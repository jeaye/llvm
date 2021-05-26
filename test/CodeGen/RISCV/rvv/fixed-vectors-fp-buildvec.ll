; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py

; RUN: llc -mtriple=riscv32 -target-abi=ilp32d -mattr=+experimental-v,+experimental-zfh,+f,+d -riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=2 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,LMULMAX1
; RUN: llc -mtriple=riscv64 -target-abi=lp64d -mattr=+experimental-v,+experimental-zfh,+f,+d -riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=2 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,LMULMAX1
; RUN: llc -mtriple=riscv32 -target-abi=ilp32d -mattr=+experimental-v,+experimental-zfh,+f,+d -riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=1 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,LMULMAX2
; RUN: llc -mtriple=riscv64 -target-abi=lp64d -mattr=+experimental-v,+experimental-zfh,+f,+d -riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=1 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,LMULMAX2

; Tests that a floating-point build_vector doesn't try and generate a VID
; instruction
define void @buildvec_no_vid_v4f32(<4 x float>* %x) {
; CHECK-LABEL: buildvec_no_vid_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a1, %hi(.LCPI0_0)
; CHECK-NEXT:    addi a1, a1, %lo(.LCPI0_0)
; CHECK-NEXT:    vsetivli zero, 4, e32,m1,ta,mu
; CHECK-NEXT:    vle32.v v25, (a1)
; CHECK-NEXT:    vse32.v v25, (a0)
; CHECK-NEXT:    ret
  store <4 x float> <float 0.0, float 4.0, float 0.0, float 2.0>, <4 x float>* %x
  ret void
}

; Not all BUILD_VECTORs are successfully lowered by the backend: some are
; expanded into scalarized stack stores. However, this may result in an
; infinite loop in the DAGCombiner which tries to recombine those stores into a
; BUILD_VECTOR followed by a vector store. The BUILD_VECTOR is then expanded
; and the loop begins.
; Until all BUILD_VECTORs are lowered, we disable store-combining after
; legalization for fixed-length vectors.
; This test uses a trick with a shufflevector which can't be lowered to a
; SHUFFLE_VECTOR node; the mask is shorter than the source vectors and the
; shuffle indices aren't located within the same 4-element subvector, so is
; expanded to 4 EXTRACT_VECTOR_ELTs and a BUILD_VECTOR. This then triggers the
; loop when expanded.
define <4 x float> @hang_when_merging_stores_after_legalization(<8 x float> %x, <8 x float> %y) optsize {
; LMULMAX1-LABEL: hang_when_merging_stores_after_legalization:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    addi sp, sp, -16
; LMULMAX1-NEXT:    .cfi_def_cfa_offset 16
; LMULMAX1-NEXT:    vsetvli zero, zero, e32,m2,ta,mu
; LMULMAX1-NEXT:    vfmv.f.s ft0, v10
; LMULMAX1-NEXT:    fsw ft0, 8(sp)
; LMULMAX1-NEXT:    vfmv.f.s ft0, v8
; LMULMAX1-NEXT:    fsw ft0, 0(sp)
; LMULMAX1-NEXT:    vsetivli zero, 1, e32,m2,ta,mu
; LMULMAX1-NEXT:    vslidedown.vi v26, v10, 7
; LMULMAX1-NEXT:    vfmv.f.s ft0, v26
; LMULMAX1-NEXT:    fsw ft0, 12(sp)
; LMULMAX1-NEXT:    vslidedown.vi v26, v8, 7
; LMULMAX1-NEXT:    vfmv.f.s ft0, v26
; LMULMAX1-NEXT:    fsw ft0, 4(sp)
; LMULMAX1-NEXT:    vsetivli zero, 4, e32,m1,ta,mu
; LMULMAX1-NEXT:    vle32.v v8, (sp)
; LMULMAX1-NEXT:    addi sp, sp, 16
; LMULMAX1-NEXT:    ret
;
; LMULMAX2-LABEL: hang_when_merging_stores_after_legalization:
; LMULMAX2:       # %bb.0:
; LMULMAX2-NEXT:    vsetivli zero, 4, e32,m1,ta,mu
; LMULMAX2-NEXT:    vmv.v.i v25, 0
; LMULMAX2-NEXT:    vrgather.vv v26, v8, v25
; LMULMAX2-NEXT:    addi a0, zero, 2
; LMULMAX2-NEXT:    vsetivli zero, 1, e8,mf8,ta,mu
; LMULMAX2-NEXT:    vmv.s.x v0, a0
; LMULMAX2-NEXT:    lui a0, %hi(.LCPI1_0)
; LMULMAX2-NEXT:    addi a0, a0, %lo(.LCPI1_0)
; LMULMAX2-NEXT:    vsetivli zero, 4, e32,m1,ta,mu
; LMULMAX2-NEXT:    vle32.v v27, (a0)
; LMULMAX2-NEXT:    vsetivli zero, 4, e32,m1,tu,mu
; LMULMAX2-NEXT:    vrgather.vv v26, v9, v27, v0.t
; LMULMAX2-NEXT:    vsetivli zero, 4, e32,m1,ta,mu
; LMULMAX2-NEXT:    vrgather.vv v27, v10, v25
; LMULMAX2-NEXT:    addi a0, zero, 8
; LMULMAX2-NEXT:    vsetivli zero, 1, e8,mf8,ta,mu
; LMULMAX2-NEXT:    vmv.s.x v0, a0
; LMULMAX2-NEXT:    lui a0, %hi(.LCPI1_1)
; LMULMAX2-NEXT:    addi a0, a0, %lo(.LCPI1_1)
; LMULMAX2-NEXT:    vsetivli zero, 4, e32,m1,ta,mu
; LMULMAX2-NEXT:    vle32.v v25, (a0)
; LMULMAX2-NEXT:    vsetivli zero, 4, e32,m1,tu,mu
; LMULMAX2-NEXT:    vrgather.vv v27, v11, v25, v0.t
; LMULMAX2-NEXT:    addi a0, zero, 3
; LMULMAX2-NEXT:    vsetivli zero, 1, e8,mf8,ta,mu
; LMULMAX2-NEXT:    vmv.s.x v0, a0
; LMULMAX2-NEXT:    vsetivli zero, 4, e32,m1,ta,mu
; LMULMAX2-NEXT:    vmerge.vvm v8, v27, v26, v0
; LMULMAX2-NEXT:    ret
  %z = shufflevector <8 x float> %x, <8 x float> %y, <4 x i32> <i32 0, i32 7, i32 8, i32 15>
  ret <4 x float> %z
}

define void @buildvec_dominant0_v4f32(<4 x float>* %x) {
; CHECK-LABEL: buildvec_dominant0_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e32,m1,ta,mu
; CHECK-NEXT:    lui a1, %hi(.LCPI2_0)
; CHECK-NEXT:    addi a1, a1, %lo(.LCPI2_0)
; CHECK-NEXT:    vlse32.v v25, (a1), zero
; CHECK-NEXT:    fmv.w.x ft0, zero
; CHECK-NEXT:    vfmv.s.f v26, ft0
; CHECK-NEXT:    vsetivli zero, 3, e32,m1,tu,mu
; CHECK-NEXT:    vslideup.vi v25, v26, 2
; CHECK-NEXT:    vsetivli zero, 4, e32,m1,ta,mu
; CHECK-NEXT:    vse32.v v25, (a0)
; CHECK-NEXT:    ret
  store <4 x float> <float 2.0, float 2.0, float 0.0, float 2.0>, <4 x float>* %x
  ret void
}

define void @buildvec_dominant1_v4f32(<4 x float>* %x, float %f) {
; CHECK-LABEL: buildvec_dominant1_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fmv.w.x ft0, zero
; CHECK-NEXT:    vsetivli zero, 4, e32,m1,ta,mu
; CHECK-NEXT:    vfmv.s.f v25, ft0
; CHECK-NEXT:    vfmv.v.f v26, fa0
; CHECK-NEXT:    vsetivli zero, 2, e32,m1,tu,mu
; CHECK-NEXT:    vslideup.vi v26, v25, 1
; CHECK-NEXT:    vsetivli zero, 4, e32,m1,ta,mu
; CHECK-NEXT:    vse32.v v26, (a0)
; CHECK-NEXT:    ret
  %v0 = insertelement <4 x float> undef, float %f, i32 0
  %v1 = insertelement <4 x float> %v0, float 0.0, i32 1
  %v2 = insertelement <4 x float> %v1, float %f, i32 2
  %v3 = insertelement <4 x float> %v2, float %f, i32 3
  store <4 x float> %v3, <4 x float>* %x
  ret void
}

define void @buildvec_dominant2_v4f32(<4 x float>* %x, float %f) {
; CHECK-LABEL: buildvec_dominant2_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a1, %hi(.LCPI4_0)
; CHECK-NEXT:    flw ft0, %lo(.LCPI4_0)(a1)
; CHECK-NEXT:    vsetivli zero, 4, e32,m1,ta,mu
; CHECK-NEXT:    vfmv.s.f v25, ft0
; CHECK-NEXT:    vfmv.v.f v26, fa0
; CHECK-NEXT:    vsetivli zero, 2, e32,m1,tu,mu
; CHECK-NEXT:    vslideup.vi v26, v25, 1
; CHECK-NEXT:    vsetivli zero, 4, e32,m1,ta,mu
; CHECK-NEXT:    vse32.v v26, (a0)
; CHECK-NEXT:    ret
  %v0 = insertelement <4 x float> undef, float %f, i32 0
  %v1 = insertelement <4 x float> %v0, float 2.0, i32 1
  %v2 = insertelement <4 x float> %v1, float %f, i32 2
  %v3 = insertelement <4 x float> %v2, float %f, i32 3
  store <4 x float> %v3, <4 x float>* %x
  ret void
}

define void @buildvec_merge0_v4f32(<4 x float>* %x, float %f) {
  %v0 = insertelement <4 x float> undef, float %f, i32 0
  %v1 = insertelement <4 x float> %v0, float 2.0, i32 1
  %v2 = insertelement <4 x float> %v1, float 2.0, i32 2
  %v3 = insertelement <4 x float> %v2, float %f, i32 3
  store <4 x float> %v3, <4 x float>* %x
  ret void
}
