; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; Test strict conversion of floating-point values to unsigned i32s (z10 only).
;
; RUN: llc < %s -mtriple=s390x-linux-gnu -mcpu=z10 | FileCheck %s

; z10 doesn't have native support for unsigned fp-to-i32 conversions;
; they were added in z196 as the Convert to Logical family of instructions.
; Promoting to i64 doesn't generate an inexact condition for values that are
; outside the i32 range but in the i64 range, so use the default expansion.
; Note that the strict expansion sequence must be used.

declare i32 @llvm.experimental.constrained.fptoui.i32.f32(float, metadata)
declare i32 @llvm.experimental.constrained.fptoui.i32.f64(double, metadata)
declare i32 @llvm.experimental.constrained.fptoui.i32.f128(fp128, metadata)

; Test f32->i32.
define i32 @f1(float %f) #0 {
; CHECK-LABEL: f1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    larl %r1, .LCPI0_0
; CHECK-NEXT:    le %f1, 0(%r1)
; CHECK-NEXT:    cebr %f0, %f1
; CHECK-NEXT:    jnl .LBB0_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    lhi %r0, 0
; CHECK-NEXT:    lzer %f1
; CHECK-NEXT:    j .LBB0_3
; CHECK-NEXT:  .LBB0_2:
; CHECK-NEXT:    llilh %r0, 32768
; CHECK-NEXT:  .LBB0_3:
; CHECK-NEXT:    sebr %f0, %f1
; CHECK-NEXT:    cfebr %r2, 5, %f0
; CHECK-NEXT:    xr %r2, %r0
; CHECK-NEXT:    br %r14
  %conv = call i32 @llvm.experimental.constrained.fptoui.i32.f32(float %f,
                                               metadata !"fpexcept.strict") #0
  ret i32 %conv
}

; Test f64->i32.
define i32 @f2(double %f) #0 {
; CHECK-LABEL: f2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    larl %r1, .LCPI1_0
; CHECK-NEXT:    ldeb %f1, 0(%r1)
; CHECK-NEXT:    cdbr %f0, %f1
; CHECK-NEXT:    jnl .LBB1_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    lhi %r0, 0
; CHECK-NEXT:    lzdr %f1
; CHECK-NEXT:    j .LBB1_3
; CHECK-NEXT:  .LBB1_2:
; CHECK-NEXT:    llilh %r0, 32768
; CHECK-NEXT:  .LBB1_3:
; CHECK-NEXT:    sdbr %f0, %f1
; CHECK-NEXT:    cfdbr %r2, 5, %f0
; CHECK-NEXT:    xr %r2, %r0
; CHECK-NEXT:    br %r14
  %conv = call i32 @llvm.experimental.constrained.fptoui.i32.f64(double %f,
                                               metadata !"fpexcept.strict") #0
  ret i32 %conv
}

; Test f128->i32.
define i32 @f3(fp128 *%src) #0 {
; CHECK-LABEL: f3:
; CHECK:       # %bb.0:
; CHECK-NEXT:    ld %f0, 0(%r2)
; CHECK-NEXT:    ld %f2, 8(%r2)
; CHECK-NEXT:    larl %r1, .LCPI2_0
; CHECK-NEXT:    lxeb %f1, 0(%r1)
; CHECK-NEXT:    cxbr %f0, %f1
; CHECK-NEXT:    jnl .LBB2_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    lhi %r0, 0
; CHECK-NEXT:    lzxr %f1
; CHECK-NEXT:    j .LBB2_3
; CHECK-NEXT:  .LBB2_2:
; CHECK-NEXT:    llilh %r0, 32768
; CHECK-NEXT:  .LBB2_3:
; CHECK-NEXT:    sxbr %f0, %f1
; CHECK-NEXT:    cfxbr %r2, 5, %f0
; CHECK-NEXT:    xr %r2, %r0
; CHECK-NEXT:    br %r14
  %f = load fp128, fp128 *%src
  %conv = call i32 @llvm.experimental.constrained.fptoui.i32.f128(fp128 %f,
                                               metadata !"fpexcept.strict") #0
  ret i32 %conv
}

attributes #0 = { strictfp }
