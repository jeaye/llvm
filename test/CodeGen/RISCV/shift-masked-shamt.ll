; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV32I
; RUN: llc -mtriple=riscv64 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV64I

; This test checks that unnecessary masking of shift amount operands is
; eliminated during instruction selection. The test needs to ensure that the
; masking is not removed if it may affect the shift amount.

define i32 @sll_redundant_mask(i32 %a, i32 %b) nounwind {
; RV32I-LABEL: sll_redundant_mask:
; RV32I:       # %bb.0:
; RV32I-NEXT:    sll a0, a0, a1
; RV32I-NEXT:    ret
;
; RV64I-LABEL: sll_redundant_mask:
; RV64I:       # %bb.0:
; RV64I-NEXT:    sllw a0, a0, a1
; RV64I-NEXT:    ret
  %1 = and i32 %b, 31
  %2 = shl i32 %a, %1
  ret i32 %2
}

define i32 @sll_non_redundant_mask(i32 %a, i32 %b) nounwind {
; RV32I-LABEL: sll_non_redundant_mask:
; RV32I:       # %bb.0:
; RV32I-NEXT:    andi a1, a1, 15
; RV32I-NEXT:    sll a0, a0, a1
; RV32I-NEXT:    ret
;
; RV64I-LABEL: sll_non_redundant_mask:
; RV64I:       # %bb.0:
; RV64I-NEXT:    andi a1, a1, 15
; RV64I-NEXT:    sllw a0, a0, a1
; RV64I-NEXT:    ret
  %1 = and i32 %b, 15
  %2 = shl i32 %a, %1
  ret i32 %2
}

define i32 @srl_redundant_mask(i32 %a, i32 %b) nounwind {
; RV32I-LABEL: srl_redundant_mask:
; RV32I:       # %bb.0:
; RV32I-NEXT:    srl a0, a0, a1
; RV32I-NEXT:    ret
;
; RV64I-LABEL: srl_redundant_mask:
; RV64I:       # %bb.0:
; RV64I-NEXT:    srlw a0, a0, a1
; RV64I-NEXT:    ret
  %1 = and i32 %b, 4095
  %2 = lshr i32 %a, %1
  ret i32 %2
}

define i32 @srl_non_redundant_mask(i32 %a, i32 %b) nounwind {
; RV32I-LABEL: srl_non_redundant_mask:
; RV32I:       # %bb.0:
; RV32I-NEXT:    andi a1, a1, 7
; RV32I-NEXT:    srl a0, a0, a1
; RV32I-NEXT:    ret
;
; RV64I-LABEL: srl_non_redundant_mask:
; RV64I:       # %bb.0:
; RV64I-NEXT:    andi a1, a1, 7
; RV64I-NEXT:    srlw a0, a0, a1
; RV64I-NEXT:    ret
  %1 = and i32 %b, 7
  %2 = lshr i32 %a, %1
  ret i32 %2
}

define i32 @sra_redundant_mask(i32 %a, i32 %b) nounwind {
; RV32I-LABEL: sra_redundant_mask:
; RV32I:       # %bb.0:
; RV32I-NEXT:    sra a0, a0, a1
; RV32I-NEXT:    ret
;
; RV64I-LABEL: sra_redundant_mask:
; RV64I:       # %bb.0:
; RV64I-NEXT:    sraw a0, a0, a1
; RV64I-NEXT:    ret
  %1 = and i32 %b, 65535
  %2 = ashr i32 %a, %1
  ret i32 %2
}

define i32 @sra_non_redundant_mask(i32 %a, i32 %b) nounwind {
; RV32I-LABEL: sra_non_redundant_mask:
; RV32I:       # %bb.0:
; RV32I-NEXT:    andi a1, a1, 32
; RV32I-NEXT:    sra a0, a0, a1
; RV32I-NEXT:    ret
;
; RV64I-LABEL: sra_non_redundant_mask:
; RV64I:       # %bb.0:
; RV64I-NEXT:    sraw a0, a0, zero
; RV64I-NEXT:    ret
  %1 = and i32 %b, 32
  %2 = ashr i32 %a, %1
  ret i32 %2
}

define i32 @sll_redundant_mask_zeros(i32 %a, i32 %b) nounwind {
; RV32I-LABEL: sll_redundant_mask_zeros:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a1, a1, 1
; RV32I-NEXT:    sll a0, a0, a1
; RV32I-NEXT:    ret
;
; RV64I-LABEL: sll_redundant_mask_zeros:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a1, a1, 1
; RV64I-NEXT:    sllw a0, a0, a1
; RV64I-NEXT:    ret
  %1 = shl i32 %b, 1
  %2 = and i32 %1, 30
  %3 = shl i32 %a, %2
  ret i32 %3
}

define i32 @srl_redundant_mask_zeros(i32 %a, i32 %b) nounwind {
; RV32I-LABEL: srl_redundant_mask_zeros:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a1, a1, 2
; RV32I-NEXT:    srl a0, a0, a1
; RV32I-NEXT:    ret
;
; RV64I-LABEL: srl_redundant_mask_zeros:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a1, a1, 2
; RV64I-NEXT:    srlw a0, a0, a1
; RV64I-NEXT:    ret
  %1 = shl i32 %b, 2
  %2 = and i32 %1, 28
  %3 = lshr i32 %a, %2
  ret i32 %3
}

define i32 @sra_redundant_mask_zeros(i32 %a, i32 %b) nounwind {
; RV32I-LABEL: sra_redundant_mask_zeros:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a1, a1, 3
; RV32I-NEXT:    sra a0, a0, a1
; RV32I-NEXT:    ret
;
; RV64I-LABEL: sra_redundant_mask_zeros:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a1, a1, 3
; RV64I-NEXT:    sraw a0, a0, a1
; RV64I-NEXT:    ret
  %1 = shl i32 %b, 3
  %2 = and i32 %1, 24
  %3 = ashr i32 %a, %2
  ret i32 %3
}

define i64 @sll_redundant_mask_zeros_i64(i64 %a, i64 %b) nounwind {
; RV32I-LABEL: sll_redundant_mask_zeros_i64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a2, a2, 2
; RV32I-NEXT:    andi a3, a2, 60
; RV32I-NEXT:    addi a4, a3, -32
; RV32I-NEXT:    bltz a4, .LBB9_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    sll a1, a0, a4
; RV32I-NEXT:    mv a0, zero
; RV32I-NEXT:    ret
; RV32I-NEXT:  .LBB9_2:
; RV32I-NEXT:    sll a1, a1, a2
; RV32I-NEXT:    addi a4, zero, 31
; RV32I-NEXT:    sub a3, a4, a3
; RV32I-NEXT:    srli a4, a0, 1
; RV32I-NEXT:    srl a3, a4, a3
; RV32I-NEXT:    or a1, a1, a3
; RV32I-NEXT:    sll a0, a0, a2
; RV32I-NEXT:    ret
;
; RV64I-LABEL: sll_redundant_mask_zeros_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a1, a1, 2
; RV64I-NEXT:    sll a0, a0, a1
; RV64I-NEXT:    ret
  %1 = shl i64 %b, 2
  %2 = and i64 %1, 60
  %3 = shl i64 %a, %2
  ret i64 %3
}

define i64 @srl_redundant_mask_zeros_i64(i64 %a, i64 %b) nounwind {
; RV32I-LABEL: srl_redundant_mask_zeros_i64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a2, a2, 3
; RV32I-NEXT:    andi a3, a2, 56
; RV32I-NEXT:    addi a4, a3, -32
; RV32I-NEXT:    bltz a4, .LBB10_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    srl a0, a1, a4
; RV32I-NEXT:    mv a1, zero
; RV32I-NEXT:    ret
; RV32I-NEXT:  .LBB10_2:
; RV32I-NEXT:    srl a0, a0, a2
; RV32I-NEXT:    addi a4, zero, 31
; RV32I-NEXT:    sub a3, a4, a3
; RV32I-NEXT:    slli a4, a1, 1
; RV32I-NEXT:    sll a3, a4, a3
; RV32I-NEXT:    or a0, a0, a3
; RV32I-NEXT:    srl a1, a1, a2
; RV32I-NEXT:    ret
;
; RV64I-LABEL: srl_redundant_mask_zeros_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a1, a1, 3
; RV64I-NEXT:    srl a0, a0, a1
; RV64I-NEXT:    ret
  %1 = shl i64 %b, 3
  %2 = and i64 %1, 56
  %3 = lshr i64 %a, %2
  ret i64 %3
}

define i64 @sra_redundant_mask_zeros_i64(i64 %a, i64 %b) nounwind {
; RV32I-LABEL: sra_redundant_mask_zeros_i64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a2, a2, 4
; RV32I-NEXT:    andi a3, a2, 48
; RV32I-NEXT:    addi a4, a3, -32
; RV32I-NEXT:    bltz a4, .LBB11_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    sra a0, a1, a4
; RV32I-NEXT:    srai a1, a1, 31
; RV32I-NEXT:    ret
; RV32I-NEXT:  .LBB11_2:
; RV32I-NEXT:    srl a0, a0, a2
; RV32I-NEXT:    addi a4, zero, 31
; RV32I-NEXT:    sub a3, a4, a3
; RV32I-NEXT:    slli a4, a1, 1
; RV32I-NEXT:    sll a3, a4, a3
; RV32I-NEXT:    or a0, a0, a3
; RV32I-NEXT:    sra a1, a1, a2
; RV32I-NEXT:    ret
;
; RV64I-LABEL: sra_redundant_mask_zeros_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a1, a1, 4
; RV64I-NEXT:    sra a0, a0, a1
; RV64I-NEXT:    ret
  %1 = shl i64 %b, 4
  %2 = and i64 %1, 48
  %3 = ashr i64 %a, %2
  ret i64 %3
}
