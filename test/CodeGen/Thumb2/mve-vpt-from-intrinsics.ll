; RUN: opt -instcombine %s | llc -mtriple=thumbv8.1m.main-none-eabi -mattr=+mve --verify-machineinstrs -o - | FileCheck %s

define arm_aapcs_vfpcc <8 x i16> @test_vpt_block(<8 x i16> %v_inactive, <8 x i16> %v1, <8 x i16> %v2, <8 x i16> %v3) {
; CHECK-LABEL: test_vpt_block:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vpt.i16 eq, q1, q2
; CHECK-NEXT:    vaddt.i16 q0, q3, q2
; CHECK-NEXT:    bx lr
entry:
  %0 = icmp eq <8 x i16> %v1, %v2
  %1 = call i32 @llvm.arm.mve.pred.v2i.v8i1(<8 x i1> %0)
  %2 = trunc i32 %1 to i16
  %3 = zext i16 %2 to i32
  %4 = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %3)
  %5 = call <8 x i16> @llvm.arm.mve.add.predicated.v8i16.v8i1(<8 x i16> %v3, <8 x i16> %v2, <8 x i1> %4, <8 x i16> %v_inactive)
  ret <8 x i16> %5
}

declare i32 @llvm.arm.mve.pred.v2i.v8i1(<8 x i1>)
declare <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32)
declare <8 x i16> @llvm.arm.mve.add.predicated.v8i16.v8i1(<8 x i16>, <8 x i16>, <8 x i1>, <8 x i16>)

