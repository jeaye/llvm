; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs < %s | FileCheck %s
; This file contains a collection of basic tests to ensure we didn't
; screw up normal call lowering when there are no deopt or gc arguments.

target datalayout = "e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct = type { i64, i64 }

declare zeroext i1 @return_i1()
declare zeroext i32 @return_i32()
declare i32* @return_i32ptr()
declare float @return_float()
declare %struct @return_struct()
declare void @varargf(i32, ...)

define i1 @test_i1_return() gc "statepoint-example" {
; CHECK-LABEL: test_i1_return:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq return_i1@PLT
; CHECK-NEXT:  .Ltmp0:
; CHECK-NEXT:    popq %rcx
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    retq
; This is just checking that a i1 gets lowered normally when there's no extra
; state arguments to the statepoint
entry:
  %safepoint_token = tail call token (i64, i32, i1 ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_i1f(i64 0, i32 0, i1 ()* @return_i1, i32 0, i32 0, i32 0, i32 0)
  %call1 = call zeroext i1 @llvm.experimental.gc.result.i1(token %safepoint_token)
  ret i1 %call1
}

define i32 @test_i32_return() gc "statepoint-example" {
; CHECK-LABEL: test_i32_return:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq return_i32@PLT
; CHECK-NEXT:  .Ltmp1:
; CHECK-NEXT:    popq %rcx
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    retq
entry:
  %safepoint_token = tail call token (i64, i32, i32 ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_i32f(i64 0, i32 0, i32 ()* @return_i32, i32 0, i32 0, i32 0, i32 0)
  %call1 = call zeroext i32 @llvm.experimental.gc.result.i32(token %safepoint_token)
  ret i32 %call1
}

define i32* @test_i32ptr_return() gc "statepoint-example" {
; CHECK-LABEL: test_i32ptr_return:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq return_i32ptr@PLT
; CHECK-NEXT:  .Ltmp2:
; CHECK-NEXT:    popq %rcx
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    retq
entry:
  %safepoint_token = tail call token (i64, i32, i32* ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_p0i32f(i64 0, i32 0, i32* ()* @return_i32ptr, i32 0, i32 0, i32 0, i32 0)
  %call1 = call i32* @llvm.experimental.gc.result.p0i32(token %safepoint_token)
  ret i32* %call1
}

define float @test_float_return() gc "statepoint-example" {
; CHECK-LABEL: test_float_return:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq return_float@PLT
; CHECK-NEXT:  .Ltmp3:
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    retq
entry:
  %safepoint_token = tail call token (i64, i32, float ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_f32f(i64 0, i32 0, float ()* @return_float, i32 0, i32 0, i32 0, i32 0)
  %call1 = call float @llvm.experimental.gc.result.f32(token %safepoint_token)
  ret float %call1
}

define %struct @test_struct_return() gc "statepoint-example" {
; CHECK-LABEL: test_struct_return:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq return_struct@PLT
; CHECK-NEXT:  .Ltmp4:
; CHECK-NEXT:    popq %rcx
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    retq
entry:
  %safepoint_token = tail call token (i64, i32, %struct ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_structf(i64 0, i32 0, %struct ()* @return_struct, i32 0, i32 0, i32 0, i32 0)
  %call1 = call %struct @llvm.experimental.gc.result.struct(token %safepoint_token)
  ret %struct %call1
}

define i1 @test_relocate(i32 addrspace(1)* %a) gc "statepoint-example" {
; CHECK-LABEL: test_relocate:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    movq %rdi, (%rsp)
; CHECK-NEXT:    callq return_i1@PLT
; CHECK-NEXT:  .Ltmp5:
; CHECK-NEXT:    popq %rcx
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    retq
; Check that an ununsed relocate has no code-generation impact
entry:
  %safepoint_token = tail call token (i64, i32, i1 ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_i1f(i64 0, i32 0, i1 ()* @return_i1, i32 0, i32 0, i32 0, i32 0) ["gc-live" (i32 addrspace(1)* %a)]
  %call1 = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token %safepoint_token,  i32 0, i32 0)
  %call2 = call zeroext i1 @llvm.experimental.gc.result.i1(token %safepoint_token)
  ret i1 %call2
}

define void @test_void_vararg() gc "statepoint-example" {
; CHECK-LABEL: test_void_vararg:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    movl $42, %edi
; CHECK-NEXT:    movl $43, %esi
; CHECK-NEXT:    callq varargf@PLT
; CHECK-NEXT:  .Ltmp6:
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    retq
; Check a statepoint wrapping a *void* returning vararg function works
entry:
  %safepoint_token = tail call token (i64, i32, void (i32, ...)*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidi32varargf(i64 0, i32 0, void (i32, ...)* @varargf, i32 2, i32 0, i32 42, i32 43, i32 0, i32 0)
  ;; if we try to use the result from a statepoint wrapping a
  ;; non-void-returning varargf, we will experience a crash.
  ret void
}

define i1 @test_i1_return_patchable() gc "statepoint-example" {
; CHECK-LABEL: test_i1_return_patchable:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    nopl (%rax)
; CHECK-NEXT:  .Ltmp7:
; CHECK-NEXT:    popq %rcx
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    retq
; A patchable variant of test_i1_return
entry:
  %safepoint_token = tail call token (i64, i32, i1 ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_i1f(i64 0, i32 3, i1 ()*null, i32 0, i32 0, i32 0, i32 0)
  %call1 = call zeroext i1 @llvm.experimental.gc.result.i1(token %safepoint_token)
  ret i1 %call1
}

declare void @consume(i32 addrspace(1)* %obj)

define i1 @test_cross_bb(i32 addrspace(1)* %a, i1 %external_cond) gc "statepoint-example" {
; CHECK-LABEL: test_cross_bb:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rbp
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 24
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    .cfi_offset %rbx, -24
; CHECK-NEXT:    .cfi_offset %rbp, -16
; CHECK-NEXT:    movl %esi, %ebp
; CHECK-NEXT:    movq %rdi, (%rsp)
; CHECK-NEXT:    callq return_i1@PLT
; CHECK-NEXT:  .Ltmp8:
; CHECK-NEXT:    testb $1, %bpl
; CHECK-NEXT:    je .LBB8_2
; CHECK-NEXT:  # %bb.1: # %left
; CHECK-NEXT:    movl %eax, %ebx
; CHECK-NEXT:    movq (%rsp), %rdi
; CHECK-NEXT:    callq consume@PLT
; CHECK-NEXT:    movl %ebx, %eax
; CHECK-NEXT:    jmp .LBB8_3
; CHECK-NEXT:  .LBB8_2: # %right
; CHECK-NEXT:    movb $1, %al
; CHECK-NEXT:  .LBB8_3: # %right
; CHECK-NEXT:    addq $8, %rsp
; CHECK-NEXT:    .cfi_def_cfa_offset 24
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    popq %rbp
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    retq
entry:
  %safepoint_token = tail call token (i64, i32, i1 ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_i1f(i64 0, i32 0, i1 ()* @return_i1, i32 0, i32 0, i32 0, i32 0) ["gc-live" (i32 addrspace(1)* %a)]
  br i1 %external_cond, label %left, label %right

left:
  %call1 = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token %safepoint_token,  i32 0, i32 0)
  %call2 = call zeroext i1 @llvm.experimental.gc.result.i1(token %safepoint_token)
  call void @consume(i32 addrspace(1)* %call1)
  ret i1 %call2

right:
  ret i1 true
}

%struct2 = type { i64, i64, i64 }

declare void @consume_attributes(i32, i8* nest, i32, %struct2* byval(%struct2))

define void @test_attributes(%struct2* byval(%struct2) %s) gc "statepoint-example" {
; CHECK-LABEL: test_attributes:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    subq $8, %rsp
; CHECK-NEXT:    .cfi_adjust_cfa_offset 8
; CHECK-NEXT:    movq {{[0-9]+}}(%rsp), %rax
; CHECK-NEXT:    movq {{[0-9]+}}(%rsp), %rcx
; CHECK-NEXT:    movq {{[0-9]+}}(%rsp), %rdx
; CHECK-NEXT:    movl $42, %edi
; CHECK-NEXT:    xorl %r10d, %r10d
; CHECK-NEXT:    movl $17, %esi
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_adjust_cfa_offset 8
; CHECK-NEXT:    pushq %rdx
; CHECK-NEXT:    .cfi_adjust_cfa_offset 8
; CHECK-NEXT:    pushq %rcx
; CHECK-NEXT:    .cfi_adjust_cfa_offset 8
; CHECK-NEXT:    callq consume_attributes@PLT
; CHECK-NEXT:  .Ltmp9:
; CHECK-NEXT:    addq $32, %rsp
; CHECK-NEXT:    .cfi_adjust_cfa_offset -32
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    retq
entry:
; Check that arguments with attributes are lowered correctly.
; We call a function that has a nest argument and a byval argument.
  %statepoint_token = call token (i64, i32, void (i32, i8*, i32, %struct2*)*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidi32p0i8i32p0s_struct2sf(i64 0, i32 0, void (i32, i8*, i32, %struct2*)* @consume_attributes, i32 4, i32 0, i32 42, i8* nest null, i32 17, %struct2* byval(%struct2) %s, i32 0, i32 0)
  ret void
}

declare token @llvm.experimental.gc.statepoint.p0f_i1f(i64, i32, i1 ()*, i32, i32, ...)
declare i1 @llvm.experimental.gc.result.i1(token)

declare token @llvm.experimental.gc.statepoint.p0f_i32f(i64, i32, i32 ()*, i32, i32, ...)
declare i32 @llvm.experimental.gc.result.i32(token)

declare token @llvm.experimental.gc.statepoint.p0f_p0i32f(i64, i32, i32* ()*, i32, i32, ...)
declare i32* @llvm.experimental.gc.result.p0i32(token)

declare token @llvm.experimental.gc.statepoint.p0f_f32f(i64, i32, float ()*, i32, i32, ...)
declare float @llvm.experimental.gc.result.f32(token)

declare token @llvm.experimental.gc.statepoint.p0f_structf(i64, i32, %struct ()*, i32, i32, ...)
declare %struct @llvm.experimental.gc.result.struct(token)

declare token @llvm.experimental.gc.statepoint.p0f_isVoidi32varargf(i64, i32, void (i32, ...)*, i32, i32, ...)

declare token @llvm.experimental.gc.statepoint.p0f_isVoidi32p0i8i32p0s_struct2sf(i64, i32, void (i32, i8*, i32, %struct2*)*, i32, i32, ...)

declare i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token, i32, i32)
