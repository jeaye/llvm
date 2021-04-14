//===-- llvm-symbolizer.cpp - Simple addr2line-like symbolizer ------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This utility works much like "addr2line". It is able of transforming
// tuples (module name, module offset) to code locations (function name,
// file, line number, column number). It is targeted for compiler-rt tools
// (especially AddressSanitizer and ThreadSanitizer) that can use it
// to symbolize stack traces in their error reports.
//
//===----------------------------------------------------------------------===//

#include "Opts.inc"
#include "llvm/ADT/StringRef.h"
#include "llvm/Config/config.h"
#include "llvm/DebugInfo/Symbolize/DIPrinter.h"
#include "llvm/DebugInfo/Symbolize/Symbolize.h"
#include "llvm/Option/Arg.h"
#include "llvm/Option/ArgList.h"
#include "llvm/Option/Option.h"
#include "llvm/Support/COM.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/InitLLVM.h"
#include "llvm/Support/Path.h"
#include "llvm/Support/StringSaver.h"
#include "llvm/Support/raw_ostream.h"
#include <algorithm>
#include <cstdio>
#include <cstring>
#include <string>

using namespace llvm;
using namespace symbolize;

namespace {
enum ID {
  OPT_INVALID = 0, // This is not an option ID.
#define OPTION(PREFIX, NAME, ID, KIND, GROUP, ALIAS, ALIASARGS, FLAGS, PARAM,  \
               HELPTEXT, METAVAR, VALUES)                                      \
  OPT_##ID,
#include "Opts.inc"
#undef OPTION
};

#define PREFIX(NAME, VALUE) const char *const NAME[] = VALUE;
#include "Opts.inc"
#undef PREFIX

static const opt::OptTable::Info InfoTable[] = {
#define OPTION(PREFIX, NAME, ID, KIND, GROUP, ALIAS, ALIASARGS, FLAGS, PARAM,  \
               HELPTEXT, METAVAR, VALUES)                                      \
  {                                                                            \
      PREFIX,      NAME,      HELPTEXT,                                        \
      METAVAR,     OPT_##ID,  opt::Option::KIND##Class,                        \
      PARAM,       FLAGS,     OPT_##GROUP,                                     \
      OPT_##ALIAS, ALIASARGS, VALUES},
#include "Opts.inc"
#undef OPTION
};

class SymbolizerOptTable : public opt::OptTable {
public:
  SymbolizerOptTable() : OptTable(InfoTable, true) {}
};
} // namespace

template <typename T>
static void print(const Request &Request, Expected<T> &ResOrErr,
                  DIPrinter &Printer) {
  if (ResOrErr) {
    // No error, print the result.
    Printer.print(Request, *ResOrErr);
    return;
  }

  // Handle the error.
  bool PrintEmpty = true;
  handleAllErrors(std::move(ResOrErr.takeError()),
                  [&](const ErrorInfoBase &EI) {
                    PrintEmpty = Printer.printError(
                        Request, EI, "LLVMSymbolizer: error reading file: ");
                  });

  if (PrintEmpty)
    Printer.print(Request, T());
}

enum class OutputStyle { LLVM, GNU };

enum class Command {
  Code,
  Data,
  Frame,
};

static bool parseCommand(StringRef BinaryName, bool IsAddr2Line,
                         StringRef InputString, Command &Cmd,
                         std::string &ModuleName, uint64_t &ModuleOffset) {
  const char kDelimiters[] = " \n\r";
  ModuleName = "";
  if (InputString.consume_front("CODE ")) {
    Cmd = Command::Code;
  } else if (InputString.consume_front("DATA ")) {
    Cmd = Command::Data;
  } else if (InputString.consume_front("FRAME ")) {
    Cmd = Command::Frame;
  } else {
    // If no cmd, assume it's CODE.
    Cmd = Command::Code;
  }
  const char *Pos = InputString.data();
  // Skip delimiters and parse input filename (if needed).
  if (BinaryName.empty()) {
    Pos += strspn(Pos, kDelimiters);
    if (*Pos == '"' || *Pos == '\'') {
      char Quote = *Pos;
      Pos++;
      const char *End = strchr(Pos, Quote);
      if (!End)
        return false;
      ModuleName = std::string(Pos, End - Pos);
      Pos = End + 1;
    } else {
      int NameLength = strcspn(Pos, kDelimiters);
      ModuleName = std::string(Pos, NameLength);
      Pos += NameLength;
    }
  } else {
    ModuleName = BinaryName.str();
  }
  // Skip delimiters and parse module offset.
  Pos += strspn(Pos, kDelimiters);
  int OffsetLength = strcspn(Pos, kDelimiters);
  StringRef Offset(Pos, OffsetLength);
  // GNU addr2line assumes the offset is hexadecimal and allows a redundant
  // "0x" or "0X" prefix; do the same for compatibility.
  if (IsAddr2Line)
    Offset.consume_front("0x") || Offset.consume_front("0X");
  return !Offset.getAsInteger(IsAddr2Line ? 16 : 0, ModuleOffset);
}

static void symbolizeInput(const opt::InputArgList &Args, uint64_t AdjustVMA,
                           bool IsAddr2Line, OutputStyle Style,
                           StringRef InputString, LLVMSymbolizer &Symbolizer,
                           DIPrinter &Printer) {
  Command Cmd;
  std::string ModuleName;
  uint64_t Offset = 0;
  if (!parseCommand(Args.getLastArgValue(OPT_obj_EQ), IsAddr2Line,
                    StringRef(InputString), Cmd, ModuleName, Offset)) {
    Printer.printInvalidCommand(
        {ModuleName, Offset},
        StringError(InputString,
                    std::make_error_code(std::errc::invalid_argument)));
    return;
  }

  uint64_t AdjustedOffset = Offset - AdjustVMA;
  if (Cmd == Command::Data) {
    Expected<DIGlobal> ResOrErr = Symbolizer.symbolizeData(
        ModuleName, {AdjustedOffset, object::SectionedAddress::UndefSection});
    print({ModuleName, Offset}, ResOrErr, Printer);
  } else if (Cmd == Command::Frame) {
    Expected<std::vector<DILocal>> ResOrErr = Symbolizer.symbolizeFrame(
        ModuleName, {AdjustedOffset, object::SectionedAddress::UndefSection});
    print({ModuleName, Offset}, ResOrErr, Printer);
  } else if (Args.hasFlag(OPT_inlines, OPT_no_inlines, !IsAddr2Line)) {
    Expected<DIInliningInfo> ResOrErr = Symbolizer.symbolizeInlinedCode(
        ModuleName, {AdjustedOffset, object::SectionedAddress::UndefSection});
    print({ModuleName, Offset}, ResOrErr, Printer);
  } else if (Style == OutputStyle::GNU) {
    // With PrintFunctions == FunctionNameKind::LinkageName (default)
    // and UseSymbolTable == true (also default), Symbolizer.symbolizeCode()
    // may override the name of an inlined function with the name of the topmost
    // caller function in the inlining chain. This contradicts the existing
    // behavior of addr2line. Symbolizer.symbolizeInlinedCode() overrides only
    // the topmost function, which suits our needs better.
    Expected<DIInliningInfo> ResOrErr = Symbolizer.symbolizeInlinedCode(
        ModuleName, {AdjustedOffset, object::SectionedAddress::UndefSection});
    Expected<DILineInfo> Res0OrErr =
        !ResOrErr
            ? Expected<DILineInfo>(ResOrErr.takeError())
            : ((ResOrErr->getNumberOfFrames() == 0) ? DILineInfo()
                                                    : ResOrErr->getFrame(0));
    print({ModuleName, Offset}, Res0OrErr, Printer);
  } else {
    Expected<DILineInfo> ResOrErr = Symbolizer.symbolizeCode(
        ModuleName, {AdjustedOffset, object::SectionedAddress::UndefSection});
    print({ModuleName, Offset}, ResOrErr, Printer);
  }
}

static void printHelp(StringRef ToolName, const SymbolizerOptTable &Tbl,
                      raw_ostream &OS) {
  const char HelpText[] = " [options] addresses...";
  Tbl.PrintHelp(OS, (ToolName + HelpText).str().c_str(),
                ToolName.str().c_str());
  // TODO Replace this with OptTable API once it adds extrahelp support.
  OS << "\nPass @FILE as argument to read options from FILE.\n";
}

static opt::InputArgList parseOptions(int Argc, char *Argv[], bool IsAddr2Line,
                                      StringSaver &Saver,
                                      SymbolizerOptTable &Tbl) {
  StringRef ToolName = IsAddr2Line ? "llvm-addr2line" : "llvm-symbolizer";
  Tbl.setGroupedShortOptions(true);
  // The environment variable specifies initial options which can be overridden
  // by commnad line options.
  Tbl.setInitialOptionsFromEnvironment(IsAddr2Line ? "LLVM_ADDR2LINE_OPTS"
                                                   : "LLVM_SYMBOLIZER_OPTS");
  bool HasError = false;
  opt::InputArgList Args =
      Tbl.parseArgs(Argc, Argv, OPT_UNKNOWN, Saver, [&](StringRef Msg) {
        errs() << ("error: " + Msg + "\n");
        HasError = true;
      });
  if (HasError)
    exit(1);
  if (Args.hasArg(OPT_help)) {
    printHelp(ToolName, Tbl, outs());
    exit(0);
  }
  if (Args.hasArg(OPT_version)) {
    outs() << ToolName << '\n';
    cl::PrintVersionMessage();
    exit(0);
  }

  return Args;
}

template <typename T>
static void parseIntArg(const opt::InputArgList &Args, int ID, T &Value) {
  if (const opt::Arg *A = Args.getLastArg(ID)) {
    StringRef V(A->getValue());
    if (!llvm::to_integer(V, Value, 0)) {
      errs() << A->getSpelling() +
                    ": expected a non-negative integer, but got '" + V + "'";
      exit(1);
    }
  } else {
    Value = 0;
  }
}

static FunctionNameKind decideHowToPrintFunctions(const opt::InputArgList &Args,
                                                  bool IsAddr2Line) {
  if (Args.hasArg(OPT_functions))
    return FunctionNameKind::LinkageName;
  if (const opt::Arg *A = Args.getLastArg(OPT_functions_EQ))
    return StringSwitch<FunctionNameKind>(A->getValue())
        .Case("none", FunctionNameKind::None)
        .Case("short", FunctionNameKind::ShortName)
        .Default(FunctionNameKind::LinkageName);
  return IsAddr2Line ? FunctionNameKind::None : FunctionNameKind::LinkageName;
}

int main(int argc, char **argv) {
  InitLLVM X(argc, argv);
  sys::InitializeCOMRAII COM(sys::COMThreadingMode::MultiThreaded);

  bool IsAddr2Line = sys::path::stem(argv[0]).contains("addr2line");
  BumpPtrAllocator A;
  StringSaver Saver(A);
  SymbolizerOptTable Tbl;
  opt::InputArgList Args = parseOptions(argc, argv, IsAddr2Line, Saver, Tbl);

  LLVMSymbolizer::Options Opts;
  uint64_t AdjustVMA;
  PrinterConfig Config;
  parseIntArg(Args, OPT_adjust_vma_EQ, AdjustVMA);
  if (const opt::Arg *A = Args.getLastArg(OPT_basenames, OPT_relativenames)) {
    Opts.PathStyle =
        A->getOption().matches(OPT_basenames)
            ? DILineInfoSpecifier::FileLineInfoKind::BaseNameOnly
            : DILineInfoSpecifier::FileLineInfoKind::RelativeFilePath;
  } else {
    Opts.PathStyle = DILineInfoSpecifier::FileLineInfoKind::AbsoluteFilePath;
  }
  Opts.DebugFileDirectory = Args.getAllArgValues(OPT_debug_file_directory_EQ);
  Opts.DefaultArch = Args.getLastArgValue(OPT_default_arch_EQ).str();
  Opts.Demangle = Args.hasFlag(OPT_demangle, OPT_no_demangle, !IsAddr2Line);
  Opts.DWPName = Args.getLastArgValue(OPT_dwp_EQ).str();
  Opts.FallbackDebugPath =
      Args.getLastArgValue(OPT_fallback_debug_path_EQ).str();
  Opts.PrintFunctions = decideHowToPrintFunctions(Args, IsAddr2Line);
  parseIntArg(Args, OPT_print_source_context_lines_EQ,
              Config.SourceContextLines);
  Opts.RelativeAddresses = Args.hasArg(OPT_relative_address);
  Opts.UntagAddresses =
      Args.hasFlag(OPT_untag_addresses, OPT_no_untag_addresses, !IsAddr2Line);
  Opts.UseDIA = Args.hasArg(OPT_use_dia);
#if !defined(LLVM_ENABLE_DIA_SDK)
  if (Opts.UseDIA) {
    WithColor::warning() << "DIA not available; using native PDB reader\n";
    Opts.UseDIA = false;
  }
#endif
  Opts.UseSymbolTable = true;
  Config.PrintAddress = Args.hasArg(OPT_addresses);
  Config.PrintFunctions = Opts.PrintFunctions != FunctionNameKind::None;
  Config.Pretty = Args.hasArg(OPT_pretty_print);
  Config.Verbose = Args.hasArg(OPT_verbose);

  for (const opt::Arg *A : Args.filtered(OPT_dsym_hint_EQ)) {
    StringRef Hint(A->getValue());
    if (sys::path::extension(Hint) == ".dSYM") {
      Opts.DsymHints.emplace_back(Hint);
    } else {
      errs() << "Warning: invalid dSYM hint: \"" << Hint
             << "\" (must have the '.dSYM' extension).\n";
    }
  }

  auto Style = IsAddr2Line ? OutputStyle::GNU : OutputStyle::LLVM;
  if (const opt::Arg *A = Args.getLastArg(OPT_output_style_EQ)) {
    Style = strcmp(A->getValue(), "GNU") == 0 ? OutputStyle::GNU
                                              : OutputStyle::LLVM;
  }

  LLVMSymbolizer Symbolizer(Opts);
  std::unique_ptr<DIPrinter> Printer;
  if (Style == OutputStyle::GNU)
    Printer = std::make_unique<GNUPrinter>(outs(), errs(), Config);
  else
    Printer = std::make_unique<LLVMPrinter>(outs(), errs(), Config);

  std::vector<std::string> InputAddresses = Args.getAllArgValues(OPT_INPUT);
  if (InputAddresses.empty()) {
    const int kMaxInputStringLength = 1024;
    char InputString[kMaxInputStringLength];

    while (fgets(InputString, sizeof(InputString), stdin)) {
      // Strip newline characters.
      std::string StrippedInputString(InputString);
      llvm::erase_if(StrippedInputString,
                     [](char c) { return c == '\r' || c == '\n'; });
      symbolizeInput(Args, AdjustVMA, IsAddr2Line, Style, StrippedInputString,
                     Symbolizer, *Printer);
      outs().flush();
    }
  } else {
    for (StringRef Address : InputAddresses)
      symbolizeInput(Args, AdjustVMA, IsAddr2Line, Style, Address, Symbolizer,
                     *Printer);
  }

  return 0;
}
