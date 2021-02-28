; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse2 | FileCheck %s --check-prefix=SSE
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+xop  | FileCheck %s --check-prefix=XOP
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx  | FileCheck %s --check-prefixes=AVX,AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefixes=AVX,AVX2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f | FileCheck %s --check-prefixes=AVX512,AVX512F
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512vl | FileCheck %s --check-prefixes=AVX512,AVX512VL

;
; 128-bit vectors
;

define <2 x i64> @bitselect_v2i64_rr(<2 x i64>, <2 x i64>) {
; SSE-LABEL: bitselect_v2i64_rr:
; SSE:       # %bb.0:
; SSE-NEXT:    andps {{.*}}(%rip), %xmm0
; SSE-NEXT:    andps {{.*}}(%rip), %xmm1
; SSE-NEXT:    orps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; XOP-LABEL: bitselect_v2i64_rr:
; XOP:       # %bb.0:
; XOP-NEXT:    vpcmov {{.*}}(%rip), %xmm0, %xmm1, %xmm0
; XOP-NEXT:    retq
;
; AVX-LABEL: bitselect_v2i64_rr:
; AVX:       # %bb.0:
; AVX-NEXT:    vandps {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    vandps {{.*}}(%rip), %xmm1, %xmm1
; AVX-NEXT:    vorps %xmm0, %xmm1, %xmm0
; AVX-NEXT:    retq
;
; AVX512F-LABEL: bitselect_v2i64_rr:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vandps {{.*}}(%rip), %xmm0, %xmm0
; AVX512F-NEXT:    vandps {{.*}}(%rip), %xmm1, %xmm1
; AVX512F-NEXT:    vorps %xmm0, %xmm1, %xmm0
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: bitselect_v2i64_rr:
; AVX512VL:       # %bb.0:
; AVX512VL-NEXT:    vpternlogq $216, {{.*}}(%rip), %xmm1, %xmm0
; AVX512VL-NEXT:    retq
  %3 = and <2 x i64> %0, <i64 4294967296, i64 12884901890>
  %4 = and <2 x i64> %1, <i64 -4294967297, i64 -12884901891>
  %5 = or <2 x i64> %4, %3
  ret <2 x i64> %5
}

define <2 x i64> @bitselect_v2i64_rm(<2 x i64>, <2 x i64>* nocapture readonly) {
; SSE-LABEL: bitselect_v2i64_rm:
; SSE:       # %bb.0:
; SSE-NEXT:    movaps (%rdi), %xmm1
; SSE-NEXT:    andps {{.*}}(%rip), %xmm0
; SSE-NEXT:    andps {{.*}}(%rip), %xmm1
; SSE-NEXT:    orps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; XOP-LABEL: bitselect_v2i64_rm:
; XOP:       # %bb.0:
; XOP-NEXT:    vmovdqa (%rdi), %xmm1
; XOP-NEXT:    vpcmov {{.*}}(%rip), %xmm0, %xmm1, %xmm0
; XOP-NEXT:    retq
;
; AVX-LABEL: bitselect_v2i64_rm:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovaps (%rdi), %xmm1
; AVX-NEXT:    vandps {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    vandps {{.*}}(%rip), %xmm1, %xmm1
; AVX-NEXT:    vorps %xmm0, %xmm1, %xmm0
; AVX-NEXT:    retq
;
; AVX512F-LABEL: bitselect_v2i64_rm:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vmovaps (%rdi), %xmm1
; AVX512F-NEXT:    vandps {{.*}}(%rip), %xmm0, %xmm0
; AVX512F-NEXT:    vandps {{.*}}(%rip), %xmm1, %xmm1
; AVX512F-NEXT:    vorps %xmm0, %xmm1, %xmm0
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: bitselect_v2i64_rm:
; AVX512VL:       # %bb.0:
; AVX512VL-NEXT:    vmovdqa (%rdi), %xmm1
; AVX512VL-NEXT:    vpternlogq $216, {{.*}}(%rip), %xmm1, %xmm0
; AVX512VL-NEXT:    retq
  %3 = load <2 x i64>, <2 x i64>* %1
  %4 = and <2 x i64> %0, <i64 8589934593, i64 3>
  %5 = and <2 x i64> %3, <i64 -8589934594, i64 -4>
  %6 = or <2 x i64> %5, %4
  ret <2 x i64> %6
}

define <2 x i64> @bitselect_v2i64_mr(<2 x i64>* nocapture readonly, <2 x i64>) {
; SSE-LABEL: bitselect_v2i64_mr:
; SSE:       # %bb.0:
; SSE-NEXT:    movaps (%rdi), %xmm1
; SSE-NEXT:    andps {{.*}}(%rip), %xmm1
; SSE-NEXT:    andps {{.*}}(%rip), %xmm0
; SSE-NEXT:    orps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; XOP-LABEL: bitselect_v2i64_mr:
; XOP:       # %bb.0:
; XOP-NEXT:    vmovdqa (%rdi), %xmm1
; XOP-NEXT:    vpcmov {{.*}}(%rip), %xmm0, %xmm1, %xmm0
; XOP-NEXT:    retq
;
; AVX-LABEL: bitselect_v2i64_mr:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovaps (%rdi), %xmm1
; AVX-NEXT:    vandps {{.*}}(%rip), %xmm1, %xmm1
; AVX-NEXT:    vandps {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    vorps %xmm0, %xmm1, %xmm0
; AVX-NEXT:    retq
;
; AVX512F-LABEL: bitselect_v2i64_mr:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vmovaps (%rdi), %xmm1
; AVX512F-NEXT:    vandps {{.*}}(%rip), %xmm1, %xmm1
; AVX512F-NEXT:    vandps {{.*}}(%rip), %xmm0, %xmm0
; AVX512F-NEXT:    vorps %xmm0, %xmm1, %xmm0
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: bitselect_v2i64_mr:
; AVX512VL:       # %bb.0:
; AVX512VL-NEXT:    vmovdqa (%rdi), %xmm1
; AVX512VL-NEXT:    vpternlogq $216, {{.*}}(%rip), %xmm1, %xmm0
; AVX512VL-NEXT:    retq
  %3 = load <2 x i64>, <2 x i64>* %0
  %4 = and <2 x i64> %3, <i64 12884901890, i64 4294967296>
  %5 = and <2 x i64> %1, <i64 -12884901891, i64 -4294967297>
  %6 = or <2 x i64> %4, %5
  ret <2 x i64> %6
}

define <2 x i64> @bitselect_v2i64_mm(<2 x i64>* nocapture readonly, <2 x i64>* nocapture readonly) {
; SSE-LABEL: bitselect_v2i64_mm:
; SSE:       # %bb.0:
; SSE-NEXT:    movaps (%rdi), %xmm1
; SSE-NEXT:    movaps (%rsi), %xmm0
; SSE-NEXT:    andps {{.*}}(%rip), %xmm1
; SSE-NEXT:    andps {{.*}}(%rip), %xmm0
; SSE-NEXT:    orps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; XOP-LABEL: bitselect_v2i64_mm:
; XOP:       # %bb.0:
; XOP-NEXT:    vmovdqa (%rsi), %xmm0
; XOP-NEXT:    vmovdqa {{.*#+}} xmm1 = [18446744073709551612,18446744065119617022]
; XOP-NEXT:    vpcmov %xmm1, (%rdi), %xmm0, %xmm0
; XOP-NEXT:    retq
;
; AVX-LABEL: bitselect_v2i64_mm:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovaps (%rdi), %xmm0
; AVX-NEXT:    vmovaps (%rsi), %xmm1
; AVX-NEXT:    vandps {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    vandps {{.*}}(%rip), %xmm1, %xmm1
; AVX-NEXT:    vorps %xmm0, %xmm1, %xmm0
; AVX-NEXT:    retq
;
; AVX512F-LABEL: bitselect_v2i64_mm:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vmovaps (%rdi), %xmm0
; AVX512F-NEXT:    vmovaps (%rsi), %xmm1
; AVX512F-NEXT:    vandps {{.*}}(%rip), %xmm0, %xmm0
; AVX512F-NEXT:    vandps {{.*}}(%rip), %xmm1, %xmm1
; AVX512F-NEXT:    vorps %xmm0, %xmm1, %xmm0
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: bitselect_v2i64_mm:
; AVX512VL:       # %bb.0:
; AVX512VL-NEXT:    vmovdqa (%rsi), %xmm1
; AVX512VL-NEXT:    vmovdqa {{.*#+}} xmm0 = [18446744073709551612,18446744065119617022]
; AVX512VL-NEXT:    vpternlogq $202, (%rdi), %xmm1, %xmm0
; AVX512VL-NEXT:    retq
  %3 = load <2 x i64>, <2 x i64>* %0
  %4 = load <2 x i64>, <2 x i64>* %1
  %5 = and <2 x i64> %3, <i64 3, i64 8589934593>
  %6 = and <2 x i64> %4, <i64 -4, i64 -8589934594>
  %7 = or <2 x i64> %6, %5
  ret <2 x i64> %7
}

define <2 x i64> @bitselect_v2i64_broadcast_rrr(<2 x i64> %a0, <2 x i64> %a1, i64 %a2) {
; SSE-LABEL: bitselect_v2i64_broadcast_rrr:
; SSE:       # %bb.0:
; SSE-NEXT:    movq %rdi, %xmm2
; SSE-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[0,1,0,1]
; SSE-NEXT:    pand %xmm2, %xmm0
; SSE-NEXT:    pandn %xmm1, %xmm2
; SSE-NEXT:    por %xmm2, %xmm0
; SSE-NEXT:    retq
;
; XOP-LABEL: bitselect_v2i64_broadcast_rrr:
; XOP:       # %bb.0:
; XOP-NEXT:    vmovq %rdi, %xmm2
; XOP-NEXT:    vpshufd {{.*#+}} xmm2 = xmm2[0,1,0,1]
; XOP-NEXT:    vpcmov %xmm2, %xmm1, %xmm0, %xmm0
; XOP-NEXT:    retq
;
; AVX1-LABEL: bitselect_v2i64_broadcast_rrr:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vmovq %rdi, %xmm2
; AVX1-NEXT:    vpshufd {{.*#+}} xmm2 = xmm2[0,1,0,1]
; AVX1-NEXT:    vpand %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vpandn %xmm1, %xmm2, %xmm1
; AVX1-NEXT:    vpor %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: bitselect_v2i64_broadcast_rrr:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovq %rdi, %xmm2
; AVX2-NEXT:    vpbroadcastq %xmm2, %xmm2
; AVX2-NEXT:    vpand %xmm2, %xmm0, %xmm0
; AVX2-NEXT:    vpandn %xmm1, %xmm2, %xmm1
; AVX2-NEXT:    vpor %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: bitselect_v2i64_broadcast_rrr:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vmovq %rdi, %xmm2
; AVX512F-NEXT:    vpbroadcastq %xmm2, %xmm2
; AVX512F-NEXT:    vpand %xmm2, %xmm0, %xmm0
; AVX512F-NEXT:    vpandn %xmm1, %xmm2, %xmm1
; AVX512F-NEXT:    vpor %xmm1, %xmm0, %xmm0
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: bitselect_v2i64_broadcast_rrr:
; AVX512VL:       # %bb.0:
; AVX512VL-NEXT:    vpbroadcastq %rdi, %xmm2
; AVX512VL-NEXT:    vpternlogq $226, %xmm1, %xmm2, %xmm0
; AVX512VL-NEXT:    retq
  %1 = insertelement <2 x i64> undef, i64 %a2, i32 0
  %2 = shufflevector <2 x i64> %1, <2 x i64> undef, <2 x i32> zeroinitializer
  %3 = xor <2 x i64> %1, <i64 -1, i64 undef>
  %4 = shufflevector <2 x i64> %3, <2 x i64> undef, <2 x i32> zeroinitializer
  %5 = and <2 x i64> %a0, %2
  %6 = and <2 x i64> %a1, %4
  %7 = or <2 x i64> %5, %6
  ret <2 x i64> %7
}

define <2 x i64> @bitselect_v2i64_broadcast_rrm(<2 x i64> %a0, <2 x i64> %a1, i64* %p2) {
; SSE-LABEL: bitselect_v2i64_broadcast_rrm:
; SSE:       # %bb.0:
; SSE-NEXT:    movq {{.*#+}} xmm2 = mem[0],zero
; SSE-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[0,1,0,1]
; SSE-NEXT:    pand %xmm2, %xmm0
; SSE-NEXT:    pandn %xmm1, %xmm2
; SSE-NEXT:    por %xmm2, %xmm0
; SSE-NEXT:    retq
;
; XOP-LABEL: bitselect_v2i64_broadcast_rrm:
; XOP:       # %bb.0:
; XOP-NEXT:    vmovddup {{.*#+}} xmm2 = mem[0,0]
; XOP-NEXT:    vpcmov %xmm2, %xmm1, %xmm0, %xmm0
; XOP-NEXT:    retq
;
; AVX-LABEL: bitselect_v2i64_broadcast_rrm:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovddup {{.*#+}} xmm2 = mem[0,0]
; AVX-NEXT:    vandps %xmm2, %xmm0, %xmm0
; AVX-NEXT:    vandnps %xmm1, %xmm2, %xmm1
; AVX-NEXT:    vorps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
;
; AVX512F-LABEL: bitselect_v2i64_broadcast_rrm:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vmovddup {{.*#+}} xmm2 = mem[0,0]
; AVX512F-NEXT:    vandps %xmm2, %xmm0, %xmm0
; AVX512F-NEXT:    vandnps %xmm1, %xmm2, %xmm1
; AVX512F-NEXT:    vorps %xmm1, %xmm0, %xmm0
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: bitselect_v2i64_broadcast_rrm:
; AVX512VL:       # %bb.0:
; AVX512VL-NEXT:    vpternlogq $228, (%rdi){1to2}, %xmm1, %xmm0
; AVX512VL-NEXT:    retq
  %a2 = load i64, i64* %p2
  %1 = insertelement <2 x i64> undef, i64 %a2, i32 0
  %2 = shufflevector <2 x i64> %1, <2 x i64> undef, <2 x i32> zeroinitializer
  %3 = xor <2 x i64> %1, <i64 -1, i64 undef>
  %4 = shufflevector <2 x i64> %3, <2 x i64> undef, <2 x i32> zeroinitializer
  %5 = and <2 x i64> %a0, %2
  %6 = and <2 x i64> %a1, %4
  %7 = or <2 x i64> %5, %6
  ret <2 x i64> %7
}

;
; 256-bit vectors
;

define <4 x i64> @bitselect_v4i64_rr(<4 x i64>, <4 x i64>) {
; SSE-LABEL: bitselect_v4i64_rr:
; SSE:       # %bb.0:
; SSE-NEXT:    andps {{.*}}(%rip), %xmm1
; SSE-NEXT:    andps {{.*}}(%rip), %xmm0
; SSE-NEXT:    andps {{.*}}(%rip), %xmm3
; SSE-NEXT:    orps %xmm3, %xmm1
; SSE-NEXT:    andps {{.*}}(%rip), %xmm2
; SSE-NEXT:    orps %xmm2, %xmm0
; SSE-NEXT:    retq
;
; XOP-LABEL: bitselect_v4i64_rr:
; XOP:       # %bb.0:
; XOP-NEXT:    vpcmov {{.*}}(%rip), %ymm0, %ymm1, %ymm0
; XOP-NEXT:    retq
;
; AVX-LABEL: bitselect_v4i64_rr:
; AVX:       # %bb.0:
; AVX-NEXT:    vandps {{.*}}(%rip), %ymm0, %ymm0
; AVX-NEXT:    vandps {{.*}}(%rip), %ymm1, %ymm1
; AVX-NEXT:    vorps %ymm0, %ymm1, %ymm0
; AVX-NEXT:    retq
;
; AVX512F-LABEL: bitselect_v4i64_rr:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vandps {{.*}}(%rip), %ymm0, %ymm0
; AVX512F-NEXT:    vandps {{.*}}(%rip), %ymm1, %ymm1
; AVX512F-NEXT:    vorps %ymm0, %ymm1, %ymm0
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: bitselect_v4i64_rr:
; AVX512VL:       # %bb.0:
; AVX512VL-NEXT:    vpternlogq $216, {{.*}}(%rip), %ymm1, %ymm0
; AVX512VL-NEXT:    retq
  %3 = and <4 x i64> %0, <i64 4294967296, i64 12884901890, i64 12884901890, i64 12884901890>
  %4 = and <4 x i64> %1, <i64 -4294967297, i64 -12884901891, i64 -12884901891, i64 -12884901891>
  %5 = or <4 x i64> %4, %3
  ret <4 x i64> %5
}

define <4 x i64> @bitselect_v4i64_rm(<4 x i64>, <4 x i64>* nocapture readonly) {
; SSE-LABEL: bitselect_v4i64_rm:
; SSE:       # %bb.0:
; SSE-NEXT:    movaps {{.*#+}} xmm2 = [18446744065119617022,18446744073709551612]
; SSE-NEXT:    movaps 16(%rdi), %xmm4
; SSE-NEXT:    andps %xmm2, %xmm4
; SSE-NEXT:    movaps (%rdi), %xmm5
; SSE-NEXT:    andps %xmm2, %xmm5
; SSE-NEXT:    movaps %xmm2, %xmm3
; SSE-NEXT:    andnps %xmm0, %xmm3
; SSE-NEXT:    orps %xmm5, %xmm3
; SSE-NEXT:    andnps %xmm1, %xmm2
; SSE-NEXT:    orps %xmm4, %xmm2
; SSE-NEXT:    movaps %xmm3, %xmm0
; SSE-NEXT:    movaps %xmm2, %xmm1
; SSE-NEXT:    retq
;
; XOP-LABEL: bitselect_v4i64_rm:
; XOP:       # %bb.0:
; XOP-NEXT:    vmovdqa (%rdi), %ymm1
; XOP-NEXT:    vpcmov {{.*}}(%rip), %ymm0, %ymm1, %ymm0
; XOP-NEXT:    retq
;
; AVX-LABEL: bitselect_v4i64_rm:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovaps (%rdi), %ymm1
; AVX-NEXT:    vandps {{.*}}(%rip), %ymm0, %ymm0
; AVX-NEXT:    vandps {{.*}}(%rip), %ymm1, %ymm1
; AVX-NEXT:    vorps %ymm0, %ymm1, %ymm0
; AVX-NEXT:    retq
;
; AVX512F-LABEL: bitselect_v4i64_rm:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vmovaps (%rdi), %ymm1
; AVX512F-NEXT:    vandps {{.*}}(%rip), %ymm0, %ymm0
; AVX512F-NEXT:    vandps {{.*}}(%rip), %ymm1, %ymm1
; AVX512F-NEXT:    vorps %ymm0, %ymm1, %ymm0
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: bitselect_v4i64_rm:
; AVX512VL:       # %bb.0:
; AVX512VL-NEXT:    vmovdqa (%rdi), %ymm1
; AVX512VL-NEXT:    vpternlogq $216, {{.*}}(%rip), %ymm1, %ymm0
; AVX512VL-NEXT:    retq
  %3 = load <4 x i64>, <4 x i64>* %1
  %4 = and <4 x i64> %0, <i64 8589934593, i64 3, i64 8589934593, i64 3>
  %5 = and <4 x i64> %3, <i64 -8589934594, i64 -4, i64 -8589934594, i64 -4>
  %6 = or <4 x i64> %5, %4
  ret <4 x i64> %6
}

define <4 x i64> @bitselect_v4i64_mr(<4 x i64>* nocapture readonly, <4 x i64>) {
; SSE-LABEL: bitselect_v4i64_mr:
; SSE:       # %bb.0:
; SSE-NEXT:    movaps {{.*#+}} xmm2 = [12884901890,4294967296]
; SSE-NEXT:    movaps 16(%rdi), %xmm4
; SSE-NEXT:    andps %xmm2, %xmm4
; SSE-NEXT:    movaps (%rdi), %xmm5
; SSE-NEXT:    andps %xmm2, %xmm5
; SSE-NEXT:    movaps %xmm2, %xmm3
; SSE-NEXT:    andnps %xmm0, %xmm3
; SSE-NEXT:    orps %xmm5, %xmm3
; SSE-NEXT:    andnps %xmm1, %xmm2
; SSE-NEXT:    orps %xmm4, %xmm2
; SSE-NEXT:    movaps %xmm3, %xmm0
; SSE-NEXT:    movaps %xmm2, %xmm1
; SSE-NEXT:    retq
;
; XOP-LABEL: bitselect_v4i64_mr:
; XOP:       # %bb.0:
; XOP-NEXT:    vmovdqa (%rdi), %ymm1
; XOP-NEXT:    vpcmov {{.*}}(%rip), %ymm0, %ymm1, %ymm0
; XOP-NEXT:    retq
;
; AVX-LABEL: bitselect_v4i64_mr:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovaps (%rdi), %ymm1
; AVX-NEXT:    vandps {{.*}}(%rip), %ymm1, %ymm1
; AVX-NEXT:    vandps {{.*}}(%rip), %ymm0, %ymm0
; AVX-NEXT:    vorps %ymm0, %ymm1, %ymm0
; AVX-NEXT:    retq
;
; AVX512F-LABEL: bitselect_v4i64_mr:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vmovaps (%rdi), %ymm1
; AVX512F-NEXT:    vandps {{.*}}(%rip), %ymm1, %ymm1
; AVX512F-NEXT:    vandps {{.*}}(%rip), %ymm0, %ymm0
; AVX512F-NEXT:    vorps %ymm0, %ymm1, %ymm0
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: bitselect_v4i64_mr:
; AVX512VL:       # %bb.0:
; AVX512VL-NEXT:    vmovdqa (%rdi), %ymm1
; AVX512VL-NEXT:    vpternlogq $216, {{.*}}(%rip), %ymm1, %ymm0
; AVX512VL-NEXT:    retq
  %3 = load <4 x i64>, <4 x i64>* %0
  %4 = and <4 x i64> %3, <i64 12884901890, i64 4294967296, i64 12884901890, i64 4294967296>
  %5 = and <4 x i64> %1, <i64 -12884901891, i64 -4294967297, i64 -12884901891, i64 -4294967297>
  %6 = or <4 x i64> %4, %5
  ret <4 x i64> %6
}

define <4 x i64> @bitselect_v4i64_mm(<4 x i64>* nocapture readonly, <4 x i64>* nocapture readonly) {
; SSE-LABEL: bitselect_v4i64_mm:
; SSE:       # %bb.0:
; SSE-NEXT:    movaps {{.*#+}} xmm1 = [18446744073709551612,18446744065119617022]
; SSE-NEXT:    movaps 16(%rsi), %xmm2
; SSE-NEXT:    andps %xmm1, %xmm2
; SSE-NEXT:    movaps (%rsi), %xmm3
; SSE-NEXT:    andps %xmm1, %xmm3
; SSE-NEXT:    movaps %xmm1, %xmm0
; SSE-NEXT:    andnps (%rdi), %xmm0
; SSE-NEXT:    orps %xmm3, %xmm0
; SSE-NEXT:    andnps 16(%rdi), %xmm1
; SSE-NEXT:    orps %xmm2, %xmm1
; SSE-NEXT:    retq
;
; XOP-LABEL: bitselect_v4i64_mm:
; XOP:       # %bb.0:
; XOP-NEXT:    vmovdqa (%rsi), %ymm0
; XOP-NEXT:    vmovdqa {{.*#+}} ymm1 = [18446744073709551612,18446744065119617022,18446744073709551612,18446744065119617022]
; XOP-NEXT:    vpcmov %ymm1, (%rdi), %ymm0, %ymm0
; XOP-NEXT:    retq
;
; AVX-LABEL: bitselect_v4i64_mm:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovaps (%rdi), %ymm0
; AVX-NEXT:    vmovaps (%rsi), %ymm1
; AVX-NEXT:    vandps {{.*}}(%rip), %ymm0, %ymm0
; AVX-NEXT:    vandps {{.*}}(%rip), %ymm1, %ymm1
; AVX-NEXT:    vorps %ymm0, %ymm1, %ymm0
; AVX-NEXT:    retq
;
; AVX512F-LABEL: bitselect_v4i64_mm:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vmovaps (%rdi), %ymm0
; AVX512F-NEXT:    vmovaps (%rsi), %ymm1
; AVX512F-NEXT:    vandps {{.*}}(%rip), %ymm0, %ymm0
; AVX512F-NEXT:    vandps {{.*}}(%rip), %ymm1, %ymm1
; AVX512F-NEXT:    vorps %ymm0, %ymm1, %ymm0
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: bitselect_v4i64_mm:
; AVX512VL:       # %bb.0:
; AVX512VL-NEXT:    vmovdqa (%rsi), %ymm1
; AVX512VL-NEXT:    vmovdqa {{.*#+}} ymm0 = [18446744073709551612,18446744065119617022,18446744073709551612,18446744065119617022]
; AVX512VL-NEXT:    vpternlogq $202, (%rdi), %ymm1, %ymm0
; AVX512VL-NEXT:    retq
  %3 = load <4 x i64>, <4 x i64>* %0
  %4 = load <4 x i64>, <4 x i64>* %1
  %5 = and <4 x i64> %3, <i64 3, i64 8589934593, i64 3, i64 8589934593>
  %6 = and <4 x i64> %4, <i64 -4, i64 -8589934594, i64 -4, i64 -8589934594>
  %7 = or <4 x i64> %6, %5
  ret <4 x i64> %7
}

define <4 x i64> @bitselect_v4i64_broadcast_rrr(<4 x i64> %a0, <4 x i64> %a1, i64 %a2) {
; SSE-LABEL: bitselect_v4i64_broadcast_rrr:
; SSE:       # %bb.0:
; SSE-NEXT:    movq %rdi, %xmm4
; SSE-NEXT:    pshufd {{.*#+}} xmm4 = xmm4[0,1,0,1]
; SSE-NEXT:    pand %xmm4, %xmm1
; SSE-NEXT:    pand %xmm4, %xmm0
; SSE-NEXT:    movdqa %xmm4, %xmm5
; SSE-NEXT:    pandn %xmm3, %xmm5
; SSE-NEXT:    por %xmm5, %xmm1
; SSE-NEXT:    pandn %xmm2, %xmm4
; SSE-NEXT:    por %xmm4, %xmm0
; SSE-NEXT:    retq
;
; XOP-LABEL: bitselect_v4i64_broadcast_rrr:
; XOP:       # %bb.0:
; XOP-NEXT:    vmovq %rdi, %xmm2
; XOP-NEXT:    vmovq %rdi, %xmm3
; XOP-NEXT:    vmovddup {{.*#+}} xmm2 = xmm2[0,0]
; XOP-NEXT:    vinsertf128 $1, %xmm2, %ymm2, %ymm2
; XOP-NEXT:    vpshufd {{.*#+}} xmm3 = xmm3[0,1,0,1]
; XOP-NEXT:    vinsertf128 $1, %xmm3, %ymm3, %ymm3
; XOP-NEXT:    vandps %ymm2, %ymm0, %ymm0
; XOP-NEXT:    vandnps %ymm1, %ymm3, %ymm1
; XOP-NEXT:    vorps %ymm1, %ymm0, %ymm0
; XOP-NEXT:    retq
;
; AVX1-LABEL: bitselect_v4i64_broadcast_rrr:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vmovq %rdi, %xmm2
; AVX1-NEXT:    vmovq %rdi, %xmm3
; AVX1-NEXT:    vmovddup {{.*#+}} xmm2 = xmm2[0,0]
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm2, %ymm2
; AVX1-NEXT:    vpshufd {{.*#+}} xmm3 = xmm3[0,1,0,1]
; AVX1-NEXT:    vinsertf128 $1, %xmm3, %ymm3, %ymm3
; AVX1-NEXT:    vandps %ymm2, %ymm0, %ymm0
; AVX1-NEXT:    vandnps %ymm1, %ymm3, %ymm1
; AVX1-NEXT:    vorps %ymm1, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: bitselect_v4i64_broadcast_rrr:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovq %rdi, %xmm2
; AVX2-NEXT:    vpbroadcastq %xmm2, %ymm2
; AVX2-NEXT:    vpand %ymm2, %ymm0, %ymm0
; AVX2-NEXT:    vpandn %ymm1, %ymm2, %ymm1
; AVX2-NEXT:    vpor %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: bitselect_v4i64_broadcast_rrr:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vmovq %rdi, %xmm2
; AVX512F-NEXT:    vpbroadcastq %xmm2, %ymm2
; AVX512F-NEXT:    vpand %ymm2, %ymm0, %ymm0
; AVX512F-NEXT:    vpandn %ymm1, %ymm2, %ymm1
; AVX512F-NEXT:    vpor %ymm1, %ymm0, %ymm0
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: bitselect_v4i64_broadcast_rrr:
; AVX512VL:       # %bb.0:
; AVX512VL-NEXT:    vpbroadcastq %rdi, %ymm2
; AVX512VL-NEXT:    vpternlogq $226, %ymm1, %ymm2, %ymm0
; AVX512VL-NEXT:    retq
  %1 = insertelement <4 x i64> undef, i64 %a2, i32 0
  %2 = shufflevector <4 x i64> %1, <4 x i64> undef, <4 x i32> zeroinitializer
  %3 = xor <4 x i64> %1, <i64 -1, i64 undef, i64 undef, i64 undef>
  %4 = shufflevector <4 x i64> %3, <4 x i64> undef, <4 x i32> zeroinitializer
  %5 = and <4 x i64> %a0, %2
  %6 = and <4 x i64> %a1, %4
  %7 = or <4 x i64> %5, %6
  ret <4 x i64> %7
}

define <4 x i64> @bitselect_v4i64_broadcast_rrm(<4 x i64> %a0, <4 x i64> %a1, i64* %p2) {
; SSE-LABEL: bitselect_v4i64_broadcast_rrm:
; SSE:       # %bb.0:
; SSE-NEXT:    movq {{.*#+}} xmm4 = mem[0],zero
; SSE-NEXT:    pshufd {{.*#+}} xmm4 = xmm4[0,1,0,1]
; SSE-NEXT:    pand %xmm4, %xmm1
; SSE-NEXT:    pand %xmm4, %xmm0
; SSE-NEXT:    movdqa %xmm4, %xmm5
; SSE-NEXT:    pandn %xmm3, %xmm5
; SSE-NEXT:    por %xmm5, %xmm1
; SSE-NEXT:    pandn %xmm2, %xmm4
; SSE-NEXT:    por %xmm4, %xmm0
; SSE-NEXT:    retq
;
; XOP-LABEL: bitselect_v4i64_broadcast_rrm:
; XOP:       # %bb.0:
; XOP-NEXT:    vbroadcastsd (%rdi), %ymm2
; XOP-NEXT:    vpcmov %ymm2, %ymm1, %ymm0, %ymm0
; XOP-NEXT:    retq
;
; AVX-LABEL: bitselect_v4i64_broadcast_rrm:
; AVX:       # %bb.0:
; AVX-NEXT:    vbroadcastsd (%rdi), %ymm2
; AVX-NEXT:    vandps %ymm2, %ymm0, %ymm0
; AVX-NEXT:    vandnps %ymm1, %ymm2, %ymm1
; AVX-NEXT:    vorps %ymm1, %ymm0, %ymm0
; AVX-NEXT:    retq
;
; AVX512F-LABEL: bitselect_v4i64_broadcast_rrm:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vbroadcastsd (%rdi), %ymm2
; AVX512F-NEXT:    vandps %ymm2, %ymm0, %ymm0
; AVX512F-NEXT:    vandnps %ymm1, %ymm2, %ymm1
; AVX512F-NEXT:    vorps %ymm1, %ymm0, %ymm0
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: bitselect_v4i64_broadcast_rrm:
; AVX512VL:       # %bb.0:
; AVX512VL-NEXT:    vpternlogq $228, (%rdi){1to4}, %ymm1, %ymm0
; AVX512VL-NEXT:    retq
  %a2 = load i64, i64* %p2
  %1 = insertelement <4 x i64> undef, i64 %a2, i32 0
  %2 = shufflevector <4 x i64> %1, <4 x i64> undef, <4 x i32> zeroinitializer
  %3 = xor <4 x i64> %1, <i64 -1, i64 undef, i64 undef, i64 undef>
  %4 = shufflevector <4 x i64> %3, <4 x i64> undef, <4 x i32> zeroinitializer
  %5 = and <4 x i64> %a0, %2
  %6 = and <4 x i64> %a1, %4
  %7 = or <4 x i64> %5, %6
  ret <4 x i64> %7
}

;
; 512-bit vectors
;

define <8 x i64> @bitselect_v8i64_rr(<8 x i64>, <8 x i64>) {
; SSE-LABEL: bitselect_v8i64_rr:
; SSE:       # %bb.0:
; SSE-NEXT:    movaps {{.*#+}} xmm8 = [18446744060824649725,18446744060824649725]
; SSE-NEXT:    andps %xmm8, %xmm7
; SSE-NEXT:    movaps {{.*#+}} xmm9 = [18446744069414584319,18446744060824649725]
; SSE-NEXT:    andps %xmm9, %xmm6
; SSE-NEXT:    andps %xmm8, %xmm5
; SSE-NEXT:    andps %xmm9, %xmm4
; SSE-NEXT:    movaps %xmm9, %xmm10
; SSE-NEXT:    andnps %xmm0, %xmm10
; SSE-NEXT:    orps %xmm4, %xmm10
; SSE-NEXT:    movaps %xmm8, %xmm4
; SSE-NEXT:    andnps %xmm1, %xmm4
; SSE-NEXT:    orps %xmm5, %xmm4
; SSE-NEXT:    andnps %xmm2, %xmm9
; SSE-NEXT:    orps %xmm6, %xmm9
; SSE-NEXT:    andnps %xmm3, %xmm8
; SSE-NEXT:    orps %xmm7, %xmm8
; SSE-NEXT:    movaps %xmm10, %xmm0
; SSE-NEXT:    movaps %xmm4, %xmm1
; SSE-NEXT:    movaps %xmm9, %xmm2
; SSE-NEXT:    movaps %xmm8, %xmm3
; SSE-NEXT:    retq
;
; XOP-LABEL: bitselect_v8i64_rr:
; XOP:       # %bb.0:
; XOP-NEXT:    vmovdqa {{.*#+}} ymm4 = [18446744069414584319,18446744060824649725,18446744060824649725,18446744060824649725]
; XOP-NEXT:    vpcmov %ymm4, %ymm0, %ymm2, %ymm0
; XOP-NEXT:    vpcmov %ymm4, %ymm1, %ymm3, %ymm1
; XOP-NEXT:    retq
;
; AVX-LABEL: bitselect_v8i64_rr:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovaps {{.*#+}} ymm4 = [18446744069414584319,18446744060824649725,18446744060824649725,18446744060824649725]
; AVX-NEXT:    vandps %ymm4, %ymm3, %ymm3
; AVX-NEXT:    vandps %ymm4, %ymm2, %ymm2
; AVX-NEXT:    vandnps %ymm0, %ymm4, %ymm0
; AVX-NEXT:    vorps %ymm0, %ymm2, %ymm0
; AVX-NEXT:    vandnps %ymm1, %ymm4, %ymm1
; AVX-NEXT:    vorps %ymm1, %ymm3, %ymm1
; AVX-NEXT:    retq
;
; AVX512-LABEL: bitselect_v8i64_rr:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpternlogq $216, {{.*}}(%rip), %zmm1, %zmm0
; AVX512-NEXT:    retq
  %3 = and <8 x i64> %0, <i64 4294967296, i64 12884901890, i64 12884901890, i64 12884901890, i64 4294967296, i64 12884901890, i64 12884901890, i64 12884901890>
  %4 = and <8 x i64> %1, <i64 -4294967297, i64 -12884901891, i64 -12884901891, i64 -12884901891, i64 -4294967297, i64 -12884901891, i64 -12884901891, i64 -12884901891>
  %5 = or <8 x i64> %4, %3
  ret <8 x i64> %5
}

define <8 x i64> @bitselect_v8i64_rm(<8 x i64>, <8 x i64>* nocapture readonly) {
; SSE-LABEL: bitselect_v8i64_rm:
; SSE:       # %bb.0:
; SSE-NEXT:    movaps {{.*#+}} xmm4 = [18446744065119617022,18446744073709551612]
; SSE-NEXT:    movaps 48(%rdi), %xmm8
; SSE-NEXT:    andps %xmm4, %xmm8
; SSE-NEXT:    movaps 32(%rdi), %xmm9
; SSE-NEXT:    andps %xmm4, %xmm9
; SSE-NEXT:    movaps 16(%rdi), %xmm7
; SSE-NEXT:    andps %xmm4, %xmm7
; SSE-NEXT:    movaps (%rdi), %xmm6
; SSE-NEXT:    andps %xmm4, %xmm6
; SSE-NEXT:    movaps %xmm4, %xmm5
; SSE-NEXT:    andnps %xmm0, %xmm5
; SSE-NEXT:    orps %xmm6, %xmm5
; SSE-NEXT:    movaps %xmm4, %xmm6
; SSE-NEXT:    andnps %xmm1, %xmm6
; SSE-NEXT:    orps %xmm7, %xmm6
; SSE-NEXT:    movaps %xmm4, %xmm7
; SSE-NEXT:    andnps %xmm2, %xmm7
; SSE-NEXT:    orps %xmm9, %xmm7
; SSE-NEXT:    andnps %xmm3, %xmm4
; SSE-NEXT:    orps %xmm8, %xmm4
; SSE-NEXT:    movaps %xmm5, %xmm0
; SSE-NEXT:    movaps %xmm6, %xmm1
; SSE-NEXT:    movaps %xmm7, %xmm2
; SSE-NEXT:    movaps %xmm4, %xmm3
; SSE-NEXT:    retq
;
; XOP-LABEL: bitselect_v8i64_rm:
; XOP:       # %bb.0:
; XOP-NEXT:    vmovdqa (%rdi), %ymm2
; XOP-NEXT:    vmovdqa 32(%rdi), %ymm3
; XOP-NEXT:    vbroadcastf128 {{.*#+}} ymm4 = [18446744065119617022,18446744073709551612,18446744065119617022,18446744073709551612]
; XOP-NEXT:    # ymm4 = mem[0,1,0,1]
; XOP-NEXT:    vpcmov %ymm4, %ymm0, %ymm2, %ymm0
; XOP-NEXT:    vpcmov %ymm4, %ymm1, %ymm3, %ymm1
; XOP-NEXT:    retq
;
; AVX-LABEL: bitselect_v8i64_rm:
; AVX:       # %bb.0:
; AVX-NEXT:    vbroadcastf128 {{.*#+}} ymm2 = [18446744065119617022,18446744073709551612,18446744065119617022,18446744073709551612]
; AVX-NEXT:    # ymm2 = mem[0,1,0,1]
; AVX-NEXT:    vandps 32(%rdi), %ymm2, %ymm3
; AVX-NEXT:    vandps (%rdi), %ymm2, %ymm4
; AVX-NEXT:    vandnps %ymm0, %ymm2, %ymm0
; AVX-NEXT:    vorps %ymm0, %ymm4, %ymm0
; AVX-NEXT:    vandnps %ymm1, %ymm2, %ymm1
; AVX-NEXT:    vorps %ymm1, %ymm3, %ymm1
; AVX-NEXT:    retq
;
; AVX512-LABEL: bitselect_v8i64_rm:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovdqa64 (%rdi), %zmm1
; AVX512-NEXT:    vpternlogq $216, {{.*}}(%rip), %zmm1, %zmm0
; AVX512-NEXT:    retq
  %3 = load <8 x i64>, <8 x i64>* %1
  %4 = and <8 x i64> %0, <i64 8589934593, i64 3, i64 8589934593, i64 3, i64 8589934593, i64 3, i64 8589934593, i64 3>
  %5 = and <8 x i64> %3, <i64 -8589934594, i64 -4, i64 -8589934594, i64 -4, i64 -8589934594, i64 -4, i64 -8589934594, i64 -4>
  %6 = or <8 x i64> %5, %4
  ret <8 x i64> %6
}

define <8 x i64> @bitselect_v8i64_mr(<8 x i64>* nocapture readonly, <8 x i64>) {
; SSE-LABEL: bitselect_v8i64_mr:
; SSE:       # %bb.0:
; SSE-NEXT:    movaps {{.*#+}} xmm4 = [12884901890,4294967296]
; SSE-NEXT:    movaps 48(%rdi), %xmm8
; SSE-NEXT:    andps %xmm4, %xmm8
; SSE-NEXT:    movaps 32(%rdi), %xmm9
; SSE-NEXT:    andps %xmm4, %xmm9
; SSE-NEXT:    movaps 16(%rdi), %xmm7
; SSE-NEXT:    andps %xmm4, %xmm7
; SSE-NEXT:    movaps (%rdi), %xmm6
; SSE-NEXT:    andps %xmm4, %xmm6
; SSE-NEXT:    movaps %xmm4, %xmm5
; SSE-NEXT:    andnps %xmm0, %xmm5
; SSE-NEXT:    orps %xmm6, %xmm5
; SSE-NEXT:    movaps %xmm4, %xmm6
; SSE-NEXT:    andnps %xmm1, %xmm6
; SSE-NEXT:    orps %xmm7, %xmm6
; SSE-NEXT:    movaps %xmm4, %xmm7
; SSE-NEXT:    andnps %xmm2, %xmm7
; SSE-NEXT:    orps %xmm9, %xmm7
; SSE-NEXT:    andnps %xmm3, %xmm4
; SSE-NEXT:    orps %xmm8, %xmm4
; SSE-NEXT:    movaps %xmm5, %xmm0
; SSE-NEXT:    movaps %xmm6, %xmm1
; SSE-NEXT:    movaps %xmm7, %xmm2
; SSE-NEXT:    movaps %xmm4, %xmm3
; SSE-NEXT:    retq
;
; XOP-LABEL: bitselect_v8i64_mr:
; XOP:       # %bb.0:
; XOP-NEXT:    vmovdqa (%rdi), %ymm2
; XOP-NEXT:    vmovdqa 32(%rdi), %ymm3
; XOP-NEXT:    vbroadcastf128 {{.*#+}} ymm4 = [12884901890,4294967296,12884901890,4294967296]
; XOP-NEXT:    # ymm4 = mem[0,1,0,1]
; XOP-NEXT:    vpcmov %ymm4, %ymm0, %ymm2, %ymm0
; XOP-NEXT:    vpcmov %ymm4, %ymm1, %ymm3, %ymm1
; XOP-NEXT:    retq
;
; AVX-LABEL: bitselect_v8i64_mr:
; AVX:       # %bb.0:
; AVX-NEXT:    vbroadcastf128 {{.*#+}} ymm2 = [12884901890,4294967296,12884901890,4294967296]
; AVX-NEXT:    # ymm2 = mem[0,1,0,1]
; AVX-NEXT:    vandps 32(%rdi), %ymm2, %ymm3
; AVX-NEXT:    vandps (%rdi), %ymm2, %ymm4
; AVX-NEXT:    vandnps %ymm0, %ymm2, %ymm0
; AVX-NEXT:    vorps %ymm0, %ymm4, %ymm0
; AVX-NEXT:    vandnps %ymm1, %ymm2, %ymm1
; AVX-NEXT:    vorps %ymm1, %ymm3, %ymm1
; AVX-NEXT:    retq
;
; AVX512-LABEL: bitselect_v8i64_mr:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovdqa64 (%rdi), %zmm1
; AVX512-NEXT:    vpternlogq $216, {{.*}}(%rip), %zmm1, %zmm0
; AVX512-NEXT:    retq
  %3 = load <8 x i64>, <8 x i64>* %0
  %4 = and <8 x i64> %3, <i64 12884901890, i64 4294967296, i64 12884901890, i64 4294967296, i64 12884901890, i64 4294967296, i64 12884901890, i64 4294967296>
  %5 = and <8 x i64> %1, <i64 -12884901891, i64 -4294967297, i64 -12884901891, i64 -4294967297, i64 -12884901891, i64 -4294967297, i64 -12884901891, i64 -4294967297>
  %6 = or <8 x i64> %4, %5
  ret <8 x i64> %6
}

define <8 x i64> @bitselect_v8i64_mm(<8 x i64>* nocapture readonly, <8 x i64>* nocapture readonly) {
; SSE-LABEL: bitselect_v8i64_mm:
; SSE:       # %bb.0:
; SSE-NEXT:    movaps {{.*#+}} xmm3 = [18446744073709551612,18446744065119617022]
; SSE-NEXT:    movaps 48(%rsi), %xmm4
; SSE-NEXT:    andps %xmm3, %xmm4
; SSE-NEXT:    movaps 32(%rsi), %xmm5
; SSE-NEXT:    andps %xmm3, %xmm5
; SSE-NEXT:    movaps 16(%rsi), %xmm2
; SSE-NEXT:    andps %xmm3, %xmm2
; SSE-NEXT:    movaps (%rsi), %xmm1
; SSE-NEXT:    andps %xmm3, %xmm1
; SSE-NEXT:    movaps %xmm3, %xmm0
; SSE-NEXT:    andnps (%rdi), %xmm0
; SSE-NEXT:    orps %xmm1, %xmm0
; SSE-NEXT:    movaps %xmm3, %xmm1
; SSE-NEXT:    andnps 16(%rdi), %xmm1
; SSE-NEXT:    orps %xmm2, %xmm1
; SSE-NEXT:    movaps %xmm3, %xmm2
; SSE-NEXT:    andnps 32(%rdi), %xmm2
; SSE-NEXT:    orps %xmm5, %xmm2
; SSE-NEXT:    andnps 48(%rdi), %xmm3
; SSE-NEXT:    orps %xmm4, %xmm3
; SSE-NEXT:    retq
;
; XOP-LABEL: bitselect_v8i64_mm:
; XOP:       # %bb.0:
; XOP-NEXT:    vmovdqa (%rsi), %ymm0
; XOP-NEXT:    vmovdqa 32(%rsi), %ymm1
; XOP-NEXT:    vbroadcastf128 {{.*#+}} ymm2 = [18446744073709551612,18446744065119617022,18446744073709551612,18446744065119617022]
; XOP-NEXT:    # ymm2 = mem[0,1,0,1]
; XOP-NEXT:    vpcmov %ymm2, (%rdi), %ymm0, %ymm0
; XOP-NEXT:    vpcmov %ymm2, 32(%rdi), %ymm1, %ymm1
; XOP-NEXT:    retq
;
; AVX-LABEL: bitselect_v8i64_mm:
; AVX:       # %bb.0:
; AVX-NEXT:    vbroadcastf128 {{.*#+}} ymm1 = [18446744073709551612,18446744065119617022,18446744073709551612,18446744065119617022]
; AVX-NEXT:    # ymm1 = mem[0,1,0,1]
; AVX-NEXT:    vandps 32(%rsi), %ymm1, %ymm2
; AVX-NEXT:    vandps (%rsi), %ymm1, %ymm0
; AVX-NEXT:    vandnps (%rdi), %ymm1, %ymm3
; AVX-NEXT:    vorps %ymm3, %ymm0, %ymm0
; AVX-NEXT:    vandnps 32(%rdi), %ymm1, %ymm1
; AVX-NEXT:    vorps %ymm1, %ymm2, %ymm1
; AVX-NEXT:    retq
;
; AVX512-LABEL: bitselect_v8i64_mm:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovdqa64 (%rsi), %zmm1
; AVX512-NEXT:    vmovdqa64 {{.*#+}} zmm0 = [18446744073709551612,18446744065119617022,18446744073709551612,18446744065119617022,18446744073709551612,18446744065119617022,18446744073709551612,18446744065119617022]
; AVX512-NEXT:    vpternlogq $202, (%rdi), %zmm1, %zmm0
; AVX512-NEXT:    retq
  %3 = load <8 x i64>, <8 x i64>* %0
  %4 = load <8 x i64>, <8 x i64>* %1
  %5 = and <8 x i64> %3, <i64 3, i64 8589934593, i64 3, i64 8589934593, i64 3, i64 8589934593, i64 3, i64 8589934593>
  %6 = and <8 x i64> %4, <i64 -4, i64 -8589934594, i64 -4, i64 -8589934594, i64 -4, i64 -8589934594, i64 -4, i64 -8589934594>
  %7 = or <8 x i64> %6, %5
  ret <8 x i64> %7
}

define <8 x i64> @bitselect_v8i64_broadcast_rrr(<8 x i64> %a0, <8 x i64> %a1, i64 %a2) {
; SSE-LABEL: bitselect_v8i64_broadcast_rrr:
; SSE:       # %bb.0:
; SSE-NEXT:    movq %rdi, %xmm8
; SSE-NEXT:    pshufd {{.*#+}} xmm8 = xmm8[0,1,0,1]
; SSE-NEXT:    pand %xmm8, %xmm3
; SSE-NEXT:    pand %xmm8, %xmm2
; SSE-NEXT:    pand %xmm8, %xmm1
; SSE-NEXT:    pand %xmm8, %xmm0
; SSE-NEXT:    movdqa %xmm8, %xmm9
; SSE-NEXT:    pandn %xmm7, %xmm9
; SSE-NEXT:    por %xmm9, %xmm3
; SSE-NEXT:    movdqa %xmm8, %xmm7
; SSE-NEXT:    pandn %xmm6, %xmm7
; SSE-NEXT:    por %xmm7, %xmm2
; SSE-NEXT:    movdqa %xmm8, %xmm6
; SSE-NEXT:    pandn %xmm5, %xmm6
; SSE-NEXT:    por %xmm6, %xmm1
; SSE-NEXT:    pandn %xmm4, %xmm8
; SSE-NEXT:    por %xmm8, %xmm0
; SSE-NEXT:    retq
;
; XOP-LABEL: bitselect_v8i64_broadcast_rrr:
; XOP:       # %bb.0:
; XOP-NEXT:    vmovq %rdi, %xmm4
; XOP-NEXT:    vmovq %rdi, %xmm5
; XOP-NEXT:    vmovddup {{.*#+}} xmm4 = xmm4[0,0]
; XOP-NEXT:    vinsertf128 $1, %xmm4, %ymm4, %ymm4
; XOP-NEXT:    vpshufd {{.*#+}} xmm5 = xmm5[0,1,0,1]
; XOP-NEXT:    vinsertf128 $1, %xmm5, %ymm5, %ymm5
; XOP-NEXT:    vandps %ymm4, %ymm1, %ymm1
; XOP-NEXT:    vandps %ymm4, %ymm0, %ymm0
; XOP-NEXT:    vandnps %ymm3, %ymm5, %ymm3
; XOP-NEXT:    vorps %ymm3, %ymm1, %ymm1
; XOP-NEXT:    vandnps %ymm2, %ymm5, %ymm2
; XOP-NEXT:    vorps %ymm2, %ymm0, %ymm0
; XOP-NEXT:    retq
;
; AVX1-LABEL: bitselect_v8i64_broadcast_rrr:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vmovq %rdi, %xmm4
; AVX1-NEXT:    vmovq %rdi, %xmm5
; AVX1-NEXT:    vmovddup {{.*#+}} xmm4 = xmm4[0,0]
; AVX1-NEXT:    vinsertf128 $1, %xmm4, %ymm4, %ymm4
; AVX1-NEXT:    vpshufd {{.*#+}} xmm5 = xmm5[0,1,0,1]
; AVX1-NEXT:    vinsertf128 $1, %xmm5, %ymm5, %ymm5
; AVX1-NEXT:    vandps %ymm4, %ymm1, %ymm1
; AVX1-NEXT:    vandps %ymm4, %ymm0, %ymm0
; AVX1-NEXT:    vandnps %ymm3, %ymm5, %ymm3
; AVX1-NEXT:    vorps %ymm3, %ymm1, %ymm1
; AVX1-NEXT:    vandnps %ymm2, %ymm5, %ymm2
; AVX1-NEXT:    vorps %ymm2, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: bitselect_v8i64_broadcast_rrr:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovq %rdi, %xmm4
; AVX2-NEXT:    vpbroadcastq %xmm4, %ymm4
; AVX2-NEXT:    vpand %ymm4, %ymm1, %ymm1
; AVX2-NEXT:    vpand %ymm4, %ymm0, %ymm0
; AVX2-NEXT:    vpandn %ymm3, %ymm4, %ymm3
; AVX2-NEXT:    vpor %ymm3, %ymm1, %ymm1
; AVX2-NEXT:    vpandn %ymm2, %ymm4, %ymm2
; AVX2-NEXT:    vpor %ymm2, %ymm0, %ymm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: bitselect_v8i64_broadcast_rrr:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpbroadcastq %rdi, %zmm2
; AVX512-NEXT:    vpternlogq $226, %zmm1, %zmm2, %zmm0
; AVX512-NEXT:    retq
  %1 = insertelement <8 x i64> undef, i64 %a2, i32 0
  %2 = shufflevector <8 x i64> %1, <8 x i64> undef, <8 x i32> zeroinitializer
  %3 = xor <8 x i64> %1, <i64 -1, i64 undef, i64 undef, i64 undef, i64 undef, i64 undef, i64 undef, i64 undef>
  %4 = shufflevector <8 x i64> %3, <8 x i64> undef, <8 x i32> zeroinitializer
  %5 = and <8 x i64> %a0, %2
  %6 = and <8 x i64> %a1, %4
  %7 = or <8 x i64> %5, %6
  ret <8 x i64> %7
}

define <8 x i64> @bitselect_v8i64_broadcast_rrm(<8 x i64> %a0, <8 x i64> %a1, i64* %p2) {
; SSE-LABEL: bitselect_v8i64_broadcast_rrm:
; SSE:       # %bb.0:
; SSE-NEXT:    movq {{.*#+}} xmm8 = mem[0],zero
; SSE-NEXT:    pshufd {{.*#+}} xmm8 = xmm8[0,1,0,1]
; SSE-NEXT:    pand %xmm8, %xmm3
; SSE-NEXT:    pand %xmm8, %xmm2
; SSE-NEXT:    pand %xmm8, %xmm1
; SSE-NEXT:    pand %xmm8, %xmm0
; SSE-NEXT:    movdqa %xmm8, %xmm9
; SSE-NEXT:    pandn %xmm7, %xmm9
; SSE-NEXT:    por %xmm9, %xmm3
; SSE-NEXT:    movdqa %xmm8, %xmm7
; SSE-NEXT:    pandn %xmm6, %xmm7
; SSE-NEXT:    por %xmm7, %xmm2
; SSE-NEXT:    movdqa %xmm8, %xmm6
; SSE-NEXT:    pandn %xmm5, %xmm6
; SSE-NEXT:    por %xmm6, %xmm1
; SSE-NEXT:    pandn %xmm4, %xmm8
; SSE-NEXT:    por %xmm8, %xmm0
; SSE-NEXT:    retq
;
; XOP-LABEL: bitselect_v8i64_broadcast_rrm:
; XOP:       # %bb.0:
; XOP-NEXT:    vbroadcastsd (%rdi), %ymm4
; XOP-NEXT:    vpcmov %ymm4, %ymm2, %ymm0, %ymm0
; XOP-NEXT:    vpcmov %ymm4, %ymm3, %ymm1, %ymm1
; XOP-NEXT:    retq
;
; AVX-LABEL: bitselect_v8i64_broadcast_rrm:
; AVX:       # %bb.0:
; AVX-NEXT:    vbroadcastsd (%rdi), %ymm4
; AVX-NEXT:    vandps %ymm4, %ymm1, %ymm1
; AVX-NEXT:    vandps %ymm4, %ymm0, %ymm0
; AVX-NEXT:    vandnps %ymm3, %ymm4, %ymm3
; AVX-NEXT:    vorps %ymm3, %ymm1, %ymm1
; AVX-NEXT:    vandnps %ymm2, %ymm4, %ymm2
; AVX-NEXT:    vorps %ymm2, %ymm0, %ymm0
; AVX-NEXT:    retq
;
; AVX512-LABEL: bitselect_v8i64_broadcast_rrm:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpternlogq $228, (%rdi){1to8}, %zmm1, %zmm0
; AVX512-NEXT:    retq
  %a2 = load i64, i64* %p2
  %1 = insertelement <8 x i64> undef, i64 %a2, i32 0
  %2 = shufflevector <8 x i64> %1, <8 x i64> undef, <8 x i32> zeroinitializer
  %3 = xor <8 x i64> %1, <i64 -1, i64 undef, i64 undef, i64 undef, i64 undef, i64 undef, i64 undef, i64 undef>
  %4 = shufflevector <8 x i64> %3, <8 x i64> undef, <8 x i32> zeroinitializer
  %5 = and <8 x i64> %a0, %2
  %6 = and <8 x i64> %a1, %4
  %7 = or <8 x i64> %5, %6
  ret <8 x i64> %7
}

; Check that mask registers don't get canonicalized.
define <4 x i1> @bitselect_v4i1_loop(<4 x i32> %a0, <4 x i32> %a1) {
; SSE-LABEL: bitselect_v4i1_loop:
; SSE:       # %bb.0: # %bb
; SSE-NEXT:    pxor %xmm2, %xmm2
; SSE-NEXT:    pcmpeqd %xmm0, %xmm2
; SSE-NEXT:    movdqa {{.*#+}} xmm0 = [12,12,12,12]
; SSE-NEXT:    pcmpeqd %xmm1, %xmm0
; SSE-NEXT:    pcmpeqd {{.*}}(%rip), %xmm1
; SSE-NEXT:    pand %xmm2, %xmm1
; SSE-NEXT:    pandn %xmm0, %xmm2
; SSE-NEXT:    por %xmm1, %xmm2
; SSE-NEXT:    movdqa %xmm2, %xmm0
; SSE-NEXT:    retq
;
; XOP-LABEL: bitselect_v4i1_loop:
; XOP:       # %bb.0: # %bb
; XOP-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; XOP-NEXT:    vpcomneqd %xmm2, %xmm0, %xmm0
; XOP-NEXT:    vpcomeqd {{.*}}(%rip), %xmm1, %xmm2
; XOP-NEXT:    vpcomeqd {{.*}}(%rip), %xmm1, %xmm1
; XOP-NEXT:    vblendvps %xmm0, %xmm2, %xmm1, %xmm0
; XOP-NEXT:    retq
;
; AVX1-LABEL: bitselect_v4i1_loop:
; AVX1:       # %bb.0: # %bb
; AVX1-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; AVX1-NEXT:    vpcmpeqd %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vpcmpeqd {{.*}}(%rip), %xmm1, %xmm2
; AVX1-NEXT:    vpcmpeqd {{.*}}(%rip), %xmm1, %xmm1
; AVX1-NEXT:    vblendvps %xmm0, %xmm1, %xmm2, %xmm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: bitselect_v4i1_loop:
; AVX2:       # %bb.0: # %bb
; AVX2-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; AVX2-NEXT:    vpcmpeqd %xmm2, %xmm0, %xmm0
; AVX2-NEXT:    vpbroadcastd {{.*#+}} xmm2 = [12,12,12,12]
; AVX2-NEXT:    vpcmpeqd %xmm2, %xmm1, %xmm2
; AVX2-NEXT:    vpbroadcastd {{.*#+}} xmm3 = [15,15,15,15]
; AVX2-NEXT:    vpcmpeqd %xmm3, %xmm1, %xmm1
; AVX2-NEXT:    vblendvps %xmm0, %xmm1, %xmm2, %xmm0
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: bitselect_v4i1_loop:
; AVX512F:       # %bb.0: # %bb
; AVX512F-NEXT:    # kill: def $xmm1 killed $xmm1 def $zmm1
; AVX512F-NEXT:    # kill: def $xmm0 killed $xmm0 def $zmm0
; AVX512F-NEXT:    vpcmpeqd {{.*}}(%rip){1to16}, %zmm1, %k1
; AVX512F-NEXT:    vpcmpeqd {{.*}}(%rip){1to16}, %zmm1, %k2
; AVX512F-NEXT:    vptestnmd %zmm0, %zmm0, %k0 {%k2}
; AVX512F-NEXT:    vptestmd %zmm0, %zmm0, %k1 {%k1}
; AVX512F-NEXT:    korw %k0, %k1, %k1
; AVX512F-NEXT:    vpternlogd $255, %zmm0, %zmm0, %zmm0 {%k1} {z}
; AVX512F-NEXT:    # kill: def $xmm0 killed $xmm0 killed $zmm0
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: bitselect_v4i1_loop:
; AVX512VL:       # %bb.0: # %bb
; AVX512VL-NEXT:    vpcmpeqd {{.*}}(%rip){1to4}, %xmm1, %k1
; AVX512VL-NEXT:    vpcmpeqd {{.*}}(%rip){1to4}, %xmm1, %k2
; AVX512VL-NEXT:    vptestnmd %xmm0, %xmm0, %k0 {%k2}
; AVX512VL-NEXT:    vptestmd %xmm0, %xmm0, %k1 {%k1}
; AVX512VL-NEXT:    korw %k0, %k1, %k1
; AVX512VL-NEXT:    vpcmpeqd %xmm0, %xmm0, %xmm0
; AVX512VL-NEXT:    vmovdqa32 %xmm0, %xmm0 {%k1} {z}
; AVX512VL-NEXT:    retq
bb:
  %tmp = icmp ne <4 x i32> %a0, zeroinitializer
  %tmp2 = icmp eq <4 x i32> %a1, <i32 12, i32 12, i32 12, i32 12>
  %tmp3 = icmp eq <4 x i32> %a1, <i32 15, i32 15, i32 15, i32 15>
  %tmp4 = select <4 x i1> %tmp, <4 x i1> %tmp2, <4 x i1> %tmp3
  ret <4 x i1> %tmp4
}

