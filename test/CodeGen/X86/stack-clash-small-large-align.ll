; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --no_x86_scrub_sp
; RUN: llc < %s | FileCheck %s
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

define i32 @foo_noprotect() local_unnamed_addr {
; CHECK-LABEL: foo_noprotect:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pushq %rbp
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset %rbp, -16
; CHECK-NEXT:    movq %rsp, %rbp
; CHECK-NEXT:    .cfi_def_cfa_register %rbp
; CHECK-NEXT:    andq $-65536, %rsp # imm = 0xFFFF0000
; CHECK-NEXT:    subq $65536, %rsp # imm = 0x10000
; CHECK-NEXT:    movl $1, 392(%rsp)
; CHECK-NEXT:    movl (%rsp), %eax
; CHECK-NEXT:    movq %rbp, %rsp
; CHECK-NEXT:    popq %rbp
; CHECK-NEXT:    .cfi_def_cfa %rsp, 8
; CHECK-NEXT:    retq
  %a = alloca i32, i64 100, align 65536
  %b = getelementptr inbounds i32, i32* %a, i64 98
  store volatile i32 1, i32* %b
  %c = load volatile i32, i32* %a
  ret i32 %c
}

define i32 @foo_protect() local_unnamed_addr #0 {
; CHECK-LABEL: foo_protect:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pushq %rbp
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset %rbp, -16
; CHECK-NEXT:    movq %rsp, %rbp
; CHECK-NEXT:    .cfi_def_cfa_register %rbp
; CHECK-NEXT:    movq %rsp, %r11
; CHECK-NEXT:    andq $-65536, %r11 # imm = 0xFFFF0000
; CHECK-NEXT:    cmpq %rsp, %r11
; CHECK-NEXT:    je .LBB1_4
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    subq $4096, %rsp # imm = 0x1000
; CHECK-NEXT:    cmpq %rsp, %r11
; CHECK-NEXT:    jb .LBB1_3
; CHECK-NEXT:  .LBB1_2: # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    movq $0, (%rsp)
; CHECK-NEXT:    subq $4096, %rsp # imm = 0x1000
; CHECK-NEXT:    cmpq %rsp, %r11
; CHECK-NEXT:    jb .LBB1_2
; CHECK-NEXT:  .LBB1_3:
; CHECK-NEXT:    movq %r11, %rsp
; CHECK-NEXT:    movq $0, (%rsp)
; CHECK-NEXT:  .LBB1_4:
; CHECK-NEXT:    movq %rsp, %r11
; CHECK-NEXT:    subq $65536, %r11 # imm = 0x10000
; CHECK-NEXT:  .LBB1_5: # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    subq $4096, %rsp # imm = 0x1000
; CHECK-NEXT:    movq $0, (%rsp)
; CHECK-NEXT:    cmpq %r11, %rsp
; CHECK-NEXT:    jne .LBB1_5
; CHECK-NEXT:  # %bb.6:
; CHECK-NEXT:    movl $1, 392(%rsp)
; CHECK-NEXT:    movl (%rsp), %eax
; CHECK-NEXT:    movq %rbp, %rsp
; CHECK-NEXT:    popq %rbp
; CHECK-NEXT:    .cfi_def_cfa %rsp, 8
; CHECK-NEXT:    retq
  %a = alloca i32, i64 100, align 65536
  %b = getelementptr inbounds i32, i32* %a, i64 98
  store volatile i32 1, i32* %b
  %c = load volatile i32, i32* %a
  ret i32 %c
}

attributes #0 =  {"probe-stack"="inline-asm"}
