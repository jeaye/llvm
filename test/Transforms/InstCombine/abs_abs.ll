; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

define i32 @abs_abs_x01(i32 %x) {
; CHECK-LABEL: @abs_abs_x01(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %cmp = icmp sgt i32 %x, -1
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %x, i32 %sub
  %cmp1 = icmp sgt i32 %cond, -1
  %sub16 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %cond, i32 %sub16
  ret i32 %cond18
}

define <2 x i32> @abs_abs_x01_vec(<2 x i32> %x) {
; CHECK-LABEL: @abs_abs_x01_vec(
; CHECK-NEXT:    [[TMP1:%.*]] = call <2 x i32> @llvm.abs.v2i32(<2 x i32> [[X:%.*]], i1 true)
; CHECK-NEXT:    ret <2 x i32> [[TMP1]]
;
  %cmp = icmp sgt <2 x i32> %x, <i32 -1, i32 -1>
  %sub = sub nsw <2 x i32> zeroinitializer, %x
  %cond = select <2 x i1> %cmp, <2 x i32> %x, <2 x i32> %sub
  %cmp1 = icmp sgt <2 x i32> %cond, <i32 -1, i32 -1>
  %sub16 = sub nsw <2 x i32> zeroinitializer, %cond
  %cond18 = select <2 x i1> %cmp1, <2 x i32> %cond, <2 x i32> %sub16
  ret <2 x i32> %cond18
}

define i32 @abs_abs_x02(i32 %x) {
; CHECK-LABEL: @abs_abs_x02(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %cmp = icmp sgt i32 %x, 0
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %x, i32 %sub
  %cmp1 = icmp sgt i32 %cond, -1
  %sub16 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %cond, i32 %sub16
  ret i32 %cond18
}

define i32 @abs_abs_x03(i32 %x) {
; CHECK-LABEL: @abs_abs_x03(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %cmp = icmp slt i32 %x, 0
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %sub, i32 %x
  %cmp1 = icmp sgt i32 %cond, -1
  %sub16 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %cond, i32 %sub16
  ret i32 %cond18
}

define i32 @abs_abs_x04(i32 %x) {
; CHECK-LABEL: @abs_abs_x04(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %cmp = icmp slt i32 %x, 1
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %sub, i32 %x
  %cmp1 = icmp sgt i32 %cond, -1
  %sub16 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %cond, i32 %sub16
  ret i32 %cond18
}

define <2 x i32> @abs_abs_x04_vec(<2 x i32> %x) {
; CHECK-LABEL: @abs_abs_x04_vec(
; CHECK-NEXT:    [[TMP1:%.*]] = call <2 x i32> @llvm.abs.v2i32(<2 x i32> [[X:%.*]], i1 true)
; CHECK-NEXT:    ret <2 x i32> [[TMP1]]
;
  %cmp = icmp slt <2 x i32> %x, <i32 1, i32 1>
  %sub = sub nsw <2 x i32> zeroinitializer, %x
  %cond = select <2 x i1> %cmp, <2 x i32> %sub, <2 x i32> %x
  %cmp1 = icmp sgt <2 x i32> %cond, <i32 -1, i32 -1>
  %sub16 = sub nsw <2 x i32> zeroinitializer, %cond
  %cond18 = select <2 x i1> %cmp1, <2 x i32> %cond, <2 x i32> %sub16
  ret <2 x i32> %cond18
}

define i32 @abs_abs_x05(i32 %x) {
; CHECK-LABEL: @abs_abs_x05(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %cmp = icmp sgt i32 %x, -1
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %x, i32 %sub
  %cmp1 = icmp sgt i32 %cond, 0
  %sub16 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %cond, i32 %sub16
  ret i32 %cond18
}

define i32 @abs_abs_x06(i32 %x) {
; CHECK-LABEL: @abs_abs_x06(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %cmp = icmp sgt i32 %x, 0
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %x, i32 %sub
  %cmp1 = icmp sgt i32 %cond, 0
  %sub16 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %cond, i32 %sub16
  ret i32 %cond18
}

define i32 @abs_abs_x07(i32 %x) {
; CHECK-LABEL: @abs_abs_x07(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %cmp = icmp slt i32 %x, 0
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %sub, i32 %x
  %cmp1 = icmp sgt i32 %cond, 0
  %sub16 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %cond, i32 %sub16
  ret i32 %cond18
}

define i32 @abs_abs_x08(i32 %x) {
; CHECK-LABEL: @abs_abs_x08(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %cmp = icmp slt i32 %x, 1
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %sub, i32 %x
  %cmp1 = icmp sgt i32 %cond, 0
  %sub16 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %cond, i32 %sub16
  ret i32 %cond18
}

define i32 @abs_abs_x09(i32 %x) {
; CHECK-LABEL: @abs_abs_x09(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %cmp = icmp sgt i32 %x, -1
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %x, i32 %sub
  %cmp1 = icmp slt i32 %cond, 0
  %sub9 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %sub9, i32 %cond
  ret i32 %cond18
}

define i32 @abs_abs_x10(i32 %x) {
; CHECK-LABEL: @abs_abs_x10(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %cmp = icmp sgt i32 %x, 0
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %x, i32 %sub
  %cmp1 = icmp slt i32 %cond, 0
  %sub9 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %sub9, i32 %cond
  ret i32 %cond18
}

define i32 @abs_abs_x11(i32 %x) {
; CHECK-LABEL: @abs_abs_x11(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %cmp = icmp slt i32 %x, 0
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %sub, i32 %x
  %cmp1 = icmp slt i32 %cond, 0
  %sub9 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %sub9, i32 %cond
  ret i32 %cond18
}

define i32 @abs_abs_x12(i32 %x) {
; CHECK-LABEL: @abs_abs_x12(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %cmp = icmp slt i32 %x, 1
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %sub, i32 %x
  %cmp1 = icmp slt i32 %cond, 0
  %sub9 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %sub9, i32 %cond
  ret i32 %cond18
}

define i32 @abs_abs_x13(i32 %x) {
; CHECK-LABEL: @abs_abs_x13(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %cmp = icmp sgt i32 %x, -1
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %x, i32 %sub
  %cmp1 = icmp slt i32 %cond, 1
  %sub9 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %sub9, i32 %cond
  ret i32 %cond18
}

define i32 @abs_abs_x14(i32 %x) {
; CHECK-LABEL: @abs_abs_x14(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %cmp = icmp sgt i32 %x, 0
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %x, i32 %sub
  %cmp1 = icmp slt i32 %cond, 1
  %sub9 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %sub9, i32 %cond
  ret i32 %cond18
}

define i32 @abs_abs_x15(i32 %x) {
; CHECK-LABEL: @abs_abs_x15(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %cmp = icmp slt i32 %x, 0
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %sub, i32 %x
  %cmp1 = icmp slt i32 %cond, 1
  %sub9 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %sub9, i32 %cond
  ret i32 %cond18
}

define i32 @abs_abs_x16(i32 %x) {
; CHECK-LABEL: @abs_abs_x16(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %cmp = icmp slt i32 %x, 1
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %sub, i32 %x
  %cmp1 = icmp slt i32 %cond, 1
  %sub9 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %sub9, i32 %cond
  ret i32 %cond18
}

; abs(abs(-x)) -> abs(-x) -> abs(x)
define i32 @abs_abs_x17(i32 %x) {
; CHECK-LABEL: @abs_abs_x17(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %sub = sub nsw i32 0, %x
  %cmp = icmp sgt i32 %sub, -1
  %cond = select i1 %cmp, i32 %sub, i32 %x
  %cmp1 = icmp sgt i32 %cond, -1
  %sub16 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %cond, i32 %sub16
  ret i32 %cond18
}

; abs(abs(x - y)) -> abs(x - y)
define i32 @abs_abs_x18(i32 %x, i32 %y) {
; CHECK-LABEL: @abs_abs_x18(
; CHECK-NEXT:    [[A:%.*]] = sub nsw i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[A]], i1 false)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %a = sub nsw i32 %x, %y
  %b = sub nsw i32 %y, %x
  %cmp = icmp sgt i32 %a, -1
  %cond = select i1 %cmp, i32 %a, i32 %b
  %cmp1 = icmp sgt i32 %cond, -1
  %sub16 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %cond, i32 %sub16
  ret i32 %cond18
}

; abs(abs(-x)) -> abs(-x) -> abs(x)
define <2 x i32> @abs_abs_x02_vec(<2 x i32> %x) {
; CHECK-LABEL: @abs_abs_x02_vec(
; CHECK-NEXT:    [[TMP1:%.*]] = call <2 x i32> @llvm.abs.v2i32(<2 x i32> [[X:%.*]], i1 true)
; CHECK-NEXT:    ret <2 x i32> [[TMP1]]
;
  %sub = sub nsw <2 x i32> zeroinitializer, %x
  %cmp = icmp sgt <2 x i32> %sub, <i32 -1, i32 -1>
  %cond = select <2 x i1> %cmp, <2 x i32> %sub, <2 x i32> %x
  %cmp1 = icmp sgt <2 x i32> %cond, <i32 -1, i32 -1>
  %sub16 = sub nsw <2 x i32> zeroinitializer, %cond
  %cond18 = select <2 x i1> %cmp1, <2 x i32> %cond, <2 x i32> %sub16
  ret <2 x i32> %cond18
}

; abs(abs(x - y)) -> abs(x - y)
define <2 x i32> @abs_abs_x03_vec(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @abs_abs_x03_vec(
; CHECK-NEXT:    [[A:%.*]] = sub nsw <2 x i32> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = call <2 x i32> @llvm.abs.v2i32(<2 x i32> [[A]], i1 false)
; CHECK-NEXT:    ret <2 x i32> [[TMP1]]
;
  %a = sub nsw <2 x i32> %x, %y
  %b = sub nsw <2 x i32> %y, %x
  %cmp = icmp sgt <2 x i32> %a, <i32 -1, i32 -1>
  %cond = select <2 x i1> %cmp, <2 x i32> %a, <2 x i32> %b
  %cmp1 = icmp sgt <2 x i32> %cond, <i32 -1, i32 -1>
  %sub16 = sub nsw <2 x i32> zeroinitializer, %cond
  %cond18 = select <2 x i1> %cmp1, <2 x i32> %cond, <2 x i32> %sub16
  ret <2 x i32> %cond18
}

define i32 @nabs_nabs_x01(i32 %x) {
; CHECK-LABEL: @nabs_nabs_x01(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    [[COND:%.*]] = sub nsw i32 0, [[TMP1]]
; CHECK-NEXT:    ret i32 [[COND]]
;
  %cmp = icmp sgt i32 %x, -1
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %sub, i32 %x
  %cmp1 = icmp sgt i32 %cond, -1
  %sub9 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %sub9, i32 %cond
  ret i32 %cond18
}

define i32 @nabs_nabs_x02(i32 %x) {
; CHECK-LABEL: @nabs_nabs_x02(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    [[COND:%.*]] = sub nsw i32 0, [[TMP1]]
; CHECK-NEXT:    ret i32 [[COND]]
;
  %cmp = icmp sgt i32 %x, 0
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %sub, i32 %x
  %cmp1 = icmp sgt i32 %cond, -1
  %sub9 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %sub9, i32 %cond
  ret i32 %cond18
}

define i32 @nabs_nabs_x03(i32 %x) {
; CHECK-LABEL: @nabs_nabs_x03(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    [[COND:%.*]] = sub nsw i32 0, [[TMP1]]
; CHECK-NEXT:    ret i32 [[COND]]
;
  %cmp = icmp slt i32 %x, 0
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %x, i32 %sub
  %cmp1 = icmp sgt i32 %cond, -1
  %sub9 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %sub9, i32 %cond
  ret i32 %cond18
}

define i32 @nabs_nabs_x04(i32 %x) {
; CHECK-LABEL: @nabs_nabs_x04(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    [[COND:%.*]] = sub nsw i32 0, [[TMP1]]
; CHECK-NEXT:    ret i32 [[COND]]
;
  %cmp = icmp slt i32 %x, 1
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %x, i32 %sub
  %cmp1 = icmp sgt i32 %cond, -1
  %sub9 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %sub9, i32 %cond
  ret i32 %cond18
}

define i32 @nabs_nabs_x05(i32 %x) {
; CHECK-LABEL: @nabs_nabs_x05(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    [[COND:%.*]] = sub nsw i32 0, [[TMP1]]
; CHECK-NEXT:    ret i32 [[COND]]
;
  %cmp = icmp sgt i32 %x, -1
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %sub, i32 %x
  %cmp1 = icmp sgt i32 %cond, 0
  %sub9 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %sub9, i32 %cond
  ret i32 %cond18
}

define i32 @nabs_nabs_x06(i32 %x) {
; CHECK-LABEL: @nabs_nabs_x06(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    [[COND:%.*]] = sub nsw i32 0, [[TMP1]]
; CHECK-NEXT:    ret i32 [[COND]]
;
  %cmp = icmp sgt i32 %x, 0
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %sub, i32 %x
  %cmp1 = icmp sgt i32 %cond, 0
  %sub9 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %sub9, i32 %cond
  ret i32 %cond18
}

define i32 @nabs_nabs_x07(i32 %x) {
; CHECK-LABEL: @nabs_nabs_x07(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    [[COND:%.*]] = sub nsw i32 0, [[TMP1]]
; CHECK-NEXT:    ret i32 [[COND]]
;
  %cmp = icmp slt i32 %x, 0
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %x, i32 %sub
  %cmp1 = icmp sgt i32 %cond, 0
  %sub9 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %sub9, i32 %cond
  ret i32 %cond18
}

define i32 @nabs_nabs_x08(i32 %x) {
; CHECK-LABEL: @nabs_nabs_x08(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    [[COND:%.*]] = sub nsw i32 0, [[TMP1]]
; CHECK-NEXT:    ret i32 [[COND]]
;
  %cmp = icmp slt i32 %x, 1
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %x, i32 %sub
  %cmp1 = icmp sgt i32 %cond, 0
  %sub9 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %sub9, i32 %cond
  ret i32 %cond18
}

define i32 @nabs_nabs_x09(i32 %x) {
; CHECK-LABEL: @nabs_nabs_x09(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    [[COND:%.*]] = sub nsw i32 0, [[TMP1]]
; CHECK-NEXT:    ret i32 [[COND]]
;
  %cmp = icmp sgt i32 %x, -1
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %sub, i32 %x
  %cmp1 = icmp slt i32 %cond, 0
  %sub16 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %cond, i32 %sub16
  ret i32 %cond18
}

define i32 @nabs_nabs_x10(i32 %x) {
; CHECK-LABEL: @nabs_nabs_x10(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    [[COND:%.*]] = sub nsw i32 0, [[TMP1]]
; CHECK-NEXT:    ret i32 [[COND]]
;
  %cmp = icmp sgt i32 %x, 0
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %sub, i32 %x
  %cmp1 = icmp slt i32 %cond, 0
  %sub16 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %cond, i32 %sub16
  ret i32 %cond18
}

define i32 @nabs_nabs_x11(i32 %x) {
; CHECK-LABEL: @nabs_nabs_x11(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    [[COND:%.*]] = sub nsw i32 0, [[TMP1]]
; CHECK-NEXT:    ret i32 [[COND]]
;
  %cmp = icmp slt i32 %x, 0
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %x, i32 %sub
  %cmp1 = icmp slt i32 %cond, 0
  %sub16 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %cond, i32 %sub16
  ret i32 %cond18
}

define i32 @nabs_nabs_x12(i32 %x) {
; CHECK-LABEL: @nabs_nabs_x12(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    [[COND:%.*]] = sub nsw i32 0, [[TMP1]]
; CHECK-NEXT:    ret i32 [[COND]]
;
  %cmp = icmp slt i32 %x, 1
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %x, i32 %sub
  %cmp1 = icmp slt i32 %cond, 0
  %sub16 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %cond, i32 %sub16
  ret i32 %cond18
}

define i32 @nabs_nabs_x13(i32 %x) {
; CHECK-LABEL: @nabs_nabs_x13(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    [[COND:%.*]] = sub nsw i32 0, [[TMP1]]
; CHECK-NEXT:    ret i32 [[COND]]
;
  %cmp = icmp sgt i32 %x, -1
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %sub, i32 %x
  %cmp1 = icmp slt i32 %cond, 1
  %sub16 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %cond, i32 %sub16
  ret i32 %cond18
}

define i32 @nabs_nabs_x14(i32 %x) {
; CHECK-LABEL: @nabs_nabs_x14(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    [[COND:%.*]] = sub nsw i32 0, [[TMP1]]
; CHECK-NEXT:    ret i32 [[COND]]
;
  %cmp = icmp sgt i32 %x, 0
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %sub, i32 %x
  %cmp1 = icmp slt i32 %cond, 1
  %sub16 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %cond, i32 %sub16
  ret i32 %cond18
}

define i32 @nabs_nabs_x15(i32 %x) {
; CHECK-LABEL: @nabs_nabs_x15(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    [[COND:%.*]] = sub nsw i32 0, [[TMP1]]
; CHECK-NEXT:    ret i32 [[COND]]
;
  %cmp = icmp slt i32 %x, 0
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %x, i32 %sub
  %cmp1 = icmp slt i32 %cond, 1
  %sub16 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %cond, i32 %sub16
  ret i32 %cond18
}

define i32 @nabs_nabs_x16(i32 %x) {
; CHECK-LABEL: @nabs_nabs_x16(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    [[COND:%.*]] = sub nsw i32 0, [[TMP1]]
; CHECK-NEXT:    ret i32 [[COND]]
;
  %cmp = icmp slt i32 %x, 1
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %x, i32 %sub
  %cmp1 = icmp slt i32 %cond, 1
  %sub16 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %cond, i32 %sub16
  ret i32 %cond18
}

; nabs(nabs(-x)) -> nabs(-x) -> nabs(x)
define i32 @nabs_nabs_x17(i32 %x) {
; CHECK-LABEL: @nabs_nabs_x17(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    [[COND:%.*]] = sub nsw i32 0, [[TMP1]]
; CHECK-NEXT:    ret i32 [[COND]]
;
  %sub = sub nsw i32 0, %x
  %cmp = icmp sgt i32 %sub, -1
  %cond = select i1 %cmp, i32 %x, i32 %sub
  %cmp1 = icmp sgt i32 %cond, -1
  %sub16 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %sub16, i32 %cond
  ret i32 %cond18
}

; nabs(nabs(x - y)) -> nabs(x - y)
define i32 @nabs_nabs_x18(i32 %x, i32 %y) {
; CHECK-LABEL: @nabs_nabs_x18(
; CHECK-NEXT:    [[A:%.*]] = sub nsw i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[A]], i1 false)
; CHECK-NEXT:    [[COND18:%.*]] = sub i32 0, [[TMP1]]
; CHECK-NEXT:    ret i32 [[COND18]]
;
  %a = sub nsw i32 %x, %y
  %b = sub nsw i32 %y, %x
  %cmp = icmp sgt i32 %a, -1
  %cond = select i1 %cmp, i32 %b, i32 %a
  %cmp1 = icmp sgt i32 %cond, -1
  %sub16 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %sub16, i32 %cond
  ret i32 %cond18
}

; nabs(nabs(-x)) -> nabs(-x) -> nabs(x)
define <2 x i32> @nabs_nabs_x01_vec(<2 x i32> %x) {
; CHECK-LABEL: @nabs_nabs_x01_vec(
; CHECK-NEXT:    [[TMP1:%.*]] = call <2 x i32> @llvm.abs.v2i32(<2 x i32> [[X:%.*]], i1 true)
; CHECK-NEXT:    [[COND:%.*]] = sub nsw <2 x i32> zeroinitializer, [[TMP1]]
; CHECK-NEXT:    ret <2 x i32> [[COND]]
;
  %sub = sub nsw <2 x i32> zeroinitializer, %x
  %cmp = icmp sgt <2 x i32> %sub, <i32 -1, i32 -1>
  %cond = select <2 x i1> %cmp, <2 x i32> %x, <2 x i32> %sub
  %cmp1 = icmp sgt <2 x i32> %cond, <i32 -1, i32 -1>
  %sub16 = sub nsw <2 x i32> zeroinitializer, %cond
  %cond18 = select <2 x i1> %cmp1, <2 x i32> %sub16, <2 x i32> %cond
  ret <2 x i32> %cond18
}

; nabs(nabs(x - y)) -> nabs(x - y)
define <2 x i32> @nabs_nabs_x02_vec(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @nabs_nabs_x02_vec(
; CHECK-NEXT:    [[A:%.*]] = sub nsw <2 x i32> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = call <2 x i32> @llvm.abs.v2i32(<2 x i32> [[A]], i1 false)
; CHECK-NEXT:    [[COND18:%.*]] = sub <2 x i32> zeroinitializer, [[TMP1]]
; CHECK-NEXT:    ret <2 x i32> [[COND18]]
;
  %a = sub nsw <2 x i32> %x, %y
  %b = sub nsw <2 x i32> %y, %x
  %cmp = icmp sgt <2 x i32> %a, <i32 -1, i32 -1>
  %cond = select <2 x i1> %cmp, <2 x i32> %b, <2 x i32> %a
  %cmp1 = icmp sgt <2 x i32> %cond, <i32 -1, i32 -1>
  %sub16 = sub nsw <2 x i32> zeroinitializer, %cond
  %cond18 = select <2 x i1> %cmp1, <2 x i32> %sub16, <2 x i32> %cond
  ret <2 x i32> %cond18
}

define i32 @abs_nabs_x01(i32 %x) {
; CHECK-LABEL: @abs_nabs_x01(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %cmp = icmp sgt i32 %x, -1
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %sub, i32 %x
  %cmp1 = icmp sgt i32 %cond, -1
  %sub16 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %cond, i32 %sub16
  ret i32 %cond18
}

define i32 @abs_nabs_x02(i32 %x) {
; CHECK-LABEL: @abs_nabs_x02(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %cmp = icmp sgt i32 %x, 0
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %sub, i32 %x
  %cmp1 = icmp sgt i32 %cond, -1
  %sub16 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %cond, i32 %sub16
  ret i32 %cond18
}

define i32 @abs_nabs_x03(i32 %x) {
; CHECK-LABEL: @abs_nabs_x03(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %cmp = icmp slt i32 %x, 0
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %x, i32 %sub
  %cmp1 = icmp sgt i32 %cond, -1
  %sub16 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %cond, i32 %sub16
  ret i32 %cond18
}

define i32 @abs_nabs_x04(i32 %x) {
; CHECK-LABEL: @abs_nabs_x04(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %cmp = icmp slt i32 %x, 1
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %x, i32 %sub
  %cmp1 = icmp sgt i32 %cond, -1
  %sub16 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %cond, i32 %sub16
  ret i32 %cond18
}

define i32 @abs_nabs_x05(i32 %x) {
; CHECK-LABEL: @abs_nabs_x05(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %cmp = icmp sgt i32 %x, -1
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %sub, i32 %x
  %cmp1 = icmp sgt i32 %cond, 0
  %sub16 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %cond, i32 %sub16
  ret i32 %cond18
}

define i32 @abs_nabs_x06(i32 %x) {
; CHECK-LABEL: @abs_nabs_x06(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %cmp = icmp sgt i32 %x, 0
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %sub, i32 %x
  %cmp1 = icmp sgt i32 %cond, 0
  %sub16 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %cond, i32 %sub16
  ret i32 %cond18
}

define i32 @abs_nabs_x07(i32 %x) {
; CHECK-LABEL: @abs_nabs_x07(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %cmp = icmp slt i32 %x, 0
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %x, i32 %sub
  %cmp1 = icmp sgt i32 %cond, 0
  %sub16 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %cond, i32 %sub16
  ret i32 %cond18
}

define i32 @abs_nabs_x08(i32 %x) {
; CHECK-LABEL: @abs_nabs_x08(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %cmp = icmp slt i32 %x, 1
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %x, i32 %sub
  %cmp1 = icmp sgt i32 %cond, 0
  %sub16 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %cond, i32 %sub16
  ret i32 %cond18
}

define i32 @abs_nabs_x09(i32 %x) {
; CHECK-LABEL: @abs_nabs_x09(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %cmp = icmp sgt i32 %x, -1
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %sub, i32 %x
  %cmp1 = icmp slt i32 %cond, 0
  %sub9 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %sub9, i32 %cond
  ret i32 %cond18
}

define i32 @abs_nabs_x10(i32 %x) {
; CHECK-LABEL: @abs_nabs_x10(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %cmp = icmp sgt i32 %x, 0
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %sub, i32 %x
  %cmp1 = icmp slt i32 %cond, 0
  %sub9 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %sub9, i32 %cond
  ret i32 %cond18
}

define i32 @abs_nabs_x11(i32 %x) {
; CHECK-LABEL: @abs_nabs_x11(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %cmp = icmp slt i32 %x, 0
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %x, i32 %sub
  %cmp1 = icmp slt i32 %cond, 0
  %sub9 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %sub9, i32 %cond
  ret i32 %cond18
}

define i32 @abs_nabs_x12(i32 %x) {
; CHECK-LABEL: @abs_nabs_x12(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %cmp = icmp slt i32 %x, 1
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %x, i32 %sub
  %cmp1 = icmp slt i32 %cond, 0
  %sub9 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %sub9, i32 %cond
  ret i32 %cond18
}

define i32 @abs_nabs_x13(i32 %x) {
; CHECK-LABEL: @abs_nabs_x13(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %cmp = icmp sgt i32 %x, -1
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %sub, i32 %x
  %cmp1 = icmp slt i32 %cond, 1
  %sub9 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %sub9, i32 %cond
  ret i32 %cond18
}

define i32 @abs_nabs_x14(i32 %x) {
; CHECK-LABEL: @abs_nabs_x14(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %cmp = icmp sgt i32 %x, 0
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %sub, i32 %x
  %cmp1 = icmp slt i32 %cond, 1
  %sub9 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %sub9, i32 %cond
  ret i32 %cond18
}

define i32 @abs_nabs_x15(i32 %x) {
; CHECK-LABEL: @abs_nabs_x15(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %cmp = icmp slt i32 %x, 0
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %x, i32 %sub
  %cmp1 = icmp slt i32 %cond, 1
  %sub9 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %sub9, i32 %cond
  ret i32 %cond18
}

define i32 @abs_nabs_x16(i32 %x) {
; CHECK-LABEL: @abs_nabs_x16(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %cmp = icmp slt i32 %x, 1
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %x, i32 %sub
  %cmp1 = icmp slt i32 %cond, 1
  %sub9 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %sub9, i32 %cond
  ret i32 %cond18
}

; abs(nabs(-x)) -> abs(-x) -> abs(x)
define i32 @abs_nabs_x17(i32 %x) {
; CHECK-LABEL: @abs_nabs_x17(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %sub = sub nsw i32 0, %x
  %cmp = icmp sgt i32 %sub, -1
  %cond = select i1 %cmp, i32 %x, i32 %sub
  %cmp1 = icmp sgt i32 %cond, -1
  %sub16 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %cond, i32 %sub16
  ret i32 %cond18
}

; abs(nabs(x - y)) -> abs(x - y)
define i32 @abs_nabs_x18(i32 %x, i32 %y) {
; CHECK-LABEL: @abs_nabs_x18(
; CHECK-NEXT:    [[A:%.*]] = sub nsw i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[A]], i1 false)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %a = sub nsw i32 %x, %y
  %b = sub nsw i32 %y, %x
  %cmp = icmp sgt i32 %a, -1
  %cond = select i1 %cmp, i32 %b, i32 %a
  %cmp1 = icmp sgt i32 %cond, -1
  %sub16 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %cond, i32 %sub16
  ret i32 %cond18
}

; abs(nabs(-x)) -> abs(-x) -> abs(x)
define <2 x i32> @abs_nabs_x01_vec(<2 x i32> %x) {
; CHECK-LABEL: @abs_nabs_x01_vec(
; CHECK-NEXT:    [[TMP1:%.*]] = call <2 x i32> @llvm.abs.v2i32(<2 x i32> [[X:%.*]], i1 true)
; CHECK-NEXT:    ret <2 x i32> [[TMP1]]
;
  %sub = sub nsw <2 x i32> zeroinitializer, %x
  %cmp = icmp sgt <2 x i32> %sub, <i32 -1, i32 -1>
  %cond = select <2 x i1> %cmp, <2 x i32> %x, <2 x i32> %sub
  %cmp1 = icmp sgt <2 x i32> %cond, <i32 -1, i32 -1>
  %sub16 = sub nsw <2 x i32> zeroinitializer, %cond
  %cond18 = select <2 x i1> %cmp1, <2 x i32> %cond, <2 x i32> %sub16
  ret <2 x i32> %cond18
}

; abs(nabs(x - y)) -> abs(x - y)
define <2 x i32> @abs_nabs_x02_vec(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @abs_nabs_x02_vec(
; CHECK-NEXT:    [[A:%.*]] = sub nsw <2 x i32> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = call <2 x i32> @llvm.abs.v2i32(<2 x i32> [[A]], i1 false)
; CHECK-NEXT:    ret <2 x i32> [[TMP1]]
;
  %a = sub nsw <2 x i32> %x, %y
  %b = sub nsw <2 x i32> %y, %x
  %cmp = icmp sgt <2 x i32> %a, <i32 -1, i32 -1>
  %cond = select <2 x i1> %cmp, <2 x i32> %b, <2 x i32> %a
  %cmp1 = icmp sgt <2 x i32> %cond, <i32 -1, i32 -1>
  %sub16 = sub nsw <2 x i32> zeroinitializer, %cond
  %cond18 = select <2 x i1> %cmp1, <2 x i32> %cond, <2 x i32> %sub16
  ret <2 x i32> %cond18
}

define i32 @nabs_abs_x01(i32 %x) {
; CHECK-LABEL: @nabs_abs_x01(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    [[SUB9:%.*]] = sub nsw i32 0, [[TMP1]]
; CHECK-NEXT:    ret i32 [[SUB9]]
;
  %cmp = icmp sgt i32 %x, -1
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %x, i32 %sub
  %cmp1 = icmp sgt i32 %cond, -1
  %sub9 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %sub9, i32 %cond
  ret i32 %cond18
}

define i32 @nabs_abs_x02(i32 %x) {
; CHECK-LABEL: @nabs_abs_x02(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    [[SUB9:%.*]] = sub nsw i32 0, [[TMP1]]
; CHECK-NEXT:    ret i32 [[SUB9]]
;
  %cmp = icmp sgt i32 %x, 0
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %x, i32 %sub
  %cmp1 = icmp sgt i32 %cond, -1
  %sub9 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %sub9, i32 %cond
  ret i32 %cond18
}

define i32 @nabs_abs_x03(i32 %x) {
; CHECK-LABEL: @nabs_abs_x03(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    [[SUB9:%.*]] = sub nsw i32 0, [[TMP1]]
; CHECK-NEXT:    ret i32 [[SUB9]]
;
  %cmp = icmp slt i32 %x, 0
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %sub, i32 %x
  %cmp1 = icmp sgt i32 %cond, -1
  %sub9 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %sub9, i32 %cond
  ret i32 %cond18
}

define i32 @nabs_abs_x04(i32 %x) {
; CHECK-LABEL: @nabs_abs_x04(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    [[SUB9:%.*]] = sub nsw i32 0, [[TMP1]]
; CHECK-NEXT:    ret i32 [[SUB9]]
;
  %cmp = icmp slt i32 %x, 1
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %sub, i32 %x
  %cmp1 = icmp sgt i32 %cond, -1
  %sub9 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %sub9, i32 %cond
  ret i32 %cond18
}

define i32 @nabs_abs_x05(i32 %x) {
; CHECK-LABEL: @nabs_abs_x05(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    [[SUB9:%.*]] = sub nsw i32 0, [[TMP1]]
; CHECK-NEXT:    ret i32 [[SUB9]]
;
  %cmp = icmp sgt i32 %x, -1
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %x, i32 %sub
  %cmp1 = icmp sgt i32 %cond, 0
  %sub9 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %sub9, i32 %cond
  ret i32 %cond18
}

define i32 @nabs_abs_x06(i32 %x) {
; CHECK-LABEL: @nabs_abs_x06(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    [[SUB9:%.*]] = sub nsw i32 0, [[TMP1]]
; CHECK-NEXT:    ret i32 [[SUB9]]
;
  %cmp = icmp sgt i32 %x, 0
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %x, i32 %sub
  %cmp1 = icmp sgt i32 %cond, 0
  %sub9 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %sub9, i32 %cond
  ret i32 %cond18
}

define i32 @nabs_abs_x07(i32 %x) {
; CHECK-LABEL: @nabs_abs_x07(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    [[SUB9:%.*]] = sub nsw i32 0, [[TMP1]]
; CHECK-NEXT:    ret i32 [[SUB9]]
;
  %cmp = icmp slt i32 %x, 0
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %sub, i32 %x
  %cmp1 = icmp sgt i32 %cond, 0
  %sub9 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %sub9, i32 %cond
  ret i32 %cond18
}

define i32 @nabs_abs_x08(i32 %x) {
; CHECK-LABEL: @nabs_abs_x08(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    [[SUB9:%.*]] = sub nsw i32 0, [[TMP1]]
; CHECK-NEXT:    ret i32 [[SUB9]]
;
  %cmp = icmp slt i32 %x, 1
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %sub, i32 %x
  %cmp1 = icmp sgt i32 %cond, 0
  %sub9 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %sub9, i32 %cond
  ret i32 %cond18
}

define i32 @nabs_abs_x09(i32 %x) {
; CHECK-LABEL: @nabs_abs_x09(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    [[SUB16:%.*]] = sub nsw i32 0, [[TMP1]]
; CHECK-NEXT:    ret i32 [[SUB16]]
;
  %cmp = icmp sgt i32 %x, -1
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %x, i32 %sub
  %cmp1 = icmp slt i32 %cond, 0
  %sub16 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %cond, i32 %sub16
  ret i32 %cond18
}

define i32 @nabs_abs_x10(i32 %x) {
; CHECK-LABEL: @nabs_abs_x10(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    [[SUB16:%.*]] = sub nsw i32 0, [[TMP1]]
; CHECK-NEXT:    ret i32 [[SUB16]]
;
  %cmp = icmp sgt i32 %x, 0
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %x, i32 %sub
  %cmp1 = icmp slt i32 %cond, 0
  %sub16 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %cond, i32 %sub16
  ret i32 %cond18
}

define i32 @nabs_abs_x11(i32 %x) {
; CHECK-LABEL: @nabs_abs_x11(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    [[SUB16:%.*]] = sub nsw i32 0, [[TMP1]]
; CHECK-NEXT:    ret i32 [[SUB16]]
;
  %cmp = icmp slt i32 %x, 0
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %sub, i32 %x
  %cmp1 = icmp slt i32 %cond, 0
  %sub16 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %cond, i32 %sub16
  ret i32 %cond18
}

define i32 @nabs_abs_x12(i32 %x) {
; CHECK-LABEL: @nabs_abs_x12(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    [[SUB16:%.*]] = sub nsw i32 0, [[TMP1]]
; CHECK-NEXT:    ret i32 [[SUB16]]
;
  %cmp = icmp slt i32 %x, 1
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %sub, i32 %x
  %cmp1 = icmp slt i32 %cond, 0
  %sub16 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %cond, i32 %sub16
  ret i32 %cond18
}

define i32 @nabs_abs_x13(i32 %x) {
; CHECK-LABEL: @nabs_abs_x13(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    [[SUB16:%.*]] = sub nsw i32 0, [[TMP1]]
; CHECK-NEXT:    ret i32 [[SUB16]]
;
  %cmp = icmp sgt i32 %x, -1
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %x, i32 %sub
  %cmp1 = icmp slt i32 %cond, 1
  %sub16 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %cond, i32 %sub16
  ret i32 %cond18
}

define i32 @nabs_abs_x14(i32 %x) {
; CHECK-LABEL: @nabs_abs_x14(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    [[SUB16:%.*]] = sub nsw i32 0, [[TMP1]]
; CHECK-NEXT:    ret i32 [[SUB16]]
;
  %cmp = icmp sgt i32 %x, 0
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %x, i32 %sub
  %cmp1 = icmp slt i32 %cond, 1
  %sub16 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %cond, i32 %sub16
  ret i32 %cond18
}

define i32 @nabs_abs_x15(i32 %x) {
; CHECK-LABEL: @nabs_abs_x15(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    [[SUB16:%.*]] = sub nsw i32 0, [[TMP1]]
; CHECK-NEXT:    ret i32 [[SUB16]]
;
  %cmp = icmp slt i32 %x, 0
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %sub, i32 %x
  %cmp1 = icmp slt i32 %cond, 1
  %sub16 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %cond, i32 %sub16
  ret i32 %cond18
}

define i32 @nabs_abs_x16(i32 %x) {
; CHECK-LABEL: @nabs_abs_x16(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    [[SUB16:%.*]] = sub nsw i32 0, [[TMP1]]
; CHECK-NEXT:    ret i32 [[SUB16]]
;
  %cmp = icmp slt i32 %x, 1
  %sub = sub nsw i32 0, %x
  %cond = select i1 %cmp, i32 %sub, i32 %x
  %cmp1 = icmp slt i32 %cond, 1
  %sub16 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %cond, i32 %sub16
  ret i32 %cond18
}

; nabs(abs(-x)) -> nabs(-x) -> nabs(x)
define i32 @nabs_abs_x17(i32 %x) {
; CHECK-LABEL: @nabs_abs_x17(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    [[SUB16:%.*]] = sub nsw i32 0, [[TMP1]]
; CHECK-NEXT:    ret i32 [[SUB16]]
;
  %sub = sub nsw i32 0, %x
  %cmp = icmp sgt i32 %sub, -1
  %cond = select i1 %cmp, i32 %sub, i32 %x
  %cmp1 = icmp sgt i32 %cond, -1
  %sub16 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %sub16, i32 %cond
  ret i32 %cond18
}

; nabs(abs(x - y)) -> nabs(x - y)
define i32 @nabs_abs_x18(i32 %x, i32 %y) {
; CHECK-LABEL: @nabs_abs_x18(
; CHECK-NEXT:    [[A:%.*]] = sub nsw i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[A]], i1 false)
; CHECK-NEXT:    [[COND18:%.*]] = sub nsw i32 0, [[TMP1]]
; CHECK-NEXT:    ret i32 [[COND18]]
;
  %a = sub nsw i32 %x, %y
  %b = sub nsw i32 %y, %x
  %cmp = icmp sgt i32 %a, -1
  %cond = select i1 %cmp, i32 %a, i32 %b
  %cmp1 = icmp sgt i32 %cond, -1
  %sub16 = sub nsw i32 0, %cond
  %cond18 = select i1 %cmp1, i32 %sub16, i32 %cond
  ret i32 %cond18
}

; nabs(abs(-x)) -> nabs(-x) -> nabs(x)
define <2 x i32> @nabs_abs_x01_vec(<2 x i32> %x) {
; CHECK-LABEL: @nabs_abs_x01_vec(
; CHECK-NEXT:    [[TMP1:%.*]] = call <2 x i32> @llvm.abs.v2i32(<2 x i32> [[X:%.*]], i1 true)
; CHECK-NEXT:    [[SUB16:%.*]] = sub nsw <2 x i32> zeroinitializer, [[TMP1]]
; CHECK-NEXT:    ret <2 x i32> [[SUB16]]
;
  %sub = sub nsw <2 x i32> zeroinitializer, %x
  %cmp = icmp sgt <2 x i32> %sub, <i32 -1, i32 -1>
  %cond = select <2 x i1> %cmp, <2 x i32> %sub, <2 x i32> %x
  %cmp1 = icmp sgt <2 x i32> %cond, <i32 -1, i32 -1>
  %sub16 = sub nsw <2 x i32> zeroinitializer, %cond
  %cond18 = select <2 x i1> %cmp1, <2 x i32> %sub16, <2 x i32> %cond
  ret <2 x i32> %cond18
}

; nabs(abs(x - y)) -> nabs(x - y)
define <2 x i32> @nabs_abs_x02_vec(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @nabs_abs_x02_vec(
; CHECK-NEXT:    [[A:%.*]] = sub nsw <2 x i32> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = call <2 x i32> @llvm.abs.v2i32(<2 x i32> [[A]], i1 false)
; CHECK-NEXT:    [[COND18:%.*]] = sub nsw <2 x i32> zeroinitializer, [[TMP1]]
; CHECK-NEXT:    ret <2 x i32> [[COND18]]
;
  %a = sub nsw <2 x i32> %x, %y
  %b = sub nsw <2 x i32> %y, %x
  %cmp = icmp sgt <2 x i32> %a, <i32 -1, i32 -1>
  %cond = select <2 x i1> %cmp, <2 x i32> %a, <2 x i32> %b
  %cmp1 = icmp sgt <2 x i32> %cond, <i32 -1, i32 -1>
  %sub16 = sub nsw <2 x i32> zeroinitializer, %cond
  %cond18 = select <2 x i1> %cmp1, <2 x i32> %sub16, <2 x i32> %cond
  ret <2 x i32> %cond18
}
