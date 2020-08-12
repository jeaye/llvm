; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instsimplify -S | FileCheck %s

declare i32 @llvm.abs.i32(i32, i1)
declare <3 x i82> @llvm.abs.v3i82(<3 x i82>, i1)
declare <4 x i32> @llvm.abs.v4i32(<4 x i32>, i1)

define i32 @test_abs_abs_0(i32 %x) {
; CHECK-LABEL: @test_abs_abs_0(
; CHECK-NEXT:    [[A:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 false)
; CHECK-NEXT:    ret i32 [[A]]
;
  %a = call i32 @llvm.abs.i32(i32 %x, i1 false)
  %b = call i32 @llvm.abs.i32(i32 %a, i1 false)
  ret i32 %b
}

define i32 @test_abs_abs_1(i32 %x) {
; CHECK-LABEL: @test_abs_abs_1(
; CHECK-NEXT:    [[A:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    ret i32 [[A]]
;
  %a = call i32 @llvm.abs.i32(i32 %x, i1 true)
  %b = call i32 @llvm.abs.i32(i32 %a, i1 false)
  ret i32 %b
}

define i32 @test_abs_abs_2(i32 %x) {
; CHECK-LABEL: @test_abs_abs_2(
; CHECK-NEXT:    [[A:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 false)
; CHECK-NEXT:    ret i32 [[A]]
;
  %a = call i32 @llvm.abs.i32(i32 %x, i1 false)
  %b = call i32 @llvm.abs.i32(i32 %a, i1 true)
  ret i32 %b
}

define i32 @test_abs_abs_3(i32 %x) {
; CHECK-LABEL: @test_abs_abs_3(
; CHECK-NEXT:    [[A:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    ret i32 [[A]]
;
  %a = call i32 @llvm.abs.i32(i32 %x, i1 true)
  %b = call i32 @llvm.abs.i32(i32 %a, i1 true)
  ret i32 %b
}

; If the sign bit is known zero, the abs is not needed.

define i32 @zext_abs(i31 %x) {
; CHECK-LABEL: @zext_abs(
; CHECK-NEXT:    [[ZEXT:%.*]] = zext i31 [[X:%.*]] to i32
; CHECK-NEXT:    ret i32 [[ZEXT]]
;
  %zext = zext i31 %x to i32
  %abs = call i32 @llvm.abs.i32(i32 %zext, i1 false)
  ret i32 %abs
}

define <3 x i82> @lshr_abs(<3 x i82> %x) {
; CHECK-LABEL: @lshr_abs(
; CHECK-NEXT:    [[LSHR:%.*]] = lshr <3 x i82> [[X:%.*]], <i82 1, i82 1, i82 1>
; CHECK-NEXT:    ret <3 x i82> [[LSHR]]
;
  %lshr = lshr <3 x i82> %x, <i82 1, i82 1, i82 1>
  %abs = call <3 x i82> @llvm.abs.v3i82(<3 x i82> %lshr, i1 true)
  ret <3 x i82> %abs
}

define i32 @and_abs(i32 %x) {
; CHECK-LABEL: @and_abs(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], 2147483644
; CHECK-NEXT:    ret i32 [[AND]]
;
  %and = and i32 %x, 2147483644
  %abs = call i32 @llvm.abs.i32(i32 %and, i1 true)
  ret i32 %abs
}

define <3 x i82> @select_abs(<3 x i1> %cond) {
; CHECK-LABEL: @select_abs(
; CHECK-NEXT:    [[SEL:%.*]] = select <3 x i1> [[COND:%.*]], <3 x i82> zeroinitializer, <3 x i82> <i82 2147483647, i82 42, i82 1>
; CHECK-NEXT:    ret <3 x i82> [[SEL]]
;
  %sel = select <3 x i1> %cond, <3 x i82> zeroinitializer, <3 x i82> <i82 2147483647, i82 42, i82 1>
  %abs = call <3 x i82> @llvm.abs.v3i82(<3 x i82> %sel, i1 false)
  ret <3 x i82> %abs
}

declare void @llvm.assume(i1)

define i32 @assume_abs(i32 %x) {
; CHECK-LABEL: @assume_abs(
; CHECK-NEXT:    [[ASSUME:%.*]] = icmp sge i32 [[X:%.*]], 0
; CHECK-NEXT:    call void @llvm.assume(i1 [[ASSUME]])
; CHECK-NEXT:    ret i32 [[X]]
;
  %assume = icmp sge i32 %x, 0
  call void @llvm.assume(i1 %assume)
  %abs = call i32 @llvm.abs.i32(i32 %x, i1 true)
  ret i32 %abs
}

define i1 @abs_nsw_must_be_positive(i32 %x) {
; CHECK-LABEL: @abs_nsw_must_be_positive(
; CHECK-NEXT:    ret i1 true
;
  %abs = call i32 @llvm.abs.i32(i32 %x, i1 true)
  %c2 = icmp sge i32 %abs, 0
  ret i1 %c2
}

define <4 x i1> @abs_nsw_must_be_positive_vec(<4 x i32> %x) {
; CHECK-LABEL: @abs_nsw_must_be_positive_vec(
; CHECK-NEXT:    ret <4 x i1> <i1 true, i1 true, i1 true, i1 true>
;
  %abs = call <4 x i32> @llvm.abs.v4i32(<4 x i32> %x, i1 true)
  %c2 = icmp sge <4 x i32> %abs, zeroinitializer
  ret <4 x i1> %c2
}

; Negative test, no nsw provides no information about the sign bit of the result.
define i1 @abs_nonsw(i32 %x) {
; CHECK-LABEL: @abs_nonsw(
; CHECK-NEXT:    [[ABS:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 false)
; CHECK-NEXT:    [[C2:%.*]] = icmp sge i32 [[ABS]], 0
; CHECK-NEXT:    ret i1 [[C2]]
;
  %abs = call i32 @llvm.abs.i32(i32 %x, i1 false)
  %c2 = icmp sge i32 %abs, 0
  ret i1 %c2
}

define <4 x i1> @abs_nonsw_vec(<4 x i32> %x) {
; CHECK-LABEL: @abs_nonsw_vec(
; CHECK-NEXT:    [[ABS:%.*]] = call <4 x i32> @llvm.abs.v4i32(<4 x i32> [[X:%.*]], i1 false)
; CHECK-NEXT:    [[C2:%.*]] = icmp sge <4 x i32> [[ABS]], zeroinitializer
; CHECK-NEXT:    ret <4 x i1> [[C2]]
;
  %abs = call <4 x i32> @llvm.abs.v4i32(<4 x i32> %x, i1 false)
  %c2 = icmp sge <4 x i32> %abs, zeroinitializer
  ret <4 x i1> %c2
}

define i1 @abs_known_positive_input_compare(i31 %x) {
; CHECK-LABEL: @abs_known_positive_input_compare(
; CHECK-NEXT:    ret i1 true
;
  %zext = zext i31 %x to i32
  %abs = call i32 @llvm.abs.i32(i32 %zext, i1 false)
  %c2 = icmp sge i32 %abs, 0
  ret i1 %c2
}

define <4 x i1> @abs_known_positive_input_compare_vec(<4 x i31> %x) {
; CHECK-LABEL: @abs_known_positive_input_compare_vec(
; CHECK-NEXT:    ret <4 x i1> <i1 true, i1 true, i1 true, i1 true>
;
  %zext = zext <4 x i31> %x to <4 x i32>
  %abs = call <4 x i32> @llvm.abs.v4i32(<4 x i32> %zext, i1 false)
  %c2 = icmp sge <4 x i32> %abs, zeroinitializer
  ret <4 x i1> %c2
}

define i1 @abs_known_not_int_min(i32 %x) {
; CHECK-LABEL: @abs_known_not_int_min(
; CHECK-NEXT:    ret i1 true
;
  %or = or i32 %x, 1
  %abs = call i32 @llvm.abs.i32(i32 %or, i1 false)
  %c2 = icmp sge i32 %abs, 0
  ret i1 %c2
}

define <4 x i1> @abs_known_not_int_min_vec(<4 x i32> %x) {
; CHECK-LABEL: @abs_known_not_int_min_vec(
; CHECK-NEXT:    ret <4 x i1> <i1 true, i1 true, i1 true, i1 true>
;
  %or = or <4 x i32> %x, <i32 1, i32 1, i32 1, i32 1>
  %abs = call <4 x i32> @llvm.abs.v4i32(<4 x i32> %or, i1 false)
  %c2 = icmp sge <4 x i32> %abs, zeroinitializer
  ret <4 x i1> %c2
}

