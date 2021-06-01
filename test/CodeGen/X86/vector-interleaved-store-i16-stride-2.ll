; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx2 | FileCheck --check-prefixes=AVX2 %s
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx2,+fast-variable-crosslane-shuffle,+fast-variable-perlane-shuffle | FileCheck --check-prefixes=AVX2 %s
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx2,+fast-variable-perlane-shuffle | FileCheck --check-prefixes=AVX2 %s

; These patterns are produced by LoopVectorizer for interleaved stores.

define void @vf2(<2 x i16>* %in.vecptr0, <2 x i16>* %in.vecptr1, <4 x i16>* %out.vec) nounwind {
; AVX2-LABEL: vf2:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovdqa (%rdi), %xmm0
; AVX2-NEXT:    vpunpcklwd {{.*#+}} xmm0 = xmm0[0],mem[0],xmm0[1],mem[1],xmm0[2],mem[2],xmm0[3],mem[3]
; AVX2-NEXT:    vmovq %xmm0, (%rdx)
; AVX2-NEXT:    retq
  %in.vec0 = load <2 x i16>, <2 x i16>* %in.vecptr0, align 32
  %in.vec1 = load <2 x i16>, <2 x i16>* %in.vecptr1, align 32

  %concat01 = shufflevector <2 x i16> %in.vec0, <2 x i16> %in.vec1, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %interleaved.vec = shufflevector <4 x i16> %concat01, <4 x i16> poison, <4 x i32> <i32 0, i32 2, i32 1, i32 3>

  store <4 x i16> %interleaved.vec, <4 x i16>* %out.vec, align 32

  ret void
}

define void @vf4(<4 x i16>* %in.vecptr0, <4 x i16>* %in.vecptr1, <8 x i16>* %out.vec) nounwind {
; AVX2-LABEL: vf4:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovq {{.*#+}} xmm0 = mem[0],zero
; AVX2-NEXT:    vmovq {{.*#+}} xmm1 = mem[0],zero
; AVX2-NEXT:    vpunpcklwd {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1],xmm0[2],xmm1[2],xmm0[3],xmm1[3]
; AVX2-NEXT:    vmovdqa %xmm0, (%rdx)
; AVX2-NEXT:    retq
  %in.vec0 = load <4 x i16>, <4 x i16>* %in.vecptr0, align 32
  %in.vec1 = load <4 x i16>, <4 x i16>* %in.vecptr1, align 32

  %concat01 = shufflevector <4 x i16> %in.vec0, <4 x i16> %in.vec1, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %interleaved.vec = shufflevector <8 x i16> %concat01, <8 x i16> poison, <8 x i32> <i32 0, i32 4, i32 1, i32 5, i32 2, i32 6, i32 3, i32 7>

  store <8 x i16> %interleaved.vec, <8 x i16>* %out.vec, align 32

  ret void
}

define void @vf8(<8 x i16>* %in.vecptr0, <8 x i16>* %in.vecptr1, <16 x i16>* %out.vec) nounwind {
; AVX2-LABEL: vf8:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovdqa (%rdi), %xmm0
; AVX2-NEXT:    vinserti128 $1, (%rsi), %ymm0, %ymm0
; AVX2-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[0,2,1,3]
; AVX2-NEXT:    vpshufb {{.*#+}} ymm0 = ymm0[0,1,8,9,2,3,10,11,4,5,12,13,6,7,14,15,16,17,24,25,18,19,26,27,20,21,28,29,22,23,30,31]
; AVX2-NEXT:    vmovdqa %ymm0, (%rdx)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
  %in.vec0 = load <8 x i16>, <8 x i16>* %in.vecptr0, align 32
  %in.vec1 = load <8 x i16>, <8 x i16>* %in.vecptr1, align 32

  %concat01 = shufflevector <8 x i16> %in.vec0, <8 x i16> %in.vec1, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %interleaved.vec = shufflevector <16 x i16> %concat01, <16 x i16> poison, <16 x i32> <i32 0, i32 8, i32 1, i32 9, i32 2, i32 10, i32 3, i32 11, i32 4, i32 12, i32 5, i32 13, i32 6, i32 14, i32 7, i32 15>

  store <16 x i16> %interleaved.vec, <16 x i16>* %out.vec, align 32

  ret void
}

define void @vf16(<16 x i16>* %in.vecptr0, <16 x i16>* %in.vecptr1, <32 x i16>* %out.vec) nounwind {
; AVX2-LABEL: vf16:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovdqa (%rsi), %xmm0
; AVX2-NEXT:    vmovdqa 16(%rsi), %xmm1
; AVX2-NEXT:    vmovdqa (%rdi), %xmm2
; AVX2-NEXT:    vmovdqa 16(%rdi), %xmm3
; AVX2-NEXT:    vpunpckhwd {{.*#+}} xmm4 = xmm2[4],xmm0[4],xmm2[5],xmm0[5],xmm2[6],xmm0[6],xmm2[7],xmm0[7]
; AVX2-NEXT:    vpunpcklwd {{.*#+}} xmm0 = xmm2[0],xmm0[0],xmm2[1],xmm0[1],xmm2[2],xmm0[2],xmm2[3],xmm0[3]
; AVX2-NEXT:    vpunpckhwd {{.*#+}} xmm2 = xmm3[4],xmm1[4],xmm3[5],xmm1[5],xmm3[6],xmm1[6],xmm3[7],xmm1[7]
; AVX2-NEXT:    vpunpcklwd {{.*#+}} xmm1 = xmm3[0],xmm1[0],xmm3[1],xmm1[1],xmm3[2],xmm1[2],xmm3[3],xmm1[3]
; AVX2-NEXT:    vmovdqa %xmm1, 32(%rdx)
; AVX2-NEXT:    vmovdqa %xmm2, 48(%rdx)
; AVX2-NEXT:    vmovdqa %xmm0, (%rdx)
; AVX2-NEXT:    vmovdqa %xmm4, 16(%rdx)
; AVX2-NEXT:    retq
  %in.vec0 = load <16 x i16>, <16 x i16>* %in.vecptr0, align 32
  %in.vec1 = load <16 x i16>, <16 x i16>* %in.vecptr1, align 32

  %concat01 = shufflevector <16 x i16> %in.vec0, <16 x i16> %in.vec1, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %interleaved.vec = shufflevector <32 x i16> %concat01, <32 x i16> poison, <32 x i32> <i32 0, i32 16, i32 1, i32 17, i32 2, i32 18, i32 3, i32 19, i32 4, i32 20, i32 5, i32 21, i32 6, i32 22, i32 7, i32 23, i32 8, i32 24, i32 9, i32 25, i32 10, i32 26, i32 11, i32 27, i32 12, i32 28, i32 13, i32 29, i32 14, i32 30, i32 15, i32 31>

  store <32 x i16> %interleaved.vec, <32 x i16>* %out.vec, align 32

  ret void
}

define void @vf32(<32 x i16>* %in.vecptr0, <32 x i16>* %in.vecptr1, <64 x i16>* %out.vec) nounwind {
; AVX2-LABEL: vf32:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovdqa (%rsi), %xmm0
; AVX2-NEXT:    vmovdqa 16(%rsi), %xmm1
; AVX2-NEXT:    vmovdqa 32(%rsi), %xmm2
; AVX2-NEXT:    vmovdqa 48(%rsi), %xmm3
; AVX2-NEXT:    vmovdqa (%rdi), %xmm4
; AVX2-NEXT:    vmovdqa 16(%rdi), %xmm5
; AVX2-NEXT:    vmovdqa 32(%rdi), %xmm6
; AVX2-NEXT:    vmovdqa 48(%rdi), %xmm7
; AVX2-NEXT:    vpunpckhwd {{.*#+}} xmm8 = xmm6[4],xmm2[4],xmm6[5],xmm2[5],xmm6[6],xmm2[6],xmm6[7],xmm2[7]
; AVX2-NEXT:    vpunpcklwd {{.*#+}} xmm2 = xmm6[0],xmm2[0],xmm6[1],xmm2[1],xmm6[2],xmm2[2],xmm6[3],xmm2[3]
; AVX2-NEXT:    vpunpckhwd {{.*#+}} xmm6 = xmm7[4],xmm3[4],xmm7[5],xmm3[5],xmm7[6],xmm3[6],xmm7[7],xmm3[7]
; AVX2-NEXT:    vpunpcklwd {{.*#+}} xmm3 = xmm7[0],xmm3[0],xmm7[1],xmm3[1],xmm7[2],xmm3[2],xmm7[3],xmm3[3]
; AVX2-NEXT:    vpunpckhwd {{.*#+}} xmm7 = xmm5[4],xmm1[4],xmm5[5],xmm1[5],xmm5[6],xmm1[6],xmm5[7],xmm1[7]
; AVX2-NEXT:    vpunpcklwd {{.*#+}} xmm1 = xmm5[0],xmm1[0],xmm5[1],xmm1[1],xmm5[2],xmm1[2],xmm5[3],xmm1[3]
; AVX2-NEXT:    vpunpckhwd {{.*#+}} xmm5 = xmm4[4],xmm0[4],xmm4[5],xmm0[5],xmm4[6],xmm0[6],xmm4[7],xmm0[7]
; AVX2-NEXT:    vpunpcklwd {{.*#+}} xmm0 = xmm4[0],xmm0[0],xmm4[1],xmm0[1],xmm4[2],xmm0[2],xmm4[3],xmm0[3]
; AVX2-NEXT:    vmovdqa %xmm0, (%rdx)
; AVX2-NEXT:    vmovdqa %xmm5, 16(%rdx)
; AVX2-NEXT:    vmovdqa %xmm1, 32(%rdx)
; AVX2-NEXT:    vmovdqa %xmm7, 48(%rdx)
; AVX2-NEXT:    vmovdqa %xmm3, 96(%rdx)
; AVX2-NEXT:    vmovdqa %xmm6, 112(%rdx)
; AVX2-NEXT:    vmovdqa %xmm2, 64(%rdx)
; AVX2-NEXT:    vmovdqa %xmm8, 80(%rdx)
; AVX2-NEXT:    retq
  %in.vec0 = load <32 x i16>, <32 x i16>* %in.vecptr0, align 32
  %in.vec1 = load <32 x i16>, <32 x i16>* %in.vecptr1, align 32

  %concat01 = shufflevector <32 x i16> %in.vec0, <32 x i16> %in.vec1, <64 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %interleaved.vec = shufflevector <64 x i16> %concat01, <64 x i16> poison, <64 x i32> <i32 0, i32 32, i32 1, i32 33, i32 2, i32 34, i32 3, i32 35, i32 4, i32 36, i32 5, i32 37, i32 6, i32 38, i32 7, i32 39, i32 8, i32 40, i32 9, i32 41, i32 10, i32 42, i32 11, i32 43, i32 12, i32 44, i32 13, i32 45, i32 14, i32 46, i32 15, i32 47, i32 16, i32 48, i32 17, i32 49, i32 18, i32 50, i32 19, i32 51, i32 20, i32 52, i32 21, i32 53, i32 22, i32 54, i32 23, i32 55, i32 24, i32 56, i32 25, i32 57, i32 26, i32 58, i32 27, i32 59, i32 28, i32 60, i32 29, i32 61, i32 30, i32 62, i32 31, i32 63>

  store <64 x i16> %interleaved.vec, <64 x i16>* %out.vec, align 32

  ret void
}
