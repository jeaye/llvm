//===---- RISCVISelDAGToDAG.h - A dag to dag inst selector for RISCV ------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file defines an instruction selector for the RISCV target.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_RISCV_RISCVISELDAGTODAG_H
#define LLVM_LIB_TARGET_RISCV_RISCVISELDAGTODAG_H

#include "RISCV.h"
#include "RISCVTargetMachine.h"
#include "llvm/CodeGen/SelectionDAGISel.h"

// RISCV-specific code to select RISCV machine instructions for
// SelectionDAG operations.
namespace llvm {
class RISCVDAGToDAGISel : public SelectionDAGISel {
  const RISCVSubtarget *Subtarget = nullptr;

public:
  explicit RISCVDAGToDAGISel(RISCVTargetMachine &TargetMachine)
      : SelectionDAGISel(TargetMachine) {}

  StringRef getPassName() const override {
    return "RISCV DAG->DAG Pattern Instruction Selection";
  }

  bool runOnMachineFunction(MachineFunction &MF) override {
    Subtarget = &MF.getSubtarget<RISCVSubtarget>();
    return SelectionDAGISel::runOnMachineFunction(MF);
  }

  void PostprocessISelDAG() override;

  void Select(SDNode *Node) override;

  bool SelectInlineAsmMemoryOperand(const SDValue &Op, unsigned ConstraintID,
                                    std::vector<SDValue> &OutOps) override;

  bool SelectAddrFI(SDValue Addr, SDValue &Base);
  bool SelectBaseAddr(SDValue Addr, SDValue &Base);

  bool selectShiftMask(SDValue N, unsigned ShiftWidth, SDValue &ShAmt);
  bool selectShiftMaskXLen(SDValue N, SDValue &ShAmt) {
    return selectShiftMask(N, Subtarget->getXLen(), ShAmt);
  }
  bool selectShiftMask32(SDValue N, SDValue &ShAmt) {
    return selectShiftMask(N, 32, ShAmt);
  }

  bool selectSExti32(SDValue N, SDValue &Val);

  bool MatchSRLIW(SDNode *N) const;
  bool MatchSLLIUW(SDNode *N) const;

  bool selectVLOp(SDValue N, SDValue &VL);

  bool selectVSplat(SDValue N, SDValue &SplatVal);
  bool selectVSplatSimm5(SDValue N, SDValue &SplatVal);
  bool selectVSplatUimm5(SDValue N, SDValue &SplatVal);

  bool selectRVVSimm5(SDValue N, unsigned Width, SDValue &Imm);
  template <unsigned Width> bool selectRVVSimm5(SDValue N, SDValue &Imm) {
    return selectRVVSimm5(N, Width, Imm);
  }

  bool selectRVVUimm5(SDValue N, unsigned Width, SDValue &Imm);
  template <unsigned Width> bool selectRVVUimm5(SDValue N, SDValue &Imm) {
    return selectRVVUimm5(N, Width, Imm);
  }

  void selectVLSEG(SDNode *Node, bool IsMasked, bool IsStrided);
  void selectVLSEGFF(SDNode *Node, bool IsMasked);
  void selectVLXSEG(SDNode *Node, bool IsMasked, bool IsOrdered);
  void selectVSSEG(SDNode *Node, bool IsMasked, bool IsStrided);
  void selectVSXSEG(SDNode *Node, bool IsMasked, bool IsOrdered);

// Include the pieces autogenerated from the target description.
#include "RISCVGenDAGISel.inc"

private:
  void doPeepholeLoadStoreADDI();
};

namespace RISCV {
struct VLSEGPseudo {
  uint8_t NF;
  uint8_t Masked;
  uint8_t Strided;
  uint8_t FF;
  uint8_t SEW;
  uint8_t LMUL;
  uint16_t Pseudo;
};

struct VLXSEGPseudo {
  uint8_t NF;
  uint8_t Masked;
  uint8_t Ordered;
  uint8_t SEW;
  uint8_t LMUL;
  uint8_t IndexLMUL;
  uint16_t Pseudo;
};

struct VSSEGPseudo {
  uint8_t NF;
  uint8_t Masked;
  uint8_t Strided;
  uint8_t SEW;
  uint8_t LMUL;
  uint16_t Pseudo;
};

struct VSXSEGPseudo {
  uint8_t NF;
  uint8_t Masked;
  uint8_t Ordered;
  uint8_t SEW;
  uint8_t LMUL;
  uint8_t IndexLMUL;
  uint16_t Pseudo;
};

struct VLEPseudo {
  uint8_t Masked;
  uint8_t Strided;
  uint8_t FF;
  uint8_t SEW;
  uint8_t LMUL;
  uint16_t Pseudo;
};

struct VSEPseudo {
  uint8_t Masked;
  uint8_t Strided;
  uint8_t SEW;
  uint8_t LMUL;
  uint16_t Pseudo;
};

struct VLX_VSXPseudo {
  uint8_t Masked;
  uint8_t Ordered;
  uint8_t SEW;
  uint8_t LMUL;
  uint8_t IndexLMUL;
  uint16_t Pseudo;
};

#define GET_RISCVVSSEGTable_DECL
#define GET_RISCVVLSEGTable_DECL
#define GET_RISCVVLXSEGTable_DECL
#define GET_RISCVVSXSEGTable_DECL
#define GET_RISCVVLETable_DECL
#define GET_RISCVVSETable_DECL
#define GET_RISCVVLXTable_DECL
#define GET_RISCVVSXTable_DECL
#include "RISCVGenSearchableTables.inc"
} // namespace RISCV

} // namespace llvm

#endif
