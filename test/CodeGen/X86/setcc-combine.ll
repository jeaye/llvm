; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64-unknown-unknown -mcpu=generic < %s | FileCheck %s

define i32 @test_eq_1(<4 x i32> %A, <4 x i32> %B) {
; CHECK-LABEL: test_eq_1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pcmpgtd %xmm0, %xmm1
; CHECK-NEXT:    pcmpeqd %xmm0, %xmm0
; CHECK-NEXT:    pxor %xmm1, %xmm0
; CHECK-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,2,3]
; CHECK-NEXT:    movd %xmm0, %eax
; CHECK-NEXT:    retq
  %cmp = icmp slt <4 x i32> %A, %B
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %cmp1 = icmp eq <4 x i32> %sext, zeroinitializer
  %t0 = extractelement <4 x i1> %cmp1, i32 1
  %t1 = sext i1 %t0 to i32
  ret i32 %t1
}

define i32 @test_ne_1(<4 x i32> %A, <4 x i32> %B) {
; CHECK-LABEL: test_ne_1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pcmpgtd %xmm0, %xmm1
; CHECK-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[1,1,2,3]
; CHECK-NEXT:    movd %xmm0, %eax
; CHECK-NEXT:    retq
  %cmp = icmp slt <4 x i32> %A, %B
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %cmp1 = icmp ne <4 x i32> %sext, zeroinitializer
  %t0 = extractelement <4 x i1> %cmp1, i32 1
  %t1 = sext i1 %t0 to i32
  ret i32 %t1
}

define i32 @test_le_1(<4 x i32> %A, <4 x i32> %B) {
; CHECK-LABEL: test_le_1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl $-1, %eax
; CHECK-NEXT:    retq
  %cmp = icmp slt <4 x i32> %A, %B
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %cmp1 = icmp sle <4 x i32> %sext, zeroinitializer
  %t0 = extractelement <4 x i1> %cmp1, i32 1
  %t1 = sext i1 %t0 to i32
  ret i32 %t1
}

define i32 @test_ge_1(<4 x i32> %A, <4 x i32> %B) {
; CHECK-LABEL: test_ge_1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pcmpgtd %xmm0, %xmm1
; CHECK-NEXT:    pcmpeqd %xmm0, %xmm0
; CHECK-NEXT:    pxor %xmm1, %xmm0
; CHECK-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,2,3]
; CHECK-NEXT:    movd %xmm0, %eax
; CHECK-NEXT:    retq
  %cmp = icmp slt <4 x i32> %A, %B
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %cmp1 = icmp sge <4 x i32> %sext, zeroinitializer
  %t0 = extractelement <4 x i1> %cmp1, i32 1
  %t1 = sext i1 %t0 to i32
  ret i32 %t1
}

define i32 @test_lt_1(<4 x i32> %A, <4 x i32> %B) {
; CHECK-LABEL: test_lt_1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pcmpgtd %xmm0, %xmm1
; CHECK-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[1,1,2,3]
; CHECK-NEXT:    movd %xmm0, %eax
; CHECK-NEXT:    retq
  %cmp = icmp slt <4 x i32> %A, %B
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %cmp1 = icmp slt <4 x i32> %sext, zeroinitializer
  %t0 = extractelement <4 x i1> %cmp, i32 1
  %t1 = sext i1 %t0 to i32
  ret i32 %t1
}

define i32 @test_gt_1(<4 x i32> %A, <4 x i32> %B) {
; CHECK-LABEL: test_gt_1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    retq
  %cmp = icmp slt <4 x i32> %A, %B
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %cmp1 = icmp sgt <4 x i32> %sext, zeroinitializer
  %t0 = extractelement <4 x i1> %cmp1, i32 1
  %t1 = sext i1 %t0 to i32
  ret i32 %t1
}

define i32 @test_eq_2(<4 x i32> %A, <4 x i32> %B) {
; CHECK-LABEL: test_eq_2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pcmpgtd %xmm1, %xmm0
; CHECK-NEXT:    pcmpeqd %xmm1, %xmm1
; CHECK-NEXT:    pxor %xmm0, %xmm1
; CHECK-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[1,1,2,3]
; CHECK-NEXT:    movd %xmm0, %eax
; CHECK-NEXT:    retq
  %cmp = icmp slt <4 x i32> %B, %A
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %cmp1 = icmp eq <4 x i32> %sext, zeroinitializer
  %t0 = extractelement <4 x i1> %cmp1, i32 1
  %t1 = sext i1 %t0 to i32
  ret i32 %t1
}

define i32 @test_ne_2(<4 x i32> %A, <4 x i32> %B) {
; CHECK-LABEL: test_ne_2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pcmpgtd %xmm1, %xmm0
; CHECK-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,2,3]
; CHECK-NEXT:    movd %xmm0, %eax
; CHECK-NEXT:    retq
  %cmp = icmp slt <4 x i32> %B, %A
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %cmp1 = icmp ne <4 x i32> %sext, zeroinitializer
  %t0 = extractelement <4 x i1> %cmp1, i32 1
  %t1 = sext i1 %t0 to i32
  ret i32 %t1
}

define i32 @test_le_2(<4 x i32> %A, <4 x i32> %B) {
; CHECK-LABEL: test_le_2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pcmpgtd %xmm1, %xmm0
; CHECK-NEXT:    pcmpeqd %xmm1, %xmm1
; CHECK-NEXT:    pxor %xmm0, %xmm1
; CHECK-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[1,1,2,3]
; CHECK-NEXT:    movd %xmm0, %eax
; CHECK-NEXT:    retq
  %cmp = icmp slt <4 x i32> %B, %A
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %cmp1 = icmp sle <4 x i32> zeroinitializer, %sext
  %t0 = extractelement <4 x i1> %cmp1, i32 1
  %t1 = sext i1 %t0 to i32
  ret i32 %t1
}

define i32 @test_ge_2(<4 x i32> %A, <4 x i32> %B) {
; CHECK-LABEL: test_ge_2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl $-1, %eax
; CHECK-NEXT:    retq
  %cmp = icmp slt <4 x i32> %B, %A
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %cmp1 = icmp sge <4 x i32> zeroinitializer, %sext
  %t0 = extractelement <4 x i1> %cmp1, i32 1
  %t1 = sext i1 %t0 to i32
  ret i32 %t1
}

define i32 @test_lt_2(<4 x i32> %A, <4 x i32> %B) {
; CHECK-LABEL: test_lt_2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pcmpgtd %xmm1, %xmm0
; CHECK-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,2,3]
; CHECK-NEXT:    movd %xmm0, %eax
; CHECK-NEXT:    retq
  %cmp = icmp slt <4 x i32> %B, %A
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %cmp1 = icmp slt <4 x i32> zeroinitializer, %sext
  %t0 = extractelement <4 x i1> %cmp, i32 1
  %t1 = sext i1 %t0 to i32
  ret i32 %t1
}

define i32 @test_gt_2(<4 x i32> %A, <4 x i32> %B) {
; CHECK-LABEL: test_gt_2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pcmpgtd %xmm1, %xmm0
; CHECK-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,2,3]
; CHECK-NEXT:    movd %xmm0, %eax
; CHECK-NEXT:    retq
  %cmp = icmp slt <4 x i32> %B, %A
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %cmp1 = icmp sgt <4 x i32> zeroinitializer, %sext
  %t0 = extractelement <4 x i1> %cmp1, i32 1
  %t1 = sext i1 %t0 to i32
  ret i32 %t1
}

