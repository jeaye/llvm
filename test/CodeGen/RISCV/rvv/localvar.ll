; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv64 -mattr=+experimental-v < %s \
; RUN:   | FileCheck %s -check-prefix=RV64IV

define void @local_var_mf8() {
; RV64IV-LABEL: local_var_mf8:
; RV64IV:       # %bb.0:
; RV64IV-NEXT:    .cfi_def_cfa_offset 0
; RV64IV-NEXT:    csrr a0, vlenb
; RV64IV-NEXT:    slli a0, a0, 1
; RV64IV-NEXT:    sub sp, sp, a0
; RV64IV-NEXT:    vsetvli a0, zero, e8,mf8,ta,mu
; RV64IV-NEXT:    csrr a0, vlenb
; RV64IV-NEXT:    add a0, sp, a0
; RV64IV-NEXT:    vle8.v v25, (a0)
; RV64IV-NEXT:    vle8.v v25, (sp)
; RV64IV-NEXT:    csrr a0, vlenb
; RV64IV-NEXT:    slli a0, a0, 1
; RV64IV-NEXT:    add sp, sp, a0
; RV64IV-NEXT:    ret
  %local0 = alloca <vscale x 1 x i8>
  %local1 = alloca <vscale x 1 x i8>
  load volatile <vscale x 1 x i8>, <vscale x 1 x i8>* %local0
  load volatile <vscale x 1 x i8>, <vscale x 1 x i8>* %local1
  ret void
}

define void @local_var_m1() {
; RV64IV-LABEL: local_var_m1:
; RV64IV:       # %bb.0:
; RV64IV-NEXT:    .cfi_def_cfa_offset 0
; RV64IV-NEXT:    csrr a0, vlenb
; RV64IV-NEXT:    slli a0, a0, 1
; RV64IV-NEXT:    sub sp, sp, a0
; RV64IV-NEXT:    csrr a0, vlenb
; RV64IV-NEXT:    add a0, sp, a0
; RV64IV-NEXT:    vl1r.v v25, (a0)
; RV64IV-NEXT:    vl1r.v v25, (sp)
; RV64IV-NEXT:    csrr a0, vlenb
; RV64IV-NEXT:    slli a0, a0, 1
; RV64IV-NEXT:    add sp, sp, a0
; RV64IV-NEXT:    ret
  %local0 = alloca <vscale x 8 x i8>
  %local1 = alloca <vscale x 8 x i8>
  load volatile <vscale x 8 x i8>, <vscale x 8 x i8>* %local0
  load volatile <vscale x 8 x i8>, <vscale x 8 x i8>* %local1
  ret void
}

define void @local_var_m2() {
; RV64IV-LABEL: local_var_m2:
; RV64IV:       # %bb.0:
; RV64IV-NEXT:    .cfi_def_cfa_offset 0
; RV64IV-NEXT:    csrr a0, vlenb
; RV64IV-NEXT:    slli a0, a0, 2
; RV64IV-NEXT:    sub sp, sp, a0
; RV64IV-NEXT:    csrr a0, vlenb
; RV64IV-NEXT:    slli a0, a0, 1
; RV64IV-NEXT:    add a0, sp, a0
; RV64IV-NEXT:    vl2r.v v26, (a0)
; RV64IV-NEXT:    vl2r.v v26, (sp)
; RV64IV-NEXT:    csrr a0, vlenb
; RV64IV-NEXT:    slli a0, a0, 2
; RV64IV-NEXT:    add sp, sp, a0
; RV64IV-NEXT:    ret
  %local0 = alloca <vscale x 16 x i8>
  %local1 = alloca <vscale x 16 x i8>
  load volatile <vscale x 16 x i8>, <vscale x 16 x i8>* %local0
  load volatile <vscale x 16 x i8>, <vscale x 16 x i8>* %local1
  ret void
}

define void @local_var_m4() {
; RV64IV-LABEL: local_var_m4:
; RV64IV:       # %bb.0:
; RV64IV-NEXT:    addi sp, sp, -32
; RV64IV-NEXT:    .cfi_def_cfa_offset 32
; RV64IV-NEXT:    sd ra, 24(sp) # 8-byte Folded Spill
; RV64IV-NEXT:    sd s0, 16(sp) # 8-byte Folded Spill
; RV64IV-NEXT:    .cfi_offset ra, -8
; RV64IV-NEXT:    .cfi_offset s0, -16
; RV64IV-NEXT:    addi s0, sp, 32
; RV64IV-NEXT:    .cfi_def_cfa s0, 0
; RV64IV-NEXT:    andi sp, sp, -32
; RV64IV-NEXT:    csrr a0, vlenb
; RV64IV-NEXT:    slli a0, a0, 3
; RV64IV-NEXT:    sub sp, sp, a0
; RV64IV-NEXT:    csrr a0, vlenb
; RV64IV-NEXT:    slli a0, a0, 2
; RV64IV-NEXT:    add a0, sp, a0
; RV64IV-NEXT:    vl4r.v v28, (a0)
; RV64IV-NEXT:    vl4r.v v28, (sp)
; RV64IV-NEXT:    addi sp, s0, -32
; RV64IV-NEXT:    ld s0, 16(sp) # 8-byte Folded Reload
; RV64IV-NEXT:    ld ra, 24(sp) # 8-byte Folded Reload
; RV64IV-NEXT:    addi sp, sp, 32
; RV64IV-NEXT:    ret
  %local0 = alloca <vscale x 32 x i8>
  %local1 = alloca <vscale x 32 x i8>
  load volatile <vscale x 32 x i8>, <vscale x 32 x i8>* %local0
  load volatile <vscale x 32 x i8>, <vscale x 32 x i8>* %local1
  ret void
}

define void @local_var_m8() {
; RV64IV-LABEL: local_var_m8:
; RV64IV:       # %bb.0:
; RV64IV-NEXT:    addi sp, sp, -64
; RV64IV-NEXT:    .cfi_def_cfa_offset 64
; RV64IV-NEXT:    sd ra, 56(sp) # 8-byte Folded Spill
; RV64IV-NEXT:    sd s0, 48(sp) # 8-byte Folded Spill
; RV64IV-NEXT:    .cfi_offset ra, -8
; RV64IV-NEXT:    .cfi_offset s0, -16
; RV64IV-NEXT:    addi s0, sp, 64
; RV64IV-NEXT:    .cfi_def_cfa s0, 0
; RV64IV-NEXT:    andi sp, sp, -64
; RV64IV-NEXT:    csrr a0, vlenb
; RV64IV-NEXT:    slli a0, a0, 4
; RV64IV-NEXT:    sub sp, sp, a0
; RV64IV-NEXT:    csrr a0, vlenb
; RV64IV-NEXT:    slli a0, a0, 3
; RV64IV-NEXT:    add a0, sp, a0
; RV64IV-NEXT:    vl8r.v v8, (a0)
; RV64IV-NEXT:    vl8r.v v8, (sp)
; RV64IV-NEXT:    addi sp, s0, -64
; RV64IV-NEXT:    ld s0, 48(sp) # 8-byte Folded Reload
; RV64IV-NEXT:    ld ra, 56(sp) # 8-byte Folded Reload
; RV64IV-NEXT:    addi sp, sp, 64
; RV64IV-NEXT:    ret
  %local0 = alloca <vscale x 64 x i8>
  %local1 = alloca <vscale x 64 x i8>
  load volatile <vscale x 64 x i8>, <vscale x 64 x i8>* %local0
  load volatile <vscale x 64 x i8>, <vscale x 64 x i8>* %local1
  ret void
}

define void @local_var_m2_mix_local_scalar() {
; RV64IV-LABEL: local_var_m2_mix_local_scalar:
; RV64IV:       # %bb.0:
; RV64IV-NEXT:    addi sp, sp, -16
; RV64IV-NEXT:    .cfi_def_cfa_offset 16
; RV64IV-NEXT:    csrr a0, vlenb
; RV64IV-NEXT:    slli a0, a0, 2
; RV64IV-NEXT:    sub sp, sp, a0
; RV64IV-NEXT:    csrr a0, vlenb
; RV64IV-NEXT:    slli a0, a0, 2
; RV64IV-NEXT:    add a0, sp, a0
; RV64IV-NEXT:    lw a0, 12(a0)
; RV64IV-NEXT:    csrr a0, vlenb
; RV64IV-NEXT:    slli a0, a0, 1
; RV64IV-NEXT:    add a0, sp, a0
; RV64IV-NEXT:    vl2r.v v26, (a0)
; RV64IV-NEXT:    vl2r.v v26, (sp)
; RV64IV-NEXT:    csrr a0, vlenb
; RV64IV-NEXT:    slli a0, a0, 2
; RV64IV-NEXT:    add a0, sp, a0
; RV64IV-NEXT:    lw a0, 8(a0)
; RV64IV-NEXT:    csrr a0, vlenb
; RV64IV-NEXT:    slli a0, a0, 2
; RV64IV-NEXT:    add sp, sp, a0
; RV64IV-NEXT:    addi sp, sp, 16
; RV64IV-NEXT:    ret
  %local_scalar0 = alloca i32
  %local0 = alloca <vscale x 16 x i8>
  %local1 = alloca <vscale x 16 x i8>
  %local_scalar1 = alloca i32
  load volatile i32, i32* %local_scalar0
  load volatile <vscale x 16 x i8>, <vscale x 16 x i8>* %local0
  load volatile <vscale x 16 x i8>, <vscale x 16 x i8>* %local1
  load volatile i32, i32* %local_scalar1
  ret void
}

define void @local_var_m2_with_varsize_object(i64 %n) {
; RV64IV-LABEL: local_var_m2_with_varsize_object:
; RV64IV:       # %bb.0:
; RV64IV-NEXT:    addi sp, sp, -16
; RV64IV-NEXT:    .cfi_def_cfa_offset 16
; RV64IV-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64IV-NEXT:    sd s0, 0(sp) # 8-byte Folded Spill
; RV64IV-NEXT:    .cfi_offset ra, -8
; RV64IV-NEXT:    .cfi_offset s0, -16
; RV64IV-NEXT:    addi s0, sp, 16
; RV64IV-NEXT:    .cfi_def_cfa s0, 0
; RV64IV-NEXT:    csrr a1, vlenb
; RV64IV-NEXT:    slli a1, a1, 2
; RV64IV-NEXT:    sub sp, sp, a1
; RV64IV-NEXT:    addi a0, a0, 15
; RV64IV-NEXT:    andi a0, a0, -16
; RV64IV-NEXT:    sub a0, sp, a0
; RV64IV-NEXT:    mv sp, a0
; RV64IV-NEXT:    csrr a1, vlenb
; RV64IV-NEXT:    slli a1, a1, 1
; RV64IV-NEXT:    sub a1, s0, a1
; RV64IV-NEXT:    addi a1, a1, -16
; RV64IV-NEXT:    call notdead@plt
; RV64IV-NEXT:    csrr a0, vlenb
; RV64IV-NEXT:    slli a0, a0, 1
; RV64IV-NEXT:    sub a0, s0, a0
; RV64IV-NEXT:    addi a0, a0, -16
; RV64IV-NEXT:    vl2r.v v26, (a0)
; RV64IV-NEXT:    csrr a0, vlenb
; RV64IV-NEXT:    slli a0, a0, 2
; RV64IV-NEXT:    sub a0, s0, a0
; RV64IV-NEXT:    addi a0, a0, -16
; RV64IV-NEXT:    vl2r.v v26, (a0)
; RV64IV-NEXT:    addi sp, s0, -16
; RV64IV-NEXT:    ld s0, 0(sp) # 8-byte Folded Reload
; RV64IV-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64IV-NEXT:    addi sp, sp, 16
; RV64IV-NEXT:    ret
  %1 = alloca i8, i64 %n
  %2 = alloca <vscale x 16 x i8>
  %3 = alloca <vscale x 16 x i8>
  call void @notdead(i8* %1, <vscale x 16 x i8>* %2)
  load volatile <vscale x 16 x i8>, <vscale x 16 x i8>* %2
  load volatile <vscale x 16 x i8>, <vscale x 16 x i8>* %3
  ret void
}

define void @local_var_m2_with_bp(i64 %n) {
; RV64IV-LABEL: local_var_m2_with_bp:
; RV64IV:       # %bb.0:
; RV64IV-NEXT:    addi sp, sp, -256
; RV64IV-NEXT:    .cfi_def_cfa_offset 256
; RV64IV-NEXT:    sd ra, 248(sp) # 8-byte Folded Spill
; RV64IV-NEXT:    sd s0, 240(sp) # 8-byte Folded Spill
; RV64IV-NEXT:    sd s1, 232(sp) # 8-byte Folded Spill
; RV64IV-NEXT:    .cfi_offset ra, -8
; RV64IV-NEXT:    .cfi_offset s0, -16
; RV64IV-NEXT:    .cfi_offset s1, -24
; RV64IV-NEXT:    addi s0, sp, 256
; RV64IV-NEXT:    .cfi_def_cfa s0, 0
; RV64IV-NEXT:    andi sp, sp, -128
; RV64IV-NEXT:    mv s1, sp
; RV64IV-NEXT:    csrr a1, vlenb
; RV64IV-NEXT:    slli a1, a1, 2
; RV64IV-NEXT:    sub sp, sp, a1
; RV64IV-NEXT:    addi a0, a0, 15
; RV64IV-NEXT:    andi a0, a0, -16
; RV64IV-NEXT:    sub a0, sp, a0
; RV64IV-NEXT:    mv sp, a0
; RV64IV-NEXT:    addi a1, s1, 128
; RV64IV-NEXT:    csrr a2, vlenb
; RV64IV-NEXT:    slli a2, a2, 1
; RV64IV-NEXT:    sub a2, s1, a2
; RV64IV-NEXT:    mv a2, a2
; RV64IV-NEXT:    call notdead2@plt
; RV64IV-NEXT:    lw a0, 124(s1)
; RV64IV-NEXT:    csrr a0, vlenb
; RV64IV-NEXT:    slli a0, a0, 1
; RV64IV-NEXT:    sub a0, s1, a0
; RV64IV-NEXT:    vl2r.v v26, (a0)
; RV64IV-NEXT:    csrr a0, vlenb
; RV64IV-NEXT:    slli a0, a0, 2
; RV64IV-NEXT:    sub a0, s1, a0
; RV64IV-NEXT:    vl2r.v v26, (a0)
; RV64IV-NEXT:    lw a0, 120(s1)
; RV64IV-NEXT:    addi sp, s0, -256
; RV64IV-NEXT:    ld s1, 232(sp) # 8-byte Folded Reload
; RV64IV-NEXT:    ld s0, 240(sp) # 8-byte Folded Reload
; RV64IV-NEXT:    ld ra, 248(sp) # 8-byte Folded Reload
; RV64IV-NEXT:    addi sp, sp, 256
; RV64IV-NEXT:    ret
  %1 = alloca i8, i64 %n
  %2 = alloca i32, align 128
  %local_scalar0 = alloca i32
  %local0 = alloca <vscale x 16 x i8>
  %local1 = alloca <vscale x 16 x i8>
  %local_scalar1 = alloca i32
  call void @notdead2(i8* %1, i32* %2, <vscale x 16 x i8>* %local0)
  load volatile i32, i32* %local_scalar0
  load volatile <vscale x 16 x i8>, <vscale x 16 x i8>* %local0
  load volatile <vscale x 16 x i8>, <vscale x 16 x i8>* %local1
  load volatile i32, i32* %local_scalar1
  ret void
}

declare void @notdead(i8*, <vscale x 16 x i8>*)
declare void @notdead2(i8*, i32*, <vscale x 16 x i8>*)
