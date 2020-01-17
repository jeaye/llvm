; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-arm-none-eabi -mattr=+mve.fp -enable-arm-maskedldst -enable-arm-maskedgatscat %s -o - | FileCheck %s

; i32

define arm_aapcs_vfpcc <2 x i32> @ptr_v2i32(<2 x i32*>* %offptr) {
; CHECK-LABEL: ptr_v2i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    ldrd r1, r0, [r0]
; CHECK-NEXT:    ldr r0, [r0]
; CHECK-NEXT:    ldr r1, [r1]
; CHECK-NEXT:    vmov.32 q0[0], r1
; CHECK-NEXT:    vmov.32 q0[2], r0
; CHECK-NEXT:    bx lr
entry:
  %offs = load <2 x i32*>, <2 x i32*>* %offptr, align 4
  %gather = call <2 x i32> @llvm.masked.gather.v2i32.v2p0i32(<2 x i32*> %offs, i32 4, <2 x i1> <i1 true, i1 true>, <2 x i32> undef)
  ret <2 x i32> %gather
}

define arm_aapcs_vfpcc <4 x i32> @ptr_v4i32(<4 x i32*>* %offptr) {
; CHECK-LABEL: ptr_v4i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    vldrw.u32 q0, [q1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i32*>, <4 x i32*>* %offptr, align 4
  %gather = call <4 x i32> @llvm.masked.gather.v4i32.v4p0i32(<4 x i32*> %offs, i32 4, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x i32> undef)
  ret <4 x i32> %gather
}

define arm_aapcs_vfpcc <8 x i32> @ptr_v8i32(<8 x i32*>* %offptr) {
; CHECK-LABEL: ptr_v8i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r7, lr}
; CHECK-NEXT:    push {r4, r5, r7, lr}
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    vldrw.u32 q1, [r0, #16]
; CHECK-NEXT:    vmov r1, s2
; CHECK-NEXT:    vmov r2, s3
; CHECK-NEXT:    vmov r3, s0
; CHECK-NEXT:    vmov r0, s4
; CHECK-NEXT:    vmov r5, s1
; CHECK-NEXT:    vmov r4, s7
; CHECK-NEXT:    ldr.w r12, [r1]
; CHECK-NEXT:    vmov r1, s5
; CHECK-NEXT:    ldr.w lr, [r2]
; CHECK-NEXT:    vmov r2, s6
; CHECK-NEXT:    ldr r3, [r3]
; CHECK-NEXT:    ldr r0, [r0]
; CHECK-NEXT:    ldr r5, [r5]
; CHECK-NEXT:    vmov.32 q0[0], r3
; CHECK-NEXT:    vmov.32 q1[0], r0
; CHECK-NEXT:    ldr r4, [r4]
; CHECK-NEXT:    vmov.32 q0[1], r5
; CHECK-NEXT:    vmov.32 q0[2], r12
; CHECK-NEXT:    vmov.32 q0[3], lr
; CHECK-NEXT:    ldr r1, [r1]
; CHECK-NEXT:    ldr r2, [r2]
; CHECK-NEXT:    vmov.32 q1[1], r1
; CHECK-NEXT:    vmov.32 q1[2], r2
; CHECK-NEXT:    vmov.32 q1[3], r4
; CHECK-NEXT:    pop {r4, r5, r7, pc}
entry:
  %offs = load <8 x i32*>, <8 x i32*>* %offptr, align 4
  %gather = call <8 x i32> @llvm.masked.gather.v8i32.v8p0i32(<8 x i32*> %offs, i32 4, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x i32> undef)
  ret <8 x i32> %gather
}

define arm_aapcs_vfpcc <16 x i32> @ptr_v16i32(<16 x i32*>* %offptr) {
; CHECK-LABEL: ptr_v16i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r6, lr}
; CHECK-NEXT:    push {r4, r5, r6, lr}
; CHECK-NEXT:    vldrw.u32 q2, [r0, #32]
; CHECK-NEXT:    vldrw.u32 q0, [r0, #48]
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    vldrw.u32 q3, [r0, #16]
; CHECK-NEXT:    vmov r1, s10
; CHECK-NEXT:    vmov r5, s4
; CHECK-NEXT:    vmov r2, s3
; CHECK-NEXT:    vmov r0, s12
; CHECK-NEXT:    vmov r6, s7
; CHECK-NEXT:    vmov r4, s11
; CHECK-NEXT:    ldr.w r12, [r1]
; CHECK-NEXT:    vmov r1, s0
; CHECK-NEXT:    ldr r5, [r5]
; CHECK-NEXT:    ldr r2, [r2]
; CHECK-NEXT:    ldr r0, [r0]
; CHECK-NEXT:    ldr r6, [r6]
; CHECK-NEXT:    ldr r4, [r4]
; CHECK-NEXT:    ldr.w lr, [r1]
; CHECK-NEXT:    vmov r1, s1
; CHECK-NEXT:    ldr r3, [r1]
; CHECK-NEXT:    vmov r1, s2
; CHECK-NEXT:    vmov.32 q0[0], r5
; CHECK-NEXT:    vmov r5, s5
; CHECK-NEXT:    ldr r1, [r1]
; CHECK-NEXT:    ldr r5, [r5]
; CHECK-NEXT:    vmov.32 q0[1], r5
; CHECK-NEXT:    vmov r5, s6
; CHECK-NEXT:    vmov.32 q1[0], r0
; CHECK-NEXT:    vmov r0, s13
; CHECK-NEXT:    ldr r5, [r5]
; CHECK-NEXT:    ldr r0, [r0]
; CHECK-NEXT:    vmov.32 q0[2], r5
; CHECK-NEXT:    vmov r5, s8
; CHECK-NEXT:    vmov.32 q1[1], r0
; CHECK-NEXT:    vmov r0, s14
; CHECK-NEXT:    vmov.32 q0[3], r6
; CHECK-NEXT:    ldr r5, [r5]
; CHECK-NEXT:    ldr r0, [r0]
; CHECK-NEXT:    vmov.32 q1[2], r0
; CHECK-NEXT:    vmov r0, s15
; CHECK-NEXT:    vmov.32 q3[0], lr
; CHECK-NEXT:    vmov.32 q3[1], r3
; CHECK-NEXT:    vmov.32 q3[2], r1
; CHECK-NEXT:    vmov.32 q3[3], r2
; CHECK-NEXT:    ldr r0, [r0]
; CHECK-NEXT:    vmov.32 q1[3], r0
; CHECK-NEXT:    vmov r0, s9
; CHECK-NEXT:    vmov.32 q2[0], r5
; CHECK-NEXT:    ldr r0, [r0]
; CHECK-NEXT:    vmov.32 q2[1], r0
; CHECK-NEXT:    vmov.32 q2[2], r12
; CHECK-NEXT:    vmov.32 q2[3], r4
; CHECK-NEXT:    pop {r4, r5, r6, pc}
entry:
  %offs = load <16 x i32*>, <16 x i32*>* %offptr, align 4
  %gather = call <16 x i32> @llvm.masked.gather.v16i32.v16p0i32(<16 x i32*> %offs, i32 4, <16 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <16 x i32> undef)
  ret <16 x i32> %gather
}

; f32

define arm_aapcs_vfpcc <2 x float> @ptr_v2f32(<2 x float*>* %offptr) {
; CHECK-LABEL: ptr_v2f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    ldrd r1, r0, [r0]
; CHECK-NEXT:    vldr s1, [r0]
; CHECK-NEXT:    vldr s0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <2 x float*>, <2 x float*>* %offptr, align 4
  %gather = call <2 x float> @llvm.masked.gather.v2f32.v2p0f32(<2 x float*> %offs, i32 4, <2 x i1> <i1 true, i1 true>, <2 x float> undef)
  ret <2 x float> %gather
}

define arm_aapcs_vfpcc <4 x float> @ptr_v4f32(<4 x float*>* %offptr) {
; CHECK-LABEL: ptr_v4f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    vldrw.u32 q0, [q1]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x float*>, <4 x float*>* %offptr, align 4
  %gather = call <4 x float> @llvm.masked.gather.v4f32.v4p0f32(<4 x float*> %offs, i32 4, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x float> undef)
  ret <4 x float> %gather
}

define arm_aapcs_vfpcc <8 x float> @ptr_v8f32(<8 x float*>* %offptr) {
; CHECK-LABEL: ptr_v8f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    vldrw.u32 q2, [r0, #16]
; CHECK-NEXT:    vmov r1, s7
; CHECK-NEXT:    vmov r0, s11
; CHECK-NEXT:    vldr s3, [r1]
; CHECK-NEXT:    vmov r1, s6
; CHECK-NEXT:    vldr s2, [r1]
; CHECK-NEXT:    vmov r1, s5
; CHECK-NEXT:    vldr s1, [r1]
; CHECK-NEXT:    vmov r1, s4
; CHECK-NEXT:    vldr s7, [r0]
; CHECK-NEXT:    vmov r0, s10
; CHECK-NEXT:    vldr s0, [r1]
; CHECK-NEXT:    vldr s6, [r0]
; CHECK-NEXT:    vmov r0, s9
; CHECK-NEXT:    vldr s5, [r0]
; CHECK-NEXT:    vmov r0, s8
; CHECK-NEXT:    vldr s4, [r0]
; CHECK-NEXT:    bx lr
entry:
  %offs = load <8 x float*>, <8 x float*>* %offptr, align 4
  %gather = call <8 x float> @llvm.masked.gather.v8f32.v8p0f32(<8 x float*> %offs, i32 4, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x float> undef)
  ret <8 x float> %gather
}

; i16

define arm_aapcs_vfpcc <8 x i16> @ptr_i16(<8 x i16*>* %offptr) {
; CHECK-LABEL: ptr_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r7, lr}
; CHECK-NEXT:    push {r4, r5, r7, lr}
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    vldrw.u32 q1, [r0, #16]
; CHECK-NEXT:    vmov r1, s2
; CHECK-NEXT:    vmov r2, s3
; CHECK-NEXT:    vmov r3, s0
; CHECK-NEXT:    vmov r5, s1
; CHECK-NEXT:    vmov r0, s4
; CHECK-NEXT:    vmov r4, s7
; CHECK-NEXT:    ldrh.w r12, [r1]
; CHECK-NEXT:    vmov r1, s5
; CHECK-NEXT:    ldrh.w lr, [r2]
; CHECK-NEXT:    vmov r2, s6
; CHECK-NEXT:    ldrh r3, [r3]
; CHECK-NEXT:    ldrh r5, [r5]
; CHECK-NEXT:    vmov.16 q0[0], r3
; CHECK-NEXT:    ldrh r0, [r0]
; CHECK-NEXT:    vmov.16 q0[1], r5
; CHECK-NEXT:    ldrh r4, [r4]
; CHECK-NEXT:    vmov.16 q0[2], r12
; CHECK-NEXT:    vmov.16 q0[3], lr
; CHECK-NEXT:    vmov.16 q0[4], r0
; CHECK-NEXT:    ldrh r1, [r1]
; CHECK-NEXT:    ldrh r2, [r2]
; CHECK-NEXT:    vmov.16 q0[5], r1
; CHECK-NEXT:    vmov.16 q0[6], r2
; CHECK-NEXT:    vmov.16 q0[7], r4
; CHECK-NEXT:    pop {r4, r5, r7, pc}
entry:
  %offs = load <8 x i16*>, <8 x i16*>* %offptr, align 4
  %gather = call <8 x i16> @llvm.masked.gather.v8i16.v8p0i16(<8 x i16*> %offs, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x i16> undef)
  ret <8 x i16> %gather
}

define arm_aapcs_vfpcc <2 x i32> @ptr_v2i16_sext(<2 x i16*>* %offptr) {
; CHECK-LABEL: ptr_v2i16_sext:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    ldrd r1, r0, [r0]
; CHECK-NEXT:    ldrsh.w r0, [r0]
; CHECK-NEXT:    ldrsh.w r1, [r1]
; CHECK-NEXT:    asrs r2, r0, #31
; CHECK-NEXT:    vmov.32 q0[0], r1
; CHECK-NEXT:    asrs r1, r1, #31
; CHECK-NEXT:    vmov.32 q0[1], r1
; CHECK-NEXT:    vmov.32 q0[2], r0
; CHECK-NEXT:    vmov.32 q0[3], r2
; CHECK-NEXT:    bx lr
entry:
  %offs = load <2 x i16*>, <2 x i16*>* %offptr, align 4
  %gather = call <2 x i16> @llvm.masked.gather.v2i16.v2p0i16(<2 x i16*> %offs, i32 2, <2 x i1> <i1 true, i1 true>, <2 x i16> undef)
  %ext = sext <2 x i16> %gather to <2 x i32>
  ret <2 x i32> %ext
}

define arm_aapcs_vfpcc <2 x i32> @ptr_v2i16_zext(<2 x i16*>* %offptr) {
; CHECK-LABEL: ptr_v2i16_zext:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    ldrd r1, r0, [r0]
; CHECK-NEXT:    adr r2, .LCPI9_0
; CHECK-NEXT:    ldrh r0, [r0]
; CHECK-NEXT:    vldrw.u32 q0, [r2]
; CHECK-NEXT:    ldrh r1, [r1]
; CHECK-NEXT:    vmov.32 q1[0], r1
; CHECK-NEXT:    vmov.32 q1[2], r0
; CHECK-NEXT:    vand q0, q1, q0
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI9_0:
; CHECK-NEXT:    .long 65535 @ 0xffff
; CHECK-NEXT:    .long 0 @ 0x0
; CHECK-NEXT:    .long 65535 @ 0xffff
; CHECK-NEXT:    .long 0 @ 0x0
entry:
  %offs = load <2 x i16*>, <2 x i16*>* %offptr, align 4
  %gather = call <2 x i16> @llvm.masked.gather.v2i16.v2p0i16(<2 x i16*> %offs, i32 2, <2 x i1> <i1 true, i1 true>, <2 x i16> undef)
  %ext = zext <2 x i16> %gather to <2 x i32>
  ret <2 x i32> %ext
}

define arm_aapcs_vfpcc <4 x i32> @ptr_v4i16_sext(<4 x i16*>* %offptr) {
; CHECK-LABEL: ptr_v4i16_sext:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    vmov r2, s0
; CHECK-NEXT:    vmov r0, s1
; CHECK-NEXT:    vmov r3, s2
; CHECK-NEXT:    vmov r1, s3
; CHECK-NEXT:    ldrh r2, [r2]
; CHECK-NEXT:    ldrh r0, [r0]
; CHECK-NEXT:    vmov.32 q0[0], r2
; CHECK-NEXT:    ldrh r3, [r3]
; CHECK-NEXT:    vmov.32 q0[1], r0
; CHECK-NEXT:    ldrh r1, [r1]
; CHECK-NEXT:    vmov.32 q0[2], r3
; CHECK-NEXT:    vmov.32 q0[3], r1
; CHECK-NEXT:    vmovlb.s16 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i16*>, <4 x i16*>* %offptr, align 4
  %gather = call <4 x i16> @llvm.masked.gather.v4i16.v4p0i16(<4 x i16*> %offs, i32 2, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x i16> undef)
  %ext = sext <4 x i16> %gather to <4 x i32>
  ret <4 x i32> %ext
}

define arm_aapcs_vfpcc <4 x i32> @ptr_v4i16_zext(<4 x i16*>* %offptr) {
; CHECK-LABEL: ptr_v4i16_zext:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    vmov r2, s0
; CHECK-NEXT:    vmov r0, s1
; CHECK-NEXT:    vmov r3, s2
; CHECK-NEXT:    vmov r1, s3
; CHECK-NEXT:    ldrh r2, [r2]
; CHECK-NEXT:    ldrh r0, [r0]
; CHECK-NEXT:    vmov.32 q0[0], r2
; CHECK-NEXT:    ldrh r3, [r3]
; CHECK-NEXT:    vmov.32 q0[1], r0
; CHECK-NEXT:    ldrh r1, [r1]
; CHECK-NEXT:    vmov.32 q0[2], r3
; CHECK-NEXT:    vmov.32 q0[3], r1
; CHECK-NEXT:    vmovlb.u16 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i16*>, <4 x i16*>* %offptr, align 4
  %gather = call <4 x i16> @llvm.masked.gather.v4i16.v4p0i16(<4 x i16*> %offs, i32 2, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x i16> undef)
  %ext = zext <4 x i16> %gather to <4 x i32>
  ret <4 x i32> %ext
}

define arm_aapcs_vfpcc <8 x i32> @ptr_v8i16_sext(<8 x i16*>* %offptr) {
; CHECK-LABEL: ptr_v8i16_sext:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r7, lr}
; CHECK-NEXT:    push {r4, r5, r7, lr}
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    vldrw.u32 q1, [r0, #16]
; CHECK-NEXT:    vmov r1, s2
; CHECK-NEXT:    vmov r2, s3
; CHECK-NEXT:    vmov r3, s0
; CHECK-NEXT:    vmov r0, s4
; CHECK-NEXT:    vmov r5, s1
; CHECK-NEXT:    vmov r4, s7
; CHECK-NEXT:    ldrh.w r12, [r1]
; CHECK-NEXT:    vmov r1, s5
; CHECK-NEXT:    ldrh.w lr, [r2]
; CHECK-NEXT:    vmov r2, s6
; CHECK-NEXT:    ldrh r3, [r3]
; CHECK-NEXT:    ldrh r0, [r0]
; CHECK-NEXT:    ldrh r5, [r5]
; CHECK-NEXT:    vmov.32 q0[0], r3
; CHECK-NEXT:    vmov.32 q1[0], r0
; CHECK-NEXT:    ldrh r4, [r4]
; CHECK-NEXT:    vmov.32 q0[1], r5
; CHECK-NEXT:    vmov.32 q0[2], r12
; CHECK-NEXT:    vmov.32 q0[3], lr
; CHECK-NEXT:    vmovlb.s16 q0, q0
; CHECK-NEXT:    ldrh r1, [r1]
; CHECK-NEXT:    ldrh r2, [r2]
; CHECK-NEXT:    vmov.32 q1[1], r1
; CHECK-NEXT:    vmov.32 q1[2], r2
; CHECK-NEXT:    vmov.32 q1[3], r4
; CHECK-NEXT:    vmovlb.s16 q1, q1
; CHECK-NEXT:    pop {r4, r5, r7, pc}
entry:
  %offs = load <8 x i16*>, <8 x i16*>* %offptr, align 4
  %gather = call <8 x i16> @llvm.masked.gather.v8i16.v8p0i16(<8 x i16*> %offs, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x i16> undef)
  %ext = sext <8 x i16> %gather to <8 x i32>
  ret <8 x i32> %ext
}

define arm_aapcs_vfpcc <8 x i32> @ptr_v8i16_zext(<8 x i16*>* %offptr) {
; CHECK-LABEL: ptr_v8i16_zext:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r7, lr}
; CHECK-NEXT:    push {r4, r5, r7, lr}
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    vldrw.u32 q1, [r0, #16]
; CHECK-NEXT:    vmov r1, s2
; CHECK-NEXT:    vmov r2, s3
; CHECK-NEXT:    vmov r3, s0
; CHECK-NEXT:    vmov r0, s4
; CHECK-NEXT:    vmov r5, s1
; CHECK-NEXT:    vmov r4, s7
; CHECK-NEXT:    ldrh.w r12, [r1]
; CHECK-NEXT:    vmov r1, s5
; CHECK-NEXT:    ldrh.w lr, [r2]
; CHECK-NEXT:    vmov r2, s6
; CHECK-NEXT:    ldrh r3, [r3]
; CHECK-NEXT:    ldrh r0, [r0]
; CHECK-NEXT:    ldrh r5, [r5]
; CHECK-NEXT:    vmov.32 q0[0], r3
; CHECK-NEXT:    vmov.32 q1[0], r0
; CHECK-NEXT:    ldrh r4, [r4]
; CHECK-NEXT:    vmov.32 q0[1], r5
; CHECK-NEXT:    vmov.32 q0[2], r12
; CHECK-NEXT:    vmov.32 q0[3], lr
; CHECK-NEXT:    vmovlb.u16 q0, q0
; CHECK-NEXT:    ldrh r1, [r1]
; CHECK-NEXT:    ldrh r2, [r2]
; CHECK-NEXT:    vmov.32 q1[1], r1
; CHECK-NEXT:    vmov.32 q1[2], r2
; CHECK-NEXT:    vmov.32 q1[3], r4
; CHECK-NEXT:    vmovlb.u16 q1, q1
; CHECK-NEXT:    pop {r4, r5, r7, pc}
entry:
  %offs = load <8 x i16*>, <8 x i16*>* %offptr, align 4
  %gather = call <8 x i16> @llvm.masked.gather.v8i16.v8p0i16(<8 x i16*> %offs, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x i16> undef)
  %ext = zext <8 x i16> %gather to <8 x i32>
  ret <8 x i32> %ext
}

; f16

define arm_aapcs_vfpcc <8 x half> @ptr_f16(<8 x half*>* %offptr) {
; CHECK-LABEL: ptr_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    vmov r1, s5
; CHECK-NEXT:    vldr.16 s0, [r1]
; CHECK-NEXT:    vmov r2, s4
; CHECK-NEXT:    vmov r1, s0
; CHECK-NEXT:    vldr.16 s0, [r2]
; CHECK-NEXT:    vmov r2, s0
; CHECK-NEXT:    vmov.16 q0[0], r2
; CHECK-NEXT:    vmov.16 q0[1], r1
; CHECK-NEXT:    vmov r1, s6
; CHECK-NEXT:    vldr.16 s8, [r1]
; CHECK-NEXT:    vmov r1, s8
; CHECK-NEXT:    vmov.16 q0[2], r1
; CHECK-NEXT:    vmov r1, s7
; CHECK-NEXT:    vldr.16 s4, [r1]
; CHECK-NEXT:    vmov r1, s4
; CHECK-NEXT:    vldrw.u32 q1, [r0, #16]
; CHECK-NEXT:    vmov.16 q0[3], r1
; CHECK-NEXT:    vmov r0, s4
; CHECK-NEXT:    vldr.16 s8, [r0]
; CHECK-NEXT:    vmov r0, s8
; CHECK-NEXT:    vmov.16 q0[4], r0
; CHECK-NEXT:    vmov r0, s5
; CHECK-NEXT:    vldr.16 s8, [r0]
; CHECK-NEXT:    vmov r0, s8
; CHECK-NEXT:    vmov.16 q0[5], r0
; CHECK-NEXT:    vmov r0, s6
; CHECK-NEXT:    vldr.16 s8, [r0]
; CHECK-NEXT:    vmov r0, s8
; CHECK-NEXT:    vmov.16 q0[6], r0
; CHECK-NEXT:    vmov r0, s7
; CHECK-NEXT:    vldr.16 s4, [r0]
; CHECK-NEXT:    vmov r0, s4
; CHECK-NEXT:    vmov.16 q0[7], r0
; CHECK-NEXT:    bx lr
entry:
  %offs = load <8 x half*>, <8 x half*>* %offptr, align 4
  %gather = call <8 x half> @llvm.masked.gather.v8f16.v8p0f16(<8 x half*> %offs, i32 2, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x half> undef)
  ret <8 x half> %gather
}

; i8

define arm_aapcs_vfpcc <16 x i8> @ptr_i8(<16 x i8*>* %offptr) {
; CHECK-LABEL: ptr_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r6, lr}
; CHECK-NEXT:    push {r4, r5, r6, lr}
; CHECK-NEXT:    vldrw.u32 q1, [r0, #32]
; CHECK-NEXT:    vldrw.u32 q0, [r0, #48]
; CHECK-NEXT:    vldrw.u32 q2, [r0]
; CHECK-NEXT:    vmov r1, s6
; CHECK-NEXT:    vmov r5, s8
; CHECK-NEXT:    vmov r2, s3
; CHECK-NEXT:    vmov r6, s11
; CHECK-NEXT:    vmov r4, s7
; CHECK-NEXT:    ldrb.w r12, [r1]
; CHECK-NEXT:    vmov r1, s0
; CHECK-NEXT:    ldrb r5, [r5]
; CHECK-NEXT:    ldrb r2, [r2]
; CHECK-NEXT:    ldrb r6, [r6]
; CHECK-NEXT:    ldrb r4, [r4]
; CHECK-NEXT:    ldrb.w lr, [r1]
; CHECK-NEXT:    vmov r1, s1
; CHECK-NEXT:    ldrb r3, [r1]
; CHECK-NEXT:    vmov r1, s2
; CHECK-NEXT:    vmov.8 q0[0], r5
; CHECK-NEXT:    vmov r5, s9
; CHECK-NEXT:    ldrb r1, [r1]
; CHECK-NEXT:    ldrb r5, [r5]
; CHECK-NEXT:    vmov.8 q0[1], r5
; CHECK-NEXT:    vmov r5, s10
; CHECK-NEXT:    vldrw.u32 q2, [r0, #16]
; CHECK-NEXT:    vmov r0, s8
; CHECK-NEXT:    ldrb r5, [r5]
; CHECK-NEXT:    vmov.8 q0[2], r5
; CHECK-NEXT:    vmov r5, s4
; CHECK-NEXT:    ldrb r0, [r0]
; CHECK-NEXT:    vmov.8 q0[3], r6
; CHECK-NEXT:    vmov.8 q0[4], r0
; CHECK-NEXT:    vmov r0, s9
; CHECK-NEXT:    ldrb r5, [r5]
; CHECK-NEXT:    ldrb r0, [r0]
; CHECK-NEXT:    vmov.8 q0[5], r0
; CHECK-NEXT:    vmov r0, s10
; CHECK-NEXT:    ldrb r0, [r0]
; CHECK-NEXT:    vmov.8 q0[6], r0
; CHECK-NEXT:    vmov r0, s11
; CHECK-NEXT:    ldrb r0, [r0]
; CHECK-NEXT:    vmov.8 q0[7], r0
; CHECK-NEXT:    vmov r0, s5
; CHECK-NEXT:    vmov.8 q0[8], r5
; CHECK-NEXT:    ldrb r0, [r0]
; CHECK-NEXT:    vmov.8 q0[9], r0
; CHECK-NEXT:    vmov.8 q0[10], r12
; CHECK-NEXT:    vmov.8 q0[11], r4
; CHECK-NEXT:    vmov.8 q0[12], lr
; CHECK-NEXT:    vmov.8 q0[13], r3
; CHECK-NEXT:    vmov.8 q0[14], r1
; CHECK-NEXT:    vmov.8 q0[15], r2
; CHECK-NEXT:    pop {r4, r5, r6, pc}
entry:
  %offs = load <16 x i8*>, <16 x i8*>* %offptr, align 4
  %gather = call <16 x i8> @llvm.masked.gather.v16i8.v16p0i8(<16 x i8*> %offs, i32 2, <16 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <16 x i8> undef)
  ret <16 x i8> %gather
}

define arm_aapcs_vfpcc <8 x i16> @ptr_v8i8_sext16(<8 x i8*>* %offptr) {
; CHECK-LABEL: ptr_v8i8_sext16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r7, lr}
; CHECK-NEXT:    push {r4, r5, r7, lr}
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    vldrw.u32 q1, [r0, #16]
; CHECK-NEXT:    vmov r2, s3
; CHECK-NEXT:    vmov r1, s1
; CHECK-NEXT:    vmov r5, s0
; CHECK-NEXT:    vmov r3, s2
; CHECK-NEXT:    vmov r0, s4
; CHECK-NEXT:    vmov r4, s7
; CHECK-NEXT:    ldrb.w r12, [r2]
; CHECK-NEXT:    vmov r2, s5
; CHECK-NEXT:    ldrb.w lr, [r1]
; CHECK-NEXT:    vmov r1, s6
; CHECK-NEXT:    ldrb r5, [r5]
; CHECK-NEXT:    ldrb r3, [r3]
; CHECK-NEXT:    vmov.16 q0[0], r5
; CHECK-NEXT:    ldrb r0, [r0]
; CHECK-NEXT:    vmov.16 q0[1], lr
; CHECK-NEXT:    ldrb r4, [r4]
; CHECK-NEXT:    vmov.16 q0[2], r3
; CHECK-NEXT:    vmov.16 q0[3], r12
; CHECK-NEXT:    vmov.16 q0[4], r0
; CHECK-NEXT:    ldrb r2, [r2]
; CHECK-NEXT:    ldrb r1, [r1]
; CHECK-NEXT:    vmov.16 q0[5], r2
; CHECK-NEXT:    vmov.16 q0[6], r1
; CHECK-NEXT:    vmov.16 q0[7], r4
; CHECK-NEXT:    vmovlb.s8 q0, q0
; CHECK-NEXT:    pop {r4, r5, r7, pc}
entry:
  %offs = load <8 x i8*>, <8 x i8*>* %offptr, align 4
  %gather = call <8 x i8> @llvm.masked.gather.v8i8.v8p0i8(<8 x i8*> %offs, i32 1, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x i8> undef)
  %ext = sext <8 x i8> %gather to <8 x i16>
  ret <8 x i16> %ext
}

define arm_aapcs_vfpcc <8 x i16> @ptr_v8i8_zext16(<8 x i8*>* %offptr) {
; CHECK-LABEL: ptr_v8i8_zext16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r7, lr}
; CHECK-NEXT:    push {r4, r5, r7, lr}
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    vldrw.u32 q1, [r0, #16]
; CHECK-NEXT:    vmov r2, s3
; CHECK-NEXT:    vmov r1, s1
; CHECK-NEXT:    vmov r5, s0
; CHECK-NEXT:    vmov r3, s2
; CHECK-NEXT:    vmov r0, s4
; CHECK-NEXT:    vmov r4, s7
; CHECK-NEXT:    ldrb.w r12, [r2]
; CHECK-NEXT:    vmov r2, s5
; CHECK-NEXT:    ldrb.w lr, [r1]
; CHECK-NEXT:    vmov r1, s6
; CHECK-NEXT:    ldrb r5, [r5]
; CHECK-NEXT:    ldrb r3, [r3]
; CHECK-NEXT:    vmov.16 q0[0], r5
; CHECK-NEXT:    ldrb r0, [r0]
; CHECK-NEXT:    vmov.16 q0[1], lr
; CHECK-NEXT:    ldrb r4, [r4]
; CHECK-NEXT:    vmov.16 q0[2], r3
; CHECK-NEXT:    vmov.16 q0[3], r12
; CHECK-NEXT:    vmov.16 q0[4], r0
; CHECK-NEXT:    ldrb r2, [r2]
; CHECK-NEXT:    ldrb r1, [r1]
; CHECK-NEXT:    vmov.16 q0[5], r2
; CHECK-NEXT:    vmov.16 q0[6], r1
; CHECK-NEXT:    vmov.16 q0[7], r4
; CHECK-NEXT:    vmovlb.u8 q0, q0
; CHECK-NEXT:    pop {r4, r5, r7, pc}
entry:
  %offs = load <8 x i8*>, <8 x i8*>* %offptr, align 4
  %gather = call <8 x i8> @llvm.masked.gather.v8i8.v8p0i8(<8 x i8*> %offs, i32 1, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x i8> undef)
  %ext = zext <8 x i8> %gather to <8 x i16>
  ret <8 x i16> %ext
}

define arm_aapcs_vfpcc <4 x i32> @ptr_v4i8_sext32(<4 x i8*>* %offptr) {
; CHECK-LABEL: ptr_v4i8_sext32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    vmov r3, s1
; CHECK-NEXT:    vmov r1, s2
; CHECK-NEXT:    vmov r2, s3
; CHECK-NEXT:    ldrb r0, [r0]
; CHECK-NEXT:    ldrb r3, [r3]
; CHECK-NEXT:    vmov.32 q0[0], r0
; CHECK-NEXT:    ldrb r1, [r1]
; CHECK-NEXT:    vmov.32 q0[1], r3
; CHECK-NEXT:    ldrb r2, [r2]
; CHECK-NEXT:    vmov.32 q0[2], r1
; CHECK-NEXT:    vmov.32 q0[3], r2
; CHECK-NEXT:    vmovlb.s8 q0, q0
; CHECK-NEXT:    vmovlb.s16 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i8*>, <4 x i8*>* %offptr, align 4
  %gather = call <4 x i8> @llvm.masked.gather.v4i8.v4p0i8(<4 x i8*> %offs, i32 1, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x i8> undef)
  %ext = sext <4 x i8> %gather to <4 x i32>
  ret <4 x i32> %ext
}

define arm_aapcs_vfpcc <4 x i32> @ptr_v4i8_zext32(<4 x i8*>* %offptr) {
; CHECK-LABEL: ptr_v4i8_zext32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    vmov.i32 q1, #0xff
; CHECK-NEXT:    vmov r2, s0
; CHECK-NEXT:    vmov r1, s1
; CHECK-NEXT:    vmov r3, s2
; CHECK-NEXT:    vmov r0, s3
; CHECK-NEXT:    ldrb r2, [r2]
; CHECK-NEXT:    ldrb r1, [r1]
; CHECK-NEXT:    vmov.32 q0[0], r2
; CHECK-NEXT:    ldrb r3, [r3]
; CHECK-NEXT:    vmov.32 q0[1], r1
; CHECK-NEXT:    ldrb r0, [r0]
; CHECK-NEXT:    vmov.32 q0[2], r3
; CHECK-NEXT:    vmov.32 q0[3], r0
; CHECK-NEXT:    vand q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %offs = load <4 x i8*>, <4 x i8*>* %offptr, align 4
  %gather = call <4 x i8> @llvm.masked.gather.v4i8.v4p0i8(<4 x i8*> %offs, i32 1, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x i8> undef)
  %ext = zext <4 x i8> %gather to <4 x i32>
  ret <4 x i32> %ext
}

define arm_aapcs_vfpcc <8 x i32> @ptr_v8i8_sext32(<8 x i8*>* %offptr) {
; CHECK-LABEL: ptr_v8i8_sext32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r7, lr}
; CHECK-NEXT:    push {r4, r5, r7, lr}
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    vldrw.u32 q1, [r0, #16]
; CHECK-NEXT:    vmov r1, s2
; CHECK-NEXT:    vmov r2, s3
; CHECK-NEXT:    vmov r3, s0
; CHECK-NEXT:    vmov r0, s4
; CHECK-NEXT:    vmov r5, s1
; CHECK-NEXT:    vmov r4, s7
; CHECK-NEXT:    ldrb.w r12, [r1]
; CHECK-NEXT:    vmov r1, s5
; CHECK-NEXT:    ldrb.w lr, [r2]
; CHECK-NEXT:    vmov r2, s6
; CHECK-NEXT:    ldrb r3, [r3]
; CHECK-NEXT:    ldrb r0, [r0]
; CHECK-NEXT:    ldrb r5, [r5]
; CHECK-NEXT:    vmov.32 q0[0], r3
; CHECK-NEXT:    vmov.32 q1[0], r0
; CHECK-NEXT:    ldrb r4, [r4]
; CHECK-NEXT:    vmov.32 q0[1], r5
; CHECK-NEXT:    vmov.32 q0[2], r12
; CHECK-NEXT:    vmov.32 q0[3], lr
; CHECK-NEXT:    vmovlb.s8 q0, q0
; CHECK-NEXT:    vmovlb.s16 q0, q0
; CHECK-NEXT:    ldrb r1, [r1]
; CHECK-NEXT:    ldrb r2, [r2]
; CHECK-NEXT:    vmov.32 q1[1], r1
; CHECK-NEXT:    vmov.32 q1[2], r2
; CHECK-NEXT:    vmov.32 q1[3], r4
; CHECK-NEXT:    vmovlb.s8 q1, q1
; CHECK-NEXT:    vmovlb.s16 q1, q1
; CHECK-NEXT:    pop {r4, r5, r7, pc}
entry:
  %offs = load <8 x i8*>, <8 x i8*>* %offptr, align 4
  %gather = call <8 x i8> @llvm.masked.gather.v8i8.v8p0i8(<8 x i8*> %offs, i32 1, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x i8> undef)
  %ext = sext <8 x i8> %gather to <8 x i32>
  ret <8 x i32> %ext
}

define arm_aapcs_vfpcc <8 x i32> @ptr_v8i8_zext32(<8 x i8*>* %offptr) {
; CHECK-LABEL: ptr_v8i8_zext32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r7, lr}
; CHECK-NEXT:    push {r4, r5, r7, lr}
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    vldrw.u32 q1, [r0, #16]
; CHECK-NEXT:    vmov r1, s2
; CHECK-NEXT:    vmov r2, s3
; CHECK-NEXT:    vmov r0, s4
; CHECK-NEXT:    vmov r4, s0
; CHECK-NEXT:    vmov r3, s5
; CHECK-NEXT:    vmov r5, s1
; CHECK-NEXT:    ldrb.w r12, [r1]
; CHECK-NEXT:    vmov r1, s6
; CHECK-NEXT:    ldrb.w lr, [r2]
; CHECK-NEXT:    vmov r2, s7
; CHECK-NEXT:    ldrb r0, [r0]
; CHECK-NEXT:    vmov.i32 q1, #0xff
; CHECK-NEXT:    ldrb r4, [r4]
; CHECK-NEXT:    ldrb r3, [r3]
; CHECK-NEXT:    vmov.32 q2[0], r0
; CHECK-NEXT:    ldrb r5, [r5]
; CHECK-NEXT:    vmov.32 q0[0], r4
; CHECK-NEXT:    vmov.32 q2[1], r3
; CHECK-NEXT:    vmov.32 q0[1], r5
; CHECK-NEXT:    vmov.32 q0[2], r12
; CHECK-NEXT:    vmov.32 q0[3], lr
; CHECK-NEXT:    vand q0, q0, q1
; CHECK-NEXT:    ldrb r1, [r1]
; CHECK-NEXT:    ldrb r2, [r2]
; CHECK-NEXT:    vmov.32 q2[2], r1
; CHECK-NEXT:    vmov.32 q2[3], r2
; CHECK-NEXT:    vand q1, q2, q1
; CHECK-NEXT:    pop {r4, r5, r7, pc}
entry:
  %offs = load <8 x i8*>, <8 x i8*>* %offptr, align 4
  %gather = call <8 x i8> @llvm.masked.gather.v8i8.v8p0i8(<8 x i8*> %offs, i32 1, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x i8> undef)
  %ext = zext <8 x i8> %gather to <8 x i32>
  ret <8 x i32> %ext
}

; loops

define void @foo_ptr_p_int32_t(i32* %dest, i32** %src, i32 %n) {
; CHECK-LABEL: foo_ptr_p_int32_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    bic r2, r2, #15
; CHECK-NEXT:    cmp r2, #1
; CHECK-NEXT:    it lt
; CHECK-NEXT:    poplt {r7, pc}
; CHECK-NEXT:    subs r2, #4
; CHECK-NEXT:    movs r3, #1
; CHECK-NEXT:    add.w lr, r3, r2, lsr #2
; CHECK-NEXT:    dls lr, lr
; CHECK-NEXT:  .LBB22_1: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrw.u32 q0, [r1], #16
; CHECK-NEXT:    vptt.i32 ne, q0, zr
; CHECK-NEXT:    vldrwt.u32 q1, [q0]
; CHECK-NEXT:    vstrwt.32 q1, [r0], #16
; CHECK-NEXT:    le lr, .LBB22_1
; CHECK-NEXT:  @ %bb.2: @ %for.end
; CHECK-NEXT:    pop {r7, pc}
entry:
  %and = and i32 %n, -16
  %cmp11 = icmp sgt i32 %and, 0
  br i1 %cmp11, label %vector.body, label %for.end

vector.body:                                      ; preds = %entry, %vector.body
  %index = phi i32 [ %index.next, %vector.body ], [ 0, %entry ]
  %0 = getelementptr inbounds i32*, i32** %src, i32 %index
  %1 = bitcast i32** %0 to <4 x i32*>*
  %wide.load = load <4 x i32*>, <4 x i32*>* %1, align 4
  %2 = icmp ne <4 x i32*> %wide.load, zeroinitializer
  %wide.masked.gather = call <4 x i32> @llvm.masked.gather.v4i32.v4p0i32(<4 x i32*> %wide.load, i32 4, <4 x i1> %2, <4 x i32> undef)
  %3 = getelementptr inbounds i32, i32* %dest, i32 %index
  %4 = bitcast i32* %3 to <4 x i32>*
  call void @llvm.masked.store.v4i32.p0v4i32(<4 x i32> %wide.masked.gather, <4 x i32>* %4, i32 4, <4 x i1> %2)
  %index.next = add i32 %index, 4
  %5 = icmp eq i32 %index.next, %and
  br i1 %5, label %for.end, label %vector.body

for.end:                                          ; preds = %vector.body, %entry
  ret void
}

define void @foo_ptr_p_float(float* %dest, float** %src, i32 %n) {
; CHECK-LABEL: foo_ptr_p_float:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    bic r2, r2, #15
; CHECK-NEXT:    cmp r2, #1
; CHECK-NEXT:    it lt
; CHECK-NEXT:    poplt {r7, pc}
; CHECK-NEXT:    subs r2, #4
; CHECK-NEXT:    movs r3, #1
; CHECK-NEXT:    add.w lr, r3, r2, lsr #2
; CHECK-NEXT:    dls lr, lr
; CHECK-NEXT:  .LBB23_1: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrw.u32 q0, [r1], #16
; CHECK-NEXT:    vptt.i32 ne, q0, zr
; CHECK-NEXT:    vldrwt.u32 q1, [q0]
; CHECK-NEXT:    vstrwt.32 q1, [r0], #16
; CHECK-NEXT:    le lr, .LBB23_1
; CHECK-NEXT:  @ %bb.2: @ %for.end
; CHECK-NEXT:    pop {r7, pc}
entry:
  %and = and i32 %n, -16
  %cmp11 = icmp sgt i32 %and, 0
  br i1 %cmp11, label %vector.body, label %for.end

vector.body:                                      ; preds = %entry, %vector.body
  %index = phi i32 [ %index.next, %vector.body ], [ 0, %entry ]
  %0 = getelementptr inbounds float*, float** %src, i32 %index
  %1 = bitcast float** %0 to <4 x float*>*
  %wide.load = load <4 x float*>, <4 x float*>* %1, align 4
  %2 = icmp ne <4 x float*> %wide.load, zeroinitializer
  %3 = bitcast <4 x float*> %wide.load to <4 x i32*>
  %wide.masked.gather = call <4 x i32> @llvm.masked.gather.v4i32.v4p0i32(<4 x i32*> %3, i32 4, <4 x i1> %2, <4 x i32> undef)
  %4 = getelementptr inbounds float, float* %dest, i32 %index
  %5 = bitcast float* %4 to <4 x i32>*
  call void @llvm.masked.store.v4i32.p0v4i32(<4 x i32> %wide.masked.gather, <4 x i32>* %5, i32 4, <4 x i1> %2)
  %index.next = add i32 %index, 4
  %6 = icmp eq i32 %index.next, %and
  br i1 %6, label %for.end, label %vector.body

for.end:                                          ; preds = %vector.body, %entry
  ret void
}

define arm_aapcs_vfpcc <4 x i32> @qi4(<4 x i32*> %p) {
; CHECK-LABEL: qi4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.i32 q1, #0x10
; CHECK-NEXT:    vadd.i32 q1, q0, q1
; CHECK-NEXT:    vldrw.u32 q0, [q1]
; CHECK-NEXT:    bx lr
entry:
  %g = getelementptr inbounds i32, <4 x i32*> %p, i32 4
  %gather = call <4 x i32> @llvm.masked.gather.v4i32.v4p0i32(<4 x i32*> %g, i32 4, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x i32> undef)
  ret <4 x i32> %gather
}

define arm_aapcs_vfpcc <8 x i32> @sext_unsigned_unscaled_i8_i8_toi64(i8* %base, <8 x i8>* %offptr) {
; CHECK-LABEL: sext_unsigned_unscaled_i8_i8_toi64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r7, lr}
; CHECK-NEXT:    push {r4, r5, r7, lr}
; CHECK-NEXT:    vldrb.u32 q0, [r1]
; CHECK-NEXT:    vldrb.u32 q1, [r1, #4]
; CHECK-NEXT:    vadd.i32 q0, q0, r0
; CHECK-NEXT:    vadd.i32 q1, q1, r0
; CHECK-NEXT:    vmov r2, s2
; CHECK-NEXT:    vmov r3, s3
; CHECK-NEXT:    vmov r0, s4
; CHECK-NEXT:    vmov r1, s5
; CHECK-NEXT:    vmov r5, s1
; CHECK-NEXT:    vmov r4, s7
; CHECK-NEXT:    ldrb.w r12, [r2]
; CHECK-NEXT:    vmov r2, s0
; CHECK-NEXT:    ldrb.w lr, [r3]
; CHECK-NEXT:    vmov r3, s6
; CHECK-NEXT:    ldrb r0, [r0]
; CHECK-NEXT:    ldrb r1, [r1]
; CHECK-NEXT:    ldrb r5, [r5]
; CHECK-NEXT:    vmov.32 q1[0], r0
; CHECK-NEXT:    ldrb r4, [r4]
; CHECK-NEXT:    vmov.32 q1[1], r1
; CHECK-NEXT:    ldrb r2, [r2]
; CHECK-NEXT:    ldrb r3, [r3]
; CHECK-NEXT:    vmov.32 q0[0], r2
; CHECK-NEXT:    vmov.32 q0[1], r5
; CHECK-NEXT:    vmov.32 q1[2], r3
; CHECK-NEXT:    vmov.32 q0[2], r12
; CHECK-NEXT:    vmov.32 q1[3], r4
; CHECK-NEXT:    vmov.32 q0[3], lr
; CHECK-NEXT:    vmovlb.s8 q1, q1
; CHECK-NEXT:    vmovlb.s8 q0, q0
; CHECK-NEXT:    vmovlb.s16 q1, q1
; CHECK-NEXT:    vmovlb.s16 q0, q0
; CHECK-NEXT:    pop {r4, r5, r7, pc}
entry:
  %offs = load <8 x i8>, <8 x i8>* %offptr, align 1
  %offs.zext = zext <8 x i8> %offs to <8 x i32>
  %ptrs = getelementptr inbounds i8, i8* %base, <8 x i32> %offs.zext
  %gather = call <8 x i8> @llvm.masked.gather.v8i8.v8p0i8(<8 x i8*> %ptrs, i32 1, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x i8> undef)
  %gather.sext = sext <8 x i8> %gather to <8 x i32>
  ret <8 x i32> %gather.sext
}

declare <2 x i32> @llvm.masked.gather.v2i32.v2p0i32(<2 x i32*>, i32, <2 x i1>, <2 x i32>)
declare <4 x i32> @llvm.masked.gather.v4i32.v4p0i32(<4 x i32*>, i32, <4 x i1>, <4 x i32>)
declare <8 x i32> @llvm.masked.gather.v8i32.v8p0i32(<8 x i32*>, i32, <8 x i1>, <8 x i32>)
declare <16 x i32> @llvm.masked.gather.v16i32.v16p0i32(<16 x i32*>, i32, <16 x i1>, <16 x i32>)
declare <2 x float> @llvm.masked.gather.v2f32.v2p0f32(<2 x float*>, i32, <2 x i1>, <2 x float>)
declare <4 x float> @llvm.masked.gather.v4f32.v4p0f32(<4 x float*>, i32, <4 x i1>, <4 x float>)
declare <8 x float> @llvm.masked.gather.v8f32.v8p0f32(<8 x float*>, i32, <8 x i1>, <8 x float>)
declare <2 x i16> @llvm.masked.gather.v2i16.v2p0i16(<2 x i16*>, i32, <2 x i1>, <2 x i16>)
declare <4 x i16> @llvm.masked.gather.v4i16.v4p0i16(<4 x i16*>, i32, <4 x i1>, <4 x i16>)
declare <8 x i16> @llvm.masked.gather.v8i16.v8p0i16(<8 x i16*>, i32, <8 x i1>, <8 x i16>)
declare <16 x i16> @llvm.masked.gather.v16i16.v16p0i16(<16 x i16*>, i32, <16 x i1>, <16 x i16>)
declare <4 x half> @llvm.masked.gather.v4f16.v4p0f16(<4 x half*>, i32, <4 x i1>, <4 x half>)
declare <8 x half> @llvm.masked.gather.v8f16.v8p0f16(<8 x half*>, i32, <8 x i1>, <8 x half>)
declare <16 x half> @llvm.masked.gather.v16f16.v16p0f16(<16 x half*>, i32, <16 x i1>, <16 x half>)
declare <4 x i8> @llvm.masked.gather.v4i8.v4p0i8(<4 x i8*>, i32, <4 x i1>, <4 x i8>)
declare <8 x i8> @llvm.masked.gather.v8i8.v8p0i8(<8 x i8*>, i32, <8 x i1>, <8 x i8>)
declare <16 x i8> @llvm.masked.gather.v16i8.v16p0i8(<16 x i8*>, i32, <16 x i1>, <16 x i8>)
declare <32 x i8> @llvm.masked.gather.v32i8.v32p0i8(<32 x i8*>, i32, <32 x i1>, <32 x i8>)
declare void @llvm.masked.store.v4i32.p0v4i32(<4 x i32>, <4 x i32>*, i32, <4 x i1>)
