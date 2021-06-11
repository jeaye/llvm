; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -O3 -enable-implicit-null-checks -mcpu=skylake -x86-align-branch-boundary=32 -x86-align-branch=call+jmp+indirect+ret+jcc < %s | FileCheck %s

;; The tests in this file check that various constructs which need to disable
;; prefix and/or nop padding do so in the right places.  However, since we
;; don't yet have assembler syntax for this, they're only able to check
;; comments and must hope the assembler does the right thing.

target datalayout = "e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; If we have autopadding enabled, make sure the label isn't separated from
; the mov.
define i32 @implicit_null_check(i32* %x) {
; CHECK-LABEL: implicit_null_check:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    #noautopadding
; CHECK-NEXT:  .Ltmp0:
; CHECK-NEXT:    movl (%rdi), %eax # on-fault: .LBB0_1
; CHECK-NEXT:    #autopadding
; CHECK-NEXT:  # %bb.2: # %not_null
; CHECK-NEXT:    retq
; CHECK-NEXT:  .LBB0_1: # %is_null
; CHECK-NEXT:    movl $42, %eax
; CHECK-NEXT:    retq

 entry:
  %c = icmp eq i32* %x, null
  br i1 %c, label %is_null, label %not_null, !make.implicit !{}

 is_null:
  ret i32 42

 not_null:
  %t = load atomic i32, i32* %x unordered, align 4
  ret i32 %t
}

; Label must bind to call before
define void @test_statepoint(i32 addrspace(1)* %ptr) gc "statepoint-example" {
; CHECK-LABEL: test_statepoint:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    #noautopadding
; CHECK-NEXT:    callq return_i1@PLT
; CHECK-NEXT:  .Ltmp1:
; CHECK-NEXT:    #autopadding
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    retq
entry:
  call token (i64, i32, i1 ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_i1f(i64 0, i32 0, i1 ()* @return_i1, i32 0, i32 0, i32 0, i32 0)
  ret void
}

declare zeroext i1 @return_i1()
declare token @llvm.experimental.gc.statepoint.p0f_i1f(i64, i32, i1 ()*, i32, i32, ...)


; Label must bind to following nop sequence
define void @patchpoint(i64 %a, i64 %b) {
; CHECK-LABEL: patchpoint:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rbp
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset %rbp, -16
; CHECK-NEXT:    movq %rsp, %rbp
; CHECK-NEXT:    .cfi_def_cfa_register %rbp
; CHECK-NEXT:    #noautopadding
; CHECK-NEXT:  .Ltmp2:
; CHECK-NEXT:    .byte 102
; CHECK-NEXT:    .byte 102
; CHECK-NEXT:    .byte 102
; CHECK-NEXT:    .byte 102
; CHECK-NEXT:    .byte 102
; CHECK-NEXT:    nopw %cs:512(%rax,%rax)
; CHECK-NEXT:    #autopadding
; CHECK-NEXT:    popq %rbp
; CHECK-NEXT:    .cfi_def_cfa %rsp, 8
; CHECK-NEXT:    retq
entry:
  call void (i64, i32, i8*, i32, ...) @llvm.experimental.patchpoint.void(i64 4, i32 15, i8* null, i32 0, i64 %a, i64 %b)
  ret void
}


declare void @llvm.experimental.stackmap(i64, i32, ...)
declare void @llvm.experimental.patchpoint.void(i64, i32, i8*, i32, ...)
