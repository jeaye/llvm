; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+experimental-v -riscv-v-vector-bits-min=128 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK
; RUN: llc -mtriple=riscv64 -mattr=+experimental-v -riscv-v-vector-bits-min=128 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK

define <2 x i16> @vwmacc_v2i16(<2 x i8>* %x, <2 x i8>* %y, <2 x i16> %z) {
; CHECK-LABEL: vwmacc_v2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e8, mf8, ta, mu
; CHECK-NEXT:    vle8.v v25, (a0)
; CHECK-NEXT:    vle8.v v26, (a1)
; CHECK-NEXT:    vwmacc.vv v8, v25, v26
; CHECK-NEXT:    ret
  %a = load <2 x i8>, <2 x i8>* %x
  %b = load <2 x i8>, <2 x i8>* %y
  %c = sext <2 x i8> %a to <2 x i16>
  %d = sext <2 x i8> %b to <2 x i16>
  %e = mul <2 x i16> %c, %d
  %f = add <2 x i16> %e, %z
  ret <2 x i16> %f
}

define <4 x i16> @vwmacc_v4i16(<4 x i8>* %x, <4 x i8>* %y, <4 x i16> %z) {
; CHECK-LABEL: vwmacc_v4i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e8, mf4, ta, mu
; CHECK-NEXT:    vle8.v v25, (a0)
; CHECK-NEXT:    vle8.v v26, (a1)
; CHECK-NEXT:    vwmacc.vv v8, v25, v26
; CHECK-NEXT:    ret
  %a = load <4 x i8>, <4 x i8>* %x
  %b = load <4 x i8>, <4 x i8>* %y
  %c = sext <4 x i8> %a to <4 x i16>
  %d = sext <4 x i8> %b to <4 x i16>
  %e = mul <4 x i16> %c, %d
  %f = add <4 x i16> %e, %z
  ret <4 x i16> %f
}

define <2 x i32> @vwmacc_v2i32(<2 x i16>* %x, <2 x i16>* %y, <2 x i32> %z) {
; CHECK-LABEL: vwmacc_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e16, mf4, ta, mu
; CHECK-NEXT:    vle16.v v25, (a0)
; CHECK-NEXT:    vle16.v v26, (a1)
; CHECK-NEXT:    vwmacc.vv v8, v25, v26
; CHECK-NEXT:    ret
  %a = load <2 x i16>, <2 x i16>* %x
  %b = load <2 x i16>, <2 x i16>* %y
  %c = sext <2 x i16> %a to <2 x i32>
  %d = sext <2 x i16> %b to <2 x i32>
  %e = mul <2 x i32> %c, %d
  %f = add <2 x i32> %e, %z
  ret <2 x i32> %f
}

define <8 x i16> @vwmacc_v8i16(<8 x i8>* %x, <8 x i8>* %y, <8 x i16> %z) {
; CHECK-LABEL: vwmacc_v8i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vle8.v v25, (a0)
; CHECK-NEXT:    vle8.v v26, (a1)
; CHECK-NEXT:    vwmacc.vv v8, v25, v26
; CHECK-NEXT:    ret
  %a = load <8 x i8>, <8 x i8>* %x
  %b = load <8 x i8>, <8 x i8>* %y
  %c = sext <8 x i8> %a to <8 x i16>
  %d = sext <8 x i8> %b to <8 x i16>
  %e = mul <8 x i16> %c, %d
  %f = add <8 x i16> %e, %z
  ret <8 x i16> %f
}

define <4 x i32> @vwmacc_v4i32(<4 x i16>* %x, <4 x i16>* %y, <4 x i32> %z) {
; CHECK-LABEL: vwmacc_v4i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e16, mf2, ta, mu
; CHECK-NEXT:    vle16.v v25, (a0)
; CHECK-NEXT:    vle16.v v26, (a1)
; CHECK-NEXT:    vwmacc.vv v8, v25, v26
; CHECK-NEXT:    ret
  %a = load <4 x i16>, <4 x i16>* %x
  %b = load <4 x i16>, <4 x i16>* %y
  %c = sext <4 x i16> %a to <4 x i32>
  %d = sext <4 x i16> %b to <4 x i32>
  %e = mul <4 x i32> %c, %d
  %f = add <4 x i32> %e, %z
  ret <4 x i32> %f
}

define <2 x i64> @vwmacc_v2i64(<2 x i32>* %x, <2 x i32>* %y, <2 x i64> %z) {
; CHECK-LABEL: vwmacc_v2i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; CHECK-NEXT:    vle32.v v25, (a0)
; CHECK-NEXT:    vle32.v v26, (a1)
; CHECK-NEXT:    vwmacc.vv v8, v25, v26
; CHECK-NEXT:    ret
  %a = load <2 x i32>, <2 x i32>* %x
  %b = load <2 x i32>, <2 x i32>* %y
  %c = sext <2 x i32> %a to <2 x i64>
  %d = sext <2 x i32> %b to <2 x i64>
  %e = mul <2 x i64> %c, %d
  %f = add <2 x i64> %e, %z
  ret <2 x i64> %f
}

define <16 x i16> @vwmacc_v16i16(<16 x i8>* %x, <16 x i8>* %y, <16 x i16> %z) {
; CHECK-LABEL: vwmacc_v16i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 16, e8, m1, ta, mu
; CHECK-NEXT:    vle8.v v25, (a0)
; CHECK-NEXT:    vle8.v v26, (a1)
; CHECK-NEXT:    vwmacc.vv v8, v25, v26
; CHECK-NEXT:    ret
  %a = load <16 x i8>, <16 x i8>* %x
  %b = load <16 x i8>, <16 x i8>* %y
  %c = sext <16 x i8> %a to <16 x i16>
  %d = sext <16 x i8> %b to <16 x i16>
  %e = mul <16 x i16> %c, %d
  %f = add <16 x i16> %e, %z
  ret <16 x i16> %f
}

define <8 x i32> @vwmacc_v8i32(<8 x i16>* %x, <8 x i16>* %y, <8 x i32> %z) {
; CHECK-LABEL: vwmacc_v8i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e16, m1, ta, mu
; CHECK-NEXT:    vle16.v v25, (a0)
; CHECK-NEXT:    vle16.v v26, (a1)
; CHECK-NEXT:    vwmacc.vv v8, v25, v26
; CHECK-NEXT:    ret
  %a = load <8 x i16>, <8 x i16>* %x
  %b = load <8 x i16>, <8 x i16>* %y
  %c = sext <8 x i16> %a to <8 x i32>
  %d = sext <8 x i16> %b to <8 x i32>
  %e = mul <8 x i32> %c, %d
  %f = add <8 x i32> %e, %z
  ret <8 x i32> %f
}

define <4 x i64> @vwmacc_v4i64(<4 x i32>* %x, <4 x i32>* %y, <4 x i64> %z) {
; CHECK-LABEL: vwmacc_v4i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e32, m1, ta, mu
; CHECK-NEXT:    vle32.v v25, (a0)
; CHECK-NEXT:    vle32.v v26, (a1)
; CHECK-NEXT:    vwmacc.vv v8, v25, v26
; CHECK-NEXT:    ret
  %a = load <4 x i32>, <4 x i32>* %x
  %b = load <4 x i32>, <4 x i32>* %y
  %c = sext <4 x i32> %a to <4 x i64>
  %d = sext <4 x i32> %b to <4 x i64>
  %e = mul <4 x i64> %c, %d
  %f = add <4 x i64> %e, %z
  ret <4 x i64> %f
}

define <32 x i16> @vwmacc_v32i16(<32 x i8>* %x, <32 x i8>* %y, <32 x i16> %z) {
; CHECK-LABEL: vwmacc_v32i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a2, zero, 32
; CHECK-NEXT:    vsetvli zero, a2, e8, m2, ta, mu
; CHECK-NEXT:    vle8.v v26, (a0)
; CHECK-NEXT:    vle8.v v28, (a1)
; CHECK-NEXT:    vwmacc.vv v8, v26, v28
; CHECK-NEXT:    ret
  %a = load <32 x i8>, <32 x i8>* %x
  %b = load <32 x i8>, <32 x i8>* %y
  %c = sext <32 x i8> %a to <32 x i16>
  %d = sext <32 x i8> %b to <32 x i16>
  %e = mul <32 x i16> %c, %d
  %f = add <32 x i16> %e, %z
  ret <32 x i16> %f
}

define <16 x i32> @vwmacc_v16i32(<16 x i16>* %x, <16 x i16>* %y, <16 x i32> %z) {
; CHECK-LABEL: vwmacc_v16i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 16, e16, m2, ta, mu
; CHECK-NEXT:    vle16.v v26, (a0)
; CHECK-NEXT:    vle16.v v28, (a1)
; CHECK-NEXT:    vwmacc.vv v8, v26, v28
; CHECK-NEXT:    ret
  %a = load <16 x i16>, <16 x i16>* %x
  %b = load <16 x i16>, <16 x i16>* %y
  %c = sext <16 x i16> %a to <16 x i32>
  %d = sext <16 x i16> %b to <16 x i32>
  %e = mul <16 x i32> %c, %d
  %f = add <16 x i32> %e, %z
  ret <16 x i32> %f
}

define <8 x i64> @vwmacc_v8i64(<8 x i32>* %x, <8 x i32>* %y, <8 x i64> %z) {
; CHECK-LABEL: vwmacc_v8i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e32, m2, ta, mu
; CHECK-NEXT:    vle32.v v26, (a0)
; CHECK-NEXT:    vle32.v v28, (a1)
; CHECK-NEXT:    vwmacc.vv v8, v26, v28
; CHECK-NEXT:    ret
  %a = load <8 x i32>, <8 x i32>* %x
  %b = load <8 x i32>, <8 x i32>* %y
  %c = sext <8 x i32> %a to <8 x i64>
  %d = sext <8 x i32> %b to <8 x i64>
  %e = mul <8 x i64> %c, %d
  %f = add <8 x i64> %e, %z
  ret <8 x i64> %f
}

define <64 x i16> @vwmacc_v64i16(<64 x i8>* %x, <64 x i8>* %y, <64 x i16> %z) {
; CHECK-LABEL: vwmacc_v64i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a2, zero, 64
; CHECK-NEXT:    vsetvli zero, a2, e8, m4, ta, mu
; CHECK-NEXT:    vle8.v v28, (a0)
; CHECK-NEXT:    vle8.v v16, (a1)
; CHECK-NEXT:    vwmacc.vv v8, v28, v16
; CHECK-NEXT:    ret
  %a = load <64 x i8>, <64 x i8>* %x
  %b = load <64 x i8>, <64 x i8>* %y
  %c = sext <64 x i8> %a to <64 x i16>
  %d = sext <64 x i8> %b to <64 x i16>
  %e = mul <64 x i16> %c, %d
  %f = add <64 x i16> %e, %z
  ret <64 x i16> %f
}

define <32 x i32> @vwmacc_v32i32(<32 x i16>* %x, <32 x i16>* %y, <32 x i32> %z) {
; CHECK-LABEL: vwmacc_v32i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a2, zero, 32
; CHECK-NEXT:    vsetvli zero, a2, e16, m4, ta, mu
; CHECK-NEXT:    vle16.v v28, (a0)
; CHECK-NEXT:    vle16.v v16, (a1)
; CHECK-NEXT:    vwmacc.vv v8, v28, v16
; CHECK-NEXT:    ret
  %a = load <32 x i16>, <32 x i16>* %x
  %b = load <32 x i16>, <32 x i16>* %y
  %c = sext <32 x i16> %a to <32 x i32>
  %d = sext <32 x i16> %b to <32 x i32>
  %e = mul <32 x i32> %c, %d
  %f = add <32 x i32> %e, %z
  ret <32 x i32> %f
}

define <16 x i64> @vwmacc_v16i64(<16 x i32>* %x, <16 x i32>* %y, <16 x i64> %z) {
; CHECK-LABEL: vwmacc_v16i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 16, e32, m4, ta, mu
; CHECK-NEXT:    vle32.v v28, (a0)
; CHECK-NEXT:    vle32.v v16, (a1)
; CHECK-NEXT:    vwmacc.vv v8, v28, v16
; CHECK-NEXT:    ret
  %a = load <16 x i32>, <16 x i32>* %x
  %b = load <16 x i32>, <16 x i32>* %y
  %c = sext <16 x i32> %a to <16 x i64>
  %d = sext <16 x i32> %b to <16 x i64>
  %e = mul <16 x i64> %c, %d
  %f = add <16 x i64> %e, %z
  ret <16 x i64> %f
}

define <2 x i16> @vwmacc_vx_v2i16(<2 x i8>* %x, i8 %y, <2 x i16> %z) {
; CHECK-LABEL: vwmacc_vx_v2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e8, mf8, ta, mu
; CHECK-NEXT:    vle8.v v25, (a0)
; CHECK-NEXT:    vwmacc.vx v8, a1, v25
; CHECK-NEXT:    ret
  %a = load <2 x i8>, <2 x i8>* %x
  %b = insertelement <2 x i8> undef, i8 %y, i32 0
  %c = shufflevector <2 x i8> %b, <2 x i8> undef, <2 x i32> zeroinitializer
  %d = sext <2 x i8> %a to <2 x i16>
  %e = sext <2 x i8> %c to <2 x i16>
  %f = mul <2 x i16> %d, %e
  %g = add <2 x i16> %f, %z
  ret <2 x i16> %g
}

define <4 x i16> @vwmacc_vx_v4i16(<4 x i8>* %x, i8 %y, <4 x i16> %z) {
; CHECK-LABEL: vwmacc_vx_v4i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e8, mf4, ta, mu
; CHECK-NEXT:    vle8.v v25, (a0)
; CHECK-NEXT:    vwmacc.vx v8, a1, v25
; CHECK-NEXT:    ret
  %a = load <4 x i8>, <4 x i8>* %x
  %b = insertelement <4 x i8> undef, i8 %y, i32 0
  %c = shufflevector <4 x i8> %b, <4 x i8> undef, <4 x i32> zeroinitializer
  %d = sext <4 x i8> %a to <4 x i16>
  %e = sext <4 x i8> %c to <4 x i16>
  %f = mul <4 x i16> %d, %e
  %g = add <4 x i16> %f, %z
  ret <4 x i16> %g
}

define <2 x i32> @vwmacc_vx_v2i32(<2 x i16>* %x, i16 %y, <2 x i32> %z) {
; CHECK-LABEL: vwmacc_vx_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e16, mf4, ta, mu
; CHECK-NEXT:    vle16.v v25, (a0)
; CHECK-NEXT:    vwmacc.vx v8, a1, v25
; CHECK-NEXT:    ret
  %a = load <2 x i16>, <2 x i16>* %x
  %b = insertelement <2 x i16> undef, i16 %y, i32 0
  %c = shufflevector <2 x i16> %b, <2 x i16> undef, <2 x i32> zeroinitializer
  %d = sext <2 x i16> %a to <2 x i32>
  %e = sext <2 x i16> %c to <2 x i32>
  %f = mul <2 x i32> %d, %e
  %g = add <2 x i32> %f, %z
  ret <2 x i32> %g
}

define <8 x i16> @vwmacc_vx_v8i16(<8 x i8>* %x, i8 %y, <8 x i16> %z) {
; CHECK-LABEL: vwmacc_vx_v8i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vle8.v v25, (a0)
; CHECK-NEXT:    vwmacc.vx v8, a1, v25
; CHECK-NEXT:    ret
  %a = load <8 x i8>, <8 x i8>* %x
  %b = insertelement <8 x i8> undef, i8 %y, i32 0
  %c = shufflevector <8 x i8> %b, <8 x i8> undef, <8 x i32> zeroinitializer
  %d = sext <8 x i8> %a to <8 x i16>
  %e = sext <8 x i8> %c to <8 x i16>
  %f = mul <8 x i16> %d, %e
  %g = add <8 x i16> %f, %z
  ret <8 x i16> %g
}

define <4 x i32> @vwmacc_vx_v4i32(<4 x i16>* %x, i16 %y, <4 x i32> %z) {
; CHECK-LABEL: vwmacc_vx_v4i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e16, mf2, ta, mu
; CHECK-NEXT:    vle16.v v25, (a0)
; CHECK-NEXT:    vwmacc.vx v8, a1, v25
; CHECK-NEXT:    ret
  %a = load <4 x i16>, <4 x i16>* %x
  %b = insertelement <4 x i16> undef, i16 %y, i32 0
  %c = shufflevector <4 x i16> %b, <4 x i16> undef, <4 x i32> zeroinitializer
  %d = sext <4 x i16> %a to <4 x i32>
  %e = sext <4 x i16> %c to <4 x i32>
  %f = mul <4 x i32> %d, %e
  %g = add <4 x i32> %f, %z
  ret <4 x i32> %g
}

define <2 x i64> @vwmacc_vx_v2i64(<2 x i32>* %x, i32 %y, <2 x i64> %z) {
; CHECK-LABEL: vwmacc_vx_v2i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; CHECK-NEXT:    vle32.v v25, (a0)
; CHECK-NEXT:    vwmacc.vx v8, a1, v25
; CHECK-NEXT:    ret
  %a = load <2 x i32>, <2 x i32>* %x
  %b = insertelement <2 x i32> undef, i32 %y, i64 0
  %c = shufflevector <2 x i32> %b, <2 x i32> undef, <2 x i32> zeroinitializer
  %d = sext <2 x i32> %a to <2 x i64>
  %e = sext <2 x i32> %c to <2 x i64>
  %f = mul <2 x i64> %d, %e
  %g = add <2 x i64> %f, %z
  ret <2 x i64> %g
}

define <16 x i16> @vwmacc_vx_v16i16(<16 x i8>* %x, i8 %y, <16 x i16> %z) {
; CHECK-LABEL: vwmacc_vx_v16i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 16, e8, m1, ta, mu
; CHECK-NEXT:    vle8.v v25, (a0)
; CHECK-NEXT:    vwmacc.vx v8, a1, v25
; CHECK-NEXT:    ret
  %a = load <16 x i8>, <16 x i8>* %x
  %b = insertelement <16 x i8> undef, i8 %y, i32 0
  %c = shufflevector <16 x i8> %b, <16 x i8> undef, <16 x i32> zeroinitializer
  %d = sext <16 x i8> %a to <16 x i16>
  %e = sext <16 x i8> %c to <16 x i16>
  %f = mul <16 x i16> %d, %e
  %g = add <16 x i16> %f, %z
  ret <16 x i16> %g
}

define <8 x i32> @vwmacc_vx_v8i32(<8 x i16>* %x, i16 %y, <8 x i32> %z) {
; CHECK-LABEL: vwmacc_vx_v8i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e16, m1, ta, mu
; CHECK-NEXT:    vle16.v v25, (a0)
; CHECK-NEXT:    vwmacc.vx v8, a1, v25
; CHECK-NEXT:    ret
  %a = load <8 x i16>, <8 x i16>* %x
  %b = insertelement <8 x i16> undef, i16 %y, i32 0
  %c = shufflevector <8 x i16> %b, <8 x i16> undef, <8 x i32> zeroinitializer
  %d = sext <8 x i16> %a to <8 x i32>
  %e = sext <8 x i16> %c to <8 x i32>
  %f = mul <8 x i32> %d, %e
  %g = add <8 x i32> %f, %z
  ret <8 x i32> %g
}

define <4 x i64> @vwmacc_vx_v4i64(<4 x i32>* %x, i32 %y, <4 x i64> %z) {
; CHECK-LABEL: vwmacc_vx_v4i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e32, m1, ta, mu
; CHECK-NEXT:    vle32.v v25, (a0)
; CHECK-NEXT:    vwmacc.vx v8, a1, v25
; CHECK-NEXT:    ret
  %a = load <4 x i32>, <4 x i32>* %x
  %b = insertelement <4 x i32> undef, i32 %y, i64 0
  %c = shufflevector <4 x i32> %b, <4 x i32> undef, <4 x i32> zeroinitializer
  %d = sext <4 x i32> %a to <4 x i64>
  %e = sext <4 x i32> %c to <4 x i64>
  %f = mul <4 x i64> %d, %e
  %g = add <4 x i64> %f, %z
  ret <4 x i64> %g
}

define <32 x i16> @vwmacc_vx_v32i16(<32 x i8>* %x, i8 %y, <32 x i16> %z) {
; CHECK-LABEL: vwmacc_vx_v32i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a2, zero, 32
; CHECK-NEXT:    vsetvli zero, a2, e8, m2, ta, mu
; CHECK-NEXT:    vle8.v v26, (a0)
; CHECK-NEXT:    vwmacc.vx v8, a1, v26
; CHECK-NEXT:    ret
  %a = load <32 x i8>, <32 x i8>* %x
  %b = insertelement <32 x i8> undef, i8 %y, i32 0
  %c = shufflevector <32 x i8> %b, <32 x i8> undef, <32 x i32> zeroinitializer
  %d = sext <32 x i8> %a to <32 x i16>
  %e = sext <32 x i8> %c to <32 x i16>
  %f = mul <32 x i16> %d, %e
  %g = add <32 x i16> %f, %z
  ret <32 x i16> %g
}

define <16 x i32> @vwmacc_vx_v16i32(<16 x i16>* %x, i16 %y, <16 x i32> %z) {
; CHECK-LABEL: vwmacc_vx_v16i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 16, e16, m2, ta, mu
; CHECK-NEXT:    vle16.v v26, (a0)
; CHECK-NEXT:    vwmacc.vx v8, a1, v26
; CHECK-NEXT:    ret
  %a = load <16 x i16>, <16 x i16>* %x
  %b = insertelement <16 x i16> undef, i16 %y, i32 0
  %c = shufflevector <16 x i16> %b, <16 x i16> undef, <16 x i32> zeroinitializer
  %d = sext <16 x i16> %a to <16 x i32>
  %e = sext <16 x i16> %c to <16 x i32>
  %f = mul <16 x i32> %d, %e
  %g = add <16 x i32> %f, %z
  ret <16 x i32> %g
}

define <8 x i64> @vwmacc_vx_v8i64(<8 x i32>* %x, i32 %y, <8 x i64> %z) {
; CHECK-LABEL: vwmacc_vx_v8i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e32, m2, ta, mu
; CHECK-NEXT:    vle32.v v26, (a0)
; CHECK-NEXT:    vwmacc.vx v8, a1, v26
; CHECK-NEXT:    ret
  %a = load <8 x i32>, <8 x i32>* %x
  %b = insertelement <8 x i32> undef, i32 %y, i64 0
  %c = shufflevector <8 x i32> %b, <8 x i32> undef, <8 x i32> zeroinitializer
  %d = sext <8 x i32> %a to <8 x i64>
  %e = sext <8 x i32> %c to <8 x i64>
  %f = mul <8 x i64> %d, %e
  %g = add <8 x i64> %f, %z
  ret <8 x i64> %g
}

define <64 x i16> @vwmacc_vx_v64i16(<64 x i8>* %x, i8 %y, <64 x i16> %z) {
; CHECK-LABEL: vwmacc_vx_v64i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a2, zero, 64
; CHECK-NEXT:    vsetvli zero, a2, e8, m4, ta, mu
; CHECK-NEXT:    vle8.v v28, (a0)
; CHECK-NEXT:    vwmacc.vx v8, a1, v28
; CHECK-NEXT:    ret
  %a = load <64 x i8>, <64 x i8>* %x
  %b = insertelement <64 x i8> undef, i8 %y, i32 0
  %c = shufflevector <64 x i8> %b, <64 x i8> undef, <64 x i32> zeroinitializer
  %d = sext <64 x i8> %a to <64 x i16>
  %e = sext <64 x i8> %c to <64 x i16>
  %f = mul <64 x i16> %d, %e
  %g = add <64 x i16> %f, %z
  ret <64 x i16> %g
}

define <32 x i32> @vwmacc_vx_v32i32(<32 x i16>* %x, i16 %y, <32 x i32> %z) {
; CHECK-LABEL: vwmacc_vx_v32i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a2, zero, 32
; CHECK-NEXT:    vsetvli zero, a2, e16, m4, ta, mu
; CHECK-NEXT:    vle16.v v28, (a0)
; CHECK-NEXT:    vwmacc.vx v8, a1, v28
; CHECK-NEXT:    ret
  %a = load <32 x i16>, <32 x i16>* %x
  %b = insertelement <32 x i16> undef, i16 %y, i32 0
  %c = shufflevector <32 x i16> %b, <32 x i16> undef, <32 x i32> zeroinitializer
  %d = sext <32 x i16> %a to <32 x i32>
  %e = sext <32 x i16> %c to <32 x i32>
  %f = mul <32 x i32> %d, %e
  %g = add <32 x i32> %f, %z
  ret <32 x i32> %g
}

define <16 x i64> @vwmacc_vx_v16i64(<16 x i32>* %x, i32 %y, <16 x i64> %z) {
; CHECK-LABEL: vwmacc_vx_v16i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 16, e32, m4, ta, mu
; CHECK-NEXT:    vle32.v v28, (a0)
; CHECK-NEXT:    vwmacc.vx v8, a1, v28
; CHECK-NEXT:    ret
  %a = load <16 x i32>, <16 x i32>* %x
  %b = insertelement <16 x i32> undef, i32 %y, i64 0
  %c = shufflevector <16 x i32> %b, <16 x i32> undef, <16 x i32> zeroinitializer
  %d = sext <16 x i32> %a to <16 x i64>
  %e = sext <16 x i32> %c to <16 x i64>
  %f = mul <16 x i64> %d, %e
  %g = add <16 x i64> %f, %z
  ret <16 x i64> %g
}
