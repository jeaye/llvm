; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -correlated-propagation -S | FileCheck %s

target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

define void @test0(i32 %n) {
; CHECK-LABEL: @test0(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_COND:%.*]]
; CHECK:       for.cond:
; CHECK-NEXT:    [[J_0:%.*]] = phi i32 [ [[N:%.*]], [[ENTRY:%.*]] ], [ [[DIV1:%.*]], [[FOR_BODY:%.*]] ]
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i32 [[J_0]], 1
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[DIV1]] = udiv i32 [[J_0]], 2
; CHECK-NEXT:    br label [[FOR_COND]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.cond

for.cond:                                         ; preds = %for.body, %entry
  %j.0 = phi i32 [ %n, %entry ], [ %div, %for.body ]
  %cmp = icmp sgt i32 %j.0, 1
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %div = sdiv i32 %j.0, 2
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void
}

define void @test1(i32 %n) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_COND:%.*]]
; CHECK:       for.cond:
; CHECK-NEXT:    [[J_0:%.*]] = phi i32 [ [[N:%.*]], [[ENTRY:%.*]] ], [ [[DIV:%.*]], [[FOR_BODY:%.*]] ]
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i32 [[J_0]], -2
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[DIV]] = sdiv i32 [[J_0]], 2
; CHECK-NEXT:    br label [[FOR_COND]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.cond

for.cond:                                         ; preds = %for.body, %entry
  %j.0 = phi i32 [ %n, %entry ], [ %div, %for.body ]
  %cmp = icmp sgt i32 %j.0, -2
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %div = sdiv i32 %j.0, 2
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void
}

define void @test2(i32 %n) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i32 [[N:%.*]], 1
; CHECK-NEXT:    br i1 [[CMP]], label [[BB:%.*]], label [[EXIT:%.*]]
; CHECK:       bb:
; CHECK-NEXT:    [[DIV1:%.*]] = udiv i32 [[N]], 2
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  %cmp = icmp sgt i32 %n, 1
  br i1 %cmp, label %bb, label %exit

bb:
  %div = sdiv i32 %n, 2
  br label %exit

exit:
  ret void
}

; looping case where loop has exactly one block
; at the point of sdiv, we know that %a is always greater than 0,
; because of the guard before it, so we can transform it to udiv.
declare void @llvm.experimental.guard(i1,...)
define void @test4(i32 %n) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i32 [[N:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[LOOP:%.*]], label [[EXIT:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[A:%.*]] = phi i32 [ [[N]], [[ENTRY:%.*]] ], [ [[DIV1:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[COND:%.*]] = icmp sgt i32 [[A]], 4
; CHECK-NEXT:    call void (i1, ...) @llvm.experimental.guard(i1 [[COND]]) [ "deopt"() ]
; CHECK-NEXT:    [[DIV1]] = udiv i32 [[A]], 6
; CHECK-NEXT:    br i1 [[COND]], label [[LOOP]], label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  %cmp = icmp sgt i32 %n, 0
  br i1 %cmp, label %loop, label %exit

loop:
  %a = phi i32 [ %n, %entry ], [ %div, %loop ]
  %cond = icmp sgt i32 %a, 4
  call void(i1,...) @llvm.experimental.guard(i1 %cond) [ "deopt"() ]
  %div = sdiv i32 %a, 6
  br i1 %cond, label %loop, label %exit

exit:
  ret void
}

; same test as above with assume instead of guard.
declare void @llvm.assume(i1)
define void @test5(i32 %n) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i32 [[N:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[LOOP:%.*]], label [[EXIT:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[A:%.*]] = phi i32 [ [[N]], [[ENTRY:%.*]] ], [ [[DIV1:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[COND:%.*]] = icmp sgt i32 [[A]], 4
; CHECK-NEXT:    call void @llvm.assume(i1 [[COND]])
; CHECK-NEXT:    [[DIV1]] = udiv i32 [[A]], 6
; CHECK-NEXT:    [[LOOPCOND:%.*]] = icmp sgt i32 [[DIV1]], 8
; CHECK-NEXT:    br i1 [[LOOPCOND]], label [[LOOP]], label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  %cmp = icmp sgt i32 %n, 0
  br i1 %cmp, label %loop, label %exit

loop:
  %a = phi i32 [ %n, %entry ], [ %div, %loop ]
  %cond = icmp sgt i32 %a, 4
  call void @llvm.assume(i1 %cond)
  %div = sdiv i32 %a, 6
  %loopcond = icmp sgt i32 %div, 8
  br i1 %loopcond, label %loop, label %exit

exit:
  ret void
}

; Now, let's try various domain combinations for operands.

define i32 @test6_pos_pos(i32 %x, i32 %y) {
; CHECK-LABEL: @test6_pos_pos(
; CHECK-NEXT:    [[C0:%.*]] = icmp sge i32 [[X:%.*]], 0
; CHECK-NEXT:    call void @llvm.assume(i1 [[C0]])
; CHECK-NEXT:    [[C1:%.*]] = icmp sge i32 [[Y:%.*]], 0
; CHECK-NEXT:    call void @llvm.assume(i1 [[C1]])
; CHECK-NEXT:    [[DIV1:%.*]] = udiv i32 [[X]], [[Y]]
; CHECK-NEXT:    ret i32 [[DIV1]]
;
  %c0 = icmp sge i32 %x, 0
  call void @llvm.assume(i1 %c0)
  %c1 = icmp sge i32 %y, 0
  call void @llvm.assume(i1 %c1)

  %div = sdiv i32 %x, %y
  ret i32 %div
}
define i32 @test7_pos_neg(i32 %x, i32 %y) {
; CHECK-LABEL: @test7_pos_neg(
; CHECK-NEXT:    [[C0:%.*]] = icmp sge i32 [[X:%.*]], 0
; CHECK-NEXT:    call void @llvm.assume(i1 [[C0]])
; CHECK-NEXT:    [[C1:%.*]] = icmp sle i32 [[Y:%.*]], 0
; CHECK-NEXT:    call void @llvm.assume(i1 [[C1]])
; CHECK-NEXT:    [[Y_NONNEG:%.*]] = sub i32 0, [[Y]]
; CHECK-NEXT:    [[DIV1:%.*]] = udiv i32 [[X]], [[Y_NONNEG]]
; CHECK-NEXT:    [[DIV1_NEG:%.*]] = sub i32 0, [[DIV1]]
; CHECK-NEXT:    ret i32 [[DIV1_NEG]]
;
  %c0 = icmp sge i32 %x, 0
  call void @llvm.assume(i1 %c0)
  %c1 = icmp sle i32 %y, 0
  call void @llvm.assume(i1 %c1)

  %div = sdiv i32 %x, %y
  ret i32 %div
}
define i32 @test8_neg_pos(i32 %x, i32 %y) {
; CHECK-LABEL: @test8_neg_pos(
; CHECK-NEXT:    [[C0:%.*]] = icmp sle i32 [[X:%.*]], 0
; CHECK-NEXT:    call void @llvm.assume(i1 [[C0]])
; CHECK-NEXT:    [[C1:%.*]] = icmp sge i32 [[Y:%.*]], 0
; CHECK-NEXT:    call void @llvm.assume(i1 [[C1]])
; CHECK-NEXT:    [[X_NONNEG:%.*]] = sub i32 0, [[X]]
; CHECK-NEXT:    [[DIV1:%.*]] = udiv i32 [[X_NONNEG]], [[Y]]
; CHECK-NEXT:    [[DIV1_NEG:%.*]] = sub i32 0, [[DIV1]]
; CHECK-NEXT:    ret i32 [[DIV1_NEG]]
;
  %c0 = icmp sle i32 %x, 0
  call void @llvm.assume(i1 %c0)
  %c1 = icmp sge i32 %y, 0
  call void @llvm.assume(i1 %c1)

  %div = sdiv i32 %x, %y
  ret i32 %div
}
define i32 @test9_neg_neg(i32 %x, i32 %y) {
; CHECK-LABEL: @test9_neg_neg(
; CHECK-NEXT:    [[C0:%.*]] = icmp sle i32 [[X:%.*]], 0
; CHECK-NEXT:    call void @llvm.assume(i1 [[C0]])
; CHECK-NEXT:    [[C1:%.*]] = icmp sle i32 [[Y:%.*]], 0
; CHECK-NEXT:    call void @llvm.assume(i1 [[C1]])
; CHECK-NEXT:    [[X_NONNEG:%.*]] = sub i32 0, [[X]]
; CHECK-NEXT:    [[Y_NONNEG:%.*]] = sub i32 0, [[Y]]
; CHECK-NEXT:    [[DIV1:%.*]] = udiv i32 [[X_NONNEG]], [[Y_NONNEG]]
; CHECK-NEXT:    ret i32 [[DIV1]]
;
  %c0 = icmp sle i32 %x, 0
  call void @llvm.assume(i1 %c0)
  %c1 = icmp sle i32 %y, 0
  call void @llvm.assume(i1 %c1)

  %div = sdiv i32 %x, %y
  ret i32 %div
}

; After making division unsigned, can we narrow it?
define i32 @test10_narrow(i32 %x, i32 %y) {
; CHECK-LABEL: @test10_narrow(
; CHECK-NEXT:    [[C0:%.*]] = icmp ult i32 [[X:%.*]], 128
; CHECK-NEXT:    call void @llvm.assume(i1 [[C0]])
; CHECK-NEXT:    [[C1:%.*]] = icmp ult i32 [[Y:%.*]], 128
; CHECK-NEXT:    call void @llvm.assume(i1 [[C1]])
; CHECK-NEXT:    br label [[END:%.*]]
; CHECK:       end:
; CHECK-NEXT:    [[DIV1_LHS_TRUNC:%.*]] = trunc i32 [[X]] to i8
; CHECK-NEXT:    [[DIV1_RHS_TRUNC:%.*]] = trunc i32 [[Y]] to i8
; CHECK-NEXT:    [[DIV12:%.*]] = udiv i8 [[DIV1_LHS_TRUNC]], [[DIV1_RHS_TRUNC]]
; CHECK-NEXT:    [[DIV1_ZEXT:%.*]] = zext i8 [[DIV12]] to i32
; CHECK-NEXT:    ret i32 [[DIV1_ZEXT]]
;
  %c0 = icmp ult i32 %x, 128
  call void @llvm.assume(i1 %c0)
  %c1 = icmp ult i32 %y, 128
  call void @llvm.assume(i1 %c1)
  br label %end

end:
  %div = sdiv i32 %x, %y
  ret i32 %div
}
