; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mcpu=pwr8 < %s | FileCheck %s
target datalayout = "e-m:e-i64:64-n32:64"
target triple = "powerpc64le-unknown-linux-gnu"

@zeroEqualityTest01.buffer1 = private unnamed_addr constant [3 x i32] [i32 1, i32 2, i32 4], align 4
@zeroEqualityTest01.buffer2 = private unnamed_addr constant [3 x i32] [i32 1, i32 2, i32 3], align 4
@zeroEqualityTest02.buffer1 = private unnamed_addr constant [4 x i32] [i32 4, i32 0, i32 0, i32 0], align 4
@zeroEqualityTest02.buffer2 = private unnamed_addr constant [4 x i32] [i32 3, i32 0, i32 0, i32 0], align 4
@zeroEqualityTest03.buffer1 = private unnamed_addr constant [4 x i32] [i32 0, i32 0, i32 0, i32 3], align 4
@zeroEqualityTest03.buffer2 = private unnamed_addr constant [4 x i32] [i32 0, i32 0, i32 0, i32 4], align 4
@zeroEqualityTest04.buffer1 = private unnamed_addr constant [15 x i32] [i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14], align 4
@zeroEqualityTest04.buffer2 = private unnamed_addr constant [15 x i32] [i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 13], align 4

declare signext i32 @memcmp(i8* nocapture, i8* nocapture, i64) local_unnamed_addr #1

; Check 4 bytes - requires 1 load for each param.
define signext i32 @zeroEqualityTest02(i8* %x, i8* %y) {
; CHECK-LABEL: zeroEqualityTest02:
; CHECK:       # BB#0:
; CHECK-NEXT:    lwz 3, 0(3)
; CHECK-NEXT:    lwz 4, 0(4)
; CHECK-NEXT:    xor 3, 3, 4
; CHECK-NEXT:    cntlzw 3, 3
; CHECK-NEXT:    srwi 3, 3, 5
; CHECK-NEXT:    xori 3, 3, 1
; CHECK-NEXT:    blr
  %call = tail call signext i32 @memcmp(i8* %x, i8* %y, i64 4)
  %not.cmp = icmp ne i32 %call, 0
  %. = zext i1 %not.cmp to i32
  ret i32 %.
}

; Check 16 bytes - requires 2 loads for each param (or use vectors?).
define signext i32 @zeroEqualityTest01(i8* %x, i8* %y) {
; CHECK-LABEL: zeroEqualityTest01:
; CHECK:       # BB#0: # %loadbb
; CHECK-NEXT:    ld 5, 0(3)
; CHECK-NEXT:    ld 6, 0(4)
; CHECK-NEXT:    cmpld 5, 6
; CHECK-NEXT:    bne 0, .LBB1_2
; CHECK-NEXT:  # BB#1: # %loadbb1
; CHECK-NEXT:    ld 3, 8(3)
; CHECK-NEXT:    ld 4, 8(4)
; CHECK-NEXT:    cmpld 3, 4
; CHECK-NEXT:    li 3, 0
; CHECK-NEXT:    beq 0, .LBB1_3
; CHECK-NEXT:  .LBB1_2: # %res_block
; CHECK-NEXT:    li 3, 1
; CHECK-NEXT:    clrldi 3, 3, 32
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB1_3: # %endblock
; CHECK-NEXT:    clrldi 3, 3, 32
; CHECK-NEXT:    blr
  %call = tail call signext i32 @memcmp(i8* %x, i8* %y, i64 16)
  %not.tobool = icmp ne i32 %call, 0
  %. = zext i1 %not.tobool to i32
  ret i32 %.
}

; Check 7 bytes - requires 3 loads for each param.
define signext i32 @zeroEqualityTest03(i8* %x, i8* %y) {
; CHECK-LABEL: zeroEqualityTest03:
; CHECK:       # BB#0: # %loadbb
; CHECK-NEXT:    lwz 5, 0(3)
; CHECK-NEXT:    lwz 6, 0(4)
; CHECK-NEXT:    cmplw 5, 6
; CHECK-NEXT:    bne 0, .LBB2_3
; CHECK-NEXT:  # BB#1: # %loadbb1
; CHECK-NEXT:    lhz 5, 4(3)
; CHECK-NEXT:    lhz 6, 4(4)
; CHECK-NEXT:    cmplw 5, 6
; CHECK-NEXT:    bne 0, .LBB2_3
; CHECK-NEXT:  # BB#2: # %loadbb2
; CHECK-NEXT:    lbz 3, 6(3)
; CHECK-NEXT:    lbz 4, 6(4)
; CHECK-NEXT:    cmplw 3, 4
; CHECK-NEXT:    li 3, 0
; CHECK-NEXT:    beq 0, .LBB2_4
; CHECK-NEXT:  .LBB2_3: # %res_block
; CHECK-NEXT:    li 3, 1
; CHECK-NEXT:    clrldi 3, 3, 32
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB2_4: # %endblock
; CHECK-NEXT:    clrldi 3, 3, 32
; CHECK-NEXT:    blr
  %call = tail call signext i32 @memcmp(i8* %x, i8* %y, i64 7)
  %not.lnot = icmp ne i32 %call, 0
  %cond = zext i1 %not.lnot to i32
  ret i32 %cond
}

; Validate with > 0
define signext i32 @zeroEqualityTest04() {
; CHECK-LABEL: zeroEqualityTest04:
; CHECK:       # BB#0: # %loadbb
; CHECK-NEXT:    addis 3, 2, .LzeroEqualityTest02.buffer1@toc@ha
; CHECK-NEXT:    addis 4, 2, .LzeroEqualityTest02.buffer2@toc@ha
; CHECK-NEXT:    addi 6, 3, .LzeroEqualityTest02.buffer1@toc@l
; CHECK-NEXT:    addi 5, 4, .LzeroEqualityTest02.buffer2@toc@l
; CHECK-NEXT:    ldbrx 3, 0, 6
; CHECK-NEXT:    ldbrx 4, 0, 5
; CHECK-NEXT:    subf. 7, 4, 3
; CHECK-NEXT:    bne 0, .LBB3_2
; CHECK-NEXT:  # BB#1: # %loadbb1
; CHECK-NEXT:    li 4, 8
; CHECK-NEXT:    ldbrx 3, 6, 4
; CHECK-NEXT:    ldbrx 4, 5, 4
; CHECK-NEXT:    subf. 5, 4, 3
; CHECK-NEXT:    beq 0, .LBB3_4
; CHECK-NEXT:  .LBB3_2: # %res_block
; CHECK-NEXT:    cmpld 3, 4
; CHECK-NEXT:    li 3, 1
; CHECK-NEXT:    li 12, -1
; CHECK-NEXT:    isel 3, 12, 3, 0
; CHECK-NEXT:  .LBB3_3: # %endblock
; CHECK-NEXT:    cmpwi 3, 1
; CHECK-NEXT:    li 3, 0
; CHECK-NEXT:    li 4, 1
; CHECK-NEXT:    isel 3, 4, 3, 0
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB3_4:
; CHECK-NEXT:    li 3, 0
; CHECK-NEXT:    b .LBB3_3
  %call = tail call signext i32 @memcmp(i8* bitcast ([4 x i32]* @zeroEqualityTest02.buffer1 to i8*), i8* bitcast ([4 x i32]* @zeroEqualityTest02.buffer2 to i8*), i64 16)
  %not.cmp = icmp slt i32 %call, 1
  %. = zext i1 %not.cmp to i32
  ret i32 %.
}

; Validate with < 0
define signext i32 @zeroEqualityTest05() {
; CHECK-LABEL: zeroEqualityTest05:
; CHECK:       # BB#0: # %loadbb
; CHECK-NEXT:    addis 3, 2, .LzeroEqualityTest03.buffer1@toc@ha
; CHECK-NEXT:    addis 4, 2, .LzeroEqualityTest03.buffer2@toc@ha
; CHECK-NEXT:    addi 6, 3, .LzeroEqualityTest03.buffer1@toc@l
; CHECK-NEXT:    addi 5, 4, .LzeroEqualityTest03.buffer2@toc@l
; CHECK-NEXT:    ldbrx 3, 0, 6
; CHECK-NEXT:    ldbrx 4, 0, 5
; CHECK-NEXT:    subf. 7, 4, 3
; CHECK-NEXT:    bne 0, .LBB4_2
; CHECK-NEXT:  # BB#1: # %loadbb1
; CHECK-NEXT:    li 4, 8
; CHECK-NEXT:    ldbrx 3, 6, 4
; CHECK-NEXT:    ldbrx 4, 5, 4
; CHECK-NEXT:    subf. 5, 4, 3
; CHECK-NEXT:    beq 0, .LBB4_4
; CHECK-NEXT:  .LBB4_2: # %res_block
; CHECK-NEXT:    cmpld 3, 4
; CHECK-NEXT:    li 3, 1
; CHECK-NEXT:    li 12, -1
; CHECK-NEXT:    isel 3, 12, 3, 0
; CHECK-NEXT:  .LBB4_3: # %endblock
; CHECK-NEXT:    srwi 3, 3, 31
; CHECK-NEXT:    xori 3, 3, 1
; CHECK-NEXT:    clrldi 3, 3, 32
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB4_4:
; CHECK-NEXT:    li 3, 0
; CHECK-NEXT:    b .LBB4_3
  %call = tail call signext i32 @memcmp(i8* bitcast ([4 x i32]* @zeroEqualityTest03.buffer1 to i8*), i8* bitcast ([4 x i32]* @zeroEqualityTest03.buffer2 to i8*), i64 16)
  %call.lobit = lshr i32 %call, 31
  %call.lobit.not = xor i32 %call.lobit, 1
  ret i32 %call.lobit.not
}

; Validate with memcmp()?:
define signext i32 @equalityFoldTwoConstants() {
; CHECK-LABEL: equalityFoldTwoConstants:
; CHECK:       # BB#0: # %endblock
; CHECK-NEXT:    li 3, 1
; CHECK-NEXT:    blr
  %call = tail call signext i32 @memcmp(i8* bitcast ([15 x i32]* @zeroEqualityTest04.buffer1 to i8*), i8* bitcast ([15 x i32]* @zeroEqualityTest04.buffer2 to i8*), i64 16)
  %not.tobool = icmp eq i32 %call, 0
  %cond = zext i1 %not.tobool to i32
  ret i32 %cond
}

define signext i32 @equalityFoldOneConstant(i8* %X) {
; CHECK-LABEL: equalityFoldOneConstant:
; CHECK:       # BB#0: # %loadbb
; CHECK-NEXT:    li 4, 1
; CHECK-NEXT:    ld 5, 0(3)
; CHECK-NEXT:    sldi 4, 4, 32
; CHECK-NEXT:    cmpld 5, 4
; CHECK-NEXT:    bne 0, .LBB6_2
; CHECK-NEXT:  # BB#1: # %loadbb1
; CHECK-NEXT:    li 4, 3
; CHECK-NEXT:    ld 3, 8(3)
; CHECK-NEXT:    sldi 4, 4, 32
; CHECK-NEXT:    ori 4, 4, 2
; CHECK-NEXT:    cmpld 3, 4
; CHECK-NEXT:    li 3, 0
; CHECK-NEXT:    beq 0, .LBB6_3
; CHECK-NEXT:  .LBB6_2: # %res_block
; CHECK-NEXT:    li 3, 1
; CHECK-NEXT:  .LBB6_3: # %endblock
; CHECK-NEXT:    cntlzw 3, 3
; CHECK-NEXT:    srwi 3, 3, 5
; CHECK-NEXT:    blr
  %call = tail call signext i32 @memcmp(i8* bitcast ([15 x i32]* @zeroEqualityTest04.buffer1 to i8*), i8* %X, i64 16)
  %not.tobool = icmp eq i32 %call, 0
  %cond = zext i1 %not.tobool to i32
  ret i32 %cond
}

define i1 @length2_eq_nobuiltin_attr(i8* %X, i8* %Y) {
; CHECK-LABEL: length2_eq_nobuiltin_attr:
; CHECK:       # BB#0:
; CHECK-NEXT:    mflr 0
; CHECK-NEXT:    std 0, 16(1)
; CHECK-NEXT:    stdu 1, -32(1)
; CHECK-NEXT:  .Lcfi0:
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:  .Lcfi1:
; CHECK-NEXT:    .cfi_offset lr, 16
; CHECK-NEXT:    li 5, 2
; CHECK-NEXT:    bl memcmp
; CHECK-NEXT:    nop
; CHECK-NEXT:    cntlzw 3, 3
; CHECK-NEXT:    rlwinm 3, 3, 27, 31, 31
; CHECK-NEXT:    addi 1, 1, 32
; CHECK-NEXT:    ld 0, 16(1)
; CHECK-NEXT:    mtlr 0
; CHECK-NEXT:    blr
  %m = tail call signext i32 @memcmp(i8* %X, i8* %Y, i64 2) nobuiltin
  %c = icmp eq i32 %m, 0
  ret i1 %c
}

