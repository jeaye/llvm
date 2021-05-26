//===- RISCVInsertVSETVLI.cpp - Insert VSETVLI instructions ---------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file implements a function pass that inserts VSETVLI instructions where
// needed.
//
// This pass consists of 3 phases:
//
// Phase 1 collects how each basic block affects VL/VTYPE.
//
// Phase 2 uses the information from phase 1 to do a data flow analysis to
// propagate the VL/VTYPE changes through the function. This gives us the
// VL/VTYPE at the start of each basic block.
//
// Phase 3 inserts VSETVLI instructions in each basic block. Information from
// phase 2 is used to prevent inserting a VSETVLI before the first vector
// instruction in the block if possible.
//
//===----------------------------------------------------------------------===//

#include "RISCV.h"
#include "RISCVSubtarget.h"
#include "llvm/CodeGen/LiveIntervals.h"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include <queue>
using namespace llvm;

#define DEBUG_TYPE "riscv-insert-vsetvli"
#define RISCV_INSERT_VSETVLI_NAME "RISCV Insert VSETVLI pass"

namespace {

class VSETVLIInfo {
  union {
    Register AVLReg;
    unsigned AVLImm;
  };

  enum : uint8_t {
    Uninitialized,
    AVLIsReg,
    AVLIsImm,
    Unknown,
  } State = Uninitialized;

  // Fields from VTYPE.
  RISCVII::VLMUL VLMul = RISCVII::LMUL_1;
  uint8_t SEW = 0;
  bool TailAgnostic = false;
  bool MaskAgnostic = false;

public:
  VSETVLIInfo() : AVLImm(0) {}

  static VSETVLIInfo getUnknown() {
    VSETVLIInfo Info;
    Info.setUnknown();
    return Info;
  }

  bool isValid() const { return State != Uninitialized; }
  void setUnknown() { State = Unknown; }
  bool isUnknown() const { return State == Unknown; }

  void setAVLReg(Register Reg) {
    AVLReg = Reg;
    State = AVLIsReg;
  }

  void setAVLImm(unsigned Imm) {
    AVLImm = Imm;
    State = AVLIsImm;
  }

  bool hasAVLImm() const { return State == AVLIsImm; }
  bool hasAVLReg() const { return State == AVLIsReg; }
  Register getAVLReg() const {
    assert(hasAVLReg());
    return AVLReg;
  }
  unsigned getAVLImm() const {
    assert(hasAVLImm());
    return AVLImm;
  }

  bool hasSameAVL(const VSETVLIInfo &Other) const {
    assert(isValid() && Other.isValid() &&
           "Can't compare invalid VSETVLIInfos");
    assert(!isUnknown() && !Other.isUnknown() &&
           "Can't compare AVL in unknown state");
    if (hasAVLReg() && Other.hasAVLReg())
      return getAVLReg() == Other.getAVLReg();

    if (hasAVLImm() && Other.hasAVLImm())
      return getAVLImm() == Other.getAVLImm();

    return false;
  }

  void setVTYPE(unsigned VType) {
    assert(isValid() && !isUnknown() &&
           "Can't set VTYPE for uninitialized or unknown");
    VLMul = RISCVVType::getVLMUL(VType);
    SEW = RISCVVType::getSEW(VType);
    TailAgnostic = RISCVVType::isTailAgnostic(VType);
    MaskAgnostic = RISCVVType::isMaskAgnostic(VType);
  }
  void setVTYPE(RISCVII::VLMUL L, unsigned S, bool TA, bool MA) {
    assert(isValid() && !isUnknown() &&
           "Can't set VTYPE for uninitialized or unknown");
    VLMul = L;
    SEW = S;
    TailAgnostic = TA;
    MaskAgnostic = MA;
  }

  unsigned encodeVTYPE() const {
    return RISCVVType::encodeVTYPE(VLMul, SEW, TailAgnostic, MaskAgnostic);
  }

  bool hasSameVTYPE(const VSETVLIInfo &Other) const {
    assert(isValid() && Other.isValid() &&
           "Can't compare invalid VSETVLIInfos");
    assert(!isUnknown() && !Other.isUnknown() &&
           "Can't compare VTYPE in unknown state");
    return std::tie(VLMul, SEW, TailAgnostic, MaskAgnostic) ==
           std::tie(Other.VLMul, Other.SEW, Other.TailAgnostic,
                    Other.MaskAgnostic);
  }

  bool isCompatible(const VSETVLIInfo &Other) const {
    assert(isValid() && Other.isValid() &&
           "Can't compare invalid VSETVLIInfos");
    // Nothing is compatible with Unknown.
    if (isUnknown() || Other.isUnknown())
      return false;

    // If other doesn't need an AVLReg and the SEW matches, consider it
    // compatible.
    if (Other.hasAVLReg() && Other.AVLReg == RISCV::NoRegister) {
      if (SEW == Other.SEW)
        return true;
    }

    // VTypes must match.
    if (!hasSameVTYPE(Other))
      return false;

    if (hasAVLImm() != Other.hasAVLImm())
      return false;

    if (hasAVLImm())
      return getAVLImm() == Other.getAVLImm();

    return getAVLReg() == Other.getAVLReg();
  }

  bool operator==(const VSETVLIInfo &Other) const {
    // Uninitialized is only equal to another Uninitialized.
    if (!isValid())
      return !Other.isValid();
    if (!Other.isValid())
      return !isValid();

    // Unknown is only equal to another Unknown.
    if (isUnknown())
      return Other.isUnknown();
    if (Other.isUnknown())
      return isUnknown();

    // Otherwise compare the VTYPE and AVL.
    return hasSameVTYPE(Other) && hasSameAVL(Other);
  }

  bool operator!=(const VSETVLIInfo &Other) const { return !(*this == Other); }

  // Calculate the VSETVLIInfo visible to a block assuming this and Other are
  // both predecessors.
  VSETVLIInfo intersect(const VSETVLIInfo &Other) const {
    // If the new value isn't valid, ignore it.
    if (!Other.isValid())
      return *this;

    // If this value isn't valid, this must be the first predecessor, use it.
    if (!isValid())
      return Other;

    if (*this == Other)
      return *this;

    // If the configurations don't match, assume unknown.
    return VSETVLIInfo::getUnknown();
  }

  // Calculate the VSETVLIInfo visible at the end of the block assuming this
  // is the predecessor value, and Other is change for this block.
  VSETVLIInfo merge(const VSETVLIInfo &Other) const {
    assert(isValid() && "Can only merge with a valid VSETVLInfo");

    // Nothing changed from the predecessor, keep it.
    if (!Other.isValid())
      return *this;

    // If the change is compatible with the input, we won't create a VSETVLI
    // and should keep the predecessor.
    if (isCompatible(Other))
      return *this;

    // Otherwise just use whatever is in this block.
    return Other;
  }
};

struct BlockData {
  // The VSETVLIInfo that represents the net changes to the VL/VTYPE registers
  // made by this block. Calculated in Phase 1.
  VSETVLIInfo Change;

  // The VSETVLIInfo that represents the VL/VTYPE settings on exit from this
  // block. Calculated in Phase 2.
  VSETVLIInfo Exit;

  // The VSETVLIInfo that represents the VL/VTYPE settings from all predecessor
  // blocks. Calculated in Phase 2, and used by Phase 3.
  VSETVLIInfo Pred;

  // Keeps track of whether the block is already in the queue.
  bool InQueue = false;

  BlockData() {}
};

class RISCVInsertVSETVLI : public MachineFunctionPass {
  const TargetInstrInfo *TII;
  MachineRegisterInfo *MRI;

  std::vector<BlockData> BlockInfo;
  std::queue<const MachineBasicBlock *> WorkList;

public:
  static char ID;

  RISCVInsertVSETVLI() : MachineFunctionPass(ID) {
    initializeRISCVInsertVSETVLIPass(*PassRegistry::getPassRegistry());
  }
  bool runOnMachineFunction(MachineFunction &MF) override;

  void getAnalysisUsage(AnalysisUsage &AU) const override {
    AU.setPreservesCFG();
    MachineFunctionPass::getAnalysisUsage(AU);
  }

  StringRef getPassName() const override { return RISCV_INSERT_VSETVLI_NAME; }

private:
  bool needVSETVLI(const VSETVLIInfo &Require, const VSETVLIInfo &CurInfo);
  void insertVSETVLI(MachineBasicBlock &MBB, MachineInstr &MI,
                     const VSETVLIInfo &Info);

  bool computeVLVTYPEChanges(const MachineBasicBlock &MBB);
  void computeIncomingVLVTYPE(const MachineBasicBlock &MBB);
  void emitVSETVLIs(MachineBasicBlock &MBB);
};

} // end anonymous namespace

char RISCVInsertVSETVLI::ID = 0;

INITIALIZE_PASS(RISCVInsertVSETVLI, DEBUG_TYPE, RISCV_INSERT_VSETVLI_NAME,
                false, false)

static MachineInstr *elideCopies(MachineInstr *MI,
                                 const MachineRegisterInfo *MRI) {
  while (true) {
    if (!MI->isFullCopy())
      return MI;
    if (!Register::isVirtualRegister(MI->getOperand(1).getReg()))
      return nullptr;
    MI = MRI->getVRegDef(MI->getOperand(1).getReg());
    if (!MI)
      return nullptr;
  }
}

static VSETVLIInfo computeInfoForInstr(const MachineInstr &MI, uint64_t TSFlags,
                                       const MachineRegisterInfo *MRI) {
  VSETVLIInfo InstrInfo;
  unsigned NumOperands = MI.getNumExplicitOperands();

  RISCVII::VLMUL VLMul = RISCVII::getLMul(TSFlags);

  unsigned Log2SEW = MI.getOperand(NumOperands - 1).getImm();
  unsigned SEW = 1 << Log2SEW;
  assert(RISCVVType::isValidSEW(SEW) && "Unexpected SEW");

  // Default to tail agnostic unless the destination is tied to a source.
  // Unless the source is undef. In that case the user would have some control
  // over the tail values. The tail policy is also ignored on instructions
  // that only update element 0 like vmv.s.x or reductions so use agnostic
  // there to match the common case.
  // FIXME: This is conservatively correct, but we might want to detect that
  // the input is undefined.
  bool ForceTailAgnostic = RISCVII::doesForceTailAgnostic(TSFlags);
  bool TailAgnostic = true;
  unsigned UseOpIdx;
  if (!ForceTailAgnostic && MI.isRegTiedToUseOperand(0, &UseOpIdx)) {
    TailAgnostic = false;
    // If the tied operand is an IMPLICIT_DEF we can keep TailAgnostic.
    const MachineOperand &UseMO = MI.getOperand(UseOpIdx);
    MachineInstr *UseMI = MRI->getVRegDef(UseMO.getReg());
    if (UseMI) {
      UseMI = elideCopies(UseMI, MRI);
      if (UseMI && UseMI->isImplicitDef())
        TailAgnostic = true;
    }
  }

  if (RISCVII::hasVLOp(TSFlags)) {
    const MachineOperand &VLOp = MI.getOperand(MI.getNumExplicitOperands() - 2);
    if (VLOp.isImm())
      InstrInfo.setAVLImm(VLOp.getImm());
    else
      InstrInfo.setAVLReg(VLOp.getReg());
  } else
    InstrInfo.setAVLReg(RISCV::NoRegister);
  InstrInfo.setVTYPE(VLMul, SEW, /*TailAgnostic*/ TailAgnostic,
                     /*MaskAgnostic*/ false);

  return InstrInfo;
}

void RISCVInsertVSETVLI::insertVSETVLI(MachineBasicBlock &MBB, MachineInstr &MI,
                                       const VSETVLIInfo &Info) {
  DebugLoc DL = MI.getDebugLoc();

  if (Info.hasAVLImm()) {
    BuildMI(MBB, MI, DL, TII->get(RISCV::PseudoVSETIVLI))
        .addReg(RISCV::X0, RegState::Define | RegState::Dead)
        .addImm(Info.getAVLImm())
        .addImm(Info.encodeVTYPE());
    return;
  }

  Register AVLReg = Info.getAVLReg();
  if (AVLReg == RISCV::NoRegister) {
    BuildMI(MBB, MI, DL, TII->get(RISCV::PseudoVSETVLI))
        .addReg(RISCV::X0, RegState::Define | RegState::Dead)
        .addReg(RISCV::X0, RegState::Kill)
        .addImm(Info.encodeVTYPE())
        .addReg(RISCV::VL, RegState::Implicit);
    return;
  }

  // Use X0 as the DestReg unless AVLReg is X0.
  Register DestReg = RISCV::X0;
  if (AVLReg == RISCV::X0)
    DestReg = MRI->createVirtualRegister(&RISCV::GPRRegClass);
  BuildMI(MBB, MI, DL, TII->get(RISCV::PseudoVSETVLI))
      .addReg(DestReg, RegState::Define | RegState::Dead)
      .addReg(AVLReg)
      .addImm(Info.encodeVTYPE());
}

// Return a VSETVLIInfo representing the changes made by this VSETVLI or
// VSETIVLI instruction.
static VSETVLIInfo getInfoForVSETVLI(const MachineInstr &MI) {
  VSETVLIInfo NewInfo;
  if (MI.getOpcode() == RISCV::PseudoVSETVLI) {
    Register AVLReg = MI.getOperand(1).getReg();
    assert((AVLReg != RISCV::X0 || MI.getOperand(0).getReg() != RISCV::X0) &&
           "Can't handle X0, X0 vsetvli yet");
    NewInfo.setAVLReg(AVLReg);
  } else {
    assert(MI.getOpcode() == RISCV::PseudoVSETIVLI);
    NewInfo.setAVLImm(MI.getOperand(1).getImm());
  }
  NewInfo.setVTYPE(MI.getOperand(2).getImm());

  return NewInfo;
}

bool RISCVInsertVSETVLI::needVSETVLI(const VSETVLIInfo &Require,
                                     const VSETVLIInfo &CurInfo) {
  if (CurInfo.isCompatible(Require))
    return false;

  // We didn't find a compatible value. If our AVL is a virtual register,
  // it might be defined by a VSET(I)VLI. If it has the same VTYPE we need
  // and the last VL/VTYPE we observed is the same, we don't need a
  // VSETVLI here.
  if (!CurInfo.isUnknown() && Require.hasAVLReg() &&
      Require.getAVLReg().isVirtual() && Require.hasSameVTYPE(CurInfo)) {
    if (MachineInstr *DefMI = MRI->getVRegDef(Require.getAVLReg())) {
      if (DefMI->getOpcode() == RISCV::PseudoVSETVLI ||
          DefMI->getOpcode() == RISCV::PseudoVSETIVLI) {
        VSETVLIInfo DefInfo = getInfoForVSETVLI(*DefMI);
        if (DefInfo.hasSameAVL(CurInfo) && DefInfo.hasSameVTYPE(CurInfo))
          return false;
      }
    }
  }

  return true;
}

bool RISCVInsertVSETVLI::computeVLVTYPEChanges(const MachineBasicBlock &MBB) {
  bool HadVectorOp = false;

  BlockData &BBInfo = BlockInfo[MBB.getNumber()];
  for (const MachineInstr &MI : MBB) {
    // If this is an explicit VSETVLI or VSETIVLI, update our state.
    if (MI.getOpcode() == RISCV::PseudoVSETVLI ||
        MI.getOpcode() == RISCV::PseudoVSETIVLI) {
      HadVectorOp = true;
      BBInfo.Change = getInfoForVSETVLI(MI);
      continue;
    }

    uint64_t TSFlags = MI.getDesc().TSFlags;
    if (RISCVII::hasSEWOp(TSFlags)) {
      HadVectorOp = true;

      VSETVLIInfo NewInfo = computeInfoForInstr(MI, TSFlags, MRI);

      if (!BBInfo.Change.isValid()) {
        BBInfo.Change = NewInfo;
      } else {
        // If this instruction isn't compatible with the previous VL/VTYPE
        // we need to insert a VSETVLI.
        if (needVSETVLI(NewInfo, BBInfo.Change))
          BBInfo.Change = NewInfo;
      }
    }

    // If this is something that updates VL/VTYPE that we don't know about, set
    // the state to unknown.
    if (MI.isCall() || MI.isInlineAsm() || MI.modifiesRegister(RISCV::VL) ||
        MI.modifiesRegister(RISCV::VTYPE)) {
      BBInfo.Change = VSETVLIInfo::getUnknown();
    }
  }

  // Initial exit state is whatever change we found in the block.
  BBInfo.Exit = BBInfo.Change;

  return HadVectorOp;
}

void RISCVInsertVSETVLI::computeIncomingVLVTYPE(const MachineBasicBlock &MBB) {
  BlockData &BBInfo = BlockInfo[MBB.getNumber()];

  BBInfo.InQueue = false;

  VSETVLIInfo InInfo;
  if (MBB.pred_empty()) {
    // There are no predecessors, so use the default starting status.
    InInfo.setUnknown();
  } else {
    for (MachineBasicBlock *P : MBB.predecessors())
      InInfo = InInfo.intersect(BlockInfo[P->getNumber()].Exit);
  }

  // If we don't have any valid predecessor value, wait until we do.
  if (!InInfo.isValid())
    return;

  BBInfo.Pred = InInfo;

  VSETVLIInfo TmpStatus = BBInfo.Pred.merge(BBInfo.Change);

  // If the new exit value matches the old exit value, we don't need to revisit
  // any blocks.
  if (BBInfo.Exit == TmpStatus)
    return;

  BBInfo.Exit = TmpStatus;

  // Add the successors to the work list so we can propagate the changed exit
  // status.
  for (MachineBasicBlock *S : MBB.successors())
    if (!BlockInfo[S->getNumber()].InQueue)
      WorkList.push(S);
}

void RISCVInsertVSETVLI::emitVSETVLIs(MachineBasicBlock &MBB) {
  VSETVLIInfo CurInfo;

  for (MachineInstr &MI : MBB) {
    // If this is an explicit VSETVLI or VSETIVLI, update our state.
    if (MI.getOpcode() == RISCV::PseudoVSETVLI ||
        MI.getOpcode() == RISCV::PseudoVSETIVLI) {
      // Conservatively, mark the VL and VTYPE as live.
      assert(MI.getOperand(3).getReg() == RISCV::VL &&
             MI.getOperand(4).getReg() == RISCV::VTYPE &&
             "Unexpected operands where VL and VTYPE should be");
      MI.getOperand(3).setIsDead(false);
      MI.getOperand(4).setIsDead(false);
      CurInfo = getInfoForVSETVLI(MI);
      continue;
    }

    uint64_t TSFlags = MI.getDesc().TSFlags;
    if (RISCVII::hasSEWOp(TSFlags)) {
      VSETVLIInfo NewInfo = computeInfoForInstr(MI, TSFlags, MRI);
      if (RISCVII::hasVLOp(TSFlags)) {
        MachineOperand &VLOp = MI.getOperand(MI.getNumExplicitOperands() - 2);
        if (VLOp.isReg()) {
          // Erase the AVL operand from the instruction.
          VLOp.setReg(RISCV::NoRegister);
          VLOp.setIsKill(false);
        }
        MI.addOperand(MachineOperand::CreateReg(RISCV::VL, /*isDef*/ false,
                                                /*isImp*/ true));
      }
      MI.addOperand(MachineOperand::CreateReg(RISCV::VTYPE, /*isDef*/ false,
                                              /*isImp*/ true));

      if (!CurInfo.isValid()) {
        // We haven't found any vector instructions or VL/VTYPE changes yet,
        // use the predecessor information.
        assert(BlockInfo[MBB.getNumber()].Pred.isValid() &&
               "Expected a valid predecessor state.");
        if (needVSETVLI(NewInfo, BlockInfo[MBB.getNumber()].Pred)) {
          insertVSETVLI(MBB, MI, NewInfo);
          CurInfo = NewInfo;
        }
      } else {
        // If this instruction isn't compatible with the previous VL/VTYPE
        // we need to insert a VSETVLI.
        if (needVSETVLI(NewInfo, CurInfo)) {
          insertVSETVLI(MBB, MI, NewInfo);
          CurInfo = NewInfo;
        }
      }
    }

    // If this is something updates VL/VTYPE that we don't know about, set
    // the state to unknown.
    if (MI.isCall() || MI.isInlineAsm() || MI.modifiesRegister(RISCV::VL) ||
        MI.modifiesRegister(RISCV::VTYPE)) {
      CurInfo = VSETVLIInfo::getUnknown();
    }
  }
}

bool RISCVInsertVSETVLI::runOnMachineFunction(MachineFunction &MF) {
  // Skip if the vector extension is not enabled.
  const RISCVSubtarget &ST = MF.getSubtarget<RISCVSubtarget>();
  if (!ST.hasStdExtV())
    return false;

  TII = ST.getInstrInfo();
  MRI = &MF.getRegInfo();

  assert(BlockInfo.empty() && "Expect empty block infos");
  BlockInfo.resize(MF.getNumBlockIDs());

  bool HaveVectorOp = false;

  // Phase 1 - determine how VL/VTYPE are affected by the each block.
  for (const MachineBasicBlock &MBB : MF)
    HaveVectorOp |= computeVLVTYPEChanges(MBB);

  // If we didn't find any instructions that need VSETVLI, we're done.
  if (HaveVectorOp) {
    // Phase 2 - determine the exit VL/VTYPE from each block. We add all
    // blocks to the list here, but will also add any that need to be revisited
    // during Phase 2 processing.
    for (const MachineBasicBlock &MBB : MF) {
      WorkList.push(&MBB);
      BlockInfo[MBB.getNumber()].InQueue = true;
    }
    while (!WorkList.empty()) {
      const MachineBasicBlock &MBB = *WorkList.front();
      WorkList.pop();
      computeIncomingVLVTYPE(MBB);
    }

    // Phase 3 - add any vsetvli instructions needed in the block. Use the
    // Phase 2 information to avoid adding vsetvlis before the first vector
    // instruction in the block if the VL/VTYPE is satisfied by its
    // predecessors.
    for (MachineBasicBlock &MBB : MF)
      emitVSETVLIs(MBB);
  }

  BlockInfo.clear();

  return HaveVectorOp;
}

/// Returns an instance of the Insert VSETVLI pass.
FunctionPass *llvm::createRISCVInsertVSETVLIPass() {
  return new RISCVInsertVSETVLI();
}
