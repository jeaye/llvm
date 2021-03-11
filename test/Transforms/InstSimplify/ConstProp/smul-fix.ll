; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instsimplify -S | FileCheck %s

;-----------------------------------------------------------------------------
; Simple test using scalar layout.
;-----------------------------------------------------------------------------

declare i32 @llvm.smul.fix.i32(i32, i32, i32)

define i32 @test_smul_fix_i32_0() {
; CHECK-LABEL: @test_smul_fix_i32_0(
; CHECK-NEXT:    ret i32 536870912
;
  %r = call i32 @llvm.smul.fix.i32(i32 1073741824, i32 1073741824, i32 31) ; 0.5 * 0.5
  ret i32 %r
}

define i32 @test_smul_fix_i32_undef_x() {
; CHECK-LABEL: @test_smul_fix_i32_undef_x(
; CHECK-NEXT:    ret i32 0
;
  %r = call i32 @llvm.smul.fix.i32(i32 undef, i32 1073741824, i32 31) ; undef * 0.5
  ret i32 %r
}

define i32 @test_smul_fix_i32_x_undef() {
; CHECK-LABEL: @test_smul_fix_i32_x_undef(
; CHECK-NEXT:    ret i32 0
;
  %r = call i32 @llvm.smul.fix.i32(i32 1073741824, i32 undef, i32 31)
  ret i32 %r
}


;-----------------------------------------------------------------------------
; More extensive tests based on vectors (basically using the scalar fold
; for each index).
;-----------------------------------------------------------------------------

declare <8 x i3> @llvm.smul.fix.v8i3(<8 x i3>, <8 x i3>, i32)

define <8 x i3> @test_smul_fix_v8i3_0() {
; CHECK-LABEL: @test_smul_fix_v8i3_0(
; CHECK-NEXT:    ret <8 x i3> <i3 0, i3 -4, i3 0, i3 -4, i3 0, i3 -4, i3 0, i3 -4>
;
  %r = call <8 x i3> @llvm.smul.fix.v8i3(
  <8 x i3> <i3 -4, i3 -3, i3 -2, i3 -1, i3 0, i3 1, i3 2, i3 3>,
  <8 x i3> <i3 -4, i3 -4, i3 -4, i3 -4, i3 -4, i3 -4, i3 -4, i3 -4>,
  i32 0)
  ret <8 x i3> %r
}

define <8 x i3> @test_smul_fix_v8i3_1() {
; CHECK-LABEL: @test_smul_fix_v8i3_1(
; CHECK-NEXT:    ret <8 x i3> <i3 0, i3 -2, i3 -4, i3 2, i3 0, i3 -2, i3 -4, i3 2>
;
  %r = call <8 x i3> @llvm.smul.fix.v8i3(
  <8 x i3> <i3 -4, i3 -3, i3 -2, i3 -1, i3 0, i3 1, i3 2, i3 3>,
  <8 x i3> <i3 -4, i3 -4, i3 -4, i3 -4, i3 -4, i3 -4, i3 -4, i3 -4>,
  i32 1)
  ret <8 x i3> %r
}

define <8 x i3> @test_smul_fix_v8i3_2() {
; CHECK-LABEL: @test_smul_fix_v8i3_2(
; CHECK-NEXT:    ret <8 x i3> <i3 -4, i3 3, i3 2, i3 1, i3 0, i3 -1, i3 -2, i3 -3>
;
  %r = call <8 x i3> @llvm.smul.fix.v8i3(
  <8 x i3> <i3 -4, i3 -3, i3 -2, i3 -1, i3 0, i3 1, i3 2, i3 3>,
  <8 x i3> <i3 -4, i3 -4, i3 -4, i3 -4, i3 -4, i3 -4, i3 -4, i3 -4>,
  i32 2)
  ret <8 x i3> %r
}

define <8 x i3> @test_smul_fix_v8i3_3() {
; CHECK-LABEL: @test_smul_fix_v8i3_3(
; CHECK-NEXT:    ret <8 x i3> <i3 -4, i3 3, i3 2, i3 1, i3 0, i3 -1, i3 -2, i3 -3>
;
  %r = call <8 x i3> @llvm.smul.fix.v8i3(
  <8 x i3> <i3 -4, i3 -3, i3 -2, i3 -1, i3 0, i3 1, i3 2, i3 3>,
  <8 x i3> <i3 -1, i3 -1, i3 -1, i3 -1, i3 -1, i3 -1, i3 -1, i3 -1>,
  i32 0)
  ret <8 x i3> %r
}

define <8 x i3> @test_smul_fix_v8i3_4() {
; CHECK-LABEL: @test_smul_fix_v8i3_4(
; CHECK-NEXT:    ret <8 x i3> <i3 2, i3 1, i3 1, i3 0, i3 0, i3 -1, i3 -1, i3 -2>
;
  %r = call <8 x i3> @llvm.smul.fix.v8i3(
  <8 x i3> <i3 -4, i3 -3, i3 -2, i3 -1, i3 0, i3 1, i3 2, i3 3>,
  <8 x i3> <i3 -1, i3 -1, i3 -1, i3 -1, i3 -1, i3 -1, i3 -1, i3 -1>,
  i32 1)
  ret <8 x i3> %r
}

define <8 x i3> @test_smul_fix_v8i3_5() {
; CHECK-LABEL: @test_smul_fix_v8i3_5(
; CHECK-NEXT:    ret <8 x i3> <i3 1, i3 0, i3 0, i3 0, i3 0, i3 -1, i3 -1, i3 -1>
;
  %r = call <8 x i3> @llvm.smul.fix.v8i3(
  <8 x i3> <i3 -4, i3 -3, i3 -2, i3 -1, i3 0, i3 1, i3 2, i3 3>,
  <8 x i3> <i3 -1, i3 -1, i3 -1, i3 -1, i3 -1, i3 -1, i3 -1, i3 -1>,
  i32 2)
  ret <8 x i3> %r
}

define <8 x i3> @test_smul_fix_v8i3_6() {
; CHECK-LABEL: @test_smul_fix_v8i3_6(
; CHECK-NEXT:    ret <8 x i3> <i3 -4, i3 -1, i3 2, i3 -3, i3 0, i3 3, i3 -2, i3 1>
;
  %r = call <8 x i3> @llvm.smul.fix.v8i3(
  <8 x i3> <i3 -4, i3 -3, i3 -2, i3 -1, i3 0, i3 1, i3 2, i3 3>,
  <8 x i3> <i3 3, i3 3, i3 3, i3 3, i3 3, i3 3, i3 3, i3 3>,
  i32 0)
  ret <8 x i3> %r
}

define <8 x i3> @test_smul_fix_v8i3_7() {
; CHECK-LABEL: @test_smul_fix_v8i3_7(
; CHECK-NEXT:    ret <8 x i3> <i3 2, i3 3, i3 -3, i3 -2, i3 0, i3 1, i3 3, i3 -4>
;
  %r = call <8 x i3> @llvm.smul.fix.v8i3(
  <8 x i3> <i3 -4, i3 -3, i3 -2, i3 -1, i3 0, i3 1, i3 2, i3 3>,
  <8 x i3> <i3 3, i3 3, i3 3, i3 3, i3 3, i3 3, i3 3, i3 3>,
  i32 1)
  ret <8 x i3> %r
}

define <8 x i3> @test_smul_fix_v8i3_8() {
; CHECK-LABEL: @test_smul_fix_v8i3_8(
; CHECK-NEXT:    ret <8 x i3> <i3 -3, i3 -3, i3 -2, i3 -1, i3 0, i3 0, i3 1, i3 2>
;
  %r = call <8 x i3> @llvm.smul.fix.v8i3(
  <8 x i3> <i3 -4, i3 -3, i3 -2, i3 -1, i3 0, i3 1, i3 2, i3 3>,
  <8 x i3> <i3 3, i3 3, i3 3, i3 3, i3 3, i3 3, i3 3, i3 3>,
  i32 2)
  ret <8 x i3> %r
}

define <8 x i3> @test_smul_fix_v8i3_9() {
; CHECK-LABEL: @test_smul_fix_v8i3_9(
; CHECK-NEXT:    ret <8 x i3> <i3 0, i3 0, i3 poison, i3 poison, i3 1, i3 1, i3 1, i3 1>
;
  %r = call <8 x i3> @llvm.smul.fix.v8i3(
  <8 x i3> <i3 2, i3 undef, i3 2, i3 poison, i3 2, i3 2, i3 2, i3 2>,
  <8 x i3> <i3 undef, i3 2, i3 poison, i3 2, i3 2, i3 2, i3 2, i3 2>,
  i32 2)
  ret <8 x i3> %r
}
