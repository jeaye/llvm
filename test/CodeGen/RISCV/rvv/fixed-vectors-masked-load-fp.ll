; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+m,+experimental-v,+f,+d,+experimental-zfh -riscv-v-vector-bits-min=128 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,RV32
; RUN: llc -mtriple=riscv64 -mattr=+m,+experimental-v,+f,+d,+experimental-zfh -riscv-v-vector-bits-min=128 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,RV64

define void @masked_load_v1f16(<1 x half>* %a, <1 x half>* %m_ptr, <1 x half>* %res_ptr) nounwind {
; CHECK-LABEL: masked_load_v1f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e16,mf4,ta,mu
; CHECK-NEXT:    vle16.v v25, (a1)
; CHECK-NEXT:    fmv.h.x ft0, zero
; CHECK-NEXT:    vmfeq.vf v0, v25, ft0
; CHECK-NEXT:    vle16.v v25, (a0), v0.t
; CHECK-NEXT:    vse16.v v25, (a2)
; CHECK-NEXT:    ret
  %m = load <1 x half>, <1 x half>* %m_ptr
  %mask = fcmp oeq <1 x half> %m, zeroinitializer
  %load = call <1 x half> @llvm.masked.load.v1f16(<1 x half>* %a, i32 8, <1 x i1> %mask, <1 x half> undef)
  store <1 x half> %load, <1 x half>* %res_ptr
  ret void
}
declare <1 x half> @llvm.masked.load.v1f16(<1 x half>*, i32, <1 x i1>, <1 x half>)

define void @masked_load_v1f32(<1 x float>* %a, <1 x float>* %m_ptr, <1 x float>* %res_ptr) nounwind {
; CHECK-LABEL: masked_load_v1f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e32,mf2,ta,mu
; CHECK-NEXT:    vle32.v v25, (a1)
; CHECK-NEXT:    fmv.w.x ft0, zero
; CHECK-NEXT:    vmfeq.vf v0, v25, ft0
; CHECK-NEXT:    vle32.v v25, (a0), v0.t
; CHECK-NEXT:    vse32.v v25, (a2)
; CHECK-NEXT:    ret
  %m = load <1 x float>, <1 x float>* %m_ptr
  %mask = fcmp oeq <1 x float> %m, zeroinitializer
  %load = call <1 x float> @llvm.masked.load.v1f32(<1 x float>* %a, i32 8, <1 x i1> %mask, <1 x float> undef)
  store <1 x float> %load, <1 x float>* %res_ptr
  ret void
}
declare <1 x float> @llvm.masked.load.v1f32(<1 x float>*, i32, <1 x i1>, <1 x float>)

define void @masked_load_v1f64(<1 x double>* %a, <1 x double>* %m_ptr, <1 x double>* %res_ptr) nounwind {
; RV32-LABEL: masked_load_v1f64:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetivli zero, 1, e64,m1,ta,mu
; RV32-NEXT:    vle64.v v25, (a1)
; RV32-NEXT:    fcvt.d.w ft0, zero
; RV32-NEXT:    vmfeq.vf v0, v25, ft0
; RV32-NEXT:    vle64.v v25, (a0), v0.t
; RV32-NEXT:    vse64.v v25, (a2)
; RV32-NEXT:    ret
;
; RV64-LABEL: masked_load_v1f64:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetivli zero, 1, e64,m1,ta,mu
; RV64-NEXT:    vle64.v v25, (a1)
; RV64-NEXT:    fmv.d.x ft0, zero
; RV64-NEXT:    vmfeq.vf v0, v25, ft0
; RV64-NEXT:    vle64.v v25, (a0), v0.t
; RV64-NEXT:    vse64.v v25, (a2)
; RV64-NEXT:    ret
  %m = load <1 x double>, <1 x double>* %m_ptr
  %mask = fcmp oeq <1 x double> %m, zeroinitializer
  %load = call <1 x double> @llvm.masked.load.v1f64(<1 x double>* %a, i32 8, <1 x i1> %mask, <1 x double> undef)
  store <1 x double> %load, <1 x double>* %res_ptr
  ret void
}
declare <1 x double> @llvm.masked.load.v1f64(<1 x double>*, i32, <1 x i1>, <1 x double>)

define void @masked_load_v2f16(<2 x half>* %a, <2 x half>* %m_ptr, <2 x half>* %res_ptr) nounwind {
; CHECK-LABEL: masked_load_v2f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e16,mf4,ta,mu
; CHECK-NEXT:    vle16.v v25, (a1)
; CHECK-NEXT:    fmv.h.x ft0, zero
; CHECK-NEXT:    vmfeq.vf v0, v25, ft0
; CHECK-NEXT:    vle16.v v25, (a0), v0.t
; CHECK-NEXT:    vse16.v v25, (a2)
; CHECK-NEXT:    ret
  %m = load <2 x half>, <2 x half>* %m_ptr
  %mask = fcmp oeq <2 x half> %m, zeroinitializer
  %load = call <2 x half> @llvm.masked.load.v2f16(<2 x half>* %a, i32 8, <2 x i1> %mask, <2 x half> undef)
  store <2 x half> %load, <2 x half>* %res_ptr
  ret void
}
declare <2 x half> @llvm.masked.load.v2f16(<2 x half>*, i32, <2 x i1>, <2 x half>)

define void @masked_load_v2f32(<2 x float>* %a, <2 x float>* %m_ptr, <2 x float>* %res_ptr) nounwind {
; CHECK-LABEL: masked_load_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e32,mf2,ta,mu
; CHECK-NEXT:    vle32.v v25, (a1)
; CHECK-NEXT:    fmv.w.x ft0, zero
; CHECK-NEXT:    vmfeq.vf v0, v25, ft0
; CHECK-NEXT:    vle32.v v25, (a0), v0.t
; CHECK-NEXT:    vse32.v v25, (a2)
; CHECK-NEXT:    ret
  %m = load <2 x float>, <2 x float>* %m_ptr
  %mask = fcmp oeq <2 x float> %m, zeroinitializer
  %load = call <2 x float> @llvm.masked.load.v2f32(<2 x float>* %a, i32 8, <2 x i1> %mask, <2 x float> undef)
  store <2 x float> %load, <2 x float>* %res_ptr
  ret void
}
declare <2 x float> @llvm.masked.load.v2f32(<2 x float>*, i32, <2 x i1>, <2 x float>)

define void @masked_load_v2f64(<2 x double>* %a, <2 x double>* %m_ptr, <2 x double>* %res_ptr) nounwind {
; RV32-LABEL: masked_load_v2f64:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetivli zero, 2, e64,m1,ta,mu
; RV32-NEXT:    vle64.v v25, (a1)
; RV32-NEXT:    fcvt.d.w ft0, zero
; RV32-NEXT:    vmfeq.vf v0, v25, ft0
; RV32-NEXT:    vle64.v v25, (a0), v0.t
; RV32-NEXT:    vse64.v v25, (a2)
; RV32-NEXT:    ret
;
; RV64-LABEL: masked_load_v2f64:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetivli zero, 2, e64,m1,ta,mu
; RV64-NEXT:    vle64.v v25, (a1)
; RV64-NEXT:    fmv.d.x ft0, zero
; RV64-NEXT:    vmfeq.vf v0, v25, ft0
; RV64-NEXT:    vle64.v v25, (a0), v0.t
; RV64-NEXT:    vse64.v v25, (a2)
; RV64-NEXT:    ret
  %m = load <2 x double>, <2 x double>* %m_ptr
  %mask = fcmp oeq <2 x double> %m, zeroinitializer
  %load = call <2 x double> @llvm.masked.load.v2f64(<2 x double>* %a, i32 8, <2 x i1> %mask, <2 x double> undef)
  store <2 x double> %load, <2 x double>* %res_ptr
  ret void
}
declare <2 x double> @llvm.masked.load.v2f64(<2 x double>*, i32, <2 x i1>, <2 x double>)

define void @masked_load_v4f16(<4 x half>* %a, <4 x half>* %m_ptr, <4 x half>* %res_ptr) nounwind {
; CHECK-LABEL: masked_load_v4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e16,mf2,ta,mu
; CHECK-NEXT:    vle16.v v25, (a1)
; CHECK-NEXT:    fmv.h.x ft0, zero
; CHECK-NEXT:    vmfeq.vf v0, v25, ft0
; CHECK-NEXT:    vle16.v v25, (a0), v0.t
; CHECK-NEXT:    vse16.v v25, (a2)
; CHECK-NEXT:    ret
  %m = load <4 x half>, <4 x half>* %m_ptr
  %mask = fcmp oeq <4 x half> %m, zeroinitializer
  %load = call <4 x half> @llvm.masked.load.v4f16(<4 x half>* %a, i32 8, <4 x i1> %mask, <4 x half> undef)
  store <4 x half> %load, <4 x half>* %res_ptr
  ret void
}
declare <4 x half> @llvm.masked.load.v4f16(<4 x half>*, i32, <4 x i1>, <4 x half>)

define void @masked_load_v4f32(<4 x float>* %a, <4 x float>* %m_ptr, <4 x float>* %res_ptr) nounwind {
; CHECK-LABEL: masked_load_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e32,m1,ta,mu
; CHECK-NEXT:    vle32.v v25, (a1)
; CHECK-NEXT:    fmv.w.x ft0, zero
; CHECK-NEXT:    vmfeq.vf v0, v25, ft0
; CHECK-NEXT:    vle32.v v25, (a0), v0.t
; CHECK-NEXT:    vse32.v v25, (a2)
; CHECK-NEXT:    ret
  %m = load <4 x float>, <4 x float>* %m_ptr
  %mask = fcmp oeq <4 x float> %m, zeroinitializer
  %load = call <4 x float> @llvm.masked.load.v4f32(<4 x float>* %a, i32 8, <4 x i1> %mask, <4 x float> undef)
  store <4 x float> %load, <4 x float>* %res_ptr
  ret void
}
declare <4 x float> @llvm.masked.load.v4f32(<4 x float>*, i32, <4 x i1>, <4 x float>)

define void @masked_load_v4f64(<4 x double>* %a, <4 x double>* %m_ptr, <4 x double>* %res_ptr) nounwind {
; RV32-LABEL: masked_load_v4f64:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetivli zero, 4, e64,m2,ta,mu
; RV32-NEXT:    vle64.v v26, (a1)
; RV32-NEXT:    fcvt.d.w ft0, zero
; RV32-NEXT:    vmfeq.vf v0, v26, ft0
; RV32-NEXT:    vle64.v v26, (a0), v0.t
; RV32-NEXT:    vse64.v v26, (a2)
; RV32-NEXT:    ret
;
; RV64-LABEL: masked_load_v4f64:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetivli zero, 4, e64,m2,ta,mu
; RV64-NEXT:    vle64.v v26, (a1)
; RV64-NEXT:    fmv.d.x ft0, zero
; RV64-NEXT:    vmfeq.vf v0, v26, ft0
; RV64-NEXT:    vle64.v v26, (a0), v0.t
; RV64-NEXT:    vse64.v v26, (a2)
; RV64-NEXT:    ret
  %m = load <4 x double>, <4 x double>* %m_ptr
  %mask = fcmp oeq <4 x double> %m, zeroinitializer
  %load = call <4 x double> @llvm.masked.load.v4f64(<4 x double>* %a, i32 8, <4 x i1> %mask, <4 x double> undef)
  store <4 x double> %load, <4 x double>* %res_ptr
  ret void
}
declare <4 x double> @llvm.masked.load.v4f64(<4 x double>*, i32, <4 x i1>, <4 x double>)

define void @masked_load_v8f16(<8 x half>* %a, <8 x half>* %m_ptr, <8 x half>* %res_ptr) nounwind {
; CHECK-LABEL: masked_load_v8f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e16,m1,ta,mu
; CHECK-NEXT:    vle16.v v25, (a1)
; CHECK-NEXT:    fmv.h.x ft0, zero
; CHECK-NEXT:    vmfeq.vf v0, v25, ft0
; CHECK-NEXT:    vle16.v v25, (a0), v0.t
; CHECK-NEXT:    vse16.v v25, (a2)
; CHECK-NEXT:    ret
  %m = load <8 x half>, <8 x half>* %m_ptr
  %mask = fcmp oeq <8 x half> %m, zeroinitializer
  %load = call <8 x half> @llvm.masked.load.v8f16(<8 x half>* %a, i32 8, <8 x i1> %mask, <8 x half> undef)
  store <8 x half> %load, <8 x half>* %res_ptr
  ret void
}
declare <8 x half> @llvm.masked.load.v8f16(<8 x half>*, i32, <8 x i1>, <8 x half>)

define void @masked_load_v8f32(<8 x float>* %a, <8 x float>* %m_ptr, <8 x float>* %res_ptr) nounwind {
; CHECK-LABEL: masked_load_v8f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e32,m2,ta,mu
; CHECK-NEXT:    vle32.v v26, (a1)
; CHECK-NEXT:    fmv.w.x ft0, zero
; CHECK-NEXT:    vmfeq.vf v0, v26, ft0
; CHECK-NEXT:    vle32.v v26, (a0), v0.t
; CHECK-NEXT:    vse32.v v26, (a2)
; CHECK-NEXT:    ret
  %m = load <8 x float>, <8 x float>* %m_ptr
  %mask = fcmp oeq <8 x float> %m, zeroinitializer
  %load = call <8 x float> @llvm.masked.load.v8f32(<8 x float>* %a, i32 8, <8 x i1> %mask, <8 x float> undef)
  store <8 x float> %load, <8 x float>* %res_ptr
  ret void
}
declare <8 x float> @llvm.masked.load.v8f32(<8 x float>*, i32, <8 x i1>, <8 x float>)

define void @masked_load_v8f64(<8 x double>* %a, <8 x double>* %m_ptr, <8 x double>* %res_ptr) nounwind {
; RV32-LABEL: masked_load_v8f64:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetivli zero, 8, e64,m4,ta,mu
; RV32-NEXT:    vle64.v v28, (a1)
; RV32-NEXT:    fcvt.d.w ft0, zero
; RV32-NEXT:    vmfeq.vf v0, v28, ft0
; RV32-NEXT:    vle64.v v28, (a0), v0.t
; RV32-NEXT:    vse64.v v28, (a2)
; RV32-NEXT:    ret
;
; RV64-LABEL: masked_load_v8f64:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetivli zero, 8, e64,m4,ta,mu
; RV64-NEXT:    vle64.v v28, (a1)
; RV64-NEXT:    fmv.d.x ft0, zero
; RV64-NEXT:    vmfeq.vf v0, v28, ft0
; RV64-NEXT:    vle64.v v28, (a0), v0.t
; RV64-NEXT:    vse64.v v28, (a2)
; RV64-NEXT:    ret
  %m = load <8 x double>, <8 x double>* %m_ptr
  %mask = fcmp oeq <8 x double> %m, zeroinitializer
  %load = call <8 x double> @llvm.masked.load.v8f64(<8 x double>* %a, i32 8, <8 x i1> %mask, <8 x double> undef)
  store <8 x double> %load, <8 x double>* %res_ptr
  ret void
}
declare <8 x double> @llvm.masked.load.v8f64(<8 x double>*, i32, <8 x i1>, <8 x double>)

define void @masked_load_v16f16(<16 x half>* %a, <16 x half>* %m_ptr, <16 x half>* %res_ptr) nounwind {
; CHECK-LABEL: masked_load_v16f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 16, e16,m2,ta,mu
; CHECK-NEXT:    vle16.v v26, (a1)
; CHECK-NEXT:    fmv.h.x ft0, zero
; CHECK-NEXT:    vmfeq.vf v0, v26, ft0
; CHECK-NEXT:    vle16.v v26, (a0), v0.t
; CHECK-NEXT:    vse16.v v26, (a2)
; CHECK-NEXT:    ret
  %m = load <16 x half>, <16 x half>* %m_ptr
  %mask = fcmp oeq <16 x half> %m, zeroinitializer
  %load = call <16 x half> @llvm.masked.load.v16f16(<16 x half>* %a, i32 8, <16 x i1> %mask, <16 x half> undef)
  store <16 x half> %load, <16 x half>* %res_ptr
  ret void
}
declare <16 x half> @llvm.masked.load.v16f16(<16 x half>*, i32, <16 x i1>, <16 x half>)

define void @masked_load_v16f32(<16 x float>* %a, <16 x float>* %m_ptr, <16 x float>* %res_ptr) nounwind {
; CHECK-LABEL: masked_load_v16f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 16, e32,m4,ta,mu
; CHECK-NEXT:    vle32.v v28, (a1)
; CHECK-NEXT:    fmv.w.x ft0, zero
; CHECK-NEXT:    vmfeq.vf v0, v28, ft0
; CHECK-NEXT:    vle32.v v28, (a0), v0.t
; CHECK-NEXT:    vse32.v v28, (a2)
; CHECK-NEXT:    ret
  %m = load <16 x float>, <16 x float>* %m_ptr
  %mask = fcmp oeq <16 x float> %m, zeroinitializer
  %load = call <16 x float> @llvm.masked.load.v16f32(<16 x float>* %a, i32 8, <16 x i1> %mask, <16 x float> undef)
  store <16 x float> %load, <16 x float>* %res_ptr
  ret void
}
declare <16 x float> @llvm.masked.load.v16f32(<16 x float>*, i32, <16 x i1>, <16 x float>)

define void @masked_load_v16f64(<16 x double>* %a, <16 x double>* %m_ptr, <16 x double>* %res_ptr) nounwind {
; RV32-LABEL: masked_load_v16f64:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetivli zero, 16, e64,m8,ta,mu
; RV32-NEXT:    vle64.v v8, (a1)
; RV32-NEXT:    fcvt.d.w ft0, zero
; RV32-NEXT:    vmfeq.vf v0, v8, ft0
; RV32-NEXT:    vle64.v v8, (a0), v0.t
; RV32-NEXT:    vse64.v v8, (a2)
; RV32-NEXT:    ret
;
; RV64-LABEL: masked_load_v16f64:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetivli zero, 16, e64,m8,ta,mu
; RV64-NEXT:    vle64.v v8, (a1)
; RV64-NEXT:    fmv.d.x ft0, zero
; RV64-NEXT:    vmfeq.vf v0, v8, ft0
; RV64-NEXT:    vle64.v v8, (a0), v0.t
; RV64-NEXT:    vse64.v v8, (a2)
; RV64-NEXT:    ret
  %m = load <16 x double>, <16 x double>* %m_ptr
  %mask = fcmp oeq <16 x double> %m, zeroinitializer
  %load = call <16 x double> @llvm.masked.load.v16f64(<16 x double>* %a, i32 8, <16 x i1> %mask, <16 x double> undef)
  store <16 x double> %load, <16 x double>* %res_ptr
  ret void
}
declare <16 x double> @llvm.masked.load.v16f64(<16 x double>*, i32, <16 x i1>, <16 x double>)

define void @masked_load_v32f16(<32 x half>* %a, <32 x half>* %m_ptr, <32 x half>* %res_ptr) nounwind {
; CHECK-LABEL: masked_load_v32f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a3, zero, 32
; CHECK-NEXT:    vsetvli zero, a3, e16,m4,ta,mu
; CHECK-NEXT:    vle16.v v28, (a1)
; CHECK-NEXT:    fmv.h.x ft0, zero
; CHECK-NEXT:    vmfeq.vf v0, v28, ft0
; CHECK-NEXT:    vle16.v v28, (a0), v0.t
; CHECK-NEXT:    vse16.v v28, (a2)
; CHECK-NEXT:    ret
  %m = load <32 x half>, <32 x half>* %m_ptr
  %mask = fcmp oeq <32 x half> %m, zeroinitializer
  %load = call <32 x half> @llvm.masked.load.v32f16(<32 x half>* %a, i32 8, <32 x i1> %mask, <32 x half> undef)
  store <32 x half> %load, <32 x half>* %res_ptr
  ret void
}
declare <32 x half> @llvm.masked.load.v32f16(<32 x half>*, i32, <32 x i1>, <32 x half>)

define void @masked_load_v32f32(<32 x float>* %a, <32 x float>* %m_ptr, <32 x float>* %res_ptr) nounwind {
; CHECK-LABEL: masked_load_v32f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a3, zero, 32
; CHECK-NEXT:    vsetvli zero, a3, e32,m8,ta,mu
; CHECK-NEXT:    vle32.v v8, (a1)
; CHECK-NEXT:    fmv.w.x ft0, zero
; CHECK-NEXT:    vmfeq.vf v0, v8, ft0
; CHECK-NEXT:    vle32.v v8, (a0), v0.t
; CHECK-NEXT:    vse32.v v8, (a2)
; CHECK-NEXT:    ret
  %m = load <32 x float>, <32 x float>* %m_ptr
  %mask = fcmp oeq <32 x float> %m, zeroinitializer
  %load = call <32 x float> @llvm.masked.load.v32f32(<32 x float>* %a, i32 8, <32 x i1> %mask, <32 x float> undef)
  store <32 x float> %load, <32 x float>* %res_ptr
  ret void
}
declare <32 x float> @llvm.masked.load.v32f32(<32 x float>*, i32, <32 x i1>, <32 x float>)

define void @masked_load_v32f64(<32 x double>* %a, <32 x double>* %m_ptr, <32 x double>* %res_ptr) nounwind {
; RV32-LABEL: masked_load_v32f64:
; RV32:       # %bb.0:
; RV32-NEXT:    addi a3, a1, 128
; RV32-NEXT:    vsetivli zero, 16, e64,m8,ta,mu
; RV32-NEXT:    vle64.v v8, (a1)
; RV32-NEXT:    vle64.v v16, (a3)
; RV32-NEXT:    fcvt.d.w ft0, zero
; RV32-NEXT:    vmfeq.vf v25, v8, ft0
; RV32-NEXT:    vmfeq.vf v0, v16, ft0
; RV32-NEXT:    addi a1, a0, 128
; RV32-NEXT:    vle64.v v8, (a1), v0.t
; RV32-NEXT:    vmv1r.v v0, v25
; RV32-NEXT:    vle64.v v16, (a0), v0.t
; RV32-NEXT:    vse64.v v16, (a2)
; RV32-NEXT:    addi a0, a2, 128
; RV32-NEXT:    vse64.v v8, (a0)
; RV32-NEXT:    ret
;
; RV64-LABEL: masked_load_v32f64:
; RV64:       # %bb.0:
; RV64-NEXT:    addi a3, a1, 128
; RV64-NEXT:    vsetivli zero, 16, e64,m8,ta,mu
; RV64-NEXT:    vle64.v v8, (a1)
; RV64-NEXT:    vle64.v v16, (a3)
; RV64-NEXT:    fmv.d.x ft0, zero
; RV64-NEXT:    vmfeq.vf v25, v8, ft0
; RV64-NEXT:    vmfeq.vf v0, v16, ft0
; RV64-NEXT:    addi a1, a0, 128
; RV64-NEXT:    vle64.v v8, (a1), v0.t
; RV64-NEXT:    vmv1r.v v0, v25
; RV64-NEXT:    vle64.v v16, (a0), v0.t
; RV64-NEXT:    vse64.v v16, (a2)
; RV64-NEXT:    addi a0, a2, 128
; RV64-NEXT:    vse64.v v8, (a0)
; RV64-NEXT:    ret
  %m = load <32 x double>, <32 x double>* %m_ptr
  %mask = fcmp oeq <32 x double> %m, zeroinitializer
  %load = call <32 x double> @llvm.masked.load.v32f64(<32 x double>* %a, i32 8, <32 x i1> %mask, <32 x double> undef)
  store <32 x double> %load, <32 x double>* %res_ptr
  ret void
}
declare <32 x double> @llvm.masked.load.v32f64(<32 x double>*, i32, <32 x i1>, <32 x double>)

define void @masked_load_v64f16(<64 x half>* %a, <64 x half>* %m_ptr, <64 x half>* %res_ptr) nounwind {
; CHECK-LABEL: masked_load_v64f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a3, zero, 64
; CHECK-NEXT:    vsetvli zero, a3, e16,m8,ta,mu
; CHECK-NEXT:    vle16.v v8, (a1)
; CHECK-NEXT:    fmv.h.x ft0, zero
; CHECK-NEXT:    vmfeq.vf v0, v8, ft0
; CHECK-NEXT:    vle16.v v8, (a0), v0.t
; CHECK-NEXT:    vse16.v v8, (a2)
; CHECK-NEXT:    ret
  %m = load <64 x half>, <64 x half>* %m_ptr
  %mask = fcmp oeq <64 x half> %m, zeroinitializer
  %load = call <64 x half> @llvm.masked.load.v64f16(<64 x half>* %a, i32 8, <64 x i1> %mask, <64 x half> undef)
  store <64 x half> %load, <64 x half>* %res_ptr
  ret void
}
declare <64 x half> @llvm.masked.load.v64f16(<64 x half>*, i32, <64 x i1>, <64 x half>)

define void @masked_load_v64f32(<64 x float>* %a, <64 x float>* %m_ptr, <64 x float>* %res_ptr) nounwind {
; CHECK-LABEL: masked_load_v64f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a3, a1, 128
; CHECK-NEXT:    addi a4, zero, 32
; CHECK-NEXT:    vsetvli zero, a4, e32,m8,ta,mu
; CHECK-NEXT:    vle32.v v8, (a1)
; CHECK-NEXT:    vle32.v v16, (a3)
; CHECK-NEXT:    fmv.w.x ft0, zero
; CHECK-NEXT:    vmfeq.vf v25, v8, ft0
; CHECK-NEXT:    vmfeq.vf v0, v16, ft0
; CHECK-NEXT:    addi a1, a0, 128
; CHECK-NEXT:    vle32.v v8, (a1), v0.t
; CHECK-NEXT:    vmv1r.v v0, v25
; CHECK-NEXT:    vle32.v v16, (a0), v0.t
; CHECK-NEXT:    vse32.v v16, (a2)
; CHECK-NEXT:    addi a0, a2, 128
; CHECK-NEXT:    vse32.v v8, (a0)
; CHECK-NEXT:    ret
  %m = load <64 x float>, <64 x float>* %m_ptr
  %mask = fcmp oeq <64 x float> %m, zeroinitializer
  %load = call <64 x float> @llvm.masked.load.v64f32(<64 x float>* %a, i32 8, <64 x i1> %mask, <64 x float> undef)
  store <64 x float> %load, <64 x float>* %res_ptr
  ret void
}
declare <64 x float> @llvm.masked.load.v64f32(<64 x float>*, i32, <64 x i1>, <64 x float>)

define void @masked_load_v128f16(<128 x half>* %a, <128 x half>* %m_ptr, <128 x half>* %res_ptr) nounwind {
; CHECK-LABEL: masked_load_v128f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a3, a1, 128
; CHECK-NEXT:    addi a4, zero, 64
; CHECK-NEXT:    vsetvli zero, a4, e16,m8,ta,mu
; CHECK-NEXT:    vle16.v v8, (a1)
; CHECK-NEXT:    vle16.v v16, (a3)
; CHECK-NEXT:    fmv.h.x ft0, zero
; CHECK-NEXT:    vmfeq.vf v25, v8, ft0
; CHECK-NEXT:    vmfeq.vf v0, v16, ft0
; CHECK-NEXT:    addi a1, a0, 128
; CHECK-NEXT:    vle16.v v8, (a1), v0.t
; CHECK-NEXT:    vmv1r.v v0, v25
; CHECK-NEXT:    vle16.v v16, (a0), v0.t
; CHECK-NEXT:    vse16.v v16, (a2)
; CHECK-NEXT:    addi a0, a2, 128
; CHECK-NEXT:    vse16.v v8, (a0)
; CHECK-NEXT:    ret
  %m = load <128 x half>, <128 x half>* %m_ptr
  %mask = fcmp oeq <128 x half> %m, zeroinitializer
  %load = call <128 x half> @llvm.masked.load.v128f16(<128 x half>* %a, i32 8, <128 x i1> %mask, <128 x half> undef)
  store <128 x half> %load, <128 x half>* %res_ptr
  ret void
}
declare <128 x half> @llvm.masked.load.v128f16(<128 x half>*, i32, <128 x i1>, <128 x half>)
