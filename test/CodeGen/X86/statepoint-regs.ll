; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -O3 -use-registers-for-deopt-values -restrict-statepoint-remat=true < %s | FileCheck %s
target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.11.0"

declare void @bar() #0
declare void @baz()

; Spill caller saved register for %a.
define void @test1(i32 %a) gc "statepoint-example" {
; CHECK-LABEL: test1:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset %rbx, -16
; CHECK-NEXT:    movl %edi, %ebx
; CHECK-NEXT:    callq _bar
; CHECK-NEXT:  Ltmp0:
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    retq
entry:
  %statepoint_token1 = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @bar, i32 0, i32 0, i32 0, i32 0) ["deopt" (i32 %a)]
  ret void
}

; Callee save registers are ok.
define void @test2(i32 %a, i32 %b) gc "statepoint-example" {
; CHECK-LABEL: test2:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    pushq %rbp
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 24
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    .cfi_offset %rbx, -24
; CHECK-NEXT:    .cfi_offset %rbp, -16
; CHECK-NEXT:    movl %esi, %ebx
; CHECK-NEXT:    movl %edi, %ebp
; CHECK-NEXT:    callq _bar
; CHECK-NEXT:  Ltmp1:
; CHECK-NEXT:    callq _bar
; CHECK-NEXT:  Ltmp2:
; CHECK-NEXT:    addq $8, %rsp
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    popq %rbp
; CHECK-NEXT:    retq
entry:
  call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @bar, i32 0, i32 0, i32 0, i32 0) ["deopt" (i32 %a, i32 %b)]
  call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @bar, i32 0, i32 0, i32 0, i32 0) ["deopt" (i32 %b, i32 %a)]
  ret void
}

; Arguments in caller saved registers, so they must be spilled.
define void @test3(i32 %a, i32 %b, i32 %c, i32 %d, i32 %e, i32 %f, i32 %g, i32 %h, i32 %i) gc "statepoint-example" {
; CHECK-LABEL: test3:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    pushq %rbp
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    pushq %r15
; CHECK-NEXT:    .cfi_def_cfa_offset 24
; CHECK-NEXT:    pushq %r14
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    pushq %r13
; CHECK-NEXT:    .cfi_def_cfa_offset 40
; CHECK-NEXT:    pushq %r12
; CHECK-NEXT:    .cfi_def_cfa_offset 48
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 56
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 64
; CHECK-NEXT:    .cfi_offset %rbx, -56
; CHECK-NEXT:    .cfi_offset %r12, -48
; CHECK-NEXT:    .cfi_offset %r13, -40
; CHECK-NEXT:    .cfi_offset %r14, -32
; CHECK-NEXT:    .cfi_offset %r15, -24
; CHECK-NEXT:    .cfi_offset %rbp, -16
; CHECK-NEXT:    movl %r9d, %r14d
; CHECK-NEXT:    movl %r8d, %r15d
; CHECK-NEXT:    movl %ecx, %r12d
; CHECK-NEXT:    movl %edx, %r13d
; CHECK-NEXT:    movl %esi, %ebx
; CHECK-NEXT:    movl %edi, %ebp
; CHECK-NEXT:    callq _bar
; CHECK-NEXT:  Ltmp3:
; CHECK-NEXT:    addq $8, %rsp
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    popq %r12
; CHECK-NEXT:    popq %r13
; CHECK-NEXT:    popq %r14
; CHECK-NEXT:    popq %r15
; CHECK-NEXT:    popq %rbp
; CHECK-NEXT:    retq
entry:
  %statepoint_token1 = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @bar, i32 0, i32 0, i32 0, i32 0) ["deopt" (i32 %a, i32 %b, i32 %c, i32 %d, i32 %e, i32 %f, i32 %g, i32 %h, i32 %i)]
  ret void
}

; This case just confirms that we don't crash when given more live values
; than registers.  This is a case where we *have* to use a stack slot.  This
; also ends up being a good test of whether we can fold loads from immutable
; stack slots into the statepoint.
define void @test4(i32 %a, i32 %b, i32 %c, i32 %d, i32 %e, i32 %f, i32 %g, i32 %h, i32 %i, i32 %j, i32 %k, i32 %l, i32 %m, i32 %n, i32 %o, i32 %p, i32 %q, i32 %r, i32 %s, i32 %t, i32 %u, i32 %v, i32 %w, i32 %x, i32 %y, i32 %z) gc "statepoint-example" {
; CHECK-LABEL: test4:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    pushq %rbp
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    pushq %r15
; CHECK-NEXT:    .cfi_def_cfa_offset 24
; CHECK-NEXT:    pushq %r14
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    pushq %r13
; CHECK-NEXT:    .cfi_def_cfa_offset 40
; CHECK-NEXT:    pushq %r12
; CHECK-NEXT:    .cfi_def_cfa_offset 48
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 56
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 64
; CHECK-NEXT:    .cfi_offset %rbx, -56
; CHECK-NEXT:    .cfi_offset %r12, -48
; CHECK-NEXT:    .cfi_offset %r13, -40
; CHECK-NEXT:    .cfi_offset %r14, -32
; CHECK-NEXT:    .cfi_offset %r15, -24
; CHECK-NEXT:    .cfi_offset %rbp, -16
; CHECK-NEXT:    movl %r9d, %r14d
; CHECK-NEXT:    movl %r8d, %r15d
; CHECK-NEXT:    movl %ecx, %r12d
; CHECK-NEXT:    movl %edx, %r13d
; CHECK-NEXT:    movl %esi, %ebx
; CHECK-NEXT:    movl %edi, %ebp
; CHECK-NEXT:    callq _bar
; CHECK-NEXT:  Ltmp4:
; CHECK-NEXT:    addq $8, %rsp
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    popq %r12
; CHECK-NEXT:    popq %r13
; CHECK-NEXT:    popq %r14
; CHECK-NEXT:    popq %r15
; CHECK-NEXT:    popq %rbp
; CHECK-NEXT:    retq
entry:
  %statepoint_token1 = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @bar, i32 0, i32 0, i32 0, i32 0) ["deopt" (i32 %a, i32 %b, i32 %c, i32 %d, i32 %e, i32 %f, i32 %g, i32 %h, i32 %i, i32 %j, i32 %k, i32 %l, i32 %m, i32 %n, i32 %o, i32 %p, i32 %q, i32 %r, i32 %s, i32 %t, i32 %u, i32 %v, i32 %w, i32 %x, i32 %y, i32 %z)]
  ret void
}

; A gc-value must be spilled even if it is also a deopt value.
define  i32 addrspace(1)* @test5(i32 %a, i32 addrspace(1)* %p) gc "statepoint-example" {
; CHECK-LABEL: test5:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    subq $16, %rsp
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    .cfi_offset %rbx, -16
; CHECK-NEXT:    movl %edi, %ebx
; CHECK-NEXT:    movq %rsi, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    callq _bar
; CHECK-NEXT:  Ltmp5:
; CHECK-NEXT:    callq _bar
; CHECK-NEXT:  Ltmp6:
; CHECK-NEXT:    movq {{[0-9]+}}(%rsp), %rax
; CHECK-NEXT:    addq $16, %rsp
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    retq
entry:
  %token = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @bar, i32 0, i32 0, i32 0, i32 0) ["gc-live" (i32 addrspace(1)* %p, i32 addrspace(1)* %p), "deopt"(i32 %a)]
  %p2 = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token %token,  i32 1, i32 1)
  %token2 = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @bar, i32 0, i32 0, i32 0, i32 0) ["gc-live" (i32 addrspace(1)* %p2, i32 addrspace(1)* %p2), "deopt"(i32 %a)]
  %p3 = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token %token2,  i32 1, i32 1)
  ret i32 addrspace(1)* %p3
}

; Callee saved are ok again.
define void @test6(i32 %a) gc "statepoint-example" {
; CHECK-LABEL: test6:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset %rbx, -16
; CHECK-NEXT:    movl %edi, %ebx
; CHECK-NEXT:    callq _baz
; CHECK-NEXT:  Ltmp7:
; CHECK-NEXT:    callq _bar
; CHECK-NEXT:  Ltmp8:
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    retq
entry:
  call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @baz, i32 0, i32 0, i32 0, i32 0) ["deopt" (i32 %a)]
  call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @bar, i32 0, i32 0, i32 0, i32 0) ["deopt" (i32 %a)]
  ret void
}

; Many deopt values.
define void @test7(i32 %a, i32 %b, i32 %c, i32 %d, i32 %e, i32 %f, i32 %g, i32 %h, i32 %i, i32 %j, i32 %k, i32 %l, i32 %m, i32 %n, i32 %o, i32 %p, i32 %q, i32 %r, i32 %s, i32 %t, i32 %u, i32 %v, i32 %w, i32 %x, i32 %y, i32 %z) gc "statepoint-example" {
; The code for this is terrible, check simply for correctness for the moment
; CHECK-LABEL: test7:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    pushq %rbp
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    pushq %r15
; CHECK-NEXT:    .cfi_def_cfa_offset 24
; CHECK-NEXT:    pushq %r14
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    pushq %r13
; CHECK-NEXT:    .cfi_def_cfa_offset 40
; CHECK-NEXT:    pushq %r12
; CHECK-NEXT:    .cfi_def_cfa_offset 48
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 56
; CHECK-NEXT:    subq $168, %rsp
; CHECK-NEXT:    .cfi_def_cfa_offset 224
; CHECK-NEXT:    .cfi_offset %rbx, -56
; CHECK-NEXT:    .cfi_offset %r12, -48
; CHECK-NEXT:    .cfi_offset %r13, -40
; CHECK-NEXT:    .cfi_offset %r14, -32
; CHECK-NEXT:    .cfi_offset %r15, -24
; CHECK-NEXT:    .cfi_offset %rbp, -16
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl %edi, %r13d
; CHECK-NEXT:    movl %esi, %ebx
; CHECK-NEXT:    movl %edx, %ebp
; CHECK-NEXT:    movl %ecx, %r14d
; CHECK-NEXT:    movl %r8d, %r15d
; CHECK-NEXT:    movl %r9d, %r12d
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    callq _bar ## 160-byte Folded Reload
; CHECK-NEXT:  Ltmp9:
; CHECK-NEXT:    addq $168, %rsp
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    popq %r12
; CHECK-NEXT:    popq %r13
; CHECK-NEXT:    popq %r14
; CHECK-NEXT:    popq %r15
; CHECK-NEXT:    popq %rbp
; CHECK-NEXT:    retq
entry:
  %a64 = zext i32 %a to i64
  %b64 = zext i32 %b to i64
  %c64 = zext i32 %c to i64
  %d64 = zext i32 %d to i64
  %e64 = zext i32 %e to i64
  %f64 = zext i32 %f to i64
  %g64 = zext i32 %g to i64
  %h64 = zext i32 %h to i64
  %i64 = zext i32 %i to i64
  %j64 = zext i32 %j to i64
  %k64 = zext i32 %k to i64
  %l64 = zext i32 %l to i64
  %m64 = zext i32 %m to i64
  %n64 = zext i32 %n to i64
  %o64 = zext i32 %o to i64
  %p64 = zext i32 %p to i64
  %q64 = zext i32 %q to i64
  %r64 = zext i32 %r to i64
  %s64 = zext i32 %s to i64
  %t64 = zext i32 %t to i64
  %u64 = zext i32 %u to i64
  %v64 = zext i32 %v to i64
  %w64 = zext i32 %w to i64
  %x64 = zext i32 %x to i64
  %y64 = zext i32 %y to i64
  %z64 = zext i32 %z to i64
  %statepoint_token1 = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @bar, i32 0, i32 0, i32 0, i32 0) ["deopt" (i64 %a64, i64 %b64, i64 %c64, i64 %d64, i64 %e64, i64 %f64, i64 %g64, i64 %h64, i64 %i64, i64 %j64, i64 %k64, i64 %l64, i64 %m64, i64 %n64, i64 %o64, i64 %p64, i64 %q64, i64 %r64, i64 %s64, i64 %t64, i64 %u64, i64 %v64, i64 %w64, i64 %x64, i64 %y64, i64 %z64)]
  ret void
}

; a variant of test7 with mixed types chosen to exercise register aliases
define void @test8(i32 %a, i32 %b, i32 %c, i32 %d, i32 %e, i32 %f, i32 %g, i32 %h, i32 %i, i32 %j, i32 %k, i32 %l, i32 %m, i32 %n, i32 %o, i32 %p, i32 %q, i32 %r, i32 %s, i32 %t, i32 %u, i32 %v, i32 %w, i32 %x, i32 %y, i32 %z) gc "statepoint-example" {
; The code for this is terrible, check simply for correctness for the moment
; CHECK-LABEL: test8:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    pushq %rbp
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    pushq %r15
; CHECK-NEXT:    .cfi_def_cfa_offset 24
; CHECK-NEXT:    pushq %r14
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    pushq %r13
; CHECK-NEXT:    .cfi_def_cfa_offset 40
; CHECK-NEXT:    pushq %r12
; CHECK-NEXT:    .cfi_def_cfa_offset 48
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 56
; CHECK-NEXT:    subq $136, %rsp
; CHECK-NEXT:    .cfi_def_cfa_offset 192
; CHECK-NEXT:    .cfi_offset %rbx, -56
; CHECK-NEXT:    .cfi_offset %r12, -48
; CHECK-NEXT:    .cfi_offset %r13, -40
; CHECK-NEXT:    .cfi_offset %r14, -32
; CHECK-NEXT:    .cfi_offset %r15, -24
; CHECK-NEXT:    .cfi_offset %rbp, -16
; CHECK-NEXT:    movl %r9d, {{[-0-9]+}}(%r{{[sb]}}p) ## 4-byte Spill
; CHECK-NEXT:    movl %r8d, (%rsp) ## 4-byte Spill
; CHECK-NEXT:    movl %ecx, %r12d
; CHECK-NEXT:    movl %edx, %r13d
; CHECK-NEXT:    movl %esi, %ebx
; CHECK-NEXT:    movl %edi, %ebp
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %r14d
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %r15d
; CHECK-NEXT:    callq _bar ## 132-byte Folded Reload
; CHECK-NEXT:  Ltmp10:
; CHECK-NEXT:    addq $136, %rsp
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    popq %r12
; CHECK-NEXT:    popq %r13
; CHECK-NEXT:    popq %r14
; CHECK-NEXT:    popq %r15
; CHECK-NEXT:    popq %rbp
; CHECK-NEXT:    retq
entry:
  %a8 = trunc i32 %a to i8
  %b8 = trunc i32 %b to i8
  %c8 = trunc i32 %c to i8
  %d8 = trunc i32 %d to i8
  %e16 = trunc i32 %e to i16
  %f16 = trunc i32 %f to i16
  %g16 = trunc i32 %g to i16
  %h16 = trunc i32 %h to i16
  %i64 = zext i32 %i to i64
  %j64 = zext i32 %j to i64
  %k64 = zext i32 %k to i64
  %l64 = zext i32 %l to i64
  %m64 = zext i32 %m to i64
  %n64 = zext i32 %n to i64
  %o64 = zext i32 %o to i64
  %p64 = zext i32 %p to i64
  %q64 = zext i32 %q to i64
  %r64 = zext i32 %r to i64
  %s64 = zext i32 %s to i64
  %t64 = zext i32 %t to i64
  %u64 = zext i32 %u to i64
  %v64 = zext i32 %v to i64
  %w64 = zext i32 %w to i64
  %x64 = zext i32 %x to i64
  %y64 = zext i32 %y to i64
  %z64 = zext i32 %z to i64
  %statepoint_token1 = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @bar, i32 0, i32 0, i32 0, i32 0) ["deopt" (i8 %a8, i8 %b8, i8 %c8, i8 %d8, i16 %e16, i16 %f16, i16 %g16, i16 %h16, i64 %i64, i64 %j64, i64 %k64, i64 %l64, i64 %m64, i64 %n64, i64 %o64, i64 %p64, i64 %q64, i64 %r64, i64 %s64, i64 %t64, i64 %u64, i64 %v64, i64 %w64, i64 %x64, i64 %y64, i64 %z64)]
  ret void
}

; Test perfect forwarding of argument registers and stack slots to the
; deopt bundle uses
define void @test9(i32 %a, i32 %b, i32 %c, i32 %d, i32 %e, i32 %f, i32 %g, i32 %h, i32 %i, i32 %j, i32 %k, i32 %l, i32 %m, i32 %n, i32 %o, i32 %p, i32 %q, i32 %r, i32 %s, i32 %t, i32 %u, i32 %v, i32 %w, i32 %x, i32 %y, i32 %z) gc "statepoint-example" {
; CHECK-LABEL: test9:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    pushq %rbp
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    pushq %r15
; CHECK-NEXT:    .cfi_def_cfa_offset 24
; CHECK-NEXT:    pushq %r14
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    pushq %r13
; CHECK-NEXT:    .cfi_def_cfa_offset 40
; CHECK-NEXT:    pushq %r12
; CHECK-NEXT:    .cfi_def_cfa_offset 48
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 56
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 64
; CHECK-NEXT:    .cfi_offset %rbx, -56
; CHECK-NEXT:    .cfi_offset %r12, -48
; CHECK-NEXT:    .cfi_offset %r13, -40
; CHECK-NEXT:    .cfi_offset %r14, -32
; CHECK-NEXT:    .cfi_offset %r15, -24
; CHECK-NEXT:    .cfi_offset %rbp, -16
; CHECK-NEXT:    movl %r9d, %r14d
; CHECK-NEXT:    movl %r8d, %r15d
; CHECK-NEXT:    movl %ecx, %r12d
; CHECK-NEXT:    movl %edx, %r13d
; CHECK-NEXT:    movl %esi, %ebx
; CHECK-NEXT:    movl %edi, %ebp
; CHECK-NEXT:    callq _bar
; CHECK-NEXT:  Ltmp11:
; CHECK-NEXT:    addq $8, %rsp
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    popq %r12
; CHECK-NEXT:    popq %r13
; CHECK-NEXT:    popq %r14
; CHECK-NEXT:    popq %r15
; CHECK-NEXT:    popq %rbp
; CHECK-NEXT:    retq

entry:
  %statepoint_token1 = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @bar, i32 0, i32 0, i32 0, i32 0) ["deopt" (i32 %a, i32 %b, i32 %c, i32 %d, i32 %e, i32 %f, i32 %g, i32 %h, i32 %i, i32 %j, i32 %k, i32 %l, i32 %m, i32 %n, i32 %o, i32 %p, i32 %q, i32 %r, i32 %s, i32 %t, i32 %u, i32 %v, i32 %w, i32 %x, i32 %y, i32 %z)]
  ret void
}

; Test enough folding of argument slots when we have one call which clobbers
; registers before a second which needs them - i.e. we must do something with
; arguments originally passed in registers
define void @test10(i32 %a, i32 %b, i32 %c, i32 %d, i32 %e, i32 %f, i32 %g, i32 %h, i32 %i, i32 %j, i32 %k, i32 %l, i32 %m, i32 %n, i32 %o, i32 %p, i32 %q, i32 %r, i32 %s, i32 %t, i32 %u, i32 %v, i32 %w, i32 %x, i32 %y, i32 %z) gc "statepoint-example" {
; FIXME (minor): It would be better to just spill (and fold reload) for
; argument registers then spill and fill all the CSRs.
; CHECK-LABEL: test10:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    pushq %rbp
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    pushq %r15
; CHECK-NEXT:    .cfi_def_cfa_offset 24
; CHECK-NEXT:    pushq %r14
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    pushq %r13
; CHECK-NEXT:    .cfi_def_cfa_offset 40
; CHECK-NEXT:    pushq %r12
; CHECK-NEXT:    .cfi_def_cfa_offset 48
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 56
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 64
; CHECK-NEXT:    .cfi_offset %rbx, -56
; CHECK-NEXT:    .cfi_offset %r12, -48
; CHECK-NEXT:    .cfi_offset %r13, -40
; CHECK-NEXT:    .cfi_offset %r14, -32
; CHECK-NEXT:    .cfi_offset %r15, -24
; CHECK-NEXT:    .cfi_offset %rbp, -16
; CHECK-NEXT:    movl %r9d, %r15d
; CHECK-NEXT:    movl %r8d, %r14d
; CHECK-NEXT:    movl %ecx, %r12d
; CHECK-NEXT:    movl %edx, %r13d
; CHECK-NEXT:    movl %esi, %ebx
; CHECK-NEXT:    movl %edi, %ebp
; CHECK-NEXT:    callq _bar
; CHECK-NEXT:  Ltmp12:
; CHECK-NEXT:    callq _bar
; CHECK-NEXT:  Ltmp13:
; CHECK-NEXT:    addq $8, %rsp
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    popq %r12
; CHECK-NEXT:    popq %r13
; CHECK-NEXT:    popq %r14
; CHECK-NEXT:    popq %r15
; CHECK-NEXT:    popq %rbp
; CHECK-NEXT:    retq

entry:
  %statepoint_token1 = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @bar, i32 0, i32 0, i32 0, i32 0) ["deopt" (i32 %a, i32 %b, i32 %c, i32 %d, i32 %e, i32 %f, i32 %g, i32 %h, i32 %i, i32 %j, i32 %k, i32 %l, i32 %m, i32 %n, i32 %o, i32 %p, i32 %q, i32 %r, i32 %s, i32 %t, i32 %u, i32 %v, i32 %w, i32 %x, i32 %y, i32 %z)]
  %statepoint_token2 = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @bar, i32 0, i32 0, i32 0, i32 0) ["deopt" (i32 %a, i32 %b, i32 %c, i32 %d, i32 %e, i32 %f, i32 %g, i32 %h, i32 %i, i32 %j, i32 %k, i32 %l, i32 %m, i32 %n, i32 %o, i32 %p, i32 %q, i32 %r, i32 %s, i32 %t, i32 %u, i32 %v, i32 %w, i32 %x, i32 %y, i32 %z)]
  ret void
}

; Check that we can remat some uses of a def despite not remating before the
; statepoint user.
define i64 @test11(i32 %a, i32 %b, i32 %c, i32 %d, i32 %e, i32 %f, i32 %g, i32 %h, i32 %i, i32 %j, i32 %k, i32 %l, i32 %m, i32 %n, i32 %o, i32 %p, i32 %q, i32 %r, i32 %s, i32 %t, i32 %u, i32 %v, i32 %w, i32 %x, i32 %y, i32 %z) gc "statepoint-example" {
; FIXME: The codegen for this is correct, but horrible.  Lots of room for
; improvement if we so desire.
; CHECK-LABEL: test11:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    pushq %rbp
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    pushq %r15
; CHECK-NEXT:    .cfi_def_cfa_offset 24
; CHECK-NEXT:    pushq %r14
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    pushq %r13
; CHECK-NEXT:    .cfi_def_cfa_offset 40
; CHECK-NEXT:    pushq %r12
; CHECK-NEXT:    .cfi_def_cfa_offset 48
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 56
; CHECK-NEXT:    subq $168, %rsp
; CHECK-NEXT:    .cfi_def_cfa_offset 224
; CHECK-NEXT:    .cfi_offset %rbx, -56
; CHECK-NEXT:    .cfi_offset %r12, -48
; CHECK-NEXT:    .cfi_offset %r13, -40
; CHECK-NEXT:    .cfi_offset %r14, -32
; CHECK-NEXT:    .cfi_offset %r15, -24
; CHECK-NEXT:    .cfi_offset %rbp, -16
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl %edi, %ebx
; CHECK-NEXT:    movl %esi, %r15d
; CHECK-NEXT:    movl %edx, %r12d
; CHECK-NEXT:    movl %ecx, %r13d
; CHECK-NEXT:    movl %r8d, %ebp
; CHECK-NEXT:    movl %r9d, %r14d
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; CHECK-NEXT:    callq _bar ## 160-byte Folded Reload
; CHECK-NEXT:  Ltmp14:
; CHECK-NEXT:    addq %r15, %rbx
; CHECK-NEXT:    addq %r12, %rbx
; CHECK-NEXT:    addq %r13, %rbx
; CHECK-NEXT:    addq %rbp, %rbx
; CHECK-NEXT:    addq %r14, %rbx
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    addq %rax, %rbx
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    addq %rax, %rbx
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    addq %rax, %rbx
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    addq %rax, %rbx
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    addq %rax, %rbx
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    addq %rax, %rbx
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    addq %rax, %rbx
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    addq %rax, %rbx
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    addq %rax, %rbx
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    addq %rax, %rbx
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    addq %rax, %rbx
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    addq %rax, %rbx
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    addq %rax, %rbx
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    addq %rax, %rbx
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    addq %rax, %rbx
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    addq %rax, %rbx
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    addq %rax, %rbx
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    addq %rax, %rbx
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    addq %rax, %rbx
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    addq %rax, %rbx
; CHECK-NEXT:    movq %rbx, %rax
; CHECK-NEXT:    addq $168, %rsp
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    popq %r12
; CHECK-NEXT:    popq %r13
; CHECK-NEXT:    popq %r14
; CHECK-NEXT:    popq %r15
; CHECK-NEXT:    popq %rbp
; CHECK-NEXT:    retq

entry:
  %a64 = zext i32 %a to i64
  %b64 = zext i32 %b to i64
  %c64 = zext i32 %c to i64
  %d64 = zext i32 %d to i64
  %e64 = zext i32 %e to i64
  %f64 = zext i32 %f to i64
  %g64 = zext i32 %g to i64
  %h64 = zext i32 %h to i64
  %i64 = zext i32 %i to i64
  %j64 = zext i32 %j to i64
  %k64 = zext i32 %k to i64
  %l64 = zext i32 %l to i64
  %m64 = zext i32 %m to i64
  %n64 = zext i32 %n to i64
  %o64 = zext i32 %o to i64
  %p64 = zext i32 %p to i64
  %q64 = zext i32 %q to i64
  %r64 = zext i32 %r to i64
  %s64 = zext i32 %s to i64
  %t64 = zext i32 %t to i64
  %u64 = zext i32 %u to i64
  %v64 = zext i32 %v to i64
  %w64 = zext i32 %w to i64
  %x64 = zext i32 %x to i64
  %y64 = zext i32 %y to i64
  %z64 = zext i32 %z to i64
  call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @bar, i32 0, i32 0, i64 0, i64 0) ["deopt" (i64 %a64, i64 %b64, i64 %c64, i64 %d64, i64 %e64, i64 %f64, i64 %g64, i64 %h64, i64 %i64, i64 %j64, i64 %k64, i64 %l64, i64 %m64, i64 %n64, i64 %o64, i64 %p64, i64 %q64, i64 %r64, i64 %s64, i64 %t64, i64 %u64, i64 %v64, i64 %w64, i64 %x64, i64 %y64, i64 %z64)]
  %addab = add i64 %a64, %b64
  %addc = add i64 %addab, %c64
  %addd = add i64 %addc, %d64
  %adde = add i64 %addd, %e64
  %addf = add i64 %adde, %f64
  %addg = add i64 %addf, %g64
  %addh = add i64 %addg, %h64
  %addi = add i64 %addh, %i64
  %addj = add i64 %addi, %j64
  %addk = add i64 %addj, %k64
  %addl = add i64 %addk, %l64
  %addm = add i64 %addl, %m64
  %addn = add i64 %addm, %n64
  %addo = add i64 %addn, %o64
  %addp = add i64 %addo, %p64
  %addq = add i64 %addp, %q64
  %addr = add i64 %addq, %r64
  %adds = add i64 %addr, %s64
  %addt = add i64 %adds, %t64
  %addu = add i64 %addt, %u64
  %addv = add i64 %addu, %v64
  %addw = add i64 %addv, %w64
  %addx = add i64 %addw, %x64
  %addy = add i64 %addx, %y64
  %addz = add i64 %addy, %z64
  ret i64 %addz
}

; Demonstrate address of a function (w/ spilling due to caller saved register is used)
define void @addr_func() gc "statepoint-example" {
; CHECK-LABEL: addr_func:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset %rbx, -16
; CHECK-NEXT:    movq _bar@GOTPCREL(%rip), %rbx
; CHECK-NEXT:    callq _bar
; CHECK-NEXT:  Ltmp15:
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    retq
entry:
  %statepoint_token1 = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @bar, i32 0, i32 0, i64 0, i64 0) ["deopt" (void ()* @bar, void ()* @bar, void ()* @bar)]
  ret void
}

; Demonstrate address of a global (w/ spilling due to caller saved register is used)
@G = external global i32
define void @addr_global() gc "statepoint-example" {
; CHECK-LABEL: addr_global:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset %rbx, -16
; CHECK-NEXT:    movq _G@GOTPCREL(%rip), %rbx
; CHECK-NEXT:    callq _bar
; CHECK-NEXT:  Ltmp16:
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    retq
entry:
  %statepoint_token1 = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @bar, i32 0, i32 0, i64 0, i64 0) ["deopt" (i32* @G, i32* @G, i32* @G)]
  ret void
}

define void @addr_alloca(i32 %v) gc "statepoint-example" {
; CHECK-LABEL: addr_alloca:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    movl %edi, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    callq _bar
; CHECK-NEXT:  Ltmp17:
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
entry:
  %a = alloca i32
  store i32 %v, i32* %a
  %statepoint_token1 = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @bar, i32 0, i32 0, i64 0, i64 0) ["deopt" (i32* %a, i32* %a, i32* %a)]
  ret void
}

define i32 addrspace(1)*  @test_fpconst_deopt(i32 addrspace(1)* %in) gc "statepoint-example" {
; CHECK-LABEL: test_fpconst_deopt:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    movq %rdi, (%rsp)
; CHECK-NEXT:    nopl 8(%rax,%rax)
; CHECK-NEXT:  Ltmp18:
; CHECK-NEXT:    movq (%rsp), %rax
; CHECK-NEXT:    popq %rcx
; CHECK-NEXT:    retq
    %statepoint_token = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2, i32 5, void ()* nonnull @bar, i32 0, i32 0, i32 0, i32 0) ["gc-live" (i32 addrspace(1)* %in), "deopt" (
    float 0x40421A1CA0000000, float 0x40459A1CA0000000, float 0x40401A1CA0000000, float 0x40479A1CA0000000, float 0x403C343940000000,
    float 0x403E343940000000, float 0x40469A1CA0000000, float 0x40489A1CA0000000, float 0x404A9A1CA0000000, float 0x40499A1CA0000000,
    float 0xC05FCD2F20000000, float 0xC05C0D2F20000000, float 0xC060269780000000, float 0xC05B8D2F20000000, float 0xC060669780000000,
    float 0xC05B0D2F20000000, float 0xC060A69780000000, float 0xC05A8D2F20000000, float 0xC060E69780000000, float 0x40439A1CA0000000)]
    %out = call coldcc i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token %statepoint_token, i32 0, i32 0)
    ret i32 addrspace(1)* %out
}

; CHECK-LABEL: __LLVM_StackMaps:
; CHECK: .long   Ltmp18-_test_fpconst_deopt
; CHECK-NEXT: .short	0
; CHECK-NEXT: .short	25
; CHECK-NEXT: .byte	4
; CHECK-NEXT: .byte	0
; CHECK-NEXT: .short	8
; CHECK-NEXT: .short	0
; CHECK-NEXT: .short	0
; CHECK-NEXT: .long	0
; CHECK-NEXT: .byte	4
; CHECK-NEXT: .byte	0
; CHECK-NEXT: .short	8
; CHECK-NEXT: .short	0
; CHECK-NEXT: .short	0
; CHECK-NEXT: .long	0
; CHECK-NEXT: .byte	4
; CHECK-NEXT: .byte	0
; CHECK-NEXT: .short	8
; CHECK-NEXT: .short	0
; CHECK-NEXT: .short	0
; CHECK-NEXT: .long	20
; CHECK: .byte	4
; CHECK: .byte	0
; CHECK: .short	8
; CHECK: .short	0
; CHECK: .short	0
; CHECK: .long	1108398309
; CHECK: .byte	4
; CHECK: .byte	0
; CHECK: .short	8
; CHECK: .short	0
; CHECK: .short	0
; CHECK: .long	1110233317
; CHECK: .byte	4
; CHECK: .byte	0
; CHECK: .short	8
; CHECK: .short	0
; CHECK: .short	0
; CHECK: .long	1107349733
; CHECK: .byte	4
; CHECK: .byte	0
; CHECK: .short	8
; CHECK: .short	0
; CHECK: .short	0
; CHECK: .long	1111281893
; CHECK: .byte	4
; CHECK: .byte	0
; CHECK: .short	8
; CHECK: .short	0
; CHECK: .short	0
; CHECK: .long	1105306058
; CHECK: .byte	4
; CHECK: .byte	0
; CHECK: .short	8
; CHECK: .short	0
; CHECK: .short	0
; CHECK: .long	1106354634
; CHECK: .byte	4
; CHECK: .byte	0
; CHECK: .short	8
; CHECK: .short	0
; CHECK: .short	0
; CHECK: .long	1110757605
; CHECK: .byte	4
; CHECK: .byte	0
; CHECK: .short	8
; CHECK: .short	0
; CHECK: .short	0
; CHECK: .long	1111806181
; CHECK: .byte	4
; CHECK: .byte	0
; CHECK: .short	8
; CHECK: .short	0
; CHECK: .short	0
; CHECK: .long	1112854757
; CHECK: .byte	4
; CHECK: .byte	0
; CHECK: .short	8
; CHECK: .short	0
; CHECK: .short	0
; CHECK: .long	1112330469
; CHECK: .byte	5
; CHECK: .byte	0
; CHECK: .short	8
; CHECK: .short	0
; CHECK: .short	0
; CHECK: .long	0
; CHECK: .byte	5
; CHECK: .byte	0
; CHECK: .short	8
; CHECK: .short	0
; CHECK: .short	0
; CHECK: .long	1
; CHECK: .byte	5
; CHECK: .byte	0
; CHECK: .short	8
; CHECK: .short	0
; CHECK: .short	0
; CHECK: .long	2
; CHECK: .byte	5
; CHECK: .byte	0
; CHECK: .short	8
; CHECK: .short	0
; CHECK: .short	0
; CHECK: .long	3
; CHECK: .byte	5
; CHECK: .byte	0
; CHECK: .short	8
; CHECK: .short	0
; CHECK: .short	0
; CHECK: .long	4
; CHECK: .byte	5
; CHECK: .byte	0
; CHECK: .short	8
; CHECK: .short	0
; CHECK: .short	0
; CHECK: .long	5
; CHECK: .byte	5
; CHECK: .byte	0
; CHECK: .short	8
; CHECK: .short	0
; CHECK: .short	0
; CHECK: .long	6
; CHECK: .byte	5
; CHECK: .byte	0
; CHECK: .short	8
; CHECK: .short	0
; CHECK: .short	0
; CHECK: .long	7
; CHECK: .byte	5
; CHECK: .byte	0
; CHECK: .short	8
; CHECK: .short	0
; CHECK: .short	0
; CHECK: .long	8
; CHECK: .byte	4
; CHECK: .byte	0
; CHECK: .short	8
; CHECK: .short	0
; CHECK: .short	0
; CHECK: .long	1109184741

declare token @llvm.experimental.gc.statepoint.p0f_isVoidf(i64, i32, void ()*, i32, i32, ...)
declare i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token, i32, i32)

attributes #0 = { "deopt-lowering"="live-in" }
attributes #1 = { "deopt-lowering"="live-through" }
