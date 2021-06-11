; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64-- < %s | FileCheck %s

@a = external dso_local global <16 x float>, align 64

declare void @goo(<2 x i256>)

define void @foo() #0 {
; CHECK-LABEL: foo:
; CHECK:       # %bb.0:
; CHECK-NEXT:    subq $24, %rsp
; CHECK-NEXT:    movq a+40(%rip), %r9
; CHECK-NEXT:    movq a+32(%rip), %r8
; CHECK-NEXT:    movq a+24(%rip), %rcx
; CHECK-NEXT:    movq a+16(%rip), %rdx
; CHECK-NEXT:    movq a+8(%rip), %rsi
; CHECK-NEXT:    movq a(%rip), %rdi
; CHECK-NEXT:    vmovaps a+48(%rip), %xmm0
; CHECK-NEXT:    vmovups %xmm0, (%rsp)
; CHECK-NEXT:    callq goo@PLT
; CHECK-NEXT:    addq $24, %rsp
; CHECK-NEXT:    retq
  %k = bitcast <16 x float>* @a to <2 x i256>*
  %load = load <2 x i256>, <2 x i256>* %k, align 64
  call void @goo(<2 x i256> %load)
  ret void
}

attributes #0 = { nounwind "target-features"="+avx512bw" }
