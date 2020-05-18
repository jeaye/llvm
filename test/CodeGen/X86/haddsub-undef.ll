; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+sse3               | FileCheck %s --check-prefixes=SSE,SSE-SLOW
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+sse3,fast-hops     | FileCheck %s --check-prefixes=SSE,SSE-FAST
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx                | FileCheck %s --check-prefixes=AVX,AVX-SLOW,AVX1-SLOW
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx,fast-hops      | FileCheck %s --check-prefixes=AVX,AVX-FAST,AVX1-FAST
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx512f            | FileCheck %s --check-prefixes=AVX,AVX-SLOW,AVX512,AVX512-SLOW
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx512f,fast-hops  | FileCheck %s --check-prefixes=AVX,AVX-FAST,AVX512,AVX512-FAST

; Verify that we correctly fold horizontal binop even in the presence of UNDEFs.

define <4 x float> @test1_undef(<4 x float> %a, <4 x float> %b) {
; SSE-LABEL: test1_undef:
; SSE:       # %bb.0:
; SSE-NEXT:    haddps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test1_undef:
; AVX:       # %bb.0:
; AVX-NEXT:    vhaddps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %vecext = extractelement <4 x float> %a, i32 0
  %vecext1 = extractelement <4 x float> %a, i32 1
  %add = fadd float %vecext, %vecext1
  %vecinit = insertelement <4 x float> undef, float %add, i32 0
  %vecext2 = extractelement <4 x float> %a, i32 2
  %vecext3 = extractelement <4 x float> %a, i32 3
  %add4 = fadd float %vecext2, %vecext3
  %vecinit5 = insertelement <4 x float> %vecinit, float %add4, i32 1
  %vecext10 = extractelement <4 x float> %b, i32 2
  %vecext11 = extractelement <4 x float> %b, i32 3
  %add12 = fadd float %vecext10, %vecext11
  %vecinit13 = insertelement <4 x float> %vecinit5, float %add12, i32 3
  ret <4 x float> %vecinit13
}

define <4 x float> @test2_undef(<4 x float> %a, <4 x float> %b) {
; SSE-LABEL: test2_undef:
; SSE:       # %bb.0:
; SSE-NEXT:    haddps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test2_undef:
; AVX:       # %bb.0:
; AVX-NEXT:    vhaddps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %vecext = extractelement <4 x float> %a, i32 0
  %vecext1 = extractelement <4 x float> %a, i32 1
  %add = fadd float %vecext, %vecext1
  %vecinit = insertelement <4 x float> undef, float %add, i32 0
  %vecext6 = extractelement <4 x float> %b, i32 0
  %vecext7 = extractelement <4 x float> %b, i32 1
  %add8 = fadd float %vecext6, %vecext7
  %vecinit9 = insertelement <4 x float> %vecinit, float %add8, i32 2
  %vecext10 = extractelement <4 x float> %b, i32 2
  %vecext11 = extractelement <4 x float> %b, i32 3
  %add12 = fadd float %vecext10, %vecext11
  %vecinit13 = insertelement <4 x float> %vecinit9, float %add12, i32 3
  ret <4 x float> %vecinit13
}

define <4 x float> @test3_undef(<4 x float> %a, <4 x float> %b) {
; SSE-LABEL: test3_undef:
; SSE:       # %bb.0:
; SSE-NEXT:    haddps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test3_undef:
; AVX:       # %bb.0:
; AVX-NEXT:    vhaddps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %vecext = extractelement <4 x float> %a, i32 0
  %vecext1 = extractelement <4 x float> %a, i32 1
  %add = fadd float %vecext, %vecext1
  %vecinit = insertelement <4 x float> undef, float %add, i32 0
  %vecext2 = extractelement <4 x float> %a, i32 2
  %vecext3 = extractelement <4 x float> %a, i32 3
  %add4 = fadd float %vecext2, %vecext3
  %vecinit5 = insertelement <4 x float> %vecinit, float %add4, i32 1
  %vecext6 = extractelement <4 x float> %b, i32 0
  %vecext7 = extractelement <4 x float> %b, i32 1
  %add8 = fadd float %vecext6, %vecext7
  %vecinit9 = insertelement <4 x float> %vecinit5, float %add8, i32 2
  ret <4 x float> %vecinit9
}

define <4 x float> @test4_undef(<4 x float> %a, <4 x float> %b) {
; SSE-SLOW-LABEL: test4_undef:
; SSE-SLOW:       # %bb.0:
; SSE-SLOW-NEXT:    movshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; SSE-SLOW-NEXT:    addss %xmm1, %xmm0
; SSE-SLOW-NEXT:    retq
;
; SSE-FAST-LABEL: test4_undef:
; SSE-FAST:       # %bb.0:
; SSE-FAST-NEXT:    haddps %xmm0, %xmm0
; SSE-FAST-NEXT:    retq
;
; AVX-SLOW-LABEL: test4_undef:
; AVX-SLOW:       # %bb.0:
; AVX-SLOW-NEXT:    vmovshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; AVX-SLOW-NEXT:    vaddss %xmm1, %xmm0, %xmm0
; AVX-SLOW-NEXT:    retq
;
; AVX-FAST-LABEL: test4_undef:
; AVX-FAST:       # %bb.0:
; AVX-FAST-NEXT:    vhaddps %xmm0, %xmm0, %xmm0
; AVX-FAST-NEXT:    retq
  %vecext = extractelement <4 x float> %a, i32 0
  %vecext1 = extractelement <4 x float> %a, i32 1
  %add = fadd float %vecext, %vecext1
  %vecinit = insertelement <4 x float> undef, float %add, i32 0
  ret <4 x float> %vecinit
}

define <2 x double> @test5_undef(<2 x double> %a, <2 x double> %b) {
; SSE-SLOW-LABEL: test5_undef:
; SSE-SLOW:       # %bb.0:
; SSE-SLOW-NEXT:    movapd %xmm0, %xmm1
; SSE-SLOW-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSE-SLOW-NEXT:    addsd %xmm0, %xmm1
; SSE-SLOW-NEXT:    movapd %xmm1, %xmm0
; SSE-SLOW-NEXT:    retq
;
; SSE-FAST-LABEL: test5_undef:
; SSE-FAST:       # %bb.0:
; SSE-FAST-NEXT:    haddpd %xmm0, %xmm0
; SSE-FAST-NEXT:    retq
;
; AVX-SLOW-LABEL: test5_undef:
; AVX-SLOW:       # %bb.0:
; AVX-SLOW-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX-SLOW-NEXT:    vaddsd %xmm1, %xmm0, %xmm0
; AVX-SLOW-NEXT:    retq
;
; AVX-FAST-LABEL: test5_undef:
; AVX-FAST:       # %bb.0:
; AVX-FAST-NEXT:    vhaddpd %xmm0, %xmm0, %xmm0
; AVX-FAST-NEXT:    retq
  %vecext = extractelement <2 x double> %a, i32 0
  %vecext1 = extractelement <2 x double> %a, i32 1
  %add = fadd double %vecext, %vecext1
  %vecinit = insertelement <2 x double> undef, double %add, i32 0
  ret <2 x double> %vecinit
}

define <4 x float> @test6_undef(<4 x float> %a, <4 x float> %b) {
; SSE-LABEL: test6_undef:
; SSE:       # %bb.0:
; SSE-NEXT:    haddps %xmm0, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test6_undef:
; AVX:       # %bb.0:
; AVX-NEXT:    vhaddps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
  %vecext = extractelement <4 x float> %a, i32 0
  %vecext1 = extractelement <4 x float> %a, i32 1
  %add = fadd float %vecext, %vecext1
  %vecinit = insertelement <4 x float> undef, float %add, i32 0
  %vecext2 = extractelement <4 x float> %a, i32 2
  %vecext3 = extractelement <4 x float> %a, i32 3
  %add4 = fadd float %vecext2, %vecext3
  %vecinit5 = insertelement <4 x float> %vecinit, float %add4, i32 1
  ret <4 x float> %vecinit5
}

define <4 x float> @test7_undef(<4 x float> %a, <4 x float> %b) {
; SSE-LABEL: test7_undef:
; SSE:       # %bb.0:
; SSE-NEXT:    haddps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test7_undef:
; AVX:       # %bb.0:
; AVX-NEXT:    vhaddps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %vecext = extractelement <4 x float> %b, i32 0
  %vecext1 = extractelement <4 x float> %b, i32 1
  %add = fadd float %vecext, %vecext1
  %vecinit = insertelement <4 x float> undef, float %add, i32 2
  %vecext2 = extractelement <4 x float> %b, i32 2
  %vecext3 = extractelement <4 x float> %b, i32 3
  %add4 = fadd float %vecext2, %vecext3
  %vecinit5 = insertelement <4 x float> %vecinit, float %add4, i32 3
  ret <4 x float> %vecinit5
}

define <4 x float> @test8_undef(<4 x float> %a, <4 x float> %b) {
; SSE-SLOW-LABEL: test8_undef:
; SSE-SLOW:       # %bb.0:
; SSE-SLOW-NEXT:    movshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; SSE-SLOW-NEXT:    addss %xmm0, %xmm1
; SSE-SLOW-NEXT:    movaps %xmm0, %xmm2
; SSE-SLOW-NEXT:    unpckhpd {{.*#+}} xmm2 = xmm2[1],xmm0[1]
; SSE-SLOW-NEXT:    shufps {{.*#+}} xmm0 = xmm0[3,1,2,3]
; SSE-SLOW-NEXT:    addss %xmm2, %xmm0
; SSE-SLOW-NEXT:    movlhps {{.*#+}} xmm1 = xmm1[0],xmm0[0]
; SSE-SLOW-NEXT:    movaps %xmm1, %xmm0
; SSE-SLOW-NEXT:    retq
;
; SSE-FAST-LABEL: test8_undef:
; SSE-FAST:       # %bb.0:
; SSE-FAST-NEXT:    haddps %xmm0, %xmm0
; SSE-FAST-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,1,1,3]
; SSE-FAST-NEXT:    retq
;
; AVX-SLOW-LABEL: test8_undef:
; AVX-SLOW:       # %bb.0:
; AVX-SLOW-NEXT:    vmovshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; AVX-SLOW-NEXT:    vaddss %xmm1, %xmm0, %xmm1
; AVX-SLOW-NEXT:    vpermilpd {{.*#+}} xmm2 = xmm0[1,0]
; AVX-SLOW-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[3,1,2,3]
; AVX-SLOW-NEXT:    vaddss %xmm0, %xmm2, %xmm0
; AVX-SLOW-NEXT:    vinsertps {{.*#+}} xmm0 = xmm1[0,1],xmm0[0],xmm1[3]
; AVX-SLOW-NEXT:    retq
;
; AVX-FAST-LABEL: test8_undef:
; AVX-FAST:       # %bb.0:
; AVX-FAST-NEXT:    vhaddps %xmm0, %xmm0, %xmm0
; AVX-FAST-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[0,1,1,3]
; AVX-FAST-NEXT:    retq
  %vecext = extractelement <4 x float> %a, i32 0
  %vecext1 = extractelement <4 x float> %a, i32 1
  %add = fadd float %vecext, %vecext1
  %vecinit = insertelement <4 x float> undef, float %add, i32 0
  %vecext2 = extractelement <4 x float> %a, i32 2
  %vecext3 = extractelement <4 x float> %a, i32 3
  %add4 = fadd float %vecext2, %vecext3
  %vecinit5 = insertelement <4 x float> %vecinit, float %add4, i32 2
  ret <4 x float> %vecinit5
}

define <4 x float> @test9_undef(<4 x float> %a, <4 x float> %b) {
; SSE-LABEL: test9_undef:
; SSE:       # %bb.0:
; SSE-NEXT:    haddps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test9_undef:
; AVX:       # %bb.0:
; AVX-NEXT:    vhaddps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %vecext = extractelement <4 x float> %a, i32 0
  %vecext1 = extractelement <4 x float> %a, i32 1
  %add = fadd float %vecext, %vecext1
  %vecinit = insertelement <4 x float> undef, float %add, i32 0
  %vecext2 = extractelement <4 x float> %b, i32 2
  %vecext3 = extractelement <4 x float> %b, i32 3
  %add4 = fadd float %vecext2, %vecext3
  %vecinit5 = insertelement <4 x float> %vecinit, float %add4, i32 3
  ret <4 x float> %vecinit5
}

define <8 x float> @test10_undef(<8 x float> %a, <8 x float> %b) {
; SSE-LABEL: test10_undef:
; SSE:       # %bb.0:
; SSE-NEXT:    haddps %xmm2, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test10_undef:
; AVX:       # %bb.0:
; AVX-NEXT:    vhaddps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %vecext = extractelement <8 x float> %a, i32 0
  %vecext1 = extractelement <8 x float> %a, i32 1
  %add = fadd float %vecext, %vecext1
  %vecinit = insertelement <8 x float> undef, float %add, i32 0
  %vecext2 = extractelement <8 x float> %b, i32 2
  %vecext3 = extractelement <8 x float> %b, i32 3
  %add4 = fadd float %vecext2, %vecext3
  %vecinit5 = insertelement <8 x float> %vecinit, float %add4, i32 3
  ret <8 x float> %vecinit5
}

define <8 x float> @test11_undef(<8 x float> %a, <8 x float> %b) {
; SSE-SLOW-LABEL: test11_undef:
; SSE-SLOW:       # %bb.0:
; SSE-SLOW-NEXT:    movshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; SSE-SLOW-NEXT:    addss %xmm1, %xmm0
; SSE-SLOW-NEXT:    movshdup {{.*#+}} xmm1 = xmm3[1,1,3,3]
; SSE-SLOW-NEXT:    addss %xmm3, %xmm1
; SSE-SLOW-NEXT:    movddup {{.*#+}} xmm1 = xmm1[0,0]
; SSE-SLOW-NEXT:    retq
;
; SSE-FAST-LABEL: test11_undef:
; SSE-FAST:       # %bb.0:
; SSE-FAST-NEXT:    movaps %xmm3, %xmm1
; SSE-FAST-NEXT:    haddps %xmm0, %xmm0
; SSE-FAST-NEXT:    haddps %xmm3, %xmm1
; SSE-FAST-NEXT:    retq
;
; AVX-LABEL: test11_undef:
; AVX:       # %bb.0:
; AVX-NEXT:    vhaddps %ymm1, %ymm0, %ymm0
; AVX-NEXT:    retq
  %vecext = extractelement <8 x float> %a, i32 0
  %vecext1 = extractelement <8 x float> %a, i32 1
  %add = fadd float %vecext, %vecext1
  %vecinit = insertelement <8 x float> undef, float %add, i32 0
  %vecext2 = extractelement <8 x float> %b, i32 4
  %vecext3 = extractelement <8 x float> %b, i32 5
  %add4 = fadd float %vecext2, %vecext3
  %vecinit5 = insertelement <8 x float> %vecinit, float %add4, i32 6
  ret <8 x float> %vecinit5
}

define <8 x float> @test12_undef(<8 x float> %a, <8 x float> %b) {
; SSE-LABEL: test12_undef:
; SSE:       # %bb.0:
; SSE-NEXT:    haddps %xmm0, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test12_undef:
; AVX:       # %bb.0:
; AVX-NEXT:    vhaddps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
  %vecext = extractelement <8 x float> %a, i32 0
  %vecext1 = extractelement <8 x float> %a, i32 1
  %add = fadd float %vecext, %vecext1
  %vecinit = insertelement <8 x float> undef, float %add, i32 0
  %vecext2 = extractelement <8 x float> %a, i32 2
  %vecext3 = extractelement <8 x float> %a, i32 3
  %add4 = fadd float %vecext2, %vecext3
  %vecinit5 = insertelement <8 x float> %vecinit, float %add4, i32 1
  ret <8 x float> %vecinit5
}

define <8 x float> @test13_undef(<8 x float> %a, <8 x float> %b) {
; SSE-LABEL: test13_undef:
; SSE:       # %bb.0:
; SSE-NEXT:    haddps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test13_undef:
; AVX:       # %bb.0:
; AVX-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX-NEXT:    vhaddps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %vecext = extractelement <8 x float> %a, i32 0
  %vecext1 = extractelement <8 x float> %a, i32 1
  %add1 = fadd float %vecext, %vecext1
  %vecinit1 = insertelement <8 x float> undef, float %add1, i32 0
  %vecext2 = extractelement <8 x float> %a, i32 2
  %vecext3 = extractelement <8 x float> %a, i32 3
  %add2 = fadd float %vecext2, %vecext3
  %vecinit2 = insertelement <8 x float> %vecinit1, float %add2, i32 1
  %vecext4 = extractelement <8 x float> %a, i32 4
  %vecext5 = extractelement <8 x float> %a, i32 5
  %add3 = fadd float %vecext4, %vecext5
  %vecinit3 = insertelement <8 x float> %vecinit2, float %add3, i32 2
  %vecext6 = extractelement <8 x float> %a, i32 6
  %vecext7 = extractelement <8 x float> %a, i32 7
  %add4 = fadd float %vecext6, %vecext7
  %vecinit4 = insertelement <8 x float> %vecinit3, float %add4, i32 3
  ret <8 x float> %vecinit4
}

define <16 x float> @test13_v16f32_undef(<16 x float> %a, <16 x float> %b) {
; SSE-LABEL: test13_v16f32_undef:
; SSE:       # %bb.0:
; SSE-NEXT:    haddps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX1-SLOW-LABEL: test13_v16f32_undef:
; AVX1-SLOW:       # %bb.0:
; AVX1-SLOW-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-SLOW-NEXT:    vhaddps %xmm1, %xmm0, %xmm0
; AVX1-SLOW-NEXT:    retq
;
; AVX-FAST-LABEL: test13_v16f32_undef:
; AVX-FAST:       # %bb.0:
; AVX-FAST-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX-FAST-NEXT:    vhaddps %xmm1, %xmm0, %xmm0
; AVX-FAST-NEXT:    retq
;
; AVX512-SLOW-LABEL: test13_v16f32_undef:
; AVX512-SLOW:       # %bb.0:
; AVX512-SLOW-NEXT:    vmovshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; AVX512-SLOW-NEXT:    vaddss %xmm1, %xmm0, %xmm1
; AVX512-SLOW-NEXT:    vpermilpd {{.*#+}} xmm2 = xmm0[1,0]
; AVX512-SLOW-NEXT:    vpermilps {{.*#+}} xmm3 = xmm0[3,1,2,3]
; AVX512-SLOW-NEXT:    vaddss %xmm3, %xmm2, %xmm2
; AVX512-SLOW-NEXT:    vinsertps {{.*#+}} xmm1 = xmm1[0],xmm2[0],xmm1[2,3]
; AVX512-SLOW-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX512-SLOW-NEXT:    vmovshdup {{.*#+}} xmm2 = xmm0[1,1,3,3]
; AVX512-SLOW-NEXT:    vaddss %xmm2, %xmm0, %xmm2
; AVX512-SLOW-NEXT:    vinsertps {{.*#+}} xmm1 = xmm1[0,1],xmm2[0],xmm1[3]
; AVX512-SLOW-NEXT:    vpermilpd {{.*#+}} xmm2 = xmm0[1,0]
; AVX512-SLOW-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[3,1,2,3]
; AVX512-SLOW-NEXT:    vaddss %xmm0, %xmm2, %xmm0
; AVX512-SLOW-NEXT:    vinsertps {{.*#+}} xmm0 = xmm1[0,1,2],xmm0[0]
; AVX512-SLOW-NEXT:    retq
  %vecext = extractelement <16 x float> %a, i32 0
  %vecext1 = extractelement <16 x float> %a, i32 1
  %add1 = fadd float %vecext, %vecext1
  %vecinit1 = insertelement <16 x float> undef, float %add1, i32 0
  %vecext2 = extractelement <16 x float> %a, i32 2
  %vecext3 = extractelement <16 x float> %a, i32 3
  %add2 = fadd float %vecext2, %vecext3
  %vecinit2 = insertelement <16 x float> %vecinit1, float %add2, i32 1
  %vecext4 = extractelement <16 x float> %a, i32 4
  %vecext5 = extractelement <16 x float> %a, i32 5
  %add3 = fadd float %vecext4, %vecext5
  %vecinit3 = insertelement <16 x float> %vecinit2, float %add3, i32 2
  %vecext6 = extractelement <16 x float> %a, i32 6
  %vecext7 = extractelement <16 x float> %a, i32 7
  %add4 = fadd float %vecext6, %vecext7
  %vecinit4 = insertelement <16 x float> %vecinit3, float %add4, i32 3
  ret <16 x float> %vecinit4
}
define <2 x double> @add_pd_003(<2 x double> %x) {
; SSE-SLOW-LABEL: add_pd_003:
; SSE-SLOW:       # %bb.0:
; SSE-SLOW-NEXT:    movddup {{.*#+}} xmm1 = xmm0[0,0]
; SSE-SLOW-NEXT:    addpd %xmm1, %xmm0
; SSE-SLOW-NEXT:    retq
;
; SSE-FAST-LABEL: add_pd_003:
; SSE-FAST:       # %bb.0:
; SSE-FAST-NEXT:    haddpd %xmm0, %xmm0
; SSE-FAST-NEXT:    retq
;
; AVX-SLOW-LABEL: add_pd_003:
; AVX-SLOW:       # %bb.0:
; AVX-SLOW-NEXT:    vmovddup {{.*#+}} xmm1 = xmm0[0,0]
; AVX-SLOW-NEXT:    vaddpd %xmm0, %xmm1, %xmm0
; AVX-SLOW-NEXT:    retq
;
; AVX-FAST-LABEL: add_pd_003:
; AVX-FAST:       # %bb.0:
; AVX-FAST-NEXT:    vhaddpd %xmm0, %xmm0, %xmm0
; AVX-FAST-NEXT:    retq
  %l = shufflevector <2 x double> %x, <2 x double> undef, <2 x i32> <i32 undef, i32 0>
  %add = fadd <2 x double> %l, %x
  ret <2 x double> %add
}

; Change shuffle mask - no undefs.

define <2 x double> @add_pd_003_2(<2 x double> %x) {
; SSE-SLOW-LABEL: add_pd_003_2:
; SSE-SLOW:       # %bb.0:
; SSE-SLOW-NEXT:    movapd %xmm0, %xmm1
; SSE-SLOW-NEXT:    shufpd {{.*#+}} xmm1 = xmm1[1],xmm0[0]
; SSE-SLOW-NEXT:    addpd %xmm0, %xmm1
; SSE-SLOW-NEXT:    movapd %xmm1, %xmm0
; SSE-SLOW-NEXT:    retq
;
; SSE-FAST-LABEL: add_pd_003_2:
; SSE-FAST:       # %bb.0:
; SSE-FAST-NEXT:    haddpd %xmm0, %xmm0
; SSE-FAST-NEXT:    retq
;
; AVX-SLOW-LABEL: add_pd_003_2:
; AVX-SLOW:       # %bb.0:
; AVX-SLOW-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX-SLOW-NEXT:    vaddpd %xmm0, %xmm1, %xmm0
; AVX-SLOW-NEXT:    retq
;
; AVX-FAST-LABEL: add_pd_003_2:
; AVX-FAST:       # %bb.0:
; AVX-FAST-NEXT:    vhaddpd %xmm0, %xmm0, %xmm0
; AVX-FAST-NEXT:    retq
  %l = shufflevector <2 x double> %x, <2 x double> undef, <2 x i32> <i32 1, i32 0>
  %add = fadd <2 x double> %l, %x
  ret <2 x double> %add
}

define <2 x double> @add_pd_010(<2 x double> %x) {
; SSE-SLOW-LABEL: add_pd_010:
; SSE-SLOW:       # %bb.0:
; SSE-SLOW-NEXT:    movddup {{.*#+}} xmm1 = xmm0[0,0]
; SSE-SLOW-NEXT:    addpd %xmm0, %xmm1
; SSE-SLOW-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1,1]
; SSE-SLOW-NEXT:    movapd %xmm1, %xmm0
; SSE-SLOW-NEXT:    retq
;
; SSE-FAST-LABEL: add_pd_010:
; SSE-FAST:       # %bb.0:
; SSE-FAST-NEXT:    haddpd %xmm0, %xmm0
; SSE-FAST-NEXT:    retq
;
; AVX-SLOW-LABEL: add_pd_010:
; AVX-SLOW:       # %bb.0:
; AVX-SLOW-NEXT:    vmovddup {{.*#+}} xmm1 = xmm0[0,0]
; AVX-SLOW-NEXT:    vaddpd %xmm0, %xmm1, %xmm0
; AVX-SLOW-NEXT:    vpermilpd {{.*#+}} xmm0 = xmm0[1,0]
; AVX-SLOW-NEXT:    retq
;
; AVX-FAST-LABEL: add_pd_010:
; AVX-FAST:       # %bb.0:
; AVX-FAST-NEXT:    vhaddpd %xmm0, %xmm0, %xmm0
; AVX-FAST-NEXT:    retq
  %l = shufflevector <2 x double> %x, <2 x double> undef, <2 x i32> <i32 undef, i32 0>
  %add = fadd <2 x double> %l, %x
  %shuffle2 = shufflevector <2 x double> %add, <2 x double> undef, <2 x i32> <i32 1, i32 undef>
  ret <2 x double> %shuffle2
}

define <4 x float> @add_ps_007(<4 x float> %x) {
; SSE-LABEL: add_ps_007:
; SSE:       # %bb.0:
; SSE-NEXT:    haddps %xmm0, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: add_ps_007:
; AVX:       # %bb.0:
; AVX-NEXT:    vhaddps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
  %l = shufflevector <4 x float> %x, <4 x float> undef, <4 x i32> <i32 undef, i32 undef, i32 0, i32 2>
  %r = shufflevector <4 x float> %x, <4 x float> undef, <4 x i32> <i32 undef, i32 undef, i32 1, i32 3>
  %add = fadd <4 x float> %l, %r
  ret <4 x float> %add
}

define <4 x float> @add_ps_030(<4 x float> %x) {
; SSE-LABEL: add_ps_030:
; SSE:       # %bb.0:
; SSE-NEXT:    haddps %xmm0, %xmm0
; SSE-NEXT:    shufps {{.*#+}} xmm0 = xmm0[3,2,2,3]
; SSE-NEXT:    retq
;
; AVX-LABEL: add_ps_030:
; AVX:       # %bb.0:
; AVX-NEXT:    vhaddps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[3,2,2,3]
; AVX-NEXT:    retq
  %l = shufflevector <4 x float> %x, <4 x float> undef, <4 x i32> <i32 undef, i32 undef, i32 0, i32 2>
  %r = shufflevector <4 x float> %x, <4 x float> undef, <4 x i32> <i32 undef, i32 undef, i32 1, i32 3>
  %add = fadd <4 x float> %l, %r
  %shuffle2 = shufflevector <4 x float> %add, <4 x float> undef, <4 x i32> <i32 3, i32 2, i32 undef, i32 undef>
  ret <4 x float> %shuffle2
}

define <4 x float> @add_ps_007_2(<4 x float> %x) {
; SSE-LABEL: add_ps_007_2:
; SSE:       # %bb.0:
; SSE-NEXT:    haddps %xmm0, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: add_ps_007_2:
; AVX:       # %bb.0:
; AVX-NEXT:    vhaddps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
  %l = shufflevector <4 x float> %x, <4 x float> undef, <4 x i32> <i32 undef, i32 undef, i32 0, i32 undef>
  %r = shufflevector <4 x float> %x, <4 x float> undef, <4 x i32> <i32 undef, i32 undef, i32 1, i32 undef>
  %add = fadd <4 x float> %l, %r
  ret <4 x float> %add
}

define <4 x float> @add_ps_008(<4 x float> %x) {
; SSE-SLOW-LABEL: add_ps_008:
; SSE-SLOW:       # %bb.0:
; SSE-SLOW-NEXT:    movsldup {{.*#+}} xmm1 = xmm0[0,0,2,2]
; SSE-SLOW-NEXT:    addps %xmm1, %xmm0
; SSE-SLOW-NEXT:    retq
;
; SSE-FAST-LABEL: add_ps_008:
; SSE-FAST:       # %bb.0:
; SSE-FAST-NEXT:    haddps %xmm0, %xmm0
; SSE-FAST-NEXT:    retq
;
; AVX-SLOW-LABEL: add_ps_008:
; AVX-SLOW:       # %bb.0:
; AVX-SLOW-NEXT:    vmovsldup {{.*#+}} xmm1 = xmm0[0,0,2,2]
; AVX-SLOW-NEXT:    vaddps %xmm0, %xmm1, %xmm0
; AVX-SLOW-NEXT:    retq
;
; AVX-FAST-LABEL: add_ps_008:
; AVX-FAST:       # %bb.0:
; AVX-FAST-NEXT:    vhaddps %xmm0, %xmm0, %xmm0
; AVX-FAST-NEXT:    retq
  %l = shufflevector <4 x float> %x, <4 x float> undef, <4 x i32> <i32 undef, i32 undef, i32 undef, i32 2>
  %add = fadd <4 x float> %l, %x
  ret <4 x float> %add
}

define <4 x float> @add_ps_017(<4 x float> %x) {
; SSE-SLOW-LABEL: add_ps_017:
; SSE-SLOW:       # %bb.0:
; SSE-SLOW-NEXT:    movsldup {{.*#+}} xmm1 = xmm0[0,0,2,2]
; SSE-SLOW-NEXT:    addps %xmm0, %xmm1
; SSE-SLOW-NEXT:    shufps {{.*#+}} xmm1 = xmm1[3,1,2,3]
; SSE-SLOW-NEXT:    movaps %xmm1, %xmm0
; SSE-SLOW-NEXT:    retq
;
; SSE-FAST-LABEL: add_ps_017:
; SSE-FAST:       # %bb.0:
; SSE-FAST-NEXT:    haddps %xmm0, %xmm0
; SSE-FAST-NEXT:    shufps {{.*#+}} xmm0 = xmm0[3,1,2,3]
; SSE-FAST-NEXT:    retq
;
; AVX-SLOW-LABEL: add_ps_017:
; AVX-SLOW:       # %bb.0:
; AVX-SLOW-NEXT:    vmovsldup {{.*#+}} xmm1 = xmm0[0,0,2,2]
; AVX-SLOW-NEXT:    vaddps %xmm0, %xmm1, %xmm0
; AVX-SLOW-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[3,1,2,3]
; AVX-SLOW-NEXT:    retq
;
; AVX-FAST-LABEL: add_ps_017:
; AVX-FAST:       # %bb.0:
; AVX-FAST-NEXT:    vhaddps %xmm0, %xmm0, %xmm0
; AVX-FAST-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[3,1,2,3]
; AVX-FAST-NEXT:    retq
  %l = shufflevector <4 x float> %x, <4 x float> undef, <4 x i32> <i32 undef, i32 undef, i32 undef, i32 2>
  %add = fadd <4 x float> %l, %x
  %shuffle2 = shufflevector <4 x float> %add, <4 x float> undef, <4 x i32> <i32 3, i32 undef, i32 undef, i32 undef>
  ret <4 x float> %shuffle2
}

define <4 x float> @add_ps_018(<4 x float> %x) {
; SSE-LABEL: add_ps_018:
; SSE:       # %bb.0:
; SSE-NEXT:    haddps %xmm0, %xmm0
; SSE-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,2,2,3]
; SSE-NEXT:    retq
;
; AVX-LABEL: add_ps_018:
; AVX:       # %bb.0:
; AVX-NEXT:    vhaddps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[0,2,2,3]
; AVX-NEXT:    retq
  %l = shufflevector <4 x float> %x, <4 x float> undef, <4 x i32> <i32 undef, i32 undef, i32 0, i32 undef>
  %r = shufflevector <4 x float> %x, <4 x float> undef, <4 x i32> <i32 undef, i32 undef, i32 1, i32 undef>
  %add = fadd <4 x float> %l, %r
  %shuffle2 = shufflevector <4 x float> %add, <4 x float> undef, <4 x i32> <i32 undef, i32 2, i32 undef, i32 undef>
  ret <4 x float> %shuffle2
}

define <4 x float> @v8f32_inputs_v4f32_output_0101(<8 x float> %a, <8 x float> %b) {
; SSE-LABEL: v8f32_inputs_v4f32_output_0101:
; SSE:       # %bb.0:
; SSE-NEXT:    haddps %xmm2, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: v8f32_inputs_v4f32_output_0101:
; AVX:       # %bb.0:
; AVX-NEXT:    vhaddps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
  %a0 = extractelement <8 x float> %a, i32 0
  %a1 = extractelement <8 x float> %a, i32 1
  %b0 = extractelement <8 x float> %b, i32 0
  %b1 = extractelement <8 x float> %b, i32 1
  %add0 = fadd float %a0, %a1
  %add2 = fadd float %b0, %b1
  %r0 = insertelement <4 x float> undef, float %add0, i32 0
  %r = insertelement <4 x float> %r0, float %add2, i32 2
  ret <4 x float> %r
}

define <4 x float> @v8f32_input0_v4f32_output_0123(<8 x float> %a, <4 x float> %b) {
; SSE-LABEL: v8f32_input0_v4f32_output_0123:
; SSE:       # %bb.0:
; SSE-NEXT:    haddps %xmm2, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: v8f32_input0_v4f32_output_0123:
; AVX:       # %bb.0:
; AVX-NEXT:    vhaddps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
  %a0 = extractelement <8 x float> %a, i32 0
  %a1 = extractelement <8 x float> %a, i32 1
  %b2 = extractelement <4 x float> %b, i32 2
  %b3 = extractelement <4 x float> %b, i32 3
  %add0 = fadd float %a0, %a1
  %add3 = fadd float %b2, %b3
  %r0 = insertelement <4 x float> undef, float %add0, i32 0
  %r = insertelement <4 x float> %r0, float %add3, i32 3
  ret <4 x float> %r
}

define <4 x float> @v8f32_input1_v4f32_output_2301(<4 x float> %a, <8 x float> %b) {
; SSE-LABEL: v8f32_input1_v4f32_output_2301:
; SSE:       # %bb.0:
; SSE-NEXT:    haddps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: v8f32_input1_v4f32_output_2301:
; AVX:       # %bb.0:
; AVX-NEXT:    vhaddps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
  %a2 = extractelement <4 x float> %a, i32 2
  %a3 = extractelement <4 x float> %a, i32 3
  %b0 = extractelement <8 x float> %b, i32 0
  %b1 = extractelement <8 x float> %b, i32 1
  %add1 = fadd float %a2, %a3
  %add2 = fadd float %b0, %b1
  %r1 = insertelement <4 x float> undef, float %add1, i32 1
  %r = insertelement <4 x float> %r1, float %add2, i32 2
  ret <4 x float> %r
}

define <4 x float> @v8f32_inputs_v4f32_output_2323(<8 x float> %a, <8 x float> %b) {
; SSE-LABEL: v8f32_inputs_v4f32_output_2323:
; SSE:       # %bb.0:
; SSE-NEXT:    haddps %xmm2, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: v8f32_inputs_v4f32_output_2323:
; AVX:       # %bb.0:
; AVX-NEXT:    vhaddps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
  %a2 = extractelement <8 x float> %a, i32 2
  %a3 = extractelement <8 x float> %a, i32 3
  %b2 = extractelement <8 x float> %b, i32 2
  %b3 = extractelement <8 x float> %b, i32 3
  %add1 = fadd float %a2, %a3
  %add3 = fadd float %b2, %b3
  %r1 = insertelement <4 x float> undef, float %add1, i32 1
  %r = insertelement <4 x float> %r1, float %add3, i32 3
  ret <4 x float> %r
}

define <4 x float> @v16f32_inputs_v4f32_output_0123(<16 x float> %a, <16 x float> %b) {
; SSE-LABEL: v16f32_inputs_v4f32_output_0123:
; SSE:       # %bb.0:
; SSE-NEXT:    haddps %xmm4, %xmm0
; SSE-NEXT:    retq
;
; AVX1-SLOW-LABEL: v16f32_inputs_v4f32_output_0123:
; AVX1-SLOW:       # %bb.0:
; AVX1-SLOW-NEXT:    vhaddps %xmm2, %xmm0, %xmm0
; AVX1-SLOW-NEXT:    vzeroupper
; AVX1-SLOW-NEXT:    retq
;
; AVX1-FAST-LABEL: v16f32_inputs_v4f32_output_0123:
; AVX1-FAST:       # %bb.0:
; AVX1-FAST-NEXT:    vhaddps %xmm2, %xmm0, %xmm0
; AVX1-FAST-NEXT:    vzeroupper
; AVX1-FAST-NEXT:    retq
;
; AVX512-LABEL: v16f32_inputs_v4f32_output_0123:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vhaddps %xmm1, %xmm0, %xmm0
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %a0 = extractelement <16 x float> %a, i32 0
  %a1 = extractelement <16 x float> %a, i32 1
  %b2 = extractelement <16 x float> %b, i32 2
  %b3 = extractelement <16 x float> %b, i32 3
  %add0 = fadd float %a0, %a1
  %add3 = fadd float %b2, %b3
  %r0 = insertelement <4 x float> undef, float %add0, i32 0
  %r = insertelement <4 x float> %r0, float %add3, i32 3
  ret <4 x float> %r
}

define <8 x float> @v16f32_inputs_v8f32_output_4567(<16 x float> %a, <16 x float> %b) {
; SSE-LABEL: v16f32_inputs_v8f32_output_4567:
; SSE:       # %bb.0:
; SSE-NEXT:    haddps %xmm5, %xmm1
; SSE-NEXT:    retq
;
; AVX1-SLOW-LABEL: v16f32_inputs_v8f32_output_4567:
; AVX1-SLOW:       # %bb.0:
; AVX1-SLOW-NEXT:    vhaddps %ymm2, %ymm0, %ymm0
; AVX1-SLOW-NEXT:    retq
;
; AVX1-FAST-LABEL: v16f32_inputs_v8f32_output_4567:
; AVX1-FAST:       # %bb.0:
; AVX1-FAST-NEXT:    vhaddps %ymm2, %ymm0, %ymm0
; AVX1-FAST-NEXT:    retq
;
; AVX512-LABEL: v16f32_inputs_v8f32_output_4567:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vhaddps %ymm1, %ymm0, %ymm0
; AVX512-NEXT:    retq
  %a4 = extractelement <16 x float> %a, i32 4
  %a5 = extractelement <16 x float> %a, i32 5
  %b6 = extractelement <16 x float> %b, i32 6
  %b7 = extractelement <16 x float> %b, i32 7
  %add4 = fadd float %a4, %a5
  %add7 = fadd float %b6, %b7
  %r4 = insertelement <8 x float> undef, float %add4, i32 4
  %r = insertelement <8 x float> %r4, float %add7, i32 7
  ret <8 x float> %r
}

define <8 x float> @PR40243(<8 x float> %a, <8 x float> %b) {
; SSE-LABEL: PR40243:
; SSE:       # %bb.0:
; SSE-NEXT:    haddps %xmm3, %xmm1
; SSE-NEXT:    retq
;
; AVX-LABEL: PR40243:
; AVX:       # %bb.0:
; AVX-NEXT:    vhaddps %ymm1, %ymm0, %ymm0
; AVX-NEXT:    retq
  %a4 = extractelement <8 x float> %a, i32 4
  %a5 = extractelement <8 x float> %a, i32 5
  %add4 = fadd float %a4, %a5
  %b6 = extractelement <8 x float> %b, i32 6
  %b7 = extractelement <8 x float> %b, i32 7
  %add7 = fadd float %b6, %b7
  %r4 = insertelement <8 x float> undef, float %add4, i32 4
  %r = insertelement <8 x float> %r4, float %add7, i32 7
  ret <8 x float> %r
}

define <4 x double> @PR44694(<4 x double> %0, <4 x double> %1) {
; SSE-SLOW-LABEL: PR44694:
; SSE-SLOW:       # %bb.0:
; SSE-SLOW-NEXT:    movddup {{.*#+}} xmm0 = xmm1[0,0]
; SSE-SLOW-NEXT:    haddpd %xmm3, %xmm2
; SSE-SLOW-NEXT:    addpd %xmm1, %xmm0
; SSE-SLOW-NEXT:    movapd %xmm2, %xmm1
; SSE-SLOW-NEXT:    retq
;
; SSE-FAST-LABEL: PR44694:
; SSE-FAST:       # %bb.0:
; SSE-FAST-NEXT:    movapd %xmm1, %xmm0
; SSE-FAST-NEXT:    haddpd %xmm3, %xmm2
; SSE-FAST-NEXT:    haddpd %xmm1, %xmm0
; SSE-FAST-NEXT:    movapd %xmm2, %xmm1
; SSE-FAST-NEXT:    retq
;
; AVX-LABEL: PR44694:
; AVX:       # %bb.0:
; AVX-NEXT:    vperm2f128 {{.*#+}} ymm0 = ymm0[2,3],ymm1[2,3]
; AVX-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm1
; AVX-NEXT:    vhaddpd %ymm0, %ymm1, %ymm0
; AVX-NEXT:    retq
  %3 = shufflevector <4 x double> %0, <4 x double> %1, <4 x i32> <i32 undef, i32 2, i32 4, i32 6>
  %4 = shufflevector <4 x double> %0, <4 x double> %1, <4 x i32> <i32 undef, i32 3, i32 5, i32 7>
  %5 = fadd <4 x double> %3, %4
  ret <4 x double> %5
}

define <4 x float> @PR45747_1(<4 x float> %a, <4 x float> %b) nounwind {
; SSE-LABEL: PR45747_1:
; SSE:       # %bb.0:
; SSE-NEXT:    movshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; SSE-NEXT:    addps %xmm0, %xmm1
; SSE-NEXT:    shufps {{.*#+}} xmm1 = xmm1[0,2,2,3]
; SSE-NEXT:    movaps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: PR45747_1:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; AVX-NEXT:    vaddps %xmm0, %xmm1, %xmm0
; AVX-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[0,2,2,3]
; AVX-NEXT:    retq
  %t0 = shufflevector <4 x float> %a, <4 x float> undef, <4 x i32> <i32 undef, i32 undef, i32 3, i32 undef>
  %t1 = fadd <4 x float> %t0, %a
  %shuffle = shufflevector <4 x float> %t1, <4 x float> undef, <4 x i32> <i32 undef, i32 2, i32 undef, i32 undef>
  ret <4 x float> %shuffle
}

define <4 x float> @PR45747_2(<4 x float> %a, <4 x float> %b) nounwind {
; SSE-LABEL: PR45747_2:
; SSE:       # %bb.0:
; SSE-NEXT:    movshdup {{.*#+}} xmm0 = xmm1[1,1,3,3]
; SSE-NEXT:    addps %xmm1, %xmm0
; SSE-NEXT:    movhlps {{.*#+}} xmm0 = xmm0[1,1]
; SSE-NEXT:    retq
;
; AVX-LABEL: PR45747_2:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovshdup {{.*#+}} xmm0 = xmm1[1,1,3,3]
; AVX-NEXT:    vaddps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vpermilpd {{.*#+}} xmm0 = xmm0[1,0]
; AVX-NEXT:    retq
  %t0 = shufflevector <4 x float> %b, <4 x float> undef, <4 x i32> <i32 undef, i32 undef, i32 3, i32 undef>
  %t1 = fadd <4 x float> %t0, %b
  %shuffle = shufflevector <4 x float> %t1, <4 x float> undef, <4 x i32> <i32 2, i32 undef, i32 undef, i32 undef>
  ret <4 x float> %shuffle
}
