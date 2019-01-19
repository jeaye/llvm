//===- AVRInstPrinter.h - Convert AVR MCInst to assembly syntax -*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This class prints an AVR MCInst to a .s file.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_AVR_INST_PRINTER_H
#define LLVM_AVR_INST_PRINTER_H

#include "llvm/MC/MCInstPrinter.h"

#include "MCTargetDesc/AVRMCTargetDesc.h"

namespace llvm {

/// Prints AVR instructions to a textual stream.
class AVRInstPrinter : public MCInstPrinter {
public:
  AVRInstPrinter(const MCAsmInfo &MAI, const MCInstrInfo &MII,
                 const MCRegisterInfo &MRI)
      : MCInstPrinter(MAI, MII, MRI) {}

  static const char *getPrettyRegisterName(unsigned RegNo,
                                           MCRegisterInfo const &MRI);

  void printInst(const MCInst *MI, raw_ostream &O, StringRef Annot,
                 const MCSubtargetInfo &STI) override;

private:
  static const char *getRegisterName(unsigned RegNo,
                                     unsigned AltIdx = AVR::NoRegAltName);

  void printOperand(const MCInst *MI, unsigned OpNo, raw_ostream &O);
  void printPCRelImm(const MCInst *MI, unsigned OpNo, raw_ostream &O);
  void printMemri(const MCInst *MI, unsigned OpNo, raw_ostream &O);

  // Autogenerated by TableGen.
  void printInstruction(const MCInst *MI, raw_ostream &O);
  bool printAliasInstr(const MCInst *MI, raw_ostream &O);
  void printCustomAliasOperand(const MCInst *MI, unsigned OpIdx,
                               unsigned PrintMethodIdx, raw_ostream &O);
};

} // end namespace llvm

#endif // LLVM_AVR_INST_PRINTER_H

