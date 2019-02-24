; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown | FileCheck %s --check-prefixes=X86
; RUN: llc < %s -mtriple=x86_64-unknown-unknown | FileCheck %s --check-prefixes=X64

define i32 @PR40483_add1(i32*, i32) nounwind {
; X86-LABEL: PR40483_add1:
; X86:       # %bb.0:
; X86-NEXT:    pushl %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl (%edx), %esi
; X86-NEXT:    leal (%esi,%ecx), %eax
; X86-NEXT:    addl %ecx, %esi
; X86-NEXT:    movl %esi, (%edx)
; X86-NEXT:    jae .LBB0_1
; X86-NEXT:  # %bb.2:
; X86-NEXT:    xorl %eax, %eax
; X86-NEXT:    popl %esi
; X86-NEXT:    retl
; X86-NEXT:  .LBB0_1:
; X86-NEXT:    orl %eax, %eax
; X86-NEXT:    popl %esi
; X86-NEXT:    retl
;
; X64-LABEL: PR40483_add1:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $esi killed $esi def $rsi
; X64-NEXT:    movl (%rdi), %ecx
; X64-NEXT:    leal (%rcx,%rsi), %edx
; X64-NEXT:    orl %edx, %edx
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    addl %esi, %ecx
; X64-NEXT:    movl %ecx, (%rdi)
; X64-NEXT:    cmovael %edx, %eax
; X64-NEXT:    retq
  %3 = load i32, i32* %0, align 8
  %4 = tail call { i8, i32 } @llvm.x86.addcarry.32(i8 0, i32 %3, i32 %1)
  %5 = extractvalue { i8, i32 } %4, 1
  store i32 %5, i32* %0, align 8
  %6 = extractvalue { i8, i32 } %4, 0
  %7 = icmp eq i8 %6, 0
  %8 = add i32 %1, %3
  %9 = or i32 %5, %8
  %10 = select i1 %7, i32 %9, i32 0
  ret i32 %10
}

define i32 @PR40483_add2(i32*, i32) nounwind {
; X86-LABEL: PR40483_add2:
; X86:       # %bb.0:
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    movl (%esi), %edi
; X86-NEXT:    leal (%edi,%edx), %ecx
; X86-NEXT:    xorl %eax, %eax
; X86-NEXT:    addl %edx, %edi
; X86-NEXT:    movl %edi, (%esi)
; X86-NEXT:    jae .LBB1_2
; X86-NEXT:  # %bb.1:
; X86-NEXT:    orl %ecx, %ecx
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:  .LBB1_2:
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    retl
;
; X64-LABEL: PR40483_add2:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $esi killed $esi def $rsi
; X64-NEXT:    movl (%rdi), %ecx
; X64-NEXT:    leal (%rcx,%rsi), %edx
; X64-NEXT:    orl %edx, %edx
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    addl %esi, %ecx
; X64-NEXT:    movl %ecx, (%rdi)
; X64-NEXT:    cmovbl %edx, %eax
; X64-NEXT:    retq
  %3 = load i32, i32* %0, align 8
  %4 = tail call { i8, i32 } @llvm.x86.addcarry.32(i8 0, i32 %3, i32 %1)
  %5 = extractvalue { i8, i32 } %4, 1
  store i32 %5, i32* %0, align 8
  %6 = extractvalue { i8, i32 } %4, 0
  %7 = icmp eq i8 %6, 0
  %8 = add i32 %3, %1
  %9 = or i32 %5, %8
  %10 = select i1 %7, i32 0, i32 %9
  ret i32 %10
}

declare { i8, i32 } @llvm.x86.addcarry.32(i8, i32, i32)
