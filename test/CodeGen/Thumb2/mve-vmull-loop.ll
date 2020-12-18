; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve -verify-machineinstrs %s -o - | FileCheck %s --check-prefix=CHECK

define arm_aapcs_vfpcc void @test32(i32* noalias nocapture readonly %x, i32* noalias nocapture readonly %y, i32* nocapture %z, i32 %n) {
; CHECK-LABEL: test32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r5, lr}
; CHECK-NEXT:    push {r5, lr}
; CHECK-NEXT:    cmp r3, #1
; CHECK-NEXT:    it lt
; CHECK-NEXT:    poplt {r5, pc}
; CHECK-NEXT:  .LBB0_1: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrw.u32 q1, [r0], #16
; CHECK-NEXT:    vldrw.u32 q2, [r1], #16
; CHECK-NEXT:    subs r3, #4
; CHECK-NEXT:    vmullt.s32 q3, q2, q1
; CHECK-NEXT:    vmov r5, s13
; CHECK-NEXT:    vmov r12, s12
; CHECK-NEXT:    lsrl r12, r5, #31
; CHECK-NEXT:    vmov.32 q0[0], r12
; CHECK-NEXT:    vmov r12, s14
; CHECK-NEXT:    vmov.32 q0[1], r5
; CHECK-NEXT:    vmov r5, s15
; CHECK-NEXT:    lsrl r12, r5, #31
; CHECK-NEXT:    vmullb.s32 q3, q2, q1
; CHECK-NEXT:    vmov.32 q0[2], r12
; CHECK-NEXT:    vmov r12, s12
; CHECK-NEXT:    vmov.32 q0[3], r5
; CHECK-NEXT:    vmov r5, s13
; CHECK-NEXT:    lsrl r12, r5, #31
; CHECK-NEXT:    vmov.32 q1[0], r12
; CHECK-NEXT:    vmov r12, s14
; CHECK-NEXT:    vmov.32 q1[1], r5
; CHECK-NEXT:    vmov r5, s15
; CHECK-NEXT:    lsrl r12, r5, #31
; CHECK-NEXT:    vmov.32 q1[2], r12
; CHECK-NEXT:    vmov.32 q1[3], r5
; CHECK-NEXT:    vmov.f32 s8, s6
; CHECK-NEXT:    vmov.f32 s9, s7
; CHECK-NEXT:    vmov.f32 s6, s0
; CHECK-NEXT:    vmov.f32 s7, s1
; CHECK-NEXT:    vmov.f32 s10, s2
; CHECK-NEXT:    vmov.f32 s5, s6
; CHECK-NEXT:    vmov.f32 s11, s3
; CHECK-NEXT:    vmov.f32 s6, s8
; CHECK-NEXT:    vmov.f32 s7, s10
; CHECK-NEXT:    vstrb.8 q1, [r2], #16
; CHECK-NEXT:    bne .LBB0_1
; CHECK-NEXT:  @ %bb.2: @ %for.cond.cleanup
; CHECK-NEXT:    pop {r5, pc}
entry:
  %0 = and i32 %n, 3
  %cmp = icmp eq i32 %0, 0
  %cmp113 = icmp sgt i32 %n, 0
  br i1 %cmp113, label %vector.body, label %for.cond.cleanup

vector.body:                                      ; preds = %vector.body, %entry
  %index = phi i32 [ %index.next, %vector.body ], [ 0, %entry ]
  %1 = getelementptr inbounds i32, i32* %x, i32 %index
  %2 = bitcast i32* %1 to <4 x i32>*
  %wide.load = load <4 x i32>, <4 x i32>* %2, align 4
  %3 = shufflevector <4 x i32> %wide.load, <4 x i32> %wide.load, <2 x i32> <i32 0, i32 2>
  %4 = shufflevector <4 x i32> %wide.load, <4 x i32> %wide.load, <2 x i32> <i32 1, i32 3>
  %5 = sext <2 x i32> %3 to <2 x i64>
  %6 = sext <2 x i32> %4 to <2 x i64>
  %7 = getelementptr inbounds i32, i32* %y, i32 %index
  %8 = bitcast i32* %7 to <4 x i32>*
  %wide.load15 = load <4 x i32>, <4 x i32>* %8, align 4
  %9 = shufflevector <4 x i32> %wide.load15, <4 x i32> %wide.load15, <2 x i32> <i32 0, i32 2>
  %10 = shufflevector <4 x i32> %wide.load15, <4 x i32> %wide.load15, <2 x i32> <i32 1, i32 3>
  %11 = sext <2 x i32> %9 to <2 x i64>
  %12 = sext <2 x i32> %10 to <2 x i64>
  %13 = mul <2 x i64> %11, %5
  %14 = mul <2 x i64> %12, %6
  %15 = lshr <2 x i64> %13, <i64 31, i64 31>
  %16 = lshr <2 x i64> %14, <i64 31, i64 31>
  %17 = shufflevector <2 x i64> %15, <2 x i64> %16, <4 x i32> <i32 0, i32 2, i32 1, i32 3>
  %18 = trunc <4 x i64> %17 to <4 x i32>
  %19 = getelementptr inbounds i32, i32* %z, i32 %index
  %20 = bitcast i32* %19 to <4 x i32>*
  store <4 x i32> %18, <4 x i32>* %20, align 4
  %index.next = add i32 %index, 4
  %21 = icmp eq i32 %index.next, %n
  br i1 %21, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body, %entry
  ret void
}

define arm_aapcs_vfpcc void @test16(i16* noalias nocapture readonly %x, i16* noalias nocapture readonly %y, i16* nocapture %z, i32 %n) {
; CHECK-LABEL: test16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cmp r3, #1
; CHECK-NEXT:    it lt
; CHECK-NEXT:    bxlt lr
; CHECK-NEXT:  .LBB1_1: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrh.u16 q0, [r0], #16
; CHECK-NEXT:    vldrh.u16 q1, [r1], #16
; CHECK-NEXT:    subs r3, #8
; CHECK-NEXT:    vmullt.s16 q2, q1, q0
; CHECK-NEXT:    vmullb.s16 q0, q1, q0
; CHECK-NEXT:    vshr.u32 q2, q2, #15
; CHECK-NEXT:    vshr.u32 q0, q0, #15
; CHECK-NEXT:    vmovnt.i32 q0, q2
; CHECK-NEXT:    vstrb.8 q0, [r2], #16
; CHECK-NEXT:    bne .LBB1_1
; CHECK-NEXT:  @ %bb.2: @ %for.cond.cleanup
; CHECK-NEXT:    bx lr
entry:
  %0 = and i32 %n, 7
  %cmp = icmp eq i32 %0, 0
  %cmp113 = icmp sgt i32 %n, 0
  br i1 %cmp113, label %vector.body, label %for.cond.cleanup

vector.body:                                      ; preds = %vector.body, %entry
  %index = phi i32 [ %index.next, %vector.body ], [ 0, %entry ]
  %1 = getelementptr inbounds i16, i16* %x, i32 %index
  %2 = bitcast i16* %1 to <8 x i16>*
  %wide.load = load <8 x i16>, <8 x i16>* %2, align 2
  %3 = shufflevector <8 x i16> %wide.load, <8 x i16> %wide.load, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
  %4 = shufflevector <8 x i16> %wide.load, <8 x i16> %wide.load, <4 x i32> <i32 1, i32 3, i32 5, i32 7>
  %5 = sext <4 x i16> %3 to <4 x i32>
  %6 = sext <4 x i16> %4 to <4 x i32>
  %7 = getelementptr inbounds i16, i16* %y, i32 %index
  %8 = bitcast i16* %7 to <8 x i16>*
  %wide.load15 = load <8 x i16>, <8 x i16>* %8, align 2
  %9 = shufflevector <8 x i16> %wide.load15, <8 x i16> %wide.load15, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
  %10 = shufflevector <8 x i16> %wide.load15, <8 x i16> %wide.load15, <4 x i32> <i32 1, i32 3, i32 5, i32 7>
  %11 = sext <4 x i16> %9 to <4 x i32>
  %12 = sext <4 x i16> %10 to <4 x i32>
  %13 = mul <4 x i32> %11, %5
  %14 = mul <4 x i32> %12, %6
  %15 = lshr <4 x i32> %13, <i32 15, i32 15, i32 15, i32 15>
  %16 = lshr <4 x i32> %14, <i32 15, i32 15, i32 15, i32 15>
  %17 = shufflevector <4 x i32> %15, <4 x i32> %16, <8 x i32> <i32 0, i32 4, i32 1, i32 5, i32 2, i32 6, i32 3, i32 7>
  %18 = trunc <8 x i32> %17 to <8 x i16>
  %19 = getelementptr inbounds i16, i16* %z, i32 %index
  %20 = bitcast i16* %19 to <8 x i16>*
  store <8 x i16> %18, <8 x i16>* %20, align 2
  %index.next = add i32 %index, 8
  %21 = icmp eq i32 %index.next, %n
  br i1 %21, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body, %entry
  ret void
}

define arm_aapcs_vfpcc void @test8(i8* noalias nocapture readonly %x, i8* noalias nocapture readonly %y, i8* nocapture %z, i32 %n) {
; CHECK-LABEL: test8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cmp r3, #1
; CHECK-NEXT:    it lt
; CHECK-NEXT:    bxlt lr
; CHECK-NEXT:  .LBB2_1: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrb.u8 q0, [r0], #16
; CHECK-NEXT:    vldrb.u8 q1, [r1], #16
; CHECK-NEXT:    subs r3, #16
; CHECK-NEXT:    vmullt.u8 q2, q1, q0
; CHECK-NEXT:    vmullb.u8 q0, q1, q0
; CHECK-NEXT:    vshr.u16 q2, q2, #7
; CHECK-NEXT:    vshr.u16 q0, q0, #7
; CHECK-NEXT:    vmovnt.i16 q0, q2
; CHECK-NEXT:    vstrb.8 q0, [r2], #16
; CHECK-NEXT:    bne .LBB2_1
; CHECK-NEXT:  @ %bb.2: @ %for.cond.cleanup
; CHECK-NEXT:    bx lr
entry:
  %0 = and i32 %n, 15
  %cmp = icmp eq i32 %0, 0
  %cmp117 = icmp sgt i32 %n, 0
  br i1 %cmp117, label %vector.body, label %for.cond.cleanup

vector.body:                                      ; preds = %vector.body, %entry
  %index = phi i32 [ %index.next, %vector.body ], [ 0, %entry ]
  %1 = getelementptr inbounds i8, i8* %x, i32 %index
  %2 = bitcast i8* %1 to <16 x i8>*
  %wide.load = load <16 x i8>, <16 x i8>* %2, align 1
  %3 = shufflevector <16 x i8> %wide.load, <16 x i8> %wide.load, <8 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14>
  %4 = shufflevector <16 x i8> %wide.load, <16 x i8> %wide.load, <8 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15>
  %5 = zext <8 x i8> %3 to <8 x i16>
  %6 = zext <8 x i8> %4 to <8 x i16>
  %7 = getelementptr inbounds i8, i8* %y, i32 %index
  %8 = bitcast i8* %7 to <16 x i8>*
  %wide.load19 = load <16 x i8>, <16 x i8>* %8, align 1
  %9 = shufflevector <16 x i8> %wide.load19, <16 x i8> %wide.load19, <8 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14>
  %10 = shufflevector <16 x i8> %wide.load19, <16 x i8> %wide.load19, <8 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15>
  %11 = zext <8 x i8> %9 to <8 x i16>
  %12 = zext <8 x i8> %10 to <8 x i16>
  %13 = mul <8 x i16> %11, %5
  %14 = mul <8 x i16> %12, %6
  %15 = lshr <8 x i16> %13, <i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7>
  %16 = lshr <8 x i16> %14, <i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7>
  %17 = shufflevector <8 x i16> %15, <8 x i16> %16, <16 x i32> <i32 0, i32 8, i32 1, i32 9, i32 2, i32 10, i32 3, i32 11, i32 4, i32 12, i32 5, i32 13, i32 6, i32 14, i32 7, i32 15>
  %18 = trunc <16 x i16> %17 to <16 x i8>
  %19 = getelementptr inbounds i8, i8* %z, i32 %index
  %20 = bitcast i8* %19 to <16 x i8>*
  store <16 x i8> %18, <16 x i8>* %20, align 1
  %index.next = add i32 %index, 16
  %21 = icmp eq i32 %index.next, %n
  br i1 %21, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body, %entry
  ret void
}
