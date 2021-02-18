; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -target-abi=ilp32d -mattr=+experimental-v,+experimental-zfh,+f,+d -verify-machineinstrs -riscv-v-vector-bits-min=128 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=RV32
; RUN: llc -mtriple=riscv64 -target-abi=lp64d -mattr=+experimental-v,+experimental-zfh,+f,+d -verify-machineinstrs -riscv-v-vector-bits-min=128 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=RV64

; FIXME: This codegen needs to be improved. These tests previously asserted
; type legalizing the i64 type on RV32.

define void @insertelt_v4i64(<4 x i64>* %x, i64 %y) {
; RV32-LABEL: insertelt_v4i64:
; RV32:       # %bb.0:
; RV32-NEXT:    addi sp, sp, -224
; RV32-NEXT:    .cfi_def_cfa_offset 224
; RV32-NEXT:    sw ra, 220(sp) # 4-byte Folded Spill
; RV32-NEXT:    sw s0, 216(sp) # 4-byte Folded Spill
; RV32-NEXT:    .cfi_offset ra, -4
; RV32-NEXT:    .cfi_offset s0, -8
; RV32-NEXT:    addi s0, sp, 224
; RV32-NEXT:    .cfi_def_cfa s0, 0
; RV32-NEXT:    andi sp, sp, -32
; RV32-NEXT:    addi a3, zero, 8
; RV32-NEXT:    vsetvli a4, a3, e32,m2,ta,mu
; RV32-NEXT:    vle32.v v26, (a0)
; RV32-NEXT:    vse32.v v26, (sp)
; RV32-NEXT:    addi a6, zero, 2
; RV32-NEXT:    addi a5, sp, 16
; RV32-NEXT:    vsetvli a4, a6, e32,m1,ta,mu
; RV32-NEXT:    vle32.v v25, (a5)
; RV32-NEXT:    addi a4, sp, 112
; RV32-NEXT:    vse32.v v25, (a4)
; RV32-NEXT:    addi a4, sp, 8
; RV32-NEXT:    vle32.v v25, (a4)
; RV32-NEXT:    addi a4, sp, 104
; RV32-NEXT:    vse32.v v25, (a4)
; RV32-NEXT:    sw a2, 128(sp)
; RV32-NEXT:    vsetvli a2, a3, e32,m2,ta,mu
; RV32-NEXT:    addi a2, sp, 128
; RV32-NEXT:    vle32.v v26, (a2)
; RV32-NEXT:    addi a2, sp, 64
; RV32-NEXT:    vse32.v v26, (a2)
; RV32-NEXT:    sw a1, 160(sp)
; RV32-NEXT:    addi a1, sp, 160
; RV32-NEXT:    vle32.v v26, (a1)
; RV32-NEXT:    addi a1, sp, 32
; RV32-NEXT:    vse32.v v26, (a1)
; RV32-NEXT:    vsetvli a1, a6, e32,m1,ta,mu
; RV32-NEXT:    vle32.v v25, (sp)
; RV32-NEXT:    addi a1, sp, 96
; RV32-NEXT:    vse32.v v25, (a1)
; RV32-NEXT:    lw a1, 64(sp)
; RV32-NEXT:    sw a1, 124(sp)
; RV32-NEXT:    lw a1, 32(sp)
; RV32-NEXT:    sw a1, 120(sp)
; RV32-NEXT:    vsetvli a1, a3, e32,m2,ta,mu
; RV32-NEXT:    addi a1, sp, 96
; RV32-NEXT:    vle32.v v26, (a1)
; RV32-NEXT:    vse32.v v26, (a0)
; RV32-NEXT:    addi sp, s0, -224
; RV32-NEXT:    lw s0, 216(sp) # 4-byte Folded Reload
; RV32-NEXT:    lw ra, 220(sp) # 4-byte Folded Reload
; RV32-NEXT:    addi sp, sp, 224
; RV32-NEXT:    ret
;
; RV64-LABEL: insertelt_v4i64:
; RV64:       # %bb.0:
; RV64-NEXT:    addi sp, sp, -160
; RV64-NEXT:    .cfi_def_cfa_offset 160
; RV64-NEXT:    sd ra, 152(sp) # 8-byte Folded Spill
; RV64-NEXT:    sd s0, 144(sp) # 8-byte Folded Spill
; RV64-NEXT:    .cfi_offset ra, -8
; RV64-NEXT:    .cfi_offset s0, -16
; RV64-NEXT:    addi s0, sp, 160
; RV64-NEXT:    .cfi_def_cfa s0, 0
; RV64-NEXT:    andi sp, sp, -32
; RV64-NEXT:    addi a2, zero, 4
; RV64-NEXT:    vsetvli a3, a2, e64,m2,ta,mu
; RV64-NEXT:    vle64.v v26, (a0)
; RV64-NEXT:    vse64.v v26, (sp)
; RV64-NEXT:    sd a1, 96(sp)
; RV64-NEXT:    addi a1, sp, 96
; RV64-NEXT:    vle64.v v26, (a1)
; RV64-NEXT:    addi a1, sp, 32
; RV64-NEXT:    vse64.v v26, (a1)
; RV64-NEXT:    addi a1, zero, 2
; RV64-NEXT:    vsetvli a1, a1, e64,m1,ta,mu
; RV64-NEXT:    vle64.v v25, (sp)
; RV64-NEXT:    addi a1, sp, 64
; RV64-NEXT:    vse64.v v25, (a1)
; RV64-NEXT:    ld a1, 16(sp)
; RV64-NEXT:    sd a1, 80(sp)
; RV64-NEXT:    ld a1, 32(sp)
; RV64-NEXT:    sd a1, 88(sp)
; RV64-NEXT:    vsetvli a1, a2, e64,m2,ta,mu
; RV64-NEXT:    addi a1, sp, 64
; RV64-NEXT:    vle64.v v26, (a1)
; RV64-NEXT:    vse64.v v26, (a0)
; RV64-NEXT:    addi sp, s0, -160
; RV64-NEXT:    ld s0, 144(sp) # 8-byte Folded Reload
; RV64-NEXT:    ld ra, 152(sp) # 8-byte Folded Reload
; RV64-NEXT:    addi sp, sp, 160
; RV64-NEXT:    ret
  %a = load <4 x i64>, <4 x i64>* %x
  %b = insertelement <4 x i64> %a, i64 %y, i32 3
  store <4 x i64> %b, <4 x i64>* %x
  ret void
}

; This uses a non-power of 2 type so that it isn't an MVT.
; The align keeps the type legalizer from using a 256 bit load so we must split
; it. This some operations that weren't support for scalable vectors when
; this test was written.
define void @insertelt_v3i64(<3 x i64>* %x, i64 %y) {
; RV32-LABEL: insertelt_v3i64:
; RV32:       # %bb.0:
; RV32-NEXT:    sw a1, 16(a0)
; RV32-NEXT:    sw a2, 20(a0)
; RV32-NEXT:    ret
;
; RV64-LABEL: insertelt_v3i64:
; RV64:       # %bb.0:
; RV64-NEXT:    sd a1, 16(a0)
; RV64-NEXT:    ret
  %a = load <3 x i64>, <3 x i64>* %x, align 8
  %b = insertelement <3 x i64> %a, i64 %y, i32 2
  store <3 x i64> %b, <3 x i64>* %x
  ret void
}
