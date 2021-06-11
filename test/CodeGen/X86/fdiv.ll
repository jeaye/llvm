; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -enable-unsafe-fp-math | FileCheck %s

define double @exact(double %x) {
; Exact division by a constant converted to multiplication.
; CHECK-LABEL: exact:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mulsd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; CHECK-NEXT:    retq
  %div = fdiv double %x, 2.0
  ret double %div
}

define double @inexact(double %x) {
; Inexact division by a constant converted to multiplication.
; CHECK-LABEL: inexact:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mulsd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; CHECK-NEXT:    retq
  %div = fdiv double %x, 0x41DFFFFFFFC00000
  ret double %div
}

define double @funky(double %x) {
; No conversion to multiplication if too funky.
; CHECK-LABEL: funky:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorpd %xmm1, %xmm1
; CHECK-NEXT:    divsd %xmm1, %xmm0
; CHECK-NEXT:    retq
  %div = fdiv double %x, 0.0
  ret double %div
}

define double @denormal1(double %x) {
; Don't generate multiplication by a denormal.
; CHECK-LABEL: denormal1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    divsd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; CHECK-NEXT:    retq
  %div = fdiv double %x, 0x7FD0000000000001
  ret double %div
}

define double @denormal2(double %x) {
; Don't generate multiplication by a denormal.
; CHECK-LABEL: denormal2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    divsd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; CHECK-NEXT:    retq
  %div = fdiv double %x, 0x7FEFFFFFFFFFFFFF
  ret double %div
}

; Deleting the negates does not require unsafe-fp-math.

define float @double_negative(float %x, float %y) #0 {
; CHECK-LABEL: double_negative:
; CHECK:       # %bb.0:
; CHECK-NEXT:    divss %xmm1, %xmm0
; CHECK-NEXT:    retq
  %neg1 = fsub float -0.0, %x
  %neg2 = fsub float -0.0, %y
  %div = fdiv float %neg1, %neg2
  ret float %div
}

define <4 x float> @double_negative_vector(<4 x float> %x, <4 x float> %y) #0 {
; CHECK-LABEL: double_negative_vector:
; CHECK:       # %bb.0:
; CHECK-NEXT:    divps %xmm1, %xmm0
; CHECK-NEXT:    retq
  %neg1 = fsub <4 x float> <float -0.0, float -0.0, float -0.0, float -0.0>, %x
  %neg2 = fsub <4 x float> <float -0.0, float -0.0, float -0.0, float -0.0>, %y
  %div = fdiv <4 x float> %neg1, %neg2
  ret <4 x float> %div
}

; This test used to fail, depending on how llc was built (e.g. using
; clang/gcc), due to order of argument evaluation not being well defined. We
; ended up hitting llvm_unreachable in getNegatedExpression when building with
; gcc. Just make sure that we get a deterministic result.
define float @fdiv_fneg_combine(float %a0, float %a1, float %a2) #0 {
; CHECK-LABEL: fdiv_fneg_combine:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movaps %xmm0, %xmm3
; CHECK-NEXT:    subss %xmm1, %xmm3
; CHECK-NEXT:    subss %xmm0, %xmm1
; CHECK-NEXT:    mulss %xmm2, %xmm1
; CHECK-NEXT:    subss %xmm2, %xmm3
; CHECK-NEXT:    divss %xmm3, %xmm1
; CHECK-NEXT:    movaps %xmm1, %xmm0
; CHECK-NEXT:    retq
  %sub1 = fsub fast float %a0, %a1
  %mul2 = fmul fast float %sub1, %a2
  %neg = fneg fast float %a0
  %add3 = fadd fast float %a1, %neg
  %sub4 = fadd fast float %add3, %a2
  %div5 = fdiv fast float %mul2, %sub4
  ret float %div5
}

attributes #0 = { "unsafe-fp-math"="false" }

