; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown -mcpu=corei7 -mattr=+sse4.1 | FileCheck %s

; rdar://12721174
; We should not fold movss into pshufd since pshufd expects m128 while movss
; loads from m32.
define void @sample_test(<4 x float>* %source, <2 x float>* %dest) nounwind {
; CHECK-LABEL: sample_test:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    subq $24, %rsp
; CHECK-NEXT:    movq %rdi, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movq %rsi, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    xorps %xmm0, %xmm0
; CHECK-NEXT:    movlps %xmm0, (%rsp)
; CHECK-NEXT:    unpcklps {{.*#+}} xmm0 = xmm0[0],mem[0],xmm0[1],mem[1]
; CHECK-NEXT:    movlps %xmm0, (%rsp)
; CHECK-NEXT:    movlps %xmm0, (%rsi)
; CHECK-NEXT:    movq {{[0-9]+}}(%rsp), %rax
; CHECK-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    movshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; CHECK-NEXT:    callq ext@PLT
; CHECK-NEXT:    addq $24, %rsp
; CHECK-NEXT:    retq
entry:
  %source.addr = alloca <4 x float>*, align 8
  %dest.addr = alloca <2 x float>*, align 8
  %tmp = alloca <2 x float>, align 8
  store <4 x float>* %source, <4 x float>** %source.addr, align 8
  store <2 x float>* %dest, <2 x float>** %dest.addr, align 8
  store <2 x float> zeroinitializer, <2 x float>* %tmp, align 8
  %0 = load <4 x float>*, <4 x float>** %source.addr, align 8
  %arrayidx = getelementptr inbounds <4 x float>, <4 x float>* %0, i64 0
  %1 = load <4 x float>, <4 x float>* %arrayidx, align 16
  %2 = extractelement <4 x float> %1, i32 0
  %3 = load <2 x float>, <2 x float>* %tmp, align 8
  %4 = insertelement <2 x float> %3, float %2, i32 1
  store <2 x float> %4, <2 x float>* %tmp, align 8
  %5 = load <2 x float>, <2 x float>* %tmp, align 8
  %6 = load <2 x float>*, <2 x float>** %dest.addr, align 8
  %arrayidx1 = getelementptr inbounds <2 x float>, <2 x float>* %6, i64 0
  store <2 x float> %5, <2 x float>* %arrayidx1, align 8
  %7 = load <2 x float>*, <2 x float>** %dest.addr, align 8
  %arrayidx2 = getelementptr inbounds <2 x float>, <2 x float>* %7, i64 0
  %8 = load <2 x float>, <2 x float>* %arrayidx2, align 8
  %vecext = extractelement <2 x float> %8, i32 0
  %9 = load <2 x float>*, <2 x float>** %dest.addr, align 8
  %arrayidx3 = getelementptr inbounds <2 x float>, <2 x float>* %9, i64 0
  %10 = load <2 x float>, <2 x float>* %arrayidx3, align 8
  %vecext4 = extractelement <2 x float> %10, i32 1
  call void @ext(float %vecext, float %vecext4)
  ret void
}
declare void @ext(float, float)
