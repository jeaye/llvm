; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV32I
; RUN: llc -mtriple=riscv64 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV64I

; Materializing constants

; TODO: It would be preferable if anyext constant returns were sign rather
; than zero extended. See PR39092. For now, mark returns as explicitly signext
; (this matches what Clang would generate for equivalent C/C++ anyway).

define signext i32 @zero() nounwind {
; RV32I-LABEL: zero:
; RV32I:       # %bb.0:
; RV32I-NEXT:    mv a0, zero
; RV32I-NEXT:    ret
;
; RV64I-LABEL: zero:
; RV64I:       # %bb.0:
; RV64I-NEXT:    mv a0, zero
; RV64I-NEXT:    ret
  ret i32 0
}

define signext i32 @pos_small() nounwind {
; RV32I-LABEL: pos_small:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi a0, zero, 2047
; RV32I-NEXT:    ret
;
; RV64I-LABEL: pos_small:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a0, zero, 2047
; RV64I-NEXT:    ret
  ret i32 2047
}

define signext i32 @neg_small() nounwind {
; RV32I-LABEL: neg_small:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi a0, zero, -2048
; RV32I-NEXT:    ret
;
; RV64I-LABEL: neg_small:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a0, zero, -2048
; RV64I-NEXT:    ret
  ret i32 -2048
}

define signext i32 @pos_i32() nounwind {
; RV32I-LABEL: pos_i32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a0, 423811
; RV32I-NEXT:    addi a0, a0, -1297
; RV32I-NEXT:    ret
;
; RV64I-LABEL: pos_i32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a0, 423811
; RV64I-NEXT:    addiw a0, a0, -1297
; RV64I-NEXT:    ret
  ret i32 1735928559
}

define signext i32 @neg_i32() nounwind {
; RV32I-LABEL: neg_i32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a0, 912092
; RV32I-NEXT:    addi a0, a0, -273
; RV32I-NEXT:    ret
;
; RV64I-LABEL: neg_i32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a0, 912092
; RV64I-NEXT:    addiw a0, a0, -273
; RV64I-NEXT:    ret
  ret i32 -559038737
}

define signext i32 @pos_i32_hi20_only() nounwind {
; RV32I-LABEL: pos_i32_hi20_only:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a0, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: pos_i32_hi20_only:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a0, 16
; RV64I-NEXT:    ret
  ret i32 65536 ; 0x10000
}

define signext i32 @neg_i32_hi20_only() nounwind {
; RV32I-LABEL: neg_i32_hi20_only:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a0, 1048560
; RV32I-NEXT:    ret
;
; RV64I-LABEL: neg_i32_hi20_only:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a0, 1048560
; RV64I-NEXT:    ret
  ret i32 -65536 ; -0x10000
}

; This can be materialized with ADDI+SLLI, improving compressibility.

define signext i32 @imm_left_shifted_addi() nounwind {
; RV32I-LABEL: imm_left_shifted_addi:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a0, 32
; RV32I-NEXT:    addi a0, a0, -64
; RV32I-NEXT:    ret
;
; RV64I-LABEL: imm_left_shifted_addi:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a0, 32
; RV64I-NEXT:    addiw a0, a0, -64
; RV64I-NEXT:    ret
  ret i32 131008 ; 0x1FFC0
}

; This can be materialized with ADDI+SRLI, improving compressibility.

define signext i32 @imm_right_shifted_addi() nounwind {
; RV32I-LABEL: imm_right_shifted_addi:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a0, 524288
; RV32I-NEXT:    addi a0, a0, -1
; RV32I-NEXT:    ret
;
; RV64I-LABEL: imm_right_shifted_addi:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a0, 524288
; RV64I-NEXT:    addiw a0, a0, -1
; RV64I-NEXT:    ret
  ret i32 2147483647 ; 0x7FFFFFFF
}

; This can be materialized with LUI+SRLI, improving compressibility.

define signext i32 @imm_right_shifted_lui() nounwind {
; RV32I-LABEL: imm_right_shifted_lui:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a0, 56
; RV32I-NEXT:    addi a0, a0, 580
; RV32I-NEXT:    ret
;
; RV64I-LABEL: imm_right_shifted_lui:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a0, 56
; RV64I-NEXT:    addiw a0, a0, 580
; RV64I-NEXT:    ret
  ret i32 229956 ; 0x38244
}

define i64 @imm64_1() nounwind {
; RV32I-LABEL: imm64_1:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a0, 524288
; RV32I-NEXT:    mv a1, zero
; RV32I-NEXT:    ret
;
; RV64I-LABEL: imm64_1:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a0, zero, 1
; RV64I-NEXT:    slli a0, a0, 31
; RV64I-NEXT:    ret
  ret i64 2147483648 ; 0x8000_0000
}

; TODO: This and similar constants with all 0s in the upper bits and all 1s in
; the lower bits could be lowered to addi a0, zero, -1 followed by a logical
; right shift.
define i64 @imm64_2() nounwind {
; RV32I-LABEL: imm64_2:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi a0, zero, -1
; RV32I-NEXT:    mv a1, zero
; RV32I-NEXT:    ret
;
; RV64I-LABEL: imm64_2:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a0, zero, -1
; RV64I-NEXT:    srli a0, a0, 32
; RV64I-NEXT:    ret
  ret i64 4294967295 ; 0xFFFF_FFFF
}

define i64 @imm64_3() nounwind {
; RV32I-LABEL: imm64_3:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi a1, zero, 1
; RV32I-NEXT:    mv a0, zero
; RV32I-NEXT:    ret
;
; RV64I-LABEL: imm64_3:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a0, zero, 1
; RV64I-NEXT:    slli a0, a0, 32
; RV64I-NEXT:    ret
  ret i64 4294967296 ; 0x1_0000_0000
}

define i64 @imm64_4() nounwind {
; RV32I-LABEL: imm64_4:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a1, 524288
; RV32I-NEXT:    mv a0, zero
; RV32I-NEXT:    ret
;
; RV64I-LABEL: imm64_4:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a0, zero, -1
; RV64I-NEXT:    slli a0, a0, 63
; RV64I-NEXT:    ret
  ret i64 9223372036854775808 ; 0x8000_0000_0000_0000
}

define i64 @imm64_5() nounwind {
; RV32I-LABEL: imm64_5:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a1, 524288
; RV32I-NEXT:    mv a0, zero
; RV32I-NEXT:    ret
;
; RV64I-LABEL: imm64_5:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a0, zero, -1
; RV64I-NEXT:    slli a0, a0, 63
; RV64I-NEXT:    ret
  ret i64 -9223372036854775808 ; 0x8000_0000_0000_0000
}

define i64 @imm64_6() nounwind {
; RV32I-LABEL: imm64_6:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a0, 74565
; RV32I-NEXT:    addi a1, a0, 1656
; RV32I-NEXT:    mv a0, zero
; RV32I-NEXT:    ret
;
; RV64I-LABEL: imm64_6:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a0, 9321
; RV64I-NEXT:    addiw a0, a0, -1329
; RV64I-NEXT:    slli a0, a0, 35
; RV64I-NEXT:    ret
  ret i64 1311768464867721216 ; 0x1234_5678_0000_0000
}

define i64 @imm64_7() nounwind {
; RV32I-LABEL: imm64_7:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a0, 45056
; RV32I-NEXT:    addi a0, a0, 15
; RV32I-NEXT:    lui a1, 458752
; RV32I-NEXT:    ret
;
; RV64I-LABEL: imm64_7:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a0, zero, 7
; RV64I-NEXT:    slli a0, a0, 36
; RV64I-NEXT:    addi a0, a0, 11
; RV64I-NEXT:    slli a0, a0, 24
; RV64I-NEXT:    addi a0, a0, 15
; RV64I-NEXT:    ret
  ret i64 8070450532432478223 ; 0x7000_0000_0B00_000F
}

; TODO: it can be preferable to put constants that are expensive to materialise
; into the constant pool, especially for -Os.
define i64 @imm64_8() nounwind {
; RV32I-LABEL: imm64_8:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a0, 633806
; RV32I-NEXT:    addi a0, a0, -272
; RV32I-NEXT:    lui a1, 74565
; RV32I-NEXT:    addi a1, a1, 1656
; RV32I-NEXT:    ret
;
; RV64I-LABEL: imm64_8:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a0, 583
; RV64I-NEXT:    addiw a0, a0, -1875
; RV64I-NEXT:    slli a0, a0, 14
; RV64I-NEXT:    addi a0, a0, -947
; RV64I-NEXT:    slli a0, a0, 12
; RV64I-NEXT:    addi a0, a0, 1511
; RV64I-NEXT:    slli a0, a0, 13
; RV64I-NEXT:    addi a0, a0, -272
; RV64I-NEXT:    ret
  ret i64 1311768467463790320 ; 0x1234_5678_9ABC_DEF0
}

define i64 @imm64_9() nounwind {
; RV32I-LABEL: imm64_9:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi a0, zero, -1
; RV32I-NEXT:    addi a1, zero, -1
; RV32I-NEXT:    ret
;
; RV64I-LABEL: imm64_9:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a0, zero, -1
; RV64I-NEXT:    ret
  ret i64 -1
}

; Various cases where extraneous ADDIs can be inserted where a (left shifted)
; LUI suffices.

define i64 @imm_left_shifted_lui_1() nounwind {
; RV32I-LABEL: imm_left_shifted_lui_1:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a0, 524290
; RV32I-NEXT:    mv a1, zero
; RV32I-NEXT:    ret
;
; RV64I-LABEL: imm_left_shifted_lui_1:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a0, 262145
; RV64I-NEXT:    slli a0, a0, 1
; RV64I-NEXT:    ret
  ret i64 2147491840 ; 0x8000_2000
}

define i64 @imm_left_shifted_lui_2() nounwind {
; RV32I-LABEL: imm_left_shifted_lui_2:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a0, 4
; RV32I-NEXT:    addi a1, zero, 1
; RV32I-NEXT:    ret
;
; RV64I-LABEL: imm_left_shifted_lui_2:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a0, 262145
; RV64I-NEXT:    slli a0, a0, 2
; RV64I-NEXT:    ret
  ret i64 4294983680 ; 0x1_0000_4000
}

define i64 @imm_left_shifted_lui_3() nounwind {
; RV32I-LABEL: imm_left_shifted_lui_3:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a0, 1
; RV32I-NEXT:    addi a1, a0, 1
; RV32I-NEXT:    mv a0, zero
; RV32I-NEXT:    ret
;
; RV64I-LABEL: imm_left_shifted_lui_3:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a0, 4097
; RV64I-NEXT:    slli a0, a0, 20
; RV64I-NEXT:    ret
  ret i64 17596481011712 ; 0x1001_0000_0000
}

; Various cases where extraneous ADDIs can be inserted where a (right shifted)
; LUI suffices, or where multiple ADDIs can be used instead of a single LUI.

define i64 @imm_right_shifted_lui_1() nounwind {
; RV32I-LABEL: imm_right_shifted_lui_1:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a0, 1048575
; RV32I-NEXT:    addi a0, a0, 1
; RV32I-NEXT:    lui a1, 16
; RV32I-NEXT:    addi a1, a1, -1
; RV32I-NEXT:    ret
;
; RV64I-LABEL: imm_right_shifted_lui_1:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a0, 983056
; RV64I-NEXT:    srli a0, a0, 16
; RV64I-NEXT:    ret
  ret i64 281474976706561 ; 0xFFFF_FFFF_F001
}

define i64 @imm_right_shifted_lui_2() nounwind {
; RV32I-LABEL: imm_right_shifted_lui_2:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a0, 1048575
; RV32I-NEXT:    addi a0, a0, 1
; RV32I-NEXT:    addi a1, zero, 255
; RV32I-NEXT:    ret
;
; RV64I-LABEL: imm_right_shifted_lui_2:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a0, 1044481
; RV64I-NEXT:    slli a0, a0, 12
; RV64I-NEXT:    srli a0, a0, 24
; RV64I-NEXT:    ret
  ret i64 1099511623681 ; 0xFF_FFFF_F001
}

; We can materialize the upper bits with a single (shifted) LUI, but that option
; can be missed due to the lower bits, which aren't just 1s or just 0s.

define i64 @imm_decoupled_lui_addi() nounwind {
; RV32I-LABEL: imm_decoupled_lui_addi:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi a0, zero, -3
; RV32I-NEXT:    lui a1, 1
; RV32I-NEXT:    ret
;
; RV64I-LABEL: imm_decoupled_lui_addi:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a0, 4097
; RV64I-NEXT:    slli a0, a0, 20
; RV64I-NEXT:    addi a0, a0, -3
; RV64I-NEXT:    ret
  ret i64 17596481011709 ; 0x1000_FFFF_FFFD
}

; This constant can be materialized for RV64 with LUI+SRLI+XORI.

define i64 @imm_end_xori_1() nounwind {
; RV32I-LABEL: imm_end_xori_1:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a0, 8192
; RV32I-NEXT:    addi a0, a0, -1
; RV32I-NEXT:    lui a1, 917504
; RV32I-NEXT:    ret
;
; RV64I-LABEL: imm_end_xori_1:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a0, zero, -1
; RV64I-NEXT:    slli a0, a0, 36
; RV64I-NEXT:    addi a0, a0, 1
; RV64I-NEXT:    slli a0, a0, 25
; RV64I-NEXT:    addi a0, a0, -1
; RV64I-NEXT:    ret
  ret i64 -2305843009180139521 ; 0xE000_0000_01FF_FFFF
}

; This constant can be materialized for RV64 with ADDI+SLLI+ADDI+ADDI.

define i64 @imm_end_2addi_1() nounwind {
; RV32I-LABEL: imm_end_2addi_1:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a0, 1048575
; RV32I-NEXT:    addi a0, a0, 2047
; RV32I-NEXT:    lui a1, 1048512
; RV32I-NEXT:    addi a1, a1, 127
; RV32I-NEXT:    ret
;
; RV64I-LABEL: imm_end_2addi_1:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a0, zero, -2047
; RV64I-NEXT:    slli a0, a0, 27
; RV64I-NEXT:    addi a0, a0, -1
; RV64I-NEXT:    slli a0, a0, 12
; RV64I-NEXT:    addi a0, a0, 2047
; RV64I-NEXT:    ret
  ret i64 -1125350151030785 ; 0xFFFC_007F_FFFF_F7FF
}

; This constant can be more efficiently materialized for RV64 if we use two
; registers instead of one.

define i64 @imm_2reg_1() nounwind {
; RV32I-LABEL: imm_2reg_1:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a0, 74565
; RV32I-NEXT:    addi a0, a0, 1656
; RV32I-NEXT:    lui a1, 983040
; RV32I-NEXT:    ret
;
; RV64I-LABEL: imm_2reg_1:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a0, zero, -1
; RV64I-NEXT:    slli a0, a0, 35
; RV64I-NEXT:    addi a0, a0, 9
; RV64I-NEXT:    slli a0, a0, 13
; RV64I-NEXT:    addi a0, a0, 837
; RV64I-NEXT:    slli a0, a0, 12
; RV64I-NEXT:    addi a0, a0, 1656
; RV64I-NEXT:    ret
  ret i64 -1152921504301427080 ; 0xF000_0000_1234_5678
}
