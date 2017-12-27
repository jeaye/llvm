; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.1 | FileCheck %s --check-prefix=SSE
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefix=AVX
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefix=AVX --check-prefix=AVX2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512vl | FileCheck %s --check-prefix=AVX --check-prefix=AVX512VL
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512vl,+avx512dq | FileCheck %s --check-prefix=AVX --check-prefix=AVX512DQVL

; TODO - shuffle+sext are superfluous
define <2 x i64> @combine_shuffle_sext_pmuldq(<4 x i32> %a0, <4 x i32> %a1) {
; SSE-LABEL: combine_shuffle_sext_pmuldq:
; SSE:       # %bb.0:
; SSE-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; SSE-NEXT:    pmovsxdq %xmm0, %xmm2
; SSE-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[0,2,2,3]
; SSE-NEXT:    pmovsxdq %xmm0, %xmm0
; SSE-NEXT:    pmuldq %xmm2, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_shuffle_sext_pmuldq:
; AVX:       # %bb.0:
; AVX-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; AVX-NEXT:    vpmovsxdq %xmm0, %xmm0
; AVX-NEXT:    vpshufd {{.*#+}} xmm1 = xmm1[0,2,2,3]
; AVX-NEXT:    vpmovsxdq %xmm1, %xmm1
; AVX-NEXT:    vpmuldq %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = shufflevector <4 x i32> %a0, <4 x i32> undef, <2 x i32> <i32 0, i32 2>
  %2 = shufflevector <4 x i32> %a1, <4 x i32> undef, <2 x i32> <i32 0, i32 2>
  %3 = sext <2 x i32> %1 to <2 x i64>
  %4 = sext <2 x i32> %2 to <2 x i64>
  %5 = mul nuw <2 x i64> %3, %4
  ret <2 x i64> %5
}

; TODO - shuffle+zext are superfluous
define <2 x i64> @combine_shuffle_zext_pmuludq(<4 x i32> %a0, <4 x i32> %a1) {
; SSE-LABEL: combine_shuffle_zext_pmuludq:
; SSE:       # %bb.0:
; SSE-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; SSE-NEXT:    pmovzxdq {{.*#+}} xmm2 = xmm0[0],zero,xmm0[1],zero
; SSE-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[0,2,2,3]
; SSE-NEXT:    pmovzxdq {{.*#+}} xmm0 = xmm0[0],zero,xmm0[1],zero
; SSE-NEXT:    pmuludq %xmm2, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_shuffle_zext_pmuludq:
; AVX:       # %bb.0:
; AVX-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; AVX-NEXT:    vpmovzxdq {{.*#+}} xmm0 = xmm0[0],zero,xmm0[1],zero
; AVX-NEXT:    vpshufd {{.*#+}} xmm1 = xmm1[0,2,2,3]
; AVX-NEXT:    vpmovzxdq {{.*#+}} xmm1 = xmm1[0],zero,xmm1[1],zero
; AVX-NEXT:    vpmuludq %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = shufflevector <4 x i32> %a0, <4 x i32> undef, <2 x i32> <i32 0, i32 2>
  %2 = shufflevector <4 x i32> %a1, <4 x i32> undef, <2 x i32> <i32 0, i32 2>
  %3 = zext <2 x i32> %1 to <2 x i64>
  %4 = zext <2 x i32> %2 to <2 x i64>
  %5 = mul nuw <2 x i64> %3, %4
  ret <2 x i64> %5
}

; TODO - blends are superfluous
define <2 x i64> @combine_shuffle_zero_pmuludq(<4 x i32> %a0, <4 x i32> %a1) {
; SSE-LABEL: combine_shuffle_zero_pmuludq:
; SSE:       # %bb.0:
; SSE-NEXT:    pxor %xmm2, %xmm2
; SSE-NEXT:    pblendw {{.*#+}} xmm0 = xmm0[0,1],xmm2[2,3],xmm0[4,5],xmm2[6,7]
; SSE-NEXT:    pblendw {{.*#+}} xmm1 = xmm1[0,1],xmm2[2,3],xmm1[4,5],xmm2[6,7]
; SSE-NEXT:    pmuludq %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX2-LABEL: combine_shuffle_zero_pmuludq:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; AVX2-NEXT:    vpblendd {{.*#+}} xmm0 = xmm0[0],xmm2[1],xmm0[2],xmm2[3]
; AVX2-NEXT:    vpblendd {{.*#+}} xmm1 = xmm1[0],xmm2[1],xmm1[2],xmm2[3]
; AVX2-NEXT:    vpmuludq %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    retq
;
; AVX512VL-LABEL: combine_shuffle_zero_pmuludq:
; AVX512VL:       # %bb.0:
; AVX512VL-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; AVX512VL-NEXT:    vpblendd {{.*#+}} xmm0 = xmm0[0],xmm2[1],xmm0[2],xmm2[3]
; AVX512VL-NEXT:    vpblendd {{.*#+}} xmm1 = xmm1[0],xmm2[1],xmm1[2],xmm2[3]
; AVX512VL-NEXT:    vpmuludq %xmm1, %xmm0, %xmm0
; AVX512VL-NEXT:    retq
;
; AVX512DQVL-LABEL: combine_shuffle_zero_pmuludq:
; AVX512DQVL:       # %bb.0:
; AVX512DQVL-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; AVX512DQVL-NEXT:    vpblendd {{.*#+}} xmm0 = xmm0[0],xmm2[1],xmm0[2],xmm2[3]
; AVX512DQVL-NEXT:    vpblendd {{.*#+}} xmm1 = xmm1[0],xmm2[1],xmm1[2],xmm2[3]
; AVX512DQVL-NEXT:    vpmullq %xmm1, %xmm0, %xmm0
; AVX512DQVL-NEXT:    retq
  %1 = shufflevector <4 x i32> %a0, <4 x i32> zeroinitializer, <4 x i32> <i32 0, i32 5, i32 2, i32 7>
  %2 = shufflevector <4 x i32> %a1, <4 x i32> zeroinitializer, <4 x i32> <i32 0, i32 5, i32 2, i32 7>
  %3 = bitcast <4 x i32> %1 to <2 x i64>
  %4 = bitcast <4 x i32> %2 to <2 x i64>
  %5 = mul <2 x i64> %3, %4
  ret <2 x i64> %5
}

; TODO - blends are superfluous
define <4 x i64> @combine_shuffle_zero_pmuludq_256(<8 x i32> %a0, <8 x i32> %a1) {
; SSE-LABEL: combine_shuffle_zero_pmuludq_256:
; SSE:       # %bb.0:
; SSE-NEXT:    pxor %xmm4, %xmm4
; SSE-NEXT:    pblendw {{.*#+}} xmm1 = xmm1[0,1],xmm4[2,3],xmm1[4,5],xmm4[6,7]
; SSE-NEXT:    pblendw {{.*#+}} xmm0 = xmm0[0,1],xmm4[2,3],xmm0[4,5],xmm4[6,7]
; SSE-NEXT:    pblendw {{.*#+}} xmm3 = xmm3[0,1],xmm4[2,3],xmm3[4,5],xmm4[6,7]
; SSE-NEXT:    pmuludq %xmm3, %xmm1
; SSE-NEXT:    pblendw {{.*#+}} xmm2 = xmm2[0,1],xmm4[2,3],xmm2[4,5],xmm4[6,7]
; SSE-NEXT:    pmuludq %xmm2, %xmm0
; SSE-NEXT:    retq
;
; AVX2-LABEL: combine_shuffle_zero_pmuludq_256:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; AVX2-NEXT:    vpblendd {{.*#+}} ymm0 = ymm0[0],ymm2[1],ymm0[2],ymm2[3],ymm0[4],ymm2[5],ymm0[6],ymm2[7]
; AVX2-NEXT:    vpblendd {{.*#+}} ymm1 = ymm1[0],ymm2[1],ymm1[2],ymm2[3],ymm1[4],ymm2[5],ymm1[6],ymm2[7]
; AVX2-NEXT:    vpmuludq %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
;
; AVX512VL-LABEL: combine_shuffle_zero_pmuludq_256:
; AVX512VL:       # %bb.0:
; AVX512VL-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; AVX512VL-NEXT:    vpblendd {{.*#+}} ymm0 = ymm0[0],ymm2[1],ymm0[2],ymm2[3],ymm0[4],ymm2[5],ymm0[6],ymm2[7]
; AVX512VL-NEXT:    vpblendd {{.*#+}} ymm1 = ymm1[0],ymm2[1],ymm1[2],ymm2[3],ymm1[4],ymm2[5],ymm1[6],ymm2[7]
; AVX512VL-NEXT:    vpmuludq %ymm1, %ymm0, %ymm0
; AVX512VL-NEXT:    retq
;
; AVX512DQVL-LABEL: combine_shuffle_zero_pmuludq_256:
; AVX512DQVL:       # %bb.0:
; AVX512DQVL-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; AVX512DQVL-NEXT:    vpblendd {{.*#+}} ymm0 = ymm0[0],ymm2[1],ymm0[2],ymm2[3],ymm0[4],ymm2[5],ymm0[6],ymm2[7]
; AVX512DQVL-NEXT:    vpblendd {{.*#+}} ymm1 = ymm1[0],ymm2[1],ymm1[2],ymm2[3],ymm1[4],ymm2[5],ymm1[6],ymm2[7]
; AVX512DQVL-NEXT:    vpmullq %ymm1, %ymm0, %ymm0
; AVX512DQVL-NEXT:    retq
  %1 = shufflevector <8 x i32> %a0, <8 x i32> zeroinitializer, <8 x i32> <i32 0, i32 9, i32 2, i32 11, i32 4, i32 13, i32 6, i32 15>
  %2 = shufflevector <8 x i32> %a1, <8 x i32> zeroinitializer, <8 x i32> <i32 0, i32 9, i32 2, i32 11, i32 4, i32 13, i32 6, i32 15>
  %3 = bitcast <8 x i32> %1 to <4 x i64>
  %4 = bitcast <8 x i32> %2 to <4 x i64>
  %5 = mul <4 x i64> %3, %4
  ret <4 x i64> %5
}

define <8 x i64> @combine_zext_pmuludq_256(<8 x i32> %a) {
; SSE-LABEL: combine_zext_pmuludq_256:
; SSE:       # %bb.0:
; SSE-NEXT:    pshufd {{.*#+}} xmm2 = xmm1[2,3,0,1]
; SSE-NEXT:    pmovzxdq {{.*#+}} xmm3 = xmm2[0],zero,xmm2[1],zero
; SSE-NEXT:    pshufd {{.*#+}} xmm2 = xmm0[2,3,0,1]
; SSE-NEXT:    pmovzxdq {{.*#+}} xmm4 = xmm2[0],zero,xmm2[1],zero
; SSE-NEXT:    pmovzxdq {{.*#+}} xmm2 = xmm1[0],zero,xmm1[1],zero
; SSE-NEXT:    pmovzxdq {{.*#+}} xmm0 = xmm0[0],zero,xmm0[1],zero
; SSE-NEXT:    movdqa {{.*#+}} xmm1 = [715827883,715827883]
; SSE-NEXT:    pmuludq %xmm1, %xmm0
; SSE-NEXT:    pmuludq %xmm1, %xmm2
; SSE-NEXT:    pmuludq %xmm1, %xmm4
; SSE-NEXT:    pmuludq %xmm1, %xmm3
; SSE-NEXT:    movdqa %xmm4, %xmm1
; SSE-NEXT:    retq
;
; AVX2-LABEL: combine_zext_pmuludq_256:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX2-NEXT:    vpmovzxdq {{.*#+}} ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero
; AVX2-NEXT:    vpmovzxdq {{.*#+}} ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero
; AVX2-NEXT:    vpbroadcastq {{.*#+}} ymm2 = [715827883,715827883,715827883,715827883]
; AVX2-NEXT:    vpmuludq %ymm2, %ymm0, %ymm0
; AVX2-NEXT:    vpmuludq %ymm2, %ymm1, %ymm1
; AVX2-NEXT:    retq
;
; AVX512VL-LABEL: combine_zext_pmuludq_256:
; AVX512VL:       # %bb.0:
; AVX512VL-NEXT:    vpmovzxdq {{.*#+}} zmm0 = ymm0[0],zero,ymm0[1],zero,ymm0[2],zero,ymm0[3],zero,ymm0[4],zero,ymm0[5],zero,ymm0[6],zero,ymm0[7],zero
; AVX512VL-NEXT:    vpmuludq {{.*}}(%rip){1to8}, %zmm0, %zmm0
; AVX512VL-NEXT:    retq
;
; AVX512DQVL-LABEL: combine_zext_pmuludq_256:
; AVX512DQVL:       # %bb.0:
; AVX512DQVL-NEXT:    vpmovzxdq {{.*#+}} zmm0 = ymm0[0],zero,ymm0[1],zero,ymm0[2],zero,ymm0[3],zero,ymm0[4],zero,ymm0[5],zero,ymm0[6],zero,ymm0[7],zero
; AVX512DQVL-NEXT:    vpmuludq {{.*}}(%rip){1to8}, %zmm0, %zmm0
; AVX512DQVL-NEXT:    retq
  %1 = zext <8 x i32> %a to <8 x i64>
  %2 = mul nuw nsw <8 x i64> %1, <i64 715827883, i64 715827883, i64 715827883, i64 715827883, i64 715827883, i64 715827883, i64 715827883, i64 715827883>
  ret <8 x i64> %2
}
