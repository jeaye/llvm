; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv64 -mattr=+experimental-v -verify-machineinstrs \
; RUN:   < %s | FileCheck %s
declare <vscale x 1 x i64> @llvm.riscv.vsext.nxv1i64.nxv1i8(
  <vscale x 1 x i8>,
  i64);

define <vscale x 1 x i64> @intrinsic_vsext_vf8_nxv1i64(<vscale x 1 x i8> %0, i64 %1) nounwind {
; CHECK-LABEL: intrinsic_vsext_vf8_nxv1i64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e64,m1,ta,mu
; CHECK-NEXT:    vsext.vf8 v25, v8
; CHECK-NEXT:    vmv1r.v v8, v25
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x i64> @llvm.riscv.vsext.nxv1i64.nxv1i8(
    <vscale x 1 x i8> %0,
    i64 %1)

  ret <vscale x 1 x i64> %a
}

declare <vscale x 1 x i64> @llvm.riscv.vsext.mask.nxv1i64.nxv1i8(
  <vscale x 1 x i64>,
  <vscale x 1 x i8>,
  <vscale x 1 x i1>,
  i64);

define <vscale x 1 x i64> @intrinsic_vsext_mask_vf8_nxv1i64(<vscale x 1 x i1> %0, <vscale x 1 x i64> %1, <vscale x 1 x i8> %2, i64 %3) nounwind {
; CHECK-LABEL: intrinsic_vsext_mask_vf8_nxv1i64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e64,m1,tu,mu
; CHECK-NEXT:    vsext.vf8 v8, v9, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x i64> @llvm.riscv.vsext.mask.nxv1i64.nxv1i8(
    <vscale x 1 x i64> %1,
    <vscale x 1 x i8> %2,
    <vscale x 1 x i1> %0,
    i64 %3)

  ret <vscale x 1 x i64> %a
}

declare <vscale x 2 x i64> @llvm.riscv.vsext.nxv2i64.nxv2i8(
  <vscale x 2 x i8>,
  i64);

define <vscale x 2 x i64> @intrinsic_vsext_vf8_nxv2i64(<vscale x 2 x i8> %0, i64 %1) nounwind {
; CHECK-LABEL: intrinsic_vsext_vf8_nxv2i64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e64,m2,ta,mu
; CHECK-NEXT:    vsext.vf8 v26, v8
; CHECK-NEXT:    vmv2r.v v8, v26
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x i64> @llvm.riscv.vsext.nxv2i64.nxv2i8(
    <vscale x 2 x i8> %0,
    i64 %1)

  ret <vscale x 2 x i64> %a
}

declare <vscale x 2 x i64> @llvm.riscv.vsext.mask.nxv2i64.nxv2i8(
  <vscale x 2 x i64>,
  <vscale x 2 x i8>,
  <vscale x 2 x i1>,
  i64);

define <vscale x 2 x i64> @intrinsic_vsext_mask_vf8_nxv2i64(<vscale x 2 x i1> %0, <vscale x 2 x i64> %1, <vscale x 2 x i8> %2, i64 %3) nounwind {
; CHECK-LABEL: intrinsic_vsext_mask_vf8_nxv2i64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e64,m2,tu,mu
; CHECK-NEXT:    vsext.vf8 v8, v10, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x i64> @llvm.riscv.vsext.mask.nxv2i64.nxv2i8(
    <vscale x 2 x i64> %1,
    <vscale x 2 x i8> %2,
    <vscale x 2 x i1> %0,
    i64 %3)

  ret <vscale x 2 x i64> %a
}

declare <vscale x 4 x i64> @llvm.riscv.vsext.nxv4i64.nxv4i8(
  <vscale x 4 x i8>,
  i64);

define <vscale x 4 x i64> @intrinsic_vsext_vf8_nxv4i64(<vscale x 4 x i8> %0, i64 %1) nounwind {
; CHECK-LABEL: intrinsic_vsext_vf8_nxv4i64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e64,m4,ta,mu
; CHECK-NEXT:    vsext.vf8 v28, v8
; CHECK-NEXT:    vmv4r.v v8, v28
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x i64> @llvm.riscv.vsext.nxv4i64.nxv4i8(
    <vscale x 4 x i8> %0,
    i64 %1)

  ret <vscale x 4 x i64> %a
}

declare <vscale x 4 x i64> @llvm.riscv.vsext.mask.nxv4i64.nxv4i8(
  <vscale x 4 x i64>,
  <vscale x 4 x i8>,
  <vscale x 4 x i1>,
  i64);

define <vscale x 4 x i64> @intrinsic_vsext_mask_vf8_nxv4i64(<vscale x 4 x i1> %0, <vscale x 4 x i64> %1, <vscale x 4 x i8> %2, i64 %3) nounwind {
; CHECK-LABEL: intrinsic_vsext_mask_vf8_nxv4i64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e64,m4,tu,mu
; CHECK-NEXT:    vsext.vf8 v8, v12, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x i64> @llvm.riscv.vsext.mask.nxv4i64.nxv4i8(
    <vscale x 4 x i64> %1,
    <vscale x 4 x i8> %2,
    <vscale x 4 x i1> %0,
    i64 %3)

  ret <vscale x 4 x i64> %a
}

declare <vscale x 8 x i64> @llvm.riscv.vsext.nxv8i64.nxv8i8(
  <vscale x 8 x i8>,
  i64);

define <vscale x 8 x i64> @intrinsic_vsext_vf8_nxv8i64(<vscale x 8 x i8> %0, i64 %1) nounwind {
; CHECK-LABEL: intrinsic_vsext_vf8_nxv8i64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e64,m8,ta,mu
; CHECK-NEXT:    vsext.vf8 v16, v8
; CHECK-NEXT:    vmv8r.v v8, v16
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x i64> @llvm.riscv.vsext.nxv8i64.nxv8i8(
    <vscale x 8 x i8> %0,
    i64 %1)

  ret <vscale x 8 x i64> %a
}

declare <vscale x 8 x i64> @llvm.riscv.vsext.mask.nxv8i64.nxv8i8(
  <vscale x 8 x i64>,
  <vscale x 8 x i8>,
  <vscale x 8 x i1>,
  i64);

define <vscale x 8 x i64> @intrinsic_vsext_mask_vf8_nxv8i64(<vscale x 8 x i1> %0, <vscale x 8 x i64> %1, <vscale x 8 x i8> %2, i64 %3) nounwind {
; CHECK-LABEL: intrinsic_vsext_mask_vf8_nxv8i64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e64,m8,tu,mu
; CHECK-NEXT:    vsext.vf8 v8, v16, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x i64> @llvm.riscv.vsext.mask.nxv8i64.nxv8i8(
    <vscale x 8 x i64> %1,
    <vscale x 8 x i8> %2,
    <vscale x 8 x i1> %0,
    i64 %3)

  ret <vscale x 8 x i64> %a
}

declare <vscale x 1 x i64> @llvm.riscv.vsext.nxv1i64.nxv1i16(
  <vscale x 1 x i16>,
  i64);

define <vscale x 1 x i64> @intrinsic_vsext_vf4_nxv1i64(<vscale x 1 x i16> %0, i64 %1) nounwind {
; CHECK-LABEL: intrinsic_vsext_vf4_nxv1i64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e64,m1,ta,mu
; CHECK-NEXT:    vsext.vf4 v25, v8
; CHECK-NEXT:    vmv1r.v v8, v25
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x i64> @llvm.riscv.vsext.nxv1i64.nxv1i16(
    <vscale x 1 x i16> %0,
    i64 %1)

  ret <vscale x 1 x i64> %a
}

declare <vscale x 1 x i64> @llvm.riscv.vsext.mask.nxv1i64.nxv1i16(
  <vscale x 1 x i64>,
  <vscale x 1 x i16>,
  <vscale x 1 x i1>,
  i64);

define <vscale x 1 x i64> @intrinsic_vsext_mask_vf4_nxv1i64(<vscale x 1 x i1> %0, <vscale x 1 x i64> %1, <vscale x 1 x i16> %2, i64 %3) nounwind {
; CHECK-LABEL: intrinsic_vsext_mask_vf4_nxv1i64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e64,m1,tu,mu
; CHECK-NEXT:    vsext.vf4 v8, v9, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x i64> @llvm.riscv.vsext.mask.nxv1i64.nxv1i16(
    <vscale x 1 x i64> %1,
    <vscale x 1 x i16> %2,
    <vscale x 1 x i1> %0,
    i64 %3)

  ret <vscale x 1 x i64> %a
}

declare <vscale x 2 x i64> @llvm.riscv.vsext.nxv2i64.nxv2i16(
  <vscale x 2 x i16>,
  i64);

define <vscale x 2 x i64> @intrinsic_vsext_vf4_nxv2i64(<vscale x 2 x i16> %0, i64 %1) nounwind {
; CHECK-LABEL: intrinsic_vsext_vf4_nxv2i64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e64,m2,ta,mu
; CHECK-NEXT:    vsext.vf4 v26, v8
; CHECK-NEXT:    vmv2r.v v8, v26
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x i64> @llvm.riscv.vsext.nxv2i64.nxv2i16(
    <vscale x 2 x i16> %0,
    i64 %1)

  ret <vscale x 2 x i64> %a
}

declare <vscale x 2 x i64> @llvm.riscv.vsext.mask.nxv2i64.nxv2i16(
  <vscale x 2 x i64>,
  <vscale x 2 x i16>,
  <vscale x 2 x i1>,
  i64);

define <vscale x 2 x i64> @intrinsic_vsext_mask_vf4_nxv2i64(<vscale x 2 x i1> %0, <vscale x 2 x i64> %1, <vscale x 2 x i16> %2, i64 %3) nounwind {
; CHECK-LABEL: intrinsic_vsext_mask_vf4_nxv2i64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e64,m2,tu,mu
; CHECK-NEXT:    vsext.vf4 v8, v10, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x i64> @llvm.riscv.vsext.mask.nxv2i64.nxv2i16(
    <vscale x 2 x i64> %1,
    <vscale x 2 x i16> %2,
    <vscale x 2 x i1> %0,
    i64 %3)

  ret <vscale x 2 x i64> %a
}

declare <vscale x 4 x i64> @llvm.riscv.vsext.nxv4i64.nxv4i16(
  <vscale x 4 x i16>,
  i64);

define <vscale x 4 x i64> @intrinsic_vsext_vf4_nxv4i64(<vscale x 4 x i16> %0, i64 %1) nounwind {
; CHECK-LABEL: intrinsic_vsext_vf4_nxv4i64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e64,m4,ta,mu
; CHECK-NEXT:    vsext.vf4 v28, v8
; CHECK-NEXT:    vmv4r.v v8, v28
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x i64> @llvm.riscv.vsext.nxv4i64.nxv4i16(
    <vscale x 4 x i16> %0,
    i64 %1)

  ret <vscale x 4 x i64> %a
}

declare <vscale x 4 x i64> @llvm.riscv.vsext.mask.nxv4i64.nxv4i16(
  <vscale x 4 x i64>,
  <vscale x 4 x i16>,
  <vscale x 4 x i1>,
  i64);

define <vscale x 4 x i64> @intrinsic_vsext_mask_vf4_nxv4i64(<vscale x 4 x i1> %0, <vscale x 4 x i64> %1, <vscale x 4 x i16> %2, i64 %3) nounwind {
; CHECK-LABEL: intrinsic_vsext_mask_vf4_nxv4i64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e64,m4,tu,mu
; CHECK-NEXT:    vsext.vf4 v8, v12, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x i64> @llvm.riscv.vsext.mask.nxv4i64.nxv4i16(
    <vscale x 4 x i64> %1,
    <vscale x 4 x i16> %2,
    <vscale x 4 x i1> %0,
    i64 %3)

  ret <vscale x 4 x i64> %a
}

declare <vscale x 8 x i64> @llvm.riscv.vsext.nxv8i64.nxv8i16(
  <vscale x 8 x i16>,
  i64);

define <vscale x 8 x i64> @intrinsic_vsext_vf4_nxv8i64(<vscale x 8 x i16> %0, i64 %1) nounwind {
; CHECK-LABEL: intrinsic_vsext_vf4_nxv8i64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e64,m8,ta,mu
; CHECK-NEXT:    vsext.vf4 v16, v8
; CHECK-NEXT:    vmv8r.v v8, v16
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x i64> @llvm.riscv.vsext.nxv8i64.nxv8i16(
    <vscale x 8 x i16> %0,
    i64 %1)

  ret <vscale x 8 x i64> %a
}

declare <vscale x 8 x i64> @llvm.riscv.vsext.mask.nxv8i64.nxv8i16(
  <vscale x 8 x i64>,
  <vscale x 8 x i16>,
  <vscale x 8 x i1>,
  i64);

define <vscale x 8 x i64> @intrinsic_vsext_mask_vf4_nxv8i64(<vscale x 8 x i1> %0, <vscale x 8 x i64> %1, <vscale x 8 x i16> %2, i64 %3) nounwind {
; CHECK-LABEL: intrinsic_vsext_mask_vf4_nxv8i64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e64,m8,tu,mu
; CHECK-NEXT:    vsext.vf4 v8, v16, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x i64> @llvm.riscv.vsext.mask.nxv8i64.nxv8i16(
    <vscale x 8 x i64> %1,
    <vscale x 8 x i16> %2,
    <vscale x 8 x i1> %0,
    i64 %3)

  ret <vscale x 8 x i64> %a
}

declare <vscale x 1 x i32> @llvm.riscv.vsext.nxv1i32.nxv1i8(
  <vscale x 1 x i8>,
  i64);

define <vscale x 1 x i32> @intrinsic_vsext_vf4_nxv1i32(<vscale x 1 x i8> %0, i64 %1) nounwind {
; CHECK-LABEL: intrinsic_vsext_vf4_nxv1i32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32,mf2,ta,mu
; CHECK-NEXT:    vsext.vf4 v25, v8
; CHECK-NEXT:    vmv1r.v v8, v25
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x i32> @llvm.riscv.vsext.nxv1i32.nxv1i8(
    <vscale x 1 x i8> %0,
    i64 %1)

  ret <vscale x 1 x i32> %a
}

declare <vscale x 1 x i32> @llvm.riscv.vsext.mask.nxv1i32.nxv1i8(
  <vscale x 1 x i32>,
  <vscale x 1 x i8>,
  <vscale x 1 x i1>,
  i64);

define <vscale x 1 x i32> @intrinsic_vsext_mask_vf4_nxv1i32(<vscale x 1 x i1> %0, <vscale x 1 x i32> %1, <vscale x 1 x i8> %2, i64 %3) nounwind {
; CHECK-LABEL: intrinsic_vsext_mask_vf4_nxv1i32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32,mf2,tu,mu
; CHECK-NEXT:    vsext.vf4 v8, v9, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x i32> @llvm.riscv.vsext.mask.nxv1i32.nxv1i8(
    <vscale x 1 x i32> %1,
    <vscale x 1 x i8> %2,
    <vscale x 1 x i1> %0,
    i64 %3)

  ret <vscale x 1 x i32> %a
}

declare <vscale x 2 x i32> @llvm.riscv.vsext.nxv2i32.nxv2i8(
  <vscale x 2 x i8>,
  i64);

define <vscale x 2 x i32> @intrinsic_vsext_vf4_nxv2i32(<vscale x 2 x i8> %0, i64 %1) nounwind {
; CHECK-LABEL: intrinsic_vsext_vf4_nxv2i32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32,m1,ta,mu
; CHECK-NEXT:    vsext.vf4 v25, v8
; CHECK-NEXT:    vmv1r.v v8, v25
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x i32> @llvm.riscv.vsext.nxv2i32.nxv2i8(
    <vscale x 2 x i8> %0,
    i64 %1)

  ret <vscale x 2 x i32> %a
}

declare <vscale x 2 x i32> @llvm.riscv.vsext.mask.nxv2i32.nxv2i8(
  <vscale x 2 x i32>,
  <vscale x 2 x i8>,
  <vscale x 2 x i1>,
  i64);

define <vscale x 2 x i32> @intrinsic_vsext_mask_vf4_nxv2i32(<vscale x 2 x i1> %0, <vscale x 2 x i32> %1, <vscale x 2 x i8> %2, i64 %3) nounwind {
; CHECK-LABEL: intrinsic_vsext_mask_vf4_nxv2i32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32,m1,tu,mu
; CHECK-NEXT:    vsext.vf4 v8, v9, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x i32> @llvm.riscv.vsext.mask.nxv2i32.nxv2i8(
    <vscale x 2 x i32> %1,
    <vscale x 2 x i8> %2,
    <vscale x 2 x i1> %0,
    i64 %3)

  ret <vscale x 2 x i32> %a
}

declare <vscale x 4 x i32> @llvm.riscv.vsext.nxv4i32.nxv4i8(
  <vscale x 4 x i8>,
  i64);

define <vscale x 4 x i32> @intrinsic_vsext_vf4_nxv4i32(<vscale x 4 x i8> %0, i64 %1) nounwind {
; CHECK-LABEL: intrinsic_vsext_vf4_nxv4i32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32,m2,ta,mu
; CHECK-NEXT:    vsext.vf4 v26, v8
; CHECK-NEXT:    vmv2r.v v8, v26
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x i32> @llvm.riscv.vsext.nxv4i32.nxv4i8(
    <vscale x 4 x i8> %0,
    i64 %1)

  ret <vscale x 4 x i32> %a
}

declare <vscale x 4 x i32> @llvm.riscv.vsext.mask.nxv4i32.nxv4i8(
  <vscale x 4 x i32>,
  <vscale x 4 x i8>,
  <vscale x 4 x i1>,
  i64);

define <vscale x 4 x i32> @intrinsic_vsext_mask_vf4_nxv4i32(<vscale x 4 x i1> %0, <vscale x 4 x i32> %1, <vscale x 4 x i8> %2, i64 %3) nounwind {
; CHECK-LABEL: intrinsic_vsext_mask_vf4_nxv4i32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32,m2,tu,mu
; CHECK-NEXT:    vsext.vf4 v8, v10, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x i32> @llvm.riscv.vsext.mask.nxv4i32.nxv4i8(
    <vscale x 4 x i32> %1,
    <vscale x 4 x i8> %2,
    <vscale x 4 x i1> %0,
    i64 %3)

  ret <vscale x 4 x i32> %a
}

declare <vscale x 8 x i32> @llvm.riscv.vsext.nxv8i32.nxv8i8(
  <vscale x 8 x i8>,
  i64);

define <vscale x 8 x i32> @intrinsic_vsext_vf4_nxv8i32(<vscale x 8 x i8> %0, i64 %1) nounwind {
; CHECK-LABEL: intrinsic_vsext_vf4_nxv8i32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32,m4,ta,mu
; CHECK-NEXT:    vsext.vf4 v28, v8
; CHECK-NEXT:    vmv4r.v v8, v28
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x i32> @llvm.riscv.vsext.nxv8i32.nxv8i8(
    <vscale x 8 x i8> %0,
    i64 %1)

  ret <vscale x 8 x i32> %a
}

declare <vscale x 8 x i32> @llvm.riscv.vsext.mask.nxv8i32.nxv8i8(
  <vscale x 8 x i32>,
  <vscale x 8 x i8>,
  <vscale x 8 x i1>,
  i64);

define <vscale x 8 x i32> @intrinsic_vsext_mask_vf4_nxv8i32(<vscale x 8 x i1> %0, <vscale x 8 x i32> %1, <vscale x 8 x i8> %2, i64 %3) nounwind {
; CHECK-LABEL: intrinsic_vsext_mask_vf4_nxv8i32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32,m4,tu,mu
; CHECK-NEXT:    vsext.vf4 v8, v12, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x i32> @llvm.riscv.vsext.mask.nxv8i32.nxv8i8(
    <vscale x 8 x i32> %1,
    <vscale x 8 x i8> %2,
    <vscale x 8 x i1> %0,
    i64 %3)

  ret <vscale x 8 x i32> %a
}

declare <vscale x 16 x i32> @llvm.riscv.vsext.nxv16i32.nxv16i8(
  <vscale x 16 x i8>,
  i64);

define <vscale x 16 x i32> @intrinsic_vsext_vf4_nxv16i32(<vscale x 16 x i8> %0, i64 %1) nounwind {
; CHECK-LABEL: intrinsic_vsext_vf4_nxv16i32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32,m8,ta,mu
; CHECK-NEXT:    vsext.vf4 v16, v8
; CHECK-NEXT:    vmv8r.v v8, v16
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 16 x i32> @llvm.riscv.vsext.nxv16i32.nxv16i8(
    <vscale x 16 x i8> %0,
    i64 %1)

  ret <vscale x 16 x i32> %a
}

declare <vscale x 16 x i32> @llvm.riscv.vsext.mask.nxv16i32.nxv16i8(
  <vscale x 16 x i32>,
  <vscale x 16 x i8>,
  <vscale x 16 x i1>,
  i64);

define <vscale x 16 x i32> @intrinsic_vsext_mask_vf4_nxv16i32(<vscale x 16 x i1> %0, <vscale x 16 x i32> %1, <vscale x 16 x i8> %2, i64 %3) nounwind {
; CHECK-LABEL: intrinsic_vsext_mask_vf4_nxv16i32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32,m8,tu,mu
; CHECK-NEXT:    vsext.vf4 v8, v16, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 16 x i32> @llvm.riscv.vsext.mask.nxv16i32.nxv16i8(
    <vscale x 16 x i32> %1,
    <vscale x 16 x i8> %2,
    <vscale x 16 x i1> %0,
    i64 %3)

  ret <vscale x 16 x i32> %a
}

declare <vscale x 1 x i64> @llvm.riscv.vsext.nxv1i64.nxv1i32(
  <vscale x 1 x i32>,
  i64);

define <vscale x 1 x i64> @intrinsic_vsext_vf2_nxv1i64(<vscale x 1 x i32> %0, i64 %1) nounwind {
; CHECK-LABEL: intrinsic_vsext_vf2_nxv1i64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e64,m1,ta,mu
; CHECK-NEXT:    vsext.vf2 v25, v8
; CHECK-NEXT:    vmv1r.v v8, v25
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x i64> @llvm.riscv.vsext.nxv1i64.nxv1i32(
    <vscale x 1 x i32> %0,
    i64 %1)

  ret <vscale x 1 x i64> %a
}

declare <vscale x 1 x i64> @llvm.riscv.vsext.mask.nxv1i64.nxv1i32(
  <vscale x 1 x i64>,
  <vscale x 1 x i32>,
  <vscale x 1 x i1>,
  i64);

define <vscale x 1 x i64> @intrinsic_vsext_mask_vf2_nxv1i64(<vscale x 1 x i1> %0, <vscale x 1 x i64> %1, <vscale x 1 x i32> %2, i64 %3) nounwind {
; CHECK-LABEL: intrinsic_vsext_mask_vf2_nxv1i64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e64,m1,tu,mu
; CHECK-NEXT:    vsext.vf2 v8, v9, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x i64> @llvm.riscv.vsext.mask.nxv1i64.nxv1i32(
    <vscale x 1 x i64> %1,
    <vscale x 1 x i32> %2,
    <vscale x 1 x i1> %0,
    i64 %3)

  ret <vscale x 1 x i64> %a
}

declare <vscale x 2 x i64> @llvm.riscv.vsext.nxv2i64.nxv2i32(
  <vscale x 2 x i32>,
  i64);

define <vscale x 2 x i64> @intrinsic_vsext_vf2_nxv2i64(<vscale x 2 x i32> %0, i64 %1) nounwind {
; CHECK-LABEL: intrinsic_vsext_vf2_nxv2i64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e64,m2,ta,mu
; CHECK-NEXT:    vsext.vf2 v26, v8
; CHECK-NEXT:    vmv2r.v v8, v26
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x i64> @llvm.riscv.vsext.nxv2i64.nxv2i32(
    <vscale x 2 x i32> %0,
    i64 %1)

  ret <vscale x 2 x i64> %a
}

declare <vscale x 2 x i64> @llvm.riscv.vsext.mask.nxv2i64.nxv2i32(
  <vscale x 2 x i64>,
  <vscale x 2 x i32>,
  <vscale x 2 x i1>,
  i64);

define <vscale x 2 x i64> @intrinsic_vsext_mask_vf2_nxv2i64(<vscale x 2 x i1> %0, <vscale x 2 x i64> %1, <vscale x 2 x i32> %2, i64 %3) nounwind {
; CHECK-LABEL: intrinsic_vsext_mask_vf2_nxv2i64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e64,m2,tu,mu
; CHECK-NEXT:    vsext.vf2 v8, v10, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x i64> @llvm.riscv.vsext.mask.nxv2i64.nxv2i32(
    <vscale x 2 x i64> %1,
    <vscale x 2 x i32> %2,
    <vscale x 2 x i1> %0,
    i64 %3)

  ret <vscale x 2 x i64> %a
}

declare <vscale x 4 x i64> @llvm.riscv.vsext.nxv4i64.nxv4i32(
  <vscale x 4 x i32>,
  i64);

define <vscale x 4 x i64> @intrinsic_vsext_vf2_nxv4i64(<vscale x 4 x i32> %0, i64 %1) nounwind {
; CHECK-LABEL: intrinsic_vsext_vf2_nxv4i64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e64,m4,ta,mu
; CHECK-NEXT:    vsext.vf2 v28, v8
; CHECK-NEXT:    vmv4r.v v8, v28
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x i64> @llvm.riscv.vsext.nxv4i64.nxv4i32(
    <vscale x 4 x i32> %0,
    i64 %1)

  ret <vscale x 4 x i64> %a
}

declare <vscale x 4 x i64> @llvm.riscv.vsext.mask.nxv4i64.nxv4i32(
  <vscale x 4 x i64>,
  <vscale x 4 x i32>,
  <vscale x 4 x i1>,
  i64);

define <vscale x 4 x i64> @intrinsic_vsext_mask_vf2_nxv4i64(<vscale x 4 x i1> %0, <vscale x 4 x i64> %1, <vscale x 4 x i32> %2, i64 %3) nounwind {
; CHECK-LABEL: intrinsic_vsext_mask_vf2_nxv4i64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e64,m4,tu,mu
; CHECK-NEXT:    vsext.vf2 v8, v12, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x i64> @llvm.riscv.vsext.mask.nxv4i64.nxv4i32(
    <vscale x 4 x i64> %1,
    <vscale x 4 x i32> %2,
    <vscale x 4 x i1> %0,
    i64 %3)

  ret <vscale x 4 x i64> %a
}

declare <vscale x 8 x i64> @llvm.riscv.vsext.nxv8i64.nxv8i32(
  <vscale x 8 x i32>,
  i64);

define <vscale x 8 x i64> @intrinsic_vsext_vf2_nxv8i64(<vscale x 8 x i32> %0, i64 %1) nounwind {
; CHECK-LABEL: intrinsic_vsext_vf2_nxv8i64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e64,m8,ta,mu
; CHECK-NEXT:    vsext.vf2 v16, v8
; CHECK-NEXT:    vmv8r.v v8, v16
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x i64> @llvm.riscv.vsext.nxv8i64.nxv8i32(
    <vscale x 8 x i32> %0,
    i64 %1)

  ret <vscale x 8 x i64> %a
}

declare <vscale x 8 x i64> @llvm.riscv.vsext.mask.nxv8i64.nxv8i32(
  <vscale x 8 x i64>,
  <vscale x 8 x i32>,
  <vscale x 8 x i1>,
  i64);

define <vscale x 8 x i64> @intrinsic_vsext_mask_vf2_nxv8i64(<vscale x 8 x i1> %0, <vscale x 8 x i64> %1, <vscale x 8 x i32> %2, i64 %3) nounwind {
; CHECK-LABEL: intrinsic_vsext_mask_vf2_nxv8i64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e64,m8,tu,mu
; CHECK-NEXT:    vsext.vf2 v8, v16, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x i64> @llvm.riscv.vsext.mask.nxv8i64.nxv8i32(
    <vscale x 8 x i64> %1,
    <vscale x 8 x i32> %2,
    <vscale x 8 x i1> %0,
    i64 %3)

  ret <vscale x 8 x i64> %a
}

declare <vscale x 1 x i32> @llvm.riscv.vsext.nxv1i32.nxv1i16(
  <vscale x 1 x i16>,
  i64);

define <vscale x 1 x i32> @intrinsic_vsext_vf2_nxv1i32(<vscale x 1 x i16> %0, i64 %1) nounwind {
; CHECK-LABEL: intrinsic_vsext_vf2_nxv1i32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32,mf2,ta,mu
; CHECK-NEXT:    vsext.vf2 v25, v8
; CHECK-NEXT:    vmv1r.v v8, v25
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x i32> @llvm.riscv.vsext.nxv1i32.nxv1i16(
    <vscale x 1 x i16> %0,
    i64 %1)

  ret <vscale x 1 x i32> %a
}

declare <vscale x 1 x i32> @llvm.riscv.vsext.mask.nxv1i32.nxv1i16(
  <vscale x 1 x i32>,
  <vscale x 1 x i16>,
  <vscale x 1 x i1>,
  i64);

define <vscale x 1 x i32> @intrinsic_vsext_mask_vf2_nxv1i32(<vscale x 1 x i1> %0, <vscale x 1 x i32> %1, <vscale x 1 x i16> %2, i64 %3) nounwind {
; CHECK-LABEL: intrinsic_vsext_mask_vf2_nxv1i32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32,mf2,tu,mu
; CHECK-NEXT:    vsext.vf2 v8, v9, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x i32> @llvm.riscv.vsext.mask.nxv1i32.nxv1i16(
    <vscale x 1 x i32> %1,
    <vscale x 1 x i16> %2,
    <vscale x 1 x i1> %0,
    i64 %3)

  ret <vscale x 1 x i32> %a
}

declare <vscale x 2 x i32> @llvm.riscv.vsext.nxv2i32.nxv2i16(
  <vscale x 2 x i16>,
  i64);

define <vscale x 2 x i32> @intrinsic_vsext_vf2_nxv2i32(<vscale x 2 x i16> %0, i64 %1) nounwind {
; CHECK-LABEL: intrinsic_vsext_vf2_nxv2i32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32,m1,ta,mu
; CHECK-NEXT:    vsext.vf2 v25, v8
; CHECK-NEXT:    vmv1r.v v8, v25
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x i32> @llvm.riscv.vsext.nxv2i32.nxv2i16(
    <vscale x 2 x i16> %0,
    i64 %1)

  ret <vscale x 2 x i32> %a
}

declare <vscale x 2 x i32> @llvm.riscv.vsext.mask.nxv2i32.nxv2i16(
  <vscale x 2 x i32>,
  <vscale x 2 x i16>,
  <vscale x 2 x i1>,
  i64);

define <vscale x 2 x i32> @intrinsic_vsext_mask_vf2_nxv2i32(<vscale x 2 x i1> %0, <vscale x 2 x i32> %1, <vscale x 2 x i16> %2, i64 %3) nounwind {
; CHECK-LABEL: intrinsic_vsext_mask_vf2_nxv2i32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32,m1,tu,mu
; CHECK-NEXT:    vsext.vf2 v8, v9, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x i32> @llvm.riscv.vsext.mask.nxv2i32.nxv2i16(
    <vscale x 2 x i32> %1,
    <vscale x 2 x i16> %2,
    <vscale x 2 x i1> %0,
    i64 %3)

  ret <vscale x 2 x i32> %a
}

declare <vscale x 4 x i32> @llvm.riscv.vsext.nxv4i32.nxv4i16(
  <vscale x 4 x i16>,
  i64);

define <vscale x 4 x i32> @intrinsic_vsext_vf2_nxv4i32(<vscale x 4 x i16> %0, i64 %1) nounwind {
; CHECK-LABEL: intrinsic_vsext_vf2_nxv4i32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32,m2,ta,mu
; CHECK-NEXT:    vsext.vf2 v26, v8
; CHECK-NEXT:    vmv2r.v v8, v26
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x i32> @llvm.riscv.vsext.nxv4i32.nxv4i16(
    <vscale x 4 x i16> %0,
    i64 %1)

  ret <vscale x 4 x i32> %a
}

declare <vscale x 4 x i32> @llvm.riscv.vsext.mask.nxv4i32.nxv4i16(
  <vscale x 4 x i32>,
  <vscale x 4 x i16>,
  <vscale x 4 x i1>,
  i64);

define <vscale x 4 x i32> @intrinsic_vsext_mask_vf2_nxv4i32(<vscale x 4 x i1> %0, <vscale x 4 x i32> %1, <vscale x 4 x i16> %2, i64 %3) nounwind {
; CHECK-LABEL: intrinsic_vsext_mask_vf2_nxv4i32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32,m2,tu,mu
; CHECK-NEXT:    vsext.vf2 v8, v10, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x i32> @llvm.riscv.vsext.mask.nxv4i32.nxv4i16(
    <vscale x 4 x i32> %1,
    <vscale x 4 x i16> %2,
    <vscale x 4 x i1> %0,
    i64 %3)

  ret <vscale x 4 x i32> %a
}

declare <vscale x 8 x i32> @llvm.riscv.vsext.nxv8i32.nxv8i16(
  <vscale x 8 x i16>,
  i64);

define <vscale x 8 x i32> @intrinsic_vsext_vf2_nxv8i32(<vscale x 8 x i16> %0, i64 %1) nounwind {
; CHECK-LABEL: intrinsic_vsext_vf2_nxv8i32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32,m4,ta,mu
; CHECK-NEXT:    vsext.vf2 v28, v8
; CHECK-NEXT:    vmv4r.v v8, v28
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x i32> @llvm.riscv.vsext.nxv8i32.nxv8i16(
    <vscale x 8 x i16> %0,
    i64 %1)

  ret <vscale x 8 x i32> %a
}

declare <vscale x 8 x i32> @llvm.riscv.vsext.mask.nxv8i32.nxv8i16(
  <vscale x 8 x i32>,
  <vscale x 8 x i16>,
  <vscale x 8 x i1>,
  i64);

define <vscale x 8 x i32> @intrinsic_vsext_mask_vf2_nxv8i32(<vscale x 8 x i1> %0, <vscale x 8 x i32> %1, <vscale x 8 x i16> %2, i64 %3) nounwind {
; CHECK-LABEL: intrinsic_vsext_mask_vf2_nxv8i32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32,m4,tu,mu
; CHECK-NEXT:    vsext.vf2 v8, v12, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x i32> @llvm.riscv.vsext.mask.nxv8i32.nxv8i16(
    <vscale x 8 x i32> %1,
    <vscale x 8 x i16> %2,
    <vscale x 8 x i1> %0,
    i64 %3)

  ret <vscale x 8 x i32> %a
}

declare <vscale x 16 x i32> @llvm.riscv.vsext.nxv16i32.nxv16i16(
  <vscale x 16 x i16>,
  i64);

define <vscale x 16 x i32> @intrinsic_vsext_vf2_nxv16i32(<vscale x 16 x i16> %0, i64 %1) nounwind {
; CHECK-LABEL: intrinsic_vsext_vf2_nxv16i32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32,m8,ta,mu
; CHECK-NEXT:    vsext.vf2 v16, v8
; CHECK-NEXT:    vmv8r.v v8, v16
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 16 x i32> @llvm.riscv.vsext.nxv16i32.nxv16i16(
    <vscale x 16 x i16> %0,
    i64 %1)

  ret <vscale x 16 x i32> %a
}

declare <vscale x 16 x i32> @llvm.riscv.vsext.mask.nxv16i32.nxv16i16(
  <vscale x 16 x i32>,
  <vscale x 16 x i16>,
  <vscale x 16 x i1>,
  i64);

define <vscale x 16 x i32> @intrinsic_vsext_mask_vf2_nxv16i32(<vscale x 16 x i1> %0, <vscale x 16 x i32> %1, <vscale x 16 x i16> %2, i64 %3) nounwind {
; CHECK-LABEL: intrinsic_vsext_mask_vf2_nxv16i32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32,m8,tu,mu
; CHECK-NEXT:    vsext.vf2 v8, v16, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 16 x i32> @llvm.riscv.vsext.mask.nxv16i32.nxv16i16(
    <vscale x 16 x i32> %1,
    <vscale x 16 x i16> %2,
    <vscale x 16 x i1> %0,
    i64 %3)

  ret <vscale x 16 x i32> %a
}

declare <vscale x 1 x i16> @llvm.riscv.vsext.nxv1i16.nxv1i8(
  <vscale x 1 x i8>,
  i64);

define <vscale x 1 x i16> @intrinsic_vsext_vf2_nxv1i16(<vscale x 1 x i8> %0, i64 %1) nounwind {
; CHECK-LABEL: intrinsic_vsext_vf2_nxv1i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16,mf4,ta,mu
; CHECK-NEXT:    vsext.vf2 v25, v8
; CHECK-NEXT:    vmv1r.v v8, v25
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x i16> @llvm.riscv.vsext.nxv1i16.nxv1i8(
    <vscale x 1 x i8> %0,
    i64 %1)

  ret <vscale x 1 x i16> %a
}

declare <vscale x 1 x i16> @llvm.riscv.vsext.mask.nxv1i16.nxv1i8(
  <vscale x 1 x i16>,
  <vscale x 1 x i8>,
  <vscale x 1 x i1>,
  i64);

define <vscale x 1 x i16> @intrinsic_vsext_mask_vf2_nxv1i16(<vscale x 1 x i1> %0, <vscale x 1 x i16> %1, <vscale x 1 x i8> %2, i64 %3) nounwind {
; CHECK-LABEL: intrinsic_vsext_mask_vf2_nxv1i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16,mf4,tu,mu
; CHECK-NEXT:    vsext.vf2 v8, v9, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 1 x i16> @llvm.riscv.vsext.mask.nxv1i16.nxv1i8(
    <vscale x 1 x i16> %1,
    <vscale x 1 x i8> %2,
    <vscale x 1 x i1> %0,
    i64 %3)

  ret <vscale x 1 x i16> %a
}

declare <vscale x 2 x i16> @llvm.riscv.vsext.nxv2i16.nxv2i8(
  <vscale x 2 x i8>,
  i64);

define <vscale x 2 x i16> @intrinsic_vsext_vf2_nxv2i16(<vscale x 2 x i8> %0, i64 %1) nounwind {
; CHECK-LABEL: intrinsic_vsext_vf2_nxv2i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16,mf2,ta,mu
; CHECK-NEXT:    vsext.vf2 v25, v8
; CHECK-NEXT:    vmv1r.v v8, v25
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x i16> @llvm.riscv.vsext.nxv2i16.nxv2i8(
    <vscale x 2 x i8> %0,
    i64 %1)

  ret <vscale x 2 x i16> %a
}

declare <vscale x 2 x i16> @llvm.riscv.vsext.mask.nxv2i16.nxv2i8(
  <vscale x 2 x i16>,
  <vscale x 2 x i8>,
  <vscale x 2 x i1>,
  i64);

define <vscale x 2 x i16> @intrinsic_vsext_mask_vf2_nxv2i16(<vscale x 2 x i1> %0, <vscale x 2 x i16> %1, <vscale x 2 x i8> %2, i64 %3) nounwind {
; CHECK-LABEL: intrinsic_vsext_mask_vf2_nxv2i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16,mf2,tu,mu
; CHECK-NEXT:    vsext.vf2 v8, v9, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 2 x i16> @llvm.riscv.vsext.mask.nxv2i16.nxv2i8(
    <vscale x 2 x i16> %1,
    <vscale x 2 x i8> %2,
    <vscale x 2 x i1> %0,
    i64 %3)

  ret <vscale x 2 x i16> %a
}

declare <vscale x 4 x i16> @llvm.riscv.vsext.nxv4i16.nxv4i8(
  <vscale x 4 x i8>,
  i64);

define <vscale x 4 x i16> @intrinsic_vsext_vf2_nxv4i16(<vscale x 4 x i8> %0, i64 %1) nounwind {
; CHECK-LABEL: intrinsic_vsext_vf2_nxv4i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16,m1,ta,mu
; CHECK-NEXT:    vsext.vf2 v25, v8
; CHECK-NEXT:    vmv1r.v v8, v25
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x i16> @llvm.riscv.vsext.nxv4i16.nxv4i8(
    <vscale x 4 x i8> %0,
    i64 %1)

  ret <vscale x 4 x i16> %a
}

declare <vscale x 4 x i16> @llvm.riscv.vsext.mask.nxv4i16.nxv4i8(
  <vscale x 4 x i16>,
  <vscale x 4 x i8>,
  <vscale x 4 x i1>,
  i64);

define <vscale x 4 x i16> @intrinsic_vsext_mask_vf2_nxv4i16(<vscale x 4 x i1> %0, <vscale x 4 x i16> %1, <vscale x 4 x i8> %2, i64 %3) nounwind {
; CHECK-LABEL: intrinsic_vsext_mask_vf2_nxv4i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16,m1,tu,mu
; CHECK-NEXT:    vsext.vf2 v8, v9, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 4 x i16> @llvm.riscv.vsext.mask.nxv4i16.nxv4i8(
    <vscale x 4 x i16> %1,
    <vscale x 4 x i8> %2,
    <vscale x 4 x i1> %0,
    i64 %3)

  ret <vscale x 4 x i16> %a
}

declare <vscale x 8 x i16> @llvm.riscv.vsext.nxv8i16.nxv8i8(
  <vscale x 8 x i8>,
  i64);

define <vscale x 8 x i16> @intrinsic_vsext_vf2_nxv8i16(<vscale x 8 x i8> %0, i64 %1) nounwind {
; CHECK-LABEL: intrinsic_vsext_vf2_nxv8i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16,m2,ta,mu
; CHECK-NEXT:    vsext.vf2 v26, v8
; CHECK-NEXT:    vmv2r.v v8, v26
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x i16> @llvm.riscv.vsext.nxv8i16.nxv8i8(
    <vscale x 8 x i8> %0,
    i64 %1)

  ret <vscale x 8 x i16> %a
}

declare <vscale x 8 x i16> @llvm.riscv.vsext.mask.nxv8i16.nxv8i8(
  <vscale x 8 x i16>,
  <vscale x 8 x i8>,
  <vscale x 8 x i1>,
  i64);

define <vscale x 8 x i16> @intrinsic_vsext_mask_vf2_nxv8i16(<vscale x 8 x i1> %0, <vscale x 8 x i16> %1, <vscale x 8 x i8> %2, i64 %3) nounwind {
; CHECK-LABEL: intrinsic_vsext_mask_vf2_nxv8i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16,m2,tu,mu
; CHECK-NEXT:    vsext.vf2 v8, v10, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 8 x i16> @llvm.riscv.vsext.mask.nxv8i16.nxv8i8(
    <vscale x 8 x i16> %1,
    <vscale x 8 x i8> %2,
    <vscale x 8 x i1> %0,
    i64 %3)

  ret <vscale x 8 x i16> %a
}

declare <vscale x 16 x i16> @llvm.riscv.vsext.nxv16i16.nxv16i8(
  <vscale x 16 x i8>,
  i64);

define <vscale x 16 x i16> @intrinsic_vsext_vf2_nxv16i16(<vscale x 16 x i8> %0, i64 %1) nounwind {
; CHECK-LABEL: intrinsic_vsext_vf2_nxv16i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16,m4,ta,mu
; CHECK-NEXT:    vsext.vf2 v28, v8
; CHECK-NEXT:    vmv4r.v v8, v28
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 16 x i16> @llvm.riscv.vsext.nxv16i16.nxv16i8(
    <vscale x 16 x i8> %0,
    i64 %1)

  ret <vscale x 16 x i16> %a
}

declare <vscale x 16 x i16> @llvm.riscv.vsext.mask.nxv16i16.nxv16i8(
  <vscale x 16 x i16>,
  <vscale x 16 x i8>,
  <vscale x 16 x i1>,
  i64);

define <vscale x 16 x i16> @intrinsic_vsext_mask_vf2_nxv16i16(<vscale x 16 x i1> %0, <vscale x 16 x i16> %1, <vscale x 16 x i8> %2, i64 %3) nounwind {
; CHECK-LABEL: intrinsic_vsext_mask_vf2_nxv16i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16,m4,tu,mu
; CHECK-NEXT:    vsext.vf2 v8, v12, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 16 x i16> @llvm.riscv.vsext.mask.nxv16i16.nxv16i8(
    <vscale x 16 x i16> %1,
    <vscale x 16 x i8> %2,
    <vscale x 16 x i1> %0,
    i64 %3)

  ret <vscale x 16 x i16> %a
}

declare <vscale x 32 x i16> @llvm.riscv.vsext.nxv32i16.nxv32i8(
  <vscale x 32 x i8>,
  i64);

define <vscale x 32 x i16> @intrinsic_vsext_vf2_nxv32i16(<vscale x 32 x i8> %0, i64 %1) nounwind {
; CHECK-LABEL: intrinsic_vsext_vf2_nxv32i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16,m8,ta,mu
; CHECK-NEXT:    vsext.vf2 v16, v8
; CHECK-NEXT:    vmv8r.v v8, v16
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 32 x i16> @llvm.riscv.vsext.nxv32i16.nxv32i8(
    <vscale x 32 x i8> %0,
    i64 %1)

  ret <vscale x 32 x i16> %a
}

declare <vscale x 32 x i16> @llvm.riscv.vsext.mask.nxv32i16.nxv32i8(
  <vscale x 32 x i16>,
  <vscale x 32 x i8>,
  <vscale x 32 x i1>,
  i64);

define <vscale x 32 x i16> @intrinsic_vsext_mask_vf2_nxv32i16(<vscale x 32 x i1> %0, <vscale x 32 x i16> %1, <vscale x 32 x i8> %2, i64 %3) nounwind {
; CHECK-LABEL: intrinsic_vsext_mask_vf2_nxv32i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e16,m8,tu,mu
; CHECK-NEXT:    vsext.vf2 v8, v16, v0.t
; CHECK-NEXT:    ret
entry:
  %a = call <vscale x 32 x i16> @llvm.riscv.vsext.mask.nxv32i16.nxv32i8(
    <vscale x 32 x i16> %1,
    <vscale x 32 x i8> %2,
    <vscale x 32 x i1> %0,
    i64 %3)

  ret <vscale x 32 x i16> %a
}
