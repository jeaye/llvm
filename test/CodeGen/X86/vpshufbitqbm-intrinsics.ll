; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mattr=+avx512bitalg,+avx512vl | FileCheck %s

declare i16 @llvm.x86.avx512.mask.vpshufbitqmb.128(<16 x i8> %a, <16 x i8> %b, i16 %mask)
define i16 @test_vpshufbitqmb_128(<16 x i8> %a, <16 x i8> %b, i16 %mask) {
; CHECK-LABEL: test_vpshufbitqmb_128:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    kmovd %edi, %k1
; CHECK-NEXT:    vpshufbitqmb %xmm1, %xmm0, %k0 {%k1}
; CHECK-NEXT:    kmovd %k0, %eax
; CHECK-NEXT:    ## kill: %ax<def> %ax<kill> %eax<kill>
; CHECK-NEXT:    retq
  %res = call i16 @llvm.x86.avx512.mask.vpshufbitqmb.128(<16 x i8> %a, <16 x i8> %b, i16 %mask)
  ret i16 %res
}

declare i32 @llvm.x86.avx512.mask.vpshufbitqmb.256(<32 x i8> %a, <32 x i8> %b, i32 %mask)
define i32 @test_vpshufbitqmb_256(<32 x i8> %a, <32 x i8> %b, i32 %mask) {
; CHECK-LABEL: test_vpshufbitqmb_256:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    kmovd %edi, %k1
; CHECK-NEXT:    vpshufbitqmb %ymm1, %ymm0, %k0 {%k1}
; CHECK-NEXT:    kmovd %k0, %eax
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %res = call i32 @llvm.x86.avx512.mask.vpshufbitqmb.256(<32 x i8> %a, <32 x i8> %b, i32 %mask)
  ret i32 %res
}

declare i64 @llvm.x86.avx512.mask.vpshufbitqmb.512(<64 x i8> %a, <64 x i8> %b, i64 %mask)
define i64 @test_vpshufbitqmb_512(<64 x i8> %a, <64 x i8> %b, i64 %mask) {
; CHECK-LABEL: test_vpshufbitqmb_512:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    kmovq %rdi, %k1
; CHECK-NEXT:    vpshufbitqmb %zmm1, %zmm0, %k0 {%k1}
; CHECK-NEXT:    kmovq %k0, %rax
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %res = call i64 @llvm.x86.avx512.mask.vpshufbitqmb.512(<64 x i8> %a, <64 x i8> %b, i64 %mask)
  ret i64 %res
}
