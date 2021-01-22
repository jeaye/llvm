; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

declare i8 @llvm.abs.i8(i8, i1)
declare i32 @llvm.abs.i32(i32, i1)
declare <4 x i32> @llvm.abs.v4i32(<4 x i32>, i1)
declare <3 x i82> @llvm.abs.v3i82(<3 x i82>, i1)
declare void @llvm.assume(i1)

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
; CHECK-NEXT:    [[ADD:%.*]] = add nuw nsw i32 [[ABS]], 1
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
; CHECK-NEXT:    [[ADD:%.*]] = add nuw nsw <4 x i32> [[ABS]], <i32 1, i32 1, i32 1, i32 1>
; CHECK-NEXT:    ret <4 x i32> [[ADD]]
;
  %ext = sext <4 x i30> %x to <4 x i32>
  %abs = call <4 x i32> @llvm.abs.v4i32(<4 x i32> %ext, i1 false)
  %add = add <4 x i32> %abs, <i32 1, i32 1, i32 1, i32 1>
  ret <4 x i32> %add
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

define i32 @abs_of_select_neg_true_val(i1 %b, i32 %x) {
; CHECK-LABEL: @abs_of_select_neg_true_val(
; CHECK-NEXT:    [[ABS:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    ret i32 [[ABS]]
;
  %neg = sub i32 0, %x
  %sel = select i1 %b, i32 %neg, i32 %x
  %abs = call i32 @llvm.abs.i32(i32 %sel, i1 true)
  ret i32 %abs
}

define <4 x i32> @abs_of_select_neg_false_val(<4 x i1> %b, <4 x i32> %x) {
; CHECK-LABEL: @abs_of_select_neg_false_val(
; CHECK-NEXT:    [[ABS:%.*]] = call <4 x i32> @llvm.abs.v4i32(<4 x i32> [[X:%.*]], i1 false)
; CHECK-NEXT:    ret <4 x i32> [[ABS]]
;
  %neg = sub <4 x i32> zeroinitializer, %x
  %sel = select <4 x i1> %b, <4 x i32> %x, <4 x i32> %neg
  %abs = call <4 x i32> @llvm.abs.v4i32(<4 x i32> %sel, i1 false)
  ret <4 x i32> %abs
}

define i32 @abs_dom_cond_nopoison(i32 %x) {
; CHECK-LABEL: @abs_dom_cond_nopoison(
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i32 [[X:%.*]], -1
; CHECK-NEXT:    br i1 [[CMP]], label [[TRUE:%.*]], label [[FALSE:%.*]]
; CHECK:       true:
; CHECK-NEXT:    ret i32 [[X]]
; CHECK:       false:
; CHECK-NEXT:    [[A2:%.*]] = sub i32 0, [[X]]
; CHECK-NEXT:    ret i32 [[A2]]
;
  %cmp = icmp sge i32 %x, 0
  br i1 %cmp, label %true, label %false

true:
  %a1 = call i32 @llvm.abs.i32(i32 %x, i1 false)
  ret i32 %a1

false:
  %a2 = call i32 @llvm.abs.i32(i32 %x, i1 false)
  ret i32 %a2
}

define i32 @abs_dom_cond_poison(i32 %x) {
; CHECK-LABEL: @abs_dom_cond_poison(
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i32 [[X:%.*]], -1
; CHECK-NEXT:    br i1 [[CMP]], label [[TRUE:%.*]], label [[FALSE:%.*]]
; CHECK:       true:
; CHECK-NEXT:    ret i32 [[X]]
; CHECK:       false:
; CHECK-NEXT:    [[A2:%.*]] = sub nsw i32 0, [[X]]
; CHECK-NEXT:    ret i32 [[A2]]
;
  %cmp = icmp sge i32 %x, 0
  br i1 %cmp, label %true, label %false

true:
  %a1 = call i32 @llvm.abs.i32(i32 %x, i1 true)
  ret i32 %a1

false:
  %a2 = call i32 @llvm.abs.i32(i32 %x, i1 true)
  ret i32 %a2
}

; Abs argument non-neg based on known bits.

define i32 @zext_abs(i31 %x) {
; CHECK-LABEL: @zext_abs(
; CHECK-NEXT:    [[ZEXT:%.*]] = zext i31 [[X:%.*]] to i32
; CHECK-NEXT:    ret i32 [[ZEXT]]
;
  %zext = zext i31 %x to i32
  %abs = call i32 @llvm.abs.i32(i32 %zext, i1 false)
  ret i32 %abs
}

define <3 x i82> @lshr_abs(<3 x i82> %x) {
; CHECK-LABEL: @lshr_abs(
; CHECK-NEXT:    [[LSHR:%.*]] = lshr <3 x i82> [[X:%.*]], <i82 1, i82 1, i82 1>
; CHECK-NEXT:    ret <3 x i82> [[LSHR]]
;
  %lshr = lshr <3 x i82> %x, <i82 1, i82 1, i82 1>
  %abs = call <3 x i82> @llvm.abs.v3i82(<3 x i82> %lshr, i1 true)
  ret <3 x i82> %abs
}

define i32 @and_abs(i32 %x) {
; CHECK-LABEL: @and_abs(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], 2147483644
; CHECK-NEXT:    ret i32 [[AND]]
;
  %and = and i32 %x, 2147483644
  %abs = call i32 @llvm.abs.i32(i32 %and, i1 true)
  ret i32 %abs
}

define <3 x i82> @select_abs(<3 x i1> %cond) {
; CHECK-LABEL: @select_abs(
; CHECK-NEXT:    [[SEL:%.*]] = select <3 x i1> [[COND:%.*]], <3 x i82> zeroinitializer, <3 x i82> <i82 2147483647, i82 42, i82 1>
; CHECK-NEXT:    ret <3 x i82> [[SEL]]
;
  %sel = select <3 x i1> %cond, <3 x i82> zeroinitializer, <3 x i82> <i82 2147483647, i82 42, i82 1>
  %abs = call <3 x i82> @llvm.abs.v3i82(<3 x i82> %sel, i1 false)
  ret <3 x i82> %abs
}

define i32 @assume_abs(i32 %x) {
; CHECK-LABEL: @assume_abs(
; CHECK-NEXT:    [[ASSUME:%.*]] = icmp sgt i32 [[X:%.*]], -1
; CHECK-NEXT:    call void @llvm.assume(i1 [[ASSUME]])
; CHECK-NEXT:    ret i32 [[X]]
;
  %assume = icmp sge i32 %x, 0
  call void @llvm.assume(i1 %assume)
  %abs = call i32 @llvm.abs.i32(i32 %x, i1 true)
  ret i32 %abs
}

; Abs argument negative based on known bits.

define i32 @abs_assume_neg(i32 %x) {
; CHECK-LABEL: @abs_assume_neg(
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[X:%.*]], 0
; CHECK-NEXT:    call void @llvm.assume(i1 [[CMP]])
; CHECK-NEXT:    [[ABS:%.*]] = sub i32 0, [[X]]
; CHECK-NEXT:    ret i32 [[ABS]]
;
  %cmp = icmp slt i32 %x, 0
  call void @llvm.assume(i1 %cmp)
  %abs = call i32 @llvm.abs.i32(i32 %x, i1 false)
  ret i32 %abs
}

define i32 @abs_known_neg(i16 %x) {
; CHECK-LABEL: @abs_known_neg(
; CHECK-NEXT:    [[EXT:%.*]] = zext i16 [[X:%.*]] to i32
; CHECK-NEXT:    [[NEG_NEG:%.*]] = add nuw nsw i32 [[EXT]], 1
; CHECK-NEXT:    ret i32 [[NEG_NEG]]
;
  %ext = zext i16 %x to i32
  %neg = sub nsw i32 -1, %ext
  %abs = call i32 @llvm.abs.i32(i32 %neg, i1 false)
  ret i32 %abs
}

define i1 @abs_eq_int_min_poison(i8 %x) {
; CHECK-LABEL: @abs_eq_int_min_poison(
; CHECK-NEXT:    ret i1 false
;
  %abs = call i8 @llvm.abs.i8(i8 %x, i1 true)
  %cmp = icmp eq i8 %abs, -128
  ret i1 %cmp
}

define i1 @abs_ne_int_min_poison(i8 %x) {
; CHECK-LABEL: @abs_ne_int_min_poison(
; CHECK-NEXT:    ret i1 true
;
  %abs = call i8 @llvm.abs.i8(i8 %x, i1 true)
  %cmp = icmp ne i8 %abs, -128
  ret i1 %cmp
}

define i1 @abs_eq_int_min_nopoison(i8 %x) {
; CHECK-LABEL: @abs_eq_int_min_nopoison(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8 [[X:%.*]], -128
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %abs = call i8 @llvm.abs.i8(i8 %x, i1 false)
  %cmp = icmp eq i8 %abs, -128
  ret i1 %cmp
}

define i1 @abs_ne_int_min_nopoison(i8 %x) {
; CHECK-LABEL: @abs_ne_int_min_nopoison(
; CHECK-NEXT:    [[CMP:%.*]] = icmp ne i8 [[X:%.*]], -128
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %abs = call i8 @llvm.abs.i8(i8 %x, i1 false)
  %cmp = icmp ne i8 %abs, -128
  ret i1 %cmp
}

define i32 @abs_sext(i8 %x) {
; CHECK-LABEL: @abs_sext(
; CHECK-NEXT:    [[S:%.*]] = sext i8 [[X:%.*]] to i32
; CHECK-NEXT:    [[A:%.*]] = call i32 @llvm.abs.i32(i32 [[S]], i1 false)
; CHECK-NEXT:    ret i32 [[A]]
;
  %s = sext i8 %x to i32
  %a = call i32 @llvm.abs.i32(i32 %s, i1 0)
  ret i32 %a
}

define <3 x i82> @abs_nsw_sext(<3 x i7> %x) {
; CHECK-LABEL: @abs_nsw_sext(
; CHECK-NEXT:    [[S:%.*]] = sext <3 x i7> [[X:%.*]] to <3 x i82>
; CHECK-NEXT:    [[A:%.*]] = call <3 x i82> @llvm.abs.v3i82(<3 x i82> [[S]], i1 true)
; CHECK-NEXT:    ret <3 x i82> [[A]]
;
  %s = sext <3 x i7> %x to <3 x i82>
  %a = call <3 x i82> @llvm.abs.v3i82(<3 x i82> %s, i1 1)
  ret <3 x i82> %a
}

define i32 @abs_sext_extra_use(i8 %x, i32* %p) {
; CHECK-LABEL: @abs_sext_extra_use(
; CHECK-NEXT:    [[S:%.*]] = sext i8 [[X:%.*]] to i32
; CHECK-NEXT:    store i32 [[S]], i32* [[P:%.*]], align 4
; CHECK-NEXT:    [[A:%.*]] = call i32 @llvm.abs.i32(i32 [[S]], i1 false)
; CHECK-NEXT:    ret i32 [[A]]
;
  %s = sext i8 %x to i32
  store i32 %s, i32* %p
  %a = call i32 @llvm.abs.i32(i32 %s, i1 0)
  ret i32 %a
}

; PR48816

define i8 @trunc_abs_sext(i8 %x) {
; CHECK-LABEL: @trunc_abs_sext(
; CHECK-NEXT:    [[S:%.*]] = sext i8 [[X:%.*]] to i32
; CHECK-NEXT:    [[A:%.*]] = tail call i32 @llvm.abs.i32(i32 [[S]], i1 true)
; CHECK-NEXT:    [[T:%.*]] = trunc i32 [[A]] to i8
; CHECK-NEXT:    ret i8 [[T]]
;
  %s = sext i8 %x to i32
  %a = tail call i32 @llvm.abs.i32(i32 %s, i1 true)
  %t = trunc i32 %a to i8
  ret i8 %t
}

define <4 x i8> @trunc_abs_sext_vec(<4 x i8> %x) {
; CHECK-LABEL: @trunc_abs_sext_vec(
; CHECK-NEXT:    [[S:%.*]] = sext <4 x i8> [[X:%.*]] to <4 x i32>
; CHECK-NEXT:    [[A:%.*]] = tail call <4 x i32> @llvm.abs.v4i32(<4 x i32> [[S]], i1 true)
; CHECK-NEXT:    [[T:%.*]] = trunc <4 x i32> [[A]] to <4 x i8>
; CHECK-NEXT:    ret <4 x i8> [[T]]
;
  %s = sext <4 x i8> %x to <4 x i32>
  %a = tail call <4 x i32> @llvm.abs.v4i32(<4 x i32> %s, i1 true)
  %t = trunc <4 x i32> %a to <4 x i8>
  ret <4 x i8> %t
}
