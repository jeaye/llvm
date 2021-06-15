//=- WebAssemblyMCCodeEmitter.cpp - Convert WebAssembly code to machine code -//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
///
/// \file
/// This file implements the WebAssemblyMCCodeEmitter class.
///
//===----------------------------------------------------------------------===//

#include "MCTargetDesc/WebAssemblyFixupKinds.h"
#include "MCTargetDesc/WebAssemblyMCTargetDesc.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/Statistic.h"
#include "llvm/MC/MCCodeEmitter.h"
#include "llvm/MC/MCFixup.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCInstrInfo.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/MC/MCSymbol.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/EndianStream.h"
#include "llvm/Support/LEB128.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

#define DEBUG_TYPE "mccodeemitter"

STATISTIC(MCNumEmitted, "Number of MC instructions emitted.");
STATISTIC(MCNumFixups, "Number of MC fixups created.");

namespace {
class WebAssemblyMCCodeEmitter final : public MCCodeEmitter {
  const MCInstrInfo &MCII;

  // Implementation generated by tablegen.
  uint64_t getBinaryCodeForInstr(const MCInst &MI,
                                 SmallVectorImpl<MCFixup> &Fixups,
                                 const MCSubtargetInfo &STI) const;

  void encodeInstruction(const MCInst &MI, raw_ostream &OS,
                         SmallVectorImpl<MCFixup> &Fixups,
                         const MCSubtargetInfo &STI) const override;

public:
  WebAssemblyMCCodeEmitter(const MCInstrInfo &MCII) : MCII(MCII) {}
};
} // end anonymous namespace

MCCodeEmitter *llvm::createWebAssemblyMCCodeEmitter(const MCInstrInfo &MCII) {
  return new WebAssemblyMCCodeEmitter(MCII);
}

void WebAssemblyMCCodeEmitter::encodeInstruction(
    const MCInst &MI, raw_ostream &OS, SmallVectorImpl<MCFixup> &Fixups,
    const MCSubtargetInfo &STI) const {
  uint64_t Start = OS.tell();

  uint64_t Binary = getBinaryCodeForInstr(MI, Fixups, STI);
  if (Binary < (1 << 8)) {
    OS << uint8_t(Binary);
  } else if (Binary < (1 << 16)) {
    OS << uint8_t(Binary >> 8);
    encodeULEB128(uint8_t(Binary), OS);
  } else if (Binary < (1 << 24)) {
    OS << uint8_t(Binary >> 16);
    encodeULEB128(uint16_t(Binary), OS);
  } else {
    llvm_unreachable("Very large (prefix + 3 byte) opcodes not supported");
  }

  // For br_table instructions, encode the size of the table. In the MCInst,
  // there's an index operand (if not a stack instruction), one operand for
  // each table entry, and the default operand.
  if (MI.getOpcode() == WebAssembly::BR_TABLE_I32_S ||
      MI.getOpcode() == WebAssembly::BR_TABLE_I64_S)
    encodeULEB128(MI.getNumOperands() - 1, OS);
  if (MI.getOpcode() == WebAssembly::BR_TABLE_I32 ||
      MI.getOpcode() == WebAssembly::BR_TABLE_I64)
    encodeULEB128(MI.getNumOperands() - 2, OS);

  const MCInstrDesc &Desc = MCII.get(MI.getOpcode());
  for (unsigned I = 0, E = MI.getNumOperands(); I < E; ++I) {
    const MCOperand &MO = MI.getOperand(I);
    if (MO.isReg()) {
      /* nothing to encode */

    } else if (MO.isImm()) {
      if (I < Desc.getNumOperands()) {
        const MCOperandInfo &Info = Desc.OpInfo[I];
        LLVM_DEBUG(dbgs() << "Encoding immediate: type="
                          << int(Info.OperandType) << "\n");
        switch (Info.OperandType) {
        case WebAssembly::OPERAND_I32IMM:
          encodeSLEB128(int32_t(MO.getImm()), OS);
          break;
        case WebAssembly::OPERAND_OFFSET32:
          encodeULEB128(uint32_t(MO.getImm()), OS);
          break;
        case WebAssembly::OPERAND_I64IMM:
          encodeSLEB128(int64_t(MO.getImm()), OS);
          break;
        case WebAssembly::OPERAND_SIGNATURE:
        case WebAssembly::OPERAND_HEAPTYPE:
          OS << uint8_t(MO.getImm());
          break;
        case WebAssembly::OPERAND_VEC_I8IMM:
          support::endian::write<uint8_t>(OS, MO.getImm(), support::little);
          break;
        case WebAssembly::OPERAND_VEC_I16IMM:
          support::endian::write<uint16_t>(OS, MO.getImm(), support::little);
          break;
        case WebAssembly::OPERAND_VEC_I32IMM:
          support::endian::write<uint32_t>(OS, MO.getImm(), support::little);
          break;
        case WebAssembly::OPERAND_VEC_I64IMM:
          support::endian::write<uint64_t>(OS, MO.getImm(), support::little);
          break;
        case WebAssembly::OPERAND_GLOBAL:
          llvm_unreachable("wasm globals should only be accessed symbolicly");
        default:
          encodeULEB128(uint64_t(MO.getImm()), OS);
        }
      } else {
        encodeULEB128(uint64_t(MO.getImm()), OS);
      }

    } else if (MO.isSFPImm()) {
      uint32_t F = MO.getSFPImm();
      support::endian::write<uint32_t>(OS, F, support::little);
    } else if (MO.isDFPImm()) {
      uint64_t D = MO.getDFPImm();
      support::endian::write<uint64_t>(OS, D, support::little);
    } else if (MO.isExpr()) {
      const MCOperandInfo &Info = Desc.OpInfo[I];
      llvm::MCFixupKind FixupKind;
      size_t PaddedSize = 5;
      switch (Info.OperandType) {
      case WebAssembly::OPERAND_I32IMM:
        FixupKind = MCFixupKind(WebAssembly::fixup_sleb128_i32);
        break;
      case WebAssembly::OPERAND_I64IMM:
        FixupKind = MCFixupKind(WebAssembly::fixup_sleb128_i64);
        PaddedSize = 10;
        break;
      case WebAssembly::OPERAND_FUNCTION32:
      case WebAssembly::OPERAND_TABLE:
      case WebAssembly::OPERAND_OFFSET32:
      case WebAssembly::OPERAND_SIGNATURE:
      case WebAssembly::OPERAND_TYPEINDEX:
      case WebAssembly::OPERAND_GLOBAL:
      case WebAssembly::OPERAND_TAG:
        FixupKind = MCFixupKind(WebAssembly::fixup_uleb128_i32);
        break;
      case WebAssembly::OPERAND_OFFSET64:
        FixupKind = MCFixupKind(WebAssembly::fixup_uleb128_i64);
        PaddedSize = 10;
        break;
      default:
        llvm_unreachable("unexpected symbolic operand kind");
      }
      Fixups.push_back(MCFixup::create(OS.tell() - Start, MO.getExpr(),
                                       FixupKind, MI.getLoc()));
      ++MCNumFixups;
      encodeULEB128(0, OS, PaddedSize);
    } else {
      llvm_unreachable("unexpected operand kind");
    }
  }

  ++MCNumEmitted; // Keep track of the # of mi's emitted.
}

#include "WebAssemblyGenMCCodeEmitter.inc"
