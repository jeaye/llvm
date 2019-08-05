; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown | FileCheck %s --check-prefix=SSE --check-prefix=SSE2 --check-prefix=SSE2-PROMOTE
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -x86-experimental-vector-widening-legalization | FileCheck %s --check-prefix=SSE --check-prefix=SSE2 --check-prefix=SSE2-WIDEN
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.1 | FileCheck %s --check-prefix=SSE --check-prefix=SSE41 --check-prefix=SSE41-PROMOTE
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.1 -x86-experimental-vector-widening-legalization | FileCheck %s --check-prefix=SSE --check-prefix=SSE41 --check-prefix=SSE41-WIDEN
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefix=AVX --check-prefix=AVX2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f | FileCheck %s --check-prefix=AVX --check-prefix=AVX512 --check-prefix=AVX512F
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512bw | FileCheck %s --check-prefix=AVX --check-prefix=AVX512 --check-prefix=AVX512BW

define <4 x i16> @mulhuw_v4i16(<4 x i16> %a, <4 x i16> %b) {
; SSE-LABEL: mulhuw_v4i16:
; SSE:       # %bb.0:
; SSE-NEXT:    pmulhuw %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: mulhuw_v4i16:
; AVX:       # %bb.0:
; AVX-NEXT:    vpmulhuw %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %a1 = zext <4 x i16> %a to <4 x i32>
  %b1 = zext <4 x i16> %b to <4 x i32>
  %c = mul <4 x i32> %a1, %b1
  %d = lshr <4 x i32> %c, <i32 16, i32 16, i32 16, i32 16>
  %e = trunc <4 x i32> %d to <4 x i16>
  ret <4 x i16> %e
}

define <4 x i16> @mulhw_v4i16(<4 x i16> %a, <4 x i16> %b) {
; SSE-LABEL: mulhw_v4i16:
; SSE:       # %bb.0:
; SSE-NEXT:    pmulhw %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: mulhw_v4i16:
; AVX:       # %bb.0:
; AVX-NEXT:    vpmulhw %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %a1 = sext <4 x i16> %a to <4 x i32>
  %b1 = sext <4 x i16> %b to <4 x i32>
  %c = mul <4 x i32> %a1, %b1
  %d = lshr <4 x i32> %c, <i32 16, i32 16, i32 16, i32 16>
  %e = trunc <4 x i32> %d to <4 x i16>
  ret <4 x i16> %e
}

define <8 x i16> @mulhuw_v8i16(<8 x i16> %a, <8 x i16> %b) {
; SSE-LABEL: mulhuw_v8i16:
; SSE:       # %bb.0:
; SSE-NEXT:    pmulhuw %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: mulhuw_v8i16:
; AVX:       # %bb.0:
; AVX-NEXT:    vpmulhuw %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %a1 = zext <8 x i16> %a to <8 x i32>
  %b1 = zext <8 x i16> %b to <8 x i32>
  %c = mul <8 x i32> %a1, %b1
  %d = lshr <8 x i32> %c, <i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16>
  %e = trunc <8 x i32> %d to <8 x i16>
  ret <8 x i16> %e
}

define <8 x i16> @mulhw_v8i16(<8 x i16> %a, <8 x i16> %b) {
; SSE-LABEL: mulhw_v8i16:
; SSE:       # %bb.0:
; SSE-NEXT:    pmulhw %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: mulhw_v8i16:
; AVX:       # %bb.0:
; AVX-NEXT:    vpmulhw %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %a1 = sext <8 x i16> %a to <8 x i32>
  %b1 = sext <8 x i16> %b to <8 x i32>
  %c = mul <8 x i32> %a1, %b1
  %d = lshr <8 x i32> %c, <i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16>
  %e = trunc <8 x i32> %d to <8 x i16>
  ret <8 x i16> %e
}

define <16 x i16> @mulhuw_v16i16(<16 x i16> %a, <16 x i16> %b) {
; SSE-LABEL: mulhuw_v16i16:
; SSE:       # %bb.0:
; SSE-NEXT:    pmulhuw %xmm2, %xmm0
; SSE-NEXT:    pmulhuw %xmm3, %xmm1
; SSE-NEXT:    retq
;
; AVX-LABEL: mulhuw_v16i16:
; AVX:       # %bb.0:
; AVX-NEXT:    vpmulhuw %ymm1, %ymm0, %ymm0
; AVX-NEXT:    retq
  %a1 = zext <16 x i16> %a to <16 x i32>
  %b1 = zext <16 x i16> %b to <16 x i32>
  %c = mul <16 x i32> %a1, %b1
  %d = lshr <16 x i32> %c, <i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16>
  %e = trunc <16 x i32> %d to <16 x i16>
  ret <16 x i16> %e
}

define <16 x i16> @mulhw_v16i16(<16 x i16> %a, <16 x i16> %b) {
; SSE-LABEL: mulhw_v16i16:
; SSE:       # %bb.0:
; SSE-NEXT:    pmulhw %xmm2, %xmm0
; SSE-NEXT:    pmulhw %xmm3, %xmm1
; SSE-NEXT:    retq
;
; AVX-LABEL: mulhw_v16i16:
; AVX:       # %bb.0:
; AVX-NEXT:    vpmulhw %ymm1, %ymm0, %ymm0
; AVX-NEXT:    retq
  %a1 = sext <16 x i16> %a to <16 x i32>
  %b1 = sext <16 x i16> %b to <16 x i32>
  %c = mul <16 x i32> %a1, %b1
  %d = lshr <16 x i32> %c, <i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16>
  %e = trunc <16 x i32> %d to <16 x i16>
  ret <16 x i16> %e
}

define <32 x i16> @mulhuw_v32i16(<32 x i16> %a, <32 x i16> %b) {
; SSE-LABEL: mulhuw_v32i16:
; SSE:       # %bb.0:
; SSE-NEXT:    pmulhuw %xmm4, %xmm0
; SSE-NEXT:    pmulhuw %xmm5, %xmm1
; SSE-NEXT:    pmulhuw %xmm6, %xmm2
; SSE-NEXT:    pmulhuw %xmm7, %xmm3
; SSE-NEXT:    retq
;
; AVX2-LABEL: mulhuw_v32i16:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpmulhuw %ymm2, %ymm0, %ymm0
; AVX2-NEXT:    vpmulhuw %ymm3, %ymm1, %ymm1
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: mulhuw_v32i16:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpmulhuw %ymm2, %ymm0, %ymm0
; AVX512F-NEXT:    vpmulhuw %ymm3, %ymm1, %ymm1
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: mulhuw_v32i16:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpmulhuw %zmm1, %zmm0, %zmm0
; AVX512BW-NEXT:    retq
  %a1 = zext <32 x i16> %a to <32 x i32>
  %b1 = zext <32 x i16> %b to <32 x i32>
  %c = mul <32 x i32> %a1, %b1
  %d = lshr <32 x i32> %c, <i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16>
  %e = trunc <32 x i32> %d to <32 x i16>
  ret <32 x i16> %e
}

define <32 x i16> @mulhw_v32i16(<32 x i16> %a, <32 x i16> %b) {
; SSE-LABEL: mulhw_v32i16:
; SSE:       # %bb.0:
; SSE-NEXT:    pmulhw %xmm4, %xmm0
; SSE-NEXT:    pmulhw %xmm5, %xmm1
; SSE-NEXT:    pmulhw %xmm6, %xmm2
; SSE-NEXT:    pmulhw %xmm7, %xmm3
; SSE-NEXT:    retq
;
; AVX2-LABEL: mulhw_v32i16:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpmulhw %ymm2, %ymm0, %ymm0
; AVX2-NEXT:    vpmulhw %ymm3, %ymm1, %ymm1
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: mulhw_v32i16:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpmulhw %ymm2, %ymm0, %ymm0
; AVX512F-NEXT:    vpmulhw %ymm3, %ymm1, %ymm1
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: mulhw_v32i16:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpmulhw %zmm1, %zmm0, %zmm0
; AVX512BW-NEXT:    retq
  %a1 = sext <32 x i16> %a to <32 x i32>
  %b1 = sext <32 x i16> %b to <32 x i32>
  %c = mul <32 x i32> %a1, %b1
  %d = lshr <32 x i32> %c, <i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16>
  %e = trunc <32 x i32> %d to <32 x i16>
  ret <32 x i16> %e
}

define <64 x i16> @mulhuw_v64i16(<64 x i16> %a, <64 x i16> %b) {
; SSE-LABEL: mulhuw_v64i16:
; SSE:       # %bb.0:
; SSE-NEXT:    movq %rdi, %rax
; SSE-NEXT:    pmulhuw {{[0-9]+}}(%rsp), %xmm0
; SSE-NEXT:    pmulhuw {{[0-9]+}}(%rsp), %xmm1
; SSE-NEXT:    pmulhuw {{[0-9]+}}(%rsp), %xmm2
; SSE-NEXT:    pmulhuw {{[0-9]+}}(%rsp), %xmm3
; SSE-NEXT:    pmulhuw {{[0-9]+}}(%rsp), %xmm4
; SSE-NEXT:    pmulhuw {{[0-9]+}}(%rsp), %xmm5
; SSE-NEXT:    pmulhuw {{[0-9]+}}(%rsp), %xmm6
; SSE-NEXT:    pmulhuw {{[0-9]+}}(%rsp), %xmm7
; SSE-NEXT:    movdqa %xmm7, 112(%rdi)
; SSE-NEXT:    movdqa %xmm6, 96(%rdi)
; SSE-NEXT:    movdqa %xmm5, 80(%rdi)
; SSE-NEXT:    movdqa %xmm4, 64(%rdi)
; SSE-NEXT:    movdqa %xmm3, 48(%rdi)
; SSE-NEXT:    movdqa %xmm2, 32(%rdi)
; SSE-NEXT:    movdqa %xmm1, 16(%rdi)
; SSE-NEXT:    movdqa %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX2-LABEL: mulhuw_v64i16:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpmulhuw %ymm4, %ymm0, %ymm0
; AVX2-NEXT:    vpmulhuw %ymm5, %ymm1, %ymm1
; AVX2-NEXT:    vpmulhuw %ymm6, %ymm2, %ymm2
; AVX2-NEXT:    vpmulhuw %ymm7, %ymm3, %ymm3
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: mulhuw_v64i16:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpmulhuw %ymm4, %ymm0, %ymm0
; AVX512F-NEXT:    vpmulhuw %ymm5, %ymm1, %ymm1
; AVX512F-NEXT:    vpmulhuw %ymm6, %ymm2, %ymm2
; AVX512F-NEXT:    vpmulhuw %ymm7, %ymm3, %ymm3
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: mulhuw_v64i16:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpmulhuw %zmm2, %zmm0, %zmm0
; AVX512BW-NEXT:    vpmulhuw %zmm3, %zmm1, %zmm1
; AVX512BW-NEXT:    retq
  %a1 = zext <64 x i16> %a to <64 x i32>
  %b1 = zext <64 x i16> %b to <64 x i32>
  %c = mul <64 x i32> %a1, %b1
  %d = lshr <64 x i32> %c, <i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16>
  %e = trunc <64 x i32> %d to <64 x i16>
  ret <64 x i16> %e
}

define <64 x i16> @mulhw_v64i16(<64 x i16> %a, <64 x i16> %b) {
; SSE-LABEL: mulhw_v64i16:
; SSE:       # %bb.0:
; SSE-NEXT:    movq %rdi, %rax
; SSE-NEXT:    pmulhw {{[0-9]+}}(%rsp), %xmm0
; SSE-NEXT:    pmulhw {{[0-9]+}}(%rsp), %xmm1
; SSE-NEXT:    pmulhw {{[0-9]+}}(%rsp), %xmm2
; SSE-NEXT:    pmulhw {{[0-9]+}}(%rsp), %xmm3
; SSE-NEXT:    pmulhw {{[0-9]+}}(%rsp), %xmm4
; SSE-NEXT:    pmulhw {{[0-9]+}}(%rsp), %xmm5
; SSE-NEXT:    pmulhw {{[0-9]+}}(%rsp), %xmm6
; SSE-NEXT:    pmulhw {{[0-9]+}}(%rsp), %xmm7
; SSE-NEXT:    movdqa %xmm7, 112(%rdi)
; SSE-NEXT:    movdqa %xmm6, 96(%rdi)
; SSE-NEXT:    movdqa %xmm5, 80(%rdi)
; SSE-NEXT:    movdqa %xmm4, 64(%rdi)
; SSE-NEXT:    movdqa %xmm3, 48(%rdi)
; SSE-NEXT:    movdqa %xmm2, 32(%rdi)
; SSE-NEXT:    movdqa %xmm1, 16(%rdi)
; SSE-NEXT:    movdqa %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX2-LABEL: mulhw_v64i16:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpmulhw %ymm4, %ymm0, %ymm0
; AVX2-NEXT:    vpmulhw %ymm5, %ymm1, %ymm1
; AVX2-NEXT:    vpmulhw %ymm6, %ymm2, %ymm2
; AVX2-NEXT:    vpmulhw %ymm7, %ymm3, %ymm3
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: mulhw_v64i16:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpmulhw %ymm4, %ymm0, %ymm0
; AVX512F-NEXT:    vpmulhw %ymm5, %ymm1, %ymm1
; AVX512F-NEXT:    vpmulhw %ymm6, %ymm2, %ymm2
; AVX512F-NEXT:    vpmulhw %ymm7, %ymm3, %ymm3
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: mulhw_v64i16:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpmulhw %zmm2, %zmm0, %zmm0
; AVX512BW-NEXT:    vpmulhw %zmm3, %zmm1, %zmm1
; AVX512BW-NEXT:    retq
  %a1 = sext <64 x i16> %a to <64 x i32>
  %b1 = sext <64 x i16> %b to <64 x i32>
  %c = mul <64 x i32> %a1, %b1
  %d = lshr <64 x i32> %c, <i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16>
  %e = trunc <64 x i32> %d to <64 x i16>
  ret <64 x i16> %e
}
