; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve -verify-machineinstrs %s -o - | FileCheck %s

define arm_aapcs_vfpcc void @reg(<8 x i16> %acc0, <8 x i16> %acc1, i32* nocapture %px, i16 signext %p0) {
; CHECK-LABEL: reg:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r6, r7, lr}
; CHECK-NEXT:    push {r4, r6, r7, lr}
; CHECK-NEXT:    movw r1, #52428
; CHECK-NEXT:    vmsr p0, r1
; CHECK-NEXT:    vpstete
; CHECK-NEXT:    vaddvt.s16 r12, q1
; CHECK-NEXT:    vaddve.s16 r2, q1
; CHECK-NEXT:    vaddvt.s16 r4, q0
; CHECK-NEXT:    vaddve.s16 r6, q0
; CHECK-NEXT:    strd r6, r4, [r0]
; CHECK-NEXT:    strd r2, r12, [r0, #8]
; CHECK-NEXT:    pop {r4, r6, r7, pc}
entry:
  %0 = tail call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 13107)
  %1 = tail call i32 @llvm.arm.mve.addv.predicated.v8i16.v8i1(<8 x i16> %acc0, i32 0, <8 x i1> %0)
  %2 = tail call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 52428)
  %3 = tail call i32 @llvm.arm.mve.addv.predicated.v8i16.v8i1(<8 x i16> %acc0, i32 0, <8 x i1> %2)
  %4 = tail call i32 @llvm.arm.mve.addv.predicated.v8i16.v8i1(<8 x i16> %acc1, i32 0, <8 x i1> %0)
  %5 = tail call i32 @llvm.arm.mve.addv.predicated.v8i16.v8i1(<8 x i16> %acc1, i32 0, <8 x i1> %2)
  store i32 %1, i32* %px, align 4
  %arrayidx1 = getelementptr inbounds i32, i32* %px, i32 1
  store i32 %3, i32* %arrayidx1, align 4
  %arrayidx2 = getelementptr inbounds i32, i32* %px, i32 2
  store i32 %4, i32* %arrayidx2, align 4
  %arrayidx3 = getelementptr inbounds i32, i32* %px, i32 3
  store i32 %5, i32* %arrayidx3, align 4
  ret void
}


define arm_aapcs_vfpcc void @const(<8 x i16> %acc0, <8 x i16> %acc1, i32* nocapture %px, i16 signext %p0) {
; CHECK-LABEL: const:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r6, r7, lr}
; CHECK-NEXT:    push {r4, r6, r7, lr}
; CHECK-NEXT:    vmsr p0, r1
; CHECK-NEXT:    vpsttee
; CHECK-NEXT:    vaddvt.s16 r12, q1
; CHECK-NEXT:    vaddvt.s16 r2, q0
; CHECK-NEXT:    vaddve.s16 r4, q1
; CHECK-NEXT:    vaddve.s16 r6, q0
; CHECK-NEXT:    stm.w r0, {r2, r6, r12}
; CHECK-NEXT:    str r4, [r0, #12]
; CHECK-NEXT:    pop {r4, r6, r7, pc}
entry:
  %0 = zext i16 %p0 to i32
  %1 = tail call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %0)
  %2 = tail call i32 @llvm.arm.mve.addv.predicated.v8i16.v8i1(<8 x i16> %acc0, i32 0, <8 x i1> %1)
  %3 = xor i16 %p0, -1
  %4 = zext i16 %3 to i32
  %5 = tail call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %4)
  %6 = tail call i32 @llvm.arm.mve.addv.predicated.v8i16.v8i1(<8 x i16> %acc0, i32 0, <8 x i1> %5)
  %7 = tail call i32 @llvm.arm.mve.addv.predicated.v8i16.v8i1(<8 x i16> %acc1, i32 0, <8 x i1> %1)
  %8 = tail call i32 @llvm.arm.mve.addv.predicated.v8i16.v8i1(<8 x i16> %acc1, i32 0, <8 x i1> %5)
  store i32 %2, i32* %px, align 4
  %arrayidx1 = getelementptr inbounds i32, i32* %px, i32 1
  store i32 %6, i32* %arrayidx1, align 4
  %arrayidx2 = getelementptr inbounds i32, i32* %px, i32 2
  store i32 %7, i32* %arrayidx2, align 4
  %arrayidx3 = getelementptr inbounds i32, i32* %px, i32 3
  store i32 %8, i32* %arrayidx3, align 4
  ret void
}



define arm_aapcs_vfpcc <4 x i32> @xorvpnot_i32(<4 x i32> %acc0, i16 signext %p0) {
; CHECK-LABEL: xorvpnot_i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vmov.i32 q1, #0x0
; CHECK-NEXT:    vpnot
; CHECK-NEXT:    vpsel q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %l3 = xor i16 %p0, -1
  %l4 = zext i16 %l3 to i32
  %l5 = tail call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %l4)
  %l6 = select <4 x i1> %l5, <4 x i32> %acc0, <4 x i32> zeroinitializer
  ret <4 x i32> %l6
}

define arm_aapcs_vfpcc <8 x i16> @xorvpnot_i16(<8 x i16> %acc0, i16 signext %p0) {
; CHECK-LABEL: xorvpnot_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vmov.i32 q1, #0x0
; CHECK-NEXT:    vpnot
; CHECK-NEXT:    vpsel q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %l3 = xor i16 %p0, -1
  %l4 = zext i16 %l3 to i32
  %l5 = tail call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %l4)
  %l6 = select <8 x i1> %l5, <8 x i16> %acc0, <8 x i16> zeroinitializer
  ret <8 x i16> %l6
}

define arm_aapcs_vfpcc <16 x i8> @xorvpnot_i8(<16 x i8> %acc0, i16 signext %p0) {
; CHECK-LABEL: xorvpnot_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vmov.i32 q1, #0x0
; CHECK-NEXT:    vpnot
; CHECK-NEXT:    vpsel q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %l3 = xor i16 %p0, -1
  %l4 = zext i16 %l3 to i32
  %l5 = tail call <16 x i1> @llvm.arm.mve.pred.i2v.v16i1(i32 %l4)
  %l6 = select <16 x i1> %l5, <16 x i8> %acc0, <16 x i8> zeroinitializer
  ret <16 x i8> %l6
}

define arm_aapcs_vfpcc <16 x i8> @xorvpnot_i8_2(<16 x i8> %acc0, i32 %p0) {
; CHECK-LABEL: xorvpnot_i8_2:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vmov.i32 q1, #0x0
; CHECK-NEXT:    vpnot
; CHECK-NEXT:    vpsel q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %l3 = xor i32 %p0, 65535
  %l5 = tail call <16 x i1> @llvm.arm.mve.pred.i2v.v16i1(i32 %l3)
  %l6 = select <16 x i1> %l5, <16 x i8> %acc0, <16 x i8> zeroinitializer
  ret <16 x i8> %l6
}



define arm_aapcs_vfpcc i32 @const_mask_1(<4 x i32> %0, <4 x i32> %1, i32 %2) {
; CHECK-LABEL: const_mask_1:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movs r1, #1
; CHECK-NEXT:    vmsr p0, r1
; CHECK-NEXT:    vpsttee
; CHECK-NEXT:    vaddvat.s32 r0, q0
; CHECK-NEXT:    vaddvat.s32 r0, q1
; CHECK-NEXT:    vaddvae.s32 r0, q0
; CHECK-NEXT:    vaddvae.s32 r0, q1
; CHECK-NEXT:    bx lr
  %4 = tail call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 1)
  %5 = tail call i32 @llvm.arm.mve.addv.predicated.v4i32.v4i1(<4 x i32> %0, i32 0, <4 x i1> %4)
  %6 = add i32 %5, %2
  %7 = tail call i32 @llvm.arm.mve.addv.predicated.v4i32.v4i1(<4 x i32> %1, i32 0, <4 x i1> %4)
  %8 = add i32 %6, %7
  %9 = tail call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 65534)
  %10 = tail call i32 @llvm.arm.mve.addv.predicated.v4i32.v4i1(<4 x i32> %0, i32 0, <4 x i1> %9)
  %11 = add i32 %8, %10
  %12 = tail call i32 @llvm.arm.mve.addv.predicated.v4i32.v4i1(<4 x i32> %1, i32 0, <4 x i1> %9)
  %13 = add i32 %11, %12
  ret i32 %13
}

define arm_aapcs_vfpcc i32 @const_mask_not1(<4 x i32> %0, <4 x i32> %1, i32 %2) {
; CHECK-LABEL: const_mask_not1:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movs r1, #1
; CHECK-NEXT:    vmsr p0, r1
; CHECK-NEXT:    vpstt
; CHECK-NEXT:    vaddvat.s32 r0, q0
; CHECK-NEXT:    vaddvat.s32 r0, q1
; CHECK-NEXT:    movw r1, #65533
; CHECK-NEXT:    vmsr p0, r1
; CHECK-NEXT:    vpstt
; CHECK-NEXT:    vaddvat.s32 r0, q0
; CHECK-NEXT:    vaddvat.s32 r0, q1
; CHECK-NEXT:    bx lr
  %4 = tail call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 1)
  %5 = tail call i32 @llvm.arm.mve.addv.predicated.v4i32.v4i1(<4 x i32> %0, i32 0, <4 x i1> %4)
  %6 = add i32 %5, %2
  %7 = tail call i32 @llvm.arm.mve.addv.predicated.v4i32.v4i1(<4 x i32> %1, i32 0, <4 x i1> %4)
  %8 = add i32 %6, %7
  %9 = tail call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 65533)
  %10 = tail call i32 @llvm.arm.mve.addv.predicated.v4i32.v4i1(<4 x i32> %0, i32 0, <4 x i1> %9)
  %11 = add i32 %8, %10
  %12 = tail call i32 @llvm.arm.mve.addv.predicated.v4i32.v4i1(<4 x i32> %1, i32 0, <4 x i1> %9)
  %13 = add i32 %11, %12
  ret i32 %13
}

define arm_aapcs_vfpcc i32 @const_mask_1234(<4 x i32> %0, <4 x i32> %1, i32 %2) {
; CHECK-LABEL: const_mask_1234:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movw r1, #1234
; CHECK-NEXT:    vmsr p0, r1
; CHECK-NEXT:    vpsttee
; CHECK-NEXT:    vaddvat.s32 r0, q0
; CHECK-NEXT:    vaddvat.s32 r0, q1
; CHECK-NEXT:    vaddvae.s32 r0, q0
; CHECK-NEXT:    vaddvae.s32 r0, q1
; CHECK-NEXT:    bx lr
  %4 = tail call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 1234)
  %5 = tail call i32 @llvm.arm.mve.addv.predicated.v4i32.v4i1(<4 x i32> %0, i32 0, <4 x i1> %4)
  %6 = add i32 %5, %2
  %7 = tail call i32 @llvm.arm.mve.addv.predicated.v4i32.v4i1(<4 x i32> %1, i32 0, <4 x i1> %4)
  %8 = add i32 %6, %7
  %9 = tail call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 64301)
  %10 = tail call i32 @llvm.arm.mve.addv.predicated.v4i32.v4i1(<4 x i32> %0, i32 0, <4 x i1> %9)
  %11 = add i32 %8, %10
  %12 = tail call i32 @llvm.arm.mve.addv.predicated.v4i32.v4i1(<4 x i32> %1, i32 0, <4 x i1> %9)
  %13 = add i32 %11, %12
  ret i32 %13
}

define arm_aapcs_vfpcc i32 @const_mask_abab(<4 x i32> %0, <4 x i32> %1, i32 %2) {
; CHECK-LABEL: const_mask_abab:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movw r1, #1234
; CHECK-NEXT:    vmsr p0, r1
; CHECK-NEXT:    vpstete
; CHECK-NEXT:    vaddvat.s32 r0, q0
; CHECK-NEXT:    vaddvae.s32 r0, q1
; CHECK-NEXT:    vaddvat.s32 r0, q1
; CHECK-NEXT:    vaddvae.s32 r0, q0
; CHECK-NEXT:    bx lr
  %4 = tail call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 1234)
  %5 = tail call i32 @llvm.arm.mve.addv.predicated.v4i32.v4i1(<4 x i32> %0, i32 0, <4 x i1> %4)
  %6 = add i32 %5, %2
  %7 = tail call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 64301)
  %8 = tail call i32 @llvm.arm.mve.addv.predicated.v4i32.v4i1(<4 x i32> %1, i32 0, <4 x i1> %7)
  %9 = add i32 %6, %8
  %10 = tail call i32 @llvm.arm.mve.addv.predicated.v4i32.v4i1(<4 x i32> %1, i32 0, <4 x i1> %4)
  %11 = add i32 %9, %10
  %12 = tail call i32 @llvm.arm.mve.addv.predicated.v4i32.v4i1(<4 x i32> %0, i32 0, <4 x i1> %7)
  %13 = add i32 %11, %12
  ret i32 %13
}

define arm_aapcs_vfpcc i32 @const_mask_abbreakab(<4 x i32> %0, <4 x i32> %1, i32 %2) {
; CHECK-LABEL: const_mask_abbreakab:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movw r1, #1234
; CHECK-NEXT:    vmsr p0, r1
; CHECK-NEXT:    vpste
; CHECK-NEXT:    vaddvat.s32 r0, q0
; CHECK-NEXT:    vaddvae.s32 r0, q1
; CHECK-NEXT:    vadd.i32 q1, q0, r0
; CHECK-NEXT:    vpnot
; CHECK-NEXT:    vpste
; CHECK-NEXT:    vaddvat.s32 r0, q1
; CHECK-NEXT:    vaddvae.s32 r0, q0
; CHECK-NEXT:    bx lr
  %4 = tail call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 1234)
  %5 = tail call i32 @llvm.arm.mve.addv.predicated.v4i32.v4i1(<4 x i32> %0, i32 0, <4 x i1> %4)
  %6 = add i32 %5, %2
  %7 = tail call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 64301)
  %8 = tail call i32 @llvm.arm.mve.addv.predicated.v4i32.v4i1(<4 x i32> %1, i32 0, <4 x i1> %7)
  %9 = add i32 %6, %8
  %si = insertelement <4 x i32> undef, i32 %9, i32 0
  %s = shufflevector <4 x i32> %si, <4 x i32> undef, <4 x i32> zeroinitializer
  %nadd = add <4 x i32> %0, %s
  %10 = tail call i32 @llvm.arm.mve.addv.predicated.v4i32.v4i1(<4 x i32> %nadd, i32 0, <4 x i1> %4)
  %11 = add i32 %9, %10
  %12 = tail call i32 @llvm.arm.mve.addv.predicated.v4i32.v4i1(<4 x i32> %0, i32 0, <4 x i1> %7)
  %13 = add i32 %11, %12
  ret i32 %13
}

define arm_aapcs_vfpcc i32 @const_mask_break(<4 x i32> %0, <4 x i32> %1, i32 %2) {
; CHECK-LABEL: const_mask_break:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movw r1, #1234
; CHECK-NEXT:    vmsr p0, r1
; CHECK-NEXT:    vpstt
; CHECK-NEXT:    vaddvat.s32 r0, q0
; CHECK-NEXT:    vaddvat.s32 r0, q1
; CHECK-NEXT:    vadd.i32 q1, q0, r0
; CHECK-NEXT:    vpnot
; CHECK-NEXT:    vpstt
; CHECK-NEXT:    vaddvat.s32 r0, q1
; CHECK-NEXT:    vaddvat.s32 r0, q0
; CHECK-NEXT:    bx lr
  %4 = tail call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 1234)
  %5 = tail call i32 @llvm.arm.mve.addv.predicated.v4i32.v4i1(<4 x i32> %0, i32 0, <4 x i1> %4)
  %6 = add i32 %5, %2
  %7 = tail call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 64301)
  %8 = tail call i32 @llvm.arm.mve.addv.predicated.v4i32.v4i1(<4 x i32> %1, i32 0, <4 x i1> %4)
  %9 = add i32 %6, %8
  %si = insertelement <4 x i32> undef, i32 %9, i32 0
  %s = shufflevector <4 x i32> %si, <4 x i32> undef, <4 x i32> zeroinitializer
  %nadd = add <4 x i32> %0, %s
  %10 = tail call i32 @llvm.arm.mve.addv.predicated.v4i32.v4i1(<4 x i32> %nadd, i32 0, <4 x i1> %7)
  %11 = add i32 %9, %10
  %12 = tail call i32 @llvm.arm.mve.addv.predicated.v4i32.v4i1(<4 x i32> %0, i32 0, <4 x i1> %7)
  %13 = add i32 %11, %12
  ret i32 %13
}

define arm_aapcs_vfpcc i32 @const_mask_threepred(<4 x i32> %0, <4 x i32> %1, i32 %2) {
; CHECK-LABEL: const_mask_threepred:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movw r1, #1234
; CHECK-NEXT:    vmsr p0, r1
; CHECK-NEXT:    vpstt
; CHECK-NEXT:    vaddvat.s32 r0, q0
; CHECK-NEXT:    vaddvat.s32 r0, q1
; CHECK-NEXT:    movw r1, #64300
; CHECK-NEXT:    vmsr p0, r1
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vaddvat.s32 r0, q1
; CHECK-NEXT:    movw r1, #64301
; CHECK-NEXT:    vmsr p0, r1
; CHECK-NEXT:    vpstt
; CHECK-NEXT:    vaddvat.s32 r0, q1
; CHECK-NEXT:    vaddvat.s32 r0, q0
; CHECK-NEXT:    bx lr
  %4 = tail call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 1234)
  %5 = tail call i32 @llvm.arm.mve.addv.predicated.v4i32.v4i1(<4 x i32> %0, i32 0, <4 x i1> %4)
  %6 = add i32 %5, %2
  %7 = tail call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 64301)
  %8 = tail call i32 @llvm.arm.mve.addv.predicated.v4i32.v4i1(<4 x i32> %1, i32 0, <4 x i1> %4)
  %9 = add i32 %6, %8
  %n7 = tail call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 64300)
  %n8 = tail call i32 @llvm.arm.mve.addv.predicated.v4i32.v4i1(<4 x i32> %1, i32 0, <4 x i1> %n7)
  %n9 = add i32 %9, %n8
  %10 = tail call i32 @llvm.arm.mve.addv.predicated.v4i32.v4i1(<4 x i32> %1, i32 0, <4 x i1> %7)
  %11 = add i32 %n9, %10
  %12 = tail call i32 @llvm.arm.mve.addv.predicated.v4i32.v4i1(<4 x i32> %0, i32 0, <4 x i1> %7)
  %13 = add i32 %11, %12
  ret i32 %13
}

define arm_aapcs_vfpcc i32 @const_mask_threepredabab(<4 x i32> %0, <4 x i32> %1, i32 %2) {
; CHECK-LABEL: const_mask_threepredabab:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    .pad #4
; CHECK-NEXT:    sub sp, #4
; CHECK-NEXT:    movw r1, #1234
; CHECK-NEXT:    vmsr p0, r1
; CHECK-NEXT:    vstr p0, [sp] @ 4-byte Spill
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vaddvat.s32 r0, q0
; CHECK-NEXT:    vldr p0, [sp] @ 4-byte Reload
; CHECK-NEXT:    vpnot
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vaddvat.s32 r0, q1
; CHECK-NEXT:    vpt.s32 gt, q1, q0
; CHECK-NEXT:    vaddvat.s32 r0, q1
; CHECK-NEXT:    vldr p0, [sp] @ 4-byte Reload
; CHECK-NEXT:    vpste
; CHECK-NEXT:    vaddvat.s32 r0, q1
; CHECK-NEXT:    vaddvae.s32 r0, q0
; CHECK-NEXT:    add sp, #4
; CHECK-NEXT:    bx lr
  %4 = tail call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 1234)
  %5 = tail call i32 @llvm.arm.mve.addv.predicated.v4i32.v4i1(<4 x i32> %0, i32 0, <4 x i1> %4)
  %6 = add i32 %5, %2
  %7 = tail call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 64301)
  %8 = tail call i32 @llvm.arm.mve.addv.predicated.v4i32.v4i1(<4 x i32> %1, i32 0, <4 x i1> %7)
  %9 = add i32 %6, %8
  %n7 = icmp slt <4 x i32> %0, %1
  %n8 = tail call i32 @llvm.arm.mve.addv.predicated.v4i32.v4i1(<4 x i32> %1, i32 0, <4 x i1> %n7)
  %n9 = add i32 %9, %n8
  %10 = tail call i32 @llvm.arm.mve.addv.predicated.v4i32.v4i1(<4 x i32> %1, i32 0, <4 x i1> %4)
  %11 = add i32 %n9, %10
  %12 = tail call i32 @llvm.arm.mve.addv.predicated.v4i32.v4i1(<4 x i32> %0, i32 0, <4 x i1> %7)
  %13 = add i32 %11, %12
  ret i32 %13
}


declare i32 @llvm.arm.mve.pred.v2i.v4i1(<4 x i1>)
declare i32 @llvm.arm.mve.pred.v2i.v8i1(<8 x i1>)
declare i32 @llvm.arm.mve.pred.v2i.v16i1(<16 x i1>)

declare <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32)
declare <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32)
declare <16 x i1> @llvm.arm.mve.pred.i2v.v16i1(i32)

declare i32 @llvm.arm.mve.addv.predicated.v4i32.v4i1(<4 x i32>, i32, <4 x i1>)
declare i32 @llvm.arm.mve.addv.predicated.v8i16.v8i1(<8 x i16>, i32, <8 x i1>)
declare i32 @llvm.arm.mve.addv.predicated.v16i8.v16i1(<16 x i8>, i32, <16 x i1>)
