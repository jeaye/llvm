; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -march=hexagon -O2 < %s | FileCheck %s

define i32 @f0(i32 %a0, i32 %a1) #0 {
; CHECK-LABEL: f0:
; CHECK:         .cfi_startproc
; CHECK-NEXT:  // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     p0 = cmp.gt(r1,r0)
; CHECK-NEXT:     if (p0.new) r0 = #0
; CHECK-NEXT:     if (p0.new) jumpr:nt r31
; CHECK-NEXT:    }
; CHECK-NEXT:  .LBB0_1: // %b2
; CHECK-NEXT:    {
; CHECK-NEXT:     p0 = cmp.gt(r1,#99)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = mux(p0,##321,#123)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = icmp slt i32 %a0, %a1
  br i1 %v0, label %b1, label %b2

b1:
  ret i32 0

b2:
  %v1 = icmp slt i32 %a1, 100
  %v2 = select i1 %v1, i32 123, i32 321
  ret i32 %v2
}
