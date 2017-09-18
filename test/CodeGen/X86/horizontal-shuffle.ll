; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-apple-darwin -mattr=+avx2 | FileCheck %s --check-prefix=X32
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mattr=+avx2 | FileCheck %s --check-prefix=X64

;
; 128-bit Vectors
;

define <4 x float> @test_unpackl_fhadd_128(<4 x float> %a0, <4 x float> %a1, <4 x float> %a2, <4 x float> %a3) {
; X32-LABEL: test_unpackl_fhadd_128:
; X32:       ## BB#0:
; X32-NEXT:    vhaddps %xmm1, %xmm0, %xmm0
; X32-NEXT:    vhaddps %xmm3, %xmm2, %xmm1
; X32-NEXT:    vmovlhps {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; X32-NEXT:    retl
;
; X64-LABEL: test_unpackl_fhadd_128:
; X64:       ## BB#0:
; X64-NEXT:    vhaddps %xmm1, %xmm0, %xmm0
; X64-NEXT:    vhaddps %xmm3, %xmm2, %xmm1
; X64-NEXT:    vmovlhps {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; X64-NEXT:    retq
  %1 = call <4 x float> @llvm.x86.sse3.hadd.ps(<4 x float> %a0, <4 x float> %a1)
  %2 = call <4 x float> @llvm.x86.sse3.hadd.ps(<4 x float> %a2, <4 x float> %a3)
  %3 = shufflevector <4 x float> %1, <4 x float> %2, <4 x i32> <i32 0, i32 1, i32 4, i32 5>
  ret <4 x float> %3
}

define <2 x double> @test_unpackh_fhadd_128(<2 x double> %a0, <2 x double> %a1, <2 x double> %a2, <2 x double> %a3) {
; X32-LABEL: test_unpackh_fhadd_128:
; X32:       ## BB#0:
; X32-NEXT:    vhaddpd %xmm1, %xmm0, %xmm0
; X32-NEXT:    vhaddpd %xmm3, %xmm2, %xmm1
; X32-NEXT:    vunpckhpd {{.*#+}} xmm0 = xmm0[1],xmm1[1]
; X32-NEXT:    retl
;
; X64-LABEL: test_unpackh_fhadd_128:
; X64:       ## BB#0:
; X64-NEXT:    vhaddpd %xmm1, %xmm0, %xmm0
; X64-NEXT:    vhaddpd %xmm3, %xmm2, %xmm1
; X64-NEXT:    vunpckhpd {{.*#+}} xmm0 = xmm0[1],xmm1[1]
; X64-NEXT:    retq
  %1 = call <2 x double> @llvm.x86.sse3.hadd.pd(<2 x double> %a0, <2 x double> %a1)
  %2 = call <2 x double> @llvm.x86.sse3.hadd.pd(<2 x double> %a2, <2 x double> %a3)
  %3 = shufflevector <2 x double> %1, <2 x double> %2, <2 x i32> <i32 1, i32 3>
  ret <2 x double> %3
}

define <2 x double> @test_unpackl_fhsub_128(<2 x double> %a0, <2 x double> %a1, <2 x double> %a2, <2 x double> %a3) {
; X32-LABEL: test_unpackl_fhsub_128:
; X32:       ## BB#0:
; X32-NEXT:    vhsubpd %xmm1, %xmm0, %xmm0
; X32-NEXT:    vhsubpd %xmm3, %xmm2, %xmm1
; X32-NEXT:    vunpcklpd {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; X32-NEXT:    retl
;
; X64-LABEL: test_unpackl_fhsub_128:
; X64:       ## BB#0:
; X64-NEXT:    vhsubpd %xmm1, %xmm0, %xmm0
; X64-NEXT:    vhsubpd %xmm3, %xmm2, %xmm1
; X64-NEXT:    vunpcklpd {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; X64-NEXT:    retq
  %1 = call <2 x double> @llvm.x86.sse3.hsub.pd(<2 x double> %a0, <2 x double> %a1)
  %2 = call <2 x double> @llvm.x86.sse3.hsub.pd(<2 x double> %a2, <2 x double> %a3)
  %3 = shufflevector <2 x double> %1, <2 x double> %2, <2 x i32> <i32 0, i32 2>
  ret <2 x double> %3
}

define <4 x float> @test_unpackh_fhsub_128(<4 x float> %a0, <4 x float> %a1, <4 x float> %a2, <4 x float> %a3) {
; X32-LABEL: test_unpackh_fhsub_128:
; X32:       ## BB#0:
; X32-NEXT:    vhsubps %xmm1, %xmm0, %xmm0
; X32-NEXT:    vhsubps %xmm3, %xmm2, %xmm1
; X32-NEXT:    vunpckhpd {{.*#+}} xmm0 = xmm0[1],xmm1[1]
; X32-NEXT:    retl
;
; X64-LABEL: test_unpackh_fhsub_128:
; X64:       ## BB#0:
; X64-NEXT:    vhsubps %xmm1, %xmm0, %xmm0
; X64-NEXT:    vhsubps %xmm3, %xmm2, %xmm1
; X64-NEXT:    vunpckhpd {{.*#+}} xmm0 = xmm0[1],xmm1[1]
; X64-NEXT:    retq
  %1 = call <4 x float> @llvm.x86.sse3.hsub.ps(<4 x float> %a0, <4 x float> %a1)
  %2 = call <4 x float> @llvm.x86.sse3.hsub.ps(<4 x float> %a2, <4 x float> %a3)
  %3 = shufflevector <4 x float> %1, <4 x float> %2, <4 x i32> <i32 2, i32 3, i32 6, i32 7>
  ret <4 x float> %3
}

define <8 x i16> @test_unpackl_hadd_128(<8 x i16> %a0, <8 x i16> %a1, <8 x i16> %a2, <8 x i16> %a3) {
; X32-LABEL: test_unpackl_hadd_128:
; X32:       ## BB#0:
; X32-NEXT:    vphaddw %xmm1, %xmm0, %xmm0
; X32-NEXT:    vphaddw %xmm3, %xmm2, %xmm1
; X32-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; X32-NEXT:    retl
;
; X64-LABEL: test_unpackl_hadd_128:
; X64:       ## BB#0:
; X64-NEXT:    vphaddw %xmm1, %xmm0, %xmm0
; X64-NEXT:    vphaddw %xmm3, %xmm2, %xmm1
; X64-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; X64-NEXT:    retq
  %1 = call <8 x i16> @llvm.x86.ssse3.phadd.w.128(<8 x i16> %a0, <8 x i16> %a1)
  %2 = call <8 x i16> @llvm.x86.ssse3.phadd.w.128(<8 x i16> %a2, <8 x i16> %a3)
  %3 = shufflevector <8 x i16> %1, <8 x i16> %2, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 8, i32 9, i32 10, i32 11>
  ret <8 x i16> %3
}

define <4 x i32> @test_unpackh_hadd_128(<4 x i32> %a0, <4 x i32> %a1, <4 x i32> %a2, <4 x i32> %a3) {
; X32-LABEL: test_unpackh_hadd_128:
; X32:       ## BB#0:
; X32-NEXT:    vphaddd %xmm1, %xmm0, %xmm0
; X32-NEXT:    vphaddd %xmm3, %xmm2, %xmm1
; X32-NEXT:    vpunpckhqdq {{.*#+}} xmm0 = xmm0[1],xmm1[1]
; X32-NEXT:    retl
;
; X64-LABEL: test_unpackh_hadd_128:
; X64:       ## BB#0:
; X64-NEXT:    vphaddd %xmm1, %xmm0, %xmm0
; X64-NEXT:    vphaddd %xmm3, %xmm2, %xmm1
; X64-NEXT:    vpunpckhqdq {{.*#+}} xmm0 = xmm0[1],xmm1[1]
; X64-NEXT:    retq
  %1 = call <4 x i32> @llvm.x86.ssse3.phadd.d.128(<4 x i32> %a0, <4 x i32> %a1)
  %2 = call <4 x i32> @llvm.x86.ssse3.phadd.d.128(<4 x i32> %a2, <4 x i32> %a3)
  %3 = shufflevector <4 x i32> %1, <4 x i32> %2, <4 x i32> <i32 2, i32 3, i32 6, i32 7>
  ret <4 x i32> %3
}

define <4 x i32> @test_unpackl_hsub_128(<4 x i32> %a0, <4 x i32> %a1, <4 x i32> %a2, <4 x i32> %a3) {
; X32-LABEL: test_unpackl_hsub_128:
; X32:       ## BB#0:
; X32-NEXT:    vphsubd %xmm1, %xmm0, %xmm0
; X32-NEXT:    vphsubd %xmm3, %xmm2, %xmm1
; X32-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; X32-NEXT:    retl
;
; X64-LABEL: test_unpackl_hsub_128:
; X64:       ## BB#0:
; X64-NEXT:    vphsubd %xmm1, %xmm0, %xmm0
; X64-NEXT:    vphsubd %xmm3, %xmm2, %xmm1
; X64-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; X64-NEXT:    retq
  %1 = call <4 x i32> @llvm.x86.ssse3.phsub.d.128(<4 x i32> %a0, <4 x i32> %a1)
  %2 = call <4 x i32> @llvm.x86.ssse3.phsub.d.128(<4 x i32> %a2, <4 x i32> %a3)
  %3 = shufflevector <4 x i32> %1, <4 x i32> %2, <4 x i32> <i32 0, i32 1, i32 4, i32 5>
  ret <4 x i32> %3
}

define <8 x i16> @test_unpackh_hsub_128(<8 x i16> %a0, <8 x i16> %a1, <8 x i16> %a2, <8 x i16> %a3) {
; X32-LABEL: test_unpackh_hsub_128:
; X32:       ## BB#0:
; X32-NEXT:    vphsubw %xmm1, %xmm0, %xmm0
; X32-NEXT:    vphsubw %xmm3, %xmm2, %xmm1
; X32-NEXT:    vpunpckhqdq {{.*#+}} xmm0 = xmm0[1],xmm1[1]
; X32-NEXT:    retl
;
; X64-LABEL: test_unpackh_hsub_128:
; X64:       ## BB#0:
; X64-NEXT:    vphsubw %xmm1, %xmm0, %xmm0
; X64-NEXT:    vphsubw %xmm3, %xmm2, %xmm1
; X64-NEXT:    vpunpckhqdq {{.*#+}} xmm0 = xmm0[1],xmm1[1]
; X64-NEXT:    retq
  %1 = call <8 x i16> @llvm.x86.ssse3.phsub.w.128(<8 x i16> %a0, <8 x i16> %a1)
  %2 = call <8 x i16> @llvm.x86.ssse3.phsub.w.128(<8 x i16> %a2, <8 x i16> %a3)
  %3 = shufflevector <8 x i16> %1, <8 x i16> %2, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 12, i32 13, i32 14, i32 15>
  ret <8 x i16> %3
}

define <16 x i8> @test_unpackl_packss_128(<8 x i16> %a0, <8 x i16> %a1, <8 x i16> %a2, <8 x i16> %a3) {
; X32-LABEL: test_unpackl_packss_128:
; X32:       ## BB#0:
; X32-NEXT:    vpacksswb %xmm1, %xmm0, %xmm0
; X32-NEXT:    vpacksswb %xmm3, %xmm2, %xmm1
; X32-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; X32-NEXT:    retl
;
; X64-LABEL: test_unpackl_packss_128:
; X64:       ## BB#0:
; X64-NEXT:    vpacksswb %xmm1, %xmm0, %xmm0
; X64-NEXT:    vpacksswb %xmm3, %xmm2, %xmm1
; X64-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; X64-NEXT:    retq
  %1 = call <16 x i8> @llvm.x86.sse2.packsswb.128(<8 x i16> %a0, <8 x i16> %a1)
  %2 = call <16 x i8> @llvm.x86.sse2.packsswb.128(<8 x i16> %a2, <8 x i16> %a3)
  %3 = shufflevector <16 x i8> %1, <16 x i8> %2, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23>
  ret <16 x i8> %3
}

define <8 x i16> @test_unpackh_packss_128(<4 x i32> %a0, <4 x i32> %a1, <4 x i32> %a2, <4 x i32> %a3) {
; X32-LABEL: test_unpackh_packss_128:
; X32:       ## BB#0:
; X32-NEXT:    vpackssdw %xmm1, %xmm0, %xmm0
; X32-NEXT:    vpackssdw %xmm3, %xmm2, %xmm1
; X32-NEXT:    vpunpckhqdq {{.*#+}} xmm0 = xmm0[1],xmm1[1]
; X32-NEXT:    retl
;
; X64-LABEL: test_unpackh_packss_128:
; X64:       ## BB#0:
; X64-NEXT:    vpackssdw %xmm1, %xmm0, %xmm0
; X64-NEXT:    vpackssdw %xmm3, %xmm2, %xmm1
; X64-NEXT:    vpunpckhqdq {{.*#+}} xmm0 = xmm0[1],xmm1[1]
; X64-NEXT:    retq
  %1 = call <8 x i16> @llvm.x86.sse2.packssdw.128(<4 x i32> %a0, <4 x i32> %a1)
  %2 = call <8 x i16> @llvm.x86.sse2.packssdw.128(<4 x i32> %a2, <4 x i32> %a3)
  %3 = shufflevector <8 x i16> %1, <8 x i16> %2, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 12, i32 13, i32 14, i32 15>
  ret <8 x i16> %3
}

define <8 x i16> @test_unpackl_packus_128(<4 x i32> %a0, <4 x i32> %a1, <4 x i32> %a2, <4 x i32> %a3) {
; X32-LABEL: test_unpackl_packus_128:
; X32:       ## BB#0:
; X32-NEXT:    vpackusdw %xmm2, %xmm0, %xmm0
; X32-NEXT:    retl
;
; X64-LABEL: test_unpackl_packus_128:
; X64:       ## BB#0:
; X64-NEXT:    vpackusdw %xmm2, %xmm0, %xmm0
; X64-NEXT:    retq
  %1 = call <8 x i16> @llvm.x86.sse41.packusdw(<4 x i32> %a0, <4 x i32> %a1)
  %2 = call <8 x i16> @llvm.x86.sse41.packusdw(<4 x i32> %a2, <4 x i32> %a3)
  %3 = shufflevector <8 x i16> %1, <8 x i16> %2, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 8, i32 9, i32 10, i32 11>
  ret <8 x i16> %3
}

define <16 x i8> @test_unpackh_packus_128(<8 x i16> %a0, <8 x i16> %a1, <8 x i16> %a2, <8 x i16> %a3) {
; X32-LABEL: test_unpackh_packus_128:
; X32:       ## BB#0:
; X32-NEXT:    vpackuswb %xmm3, %xmm1, %xmm0
; X32-NEXT:    retl
;
; X64-LABEL: test_unpackh_packus_128:
; X64:       ## BB#0:
; X64-NEXT:    vpackuswb %xmm3, %xmm1, %xmm0
; X64-NEXT:    retq
  %1 = call <16 x i8> @llvm.x86.sse2.packuswb.128(<8 x i16> %a0, <8 x i16> %a1)
  %2 = call <16 x i8> @llvm.x86.sse2.packuswb.128(<8 x i16> %a2, <8 x i16> %a3)
  %3 = shufflevector <16 x i8> %1, <16 x i8> %2, <16 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  ret <16 x i8> %3
}

;
; 256-bit Vectors
;

define <8 x float> @test_unpackl_fhadd_256(<8 x float> %a0, <8 x float> %a1, <8 x float> %a2, <8 x float> %a3) {
; X32-LABEL: test_unpackl_fhadd_256:
; X32:       ## BB#0:
; X32-NEXT:    vhaddps %ymm1, %ymm0, %ymm0
; X32-NEXT:    vhaddps %ymm3, %ymm2, %ymm1
; X32-NEXT:    vunpcklpd {{.*#+}} ymm0 = ymm0[0],ymm1[0],ymm0[2],ymm1[2]
; X32-NEXT:    retl
;
; X64-LABEL: test_unpackl_fhadd_256:
; X64:       ## BB#0:
; X64-NEXT:    vhaddps %ymm1, %ymm0, %ymm0
; X64-NEXT:    vhaddps %ymm3, %ymm2, %ymm1
; X64-NEXT:    vunpcklpd {{.*#+}} ymm0 = ymm0[0],ymm1[0],ymm0[2],ymm1[2]
; X64-NEXT:    retq
  %1 = call <8 x float> @llvm.x86.avx.hadd.ps.256(<8 x float> %a0, <8 x float> %a1)
  %2 = call <8 x float> @llvm.x86.avx.hadd.ps.256(<8 x float> %a2, <8 x float> %a3)
  %3 = shufflevector <8 x float> %1, <8 x float> %2, <8 x i32> <i32 0, i32 1, i32 8, i32 9, i32 4, i32 5, i32 12, i32 13>
  ret <8 x float> %3
}

define <4 x double> @test_unpackh_fhadd_256(<4 x double> %a0, <4 x double> %a1, <4 x double> %a2, <4 x double> %a3) {
; X32-LABEL: test_unpackh_fhadd_256:
; X32:       ## BB#0:
; X32-NEXT:    vhaddpd %ymm1, %ymm0, %ymm0
; X32-NEXT:    vhaddpd %ymm3, %ymm2, %ymm1
; X32-NEXT:    vunpckhpd {{.*#+}} ymm0 = ymm0[1],ymm1[1],ymm0[3],ymm1[3]
; X32-NEXT:    retl
;
; X64-LABEL: test_unpackh_fhadd_256:
; X64:       ## BB#0:
; X64-NEXT:    vhaddpd %ymm1, %ymm0, %ymm0
; X64-NEXT:    vhaddpd %ymm3, %ymm2, %ymm1
; X64-NEXT:    vunpckhpd {{.*#+}} ymm0 = ymm0[1],ymm1[1],ymm0[3],ymm1[3]
; X64-NEXT:    retq
  %1 = call <4 x double> @llvm.x86.avx.hadd.pd.256(<4 x double> %a0, <4 x double> %a1)
  %2 = call <4 x double> @llvm.x86.avx.hadd.pd.256(<4 x double> %a2, <4 x double> %a3)
  %3 = shufflevector <4 x double> %1, <4 x double> %2, <4 x i32> <i32 1, i32 5, i32 3, i32 7>
  ret <4 x double> %3
}

define <4 x double> @test_unpackl_fhsub_256(<4 x double> %a0, <4 x double> %a1, <4 x double> %a2, <4 x double> %a3) {
; X32-LABEL: test_unpackl_fhsub_256:
; X32:       ## BB#0:
; X32-NEXT:    vhsubpd %ymm1, %ymm0, %ymm0
; X32-NEXT:    vhsubpd %ymm3, %ymm2, %ymm1
; X32-NEXT:    vunpcklpd {{.*#+}} ymm0 = ymm0[0],ymm1[0],ymm0[2],ymm1[2]
; X32-NEXT:    retl
;
; X64-LABEL: test_unpackl_fhsub_256:
; X64:       ## BB#0:
; X64-NEXT:    vhsubpd %ymm1, %ymm0, %ymm0
; X64-NEXT:    vhsubpd %ymm3, %ymm2, %ymm1
; X64-NEXT:    vunpcklpd {{.*#+}} ymm0 = ymm0[0],ymm1[0],ymm0[2],ymm1[2]
; X64-NEXT:    retq
  %1 = call <4 x double> @llvm.x86.avx.hsub.pd.256(<4 x double> %a0, <4 x double> %a1)
  %2 = call <4 x double> @llvm.x86.avx.hsub.pd.256(<4 x double> %a2, <4 x double> %a3)
  %3 = shufflevector <4 x double> %1, <4 x double> %2, <4 x i32> <i32 0, i32 4, i32 2, i32 6>
  ret <4 x double> %3
}

define <8 x float> @test_unpackh_fhsub_256(<8 x float> %a0, <8 x float> %a1, <8 x float> %a2, <8 x float> %a3) {
; X32-LABEL: test_unpackh_fhsub_256:
; X32:       ## BB#0:
; X32-NEXT:    vhsubps %ymm1, %ymm0, %ymm0
; X32-NEXT:    vhsubps %ymm3, %ymm2, %ymm1
; X32-NEXT:    vunpckhpd {{.*#+}} ymm0 = ymm0[1],ymm1[1],ymm0[3],ymm1[3]
; X32-NEXT:    retl
;
; X64-LABEL: test_unpackh_fhsub_256:
; X64:       ## BB#0:
; X64-NEXT:    vhsubps %ymm1, %ymm0, %ymm0
; X64-NEXT:    vhsubps %ymm3, %ymm2, %ymm1
; X64-NEXT:    vunpckhpd {{.*#+}} ymm0 = ymm0[1],ymm1[1],ymm0[3],ymm1[3]
; X64-NEXT:    retq
  %1 = call <8 x float> @llvm.x86.avx.hsub.ps.256(<8 x float> %a0, <8 x float> %a1)
  %2 = call <8 x float> @llvm.x86.avx.hsub.ps.256(<8 x float> %a2, <8 x float> %a3)
  %3 = shufflevector <8 x float> %1, <8 x float> %2, <8 x i32> <i32 2, i32 3, i32 10, i32 11, i32 6, i32 7, i32 14, i32 15>
  ret <8 x float> %3
}

define <16 x i16> @test_unpackl_hadd_256(<16 x i16> %a0, <16 x i16> %a1, <16 x i16> %a2, <16 x i16> %a3) {
; X32-LABEL: test_unpackl_hadd_256:
; X32:       ## BB#0:
; X32-NEXT:    vphaddw %ymm1, %ymm0, %ymm0
; X32-NEXT:    vphaddw %ymm3, %ymm2, %ymm1
; X32-NEXT:    vpunpcklqdq {{.*#+}} ymm0 = ymm0[0],ymm1[0],ymm0[2],ymm1[2]
; X32-NEXT:    retl
;
; X64-LABEL: test_unpackl_hadd_256:
; X64:       ## BB#0:
; X64-NEXT:    vphaddw %ymm1, %ymm0, %ymm0
; X64-NEXT:    vphaddw %ymm3, %ymm2, %ymm1
; X64-NEXT:    vpunpcklqdq {{.*#+}} ymm0 = ymm0[0],ymm1[0],ymm0[2],ymm1[2]
; X64-NEXT:    retq
  %1 = call <16 x i16> @llvm.x86.avx2.phadd.w(<16 x i16> %a0, <16 x i16> %a1)
  %2 = call <16 x i16> @llvm.x86.avx2.phadd.w(<16 x i16> %a2, <16 x i16> %a3)
  %3 = shufflevector <16 x i16> %1, <16 x i16> %2, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 16, i32 17, i32 18, i32 19, i32 8, i32 9, i32 10, i32 11, i32 24, i32 25, i32 26, i32 27>
  ret <16 x i16> %3
}

define <8 x i32> @test_unpackh_hadd_256(<8 x i32> %a0, <8 x i32> %a1, <8 x i32> %a2, <8 x i32> %a3) {
; X32-LABEL: test_unpackh_hadd_256:
; X32:       ## BB#0:
; X32-NEXT:    vphaddd %ymm1, %ymm0, %ymm0
; X32-NEXT:    vphaddd %ymm3, %ymm2, %ymm1
; X32-NEXT:    vpunpckhqdq {{.*#+}} ymm0 = ymm0[1],ymm1[1],ymm0[3],ymm1[3]
; X32-NEXT:    retl
;
; X64-LABEL: test_unpackh_hadd_256:
; X64:       ## BB#0:
; X64-NEXT:    vphaddd %ymm1, %ymm0, %ymm0
; X64-NEXT:    vphaddd %ymm3, %ymm2, %ymm1
; X64-NEXT:    vpunpckhqdq {{.*#+}} ymm0 = ymm0[1],ymm1[1],ymm0[3],ymm1[3]
; X64-NEXT:    retq
  %1 = call <8 x i32> @llvm.x86.avx2.phadd.d(<8 x i32> %a0, <8 x i32> %a1)
  %2 = call <8 x i32> @llvm.x86.avx2.phadd.d(<8 x i32> %a2, <8 x i32> %a3)
  %3 = shufflevector <8 x i32> %1, <8 x i32> %2, <8 x i32> <i32 2, i32 3, i32 10, i32 11, i32 6, i32 7, i32 14, i32 15>
  ret <8 x i32> %3
}

define <8 x i32> @test_unpackl_hsub_256(<8 x i32> %a0, <8 x i32> %a1, <8 x i32> %a2, <8 x i32> %a3) {
; X32-LABEL: test_unpackl_hsub_256:
; X32:       ## BB#0:
; X32-NEXT:    vphsubd %ymm1, %ymm0, %ymm0
; X32-NEXT:    vphsubd %ymm3, %ymm2, %ymm1
; X32-NEXT:    vpunpcklqdq {{.*#+}} ymm0 = ymm0[0],ymm1[0],ymm0[2],ymm1[2]
; X32-NEXT:    retl
;
; X64-LABEL: test_unpackl_hsub_256:
; X64:       ## BB#0:
; X64-NEXT:    vphsubd %ymm1, %ymm0, %ymm0
; X64-NEXT:    vphsubd %ymm3, %ymm2, %ymm1
; X64-NEXT:    vpunpcklqdq {{.*#+}} ymm0 = ymm0[0],ymm1[0],ymm0[2],ymm1[2]
; X64-NEXT:    retq
  %1 = call <8 x i32> @llvm.x86.avx2.phsub.d(<8 x i32> %a0, <8 x i32> %a1)
  %2 = call <8 x i32> @llvm.x86.avx2.phsub.d(<8 x i32> %a2, <8 x i32> %a3)
  %3 = shufflevector <8 x i32> %1, <8 x i32> %2, <8 x i32> <i32 0, i32 1, i32 8, i32 9, i32 4, i32 5, i32 12, i32 13>
  ret <8 x i32> %3
}

define <16 x i16> @test_unpackh_hsub_256(<16 x i16> %a0, <16 x i16> %a1, <16 x i16> %a2, <16 x i16> %a3) {
; X32-LABEL: test_unpackh_hsub_256:
; X32:       ## BB#0:
; X32-NEXT:    vphsubw %ymm1, %ymm0, %ymm0
; X32-NEXT:    vphsubw %ymm3, %ymm2, %ymm1
; X32-NEXT:    vpunpckhqdq {{.*#+}} ymm0 = ymm0[1],ymm1[1],ymm0[3],ymm1[3]
; X32-NEXT:    retl
;
; X64-LABEL: test_unpackh_hsub_256:
; X64:       ## BB#0:
; X64-NEXT:    vphsubw %ymm1, %ymm0, %ymm0
; X64-NEXT:    vphsubw %ymm3, %ymm2, %ymm1
; X64-NEXT:    vpunpckhqdq {{.*#+}} ymm0 = ymm0[1],ymm1[1],ymm0[3],ymm1[3]
; X64-NEXT:    retq
  %1 = call <16 x i16> @llvm.x86.avx2.phsub.w(<16 x i16> %a0, <16 x i16> %a1)
  %2 = call <16 x i16> @llvm.x86.avx2.phsub.w(<16 x i16> %a2, <16 x i16> %a3)
  %3 = shufflevector <16 x i16> %1, <16 x i16> %2, <16 x i32> <i32 4, i32 5, i32 6, i32 7, i32 20, i32 21, i32 22, i32 23, i32 12, i32 13, i32 14, i32 15, i32 28, i32 29, i32 30, i32 31>
  ret <16 x i16> %3
}

define <32 x i8> @test_unpackl_packss_256(<16 x i16> %a0, <16 x i16> %a1, <16 x i16> %a2, <16 x i16> %a3) {
; X32-LABEL: test_unpackl_packss_256:
; X32:       ## BB#0:
; X32-NEXT:    vpacksswb %ymm1, %ymm0, %ymm0
; X32-NEXT:    vpacksswb %ymm3, %ymm2, %ymm1
; X32-NEXT:    vpunpcklqdq {{.*#+}} ymm0 = ymm0[0],ymm1[0],ymm0[2],ymm1[2]
; X32-NEXT:    retl
;
; X64-LABEL: test_unpackl_packss_256:
; X64:       ## BB#0:
; X64-NEXT:    vpacksswb %ymm1, %ymm0, %ymm0
; X64-NEXT:    vpacksswb %ymm3, %ymm2, %ymm1
; X64-NEXT:    vpunpcklqdq {{.*#+}} ymm0 = ymm0[0],ymm1[0],ymm0[2],ymm1[2]
; X64-NEXT:    retq
  %1 = call <32 x i8> @llvm.x86.avx2.packsswb(<16 x i16> %a0, <16 x i16> %a1)
  %2 = call <32 x i8> @llvm.x86.avx2.packsswb(<16 x i16> %a2, <16 x i16> %a3)
  %3 = shufflevector <32 x i8> %1, <32 x i8> %2, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55>
  ret <32 x i8> %3
}

define <16 x i16> @test_unpackh_packss_256(<8 x i32> %a0, <8 x i32> %a1, <8 x i32> %a2, <8 x i32> %a3) {
; X32-LABEL: test_unpackh_packss_256:
; X32:       ## BB#0:
; X32-NEXT:    vpackssdw %ymm1, %ymm0, %ymm0
; X32-NEXT:    vpackssdw %ymm3, %ymm2, %ymm1
; X32-NEXT:    vpunpckhqdq {{.*#+}} ymm0 = ymm0[1],ymm1[1],ymm0[3],ymm1[3]
; X32-NEXT:    retl
;
; X64-LABEL: test_unpackh_packss_256:
; X64:       ## BB#0:
; X64-NEXT:    vpackssdw %ymm1, %ymm0, %ymm0
; X64-NEXT:    vpackssdw %ymm3, %ymm2, %ymm1
; X64-NEXT:    vpunpckhqdq {{.*#+}} ymm0 = ymm0[1],ymm1[1],ymm0[3],ymm1[3]
; X64-NEXT:    retq
  %1 = call <16 x i16> @llvm.x86.avx2.packssdw(<8 x i32> %a0, <8 x i32> %a1)
  %2 = call <16 x i16> @llvm.x86.avx2.packssdw(<8 x i32> %a2, <8 x i32> %a3)
  %3 = shufflevector <16 x i16> %1, <16 x i16> %2, <16 x i32> <i32 4, i32 5, i32 6, i32 7, i32 20, i32 21, i32 22, i32 23, i32 12, i32 13, i32 14, i32 15, i32 28, i32 29, i32 30, i32 31>
  ret <16 x i16> %3
}

define <16 x i16> @test_unpackl_packus_256(<8 x i32> %a0, <8 x i32> %a1, <8 x i32> %a2, <8 x i32> %a3) {
; X32-LABEL: test_unpackl_packus_256:
; X32:       ## BB#0:
; X32-NEXT:    vpackusdw %ymm1, %ymm0, %ymm0
; X32-NEXT:    vpackusdw %ymm3, %ymm2, %ymm1
; X32-NEXT:    vpunpcklqdq {{.*#+}} ymm0 = ymm0[0],ymm1[0],ymm0[2],ymm1[2]
; X32-NEXT:    retl
;
; X64-LABEL: test_unpackl_packus_256:
; X64:       ## BB#0:
; X64-NEXT:    vpackusdw %ymm1, %ymm0, %ymm0
; X64-NEXT:    vpackusdw %ymm3, %ymm2, %ymm1
; X64-NEXT:    vpunpcklqdq {{.*#+}} ymm0 = ymm0[0],ymm1[0],ymm0[2],ymm1[2]
; X64-NEXT:    retq
  %1 = call <16 x i16> @llvm.x86.avx2.packusdw(<8 x i32> %a0, <8 x i32> %a1)
  %2 = call <16 x i16> @llvm.x86.avx2.packusdw(<8 x i32> %a2, <8 x i32> %a3)
  %3 = shufflevector <16 x i16> %1, <16 x i16> %2, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 16, i32 17, i32 18, i32 19, i32 8, i32 9, i32 10, i32 11, i32 24, i32 25, i32 26, i32 27>
  ret <16 x i16> %3
}

define <32 x i8> @test_unpackh_packus_256(<16 x i16> %a0, <16 x i16> %a1, <16 x i16> %a2, <16 x i16> %a3) {
; X32-LABEL: test_unpackh_packus_256:
; X32:       ## BB#0:
; X32-NEXT:    vpacksswb %ymm1, %ymm0, %ymm0
; X32-NEXT:    vpacksswb %ymm3, %ymm2, %ymm1
; X32-NEXT:    vpunpckhqdq {{.*#+}} ymm0 = ymm0[1],ymm1[1],ymm0[3],ymm1[3]
; X32-NEXT:    retl
;
; X64-LABEL: test_unpackh_packus_256:
; X64:       ## BB#0:
; X64-NEXT:    vpacksswb %ymm1, %ymm0, %ymm0
; X64-NEXT:    vpacksswb %ymm3, %ymm2, %ymm1
; X64-NEXT:    vpunpckhqdq {{.*#+}} ymm0 = ymm0[1],ymm1[1],ymm0[3],ymm1[3]
; X64-NEXT:    retq
  %1 = call <32 x i8> @llvm.x86.avx2.packsswb(<16 x i16> %a0, <16 x i16> %a1)
  %2 = call <32 x i8> @llvm.x86.avx2.packsswb(<16 x i16> %a2, <16 x i16> %a3)
  %3 = shufflevector <32 x i8> %1, <32 x i8> %2, <32 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  ret <32 x i8> %3
}

declare <4 x float> @llvm.x86.sse3.hadd.ps(<4 x float>, <4 x float>)
declare <4 x float> @llvm.x86.sse3.hsub.ps(<4 x float>, <4 x float>)
declare <2 x double> @llvm.x86.sse3.hadd.pd(<2 x double>, <2 x double>)
declare <2 x double> @llvm.x86.sse3.hsub.pd(<2 x double>, <2 x double>)

declare <8 x i16> @llvm.x86.ssse3.phadd.w.128(<8 x i16>, <8 x i16>)
declare <4 x i32> @llvm.x86.ssse3.phadd.d.128(<4 x i32>, <4 x i32>)
declare <8 x i16> @llvm.x86.ssse3.phsub.w.128(<8 x i16>, <8 x i16>)
declare <4 x i32> @llvm.x86.ssse3.phsub.d.128(<4 x i32>, <4 x i32>)

declare <16 x i8> @llvm.x86.sse2.packsswb.128(<8 x i16>, <8 x i16>)
declare <8 x i16> @llvm.x86.sse2.packssdw.128(<4 x i32>, <4 x i32>)
declare <16 x i8> @llvm.x86.sse2.packuswb.128(<8 x i16>, <8 x i16>)
declare <8 x i16> @llvm.x86.sse41.packusdw(<4 x i32>, <4 x i32>)

declare <8 x float> @llvm.x86.avx.hadd.ps.256(<8 x float>, <8 x float>)
declare <8 x float> @llvm.x86.avx.hsub.ps.256(<8 x float>, <8 x float>)
declare <4 x double> @llvm.x86.avx.hadd.pd.256(<4 x double>, <4 x double>)
declare <4 x double> @llvm.x86.avx.hsub.pd.256(<4 x double>, <4 x double>)

declare <16 x i16> @llvm.x86.avx2.phadd.w(<16 x i16>, <16 x i16>)
declare <8 x i32> @llvm.x86.avx2.phadd.d(<8 x i32>, <8 x i32>)
declare <16 x i16> @llvm.x86.avx2.phsub.w(<16 x i16>, <16 x i16>)
declare <8 x i32> @llvm.x86.avx2.phsub.d(<8 x i32>, <8 x i32>)

declare <32 x i8> @llvm.x86.avx2.packsswb(<16 x i16>, <16 x i16>)
declare <16 x i16> @llvm.x86.avx2.packssdw(<8 x i32>, <8 x i32>)
declare <32 x i8> @llvm.x86.avx2.packuswb(<16 x i16>, <16 x i16>)
declare <16 x i16> @llvm.x86.avx2.packusdw(<8 x i32>, <8 x i32>)
