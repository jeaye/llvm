; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mattr=+avx512bitalg,+avx512vl | FileCheck %s

define i16 @test_vpshufbitqmb_128(<16 x i8> %a, <16 x i8> %b, <16 x i8> %c, <16 x i8> %d) {
; CHECK-LABEL: test_vpshufbitqmb_128:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpshufbitqmb %xmm1, %xmm0, %k1
; CHECK-NEXT:    vpshufbitqmb %xmm3, %xmm2, %k0 {%k1}
; CHECK-NEXT:    kmovd %k0, %eax
; CHECK-NEXT:    ## kill: def $ax killed $ax killed $eax
; CHECK-NEXT:    retq
  %tmp = call <16 x i1> @llvm.x86.avx512.vpshufbitqmb.128(<16 x i8> %a, <16 x i8> %b)
  %tmp1 = call <16 x i1> @llvm.x86.avx512.vpshufbitqmb.128(<16 x i8> %c, <16 x i8> %d)
  %tmp2 = and <16 x i1> %tmp, %tmp1
  %tmp3 = bitcast <16 x i1> %tmp2 to i16
  ret i16 %tmp3
}

define i32 @test_vpshufbitqmb_256(<32 x i8> %a, <32 x i8> %b, <32 x i8> %c, <32 x i8> %d) {
; CHECK-LABEL: test_vpshufbitqmb_256:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpshufbitqmb %ymm1, %ymm0, %k1
; CHECK-NEXT:    vpshufbitqmb %ymm3, %ymm2, %k0 {%k1}
; CHECK-NEXT:    kmovd %k0, %eax
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %tmp = call <32 x i1> @llvm.x86.avx512.vpshufbitqmb.256(<32 x i8> %a, <32 x i8> %b)
  %tmp1 = call <32 x i1> @llvm.x86.avx512.vpshufbitqmb.256(<32 x i8> %c, <32 x i8> %d)
  %tmp2 = and <32 x i1> %tmp, %tmp1
  %tmp3 = bitcast <32 x i1> %tmp2 to i32
  ret i32 %tmp3
}

define i64 @test_vpshufbitqmb_512(<64 x i8> %a, <64 x i8> %b, <64 x i8> %c, <64 x i8> %d) {
; CHECK-LABEL: test_vpshufbitqmb_512:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpshufbitqmb %zmm1, %zmm0, %k1
; CHECK-NEXT:    vpshufbitqmb %zmm3, %zmm2, %k0 {%k1}
; CHECK-NEXT:    kmovq %k0, %rax
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %tmp = call <64 x i1> @llvm.x86.avx512.vpshufbitqmb.512(<64 x i8> %a, <64 x i8> %b)
  %tmp1 = call <64 x i1> @llvm.x86.avx512.vpshufbitqmb.512(<64 x i8> %c, <64 x i8> %d)
  %tmp2 = and <64 x i1> %tmp, %tmp1
  %tmp3 = bitcast <64 x i1> %tmp2 to i64
  ret i64 %tmp3
}

declare <16 x i1> @llvm.x86.avx512.vpshufbitqmb.128(<16 x i8>, <16 x i8>)
declare <32 x i1> @llvm.x86.avx512.vpshufbitqmb.256(<32 x i8>, <32 x i8>)
declare <64 x i1> @llvm.x86.avx512.vpshufbitqmb.512(<64 x i8>, <64 x i8>)
