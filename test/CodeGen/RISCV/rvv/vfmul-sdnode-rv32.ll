; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+d,+experimental-zfh,+experimental-v -target-abi=ilp32d \
; RUN:     -verify-machineinstrs < %s | FileCheck %s

define <vscale x 1 x half> @vfmul_vv_nxv1f16(<vscale x 1 x half> %va, <vscale x 1 x half> %vb) {
; CHECK-LABEL: vfmul_vv_nxv1f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16,mf4,ta,mu
; CHECK-NEXT:    vfmul.vv v8, v8, v9
; CHECK-NEXT:    ret
  %vc = fmul <vscale x 1 x half> %va, %vb
  ret <vscale x 1 x half> %vc
}

define <vscale x 1 x half> @vfmul_vf_nxv1f16(<vscale x 1 x half> %va, half %b) {
; CHECK-LABEL: vfmul_vf_nxv1f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16,mf4,ta,mu
; CHECK-NEXT:    vfmul.vf v8, v8, fa0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 1 x half> undef, half %b, i32 0
  %splat = shufflevector <vscale x 1 x half> %head, <vscale x 1 x half> undef, <vscale x 1 x i32> zeroinitializer
  %vc = fmul <vscale x 1 x half> %va, %splat
  ret <vscale x 1 x half> %vc
}

define <vscale x 2 x half> @vfmul_vv_nxv2f16(<vscale x 2 x half> %va, <vscale x 2 x half> %vb) {
; CHECK-LABEL: vfmul_vv_nxv2f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16,mf2,ta,mu
; CHECK-NEXT:    vfmul.vv v8, v8, v9
; CHECK-NEXT:    ret
  %vc = fmul <vscale x 2 x half> %va, %vb
  ret <vscale x 2 x half> %vc
}

define <vscale x 2 x half> @vfmul_vf_nxv2f16(<vscale x 2 x half> %va, half %b) {
; CHECK-LABEL: vfmul_vf_nxv2f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16,mf2,ta,mu
; CHECK-NEXT:    vfmul.vf v8, v8, fa0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 2 x half> undef, half %b, i32 0
  %splat = shufflevector <vscale x 2 x half> %head, <vscale x 2 x half> undef, <vscale x 2 x i32> zeroinitializer
  %vc = fmul <vscale x 2 x half> %va, %splat
  ret <vscale x 2 x half> %vc
}

define <vscale x 4 x half> @vfmul_vv_nxv4f16(<vscale x 4 x half> %va, <vscale x 4 x half> %vb) {
; CHECK-LABEL: vfmul_vv_nxv4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16,m1,ta,mu
; CHECK-NEXT:    vfmul.vv v8, v8, v9
; CHECK-NEXT:    ret
  %vc = fmul <vscale x 4 x half> %va, %vb
  ret <vscale x 4 x half> %vc
}

define <vscale x 4 x half> @vfmul_vf_nxv4f16(<vscale x 4 x half> %va, half %b) {
; CHECK-LABEL: vfmul_vf_nxv4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16,m1,ta,mu
; CHECK-NEXT:    vfmul.vf v8, v8, fa0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 4 x half> undef, half %b, i32 0
  %splat = shufflevector <vscale x 4 x half> %head, <vscale x 4 x half> undef, <vscale x 4 x i32> zeroinitializer
  %vc = fmul <vscale x 4 x half> %va, %splat
  ret <vscale x 4 x half> %vc
}

define <vscale x 8 x half> @vfmul_vv_nxv8f16(<vscale x 8 x half> %va, <vscale x 8 x half> %vb) {
; CHECK-LABEL: vfmul_vv_nxv8f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16,m2,ta,mu
; CHECK-NEXT:    vfmul.vv v8, v8, v10
; CHECK-NEXT:    ret
  %vc = fmul <vscale x 8 x half> %va, %vb
  ret <vscale x 8 x half> %vc
}

define <vscale x 8 x half> @vfmul_vf_nxv8f16(<vscale x 8 x half> %va, half %b) {
; CHECK-LABEL: vfmul_vf_nxv8f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16,m2,ta,mu
; CHECK-NEXT:    vfmul.vf v8, v8, fa0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x half> undef, half %b, i32 0
  %splat = shufflevector <vscale x 8 x half> %head, <vscale x 8 x half> undef, <vscale x 8 x i32> zeroinitializer
  %vc = fmul <vscale x 8 x half> %va, %splat
  ret <vscale x 8 x half> %vc
}

define <vscale x 8 x half> @vfmul_fv_nxv8f16(<vscale x 8 x half> %va, half %b) {
; CHECK-LABEL: vfmul_fv_nxv8f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16,m2,ta,mu
; CHECK-NEXT:    vfmul.vf v8, v8, fa0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x half> undef, half %b, i32 0
  %splat = shufflevector <vscale x 8 x half> %head, <vscale x 8 x half> undef, <vscale x 8 x i32> zeroinitializer
  %vc = fmul <vscale x 8 x half> %splat, %va
  ret <vscale x 8 x half> %vc
}

define <vscale x 16 x half> @vfmul_vv_nxv16f16(<vscale x 16 x half> %va, <vscale x 16 x half> %vb) {
; CHECK-LABEL: vfmul_vv_nxv16f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16,m4,ta,mu
; CHECK-NEXT:    vfmul.vv v8, v8, v12
; CHECK-NEXT:    ret
  %vc = fmul <vscale x 16 x half> %va, %vb
  ret <vscale x 16 x half> %vc
}

define <vscale x 16 x half> @vfmul_vf_nxv16f16(<vscale x 16 x half> %va, half %b) {
; CHECK-LABEL: vfmul_vf_nxv16f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16,m4,ta,mu
; CHECK-NEXT:    vfmul.vf v8, v8, fa0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 16 x half> undef, half %b, i32 0
  %splat = shufflevector <vscale x 16 x half> %head, <vscale x 16 x half> undef, <vscale x 16 x i32> zeroinitializer
  %vc = fmul <vscale x 16 x half> %va, %splat
  ret <vscale x 16 x half> %vc
}

define <vscale x 32 x half> @vfmul_vv_nxv32f16(<vscale x 32 x half> %va, <vscale x 32 x half> %vb) {
; CHECK-LABEL: vfmul_vv_nxv32f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16,m8,ta,mu
; CHECK-NEXT:    vfmul.vv v8, v8, v16
; CHECK-NEXT:    ret
  %vc = fmul <vscale x 32 x half> %va, %vb
  ret <vscale x 32 x half> %vc
}

define <vscale x 32 x half> @vfmul_vf_nxv32f16(<vscale x 32 x half> %va, half %b) {
; CHECK-LABEL: vfmul_vf_nxv32f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16,m8,ta,mu
; CHECK-NEXT:    vfmul.vf v8, v8, fa0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 32 x half> undef, half %b, i32 0
  %splat = shufflevector <vscale x 32 x half> %head, <vscale x 32 x half> undef, <vscale x 32 x i32> zeroinitializer
  %vc = fmul <vscale x 32 x half> %va, %splat
  ret <vscale x 32 x half> %vc
}

define <vscale x 1 x float> @vfmul_vv_nxv1f32(<vscale x 1 x float> %va, <vscale x 1 x float> %vb) {
; CHECK-LABEL: vfmul_vv_nxv1f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,mf2,ta,mu
; CHECK-NEXT:    vfmul.vv v8, v8, v9
; CHECK-NEXT:    ret
  %vc = fmul <vscale x 1 x float> %va, %vb
  ret <vscale x 1 x float> %vc
}

define <vscale x 1 x float> @vfmul_vf_nxv1f32(<vscale x 1 x float> %va, float %b) {
; CHECK-LABEL: vfmul_vf_nxv1f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,mf2,ta,mu
; CHECK-NEXT:    vfmul.vf v8, v8, fa0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 1 x float> undef, float %b, i32 0
  %splat = shufflevector <vscale x 1 x float> %head, <vscale x 1 x float> undef, <vscale x 1 x i32> zeroinitializer
  %vc = fmul <vscale x 1 x float> %va, %splat
  ret <vscale x 1 x float> %vc
}

define <vscale x 2 x float> @vfmul_vv_nxv2f32(<vscale x 2 x float> %va, <vscale x 2 x float> %vb) {
; CHECK-LABEL: vfmul_vv_nxv2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,m1,ta,mu
; CHECK-NEXT:    vfmul.vv v8, v8, v9
; CHECK-NEXT:    ret
  %vc = fmul <vscale x 2 x float> %va, %vb
  ret <vscale x 2 x float> %vc
}

define <vscale x 2 x float> @vfmul_vf_nxv2f32(<vscale x 2 x float> %va, float %b) {
; CHECK-LABEL: vfmul_vf_nxv2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,m1,ta,mu
; CHECK-NEXT:    vfmul.vf v8, v8, fa0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 2 x float> undef, float %b, i32 0
  %splat = shufflevector <vscale x 2 x float> %head, <vscale x 2 x float> undef, <vscale x 2 x i32> zeroinitializer
  %vc = fmul <vscale x 2 x float> %va, %splat
  ret <vscale x 2 x float> %vc
}

define <vscale x 4 x float> @vfmul_vv_nxv4f32(<vscale x 4 x float> %va, <vscale x 4 x float> %vb) {
; CHECK-LABEL: vfmul_vv_nxv4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,m2,ta,mu
; CHECK-NEXT:    vfmul.vv v8, v8, v10
; CHECK-NEXT:    ret
  %vc = fmul <vscale x 4 x float> %va, %vb
  ret <vscale x 4 x float> %vc
}

define <vscale x 4 x float> @vfmul_vf_nxv4f32(<vscale x 4 x float> %va, float %b) {
; CHECK-LABEL: vfmul_vf_nxv4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,m2,ta,mu
; CHECK-NEXT:    vfmul.vf v8, v8, fa0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 4 x float> undef, float %b, i32 0
  %splat = shufflevector <vscale x 4 x float> %head, <vscale x 4 x float> undef, <vscale x 4 x i32> zeroinitializer
  %vc = fmul <vscale x 4 x float> %va, %splat
  ret <vscale x 4 x float> %vc
}

define <vscale x 8 x float> @vfmul_vv_nxv8f32(<vscale x 8 x float> %va, <vscale x 8 x float> %vb) {
; CHECK-LABEL: vfmul_vv_nxv8f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,m4,ta,mu
; CHECK-NEXT:    vfmul.vv v8, v8, v12
; CHECK-NEXT:    ret
  %vc = fmul <vscale x 8 x float> %va, %vb
  ret <vscale x 8 x float> %vc
}

define <vscale x 8 x float> @vfmul_vf_nxv8f32(<vscale x 8 x float> %va, float %b) {
; CHECK-LABEL: vfmul_vf_nxv8f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,m4,ta,mu
; CHECK-NEXT:    vfmul.vf v8, v8, fa0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x float> undef, float %b, i32 0
  %splat = shufflevector <vscale x 8 x float> %head, <vscale x 8 x float> undef, <vscale x 8 x i32> zeroinitializer
  %vc = fmul <vscale x 8 x float> %va, %splat
  ret <vscale x 8 x float> %vc
}

define <vscale x 8 x float> @vfmul_fv_nxv8f32(<vscale x 8 x float> %va, float %b) {
; CHECK-LABEL: vfmul_fv_nxv8f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,m4,ta,mu
; CHECK-NEXT:    vfmul.vf v8, v8, fa0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x float> undef, float %b, i32 0
  %splat = shufflevector <vscale x 8 x float> %head, <vscale x 8 x float> undef, <vscale x 8 x i32> zeroinitializer
  %vc = fmul <vscale x 8 x float> %splat, %va
  ret <vscale x 8 x float> %vc
}

define <vscale x 16 x float> @vfmul_vv_nxv16f32(<vscale x 16 x float> %va, <vscale x 16 x float> %vb) {
; CHECK-LABEL: vfmul_vv_nxv16f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,m8,ta,mu
; CHECK-NEXT:    vfmul.vv v8, v8, v16
; CHECK-NEXT:    ret
  %vc = fmul <vscale x 16 x float> %va, %vb
  ret <vscale x 16 x float> %vc
}

define <vscale x 16 x float> @vfmul_vf_nxv16f32(<vscale x 16 x float> %va, float %b) {
; CHECK-LABEL: vfmul_vf_nxv16f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,m8,ta,mu
; CHECK-NEXT:    vfmul.vf v8, v8, fa0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 16 x float> undef, float %b, i32 0
  %splat = shufflevector <vscale x 16 x float> %head, <vscale x 16 x float> undef, <vscale x 16 x i32> zeroinitializer
  %vc = fmul <vscale x 16 x float> %va, %splat
  ret <vscale x 16 x float> %vc
}

define <vscale x 1 x double> @vfmul_vv_nxv1f64(<vscale x 1 x double> %va, <vscale x 1 x double> %vb) {
; CHECK-LABEL: vfmul_vv_nxv1f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64,m1,ta,mu
; CHECK-NEXT:    vfmul.vv v8, v8, v9
; CHECK-NEXT:    ret
  %vc = fmul <vscale x 1 x double> %va, %vb
  ret <vscale x 1 x double> %vc
}

define <vscale x 1 x double> @vfmul_vf_nxv1f64(<vscale x 1 x double> %va, double %b) {
; CHECK-LABEL: vfmul_vf_nxv1f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64,m1,ta,mu
; CHECK-NEXT:    vfmul.vf v8, v8, fa0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 1 x double> undef, double %b, i32 0
  %splat = shufflevector <vscale x 1 x double> %head, <vscale x 1 x double> undef, <vscale x 1 x i32> zeroinitializer
  %vc = fmul <vscale x 1 x double> %va, %splat
  ret <vscale x 1 x double> %vc
}

define <vscale x 2 x double> @vfmul_vv_nxv2f64(<vscale x 2 x double> %va, <vscale x 2 x double> %vb) {
; CHECK-LABEL: vfmul_vv_nxv2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64,m2,ta,mu
; CHECK-NEXT:    vfmul.vv v8, v8, v10
; CHECK-NEXT:    ret
  %vc = fmul <vscale x 2 x double> %va, %vb
  ret <vscale x 2 x double> %vc
}

define <vscale x 2 x double> @vfmul_vf_nxv2f64(<vscale x 2 x double> %va, double %b) {
; CHECK-LABEL: vfmul_vf_nxv2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64,m2,ta,mu
; CHECK-NEXT:    vfmul.vf v8, v8, fa0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 2 x double> undef, double %b, i32 0
  %splat = shufflevector <vscale x 2 x double> %head, <vscale x 2 x double> undef, <vscale x 2 x i32> zeroinitializer
  %vc = fmul <vscale x 2 x double> %va, %splat
  ret <vscale x 2 x double> %vc
}

define <vscale x 4 x double> @vfmul_vv_nxv4f64(<vscale x 4 x double> %va, <vscale x 4 x double> %vb) {
; CHECK-LABEL: vfmul_vv_nxv4f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64,m4,ta,mu
; CHECK-NEXT:    vfmul.vv v8, v8, v12
; CHECK-NEXT:    ret
  %vc = fmul <vscale x 4 x double> %va, %vb
  ret <vscale x 4 x double> %vc
}

define <vscale x 4 x double> @vfmul_vf_nxv4f64(<vscale x 4 x double> %va, double %b) {
; CHECK-LABEL: vfmul_vf_nxv4f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64,m4,ta,mu
; CHECK-NEXT:    vfmul.vf v8, v8, fa0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 4 x double> undef, double %b, i32 0
  %splat = shufflevector <vscale x 4 x double> %head, <vscale x 4 x double> undef, <vscale x 4 x i32> zeroinitializer
  %vc = fmul <vscale x 4 x double> %va, %splat
  ret <vscale x 4 x double> %vc
}

define <vscale x 8 x double> @vfmul_vv_nxv8f64(<vscale x 8 x double> %va, <vscale x 8 x double> %vb) {
; CHECK-LABEL: vfmul_vv_nxv8f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64,m8,ta,mu
; CHECK-NEXT:    vfmul.vv v8, v8, v16
; CHECK-NEXT:    ret
  %vc = fmul <vscale x 8 x double> %va, %vb
  ret <vscale x 8 x double> %vc
}

define <vscale x 8 x double> @vfmul_vf_nxv8f64(<vscale x 8 x double> %va, double %b) {
; CHECK-LABEL: vfmul_vf_nxv8f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64,m8,ta,mu
; CHECK-NEXT:    vfmul.vf v8, v8, fa0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x double> undef, double %b, i32 0
  %splat = shufflevector <vscale x 8 x double> %head, <vscale x 8 x double> undef, <vscale x 8 x i32> zeroinitializer
  %vc = fmul <vscale x 8 x double> %va, %splat
  ret <vscale x 8 x double> %vc
}

define <vscale x 8 x double> @vfmul_fv_nxv8f64(<vscale x 8 x double> %va, double %b) {
; CHECK-LABEL: vfmul_fv_nxv8f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64,m8,ta,mu
; CHECK-NEXT:    vfmul.vf v8, v8, fa0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x double> undef, double %b, i32 0
  %splat = shufflevector <vscale x 8 x double> %head, <vscale x 8 x double> undef, <vscale x 8 x i32> zeroinitializer
  %vc = fmul <vscale x 8 x double> %splat, %va
  ret <vscale x 8 x double> %vc
}

