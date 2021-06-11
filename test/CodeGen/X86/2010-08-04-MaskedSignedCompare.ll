; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown | FileCheck %s
; PR7814

@g_16 = dso_local global i64 -3738643449681751625, align 8
@g_38 = dso_local global i32 0, align 4
@.str = private constant [4 x i8] c"%d\0A\00"

define dso_local i32 @main() nounwind {
; CHECK-LABEL: main:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    cmpq g_16(%rip), %rax
; CHECK-NEXT:    sbbl %eax, %eax
; CHECK-NEXT:    testb $-106, %al
; CHECK-NEXT:    jle .LBB0_1
; CHECK-NEXT:  # %bb.2: # %if.then
; CHECK-NEXT:    movl $1, g_38(%rip)
; CHECK-NEXT:    movl $1, %esi
; CHECK-NEXT:    jmp .LBB0_3
; CHECK-NEXT:  .LBB0_1: # %entry.if.end_crit_edge
; CHECK-NEXT:    movl g_38(%rip), %esi
; CHECK-NEXT:  .LBB0_3: # %if.end
; CHECK-NEXT:    movl $.L.str, %edi
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    callq printf@PLT
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    popq %rcx
; CHECK-NEXT:    retq
entry:
  %tmp = load i64, i64* @g_16
  %not.lnot = icmp ne i64 %tmp, 0
  %conv = sext i1 %not.lnot to i64
  %and = and i64 %conv, 150
  %conv.i = trunc i64 %and to i8
  %cmp = icmp sgt i8 %conv.i, 0
  br i1 %cmp, label %if.then, label %entry.if.end_crit_edge

entry.if.end_crit_edge:
  %tmp4.pre = load i32, i32* @g_38
  br label %if.end

if.then:
  store i32 1, i32* @g_38
  br label %if.end

if.end:
  %tmp4 = phi i32 [ %tmp4.pre, %entry.if.end_crit_edge ], [ 1, %if.then ] ; <i32> [#uses=1]
  %call5 = tail call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 %tmp4) nounwind ; <i32> [#uses=0]
  ret i32 0
}

declare i32 @printf(i8* nocapture, ...) nounwind

