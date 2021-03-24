; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv6m-eabi -verify-machineinstrs < %s | FileCheck --check-prefix=T1 %s
; RUN: llc -mtriple=thumbv7m-eabi -verify-machineinstrs < %s | FileCheck --check-prefix=T2 %s

define i32 @addri1(i32 %a, i32 %b) {
; T1-LABEL: addri1:
; T1:       @ %bb.0: @ %entry
; T1-NEXT:    adds r0, r0, #3
; T1-NEXT:    beq .LBB0_2
; T1-NEXT:  @ %bb.1: @ %false
; T1-NEXT:    movs r0, #5
; T1-NEXT:    bx lr
; T1-NEXT:  .LBB0_2: @ %true
; T1-NEXT:    movs r0, #4
; T1-NEXT:    bx lr
;
; T2-LABEL: addri1:
; T2:       @ %bb.0: @ %entry
; T2-NEXT:    adds r0, #3
; T2-NEXT:    mov.w r0, #5
; T2-NEXT:    it eq
; T2-NEXT:    moveq r0, #4
; T2-NEXT:    bx lr
entry:
  %c = add i32 %a, 3
  %d = icmp eq i32 %c, 0
  br i1 %d, label %true, label %false

true:
  ret i32 4

false:
  ret i32 5
}

define i32 @addri2(i32 %a, i32 %b) {
; T1-LABEL: addri2:
; T1:       @ %bb.0: @ %entry
; T1-NEXT:    adds r0, #254
; T1-NEXT:    beq .LBB1_2
; T1-NEXT:  @ %bb.1: @ %false
; T1-NEXT:    movs r0, #5
; T1-NEXT:    bx lr
; T1-NEXT:  .LBB1_2: @ %true
; T1-NEXT:    movs r0, #4
; T1-NEXT:    bx lr
;
; T2-LABEL: addri2:
; T2:       @ %bb.0: @ %entry
; T2-NEXT:    adds r0, #254
; T2-NEXT:    mov.w r0, #5
; T2-NEXT:    it eq
; T2-NEXT:    moveq r0, #4
; T2-NEXT:    bx lr
entry:
  %c = add i32 %a, 254
  %d = icmp eq i32 %c, 0
  br i1 %d, label %true, label %false

true:
  ret i32 4

false:
  ret i32 5
}
