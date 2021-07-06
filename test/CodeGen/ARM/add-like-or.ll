; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv6m-none-eabi %s -o - | FileCheck %s --check-prefixes=CHECK-T1
; RUN: llc -mtriple=thumbv7m-none-eabi %s -o - | FileCheck %s --check-prefixes=CHECK-T2
; RUN: llc -mtriple=armv7a-none-eabi %s -o - | FileCheck %s --check-prefixes=CHECK-A

define i32 @test_add_i3(i1 %tst, i32 %a, i32 %b) {
; CHECK-T1-LABEL: test_add_i3:
; CHECK-T1:       @ %bb.0:
; CHECK-T1-NEXT:    .save {r4, lr}
; CHECK-T1-NEXT:    push {r4, lr}
; CHECK-T1-NEXT:    lsls r0, r0, #31
; CHECK-T1-NEXT:    bne .LBB0_2
; CHECK-T1-NEXT:  @ %bb.1:
; CHECK-T1-NEXT:    movs r0, #3
; CHECK-T1-NEXT:    bics r2, r0
; CHECK-T1-NEXT:    mov r4, r2
; CHECK-T1-NEXT:    b .LBB0_3
; CHECK-T1-NEXT:  .LBB0_2:
; CHECK-T1-NEXT:    mov r4, r1
; CHECK-T1-NEXT:    movs r0, #6
; CHECK-T1-NEXT:    bics r4, r0
; CHECK-T1-NEXT:  .LBB0_3:
; CHECK-T1-NEXT:    mov r0, r4
; CHECK-T1-NEXT:    bl foo
; CHECK-T1-NEXT:    adds r0, r4, #2
; CHECK-T1-NEXT:    pop {r4, pc}
;
; CHECK-T2-LABEL: test_add_i3:
; CHECK-T2:       @ %bb.0:
; CHECK-T2-NEXT:    .save {r4, lr}
; CHECK-T2-NEXT:    push {r4, lr}
; CHECK-T2-NEXT:    lsls r0, r0, #31
; CHECK-T2-NEXT:    bic r4, r2, #3
; CHECK-T2-NEXT:    it ne
; CHECK-T2-NEXT:    bicne r4, r1, #6
; CHECK-T2-NEXT:    mov r0, r4
; CHECK-T2-NEXT:    bl foo
; CHECK-T2-NEXT:    adds r0, r4, #2
; CHECK-T2-NEXT:    pop {r4, pc}
;
; CHECK-A-LABEL: test_add_i3:
; CHECK-A:       @ %bb.0:
; CHECK-A-NEXT:    .save {r4, lr}
; CHECK-A-NEXT:    push {r4, lr}
; CHECK-A-NEXT:    bic r4, r2, #3
; CHECK-A-NEXT:    tst r0, #1
; CHECK-A-NEXT:    bicne r4, r1, #6
; CHECK-A-NEXT:    mov r0, r4
; CHECK-A-NEXT:    bl foo
; CHECK-A-NEXT:    orr r0, r4, #2
; CHECK-A-NEXT:    pop {r4, pc}
  %tmp = and i32 %a, -7
  %tmp1 = and i32 %b, -4
  %int = select i1 %tst, i32 %tmp, i32 %tmp1

  ; Call to force %int into a register that isn't r0 so using the i3 form is a
  ; good idea.
  call void @foo(i32 %int)
  %res = or i32 %int, 2
  ret i32 %res
}

define i32 @test_add_i8(i32 %a, i32 %b, i1 %tst) {
; CHECK-T1-LABEL: test_add_i8:
; CHECK-T1:       @ %bb.0:
; CHECK-T1-NEXT:    lsls r2, r2, #31
; CHECK-T1-NEXT:    bne .LBB1_2
; CHECK-T1-NEXT:  @ %bb.1:
; CHECK-T1-NEXT:    ldr r0, .LCPI1_0
; CHECK-T1-NEXT:    ands r1, r0
; CHECK-T1-NEXT:    mov r0, r1
; CHECK-T1-NEXT:    adds r0, #12
; CHECK-T1-NEXT:    bx lr
; CHECK-T1-NEXT:  .LBB1_2:
; CHECK-T1-NEXT:    movs r1, #255
; CHECK-T1-NEXT:    bics r0, r1
; CHECK-T1-NEXT:    adds r0, #12
; CHECK-T1-NEXT:    bx lr
; CHECK-T1-NEXT:    .p2align 2
; CHECK-T1-NEXT:  @ %bb.3:
; CHECK-T1-NEXT:  .LCPI1_0:
; CHECK-T1-NEXT:    .long 4294966784 @ 0xfffffe00
;
; CHECK-T2-LABEL: test_add_i8:
; CHECK-T2:       @ %bb.0:
; CHECK-T2-NEXT:    movw r3, #511
; CHECK-T2-NEXT:    bics r1, r3
; CHECK-T2-NEXT:    lsls r2, r2, #31
; CHECK-T2-NEXT:    it ne
; CHECK-T2-NEXT:    bicne r1, r0, #255
; CHECK-T2-NEXT:    add.w r0, r1, #12
; CHECK-T2-NEXT:    bx lr
;
; CHECK-A-LABEL: test_add_i8:
; CHECK-A:       @ %bb.0:
; CHECK-A-NEXT:    bfc r1, #0, #9
; CHECK-A-NEXT:    tst r2, #1
; CHECK-A-NEXT:    bicne r1, r0, #255
; CHECK-A-NEXT:    orr r0, r1, #12
; CHECK-A-NEXT:    bx lr
  %tmp = and i32 %a, -256
  %tmp1 = and i32 %b, -512
  %int = select i1 %tst, i32 %tmp, i32 %tmp1
  %res = or i32 %int, 12
  ret i32 %res
}

define i32 @test_add_i12(i32 %a, i32 %b, i1 %tst) {
; CHECK-T1-LABEL: test_add_i12:
; CHECK-T1:       @ %bb.0:
; CHECK-T1-NEXT:    lsls r2, r2, #31
; CHECK-T1-NEXT:    bne .LBB2_2
; CHECK-T1-NEXT:  @ %bb.1:
; CHECK-T1-NEXT:    ldr r0, .LCPI2_1
; CHECK-T1-NEXT:    ands r1, r0
; CHECK-T1-NEXT:    mov r0, r1
; CHECK-T1-NEXT:    b .LBB2_3
; CHECK-T1-NEXT:  .LBB2_2:
; CHECK-T1-NEXT:    ldr r1, .LCPI2_0
; CHECK-T1-NEXT:    ands r0, r1
; CHECK-T1-NEXT:  .LBB2_3:
; CHECK-T1-NEXT:    ldr r1, .LCPI2_2
; CHECK-T1-NEXT:    adds r0, r0, r1
; CHECK-T1-NEXT:    bx lr
; CHECK-T1-NEXT:    .p2align 2
; CHECK-T1-NEXT:  @ %bb.4:
; CHECK-T1-NEXT:  .LCPI2_0:
; CHECK-T1-NEXT:    .long 4294963200 @ 0xfffff000
; CHECK-T1-NEXT:  .LCPI2_1:
; CHECK-T1-NEXT:    .long 4294959104 @ 0xffffe000
; CHECK-T1-NEXT:  .LCPI2_2:
; CHECK-T1-NEXT:    .long 854 @ 0x356
;
; CHECK-T2-LABEL: test_add_i12:
; CHECK-T2:       @ %bb.0:
; CHECK-T2-NEXT:    movw r3, #8191
; CHECK-T2-NEXT:    bics r1, r3
; CHECK-T2-NEXT:    movw r12, #4095
; CHECK-T2-NEXT:    lsls r2, r2, #31
; CHECK-T2-NEXT:    it ne
; CHECK-T2-NEXT:    bicne.w r1, r0, r12
; CHECK-T2-NEXT:    addw r0, r1, #854
; CHECK-T2-NEXT:    bx lr
;
; CHECK-A-LABEL: test_add_i12:
; CHECK-A:       @ %bb.0:
; CHECK-A-NEXT:    bfc r1, #0, #13
; CHECK-A-NEXT:    bfc r0, #0, #12
; CHECK-A-NEXT:    tst r2, #1
; CHECK-A-NEXT:    moveq r0, r1
; CHECK-A-NEXT:    movw r1, #854
; CHECK-A-NEXT:    orr r0, r0, r1
; CHECK-A-NEXT:    bx lr
  %tmp = and i32 %a, -4096
  %tmp1 = and i32 %b, -8192
  %int = select i1 %tst, i32 %tmp, i32 %tmp1
  %res = or i32 %int, 854
  ret i32 %res
}

define i32 @oradd(i32 %i, i32 %y) {
; CHECK-T1-LABEL: oradd:
; CHECK-T1:       @ %bb.0: @ %entry
; CHECK-T1-NEXT:    lsls r0, r0, #1
; CHECK-T1-NEXT:    adds r0, r0, #1
; CHECK-T1-NEXT:    adds r0, r0, r1
; CHECK-T1-NEXT:    bx lr
;
; CHECK-T2-LABEL: oradd:
; CHECK-T2:       @ %bb.0: @ %entry
; CHECK-T2-NEXT:    lsls r0, r0, #1
; CHECK-T2-NEXT:    adds r0, #1
; CHECK-T2-NEXT:    add r0, r1
; CHECK-T2-NEXT:    bx lr
;
; CHECK-A-LABEL: oradd:
; CHECK-A:       @ %bb.0: @ %entry
; CHECK-A-NEXT:    mov r2, #1
; CHECK-A-NEXT:    orr r0, r2, r0, lsl #1
; CHECK-A-NEXT:    add r0, r0, r1
; CHECK-A-NEXT:    bx lr
entry:
  %mul = shl i32 %i, 1
  %or = or i32 %mul, 1
  %add = add i32 %or, %y
  ret i32 %add
}

define i32 @orgep(i32 %i, i32* %x, i32* %y) {
; CHECK-T1-LABEL: orgep:
; CHECK-T1:       @ %bb.0: @ %entry
; CHECK-T1-NEXT:    lsls r0, r0, #3
; CHECK-T1-NEXT:    adds r0, r0, #4
; CHECK-T1-NEXT:    ldr r0, [r1, r0]
; CHECK-T1-NEXT:    bx lr
;
; CHECK-T2-LABEL: orgep:
; CHECK-T2:       @ %bb.0: @ %entry
; CHECK-T2-NEXT:    lsls r0, r0, #3
; CHECK-T2-NEXT:    adds r0, #4
; CHECK-T2-NEXT:    ldr r0, [r1, r0]
; CHECK-T2-NEXT:    bx lr
;
; CHECK-A-LABEL: orgep:
; CHECK-A:       @ %bb.0: @ %entry
; CHECK-A-NEXT:    mov r2, #4
; CHECK-A-NEXT:    orr r0, r2, r0, lsl #3
; CHECK-A-NEXT:    ldr r0, [r1, r0]
; CHECK-A-NEXT:    bx lr
entry:
  %mul = shl i32 %i, 1
  %add = or i32 %mul, 1
  %arrayidx = getelementptr inbounds i32, i32* %x, i32 %add
  %0 = load i32, i32* %arrayidx, align 8
  ret i32 %0
}

define i32 @orgeps(i32 %i, i32* %x, i32* %y) {
; CHECK-T1-LABEL: orgeps:
; CHECK-T1:       @ %bb.0: @ %entry
; CHECK-T1-NEXT:    lsls r0, r0, #3
; CHECK-T1-NEXT:    adds r2, r0, #4
; CHECK-T1-NEXT:    ldr r2, [r1, r2]
; CHECK-T1-NEXT:    adds r0, r0, r1
; CHECK-T1-NEXT:    ldr r0, [r0, #8]
; CHECK-T1-NEXT:    adds r0, r0, r2
; CHECK-T1-NEXT:    bx lr
;
; CHECK-T2-LABEL: orgeps:
; CHECK-T2:       @ %bb.0: @ %entry
; CHECK-T2-NEXT:    lsls r2, r0, #3
; CHECK-T2-NEXT:    add.w r0, r1, r0, lsl #3
; CHECK-T2-NEXT:    adds r2, #4
; CHECK-T2-NEXT:    ldr r0, [r0, #8]
; CHECK-T2-NEXT:    ldr r2, [r1, r2]
; CHECK-T2-NEXT:    add r0, r2
; CHECK-T2-NEXT:    bx lr
;
; CHECK-A-LABEL: orgeps:
; CHECK-A:       @ %bb.0: @ %entry
; CHECK-A-NEXT:    mov r2, #4
; CHECK-A-NEXT:    orr r2, r2, r0, lsl #3
; CHECK-A-NEXT:    add r0, r1, r0, lsl #3
; CHECK-A-NEXT:    ldr r2, [r1, r2]
; CHECK-A-NEXT:    ldr r0, [r0, #8]
; CHECK-A-NEXT:    add r0, r0, r2
; CHECK-A-NEXT:    bx lr
entry:
  %mul = shl i32 %i, 1
  %add = or i32 %mul, 1
  %arrayidx = getelementptr inbounds i32, i32* %x, i32 %add
  %0 = load i32, i32* %arrayidx, align 8
  %add2 = add i32 %mul, 2
  %arrayidx3 = getelementptr inbounds i32, i32* %x, i32 %add2
  %1 = load i32, i32* %arrayidx3, align 8
  %add4 = add i32 %1, %0
  ret i32 %add4
}

define i32 @multiuse(i32 %i, i32* %x, i32* %y) {
; CHECK-T1-LABEL: multiuse:
; CHECK-T1:       @ %bb.0: @ %entry
; CHECK-T1-NEXT:    lsls r0, r0, #1
; CHECK-T1-NEXT:    adds r0, r0, #1
; CHECK-T1-NEXT:    lsls r2, r0, #2
; CHECK-T1-NEXT:    ldr r1, [r1, r2]
; CHECK-T1-NEXT:    adds r0, r0, r1
; CHECK-T1-NEXT:    bx lr
;
; CHECK-T2-LABEL: multiuse:
; CHECK-T2:       @ %bb.0: @ %entry
; CHECK-T2-NEXT:    lsls r0, r0, #1
; CHECK-T2-NEXT:    adds r0, #1
; CHECK-T2-NEXT:    ldr.w r1, [r1, r0, lsl #2]
; CHECK-T2-NEXT:    add r0, r1
; CHECK-T2-NEXT:    bx lr
;
; CHECK-A-LABEL: multiuse:
; CHECK-A:       @ %bb.0: @ %entry
; CHECK-A-NEXT:    mov r2, #1
; CHECK-A-NEXT:    orr r0, r2, r0, lsl #1
; CHECK-A-NEXT:    ldr r1, [r1, r0, lsl #2]
; CHECK-A-NEXT:    add r0, r0, r1
; CHECK-A-NEXT:    bx lr
entry:
  %mul = shl i32 %i, 1
  %add = or i32 %mul, 1
  %arrayidx = getelementptr inbounds i32, i32* %x, i32 %add
  %0 = load i32, i32* %arrayidx, align 8
  %r = add i32 %add, %0
  ret i32 %r
}

declare void @foo(i32)
