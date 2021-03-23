; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -S -simplifycfg -simplifycfg-require-and-preserve-domtree=1 -bonus-inst-threshold=1 | FileCheck --check-prefixes=THR1 %s
; RUN: opt < %s -S -simplifycfg -simplifycfg-require-and-preserve-domtree=1 -bonus-inst-threshold=2 | FileCheck --check-prefixes=THR2 %s

declare void @sideeffect0()
declare void @sideeffect1()
declare void @sideeffect2()
declare void @use8(i8)
declare i1 @gen1()

; Here we'd want to duplicate %v3_adj into two predecessors,
; but -bonus-inst-threshold=1 says that we can only clone it into one.
; With -bonus-inst-threshold=2 we can clone it into both though.
define void @two_preds_with_extra_op(i8 %v0, i8 %v1, i8 %v2, i8 %v3) {
; THR1-LABEL: @two_preds_with_extra_op(
; THR1-NEXT:  entry:
; THR1-NEXT:    [[C0:%.*]] = icmp eq i8 [[V0:%.*]], 0
; THR1-NEXT:    br i1 [[C0]], label [[PRED0:%.*]], label [[PRED1:%.*]]
; THR1:       pred0:
; THR1-NEXT:    [[C1:%.*]] = icmp eq i8 [[V1:%.*]], 0
; THR1-NEXT:    br i1 [[C1]], label [[FINAL_LEFT:%.*]], label [[DISPATCH:%.*]]
; THR1:       pred1:
; THR1-NEXT:    [[C2:%.*]] = icmp eq i8 [[V2:%.*]], 0
; THR1-NEXT:    br i1 [[C2]], label [[DISPATCH]], label [[FINAL_RIGHT:%.*]]
; THR1:       dispatch:
; THR1-NEXT:    [[V3_ADJ:%.*]] = add i8 [[V1]], [[V2]]
; THR1-NEXT:    [[C3:%.*]] = icmp eq i8 [[V3_ADJ]], 0
; THR1-NEXT:    br i1 [[C3]], label [[FINAL_LEFT]], label [[FINAL_RIGHT]]
; THR1:       final_left:
; THR1-NEXT:    call void @sideeffect0()
; THR1-NEXT:    ret void
; THR1:       final_right:
; THR1-NEXT:    call void @sideeffect1()
; THR1-NEXT:    ret void
;
; THR2-LABEL: @two_preds_with_extra_op(
; THR2-NEXT:  entry:
; THR2-NEXT:    [[C0:%.*]] = icmp eq i8 [[V0:%.*]], 0
; THR2-NEXT:    br i1 [[C0]], label [[PRED0:%.*]], label [[PRED1:%.*]]
; THR2:       pred0:
; THR2-NEXT:    [[C1:%.*]] = icmp eq i8 [[V1:%.*]], 0
; THR2-NEXT:    [[V3_ADJ_OLD:%.*]] = add i8 [[V1]], [[V2:%.*]]
; THR2-NEXT:    [[C3_OLD:%.*]] = icmp eq i8 [[V3_ADJ_OLD]], 0
; THR2-NEXT:    [[OR_COND1:%.*]] = select i1 [[C1]], i1 true, i1 [[C3_OLD]]
; THR2-NEXT:    br i1 [[OR_COND1]], label [[FINAL_LEFT:%.*]], label [[FINAL_RIGHT:%.*]]
; THR2:       pred1:
; THR2-NEXT:    [[C2:%.*]] = icmp eq i8 [[V2]], 0
; THR2-NEXT:    [[V3_ADJ:%.*]] = add i8 [[V1]], [[V2]]
; THR2-NEXT:    [[C3:%.*]] = icmp eq i8 [[V3_ADJ]], 0
; THR2-NEXT:    [[OR_COND:%.*]] = select i1 [[C2]], i1 [[C3]], i1 false
; THR2-NEXT:    br i1 [[OR_COND]], label [[FINAL_LEFT]], label [[FINAL_RIGHT]]
; THR2:       final_left:
; THR2-NEXT:    call void @sideeffect0()
; THR2-NEXT:    ret void
; THR2:       final_right:
; THR2-NEXT:    call void @sideeffect1()
; THR2-NEXT:    ret void
;
entry:
  %c0 = icmp eq i8 %v0, 0
  br i1 %c0, label %pred0, label %pred1
pred0:
  %c1 = icmp eq i8 %v1, 0
  br i1 %c1, label %final_left, label %dispatch
pred1:
  %c2 = icmp eq i8 %v2, 0
  br i1 %c2, label %dispatch, label %final_right
dispatch:
  %v3_adj = add i8 %v1, %v2
  %c3 = icmp eq i8 %v3_adj, 0
  br i1 %c3, label %final_left, label %final_right
final_left:
  call void @sideeffect0()
  ret void
final_right:
  call void @sideeffect1()
  ret void
}

; Here we'd want to duplicate %v3_adj into two predecessors,
; but -bonus-inst-threshold=1 says that we can only clone it into one.
; But, we aren't going to clone it into one of the predecessors,
; because that isn't profitable. So we should not use it in cost calculation.
define void @two_preds_with_extra_op_and_branchweights(i8 %v0, i8 %v1, i8 %v2, i8 %v3) {
; THR1-LABEL: @two_preds_with_extra_op_and_branchweights(
; THR1-NEXT:  entry:
; THR1-NEXT:    [[C0:%.*]] = icmp eq i8 [[V0:%.*]], 0
; THR1-NEXT:    br i1 [[C0]], label [[PRED0:%.*]], label [[PRED1:%.*]]
; THR1:       pred0:
; THR1-NEXT:    [[C1:%.*]] = icmp eq i8 [[V1:%.*]], 0
; THR1-NEXT:    br i1 [[C1]], label [[FINAL_LEFT:%.*]], label [[DISPATCH:%.*]], !prof !0
; THR1:       pred1:
; THR1-NEXT:    [[C2:%.*]] = icmp eq i8 [[V2:%.*]], 0
; THR1-NEXT:    br i1 [[C2]], label [[DISPATCH]], label [[FINAL_RIGHT:%.*]]
; THR1:       dispatch:
; THR1-NEXT:    [[V3_ADJ:%.*]] = add i8 [[V1]], [[V2]]
; THR1-NEXT:    [[C3:%.*]] = icmp eq i8 [[V3_ADJ]], 0
; THR1-NEXT:    br i1 [[C3]], label [[FINAL_LEFT]], label [[FINAL_RIGHT]]
; THR1:       final_left:
; THR1-NEXT:    call void @sideeffect0()
; THR1-NEXT:    ret void
; THR1:       final_right:
; THR1-NEXT:    call void @sideeffect1()
; THR1-NEXT:    ret void
;
; THR2-LABEL: @two_preds_with_extra_op_and_branchweights(
; THR2-NEXT:  entry:
; THR2-NEXT:    [[C0:%.*]] = icmp eq i8 [[V0:%.*]], 0
; THR2-NEXT:    br i1 [[C0]], label [[PRED0:%.*]], label [[PRED1:%.*]]
; THR2:       pred0:
; THR2-NEXT:    [[C1:%.*]] = icmp eq i8 [[V1:%.*]], 0
; THR2-NEXT:    br i1 [[C1]], label [[FINAL_LEFT:%.*]], label [[DISPATCH:%.*]], !prof !0
; THR2:       pred1:
; THR2-NEXT:    [[C2:%.*]] = icmp eq i8 [[V2:%.*]], 0
; THR2-NEXT:    [[V3_ADJ:%.*]] = add i8 [[V1]], [[V2]]
; THR2-NEXT:    [[C3:%.*]] = icmp eq i8 [[V3_ADJ]], 0
; THR2-NEXT:    [[OR_COND:%.*]] = select i1 [[C2]], i1 [[C3]], i1 false
; THR2-NEXT:    br i1 [[OR_COND]], label [[FINAL_LEFT]], label [[FINAL_RIGHT:%.*]]
; THR2:       dispatch:
; THR2-NEXT:    [[V3_ADJ_OLD:%.*]] = add i8 [[V1]], [[V2]]
; THR2-NEXT:    [[C3_OLD:%.*]] = icmp eq i8 [[V3_ADJ_OLD]], 0
; THR2-NEXT:    br i1 [[C3_OLD]], label [[FINAL_LEFT]], label [[FINAL_RIGHT]]
; THR2:       final_left:
; THR2-NEXT:    call void @sideeffect0()
; THR2-NEXT:    ret void
; THR2:       final_right:
; THR2-NEXT:    call void @sideeffect1()
; THR2-NEXT:    ret void
;
entry:
  %c0 = icmp eq i8 %v0, 0
  br i1 %c0, label %pred0, label %pred1
pred0:
  %c1 = icmp eq i8 %v1, 0
  br i1 %c1, label %final_left, label %dispatch, !prof !0 ; likely branches to %final_left
pred1:
  %c2 = icmp eq i8 %v2, 0
  br i1 %c2, label %dispatch, label %final_right
dispatch:
  %v3_adj = add i8 %v1, %v2
  %c3 = icmp eq i8 %v3_adj, 0
  br i1 %c3, label %final_left, label %final_right
final_left:
  call void @sideeffect0()
  ret void
final_right:
  call void @sideeffect1()
  ret void
}

!0 = !{!"branch_weights", i32 99, i32 1}

; CHECK: !0 = !{!"branch_weights", i32 99, i32 1}
