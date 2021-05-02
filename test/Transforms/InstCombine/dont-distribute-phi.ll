; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s
;
; This test ensures that InstCombine does not distribute And over Xor
; using simplifications involving undef.

define zeroext i1 @foo(i32 %arg) {
; CHECK-LABEL: @foo(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i32 [[ARG:%.*]], 37
; CHECK-NEXT:    br i1 [[CMP1]], label [[BB_THEN:%.*]], label [[BB_ELSE:%.*]]
; CHECK:       bb_then:
; CHECK-NEXT:    call void @bar()
; CHECK-NEXT:    br label [[BB_EXIT:%.*]]
; CHECK:       bb_else:
; CHECK-NEXT:    [[CMP2:%.*]] = icmp slt i32 [[ARG]], 17
; CHECK-NEXT:    br label [[BB_EXIT]]
; CHECK:       bb_exit:
; CHECK-NEXT:    [[PHI1:%.*]] = phi i1 [ [[CMP2]], [[BB_ELSE]] ], [ undef, [[BB_THEN]] ]
; CHECK-NEXT:    [[XOR1:%.*]] = xor i1 [[CMP1]], true
; CHECK-NEXT:    [[AND1:%.*]] = and i1 [[PHI1]], [[XOR1]]
; CHECK-NEXT:    ret i1 [[AND1]]
;

entry:
  %cmp1 = icmp eq i32 %arg, 37
  br i1 %cmp1, label %bb_then, label %bb_else

bb_then:
  call void @bar()
  br label %bb_exit

bb_else:
  %cmp2 = icmp slt i32 %arg, 17
  br label %bb_exit

bb_exit:
  %phi1 = phi i1 [ %cmp2, %bb_else ], [ undef, %bb_then ]
  %xor1 = xor i1 %cmp1, true
  %and1 = and i1 %phi1, %xor1
  ret i1 %and1
}

define zeroext i1 @foo_logical(i32 %arg) {
; CHECK-LABEL: @foo_logical(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i32 [[ARG:%.*]], 37
; CHECK-NEXT:    br i1 [[CMP1]], label [[BB_THEN:%.*]], label [[BB_ELSE:%.*]]
; CHECK:       bb_then:
; CHECK-NEXT:    call void @bar()
; CHECK-NEXT:    br label [[BB_EXIT:%.*]]
; CHECK:       bb_else:
; CHECK-NEXT:    [[CMP2:%.*]] = icmp slt i32 [[ARG]], 17
; CHECK-NEXT:    br label [[BB_EXIT]]
; CHECK:       bb_exit:
; CHECK-NEXT:    [[PHI1:%.*]] = phi i1 [ [[CMP2]], [[BB_ELSE]] ], [ undef, [[BB_THEN]] ]
; CHECK-NEXT:    [[XOR1:%.*]] = xor i1 [[CMP1]], true
; CHECK-NEXT:    [[AND1:%.*]] = select i1 [[PHI1]], i1 [[XOR1]], i1 false
; CHECK-NEXT:    ret i1 [[AND1]]
;

entry:
  %cmp1 = icmp eq i32 %arg, 37
  br i1 %cmp1, label %bb_then, label %bb_else

bb_then:
  call void @bar()
  br label %bb_exit

bb_else:
  %cmp2 = icmp slt i32 %arg, 17
  br label %bb_exit

bb_exit:
  %phi1 = phi i1 [ %cmp2, %bb_else ], [ undef, %bb_then ]
  %xor1 = xor i1 %cmp1, true
  %and1 = select i1 %phi1, i1 %xor1, i1 false
  ret i1 %and1
}

declare void @bar()
