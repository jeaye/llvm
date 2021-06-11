; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mattr=+avx512vl | FileCheck %s --check-prefix=X64-AVX512 --check-prefix=X64-AVX512VL
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mattr=+avx512bw,+avx512vl | FileCheck %s --check-prefix=X64-AVX512 --check-prefix=X64-AVX512BWVL
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mattr=+avx512dq,+avx512vl | FileCheck %s --check-prefix=X64-AVX512 --check-prefix=X64-AVX512DQVL

define <8 x double> @test_broadcast_4f64_8f64(<4 x double> *%p) nounwind {
; X64-AVX512-LABEL: test_broadcast_4f64_8f64:
; X64-AVX512:       ## %bb.0:
; X64-AVX512-NEXT:    vbroadcastf64x4 {{.*#+}} zmm0 = mem[0,1,2,3,0,1,2,3]
; X64-AVX512-NEXT:    vaddpd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %zmm0, %zmm0
; X64-AVX512-NEXT:    retq
 %1 = load <4 x double>, <4 x double> *%p
 %2 = shufflevector <4 x double> %1, <4 x double> undef, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 2, i32 3>
 %3 = fadd <8 x double> %2, <double 1.0, double 2.0, double 3.0, double 4.0, double 5.0, double 6.0, double 7.0, double 8.0>
 ret <8 x double> %3
}

define <8 x i64> @test_broadcast_4i64_8i64(<4 x i64> *%p) nounwind {
; X64-AVX512-LABEL: test_broadcast_4i64_8i64:
; X64-AVX512:       ## %bb.0:
; X64-AVX512-NEXT:    vbroadcasti64x4 {{.*#+}} zmm0 = mem[0,1,2,3,0,1,2,3]
; X64-AVX512-NEXT:    vpaddq {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %zmm0, %zmm0
; X64-AVX512-NEXT:    retq
 %1 = load <4 x i64>, <4 x i64> *%p
 %2 = shufflevector <4 x i64> %1, <4 x i64> undef, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 2, i32 3>
 %3 = add <8 x i64> %2, <i64 1, i64 2, i64 3, i64 4, i64 5, i64 6, i64 7, i64 8>
 ret <8 x i64> %3
}

define <16 x float> @test_broadcast_8f32_16f32(<8 x float> *%p) nounwind {
; X64-AVX512-LABEL: test_broadcast_8f32_16f32:
; X64-AVX512:       ## %bb.0:
; X64-AVX512-NEXT:    vbroadcastf64x4 {{.*#+}} zmm0 = mem[0,1,2,3,0,1,2,3]
; X64-AVX512-NEXT:    vaddps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %zmm0, %zmm0
; X64-AVX512-NEXT:    retq
 %1 = load <8 x float>, <8 x float> *%p
 %2 = shufflevector <8 x float> %1, <8 x float> undef, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
 %3 = fadd <16 x float> %2, <float 1.0, float 2.0, float 3.0, float 4.0, float 5.0, float 6.0, float 7.0, float 8.0, float 9.0, float 10.0, float 11.0, float 12.0, float 13.0, float 14.0, float 15.0, float 16.0>
 ret <16 x float> %3
}

define <16 x i32> @test_broadcast_8i32_16i32(<8 x i32> *%p) nounwind {
; X64-AVX512-LABEL: test_broadcast_8i32_16i32:
; X64-AVX512:       ## %bb.0:
; X64-AVX512-NEXT:    vbroadcasti64x4 {{.*#+}} zmm0 = mem[0,1,2,3,0,1,2,3]
; X64-AVX512-NEXT:    vpaddd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %zmm0, %zmm0
; X64-AVX512-NEXT:    retq
 %1 = load <8 x i32>, <8 x i32> *%p
 %2 = shufflevector <8 x i32> %1, <8 x i32> undef, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
 %3 = add <16 x i32> %2, <i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16>
 ret <16 x i32> %3
}

define <32 x i16> @test_broadcast_16i16_32i16(<16 x i16> *%p) nounwind {
; X64-AVX512VL-LABEL: test_broadcast_16i16_32i16:
; X64-AVX512VL:       ## %bb.0:
; X64-AVX512VL-NEXT:    vmovdqa (%rdi), %ymm0
; X64-AVX512VL-NEXT:    vpaddw {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %ymm1
; X64-AVX512VL-NEXT:    vpaddw {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %ymm0
; X64-AVX512VL-NEXT:    vinserti64x4 $1, %ymm0, %zmm1, %zmm0
; X64-AVX512VL-NEXT:    retq
;
; X64-AVX512BWVL-LABEL: test_broadcast_16i16_32i16:
; X64-AVX512BWVL:       ## %bb.0:
; X64-AVX512BWVL-NEXT:    vbroadcasti64x4 {{.*#+}} zmm0 = mem[0,1,2,3,0,1,2,3]
; X64-AVX512BWVL-NEXT:    vpaddw {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %zmm0, %zmm0
; X64-AVX512BWVL-NEXT:    retq
;
; X64-AVX512DQVL-LABEL: test_broadcast_16i16_32i16:
; X64-AVX512DQVL:       ## %bb.0:
; X64-AVX512DQVL-NEXT:    vmovdqa (%rdi), %ymm0
; X64-AVX512DQVL-NEXT:    vpaddw {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %ymm1
; X64-AVX512DQVL-NEXT:    vpaddw {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %ymm0
; X64-AVX512DQVL-NEXT:    vinserti64x4 $1, %ymm0, %zmm1, %zmm0
; X64-AVX512DQVL-NEXT:    retq
 %1 = load <16 x i16>, <16 x i16> *%p
 %2 = shufflevector <16 x i16> %1, <16 x i16> undef, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
 %3  = add <32 x i16> %2, <i16 1, i16 2, i16 3, i16 4, i16 5, i16 6, i16 7, i16 8, i16 9, i16 10, i16 11, i16 12, i16 13, i16 14, i16 15, i16 16, i16 17, i16 18, i16 19, i16 20, i16 21, i16 22, i16 23, i16 24, i16 25, i16 26, i16 27, i16 28, i16 29, i16 30, i16 31, i16 32>
 ret <32 x i16> %3
}

define <64 x i8> @test_broadcast_32i8_64i8(<32 x i8> *%p) nounwind {
; X64-AVX512VL-LABEL: test_broadcast_32i8_64i8:
; X64-AVX512VL:       ## %bb.0:
; X64-AVX512VL-NEXT:    vmovdqa (%rdi), %ymm0
; X64-AVX512VL-NEXT:    vpaddb {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %ymm1
; X64-AVX512VL-NEXT:    vpaddb {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %ymm0
; X64-AVX512VL-NEXT:    vinserti64x4 $1, %ymm0, %zmm1, %zmm0
; X64-AVX512VL-NEXT:    retq
;
; X64-AVX512BWVL-LABEL: test_broadcast_32i8_64i8:
; X64-AVX512BWVL:       ## %bb.0:
; X64-AVX512BWVL-NEXT:    vbroadcasti64x4 {{.*#+}} zmm0 = mem[0,1,2,3,0,1,2,3]
; X64-AVX512BWVL-NEXT:    vpaddb {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %zmm0, %zmm0
; X64-AVX512BWVL-NEXT:    retq
;
; X64-AVX512DQVL-LABEL: test_broadcast_32i8_64i8:
; X64-AVX512DQVL:       ## %bb.0:
; X64-AVX512DQVL-NEXT:    vmovdqa (%rdi), %ymm0
; X64-AVX512DQVL-NEXT:    vpaddb {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %ymm1
; X64-AVX512DQVL-NEXT:    vpaddb {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %ymm0
; X64-AVX512DQVL-NEXT:    vinserti64x4 $1, %ymm0, %zmm1, %zmm0
; X64-AVX512DQVL-NEXT:    retq
 %1 = load <32 x i8>, <32 x i8> *%p
 %2 = shufflevector <32 x i8> %1, <32 x i8> undef, <64 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
 %3 = add <64 x i8> %2, <i8 1, i8 2, i8 3, i8 4, i8 5, i8 6, i8 7, i8 8, i8 9, i8 10, i8 11, i8 12, i8 13, i8 14, i8 15, i8 16, i8 17, i8 18, i8 19, i8 20, i8 21, i8 22, i8 23, i8 24, i8 25, i8 26, i8 27, i8 28, i8 29, i8 30, i8 31, i8 32, i8 33, i8 34, i8 35, i8 36, i8 37, i8 38, i8 39, i8 40, i8 41, i8 42, i8 43, i8 44, i8 45, i8 46, i8 47, i8 48, i8 49, i8 50, i8 51, i8 52, i8 53, i8 54, i8 55, i8 56, i8 57, i8 58, i8 59, i8 60, i8 61, i8 62, i8 63, i8 64>
 ret <64 x i8> %3
}
