; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown -mattr=+sse2 | FileCheck %s --check-prefixes=X32-SSE2
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+ssse3 | FileCheck %s --check-prefixes=X64,X64-SSSE3
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx | FileCheck %s --check-prefixes=X64,X64-AVX

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

define i32 @t(<2 x i64>* %val) nounwind  {
; X32-SSE2-LABEL: t:
; X32-SSE2:       # %bb.0:
; X32-SSE2-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-SSE2-NEXT:    pshufd $78, (%eax), %xmm0 # xmm0 = mem[2,3,0,1]
; X32-SSE2-NEXT:    movd %xmm0, %eax
; X32-SSE2-NEXT:    retl
;
; X64-SSSE3-LABEL: t:
; X64-SSSE3:       # %bb.0:
; X64-SSSE3-NEXT:    pshufd $78, (%rdi), %xmm0 # xmm0 = mem[2,3,0,1]
; X64-SSSE3-NEXT:    movd %xmm0, %eax
; X64-SSSE3-NEXT:    retq
;
; X64-AVX-LABEL: t:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    movl 8(%rdi), %eax
; X64-AVX-NEXT:    retq
  %tmp2 = load <2 x i64>, <2 x i64>* %val, align 16		; <<2 x i64>> [#uses=1]
  %tmp3 = bitcast <2 x i64> %tmp2 to <4 x i32>		; <<4 x i32>> [#uses=1]
  %tmp4 = extractelement <4 x i32> %tmp3, i32 2		; <i32> [#uses=1]
  ret i32 %tmp4
}

; Case where extractelement of load ends up as undef.
; (Making sure this doesn't crash.)
define i32 @t2(<8 x i32>* %xp) {
; X32-SSE2-LABEL: t2:
; X32-SSE2:       # %bb.0:
; X32-SSE2-NEXT:    retl
;
; X64-LABEL: t2:
; X64:       # %bb.0:
; X64-NEXT:    retq
  %x = load <8 x i32>, <8 x i32>* %xp
  %Shuff68 = shufflevector <8 x i32> %x, <8 x i32> undef, <8 x i32> <i32 undef, i32 7, i32 9, i32 undef, i32 13, i32 15, i32 1, i32 3>
  %y = extractelement <8 x i32> %Shuff68, i32 0
  ret i32 %y
}

; This case could easily end up inf-looping in the DAG combiner due to an
; low alignment load of the vector which prevents us from reliably forming a
; narrow load.

define void @t3(<2 x double>* %a0) {
; X32-SSE2-LABEL: t3:
; X32-SSE2:       # %bb.0: # %bb
; X32-SSE2-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-SSE2-NEXT:    movups (%eax), %xmm0
; X32-SSE2-NEXT:    movhps %xmm0, (%eax)
; X32-SSE2-NEXT:    retl
;
; X64-SSSE3-LABEL: t3:
; X64-SSSE3:       # %bb.0: # %bb
; X64-SSSE3-NEXT:    movsd 8(%rdi), %xmm0 # xmm0 = mem[0],zero
; X64-SSSE3-NEXT:    movsd %xmm0, (%rax)
; X64-SSSE3-NEXT:    retq
;
; X64-AVX-LABEL: t3:
; X64-AVX:       # %bb.0: # %bb
; X64-AVX-NEXT:    vmovsd 8(%rdi), %xmm0 # xmm0 = mem[0],zero
; X64-AVX-NEXT:    vmovsd %xmm0, (%rax)
; X64-AVX-NEXT:    retq
bb:
  %tmp13 = load <2 x double>, <2 x double>* %a0, align 1
  %.sroa.3.24.vec.extract = extractelement <2 x double> %tmp13, i32 1
  store double %.sroa.3.24.vec.extract, double* undef, align 8
  ret void
}

; Case where a load is unary shuffled, then bitcast (to a type with the same
; number of elements) before extractelement.
; This is testing for an assertion - the extraction was assuming that the undef
; second shuffle operand was a post-bitcast type instead of a pre-bitcast type.
define i64 @t4(<2 x double>* %a) {
; X32-SSE2-LABEL: t4:
; X32-SSE2:       # %bb.0:
; X32-SSE2-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-SSE2-NEXT:    movdqa (%eax), %xmm0
; X32-SSE2-NEXT:    movd %xmm0, %eax
; X32-SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[1,1,0,1]
; X32-SSE2-NEXT:    movd %xmm0, %edx
; X32-SSE2-NEXT:    retl
;
; X64-LABEL: t4:
; X64:       # %bb.0:
; X64-NEXT:    movq (%rdi), %rax
; X64-NEXT:    retq
  %b = load <2 x double>, <2 x double>* %a, align 16
  %c = shufflevector <2 x double> %b, <2 x double> %b, <2 x i32> <i32 1, i32 0>
  %d = bitcast <2 x double> %c to <2 x i64>
  %e = extractelement <2 x i64> %d, i32 1
  ret i64 %e
}

; Don't extract from a volatile.
define void @t5(<2 x double> *%a0, double *%a1) {
; X32-SSE2-LABEL: t5:
; X32-SSE2:       # %bb.0:
; X32-SSE2-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-SSE2-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-SSE2-NEXT:    movaps (%ecx), %xmm0
; X32-SSE2-NEXT:    movhps %xmm0, (%eax)
; X32-SSE2-NEXT:    retl
;
; X64-SSSE3-LABEL: t5:
; X64-SSSE3:       # %bb.0:
; X64-SSSE3-NEXT:    movaps (%rdi), %xmm0
; X64-SSSE3-NEXT:    movhps %xmm0, (%rsi)
; X64-SSSE3-NEXT:    retq
;
; X64-AVX-LABEL: t5:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    vmovaps (%rdi), %xmm0
; X64-AVX-NEXT:    vmovhps %xmm0, (%rsi)
; X64-AVX-NEXT:    retq
  %vecload = load volatile <2 x double>, <2 x double>* %a0, align 16
  %vecext = extractelement <2 x double> %vecload, i32 1
  store volatile double %vecext, double* %a1, align 8
  ret void
}

; Check for multiuse.
define float @t6(<8 x float> *%a0) {
; X32-SSE2-LABEL: t6:
; X32-SSE2:       # %bb.0:
; X32-SSE2-NEXT:    pushl %eax
; X32-SSE2-NEXT:    .cfi_def_cfa_offset 8
; X32-SSE2-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-SSE2-NEXT:    movaps (%eax), %xmm0
; X32-SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[1,1,2,3]
; X32-SSE2-NEXT:    xorps %xmm1, %xmm1
; X32-SSE2-NEXT:    cmpeqss %xmm0, %xmm1
; X32-SSE2-NEXT:    movss {{\.LCPI.*}}, %xmm2 # xmm2 = mem[0],zero,zero,zero
; X32-SSE2-NEXT:    andps %xmm1, %xmm2
; X32-SSE2-NEXT:    andnps %xmm0, %xmm1
; X32-SSE2-NEXT:    orps %xmm2, %xmm1
; X32-SSE2-NEXT:    movss %xmm1, (%esp)
; X32-SSE2-NEXT:    flds (%esp)
; X32-SSE2-NEXT:    popl %eax
; X32-SSE2-NEXT:    .cfi_def_cfa_offset 4
; X32-SSE2-NEXT:    retl
;
; X64-SSSE3-LABEL: t6:
; X64-SSSE3:       # %bb.0:
; X64-SSSE3-NEXT:    movshdup (%rdi), %xmm1 # xmm1 = mem[1,1,3,3]
; X64-SSSE3-NEXT:    xorps %xmm0, %xmm0
; X64-SSSE3-NEXT:    cmpeqss %xmm1, %xmm0
; X64-SSSE3-NEXT:    movss {{.*}}(%rip), %xmm2 # xmm2 = mem[0],zero,zero,zero
; X64-SSSE3-NEXT:    andps %xmm0, %xmm2
; X64-SSSE3-NEXT:    andnps %xmm1, %xmm0
; X64-SSSE3-NEXT:    orps %xmm2, %xmm0
; X64-SSSE3-NEXT:    retq
;
; X64-AVX-LABEL: t6:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    vmovss 4(%rdi), %xmm0 # xmm0 = mem[0],zero,zero,zero
; X64-AVX-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; X64-AVX-NEXT:    vcmpeqss %xmm1, %xmm0, %xmm1
; X64-AVX-NEXT:    vmovss {{.*}}(%rip), %xmm2 # xmm2 = mem[0],zero,zero,zero
; X64-AVX-NEXT:    vblendvps %xmm1, %xmm2, %xmm0, %xmm0
; X64-AVX-NEXT:    retq
  %vecload = load <8 x float>, <8 x float>* %a0, align 32
  %vecext = extractelement <8 x float> %vecload, i32 1
  %cmp = fcmp oeq float %vecext, 0.000000e+00
  %cond = select i1 %cmp, float 1.000000e+00, float %vecext
  ret float %cond
}

define void @PR43971(<8 x float> *%a0, float *%a1) {
; X32-SSE2-LABEL: PR43971:
; X32-SSE2:       # %bb.0: # %entry
; X32-SSE2-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-SSE2-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-SSE2-NEXT:    movaps 16(%ecx), %xmm0
; X32-SSE2-NEXT:    movhlps {{.*#+}} xmm0 = xmm0[1,1]
; X32-SSE2-NEXT:    xorps %xmm1, %xmm1
; X32-SSE2-NEXT:    cmpltss %xmm0, %xmm1
; X32-SSE2-NEXT:    movss (%eax), %xmm2 # xmm2 = mem[0],zero,zero,zero
; X32-SSE2-NEXT:    andps %xmm1, %xmm2
; X32-SSE2-NEXT:    andnps %xmm0, %xmm1
; X32-SSE2-NEXT:    orps %xmm2, %xmm1
; X32-SSE2-NEXT:    movss %xmm1, (%eax)
; X32-SSE2-NEXT:    retl
;
; X64-SSSE3-LABEL: PR43971:
; X64-SSSE3:       # %bb.0: # %entry
; X64-SSSE3-NEXT:    movss 24(%rdi), %xmm0 # xmm0 = mem[0],zero,zero,zero
; X64-SSSE3-NEXT:    xorps %xmm1, %xmm1
; X64-SSSE3-NEXT:    cmpltss %xmm0, %xmm1
; X64-SSSE3-NEXT:    movss (%rsi), %xmm2 # xmm2 = mem[0],zero,zero,zero
; X64-SSSE3-NEXT:    andps %xmm1, %xmm2
; X64-SSSE3-NEXT:    andnps %xmm0, %xmm1
; X64-SSSE3-NEXT:    orps %xmm2, %xmm1
; X64-SSSE3-NEXT:    movss %xmm1, (%rsi)
; X64-SSSE3-NEXT:    retq
;
; X64-AVX-LABEL: PR43971:
; X64-AVX:       # %bb.0: # %entry
; X64-AVX-NEXT:    vmovss 24(%rdi), %xmm0 # xmm0 = mem[0],zero,zero,zero
; X64-AVX-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; X64-AVX-NEXT:    vcmpltss %xmm0, %xmm1, %xmm1
; X64-AVX-NEXT:    vmovss (%rsi), %xmm2 # xmm2 = mem[0],zero,zero,zero
; X64-AVX-NEXT:    vblendvps %xmm1, %xmm2, %xmm0, %xmm0
; X64-AVX-NEXT:    vmovss %xmm0, (%rsi)
; X64-AVX-NEXT:    retq
entry:
  %0 = load <8 x float>, <8 x float>* %a0, align 32
  %vecext = extractelement <8 x float> %0, i32 6
  %cmp = fcmp ogt float %vecext, 0.000000e+00
  %1 = load float, float* %a1, align 4
  %cond = select i1 %cmp, float %1, float %vecext
  store float %cond, float* %a1, align 4
  ret void
}

define float @PR43971_1(<8 x float> *%a0) nounwind {
; X32-SSE2-LABEL: PR43971_1:
; X32-SSE2:       # %bb.0: # %entry
; X32-SSE2-NEXT:    pushl %eax
; X32-SSE2-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-SSE2-NEXT:    movaps (%eax), %xmm0
; X32-SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[1,1,2,3]
; X32-SSE2-NEXT:    xorps %xmm1, %xmm1
; X32-SSE2-NEXT:    cmpeqss %xmm0, %xmm1
; X32-SSE2-NEXT:    movss {{\.LCPI.*}}, %xmm2 # xmm2 = mem[0],zero,zero,zero
; X32-SSE2-NEXT:    andps %xmm1, %xmm2
; X32-SSE2-NEXT:    andnps %xmm0, %xmm1
; X32-SSE2-NEXT:    orps %xmm2, %xmm1
; X32-SSE2-NEXT:    movss %xmm1, (%esp)
; X32-SSE2-NEXT:    flds (%esp)
; X32-SSE2-NEXT:    popl %eax
; X32-SSE2-NEXT:    retl
;
; X64-SSSE3-LABEL: PR43971_1:
; X64-SSSE3:       # %bb.0: # %entry
; X64-SSSE3-NEXT:    movshdup (%rdi), %xmm1 # xmm1 = mem[1,1,3,3]
; X64-SSSE3-NEXT:    xorps %xmm0, %xmm0
; X64-SSSE3-NEXT:    cmpeqss %xmm1, %xmm0
; X64-SSSE3-NEXT:    movss {{.*}}(%rip), %xmm2 # xmm2 = mem[0],zero,zero,zero
; X64-SSSE3-NEXT:    andps %xmm0, %xmm2
; X64-SSSE3-NEXT:    andnps %xmm1, %xmm0
; X64-SSSE3-NEXT:    orps %xmm2, %xmm0
; X64-SSSE3-NEXT:    retq
;
; X64-AVX-LABEL: PR43971_1:
; X64-AVX:       # %bb.0: # %entry
; X64-AVX-NEXT:    vmovss 4(%rdi), %xmm0 # xmm0 = mem[0],zero,zero,zero
; X64-AVX-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; X64-AVX-NEXT:    vcmpeqss %xmm1, %xmm0, %xmm1
; X64-AVX-NEXT:    vmovss {{.*}}(%rip), %xmm2 # xmm2 = mem[0],zero,zero,zero
; X64-AVX-NEXT:    vblendvps %xmm1, %xmm2, %xmm0, %xmm0
; X64-AVX-NEXT:    retq
entry:
  %0 = load <8 x float>, <8 x float>* %a0, align 32
  %vecext = extractelement <8 x float> %0, i32 1
  %cmp = fcmp oeq float %vecext, 0.000000e+00
  %cond = select i1 %cmp, float 1.000000e+00, float %vecext
  ret float %cond
}
