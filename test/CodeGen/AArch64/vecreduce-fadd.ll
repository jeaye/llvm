; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc --mtriple=aarch64-eabi -aarch64-neon-syntax=generic -mattr=+fullfp16 < %s | FileCheck %s
; RUN: llc --mtriple=aarch64-eabi -aarch64-neon-syntax=generic < %s | FileCheck %s --check-prefix=CHECKNOFP16

define float @add_HalfS(<2 x float> %bin.rdx)  {
; CHECK-LABEL: add_HalfS:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECK-NEXT:    faddp s0, v0.2s
; CHECK-NEXT:    ret
;
; CHECKNOFP16-LABEL: add_HalfS:
; CHECKNOFP16:       // %bb.0:
; CHECKNOFP16-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECKNOFP16-NEXT:    faddp s0, v0.2s
; CHECKNOFP16-NEXT:    ret
  %r = call fast float @llvm.experimental.vector.reduce.v2.fadd.f32.v2f32(float 0.0, <2 x float> %bin.rdx)
  ret float %r
}

define half @add_HalfH(<4 x half> %bin.rdx)  {
; CHECK-LABEL: add_HalfH:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECK-NEXT:    mov h3, v0.h[1]
; CHECK-NEXT:    mov h1, v0.h[3]
; CHECK-NEXT:    mov h2, v0.h[2]
; CHECK-NEXT:    fadd h0, h0, h3
; CHECK-NEXT:    fadd h0, h0, h2
; CHECK-NEXT:    fadd h0, h0, h1
; CHECK-NEXT:    ret
;
; CHECKNOFP16-LABEL: add_HalfH:
; CHECKNOFP16:       // %bb.0:
; CHECKNOFP16-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECKNOFP16-NEXT:    mov h3, v0.h[1]
; CHECKNOFP16-NEXT:    mov h1, v0.h[3]
; CHECKNOFP16-NEXT:    mov h2, v0.h[2]
; CHECKNOFP16-NEXT:    fcvt s0, h0
; CHECKNOFP16-NEXT:    fcvt s3, h3
; CHECKNOFP16-NEXT:    fadd s0, s0, s3
; CHECKNOFP16-NEXT:    fcvt h0, s0
; CHECKNOFP16-NEXT:    fcvt s2, h2
; CHECKNOFP16-NEXT:    fcvt s0, h0
; CHECKNOFP16-NEXT:    fadd s0, s0, s2
; CHECKNOFP16-NEXT:    fcvt h0, s0
; CHECKNOFP16-NEXT:    fcvt s0, h0
; CHECKNOFP16-NEXT:    fcvt s1, h1
; CHECKNOFP16-NEXT:    fadd s0, s0, s1
; CHECKNOFP16-NEXT:    fcvt h0, s0
; CHECKNOFP16-NEXT:    ret
  %r = call fast half @llvm.experimental.vector.reduce.v2.fadd.f16.v4f16(half 0.0, <4 x half> %bin.rdx)
  ret half %r
}


define half @add_H(<8 x half> %bin.rdx)  {
; CHECK-LABEL: add_H:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ext v1.16b, v0.16b, v0.16b, #8
; CHECK-NEXT:    fadd v0.4h, v0.4h, v1.4h
; CHECK-NEXT:    mov h1, v0.h[1]
; CHECK-NEXT:    mov h2, v0.h[2]
; CHECK-NEXT:    fadd h1, h0, h1
; CHECK-NEXT:    fadd h1, h1, h2
; CHECK-NEXT:    mov h0, v0.h[3]
; CHECK-NEXT:    fadd h0, h1, h0
; CHECK-NEXT:    ret
;
; CHECKNOFP16-LABEL: add_H:
; CHECKNOFP16:       // %bb.0:
; CHECKNOFP16-NEXT:    mov h7, v0.h[1]
; CHECKNOFP16-NEXT:    mov h1, v0.h[7]
; CHECKNOFP16-NEXT:    mov h2, v0.h[6]
; CHECKNOFP16-NEXT:    mov h3, v0.h[5]
; CHECKNOFP16-NEXT:    mov h4, v0.h[4]
; CHECKNOFP16-NEXT:    mov h5, v0.h[3]
; CHECKNOFP16-NEXT:    mov h6, v0.h[2]
; CHECKNOFP16-NEXT:    fcvt s0, h0
; CHECKNOFP16-NEXT:    fcvt s7, h7
; CHECKNOFP16-NEXT:    fadd s0, s0, s7
; CHECKNOFP16-NEXT:    fcvt h0, s0
; CHECKNOFP16-NEXT:    fcvt s6, h6
; CHECKNOFP16-NEXT:    fcvt s0, h0
; CHECKNOFP16-NEXT:    fadd s0, s0, s6
; CHECKNOFP16-NEXT:    fcvt h0, s0
; CHECKNOFP16-NEXT:    fcvt s5, h5
; CHECKNOFP16-NEXT:    fcvt s0, h0
; CHECKNOFP16-NEXT:    fadd s0, s0, s5
; CHECKNOFP16-NEXT:    fcvt h0, s0
; CHECKNOFP16-NEXT:    fcvt s4, h4
; CHECKNOFP16-NEXT:    fcvt s0, h0
; CHECKNOFP16-NEXT:    fadd s0, s0, s4
; CHECKNOFP16-NEXT:    fcvt h0, s0
; CHECKNOFP16-NEXT:    fcvt s3, h3
; CHECKNOFP16-NEXT:    fcvt s0, h0
; CHECKNOFP16-NEXT:    fadd s0, s0, s3
; CHECKNOFP16-NEXT:    fcvt h0, s0
; CHECKNOFP16-NEXT:    fcvt s2, h2
; CHECKNOFP16-NEXT:    fcvt s0, h0
; CHECKNOFP16-NEXT:    fadd s0, s0, s2
; CHECKNOFP16-NEXT:    fcvt h0, s0
; CHECKNOFP16-NEXT:    fcvt s0, h0
; CHECKNOFP16-NEXT:    fcvt s1, h1
; CHECKNOFP16-NEXT:    fadd s0, s0, s1
; CHECKNOFP16-NEXT:    fcvt h0, s0
; CHECKNOFP16-NEXT:    ret

  %r = call fast half @llvm.experimental.vector.reduce.v2.fadd.f16.v8f16(half 0.0, <8 x half> %bin.rdx)
  ret half %r
}

define float @add_S(<4 x float> %bin.rdx)  {
; CHECK-LABEL: add_S:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ext v1.16b, v0.16b, v0.16b, #8
; CHECK-NEXT:    fadd v0.2s, v0.2s, v1.2s
; CHECK-NEXT:    faddp s0, v0.2s
; CHECK-NEXT:    ret
;
; CHECKNOFP16-LABEL: add_S:
; CHECKNOFP16:       // %bb.0:
; CHECKNOFP16-NEXT:    ext v1.16b, v0.16b, v0.16b, #8
; CHECKNOFP16-NEXT:    fadd v0.2s, v0.2s, v1.2s
; CHECKNOFP16-NEXT:    faddp s0, v0.2s
; CHECKNOFP16-NEXT:    ret
  %r = call fast float @llvm.experimental.vector.reduce.v2.fadd.f32.v4f32(float 0.0, <4 x float> %bin.rdx)
  ret float %r
}

define double @add_D(<2 x double> %bin.rdx)  {
; CHECK-LABEL: add_D:
; CHECK:       // %bb.0:
; CHECK-NEXT:    faddp d0, v0.2d
; CHECK-NEXT:    ret
;
; CHECKNOFP16-LABEL: add_D:
; CHECKNOFP16:       // %bb.0:
; CHECKNOFP16-NEXT:    faddp d0, v0.2d
; CHECKNOFP16-NEXT:    ret
  %r = call fast double @llvm.experimental.vector.reduce.v2.fadd.f64.v2f64(double 0.0, <2 x double> %bin.rdx)
  ret double %r
}

define half @add_2H(<16 x half> %bin.rdx)  {
; CHECK-LABEL: add_2H:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fadd v0.8h, v0.8h, v1.8h
; CHECK-NEXT:    ext v1.16b, v0.16b, v0.16b, #8
; CHECK-NEXT:    fadd v0.4h, v0.4h, v1.4h
; CHECK-NEXT:    mov h1, v0.h[1]
; CHECK-NEXT:    mov h2, v0.h[2]
; CHECK-NEXT:    fadd h1, h0, h1
; CHECK-NEXT:    fadd h1, h1, h2
; CHECK-NEXT:    mov h0, v0.h[3]
; CHECK-NEXT:    fadd h0, h1, h0
; CHECK-NEXT:    ret
;
; CHECKNOFP16-LABEL: add_2H:
; CHECKNOFP16:       // %bb.0:
; CHECKNOFP16-NEXT:    mov h2, v1.h[1]
; CHECKNOFP16-NEXT:    mov h3, v0.h[1]
; CHECKNOFP16-NEXT:    mov h6, v1.h[2]
; CHECKNOFP16-NEXT:    mov h7, v0.h[2]
; CHECKNOFP16-NEXT:    mov h16, v1.h[3]
; CHECKNOFP16-NEXT:    mov h17, v0.h[3]
; CHECKNOFP16-NEXT:    fcvt s4, h1
; CHECKNOFP16-NEXT:    fcvt s5, h0
; CHECKNOFP16-NEXT:    fcvt s2, h2
; CHECKNOFP16-NEXT:    fcvt s3, h3
; CHECKNOFP16-NEXT:    fcvt s6, h6
; CHECKNOFP16-NEXT:    fcvt s7, h7
; CHECKNOFP16-NEXT:    fcvt s16, h16
; CHECKNOFP16-NEXT:    fcvt s17, h17
; CHECKNOFP16-NEXT:    fadd s4, s5, s4
; CHECKNOFP16-NEXT:    mov h5, v1.h[4]
; CHECKNOFP16-NEXT:    fadd s2, s3, s2
; CHECKNOFP16-NEXT:    mov h3, v0.h[4]
; CHECKNOFP16-NEXT:    fadd s6, s7, s6
; CHECKNOFP16-NEXT:    mov h7, v1.h[5]
; CHECKNOFP16-NEXT:    fadd s16, s17, s16
; CHECKNOFP16-NEXT:    mov h17, v0.h[5]
; CHECKNOFP16-NEXT:    fcvt s5, h5
; CHECKNOFP16-NEXT:    fcvt s3, h3
; CHECKNOFP16-NEXT:    fcvt s7, h7
; CHECKNOFP16-NEXT:    fcvt s17, h17
; CHECKNOFP16-NEXT:    fadd s3, s3, s5
; CHECKNOFP16-NEXT:    mov h5, v1.h[6]
; CHECKNOFP16-NEXT:    fadd s7, s17, s7
; CHECKNOFP16-NEXT:    mov h17, v0.h[6]
; CHECKNOFP16-NEXT:    mov h1, v1.h[7]
; CHECKNOFP16-NEXT:    mov h0, v0.h[7]
; CHECKNOFP16-NEXT:    fcvt s1, h1
; CHECKNOFP16-NEXT:    fcvt s0, h0
; CHECKNOFP16-NEXT:    fadd s0, s0, s1
; CHECKNOFP16-NEXT:    fcvt h1, s4
; CHECKNOFP16-NEXT:    fcvt h2, s2
; CHECKNOFP16-NEXT:    fcvt s1, h1
; CHECKNOFP16-NEXT:    fcvt s2, h2
; CHECKNOFP16-NEXT:    fadd s1, s1, s2
; CHECKNOFP16-NEXT:    fcvt h2, s6
; CHECKNOFP16-NEXT:    fcvt h1, s1
; CHECKNOFP16-NEXT:    fcvt s2, h2
; CHECKNOFP16-NEXT:    fcvt s1, h1
; CHECKNOFP16-NEXT:    fadd s1, s1, s2
; CHECKNOFP16-NEXT:    fcvt h2, s16
; CHECKNOFP16-NEXT:    fcvt h1, s1
; CHECKNOFP16-NEXT:    fcvt s2, h2
; CHECKNOFP16-NEXT:    fcvt s1, h1
; CHECKNOFP16-NEXT:    fadd s1, s1, s2
; CHECKNOFP16-NEXT:    fcvt h2, s3
; CHECKNOFP16-NEXT:    fcvt h1, s1
; CHECKNOFP16-NEXT:    fcvt s2, h2
; CHECKNOFP16-NEXT:    fcvt s1, h1
; CHECKNOFP16-NEXT:    fadd s1, s1, s2
; CHECKNOFP16-NEXT:    fcvt h3, s7
; CHECKNOFP16-NEXT:    fcvt h1, s1
; CHECKNOFP16-NEXT:    fcvt s5, h5
; CHECKNOFP16-NEXT:    fcvt s17, h17
; CHECKNOFP16-NEXT:    fcvt s3, h3
; CHECKNOFP16-NEXT:    fcvt s1, h1
; CHECKNOFP16-NEXT:    fadd s5, s17, s5
; CHECKNOFP16-NEXT:    fadd s1, s1, s3
; CHECKNOFP16-NEXT:    fcvt h4, s5
; CHECKNOFP16-NEXT:    fcvt h1, s1
; CHECKNOFP16-NEXT:    fcvt s4, h4
; CHECKNOFP16-NEXT:    fcvt s1, h1
; CHECKNOFP16-NEXT:    fadd s1, s1, s4
; CHECKNOFP16-NEXT:    fcvt h0, s0
; CHECKNOFP16-NEXT:    fcvt h1, s1
; CHECKNOFP16-NEXT:    fcvt s1, h1
; CHECKNOFP16-NEXT:    fcvt s0, h0
; CHECKNOFP16-NEXT:    fadd s0, s1, s0
; CHECKNOFP16-NEXT:    fcvt h0, s0
; CHECKNOFP16-NEXT:    ret
  %r = call fast half @llvm.experimental.vector.reduce.v2.fadd.f16.v16f16(half 0.0, <16 x half> %bin.rdx)
  ret half %r
}

define float @add_2S(<8 x float> %bin.rdx)  {
; CHECK-LABEL: add_2S:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fadd v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    ext v1.16b, v0.16b, v0.16b, #8
; CHECK-NEXT:    fadd v0.2s, v0.2s, v1.2s
; CHECK-NEXT:    faddp s0, v0.2s
; CHECK-NEXT:    ret
;
; CHECKNOFP16-LABEL: add_2S:
; CHECKNOFP16:       // %bb.0:
; CHECKNOFP16-NEXT:    fadd v0.4s, v0.4s, v1.4s
; CHECKNOFP16-NEXT:    ext v1.16b, v0.16b, v0.16b, #8
; CHECKNOFP16-NEXT:    fadd v0.2s, v0.2s, v1.2s
; CHECKNOFP16-NEXT:    faddp s0, v0.2s
; CHECKNOFP16-NEXT:    ret
  %r = call fast float @llvm.experimental.vector.reduce.v2.fadd.f32.v8f32(float 0.0, <8 x float> %bin.rdx)
  ret float %r
}

define double @add_2D(<4 x double> %bin.rdx)  {
; CHECK-LABEL: add_2D:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fadd v0.2d, v0.2d, v1.2d
; CHECK-NEXT:    faddp d0, v0.2d
; CHECK-NEXT:    ret
;
; CHECKNOFP16-LABEL: add_2D:
; CHECKNOFP16:       // %bb.0:
; CHECKNOFP16-NEXT:    fadd v0.2d, v0.2d, v1.2d
; CHECKNOFP16-NEXT:    faddp d0, v0.2d
; CHECKNOFP16-NEXT:    ret
  %r = call fast double @llvm.experimental.vector.reduce.v2.fadd.f64.v4f64(double 0.0, <4 x double> %bin.rdx)
  ret double %r
}

; Function Attrs: nounwind readnone
declare half @llvm.experimental.vector.reduce.v2.fadd.f16.v4f16(half, <4 x half>)
declare half @llvm.experimental.vector.reduce.v2.fadd.f16.v8f16(half, <8 x half>)
declare half @llvm.experimental.vector.reduce.v2.fadd.f16.v16f16(half, <16 x half>)
declare float @llvm.experimental.vector.reduce.v2.fadd.f32.v2f32(float, <2 x float>)
declare float @llvm.experimental.vector.reduce.v2.fadd.f32.v4f32(float, <4 x float>)
declare float @llvm.experimental.vector.reduce.v2.fadd.f32.v8f32(float, <8 x float>)
declare double @llvm.experimental.vector.reduce.v2.fadd.f64.v2f64(double, <2 x double>)
declare double @llvm.experimental.vector.reduce.v2.fadd.f64.v4f64(double, <4 x double>)
