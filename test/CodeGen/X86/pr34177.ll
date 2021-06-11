; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mattr=+avx512f | FileCheck %s --check-prefix=AVX512F
; RUN: llc < %s -mattr=+avx512f,+avx512vl,+avx512bw,+avx512dq | FileCheck %s --check-prefix=AVX512VL

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

define void @test(<4 x i64> %a, <4 x x86_fp80> %b, <8 x x86_fp80>* %c) local_unnamed_addr {
; AVX512F-LABEL: test:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vmovq %xmm0, %rax
; AVX512F-NEXT:    vpextrq $1, %xmm0, %rcx
; AVX512F-NEXT:    vextracti128 $1, %ymm0, %xmm0
; AVX512F-NEXT:    vmovq %xmm0, %rdx
; AVX512F-NEXT:    vpextrq $1, %xmm0, %rsi
; AVX512F-NEXT:    cmpq $3, %rsi
; AVX512F-NEXT:    fld1
; AVX512F-NEXT:    fldz
; AVX512F-NEXT:    fld %st(0)
; AVX512F-NEXT:    fcmove %st(2), %st
; AVX512F-NEXT:    cmpq $2, %rdx
; AVX512F-NEXT:    fld %st(1)
; AVX512F-NEXT:    fcmove %st(3), %st
; AVX512F-NEXT:    cmpq $1, %rcx
; AVX512F-NEXT:    fld %st(2)
; AVX512F-NEXT:    fcmove %st(4), %st
; AVX512F-NEXT:    testq %rax, %rax
; AVX512F-NEXT:    fxch %st(3)
; AVX512F-NEXT:    fcmove %st(4), %st
; AVX512F-NEXT:    fstp %st(4)
; AVX512F-NEXT:    fldt {{[0-9]+}}(%rsp)
; AVX512F-NEXT:    fstpt 70(%rdi)
; AVX512F-NEXT:    fldt {{[0-9]+}}(%rsp)
; AVX512F-NEXT:    fstpt 50(%rdi)
; AVX512F-NEXT:    fldt {{[0-9]+}}(%rsp)
; AVX512F-NEXT:    fstpt 30(%rdi)
; AVX512F-NEXT:    fldt {{[0-9]+}}(%rsp)
; AVX512F-NEXT:    fstpt 10(%rdi)
; AVX512F-NEXT:    fxch %st(1)
; AVX512F-NEXT:    fadd %st, %st(0)
; AVX512F-NEXT:    fstpt 60(%rdi)
; AVX512F-NEXT:    fadd %st, %st(0)
; AVX512F-NEXT:    fstpt 40(%rdi)
; AVX512F-NEXT:    fadd %st, %st(0)
; AVX512F-NEXT:    fstpt 20(%rdi)
; AVX512F-NEXT:    fadd %st, %st(0)
; AVX512F-NEXT:    fstpt (%rdi)
;
; AVX512VL-LABEL: test:
; AVX512VL:       # %bb.0:
; AVX512VL-NEXT:    vpcmpeqq {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %k0
; AVX512VL-NEXT:    kshiftrb $2, %k0, %k1
; AVX512VL-NEXT:    kshiftrb $1, %k0, %k2
; AVX512VL-NEXT:    kmovd %k0, %eax
; AVX512VL-NEXT:    testb $1, %al
; AVX512VL-NEXT:    fld1
; AVX512VL-NEXT:    fldz
; AVX512VL-NEXT:    fld %st(0)
; AVX512VL-NEXT:    fcmovne %st(2), %st
; AVX512VL-NEXT:    kshiftrb $1, %k1, %k0
; AVX512VL-NEXT:    kmovd %k0, %eax
; AVX512VL-NEXT:    testb $1, %al
; AVX512VL-NEXT:    fld %st(1)
; AVX512VL-NEXT:    fcmovne %st(3), %st
; AVX512VL-NEXT:    kmovd %k1, %eax
; AVX512VL-NEXT:    testb $1, %al
; AVX512VL-NEXT:    fld %st(2)
; AVX512VL-NEXT:    fcmovne %st(4), %st
; AVX512VL-NEXT:    kmovd %k2, %eax
; AVX512VL-NEXT:    testb $1, %al
; AVX512VL-NEXT:    fxch %st(3)
; AVX512VL-NEXT:    fcmovne %st(4), %st
; AVX512VL-NEXT:    fstp %st(4)
; AVX512VL-NEXT:    fldt {{[0-9]+}}(%rsp)
; AVX512VL-NEXT:    fstpt 70(%rdi)
; AVX512VL-NEXT:    fldt {{[0-9]+}}(%rsp)
; AVX512VL-NEXT:    fstpt 50(%rdi)
; AVX512VL-NEXT:    fldt {{[0-9]+}}(%rsp)
; AVX512VL-NEXT:    fstpt 30(%rdi)
; AVX512VL-NEXT:    fldt {{[0-9]+}}(%rsp)
; AVX512VL-NEXT:    fstpt 10(%rdi)
; AVX512VL-NEXT:    fxch %st(1)
; AVX512VL-NEXT:    fadd %st, %st(0)
; AVX512VL-NEXT:    fstpt (%rdi)
; AVX512VL-NEXT:    fadd %st, %st(0)
; AVX512VL-NEXT:    fstpt 60(%rdi)
; AVX512VL-NEXT:    fadd %st, %st(0)
; AVX512VL-NEXT:    fstpt 40(%rdi)
; AVX512VL-NEXT:    fadd %st, %st(0)
; AVX512VL-NEXT:    fstpt 20(%rdi)
  %1 = icmp eq <4 x i64> <i64 0, i64 1, i64 2, i64 3>, %a
  %2 = select <4 x i1> %1, <4 x x86_fp80> <x86_fp80 0xK3FFF8000000000000000, x86_fp80 0xK3FFF8000000000000000, x86_fp80 0xK3FFF8000000000000000, x86_fp80 0xK3FFF8000000000000000>, <4 x x86_fp80> zeroinitializer
  %3 = fadd <4 x x86_fp80> %2, %2
  %4 = shufflevector <4 x x86_fp80> %3, <4 x x86_fp80> %b, <8 x i32> <i32 0, i32 4, i32 1, i32 5, i32 2, i32 6, i32 3, i32 7>
  store <8 x x86_fp80> %4, <8 x x86_fp80>* %c, align 16
  unreachable
}
