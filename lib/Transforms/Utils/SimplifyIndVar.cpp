//===-- SimplifyIndVar.cpp - Induction variable simplification ------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file implements induction variable simplification. It does
// not define any actual pass or policy, but provides a single function to
// simplify a loop's induction variables based on ScalarEvolution.
//
//===----------------------------------------------------------------------===//

#include "llvm/Transforms/Utils/SimplifyIndVar.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/Statistic.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/IR/Dominators.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/IntrinsicInst.h"
#include "llvm/IR/PatternMatch.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Transforms/Utils/Local.h"
#include "llvm/Transforms/Utils/ScalarEvolutionExpander.h"

using namespace llvm;

#define DEBUG_TYPE "indvars"

STATISTIC(NumElimIdentity, "Number of IV identities eliminated");
STATISTIC(NumElimOperand,  "Number of IV operands folded into a use");
STATISTIC(NumFoldedUser, "Number of IV users folded into a constant");
STATISTIC(NumElimRem     , "Number of IV remainder operations eliminated");
STATISTIC(
    NumSimplifiedSDiv,
    "Number of IV signed division operations converted to unsigned division");
STATISTIC(
    NumSimplifiedSRem,
    "Number of IV signed remainder operations converted to unsigned remainder");
STATISTIC(NumElimCmp     , "Number of IV comparisons eliminated");

namespace {
  /// This is a utility for simplifying induction variables
  /// based on ScalarEvolution. It is the primary instrument of the
  /// IndvarSimplify pass, but it may also be directly invoked to cleanup after
  /// other loop passes that preserve SCEV.
  class SimplifyIndvar {
    Loop             *L;
    LoopInfo         *LI;
    ScalarEvolution  *SE;
    DominatorTree    *DT;
    const TargetTransformInfo *TTI;
    SCEVExpander     &Rewriter;
    SmallVectorImpl<WeakTrackingVH> &DeadInsts;

    bool Changed;

  public:
    SimplifyIndvar(Loop *Loop, ScalarEvolution *SE, DominatorTree *DT,
                   LoopInfo *LI, const TargetTransformInfo *TTI,
                   SCEVExpander &Rewriter,
                   SmallVectorImpl<WeakTrackingVH> &Dead)
        : L(Loop), LI(LI), SE(SE), DT(DT), TTI(TTI), Rewriter(Rewriter),
          DeadInsts(Dead), Changed(false) {
      assert(LI && "IV simplification requires LoopInfo");
    }

    bool hasChanged() const { return Changed; }

    /// Iteratively perform simplification on a worklist of users of the
    /// specified induction variable. This is the top-level driver that applies
    /// all simplifications to users of an IV.
    void simplifyUsers(PHINode *CurrIV, IVVisitor *V = nullptr);

    Value *foldIVUser(Instruction *UseInst, Instruction *IVOperand);

    bool eliminateIdentitySCEV(Instruction *UseInst, Instruction *IVOperand);
    bool replaceIVUserWithLoopInvariant(Instruction *UseInst);

    bool eliminateOverflowIntrinsic(WithOverflowInst *WO);
    bool eliminateSaturatingIntrinsic(SaturatingInst *SI);
    bool eliminateTrunc(TruncInst *TI);
    bool eliminateIVUser(Instruction *UseInst, Instruction *IVOperand);
    bool makeIVComparisonInvariant(ICmpInst *ICmp, Value *IVOperand);
    void eliminateIVComparison(ICmpInst *ICmp, Value *IVOperand);
    void simplifyIVRemainder(BinaryOperator *Rem, Value *IVOperand,
                             bool IsSigned);
    void replaceRemWithNumerator(BinaryOperator *Rem);
    void replaceRemWithNumeratorOrZero(BinaryOperator *Rem);
    void replaceSRemWithURem(BinaryOperator *Rem);
    bool eliminateSDiv(BinaryOperator *SDiv);
    bool strengthenOverflowingOperation(BinaryOperator *OBO, Value *IVOperand);
    bool strengthenRightShift(BinaryOperator *BO, Value *IVOperand);
  };
}

/// Fold an IV operand into its use.  This removes increments of an
/// aligned IV when used by a instruction that ignores the low bits.
///
/// IVOperand is guaranteed SCEVable, but UseInst may not be.
///
/// Return the operand of IVOperand for this induction variable if IVOperand can
/// be folded (in case more folding opportunities have been exposed).
/// Otherwise return null.
Value *SimplifyIndvar::foldIVUser(Instruction *UseInst, Instruction *IVOperand) {
  Value *IVSrc = nullptr;
  const unsigned OperIdx = 0;
  const SCEV *FoldedExpr = nullptr;
  bool MustDropExactFlag = false;
  switch (UseInst->getOpcode()) {
  default:
    return nullptr;
  case Instruction::UDiv:
  case Instruction::LShr:
    // We're only interested in the case where we know something about
    // the numerator and have a constant denominator.
    if (IVOperand != UseInst->getOperand(OperIdx) ||
        !isa<ConstantInt>(UseInst->getOperand(1)))
      return nullptr;

    // Attempt to fold a binary operator with constant operand.
    // e.g. ((I + 1) >> 2) => I >> 2
    if (!isa<BinaryOperator>(IVOperand)
        || !isa<ConstantInt>(IVOperand->getOperand(1)))
      return nullptr;

    IVSrc = IVOperand->getOperand(0);
    // IVSrc must be the (SCEVable) IV, since the other operand is const.
    assert(SE->isSCEVable(IVSrc->getType()) && "Expect SCEVable IV operand");

    ConstantInt *D = cast<ConstantInt>(UseInst->getOperand(1));
    if (UseInst->getOpcode() == Instruction::LShr) {
      // Get a constant for the divisor. See createSCEV.
      uint32_t BitWidth = cast<IntegerType>(UseInst->getType())->getBitWidth();
      if (D->getValue().uge(BitWidth))
        return nullptr;

      D = ConstantInt::get(UseInst->getContext(),
                           APInt::getOneBitSet(BitWidth, D->getZExtValue()));
    }
    FoldedExpr = SE->getUDivExpr(SE->getSCEV(IVSrc), SE->getSCEV(D));
    // We might have 'exact' flag set at this point which will no longer be
    // correct after we make the replacement.
    if (UseInst->isExact() &&
        SE->getSCEV(IVSrc) != SE->getMulExpr(FoldedExpr, SE->getSCEV(D)))
      MustDropExactFlag = true;
  }
  // We have something that might fold it's operand. Compare SCEVs.
  if (!SE->isSCEVable(UseInst->getType()))
    return nullptr;

  // Bypass the operand if SCEV can prove it has no effect.
  if (SE->getSCEV(UseInst) != FoldedExpr)
    return nullptr;

  LLVM_DEBUG(dbgs() << "INDVARS: Eliminated IV operand: " << *IVOperand
                    << " -> " << *UseInst << '\n');

  UseInst->setOperand(OperIdx, IVSrc);
  assert(SE->getSCEV(UseInst) == FoldedExpr && "bad SCEV with folded oper");

  if (MustDropExactFlag)
    UseInst->dropPoisonGeneratingFlags();

  ++NumElimOperand;
  Changed = true;
  if (IVOperand->use_empty())
    DeadInsts.emplace_back(IVOperand);
  return IVSrc;
}

bool SimplifyIndvar::makeIVComparisonInvariant(ICmpInst *ICmp,
                                               Value *IVOperand) {
  unsigned IVOperIdx = 0;
  ICmpInst::Predicate Pred = ICmp->getPredicate();
  if (IVOperand != ICmp->getOperand(0)) {
    // Swapped
    assert(IVOperand == ICmp->getOperand(1) && "Can't find IVOperand");
    IVOperIdx = 1;
    Pred = ICmpInst::getSwappedPredicate(Pred);
  }

  // Get the SCEVs for the ICmp operands (in the specific context of the
  // current loop)
  const Loop *ICmpLoop = LI->getLoopFor(ICmp->getParent());
  const SCEV *S = SE->getSCEVAtScope(ICmp->getOperand(IVOperIdx), ICmpLoop);
  const SCEV *X = SE->getSCEVAtScope(ICmp->getOperand(1 - IVOperIdx), ICmpLoop);

  auto *PN = dyn_cast<PHINode>(IVOperand);
  if (!PN)
    return false;
  auto LIP = SE->getLoopInvariantPredicate(Pred, S, X, L);
  if (!LIP)
    return false;
  ICmpInst::Predicate InvariantPredicate = LIP->Pred;
  const SCEV *InvariantLHS = LIP->LHS;
  const SCEV *InvariantRHS = LIP->RHS;

  // Rewrite the comparison to a loop invariant comparison if it can be done
  // cheaply, where cheaply means "we don't need to emit any new
  // instructions".

  SmallDenseMap<const SCEV*, Value*> CheapExpansions;
  CheapExpansions[S] = ICmp->getOperand(IVOperIdx);
  CheapExpansions[X] = ICmp->getOperand(1 - IVOperIdx);

  // TODO: Support multiple entry loops?  (We currently bail out of these in
  // the IndVarSimplify pass)
  if (auto *BB = L->getLoopPredecessor()) {
    const int Idx = PN->getBasicBlockIndex(BB);
    if (Idx >= 0) {
      Value *Incoming = PN->getIncomingValue(Idx);
      const SCEV *IncomingS = SE->getSCEV(Incoming);
      CheapExpansions[IncomingS] = Incoming;
    }
  }
  Value *NewLHS = CheapExpansions[InvariantLHS];
  Value *NewRHS = CheapExpansions[InvariantRHS];

  if (!NewLHS)
    if (auto *ConstLHS = dyn_cast<SCEVConstant>(InvariantLHS))
      NewLHS = ConstLHS->getValue();
  if (!NewRHS)
    if (auto *ConstRHS = dyn_cast<SCEVConstant>(InvariantRHS))
      NewRHS = ConstRHS->getValue();

  if (!NewLHS || !NewRHS)
    // We could not find an existing value to replace either LHS or RHS.
    // Generating new instructions has subtler tradeoffs, so avoid doing that
    // for now.
    return false;

  LLVM_DEBUG(dbgs() << "INDVARS: Simplified comparison: " << *ICmp << '\n');
  ICmp->setPredicate(InvariantPredicate);
  ICmp->setOperand(0, NewLHS);
  ICmp->setOperand(1, NewRHS);
  return true;
}

/// SimplifyIVUsers helper for eliminating useless
/// comparisons against an induction variable.
void SimplifyIndvar::eliminateIVComparison(ICmpInst *ICmp, Value *IVOperand) {
  unsigned IVOperIdx = 0;
  ICmpInst::Predicate Pred = ICmp->getPredicate();
  ICmpInst::Predicate OriginalPred = Pred;
  if (IVOperand != ICmp->getOperand(0)) {
    // Swapped
    assert(IVOperand == ICmp->getOperand(1) && "Can't find IVOperand");
    IVOperIdx = 1;
    Pred = ICmpInst::getSwappedPredicate(Pred);
  }

  // Get the SCEVs for the ICmp operands (in the specific context of the
  // current loop)
  const Loop *ICmpLoop = LI->getLoopFor(ICmp->getParent());
  const SCEV *S = SE->getSCEVAtScope(ICmp->getOperand(IVOperIdx), ICmpLoop);
  const SCEV *X = SE->getSCEVAtScope(ICmp->getOperand(1 - IVOperIdx), ICmpLoop);

  // If the condition is always true or always false, replace it with
  // a constant value.
  if (SE->isKnownPredicate(Pred, S, X)) {
    ICmp->replaceAllUsesWith(ConstantInt::getTrue(ICmp->getContext()));
    DeadInsts.emplace_back(ICmp);
    LLVM_DEBUG(dbgs() << "INDVARS: Eliminated comparison: " << *ICmp << '\n');
  } else if (SE->isKnownPredicate(ICmpInst::getInversePredicate(Pred), S, X)) {
    ICmp->replaceAllUsesWith(ConstantInt::getFalse(ICmp->getContext()));
    DeadInsts.emplace_back(ICmp);
    LLVM_DEBUG(dbgs() << "INDVARS: Eliminated comparison: " << *ICmp << '\n');
  } else if (makeIVComparisonInvariant(ICmp, IVOperand)) {
    // fallthrough to end of function
  } else if (ICmpInst::isSigned(OriginalPred) &&
             SE->isKnownNonNegative(S) && SE->isKnownNonNegative(X)) {
    // If we were unable to make anything above, all we can is to canonicalize
    // the comparison hoping that it will open the doors for other
    // optimizations. If we find out that we compare two non-negative values,
    // we turn the instruction's predicate to its unsigned version. Note that
    // we cannot rely on Pred here unless we check if we have swapped it.
    assert(ICmp->getPredicate() == OriginalPred && "Predicate changed?");
    LLVM_DEBUG(dbgs() << "INDVARS: Turn to unsigned comparison: " << *ICmp
                      << '\n');
    ICmp->setPredicate(ICmpInst::getUnsignedPredicate(OriginalPred));
  } else
    return;

  ++NumElimCmp;
  Changed = true;
}

bool SimplifyIndvar::eliminateSDiv(BinaryOperator *SDiv) {
  // Get the SCEVs for the ICmp operands.
  auto *N = SE->getSCEV(SDiv->getOperand(0));
  auto *D = SE->getSCEV(SDiv->getOperand(1));

  // Simplify unnecessary loops away.
  const Loop *L = LI->getLoopFor(SDiv->getParent());
  N = SE->getSCEVAtScope(N, L);
  D = SE->getSCEVAtScope(D, L);

  // Replace sdiv by udiv if both of the operands are non-negative
  if (SE->isKnownNonNegative(N) && SE->isKnownNonNegative(D)) {
    auto *UDiv = BinaryOperator::Create(
        BinaryOperator::UDiv, SDiv->getOperand(0), SDiv->getOperand(1),
        SDiv->getName() + ".udiv", SDiv);
    UDiv->setIsExact(SDiv->isExact());
    SDiv->replaceAllUsesWith(UDiv);
    LLVM_DEBUG(dbgs() << "INDVARS: Simplified sdiv: " << *SDiv << '\n');
    ++NumSimplifiedSDiv;
    Changed = true;
    DeadInsts.push_back(SDiv);
    return true;
  }

  return false;
}

// i %s n -> i %u n if i >= 0 and n >= 0
void SimplifyIndvar::replaceSRemWithURem(BinaryOperator *Rem) {
  auto *N = Rem->getOperand(0), *D = Rem->getOperand(1);
  auto *URem = BinaryOperator::Create(BinaryOperator::URem, N, D,
                                      Rem->getName() + ".urem", Rem);
  Rem->replaceAllUsesWith(URem);
  LLVM_DEBUG(dbgs() << "INDVARS: Simplified srem: " << *Rem << '\n');
  ++NumSimplifiedSRem;
  Changed = true;
  DeadInsts.emplace_back(Rem);
}

// i % n  -->  i  if i is in [0,n).
void SimplifyIndvar::replaceRemWithNumerator(BinaryOperator *Rem) {
  Rem->replaceAllUsesWith(Rem->getOperand(0));
  LLVM_DEBUG(dbgs() << "INDVARS: Simplified rem: " << *Rem << '\n');
  ++NumElimRem;
  Changed = true;
  DeadInsts.emplace_back(Rem);
}

// (i+1) % n  -->  (i+1)==n?0:(i+1)  if i is in [0,n).
void SimplifyIndvar::replaceRemWithNumeratorOrZero(BinaryOperator *Rem) {
  auto *T = Rem->getType();
  auto *N = Rem->getOperand(0), *D = Rem->getOperand(1);
  ICmpInst *ICmp = new ICmpInst(Rem, ICmpInst::ICMP_EQ, N, D);
  SelectInst *Sel =
      SelectInst::Create(ICmp, ConstantInt::get(T, 0), N, "iv.rem", Rem);
  Rem->replaceAllUsesWith(Sel);
  LLVM_DEBUG(dbgs() << "INDVARS: Simplified rem: " << *Rem << '\n');
  ++NumElimRem;
  Changed = true;
  DeadInsts.emplace_back(Rem);
}

/// SimplifyIVUsers helper for eliminating useless remainder operations
/// operating on an induction variable or replacing srem by urem.
void SimplifyIndvar::simplifyIVRemainder(BinaryOperator *Rem, Value *IVOperand,
                                         bool IsSigned) {
  auto *NValue = Rem->getOperand(0);
  auto *DValue = Rem->getOperand(1);
  // We're only interested in the case where we know something about
  // the numerator, unless it is a srem, because we want to replace srem by urem
  // in general.
  bool UsedAsNumerator = IVOperand == NValue;
  if (!UsedAsNumerator && !IsSigned)
    return;

  const SCEV *N = SE->getSCEV(NValue);

  // Simplify unnecessary loops away.
  const Loop *ICmpLoop = LI->getLoopFor(Rem->getParent());
  N = SE->getSCEVAtScope(N, ICmpLoop);

  bool IsNumeratorNonNegative = !IsSigned || SE->isKnownNonNegative(N);

  // Do not proceed if the Numerator may be negative
  if (!IsNumeratorNonNegative)
    return;

  const SCEV *D = SE->getSCEV(DValue);
  D = SE->getSCEVAtScope(D, ICmpLoop);

  if (UsedAsNumerator) {
    auto LT = IsSigned ? ICmpInst::ICMP_SLT : ICmpInst::ICMP_ULT;
    if (SE->isKnownPredicate(LT, N, D)) {
      replaceRemWithNumerator(Rem);
      return;
    }

    auto *T = Rem->getType();
    const auto *NLessOne = SE->getMinusSCEV(N, SE->getOne(T));
    if (SE->isKnownPredicate(LT, NLessOne, D)) {
      replaceRemWithNumeratorOrZero(Rem);
      return;
    }
  }

  // Try to replace SRem with URem, if both N and D are known non-negative.
  // Since we had already check N, we only need to check D now
  if (!IsSigned || !SE->isKnownNonNegative(D))
    return;

  replaceSRemWithURem(Rem);
}

static bool willNotOverflow(ScalarEvolution *SE, Instruction::BinaryOps BinOp,
                            bool Signed, const SCEV *LHS, const SCEV *RHS) {
  const SCEV *(ScalarEvolution::*Operation)(const SCEV *, const SCEV *,
                                            SCEV::NoWrapFlags, unsigned);
  switch (BinOp) {
  default:
    llvm_unreachable("Unsupported binary op");
  case Instruction::Add:
    Operation = &ScalarEvolution::getAddExpr;
    break;
  case Instruction::Sub:
    Operation = &ScalarEvolution::getMinusSCEV;
    break;
  case Instruction::Mul:
    Operation = &ScalarEvolution::getMulExpr;
    break;
  }

  const SCEV *(ScalarEvolution::*Extension)(const SCEV *, Type *, unsigned) =
      Signed ? &ScalarEvolution::getSignExtendExpr
             : &ScalarEvolution::getZeroExtendExpr;

  // Check ext(LHS op RHS) == ext(LHS) op ext(RHS)
  auto *NarrowTy = cast<IntegerType>(LHS->getType());
  auto *WideTy =
    IntegerType::get(NarrowTy->getContext(), NarrowTy->getBitWidth() * 2);

  const SCEV *A =
      (SE->*Extension)((SE->*Operation)(LHS, RHS, SCEV::FlagAnyWrap, 0),
                       WideTy, 0);
  const SCEV *B =
      (SE->*Operation)((SE->*Extension)(LHS, WideTy, 0),
                       (SE->*Extension)(RHS, WideTy, 0), SCEV::FlagAnyWrap, 0);
  return A == B;
}

bool SimplifyIndvar::eliminateOverflowIntrinsic(WithOverflowInst *WO) {
  const SCEV *LHS = SE->getSCEV(WO->getLHS());
  const SCEV *RHS = SE->getSCEV(WO->getRHS());
  if (!willNotOverflow(SE, WO->getBinaryOp(), WO->isSigned(), LHS, RHS))
    return false;

  // Proved no overflow, nuke the overflow check and, if possible, the overflow
  // intrinsic as well.

  BinaryOperator *NewResult = BinaryOperator::Create(
      WO->getBinaryOp(), WO->getLHS(), WO->getRHS(), "", WO);

  if (WO->isSigned())
    NewResult->setHasNoSignedWrap(true);
  else
    NewResult->setHasNoUnsignedWrap(true);

  SmallVector<ExtractValueInst *, 4> ToDelete;

  for (auto *U : WO->users()) {
    if (auto *EVI = dyn_cast<ExtractValueInst>(U)) {
      if (EVI->getIndices()[0] == 1)
        EVI->replaceAllUsesWith(ConstantInt::getFalse(WO->getContext()));
      else {
        assert(EVI->getIndices()[0] == 0 && "Only two possibilities!");
        EVI->replaceAllUsesWith(NewResult);
      }
      ToDelete.push_back(EVI);
    }
  }

  for (auto *EVI : ToDelete)
    EVI->eraseFromParent();

  if (WO->use_empty())
    WO->eraseFromParent();

  Changed = true;
  return true;
}

bool SimplifyIndvar::eliminateSaturatingIntrinsic(SaturatingInst *SI) {
  const SCEV *LHS = SE->getSCEV(SI->getLHS());
  const SCEV *RHS = SE->getSCEV(SI->getRHS());
  if (!willNotOverflow(SE, SI->getBinaryOp(), SI->isSigned(), LHS, RHS))
    return false;

  BinaryOperator *BO = BinaryOperator::Create(
      SI->getBinaryOp(), SI->getLHS(), SI->getRHS(), SI->getName(), SI);
  if (SI->isSigned())
    BO->setHasNoSignedWrap();
  else
    BO->setHasNoUnsignedWrap();

  SI->replaceAllUsesWith(BO);
  DeadInsts.emplace_back(SI);
  Changed = true;
  return true;
}

bool SimplifyIndvar::eliminateTrunc(TruncInst *TI) {
  // It is always legal to replace
  //   icmp <pred> i32 trunc(iv), n
  // with
  //   icmp <pred> i64 sext(trunc(iv)), sext(n), if pred is signed predicate.
  // Or with
  //   icmp <pred> i64 zext(trunc(iv)), zext(n), if pred is unsigned predicate.
  // Or with either of these if pred is an equality predicate.
  //
  // If we can prove that iv == sext(trunc(iv)) or iv == zext(trunc(iv)) for
  // every comparison which uses trunc, it means that we can replace each of
  // them with comparison of iv against sext/zext(n). We no longer need trunc
  // after that.
  //
  // TODO: Should we do this if we can widen *some* comparisons, but not all
  // of them? Sometimes it is enough to enable other optimizations, but the
  // trunc instruction will stay in the loop.
  Value *IV = TI->getOperand(0);
  Type *IVTy = IV->getType();
  const SCEV *IVSCEV = SE->getSCEV(IV);
  const SCEV *TISCEV = SE->getSCEV(TI);

  // Check if iv == zext(trunc(iv)) and if iv == sext(trunc(iv)). If so, we can
  // get rid of trunc
  bool DoesSExtCollapse = false;
  bool DoesZExtCollapse = false;
  if (IVSCEV == SE->getSignExtendExpr(TISCEV, IVTy))
    DoesSExtCollapse = true;
  if (IVSCEV == SE->getZeroExtendExpr(TISCEV, IVTy))
    DoesZExtCollapse = true;

  // If neither sext nor zext does collapse, it is not profitable to do any
  // transform. Bail.
  if (!DoesSExtCollapse && !DoesZExtCollapse)
    return false;

  // Collect users of the trunc that look like comparisons against invariants.
  // Bail if we find something different.
  SmallVector<ICmpInst *, 4> ICmpUsers;
  for (auto *U : TI->users()) {
    // We don't care about users in unreachable blocks.
    if (isa<Instruction>(U) &&
        !DT->isReachableFromEntry(cast<Instruction>(U)->getParent()))
      continue;
    ICmpInst *ICI = dyn_cast<ICmpInst>(U);
    if (!ICI) return false;
    assert(L->contains(ICI->getParent()) && "LCSSA form broken?");
    if (!(ICI->getOperand(0) == TI && L->isLoopInvariant(ICI->getOperand(1))) &&
        !(ICI->getOperand(1) == TI && L->isLoopInvariant(ICI->getOperand(0))))
      return false;
    // If we cannot get rid of trunc, bail.
    if (ICI->isSigned() && !DoesSExtCollapse)
      return false;
    if (ICI->isUnsigned() && !DoesZExtCollapse)
      return false;
    // For equality, either signed or unsigned works.
    ICmpUsers.push_back(ICI);
  }

  auto CanUseZExt = [&](ICmpInst *ICI) {
    // Unsigned comparison can be widened as unsigned.
    if (ICI->isUnsigned())
      return true;
    // Is it profitable to do zext?
    if (!DoesZExtCollapse)
      return false;
    // For equality, we can safely zext both parts.
    if (ICI->isEquality())
      return true;
    // Otherwise we can only use zext when comparing two non-negative or two
    // negative values. But in practice, we will never pass DoesZExtCollapse
    // check for a negative value, because zext(trunc(x)) is non-negative. So
    // it only make sense to check for non-negativity here.
    const SCEV *SCEVOP1 = SE->getSCEV(ICI->getOperand(0));
    const SCEV *SCEVOP2 = SE->getSCEV(ICI->getOperand(1));
    return SE->isKnownNonNegative(SCEVOP1) && SE->isKnownNonNegative(SCEVOP2);
  };
  // Replace all comparisons against trunc with comparisons against IV.
  for (auto *ICI : ICmpUsers) {
    bool IsSwapped = L->isLoopInvariant(ICI->getOperand(0));
    auto *Op1 = IsSwapped ? ICI->getOperand(0) : ICI->getOperand(1);
    Instruction *Ext = nullptr;
    // For signed/unsigned predicate, replace the old comparison with comparison
    // of immediate IV against sext/zext of the invariant argument. If we can
    // use either sext or zext (i.e. we are dealing with equality predicate),
    // then prefer zext as a more canonical form.
    // TODO: If we see a signed comparison which can be turned into unsigned,
    // we can do it here for canonicalization purposes.
    ICmpInst::Predicate Pred = ICI->getPredicate();
    if (IsSwapped) Pred = ICmpInst::getSwappedPredicate(Pred);
    if (CanUseZExt(ICI)) {
      assert(DoesZExtCollapse && "Unprofitable zext?");
      Ext = new ZExtInst(Op1, IVTy, "zext", ICI);
      Pred = ICmpInst::getUnsignedPredicate(Pred);
    } else {
      assert(DoesSExtCollapse && "Unprofitable sext?");
      Ext = new SExtInst(Op1, IVTy, "sext", ICI);
      assert(Pred == ICmpInst::getSignedPredicate(Pred) && "Must be signed!");
    }
    bool Changed;
    L->makeLoopInvariant(Ext, Changed);
    (void)Changed;
    ICmpInst *NewICI = new ICmpInst(ICI, Pred, IV, Ext);
    ICI->replaceAllUsesWith(NewICI);
    DeadInsts.emplace_back(ICI);
  }

  // Trunc no longer needed.
  TI->replaceAllUsesWith(UndefValue::get(TI->getType()));
  DeadInsts.emplace_back(TI);
  return true;
}

/// Eliminate an operation that consumes a simple IV and has no observable
/// side-effect given the range of IV values.  IVOperand is guaranteed SCEVable,
/// but UseInst may not be.
bool SimplifyIndvar::eliminateIVUser(Instruction *UseInst,
                                     Instruction *IVOperand) {
  if (ICmpInst *ICmp = dyn_cast<ICmpInst>(UseInst)) {
    eliminateIVComparison(ICmp, IVOperand);
    return true;
  }
  if (BinaryOperator *Bin = dyn_cast<BinaryOperator>(UseInst)) {
    bool IsSRem = Bin->getOpcode() == Instruction::SRem;
    if (IsSRem || Bin->getOpcode() == Instruction::URem) {
      simplifyIVRemainder(Bin, IVOperand, IsSRem);
      return true;
    }

    if (Bin->getOpcode() == Instruction::SDiv)
      return eliminateSDiv(Bin);
  }

  if (auto *WO = dyn_cast<WithOverflowInst>(UseInst))
    if (eliminateOverflowIntrinsic(WO))
      return true;

  if (auto *SI = dyn_cast<SaturatingInst>(UseInst))
    if (eliminateSaturatingIntrinsic(SI))
      return true;

  if (auto *TI = dyn_cast<TruncInst>(UseInst))
    if (eliminateTrunc(TI))
      return true;

  if (eliminateIdentitySCEV(UseInst, IVOperand))
    return true;

  return false;
}

static Instruction *GetLoopInvariantInsertPosition(Loop *L, Instruction *Hint) {
  if (auto *BB = L->getLoopPreheader())
    return BB->getTerminator();

  return Hint;
}

/// Replace the UseInst with a loop invariant expression if it is safe.
bool SimplifyIndvar::replaceIVUserWithLoopInvariant(Instruction *I) {
  if (!SE->isSCEVable(I->getType()))
    return false;

  // Get the symbolic expression for this instruction.
  const SCEV *S = SE->getSCEV(I);

  if (!SE->isLoopInvariant(S, L))
    return false;

  // Do not generate something ridiculous even if S is loop invariant.
  if (Rewriter.isHighCostExpansion(S, L, SCEVCheapExpansionBudget, TTI, I))
    return false;

  auto *IP = GetLoopInvariantInsertPosition(L, I);

  if (!isSafeToExpandAt(S, IP, *SE)) {
    LLVM_DEBUG(dbgs() << "INDVARS: Can not replace IV user: " << *I
                      << " with non-speculable loop invariant: " << *S << '\n');
    return false;
  }

  auto *Invariant = Rewriter.expandCodeFor(S, I->getType(), IP);

  I->replaceAllUsesWith(Invariant);
  LLVM_DEBUG(dbgs() << "INDVARS: Replace IV user: " << *I
                    << " with loop invariant: " << *S << '\n');
  ++NumFoldedUser;
  Changed = true;
  DeadInsts.emplace_back(I);
  return true;
}

/// Eliminate any operation that SCEV can prove is an identity function.
bool SimplifyIndvar::eliminateIdentitySCEV(Instruction *UseInst,
                                           Instruction *IVOperand) {
  if (!SE->isSCEVable(UseInst->getType()) ||
      (UseInst->getType() != IVOperand->getType()) ||
      (SE->getSCEV(UseInst) != SE->getSCEV(IVOperand)))
    return false;

  // getSCEV(X) == getSCEV(Y) does not guarantee that X and Y are related in the
  // dominator tree, even if X is an operand to Y.  For instance, in
  //
  //     %iv = phi i32 {0,+,1}
  //     br %cond, label %left, label %merge
  //
  //   left:
  //     %X = add i32 %iv, 0
  //     br label %merge
  //
  //   merge:
  //     %M = phi (%X, %iv)
  //
  // getSCEV(%M) == getSCEV(%X) == {0,+,1}, but %X does not dominate %M, and
  // %M.replaceAllUsesWith(%X) would be incorrect.

  if (isa<PHINode>(UseInst))
    // If UseInst is not a PHI node then we know that IVOperand dominates
    // UseInst directly from the legality of SSA.
    if (!DT || !DT->dominates(IVOperand, UseInst))
      return false;

  if (!LI->replacementPreservesLCSSAForm(UseInst, IVOperand))
    return false;

  LLVM_DEBUG(dbgs() << "INDVARS: Eliminated identity: " << *UseInst << '\n');

  UseInst->replaceAllUsesWith(IVOperand);
  ++NumElimIdentity;
  Changed = true;
  DeadInsts.emplace_back(UseInst);
  return true;
}

/// Annotate BO with nsw / nuw if it provably does not signed-overflow /
/// unsigned-overflow.  Returns true if anything changed, false otherwise.
bool SimplifyIndvar::strengthenOverflowingOperation(BinaryOperator *BO,
                                                    Value *IVOperand) {
  // Fastpath: we don't have any work to do if `BO` is `nuw` and `nsw`.
  if (BO->hasNoUnsignedWrap() && BO->hasNoSignedWrap())
    return false;

  if (BO->getOpcode() != Instruction::Add &&
      BO->getOpcode() != Instruction::Sub &&
      BO->getOpcode() != Instruction::Mul)
    return false;

  const SCEV *LHS = SE->getSCEV(BO->getOperand(0));
  const SCEV *RHS = SE->getSCEV(BO->getOperand(1));
  bool Changed = false;

  if (!BO->hasNoUnsignedWrap() &&
      willNotOverflow(SE, BO->getOpcode(), /* Signed */ false, LHS, RHS)) {
    BO->setHasNoUnsignedWrap();
    SE->forgetValue(BO);
    Changed = true;
  }

  if (!BO->hasNoSignedWrap() &&
      willNotOverflow(SE, BO->getOpcode(), /* Signed */ true, LHS, RHS)) {
    BO->setHasNoSignedWrap();
    SE->forgetValue(BO);
    Changed = true;
  }

  return Changed;
}

/// Annotate the Shr in (X << IVOperand) >> C as exact using the
/// information from the IV's range. Returns true if anything changed, false
/// otherwise.
bool SimplifyIndvar::strengthenRightShift(BinaryOperator *BO,
                                          Value *IVOperand) {
  using namespace llvm::PatternMatch;

  if (BO->getOpcode() == Instruction::Shl) {
    bool Changed = false;
    ConstantRange IVRange = SE->getUnsignedRange(SE->getSCEV(IVOperand));
    for (auto *U : BO->users()) {
      const APInt *C;
      if (match(U,
                m_AShr(m_Shl(m_Value(), m_Specific(IVOperand)), m_APInt(C))) ||
          match(U,
                m_LShr(m_Shl(m_Value(), m_Specific(IVOperand)), m_APInt(C)))) {
        BinaryOperator *Shr = cast<BinaryOperator>(U);
        if (!Shr->isExact() && IVRange.getUnsignedMin().uge(*C)) {
          Shr->setIsExact(true);
          Changed = true;
        }
      }
    }
    return Changed;
  }

  return false;
}

/// Add all uses of Def to the current IV's worklist.
static void pushIVUsers(
  Instruction *Def, Loop *L,
  SmallPtrSet<Instruction*,16> &Simplified,
  SmallVectorImpl< std::pair<Instruction*,Instruction*> > &SimpleIVUsers) {

  for (User *U : Def->users()) {
    Instruction *UI = cast<Instruction>(U);

    // Avoid infinite or exponential worklist processing.
    // Also ensure unique worklist users.
    // If Def is a LoopPhi, it may not be in the Simplified set, so check for
    // self edges first.
    if (UI == Def)
      continue;

    // Only change the current Loop, do not change the other parts (e.g. other
    // Loops).
    if (!L->contains(UI))
      continue;

    // Do not push the same instruction more than once.
    if (!Simplified.insert(UI).second)
      continue;

    SimpleIVUsers.push_back(std::make_pair(UI, Def));
  }
}

/// Return true if this instruction generates a simple SCEV
/// expression in terms of that IV.
///
/// This is similar to IVUsers' isInteresting() but processes each instruction
/// non-recursively when the operand is already known to be a simpleIVUser.
///
static bool isSimpleIVUser(Instruction *I, const Loop *L, ScalarEvolution *SE) {
  if (!SE->isSCEVable(I->getType()))
    return false;

  // Get the symbolic expression for this instruction.
  const SCEV *S = SE->getSCEV(I);

  // Only consider affine recurrences.
  const SCEVAddRecExpr *AR = dyn_cast<SCEVAddRecExpr>(S);
  if (AR && AR->getLoop() == L)
    return true;

  return false;
}

/// Iteratively perform simplification on a worklist of users
/// of the specified induction variable. Each successive simplification may push
/// more users which may themselves be candidates for simplification.
///
/// This algorithm does not require IVUsers analysis. Instead, it simplifies
/// instructions in-place during analysis. Rather than rewriting induction
/// variables bottom-up from their users, it transforms a chain of IVUsers
/// top-down, updating the IR only when it encounters a clear optimization
/// opportunity.
///
/// Once DisableIVRewrite is default, LSR will be the only client of IVUsers.
///
void SimplifyIndvar::simplifyUsers(PHINode *CurrIV, IVVisitor *V) {
  if (!SE->isSCEVable(CurrIV->getType()))
    return;

  // Instructions processed by SimplifyIndvar for CurrIV.
  SmallPtrSet<Instruction*,16> Simplified;

  // Use-def pairs if IV users waiting to be processed for CurrIV.
  SmallVector<std::pair<Instruction*, Instruction*>, 8> SimpleIVUsers;

  // Push users of the current LoopPhi. In rare cases, pushIVUsers may be
  // called multiple times for the same LoopPhi. This is the proper thing to
  // do for loop header phis that use each other.
  pushIVUsers(CurrIV, L, Simplified, SimpleIVUsers);

  while (!SimpleIVUsers.empty()) {
    std::pair<Instruction*, Instruction*> UseOper =
      SimpleIVUsers.pop_back_val();
    Instruction *UseInst = UseOper.first;

    // If a user of the IndVar is trivially dead, we prefer just to mark it dead
    // rather than try to do some complex analysis or transformation (such as
    // widening) basing on it.
    // TODO: Propagate TLI and pass it here to handle more cases.
    if (isInstructionTriviallyDead(UseInst, /* TLI */ nullptr)) {
      DeadInsts.emplace_back(UseInst);
      continue;
    }

    // Bypass back edges to avoid extra work.
    if (UseInst == CurrIV) continue;

    // Try to replace UseInst with a loop invariant before any other
    // simplifications.
    if (replaceIVUserWithLoopInvariant(UseInst))
      continue;

    Instruction *IVOperand = UseOper.second;
    for (unsigned N = 0; IVOperand; ++N) {
      assert(N <= Simplified.size() && "runaway iteration");

      Value *NewOper = foldIVUser(UseInst, IVOperand);
      if (!NewOper)
        break; // done folding
      IVOperand = dyn_cast<Instruction>(NewOper);
    }
    if (!IVOperand)
      continue;

    if (eliminateIVUser(UseInst, IVOperand)) {
      pushIVUsers(IVOperand, L, Simplified, SimpleIVUsers);
      continue;
    }

    if (BinaryOperator *BO = dyn_cast<BinaryOperator>(UseInst)) {
      if ((isa<OverflowingBinaryOperator>(BO) &&
           strengthenOverflowingOperation(BO, IVOperand)) ||
          (isa<ShlOperator>(BO) && strengthenRightShift(BO, IVOperand))) {
        // re-queue uses of the now modified binary operator and fall
        // through to the checks that remain.
        pushIVUsers(IVOperand, L, Simplified, SimpleIVUsers);
      }
    }

    CastInst *Cast = dyn_cast<CastInst>(UseInst);
    if (V && Cast) {
      V->visitCast(Cast);
      continue;
    }
    if (isSimpleIVUser(UseInst, L, SE)) {
      pushIVUsers(UseInst, L, Simplified, SimpleIVUsers);
    }
  }
}

namespace llvm {

void IVVisitor::anchor() { }

/// Simplify instructions that use this induction variable
/// by using ScalarEvolution to analyze the IV's recurrence.
bool simplifyUsersOfIV(PHINode *CurrIV, ScalarEvolution *SE, DominatorTree *DT,
                       LoopInfo *LI, const TargetTransformInfo *TTI,
                       SmallVectorImpl<WeakTrackingVH> &Dead,
                       SCEVExpander &Rewriter, IVVisitor *V) {
  SimplifyIndvar SIV(LI->getLoopFor(CurrIV->getParent()), SE, DT, LI, TTI,
                     Rewriter, Dead);
  SIV.simplifyUsers(CurrIV, V);
  return SIV.hasChanged();
}

/// Simplify users of induction variables within this
/// loop. This does not actually change or add IVs.
bool simplifyLoopIVs(Loop *L, ScalarEvolution *SE, DominatorTree *DT,
                     LoopInfo *LI, const TargetTransformInfo *TTI,
                     SmallVectorImpl<WeakTrackingVH> &Dead) {
  SCEVExpander Rewriter(*SE, SE->getDataLayout(), "indvars");
#ifndef NDEBUG
  Rewriter.setDebugType(DEBUG_TYPE);
#endif
  bool Changed = false;
  for (BasicBlock::iterator I = L->getHeader()->begin(); isa<PHINode>(I); ++I) {
    Changed |=
        simplifyUsersOfIV(cast<PHINode>(I), SE, DT, LI, TTI, Dead, Rewriter);
  }
  return Changed;
}

} // namespace llvm

//===----------------------------------------------------------------------===//
// Widen Induction Variables - Extend the width of an IV to cover its
// widest uses.
//===----------------------------------------------------------------------===//

class WidenIV {
  // Parameters
  PHINode *OrigPhi;
  Type *WideType;

  // Context
  LoopInfo        *LI;
  Loop            *L;
  ScalarEvolution *SE;
  DominatorTree   *DT;

  // Does the module have any calls to the llvm.experimental.guard intrinsic
  // at all? If not we can avoid scanning instructions looking for guards.
  bool HasGuards;

  bool UsePostIncrementRanges;

  // Statistics
  unsigned NumElimExt = 0;
  unsigned NumWidened = 0;

  // Result
  PHINode *WidePhi = nullptr;
  Instruction *WideInc = nullptr;
  const SCEV *WideIncExpr = nullptr;
  SmallVectorImpl<WeakTrackingVH> &DeadInsts;

  SmallPtrSet<Instruction *,16> Widened;

  enum ExtendKind { ZeroExtended, SignExtended, Unknown };

  // A map tracking the kind of extension used to widen each narrow IV
  // and narrow IV user.
  // Key: pointer to a narrow IV or IV user.
  // Value: the kind of extension used to widen this Instruction.
  DenseMap<AssertingVH<Instruction>, ExtendKind> ExtendKindMap;

  using DefUserPair = std::pair<AssertingVH<Value>, AssertingVH<Instruction>>;

  // A map with control-dependent ranges for post increment IV uses. The key is
  // a pair of IV def and a use of this def denoting the context. The value is
  // a ConstantRange representing possible values of the def at the given
  // context.
  DenseMap<DefUserPair, ConstantRange> PostIncRangeInfos;

  Optional<ConstantRange> getPostIncRangeInfo(Value *Def,
                                              Instruction *UseI) {
    DefUserPair Key(Def, UseI);
    auto It = PostIncRangeInfos.find(Key);
    return It == PostIncRangeInfos.end()
               ? Optional<ConstantRange>(None)
               : Optional<ConstantRange>(It->second);
  }

  void calculatePostIncRanges(PHINode *OrigPhi);
  void calculatePostIncRange(Instruction *NarrowDef, Instruction *NarrowUser);

  void updatePostIncRangeInfo(Value *Def, Instruction *UseI, ConstantRange R) {
    DefUserPair Key(Def, UseI);
    auto It = PostIncRangeInfos.find(Key);
    if (It == PostIncRangeInfos.end())
      PostIncRangeInfos.insert({Key, R});
    else
      It->second = R.intersectWith(It->second);
  }

public:
  /// Record a link in the Narrow IV def-use chain along with the WideIV that
  /// computes the same value as the Narrow IV def.  This avoids caching Use*
  /// pointers.
  struct NarrowIVDefUse {
    Instruction *NarrowDef = nullptr;
    Instruction *NarrowUse = nullptr;
    Instruction *WideDef = nullptr;

    // True if the narrow def is never negative.  Tracking this information lets
    // us use a sign extension instead of a zero extension or vice versa, when
    // profitable and legal.
    bool NeverNegative = false;

    NarrowIVDefUse(Instruction *ND, Instruction *NU, Instruction *WD,
                   bool NeverNegative)
        : NarrowDef(ND), NarrowUse(NU), WideDef(WD),
          NeverNegative(NeverNegative) {}
  };

  WidenIV(const WideIVInfo &WI, LoopInfo *LInfo, ScalarEvolution *SEv,
          DominatorTree *DTree, SmallVectorImpl<WeakTrackingVH> &DI,
          bool HasGuards, bool UsePostIncrementRanges = true);

  PHINode *createWideIV(SCEVExpander &Rewriter);

  unsigned getNumElimExt() { return NumElimExt; };
  unsigned getNumWidened() { return NumWidened; };

protected:
  Value *createExtendInst(Value *NarrowOper, Type *WideType, bool IsSigned,
                          Instruction *Use);

  Instruction *cloneIVUser(NarrowIVDefUse DU, const SCEVAddRecExpr *WideAR);
  Instruction *cloneArithmeticIVUser(NarrowIVDefUse DU,
                                     const SCEVAddRecExpr *WideAR);
  Instruction *cloneBitwiseIVUser(NarrowIVDefUse DU);

  ExtendKind getExtendKind(Instruction *I);

  using WidenedRecTy = std::pair<const SCEVAddRecExpr *, ExtendKind>;

  WidenedRecTy getWideRecurrence(NarrowIVDefUse DU);

  WidenedRecTy getExtendedOperandRecurrence(NarrowIVDefUse DU);

  const SCEV *getSCEVByOpCode(const SCEV *LHS, const SCEV *RHS,
                              unsigned OpCode) const;

  Instruction *widenIVUse(NarrowIVDefUse DU, SCEVExpander &Rewriter);

  bool widenLoopCompare(NarrowIVDefUse DU);
  bool widenWithVariantUse(NarrowIVDefUse DU);

  void pushNarrowIVUsers(Instruction *NarrowDef, Instruction *WideDef);

private:
  SmallVector<NarrowIVDefUse, 8> NarrowIVUsers;
};


/// Determine the insertion point for this user. By default, insert immediately
/// before the user. SCEVExpander or LICM will hoist loop invariants out of the
/// loop. For PHI nodes, there may be multiple uses, so compute the nearest
/// common dominator for the incoming blocks. A nullptr can be returned if no
/// viable location is found: it may happen if User is a PHI and Def only comes
/// to this PHI from unreachable blocks.
static Instruction *getInsertPointForUses(Instruction *User, Value *Def,
                                          DominatorTree *DT, LoopInfo *LI) {
  PHINode *PHI = dyn_cast<PHINode>(User);
  if (!PHI)
    return User;

  Instruction *InsertPt = nullptr;
  for (unsigned i = 0, e = PHI->getNumIncomingValues(); i != e; ++i) {
    if (PHI->getIncomingValue(i) != Def)
      continue;

    BasicBlock *InsertBB = PHI->getIncomingBlock(i);

    if (!DT->isReachableFromEntry(InsertBB))
      continue;

    if (!InsertPt) {
      InsertPt = InsertBB->getTerminator();
      continue;
    }
    InsertBB = DT->findNearestCommonDominator(InsertPt->getParent(), InsertBB);
    InsertPt = InsertBB->getTerminator();
  }

  // If we have skipped all inputs, it means that Def only comes to Phi from
  // unreachable blocks.
  if (!InsertPt)
    return nullptr;

  auto *DefI = dyn_cast<Instruction>(Def);
  if (!DefI)
    return InsertPt;

  assert(DT->dominates(DefI, InsertPt) && "def does not dominate all uses");

  auto *L = LI->getLoopFor(DefI->getParent());
  assert(!L || L->contains(LI->getLoopFor(InsertPt->getParent())));

  for (auto *DTN = (*DT)[InsertPt->getParent()]; DTN; DTN = DTN->getIDom())
    if (LI->getLoopFor(DTN->getBlock()) == L)
      return DTN->getBlock()->getTerminator();

  llvm_unreachable("DefI dominates InsertPt!");
}

WidenIV::WidenIV(const WideIVInfo &WI, LoopInfo *LInfo, ScalarEvolution *SEv,
          DominatorTree *DTree, SmallVectorImpl<WeakTrackingVH> &DI,
          bool HasGuards, bool UsePostIncrementRanges)
      : OrigPhi(WI.NarrowIV), WideType(WI.WidestNativeType), LI(LInfo),
        L(LI->getLoopFor(OrigPhi->getParent())), SE(SEv), DT(DTree),
        HasGuards(HasGuards), UsePostIncrementRanges(UsePostIncrementRanges),
        DeadInsts(DI) {
    assert(L->getHeader() == OrigPhi->getParent() && "Phi must be an IV");
    ExtendKindMap[OrigPhi] = WI.IsSigned ? SignExtended : ZeroExtended;
}

Value *WidenIV::createExtendInst(Value *NarrowOper, Type *WideType,
                                 bool IsSigned, Instruction *Use) {
  // Set the debug location and conservative insertion point.
  IRBuilder<> Builder(Use);
  // Hoist the insertion point into loop preheaders as far as possible.
  for (const Loop *L = LI->getLoopFor(Use->getParent());
       L && L->getLoopPreheader() && L->isLoopInvariant(NarrowOper);
       L = L->getParentLoop())
    Builder.SetInsertPoint(L->getLoopPreheader()->getTerminator());

  return IsSigned ? Builder.CreateSExt(NarrowOper, WideType) :
                    Builder.CreateZExt(NarrowOper, WideType);
}

/// Instantiate a wide operation to replace a narrow operation. This only needs
/// to handle operations that can evaluation to SCEVAddRec. It can safely return
/// 0 for any operation we decide not to clone.
Instruction *WidenIV::cloneIVUser(WidenIV::NarrowIVDefUse DU,
                                  const SCEVAddRecExpr *WideAR) {
  unsigned Opcode = DU.NarrowUse->getOpcode();
  switch (Opcode) {
  default:
    return nullptr;
  case Instruction::Add:
  case Instruction::Mul:
  case Instruction::UDiv:
  case Instruction::Sub:
    return cloneArithmeticIVUser(DU, WideAR);

  case Instruction::And:
  case Instruction::Or:
  case Instruction::Xor:
  case Instruction::Shl:
  case Instruction::LShr:
  case Instruction::AShr:
    return cloneBitwiseIVUser(DU);
  }
}

Instruction *WidenIV::cloneBitwiseIVUser(WidenIV::NarrowIVDefUse DU) {
  Instruction *NarrowUse = DU.NarrowUse;
  Instruction *NarrowDef = DU.NarrowDef;
  Instruction *WideDef = DU.WideDef;

  LLVM_DEBUG(dbgs() << "Cloning bitwise IVUser: " << *NarrowUse << "\n");

  // Replace NarrowDef operands with WideDef. Otherwise, we don't know anything
  // about the narrow operand yet so must insert a [sz]ext. It is probably loop
  // invariant and will be folded or hoisted. If it actually comes from a
  // widened IV, it should be removed during a future call to widenIVUse.
  bool IsSigned = getExtendKind(NarrowDef) == SignExtended;
  Value *LHS = (NarrowUse->getOperand(0) == NarrowDef)
                   ? WideDef
                   : createExtendInst(NarrowUse->getOperand(0), WideType,
                                      IsSigned, NarrowUse);
  Value *RHS = (NarrowUse->getOperand(1) == NarrowDef)
                   ? WideDef
                   : createExtendInst(NarrowUse->getOperand(1), WideType,
                                      IsSigned, NarrowUse);

  auto *NarrowBO = cast<BinaryOperator>(NarrowUse);
  auto *WideBO = BinaryOperator::Create(NarrowBO->getOpcode(), LHS, RHS,
                                        NarrowBO->getName());
  IRBuilder<> Builder(NarrowUse);
  Builder.Insert(WideBO);
  WideBO->copyIRFlags(NarrowBO);
  return WideBO;
}

Instruction *WidenIV::cloneArithmeticIVUser(WidenIV::NarrowIVDefUse DU,
                                            const SCEVAddRecExpr *WideAR) {
  Instruction *NarrowUse = DU.NarrowUse;
  Instruction *NarrowDef = DU.NarrowDef;
  Instruction *WideDef = DU.WideDef;

  LLVM_DEBUG(dbgs() << "Cloning arithmetic IVUser: " << *NarrowUse << "\n");

  unsigned IVOpIdx = (NarrowUse->getOperand(0) == NarrowDef) ? 0 : 1;

  // We're trying to find X such that
  //
  //  Widen(NarrowDef `op` NonIVNarrowDef) == WideAR == WideDef `op.wide` X
  //
  // We guess two solutions to X, sext(NonIVNarrowDef) and zext(NonIVNarrowDef),
  // and check using SCEV if any of them are correct.

  // Returns true if extending NonIVNarrowDef according to `SignExt` is a
  // correct solution to X.
  auto GuessNonIVOperand = [&](bool SignExt) {
    const SCEV *WideLHS;
    const SCEV *WideRHS;

    auto GetExtend = [this, SignExt](const SCEV *S, Type *Ty) {
      if (SignExt)
        return SE->getSignExtendExpr(S, Ty);
      return SE->getZeroExtendExpr(S, Ty);
    };

    if (IVOpIdx == 0) {
      WideLHS = SE->getSCEV(WideDef);
      const SCEV *NarrowRHS = SE->getSCEV(NarrowUse->getOperand(1));
      WideRHS = GetExtend(NarrowRHS, WideType);
    } else {
      const SCEV *NarrowLHS = SE->getSCEV(NarrowUse->getOperand(0));
      WideLHS = GetExtend(NarrowLHS, WideType);
      WideRHS = SE->getSCEV(WideDef);
    }

    // WideUse is "WideDef `op.wide` X" as described in the comment.
    const SCEV *WideUse =
      getSCEVByOpCode(WideLHS, WideRHS, NarrowUse->getOpcode());

    return WideUse == WideAR;
  };

  bool SignExtend = getExtendKind(NarrowDef) == SignExtended;
  if (!GuessNonIVOperand(SignExtend)) {
    SignExtend = !SignExtend;
    if (!GuessNonIVOperand(SignExtend))
      return nullptr;
  }

  Value *LHS = (NarrowUse->getOperand(0) == NarrowDef)
                   ? WideDef
                   : createExtendInst(NarrowUse->getOperand(0), WideType,
                                      SignExtend, NarrowUse);
  Value *RHS = (NarrowUse->getOperand(1) == NarrowDef)
                   ? WideDef
                   : createExtendInst(NarrowUse->getOperand(1), WideType,
                                      SignExtend, NarrowUse);

  auto *NarrowBO = cast<BinaryOperator>(NarrowUse);
  auto *WideBO = BinaryOperator::Create(NarrowBO->getOpcode(), LHS, RHS,
                                        NarrowBO->getName());

  IRBuilder<> Builder(NarrowUse);
  Builder.Insert(WideBO);
  WideBO->copyIRFlags(NarrowBO);
  return WideBO;
}

WidenIV::ExtendKind WidenIV::getExtendKind(Instruction *I) {
  auto It = ExtendKindMap.find(I);
  assert(It != ExtendKindMap.end() && "Instruction not yet extended!");
  return It->second;
}

const SCEV *WidenIV::getSCEVByOpCode(const SCEV *LHS, const SCEV *RHS,
                                     unsigned OpCode) const {
  switch (OpCode) {
  case Instruction::Add:
    return SE->getAddExpr(LHS, RHS);
  case Instruction::Sub:
    return SE->getMinusSCEV(LHS, RHS);
  case Instruction::Mul:
    return SE->getMulExpr(LHS, RHS);
  case Instruction::UDiv:
    return SE->getUDivExpr(LHS, RHS);
  default:
    llvm_unreachable("Unsupported opcode.");
  };
}

/// No-wrap operations can transfer sign extension of their result to their
/// operands. Generate the SCEV value for the widened operation without
/// actually modifying the IR yet. If the expression after extending the
/// operands is an AddRec for this loop, return the AddRec and the kind of
/// extension used.
WidenIV::WidenedRecTy
WidenIV::getExtendedOperandRecurrence(WidenIV::NarrowIVDefUse DU) {
  // Handle the common case of add<nsw/nuw>
  const unsigned OpCode = DU.NarrowUse->getOpcode();
  // Only Add/Sub/Mul instructions supported yet.
  if (OpCode != Instruction::Add && OpCode != Instruction::Sub &&
      OpCode != Instruction::Mul)
    return {nullptr, Unknown};

  // One operand (NarrowDef) has already been extended to WideDef. Now determine
  // if extending the other will lead to a recurrence.
  const unsigned ExtendOperIdx =
      DU.NarrowUse->getOperand(0) == DU.NarrowDef ? 1 : 0;
  assert(DU.NarrowUse->getOperand(1-ExtendOperIdx) == DU.NarrowDef && "bad DU");

  const SCEV *ExtendOperExpr = nullptr;
  const OverflowingBinaryOperator *OBO =
    cast<OverflowingBinaryOperator>(DU.NarrowUse);
  ExtendKind ExtKind = getExtendKind(DU.NarrowDef);
  if (ExtKind == SignExtended && OBO->hasNoSignedWrap())
    ExtendOperExpr = SE->getSignExtendExpr(
      SE->getSCEV(DU.NarrowUse->getOperand(ExtendOperIdx)), WideType);
  else if(ExtKind == ZeroExtended && OBO->hasNoUnsignedWrap())
    ExtendOperExpr = SE->getZeroExtendExpr(
      SE->getSCEV(DU.NarrowUse->getOperand(ExtendOperIdx)), WideType);
  else
    return {nullptr, Unknown};

  // When creating this SCEV expr, don't apply the current operations NSW or NUW
  // flags. This instruction may be guarded by control flow that the no-wrap
  // behavior depends on. Non-control-equivalent instructions can be mapped to
  // the same SCEV expression, and it would be incorrect to transfer NSW/NUW
  // semantics to those operations.
  const SCEV *lhs = SE->getSCEV(DU.WideDef);
  const SCEV *rhs = ExtendOperExpr;

  // Let's swap operands to the initial order for the case of non-commutative
  // operations, like SUB. See PR21014.
  if (ExtendOperIdx == 0)
    std::swap(lhs, rhs);
  const SCEVAddRecExpr *AddRec =
      dyn_cast<SCEVAddRecExpr>(getSCEVByOpCode(lhs, rhs, OpCode));

  if (!AddRec || AddRec->getLoop() != L)
    return {nullptr, Unknown};

  return {AddRec, ExtKind};
}

/// Is this instruction potentially interesting for further simplification after
/// widening it's type? In other words, can the extend be safely hoisted out of
/// the loop with SCEV reducing the value to a recurrence on the same loop. If
/// so, return the extended recurrence and the kind of extension used. Otherwise
/// return {nullptr, Unknown}.
WidenIV::WidenedRecTy WidenIV::getWideRecurrence(WidenIV::NarrowIVDefUse DU) {
  if (!SE->isSCEVable(DU.NarrowUse->getType()))
    return {nullptr, Unknown};

  const SCEV *NarrowExpr = SE->getSCEV(DU.NarrowUse);
  if (SE->getTypeSizeInBits(NarrowExpr->getType()) >=
      SE->getTypeSizeInBits(WideType)) {
    // NarrowUse implicitly widens its operand. e.g. a gep with a narrow
    // index. So don't follow this use.
    return {nullptr, Unknown};
  }

  const SCEV *WideExpr;
  ExtendKind ExtKind;
  if (DU.NeverNegative) {
    WideExpr = SE->getSignExtendExpr(NarrowExpr, WideType);
    if (isa<SCEVAddRecExpr>(WideExpr))
      ExtKind = SignExtended;
    else {
      WideExpr = SE->getZeroExtendExpr(NarrowExpr, WideType);
      ExtKind = ZeroExtended;
    }
  } else if (getExtendKind(DU.NarrowDef) == SignExtended) {
    WideExpr = SE->getSignExtendExpr(NarrowExpr, WideType);
    ExtKind = SignExtended;
  } else {
    WideExpr = SE->getZeroExtendExpr(NarrowExpr, WideType);
    ExtKind = ZeroExtended;
  }
  const SCEVAddRecExpr *AddRec = dyn_cast<SCEVAddRecExpr>(WideExpr);
  if (!AddRec || AddRec->getLoop() != L)
    return {nullptr, Unknown};
  return {AddRec, ExtKind};
}

/// This IV user cannot be widened. Replace this use of the original narrow IV
/// with a truncation of the new wide IV to isolate and eliminate the narrow IV.
static void truncateIVUse(WidenIV::NarrowIVDefUse DU, DominatorTree *DT,
                          LoopInfo *LI) {
  auto *InsertPt = getInsertPointForUses(DU.NarrowUse, DU.NarrowDef, DT, LI);
  if (!InsertPt)
    return;
  LLVM_DEBUG(dbgs() << "INDVARS: Truncate IV " << *DU.WideDef << " for user "
                    << *DU.NarrowUse << "\n");
  IRBuilder<> Builder(InsertPt);
  Value *Trunc = Builder.CreateTrunc(DU.WideDef, DU.NarrowDef->getType());
  DU.NarrowUse->replaceUsesOfWith(DU.NarrowDef, Trunc);
}

/// If the narrow use is a compare instruction, then widen the compare
//  (and possibly the other operand).  The extend operation is hoisted into the
// loop preheader as far as possible.
bool WidenIV::widenLoopCompare(WidenIV::NarrowIVDefUse DU) {
  ICmpInst *Cmp = dyn_cast<ICmpInst>(DU.NarrowUse);
  if (!Cmp)
    return false;

  // We can legally widen the comparison in the following two cases:
  //
  //  - The signedness of the IV extension and comparison match
  //
  //  - The narrow IV is always positive (and thus its sign extension is equal
  //    to its zero extension).  For instance, let's say we're zero extending
  //    %narrow for the following use
  //
  //      icmp slt i32 %narrow, %val   ... (A)
  //
  //    and %narrow is always positive.  Then
  //
  //      (A) == icmp slt i32 sext(%narrow), sext(%val)
  //          == icmp slt i32 zext(%narrow), sext(%val)
  bool IsSigned = getExtendKind(DU.NarrowDef) == SignExtended;
  if (!(DU.NeverNegative || IsSigned == Cmp->isSigned()))
    return false;

  Value *Op = Cmp->getOperand(Cmp->getOperand(0) == DU.NarrowDef ? 1 : 0);
  unsigned CastWidth = SE->getTypeSizeInBits(Op->getType());
  unsigned IVWidth = SE->getTypeSizeInBits(WideType);
  assert(CastWidth <= IVWidth && "Unexpected width while widening compare.");

  // Widen the compare instruction.
  auto *InsertPt = getInsertPointForUses(DU.NarrowUse, DU.NarrowDef, DT, LI);
  if (!InsertPt)
    return false;
  IRBuilder<> Builder(InsertPt);
  DU.NarrowUse->replaceUsesOfWith(DU.NarrowDef, DU.WideDef);

  // Widen the other operand of the compare, if necessary.
  if (CastWidth < IVWidth) {
    Value *ExtOp = createExtendInst(Op, WideType, Cmp->isSigned(), Cmp);
    DU.NarrowUse->replaceUsesOfWith(Op, ExtOp);
  }
  return true;
}

// The widenIVUse avoids generating trunc by evaluating the use as AddRec, this
// will not work when:
//    1) SCEV traces back to an instruction inside the loop that SCEV can not
// expand, eg. add %indvar, (load %addr)
//    2) SCEV finds a loop variant, eg. add %indvar, %loopvariant
// While SCEV fails to avoid trunc, we can still try to use instruction
// combining approach to prove trunc is not required. This can be further
// extended with other instruction combining checks, but for now we handle the
// following case (sub can be "add" and "mul", "nsw + sext" can be "nus + zext")
//
// Src:
//   %c = sub nsw %b, %indvar
//   %d = sext %c to i64
// Dst:
//   %indvar.ext1 = sext %indvar to i64
//   %m = sext %b to i64
//   %d = sub nsw i64 %m, %indvar.ext1
// Therefore, as long as the result of add/sub/mul is extended to wide type, no
// trunc is required regardless of how %b is generated. This pattern is common
// when calculating address in 64 bit architecture
bool WidenIV::widenWithVariantUse(WidenIV::NarrowIVDefUse DU) {
  Instruction *NarrowUse = DU.NarrowUse;
  Instruction *NarrowDef = DU.NarrowDef;
  Instruction *WideDef = DU.WideDef;

  // Handle the common case of add<nsw/nuw>
  const unsigned OpCode = NarrowUse->getOpcode();
  // Only Add/Sub/Mul instructions are supported.
  if (OpCode != Instruction::Add && OpCode != Instruction::Sub &&
      OpCode != Instruction::Mul)
    return false;

  // The operand that is not defined by NarrowDef of DU. Let's call it the
  // other operand.
  assert((NarrowUse->getOperand(0) == NarrowDef ||
          NarrowUse->getOperand(1) == NarrowDef) &&
         "bad DU");

  const OverflowingBinaryOperator *OBO =
    cast<OverflowingBinaryOperator>(NarrowUse);
  ExtendKind ExtKind = getExtendKind(NarrowDef);
  bool CanSignExtend = ExtKind == SignExtended && OBO->hasNoSignedWrap();
  bool CanZeroExtend = ExtKind == ZeroExtended && OBO->hasNoUnsignedWrap();
  auto AnotherOpExtKind = ExtKind;

  // Check that all uses are either:
  // - narrow def (in case of we are widening the IV increment);
  // - single-input LCSSA Phis;
  // - comparison of the chosen type;
  // - extend of the chosen type (raison d'etre).
  SmallVector<Instruction *, 4> ExtUsers;
  SmallVector<PHINode *, 4> LCSSAPhiUsers;
  SmallVector<ICmpInst *, 4> ICmpUsers;
  for (Use &U : NarrowUse->uses()) {
    Instruction *User = cast<Instruction>(U.getUser());
    if (User == NarrowDef)
      continue;
    if (!L->contains(User)) {
      auto *LCSSAPhi = cast<PHINode>(User);
      // Make sure there is only 1 input, so that we don't have to split
      // critical edges.
      if (LCSSAPhi->getNumOperands() != 1)
        return false;
      LCSSAPhiUsers.push_back(LCSSAPhi);
      continue;
    }
    if (auto *ICmp = dyn_cast<ICmpInst>(User)) {
      auto Pred = ICmp->getPredicate();
      // We have 3 types of predicates: signed, unsigned and equality
      // predicates. For equality, it's legal to widen icmp for either sign and
      // zero extend. For sign extend, we can also do so for signed predicates,
      // likeweise for zero extend we can widen icmp for unsigned predicates.
      if (ExtKind == ZeroExtended && ICmpInst::isSigned(Pred))
        return false;
      if (ExtKind == SignExtended && ICmpInst::isUnsigned(Pred))
        return false;
      ICmpUsers.push_back(ICmp);
      continue;
    }
    if (ExtKind == SignExtended)
      User = dyn_cast<SExtInst>(User);
    else
      User = dyn_cast<ZExtInst>(User);
    if (!User || User->getType() != WideType)
      return false;
    ExtUsers.push_back(User);
  }
  if (ExtUsers.empty()) {
    DeadInsts.emplace_back(NarrowUse);
    return true;
  }

  // We'll prove some facts that should be true in the context of ext users. If
  // there is no users, we are done now. If there are some, pick their common
  // dominator as context.
  Instruction *Context = nullptr;
  for (auto *Ext : ExtUsers) {
    if (!Context || DT->dominates(Ext, Context))
      Context = Ext;
    else if (!DT->dominates(Context, Ext))
      // For users that don't have dominance relation, use common dominator.
      Context =
          DT->findNearestCommonDominator(Context->getParent(), Ext->getParent())
              ->getTerminator();
  }
  assert(Context && "Context not found?");

  if (!CanSignExtend && !CanZeroExtend) {
    // Because InstCombine turns 'sub nuw' to 'add' losing the no-wrap flag, we
    // will most likely not see it. Let's try to prove it.
    if (OpCode != Instruction::Add)
      return false;
    if (ExtKind != ZeroExtended)
      return false;
    const SCEV *LHS = SE->getSCEV(OBO->getOperand(0));
    const SCEV *RHS = SE->getSCEV(OBO->getOperand(1));
    // TODO: Support case for NarrowDef = NarrowUse->getOperand(1).
    if (NarrowUse->getOperand(0) != NarrowDef)
      return false;
    if (!SE->isKnownNegative(RHS))
      return false;
    bool ProvedSubNUW = SE->isKnownPredicateAt(
        ICmpInst::ICMP_UGE, LHS, SE->getNegativeSCEV(RHS), Context);
    if (!ProvedSubNUW)
      return false;
    // In fact, our 'add' is 'sub nuw'. We will need to widen the 2nd operand as
    // neg(zext(neg(op))), which is basically sext(op).
    AnotherOpExtKind = SignExtended;
  }

  // Verifying that Defining operand is an AddRec
  const SCEV *Op1 = SE->getSCEV(WideDef);
  const SCEVAddRecExpr *AddRecOp1 = dyn_cast<SCEVAddRecExpr>(Op1);
  if (!AddRecOp1 || AddRecOp1->getLoop() != L)
    return false;

  LLVM_DEBUG(dbgs() << "Cloning arithmetic IVUser: " << *NarrowUse << "\n");

  // Generating a widening use instruction.
  Value *LHS = (NarrowUse->getOperand(0) == NarrowDef)
                   ? WideDef
                   : createExtendInst(NarrowUse->getOperand(0), WideType,
                                      AnotherOpExtKind, NarrowUse);
  Value *RHS = (NarrowUse->getOperand(1) == NarrowDef)
                   ? WideDef
                   : createExtendInst(NarrowUse->getOperand(1), WideType,
                                      AnotherOpExtKind, NarrowUse);

  auto *NarrowBO = cast<BinaryOperator>(NarrowUse);
  auto *WideBO = BinaryOperator::Create(NarrowBO->getOpcode(), LHS, RHS,
                                        NarrowBO->getName());
  IRBuilder<> Builder(NarrowUse);
  Builder.Insert(WideBO);
  WideBO->copyIRFlags(NarrowBO);
  ExtendKindMap[NarrowUse] = ExtKind;

  for (Instruction *User : ExtUsers) {
    assert(User->getType() == WideType && "Checked before!");
    LLVM_DEBUG(dbgs() << "INDVARS: eliminating " << *User << " replaced by "
                      << *WideBO << "\n");
    ++NumElimExt;
    User->replaceAllUsesWith(WideBO);
    DeadInsts.emplace_back(User);
  }

  for (PHINode *User : LCSSAPhiUsers) {
    assert(User->getNumOperands() == 1 && "Checked before!");
    Builder.SetInsertPoint(User);
    auto *WidePN =
        Builder.CreatePHI(WideBO->getType(), 1, User->getName() + ".wide");
    BasicBlock *LoopExitingBlock = User->getParent()->getSinglePredecessor();
    assert(LoopExitingBlock && L->contains(LoopExitingBlock) &&
           "Not a LCSSA Phi?");
    WidePN->addIncoming(WideBO, LoopExitingBlock);
    Builder.SetInsertPoint(&*User->getParent()->getFirstInsertionPt());
    auto *TruncPN = Builder.CreateTrunc(WidePN, User->getType());
    User->replaceAllUsesWith(TruncPN);
    DeadInsts.emplace_back(User);
  }

  for (ICmpInst *User : ICmpUsers) {
    Builder.SetInsertPoint(User);
    auto ExtendedOp = [&](Value * V)->Value * {
      if (V == NarrowUse)
        return WideBO;
      if (ExtKind == ZeroExtended)
        return Builder.CreateZExt(V, WideBO->getType());
      else
        return Builder.CreateSExt(V, WideBO->getType());
    };
    auto Pred = User->getPredicate();
    auto *LHS = ExtendedOp(User->getOperand(0));
    auto *RHS = ExtendedOp(User->getOperand(1));
    auto *WideCmp =
        Builder.CreateICmp(Pred, LHS, RHS, User->getName() + ".wide");
    User->replaceAllUsesWith(WideCmp);
    DeadInsts.emplace_back(User);
  }

  return true;
}

/// Determine whether an individual user of the narrow IV can be widened. If so,
/// return the wide clone of the user.
Instruction *WidenIV::widenIVUse(WidenIV::NarrowIVDefUse DU, SCEVExpander &Rewriter) {
  assert(ExtendKindMap.count(DU.NarrowDef) &&
         "Should already know the kind of extension used to widen NarrowDef");

  // Stop traversing the def-use chain at inner-loop phis or post-loop phis.
  if (PHINode *UsePhi = dyn_cast<PHINode>(DU.NarrowUse)) {
    if (LI->getLoopFor(UsePhi->getParent()) != L) {
      // For LCSSA phis, sink the truncate outside the loop.
      // After SimplifyCFG most loop exit targets have a single predecessor.
      // Otherwise fall back to a truncate within the loop.
      if (UsePhi->getNumOperands() != 1)
        truncateIVUse(DU, DT, LI);
      else {
        // Widening the PHI requires us to insert a trunc.  The logical place
        // for this trunc is in the same BB as the PHI.  This is not possible if
        // the BB is terminated by a catchswitch.
        if (isa<CatchSwitchInst>(UsePhi->getParent()->getTerminator()))
          return nullptr;

        PHINode *WidePhi =
          PHINode::Create(DU.WideDef->getType(), 1, UsePhi->getName() + ".wide",
                          UsePhi);
        WidePhi->addIncoming(DU.WideDef, UsePhi->getIncomingBlock(0));
        IRBuilder<> Builder(&*WidePhi->getParent()->getFirstInsertionPt());
        Value *Trunc = Builder.CreateTrunc(WidePhi, DU.NarrowDef->getType());
        UsePhi->replaceAllUsesWith(Trunc);
        DeadInsts.emplace_back(UsePhi);
        LLVM_DEBUG(dbgs() << "INDVARS: Widen lcssa phi " << *UsePhi << " to "
                          << *WidePhi << "\n");
      }
      return nullptr;
    }
  }

  // This narrow use can be widened by a sext if it's non-negative or its narrow
  // def was widended by a sext. Same for zext.
  auto canWidenBySExt = [&]() {
    return DU.NeverNegative || getExtendKind(DU.NarrowDef) == SignExtended;
  };
  auto canWidenByZExt = [&]() {
    return DU.NeverNegative || getExtendKind(DU.NarrowDef) == ZeroExtended;
  };

  // Our raison d'etre! Eliminate sign and zero extension.
  if ((isa<SExtInst>(DU.NarrowUse) && canWidenBySExt()) ||
      (isa<ZExtInst>(DU.NarrowUse) && canWidenByZExt())) {
    Value *NewDef = DU.WideDef;
    if (DU.NarrowUse->getType() != WideType) {
      unsigned CastWidth = SE->getTypeSizeInBits(DU.NarrowUse->getType());
      unsigned IVWidth = SE->getTypeSizeInBits(WideType);
      if (CastWidth < IVWidth) {
        // The cast isn't as wide as the IV, so insert a Trunc.
        IRBuilder<> Builder(DU.NarrowUse);
        NewDef = Builder.CreateTrunc(DU.WideDef, DU.NarrowUse->getType());
      }
      else {
        // A wider extend was hidden behind a narrower one. This may induce
        // another round of IV widening in which the intermediate IV becomes
        // dead. It should be very rare.
        LLVM_DEBUG(dbgs() << "INDVARS: New IV " << *WidePhi
                          << " not wide enough to subsume " << *DU.NarrowUse
                          << "\n");
        DU.NarrowUse->replaceUsesOfWith(DU.NarrowDef, DU.WideDef);
        NewDef = DU.NarrowUse;
      }
    }
    if (NewDef != DU.NarrowUse) {
      LLVM_DEBUG(dbgs() << "INDVARS: eliminating " << *DU.NarrowUse
                        << " replaced by " << *DU.WideDef << "\n");
      ++NumElimExt;
      DU.NarrowUse->replaceAllUsesWith(NewDef);
      DeadInsts.emplace_back(DU.NarrowUse);
    }
    // Now that the extend is gone, we want to expose it's uses for potential
    // further simplification. We don't need to directly inform SimplifyIVUsers
    // of the new users, because their parent IV will be processed later as a
    // new loop phi. If we preserved IVUsers analysis, we would also want to
    // push the uses of WideDef here.

    // No further widening is needed. The deceased [sz]ext had done it for us.
    return nullptr;
  }

  // Does this user itself evaluate to a recurrence after widening?
  WidenedRecTy WideAddRec = getExtendedOperandRecurrence(DU);
  if (!WideAddRec.first)
    WideAddRec = getWideRecurrence(DU);

  assert((WideAddRec.first == nullptr) == (WideAddRec.second == Unknown));
  if (!WideAddRec.first) {
    // If use is a loop condition, try to promote the condition instead of
    // truncating the IV first.
    if (widenLoopCompare(DU))
      return nullptr;

    // We are here about to generate a truncate instruction that may hurt
    // performance because the scalar evolution expression computed earlier
    // in WideAddRec.first does not indicate a polynomial induction expression.
    // In that case, look at the operands of the use instruction to determine
    // if we can still widen the use instead of truncating its operand.
    if (widenWithVariantUse(DU))
      return nullptr;

    // This user does not evaluate to a recurrence after widening, so don't
    // follow it. Instead insert a Trunc to kill off the original use,
    // eventually isolating the original narrow IV so it can be removed.
    truncateIVUse(DU, DT, LI);
    return nullptr;
  }
  // Assume block terminators cannot evaluate to a recurrence. We can't to
  // insert a Trunc after a terminator if there happens to be a critical edge.
  assert(DU.NarrowUse != DU.NarrowUse->getParent()->getTerminator() &&
         "SCEV is not expected to evaluate a block terminator");

  // Reuse the IV increment that SCEVExpander created as long as it dominates
  // NarrowUse.
  Instruction *WideUse = nullptr;
  if (WideAddRec.first == WideIncExpr &&
      Rewriter.hoistIVInc(WideInc, DU.NarrowUse))
    WideUse = WideInc;
  else {
    WideUse = cloneIVUser(DU, WideAddRec.first);
    if (!WideUse)
      return nullptr;
  }
  // Evaluation of WideAddRec ensured that the narrow expression could be
  // extended outside the loop without overflow. This suggests that the wide use
  // evaluates to the same expression as the extended narrow use, but doesn't
  // absolutely guarantee it. Hence the following failsafe check. In rare cases
  // where it fails, we simply throw away the newly created wide use.
  if (WideAddRec.first != SE->getSCEV(WideUse)) {
    LLVM_DEBUG(dbgs() << "Wide use expression mismatch: " << *WideUse << ": "
                      << *SE->getSCEV(WideUse) << " != " << *WideAddRec.first
                      << "\n");
    DeadInsts.emplace_back(WideUse);
    return nullptr;
  }

  // if we reached this point then we are going to replace
  // DU.NarrowUse with WideUse. Reattach DbgValue then.
  replaceAllDbgUsesWith(*DU.NarrowUse, *WideUse, *WideUse, *DT);

  ExtendKindMap[DU.NarrowUse] = WideAddRec.second;
  // Returning WideUse pushes it on the worklist.
  return WideUse;
}

/// Add eligible users of NarrowDef to NarrowIVUsers.
void WidenIV::pushNarrowIVUsers(Instruction *NarrowDef, Instruction *WideDef) {
  const SCEV *NarrowSCEV = SE->getSCEV(NarrowDef);
  bool NonNegativeDef =
      SE->isKnownPredicate(ICmpInst::ICMP_SGE, NarrowSCEV,
                           SE->getZero(NarrowSCEV->getType()));
  for (User *U : NarrowDef->users()) {
    Instruction *NarrowUser = cast<Instruction>(U);

    // Handle data flow merges and bizarre phi cycles.
    if (!Widened.insert(NarrowUser).second)
      continue;

    bool NonNegativeUse = false;
    if (!NonNegativeDef) {
      // We might have a control-dependent range information for this context.
      if (auto RangeInfo = getPostIncRangeInfo(NarrowDef, NarrowUser))
        NonNegativeUse = RangeInfo->getSignedMin().isNonNegative();
    }

    NarrowIVUsers.emplace_back(NarrowDef, NarrowUser, WideDef,
                               NonNegativeDef || NonNegativeUse);
  }
}

/// Process a single induction variable. First use the SCEVExpander to create a
/// wide induction variable that evaluates to the same recurrence as the
/// original narrow IV. Then use a worklist to forward traverse the narrow IV's
/// def-use chain. After widenIVUse has processed all interesting IV users, the
/// narrow IV will be isolated for removal by DeleteDeadPHIs.
///
/// It would be simpler to delete uses as they are processed, but we must avoid
/// invalidating SCEV expressions.
PHINode *WidenIV::createWideIV(SCEVExpander &Rewriter) {
  // Is this phi an induction variable?
  const SCEVAddRecExpr *AddRec = dyn_cast<SCEVAddRecExpr>(SE->getSCEV(OrigPhi));
  if (!AddRec)
    return nullptr;

  // Widen the induction variable expression.
  const SCEV *WideIVExpr = getExtendKind(OrigPhi) == SignExtended
                               ? SE->getSignExtendExpr(AddRec, WideType)
                               : SE->getZeroExtendExpr(AddRec, WideType);

  assert(SE->getEffectiveSCEVType(WideIVExpr->getType()) == WideType &&
         "Expect the new IV expression to preserve its type");

  // Can the IV be extended outside the loop without overflow?
  AddRec = dyn_cast<SCEVAddRecExpr>(WideIVExpr);
  if (!AddRec || AddRec->getLoop() != L)
    return nullptr;

  // An AddRec must have loop-invariant operands. Since this AddRec is
  // materialized by a loop header phi, the expression cannot have any post-loop
  // operands, so they must dominate the loop header.
  assert(
      SE->properlyDominates(AddRec->getStart(), L->getHeader()) &&
      SE->properlyDominates(AddRec->getStepRecurrence(*SE), L->getHeader()) &&
      "Loop header phi recurrence inputs do not dominate the loop");

  // Iterate over IV uses (including transitive ones) looking for IV increments
  // of the form 'add nsw %iv, <const>'. For each increment and each use of
  // the increment calculate control-dependent range information basing on
  // dominating conditions inside of the loop (e.g. a range check inside of the
  // loop). Calculated ranges are stored in PostIncRangeInfos map.
  //
  // Control-dependent range information is later used to prove that a narrow
  // definition is not negative (see pushNarrowIVUsers). It's difficult to do
  // this on demand because when pushNarrowIVUsers needs this information some
  // of the dominating conditions might be already widened.
  if (UsePostIncrementRanges)
    calculatePostIncRanges(OrigPhi);

  // The rewriter provides a value for the desired IV expression. This may
  // either find an existing phi or materialize a new one. Either way, we
  // expect a well-formed cyclic phi-with-increments. i.e. any operand not part
  // of the phi-SCC dominates the loop entry.
  Instruction *InsertPt = &*L->getHeader()->getFirstInsertionPt();
  Value *ExpandInst = Rewriter.expandCodeFor(AddRec, WideType, InsertPt);
  // If the wide phi is not a phi node, for example a cast node, like bitcast,
  // inttoptr, ptrtoint, just skip for now.
  if (!(WidePhi = dyn_cast<PHINode>(ExpandInst))) {
    // if the cast node is an inserted instruction without any user, we should
    // remove it to make sure the pass don't touch the function as we can not
    // wide the phi.
    if (ExpandInst->hasNUses(0) &&
        Rewriter.isInsertedInstruction(cast<Instruction>(ExpandInst)))
      DeadInsts.emplace_back(ExpandInst);
    return nullptr;
  }

  // Remembering the WideIV increment generated by SCEVExpander allows
  // widenIVUse to reuse it when widening the narrow IV's increment. We don't
  // employ a general reuse mechanism because the call above is the only call to
  // SCEVExpander. Henceforth, we produce 1-to-1 narrow to wide uses.
  if (BasicBlock *LatchBlock = L->getLoopLatch()) {
    WideInc =
      cast<Instruction>(WidePhi->getIncomingValueForBlock(LatchBlock));
    WideIncExpr = SE->getSCEV(WideInc);
    // Propagate the debug location associated with the original loop increment
    // to the new (widened) increment.
    auto *OrigInc =
      cast<Instruction>(OrigPhi->getIncomingValueForBlock(LatchBlock));
    WideInc->setDebugLoc(OrigInc->getDebugLoc());
  }

  LLVM_DEBUG(dbgs() << "Wide IV: " << *WidePhi << "\n");
  ++NumWidened;

  // Traverse the def-use chain using a worklist starting at the original IV.
  assert(Widened.empty() && NarrowIVUsers.empty() && "expect initial state" );

  Widened.insert(OrigPhi);
  pushNarrowIVUsers(OrigPhi, WidePhi);

  while (!NarrowIVUsers.empty()) {
    WidenIV::NarrowIVDefUse DU = NarrowIVUsers.pop_back_val();

    // Process a def-use edge. This may replace the use, so don't hold a
    // use_iterator across it.
    Instruction *WideUse = widenIVUse(DU, Rewriter);

    // Follow all def-use edges from the previous narrow use.
    if (WideUse)
      pushNarrowIVUsers(DU.NarrowUse, WideUse);

    // widenIVUse may have removed the def-use edge.
    if (DU.NarrowDef->use_empty())
      DeadInsts.emplace_back(DU.NarrowDef);
  }

  // Attach any debug information to the new PHI.
  replaceAllDbgUsesWith(*OrigPhi, *WidePhi, *WidePhi, *DT);

  return WidePhi;
}

/// Calculates control-dependent range for the given def at the given context
/// by looking at dominating conditions inside of the loop
void WidenIV::calculatePostIncRange(Instruction *NarrowDef,
                                    Instruction *NarrowUser) {
  using namespace llvm::PatternMatch;

  Value *NarrowDefLHS;
  const APInt *NarrowDefRHS;
  if (!match(NarrowDef, m_NSWAdd(m_Value(NarrowDefLHS),
                                 m_APInt(NarrowDefRHS))) ||
      !NarrowDefRHS->isNonNegative())
    return;

  auto UpdateRangeFromCondition = [&] (Value *Condition,
                                       bool TrueDest) {
    CmpInst::Predicate Pred;
    Value *CmpRHS;
    if (!match(Condition, m_ICmp(Pred, m_Specific(NarrowDefLHS),
                                 m_Value(CmpRHS))))
      return;

    CmpInst::Predicate P =
            TrueDest ? Pred : CmpInst::getInversePredicate(Pred);

    auto CmpRHSRange = SE->getSignedRange(SE->getSCEV(CmpRHS));
    auto CmpConstrainedLHSRange =
            ConstantRange::makeAllowedICmpRegion(P, CmpRHSRange);
    auto NarrowDefRange = CmpConstrainedLHSRange.addWithNoWrap(
        *NarrowDefRHS, OverflowingBinaryOperator::NoSignedWrap);

    updatePostIncRangeInfo(NarrowDef, NarrowUser, NarrowDefRange);
  };

  auto UpdateRangeFromGuards = [&](Instruction *Ctx) {
    if (!HasGuards)
      return;

    for (Instruction &I : make_range(Ctx->getIterator().getReverse(),
                                     Ctx->getParent()->rend())) {
      Value *C = nullptr;
      if (match(&I, m_Intrinsic<Intrinsic::experimental_guard>(m_Value(C))))
        UpdateRangeFromCondition(C, /*TrueDest=*/true);
    }
  };

  UpdateRangeFromGuards(NarrowUser);

  BasicBlock *NarrowUserBB = NarrowUser->getParent();
  // If NarrowUserBB is statically unreachable asking dominator queries may
  // yield surprising results. (e.g. the block may not have a dom tree node)
  if (!DT->isReachableFromEntry(NarrowUserBB))
    return;

  for (auto *DTB = (*DT)[NarrowUserBB]->getIDom();
       L->contains(DTB->getBlock());
       DTB = DTB->getIDom()) {
    auto *BB = DTB->getBlock();
    auto *TI = BB->getTerminator();
    UpdateRangeFromGuards(TI);

    auto *BI = dyn_cast<BranchInst>(TI);
    if (!BI || !BI->isConditional())
      continue;

    auto *TrueSuccessor = BI->getSuccessor(0);
    auto *FalseSuccessor = BI->getSuccessor(1);

    auto DominatesNarrowUser = [this, NarrowUser] (BasicBlockEdge BBE) {
      return BBE.isSingleEdge() &&
             DT->dominates(BBE, NarrowUser->getParent());
    };

    if (DominatesNarrowUser(BasicBlockEdge(BB, TrueSuccessor)))
      UpdateRangeFromCondition(BI->getCondition(), /*TrueDest=*/true);

    if (DominatesNarrowUser(BasicBlockEdge(BB, FalseSuccessor)))
      UpdateRangeFromCondition(BI->getCondition(), /*TrueDest=*/false);
  }
}

/// Calculates PostIncRangeInfos map for the given IV
void WidenIV::calculatePostIncRanges(PHINode *OrigPhi) {
  SmallPtrSet<Instruction *, 16> Visited;
  SmallVector<Instruction *, 6> Worklist;
  Worklist.push_back(OrigPhi);
  Visited.insert(OrigPhi);

  while (!Worklist.empty()) {
    Instruction *NarrowDef = Worklist.pop_back_val();

    for (Use &U : NarrowDef->uses()) {
      auto *NarrowUser = cast<Instruction>(U.getUser());

      // Don't go looking outside the current loop.
      auto *NarrowUserLoop = (*LI)[NarrowUser->getParent()];
      if (!NarrowUserLoop || !L->contains(NarrowUserLoop))
        continue;

      if (!Visited.insert(NarrowUser).second)
        continue;

      Worklist.push_back(NarrowUser);

      calculatePostIncRange(NarrowDef, NarrowUser);
    }
  }
}

PHINode *llvm::createWideIV(WideIVInfo &WI,
    LoopInfo *LI, ScalarEvolution *SE, SCEVExpander &Rewriter,
    DominatorTree *DT, SmallVectorImpl<WeakTrackingVH> &DeadInsts,
    unsigned &NumElimExt, unsigned &NumWidened,
    bool HasGuards, bool UsePostIncrementRanges) {
  WidenIV Widener(WI, LI, SE, DT, DeadInsts, HasGuards, UsePostIncrementRanges);
  PHINode *WidePHI = Widener.createWideIV(Rewriter);
  NumElimExt = Widener.getNumElimExt();
  NumWidened = Widener.getNumWidened();
  return WidePHI;
}
