; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -instsimplify -S < %s | FileCheck %s

define i1 @test_add_nsw(i8 %p, i8* %pq, i8 %n, i8 %r) {
; CHECK-LABEL: @test_add_nsw(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[A:%.*]] = phi i8 [ 1, [[ENTRY:%.*]] ], [ [[NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[NEXT]] = add nsw i8 [[A]], 1
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i8 [[A]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP1]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    ret i1 false
;
entry:
  br label %loop
loop:
  %A = phi i8 [ 1, %entry ], [ %next, %loop ]
  %next = add nsw i8 %A, 1
  %cmp1 = icmp eq i8 %A, %n
  br i1 %cmp1, label %exit, label %loop
exit:
  %add = or i8 %A, %r
  %cmp = icmp eq i8 %add, 0
  ret i1 %cmp
}

define i1 @test_add_may_wrap(i8 %p, i8* %pq, i8 %n, i8 %r) {
; CHECK-LABEL: @test_add_may_wrap(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[A:%.*]] = phi i8 [ 1, [[ENTRY:%.*]] ], [ [[NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[NEXT]] = add i8 [[A]], 1
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i8 [[A]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP1]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    [[ADD:%.*]] = or i8 [[A]], [[R:%.*]]
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8 [[ADD]], 0
; CHECK-NEXT:    ret i1 [[CMP]]
;
entry:
  br label %loop
loop:
  %A = phi i8 [ 1, %entry ], [ %next, %loop ]
  %next = add i8 %A, 1
  %cmp1 = icmp eq i8 %A, %n
  br i1 %cmp1, label %exit, label %loop
exit:
  %add = or i8 %A, %r
  %cmp = icmp eq i8 %add, 0
  ret i1 %cmp
}

define i1 @test_add_nuw(i8 %p, i8* %pq, i8 %n, i8 %r) {
; CHECK-LABEL: @test_add_nuw(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[A:%.*]] = phi i8 [ 1, [[ENTRY:%.*]] ], [ [[NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[NEXT]] = add nuw i8 [[A]], 1
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i8 [[A]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP1]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    ret i1 false
;
entry:
  br label %loop
loop:
  %A = phi i8 [ 1, %entry ], [ %next, %loop ]
  %next = add nuw i8 %A, 1
  %cmp1 = icmp eq i8 %A, %n
  br i1 %cmp1, label %exit, label %loop
exit:
  %add = or i8 %A, %r
  %cmp = icmp eq i8 %add, 0
  ret i1 %cmp
}

define i1 @test_add_zero_start(i8 %p, i8* %pq, i8 %n, i8 %r) {
; CHECK-LABEL: @test_add_zero_start(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[A:%.*]] = phi i8 [ 0, [[ENTRY:%.*]] ], [ [[NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[NEXT]] = add nuw i8 [[A]], 1
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i8 [[A]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP1]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    [[ADD:%.*]] = or i8 [[A]], [[R:%.*]]
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8 [[ADD]], 0
; CHECK-NEXT:    ret i1 [[CMP]]
;
entry:
  br label %loop
loop:
  %A = phi i8 [ 0, %entry ], [ %next, %loop ]
  %next = add nuw i8 %A, 1
  %cmp1 = icmp eq i8 %A, %n
  br i1 %cmp1, label %exit, label %loop
exit:
  %add = or i8 %A, %r
  %cmp = icmp eq i8 %add, 0
  ret i1 %cmp
}

define i1 @test_add_nuw_negative_start(i8 %p, i8* %pq, i8 %n, i8 %r) {
; CHECK-LABEL: @test_add_nuw_negative_start(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[A:%.*]] = phi i8 [ -2, [[ENTRY:%.*]] ], [ [[NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[NEXT]] = add nuw i8 [[A]], 1
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i8 [[A]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP1]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    ret i1 false
;
entry:
  br label %loop
loop:
  %A = phi i8 [ -2, %entry ], [ %next, %loop ]
  %next = add nuw i8 %A, 1
  %cmp1 = icmp eq i8 %A, %n
  br i1 %cmp1, label %exit, label %loop
exit:
  %add = or i8 %A, %r
  %cmp = icmp eq i8 %add, 0
  ret i1 %cmp
}

define i1 @test_add_nsw_negative_start(i8 %p, i8* %pq, i8 %n, i8 %r) {
; CHECK-LABEL: @test_add_nsw_negative_start(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[A:%.*]] = phi i8 [ -2, [[ENTRY:%.*]] ], [ [[NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[NEXT]] = add nsw i8 [[A]], 1
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i8 [[A]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP1]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    [[ADD:%.*]] = or i8 [[A]], [[R:%.*]]
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8 [[ADD]], 0
; CHECK-NEXT:    ret i1 [[CMP]]
;
entry:
  br label %loop
loop:
  %A = phi i8 [ -2, %entry ], [ %next, %loop ]
  %next = add nsw i8 %A, 1
  %cmp1 = icmp eq i8 %A, %n
  br i1 %cmp1, label %exit, label %loop
exit:
  %add = or i8 %A, %r
  %cmp = icmp eq i8 %add, 0
  ret i1 %cmp
}

define i1 @test_add_nsw_negative_start_and_step(i8 %p, i8* %pq, i8 %n, i8 %r) {
; CHECK-LABEL: @test_add_nsw_negative_start_and_step(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[A:%.*]] = phi i8 [ -1, [[ENTRY:%.*]] ], [ [[NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[NEXT]] = add nsw i8 [[A]], -1
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i8 [[A]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP1]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    ret i1 false
;
entry:
  br label %loop
loop:
  %A = phi i8 [ -1, %entry ], [ %next, %loop ]
  %next = add nsw i8 %A, -1
  %cmp1 = icmp eq i8 %A, %n
  br i1 %cmp1, label %exit, label %loop
exit:
  %add = or i8 %A, %r
  %cmp = icmp eq i8 %add, 0
  ret i1 %cmp
}

define i1 @test_mul_nsw(i8 %p, i8* %pq, i8 %n) {
; CHECK-LABEL: @test_mul_nsw(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[A:%.*]] = phi i8 [ 2, [[ENTRY:%.*]] ], [ [[NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[NEXT]] = mul nsw i8 [[A]], 2
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i8 [[A]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP1]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    ret i1 false
;
entry:
  br label %loop
loop:
  %A = phi i8 [ 2, %entry ], [ %next, %loop ]
  %next = mul nsw i8 %A, 2
  %cmp1 = icmp eq i8 %A, %n
  br i1 %cmp1, label %exit, label %loop
exit:
  %cmp = icmp eq i8 %A, 0
  ret i1 %cmp
}

define i1 @test_mul_may_wrap(i8 %p, i8* %pq, i8 %n) {
; CHECK-LABEL: @test_mul_may_wrap(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[A:%.*]] = phi i8 [ 2, [[ENTRY:%.*]] ], [ [[NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[NEXT]] = mul i8 [[A]], 2
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i8 [[A]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP1]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8 [[A]], 0
; CHECK-NEXT:    ret i1 [[CMP]]
;
entry:
  br label %loop
loop:
  %A = phi i8 [ 2, %entry ], [ %next, %loop ]
  %next = mul i8 %A, 2
  %cmp1 = icmp eq i8 %A, %n
  br i1 %cmp1, label %exit, label %loop
exit:
  %cmp = icmp eq i8 %A, 0
  ret i1 %cmp
}

define i1 @test_mul_nuw(i8 %p, i8* %pq, i8 %n) {
; CHECK-LABEL: @test_mul_nuw(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[A:%.*]] = phi i8 [ 2, [[ENTRY:%.*]] ], [ [[NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[NEXT]] = mul nuw i8 [[A]], 2
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i8 [[A]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP1]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    ret i1 false
;
entry:
  br label %loop
loop:
  %A = phi i8 [ 2, %entry ], [ %next, %loop ]
  %next = mul nuw i8 %A, 2
  %cmp1 = icmp eq i8 %A, %n
  br i1 %cmp1, label %exit, label %loop
exit:
  %cmp = icmp eq i8 %A, 0
  ret i1 %cmp
}

define i1 @test_mul_zero_start(i8 %p, i8* %pq, i8 %n) {
; CHECK-LABEL: @test_mul_zero_start(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[A:%.*]] = phi i8 [ 0, [[ENTRY:%.*]] ], [ [[NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[NEXT]] = mul nuw i8 [[A]], 2
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i8 [[A]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP1]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8 [[A]], 0
; CHECK-NEXT:    ret i1 [[CMP]]
;
entry:
  br label %loop
loop:
  %A = phi i8 [ 0, %entry ], [ %next, %loop ]
  %next = mul nuw i8 %A, 2
  %cmp1 = icmp eq i8 %A, %n
  br i1 %cmp1, label %exit, label %loop
exit:
  %cmp = icmp eq i8 %A, 0
  ret i1 %cmp
}

define i1 @test_mul_nuw_negative_step(i8 %p, i8* %pq, i8 %n) {
; CHECK-LABEL: @test_mul_nuw_negative_step(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[A:%.*]] = phi i8 [ 2, [[ENTRY:%.*]] ], [ [[NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[NEXT]] = mul nuw i8 [[A]], -2
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i8 [[A]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP1]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    ret i1 false
;
entry:
  br label %loop
loop:
  %A = phi i8 [ 2, %entry ], [ %next, %loop ]
  %next = mul nuw i8 %A, -2
  %cmp1 = icmp eq i8 %A, %n
  br i1 %cmp1, label %exit, label %loop
exit:
  %cmp = icmp eq i8 %A, 0
  ret i1 %cmp
}

define i1 @test_mul_nsw_negative_step(i8 %p, i8* %pq, i8 %n) {
; CHECK-LABEL: @test_mul_nsw_negative_step(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[A:%.*]] = phi i8 [ 2, [[ENTRY:%.*]] ], [ [[NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[NEXT]] = mul nsw i8 [[A]], -2
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i8 [[A]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP1]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8 [[A]], 0
; CHECK-NEXT:    ret i1 [[CMP]]
;
entry:
  br label %loop
loop:
  %A = phi i8 [ 2, %entry ], [ %next, %loop ]
  %next = mul nsw i8 %A, -2
  %cmp1 = icmp eq i8 %A, %n
  br i1 %cmp1, label %exit, label %loop
exit:
  %cmp = icmp eq i8 %A, 0
  ret i1 %cmp
}

define i1 @test_mul_nuw_negative_start(i8 %p, i8* %pq, i8 %n) {
; CHECK-LABEL: @test_mul_nuw_negative_start(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[A:%.*]] = phi i8 [ -2, [[ENTRY:%.*]] ], [ [[NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[NEXT]] = mul nuw i8 [[A]], 2
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i8 [[A]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP1]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    ret i1 false
;
entry:
  br label %loop
loop:
  %A = phi i8 [ -2, %entry ], [ %next, %loop ]
  %next = mul nuw i8 %A, 2
  %cmp1 = icmp eq i8 %A, %n
  br i1 %cmp1, label %exit, label %loop
exit:
  %cmp = icmp eq i8 %A, 0
  ret i1 %cmp
}

define i1 @test_shl_nuw(i8 %p, i8* %pq, i8 %n) {
; CHECK-LABEL: @test_shl_nuw(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[A:%.*]] = phi i8 [ 1, [[ENTRY:%.*]] ], [ [[NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[NEXT]] = shl nuw i8 [[A]], 1
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i8 [[A]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP1]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    ret i1 false
;
entry:
  br label %loop
loop:
  %A = phi i8 [ 1, %entry ], [ %next, %loop ]
  %next = shl nuw i8 %A, 1
  %cmp1 = icmp eq i8 %A, %n
  br i1 %cmp1, label %exit, label %loop
exit:
  %cmp = icmp eq i8 %A, 0
  ret i1 %cmp
}

define i1 @test_shl_nsw(i8 %p, i8* %pq, i8 %n) {
; CHECK-LABEL: @test_shl_nsw(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[A:%.*]] = phi i8 [ 1, [[ENTRY:%.*]] ], [ [[NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[NEXT]] = shl nsw i8 [[A]], 1
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i8 [[A]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP1]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    ret i1 false
;
entry:
  br label %loop
loop:
  %A = phi i8 [ 1, %entry ], [ %next, %loop ]
  %next = shl nsw i8 %A, 1
  %cmp1 = icmp eq i8 %A, %n
  br i1 %cmp1, label %exit, label %loop
exit:
  %cmp = icmp eq i8 %A, 0
  ret i1 %cmp
}

define i1 @test_shl_dynamic_shift(i8 %p, i8* %pq, i8 %n, i8 %shift) {
; CHECK-LABEL: @test_shl_dynamic_shift(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[A:%.*]] = phi i8 [ 1, [[ENTRY:%.*]] ], [ [[NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[NEXT]] = shl nuw i8 [[A]], [[SHIFT:%.*]]
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i8 [[A]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP1]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    ret i1 false
;
entry:
  br label %loop
loop:
  %A = phi i8 [ 1, %entry ], [ %next, %loop ]
  %next = shl nuw i8 %A, %shift
  %cmp1 = icmp eq i8 %A, %n
  br i1 %cmp1, label %exit, label %loop
exit:
  %cmp = icmp eq i8 %A, 0
  ret i1 %cmp
}

define i1 @test_shl_may_wrap(i8 %p, i8* %pq, i8 %n) {
; CHECK-LABEL: @test_shl_may_wrap(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[A:%.*]] = phi i8 [ 1, [[ENTRY:%.*]] ], [ [[NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[NEXT]] = shl i8 [[A]], 1
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i8 [[A]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP1]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8 [[A]], 0
; CHECK-NEXT:    ret i1 [[CMP]]
;
entry:
  br label %loop
loop:
  %A = phi i8 [ 1, %entry ], [ %next, %loop ]
  %next = shl i8 %A, 1
  %cmp1 = icmp eq i8 %A, %n
  br i1 %cmp1, label %exit, label %loop
exit:
  %cmp = icmp eq i8 %A, 0
  ret i1 %cmp
}

define i1 @test_shl_zero_start(i8 %p, i8* %pq, i8 %n) {
; CHECK-LABEL: @test_shl_zero_start(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[A:%.*]] = phi i8 [ 0, [[ENTRY:%.*]] ], [ [[NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[NEXT]] = shl nuw i8 [[A]], 1
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i8 [[A]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP1]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8 [[A]], 0
; CHECK-NEXT:    ret i1 [[CMP]]
;
entry:
  br label %loop
loop:
  %A = phi i8 [ 0, %entry ], [ %next, %loop ]
  %next = shl nuw i8 %A, 1
  %cmp1 = icmp eq i8 %A, %n
  br i1 %cmp1, label %exit, label %loop
exit:
  %cmp = icmp eq i8 %A, 0
  ret i1 %cmp
}


define i1 @test_lshr_exact(i8 %p, i8* %pq, i8 %n) {
; CHECK-LABEL: @test_lshr_exact(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[A:%.*]] = phi i8 [ 64, [[ENTRY:%.*]] ], [ [[NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[NEXT]] = lshr exact i8 [[A]], 1
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i8 [[A]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP1]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    ret i1 false
;
entry:
  br label %loop
loop:
  %A = phi i8 [ 64, %entry ], [ %next, %loop ]
  %next = lshr exact i8 %A, 1
  %cmp1 = icmp eq i8 %A, %n
  br i1 %cmp1, label %exit, label %loop
exit:
  %cmp = icmp eq i8 %A, 0
  ret i1 %cmp
}

define i1 @test_lshr_may_wrap(i8 %p, i8* %pq, i8 %n) {
; CHECK-LABEL: @test_lshr_may_wrap(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[A:%.*]] = phi i8 [ 1, [[ENTRY:%.*]] ], [ [[NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[NEXT]] = lshr i8 [[A]], 1
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i8 [[A]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP1]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8 [[A]], 0
; CHECK-NEXT:    ret i1 [[CMP]]
;
entry:
  br label %loop
loop:
  %A = phi i8 [ 1, %entry ], [ %next, %loop ]
  %next = lshr i8 %A, 1
  %cmp1 = icmp eq i8 %A, %n
  br i1 %cmp1, label %exit, label %loop
exit:
  %cmp = icmp eq i8 %A, 0
  ret i1 %cmp
}

define i1 @test_lshr_zero_start(i8 %p, i8* %pq, i8 %n) {
; CHECK-LABEL: @test_lshr_zero_start(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[A:%.*]] = phi i8 [ 0, [[ENTRY:%.*]] ], [ [[NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[NEXT]] = lshr exact i8 [[A]], 1
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i8 [[A]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP1]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8 [[A]], 0
; CHECK-NEXT:    ret i1 [[CMP]]
;
entry:
  br label %loop
loop:
  %A = phi i8 [ 0, %entry ], [ %next, %loop ]
  %next = lshr exact i8 %A, 1
  %cmp1 = icmp eq i8 %A, %n
  br i1 %cmp1, label %exit, label %loop
exit:
  %cmp = icmp eq i8 %A, 0
  ret i1 %cmp
}

define i1 @test_ashr_exact(i8 %p, i8* %pq, i8 %n) {
; CHECK-LABEL: @test_ashr_exact(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[A:%.*]] = phi i8 [ 64, [[ENTRY:%.*]] ], [ [[NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[NEXT]] = ashr exact i8 [[A]], 1
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i8 [[A]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP1]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    ret i1 false
;
entry:
  br label %loop
loop:
  %A = phi i8 [ 64, %entry ], [ %next, %loop ]
  %next = ashr exact i8 %A, 1
  %cmp1 = icmp eq i8 %A, %n
  br i1 %cmp1, label %exit, label %loop
exit:
  %cmp = icmp eq i8 %A, 0
  ret i1 %cmp
}

define i1 @test_ashr_may_wrap(i8 %p, i8* %pq, i8 %n) {
; CHECK-LABEL: @test_ashr_may_wrap(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[A:%.*]] = phi i8 [ 1, [[ENTRY:%.*]] ], [ [[NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[NEXT]] = ashr i8 [[A]], 1
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i8 [[A]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP1]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8 [[A]], 0
; CHECK-NEXT:    ret i1 [[CMP]]
;
entry:
  br label %loop
loop:
  %A = phi i8 [ 1, %entry ], [ %next, %loop ]
  %next = ashr i8 %A, 1
  %cmp1 = icmp eq i8 %A, %n
  br i1 %cmp1, label %exit, label %loop
exit:
  %cmp = icmp eq i8 %A, 0
  ret i1 %cmp
}

define i1 @test_ashr_zero_start(i8 %p, i8* %pq, i8 %n) {
; CHECK-LABEL: @test_ashr_zero_start(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[A:%.*]] = phi i8 [ 0, [[ENTRY:%.*]] ], [ [[NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[NEXT]] = ashr exact i8 [[A]], 1
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i8 [[A]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP1]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8 [[A]], 0
; CHECK-NEXT:    ret i1 [[CMP]]
;
entry:
  br label %loop
loop:
  %A = phi i8 [ 0, %entry ], [ %next, %loop ]
  %next = ashr exact i8 %A, 1
  %cmp1 = icmp eq i8 %A, %n
  br i1 %cmp1, label %exit, label %loop
exit:
  %cmp = icmp eq i8 %A, 0
  ret i1 %cmp
}
