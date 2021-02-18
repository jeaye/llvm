; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.1 | FileCheck %s

; TODO: (zext(select c, load1, load2)) -> (select c, zextload1, zextload2)
define i64 @zext_scalar(i8* %p, i1 zeroext %c) {
; CHECK-LABEL: zext_scalar:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movzbl (%rdi), %eax
; CHECK-NEXT:    movzbl 1(%rdi), %ecx
; CHECK-NEXT:    testl %esi, %esi
; CHECK-NEXT:    cmovel %eax, %ecx
; CHECK-NEXT:    movzbl %cl, %eax
; CHECK-NEXT:    retq
  %ld1 = load volatile i8, i8* %p
  %arrayidx1 = getelementptr inbounds i8, i8* %p, i64 1
  %ld2 = load volatile i8, i8* %arrayidx1
  %cond.v = select i1 %c, i8 %ld2, i8 %ld1
  %cond = zext i8 %cond.v to i64
  ret i64 %cond
}

define i64 @zext_scalar2(i8* %p, i16* %q, i1 zeroext %c) {
; CHECK-LABEL: zext_scalar2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movzbl (%rdi), %eax
; CHECK-NEXT:    testl %edx, %edx
; CHECK-NEXT:    je .LBB1_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    movzwl (%rsi), %eax
; CHECK-NEXT:  .LBB1_2:
; CHECK-NEXT:    movzwl %ax, %eax
; CHECK-NEXT:    retq
  %ld1 = load volatile i8, i8* %p
  %ext_ld1 = zext i8 %ld1 to i16
  %ld2 = load volatile i16, i16* %q
  %cond.v = select i1 %c, i16 %ld2, i16 %ext_ld1
  %cond = zext i16 %cond.v to i64
  ret i64 %cond
}

; Don't fold the ext if there is a load with conflicting ext type.
define i64 @zext_scalar_neg(i8* %p, i16* %q, i1 zeroext %c) {
; CHECK-LABEL: zext_scalar_neg:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movsbl (%rdi), %eax
; CHECK-NEXT:    testl %edx, %edx
; CHECK-NEXT:    je .LBB2_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    movzwl (%rsi), %eax
; CHECK-NEXT:  .LBB2_2:
; CHECK-NEXT:    movzwl %ax, %eax
; CHECK-NEXT:    retq
  %ld1 = load volatile i8, i8* %p
  %ext_ld1 = sext i8 %ld1 to i16
  %ld2 = load volatile i16, i16* %q
  %cond.v = select i1 %c, i16 %ld2, i16 %ext_ld1
  %cond = zext i16 %cond.v to i64
  ret i64 %cond
}

; TODO: (sext(select c, load1, load2)) -> (select c, sextload1, sextload2)
define i64 @sext_scalar(i8* %p, i1 zeroext %c) {
; CHECK-LABEL: sext_scalar:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movzbl (%rdi), %eax
; CHECK-NEXT:    movzbl 1(%rdi), %ecx
; CHECK-NEXT:    testl %esi, %esi
; CHECK-NEXT:    cmovel %eax, %ecx
; CHECK-NEXT:    movsbq %cl, %rax
; CHECK-NEXT:    retq
  %ld1 = load volatile i8, i8* %p
  %arrayidx1 = getelementptr inbounds i8, i8* %p, i64 1
  %ld2 = load volatile i8, i8* %arrayidx1
  %cond.v = select i1 %c, i8 %ld2, i8 %ld1
  %cond = sext i8 %cond.v to i64
  ret i64 %cond
}

; Same as zext_scalar, but operate on vectors.
define <2 x i64> @zext_vector_i1(<2 x i32>* %p, i1 zeroext %c) {
; CHECK-LABEL: zext_vector_i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq {{.*#+}} xmm1 = mem[0],zero
; CHECK-NEXT:    movq {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    testl %esi, %esi
; CHECK-NEXT:    jne .LBB4_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    movdqa %xmm1, %xmm0
; CHECK-NEXT:  .LBB4_2:
; CHECK-NEXT:    pmovzxdq {{.*#+}} xmm0 = xmm0[0],zero,xmm0[1],zero
; CHECK-NEXT:    retq
  %ld1 = load volatile <2 x i32>, <2 x i32>* %p
  %arrayidx1 = getelementptr inbounds <2 x i32>, <2 x i32>* %p, i64 1
  %ld2 = load volatile <2 x i32>, <2 x i32>* %arrayidx1
  %cond.v = select i1 %c, <2 x i32> %ld2, <2 x i32> %ld1
  %cond = zext <2 x i32> %cond.v to <2 x i64>
  ret <2 x i64> %cond
}

define <2 x i64> @zext_vector_v2i1(<2 x i32>* %p, <2 x i1> %c) {
; CHECK-LABEL: zext_vector_v2i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; CHECK-NEXT:    pslld $31, %xmm0
; CHECK-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; CHECK-NEXT:    movsd {{.*#+}} xmm2 = mem[0],zero
; CHECK-NEXT:    blendvps %xmm0, %xmm2, %xmm1
; CHECK-NEXT:    pmovzxdq {{.*#+}} xmm0 = xmm1[0],zero,xmm1[1],zero
; CHECK-NEXT:    retq
  %ld1 = load volatile <2 x i32>, <2 x i32>* %p
  %arrayidx1 = getelementptr inbounds <2 x i32>, <2 x i32>* %p, i64 1
  %ld2 = load volatile <2 x i32>, <2 x i32>* %arrayidx1
  %cond.v = select <2 x i1> %c, <2 x i32> %ld2, <2 x i32> %ld1
  %cond = zext <2 x i32> %cond.v to <2 x i64>
  ret <2 x i64> %cond
}

; Same as sext_scalar, but operate on vectors.
define <2 x i64> @sext_vector_i1(<2 x i32>* %p, i1 zeroext %c) {
; CHECK-LABEL: sext_vector_i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq {{.*#+}} xmm1 = mem[0],zero
; CHECK-NEXT:    movq {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    testl %esi, %esi
; CHECK-NEXT:    jne .LBB6_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    movdqa %xmm1, %xmm0
; CHECK-NEXT:  .LBB6_2:
; CHECK-NEXT:    pmovsxdq %xmm0, %xmm0
; CHECK-NEXT:    retq
  %ld1 = load volatile <2 x i32>, <2 x i32>* %p
  %arrayidx1 = getelementptr inbounds <2 x i32>, <2 x i32>* %p, i64 1
  %ld2 = load volatile <2 x i32>, <2 x i32>* %arrayidx1
  %cond.v = select i1 %c, <2 x i32> %ld2, <2 x i32> %ld1
  %cond = sext <2 x i32> %cond.v to <2 x i64>
  ret <2 x i64> %cond
}

define <2 x i64> @sext_vector_v2i1(<2 x i32>* %p, <2 x i1> %c) {
; CHECK-LABEL: sext_vector_v2i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; CHECK-NEXT:    pslld $31, %xmm0
; CHECK-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; CHECK-NEXT:    movsd {{.*#+}} xmm2 = mem[0],zero
; CHECK-NEXT:    blendvps %xmm0, %xmm2, %xmm1
; CHECK-NEXT:    pmovsxdq %xmm1, %xmm0
; CHECK-NEXT:    retq
  %ld1 = load volatile <2 x i32>, <2 x i32>* %p
  %arrayidx1 = getelementptr inbounds <2 x i32>, <2 x i32>* %p, i64 1
  %ld2 = load volatile <2 x i32>, <2 x i32>* %arrayidx1
  %cond.v = select <2 x i1> %c, <2 x i32> %ld2, <2 x i32> %ld1
  %cond = sext <2 x i32> %cond.v to <2 x i64>
  ret <2 x i64> %cond
}
