; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown | FileCheck %s --check-prefix=X86
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+cmov | FileCheck %s --check-prefix=X64

;
; PR48768 - 'and' clears the overflow flag, so we don't need a separate 'test'.
;

define i8 @and_i8_ri(i8 zeroext %0, i8 zeroext %1) {
; X86-LABEL: and_i8_ri:
; X86:       # %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %al
; X86-NEXT:    movl %eax, %ecx
; X86-NEXT:    andb $-17, %cl
; X86-NEXT:    je .LBB0_2
; X86-NEXT:  # %bb.1:
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:  .LBB0_2:
; X86-NEXT:    retl
;
; X64-LABEL: and_i8_ri:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    andb $-17, %al
; X64-NEXT:    movzbl %al, %eax
; X64-NEXT:    cmovel %edi, %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %3 = and i8 %0, -17
  %4 = icmp eq i8 %3, 0
  %5 = select i1 %4, i8 %0, i8 %3
  ret i8 %5
}

define i8 @and_i8_rr(i8 zeroext %0, i8 zeroext %1) {
; X86-LABEL: and_i8_rr:
; X86:       # %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %al
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    andb %al, %cl
; X86-NEXT:    je .LBB1_2
; X86-NEXT:  # %bb.1:
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:  .LBB1_2:
; X86-NEXT:    retl
;
; X64-LABEL: and_i8_rr:
; X64:       # %bb.0:
; X64-NEXT:    movl %esi, %eax
; X64-NEXT:    andl %edi, %eax
; X64-NEXT:    cmovel %edi, %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %3 = and i8 %1, %0
  %4 = icmp eq i8 %3, 0
  %5 = select i1 %4, i8 %0, i8 %3
  ret i8 %5
}

define i16 @and_i16_ri(i16 zeroext %0, i16 zeroext %1) {
; X86-LABEL: and_i16_ri:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl %eax, %ecx
; X86-NEXT:    andl $-17, %ecx
; X86-NEXT:    testw %cx, %cx
; X86-NEXT:    je .LBB2_2
; X86-NEXT:  # %bb.1:
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:  .LBB2_2:
; X86-NEXT:    # kill: def $ax killed $ax killed $eax
; X86-NEXT:    retl
;
; X64-LABEL: and_i16_ri:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    andl $-17, %eax
; X64-NEXT:    cmovel %edi, %eax
; X64-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NEXT:    retq
  %3 = and i16 %0, -17
  %4 = icmp eq i16 %3, 0
  %5 = select i1 %4, i16 %0, i16 %3
  ret i16 %5
}

define i16 @and_i16_rr(i16 zeroext %0, i16 zeroext %1) {
; X86-LABEL: and_i16_rr:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    andw %ax, %cx
; X86-NEXT:    je .LBB3_2
; X86-NEXT:  # %bb.1:
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:  .LBB3_2:
; X86-NEXT:    # kill: def $ax killed $ax killed $eax
; X86-NEXT:    retl
;
; X64-LABEL: and_i16_rr:
; X64:       # %bb.0:
; X64-NEXT:    movl %esi, %eax
; X64-NEXT:    andl %edi, %eax
; X64-NEXT:    cmovel %edi, %eax
; X64-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NEXT:    retq
  %3 = and i16 %1, %0
  %4 = icmp eq i16 %3, 0
  %5 = select i1 %4, i16 %0, i16 %3
  ret i16 %5
}

define i32 @and_i32_ri(i32 %0, i32 %1) {
; X86-LABEL: and_i32_ri:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl %eax, %ecx
; X86-NEXT:    andl $-17, %ecx
; X86-NEXT:    jle .LBB4_2
; X86-NEXT:  # %bb.1:
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:  .LBB4_2:
; X86-NEXT:    retl
;
; X64-LABEL: and_i32_ri:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    andl $-17, %eax
; X64-NEXT:    cmovlel %edi, %eax
; X64-NEXT:    retq
  %3 = and i32 %0, -17
  %4 = icmp slt i32 %3, 1
  %5 = select i1 %4, i32 %0, i32 %3
  ret i32 %5
}

define i32 @and_i32_rr(i32 %0, i32 %1) {
; X86-LABEL: and_i32_rr:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    andl %eax, %ecx
; X86-NEXT:    jle .LBB5_2
; X86-NEXT:  # %bb.1:
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:  .LBB5_2:
; X86-NEXT:    retl
;
; X64-LABEL: and_i32_rr:
; X64:       # %bb.0:
; X64-NEXT:    movl %esi, %eax
; X64-NEXT:    andl %edi, %eax
; X64-NEXT:    cmovlel %edi, %eax
; X64-NEXT:    retq
  %3 = and i32 %1, %0
  %4 = icmp slt i32 %3, 1
  %5 = select i1 %4, i32 %0, i32 %3
  ret i32 %5
}

define i64 @and_i64_ri(i64 %0, i64 %1) nounwind {
; X86-LABEL: and_i64_ri:
; X86:       # %bb.0:
; X86-NEXT:    pushl %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl %eax, %ecx
; X86-NEXT:    andl $-17, %ecx
; X86-NEXT:    cmpl $1, %ecx
; X86-NEXT:    movl %edx, %esi
; X86-NEXT:    sbbl $0, %esi
; X86-NEXT:    jl .LBB6_2
; X86-NEXT:  # %bb.1:
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:  .LBB6_2:
; X86-NEXT:    popl %esi
; X86-NEXT:    retl
;
; X64-LABEL: and_i64_ri:
; X64:       # %bb.0:
; X64-NEXT:    movq %rdi, %rax
; X64-NEXT:    andq $-17, %rax
; X64-NEXT:    cmovleq %rdi, %rax
; X64-NEXT:    retq
  %3 = and i64 %0, -17
  %4 = icmp slt i64 %3, 1
  %5 = select i1 %4, i64 %0, i64 %3
  ret i64 %5
}

define i64 @and_i64_rr(i64 %0, i64 %1) nounwind {
; X86-LABEL: and_i64_rr:
; X86:       # %bb.0:
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    andl %edx, %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    andl %eax, %esi
; X86-NEXT:    cmpl $1, %esi
; X86-NEXT:    movl %ecx, %edi
; X86-NEXT:    sbbl $0, %edi
; X86-NEXT:    jl .LBB7_2
; X86-NEXT:  # %bb.1:
; X86-NEXT:    movl %esi, %eax
; X86-NEXT:    movl %ecx, %edx
; X86-NEXT:  .LBB7_2:
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    retl
;
; X64-LABEL: and_i64_rr:
; X64:       # %bb.0:
; X64-NEXT:    movq %rsi, %rax
; X64-NEXT:    andq %rdi, %rax
; X64-NEXT:    cmovleq %rdi, %rax
; X64-NEXT:    retq
  %3 = and i64 %1, %0
  %4 = icmp slt i64 %3, 1
  %5 = select i1 %4, i64 %0, i64 %3
  ret i64 %5
}
