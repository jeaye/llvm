; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64-- | FileCheck %s

define <4 x i32> @sextbool_add_vector(<4 x i32> %c1, <4 x i32> %c2, <4 x i32> %x) {
; CHECK-LABEL: sextbool_add_vector:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmeq v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    add v0.4s, v2.4s, v0.4s
; CHECK-NEXT:    ret
  %c = icmp eq <4 x i32> %c1, %c2
  %b = sext <4 x i1> %c to <4 x i32>
  %s = add <4 x i32> %x, %b
  ret <4 x i32> %s
}

define <4 x i32> @zextbool_sub_vector(<4 x i32> %c1, <4 x i32> %c2, <4 x i32> %x) {
; CHECK-LABEL: zextbool_sub_vector:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmeq v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    add v0.4s, v2.4s, v0.4s
; CHECK-NEXT:    ret
  %c = icmp eq <4 x i32> %c1, %c2
  %b = zext <4 x i1> %c to <4 x i32>
  %s = sub <4 x i32> %x, %b
  ret <4 x i32> %s
}

define i32 @assertsext_sub_1(i1 signext %cond, i32 %y) {
; CHECK-LABEL: assertsext_sub_1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    add w0, w1, w0
; CHECK-NEXT:    ret
  %e = zext i1 %cond to i32
  %r = sub i32 %y, %e
  ret i32 %r
}

define i32 @assertsext_add_1(i1 signext %cond, i32 %y) {
; CHECK-LABEL: assertsext_add_1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub w0, w1, w0
; CHECK-NEXT:    ret
  %e = zext i1 %cond to i32
  %r = add i32 %e, %y
  ret i32 %r
}

define i32 @assertsext_add_1_commute(i1 signext %cond, i32 %y) {
; CHECK-LABEL: assertsext_add_1_commute:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub w0, w1, w0
; CHECK-NEXT:    ret
  %e = zext i1 %cond to i32
  %r = add i32 %y, %e
  ret i32 %r
}

