; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve -verify-machineinstrs %s -o - | FileCheck %s --check-prefix=CHECK --check-prefix=CHECK-LE
; RUN: llc -mtriple=thumbebv8.1m.main-arm-none-eabi -mattr=+mve -verify-machineinstrs %s -o - | FileCheck %s --check-prefix=CHECK --check-prefix=CHECK-BE

define arm_aapcs_vfpcc <4 x i32> @load_v4i1(<4 x i1> *%src, <4 x i32> %a) {
; CHECK-LE-LABEL: load_v4i1:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    ldrb r0, [r0]
; CHECK-LE-NEXT:    vmov.i8 q1, #0x0
; CHECK-LE-NEXT:    vmov.i8 q2, #0xff
; CHECK-LE-NEXT:    vmsr p0, r0
; CHECK-LE-NEXT:    vpsel q1, q2, q1
; CHECK-LE-NEXT:    vmov.u8 r0, q1[0]
; CHECK-LE-NEXT:    vmov.32 q2[0], r0
; CHECK-LE-NEXT:    vmov.u8 r0, q1[1]
; CHECK-LE-NEXT:    vmov.32 q2[1], r0
; CHECK-LE-NEXT:    vmov.u8 r0, q1[2]
; CHECK-LE-NEXT:    vmov.32 q2[2], r0
; CHECK-LE-NEXT:    vmov.u8 r0, q1[3]
; CHECK-LE-NEXT:    vmov.32 q2[3], r0
; CHECK-LE-NEXT:    vmov.i32 q1, #0x0
; CHECK-LE-NEXT:    vcmp.i32 ne, q2, zr
; CHECK-LE-NEXT:    vpsel q0, q0, q1
; CHECK-LE-NEXT:    bx lr
;
; CHECK-BE-LABEL: load_v4i1:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    ldrb r0, [r0]
; CHECK-BE-NEXT:    vmov.i8 q1, #0x0
; CHECK-BE-NEXT:    vmov.i8 q2, #0xff
; CHECK-BE-NEXT:    vmsr p0, r0
; CHECK-BE-NEXT:    vpsel q1, q2, q1
; CHECK-BE-NEXT:    vmov.u8 r0, q1[0]
; CHECK-BE-NEXT:    vmov.32 q2[0], r0
; CHECK-BE-NEXT:    vmov.u8 r0, q1[1]
; CHECK-BE-NEXT:    vmov.32 q2[1], r0
; CHECK-BE-NEXT:    vmov.u8 r0, q1[2]
; CHECK-BE-NEXT:    vmov.32 q2[2], r0
; CHECK-BE-NEXT:    vmov.u8 r0, q1[3]
; CHECK-BE-NEXT:    vmov.32 q2[3], r0
; CHECK-BE-NEXT:    vrev64.32 q1, q0
; CHECK-BE-NEXT:    vcmp.i32 ne, q2, zr
; CHECK-BE-NEXT:    vmov.i32 q0, #0x0
; CHECK-BE-NEXT:    vpsel q1, q1, q0
; CHECK-BE-NEXT:    vrev64.32 q0, q1
; CHECK-BE-NEXT:    bx lr
entry:
  %c = load <4 x i1>, <4 x i1>* %src
  %s = select <4 x i1> %c, <4 x i32> %a, <4 x i32> zeroinitializer
  ret <4 x i32> %s
}

define arm_aapcs_vfpcc <8 x i16> @load_v8i1(<8 x i1> *%src, <8 x i16> %a) {
; CHECK-LE-LABEL: load_v8i1:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    ldrb r0, [r0]
; CHECK-LE-NEXT:    vmov.i8 q1, #0x0
; CHECK-LE-NEXT:    vmov.i8 q2, #0xff
; CHECK-LE-NEXT:    vmsr p0, r0
; CHECK-LE-NEXT:    vpsel q2, q2, q1
; CHECK-LE-NEXT:    vmov.u8 r0, q2[0]
; CHECK-LE-NEXT:    vmov.16 q1[0], r0
; CHECK-LE-NEXT:    vmov.u8 r0, q2[1]
; CHECK-LE-NEXT:    vmov.16 q1[1], r0
; CHECK-LE-NEXT:    vmov.u8 r0, q2[2]
; CHECK-LE-NEXT:    vmov.16 q1[2], r0
; CHECK-LE-NEXT:    vmov.u8 r0, q2[3]
; CHECK-LE-NEXT:    vmov.16 q1[3], r0
; CHECK-LE-NEXT:    vmov.u8 r0, q2[4]
; CHECK-LE-NEXT:    vmov.16 q1[4], r0
; CHECK-LE-NEXT:    vmov.u8 r0, q2[5]
; CHECK-LE-NEXT:    vmov.16 q1[5], r0
; CHECK-LE-NEXT:    vmov.u8 r0, q2[6]
; CHECK-LE-NEXT:    vmov.16 q1[6], r0
; CHECK-LE-NEXT:    vmov.u8 r0, q2[7]
; CHECK-LE-NEXT:    vmov.16 q1[7], r0
; CHECK-LE-NEXT:    vcmp.i16 ne, q1, zr
; CHECK-LE-NEXT:    vmov.i32 q1, #0x0
; CHECK-LE-NEXT:    vpsel q0, q0, q1
; CHECK-LE-NEXT:    bx lr
;
; CHECK-BE-LABEL: load_v8i1:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    ldrb r0, [r0]
; CHECK-BE-NEXT:    vmov.i8 q1, #0x0
; CHECK-BE-NEXT:    vmov.i8 q2, #0xff
; CHECK-BE-NEXT:    vmsr p0, r0
; CHECK-BE-NEXT:    vpsel q2, q2, q1
; CHECK-BE-NEXT:    vmov.u8 r0, q2[0]
; CHECK-BE-NEXT:    vmov.16 q1[0], r0
; CHECK-BE-NEXT:    vmov.u8 r0, q2[1]
; CHECK-BE-NEXT:    vmov.16 q1[1], r0
; CHECK-BE-NEXT:    vmov.u8 r0, q2[2]
; CHECK-BE-NEXT:    vmov.16 q1[2], r0
; CHECK-BE-NEXT:    vmov.u8 r0, q2[3]
; CHECK-BE-NEXT:    vmov.16 q1[3], r0
; CHECK-BE-NEXT:    vmov.u8 r0, q2[4]
; CHECK-BE-NEXT:    vmov.16 q1[4], r0
; CHECK-BE-NEXT:    vmov.u8 r0, q2[5]
; CHECK-BE-NEXT:    vmov.16 q1[5], r0
; CHECK-BE-NEXT:    vmov.u8 r0, q2[6]
; CHECK-BE-NEXT:    vmov.16 q1[6], r0
; CHECK-BE-NEXT:    vmov.u8 r0, q2[7]
; CHECK-BE-NEXT:    vmov.16 q1[7], r0
; CHECK-BE-NEXT:    vcmp.i16 ne, q1, zr
; CHECK-BE-NEXT:    vrev64.16 q1, q0
; CHECK-BE-NEXT:    vmov.i32 q0, #0x0
; CHECK-BE-NEXT:    vrev32.16 q0, q0
; CHECK-BE-NEXT:    vpsel q1, q1, q0
; CHECK-BE-NEXT:    vrev64.16 q0, q1
; CHECK-BE-NEXT:    bx lr
entry:
  %c = load <8 x i1>, <8 x i1>* %src
  %s = select <8 x i1> %c, <8 x i16> %a, <8 x i16> zeroinitializer
  ret <8 x i16> %s
}

define arm_aapcs_vfpcc <16 x i8> @load_v16i1(<16 x i1> *%src, <16 x i8> %a) {
; CHECK-LE-LABEL: load_v16i1:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    ldrh r0, [r0]
; CHECK-LE-NEXT:    vmov.i32 q1, #0x0
; CHECK-LE-NEXT:    vmsr p0, r0
; CHECK-LE-NEXT:    vpsel q0, q0, q1
; CHECK-LE-NEXT:    bx lr
;
; CHECK-BE-LABEL: load_v16i1:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    ldrh r0, [r0]
; CHECK-BE-NEXT:    vrev64.8 q1, q0
; CHECK-BE-NEXT:    vmov.i32 q0, #0x0
; CHECK-BE-NEXT:    vrev32.8 q0, q0
; CHECK-BE-NEXT:    vmsr p0, r0
; CHECK-BE-NEXT:    vpsel q1, q1, q0
; CHECK-BE-NEXT:    vrev64.8 q0, q1
; CHECK-BE-NEXT:    bx lr
entry:
  %c = load <16 x i1>, <16 x i1>* %src
  %s = select <16 x i1> %c, <16 x i8> %a, <16 x i8> zeroinitializer
  ret <16 x i8> %s
}

define arm_aapcs_vfpcc <2 x i64> @load_v2i1(<2 x i1> *%src, <2 x i64> %a) {
; CHECK-LE-LABEL: load_v2i1:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    ldrb r0, [r0]
; CHECK-LE-NEXT:    sbfx r1, r0, #0, #1
; CHECK-LE-NEXT:    sbfx r0, r0, #1, #1
; CHECK-LE-NEXT:    vmov.32 q1[0], r1
; CHECK-LE-NEXT:    vmov.32 q1[1], r1
; CHECK-LE-NEXT:    vmov.32 q1[2], r0
; CHECK-LE-NEXT:    vmov.32 q1[3], r0
; CHECK-LE-NEXT:    vand q0, q0, q1
; CHECK-LE-NEXT:    bx lr
;
; CHECK-BE-LABEL: load_v2i1:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    ldrb r0, [r0]
; CHECK-BE-NEXT:    sbfx r1, r0, #0, #1
; CHECK-BE-NEXT:    sbfx r0, r0, #1, #1
; CHECK-BE-NEXT:    vmov.32 q1[0], r1
; CHECK-BE-NEXT:    vmov.32 q1[1], r1
; CHECK-BE-NEXT:    vmov.32 q1[2], r0
; CHECK-BE-NEXT:    vmov.32 q1[3], r0
; CHECK-BE-NEXT:    vrev64.32 q2, q1
; CHECK-BE-NEXT:    vand q0, q0, q2
; CHECK-BE-NEXT:    bx lr
entry:
  %c = load <2 x i1>, <2 x i1>* %src
  %s = select <2 x i1> %c, <2 x i64> %a, <2 x i64> zeroinitializer
  ret <2 x i64> %s
}


define arm_aapcs_vfpcc void @store_v4i1(<4 x i1> *%dst, <4 x i32> %a) {
; CHECK-LE-LABEL: store_v4i1:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    vcmp.i32 eq, q0, zr
; CHECK-LE-NEXT:    movs r3, #0
; CHECK-LE-NEXT:    vmrs r1, p0
; CHECK-LE-NEXT:    and r2, r1, #1
; CHECK-LE-NEXT:    rsbs r2, r2, #0
; CHECK-LE-NEXT:    bfi r3, r2, #0, #1
; CHECK-LE-NEXT:    ubfx r2, r1, #4, #1
; CHECK-LE-NEXT:    rsbs r2, r2, #0
; CHECK-LE-NEXT:    bfi r3, r2, #1, #1
; CHECK-LE-NEXT:    ubfx r2, r1, #8, #1
; CHECK-LE-NEXT:    ubfx r1, r1, #12, #1
; CHECK-LE-NEXT:    rsbs r2, r2, #0
; CHECK-LE-NEXT:    bfi r3, r2, #2, #1
; CHECK-LE-NEXT:    rsbs r1, r1, #0
; CHECK-LE-NEXT:    bfi r3, r1, #3, #1
; CHECK-LE-NEXT:    strb r3, [r0]
; CHECK-LE-NEXT:    bx lr
;
; CHECK-BE-LABEL: store_v4i1:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    vrev64.32 q1, q0
; CHECK-BE-NEXT:    movs r3, #0
; CHECK-BE-NEXT:    vcmp.i32 eq, q1, zr
; CHECK-BE-NEXT:    vmrs r1, p0
; CHECK-BE-NEXT:    and r2, r1, #1
; CHECK-BE-NEXT:    rsbs r2, r2, #0
; CHECK-BE-NEXT:    bfi r3, r2, #0, #1
; CHECK-BE-NEXT:    ubfx r2, r1, #4, #1
; CHECK-BE-NEXT:    rsbs r2, r2, #0
; CHECK-BE-NEXT:    bfi r3, r2, #1, #1
; CHECK-BE-NEXT:    ubfx r2, r1, #8, #1
; CHECK-BE-NEXT:    ubfx r1, r1, #12, #1
; CHECK-BE-NEXT:    rsbs r2, r2, #0
; CHECK-BE-NEXT:    bfi r3, r2, #2, #1
; CHECK-BE-NEXT:    rsbs r1, r1, #0
; CHECK-BE-NEXT:    bfi r3, r1, #3, #1
; CHECK-BE-NEXT:    strb r3, [r0]
; CHECK-BE-NEXT:    bx lr
entry:
  %c = icmp eq <4 x i32> %a, zeroinitializer
  store <4 x i1> %c, <4 x i1>* %dst
  ret void
}

define arm_aapcs_vfpcc void @store_v8i1(<8 x i1> *%dst, <8 x i16> %a) {
; CHECK-LE-LABEL: store_v8i1:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    vcmp.i16 eq, q0, zr
; CHECK-LE-NEXT:    vmrs r2, p0
; CHECK-LE-NEXT:    and r1, r2, #1
; CHECK-LE-NEXT:    rsbs r3, r1, #0
; CHECK-LE-NEXT:    movs r1, #0
; CHECK-LE-NEXT:    bfi r1, r3, #0, #1
; CHECK-LE-NEXT:    ubfx r3, r2, #2, #1
; CHECK-LE-NEXT:    rsbs r3, r3, #0
; CHECK-LE-NEXT:    bfi r1, r3, #1, #1
; CHECK-LE-NEXT:    ubfx r3, r2, #4, #1
; CHECK-LE-NEXT:    rsbs r3, r3, #0
; CHECK-LE-NEXT:    bfi r1, r3, #2, #1
; CHECK-LE-NEXT:    ubfx r3, r2, #6, #1
; CHECK-LE-NEXT:    rsbs r3, r3, #0
; CHECK-LE-NEXT:    bfi r1, r3, #3, #1
; CHECK-LE-NEXT:    ubfx r3, r2, #8, #1
; CHECK-LE-NEXT:    rsbs r3, r3, #0
; CHECK-LE-NEXT:    bfi r1, r3, #4, #1
; CHECK-LE-NEXT:    ubfx r3, r2, #10, #1
; CHECK-LE-NEXT:    rsbs r3, r3, #0
; CHECK-LE-NEXT:    bfi r1, r3, #5, #1
; CHECK-LE-NEXT:    ubfx r3, r2, #12, #1
; CHECK-LE-NEXT:    ubfx r2, r2, #14, #1
; CHECK-LE-NEXT:    rsbs r3, r3, #0
; CHECK-LE-NEXT:    bfi r1, r3, #6, #1
; CHECK-LE-NEXT:    rsbs r2, r2, #0
; CHECK-LE-NEXT:    bfi r1, r2, #7, #1
; CHECK-LE-NEXT:    strb r1, [r0]
; CHECK-LE-NEXT:    bx lr
;
; CHECK-BE-LABEL: store_v8i1:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    vrev64.16 q1, q0
; CHECK-BE-NEXT:    vcmp.i16 eq, q1, zr
; CHECK-BE-NEXT:    vmrs r2, p0
; CHECK-BE-NEXT:    and r1, r2, #1
; CHECK-BE-NEXT:    rsbs r3, r1, #0
; CHECK-BE-NEXT:    movs r1, #0
; CHECK-BE-NEXT:    bfi r1, r3, #0, #1
; CHECK-BE-NEXT:    ubfx r3, r2, #2, #1
; CHECK-BE-NEXT:    rsbs r3, r3, #0
; CHECK-BE-NEXT:    bfi r1, r3, #1, #1
; CHECK-BE-NEXT:    ubfx r3, r2, #4, #1
; CHECK-BE-NEXT:    rsbs r3, r3, #0
; CHECK-BE-NEXT:    bfi r1, r3, #2, #1
; CHECK-BE-NEXT:    ubfx r3, r2, #6, #1
; CHECK-BE-NEXT:    rsbs r3, r3, #0
; CHECK-BE-NEXT:    bfi r1, r3, #3, #1
; CHECK-BE-NEXT:    ubfx r3, r2, #8, #1
; CHECK-BE-NEXT:    rsbs r3, r3, #0
; CHECK-BE-NEXT:    bfi r1, r3, #4, #1
; CHECK-BE-NEXT:    ubfx r3, r2, #10, #1
; CHECK-BE-NEXT:    rsbs r3, r3, #0
; CHECK-BE-NEXT:    bfi r1, r3, #5, #1
; CHECK-BE-NEXT:    ubfx r3, r2, #12, #1
; CHECK-BE-NEXT:    ubfx r2, r2, #14, #1
; CHECK-BE-NEXT:    rsbs r3, r3, #0
; CHECK-BE-NEXT:    bfi r1, r3, #6, #1
; CHECK-BE-NEXT:    rsbs r2, r2, #0
; CHECK-BE-NEXT:    bfi r1, r2, #7, #1
; CHECK-BE-NEXT:    strb r1, [r0]
; CHECK-BE-NEXT:    bx lr
entry:
  %c = icmp eq <8 x i16> %a, zeroinitializer
  store <8 x i1> %c, <8 x i1>* %dst
  ret void
}

define arm_aapcs_vfpcc void @store_v16i1(<16 x i1> *%dst, <16 x i8> %a) {
; CHECK-LE-LABEL: store_v16i1:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    vcmp.i8 eq, q0, zr
; CHECK-LE-NEXT:    vmrs r1, p0
; CHECK-LE-NEXT:    strh r1, [r0]
; CHECK-LE-NEXT:    bx lr
;
; CHECK-BE-LABEL: store_v16i1:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    vrev64.8 q1, q0
; CHECK-BE-NEXT:    vcmp.i8 eq, q1, zr
; CHECK-BE-NEXT:    vmrs r1, p0
; CHECK-BE-NEXT:    strh r1, [r0]
; CHECK-BE-NEXT:    bx lr
entry:
  %c = icmp eq <16 x i8> %a, zeroinitializer
  store <16 x i1> %c, <16 x i1>* %dst
  ret void
}

define arm_aapcs_vfpcc void @store_v2i1(<2 x i1> *%dst, <2 x i64> %a) {
; CHECK-LE-LABEL: store_v2i1:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    vmov r1, s1
; CHECK-LE-NEXT:    vmov r2, s0
; CHECK-LE-NEXT:    vmov r3, s2
; CHECK-LE-NEXT:    orrs r1, r2
; CHECK-LE-NEXT:    vmov r2, s3
; CHECK-LE-NEXT:    cset r1, eq
; CHECK-LE-NEXT:    orrs r2, r3
; CHECK-LE-NEXT:    cset r2, eq
; CHECK-LE-NEXT:    ands r2, r2, #1
; CHECK-LE-NEXT:    it ne
; CHECK-LE-NEXT:    mvnne r2, #1
; CHECK-LE-NEXT:    bfi r2, r1, #0, #1
; CHECK-LE-NEXT:    and r1, r2, #3
; CHECK-LE-NEXT:    strb r1, [r0]
; CHECK-LE-NEXT:    bx lr
;
; CHECK-BE-LABEL: store_v2i1:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    vrev64.32 q1, q0
; CHECK-BE-NEXT:    vmov r1, s6
; CHECK-BE-NEXT:    vmov r2, s7
; CHECK-BE-NEXT:    vmov r3, s5
; CHECK-BE-NEXT:    orrs r1, r2
; CHECK-BE-NEXT:    vmov r2, s4
; CHECK-BE-NEXT:    cset r1, eq
; CHECK-BE-NEXT:    orrs r2, r3
; CHECK-BE-NEXT:    cset r2, eq
; CHECK-BE-NEXT:    ands r2, r2, #1
; CHECK-BE-NEXT:    it ne
; CHECK-BE-NEXT:    mvnne r2, #1
; CHECK-BE-NEXT:    bfi r2, r1, #0, #1
; CHECK-BE-NEXT:    and r1, r2, #3
; CHECK-BE-NEXT:    strb r1, [r0]
; CHECK-BE-NEXT:    bx lr
entry:
  %c = icmp eq <2 x i64> %a, zeroinitializer
  store <2 x i1> %c, <2 x i1>* %dst
  ret void
}
