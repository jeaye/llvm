//===- TargetSubtargetInfo.cpp - General Target Information ----------------==//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
/// \file This file describes the general parts of a Subtarget.
//
//===----------------------------------------------------------------------===//

#include "llvm/CodeGen/TargetSubtargetInfo.h"

using namespace llvm;

TargetSubtargetInfo::TargetSubtargetInfo(
    const Triple &TT, StringRef CPU, StringRef FS,
    ArrayRef<SubtargetFeatureKV> PF, ArrayRef<SubtargetSubTypeKV> PD,
    const SubtargetInfoKV *ProcSched, const MCWriteProcResEntry *WPR,
    const MCWriteLatencyEntry *WL, const MCReadAdvanceEntry *RA,
    const InstrStage *IS, const unsigned *OC, const unsigned *FP)
    : MCSubtargetInfo(TT, CPU, FS, PF, PD, ProcSched, WPR, WL, RA, IS, OC, FP) {
}

TargetSubtargetInfo::~TargetSubtargetInfo() = default;

bool TargetSubtargetInfo::enableAtomicExpand() const {
  return true;
}

bool TargetSubtargetInfo::enableIndirectBrExpand() const {
  return false;
}

bool TargetSubtargetInfo::enableMachineScheduler() const {
  return false;
}

bool TargetSubtargetInfo::enableJoinGlobalCopies() const {
  return enableMachineScheduler();
}

bool TargetSubtargetInfo::enableRALocalReassignment(
    CodeGenOpt::Level OptLevel) const {
  return true;
}

bool TargetSubtargetInfo::enableAdvancedRASplitCost() const {
  return false;
}

bool TargetSubtargetInfo::enablePostRAScheduler() const {
  return getSchedModel().PostRAScheduler;
}

bool TargetSubtargetInfo::useAA() const {
  return false;
}

void TargetSubtargetInfo::mirFileLoaded(MachineFunction &MF) const { }
