; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt %s -instsimplify -S | FileCheck %s

; Here we subtract two values, check that subtraction did not overflow AND
; that the result is non-zero. This can be simplified just to a comparison
; between the base and offset.

declare void @llvm.assume(i1)

define i1 @t0(i8 %base, i8 %offset) {
; CHECK-LABEL: @t0(
; CHECK-NEXT:    [[CMP:%.*]] = icmp ne i8 [[OFFSET:%.*]], 0
; CHECK-NEXT:    call void @llvm.assume(i1 [[CMP]])
; CHECK-NEXT:    [[ADJUSTED:%.*]] = sub i8 [[BASE:%.*]], [[OFFSET]]
; CHECK-NEXT:    [[NO_UNDERFLOW:%.*]] = icmp uge i8 [[ADJUSTED]], [[BASE]]
; CHECK-NEXT:    [[NOT_NULL:%.*]] = icmp ne i8 [[ADJUSTED]], 0
; CHECK-NEXT:    [[R:%.*]] = and i1 [[NOT_NULL]], [[NO_UNDERFLOW]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %cmp = icmp ne i8 %offset, 0
  call void @llvm.assume(i1 %cmp)

  %adjusted = sub i8 %base, %offset
  %no_underflow = icmp uge i8 %adjusted, %base
  %not_null = icmp ne i8 %adjusted, 0
  %r = and i1 %not_null, %no_underflow
  ret i1 %r
}

define i1 @t1(i8 %base, i8 %offset) {
; CHECK-LABEL: @t1(
; CHECK-NEXT:    [[CMP:%.*]] = icmp ne i8 [[OFFSET:%.*]], 0
; CHECK-NEXT:    call void @llvm.assume(i1 [[CMP]])
; CHECK-NEXT:    [[ADJUSTED:%.*]] = sub i8 [[BASE:%.*]], [[OFFSET]]
; CHECK-NEXT:    [[NO_UNDERFLOW:%.*]] = icmp ult i8 [[ADJUSTED]], [[BASE]]
; CHECK-NEXT:    [[NOT_NULL:%.*]] = icmp eq i8 [[ADJUSTED]], 0
; CHECK-NEXT:    [[R:%.*]] = or i1 [[NOT_NULL]], [[NO_UNDERFLOW]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %cmp = icmp ne i8 %offset, 0
  call void @llvm.assume(i1 %cmp)

  %adjusted = sub i8 %base, %offset
  %no_underflow = icmp ult i8 %adjusted, %base
  %not_null = icmp eq i8 %adjusted, 0
  %r = or i1 %not_null, %no_underflow
  ret i1 %r
}

define i1 @t2_commutative(i8 %base, i8 %offset) {
; CHECK-LABEL: @t2_commutative(
; CHECK-NEXT:    [[CMP:%.*]] = icmp ne i8 [[OFFSET:%.*]], 0
; CHECK-NEXT:    call void @llvm.assume(i1 [[CMP]])
; CHECK-NEXT:    [[ADJUSTED:%.*]] = sub i8 [[BASE:%.*]], [[OFFSET]]
; CHECK-NEXT:    [[NO_UNDERFLOW:%.*]] = icmp ule i8 [[BASE]], [[ADJUSTED]]
; CHECK-NEXT:    [[NOT_NULL:%.*]] = icmp ne i8 [[ADJUSTED]], 0
; CHECK-NEXT:    [[R:%.*]] = and i1 [[NOT_NULL]], [[NO_UNDERFLOW]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %cmp = icmp ne i8 %offset, 0
  call void @llvm.assume(i1 %cmp)

  %adjusted = sub i8 %base, %offset
  %no_underflow = icmp ule i8 %base, %adjusted
  %not_null = icmp ne i8 %adjusted, 0
  %r = and i1 %not_null, %no_underflow
  ret i1 %r
}

; We don't know that offset is non-zero, so we can't fold.
define i1 @t3_bad(i8 %base, i8 %offset) {
; CHECK-LABEL: @t3_bad(
; CHECK-NEXT:    [[ADJUSTED:%.*]] = sub i8 [[BASE:%.*]], [[OFFSET:%.*]]
; CHECK-NEXT:    [[NO_UNDERFLOW:%.*]] = icmp uge i8 [[ADJUSTED]], [[BASE]]
; CHECK-NEXT:    [[NOT_NULL:%.*]] = icmp ne i8 [[ADJUSTED]], 0
; CHECK-NEXT:    [[R:%.*]] = and i1 [[NOT_NULL]], [[NO_UNDERFLOW]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %adjusted = sub i8 %base, %offset
  %no_underflow = icmp uge i8 %adjusted, %base
  %not_null = icmp ne i8 %adjusted, 0
  %r = and i1 %not_null, %no_underflow
  ret i1 %r
}
