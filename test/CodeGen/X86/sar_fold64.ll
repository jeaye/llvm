; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown | FileCheck %s --check-prefixes=CHECK,SSE
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx  | FileCheck %s --check-prefixes=CHECK,AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefixes=CHECK,AVX2

define i32 @shl48sar47(i64 %a) #0 {
; CHECK-LABEL: shl48sar47:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movswq %di, %rax
; CHECK-NEXT:    addl %eax, %eax
; CHECK-NEXT:    # kill: def $eax killed $eax killed $rax
; CHECK-NEXT:    retq
  %1 = shl i64 %a, 48
  %2 = ashr exact i64 %1, 47
  %3 = trunc i64 %2 to i32
  ret i32 %3
}

define i32 @shl48sar49(i64 %a) #0 {
; CHECK-LABEL: shl48sar49:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movswq %di, %rax
; CHECK-NEXT:    shrq %rax
; CHECK-NEXT:    # kill: def $eax killed $eax killed $rax
; CHECK-NEXT:    retq
  %1 = shl i64 %a, 48
  %2 = ashr exact i64 %1, 49
  %3 = trunc i64 %2 to i32
  ret i32 %3
}

define i32 @shl56sar55(i64 %a) #0 {
; CHECK-LABEL: shl56sar55:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movsbq %dil, %rax
; CHECK-NEXT:    addl %eax, %eax
; CHECK-NEXT:    # kill: def $eax killed $eax killed $rax
; CHECK-NEXT:    retq
  %1 = shl i64 %a, 56
  %2 = ashr exact i64 %1, 55
  %3 = trunc i64 %2 to i32
  ret i32 %3
}

define i32 @shl56sar57(i64 %a) #0 {
; CHECK-LABEL: shl56sar57:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movsbq %dil, %rax
; CHECK-NEXT:    shrq %rax
; CHECK-NEXT:    # kill: def $eax killed $eax killed $rax
; CHECK-NEXT:    retq
  %1 = shl i64 %a, 56
  %2 = ashr exact i64 %1, 57
  %3 = trunc i64 %2 to i32
  ret i32 %3
}

define i8 @all_sign_bit_ashr(i8 %x) {
; CHECK-LABEL: all_sign_bit_ashr:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    andb $1, %al
; CHECK-NEXT:    negb %al
; CHECK-NEXT:    # kill: def $al killed $al killed $eax
; CHECK-NEXT:    retq
  %and = and i8 %x, 1
  %neg = sub i8 0, %and
  %sar = ashr i8 %neg, 6
  ret i8 %sar
}

define <4 x i32> @all_sign_bit_ashr_vec0(<4 x i32> %x) {
; SSE-LABEL: all_sign_bit_ashr_vec0:
; SSE:       # %bb.0:
; SSE-NEXT:    pand {{.*}}(%rip), %xmm0
; SSE-NEXT:    pxor %xmm1, %xmm1
; SSE-NEXT:    psubd %xmm0, %xmm1
; SSE-NEXT:    movdqa %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX1-LABEL: all_sign_bit_ashr_vec0:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpand {{.*}}(%rip), %xmm0, %xmm0
; AVX1-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX1-NEXT:    vpsubd %xmm0, %xmm1, %xmm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: all_sign_bit_ashr_vec0:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpbroadcastd {{.*#+}} xmm1 = [1,1,1,1]
; AVX2-NEXT:    vpand %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX2-NEXT:    vpsubd %xmm0, %xmm1, %xmm0
; AVX2-NEXT:    retq
  %and = and <4 x i32> %x, <i32 1, i32 1, i32 1 , i32 1>
  %neg = sub <4 x i32> zeroinitializer, %and
  %sar = ashr <4 x i32> %neg, <i32 1, i32 31, i32 5, i32 0>
  ret <4 x i32> %sar
}

define <4 x i32> @all_sign_bit_ashr_vec1(<4 x i32> %x) {
; SSE-LABEL: all_sign_bit_ashr_vec1:
; SSE:       # %bb.0:
; SSE-NEXT:    pand {{.*}}(%rip), %xmm0
; SSE-NEXT:    pxor %xmm1, %xmm1
; SSE-NEXT:    psubd %xmm0, %xmm1
; SSE-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[0,0,0,0]
; SSE-NEXT:    movdqa %xmm0, %xmm1
; SSE-NEXT:    psrad $5, %xmm1
; SSE-NEXT:    punpckhqdq {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSE-NEXT:    movdqa %xmm0, %xmm2
; SSE-NEXT:    psrad $31, %xmm2
; SSE-NEXT:    psrad $1, %xmm0
; SSE-NEXT:    punpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm2[0]
; SSE-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,3],xmm1[0,3]
; SSE-NEXT:    retq
;
; AVX1-LABEL: all_sign_bit_ashr_vec1:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpand {{.*}}(%rip), %xmm0, %xmm0
; AVX1-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX1-NEXT:    vpsubd %xmm0, %xmm1, %xmm0
; AVX1-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,0,0,0]
; AVX1-NEXT:    vpsrad $31, %xmm0, %xmm1
; AVX1-NEXT:    vpblendw {{.*#+}} xmm1 = xmm1[0,1,2,3],xmm0[4,5,6,7]
; AVX1-NEXT:    vpsrad $5, %xmm0, %xmm2
; AVX1-NEXT:    vpsrad $1, %xmm0, %xmm0
; AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0,1,2,3],xmm2[4,5,6,7]
; AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3],xmm0[4,5],xmm1[6,7]
; AVX1-NEXT:    retq
;
; AVX2-LABEL: all_sign_bit_ashr_vec1:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpbroadcastd {{.*#+}} xmm1 = [1,1,1,1]
; AVX2-NEXT:    vpand %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX2-NEXT:    vpsubd %xmm0, %xmm1, %xmm0
; AVX2-NEXT:    vpbroadcastd %xmm0, %xmm0
; AVX2-NEXT:    vpsravd {{.*}}(%rip), %xmm0, %xmm0
; AVX2-NEXT:    retq
  %and = and <4 x i32> %x, <i32 1, i32 1, i32 1 , i32 1>
  %sub = sub <4 x i32> <i32 0, i32 1, i32 2, i32 3>, %and
  %shf = shufflevector <4 x i32> %sub, <4 x i32> undef, <4 x i32> zeroinitializer
  %sar = ashr <4 x i32> %shf, <i32 1, i32 31, i32 5, i32 0>
  ret <4 x i32> %sar
}

attributes #0 = { nounwind }
