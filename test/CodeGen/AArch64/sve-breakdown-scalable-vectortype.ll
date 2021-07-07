; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64--linux-gnu -mattr=+sve < %s | FileCheck %s

; Test that scalable vectors that are a multiple of the legal vector size
; can be properly broken down into part vectors.

declare aarch64_sve_vector_pcs void @bar()

;
; Vectors twice the size
;

define <vscale x 32 x i8> @wide_32i8(i1 %b, <vscale x 16 x i8> %legal, <vscale x 32 x i8> %illegal) nounwind {
; CHECK-LABEL: wide_32i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    stp x29, x30, [sp, #-16]! // 16-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-2
; CHECK-NEXT:    str z9, [sp] // 16-byte Folded Spill
; CHECK-NEXT:    str z8, [sp, #1, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    mov z8.d, z2.d
; CHECK-NEXT:    mov z9.d, z1.d
; CHECK-NEXT:    tbz w0, #0, .LBB0_2
; CHECK-NEXT:  // %bb.1: // %L1
; CHECK-NEXT:    bl bar
; CHECK-NEXT:  .LBB0_2: // %common.ret
; CHECK-NEXT:    mov z0.d, z9.d
; CHECK-NEXT:    mov z1.d, z8.d
; CHECK-NEXT:    ldr z9, [sp] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z8, [sp, #1, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    addvl sp, sp, #2
; CHECK-NEXT:    ldp x29, x30, [sp], #16 // 16-byte Folded Reload
; CHECK-NEXT:    ret
  br i1 %b, label %L1, label %L2
L1:
  call aarch64_sve_vector_pcs void @bar()
  ret <vscale x 32 x i8> undef
L2:
  ret <vscale x 32 x i8> %illegal
}

define <vscale x 16 x i16> @wide_16i16(i1 %b, <vscale x 16 x i8> %legal, <vscale x 16 x i16> %illegal) nounwind {
; CHECK-LABEL: wide_16i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    stp x29, x30, [sp, #-16]! // 16-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-2
; CHECK-NEXT:    str z9, [sp] // 16-byte Folded Spill
; CHECK-NEXT:    str z8, [sp, #1, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    mov z8.d, z2.d
; CHECK-NEXT:    mov z9.d, z1.d
; CHECK-NEXT:    tbz w0, #0, .LBB1_2
; CHECK-NEXT:  // %bb.1: // %L1
; CHECK-NEXT:    bl bar
; CHECK-NEXT:  .LBB1_2: // %common.ret
; CHECK-NEXT:    mov z0.d, z9.d
; CHECK-NEXT:    mov z1.d, z8.d
; CHECK-NEXT:    ldr z9, [sp] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z8, [sp, #1, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    addvl sp, sp, #2
; CHECK-NEXT:    ldp x29, x30, [sp], #16 // 16-byte Folded Reload
; CHECK-NEXT:    ret
  br i1 %b, label %L1, label %L2
L1:
  call aarch64_sve_vector_pcs void @bar()
  ret <vscale x 16 x i16> undef
L2:
  ret <vscale x 16 x i16> %illegal
}

define <vscale x 8 x i32> @wide_8i32(i1 %b, <vscale x 16 x i8> %legal, <vscale x 8 x i32> %illegal) nounwind {
; CHECK-LABEL: wide_8i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    stp x29, x30, [sp, #-16]! // 16-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-2
; CHECK-NEXT:    str z9, [sp] // 16-byte Folded Spill
; CHECK-NEXT:    str z8, [sp, #1, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    mov z8.d, z2.d
; CHECK-NEXT:    mov z9.d, z1.d
; CHECK-NEXT:    tbz w0, #0, .LBB2_2
; CHECK-NEXT:  // %bb.1: // %L1
; CHECK-NEXT:    bl bar
; CHECK-NEXT:  .LBB2_2: // %common.ret
; CHECK-NEXT:    mov z0.d, z9.d
; CHECK-NEXT:    mov z1.d, z8.d
; CHECK-NEXT:    ldr z9, [sp] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z8, [sp, #1, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    addvl sp, sp, #2
; CHECK-NEXT:    ldp x29, x30, [sp], #16 // 16-byte Folded Reload
; CHECK-NEXT:    ret
  br i1 %b, label %L1, label %L2
L1:
  call aarch64_sve_vector_pcs void @bar()
  ret <vscale x 8 x i32> undef
L2:
  ret <vscale x 8 x i32> %illegal
}

define <vscale x 4 x i64> @wide_4i64(i1 %b, <vscale x 16 x i8> %legal, <vscale x 4 x i64> %illegal) nounwind {
; CHECK-LABEL: wide_4i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    stp x29, x30, [sp, #-16]! // 16-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-2
; CHECK-NEXT:    str z9, [sp] // 16-byte Folded Spill
; CHECK-NEXT:    str z8, [sp, #1, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    mov z8.d, z2.d
; CHECK-NEXT:    mov z9.d, z1.d
; CHECK-NEXT:    tbz w0, #0, .LBB3_2
; CHECK-NEXT:  // %bb.1: // %L1
; CHECK-NEXT:    bl bar
; CHECK-NEXT:  .LBB3_2: // %common.ret
; CHECK-NEXT:    mov z0.d, z9.d
; CHECK-NEXT:    mov z1.d, z8.d
; CHECK-NEXT:    ldr z9, [sp] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z8, [sp, #1, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    addvl sp, sp, #2
; CHECK-NEXT:    ldp x29, x30, [sp], #16 // 16-byte Folded Reload
; CHECK-NEXT:    ret
  br i1 %b, label %L1, label %L2
L1:
  call aarch64_sve_vector_pcs void @bar()
  ret <vscale x 4 x i64> undef
L2:
  ret <vscale x 4 x i64> %illegal
}

define <vscale x 16 x half> @wide_16f16(i1 %b, <vscale x 16 x i8> %legal, <vscale x 16 x half> %illegal) nounwind {
; CHECK-LABEL: wide_16f16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    stp x29, x30, [sp, #-16]! // 16-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-2
; CHECK-NEXT:    str z9, [sp] // 16-byte Folded Spill
; CHECK-NEXT:    str z8, [sp, #1, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    mov z8.d, z2.d
; CHECK-NEXT:    mov z9.d, z1.d
; CHECK-NEXT:    tbz w0, #0, .LBB4_2
; CHECK-NEXT:  // %bb.1: // %L1
; CHECK-NEXT:    bl bar
; CHECK-NEXT:  .LBB4_2: // %common.ret
; CHECK-NEXT:    mov z0.d, z9.d
; CHECK-NEXT:    mov z1.d, z8.d
; CHECK-NEXT:    ldr z9, [sp] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z8, [sp, #1, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    addvl sp, sp, #2
; CHECK-NEXT:    ldp x29, x30, [sp], #16 // 16-byte Folded Reload
; CHECK-NEXT:    ret
  br i1 %b, label %L1, label %L2
L1:
  call aarch64_sve_vector_pcs void @bar()
  ret <vscale x 16 x half> undef
L2:
  ret <vscale x 16 x half> %illegal
}

define <vscale x 8 x float> @wide_8f32(i1 %b, <vscale x 16 x i8> %legal, <vscale x 8 x float> %illegal) nounwind {
; CHECK-LABEL: wide_8f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    stp x29, x30, [sp, #-16]! // 16-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-2
; CHECK-NEXT:    str z9, [sp] // 16-byte Folded Spill
; CHECK-NEXT:    str z8, [sp, #1, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    mov z8.d, z2.d
; CHECK-NEXT:    mov z9.d, z1.d
; CHECK-NEXT:    tbz w0, #0, .LBB5_2
; CHECK-NEXT:  // %bb.1: // %L1
; CHECK-NEXT:    bl bar
; CHECK-NEXT:  .LBB5_2: // %common.ret
; CHECK-NEXT:    mov z0.d, z9.d
; CHECK-NEXT:    mov z1.d, z8.d
; CHECK-NEXT:    ldr z9, [sp] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z8, [sp, #1, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    addvl sp, sp, #2
; CHECK-NEXT:    ldp x29, x30, [sp], #16 // 16-byte Folded Reload
; CHECK-NEXT:    ret
  br i1 %b, label %L1, label %L2
L1:
  call aarch64_sve_vector_pcs void @bar()
  ret <vscale x 8 x float> undef
L2:
  ret <vscale x 8 x float> %illegal
}

define <vscale x 4 x double> @wide_4f64(i1 %b, <vscale x 16 x i8> %legal, <vscale x 4 x double> %illegal) nounwind {
; CHECK-LABEL: wide_4f64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    stp x29, x30, [sp, #-16]! // 16-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-2
; CHECK-NEXT:    str z9, [sp] // 16-byte Folded Spill
; CHECK-NEXT:    str z8, [sp, #1, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    mov z8.d, z2.d
; CHECK-NEXT:    mov z9.d, z1.d
; CHECK-NEXT:    tbz w0, #0, .LBB6_2
; CHECK-NEXT:  // %bb.1: // %L1
; CHECK-NEXT:    bl bar
; CHECK-NEXT:  .LBB6_2: // %common.ret
; CHECK-NEXT:    mov z0.d, z9.d
; CHECK-NEXT:    mov z1.d, z8.d
; CHECK-NEXT:    ldr z9, [sp] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z8, [sp, #1, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    addvl sp, sp, #2
; CHECK-NEXT:    ldp x29, x30, [sp], #16 // 16-byte Folded Reload
; CHECK-NEXT:    ret
  br i1 %b, label %L1, label %L2
L1:
  call aarch64_sve_vector_pcs void @bar()
  ret <vscale x 4 x double> undef
L2:
  ret <vscale x 4 x double> %illegal
}

;
; Vectors three times the size
;

define <vscale x 48 x i8> @wide_48i8(i1 %b, <vscale x 16 x i8> %legal, <vscale x 48 x i8> %illegal) nounwind {
; CHECK-LABEL: wide_48i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    stp x29, x30, [sp, #-16]! // 16-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-3
; CHECK-NEXT:    str z10, [sp] // 16-byte Folded Spill
; CHECK-NEXT:    str z9, [sp, #1, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    str z8, [sp, #2, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    mov z8.d, z3.d
; CHECK-NEXT:    mov z9.d, z2.d
; CHECK-NEXT:    mov z10.d, z1.d
; CHECK-NEXT:    tbz w0, #0, .LBB7_2
; CHECK-NEXT:  // %bb.1: // %L1
; CHECK-NEXT:    bl bar
; CHECK-NEXT:  .LBB7_2: // %common.ret
; CHECK-NEXT:    mov z0.d, z10.d
; CHECK-NEXT:    mov z1.d, z9.d
; CHECK-NEXT:    mov z2.d, z8.d
; CHECK-NEXT:    ldr z10, [sp] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z9, [sp, #1, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z8, [sp, #2, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    addvl sp, sp, #3
; CHECK-NEXT:    ldp x29, x30, [sp], #16 // 16-byte Folded Reload
; CHECK-NEXT:    ret
  br i1 %b, label %L1, label %L2
L1:
  call aarch64_sve_vector_pcs void @bar()
  ret <vscale x 48 x i8> undef
L2:
  ret <vscale x 48 x i8> %illegal
}

define <vscale x 24 x i16> @wide_24i16(i1 %b, <vscale x 16 x i8> %legal, <vscale x 24 x i16> %illegal) nounwind {
; CHECK-LABEL: wide_24i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    stp x29, x30, [sp, #-16]! // 16-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-3
; CHECK-NEXT:    str z10, [sp] // 16-byte Folded Spill
; CHECK-NEXT:    str z9, [sp, #1, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    str z8, [sp, #2, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    mov z8.d, z3.d
; CHECK-NEXT:    mov z9.d, z2.d
; CHECK-NEXT:    mov z10.d, z1.d
; CHECK-NEXT:    tbz w0, #0, .LBB8_2
; CHECK-NEXT:  // %bb.1: // %L1
; CHECK-NEXT:    bl bar
; CHECK-NEXT:  .LBB8_2: // %common.ret
; CHECK-NEXT:    mov z0.d, z10.d
; CHECK-NEXT:    mov z1.d, z9.d
; CHECK-NEXT:    mov z2.d, z8.d
; CHECK-NEXT:    ldr z10, [sp] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z9, [sp, #1, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z8, [sp, #2, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    addvl sp, sp, #3
; CHECK-NEXT:    ldp x29, x30, [sp], #16 // 16-byte Folded Reload
; CHECK-NEXT:    ret
  br i1 %b, label %L1, label %L2
L1:
  call aarch64_sve_vector_pcs void @bar()
  ret <vscale x 24 x i16> undef
L2:
  ret <vscale x 24 x i16> %illegal
}

define <vscale x 12 x i32> @wide_12i32(i1 %b, <vscale x 16 x i8> %legal, <vscale x 12 x i32> %illegal) nounwind {
; CHECK-LABEL: wide_12i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    stp x29, x30, [sp, #-16]! // 16-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-3
; CHECK-NEXT:    str z10, [sp] // 16-byte Folded Spill
; CHECK-NEXT:    str z9, [sp, #1, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    str z8, [sp, #2, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    mov z8.d, z3.d
; CHECK-NEXT:    mov z9.d, z2.d
; CHECK-NEXT:    mov z10.d, z1.d
; CHECK-NEXT:    tbz w0, #0, .LBB9_2
; CHECK-NEXT:  // %bb.1: // %L1
; CHECK-NEXT:    bl bar
; CHECK-NEXT:  .LBB9_2: // %common.ret
; CHECK-NEXT:    mov z0.d, z10.d
; CHECK-NEXT:    mov z1.d, z9.d
; CHECK-NEXT:    mov z2.d, z8.d
; CHECK-NEXT:    ldr z10, [sp] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z9, [sp, #1, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z8, [sp, #2, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    addvl sp, sp, #3
; CHECK-NEXT:    ldp x29, x30, [sp], #16 // 16-byte Folded Reload
; CHECK-NEXT:    ret
  br i1 %b, label %L1, label %L2
L1:
  call aarch64_sve_vector_pcs void @bar()
  ret <vscale x 12 x i32> undef
L2:
  ret <vscale x 12 x i32> %illegal
}

define <vscale x 6 x i64> @wide_6i64(i1 %b, <vscale x 16 x i8> %legal, <vscale x 6 x i64> %illegal) nounwind {
; CHECK-LABEL: wide_6i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    stp x29, x30, [sp, #-16]! // 16-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-3
; CHECK-NEXT:    str z10, [sp] // 16-byte Folded Spill
; CHECK-NEXT:    str z9, [sp, #1, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    str z8, [sp, #2, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    mov z8.d, z3.d
; CHECK-NEXT:    mov z9.d, z2.d
; CHECK-NEXT:    mov z10.d, z1.d
; CHECK-NEXT:    tbz w0, #0, .LBB10_2
; CHECK-NEXT:  // %bb.1: // %L1
; CHECK-NEXT:    bl bar
; CHECK-NEXT:  .LBB10_2: // %common.ret
; CHECK-NEXT:    mov z0.d, z10.d
; CHECK-NEXT:    mov z1.d, z9.d
; CHECK-NEXT:    mov z2.d, z8.d
; CHECK-NEXT:    ldr z10, [sp] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z9, [sp, #1, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z8, [sp, #2, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    addvl sp, sp, #3
; CHECK-NEXT:    ldp x29, x30, [sp], #16 // 16-byte Folded Reload
; CHECK-NEXT:    ret
  br i1 %b, label %L1, label %L2
L1:
  call aarch64_sve_vector_pcs void @bar()
  ret <vscale x 6 x i64> undef
L2:
  ret <vscale x 6 x i64> %illegal
}

define <vscale x 24 x half> @wide_24f16(i1 %b, <vscale x 16 x i8> %legal, <vscale x 24 x half> %illegal) nounwind {
; CHECK-LABEL: wide_24f16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    stp x29, x30, [sp, #-16]! // 16-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-3
; CHECK-NEXT:    str z10, [sp] // 16-byte Folded Spill
; CHECK-NEXT:    str z9, [sp, #1, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    str z8, [sp, #2, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    mov z8.d, z3.d
; CHECK-NEXT:    mov z9.d, z2.d
; CHECK-NEXT:    mov z10.d, z1.d
; CHECK-NEXT:    tbz w0, #0, .LBB11_2
; CHECK-NEXT:  // %bb.1: // %L1
; CHECK-NEXT:    bl bar
; CHECK-NEXT:  .LBB11_2: // %common.ret
; CHECK-NEXT:    mov z0.d, z10.d
; CHECK-NEXT:    mov z1.d, z9.d
; CHECK-NEXT:    mov z2.d, z8.d
; CHECK-NEXT:    ldr z10, [sp] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z9, [sp, #1, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z8, [sp, #2, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    addvl sp, sp, #3
; CHECK-NEXT:    ldp x29, x30, [sp], #16 // 16-byte Folded Reload
; CHECK-NEXT:    ret
  br i1 %b, label %L1, label %L2
L1:
  call aarch64_sve_vector_pcs void @bar()
  ret <vscale x 24 x half> undef
L2:
  ret <vscale x 24 x half> %illegal
}

define <vscale x 12 x float> @wide_12f32(i1 %b, <vscale x 16 x i8> %legal, <vscale x 12 x float> %illegal) nounwind {
; CHECK-LABEL: wide_12f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    stp x29, x30, [sp, #-16]! // 16-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-3
; CHECK-NEXT:    str z10, [sp] // 16-byte Folded Spill
; CHECK-NEXT:    str z9, [sp, #1, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    str z8, [sp, #2, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    mov z8.d, z3.d
; CHECK-NEXT:    mov z9.d, z2.d
; CHECK-NEXT:    mov z10.d, z1.d
; CHECK-NEXT:    tbz w0, #0, .LBB12_2
; CHECK-NEXT:  // %bb.1: // %L1
; CHECK-NEXT:    bl bar
; CHECK-NEXT:  .LBB12_2: // %common.ret
; CHECK-NEXT:    mov z0.d, z10.d
; CHECK-NEXT:    mov z1.d, z9.d
; CHECK-NEXT:    mov z2.d, z8.d
; CHECK-NEXT:    ldr z10, [sp] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z9, [sp, #1, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z8, [sp, #2, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    addvl sp, sp, #3
; CHECK-NEXT:    ldp x29, x30, [sp], #16 // 16-byte Folded Reload
; CHECK-NEXT:    ret
  br i1 %b, label %L1, label %L2
L1:
  call aarch64_sve_vector_pcs void @bar()
  ret <vscale x 12 x float> undef
L2:
  ret <vscale x 12 x float> %illegal
}

define <vscale x 6 x double> @wide_6f64(i1 %b, <vscale x 16 x i8> %legal, <vscale x 6 x double> %illegal) nounwind {
; CHECK-LABEL: wide_6f64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    stp x29, x30, [sp, #-16]! // 16-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-3
; CHECK-NEXT:    str z10, [sp] // 16-byte Folded Spill
; CHECK-NEXT:    str z9, [sp, #1, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    str z8, [sp, #2, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    mov z8.d, z3.d
; CHECK-NEXT:    mov z9.d, z2.d
; CHECK-NEXT:    mov z10.d, z1.d
; CHECK-NEXT:    tbz w0, #0, .LBB13_2
; CHECK-NEXT:  // %bb.1: // %L1
; CHECK-NEXT:    bl bar
; CHECK-NEXT:  .LBB13_2: // %common.ret
; CHECK-NEXT:    mov z0.d, z10.d
; CHECK-NEXT:    mov z1.d, z9.d
; CHECK-NEXT:    mov z2.d, z8.d
; CHECK-NEXT:    ldr z10, [sp] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z9, [sp, #1, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z8, [sp, #2, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    addvl sp, sp, #3
; CHECK-NEXT:    ldp x29, x30, [sp], #16 // 16-byte Folded Reload
; CHECK-NEXT:    ret
  br i1 %b, label %L1, label %L2
L1:
  call aarch64_sve_vector_pcs void @bar()
  ret <vscale x 6 x double> undef
L2:
  ret <vscale x 6 x double> %illegal
}

;
; Vectors four times the size
;

define <vscale x 64 x i8> @wide_64i8(i1 %b, <vscale x 16 x i8> %legal, <vscale x 64 x i8> %illegal) nounwind {
; CHECK-LABEL: wide_64i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    stp x29, x30, [sp, #-16]! // 16-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-4
; CHECK-NEXT:    str z11, [sp] // 16-byte Folded Spill
; CHECK-NEXT:    str z10, [sp, #1, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    str z9, [sp, #2, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    str z8, [sp, #3, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    mov z8.d, z4.d
; CHECK-NEXT:    mov z9.d, z3.d
; CHECK-NEXT:    mov z10.d, z2.d
; CHECK-NEXT:    mov z11.d, z1.d
; CHECK-NEXT:    tbz w0, #0, .LBB14_2
; CHECK-NEXT:  // %bb.1: // %L1
; CHECK-NEXT:    bl bar
; CHECK-NEXT:  .LBB14_2: // %common.ret
; CHECK-NEXT:    mov z0.d, z11.d
; CHECK-NEXT:    mov z1.d, z10.d
; CHECK-NEXT:    mov z2.d, z9.d
; CHECK-NEXT:    mov z3.d, z8.d
; CHECK-NEXT:    ldr z11, [sp] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z10, [sp, #1, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z9, [sp, #2, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z8, [sp, #3, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    addvl sp, sp, #4
; CHECK-NEXT:    ldp x29, x30, [sp], #16 // 16-byte Folded Reload
; CHECK-NEXT:    ret
  br i1 %b, label %L1, label %L2
L1:
  call aarch64_sve_vector_pcs void @bar()
  ret <vscale x 64 x i8> undef
L2:
  ret <vscale x 64 x i8> %illegal
}

define <vscale x 32 x i16> @wide_32i16(i1 %b, <vscale x 16 x i8> %legal, <vscale x 32 x i16> %illegal) nounwind {
; CHECK-LABEL: wide_32i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    stp x29, x30, [sp, #-16]! // 16-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-4
; CHECK-NEXT:    str z11, [sp] // 16-byte Folded Spill
; CHECK-NEXT:    str z10, [sp, #1, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    str z9, [sp, #2, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    str z8, [sp, #3, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    mov z8.d, z4.d
; CHECK-NEXT:    mov z9.d, z3.d
; CHECK-NEXT:    mov z10.d, z2.d
; CHECK-NEXT:    mov z11.d, z1.d
; CHECK-NEXT:    tbz w0, #0, .LBB15_2
; CHECK-NEXT:  // %bb.1: // %L1
; CHECK-NEXT:    bl bar
; CHECK-NEXT:  .LBB15_2: // %common.ret
; CHECK-NEXT:    mov z0.d, z11.d
; CHECK-NEXT:    mov z1.d, z10.d
; CHECK-NEXT:    mov z2.d, z9.d
; CHECK-NEXT:    mov z3.d, z8.d
; CHECK-NEXT:    ldr z11, [sp] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z10, [sp, #1, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z9, [sp, #2, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z8, [sp, #3, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    addvl sp, sp, #4
; CHECK-NEXT:    ldp x29, x30, [sp], #16 // 16-byte Folded Reload
; CHECK-NEXT:    ret
  br i1 %b, label %L1, label %L2
L1:
  call aarch64_sve_vector_pcs void @bar()
  ret <vscale x 32 x i16> undef
L2:
  ret <vscale x 32 x i16> %illegal
}

define <vscale x 16 x i32> @wide_16i32(i1 %b, <vscale x 16 x i8> %legal, <vscale x 16 x i32> %illegal) nounwind {
; CHECK-LABEL: wide_16i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    stp x29, x30, [sp, #-16]! // 16-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-4
; CHECK-NEXT:    str z11, [sp] // 16-byte Folded Spill
; CHECK-NEXT:    str z10, [sp, #1, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    str z9, [sp, #2, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    str z8, [sp, #3, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    mov z8.d, z4.d
; CHECK-NEXT:    mov z9.d, z3.d
; CHECK-NEXT:    mov z10.d, z2.d
; CHECK-NEXT:    mov z11.d, z1.d
; CHECK-NEXT:    tbz w0, #0, .LBB16_2
; CHECK-NEXT:  // %bb.1: // %L1
; CHECK-NEXT:    bl bar
; CHECK-NEXT:  .LBB16_2: // %common.ret
; CHECK-NEXT:    mov z0.d, z11.d
; CHECK-NEXT:    mov z1.d, z10.d
; CHECK-NEXT:    mov z2.d, z9.d
; CHECK-NEXT:    mov z3.d, z8.d
; CHECK-NEXT:    ldr z11, [sp] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z10, [sp, #1, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z9, [sp, #2, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z8, [sp, #3, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    addvl sp, sp, #4
; CHECK-NEXT:    ldp x29, x30, [sp], #16 // 16-byte Folded Reload
; CHECK-NEXT:    ret
  br i1 %b, label %L1, label %L2
L1:
  call aarch64_sve_vector_pcs void @bar()
  ret <vscale x 16 x i32> undef
L2:
  ret <vscale x 16 x i32> %illegal
}

define <vscale x 8 x i64> @wide_8i64(i1 %b, <vscale x 16 x i8> %legal, <vscale x 8 x i64> %illegal) nounwind {
; CHECK-LABEL: wide_8i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    stp x29, x30, [sp, #-16]! // 16-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-4
; CHECK-NEXT:    str z11, [sp] // 16-byte Folded Spill
; CHECK-NEXT:    str z10, [sp, #1, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    str z9, [sp, #2, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    str z8, [sp, #3, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    mov z8.d, z4.d
; CHECK-NEXT:    mov z9.d, z3.d
; CHECK-NEXT:    mov z10.d, z2.d
; CHECK-NEXT:    mov z11.d, z1.d
; CHECK-NEXT:    tbz w0, #0, .LBB17_2
; CHECK-NEXT:  // %bb.1: // %L1
; CHECK-NEXT:    bl bar
; CHECK-NEXT:  .LBB17_2: // %common.ret
; CHECK-NEXT:    mov z0.d, z11.d
; CHECK-NEXT:    mov z1.d, z10.d
; CHECK-NEXT:    mov z2.d, z9.d
; CHECK-NEXT:    mov z3.d, z8.d
; CHECK-NEXT:    ldr z11, [sp] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z10, [sp, #1, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z9, [sp, #2, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z8, [sp, #3, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    addvl sp, sp, #4
; CHECK-NEXT:    ldp x29, x30, [sp], #16 // 16-byte Folded Reload
; CHECK-NEXT:    ret
  br i1 %b, label %L1, label %L2
L1:
  call aarch64_sve_vector_pcs void @bar()
  ret <vscale x 8 x i64> undef
L2:
  ret <vscale x 8 x i64> %illegal
}

define <vscale x 32 x half> @wide_32f16(i1 %b, <vscale x 16 x i8> %legal, <vscale x 32 x half> %illegal) nounwind {
; CHECK-LABEL: wide_32f16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    stp x29, x30, [sp, #-16]! // 16-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-4
; CHECK-NEXT:    str z11, [sp] // 16-byte Folded Spill
; CHECK-NEXT:    str z10, [sp, #1, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    str z9, [sp, #2, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    str z8, [sp, #3, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    mov z8.d, z4.d
; CHECK-NEXT:    mov z9.d, z3.d
; CHECK-NEXT:    mov z10.d, z2.d
; CHECK-NEXT:    mov z11.d, z1.d
; CHECK-NEXT:    tbz w0, #0, .LBB18_2
; CHECK-NEXT:  // %bb.1: // %L1
; CHECK-NEXT:    bl bar
; CHECK-NEXT:  .LBB18_2: // %common.ret
; CHECK-NEXT:    mov z0.d, z11.d
; CHECK-NEXT:    mov z1.d, z10.d
; CHECK-NEXT:    mov z2.d, z9.d
; CHECK-NEXT:    mov z3.d, z8.d
; CHECK-NEXT:    ldr z11, [sp] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z10, [sp, #1, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z9, [sp, #2, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z8, [sp, #3, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    addvl sp, sp, #4
; CHECK-NEXT:    ldp x29, x30, [sp], #16 // 16-byte Folded Reload
; CHECK-NEXT:    ret
  br i1 %b, label %L1, label %L2
L1:
  call aarch64_sve_vector_pcs void @bar()
  ret <vscale x 32 x half> undef
L2:
  ret <vscale x 32 x half> %illegal
}

define <vscale x 16 x float> @wide_16f32(i1 %b, <vscale x 16 x i8> %legal, <vscale x 16 x float> %illegal) nounwind {
; CHECK-LABEL: wide_16f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    stp x29, x30, [sp, #-16]! // 16-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-4
; CHECK-NEXT:    str z11, [sp] // 16-byte Folded Spill
; CHECK-NEXT:    str z10, [sp, #1, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    str z9, [sp, #2, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    str z8, [sp, #3, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    mov z8.d, z4.d
; CHECK-NEXT:    mov z9.d, z3.d
; CHECK-NEXT:    mov z10.d, z2.d
; CHECK-NEXT:    mov z11.d, z1.d
; CHECK-NEXT:    tbz w0, #0, .LBB19_2
; CHECK-NEXT:  // %bb.1: // %L1
; CHECK-NEXT:    bl bar
; CHECK-NEXT:  .LBB19_2: // %common.ret
; CHECK-NEXT:    mov z0.d, z11.d
; CHECK-NEXT:    mov z1.d, z10.d
; CHECK-NEXT:    mov z2.d, z9.d
; CHECK-NEXT:    mov z3.d, z8.d
; CHECK-NEXT:    ldr z11, [sp] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z10, [sp, #1, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z9, [sp, #2, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z8, [sp, #3, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    addvl sp, sp, #4
; CHECK-NEXT:    ldp x29, x30, [sp], #16 // 16-byte Folded Reload
; CHECK-NEXT:    ret
  br i1 %b, label %L1, label %L2
L1:
  call aarch64_sve_vector_pcs void @bar()
  ret <vscale x 16 x float> undef
L2:
  ret <vscale x 16 x float> %illegal
}

define <vscale x 8 x double> @wide_8f64(i1 %b, <vscale x 16 x i8> %legal, <vscale x 8 x double> %illegal) nounwind {
; CHECK-LABEL: wide_8f64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    stp x29, x30, [sp, #-16]! // 16-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-4
; CHECK-NEXT:    str z11, [sp] // 16-byte Folded Spill
; CHECK-NEXT:    str z10, [sp, #1, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    str z9, [sp, #2, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    str z8, [sp, #3, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    mov z8.d, z4.d
; CHECK-NEXT:    mov z9.d, z3.d
; CHECK-NEXT:    mov z10.d, z2.d
; CHECK-NEXT:    mov z11.d, z1.d
; CHECK-NEXT:    tbz w0, #0, .LBB20_2
; CHECK-NEXT:  // %bb.1: // %L1
; CHECK-NEXT:    bl bar
; CHECK-NEXT:  .LBB20_2: // %common.ret
; CHECK-NEXT:    mov z0.d, z11.d
; CHECK-NEXT:    mov z1.d, z10.d
; CHECK-NEXT:    mov z2.d, z9.d
; CHECK-NEXT:    mov z3.d, z8.d
; CHECK-NEXT:    ldr z11, [sp] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z10, [sp, #1, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z9, [sp, #2, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z8, [sp, #3, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    addvl sp, sp, #4
; CHECK-NEXT:    ldp x29, x30, [sp], #16 // 16-byte Folded Reload
; CHECK-NEXT:    ret
  br i1 %b, label %L1, label %L2
L1:
  call aarch64_sve_vector_pcs void @bar()
  ret <vscale x 8 x double> undef
L2:
  ret <vscale x 8 x double> %illegal
}
