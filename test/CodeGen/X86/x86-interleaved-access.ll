; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64-pc-linux  -mattr=+avx < %s | FileCheck %s --check-prefix=AVX --check-prefix=AVX1
; RUN: llc -mtriple=x86_64-pc-linux  -mattr=+avx2 < %s | FileCheck %s --check-prefix=AVX --check-prefix=AVX2

define <4 x double> @load_factorf64_4(<16 x double>* %ptr) {
; AVX-LABEL: load_factorf64_4:
; AVX:       # BB#0:
; AVX-NEXT:    vmovupd (%rdi), %ymm0
; AVX-NEXT:    vmovupd 32(%rdi), %ymm1
; AVX-NEXT:    vmovupd 64(%rdi), %ymm2
; AVX-NEXT:    vmovupd 96(%rdi), %ymm3
; AVX-NEXT:    vperm2f128 {{.*#+}} ymm4 = ymm0[0,1],ymm2[0,1]
; AVX-NEXT:    vperm2f128 {{.*#+}} ymm5 = ymm1[0,1],ymm3[0,1]
; AVX-NEXT:    vhaddpd %ymm5, %ymm4, %ymm4
; AVX-NEXT:    vperm2f128 {{.*#+}} ymm0 = ymm0[2,3],ymm2[2,3]
; AVX-NEXT:    vperm2f128 {{.*#+}} ymm1 = ymm1[2,3],ymm3[2,3]
; AVX-NEXT:    vunpcklpd {{.*#+}} ymm2 = ymm0[0],ymm1[0],ymm0[2],ymm1[2]
; AVX-NEXT:    vaddpd %ymm2, %ymm4, %ymm2
; AVX-NEXT:    vunpckhpd {{.*#+}} ymm0 = ymm0[1],ymm1[1],ymm0[3],ymm1[3]
; AVX-NEXT:    vaddpd %ymm0, %ymm2, %ymm0
; AVX-NEXT:    retq
  %wide.vec = load <16 x double>, <16 x double>* %ptr, align 16
  %strided.v0 = shufflevector <16 x double> %wide.vec, <16 x double> undef, <4 x i32> <i32 0, i32 4, i32 8, i32 12>
  %strided.v1 = shufflevector <16 x double> %wide.vec, <16 x double> undef, <4 x i32> <i32 1, i32 5, i32 9, i32 13>
  %strided.v2 = shufflevector <16 x double> %wide.vec, <16 x double> undef, <4 x i32> <i32 2, i32 6, i32 10, i32 14>
  %strided.v3 = shufflevector <16 x double> %wide.vec, <16 x double> undef, <4 x i32> <i32 3, i32 7, i32 11, i32 15>
  %add1 = fadd <4 x double> %strided.v0, %strided.v1
  %add2 = fadd <4 x double> %add1, %strided.v2
  %add3 = fadd <4 x double> %add2, %strided.v3
  ret <4 x double> %add3
}

define <4 x double> @load_factorf64_2(<16 x double>* %ptr) {
; AVX-LABEL: load_factorf64_2:
; AVX:       # BB#0:
; AVX-NEXT:    vmovupd (%rdi), %ymm0
; AVX-NEXT:    vmovupd 32(%rdi), %ymm1
; AVX-NEXT:    vmovupd 64(%rdi), %ymm2
; AVX-NEXT:    vmovupd 96(%rdi), %ymm3
; AVX-NEXT:    vperm2f128 {{.*#+}} ymm4 = ymm0[0,1],ymm2[0,1]
; AVX-NEXT:    vperm2f128 {{.*#+}} ymm5 = ymm1[0,1],ymm3[0,1]
; AVX-NEXT:    vunpcklpd {{.*#+}} ymm4 = ymm4[0],ymm5[0],ymm4[2],ymm5[2]
; AVX-NEXT:    vperm2f128 {{.*#+}} ymm0 = ymm0[2,3],ymm2[2,3]
; AVX-NEXT:    vperm2f128 {{.*#+}} ymm1 = ymm1[2,3],ymm3[2,3]
; AVX-NEXT:    vunpckhpd {{.*#+}} ymm0 = ymm0[1],ymm1[1],ymm0[3],ymm1[3]
; AVX-NEXT:    vmulpd %ymm0, %ymm4, %ymm0
; AVX-NEXT:    retq
  %wide.vec = load <16 x double>, <16 x double>* %ptr, align 16
  %strided.v0 = shufflevector <16 x double> %wide.vec, <16 x double> undef, <4 x i32> <i32 0, i32 4, i32 8, i32 12>
  %strided.v3 = shufflevector <16 x double> %wide.vec, <16 x double> undef, <4 x i32> <i32 3, i32 7, i32 11, i32 15>
  %mul = fmul <4 x double> %strided.v0, %strided.v3
  ret <4 x double> %mul
}

define <4 x double> @load_factorf64_1(<16 x double>* %ptr) {
; AVX-LABEL: load_factorf64_1:
; AVX:       # BB#0:
; AVX-NEXT:    vmovupd (%rdi), %ymm0
; AVX-NEXT:    vmovupd 32(%rdi), %ymm1
; AVX-NEXT:    vperm2f128 {{.*#+}} ymm0 = ymm0[0,1],mem[0,1]
; AVX-NEXT:    vperm2f128 {{.*#+}} ymm1 = ymm1[0,1],mem[0,1]
; AVX-NEXT:    vunpcklpd {{.*#+}} ymm0 = ymm0[0],ymm1[0],ymm0[2],ymm1[2]
; AVX-NEXT:    vmulpd %ymm0, %ymm0, %ymm0
; AVX-NEXT:    retq
  %wide.vec = load <16 x double>, <16 x double>* %ptr, align 16
  %strided.v0 = shufflevector <16 x double> %wide.vec, <16 x double> undef, <4 x i32> <i32 0, i32 4, i32 8, i32 12>
  %strided.v3 = shufflevector <16 x double> %wide.vec, <16 x double> undef, <4 x i32> <i32 0, i32 4, i32 8, i32 12>
  %mul = fmul <4 x double> %strided.v0, %strided.v3
  ret <4 x double> %mul
}

define <4 x i64> @load_factori64_4(<16 x i64>* %ptr) {
; AVX1-LABEL: load_factori64_4:
; AVX1:       # BB#0:
; AVX1-NEXT:    vmovupd (%rdi), %ymm0
; AVX1-NEXT:    vmovupd 32(%rdi), %ymm1
; AVX1-NEXT:    vmovupd 64(%rdi), %ymm2
; AVX1-NEXT:    vmovupd 96(%rdi), %ymm3
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm4 = ymm0[0,1],ymm2[0,1]
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm5 = ymm1[0,1],ymm3[0,1]
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm0 = ymm0[2,3],ymm2[2,3]
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm1 = ymm1[2,3],ymm3[2,3]
; AVX1-NEXT:    vunpcklpd {{.*#+}} ymm2 = ymm4[0],ymm5[0],ymm4[2],ymm5[2]
; AVX1-NEXT:    vunpcklpd {{.*#+}} ymm3 = ymm0[0],ymm1[0],ymm0[2],ymm1[2]
; AVX1-NEXT:    vunpckhpd {{.*#+}} ymm4 = ymm4[1],ymm5[1],ymm4[3],ymm5[3]
; AVX1-NEXT:    vunpckhpd {{.*#+}} ymm0 = ymm0[1],ymm1[1],ymm0[3],ymm1[3]
; AVX1-NEXT:    vextractf128 $1, %ymm4, %xmm1
; AVX1-NEXT:    vextractf128 $1, %ymm2, %xmm5
; AVX1-NEXT:    vpaddq %xmm3, %xmm4, %xmm4
; AVX1-NEXT:    vextractf128 $1, %ymm3, %xmm3
; AVX1-NEXT:    vpaddq %xmm3, %xmm1, %xmm1
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm3
; AVX1-NEXT:    vpaddq %xmm3, %xmm1, %xmm1
; AVX1-NEXT:    vpaddq %xmm1, %xmm5, %xmm1
; AVX1-NEXT:    vpaddq %xmm0, %xmm4, %xmm0
; AVX1-NEXT:    vpaddq %xmm0, %xmm2, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: load_factori64_4:
; AVX2:       # BB#0:
; AVX2-NEXT:    vmovdqu (%rdi), %ymm0
; AVX2-NEXT:    vmovdqu 32(%rdi), %ymm1
; AVX2-NEXT:    vmovdqu 64(%rdi), %ymm2
; AVX2-NEXT:    vmovdqu 96(%rdi), %ymm3
; AVX2-NEXT:    vperm2i128 {{.*#+}} ymm4 = ymm0[0,1],ymm2[0,1]
; AVX2-NEXT:    vperm2i128 {{.*#+}} ymm5 = ymm1[0,1],ymm3[0,1]
; AVX2-NEXT:    vperm2i128 {{.*#+}} ymm0 = ymm0[2,3],ymm2[2,3]
; AVX2-NEXT:    vperm2i128 {{.*#+}} ymm1 = ymm1[2,3],ymm3[2,3]
; AVX2-NEXT:    vpunpcklqdq {{.*#+}} ymm2 = ymm4[0],ymm5[0],ymm4[2],ymm5[2]
; AVX2-NEXT:    vpunpcklqdq {{.*#+}} ymm3 = ymm0[0],ymm1[0],ymm0[2],ymm1[2]
; AVX2-NEXT:    vpunpckhqdq {{.*#+}} ymm4 = ymm4[1],ymm5[1],ymm4[3],ymm5[3]
; AVX2-NEXT:    vpaddq %ymm3, %ymm4, %ymm3
; AVX2-NEXT:    vpunpckhqdq {{.*#+}} ymm0 = ymm0[1],ymm1[1],ymm0[3],ymm1[3]
; AVX2-NEXT:    vpaddq %ymm0, %ymm3, %ymm0
; AVX2-NEXT:    vpaddq %ymm0, %ymm2, %ymm0
; AVX2-NEXT:    retq
  %wide.vec = load <16 x i64>, <16 x i64>* %ptr, align 16
  %strided.v0 = shufflevector <16 x i64> %wide.vec, <16 x i64> undef, <4 x i32> <i32 0, i32 4, i32 8, i32 12>
  %strided.v1 = shufflevector <16 x i64> %wide.vec, <16 x i64> undef, <4 x i32> <i32 1, i32 5, i32 9, i32 13>
  %strided.v2 = shufflevector <16 x i64> %wide.vec, <16 x i64> undef, <4 x i32> <i32 2, i32 6, i32 10, i32 14>
  %strided.v3 = shufflevector <16 x i64> %wide.vec, <16 x i64> undef, <4 x i32> <i32 3, i32 7, i32 11, i32 15>
  %add1 = add <4 x i64> %strided.v0, %strided.v1
  %add2 = add <4 x i64> %add1, %strided.v2
  %add3 = add <4 x i64> %add2, %strided.v3
  ret <4 x i64> %add3
}

define void @store_factorf64_4(<16 x double>* %ptr, <4 x double> %v0, <4 x double> %v1, <4 x double> %v2, <4 x double> %v3) {
; AVX-LABEL: store_factorf64_4:
; AVX:       # BB#0:
; AVX-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm4
; AVX-NEXT:    vinsertf128 $1, %xmm3, %ymm1, %ymm5
; AVX-NEXT:    vperm2f128 {{.*#+}} ymm0 = ymm0[2,3],ymm2[2,3]
; AVX-NEXT:    vperm2f128 {{.*#+}} ymm1 = ymm1[2,3],ymm3[2,3]
; AVX-NEXT:    vunpcklpd {{.*#+}} ymm2 = ymm4[0],ymm5[0],ymm4[2],ymm5[2]
; AVX-NEXT:    vunpcklpd {{.*#+}} ymm3 = ymm0[0],ymm1[0],ymm0[2],ymm1[2]
; AVX-NEXT:    vunpckhpd {{.*#+}} ymm4 = ymm4[1],ymm5[1],ymm4[3],ymm5[3]
; AVX-NEXT:    vunpckhpd {{.*#+}} ymm0 = ymm0[1],ymm1[1],ymm0[3],ymm1[3]
; AVX-NEXT:    vmovupd %ymm0, 96(%rdi)
; AVX-NEXT:    vmovupd %ymm3, 64(%rdi)
; AVX-NEXT:    vmovupd %ymm4, 32(%rdi)
; AVX-NEXT:    vmovupd %ymm2, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
  %s0 = shufflevector <4 x double> %v0, <4 x double> %v1, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %s1 = shufflevector <4 x double> %v2, <4 x double> %v3, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %interleaved.vec = shufflevector <8 x double> %s0, <8 x double> %s1, <16 x i32> <i32 0, i32 4, i32 8, i32 12, i32 1, i32 5, i32 9, i32 13, i32 2, i32 6, i32 10, i32 14, i32 3, i32 7, i32 11, i32 15>
  store <16 x double> %interleaved.vec, <16 x double>* %ptr, align 16
  ret void
}

define void @store_factori64_4(<16 x i64>* %ptr, <4 x i64> %v0, <4 x i64> %v1, <4 x i64> %v2, <4 x i64> %v3) {
; AVX1-LABEL: store_factori64_4:
; AVX1:       # BB#0:
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm4
; AVX1-NEXT:    vinsertf128 $1, %xmm3, %ymm1, %ymm5
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm0 = ymm0[2,3],ymm2[2,3]
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm1 = ymm1[2,3],ymm3[2,3]
; AVX1-NEXT:    vunpcklpd {{.*#+}} ymm2 = ymm4[0],ymm5[0],ymm4[2],ymm5[2]
; AVX1-NEXT:    vunpcklpd {{.*#+}} ymm3 = ymm0[0],ymm1[0],ymm0[2],ymm1[2]
; AVX1-NEXT:    vunpckhpd {{.*#+}} ymm4 = ymm4[1],ymm5[1],ymm4[3],ymm5[3]
; AVX1-NEXT:    vunpckhpd {{.*#+}} ymm0 = ymm0[1],ymm1[1],ymm0[3],ymm1[3]
; AVX1-NEXT:    vmovupd %ymm0, 96(%rdi)
; AVX1-NEXT:    vmovupd %ymm3, 64(%rdi)
; AVX1-NEXT:    vmovupd %ymm4, 32(%rdi)
; AVX1-NEXT:    vmovupd %ymm2, (%rdi)
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: store_factori64_4:
; AVX2:       # BB#0:
; AVX2-NEXT:    vinserti128 $1, %xmm2, %ymm0, %ymm4
; AVX2-NEXT:    vinserti128 $1, %xmm3, %ymm1, %ymm5
; AVX2-NEXT:    vperm2i128 {{.*#+}} ymm0 = ymm0[2,3],ymm2[2,3]
; AVX2-NEXT:    vperm2i128 {{.*#+}} ymm1 = ymm1[2,3],ymm3[2,3]
; AVX2-NEXT:    vpunpcklqdq {{.*#+}} ymm2 = ymm4[0],ymm5[0],ymm4[2],ymm5[2]
; AVX2-NEXT:    vpunpcklqdq {{.*#+}} ymm3 = ymm0[0],ymm1[0],ymm0[2],ymm1[2]
; AVX2-NEXT:    vpunpckhqdq {{.*#+}} ymm4 = ymm4[1],ymm5[1],ymm4[3],ymm5[3]
; AVX2-NEXT:    vpunpckhqdq {{.*#+}} ymm0 = ymm0[1],ymm1[1],ymm0[3],ymm1[3]
; AVX2-NEXT:    vmovdqu %ymm0, 96(%rdi)
; AVX2-NEXT:    vmovdqu %ymm3, 64(%rdi)
; AVX2-NEXT:    vmovdqu %ymm4, 32(%rdi)
; AVX2-NEXT:    vmovdqu %ymm2, (%rdi)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
  %s0 = shufflevector <4 x i64> %v0, <4 x i64> %v1, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %s1 = shufflevector <4 x i64> %v2, <4 x i64> %v3, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %interleaved.vec = shufflevector <8 x i64> %s0, <8 x i64> %s1, <16 x i32> <i32 0, i32 4, i32 8, i32 12, i32 1, i32 5, i32 9, i32 13, i32 2, i32 6, i32 10, i32 14, i32 3, i32 7, i32 11, i32 15>
  store <16 x i64> %interleaved.vec, <16 x i64>* %ptr, align 16
  ret void
}
