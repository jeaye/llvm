; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse2 | FileCheck %s --check-prefixes=CHECK,SSE,SSE2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.2 | FileCheck %s --check-prefixes=CHECK,SSE,SSE42
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefixes=CHECK,AVX,AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefixes=CHECK,AVX,AVX2

declare i32 @llvm.x86.sse.movmsk.ps(<4 x float>)
declare i32 @llvm.x86.sse2.movmsk.pd(<2 x double>)
declare i32 @llvm.x86.sse2.pmovmskb.128(<16 x i8>)

; Use widest possible vector for movmsk comparisons (PR37087)

define i1 @movmskps_noneof_bitcast_v2f64(<2 x double> %a0) {
; SSE-LABEL: movmskps_noneof_bitcast_v2f64:
; SSE:       # %bb.0:
; SSE-NEXT:    xorpd %xmm1, %xmm1
; SSE-NEXT:    cmpeqpd %xmm0, %xmm1
; SSE-NEXT:    movmskpd %xmm1, %eax
; SSE-NEXT:    testl %eax, %eax
; SSE-NEXT:    sete %al
; SSE-NEXT:    retq
;
; AVX-LABEL: movmskps_noneof_bitcast_v2f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorpd %xmm1, %xmm1, %xmm1
; AVX-NEXT:    vcmpeqpd %xmm0, %xmm1, %xmm0
; AVX-NEXT:    vmovmskpd %xmm0, %eax
; AVX-NEXT:    testl %eax, %eax
; AVX-NEXT:    sete %al
; AVX-NEXT:    retq
  %1 = fcmp oeq <2 x double> zeroinitializer, %a0
  %2 = sext <2 x i1> %1 to <2 x i64>
  %3 = bitcast <2 x i64> %2 to <4 x float>
  %4 = tail call i32 @llvm.x86.sse.movmsk.ps(<4 x float> %3)
  %5 = icmp eq i32 %4, 0
  ret i1 %5
}

define i1 @movmskps_allof_bitcast_v2f64(<2 x double> %a0) {
; SSE-LABEL: movmskps_allof_bitcast_v2f64:
; SSE:       # %bb.0:
; SSE-NEXT:    xorpd %xmm1, %xmm1
; SSE-NEXT:    cmpeqpd %xmm0, %xmm1
; SSE-NEXT:    movmskpd %xmm1, %eax
; SSE-NEXT:    cmpl $3, %eax
; SSE-NEXT:    sete %al
; SSE-NEXT:    retq
;
; AVX-LABEL: movmskps_allof_bitcast_v2f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorpd %xmm1, %xmm1, %xmm1
; AVX-NEXT:    vcmpeqpd %xmm0, %xmm1, %xmm0
; AVX-NEXT:    vmovmskpd %xmm0, %eax
; AVX-NEXT:    cmpl $3, %eax
; AVX-NEXT:    sete %al
; AVX-NEXT:    retq
  %1 = fcmp oeq <2 x double> zeroinitializer, %a0
  %2 = sext <2 x i1> %1 to <2 x i64>
  %3 = bitcast <2 x i64> %2 to <4 x float>
  %4 = tail call i32 @llvm.x86.sse.movmsk.ps(<4 x float> %3)
  %5 = icmp eq i32 %4, 15
  ret i1 %5
}

define i1 @pmovmskb_noneof_bitcast_v2i64(<2 x i64> %a0) {
; SSE2-LABEL: pmovmskb_noneof_bitcast_v2i64:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pxor %xmm1, %xmm1
; SSE2-NEXT:    pcmpgtd %xmm0, %xmm1
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[1,1,3,3]
; SSE2-NEXT:    movmskps %xmm0, %eax
; SSE2-NEXT:    testl %eax, %eax
; SSE2-NEXT:    sete %al
; SSE2-NEXT:    retq
;
; SSE42-LABEL: pmovmskb_noneof_bitcast_v2i64:
; SSE42:       # %bb.0:
; SSE42-NEXT:    movmskpd %xmm0, %eax
; SSE42-NEXT:    testl %eax, %eax
; SSE42-NEXT:    sete %al
; SSE42-NEXT:    retq
;
; AVX-LABEL: pmovmskb_noneof_bitcast_v2i64:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovmskpd %xmm0, %eax
; AVX-NEXT:    testl %eax, %eax
; AVX-NEXT:    sete %al
; AVX-NEXT:    retq
  %1 = icmp sgt <2 x i64> zeroinitializer, %a0
  %2 = sext <2 x i1> %1 to <2 x i64>
  %3 = bitcast <2 x i64> %2 to <16 x i8>
  %4 = tail call i32 @llvm.x86.sse2.pmovmskb.128(<16 x i8> %3)
  %5 = icmp eq i32 %4, 0
  ret i1 %5
}

define i1 @pmovmskb_allof_bitcast_v2i64(<2 x i64> %a0) {
; SSE2-LABEL: pmovmskb_allof_bitcast_v2i64:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pxor %xmm1, %xmm1
; SSE2-NEXT:    pcmpgtd %xmm0, %xmm1
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[1,1,3,3]
; SSE2-NEXT:    movmskps %xmm0, %eax
; SSE2-NEXT:    cmpl $15, %eax
; SSE2-NEXT:    sete %al
; SSE2-NEXT:    retq
;
; SSE42-LABEL: pmovmskb_allof_bitcast_v2i64:
; SSE42:       # %bb.0:
; SSE42-NEXT:    movmskpd %xmm0, %eax
; SSE42-NEXT:    cmpl $3, %eax
; SSE42-NEXT:    sete %al
; SSE42-NEXT:    retq
;
; AVX-LABEL: pmovmskb_allof_bitcast_v2i64:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovmskpd %xmm0, %eax
; AVX-NEXT:    cmpl $3, %eax
; AVX-NEXT:    sete %al
; AVX-NEXT:    retq
  %1 = icmp sgt <2 x i64> zeroinitializer, %a0
  %2 = sext <2 x i1> %1 to <2 x i64>
  %3 = bitcast <2 x i64> %2 to <16 x i8>
  %4 = tail call i32 @llvm.x86.sse2.pmovmskb.128(<16 x i8> %3)
  %5 = icmp eq i32 %4, 65535
  ret i1 %5
}

define i1 @pmovmskb_noneof_bitcast_v4f32(<4 x float> %a0) {
; SSE-LABEL: pmovmskb_noneof_bitcast_v4f32:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm1, %xmm1
; SSE-NEXT:    cmpeqps %xmm0, %xmm1
; SSE-NEXT:    movmskps %xmm1, %eax
; SSE-NEXT:    testl %eax, %eax
; SSE-NEXT:    sete %al
; SSE-NEXT:    retq
;
; AVX-LABEL: pmovmskb_noneof_bitcast_v4f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; AVX-NEXT:    vcmpeqps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vmovmskps %xmm0, %eax
; AVX-NEXT:    testl %eax, %eax
; AVX-NEXT:    sete %al
; AVX-NEXT:    retq
  %1 = fcmp oeq <4 x float> %a0, zeroinitializer
  %2 = sext <4 x i1> %1 to <4 x i32>
  %3 = bitcast <4 x i32> %2 to <16 x i8>
  %4 = tail call i32 @llvm.x86.sse2.pmovmskb.128(<16 x i8> %3)
  %5 = icmp eq i32 %4, 0
  ret i1 %5
}

define i1 @pmovmskb_allof_bitcast_v4f32(<4 x float> %a0) {
; SSE-LABEL: pmovmskb_allof_bitcast_v4f32:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm1, %xmm1
; SSE-NEXT:    cmpeqps %xmm0, %xmm1
; SSE-NEXT:    movmskps %xmm1, %eax
; SSE-NEXT:    cmpl $15, %eax
; SSE-NEXT:    sete %al
; SSE-NEXT:    retq
;
; AVX-LABEL: pmovmskb_allof_bitcast_v4f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; AVX-NEXT:    vcmpeqps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vmovmskps %xmm0, %eax
; AVX-NEXT:    cmpl $15, %eax
; AVX-NEXT:    sete %al
; AVX-NEXT:    retq
  %1 = fcmp oeq <4 x float> %a0, zeroinitializer
  %2 = sext <4 x i1> %1 to <4 x i32>
  %3 = bitcast <4 x i32> %2 to <16 x i8>
  %4 = tail call i32 @llvm.x86.sse2.pmovmskb.128(<16 x i8> %3)
  %5 = icmp eq i32 %4, 65535
  ret i1 %5
}
