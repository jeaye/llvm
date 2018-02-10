; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse2 | FileCheck %s --check-prefix=ALL --check-prefix=SSE --check-prefix=SSE2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.1 | FileCheck %s --check-prefix=ALL --check-prefix=SSE --check-prefix=SSE41
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.2 | FileCheck %s --check-prefix=ALL --check-prefix=SSE --check-prefix=SSE42
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefix=ALL --check-prefix=AVX --check-prefix=AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefix=ALL --check-prefix=AVX --check-prefix=AVX2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f | FileCheck %s --check-prefix=ALL --check-prefix=AVX --check-prefix=AVX512 --check-prefix=AVX512F
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512bw | FileCheck %s --check-prefix=ALL --check-prefix=AVX --check-prefix=AVX512 --check-prefix=AVX512BW

define <16 x i8> @test_v16i8_nosignbit(<16 x i8> %a, <16 x i8> %b) {
; SSE2-LABEL: test_v16i8_nosignbit:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movdqa {{.*#+}} xmm2 = [15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15]
; SSE2-NEXT:    pand %xmm2, %xmm0
; SSE2-NEXT:    pand %xmm2, %xmm1
; SSE2-NEXT:    movdqa %xmm0, %xmm2
; SSE2-NEXT:    pcmpgtb %xmm1, %xmm2
; SSE2-NEXT:    pand %xmm2, %xmm0
; SSE2-NEXT:    pandn %xmm1, %xmm2
; SSE2-NEXT:    por %xmm0, %xmm2
; SSE2-NEXT:    movdqa %xmm2, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_v16i8_nosignbit:
; SSE41:       # %bb.0:
; SSE41-NEXT:    movdqa {{.*#+}} xmm2 = [15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15]
; SSE41-NEXT:    pand %xmm2, %xmm0
; SSE41-NEXT:    pand %xmm2, %xmm1
; SSE41-NEXT:    pmaxsb %xmm1, %xmm0
; SSE41-NEXT:    retq
;
; SSE42-LABEL: test_v16i8_nosignbit:
; SSE42:       # %bb.0:
; SSE42-NEXT:    movdqa {{.*#+}} xmm2 = [15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15]
; SSE42-NEXT:    pand %xmm2, %xmm0
; SSE42-NEXT:    pand %xmm2, %xmm1
; SSE42-NEXT:    pmaxsb %xmm1, %xmm0
; SSE42-NEXT:    retq
;
; AVX-LABEL: test_v16i8_nosignbit:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovdqa {{.*#+}} xmm2 = [15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15]
; AVX-NEXT:    vpand %xmm2, %xmm0, %xmm0
; AVX-NEXT:    vpand %xmm2, %xmm1, %xmm1
; AVX-NEXT:    vpmaxsb %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = and <16 x i8> %a, <i8 15, i8 15, i8 15, i8 15, i8 15, i8 15, i8 15, i8 15, i8 15, i8 15, i8 15, i8 15, i8 15, i8 15, i8 15, i8 15>
  %2 = and <16 x i8> %b, <i8 15, i8 15, i8 15, i8 15, i8 15, i8 15, i8 15, i8 15, i8 15, i8 15, i8 15, i8 15, i8 15, i8 15, i8 15, i8 15>
  %3 = icmp sgt <16 x i8> %1, %2
  %4 = select <16 x i1> %3, <16 x i8> %1, <16 x i8> %2
  ret <16 x i8> %4
}
