; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -show-mc-encoding < %s | FileCheck %s

target datalayout = "e-m:e-p:32:32-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnux32"

%struct.a = type { [65 x i32] }

@c = global %struct.a zeroinitializer, align 4

define void @e() nounwind {
; CHECK-LABEL: e:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rbx # encoding: [0x53]
; CHECK-NEXT:    subl $528, %esp # encoding: [0x81,0xec,0x10,0x02,0x00,0x00]
; CHECK-NEXT:    # imm = 0x210
; CHECK-NEXT:    leal {{[0-9]+}}(%rsp), %ebx # encoding: [0x8d,0x9c,0x24,0x08,0x01,0x00,0x00]
; CHECK-NEXT:    movq %rbx, %rdi # encoding: [0x48,0x89,0xdf]
; CHECK-NEXT:    movl $c, %esi # encoding: [0xbe,A,A,A,A]
; CHECK-NEXT:    # fixup A - offset: 1, value: c, kind: FK_Data_4
; CHECK-NEXT:    movl $260, %edx # encoding: [0xba,0x04,0x01,0x00,0x00]
; CHECK-NEXT:    # imm = 0x104
; CHECK-NEXT:    callq memcpy # encoding: [0xe8,A,A,A,A]
; CHECK-NEXT:    # fixup A - offset: 1, value: memcpy-4, kind: FK_PCRel_4
; CHECK-NEXT:    movl $32, %ecx # encoding: [0xb9,0x20,0x00,0x00,0x00]
; CHECK-NEXT:    movl %esp, %edi # encoding: [0x89,0xe7]
; CHECK-NEXT:    movl %ebx, %esi # encoding: [0x89,0xde]
; CHECK-NEXT:    rep;movsq (%esi), %es:(%edi) # encoding: [0xf3,0x67,0x48,0xa5]
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x67,0x8b,0x84,0x24,0x08,0x02,0x00,0x00]
; CHECK-NEXT:    movl %eax, {{[0-9]+}}(%esp) # encoding: [0x67,0x89,0x84,0x24,0x00,0x01,0x00,0x00]
; CHECK-NEXT:    callq d # encoding: [0xe8,A,A,A,A]
; CHECK-NEXT:    # fixup A - offset: 1, value: d-4, kind: FK_PCRel_4
; CHECK-NEXT:    addl $528, %esp # encoding: [0x81,0xc4,0x10,0x02,0x00,0x00]
; CHECK-NEXT:    # imm = 0x210
; CHECK-NEXT:    popq %rbx # encoding: [0x5b]
; CHECK-NEXT:    retq # encoding: [0xc3]
entry:
  %byval-temp = alloca %struct.a, align 8
  %0 = bitcast %struct.a* %byval-temp to i8*
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* nonnull align 8 %0, i8* align 4 bitcast (%struct.a* @c to i8*), i32 260, i1 false)
  call void @d(%struct.a* byval(%struct.a) nonnull align 8 %byval-temp)
  ret void
}

declare void @d(%struct.a* byval(%struct.a) align 8) local_unnamed_addr #1

declare void @llvm.memcpy.p0i8.p0i8.i32(i8* nocapture writeonly, i8* nocapture readonly, i32, i1)
