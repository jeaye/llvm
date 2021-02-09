; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

; Remove an icmp by using its operand in the subsequent logic directly.

define i8 @zext_or_icmp_icmp(i8 %a, i8 %b) {
; CHECK-LABEL: @zext_or_icmp_icmp(
; CHECK-NEXT:    [[MASK:%.*]] = and i8 [[A:%.*]], 1
; CHECK-NEXT:    [[TOBOOL2:%.*]] = icmp eq i8 [[B:%.*]], 0
; CHECK-NEXT:    [[TOBOOL22:%.*]] = zext i1 [[TOBOOL2]] to i8
; CHECK-NEXT:    [[TMP1:%.*]] = xor i8 [[MASK]], 1
; CHECK-NEXT:    [[ZEXT3:%.*]] = or i8 [[TMP1]], [[TOBOOL22]]
; CHECK-NEXT:    ret i8 [[ZEXT3]]
;
  %mask = and i8 %a, 1
  %toBool1 = icmp eq i8 %mask, 0
  %toBool2 = icmp eq i8 %b, 0
  %bothCond = or i1 %toBool1, %toBool2
  %zext = zext i1 %bothCond to i8
  ret i8 %zext
}

define i8 @zext_or_icmp_icmp_logical(i8 %a, i8 %b) {
; CHECK-LABEL: @zext_or_icmp_icmp_logical(
; CHECK-NEXT:    [[MASK:%.*]] = and i8 [[A:%.*]], 1
; CHECK-NEXT:    [[TOBOOL2:%.*]] = icmp eq i8 [[B:%.*]], 0
; CHECK-NEXT:    [[TOBOOL22:%.*]] = zext i1 [[TOBOOL2]] to i8
; CHECK-NEXT:    [[TMP1:%.*]] = xor i8 [[MASK]], 1
; CHECK-NEXT:    [[ZEXT3:%.*]] = or i8 [[TMP1]], [[TOBOOL22]]
; CHECK-NEXT:    ret i8 [[ZEXT3]]
;
  %mask = and i8 %a, 1
  %toBool1 = icmp eq i8 %mask, 0
  %toBool2 = icmp eq i8 %b, 0
  %bothCond = select i1 %toBool1, i1 true, i1 %toBool2
  %zext = zext i1 %bothCond to i8
  ret i8 %zext
}

; Here, widening the or from i1 to i32 and removing one of the icmps would
; widen an undef value (created by the out-of-range shift), increasing the
; range of valid values for the return, so we can't do it.

define i32 @dont_widen_undef() {
; CHECK-LABEL: @dont_widen_undef(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[BLOCK2:%.*]]
; CHECK:       block1:
; CHECK-NEXT:    br label [[BLOCK2]]
; CHECK:       block2:
; CHECK-NEXT:    [[CMP_I:%.*]] = phi i1 [ false, [[BLOCK1:%.*]] ], [ true, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[CMP115:%.*]] = phi i1 [ true, [[BLOCK1]] ], [ false, [[ENTRY]] ]
; CHECK-NEXT:    [[CMP1:%.*]] = or i1 [[CMP_I]], [[CMP115]]
; CHECK-NEXT:    [[CONV2:%.*]] = zext i1 [[CMP1]] to i32
; CHECK-NEXT:    ret i32 [[CONV2]]
;
entry:
  br label %block2

block1:
  br label %block2

block2:
  %m.011 = phi i32 [ 33, %entry ], [ 0, %block1 ]
  %cmp.i = icmp ugt i32 %m.011, 1
  %m.1.op = lshr i32 1, %m.011
  %sext.mask = and i32 %m.1.op, 65535
  %cmp115 = icmp ne i32 %sext.mask, 0
  %cmp1 = or i1 %cmp.i, %cmp115
  %conv2 = zext i1 %cmp1 to i32
  ret i32 %conv2
}

define i32 @dont_widen_undef_logical() {
; CHECK-LABEL: @dont_widen_undef_logical(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[BLOCK2:%.*]]
; CHECK:       block1:
; CHECK-NEXT:    br label [[BLOCK2]]
; CHECK:       block2:
; CHECK-NEXT:    [[CMP_I:%.*]] = phi i1 [ false, [[BLOCK1:%.*]] ], [ true, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[CMP115:%.*]] = phi i1 [ true, [[BLOCK1]] ], [ false, [[ENTRY]] ]
; CHECK-NEXT:    [[CMP1:%.*]] = or i1 [[CMP_I]], [[CMP115]]
; CHECK-NEXT:    [[CONV2:%.*]] = zext i1 [[CMP1]] to i32
; CHECK-NEXT:    ret i32 [[CONV2]]
;
entry:
  br label %block2

block1:
  br label %block2

block2:
  %m.011 = phi i32 [ 33, %entry ], [ 0, %block1 ]
  %cmp.i = icmp ugt i32 %m.011, 1
  %m.1.op = lshr i32 1, %m.011
  %sext.mask = and i32 %m.1.op, 65535
  %cmp115 = icmp ne i32 %sext.mask, 0
  %cmp1 = select i1 %cmp.i, i1 true, i1 %cmp115
  %conv2 = zext i1 %cmp1 to i32
  ret i32 %conv2
}
