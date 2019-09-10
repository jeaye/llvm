; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown | FileCheck %s --check-prefixes=CHECK,SSE
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefixes=CHECK,AVX

; PR31455 - https://bugs.llvm.org/show_bug.cgi?id=31455
; We have to assume that errno can be set, so we have to make a libcall in that case.
; But it's better for perf to check that the argument is valid rather than the result of
; sqrtss/sqrtsd.
; Note: This is really a test of the -partially-inline-libcalls IR pass (and we have an IR test
; for that), but we're checking the final asm to make sure that comes out as expected too.

define float @f(float %val) nounwind {
; SSE-LABEL: f:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm1, %xmm1
; SSE-NEXT:    ucomiss %xmm1, %xmm0
; SSE-NEXT:    jb .LBB0_2
; SSE-NEXT:  # %bb.1: # %.split
; SSE-NEXT:    sqrtss %xmm0, %xmm0
; SSE-NEXT:    retq
; SSE-NEXT:  .LBB0_2: # %call.sqrt
; SSE-NEXT:    jmp sqrtf # TAILCALL
;
; AVX-LABEL: f:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; AVX-NEXT:    vucomiss %xmm1, %xmm0
; AVX-NEXT:    jb .LBB0_2
; AVX-NEXT:  # %bb.1: # %.split
; AVX-NEXT:    vsqrtss %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
; AVX-NEXT:  .LBB0_2: # %call.sqrt
; AVX-NEXT:    jmp sqrtf # TAILCALL
  %res = tail call float @sqrtf(float %val)
  ret float %res
}

define double @d(double %val) nounwind {
; SSE-LABEL: d:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm1, %xmm1
; SSE-NEXT:    ucomisd %xmm1, %xmm0
; SSE-NEXT:    jb .LBB1_2
; SSE-NEXT:  # %bb.1: # %.split
; SSE-NEXT:    sqrtsd %xmm0, %xmm0
; SSE-NEXT:    retq
; SSE-NEXT:  .LBB1_2: # %call.sqrt
; SSE-NEXT:    jmp sqrt # TAILCALL
;
; AVX-LABEL: d:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; AVX-NEXT:    vucomisd %xmm1, %xmm0
; AVX-NEXT:    jb .LBB1_2
; AVX-NEXT:  # %bb.1: # %.split
; AVX-NEXT:    vsqrtsd %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
; AVX-NEXT:  .LBB1_2: # %call.sqrt
; AVX-NEXT:    jmp sqrt # TAILCALL
  %res = tail call double @sqrt(double %val)
  ret double %res
}

define double @minsize(double %x, double %y) minsize {
; SSE-LABEL: minsize:
; SSE:       # %bb.0:
; SSE-NEXT:    mulsd %xmm0, %xmm0
; SSE-NEXT:    mulsd %xmm1, %xmm1
; SSE-NEXT:    addsd %xmm0, %xmm1
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    sqrtsd %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: minsize:
; AVX:       # %bb.0:
; AVX-NEXT:    vmulsd %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmulsd %xmm1, %xmm1, %xmm1
; AVX-NEXT:    vaddsd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vsqrtsd %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
  %t3 = fmul fast double %x, %x
  %t4 = fmul fast double %y, %y
  %t5 = fadd fast double %t3, %t4
  %t6 = tail call fast double @llvm.sqrt.f64(double %t5)
  ret double %t6
}

; Partial reg avoidance may involve register allocation
; rather than adding an instruction.

define double @partial_dep_minsize(double %x, double %y) minsize {
; SSE-LABEL: partial_dep_minsize:
; SSE:       # %bb.0:
; SSE-NEXT:    sqrtsd %xmm1, %xmm0
; SSE-NEXT:    addsd %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: partial_dep_minsize:
; AVX:       # %bb.0:
; AVX-NEXT:    vsqrtsd %xmm1, %xmm1, %xmm0
; AVX-NEXT:    vaddsd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %t6 = tail call fast double @llvm.sqrt.f64(double %y)
  %t = fadd fast double %t6, %y
  ret double %t
}

declare float @sqrtf(float)
declare double @sqrt(double)
declare double @llvm.sqrt.f64(double)
