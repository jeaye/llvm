; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-- | FileCheck %s --check-prefix=X86
; RUN: llc < %s -mtriple=x86_64-- | FileCheck %s --check-prefix=X64

; Make sure none of these crash, and that the power-of-two transformations
; trigger correctly.

define i128 @test1(i128 %x) nounwind {
; X86-LABEL: test1:
; X86:       # %bb.0:
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl %ecx, %edx
; X86-NEXT:    sarl $31, %edx
; X86-NEXT:    movl %edx, %esi
; X86-NEXT:    shrl $30, %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X86-NEXT:    addl %edx, %edi
; X86-NEXT:    adcl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    adcl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    adcl $0, %ecx
; X86-NEXT:    shrdl $2, %ecx, %esi
; X86-NEXT:    movl %ecx, %edx
; X86-NEXT:    sarl $2, %edx
; X86-NEXT:    sarl $31, %ecx
; X86-NEXT:    movl %ecx, 12(%eax)
; X86-NEXT:    movl %ecx, 8(%eax)
; X86-NEXT:    movl %edx, 4(%eax)
; X86-NEXT:    movl %esi, (%eax)
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    retl $4
;
; X64-LABEL: test1:
; X64:       # %bb.0:
; X64-NEXT:    movq %rsi, %rax
; X64-NEXT:    sarq $63, %rax
; X64-NEXT:    movq %rax, %rdx
; X64-NEXT:    shrq $62, %rdx
; X64-NEXT:    addq %rdi, %rax
; X64-NEXT:    adcq %rsi, %rdx
; X64-NEXT:    movq %rdx, %rax
; X64-NEXT:    sarq $2, %rax
; X64-NEXT:    sarq $63, %rdx
; X64-NEXT:    retq
  %tmp = sdiv i128 %x, 73786976294838206464
  ret i128 %tmp
}

define i128 @test2(i128 %x) nounwind {
; X86-LABEL: test2:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebx
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl %ecx, %edx
; X86-NEXT:    sarl $31, %edx
; X86-NEXT:    movl %edx, %esi
; X86-NEXT:    shrl $30, %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X86-NEXT:    addl %edx, %edi
; X86-NEXT:    adcl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    adcl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    adcl $0, %ecx
; X86-NEXT:    shrdl $2, %ecx, %esi
; X86-NEXT:    movl %ecx, %edx
; X86-NEXT:    sarl $31, %edx
; X86-NEXT:    sarl $2, %ecx
; X86-NEXT:    xorl %edi, %edi
; X86-NEXT:    negl %esi
; X86-NEXT:    movl $0, %ebx
; X86-NEXT:    sbbl %ecx, %ebx
; X86-NEXT:    movl $0, %ecx
; X86-NEXT:    sbbl %edx, %ecx
; X86-NEXT:    sbbl %edx, %edi
; X86-NEXT:    movl %esi, (%eax)
; X86-NEXT:    movl %ebx, 4(%eax)
; X86-NEXT:    movl %ecx, 8(%eax)
; X86-NEXT:    movl %edi, 12(%eax)
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    popl %ebx
; X86-NEXT:    retl $4
;
; X64-LABEL: test2:
; X64:       # %bb.0:
; X64-NEXT:    movq %rsi, %rcx
; X64-NEXT:    sarq $63, %rcx
; X64-NEXT:    movq %rcx, %rax
; X64-NEXT:    shrq $62, %rax
; X64-NEXT:    addq %rdi, %rcx
; X64-NEXT:    adcq %rsi, %rax
; X64-NEXT:    movq %rax, %rcx
; X64-NEXT:    sarq $63, %rcx
; X64-NEXT:    sarq $2, %rax
; X64-NEXT:    xorl %edx, %edx
; X64-NEXT:    negq %rax
; X64-NEXT:    sbbq %rcx, %rdx
; X64-NEXT:    retq
  %tmp = sdiv i128 %x, -73786976294838206464
  ret i128 %tmp
}

define i128 @test3(i128 %x) nounwind {
; X86-LABEL: test3:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebp
; X86-NEXT:    movl %esp, %ebp
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    andl $-8, %esp
; X86-NEXT:    subl $16, %esp
; X86-NEXT:    movl 8(%ebp), %esi
; X86-NEXT:    movl %esp, %eax
; X86-NEXT:    pushl $-1
; X86-NEXT:    pushl $-5
; X86-NEXT:    pushl $-1
; X86-NEXT:    pushl $-3
; X86-NEXT:    pushl 24(%ebp)
; X86-NEXT:    pushl 20(%ebp)
; X86-NEXT:    pushl 16(%ebp)
; X86-NEXT:    pushl 12(%ebp)
; X86-NEXT:    pushl %eax
; X86-NEXT:    calll __divti3
; X86-NEXT:    addl $32, %esp
; X86-NEXT:    movl (%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X86-NEXT:    movl %edi, 12(%esi)
; X86-NEXT:    movl %edx, 8(%esi)
; X86-NEXT:    movl %ecx, 4(%esi)
; X86-NEXT:    movl %eax, (%esi)
; X86-NEXT:    movl %esi, %eax
; X86-NEXT:    leal -8(%ebp), %esp
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    popl %ebp
; X86-NEXT:    retl $4
;
; X64-LABEL: test3:
; X64:       # %bb.0:
; X64-NEXT:    pushq %rax
; X64-NEXT:    movq $-3, %rdx
; X64-NEXT:    movq $-5, %rcx
; X64-NEXT:    callq __divti3@PLT
; X64-NEXT:    popq %rcx
; X64-NEXT:    retq
  %tmp = sdiv i128 %x, -73786976294838206467
  ret i128 %tmp
}
