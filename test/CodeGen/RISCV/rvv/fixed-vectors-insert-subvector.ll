; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv64 -mattr=+m,+experimental-v -verify-machineinstrs -riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=2 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,LMULMAX2
; RUN: llc -mtriple=riscv64 -mattr=+m,+experimental-v -verify-machineinstrs -riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=1 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,LMULMAX1

define <vscale x 8 x i32> @insert_nxv8i32_v2i32_0(<vscale x 8 x i32> %vec, <2 x i32>* %svp) {
; CHECK-LABEL: insert_nxv8i32_v2i32_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli a1, 2, e32,m1,ta,mu
; CHECK-NEXT:    vle32.v v28, (a0)
; CHECK-NEXT:    vsetivli a0, 2, e32,m4,tu,mu
; CHECK-NEXT:    vslideup.vi v8, v28, 0
; CHECK-NEXT:    ret
  %sv = load <2 x i32>, <2 x i32>* %svp
  %v = call <vscale x 8 x i32> @llvm.experimental.vector.insert.v2i32.nxv8i32(<vscale x 8 x i32> %vec, <2 x i32> %sv, i64 0)
  ret <vscale x 8 x i32> %v
}

define <vscale x 8 x i32> @insert_nxv8i32_v2i32_2(<vscale x 8 x i32> %vec, <2 x i32>* %svp) {
; CHECK-LABEL: insert_nxv8i32_v2i32_2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli a1, 2, e32,m1,ta,mu
; CHECK-NEXT:    vle32.v v28, (a0)
; CHECK-NEXT:    vsetivli a0, 4, e32,m4,tu,mu
; CHECK-NEXT:    vslideup.vi v8, v28, 2
; CHECK-NEXT:    ret
  %sv = load <2 x i32>, <2 x i32>* %svp
  %v = call <vscale x 8 x i32> @llvm.experimental.vector.insert.v2i32.nxv8i32(<vscale x 8 x i32> %vec, <2 x i32> %sv, i64 2)
  ret <vscale x 8 x i32> %v
}

define <vscale x 8 x i32> @insert_nxv8i32_v2i32_6(<vscale x 8 x i32> %vec, <2 x i32>* %svp) {
; CHECK-LABEL: insert_nxv8i32_v2i32_6:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli a1, 2, e32,m1,ta,mu
; CHECK-NEXT:    vle32.v v28, (a0)
; CHECK-NEXT:    vsetivli a0, 8, e32,m4,tu,mu
; CHECK-NEXT:    vslideup.vi v8, v28, 6
; CHECK-NEXT:    ret
  %sv = load <2 x i32>, <2 x i32>* %svp
  %v = call <vscale x 8 x i32> @llvm.experimental.vector.insert.v2i32.nxv8i32(<vscale x 8 x i32> %vec, <2 x i32> %sv, i64 6)
  ret <vscale x 8 x i32> %v
}

define <vscale x 8 x i32> @insert_nxv8i32_v8i32_0(<vscale x 8 x i32> %vec, <8 x i32>* %svp) {
; LMULMAX2-LABEL: insert_nxv8i32_v8i32_0:
; LMULMAX2:       # %bb.0:
; LMULMAX2-NEXT:    vsetivli a1, 8, e32,m2,ta,mu
; LMULMAX2-NEXT:    vle32.v v28, (a0)
; LMULMAX2-NEXT:    vsetivli a0, 8, e32,m4,tu,mu
; LMULMAX2-NEXT:    vslideup.vi v8, v28, 0
; LMULMAX2-NEXT:    ret
;
; LMULMAX1-LABEL: insert_nxv8i32_v8i32_0:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    vsetivli a1, 4, e32,m1,ta,mu
; LMULMAX1-NEXT:    vle32.v v28, (a0)
; LMULMAX1-NEXT:    addi a0, a0, 16
; LMULMAX1-NEXT:    vle32.v v12, (a0)
; LMULMAX1-NEXT:    vsetivli a0, 4, e32,m4,tu,mu
; LMULMAX1-NEXT:    vslideup.vi v8, v28, 0
; LMULMAX1-NEXT:    vsetivli a0, 8, e32,m4,tu,mu
; LMULMAX1-NEXT:    vslideup.vi v8, v12, 4
; LMULMAX1-NEXT:    ret
  %sv = load <8 x i32>, <8 x i32>* %svp
  %v = call <vscale x 8 x i32> @llvm.experimental.vector.insert.v8i32.nxv8i32(<vscale x 8 x i32> %vec, <8 x i32> %sv, i64 0)
  ret <vscale x 8 x i32> %v
}

define <vscale x 8 x i32> @insert_nxv8i32_v8i32_4(<vscale x 8 x i32> %vec, <8 x i32>* %svp) {
; LMULMAX2-LABEL: insert_nxv8i32_v8i32_4:
; LMULMAX2:       # %bb.0:
; LMULMAX2-NEXT:    vsetivli a1, 8, e32,m2,ta,mu
; LMULMAX2-NEXT:    vle32.v v28, (a0)
; LMULMAX2-NEXT:    vsetivli a0, 12, e32,m4,tu,mu
; LMULMAX2-NEXT:    vslideup.vi v8, v28, 4
; LMULMAX2-NEXT:    ret
;
; LMULMAX1-LABEL: insert_nxv8i32_v8i32_4:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    vsetivli a1, 4, e32,m1,ta,mu
; LMULMAX1-NEXT:    vle32.v v28, (a0)
; LMULMAX1-NEXT:    addi a0, a0, 16
; LMULMAX1-NEXT:    vle32.v v12, (a0)
; LMULMAX1-NEXT:    vsetivli a0, 8, e32,m4,tu,mu
; LMULMAX1-NEXT:    vslideup.vi v8, v28, 4
; LMULMAX1-NEXT:    vsetivli a0, 12, e32,m4,tu,mu
; LMULMAX1-NEXT:    vslideup.vi v8, v12, 8
; LMULMAX1-NEXT:    ret
  %sv = load <8 x i32>, <8 x i32>* %svp
  %v = call <vscale x 8 x i32> @llvm.experimental.vector.insert.v8i32.nxv8i32(<vscale x 8 x i32> %vec, <8 x i32> %sv, i64 4)
  ret <vscale x 8 x i32> %v
}

define <vscale x 8 x i32> @insert_nxv8i32_v8i32_8(<vscale x 8 x i32> %vec, <8 x i32>* %svp) {
; LMULMAX2-LABEL: insert_nxv8i32_v8i32_8:
; LMULMAX2:       # %bb.0:
; LMULMAX2-NEXT:    vsetivli a1, 8, e32,m2,ta,mu
; LMULMAX2-NEXT:    vle32.v v28, (a0)
; LMULMAX2-NEXT:    vsetivli a0, 16, e32,m4,tu,mu
; LMULMAX2-NEXT:    vslideup.vi v8, v28, 8
; LMULMAX2-NEXT:    ret
;
; LMULMAX1-LABEL: insert_nxv8i32_v8i32_8:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    vsetivli a1, 4, e32,m1,ta,mu
; LMULMAX1-NEXT:    vle32.v v28, (a0)
; LMULMAX1-NEXT:    addi a0, a0, 16
; LMULMAX1-NEXT:    vle32.v v12, (a0)
; LMULMAX1-NEXT:    vsetivli a0, 12, e32,m4,tu,mu
; LMULMAX1-NEXT:    vslideup.vi v8, v28, 8
; LMULMAX1-NEXT:    vsetivli a0, 16, e32,m4,tu,mu
; LMULMAX1-NEXT:    vslideup.vi v8, v12, 12
; LMULMAX1-NEXT:    ret
  %sv = load <8 x i32>, <8 x i32>* %svp
  %v = call <vscale x 8 x i32> @llvm.experimental.vector.insert.v8i32.nxv8i32(<vscale x 8 x i32> %vec, <8 x i32> %sv, i64 8)
  ret <vscale x 8 x i32> %v
}

define <vscale x 8 x i32> @insert_nxv8i32_undef_v2i32_0(<2 x i32>* %svp) {
; CHECK-LABEL: insert_nxv8i32_undef_v2i32_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli a1, 2, e32,m1,ta,mu
; CHECK-NEXT:    vle32.v v8, (a0)
; CHECK-NEXT:    ret
  %sv = load <2 x i32>, <2 x i32>* %svp
  %v = call <vscale x 8 x i32> @llvm.experimental.vector.insert.v2i32.nxv8i32(<vscale x 8 x i32> undef, <2 x i32> %sv, i64 0)
  ret <vscale x 8 x i32> %v
}

define void @insert_v4i32_v2i32_0(<4 x i32>* %vp, <2 x i32>* %svp) {
; CHECK-LABEL: insert_v4i32_v2i32_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli a2, 2, e32,m1,ta,mu
; CHECK-NEXT:    vle32.v v25, (a1)
; CHECK-NEXT:    vsetivli a1, 4, e32,m1,ta,mu
; CHECK-NEXT:    vle32.v v26, (a0)
; CHECK-NEXT:    vsetivli a1, 2, e32,m1,tu,mu
; CHECK-NEXT:    vslideup.vi v26, v25, 0
; CHECK-NEXT:    vsetivli a1, 4, e32,m1,ta,mu
; CHECK-NEXT:    vse32.v v26, (a0)
; CHECK-NEXT:    ret
  %sv = load <2 x i32>, <2 x i32>* %svp
  %vec = load <4 x i32>, <4 x i32>* %vp
  %v = call <4 x i32> @llvm.experimental.vector.insert.v2i32.v4i32(<4 x i32> %vec, <2 x i32> %sv, i64 0)
  store <4 x i32> %v, <4 x i32>* %vp
  ret void
}

define void @insert_v4i32_v2i32_2(<4 x i32>* %vp, <2 x i32>* %svp) {
; CHECK-LABEL: insert_v4i32_v2i32_2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli a2, 2, e32,m1,ta,mu
; CHECK-NEXT:    vle32.v v25, (a1)
; CHECK-NEXT:    vsetivli a1, 4, e32,m1,ta,mu
; CHECK-NEXT:    vle32.v v26, (a0)
; CHECK-NEXT:    vsetivli a1, 4, e32,m1,tu,mu
; CHECK-NEXT:    vslideup.vi v26, v25, 2
; CHECK-NEXT:    vsetivli a1, 4, e32,m1,ta,mu
; CHECK-NEXT:    vse32.v v26, (a0)
; CHECK-NEXT:    ret
  %sv = load <2 x i32>, <2 x i32>* %svp
  %vec = load <4 x i32>, <4 x i32>* %vp
  %v = call <4 x i32> @llvm.experimental.vector.insert.v2i32.v4i32(<4 x i32> %vec, <2 x i32> %sv, i64 2)
  store <4 x i32> %v, <4 x i32>* %vp
  ret void
}

define void @insert_v4i32_undef_v2i32_0(<4 x i32>* %vp, <2 x i32>* %svp) {
; CHECK-LABEL: insert_v4i32_undef_v2i32_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli a2, 2, e32,m1,ta,mu
; CHECK-NEXT:    vle32.v v25, (a1)
; CHECK-NEXT:    vsetivli a1, 4, e32,m1,ta,mu
; CHECK-NEXT:    vmv.v.i v26, 0
; CHECK-NEXT:    vsetivli a1, 2, e32,m1,tu,mu
; CHECK-NEXT:    vslideup.vi v26, v25, 0
; CHECK-NEXT:    vsetivli a1, 4, e32,m1,ta,mu
; CHECK-NEXT:    vse32.v v26, (a0)
; CHECK-NEXT:    ret
  %sv = load <2 x i32>, <2 x i32>* %svp
  %v = call <4 x i32> @llvm.experimental.vector.insert.v2i32.v4i32(<4 x i32> undef, <2 x i32> %sv, i64 0)
  store <4 x i32> %v, <4 x i32>* %vp
  ret void
}

define void @insert_v8i32_v2i32_0(<8 x i32>* %vp, <2 x i32>* %svp) {
; LMULMAX2-LABEL: insert_v8i32_v2i32_0:
; LMULMAX2:       # %bb.0:
; LMULMAX2-NEXT:    vsetivli a2, 2, e32,m1,ta,mu
; LMULMAX2-NEXT:    vle32.v v26, (a1)
; LMULMAX2-NEXT:    vsetivli a1, 8, e32,m2,ta,mu
; LMULMAX2-NEXT:    vle32.v v28, (a0)
; LMULMAX2-NEXT:    vsetivli a1, 2, e32,m2,tu,mu
; LMULMAX2-NEXT:    vslideup.vi v28, v26, 0
; LMULMAX2-NEXT:    vsetivli a1, 8, e32,m2,ta,mu
; LMULMAX2-NEXT:    vse32.v v28, (a0)
; LMULMAX2-NEXT:    ret
;
; LMULMAX1-LABEL: insert_v8i32_v2i32_0:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    vsetivli a2, 2, e32,m1,ta,mu
; LMULMAX1-NEXT:    vle32.v v25, (a1)
; LMULMAX1-NEXT:    vsetivli a1, 4, e32,m1,ta,mu
; LMULMAX1-NEXT:    vle32.v v26, (a0)
; LMULMAX1-NEXT:    vsetivli a1, 2, e32,m1,tu,mu
; LMULMAX1-NEXT:    vslideup.vi v26, v25, 0
; LMULMAX1-NEXT:    vsetivli a1, 4, e32,m1,ta,mu
; LMULMAX1-NEXT:    vse32.v v26, (a0)
; LMULMAX1-NEXT:    ret
  %sv = load <2 x i32>, <2 x i32>* %svp
  %vec = load <8 x i32>, <8 x i32>* %vp
  %v = call <8 x i32> @llvm.experimental.vector.insert.v2i32.v8i32(<8 x i32> %vec, <2 x i32> %sv, i64 0)
  store <8 x i32> %v, <8 x i32>* %vp
  ret void
}

define void @insert_v8i32_v2i32_2(<8 x i32>* %vp, <2 x i32>* %svp) {
; LMULMAX2-LABEL: insert_v8i32_v2i32_2:
; LMULMAX2:       # %bb.0:
; LMULMAX2-NEXT:    vsetivli a2, 2, e32,m1,ta,mu
; LMULMAX2-NEXT:    vle32.v v26, (a1)
; LMULMAX2-NEXT:    vsetivli a1, 8, e32,m2,ta,mu
; LMULMAX2-NEXT:    vle32.v v28, (a0)
; LMULMAX2-NEXT:    vsetivli a1, 4, e32,m2,tu,mu
; LMULMAX2-NEXT:    vslideup.vi v28, v26, 2
; LMULMAX2-NEXT:    vsetivli a1, 8, e32,m2,ta,mu
; LMULMAX2-NEXT:    vse32.v v28, (a0)
; LMULMAX2-NEXT:    ret
;
; LMULMAX1-LABEL: insert_v8i32_v2i32_2:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    addi sp, sp, -32
; LMULMAX1-NEXT:    .cfi_def_cfa_offset 32
; LMULMAX1-NEXT:    vsetivli a2, 2, e32,m1,ta,mu
; LMULMAX1-NEXT:    vle32.v v25, (a1)
; LMULMAX1-NEXT:    vsetivli a1, 4, e32,m1,ta,mu
; LMULMAX1-NEXT:    vle32.v v26, (a0)
; LMULMAX1-NEXT:    vse32.v v26, (sp)
; LMULMAX1-NEXT:    addi a1, sp, 8
; LMULMAX1-NEXT:    vsetivli a2, 2, e32,m1,ta,mu
; LMULMAX1-NEXT:    vse32.v v25, (a1)
; LMULMAX1-NEXT:    vsetivli a1, 4, e32,m1,ta,mu
; LMULMAX1-NEXT:    vle32.v v25, (sp)
; LMULMAX1-NEXT:    vse32.v v25, (a0)
; LMULMAX1-NEXT:    addi sp, sp, 32
; LMULMAX1-NEXT:    ret
  %sv = load <2 x i32>, <2 x i32>* %svp
  %vec = load <8 x i32>, <8 x i32>* %vp
  %v = call <8 x i32> @llvm.experimental.vector.insert.v2i32.v8i32(<8 x i32> %vec, <2 x i32> %sv, i64 2)
  store <8 x i32> %v, <8 x i32>* %vp
  ret void
}

define void @insert_v8i32_v2i32_6(<8 x i32>* %vp, <2 x i32>* %svp) {
; LMULMAX2-LABEL: insert_v8i32_v2i32_6:
; LMULMAX2:       # %bb.0:
; LMULMAX2-NEXT:    vsetivli a2, 2, e32,m1,ta,mu
; LMULMAX2-NEXT:    vle32.v v26, (a1)
; LMULMAX2-NEXT:    vsetivli a1, 8, e32,m2,ta,mu
; LMULMAX2-NEXT:    vle32.v v28, (a0)
; LMULMAX2-NEXT:    vsetivli a1, 8, e32,m2,tu,mu
; LMULMAX2-NEXT:    vslideup.vi v28, v26, 6
; LMULMAX2-NEXT:    vsetivli a1, 8, e32,m2,ta,mu
; LMULMAX2-NEXT:    vse32.v v28, (a0)
; LMULMAX2-NEXT:    ret
;
; LMULMAX1-LABEL: insert_v8i32_v2i32_6:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    addi sp, sp, -32
; LMULMAX1-NEXT:    .cfi_def_cfa_offset 32
; LMULMAX1-NEXT:    vsetivli a2, 2, e32,m1,ta,mu
; LMULMAX1-NEXT:    vle32.v v25, (a1)
; LMULMAX1-NEXT:    addi a0, a0, 16
; LMULMAX1-NEXT:    vsetivli a1, 4, e32,m1,ta,mu
; LMULMAX1-NEXT:    vle32.v v26, (a0)
; LMULMAX1-NEXT:    addi a1, sp, 16
; LMULMAX1-NEXT:    vse32.v v26, (a1)
; LMULMAX1-NEXT:    addi a2, sp, 24
; LMULMAX1-NEXT:    vsetivli a3, 2, e32,m1,ta,mu
; LMULMAX1-NEXT:    vse32.v v25, (a2)
; LMULMAX1-NEXT:    vsetivli a2, 4, e32,m1,ta,mu
; LMULMAX1-NEXT:    vle32.v v25, (a1)
; LMULMAX1-NEXT:    vse32.v v25, (a0)
; LMULMAX1-NEXT:    addi sp, sp, 32
; LMULMAX1-NEXT:    ret
  %sv = load <2 x i32>, <2 x i32>* %svp
  %vec = load <8 x i32>, <8 x i32>* %vp
  %v = call <8 x i32> @llvm.experimental.vector.insert.v2i32.v8i32(<8 x i32> %vec, <2 x i32> %sv, i64 6)
  store <8 x i32> %v, <8 x i32>* %vp
  ret void
}

define void @insert_v8i32_undef_v2i32_6(<8 x i32>* %vp, <2 x i32>* %svp) {
; LMULMAX2-LABEL: insert_v8i32_undef_v2i32_6:
; LMULMAX2:       # %bb.0:
; LMULMAX2-NEXT:    vsetivli a2, 2, e32,m1,ta,mu
; LMULMAX2-NEXT:    vle32.v v26, (a1)
; LMULMAX2-NEXT:    vsetivli a1, 8, e32,m2,ta,mu
; LMULMAX2-NEXT:    vslideup.vi v28, v26, 6
; LMULMAX2-NEXT:    vse32.v v28, (a0)
; LMULMAX2-NEXT:    ret
;
; LMULMAX1-LABEL: insert_v8i32_undef_v2i32_6:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    addi sp, sp, -32
; LMULMAX1-NEXT:    .cfi_def_cfa_offset 32
; LMULMAX1-NEXT:    vsetivli a2, 2, e32,m1,ta,mu
; LMULMAX1-NEXT:    vle32.v v25, (a1)
; LMULMAX1-NEXT:    addi a1, sp, 24
; LMULMAX1-NEXT:    vse32.v v25, (a1)
; LMULMAX1-NEXT:    vsetivli a1, 4, e32,m1,ta,mu
; LMULMAX1-NEXT:    vle32.v v25, (sp)
; LMULMAX1-NEXT:    addi a1, sp, 16
; LMULMAX1-NEXT:    vle32.v v26, (a1)
; LMULMAX1-NEXT:    vse32.v v25, (a0)
; LMULMAX1-NEXT:    addi a0, a0, 16
; LMULMAX1-NEXT:    vse32.v v26, (a0)
; LMULMAX1-NEXT:    addi sp, sp, 32
; LMULMAX1-NEXT:    ret
  %sv = load <2 x i32>, <2 x i32>* %svp
  %v = call <8 x i32> @llvm.experimental.vector.insert.v2i32.v8i32(<8 x i32> undef, <2 x i32> %sv, i64 6)
  store <8 x i32> %v, <8 x i32>* %vp
  ret void
}

declare <4 x i32> @llvm.experimental.vector.insert.v2i32.v4i32(<4 x i32>, <2 x i32>, i64)
declare <8 x i32> @llvm.experimental.vector.insert.v2i32.v8i32(<8 x i32>, <2 x i32>, i64)

declare <vscale x 8 x i32> @llvm.experimental.vector.insert.v2i32.nxv8i32(<vscale x 8 x i32>, <2 x i32>, i64)
declare <vscale x 8 x i32> @llvm.experimental.vector.insert.v4i32.nxv8i32(<vscale x 8 x i32>, <4 x i32>, i64)
declare <vscale x 8 x i32> @llvm.experimental.vector.insert.v8i32.nxv8i32(<vscale x 8 x i32>, <8 x i32>, i64)
