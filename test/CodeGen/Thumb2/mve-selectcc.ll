; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve.fp -verify-machineinstrs %s -o - | FileCheck %s --check-prefix=CHECK

define arm_aapcs_vfpcc <4 x i32> @test_v4i32(i32 %x, <4 x i32> %s0, <4 x i32> %s1) {
; CHECK-LABEL: test_v4i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:    it eq
; CHECK-NEXT:    bxeq lr
; CHECK-NEXT:  .LBB0_1: @ %select.false
; CHECK-NEXT:    vmov q0, q1
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq i32 %x, 0
  %s = select i1 %c,  <4 x i32> %s0, <4 x i32> %s1
  ret <4 x i32> %s
}

define arm_aapcs_vfpcc <8 x i16> @test_v8i16(i32 %x, <8 x i16> %s0, <8 x i16> %s1) {
; CHECK-LABEL: test_v8i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:    it eq
; CHECK-NEXT:    bxeq lr
; CHECK-NEXT:  .LBB1_1: @ %select.false
; CHECK-NEXT:    vmov q0, q1
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq i32 %x, 0
  %s = select i1 %c,  <8 x i16> %s0, <8 x i16> %s1
  ret <8 x i16> %s
}

define arm_aapcs_vfpcc <16 x i8> @test_v16i8(i32 %x, <16 x i8> %s0, <16 x i8> %s1) {
; CHECK-LABEL: test_v16i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:    it eq
; CHECK-NEXT:    bxeq lr
; CHECK-NEXT:  .LBB2_1: @ %select.false
; CHECK-NEXT:    vmov q0, q1
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq i32 %x, 0
  %s = select i1 %c,  <16 x i8> %s0, <16 x i8> %s1
  ret <16 x i8> %s
}

define arm_aapcs_vfpcc <2 x i64> @test_v2i64(i32 %x, <2 x i64> %s0, <2 x i64> %s1) {
; CHECK-LABEL: test_v2i64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:    it eq
; CHECK-NEXT:    bxeq lr
; CHECK-NEXT:  .LBB3_1: @ %select.false
; CHECK-NEXT:    vmov q0, q1
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq i32 %x, 0
  %s = select i1 %c,  <2 x i64> %s0, <2 x i64> %s1
  ret <2 x i64> %s
}

define arm_aapcs_vfpcc <4 x float> @test_v4float(i32 %x, <4 x float> %s0, <4 x float> %s1) {
; CHECK-LABEL: test_v4float:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:    it eq
; CHECK-NEXT:    bxeq lr
; CHECK-NEXT:  .LBB4_1: @ %select.false
; CHECK-NEXT:    vmov q0, q1
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq i32 %x, 0
  %s = select i1 %c,  <4 x float> %s0, <4 x float> %s1
  ret <4 x float> %s
}

define arm_aapcs_vfpcc <8 x half> @test_v8half(i32 %x, <8 x half> %s0, <8 x half> %s1) {
; CHECK-LABEL: test_v8half:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:    it eq
; CHECK-NEXT:    bxeq lr
; CHECK-NEXT:  .LBB5_1: @ %select.false
; CHECK-NEXT:    vmov q0, q1
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq i32 %x, 0
  %s = select i1 %c,  <8 x half> %s0, <8 x half> %s1
  ret <8 x half> %s
}

define arm_aapcs_vfpcc <2 x double> @test_v2double(i32 %x, <2 x double> %s0, <2 x double> %s1) {
; CHECK-LABEL: test_v2double:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:    it eq
; CHECK-NEXT:    bxeq lr
; CHECK-NEXT:  .LBB6_1: @ %select.false
; CHECK-NEXT:    vmov q0, q1
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq i32 %x, 0
  %s = select i1 %c,  <2 x double> %s0, <2 x double> %s1
  ret <2 x double> %s
}

define arm_aapcs_vfpcc <4 x i32> @minsize_v4i32(i32 %x, <4 x i32> %s0, <4 x i32> %s1) minsize {
; CHECK-LABEL: minsize_v4i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cbz r0, .LBB7_2
; CHECK-NEXT:  @ %bb.1: @ %select.false
; CHECK-NEXT:    vmov q0, q1
; CHECK-NEXT:  .LBB7_2: @ %select.end
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq i32 %x, 0
  %s = select i1 %c,  <4 x i32> %s0, <4 x i32> %s1
  ret <4 x i32> %s
}

define arm_aapcs_vfpcc <8 x i16> @minsize_v8i16(i32 %x, <8 x i16> %s0, <8 x i16> %s1) minsize {
; CHECK-LABEL: minsize_v8i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cbz r0, .LBB8_2
; CHECK-NEXT:  @ %bb.1: @ %select.false
; CHECK-NEXT:    vmov q0, q1
; CHECK-NEXT:  .LBB8_2: @ %select.end
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq i32 %x, 0
  %s = select i1 %c,  <8 x i16> %s0, <8 x i16> %s1
  ret <8 x i16> %s
}

define arm_aapcs_vfpcc <16 x i8> @minsize_v16i8(i32 %x, <16 x i8> %s0, <16 x i8> %s1) minsize {
; CHECK-LABEL: minsize_v16i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cbz r0, .LBB9_2
; CHECK-NEXT:  @ %bb.1: @ %select.false
; CHECK-NEXT:    vmov q0, q1
; CHECK-NEXT:  .LBB9_2: @ %select.end
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq i32 %x, 0
  %s = select i1 %c,  <16 x i8> %s0, <16 x i8> %s1
  ret <16 x i8> %s
}

define arm_aapcs_vfpcc <2 x i64> @minsize_v2i64(i32 %x, <2 x i64> %s0, <2 x i64> %s1) minsize {
; CHECK-LABEL: minsize_v2i64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cbz r0, .LBB10_2
; CHECK-NEXT:  @ %bb.1: @ %select.false
; CHECK-NEXT:    vmov q0, q1
; CHECK-NEXT:  .LBB10_2: @ %select.end
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq i32 %x, 0
  %s = select i1 %c,  <2 x i64> %s0, <2 x i64> %s1
  ret <2 x i64> %s
}

define arm_aapcs_vfpcc <4 x float> @minsize_v4float(i32 %x, <4 x float> %s0, <4 x float> %s1) minsize {
; CHECK-LABEL: minsize_v4float:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cbz r0, .LBB11_2
; CHECK-NEXT:  @ %bb.1: @ %select.false
; CHECK-NEXT:    vmov q0, q1
; CHECK-NEXT:  .LBB11_2: @ %select.end
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq i32 %x, 0
  %s = select i1 %c,  <4 x float> %s0, <4 x float> %s1
  ret <4 x float> %s
}

define arm_aapcs_vfpcc <8 x half> @minsize_v8half(i32 %x, <8 x half> %s0, <8 x half> %s1) minsize {
; CHECK-LABEL: minsize_v8half:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cbz r0, .LBB12_2
; CHECK-NEXT:  @ %bb.1: @ %select.false
; CHECK-NEXT:    vmov q0, q1
; CHECK-NEXT:  .LBB12_2: @ %select.end
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq i32 %x, 0
  %s = select i1 %c,  <8 x half> %s0, <8 x half> %s1
  ret <8 x half> %s
}

define arm_aapcs_vfpcc <2 x double> @minsize_v2double(i32 %x, <2 x double> %s0, <2 x double> %s1) minsize {
; CHECK-LABEL: minsize_v2double:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cbz r0, .LBB13_2
; CHECK-NEXT:  @ %bb.1: @ %select.false
; CHECK-NEXT:    vmov q0, q1
; CHECK-NEXT:  .LBB13_2: @ %select.end
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq i32 %x, 0
  %s = select i1 %c,  <2 x double> %s0, <2 x double> %s1
  ret <2 x double> %s
}

define i32 @e() {
; CHECK-LABEL: e:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    adr r0, .LCPI14_0
; CHECK-NEXT:    vmov.i32 q1, #0x4
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    movs r0, #0
; CHECK-NEXT:    vmov q2, q0
; CHECK-NEXT:  .LBB14_1: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    adds r0, #4
; CHECK-NEXT:    vadd.i32 q2, q2, q1
; CHECK-NEXT:    cmp r0, #8
; CHECK-NEXT:    cset r1, eq
; CHECK-NEXT:    cmp r1, #0
; CHECK-NEXT:    csetm r1, ne
; CHECK-NEXT:    subs.w r2, r0, #8
; CHECK-NEXT:    vdup.32 q3, r1
; CHECK-NEXT:    csel r0, r0, r2, ne
; CHECK-NEXT:    vbic q2, q2, q3
; CHECK-NEXT:    vand q3, q3, q0
; CHECK-NEXT:    vorr q2, q3, q2
; CHECK-NEXT:    b .LBB14_1
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  @ %bb.2:
; CHECK-NEXT:  .LCPI14_0:
; CHECK-NEXT:    .long 0 @ 0x0
; CHECK-NEXT:    .long 1 @ 0x1
; CHECK-NEXT:    .long 2 @ 0x2
; CHECK-NEXT:    .long 3 @ 0x3
entry:
  br label %vector.body

vector.body:                                      ; preds = %pred.store.continue73, %entry
  %index = phi i32 [ 0, %entry ], [ %spec.select, %pred.store.continue73 ]
  %vec.ind = phi <4 x i32> [ <i32 0, i32 1, i32 2, i32 3>, %entry ], [ %spec.select74, %pred.store.continue73 ]
  %l3 = icmp ult <4 x i32> %vec.ind, <i32 5, i32 5, i32 5, i32 5>
  %l4 = extractelement <4 x i1> %l3, i32 0
  br label %pred.store.continue73

pred.store.continue73:                            ; preds = %pred.store.if72, %pred.store.continue71
  %index.next = add i32 %index, 4
  %vec.ind.next = add <4 x i32> %vec.ind, <i32 4, i32 4, i32 4, i32 4>
  %l60 = icmp eq i32 %index.next, 8
  %spec.select = select i1 %l60, i32 0, i32 %index.next
  %spec.select74 = select i1 %l60, <4 x i32> <i32 0, i32 1, i32 2, i32 3>, <4 x i32> %vec.ind.next
  br label %vector.body
}

