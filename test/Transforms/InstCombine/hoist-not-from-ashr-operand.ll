; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

; Transform
;   (~x) a>> y
; into:
;   ~(x a>> y)

declare void @use8(i8)

; Most basic positive test
define i8 @t0(i8 %x, i8 %y) {
; CHECK-LABEL: @t0(
; CHECK-NEXT:    [[NOT_X_NOT:%.*]] = ashr i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[ASHR:%.*]] = xor i8 [[NOT_X_NOT]], -1
; CHECK-NEXT:    ret i8 [[ASHR]]
;
  %not_x = xor i8 %x, -1
  %ashr = ashr i8 %not_x, %y
  ret i8 %ashr
}
; 'exact'-ness isn't preserved!
define i8 @t1(i8 %x, i8 %y) {
; CHECK-LABEL: @t1(
; CHECK-NEXT:    [[NOT_X_NOT:%.*]] = ashr i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[ASHR:%.*]] = xor i8 [[NOT_X_NOT]], -1
; CHECK-NEXT:    ret i8 [[ASHR]]
;
  %not_x = xor i8 %x, -1
  %ashr = ashr exact i8 %not_x, %y
  ret i8 %ashr
}
; Basic vector test
define <2 x i8> @t2_vec(<2 x i8> %x, <2 x i8> %y) {
; CHECK-LABEL: @t2_vec(
; CHECK-NEXT:    [[NOT_X_NOT:%.*]] = ashr <2 x i8> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[ASHR:%.*]] = xor <2 x i8> [[NOT_X_NOT]], <i8 -1, i8 -1>
; CHECK-NEXT:    ret <2 x i8> [[ASHR]]
;
  %not_x = xor <2 x i8> %x, <i8 -1, i8 -1>
  %ashr = ashr <2 x i8> %not_x, %y
  ret <2 x i8> %ashr
}
; Note that we must sanitize undef elts of -1 constant to -1 or 0.
define <2 x i8> @t3_vec_undef(<2 x i8> %x, <2 x i8> %y) {
; CHECK-LABEL: @t3_vec_undef(
; CHECK-NEXT:    [[NOT_X_NOT:%.*]] = ashr <2 x i8> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[ASHR:%.*]] = xor <2 x i8> [[NOT_X_NOT]], <i8 -1, i8 -1>
; CHECK-NEXT:    ret <2 x i8> [[ASHR]]
;
  %not_x = xor <2 x i8> %x, <i8 -1, i8 undef>
  %ashr = ashr <2 x i8> %not_x, %y
  ret <2 x i8> %ashr
}

; Extra use prevents the fold.
define i8 @n4(i8 %x, i8 %y) {
; CHECK-LABEL: @n4(
; CHECK-NEXT:    [[NOT_X:%.*]] = xor i8 [[X:%.*]], -1
; CHECK-NEXT:    call void @use8(i8 [[NOT_X]])
; CHECK-NEXT:    [[ASHR:%.*]] = ashr i8 [[NOT_X]], [[Y:%.*]]
; CHECK-NEXT:    ret i8 [[ASHR]]
;
  %not_x = xor i8 %x, -1
  call void @use8(i8 %not_x)
  %ashr = ashr i8 %not_x, %y
  ret i8 %ashr
}
