; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -instcombine < %s | FileCheck %s


define i32 @and_umax_less(i32 %A) {
; CHECK-LABEL: @and_umax_less(
; CHECK-NEXT:    [[X:%.*]] = and i32 [[A:%.*]], -32
; CHECK-NEXT:    ret i32 [[X]]
;
  %l0 = icmp ugt i32 31, %A
  %l1 = select i1 %l0, i32 31, i32 %A
  %x = and i32 %l1, -32
  ret i32 %x
}

define i32 @and_umax_muchless(i32 %A) {
; CHECK-LABEL: @and_umax_muchless(
; CHECK-NEXT:    [[X:%.*]] = and i32 [[A:%.*]], -32
; CHECK-NEXT:    ret i32 [[X]]
;
  %l0 = icmp ugt i32 12, %A
  %l1 = select i1 %l0, i32 12, i32 %A
  %x = and i32 %l1, -32
  ret i32 %x
}

define i32 @and_umax_more(i32 %A) {
; CHECK-LABEL: @and_umax_more(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ugt i32 [[A:%.*]], 32
; CHECK-NEXT:    [[L1:%.*]] = select i1 [[TMP1]], i32 [[A]], i32 32
; CHECK-NEXT:    [[X:%.*]] = and i32 [[L1]], -32
; CHECK-NEXT:    ret i32 [[X]]
;
  %l0 = icmp ugt i32 32, %A
  %l1 = select i1 %l0, i32 32, i32 %A
  %x = and i32 %l1, -32
  ret i32 %x
}

define i32 @shr_umax(i32 %A) {
; CHECK-LABEL: @shr_umax(
; CHECK-NEXT:    [[X:%.*]] = lshr i32 [[A:%.*]], 4
; CHECK-NEXT:    ret i32 [[X]]
;
  %l0 = icmp ugt i32 15, %A
  %l1 = select i1 %l0, i32 15, i32 %A
  %x = lshr i32 %l1, 4
  ret i32 %x
}

; Various constants for C2 & umax(A, C1)

define i8 @t_0_1(i8 %A) {
; CHECK-LABEL: @t_0_1(
; CHECK-NEXT:    [[X:%.*]] = and i8 [[A:%.*]], 1
; CHECK-NEXT:    ret i8 [[X]]
;
  %l2 = icmp ugt i8 %A, 0
  %l1 = select i1 %l2, i8 %A, i8 0
  %x = and i8 %l1, 1
  ret i8 %x
}

define i8 @t_0_10(i8 %A) {
; CHECK-LABEL: @t_0_10(
; CHECK-NEXT:    [[X:%.*]] = and i8 [[A:%.*]], 10
; CHECK-NEXT:    ret i8 [[X]]
;
  %l2 = icmp ugt i8 %A, 0
  %l1 = select i1 %l2, i8 %A, i8 0
  %x = and i8 %l1, 10
  ret i8 %x
}

define i8 @t_1_10(i8 %A) {
; CHECK-LABEL: @t_1_10(
; CHECK-NEXT:    [[X:%.*]] = and i8 [[A:%.*]], 10
; CHECK-NEXT:    ret i8 [[X]]
;
  %l2 = icmp ugt i8 %A, 1
  %l1 = select i1 %l2, i8 %A, i8 1
  %x = and i8 %l1, 10
  ret i8 %x
}

define i8 @t_2_4(i8 %A) {
; CHECK-LABEL: @t_2_4(
; CHECK-NEXT:    [[X:%.*]] = and i8 [[A:%.*]], 4
; CHECK-NEXT:    ret i8 [[X]]
;
  %l2 = icmp ugt i8 %A, 2
  %l1 = select i1 %l2, i8 %A, i8 2
  %x = and i8 %l1, 4
  ret i8 %x
}

define i8 @t_2_192(i8 %A) {
; CHECK-LABEL: @t_2_192(
; CHECK-NEXT:    [[X:%.*]] = and i8 [[A:%.*]], -64
; CHECK-NEXT:    ret i8 [[X]]
;
  %l2 = icmp ugt i8 %A, 2
  %l1 = select i1 %l2, i8 %A, i8 2
  %x = and i8 %l1, -64
  ret i8 %x
}

define i8 @t_2_63_or(i8 %A) {
; CHECK-LABEL: @t_2_63_or(
; CHECK-NEXT:    [[X:%.*]] = or i8 [[A:%.*]], 63
; CHECK-NEXT:    ret i8 [[X]]
;
  %l2 = icmp ugt i8 %A, 2
  %l1 = select i1 %l2, i8 %A, i8 2
  %x = or i8 %l1, 63
  ret i8 %x
}

define i8 @f_1_1(i8 %A) {
; CHECK-LABEL: @f_1_1(
; CHECK-NEXT:    [[L2:%.*]] = icmp ugt i8 [[A:%.*]], 1
; CHECK-NEXT:    [[L1:%.*]] = select i1 [[L2]], i8 [[A]], i8 1
; CHECK-NEXT:    [[X:%.*]] = and i8 [[L1]], 1
; CHECK-NEXT:    ret i8 [[X]]
;
  %l2 = icmp ugt i8 %A, 1
  %l1 = select i1 %l2, i8 %A, i8 1
  %x = and i8 %l1, 1
  ret i8 %x
}

define i8 @f_32_32(i8 %A) {
; CHECK-LABEL: @f_32_32(
; CHECK-NEXT:    [[L2:%.*]] = icmp ugt i8 [[A:%.*]], 32
; CHECK-NEXT:    [[L1:%.*]] = select i1 [[L2]], i8 [[A]], i8 32
; CHECK-NEXT:    [[X:%.*]] = and i8 [[L1]], -32
; CHECK-NEXT:    ret i8 [[X]]
;
  %l2 = icmp ugt i8 %A, 32
  %l1 = select i1 %l2, i8 %A, i8 32
  %x = and i8 %l1, -32
  ret i8 %x
}

define i8 @f_191_192(i8 %A) {
; CHECK-LABEL: @f_191_192(
; CHECK-NEXT:    [[L2:%.*]] = icmp ugt i8 [[A:%.*]], -65
; CHECK-NEXT:    [[L1:%.*]] = select i1 [[L2]], i8 [[A]], i8 -65
; CHECK-NEXT:    [[X:%.*]] = and i8 [[L1]], -64
; CHECK-NEXT:    ret i8 [[X]]
;
  %l2 = icmp ugt i8 %A, 191
  %l1 = select i1 %l2, i8 %A, i8 191
  %x = and i8 %l1, 192
  ret i8 %x
}

define i8 @f_10_1(i8 %A) {
; CHECK-LABEL: @f_10_1(
; CHECK-NEXT:    [[L2:%.*]] = icmp ugt i8 [[A:%.*]], 10
; CHECK-NEXT:    [[L1:%.*]] = select i1 [[L2]], i8 [[A]], i8 10
; CHECK-NEXT:    [[X:%.*]] = and i8 [[L1]], 1
; CHECK-NEXT:    ret i8 [[X]]
;
  %l2 = icmp ugt i8 %A, 10
  %l1 = select i1 %l2, i8 %A, i8 10
  %x = and i8 %l1, 1
  ret i8 %x
}

define i32 @and_umin(i32 %A) {
; CHECK-LABEL: @and_umin(
; CHECK-NEXT:    ret i32 0
;
  %l0 = icmp ult i32 15, %A
  %l1 = select i1 %l0, i32 15, i32 %A
  %x = and i32 %l1, -32
  ret i32 %x
}

define i32 @or_umin(i32 %A) {
; CHECK-LABEL: @or_umin(
; CHECK-NEXT:    ret i32 31
;
  %l0 = icmp ult i32 15, %A
  %l1 = select i1 %l0, i32 15, i32 %A
  %x = or i32 %l1, 31
  ret i32 %x
}

define i8 @or_min_31_30(i8 %A) {
; CHECK-LABEL: @or_min_31_30(
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i8 [[A:%.*]], -30
; CHECK-NEXT:    [[MIN:%.*]] = select i1 [[CMP]], i8 [[A]], i8 -30
; CHECK-NEXT:    [[R:%.*]] = or i8 [[MIN]], 31
; CHECK-NEXT:    ret i8 [[R]]
;
  %cmp = icmp ult i8 %A, -30
  %min = select i1 %cmp, i8 %A, i8 -30
  %r = or i8 %min, 31
  ret i8 %r
}

define i8 @and_min_7_7(i8 %A) {
; CHECK-LABEL: @and_min_7_7(
; CHECK-NEXT:    [[L2:%.*]] = icmp ult i8 [[A:%.*]], -7
; CHECK-NEXT:    [[MIN:%.*]] = select i1 [[L2]], i8 [[A]], i8 -7
; CHECK-NEXT:    [[R:%.*]] = and i8 [[MIN]], -8
; CHECK-NEXT:    ret i8 [[R]]
;
  %l2 = icmp ult i8 %A, -7
  %min = select i1 %l2, i8 %A, i8 -7
  %r = and i8 %min, -8
  ret i8 %r
}

define i8 @and_min_7_8(i8 %A) {
; CHECK-LABEL: @and_min_7_8(
; CHECK-NEXT:    [[L2:%.*]] = icmp ult i8 [[A:%.*]], -8
; CHECK-NEXT:    [[MIN:%.*]] = select i1 [[L2]], i8 [[A]], i8 -8
; CHECK-NEXT:    [[R:%.*]] = and i8 [[MIN]], -8
; CHECK-NEXT:    ret i8 [[R]]
;
  %l2 = icmp ult i8 %A, -8
  %min = select i1 %l2, i8 %A, i8 -8
  %r = and i8 %min, -8
  ret i8 %r
}

define i8 @and_min_7_9(i8 %A) {
; CHECK-LABEL: @and_min_7_9(
; CHECK-NEXT:    [[L2:%.*]] = icmp ult i8 [[A:%.*]], -9
; CHECK-NEXT:    [[MIN:%.*]] = select i1 [[L2]], i8 [[A]], i8 -9
; CHECK-NEXT:    [[R:%.*]] = and i8 [[MIN]], -8
; CHECK-NEXT:    ret i8 [[R]]
;
  %l2 = icmp ult i8 %A, -9
  %min = select i1 %l2, i8 %A, i8 -9
  %r = and i8 %min, -8
  ret i8 %r
}

