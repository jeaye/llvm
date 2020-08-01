; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

declare i32 @llvm.abs.i32(i32, i1)
declare <4 x i32> @llvm.abs.v4i32(<4 x i32>, i1)

define i1 @abs_nsw_must_be_positive(i32 %x) {
; CHECK-LABEL: @abs_nsw_must_be_positive(
; CHECK-NEXT:    ret i1 true
;
  %abs = call i32 @llvm.abs.i32(i32 %x, i1 true)
  %c2 = icmp sge i32 %abs, 0
  ret i1 %c2
}

define <4 x i1> @abs_nsw_must_be_positive_vec(<4 x i32> %x) {
; CHECK-LABEL: @abs_nsw_must_be_positive_vec(
; CHECK-NEXT:    ret <4 x i1> <i1 true, i1 true, i1 true, i1 true>
;
  %abs = call <4 x i32> @llvm.abs.v4i32(<4 x i32> %x, i1 true)
  %c2 = icmp sge <4 x i32> %abs, zeroinitializer
  ret <4 x i1> %c2
}

; Negative test, no nsw provides no information about the sign bit of the result.
define i1 @abs_nonsw(i32 %x) {
; CHECK-LABEL: @abs_nonsw(
; CHECK-NEXT:    [[ABS:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 false)
; CHECK-NEXT:    [[C2:%.*]] = icmp sgt i32 [[ABS]], -1
; CHECK-NEXT:    ret i1 [[C2]]
;
  %abs = call i32 @llvm.abs.i32(i32 %x, i1 false)
  %c2 = icmp sge i32 %abs, 0
  ret i1 %c2
}

define <4 x i1> @abs_nonsw_vec(<4 x i32> %x) {
; CHECK-LABEL: @abs_nonsw_vec(
; CHECK-NEXT:    [[ABS:%.*]] = call <4 x i32> @llvm.abs.v4i32(<4 x i32> [[X:%.*]], i1 false)
; CHECK-NEXT:    [[C2:%.*]] = icmp sgt <4 x i32> [[ABS]], <i32 -1, i32 -1, i32 -1, i32 -1>
; CHECK-NEXT:    ret <4 x i1> [[C2]]
;
  %abs = call <4 x i32> @llvm.abs.v4i32(<4 x i32> %x, i1 false)
  %c2 = icmp sge <4 x i32> %abs, zeroinitializer
  ret <4 x i1> %c2
}

; abs preserves trailing zeros so the second and is unneeded
define i32 @abs_trailing_zeros(i32 %x) {
; CHECK-LABEL: @abs_trailing_zeros(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], -4
; CHECK-NEXT:    [[ABS:%.*]] = call i32 @llvm.abs.i32(i32 [[AND]], i1 false)
; CHECK-NEXT:    ret i32 [[ABS]]
;
  %and = and i32 %x, -4
  %abs = call i32 @llvm.abs.i32(i32 %and, i1 false)
  %and2 = and i32 %abs, -2
  ret i32 %and2
}

define <4 x i32> @abs_trailing_zeros_vec(<4 x i32> %x) {
; CHECK-LABEL: @abs_trailing_zeros_vec(
; CHECK-NEXT:    [[AND:%.*]] = and <4 x i32> [[X:%.*]], <i32 -4, i32 -8, i32 -16, i32 -32>
; CHECK-NEXT:    [[ABS:%.*]] = call <4 x i32> @llvm.abs.v4i32(<4 x i32> [[AND]], i1 false)
; CHECK-NEXT:    ret <4 x i32> [[ABS]]
;
  %and = and <4 x i32> %x, <i32 -4, i32 -8, i32 -16, i32 -32>
  %abs = call <4 x i32> @llvm.abs.v4i32(<4 x i32> %and, i1 false)
  %and2 = and <4 x i32> %abs, <i32 -2, i32 -2, i32 -2, i32 -2>
  ret <4 x i32> %and2
}

; negative test, can't remove the second and based on trailing zeroes.
; FIXME: Could remove the first and using demanded bits.
define i32 @abs_trailing_zeros_negative(i32 %x) {
; CHECK-LABEL: @abs_trailing_zeros_negative(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], -2
; CHECK-NEXT:    [[ABS:%.*]] = call i32 @llvm.abs.i32(i32 [[AND]], i1 false)
; CHECK-NEXT:    [[AND2:%.*]] = and i32 [[ABS]], -4
; CHECK-NEXT:    ret i32 [[AND2]]
;
  %and = and i32 %x, -2
  %abs = call i32 @llvm.abs.i32(i32 %and, i1 false)
  %and2 = and i32 %abs, -4
  ret i32 %and2
}

define <4 x i32> @abs_trailing_zeros_negative_vec(<4 x i32> %x) {
; CHECK-LABEL: @abs_trailing_zeros_negative_vec(
; CHECK-NEXT:    [[AND:%.*]] = and <4 x i32> [[X:%.*]], <i32 -2, i32 -2, i32 -2, i32 -2>
; CHECK-NEXT:    [[ABS:%.*]] = call <4 x i32> @llvm.abs.v4i32(<4 x i32> [[AND]], i1 false)
; CHECK-NEXT:    [[AND2:%.*]] = and <4 x i32> [[ABS]], <i32 -4, i32 -4, i32 -4, i32 -4>
; CHECK-NEXT:    ret <4 x i32> [[AND2]]
;
  %and = and <4 x i32> %x, <i32 -2, i32 -2, i32 -2, i32 -2>
  %abs = call <4 x i32> @llvm.abs.v4i32(<4 x i32> %and, i1 false)
  %and2 = and <4 x i32> %abs, <i32 -4, i32 -4, i32 -4, i32 -4>
  ret <4 x i32> %and2
}

; Make sure we infer this add doesn't overflow. The input to the abs has 3
; sign bits, the abs reduces this to 2 sign bits.
define i32 @abs_signbits(i30 %x) {
; CHECK-LABEL: @abs_signbits(
; CHECK-NEXT:    [[EXT:%.*]] = sext i30 [[X:%.*]] to i32
; CHECK-NEXT:    [[ABS:%.*]] = call i32 @llvm.abs.i32(i32 [[EXT]], i1 false)
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i32 [[ABS]], 1
; CHECK-NEXT:    ret i32 [[ADD]]
;
  %ext = sext i30 %x to i32
  %abs = call i32 @llvm.abs.i32(i32 %ext, i1 false)
  %add = add i32 %abs, 1
  ret i32 %add
}

define <4 x i32> @abs_signbits_vec(<4 x i30> %x) {
; CHECK-LABEL: @abs_signbits_vec(
; CHECK-NEXT:    [[EXT:%.*]] = sext <4 x i30> [[X:%.*]] to <4 x i32>
; CHECK-NEXT:    [[ABS:%.*]] = call <4 x i32> @llvm.abs.v4i32(<4 x i32> [[EXT]], i1 false)
; CHECK-NEXT:    [[ADD:%.*]] = add nsw <4 x i32> [[ABS]], <i32 1, i32 1, i32 1, i32 1>
; CHECK-NEXT:    ret <4 x i32> [[ADD]]
;
  %ext = sext <4 x i30> %x to <4 x i32>
  %abs = call <4 x i32> @llvm.abs.v4i32(<4 x i32> %ext, i1 false)
  %add = add <4 x i32> %abs, <i32 1, i32 1, i32 1, i32 1>
  ret <4 x i32> %add
}

define i1 @abs_known_positive_input_compare(i31 %x) {
; CHECK-LABEL: @abs_known_positive_input_compare(
; CHECK-NEXT:    ret i1 true
;
  %zext = zext i31 %x to i32
  %abs = call i32 @llvm.abs.i32(i32 %zext, i1 false)
  %c2 = icmp sge i32 %abs, 0
  ret i1 %c2
}

define <4 x i1> @abs_known_positive_input_compare_vec(<4 x i31> %x) {
; CHECK-LABEL: @abs_known_positive_input_compare_vec(
; CHECK-NEXT:    ret <4 x i1> <i1 true, i1 true, i1 true, i1 true>
;
  %zext = zext <4 x i31> %x to <4 x i32>
  %abs = call <4 x i32> @llvm.abs.v4i32(<4 x i32> %zext, i1 false)
  %c2 = icmp sge <4 x i32> %abs, zeroinitializer
  ret <4 x i1> %c2
}

define i1 @abs_known_not_int_min(i32 %x) {
; CHECK-LABEL: @abs_known_not_int_min(
; CHECK-NEXT:    ret i1 true
;
  %or = or i32 %x, 1
  %abs = call i32 @llvm.abs.i32(i32 %or, i1 false)
  %c2 = icmp sge i32 %abs, 0
  ret i1 %c2
}

define <4 x i1> @abs_known_not_int_min_vec(<4 x i32> %x) {
; CHECK-LABEL: @abs_known_not_int_min_vec(
; CHECK-NEXT:    ret <4 x i1> <i1 true, i1 true, i1 true, i1 true>
;
  %or = or <4 x i32> %x, <i32 1, i32 1, i32 1, i32 1>
  %abs = call <4 x i32> @llvm.abs.v4i32(<4 x i32> %or, i1 false)
  %c2 = icmp sge <4 x i32> %abs, zeroinitializer
  ret <4 x i1> %c2
}

define i32 @abs_of_neg(i32 %x) {
; CHECK-LABEL: @abs_of_neg(
; CHECK-NEXT:    [[B:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 false)
; CHECK-NEXT:    ret i32 [[B]]
;
  %a = sub i32 0, %x
  %b = call i32 @llvm.abs.i32(i32 %a, i1 false)
  ret i32 %b
}

define <4 x i32> @abs_of_neg_vec(<4 x i32> %x) {
; CHECK-LABEL: @abs_of_neg_vec(
; CHECK-NEXT:    [[B:%.*]] = call <4 x i32> @llvm.abs.v4i32(<4 x i32> [[X:%.*]], i1 false)
; CHECK-NEXT:    ret <4 x i32> [[B]]
;
  %a = sub nsw <4 x i32> zeroinitializer, %x
  %b = call <4 x i32> @llvm.abs.v4i32(<4 x i32> %a, i1 false)
  ret <4 x i32> %b
}
