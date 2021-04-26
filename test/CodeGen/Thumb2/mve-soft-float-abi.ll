; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-none-eabi -mattr=+mve -o - %s | FileCheck %s --check-prefixes=CHECK-LE,CHECK-MVE
; RUN: llc -mtriple=thumbebv8.1m.main-none-eabi -mattr=+mve -o - %s | FileCheck %s --check-prefix=CHECK-BE
; RUN: llc -mtriple=thumbv8.1m.main-none-eabi -mattr=+mve.fp -o - %s | FileCheck %s --check-prefixes=CHECK-LE,CHECK-FP

define <16 x i8> @vector_add_i8(<16 x i8> %lhs, <16 x i8> %rhs) {
; CHECK-LE-LABEL: vector_add_i8:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    vmov d1, r2, r3
; CHECK-LE-NEXT:    vmov d0, r0, r1
; CHECK-LE-NEXT:    mov r0, sp
; CHECK-LE-NEXT:    vldrw.u32 q1, [r0]
; CHECK-LE-NEXT:    vadd.i8 q0, q0, q1
; CHECK-LE-NEXT:    vmov r0, r1, d0
; CHECK-LE-NEXT:    vmov r2, r3, d1
; CHECK-LE-NEXT:    bx lr
;
; CHECK-BE-LABEL: vector_add_i8:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    vmov d1, r3, r2
; CHECK-BE-NEXT:    vmov d0, r1, r0
; CHECK-BE-NEXT:    mov r0, sp
; CHECK-BE-NEXT:    vrev64.8 q1, q0
; CHECK-BE-NEXT:    vldrb.u8 q0, [r0]
; CHECK-BE-NEXT:    vadd.i8 q0, q1, q0
; CHECK-BE-NEXT:    vrev64.8 q1, q0
; CHECK-BE-NEXT:    vmov r1, r0, d2
; CHECK-BE-NEXT:    vmov r3, r2, d3
; CHECK-BE-NEXT:    bx lr
entry:
  %sum = add <16 x i8> %lhs, %rhs
  ret <16 x i8> %sum
}

define <8 x i16> @vector_add_i16(<8 x i16> %lhs, <8 x i16> %rhs) {
; CHECK-LE-LABEL: vector_add_i16:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    vmov d1, r2, r3
; CHECK-LE-NEXT:    vmov d0, r0, r1
; CHECK-LE-NEXT:    mov r0, sp
; CHECK-LE-NEXT:    vldrw.u32 q1, [r0]
; CHECK-LE-NEXT:    vadd.i16 q0, q0, q1
; CHECK-LE-NEXT:    vmov r0, r1, d0
; CHECK-LE-NEXT:    vmov r2, r3, d1
; CHECK-LE-NEXT:    bx lr
;
; CHECK-BE-LABEL: vector_add_i16:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    vmov d1, r3, r2
; CHECK-BE-NEXT:    vmov d0, r1, r0
; CHECK-BE-NEXT:    mov r0, sp
; CHECK-BE-NEXT:    vrev64.16 q1, q0
; CHECK-BE-NEXT:    vldrh.u16 q0, [r0]
; CHECK-BE-NEXT:    vadd.i16 q0, q1, q0
; CHECK-BE-NEXT:    vrev64.16 q1, q0
; CHECK-BE-NEXT:    vmov r1, r0, d2
; CHECK-BE-NEXT:    vmov r3, r2, d3
; CHECK-BE-NEXT:    bx lr
entry:
  %sum = add <8 x i16> %lhs, %rhs
  ret <8 x i16> %sum
}

define <4 x i32> @vector_add_i32(<4 x i32> %lhs, <4 x i32> %rhs) {
; CHECK-LE-LABEL: vector_add_i32:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    vmov d1, r2, r3
; CHECK-LE-NEXT:    vmov d0, r0, r1
; CHECK-LE-NEXT:    mov r0, sp
; CHECK-LE-NEXT:    vldrw.u32 q1, [r0]
; CHECK-LE-NEXT:    vadd.i32 q0, q0, q1
; CHECK-LE-NEXT:    vmov r0, r1, d0
; CHECK-LE-NEXT:    vmov r2, r3, d1
; CHECK-LE-NEXT:    bx lr
;
; CHECK-BE-LABEL: vector_add_i32:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    vmov d1, r3, r2
; CHECK-BE-NEXT:    vmov d0, r1, r0
; CHECK-BE-NEXT:    mov r0, sp
; CHECK-BE-NEXT:    vrev64.32 q1, q0
; CHECK-BE-NEXT:    vldrw.u32 q0, [r0]
; CHECK-BE-NEXT:    vadd.i32 q0, q1, q0
; CHECK-BE-NEXT:    vrev64.32 q1, q0
; CHECK-BE-NEXT:    vmov r1, r0, d2
; CHECK-BE-NEXT:    vmov r3, r2, d3
; CHECK-BE-NEXT:    bx lr
entry:
  %sum = add <4 x i32> %lhs, %rhs
  ret <4 x i32> %sum
}

define <2 x i64> @vector_add_i64(<2 x i64> %lhs, <2 x i64> %rhs) {
; CHECK-MVE-LABEL: vector_add_i64:
; CHECK-MVE:       @ %bb.0: @ %entry
; CHECK-MVE-NEXT:    .save {r7, lr}
; CHECK-MVE-NEXT:    push {r7, lr}
; CHECK-MVE-NEXT:    add.w r12, sp, #8
; CHECK-MVE-NEXT:    vldrw.u32 q0, [r12]
; CHECK-MVE-NEXT:    vmov r12, lr, d0
; CHECK-MVE-NEXT:    adds.w r0, r0, r12
; CHECK-MVE-NEXT:    adc.w r1, r1, lr
; CHECK-MVE-NEXT:    vmov r12, lr, d1
; CHECK-MVE-NEXT:    adds.w r2, r2, r12
; CHECK-MVE-NEXT:    adc.w r3, r3, lr
; CHECK-MVE-NEXT:    pop {r7, pc}
;
; CHECK-BE-LABEL: vector_add_i64:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    .save {r7, lr}
; CHECK-BE-NEXT:    push {r7, lr}
; CHECK-BE-NEXT:    add.w r12, sp, #8
; CHECK-BE-NEXT:    vldrw.u32 q0, [r12]
; CHECK-BE-NEXT:    vmov r12, lr, d0
; CHECK-BE-NEXT:    adds.w r1, r1, lr
; CHECK-BE-NEXT:    adc.w r0, r0, r12
; CHECK-BE-NEXT:    vmov r12, lr, d1
; CHECK-BE-NEXT:    adds.w r3, r3, lr
; CHECK-BE-NEXT:    adc.w r2, r2, r12
; CHECK-BE-NEXT:    pop {r7, pc}
;
; CHECK-FP-LABEL: vector_add_i64:
; CHECK-FP:       @ %bb.0: @ %entry
; CHECK-FP-NEXT:    .save {r4, r5, r7, lr}
; CHECK-FP-NEXT:    push {r4, r5, r7, lr}
; CHECK-FP-NEXT:    add.w r12, sp, #16
; CHECK-FP-NEXT:    vldrw.u32 q0, [r12]
; CHECK-FP-NEXT:    vmov r12, lr, d0
; CHECK-FP-NEXT:    vmov r4, r5, d1
; CHECK-FP-NEXT:    adds.w r0, r0, r12
; CHECK-FP-NEXT:    adc.w r1, r1, lr
; CHECK-FP-NEXT:    adds r2, r2, r4
; CHECK-FP-NEXT:    adcs r3, r5
; CHECK-FP-NEXT:    pop {r4, r5, r7, pc}
entry:
  %sum = add <2 x i64> %lhs, %rhs
  ret <2 x i64> %sum
}

define <8 x half> @vector_add_f16(<8 x half> %lhs, <8 x half> %rhs) {
; CHECK-MVE-LABEL: vector_add_f16:
; CHECK-MVE:       @ %bb.0: @ %entry
; CHECK-MVE-NEXT:    .save {r4, r5, r7, lr}
; CHECK-MVE-NEXT:    push {r4, r5, r7, lr}
; CHECK-MVE-NEXT:    .vsave {d8, d9, d10, d11, d12, d13}
; CHECK-MVE-NEXT:    vpush {d8, d9, d10, d11, d12, d13}
; CHECK-MVE-NEXT:    vmov d9, r2, r3
; CHECK-MVE-NEXT:    vmov d8, r0, r1
; CHECK-MVE-NEXT:    add r0, sp, #64
; CHECK-MVE-NEXT:    vldrw.u32 q6, [r0]
; CHECK-MVE-NEXT:    vmov.u16 r4, q4[0]
; CHECK-MVE-NEXT:    vmov.u16 r0, q6[0]
; CHECK-MVE-NEXT:    bl __aeabi_h2f
; CHECK-MVE-NEXT:    mov r5, r0
; CHECK-MVE-NEXT:    mov r0, r4
; CHECK-MVE-NEXT:    bl __aeabi_h2f
; CHECK-MVE-NEXT:    mov r1, r5
; CHECK-MVE-NEXT:    bl __aeabi_fadd
; CHECK-MVE-NEXT:    bl __aeabi_f2h
; CHECK-MVE-NEXT:    vmov.16 q5[0], r0
; CHECK-MVE-NEXT:    vmov.u16 r0, q6[1]
; CHECK-MVE-NEXT:    vmov.u16 r4, q4[1]
; CHECK-MVE-NEXT:    bl __aeabi_h2f
; CHECK-MVE-NEXT:    mov r5, r0
; CHECK-MVE-NEXT:    mov r0, r4
; CHECK-MVE-NEXT:    bl __aeabi_h2f
; CHECK-MVE-NEXT:    mov r1, r5
; CHECK-MVE-NEXT:    bl __aeabi_fadd
; CHECK-MVE-NEXT:    bl __aeabi_f2h
; CHECK-MVE-NEXT:    vmov.16 q5[1], r0
; CHECK-MVE-NEXT:    vmov.u16 r0, q6[2]
; CHECK-MVE-NEXT:    vmov.u16 r4, q4[2]
; CHECK-MVE-NEXT:    bl __aeabi_h2f
; CHECK-MVE-NEXT:    mov r5, r0
; CHECK-MVE-NEXT:    mov r0, r4
; CHECK-MVE-NEXT:    bl __aeabi_h2f
; CHECK-MVE-NEXT:    mov r1, r5
; CHECK-MVE-NEXT:    bl __aeabi_fadd
; CHECK-MVE-NEXT:    bl __aeabi_f2h
; CHECK-MVE-NEXT:    vmov.16 q5[2], r0
; CHECK-MVE-NEXT:    vmov.u16 r0, q6[3]
; CHECK-MVE-NEXT:    vmov.u16 r4, q4[3]
; CHECK-MVE-NEXT:    bl __aeabi_h2f
; CHECK-MVE-NEXT:    mov r5, r0
; CHECK-MVE-NEXT:    mov r0, r4
; CHECK-MVE-NEXT:    bl __aeabi_h2f
; CHECK-MVE-NEXT:    mov r1, r5
; CHECK-MVE-NEXT:    bl __aeabi_fadd
; CHECK-MVE-NEXT:    bl __aeabi_f2h
; CHECK-MVE-NEXT:    vmov.16 q5[3], r0
; CHECK-MVE-NEXT:    vmov.u16 r0, q6[4]
; CHECK-MVE-NEXT:    vmov.u16 r4, q4[4]
; CHECK-MVE-NEXT:    bl __aeabi_h2f
; CHECK-MVE-NEXT:    mov r5, r0
; CHECK-MVE-NEXT:    mov r0, r4
; CHECK-MVE-NEXT:    bl __aeabi_h2f
; CHECK-MVE-NEXT:    mov r1, r5
; CHECK-MVE-NEXT:    bl __aeabi_fadd
; CHECK-MVE-NEXT:    bl __aeabi_f2h
; CHECK-MVE-NEXT:    vmov.16 q5[4], r0
; CHECK-MVE-NEXT:    vmov.u16 r0, q6[5]
; CHECK-MVE-NEXT:    vmov.u16 r4, q4[5]
; CHECK-MVE-NEXT:    bl __aeabi_h2f
; CHECK-MVE-NEXT:    mov r5, r0
; CHECK-MVE-NEXT:    mov r0, r4
; CHECK-MVE-NEXT:    bl __aeabi_h2f
; CHECK-MVE-NEXT:    mov r1, r5
; CHECK-MVE-NEXT:    bl __aeabi_fadd
; CHECK-MVE-NEXT:    bl __aeabi_f2h
; CHECK-MVE-NEXT:    vmov.16 q5[5], r0
; CHECK-MVE-NEXT:    vmov.u16 r0, q6[6]
; CHECK-MVE-NEXT:    vmov.u16 r4, q4[6]
; CHECK-MVE-NEXT:    bl __aeabi_h2f
; CHECK-MVE-NEXT:    mov r5, r0
; CHECK-MVE-NEXT:    mov r0, r4
; CHECK-MVE-NEXT:    bl __aeabi_h2f
; CHECK-MVE-NEXT:    mov r1, r5
; CHECK-MVE-NEXT:    bl __aeabi_fadd
; CHECK-MVE-NEXT:    bl __aeabi_f2h
; CHECK-MVE-NEXT:    vmov.16 q5[6], r0
; CHECK-MVE-NEXT:    vmov.u16 r0, q6[7]
; CHECK-MVE-NEXT:    vmov.u16 r4, q4[7]
; CHECK-MVE-NEXT:    bl __aeabi_h2f
; CHECK-MVE-NEXT:    mov r5, r0
; CHECK-MVE-NEXT:    mov r0, r4
; CHECK-MVE-NEXT:    bl __aeabi_h2f
; CHECK-MVE-NEXT:    mov r1, r5
; CHECK-MVE-NEXT:    bl __aeabi_fadd
; CHECK-MVE-NEXT:    bl __aeabi_f2h
; CHECK-MVE-NEXT:    vmov.16 q5[7], r0
; CHECK-MVE-NEXT:    vmov r0, r1, d10
; CHECK-MVE-NEXT:    vmov r2, r3, d11
; CHECK-MVE-NEXT:    vpop {d8, d9, d10, d11, d12, d13}
; CHECK-MVE-NEXT:    pop {r4, r5, r7, pc}
;
; CHECK-BE-LABEL: vector_add_f16:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    .save {r4, r5, r7, lr}
; CHECK-BE-NEXT:    push {r4, r5, r7, lr}
; CHECK-BE-NEXT:    .vsave {d8, d9, d10, d11, d12, d13}
; CHECK-BE-NEXT:    vpush {d8, d9, d10, d11, d12, d13}
; CHECK-BE-NEXT:    vmov d1, r3, r2
; CHECK-BE-NEXT:    vmov d0, r1, r0
; CHECK-BE-NEXT:    add r0, sp, #64
; CHECK-BE-NEXT:    vldrh.u16 q6, [r0]
; CHECK-BE-NEXT:    vrev64.16 q4, q0
; CHECK-BE-NEXT:    vmov.u16 r4, q4[0]
; CHECK-BE-NEXT:    vmov.u16 r0, q6[0]
; CHECK-BE-NEXT:    bl __aeabi_h2f
; CHECK-BE-NEXT:    mov r5, r0
; CHECK-BE-NEXT:    mov r0, r4
; CHECK-BE-NEXT:    bl __aeabi_h2f
; CHECK-BE-NEXT:    mov r1, r5
; CHECK-BE-NEXT:    bl __aeabi_fadd
; CHECK-BE-NEXT:    bl __aeabi_f2h
; CHECK-BE-NEXT:    vmov.16 q5[0], r0
; CHECK-BE-NEXT:    vmov.u16 r0, q6[1]
; CHECK-BE-NEXT:    vmov.u16 r4, q4[1]
; CHECK-BE-NEXT:    bl __aeabi_h2f
; CHECK-BE-NEXT:    mov r5, r0
; CHECK-BE-NEXT:    mov r0, r4
; CHECK-BE-NEXT:    bl __aeabi_h2f
; CHECK-BE-NEXT:    mov r1, r5
; CHECK-BE-NEXT:    bl __aeabi_fadd
; CHECK-BE-NEXT:    bl __aeabi_f2h
; CHECK-BE-NEXT:    vmov.16 q5[1], r0
; CHECK-BE-NEXT:    vmov.u16 r0, q6[2]
; CHECK-BE-NEXT:    vmov.u16 r4, q4[2]
; CHECK-BE-NEXT:    bl __aeabi_h2f
; CHECK-BE-NEXT:    mov r5, r0
; CHECK-BE-NEXT:    mov r0, r4
; CHECK-BE-NEXT:    bl __aeabi_h2f
; CHECK-BE-NEXT:    mov r1, r5
; CHECK-BE-NEXT:    bl __aeabi_fadd
; CHECK-BE-NEXT:    bl __aeabi_f2h
; CHECK-BE-NEXT:    vmov.16 q5[2], r0
; CHECK-BE-NEXT:    vmov.u16 r0, q6[3]
; CHECK-BE-NEXT:    vmov.u16 r4, q4[3]
; CHECK-BE-NEXT:    bl __aeabi_h2f
; CHECK-BE-NEXT:    mov r5, r0
; CHECK-BE-NEXT:    mov r0, r4
; CHECK-BE-NEXT:    bl __aeabi_h2f
; CHECK-BE-NEXT:    mov r1, r5
; CHECK-BE-NEXT:    bl __aeabi_fadd
; CHECK-BE-NEXT:    bl __aeabi_f2h
; CHECK-BE-NEXT:    vmov.16 q5[3], r0
; CHECK-BE-NEXT:    vmov.u16 r0, q6[4]
; CHECK-BE-NEXT:    vmov.u16 r4, q4[4]
; CHECK-BE-NEXT:    bl __aeabi_h2f
; CHECK-BE-NEXT:    mov r5, r0
; CHECK-BE-NEXT:    mov r0, r4
; CHECK-BE-NEXT:    bl __aeabi_h2f
; CHECK-BE-NEXT:    mov r1, r5
; CHECK-BE-NEXT:    bl __aeabi_fadd
; CHECK-BE-NEXT:    bl __aeabi_f2h
; CHECK-BE-NEXT:    vmov.16 q5[4], r0
; CHECK-BE-NEXT:    vmov.u16 r0, q6[5]
; CHECK-BE-NEXT:    vmov.u16 r4, q4[5]
; CHECK-BE-NEXT:    bl __aeabi_h2f
; CHECK-BE-NEXT:    mov r5, r0
; CHECK-BE-NEXT:    mov r0, r4
; CHECK-BE-NEXT:    bl __aeabi_h2f
; CHECK-BE-NEXT:    mov r1, r5
; CHECK-BE-NEXT:    bl __aeabi_fadd
; CHECK-BE-NEXT:    bl __aeabi_f2h
; CHECK-BE-NEXT:    vmov.16 q5[5], r0
; CHECK-BE-NEXT:    vmov.u16 r0, q6[6]
; CHECK-BE-NEXT:    vmov.u16 r4, q4[6]
; CHECK-BE-NEXT:    bl __aeabi_h2f
; CHECK-BE-NEXT:    mov r5, r0
; CHECK-BE-NEXT:    mov r0, r4
; CHECK-BE-NEXT:    bl __aeabi_h2f
; CHECK-BE-NEXT:    mov r1, r5
; CHECK-BE-NEXT:    bl __aeabi_fadd
; CHECK-BE-NEXT:    bl __aeabi_f2h
; CHECK-BE-NEXT:    vmov.16 q5[6], r0
; CHECK-BE-NEXT:    vmov.u16 r0, q6[7]
; CHECK-BE-NEXT:    vmov.u16 r4, q4[7]
; CHECK-BE-NEXT:    bl __aeabi_h2f
; CHECK-BE-NEXT:    mov r5, r0
; CHECK-BE-NEXT:    mov r0, r4
; CHECK-BE-NEXT:    bl __aeabi_h2f
; CHECK-BE-NEXT:    mov r1, r5
; CHECK-BE-NEXT:    bl __aeabi_fadd
; CHECK-BE-NEXT:    bl __aeabi_f2h
; CHECK-BE-NEXT:    vmov.16 q5[7], r0
; CHECK-BE-NEXT:    vrev64.16 q0, q5
; CHECK-BE-NEXT:    vmov r1, r0, d0
; CHECK-BE-NEXT:    vmov r3, r2, d1
; CHECK-BE-NEXT:    vpop {d8, d9, d10, d11, d12, d13}
; CHECK-BE-NEXT:    pop {r4, r5, r7, pc}
;
; CHECK-FP-LABEL: vector_add_f16:
; CHECK-FP:       @ %bb.0: @ %entry
; CHECK-FP-NEXT:    vmov d1, r2, r3
; CHECK-FP-NEXT:    vmov d0, r0, r1
; CHECK-FP-NEXT:    mov r0, sp
; CHECK-FP-NEXT:    vldrw.u32 q1, [r0]
; CHECK-FP-NEXT:    vadd.f16 q0, q0, q1
; CHECK-FP-NEXT:    vmov r0, r1, d0
; CHECK-FP-NEXT:    vmov r2, r3, d1
; CHECK-FP-NEXT:    bx lr
entry:
  %sum = fadd <8 x half> %lhs, %rhs
  ret <8 x half> %sum
}

define <4 x float> @vector_add_f32(<4 x float> %lhs, <4 x float> %rhs) {
; CHECK-MVE-LABEL: vector_add_f32:
; CHECK-MVE:       @ %bb.0: @ %entry
; CHECK-MVE-NEXT:    .save {r4, r5, r7, lr}
; CHECK-MVE-NEXT:    push {r4, r5, r7, lr}
; CHECK-MVE-NEXT:    .vsave {d8, d9, d10, d11, d12, d13}
; CHECK-MVE-NEXT:    vpush {d8, d9, d10, d11, d12, d13}
; CHECK-MVE-NEXT:    vmov d13, r2, r3
; CHECK-MVE-NEXT:    vmov d12, r0, r1
; CHECK-MVE-NEXT:    add r1, sp, #64
; CHECK-MVE-NEXT:    vldrw.u32 q5, [r1]
; CHECK-MVE-NEXT:    vmov r4, r0, d13
; CHECK-MVE-NEXT:    vmov r5, r1, d11
; CHECK-MVE-NEXT:    bl __aeabi_fadd
; CHECK-MVE-NEXT:    vmov s19, r0
; CHECK-MVE-NEXT:    mov r0, r4
; CHECK-MVE-NEXT:    mov r1, r5
; CHECK-MVE-NEXT:    bl __aeabi_fadd
; CHECK-MVE-NEXT:    vmov s18, r0
; CHECK-MVE-NEXT:    vmov r4, r0, d12
; CHECK-MVE-NEXT:    vmov r5, r1, d10
; CHECK-MVE-NEXT:    bl __aeabi_fadd
; CHECK-MVE-NEXT:    vmov s17, r0
; CHECK-MVE-NEXT:    mov r0, r4
; CHECK-MVE-NEXT:    mov r1, r5
; CHECK-MVE-NEXT:    bl __aeabi_fadd
; CHECK-MVE-NEXT:    vmov s16, r0
; CHECK-MVE-NEXT:    vmov r2, r3, d9
; CHECK-MVE-NEXT:    vmov r0, r1, d8
; CHECK-MVE-NEXT:    vpop {d8, d9, d10, d11, d12, d13}
; CHECK-MVE-NEXT:    pop {r4, r5, r7, pc}
;
; CHECK-BE-LABEL: vector_add_f32:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    .save {r4, r5, r7, lr}
; CHECK-BE-NEXT:    push {r4, r5, r7, lr}
; CHECK-BE-NEXT:    .vsave {d8, d9, d10, d11, d12, d13}
; CHECK-BE-NEXT:    vpush {d8, d9, d10, d11, d12, d13}
; CHECK-BE-NEXT:    vmov d1, r3, r2
; CHECK-BE-NEXT:    vmov d0, r1, r0
; CHECK-BE-NEXT:    add r1, sp, #64
; CHECK-BE-NEXT:    vldrw.u32 q6, [r1]
; CHECK-BE-NEXT:    vrev64.32 q5, q0
; CHECK-BE-NEXT:    vmov r4, r0, d11
; CHECK-BE-NEXT:    vmov r5, r1, d13
; CHECK-BE-NEXT:    bl __aeabi_fadd
; CHECK-BE-NEXT:    vmov s19, r0
; CHECK-BE-NEXT:    mov r0, r4
; CHECK-BE-NEXT:    mov r1, r5
; CHECK-BE-NEXT:    bl __aeabi_fadd
; CHECK-BE-NEXT:    vmov s18, r0
; CHECK-BE-NEXT:    vmov r4, r0, d10
; CHECK-BE-NEXT:    vmov r5, r1, d12
; CHECK-BE-NEXT:    bl __aeabi_fadd
; CHECK-BE-NEXT:    vmov s17, r0
; CHECK-BE-NEXT:    mov r0, r4
; CHECK-BE-NEXT:    mov r1, r5
; CHECK-BE-NEXT:    bl __aeabi_fadd
; CHECK-BE-NEXT:    vmov s16, r0
; CHECK-BE-NEXT:    vrev64.32 q0, q4
; CHECK-BE-NEXT:    vmov r1, r0, d0
; CHECK-BE-NEXT:    vmov r3, r2, d1
; CHECK-BE-NEXT:    vpop {d8, d9, d10, d11, d12, d13}
; CHECK-BE-NEXT:    pop {r4, r5, r7, pc}
;
; CHECK-FP-LABEL: vector_add_f32:
; CHECK-FP:       @ %bb.0: @ %entry
; CHECK-FP-NEXT:    vmov d1, r2, r3
; CHECK-FP-NEXT:    vmov d0, r0, r1
; CHECK-FP-NEXT:    mov r0, sp
; CHECK-FP-NEXT:    vldrw.u32 q1, [r0]
; CHECK-FP-NEXT:    vadd.f32 q0, q0, q1
; CHECK-FP-NEXT:    vmov r0, r1, d0
; CHECK-FP-NEXT:    vmov r2, r3, d1
; CHECK-FP-NEXT:    bx lr
entry:
  %sum = fadd <4 x float> %lhs, %rhs
  ret <4 x float> %sum
}

define <2 x double> @vector_add_f64(<2 x double> %lhs, <2 x double> %rhs) {
; CHECK-MVE-LABEL: vector_add_f64:
; CHECK-MVE:       @ %bb.0: @ %entry
; CHECK-MVE-NEXT:    .save {r4, r5, r6, r7, lr}
; CHECK-MVE-NEXT:    push {r4, r5, r6, r7, lr}
; CHECK-MVE-NEXT:    .pad #4
; CHECK-MVE-NEXT:    sub sp, #4
; CHECK-MVE-NEXT:    .vsave {d8, d9, d10, d11}
; CHECK-MVE-NEXT:    vpush {d8, d9, d10, d11}
; CHECK-MVE-NEXT:    mov r5, r0
; CHECK-MVE-NEXT:    add r0, sp, #56
; CHECK-MVE-NEXT:    vldrw.u32 q4, [r0]
; CHECK-MVE-NEXT:    mov r4, r2
; CHECK-MVE-NEXT:    mov r6, r3
; CHECK-MVE-NEXT:    mov r7, r1
; CHECK-MVE-NEXT:    vmov r2, r3, d9
; CHECK-MVE-NEXT:    mov r0, r4
; CHECK-MVE-NEXT:    mov r1, r6
; CHECK-MVE-NEXT:    bl __aeabi_dadd
; CHECK-MVE-NEXT:    vmov r2, r3, d8
; CHECK-MVE-NEXT:    vmov d11, r0, r1
; CHECK-MVE-NEXT:    mov r0, r5
; CHECK-MVE-NEXT:    mov r1, r7
; CHECK-MVE-NEXT:    bl __aeabi_dadd
; CHECK-MVE-NEXT:    vmov d10, r0, r1
; CHECK-MVE-NEXT:    vmov r2, r3, d11
; CHECK-MVE-NEXT:    vmov r0, r1, d10
; CHECK-MVE-NEXT:    vpop {d8, d9, d10, d11}
; CHECK-MVE-NEXT:    add sp, #4
; CHECK-MVE-NEXT:    pop {r4, r5, r6, r7, pc}
;
; CHECK-BE-LABEL: vector_add_f64:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    .save {r4, r5, r6, r7, lr}
; CHECK-BE-NEXT:    push {r4, r5, r6, r7, lr}
; CHECK-BE-NEXT:    .pad #4
; CHECK-BE-NEXT:    sub sp, #4
; CHECK-BE-NEXT:    .vsave {d8, d9, d10, d11}
; CHECK-BE-NEXT:    vpush {d8, d9, d10, d11}
; CHECK-BE-NEXT:    mov r5, r0
; CHECK-BE-NEXT:    add r0, sp, #56
; CHECK-BE-NEXT:    vldrb.u8 q0, [r0]
; CHECK-BE-NEXT:    mov r6, r2
; CHECK-BE-NEXT:    mov r4, r3
; CHECK-BE-NEXT:    mov r7, r1
; CHECK-BE-NEXT:    vrev64.8 q4, q0
; CHECK-BE-NEXT:    mov r0, r6
; CHECK-BE-NEXT:    vmov r3, r2, d9
; CHECK-BE-NEXT:    mov r1, r4
; CHECK-BE-NEXT:    bl __aeabi_dadd
; CHECK-BE-NEXT:    vmov r3, r2, d8
; CHECK-BE-NEXT:    vmov d11, r1, r0
; CHECK-BE-NEXT:    mov r0, r5
; CHECK-BE-NEXT:    mov r1, r7
; CHECK-BE-NEXT:    bl __aeabi_dadd
; CHECK-BE-NEXT:    vmov d10, r1, r0
; CHECK-BE-NEXT:    vmov r3, r2, d11
; CHECK-BE-NEXT:    vmov r1, r0, d10
; CHECK-BE-NEXT:    vpop {d8, d9, d10, d11}
; CHECK-BE-NEXT:    add sp, #4
; CHECK-BE-NEXT:    pop {r4, r5, r6, r7, pc}
;
; CHECK-FP-LABEL: vector_add_f64:
; CHECK-FP:       @ %bb.0: @ %entry
; CHECK-FP-NEXT:    .save {r4, r5, r6, r7, lr}
; CHECK-FP-NEXT:    push {r4, r5, r6, r7, lr}
; CHECK-FP-NEXT:    .pad #4
; CHECK-FP-NEXT:    sub sp, #4
; CHECK-FP-NEXT:    .vsave {d8, d9}
; CHECK-FP-NEXT:    vpush {d8, d9}
; CHECK-FP-NEXT:    mov r5, r0
; CHECK-FP-NEXT:    add r0, sp, #40
; CHECK-FP-NEXT:    vldrw.u32 q4, [r0]
; CHECK-FP-NEXT:    mov r4, r2
; CHECK-FP-NEXT:    mov r6, r3
; CHECK-FP-NEXT:    mov r7, r1
; CHECK-FP-NEXT:    vmov r2, r3, d9
; CHECK-FP-NEXT:    mov r0, r4
; CHECK-FP-NEXT:    mov r1, r6
; CHECK-FP-NEXT:    bl __aeabi_dadd
; CHECK-FP-NEXT:    vmov r2, r3, d8
; CHECK-FP-NEXT:    vmov d9, r0, r1
; CHECK-FP-NEXT:    mov r0, r5
; CHECK-FP-NEXT:    mov r1, r7
; CHECK-FP-NEXT:    bl __aeabi_dadd
; CHECK-FP-NEXT:    vmov d8, r0, r1
; CHECK-FP-NEXT:    vmov r2, r3, d9
; CHECK-FP-NEXT:    vmov r0, r1, d8
; CHECK-FP-NEXT:    vpop {d8, d9}
; CHECK-FP-NEXT:    add sp, #4
; CHECK-FP-NEXT:    pop {r4, r5, r6, r7, pc}
entry:
  %sum = fadd <2 x double> %lhs, %rhs
  ret <2 x double> %sum
}

define <4 x i32> @insertextract(i32 %x, i32 %y) {
; CHECK-LE-LABEL: insertextract:
; CHECK-LE:       @ %bb.0:
; CHECK-LE-NEXT:    vdup.32 q0, r0
; CHECK-LE-NEXT:    vmov.32 q0[3], r1
; CHECK-LE-NEXT:    vmov r0, r1, d0
; CHECK-LE-NEXT:    vmov r2, r3, d1
; CHECK-LE-NEXT:    bx lr
;
; CHECK-BE-LABEL: insertextract:
; CHECK-BE:       @ %bb.0:
; CHECK-BE-NEXT:    vdup.32 q0, r0
; CHECK-BE-NEXT:    vmov.32 q0[3], r1
; CHECK-BE-NEXT:    vrev64.32 q1, q0
; CHECK-BE-NEXT:    vmov r1, r0, d2
; CHECK-BE-NEXT:    vmov r3, r2, d3
; CHECK-BE-NEXT:    bx lr
  %1 = insertelement <4 x i32> undef, i32 %x, i32 0
  %2 = insertelement <4 x i32> %1, i32 %x, i32 1
  %3 = insertelement <4 x i32> %2, i32 %x, i32 2
  %4 = insertelement <4 x i32> %3, i32 %y, i32 3
  ret <4 x i32> %4
}
