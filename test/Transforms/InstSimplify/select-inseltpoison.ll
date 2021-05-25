; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instsimplify -S | FileCheck %s

define i1 @bool_true_or_false(i1 %cond) {
; CHECK-LABEL: @bool_true_or_false(
; CHECK-NEXT:    ret i1 [[COND:%.*]]
;
  %s = select i1 %cond, i1 true, i1 false
  ret i1 %s
}

define <2 x i1> @bool_true_or_false_vec(<2 x i1> %cond) {
; CHECK-LABEL: @bool_true_or_false_vec(
; CHECK-NEXT:    ret <2 x i1> [[COND:%.*]]
;
  %s = select <2 x i1> %cond, <2 x i1> <i1 true, i1 true>, <2 x i1> zeroinitializer
  ret <2 x i1> %s
}

define <2 x i1> @bool_true_or_false_vec_undef(<2 x i1> %cond) {
; CHECK-LABEL: @bool_true_or_false_vec_undef(
; CHECK-NEXT:    ret <2 x i1> [[COND:%.*]]
;
  %s = select <2 x i1> %cond, <2 x i1> <i1 undef, i1 true>, <2 x i1> <i1 false, i1 undef>
  ret <2 x i1> %s
}

define i32 @cond_is_false(i32 %A, i32 %B) {
; CHECK-LABEL: @cond_is_false(
; CHECK-NEXT:    ret i32 [[B:%.*]]
;
  %C = select i1 false, i32 %A, i32 %B
  ret i32 %C
}

define i32 @cond_is_true(i32 %A, i32 %B) {
; CHECK-LABEL: @cond_is_true(
; CHECK-NEXT:    ret i32 [[A:%.*]]
;
  %C = select i1 true, i32 %A, i32 %B
  ret i32 %C
}

define i32 @equal_arms(i1 %cond, i32 %x) {
; CHECK-LABEL: @equal_arms(
; CHECK-NEXT:    ret i32 [[X:%.*]]
;
  %V = select i1 %cond, i32 %x, i32 %x
  ret i32 %V
}

define <2 x i32> @equal_arms_vec(<2 x i1> %cond, <2 x i32> %x) {
; CHECK-LABEL: @equal_arms_vec(
; CHECK-NEXT:    ret <2 x i32> [[X:%.*]]
;
  %V = select <2 x i1> %cond, <2 x i32> %x, <2 x i32> %x
  ret <2 x i32> %V
}

define <2 x i32> @equal_arms_vec_undef(<2 x i1> %cond) {
; CHECK-LABEL: @equal_arms_vec_undef(
; CHECK-NEXT:    ret <2 x i32> <i32 42, i32 42>
;
  %V = select <2 x i1> %cond, <2 x i32> <i32 42, i32 undef>, <2 x i32> <i32 undef, i32 42>
  ret <2 x i32> %V
}

define <3 x float> @equal_arms_vec_less_undef(<3 x i1> %cond) {
; CHECK-LABEL: @equal_arms_vec_less_undef(
; CHECK-NEXT:    ret <3 x float> <float 4.200000e+01, float 4.200000e+01, float 4.300000e+01>
;
  %V = select <3 x i1> %cond, <3 x float> <float 42.0, float undef, float 43.0>, <3 x float> <float 42.0, float 42.0, float 43.0>
  ret <3 x float> %V
}

define <3 x float> @equal_arms_vec_more_undef(<3 x i1> %cond) {
; CHECK-LABEL: @equal_arms_vec_more_undef(
; CHECK-NEXT:    ret <3 x float> <float 4.200000e+01, float undef, float 4.300000e+01>
;
  %V = select <3 x i1> %cond, <3 x float> <float 42.0, float undef, float undef>, <3 x float> <float undef, float undef, float 43.0>
  ret <3 x float> %V
}

define <2 x i8> @vsel_tvec(<2 x i8> %x, <2 x i8> %y) {
; CHECK-LABEL: @vsel_tvec(
; CHECK-NEXT:    ret <2 x i8> [[X:%.*]]
;
  %s = select <2 x i1><i1 true, i1 true>, <2 x i8> %x, <2 x i8> %y
  ret <2 x i8> %s
}

define <2 x i8> @vsel_fvec(<2 x i8> %x, <2 x i8> %y) {
; CHECK-LABEL: @vsel_fvec(
; CHECK-NEXT:    ret <2 x i8> [[Y:%.*]]
;
  %s = select <2 x i1><i1 false, i1 false>, <2 x i8> %x, <2 x i8> %y
  ret <2 x i8> %s
}

define <2 x i8> @vsel_mixedvec() {
; CHECK-LABEL: @vsel_mixedvec(
; CHECK-NEXT:    ret <2 x i8> <i8 0, i8 3>
;
  %s = select <2 x i1><i1 true, i1 false>, <2 x i8> <i8 0, i8 1>, <2 x i8> <i8 2, i8 3>
  ret <2 x i8> %s
}

define <3 x i8> @vsel_undef_true_op(<3 x i8> %x, <3 x i8> %y) {
; CHECK-LABEL: @vsel_undef_true_op(
; CHECK-NEXT:    ret <3 x i8> [[X:%.*]]
;
  %s = select <3 x i1><i1 1, i1 undef, i1 1>, <3 x i8> %x, <3 x i8> %y
  ret <3 x i8> %s
}

define <3 x i4> @vsel_undef_false_op(<3 x i4> %x, <3 x i4> %y) {
; CHECK-LABEL: @vsel_undef_false_op(
; CHECK-NEXT:    ret <3 x i4> [[Y:%.*]]
;
  %s = select <3 x i1><i1 0, i1 undef, i1 undef>, <3 x i4> %x, <3 x i4> %y
  ret <3 x i4> %s
}

define i32 @test1(i32 %x) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    ret i32 [[X:%.*]]
;
  %and = and i32 %x, 1
  %cmp = icmp eq i32 %and, 0
  %and1 = and i32 %x, -2
  %and1.x = select i1 %cmp, i32 %and1, i32 %x
  ret i32 %and1.x
}

define i32 @test2(i32 %x) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    ret i32 [[X:%.*]]
;
  %and = and i32 %x, 1
  %cmp = icmp ne i32 %and, 0
  %and1 = and i32 %x, -2
  %and1.x = select i1 %cmp, i32 %x, i32 %and1
  ret i32 %and1.x
}

define i32 @test3(i32 %x) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    [[AND1:%.*]] = and i32 [[X:%.*]], -2
; CHECK-NEXT:    ret i32 [[AND1]]
;
  %and = and i32 %x, 1
  %cmp = icmp ne i32 %and, 0
  %and1 = and i32 %x, -2
  %and1.x = select i1 %cmp, i32 %and1, i32 %x
  ret i32 %and1.x
}

define i32 @test4(i32 %X) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[X:%.*]], -2147483648
; CHECK-NEXT:    ret i32 [[OR]]
;
  %cmp = icmp slt i32 %X, 0
  %or = or i32 %X, -2147483648
  %cond = select i1 %cmp, i32 %X, i32 %or
  ret i32 %cond
}

; Same as above, but the compare isn't canonical
define i32 @test4noncanon(i32 %X) {
; CHECK-LABEL: @test4noncanon(
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[X:%.*]], -2147483648
; CHECK-NEXT:    ret i32 [[OR]]
;
  %cmp = icmp sle i32 %X, -1
  %or = or i32 %X, -2147483648
  %cond = select i1 %cmp, i32 %X, i32 %or
  ret i32 %cond
}

define i32 @test5(i32 %X) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:    ret i32 [[X:%.*]]
;
  %cmp = icmp slt i32 %X, 0
  %or = or i32 %X, -2147483648
  %cond = select i1 %cmp, i32 %or, i32 %X
  ret i32 %cond
}

define i32 @test6(i32 %X) {
; CHECK-LABEL: @test6(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], 2147483647
; CHECK-NEXT:    ret i32 [[AND]]
;
  %cmp = icmp slt i32 %X, 0
  %and = and i32 %X, 2147483647
  %cond = select i1 %cmp, i32 %and, i32 %X
  ret i32 %cond
}

define i32 @test7(i32 %X) {
; CHECK-LABEL: @test7(
; CHECK-NEXT:    ret i32 [[X:%.*]]
;
  %cmp = icmp slt i32 %X, 0
  %and = and i32 %X, 2147483647
  %cond = select i1 %cmp, i32 %X, i32 %and
  ret i32 %cond
}

define i32 @test8(i32 %X) {
; CHECK-LABEL: @test8(
; CHECK-NEXT:    ret i32 [[X:%.*]]
;
  %cmp = icmp sgt i32 %X, -1
  %or = or i32 %X, -2147483648
  %cond = select i1 %cmp, i32 %X, i32 %or
  ret i32 %cond
}

define i32 @test9(i32 %X) {
; CHECK-LABEL: @test9(
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[X:%.*]], -2147483648
; CHECK-NEXT:    ret i32 [[OR]]
;
  %cmp = icmp sgt i32 %X, -1
  %or = or i32 %X, -2147483648
  %cond = select i1 %cmp, i32 %or, i32 %X
  ret i32 %cond
}

; Same as above, but the compare isn't canonical
define i32 @test9noncanon(i32 %X) {
; CHECK-LABEL: @test9noncanon(
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[X:%.*]], -2147483648
; CHECK-NEXT:    ret i32 [[OR]]
;
  %cmp = icmp sge i32 %X, 0
  %or = or i32 %X, -2147483648
  %cond = select i1 %cmp, i32 %or, i32 %X
  ret i32 %cond
}

define i32 @test10(i32 %X) {
; CHECK-LABEL: @test10(
; CHECK-NEXT:    ret i32 [[X:%.*]]
;
  %cmp = icmp sgt i32 %X, -1
  %and = and i32 %X, 2147483647
  %cond = select i1 %cmp, i32 %and, i32 %X
  ret i32 %cond
}

define i32 @test11(i32 %X) {
; CHECK-LABEL: @test11(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], 2147483647
; CHECK-NEXT:    ret i32 [[AND]]
;
  %cmp = icmp sgt i32 %X, -1
  %and = and i32 %X, 2147483647
  %cond = select i1 %cmp, i32 %X, i32 %and
  ret i32 %cond
}

define <2 x i8> @test11vec(<2 x i8> %X) {
; CHECK-LABEL: @test11vec(
; CHECK-NEXT:    [[AND:%.*]] = and <2 x i8> [[X:%.*]], <i8 127, i8 127>
; CHECK-NEXT:    ret <2 x i8> [[AND]]
;
  %cmp = icmp sgt <2 x i8> %X, <i8 -1, i8 -1>
  %and = and <2 x i8> %X, <i8 127, i8 127>
  %sel = select <2 x i1> %cmp, <2 x i8> %X, <2 x i8> %and
  ret <2 x i8> %sel
}

define i32 @test12(i32 %X) {
; CHECK-LABEL: @test12(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], 3
; CHECK-NEXT:    ret i32 [[AND]]
;
  %cmp = icmp ult i32 %X, 4
  %and = and i32 %X, 3
  %cond = select i1 %cmp, i32 %X, i32 %and
  ret i32 %cond
}

; Same as above, but the compare isn't canonical
define i32 @test12noncanon(i32 %X) {
; CHECK-LABEL: @test12noncanon(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], 3
; CHECK-NEXT:    ret i32 [[AND]]
;
  %cmp = icmp ule i32 %X, 3
  %and = and i32 %X, 3
  %cond = select i1 %cmp, i32 %X, i32 %and
  ret i32 %cond
}

define i32 @test13(i32 %X) {
; CHECK-LABEL: @test13(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], 3
; CHECK-NEXT:    ret i32 [[AND]]
;
  %cmp = icmp ugt i32 %X, 3
  %and = and i32 %X, 3
  %cond = select i1 %cmp, i32 %and, i32 %X
  ret i32 %cond
}

; Same as above, but the compare isn't canonical
define i32 @test13noncanon(i32 %X) {
; CHECK-LABEL: @test13noncanon(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], 3
; CHECK-NEXT:    ret i32 [[AND]]
;
  %cmp = icmp uge i32 %X, 4
  %and = and i32 %X, 3
  %cond = select i1 %cmp, i32 %and, i32 %X
  ret i32 %cond
}

define i32 @select_icmp_and_8_eq_0_or_8(i32 %x) {
; CHECK-LABEL: @select_icmp_and_8_eq_0_or_8(
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[X:%.*]], 8
; CHECK-NEXT:    ret i32 [[OR]]
;
  %and = and i32 %x, 8
  %cmp = icmp eq i32 %and, 0
  %or = or i32 %x, 8
  %sel = select i1 %cmp, i32 %or, i32 %x
  ret i32 %sel
}

define i32 @select_icmp_and_8_eq_0_or_8_alt(i32 %x) {
; CHECK-LABEL: @select_icmp_and_8_eq_0_or_8_alt(
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[X:%.*]], 8
; CHECK-NEXT:    ret i32 [[OR]]
;
  %and = and i32 %x, 8
  %cmp = icmp ne i32 %and, 0
  %or = or i32 %x, 8
  %sel = select i1 %cmp, i32 %x, i32 %or
  ret i32 %sel
}

define i32 @select_icmp_and_8_ne_0_or_8(i32 %x) {
; CHECK-LABEL: @select_icmp_and_8_ne_0_or_8(
; CHECK-NEXT:    ret i32 [[X:%.*]]
;
  %and = and i32 %x, 8
  %cmp = icmp ne i32 %and, 0
  %or = or i32 %x, 8
  %sel = select i1 %cmp, i32 %or, i32 %x
  ret i32 %sel
}

define i32 @select_icmp_and_8_ne_0_or_8_alt(i32 %x) {
; CHECK-LABEL: @select_icmp_and_8_ne_0_or_8_alt(
; CHECK-NEXT:    ret i32 [[X:%.*]]
;
  %and = and i32 %x, 8
  %cmp = icmp eq i32 %and, 0
  %or = or i32 %x, 8
  %sel = select i1 %cmp, i32 %x, i32 %or
  ret i32 %sel
}

define i32 @select_icmp_and_8_eq_0_and_not_8(i32 %x) {
; CHECK-LABEL: @select_icmp_and_8_eq_0_and_not_8(
; CHECK-NEXT:    [[AND1:%.*]] = and i32 [[X:%.*]], -9
; CHECK-NEXT:    ret i32 [[AND1]]
;
  %and = and i32 %x, 8
  %cmp = icmp eq i32 %and, 0
  %and1 = and i32 %x, -9
  %sel = select i1 %cmp, i32 %x, i32 %and1
  ret i32 %sel
}

define i32 @select_icmp_and_8_eq_0_and_not_8_alt(i32 %x) {
; CHECK-LABEL: @select_icmp_and_8_eq_0_and_not_8_alt(
; CHECK-NEXT:    [[AND1:%.*]] = and i32 [[X:%.*]], -9
; CHECK-NEXT:    ret i32 [[AND1]]
;
  %and = and i32 %x, 8
  %cmp = icmp ne i32 %and, 0
  %and1 = and i32 %x, -9
  %sel = select i1 %cmp, i32 %and1, i32 %x
  ret i32 %sel
}

define i32 @select_icmp_and_8_ne_0_and_not_8(i32 %x) {
; CHECK-LABEL: @select_icmp_and_8_ne_0_and_not_8(
; CHECK-NEXT:    ret i32 [[X:%.*]]
;
  %and = and i32 %x, 8
  %cmp = icmp ne i32 %and, 0
  %and1 = and i32 %x, -9
  %sel = select i1 %cmp, i32 %x, i32 %and1
  ret i32 %sel
}

define i32 @select_icmp_and_8_ne_0_and_not_8_alt(i32 %x) {
; CHECK-LABEL: @select_icmp_and_8_ne_0_and_not_8_alt(
; CHECK-NEXT:    ret i32 [[X:%.*]]
;
  %and = and i32 %x, 8
  %cmp = icmp eq i32 %and, 0
  %and1 = and i32 %x, -9
  %sel = select i1 %cmp, i32 %and1, i32 %x
  ret i32 %sel
}

; PR28466: https://llvm.org/bugs/show_bug.cgi?id=28466
; Each of the previous 8 patterns has a variant that replaces the
; 'and' with a 'trunc' and the icmp eq/ne with icmp slt/sgt.

define i32 @select_icmp_trunc_8_ne_0_or_128(i32 %x) {
; CHECK-LABEL: @select_icmp_trunc_8_ne_0_or_128(
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[X:%.*]], 128
; CHECK-NEXT:    ret i32 [[OR]]
;
  %trunc = trunc i32 %x to i8
  %cmp = icmp sgt i8 %trunc, -1
  %or = or i32 %x, 128
  %sel = select i1 %cmp, i32 %or, i32 %x
  ret i32 %sel
}

define i32 @select_icmp_trunc_8_ne_0_or_128_alt(i32 %x) {
; CHECK-LABEL: @select_icmp_trunc_8_ne_0_or_128_alt(
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[X:%.*]], 128
; CHECK-NEXT:    ret i32 [[OR]]
;
  %trunc = trunc i32 %x to i8
  %cmp = icmp slt i8 %trunc, 0
  %or = or i32 %x, 128
  %sel = select i1 %cmp, i32 %x, i32 %or
  ret i32 %sel
}

define i32 @select_icmp_trunc_8_eq_0_or_128(i32 %x) {
; CHECK-LABEL: @select_icmp_trunc_8_eq_0_or_128(
; CHECK-NEXT:    ret i32 [[X:%.*]]
;
  %trunc = trunc i32 %x to i8
  %cmp = icmp slt i8 %trunc, 0
  %or = or i32 %x, 128
  %sel = select i1 %cmp, i32 %or, i32 %x
  ret i32 %sel
}

define i32 @select_icmp_trunc_8_eq_0_or_128_alt(i32 %x) {
; CHECK-LABEL: @select_icmp_trunc_8_eq_0_or_128_alt(
; CHECK-NEXT:    ret i32 [[X:%.*]]
;
  %trunc = trunc i32 %x to i8
  %cmp = icmp sgt i8 %trunc, -1
  %or = or i32 %x, 128
  %sel = select i1 %cmp, i32 %x, i32 %or
  ret i32 %sel
}

define i32 @select_icmp_trunc_8_eq_0_and_not_8(i32 %x) {
; CHECK-LABEL: @select_icmp_trunc_8_eq_0_and_not_8(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], -9
; CHECK-NEXT:    ret i32 [[AND]]
;
  %trunc = trunc i32 %x to i4
  %cmp = icmp sgt i4 %trunc, -1
  %and = and i32 %x, -9
  %sel = select i1 %cmp, i32 %x, i32 %and
  ret i32 %sel
}

define i32 @select_icmp_trunc_8_eq_0_and_not_8_alt(i32 %x) {
; CHECK-LABEL: @select_icmp_trunc_8_eq_0_and_not_8_alt(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], -9
; CHECK-NEXT:    ret i32 [[AND]]
;
  %trunc = trunc i32 %x to i4
  %cmp = icmp slt i4 %trunc, 0
  %and = and i32 %x, -9
  %sel = select i1 %cmp, i32 %and, i32 %x
  ret i32 %sel
}

define i32 @select_icmp_trunc_8_ne_0_and_not_8(i32 %x) {
; CHECK-LABEL: @select_icmp_trunc_8_ne_0_and_not_8(
; CHECK-NEXT:    ret i32 [[X:%.*]]
;
  %trunc = trunc i32 %x to i4
  %cmp = icmp slt i4 %trunc, 0
  %and = and i32 %x, -9
  %sel = select i1 %cmp, i32 %x, i32 %and
  ret i32 %sel
}

define i32 @select_icmp_trunc_8_ne_0_and_not_8_alt(i32 %x) {
; CHECK-LABEL: @select_icmp_trunc_8_ne_0_and_not_8_alt(
; CHECK-NEXT:    ret i32 [[X:%.*]]
;
  %trunc = trunc i32 %x to i4
  %cmp = icmp sgt i4 %trunc, -1
  %and = and i32 %x, -9
  %sel = select i1 %cmp, i32 %and, i32 %x
  ret i32 %sel
}

; Make sure that at least a few of the same patterns are repeated with vector types.

define <2 x i32> @select_icmp_and_8_ne_0_and_not_8_vec(<2 x i32> %x) {
; CHECK-LABEL: @select_icmp_and_8_ne_0_and_not_8_vec(
; CHECK-NEXT:    ret <2 x i32> [[X:%.*]]
;
  %and = and <2 x i32> %x, <i32 8, i32 8>
  %cmp = icmp ne <2 x i32> %and, zeroinitializer
  %and1 = and <2 x i32> %x, <i32 -9, i32 -9>
  %sel = select <2 x i1> %cmp, <2 x i32> %x, <2 x i32> %and1
  ret <2 x i32> %sel
}

define <2 x i32> @select_icmp_trunc_8_ne_0_and_not_8_alt_vec(<2 x i32> %x) {
; CHECK-LABEL: @select_icmp_trunc_8_ne_0_and_not_8_alt_vec(
; CHECK-NEXT:    ret <2 x i32> [[X:%.*]]
;
  %trunc = trunc <2 x i32> %x to <2 x i4>
  %cmp = icmp sgt <2 x i4> %trunc, <i4 -1, i4 -1>
  %and = and <2 x i32> %x, <i32 -9, i32 -9>
  %sel = select <2 x i1> %cmp, <2 x i32> %and, <2 x i32> %x
  ret <2 x i32> %sel
}

; Insert a bit from x into y? This should be possible in InstCombine, but not InstSimplify?

define i32 @select_icmp_x_and_8_eq_0_y_and_not_8(i32 %x, i32 %y) {
; CHECK-LABEL: @select_icmp_x_and_8_eq_0_y_and_not_8(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], 8
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[AND]], 0
; CHECK-NEXT:    [[AND1:%.*]] = and i32 [[Y:%.*]], -9
; CHECK-NEXT:    [[Y_AND1:%.*]] = select i1 [[CMP]], i32 [[Y]], i32 [[AND1]]
; CHECK-NEXT:    ret i32 [[Y_AND1]]
;
  %and = and i32 %x, 8
  %cmp = icmp eq i32 %and, 0
  %and1 = and i32 %y, -9
  %y.and1 = select i1 %cmp, i32 %y, i32 %and1
  ret i32 %y.and1
}

define i64 @select_icmp_x_and_8_eq_0_y64_and_not_8(i32 %x, i64 %y) {
; CHECK-LABEL: @select_icmp_x_and_8_eq_0_y64_and_not_8(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], 8
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[AND]], 0
; CHECK-NEXT:    [[AND1:%.*]] = and i64 [[Y:%.*]], -9
; CHECK-NEXT:    [[Y_AND1:%.*]] = select i1 [[CMP]], i64 [[Y]], i64 [[AND1]]
; CHECK-NEXT:    ret i64 [[Y_AND1]]
;
  %and = and i32 %x, 8
  %cmp = icmp eq i32 %and, 0
  %and1 = and i64 %y, -9
  %y.and1 = select i1 %cmp, i64 %y, i64 %and1
  ret i64 %y.and1
}

define i64 @select_icmp_x_and_8_ne_0_y64_and_not_8(i32 %x, i64 %y) {
; CHECK-LABEL: @select_icmp_x_and_8_ne_0_y64_and_not_8(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], 8
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[AND]], 0
; CHECK-NEXT:    [[AND1:%.*]] = and i64 [[Y:%.*]], -9
; CHECK-NEXT:    [[AND1_Y:%.*]] = select i1 [[CMP]], i64 [[AND1]], i64 [[Y]]
; CHECK-NEXT:    ret i64 [[AND1_Y]]
;
  %and = and i32 %x, 8
  %cmp = icmp eq i32 %and, 0
  %and1 = and i64 %y, -9
  %and1.y = select i1 %cmp, i64 %and1, i64 %y
  ret i64 %and1.y
}

; Don't crash on a pointer or aggregate type.

define i32* @select_icmp_pointers(i32* %x, i32* %y) {
; CHECK-LABEL: @select_icmp_pointers(
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32* [[X:%.*]], null
; CHECK-NEXT:    [[SEL:%.*]] = select i1 [[CMP]], i32* [[X]], i32* [[Y:%.*]]
; CHECK-NEXT:    ret i32* [[SEL]]
;
  %cmp = icmp slt i32* %x, null
  %sel = select i1 %cmp, i32* %x, i32* %y
  ret i32* %sel
}

; If the condition is known, we don't need to select, but we're not
; doing this fold here to avoid compile-time cost.

declare void @llvm.assume(i1)

define i8 @assume_sel_cond(i1 %cond, i8 %x, i8 %y) {
; CHECK-LABEL: @assume_sel_cond(
; CHECK-NEXT:    call void @llvm.assume(i1 [[COND:%.*]])
; CHECK-NEXT:    [[SEL:%.*]] = select i1 [[COND]], i8 [[X:%.*]], i8 [[Y:%.*]]
; CHECK-NEXT:    ret i8 [[SEL]]
;
  call void @llvm.assume(i1 %cond)
  %sel = select i1 %cond, i8 %x, i8 %y
  ret i8 %sel
}

define i8 @do_not_assume_sel_cond(i1 %cond, i8 %x, i8 %y) {
; CHECK-LABEL: @do_not_assume_sel_cond(
; CHECK-NEXT:    [[NOTCOND:%.*]] = icmp eq i1 [[COND:%.*]], false
; CHECK-NEXT:    call void @llvm.assume(i1 [[NOTCOND]])
; CHECK-NEXT:    [[SEL:%.*]] = select i1 [[COND]], i8 [[X:%.*]], i8 [[Y:%.*]]
; CHECK-NEXT:    ret i8 [[SEL]]
;
  %notcond = icmp eq i1 %cond, false
  call void @llvm.assume(i1 %notcond)
  %sel = select i1 %cond, i8 %x, i8 %y
  ret i8 %sel
}

define i32* @select_icmp_eq_0_gep_operand(i32* %base, i64 %n) {
; CHECK-LABEL: @select_icmp_eq_0_gep_operand(
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr i32, i32* [[BASE:%.*]], i64 [[N:%.*]]
; CHECK-NEXT:    ret i32* [[GEP]]
;
  %cond = icmp eq i64 %n, 0
  %gep = getelementptr i32, i32* %base, i64 %n
  %r = select i1 %cond, i32* %base, i32* %gep
  ret i32* %r
}

define i32* @select_icmp_ne_0_gep_operand(i32* %base, i64 %n) {
; CHECK-LABEL: @select_icmp_ne_0_gep_operand(
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr i32, i32* [[BASE:%.*]], i64 [[N:%.*]]
; CHECK-NEXT:    ret i32* [[GEP]]
;
  %cond = icmp ne i64 %n, 0
  %gep = getelementptr i32, i32* %base, i64 %n
  %r = select i1 %cond, i32* %gep, i32* %base
  ret i32* %r
}

define i1 @and_cmps(i32 %x) {
; CHECK-LABEL: @and_cmps(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp slt i32 [[X:%.*]], 92
; CHECK-NEXT:    [[CMP2:%.*]] = icmp slt i32 [[X]], 11
; CHECK-NEXT:    [[R:%.*]] = select i1 [[CMP1]], i1 [[CMP2]], i1 false
; CHECK-NEXT:    ret i1 [[R]]
;
  %cmp1 = icmp slt i32 %x, 92
  %cmp2 = icmp slt i32 %x, 11
  %r = select i1 %cmp1, i1 %cmp2, i1 false
  ret i1 %r
}

define <2 x i1> @and_cmps_vector(<2 x i32> %x) {
; CHECK-LABEL: @and_cmps_vector(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp slt <2 x i32> [[X:%.*]], <i32 92, i32 92>
; CHECK-NEXT:    [[CMP2:%.*]] = icmp slt <2 x i32> [[X]], <i32 11, i32 11>
; CHECK-NEXT:    [[R:%.*]] = select <2 x i1> [[CMP1]], <2 x i1> [[CMP2]], <2 x i1> zeroinitializer
; CHECK-NEXT:    ret <2 x i1> [[R]]
;
  %cmp1 = icmp slt <2 x i32> %x, <i32 92, i32 92>
  %cmp2 = icmp slt <2 x i32> %x, <i32 11, i32 11>
  %r = select <2 x i1> %cmp1, <2 x i1> %cmp2, <2 x i1> <i1 false, i1 false>
  ret <2 x i1> %r
}

define i1 @or_cmps(float %x) {
; CHECK-LABEL: @or_cmps(
; CHECK-NEXT:    [[CMP1:%.*]] = fcmp uno float [[X:%.*]], 4.200000e+01
; CHECK-NEXT:    [[CMP2:%.*]] = fcmp uno float [[X]], 5.200000e+01
; CHECK-NEXT:    [[R:%.*]] = select i1 [[CMP1]], i1 true, i1 [[CMP2]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %cmp1 = fcmp uno float %x, 42.0
  %cmp2 = fcmp uno float %x, 52.0
  %r = select i1 %cmp1, i1 true, i1 %cmp2
  ret i1 %r
}

define <2 x i1> @or_logic_vector(<2 x i1> %x, <2 x i1> %y) {
; CHECK-LABEL: @or_logic_vector(
; CHECK-NEXT:    [[A:%.*]] = and <2 x i1> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = select <2 x i1> [[X]], <2 x i1> <i1 true, i1 true>, <2 x i1> [[A]]
; CHECK-NEXT:    ret <2 x i1> [[R]]
;
  %a = and <2 x i1> %x, %y
  %r = select <2 x i1> %x, <2 x i1> <i1 true, i1 true>, <2 x i1> %a
  ret <2 x i1> %r
}

define i1 @and_not_cmps(i32 %x) {
; CHECK-LABEL: @and_not_cmps(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp slt i32 [[X:%.*]], 92
; CHECK-NEXT:    [[CMP2:%.*]] = icmp slt i32 [[X]], 11
; CHECK-NEXT:    [[R:%.*]] = select i1 [[CMP1]], i1 false, i1 [[CMP2]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %cmp1 = icmp slt i32 %x, 92
  %cmp2 = icmp slt i32 %x, 11
  %r = select i1 %cmp1, i1 false, i1 %cmp2
  ret i1 %r
}

define i1 @or_not_cmps(i32 %x) {
; CHECK-LABEL: @or_not_cmps(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp slt i32 [[X:%.*]], 92
; CHECK-NEXT:    [[CMP2:%.*]] = icmp slt i32 [[X]], 11
; CHECK-NEXT:    [[R:%.*]] = select i1 [[CMP1]], i1 [[CMP2]], i1 true
; CHECK-NEXT:    ret i1 [[R]]
;
  %cmp1 = icmp slt i32 %x, 92
  %cmp2 = icmp slt i32 %x, 11
  %r = select i1 %cmp1, i1 %cmp2, i1 true
  ret i1 %r
}

define i8 @and_cmps_wrong_type(i32 %x) {
; CHECK-LABEL: @and_cmps_wrong_type(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp slt i32 [[X:%.*]], 92
; CHECK-NEXT:    [[CMP2:%.*]] = icmp slt i32 [[X]], 11
; CHECK-NEXT:    [[S:%.*]] = sext i1 [[CMP2]] to i8
; CHECK-NEXT:    [[R:%.*]] = select i1 [[CMP1]], i8 [[S]], i8 0
; CHECK-NEXT:    ret i8 [[R]]
;
  %cmp1 = icmp slt i32 %x, 92
  %cmp2 = icmp slt i32 %x, 11
  %s = sext i1 %cmp2 to i8
  %r = select i1 %cmp1, i8 %s, i8 0
  ret i8 %r
}

define i1 @y_might_be_poison(float %x, float %y) {
; CHECK-LABEL: @y_might_be_poison(
; CHECK-NEXT:    [[C1:%.*]] = fcmp ord float 0.000000e+00, [[X:%.*]]
; CHECK-NEXT:    [[C2:%.*]] = fcmp ord float [[X]], [[Y:%.*]]
; CHECK-NEXT:    [[C3:%.*]] = select i1 [[C1]], i1 [[C2]], i1 false
; CHECK-NEXT:    ret i1 [[C3]]
;
  %c1 = fcmp ord float 0.0, %x
  %c2 = fcmp ord float %x, %y
  %c3 = select i1 %c1, i1 %c2, i1 false
  ret i1 %c3
}

; Negative tests to ensure we don't remove selects with undef true/false values.
; See https://bugs.llvm.org/show_bug.cgi?id=31633
; https://lists.llvm.org/pipermail/llvm-dev/2016-October/106182.html
; https://reviews.llvm.org/D83360
define i32 @false_undef(i1 %cond, i32 %x) {
; CHECK-LABEL: @false_undef(
; CHECK-NEXT:    [[S:%.*]] = select i1 [[COND:%.*]], i32 [[X:%.*]], i32 undef
; CHECK-NEXT:    ret i32 [[S]]
;
  %s = select i1 %cond, i32 %x, i32 undef
  ret i32 %s
}

define i32 @true_undef(i1 %cond, i32 %x) {
; CHECK-LABEL: @true_undef(
; CHECK-NEXT:    [[S:%.*]] = select i1 [[COND:%.*]], i32 undef, i32 [[X:%.*]]
; CHECK-NEXT:    ret i32 [[S]]
;
  %s = select i1 %cond, i32 undef, i32 %x
  ret i32 %s
}

define <2 x i32> @false_undef_vec(i1 %cond, <2 x i32> %x) {
; CHECK-LABEL: @false_undef_vec(
; CHECK-NEXT:    [[S:%.*]] = select i1 [[COND:%.*]], <2 x i32> [[X:%.*]], <2 x i32> undef
; CHECK-NEXT:    ret <2 x i32> [[S]]
;
  %s = select i1 %cond, <2 x i32> %x, <2 x i32> undef
  ret <2 x i32> %s
}

define <2 x i32> @true_undef_vec(i1 %cond, <2 x i32> %x) {
; CHECK-LABEL: @true_undef_vec(
; CHECK-NEXT:    [[S:%.*]] = select i1 [[COND:%.*]], <2 x i32> undef, <2 x i32> [[X:%.*]]
; CHECK-NEXT:    ret <2 x i32> [[S]]
;
  %s = select i1 %cond, <2 x i32> undef, <2 x i32> %x
  ret <2 x i32> %s
}

; These can be folded because the other value is guaranteed not to be poison.
define i32 @false_undef_true_constant(i1 %cond) {
; CHECK-LABEL: @false_undef_true_constant(
; CHECK-NEXT:    ret i32 10
;
  %s = select i1 %cond, i32 10, i32 undef
  ret i32 %s
}

define i32 @true_undef_false_constant(i1 %cond) {
; CHECK-LABEL: @true_undef_false_constant(
; CHECK-NEXT:    ret i32 20
;
  %s = select i1 %cond, i32 undef, i32 20
  ret i32 %s
}

define <2 x i32> @false_undef_true_constant_vec(i1 %cond) {
; CHECK-LABEL: @false_undef_true_constant_vec(
; CHECK-NEXT:    ret <2 x i32> <i32 42, i32 -42>
;
  %s = select i1 %cond, <2 x i32> <i32 42, i32 -42>, <2 x i32> undef
  ret <2 x i32> %s
}

define <2 x i32> @true_undef_false_constant_vec(i1 %cond) {
; CHECK-LABEL: @true_undef_false_constant_vec(
; CHECK-NEXT:    ret <2 x i32> <i32 -42, i32 42>
;
  %s = select i1 %cond, <2 x i32> undef, <2 x i32> <i32 -42, i32 42>
  ret <2 x i32> %s
}

; If one input is undef and the other is freeze, we can fold it to the freeze.
define i32 @false_undef_true_freeze(i1 %cond, i32 %x) {
; CHECK-LABEL: @false_undef_true_freeze(
; CHECK-NEXT:    [[XF:%.*]] = freeze i32 [[X:%.*]]
; CHECK-NEXT:    ret i32 [[XF]]
;
  %xf = freeze i32 %x
  %s = select i1 %cond, i32 %xf, i32 undef
  ret i32 %s
}

define i32 @false_undef_false_freeze(i1 %cond, i32 %x) {
; CHECK-LABEL: @false_undef_false_freeze(
; CHECK-NEXT:    [[XF:%.*]] = freeze i32 [[X:%.*]]
; CHECK-NEXT:    ret i32 [[XF]]
;
  %xf = freeze i32 %x
  %s = select i1 %cond, i32 undef, i32 %xf
  ret i32 %s
}

@g = external global i32, align 1

define <2 x i32> @false_undef_true_constextpr_vec(i1 %cond) {
; CHECK-LABEL: @false_undef_true_constextpr_vec(
; CHECK-NEXT:    ret <2 x i32> <i32 ptrtoint (i32* @g to i32), i32 ptrtoint (i32* @g to i32)>
;
  %s = select i1 %cond, <2 x i32> <i32 undef, i32 ptrtoint (i32* @g to i32)>, <2 x i32> <i32 ptrtoint (i32* @g to i32), i32 undef>
  ret <2 x i32> %s
}

define i32 @all_constant_true_undef() {
; CHECK-LABEL: @all_constant_true_undef(
; CHECK-NEXT:    ret i32 1
;
  %s = select i1 ptrtoint (i32 ()* @all_constant_true_undef to i1), i32 undef, i32 1
  ret i32 %s
}

define float @all_constant_false_undef() {
; CHECK-LABEL: @all_constant_false_undef(
; CHECK-NEXT:    ret float 1.000000e+00
;
  %s = select i1 ptrtoint (float ()* @all_constant_false_undef to i1), float undef, float 1.0
  ret float %s
}

define <2 x i32> @all_constant_true_undef_vec() {
; CHECK-LABEL: @all_constant_true_undef_vec(
; CHECK-NEXT:    ret <2 x i32> <i32 1, i32 -1>
;
  %s = select i1 ptrtoint (<2 x i32> ()* @all_constant_true_undef_vec to i1), <2 x i32> undef, <2 x i32> <i32 1, i32 -1>
  ret <2 x i32> %s
}

define <2 x float> @all_constant_false_undef_vec() {
; CHECK-LABEL: @all_constant_false_undef_vec(
; CHECK-NEXT:    ret <2 x float> <float 1.000000e+00, float -1.000000e+00>
;
  %s = select i1 ptrtoint (<2 x float> ()* @all_constant_false_undef_vec to i1), <2 x float> undef, <2 x float> <float 1.0, float -1.0>
  ret <2 x float> %s
}

; Negative tests. Don't fold if the non-undef operand is a constexpr.
define i32 @all_constant_false_undef_true_constexpr() {
; CHECK-LABEL: @all_constant_false_undef_true_constexpr(
; CHECK-NEXT:    [[S:%.*]] = select i1 ptrtoint (i32 ()* @all_constant_false_undef_true_constexpr to i1), i32 ptrtoint (i32 ()* @all_constant_false_undef_true_constexpr to i32), i32 undef
; CHECK-NEXT:    ret i32 [[S]]
;
  %s = select i1 ptrtoint (i32 ()* @all_constant_false_undef_true_constexpr to i1), i32 ptrtoint (i32 ()* @all_constant_false_undef_true_constexpr to i32), i32 undef
  ret i32 %s
}

define i32 @all_constant_true_undef_false_constexpr() {
; CHECK-LABEL: @all_constant_true_undef_false_constexpr(
; CHECK-NEXT:    [[S:%.*]] = select i1 ptrtoint (i32 ()* @all_constant_true_undef_false_constexpr to i1), i32 undef, i32 ptrtoint (i32 ()* @all_constant_true_undef_false_constexpr to i32)
; CHECK-NEXT:    ret i32 [[S]]
;
  %s = select i1 ptrtoint (i32 ()* @all_constant_true_undef_false_constexpr to i1), i32 undef, i32 ptrtoint (i32 ()* @all_constant_true_undef_false_constexpr to i32)
  ret i32 %s
}

; Negative tests. Don't fold if the non-undef operand is a vector containing a constexpr.
define <2 x i32> @all_constant_false_undef_true_constexpr_vec() {
; CHECK-LABEL: @all_constant_false_undef_true_constexpr_vec(
; CHECK-NEXT:    [[S:%.*]] = select i1 ptrtoint (<2 x i32> ()* @all_constant_false_undef_true_constexpr_vec to i1), <2 x i32> <i32 ptrtoint (<2 x i32> ()* @all_constant_false_undef_true_constexpr_vec to i32), i32 -1>, <2 x i32> undef
; CHECK-NEXT:    ret <2 x i32> [[S]]
;
  %s = select i1 ptrtoint (<2 x i32> ()* @all_constant_false_undef_true_constexpr_vec to i1), <2 x i32> <i32 ptrtoint (<2 x i32> ()* @all_constant_false_undef_true_constexpr_vec to i32), i32 -1>, <2 x i32> undef
  ret <2 x i32> %s
}

define <2 x i32> @all_constant_true_undef_false_constexpr_vec() {
; CHECK-LABEL: @all_constant_true_undef_false_constexpr_vec(
; CHECK-NEXT:    [[S:%.*]] = select i1 ptrtoint (<2 x i32> ()* @all_constant_true_undef_false_constexpr_vec to i1), <2 x i32> undef, <2 x i32> <i32 -1, i32 ptrtoint (<2 x i32> ()* @all_constant_true_undef_false_constexpr_vec to i32)>
; CHECK-NEXT:    ret <2 x i32> [[S]]
;
  %s = select i1 ptrtoint (<2 x i32> ()* @all_constant_true_undef_false_constexpr_vec to i1), <2 x i32> undef, <2 x i32><i32 -1, i32 ptrtoint (<2 x i32> ()* @all_constant_true_undef_false_constexpr_vec to i32)>
  ret <2 x i32> %s
}

define i1 @expand_binop_undef(i32 %x, i32 %y) {
; CHECK-LABEL: @expand_binop_undef(
; CHECK-NEXT:    [[CMP9_NOT_1:%.*]] = icmp eq i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[CMP15:%.*]] = icmp slt i32 [[X]], [[Y]]
; CHECK-NEXT:    [[SPEC_SELECT39:%.*]] = select i1 [[CMP9_NOT_1]], i1 undef, i1 [[CMP15]]
; CHECK-NEXT:    [[SPEC_SELECT40:%.*]] = xor i1 [[CMP9_NOT_1]], true
; CHECK-NEXT:    [[SPEC_SELECT:%.*]] = and i1 [[SPEC_SELECT39]], [[SPEC_SELECT40]]
; CHECK-NEXT:    ret i1 [[SPEC_SELECT]]
;
  %cmp9.not.1 = icmp eq i32 %x, %y
  %cmp15 = icmp slt i32 %x, %y
  %spec.select39 = select i1 %cmp9.not.1, i1 undef, i1 %cmp15
  %spec.select40 = xor i1 %cmp9.not.1, 1
  %spec.select  = and i1 %spec.select39, %spec.select40
  ret i1 %spec.select
}

define i32 @pr47322_more_poisonous_replacement(i32 %arg) {
; CHECK-LABEL: @pr47322_more_poisonous_replacement(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[ARG:%.*]], 0
; CHECK-NEXT:    [[TRAILING:%.*]] = call i32 @llvm.cttz.i32(i32 [[ARG]], i1 immarg true)
; CHECK-NEXT:    [[SHIFTED:%.*]] = lshr i32 [[ARG]], [[TRAILING]]
; CHECK-NEXT:    [[R1_SROA_0_1:%.*]] = select i1 [[CMP]], i32 0, i32 [[SHIFTED]]
; CHECK-NEXT:    ret i32 [[R1_SROA_0_1]]
;
  %cmp = icmp eq i32 %arg, 0
  %trailing = call i32 @llvm.cttz.i32(i32 %arg, i1 immarg true)
  %shifted = lshr i32 %arg, %trailing
  %r1.sroa.0.1 = select i1 %cmp, i32 0, i32 %shifted
  ret i32 %r1.sroa.0.1
}
declare i32 @llvm.cttz.i32(i32, i1 immarg)

; Partial undef scalable vectors should be ignored.
define <vscale x 2 x i1> @ignore_scalable_undef(<vscale x 2 x i1> %cond) {
; CHECK-LABEL: @ignore_scalable_undef(
; CHECK-NEXT:    [[S:%.*]] = select <vscale x 2 x i1> [[COND:%.*]], <vscale x 2 x i1> undef, <vscale x 2 x i1> insertelement (<vscale x 2 x i1> poison, i1 true, i32 0)
; CHECK-NEXT:    ret <vscale x 2 x i1> [[S]]
;
  %vec = insertelement <vscale x 2 x i1> poison, i1 true, i32 0
  %s = select <vscale x 2 x i1> %cond, <vscale x 2 x i1> undef, <vscale x 2 x i1> %vec
  ret <vscale x 2 x i1> %s
}

; TODO: these can be optimized more

define i32 @poison(i32 %x, i32 %y) {
; CHECK-LABEL: @poison(
; CHECK-NEXT:    ret i32 [[X:%.*]]
;
  %v = select i1 undef, i32 %x, i32 %y
  ret i32 %v
}

define i32 @poison2(i1 %cond, i32 %x) {
; CHECK-LABEL: @poison2(
; CHECK-NEXT:    [[V:%.*]] = select i1 [[COND:%.*]], i32 poison, i32 [[X:%.*]]
; CHECK-NEXT:    ret i32 [[V]]
;
  %v = select i1 %cond, i32 poison, i32 %x
  ret i32 %v
}

define i32 @poison3(i1 %cond, i32 %x) {
; CHECK-LABEL: @poison3(
; CHECK-NEXT:    [[V:%.*]] = select i1 [[COND:%.*]], i32 [[X:%.*]], i32 poison
; CHECK-NEXT:    ret i32 [[V]]
;
  %v = select i1 %cond, i32 %x, i32 poison
  ret i32 %v
}

define <2 x i32> @poison4(<2 x i1> %cond, <2 x i32> %x) {
; CHECK-LABEL: @poison4(
; CHECK-NEXT:    [[V:%.*]] = select <2 x i1> [[COND:%.*]], <2 x i32> [[X:%.*]], <2 x i32> poison
; CHECK-NEXT:    ret <2 x i32> [[V]]
;
  %v = select <2 x i1> %cond, <2 x i32> %x, <2 x i32> poison
  ret <2 x i32> %v
}
