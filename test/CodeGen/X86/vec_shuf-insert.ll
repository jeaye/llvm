; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-linux -mcpu=corei7-avx | FileCheck %s

; These tests check that an insert_subvector which replaces one of the halves
; of a concat_vectors is optimized into a single vinsertf128.


declare <8 x float> @llvm.x86.avx.vinsertf128.ps.256(<8 x float>, <4 x float>, i8)

define <8 x float> @lower_half(<4 x float> %v1, <4 x float> %v2, <4 x float> %v3) {
; CHECK-LABEL: lower_half:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $xmm2 killed $xmm2 def $ymm2
; CHECK-NEXT:    vinsertf128 $1, %xmm1, %ymm2, %ymm0
; CHECK-NEXT:    retq
  %1 = shufflevector <4 x float> %v1, <4 x float> %v2, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %2 = tail call <8 x float> @llvm.x86.avx.vinsertf128.ps.256(<8 x float> %1, <4 x float> %v3, i8 0)
  ret <8 x float> %2

}

define <8 x float> @upper_half(<4 x float> %v1, <4 x float> %v2, <4 x float> %v3) {
; CHECK-LABEL: upper_half:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $xmm0 killed $xmm0 def $ymm0
; CHECK-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; CHECK-NEXT:    retq
  %1 = shufflevector <4 x float> %v1, <4 x float> %v2, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %2 = tail call <8 x float> @llvm.x86.avx.vinsertf128.ps.256(<8 x float> %1, <4 x float> %v3, i8 1)
  ret <8 x float> %2

}
