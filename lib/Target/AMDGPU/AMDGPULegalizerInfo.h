//===- AMDGPULegalizerInfo ---------------------------------------*- C++ -*-==//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
/// \file
/// This file declares the targeting of the Machinelegalizer class for
/// AMDGPU.
/// \todo This should be generated by TableGen.
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_AMDGPU_AMDGPUMACHINELEGALIZER_H
#define LLVM_LIB_TARGET_AMDGPU_AMDGPUMACHINELEGALIZER_H

#include "llvm/CodeGen/GlobalISel/LegalizerInfo.h"
#include "AMDGPUArgumentUsageInfo.h"
#include "SIInstrInfo.h"

namespace llvm {

class GCNTargetMachine;
class LLVMContext;
class GCNSubtarget;

/// This class provides the information for the target register banks.
class AMDGPULegalizerInfo : public LegalizerInfo {
  const GCNSubtarget &ST;

public:
  AMDGPULegalizerInfo(const GCNSubtarget &ST,
                      const GCNTargetMachine &TM);

  bool legalizeCustom(MachineInstr &MI, MachineRegisterInfo &MRI,
                      MachineIRBuilder &B,
                      GISelChangeObserver &Observer) const override;

  Register getSegmentAperture(unsigned AddrSpace,
                              MachineRegisterInfo &MRI,
                              MachineIRBuilder &B) const;

  bool legalizeAddrSpaceCast(MachineInstr &MI, MachineRegisterInfo &MRI,
                             MachineIRBuilder &B) const;
  bool legalizeFrint(MachineInstr &MI, MachineRegisterInfo &MRI,
                     MachineIRBuilder &B) const;
  bool legalizeFceil(MachineInstr &MI, MachineRegisterInfo &MRI,
                     MachineIRBuilder &B) const;
  bool legalizeIntrinsicTrunc(MachineInstr &MI, MachineRegisterInfo &MRI,
                              MachineIRBuilder &B) const;
  bool legalizeITOFP(MachineInstr &MI, MachineRegisterInfo &MRI,
                     MachineIRBuilder &B, bool Signed) const;
  bool legalizeMinNumMaxNum(MachineInstr &MI, MachineRegisterInfo &MRI,
                            MachineIRBuilder &B) const;
  bool legalizeExtractVectorElt(MachineInstr &MI, MachineRegisterInfo &MRI,
                                MachineIRBuilder &B) const;
  bool legalizeInsertVectorElt(MachineInstr &MI, MachineRegisterInfo &MRI,
                               MachineIRBuilder &B) const;
  bool legalizeShuffleVector(MachineInstr &MI, MachineRegisterInfo &MRI,
                             MachineIRBuilder &B) const;

  bool legalizeSinCos(MachineInstr &MI, MachineRegisterInfo &MRI,
                      MachineIRBuilder &B) const;

  bool buildPCRelGlobalAddress(
    Register DstReg, LLT PtrTy, MachineIRBuilder &B, const GlobalValue *GV,
    unsigned Offset, unsigned GAFlags = SIInstrInfo::MO_NONE) const;

  bool legalizeGlobalValue(MachineInstr &MI, MachineRegisterInfo &MRI,
                           MachineIRBuilder &B) const;
  bool legalizeLoad(MachineInstr &MI, MachineRegisterInfo &MRI,
                    MachineIRBuilder &B,
                    GISelChangeObserver &Observer) const;

  bool legalizeFMad(MachineInstr &MI, MachineRegisterInfo &MRI,
                    MachineIRBuilder &B) const;

  bool legalizeAtomicCmpXChg(MachineInstr &MI, MachineRegisterInfo &MRI,
                             MachineIRBuilder &B) const;

  Register getLiveInRegister(MachineRegisterInfo &MRI,
                             Register Reg, LLT Ty) const;

  bool loadInputValue(Register DstReg, MachineIRBuilder &B,
                      const ArgDescriptor *Arg) const;
  bool legalizePreloadedArgIntrin(
    MachineInstr &MI, MachineRegisterInfo &MRI, MachineIRBuilder &B,
    AMDGPUFunctionArgInfo::PreloadedValue ArgType) const;

  bool legalizeFDIV(MachineInstr &MI, MachineRegisterInfo &MRI,
                    MachineIRBuilder &B) const;
  bool legalizeFDIV16(MachineInstr &MI, MachineRegisterInfo &MRI,
                      MachineIRBuilder &B) const;
  bool legalizeFDIV32(MachineInstr &MI, MachineRegisterInfo &MRI,
                      MachineIRBuilder &B) const;
  bool legalizeFDIV64(MachineInstr &MI, MachineRegisterInfo &MRI,
                      MachineIRBuilder &B) const;
  bool legalizeFastUnsafeFDIV(MachineInstr &MI, MachineRegisterInfo &MRI,
                              MachineIRBuilder &B) const;
  bool legalizeFDIVFastIntrin(MachineInstr &MI, MachineRegisterInfo &MRI,
                              MachineIRBuilder &B) const;

  bool legalizeImplicitArgPtr(MachineInstr &MI, MachineRegisterInfo &MRI,
                              MachineIRBuilder &B) const;
  bool legalizeIsAddrSpace(MachineInstr &MI, MachineRegisterInfo &MRI,
                           MachineIRBuilder &B, unsigned AddrSpace) const;

  std::tuple<Register, unsigned, unsigned>
  splitBufferOffsets(MachineIRBuilder &B, Register OrigOffset) const;

  Register handleD16VData(MachineIRBuilder &B, MachineRegisterInfo &MRI,
                          Register Reg) const;
  bool legalizeRawBufferStore(MachineInstr &MI, MachineRegisterInfo &MRI,
                              MachineIRBuilder &B, bool IsFormat) const;
  bool legalizeRawBufferLoad(MachineInstr &MI, MachineRegisterInfo &MRI,
                             MachineIRBuilder &B, bool IsFormat) const;
  bool legalizeAtomicIncDec(MachineInstr &MI,  MachineIRBuilder &B,
                            bool IsInc) const;

  bool legalizeIntrinsic(MachineInstr &MI, MachineRegisterInfo &MRI,
                         MachineIRBuilder &B) const override;

};
} // End llvm namespace.
#endif
