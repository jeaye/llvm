; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -target-abi=ilp32d -mattr=+experimental-v,+experimental-zfh,+f,+d -verify-machineinstrs -riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=2 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,LMULMAX2
; RUN: llc -mtriple=riscv64 -target-abi=lp64d -mattr=+experimental-v,+experimental-zfh,+f,+d -verify-machineinstrs -riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=2 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,LMULMAX2
; RUN: llc -mtriple=riscv32 -target-abi=ilp32d -mattr=+experimental-v,+experimental-zfh,+f,+d -verify-machineinstrs -riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=1 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,LMULMAX1
; RUN: llc -mtriple=riscv64 -target-abi=lp64d -mattr=+experimental-v,+experimental-zfh,+f,+d -verify-machineinstrs -riscv-v-vector-bits-min=128 -riscv-v-fixed-length-vector-lmul-max=1 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,LMULMAX1

define void @splat_v8f16(<8 x half>* %x, half %y) {
; CHECK-LABEL: splat_v8f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli a1, 8, e16,m1,ta,mu
; CHECK-NEXT:    vfmv.v.f v25, fa0
; CHECK-NEXT:    vse16.v v25, (a0)
; CHECK-NEXT:    ret
  %a = insertelement <8 x half> undef, half %y, i32 0
  %b = shufflevector <8 x half> %a, <8 x half> undef, <8 x i32> zeroinitializer
  store <8 x half> %b, <8 x half>* %x
  ret void
}

define void @splat_v4f32(<4 x float>* %x, float %y) {
; CHECK-LABEL: splat_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli a1, 4, e32,m1,ta,mu
; CHECK-NEXT:    vfmv.v.f v25, fa0
; CHECK-NEXT:    vse32.v v25, (a0)
; CHECK-NEXT:    ret
  %a = insertelement <4 x float> undef, float %y, i32 0
  %b = shufflevector <4 x float> %a, <4 x float> undef, <4 x i32> zeroinitializer
  store <4 x float> %b, <4 x float>* %x
  ret void
}

define void @splat_v2f64(<2 x double>* %x, double %y) {
; CHECK-LABEL: splat_v2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli a1, 2, e64,m1,ta,mu
; CHECK-NEXT:    vfmv.v.f v25, fa0
; CHECK-NEXT:    vse64.v v25, (a0)
; CHECK-NEXT:    ret
  %a = insertelement <2 x double> undef, double %y, i32 0
  %b = shufflevector <2 x double> %a, <2 x double> undef, <2 x i32> zeroinitializer
  store <2 x double> %b, <2 x double>* %x
  ret void
}

define void @splat_16f16(<16 x half>* %x, half %y) {
; LMULMAX2-LABEL: splat_16f16:
; LMULMAX2:       # %bb.0:
; LMULMAX2-NEXT:    vsetivli a1, 16, e16,m2,ta,mu
; LMULMAX2-NEXT:    vfmv.v.f v26, fa0
; LMULMAX2-NEXT:    vse16.v v26, (a0)
; LMULMAX2-NEXT:    ret
;
; LMULMAX1-LABEL: splat_16f16:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    vsetivli a1, 8, e16,m1,ta,mu
; LMULMAX1-NEXT:    vfmv.v.f v25, fa0
; LMULMAX1-NEXT:    addi a1, a0, 16
; LMULMAX1-NEXT:    vse16.v v25, (a1)
; LMULMAX1-NEXT:    vse16.v v25, (a0)
; LMULMAX1-NEXT:    ret
  %a = insertelement <16 x half> undef, half %y, i32 0
  %b = shufflevector <16 x half> %a, <16 x half> undef, <16 x i32> zeroinitializer
  store <16 x half> %b, <16 x half>* %x
  ret void
}

define void @splat_v8f32(<8 x float>* %x, float %y) {
; LMULMAX2-LABEL: splat_v8f32:
; LMULMAX2:       # %bb.0:
; LMULMAX2-NEXT:    vsetivli a1, 8, e32,m2,ta,mu
; LMULMAX2-NEXT:    vfmv.v.f v26, fa0
; LMULMAX2-NEXT:    vse32.v v26, (a0)
; LMULMAX2-NEXT:    ret
;
; LMULMAX1-LABEL: splat_v8f32:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    vsetivli a1, 4, e32,m1,ta,mu
; LMULMAX1-NEXT:    vfmv.v.f v25, fa0
; LMULMAX1-NEXT:    addi a1, a0, 16
; LMULMAX1-NEXT:    vse32.v v25, (a1)
; LMULMAX1-NEXT:    vse32.v v25, (a0)
; LMULMAX1-NEXT:    ret
  %a = insertelement <8 x float> undef, float %y, i32 0
  %b = shufflevector <8 x float> %a, <8 x float> undef, <8 x i32> zeroinitializer
  store <8 x float> %b, <8 x float>* %x
  ret void
}

define void @splat_v4f64(<4 x double>* %x, double %y) {
; LMULMAX2-LABEL: splat_v4f64:
; LMULMAX2:       # %bb.0:
; LMULMAX2-NEXT:    vsetivli a1, 4, e64,m2,ta,mu
; LMULMAX2-NEXT:    vfmv.v.f v26, fa0
; LMULMAX2-NEXT:    vse64.v v26, (a0)
; LMULMAX2-NEXT:    ret
;
; LMULMAX1-LABEL: splat_v4f64:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    vsetivli a1, 2, e64,m1,ta,mu
; LMULMAX1-NEXT:    vfmv.v.f v25, fa0
; LMULMAX1-NEXT:    addi a1, a0, 16
; LMULMAX1-NEXT:    vse64.v v25, (a1)
; LMULMAX1-NEXT:    vse64.v v25, (a0)
; LMULMAX1-NEXT:    ret
  %a = insertelement <4 x double> undef, double %y, i32 0
  %b = shufflevector <4 x double> %a, <4 x double> undef, <4 x i32> zeroinitializer
  store <4 x double> %b, <4 x double>* %x
  ret void
}

define void @splat_zero_v8f16(<8 x half>* %x) {
; CHECK-LABEL: splat_zero_v8f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli a1, 8, e16,m1,ta,mu
; CHECK-NEXT:    vmv.v.i v25, 0
; CHECK-NEXT:    vse16.v v25, (a0)
; CHECK-NEXT:    ret
  %a = insertelement <8 x half> undef, half 0.0, i32 0
  %b = shufflevector <8 x half> %a, <8 x half> undef, <8 x i32> zeroinitializer
  store <8 x half> %b, <8 x half>* %x
  ret void
}

define void @splat_zero_v4f32(<4 x float>* %x) {
; CHECK-LABEL: splat_zero_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli a1, 4, e32,m1,ta,mu
; CHECK-NEXT:    vmv.v.i v25, 0
; CHECK-NEXT:    vse32.v v25, (a0)
; CHECK-NEXT:    ret
  %a = insertelement <4 x float> undef, float 0.0, i32 0
  %b = shufflevector <4 x float> %a, <4 x float> undef, <4 x i32> zeroinitializer
  store <4 x float> %b, <4 x float>* %x
  ret void
}

define void @splat_zero_v2f64(<2 x double>* %x) {
; CHECK-LABEL: splat_zero_v2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli a1, 2, e64,m1,ta,mu
; CHECK-NEXT:    vmv.v.i v25, 0
; CHECK-NEXT:    vse64.v v25, (a0)
; CHECK-NEXT:    ret
  %a = insertelement <2 x double> undef, double 0.0, i32 0
  %b = shufflevector <2 x double> %a, <2 x double> undef, <2 x i32> zeroinitializer
  store <2 x double> %b, <2 x double>* %x
  ret void
}

define void @splat_zero_16f16(<16 x half>* %x) {
; LMULMAX2-LABEL: splat_zero_16f16:
; LMULMAX2:       # %bb.0:
; LMULMAX2-NEXT:    vsetivli a1, 16, e16,m2,ta,mu
; LMULMAX2-NEXT:    vmv.v.i v26, 0
; LMULMAX2-NEXT:    vse16.v v26, (a0)
; LMULMAX2-NEXT:    ret
;
; LMULMAX1-LABEL: splat_zero_16f16:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    vsetivli a1, 8, e16,m1,ta,mu
; LMULMAX1-NEXT:    vmv.v.i v25, 0
; LMULMAX1-NEXT:    addi a1, a0, 16
; LMULMAX1-NEXT:    vse16.v v25, (a1)
; LMULMAX1-NEXT:    vse16.v v25, (a0)
; LMULMAX1-NEXT:    ret
  %a = insertelement <16 x half> undef, half 0.0, i32 0
  %b = shufflevector <16 x half> %a, <16 x half> undef, <16 x i32> zeroinitializer
  store <16 x half> %b, <16 x half>* %x
  ret void
}

define void @splat_zero_v8f32(<8 x float>* %x) {
; LMULMAX2-LABEL: splat_zero_v8f32:
; LMULMAX2:       # %bb.0:
; LMULMAX2-NEXT:    vsetivli a1, 8, e32,m2,ta,mu
; LMULMAX2-NEXT:    vmv.v.i v26, 0
; LMULMAX2-NEXT:    vse32.v v26, (a0)
; LMULMAX2-NEXT:    ret
;
; LMULMAX1-LABEL: splat_zero_v8f32:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    vsetivli a1, 4, e32,m1,ta,mu
; LMULMAX1-NEXT:    vmv.v.i v25, 0
; LMULMAX1-NEXT:    addi a1, a0, 16
; LMULMAX1-NEXT:    vse32.v v25, (a1)
; LMULMAX1-NEXT:    vse32.v v25, (a0)
; LMULMAX1-NEXT:    ret
  %a = insertelement <8 x float> undef, float 0.0, i32 0
  %b = shufflevector <8 x float> %a, <8 x float> undef, <8 x i32> zeroinitializer
  store <8 x float> %b, <8 x float>* %x
  ret void
}

define void @splat_zero_v4f64(<4 x double>* %x) {
; LMULMAX2-LABEL: splat_zero_v4f64:
; LMULMAX2:       # %bb.0:
; LMULMAX2-NEXT:    vsetivli a1, 4, e64,m2,ta,mu
; LMULMAX2-NEXT:    vmv.v.i v26, 0
; LMULMAX2-NEXT:    vse64.v v26, (a0)
; LMULMAX2-NEXT:    ret
;
; LMULMAX1-LABEL: splat_zero_v4f64:
; LMULMAX1:       # %bb.0:
; LMULMAX1-NEXT:    vsetivli a1, 2, e64,m1,ta,mu
; LMULMAX1-NEXT:    vmv.v.i v25, 0
; LMULMAX1-NEXT:    addi a1, a0, 16
; LMULMAX1-NEXT:    vse64.v v25, (a1)
; LMULMAX1-NEXT:    vse64.v v25, (a0)
; LMULMAX1-NEXT:    ret
  %a = insertelement <4 x double> undef, double 0.0, i32 0
  %b = shufflevector <4 x double> %a, <4 x double> undef, <4 x i32> zeroinitializer
  store <4 x double> %b, <4 x double>* %x
  ret void
}
