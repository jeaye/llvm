; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-arm-none-eabi -mattr=+mve -verify-machineinstrs %s -o - | FileCheck %s

define arm_aapcs_vfpcc <16 x i8> @sadd_int8_t(<16 x i8> %src1, <16 x i8> %src2) {
; CHECK-LABEL: sadd_int8_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vqadd.s8 q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = call <16 x i8> @llvm.sadd.sat.v16i8(<16 x i8> %src1, <16 x i8> %src2)
  ret <16 x i8> %0
}

define arm_aapcs_vfpcc <8 x i16> @sadd_int16_t(<8 x i16> %src1, <8 x i16> %src2) {
; CHECK-LABEL: sadd_int16_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vqadd.s16 q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = call <8 x i16> @llvm.sadd.sat.v8i16(<8 x i16> %src1, <8 x i16> %src2)
  ret <8 x i16> %0
}

define arm_aapcs_vfpcc <4 x i32> @sadd_int32_t(<4 x i32> %src1, <4 x i32> %src2) {
; CHECK-LABEL: sadd_int32_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vqadd.s32 q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = call <4 x i32> @llvm.sadd.sat.v4i32(<4 x i32> %src1, <4 x i32> %src2)
  ret <4 x i32> %0
}

define arm_aapcs_vfpcc <2 x i64> @sadd_int64_t(<2 x i64> %src1, <2 x i64> %src2) {
; CHECK-LABEL: sadd_int64_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r6, r7, r8, lr}
; CHECK-NEXT:    push.w {r4, r5, r6, r7, r8, lr}
; CHECK-NEXT:    vmov r0, s4
; CHECK-NEXT:    vmov r5, s0
; CHECK-NEXT:    vmov r8, s5
; CHECK-NEXT:    vmov r4, s1
; CHECK-NEXT:    vmov r7, s2
; CHECK-NEXT:    vmov r3, s7
; CHECK-NEXT:    vmov r6, s3
; CHECK-NEXT:    adds.w r12, r5, r0
; CHECK-NEXT:    adc.w r0, r4, r8
; CHECK-NEXT:    asrs r2, r0, #31
; CHECK-NEXT:    vmov.32 q2[0], r2
; CHECK-NEXT:    vmov.32 q2[1], r2
; CHECK-NEXT:    vmov r2, s6
; CHECK-NEXT:    adds.w lr, r7, r2
; CHECK-NEXT:    adc.w r2, r6, r3
; CHECK-NEXT:    subs.w r5, r12, r5
; CHECK-NEXT:    sbcs.w r4, r0, r4
; CHECK-NEXT:    asr.w r1, r2, #31
; CHECK-NEXT:    mov.w r4, #0
; CHECK-NEXT:    vmov.32 q2[2], r1
; CHECK-NEXT:    it lt
; CHECK-NEXT:    movlt r4, #1
; CHECK-NEXT:    vmov.32 q2[3], r1
; CHECK-NEXT:    adr r1, .LCPI3_0
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    adr r1, .LCPI3_1
; CHECK-NEXT:    vldrw.u32 q1, [r1]
; CHECK-NEXT:    cmp r4, #0
; CHECK-NEXT:    vbic q0, q0, q2
; CHECK-NEXT:    csetm r4, ne
; CHECK-NEXT:    vand q1, q1, q2
; CHECK-NEXT:    movs r1, #0
; CHECK-NEXT:    vorr q0, q1, q0
; CHECK-NEXT:    vmov.32 q1[0], r4
; CHECK-NEXT:    vmov.32 q1[1], r4
; CHECK-NEXT:    subs.w r4, lr, r7
; CHECK-NEXT:    sbcs.w r4, r2, r6
; CHECK-NEXT:    it lt
; CHECK-NEXT:    movlt r1, #1
; CHECK-NEXT:    cmp r1, #0
; CHECK-NEXT:    csetm r1, ne
; CHECK-NEXT:    vmov.32 q1[2], r1
; CHECK-NEXT:    vmov.32 q1[3], r1
; CHECK-NEXT:    asr.w r1, r8, #31
; CHECK-NEXT:    vmov.32 q2[0], r1
; CHECK-NEXT:    vmov.32 q2[1], r1
; CHECK-NEXT:    asrs r1, r3, #31
; CHECK-NEXT:    vmov.32 q2[2], r1
; CHECK-NEXT:    vmov.32 q2[3], r1
; CHECK-NEXT:    veor q1, q2, q1
; CHECK-NEXT:    vmov.32 q2[0], r12
; CHECK-NEXT:    vmov.32 q2[1], r0
; CHECK-NEXT:    vand q0, q0, q1
; CHECK-NEXT:    vmov.32 q2[2], lr
; CHECK-NEXT:    vmov.32 q2[3], r2
; CHECK-NEXT:    vbic q1, q2, q1
; CHECK-NEXT:    vorr q0, q0, q1
; CHECK-NEXT:    pop.w {r4, r5, r6, r7, r8, pc}
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI3_0:
; CHECK-NEXT:    .long 0 @ 0x0
; CHECK-NEXT:    .long 2147483648 @ 0x80000000
; CHECK-NEXT:    .long 0 @ 0x0
; CHECK-NEXT:    .long 2147483648 @ 0x80000000
; CHECK-NEXT:  .LCPI3_1:
; CHECK-NEXT:    .long 4294967295 @ 0xffffffff
; CHECK-NEXT:    .long 2147483647 @ 0x7fffffff
; CHECK-NEXT:    .long 4294967295 @ 0xffffffff
; CHECK-NEXT:    .long 2147483647 @ 0x7fffffff
entry:
  %0 = call <2 x i64> @llvm.sadd.sat.v2i64(<2 x i64> %src1, <2 x i64> %src2)
  ret <2 x i64> %0
}

define arm_aapcs_vfpcc <16 x i8> @uadd_int8_t(<16 x i8> %src1, <16 x i8> %src2) {
; CHECK-LABEL: uadd_int8_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vqadd.u8 q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = call <16 x i8> @llvm.uadd.sat.v16i8(<16 x i8> %src1, <16 x i8> %src2)
  ret <16 x i8> %0
}

define arm_aapcs_vfpcc <8 x i16> @uadd_int16_t(<8 x i16> %src1, <8 x i16> %src2) {
; CHECK-LABEL: uadd_int16_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vqadd.u16 q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = call <8 x i16> @llvm.uadd.sat.v8i16(<8 x i16> %src1, <8 x i16> %src2)
  ret <8 x i16> %0
}

define arm_aapcs_vfpcc <4 x i32> @uadd_int32_t(<4 x i32> %src1, <4 x i32> %src2) {
; CHECK-LABEL: uadd_int32_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vqadd.u32 q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = call <4 x i32> @llvm.uadd.sat.v4i32(<4 x i32> %src1, <4 x i32> %src2)
  ret <4 x i32> %0
}

define arm_aapcs_vfpcc <2 x i64> @uadd_int64_t(<2 x i64> %src1, <2 x i64> %src2) {
; CHECK-LABEL: uadd_int64_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, lr}
; CHECK-NEXT:    push {r4, lr}
; CHECK-NEXT:    vmov r2, s4
; CHECK-NEXT:    vmov r3, s0
; CHECK-NEXT:    vmov r0, s5
; CHECK-NEXT:    vmov r1, s1
; CHECK-NEXT:    vmov r4, s2
; CHECK-NEXT:    adds.w lr, r3, r2
; CHECK-NEXT:    vmov r2, s6
; CHECK-NEXT:    adc.w r12, r1, r0
; CHECK-NEXT:    subs.w r3, lr, r3
; CHECK-NEXT:    sbcs.w r1, r12, r1
; CHECK-NEXT:    vmov r3, s3
; CHECK-NEXT:    mov.w r1, #0
; CHECK-NEXT:    mov.w r0, #0
; CHECK-NEXT:    it lo
; CHECK-NEXT:    movlo r1, #1
; CHECK-NEXT:    cmp r1, #0
; CHECK-NEXT:    csetm r1, ne
; CHECK-NEXT:    vmov.32 q0[0], lr
; CHECK-NEXT:    vmov.32 q2[0], r1
; CHECK-NEXT:    vmov.32 q0[1], r12
; CHECK-NEXT:    vmov.32 q2[1], r1
; CHECK-NEXT:    vmov r1, s7
; CHECK-NEXT:    adds r2, r2, r4
; CHECK-NEXT:    vmov.32 q0[2], r2
; CHECK-NEXT:    adcs r1, r3
; CHECK-NEXT:    subs r4, r2, r4
; CHECK-NEXT:    sbcs.w r3, r1, r3
; CHECK-NEXT:    it lo
; CHECK-NEXT:    movlo r0, #1
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:    vmov.32 q0[3], r1
; CHECK-NEXT:    csetm r0, ne
; CHECK-NEXT:    vmov.32 q2[2], r0
; CHECK-NEXT:    vmov.32 q2[3], r0
; CHECK-NEXT:    vorr q0, q0, q2
; CHECK-NEXT:    pop {r4, pc}
entry:
  %0 = call <2 x i64> @llvm.uadd.sat.v2i64(<2 x i64> %src1, <2 x i64> %src2)
  ret <2 x i64> %0
}


define arm_aapcs_vfpcc <16 x i8> @ssub_int8_t(<16 x i8> %src1, <16 x i8> %src2) {
; CHECK-LABEL: ssub_int8_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .vsave {d8, d9}
; CHECK-NEXT:    vpush {d8, d9}
; CHECK-NEXT:    vsub.i8 q2, q0, q1
; CHECK-NEXT:    vmov.i8 q3, #0x80
; CHECK-NEXT:    vcmp.s8 lt, q2, zr
; CHECK-NEXT:    vmov.i8 q4, #0x7f
; CHECK-NEXT:    vpsel q3, q4, q3
; CHECK-NEXT:    vcmp.s8 gt, q0, q2
; CHECK-NEXT:    vmrs r0, p0
; CHECK-NEXT:    vcmp.s8 gt, q1, zr
; CHECK-NEXT:    vmrs r1, p0
; CHECK-NEXT:    eors r0, r1
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpsel q0, q3, q2
; CHECK-NEXT:    vpop {d8, d9}
; CHECK-NEXT:    bx lr
entry:
  %0 = call <16 x i8> @llvm.ssub.sat.v16i8(<16 x i8> %src1, <16 x i8> %src2)
  ret <16 x i8> %0
}

define arm_aapcs_vfpcc <8 x i16> @ssub_int16_t(<8 x i16> %src1, <8 x i16> %src2) {
; CHECK-LABEL: ssub_int16_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .vsave {d8, d9}
; CHECK-NEXT:    vpush {d8, d9}
; CHECK-NEXT:    vsub.i16 q2, q0, q1
; CHECK-NEXT:    vmov.i16 q3, #0x8000
; CHECK-NEXT:    vcmp.s16 lt, q2, zr
; CHECK-NEXT:    vmvn.i16 q4, #0x8000
; CHECK-NEXT:    vpsel q3, q4, q3
; CHECK-NEXT:    vcmp.s16 gt, q0, q2
; CHECK-NEXT:    vmrs r0, p0
; CHECK-NEXT:    vcmp.s16 gt, q1, zr
; CHECK-NEXT:    vmrs r1, p0
; CHECK-NEXT:    eors r0, r1
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpsel q0, q3, q2
; CHECK-NEXT:    vpop {d8, d9}
; CHECK-NEXT:    bx lr
entry:
  %0 = call <8 x i16> @llvm.ssub.sat.v8i16(<8 x i16> %src1, <8 x i16> %src2)
  ret <8 x i16> %0
}

define arm_aapcs_vfpcc <4 x i32> @ssub_int32_t(<4 x i32> %src1, <4 x i32> %src2) {
; CHECK-LABEL: ssub_int32_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .vsave {d8, d9}
; CHECK-NEXT:    vpush {d8, d9}
; CHECK-NEXT:    vsub.i32 q2, q0, q1
; CHECK-NEXT:    vmov.i32 q3, #0x80000000
; CHECK-NEXT:    vcmp.s32 lt, q2, zr
; CHECK-NEXT:    vmvn.i32 q4, #0x80000000
; CHECK-NEXT:    vpsel q3, q4, q3
; CHECK-NEXT:    vcmp.s32 gt, q0, q2
; CHECK-NEXT:    vmrs r0, p0
; CHECK-NEXT:    vcmp.s32 gt, q1, zr
; CHECK-NEXT:    vmrs r1, p0
; CHECK-NEXT:    eors r0, r1
; CHECK-NEXT:    vmsr p0, r0
; CHECK-NEXT:    vpsel q0, q3, q2
; CHECK-NEXT:    vpop {d8, d9}
; CHECK-NEXT:    bx lr
entry:
  %0 = call <4 x i32> @llvm.ssub.sat.v4i32(<4 x i32> %src1, <4 x i32> %src2)
  ret <4 x i32> %0
}

define arm_aapcs_vfpcc <2 x i64> @ssub_int64_t(<2 x i64> %src1, <2 x i64> %src2) {
; CHECK-LABEL: ssub_int64_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r6, lr}
; CHECK-NEXT:    push {r4, r5, r6, lr}
; CHECK-NEXT:    .vsave {d8, d9}
; CHECK-NEXT:    vpush {d8, d9}
; CHECK-NEXT:    vmov r2, s4
; CHECK-NEXT:    movs r0, #0
; CHECK-NEXT:    vmov lr, s5
; CHECK-NEXT:    vmov r12, s7
; CHECK-NEXT:    vmov r5, s0
; CHECK-NEXT:    vmov r4, s1
; CHECK-NEXT:    rsbs r3, r2, #0
; CHECK-NEXT:    sbcs.w r3, r0, lr
; CHECK-NEXT:    mov.w r3, #0
; CHECK-NEXT:    it lt
; CHECK-NEXT:    movlt r3, #1
; CHECK-NEXT:    cmp r3, #0
; CHECK-NEXT:    csetm r3, ne
; CHECK-NEXT:    vmov.32 q2[0], r3
; CHECK-NEXT:    vmov.32 q2[1], r3
; CHECK-NEXT:    vmov r3, s6
; CHECK-NEXT:    rsbs r1, r3, #0
; CHECK-NEXT:    sbcs.w r1, r0, r12
; CHECK-NEXT:    mov.w r1, #0
; CHECK-NEXT:    it lt
; CHECK-NEXT:    movlt r1, #1
; CHECK-NEXT:    cmp r1, #0
; CHECK-NEXT:    csetm r1, ne
; CHECK-NEXT:    subs r6, r5, r2
; CHECK-NEXT:    vmov.32 q2[2], r1
; CHECK-NEXT:    vmov.32 q2[3], r1
; CHECK-NEXT:    sbc.w r1, r4, lr
; CHECK-NEXT:    subs r5, r6, r5
; CHECK-NEXT:    sbcs.w r5, r1, r4
; CHECK-NEXT:    vmov r4, s2
; CHECK-NEXT:    mov.w r5, #0
; CHECK-NEXT:    it lt
; CHECK-NEXT:    movlt r5, #1
; CHECK-NEXT:    cmp r5, #0
; CHECK-NEXT:    csetm r5, ne
; CHECK-NEXT:    vmov.32 q1[0], r5
; CHECK-NEXT:    vmov.32 q1[1], r5
; CHECK-NEXT:    vmov r5, s3
; CHECK-NEXT:    subs r3, r4, r3
; CHECK-NEXT:    sbc.w r2, r5, r12
; CHECK-NEXT:    subs r4, r3, r4
; CHECK-NEXT:    sbcs.w r5, r2, r5
; CHECK-NEXT:    it lt
; CHECK-NEXT:    movlt r0, #1
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:    csetm r0, ne
; CHECK-NEXT:    vmov.32 q1[2], r0
; CHECK-NEXT:    vmov.32 q1[3], r0
; CHECK-NEXT:    asrs r0, r1, #31
; CHECK-NEXT:    veor q0, q2, q1
; CHECK-NEXT:    vmov.32 q2[0], r0
; CHECK-NEXT:    vmov.32 q2[1], r0
; CHECK-NEXT:    asrs r0, r2, #31
; CHECK-NEXT:    vmov.32 q2[2], r0
; CHECK-NEXT:    vmov.32 q1[0], r6
; CHECK-NEXT:    vmov.32 q2[3], r0
; CHECK-NEXT:    adr r0, .LCPI11_0
; CHECK-NEXT:    vldrw.u32 q3, [r0]
; CHECK-NEXT:    adr r0, .LCPI11_1
; CHECK-NEXT:    vldrw.u32 q4, [r0]
; CHECK-NEXT:    vmov.32 q1[1], r1
; CHECK-NEXT:    vmov.32 q1[2], r3
; CHECK-NEXT:    vbic q3, q3, q2
; CHECK-NEXT:    vand q2, q4, q2
; CHECK-NEXT:    vmov.32 q1[3], r2
; CHECK-NEXT:    vorr q2, q2, q3
; CHECK-NEXT:    vbic q1, q1, q0
; CHECK-NEXT:    vand q0, q2, q0
; CHECK-NEXT:    vorr q0, q0, q1
; CHECK-NEXT:    vpop {d8, d9}
; CHECK-NEXT:    pop {r4, r5, r6, pc}
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI11_0:
; CHECK-NEXT:    .long 0 @ 0x0
; CHECK-NEXT:    .long 2147483648 @ 0x80000000
; CHECK-NEXT:    .long 0 @ 0x0
; CHECK-NEXT:    .long 2147483648 @ 0x80000000
; CHECK-NEXT:  .LCPI11_1:
; CHECK-NEXT:    .long 4294967295 @ 0xffffffff
; CHECK-NEXT:    .long 2147483647 @ 0x7fffffff
; CHECK-NEXT:    .long 4294967295 @ 0xffffffff
; CHECK-NEXT:    .long 2147483647 @ 0x7fffffff
entry:
  %0 = call <2 x i64> @llvm.ssub.sat.v2i64(<2 x i64> %src1, <2 x i64> %src2)
  ret <2 x i64> %0
}

define arm_aapcs_vfpcc <16 x i8> @usub_int8_t(<16 x i8> %src1, <16 x i8> %src2) {
; CHECK-LABEL: usub_int8_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmax.u8 q0, q0, q1
; CHECK-NEXT:    vsub.i8 q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = call <16 x i8> @llvm.usub.sat.v16i8(<16 x i8> %src1, <16 x i8> %src2)
  ret <16 x i8> %0
}

define arm_aapcs_vfpcc <8 x i16> @usub_int16_t(<8 x i16> %src1, <8 x i16> %src2) {
; CHECK-LABEL: usub_int16_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmax.u16 q0, q0, q1
; CHECK-NEXT:    vsub.i16 q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = call <8 x i16> @llvm.usub.sat.v8i16(<8 x i16> %src1, <8 x i16> %src2)
  ret <8 x i16> %0
}

define arm_aapcs_vfpcc <4 x i32> @usub_int32_t(<4 x i32> %src1, <4 x i32> %src2) {
; CHECK-LABEL: usub_int32_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmax.u32 q0, q0, q1
; CHECK-NEXT:    vsub.i32 q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = call <4 x i32> @llvm.usub.sat.v4i32(<4 x i32> %src1, <4 x i32> %src2)
  ret <4 x i32> %0
}

define arm_aapcs_vfpcc <2 x i64> @usub_int64_t(<2 x i64> %src1, <2 x i64> %src2) {
; CHECK-LABEL: usub_int64_t:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, lr}
; CHECK-NEXT:    push {r4, lr}
; CHECK-NEXT:    vmov r2, s4
; CHECK-NEXT:    vmov r3, s0
; CHECK-NEXT:    vmov r0, s5
; CHECK-NEXT:    vmov r1, s1
; CHECK-NEXT:    vmov r4, s2
; CHECK-NEXT:    subs.w lr, r3, r2
; CHECK-NEXT:    vmov r2, s6
; CHECK-NEXT:    sbc.w r12, r1, r0
; CHECK-NEXT:    subs.w r3, r3, lr
; CHECK-NEXT:    sbcs.w r1, r1, r12
; CHECK-NEXT:    vmov r3, s3
; CHECK-NEXT:    mov.w r1, #0
; CHECK-NEXT:    mov.w r0, #0
; CHECK-NEXT:    it lo
; CHECK-NEXT:    movlo r1, #1
; CHECK-NEXT:    cmp r1, #0
; CHECK-NEXT:    csetm r1, ne
; CHECK-NEXT:    vmov.32 q0[0], lr
; CHECK-NEXT:    vmov.32 q2[0], r1
; CHECK-NEXT:    vmov.32 q0[1], r12
; CHECK-NEXT:    vmov.32 q2[1], r1
; CHECK-NEXT:    vmov r1, s7
; CHECK-NEXT:    subs r2, r4, r2
; CHECK-NEXT:    vmov.32 q0[2], r2
; CHECK-NEXT:    sbc.w r1, r3, r1
; CHECK-NEXT:    subs r4, r4, r2
; CHECK-NEXT:    sbcs r3, r1
; CHECK-NEXT:    it lo
; CHECK-NEXT:    movlo r0, #1
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:    vmov.32 q0[3], r1
; CHECK-NEXT:    csetm r0, ne
; CHECK-NEXT:    vmov.32 q2[2], r0
; CHECK-NEXT:    vmov.32 q2[3], r0
; CHECK-NEXT:    vbic q0, q0, q2
; CHECK-NEXT:    pop {r4, pc}
entry:
  %0 = call <2 x i64> @llvm.usub.sat.v2i64(<2 x i64> %src1, <2 x i64> %src2)
  ret <2 x i64> %0
}


declare <16 x i8> @llvm.sadd.sat.v16i8(<16 x i8> %src1, <16 x i8> %src2)
declare <8 x i16> @llvm.sadd.sat.v8i16(<8 x i16> %src1, <8 x i16> %src2)
declare <4 x i32> @llvm.sadd.sat.v4i32(<4 x i32> %src1, <4 x i32> %src2)
declare <2 x i64> @llvm.sadd.sat.v2i64(<2 x i64> %src1, <2 x i64> %src2)
declare <16 x i8> @llvm.uadd.sat.v16i8(<16 x i8> %src1, <16 x i8> %src2)
declare <8 x i16> @llvm.uadd.sat.v8i16(<8 x i16> %src1, <8 x i16> %src2)
declare <4 x i32> @llvm.uadd.sat.v4i32(<4 x i32> %src1, <4 x i32> %src2)
declare <2 x i64> @llvm.uadd.sat.v2i64(<2 x i64> %src1, <2 x i64> %src2)
declare <16 x i8> @llvm.ssub.sat.v16i8(<16 x i8> %src1, <16 x i8> %src2)
declare <8 x i16> @llvm.ssub.sat.v8i16(<8 x i16> %src1, <8 x i16> %src2)
declare <4 x i32> @llvm.ssub.sat.v4i32(<4 x i32> %src1, <4 x i32> %src2)
declare <2 x i64> @llvm.ssub.sat.v2i64(<2 x i64> %src1, <2 x i64> %src2)
declare <16 x i8> @llvm.usub.sat.v16i8(<16 x i8> %src1, <16 x i8> %src2)
declare <8 x i16> @llvm.usub.sat.v8i16(<8 x i16> %src1, <8 x i16> %src2)
declare <4 x i32> @llvm.usub.sat.v4i32(<4 x i32> %src1, <4 x i32> %src2)
declare <2 x i64> @llvm.usub.sat.v2i64(<2 x i64> %src1, <2 x i64> %src2)
