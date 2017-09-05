; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

define i1 @oeq_self(double %arg) {
; CHECK-LABEL: @oeq_self(
; CHECK-NEXT:    [[TMP:%.*]] = fcmp ord double %arg, 0.000000e+00
; CHECK-NEXT:    ret i1 [[TMP]]
;
  %tmp = fcmp oeq double %arg, %arg
  ret i1 %tmp
}

; PR1111 - https://bugs.llvm.org/show_bug.cgi?id=1111

define i1 @une_self(double %x) {
; CHECK-LABEL: @une_self(
; CHECK-NEXT:    [[TMP:%.*]] = fcmp uno double %x, 0.000000e+00
; CHECK-NEXT:    ret i1 [[TMP]]
;
  %tmp = fcmp une double %x, %x
  ret i1 %tmp
}

; When just checking for a NaN (ORD/UNO), canonicalize constants.
; Float/double are alternated for additional coverage.

define i1 @ord_zero(float %x) {
; CHECK-LABEL: @ord_zero(
; CHECK-NEXT:    [[F:%.*]] = fcmp ord float %x, 0.000000e+00
; CHECK-NEXT:    ret i1 [[F]]
;
  %f = fcmp ord float %x, 0.0
  ret i1 %f
}

define i1 @ord_nonzero(double %x) {
; CHECK-LABEL: @ord_nonzero(
; CHECK-NEXT:    [[F:%.*]] = fcmp ord double %x, 3.000000e+00
; CHECK-NEXT:    ret i1 [[F]]
;
  %f = fcmp ord double %x, 3.0
  ret i1 %f
}

define i1 @ord_self(float %x) {
; CHECK-LABEL: @ord_self(
; CHECK-NEXT:    [[F:%.*]] = fcmp ord float %x, 0.000000e+00
; CHECK-NEXT:    ret i1 [[F]]
;
  %f = fcmp ord float %x, %x
  ret i1 %f
}

define i1 @uno_zero(double %x) {
; CHECK-LABEL: @uno_zero(
; CHECK-NEXT:    [[F:%.*]] = fcmp uno double %x, 0.000000e+00
; CHECK-NEXT:    ret i1 [[F]]
;
  %f = fcmp uno double %x, 0.0
  ret i1 %f
}

define i1 @uno_nonzero(float %x) {
; CHECK-LABEL: @uno_nonzero(
; CHECK-NEXT:    [[F:%.*]] = fcmp uno float %x, 3.000000e+00
; CHECK-NEXT:    ret i1 [[F]]
;
  %f = fcmp uno float %x, 3.0
  ret i1 %f
}

define i1 @uno_self(double %x) {
; CHECK-LABEL: @uno_self(
; CHECK-NEXT:    [[F:%.*]] = fcmp uno double %x, 0.000000e+00
; CHECK-NEXT:    ret i1 [[F]]
;
  %f = fcmp uno double %x, %x
  ret i1 %f
}

define <2 x i1> @ord_zero_vec(<2 x double> %x) {
; CHECK-LABEL: @ord_zero_vec(
; CHECK-NEXT:    [[F:%.*]] = fcmp ord <2 x double> %x, zeroinitializer
; CHECK-NEXT:    ret <2 x i1> [[F]]
;
  %f = fcmp ord <2 x double> %x, zeroinitializer
  ret <2 x i1> %f
}

define <2 x i1> @ord_nonzero_vec(<2 x float> %x) {
; CHECK-LABEL: @ord_nonzero_vec(
; CHECK-NEXT:    [[F:%.*]] = fcmp ord <2 x float> %x, <float 3.000000e+00, float 5.000000e+00>
; CHECK-NEXT:    ret <2 x i1> [[F]]
;
  %f = fcmp ord <2 x float> %x, <float 3.0, float 5.0>
  ret <2 x i1> %f
}

define <2 x i1> @ord_self_vec(<2 x double> %x) {
; CHECK-LABEL: @ord_self_vec(
; CHECK-NEXT:    [[F:%.*]] = fcmp ord <2 x double> %x, zeroinitializer
; CHECK-NEXT:    ret <2 x i1> [[F]]
;
  %f = fcmp ord <2 x double> %x, %x
  ret <2 x i1> %f
}

define <2 x i1> @uno_zero_vec(<2 x float> %x) {
; CHECK-LABEL: @uno_zero_vec(
; CHECK-NEXT:    [[F:%.*]] = fcmp uno <2 x float> %x, zeroinitializer
; CHECK-NEXT:    ret <2 x i1> [[F]]
;
  %f = fcmp uno <2 x float> %x, zeroinitializer
  ret <2 x i1> %f
}

define <2 x i1> @uno_nonzero_vec(<2 x double> %x) {
; CHECK-LABEL: @uno_nonzero_vec(
; CHECK-NEXT:    [[F:%.*]] = fcmp uno <2 x double> %x, <double 3.000000e+00, double 5.000000e+00>
; CHECK-NEXT:    ret <2 x i1> [[F]]
;
  %f = fcmp uno <2 x double> %x, <double 3.0, double 5.0>
  ret <2 x i1> %f
}

define <2 x i1> @uno_self_vec(<2 x float> %x) {
; CHECK-LABEL: @uno_self_vec(
; CHECK-NEXT:    [[F:%.*]] = fcmp uno <2 x float> %x, zeroinitializer
; CHECK-NEXT:    ret <2 x i1> [[F]]
;
  %f = fcmp uno <2 x float> %x, %x
  ret <2 x i1> %f
}

; If a scalar constant is NaN in any of the above tests, it would have been eliminated by InstSimplify.
; If a vector has a NaN element, we don't do anything with it.

define <2 x i1> @uno_vec_with_nan(<2 x double> %x) {
; CHECK-LABEL: @uno_vec_with_nan(
; CHECK-NEXT:    [[F:%.*]] = fcmp uno <2 x double> %x, <double 3.000000e+00, double 0x7FF00000FFFFFFFF>
; CHECK-NEXT:    ret <2 x i1> [[F]]
;
  %f = fcmp uno <2 x double> %x, <double 3.0, double 0x7FF00000FFFFFFFF>
  ret <2 x i1> %f
}

; TODO: This could be handled in InstSimplify.

define i1 @nnan_ops_to_fcmp_ord(float %x, float %y) {
; CHECK-LABEL: @nnan_ops_to_fcmp_ord(
; CHECK-NEXT:    [[MUL:%.*]] = fmul nnan float %x, %y
; CHECK-NEXT:    [[DIV:%.*]] = fdiv nnan float %x, %y
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ord float [[MUL]], [[DIV]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %mul = fmul nnan float %x, %y
  %div = fdiv nnan float %x, %y
  %cmp = fcmp ord float %mul, %div
  ret i1 %cmp
}

; TODO: This could be handled in InstSimplify.

define i1 @nnan_ops_to_fcmp_uno(float %x, float %y) {
; CHECK-LABEL: @nnan_ops_to_fcmp_uno(
; CHECK-NEXT:    [[MUL:%.*]] = fmul nnan float %x, %y
; CHECK-NEXT:    [[DIV:%.*]] = fdiv nnan float %x, %y
; CHECK-NEXT:    [[CMP:%.*]] = fcmp uno float [[MUL]], [[DIV]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %mul = fmul nnan float %x, %y
  %div = fdiv nnan float %x, %y
  %cmp = fcmp uno float %mul, %div
  ret i1 %cmp
}

