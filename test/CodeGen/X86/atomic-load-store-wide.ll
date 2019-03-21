; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mcpu=corei7 -mtriple=i686-- -verify-machineinstrs | FileCheck %s

; 64-bit load/store on x86-32
; FIXME: The generated code can be substantially improved.

define void @test1(i64* %ptr, i64 %val1) {
; CHECK-LABEL: test1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pushl %ebx
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    pushl %esi
; CHECK-NEXT:    .cfi_def_cfa_offset 12
; CHECK-NEXT:    .cfi_offset %esi, -12
; CHECK-NEXT:    .cfi_offset %ebx, -8
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %ebx
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %esi
; CHECK-NEXT:    movl (%esi), %eax
; CHECK-NEXT:    movl 4(%esi), %edx
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB0_1: # %atomicrmw.start
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    lock cmpxchg8b (%esi)
; CHECK-NEXT:    jne .LBB0_1
; CHECK-NEXT:  # %bb.2: # %atomicrmw.end
; CHECK-NEXT:    popl %esi
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    popl %ebx
; CHECK-NEXT:    .cfi_def_cfa_offset 4
; CHECK-NEXT:    retl
  store atomic i64 %val1, i64* %ptr seq_cst, align 8
  ret void
}

define i64 @test2(i64* %ptr) {
; CHECK-LABEL: test2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pushl %ebx
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    pushl %esi
; CHECK-NEXT:    .cfi_def_cfa_offset 12
; CHECK-NEXT:    .cfi_offset %esi, -12
; CHECK-NEXT:    .cfi_offset %ebx, -8
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %esi
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    xorl %edx, %edx
; CHECK-NEXT:    xorl %ecx, %ecx
; CHECK-NEXT:    xorl %ebx, %ebx
; CHECK-NEXT:    lock cmpxchg8b (%esi)
; CHECK-NEXT:    popl %esi
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    popl %ebx
; CHECK-NEXT:    .cfi_def_cfa_offset 4
; CHECK-NEXT:    retl
  %val = load atomic i64, i64* %ptr seq_cst, align 8
  ret i64 %val
}
