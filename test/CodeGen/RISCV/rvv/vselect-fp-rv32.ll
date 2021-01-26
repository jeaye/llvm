; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+d,+experimental-zfh,+experimental-v -target-abi=ilp32d \
; RUN:     -verify-machineinstrs < %s | FileCheck %s

define <vscale x 1 x half> @vfmerge_vv_nxv1f16(<vscale x 1 x half> %va, <vscale x 1 x half> %vb, <vscale x 1 x i1> %cond) {
; CHECK-LABEL: vfmerge_vv_nxv1f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16,mf4,ta,mu
; CHECK-NEXT:    vmerge.vvm v8, v9, v8, v0
; CHECK-NEXT:    ret
  %vc = select <vscale x 1 x i1> %cond, <vscale x 1 x half> %va, <vscale x 1 x half> %vb
  ret <vscale x 1 x half> %vc
}

define <vscale x 1 x half> @vfmerge_fv_nxv1f16(<vscale x 1 x half> %va, half %b, <vscale x 1 x i1> %cond) {
; CHECK-LABEL: vfmerge_fv_nxv1f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16,mf4,ta,mu
; CHECK-NEXT:    vfmerge.vfm v8, v8, fa0, v0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 1 x half> undef, half %b, i32 0
  %splat = shufflevector <vscale x 1 x half> %head, <vscale x 1 x half> undef, <vscale x 1 x i32> zeroinitializer
  %vc = select <vscale x 1 x i1> %cond, <vscale x 1 x half> %splat, <vscale x 1 x half> %va
  ret <vscale x 1 x half> %vc
}

define <vscale x 2 x half> @vfmerge_vv_nxv2f16(<vscale x 2 x half> %va, <vscale x 2 x half> %vb, <vscale x 2 x i1> %cond) {
; CHECK-LABEL: vfmerge_vv_nxv2f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16,mf2,ta,mu
; CHECK-NEXT:    vmerge.vvm v8, v9, v8, v0
; CHECK-NEXT:    ret
  %vc = select <vscale x 2 x i1> %cond, <vscale x 2 x half> %va, <vscale x 2 x half> %vb
  ret <vscale x 2 x half> %vc
}

define <vscale x 2 x half> @vfmerge_fv_nxv2f16(<vscale x 2 x half> %va, half %b, <vscale x 2 x i1> %cond) {
; CHECK-LABEL: vfmerge_fv_nxv2f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16,mf2,ta,mu
; CHECK-NEXT:    vfmerge.vfm v8, v8, fa0, v0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 2 x half> undef, half %b, i32 0
  %splat = shufflevector <vscale x 2 x half> %head, <vscale x 2 x half> undef, <vscale x 2 x i32> zeroinitializer
  %vc = select <vscale x 2 x i1> %cond, <vscale x 2 x half> %splat, <vscale x 2 x half> %va
  ret <vscale x 2 x half> %vc
}

define <vscale x 4 x half> @vfmerge_vv_nxv4f16(<vscale x 4 x half> %va, <vscale x 4 x half> %vb, <vscale x 4 x i1> %cond) {
; CHECK-LABEL: vfmerge_vv_nxv4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16,m1,ta,mu
; CHECK-NEXT:    vmerge.vvm v8, v9, v8, v0
; CHECK-NEXT:    ret
  %vc = select <vscale x 4 x i1> %cond, <vscale x 4 x half> %va, <vscale x 4 x half> %vb
  ret <vscale x 4 x half> %vc
}

define <vscale x 4 x half> @vfmerge_fv_nxv4f16(<vscale x 4 x half> %va, half %b, <vscale x 4 x i1> %cond) {
; CHECK-LABEL: vfmerge_fv_nxv4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16,m1,ta,mu
; CHECK-NEXT:    vfmerge.vfm v8, v8, fa0, v0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 4 x half> undef, half %b, i32 0
  %splat = shufflevector <vscale x 4 x half> %head, <vscale x 4 x half> undef, <vscale x 4 x i32> zeroinitializer
  %vc = select <vscale x 4 x i1> %cond, <vscale x 4 x half> %splat, <vscale x 4 x half> %va
  ret <vscale x 4 x half> %vc
}

define <vscale x 8 x half> @vfmerge_vv_nxv8f16(<vscale x 8 x half> %va, <vscale x 8 x half> %vb, <vscale x 8 x i1> %cond) {
; CHECK-LABEL: vfmerge_vv_nxv8f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16,m2,ta,mu
; CHECK-NEXT:    vmerge.vvm v8, v10, v8, v0
; CHECK-NEXT:    ret
  %vc = select <vscale x 8 x i1> %cond, <vscale x 8 x half> %va, <vscale x 8 x half> %vb
  ret <vscale x 8 x half> %vc
}

define <vscale x 8 x half> @vfmerge_fv_nxv8f16(<vscale x 8 x half> %va, half %b, <vscale x 8 x i1> %cond) {
; CHECK-LABEL: vfmerge_fv_nxv8f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16,m2,ta,mu
; CHECK-NEXT:    vfmerge.vfm v8, v8, fa0, v0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x half> undef, half %b, i32 0
  %splat = shufflevector <vscale x 8 x half> %head, <vscale x 8 x half> undef, <vscale x 8 x i32> zeroinitializer
  %vc = select <vscale x 8 x i1> %cond, <vscale x 8 x half> %splat, <vscale x 8 x half> %va
  ret <vscale x 8 x half> %vc
}

define <vscale x 8 x half> @vfmerge_zv_nxv8f16(<vscale x 8 x half> %va, <vscale x 8 x i1> %cond) {
; CHECK-LABEL: vfmerge_zv_nxv8f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16,m2,ta,mu
; CHECK-NEXT:    vmerge.vim v8, v8, 0, v0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x half> undef, half zeroinitializer, i32 0
  %splat = shufflevector <vscale x 8 x half> %head, <vscale x 8 x half> undef, <vscale x 8 x i32> zeroinitializer
  %vc = select <vscale x 8 x i1> %cond, <vscale x 8 x half> %splat, <vscale x 8 x half> %va
  ret <vscale x 8 x half> %vc
}

define <vscale x 16 x half> @vfmerge_vv_nxv16f16(<vscale x 16 x half> %va, <vscale x 16 x half> %vb, <vscale x 16 x i1> %cond) {
; CHECK-LABEL: vfmerge_vv_nxv16f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16,m4,ta,mu
; CHECK-NEXT:    vmerge.vvm v8, v12, v8, v0
; CHECK-NEXT:    ret
  %vc = select <vscale x 16 x i1> %cond, <vscale x 16 x half> %va, <vscale x 16 x half> %vb
  ret <vscale x 16 x half> %vc
}

define <vscale x 16 x half> @vfmerge_fv_nxv16f16(<vscale x 16 x half> %va, half %b, <vscale x 16 x i1> %cond) {
; CHECK-LABEL: vfmerge_fv_nxv16f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16,m4,ta,mu
; CHECK-NEXT:    vfmerge.vfm v8, v8, fa0, v0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 16 x half> undef, half %b, i32 0
  %splat = shufflevector <vscale x 16 x half> %head, <vscale x 16 x half> undef, <vscale x 16 x i32> zeroinitializer
  %vc = select <vscale x 16 x i1> %cond, <vscale x 16 x half> %splat, <vscale x 16 x half> %va
  ret <vscale x 16 x half> %vc
}

define <vscale x 32 x half> @vfmerge_vv_nxv32f16(<vscale x 32 x half> %va, <vscale x 32 x half> %vb, <vscale x 32 x i1> %cond) {
; CHECK-LABEL: vfmerge_vv_nxv32f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16,m8,ta,mu
; CHECK-NEXT:    vmerge.vvm v8, v16, v8, v0
; CHECK-NEXT:    ret
  %vc = select <vscale x 32 x i1> %cond, <vscale x 32 x half> %va, <vscale x 32 x half> %vb
  ret <vscale x 32 x half> %vc
}

define <vscale x 32 x half> @vfmerge_fv_nxv32f16(<vscale x 32 x half> %va, half %b, <vscale x 32 x i1> %cond) {
; CHECK-LABEL: vfmerge_fv_nxv32f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16,m8,ta,mu
; CHECK-NEXT:    vfmerge.vfm v8, v8, fa0, v0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 32 x half> undef, half %b, i32 0
  %splat = shufflevector <vscale x 32 x half> %head, <vscale x 32 x half> undef, <vscale x 32 x i32> zeroinitializer
  %vc = select <vscale x 32 x i1> %cond, <vscale x 32 x half> %splat, <vscale x 32 x half> %va
  ret <vscale x 32 x half> %vc
}

define <vscale x 1 x float> @vfmerge_vv_nxv1f32(<vscale x 1 x float> %va, <vscale x 1 x float> %vb, <vscale x 1 x i1> %cond) {
; CHECK-LABEL: vfmerge_vv_nxv1f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,mf2,ta,mu
; CHECK-NEXT:    vmerge.vvm v8, v9, v8, v0
; CHECK-NEXT:    ret
  %vc = select <vscale x 1 x i1> %cond, <vscale x 1 x float> %va, <vscale x 1 x float> %vb
  ret <vscale x 1 x float> %vc
}

define <vscale x 1 x float> @vfmerge_fv_nxv1f32(<vscale x 1 x float> %va, float %b, <vscale x 1 x i1> %cond) {
; CHECK-LABEL: vfmerge_fv_nxv1f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,mf2,ta,mu
; CHECK-NEXT:    vfmerge.vfm v8, v8, fa0, v0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 1 x float> undef, float %b, i32 0
  %splat = shufflevector <vscale x 1 x float> %head, <vscale x 1 x float> undef, <vscale x 1 x i32> zeroinitializer
  %vc = select <vscale x 1 x i1> %cond, <vscale x 1 x float> %splat, <vscale x 1 x float> %va
  ret <vscale x 1 x float> %vc
}

define <vscale x 2 x float> @vfmerge_vv_nxv2f32(<vscale x 2 x float> %va, <vscale x 2 x float> %vb, <vscale x 2 x i1> %cond) {
; CHECK-LABEL: vfmerge_vv_nxv2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,m1,ta,mu
; CHECK-NEXT:    vmerge.vvm v8, v9, v8, v0
; CHECK-NEXT:    ret
  %vc = select <vscale x 2 x i1> %cond, <vscale x 2 x float> %va, <vscale x 2 x float> %vb
  ret <vscale x 2 x float> %vc
}

define <vscale x 2 x float> @vfmerge_fv_nxv2f32(<vscale x 2 x float> %va, float %b, <vscale x 2 x i1> %cond) {
; CHECK-LABEL: vfmerge_fv_nxv2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,m1,ta,mu
; CHECK-NEXT:    vfmerge.vfm v8, v8, fa0, v0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 2 x float> undef, float %b, i32 0
  %splat = shufflevector <vscale x 2 x float> %head, <vscale x 2 x float> undef, <vscale x 2 x i32> zeroinitializer
  %vc = select <vscale x 2 x i1> %cond, <vscale x 2 x float> %splat, <vscale x 2 x float> %va
  ret <vscale x 2 x float> %vc
}

define <vscale x 4 x float> @vfmerge_vv_nxv4f32(<vscale x 4 x float> %va, <vscale x 4 x float> %vb, <vscale x 4 x i1> %cond) {
; CHECK-LABEL: vfmerge_vv_nxv4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,m2,ta,mu
; CHECK-NEXT:    vmerge.vvm v8, v10, v8, v0
; CHECK-NEXT:    ret
  %vc = select <vscale x 4 x i1> %cond, <vscale x 4 x float> %va, <vscale x 4 x float> %vb
  ret <vscale x 4 x float> %vc
}

define <vscale x 4 x float> @vfmerge_fv_nxv4f32(<vscale x 4 x float> %va, float %b, <vscale x 4 x i1> %cond) {
; CHECK-LABEL: vfmerge_fv_nxv4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,m2,ta,mu
; CHECK-NEXT:    vfmerge.vfm v8, v8, fa0, v0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 4 x float> undef, float %b, i32 0
  %splat = shufflevector <vscale x 4 x float> %head, <vscale x 4 x float> undef, <vscale x 4 x i32> zeroinitializer
  %vc = select <vscale x 4 x i1> %cond, <vscale x 4 x float> %splat, <vscale x 4 x float> %va
  ret <vscale x 4 x float> %vc
}

define <vscale x 8 x float> @vfmerge_vv_nxv8f32(<vscale x 8 x float> %va, <vscale x 8 x float> %vb, <vscale x 8 x i1> %cond) {
; CHECK-LABEL: vfmerge_vv_nxv8f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,m4,ta,mu
; CHECK-NEXT:    vmerge.vvm v8, v12, v8, v0
; CHECK-NEXT:    ret
  %vc = select <vscale x 8 x i1> %cond, <vscale x 8 x float> %va, <vscale x 8 x float> %vb
  ret <vscale x 8 x float> %vc
}

define <vscale x 8 x float> @vfmerge_fv_nxv8f32(<vscale x 8 x float> %va, float %b, <vscale x 8 x i1> %cond) {
; CHECK-LABEL: vfmerge_fv_nxv8f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,m4,ta,mu
; CHECK-NEXT:    vfmerge.vfm v8, v8, fa0, v0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x float> undef, float %b, i32 0
  %splat = shufflevector <vscale x 8 x float> %head, <vscale x 8 x float> undef, <vscale x 8 x i32> zeroinitializer
  %vc = select <vscale x 8 x i1> %cond, <vscale x 8 x float> %splat, <vscale x 8 x float> %va
  ret <vscale x 8 x float> %vc
}

define <vscale x 8 x float> @vfmerge_zv_nxv8f32(<vscale x 8 x float> %va, <vscale x 8 x i1> %cond) {
; CHECK-LABEL: vfmerge_zv_nxv8f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,m4,ta,mu
; CHECK-NEXT:    vmerge.vim v8, v8, 0, v0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x float> undef, float zeroinitializer, i32 0
  %splat = shufflevector <vscale x 8 x float> %head, <vscale x 8 x float> undef, <vscale x 8 x i32> zeroinitializer
  %vc = select <vscale x 8 x i1> %cond, <vscale x 8 x float> %splat, <vscale x 8 x float> %va
  ret <vscale x 8 x float> %vc
}

define <vscale x 16 x float> @vfmerge_vv_nxv16f32(<vscale x 16 x float> %va, <vscale x 16 x float> %vb, <vscale x 16 x i1> %cond) {
; CHECK-LABEL: vfmerge_vv_nxv16f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,m8,ta,mu
; CHECK-NEXT:    vmerge.vvm v8, v16, v8, v0
; CHECK-NEXT:    ret
  %vc = select <vscale x 16 x i1> %cond, <vscale x 16 x float> %va, <vscale x 16 x float> %vb
  ret <vscale x 16 x float> %vc
}

define <vscale x 16 x float> @vfmerge_fv_nxv16f32(<vscale x 16 x float> %va, float %b, <vscale x 16 x i1> %cond) {
; CHECK-LABEL: vfmerge_fv_nxv16f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,m8,ta,mu
; CHECK-NEXT:    vfmerge.vfm v8, v8, fa0, v0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 16 x float> undef, float %b, i32 0
  %splat = shufflevector <vscale x 16 x float> %head, <vscale x 16 x float> undef, <vscale x 16 x i32> zeroinitializer
  %vc = select <vscale x 16 x i1> %cond, <vscale x 16 x float> %splat, <vscale x 16 x float> %va
  ret <vscale x 16 x float> %vc
}

define <vscale x 1 x double> @vfmerge_vv_nxv1f64(<vscale x 1 x double> %va, <vscale x 1 x double> %vb, <vscale x 1 x i1> %cond) {
; CHECK-LABEL: vfmerge_vv_nxv1f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64,m1,ta,mu
; CHECK-NEXT:    vmerge.vvm v8, v9, v8, v0
; CHECK-NEXT:    ret
  %vc = select <vscale x 1 x i1> %cond, <vscale x 1 x double> %va, <vscale x 1 x double> %vb
  ret <vscale x 1 x double> %vc
}

define <vscale x 1 x double> @vfmerge_fv_nxv1f64(<vscale x 1 x double> %va, double %b, <vscale x 1 x i1> %cond) {
; CHECK-LABEL: vfmerge_fv_nxv1f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64,m1,ta,mu
; CHECK-NEXT:    vfmerge.vfm v8, v8, fa0, v0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 1 x double> undef, double %b, i32 0
  %splat = shufflevector <vscale x 1 x double> %head, <vscale x 1 x double> undef, <vscale x 1 x i32> zeroinitializer
  %vc = select <vscale x 1 x i1> %cond, <vscale x 1 x double> %splat, <vscale x 1 x double> %va
  ret <vscale x 1 x double> %vc
}

define <vscale x 2 x double> @vfmerge_vv_nxv2f64(<vscale x 2 x double> %va, <vscale x 2 x double> %vb, <vscale x 2 x i1> %cond) {
; CHECK-LABEL: vfmerge_vv_nxv2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64,m2,ta,mu
; CHECK-NEXT:    vmerge.vvm v8, v10, v8, v0
; CHECK-NEXT:    ret
  %vc = select <vscale x 2 x i1> %cond, <vscale x 2 x double> %va, <vscale x 2 x double> %vb
  ret <vscale x 2 x double> %vc
}

define <vscale x 2 x double> @vfmerge_fv_nxv2f64(<vscale x 2 x double> %va, double %b, <vscale x 2 x i1> %cond) {
; CHECK-LABEL: vfmerge_fv_nxv2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64,m2,ta,mu
; CHECK-NEXT:    vfmerge.vfm v8, v8, fa0, v0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 2 x double> undef, double %b, i32 0
  %splat = shufflevector <vscale x 2 x double> %head, <vscale x 2 x double> undef, <vscale x 2 x i32> zeroinitializer
  %vc = select <vscale x 2 x i1> %cond, <vscale x 2 x double> %splat, <vscale x 2 x double> %va
  ret <vscale x 2 x double> %vc
}

define <vscale x 4 x double> @vfmerge_vv_nxv4f64(<vscale x 4 x double> %va, <vscale x 4 x double> %vb, <vscale x 4 x i1> %cond) {
; CHECK-LABEL: vfmerge_vv_nxv4f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64,m4,ta,mu
; CHECK-NEXT:    vmerge.vvm v8, v12, v8, v0
; CHECK-NEXT:    ret
  %vc = select <vscale x 4 x i1> %cond, <vscale x 4 x double> %va, <vscale x 4 x double> %vb
  ret <vscale x 4 x double> %vc
}

define <vscale x 4 x double> @vfmerge_fv_nxv4f64(<vscale x 4 x double> %va, double %b, <vscale x 4 x i1> %cond) {
; CHECK-LABEL: vfmerge_fv_nxv4f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64,m4,ta,mu
; CHECK-NEXT:    vfmerge.vfm v8, v8, fa0, v0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 4 x double> undef, double %b, i32 0
  %splat = shufflevector <vscale x 4 x double> %head, <vscale x 4 x double> undef, <vscale x 4 x i32> zeroinitializer
  %vc = select <vscale x 4 x i1> %cond, <vscale x 4 x double> %splat, <vscale x 4 x double> %va
  ret <vscale x 4 x double> %vc
}

define <vscale x 8 x double> @vfmerge_vv_nxv8f64(<vscale x 8 x double> %va, <vscale x 8 x double> %vb, <vscale x 8 x i1> %cond) {
; CHECK-LABEL: vfmerge_vv_nxv8f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64,m8,ta,mu
; CHECK-NEXT:    vmerge.vvm v8, v16, v8, v0
; CHECK-NEXT:    ret
  %vc = select <vscale x 8 x i1> %cond, <vscale x 8 x double> %va, <vscale x 8 x double> %vb
  ret <vscale x 8 x double> %vc
}

define <vscale x 8 x double> @vfmerge_fv_nxv8f64(<vscale x 8 x double> %va, double %b, <vscale x 8 x i1> %cond) {
; CHECK-LABEL: vfmerge_fv_nxv8f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64,m8,ta,mu
; CHECK-NEXT:    vfmerge.vfm v8, v8, fa0, v0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x double> undef, double %b, i32 0
  %splat = shufflevector <vscale x 8 x double> %head, <vscale x 8 x double> undef, <vscale x 8 x i32> zeroinitializer
  %vc = select <vscale x 8 x i1> %cond, <vscale x 8 x double> %splat, <vscale x 8 x double> %va
  ret <vscale x 8 x double> %vc
}

define <vscale x 8 x double> @vfmerge_zv_nxv8f64(<vscale x 8 x double> %va, <vscale x 8 x i1> %cond) {
; CHECK-LABEL: vfmerge_zv_nxv8f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64,m8,ta,mu
; CHECK-NEXT:    vmerge.vim v8, v8, 0, v0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x double> undef, double zeroinitializer, i32 0
  %splat = shufflevector <vscale x 8 x double> %head, <vscale x 8 x double> undef, <vscale x 8 x i32> zeroinitializer
  %vc = select <vscale x 8 x i1> %cond, <vscale x 8 x double> %splat, <vscale x 8 x double> %va
  ret <vscale x 8 x double> %vc
}

