; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64-pc-windows-macho -O0 < %s -o - | FileCheck %s
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-macho"

; This test checks that on Win32 MachO targets we don't xor the cookie with rbp before checking.

@.str = private unnamed_addr constant [15 x i8] c"Hello World!\0A \00", align 1
define dso_local i32 @main(i32 %argc, i8** %argv, ...) #0 {
; CHECK-LABEL: main:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    pushq %rbp
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset %rbp, -16
; CHECK-NEXT:    movq %rsp, %rbp
; CHECK-NEXT:    .cfi_def_cfa_register %rbp
; CHECK-NEXT:    subq $320, %rsp ## imm = 0x140
; CHECK-NEXT:    movq ___security_cookie@GOTPCREL(%rip), %rax
; CHECK-NEXT:    movq (%rax), %rax
; CHECK-NEXT:    movq %rax, -8(%rbp)
; CHECK-NEXT:    movl %ecx, -276(%rbp)
; CHECK-NEXT:    movq %rdx, -288(%rbp)
; CHECK-NEXT:    movslq -276(%rbp), %rax
; CHECK-NEXT:    movb $1, -272(%rbp,%rax)
; CHECK-NEXT:    leaq L_.str(%rip), %rcx
; CHECK-NEXT:    callq _printf
; CHECK-NEXT:    movq -8(%rbp), %rcx
; CHECK-NEXT:    callq ___security_check_cookie
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    addq $320, %rsp ## imm = 0x140
; CHECK-NEXT:    popq %rbp
; CHECK-NEXT:    retq
entry:
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %Buffer = alloca [256 x i8], align 16
  store i32 %argc, i32* %argc.addr, align 4
  store i8** %argv, i8*** %argv.addr, align 8
  %0 = load i32, i32* %argc.addr, align 4
  %idxprom = sext i32 %0 to i64
  %arrayidx = getelementptr inbounds [256 x i8], [256 x i8]* %Buffer, i64 0, i64 %idxprom
  store i8 1, i8* %arrayidx, align 1
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str, i64 0, i64 0))
  ret i32 0
}
declare dso_local i32 @printf(i8*, ...) #1

attributes #0 = { sspstrong "frame-pointer"="all" "stack-protector-buffer-size"="8"}
attributes #1 = { "frame-pointer"="all" "stack-protector-buffer-size"="8" }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{!"clang version 10.0.0"}
