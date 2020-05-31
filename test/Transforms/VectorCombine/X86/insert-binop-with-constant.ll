; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -vector-combine -S -mtriple=x86_64-- -mattr=SSE2 | FileCheck %s --check-prefixes=CHECK,SSE
; RUN: opt < %s -vector-combine -S -mtriple=x86_64-- -mattr=AVX2 | FileCheck %s --check-prefixes=CHECK,AVX

define <2 x i64> @add_constant(i64 %x) {
; CHECK-LABEL: @add_constant(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i64> undef, i64 [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = add <2 x i64> [[INS]], <i64 42, i64 undef>
; CHECK-NEXT:    ret <2 x i64> [[BO]]
;
  %ins = insertelement <2 x i64> undef, i64 %x, i32 0
  %bo = add <2 x i64> %ins, <i64 42, i64 undef>
  ret <2 x i64> %bo
}

define <2 x i64> @add_constant_not_undef_lane(i64 %x) {
; CHECK-LABEL: @add_constant_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i64> undef, i64 [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = add <2 x i64> [[INS]], <i64 42, i64 -42>
; CHECK-NEXT:    ret <2 x i64> [[BO]]
;
  %ins = insertelement <2 x i64> undef, i64 %x, i32 0
  %bo = add <2 x i64> %ins, <i64 42, i64 -42>
  ret <2 x i64> %bo
}

; IR flags are not required, but they should propagate.

define <4 x i32> @sub_constant_op0(i32 %x) {
; CHECK-LABEL: @sub_constant_op0(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <4 x i32> undef, i32 [[X:%.*]], i32 1
; CHECK-NEXT:    [[BO:%.*]] = sub nuw nsw <4 x i32> <i32 undef, i32 -42, i32 undef, i32 undef>, [[INS]]
; CHECK-NEXT:    ret <4 x i32> [[BO]]
;
  %ins = insertelement <4 x i32> undef, i32 %x, i32 1
  %bo = sub nsw nuw <4 x i32> <i32 undef, i32 -42, i32 undef, i32 undef>, %ins
  ret <4 x i32> %bo
}

define <4 x i32> @sub_constant_op0_not_undef_lane(i32 %x) {
; CHECK-LABEL: @sub_constant_op0_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <4 x i32> undef, i32 [[X:%.*]], i32 1
; CHECK-NEXT:    [[BO:%.*]] = sub nuw <4 x i32> <i32 1, i32 42, i32 42, i32 -42>, [[INS]]
; CHECK-NEXT:    ret <4 x i32> [[BO]]
;
  %ins = insertelement <4 x i32> undef, i32 %x, i32 1
  %bo = sub nuw <4 x i32> <i32 1, i32 42, i32 42, i32 -42>, %ins
  ret <4 x i32> %bo
}

define <8 x i16> @sub_constant_op1(i16 %x) {
; CHECK-LABEL: @sub_constant_op1(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <8 x i16> undef, i16 [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = sub nuw <8 x i16> [[INS]], <i16 42, i16 undef, i16 undef, i16 undef, i16 undef, i16 undef, i16 undef, i16 undef>
; CHECK-NEXT:    ret <8 x i16> [[BO]]
;
  %ins = insertelement <8 x i16> undef, i16 %x, i32 0
  %bo = sub nuw <8 x i16> %ins, <i16 42, i16 undef, i16 undef, i16 undef, i16 undef, i16 undef, i16 undef, i16 undef>
  ret <8 x i16> %bo
}

define <8 x i16> @sub_constant_op1_not_undef_lane(i16 %x) {
; CHECK-LABEL: @sub_constant_op1_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <8 x i16> undef, i16 [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = sub nuw <8 x i16> [[INS]], <i16 42, i16 -42, i16 0, i16 1, i16 -2, i16 3, i16 -4, i16 5>
; CHECK-NEXT:    ret <8 x i16> [[BO]]
;
  %ins = insertelement <8 x i16> undef, i16 %x, i32 0
  %bo = sub nuw <8 x i16> %ins, <i16 42, i16 -42, i16 0, i16 1, i16 -2, i16 3, i16 -4, i16 5>
  ret <8 x i16> %bo
}

define <16 x i8> @mul_constant(i8 %x) {
; CHECK-LABEL: @mul_constant(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <16 x i8> undef, i8 [[X:%.*]], i32 2
; CHECK-NEXT:    [[BO:%.*]] = mul <16 x i8> [[INS]], <i8 undef, i8 undef, i8 -42, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef>
; CHECK-NEXT:    ret <16 x i8> [[BO]]
;
  %ins = insertelement <16 x i8> undef, i8 %x, i32 2
  %bo = mul <16 x i8> %ins, <i8 undef, i8 undef, i8 -42, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef>
  ret <16 x i8> %bo
}

define <3 x i64> @mul_constant_not_undef_lane(i64 %x) {
; CHECK-LABEL: @mul_constant_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <3 x i64> undef, i64 [[X:%.*]], i32 2
; CHECK-NEXT:    [[BO:%.*]] = mul <3 x i64> [[INS]], <i64 42, i64 undef, i64 -42>
; CHECK-NEXT:    ret <3 x i64> [[BO]]
;
  %ins = insertelement <3 x i64> undef, i64 %x, i32 2
  %bo = mul <3 x i64> %ins, <i64 42, i64 undef, i64 -42>
  ret <3 x i64> %bo
}

define <2 x i64> @shl_constant_op0(i64 %x) {
; CHECK-LABEL: @shl_constant_op0(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i64> undef, i64 [[X:%.*]], i32 1
; CHECK-NEXT:    [[BO:%.*]] = shl <2 x i64> <i64 undef, i64 2>, [[INS]]
; CHECK-NEXT:    ret <2 x i64> [[BO]]
;
  %ins = insertelement <2 x i64> undef, i64 %x, i32 1
  %bo = shl <2 x i64> <i64 undef, i64 2>, %ins
  ret <2 x i64> %bo
}

define <2 x i64> @shl_constant_op0_not_undef_lane(i64 %x) {
; CHECK-LABEL: @shl_constant_op0_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i64> undef, i64 [[X:%.*]], i32 1
; CHECK-NEXT:    [[BO:%.*]] = shl <2 x i64> <i64 5, i64 2>, [[INS]]
; CHECK-NEXT:    ret <2 x i64> [[BO]]
;
  %ins = insertelement <2 x i64> undef, i64 %x, i32 1
  %bo = shl <2 x i64> <i64 5, i64 2>, %ins
  ret <2 x i64> %bo
}

define <2 x i64> @shl_constant_op1(i64 %x) {
; CHECK-LABEL: @shl_constant_op1(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i64> undef, i64 [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = shl nuw <2 x i64> [[INS]], <i64 5, i64 undef>
; CHECK-NEXT:    ret <2 x i64> [[BO]]
;
  %ins = insertelement <2 x i64> undef, i64 %x, i32 0
  %bo = shl nuw <2 x i64> %ins, <i64 5, i64 undef>
  ret <2 x i64> %bo
}

define <2 x i64> @shl_constant_op1_not_undef_lane(i64 %x) {
; CHECK-LABEL: @shl_constant_op1_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i64> undef, i64 [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = shl nuw <2 x i64> [[INS]], <i64 5, i64 2>
; CHECK-NEXT:    ret <2 x i64> [[BO]]
;
  %ins = insertelement <2 x i64> undef, i64 %x, i32 0
  %bo = shl nuw <2 x i64> %ins, <i64 5, i64 2>
  ret <2 x i64> %bo
}

define <2 x i64> @ashr_constant_op0(i64 %x) {
; CHECK-LABEL: @ashr_constant_op0(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i64> undef, i64 [[X:%.*]], i32 1
; CHECK-NEXT:    [[BO:%.*]] = ashr exact <2 x i64> <i64 undef, i64 2>, [[INS]]
; CHECK-NEXT:    ret <2 x i64> [[BO]]
;
  %ins = insertelement <2 x i64> undef, i64 %x, i32 1
  %bo = ashr exact <2 x i64> <i64 undef, i64 2>, %ins
  ret <2 x i64> %bo
}

define <2 x i64> @ashr_constant_op0_not_undef_lane(i64 %x) {
; CHECK-LABEL: @ashr_constant_op0_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i64> undef, i64 [[X:%.*]], i32 1
; CHECK-NEXT:    [[BO:%.*]] = ashr exact <2 x i64> <i64 5, i64 2>, [[INS]]
; CHECK-NEXT:    ret <2 x i64> [[BO]]
;
  %ins = insertelement <2 x i64> undef, i64 %x, i32 1
  %bo = ashr exact <2 x i64> <i64 5, i64 2>, %ins
  ret <2 x i64> %bo
}

define <2 x i64> @ashr_constant_op1(i64 %x) {
; CHECK-LABEL: @ashr_constant_op1(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i64> undef, i64 [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = ashr <2 x i64> [[INS]], <i64 5, i64 undef>
; CHECK-NEXT:    ret <2 x i64> [[BO]]
;
  %ins = insertelement <2 x i64> undef, i64 %x, i32 0
  %bo = ashr <2 x i64> %ins, <i64 5, i64 undef>
  ret <2 x i64> %bo
}

define <2 x i64> @ashr_constant_op1_not_undef_lane(i64 %x) {
; CHECK-LABEL: @ashr_constant_op1_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i64> undef, i64 [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = ashr <2 x i64> [[INS]], <i64 5, i64 2>
; CHECK-NEXT:    ret <2 x i64> [[BO]]
;
  %ins = insertelement <2 x i64> undef, i64 %x, i32 0
  %bo = ashr <2 x i64> %ins, <i64 5, i64 2>
  ret <2 x i64> %bo
}

define <2 x i64> @lshr_constant_op0(i64 %x) {
; CHECK-LABEL: @lshr_constant_op0(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i64> undef, i64 [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = lshr <2 x i64> <i64 5, i64 undef>, [[INS]]
; CHECK-NEXT:    ret <2 x i64> [[BO]]
;
  %ins = insertelement <2 x i64> undef, i64 %x, i32 0
  %bo = lshr <2 x i64> <i64 5, i64 undef>, %ins
  ret <2 x i64> %bo
}

define <2 x i64> @lshr_constant_op0_not_undef_lane(i64 %x) {
; CHECK-LABEL: @lshr_constant_op0_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i64> undef, i64 [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = lshr <2 x i64> <i64 5, i64 2>, [[INS]]
; CHECK-NEXT:    ret <2 x i64> [[BO]]
;
  %ins = insertelement <2 x i64> undef, i64 %x, i32 0
  %bo = lshr <2 x i64> <i64 5, i64 2>, %ins
  ret <2 x i64> %bo
}

define <2 x i64> @lshr_constant_op1(i64 %x) {
; CHECK-LABEL: @lshr_constant_op1(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i64> undef, i64 [[X:%.*]], i32 1
; CHECK-NEXT:    [[BO:%.*]] = lshr exact <2 x i64> [[INS]], <i64 undef, i64 2>
; CHECK-NEXT:    ret <2 x i64> [[BO]]
;
  %ins = insertelement <2 x i64> undef, i64 %x, i32 1
  %bo = lshr exact <2 x i64> %ins, <i64 undef, i64 2>
  ret <2 x i64> %bo
}

define <2 x i64> @lshr_constant_op1_not_undef_lane(i64 %x) {
; CHECK-LABEL: @lshr_constant_op1_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i64> undef, i64 [[X:%.*]], i32 1
; CHECK-NEXT:    [[BO:%.*]] = lshr exact <2 x i64> [[INS]], <i64 5, i64 2>
; CHECK-NEXT:    ret <2 x i64> [[BO]]
;
  %ins = insertelement <2 x i64> undef, i64 %x, i32 1
  %bo = lshr exact <2 x i64> %ins, <i64 5, i64 2>
  ret <2 x i64> %bo
}

define <2 x i64> @urem_constant_op0(i64 %x) {
; CHECK-LABEL: @urem_constant_op0(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i64> undef, i64 [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = urem <2 x i64> <i64 5, i64 undef>, [[INS]]
; CHECK-NEXT:    ret <2 x i64> [[BO]]
;
  %ins = insertelement <2 x i64> undef, i64 %x, i32 0
  %bo = urem <2 x i64> <i64 5, i64 undef>, %ins
  ret <2 x i64> %bo
}

define <2 x i64> @urem_constant_op0_not_undef_lane(i64 %x) {
; CHECK-LABEL: @urem_constant_op0_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i64> undef, i64 [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = urem <2 x i64> <i64 5, i64 2>, [[INS]]
; CHECK-NEXT:    ret <2 x i64> [[BO]]
;
  %ins = insertelement <2 x i64> undef, i64 %x, i32 0
  %bo = urem <2 x i64> <i64 5, i64 2>, %ins
  ret <2 x i64> %bo
}

define <2 x i64> @urem_constant_op1(i64 %x) {
; CHECK-LABEL: @urem_constant_op1(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i64> undef, i64 [[X:%.*]], i32 1
; CHECK-NEXT:    [[BO:%.*]] = urem <2 x i64> [[INS]], <i64 undef, i64 2>
; CHECK-NEXT:    ret <2 x i64> [[BO]]
;
  %ins = insertelement <2 x i64> undef, i64 %x, i32 1
  %bo = urem <2 x i64> %ins, <i64 undef, i64 2>
  ret <2 x i64> %bo
}

define <2 x i64> @urem_constant_op1_not_undef_lane(i64 %x) {
; CHECK-LABEL: @urem_constant_op1_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i64> undef, i64 [[X:%.*]], i32 1
; CHECK-NEXT:    [[BO:%.*]] = urem <2 x i64> [[INS]], <i64 5, i64 2>
; CHECK-NEXT:    ret <2 x i64> [[BO]]
;
  %ins = insertelement <2 x i64> undef, i64 %x, i32 1
  %bo = urem <2 x i64> %ins, <i64 5, i64 2>
  ret <2 x i64> %bo
}

define <2 x i64> @srem_constant_op0(i64 %x) {
; CHECK-LABEL: @srem_constant_op0(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i64> undef, i64 [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = srem <2 x i64> <i64 5, i64 undef>, [[INS]]
; CHECK-NEXT:    ret <2 x i64> [[BO]]
;
  %ins = insertelement <2 x i64> undef, i64 %x, i32 0
  %bo = srem <2 x i64> <i64 5, i64 undef>, %ins
  ret <2 x i64> %bo
}

define <2 x i64> @srem_constant_op0_not_undef_lane(i64 %x) {
; CHECK-LABEL: @srem_constant_op0_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i64> undef, i64 [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = srem <2 x i64> <i64 5, i64 2>, [[INS]]
; CHECK-NEXT:    ret <2 x i64> [[BO]]
;
  %ins = insertelement <2 x i64> undef, i64 %x, i32 0
  %bo = srem <2 x i64> <i64 5, i64 2>, %ins
  ret <2 x i64> %bo
}

define <2 x i64> @srem_constant_op1(i64 %x) {
; CHECK-LABEL: @srem_constant_op1(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i64> undef, i64 [[X:%.*]], i32 1
; CHECK-NEXT:    [[BO:%.*]] = srem <2 x i64> [[INS]], <i64 undef, i64 2>
; CHECK-NEXT:    ret <2 x i64> [[BO]]
;
  %ins = insertelement <2 x i64> undef, i64 %x, i32 1
  %bo = srem <2 x i64> %ins, <i64 undef, i64 2>
  ret <2 x i64> %bo
}

define <2 x i64> @srem_constant_op1_not_undef_lane(i64 %x) {
; CHECK-LABEL: @srem_constant_op1_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i64> undef, i64 [[X:%.*]], i32 1
; CHECK-NEXT:    [[BO:%.*]] = srem <2 x i64> [[INS]], <i64 5, i64 2>
; CHECK-NEXT:    ret <2 x i64> [[BO]]
;
  %ins = insertelement <2 x i64> undef, i64 %x, i32 1
  %bo = srem <2 x i64> %ins, <i64 5, i64 2>
  ret <2 x i64> %bo
}

define <2 x i64> @udiv_constant_op0(i64 %x) {
; CHECK-LABEL: @udiv_constant_op0(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i64> undef, i64 [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = udiv exact <2 x i64> <i64 5, i64 undef>, [[INS]]
; CHECK-NEXT:    ret <2 x i64> [[BO]]
;
  %ins = insertelement <2 x i64> undef, i64 %x, i32 0
  %bo = udiv exact <2 x i64> <i64 5, i64 undef>, %ins
  ret <2 x i64> %bo
}

define <2 x i64> @udiv_constant_op0_not_undef_lane(i64 %x) {
; CHECK-LABEL: @udiv_constant_op0_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i64> undef, i64 [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = udiv exact <2 x i64> <i64 5, i64 2>, [[INS]]
; CHECK-NEXT:    ret <2 x i64> [[BO]]
;
  %ins = insertelement <2 x i64> undef, i64 %x, i32 0
  %bo = udiv exact <2 x i64> <i64 5, i64 2>, %ins
  ret <2 x i64> %bo
}

define <2 x i64> @udiv_constant_op1(i64 %x) {
; CHECK-LABEL: @udiv_constant_op1(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i64> undef, i64 [[X:%.*]], i32 1
; CHECK-NEXT:    [[BO:%.*]] = udiv <2 x i64> [[INS]], <i64 undef, i64 2>
; CHECK-NEXT:    ret <2 x i64> [[BO]]
;
  %ins = insertelement <2 x i64> undef, i64 %x, i32 1
  %bo = udiv <2 x i64> %ins, <i64 undef, i64 2>
  ret <2 x i64> %bo
}

define <2 x i64> @udiv_constant_op1_not_undef_lane(i64 %x) {
; CHECK-LABEL: @udiv_constant_op1_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i64> undef, i64 [[X:%.*]], i32 1
; CHECK-NEXT:    [[BO:%.*]] = udiv <2 x i64> [[INS]], <i64 5, i64 2>
; CHECK-NEXT:    ret <2 x i64> [[BO]]
;
  %ins = insertelement <2 x i64> undef, i64 %x, i32 1
  %bo = udiv <2 x i64> %ins, <i64 5, i64 2>
  ret <2 x i64> %bo
}

define <2 x i64> @sdiv_constant_op0(i64 %x) {
; CHECK-LABEL: @sdiv_constant_op0(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i64> undef, i64 [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = sdiv <2 x i64> <i64 5, i64 undef>, [[INS]]
; CHECK-NEXT:    ret <2 x i64> [[BO]]
;
  %ins = insertelement <2 x i64> undef, i64 %x, i32 0
  %bo = sdiv <2 x i64> <i64 5, i64 undef>, %ins
  ret <2 x i64> %bo
}

define <2 x i64> @sdiv_constant_op0_not_undef_lane(i64 %x) {
; CHECK-LABEL: @sdiv_constant_op0_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i64> undef, i64 [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = sdiv <2 x i64> <i64 5, i64 2>, [[INS]]
; CHECK-NEXT:    ret <2 x i64> [[BO]]
;
  %ins = insertelement <2 x i64> undef, i64 %x, i32 0
  %bo = sdiv <2 x i64> <i64 5, i64 2>, %ins
  ret <2 x i64> %bo
}

define <2 x i64> @sdiv_constant_op1(i64 %x) {
; CHECK-LABEL: @sdiv_constant_op1(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i64> undef, i64 [[X:%.*]], i32 1
; CHECK-NEXT:    [[BO:%.*]] = sdiv exact <2 x i64> [[INS]], <i64 undef, i64 2>
; CHECK-NEXT:    ret <2 x i64> [[BO]]
;
  %ins = insertelement <2 x i64> undef, i64 %x, i32 1
  %bo = sdiv exact <2 x i64> %ins, <i64 undef, i64 2>
  ret <2 x i64> %bo
}

define <2 x i64> @sdiv_constant_op1_not_undef_lane(i64 %x) {
; CHECK-LABEL: @sdiv_constant_op1_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i64> undef, i64 [[X:%.*]], i32 1
; CHECK-NEXT:    [[BO:%.*]] = sdiv exact <2 x i64> [[INS]], <i64 5, i64 2>
; CHECK-NEXT:    ret <2 x i64> [[BO]]
;
  %ins = insertelement <2 x i64> undef, i64 %x, i32 1
  %bo = sdiv exact <2 x i64> %ins, <i64 5, i64 2>
  ret <2 x i64> %bo
}

define <2 x i64> @and_constant(i64 %x) {
; CHECK-LABEL: @and_constant(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i64> undef, i64 [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = and <2 x i64> [[INS]], <i64 42, i64 undef>
; CHECK-NEXT:    ret <2 x i64> [[BO]]
;
  %ins = insertelement <2 x i64> undef, i64 %x, i32 0
  %bo = and <2 x i64> %ins, <i64 42, i64 undef>
  ret <2 x i64> %bo
}

define <2 x i64> @and_constant_not_undef_lane(i64 %x) {
; CHECK-LABEL: @and_constant_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i64> undef, i64 [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = and <2 x i64> [[INS]], <i64 42, i64 -42>
; CHECK-NEXT:    ret <2 x i64> [[BO]]
;
  %ins = insertelement <2 x i64> undef, i64 %x, i32 0
  %bo = and <2 x i64> %ins, <i64 42, i64 -42>
  ret <2 x i64> %bo
}

define <2 x i64> @or_constant(i64 %x) {
; CHECK-LABEL: @or_constant(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i64> undef, i64 [[X:%.*]], i32 1
; CHECK-NEXT:    [[BO:%.*]] = or <2 x i64> [[INS]], <i64 undef, i64 -42>
; CHECK-NEXT:    ret <2 x i64> [[BO]]
;
  %ins = insertelement <2 x i64> undef, i64 %x, i32 1
  %bo = or <2 x i64> %ins, <i64 undef, i64 -42>
  ret <2 x i64> %bo
}

define <2 x i64> @or_constant_not_undef_lane(i64 %x) {
; CHECK-LABEL: @or_constant_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i64> undef, i64 [[X:%.*]], i32 1
; CHECK-NEXT:    [[BO:%.*]] = or <2 x i64> [[INS]], <i64 42, i64 -42>
; CHECK-NEXT:    ret <2 x i64> [[BO]]
;
  %ins = insertelement <2 x i64> undef, i64 %x, i32 1
  %bo = or <2 x i64> %ins, <i64 42, i64 -42>
  ret <2 x i64> %bo
}

define <2 x i64> @xor_constant(i64 %x) {
; CHECK-LABEL: @xor_constant(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i64> undef, i64 [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = xor <2 x i64> [[INS]], <i64 42, i64 undef>
; CHECK-NEXT:    ret <2 x i64> [[BO]]
;
  %ins = insertelement <2 x i64> undef, i64 %x, i32 0
  %bo = xor <2 x i64> %ins, <i64 42, i64 undef>
  ret <2 x i64> %bo
}

define <2 x i64> @xor_constant_not_undef_lane(i64 %x) {
; CHECK-LABEL: @xor_constant_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x i64> undef, i64 [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = xor <2 x i64> [[INS]], <i64 42, i64 -42>
; CHECK-NEXT:    ret <2 x i64> [[BO]]
;
  %ins = insertelement <2 x i64> undef, i64 %x, i32 0
  %bo = xor <2 x i64> %ins, <i64 42, i64 -42>
  ret <2 x i64> %bo
}

define <2 x double> @fadd_constant(double %x) {
; CHECK-LABEL: @fadd_constant(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x double> undef, double [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = fadd <2 x double> [[INS]], <double 4.200000e+01, double undef>
; CHECK-NEXT:    ret <2 x double> [[BO]]
;
  %ins = insertelement <2 x double> undef, double %x, i32 0
  %bo = fadd <2 x double> %ins, <double 42.0, double undef>
  ret <2 x double> %bo
}

define <2 x double> @fadd_constant_not_undef_lane(double %x) {
; CHECK-LABEL: @fadd_constant_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x double> undef, double [[X:%.*]], i32 1
; CHECK-NEXT:    [[BO:%.*]] = fadd <2 x double> [[INS]], <double 4.200000e+01, double -4.200000e+01>
; CHECK-NEXT:    ret <2 x double> [[BO]]
;
  %ins = insertelement <2 x double> undef, double %x, i32 1
  %bo = fadd <2 x double> %ins, <double 42.0, double -42.0>
  ret <2 x double> %bo
}

define <2 x double> @fsub_constant_op0(double %x) {
; CHECK-LABEL: @fsub_constant_op0(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x double> undef, double [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = fsub fast <2 x double> <double 4.200000e+01, double undef>, [[INS]]
; CHECK-NEXT:    ret <2 x double> [[BO]]
;
  %ins = insertelement <2 x double> undef, double %x, i32 0
  %bo = fsub fast <2 x double> <double 42.0, double undef>, %ins
  ret <2 x double> %bo
}

define <2 x double> @fsub_constant_op0_not_undef_lane(double %x) {
; CHECK-LABEL: @fsub_constant_op0_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x double> undef, double [[X:%.*]], i32 1
; CHECK-NEXT:    [[BO:%.*]] = fsub nsz <2 x double> <double 4.200000e+01, double -4.200000e+01>, [[INS]]
; CHECK-NEXT:    ret <2 x double> [[BO]]
;
  %ins = insertelement <2 x double> undef, double %x, i32 1
  %bo = fsub nsz <2 x double> <double 42.0, double -42.0>, %ins
  ret <2 x double> %bo
}

define <2 x double> @fsub_constant_op1(double %x) {
; CHECK-LABEL: @fsub_constant_op1(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x double> undef, double [[X:%.*]], i32 1
; CHECK-NEXT:    [[BO:%.*]] = fsub <2 x double> [[INS]], <double undef, double 4.200000e+01>
; CHECK-NEXT:    ret <2 x double> [[BO]]
;
  %ins = insertelement <2 x double> undef, double %x, i32 1
  %bo = fsub <2 x double> %ins, <double undef, double 42.0>
  ret <2 x double> %bo
}

define <2 x double> @fsub_constant_op1_not_undef_lane(double %x) {
; CHECK-LABEL: @fsub_constant_op1_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x double> undef, double [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = fsub <2 x double> [[INS]], <double 4.200000e+01, double -4.200000e+01>
; CHECK-NEXT:    ret <2 x double> [[BO]]
;
  %ins = insertelement <2 x double> undef, double %x, i32 0
  %bo = fsub <2 x double> %ins, <double 42.0, double -42.0>
  ret <2 x double> %bo
}

define <2 x double> @fmul_constant(double %x) {
; CHECK-LABEL: @fmul_constant(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x double> undef, double [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = fmul reassoc <2 x double> [[INS]], <double 4.200000e+01, double undef>
; CHECK-NEXT:    ret <2 x double> [[BO]]
;
  %ins = insertelement <2 x double> undef, double %x, i32 0
  %bo = fmul reassoc <2 x double> %ins, <double 42.0, double undef>
  ret <2 x double> %bo
}

define <2 x double> @fmul_constant_not_undef_lane(double %x) {
; CHECK-LABEL: @fmul_constant_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x double> undef, double [[X:%.*]], i32 1
; CHECK-NEXT:    [[BO:%.*]] = fmul <2 x double> [[INS]], <double 4.200000e+01, double -4.200000e+01>
; CHECK-NEXT:    ret <2 x double> [[BO]]
;
  %ins = insertelement <2 x double> undef, double %x, i32 1
  %bo = fmul <2 x double> %ins, <double 42.0, double -42.0>
  ret <2 x double> %bo
}

define <2 x double> @fdiv_constant_op0(double %x) {
; CHECK-LABEL: @fdiv_constant_op0(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x double> undef, double [[X:%.*]], i32 1
; CHECK-NEXT:    [[BO:%.*]] = fdiv nnan <2 x double> <double undef, double 4.200000e+01>, [[INS]]
; CHECK-NEXT:    ret <2 x double> [[BO]]
;
  %ins = insertelement <2 x double> undef, double %x, i32 1
  %bo = fdiv nnan <2 x double> <double undef, double 42.0>, %ins
  ret <2 x double> %bo
}

define <2 x double> @fdiv_constant_op0_not_undef_lane(double %x) {
; CHECK-LABEL: @fdiv_constant_op0_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x double> undef, double [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = fdiv ninf <2 x double> <double 4.200000e+01, double -4.200000e+01>, [[INS]]
; CHECK-NEXT:    ret <2 x double> [[BO]]
;
  %ins = insertelement <2 x double> undef, double %x, i32 0
  %bo = fdiv ninf <2 x double> <double 42.0, double -42.0>, %ins
  ret <2 x double> %bo
}

define <2 x double> @fdiv_constant_op1(double %x) {
; CHECK-LABEL: @fdiv_constant_op1(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x double> undef, double [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = fdiv <2 x double> [[INS]], <double 4.200000e+01, double undef>
; CHECK-NEXT:    ret <2 x double> [[BO]]
;
  %ins = insertelement <2 x double> undef, double %x, i32 0
  %bo = fdiv <2 x double> %ins, <double 42.0, double undef>
  ret <2 x double> %bo
}

define <2 x double> @fdiv_constant_op1_not_undef_lane(double %x) {
; CHECK-LABEL: @fdiv_constant_op1_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x double> undef, double [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = fdiv <2 x double> [[INS]], <double 4.200000e+01, double -4.200000e+01>
; CHECK-NEXT:    ret <2 x double> [[BO]]
;
  %ins = insertelement <2 x double> undef, double %x, i32 0
  %bo = fdiv <2 x double> %ins, <double 42.0, double -42.0>
  ret <2 x double> %bo
}

define <2 x double> @frem_constant_op0(double %x) {
; CHECK-LABEL: @frem_constant_op0(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x double> undef, double [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = frem fast <2 x double> <double 4.200000e+01, double undef>, [[INS]]
; CHECK-NEXT:    ret <2 x double> [[BO]]
;
  %ins = insertelement <2 x double> undef, double %x, i32 0
  %bo = frem fast <2 x double> <double 42.0, double undef>, %ins
  ret <2 x double> %bo
}

define <2 x double> @frem_constant_op0_not_undef_lane(double %x) {
; CHECK-LABEL: @frem_constant_op0_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x double> undef, double [[X:%.*]], i32 1
; CHECK-NEXT:    [[BO:%.*]] = frem <2 x double> <double 4.200000e+01, double -4.200000e+01>, [[INS]]
; CHECK-NEXT:    ret <2 x double> [[BO]]
;
  %ins = insertelement <2 x double> undef, double %x, i32 1
  %bo = frem <2 x double> <double 42.0, double -42.0>, %ins
  ret <2 x double> %bo
}

define <2 x double> @frem_constant_op1(double %x) {
; CHECK-LABEL: @frem_constant_op1(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x double> undef, double [[X:%.*]], i32 1
; CHECK-NEXT:    [[BO:%.*]] = frem ninf <2 x double> [[INS]], <double undef, double 4.200000e+01>
; CHECK-NEXT:    ret <2 x double> [[BO]]
;
  %ins = insertelement <2 x double> undef, double %x, i32 1
  %bo = frem ninf <2 x double> %ins, <double undef, double 42.0>
  ret <2 x double> %bo
}

define <2 x double> @frem_constant_op1_not_undef_lane(double %x) {
; CHECK-LABEL: @frem_constant_op1_not_undef_lane(
; CHECK-NEXT:    [[INS:%.*]] = insertelement <2 x double> undef, double [[X:%.*]], i32 0
; CHECK-NEXT:    [[BO:%.*]] = frem nnan <2 x double> [[INS]], <double 4.200000e+01, double -4.200000e+01>
; CHECK-NEXT:    ret <2 x double> [[BO]]
;
  %ins = insertelement <2 x double> undef, double %x, i32 0
  %bo = frem nnan <2 x double> %ins, <double 42.0, double -42.0>
  ret <2 x double> %bo
}
