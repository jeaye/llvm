; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -instcombine -S < %s | FileCheck %s

declare void @use(i32)

define i32 @test1(i32 %x) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], 31
; CHECK-NEXT:    [[SUB:%.*]] = xor i32 [[AND]], 63
; CHECK-NEXT:    ret i32 [[SUB]]
;
  %and = and i32 %x, 31
  %sub = sub i32 63, %and
  ret i32 %sub
}

define <2 x i32> @test1vec(<2 x i32> %x) {
; CHECK-LABEL: @test1vec(
; CHECK-NEXT:    [[AND:%.*]] = and <2 x i32> [[X:%.*]], <i32 31, i32 31>
; CHECK-NEXT:    [[SUB:%.*]] = xor <2 x i32> [[AND]], <i32 63, i32 63>
; CHECK-NEXT:    ret <2 x i32> [[SUB]]
;
  %and = and <2 x i32> %x, <i32 31, i32 31>
  %sub = sub <2 x i32> <i32 63, i32 63>, %and
  ret <2 x i32> %sub
}

declare i32 @llvm.ctlz.i32(i32, i1) nounwind readnone

define i32 @test2(i32 %x) nounwind {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[COUNT:%.*]] = tail call i32 @llvm.ctlz.i32(i32 [[X:%.*]], i1 true) [[ATTR2:#.*]], [[RNG0:!range !.*]]
; CHECK-NEXT:    [[SUB:%.*]] = xor i32 [[COUNT]], 31
; CHECK-NEXT:    ret i32 [[SUB]]
;
  %count = tail call i32 @llvm.ctlz.i32(i32 %x, i1 true) nounwind readnone
  %sub = sub i32 31, %count
  ret i32 %sub
}

define i32 @xor_add(i32 %x) {
; CHECK-LABEL: @xor_add(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], 31
; CHECK-NEXT:    [[ADD:%.*]] = sub nuw nsw i32 73, [[AND]]
; CHECK-NEXT:    ret i32 [[ADD]]
;
  %and = and i32 %x, 31
  %xor = xor i32 %and, 31
  %add = add i32 %xor, 42
  ret i32 %add
}

define i32 @xor_add_extra_use(i32 %x) {
; CHECK-LABEL: @xor_add_extra_use(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], 31
; CHECK-NEXT:    [[XOR:%.*]] = xor i32 [[AND]], 31
; CHECK-NEXT:    call void @use(i32 [[XOR]])
; CHECK-NEXT:    [[ADD:%.*]] = sub nuw nsw i32 73, [[AND]]
; CHECK-NEXT:    ret i32 [[ADD]]
;
  %and = and i32 %x, 31
  %xor = xor i32 %and, 31
  call void @use(i32 %xor)
  %add = add i32 %xor, 42
  ret i32 %add
}

define <2 x i8> @xor_add_splat(<2 x i8> %x) {
; CHECK-LABEL: @xor_add_splat(
; CHECK-NEXT:    [[AND:%.*]] = and <2 x i8> [[X:%.*]], <i8 24, i8 24>
; CHECK-NEXT:    [[XOR:%.*]] = xor <2 x i8> [[AND]], <i8 63, i8 63>
; CHECK-NEXT:    [[ADD:%.*]] = add nuw nsw <2 x i8> [[XOR]], <i8 42, i8 42>
; CHECK-NEXT:    ret <2 x i8> [[ADD]]
;
  %and = and <2 x i8> %x, <i8 24, i8 24>
  %xor = xor <2 x i8> %and, <i8 63, i8 63>
  %add = add <2 x i8> %xor, <i8 42, i8 42>
  ret <2 x i8> %add
}

define <2 x i8> @xor_add_splat_undef(<2 x i8> %x) {
; CHECK-LABEL: @xor_add_splat_undef(
; CHECK-NEXT:    [[AND:%.*]] = and <2 x i8> [[X:%.*]], <i8 24, i8 24>
; CHECK-NEXT:    [[XOR:%.*]] = xor <2 x i8> [[AND]], <i8 63, i8 undef>
; CHECK-NEXT:    [[ADD:%.*]] = add <2 x i8> [[XOR]], <i8 42, i8 42>
; CHECK-NEXT:    ret <2 x i8> [[ADD]]
;
  %and = and <2 x i8> %x, <i8 24, i8 24>
  %xor = xor <2 x i8> %and, <i8 63, i8 undef>
  %add = add <2 x i8> %xor, <i8 42, i8 42>
  ret <2 x i8> %add
}
