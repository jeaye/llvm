; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64-unknown-unknown | FileCheck %s

declare void @use(<4 x i32> %arg)

; (x+c1)+c2

define <4 x i32> @add_const_add_const(<4 x i32> %arg) {
; CHECK-LABEL: add_const_add_const:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.4s, #10
; CHECK-NEXT:    add v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    ret
  %t0 = add <4 x i32> %arg, <i32 8, i32 8, i32 8, i32 8>
  %t1 = add <4 x i32> %t0, <i32 2, i32 2, i32 2, i32 2>
  ret <4 x i32> %t1
}

define <4 x i32> @add_const_add_const_extrause(<4 x i32> %arg) {
; CHECK-LABEL: add_const_add_const_extrause:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub sp, sp, #32 // =32
; CHECK-NEXT:    str x30, [sp, #16] // 8-byte Folded Spill
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    .cfi_offset w30, -16
; CHECK-NEXT:    movi v1.4s, #8
; CHECK-NEXT:    str q0, [sp] // 16-byte Folded Spill
; CHECK-NEXT:    add v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    bl use
; CHECK-NEXT:    ldr q1, [sp] // 16-byte Folded Reload
; CHECK-NEXT:    ldr x30, [sp, #16] // 8-byte Folded Reload
; CHECK-NEXT:    movi v0.4s, #10
; CHECK-NEXT:    add v0.4s, v1.4s, v0.4s
; CHECK-NEXT:    add sp, sp, #32 // =32
; CHECK-NEXT:    ret
  %t0 = add <4 x i32> %arg, <i32 8, i32 8, i32 8, i32 8>
  call void @use(<4 x i32> %t0)
  %t1 = add <4 x i32> %t0, <i32 2, i32 2, i32 2, i32 2>
  ret <4 x i32> %t1
}

define <4 x i32> @add_const_add_const_nonsplat(<4 x i32> %arg) {
; CHECK-LABEL: add_const_add_const_nonsplat:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI2_0
; CHECK-NEXT:    ldr q1, [x8, :lo12:.LCPI2_0]
; CHECK-NEXT:    add v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    ret
  %t0 = add <4 x i32> %arg, <i32 21, i32 undef, i32 8, i32 8>
  %t1 = add <4 x i32> %t0, <i32 2, i32 3, i32 undef, i32 2>
  ret <4 x i32> %t1
}

; (x+c1)-c2

define <4 x i32> @add_const_sub_const(<4 x i32> %arg) {
; CHECK-LABEL: add_const_sub_const:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.4s, #6
; CHECK-NEXT:    add v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    ret
  %t0 = add <4 x i32> %arg, <i32 8, i32 8, i32 8, i32 8>
  %t1 = sub <4 x i32> %t0, <i32 2, i32 2, i32 2, i32 2>
  ret <4 x i32> %t1
}

define <4 x i32> @add_const_sub_const_extrause(<4 x i32> %arg) {
; CHECK-LABEL: add_const_sub_const_extrause:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub sp, sp, #32 // =32
; CHECK-NEXT:    str x30, [sp, #16] // 8-byte Folded Spill
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    .cfi_offset w30, -16
; CHECK-NEXT:    movi v1.4s, #8
; CHECK-NEXT:    str q0, [sp] // 16-byte Folded Spill
; CHECK-NEXT:    add v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    bl use
; CHECK-NEXT:    ldr q1, [sp] // 16-byte Folded Reload
; CHECK-NEXT:    ldr x30, [sp, #16] // 8-byte Folded Reload
; CHECK-NEXT:    movi v0.4s, #6
; CHECK-NEXT:    add v0.4s, v1.4s, v0.4s
; CHECK-NEXT:    add sp, sp, #32 // =32
; CHECK-NEXT:    ret
  %t0 = add <4 x i32> %arg, <i32 8, i32 8, i32 8, i32 8>
  call void @use(<4 x i32> %t0)
  %t1 = sub <4 x i32> %t0, <i32 2, i32 2, i32 2, i32 2>
  ret <4 x i32> %t1
}

define <4 x i32> @add_const_sub_const_nonsplat(<4 x i32> %arg) {
; CHECK-LABEL: add_const_sub_const_nonsplat:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI5_0
; CHECK-NEXT:    ldr q1, [x8, :lo12:.LCPI5_0]
; CHECK-NEXT:    add v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    ret
  %t0 = add <4 x i32> %arg, <i32 21, i32 undef, i32 8, i32 8>
  %t1 = sub <4 x i32> %t0, <i32 2, i32 3, i32 undef, i32 2>
  ret <4 x i32> %t1
}

; c2-(x+c1)

define <4 x i32> @add_const_const_sub(<4 x i32> %arg) {
; CHECK-LABEL: add_const_const_sub:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mvni v1.4s, #5
; CHECK-NEXT:    sub v0.4s, v1.4s, v0.4s
; CHECK-NEXT:    ret
  %t0 = add <4 x i32> %arg, <i32 8, i32 8, i32 8, i32 8>
  %t1 = sub <4 x i32> <i32 2, i32 2, i32 2, i32 2>, %t0
  ret <4 x i32> %t1
}

define <4 x i32> @add_const_const_sub_extrause(<4 x i32> %arg) {
; CHECK-LABEL: add_const_const_sub_extrause:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub sp, sp, #32 // =32
; CHECK-NEXT:    str x30, [sp, #16] // 8-byte Folded Spill
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    .cfi_offset w30, -16
; CHECK-NEXT:    movi v1.4s, #8
; CHECK-NEXT:    str q0, [sp] // 16-byte Folded Spill
; CHECK-NEXT:    add v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    bl use
; CHECK-NEXT:    ldr q1, [sp] // 16-byte Folded Reload
; CHECK-NEXT:    ldr x30, [sp, #16] // 8-byte Folded Reload
; CHECK-NEXT:    mvni v0.4s, #5
; CHECK-NEXT:    sub v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    add sp, sp, #32 // =32
; CHECK-NEXT:    ret
  %t0 = add <4 x i32> %arg, <i32 8, i32 8, i32 8, i32 8>
  call void @use(<4 x i32> %t0)
  %t1 = sub <4 x i32> <i32 2, i32 2, i32 2, i32 2>, %t0
  ret <4 x i32> %t1
}

define <4 x i32> @add_const_const_sub_nonsplat(<4 x i32> %arg) {
; CHECK-LABEL: add_const_const_sub_nonsplat:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI8_0
; CHECK-NEXT:    ldr q1, [x8, :lo12:.LCPI8_0]
; CHECK-NEXT:    sub v0.4s, v1.4s, v0.4s
; CHECK-NEXT:    ret
  %t0 = add <4 x i32> %arg, <i32 21, i32 undef, i32 8, i32 8>
  %t1 = sub <4 x i32> <i32 2, i32 3, i32 undef, i32 2>, %t0
  ret <4 x i32> %t1
}

; (x-c1)+c2

define <4 x i32> @sub_const_add_const(<4 x i32> %arg) {
; CHECK-LABEL: sub_const_add_const:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mvni v1.4s, #5
; CHECK-NEXT:    add v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    ret
  %t0 = sub <4 x i32> %arg, <i32 8, i32 8, i32 8, i32 8>
  %t1 = add <4 x i32> %t0, <i32 2, i32 2, i32 2, i32 2>
  ret <4 x i32> %t1
}

define <4 x i32> @sub_const_add_const_extrause(<4 x i32> %arg) {
; CHECK-LABEL: sub_const_add_const_extrause:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub sp, sp, #32 // =32
; CHECK-NEXT:    str x30, [sp, #16] // 8-byte Folded Spill
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    .cfi_offset w30, -16
; CHECK-NEXT:    movi v1.4s, #8
; CHECK-NEXT:    str q0, [sp] // 16-byte Folded Spill
; CHECK-NEXT:    sub v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    bl use
; CHECK-NEXT:    ldr q1, [sp] // 16-byte Folded Reload
; CHECK-NEXT:    ldr x30, [sp, #16] // 8-byte Folded Reload
; CHECK-NEXT:    mvni v0.4s, #5
; CHECK-NEXT:    add v0.4s, v1.4s, v0.4s
; CHECK-NEXT:    add sp, sp, #32 // =32
; CHECK-NEXT:    ret
  %t0 = sub <4 x i32> %arg, <i32 8, i32 8, i32 8, i32 8>
  call void @use(<4 x i32> %t0)
  %t1 = add <4 x i32> %t0, <i32 2, i32 2, i32 2, i32 2>
  ret <4 x i32> %t1
}

define <4 x i32> @sub_const_add_const_nonsplat(<4 x i32> %arg) {
; CHECK-LABEL: sub_const_add_const_nonsplat:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI11_0
; CHECK-NEXT:    ldr q1, [x8, :lo12:.LCPI11_0]
; CHECK-NEXT:    add v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    ret
  %t0 = sub <4 x i32> %arg, <i32 21, i32 undef, i32 8, i32 8>
  %t1 = add <4 x i32> %t0, <i32 2, i32 3, i32 undef, i32 2>
  ret <4 x i32> %t1
}

; (x-c1)-c2

define <4 x i32> @sub_const_sub_const(<4 x i32> %arg) {
; CHECK-LABEL: sub_const_sub_const:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.4s, #10
; CHECK-NEXT:    sub v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    ret
  %t0 = sub <4 x i32> %arg, <i32 8, i32 8, i32 8, i32 8>
  %t1 = sub <4 x i32> %t0, <i32 2, i32 2, i32 2, i32 2>
  ret <4 x i32> %t1
}

define <4 x i32> @sub_const_sub_const_extrause(<4 x i32> %arg) {
; CHECK-LABEL: sub_const_sub_const_extrause:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub sp, sp, #32 // =32
; CHECK-NEXT:    str x30, [sp, #16] // 8-byte Folded Spill
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    .cfi_offset w30, -16
; CHECK-NEXT:    movi v1.4s, #8
; CHECK-NEXT:    str q0, [sp] // 16-byte Folded Spill
; CHECK-NEXT:    sub v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    bl use
; CHECK-NEXT:    ldr q1, [sp] // 16-byte Folded Reload
; CHECK-NEXT:    ldr x30, [sp, #16] // 8-byte Folded Reload
; CHECK-NEXT:    movi v0.4s, #10
; CHECK-NEXT:    sub v0.4s, v1.4s, v0.4s
; CHECK-NEXT:    add sp, sp, #32 // =32
; CHECK-NEXT:    ret
  %t0 = sub <4 x i32> %arg, <i32 8, i32 8, i32 8, i32 8>
  call void @use(<4 x i32> %t0)
  %t1 = sub <4 x i32> %t0, <i32 2, i32 2, i32 2, i32 2>
  ret <4 x i32> %t1
}

define <4 x i32> @sub_const_sub_const_nonsplat(<4 x i32> %arg) {
; CHECK-LABEL: sub_const_sub_const_nonsplat:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI14_0
; CHECK-NEXT:    ldr q1, [x8, :lo12:.LCPI14_0]
; CHECK-NEXT:    sub v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    ret
  %t0 = sub <4 x i32> %arg, <i32 21, i32 undef, i32 8, i32 8>
  %t1 = sub <4 x i32> %t0, <i32 2, i32 3, i32 undef, i32 2>
  ret <4 x i32> %t1
}

; c2-(x-c1)

define <4 x i32> @sub_const_const_sub(<4 x i32> %arg) {
; CHECK-LABEL: sub_const_const_sub:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.4s, #10
; CHECK-NEXT:    sub v0.4s, v1.4s, v0.4s
; CHECK-NEXT:    ret
  %t0 = sub <4 x i32> %arg, <i32 8, i32 8, i32 8, i32 8>
  %t1 = sub <4 x i32> <i32 2, i32 2, i32 2, i32 2>, %t0
  ret <4 x i32> %t1
}

define <4 x i32> @sub_const_const_sub_extrause(<4 x i32> %arg) {
; CHECK-LABEL: sub_const_const_sub_extrause:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub sp, sp, #32 // =32
; CHECK-NEXT:    str x30, [sp, #16] // 8-byte Folded Spill
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    .cfi_offset w30, -16
; CHECK-NEXT:    movi v1.4s, #8
; CHECK-NEXT:    sub v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    str q0, [sp] // 16-byte Folded Spill
; CHECK-NEXT:    bl use
; CHECK-NEXT:    ldr q1, [sp] // 16-byte Folded Reload
; CHECK-NEXT:    ldr x30, [sp, #16] // 8-byte Folded Reload
; CHECK-NEXT:    movi v0.4s, #2
; CHECK-NEXT:    sub v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    add sp, sp, #32 // =32
; CHECK-NEXT:    ret
  %t0 = sub <4 x i32> %arg, <i32 8, i32 8, i32 8, i32 8>
  call void @use(<4 x i32> %t0)
  %t1 = sub <4 x i32> <i32 2, i32 2, i32 2, i32 2>, %t0
  ret <4 x i32> %t1
}

define <4 x i32> @sub_const_const_sub_nonsplat(<4 x i32> %arg) {
; CHECK-LABEL: sub_const_const_sub_nonsplat:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI17_0
; CHECK-NEXT:    ldr q1, [x8, :lo12:.LCPI17_0]
; CHECK-NEXT:    sub v0.4s, v1.4s, v0.4s
; CHECK-NEXT:    ret
  %t0 = sub <4 x i32> %arg, <i32 21, i32 undef, i32 8, i32 8>
  %t1 = sub <4 x i32> <i32 2, i32 3, i32 undef, i32 2>, %t0
  ret <4 x i32> %t1
}

; (c1-x)+c2

define <4 x i32> @const_sub_add_const(<4 x i32> %arg) {
; CHECK-LABEL: const_sub_add_const:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.4s, #10
; CHECK-NEXT:    sub v0.4s, v1.4s, v0.4s
; CHECK-NEXT:    ret
  %t0 = sub <4 x i32> <i32 8, i32 8, i32 8, i32 8>, %arg
  %t1 = add <4 x i32> %t0, <i32 2, i32 2, i32 2, i32 2>
  ret <4 x i32> %t1
}

define <4 x i32> @const_sub_add_const_extrause(<4 x i32> %arg) {
; CHECK-LABEL: const_sub_add_const_extrause:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub sp, sp, #32 // =32
; CHECK-NEXT:    str x30, [sp, #16] // 8-byte Folded Spill
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    .cfi_offset w30, -16
; CHECK-NEXT:    movi v1.4s, #8
; CHECK-NEXT:    str q0, [sp] // 16-byte Folded Spill
; CHECK-NEXT:    sub v0.4s, v1.4s, v0.4s
; CHECK-NEXT:    bl use
; CHECK-NEXT:    ldr q1, [sp] // 16-byte Folded Reload
; CHECK-NEXT:    ldr x30, [sp, #16] // 8-byte Folded Reload
; CHECK-NEXT:    movi v0.4s, #10
; CHECK-NEXT:    sub v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    add sp, sp, #32 // =32
; CHECK-NEXT:    ret
  %t0 = sub <4 x i32> <i32 8, i32 8, i32 8, i32 8>, %arg
  call void @use(<4 x i32> %t0)
  %t1 = add <4 x i32> %t0, <i32 2, i32 2, i32 2, i32 2>
  ret <4 x i32> %t1
}

define <4 x i32> @const_sub_add_const_nonsplat(<4 x i32> %arg) {
; CHECK-LABEL: const_sub_add_const_nonsplat:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI20_0
; CHECK-NEXT:    ldr q1, [x8, :lo12:.LCPI20_0]
; CHECK-NEXT:    sub v0.4s, v1.4s, v0.4s
; CHECK-NEXT:    ret
  %t0 = sub <4 x i32> <i32 21, i32 undef, i32 8, i32 8>, %arg
  %t1 = add <4 x i32> %t0, <i32 2, i32 3, i32 undef, i32 2>
  ret <4 x i32> %t1
}

; (c1-x)-c2

define <4 x i32> @const_sub_sub_const(<4 x i32> %arg) {
; CHECK-LABEL: const_sub_sub_const:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.4s, #6
; CHECK-NEXT:    sub v0.4s, v1.4s, v0.4s
; CHECK-NEXT:    ret
  %t0 = sub <4 x i32> <i32 8, i32 8, i32 8, i32 8>, %arg
  %t1 = sub <4 x i32> %t0, <i32 2, i32 2, i32 2, i32 2>
  ret <4 x i32> %t1
}

define <4 x i32> @const_sub_sub_const_extrause(<4 x i32> %arg) {
; CHECK-LABEL: const_sub_sub_const_extrause:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub sp, sp, #32 // =32
; CHECK-NEXT:    str x30, [sp, #16] // 8-byte Folded Spill
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    .cfi_offset w30, -16
; CHECK-NEXT:    movi v1.4s, #8
; CHECK-NEXT:    str q0, [sp] // 16-byte Folded Spill
; CHECK-NEXT:    sub v0.4s, v1.4s, v0.4s
; CHECK-NEXT:    bl use
; CHECK-NEXT:    ldr q1, [sp] // 16-byte Folded Reload
; CHECK-NEXT:    ldr x30, [sp, #16] // 8-byte Folded Reload
; CHECK-NEXT:    movi v0.4s, #6
; CHECK-NEXT:    sub v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    add sp, sp, #32 // =32
; CHECK-NEXT:    ret
  %t0 = sub <4 x i32> <i32 8, i32 8, i32 8, i32 8>, %arg
  call void @use(<4 x i32> %t0)
  %t1 = sub <4 x i32> %t0, <i32 2, i32 2, i32 2, i32 2>
  ret <4 x i32> %t1
}

define <4 x i32> @const_sub_sub_const_nonsplat(<4 x i32> %arg) {
; CHECK-LABEL: const_sub_sub_const_nonsplat:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI23_0
; CHECK-NEXT:    ldr q1, [x8, :lo12:.LCPI23_0]
; CHECK-NEXT:    sub v0.4s, v1.4s, v0.4s
; CHECK-NEXT:    ret
  %t0 = sub <4 x i32> <i32 21, i32 undef, i32 8, i32 8>, %arg
  %t1 = sub <4 x i32> %t0, <i32 2, i32 3, i32 undef, i32 2>
  ret <4 x i32> %t1
}

; c2-(c1-x)

define <4 x i32> @const_sub_const_sub(<4 x i32> %arg) {
; CHECK-LABEL: const_sub_const_sub:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mvni v1.4s, #5
; CHECK-NEXT:    add v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    ret
  %t0 = sub <4 x i32> <i32 8, i32 8, i32 8, i32 8>, %arg
  %t1 = sub <4 x i32> <i32 2, i32 2, i32 2, i32 2>, %t0
  ret <4 x i32> %t1
}

define <4 x i32> @const_sub_const_sub_extrause(<4 x i32> %arg) {
; CHECK-LABEL: const_sub_const_sub_extrause:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub sp, sp, #32 // =32
; CHECK-NEXT:    str x30, [sp, #16] // 8-byte Folded Spill
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    .cfi_offset w30, -16
; CHECK-NEXT:    movi v1.4s, #8
; CHECK-NEXT:    sub v0.4s, v1.4s, v0.4s
; CHECK-NEXT:    str q0, [sp] // 16-byte Folded Spill
; CHECK-NEXT:    bl use
; CHECK-NEXT:    ldr q1, [sp] // 16-byte Folded Reload
; CHECK-NEXT:    ldr x30, [sp, #16] // 8-byte Folded Reload
; CHECK-NEXT:    movi v0.4s, #2
; CHECK-NEXT:    sub v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    add sp, sp, #32 // =32
; CHECK-NEXT:    ret
  %t0 = sub <4 x i32> <i32 8, i32 8, i32 8, i32 8>, %arg
  call void @use(<4 x i32> %t0)
  %t1 = sub <4 x i32> <i32 2, i32 2, i32 2, i32 2>, %t0
  ret <4 x i32> %t1
}

define <4 x i32> @const_sub_const_sub_nonsplat(<4 x i32> %arg) {
; CHECK-LABEL: const_sub_const_sub_nonsplat:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI26_0
; CHECK-NEXT:    ldr q1, [x8, :lo12:.LCPI26_0]
; CHECK-NEXT:    add v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    ret
  %t0 = sub <4 x i32> <i32 21, i32 undef, i32 8, i32 8>, %arg
  %t1 = sub <4 x i32> <i32 2, i32 3, i32 undef, i32 2>, %t0
  ret <4 x i32> %t1
}
