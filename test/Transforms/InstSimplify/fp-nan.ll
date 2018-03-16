; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instsimplify -S | FileCheck %s

; Default NaN constant

define double @fadd_nan_op0(double %x) {
; CHECK-LABEL: @fadd_nan_op0(
; CHECK-NEXT:    [[R:%.*]] = fadd double 0x7FF8000000000000, [[X:%.*]]
; CHECK-NEXT:    ret double [[R]]
;
  %r = fadd double 0x7FF8000000000000, %x
  ret double %r
}

; Sign bit is set

define double @fadd_nan_op1(double %x) {
; CHECK-LABEL: @fadd_nan_op1(
; CHECK-NEXT:    [[R:%.*]] = fadd double [[X:%.*]], 0xFFF8000000000000
; CHECK-NEXT:    ret double [[R]]
;
  %r = fadd double %x, 0xFFF8000000000000
  ret double %r
}

; Non-zero payload

define float @fsub_nan_op0(float %x) {
; CHECK-LABEL: @fsub_nan_op0(
; CHECK-NEXT:    [[R:%.*]] = fsub float 0x7FFFFF0000000000, [[X:%.*]]
; CHECK-NEXT:    ret float [[R]]
;
  %r = fsub float 0x7FFFFF0000000000, %x
  ret float %r
}

; Signaling

define float @fsub_nan_op1(float %x) {
; CHECK-LABEL: @fsub_nan_op1(
; CHECK-NEXT:    [[R:%.*]] = fsub float [[X:%.*]], 0x7FF1000000000000
; CHECK-NEXT:    ret float [[R]]
;
  %r = fsub float %x, 0x7FF1000000000000
  ret float %r
}

; Signaling and signed

define double @fmul_nan_op0(double %x) {
; CHECK-LABEL: @fmul_nan_op0(
; CHECK-NEXT:    [[R:%.*]] = fmul double 0xFFF0000000000001, [[X:%.*]]
; CHECK-NEXT:    ret double [[R]]
;
  %r = fmul double 0xFFF0000000000001, %x
  ret double %r
}

; Vector type

define <2 x float> @fmul_nan_op1(<2 x float> %x) {
; CHECK-LABEL: @fmul_nan_op1(
; CHECK-NEXT:    [[R:%.*]] = fmul <2 x float> [[X:%.*]], <float 0x7FF8000000000000, float 0x7FF8000000000000>
; CHECK-NEXT:    ret <2 x float> [[R]]
;
  %r = fmul <2 x float> %x, <float 0x7FF8000000000000, float 0x7FF8000000000000>
  ret <2 x float> %r
}

; Vector signed and non-zero payload

define <2 x double> @fdiv_nan_op0(<2 x double> %x) {
; CHECK-LABEL: @fdiv_nan_op0(
; CHECK-NEXT:    [[R:%.*]] = fdiv <2 x double> <double 0xFFF800000000000F, double 0xFFF800000000000F>, [[X:%.*]]
; CHECK-NEXT:    ret <2 x double> [[R]]
;
  %r = fdiv <2 x double> <double 0xFFF800000000000F, double 0xFFF800000000000F>, %x
  ret <2 x double>  %r
}

; Vector with different NaN constant elements

define <2 x half> @fdiv_nan_op1(<2 x half> %x) {
; CHECK-LABEL: @fdiv_nan_op1(
; CHECK-NEXT:    [[R:%.*]] = fdiv <2 x half> [[X:%.*]], <half 0xH7FFF, half 0xHFF00>
; CHECK-NEXT:    ret <2 x half> [[R]]
;
  %r = fdiv <2 x half> %x, <half 0xH7FFF, half 0xHFF00>
  ret <2 x half> %r
}

; Vector with undef element

define <2 x double> @frem_nan_op0(<2 x double> %x) {
; CHECK-LABEL: @frem_nan_op0(
; CHECK-NEXT:    [[R:%.*]] = frem <2 x double> <double 0xFFFF000000000000, double undef>, [[X:%.*]]
; CHECK-NEXT:    ret <2 x double> [[R]]
;
  %r = frem <2 x double> <double 0xFFFF000000000000, double undef>, %x
  ret <2 x double> %r
}

define float @frem_nan_op1(float %x) {
; CHECK-LABEL: @frem_nan_op1(
; CHECK-NEXT:    [[R:%.*]] = frem float [[X:%.*]], 0x7FF8000000000000
; CHECK-NEXT:    ret float [[R]]
;
  %r = frem float %x, 0x7FF8000000000000
  ret float %r
}

; Special-case: fneg must only change the sign bit (this is handled by constant folding).

define double @fneg_nan_1(double %x) {
; CHECK-LABEL: @fneg_nan_1(
; CHECK-NEXT:    ret double 0xFFFABCDEF0123456
;
  %r = fsub double -0.0, 0x7FFABCDEF0123456
  ret double %r
}

define <2 x double> @fneg_nan_2(<2 x double> %x) {
; CHECK-LABEL: @fneg_nan_2(
; CHECK-NEXT:    ret <2 x double> <double 0x7FF1234567890ABC, double 0xFFF0000000000001>
;
  %r = fsub <2 x double> <double -0.0, double -0.0>, <double 0xFFF1234567890ABC, double 0x7FF0000000000001>
  ret <2 x double> %r
}

; Repeat all tests with fast-math-flags. Alternate 'nnan' and 'fast' for more coverage.

define float @fadd_nan_op0_nnan(float %x) {
; CHECK-LABEL: @fadd_nan_op0_nnan(
; CHECK-NEXT:    [[R:%.*]] = fadd nnan float 0x7FF8000000000000, [[X:%.*]]
; CHECK-NEXT:    ret float [[R]]
;
  %r = fadd nnan float 0x7FF8000000000000, %x
  ret float %r
}

define float @fadd_nan_op1_fast(float %x) {
; CHECK-LABEL: @fadd_nan_op1_fast(
; CHECK-NEXT:    [[R:%.*]] = fadd fast float [[X:%.*]], 0x7FF8000000000000
; CHECK-NEXT:    ret float [[R]]
;
  %r = fadd fast float %x, 0x7FF8000000000000
  ret float %r
}

define float @fsub_nan_op0_fast(float %x) {
; CHECK-LABEL: @fsub_nan_op0_fast(
; CHECK-NEXT:    [[R:%.*]] = fsub fast float 0x7FF8000000000000, [[X:%.*]]
; CHECK-NEXT:    ret float [[R]]
;
  %r = fsub fast float 0x7FF8000000000000, %x
  ret float %r
}

define float @fsub_nan_op1_nnan(float %x) {
; CHECK-LABEL: @fsub_nan_op1_nnan(
; CHECK-NEXT:    [[R:%.*]] = fsub nnan float [[X:%.*]], 0x7FF8000000000000
; CHECK-NEXT:    ret float [[R]]
;
  %r = fsub nnan float %x, 0x7FF8000000000000
  ret float %r
}

define float @fmul_nan_op0_nnan(float %x) {
; CHECK-LABEL: @fmul_nan_op0_nnan(
; CHECK-NEXT:    [[R:%.*]] = fmul nnan float 0x7FF8000000000000, [[X:%.*]]
; CHECK-NEXT:    ret float [[R]]
;
  %r = fmul nnan float 0x7FF8000000000000, %x
  ret float %r
}

define float @fmul_nan_op1_fast(float %x) {
; CHECK-LABEL: @fmul_nan_op1_fast(
; CHECK-NEXT:    [[R:%.*]] = fmul fast float [[X:%.*]], 0x7FF8000000000000
; CHECK-NEXT:    ret float [[R]]
;
  %r = fmul fast float %x, 0x7FF8000000000000
  ret float %r
}

define float @fdiv_nan_op0_fast(float %x) {
; CHECK-LABEL: @fdiv_nan_op0_fast(
; CHECK-NEXT:    [[R:%.*]] = fdiv fast float 0x7FF8000000000000, [[X:%.*]]
; CHECK-NEXT:    ret float [[R]]
;
  %r = fdiv fast float 0x7FF8000000000000, %x
  ret float %r
}

define float @fdiv_nan_op1_nnan(float %x) {
; CHECK-LABEL: @fdiv_nan_op1_nnan(
; CHECK-NEXT:    [[R:%.*]] = fdiv nnan float [[X:%.*]], 0x7FF8000000000000
; CHECK-NEXT:    ret float [[R]]
;
  %r = fdiv nnan float %x, 0x7FF8000000000000
  ret float %r
}

define float @frem_nan_op0_nnan(float %x) {
; CHECK-LABEL: @frem_nan_op0_nnan(
; CHECK-NEXT:    [[R:%.*]] = frem nnan float 0x7FF8000000000000, [[X:%.*]]
; CHECK-NEXT:    ret float [[R]]
;
  %r = frem nnan float 0x7FF8000000000000, %x
  ret float %r
}

define float @frem_nan_op1_fast(float %x) {
; CHECK-LABEL: @frem_nan_op1_fast(
; CHECK-NEXT:    [[R:%.*]] = frem fast float [[X:%.*]], 0x7FF8000000000000
; CHECK-NEXT:    ret float [[R]]
;
  %r = frem fast float %x, 0x7FF8000000000000
  ret float %r
}

