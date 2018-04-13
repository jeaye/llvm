; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

; https://bugs.llvm.org/show_bug.cgi?id=6773

; Patterns:
;   (x & m) | (y & ~m)
;   (x & m) ^ (y & ~m)
; Should be transformed into:
;   ((x ^ y) & m) ^ y

define i32 @or(i32 %x, i32 %y, i32 %m) {
; CHECK-LABEL: @or(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], [[M:%.*]]
; CHECK-NEXT:    [[NEG:%.*]] = xor i32 [[M]], -1
; CHECK-NEXT:    [[AND1:%.*]] = and i32 [[NEG]], [[Y:%.*]]
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[AND]], [[AND1]]
; CHECK-NEXT:    ret i32 [[OR]]
;
  %and = and i32 %x, %m
  %neg = xor i32 %m, -1
  %and1 = and i32 %neg, %y
  %or = or i32 %and, %and1
  ret i32 %or
}

define <2 x i32> @or_splatvec(<2 x i32> %x, <2 x i32> %y, <2 x i32> %m) {
; CHECK-LABEL: @or_splatvec(
; CHECK-NEXT:    [[AND:%.*]] = and <2 x i32> [[X:%.*]], [[M:%.*]]
; CHECK-NEXT:    [[NEG:%.*]] = xor <2 x i32> [[M]], <i32 -1, i32 -1>
; CHECK-NEXT:    [[AND1:%.*]] = and <2 x i32> [[NEG]], [[Y:%.*]]
; CHECK-NEXT:    [[OR:%.*]] = or <2 x i32> [[AND]], [[AND1]]
; CHECK-NEXT:    ret <2 x i32> [[OR]]
;
  %and = and <2 x i32> %x, %m
  %neg = xor <2 x i32> %m, <i32 -1, i32 -1>
  %and1 = and <2 x i32> %neg, %y
  %or = or <2 x i32> %and, %and1
  ret <2 x i32> %or
}

define <3 x i32> @or_vec_undef(<3 x i32> %x, <3 x i32> %y, <3 x i32> %m) {
; CHECK-LABEL: @or_vec_undef(
; CHECK-NEXT:    [[AND:%.*]] = and <3 x i32> [[X:%.*]], [[M:%.*]]
; CHECK-NEXT:    [[NEG:%.*]] = xor <3 x i32> [[M]], <i32 -1, i32 undef, i32 -1>
; CHECK-NEXT:    [[AND1:%.*]] = and <3 x i32> [[NEG]], [[Y:%.*]]
; CHECK-NEXT:    [[OR:%.*]] = or <3 x i32> [[AND]], [[AND1]]
; CHECK-NEXT:    ret <3 x i32> [[OR]]
;
  %and = and <3 x i32> %x, %m
  %neg = xor <3 x i32> %m, <i32 -1, i32 undef, i32 -1>
  %and1 = and <3 x i32> %neg, %y
  %or = or <3 x i32> %and, %and1
  ret <3 x i32> %or
}

define i32 @xor(i32 %x, i32 %y, i32 %m) {
; CHECK-LABEL: @xor(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], [[M:%.*]]
; CHECK-NEXT:    [[NEG:%.*]] = xor i32 [[M]], -1
; CHECK-NEXT:    [[AND1:%.*]] = and i32 [[NEG]], [[Y:%.*]]
; CHECK-NEXT:    [[XOR:%.*]] = xor i32 [[AND]], [[AND1]]
; CHECK-NEXT:    ret i32 [[XOR]]
;
  %and = and i32 %x, %m
  %neg = xor i32 %m, -1
  %and1 = and i32 %neg, %y
  %xor = xor i32 %and, %and1
  ret i32 %xor
}

define <2 x i32> @xor_splatvec(<2 x i32> %x, <2 x i32> %y, <2 x i32> %m) {
; CHECK-LABEL: @xor_splatvec(
; CHECK-NEXT:    [[AND:%.*]] = and <2 x i32> [[X:%.*]], [[M:%.*]]
; CHECK-NEXT:    [[NEG:%.*]] = xor <2 x i32> [[M]], <i32 -1, i32 -1>
; CHECK-NEXT:    [[AND1:%.*]] = and <2 x i32> [[NEG]], [[Y:%.*]]
; CHECK-NEXT:    [[XOR:%.*]] = xor <2 x i32> [[AND]], [[AND1]]
; CHECK-NEXT:    ret <2 x i32> [[XOR]]
;
  %and = and <2 x i32> %x, %m
  %neg = xor <2 x i32> %m, <i32 -1, i32 -1>
  %and1 = and <2 x i32> %neg, %y
  %xor = xor <2 x i32> %and, %and1
  ret <2 x i32> %xor
}

define <3 x i32> @xor_vec_undef(<3 x i32> %x, <3 x i32> %y, <3 x i32> %m) {
; CHECK-LABEL: @xor_vec_undef(
; CHECK-NEXT:    [[AND:%.*]] = and <3 x i32> [[X:%.*]], [[M:%.*]]
; CHECK-NEXT:    [[NEG:%.*]] = xor <3 x i32> [[M]], <i32 -1, i32 undef, i32 -1>
; CHECK-NEXT:    [[AND1:%.*]] = and <3 x i32> [[NEG]], [[Y:%.*]]
; CHECK-NEXT:    [[XOR:%.*]] = xor <3 x i32> [[AND]], [[AND1]]
; CHECK-NEXT:    ret <3 x i32> [[XOR]]
;
  %and = and <3 x i32> %x, %m
  %neg = xor <3 x i32> %m, <i32 -1, i32 undef, i32 -1>
  %and1 = and <3 x i32> %neg, %y
  %xor = xor <3 x i32> %and, %and1
  ret <3 x i32> %xor
}

; ============================================================================ ;
; Constant mask.
; ============================================================================ ;

define i32 @or_constmask(i32 %x, i32 %y) {
; CHECK-LABEL: @or_constmask(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], 65280
; CHECK-NEXT:    [[AND1:%.*]] = and i32 [[Y:%.*]], -65281
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[AND]], [[AND1]]
; CHECK-NEXT:    ret i32 [[OR]]
;
  %and = and i32 %x, 65280
  %and1 = and i32 %y, -65281
  %or = or i32 %and, %and1
  ret i32 %or
}

define <2 x i32> @or_constmask_splatvec(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @or_constmask_splatvec(
; CHECK-NEXT:    [[AND:%.*]] = and <2 x i32> [[X:%.*]], <i32 65280, i32 65280>
; CHECK-NEXT:    [[AND1:%.*]] = and <2 x i32> [[Y:%.*]], <i32 -65281, i32 -65281>
; CHECK-NEXT:    [[OR:%.*]] = or <2 x i32> [[AND]], [[AND1]]
; CHECK-NEXT:    ret <2 x i32> [[OR]]
;
  %and = and <2 x i32> %x, <i32 65280, i32 65280>
  %and1 = and <2 x i32> %y, <i32 -65281, i32 -65281>
  %or = or <2 x i32> %and, %and1
  ret <2 x i32> %or
}

define <2 x i32> @or_constmask_vec(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @or_constmask_vec(
; CHECK-NEXT:    [[AND:%.*]] = and <2 x i32> [[X:%.*]], <i32 65280, i32 16776960>
; CHECK-NEXT:    [[AND1:%.*]] = and <2 x i32> [[Y:%.*]], <i32 -65281, i32 -16776961>
; CHECK-NEXT:    [[OR:%.*]] = or <2 x i32> [[AND]], [[AND1]]
; CHECK-NEXT:    ret <2 x i32> [[OR]]
;
  %and = and <2 x i32> %x, <i32 65280, i32 16776960>
  %and1 = and <2 x i32> %y, <i32 -65281, i32 -16776961>
  %or = or <2 x i32> %and, %and1
  ret <2 x i32> %or
}

define <3 x i32> @or_constmask_vec_undef(<3 x i32> %x, <3 x i32> %y) {
; CHECK-LABEL: @or_constmask_vec_undef(
; CHECK-NEXT:    [[AND:%.*]] = and <3 x i32> [[X:%.*]], <i32 65280, i32 undef, i32 65280>
; CHECK-NEXT:    [[AND1:%.*]] = and <3 x i32> [[Y:%.*]], <i32 -65281, i32 undef, i32 -65281>
; CHECK-NEXT:    [[OR:%.*]] = or <3 x i32> [[AND]], [[AND1]]
; CHECK-NEXT:    ret <3 x i32> [[OR]]
;
  %and = and <3 x i32> %x, <i32 65280, i32 undef, i32 65280>
  %and1 = and <3 x i32> %y, <i32 -65281, i32 undef, i32 -65281>
  %or = or <3 x i32> %and, %and1
  ret <3 x i32> %or
}

define i32 @xor_constmask(i32 %x, i32 %y) {
; CHECK-LABEL: @xor_constmask(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], 65280
; CHECK-NEXT:    [[AND1:%.*]] = and i32 [[Y:%.*]], -65281
; CHECK-NEXT:    [[XOR1:%.*]] = or i32 [[AND]], [[AND1]]
; CHECK-NEXT:    ret i32 [[XOR1]]
;
  %and = and i32 %x, 65280
  %and1 = and i32 %y, -65281
  %xor = xor i32 %and, %and1
  ret i32 %xor
}

define <2 x i32> @xor_constmask_splatvec(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @xor_constmask_splatvec(
; CHECK-NEXT:    [[AND:%.*]] = and <2 x i32> [[X:%.*]], <i32 65280, i32 65280>
; CHECK-NEXT:    [[AND1:%.*]] = and <2 x i32> [[Y:%.*]], <i32 -65281, i32 -65281>
; CHECK-NEXT:    [[XOR1:%.*]] = or <2 x i32> [[AND]], [[AND1]]
; CHECK-NEXT:    ret <2 x i32> [[XOR1]]
;
  %and = and <2 x i32> %x, <i32 65280, i32 65280>
  %and1 = and <2 x i32> %y, <i32 -65281, i32 -65281>
  %xor = xor <2 x i32> %and, %and1
  ret <2 x i32> %xor
}

define <2 x i32> @xor_constmask_vec(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @xor_constmask_vec(
; CHECK-NEXT:    [[AND:%.*]] = and <2 x i32> [[X:%.*]], <i32 65280, i32 16776960>
; CHECK-NEXT:    [[AND1:%.*]] = and <2 x i32> [[Y:%.*]], <i32 -65281, i32 -16776961>
; CHECK-NEXT:    [[XOR:%.*]] = xor <2 x i32> [[AND]], [[AND1]]
; CHECK-NEXT:    ret <2 x i32> [[XOR]]
;
  %and = and <2 x i32> %x, <i32 65280, i32 16776960>
  %and1 = and <2 x i32> %y, <i32 -65281, i32 -16776961>
  %xor = xor <2 x i32> %and, %and1
  ret <2 x i32> %xor
}

define <3 x i32> @xor_constmask_vec_undef(<3 x i32> %x, <3 x i32> %y) {
; CHECK-LABEL: @xor_constmask_vec_undef(
; CHECK-NEXT:    [[AND:%.*]] = and <3 x i32> [[X:%.*]], <i32 65280, i32 undef, i32 65280>
; CHECK-NEXT:    [[AND1:%.*]] = and <3 x i32> [[Y:%.*]], <i32 -65281, i32 undef, i32 -65281>
; CHECK-NEXT:    [[XOR:%.*]] = xor <3 x i32> [[AND]], [[AND1]]
; CHECK-NEXT:    ret <3 x i32> [[XOR]]
;
  %and = and <3 x i32> %x, <i32 65280, i32 undef, i32 65280>
  %and1 = and <3 x i32> %y, <i32 -65281, i32 undef, i32 -65281>
  %xor = xor <3 x i32> %and, %and1
  ret <3 x i32> %xor
}

; ============================================================================ ;
; Commutativity.
; ============================================================================ ;

define i32 @or_commutative0(i32 %x, i32 %y, i32 %m) {
; CHECK-LABEL: @or_commutative0(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[M:%.*]], [[X:%.*]]
; CHECK-NEXT:    [[NEG:%.*]] = xor i32 [[M]], -1
; CHECK-NEXT:    [[AND1:%.*]] = and i32 [[NEG]], [[Y:%.*]]
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[AND]], [[AND1]]
; CHECK-NEXT:    ret i32 [[OR]]
;
  %and = and i32 %m, %x ; swapped order
  %neg = xor i32 %m, -1
  %and1 = and i32 %neg, %y
  %or = or i32 %and, %and1
  ret i32 %or
}

define i32 @or_commutative1(i32 %x, i32 %y, i32 %m) {
; CHECK-LABEL: @or_commutative1(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], [[M:%.*]]
; CHECK-NEXT:    [[NEG:%.*]] = xor i32 [[M]], -1
; CHECK-NEXT:    [[AND1:%.*]] = and i32 [[NEG]], [[Y:%.*]]
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[AND]], [[AND1]]
; CHECK-NEXT:    ret i32 [[OR]]
;
  %and = and i32 %x, %m
  %neg = xor i32 %m, -1
  %and1 = and i32 %y, %neg; swapped order
  %or = or i32 %and, %and1
  ret i32 %or
}

define i32 @or_commutative2(i32 %x, i32 %y, i32 %m) {
; CHECK-LABEL: @or_commutative2(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], [[M:%.*]]
; CHECK-NEXT:    [[NEG:%.*]] = xor i32 [[M]], -1
; CHECK-NEXT:    [[AND1:%.*]] = and i32 [[NEG]], [[Y:%.*]]
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[AND1]], [[AND]]
; CHECK-NEXT:    ret i32 [[OR]]
;
  %and = and i32 %x, %m
  %neg = xor i32 %m, -1
  %and1 = and i32 %neg, %y
  %or = or i32 %and1, %and ; swapped order
  ret i32 %or
}


define i32 @or_commutative3(i32 %x, i32 %y, i32 %m) {
; CHECK-LABEL: @or_commutative3(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[M:%.*]], [[X:%.*]]
; CHECK-NEXT:    [[NEG:%.*]] = xor i32 [[M]], -1
; CHECK-NEXT:    [[AND1:%.*]] = and i32 [[NEG]], [[Y:%.*]]
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[AND]], [[AND1]]
; CHECK-NEXT:    ret i32 [[OR]]
;
  %and = and i32 %m, %x ; swapped order
  %neg = xor i32 %m, -1
  %and1 = and i32 %y, %neg; swapped order
  %or = or i32 %and, %and1
  ret i32 %or
}

define i32 @or_commutative4(i32 %x, i32 %y, i32 %m) {
; CHECK-LABEL: @or_commutative4(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[M:%.*]], [[X:%.*]]
; CHECK-NEXT:    [[NEG:%.*]] = xor i32 [[M]], -1
; CHECK-NEXT:    [[AND1:%.*]] = and i32 [[NEG]], [[Y:%.*]]
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[AND1]], [[AND]]
; CHECK-NEXT:    ret i32 [[OR]]
;
  %and = and i32 %m, %x ; swapped order
  %neg = xor i32 %m, -1
  %and1 = and i32 %neg, %y
  %or = or i32 %and1, %and ; swapped order
  ret i32 %or
}

define i32 @or_commutative5(i32 %x, i32 %y, i32 %m) {
; CHECK-LABEL: @or_commutative5(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], [[M:%.*]]
; CHECK-NEXT:    [[NEG:%.*]] = xor i32 [[M]], -1
; CHECK-NEXT:    [[AND1:%.*]] = and i32 [[NEG]], [[Y:%.*]]
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[AND1]], [[AND]]
; CHECK-NEXT:    ret i32 [[OR]]
;
  %and = and i32 %x, %m
  %neg = xor i32 %m, -1
  %and1 = and i32 %y, %neg; swapped order
  %or = or i32 %and1, %and ; swapped order
  ret i32 %or
}


define i32 @or_commutative6(i32 %x, i32 %y, i32 %m) {
; CHECK-LABEL: @or_commutative6(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[M:%.*]], [[X:%.*]]
; CHECK-NEXT:    [[NEG:%.*]] = xor i32 [[M]], -1
; CHECK-NEXT:    [[AND1:%.*]] = and i32 [[NEG]], [[Y:%.*]]
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[AND1]], [[AND]]
; CHECK-NEXT:    ret i32 [[OR]]
;
  %and = and i32 %m, %x ; swapped order
  %neg = xor i32 %m, -1
  %and1 = and i32 %y, %neg; swapped order
  %or = or i32 %and1, %and ; swapped order
  ret i32 %or
}



define i32 @xor_commutative0(i32 %x, i32 %y, i32 %m) {
; CHECK-LABEL: @xor_commutative0(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[M:%.*]], [[X:%.*]]
; CHECK-NEXT:    [[NEG:%.*]] = xor i32 [[M]], -1
; CHECK-NEXT:    [[AND1:%.*]] = and i32 [[NEG]], [[Y:%.*]]
; CHECK-NEXT:    [[XOR:%.*]] = xor i32 [[AND]], [[AND1]]
; CHECK-NEXT:    ret i32 [[XOR]]
;
  %and = and i32 %m, %x ; swapped order
  %neg = xor i32 %m, -1
  %and1 = and i32 %neg, %y
  %xor = xor i32 %and, %and1
  ret i32 %xor
}

define i32 @xor_commutative1(i32 %x, i32 %y, i32 %m) {
; CHECK-LABEL: @xor_commutative1(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], [[M:%.*]]
; CHECK-NEXT:    [[NEG:%.*]] = xor i32 [[M]], -1
; CHECK-NEXT:    [[AND1:%.*]] = and i32 [[NEG]], [[Y:%.*]]
; CHECK-NEXT:    [[XOR:%.*]] = xor i32 [[AND]], [[AND1]]
; CHECK-NEXT:    ret i32 [[XOR]]
;
  %and = and i32 %x, %m
  %neg = xor i32 %m, -1
  %and1 = and i32 %y, %neg; swapped order
  %xor = xor i32 %and, %and1
  ret i32 %xor
}

define i32 @xor_commutative2(i32 %x, i32 %y, i32 %m) {
; CHECK-LABEL: @xor_commutative2(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], [[M:%.*]]
; CHECK-NEXT:    [[NEG:%.*]] = xor i32 [[M]], -1
; CHECK-NEXT:    [[AND1:%.*]] = and i32 [[NEG]], [[Y:%.*]]
; CHECK-NEXT:    [[XOR:%.*]] = xor i32 [[AND1]], [[AND]]
; CHECK-NEXT:    ret i32 [[XOR]]
;
  %and = and i32 %x, %m
  %neg = xor i32 %m, -1
  %and1 = and i32 %neg, %y
  %xor = xor i32 %and1, %and ; swapped order
  ret i32 %xor
}


define i32 @xor_commutative3(i32 %x, i32 %y, i32 %m) {
; CHECK-LABEL: @xor_commutative3(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[M:%.*]], [[X:%.*]]
; CHECK-NEXT:    [[NEG:%.*]] = xor i32 [[M]], -1
; CHECK-NEXT:    [[AND1:%.*]] = and i32 [[NEG]], [[Y:%.*]]
; CHECK-NEXT:    [[XOR:%.*]] = xor i32 [[AND]], [[AND1]]
; CHECK-NEXT:    ret i32 [[XOR]]
;
  %and = and i32 %m, %x ; swapped order
  %neg = xor i32 %m, -1
  %and1 = and i32 %y, %neg; swapped order
  %xor = xor i32 %and, %and1
  ret i32 %xor
}

define i32 @xor_commutative4(i32 %x, i32 %y, i32 %m) {
; CHECK-LABEL: @xor_commutative4(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[M:%.*]], [[X:%.*]]
; CHECK-NEXT:    [[NEG:%.*]] = xor i32 [[M]], -1
; CHECK-NEXT:    [[AND1:%.*]] = and i32 [[NEG]], [[Y:%.*]]
; CHECK-NEXT:    [[XOR:%.*]] = xor i32 [[AND1]], [[AND]]
; CHECK-NEXT:    ret i32 [[XOR]]
;
  %and = and i32 %m, %x ; swapped order
  %neg = xor i32 %m, -1
  %and1 = and i32 %neg, %y
  %xor = xor i32 %and1, %and ; swapped order
  ret i32 %xor
}

define i32 @xor_commutative5(i32 %x, i32 %y, i32 %m) {
; CHECK-LABEL: @xor_commutative5(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], [[M:%.*]]
; CHECK-NEXT:    [[NEG:%.*]] = xor i32 [[M]], -1
; CHECK-NEXT:    [[AND1:%.*]] = and i32 [[NEG]], [[Y:%.*]]
; CHECK-NEXT:    [[XOR:%.*]] = xor i32 [[AND1]], [[AND]]
; CHECK-NEXT:    ret i32 [[XOR]]
;
  %and = and i32 %x, %m
  %neg = xor i32 %m, -1
  %and1 = and i32 %y, %neg; swapped order
  %xor = xor i32 %and1, %and ; swapped order
  ret i32 %xor
}


define i32 @xor_commutative6(i32 %x, i32 %y, i32 %m) {
; CHECK-LABEL: @xor_commutative6(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[M:%.*]], [[X:%.*]]
; CHECK-NEXT:    [[NEG:%.*]] = xor i32 [[M]], -1
; CHECK-NEXT:    [[AND1:%.*]] = and i32 [[NEG]], [[Y:%.*]]
; CHECK-NEXT:    [[XOR:%.*]] = xor i32 [[AND1]], [[AND]]
; CHECK-NEXT:    ret i32 [[XOR]]
;
  %and = and i32 %m, %x ; swapped order
  %neg = xor i32 %m, -1
  %and1 = and i32 %y, %neg; swapped order
  %xor = xor i32 %and1, %and ; swapped order
  ret i32 %xor
}


define i32 @or_constmask_commutative(i32 %x, i32 %y) {
; CHECK-LABEL: @or_constmask_commutative(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], 65280
; CHECK-NEXT:    [[AND1:%.*]] = and i32 [[Y:%.*]], -65281
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[AND1]], [[AND]]
; CHECK-NEXT:    ret i32 [[OR]]
;
  %and = and i32 %x, 65280
  %and1 = and i32 %y, -65281
  %or = or i32 %and1, %and ; swapped order
  ret i32 %or
}

define i32 @xor_constmask_commutative(i32 %x, i32 %y) {
; CHECK-LABEL: @xor_constmask_commutative(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], 65280
; CHECK-NEXT:    [[AND1:%.*]] = and i32 [[Y:%.*]], -65281
; CHECK-NEXT:    [[XOR1:%.*]] = or i32 [[AND1]], [[AND]]
; CHECK-NEXT:    ret i32 [[XOR1]]
;
  %and = and i32 %x, 65280
  %and1 = and i32 %y, -65281
  %xor = xor i32 %and1, %and ; swapped order
  ret i32 %xor
}

; ============================================================================ ;
; Negative tests. Should not be folded.
; ============================================================================ ;

; One use only.

declare void @use32(i32)

define i32 @n0_or_oneuse(i32 %x, i32 %y, i32 %m) {
; CHECK-LABEL: @n0_or_oneuse(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], [[M:%.*]]
; CHECK-NEXT:    [[NEG:%.*]] = xor i32 [[M]], -1
; CHECK-NEXT:    [[AND1:%.*]] = and i32 [[NEG]], [[Y:%.*]]
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[AND]], [[AND1]]
; CHECK-NEXT:    call void @use32(i32 [[AND]])
; CHECK-NEXT:    call void @use32(i32 [[NEG]])
; CHECK-NEXT:    call void @use32(i32 [[AND1]])
; CHECK-NEXT:    ret i32 [[OR]]
;
  %and = and i32 %x, %m
  %neg = xor i32 %m, -1
  %and1 = and i32 %neg, %y
  %or = or i32 %and, %and1
  call void @use32(i32 %and)
  call void @use32(i32 %neg)
  call void @use32(i32 %and1)
  ret i32 %or
}

define i32 @n0_xor_oneuse(i32 %x, i32 %y, i32 %m) {
; CHECK-LABEL: @n0_xor_oneuse(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], [[M:%.*]]
; CHECK-NEXT:    [[NEG:%.*]] = xor i32 [[M]], -1
; CHECK-NEXT:    [[AND1:%.*]] = and i32 [[NEG]], [[Y:%.*]]
; CHECK-NEXT:    [[XOR:%.*]] = xor i32 [[AND]], [[AND1]]
; CHECK-NEXT:    call void @use32(i32 [[AND]])
; CHECK-NEXT:    call void @use32(i32 [[NEG]])
; CHECK-NEXT:    call void @use32(i32 [[AND1]])
; CHECK-NEXT:    ret i32 [[XOR]]
;
  %and = and i32 %x, %m
  %neg = xor i32 %m, -1
  %and1 = and i32 %neg, %y
  %xor = xor i32 %and, %and1
  call void @use32(i32 %and)
  call void @use32(i32 %neg)
  call void @use32(i32 %and1)
  ret i32 %xor
}

define i32 @n0_or_constmask_oneuse(i32 %x, i32 %y) {
; CHECK-LABEL: @n0_or_constmask_oneuse(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], 65280
; CHECK-NEXT:    [[AND1:%.*]] = and i32 [[Y:%.*]], -65281
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[AND]], [[AND1]]
; CHECK-NEXT:    call void @use32(i32 [[AND]])
; CHECK-NEXT:    call void @use32(i32 [[AND1]])
; CHECK-NEXT:    call void @use32(i32 [[OR]])
; CHECK-NEXT:    ret i32 [[OR]]
;
  %and = and i32 %x, 65280
  %and1 = and i32 %y, -65281
  %or = or i32 %and, %and1
  call void @use32(i32 %and)
  call void @use32(i32 %and1)
  call void @use32(i32 %or)
  ret i32 %or
}

define i32 @n0_xor_constmask_oneuse(i32 %x, i32 %y) {
; CHECK-LABEL: @n0_xor_constmask_oneuse(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], 65280
; CHECK-NEXT:    [[AND1:%.*]] = and i32 [[Y:%.*]], -65281
; CHECK-NEXT:    [[XOR1:%.*]] = or i32 [[AND]], [[AND1]]
; CHECK-NEXT:    call void @use32(i32 [[AND]])
; CHECK-NEXT:    call void @use32(i32 [[AND1]])
; CHECK-NEXT:    call void @use32(i32 [[XOR1]])
; CHECK-NEXT:    ret i32 [[XOR1]]
;
  %and = and i32 %x, 65280
  %and1 = and i32 %y, -65281
  %xor = xor i32 %and, %and1
  call void @use32(i32 %and)
  call void @use32(i32 %and1)
  call void @use32(i32 %xor)
  ret i32 %xor
}

; Bad xor constant

define i32 @n1_or_badxor(i32 %x, i32 %y, i32 %m) {
; CHECK-LABEL: @n1_or_badxor(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], [[M:%.*]]
; CHECK-NEXT:    [[NEG:%.*]] = xor i32 [[M]], 1
; CHECK-NEXT:    [[AND1:%.*]] = and i32 [[NEG]], [[Y:%.*]]
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[AND]], [[AND1]]
; CHECK-NEXT:    ret i32 [[OR]]
;
  %and = and i32 %x, %m
  %neg = xor i32 %m, 1 ; not -1
  %and1 = and i32 %neg, %y
  %or = or i32 %and, %and1
  ret i32 %or
}

define i32 @n1_xor_badxor(i32 %x, i32 %y, i32 %m) {
; CHECK-LABEL: @n1_xor_badxor(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], [[M:%.*]]
; CHECK-NEXT:    [[NEG:%.*]] = xor i32 [[M]], 1
; CHECK-NEXT:    [[AND1:%.*]] = and i32 [[NEG]], [[Y:%.*]]
; CHECK-NEXT:    [[XOR:%.*]] = xor i32 [[AND]], [[AND1]]
; CHECK-NEXT:    ret i32 [[XOR]]
;
  %and = and i32 %x, %m
  %neg = xor i32 %m, 1 ; not -1
  %and1 = and i32 %neg, %y
  %xor = xor i32 %and, %and1
  ret i32 %xor
}

; Different mask is used

define i32 @n2_or_badmask(i32 %x, i32 %y, i32 %m1, i32 %m2) {
; CHECK-LABEL: @n2_or_badmask(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[M1:%.*]], [[X:%.*]]
; CHECK-NEXT:    [[NEG:%.*]] = xor i32 [[M2:%.*]], -1
; CHECK-NEXT:    [[AND1:%.*]] = and i32 [[NEG]], [[Y:%.*]]
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[AND]], [[AND1]]
; CHECK-NEXT:    ret i32 [[OR]]
;
  %and = and i32 %m1, %x
  %neg = xor i32 %m2, -1 ; different mask, not %m1
  %and1 = and i32 %neg, %y
  %or = or i32 %and, %and1
  ret i32 %or
}

define i32 @n2_xor_badmask(i32 %x, i32 %y, i32 %m1, i32 %m2) {
; CHECK-LABEL: @n2_xor_badmask(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[M1:%.*]], [[X:%.*]]
; CHECK-NEXT:    [[NEG:%.*]] = xor i32 [[M2:%.*]], -1
; CHECK-NEXT:    [[AND1:%.*]] = and i32 [[NEG]], [[Y:%.*]]
; CHECK-NEXT:    [[XOR:%.*]] = xor i32 [[AND]], [[AND1]]
; CHECK-NEXT:    ret i32 [[XOR]]
;
  %and = and i32 %m1, %x
  %neg = xor i32 %m2, -1 ; different mask, not %m1
  %and1 = and i32 %neg, %y
  %xor = xor i32 %and, %and1
  ret i32 %xor
}

; Different const mask is used

define i32 @n3_or_constmask_badmask(i32 %x, i32 %y) {
; CHECK-LABEL: @n3_or_constmask_badmask(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], 65280
; CHECK-NEXT:    [[AND1:%.*]] = and i32 [[Y:%.*]], -65280
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[AND]], [[AND1]]
; CHECK-NEXT:    ret i32 [[OR]]
;
  %and = and i32 %x, 65280
  %and1 = and i32 %y, -65280 ; not -65281
  %or = or i32 %and, %and1
  ret i32 %or
}

define i32 @n3_xor_constmask_badmask(i32 %x, i32 %y) {
; CHECK-LABEL: @n3_xor_constmask_badmask(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], 65280
; CHECK-NEXT:    [[AND1:%.*]] = and i32 [[Y:%.*]], -65280
; CHECK-NEXT:    [[XOR:%.*]] = xor i32 [[AND]], [[AND1]]
; CHECK-NEXT:    ret i32 [[XOR]]
;
  %and = and i32 %x, 65280
  %and1 = and i32 %y, -65280 ; not -65281
  %xor = xor i32 %and, %and1
  ret i32 %xor
}
