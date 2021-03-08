; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=m68k-pc-linux -relocation-model=pic -verify-machineinstrs | FileCheck %s

;
; Pass all arguments on the stack in reverse order

define i32 @test1() nounwind {
; CHECK-LABEL: test1:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    sub.l #20, %sp
; CHECK-NEXT:    move.l #5, (16,%sp)
; CHECK-NEXT:    move.l #4, (12,%sp)
; CHECK-NEXT:    move.l #3, (8,%sp)
; CHECK-NEXT:    move.l #2, (4,%sp)
; CHECK-NEXT:    move.l #1, (%sp)
; CHECK-NEXT:    jsr (test1_callee@PLT,%pc)
; CHECK-NEXT:    move.l #0, %d0
; CHECK-NEXT:    add.l #20, %sp
; CHECK-NEXT:    rts
entry:
  call void @test1_callee(i32 1, i32 2, i32 3, i32 4, i32 5) nounwind
  ret i32 0
}

declare void @test1_callee(i32 %a, i32 %b, i32 %c, i32 %d, i32 %e);

define i16 @test2() nounwind {
; CHECK-LABEL: test2:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    sub.l #20, %sp
; CHECK-NEXT:    move.l #5, (16,%sp)
; CHECK-NEXT:    move.l #4, (12,%sp)
; CHECK-NEXT:    move.l #3, (8,%sp)
; CHECK-NEXT:    move.l #2, (4,%sp)
; CHECK-NEXT:    move.l #1, (%sp)
; CHECK-NEXT:    jsr (test2_callee@PLT,%pc)
; CHECK-NEXT:    move.w #0, %d0
; CHECK-NEXT:    add.l #20, %sp
; CHECK-NEXT:    rts
entry:
  call void @test2_callee(i16 1, i16 2, i16 3, i16 4, i16 5) nounwind
  ret i16 0
}

declare void @test2_callee(i16 %a, i16 %b, i16 %c, i16 %d, i16 %e);

define i8 @test3() nounwind {
; CHECK-LABEL: test3:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    sub.l #20, %sp
; CHECK-NEXT:    move.l #5, (16,%sp)
; CHECK-NEXT:    move.l #4, (12,%sp)
; CHECK-NEXT:    move.l #3, (8,%sp)
; CHECK-NEXT:    move.l #2, (4,%sp)
; CHECK-NEXT:    move.l #1, (%sp)
; CHECK-NEXT:    jsr (test3_callee@PLT,%pc)
; CHECK-NEXT:    move.b #0, %d0
; CHECK-NEXT:    add.l #20, %sp
; CHECK-NEXT:    rts
entry:
  call void @test3_callee(i8 1, i8 2, i8 3, i8 4, i8 5) nounwind
  ret i8 0
}

declare void @test3_callee(i8 %a, i8 %b, i8 %c, i8 %d, i8 %e);
