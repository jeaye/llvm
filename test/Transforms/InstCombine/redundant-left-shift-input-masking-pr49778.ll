; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

; PR49778: this should not be folded to 0.
define i32 @src(i1 %x2) {
; CHECK-LABEL: @src(
; CHECK-NEXT:    ret i32 0
;
  %x13 = zext i1 %x2 to i32
  %_7 = shl i32 4294967295, %x13
  %mask = xor i32 %_7, 4294967295
  %_8 = and i32 %mask, %x13
  %_9 = shl i32 %_8, %x13
  ret i32 %_9
}
