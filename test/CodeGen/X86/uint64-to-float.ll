; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-apple-unknown -mattr=+sse2 | FileCheck %s --check-prefix=X86
; RUN: llc < %s -mtriple=x86_64-apple-unknown -mattr=+sse2 | FileCheck %s --check-prefix=X64

; Verify that we are using the efficient uitofp --> sitofp lowering illustrated
; by the compiler_rt implementation of __floatundisf.
; <rdar://problem/8493982>

define float @test(i64 %a) nounwind {
; X86-LABEL: test:
; X86:       # %bb.0: # %entry
; X86-NEXT:    pushl %ebp
; X86-NEXT:    movl %esp, %ebp
; X86-NEXT:    andl $-8, %esp
; X86-NEXT:    subl $16, %esp
; X86-NEXT:    movl 12(%ebp), %eax
; X86-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; X86-NEXT:    movlps %xmm0, {{[0-9]+}}(%esp)
; X86-NEXT:    shrl $31, %eax
; X86-NEXT:    fildll {{[0-9]+}}(%esp)
; X86-NEXT:    fadds {{\.LCPI[0-9]+_[0-9]+}}(,%eax,4)
; X86-NEXT:    fstps {{[0-9]+}}(%esp)
; X86-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X86-NEXT:    movss %xmm0, (%esp)
; X86-NEXT:    flds (%esp)
; X86-NEXT:    movl %ebp, %esp
; X86-NEXT:    popl %ebp
; X86-NEXT:    retl
;
; X64-LABEL: test:
; X64:       # %bb.0: # %entry
; X64-NEXT:    testq %rdi, %rdi
; X64-NEXT:    js .LBB0_1
; X64-NEXT:  # %bb.2: # %entry
; X64-NEXT:    cvtsi2ss %rdi, %xmm0
; X64-NEXT:    retq
; X64-NEXT:  .LBB0_1:
; X64-NEXT:    movq %rdi, %rax
; X64-NEXT:    shrq %rax
; X64-NEXT:    andl $1, %edi
; X64-NEXT:    orq %rax, %rdi
; X64-NEXT:    cvtsi2ss %rdi, %xmm0
; X64-NEXT:    addss %xmm0, %xmm0
; X64-NEXT:    retq
entry:
  %b = uitofp i64 %a to float
  ret float %b
}
