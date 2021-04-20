; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+experimental-v -verify-machineinstrs < %s | FileCheck %s

define <vscale x 1 x i8> @vrem_vv_nxv1i8(<vscale x 1 x i8> %va, <vscale x 1 x i8> %vb) {
; CHECK-LABEL: vrem_vv_nxv1i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e8,mf8,ta,mu
; CHECK-NEXT:    vrem.vv v8, v8, v9
; CHECK-NEXT:    ret
  %vc = srem <vscale x 1 x i8> %va, %vb
  ret <vscale x 1 x i8> %vc
}

define <vscale x 1 x i8> @vrem_vx_nxv1i8(<vscale x 1 x i8> %va, i8 signext %b) {
; CHECK-LABEL: vrem_vx_nxv1i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e8,mf8,ta,mu
; CHECK-NEXT:    vrem.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 1 x i8> undef, i8 %b, i32 0
  %splat = shufflevector <vscale x 1 x i8> %head, <vscale x 1 x i8> undef, <vscale x 1 x i32> zeroinitializer
  %vc = srem <vscale x 1 x i8> %va, %splat
  ret <vscale x 1 x i8> %vc
}

define <vscale x 1 x i8> @vrem_vi_nxv1i8_0(<vscale x 1 x i8> %va) {
; CHECK-LABEL: vrem_vi_nxv1i8_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a0, zero, 109
; CHECK-NEXT:    vsetvli a1, zero, e8,mf8,ta,mu
; CHECK-NEXT:    vmulh.vx v25, v8, a0
; CHECK-NEXT:    vrsub.vi v26, v8, 0
; CHECK-NEXT:    vadd.vv v25, v25, v26
; CHECK-NEXT:    vsra.vi v25, v25, 2
; CHECK-NEXT:    vsrl.vi v26, v25, 7
; CHECK-NEXT:    vand.vi v26, v26, -1
; CHECK-NEXT:    vadd.vv v25, v25, v26
; CHECK-NEXT:    addi a0, zero, -7
; CHECK-NEXT:    vmul.vx v25, v25, a0
; CHECK-NEXT:    vsub.vv v8, v8, v25
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 1 x i8> undef, i8 -7, i32 0
  %splat = shufflevector <vscale x 1 x i8> %head, <vscale x 1 x i8> undef, <vscale x 1 x i32> zeroinitializer
  %vc = srem <vscale x 1 x i8> %va, %splat
  ret <vscale x 1 x i8> %vc
}

define <vscale x 2 x i8> @vrem_vv_nxv2i8(<vscale x 2 x i8> %va, <vscale x 2 x i8> %vb) {
; CHECK-LABEL: vrem_vv_nxv2i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e8,mf4,ta,mu
; CHECK-NEXT:    vrem.vv v8, v8, v9
; CHECK-NEXT:    ret
  %vc = srem <vscale x 2 x i8> %va, %vb
  ret <vscale x 2 x i8> %vc
}

define <vscale x 2 x i8> @vrem_vx_nxv2i8(<vscale x 2 x i8> %va, i8 signext %b) {
; CHECK-LABEL: vrem_vx_nxv2i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e8,mf4,ta,mu
; CHECK-NEXT:    vrem.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 2 x i8> undef, i8 %b, i32 0
  %splat = shufflevector <vscale x 2 x i8> %head, <vscale x 2 x i8> undef, <vscale x 2 x i32> zeroinitializer
  %vc = srem <vscale x 2 x i8> %va, %splat
  ret <vscale x 2 x i8> %vc
}

define <vscale x 2 x i8> @vrem_vi_nxv2i8_0(<vscale x 2 x i8> %va) {
; CHECK-LABEL: vrem_vi_nxv2i8_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a0, zero, 109
; CHECK-NEXT:    vsetvli a1, zero, e8,mf4,ta,mu
; CHECK-NEXT:    vmulh.vx v25, v8, a0
; CHECK-NEXT:    vrsub.vi v26, v8, 0
; CHECK-NEXT:    vadd.vv v25, v25, v26
; CHECK-NEXT:    vsra.vi v25, v25, 2
; CHECK-NEXT:    vsrl.vi v26, v25, 7
; CHECK-NEXT:    vand.vi v26, v26, -1
; CHECK-NEXT:    vadd.vv v25, v25, v26
; CHECK-NEXT:    addi a0, zero, -7
; CHECK-NEXT:    vmul.vx v25, v25, a0
; CHECK-NEXT:    vsub.vv v8, v8, v25
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 2 x i8> undef, i8 -7, i32 0
  %splat = shufflevector <vscale x 2 x i8> %head, <vscale x 2 x i8> undef, <vscale x 2 x i32> zeroinitializer
  %vc = srem <vscale x 2 x i8> %va, %splat
  ret <vscale x 2 x i8> %vc
}

define <vscale x 4 x i8> @vrem_vv_nxv4i8(<vscale x 4 x i8> %va, <vscale x 4 x i8> %vb) {
; CHECK-LABEL: vrem_vv_nxv4i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e8,mf2,ta,mu
; CHECK-NEXT:    vrem.vv v8, v8, v9
; CHECK-NEXT:    ret
  %vc = srem <vscale x 4 x i8> %va, %vb
  ret <vscale x 4 x i8> %vc
}

define <vscale x 4 x i8> @vrem_vx_nxv4i8(<vscale x 4 x i8> %va, i8 signext %b) {
; CHECK-LABEL: vrem_vx_nxv4i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e8,mf2,ta,mu
; CHECK-NEXT:    vrem.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 4 x i8> undef, i8 %b, i32 0
  %splat = shufflevector <vscale x 4 x i8> %head, <vscale x 4 x i8> undef, <vscale x 4 x i32> zeroinitializer
  %vc = srem <vscale x 4 x i8> %va, %splat
  ret <vscale x 4 x i8> %vc
}

define <vscale x 4 x i8> @vrem_vi_nxv4i8_0(<vscale x 4 x i8> %va) {
; CHECK-LABEL: vrem_vi_nxv4i8_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a0, zero, 109
; CHECK-NEXT:    vsetvli a1, zero, e8,mf2,ta,mu
; CHECK-NEXT:    vmulh.vx v25, v8, a0
; CHECK-NEXT:    vrsub.vi v26, v8, 0
; CHECK-NEXT:    vadd.vv v25, v25, v26
; CHECK-NEXT:    vsra.vi v25, v25, 2
; CHECK-NEXT:    vsrl.vi v26, v25, 7
; CHECK-NEXT:    vand.vi v26, v26, -1
; CHECK-NEXT:    vadd.vv v25, v25, v26
; CHECK-NEXT:    addi a0, zero, -7
; CHECK-NEXT:    vmul.vx v25, v25, a0
; CHECK-NEXT:    vsub.vv v8, v8, v25
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 4 x i8> undef, i8 -7, i32 0
  %splat = shufflevector <vscale x 4 x i8> %head, <vscale x 4 x i8> undef, <vscale x 4 x i32> zeroinitializer
  %vc = srem <vscale x 4 x i8> %va, %splat
  ret <vscale x 4 x i8> %vc
}

define <vscale x 8 x i8> @vrem_vv_nxv8i8(<vscale x 8 x i8> %va, <vscale x 8 x i8> %vb) {
; CHECK-LABEL: vrem_vv_nxv8i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e8,m1,ta,mu
; CHECK-NEXT:    vrem.vv v8, v8, v9
; CHECK-NEXT:    ret
  %vc = srem <vscale x 8 x i8> %va, %vb
  ret <vscale x 8 x i8> %vc
}

define <vscale x 8 x i8> @vrem_vx_nxv8i8(<vscale x 8 x i8> %va, i8 signext %b) {
; CHECK-LABEL: vrem_vx_nxv8i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e8,m1,ta,mu
; CHECK-NEXT:    vrem.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x i8> undef, i8 %b, i32 0
  %splat = shufflevector <vscale x 8 x i8> %head, <vscale x 8 x i8> undef, <vscale x 8 x i32> zeroinitializer
  %vc = srem <vscale x 8 x i8> %va, %splat
  ret <vscale x 8 x i8> %vc
}

define <vscale x 8 x i8> @vrem_vi_nxv8i8_0(<vscale x 8 x i8> %va) {
; CHECK-LABEL: vrem_vi_nxv8i8_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a0, zero, 109
; CHECK-NEXT:    vsetvli a1, zero, e8,m1,ta,mu
; CHECK-NEXT:    vmulh.vx v25, v8, a0
; CHECK-NEXT:    vrsub.vi v26, v8, 0
; CHECK-NEXT:    vadd.vv v25, v25, v26
; CHECK-NEXT:    vsra.vi v25, v25, 2
; CHECK-NEXT:    vsrl.vi v26, v25, 7
; CHECK-NEXT:    vand.vi v26, v26, -1
; CHECK-NEXT:    vadd.vv v25, v25, v26
; CHECK-NEXT:    addi a0, zero, -7
; CHECK-NEXT:    vmul.vx v25, v25, a0
; CHECK-NEXT:    vsub.vv v8, v8, v25
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x i8> undef, i8 -7, i32 0
  %splat = shufflevector <vscale x 8 x i8> %head, <vscale x 8 x i8> undef, <vscale x 8 x i32> zeroinitializer
  %vc = srem <vscale x 8 x i8> %va, %splat
  ret <vscale x 8 x i8> %vc
}

define <vscale x 16 x i8> @vrem_vv_nxv16i8(<vscale x 16 x i8> %va, <vscale x 16 x i8> %vb) {
; CHECK-LABEL: vrem_vv_nxv16i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e8,m2,ta,mu
; CHECK-NEXT:    vrem.vv v8, v8, v10
; CHECK-NEXT:    ret
  %vc = srem <vscale x 16 x i8> %va, %vb
  ret <vscale x 16 x i8> %vc
}

define <vscale x 16 x i8> @vrem_vx_nxv16i8(<vscale x 16 x i8> %va, i8 signext %b) {
; CHECK-LABEL: vrem_vx_nxv16i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e8,m2,ta,mu
; CHECK-NEXT:    vrem.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 16 x i8> undef, i8 %b, i32 0
  %splat = shufflevector <vscale x 16 x i8> %head, <vscale x 16 x i8> undef, <vscale x 16 x i32> zeroinitializer
  %vc = srem <vscale x 16 x i8> %va, %splat
  ret <vscale x 16 x i8> %vc
}

define <vscale x 16 x i8> @vrem_vi_nxv16i8_0(<vscale x 16 x i8> %va) {
; CHECK-LABEL: vrem_vi_nxv16i8_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a0, zero, 109
; CHECK-NEXT:    vsetvli a1, zero, e8,m2,ta,mu
; CHECK-NEXT:    vmulh.vx v26, v8, a0
; CHECK-NEXT:    vrsub.vi v28, v8, 0
; CHECK-NEXT:    vadd.vv v26, v26, v28
; CHECK-NEXT:    vsra.vi v26, v26, 2
; CHECK-NEXT:    vsrl.vi v28, v26, 7
; CHECK-NEXT:    vand.vi v28, v28, -1
; CHECK-NEXT:    vadd.vv v26, v26, v28
; CHECK-NEXT:    addi a0, zero, -7
; CHECK-NEXT:    vmul.vx v26, v26, a0
; CHECK-NEXT:    vsub.vv v8, v8, v26
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 16 x i8> undef, i8 -7, i32 0
  %splat = shufflevector <vscale x 16 x i8> %head, <vscale x 16 x i8> undef, <vscale x 16 x i32> zeroinitializer
  %vc = srem <vscale x 16 x i8> %va, %splat
  ret <vscale x 16 x i8> %vc
}

define <vscale x 32 x i8> @vrem_vv_nxv32i8(<vscale x 32 x i8> %va, <vscale x 32 x i8> %vb) {
; CHECK-LABEL: vrem_vv_nxv32i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e8,m4,ta,mu
; CHECK-NEXT:    vrem.vv v8, v8, v12
; CHECK-NEXT:    ret
  %vc = srem <vscale x 32 x i8> %va, %vb
  ret <vscale x 32 x i8> %vc
}

define <vscale x 32 x i8> @vrem_vx_nxv32i8(<vscale x 32 x i8> %va, i8 signext %b) {
; CHECK-LABEL: vrem_vx_nxv32i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e8,m4,ta,mu
; CHECK-NEXT:    vrem.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 32 x i8> undef, i8 %b, i32 0
  %splat = shufflevector <vscale x 32 x i8> %head, <vscale x 32 x i8> undef, <vscale x 32 x i32> zeroinitializer
  %vc = srem <vscale x 32 x i8> %va, %splat
  ret <vscale x 32 x i8> %vc
}

define <vscale x 32 x i8> @vrem_vi_nxv32i8_0(<vscale x 32 x i8> %va) {
; CHECK-LABEL: vrem_vi_nxv32i8_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a0, zero, 109
; CHECK-NEXT:    vsetvli a1, zero, e8,m4,ta,mu
; CHECK-NEXT:    vmulh.vx v28, v8, a0
; CHECK-NEXT:    vrsub.vi v12, v8, 0
; CHECK-NEXT:    vadd.vv v28, v28, v12
; CHECK-NEXT:    vsra.vi v28, v28, 2
; CHECK-NEXT:    vsrl.vi v12, v28, 7
; CHECK-NEXT:    vand.vi v12, v12, -1
; CHECK-NEXT:    vadd.vv v28, v28, v12
; CHECK-NEXT:    addi a0, zero, -7
; CHECK-NEXT:    vmul.vx v28, v28, a0
; CHECK-NEXT:    vsub.vv v8, v8, v28
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 32 x i8> undef, i8 -7, i32 0
  %splat = shufflevector <vscale x 32 x i8> %head, <vscale x 32 x i8> undef, <vscale x 32 x i32> zeroinitializer
  %vc = srem <vscale x 32 x i8> %va, %splat
  ret <vscale x 32 x i8> %vc
}

define <vscale x 64 x i8> @vrem_vv_nxv64i8(<vscale x 64 x i8> %va, <vscale x 64 x i8> %vb) {
; CHECK-LABEL: vrem_vv_nxv64i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e8,m8,ta,mu
; CHECK-NEXT:    vrem.vv v8, v8, v16
; CHECK-NEXT:    ret
  %vc = srem <vscale x 64 x i8> %va, %vb
  ret <vscale x 64 x i8> %vc
}

define <vscale x 64 x i8> @vrem_vx_nxv64i8(<vscale x 64 x i8> %va, i8 signext %b) {
; CHECK-LABEL: vrem_vx_nxv64i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e8,m8,ta,mu
; CHECK-NEXT:    vrem.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 64 x i8> undef, i8 %b, i32 0
  %splat = shufflevector <vscale x 64 x i8> %head, <vscale x 64 x i8> undef, <vscale x 64 x i32> zeroinitializer
  %vc = srem <vscale x 64 x i8> %va, %splat
  ret <vscale x 64 x i8> %vc
}

define <vscale x 64 x i8> @vrem_vi_nxv64i8_0(<vscale x 64 x i8> %va) {
; CHECK-LABEL: vrem_vi_nxv64i8_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a0, zero, 109
; CHECK-NEXT:    vsetvli a1, zero, e8,m8,ta,mu
; CHECK-NEXT:    vmulh.vx v16, v8, a0
; CHECK-NEXT:    vrsub.vi v24, v8, 0
; CHECK-NEXT:    vadd.vv v16, v16, v24
; CHECK-NEXT:    vsra.vi v16, v16, 2
; CHECK-NEXT:    vsrl.vi v24, v16, 7
; CHECK-NEXT:    vand.vi v24, v24, -1
; CHECK-NEXT:    vadd.vv v16, v16, v24
; CHECK-NEXT:    addi a0, zero, -7
; CHECK-NEXT:    vmul.vx v16, v16, a0
; CHECK-NEXT:    vsub.vv v8, v8, v16
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 64 x i8> undef, i8 -7, i32 0
  %splat = shufflevector <vscale x 64 x i8> %head, <vscale x 64 x i8> undef, <vscale x 64 x i32> zeroinitializer
  %vc = srem <vscale x 64 x i8> %va, %splat
  ret <vscale x 64 x i8> %vc
}

define <vscale x 1 x i16> @vrem_vv_nxv1i16(<vscale x 1 x i16> %va, <vscale x 1 x i16> %vb) {
; CHECK-LABEL: vrem_vv_nxv1i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16,mf4,ta,mu
; CHECK-NEXT:    vrem.vv v8, v8, v9
; CHECK-NEXT:    ret
  %vc = srem <vscale x 1 x i16> %va, %vb
  ret <vscale x 1 x i16> %vc
}

define <vscale x 1 x i16> @vrem_vx_nxv1i16(<vscale x 1 x i16> %va, i16 signext %b) {
; CHECK-LABEL: vrem_vx_nxv1i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e16,mf4,ta,mu
; CHECK-NEXT:    vrem.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 1 x i16> undef, i16 %b, i32 0
  %splat = shufflevector <vscale x 1 x i16> %head, <vscale x 1 x i16> undef, <vscale x 1 x i32> zeroinitializer
  %vc = srem <vscale x 1 x i16> %va, %splat
  ret <vscale x 1 x i16> %vc
}

define <vscale x 1 x i16> @vrem_vi_nxv1i16_0(<vscale x 1 x i16> %va) {
; CHECK-LABEL: vrem_vi_nxv1i16_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a0, 1048571
; CHECK-NEXT:    addi a0, a0, 1755
; CHECK-NEXT:    vsetvli a1, zero, e16,mf4,ta,mu
; CHECK-NEXT:    vmulh.vx v25, v8, a0
; CHECK-NEXT:    vsra.vi v25, v25, 1
; CHECK-NEXT:    vsrl.vi v26, v25, 15
; CHECK-NEXT:    vand.vi v26, v26, -1
; CHECK-NEXT:    vadd.vv v25, v25, v26
; CHECK-NEXT:    addi a0, zero, -7
; CHECK-NEXT:    vmul.vx v25, v25, a0
; CHECK-NEXT:    vsub.vv v8, v8, v25
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 1 x i16> undef, i16 -7, i32 0
  %splat = shufflevector <vscale x 1 x i16> %head, <vscale x 1 x i16> undef, <vscale x 1 x i32> zeroinitializer
  %vc = srem <vscale x 1 x i16> %va, %splat
  ret <vscale x 1 x i16> %vc
}

define <vscale x 2 x i16> @vrem_vv_nxv2i16(<vscale x 2 x i16> %va, <vscale x 2 x i16> %vb) {
; CHECK-LABEL: vrem_vv_nxv2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16,mf2,ta,mu
; CHECK-NEXT:    vrem.vv v8, v8, v9
; CHECK-NEXT:    ret
  %vc = srem <vscale x 2 x i16> %va, %vb
  ret <vscale x 2 x i16> %vc
}

define <vscale x 2 x i16> @vrem_vx_nxv2i16(<vscale x 2 x i16> %va, i16 signext %b) {
; CHECK-LABEL: vrem_vx_nxv2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e16,mf2,ta,mu
; CHECK-NEXT:    vrem.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 2 x i16> undef, i16 %b, i32 0
  %splat = shufflevector <vscale x 2 x i16> %head, <vscale x 2 x i16> undef, <vscale x 2 x i32> zeroinitializer
  %vc = srem <vscale x 2 x i16> %va, %splat
  ret <vscale x 2 x i16> %vc
}

define <vscale x 2 x i16> @vrem_vi_nxv2i16_0(<vscale x 2 x i16> %va) {
; CHECK-LABEL: vrem_vi_nxv2i16_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a0, 1048571
; CHECK-NEXT:    addi a0, a0, 1755
; CHECK-NEXT:    vsetvli a1, zero, e16,mf2,ta,mu
; CHECK-NEXT:    vmulh.vx v25, v8, a0
; CHECK-NEXT:    vsra.vi v25, v25, 1
; CHECK-NEXT:    vsrl.vi v26, v25, 15
; CHECK-NEXT:    vand.vi v26, v26, -1
; CHECK-NEXT:    vadd.vv v25, v25, v26
; CHECK-NEXT:    addi a0, zero, -7
; CHECK-NEXT:    vmul.vx v25, v25, a0
; CHECK-NEXT:    vsub.vv v8, v8, v25
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 2 x i16> undef, i16 -7, i32 0
  %splat = shufflevector <vscale x 2 x i16> %head, <vscale x 2 x i16> undef, <vscale x 2 x i32> zeroinitializer
  %vc = srem <vscale x 2 x i16> %va, %splat
  ret <vscale x 2 x i16> %vc
}

define <vscale x 4 x i16> @vrem_vv_nxv4i16(<vscale x 4 x i16> %va, <vscale x 4 x i16> %vb) {
; CHECK-LABEL: vrem_vv_nxv4i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16,m1,ta,mu
; CHECK-NEXT:    vrem.vv v8, v8, v9
; CHECK-NEXT:    ret
  %vc = srem <vscale x 4 x i16> %va, %vb
  ret <vscale x 4 x i16> %vc
}

define <vscale x 4 x i16> @vrem_vx_nxv4i16(<vscale x 4 x i16> %va, i16 signext %b) {
; CHECK-LABEL: vrem_vx_nxv4i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e16,m1,ta,mu
; CHECK-NEXT:    vrem.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 4 x i16> undef, i16 %b, i32 0
  %splat = shufflevector <vscale x 4 x i16> %head, <vscale x 4 x i16> undef, <vscale x 4 x i32> zeroinitializer
  %vc = srem <vscale x 4 x i16> %va, %splat
  ret <vscale x 4 x i16> %vc
}

define <vscale x 4 x i16> @vrem_vi_nxv4i16_0(<vscale x 4 x i16> %va) {
; CHECK-LABEL: vrem_vi_nxv4i16_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a0, 1048571
; CHECK-NEXT:    addi a0, a0, 1755
; CHECK-NEXT:    vsetvli a1, zero, e16,m1,ta,mu
; CHECK-NEXT:    vmulh.vx v25, v8, a0
; CHECK-NEXT:    vsra.vi v25, v25, 1
; CHECK-NEXT:    vsrl.vi v26, v25, 15
; CHECK-NEXT:    vand.vi v26, v26, -1
; CHECK-NEXT:    vadd.vv v25, v25, v26
; CHECK-NEXT:    addi a0, zero, -7
; CHECK-NEXT:    vmul.vx v25, v25, a0
; CHECK-NEXT:    vsub.vv v8, v8, v25
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 4 x i16> undef, i16 -7, i32 0
  %splat = shufflevector <vscale x 4 x i16> %head, <vscale x 4 x i16> undef, <vscale x 4 x i32> zeroinitializer
  %vc = srem <vscale x 4 x i16> %va, %splat
  ret <vscale x 4 x i16> %vc
}

define <vscale x 8 x i16> @vrem_vv_nxv8i16(<vscale x 8 x i16> %va, <vscale x 8 x i16> %vb) {
; CHECK-LABEL: vrem_vv_nxv8i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16,m2,ta,mu
; CHECK-NEXT:    vrem.vv v8, v8, v10
; CHECK-NEXT:    ret
  %vc = srem <vscale x 8 x i16> %va, %vb
  ret <vscale x 8 x i16> %vc
}

define <vscale x 8 x i16> @vrem_vx_nxv8i16(<vscale x 8 x i16> %va, i16 signext %b) {
; CHECK-LABEL: vrem_vx_nxv8i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e16,m2,ta,mu
; CHECK-NEXT:    vrem.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x i16> undef, i16 %b, i32 0
  %splat = shufflevector <vscale x 8 x i16> %head, <vscale x 8 x i16> undef, <vscale x 8 x i32> zeroinitializer
  %vc = srem <vscale x 8 x i16> %va, %splat
  ret <vscale x 8 x i16> %vc
}

define <vscale x 8 x i16> @vrem_vi_nxv8i16_0(<vscale x 8 x i16> %va) {
; CHECK-LABEL: vrem_vi_nxv8i16_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a0, 1048571
; CHECK-NEXT:    addi a0, a0, 1755
; CHECK-NEXT:    vsetvli a1, zero, e16,m2,ta,mu
; CHECK-NEXT:    vmulh.vx v26, v8, a0
; CHECK-NEXT:    vsra.vi v26, v26, 1
; CHECK-NEXT:    vsrl.vi v28, v26, 15
; CHECK-NEXT:    vand.vi v28, v28, -1
; CHECK-NEXT:    vadd.vv v26, v26, v28
; CHECK-NEXT:    addi a0, zero, -7
; CHECK-NEXT:    vmul.vx v26, v26, a0
; CHECK-NEXT:    vsub.vv v8, v8, v26
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x i16> undef, i16 -7, i32 0
  %splat = shufflevector <vscale x 8 x i16> %head, <vscale x 8 x i16> undef, <vscale x 8 x i32> zeroinitializer
  %vc = srem <vscale x 8 x i16> %va, %splat
  ret <vscale x 8 x i16> %vc
}

define <vscale x 16 x i16> @vrem_vv_nxv16i16(<vscale x 16 x i16> %va, <vscale x 16 x i16> %vb) {
; CHECK-LABEL: vrem_vv_nxv16i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16,m4,ta,mu
; CHECK-NEXT:    vrem.vv v8, v8, v12
; CHECK-NEXT:    ret
  %vc = srem <vscale x 16 x i16> %va, %vb
  ret <vscale x 16 x i16> %vc
}

define <vscale x 16 x i16> @vrem_vx_nxv16i16(<vscale x 16 x i16> %va, i16 signext %b) {
; CHECK-LABEL: vrem_vx_nxv16i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e16,m4,ta,mu
; CHECK-NEXT:    vrem.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 16 x i16> undef, i16 %b, i32 0
  %splat = shufflevector <vscale x 16 x i16> %head, <vscale x 16 x i16> undef, <vscale x 16 x i32> zeroinitializer
  %vc = srem <vscale x 16 x i16> %va, %splat
  ret <vscale x 16 x i16> %vc
}

define <vscale x 16 x i16> @vrem_vi_nxv16i16_0(<vscale x 16 x i16> %va) {
; CHECK-LABEL: vrem_vi_nxv16i16_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a0, 1048571
; CHECK-NEXT:    addi a0, a0, 1755
; CHECK-NEXT:    vsetvli a1, zero, e16,m4,ta,mu
; CHECK-NEXT:    vmulh.vx v28, v8, a0
; CHECK-NEXT:    vsra.vi v28, v28, 1
; CHECK-NEXT:    vsrl.vi v12, v28, 15
; CHECK-NEXT:    vand.vi v12, v12, -1
; CHECK-NEXT:    vadd.vv v28, v28, v12
; CHECK-NEXT:    addi a0, zero, -7
; CHECK-NEXT:    vmul.vx v28, v28, a0
; CHECK-NEXT:    vsub.vv v8, v8, v28
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 16 x i16> undef, i16 -7, i32 0
  %splat = shufflevector <vscale x 16 x i16> %head, <vscale x 16 x i16> undef, <vscale x 16 x i32> zeroinitializer
  %vc = srem <vscale x 16 x i16> %va, %splat
  ret <vscale x 16 x i16> %vc
}

define <vscale x 32 x i16> @vrem_vv_nxv32i16(<vscale x 32 x i16> %va, <vscale x 32 x i16> %vb) {
; CHECK-LABEL: vrem_vv_nxv32i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16,m8,ta,mu
; CHECK-NEXT:    vrem.vv v8, v8, v16
; CHECK-NEXT:    ret
  %vc = srem <vscale x 32 x i16> %va, %vb
  ret <vscale x 32 x i16> %vc
}

define <vscale x 32 x i16> @vrem_vx_nxv32i16(<vscale x 32 x i16> %va, i16 signext %b) {
; CHECK-LABEL: vrem_vx_nxv32i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e16,m8,ta,mu
; CHECK-NEXT:    vrem.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 32 x i16> undef, i16 %b, i32 0
  %splat = shufflevector <vscale x 32 x i16> %head, <vscale x 32 x i16> undef, <vscale x 32 x i32> zeroinitializer
  %vc = srem <vscale x 32 x i16> %va, %splat
  ret <vscale x 32 x i16> %vc
}

define <vscale x 32 x i16> @vrem_vi_nxv32i16_0(<vscale x 32 x i16> %va) {
; CHECK-LABEL: vrem_vi_nxv32i16_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a0, 1048571
; CHECK-NEXT:    addi a0, a0, 1755
; CHECK-NEXT:    vsetvli a1, zero, e16,m8,ta,mu
; CHECK-NEXT:    vmulh.vx v16, v8, a0
; CHECK-NEXT:    vsra.vi v16, v16, 1
; CHECK-NEXT:    vsrl.vi v24, v16, 15
; CHECK-NEXT:    vand.vi v24, v24, -1
; CHECK-NEXT:    vadd.vv v16, v16, v24
; CHECK-NEXT:    addi a0, zero, -7
; CHECK-NEXT:    vmul.vx v16, v16, a0
; CHECK-NEXT:    vsub.vv v8, v8, v16
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 32 x i16> undef, i16 -7, i32 0
  %splat = shufflevector <vscale x 32 x i16> %head, <vscale x 32 x i16> undef, <vscale x 32 x i32> zeroinitializer
  %vc = srem <vscale x 32 x i16> %va, %splat
  ret <vscale x 32 x i16> %vc
}

define <vscale x 1 x i32> @vrem_vv_nxv1i32(<vscale x 1 x i32> %va, <vscale x 1 x i32> %vb) {
; CHECK-LABEL: vrem_vv_nxv1i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,mf2,ta,mu
; CHECK-NEXT:    vrem.vv v8, v8, v9
; CHECK-NEXT:    ret
  %vc = srem <vscale x 1 x i32> %va, %vb
  ret <vscale x 1 x i32> %vc
}

define <vscale x 1 x i32> @vrem_vx_nxv1i32(<vscale x 1 x i32> %va, i32 %b) {
; CHECK-LABEL: vrem_vx_nxv1i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32,mf2,ta,mu
; CHECK-NEXT:    vrem.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 1 x i32> undef, i32 %b, i32 0
  %splat = shufflevector <vscale x 1 x i32> %head, <vscale x 1 x i32> undef, <vscale x 1 x i32> zeroinitializer
  %vc = srem <vscale x 1 x i32> %va, %splat
  ret <vscale x 1 x i32> %vc
}

define <vscale x 1 x i32> @vrem_vi_nxv1i32_0(<vscale x 1 x i32> %va) {
; CHECK-LABEL: vrem_vi_nxv1i32_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a0, 449390
; CHECK-NEXT:    addi a0, a0, -1171
; CHECK-NEXT:    vsetvli a1, zero, e32,mf2,ta,mu
; CHECK-NEXT:    vmulh.vx v25, v8, a0
; CHECK-NEXT:    vsub.vv v25, v25, v8
; CHECK-NEXT:    vsra.vi v26, v25, 2
; CHECK-NEXT:    vsrl.vi v25, v25, 31
; CHECK-NEXT:    vand.vi v25, v25, -1
; CHECK-NEXT:    vadd.vv v25, v26, v25
; CHECK-NEXT:    addi a0, zero, -7
; CHECK-NEXT:    vmul.vx v25, v25, a0
; CHECK-NEXT:    vsub.vv v8, v8, v25
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 1 x i32> undef, i32 -7, i32 0
  %splat = shufflevector <vscale x 1 x i32> %head, <vscale x 1 x i32> undef, <vscale x 1 x i32> zeroinitializer
  %vc = srem <vscale x 1 x i32> %va, %splat
  ret <vscale x 1 x i32> %vc
}

define <vscale x 2 x i32> @vrem_vv_nxv2i32(<vscale x 2 x i32> %va, <vscale x 2 x i32> %vb) {
; CHECK-LABEL: vrem_vv_nxv2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,m1,ta,mu
; CHECK-NEXT:    vrem.vv v8, v8, v9
; CHECK-NEXT:    ret
  %vc = srem <vscale x 2 x i32> %va, %vb
  ret <vscale x 2 x i32> %vc
}

define <vscale x 2 x i32> @vrem_vx_nxv2i32(<vscale x 2 x i32> %va, i32 %b) {
; CHECK-LABEL: vrem_vx_nxv2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32,m1,ta,mu
; CHECK-NEXT:    vrem.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 2 x i32> undef, i32 %b, i32 0
  %splat = shufflevector <vscale x 2 x i32> %head, <vscale x 2 x i32> undef, <vscale x 2 x i32> zeroinitializer
  %vc = srem <vscale x 2 x i32> %va, %splat
  ret <vscale x 2 x i32> %vc
}

define <vscale x 2 x i32> @vrem_vi_nxv2i32_0(<vscale x 2 x i32> %va) {
; CHECK-LABEL: vrem_vi_nxv2i32_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a0, 449390
; CHECK-NEXT:    addi a0, a0, -1171
; CHECK-NEXT:    vsetvli a1, zero, e32,m1,ta,mu
; CHECK-NEXT:    vmulh.vx v25, v8, a0
; CHECK-NEXT:    vsub.vv v25, v25, v8
; CHECK-NEXT:    vsra.vi v26, v25, 2
; CHECK-NEXT:    vsrl.vi v25, v25, 31
; CHECK-NEXT:    vand.vi v25, v25, -1
; CHECK-NEXT:    vadd.vv v25, v26, v25
; CHECK-NEXT:    addi a0, zero, -7
; CHECK-NEXT:    vmul.vx v25, v25, a0
; CHECK-NEXT:    vsub.vv v8, v8, v25
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 2 x i32> undef, i32 -7, i32 0
  %splat = shufflevector <vscale x 2 x i32> %head, <vscale x 2 x i32> undef, <vscale x 2 x i32> zeroinitializer
  %vc = srem <vscale x 2 x i32> %va, %splat
  ret <vscale x 2 x i32> %vc
}

define <vscale x 4 x i32> @vrem_vv_nxv4i32(<vscale x 4 x i32> %va, <vscale x 4 x i32> %vb) {
; CHECK-LABEL: vrem_vv_nxv4i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,m2,ta,mu
; CHECK-NEXT:    vrem.vv v8, v8, v10
; CHECK-NEXT:    ret
  %vc = srem <vscale x 4 x i32> %va, %vb
  ret <vscale x 4 x i32> %vc
}

define <vscale x 4 x i32> @vrem_vx_nxv4i32(<vscale x 4 x i32> %va, i32 %b) {
; CHECK-LABEL: vrem_vx_nxv4i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32,m2,ta,mu
; CHECK-NEXT:    vrem.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 4 x i32> undef, i32 %b, i32 0
  %splat = shufflevector <vscale x 4 x i32> %head, <vscale x 4 x i32> undef, <vscale x 4 x i32> zeroinitializer
  %vc = srem <vscale x 4 x i32> %va, %splat
  ret <vscale x 4 x i32> %vc
}

define <vscale x 4 x i32> @vrem_vi_nxv4i32_0(<vscale x 4 x i32> %va) {
; CHECK-LABEL: vrem_vi_nxv4i32_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a0, 449390
; CHECK-NEXT:    addi a0, a0, -1171
; CHECK-NEXT:    vsetvli a1, zero, e32,m2,ta,mu
; CHECK-NEXT:    vmulh.vx v26, v8, a0
; CHECK-NEXT:    vsub.vv v26, v26, v8
; CHECK-NEXT:    vsra.vi v28, v26, 2
; CHECK-NEXT:    vsrl.vi v26, v26, 31
; CHECK-NEXT:    vand.vi v26, v26, -1
; CHECK-NEXT:    vadd.vv v26, v28, v26
; CHECK-NEXT:    addi a0, zero, -7
; CHECK-NEXT:    vmul.vx v26, v26, a0
; CHECK-NEXT:    vsub.vv v8, v8, v26
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 4 x i32> undef, i32 -7, i32 0
  %splat = shufflevector <vscale x 4 x i32> %head, <vscale x 4 x i32> undef, <vscale x 4 x i32> zeroinitializer
  %vc = srem <vscale x 4 x i32> %va, %splat
  ret <vscale x 4 x i32> %vc
}

define <vscale x 8 x i32> @vrem_vv_nxv8i32(<vscale x 8 x i32> %va, <vscale x 8 x i32> %vb) {
; CHECK-LABEL: vrem_vv_nxv8i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,m4,ta,mu
; CHECK-NEXT:    vrem.vv v8, v8, v12
; CHECK-NEXT:    ret
  %vc = srem <vscale x 8 x i32> %va, %vb
  ret <vscale x 8 x i32> %vc
}

define <vscale x 8 x i32> @vrem_vx_nxv8i32(<vscale x 8 x i32> %va, i32 %b) {
; CHECK-LABEL: vrem_vx_nxv8i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32,m4,ta,mu
; CHECK-NEXT:    vrem.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x i32> undef, i32 %b, i32 0
  %splat = shufflevector <vscale x 8 x i32> %head, <vscale x 8 x i32> undef, <vscale x 8 x i32> zeroinitializer
  %vc = srem <vscale x 8 x i32> %va, %splat
  ret <vscale x 8 x i32> %vc
}

define <vscale x 8 x i32> @vrem_vi_nxv8i32_0(<vscale x 8 x i32> %va) {
; CHECK-LABEL: vrem_vi_nxv8i32_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a0, 449390
; CHECK-NEXT:    addi a0, a0, -1171
; CHECK-NEXT:    vsetvli a1, zero, e32,m4,ta,mu
; CHECK-NEXT:    vmulh.vx v28, v8, a0
; CHECK-NEXT:    vsub.vv v28, v28, v8
; CHECK-NEXT:    vsra.vi v12, v28, 2
; CHECK-NEXT:    vsrl.vi v28, v28, 31
; CHECK-NEXT:    vand.vi v28, v28, -1
; CHECK-NEXT:    vadd.vv v28, v12, v28
; CHECK-NEXT:    addi a0, zero, -7
; CHECK-NEXT:    vmul.vx v28, v28, a0
; CHECK-NEXT:    vsub.vv v8, v8, v28
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x i32> undef, i32 -7, i32 0
  %splat = shufflevector <vscale x 8 x i32> %head, <vscale x 8 x i32> undef, <vscale x 8 x i32> zeroinitializer
  %vc = srem <vscale x 8 x i32> %va, %splat
  ret <vscale x 8 x i32> %vc
}

define <vscale x 16 x i32> @vrem_vv_nxv16i32(<vscale x 16 x i32> %va, <vscale x 16 x i32> %vb) {
; CHECK-LABEL: vrem_vv_nxv16i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,m8,ta,mu
; CHECK-NEXT:    vrem.vv v8, v8, v16
; CHECK-NEXT:    ret
  %vc = srem <vscale x 16 x i32> %va, %vb
  ret <vscale x 16 x i32> %vc
}

define <vscale x 16 x i32> @vrem_vx_nxv16i32(<vscale x 16 x i32> %va, i32 %b) {
; CHECK-LABEL: vrem_vx_nxv16i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32,m8,ta,mu
; CHECK-NEXT:    vrem.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 16 x i32> undef, i32 %b, i32 0
  %splat = shufflevector <vscale x 16 x i32> %head, <vscale x 16 x i32> undef, <vscale x 16 x i32> zeroinitializer
  %vc = srem <vscale x 16 x i32> %va, %splat
  ret <vscale x 16 x i32> %vc
}

define <vscale x 16 x i32> @vrem_vi_nxv16i32_0(<vscale x 16 x i32> %va) {
; CHECK-LABEL: vrem_vi_nxv16i32_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a0, 449390
; CHECK-NEXT:    addi a0, a0, -1171
; CHECK-NEXT:    vsetvli a1, zero, e32,m8,ta,mu
; CHECK-NEXT:    vmulh.vx v16, v8, a0
; CHECK-NEXT:    vsub.vv v16, v16, v8
; CHECK-NEXT:    vsra.vi v24, v16, 2
; CHECK-NEXT:    vsrl.vi v16, v16, 31
; CHECK-NEXT:    vand.vi v16, v16, -1
; CHECK-NEXT:    vadd.vv v16, v24, v16
; CHECK-NEXT:    addi a0, zero, -7
; CHECK-NEXT:    vmul.vx v16, v16, a0
; CHECK-NEXT:    vsub.vv v8, v8, v16
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 16 x i32> undef, i32 -7, i32 0
  %splat = shufflevector <vscale x 16 x i32> %head, <vscale x 16 x i32> undef, <vscale x 16 x i32> zeroinitializer
  %vc = srem <vscale x 16 x i32> %va, %splat
  ret <vscale x 16 x i32> %vc
}

define <vscale x 1 x i64> @vrem_vv_nxv1i64(<vscale x 1 x i64> %va, <vscale x 1 x i64> %vb) {
; CHECK-LABEL: vrem_vv_nxv1i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64,m1,ta,mu
; CHECK-NEXT:    vrem.vv v8, v8, v9
; CHECK-NEXT:    ret
  %vc = srem <vscale x 1 x i64> %va, %vb
  ret <vscale x 1 x i64> %vc
}

define <vscale x 1 x i64> @vrem_vx_nxv1i64(<vscale x 1 x i64> %va, i64 %b) {
; CHECK-LABEL: vrem_vx_nxv1i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a2, zero, e64,m1,ta,mu
; CHECK-NEXT:    vmv.v.x v25, a1
; CHECK-NEXT:    addi a1, zero, 32
; CHECK-NEXT:    vsll.vx v25, v25, a1
; CHECK-NEXT:    vmv.v.x v26, a0
; CHECK-NEXT:    vsll.vx v26, v26, a1
; CHECK-NEXT:    vsrl.vx v26, v26, a1
; CHECK-NEXT:    vor.vv v25, v26, v25
; CHECK-NEXT:    vrem.vv v8, v8, v25
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 1 x i64> undef, i64 %b, i32 0
  %splat = shufflevector <vscale x 1 x i64> %head, <vscale x 1 x i64> undef, <vscale x 1 x i32> zeroinitializer
  %vc = srem <vscale x 1 x i64> %va, %splat
  ret <vscale x 1 x i64> %vc
}

define <vscale x 1 x i64> @vrem_vi_nxv1i64_0(<vscale x 1 x i64> %va) {
; CHECK-LABEL: vrem_vi_nxv1i64_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a0, 748983
; CHECK-NEXT:    addi a0, a0, -586
; CHECK-NEXT:    vsetvli a1, zero, e64,m1,ta,mu
; CHECK-NEXT:    vmv.v.x v25, a0
; CHECK-NEXT:    addi a0, zero, 32
; CHECK-NEXT:    vsll.vx v25, v25, a0
; CHECK-NEXT:    lui a1, 898779
; CHECK-NEXT:    addi a1, a1, 1755
; CHECK-NEXT:    vmv.v.x v26, a1
; CHECK-NEXT:    vsll.vx v26, v26, a0
; CHECK-NEXT:    vsrl.vx v26, v26, a0
; CHECK-NEXT:    vor.vv v25, v26, v25
; CHECK-NEXT:    vmulh.vv v25, v8, v25
; CHECK-NEXT:    vsra.vi v26, v25, 1
; CHECK-NEXT:    addi a0, zero, 63
; CHECK-NEXT:    vsrl.vx v25, v25, a0
; CHECK-NEXT:    vand.vi v25, v25, -1
; CHECK-NEXT:    vadd.vv v25, v26, v25
; CHECK-NEXT:    addi a0, zero, -7
; CHECK-NEXT:    vmul.vx v25, v25, a0
; CHECK-NEXT:    vsub.vv v8, v8, v25
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 1 x i64> undef, i64 -7, i32 0
  %splat = shufflevector <vscale x 1 x i64> %head, <vscale x 1 x i64> undef, <vscale x 1 x i32> zeroinitializer
  %vc = srem <vscale x 1 x i64> %va, %splat
  ret <vscale x 1 x i64> %vc
}

define <vscale x 2 x i64> @vrem_vv_nxv2i64(<vscale x 2 x i64> %va, <vscale x 2 x i64> %vb) {
; CHECK-LABEL: vrem_vv_nxv2i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64,m2,ta,mu
; CHECK-NEXT:    vrem.vv v8, v8, v10
; CHECK-NEXT:    ret
  %vc = srem <vscale x 2 x i64> %va, %vb
  ret <vscale x 2 x i64> %vc
}

define <vscale x 2 x i64> @vrem_vx_nxv2i64(<vscale x 2 x i64> %va, i64 %b) {
; CHECK-LABEL: vrem_vx_nxv2i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a2, zero, e64,m2,ta,mu
; CHECK-NEXT:    vmv.v.x v26, a1
; CHECK-NEXT:    addi a1, zero, 32
; CHECK-NEXT:    vsll.vx v26, v26, a1
; CHECK-NEXT:    vmv.v.x v28, a0
; CHECK-NEXT:    vsll.vx v28, v28, a1
; CHECK-NEXT:    vsrl.vx v28, v28, a1
; CHECK-NEXT:    vor.vv v26, v28, v26
; CHECK-NEXT:    vrem.vv v8, v8, v26
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 2 x i64> undef, i64 %b, i32 0
  %splat = shufflevector <vscale x 2 x i64> %head, <vscale x 2 x i64> undef, <vscale x 2 x i32> zeroinitializer
  %vc = srem <vscale x 2 x i64> %va, %splat
  ret <vscale x 2 x i64> %vc
}

define <vscale x 2 x i64> @vrem_vi_nxv2i64_0(<vscale x 2 x i64> %va) {
; CHECK-LABEL: vrem_vi_nxv2i64_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a0, 748983
; CHECK-NEXT:    addi a0, a0, -586
; CHECK-NEXT:    vsetvli a1, zero, e64,m2,ta,mu
; CHECK-NEXT:    vmv.v.x v26, a0
; CHECK-NEXT:    addi a0, zero, 32
; CHECK-NEXT:    vsll.vx v26, v26, a0
; CHECK-NEXT:    lui a1, 898779
; CHECK-NEXT:    addi a1, a1, 1755
; CHECK-NEXT:    vmv.v.x v28, a1
; CHECK-NEXT:    vsll.vx v28, v28, a0
; CHECK-NEXT:    vsrl.vx v28, v28, a0
; CHECK-NEXT:    vor.vv v26, v28, v26
; CHECK-NEXT:    vmulh.vv v26, v8, v26
; CHECK-NEXT:    vsra.vi v28, v26, 1
; CHECK-NEXT:    addi a0, zero, 63
; CHECK-NEXT:    vsrl.vx v26, v26, a0
; CHECK-NEXT:    vand.vi v26, v26, -1
; CHECK-NEXT:    vadd.vv v26, v28, v26
; CHECK-NEXT:    addi a0, zero, -7
; CHECK-NEXT:    vmul.vx v26, v26, a0
; CHECK-NEXT:    vsub.vv v8, v8, v26
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 2 x i64> undef, i64 -7, i32 0
  %splat = shufflevector <vscale x 2 x i64> %head, <vscale x 2 x i64> undef, <vscale x 2 x i32> zeroinitializer
  %vc = srem <vscale x 2 x i64> %va, %splat
  ret <vscale x 2 x i64> %vc
}

define <vscale x 4 x i64> @vrem_vv_nxv4i64(<vscale x 4 x i64> %va, <vscale x 4 x i64> %vb) {
; CHECK-LABEL: vrem_vv_nxv4i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64,m4,ta,mu
; CHECK-NEXT:    vrem.vv v8, v8, v12
; CHECK-NEXT:    ret
  %vc = srem <vscale x 4 x i64> %va, %vb
  ret <vscale x 4 x i64> %vc
}

define <vscale x 4 x i64> @vrem_vx_nxv4i64(<vscale x 4 x i64> %va, i64 %b) {
; CHECK-LABEL: vrem_vx_nxv4i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a2, zero, e64,m4,ta,mu
; CHECK-NEXT:    vmv.v.x v28, a1
; CHECK-NEXT:    addi a1, zero, 32
; CHECK-NEXT:    vsll.vx v28, v28, a1
; CHECK-NEXT:    vmv.v.x v12, a0
; CHECK-NEXT:    vsll.vx v12, v12, a1
; CHECK-NEXT:    vsrl.vx v12, v12, a1
; CHECK-NEXT:    vor.vv v28, v12, v28
; CHECK-NEXT:    vrem.vv v8, v8, v28
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 4 x i64> undef, i64 %b, i32 0
  %splat = shufflevector <vscale x 4 x i64> %head, <vscale x 4 x i64> undef, <vscale x 4 x i32> zeroinitializer
  %vc = srem <vscale x 4 x i64> %va, %splat
  ret <vscale x 4 x i64> %vc
}

define <vscale x 4 x i64> @vrem_vi_nxv4i64_0(<vscale x 4 x i64> %va) {
; CHECK-LABEL: vrem_vi_nxv4i64_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a0, 748983
; CHECK-NEXT:    addi a0, a0, -586
; CHECK-NEXT:    vsetvli a1, zero, e64,m4,ta,mu
; CHECK-NEXT:    vmv.v.x v28, a0
; CHECK-NEXT:    addi a0, zero, 32
; CHECK-NEXT:    vsll.vx v28, v28, a0
; CHECK-NEXT:    lui a1, 898779
; CHECK-NEXT:    addi a1, a1, 1755
; CHECK-NEXT:    vmv.v.x v12, a1
; CHECK-NEXT:    vsll.vx v12, v12, a0
; CHECK-NEXT:    vsrl.vx v12, v12, a0
; CHECK-NEXT:    vor.vv v28, v12, v28
; CHECK-NEXT:    vmulh.vv v28, v8, v28
; CHECK-NEXT:    vsra.vi v12, v28, 1
; CHECK-NEXT:    addi a0, zero, 63
; CHECK-NEXT:    vsrl.vx v28, v28, a0
; CHECK-NEXT:    vand.vi v28, v28, -1
; CHECK-NEXT:    vadd.vv v28, v12, v28
; CHECK-NEXT:    addi a0, zero, -7
; CHECK-NEXT:    vmul.vx v28, v28, a0
; CHECK-NEXT:    vsub.vv v8, v8, v28
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 4 x i64> undef, i64 -7, i32 0
  %splat = shufflevector <vscale x 4 x i64> %head, <vscale x 4 x i64> undef, <vscale x 4 x i32> zeroinitializer
  %vc = srem <vscale x 4 x i64> %va, %splat
  ret <vscale x 4 x i64> %vc
}

define <vscale x 8 x i64> @vrem_vv_nxv8i64(<vscale x 8 x i64> %va, <vscale x 8 x i64> %vb) {
; CHECK-LABEL: vrem_vv_nxv8i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64,m8,ta,mu
; CHECK-NEXT:    vrem.vv v8, v8, v16
; CHECK-NEXT:    ret
  %vc = srem <vscale x 8 x i64> %va, %vb
  ret <vscale x 8 x i64> %vc
}

define <vscale x 8 x i64> @vrem_vx_nxv8i64(<vscale x 8 x i64> %va, i64 %b) {
; CHECK-LABEL: vrem_vx_nxv8i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a2, zero, e64,m8,ta,mu
; CHECK-NEXT:    vmv.v.x v16, a1
; CHECK-NEXT:    addi a1, zero, 32
; CHECK-NEXT:    vsll.vx v16, v16, a1
; CHECK-NEXT:    vmv.v.x v24, a0
; CHECK-NEXT:    vsll.vx v24, v24, a1
; CHECK-NEXT:    vsrl.vx v24, v24, a1
; CHECK-NEXT:    vor.vv v16, v24, v16
; CHECK-NEXT:    vrem.vv v8, v8, v16
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x i64> undef, i64 %b, i32 0
  %splat = shufflevector <vscale x 8 x i64> %head, <vscale x 8 x i64> undef, <vscale x 8 x i32> zeroinitializer
  %vc = srem <vscale x 8 x i64> %va, %splat
  ret <vscale x 8 x i64> %vc
}

define <vscale x 8 x i64> @vrem_vi_nxv8i64_0(<vscale x 8 x i64> %va) {
; CHECK-LABEL: vrem_vi_nxv8i64_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a0, 748983
; CHECK-NEXT:    addi a0, a0, -586
; CHECK-NEXT:    vsetvli a1, zero, e64,m8,ta,mu
; CHECK-NEXT:    vmv.v.x v16, a0
; CHECK-NEXT:    addi a0, zero, 32
; CHECK-NEXT:    vsll.vx v16, v16, a0
; CHECK-NEXT:    lui a1, 898779
; CHECK-NEXT:    addi a1, a1, 1755
; CHECK-NEXT:    vmv.v.x v24, a1
; CHECK-NEXT:    vsll.vx v24, v24, a0
; CHECK-NEXT:    vsrl.vx v24, v24, a0
; CHECK-NEXT:    vor.vv v16, v24, v16
; CHECK-NEXT:    vmulh.vv v16, v8, v16
; CHECK-NEXT:    vsra.vi v24, v16, 1
; CHECK-NEXT:    addi a0, zero, 63
; CHECK-NEXT:    vsrl.vx v16, v16, a0
; CHECK-NEXT:    vand.vi v16, v16, -1
; CHECK-NEXT:    vadd.vv v16, v24, v16
; CHECK-NEXT:    addi a0, zero, -7
; CHECK-NEXT:    vmul.vx v16, v16, a0
; CHECK-NEXT:    vsub.vv v8, v8, v16
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x i64> undef, i64 -7, i32 0
  %splat = shufflevector <vscale x 8 x i64> %head, <vscale x 8 x i64> undef, <vscale x 8 x i32> zeroinitializer
  %vc = srem <vscale x 8 x i64> %va, %splat
  ret <vscale x 8 x i64> %vc
}

