; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv6-eabi %s -o - | FileCheck %s

define void @test1(i32 %x, void ()* %f)  {
; CHECK-LABEL: test1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    lsls r0, r0, #2
; CHECK-NEXT:    cmp r0, #68
; CHECK-NEXT:    beq .LBB0_2
; CHECK-NEXT:  @ %bb.1: @ %if.then
; CHECK-NEXT:    blx r1
; CHECK-NEXT:  .LBB0_2: @ %if.end
; CHECK-NEXT:    pop {r7, pc}
entry:
  %a = and i32 %x, 1073741823
  %cmp = icmp eq i32 %a, 17
  br i1 %cmp, label %if.end, label %if.then

if.then:
  tail call void %f()
  br label %if.end

if.end:
  ret void
}

define void @test2(i32 %x, void ()* %f)  {
; CHECK-LABEL: test2:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    movs r2, #1
; CHECK-NEXT:    lsls r2, r2, #31
; CHECK-NEXT:    lsls r0, r0, #7
; CHECK-NEXT:    cmp r0, r2
; CHECK-NEXT:    bhi .LBB1_2
; CHECK-NEXT:  @ %bb.1: @ %if.then
; CHECK-NEXT:    blx r1
; CHECK-NEXT:  .LBB1_2: @ %if.end
; CHECK-NEXT:    pop {r7, pc}
entry:
  %a = shl i32 %x, 7
  %cmp = icmp ugt i32 %a, 2147483648
  br i1 %cmp, label %if.end, label %if.then

if.then:
  tail call void %f()
  br label %if.end

if.end:
  ret void
}

define void @test3(i32 %x, void ()* %f)  {
; CHECK-LABEL: test3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    movs r2, #1
; CHECK-NEXT:    lsls r2, r2, #31
; CHECK-NEXT:    lsls r0, r0, #2
; CHECK-NEXT:    cmp r0, r2
; CHECK-NEXT:    bhi .LBB2_2
; CHECK-NEXT:  @ %bb.1: @ %if.then
; CHECK-NEXT:    blx r1
; CHECK-NEXT:  .LBB2_2: @ %if.end
; CHECK-NEXT:    pop {r7, pc}
entry:
  %a = and i32 %x, 1073741823
  %cmp = icmp ugt i32 %a, 536870912
  br i1 %cmp, label %if.end, label %if.then

if.then:
  tail call void %f()
  br label %if.end

if.end:
  ret void
}

define void @test4(i32 %x, void ()* %f)  {
; CHECK-LABEL: test4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    uxtb r0, r0
; CHECK-NEXT:    cmp r0, #17
; CHECK-NEXT:    beq .LBB3_2
; CHECK-NEXT:  @ %bb.1: @ %if.then
; CHECK-NEXT:    blx r1
; CHECK-NEXT:  .LBB3_2: @ %if.end
; CHECK-NEXT:    pop {r7, pc}
entry:
  %a = and i32 %x, 255
  %cmp = icmp eq i32 %a, 17
  br i1 %cmp, label %if.end, label %if.then

if.then:
  tail call void %f()
  br label %if.end

if.end:
  ret void
}

define void @test5(i32 %x, void ()* %f)  {
; CHECK-LABEL: test5:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    uxth r0, r0
; CHECK-NEXT:    cmp r0, #17
; CHECK-NEXT:    beq .LBB4_2
; CHECK-NEXT:  @ %bb.1: @ %if.then
; CHECK-NEXT:    blx r1
; CHECK-NEXT:  .LBB4_2: @ %if.end
; CHECK-NEXT:    pop {r7, pc}
entry:
  %a = and i32 %x, 65535
  %cmp = icmp eq i32 %a, 17
  br i1 %cmp, label %if.end, label %if.then

if.then:
  tail call void %f()
  br label %if.end

if.end:
  ret void
}

define void @test6(i32 %x, void ()* %f)  {
; CHECK-LABEL: test6:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    movs r2, #32
; CHECK-NEXT:    ands r2, r0
; CHECK-NEXT:    cmp r2, #17
; CHECK-NEXT:    beq .LBB5_2
; CHECK-NEXT:  @ %bb.1: @ %if.then
; CHECK-NEXT:    blx r1
; CHECK-NEXT:  .LBB5_2: @ %if.end
; CHECK-NEXT:    pop {r7, pc}
entry:
  %a = and i32 %x, 32
  %cmp = icmp eq i32 %a, 17
  br i1 %cmp, label %if.end, label %if.then

if.then:
  tail call void %f()
  br label %if.end

if.end:
  ret void
}

define void @test7(i32 %x, void ()* %f)  {
; CHECK-LABEL: test7:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    ldr r2, .LCPI6_0
; CHECK-NEXT:    ands r2, r0
; CHECK-NEXT:    cmp r2, #17
; CHECK-NEXT:    beq .LBB6_2
; CHECK-NEXT:  @ %bb.1: @ %if.then
; CHECK-NEXT:    blx r1
; CHECK-NEXT:  .LBB6_2: @ %if.end
; CHECK-NEXT:    pop {r7, pc}
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  @ %bb.3:
; CHECK-NEXT:  .LCPI6_0:
; CHECK-NEXT:    .long 1023 @ 0x3ff
entry:
  %a = and i32 %x, 1023
  %cmp = icmp eq i32 %a, 17
  br i1 %cmp, label %if.end, label %if.then

if.then:
  tail call void %f()
  br label %if.end

if.end:
  ret void
}

define void @test8(i32 %x, void ()* %f)  {
; CHECK-LABEL: test8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    movs r2, #129
; CHECK-NEXT:    lsls r2, r2, #23
; CHECK-NEXT:    lsls r0, r0, #22
; CHECK-NEXT:    cmp r0, r2
; CHECK-NEXT:    beq .LBB7_2
; CHECK-NEXT:  @ %bb.1: @ %if.then
; CHECK-NEXT:    blx r1
; CHECK-NEXT:  .LBB7_2: @ %if.end
; CHECK-NEXT:    pop {r7, pc}
entry:
  %a = and i32 %x, 1023
  %cmp = icmp eq i32 %a, 258
  br i1 %cmp, label %if.end, label %if.then

if.then:
  tail call void %f()
  br label %if.end

if.end:
  ret void
}
