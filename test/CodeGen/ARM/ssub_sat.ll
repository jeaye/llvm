; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=thumbv6m-none-eabi | FileCheck %s --check-prefix=CHECK-T1
; RUN: llc < %s -mtriple=thumbv7m-none-eabi | FileCheck %s --check-prefix=CHECK-T2 --check-prefix=CHECK-T2NODSP
; RUN: llc < %s -mtriple=thumbv7em-none-eabi | FileCheck %s --check-prefix=CHECK-T2 --check-prefix=CHECK-T2DSP
; RUN: llc < %s -mtriple=armv8a-none-eabi | FileCheck %s --check-prefix=CHECK-ARM

declare i4 @llvm.ssub.sat.i4(i4, i4)
declare i8 @llvm.ssub.sat.i8(i8, i8)
declare i16 @llvm.ssub.sat.i16(i16, i16)
declare i32 @llvm.ssub.sat.i32(i32, i32)
declare i64 @llvm.ssub.sat.i64(i64, i64)
declare <4 x i32> @llvm.ssub.sat.v4i32(<4 x i32>, <4 x i32>)

define i32 @func(i32 %x, i32 %y) nounwind {
; CHECK-T1-LABEL: func:
; CHECK-T1:       @ %bb.0:
; CHECK-T1-NEXT:    .save {r4, lr}
; CHECK-T1-NEXT:    push {r4, lr}
; CHECK-T1-NEXT:    mov r2, r0
; CHECK-T1-NEXT:    movs r3, #1
; CHECK-T1-NEXT:    subs r0, r0, r1
; CHECK-T1-NEXT:    mov r4, r3
; CHECK-T1-NEXT:    bmi .LBB0_2
; CHECK-T1-NEXT:  @ %bb.1:
; CHECK-T1-NEXT:    movs r4, #0
; CHECK-T1-NEXT:  .LBB0_2:
; CHECK-T1-NEXT:    cmp r4, #0
; CHECK-T1-NEXT:    bne .LBB0_4
; CHECK-T1-NEXT:  @ %bb.3:
; CHECK-T1-NEXT:    lsls r3, r3, #31
; CHECK-T1-NEXT:    cmp r2, r1
; CHECK-T1-NEXT:    bvs .LBB0_5
; CHECK-T1-NEXT:    b .LBB0_6
; CHECK-T1-NEXT:  .LBB0_4:
; CHECK-T1-NEXT:    ldr r3, .LCPI0_0
; CHECK-T1-NEXT:    cmp r2, r1
; CHECK-T1-NEXT:    bvc .LBB0_6
; CHECK-T1-NEXT:  .LBB0_5:
; CHECK-T1-NEXT:    mov r0, r3
; CHECK-T1-NEXT:  .LBB0_6:
; CHECK-T1-NEXT:    pop {r4, pc}
; CHECK-T1-NEXT:    .p2align 2
; CHECK-T1-NEXT:  @ %bb.7:
; CHECK-T1-NEXT:  .LCPI0_0:
; CHECK-T1-NEXT:    .long 2147483647 @ 0x7fffffff
;
; CHECK-T2-LABEL: func:
; CHECK-T2:       @ %bb.0:
; CHECK-T2-NEXT:    subs.w r12, r0, r1
; CHECK-T2-NEXT:    mov.w r3, #0
; CHECK-T2-NEXT:    mov.w r2, #-2147483648
; CHECK-T2-NEXT:    it mi
; CHECK-T2-NEXT:    movmi r3, #1
; CHECK-T2-NEXT:    cmp r3, #0
; CHECK-T2-NEXT:    it ne
; CHECK-T2-NEXT:    mvnne r2, #-2147483648
; CHECK-T2-NEXT:    cmp r0, r1
; CHECK-T2-NEXT:    it vc
; CHECK-T2-NEXT:    movvc r2, r12
; CHECK-T2-NEXT:    mov r0, r2
; CHECK-T2-NEXT:    bx lr
;
; CHECK-ARM-LABEL: func:
; CHECK-ARM:       @ %bb.0:
; CHECK-ARM-NEXT:    subs r12, r0, r1
; CHECK-ARM-NEXT:    mov r3, #0
; CHECK-ARM-NEXT:    movwmi r3, #1
; CHECK-ARM-NEXT:    mov r2, #-2147483648
; CHECK-ARM-NEXT:    cmp r3, #0
; CHECK-ARM-NEXT:    mvnne r2, #-2147483648
; CHECK-ARM-NEXT:    cmp r0, r1
; CHECK-ARM-NEXT:    movvc r2, r12
; CHECK-ARM-NEXT:    mov r0, r2
; CHECK-ARM-NEXT:    bx lr
  %tmp = call i32 @llvm.ssub.sat.i32(i32 %x, i32 %y)
  ret i32 %tmp
}

define i64 @func2(i64 %x, i64 %y) nounwind {
; CHECK-T1-LABEL: func2:
; CHECK-T1:       @ %bb.0:
; CHECK-T1-NEXT:    .save {r4, r5, r6, r7, lr}
; CHECK-T1-NEXT:    push {r4, r5, r6, r7, lr}
; CHECK-T1-NEXT:    .pad #4
; CHECK-T1-NEXT:    sub sp, #4
; CHECK-T1-NEXT:    str r2, [sp] @ 4-byte Spill
; CHECK-T1-NEXT:    mov r2, r0
; CHECK-T1-NEXT:    movs r4, #1
; CHECK-T1-NEXT:    movs r0, #0
; CHECK-T1-NEXT:    cmp r3, #0
; CHECK-T1-NEXT:    mov r5, r4
; CHECK-T1-NEXT:    bge .LBB1_2
; CHECK-T1-NEXT:  @ %bb.1:
; CHECK-T1-NEXT:    mov r5, r0
; CHECK-T1-NEXT:  .LBB1_2:
; CHECK-T1-NEXT:    cmp r1, #0
; CHECK-T1-NEXT:    mov r7, r4
; CHECK-T1-NEXT:    bge .LBB1_4
; CHECK-T1-NEXT:  @ %bb.3:
; CHECK-T1-NEXT:    mov r7, r0
; CHECK-T1-NEXT:  .LBB1_4:
; CHECK-T1-NEXT:    subs r5, r7, r5
; CHECK-T1-NEXT:    subs r6, r5, #1
; CHECK-T1-NEXT:    sbcs r5, r6
; CHECK-T1-NEXT:    ldr r6, [sp] @ 4-byte Reload
; CHECK-T1-NEXT:    subs r6, r2, r6
; CHECK-T1-NEXT:    sbcs r1, r3
; CHECK-T1-NEXT:    cmp r1, #0
; CHECK-T1-NEXT:    mov r2, r4
; CHECK-T1-NEXT:    bge .LBB1_6
; CHECK-T1-NEXT:  @ %bb.5:
; CHECK-T1-NEXT:    mov r2, r0
; CHECK-T1-NEXT:  .LBB1_6:
; CHECK-T1-NEXT:    subs r0, r7, r2
; CHECK-T1-NEXT:    subs r2, r0, #1
; CHECK-T1-NEXT:    sbcs r0, r2
; CHECK-T1-NEXT:    ands r5, r0
; CHECK-T1-NEXT:    beq .LBB1_8
; CHECK-T1-NEXT:  @ %bb.7:
; CHECK-T1-NEXT:    asrs r6, r1, #31
; CHECK-T1-NEXT:  .LBB1_8:
; CHECK-T1-NEXT:    cmp r1, #0
; CHECK-T1-NEXT:    bmi .LBB1_10
; CHECK-T1-NEXT:  @ %bb.9:
; CHECK-T1-NEXT:    lsls r2, r4, #31
; CHECK-T1-NEXT:    cmp r5, #0
; CHECK-T1-NEXT:    beq .LBB1_11
; CHECK-T1-NEXT:    b .LBB1_12
; CHECK-T1-NEXT:  .LBB1_10:
; CHECK-T1-NEXT:    ldr r2, .LCPI1_0
; CHECK-T1-NEXT:    cmp r5, #0
; CHECK-T1-NEXT:    bne .LBB1_12
; CHECK-T1-NEXT:  .LBB1_11:
; CHECK-T1-NEXT:    mov r2, r1
; CHECK-T1-NEXT:  .LBB1_12:
; CHECK-T1-NEXT:    mov r0, r6
; CHECK-T1-NEXT:    mov r1, r2
; CHECK-T1-NEXT:    add sp, #4
; CHECK-T1-NEXT:    pop {r4, r5, r6, r7, pc}
; CHECK-T1-NEXT:    .p2align 2
; CHECK-T1-NEXT:  @ %bb.13:
; CHECK-T1-NEXT:  .LCPI1_0:
; CHECK-T1-NEXT:    .long 2147483647 @ 0x7fffffff
;
; CHECK-T2-LABEL: func2:
; CHECK-T2:       @ %bb.0:
; CHECK-T2-NEXT:    .save {r4, lr}
; CHECK-T2-NEXT:    push {r4, lr}
; CHECK-T2-NEXT:    cmp.w r3, #-1
; CHECK-T2-NEXT:    mov.w lr, #0
; CHECK-T2-NEXT:    it gt
; CHECK-T2-NEXT:    movgt.w lr, #1
; CHECK-T2-NEXT:    cmp.w r1, #-1
; CHECK-T2-NEXT:    mov.w r4, #0
; CHECK-T2-NEXT:    mov.w r12, #0
; CHECK-T2-NEXT:    it gt
; CHECK-T2-NEXT:    movgt r4, #1
; CHECK-T2-NEXT:    subs.w lr, r4, lr
; CHECK-T2-NEXT:    it ne
; CHECK-T2-NEXT:    movne.w lr, #1
; CHECK-T2-NEXT:    subs r0, r0, r2
; CHECK-T2-NEXT:    sbc.w r2, r1, r3
; CHECK-T2-NEXT:    cmp.w r2, #-1
; CHECK-T2-NEXT:    it gt
; CHECK-T2-NEXT:    movgt.w r12, #1
; CHECK-T2-NEXT:    subs.w r1, r4, r12
; CHECK-T2-NEXT:    it ne
; CHECK-T2-NEXT:    movne r1, #1
; CHECK-T2-NEXT:    ands.w r3, lr, r1
; CHECK-T2-NEXT:    mov.w r1, #-2147483648
; CHECK-T2-NEXT:    it ne
; CHECK-T2-NEXT:    asrne r0, r2, #31
; CHECK-T2-NEXT:    cmp r2, #0
; CHECK-T2-NEXT:    it mi
; CHECK-T2-NEXT:    mvnmi r1, #-2147483648
; CHECK-T2-NEXT:    cmp r3, #0
; CHECK-T2-NEXT:    it eq
; CHECK-T2-NEXT:    moveq r1, r2
; CHECK-T2-NEXT:    pop {r4, pc}
;
; CHECK-ARM-LABEL: func2:
; CHECK-ARM:       @ %bb.0:
; CHECK-ARM-NEXT:    .save {r4, lr}
; CHECK-ARM-NEXT:    push {r4, lr}
; CHECK-ARM-NEXT:    cmn r3, #1
; CHECK-ARM-NEXT:    mov lr, #0
; CHECK-ARM-NEXT:    movwgt lr, #1
; CHECK-ARM-NEXT:    cmn r1, #1
; CHECK-ARM-NEXT:    mov r4, #0
; CHECK-ARM-NEXT:    mov r12, #0
; CHECK-ARM-NEXT:    movwgt r4, #1
; CHECK-ARM-NEXT:    subs lr, r4, lr
; CHECK-ARM-NEXT:    movwne lr, #1
; CHECK-ARM-NEXT:    subs r0, r0, r2
; CHECK-ARM-NEXT:    sbc r2, r1, r3
; CHECK-ARM-NEXT:    cmn r2, #1
; CHECK-ARM-NEXT:    movwgt r12, #1
; CHECK-ARM-NEXT:    subs r1, r4, r12
; CHECK-ARM-NEXT:    movwne r1, #1
; CHECK-ARM-NEXT:    ands r3, lr, r1
; CHECK-ARM-NEXT:    asrne r0, r2, #31
; CHECK-ARM-NEXT:    mov r1, #-2147483648
; CHECK-ARM-NEXT:    cmp r2, #0
; CHECK-ARM-NEXT:    mvnmi r1, #-2147483648
; CHECK-ARM-NEXT:    cmp r3, #0
; CHECK-ARM-NEXT:    moveq r1, r2
; CHECK-ARM-NEXT:    pop {r4, pc}
  %tmp = call i64 @llvm.ssub.sat.i64(i64 %x, i64 %y)
  ret i64 %tmp
}

define i16 @func16(i16 %x, i16 %y) nounwind {
; CHECK-T1-LABEL: func16:
; CHECK-T1:       @ %bb.0:
; CHECK-T1-NEXT:    subs r0, r0, r1
; CHECK-T1-NEXT:    ldr r1, .LCPI2_0
; CHECK-T1-NEXT:    cmp r0, r1
; CHECK-T1-NEXT:    blt .LBB2_2
; CHECK-T1-NEXT:  @ %bb.1:
; CHECK-T1-NEXT:    mov r0, r1
; CHECK-T1-NEXT:  .LBB2_2:
; CHECK-T1-NEXT:    ldr r1, .LCPI2_1
; CHECK-T1-NEXT:    cmp r0, r1
; CHECK-T1-NEXT:    bgt .LBB2_4
; CHECK-T1-NEXT:  @ %bb.3:
; CHECK-T1-NEXT:    mov r0, r1
; CHECK-T1-NEXT:  .LBB2_4:
; CHECK-T1-NEXT:    bx lr
; CHECK-T1-NEXT:    .p2align 2
; CHECK-T1-NEXT:  @ %bb.5:
; CHECK-T1-NEXT:  .LCPI2_0:
; CHECK-T1-NEXT:    .long 32767 @ 0x7fff
; CHECK-T1-NEXT:  .LCPI2_1:
; CHECK-T1-NEXT:    .long 4294934528 @ 0xffff8000
;
; CHECK-T2-LABEL: func16:
; CHECK-T2:       @ %bb.0:
; CHECK-T2-NEXT:    subs r0, r0, r1
; CHECK-T2-NEXT:    movw r1, #32767
; CHECK-T2-NEXT:    cmp r0, r1
; CHECK-T2-NEXT:    it lt
; CHECK-T2-NEXT:    movlt r1, r0
; CHECK-T2-NEXT:    movw r0, #32768
; CHECK-T2-NEXT:    cmn.w r1, #32768
; CHECK-T2-NEXT:    movt r0, #65535
; CHECK-T2-NEXT:    it gt
; CHECK-T2-NEXT:    movgt r0, r1
; CHECK-T2-NEXT:    bx lr
;
; CHECK-ARM-LABEL: func16:
; CHECK-ARM:       @ %bb.0:
; CHECK-ARM-NEXT:    sub r0, r0, r1
; CHECK-ARM-NEXT:    movw r1, #32767
; CHECK-ARM-NEXT:    cmp r0, r1
; CHECK-ARM-NEXT:    movlt r1, r0
; CHECK-ARM-NEXT:    movw r0, #32768
; CHECK-ARM-NEXT:    movt r0, #65535
; CHECK-ARM-NEXT:    cmn r1, #32768
; CHECK-ARM-NEXT:    movgt r0, r1
; CHECK-ARM-NEXT:    bx lr
  %tmp = call i16 @llvm.ssub.sat.i16(i16 %x, i16 %y)
  ret i16 %tmp
}

define i8 @func8(i8 %x, i8 %y) nounwind {
; CHECK-T1-LABEL: func8:
; CHECK-T1:       @ %bb.0:
; CHECK-T1-NEXT:    subs r0, r0, r1
; CHECK-T1-NEXT:    movs r1, #127
; CHECK-T1-NEXT:    cmp r0, #127
; CHECK-T1-NEXT:    blt .LBB3_2
; CHECK-T1-NEXT:  @ %bb.1:
; CHECK-T1-NEXT:    mov r0, r1
; CHECK-T1-NEXT:  .LBB3_2:
; CHECK-T1-NEXT:    mvns r1, r1
; CHECK-T1-NEXT:    cmp r0, r1
; CHECK-T1-NEXT:    bgt .LBB3_4
; CHECK-T1-NEXT:  @ %bb.3:
; CHECK-T1-NEXT:    mov r0, r1
; CHECK-T1-NEXT:  .LBB3_4:
; CHECK-T1-NEXT:    bx lr
;
; CHECK-T2-LABEL: func8:
; CHECK-T2:       @ %bb.0:
; CHECK-T2-NEXT:    subs r0, r0, r1
; CHECK-T2-NEXT:    cmp r0, #127
; CHECK-T2-NEXT:    it ge
; CHECK-T2-NEXT:    movge r0, #127
; CHECK-T2-NEXT:    cmn.w r0, #128
; CHECK-T2-NEXT:    it le
; CHECK-T2-NEXT:    mvnle r0, #127
; CHECK-T2-NEXT:    bx lr
;
; CHECK-ARM-LABEL: func8:
; CHECK-ARM:       @ %bb.0:
; CHECK-ARM-NEXT:    sub r0, r0, r1
; CHECK-ARM-NEXT:    cmp r0, #127
; CHECK-ARM-NEXT:    movge r0, #127
; CHECK-ARM-NEXT:    cmn r0, #128
; CHECK-ARM-NEXT:    mvnle r0, #127
; CHECK-ARM-NEXT:    bx lr
  %tmp = call i8 @llvm.ssub.sat.i8(i8 %x, i8 %y)
  ret i8 %tmp
}

define i4 @func3(i4 %x, i4 %y) nounwind {
; CHECK-T1-LABEL: func3:
; CHECK-T1:       @ %bb.0:
; CHECK-T1-NEXT:    subs r0, r0, r1
; CHECK-T1-NEXT:    movs r1, #7
; CHECK-T1-NEXT:    cmp r0, #7
; CHECK-T1-NEXT:    blt .LBB4_2
; CHECK-T1-NEXT:  @ %bb.1:
; CHECK-T1-NEXT:    mov r0, r1
; CHECK-T1-NEXT:  .LBB4_2:
; CHECK-T1-NEXT:    mvns r1, r1
; CHECK-T1-NEXT:    cmp r0, r1
; CHECK-T1-NEXT:    bgt .LBB4_4
; CHECK-T1-NEXT:  @ %bb.3:
; CHECK-T1-NEXT:    mov r0, r1
; CHECK-T1-NEXT:  .LBB4_4:
; CHECK-T1-NEXT:    bx lr
;
; CHECK-T2-LABEL: func3:
; CHECK-T2:       @ %bb.0:
; CHECK-T2-NEXT:    subs r0, r0, r1
; CHECK-T2-NEXT:    cmp r0, #7
; CHECK-T2-NEXT:    it ge
; CHECK-T2-NEXT:    movge r0, #7
; CHECK-T2-NEXT:    cmn.w r0, #8
; CHECK-T2-NEXT:    it le
; CHECK-T2-NEXT:    mvnle r0, #7
; CHECK-T2-NEXT:    bx lr
;
; CHECK-ARM-LABEL: func3:
; CHECK-ARM:       @ %bb.0:
; CHECK-ARM-NEXT:    sub r0, r0, r1
; CHECK-ARM-NEXT:    cmp r0, #7
; CHECK-ARM-NEXT:    movge r0, #7
; CHECK-ARM-NEXT:    cmn r0, #8
; CHECK-ARM-NEXT:    mvnle r0, #7
; CHECK-ARM-NEXT:    bx lr
  %tmp = call i4 @llvm.ssub.sat.i4(i4 %x, i4 %y)
  ret i4 %tmp
}

define <4 x i32> @vec(<4 x i32> %x, <4 x i32> %y) nounwind {
; CHECK-T1-LABEL: vec:
; CHECK-T1:       @ %bb.0:
; CHECK-T1-NEXT:    .save {r4, r5, r6, r7, lr}
; CHECK-T1-NEXT:    push {r4, r5, r6, r7, lr}
; CHECK-T1-NEXT:    .pad #12
; CHECK-T1-NEXT:    sub sp, #12
; CHECK-T1-NEXT:    str r3, [sp] @ 4-byte Spill
; CHECK-T1-NEXT:    mov r4, r1
; CHECK-T1-NEXT:    mov r1, r0
; CHECK-T1-NEXT:    ldr r5, [sp, #32]
; CHECK-T1-NEXT:    movs r7, #1
; CHECK-T1-NEXT:    movs r0, #0
; CHECK-T1-NEXT:    str r0, [sp, #8] @ 4-byte Spill
; CHECK-T1-NEXT:    subs r0, r1, r5
; CHECK-T1-NEXT:    str r0, [sp, #4] @ 4-byte Spill
; CHECK-T1-NEXT:    mov r6, r7
; CHECK-T1-NEXT:    bmi .LBB5_2
; CHECK-T1-NEXT:  @ %bb.1:
; CHECK-T1-NEXT:    ldr r6, [sp, #8] @ 4-byte Reload
; CHECK-T1-NEXT:  .LBB5_2:
; CHECK-T1-NEXT:    lsls r3, r7, #31
; CHECK-T1-NEXT:    ldr r0, .LCPI5_0
; CHECK-T1-NEXT:    cmp r6, #0
; CHECK-T1-NEXT:    mov r6, r0
; CHECK-T1-NEXT:    bne .LBB5_4
; CHECK-T1-NEXT:  @ %bb.3:
; CHECK-T1-NEXT:    mov r6, r3
; CHECK-T1-NEXT:  .LBB5_4:
; CHECK-T1-NEXT:    cmp r1, r5
; CHECK-T1-NEXT:    bvc .LBB5_6
; CHECK-T1-NEXT:  @ %bb.5:
; CHECK-T1-NEXT:    str r6, [sp, #4] @ 4-byte Spill
; CHECK-T1-NEXT:  .LBB5_6:
; CHECK-T1-NEXT:    ldr r5, [sp, #36]
; CHECK-T1-NEXT:    subs r1, r4, r5
; CHECK-T1-NEXT:    mov r6, r7
; CHECK-T1-NEXT:    bmi .LBB5_8
; CHECK-T1-NEXT:  @ %bb.7:
; CHECK-T1-NEXT:    ldr r6, [sp, #8] @ 4-byte Reload
; CHECK-T1-NEXT:  .LBB5_8:
; CHECK-T1-NEXT:    cmp r6, #0
; CHECK-T1-NEXT:    mov r6, r0
; CHECK-T1-NEXT:    bne .LBB5_10
; CHECK-T1-NEXT:  @ %bb.9:
; CHECK-T1-NEXT:    mov r6, r3
; CHECK-T1-NEXT:  .LBB5_10:
; CHECK-T1-NEXT:    cmp r4, r5
; CHECK-T1-NEXT:    bvc .LBB5_12
; CHECK-T1-NEXT:  @ %bb.11:
; CHECK-T1-NEXT:    mov r1, r6
; CHECK-T1-NEXT:  .LBB5_12:
; CHECK-T1-NEXT:    ldr r5, [sp, #40]
; CHECK-T1-NEXT:    subs r4, r2, r5
; CHECK-T1-NEXT:    mov r6, r7
; CHECK-T1-NEXT:    bmi .LBB5_14
; CHECK-T1-NEXT:  @ %bb.13:
; CHECK-T1-NEXT:    ldr r6, [sp, #8] @ 4-byte Reload
; CHECK-T1-NEXT:  .LBB5_14:
; CHECK-T1-NEXT:    cmp r6, #0
; CHECK-T1-NEXT:    mov r6, r0
; CHECK-T1-NEXT:    bne .LBB5_16
; CHECK-T1-NEXT:  @ %bb.15:
; CHECK-T1-NEXT:    mov r6, r3
; CHECK-T1-NEXT:  .LBB5_16:
; CHECK-T1-NEXT:    cmp r2, r5
; CHECK-T1-NEXT:    bvc .LBB5_18
; CHECK-T1-NEXT:  @ %bb.17:
; CHECK-T1-NEXT:    mov r4, r6
; CHECK-T1-NEXT:  .LBB5_18:
; CHECK-T1-NEXT:    ldr r2, [sp, #44]
; CHECK-T1-NEXT:    ldr r6, [sp] @ 4-byte Reload
; CHECK-T1-NEXT:    subs r5, r6, r2
; CHECK-T1-NEXT:    bpl .LBB5_23
; CHECK-T1-NEXT:  @ %bb.19:
; CHECK-T1-NEXT:    cmp r7, #0
; CHECK-T1-NEXT:    beq .LBB5_24
; CHECK-T1-NEXT:  .LBB5_20:
; CHECK-T1-NEXT:    cmp r6, r2
; CHECK-T1-NEXT:    bvc .LBB5_22
; CHECK-T1-NEXT:  .LBB5_21:
; CHECK-T1-NEXT:    mov r5, r0
; CHECK-T1-NEXT:  .LBB5_22:
; CHECK-T1-NEXT:    ldr r0, [sp, #4] @ 4-byte Reload
; CHECK-T1-NEXT:    mov r2, r4
; CHECK-T1-NEXT:    mov r3, r5
; CHECK-T1-NEXT:    add sp, #12
; CHECK-T1-NEXT:    pop {r4, r5, r6, r7, pc}
; CHECK-T1-NEXT:  .LBB5_23:
; CHECK-T1-NEXT:    ldr r7, [sp, #8] @ 4-byte Reload
; CHECK-T1-NEXT:    cmp r7, #0
; CHECK-T1-NEXT:    bne .LBB5_20
; CHECK-T1-NEXT:  .LBB5_24:
; CHECK-T1-NEXT:    mov r0, r3
; CHECK-T1-NEXT:    cmp r6, r2
; CHECK-T1-NEXT:    bvs .LBB5_21
; CHECK-T1-NEXT:    b .LBB5_22
; CHECK-T1-NEXT:    .p2align 2
; CHECK-T1-NEXT:  @ %bb.25:
; CHECK-T1-NEXT:  .LCPI5_0:
; CHECK-T1-NEXT:    .long 2147483647 @ 0x7fffffff
;
; CHECK-T2-LABEL: vec:
; CHECK-T2:       @ %bb.0:
; CHECK-T2-NEXT:    .save {r4, r5, r6, r7, lr}
; CHECK-T2-NEXT:    push {r4, r5, r6, r7, lr}
; CHECK-T2-NEXT:    .pad #4
; CHECK-T2-NEXT:    sub sp, #4
; CHECK-T2-NEXT:    ldr r4, [sp, #24]
; CHECK-T2-NEXT:    mov lr, r0
; CHECK-T2-NEXT:    ldr r7, [sp, #28]
; CHECK-T2-NEXT:    movs r5, #0
; CHECK-T2-NEXT:    subs r6, r0, r4
; CHECK-T2-NEXT:    mov.w r0, #0
; CHECK-T2-NEXT:    it mi
; CHECK-T2-NEXT:    movmi r0, #1
; CHECK-T2-NEXT:    cmp r0, #0
; CHECK-T2-NEXT:    mov.w r0, #-2147483648
; CHECK-T2-NEXT:    mov.w r12, #-2147483648
; CHECK-T2-NEXT:    it ne
; CHECK-T2-NEXT:    mvnne r0, #-2147483648
; CHECK-T2-NEXT:    cmp lr, r4
; CHECK-T2-NEXT:    it vc
; CHECK-T2-NEXT:    movvc r0, r6
; CHECK-T2-NEXT:    subs r6, r1, r7
; CHECK-T2-NEXT:    mov.w r4, #0
; CHECK-T2-NEXT:    mov.w lr, #-2147483648
; CHECK-T2-NEXT:    it mi
; CHECK-T2-NEXT:    movmi r4, #1
; CHECK-T2-NEXT:    cmp r4, #0
; CHECK-T2-NEXT:    it ne
; CHECK-T2-NEXT:    mvnne lr, #-2147483648
; CHECK-T2-NEXT:    cmp r1, r7
; CHECK-T2-NEXT:    ldr r1, [sp, #32]
; CHECK-T2-NEXT:    mov.w r4, #0
; CHECK-T2-NEXT:    it vc
; CHECK-T2-NEXT:    movvc lr, r6
; CHECK-T2-NEXT:    subs r6, r2, r1
; CHECK-T2-NEXT:    it mi
; CHECK-T2-NEXT:    movmi r4, #1
; CHECK-T2-NEXT:    cmp r4, #0
; CHECK-T2-NEXT:    mov.w r4, #-2147483648
; CHECK-T2-NEXT:    it ne
; CHECK-T2-NEXT:    mvnne r4, #-2147483648
; CHECK-T2-NEXT:    cmp r2, r1
; CHECK-T2-NEXT:    ldr r1, [sp, #36]
; CHECK-T2-NEXT:    it vc
; CHECK-T2-NEXT:    movvc r4, r6
; CHECK-T2-NEXT:    subs r2, r3, r1
; CHECK-T2-NEXT:    it mi
; CHECK-T2-NEXT:    movmi r5, #1
; CHECK-T2-NEXT:    cmp r5, #0
; CHECK-T2-NEXT:    it ne
; CHECK-T2-NEXT:    mvnne r12, #-2147483648
; CHECK-T2-NEXT:    cmp r3, r1
; CHECK-T2-NEXT:    it vc
; CHECK-T2-NEXT:    movvc r12, r2
; CHECK-T2-NEXT:    mov r1, lr
; CHECK-T2-NEXT:    mov r2, r4
; CHECK-T2-NEXT:    mov r3, r12
; CHECK-T2-NEXT:    add sp, #4
; CHECK-T2-NEXT:    pop {r4, r5, r6, r7, pc}
;
; CHECK-ARM-LABEL: vec:
; CHECK-ARM:       @ %bb.0:
; CHECK-ARM-NEXT:    vmov d17, r2, r3
; CHECK-ARM-NEXT:    mov r12, sp
; CHECK-ARM-NEXT:    vld1.64 {d18, d19}, [r12]
; CHECK-ARM-NEXT:    vmov d16, r0, r1
; CHECK-ARM-NEXT:    vmvn.i32 q11, #0x80000000
; CHECK-ARM-NEXT:    vsub.i32 q10, q8, q9
; CHECK-ARM-NEXT:    vcgt.s32 q9, q9, #0
; CHECK-ARM-NEXT:    vclt.s32 q12, q10, #0
; CHECK-ARM-NEXT:    vmvn q13, q12
; CHECK-ARM-NEXT:    vcgt.s32 q8, q8, q10
; CHECK-ARM-NEXT:    vbsl q11, q12, q13
; CHECK-ARM-NEXT:    veor q8, q9, q8
; CHECK-ARM-NEXT:    vbsl q8, q11, q10
; CHECK-ARM-NEXT:    vmov r0, r1, d16
; CHECK-ARM-NEXT:    vmov r2, r3, d17
; CHECK-ARM-NEXT:    bx lr
  %tmp = call <4 x i32> @llvm.ssub.sat.v4i32(<4 x i32> %x, <4 x i32> %y)
  ret <4 x i32> %tmp
}
