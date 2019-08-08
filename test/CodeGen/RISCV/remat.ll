; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -O1 -mtriple=riscv32 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV32I

@a = common global i32 0, align 4
@l = common global i32 0, align 4
@b = common global i32 0, align 4
@c = common global i32 0, align 4
@d = common global i32 0, align 4
@e = common global i32 0, align 4
@k = common global i32 0, align 4
@f = common global i32 0, align 4
@j = common global i32 0, align 4
@g = common global i32 0, align 4
@i = common global i32 0, align 4
@h = common global i32 0, align 4

; This test case benefits from codegen recognising that some values are
; trivially rematerialisable, meaning they are recreated rather than saved to
; the stack and restored. It creates high register pressure to force this
; situation.

define i32 @test() nounwind {
; RV32I-LABEL: test:
; RV32I:       # %bb.0: # %entry
; RV32I-NEXT:    addi sp, sp, -64
; RV32I-NEXT:    sw ra, 60(sp)
; RV32I-NEXT:    sw s0, 56(sp)
; RV32I-NEXT:    sw s1, 52(sp)
; RV32I-NEXT:    sw s2, 48(sp)
; RV32I-NEXT:    sw s3, 44(sp)
; RV32I-NEXT:    sw s4, 40(sp)
; RV32I-NEXT:    sw s5, 36(sp)
; RV32I-NEXT:    sw s6, 32(sp)
; RV32I-NEXT:    sw s7, 28(sp)
; RV32I-NEXT:    sw s8, 24(sp)
; RV32I-NEXT:    sw s9, 20(sp)
; RV32I-NEXT:    sw s10, 16(sp)
; RV32I-NEXT:    sw s11, 12(sp)
; RV32I-NEXT:    lui s9, %hi(a)
; RV32I-NEXT:    lw a0, %lo(a)(s9)
; RV32I-NEXT:    beqz a0, .LBB0_11
; RV32I-NEXT:  # %bb.1: # %for.body.preheader
; RV32I-NEXT:    lui s2, %hi(l)
; RV32I-NEXT:    lui s3, %hi(k)
; RV32I-NEXT:    lui s4, %hi(j)
; RV32I-NEXT:    lui s6, %hi(i)
; RV32I-NEXT:    lui s5, %hi(h)
; RV32I-NEXT:    lui s7, %hi(g)
; RV32I-NEXT:    lui s8, %hi(f)
; RV32I-NEXT:    lui s1, %hi(e)
; RV32I-NEXT:    lui s0, %hi(d)
; RV32I-NEXT:    lui s10, %hi(c)
; RV32I-NEXT:    lui s11, %hi(b)
; RV32I-NEXT:  .LBB0_2: # %for.body
; RV32I-NEXT:    # =>This Inner Loop Header: Depth=1
; RV32I-NEXT:    lw a1, %lo(l)(s2)
; RV32I-NEXT:    beqz a1, .LBB0_4
; RV32I-NEXT:  # %bb.3: # %if.then
; RV32I-NEXT:    # in Loop: Header=BB0_2 Depth=1
; RV32I-NEXT:    lw a4, %lo(e)(s1)
; RV32I-NEXT:    lw a3, %lo(d)(s0)
; RV32I-NEXT:    lw a2, %lo(c)(s10)
; RV32I-NEXT:    lw a1, %lo(b)(s11)
; RV32I-NEXT:    addi a5, zero, 32
; RV32I-NEXT:    call foo
; RV32I-NEXT:  .LBB0_4: # %if.end
; RV32I-NEXT:    # in Loop: Header=BB0_2 Depth=1
; RV32I-NEXT:    lw a0, %lo(k)(s3)
; RV32I-NEXT:    beqz a0, .LBB0_6
; RV32I-NEXT:  # %bb.5: # %if.then3
; RV32I-NEXT:    # in Loop: Header=BB0_2 Depth=1
; RV32I-NEXT:    lw a4, %lo(f)(s8)
; RV32I-NEXT:    lw a3, %lo(e)(s1)
; RV32I-NEXT:    lw a2, %lo(d)(s0)
; RV32I-NEXT:    lw a1, %lo(c)(s10)
; RV32I-NEXT:    lw a0, %lo(b)(s11)
; RV32I-NEXT:    addi a5, zero, 64
; RV32I-NEXT:    call foo
; RV32I-NEXT:  .LBB0_6: # %if.end5
; RV32I-NEXT:    # in Loop: Header=BB0_2 Depth=1
; RV32I-NEXT:    lw a0, %lo(j)(s4)
; RV32I-NEXT:    beqz a0, .LBB0_8
; RV32I-NEXT:  # %bb.7: # %if.then7
; RV32I-NEXT:    # in Loop: Header=BB0_2 Depth=1
; RV32I-NEXT:    lw a4, %lo(g)(s7)
; RV32I-NEXT:    lw a3, %lo(f)(s8)
; RV32I-NEXT:    lw a2, %lo(e)(s1)
; RV32I-NEXT:    lw a1, %lo(d)(s0)
; RV32I-NEXT:    lw a0, %lo(c)(s10)
; RV32I-NEXT:    addi a5, zero, 32
; RV32I-NEXT:    call foo
; RV32I-NEXT:  .LBB0_8: # %if.end9
; RV32I-NEXT:    # in Loop: Header=BB0_2 Depth=1
; RV32I-NEXT:    lw a0, %lo(i)(s6)
; RV32I-NEXT:    beqz a0, .LBB0_10
; RV32I-NEXT:  # %bb.9: # %if.then11
; RV32I-NEXT:    # in Loop: Header=BB0_2 Depth=1
; RV32I-NEXT:    lw a4, %lo(h)(s5)
; RV32I-NEXT:    lw a3, %lo(g)(s7)
; RV32I-NEXT:    lw a2, %lo(f)(s8)
; RV32I-NEXT:    lw a1, %lo(e)(s1)
; RV32I-NEXT:    lw a0, %lo(d)(s0)
; RV32I-NEXT:    addi a5, zero, 32
; RV32I-NEXT:    call foo
; RV32I-NEXT:  .LBB0_10: # %for.inc
; RV32I-NEXT:    # in Loop: Header=BB0_2 Depth=1
; RV32I-NEXT:    lw a0, %lo(a)(s9)
; RV32I-NEXT:    addi a0, a0, -1
; RV32I-NEXT:    sw a0, %lo(a)(s9)
; RV32I-NEXT:    bnez a0, .LBB0_2
; RV32I-NEXT:  .LBB0_11: # %for.end
; RV32I-NEXT:    addi a0, zero, 1
; RV32I-NEXT:    lw s11, 12(sp)
; RV32I-NEXT:    lw s10, 16(sp)
; RV32I-NEXT:    lw s9, 20(sp)
; RV32I-NEXT:    lw s8, 24(sp)
; RV32I-NEXT:    lw s7, 28(sp)
; RV32I-NEXT:    lw s6, 32(sp)
; RV32I-NEXT:    lw s5, 36(sp)
; RV32I-NEXT:    lw s4, 40(sp)
; RV32I-NEXT:    lw s3, 44(sp)
; RV32I-NEXT:    lw s2, 48(sp)
; RV32I-NEXT:    lw s1, 52(sp)
; RV32I-NEXT:    lw s0, 56(sp)
; RV32I-NEXT:    lw ra, 60(sp)
; RV32I-NEXT:    addi sp, sp, 64
; RV32I-NEXT:    ret
entry:
  %.pr = load i32, i32* @a, align 4
  %tobool14 = icmp eq i32 %.pr, 0
  br i1 %tobool14, label %for.end, label %for.body

for.body:                                         ; preds = %entry, %for.inc
  %0 = phi i32 [ %dec, %for.inc ], [ %.pr, %entry ]
  %1 = load i32, i32* @l, align 4
  %tobool1 = icmp eq i32 %1, 0
  br i1 %tobool1, label %if.end, label %if.then

if.then:                                          ; preds = %for.body
  %2 = load i32, i32* @b, align 4
  %3 = load i32, i32* @c, align 4
  %4 = load i32, i32* @d, align 4
  %5 = load i32, i32* @e, align 4
  %call = tail call i32 @foo(i32 %0, i32 %2, i32 %3, i32 %4, i32 %5, i32 32) #3
  br label %if.end

if.end:                                           ; preds = %for.body, %if.then
  %6 = load i32, i32* @k, align 4
  %tobool2 = icmp eq i32 %6, 0
  br i1 %tobool2, label %if.end5, label %if.then3

if.then3:                                         ; preds = %if.end
  %7 = load i32, i32* @b, align 4
  %8 = load i32, i32* @c, align 4
  %9 = load i32, i32* @d, align 4
  %10 = load i32, i32* @e, align 4
  %11 = load i32, i32* @f, align 4
  %call4 = tail call i32 @foo(i32 %7, i32 %8, i32 %9, i32 %10, i32 %11, i32 64) #3
  br label %if.end5

if.end5:                                          ; preds = %if.end, %if.then3
  %12 = load i32, i32* @j, align 4
  %tobool6 = icmp eq i32 %12, 0
  br i1 %tobool6, label %if.end9, label %if.then7

if.then7:                                         ; preds = %if.end5
  %13 = load i32, i32* @c, align 4
  %14 = load i32, i32* @d, align 4
  %15 = load i32, i32* @e, align 4
  %16 = load i32, i32* @f, align 4
  %17 = load i32, i32* @g, align 4
  %call8 = tail call i32 @foo(i32 %13, i32 %14, i32 %15, i32 %16, i32 %17, i32 32) #3
  br label %if.end9

if.end9:                                          ; preds = %if.end5, %if.then7
  %18 = load i32, i32* @i, align 4
  %tobool10 = icmp eq i32 %18, 0
  br i1 %tobool10, label %for.inc, label %if.then11

if.then11:                                        ; preds = %if.end9
  %19 = load i32, i32* @d, align 4
  %20 = load i32, i32* @e, align 4
  %21 = load i32, i32* @f, align 4
  %22 = load i32, i32* @g, align 4
  %23 = load i32, i32* @h, align 4
  %call12 = tail call i32 @foo(i32 %19, i32 %20, i32 %21, i32 %22, i32 %23, i32 32) #3
  br label %for.inc

for.inc:                                          ; preds = %if.end9, %if.then11
  %24 = load i32, i32* @a, align 4
  %dec = add nsw i32 %24, -1
  store i32 %dec, i32* @a, align 4
  %tobool = icmp eq i32 %dec, 0
  br i1 %tobool, label %for.end, label %for.body

for.end:                                          ; preds = %for.inc, %entry
  ret i32 1
}

declare i32 @foo(i32, i32, i32, i32, i32, i32)
