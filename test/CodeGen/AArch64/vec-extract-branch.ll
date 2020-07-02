; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64-none-linux-gnu -verify-machineinstrs | FileCheck %s

define i32 @vec_extract_branch(<2 x double> %x, i32 %y)  {
; CHECK-LABEL: vec_extract_branch:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fcmgt v0.2d, v0.2d, #0.0
; CHECK-NEXT:    xtn v0.2s, v0.2d
; CHECK-NEXT:    mov w8, v0.s[1]
; CHECK-NEXT:    fmov w9, s0
; CHECK-NEXT:    and w8, w9, w8
; CHECK-NEXT:    tbz w8, #0, .LBB0_2
; CHECK-NEXT:  // %bb.1: // %true
; CHECK-NEXT:    mov w8, #42
; CHECK-NEXT:    sdiv w0, w8, w0
; CHECK-NEXT:    ret
; CHECK-NEXT:  .LBB0_2: // %false
; CHECK-NEXT:    mov w0, #88
; CHECK-NEXT:    ret
  %t1 = fcmp ogt <2 x double> %x, zeroinitializer
  %t2 = extractelement <2 x i1> %t1, i32 0
  %t3 = extractelement <2 x i1> %t1, i32 1
  %t4 = and i1 %t2, %t3
  br i1 %t4, label %true, label %false
true:
  %y1 = sdiv i32 42, %y
  ret i32 %y1
false:
  ret i32 88
}
