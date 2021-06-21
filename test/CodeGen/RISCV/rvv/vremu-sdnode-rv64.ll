; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv64 -mattr=+experimental-v -verify-machineinstrs < %s | FileCheck %s

define <vscale x 1 x i8> @vremu_vv_nxv1i8(<vscale x 1 x i8> %va, <vscale x 1 x i8> %vb) {
; CHECK-LABEL: vremu_vv_nxv1i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e8, mf8, ta, mu
; CHECK-NEXT:    vremu.vv v8, v8, v9
; CHECK-NEXT:    ret
  %vc = urem <vscale x 1 x i8> %va, %vb
  ret <vscale x 1 x i8> %vc
}

define <vscale x 1 x i8> @vremu_vx_nxv1i8(<vscale x 1 x i8> %va, i8 signext %b) {
; CHECK-LABEL: vremu_vx_nxv1i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e8, mf8, ta, mu
; CHECK-NEXT:    vremu.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 1 x i8> undef, i8 %b, i32 0
  %splat = shufflevector <vscale x 1 x i8> %head, <vscale x 1 x i8> undef, <vscale x 1 x i32> zeroinitializer
  %vc = urem <vscale x 1 x i8> %va, %splat
  ret <vscale x 1 x i8> %vc
}

define <vscale x 1 x i8> @vremu_vi_nxv1i8_0(<vscale x 1 x i8> %va) {
; CHECK-LABEL: vremu_vi_nxv1i8_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a0, zero, 33
; CHECK-NEXT:    vsetvli a1, zero, e8, mf8, ta, mu
; CHECK-NEXT:    vmulhu.vx v25, v8, a0
; CHECK-NEXT:    vsrl.vi v25, v25, 5
; CHECK-NEXT:    addi a0, zero, -7
; CHECK-NEXT:    vnmsac.vx v8, a0, v25
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 1 x i8> undef, i8 -7, i32 0
  %splat = shufflevector <vscale x 1 x i8> %head, <vscale x 1 x i8> undef, <vscale x 1 x i32> zeroinitializer
  %vc = urem <vscale x 1 x i8> %va, %splat
  ret <vscale x 1 x i8> %vc
}

define <vscale x 2 x i8> @vremu_vv_nxv2i8(<vscale x 2 x i8> %va, <vscale x 2 x i8> %vb) {
; CHECK-LABEL: vremu_vv_nxv2i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e8, mf4, ta, mu
; CHECK-NEXT:    vremu.vv v8, v8, v9
; CHECK-NEXT:    ret
  %vc = urem <vscale x 2 x i8> %va, %vb
  ret <vscale x 2 x i8> %vc
}

define <vscale x 2 x i8> @vremu_vx_nxv2i8(<vscale x 2 x i8> %va, i8 signext %b) {
; CHECK-LABEL: vremu_vx_nxv2i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e8, mf4, ta, mu
; CHECK-NEXT:    vremu.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 2 x i8> undef, i8 %b, i32 0
  %splat = shufflevector <vscale x 2 x i8> %head, <vscale x 2 x i8> undef, <vscale x 2 x i32> zeroinitializer
  %vc = urem <vscale x 2 x i8> %va, %splat
  ret <vscale x 2 x i8> %vc
}

define <vscale x 2 x i8> @vremu_vi_nxv2i8_0(<vscale x 2 x i8> %va) {
; CHECK-LABEL: vremu_vi_nxv2i8_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a0, zero, 33
; CHECK-NEXT:    vsetvli a1, zero, e8, mf4, ta, mu
; CHECK-NEXT:    vmulhu.vx v25, v8, a0
; CHECK-NEXT:    vsrl.vi v25, v25, 5
; CHECK-NEXT:    addi a0, zero, -7
; CHECK-NEXT:    vnmsac.vx v8, a0, v25
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 2 x i8> undef, i8 -7, i32 0
  %splat = shufflevector <vscale x 2 x i8> %head, <vscale x 2 x i8> undef, <vscale x 2 x i32> zeroinitializer
  %vc = urem <vscale x 2 x i8> %va, %splat
  ret <vscale x 2 x i8> %vc
}

define <vscale x 4 x i8> @vremu_vv_nxv4i8(<vscale x 4 x i8> %va, <vscale x 4 x i8> %vb) {
; CHECK-LABEL: vremu_vv_nxv4i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e8, mf2, ta, mu
; CHECK-NEXT:    vremu.vv v8, v8, v9
; CHECK-NEXT:    ret
  %vc = urem <vscale x 4 x i8> %va, %vb
  ret <vscale x 4 x i8> %vc
}

define <vscale x 4 x i8> @vremu_vx_nxv4i8(<vscale x 4 x i8> %va, i8 signext %b) {
; CHECK-LABEL: vremu_vx_nxv4i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e8, mf2, ta, mu
; CHECK-NEXT:    vremu.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 4 x i8> undef, i8 %b, i32 0
  %splat = shufflevector <vscale x 4 x i8> %head, <vscale x 4 x i8> undef, <vscale x 4 x i32> zeroinitializer
  %vc = urem <vscale x 4 x i8> %va, %splat
  ret <vscale x 4 x i8> %vc
}

define <vscale x 4 x i8> @vremu_vi_nxv4i8_0(<vscale x 4 x i8> %va) {
; CHECK-LABEL: vremu_vi_nxv4i8_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a0, zero, 33
; CHECK-NEXT:    vsetvli a1, zero, e8, mf2, ta, mu
; CHECK-NEXT:    vmulhu.vx v25, v8, a0
; CHECK-NEXT:    vsrl.vi v25, v25, 5
; CHECK-NEXT:    addi a0, zero, -7
; CHECK-NEXT:    vnmsac.vx v8, a0, v25
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 4 x i8> undef, i8 -7, i32 0
  %splat = shufflevector <vscale x 4 x i8> %head, <vscale x 4 x i8> undef, <vscale x 4 x i32> zeroinitializer
  %vc = urem <vscale x 4 x i8> %va, %splat
  ret <vscale x 4 x i8> %vc
}

define <vscale x 8 x i8> @vremu_vv_nxv8i8(<vscale x 8 x i8> %va, <vscale x 8 x i8> %vb) {
; CHECK-LABEL: vremu_vv_nxv8i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e8, m1, ta, mu
; CHECK-NEXT:    vremu.vv v8, v8, v9
; CHECK-NEXT:    ret
  %vc = urem <vscale x 8 x i8> %va, %vb
  ret <vscale x 8 x i8> %vc
}

define <vscale x 8 x i8> @vremu_vx_nxv8i8(<vscale x 8 x i8> %va, i8 signext %b) {
; CHECK-LABEL: vremu_vx_nxv8i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e8, m1, ta, mu
; CHECK-NEXT:    vremu.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x i8> undef, i8 %b, i32 0
  %splat = shufflevector <vscale x 8 x i8> %head, <vscale x 8 x i8> undef, <vscale x 8 x i32> zeroinitializer
  %vc = urem <vscale x 8 x i8> %va, %splat
  ret <vscale x 8 x i8> %vc
}

define <vscale x 8 x i8> @vremu_vi_nxv8i8_0(<vscale x 8 x i8> %va) {
; CHECK-LABEL: vremu_vi_nxv8i8_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a0, zero, 33
; CHECK-NEXT:    vsetvli a1, zero, e8, m1, ta, mu
; CHECK-NEXT:    vmulhu.vx v25, v8, a0
; CHECK-NEXT:    vsrl.vi v25, v25, 5
; CHECK-NEXT:    addi a0, zero, -7
; CHECK-NEXT:    vnmsac.vx v8, a0, v25
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x i8> undef, i8 -7, i32 0
  %splat = shufflevector <vscale x 8 x i8> %head, <vscale x 8 x i8> undef, <vscale x 8 x i32> zeroinitializer
  %vc = urem <vscale x 8 x i8> %va, %splat
  ret <vscale x 8 x i8> %vc
}

define <vscale x 16 x i8> @vremu_vv_nxv16i8(<vscale x 16 x i8> %va, <vscale x 16 x i8> %vb) {
; CHECK-LABEL: vremu_vv_nxv16i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e8, m2, ta, mu
; CHECK-NEXT:    vremu.vv v8, v8, v10
; CHECK-NEXT:    ret
  %vc = urem <vscale x 16 x i8> %va, %vb
  ret <vscale x 16 x i8> %vc
}

define <vscale x 16 x i8> @vremu_vx_nxv16i8(<vscale x 16 x i8> %va, i8 signext %b) {
; CHECK-LABEL: vremu_vx_nxv16i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e8, m2, ta, mu
; CHECK-NEXT:    vremu.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 16 x i8> undef, i8 %b, i32 0
  %splat = shufflevector <vscale x 16 x i8> %head, <vscale x 16 x i8> undef, <vscale x 16 x i32> zeroinitializer
  %vc = urem <vscale x 16 x i8> %va, %splat
  ret <vscale x 16 x i8> %vc
}

define <vscale x 16 x i8> @vremu_vi_nxv16i8_0(<vscale x 16 x i8> %va) {
; CHECK-LABEL: vremu_vi_nxv16i8_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a0, zero, 33
; CHECK-NEXT:    vsetvli a1, zero, e8, m2, ta, mu
; CHECK-NEXT:    vmulhu.vx v26, v8, a0
; CHECK-NEXT:    vsrl.vi v26, v26, 5
; CHECK-NEXT:    addi a0, zero, -7
; CHECK-NEXT:    vnmsac.vx v8, a0, v26
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 16 x i8> undef, i8 -7, i32 0
  %splat = shufflevector <vscale x 16 x i8> %head, <vscale x 16 x i8> undef, <vscale x 16 x i32> zeroinitializer
  %vc = urem <vscale x 16 x i8> %va, %splat
  ret <vscale x 16 x i8> %vc
}

define <vscale x 32 x i8> @vremu_vv_nxv32i8(<vscale x 32 x i8> %va, <vscale x 32 x i8> %vb) {
; CHECK-LABEL: vremu_vv_nxv32i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e8, m4, ta, mu
; CHECK-NEXT:    vremu.vv v8, v8, v12
; CHECK-NEXT:    ret
  %vc = urem <vscale x 32 x i8> %va, %vb
  ret <vscale x 32 x i8> %vc
}

define <vscale x 32 x i8> @vremu_vx_nxv32i8(<vscale x 32 x i8> %va, i8 signext %b) {
; CHECK-LABEL: vremu_vx_nxv32i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e8, m4, ta, mu
; CHECK-NEXT:    vremu.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 32 x i8> undef, i8 %b, i32 0
  %splat = shufflevector <vscale x 32 x i8> %head, <vscale x 32 x i8> undef, <vscale x 32 x i32> zeroinitializer
  %vc = urem <vscale x 32 x i8> %va, %splat
  ret <vscale x 32 x i8> %vc
}

define <vscale x 32 x i8> @vremu_vi_nxv32i8_0(<vscale x 32 x i8> %va) {
; CHECK-LABEL: vremu_vi_nxv32i8_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a0, zero, 33
; CHECK-NEXT:    vsetvli a1, zero, e8, m4, ta, mu
; CHECK-NEXT:    vmulhu.vx v28, v8, a0
; CHECK-NEXT:    vsrl.vi v28, v28, 5
; CHECK-NEXT:    addi a0, zero, -7
; CHECK-NEXT:    vnmsac.vx v8, a0, v28
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 32 x i8> undef, i8 -7, i32 0
  %splat = shufflevector <vscale x 32 x i8> %head, <vscale x 32 x i8> undef, <vscale x 32 x i32> zeroinitializer
  %vc = urem <vscale x 32 x i8> %va, %splat
  ret <vscale x 32 x i8> %vc
}

define <vscale x 64 x i8> @vremu_vv_nxv64i8(<vscale x 64 x i8> %va, <vscale x 64 x i8> %vb) {
; CHECK-LABEL: vremu_vv_nxv64i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e8, m8, ta, mu
; CHECK-NEXT:    vremu.vv v8, v8, v16
; CHECK-NEXT:    ret
  %vc = urem <vscale x 64 x i8> %va, %vb
  ret <vscale x 64 x i8> %vc
}

define <vscale x 64 x i8> @vremu_vx_nxv64i8(<vscale x 64 x i8> %va, i8 signext %b) {
; CHECK-LABEL: vremu_vx_nxv64i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e8, m8, ta, mu
; CHECK-NEXT:    vremu.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 64 x i8> undef, i8 %b, i32 0
  %splat = shufflevector <vscale x 64 x i8> %head, <vscale x 64 x i8> undef, <vscale x 64 x i32> zeroinitializer
  %vc = urem <vscale x 64 x i8> %va, %splat
  ret <vscale x 64 x i8> %vc
}

define <vscale x 64 x i8> @vremu_vi_nxv64i8_0(<vscale x 64 x i8> %va) {
; CHECK-LABEL: vremu_vi_nxv64i8_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a0, zero, 33
; CHECK-NEXT:    vsetvli a1, zero, e8, m8, ta, mu
; CHECK-NEXT:    vmulhu.vx v16, v8, a0
; CHECK-NEXT:    vsrl.vi v16, v16, 5
; CHECK-NEXT:    addi a0, zero, -7
; CHECK-NEXT:    vnmsac.vx v8, a0, v16
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 64 x i8> undef, i8 -7, i32 0
  %splat = shufflevector <vscale x 64 x i8> %head, <vscale x 64 x i8> undef, <vscale x 64 x i32> zeroinitializer
  %vc = urem <vscale x 64 x i8> %va, %splat
  ret <vscale x 64 x i8> %vc
}

define <vscale x 1 x i16> @vremu_vv_nxv1i16(<vscale x 1 x i16> %va, <vscale x 1 x i16> %vb) {
; CHECK-LABEL: vremu_vv_nxv1i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16, mf4, ta, mu
; CHECK-NEXT:    vremu.vv v8, v8, v9
; CHECK-NEXT:    ret
  %vc = urem <vscale x 1 x i16> %va, %vb
  ret <vscale x 1 x i16> %vc
}

define <vscale x 1 x i16> @vremu_vx_nxv1i16(<vscale x 1 x i16> %va, i16 signext %b) {
; CHECK-LABEL: vremu_vx_nxv1i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e16, mf4, ta, mu
; CHECK-NEXT:    vremu.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 1 x i16> undef, i16 %b, i32 0
  %splat = shufflevector <vscale x 1 x i16> %head, <vscale x 1 x i16> undef, <vscale x 1 x i32> zeroinitializer
  %vc = urem <vscale x 1 x i16> %va, %splat
  ret <vscale x 1 x i16> %vc
}

define <vscale x 1 x i16> @vremu_vi_nxv1i16_0(<vscale x 1 x i16> %va) {
; CHECK-LABEL: vremu_vi_nxv1i16_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a0, 2
; CHECK-NEXT:    addiw a0, a0, 1
; CHECK-NEXT:    vsetvli a1, zero, e16, mf4, ta, mu
; CHECK-NEXT:    vmulhu.vx v25, v8, a0
; CHECK-NEXT:    vsrl.vi v25, v25, 13
; CHECK-NEXT:    addi a0, zero, -7
; CHECK-NEXT:    vnmsac.vx v8, a0, v25
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 1 x i16> undef, i16 -7, i32 0
  %splat = shufflevector <vscale x 1 x i16> %head, <vscale x 1 x i16> undef, <vscale x 1 x i32> zeroinitializer
  %vc = urem <vscale x 1 x i16> %va, %splat
  ret <vscale x 1 x i16> %vc
}

define <vscale x 2 x i16> @vremu_vv_nxv2i16(<vscale x 2 x i16> %va, <vscale x 2 x i16> %vb) {
; CHECK-LABEL: vremu_vv_nxv2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16, mf2, ta, mu
; CHECK-NEXT:    vremu.vv v8, v8, v9
; CHECK-NEXT:    ret
  %vc = urem <vscale x 2 x i16> %va, %vb
  ret <vscale x 2 x i16> %vc
}

define <vscale x 2 x i16> @vremu_vx_nxv2i16(<vscale x 2 x i16> %va, i16 signext %b) {
; CHECK-LABEL: vremu_vx_nxv2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e16, mf2, ta, mu
; CHECK-NEXT:    vremu.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 2 x i16> undef, i16 %b, i32 0
  %splat = shufflevector <vscale x 2 x i16> %head, <vscale x 2 x i16> undef, <vscale x 2 x i32> zeroinitializer
  %vc = urem <vscale x 2 x i16> %va, %splat
  ret <vscale x 2 x i16> %vc
}

define <vscale x 2 x i16> @vremu_vi_nxv2i16_0(<vscale x 2 x i16> %va) {
; CHECK-LABEL: vremu_vi_nxv2i16_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a0, 2
; CHECK-NEXT:    addiw a0, a0, 1
; CHECK-NEXT:    vsetvli a1, zero, e16, mf2, ta, mu
; CHECK-NEXT:    vmulhu.vx v25, v8, a0
; CHECK-NEXT:    vsrl.vi v25, v25, 13
; CHECK-NEXT:    addi a0, zero, -7
; CHECK-NEXT:    vnmsac.vx v8, a0, v25
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 2 x i16> undef, i16 -7, i32 0
  %splat = shufflevector <vscale x 2 x i16> %head, <vscale x 2 x i16> undef, <vscale x 2 x i32> zeroinitializer
  %vc = urem <vscale x 2 x i16> %va, %splat
  ret <vscale x 2 x i16> %vc
}

define <vscale x 4 x i16> @vremu_vv_nxv4i16(<vscale x 4 x i16> %va, <vscale x 4 x i16> %vb) {
; CHECK-LABEL: vremu_vv_nxv4i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16, m1, ta, mu
; CHECK-NEXT:    vremu.vv v8, v8, v9
; CHECK-NEXT:    ret
  %vc = urem <vscale x 4 x i16> %va, %vb
  ret <vscale x 4 x i16> %vc
}

define <vscale x 4 x i16> @vremu_vx_nxv4i16(<vscale x 4 x i16> %va, i16 signext %b) {
; CHECK-LABEL: vremu_vx_nxv4i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e16, m1, ta, mu
; CHECK-NEXT:    vremu.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 4 x i16> undef, i16 %b, i32 0
  %splat = shufflevector <vscale x 4 x i16> %head, <vscale x 4 x i16> undef, <vscale x 4 x i32> zeroinitializer
  %vc = urem <vscale x 4 x i16> %va, %splat
  ret <vscale x 4 x i16> %vc
}

define <vscale x 4 x i16> @vremu_vi_nxv4i16_0(<vscale x 4 x i16> %va) {
; CHECK-LABEL: vremu_vi_nxv4i16_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a0, 2
; CHECK-NEXT:    addiw a0, a0, 1
; CHECK-NEXT:    vsetvli a1, zero, e16, m1, ta, mu
; CHECK-NEXT:    vmulhu.vx v25, v8, a0
; CHECK-NEXT:    vsrl.vi v25, v25, 13
; CHECK-NEXT:    addi a0, zero, -7
; CHECK-NEXT:    vnmsac.vx v8, a0, v25
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 4 x i16> undef, i16 -7, i32 0
  %splat = shufflevector <vscale x 4 x i16> %head, <vscale x 4 x i16> undef, <vscale x 4 x i32> zeroinitializer
  %vc = urem <vscale x 4 x i16> %va, %splat
  ret <vscale x 4 x i16> %vc
}

define <vscale x 8 x i16> @vremu_vv_nxv8i16(<vscale x 8 x i16> %va, <vscale x 8 x i16> %vb) {
; CHECK-LABEL: vremu_vv_nxv8i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16, m2, ta, mu
; CHECK-NEXT:    vremu.vv v8, v8, v10
; CHECK-NEXT:    ret
  %vc = urem <vscale x 8 x i16> %va, %vb
  ret <vscale x 8 x i16> %vc
}

define <vscale x 8 x i16> @vremu_vx_nxv8i16(<vscale x 8 x i16> %va, i16 signext %b) {
; CHECK-LABEL: vremu_vx_nxv8i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e16, m2, ta, mu
; CHECK-NEXT:    vremu.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x i16> undef, i16 %b, i32 0
  %splat = shufflevector <vscale x 8 x i16> %head, <vscale x 8 x i16> undef, <vscale x 8 x i32> zeroinitializer
  %vc = urem <vscale x 8 x i16> %va, %splat
  ret <vscale x 8 x i16> %vc
}

define <vscale x 8 x i16> @vremu_vi_nxv8i16_0(<vscale x 8 x i16> %va) {
; CHECK-LABEL: vremu_vi_nxv8i16_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a0, 2
; CHECK-NEXT:    addiw a0, a0, 1
; CHECK-NEXT:    vsetvli a1, zero, e16, m2, ta, mu
; CHECK-NEXT:    vmulhu.vx v26, v8, a0
; CHECK-NEXT:    vsrl.vi v26, v26, 13
; CHECK-NEXT:    addi a0, zero, -7
; CHECK-NEXT:    vnmsac.vx v8, a0, v26
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x i16> undef, i16 -7, i32 0
  %splat = shufflevector <vscale x 8 x i16> %head, <vscale x 8 x i16> undef, <vscale x 8 x i32> zeroinitializer
  %vc = urem <vscale x 8 x i16> %va, %splat
  ret <vscale x 8 x i16> %vc
}

define <vscale x 16 x i16> @vremu_vv_nxv16i16(<vscale x 16 x i16> %va, <vscale x 16 x i16> %vb) {
; CHECK-LABEL: vremu_vv_nxv16i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16, m4, ta, mu
; CHECK-NEXT:    vremu.vv v8, v8, v12
; CHECK-NEXT:    ret
  %vc = urem <vscale x 16 x i16> %va, %vb
  ret <vscale x 16 x i16> %vc
}

define <vscale x 16 x i16> @vremu_vx_nxv16i16(<vscale x 16 x i16> %va, i16 signext %b) {
; CHECK-LABEL: vremu_vx_nxv16i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e16, m4, ta, mu
; CHECK-NEXT:    vremu.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 16 x i16> undef, i16 %b, i32 0
  %splat = shufflevector <vscale x 16 x i16> %head, <vscale x 16 x i16> undef, <vscale x 16 x i32> zeroinitializer
  %vc = urem <vscale x 16 x i16> %va, %splat
  ret <vscale x 16 x i16> %vc
}

define <vscale x 16 x i16> @vremu_vi_nxv16i16_0(<vscale x 16 x i16> %va) {
; CHECK-LABEL: vremu_vi_nxv16i16_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a0, 2
; CHECK-NEXT:    addiw a0, a0, 1
; CHECK-NEXT:    vsetvli a1, zero, e16, m4, ta, mu
; CHECK-NEXT:    vmulhu.vx v28, v8, a0
; CHECK-NEXT:    vsrl.vi v28, v28, 13
; CHECK-NEXT:    addi a0, zero, -7
; CHECK-NEXT:    vnmsac.vx v8, a0, v28
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 16 x i16> undef, i16 -7, i32 0
  %splat = shufflevector <vscale x 16 x i16> %head, <vscale x 16 x i16> undef, <vscale x 16 x i32> zeroinitializer
  %vc = urem <vscale x 16 x i16> %va, %splat
  ret <vscale x 16 x i16> %vc
}

define <vscale x 32 x i16> @vremu_vv_nxv32i16(<vscale x 32 x i16> %va, <vscale x 32 x i16> %vb) {
; CHECK-LABEL: vremu_vv_nxv32i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16, m8, ta, mu
; CHECK-NEXT:    vremu.vv v8, v8, v16
; CHECK-NEXT:    ret
  %vc = urem <vscale x 32 x i16> %va, %vb
  ret <vscale x 32 x i16> %vc
}

define <vscale x 32 x i16> @vremu_vx_nxv32i16(<vscale x 32 x i16> %va, i16 signext %b) {
; CHECK-LABEL: vremu_vx_nxv32i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e16, m8, ta, mu
; CHECK-NEXT:    vremu.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 32 x i16> undef, i16 %b, i32 0
  %splat = shufflevector <vscale x 32 x i16> %head, <vscale x 32 x i16> undef, <vscale x 32 x i32> zeroinitializer
  %vc = urem <vscale x 32 x i16> %va, %splat
  ret <vscale x 32 x i16> %vc
}

define <vscale x 32 x i16> @vremu_vi_nxv32i16_0(<vscale x 32 x i16> %va) {
; CHECK-LABEL: vremu_vi_nxv32i16_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a0, 2
; CHECK-NEXT:    addiw a0, a0, 1
; CHECK-NEXT:    vsetvli a1, zero, e16, m8, ta, mu
; CHECK-NEXT:    vmulhu.vx v16, v8, a0
; CHECK-NEXT:    vsrl.vi v16, v16, 13
; CHECK-NEXT:    addi a0, zero, -7
; CHECK-NEXT:    vnmsac.vx v8, a0, v16
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 32 x i16> undef, i16 -7, i32 0
  %splat = shufflevector <vscale x 32 x i16> %head, <vscale x 32 x i16> undef, <vscale x 32 x i32> zeroinitializer
  %vc = urem <vscale x 32 x i16> %va, %splat
  ret <vscale x 32 x i16> %vc
}

define <vscale x 1 x i32> @vremu_vv_nxv1i32(<vscale x 1 x i32> %va, <vscale x 1 x i32> %vb) {
; CHECK-LABEL: vremu_vv_nxv1i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, mf2, ta, mu
; CHECK-NEXT:    vremu.vv v8, v8, v9
; CHECK-NEXT:    ret
  %vc = urem <vscale x 1 x i32> %va, %vb
  ret <vscale x 1 x i32> %vc
}

define <vscale x 1 x i32> @vremu_vx_nxv1i32(<vscale x 1 x i32> %va, i32 signext %b) {
; CHECK-LABEL: vremu_vx_nxv1i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32, mf2, ta, mu
; CHECK-NEXT:    vremu.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 1 x i32> undef, i32 %b, i32 0
  %splat = shufflevector <vscale x 1 x i32> %head, <vscale x 1 x i32> undef, <vscale x 1 x i32> zeroinitializer
  %vc = urem <vscale x 1 x i32> %va, %splat
  ret <vscale x 1 x i32> %vc
}

define <vscale x 1 x i32> @vremu_vi_nxv1i32_0(<vscale x 1 x i32> %va) {
; CHECK-LABEL: vremu_vi_nxv1i32_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a0, 131072
; CHECK-NEXT:    addiw a0, a0, 1
; CHECK-NEXT:    vsetvli a1, zero, e32, mf2, ta, mu
; CHECK-NEXT:    vmulhu.vx v25, v8, a0
; CHECK-NEXT:    vsrl.vi v25, v25, 29
; CHECK-NEXT:    addi a0, zero, -7
; CHECK-NEXT:    vnmsac.vx v8, a0, v25
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 1 x i32> undef, i32 -7, i32 0
  %splat = shufflevector <vscale x 1 x i32> %head, <vscale x 1 x i32> undef, <vscale x 1 x i32> zeroinitializer
  %vc = urem <vscale x 1 x i32> %va, %splat
  ret <vscale x 1 x i32> %vc
}

define <vscale x 2 x i32> @vremu_vv_nxv2i32(<vscale x 2 x i32> %va, <vscale x 2 x i32> %vb) {
; CHECK-LABEL: vremu_vv_nxv2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m1, ta, mu
; CHECK-NEXT:    vremu.vv v8, v8, v9
; CHECK-NEXT:    ret
  %vc = urem <vscale x 2 x i32> %va, %vb
  ret <vscale x 2 x i32> %vc
}

define <vscale x 2 x i32> @vremu_vx_nxv2i32(<vscale x 2 x i32> %va, i32 signext %b) {
; CHECK-LABEL: vremu_vx_nxv2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32, m1, ta, mu
; CHECK-NEXT:    vremu.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 2 x i32> undef, i32 %b, i32 0
  %splat = shufflevector <vscale x 2 x i32> %head, <vscale x 2 x i32> undef, <vscale x 2 x i32> zeroinitializer
  %vc = urem <vscale x 2 x i32> %va, %splat
  ret <vscale x 2 x i32> %vc
}

define <vscale x 2 x i32> @vremu_vi_nxv2i32_0(<vscale x 2 x i32> %va) {
; CHECK-LABEL: vremu_vi_nxv2i32_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a0, 131072
; CHECK-NEXT:    addiw a0, a0, 1
; CHECK-NEXT:    vsetvli a1, zero, e32, m1, ta, mu
; CHECK-NEXT:    vmulhu.vx v25, v8, a0
; CHECK-NEXT:    vsrl.vi v25, v25, 29
; CHECK-NEXT:    addi a0, zero, -7
; CHECK-NEXT:    vnmsac.vx v8, a0, v25
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 2 x i32> undef, i32 -7, i32 0
  %splat = shufflevector <vscale x 2 x i32> %head, <vscale x 2 x i32> undef, <vscale x 2 x i32> zeroinitializer
  %vc = urem <vscale x 2 x i32> %va, %splat
  ret <vscale x 2 x i32> %vc
}

define <vscale x 4 x i32> @vremu_vv_nxv4i32(<vscale x 4 x i32> %va, <vscale x 4 x i32> %vb) {
; CHECK-LABEL: vremu_vv_nxv4i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m2, ta, mu
; CHECK-NEXT:    vremu.vv v8, v8, v10
; CHECK-NEXT:    ret
  %vc = urem <vscale x 4 x i32> %va, %vb
  ret <vscale x 4 x i32> %vc
}

define <vscale x 4 x i32> @vremu_vx_nxv4i32(<vscale x 4 x i32> %va, i32 signext %b) {
; CHECK-LABEL: vremu_vx_nxv4i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32, m2, ta, mu
; CHECK-NEXT:    vremu.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 4 x i32> undef, i32 %b, i32 0
  %splat = shufflevector <vscale x 4 x i32> %head, <vscale x 4 x i32> undef, <vscale x 4 x i32> zeroinitializer
  %vc = urem <vscale x 4 x i32> %va, %splat
  ret <vscale x 4 x i32> %vc
}

define <vscale x 4 x i32> @vremu_vi_nxv4i32_0(<vscale x 4 x i32> %va) {
; CHECK-LABEL: vremu_vi_nxv4i32_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a0, 131072
; CHECK-NEXT:    addiw a0, a0, 1
; CHECK-NEXT:    vsetvli a1, zero, e32, m2, ta, mu
; CHECK-NEXT:    vmulhu.vx v26, v8, a0
; CHECK-NEXT:    vsrl.vi v26, v26, 29
; CHECK-NEXT:    addi a0, zero, -7
; CHECK-NEXT:    vnmsac.vx v8, a0, v26
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 4 x i32> undef, i32 -7, i32 0
  %splat = shufflevector <vscale x 4 x i32> %head, <vscale x 4 x i32> undef, <vscale x 4 x i32> zeroinitializer
  %vc = urem <vscale x 4 x i32> %va, %splat
  ret <vscale x 4 x i32> %vc
}

define <vscale x 8 x i32> @vremu_vv_nxv8i32(<vscale x 8 x i32> %va, <vscale x 8 x i32> %vb) {
; CHECK-LABEL: vremu_vv_nxv8i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m4, ta, mu
; CHECK-NEXT:    vremu.vv v8, v8, v12
; CHECK-NEXT:    ret
  %vc = urem <vscale x 8 x i32> %va, %vb
  ret <vscale x 8 x i32> %vc
}

define <vscale x 8 x i32> @vremu_vx_nxv8i32(<vscale x 8 x i32> %va, i32 signext %b) {
; CHECK-LABEL: vremu_vx_nxv8i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32, m4, ta, mu
; CHECK-NEXT:    vremu.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x i32> undef, i32 %b, i32 0
  %splat = shufflevector <vscale x 8 x i32> %head, <vscale x 8 x i32> undef, <vscale x 8 x i32> zeroinitializer
  %vc = urem <vscale x 8 x i32> %va, %splat
  ret <vscale x 8 x i32> %vc
}

define <vscale x 8 x i32> @vremu_vi_nxv8i32_0(<vscale x 8 x i32> %va) {
; CHECK-LABEL: vremu_vi_nxv8i32_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a0, 131072
; CHECK-NEXT:    addiw a0, a0, 1
; CHECK-NEXT:    vsetvli a1, zero, e32, m4, ta, mu
; CHECK-NEXT:    vmulhu.vx v28, v8, a0
; CHECK-NEXT:    vsrl.vi v28, v28, 29
; CHECK-NEXT:    addi a0, zero, -7
; CHECK-NEXT:    vnmsac.vx v8, a0, v28
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x i32> undef, i32 -7, i32 0
  %splat = shufflevector <vscale x 8 x i32> %head, <vscale x 8 x i32> undef, <vscale x 8 x i32> zeroinitializer
  %vc = urem <vscale x 8 x i32> %va, %splat
  ret <vscale x 8 x i32> %vc
}

define <vscale x 16 x i32> @vremu_vv_nxv16i32(<vscale x 16 x i32> %va, <vscale x 16 x i32> %vb) {
; CHECK-LABEL: vremu_vv_nxv16i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m8, ta, mu
; CHECK-NEXT:    vremu.vv v8, v8, v16
; CHECK-NEXT:    ret
  %vc = urem <vscale x 16 x i32> %va, %vb
  ret <vscale x 16 x i32> %vc
}

define <vscale x 16 x i32> @vremu_vx_nxv16i32(<vscale x 16 x i32> %va, i32 signext %b) {
; CHECK-LABEL: vremu_vx_nxv16i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32, m8, ta, mu
; CHECK-NEXT:    vremu.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 16 x i32> undef, i32 %b, i32 0
  %splat = shufflevector <vscale x 16 x i32> %head, <vscale x 16 x i32> undef, <vscale x 16 x i32> zeroinitializer
  %vc = urem <vscale x 16 x i32> %va, %splat
  ret <vscale x 16 x i32> %vc
}

define <vscale x 16 x i32> @vremu_vi_nxv16i32_0(<vscale x 16 x i32> %va) {
; CHECK-LABEL: vremu_vi_nxv16i32_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a0, 131072
; CHECK-NEXT:    addiw a0, a0, 1
; CHECK-NEXT:    vsetvli a1, zero, e32, m8, ta, mu
; CHECK-NEXT:    vmulhu.vx v16, v8, a0
; CHECK-NEXT:    vsrl.vi v16, v16, 29
; CHECK-NEXT:    addi a0, zero, -7
; CHECK-NEXT:    vnmsac.vx v8, a0, v16
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 16 x i32> undef, i32 -7, i32 0
  %splat = shufflevector <vscale x 16 x i32> %head, <vscale x 16 x i32> undef, <vscale x 16 x i32> zeroinitializer
  %vc = urem <vscale x 16 x i32> %va, %splat
  ret <vscale x 16 x i32> %vc
}

define <vscale x 1 x i64> @vremu_vv_nxv1i64(<vscale x 1 x i64> %va, <vscale x 1 x i64> %vb) {
; CHECK-LABEL: vremu_vv_nxv1i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m1, ta, mu
; CHECK-NEXT:    vremu.vv v8, v8, v9
; CHECK-NEXT:    ret
  %vc = urem <vscale x 1 x i64> %va, %vb
  ret <vscale x 1 x i64> %vc
}

define <vscale x 1 x i64> @vremu_vx_nxv1i64(<vscale x 1 x i64> %va, i64 %b) {
; CHECK-LABEL: vremu_vx_nxv1i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e64, m1, ta, mu
; CHECK-NEXT:    vremu.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 1 x i64> undef, i64 %b, i32 0
  %splat = shufflevector <vscale x 1 x i64> %head, <vscale x 1 x i64> undef, <vscale x 1 x i32> zeroinitializer
  %vc = urem <vscale x 1 x i64> %va, %splat
  ret <vscale x 1 x i64> %vc
}

define <vscale x 1 x i64> @vremu_vi_nxv1i64_0(<vscale x 1 x i64> %va) {
; CHECK-LABEL: vremu_vi_nxv1i64_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a0, zero, 1
; CHECK-NEXT:    slli a0, a0, 61
; CHECK-NEXT:    addi a0, a0, 1
; CHECK-NEXT:    vsetvli a1, zero, e64, m1, ta, mu
; CHECK-NEXT:    vmulhu.vx v25, v8, a0
; CHECK-NEXT:    addi a0, zero, 61
; CHECK-NEXT:    vsrl.vx v25, v25, a0
; CHECK-NEXT:    addi a0, zero, -7
; CHECK-NEXT:    vnmsac.vx v8, a0, v25
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 1 x i64> undef, i64 -7, i32 0
  %splat = shufflevector <vscale x 1 x i64> %head, <vscale x 1 x i64> undef, <vscale x 1 x i32> zeroinitializer
  %vc = urem <vscale x 1 x i64> %va, %splat
  ret <vscale x 1 x i64> %vc
}

define <vscale x 2 x i64> @vremu_vv_nxv2i64(<vscale x 2 x i64> %va, <vscale x 2 x i64> %vb) {
; CHECK-LABEL: vremu_vv_nxv2i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m2, ta, mu
; CHECK-NEXT:    vremu.vv v8, v8, v10
; CHECK-NEXT:    ret
  %vc = urem <vscale x 2 x i64> %va, %vb
  ret <vscale x 2 x i64> %vc
}

define <vscale x 2 x i64> @vremu_vx_nxv2i64(<vscale x 2 x i64> %va, i64 %b) {
; CHECK-LABEL: vremu_vx_nxv2i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e64, m2, ta, mu
; CHECK-NEXT:    vremu.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 2 x i64> undef, i64 %b, i32 0
  %splat = shufflevector <vscale x 2 x i64> %head, <vscale x 2 x i64> undef, <vscale x 2 x i32> zeroinitializer
  %vc = urem <vscale x 2 x i64> %va, %splat
  ret <vscale x 2 x i64> %vc
}

define <vscale x 2 x i64> @vremu_vi_nxv2i64_0(<vscale x 2 x i64> %va) {
; CHECK-LABEL: vremu_vi_nxv2i64_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a0, zero, 1
; CHECK-NEXT:    slli a0, a0, 61
; CHECK-NEXT:    addi a0, a0, 1
; CHECK-NEXT:    vsetvli a1, zero, e64, m2, ta, mu
; CHECK-NEXT:    vmulhu.vx v26, v8, a0
; CHECK-NEXT:    addi a0, zero, 61
; CHECK-NEXT:    vsrl.vx v26, v26, a0
; CHECK-NEXT:    addi a0, zero, -7
; CHECK-NEXT:    vnmsac.vx v8, a0, v26
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 2 x i64> undef, i64 -7, i32 0
  %splat = shufflevector <vscale x 2 x i64> %head, <vscale x 2 x i64> undef, <vscale x 2 x i32> zeroinitializer
  %vc = urem <vscale x 2 x i64> %va, %splat
  ret <vscale x 2 x i64> %vc
}

define <vscale x 4 x i64> @vremu_vv_nxv4i64(<vscale x 4 x i64> %va, <vscale x 4 x i64> %vb) {
; CHECK-LABEL: vremu_vv_nxv4i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m4, ta, mu
; CHECK-NEXT:    vremu.vv v8, v8, v12
; CHECK-NEXT:    ret
  %vc = urem <vscale x 4 x i64> %va, %vb
  ret <vscale x 4 x i64> %vc
}

define <vscale x 4 x i64> @vremu_vx_nxv4i64(<vscale x 4 x i64> %va, i64 %b) {
; CHECK-LABEL: vremu_vx_nxv4i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e64, m4, ta, mu
; CHECK-NEXT:    vremu.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 4 x i64> undef, i64 %b, i32 0
  %splat = shufflevector <vscale x 4 x i64> %head, <vscale x 4 x i64> undef, <vscale x 4 x i32> zeroinitializer
  %vc = urem <vscale x 4 x i64> %va, %splat
  ret <vscale x 4 x i64> %vc
}

define <vscale x 4 x i64> @vremu_vi_nxv4i64_0(<vscale x 4 x i64> %va) {
; CHECK-LABEL: vremu_vi_nxv4i64_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a0, zero, 1
; CHECK-NEXT:    slli a0, a0, 61
; CHECK-NEXT:    addi a0, a0, 1
; CHECK-NEXT:    vsetvli a1, zero, e64, m4, ta, mu
; CHECK-NEXT:    vmulhu.vx v28, v8, a0
; CHECK-NEXT:    addi a0, zero, 61
; CHECK-NEXT:    vsrl.vx v28, v28, a0
; CHECK-NEXT:    addi a0, zero, -7
; CHECK-NEXT:    vnmsac.vx v8, a0, v28
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 4 x i64> undef, i64 -7, i32 0
  %splat = shufflevector <vscale x 4 x i64> %head, <vscale x 4 x i64> undef, <vscale x 4 x i32> zeroinitializer
  %vc = urem <vscale x 4 x i64> %va, %splat
  ret <vscale x 4 x i64> %vc
}

define <vscale x 8 x i64> @vremu_vv_nxv8i64(<vscale x 8 x i64> %va, <vscale x 8 x i64> %vb) {
; CHECK-LABEL: vremu_vv_nxv8i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m8, ta, mu
; CHECK-NEXT:    vremu.vv v8, v8, v16
; CHECK-NEXT:    ret
  %vc = urem <vscale x 8 x i64> %va, %vb
  ret <vscale x 8 x i64> %vc
}

define <vscale x 8 x i64> @vremu_vx_nxv8i64(<vscale x 8 x i64> %va, i64 %b) {
; CHECK-LABEL: vremu_vx_nxv8i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e64, m8, ta, mu
; CHECK-NEXT:    vremu.vx v8, v8, a0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x i64> undef, i64 %b, i32 0
  %splat = shufflevector <vscale x 8 x i64> %head, <vscale x 8 x i64> undef, <vscale x 8 x i32> zeroinitializer
  %vc = urem <vscale x 8 x i64> %va, %splat
  ret <vscale x 8 x i64> %vc
}

define <vscale x 8 x i64> @vremu_vi_nxv8i64_0(<vscale x 8 x i64> %va) {
; CHECK-LABEL: vremu_vi_nxv8i64_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a0, zero, 1
; CHECK-NEXT:    slli a0, a0, 61
; CHECK-NEXT:    addi a0, a0, 1
; CHECK-NEXT:    vsetvli a1, zero, e64, m8, ta, mu
; CHECK-NEXT:    vmulhu.vx v16, v8, a0
; CHECK-NEXT:    addi a0, zero, 61
; CHECK-NEXT:    vsrl.vx v16, v16, a0
; CHECK-NEXT:    addi a0, zero, -7
; CHECK-NEXT:    vnmsac.vx v8, a0, v16
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x i64> undef, i64 -7, i32 0
  %splat = shufflevector <vscale x 8 x i64> %head, <vscale x 8 x i64> undef, <vscale x 8 x i32> zeroinitializer
  %vc = urem <vscale x 8 x i64> %va, %splat
  ret <vscale x 8 x i64> %vc
}

