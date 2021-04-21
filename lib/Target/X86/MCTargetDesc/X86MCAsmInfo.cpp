//===-- X86MCAsmInfo.cpp - X86 asm properties -----------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file contains the declarations of the X86MCAsmInfo properties.
//
//===----------------------------------------------------------------------===//

#include "X86MCAsmInfo.h"
#include "llvm/ADT/Triple.h"
#include "llvm/MC/MCExpr.h"
#include "llvm/MC/MCStreamer.h"
#include "llvm/Support/CommandLine.h"
using namespace llvm;

enum AsmWriterFlavorTy {
  // Note: This numbering has to match the GCC assembler dialects for inline
  // asm alternatives to work right.
  ATT = 0, Intel = 1
};

static cl::opt<AsmWriterFlavorTy> AsmWriterFlavor(
    "x86-asm-syntax", cl::init(ATT), cl::Hidden,
    cl::desc("Choose style of code to emit from X86 backend:"),
    cl::values(clEnumValN(ATT, "att", "Emit AT&T-style assembly"),
               clEnumValN(Intel, "intel", "Emit Intel-style assembly")));

static cl::opt<bool>
MarkedJTDataRegions("mark-data-regions", cl::init(true),
  cl::desc("Mark code section jump table data regions."),
  cl::Hidden);

void X86MCAsmInfoDarwin::anchor() { }

X86MCAsmInfoDarwin::X86MCAsmInfoDarwin(const Triple &T) {
  bool is64Bit = T.getArch() == Triple::x86_64;
  if (is64Bit)
    CodePointerSize = CalleeSaveStackSlotSize = 8;

  AssemblerDialect = AsmWriterFlavor;

  TextAlignFillValue = 0x90;

  if (!is64Bit)
    Data64bitsDirective = nullptr;       // we can't emit a 64-bit unit

  // Use ## as a comment string so that .s files generated by llvm can go
  // through the GCC preprocessor without causing an error.  This is needed
  // because "clang foo.s" runs the C preprocessor, which is usually reserved
  // for .S files on other systems.  Perhaps this is because the file system
  // wasn't always case preserving or something.
  CommentString = "##";

  SupportsDebugInformation = true;
  UseDataRegionDirectives = MarkedJTDataRegions;

  // Exceptions handling
  ExceptionsType = ExceptionHandling::DwarfCFI;

  // old assembler lacks some directives
  // FIXME: this should really be a check on the assembler characteristics
  // rather than OS version
  if (T.isMacOSX() && T.isMacOSXVersionLT(10, 6))
    HasWeakDefCanBeHiddenDirective = false;

  // Assume ld64 is new enough that the abs-ified FDE relocs may be used
  // (actually, must, since otherwise the non-extern relocations we produce
  // overwhelm ld64's tiny little mind and it fails).
  DwarfFDESymbolsUseAbsDiff = true;
}

X86_64MCAsmInfoDarwin::X86_64MCAsmInfoDarwin(const Triple &Triple)
  : X86MCAsmInfoDarwin(Triple) {
}

void X86ELFMCAsmInfo::anchor() { }

X86ELFMCAsmInfo::X86ELFMCAsmInfo(const Triple &T) {
  bool is64Bit = T.getArch() == Triple::x86_64;
  bool isX32 = T.getEnvironment() == Triple::GNUX32;

  // For ELF, x86-64 pointer size depends on the ABI.
  // For x86-64 without the x32 ABI, pointer size is 8. For x86 and for x86-64
  // with the x32 ABI, pointer size remains the default 4.
  CodePointerSize = (is64Bit && !isX32) ? 8 : 4;

  // OTOH, stack slot size is always 8 for x86-64, even with the x32 ABI.
  CalleeSaveStackSlotSize = is64Bit ? 8 : 4;

  AssemblerDialect = AsmWriterFlavor;

  TextAlignFillValue = 0x90;

  // Debug Information
  SupportsDebugInformation = true;

  // Exceptions handling
  ExceptionsType = ExceptionHandling::DwarfCFI;
}

const MCExpr *
X86_64MCAsmInfoDarwin::getExprForPersonalitySymbol(const MCSymbol *Sym,
                                                   unsigned Encoding,
                                                   MCStreamer &Streamer) const {
  MCContext &Context = Streamer.getContext();
  const MCExpr *Res =
    MCSymbolRefExpr::create(Sym, MCSymbolRefExpr::VK_GOTPCREL, Context);
  const MCExpr *Four = MCConstantExpr::create(4, Context);
  return MCBinaryExpr::createAdd(Res, Four, Context);
}

void X86MCAsmInfoMicrosoft::anchor() { }

X86MCAsmInfoMicrosoft::X86MCAsmInfoMicrosoft(const Triple &Triple) {
  if (Triple.getArch() == Triple::x86_64) {
    PrivateGlobalPrefix = ".L";
    PrivateLabelPrefix = ".L";
    CodePointerSize = 8;
    WinEHEncodingType = WinEH::EncodingType::Itanium;
  } else {
    // 32-bit X86 doesn't use CFI, so this isn't a real encoding type. It's just
    // a place holder that the Windows EHStreamer looks for to suppress CFI
    // output. In particular, usesWindowsCFI() returns false.
    WinEHEncodingType = WinEH::EncodingType::X86;
  }

  ExceptionsType = ExceptionHandling::WinEH;

  AssemblerDialect = AsmWriterFlavor;

  TextAlignFillValue = 0x90;

  AllowAtInName = true;
}

void X86MCAsmInfoMicrosoftMASM::anchor() { }

X86MCAsmInfoMicrosoftMASM::X86MCAsmInfoMicrosoftMASM(const Triple &Triple)
    : X86MCAsmInfoMicrosoft(Triple) {
  DollarIsPC = true;
  SeparatorString = "\n";
  CommentString = ";";
  AllowQuestionAtStartOfIdentifier = true;
  AllowDollarAtStartOfIdentifier = true;
  AllowAtAtStartOfIdentifier = true;
}

void X86MCAsmInfoGNUCOFF::anchor() { }

X86MCAsmInfoGNUCOFF::X86MCAsmInfoGNUCOFF(const Triple &Triple) {
  assert(Triple.isOSWindows() && "Windows is the only supported COFF target");
  if (Triple.getArch() == Triple::x86_64) {
    PrivateGlobalPrefix = ".L";
    PrivateLabelPrefix = ".L";
    CodePointerSize = 8;
    WinEHEncodingType = WinEH::EncodingType::Itanium;
    ExceptionsType = ExceptionHandling::WinEH;
  } else {
    ExceptionsType = ExceptionHandling::DwarfCFI;
  }

  AssemblerDialect = AsmWriterFlavor;

  TextAlignFillValue = 0x90;

  AllowAtInName = true;
}
