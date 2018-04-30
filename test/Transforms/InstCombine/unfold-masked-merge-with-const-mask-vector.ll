; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

; If we have a masked merge, in the form of: (M is constant)
;   ((x ^ y) & M) ^ y
; Unfold it to
;   (x & M) | (y & ~M)

define <2 x i4> @splat (<2 x i4> %x, <2 x i4> %y) {
; CHECK-LABEL: @splat(
; CHECK-NEXT:    [[TMP1:%.*]] = and <2 x i4> [[X:%.*]], <i4 -2, i4 -2>
; CHECK-NEXT:    [[TMP2:%.*]] = and <2 x i4> [[Y:%.*]], <i4 1, i4 1>
; CHECK-NEXT:    [[R:%.*]] = or <2 x i4> [[TMP1]], [[TMP2]]
; CHECK-NEXT:    ret <2 x i4> [[R]]
;
  %n0 = xor <2 x i4> %x, %y
  %n1 = and <2 x i4> %n0, <i4 -2, i4 -2>
  %r  = xor <2 x i4> %n1, %y
  ret <2 x i4> %r
}

define <3 x i4> @splat_undef (<3 x i4> %x, <3 x i4> %y) {
; CHECK-LABEL: @splat_undef(
; CHECK-NEXT:    [[TMP1:%.*]] = and <3 x i4> [[X:%.*]], <i4 -2, i4 undef, i4 -2>
; CHECK-NEXT:    [[TMP2:%.*]] = and <3 x i4> [[Y:%.*]], <i4 1, i4 undef, i4 1>
; CHECK-NEXT:    [[R:%.*]] = or <3 x i4> [[TMP1]], [[TMP2]]
; CHECK-NEXT:    ret <3 x i4> [[R]]
;
  %n0 = xor <3 x i4> %x, %y
  %n1 = and <3 x i4> %n0, <i4 -2, i4 undef, i4 -2>
  %r  = xor <3 x i4> %n1, %y
  ret <3 x i4> %r
}

define <2 x i4> @nonsplat (<2 x i4> %x, <2 x i4> %y) {
; CHECK-LABEL: @nonsplat(
; CHECK-NEXT:    [[TMP1:%.*]] = and <2 x i4> [[X:%.*]], <i4 -2, i4 1>
; CHECK-NEXT:    [[TMP2:%.*]] = and <2 x i4> [[Y:%.*]], <i4 1, i4 -2>
; CHECK-NEXT:    [[R:%.*]] = or <2 x i4> [[TMP1]], [[TMP2]]
; CHECK-NEXT:    ret <2 x i4> [[R]]
;
  %n0 = xor <2 x i4> %x, %y
  %n1 = and <2 x i4> %n0, <i4 -2, i4 1>
  %r  = xor <2 x i4> %n1, %y
  ret <2 x i4> %r
}

; ============================================================================ ;
; Various cases with %x and/or %y being a constant
; ============================================================================ ;

define <2 x i4> @in_constant_varx_mone(<2 x i4> %x, <2 x i4> %mask) {
; CHECK-LABEL: @in_constant_varx_mone(
; CHECK-NEXT:    [[R1:%.*]] = or <2 x i4> [[X:%.*]], <i4 -2, i4 -2>
; CHECK-NEXT:    ret <2 x i4> [[R1]]
;
  %n0 = xor <2 x i4> %x, <i4 -1, i4 -1> ; %x
  %n1 = and <2 x i4> %n0, <i4 1, i4 1>
  %r = xor <2 x i4> %n1, <i4 -1, i4 -1>
  ret <2 x i4> %r
}

define <2 x i4> @in_constant_varx_14(<2 x i4> %x, <2 x i4> %mask) {
; CHECK-LABEL: @in_constant_varx_14(
; CHECK-NEXT:    [[R1:%.*]] = or <2 x i4> [[X:%.*]], <i4 -2, i4 -2>
; CHECK-NEXT:    ret <2 x i4> [[R1]]
;
  %n0 = xor <2 x i4> %x, <i4 14, i4 14> ; %x
  %n1 = and <2 x i4> %n0, <i4 1, i4 1>
  %r = xor <2 x i4> %n1, <i4 14, i4 14>
  ret <2 x i4> %r
}

define <2 x i4> @in_constant_varx_14_nonsplat(<2 x i4> %x, <2 x i4> %mask) {
; CHECK-LABEL: @in_constant_varx_14_nonsplat(
; CHECK-NEXT:    [[TMP1:%.*]] = and <2 x i4> [[X:%.*]], <i4 1, i4 1>
; CHECK-NEXT:    [[R:%.*]] = or <2 x i4> [[TMP1]], <i4 -2, i4 6>
; CHECK-NEXT:    ret <2 x i4> [[R]]
;
  %n0 = xor <2 x i4> %x, <i4 14, i4 7> ; %x
  %n1 = and <2 x i4> %n0, <i4 1, i4 1>
  %r = xor <2 x i4> %n1, <i4 14, i4 7>
  ret <2 x i4> %r
}

define <3 x i4> @in_constant_varx_14_undef(<3 x i4> %x, <3 x i4> %mask) {
; CHECK-LABEL: @in_constant_varx_14_undef(
; CHECK-NEXT:    [[TMP1:%.*]] = and <3 x i4> [[X:%.*]], <i4 1, i4 undef, i4 1>
; CHECK-NEXT:    [[R:%.*]] = or <3 x i4> [[TMP1]], <i4 -2, i4 undef, i4 6>
; CHECK-NEXT:    ret <3 x i4> [[R]]
;
  %n0 = xor <3 x i4> %x, <i4 14, i4 undef, i4 7> ; %x
  %n1 = and <3 x i4> %n0, <i4 1, i4 undef, i4 1>
  %r = xor <3 x i4> %n1, <i4 14, i4 undef, i4 7>
  ret <3 x i4> %r
}

define <2 x i4> @in_constant_mone_vary(<2 x i4> %y, <2 x i4> %mask) {
; CHECK-LABEL: @in_constant_mone_vary(
; CHECK-NEXT:    [[N0:%.*]] = and <2 x i4> [[Y:%.*]], <i4 1, i4 1>
; CHECK-NEXT:    [[N1:%.*]] = xor <2 x i4> [[N0]], <i4 1, i4 1>
; CHECK-NEXT:    [[R:%.*]] = xor <2 x i4> [[N1]], [[Y]]
; CHECK-NEXT:    ret <2 x i4> [[R]]
;
  %n0 = xor <2 x i4> %y, <i4 -1, i4 -1> ; %x
  %n1 = and <2 x i4> %n0, <i4 1, i4 1>
  %r = xor <2 x i4> %n1, %y
  ret <2 x i4> %r
}

define <2 x i4> @in_constant_14_vary(<2 x i4> %y, <2 x i4> %mask) {
; CHECK-LABEL: @in_constant_14_vary(
; CHECK-NEXT:    [[R:%.*]] = and <2 x i4> [[Y:%.*]], <i4 -2, i4 -2>
; CHECK-NEXT:    ret <2 x i4> [[R]]
;
  %n0 = xor <2 x i4> %y, <i4 14, i4 14> ; %x
  %n1 = and <2 x i4> %n0, <i4 1, i4 1>
  %r = xor <2 x i4> %n1, %y
  ret <2 x i4> %r
}

define <2 x i4> @in_constant_14_vary_nonsplat(<2 x i4> %y, <2 x i4> %mask) {
; CHECK-LABEL: @in_constant_14_vary_nonsplat(
; CHECK-NEXT:    [[TMP1:%.*]] = and <2 x i4> [[Y:%.*]], <i4 -2, i4 -2>
; CHECK-NEXT:    [[R:%.*]] = or <2 x i4> [[TMP1]], <i4 0, i4 1>
; CHECK-NEXT:    ret <2 x i4> [[R]]
;
  %n0 = xor <2 x i4> %y, <i4 14, i4 7> ; %x
  %n1 = and <2 x i4> %n0, <i4 1, i4 1>
  %r = xor <2 x i4> %n1, %y
  ret <2 x i4> %r
}

define <3 x i4> @in_constant_14_vary_undef(<3 x i4> %y, <3 x i4> %mask) {
; CHECK-LABEL: @in_constant_14_vary_undef(
; CHECK-NEXT:    [[TMP1:%.*]] = and <3 x i4> [[Y:%.*]], <i4 -2, i4 undef, i4 -2>
; CHECK-NEXT:    [[R:%.*]] = or <3 x i4> [[TMP1]], <i4 0, i4 undef, i4 1>
; CHECK-NEXT:    ret <3 x i4> [[R]]
;
  %n0 = xor <3 x i4> %y, <i4 14, i4 undef, i4 7> ; %x
  %n1 = and <3 x i4> %n0, <i4 1, i4 undef, i4 1>
  %r = xor <3 x i4> %n1, %y
  ret <3 x i4> %r
}

; ============================================================================ ;
; Commutativity
; ============================================================================ ;

; Used to make sure that the IR complexity sorting does not interfere.
declare <2 x i4> @gen4()

define <2 x i4> @c_1_0_0 (<2 x i4> %x, <2 x i4> %y) {
; CHECK-LABEL: @c_1_0_0(
; CHECK-NEXT:    [[TMP1:%.*]] = and <2 x i4> [[X:%.*]], <i4 -2, i4 -2>
; CHECK-NEXT:    [[TMP2:%.*]] = and <2 x i4> [[Y:%.*]], <i4 1, i4 1>
; CHECK-NEXT:    [[R:%.*]] = or <2 x i4> [[TMP1]], [[TMP2]]
; CHECK-NEXT:    ret <2 x i4> [[R]]
;
  %n0 = xor <2 x i4> %y, %x ; swapped order
  %n1 = and <2 x i4> %n0, <i4 -2, i4 -2>
  %r  = xor <2 x i4> %n1, %y
  ret <2 x i4> %r
}

define <2 x i4> @c_0_1_0 (<2 x i4> %x, <2 x i4> %y) {
; CHECK-LABEL: @c_0_1_0(
; CHECK-NEXT:    [[TMP1:%.*]] = and <2 x i4> [[Y:%.*]], <i4 -2, i4 -2>
; CHECK-NEXT:    [[TMP2:%.*]] = and <2 x i4> [[X:%.*]], <i4 1, i4 1>
; CHECK-NEXT:    [[R:%.*]] = or <2 x i4> [[TMP1]], [[TMP2]]
; CHECK-NEXT:    ret <2 x i4> [[R]]
;
  %n0 = xor <2 x i4> %x, %y
  %n1 = and <2 x i4> %n0, <i4 -2, i4 -2>
  %r  = xor <2 x i4> %n1, %x ; %x instead of %y
  ret <2 x i4> %r
}

define <2 x i4> @c_0_0_1 () {
; CHECK-LABEL: @c_0_0_1(
; CHECK-NEXT:    [[X:%.*]] = call <2 x i4> @gen4()
; CHECK-NEXT:    [[Y:%.*]] = call <2 x i4> @gen4()
; CHECK-NEXT:    [[TMP1:%.*]] = and <2 x i4> [[X]], <i4 -2, i4 -2>
; CHECK-NEXT:    [[TMP2:%.*]] = and <2 x i4> [[Y]], <i4 1, i4 1>
; CHECK-NEXT:    [[R:%.*]] = or <2 x i4> [[TMP1]], [[TMP2]]
; CHECK-NEXT:    ret <2 x i4> [[R]]
;
  %x  = call <2 x i4> @gen4()
  %y  = call <2 x i4> @gen4()
  %n0 = xor <2 x i4> %x, %y
  %n1 = and <2 x i4> %n0, <i4 -2, i4 -2>
  %r  = xor <2 x i4> %y, %n1 ; swapped order
  ret <2 x i4> %r
}

define <2 x i4> @c_1_1_0 (<2 x i4> %x, <2 x i4> %y) {
; CHECK-LABEL: @c_1_1_0(
; CHECK-NEXT:    [[TMP1:%.*]] = and <2 x i4> [[Y:%.*]], <i4 -2, i4 -2>
; CHECK-NEXT:    [[TMP2:%.*]] = and <2 x i4> [[X:%.*]], <i4 1, i4 1>
; CHECK-NEXT:    [[R:%.*]] = or <2 x i4> [[TMP1]], [[TMP2]]
; CHECK-NEXT:    ret <2 x i4> [[R]]
;
  %n0 = xor <2 x i4> %y, %x ; swapped order
  %n1 = and <2 x i4> %n0, <i4 -2, i4 -2>
  %r  = xor <2 x i4> %n1, %x ; %x instead of %y
  ret <2 x i4> %r
}

define <2 x i4> @c_1_0_1 (<2 x i4> %x) {
; CHECK-LABEL: @c_1_0_1(
; CHECK-NEXT:    [[Y:%.*]] = call <2 x i4> @gen4()
; CHECK-NEXT:    [[TMP1:%.*]] = and <2 x i4> [[X:%.*]], <i4 -2, i4 -2>
; CHECK-NEXT:    [[TMP2:%.*]] = and <2 x i4> [[Y]], <i4 1, i4 1>
; CHECK-NEXT:    [[R:%.*]] = or <2 x i4> [[TMP1]], [[TMP2]]
; CHECK-NEXT:    ret <2 x i4> [[R]]
;
  %y  = call <2 x i4> @gen4()
  %n0 = xor <2 x i4> %y, %x ; swapped order
  %n1 = and <2 x i4> %n0, <i4 -2, i4 -2>
  %r  = xor <2 x i4> %y, %n1 ; swapped order
  ret <2 x i4> %r
}

define <2 x i4> @c_0_1_1 (<2 x i4> %y) {
; CHECK-LABEL: @c_0_1_1(
; CHECK-NEXT:    [[X:%.*]] = call <2 x i4> @gen4()
; CHECK-NEXT:    [[TMP1:%.*]] = and <2 x i4> [[Y:%.*]], <i4 -2, i4 -2>
; CHECK-NEXT:    [[TMP2:%.*]] = and <2 x i4> [[X]], <i4 1, i4 1>
; CHECK-NEXT:    [[R:%.*]] = or <2 x i4> [[TMP1]], [[TMP2]]
; CHECK-NEXT:    ret <2 x i4> [[R]]
;
  %x  = call <2 x i4> @gen4()
  %n0 = xor <2 x i4> %x, %y
  %n1 = and <2 x i4> %n0, <i4 -2, i4 -2>
  %r  = xor <2 x i4> %x, %n1 ; swapped order, %x instead of %y
  ret <2 x i4> %r
}

define <2 x i4> @c_1_1_1 () {
; CHECK-LABEL: @c_1_1_1(
; CHECK-NEXT:    [[X:%.*]] = call <2 x i4> @gen4()
; CHECK-NEXT:    [[Y:%.*]] = call <2 x i4> @gen4()
; CHECK-NEXT:    [[TMP1:%.*]] = and <2 x i4> [[Y]], <i4 -2, i4 -2>
; CHECK-NEXT:    [[TMP2:%.*]] = and <2 x i4> [[X]], <i4 1, i4 1>
; CHECK-NEXT:    [[R:%.*]] = or <2 x i4> [[TMP1]], [[TMP2]]
; CHECK-NEXT:    ret <2 x i4> [[R]]
;
  %x  = call <2 x i4> @gen4()
  %y  = call <2 x i4> @gen4()
  %n0 = xor <2 x i4> %y, %x ; swapped order
  %n1 = and <2 x i4> %n0, <i4 -2, i4 -2>
  %r  = xor <2 x i4> %x, %n1 ; swapped order, %x instead of %y
  ret <2 x i4> %r
}

define <2 x i4> @commutativity_constant_14_vary(<2 x i4> %y, <2 x i4> %mask) {
; CHECK-LABEL: @commutativity_constant_14_vary(
; CHECK-NEXT:    [[R:%.*]] = and <2 x i4> [[Y:%.*]], <i4 -2, i4 -2>
; CHECK-NEXT:    ret <2 x i4> [[R]]
;
  %n0 = xor <2 x i4> %y, <i4 14, i4 14> ; %x
  %n1 = and <2 x i4> %n0, <i4 1, i4 1>
  %r = xor <2 x i4> %y, %n1 ; swapped
  ret <2 x i4> %r
}

; ============================================================================ ;
; Negative tests. Should not be folded.
; ============================================================================ ;

; One use only.

declare void @use4(<2 x i4>)

define <2 x i4> @n_oneuse_D (<2 x i4> %x, <2 x i4> %y) {
; CHECK-LABEL: @n_oneuse_D(
; CHECK-NEXT:    [[N0:%.*]] = xor <2 x i4> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[N1:%.*]] = and <2 x i4> [[N0]], <i4 -2, i4 -2>
; CHECK-NEXT:    [[R:%.*]] = xor <2 x i4> [[N1]], [[Y]]
; CHECK-NEXT:    call void @use4(<2 x i4> [[N0]])
; CHECK-NEXT:    ret <2 x i4> [[R]]
;
  %n0 = xor <2 x i4> %x, %y ; two uses of %n0, which is going to be replaced
  %n1 = and <2 x i4> %n0, <i4 -2, i4 -2>
  %r  = xor <2 x i4> %n1, %y
  call void @use4(<2 x i4> %n0)
  ret <2 x i4> %r
}

define <2 x i4> @n_oneuse_A (<2 x i4> %x, <2 x i4> %y) {
; CHECK-LABEL: @n_oneuse_A(
; CHECK-NEXT:    [[N0:%.*]] = xor <2 x i4> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[N1:%.*]] = and <2 x i4> [[N0]], <i4 -2, i4 -2>
; CHECK-NEXT:    [[R:%.*]] = xor <2 x i4> [[N1]], [[Y]]
; CHECK-NEXT:    call void @use4(<2 x i4> [[N1]])
; CHECK-NEXT:    ret <2 x i4> [[R]]
;
  %n0 = xor <2 x i4> %x, %y
  %n1 = and <2 x i4> %n0, <i4 -2, i4 -2> ; two uses of %n1, which is going to be replaced
  %r  = xor <2 x i4> %n1, %y
  call void @use4(<2 x i4> %n1)
  ret <2 x i4> %r
}

define <2 x i4> @n_oneuse_AD (<2 x i4> %x, <2 x i4> %y) {
; CHECK-LABEL: @n_oneuse_AD(
; CHECK-NEXT:    [[N0:%.*]] = xor <2 x i4> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[N1:%.*]] = and <2 x i4> [[N0]], <i4 -2, i4 -2>
; CHECK-NEXT:    [[R:%.*]] = xor <2 x i4> [[N1]], [[Y]]
; CHECK-NEXT:    call void @use4(<2 x i4> [[N0]])
; CHECK-NEXT:    call void @use4(<2 x i4> [[N1]])
; CHECK-NEXT:    ret <2 x i4> [[R]]
;
  %n0 = xor <2 x i4> %x, %y
  %n1 = and <2 x i4> %n0, <i4 -2, i4 -2> ; two uses of %n1, which is going to be replaced
  %r  = xor <2 x i4> %n1, %y
  call void @use4(<2 x i4> %n0)
  call void @use4(<2 x i4> %n1)
  ret <2 x i4> %r
}

; Mask is not constant

define <2 x i4> @n_var_mask (<2 x i4> %x, <2 x i4> %y, <2 x i4> %m) {
; CHECK-LABEL: @n_var_mask(
; CHECK-NEXT:    [[N0:%.*]] = xor <2 x i4> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[N1:%.*]] = and <2 x i4> [[N0]], [[M:%.*]]
; CHECK-NEXT:    [[R:%.*]] = xor <2 x i4> [[N1]], [[Y]]
; CHECK-NEXT:    ret <2 x i4> [[R]]
;
  %n0 = xor <2 x i4> %x, %y
  %n1 = and <2 x i4> %n0, %m
  %r  = xor <2 x i4> %n1, %y
  ret <2 x i4> %r
}

; Some third variable is used

define <2 x i4> @n_differenty(<2 x i4> %x, <2 x i4> %mask) {
; CHECK-LABEL: @n_differenty(
; CHECK-NEXT:    [[N0:%.*]] = xor <2 x i4> [[X:%.*]], <i4 -2, i4 7>
; CHECK-NEXT:    [[N1:%.*]] = and <2 x i4> [[N0]], <i4 1, i4 1>
; CHECK-NEXT:    [[R:%.*]] = xor <2 x i4> [[N1]], <i4 7, i4 -2>
; CHECK-NEXT:    ret <2 x i4> [[R]]
;
  %n0 = xor <2 x i4> %x, <i4 14, i4 7> ; %x
  %n1 = and <2 x i4> %n0, <i4 1, i4 1>
  %r = xor <2 x i4> %n1, <i4 7, i4 14>
  ret <2 x i4> %r
}
