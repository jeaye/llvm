; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown   -mattr=+sse2     | FileCheck %s --check-prefix=X32SSE --check-prefix=X32SSE2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse2     | FileCheck %s --check-prefix=X64SSE --check-prefix=X64SSE2
; RUN: llc < %s -mtriple=i686-unknown-unknown   -mattr=+sse4.1   | FileCheck %s --check-prefix=X32SSE --check-prefix=X32SSE4
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.1   | FileCheck %s --check-prefix=X64SSE --check-prefix=X64SSE4
; RUN: llc < %s -mtriple=i686-unknown-unknown   -mattr=+avx2     | FileCheck %s --check-prefix=X32AVX --check-prefix=X32AVX2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2     | FileCheck %s --check-prefix=X64AVX --check-prefix=X64AVX2
; RUN: llc < %s -mtriple=i686-unknown-unknown   -mattr=+avx512f  | FileCheck %s --check-prefix=X32AVX --check-prefix=X32AVX512F
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f  | FileCheck %s --check-prefix=X64AVX --check-prefix=X64AVX512F

define <16 x i8> @elt0_v16i8(i8 %x) {
; X32SSE2-LABEL: elt0_v16i8:
; X32SSE2:       # BB#0:
; X32SSE2-NEXT:    movl $15, %eax
; X32SSE2-NEXT:    movd %eax, %xmm0
; X32SSE2-NEXT:    movl $14, %eax
; X32SSE2-NEXT:    movd %eax, %xmm1
; X32SSE2-NEXT:    punpcklbw {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1],xmm1[2],xmm0[2],xmm1[3],xmm0[3],xmm1[4],xmm0[4],xmm1[5],xmm0[5],xmm1[6],xmm0[6],xmm1[7],xmm0[7]
; X32SSE2-NEXT:    movl $13, %eax
; X32SSE2-NEXT:    movd %eax, %xmm0
; X32SSE2-NEXT:    movl $12, %eax
; X32SSE2-NEXT:    movd %eax, %xmm2
; X32SSE2-NEXT:    punpcklbw {{.*#+}} xmm2 = xmm2[0],xmm0[0],xmm2[1],xmm0[1],xmm2[2],xmm0[2],xmm2[3],xmm0[3],xmm2[4],xmm0[4],xmm2[5],xmm0[5],xmm2[6],xmm0[6],xmm2[7],xmm0[7]
; X32SSE2-NEXT:    punpcklwd {{.*#+}} xmm2 = xmm2[0],xmm1[0],xmm2[1],xmm1[1],xmm2[2],xmm1[2],xmm2[3],xmm1[3]
; X32SSE2-NEXT:    movl $11, %eax
; X32SSE2-NEXT:    movd %eax, %xmm0
; X32SSE2-NEXT:    movl $10, %eax
; X32SSE2-NEXT:    movd %eax, %xmm3
; X32SSE2-NEXT:    punpcklbw {{.*#+}} xmm3 = xmm3[0],xmm0[0],xmm3[1],xmm0[1],xmm3[2],xmm0[2],xmm3[3],xmm0[3],xmm3[4],xmm0[4],xmm3[5],xmm0[5],xmm3[6],xmm0[6],xmm3[7],xmm0[7]
; X32SSE2-NEXT:    movl $9, %eax
; X32SSE2-NEXT:    movd %eax, %xmm0
; X32SSE2-NEXT:    movl $8, %eax
; X32SSE2-NEXT:    movd %eax, %xmm1
; X32SSE2-NEXT:    punpcklbw {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1],xmm1[2],xmm0[2],xmm1[3],xmm0[3],xmm1[4],xmm0[4],xmm1[5],xmm0[5],xmm1[6],xmm0[6],xmm1[7],xmm0[7]
; X32SSE2-NEXT:    punpcklwd {{.*#+}} xmm1 = xmm1[0],xmm3[0],xmm1[1],xmm3[1],xmm1[2],xmm3[2],xmm1[3],xmm3[3]
; X32SSE2-NEXT:    punpckldq {{.*#+}} xmm1 = xmm1[0],xmm2[0],xmm1[1],xmm2[1]
; X32SSE2-NEXT:    movl $7, %eax
; X32SSE2-NEXT:    movd %eax, %xmm0
; X32SSE2-NEXT:    movl $6, %eax
; X32SSE2-NEXT:    movd %eax, %xmm2
; X32SSE2-NEXT:    punpcklbw {{.*#+}} xmm2 = xmm2[0],xmm0[0],xmm2[1],xmm0[1],xmm2[2],xmm0[2],xmm2[3],xmm0[3],xmm2[4],xmm0[4],xmm2[5],xmm0[5],xmm2[6],xmm0[6],xmm2[7],xmm0[7]
; X32SSE2-NEXT:    movl $5, %eax
; X32SSE2-NEXT:    movd %eax, %xmm0
; X32SSE2-NEXT:    movl $4, %eax
; X32SSE2-NEXT:    movd %eax, %xmm3
; X32SSE2-NEXT:    punpcklbw {{.*#+}} xmm3 = xmm3[0],xmm0[0],xmm3[1],xmm0[1],xmm3[2],xmm0[2],xmm3[3],xmm0[3],xmm3[4],xmm0[4],xmm3[5],xmm0[5],xmm3[6],xmm0[6],xmm3[7],xmm0[7]
; X32SSE2-NEXT:    punpcklwd {{.*#+}} xmm3 = xmm3[0],xmm2[0],xmm3[1],xmm2[1],xmm3[2],xmm2[2],xmm3[3],xmm2[3]
; X32SSE2-NEXT:    movl $3, %eax
; X32SSE2-NEXT:    movd %eax, %xmm0
; X32SSE2-NEXT:    movl $2, %eax
; X32SSE2-NEXT:    movd %eax, %xmm2
; X32SSE2-NEXT:    punpcklbw {{.*#+}} xmm2 = xmm2[0],xmm0[0],xmm2[1],xmm0[1],xmm2[2],xmm0[2],xmm2[3],xmm0[3],xmm2[4],xmm0[4],xmm2[5],xmm0[5],xmm2[6],xmm0[6],xmm2[7],xmm0[7]
; X32SSE2-NEXT:    movl $1, %eax
; X32SSE2-NEXT:    movd %eax, %xmm4
; X32SSE2-NEXT:    movd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X32SSE2-NEXT:    punpcklbw {{.*#+}} xmm0 = xmm0[0],xmm4[0],xmm0[1],xmm4[1],xmm0[2],xmm4[2],xmm0[3],xmm4[3],xmm0[4],xmm4[4],xmm0[5],xmm4[5],xmm0[6],xmm4[6],xmm0[7],xmm4[7]
; X32SSE2-NEXT:    punpcklwd {{.*#+}} xmm0 = xmm0[0],xmm2[0],xmm0[1],xmm2[1],xmm0[2],xmm2[2],xmm0[3],xmm2[3]
; X32SSE2-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm3[0],xmm0[1],xmm3[1]
; X32SSE2-NEXT:    punpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; X32SSE2-NEXT:    retl
;
; X64SSE2-LABEL: elt0_v16i8:
; X64SSE2:       # BB#0:
; X64SSE2-NEXT:    movl $15, %eax
; X64SSE2-NEXT:    movd %eax, %xmm0
; X64SSE2-NEXT:    movl $14, %eax
; X64SSE2-NEXT:    movd %eax, %xmm1
; X64SSE2-NEXT:    punpcklbw {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1],xmm1[2],xmm0[2],xmm1[3],xmm0[3],xmm1[4],xmm0[4],xmm1[5],xmm0[5],xmm1[6],xmm0[6],xmm1[7],xmm0[7]
; X64SSE2-NEXT:    movl $13, %eax
; X64SSE2-NEXT:    movd %eax, %xmm0
; X64SSE2-NEXT:    movl $12, %eax
; X64SSE2-NEXT:    movd %eax, %xmm2
; X64SSE2-NEXT:    punpcklbw {{.*#+}} xmm2 = xmm2[0],xmm0[0],xmm2[1],xmm0[1],xmm2[2],xmm0[2],xmm2[3],xmm0[3],xmm2[4],xmm0[4],xmm2[5],xmm0[5],xmm2[6],xmm0[6],xmm2[7],xmm0[7]
; X64SSE2-NEXT:    punpcklwd {{.*#+}} xmm2 = xmm2[0],xmm1[0],xmm2[1],xmm1[1],xmm2[2],xmm1[2],xmm2[3],xmm1[3]
; X64SSE2-NEXT:    movl $11, %eax
; X64SSE2-NEXT:    movd %eax, %xmm0
; X64SSE2-NEXT:    movl $10, %eax
; X64SSE2-NEXT:    movd %eax, %xmm3
; X64SSE2-NEXT:    punpcklbw {{.*#+}} xmm3 = xmm3[0],xmm0[0],xmm3[1],xmm0[1],xmm3[2],xmm0[2],xmm3[3],xmm0[3],xmm3[4],xmm0[4],xmm3[5],xmm0[5],xmm3[6],xmm0[6],xmm3[7],xmm0[7]
; X64SSE2-NEXT:    movl $9, %eax
; X64SSE2-NEXT:    movd %eax, %xmm0
; X64SSE2-NEXT:    movl $8, %eax
; X64SSE2-NEXT:    movd %eax, %xmm1
; X64SSE2-NEXT:    punpcklbw {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1],xmm1[2],xmm0[2],xmm1[3],xmm0[3],xmm1[4],xmm0[4],xmm1[5],xmm0[5],xmm1[6],xmm0[6],xmm1[7],xmm0[7]
; X64SSE2-NEXT:    punpcklwd {{.*#+}} xmm1 = xmm1[0],xmm3[0],xmm1[1],xmm3[1],xmm1[2],xmm3[2],xmm1[3],xmm3[3]
; X64SSE2-NEXT:    punpckldq {{.*#+}} xmm1 = xmm1[0],xmm2[0],xmm1[1],xmm2[1]
; X64SSE2-NEXT:    movl $7, %eax
; X64SSE2-NEXT:    movd %eax, %xmm0
; X64SSE2-NEXT:    movl $6, %eax
; X64SSE2-NEXT:    movd %eax, %xmm2
; X64SSE2-NEXT:    punpcklbw {{.*#+}} xmm2 = xmm2[0],xmm0[0],xmm2[1],xmm0[1],xmm2[2],xmm0[2],xmm2[3],xmm0[3],xmm2[4],xmm0[4],xmm2[5],xmm0[5],xmm2[6],xmm0[6],xmm2[7],xmm0[7]
; X64SSE2-NEXT:    movl $5, %eax
; X64SSE2-NEXT:    movd %eax, %xmm0
; X64SSE2-NEXT:    movl $4, %eax
; X64SSE2-NEXT:    movd %eax, %xmm3
; X64SSE2-NEXT:    punpcklbw {{.*#+}} xmm3 = xmm3[0],xmm0[0],xmm3[1],xmm0[1],xmm3[2],xmm0[2],xmm3[3],xmm0[3],xmm3[4],xmm0[4],xmm3[5],xmm0[5],xmm3[6],xmm0[6],xmm3[7],xmm0[7]
; X64SSE2-NEXT:    punpcklwd {{.*#+}} xmm3 = xmm3[0],xmm2[0],xmm3[1],xmm2[1],xmm3[2],xmm2[2],xmm3[3],xmm2[3]
; X64SSE2-NEXT:    movl $3, %eax
; X64SSE2-NEXT:    movd %eax, %xmm0
; X64SSE2-NEXT:    movl $2, %eax
; X64SSE2-NEXT:    movd %eax, %xmm2
; X64SSE2-NEXT:    punpcklbw {{.*#+}} xmm2 = xmm2[0],xmm0[0],xmm2[1],xmm0[1],xmm2[2],xmm0[2],xmm2[3],xmm0[3],xmm2[4],xmm0[4],xmm2[5],xmm0[5],xmm2[6],xmm0[6],xmm2[7],xmm0[7]
; X64SSE2-NEXT:    movl $1, %eax
; X64SSE2-NEXT:    movd %eax, %xmm4
; X64SSE2-NEXT:    movd %edi, %xmm0
; X64SSE2-NEXT:    punpcklbw {{.*#+}} xmm0 = xmm0[0],xmm4[0],xmm0[1],xmm4[1],xmm0[2],xmm4[2],xmm0[3],xmm4[3],xmm0[4],xmm4[4],xmm0[5],xmm4[5],xmm0[6],xmm4[6],xmm0[7],xmm4[7]
; X64SSE2-NEXT:    punpcklwd {{.*#+}} xmm0 = xmm0[0],xmm2[0],xmm0[1],xmm2[1],xmm0[2],xmm2[2],xmm0[3],xmm2[3]
; X64SSE2-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm3[0],xmm0[1],xmm3[1]
; X64SSE2-NEXT:    punpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; X64SSE2-NEXT:    retq
;
; X32SSE4-LABEL: elt0_v16i8:
; X32SSE4:       # BB#0:
; X32SSE4-NEXT:    movd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X32SSE4-NEXT:    movl $1, %eax
; X32SSE4-NEXT:    pinsrb $1, %eax, %xmm0
; X32SSE4-NEXT:    movl $2, %eax
; X32SSE4-NEXT:    pinsrb $2, %eax, %xmm0
; X32SSE4-NEXT:    movl $3, %eax
; X32SSE4-NEXT:    pinsrb $3, %eax, %xmm0
; X32SSE4-NEXT:    movl $4, %eax
; X32SSE4-NEXT:    pinsrb $4, %eax, %xmm0
; X32SSE4-NEXT:    movl $5, %eax
; X32SSE4-NEXT:    pinsrb $5, %eax, %xmm0
; X32SSE4-NEXT:    movl $6, %eax
; X32SSE4-NEXT:    pinsrb $6, %eax, %xmm0
; X32SSE4-NEXT:    movl $7, %eax
; X32SSE4-NEXT:    pinsrb $7, %eax, %xmm0
; X32SSE4-NEXT:    movl $8, %eax
; X32SSE4-NEXT:    pinsrb $8, %eax, %xmm0
; X32SSE4-NEXT:    movl $9, %eax
; X32SSE4-NEXT:    pinsrb $9, %eax, %xmm0
; X32SSE4-NEXT:    movl $10, %eax
; X32SSE4-NEXT:    pinsrb $10, %eax, %xmm0
; X32SSE4-NEXT:    movl $11, %eax
; X32SSE4-NEXT:    pinsrb $11, %eax, %xmm0
; X32SSE4-NEXT:    movl $12, %eax
; X32SSE4-NEXT:    pinsrb $12, %eax, %xmm0
; X32SSE4-NEXT:    movl $13, %eax
; X32SSE4-NEXT:    pinsrb $13, %eax, %xmm0
; X32SSE4-NEXT:    movl $14, %eax
; X32SSE4-NEXT:    pinsrb $14, %eax, %xmm0
; X32SSE4-NEXT:    movl $15, %eax
; X32SSE4-NEXT:    pinsrb $15, %eax, %xmm0
; X32SSE4-NEXT:    retl
;
; X64SSE4-LABEL: elt0_v16i8:
; X64SSE4:       # BB#0:
; X64SSE4-NEXT:    movd %edi, %xmm0
; X64SSE4-NEXT:    movl $1, %eax
; X64SSE4-NEXT:    pinsrb $1, %eax, %xmm0
; X64SSE4-NEXT:    movl $2, %eax
; X64SSE4-NEXT:    pinsrb $2, %eax, %xmm0
; X64SSE4-NEXT:    movl $3, %eax
; X64SSE4-NEXT:    pinsrb $3, %eax, %xmm0
; X64SSE4-NEXT:    movl $4, %eax
; X64SSE4-NEXT:    pinsrb $4, %eax, %xmm0
; X64SSE4-NEXT:    movl $5, %eax
; X64SSE4-NEXT:    pinsrb $5, %eax, %xmm0
; X64SSE4-NEXT:    movl $6, %eax
; X64SSE4-NEXT:    pinsrb $6, %eax, %xmm0
; X64SSE4-NEXT:    movl $7, %eax
; X64SSE4-NEXT:    pinsrb $7, %eax, %xmm0
; X64SSE4-NEXT:    movl $8, %eax
; X64SSE4-NEXT:    pinsrb $8, %eax, %xmm0
; X64SSE4-NEXT:    movl $9, %eax
; X64SSE4-NEXT:    pinsrb $9, %eax, %xmm0
; X64SSE4-NEXT:    movl $10, %eax
; X64SSE4-NEXT:    pinsrb $10, %eax, %xmm0
; X64SSE4-NEXT:    movl $11, %eax
; X64SSE4-NEXT:    pinsrb $11, %eax, %xmm0
; X64SSE4-NEXT:    movl $12, %eax
; X64SSE4-NEXT:    pinsrb $12, %eax, %xmm0
; X64SSE4-NEXT:    movl $13, %eax
; X64SSE4-NEXT:    pinsrb $13, %eax, %xmm0
; X64SSE4-NEXT:    movl $14, %eax
; X64SSE4-NEXT:    pinsrb $14, %eax, %xmm0
; X64SSE4-NEXT:    movl $15, %eax
; X64SSE4-NEXT:    pinsrb $15, %eax, %xmm0
; X64SSE4-NEXT:    retq
;
; X32AVX-LABEL: elt0_v16i8:
; X32AVX:       # BB#0:
; X32AVX-NEXT:    vmovd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X32AVX-NEXT:    movl $1, %eax
; X32AVX-NEXT:    vpinsrb $1, %eax, %xmm0, %xmm0
; X32AVX-NEXT:    movl $2, %eax
; X32AVX-NEXT:    vpinsrb $2, %eax, %xmm0, %xmm0
; X32AVX-NEXT:    movl $3, %eax
; X32AVX-NEXT:    vpinsrb $3, %eax, %xmm0, %xmm0
; X32AVX-NEXT:    movl $4, %eax
; X32AVX-NEXT:    vpinsrb $4, %eax, %xmm0, %xmm0
; X32AVX-NEXT:    movl $5, %eax
; X32AVX-NEXT:    vpinsrb $5, %eax, %xmm0, %xmm0
; X32AVX-NEXT:    movl $6, %eax
; X32AVX-NEXT:    vpinsrb $6, %eax, %xmm0, %xmm0
; X32AVX-NEXT:    movl $7, %eax
; X32AVX-NEXT:    vpinsrb $7, %eax, %xmm0, %xmm0
; X32AVX-NEXT:    movl $8, %eax
; X32AVX-NEXT:    vpinsrb $8, %eax, %xmm0, %xmm0
; X32AVX-NEXT:    movl $9, %eax
; X32AVX-NEXT:    vpinsrb $9, %eax, %xmm0, %xmm0
; X32AVX-NEXT:    movl $10, %eax
; X32AVX-NEXT:    vpinsrb $10, %eax, %xmm0, %xmm0
; X32AVX-NEXT:    movl $11, %eax
; X32AVX-NEXT:    vpinsrb $11, %eax, %xmm0, %xmm0
; X32AVX-NEXT:    movl $12, %eax
; X32AVX-NEXT:    vpinsrb $12, %eax, %xmm0, %xmm0
; X32AVX-NEXT:    movl $13, %eax
; X32AVX-NEXT:    vpinsrb $13, %eax, %xmm0, %xmm0
; X32AVX-NEXT:    movl $14, %eax
; X32AVX-NEXT:    vpinsrb $14, %eax, %xmm0, %xmm0
; X32AVX-NEXT:    movl $15, %eax
; X32AVX-NEXT:    vpinsrb $15, %eax, %xmm0, %xmm0
; X32AVX-NEXT:    retl
;
; X64AVX-LABEL: elt0_v16i8:
; X64AVX:       # BB#0:
; X64AVX-NEXT:    vmovd %edi, %xmm0
; X64AVX-NEXT:    movl $1, %eax
; X64AVX-NEXT:    vpinsrb $1, %eax, %xmm0, %xmm0
; X64AVX-NEXT:    movl $2, %eax
; X64AVX-NEXT:    vpinsrb $2, %eax, %xmm0, %xmm0
; X64AVX-NEXT:    movl $3, %eax
; X64AVX-NEXT:    vpinsrb $3, %eax, %xmm0, %xmm0
; X64AVX-NEXT:    movl $4, %eax
; X64AVX-NEXT:    vpinsrb $4, %eax, %xmm0, %xmm0
; X64AVX-NEXT:    movl $5, %eax
; X64AVX-NEXT:    vpinsrb $5, %eax, %xmm0, %xmm0
; X64AVX-NEXT:    movl $6, %eax
; X64AVX-NEXT:    vpinsrb $6, %eax, %xmm0, %xmm0
; X64AVX-NEXT:    movl $7, %eax
; X64AVX-NEXT:    vpinsrb $7, %eax, %xmm0, %xmm0
; X64AVX-NEXT:    movl $8, %eax
; X64AVX-NEXT:    vpinsrb $8, %eax, %xmm0, %xmm0
; X64AVX-NEXT:    movl $9, %eax
; X64AVX-NEXT:    vpinsrb $9, %eax, %xmm0, %xmm0
; X64AVX-NEXT:    movl $10, %eax
; X64AVX-NEXT:    vpinsrb $10, %eax, %xmm0, %xmm0
; X64AVX-NEXT:    movl $11, %eax
; X64AVX-NEXT:    vpinsrb $11, %eax, %xmm0, %xmm0
; X64AVX-NEXT:    movl $12, %eax
; X64AVX-NEXT:    vpinsrb $12, %eax, %xmm0, %xmm0
; X64AVX-NEXT:    movl $13, %eax
; X64AVX-NEXT:    vpinsrb $13, %eax, %xmm0, %xmm0
; X64AVX-NEXT:    movl $14, %eax
; X64AVX-NEXT:    vpinsrb $14, %eax, %xmm0, %xmm0
; X64AVX-NEXT:    movl $15, %eax
; X64AVX-NEXT:    vpinsrb $15, %eax, %xmm0, %xmm0
; X64AVX-NEXT:    retq
   %ins = insertelement <16 x i8> <i8 42, i8 1, i8 2, i8 3, i8 4, i8 5, i8 6, i8 7, i8 8, i8 9, i8 10, i8 11, i8 12, i8 13, i8 14, i8 15>, i8 %x, i32 0
   ret <16 x i8> %ins
}

define <8 x i16> @elt5_v8i16(i16 %x) {
; X32SSE2-LABEL: elt5_v8i16:
; X32SSE2:       # BB#0:
; X32SSE2-NEXT:    movl $7, %eax
; X32SSE2-NEXT:    movd %eax, %xmm0
; X32SSE2-NEXT:    movl $6, %eax
; X32SSE2-NEXT:    movd %eax, %xmm1
; X32SSE2-NEXT:    punpcklwd {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1],xmm1[2],xmm0[2],xmm1[3],xmm0[3]
; X32SSE2-NEXT:    movl $4, %eax
; X32SSE2-NEXT:    movd %eax, %xmm2
; X32SSE2-NEXT:    movd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X32SSE2-NEXT:    punpcklwd {{.*#+}} xmm2 = xmm2[0],xmm0[0],xmm2[1],xmm0[1],xmm2[2],xmm0[2],xmm2[3],xmm0[3]
; X32SSE2-NEXT:    punpckldq {{.*#+}} xmm2 = xmm2[0],xmm1[0],xmm2[1],xmm1[1]
; X32SSE2-NEXT:    movl $3, %eax
; X32SSE2-NEXT:    movd %eax, %xmm0
; X32SSE2-NEXT:    movl $2, %eax
; X32SSE2-NEXT:    movd %eax, %xmm1
; X32SSE2-NEXT:    punpcklwd {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1],xmm1[2],xmm0[2],xmm1[3],xmm0[3]
; X32SSE2-NEXT:    movl $1, %eax
; X32SSE2-NEXT:    movd %eax, %xmm3
; X32SSE2-NEXT:    movl $42, %eax
; X32SSE2-NEXT:    movd %eax, %xmm0
; X32SSE2-NEXT:    punpcklwd {{.*#+}} xmm0 = xmm0[0],xmm3[0],xmm0[1],xmm3[1],xmm0[2],xmm3[2],xmm0[3],xmm3[3]
; X32SSE2-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1]
; X32SSE2-NEXT:    punpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm2[0]
; X32SSE2-NEXT:    retl
;
; X64SSE2-LABEL: elt5_v8i16:
; X64SSE2:       # BB#0:
; X64SSE2-NEXT:    movl $7, %eax
; X64SSE2-NEXT:    movd %eax, %xmm0
; X64SSE2-NEXT:    movl $6, %eax
; X64SSE2-NEXT:    movd %eax, %xmm1
; X64SSE2-NEXT:    punpcklwd {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1],xmm1[2],xmm0[2],xmm1[3],xmm0[3]
; X64SSE2-NEXT:    movd %edi, %xmm0
; X64SSE2-NEXT:    movl $4, %eax
; X64SSE2-NEXT:    movd %eax, %xmm2
; X64SSE2-NEXT:    punpcklwd {{.*#+}} xmm2 = xmm2[0],xmm0[0],xmm2[1],xmm0[1],xmm2[2],xmm0[2],xmm2[3],xmm0[3]
; X64SSE2-NEXT:    punpckldq {{.*#+}} xmm2 = xmm2[0],xmm1[0],xmm2[1],xmm1[1]
; X64SSE2-NEXT:    movl $3, %eax
; X64SSE2-NEXT:    movd %eax, %xmm0
; X64SSE2-NEXT:    movl $2, %eax
; X64SSE2-NEXT:    movd %eax, %xmm1
; X64SSE2-NEXT:    punpcklwd {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1],xmm1[2],xmm0[2],xmm1[3],xmm0[3]
; X64SSE2-NEXT:    movl $1, %eax
; X64SSE2-NEXT:    movd %eax, %xmm3
; X64SSE2-NEXT:    movl $42, %eax
; X64SSE2-NEXT:    movd %eax, %xmm0
; X64SSE2-NEXT:    punpcklwd {{.*#+}} xmm0 = xmm0[0],xmm3[0],xmm0[1],xmm3[1],xmm0[2],xmm3[2],xmm0[3],xmm3[3]
; X64SSE2-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1]
; X64SSE2-NEXT:    punpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm2[0]
; X64SSE2-NEXT:    retq
;
; X32SSE4-LABEL: elt5_v8i16:
; X32SSE4:       # BB#0:
; X32SSE4-NEXT:    movl $42, %eax
; X32SSE4-NEXT:    movd %eax, %xmm0
; X32SSE4-NEXT:    movl $1, %eax
; X32SSE4-NEXT:    pinsrw $1, %eax, %xmm0
; X32SSE4-NEXT:    movl $2, %eax
; X32SSE4-NEXT:    pinsrw $2, %eax, %xmm0
; X32SSE4-NEXT:    movl $3, %eax
; X32SSE4-NEXT:    pinsrw $3, %eax, %xmm0
; X32SSE4-NEXT:    movl $4, %eax
; X32SSE4-NEXT:    pinsrw $4, %eax, %xmm0
; X32SSE4-NEXT:    pinsrw $5, {{[0-9]+}}(%esp), %xmm0
; X32SSE4-NEXT:    movl $6, %eax
; X32SSE4-NEXT:    pinsrw $6, %eax, %xmm0
; X32SSE4-NEXT:    movl $7, %eax
; X32SSE4-NEXT:    pinsrw $7, %eax, %xmm0
; X32SSE4-NEXT:    retl
;
; X64SSE4-LABEL: elt5_v8i16:
; X64SSE4:       # BB#0:
; X64SSE4-NEXT:    movl $42, %eax
; X64SSE4-NEXT:    movd %eax, %xmm0
; X64SSE4-NEXT:    movl $1, %eax
; X64SSE4-NEXT:    pinsrw $1, %eax, %xmm0
; X64SSE4-NEXT:    movl $2, %eax
; X64SSE4-NEXT:    pinsrw $2, %eax, %xmm0
; X64SSE4-NEXT:    movl $3, %eax
; X64SSE4-NEXT:    pinsrw $3, %eax, %xmm0
; X64SSE4-NEXT:    movl $4, %eax
; X64SSE4-NEXT:    pinsrw $4, %eax, %xmm0
; X64SSE4-NEXT:    pinsrw $5, %edi, %xmm0
; X64SSE4-NEXT:    movl $6, %eax
; X64SSE4-NEXT:    pinsrw $6, %eax, %xmm0
; X64SSE4-NEXT:    movl $7, %eax
; X64SSE4-NEXT:    pinsrw $7, %eax, %xmm0
; X64SSE4-NEXT:    retq
;
; X32AVX-LABEL: elt5_v8i16:
; X32AVX:       # BB#0:
; X32AVX-NEXT:    movl $42, %eax
; X32AVX-NEXT:    vmovd %eax, %xmm0
; X32AVX-NEXT:    movl $1, %eax
; X32AVX-NEXT:    vpinsrw $1, %eax, %xmm0, %xmm0
; X32AVX-NEXT:    movl $2, %eax
; X32AVX-NEXT:    vpinsrw $2, %eax, %xmm0, %xmm0
; X32AVX-NEXT:    movl $3, %eax
; X32AVX-NEXT:    vpinsrw $3, %eax, %xmm0, %xmm0
; X32AVX-NEXT:    movl $4, %eax
; X32AVX-NEXT:    vpinsrw $4, %eax, %xmm0, %xmm0
; X32AVX-NEXT:    vpinsrw $5, {{[0-9]+}}(%esp), %xmm0, %xmm0
; X32AVX-NEXT:    movl $6, %eax
; X32AVX-NEXT:    vpinsrw $6, %eax, %xmm0, %xmm0
; X32AVX-NEXT:    movl $7, %eax
; X32AVX-NEXT:    vpinsrw $7, %eax, %xmm0, %xmm0
; X32AVX-NEXT:    retl
;
; X64AVX-LABEL: elt5_v8i16:
; X64AVX:       # BB#0:
; X64AVX-NEXT:    movl $42, %eax
; X64AVX-NEXT:    vmovd %eax, %xmm0
; X64AVX-NEXT:    movl $1, %eax
; X64AVX-NEXT:    vpinsrw $1, %eax, %xmm0, %xmm0
; X64AVX-NEXT:    movl $2, %eax
; X64AVX-NEXT:    vpinsrw $2, %eax, %xmm0, %xmm0
; X64AVX-NEXT:    movl $3, %eax
; X64AVX-NEXT:    vpinsrw $3, %eax, %xmm0, %xmm0
; X64AVX-NEXT:    movl $4, %eax
; X64AVX-NEXT:    vpinsrw $4, %eax, %xmm0, %xmm0
; X64AVX-NEXT:    vpinsrw $5, %edi, %xmm0, %xmm0
; X64AVX-NEXT:    movl $6, %eax
; X64AVX-NEXT:    vpinsrw $6, %eax, %xmm0, %xmm0
; X64AVX-NEXT:    movl $7, %eax
; X64AVX-NEXT:    vpinsrw $7, %eax, %xmm0, %xmm0
; X64AVX-NEXT:    retq
   %ins = insertelement <8 x i16> <i16 42, i16 1, i16 2, i16 3, i16 4, i16 5, i16 6, i16 7>, i16 %x, i32 5
   ret <8 x i16> %ins
}

define <4 x i32> @elt3_v4i32(i32 %x) {
; X32SSE2-LABEL: elt3_v4i32:
; X32SSE2:       # BB#0:
; X32SSE2-NEXT:    movl $2, %eax
; X32SSE2-NEXT:    movd %eax, %xmm1
; X32SSE2-NEXT:    movd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X32SSE2-NEXT:    punpckldq {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1]
; X32SSE2-NEXT:    movl $1, %eax
; X32SSE2-NEXT:    movd %eax, %xmm2
; X32SSE2-NEXT:    movl $42, %eax
; X32SSE2-NEXT:    movd %eax, %xmm0
; X32SSE2-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm2[0],xmm0[1],xmm2[1]
; X32SSE2-NEXT:    punpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; X32SSE2-NEXT:    retl
;
; X64SSE2-LABEL: elt3_v4i32:
; X64SSE2:       # BB#0:
; X64SSE2-NEXT:    movd %edi, %xmm0
; X64SSE2-NEXT:    movl $2, %eax
; X64SSE2-NEXT:    movd %eax, %xmm1
; X64SSE2-NEXT:    punpckldq {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1]
; X64SSE2-NEXT:    movl $1, %eax
; X64SSE2-NEXT:    movd %eax, %xmm2
; X64SSE2-NEXT:    movl $42, %eax
; X64SSE2-NEXT:    movd %eax, %xmm0
; X64SSE2-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm2[0],xmm0[1],xmm2[1]
; X64SSE2-NEXT:    punpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; X64SSE2-NEXT:    retq
;
; X32SSE4-LABEL: elt3_v4i32:
; X32SSE4:       # BB#0:
; X32SSE4-NEXT:    movl $42, %eax
; X32SSE4-NEXT:    movd %eax, %xmm0
; X32SSE4-NEXT:    movl $1, %eax
; X32SSE4-NEXT:    pinsrd $1, %eax, %xmm0
; X32SSE4-NEXT:    movl $2, %eax
; X32SSE4-NEXT:    pinsrd $2, %eax, %xmm0
; X32SSE4-NEXT:    pinsrd $3, {{[0-9]+}}(%esp), %xmm0
; X32SSE4-NEXT:    retl
;
; X64SSE4-LABEL: elt3_v4i32:
; X64SSE4:       # BB#0:
; X64SSE4-NEXT:    movl $42, %eax
; X64SSE4-NEXT:    movd %eax, %xmm0
; X64SSE4-NEXT:    movl $1, %eax
; X64SSE4-NEXT:    pinsrd $1, %eax, %xmm0
; X64SSE4-NEXT:    movl $2, %eax
; X64SSE4-NEXT:    pinsrd $2, %eax, %xmm0
; X64SSE4-NEXT:    pinsrd $3, %edi, %xmm0
; X64SSE4-NEXT:    retq
;
; X32AVX-LABEL: elt3_v4i32:
; X32AVX:       # BB#0:
; X32AVX-NEXT:    movl $42, %eax
; X32AVX-NEXT:    vmovd %eax, %xmm0
; X32AVX-NEXT:    movl $1, %eax
; X32AVX-NEXT:    vpinsrd $1, %eax, %xmm0, %xmm0
; X32AVX-NEXT:    movl $2, %eax
; X32AVX-NEXT:    vpinsrd $2, %eax, %xmm0, %xmm0
; X32AVX-NEXT:    vpinsrd $3, {{[0-9]+}}(%esp), %xmm0, %xmm0
; X32AVX-NEXT:    retl
;
; X64AVX-LABEL: elt3_v4i32:
; X64AVX:       # BB#0:
; X64AVX-NEXT:    movl $42, %eax
; X64AVX-NEXT:    vmovd %eax, %xmm0
; X64AVX-NEXT:    movl $1, %eax
; X64AVX-NEXT:    vpinsrd $1, %eax, %xmm0, %xmm0
; X64AVX-NEXT:    movl $2, %eax
; X64AVX-NEXT:    vpinsrd $2, %eax, %xmm0, %xmm0
; X64AVX-NEXT:    vpinsrd $3, %edi, %xmm0, %xmm0
; X64AVX-NEXT:    retq
   %ins = insertelement <4 x i32> <i32 42, i32 1, i32 2, i32 3>, i32 %x, i32 3
   ret <4 x i32> %ins
}

define <2 x i64> @elt0_v2i64(i64 %x) {
; X32SSE-LABEL: elt0_v2i64:
; X32SSE:       # BB#0:
; X32SSE-NEXT:    movl $1, %eax
; X32SSE-NEXT:    movd %eax, %xmm1
; X32SSE-NEXT:    movq {{.*#+}} xmm0 = mem[0],zero
; X32SSE-NEXT:    punpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; X32SSE-NEXT:    retl
;
; X64SSE-LABEL: elt0_v2i64:
; X64SSE:       # BB#0:
; X64SSE-NEXT:    movq %rdi, %xmm0
; X64SSE-NEXT:    movl $1, %eax
; X64SSE-NEXT:    movq %rax, %xmm1
; X64SSE-NEXT:    punpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; X64SSE-NEXT:    retq
;
; X32AVX-LABEL: elt0_v2i64:
; X32AVX:       # BB#0:
; X32AVX-NEXT:    movl $1, %eax
; X32AVX-NEXT:    vmovd %eax, %xmm0
; X32AVX-NEXT:    vmovq {{.*#+}} xmm1 = mem[0],zero
; X32AVX-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm1[0],xmm0[0]
; X32AVX-NEXT:    retl
;
; X64AVX-LABEL: elt0_v2i64:
; X64AVX:       # BB#0:
; X64AVX-NEXT:    vmovq %rdi, %xmm0
; X64AVX-NEXT:    movl $1, %eax
; X64AVX-NEXT:    vmovq %rax, %xmm1
; X64AVX-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; X64AVX-NEXT:    retq
   %ins = insertelement <2 x i64> <i64 42, i64 1>, i64 %x, i32 0
   ret <2 x i64> %ins
}

define <4 x float> @elt1_v4f32(float %x) {
; X32SSE2-LABEL: elt1_v4f32:
; X32SSE2:       # BB#0:
; X32SSE2-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X32SSE2-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; X32SSE2-NEXT:    unpcklps {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1]
; X32SSE2-NEXT:    movss {{.*#+}} xmm2 = mem[0],zero,zero,zero
; X32SSE2-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X32SSE2-NEXT:    unpcklps {{.*#+}} xmm0 = xmm0[0],xmm2[0],xmm0[1],xmm2[1]
; X32SSE2-NEXT:    movlhps {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; X32SSE2-NEXT:    retl
;
; X64SSE2-LABEL: elt1_v4f32:
; X64SSE2:       # BB#0:
; X64SSE2-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; X64SSE2-NEXT:    movss {{.*#+}} xmm2 = mem[0],zero,zero,zero
; X64SSE2-NEXT:    unpcklps {{.*#+}} xmm2 = xmm2[0],xmm1[0],xmm2[1],xmm1[1]
; X64SSE2-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; X64SSE2-NEXT:    unpcklps {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1]
; X64SSE2-NEXT:    movlhps {{.*#+}} xmm1 = xmm1[0],xmm2[0]
; X64SSE2-NEXT:    movaps %xmm1, %xmm0
; X64SSE2-NEXT:    retq
;
; X32SSE4-LABEL: elt1_v4f32:
; X32SSE4:       # BB#0:
; X32SSE4-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X32SSE4-NEXT:    insertps {{.*#+}} xmm0 = xmm0[0],mem[0],xmm0[2,3]
; X32SSE4-NEXT:    insertps {{.*#+}} xmm0 = xmm0[0,1],mem[0],xmm0[3]
; X32SSE4-NEXT:    insertps {{.*#+}} xmm0 = xmm0[0,1,2],mem[0]
; X32SSE4-NEXT:    retl
;
; X64SSE4-LABEL: elt1_v4f32:
; X64SSE4:       # BB#0:
; X64SSE4-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; X64SSE4-NEXT:    insertps {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[2,3]
; X64SSE4-NEXT:    insertps {{.*#+}} xmm1 = xmm1[0,1],mem[0],xmm1[3]
; X64SSE4-NEXT:    insertps {{.*#+}} xmm1 = xmm1[0,1,2],mem[0]
; X64SSE4-NEXT:    movaps %xmm1, %xmm0
; X64SSE4-NEXT:    retq
;
; X32AVX-LABEL: elt1_v4f32:
; X32AVX:       # BB#0:
; X32AVX-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X32AVX-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0],mem[0],xmm0[2,3]
; X32AVX-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0,1],mem[0],xmm0[3]
; X32AVX-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0,1,2],mem[0]
; X32AVX-NEXT:    retl
;
; X64AVX-LABEL: elt1_v4f32:
; X64AVX:       # BB#0:
; X64AVX-NEXT:    vmovss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; X64AVX-NEXT:    vinsertps {{.*#+}} xmm0 = xmm1[0],xmm0[0],xmm1[2,3]
; X64AVX-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0,1],mem[0],xmm0[3]
; X64AVX-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0,1,2],mem[0]
; X64AVX-NEXT:    retq
   %ins = insertelement <4 x float> <float 42.0, float 1.0, float 2.0, float 3.0>, float %x, i32 1
   ret <4 x float> %ins
}

define <2 x double> @elt1_v2f64(double %x) {
; X32SSE-LABEL: elt1_v2f64:
; X32SSE:       # BB#0:
; X32SSE-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; X32SSE-NEXT:    movhpd {{.*#+}} xmm0 = xmm0[0],mem[0]
; X32SSE-NEXT:    retl
;
; X64SSE-LABEL: elt1_v2f64:
; X64SSE:       # BB#0:
; X64SSE-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; X64SSE-NEXT:    movlhps {{.*#+}} xmm1 = xmm1[0],xmm0[0]
; X64SSE-NEXT:    movaps %xmm1, %xmm0
; X64SSE-NEXT:    retq
;
; X32AVX-LABEL: elt1_v2f64:
; X32AVX:       # BB#0:
; X32AVX-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; X32AVX-NEXT:    vmovhpd {{.*#+}} xmm0 = xmm0[0],mem[0]
; X32AVX-NEXT:    retl
;
; X64AVX-LABEL: elt1_v2f64:
; X64AVX:       # BB#0:
; X64AVX-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; X64AVX-NEXT:    vmovlhps {{.*#+}} xmm0 = xmm1[0],xmm0[0]
; X64AVX-NEXT:    retq
   %ins = insertelement <2 x double> <double 42.0, double 1.0>, double %x, i32 1
   ret <2 x double> %ins
}

define <8 x i32> @elt7_v8i32(i32 %x) {
; X32SSE2-LABEL: elt7_v8i32:
; X32SSE2:       # BB#0:
; X32SSE2-NEXT:    movl $6, %eax
; X32SSE2-NEXT:    movd %eax, %xmm0
; X32SSE2-NEXT:    movd {{.*#+}} xmm1 = mem[0],zero,zero,zero
; X32SSE2-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1]
; X32SSE2-NEXT:    movl $5, %eax
; X32SSE2-NEXT:    movd %eax, %xmm2
; X32SSE2-NEXT:    movl $4, %eax
; X32SSE2-NEXT:    movd %eax, %xmm1
; X32SSE2-NEXT:    punpckldq {{.*#+}} xmm1 = xmm1[0],xmm2[0],xmm1[1],xmm2[1]
; X32SSE2-NEXT:    punpcklqdq {{.*#+}} xmm1 = xmm1[0],xmm0[0]
; X32SSE2-NEXT:    movaps {{.*#+}} xmm0 = [42,1,2,3]
; X32SSE2-NEXT:    retl
;
; X64SSE2-LABEL: elt7_v8i32:
; X64SSE2:       # BB#0:
; X64SSE2-NEXT:    movd %edi, %xmm0
; X64SSE2-NEXT:    movl $6, %eax
; X64SSE2-NEXT:    movd %eax, %xmm2
; X64SSE2-NEXT:    punpckldq {{.*#+}} xmm2 = xmm2[0],xmm0[0],xmm2[1],xmm0[1]
; X64SSE2-NEXT:    movl $5, %eax
; X64SSE2-NEXT:    movd %eax, %xmm0
; X64SSE2-NEXT:    movl $4, %eax
; X64SSE2-NEXT:    movd %eax, %xmm1
; X64SSE2-NEXT:    punpckldq {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1]
; X64SSE2-NEXT:    punpcklqdq {{.*#+}} xmm1 = xmm1[0],xmm2[0]
; X64SSE2-NEXT:    movaps {{.*#+}} xmm0 = [42,1,2,3]
; X64SSE2-NEXT:    retq
;
; X32SSE4-LABEL: elt7_v8i32:
; X32SSE4:       # BB#0:
; X32SSE4-NEXT:    movl $4, %eax
; X32SSE4-NEXT:    movd %eax, %xmm1
; X32SSE4-NEXT:    movl $5, %eax
; X32SSE4-NEXT:    pinsrd $1, %eax, %xmm1
; X32SSE4-NEXT:    movl $6, %eax
; X32SSE4-NEXT:    pinsrd $2, %eax, %xmm1
; X32SSE4-NEXT:    pinsrd $3, {{[0-9]+}}(%esp), %xmm1
; X32SSE4-NEXT:    movaps {{.*#+}} xmm0 = [42,1,2,3]
; X32SSE4-NEXT:    retl
;
; X64SSE4-LABEL: elt7_v8i32:
; X64SSE4:       # BB#0:
; X64SSE4-NEXT:    movl $4, %eax
; X64SSE4-NEXT:    movd %eax, %xmm1
; X64SSE4-NEXT:    movl $5, %eax
; X64SSE4-NEXT:    pinsrd $1, %eax, %xmm1
; X64SSE4-NEXT:    movl $6, %eax
; X64SSE4-NEXT:    pinsrd $2, %eax, %xmm1
; X64SSE4-NEXT:    pinsrd $3, %edi, %xmm1
; X64SSE4-NEXT:    movaps {{.*#+}} xmm0 = [42,1,2,3]
; X64SSE4-NEXT:    retq
;
; X32AVX-LABEL: elt7_v8i32:
; X32AVX:       # BB#0:
; X32AVX-NEXT:    vmovdqa {{.*#+}} xmm0 = [42,1,2,3]
; X32AVX-NEXT:    movl $4, %eax
; X32AVX-NEXT:    vmovd %eax, %xmm1
; X32AVX-NEXT:    movl $5, %eax
; X32AVX-NEXT:    vpinsrd $1, %eax, %xmm1, %xmm1
; X32AVX-NEXT:    movl $6, %eax
; X32AVX-NEXT:    vpinsrd $2, %eax, %xmm1, %xmm1
; X32AVX-NEXT:    vpinsrd $3, {{[0-9]+}}(%esp), %xmm1, %xmm1
; X32AVX-NEXT:    vinserti128 $1, %xmm1, %ymm0, %ymm0
; X32AVX-NEXT:    retl
;
; X64AVX-LABEL: elt7_v8i32:
; X64AVX:       # BB#0:
; X64AVX-NEXT:    vmovdqa {{.*#+}} xmm0 = [42,1,2,3]
; X64AVX-NEXT:    movl $4, %eax
; X64AVX-NEXT:    vmovd %eax, %xmm1
; X64AVX-NEXT:    movl $5, %eax
; X64AVX-NEXT:    vpinsrd $1, %eax, %xmm1, %xmm1
; X64AVX-NEXT:    movl $6, %eax
; X64AVX-NEXT:    vpinsrd $2, %eax, %xmm1, %xmm1
; X64AVX-NEXT:    vpinsrd $3, %edi, %xmm1, %xmm1
; X64AVX-NEXT:    vinserti128 $1, %xmm1, %ymm0, %ymm0
; X64AVX-NEXT:    retq
   %ins = insertelement <8 x i32> <i32 42, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>, i32 %x, i32 7
   ret <8 x i32> %ins
}

define <8 x float> @elt6_v8f32(float %x) {
; X32SSE2-LABEL: elt6_v8f32:
; X32SSE2:       # BB#0:
; X32SSE2-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X32SSE2-NEXT:    movss {{.*#+}} xmm2 = mem[0],zero,zero,zero
; X32SSE2-NEXT:    unpcklps {{.*#+}} xmm2 = xmm2[0],xmm0[0],xmm2[1],xmm0[1]
; X32SSE2-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X32SSE2-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; X32SSE2-NEXT:    unpcklps {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1]
; X32SSE2-NEXT:    movlhps {{.*#+}} xmm1 = xmm1[0],xmm2[0]
; X32SSE2-NEXT:    movaps {{.*#+}} xmm0 = [4.200000e+01,1.000000e+00,2.000000e+00,3.000000e+00]
; X32SSE2-NEXT:    retl
;
; X64SSE2-LABEL: elt6_v8f32:
; X64SSE2:       # BB#0:
; X64SSE2-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; X64SSE2-NEXT:    unpcklps {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1]
; X64SSE2-NEXT:    movss {{.*#+}} xmm2 = mem[0],zero,zero,zero
; X64SSE2-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; X64SSE2-NEXT:    unpcklps {{.*#+}} xmm1 = xmm1[0],xmm2[0],xmm1[1],xmm2[1]
; X64SSE2-NEXT:    movlhps {{.*#+}} xmm1 = xmm1[0],xmm0[0]
; X64SSE2-NEXT:    movaps {{.*#+}} xmm0 = [4.200000e+01,1.000000e+00,2.000000e+00,3.000000e+00]
; X64SSE2-NEXT:    retq
;
; X32SSE4-LABEL: elt6_v8f32:
; X32SSE4:       # BB#0:
; X32SSE4-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; X32SSE4-NEXT:    insertps {{.*#+}} xmm1 = xmm1[0],mem[0],xmm1[2,3]
; X32SSE4-NEXT:    insertps {{.*#+}} xmm1 = xmm1[0,1],mem[0],xmm1[3]
; X32SSE4-NEXT:    insertps {{.*#+}} xmm1 = xmm1[0,1,2],mem[0]
; X32SSE4-NEXT:    movaps {{.*#+}} xmm0 = [4.200000e+01,1.000000e+00,2.000000e+00,3.000000e+00]
; X32SSE4-NEXT:    retl
;
; X64SSE4-LABEL: elt6_v8f32:
; X64SSE4:       # BB#0:
; X64SSE4-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; X64SSE4-NEXT:    insertps {{.*#+}} xmm1 = xmm1[0],mem[0],xmm1[2,3]
; X64SSE4-NEXT:    insertps {{.*#+}} xmm1 = xmm1[0,1],xmm0[0],xmm1[3]
; X64SSE4-NEXT:    insertps {{.*#+}} xmm1 = xmm1[0,1,2],mem[0]
; X64SSE4-NEXT:    movaps {{.*#+}} xmm0 = [4.200000e+01,1.000000e+00,2.000000e+00,3.000000e+00]
; X64SSE4-NEXT:    retq
;
; X32AVX-LABEL: elt6_v8f32:
; X32AVX:       # BB#0:
; X32AVX-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X32AVX-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0],mem[0],xmm0[2,3]
; X32AVX-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0,1],mem[0],xmm0[3]
; X32AVX-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0,1,2],mem[0]
; X32AVX-NEXT:    vmovss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; X32AVX-NEXT:    vinsertps {{.*#+}} xmm1 = xmm1[0],mem[0],xmm1[2,3]
; X32AVX-NEXT:    vinsertps {{.*#+}} xmm1 = xmm1[0,1],mem[0],xmm1[3]
; X32AVX-NEXT:    vinsertps {{.*#+}} xmm1 = xmm1[0,1,2],mem[0]
; X32AVX-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; X32AVX-NEXT:    retl
;
; X64AVX-LABEL: elt6_v8f32:
; X64AVX:       # BB#0:
; X64AVX-NEXT:    vmovss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; X64AVX-NEXT:    vinsertps {{.*#+}} xmm1 = xmm1[0],mem[0],xmm1[2,3]
; X64AVX-NEXT:    vinsertps {{.*#+}} xmm1 = xmm1[0,1],mem[0],xmm1[3]
; X64AVX-NEXT:    vinsertps {{.*#+}} xmm1 = xmm1[0,1,2],mem[0]
; X64AVX-NEXT:    vmovss {{.*#+}} xmm2 = mem[0],zero,zero,zero
; X64AVX-NEXT:    vinsertps {{.*#+}} xmm2 = xmm2[0],mem[0],xmm2[2,3]
; X64AVX-NEXT:    vinsertps {{.*#+}} xmm0 = xmm2[0,1],xmm0[0],xmm2[3]
; X64AVX-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0,1,2],mem[0]
; X64AVX-NEXT:    vinsertf128 $1, %xmm0, %ymm1, %ymm0
; X64AVX-NEXT:    retq
   %ins = insertelement <8 x float> <float 42.0, float 1.0, float 2.0, float 3.0, float 4.0, float 5.0, float 6.0, float 7.0>, float %x, i32 6
   ret <8 x float> %ins
}

define <8 x i64> @elt5_v8i64(i64 %x) {
; X32SSE-LABEL: elt5_v8i64:
; X32SSE:       # BB#0:
; X32SSE-NEXT:    movl $4, %eax
; X32SSE-NEXT:    movd %eax, %xmm2
; X32SSE-NEXT:    movq {{.*#+}} xmm0 = mem[0],zero
; X32SSE-NEXT:    punpcklqdq {{.*#+}} xmm2 = xmm2[0],xmm0[0]
; X32SSE-NEXT:    movaps {{.*#+}} xmm0 = [42,0,1,0]
; X32SSE-NEXT:    movaps {{.*#+}} xmm1 = [2,0,3,0]
; X32SSE-NEXT:    movaps {{.*#+}} xmm3 = [6,0,7,0]
; X32SSE-NEXT:    retl
;
; X64SSE-LABEL: elt5_v8i64:
; X64SSE:       # BB#0:
; X64SSE-NEXT:    movq %rdi, %xmm0
; X64SSE-NEXT:    movl $4, %eax
; X64SSE-NEXT:    movq %rax, %xmm2
; X64SSE-NEXT:    punpcklqdq {{.*#+}} xmm2 = xmm2[0],xmm0[0]
; X64SSE-NEXT:    movaps {{.*#+}} xmm0 = [42,1]
; X64SSE-NEXT:    movaps {{.*#+}} xmm1 = [2,3]
; X64SSE-NEXT:    movaps {{.*#+}} xmm3 = [6,7]
; X64SSE-NEXT:    retq
;
; X32AVX2-LABEL: elt5_v8i64:
; X32AVX2:       # BB#0:
; X32AVX2-NEXT:    movl $4, %eax
; X32AVX2-NEXT:    vmovd %eax, %xmm0
; X32AVX2-NEXT:    vmovq {{.*#+}} xmm1 = mem[0],zero
; X32AVX2-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; X32AVX2-NEXT:    vinserti128 $1, {{\.LCPI.*}}, %ymm0, %ymm1
; X32AVX2-NEXT:    vmovaps {{.*#+}} ymm0 = [42,0,1,0,2,0,3,0]
; X32AVX2-NEXT:    retl
;
; X64AVX2-LABEL: elt5_v8i64:
; X64AVX2:       # BB#0:
; X64AVX2-NEXT:    vmovq %rdi, %xmm0
; X64AVX2-NEXT:    movl $4, %eax
; X64AVX2-NEXT:    vmovq %rax, %xmm1
; X64AVX2-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm1[0],xmm0[0]
; X64AVX2-NEXT:    vinserti128 $1, {{.*}}(%rip), %ymm0, %ymm1
; X64AVX2-NEXT:    vmovaps {{.*#+}} ymm0 = [42,1,2,3]
; X64AVX2-NEXT:    retq
;
; X32AVX512F-LABEL: elt5_v8i64:
; X32AVX512F:       # BB#0:
; X32AVX512F-NEXT:    vmovdqa {{.*#+}} ymm0 = [42,0,1,0,2,0,3,0]
; X32AVX512F-NEXT:    movl $4, %eax
; X32AVX512F-NEXT:    vmovd %eax, %xmm1
; X32AVX512F-NEXT:    vmovq {{.*#+}} xmm2 = mem[0],zero
; X32AVX512F-NEXT:    vpunpcklqdq {{.*#+}} xmm1 = xmm1[0],xmm2[0]
; X32AVX512F-NEXT:    vinserti128 $1, {{\.LCPI.*}}, %ymm1, %ymm1
; X32AVX512F-NEXT:    vinserti64x4 $1, %ymm1, %zmm0, %zmm0
; X32AVX512F-NEXT:    retl
;
; X64AVX512F-LABEL: elt5_v8i64:
; X64AVX512F:       # BB#0:
; X64AVX512F-NEXT:    vmovdqa {{.*#+}} ymm0 = [42,1,2,3]
; X64AVX512F-NEXT:    vmovq %rdi, %xmm1
; X64AVX512F-NEXT:    movl $4, %eax
; X64AVX512F-NEXT:    vmovq %rax, %xmm2
; X64AVX512F-NEXT:    vpunpcklqdq {{.*#+}} xmm1 = xmm2[0],xmm1[0]
; X64AVX512F-NEXT:    vinserti128 $1, {{.*}}(%rip), %ymm1, %ymm1
; X64AVX512F-NEXT:    vinserti64x4 $1, %ymm1, %zmm0, %zmm0
; X64AVX512F-NEXT:    retq
   %ins = insertelement <8 x i64> <i64 42, i64 1, i64 2, i64 3, i64 4, i64 5, i64 6, i64 7>, i64 %x, i32 5
   ret <8 x i64> %ins
}

define <8 x double> @elt1_v8f64(double %x) {
; X32SSE-LABEL: elt1_v8f64:
; X32SSE:       # BB#0:
; X32SSE-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; X32SSE-NEXT:    movhpd {{.*#+}} xmm0 = xmm0[0],mem[0]
; X32SSE-NEXT:    movaps {{.*#+}} xmm1 = [2.000000e+00,3.000000e+00]
; X32SSE-NEXT:    movaps {{.*#+}} xmm2 = [4.000000e+00,5.000000e+00]
; X32SSE-NEXT:    movaps {{.*#+}} xmm3 = [6.000000e+00,7.000000e+00]
; X32SSE-NEXT:    retl
;
; X64SSE-LABEL: elt1_v8f64:
; X64SSE:       # BB#0:
; X64SSE-NEXT:    movsd {{.*#+}} xmm4 = mem[0],zero
; X64SSE-NEXT:    movlhps {{.*#+}} xmm4 = xmm4[0],xmm0[0]
; X64SSE-NEXT:    movaps {{.*#+}} xmm1 = [2.000000e+00,3.000000e+00]
; X64SSE-NEXT:    movaps {{.*#+}} xmm2 = [4.000000e+00,5.000000e+00]
; X64SSE-NEXT:    movaps {{.*#+}} xmm3 = [6.000000e+00,7.000000e+00]
; X64SSE-NEXT:    movaps %xmm4, %xmm0
; X64SSE-NEXT:    retq
;
; X32AVX2-LABEL: elt1_v8f64:
; X32AVX2:       # BB#0:
; X32AVX2-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; X32AVX2-NEXT:    vmovhpd {{.*#+}} xmm0 = xmm0[0],mem[0]
; X32AVX2-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; X32AVX2-NEXT:    vmovhpd {{.*#+}} xmm1 = xmm1[0],mem[0]
; X32AVX2-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; X32AVX2-NEXT:    vmovaps {{.*#+}} ymm1 = [4.000000e+00,5.000000e+00,6.000000e+00,7.000000e+00]
; X32AVX2-NEXT:    retl
;
; X64AVX2-LABEL: elt1_v8f64:
; X64AVX2:       # BB#0:
; X64AVX2-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; X64AVX2-NEXT:    vunpcklpd {{.*#+}} xmm0 = xmm1[0],xmm0[0]
; X64AVX2-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; X64AVX2-NEXT:    vmovhpd {{.*#+}} xmm1 = xmm1[0],mem[0]
; X64AVX2-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; X64AVX2-NEXT:    vmovaps {{.*#+}} ymm1 = [4.000000e+00,5.000000e+00,6.000000e+00,7.000000e+00]
; X64AVX2-NEXT:    retq
;
; X32AVX512F-LABEL: elt1_v8f64:
; X32AVX512F:       # BB#0:
; X32AVX512F-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; X32AVX512F-NEXT:    vmovhpd {{.*#+}} xmm0 = xmm0[0],mem[0]
; X32AVX512F-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; X32AVX512F-NEXT:    vmovhpd {{.*#+}} xmm1 = xmm1[0],mem[0]
; X32AVX512F-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; X32AVX512F-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; X32AVX512F-NEXT:    vmovhpd {{.*#+}} xmm1 = xmm1[0],mem[0]
; X32AVX512F-NEXT:    vmovsd {{.*#+}} xmm2 = mem[0],zero
; X32AVX512F-NEXT:    vmovhpd {{.*#+}} xmm2 = xmm2[0],mem[0]
; X32AVX512F-NEXT:    vinsertf128 $1, %xmm2, %ymm1, %ymm1
; X32AVX512F-NEXT:    vinsertf64x4 $1, %ymm0, %zmm1, %zmm0
; X32AVX512F-NEXT:    retl
;
; X64AVX512F-LABEL: elt1_v8f64:
; X64AVX512F:       # BB#0:
; X64AVX512F-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; X64AVX512F-NEXT:    vmovhpd {{.*#+}} xmm1 = xmm1[0],mem[0]
; X64AVX512F-NEXT:    vmovsd {{.*#+}} xmm2 = mem[0],zero
; X64AVX512F-NEXT:    vmovhpd {{.*#+}} xmm2 = xmm2[0],mem[0]
; X64AVX512F-NEXT:    vinsertf128 $1, %xmm2, %ymm1, %ymm1
; X64AVX512F-NEXT:    vmovsd {{.*#+}} xmm2 = mem[0],zero
; X64AVX512F-NEXT:    vunpcklpd {{.*#+}} xmm0 = xmm2[0],xmm0[0]
; X64AVX512F-NEXT:    vmovsd {{.*#+}} xmm2 = mem[0],zero
; X64AVX512F-NEXT:    vmovhpd {{.*#+}} xmm2 = xmm2[0],mem[0]
; X64AVX512F-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; X64AVX512F-NEXT:    vinsertf64x4 $1, %ymm1, %zmm0, %zmm0
; X64AVX512F-NEXT:    retq
   %ins = insertelement <8 x double> <double 42.0, double 1.0, double 2.0, double 3.0, double 4.0, double 5.0, double 6.0, double 7.0>, double %x, i32 1
   ret <8 x double> %ins
}

