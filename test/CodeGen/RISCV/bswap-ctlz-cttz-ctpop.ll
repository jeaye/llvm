; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV32I
; RUN: llc -mtriple=riscv64 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV64I

declare i16 @llvm.bswap.i16(i16)
declare i32 @llvm.bswap.i32(i32)
declare i64 @llvm.bswap.i64(i64)
declare i8 @llvm.cttz.i8(i8, i1)
declare i16 @llvm.cttz.i16(i16, i1)
declare i32 @llvm.cttz.i32(i32, i1)
declare i64 @llvm.cttz.i64(i64, i1)
declare i32 @llvm.ctlz.i32(i32, i1)
declare i32 @llvm.ctpop.i32(i32)

define i16 @test_bswap_i16(i16 %a) nounwind {
; RV32I-LABEL: test_bswap_i16:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a1, a0, 8
; RV32I-NEXT:    slli a0, a0, 16
; RV32I-NEXT:    srli a0, a0, 24
; RV32I-NEXT:    or a0, a1, a0
; RV32I-NEXT:    ret
;
; RV64I-LABEL: test_bswap_i16:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a1, a0, 8
; RV64I-NEXT:    slliw a0, a0, 16
; RV64I-NEXT:    srliw a0, a0, 24
; RV64I-NEXT:    or a0, a1, a0
; RV64I-NEXT:    ret
  %tmp = call i16 @llvm.bswap.i16(i16 %a)
  ret i16 %tmp
}

define i32 @test_bswap_i32(i32 %a) nounwind {
; RV32I-LABEL: test_bswap_i32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    srli a1, a0, 8
; RV32I-NEXT:    lui a2, 16
; RV32I-NEXT:    addi a2, a2, -256
; RV32I-NEXT:    and a1, a1, a2
; RV32I-NEXT:    srli a2, a0, 24
; RV32I-NEXT:    or a1, a1, a2
; RV32I-NEXT:    slli a2, a0, 8
; RV32I-NEXT:    lui a3, 4080
; RV32I-NEXT:    and a2, a2, a3
; RV32I-NEXT:    slli a0, a0, 24
; RV32I-NEXT:    or a0, a0, a2
; RV32I-NEXT:    or a0, a0, a1
; RV32I-NEXT:    ret
;
; RV64I-LABEL: test_bswap_i32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    srliw a1, a0, 8
; RV64I-NEXT:    lui a2, 16
; RV64I-NEXT:    addiw a2, a2, -256
; RV64I-NEXT:    and a1, a1, a2
; RV64I-NEXT:    srliw a2, a0, 24
; RV64I-NEXT:    or a1, a1, a2
; RV64I-NEXT:    slli a2, a0, 8
; RV64I-NEXT:    lui a3, 4080
; RV64I-NEXT:    and a2, a2, a3
; RV64I-NEXT:    slli a0, a0, 24
; RV64I-NEXT:    or a0, a0, a2
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    ret
  %tmp = call i32 @llvm.bswap.i32(i32 %a)
  ret i32 %tmp
}

define i64 @test_bswap_i64(i64 %a) nounwind {
; RV32I-LABEL: test_bswap_i64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    srli a2, a1, 8
; RV32I-NEXT:    lui a3, 16
; RV32I-NEXT:    addi a3, a3, -256
; RV32I-NEXT:    and a2, a2, a3
; RV32I-NEXT:    srli a4, a1, 24
; RV32I-NEXT:    or a2, a2, a4
; RV32I-NEXT:    slli a4, a1, 8
; RV32I-NEXT:    lui a5, 4080
; RV32I-NEXT:    and a4, a4, a5
; RV32I-NEXT:    slli a1, a1, 24
; RV32I-NEXT:    or a1, a1, a4
; RV32I-NEXT:    or a2, a1, a2
; RV32I-NEXT:    srli a1, a0, 8
; RV32I-NEXT:    and a1, a1, a3
; RV32I-NEXT:    srli a3, a0, 24
; RV32I-NEXT:    or a1, a1, a3
; RV32I-NEXT:    slli a3, a0, 8
; RV32I-NEXT:    and a3, a3, a5
; RV32I-NEXT:    slli a0, a0, 24
; RV32I-NEXT:    or a0, a0, a3
; RV32I-NEXT:    or a1, a0, a1
; RV32I-NEXT:    mv a0, a2
; RV32I-NEXT:    ret
;
; RV64I-LABEL: test_bswap_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    srli a1, a0, 24
; RV64I-NEXT:    lui a2, 4080
; RV64I-NEXT:    and a1, a1, a2
; RV64I-NEXT:    srli a2, a0, 8
; RV64I-NEXT:    addi a3, zero, 255
; RV64I-NEXT:    slli a4, a3, 24
; RV64I-NEXT:    and a2, a2, a4
; RV64I-NEXT:    or a1, a2, a1
; RV64I-NEXT:    srli a2, a0, 40
; RV64I-NEXT:    lui a4, 16
; RV64I-NEXT:    addiw a4, a4, -256
; RV64I-NEXT:    and a2, a2, a4
; RV64I-NEXT:    srli a4, a0, 56
; RV64I-NEXT:    or a2, a2, a4
; RV64I-NEXT:    or a1, a1, a2
; RV64I-NEXT:    slli a2, a0, 8
; RV64I-NEXT:    slli a4, a3, 32
; RV64I-NEXT:    and a2, a2, a4
; RV64I-NEXT:    slli a4, a0, 24
; RV64I-NEXT:    slli a5, a3, 40
; RV64I-NEXT:    and a4, a4, a5
; RV64I-NEXT:    or a2, a4, a2
; RV64I-NEXT:    slli a4, a0, 40
; RV64I-NEXT:    slli a3, a3, 48
; RV64I-NEXT:    and a3, a4, a3
; RV64I-NEXT:    slli a0, a0, 56
; RV64I-NEXT:    or a0, a0, a3
; RV64I-NEXT:    or a0, a0, a2
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    ret
  %tmp = call i64 @llvm.bswap.i64(i64 %a)
  ret i64 %tmp
}

define i8 @test_cttz_i8(i8 %a) nounwind {
; RV32I-LABEL: test_cttz_i8:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    andi a1, a0, 255
; RV32I-NEXT:    beqz a1, .LBB3_2
; RV32I-NEXT:  # %bb.1: # %cond.false
; RV32I-NEXT:    addi a1, a0, -1
; RV32I-NEXT:    not a0, a0
; RV32I-NEXT:    and a0, a0, a1
; RV32I-NEXT:    srli a1, a0, 1
; RV32I-NEXT:    lui a2, 349525
; RV32I-NEXT:    addi a2, a2, 1365
; RV32I-NEXT:    and a1, a1, a2
; RV32I-NEXT:    sub a0, a0, a1
; RV32I-NEXT:    lui a1, 209715
; RV32I-NEXT:    addi a1, a1, 819
; RV32I-NEXT:    and a2, a0, a1
; RV32I-NEXT:    srli a0, a0, 2
; RV32I-NEXT:    and a0, a0, a1
; RV32I-NEXT:    add a0, a2, a0
; RV32I-NEXT:    srli a1, a0, 4
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    lui a1, 61681
; RV32I-NEXT:    addi a1, a1, -241
; RV32I-NEXT:    and a0, a0, a1
; RV32I-NEXT:    lui a1, 4112
; RV32I-NEXT:    addi a1, a1, 257
; RV32I-NEXT:    call __mulsi3@plt
; RV32I-NEXT:    srli a0, a0, 24
; RV32I-NEXT:    j .LBB3_3
; RV32I-NEXT:  .LBB3_2:
; RV32I-NEXT:    addi a0, zero, 8
; RV32I-NEXT:  .LBB3_3: # %cond.end
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: test_cttz_i8:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    andi a1, a0, 255
; RV64I-NEXT:    beqz a1, .LBB3_2
; RV64I-NEXT:  # %bb.1: # %cond.false
; RV64I-NEXT:    addi a1, a0, -1
; RV64I-NEXT:    not a0, a0
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    srli a1, a0, 1
; RV64I-NEXT:    lui a2, 21845
; RV64I-NEXT:    addiw a2, a2, 1365
; RV64I-NEXT:    slli a2, a2, 12
; RV64I-NEXT:    addi a2, a2, 1365
; RV64I-NEXT:    slli a2, a2, 12
; RV64I-NEXT:    addi a2, a2, 1365
; RV64I-NEXT:    slli a2, a2, 12
; RV64I-NEXT:    addi a2, a2, 1365
; RV64I-NEXT:    and a1, a1, a2
; RV64I-NEXT:    sub a0, a0, a1
; RV64I-NEXT:    lui a1, 13107
; RV64I-NEXT:    addiw a1, a1, 819
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, 819
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, 819
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, 819
; RV64I-NEXT:    and a2, a0, a1
; RV64I-NEXT:    srli a0, a0, 2
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    add a0, a2, a0
; RV64I-NEXT:    srli a1, a0, 4
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    lui a1, 3855
; RV64I-NEXT:    addiw a1, a1, 241
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, -241
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, 241
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, -241
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    lui a1, 4112
; RV64I-NEXT:    addiw a1, a1, 257
; RV64I-NEXT:    slli a1, a1, 16
; RV64I-NEXT:    addi a1, a1, 257
; RV64I-NEXT:    slli a1, a1, 16
; RV64I-NEXT:    addi a1, a1, 257
; RV64I-NEXT:    call __muldi3@plt
; RV64I-NEXT:    srli a0, a0, 56
; RV64I-NEXT:    j .LBB3_3
; RV64I-NEXT:  .LBB3_2:
; RV64I-NEXT:    addi a0, zero, 8
; RV64I-NEXT:  .LBB3_3: # %cond.end
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
  %tmp = call i8 @llvm.cttz.i8(i8 %a, i1 false)
  ret i8 %tmp
}

define i16 @test_cttz_i16(i16 %a) nounwind {
; RV32I-LABEL: test_cttz_i16:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    lui a1, 16
; RV32I-NEXT:    addi a1, a1, -1
; RV32I-NEXT:    and a1, a0, a1
; RV32I-NEXT:    beqz a1, .LBB4_2
; RV32I-NEXT:  # %bb.1: # %cond.false
; RV32I-NEXT:    addi a1, a0, -1
; RV32I-NEXT:    not a0, a0
; RV32I-NEXT:    and a0, a0, a1
; RV32I-NEXT:    srli a1, a0, 1
; RV32I-NEXT:    lui a2, 349525
; RV32I-NEXT:    addi a2, a2, 1365
; RV32I-NEXT:    and a1, a1, a2
; RV32I-NEXT:    sub a0, a0, a1
; RV32I-NEXT:    lui a1, 209715
; RV32I-NEXT:    addi a1, a1, 819
; RV32I-NEXT:    and a2, a0, a1
; RV32I-NEXT:    srli a0, a0, 2
; RV32I-NEXT:    and a0, a0, a1
; RV32I-NEXT:    add a0, a2, a0
; RV32I-NEXT:    srli a1, a0, 4
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    lui a1, 61681
; RV32I-NEXT:    addi a1, a1, -241
; RV32I-NEXT:    and a0, a0, a1
; RV32I-NEXT:    lui a1, 4112
; RV32I-NEXT:    addi a1, a1, 257
; RV32I-NEXT:    call __mulsi3@plt
; RV32I-NEXT:    srli a0, a0, 24
; RV32I-NEXT:    j .LBB4_3
; RV32I-NEXT:  .LBB4_2:
; RV32I-NEXT:    addi a0, zero, 16
; RV32I-NEXT:  .LBB4_3: # %cond.end
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: test_cttz_i16:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    lui a1, 16
; RV64I-NEXT:    addiw a1, a1, -1
; RV64I-NEXT:    and a1, a0, a1
; RV64I-NEXT:    beqz a1, .LBB4_2
; RV64I-NEXT:  # %bb.1: # %cond.false
; RV64I-NEXT:    addi a1, a0, -1
; RV64I-NEXT:    not a0, a0
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    srli a1, a0, 1
; RV64I-NEXT:    lui a2, 21845
; RV64I-NEXT:    addiw a2, a2, 1365
; RV64I-NEXT:    slli a2, a2, 12
; RV64I-NEXT:    addi a2, a2, 1365
; RV64I-NEXT:    slli a2, a2, 12
; RV64I-NEXT:    addi a2, a2, 1365
; RV64I-NEXT:    slli a2, a2, 12
; RV64I-NEXT:    addi a2, a2, 1365
; RV64I-NEXT:    and a1, a1, a2
; RV64I-NEXT:    sub a0, a0, a1
; RV64I-NEXT:    lui a1, 13107
; RV64I-NEXT:    addiw a1, a1, 819
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, 819
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, 819
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, 819
; RV64I-NEXT:    and a2, a0, a1
; RV64I-NEXT:    srli a0, a0, 2
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    add a0, a2, a0
; RV64I-NEXT:    srli a1, a0, 4
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    lui a1, 3855
; RV64I-NEXT:    addiw a1, a1, 241
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, -241
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, 241
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, -241
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    lui a1, 4112
; RV64I-NEXT:    addiw a1, a1, 257
; RV64I-NEXT:    slli a1, a1, 16
; RV64I-NEXT:    addi a1, a1, 257
; RV64I-NEXT:    slli a1, a1, 16
; RV64I-NEXT:    addi a1, a1, 257
; RV64I-NEXT:    call __muldi3@plt
; RV64I-NEXT:    srli a0, a0, 56
; RV64I-NEXT:    j .LBB4_3
; RV64I-NEXT:  .LBB4_2:
; RV64I-NEXT:    addi a0, zero, 16
; RV64I-NEXT:  .LBB4_3: # %cond.end
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
  %tmp = call i16 @llvm.cttz.i16(i16 %a, i1 false)
  ret i16 %tmp
}

define i32 @test_cttz_i32(i32 %a) nounwind {
; RV32I-LABEL: test_cttz_i32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    beqz a0, .LBB5_2
; RV32I-NEXT:  # %bb.1: # %cond.false
; RV32I-NEXT:    addi a1, a0, -1
; RV32I-NEXT:    not a0, a0
; RV32I-NEXT:    and a0, a0, a1
; RV32I-NEXT:    srli a1, a0, 1
; RV32I-NEXT:    lui a2, 349525
; RV32I-NEXT:    addi a2, a2, 1365
; RV32I-NEXT:    and a1, a1, a2
; RV32I-NEXT:    sub a0, a0, a1
; RV32I-NEXT:    lui a1, 209715
; RV32I-NEXT:    addi a1, a1, 819
; RV32I-NEXT:    and a2, a0, a1
; RV32I-NEXT:    srli a0, a0, 2
; RV32I-NEXT:    and a0, a0, a1
; RV32I-NEXT:    add a0, a2, a0
; RV32I-NEXT:    srli a1, a0, 4
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    lui a1, 61681
; RV32I-NEXT:    addi a1, a1, -241
; RV32I-NEXT:    and a0, a0, a1
; RV32I-NEXT:    lui a1, 4112
; RV32I-NEXT:    addi a1, a1, 257
; RV32I-NEXT:    call __mulsi3@plt
; RV32I-NEXT:    srli a0, a0, 24
; RV32I-NEXT:    j .LBB5_3
; RV32I-NEXT:  .LBB5_2:
; RV32I-NEXT:    addi a0, zero, 32
; RV32I-NEXT:  .LBB5_3: # %cond.end
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: test_cttz_i32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sext.w a1, a0
; RV64I-NEXT:    beqz a1, .LBB5_2
; RV64I-NEXT:  # %bb.1: # %cond.false
; RV64I-NEXT:    addi a1, a0, -1
; RV64I-NEXT:    not a0, a0
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    srli a1, a0, 1
; RV64I-NEXT:    lui a2, 21845
; RV64I-NEXT:    addiw a2, a2, 1365
; RV64I-NEXT:    slli a2, a2, 12
; RV64I-NEXT:    addi a2, a2, 1365
; RV64I-NEXT:    slli a2, a2, 12
; RV64I-NEXT:    addi a2, a2, 1365
; RV64I-NEXT:    slli a2, a2, 12
; RV64I-NEXT:    addi a2, a2, 1365
; RV64I-NEXT:    and a1, a1, a2
; RV64I-NEXT:    sub a0, a0, a1
; RV64I-NEXT:    lui a1, 13107
; RV64I-NEXT:    addiw a1, a1, 819
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, 819
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, 819
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, 819
; RV64I-NEXT:    and a2, a0, a1
; RV64I-NEXT:    srli a0, a0, 2
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    add a0, a2, a0
; RV64I-NEXT:    srli a1, a0, 4
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    lui a1, 3855
; RV64I-NEXT:    addiw a1, a1, 241
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, -241
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, 241
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, -241
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    lui a1, 4112
; RV64I-NEXT:    addiw a1, a1, 257
; RV64I-NEXT:    slli a1, a1, 16
; RV64I-NEXT:    addi a1, a1, 257
; RV64I-NEXT:    slli a1, a1, 16
; RV64I-NEXT:    addi a1, a1, 257
; RV64I-NEXT:    call __muldi3@plt
; RV64I-NEXT:    srli a0, a0, 56
; RV64I-NEXT:    j .LBB5_3
; RV64I-NEXT:  .LBB5_2:
; RV64I-NEXT:    addi a0, zero, 32
; RV64I-NEXT:  .LBB5_3: # %cond.end
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
  %tmp = call i32 @llvm.cttz.i32(i32 %a, i1 false)
  ret i32 %tmp
}

define i32 @test_ctlz_i32(i32 %a) nounwind {
; RV32I-LABEL: test_ctlz_i32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    beqz a0, .LBB6_2
; RV32I-NEXT:  # %bb.1: # %cond.false
; RV32I-NEXT:    srli a1, a0, 1
; RV32I-NEXT:    or a0, a0, a1
; RV32I-NEXT:    srli a1, a0, 2
; RV32I-NEXT:    or a0, a0, a1
; RV32I-NEXT:    srli a1, a0, 4
; RV32I-NEXT:    or a0, a0, a1
; RV32I-NEXT:    srli a1, a0, 8
; RV32I-NEXT:    or a0, a0, a1
; RV32I-NEXT:    srli a1, a0, 16
; RV32I-NEXT:    or a0, a0, a1
; RV32I-NEXT:    not a0, a0
; RV32I-NEXT:    srli a1, a0, 1
; RV32I-NEXT:    lui a2, 349525
; RV32I-NEXT:    addi a2, a2, 1365
; RV32I-NEXT:    and a1, a1, a2
; RV32I-NEXT:    sub a0, a0, a1
; RV32I-NEXT:    lui a1, 209715
; RV32I-NEXT:    addi a1, a1, 819
; RV32I-NEXT:    and a2, a0, a1
; RV32I-NEXT:    srli a0, a0, 2
; RV32I-NEXT:    and a0, a0, a1
; RV32I-NEXT:    add a0, a2, a0
; RV32I-NEXT:    srli a1, a0, 4
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    lui a1, 61681
; RV32I-NEXT:    addi a1, a1, -241
; RV32I-NEXT:    and a0, a0, a1
; RV32I-NEXT:    lui a1, 4112
; RV32I-NEXT:    addi a1, a1, 257
; RV32I-NEXT:    call __mulsi3@plt
; RV32I-NEXT:    srli a0, a0, 24
; RV32I-NEXT:    j .LBB6_3
; RV32I-NEXT:  .LBB6_2:
; RV32I-NEXT:    addi a0, zero, 32
; RV32I-NEXT:  .LBB6_3: # %cond.end
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: test_ctlz_i32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sext.w a1, a0
; RV64I-NEXT:    beqz a1, .LBB6_2
; RV64I-NEXT:  # %bb.1: # %cond.false
; RV64I-NEXT:    srliw a1, a0, 1
; RV64I-NEXT:    slli a0, a0, 32
; RV64I-NEXT:    srli a0, a0, 32
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    srli a1, a0, 2
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    srli a1, a0, 4
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    srli a1, a0, 8
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    srli a1, a0, 16
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    srli a1, a0, 32
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    not a0, a0
; RV64I-NEXT:    srli a1, a0, 1
; RV64I-NEXT:    lui a2, 21845
; RV64I-NEXT:    addiw a2, a2, 1365
; RV64I-NEXT:    slli a2, a2, 12
; RV64I-NEXT:    addi a2, a2, 1365
; RV64I-NEXT:    slli a2, a2, 12
; RV64I-NEXT:    addi a2, a2, 1365
; RV64I-NEXT:    slli a2, a2, 12
; RV64I-NEXT:    addi a2, a2, 1365
; RV64I-NEXT:    and a1, a1, a2
; RV64I-NEXT:    sub a0, a0, a1
; RV64I-NEXT:    lui a1, 13107
; RV64I-NEXT:    addiw a1, a1, 819
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, 819
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, 819
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, 819
; RV64I-NEXT:    and a2, a0, a1
; RV64I-NEXT:    srli a0, a0, 2
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    add a0, a2, a0
; RV64I-NEXT:    srli a1, a0, 4
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    lui a1, 3855
; RV64I-NEXT:    addiw a1, a1, 241
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, -241
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, 241
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, -241
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    lui a1, 4112
; RV64I-NEXT:    addiw a1, a1, 257
; RV64I-NEXT:    slli a1, a1, 16
; RV64I-NEXT:    addi a1, a1, 257
; RV64I-NEXT:    slli a1, a1, 16
; RV64I-NEXT:    addi a1, a1, 257
; RV64I-NEXT:    call __muldi3@plt
; RV64I-NEXT:    srli a0, a0, 56
; RV64I-NEXT:    addi a0, a0, -32
; RV64I-NEXT:    j .LBB6_3
; RV64I-NEXT:  .LBB6_2:
; RV64I-NEXT:    addi a0, zero, 32
; RV64I-NEXT:  .LBB6_3: # %cond.end
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
  %tmp = call i32 @llvm.ctlz.i32(i32 %a, i1 false)
  ret i32 %tmp
}

define i64 @test_cttz_i64(i64 %a) nounwind {
; RV32I-LABEL: test_cttz_i64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -32
; RV32I-NEXT:    sw ra, 28(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s0, 24(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s1, 20(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s2, 16(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s3, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s4, 8(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s5, 4(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s6, 0(sp) # 4-byte Folded Spill
; RV32I-NEXT:    mv s3, a1
; RV32I-NEXT:    mv s4, a0
; RV32I-NEXT:    addi a0, a0, -1
; RV32I-NEXT:    not a1, s4
; RV32I-NEXT:    and a0, a1, a0
; RV32I-NEXT:    srli a1, a0, 1
; RV32I-NEXT:    lui a2, 349525
; RV32I-NEXT:    addi s5, a2, 1365
; RV32I-NEXT:    and a1, a1, s5
; RV32I-NEXT:    sub a0, a0, a1
; RV32I-NEXT:    lui a1, 209715
; RV32I-NEXT:    addi s0, a1, 819
; RV32I-NEXT:    and a1, a0, s0
; RV32I-NEXT:    srli a0, a0, 2
; RV32I-NEXT:    and a0, a0, s0
; RV32I-NEXT:    add a0, a1, a0
; RV32I-NEXT:    srli a1, a0, 4
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    lui a1, 61681
; RV32I-NEXT:    addi s6, a1, -241
; RV32I-NEXT:    and a0, a0, s6
; RV32I-NEXT:    lui a1, 4112
; RV32I-NEXT:    addi s1, a1, 257
; RV32I-NEXT:    mv a1, s1
; RV32I-NEXT:    call __mulsi3@plt
; RV32I-NEXT:    mv s2, a0
; RV32I-NEXT:    addi a0, s3, -1
; RV32I-NEXT:    not a1, s3
; RV32I-NEXT:    and a0, a1, a0
; RV32I-NEXT:    srli a1, a0, 1
; RV32I-NEXT:    and a1, a1, s5
; RV32I-NEXT:    sub a0, a0, a1
; RV32I-NEXT:    and a1, a0, s0
; RV32I-NEXT:    srli a0, a0, 2
; RV32I-NEXT:    and a0, a0, s0
; RV32I-NEXT:    add a0, a1, a0
; RV32I-NEXT:    srli a1, a0, 4
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    and a0, a0, s6
; RV32I-NEXT:    mv a1, s1
; RV32I-NEXT:    call __mulsi3@plt
; RV32I-NEXT:    bnez s4, .LBB7_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    srli a0, a0, 24
; RV32I-NEXT:    addi a0, a0, 32
; RV32I-NEXT:    j .LBB7_3
; RV32I-NEXT:  .LBB7_2:
; RV32I-NEXT:    srli a0, s2, 24
; RV32I-NEXT:  .LBB7_3:
; RV32I-NEXT:    mv a1, zero
; RV32I-NEXT:    lw s6, 0(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s5, 4(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s4, 8(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s3, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s2, 16(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s1, 20(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s0, 24(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw ra, 28(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 32
; RV32I-NEXT:    ret
;
; RV64I-LABEL: test_cttz_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    beqz a0, .LBB7_2
; RV64I-NEXT:  # %bb.1: # %cond.false
; RV64I-NEXT:    addi a1, a0, -1
; RV64I-NEXT:    not a0, a0
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    srli a1, a0, 1
; RV64I-NEXT:    lui a2, 21845
; RV64I-NEXT:    addiw a2, a2, 1365
; RV64I-NEXT:    slli a2, a2, 12
; RV64I-NEXT:    addi a2, a2, 1365
; RV64I-NEXT:    slli a2, a2, 12
; RV64I-NEXT:    addi a2, a2, 1365
; RV64I-NEXT:    slli a2, a2, 12
; RV64I-NEXT:    addi a2, a2, 1365
; RV64I-NEXT:    and a1, a1, a2
; RV64I-NEXT:    sub a0, a0, a1
; RV64I-NEXT:    lui a1, 13107
; RV64I-NEXT:    addiw a1, a1, 819
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, 819
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, 819
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, 819
; RV64I-NEXT:    and a2, a0, a1
; RV64I-NEXT:    srli a0, a0, 2
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    add a0, a2, a0
; RV64I-NEXT:    srli a1, a0, 4
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    lui a1, 3855
; RV64I-NEXT:    addiw a1, a1, 241
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, -241
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, 241
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, -241
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    lui a1, 4112
; RV64I-NEXT:    addiw a1, a1, 257
; RV64I-NEXT:    slli a1, a1, 16
; RV64I-NEXT:    addi a1, a1, 257
; RV64I-NEXT:    slli a1, a1, 16
; RV64I-NEXT:    addi a1, a1, 257
; RV64I-NEXT:    call __muldi3@plt
; RV64I-NEXT:    srli a0, a0, 56
; RV64I-NEXT:    j .LBB7_3
; RV64I-NEXT:  .LBB7_2:
; RV64I-NEXT:    addi a0, zero, 64
; RV64I-NEXT:  .LBB7_3: # %cond.end
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
  %tmp = call i64 @llvm.cttz.i64(i64 %a, i1 false)
  ret i64 %tmp
}

define i8 @test_cttz_i8_zero_undef(i8 %a) nounwind {
; RV32I-LABEL: test_cttz_i8_zero_undef:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    addi a1, a0, -1
; RV32I-NEXT:    not a0, a0
; RV32I-NEXT:    and a0, a0, a1
; RV32I-NEXT:    srli a1, a0, 1
; RV32I-NEXT:    lui a2, 349525
; RV32I-NEXT:    addi a2, a2, 1365
; RV32I-NEXT:    and a1, a1, a2
; RV32I-NEXT:    sub a0, a0, a1
; RV32I-NEXT:    lui a1, 209715
; RV32I-NEXT:    addi a1, a1, 819
; RV32I-NEXT:    and a2, a0, a1
; RV32I-NEXT:    srli a0, a0, 2
; RV32I-NEXT:    and a0, a0, a1
; RV32I-NEXT:    add a0, a2, a0
; RV32I-NEXT:    srli a1, a0, 4
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    lui a1, 61681
; RV32I-NEXT:    addi a1, a1, -241
; RV32I-NEXT:    and a0, a0, a1
; RV32I-NEXT:    lui a1, 4112
; RV32I-NEXT:    addi a1, a1, 257
; RV32I-NEXT:    call __mulsi3@plt
; RV32I-NEXT:    srli a0, a0, 24
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: test_cttz_i8_zero_undef:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    addi a1, a0, -1
; RV64I-NEXT:    not a0, a0
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    srli a1, a0, 1
; RV64I-NEXT:    lui a2, 21845
; RV64I-NEXT:    addiw a2, a2, 1365
; RV64I-NEXT:    slli a2, a2, 12
; RV64I-NEXT:    addi a2, a2, 1365
; RV64I-NEXT:    slli a2, a2, 12
; RV64I-NEXT:    addi a2, a2, 1365
; RV64I-NEXT:    slli a2, a2, 12
; RV64I-NEXT:    addi a2, a2, 1365
; RV64I-NEXT:    and a1, a1, a2
; RV64I-NEXT:    sub a0, a0, a1
; RV64I-NEXT:    lui a1, 13107
; RV64I-NEXT:    addiw a1, a1, 819
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, 819
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, 819
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, 819
; RV64I-NEXT:    and a2, a0, a1
; RV64I-NEXT:    srli a0, a0, 2
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    add a0, a2, a0
; RV64I-NEXT:    srli a1, a0, 4
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    lui a1, 3855
; RV64I-NEXT:    addiw a1, a1, 241
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, -241
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, 241
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, -241
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    lui a1, 4112
; RV64I-NEXT:    addiw a1, a1, 257
; RV64I-NEXT:    slli a1, a1, 16
; RV64I-NEXT:    addi a1, a1, 257
; RV64I-NEXT:    slli a1, a1, 16
; RV64I-NEXT:    addi a1, a1, 257
; RV64I-NEXT:    call __muldi3@plt
; RV64I-NEXT:    srli a0, a0, 56
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
  %tmp = call i8 @llvm.cttz.i8(i8 %a, i1 true)
  ret i8 %tmp
}

define i16 @test_cttz_i16_zero_undef(i16 %a) nounwind {
; RV32I-LABEL: test_cttz_i16_zero_undef:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    addi a1, a0, -1
; RV32I-NEXT:    not a0, a0
; RV32I-NEXT:    and a0, a0, a1
; RV32I-NEXT:    srli a1, a0, 1
; RV32I-NEXT:    lui a2, 349525
; RV32I-NEXT:    addi a2, a2, 1365
; RV32I-NEXT:    and a1, a1, a2
; RV32I-NEXT:    sub a0, a0, a1
; RV32I-NEXT:    lui a1, 209715
; RV32I-NEXT:    addi a1, a1, 819
; RV32I-NEXT:    and a2, a0, a1
; RV32I-NEXT:    srli a0, a0, 2
; RV32I-NEXT:    and a0, a0, a1
; RV32I-NEXT:    add a0, a2, a0
; RV32I-NEXT:    srli a1, a0, 4
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    lui a1, 61681
; RV32I-NEXT:    addi a1, a1, -241
; RV32I-NEXT:    and a0, a0, a1
; RV32I-NEXT:    lui a1, 4112
; RV32I-NEXT:    addi a1, a1, 257
; RV32I-NEXT:    call __mulsi3@plt
; RV32I-NEXT:    srli a0, a0, 24
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: test_cttz_i16_zero_undef:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    addi a1, a0, -1
; RV64I-NEXT:    not a0, a0
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    srli a1, a0, 1
; RV64I-NEXT:    lui a2, 21845
; RV64I-NEXT:    addiw a2, a2, 1365
; RV64I-NEXT:    slli a2, a2, 12
; RV64I-NEXT:    addi a2, a2, 1365
; RV64I-NEXT:    slli a2, a2, 12
; RV64I-NEXT:    addi a2, a2, 1365
; RV64I-NEXT:    slli a2, a2, 12
; RV64I-NEXT:    addi a2, a2, 1365
; RV64I-NEXT:    and a1, a1, a2
; RV64I-NEXT:    sub a0, a0, a1
; RV64I-NEXT:    lui a1, 13107
; RV64I-NEXT:    addiw a1, a1, 819
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, 819
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, 819
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, 819
; RV64I-NEXT:    and a2, a0, a1
; RV64I-NEXT:    srli a0, a0, 2
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    add a0, a2, a0
; RV64I-NEXT:    srli a1, a0, 4
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    lui a1, 3855
; RV64I-NEXT:    addiw a1, a1, 241
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, -241
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, 241
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, -241
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    lui a1, 4112
; RV64I-NEXT:    addiw a1, a1, 257
; RV64I-NEXT:    slli a1, a1, 16
; RV64I-NEXT:    addi a1, a1, 257
; RV64I-NEXT:    slli a1, a1, 16
; RV64I-NEXT:    addi a1, a1, 257
; RV64I-NEXT:    call __muldi3@plt
; RV64I-NEXT:    srli a0, a0, 56
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
  %tmp = call i16 @llvm.cttz.i16(i16 %a, i1 true)
  ret i16 %tmp
}

define i32 @test_cttz_i32_zero_undef(i32 %a) nounwind {
; RV32I-LABEL: test_cttz_i32_zero_undef:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    addi a1, a0, -1
; RV32I-NEXT:    not a0, a0
; RV32I-NEXT:    and a0, a0, a1
; RV32I-NEXT:    srli a1, a0, 1
; RV32I-NEXT:    lui a2, 349525
; RV32I-NEXT:    addi a2, a2, 1365
; RV32I-NEXT:    and a1, a1, a2
; RV32I-NEXT:    sub a0, a0, a1
; RV32I-NEXT:    lui a1, 209715
; RV32I-NEXT:    addi a1, a1, 819
; RV32I-NEXT:    and a2, a0, a1
; RV32I-NEXT:    srli a0, a0, 2
; RV32I-NEXT:    and a0, a0, a1
; RV32I-NEXT:    add a0, a2, a0
; RV32I-NEXT:    srli a1, a0, 4
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    lui a1, 61681
; RV32I-NEXT:    addi a1, a1, -241
; RV32I-NEXT:    and a0, a0, a1
; RV32I-NEXT:    lui a1, 4112
; RV32I-NEXT:    addi a1, a1, 257
; RV32I-NEXT:    call __mulsi3@plt
; RV32I-NEXT:    srli a0, a0, 24
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: test_cttz_i32_zero_undef:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    addi a1, a0, -1
; RV64I-NEXT:    not a0, a0
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    srli a1, a0, 1
; RV64I-NEXT:    lui a2, 21845
; RV64I-NEXT:    addiw a2, a2, 1365
; RV64I-NEXT:    slli a2, a2, 12
; RV64I-NEXT:    addi a2, a2, 1365
; RV64I-NEXT:    slli a2, a2, 12
; RV64I-NEXT:    addi a2, a2, 1365
; RV64I-NEXT:    slli a2, a2, 12
; RV64I-NEXT:    addi a2, a2, 1365
; RV64I-NEXT:    and a1, a1, a2
; RV64I-NEXT:    sub a0, a0, a1
; RV64I-NEXT:    lui a1, 13107
; RV64I-NEXT:    addiw a1, a1, 819
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, 819
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, 819
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, 819
; RV64I-NEXT:    and a2, a0, a1
; RV64I-NEXT:    srli a0, a0, 2
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    add a0, a2, a0
; RV64I-NEXT:    srli a1, a0, 4
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    lui a1, 3855
; RV64I-NEXT:    addiw a1, a1, 241
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, -241
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, 241
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, -241
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    lui a1, 4112
; RV64I-NEXT:    addiw a1, a1, 257
; RV64I-NEXT:    slli a1, a1, 16
; RV64I-NEXT:    addi a1, a1, 257
; RV64I-NEXT:    slli a1, a1, 16
; RV64I-NEXT:    addi a1, a1, 257
; RV64I-NEXT:    call __muldi3@plt
; RV64I-NEXT:    srli a0, a0, 56
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
  %tmp = call i32 @llvm.cttz.i32(i32 %a, i1 true)
  ret i32 %tmp
}

define i64 @test_cttz_i64_zero_undef(i64 %a) nounwind {
; RV32I-LABEL: test_cttz_i64_zero_undef:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -32
; RV32I-NEXT:    sw ra, 28(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s0, 24(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s1, 20(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s2, 16(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s3, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s4, 8(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s5, 4(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s6, 0(sp) # 4-byte Folded Spill
; RV32I-NEXT:    mv s3, a1
; RV32I-NEXT:    mv s4, a0
; RV32I-NEXT:    addi a0, a0, -1
; RV32I-NEXT:    not a1, s4
; RV32I-NEXT:    and a0, a1, a0
; RV32I-NEXT:    srli a1, a0, 1
; RV32I-NEXT:    lui a2, 349525
; RV32I-NEXT:    addi s5, a2, 1365
; RV32I-NEXT:    and a1, a1, s5
; RV32I-NEXT:    sub a0, a0, a1
; RV32I-NEXT:    lui a1, 209715
; RV32I-NEXT:    addi s0, a1, 819
; RV32I-NEXT:    and a1, a0, s0
; RV32I-NEXT:    srli a0, a0, 2
; RV32I-NEXT:    and a0, a0, s0
; RV32I-NEXT:    add a0, a1, a0
; RV32I-NEXT:    srli a1, a0, 4
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    lui a1, 61681
; RV32I-NEXT:    addi s6, a1, -241
; RV32I-NEXT:    and a0, a0, s6
; RV32I-NEXT:    lui a1, 4112
; RV32I-NEXT:    addi s1, a1, 257
; RV32I-NEXT:    mv a1, s1
; RV32I-NEXT:    call __mulsi3@plt
; RV32I-NEXT:    mv s2, a0
; RV32I-NEXT:    addi a0, s3, -1
; RV32I-NEXT:    not a1, s3
; RV32I-NEXT:    and a0, a1, a0
; RV32I-NEXT:    srli a1, a0, 1
; RV32I-NEXT:    and a1, a1, s5
; RV32I-NEXT:    sub a0, a0, a1
; RV32I-NEXT:    and a1, a0, s0
; RV32I-NEXT:    srli a0, a0, 2
; RV32I-NEXT:    and a0, a0, s0
; RV32I-NEXT:    add a0, a1, a0
; RV32I-NEXT:    srli a1, a0, 4
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    and a0, a0, s6
; RV32I-NEXT:    mv a1, s1
; RV32I-NEXT:    call __mulsi3@plt
; RV32I-NEXT:    bnez s4, .LBB11_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    srli a0, a0, 24
; RV32I-NEXT:    addi a0, a0, 32
; RV32I-NEXT:    j .LBB11_3
; RV32I-NEXT:  .LBB11_2:
; RV32I-NEXT:    srli a0, s2, 24
; RV32I-NEXT:  .LBB11_3:
; RV32I-NEXT:    mv a1, zero
; RV32I-NEXT:    lw s6, 0(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s5, 4(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s4, 8(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s3, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s2, 16(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s1, 20(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s0, 24(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw ra, 28(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 32
; RV32I-NEXT:    ret
;
; RV64I-LABEL: test_cttz_i64_zero_undef:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    addi a1, a0, -1
; RV64I-NEXT:    not a0, a0
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    srli a1, a0, 1
; RV64I-NEXT:    lui a2, 21845
; RV64I-NEXT:    addiw a2, a2, 1365
; RV64I-NEXT:    slli a2, a2, 12
; RV64I-NEXT:    addi a2, a2, 1365
; RV64I-NEXT:    slli a2, a2, 12
; RV64I-NEXT:    addi a2, a2, 1365
; RV64I-NEXT:    slli a2, a2, 12
; RV64I-NEXT:    addi a2, a2, 1365
; RV64I-NEXT:    and a1, a1, a2
; RV64I-NEXT:    sub a0, a0, a1
; RV64I-NEXT:    lui a1, 13107
; RV64I-NEXT:    addiw a1, a1, 819
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, 819
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, 819
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, 819
; RV64I-NEXT:    and a2, a0, a1
; RV64I-NEXT:    srli a0, a0, 2
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    add a0, a2, a0
; RV64I-NEXT:    srli a1, a0, 4
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    lui a1, 3855
; RV64I-NEXT:    addiw a1, a1, 241
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, -241
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, 241
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, -241
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    lui a1, 4112
; RV64I-NEXT:    addiw a1, a1, 257
; RV64I-NEXT:    slli a1, a1, 16
; RV64I-NEXT:    addi a1, a1, 257
; RV64I-NEXT:    slli a1, a1, 16
; RV64I-NEXT:    addi a1, a1, 257
; RV64I-NEXT:    call __muldi3@plt
; RV64I-NEXT:    srli a0, a0, 56
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
  %tmp = call i64 @llvm.cttz.i64(i64 %a, i1 true)
  ret i64 %tmp
}

define i32 @test_ctpop_i32(i32 %a) nounwind {
; RV32I-LABEL: test_ctpop_i32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    srli a1, a0, 1
; RV32I-NEXT:    lui a2, 349525
; RV32I-NEXT:    addi a2, a2, 1365
; RV32I-NEXT:    and a1, a1, a2
; RV32I-NEXT:    sub a0, a0, a1
; RV32I-NEXT:    lui a1, 209715
; RV32I-NEXT:    addi a1, a1, 819
; RV32I-NEXT:    and a2, a0, a1
; RV32I-NEXT:    srli a0, a0, 2
; RV32I-NEXT:    and a0, a0, a1
; RV32I-NEXT:    add a0, a2, a0
; RV32I-NEXT:    srli a1, a0, 4
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    lui a1, 61681
; RV32I-NEXT:    addi a1, a1, -241
; RV32I-NEXT:    and a0, a0, a1
; RV32I-NEXT:    lui a1, 4112
; RV32I-NEXT:    addi a1, a1, 257
; RV32I-NEXT:    call __mulsi3@plt
; RV32I-NEXT:    srli a0, a0, 24
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: test_ctpop_i32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    slli a1, a0, 32
; RV64I-NEXT:    srli a1, a1, 32
; RV64I-NEXT:    srliw a0, a0, 1
; RV64I-NEXT:    lui a2, 349525
; RV64I-NEXT:    addiw a2, a2, 1365
; RV64I-NEXT:    and a0, a0, a2
; RV64I-NEXT:    sub a0, a1, a0
; RV64I-NEXT:    srli a1, a0, 2
; RV64I-NEXT:    lui a2, 13107
; RV64I-NEXT:    addiw a2, a2, 819
; RV64I-NEXT:    slli a2, a2, 12
; RV64I-NEXT:    addi a2, a2, 819
; RV64I-NEXT:    slli a2, a2, 12
; RV64I-NEXT:    addi a2, a2, 819
; RV64I-NEXT:    slli a2, a2, 12
; RV64I-NEXT:    addi a2, a2, 819
; RV64I-NEXT:    and a1, a1, a2
; RV64I-NEXT:    and a0, a0, a2
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    srli a1, a0, 4
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    lui a1, 3855
; RV64I-NEXT:    addiw a1, a1, 241
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, -241
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, 241
; RV64I-NEXT:    slli a1, a1, 12
; RV64I-NEXT:    addi a1, a1, -241
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    lui a1, 4112
; RV64I-NEXT:    addiw a1, a1, 257
; RV64I-NEXT:    slli a1, a1, 16
; RV64I-NEXT:    addi a1, a1, 257
; RV64I-NEXT:    slli a1, a1, 16
; RV64I-NEXT:    addi a1, a1, 257
; RV64I-NEXT:    call __muldi3@plt
; RV64I-NEXT:    srli a0, a0, 56
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
  %1 = call i32 @llvm.ctpop.i32(i32 %a)
  ret i32 %1
}
