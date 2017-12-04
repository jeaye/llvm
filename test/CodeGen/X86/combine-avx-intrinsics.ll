; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=avx | FileCheck %s


define <4 x double> @test_x86_avx_blend_pd_256(<4 x double> %a0) {
; CHECK-LABEL: test_x86_avx_blend_pd_256:
; CHECK:       # %bb.0:
; CHECK-NEXT:    retq
  %1 = call <4 x double> @llvm.x86.avx.blend.pd.256(<4 x double> %a0, <4 x double> %a0, i32 7)
  ret <4 x double> %1
}

define <8 x float> @test_x86_avx_blend_ps_256(<8 x float> %a0) {
; CHECK-LABEL: test_x86_avx_blend_ps_256:
; CHECK:       # %bb.0:
; CHECK-NEXT:    retq
  %1 = call <8 x float> @llvm.x86.avx.blend.ps.256(<8 x float> %a0, <8 x float> %a0, i32 7)
  ret <8 x float> %1
}

define <4 x double> @test2_x86_avx_blend_pd_256(<4 x double> %a0, <4 x double> %a1) {
; CHECK-LABEL: test2_x86_avx_blend_pd_256:
; CHECK:       # %bb.0:
; CHECK-NEXT:    retq
  %1 = call <4 x double> @llvm.x86.avx.blend.pd.256(<4 x double> %a0, <4 x double> %a1, i32 0)
  ret <4 x double> %1
}

define <8 x float> @test2_x86_avx_blend_ps_256(<8 x float> %a0, <8 x float> %a1) {
; CHECK-LABEL: test2_x86_avx_blend_ps_256:
; CHECK:       # %bb.0:
; CHECK-NEXT:    retq
  %1 = call <8 x float> @llvm.x86.avx.blend.ps.256(<8 x float> %a0, <8 x float> %a1, i32 0)
  ret <8 x float> %1
}

define <4 x double> @test3_x86_avx_blend_pd_256(<4 x double> %a0, <4 x double> %a1) {
; CHECK-LABEL: test3_x86_avx_blend_pd_256:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovaps %ymm1, %ymm0
; CHECK-NEXT:    retq
  %1 = call <4 x double> @llvm.x86.avx.blend.pd.256(<4 x double> %a0, <4 x double> %a1, i32 -1)
  ret <4 x double> %1
}

define <8 x float> @test3_x86_avx_blend_ps_256(<8 x float> %a0, <8 x float> %a1) {
; CHECK-LABEL: test3_x86_avx_blend_ps_256:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovaps %ymm1, %ymm0
; CHECK-NEXT:    retq
  %1 = call <8 x float> @llvm.x86.avx.blend.ps.256(<8 x float> %a0, <8 x float> %a1, i32 -1)
  ret <8 x float> %1
}

declare <4 x double> @llvm.x86.avx.blend.pd.256(<4 x double>, <4 x double>, i32)
declare <8 x float> @llvm.x86.avx.blend.ps.256(<8 x float>, <8 x float>, i32)

