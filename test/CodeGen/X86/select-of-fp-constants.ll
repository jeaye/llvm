; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i386--   -mattr=sse2     | FileCheck %s --check-prefixes=X86,X86-SSE
; RUN: llc < %s -mtriple=i386--   -mattr=sse4.1   | FileCheck %s --check-prefixes=X86,X86-SSE
; RUN: llc < %s -mtriple=i386--   -mattr=avx2     | FileCheck %s --check-prefixes=X86,X86-AVX2
; RUN: llc < %s -mtriple=i386--   -mattr=avx512f  | FileCheck %s --check-prefixes=X86,X86-AVX512F
; RUN: llc < %s -mtriple=x86_64-- -mattr=sse2     | FileCheck %s --check-prefix=X64-SSE
; RUN: llc < %s -mtriple=x86_64-- -mattr=sse4.1   | FileCheck %s --check-prefix=X64-SSE
; RUN: llc < %s -mtriple=x86_64-- -mattr=avx2     | FileCheck %s --check-prefixes=X64-AVX,X64-AVX2
; RUN: llc < %s -mtriple=x86_64-- -mattr=avx512f  | FileCheck %s --check-prefixes=X64-AVX,X64-AVX512F

; This should do a single load into the fp stack for the return, not diddle with xmm registers.

define float @icmp_select_fp_constants(i32 %x) nounwind readnone {
; X86-LABEL: icmp_select_fp_constants:
; X86:       # %bb.0:
; X86-NEXT:    xorl %eax, %eax
; X86-NEXT:    cmpl $0, {{[0-9]+}}(%esp)
; X86-NEXT:    sete %al
; X86-NEXT:    flds {{\.?LCPI[0-9]+_[0-9]+}}(,%eax,4)
; X86-NEXT:    retl
;
; X64-SSE-LABEL: icmp_select_fp_constants:
; X64-SSE:       # %bb.0:
; X64-SSE-NEXT:    xorl %eax, %eax
; X64-SSE-NEXT:    testl %edi, %edi
; X64-SSE-NEXT:    sete %al
; X64-SSE-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X64-SSE-NEXT:    retq
;
; X64-AVX-LABEL: icmp_select_fp_constants:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    xorl %eax, %eax
; X64-AVX-NEXT:    testl %edi, %edi
; X64-AVX-NEXT:    sete %al
; X64-AVX-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X64-AVX-NEXT:    retq
	%c = icmp eq i32 %x, 0
	%r = select i1 %c, float 42.0, float 23.0
	ret float %r
}

define float @fcmp_select_fp_constants(float %x) nounwind readnone {
; X86-SSE-LABEL: fcmp_select_fp_constants:
; X86-SSE:       # %bb.0:
; X86-SSE-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X86-SSE-NEXT:    cmpneqss {{[0-9]+}}(%esp), %xmm0
; X86-SSE-NEXT:    movd %xmm0, %eax
; X86-SSE-NEXT:    andl $1, %eax
; X86-SSE-NEXT:    flds {{\.?LCPI[0-9]+_[0-9]+}}(,%eax,4)
; X86-SSE-NEXT:    retl
;
; X86-AVX2-LABEL: fcmp_select_fp_constants:
; X86-AVX2:       # %bb.0:
; X86-AVX2-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X86-AVX2-NEXT:    vcmpneqss {{[0-9]+}}(%esp), %xmm0, %xmm0
; X86-AVX2-NEXT:    vmovd %xmm0, %eax
; X86-AVX2-NEXT:    andl $1, %eax
; X86-AVX2-NEXT:    flds {{\.?LCPI[0-9]+_[0-9]+}}(,%eax,4)
; X86-AVX2-NEXT:    retl
;
; X86-AVX512F-LABEL: fcmp_select_fp_constants:
; X86-AVX512F:       # %bb.0:
; X86-AVX512F-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X86-AVX512F-NEXT:    vcmpneqss {{\.?LCPI[0-9]+_[0-9]+}}, %xmm0, %k0
; X86-AVX512F-NEXT:    kmovw %k0, %eax
; X86-AVX512F-NEXT:    flds {{\.?LCPI[0-9]+_[0-9]+}}(,%eax,4)
; X86-AVX512F-NEXT:    retl
;
; X64-SSE-LABEL: fcmp_select_fp_constants:
; X64-SSE:       # %bb.0:
; X64-SSE-NEXT:    cmpneqss {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; X64-SSE-NEXT:    movd %xmm0, %eax
; X64-SSE-NEXT:    andl $1, %eax
; X64-SSE-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X64-SSE-NEXT:    retq
;
; X64-AVX2-LABEL: fcmp_select_fp_constants:
; X64-AVX2:       # %bb.0:
; X64-AVX2-NEXT:    vcmpneqss {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; X64-AVX2-NEXT:    vmovss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; X64-AVX2-NEXT:    vmovss {{.*#+}} xmm2 = mem[0],zero,zero,zero
; X64-AVX2-NEXT:    vblendvps %xmm0, %xmm1, %xmm2, %xmm0
; X64-AVX2-NEXT:    retq
;
; X64-AVX512F-LABEL: fcmp_select_fp_constants:
; X64-AVX512F:       # %bb.0:
; X64-AVX512F-NEXT:    vcmpneqss {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %k1
; X64-AVX512F-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X64-AVX512F-NEXT:    vmovss {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0 {%k1}
; X64-AVX512F-NEXT:    retq
 %c = fcmp une float %x, -4.0
 %r = select i1 %c, float 42.0, float 23.0
 ret float %r
}

