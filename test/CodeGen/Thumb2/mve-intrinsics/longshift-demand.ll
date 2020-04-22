; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve -verify-machineinstrs %s -o - | FileCheck %s

declare {i32, i32} @llvm.arm.mve.asrl(i32, i32, i32)
declare {i32, i32} @llvm.arm.mve.lsll(i32, i32, i32)

define i32 @ashr_demand_bottom3(i64 %X) {
; CHECK-LABEL: ashr_demand_bottom3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    asrl r0, r1, #3
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.asrl(i32 %2, i32 %1, i32 3)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %shr = or i64 %6, %8
  %t = trunc i64 %shr to i32
  ret i32 %t
}

define i32 @lsll_demand_bottom3(i64 %X) {
; CHECK-LABEL: lsll_demand_bottom3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    lsll r0, r1, #3
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.lsll(i32 %2, i32 %1, i32 3)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %shr = or i64 %6, %8
  %t = trunc i64 %shr to i32
  ret i32 %t
}

define i32 @ashr_demand_bottomm3(i64 %X) {
; CHECK-LABEL: ashr_demand_bottomm3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    lsll r0, r1, #3
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.asrl(i32 %2, i32 %1, i32 -3)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %shr = or i64 %6, %8
  %t = trunc i64 %shr to i32
  ret i32 %t
}

define i32 @lsll_demand_bottomm3(i64 %X) {
; CHECK-LABEL: lsll_demand_bottomm3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    lsrl r0, r1, #3
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.lsll(i32 %2, i32 %1, i32 -3)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %shr = or i64 %6, %8
  %t = trunc i64 %shr to i32
  ret i32 %t
}


define i32 @ashr_demand_bottom31(i64 %X) {
; CHECK-LABEL: ashr_demand_bottom31:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    asrl r0, r1, #31
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.asrl(i32 %2, i32 %1, i32 31)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %shr = or i64 %6, %8
  %t = trunc i64 %shr to i32
  ret i32 %t
}

define i32 @lsll_demand_bottom31(i64 %X) {
; CHECK-LABEL: lsll_demand_bottom31:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    lsll r0, r1, #31
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.lsll(i32 %2, i32 %1, i32 31)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %shr = or i64 %6, %8
  %t = trunc i64 %shr to i32
  ret i32 %t
}

define i32 @ashr_demand_bottomm31(i64 %X) {
; CHECK-LABEL: ashr_demand_bottomm31:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    lsll r0, r1, #31
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.asrl(i32 %2, i32 %1, i32 -31)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %shr = or i64 %6, %8
  %t = trunc i64 %shr to i32
  ret i32 %t
}

define i32 @lsll_demand_bottomm31(i64 %X) {
; CHECK-LABEL: lsll_demand_bottomm31:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    lsrl r0, r1, #31
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.lsll(i32 %2, i32 %1, i32 -31)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %shr = or i64 %6, %8
  %t = trunc i64 %shr to i32
  ret i32 %t
}


define i32 @ashr_demand_bottom32(i64 %X) {
; CHECK-LABEL: ashr_demand_bottom32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    asrl r0, r1, #32
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.asrl(i32 %2, i32 %1, i32 32)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %shr = or i64 %6, %8
  %t = trunc i64 %shr to i32
  ret i32 %t
}

define i32 @lsll_demand_bottom32(i64 %X) {
; CHECK-LABEL: lsll_demand_bottom32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    lsll r0, r1, #32
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.lsll(i32 %2, i32 %1, i32 32)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %shr = or i64 %6, %8
  %t = trunc i64 %shr to i32
  ret i32 %t
}

define i32 @ashr_demand_bottomm32(i64 %X) {
; CHECK-LABEL: ashr_demand_bottomm32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    lsll r0, r1, #32
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.asrl(i32 %2, i32 %1, i32 -32)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %shr = or i64 %6, %8
  %t = trunc i64 %shr to i32
  ret i32 %t
}

define i32 @lsll_demand_bottomm32(i64 %X) {
; CHECK-LABEL: lsll_demand_bottomm32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    lsrl r0, r1, #32
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.lsll(i32 %2, i32 %1, i32 -32)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %shr = or i64 %6, %8
  %t = trunc i64 %shr to i32
  ret i32 %t
}


define i32 @ashr_demand_bottom44(i64 %X) {
; CHECK-LABEL: ashr_demand_bottom44:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movs r2, #44
; CHECK-NEXT:    asrl r0, r1, r2
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.asrl(i32 %2, i32 %1, i32 44)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %shr = or i64 %6, %8
  %t = trunc i64 %shr to i32
  ret i32 %t
}

define i32 @lsll_demand_bottom44(i64 %X) {
; CHECK-LABEL: lsll_demand_bottom44:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movs r2, #44
; CHECK-NEXT:    lsll r0, r1, r2
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.lsll(i32 %2, i32 %1, i32 44)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %shr = or i64 %6, %8
  %t = trunc i64 %shr to i32
  ret i32 %t
}

define i32 @ashr_demand_bottomm44(i64 %X) {
; CHECK-LABEL: ashr_demand_bottomm44:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    mvn r2, #43
; CHECK-NEXT:    asrl r0, r1, r2
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.asrl(i32 %2, i32 %1, i32 -44)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %shr = or i64 %6, %8
  %t = trunc i64 %shr to i32
  ret i32 %t
}

define i32 @lsll_demand_bottomm44(i64 %X) {
; CHECK-LABEL: lsll_demand_bottomm44:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    mvn r2, #43
; CHECK-NEXT:    lsll r0, r1, r2
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.lsll(i32 %2, i32 %1, i32 -44)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %shr = or i64 %6, %8
  %t = trunc i64 %shr to i32
  ret i32 %t
}







define i32 @ashr_demand_top3(i64 %X) {
; CHECK-LABEL: ashr_demand_top3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    asrl r0, r1, #3
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.asrl(i32 %2, i32 %1, i32 3)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %shr = or i64 %6, %8
  %sm = lshr i64 %shr, 32
  %t = trunc i64 %sm to i32
  ret i32 %t
}

define i32 @lsll_demand_top3(i64 %X) {
; CHECK-LABEL: lsll_demand_top3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    lsll r0, r1, #3
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.lsll(i32 %2, i32 %1, i32 3)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %shr = or i64 %6, %8
  %sm = lshr i64 %shr, 32
  %t = trunc i64 %sm to i32
  ret i32 %t
}

define i32 @ashr_demand_topm3(i64 %X) {
; CHECK-LABEL: ashr_demand_topm3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    lsll r0, r1, #3
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.asrl(i32 %2, i32 %1, i32 -3)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %shr = or i64 %6, %8
  %sm = lshr i64 %shr, 32
  %t = trunc i64 %sm to i32
  ret i32 %t
}

define i32 @lsll_demand_topm3(i64 %X) {
; CHECK-LABEL: lsll_demand_topm3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    lsrl r0, r1, #3
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.lsll(i32 %2, i32 %1, i32 -3)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %shr = or i64 %6, %8
  %sm = lshr i64 %shr, 32
  %t = trunc i64 %sm to i32
  ret i32 %t
}


define i32 @ashr_demand_top31(i64 %X) {
; CHECK-LABEL: ashr_demand_top31:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    asrl r0, r1, #31
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.asrl(i32 %2, i32 %1, i32 31)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %shr = or i64 %6, %8
  %sm = lshr i64 %shr, 32
  %t = trunc i64 %sm to i32
  ret i32 %t
}

define i32 @lsll_demand_top31(i64 %X) {
; CHECK-LABEL: lsll_demand_top31:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    lsll r0, r1, #31
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.lsll(i32 %2, i32 %1, i32 31)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %shr = or i64 %6, %8
  %sm = lshr i64 %shr, 32
  %t = trunc i64 %sm to i32
  ret i32 %t
}

define i32 @ashr_demand_topm31(i64 %X) {
; CHECK-LABEL: ashr_demand_topm31:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    lsll r0, r1, #31
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.asrl(i32 %2, i32 %1, i32 -31)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %shr = or i64 %6, %8
  %sm = lshr i64 %shr, 32
  %t = trunc i64 %sm to i32
  ret i32 %t
}

define i32 @lsll_demand_topm31(i64 %X) {
; CHECK-LABEL: lsll_demand_topm31:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    lsrl r0, r1, #31
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.lsll(i32 %2, i32 %1, i32 -31)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %shr = or i64 %6, %8
  %sm = lshr i64 %shr, 32
  %t = trunc i64 %sm to i32
  ret i32 %t
}


define i32 @ashr_demand_top32(i64 %X) {
; CHECK-LABEL: ashr_demand_top32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    asrl r0, r1, #32
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.asrl(i32 %2, i32 %1, i32 32)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %shr = or i64 %6, %8
  %sm = lshr i64 %shr, 32
  %t = trunc i64 %sm to i32
  ret i32 %t
}

define i32 @lsll_demand_top32(i64 %X) {
; CHECK-LABEL: lsll_demand_top32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    lsll r0, r1, #32
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.lsll(i32 %2, i32 %1, i32 32)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %shr = or i64 %6, %8
  %sm = lshr i64 %shr, 32
  %t = trunc i64 %sm to i32
  ret i32 %t
}

define i32 @ashr_demand_topm32(i64 %X) {
; CHECK-LABEL: ashr_demand_topm32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    lsll r0, r1, #32
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.asrl(i32 %2, i32 %1, i32 -32)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %shr = or i64 %6, %8
  %sm = lshr i64 %shr, 32
  %t = trunc i64 %sm to i32
  ret i32 %t
}

define i32 @lsll_demand_topm32(i64 %X) {
; CHECK-LABEL: lsll_demand_topm32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    lsrl r0, r1, #32
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.lsll(i32 %2, i32 %1, i32 -32)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %shr = or i64 %6, %8
  %sm = lshr i64 %shr, 32
  %t = trunc i64 %sm to i32
  ret i32 %t
}


define i32 @ashr_demand_top44(i64 %X) {
; CHECK-LABEL: ashr_demand_top44:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movs r2, #44
; CHECK-NEXT:    asrl r0, r1, r2
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.asrl(i32 %2, i32 %1, i32 44)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %shr = or i64 %6, %8
  %sm = lshr i64 %shr, 32
  %t = trunc i64 %sm to i32
  ret i32 %t
}

define i32 @lsll_demand_top44(i64 %X) {
; CHECK-LABEL: lsll_demand_top44:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movs r2, #44
; CHECK-NEXT:    lsll r0, r1, r2
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.lsll(i32 %2, i32 %1, i32 44)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %shr = or i64 %6, %8
  %sm = lshr i64 %shr, 32
  %t = trunc i64 %sm to i32
  ret i32 %t
}

define i32 @ashr_demand_topm44(i64 %X) {
; CHECK-LABEL: ashr_demand_topm44:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    mvn r2, #43
; CHECK-NEXT:    asrl r0, r1, r2
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.asrl(i32 %2, i32 %1, i32 -44)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %shr = or i64 %6, %8
  %sm = lshr i64 %shr, 32
  %t = trunc i64 %sm to i32
  ret i32 %t
}

define i32 @lsll_demand_topm44(i64 %X) {
; CHECK-LABEL: lsll_demand_topm44:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    mvn r2, #43
; CHECK-NEXT:    lsll r0, r1, r2
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.lsll(i32 %2, i32 %1, i32 -44)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %shr = or i64 %6, %8
  %sm = lshr i64 %shr, 32
  %t = trunc i64 %sm to i32
  ret i32 %t
}



define i32 @ashr_demand_bottommask3(i64 %X) {
; CHECK-LABEL: ashr_demand_bottommask3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    asrl r0, r1, #3
; CHECK-NEXT:    bic r0, r0, #1
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.asrl(i32 %2, i32 %1, i32 3)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %shr = or i64 %6, %8
  %t = trunc i64 %shr to i32
  %a = and i32 %t, -2
  ret i32 %a
}

define i32 @lsll_demand_bottommask3(i64 %X) {
; CHECK-LABEL: lsll_demand_bottommask3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    lsll r0, r1, #3
; CHECK-NEXT:    bic r0, r0, #1
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.lsll(i32 %2, i32 %1, i32 3)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %shr = or i64 %6, %8
  %t = trunc i64 %shr to i32
  %a = and i32 %t, -2
  ret i32 %a
}

define i32 @ashr_demand_bottommaskm3(i64 %X) {
; CHECK-LABEL: ashr_demand_bottommaskm3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    lsll r0, r1, #3
; CHECK-NEXT:    bic r0, r0, #1
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.asrl(i32 %2, i32 %1, i32 -3)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %shr = or i64 %6, %8
  %t = trunc i64 %shr to i32
  %a = and i32 %t, -2
  ret i32 %a
}

define i32 @lsll_demand_bottommaskm3(i64 %X) {
; CHECK-LABEL: lsll_demand_bottommaskm3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    lsrl r0, r1, #3
; CHECK-NEXT:    bic r0, r0, #1
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.lsll(i32 %2, i32 %1, i32 -3)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %shr = or i64 %6, %8
  %t = trunc i64 %shr to i32
  %a = and i32 %t, -2
  ret i32 %a
}


define i32 @ashr_demand_bottommask32(i64 %X) {
; CHECK-LABEL: ashr_demand_bottommask32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    asrl r0, r1, #32
; CHECK-NEXT:    bic r0, r0, #1
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.asrl(i32 %2, i32 %1, i32 32)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %shr = or i64 %6, %8
  %t = trunc i64 %shr to i32
  %a = and i32 %t, -2
  ret i32 %a
}

define i32 @lsll_demand_bottommask32(i64 %X) {
; CHECK-LABEL: lsll_demand_bottommask32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    lsll r0, r1, #32
; CHECK-NEXT:    bic r0, r0, #1
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.lsll(i32 %2, i32 %1, i32 32)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %shr = or i64 %6, %8
  %t = trunc i64 %shr to i32
  %a = and i32 %t, -2
  ret i32 %a
}

define i32 @ashr_demand_bottommaskm32(i64 %X) {
; CHECK-LABEL: ashr_demand_bottommaskm32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    lsll r0, r1, #32
; CHECK-NEXT:    bic r0, r0, #1
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.asrl(i32 %2, i32 %1, i32 -32)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %shr = or i64 %6, %8
  %t = trunc i64 %shr to i32
  %a = and i32 %t, -2
  ret i32 %a
}

define i32 @lsll_demand_bottommaskm32(i64 %X) {
; CHECK-LABEL: lsll_demand_bottommaskm32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    lsrl r0, r1, #32
; CHECK-NEXT:    bic r0, r0, #1
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.lsll(i32 %2, i32 %1, i32 -32)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %shr = or i64 %6, %8
  %t = trunc i64 %shr to i32
  %a = and i32 %t, -2
  ret i32 %a
}
