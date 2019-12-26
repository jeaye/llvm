; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+sse2 -O3 -disable-strictnode-mutation | FileCheck %s --check-prefixes=SSE,SSE-X86
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse2 -O3 -disable-strictnode-mutation | FileCheck %s --check-prefixes=SSE,SSE-X64
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+fma -O3 -disable-strictnode-mutation | FileCheck %s --check-prefixes=AVX
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+fma -O3 -disable-strictnode-mutation | FileCheck %s --check-prefixes=AVX
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+avx512f -mattr=+avx512vl -O3 -disable-strictnode-mutation | FileCheck %s --check-prefixes=AVX
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f -mattr=+avx512vl -O3 -disable-strictnode-mutation | FileCheck %s --check-prefixes=AVX

declare <2 x double> @llvm.experimental.constrained.fadd.v2f64(<2 x double>, <2 x double>, metadata, metadata)
declare <4 x float> @llvm.experimental.constrained.fadd.v4f32(<4 x float>, <4 x float>, metadata, metadata)
declare <2 x double> @llvm.experimental.constrained.fsub.v2f64(<2 x double>, <2 x double>, metadata, metadata)
declare <4 x float> @llvm.experimental.constrained.fsub.v4f32(<4 x float>, <4 x float>, metadata, metadata)
declare <2 x double> @llvm.experimental.constrained.fmul.v2f64(<2 x double>, <2 x double>, metadata, metadata)
declare <4 x float> @llvm.experimental.constrained.fmul.v4f32(<4 x float>, <4 x float>, metadata, metadata)
declare <2 x double> @llvm.experimental.constrained.fdiv.v2f64(<2 x double>, <2 x double>, metadata, metadata)
declare <4 x float> @llvm.experimental.constrained.fdiv.v4f32(<4 x float>, <4 x float>, metadata, metadata)
declare <2 x double> @llvm.experimental.constrained.sqrt.v2f64(<2 x double>, metadata, metadata)
declare <4 x float> @llvm.experimental.constrained.sqrt.v4f32(<4 x float>, metadata, metadata)
declare float @llvm.experimental.constrained.fptrunc.f32.f64(double, metadata, metadata)
declare <2 x float> @llvm.experimental.constrained.fptrunc.v2f32.v2f64(<2 x double>, metadata, metadata)
declare double @llvm.experimental.constrained.fpext.f64.f32(float, metadata)
declare <2 x double> @llvm.experimental.constrained.fpext.v2f64.v2f32(<2 x float>, metadata)
declare <2 x double> @llvm.experimental.constrained.fma.v2f64(<2 x double>, <2 x double>, <2 x double>, metadata, metadata)
declare <4 x float> @llvm.experimental.constrained.fma.v4f32(<4 x float>, <4 x float>, <4 x float>, metadata, metadata)

define <2 x double> @f1(<2 x double> %a, <2 x double> %b) #0 {
; SSE-LABEL: f1:
; SSE:       # %bb.0:
; SSE-NEXT:    addpd %xmm1, %xmm0
; SSE-NEXT:    ret{{[l|q]}}
;
; AVX-LABEL: f1:
; AVX:       # %bb.0:
; AVX-NEXT:    vaddpd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    ret{{[l|q]}}
  %ret = call <2 x double> @llvm.experimental.constrained.fadd.v2f64(<2 x double> %a, <2 x double> %b,
                                                                     metadata !"round.dynamic",
                                                                     metadata !"fpexcept.strict") #0
  ret <2 x double> %ret
}

define <4 x float> @f2(<4 x float> %a, <4 x float> %b) #0 {
; SSE-LABEL: f2:
; SSE:       # %bb.0:
; SSE-NEXT:    addps %xmm1, %xmm0
; SSE-NEXT:    ret{{[l|q]}}
;
; AVX-LABEL: f2:
; AVX:       # %bb.0:
; AVX-NEXT:    vaddps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    ret{{[l|q]}}
  %ret = call <4 x float> @llvm.experimental.constrained.fadd.v4f32(<4 x float> %a, <4 x float> %b,
                                                                    metadata !"round.dynamic",
                                                                    metadata !"fpexcept.strict") #0
  ret <4 x float> %ret
}

define <2 x double> @f3(<2 x double> %a, <2 x double> %b) #0 {
; SSE-LABEL: f3:
; SSE:       # %bb.0:
; SSE-NEXT:    subpd %xmm1, %xmm0
; SSE-NEXT:    ret{{[l|q]}}
;
; AVX-LABEL: f3:
; AVX:       # %bb.0:
; AVX-NEXT:    vsubpd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    ret{{[l|q]}}
  %ret = call <2 x double> @llvm.experimental.constrained.fsub.v2f64(<2 x double> %a, <2 x double> %b,
                                                                     metadata !"round.dynamic",
                                                                     metadata !"fpexcept.strict") #0
  ret <2 x double> %ret
}

define <4 x float> @f4(<4 x float> %a, <4 x float> %b) #0 {
; SSE-LABEL: f4:
; SSE:       # %bb.0:
; SSE-NEXT:    subps %xmm1, %xmm0
; SSE-NEXT:    ret{{[l|q]}}
;
; AVX-LABEL: f4:
; AVX:       # %bb.0:
; AVX-NEXT:    vsubps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    ret{{[l|q]}}
  %ret = call <4 x float> @llvm.experimental.constrained.fsub.v4f32(<4 x float> %a, <4 x float> %b,
                                                                    metadata !"round.dynamic",
                                                                    metadata !"fpexcept.strict") #0
  ret <4 x float> %ret
}

define <2 x double> @f5(<2 x double> %a, <2 x double> %b) #0 {
; SSE-LABEL: f5:
; SSE:       # %bb.0:
; SSE-NEXT:    mulpd %xmm1, %xmm0
; SSE-NEXT:    ret{{[l|q]}}
;
; AVX-LABEL: f5:
; AVX:       # %bb.0:
; AVX-NEXT:    vmulpd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    ret{{[l|q]}}
  %ret = call <2 x double> @llvm.experimental.constrained.fmul.v2f64(<2 x double> %a, <2 x double> %b,
                                                                     metadata !"round.dynamic",
                                                                     metadata !"fpexcept.strict") #0
  ret <2 x double> %ret
}

define <4 x float> @f6(<4 x float> %a, <4 x float> %b) #0 {
; SSE-LABEL: f6:
; SSE:       # %bb.0:
; SSE-NEXT:    mulps %xmm1, %xmm0
; SSE-NEXT:    ret{{[l|q]}}
;
; AVX-LABEL: f6:
; AVX:       # %bb.0:
; AVX-NEXT:    vmulps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    ret{{[l|q]}}
  %ret = call <4 x float> @llvm.experimental.constrained.fmul.v4f32(<4 x float> %a, <4 x float> %b,
                                                                    metadata !"round.dynamic",
                                                                    metadata !"fpexcept.strict") #0
  ret <4 x float> %ret
}

define <2 x double> @f7(<2 x double> %a, <2 x double> %b) #0 {
; SSE-LABEL: f7:
; SSE:       # %bb.0:
; SSE-NEXT:    divpd %xmm1, %xmm0
; SSE-NEXT:    ret{{[l|q]}}
;
; AVX-LABEL: f7:
; AVX:       # %bb.0:
; AVX-NEXT:    vdivpd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    ret{{[l|q]}}
  %ret = call <2 x double> @llvm.experimental.constrained.fdiv.v2f64(<2 x double> %a, <2 x double> %b,
                                                                     metadata !"round.dynamic",
                                                                     metadata !"fpexcept.strict") #0
  ret <2 x double> %ret
}

define <4 x float> @f8(<4 x float> %a, <4 x float> %b) #0 {
; SSE-LABEL: f8:
; SSE:       # %bb.0:
; SSE-NEXT:    divps %xmm1, %xmm0
; SSE-NEXT:    ret{{[l|q]}}
;
; AVX-LABEL: f8:
; AVX:       # %bb.0:
; AVX-NEXT:    vdivps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    ret{{[l|q]}}
  %ret = call <4 x float> @llvm.experimental.constrained.fdiv.v4f32(<4 x float> %a, <4 x float> %b,
                                                                    metadata !"round.dynamic",
                                                                    metadata !"fpexcept.strict") #0
  ret <4 x float> %ret
}

define <2 x double> @f9(<2 x double> %a) #0 {
; SSE-LABEL: f9:
; SSE:       # %bb.0:
; SSE-NEXT:    sqrtpd %xmm0, %xmm0
; SSE-NEXT:    ret{{[l|q]}}
;
; AVX-LABEL: f9:
; AVX:       # %bb.0:
; AVX-NEXT:    vsqrtpd %xmm0, %xmm0
; AVX-NEXT:    ret{{[l|q]}}
  %sqrt = call <2 x double> @llvm.experimental.constrained.sqrt.v2f64(
                              <2 x double> %a,
                              metadata !"round.dynamic",
                              metadata !"fpexcept.strict") #0
  ret <2 x double> %sqrt
}

define <4 x float> @f10(<4 x float> %a) #0 {
; SSE-LABEL: f10:
; SSE:       # %bb.0:
; SSE-NEXT:    sqrtps %xmm0, %xmm0
; SSE-NEXT:    ret{{[l|q]}}
;
; AVX-LABEL: f10:
; AVX:       # %bb.0:
; AVX-NEXT:    vsqrtps %xmm0, %xmm0
; AVX-NEXT:    ret{{[l|q]}}
  %sqrt = call <4 x float> @llvm.experimental.constrained.sqrt.v4f32(
                              <4 x float> %a,
                              metadata !"round.dynamic",
                              metadata !"fpexcept.strict") #0
  ret <4 x float > %sqrt
}

define <4 x float> @f11(<2 x double> %a0, <4 x float> %a1) #0 {
; SSE-LABEL: f11:
; SSE:       # %bb.0:
; SSE-NEXT:    cvtsd2ss %xmm0, %xmm1
; SSE-NEXT:    movaps %xmm1, %xmm0
; SSE-NEXT:    ret{{[l|q]}}
;
; AVX-LABEL: f11:
; AVX:       # %bb.0:
; AVX-NEXT:    vcvtsd2ss %xmm0, %xmm1, %xmm0
; AVX-NEXT:    ret{{[l|q]}}
  %ext = extractelement <2 x double> %a0, i32 0
  %cvt = call float @llvm.experimental.constrained.fptrunc.f32.f64(double %ext,
                                                                   metadata !"round.dynamic",
                                                                   metadata !"fpexcept.strict")
  %res = insertelement <4 x float> %a1, float %cvt, i32 0
  ret <4 x float> %res
}

define <2 x double> @f12(<2 x double> %a0, <4 x float> %a1) #0 {
; SSE-LABEL: f12:
; SSE:       # %bb.0:
; SSE-NEXT:    cvtss2sd %xmm1, %xmm0
; SSE-NEXT:    ret{{[l|q]}}
;
; AVX-LABEL: f12:
; AVX:       # %bb.0:
; AVX-NEXT:    vcvtss2sd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    ret{{[l|q]}}
  %ext = extractelement <4 x float> %a1, i32 0
  %cvt = call double @llvm.experimental.constrained.fpext.f64.f32(float %ext,
                                                                  metadata !"fpexcept.strict") #0
  %res = insertelement <2 x double> %a0, double %cvt, i32 0
  ret <2 x double> %res
}

define <4 x float> @f13(<4 x float> %a, <4 x float> %b, <4 x float> %c) #0 {
; SSE-X86-LABEL: f13:
; SSE-X86:       # %bb.0:
; SSE-X86-NEXT:    subl $108, %esp
; SSE-X86-NEXT:    .cfi_def_cfa_offset 112
; SSE-X86-NEXT:    movups %xmm2, {{[-0-9]+}}(%e{{[sb]}}p) # 16-byte Spill
; SSE-X86-NEXT:    movups %xmm1, {{[-0-9]+}}(%e{{[sb]}}p) # 16-byte Spill
; SSE-X86-NEXT:    movups %xmm0, {{[-0-9]+}}(%e{{[sb]}}p) # 16-byte Spill
; SSE-X86-NEXT:    movss %xmm2, {{[0-9]+}}(%esp)
; SSE-X86-NEXT:    movss %xmm1, {{[0-9]+}}(%esp)
; SSE-X86-NEXT:    movss %xmm0, (%esp)
; SSE-X86-NEXT:    calll fmaf
; SSE-X86-NEXT:    fstpt {{[-0-9]+}}(%e{{[sb]}}p) # 10-byte Folded Spill
; SSE-X86-NEXT:    movups {{[-0-9]+}}(%e{{[sb]}}p), %xmm0 # 16-byte Reload
; SSE-X86-NEXT:    movhlps {{.*#+}} xmm0 = xmm0[1,1]
; SSE-X86-NEXT:    movss %xmm0, {{[0-9]+}}(%esp)
; SSE-X86-NEXT:    movups {{[-0-9]+}}(%e{{[sb]}}p), %xmm0 # 16-byte Reload
; SSE-X86-NEXT:    movhlps {{.*#+}} xmm0 = xmm0[1,1]
; SSE-X86-NEXT:    movss %xmm0, {{[0-9]+}}(%esp)
; SSE-X86-NEXT:    movups {{[-0-9]+}}(%e{{[sb]}}p), %xmm0 # 16-byte Reload
; SSE-X86-NEXT:    movhlps {{.*#+}} xmm0 = xmm0[1,1]
; SSE-X86-NEXT:    movss %xmm0, (%esp)
; SSE-X86-NEXT:    calll fmaf
; SSE-X86-NEXT:    fstpt {{[-0-9]+}}(%e{{[sb]}}p) # 10-byte Folded Spill
; SSE-X86-NEXT:    movups {{[-0-9]+}}(%e{{[sb]}}p), %xmm0 # 16-byte Reload
; SSE-X86-NEXT:    shufps {{.*#+}} xmm0 = xmm0[3,1,2,3]
; SSE-X86-NEXT:    movss %xmm0, {{[0-9]+}}(%esp)
; SSE-X86-NEXT:    movups {{[-0-9]+}}(%e{{[sb]}}p), %xmm0 # 16-byte Reload
; SSE-X86-NEXT:    shufps {{.*#+}} xmm0 = xmm0[3,1,2,3]
; SSE-X86-NEXT:    movss %xmm0, {{[0-9]+}}(%esp)
; SSE-X86-NEXT:    movups {{[-0-9]+}}(%e{{[sb]}}p), %xmm0 # 16-byte Reload
; SSE-X86-NEXT:    shufps {{.*#+}} xmm0 = xmm0[3,1,2,3]
; SSE-X86-NEXT:    movss %xmm0, (%esp)
; SSE-X86-NEXT:    calll fmaf
; SSE-X86-NEXT:    movups {{[-0-9]+}}(%e{{[sb]}}p), %xmm0 # 16-byte Reload
; SSE-X86-NEXT:    shufps {{.*#+}} xmm0 = xmm0[1,1,2,3]
; SSE-X86-NEXT:    movss %xmm0, {{[0-9]+}}(%esp)
; SSE-X86-NEXT:    movups {{[-0-9]+}}(%e{{[sb]}}p), %xmm0 # 16-byte Reload
; SSE-X86-NEXT:    shufps {{.*#+}} xmm0 = xmm0[1,1,2,3]
; SSE-X86-NEXT:    movss %xmm0, {{[0-9]+}}(%esp)
; SSE-X86-NEXT:    movups {{[-0-9]+}}(%e{{[sb]}}p), %xmm0 # 16-byte Reload
; SSE-X86-NEXT:    shufps {{.*#+}} xmm0 = xmm0[1,1,2,3]
; SSE-X86-NEXT:    movss %xmm0, (%esp)
; SSE-X86-NEXT:    fstps {{[0-9]+}}(%esp)
; SSE-X86-NEXT:    fldt {{[-0-9]+}}(%e{{[sb]}}p) # 10-byte Folded Reload
; SSE-X86-NEXT:    fstps {{[0-9]+}}(%esp)
; SSE-X86-NEXT:    fldt {{[-0-9]+}}(%e{{[sb]}}p) # 10-byte Folded Reload
; SSE-X86-NEXT:    fstps {{[0-9]+}}(%esp)
; SSE-X86-NEXT:    calll fmaf
; SSE-X86-NEXT:    fstps {{[0-9]+}}(%esp)
; SSE-X86-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; SSE-X86-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; SSE-X86-NEXT:    unpcklps {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1]
; SSE-X86-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; SSE-X86-NEXT:    movss {{.*#+}} xmm2 = mem[0],zero,zero,zero
; SSE-X86-NEXT:    unpcklps {{.*#+}} xmm0 = xmm0[0],xmm2[0],xmm0[1],xmm2[1]
; SSE-X86-NEXT:    movlhps {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; SSE-X86-NEXT:    addl $108, %esp
; SSE-X86-NEXT:    .cfi_def_cfa_offset 4
; SSE-X86-NEXT:    retl
;
; SSE-X64-LABEL: f13:
; SSE-X64:       # %bb.0:
; SSE-X64-NEXT:    subq $88, %rsp
; SSE-X64-NEXT:    .cfi_def_cfa_offset 96
; SSE-X64-NEXT:    movaps %xmm2, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; SSE-X64-NEXT:    movaps %xmm1, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; SSE-X64-NEXT:    movaps %xmm0, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; SSE-X64-NEXT:    shufps {{.*#+}} xmm0 = xmm0[3,1,2,3]
; SSE-X64-NEXT:    shufps {{.*#+}} xmm1 = xmm1[3,1,2,3]
; SSE-X64-NEXT:    shufps {{.*#+}} xmm2 = xmm2[3,1,2,3]
; SSE-X64-NEXT:    callq fmaf
; SSE-X64-NEXT:    movaps %xmm0, (%rsp) # 16-byte Spill
; SSE-X64-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 # 16-byte Reload
; SSE-X64-NEXT:    movhlps {{.*#+}} xmm0 = xmm0[1,1]
; SSE-X64-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm1 # 16-byte Reload
; SSE-X64-NEXT:    movhlps {{.*#+}} xmm1 = xmm1[1,1]
; SSE-X64-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm2 # 16-byte Reload
; SSE-X64-NEXT:    movhlps {{.*#+}} xmm2 = xmm2[1,1]
; SSE-X64-NEXT:    callq fmaf
; SSE-X64-NEXT:    unpcklps (%rsp), %xmm0 # 16-byte Folded Reload
; SSE-X64-NEXT:    # xmm0 = xmm0[0],mem[0],xmm0[1],mem[1]
; SSE-X64-NEXT:    movaps %xmm0, (%rsp) # 16-byte Spill
; SSE-X64-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 # 16-byte Reload
; SSE-X64-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm1 # 16-byte Reload
; SSE-X64-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm2 # 16-byte Reload
; SSE-X64-NEXT:    callq fmaf
; SSE-X64-NEXT:    movaps %xmm0, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; SSE-X64-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 # 16-byte Reload
; SSE-X64-NEXT:    shufps {{.*#+}} xmm0 = xmm0[1,1,2,3]
; SSE-X64-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm1 # 16-byte Reload
; SSE-X64-NEXT:    shufps {{.*#+}} xmm1 = xmm1[1,1,2,3]
; SSE-X64-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm2 # 16-byte Reload
; SSE-X64-NEXT:    shufps {{.*#+}} xmm2 = xmm2[1,1,2,3]
; SSE-X64-NEXT:    callq fmaf
; SSE-X64-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm1 # 16-byte Reload
; SSE-X64-NEXT:    unpcklps {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1]
; SSE-X64-NEXT:    unpcklpd (%rsp), %xmm1 # 16-byte Folded Reload
; SSE-X64-NEXT:    # xmm1 = xmm1[0],mem[0]
; SSE-X64-NEXT:    movaps %xmm1, %xmm0
; SSE-X64-NEXT:    addq $88, %rsp
; SSE-X64-NEXT:    .cfi_def_cfa_offset 8
; SSE-X64-NEXT:    retq
;
; AVX-LABEL: f13:
; AVX:       # %bb.0:
; AVX-NEXT:    vfmadd213ps {{.*#+}} xmm0 = (xmm1 * xmm0) + xmm2
; AVX-NEXT:    ret{{[l|q]}}
  %res = call <4 x float> @llvm.experimental.constrained.fma.v4f32(<4 x float> %a, <4 x float> %b, <4 x float> %c,
                                                                   metadata !"round.dynamic",
                                                                   metadata !"fpexcept.strict") #0
  ret <4 x float> %res
}

define <2 x double> @f14(<2 x double> %a, <2 x double> %b, <2 x double> %c) #0 {
; SSE-X86-LABEL: f14:
; SSE-X86:       # %bb.0:
; SSE-X86-NEXT:    pushl %ebp
; SSE-X86-NEXT:    .cfi_def_cfa_offset 8
; SSE-X86-NEXT:    .cfi_offset %ebp, -8
; SSE-X86-NEXT:    movl %esp, %ebp
; SSE-X86-NEXT:    .cfi_def_cfa_register %ebp
; SSE-X86-NEXT:    andl $-16, %esp
; SSE-X86-NEXT:    subl $112, %esp
; SSE-X86-NEXT:    movaps %xmm2, {{[-0-9]+}}(%e{{[sb]}}p) # 16-byte Spill
; SSE-X86-NEXT:    movaps %xmm1, {{[-0-9]+}}(%e{{[sb]}}p) # 16-byte Spill
; SSE-X86-NEXT:    movaps %xmm0, {{[-0-9]+}}(%e{{[sb]}}p) # 16-byte Spill
; SSE-X86-NEXT:    movlps %xmm2, {{[0-9]+}}(%esp)
; SSE-X86-NEXT:    movlps %xmm1, {{[0-9]+}}(%esp)
; SSE-X86-NEXT:    movlps %xmm0, (%esp)
; SSE-X86-NEXT:    calll fma
; SSE-X86-NEXT:    movaps {{[-0-9]+}}(%e{{[sb]}}p), %xmm0 # 16-byte Reload
; SSE-X86-NEXT:    movhps %xmm0, {{[0-9]+}}(%esp)
; SSE-X86-NEXT:    movaps {{[-0-9]+}}(%e{{[sb]}}p), %xmm0 # 16-byte Reload
; SSE-X86-NEXT:    movhps %xmm0, {{[0-9]+}}(%esp)
; SSE-X86-NEXT:    movaps {{[-0-9]+}}(%e{{[sb]}}p), %xmm0 # 16-byte Reload
; SSE-X86-NEXT:    movhps %xmm0, (%esp)
; SSE-X86-NEXT:    fstpl {{[0-9]+}}(%esp)
; SSE-X86-NEXT:    calll fma
; SSE-X86-NEXT:    fstpl {{[0-9]+}}(%esp)
; SSE-X86-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; SSE-X86-NEXT:    movhps {{.*#+}} xmm0 = xmm0[0,1],mem[0,1]
; SSE-X86-NEXT:    movl %ebp, %esp
; SSE-X86-NEXT:    popl %ebp
; SSE-X86-NEXT:    .cfi_def_cfa %esp, 4
; SSE-X86-NEXT:    retl
;
; SSE-X64-LABEL: f14:
; SSE-X64:       # %bb.0:
; SSE-X64-NEXT:    subq $72, %rsp
; SSE-X64-NEXT:    .cfi_def_cfa_offset 80
; SSE-X64-NEXT:    movaps %xmm2, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; SSE-X64-NEXT:    movaps %xmm1, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; SSE-X64-NEXT:    movaps %xmm0, (%rsp) # 16-byte Spill
; SSE-X64-NEXT:    callq fma
; SSE-X64-NEXT:    movaps %xmm0, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; SSE-X64-NEXT:    movaps (%rsp), %xmm0 # 16-byte Reload
; SSE-X64-NEXT:    movhlps {{.*#+}} xmm0 = xmm0[1,1]
; SSE-X64-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm1 # 16-byte Reload
; SSE-X64-NEXT:    movhlps {{.*#+}} xmm1 = xmm1[1,1]
; SSE-X64-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm2 # 16-byte Reload
; SSE-X64-NEXT:    movhlps {{.*#+}} xmm2 = xmm2[1,1]
; SSE-X64-NEXT:    callq fma
; SSE-X64-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm1 # 16-byte Reload
; SSE-X64-NEXT:    movlhps {{.*#+}} xmm1 = xmm1[0],xmm0[0]
; SSE-X64-NEXT:    movaps %xmm1, %xmm0
; SSE-X64-NEXT:    addq $72, %rsp
; SSE-X64-NEXT:    .cfi_def_cfa_offset 8
; SSE-X64-NEXT:    retq
;
; AVX-LABEL: f14:
; AVX:       # %bb.0:
; AVX-NEXT:    vfmadd213pd {{.*#+}} xmm0 = (xmm1 * xmm0) + xmm2
; AVX-NEXT:    ret{{[l|q]}}
  %res = call <2 x double> @llvm.experimental.constrained.fma.v2f64(<2 x double> %a, <2 x double> %b, <2 x double> %c,
                                                                    metadata !"round.dynamic",
                                                                    metadata !"fpexcept.strict") #0
  ret <2 x double> %res
}

define <2 x double> @f15(<2 x float> %a) #0 {
; SSE-LABEL: f15:
; SSE:       # %bb.0:
; SSE-NEXT:    cvtps2pd %xmm0, %xmm0
; SSE-NEXT:    ret{{[l|q]}}
;
; AVX-LABEL: f15:
; AVX:       # %bb.0:
; AVX-NEXT:    vcvtps2pd %xmm0, %xmm0
; AVX-NEXT:    ret{{[l|q]}}
  %ret = call <2 x double> @llvm.experimental.constrained.fpext.v2f64.v2f32(
                                <2 x float> %a,
                                metadata !"fpexcept.strict") #0
  ret <2 x double> %ret
}

define <2 x float> @f16(<2 x double> %a) #0 {
; SSE-LABEL: f16:
; SSE:       # %bb.0:
; SSE-NEXT:    cvtpd2ps %xmm0, %xmm0
; SSE-NEXT:    ret{{[l|q]}}
;
; AVX-LABEL: f16:
; AVX:       # %bb.0:
; AVX-NEXT:    vcvtpd2ps %xmm0, %xmm0
; AVX-NEXT:    ret{{[l|q]}}
  %ret = call <2 x float> @llvm.experimental.constrained.fptrunc.v2f32.v2f64(
                                <2 x double> %a,
                                metadata !"round.dynamic",
                                metadata !"fpexcept.strict") #0
  ret <2 x float> %ret
}


attributes #0 = { strictfp }
