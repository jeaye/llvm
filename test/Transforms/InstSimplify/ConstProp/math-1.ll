; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -early-cse -earlycse-debug-hash -S -o - %s | FileCheck %s

declare double @acos(double) #0
define double @f_acos() {
; CHECK-LABEL: @f_acos(
; CHECK-NEXT:    ret double 0.000000e+00
;
  %res = tail call fast double @acos(double 1.0)
  ret double %res
}

declare float @asinf(float) #0
define float @f_asinf() {
; CHECK-LABEL: @f_asinf(
; CHECK-NEXT:    ret float 0x3FF921FB{{.+}}
;
  %res = tail call fast float @asinf(float 1.0)
  ret float %res
}

declare double @atan(double) #0
define double @f_atan() {
; CHECK-LABEL: @f_atan(
; CHECK-NEXT:    [[RES:%.*]] = tail call fast double @atan(double 1.000000e+00)
; CHECK-NEXT:    ret double 0x3FE921FB
;
  %res = tail call fast double @atan(double 1.0)
  ret double %res
}

declare float @cosf(float) #0
define float @f_cosf() {
; CHECK-LABEL: @f_cosf(
; CHECK-NEXT:    ret float 0x3FE14A2{{.+}}
;
  %res = tail call fast float @cosf(float 1.0)
  ret float %res
}

declare float @llvm.cos.f32(float)
define float @i_cosf() {
; CHECK-LABEL: @i_cosf(
; CHECK-NEXT:    ret float 0x3FE14A2
;
  %res = tail call fast float @llvm.cos.f32(float 1.0)
  ret float %res
}

declare double @cosh(double) #0
define double @f_cosh() {
; CHECK-LABEL: @f_cosh(
; CHECK-NEXT:    ret double 0x3FF8B075{{.+}}
;
  %res = tail call fast double @cosh(double 1.0)
  ret double %res
}

declare float @expf(float) #0
define float @f_expf() {
; CHECK-LABEL: @f_expf(
; CHECK-NEXT:    ret float 0x4005BF0A{{.+}}
;
  %res = tail call fast float @expf(float 1.0)
  ret float %res
}

declare float @llvm.exp.f32(float)
define float @i_expf() {
; CHECK-LABEL: @i_expf(
; CHECK-NEXT:    ret float 0x4005BF0A{{.+}}
;
  %res = tail call fast float @llvm.exp.f32(float 1.0)
  ret float %res
}

declare double @exp2(double) #0
define double @f_exp2() {
; CHECK-LABEL: @f_exp2(
; CHECK-NEXT:    ret double 2.000000e+00
;
  %res = tail call fast double @exp2(double 1.0)
  ret double %res
}

declare double @llvm.exp2.f64(double)
define double @i_exp2() {
; CHECK-LABEL: @i_exp2(
; CHECK-NEXT:    ret double 2.000000e+00
;
  %res = tail call fast double @llvm.exp2.f64(double 1.0)
  ret double %res
}

; FIXME: exp10() is not widely supported.
declare float @exp10f(float) #0
define float @f_exp10f() {
; CHECK-LABEL: @f_exp10f(
; CHECK-NEXT:    [[RES:%.*]] = tail call float @exp10f(float 1.000000e+00)
; CHECK-NEXT:    ret float [[RES]]
;
  %res = tail call float @exp10f(float 1.0)
  ret float %res
}

declare double @log(double) #0
define double @f_log() {
; CHECK-LABEL: @f_log(
; CHECK-NEXT:    ret double 0.000000e+00
;
  %res = tail call fast double @log(double 1.0)
  ret double %res
}

declare double @llvm.log.f64(double)
define double @i_log() {
; CHECK-LABEL: @i_log(
; CHECK-NEXT:    ret double 0.000000e+00
;
  %res = tail call fast double @llvm.log.f64(double 1.0)
  ret double %res
}

declare float @log2f(float) #0
define float @f_log2f() {
; CHECK-LABEL: @f_log2f(
; CHECK-NEXT:    ret float 0.000000e+00
;
  %res = tail call fast float @log2f(float 1.0)
  ret float %res
}

declare float @llvm.log2.f32(float)
define float @i_log2f() {
; CHECK-LABEL: @i_log2f(
; CHECK-NEXT:    ret float 0.000000e+00
;
  %res = tail call fast float @llvm.log2.f32(float 1.0)
  ret float %res
}

declare double @log10(double) #0
define double @f_log10() {
; CHECK-LABEL: @f_log10(
; CHECK-NEXT:    ret double 0.000000e+00
;
  %res = tail call fast double @log10(double 1.0)
  ret double %res
}

declare float @sinf(float) #0
define float @f_sinf() {
; CHECK-LABEL: @f_sinf(
; CHECK-NEXT:    ret float 0x3FEAED54{{.+}}
;
  %res = tail call fast float @sinf(float 1.0)
  ret float %res
}

declare double @sinh(double) #0
define double @f_sinh() {
; CHECK-LABEL: @f_sinh(
; CHECK-NEXT:    ret double 0x3FF2CD9F{{.+}}
;
  %res = tail call fast double @sinh(double 1.0)
  ret double %res
}

declare float @sqrtf(float) #0
define float @f_sqrtf() {
; CHECK-LABEL: @f_sqrtf(
; CHECK-NEXT:    ret float 1.000000e+00
;
  %res = tail call fast float @sqrtf(float 1.0)
  ret float %res
}

declare double @tan(double) #0
define double @f_tan() {
; CHECK-LABEL: @f_tan(
; CHECK-NEXT:    ret double 0x3FF8EB24{{.+}}
;
  %res = tail call fast double @tan(double 1.0)
  ret double %res
}

declare float @tanhf(float) #0
define float @f_tanhf() {
; CHECK-LABEL: @f_tanhf(
; CHECK-NEXT:    [[RES:%.*]] = tail call fast float @tanhf(float 1.000000e+00)
; CHECK-NEXT:    ret float 0x3FE85EFA{{.+}}
;
  %res = tail call fast float @tanhf(float 1.0)
  ret float %res
}

attributes #0 = { nofree nounwind willreturn }
