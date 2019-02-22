//===- ARMLegalizerInfo.cpp --------------------------------------*- C++ -*-==//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
/// \file
/// This file implements the targeting of the Machinelegalizer class for ARM.
/// \todo This should be generated by TableGen.
//===----------------------------------------------------------------------===//

#include "ARMLegalizerInfo.h"
#include "ARMCallLowering.h"
#include "ARMSubtarget.h"
#include "llvm/CodeGen/GlobalISel/LegalizerHelper.h"
#include "llvm/CodeGen/LowLevelType.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/TargetOpcodes.h"
#include "llvm/CodeGen/ValueTypes.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Type.h"

using namespace llvm;
using namespace LegalizeActions;

/// FIXME: The following static functions are SizeChangeStrategy functions
/// that are meant to temporarily mimic the behaviour of the old legalization
/// based on doubling/halving non-legal types as closely as possible. This is
/// not entirly possible as only legalizing the types that are exactly a power
/// of 2 times the size of the legal types would require specifying all those
/// sizes explicitly.
/// In practice, not specifying those isn't a problem, and the below functions
/// should disappear quickly as we add support for legalizing non-power-of-2
/// sized types further.
static void
addAndInterleaveWithUnsupported(LegalizerInfo::SizeAndActionsVec &result,
                                const LegalizerInfo::SizeAndActionsVec &v) {
  for (unsigned i = 0; i < v.size(); ++i) {
    result.push_back(v[i]);
    if (i + 1 < v[i].first && i + 1 < v.size() &&
        v[i + 1].first != v[i].first + 1)
      result.push_back({v[i].first + 1, Unsupported});
  }
}

static LegalizerInfo::SizeAndActionsVec
widen_8_16(const LegalizerInfo::SizeAndActionsVec &v) {
  assert(v.size() >= 1);
  assert(v[0].first > 17);
  LegalizerInfo::SizeAndActionsVec result = {{1, Unsupported},
                                             {8, WidenScalar},
                                             {9, Unsupported},
                                             {16, WidenScalar},
                                             {17, Unsupported}};
  addAndInterleaveWithUnsupported(result, v);
  auto Largest = result.back().first;
  result.push_back({Largest + 1, Unsupported});
  return result;
}

static bool AEABI(const ARMSubtarget &ST) {
  return ST.isTargetAEABI() || ST.isTargetGNUAEABI() || ST.isTargetMuslAEABI();
}

ARMLegalizerInfo::ARMLegalizerInfo(const ARMSubtarget &ST) {
  using namespace TargetOpcode;

  const LLT p0 = LLT::pointer(0, 32);

  const LLT s1 = LLT::scalar(1);
  const LLT s8 = LLT::scalar(8);
  const LLT s16 = LLT::scalar(16);
  const LLT s32 = LLT::scalar(32);
  const LLT s64 = LLT::scalar(64);

  if (ST.isThumb1Only()) {
    // Thumb1 is not supported yet.
    computeTables();
    verify(*ST.getInstrInfo());
    return;
  }

  getActionDefinitionsBuilder({G_SEXT, G_ZEXT, G_ANYEXT})
      .legalForCartesianProduct({s32}, {s1, s8, s16});

  getActionDefinitionsBuilder({G_ADD, G_SUB, G_MUL, G_AND, G_OR, G_XOR})
      .legalFor({s32})
      .minScalar(0, s32);

  getActionDefinitionsBuilder({G_ASHR, G_LSHR, G_SHL})
    .legalFor({{s32, s32}})
    .clampScalar(1, s32, s32);

  bool HasHWDivide = (!ST.isThumb() && ST.hasDivideInARMMode()) ||
                     (ST.isThumb() && ST.hasDivideInThumbMode());
  if (HasHWDivide)
    getActionDefinitionsBuilder({G_SDIV, G_UDIV})
        .legalFor({s32})
        .clampScalar(0, s32, s32);
  else
    getActionDefinitionsBuilder({G_SDIV, G_UDIV})
        .libcallFor({s32})
        .clampScalar(0, s32, s32);

  for (unsigned Op : {G_SREM, G_UREM}) {
    setLegalizeScalarToDifferentSizeStrategy(Op, 0, widen_8_16);
    if (HasHWDivide)
      setAction({Op, s32}, Lower);
    else if (AEABI(ST))
      setAction({Op, s32}, Custom);
    else
      setAction({Op, s32}, Libcall);
  }

  getActionDefinitionsBuilder(G_INTTOPTR).legalFor({{p0, s32}});
  getActionDefinitionsBuilder(G_PTRTOINT).legalFor({{s32, p0}});

  getActionDefinitionsBuilder(G_CONSTANT)
      .legalFor({s32, p0})
      .clampScalar(0, s32, s32);

  getActionDefinitionsBuilder(G_ICMP)
      .legalForCartesianProduct({s1}, {s32, p0})
      .minScalar(1, s32);

  getActionDefinitionsBuilder(G_SELECT).legalForCartesianProduct({s32, p0},
                                                                 {s1});

  // We're keeping these builders around because we'll want to add support for
  // floating point to them.
  auto &LoadStoreBuilder =
      getActionDefinitionsBuilder({G_LOAD, G_STORE})
          .legalForTypesWithMemDesc({
              {s1, p0, 8, 8},
              {s8, p0, 8, 8},
              {s16, p0, 16, 8},
              {s32, p0, 32, 8},
              {p0, p0, 32, 8}});

  getActionDefinitionsBuilder(G_FRAME_INDEX).legalFor({p0});

  auto &PhiBuilder =
      getActionDefinitionsBuilder(G_PHI)
          .legalFor({s32, p0})
          .minScalar(0, s32);

  getActionDefinitionsBuilder(G_GEP).legalFor({{p0, s32}});

  getActionDefinitionsBuilder(G_BRCOND).legalFor({s1});

  if (!ST.useSoftFloat() && ST.hasVFP2()) {
    getActionDefinitionsBuilder(
        {G_FADD, G_FSUB, G_FMUL, G_FDIV, G_FCONSTANT, G_FNEG})
        .legalFor({s32, s64});

    LoadStoreBuilder.legalFor({{s64, p0}});
    PhiBuilder.legalFor({s64});

    getActionDefinitionsBuilder(G_FCMP).legalForCartesianProduct({s1},
                                                                 {s32, s64});

    getActionDefinitionsBuilder(G_MERGE_VALUES).legalFor({{s64, s32}});
    getActionDefinitionsBuilder(G_UNMERGE_VALUES).legalFor({{s32, s64}});

    getActionDefinitionsBuilder(G_FPEXT).legalFor({{s64, s32}});
    getActionDefinitionsBuilder(G_FPTRUNC).legalFor({{s32, s64}});

    getActionDefinitionsBuilder({G_FPTOSI, G_FPTOUI})
        .legalForCartesianProduct({s32}, {s32, s64});
    getActionDefinitionsBuilder({G_SITOFP, G_UITOFP})
        .legalForCartesianProduct({s32, s64}, {s32});
  } else {
    getActionDefinitionsBuilder({G_FADD, G_FSUB, G_FMUL, G_FDIV})
        .libcallFor({s32, s64});

    LoadStoreBuilder.maxScalar(0, s32);

    for (auto Ty : {s32, s64})
      setAction({G_FNEG, Ty}, Lower);

    getActionDefinitionsBuilder(G_FCONSTANT).customFor({s32, s64});

    getActionDefinitionsBuilder(G_FCMP).customForCartesianProduct({s1},
                                                                  {s32, s64});

    if (AEABI(ST))
      setFCmpLibcallsAEABI();
    else
      setFCmpLibcallsGNU();

    getActionDefinitionsBuilder(G_FPEXT).libcallFor({{s64, s32}});
    getActionDefinitionsBuilder(G_FPTRUNC).libcallFor({{s32, s64}});

    getActionDefinitionsBuilder({G_FPTOSI, G_FPTOUI})
        .libcallForCartesianProduct({s32}, {s32, s64});
    getActionDefinitionsBuilder({G_SITOFP, G_UITOFP})
        .libcallForCartesianProduct({s32, s64}, {s32});
  }

  if (!ST.useSoftFloat() && ST.hasVFP4())
    getActionDefinitionsBuilder(G_FMA).legalFor({s32, s64});
  else
    getActionDefinitionsBuilder(G_FMA).libcallFor({s32, s64});

  getActionDefinitionsBuilder({G_FREM, G_FPOW}).libcallFor({s32, s64});

  if (ST.isThumb()) {
    // FIXME: merge with the code for non-Thumb.
    computeTables();
    verify(*ST.getInstrInfo());
    return;
  }

  getActionDefinitionsBuilder(G_GLOBAL_VALUE).legalFor({p0});

  if (ST.hasV5TOps()) {
    getActionDefinitionsBuilder(G_CTLZ)
        .legalFor({s32, s32})
        .clampScalar(1, s32, s32)
        .clampScalar(0, s32, s32);
    getActionDefinitionsBuilder(G_CTLZ_ZERO_UNDEF)
        .lowerFor({s32, s32})
        .clampScalar(1, s32, s32)
        .clampScalar(0, s32, s32);
  } else {
    getActionDefinitionsBuilder(G_CTLZ_ZERO_UNDEF)
        .libcallFor({s32, s32})
        .clampScalar(1, s32, s32)
        .clampScalar(0, s32, s32);
    getActionDefinitionsBuilder(G_CTLZ)
        .lowerFor({s32, s32})
        .clampScalar(1, s32, s32)
        .clampScalar(0, s32, s32);
  }

  computeTables();
  verify(*ST.getInstrInfo());
}

void ARMLegalizerInfo::setFCmpLibcallsAEABI() {
  // FCMP_TRUE and FCMP_FALSE don't need libcalls, they should be
  // default-initialized.
  FCmp32Libcalls.resize(CmpInst::LAST_FCMP_PREDICATE + 1);
  FCmp32Libcalls[CmpInst::FCMP_OEQ] = {
      {RTLIB::OEQ_F32, CmpInst::BAD_ICMP_PREDICATE}};
  FCmp32Libcalls[CmpInst::FCMP_OGE] = {
      {RTLIB::OGE_F32, CmpInst::BAD_ICMP_PREDICATE}};
  FCmp32Libcalls[CmpInst::FCMP_OGT] = {
      {RTLIB::OGT_F32, CmpInst::BAD_ICMP_PREDICATE}};
  FCmp32Libcalls[CmpInst::FCMP_OLE] = {
      {RTLIB::OLE_F32, CmpInst::BAD_ICMP_PREDICATE}};
  FCmp32Libcalls[CmpInst::FCMP_OLT] = {
      {RTLIB::OLT_F32, CmpInst::BAD_ICMP_PREDICATE}};
  FCmp32Libcalls[CmpInst::FCMP_ORD] = {{RTLIB::O_F32, CmpInst::ICMP_EQ}};
  FCmp32Libcalls[CmpInst::FCMP_UGE] = {{RTLIB::OLT_F32, CmpInst::ICMP_EQ}};
  FCmp32Libcalls[CmpInst::FCMP_UGT] = {{RTLIB::OLE_F32, CmpInst::ICMP_EQ}};
  FCmp32Libcalls[CmpInst::FCMP_ULE] = {{RTLIB::OGT_F32, CmpInst::ICMP_EQ}};
  FCmp32Libcalls[CmpInst::FCMP_ULT] = {{RTLIB::OGE_F32, CmpInst::ICMP_EQ}};
  FCmp32Libcalls[CmpInst::FCMP_UNE] = {{RTLIB::UNE_F32, CmpInst::ICMP_EQ}};
  FCmp32Libcalls[CmpInst::FCMP_UNO] = {
      {RTLIB::UO_F32, CmpInst::BAD_ICMP_PREDICATE}};
  FCmp32Libcalls[CmpInst::FCMP_ONE] = {
      {RTLIB::OGT_F32, CmpInst::BAD_ICMP_PREDICATE},
      {RTLIB::OLT_F32, CmpInst::BAD_ICMP_PREDICATE}};
  FCmp32Libcalls[CmpInst::FCMP_UEQ] = {
      {RTLIB::OEQ_F32, CmpInst::BAD_ICMP_PREDICATE},
      {RTLIB::UO_F32, CmpInst::BAD_ICMP_PREDICATE}};

  FCmp64Libcalls.resize(CmpInst::LAST_FCMP_PREDICATE + 1);
  FCmp64Libcalls[CmpInst::FCMP_OEQ] = {
      {RTLIB::OEQ_F64, CmpInst::BAD_ICMP_PREDICATE}};
  FCmp64Libcalls[CmpInst::FCMP_OGE] = {
      {RTLIB::OGE_F64, CmpInst::BAD_ICMP_PREDICATE}};
  FCmp64Libcalls[CmpInst::FCMP_OGT] = {
      {RTLIB::OGT_F64, CmpInst::BAD_ICMP_PREDICATE}};
  FCmp64Libcalls[CmpInst::FCMP_OLE] = {
      {RTLIB::OLE_F64, CmpInst::BAD_ICMP_PREDICATE}};
  FCmp64Libcalls[CmpInst::FCMP_OLT] = {
      {RTLIB::OLT_F64, CmpInst::BAD_ICMP_PREDICATE}};
  FCmp64Libcalls[CmpInst::FCMP_ORD] = {{RTLIB::O_F64, CmpInst::ICMP_EQ}};
  FCmp64Libcalls[CmpInst::FCMP_UGE] = {{RTLIB::OLT_F64, CmpInst::ICMP_EQ}};
  FCmp64Libcalls[CmpInst::FCMP_UGT] = {{RTLIB::OLE_F64, CmpInst::ICMP_EQ}};
  FCmp64Libcalls[CmpInst::FCMP_ULE] = {{RTLIB::OGT_F64, CmpInst::ICMP_EQ}};
  FCmp64Libcalls[CmpInst::FCMP_ULT] = {{RTLIB::OGE_F64, CmpInst::ICMP_EQ}};
  FCmp64Libcalls[CmpInst::FCMP_UNE] = {{RTLIB::UNE_F64, CmpInst::ICMP_EQ}};
  FCmp64Libcalls[CmpInst::FCMP_UNO] = {
      {RTLIB::UO_F64, CmpInst::BAD_ICMP_PREDICATE}};
  FCmp64Libcalls[CmpInst::FCMP_ONE] = {
      {RTLIB::OGT_F64, CmpInst::BAD_ICMP_PREDICATE},
      {RTLIB::OLT_F64, CmpInst::BAD_ICMP_PREDICATE}};
  FCmp64Libcalls[CmpInst::FCMP_UEQ] = {
      {RTLIB::OEQ_F64, CmpInst::BAD_ICMP_PREDICATE},
      {RTLIB::UO_F64, CmpInst::BAD_ICMP_PREDICATE}};
}

void ARMLegalizerInfo::setFCmpLibcallsGNU() {
  // FCMP_TRUE and FCMP_FALSE don't need libcalls, they should be
  // default-initialized.
  FCmp32Libcalls.resize(CmpInst::LAST_FCMP_PREDICATE + 1);
  FCmp32Libcalls[CmpInst::FCMP_OEQ] = {{RTLIB::OEQ_F32, CmpInst::ICMP_EQ}};
  FCmp32Libcalls[CmpInst::FCMP_OGE] = {{RTLIB::OGE_F32, CmpInst::ICMP_SGE}};
  FCmp32Libcalls[CmpInst::FCMP_OGT] = {{RTLIB::OGT_F32, CmpInst::ICMP_SGT}};
  FCmp32Libcalls[CmpInst::FCMP_OLE] = {{RTLIB::OLE_F32, CmpInst::ICMP_SLE}};
  FCmp32Libcalls[CmpInst::FCMP_OLT] = {{RTLIB::OLT_F32, CmpInst::ICMP_SLT}};
  FCmp32Libcalls[CmpInst::FCMP_ORD] = {{RTLIB::O_F32, CmpInst::ICMP_EQ}};
  FCmp32Libcalls[CmpInst::FCMP_UGE] = {{RTLIB::OLT_F32, CmpInst::ICMP_SGE}};
  FCmp32Libcalls[CmpInst::FCMP_UGT] = {{RTLIB::OLE_F32, CmpInst::ICMP_SGT}};
  FCmp32Libcalls[CmpInst::FCMP_ULE] = {{RTLIB::OGT_F32, CmpInst::ICMP_SLE}};
  FCmp32Libcalls[CmpInst::FCMP_ULT] = {{RTLIB::OGE_F32, CmpInst::ICMP_SLT}};
  FCmp32Libcalls[CmpInst::FCMP_UNE] = {{RTLIB::UNE_F32, CmpInst::ICMP_NE}};
  FCmp32Libcalls[CmpInst::FCMP_UNO] = {{RTLIB::UO_F32, CmpInst::ICMP_NE}};
  FCmp32Libcalls[CmpInst::FCMP_ONE] = {{RTLIB::OGT_F32, CmpInst::ICMP_SGT},
                                       {RTLIB::OLT_F32, CmpInst::ICMP_SLT}};
  FCmp32Libcalls[CmpInst::FCMP_UEQ] = {{RTLIB::OEQ_F32, CmpInst::ICMP_EQ},
                                       {RTLIB::UO_F32, CmpInst::ICMP_NE}};

  FCmp64Libcalls.resize(CmpInst::LAST_FCMP_PREDICATE + 1);
  FCmp64Libcalls[CmpInst::FCMP_OEQ] = {{RTLIB::OEQ_F64, CmpInst::ICMP_EQ}};
  FCmp64Libcalls[CmpInst::FCMP_OGE] = {{RTLIB::OGE_F64, CmpInst::ICMP_SGE}};
  FCmp64Libcalls[CmpInst::FCMP_OGT] = {{RTLIB::OGT_F64, CmpInst::ICMP_SGT}};
  FCmp64Libcalls[CmpInst::FCMP_OLE] = {{RTLIB::OLE_F64, CmpInst::ICMP_SLE}};
  FCmp64Libcalls[CmpInst::FCMP_OLT] = {{RTLIB::OLT_F64, CmpInst::ICMP_SLT}};
  FCmp64Libcalls[CmpInst::FCMP_ORD] = {{RTLIB::O_F64, CmpInst::ICMP_EQ}};
  FCmp64Libcalls[CmpInst::FCMP_UGE] = {{RTLIB::OLT_F64, CmpInst::ICMP_SGE}};
  FCmp64Libcalls[CmpInst::FCMP_UGT] = {{RTLIB::OLE_F64, CmpInst::ICMP_SGT}};
  FCmp64Libcalls[CmpInst::FCMP_ULE] = {{RTLIB::OGT_F64, CmpInst::ICMP_SLE}};
  FCmp64Libcalls[CmpInst::FCMP_ULT] = {{RTLIB::OGE_F64, CmpInst::ICMP_SLT}};
  FCmp64Libcalls[CmpInst::FCMP_UNE] = {{RTLIB::UNE_F64, CmpInst::ICMP_NE}};
  FCmp64Libcalls[CmpInst::FCMP_UNO] = {{RTLIB::UO_F64, CmpInst::ICMP_NE}};
  FCmp64Libcalls[CmpInst::FCMP_ONE] = {{RTLIB::OGT_F64, CmpInst::ICMP_SGT},
                                       {RTLIB::OLT_F64, CmpInst::ICMP_SLT}};
  FCmp64Libcalls[CmpInst::FCMP_UEQ] = {{RTLIB::OEQ_F64, CmpInst::ICMP_EQ},
                                       {RTLIB::UO_F64, CmpInst::ICMP_NE}};
}

ARMLegalizerInfo::FCmpLibcallsList
ARMLegalizerInfo::getFCmpLibcalls(CmpInst::Predicate Predicate,
                                  unsigned Size) const {
  assert(CmpInst::isFPPredicate(Predicate) && "Unsupported FCmp predicate");
  if (Size == 32)
    return FCmp32Libcalls[Predicate];
  if (Size == 64)
    return FCmp64Libcalls[Predicate];
  llvm_unreachable("Unsupported size for FCmp predicate");
}

bool ARMLegalizerInfo::legalizeCustom(MachineInstr &MI,
                                      MachineRegisterInfo &MRI,
                                      MachineIRBuilder &MIRBuilder,
                                      GISelChangeObserver &Observer) const {
  using namespace TargetOpcode;

  MIRBuilder.setInstr(MI);
  LLVMContext &Ctx = MIRBuilder.getMF().getFunction().getContext();

  switch (MI.getOpcode()) {
  default:
    return false;
  case G_SREM:
  case G_UREM: {
    unsigned OriginalResult = MI.getOperand(0).getReg();
    auto Size = MRI.getType(OriginalResult).getSizeInBits();
    if (Size != 32)
      return false;

    auto Libcall =
        MI.getOpcode() == G_SREM ? RTLIB::SDIVREM_I32 : RTLIB::UDIVREM_I32;

    // Our divmod libcalls return a struct containing the quotient and the
    // remainder. We need to create a virtual register for it.
    Type *ArgTy = Type::getInt32Ty(Ctx);
    StructType *RetTy = StructType::get(Ctx, {ArgTy, ArgTy}, /* Packed */ true);
    auto RetVal = MRI.createGenericVirtualRegister(
        getLLTForType(*RetTy, MIRBuilder.getMF().getDataLayout()));

    auto Status = createLibcall(MIRBuilder, Libcall, {RetVal, RetTy},
                                {{MI.getOperand(1).getReg(), ArgTy},
                                 {MI.getOperand(2).getReg(), ArgTy}});
    if (Status != LegalizerHelper::Legalized)
      return false;

    // The remainder is the second result of divmod. Split the return value into
    // a new, unused register for the quotient and the destination of the
    // original instruction for the remainder.
    MIRBuilder.buildUnmerge(
        {MRI.createGenericVirtualRegister(LLT::scalar(32)), OriginalResult},
        RetVal);
    break;
  }
  case G_FCMP: {
    assert(MRI.getType(MI.getOperand(2).getReg()) ==
               MRI.getType(MI.getOperand(3).getReg()) &&
           "Mismatched operands for G_FCMP");
    auto OpSize = MRI.getType(MI.getOperand(2).getReg()).getSizeInBits();

    auto OriginalResult = MI.getOperand(0).getReg();
    auto Predicate =
        static_cast<CmpInst::Predicate>(MI.getOperand(1).getPredicate());
    auto Libcalls = getFCmpLibcalls(Predicate, OpSize);

    if (Libcalls.empty()) {
      assert((Predicate == CmpInst::FCMP_TRUE ||
              Predicate == CmpInst::FCMP_FALSE) &&
             "Predicate needs libcalls, but none specified");
      MIRBuilder.buildConstant(OriginalResult,
                               Predicate == CmpInst::FCMP_TRUE ? 1 : 0);
      MI.eraseFromParent();
      return true;
    }

    assert((OpSize == 32 || OpSize == 64) && "Unsupported operand size");
    auto *ArgTy = OpSize == 32 ? Type::getFloatTy(Ctx) : Type::getDoubleTy(Ctx);
    auto *RetTy = Type::getInt32Ty(Ctx);

    SmallVector<unsigned, 2> Results;
    for (auto Libcall : Libcalls) {
      auto LibcallResult = MRI.createGenericVirtualRegister(LLT::scalar(32));
      auto Status =
          createLibcall(MIRBuilder, Libcall.LibcallID, {LibcallResult, RetTy},
                        {{MI.getOperand(2).getReg(), ArgTy},
                         {MI.getOperand(3).getReg(), ArgTy}});

      if (Status != LegalizerHelper::Legalized)
        return false;

      auto ProcessedResult =
          Libcalls.size() == 1
              ? OriginalResult
              : MRI.createGenericVirtualRegister(MRI.getType(OriginalResult));

      // We have a result, but we need to transform it into a proper 1-bit 0 or
      // 1, taking into account the different peculiarities of the values
      // returned by the comparison functions.
      CmpInst::Predicate ResultPred = Libcall.Predicate;
      if (ResultPred == CmpInst::BAD_ICMP_PREDICATE) {
        // We have a nice 0 or 1, and we just need to truncate it back to 1 bit
        // to keep the types consistent.
        MIRBuilder.buildTrunc(ProcessedResult, LibcallResult);
      } else {
        // We need to compare against 0.
        assert(CmpInst::isIntPredicate(ResultPred) && "Unsupported predicate");
        auto Zero = MRI.createGenericVirtualRegister(LLT::scalar(32));
        MIRBuilder.buildConstant(Zero, 0);
        MIRBuilder.buildICmp(ResultPred, ProcessedResult, LibcallResult, Zero);
      }
      Results.push_back(ProcessedResult);
    }

    if (Results.size() != 1) {
      assert(Results.size() == 2 && "Unexpected number of results");
      MIRBuilder.buildOr(OriginalResult, Results[0], Results[1]);
    }
    break;
  }
  case G_FCONSTANT: {
    // Convert to integer constants, while preserving the binary representation.
    auto AsInteger =
        MI.getOperand(1).getFPImm()->getValueAPF().bitcastToAPInt();
    MIRBuilder.buildConstant(MI.getOperand(0).getReg(),
                             *ConstantInt::get(Ctx, AsInteger));
    break;
  }
  }

  MI.eraseFromParent();
  return true;
}
