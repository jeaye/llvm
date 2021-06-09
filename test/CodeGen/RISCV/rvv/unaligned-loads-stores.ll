; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple riscv32 -mattr=+d,+experimental-zfh,+experimental-v < %s \
; RUN:    -verify-machineinstrs | FileCheck %s
; RUN: llc -mtriple riscv64 -mattr=+d,+experimental-zfh,+experimental-v < %s \
; RUN:    -verify-machineinstrs | FileCheck %s

define <vscale x 1 x i32> @unaligned_load_nxv1i32_a1(<vscale x 1 x i32>* %ptr) {
; CHECK-LABEL: unaligned_load_nxv1i32_a1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e8, mf2, ta, mu
; CHECK-NEXT:    vle8.v v8, (a0)
; CHECK-NEXT:    ret
  %v = load <vscale x 1 x i32>, <vscale x 1 x i32>* %ptr, align 1
  ret <vscale x 1 x i32> %v
}

define <vscale x 1 x i32> @unaligned_load_nxv1i32_a2(<vscale x 1 x i32>* %ptr) {
; CHECK-LABEL: unaligned_load_nxv1i32_a2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e8, mf2, ta, mu
; CHECK-NEXT:    vle8.v v8, (a0)
; CHECK-NEXT:    ret
  %v = load <vscale x 1 x i32>, <vscale x 1 x i32>* %ptr, align 2
  ret <vscale x 1 x i32> %v
}

define <vscale x 1 x i32> @aligned_load_nxv1i32_a4(<vscale x 1 x i32>* %ptr) {
; CHECK-LABEL: aligned_load_nxv1i32_a4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32, mf2, ta, mu
; CHECK-NEXT:    vle32.v v8, (a0)
; CHECK-NEXT:    ret
  %v = load <vscale x 1 x i32>, <vscale x 1 x i32>* %ptr, align 4
  ret <vscale x 1 x i32> %v
}

define <vscale x 1 x i64> @unaligned_load_nxv1i64_a1(<vscale x 1 x i64>* %ptr) {
; CHECK-LABEL: unaligned_load_nxv1i64_a1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vl1r.v v8, (a0)
; CHECK-NEXT:    ret
  %v = load <vscale x 1 x i64>, <vscale x 1 x i64>* %ptr, align 1
  ret <vscale x 1 x i64> %v
}

define <vscale x 1 x i64> @unaligned_load_nxv1i64_a4(<vscale x 1 x i64>* %ptr) {
; CHECK-LABEL: unaligned_load_nxv1i64_a4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vl1r.v v8, (a0)
; CHECK-NEXT:    ret
  %v = load <vscale x 1 x i64>, <vscale x 1 x i64>* %ptr, align 4
  ret <vscale x 1 x i64> %v
}

define <vscale x 1 x i64> @aligned_load_nxv1i64_a8(<vscale x 1 x i64>* %ptr) {
; CHECK-LABEL: aligned_load_nxv1i64_a8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vl1re64.v v8, (a0)
; CHECK-NEXT:    ret
  %v = load <vscale x 1 x i64>, <vscale x 1 x i64>* %ptr, align 8
  ret <vscale x 1 x i64> %v
}

define <vscale x 2 x i64> @unaligned_load_nxv2i64_a1(<vscale x 2 x i64>* %ptr) {
; CHECK-LABEL: unaligned_load_nxv2i64_a1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vl2r.v v8, (a0)
; CHECK-NEXT:    ret
  %v = load <vscale x 2 x i64>, <vscale x 2 x i64>* %ptr, align 1
  ret <vscale x 2 x i64> %v
}

define <vscale x 2 x i64> @unaligned_load_nxv2i64_a4(<vscale x 2 x i64>* %ptr) {
; CHECK-LABEL: unaligned_load_nxv2i64_a4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vl2r.v v8, (a0)
; CHECK-NEXT:    ret
  %v = load <vscale x 2 x i64>, <vscale x 2 x i64>* %ptr, align 4
  ret <vscale x 2 x i64> %v
}

define <vscale x 2 x i64> @aligned_load_nxv2i64_a8(<vscale x 2 x i64>* %ptr) {
; CHECK-LABEL: aligned_load_nxv2i64_a8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vl2re64.v v8, (a0)
; CHECK-NEXT:    ret
  %v = load <vscale x 2 x i64>, <vscale x 2 x i64>* %ptr, align 8
  ret <vscale x 2 x i64> %v
}

; Masks should always be aligned
define <vscale x 1 x i1> @unaligned_load_nxv1i1_a1(<vscale x 1 x i1>* %ptr) {
; CHECK-LABEL: unaligned_load_nxv1i1_a1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e8, mf8, ta, mu
; CHECK-NEXT:    vle1.v v0, (a0)
; CHECK-NEXT:    ret
  %v = load <vscale x 1 x i1>, <vscale x 1 x i1>* %ptr, align 1
  ret <vscale x 1 x i1> %v
}

define <vscale x 4 x float> @unaligned_load_nxv4f32_a1(<vscale x 4 x float>* %ptr) {
; CHECK-LABEL: unaligned_load_nxv4f32_a1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vl2r.v v8, (a0)
; CHECK-NEXT:    ret
  %v = load <vscale x 4 x float>, <vscale x 4 x float>* %ptr, align 1
  ret <vscale x 4 x float> %v
}

define <vscale x 4 x float> @unaligned_load_nxv4f32_a2(<vscale x 4 x float>* %ptr) {
; CHECK-LABEL: unaligned_load_nxv4f32_a2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vl2r.v v8, (a0)
; CHECK-NEXT:    ret
  %v = load <vscale x 4 x float>, <vscale x 4 x float>* %ptr, align 2
  ret <vscale x 4 x float> %v
}

define <vscale x 4 x float> @aligned_load_nxv4f32_a4(<vscale x 4 x float>* %ptr) {
; CHECK-LABEL: aligned_load_nxv4f32_a4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vl2re32.v v8, (a0)
; CHECK-NEXT:    ret
  %v = load <vscale x 4 x float>, <vscale x 4 x float>* %ptr, align 4
  ret <vscale x 4 x float> %v
}

define <vscale x 8 x half> @unaligned_load_nxv8f16_a1(<vscale x 8 x half>* %ptr) {
; CHECK-LABEL: unaligned_load_nxv8f16_a1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vl2r.v v8, (a0)
; CHECK-NEXT:    ret
  %v = load <vscale x 8 x half>, <vscale x 8 x half>* %ptr, align 1
  ret <vscale x 8 x half> %v
}

define <vscale x 8 x half> @aligned_load_nxv8f16_a2(<vscale x 8 x half>* %ptr) {
; CHECK-LABEL: aligned_load_nxv8f16_a2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vl2re16.v v8, (a0)
; CHECK-NEXT:    ret
  %v = load <vscale x 8 x half>, <vscale x 8 x half>* %ptr, align 2
  ret <vscale x 8 x half> %v
}

define void @unaligned_store_nxv4i32_a1(<vscale x 4 x i32> %x, <vscale x 4 x i32>* %ptr) {
; CHECK-LABEL: unaligned_store_nxv4i32_a1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vs2r.v v8, (a0)
; CHECK-NEXT:    ret
  store <vscale x 4 x i32> %x, <vscale x 4 x i32>* %ptr, align 1
  ret void
}

define void @unaligned_store_nxv4i32_a2(<vscale x 4 x i32> %x, <vscale x 4 x i32>* %ptr) {
; CHECK-LABEL: unaligned_store_nxv4i32_a2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vs2r.v v8, (a0)
; CHECK-NEXT:    ret
  store <vscale x 4 x i32> %x, <vscale x 4 x i32>* %ptr, align 2
  ret void
}

define void @aligned_store_nxv4i32_a4(<vscale x 4 x i32> %x, <vscale x 4 x i32>* %ptr) {
; CHECK-LABEL: aligned_store_nxv4i32_a4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vs2r.v v8, (a0)
; CHECK-NEXT:    ret
  store <vscale x 4 x i32> %x, <vscale x 4 x i32>* %ptr, align 4
  ret void
}

define void @unaligned_store_nxv1i16_a1(<vscale x 1 x i16> %x, <vscale x 1 x i16>* %ptr) {
; CHECK-LABEL: unaligned_store_nxv1i16_a1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e8, mf4, ta, mu
; CHECK-NEXT:    vse8.v v8, (a0)
; CHECK-NEXT:    ret
  store <vscale x 1 x i16> %x, <vscale x 1 x i16>* %ptr, align 1
  ret void
}

define void @aligned_store_nxv1i16_a2(<vscale x 1 x i16> %x, <vscale x 1 x i16>* %ptr) {
; CHECK-LABEL: aligned_store_nxv1i16_a2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e16, mf4, ta, mu
; CHECK-NEXT:    vse16.v v8, (a0)
; CHECK-NEXT:    ret
  store <vscale x 1 x i16> %x, <vscale x 1 x i16>* %ptr, align 2
  ret void
}
