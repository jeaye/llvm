; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-- -mcpu=nehalem     | FileCheck %s --check-prefixes=NHM
; RUN: llc < %s -mtriple=x86_64-- -mcpu=sandybridge | FileCheck %s --check-prefixes=FAST-SCALAR,SNB
; RUN: llc < %s -mtriple=x86_64-- -mcpu=broadwell   | FileCheck %s --check-prefixes=FAST-SCALAR,BDW
; RUN: llc < %s -mtriple=x86_64-- -mcpu=skylake     | FileCheck %s --check-prefixes=FAST-SCALAR,SKL

define float @f32_no_daz(float %f) #0 {
; NHM-LABEL: f32_no_daz:
; NHM:       # %bb.0:
; NHM-NEXT:    rsqrtss %xmm0, %xmm1
; NHM-NEXT:    movaps %xmm0, %xmm2
; NHM-NEXT:    mulss %xmm1, %xmm2
; NHM-NEXT:    movss {{.*#+}} xmm3 = mem[0],zero,zero,zero
; NHM-NEXT:    mulss %xmm2, %xmm3
; NHM-NEXT:    mulss %xmm1, %xmm2
; NHM-NEXT:    addss {{.*}}(%rip), %xmm2
; NHM-NEXT:    andps {{.*}}(%rip), %xmm0
; NHM-NEXT:    mulss %xmm3, %xmm2
; NHM-NEXT:    cmpltss {{.*}}(%rip), %xmm0
; NHM-NEXT:    andnps %xmm2, %xmm0
; NHM-NEXT:    retq
;
; FAST-SCALAR-LABEL: f32_no_daz:
; FAST-SCALAR:       # %bb.0:
; FAST-SCALAR-NEXT:    vsqrtss %xmm0, %xmm0, %xmm0
; FAST-SCALAR-NEXT:    retq
  %call = tail call fast float @llvm.sqrt.f32(float %f) #2
  ret float %call
}

define <4 x float> @v4f32_no_daz(<4 x float> %f) #0 {
; NHM-LABEL: v4f32_no_daz:
; NHM:       # %bb.0:
; NHM-NEXT:    rsqrtps %xmm0, %xmm2
; NHM-NEXT:    movaps %xmm0, %xmm1
; NHM-NEXT:    mulps %xmm2, %xmm1
; NHM-NEXT:    movaps {{.*#+}} xmm3 = [-5.0E-1,-5.0E-1,-5.0E-1,-5.0E-1]
; NHM-NEXT:    mulps %xmm1, %xmm3
; NHM-NEXT:    mulps %xmm2, %xmm1
; NHM-NEXT:    addps {{.*}}(%rip), %xmm1
; NHM-NEXT:    andps {{.*}}(%rip), %xmm0
; NHM-NEXT:    mulps %xmm3, %xmm1
; NHM-NEXT:    movaps {{.*#+}} xmm2 = [1.17549435E-38,1.17549435E-38,1.17549435E-38,1.17549435E-38]
; NHM-NEXT:    cmpleps %xmm0, %xmm2
; NHM-NEXT:    andps %xmm2, %xmm1
; NHM-NEXT:    movaps %xmm1, %xmm0
; NHM-NEXT:    retq
;
; SNB-LABEL: v4f32_no_daz:
; SNB:       # %bb.0:
; SNB-NEXT:    vrsqrtps %xmm0, %xmm1
; SNB-NEXT:    vmulps %xmm1, %xmm0, %xmm2
; SNB-NEXT:    vmulps {{.*}}(%rip), %xmm2, %xmm3
; SNB-NEXT:    vmulps %xmm1, %xmm2, %xmm1
; SNB-NEXT:    vaddps {{.*}}(%rip), %xmm1, %xmm1
; SNB-NEXT:    vandps {{.*}}(%rip), %xmm0, %xmm0
; SNB-NEXT:    vmulps %xmm1, %xmm3, %xmm1
; SNB-NEXT:    vmovaps {{.*#+}} xmm2 = [1.17549435E-38,1.17549435E-38,1.17549435E-38,1.17549435E-38]
; SNB-NEXT:    vcmpleps %xmm0, %xmm2, %xmm0
; SNB-NEXT:    vandps %xmm1, %xmm0, %xmm0
; SNB-NEXT:    retq
;
; BDW-LABEL: v4f32_no_daz:
; BDW:       # %bb.0:
; BDW-NEXT:    vrsqrtps %xmm0, %xmm1
; BDW-NEXT:    vmulps %xmm1, %xmm0, %xmm2
; BDW-NEXT:    vbroadcastss {{.*#+}} xmm3 = [-3.0E+0,-3.0E+0,-3.0E+0,-3.0E+0]
; BDW-NEXT:    vfmadd231ps {{.*#+}} xmm3 = (xmm2 * xmm1) + xmm3
; BDW-NEXT:    vbroadcastss {{.*#+}} xmm1 = [-5.0E-1,-5.0E-1,-5.0E-1,-5.0E-1]
; BDW-NEXT:    vmulps %xmm1, %xmm2, %xmm1
; BDW-NEXT:    vmulps %xmm3, %xmm1, %xmm1
; BDW-NEXT:    vbroadcastss {{.*#+}} xmm2 = [NaN,NaN,NaN,NaN]
; BDW-NEXT:    vandps %xmm2, %xmm0, %xmm0
; BDW-NEXT:    vbroadcastss {{.*#+}} xmm2 = [1.17549435E-38,1.17549435E-38,1.17549435E-38,1.17549435E-38]
; BDW-NEXT:    vcmpleps %xmm0, %xmm2, %xmm0
; BDW-NEXT:    vandps %xmm1, %xmm0, %xmm0
; BDW-NEXT:    retq
;
; SKL-LABEL: v4f32_no_daz:
; SKL:       # %bb.0:
; SKL-NEXT:    vsqrtps %xmm0, %xmm0
; SKL-NEXT:    retq
; HSW-LABEL: v4f32_no_daz:
; HSW:       # %bb.0:
; HSW-NEXT:    vrsqrtps %xmm0, %xmm1
; HSW-NEXT:    vmulps %xmm1, %xmm0, %xmm2
; HSW-NEXT:    vbroadcastss {{.*#+}} xmm3 = [-3.0E+0,-3.0E+0,-3.0E+0,-3.0E+0]
; HSW-NEXT:    vfmadd231ps {{.*#+}} xmm3 = (xmm2 * xmm1) + xmm3
; HSW-NEXT:    vbroadcastss {{.*#+}} xmm1 = [-5.0E-1,-5.0E-1,-5.0E-1,-5.0E-1]
; HSW-NEXT:    vmulps %xmm1, %xmm2, %xmm1
; HSW-NEXT:    vmulps %xmm3, %xmm1, %xmm1
; HSW-NEXT:    vbroadcastss {{.*#+}} xmm2 = [NaN,NaN,NaN,NaN]
; HSW-NEXT:    vandps %xmm2, %xmm0, %xmm0
; HSW-NEXT:    vbroadcastss {{.*#+}} xmm2 = [1.17549435E-38,1.17549435E-38,1.17549435E-38,1.17549435E-38]
; HSW-NEXT:    vcmpleps %xmm0, %xmm2, %xmm0
; HSW-NEXT:    vandps %xmm1, %xmm0, %xmm0
; HSW-NEXT:    retq
  %call = tail call fast <4 x float> @llvm.sqrt.v4f32(<4 x float> %f) #2
  ret <4 x float> %call
}

define <8 x float> @v8f32_no_daz(<8 x float> %f) #0 {
; NHM-LABEL: v8f32_no_daz:
; NHM:       # %bb.0:
; NHM-NEXT:    sqrtps %xmm0, %xmm0
; NHM-NEXT:    sqrtps %xmm1, %xmm1
; NHM-NEXT:    retq
;
; SNB-LABEL: v8f32_no_daz:
; SNB:       # %bb.0:
; SNB-NEXT:    vrsqrtps %ymm0, %ymm1
; SNB-NEXT:    vmulps %ymm1, %ymm0, %ymm2
; SNB-NEXT:    vmulps {{.*}}(%rip), %ymm2, %ymm3
; SNB-NEXT:    vmulps %ymm1, %ymm2, %ymm1
; SNB-NEXT:    vaddps {{.*}}(%rip), %ymm1, %ymm1
; SNB-NEXT:    vandps {{.*}}(%rip), %ymm0, %ymm0
; SNB-NEXT:    vmulps %ymm1, %ymm3, %ymm1
; SNB-NEXT:    vmovaps {{.*#+}} ymm2 = [1.17549435E-38,1.17549435E-38,1.17549435E-38,1.17549435E-38,1.17549435E-38,1.17549435E-38,1.17549435E-38,1.17549435E-38]
; SNB-NEXT:    vcmpleps %ymm0, %ymm2, %ymm0
; SNB-NEXT:    vandps %ymm1, %ymm0, %ymm0
; SNB-NEXT:    retq
;
; BDW-LABEL: v8f32_no_daz:
; BDW:       # %bb.0:
; BDW-NEXT:    vrsqrtps %ymm0, %ymm1
; BDW-NEXT:    vmulps %ymm1, %ymm0, %ymm2
; BDW-NEXT:    vbroadcastss {{.*#+}} ymm3 = [-3.0E+0,-3.0E+0,-3.0E+0,-3.0E+0,-3.0E+0,-3.0E+0,-3.0E+0,-3.0E+0]
; BDW-NEXT:    vfmadd231ps {{.*#+}} ymm3 = (ymm2 * ymm1) + ymm3
; BDW-NEXT:    vbroadcastss {{.*#+}} ymm1 = [-5.0E-1,-5.0E-1,-5.0E-1,-5.0E-1,-5.0E-1,-5.0E-1,-5.0E-1,-5.0E-1]
; BDW-NEXT:    vmulps %ymm1, %ymm2, %ymm1
; BDW-NEXT:    vmulps %ymm3, %ymm1, %ymm1
; BDW-NEXT:    vbroadcastss {{.*#+}} ymm2 = [NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN]
; BDW-NEXT:    vandps %ymm2, %ymm0, %ymm0
; BDW-NEXT:    vbroadcastss {{.*#+}} ymm2 = [1.17549435E-38,1.17549435E-38,1.17549435E-38,1.17549435E-38,1.17549435E-38,1.17549435E-38,1.17549435E-38,1.17549435E-38]
; BDW-NEXT:    vcmpleps %ymm0, %ymm2, %ymm0
; BDW-NEXT:    vandps %ymm1, %ymm0, %ymm0
; BDW-NEXT:    retq
;
; SKL-LABEL: v8f32_no_daz:
; SKL:       # %bb.0:
; SKL-NEXT:    vsqrtps %ymm0, %ymm0
; SKL-NEXT:    retq
; HSW-LABEL: v8f32_no_daz:
; HSW:       # %bb.0:
; HSW-NEXT:    vrsqrtps %ymm0, %ymm1
; HSW-NEXT:    vmulps %ymm1, %ymm0, %ymm2
; HSW-NEXT:    vbroadcastss {{.*#+}} ymm3 = [-3.0E+0,-3.0E+0,-3.0E+0,-3.0E+0,-3.0E+0,-3.0E+0,-3.0E+0,-3.0E+0]
; HSW-NEXT:    vfmadd231ps {{.*#+}} ymm3 = (ymm2 * ymm1) + ymm3
; HSW-NEXT:    vbroadcastss {{.*#+}} ymm1 = [-5.0E-1,-5.0E-1,-5.0E-1,-5.0E-1,-5.0E-1,-5.0E-1,-5.0E-1,-5.0E-1]
; HSW-NEXT:    vmulps %ymm1, %ymm2, %ymm1
; HSW-NEXT:    vmulps %ymm3, %ymm1, %ymm1
; HSW-NEXT:    vbroadcastss {{.*#+}} ymm2 = [NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN]
; HSW-NEXT:    vandps %ymm2, %ymm0, %ymm0
; HSW-NEXT:    vbroadcastss {{.*#+}} ymm2 = [1.17549435E-38,1.17549435E-38,1.17549435E-38,1.17549435E-38,1.17549435E-38,1.17549435E-38,1.17549435E-38,1.17549435E-38]
; HSW-NEXT:    vcmpleps %ymm0, %ymm2, %ymm0
; HSW-NEXT:    vandps %ymm1, %ymm0, %ymm0
; HSW-NEXT:    retq
  %call = tail call fast <8 x float> @llvm.sqrt.v8f32(<8 x float> %f) #2
  ret <8 x float> %call
}

; Repeat all tests with denorms-as-zero enabled.

define float @f32_daz(float %f) #1 {
; NHM-LABEL: f32_daz:
; NHM:       # %bb.0:
; NHM-NEXT:    rsqrtss %xmm0, %xmm1
; NHM-NEXT:    movaps %xmm0, %xmm2
; NHM-NEXT:    mulss %xmm1, %xmm2
; NHM-NEXT:    movss {{.*#+}} xmm3 = mem[0],zero,zero,zero
; NHM-NEXT:    mulss %xmm2, %xmm3
; NHM-NEXT:    mulss %xmm1, %xmm2
; NHM-NEXT:    addss {{.*}}(%rip), %xmm2
; NHM-NEXT:    mulss %xmm3, %xmm2
; NHM-NEXT:    xorps %xmm1, %xmm1
; NHM-NEXT:    cmpeqss %xmm1, %xmm0
; NHM-NEXT:    andnps %xmm2, %xmm0
; NHM-NEXT:    retq
;
; FAST-SCALAR-LABEL: f32_daz:
; FAST-SCALAR:       # %bb.0:
; FAST-SCALAR-NEXT:    vsqrtss %xmm0, %xmm0, %xmm0
; FAST-SCALAR-NEXT:    retq
  %call = tail call fast float @llvm.sqrt.f32(float %f) #2
  ret float %call
}

define <4 x float> @v4f32_daz(<4 x float> %f) #1 {
; NHM-LABEL: v4f32_daz:
; NHM:       # %bb.0:
; NHM-NEXT:    rsqrtps %xmm0, %xmm1
; NHM-NEXT:    movaps %xmm0, %xmm2
; NHM-NEXT:    mulps %xmm1, %xmm2
; NHM-NEXT:    movaps {{.*#+}} xmm3 = [-5.0E-1,-5.0E-1,-5.0E-1,-5.0E-1]
; NHM-NEXT:    mulps %xmm2, %xmm3
; NHM-NEXT:    mulps %xmm1, %xmm2
; NHM-NEXT:    addps {{.*}}(%rip), %xmm2
; NHM-NEXT:    mulps %xmm3, %xmm2
; NHM-NEXT:    xorps %xmm1, %xmm1
; NHM-NEXT:    cmpneqps %xmm1, %xmm0
; NHM-NEXT:    andps %xmm2, %xmm0
; NHM-NEXT:    retq
;
; SNB-LABEL: v4f32_daz:
; SNB:       # %bb.0:
; SNB-NEXT:    vrsqrtps %xmm0, %xmm1
; SNB-NEXT:    vmulps %xmm1, %xmm0, %xmm2
; SNB-NEXT:    vmulps {{.*}}(%rip), %xmm2, %xmm3
; SNB-NEXT:    vmulps %xmm1, %xmm2, %xmm1
; SNB-NEXT:    vaddps {{.*}}(%rip), %xmm1, %xmm1
; SNB-NEXT:    vmulps %xmm1, %xmm3, %xmm1
; SNB-NEXT:    vxorps %xmm2, %xmm2, %xmm2
; SNB-NEXT:    vcmpneqps %xmm2, %xmm0, %xmm0
; SNB-NEXT:    vandps %xmm1, %xmm0, %xmm0
; SNB-NEXT:    retq
;
; BDW-LABEL: v4f32_daz:
; BDW:       # %bb.0:
; BDW-NEXT:    vrsqrtps %xmm0, %xmm1
; BDW-NEXT:    vmulps %xmm1, %xmm0, %xmm2
; BDW-NEXT:    vbroadcastss {{.*#+}} xmm3 = [-3.0E+0,-3.0E+0,-3.0E+0,-3.0E+0]
; BDW-NEXT:    vfmadd231ps {{.*#+}} xmm3 = (xmm2 * xmm1) + xmm3
; BDW-NEXT:    vbroadcastss {{.*#+}} xmm1 = [-5.0E-1,-5.0E-1,-5.0E-1,-5.0E-1]
; BDW-NEXT:    vmulps %xmm1, %xmm2, %xmm1
; BDW-NEXT:    vmulps %xmm3, %xmm1, %xmm1
; BDW-NEXT:    vxorps %xmm2, %xmm2, %xmm2
; BDW-NEXT:    vcmpneqps %xmm2, %xmm0, %xmm0
; BDW-NEXT:    vandps %xmm1, %xmm0, %xmm0
; BDW-NEXT:    retq
;
; SKL-LABEL: v4f32_daz:
; SKL:       # %bb.0:
; SKL-NEXT:    vsqrtps %xmm0, %xmm0
; SKL-NEXT:    retq
; HSW-LABEL: v4f32_daz:
; HSW:       # %bb.0:
; HSW-NEXT:    vrsqrtps %xmm0, %xmm1
; HSW-NEXT:    vmulps %xmm1, %xmm0, %xmm2
; HSW-NEXT:    vbroadcastss {{.*#+}} xmm3 = [-3.0E+0,-3.0E+0,-3.0E+0,-3.0E+0]
; HSW-NEXT:    vfmadd231ps {{.*#+}} xmm3 = (xmm2 * xmm1) + xmm3
; HSW-NEXT:    vbroadcastss {{.*#+}} xmm1 = [-5.0E-1,-5.0E-1,-5.0E-1,-5.0E-1]
; HSW-NEXT:    vmulps %xmm1, %xmm2, %xmm1
; HSW-NEXT:    vmulps %xmm3, %xmm1, %xmm1
; HSW-NEXT:    vxorps %xmm2, %xmm2, %xmm2
; HSW-NEXT:    vcmpneqps %xmm2, %xmm0, %xmm0
; HSW-NEXT:    vandps %xmm1, %xmm0, %xmm0
; HSW-NEXT:    retq
  %call = tail call fast <4 x float> @llvm.sqrt.v4f32(<4 x float> %f) #2
  ret <4 x float> %call
}

define <8 x float> @v8f32_daz(<8 x float> %f) #1 {
; NHM-LABEL: v8f32_daz:
; NHM:       # %bb.0:
; NHM-NEXT:    sqrtps %xmm0, %xmm0
; NHM-NEXT:    sqrtps %xmm1, %xmm1
; NHM-NEXT:    retq
;
; SNB-LABEL: v8f32_daz:
; SNB:       # %bb.0:
; SNB-NEXT:    vrsqrtps %ymm0, %ymm1
; SNB-NEXT:    vmulps %ymm1, %ymm0, %ymm2
; SNB-NEXT:    vmulps {{.*}}(%rip), %ymm2, %ymm3
; SNB-NEXT:    vmulps %ymm1, %ymm2, %ymm1
; SNB-NEXT:    vaddps {{.*}}(%rip), %ymm1, %ymm1
; SNB-NEXT:    vmulps %ymm1, %ymm3, %ymm1
; SNB-NEXT:    vxorps %xmm2, %xmm2, %xmm2
; SNB-NEXT:    vcmpneqps %ymm2, %ymm0, %ymm0
; SNB-NEXT:    vandps %ymm1, %ymm0, %ymm0
; SNB-NEXT:    retq
;
; BDW-LABEL: v8f32_daz:
; BDW:       # %bb.0:
; BDW-NEXT:    vrsqrtps %ymm0, %ymm1
; BDW-NEXT:    vmulps %ymm1, %ymm0, %ymm2
; BDW-NEXT:    vbroadcastss {{.*#+}} ymm3 = [-3.0E+0,-3.0E+0,-3.0E+0,-3.0E+0,-3.0E+0,-3.0E+0,-3.0E+0,-3.0E+0]
; BDW-NEXT:    vfmadd231ps {{.*#+}} ymm3 = (ymm2 * ymm1) + ymm3
; BDW-NEXT:    vbroadcastss {{.*#+}} ymm1 = [-5.0E-1,-5.0E-1,-5.0E-1,-5.0E-1,-5.0E-1,-5.0E-1,-5.0E-1,-5.0E-1]
; BDW-NEXT:    vmulps %ymm1, %ymm2, %ymm1
; BDW-NEXT:    vmulps %ymm3, %ymm1, %ymm1
; BDW-NEXT:    vxorps %xmm2, %xmm2, %xmm2
; BDW-NEXT:    vcmpneqps %ymm2, %ymm0, %ymm0
; BDW-NEXT:    vandps %ymm1, %ymm0, %ymm0
; BDW-NEXT:    retq
;
; SKL-LABEL: v8f32_daz:
; SKL:       # %bb.0:
; SKL-NEXT:    vsqrtps %ymm0, %ymm0
; SKL-NEXT:    retq
; HSW-LABEL: v8f32_daz:
; HSW:       # %bb.0:
; HSW-NEXT:    vrsqrtps %ymm0, %ymm1
; HSW-NEXT:    vmulps %ymm1, %ymm0, %ymm2
; HSW-NEXT:    vbroadcastss {{.*#+}} ymm3 = [-3.0E+0,-3.0E+0,-3.0E+0,-3.0E+0,-3.0E+0,-3.0E+0,-3.0E+0,-3.0E+0]
; HSW-NEXT:    vfmadd231ps {{.*#+}} ymm3 = (ymm2 * ymm1) + ymm3
; HSW-NEXT:    vbroadcastss {{.*#+}} ymm1 = [-5.0E-1,-5.0E-1,-5.0E-1,-5.0E-1,-5.0E-1,-5.0E-1,-5.0E-1,-5.0E-1]
; HSW-NEXT:    vmulps %ymm1, %ymm2, %ymm1
; HSW-NEXT:    vmulps %ymm3, %ymm1, %ymm1
; HSW-NEXT:    vxorps %xmm2, %xmm2, %xmm2
; HSW-NEXT:    vcmpneqps %ymm2, %ymm0, %ymm0
; HSW-NEXT:    vandps %ymm1, %ymm0, %ymm0
; HSW-NEXT:    retq
  %call = tail call fast <8 x float> @llvm.sqrt.v8f32(<8 x float> %f) #2
  ret <8 x float> %call
}

declare float @llvm.sqrt.f32(float) #2
declare <4 x float> @llvm.sqrt.v4f32(<4 x float>) #2
declare <8 x float> @llvm.sqrt.v8f32(<8 x float>) #2

attributes #0 = { "denormal-fp-math"="ieee,ieee" }
attributes #1 = { "denormal-fp-math"="ieee,preserve-sign" }
attributes #2 = { nounwind readnone }
