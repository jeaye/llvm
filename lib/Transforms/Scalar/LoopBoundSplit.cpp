//===------- LoopBoundSplit.cpp - Split Loop Bound --------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "llvm/Transforms/Scalar/LoopBoundSplit.h"
#include "llvm/Analysis/LoopAccessAnalysis.h"
#include "llvm/Analysis/LoopAnalysisManager.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Analysis/LoopIterator.h"
#include "llvm/Analysis/LoopPass.h"
#include "llvm/Analysis/MemorySSA.h"
#include "llvm/Analysis/MemorySSAUpdater.h"
#include "llvm/Analysis/ScalarEvolution.h"
#include "llvm/Analysis/ScalarEvolutionExpressions.h"
#include "llvm/IR/PatternMatch.h"
#include "llvm/Transforms/Utils/BasicBlockUtils.h"
#include "llvm/Transforms/Utils/Cloning.h"
#include "llvm/Transforms/Utils/LoopSimplify.h"
#include "llvm/Transforms/Utils/LoopUtils.h"
#include "llvm/Transforms/Utils/ScalarEvolutionExpander.h"

#define DEBUG_TYPE "loop-bound-split"

namespace llvm {

using namespace PatternMatch;

namespace {
struct ConditionInfo {
  /// Branch instruction with this condition
  BranchInst *BI;
  /// ICmp instruction with this condition
  ICmpInst *ICmp;
  /// Preciate info
  ICmpInst::Predicate Pred;
  /// AddRec llvm value
  Value *AddRecValue;
  /// Bound llvm value
  Value *BoundValue;
  /// AddRec SCEV
  const SCEV *AddRecSCEV;
  /// Bound SCEV
  const SCEV *BoundSCEV;

  ConditionInfo()
      : BI(nullptr), ICmp(nullptr), Pred(ICmpInst::BAD_ICMP_PREDICATE),
        AddRecValue(nullptr), BoundValue(nullptr), AddRecSCEV(nullptr),
        BoundSCEV(nullptr) {}
};
} // namespace

static void analyzeICmp(ScalarEvolution &SE, ICmpInst *ICmp,
                        ConditionInfo &Cond) {
  Cond.ICmp = ICmp;
  if (match(ICmp, m_ICmp(Cond.Pred, m_Value(Cond.AddRecValue),
                         m_Value(Cond.BoundValue)))) {
    Cond.AddRecSCEV = SE.getSCEV(Cond.AddRecValue);
    Cond.BoundSCEV = SE.getSCEV(Cond.BoundValue);
    // Locate AddRec in LHSSCEV and Bound in RHSSCEV.
    if (isa<SCEVAddRecExpr>(Cond.BoundSCEV) &&
        !isa<SCEVAddRecExpr>(Cond.AddRecSCEV)) {
      std::swap(Cond.AddRecValue, Cond.BoundValue);
      std::swap(Cond.AddRecSCEV, Cond.BoundSCEV);
      Cond.Pred = ICmpInst::getSwappedPredicate(Cond.Pred);
    }
  }
}

static bool calculateUpperBound(const Loop &L, ScalarEvolution &SE,
                                ConditionInfo &Cond, bool IsExitCond) {
  if (IsExitCond) {
    const SCEV *ExitCount = SE.getExitCount(&L, Cond.ICmp->getParent());
    if (isa<SCEVCouldNotCompute>(ExitCount))
      return false;

    Cond.BoundSCEV = ExitCount;
    return true;
  }

  // For non-exit condtion, if pred is LT, keep existing bound.
  if (Cond.Pred == ICmpInst::ICMP_SLT || Cond.Pred == ICmpInst::ICMP_ULT)
    return true;

  // For non-exit condition, if pre is LE, try to convert it to LT.
  //      Range                 Range
  // AddRec <= Bound  -->  AddRec < Bound + 1
  if (Cond.Pred != ICmpInst::ICMP_ULE && Cond.Pred != ICmpInst::ICMP_SLE)
    return false;

  if (IntegerType *BoundSCEVIntType =
          dyn_cast<IntegerType>(Cond.BoundSCEV->getType())) {
    unsigned BitWidth = BoundSCEVIntType->getBitWidth();
    APInt Max = ICmpInst::isSigned(Cond.Pred)
                    ? APInt::getSignedMaxValue(BitWidth)
                    : APInt::getMaxValue(BitWidth);
    const SCEV *MaxSCEV = SE.getConstant(Max);
    // Check Bound < INT_MAX
    ICmpInst::Predicate Pred =
        ICmpInst::isSigned(Cond.Pred) ? ICmpInst::ICMP_SLT : ICmpInst::ICMP_ULT;
    if (SE.isKnownPredicate(Pred, Cond.BoundSCEV, MaxSCEV)) {
      const SCEV *BoundPlusOneSCEV =
          SE.getAddExpr(Cond.BoundSCEV, SE.getOne(BoundSCEVIntType));
      Cond.BoundSCEV = BoundPlusOneSCEV;
      Cond.Pred = Pred;
      return true;
    }
  }

  // ToDo: Support ICMP_NE/EQ.

  return false;
}

static bool hasProcessableCondition(const Loop &L, ScalarEvolution &SE,
                                    ICmpInst *ICmp, ConditionInfo &Cond,
                                    bool IsExitCond) {
  analyzeICmp(SE, ICmp, Cond);

  // The BoundSCEV should be evaluated at loop entry.
  if (!SE.isAvailableAtLoopEntry(Cond.BoundSCEV, &L))
    return false;

  const SCEVAddRecExpr *AddRecSCEV = dyn_cast<SCEVAddRecExpr>(Cond.AddRecSCEV);
  // Allowed AddRec as induction variable.
  if (!AddRecSCEV)
    return false;

  if (!AddRecSCEV->isAffine())
    return false;

  const SCEV *StepRecSCEV = AddRecSCEV->getStepRecurrence(SE);
  // Allowed constant step.
  if (!isa<SCEVConstant>(StepRecSCEV))
    return false;

  ConstantInt *StepCI = cast<SCEVConstant>(StepRecSCEV)->getValue();
  // Allowed positive step for now.
  // TODO: Support negative step.
  if (StepCI->isNegative() || StepCI->isZero())
    return false;

  // Calculate upper bound.
  if (!calculateUpperBound(L, SE, Cond, IsExitCond))
    return false;

  return true;
}

static bool isProcessableCondBI(const ScalarEvolution &SE,
                                const BranchInst *BI) {
  BasicBlock *TrueSucc = nullptr;
  BasicBlock *FalseSucc = nullptr;
  ICmpInst::Predicate Pred;
  Value *LHS, *RHS;
  if (!match(BI, m_Br(m_ICmp(Pred, m_Value(LHS), m_Value(RHS)),
                      m_BasicBlock(TrueSucc), m_BasicBlock(FalseSucc))))
    return false;

  if (!SE.isSCEVable(LHS->getType()))
    return false;
  assert(SE.isSCEVable(RHS->getType()) && "Expected RHS's type is SCEVable");

  if (TrueSucc == FalseSucc)
    return false;

  return true;
}

static bool canSplitLoopBound(const Loop &L, const DominatorTree &DT,
                              ScalarEvolution &SE, ConditionInfo &Cond) {
  // Skip function with optsize.
  if (L.getHeader()->getParent()->hasOptSize())
    return false;

  // Split only innermost loop.
  if (!L.isInnermost())
    return false;

  // Check loop is in simplified form.
  if (!L.isLoopSimplifyForm())
    return false;

  // Check loop is in LCSSA form.
  if (!L.isLCSSAForm(DT))
    return false;

  // Skip loop that cannot be cloned.
  if (!L.isSafeToClone())
    return false;

  BasicBlock *ExitingBB = L.getExitingBlock();
  // Assumed only one exiting block.
  if (!ExitingBB)
    return false;

  BranchInst *ExitingBI = dyn_cast<BranchInst>(ExitingBB->getTerminator());
  if (!ExitingBI)
    return false;

  // Allowed only conditional branch with ICmp.
  if (!isProcessableCondBI(SE, ExitingBI))
    return false;

  // Check the condition is processable.
  ICmpInst *ICmp = cast<ICmpInst>(ExitingBI->getCondition());
  if (!hasProcessableCondition(L, SE, ICmp, Cond, /*IsExitCond*/ true))
    return false;

  Cond.BI = ExitingBI;
  return true;
}

static bool isProfitableToTransform(const Loop &L, const BranchInst *BI) {
  // If the conditional branch splits a loop into two halves, we could
  // generally say it is profitable.
  //
  // ToDo: Add more profitable cases here.

  // Check this branch causes diamond CFG.
  BasicBlock *Succ0 = BI->getSuccessor(0);
  BasicBlock *Succ1 = BI->getSuccessor(1);

  BasicBlock *Succ0Succ = Succ0->getSingleSuccessor();
  BasicBlock *Succ1Succ = Succ1->getSingleSuccessor();
  if (!Succ0Succ || !Succ1Succ || Succ0Succ != Succ1Succ)
    return false;

  // ToDo: Calculate each successor's instruction cost.

  return true;
}

static BranchInst *findSplitCandidate(const Loop &L, ScalarEvolution &SE,
                                      ConditionInfo &ExitingCond,
                                      ConditionInfo &SplitCandidateCond) {
  for (auto *BB : L.blocks()) {
    // Skip condition of backedge.
    if (L.getLoopLatch() == BB)
      continue;

    auto *BI = dyn_cast<BranchInst>(BB->getTerminator());
    if (!BI)
      continue;

    // Check conditional branch with ICmp.
    if (!isProcessableCondBI(SE, BI))
      continue;

    // Skip loop invariant condition.
    if (L.isLoopInvariant(BI->getCondition()))
      continue;

    // Check the condition is processable.
    ICmpInst *ICmp = cast<ICmpInst>(BI->getCondition());
    if (!hasProcessableCondition(L, SE, ICmp, SplitCandidateCond,
                                 /*IsExitCond*/ false))
      continue;

    if (ExitingCond.BoundSCEV->getType() !=
        SplitCandidateCond.BoundSCEV->getType())
      continue;

    SplitCandidateCond.BI = BI;
    return BI;
  }

  return nullptr;
}

static bool splitLoopBound(Loop &L, DominatorTree &DT, LoopInfo &LI,
                           ScalarEvolution &SE, LPMUpdater &U) {
  ConditionInfo SplitCandidateCond;
  ConditionInfo ExitingCond;

  // Check we can split this loop's bound.
  if (!canSplitLoopBound(L, DT, SE, ExitingCond))
    return false;

  if (!findSplitCandidate(L, SE, ExitingCond, SplitCandidateCond))
    return false;

  if (!isProfitableToTransform(L, SplitCandidateCond.BI))
    return false;

  // Now, we have a split candidate. Let's build a form as below.
  //    +--------------------+
  //    |     preheader      |
  //    |  set up newbound   |
  //    +--------------------+
  //             |     /----------------\
  //    +--------v----v------+          |
  //    |      header        |---\      |
  //    | with true condition|   |      |
  //    +--------------------+   |      |
  //             |               |      |
  //    +--------v-----------+   |      |
  //    |     if.then.BB     |   |      |
  //    +--------------------+   |      |
  //             |               |      |
  //    +--------v-----------<---/      |
  //    |       latch        >----------/
  //    |   with newbound    |
  //    +--------------------+
  //             |
  //    +--------v-----------+
  //    |     preheader2     |--------------\
  //    | if (AddRec i !=    |              |
  //    |     org bound)     |              |
  //    +--------------------+              |
  //             |     /----------------\   |
  //    +--------v----v------+          |   |
  //    |      header2       |---\      |   |
  //    | conditional branch |   |      |   |
  //    |with false condition|   |      |   |
  //    +--------------------+   |      |   |
  //             |               |      |   |
  //    +--------v-----------+   |      |   |
  //    |    if.then.BB2     |   |      |   |
  //    +--------------------+   |      |   |
  //             |               |      |   |
  //    +--------v-----------<---/      |   |
  //    |       latch2       >----------/   |
  //    |   with org bound   |              |
  //    +--------v-----------+              |
  //             |                          |
  //             |  +---------------+       |
  //             +-->     exit      <-------/
  //                +---------------+

  // Let's create post loop.
  SmallVector<BasicBlock *, 8> PostLoopBlocks;
  Loop *PostLoop;
  ValueToValueMapTy VMap;
  BasicBlock *PreHeader = L.getLoopPreheader();
  BasicBlock *SplitLoopPH = SplitEdge(PreHeader, L.getHeader(), &DT, &LI);
  PostLoop = cloneLoopWithPreheader(L.getExitBlock(), SplitLoopPH, &L, VMap,
                                    ".split", &LI, &DT, PostLoopBlocks);
  remapInstructionsInBlocks(PostLoopBlocks, VMap);

  // Add conditional branch to check we can skip post-loop in its preheader.
  BasicBlock *PostLoopPreHeader = PostLoop->getLoopPreheader();
  IRBuilder<> Builder(PostLoopPreHeader);
  Instruction *OrigBI = PostLoopPreHeader->getTerminator();
  ICmpInst::Predicate Pred = ICmpInst::ICMP_NE;
  Value *Cond =
      Builder.CreateICmp(Pred, ExitingCond.AddRecValue, ExitingCond.BoundValue);
  Builder.CreateCondBr(Cond, PostLoop->getHeader(), PostLoop->getExitBlock());
  OrigBI->eraseFromParent();

  // Create new loop bound and add it into preheader of pre-loop.
  const SCEV *NewBoundSCEV = ExitingCond.BoundSCEV;
  const SCEV *SplitBoundSCEV = SplitCandidateCond.BoundSCEV;
  NewBoundSCEV = ICmpInst::isSigned(ExitingCond.Pred)
                     ? SE.getSMinExpr(NewBoundSCEV, SplitBoundSCEV)
                     : SE.getUMinExpr(NewBoundSCEV, SplitBoundSCEV);

  SCEVExpander Expander(
      SE, L.getHeader()->getParent()->getParent()->getDataLayout(), "split");
  Instruction *InsertPt = SplitLoopPH->getTerminator();
  Value *NewBoundValue =
      Expander.expandCodeFor(NewBoundSCEV, NewBoundSCEV->getType(), InsertPt);
  NewBoundValue->setName("new.bound");

  // Replace exiting bound value of pre-loop NewBound.
  ExitingCond.ICmp->setOperand(1, NewBoundValue);

  // Replace IV's start value of post-loop by NewBound.
  for (PHINode &PN : L.getHeader()->phis()) {
    // Find PHI with exiting condition from pre-loop.
    if (SE.isSCEVable(PN.getType()) && isa<SCEVAddRecExpr>(SE.getSCEV(&PN))) {
      for (Value *Op : PN.incoming_values()) {
        if (Op == ExitingCond.AddRecValue) {
          // Find cloned PHI for post-loop.
          PHINode *PostLoopPN = cast<PHINode>(VMap[&PN]);
          PostLoopPN->setIncomingValueForBlock(PostLoopPreHeader,
                                               NewBoundValue);
        }
      }
    }
  }

  // Replace SplitCandidateCond.BI's condition of pre-loop by True.
  LLVMContext &Context = PreHeader->getContext();
  SplitCandidateCond.BI->setCondition(ConstantInt::getTrue(Context));

  // Replace cloned SplitCandidateCond.BI's condition in post-loop by False.
  BranchInst *ClonedSplitCandidateBI =
      cast<BranchInst>(VMap[SplitCandidateCond.BI]);
  ClonedSplitCandidateBI->setCondition(ConstantInt::getFalse(Context));

  // Replace exit branch target of pre-loop by post-loop's preheader.
  if (L.getExitBlock() == ExitingCond.BI->getSuccessor(0))
    ExitingCond.BI->setSuccessor(0, PostLoopPreHeader);
  else
    ExitingCond.BI->setSuccessor(1, PostLoopPreHeader);

  // Update dominator tree.
  DT.changeImmediateDominator(PostLoopPreHeader, L.getExitingBlock());
  DT.changeImmediateDominator(PostLoop->getExitBlock(), PostLoopPreHeader);

  // Invalidate cached SE information.
  SE.forgetLoop(&L);

  // Canonicalize loops.
  // TODO: Try to update LCSSA information according to above change.
  formLCSSA(L, DT, &LI, &SE);
  simplifyLoop(&L, &DT, &LI, &SE, nullptr, nullptr, true);
  formLCSSA(*PostLoop, DT, &LI, &SE);
  simplifyLoop(PostLoop, &DT, &LI, &SE, nullptr, nullptr, true);

  // Add new post-loop to loop pass manager.
  U.addSiblingLoops(PostLoop);

  return true;
}

PreservedAnalyses LoopBoundSplitPass::run(Loop &L, LoopAnalysisManager &AM,
                                          LoopStandardAnalysisResults &AR,
                                          LPMUpdater &U) {
  Function &F = *L.getHeader()->getParent();
  (void)F;

  LLVM_DEBUG(dbgs() << "Spliting bound of loop in " << F.getName() << ": " << L
                    << "\n");

  if (!splitLoopBound(L, AR.DT, AR.LI, AR.SE, U))
    return PreservedAnalyses::all();

  assert(AR.DT.verify(DominatorTree::VerificationLevel::Fast));
  AR.LI.verify(AR.DT);

  return getLoopPassPreservedAnalyses();
}

} // end namespace llvm
