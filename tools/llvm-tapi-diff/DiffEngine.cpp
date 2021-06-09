//===-- DiffEngine.cpp - Structural file comparison -----------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file defines the implementation of the llvm-tapi difference
// engine, which structurally compares two tbd files.
//
//===----------------------------------------------------------------------===/
#include "DiffEngine.h"
#include "llvm/Support/Casting.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/TextAPI/InterfaceFile.h"
#include "llvm/TextAPI/Target.h"

using namespace llvm;
using namespace MachO;
using namespace object;

StringRef setOrderIndicator(InterfaceInputOrder Order) {
  return ((Order == lhs) ? "< " : "> ");
}

// The following template specialization implementations
// need to be explicitly placed into the llvm namespace
// to work around a GCC 4.8 bug.
namespace llvm {

template <typename T, DiffAttrKind U>
inline void DiffScalarVal<T, U>::print(raw_ostream &OS, std::string Indent) {
  OS << Indent << "\t" << setOrderIndicator(Order) << Val << "\n";
}

template <>
inline void
DiffScalarVal<StringRef, AD_Diff_Scalar_Str>::print(raw_ostream &OS,
                                                    std::string Indent) {
  OS << Indent << "\t\t" << setOrderIndicator(Order) << Val << "\n";
}

template <>
inline void
DiffScalarVal<uint8_t, AD_Diff_Scalar_Unsigned>::print(raw_ostream &OS,
                                                       std::string Indent) {
  OS << Indent << "\t" << setOrderIndicator(Order) << std::to_string(Val)
     << "\n";
}

template <>
inline void
DiffScalarVal<bool, AD_Diff_Scalar_Bool>::print(raw_ostream &OS,
                                                std::string Indent) {
  OS << Indent << "\t" << setOrderIndicator(Order)
     << ((Val == true) ? "true" : "false") << "\n";
}

} // end namespace llvm.

std::string SymScalar::stringifySymbolKind(MachO::SymbolKind Kind) {
  switch (Kind) {
  case MachO::SymbolKind::GlobalSymbol:
    return "";
  case MachO::SymbolKind::ObjectiveCClass:
    return "_OBJC_METACLASS_$_";
  case MachO::SymbolKind ::ObjectiveCClassEHType:
    return "_OBJC_EHTYPE_$_";
  case MachO::SymbolKind ::ObjectiveCInstanceVariable:
    return "_OBJC_IVAR_$_";
  }
  llvm_unreachable("Unknown llvm::MachO::SymbolKind enum");
}

std::string SymScalar::stringifySymbolFlag(MachO::SymbolFlags Flag) {
  switch (Flag) {
  case MachO::SymbolFlags::None:
    return "";
  case MachO::SymbolFlags::ThreadLocalValue:
    return "Thread-Local";
  case MachO::SymbolFlags::WeakDefined:
    return "Weak-Defined";
  case MachO::SymbolFlags::WeakReferenced:
    return "Weak-Referenced";
  case MachO::SymbolFlags::Undefined:
    return "Undefined";
  case MachO::SymbolFlags::Rexported:
    return "Reexported";
  }
  llvm_unreachable("Unknown llvm::MachO::SymbolFlags enum");
}

void SymScalar::print(raw_ostream &OS, std::string Indent, MachO::Target Targ) {
  if (Val->getKind() == MachO::SymbolKind::ObjectiveCClass) {
    if (Targ.Arch == MachO::AK_i386 &&
        Targ.Platform == MachO::PlatformKind::macOS) {
      OS << Indent << "\t\t" << ((Order == lhs) ? "< " : "> ")
         << ".objc_class_name_" << Val->getName()
         << getFlagString(Val->getFlags()) << "\n";
      return;
    }
    OS << Indent << "\t\t" << ((Order == lhs) ? "< " : "> ") << "_OBJC_CLASS_$_"
       << Val->getName() << getFlagString(Val->getFlags()) << "\n";
  }
  OS << Indent << "\t\t" << ((Order == lhs) ? "< " : "> ")
     << stringifySymbolKind(Val->getKind()) << Val->getName()
     << getFlagString(Val->getFlags()) << "\n";
}

bool checkSymbolEquality(llvm::MachO::InterfaceFile::const_symbol_range LHS,
                         llvm::MachO::InterfaceFile::const_symbol_range RHS) {
  return std::equal(LHS.begin(), LHS.end(), RHS.begin(),
                    [&](auto LHS, auto RHS) { return *LHS == *RHS; });
}

template <typename TargetVecT, typename ValTypeT, typename V>
void addDiffForTargSlice(V Val, Target Targ, DiffOutput &Diff,
                         InterfaceInputOrder Order) {
  auto TargetVector = llvm::find_if(
      Diff.Values, [&](const std::unique_ptr<AttributeDiff> &RawTVec) {
        if (TargetVecT *TVec = dyn_cast<TargetVecT>(RawTVec.get()))
          return TVec->Targ == Targ;
        return false;
      });
  if (TargetVector != Diff.Values.end()) {
    ValTypeT NewVal(Order, Val);
    cast<TargetVecT>(TargetVector->get())->TargValues.push_back(NewVal);
  } else {
    auto NewTargetVec = std::make_unique<TargetVecT>(Targ);
    ValTypeT NewVal(Order, Val);
    NewTargetVec->TargValues.push_back(NewVal);
    Diff.Values.push_back(std::move(NewTargetVec));
  }
}

DiffOutput getSingleAttrDiff(const std::vector<InterfaceFileRef> &IRefVec,
                             std::string Name, InterfaceInputOrder Order) {
  DiffOutput Diff(Name);
  Diff.Kind = AD_Str_Vec;
  for (const auto &IRef : IRefVec)
    for (auto Targ : IRef.targets())
      addDiffForTargSlice<DiffStrVec,
                          DiffScalarVal<StringRef, AD_Diff_Scalar_Str>>(
          IRef.getInstallName(), Targ, Diff, Order);
  return Diff;
}

DiffOutput
getSingleAttrDiff(const std::vector<std::pair<Target, std::string>> &PairVec,
                  std::string Name, InterfaceInputOrder Order) {
  DiffOutput Diff(Name);
  Diff.Kind = AD_Str_Vec;
  for (const auto &Pair : PairVec)
    addDiffForTargSlice<DiffStrVec,
                        DiffScalarVal<StringRef, AD_Diff_Scalar_Str>>(
        StringRef(Pair.second), Pair.first, Diff, Order);
  return Diff;
}

DiffOutput getSingleAttrDiff(InterfaceFile::const_symbol_range SymRange,
                             std::string Name, InterfaceInputOrder Order) {
  DiffOutput Diff(Name);
  Diff.Kind = AD_Sym_Vec;
  for (const auto *Sym : SymRange)
    for (auto Targ : Sym->targets())
      addDiffForTargSlice<DiffSymVec, SymScalar>(Sym, Targ, Diff, Order);
  return Diff;
}

template <typename T>
DiffOutput getSingleAttrDiff(T SingleAttr, std::string Attribute) {
  DiffOutput Diff(Attribute);
  Diff.Kind = SingleAttr.getKind();
  Diff.Values.push_back(std::make_unique<T>(SingleAttr));
  return Diff;
}

template <typename T, DiffAttrKind U>
void diffAttribute(std::string Name, std::vector<DiffOutput> &Output,
                   DiffScalarVal<T, U> Attr) {
  Output.push_back(getSingleAttrDiff(Attr, Name));
}

template <typename T>
void diffAttribute(std::string Name, std::vector<DiffOutput> &Output,
                   const T &Val, InterfaceInputOrder Order) {
  Output.push_back(getSingleAttrDiff(Val, Name, Order));
}

std::vector<DiffOutput> getSingleIF(InterfaceFile *Interface,
                                    InterfaceInputOrder Order) {
  std::vector<DiffOutput> Output;
  diffAttribute("Install Name", Output,
                DiffScalarVal<StringRef, AD_Diff_Scalar_Str>(
                    Order, Interface->getInstallName()));
  diffAttribute("Current Version", Output,
                DiffScalarVal<PackedVersion, AD_Diff_Scalar_PackedVersion>(
                    Order, Interface->getCurrentVersion()));
  diffAttribute("Compatibility Version", Output,
                DiffScalarVal<PackedVersion, AD_Diff_Scalar_PackedVersion>(
                    Order, Interface->getCompatibilityVersion()));
  diffAttribute("Swift ABI Version", Output,
                DiffScalarVal<uint8_t, AD_Diff_Scalar_Unsigned>(
                    Order, Interface->getSwiftABIVersion()));
  diffAttribute("InstallAPI", Output,
                DiffScalarVal<bool, AD_Diff_Scalar_Bool>(
                    Order, Interface->isInstallAPI()));
  diffAttribute("Two Level Namespace", Output,
                DiffScalarVal<bool, AD_Diff_Scalar_Bool>(
                    Order, Interface->isTwoLevelNamespace()));
  diffAttribute("Application Extension Safe", Output,
                DiffScalarVal<bool, AD_Diff_Scalar_Bool>(
                    Order, Interface->isApplicationExtensionSafe()));
  diffAttribute("Reexported Libraries", Output,
                Interface->reexportedLibraries(), Order);
  diffAttribute("Allowable Clients", Output, Interface->allowableClients(),
                Order);
  diffAttribute("Parent Umbrellas", Output, Interface->umbrellas(), Order);
  diffAttribute("Symbols", Output, Interface->symbols(), Order);
  for (auto Doc : Interface->documents()) {
    DiffOutput Documents("Inlined Reexported Frameworks/Libraries");
    Documents.Kind = AD_Inline_Doc;
    Documents.Values.push_back(std::make_unique<InlineDoc>(
        InlineDoc(Doc->getInstallName(), getSingleIF(Doc.get(), Order))));
    Output.push_back(std::move(Documents));
  }
  return Output;
}

void findAndAddDiff(const std::vector<InterfaceFileRef> &CollectedIRefVec,
                    const std::vector<InterfaceFileRef> &LookupIRefVec,
                    DiffOutput &Result, InterfaceInputOrder Order) {
  Result.Kind = AD_Str_Vec;
  for (const auto &IRef : CollectedIRefVec)
    for (auto Targ : IRef.targets()) {
      auto FoundIRef = llvm::find_if(LookupIRefVec, [&](const auto LIRef) {
        auto FoundTarg = llvm::find(LIRef.targets(), Targ);
        return (FoundTarg != LIRef.targets().end() &&
                IRef.getInstallName() == LIRef.getInstallName());
      });
      if (FoundIRef == LookupIRefVec.end())
        addDiffForTargSlice<DiffStrVec,
                            DiffScalarVal<StringRef, AD_Diff_Scalar_Str>>(
            IRef.getInstallName(), Targ, Result, Order);
    }
}

void findAndAddDiff(
    const std::vector<std::pair<Target, std::string>> &CollectedPairs,
    const std::vector<std::pair<Target, std::string>> &LookupPairs,
    DiffOutput &Result, InterfaceInputOrder Order) {
  Result.Kind = AD_Str_Vec;
  for (const auto &Pair : CollectedPairs) {
    auto FoundPair = llvm::find(LookupPairs, Pair);
    if (FoundPair == LookupPairs.end())
      addDiffForTargSlice<DiffStrVec,
                          DiffScalarVal<StringRef, AD_Diff_Scalar_Str>>(
          StringRef(Pair.second), Pair.first, Result, Order);
  }
}

void findAndAddDiff(InterfaceFile::const_symbol_range CollectedSyms,
                    InterfaceFile::const_symbol_range LookupSyms,
                    DiffOutput &Result, InterfaceInputOrder Order) {
  Result.Kind = AD_Sym_Vec;
  for (const auto *Sym : CollectedSyms)
    for (const auto Targ : Sym->targets()) {
      auto FoundSym = llvm::find_if(LookupSyms, [&](const auto LSym) {
        auto FoundTarg = llvm::find(LSym->targets(), Targ);
        return (Sym->getName() == LSym->getName() &&
                Sym->getKind() == LSym->getKind() &&
                Sym->getFlags() == LSym->getFlags() &&
                FoundTarg != LSym->targets().end());
      });
      if (FoundSym == LookupSyms.end())
        addDiffForTargSlice<DiffSymVec, SymScalar>(Sym, Targ, Result, Order);
    }
}

template <typename T>
DiffOutput recordDifferences(T LHS, T RHS, std::string Attr) {
  DiffOutput Diff(Attr);
  if (LHS.getKind() == RHS.getKind()) {
    Diff.Kind = LHS.getKind();
    Diff.Values.push_back(std::make_unique<T>(LHS));
    Diff.Values.push_back(std::make_unique<T>(RHS));
  }
  return Diff;
}

template <typename T>
DiffOutput recordDifferences(const std::vector<T> &LHS,
                             const std::vector<T> &RHS, std::string Attr) {
  DiffOutput Diff(Attr);
  Diff.Kind = AD_Str_Vec;
  findAndAddDiff(LHS, RHS, Diff, lhs);
  findAndAddDiff(RHS, LHS, Diff, rhs);
  return Diff;
}

DiffOutput recordDifferences(llvm::MachO::InterfaceFile::const_symbol_range LHS,
                             llvm::MachO::InterfaceFile::const_symbol_range RHS,
                             std::string Attr) {
  DiffOutput Diff(Attr);
  Diff.Kind = AD_Sym_Vec;
  findAndAddDiff(LHS, RHS, Diff, lhs);
  findAndAddDiff(RHS, LHS, Diff, rhs);
  return Diff;
}

std::vector<DiffOutput>
DiffEngine::findDifferences(const InterfaceFile *IFLHS,
                            const InterfaceFile *IFRHS) {
  std::vector<DiffOutput> Output;
  if (IFLHS->getInstallName() != IFRHS->getInstallName())
    Output.push_back(recordDifferences(
        DiffScalarVal<StringRef, AD_Diff_Scalar_Str>(lhs,
                                                     IFLHS->getInstallName()),
        DiffScalarVal<StringRef, AD_Diff_Scalar_Str>(rhs,
                                                     IFRHS->getInstallName()),
        "Install Name"));

  if (IFLHS->getCurrentVersion() != IFRHS->getCurrentVersion())
    Output.push_back(recordDifferences(
        DiffScalarVal<PackedVersion, AD_Diff_Scalar_PackedVersion>(
            lhs, IFLHS->getCurrentVersion()),
        DiffScalarVal<PackedVersion, AD_Diff_Scalar_PackedVersion>(
            rhs, IFRHS->getCurrentVersion()),
        "Current Version"));
  if (IFLHS->getCompatibilityVersion() != IFRHS->getCompatibilityVersion())
    Output.push_back(recordDifferences(
        DiffScalarVal<PackedVersion, AD_Diff_Scalar_PackedVersion>(
            lhs, IFLHS->getCompatibilityVersion()),
        DiffScalarVal<PackedVersion, AD_Diff_Scalar_PackedVersion>(
            rhs, IFRHS->getCompatibilityVersion()),
        "Compatibility Version"));
  if (IFLHS->getSwiftABIVersion() != IFRHS->getSwiftABIVersion())
    Output.push_back(
        recordDifferences(DiffScalarVal<uint8_t, AD_Diff_Scalar_Unsigned>(
                              lhs, IFLHS->getSwiftABIVersion()),
                          DiffScalarVal<uint8_t, AD_Diff_Scalar_Unsigned>(
                              rhs, IFRHS->getSwiftABIVersion()),
                          "Swift ABI Version"));
  if (IFLHS->isInstallAPI() != IFRHS->isInstallAPI())
    Output.push_back(recordDifferences(
        DiffScalarVal<bool, AD_Diff_Scalar_Bool>(lhs, IFLHS->isInstallAPI()),
        DiffScalarVal<bool, AD_Diff_Scalar_Bool>(rhs, IFRHS->isInstallAPI()),
        "InstallAPI"));

  if (IFLHS->isTwoLevelNamespace() != IFRHS->isTwoLevelNamespace())
    Output.push_back(recordDifferences(DiffScalarVal<bool, AD_Diff_Scalar_Bool>(
                                           lhs, IFLHS->isTwoLevelNamespace()),
                                       DiffScalarVal<bool, AD_Diff_Scalar_Bool>(
                                           rhs, IFRHS->isTwoLevelNamespace()),
                                       "Two Level Namespace"));

  if (IFLHS->isApplicationExtensionSafe() !=
      IFRHS->isApplicationExtensionSafe())
    Output.push_back(
        recordDifferences(DiffScalarVal<bool, AD_Diff_Scalar_Bool>(
                              lhs, IFLHS->isApplicationExtensionSafe()),
                          DiffScalarVal<bool, AD_Diff_Scalar_Bool>(
                              rhs, IFRHS->isApplicationExtensionSafe()),
                          "Application Extension Safe"));

  if (IFLHS->reexportedLibraries() != IFRHS->reexportedLibraries())
    Output.push_back(recordDifferences(IFLHS->reexportedLibraries(),
                                       IFRHS->reexportedLibraries(),
                                       "Reexported Libraries"));

  if (IFLHS->allowableClients() != IFRHS->allowableClients())
    Output.push_back(recordDifferences(IFLHS->allowableClients(),
                                       IFRHS->allowableClients(),
                                       "Allowable Clients"));

  if (IFLHS->umbrellas() != IFRHS->umbrellas())
    Output.push_back(recordDifferences(IFLHS->umbrellas(), IFRHS->umbrellas(),
                                       "Parent Umbrellas"));

  if (!checkSymbolEquality(IFLHS->symbols(), IFRHS->symbols()))
    Output.push_back(
        recordDifferences(IFLHS->symbols(), IFRHS->symbols(), "Symbols"));

  if (IFLHS->documents() != IFRHS->documents()) {
    DiffOutput Docs("Inlined Reexported Frameworks/Libraries");
    Docs.Kind = AD_Inline_Doc;
    std::vector<StringRef> DocsInserted;
    // Iterate through inline frameworks/libraries from interface file and find
    // match based on install name.
    for (auto DocLHS : IFLHS->documents()) {
      auto Pair = llvm::find_if(IFRHS->documents(), [&](const auto &DocRHS) {
        return (DocLHS->getInstallName() == DocRHS->getInstallName());
      });
      // If a match found, recursively get differences between the pair.
      if (Pair != IFRHS->documents().end()) {
        InlineDoc PairDiff =
            InlineDoc(DocLHS->getInstallName(),
                      findDifferences(DocLHS.get(), Pair->get()));
        if (!PairDiff.DocValues.empty())
          Docs.Values.push_back(
              std::make_unique<InlineDoc>(std::move(PairDiff)));
      }
      // If a match is not found, get attributes from single item.
      else
        Docs.Values.push_back(std::make_unique<InlineDoc>(InlineDoc(
            DocLHS->getInstallName(), getSingleIF(DocLHS.get(), lhs))));
      DocsInserted.push_back(DocLHS->getInstallName());
    }
    for (auto DocRHS : IFRHS->documents()) {
      auto WasGathered =
          llvm::find_if(DocsInserted, [&](const auto &GatheredDoc) {
            return (GatheredDoc == DocRHS->getInstallName());
          });
      if (WasGathered == DocsInserted.end())
        Docs.Values.push_back(std::make_unique<InlineDoc>(InlineDoc(
            DocRHS->getInstallName(), getSingleIF(DocRHS.get(), rhs))));
    }
    if (!Docs.Values.empty())
      Output.push_back(std::move(Docs));
  }
  return Output;
}

template <typename T>
void printSingleVal(std::string Indent, const DiffOutput &Attr,
                    raw_ostream &OS) {
  if (Attr.Values.empty())
    return;
  OS << Indent << Attr.Name << "\n";
  for (auto &RawItem : Attr.Values)
    if (T *Item = dyn_cast<T>(RawItem.get()))
      Item->print(OS, Indent);
}

template <typename T>
T *castValues(const std::unique_ptr<AttributeDiff> &RawAttr) {
  T *CastAttr = cast<T>(RawAttr.get());
  return CastAttr;
}

template <typename T>
void printVecVal(std::string Indent, const DiffOutput &Attr, raw_ostream &OS) {
  if (Attr.Values.empty())
    return;

  OS << Indent << Attr.Name << "\n";

  std::vector<T *> SortedAttrs;

  llvm::transform(Attr.Values, std::back_inserter(SortedAttrs), castValues<T>);

  llvm::sort(SortedAttrs, [&](const auto &ValA, const auto &ValB) {
    return ValA->Targ < ValB->Targ;
  });

  for (auto *Vec : SortedAttrs) {
    llvm::sort(Vec->TargValues, [](const auto &ValA, const auto &ValB) {
      return ValA.getOrder() == ValB.getOrder() &&
             ValA.getVal() < ValB.getVal();
    });
    OS << Indent << "\t" << getTargetTripleName(Vec->Targ) << "\n";
    for (auto &Item : Vec->TargValues)
      Item.print(OS, Indent);
  }
}

template <>
void printVecVal<DiffSymVec>(std::string Indent, const DiffOutput &Attr,
                             raw_ostream &OS) {
  if (Attr.Values.empty())
    return;

  OS << Indent << Attr.Name << "\n";

  std::vector<DiffSymVec *> SortedAttrs;

  llvm::transform(Attr.Values, std::back_inserter(SortedAttrs),
                  castValues<DiffSymVec>);

  llvm::sort(SortedAttrs, [&](const auto &ValA, const auto &ValB) {
    return ValA->Targ < ValB->Targ;
  });
  for (auto *SymVec : SortedAttrs) {
    llvm::sort(SymVec->TargValues, [](const auto &ValA, const auto &ValB) {
      return ValA.getOrder() == ValB.getOrder() &&
             ValA.getVal() < ValB.getVal();
    });
    OS << Indent << "\t" << getTargetTripleName(SymVec->Targ) << "\n";
    for (auto &Item : SymVec->TargValues)
      Item.print(OS, Indent, SymVec->Targ);
  }
}

void DiffEngine::printDifferences(raw_ostream &OS,
                                  const std::vector<DiffOutput> &Diffs,
                                  int IndentCounter) {
  std::string Indent = std::string(IndentCounter, '\t');
  for (auto &Attr : Diffs) {
    switch (Attr.Kind) {
    case AD_Diff_Scalar_Str:
      if (IndentCounter == 0)
        printSingleVal<DiffScalarVal<StringRef, AD_Diff_Scalar_Str>>(Indent,
                                                                     Attr, OS);
      break;
    case AD_Diff_Scalar_PackedVersion:
      printSingleVal<
          DiffScalarVal<PackedVersion, AD_Diff_Scalar_PackedVersion>>(Indent,
                                                                      Attr, OS);
      break;
    case AD_Diff_Scalar_Unsigned:
      printSingleVal<DiffScalarVal<uint8_t, AD_Diff_Scalar_Unsigned>>(Indent,
                                                                      Attr, OS);
      break;
    case AD_Diff_Scalar_Bool:
      printSingleVal<DiffScalarVal<bool, AD_Diff_Scalar_Bool>>(Indent, Attr,
                                                               OS);
      break;
    case AD_Str_Vec:
      printVecVal<DiffStrVec>(Indent, Attr, OS);
      break;
    case AD_Sym_Vec:
      printVecVal<DiffSymVec>(Indent, Attr, OS);
      break;
    case AD_Inline_Doc:
      if (!Attr.Values.empty()) {
        OS << Indent << Attr.Name << "\n";
        for (auto &Item : Attr.Values)
          if (InlineDoc *Doc = dyn_cast<InlineDoc>(Item.get()))
            if (!Doc->DocValues.empty()) {
              OS << Indent << "\t" << Doc->InstallName << "\n";
              printDifferences(OS, std::move(Doc->DocValues), 2);
            }
      }
      break;
    }
  }
}

bool DiffEngine::compareFiles(raw_ostream &OS) {
  const auto *IFLHS = &(FileLHS->getInterfaceFile());
  const auto *IFRHS = &(FileRHS->getInterfaceFile());
  if (*IFLHS == *IFRHS)
    return false;
  OS << "< " << std::string(IFLHS->getPath().data()) << "\n> "
     << std::string(IFRHS->getPath().data()) << "\n\n";
  std::vector<DiffOutput> Diffs = findDifferences(IFLHS, IFRHS);
  printDifferences(OS, Diffs, 0);
  return true;
}
