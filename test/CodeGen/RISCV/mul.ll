; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV32I %s
; RUN: llc -mtriple=riscv32 -mattr=+m -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV32IM %s
; RUN: llc -mtriple=riscv64 -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV64I %s
; RUN: llc -mtriple=riscv64 -mattr=+m -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV64IM %s

define signext i32 @square(i32 %a) nounwind {
; RV32I-LABEL: square:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    mv a1, a0
; RV32I-NEXT:    call __mulsi3@plt
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: square:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    mul a0, a0, a0
; RV32IM-NEXT:    ret
;
; RV64I-LABEL: square:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    mv a1, a0
; RV64I-NEXT:    call __muldi3@plt
; RV64I-NEXT:    sext.w a0, a0
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
;
; RV64IM-LABEL: square:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    mulw a0, a0, a0
; RV64IM-NEXT:    ret
  %1 = mul i32 %a, %a
  ret i32 %1
}

define signext i32 @mul(i32 %a, i32 %b) nounwind {
; RV32I-LABEL: mul:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    call __mulsi3@plt
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: mul:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    mul a0, a0, a1
; RV32IM-NEXT:    ret
;
; RV64I-LABEL: mul:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    call __muldi3@plt
; RV64I-NEXT:    sext.w a0, a0
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
;
; RV64IM-LABEL: mul:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    mulw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = mul i32 %a, %b
  ret i32 %1
}

define signext i32 @mul_constant(i32 %a) nounwind {
; RV32I-LABEL: mul_constant:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a1, a0, 2
; RV32I-NEXT:    add a0, a1, a0
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: mul_constant:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    slli a1, a0, 2
; RV32IM-NEXT:    add a0, a1, a0
; RV32IM-NEXT:    ret
;
; RV64I-LABEL: mul_constant:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a1, a0, 2
; RV64I-NEXT:    addw a0, a1, a0
; RV64I-NEXT:    ret
;
; RV64IM-LABEL: mul_constant:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    slli a1, a0, 2
; RV64IM-NEXT:    addw a0, a1, a0
; RV64IM-NEXT:    ret
  %1 = mul i32 %a, 5
  ret i32 %1
}

define i32 @mul_pow2(i32 %a) nounwind {
; RV32I-LABEL: mul_pow2:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a0, a0, 3
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: mul_pow2:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    slli a0, a0, 3
; RV32IM-NEXT:    ret
;
; RV64I-LABEL: mul_pow2:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 3
; RV64I-NEXT:    ret
;
; RV64IM-LABEL: mul_pow2:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    slli a0, a0, 3
; RV64IM-NEXT:    ret
  %1 = mul i32 %a, 8
  ret i32 %1
}

define i64 @mul64(i64 %a, i64 %b) nounwind {
; RV32I-LABEL: mul64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    call __muldi3@plt
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: mul64:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    mul a3, a0, a3
; RV32IM-NEXT:    mulhu a4, a0, a2
; RV32IM-NEXT:    add a3, a4, a3
; RV32IM-NEXT:    mul a1, a1, a2
; RV32IM-NEXT:    add a1, a3, a1
; RV32IM-NEXT:    mul a0, a0, a2
; RV32IM-NEXT:    ret
;
; RV64I-LABEL: mul64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    call __muldi3@plt
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
;
; RV64IM-LABEL: mul64:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    mul a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = mul i64 %a, %b
  ret i64 %1
}

define i64 @mul64_constant(i64 %a) nounwind {
; RV32I-LABEL: mul64_constant:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a3, a0, 2
; RV32I-NEXT:    add a2, a3, a0
; RV32I-NEXT:    sltu a3, a2, a3
; RV32I-NEXT:    srli a0, a0, 30
; RV32I-NEXT:    slli a4, a1, 2
; RV32I-NEXT:    or a0, a4, a0
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    add a1, a0, a3
; RV32I-NEXT:    mv a0, a2
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: mul64_constant:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    addi a2, zero, 5
; RV32IM-NEXT:    mulhu a2, a0, a2
; RV32IM-NEXT:    slli a3, a1, 2
; RV32IM-NEXT:    add a1, a3, a1
; RV32IM-NEXT:    add a1, a2, a1
; RV32IM-NEXT:    slli a2, a0, 2
; RV32IM-NEXT:    add a0, a2, a0
; RV32IM-NEXT:    ret
;
; RV64I-LABEL: mul64_constant:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a1, a0, 2
; RV64I-NEXT:    add a0, a1, a0
; RV64I-NEXT:    ret
;
; RV64IM-LABEL: mul64_constant:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    slli a1, a0, 2
; RV64IM-NEXT:    add a0, a1, a0
; RV64IM-NEXT:    ret
  %1 = mul i64 %a, 5
  ret i64 %1
}

define i32 @mulhs(i32 %a, i32 %b) nounwind {
; RV32I-LABEL: mulhs:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    mv a2, a1
; RV32I-NEXT:    srai a1, a0, 31
; RV32I-NEXT:    srai a3, a2, 31
; RV32I-NEXT:    call __muldi3@plt
; RV32I-NEXT:    mv a0, a1
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: mulhs:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    mulh a0, a0, a1
; RV32IM-NEXT:    ret
;
; RV64I-LABEL: mulhs:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sext.w a0, a0
; RV64I-NEXT:    sext.w a1, a1
; RV64I-NEXT:    call __muldi3@plt
; RV64I-NEXT:    srli a0, a0, 32
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
;
; RV64IM-LABEL: mulhs:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    sext.w a0, a0
; RV64IM-NEXT:    sext.w a1, a1
; RV64IM-NEXT:    mul a0, a0, a1
; RV64IM-NEXT:    srli a0, a0, 32
; RV64IM-NEXT:    ret
  %1 = sext i32 %a to i64
  %2 = sext i32 %b to i64
  %3 = mul i64 %1, %2
  %4 = lshr i64 %3, 32
  %5 = trunc i64 %4 to i32
  ret i32 %5
}

define zeroext i32 @mulhu(i32 zeroext %a, i32 zeroext %b) nounwind {
; RV32I-LABEL: mulhu:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    mv a2, a1
; RV32I-NEXT:    mv a1, zero
; RV32I-NEXT:    mv a3, zero
; RV32I-NEXT:    call __muldi3@plt
; RV32I-NEXT:    mv a0, a1
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: mulhu:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    mulhu a0, a0, a1
; RV32IM-NEXT:    ret
;
; RV64I-LABEL: mulhu:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    call __muldi3@plt
; RV64I-NEXT:    srli a0, a0, 32
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
;
; RV64IM-LABEL: mulhu:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    mul a0, a0, a1
; RV64IM-NEXT:    srli a0, a0, 32
; RV64IM-NEXT:    ret
  %1 = zext i32 %a to i64
  %2 = zext i32 %b to i64
  %3 = mul i64 %1, %2
  %4 = lshr i64 %3, 32
  %5 = trunc i64 %4 to i32
  ret i32 %5
}

define i32 @mulhsu(i32 %a, i32 %b) nounwind {
; RV32I-LABEL: mulhsu:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    mv a2, a1
; RV32I-NEXT:    srai a3, a1, 31
; RV32I-NEXT:    mv a1, zero
; RV32I-NEXT:    call __muldi3@plt
; RV32I-NEXT:    mv a0, a1
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: mulhsu:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    srai a2, a1, 31
; RV32IM-NEXT:    mulhu a1, a0, a1
; RV32IM-NEXT:    mul a0, a0, a2
; RV32IM-NEXT:    add a0, a1, a0
; RV32IM-NEXT:    ret
;
; RV64I-LABEL: mulhsu:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    slli a0, a0, 32
; RV64I-NEXT:    srli a0, a0, 32
; RV64I-NEXT:    sext.w a1, a1
; RV64I-NEXT:    call __muldi3@plt
; RV64I-NEXT:    srli a0, a0, 32
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
;
; RV64IM-LABEL: mulhsu:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    slli a0, a0, 32
; RV64IM-NEXT:    srli a0, a0, 32
; RV64IM-NEXT:    sext.w a1, a1
; RV64IM-NEXT:    mul a0, a0, a1
; RV64IM-NEXT:    srli a0, a0, 32
; RV64IM-NEXT:    ret
  %1 = zext i32 %a to i64
  %2 = sext i32 %b to i64
  %3 = mul i64 %1, %2
  %4 = lshr i64 %3, 32
  %5 = trunc i64 %4 to i32
  ret i32 %5
}

define i32 @muli32_p65(i32 %a) nounwind {
; RV32I-LABEL: muli32_p65:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a1, a0, 6
; RV32I-NEXT:    add a0, a1, a0
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: muli32_p65:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    slli a1, a0, 6
; RV32IM-NEXT:    add a0, a1, a0
; RV32IM-NEXT:    ret
;
; RV64I-LABEL: muli32_p65:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a1, a0, 6
; RV64I-NEXT:    addw a0, a1, a0
; RV64I-NEXT:    ret
;
; RV64IM-LABEL: muli32_p65:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    slli a1, a0, 6
; RV64IM-NEXT:    addw a0, a1, a0
; RV64IM-NEXT:    ret
  %1 = mul i32 %a, 65
  ret i32 %1
}

define i32 @muli32_p63(i32 %a) nounwind {
; RV32I-LABEL: muli32_p63:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a1, a0, 6
; RV32I-NEXT:    sub a0, a1, a0
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: muli32_p63:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    slli a1, a0, 6
; RV32IM-NEXT:    sub a0, a1, a0
; RV32IM-NEXT:    ret
;
; RV64I-LABEL: muli32_p63:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a1, a0, 6
; RV64I-NEXT:    subw a0, a1, a0
; RV64I-NEXT:    ret
;
; RV64IM-LABEL: muli32_p63:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    slli a1, a0, 6
; RV64IM-NEXT:    subw a0, a1, a0
; RV64IM-NEXT:    ret
  %1 = mul i32 %a, 63
  ret i32 %1
}

define i64 @muli64_p65(i64 %a) nounwind {
; RV32I-LABEL: muli64_p65:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a3, a0, 6
; RV32I-NEXT:    add a2, a3, a0
; RV32I-NEXT:    sltu a3, a2, a3
; RV32I-NEXT:    srli a0, a0, 26
; RV32I-NEXT:    slli a4, a1, 6
; RV32I-NEXT:    or a0, a4, a0
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    add a1, a0, a3
; RV32I-NEXT:    mv a0, a2
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: muli64_p65:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    addi a2, zero, 65
; RV32IM-NEXT:    mulhu a2, a0, a2
; RV32IM-NEXT:    slli a3, a1, 6
; RV32IM-NEXT:    add a1, a3, a1
; RV32IM-NEXT:    add a1, a2, a1
; RV32IM-NEXT:    slli a2, a0, 6
; RV32IM-NEXT:    add a0, a2, a0
; RV32IM-NEXT:    ret
;
; RV64I-LABEL: muli64_p65:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a1, a0, 6
; RV64I-NEXT:    add a0, a1, a0
; RV64I-NEXT:    ret
;
; RV64IM-LABEL: muli64_p65:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    slli a1, a0, 6
; RV64IM-NEXT:    add a0, a1, a0
; RV64IM-NEXT:    ret
  %1 = mul i64 %a, 65
  ret i64 %1
}

define i64 @muli64_p63(i64 %a) nounwind {
; RV32I-LABEL: muli64_p63:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a2, a0, 6
; RV32I-NEXT:    sltu a3, a2, a0
; RV32I-NEXT:    srli a4, a0, 26
; RV32I-NEXT:    slli a5, a1, 6
; RV32I-NEXT:    or a4, a5, a4
; RV32I-NEXT:    sub a1, a4, a1
; RV32I-NEXT:    sub a1, a1, a3
; RV32I-NEXT:    sub a0, a2, a0
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: muli64_p63:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    addi a2, zero, 63
; RV32IM-NEXT:    mulhu a2, a0, a2
; RV32IM-NEXT:    slli a3, a1, 6
; RV32IM-NEXT:    sub a1, a3, a1
; RV32IM-NEXT:    add a1, a2, a1
; RV32IM-NEXT:    slli a2, a0, 6
; RV32IM-NEXT:    sub a0, a2, a0
; RV32IM-NEXT:    ret
;
; RV64I-LABEL: muli64_p63:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a1, a0, 6
; RV64I-NEXT:    sub a0, a1, a0
; RV64I-NEXT:    ret
;
; RV64IM-LABEL: muli64_p63:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    slli a1, a0, 6
; RV64IM-NEXT:    sub a0, a1, a0
; RV64IM-NEXT:    ret
  %1 = mul i64 %a, 63
  ret i64 %1
}

define i32 @muli32_m63(i32 %a) nounwind {
; RV32I-LABEL: muli32_m63:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a1, a0, 6
; RV32I-NEXT:    sub a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: muli32_m63:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    slli a1, a0, 6
; RV32IM-NEXT:    sub a0, a0, a1
; RV32IM-NEXT:    ret
;
; RV64I-LABEL: muli32_m63:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a1, a0, 6
; RV64I-NEXT:    subw a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IM-LABEL: muli32_m63:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    slli a1, a0, 6
; RV64IM-NEXT:    subw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = mul i32 %a, -63
  ret i32 %1
}

define i32 @muli32_m65(i32 %a) nounwind {
; RV32I-LABEL: muli32_m65:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a1, a0, 6
; RV32I-NEXT:    add a0, a1, a0
; RV32I-NEXT:    neg a0, a0
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: muli32_m65:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    slli a1, a0, 6
; RV32IM-NEXT:    add a0, a1, a0
; RV32IM-NEXT:    neg a0, a0
; RV32IM-NEXT:    ret
;
; RV64I-LABEL: muli32_m65:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a1, a0, 6
; RV64I-NEXT:    add a0, a1, a0
; RV64I-NEXT:    negw a0, a0
; RV64I-NEXT:    ret
;
; RV64IM-LABEL: muli32_m65:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    slli a1, a0, 6
; RV64IM-NEXT:    add a0, a1, a0
; RV64IM-NEXT:    negw a0, a0
; RV64IM-NEXT:    ret
  %1 = mul i32 %a, -65
  ret i32 %1
}

define i64 @muli64_m63(i64 %a) nounwind {
; RV32I-LABEL: muli64_m63:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a2, a0, 6
; RV32I-NEXT:    sltu a3, a0, a2
; RV32I-NEXT:    srli a4, a0, 26
; RV32I-NEXT:    slli a5, a1, 6
; RV32I-NEXT:    or a4, a5, a4
; RV32I-NEXT:    sub a1, a1, a4
; RV32I-NEXT:    sub a1, a1, a3
; RV32I-NEXT:    sub a0, a0, a2
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: muli64_m63:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    slli a2, a1, 6
; RV32IM-NEXT:    sub a1, a1, a2
; RV32IM-NEXT:    addi a2, zero, -63
; RV32IM-NEXT:    mulhu a2, a0, a2
; RV32IM-NEXT:    sub a2, a2, a0
; RV32IM-NEXT:    add a1, a2, a1
; RV32IM-NEXT:    slli a2, a0, 6
; RV32IM-NEXT:    sub a0, a0, a2
; RV32IM-NEXT:    ret
;
; RV64I-LABEL: muli64_m63:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a1, a0, 6
; RV64I-NEXT:    sub a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IM-LABEL: muli64_m63:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    slli a1, a0, 6
; RV64IM-NEXT:    sub a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = mul i64 %a, -63
  ret i64 %1
}

define i64 @muli64_m65(i64 %a) nounwind {
; RV32I-LABEL: muli64_m65:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a2, a0, 6
; RV32I-NEXT:    add a3, a2, a0
; RV32I-NEXT:    sltu a2, a3, a2
; RV32I-NEXT:    srli a0, a0, 26
; RV32I-NEXT:    slli a4, a1, 6
; RV32I-NEXT:    or a0, a4, a0
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    add a0, a0, a2
; RV32I-NEXT:    snez a1, a3
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    neg a1, a0
; RV32I-NEXT:    neg a0, a3
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: muli64_m65:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    slli a2, a1, 6
; RV32IM-NEXT:    add a1, a2, a1
; RV32IM-NEXT:    addi a2, zero, -65
; RV32IM-NEXT:    mulhu a2, a0, a2
; RV32IM-NEXT:    sub a2, a2, a0
; RV32IM-NEXT:    sub a1, a2, a1
; RV32IM-NEXT:    slli a2, a0, 6
; RV32IM-NEXT:    add a0, a2, a0
; RV32IM-NEXT:    neg a0, a0
; RV32IM-NEXT:    ret
;
; RV64I-LABEL: muli64_m65:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a1, a0, 6
; RV64I-NEXT:    add a0, a1, a0
; RV64I-NEXT:    neg a0, a0
; RV64I-NEXT:    ret
;
; RV64IM-LABEL: muli64_m65:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    slli a1, a0, 6
; RV64IM-NEXT:    add a0, a1, a0
; RV64IM-NEXT:    neg a0, a0
; RV64IM-NEXT:    ret
  %1 = mul i64 %a, -65
  ret i64 %1
}

define i32 @muli32_p384(i32 %a) nounwind {
; RV32I-LABEL: muli32_p384:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    addi a1, zero, 384
; RV32I-NEXT:    call __mulsi3@plt
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: muli32_p384:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    addi a1, zero, 384
; RV32IM-NEXT:    mul a0, a0, a1
; RV32IM-NEXT:    ret
;
; RV64I-LABEL: muli32_p384:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    addi a1, zero, 384
; RV64I-NEXT:    call __muldi3@plt
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
;
; RV64IM-LABEL: muli32_p384:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    addi a1, zero, 384
; RV64IM-NEXT:    mul a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = mul i32 %a, 384
  ret i32 %1
}

define i32 @muli32_p12288(i32 %a) nounwind {
; RV32I-LABEL: muli32_p12288:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    lui a1, 3
; RV32I-NEXT:    call __mulsi3@plt
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: muli32_p12288:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    lui a1, 3
; RV32IM-NEXT:    mul a0, a0, a1
; RV32IM-NEXT:    ret
;
; RV64I-LABEL: muli32_p12288:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    lui a1, 3
; RV64I-NEXT:    call __muldi3@plt
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
;
; RV64IM-LABEL: muli32_p12288:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    lui a1, 3
; RV64IM-NEXT:    mul a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = mul i32 %a, 12288
  ret i32 %1
}

define i32 @muli32_p4352(i32 %a) nounwind {
; RV32I-LABEL: muli32_p4352:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a1, a0, 8
; RV32I-NEXT:    slli a0, a0, 12
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: muli32_p4352:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    lui a1, 1
; RV32IM-NEXT:    addi a1, a1, 256
; RV32IM-NEXT:    mul a0, a0, a1
; RV32IM-NEXT:    ret
;
; RV64I-LABEL: muli32_p4352:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a1, a0, 8
; RV64I-NEXT:    slli a0, a0, 12
; RV64I-NEXT:    addw a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IM-LABEL: muli32_p4352:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    slli a1, a0, 8
; RV64IM-NEXT:    slli a0, a0, 12
; RV64IM-NEXT:    addw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = mul i32 %a, 4352
  ret i32 %1
}

define i32 @muli32_p3840(i32 %a) nounwind {
; RV32I-LABEL: muli32_p3840:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a1, a0, 8
; RV32I-NEXT:    slli a0, a0, 12
; RV32I-NEXT:    sub a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: muli32_p3840:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    lui a1, 1
; RV32IM-NEXT:    addi a1, a1, -256
; RV32IM-NEXT:    mul a0, a0, a1
; RV32IM-NEXT:    ret
;
; RV64I-LABEL: muli32_p3840:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a1, a0, 8
; RV64I-NEXT:    slli a0, a0, 12
; RV64I-NEXT:    subw a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IM-LABEL: muli32_p3840:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    slli a1, a0, 8
; RV64IM-NEXT:    slli a0, a0, 12
; RV64IM-NEXT:    subw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = mul i32 %a, 3840
  ret i32 %1
}

define i32 @muli32_m3840(i32 %a) nounwind {
; RV32I-LABEL: muli32_m3840:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a1, a0, 12
; RV32I-NEXT:    slli a0, a0, 8
; RV32I-NEXT:    sub a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: muli32_m3840:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    lui a1, 1048575
; RV32IM-NEXT:    addi a1, a1, 256
; RV32IM-NEXT:    mul a0, a0, a1
; RV32IM-NEXT:    ret
;
; RV64I-LABEL: muli32_m3840:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a1, a0, 12
; RV64I-NEXT:    slli a0, a0, 8
; RV64I-NEXT:    subw a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IM-LABEL: muli32_m3840:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    slli a1, a0, 12
; RV64IM-NEXT:    slli a0, a0, 8
; RV64IM-NEXT:    subw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = mul i32 %a, -3840
  ret i32 %1
}

define i32 @muli32_m4352(i32 %a) nounwind {
; RV32I-LABEL: muli32_m4352:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    lui a1, 1048575
; RV32I-NEXT:    addi a1, a1, -256
; RV32I-NEXT:    call __mulsi3@plt
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: muli32_m4352:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    lui a1, 1048575
; RV32IM-NEXT:    addi a1, a1, -256
; RV32IM-NEXT:    mul a0, a0, a1
; RV32IM-NEXT:    ret
;
; RV64I-LABEL: muli32_m4352:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    lui a1, 1048575
; RV64I-NEXT:    addiw a1, a1, -256
; RV64I-NEXT:    call __muldi3@plt
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
;
; RV64IM-LABEL: muli32_m4352:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    lui a1, 1048575
; RV64IM-NEXT:    addiw a1, a1, -256
; RV64IM-NEXT:    mul a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = mul i32 %a, -4352
  ret i32 %1
}

define i64 @muli64_p4352(i64 %a) nounwind {
; RV32I-LABEL: muli64_p4352:
; RV32I:       # %bb.0:
; RV32I-NEXT:    srli a2, a0, 24
; RV32I-NEXT:    slli a3, a1, 8
; RV32I-NEXT:    or a2, a3, a2
; RV32I-NEXT:    srli a3, a0, 20
; RV32I-NEXT:    slli a1, a1, 12
; RV32I-NEXT:    or a1, a1, a3
; RV32I-NEXT:    add a1, a1, a2
; RV32I-NEXT:    slli a2, a0, 8
; RV32I-NEXT:    slli a3, a0, 12
; RV32I-NEXT:    add a0, a3, a2
; RV32I-NEXT:    sltu a2, a0, a3
; RV32I-NEXT:    add a1, a1, a2
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: muli64_p4352:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    lui a2, 1
; RV32IM-NEXT:    addi a2, a2, 256
; RV32IM-NEXT:    mul a1, a1, a2
; RV32IM-NEXT:    mulhu a3, a0, a2
; RV32IM-NEXT:    add a1, a3, a1
; RV32IM-NEXT:    mul a0, a0, a2
; RV32IM-NEXT:    ret
;
; RV64I-LABEL: muli64_p4352:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a1, a0, 8
; RV64I-NEXT:    slli a0, a0, 12
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IM-LABEL: muli64_p4352:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    lui a1, 1
; RV64IM-NEXT:    addiw a1, a1, 256
; RV64IM-NEXT:    mul a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = mul i64 %a, 4352
  ret i64 %1
}

define i64 @muli64_p3840(i64 %a) nounwind {
; RV32I-LABEL: muli64_p3840:
; RV32I:       # %bb.0:
; RV32I-NEXT:    srli a2, a0, 24
; RV32I-NEXT:    slli a3, a1, 8
; RV32I-NEXT:    or a2, a3, a2
; RV32I-NEXT:    srli a3, a0, 20
; RV32I-NEXT:    slli a1, a1, 12
; RV32I-NEXT:    or a1, a1, a3
; RV32I-NEXT:    sub a1, a1, a2
; RV32I-NEXT:    slli a2, a0, 8
; RV32I-NEXT:    slli a0, a0, 12
; RV32I-NEXT:    sltu a3, a0, a2
; RV32I-NEXT:    sub a1, a1, a3
; RV32I-NEXT:    sub a0, a0, a2
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: muli64_p3840:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    lui a2, 1
; RV32IM-NEXT:    addi a2, a2, -256
; RV32IM-NEXT:    mul a1, a1, a2
; RV32IM-NEXT:    mulhu a3, a0, a2
; RV32IM-NEXT:    add a1, a3, a1
; RV32IM-NEXT:    mul a0, a0, a2
; RV32IM-NEXT:    ret
;
; RV64I-LABEL: muli64_p3840:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a1, a0, 8
; RV64I-NEXT:    slli a0, a0, 12
; RV64I-NEXT:    sub a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IM-LABEL: muli64_p3840:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    lui a1, 1
; RV64IM-NEXT:    addiw a1, a1, -256
; RV64IM-NEXT:    mul a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = mul i64 %a, 3840
  ret i64 %1
}

define i64 @muli64_m4352(i64 %a) nounwind {
; RV32I-LABEL: muli64_m4352:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    lui a2, 1048575
; RV32I-NEXT:    addi a2, a2, -256
; RV32I-NEXT:    addi a3, zero, -1
; RV32I-NEXT:    call __muldi3@plt
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: muli64_m4352:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    lui a2, 1048575
; RV32IM-NEXT:    addi a2, a2, -256
; RV32IM-NEXT:    mul a1, a1, a2
; RV32IM-NEXT:    mulhu a3, a0, a2
; RV32IM-NEXT:    sub a3, a3, a0
; RV32IM-NEXT:    add a1, a3, a1
; RV32IM-NEXT:    mul a0, a0, a2
; RV32IM-NEXT:    ret
;
; RV64I-LABEL: muli64_m4352:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    lui a1, 1048575
; RV64I-NEXT:    addiw a1, a1, -256
; RV64I-NEXT:    call __muldi3@plt
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
;
; RV64IM-LABEL: muli64_m4352:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    lui a1, 1048575
; RV64IM-NEXT:    addiw a1, a1, -256
; RV64IM-NEXT:    mul a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = mul i64 %a, -4352
  ret i64 %1
}

define i64 @muli64_m3840(i64 %a) nounwind {
; RV32I-LABEL: muli64_m3840:
; RV32I:       # %bb.0:
; RV32I-NEXT:    srli a2, a0, 20
; RV32I-NEXT:    slli a3, a1, 12
; RV32I-NEXT:    or a2, a3, a2
; RV32I-NEXT:    srli a3, a0, 24
; RV32I-NEXT:    slli a1, a1, 8
; RV32I-NEXT:    or a1, a1, a3
; RV32I-NEXT:    sub a1, a1, a2
; RV32I-NEXT:    slli a2, a0, 12
; RV32I-NEXT:    slli a0, a0, 8
; RV32I-NEXT:    sltu a3, a0, a2
; RV32I-NEXT:    sub a1, a1, a3
; RV32I-NEXT:    sub a0, a0, a2
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: muli64_m3840:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    lui a2, 1048575
; RV32IM-NEXT:    addi a2, a2, 256
; RV32IM-NEXT:    mul a1, a1, a2
; RV32IM-NEXT:    mulhu a3, a0, a2
; RV32IM-NEXT:    sub a3, a3, a0
; RV32IM-NEXT:    add a1, a3, a1
; RV32IM-NEXT:    mul a0, a0, a2
; RV32IM-NEXT:    ret
;
; RV64I-LABEL: muli64_m3840:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a1, a0, 12
; RV64I-NEXT:    slli a0, a0, 8
; RV64I-NEXT:    sub a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IM-LABEL: muli64_m3840:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    lui a1, 1048575
; RV64IM-NEXT:    addiw a1, a1, 256
; RV64IM-NEXT:    mul a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = mul i64 %a, -3840
  ret i64 %1
}

define i128 @muli128_m3840(i128 %a) nounwind {
; RV32I-LABEL: muli128_m3840:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lw a2, 4(a1)
; RV32I-NEXT:    lw a3, 8(a1)
; RV32I-NEXT:    lw a4, 0(a1)
; RV32I-NEXT:    lw a1, 12(a1)
; RV32I-NEXT:    srli a6, a2, 20
; RV32I-NEXT:    slli a5, a3, 12
; RV32I-NEXT:    or a6, a5, a6
; RV32I-NEXT:    srli a7, a2, 24
; RV32I-NEXT:    slli a5, a3, 8
; RV32I-NEXT:    or a7, a5, a7
; RV32I-NEXT:    sltu t0, a7, a6
; RV32I-NEXT:    srli t1, a3, 20
; RV32I-NEXT:    slli a5, a1, 12
; RV32I-NEXT:    or a5, a5, t1
; RV32I-NEXT:    srli a3, a3, 24
; RV32I-NEXT:    slli a1, a1, 8
; RV32I-NEXT:    or a1, a1, a3
; RV32I-NEXT:    sub t2, a1, a5
; RV32I-NEXT:    srli a1, a4, 20
; RV32I-NEXT:    slli a3, a2, 12
; RV32I-NEXT:    or a3, a3, a1
; RV32I-NEXT:    srli a1, a4, 24
; RV32I-NEXT:    slli a2, a2, 8
; RV32I-NEXT:    or a5, a2, a1
; RV32I-NEXT:    slli t1, a4, 12
; RV32I-NEXT:    slli t3, a4, 8
; RV32I-NEXT:    sltu t4, t3, t1
; RV32I-NEXT:    sub t0, t2, t0
; RV32I-NEXT:    mv a2, t4
; RV32I-NEXT:    beq a5, a3, .LBB27_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    sltu a2, a5, a3
; RV32I-NEXT:  .LBB27_2:
; RV32I-NEXT:    sub a1, a7, a6
; RV32I-NEXT:    sltu a4, a1, a2
; RV32I-NEXT:    sub a4, t0, a4
; RV32I-NEXT:    sub a1, a1, a2
; RV32I-NEXT:    sub a2, a5, a3
; RV32I-NEXT:    sub a2, a2, t4
; RV32I-NEXT:    sub a3, t3, t1
; RV32I-NEXT:    sw a3, 0(a0)
; RV32I-NEXT:    sw a2, 4(a0)
; RV32I-NEXT:    sw a1, 8(a0)
; RV32I-NEXT:    sw a4, 12(a0)
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: muli128_m3840:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    addi sp, sp, -64
; RV32IM-NEXT:    sw ra, 60(sp) # 4-byte Folded Spill
; RV32IM-NEXT:    sw s0, 56(sp) # 4-byte Folded Spill
; RV32IM-NEXT:    lw a3, 0(a1)
; RV32IM-NEXT:    lw a2, 4(a1)
; RV32IM-NEXT:    lw a4, 8(a1)
; RV32IM-NEXT:    lw a1, 12(a1)
; RV32IM-NEXT:    mv s0, a0
; RV32IM-NEXT:    addi a0, zero, -1
; RV32IM-NEXT:    sw a0, 20(sp)
; RV32IM-NEXT:    sw a0, 16(sp)
; RV32IM-NEXT:    sw a0, 12(sp)
; RV32IM-NEXT:    lui a0, 1048575
; RV32IM-NEXT:    addi a0, a0, 256
; RV32IM-NEXT:    sw a0, 8(sp)
; RV32IM-NEXT:    sw a1, 36(sp)
; RV32IM-NEXT:    sw a4, 32(sp)
; RV32IM-NEXT:    sw a2, 28(sp)
; RV32IM-NEXT:    addi a0, sp, 40
; RV32IM-NEXT:    addi a1, sp, 24
; RV32IM-NEXT:    addi a2, sp, 8
; RV32IM-NEXT:    sw a3, 24(sp)
; RV32IM-NEXT:    call __multi3@plt
; RV32IM-NEXT:    lw a0, 52(sp)
; RV32IM-NEXT:    lw a1, 48(sp)
; RV32IM-NEXT:    lw a2, 44(sp)
; RV32IM-NEXT:    lw a3, 40(sp)
; RV32IM-NEXT:    sw a0, 12(s0)
; RV32IM-NEXT:    sw a1, 8(s0)
; RV32IM-NEXT:    sw a2, 4(s0)
; RV32IM-NEXT:    sw a3, 0(s0)
; RV32IM-NEXT:    lw s0, 56(sp) # 4-byte Folded Reload
; RV32IM-NEXT:    lw ra, 60(sp) # 4-byte Folded Reload
; RV32IM-NEXT:    addi sp, sp, 64
; RV32IM-NEXT:    ret
;
; RV64I-LABEL: muli128_m3840:
; RV64I:       # %bb.0:
; RV64I-NEXT:    srli a2, a0, 52
; RV64I-NEXT:    slli a3, a1, 12
; RV64I-NEXT:    or a2, a3, a2
; RV64I-NEXT:    srli a3, a0, 56
; RV64I-NEXT:    slli a1, a1, 8
; RV64I-NEXT:    or a1, a1, a3
; RV64I-NEXT:    sub a1, a1, a2
; RV64I-NEXT:    slli a2, a0, 12
; RV64I-NEXT:    slli a0, a0, 8
; RV64I-NEXT:    sltu a3, a0, a2
; RV64I-NEXT:    sub a1, a1, a3
; RV64I-NEXT:    sub a0, a0, a2
; RV64I-NEXT:    ret
;
; RV64IM-LABEL: muli128_m3840:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    lui a2, 1048575
; RV64IM-NEXT:    addiw a2, a2, 256
; RV64IM-NEXT:    mul a1, a1, a2
; RV64IM-NEXT:    mulhu a3, a0, a2
; RV64IM-NEXT:    sub a3, a3, a0
; RV64IM-NEXT:    add a1, a3, a1
; RV64IM-NEXT:    mul a0, a0, a2
; RV64IM-NEXT:    ret
  %1 = mul i128 %a, -3840
  ret i128 %1
}

define i128 @muli128_m63(i128 %a) nounwind {
; RV32I-LABEL: muli128_m63:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lw a2, 0(a1)
; RV32I-NEXT:    lw t0, 12(a1)
; RV32I-NEXT:    lw a4, 8(a1)
; RV32I-NEXT:    lw a3, 4(a1)
; RV32I-NEXT:    slli a6, a2, 6
; RV32I-NEXT:    sltu a7, a2, a6
; RV32I-NEXT:    srli a1, a2, 26
; RV32I-NEXT:    slli a5, a3, 6
; RV32I-NEXT:    or t2, a5, a1
; RV32I-NEXT:    mv t3, a7
; RV32I-NEXT:    beq a3, t2, .LBB28_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    sltu t3, a3, t2
; RV32I-NEXT:  .LBB28_2:
; RV32I-NEXT:    srli t1, a3, 26
; RV32I-NEXT:    slli a1, a4, 6
; RV32I-NEXT:    or a1, a1, t1
; RV32I-NEXT:    sub a5, a4, a1
; RV32I-NEXT:    sltu t1, a5, t3
; RV32I-NEXT:    sltu t4, a4, a1
; RV32I-NEXT:    srli a4, a4, 26
; RV32I-NEXT:    slli a1, t0, 6
; RV32I-NEXT:    or a1, a1, a4
; RV32I-NEXT:    sub a1, t0, a1
; RV32I-NEXT:    sub a1, a1, t4
; RV32I-NEXT:    sub a1, a1, t1
; RV32I-NEXT:    sub a4, a5, t3
; RV32I-NEXT:    sub a3, a3, t2
; RV32I-NEXT:    sub a3, a3, a7
; RV32I-NEXT:    sub a2, a2, a6
; RV32I-NEXT:    sw a2, 0(a0)
; RV32I-NEXT:    sw a3, 4(a0)
; RV32I-NEXT:    sw a4, 8(a0)
; RV32I-NEXT:    sw a1, 12(a0)
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: muli128_m63:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    addi sp, sp, -64
; RV32IM-NEXT:    sw ra, 60(sp) # 4-byte Folded Spill
; RV32IM-NEXT:    sw s0, 56(sp) # 4-byte Folded Spill
; RV32IM-NEXT:    lw a3, 0(a1)
; RV32IM-NEXT:    lw a2, 4(a1)
; RV32IM-NEXT:    lw a4, 8(a1)
; RV32IM-NEXT:    lw a1, 12(a1)
; RV32IM-NEXT:    mv s0, a0
; RV32IM-NEXT:    addi a0, zero, -1
; RV32IM-NEXT:    sw a0, 20(sp)
; RV32IM-NEXT:    sw a0, 16(sp)
; RV32IM-NEXT:    sw a0, 12(sp)
; RV32IM-NEXT:    addi a0, zero, -63
; RV32IM-NEXT:    sw a0, 8(sp)
; RV32IM-NEXT:    sw a1, 36(sp)
; RV32IM-NEXT:    sw a4, 32(sp)
; RV32IM-NEXT:    sw a2, 28(sp)
; RV32IM-NEXT:    addi a0, sp, 40
; RV32IM-NEXT:    addi a1, sp, 24
; RV32IM-NEXT:    addi a2, sp, 8
; RV32IM-NEXT:    sw a3, 24(sp)
; RV32IM-NEXT:    call __multi3@plt
; RV32IM-NEXT:    lw a0, 52(sp)
; RV32IM-NEXT:    lw a1, 48(sp)
; RV32IM-NEXT:    lw a2, 44(sp)
; RV32IM-NEXT:    lw a3, 40(sp)
; RV32IM-NEXT:    sw a0, 12(s0)
; RV32IM-NEXT:    sw a1, 8(s0)
; RV32IM-NEXT:    sw a2, 4(s0)
; RV32IM-NEXT:    sw a3, 0(s0)
; RV32IM-NEXT:    lw s0, 56(sp) # 4-byte Folded Reload
; RV32IM-NEXT:    lw ra, 60(sp) # 4-byte Folded Reload
; RV32IM-NEXT:    addi sp, sp, 64
; RV32IM-NEXT:    ret
;
; RV64I-LABEL: muli128_m63:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a2, a0, 6
; RV64I-NEXT:    sltu a3, a0, a2
; RV64I-NEXT:    srli a4, a0, 58
; RV64I-NEXT:    slli a5, a1, 6
; RV64I-NEXT:    or a4, a5, a4
; RV64I-NEXT:    sub a1, a1, a4
; RV64I-NEXT:    sub a1, a1, a3
; RV64I-NEXT:    sub a0, a0, a2
; RV64I-NEXT:    ret
;
; RV64IM-LABEL: muli128_m63:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    slli a2, a1, 6
; RV64IM-NEXT:    sub a1, a1, a2
; RV64IM-NEXT:    addi a2, zero, -63
; RV64IM-NEXT:    mulhu a2, a0, a2
; RV64IM-NEXT:    sub a2, a2, a0
; RV64IM-NEXT:    add a1, a2, a1
; RV64IM-NEXT:    slli a2, a0, 6
; RV64IM-NEXT:    sub a0, a0, a2
; RV64IM-NEXT:    ret
  %1 = mul i128 %a, -63
  ret i128 %1
}

define i64 @mulhsu_i64(i64 %a, i64 %b) nounwind {
; RV32I-LABEL: mulhsu_i64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -64
; RV32I-NEXT:    sw ra, 60(sp) # 4-byte Folded Spill
; RV32I-NEXT:    srai a4, a3, 31
; RV32I-NEXT:    sw a3, 12(sp)
; RV32I-NEXT:    sw a2, 8(sp)
; RV32I-NEXT:    sw zero, 36(sp)
; RV32I-NEXT:    sw zero, 32(sp)
; RV32I-NEXT:    sw a1, 28(sp)
; RV32I-NEXT:    sw a0, 24(sp)
; RV32I-NEXT:    sw a4, 20(sp)
; RV32I-NEXT:    addi a0, sp, 40
; RV32I-NEXT:    addi a1, sp, 24
; RV32I-NEXT:    addi a2, sp, 8
; RV32I-NEXT:    sw a4, 16(sp)
; RV32I-NEXT:    call __multi3@plt
; RV32I-NEXT:    lw a0, 48(sp)
; RV32I-NEXT:    lw a1, 52(sp)
; RV32I-NEXT:    lw ra, 60(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 64
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: mulhsu_i64:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    addi sp, sp, -64
; RV32IM-NEXT:    sw ra, 60(sp) # 4-byte Folded Spill
; RV32IM-NEXT:    srai a4, a3, 31
; RV32IM-NEXT:    sw a3, 12(sp)
; RV32IM-NEXT:    sw a2, 8(sp)
; RV32IM-NEXT:    sw zero, 36(sp)
; RV32IM-NEXT:    sw zero, 32(sp)
; RV32IM-NEXT:    sw a1, 28(sp)
; RV32IM-NEXT:    sw a0, 24(sp)
; RV32IM-NEXT:    sw a4, 20(sp)
; RV32IM-NEXT:    addi a0, sp, 40
; RV32IM-NEXT:    addi a1, sp, 24
; RV32IM-NEXT:    addi a2, sp, 8
; RV32IM-NEXT:    sw a4, 16(sp)
; RV32IM-NEXT:    call __multi3@plt
; RV32IM-NEXT:    lw a0, 48(sp)
; RV32IM-NEXT:    lw a1, 52(sp)
; RV32IM-NEXT:    lw ra, 60(sp) # 4-byte Folded Reload
; RV32IM-NEXT:    addi sp, sp, 64
; RV32IM-NEXT:    ret
;
; RV64I-LABEL: mulhsu_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    mv a2, a1
; RV64I-NEXT:    srai a3, a1, 63
; RV64I-NEXT:    mv a1, zero
; RV64I-NEXT:    call __multi3@plt
; RV64I-NEXT:    mv a0, a1
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
;
; RV64IM-LABEL: mulhsu_i64:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    srai a2, a1, 63
; RV64IM-NEXT:    mulhu a1, a0, a1
; RV64IM-NEXT:    mul a0, a0, a2
; RV64IM-NEXT:    add a0, a1, a0
; RV64IM-NEXT:    ret
  %1 = zext i64 %a to i128
  %2 = sext i64 %b to i128
  %3 = mul i128 %1, %2
  %4 = lshr i128 %3, 64
  %5 = trunc i128 %4 to i64
  ret i64 %5
}

