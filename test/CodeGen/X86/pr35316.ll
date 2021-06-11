; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-linux | FileCheck %s --check-prefix=CHECK

; This tests for a cyclic dependencies in the generated DAG.

@c = external dso_local local_unnamed_addr global i32, align 4
@a = external dso_local local_unnamed_addr global i32, align 4
@b = external dso_local local_unnamed_addr global i32, align 4

define void @foo() {
; CHECK-LABEL: foo:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movl -{{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movl -{{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movl -{{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movl -{{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movl -{{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movl -{{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movl -{{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movl -{{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movl -{{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movl -{{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movl -{{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movl -{{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movl -{{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movl -{{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movl -{{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movl $0, b(%rip)
; CHECK-NEXT:    movl -{{[0-9]+}}(%rsp), %r8d
; CHECK-NEXT:    movl -{{[0-9]+}}(%rsp), %edi
; CHECK-NEXT:    movl -{{[0-9]+}}(%rsp), %esi
; CHECK-NEXT:    movl -{{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    cltd
; CHECK-NEXT:    idivl a(%rip)
; CHECK-NEXT:    movl %eax, %ecx
; CHECK-NEXT:    movl c(%rip), %eax
; CHECK-NEXT:    cltd
; CHECK-NEXT:    idivl %esi
; CHECK-NEXT:    andl %edi, %eax
; CHECK-NEXT:    addl %ecx, %eax
; CHECK-NEXT:    andl %r8d, %eax
; CHECK-NEXT:    movl %eax, (%rax)
; CHECK-NEXT:    retq
entry:
  %e = alloca i32, align 4
  %e.0.e.0.24 = load volatile i32, i32* %e, align 4
  %e.0.e.0.25 = load volatile i32, i32* %e, align 4
  %e.0.e.0.26 = load volatile i32, i32* %e, align 4
  %e.0.e.0.27 = load volatile i32, i32* %e, align 4
  %e.0.e.0.28 = load volatile i32, i32* %e, align 4
  %e.0.e.0.29 = load volatile i32, i32* %e, align 4
  %e.0.e.0.30 = load volatile i32, i32* %e, align 4
  %e.0.e.0.31 = load volatile i32, i32* %e, align 4
  %e.0.e.0.32 = load volatile i32, i32* %e, align 4
  %e.0.e.0.33 = load volatile i32, i32* %e, align 4
  %e.0.e.0.34 = load volatile i32, i32* %e, align 4
  %e.0.e.0.35 = load volatile i32, i32* %e, align 4
  %e.0.e.0.36 = load volatile i32, i32* %e, align 4
  %e.0.e.0.37 = load volatile i32, i32* %e, align 4
  %e.0.e.0.39 = load volatile i32, i32* %e, align 4
  %tmp = load i32, i32* @a, align 4
  store i32 0, i32* @b, align 4
  %e.0.e.0.41 = load volatile i32, i32* %e, align 4
  %add17 = add nsw i32 %e.0.e.0.41, 0
  %e.0.e.0.42 = load volatile i32, i32* %e, align 4
  %tmp1 = load i32, i32* @c, align 4
  %e.0.e.0.43 = load volatile i32, i32* %e, align 4
  %div = sdiv i32 %tmp1, %e.0.e.0.43
  %and18 = and i32 %div, %e.0.e.0.42
  %e.0.e.0.44 = load volatile i32, i32* %e, align 4
  %div19 = sdiv i32 %e.0.e.0.44, %tmp
  %add20 = add nsw i32 %div19, %and18
  %and21 = and i32 %add20, %add17
  store volatile i32 %and21, i32* undef, align 4
  ret void
}
