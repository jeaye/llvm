; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64--linux-gnu -mattr=+sve < %s | FileCheck %s

define void @fptrunc2_f64_f32(<vscale x 2 x float> *%dst, <vscale x 2 x double> *%src) {
; CHECK-LABEL: fptrunc2_f64_f32:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    ld1d { z0.d }, p0/z, [x1]
; CHECK-NEXT:    fcvt z0.s, p0/m, z0.d
; CHECK-NEXT:    st1w { z0.d }, p0, [x0]
; CHECK-NEXT:    ret
entry:
  %0 = load <vscale x 2 x double>, <vscale x 2 x double>* %src, align 8
  %1 = fptrunc <vscale x 2 x double> %0 to <vscale x 2 x float>
  store <vscale x 2 x float> %1, <vscale x 2 x float>* %dst, align 4
  ret void
}

define void @fptrunc2_f64_f16(<vscale x 2 x half> *%dst, <vscale x 2 x double> *%src) {
; CHECK-LABEL: fptrunc2_f64_f16:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    ld1d { z0.d }, p0/z, [x1]
; CHECK-NEXT:    fcvt z0.h, p0/m, z0.d
; CHECK-NEXT:    st1h { z0.d }, p0, [x0]
; CHECK-NEXT:    ret
entry:
  %0 = load <vscale x 2 x double>, <vscale x 2 x double>* %src, align 8
  %1 = fptrunc <vscale x 2 x double> %0 to <vscale x 2 x half>
  store <vscale x 2 x half> %1, <vscale x 2 x half>* %dst, align 2
  ret void
}

define void @fptrunc4_f32_f16(<vscale x 4 x half> *%dst, <vscale x 4 x float> *%src) {
; CHECK-LABEL: fptrunc4_f32_f16:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    ld1w { z0.s }, p0/z, [x1]
; CHECK-NEXT:    fcvt z0.h, p0/m, z0.s
; CHECK-NEXT:    st1h { z0.s }, p0, [x0]
; CHECK-NEXT:    ret
entry:
  %0 = load <vscale x 4 x float>, <vscale x 4 x float>* %src, align 8
  %1 = fptrunc <vscale x 4 x float> %0 to <vscale x 4 x half>
  store <vscale x 4 x half> %1, <vscale x 4 x half>* %dst, align 2
  ret void
}

define void @fptrunc2_f32_f16(<vscale x 2 x half> *%dst, <vscale x 2 x float> *%src) {
; CHECK-LABEL: fptrunc2_f32_f16:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    ld1w { z0.d }, p0/z, [x1]
; CHECK-NEXT:    fcvt z0.h, p0/m, z0.s
; CHECK-NEXT:    st1h { z0.d }, p0, [x0]
; CHECK-NEXT:    ret
entry:
  %0 = load <vscale x 2 x float>, <vscale x 2 x float>* %src, align 8
  %1 = fptrunc <vscale x 2 x float> %0 to <vscale x 2 x half>
  store <vscale x 2 x half> %1, <vscale x 2 x half>* %dst, align 2
  ret void
}

define void @fptrunc8_f64_f16(<vscale x 8 x half> *%dst, <vscale x 8 x double> *%src) {
; CHECK-LABEL: fptrunc8_f64_f16:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    ld1d { z0.d }, p0/z, [x1]
; CHECK-NEXT:    ld1d { z1.d }, p0/z, [x1, #1, mul vl]
; CHECK-NEXT:    ld1d { z2.d }, p0/z, [x1, #2, mul vl]
; CHECK-NEXT:    ld1d { z3.d }, p0/z, [x1, #3, mul vl]
; CHECK-NEXT:    fcvt z0.h, p0/m, z0.d
; CHECK-NEXT:    fcvt z1.h, p0/m, z1.d
; CHECK-NEXT:    fcvt z2.h, p0/m, z2.d
; CHECK-NEXT:    fcvt z3.h, p0/m, z3.d
; CHECK-NEXT:    uzp1 z2.s, z2.s, z3.s
; CHECK-NEXT:    uzp1 z0.s, z0.s, z1.s
; CHECK-NEXT:    uzp1 z0.h, z0.h, z2.h
; CHECK-NEXT:    ptrue p0.h
; CHECK-NEXT:    st1h { z0.h }, p0, [x0]
; CHECK-NEXT:    ret
entry:
  %0 = load <vscale x 8 x double>, <vscale x 8 x double>* %src, align 8
  %1 = fptrunc <vscale x 8 x double> %0 to <vscale x 8 x half>
  store <vscale x 8 x half> %1, <vscale x 8 x half>* %dst, align 2
  ret void
}
