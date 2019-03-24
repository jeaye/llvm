; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse2 | FileCheck %s --check-prefix=SSE --check-prefix=SSE2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.1 | FileCheck %s --check-prefix=SSE --check-prefix=SSE41
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefix=AVX --check-prefix=AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefix=AVX --check-prefix=AVX2

; If we have a cmp and a sel with different-sized operands followed by a size-changing cast,
; we may want to pull the cast ahead of the select operands to create a select with matching op sizes:
; ext (sel (cmp a, b), c, d) --> sel (cmp a, b), (ext c), (ext d)

define <8 x i32> @sext(<8 x float> %a, <8 x float> %b, <8 x i16> %c, <8 x i16> %d) {
; SSE2-LABEL: sext:
; SSE2:       # %bb.0:
; SSE2-NEXT:    cmpltps %xmm3, %xmm1
; SSE2-NEXT:    cmpltps %xmm2, %xmm0
; SSE2-NEXT:    packssdw %xmm1, %xmm0
; SSE2-NEXT:    pand %xmm0, %xmm4
; SSE2-NEXT:    pandn %xmm5, %xmm0
; SSE2-NEXT:    por %xmm4, %xmm0
; SSE2-NEXT:    punpcklwd {{.*#+}} xmm2 = xmm2[0],xmm0[0],xmm2[1],xmm0[1],xmm2[2],xmm0[2],xmm2[3],xmm0[3]
; SSE2-NEXT:    psrad $16, %xmm2
; SSE2-NEXT:    punpckhwd {{.*#+}} xmm1 = xmm1[4],xmm0[4],xmm1[5],xmm0[5],xmm1[6],xmm0[6],xmm1[7],xmm0[7]
; SSE2-NEXT:    psrad $16, %xmm1
; SSE2-NEXT:    movdqa %xmm2, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: sext:
; SSE41:       # %bb.0:
; SSE41-NEXT:    cmpltps %xmm3, %xmm1
; SSE41-NEXT:    cmpltps %xmm2, %xmm0
; SSE41-NEXT:    packssdw %xmm1, %xmm0
; SSE41-NEXT:    pblendvb %xmm0, %xmm4, %xmm5
; SSE41-NEXT:    pmovsxwd %xmm5, %xmm0
; SSE41-NEXT:    pshufd {{.*#+}} xmm1 = xmm5[2,3,0,1]
; SSE41-NEXT:    pmovsxwd %xmm1, %xmm1
; SSE41-NEXT:    retq
;
; AVX1-LABEL: sext:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vcmpltps %ymm1, %ymm0, %ymm0
; AVX1-NEXT:    vpmovsxwd %xmm2, %xmm1
; AVX1-NEXT:    vpshufd {{.*#+}} xmm2 = xmm2[2,3,0,1]
; AVX1-NEXT:    vpmovsxwd %xmm2, %xmm2
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm1, %ymm1
; AVX1-NEXT:    vpmovsxwd %xmm3, %xmm2
; AVX1-NEXT:    vpshufd {{.*#+}} xmm3 = xmm3[2,3,0,1]
; AVX1-NEXT:    vpmovsxwd %xmm3, %xmm3
; AVX1-NEXT:    vinsertf128 $1, %xmm3, %ymm2, %ymm2
; AVX1-NEXT:    vblendvps %ymm0, %ymm1, %ymm2, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: sext:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vcmpltps %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vpmovsxwd %xmm2, %ymm1
; AVX2-NEXT:    vpmovsxwd %xmm3, %ymm2
; AVX2-NEXT:    vblendvps %ymm0, %ymm1, %ymm2, %ymm0
; AVX2-NEXT:    retq
  %cmp = fcmp olt <8 x float> %a, %b
  %sel = select <8 x i1> %cmp, <8 x i16> %c, <8 x i16> %d
  %ext = sext <8 x i16> %sel to <8 x i32>
  ret <8 x i32> %ext
}

define <8 x i32> @zext(<8 x float> %a, <8 x float> %b, <8 x i16> %c, <8 x i16> %d) {
; SSE2-LABEL: zext:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movaps %xmm0, %xmm6
; SSE2-NEXT:    cmpltps %xmm3, %xmm1
; SSE2-NEXT:    cmpltps %xmm2, %xmm6
; SSE2-NEXT:    packssdw %xmm1, %xmm6
; SSE2-NEXT:    pand %xmm6, %xmm4
; SSE2-NEXT:    pandn %xmm5, %xmm6
; SSE2-NEXT:    por %xmm4, %xmm6
; SSE2-NEXT:    pxor %xmm1, %xmm1
; SSE2-NEXT:    movdqa %xmm6, %xmm0
; SSE2-NEXT:    punpcklwd {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1],xmm0[2],xmm1[2],xmm0[3],xmm1[3]
; SSE2-NEXT:    punpckhwd {{.*#+}} xmm6 = xmm6[4],xmm1[4],xmm6[5],xmm1[5],xmm6[6],xmm1[6],xmm6[7],xmm1[7]
; SSE2-NEXT:    movdqa %xmm6, %xmm1
; SSE2-NEXT:    retq
;
; SSE41-LABEL: zext:
; SSE41:       # %bb.0:
; SSE41-NEXT:    cmpltps %xmm3, %xmm1
; SSE41-NEXT:    cmpltps %xmm2, %xmm0
; SSE41-NEXT:    packssdw %xmm1, %xmm0
; SSE41-NEXT:    pblendvb %xmm0, %xmm4, %xmm5
; SSE41-NEXT:    pxor %xmm1, %xmm1
; SSE41-NEXT:    pmovzxwd {{.*#+}} xmm0 = xmm5[0],zero,xmm5[1],zero,xmm5[2],zero,xmm5[3],zero
; SSE41-NEXT:    punpckhwd {{.*#+}} xmm5 = xmm5[4],xmm1[4],xmm5[5],xmm1[5],xmm5[6],xmm1[6],xmm5[7],xmm1[7]
; SSE41-NEXT:    movdqa %xmm5, %xmm1
; SSE41-NEXT:    retq
;
; AVX1-LABEL: zext:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vcmpltps %ymm1, %ymm0, %ymm0
; AVX1-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; AVX1-NEXT:    vpunpckhwd {{.*#+}} xmm4 = xmm2[4],xmm1[4],xmm2[5],xmm1[5],xmm2[6],xmm1[6],xmm2[7],xmm1[7]
; AVX1-NEXT:    vpmovzxwd {{.*#+}} xmm2 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
; AVX1-NEXT:    vinsertf128 $1, %xmm4, %ymm2, %ymm2
; AVX1-NEXT:    vpunpckhwd {{.*#+}} xmm1 = xmm3[4],xmm1[4],xmm3[5],xmm1[5],xmm3[6],xmm1[6],xmm3[7],xmm1[7]
; AVX1-NEXT:    vpmovzxwd {{.*#+}} xmm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm3, %ymm1
; AVX1-NEXT:    vblendvps %ymm0, %ymm2, %ymm1, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: zext:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vcmpltps %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vpmovzxwd {{.*#+}} ymm1 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero,xmm2[4],zero,xmm2[5],zero,xmm2[6],zero,xmm2[7],zero
; AVX2-NEXT:    vpmovzxwd {{.*#+}} ymm2 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero,xmm3[4],zero,xmm3[5],zero,xmm3[6],zero,xmm3[7],zero
; AVX2-NEXT:    vblendvps %ymm0, %ymm1, %ymm2, %ymm0
; AVX2-NEXT:    retq
  %cmp = fcmp olt <8 x float> %a, %b
  %sel = select <8 x i1> %cmp, <8 x i16> %c, <8 x i16> %d
  %ext = zext <8 x i16> %sel to <8 x i32>
  ret <8 x i32> %ext
}

define <4 x double> @fpext(<4 x double> %a, <4 x double> %b, <4 x float> %c, <4 x float> %d) {
; SSE2-LABEL: fpext:
; SSE2:       # %bb.0:
; SSE2-NEXT:    cmpltpd %xmm3, %xmm1
; SSE2-NEXT:    cmpltpd %xmm2, %xmm0
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,2],xmm1[0,2]
; SSE2-NEXT:    andps %xmm0, %xmm4
; SSE2-NEXT:    andnps %xmm5, %xmm0
; SSE2-NEXT:    orps %xmm4, %xmm0
; SSE2-NEXT:    cvtps2pd %xmm0, %xmm2
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[2,3,2,3]
; SSE2-NEXT:    cvtps2pd %xmm0, %xmm1
; SSE2-NEXT:    movaps %xmm2, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: fpext:
; SSE41:       # %bb.0:
; SSE41-NEXT:    cmpltpd %xmm3, %xmm1
; SSE41-NEXT:    cmpltpd %xmm2, %xmm0
; SSE41-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,2],xmm1[0,2]
; SSE41-NEXT:    blendvps %xmm0, %xmm4, %xmm5
; SSE41-NEXT:    cvtps2pd %xmm5, %xmm0
; SSE41-NEXT:    movhlps {{.*#+}} xmm5 = xmm5[1,1]
; SSE41-NEXT:    cvtps2pd %xmm5, %xmm1
; SSE41-NEXT:    retq
;
; AVX-LABEL: fpext:
; AVX:       # %bb.0:
; AVX-NEXT:    vcmpltpd %ymm1, %ymm0, %ymm0
; AVX-NEXT:    vcvtps2pd %xmm2, %ymm1
; AVX-NEXT:    vcvtps2pd %xmm3, %ymm2
; AVX-NEXT:    vblendvpd %ymm0, %ymm1, %ymm2, %ymm0
; AVX-NEXT:    retq
  %cmp = fcmp olt <4 x double> %a, %b
  %sel = select <4 x i1> %cmp, <4 x float> %c, <4 x float> %d
  %ext = fpext <4 x float> %sel to <4 x double>
  ret <4 x double> %ext
}

define <8 x i16> @trunc(<8 x i16> %a, <8 x i16> %b, <8 x i32> %c, <8 x i32> %d) {
; SSE2-LABEL: trunc:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pcmpeqw %xmm1, %xmm0
; SSE2-NEXT:    pslld $16, %xmm5
; SSE2-NEXT:    psrad $16, %xmm5
; SSE2-NEXT:    pslld $16, %xmm4
; SSE2-NEXT:    psrad $16, %xmm4
; SSE2-NEXT:    packssdw %xmm5, %xmm4
; SSE2-NEXT:    pslld $16, %xmm3
; SSE2-NEXT:    psrad $16, %xmm3
; SSE2-NEXT:    pslld $16, %xmm2
; SSE2-NEXT:    psrad $16, %xmm2
; SSE2-NEXT:    packssdw %xmm3, %xmm2
; SSE2-NEXT:    pand %xmm0, %xmm2
; SSE2-NEXT:    pandn %xmm4, %xmm0
; SSE2-NEXT:    por %xmm2, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: trunc:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pcmpeqw %xmm1, %xmm0
; SSE41-NEXT:    movdqa {{.*#+}} xmm1 = [0,1,4,5,8,9,12,13,8,9,12,13,12,13,14,15]
; SSE41-NEXT:    pshufb %xmm1, %xmm3
; SSE41-NEXT:    pshufb %xmm1, %xmm2
; SSE41-NEXT:    punpcklqdq {{.*#+}} xmm2 = xmm2[0],xmm3[0]
; SSE41-NEXT:    pshufb %xmm1, %xmm5
; SSE41-NEXT:    pshufb %xmm1, %xmm4
; SSE41-NEXT:    punpcklqdq {{.*#+}} xmm4 = xmm4[0],xmm5[0]
; SSE41-NEXT:    pblendvb %xmm0, %xmm2, %xmm4
; SSE41-NEXT:    movdqa %xmm4, %xmm0
; SSE41-NEXT:    retq
;
; AVX1-LABEL: trunc:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpcmpeqw %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vextractf128 $1, %ymm2, %xmm1
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm4 = [0,1,4,5,8,9,12,13,8,9,12,13,12,13,14,15]
; AVX1-NEXT:    vpshufb %xmm4, %xmm1, %xmm1
; AVX1-NEXT:    vpshufb %xmm4, %xmm2, %xmm2
; AVX1-NEXT:    vpunpcklqdq {{.*#+}} xmm1 = xmm2[0],xmm1[0]
; AVX1-NEXT:    vextractf128 $1, %ymm3, %xmm2
; AVX1-NEXT:    vpshufb %xmm4, %xmm2, %xmm2
; AVX1-NEXT:    vpshufb %xmm4, %xmm3, %xmm3
; AVX1-NEXT:    vpunpcklqdq {{.*#+}} xmm2 = xmm3[0],xmm2[0]
; AVX1-NEXT:    vpblendvb %xmm0, %xmm1, %xmm2, %xmm0
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: trunc:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpcmpeqw %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vmovdqa {{.*#+}} ymm1 = [0,1,4,5,8,9,12,13,8,9,12,13,12,13,14,15,16,17,20,21,24,25,28,29,24,25,28,29,28,29,30,31]
; AVX2-NEXT:    vpshufb %ymm1, %ymm2, %ymm2
; AVX2-NEXT:    vpermq {{.*#+}} ymm2 = ymm2[0,2,2,3]
; AVX2-NEXT:    vpshufb %ymm1, %ymm3, %ymm1
; AVX2-NEXT:    vpermq {{.*#+}} ymm1 = ymm1[0,2,2,3]
; AVX2-NEXT:    vpblendvb %xmm0, %xmm2, %xmm1, %xmm0
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
  %cmp = icmp eq <8 x i16> %a, %b
  %sel = select <8 x i1> %cmp, <8 x i32> %c, <8 x i32> %d
  %tr = trunc <8 x i32> %sel to <8 x i16>
  ret <8 x i16> %tr
}

define <4 x float> @fptrunc(<4 x float> %a, <4 x float> %b, <4 x double> %c, <4 x double> %d) {
; SSE2-LABEL: fptrunc:
; SSE2:       # %bb.0:
; SSE2-NEXT:    cmpltps %xmm1, %xmm0
; SSE2-NEXT:    cvtpd2ps %xmm5, %xmm1
; SSE2-NEXT:    cvtpd2ps %xmm4, %xmm4
; SSE2-NEXT:    unpcklpd {{.*#+}} xmm4 = xmm4[0],xmm1[0]
; SSE2-NEXT:    cvtpd2ps %xmm3, %xmm1
; SSE2-NEXT:    cvtpd2ps %xmm2, %xmm2
; SSE2-NEXT:    unpcklpd {{.*#+}} xmm2 = xmm2[0],xmm1[0]
; SSE2-NEXT:    andpd %xmm0, %xmm2
; SSE2-NEXT:    andnpd %xmm4, %xmm0
; SSE2-NEXT:    orpd %xmm2, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: fptrunc:
; SSE41:       # %bb.0:
; SSE41-NEXT:    cmpltps %xmm1, %xmm0
; SSE41-NEXT:    cvtpd2ps %xmm3, %xmm1
; SSE41-NEXT:    cvtpd2ps %xmm2, %xmm2
; SSE41-NEXT:    unpcklpd {{.*#+}} xmm2 = xmm2[0],xmm1[0]
; SSE41-NEXT:    cvtpd2ps %xmm5, %xmm3
; SSE41-NEXT:    cvtpd2ps %xmm4, %xmm1
; SSE41-NEXT:    unpcklpd {{.*#+}} xmm1 = xmm1[0],xmm3[0]
; SSE41-NEXT:    blendvps %xmm0, %xmm2, %xmm1
; SSE41-NEXT:    movaps %xmm1, %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: fptrunc:
; AVX:       # %bb.0:
; AVX-NEXT:    vcmpltps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vcvtpd2ps %ymm2, %xmm1
; AVX-NEXT:    vcvtpd2ps %ymm3, %xmm2
; AVX-NEXT:    vblendvps %xmm0, %xmm1, %xmm2, %xmm0
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
  %cmp = fcmp olt <4 x float> %a, %b
  %sel = select <4 x i1> %cmp, <4 x double> %c, <4 x double> %d
  %tr = fptrunc <4 x double> %sel to <4 x float>
  ret <4 x float> %tr
}

; PR14657 - avoid truncation/extension of comparison results
; These tests demonstrate the same issue as the simpler cases above,
; but also include multi-BB to show potentially larger transforms/codegen issues.

@da = common global [1024 x float] zeroinitializer, align 32
@db = common global [1024 x float] zeroinitializer, align 32
@dc = common global [1024 x float] zeroinitializer, align 32
@dd = common global [1024 x float] zeroinitializer, align 32
@dj = common global [1024 x i32] zeroinitializer, align 32

define void @example25() nounwind {
; SSE2-LABEL: example25:
; SSE2:       # %bb.0: # %vector.ph
; SSE2-NEXT:    movq $-4096, %rax # imm = 0xF000
; SSE2-NEXT:    movdqa {{.*#+}} xmm0 = [1,1,1,1]
; SSE2-NEXT:    .p2align 4, 0x90
; SSE2-NEXT:  .LBB5_1: # %vector.body
; SSE2-NEXT:    # =>This Inner Loop Header: Depth=1
; SSE2-NEXT:    movaps da+4096(%rax), %xmm1
; SSE2-NEXT:    movaps da+4112(%rax), %xmm2
; SSE2-NEXT:    cmpltps db+4112(%rax), %xmm2
; SSE2-NEXT:    cmpltps db+4096(%rax), %xmm1
; SSE2-NEXT:    packssdw %xmm2, %xmm1
; SSE2-NEXT:    movaps dc+4096(%rax), %xmm2
; SSE2-NEXT:    movaps dc+4112(%rax), %xmm3
; SSE2-NEXT:    cmpltps dd+4112(%rax), %xmm3
; SSE2-NEXT:    cmpltps dd+4096(%rax), %xmm2
; SSE2-NEXT:    packssdw %xmm3, %xmm2
; SSE2-NEXT:    pand %xmm1, %xmm2
; SSE2-NEXT:    movdqa %xmm2, %xmm1
; SSE2-NEXT:    punpcklwd {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1],xmm1[2],xmm0[2],xmm1[3],xmm0[3]
; SSE2-NEXT:    pand %xmm0, %xmm1
; SSE2-NEXT:    punpckhwd {{.*#+}} xmm2 = xmm2[4],xmm0[4],xmm2[5],xmm0[5],xmm2[6],xmm0[6],xmm2[7],xmm0[7]
; SSE2-NEXT:    pand %xmm0, %xmm2
; SSE2-NEXT:    movdqa %xmm2, dj+4112(%rax)
; SSE2-NEXT:    movdqa %xmm1, dj+4096(%rax)
; SSE2-NEXT:    addq $32, %rax
; SSE2-NEXT:    jne .LBB5_1
; SSE2-NEXT:  # %bb.2: # %for.end
; SSE2-NEXT:    retq
;
; SSE41-LABEL: example25:
; SSE41:       # %bb.0: # %vector.ph
; SSE41-NEXT:    movq $-4096, %rax # imm = 0xF000
; SSE41-NEXT:    movdqa {{.*#+}} xmm0 = [1,1,1,1]
; SSE41-NEXT:    .p2align 4, 0x90
; SSE41-NEXT:  .LBB5_1: # %vector.body
; SSE41-NEXT:    # =>This Inner Loop Header: Depth=1
; SSE41-NEXT:    movaps da+4096(%rax), %xmm1
; SSE41-NEXT:    movaps da+4112(%rax), %xmm2
; SSE41-NEXT:    cmpltps db+4112(%rax), %xmm2
; SSE41-NEXT:    cmpltps db+4096(%rax), %xmm1
; SSE41-NEXT:    packssdw %xmm2, %xmm1
; SSE41-NEXT:    movaps dc+4096(%rax), %xmm2
; SSE41-NEXT:    movaps dc+4112(%rax), %xmm3
; SSE41-NEXT:    cmpltps dd+4112(%rax), %xmm3
; SSE41-NEXT:    cmpltps dd+4096(%rax), %xmm2
; SSE41-NEXT:    packssdw %xmm3, %xmm2
; SSE41-NEXT:    pand %xmm1, %xmm2
; SSE41-NEXT:    pmovzxwd {{.*#+}} xmm1 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero
; SSE41-NEXT:    pand %xmm0, %xmm1
; SSE41-NEXT:    punpckhwd {{.*#+}} xmm2 = xmm2[4],xmm0[4],xmm2[5],xmm0[5],xmm2[6],xmm0[6],xmm2[7],xmm0[7]
; SSE41-NEXT:    pand %xmm0, %xmm2
; SSE41-NEXT:    movdqa %xmm2, dj+4112(%rax)
; SSE41-NEXT:    movdqa %xmm1, dj+4096(%rax)
; SSE41-NEXT:    addq $32, %rax
; SSE41-NEXT:    jne .LBB5_1
; SSE41-NEXT:  # %bb.2: # %for.end
; SSE41-NEXT:    retq
;
; AVX1-LABEL: example25:
; AVX1:       # %bb.0: # %vector.ph
; AVX1-NEXT:    movq $-4096, %rax # imm = 0xF000
; AVX1-NEXT:    vmovaps {{.*#+}} ymm0 = [1,1,1,1,1,1,1,1]
; AVX1-NEXT:    .p2align 4, 0x90
; AVX1-NEXT:  .LBB5_1: # %vector.body
; AVX1-NEXT:    # =>This Inner Loop Header: Depth=1
; AVX1-NEXT:    vmovups da+4096(%rax), %ymm1
; AVX1-NEXT:    vcmpltps db+4096(%rax), %ymm1, %ymm1
; AVX1-NEXT:    vmovups dc+4096(%rax), %ymm2
; AVX1-NEXT:    vcmpltps dd+4096(%rax), %ymm2, %ymm2
; AVX1-NEXT:    vandps %ymm2, %ymm1, %ymm1
; AVX1-NEXT:    vandps %ymm0, %ymm1, %ymm1
; AVX1-NEXT:    vmovups %ymm1, dj+4096(%rax)
; AVX1-NEXT:    addq $32, %rax
; AVX1-NEXT:    jne .LBB5_1
; AVX1-NEXT:  # %bb.2: # %for.end
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: example25:
; AVX2:       # %bb.0: # %vector.ph
; AVX2-NEXT:    movq $-4096, %rax # imm = 0xF000
; AVX2-NEXT:    .p2align 4, 0x90
; AVX2-NEXT:  .LBB5_1: # %vector.body
; AVX2-NEXT:    # =>This Inner Loop Header: Depth=1
; AVX2-NEXT:    vmovups da+4096(%rax), %ymm0
; AVX2-NEXT:    vcmpltps db+4096(%rax), %ymm0, %ymm0
; AVX2-NEXT:    vmovups dc+4096(%rax), %ymm1
; AVX2-NEXT:    vcmpltps dd+4096(%rax), %ymm1, %ymm1
; AVX2-NEXT:    vandps %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vpsrld $31, %ymm0, %ymm0
; AVX2-NEXT:    vmovdqu %ymm0, dj+4096(%rax)
; AVX2-NEXT:    addq $32, %rax
; AVX2-NEXT:    jne .LBB5_1
; AVX2-NEXT:  # %bb.2: # %for.end
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
vector.ph:
  br label %vector.body

vector.body:
  %index = phi i64 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %0 = getelementptr inbounds [1024 x float], [1024 x float]* @da, i64 0, i64 %index
  %1 = bitcast float* %0 to <8 x float>*
  %2 = load <8 x float>, <8 x float>* %1, align 16
  %3 = getelementptr inbounds [1024 x float], [1024 x float]* @db, i64 0, i64 %index
  %4 = bitcast float* %3 to <8 x float>*
  %5 = load <8 x float>, <8 x float>* %4, align 16
  %6 = fcmp olt <8 x float> %2, %5
  %7 = getelementptr inbounds [1024 x float], [1024 x float]* @dc, i64 0, i64 %index
  %8 = bitcast float* %7 to <8 x float>*
  %9 = load <8 x float>, <8 x float>* %8, align 16
  %10 = getelementptr inbounds [1024 x float], [1024 x float]* @dd, i64 0, i64 %index
  %11 = bitcast float* %10 to <8 x float>*
  %12 = load <8 x float>, <8 x float>* %11, align 16
  %13 = fcmp olt <8 x float> %9, %12
  %14 = and <8 x i1> %6, %13
  %15 = zext <8 x i1> %14 to <8 x i32>
  %16 = getelementptr inbounds [1024 x i32], [1024 x i32]* @dj, i64 0, i64 %index
  %17 = bitcast i32* %16 to <8 x i32>*
  store <8 x i32> %15, <8 x i32>* %17, align 16
  %index.next = add i64 %index, 8
  %18 = icmp eq i64 %index.next, 1024
  br i1 %18, label %for.end, label %vector.body

for.end:
  ret void
}

define void @example24(i16 signext %x, i16 signext %y) nounwind {
; SSE2-LABEL: example24:
; SSE2:       # %bb.0: # %vector.ph
; SSE2-NEXT:    movd %edi, %xmm0
; SSE2-NEXT:    pshuflw {{.*#+}} xmm0 = xmm0[0,0,2,3,4,5,6,7]
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,0,0,0]
; SSE2-NEXT:    movd %esi, %xmm1
; SSE2-NEXT:    pshuflw {{.*#+}} xmm1 = xmm1[0,0,2,3,4,5,6,7]
; SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[0,0,0,0]
; SSE2-NEXT:    movq $-4096, %rax # imm = 0xF000
; SSE2-NEXT:    .p2align 4, 0x90
; SSE2-NEXT:  .LBB6_1: # %vector.body
; SSE2-NEXT:    # =>This Inner Loop Header: Depth=1
; SSE2-NEXT:    movaps da+4096(%rax), %xmm2
; SSE2-NEXT:    movaps da+4112(%rax), %xmm3
; SSE2-NEXT:    cmpltps db+4112(%rax), %xmm3
; SSE2-NEXT:    cmpltps db+4096(%rax), %xmm2
; SSE2-NEXT:    packssdw %xmm3, %xmm2
; SSE2-NEXT:    movdqa %xmm0, %xmm3
; SSE2-NEXT:    pand %xmm2, %xmm3
; SSE2-NEXT:    pandn %xmm1, %xmm2
; SSE2-NEXT:    por %xmm3, %xmm2
; SSE2-NEXT:    punpcklwd {{.*#+}} xmm3 = xmm3[0],xmm2[0],xmm3[1],xmm2[1],xmm3[2],xmm2[2],xmm3[3],xmm2[3]
; SSE2-NEXT:    psrad $16, %xmm3
; SSE2-NEXT:    punpckhwd {{.*#+}} xmm2 = xmm2[4,4,5,5,6,6,7,7]
; SSE2-NEXT:    psrad $16, %xmm2
; SSE2-NEXT:    movdqa %xmm2, dj+4112(%rax)
; SSE2-NEXT:    movdqa %xmm3, dj+4096(%rax)
; SSE2-NEXT:    addq $32, %rax
; SSE2-NEXT:    jne .LBB6_1
; SSE2-NEXT:  # %bb.2: # %for.end
; SSE2-NEXT:    retq
;
; SSE41-LABEL: example24:
; SSE41:       # %bb.0: # %vector.ph
; SSE41-NEXT:    movd %edi, %xmm0
; SSE41-NEXT:    pshuflw {{.*#+}} xmm0 = xmm0[0,0,2,3,4,5,6,7]
; SSE41-NEXT:    pshufd {{.*#+}} xmm1 = xmm0[0,0,0,0]
; SSE41-NEXT:    movd %esi, %xmm0
; SSE41-NEXT:    pshuflw {{.*#+}} xmm0 = xmm0[0,0,2,3,4,5,6,7]
; SSE41-NEXT:    pshufd {{.*#+}} xmm2 = xmm0[0,0,0,0]
; SSE41-NEXT:    movq $-4096, %rax # imm = 0xF000
; SSE41-NEXT:    .p2align 4, 0x90
; SSE41-NEXT:  .LBB6_1: # %vector.body
; SSE41-NEXT:    # =>This Inner Loop Header: Depth=1
; SSE41-NEXT:    movaps da+4096(%rax), %xmm0
; SSE41-NEXT:    movaps da+4112(%rax), %xmm3
; SSE41-NEXT:    cmpltps db+4112(%rax), %xmm3
; SSE41-NEXT:    cmpltps db+4096(%rax), %xmm0
; SSE41-NEXT:    packssdw %xmm3, %xmm0
; SSE41-NEXT:    movdqa %xmm2, %xmm3
; SSE41-NEXT:    pblendvb %xmm0, %xmm1, %xmm3
; SSE41-NEXT:    pshufd {{.*#+}} xmm0 = xmm3[2,3,0,1]
; SSE41-NEXT:    pmovsxwd %xmm0, %xmm0
; SSE41-NEXT:    pmovsxwd %xmm3, %xmm3
; SSE41-NEXT:    movdqa %xmm3, dj+4096(%rax)
; SSE41-NEXT:    movdqa %xmm0, dj+4112(%rax)
; SSE41-NEXT:    addq $32, %rax
; SSE41-NEXT:    jne .LBB6_1
; SSE41-NEXT:  # %bb.2: # %for.end
; SSE41-NEXT:    retq
;
; AVX1-LABEL: example24:
; AVX1:       # %bb.0: # %vector.ph
; AVX1-NEXT:    vmovd %edi, %xmm0
; AVX1-NEXT:    vpshuflw {{.*#+}} xmm0 = xmm0[0,0,2,3,4,5,6,7]
; AVX1-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,0,0,0]
; AVX1-NEXT:    vmovd %esi, %xmm1
; AVX1-NEXT:    vpshuflw {{.*#+}} xmm1 = xmm1[0,0,2,3,4,5,6,7]
; AVX1-NEXT:    vpshufd {{.*#+}} xmm1 = xmm1[0,0,0,0]
; AVX1-NEXT:    movq $-4096, %rax # imm = 0xF000
; AVX1-NEXT:    vpmovsxwd %xmm0, %xmm2
; AVX1-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[2,3,0,1]
; AVX1-NEXT:    vpmovsxwd %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm0, %ymm2, %ymm0
; AVX1-NEXT:    vpmovsxwd %xmm1, %xmm2
; AVX1-NEXT:    vpshufd {{.*#+}} xmm1 = xmm1[2,3,0,1]
; AVX1-NEXT:    vpmovsxwd %xmm1, %xmm1
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm2, %ymm1
; AVX1-NEXT:    .p2align 4, 0x90
; AVX1-NEXT:  .LBB6_1: # %vector.body
; AVX1-NEXT:    # =>This Inner Loop Header: Depth=1
; AVX1-NEXT:    vmovups da+4096(%rax), %ymm2
; AVX1-NEXT:    vcmpltps db+4096(%rax), %ymm2, %ymm2
; AVX1-NEXT:    vblendvps %ymm2, %ymm0, %ymm1, %ymm2
; AVX1-NEXT:    vmovups %ymm2, dj+4096(%rax)
; AVX1-NEXT:    addq $32, %rax
; AVX1-NEXT:    jne .LBB6_1
; AVX1-NEXT:  # %bb.2: # %for.end
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: example24:
; AVX2:       # %bb.0: # %vector.ph
; AVX2-NEXT:    vmovd %edi, %xmm0
; AVX2-NEXT:    vpbroadcastw %xmm0, %xmm0
; AVX2-NEXT:    vmovd %esi, %xmm1
; AVX2-NEXT:    vpbroadcastw %xmm1, %xmm1
; AVX2-NEXT:    movq $-4096, %rax # imm = 0xF000
; AVX2-NEXT:    vpmovsxwd %xmm0, %ymm0
; AVX2-NEXT:    vpmovsxwd %xmm1, %ymm1
; AVX2-NEXT:    .p2align 4, 0x90
; AVX2-NEXT:  .LBB6_1: # %vector.body
; AVX2-NEXT:    # =>This Inner Loop Header: Depth=1
; AVX2-NEXT:    vmovups da+4096(%rax), %ymm2
; AVX2-NEXT:    vcmpltps db+4096(%rax), %ymm2, %ymm2
; AVX2-NEXT:    vblendvps %ymm2, %ymm0, %ymm1, %ymm2
; AVX2-NEXT:    vmovups %ymm2, dj+4096(%rax)
; AVX2-NEXT:    addq $32, %rax
; AVX2-NEXT:    jne .LBB6_1
; AVX2-NEXT:  # %bb.2: # %for.end
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
vector.ph:
  %0 = insertelement <8 x i16> undef, i16 %x, i32 0
  %broadcast11 = shufflevector <8 x i16> %0, <8 x i16> undef, <8 x i32> zeroinitializer
  %1 = insertelement <8 x i16> undef, i16 %y, i32 0
  %broadcast12 = shufflevector <8 x i16> %1, <8 x i16> undef, <8 x i32> zeroinitializer
  br label %vector.body

vector.body:
  %index = phi i64 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %2 = getelementptr inbounds [1024 x float], [1024 x float]* @da, i64 0, i64 %index
  %3 = bitcast float* %2 to <8 x float>*
  %4 = load <8 x float>, <8 x float>* %3, align 16
  %5 = getelementptr inbounds [1024 x float], [1024 x float]* @db, i64 0, i64 %index
  %6 = bitcast float* %5 to <8 x float>*
  %7 = load <8 x float>, <8 x float>* %6, align 16
  %8 = fcmp olt <8 x float> %4, %7
  %9 = select <8 x i1> %8, <8 x i16> %broadcast11, <8 x i16> %broadcast12
  %10 = sext <8 x i16> %9 to <8 x i32>
  %11 = getelementptr inbounds [1024 x i32], [1024 x i32]* @dj, i64 0, i64 %index
  %12 = bitcast i32* %11 to <8 x i32>*
  store <8 x i32> %10, <8 x i32>* %12, align 16
  %index.next = add i64 %index, 8
  %13 = icmp eq i64 %index.next, 1024
  br i1 %13, label %for.end, label %vector.body

for.end:
  ret void
}

