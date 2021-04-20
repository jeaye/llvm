; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

; Iff trunc only chops off zero bits that were just shifted-in by the lshr,
; but no other bits, then we can instead do signed shift, and signext it.
; Note that we can replace trunc with trunc of new signed shift.

declare void @use8(i8)
declare void @use4(i4)
declare void @usevec8(<2 x i8>)
declare void @usevec4(<2 x i4>)

define i16 @t0(i8 %x) {
; CHECK-LABEL: @t0(
; CHECK-NEXT:    [[A:%.*]] = lshr i8 [[X:%.*]], 4
; CHECK-NEXT:    [[B:%.*]] = trunc i8 [[A]] to i4
; CHECK-NEXT:    [[C:%.*]] = sext i4 [[B]] to i16
; CHECK-NEXT:    ret i16 [[C]]
;
  %a = lshr i8 %x, 4
  %b = trunc i8 %a to i4
  %c = sext i4 %b to i16
  ret i16 %c
}

define i16 @t1(i8 %x) {
; CHECK-LABEL: @t1(
; CHECK-NEXT:    [[A:%.*]] = lshr i8 [[X:%.*]], 5
; CHECK-NEXT:    [[B:%.*]] = trunc i8 [[A]] to i3
; CHECK-NEXT:    [[C:%.*]] = sext i3 [[B]] to i16
; CHECK-NEXT:    ret i16 [[C]]
;
  %a = lshr i8 %x, 5
  %b = trunc i8 %a to i3
  %c = sext i3 %b to i16
  ret i16 %c
}

define i16 @t2(i7 %x) {
; CHECK-LABEL: @t2(
; CHECK-NEXT:    [[A:%.*]] = lshr i7 [[X:%.*]], 3
; CHECK-NEXT:    [[B:%.*]] = trunc i7 [[A]] to i4
; CHECK-NEXT:    [[C:%.*]] = sext i4 [[B]] to i16
; CHECK-NEXT:    ret i16 [[C]]
;
  %a = lshr i7 %x, 3
  %b = trunc i7 %a to i4
  %c = sext i4 %b to i16
  ret i16 %c
}

define i16 @n3(i8 %x) {
; CHECK-LABEL: @n3(
; CHECK-NEXT:    [[A:%.*]] = lshr i8 [[X:%.*]], 3
; CHECK-NEXT:    [[B:%.*]] = trunc i8 [[A]] to i4
; CHECK-NEXT:    [[C:%.*]] = sext i4 [[B]] to i16
; CHECK-NEXT:    ret i16 [[C]]
;
  %a = lshr i8 %x, 3
  %b = trunc i8 %a to i4
  %c = sext i4 %b to i16
  ret i16 %c
}

define <2 x i16> @t4_vec_splat(<2 x i8> %x) {
; CHECK-LABEL: @t4_vec_splat(
; CHECK-NEXT:    [[A:%.*]] = lshr <2 x i8> [[X:%.*]], <i8 4, i8 4>
; CHECK-NEXT:    [[B:%.*]] = trunc <2 x i8> [[A]] to <2 x i4>
; CHECK-NEXT:    [[C:%.*]] = sext <2 x i4> [[B]] to <2 x i16>
; CHECK-NEXT:    ret <2 x i16> [[C]]
;
  %a = lshr <2 x i8> %x, <i8 4, i8 4>
  %b = trunc <2 x i8> %a to <2 x i4>
  %c = sext <2 x i4> %b to <2 x i16>
  ret <2 x i16> %c
}

define <2 x i16> @t5_vec_undef(<2 x i8> %x) {
; CHECK-LABEL: @t5_vec_undef(
; CHECK-NEXT:    [[A:%.*]] = lshr <2 x i8> [[X:%.*]], <i8 4, i8 undef>
; CHECK-NEXT:    [[B:%.*]] = trunc <2 x i8> [[A]] to <2 x i4>
; CHECK-NEXT:    [[C:%.*]] = sext <2 x i4> [[B]] to <2 x i16>
; CHECK-NEXT:    ret <2 x i16> [[C]]
;
  %a = lshr <2 x i8> %x, <i8 4, i8 undef>
  %b = trunc <2 x i8> %a to <2 x i4>
  %c = sext <2 x i4> %b to <2 x i16>
  ret <2 x i16> %c
}

define i16 @t6_extrause0(i8 %x) {
; CHECK-LABEL: @t6_extrause0(
; CHECK-NEXT:    [[A:%.*]] = lshr i8 [[X:%.*]], 4
; CHECK-NEXT:    [[B:%.*]] = trunc i8 [[A]] to i4
; CHECK-NEXT:    call void @use4(i4 [[B]])
; CHECK-NEXT:    [[C:%.*]] = sext i4 [[B]] to i16
; CHECK-NEXT:    ret i16 [[C]]
;
  %a = lshr i8 %x, 4
  %b = trunc i8 %a to i4 ; has extra use, but we can deal with that
  call void @use4(i4 %b)
  %c = sext i4 %b to i16
  ret i16 %c
}
define <2 x i16> @t7_extrause0_vec_undef(<2 x i8> %x) {
; CHECK-LABEL: @t7_extrause0_vec_undef(
; CHECK-NEXT:    [[A:%.*]] = lshr <2 x i8> [[X:%.*]], <i8 4, i8 undef>
; CHECK-NEXT:    [[B:%.*]] = trunc <2 x i8> [[A]] to <2 x i4>
; CHECK-NEXT:    call void @usevec4(<2 x i4> [[B]])
; CHECK-NEXT:    [[C:%.*]] = sext <2 x i4> [[B]] to <2 x i16>
; CHECK-NEXT:    ret <2 x i16> [[C]]
;
  %a = lshr <2 x i8> %x, <i8 4, i8 undef>
  %b = trunc <2 x i8> %a to <2 x i4>
  call void @usevec4(<2 x i4> %b)
  %c = sext <2 x i4> %b to <2 x i16>
  ret <2 x i16> %c
}
define i16 @t8_extrause1(i8 %x) {
; CHECK-LABEL: @t8_extrause1(
; CHECK-NEXT:    [[A:%.*]] = lshr i8 [[X:%.*]], 4
; CHECK-NEXT:    call void @use8(i8 [[A]])
; CHECK-NEXT:    [[B:%.*]] = trunc i8 [[A]] to i4
; CHECK-NEXT:    [[C:%.*]] = sext i4 [[B]] to i16
; CHECK-NEXT:    ret i16 [[C]]
;
  %a = lshr i8 %x, 4 ; has extra use, but we can deal with that
  call void @use8(i8 %a)
  %b = trunc i8 %a to i4
  %c = sext i4 %b to i16
  ret i16 %c
}
define <2 x i16> @t9_extrause1_vec_undef(<2 x i8> %x) {
; CHECK-LABEL: @t9_extrause1_vec_undef(
; CHECK-NEXT:    [[A:%.*]] = lshr <2 x i8> [[X:%.*]], <i8 4, i8 undef>
; CHECK-NEXT:    call void @usevec8(<2 x i8> [[A]])
; CHECK-NEXT:    [[B:%.*]] = trunc <2 x i8> [[A]] to <2 x i4>
; CHECK-NEXT:    [[C:%.*]] = sext <2 x i4> [[B]] to <2 x i16>
; CHECK-NEXT:    ret <2 x i16> [[C]]
;
  %a = lshr <2 x i8> %x, <i8 4, i8 undef>
  call void @usevec8(<2 x i8> %a)
  %b = trunc <2 x i8> %a to <2 x i4>
  %c = sext <2 x i4> %b to <2 x i16>
  ret <2 x i16> %c
}
define i16 @t10_extrause2(i8 %x) {
; CHECK-LABEL: @t10_extrause2(
; CHECK-NEXT:    [[A:%.*]] = lshr i8 [[X:%.*]], 4
; CHECK-NEXT:    call void @use8(i8 [[A]])
; CHECK-NEXT:    [[B:%.*]] = trunc i8 [[A]] to i4
; CHECK-NEXT:    call void @use4(i4 [[B]])
; CHECK-NEXT:    [[C:%.*]] = sext i4 [[B]] to i16
; CHECK-NEXT:    ret i16 [[C]]
;
  %a = lshr i8 %x, 4 ; has extra use
  call void @use8(i8 %a)
  %b = trunc i8 %a to i4 ; has extra use
  call void @use4(i4 %b)
  %c = sext i4 %b to i16
  ret i16 %c
}
define <2 x i16> @t11_extrause2_vec_undef(<2 x i8> %x) {
; CHECK-LABEL: @t11_extrause2_vec_undef(
; CHECK-NEXT:    [[A:%.*]] = lshr <2 x i8> [[X:%.*]], <i8 4, i8 undef>
; CHECK-NEXT:    call void @usevec8(<2 x i8> [[A]])
; CHECK-NEXT:    [[B:%.*]] = trunc <2 x i8> [[A]] to <2 x i4>
; CHECK-NEXT:    call void @usevec4(<2 x i4> [[B]])
; CHECK-NEXT:    [[C:%.*]] = sext <2 x i4> [[B]] to <2 x i16>
; CHECK-NEXT:    ret <2 x i16> [[C]]
;
  %a = lshr <2 x i8> %x, <i8 4, i8 undef>
  call void @usevec8(<2 x i8> %a)
  %b = trunc <2 x i8> %a to <2 x i4>
  call void @usevec4(<2 x i4> %b)
  %c = sext <2 x i4> %b to <2 x i16>
  ret <2 x i16> %c
}
