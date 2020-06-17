//=- WebAssemblyFixBrTableDefaults.cpp - Fix br_table default branch targets -//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
///
/// \file This file implements a pass that eliminates redundant range checks
/// guarding br_table instructions. Since jump tables on most targets cannot
/// handle out of range indices, LLVM emits these checks before most jump
/// tables. But br_table takes a default branch target as an argument, so it
/// does not need the range checks.
///
//===----------------------------------------------------------------------===//

#include "MCTargetDesc/WebAssemblyMCTargetDesc.h"
#include "WebAssembly.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/Pass.h"

using namespace llvm;

#define DEBUG_TYPE "wasm-fix-br-table-defaults"

namespace {

class WebAssemblyFixBrTableDefaults final : public MachineFunctionPass {
  StringRef getPassName() const override {
    return "WebAssembly Fix br_table Defaults";
  }

  bool runOnMachineFunction(MachineFunction &MF) override;

public:
  static char ID; // Pass identification, replacement for typeid
  WebAssemblyFixBrTableDefaults() : MachineFunctionPass(ID) {}
};

char WebAssemblyFixBrTableDefaults::ID = 0;

// `MI` is a br_table instruction missing its default target argument. This
// function finds and adds the default target argument and removes any redundant
// range check preceding the br_table.
MachineBasicBlock *fixBrTable(MachineInstr &MI, MachineBasicBlock *MBB,
                              MachineFunction &MF) {
  // Get the header block, which contains the redundant range check.
  assert(MBB->pred_size() == 1 && "Expected a single guard predecessor");
  auto *HeaderMBB = *MBB->pred_begin();

  // Find the conditional jump to the default target. If it doesn't exist, the
  // default target is unreachable anyway, so we can choose anything.
  MachineBasicBlock *TBB = nullptr, *FBB = nullptr;
  SmallVector<MachineOperand, 2> Cond;
  const auto &TII = *MF.getSubtarget<WebAssemblySubtarget>().getInstrInfo();
  TII.analyzeBranch(*HeaderMBB, TBB, FBB, Cond);

  // Here are the possible outcomes. '_' is nullptr, `J` is the jump table block
  // aka MBB, 'D' is the default block.
  //
  // TBB | FBB | Meaning
  //  _  |  _  | No default block, header falls through to jump table
  //  J  |  _  | No default block, header jumps to the jump table
  //  D  |  _  | Header jumps to the default and falls through to the jump table
  //  D  |  J  | Header jumps to the default and also to the jump table
  if (TBB && TBB != MBB) {
    // Install the default target.
    assert((FBB == nullptr || FBB == MBB) &&
           "Expected jump or fallthrough to br_table block");
    MI.addOperand(MF, MachineOperand::CreateMBB(TBB));
  } else {
    // Arbitrarily choose the first jump target as the default.
    auto *SomeMBB = MI.getOperand(1).getMBB();
    MI.addOperand(MachineOperand::CreateMBB(SomeMBB));
  }

  // Remove any branches from the header and splice in the jump table instead
  TII.removeBranch(*HeaderMBB, nullptr);
  HeaderMBB->splice(HeaderMBB->end(), MBB, MBB->begin(), MBB->end());

  // Update CFG to skip the old jump table block. Remove shared successors
  // before transferring to avoid duplicated successors.
  HeaderMBB->removeSuccessor(MBB);
  for (auto &Succ : MBB->successors())
    if (HeaderMBB->isSuccessor(Succ))
      HeaderMBB->removeSuccessor(Succ);
  HeaderMBB->transferSuccessorsAndUpdatePHIs(MBB);

  // Remove the old jump table block from the function
  MF.erase(MBB);

  return HeaderMBB;
}

bool WebAssemblyFixBrTableDefaults::runOnMachineFunction(MachineFunction &MF) {
  LLVM_DEBUG(dbgs() << "********** Fixing br_table Default Targets **********\n"
                       "********** Function: "
                    << MF.getName() << '\n');

  bool Changed = false;
  SmallPtrSet<MachineBasicBlock *, 16> MBBSet;
  for (auto &MBB : MF)
    MBBSet.insert(&MBB);

  while (!MBBSet.empty()) {
    MachineBasicBlock *MBB = *MBBSet.begin();
    MBBSet.erase(MBB);
    for (auto &MI : *MBB) {
      if (WebAssembly::isBrTable(MI)) {
        auto *Fixed = fixBrTable(MI, MBB, MF);
        MBBSet.erase(Fixed);
        Changed = true;
        break;
      }
    }
  }

  if (Changed) {
    // We rewrote part of the function; recompute relevant things.
    MF.RenumberBlocks();
    return true;
  }

  return false;
}

} // end anonymous namespace

INITIALIZE_PASS(WebAssemblyFixBrTableDefaults, DEBUG_TYPE,
                "Removes range checks and sets br_table default targets", false,
                false)

FunctionPass *llvm::createWebAssemblyFixBrTableDefaults() {
  return new WebAssemblyFixBrTableDefaults();
}
