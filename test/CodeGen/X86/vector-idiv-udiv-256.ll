; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefix=AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefix=AVX2 --check-prefix=AVX2NOBW
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512bw | FileCheck %s --check-prefix=AVX2 --check-prefix=AVX512BW

;
; udiv by 7
;

define <4 x i64> @test_div7_4i64(<4 x i64> %a) nounwind {
; AVX1-LABEL: test_div7_4i64:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-NEXT:    vpextrq $1, %xmm1, %rcx
; AVX1-NEXT:    movabsq $2635249153387078803, %rsi # imm = 0x2492492492492493
; AVX1-NEXT:    movq %rcx, %rax
; AVX1-NEXT:    mulq %rsi
; AVX1-NEXT:    subq %rdx, %rcx
; AVX1-NEXT:    shrq %rcx
; AVX1-NEXT:    addq %rdx, %rcx
; AVX1-NEXT:    shrq $2, %rcx
; AVX1-NEXT:    vmovq %rcx, %xmm2
; AVX1-NEXT:    vmovq %xmm1, %rcx
; AVX1-NEXT:    movq %rcx, %rax
; AVX1-NEXT:    mulq %rsi
; AVX1-NEXT:    subq %rdx, %rcx
; AVX1-NEXT:    shrq %rcx
; AVX1-NEXT:    addq %rdx, %rcx
; AVX1-NEXT:    shrq $2, %rcx
; AVX1-NEXT:    vmovq %rcx, %xmm1
; AVX1-NEXT:    vpunpcklqdq {{.*#+}} xmm1 = xmm1[0],xmm2[0]
; AVX1-NEXT:    vpextrq $1, %xmm0, %rcx
; AVX1-NEXT:    movq %rcx, %rax
; AVX1-NEXT:    mulq %rsi
; AVX1-NEXT:    subq %rdx, %rcx
; AVX1-NEXT:    shrq %rcx
; AVX1-NEXT:    addq %rdx, %rcx
; AVX1-NEXT:    shrq $2, %rcx
; AVX1-NEXT:    vmovq %rcx, %xmm2
; AVX1-NEXT:    vmovq %xmm0, %rcx
; AVX1-NEXT:    movq %rcx, %rax
; AVX1-NEXT:    mulq %rsi
; AVX1-NEXT:    subq %rdx, %rcx
; AVX1-NEXT:    shrq %rcx
; AVX1-NEXT:    addq %rdx, %rcx
; AVX1-NEXT:    shrq $2, %rcx
; AVX1-NEXT:    vmovq %rcx, %xmm0
; AVX1-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm2[0]
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test_div7_4i64:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX2-NEXT:    vpextrq $1, %xmm1, %rcx
; AVX2-NEXT:    movabsq $2635249153387078803, %rsi # imm = 0x2492492492492493
; AVX2-NEXT:    movq %rcx, %rax
; AVX2-NEXT:    mulq %rsi
; AVX2-NEXT:    subq %rdx, %rcx
; AVX2-NEXT:    shrq %rcx
; AVX2-NEXT:    addq %rdx, %rcx
; AVX2-NEXT:    shrq $2, %rcx
; AVX2-NEXT:    vmovq %rcx, %xmm2
; AVX2-NEXT:    vmovq %xmm1, %rcx
; AVX2-NEXT:    movq %rcx, %rax
; AVX2-NEXT:    mulq %rsi
; AVX2-NEXT:    subq %rdx, %rcx
; AVX2-NEXT:    shrq %rcx
; AVX2-NEXT:    addq %rdx, %rcx
; AVX2-NEXT:    shrq $2, %rcx
; AVX2-NEXT:    vmovq %rcx, %xmm1
; AVX2-NEXT:    vpunpcklqdq {{.*#+}} xmm1 = xmm1[0],xmm2[0]
; AVX2-NEXT:    vpextrq $1, %xmm0, %rcx
; AVX2-NEXT:    movq %rcx, %rax
; AVX2-NEXT:    mulq %rsi
; AVX2-NEXT:    subq %rdx, %rcx
; AVX2-NEXT:    shrq %rcx
; AVX2-NEXT:    addq %rdx, %rcx
; AVX2-NEXT:    shrq $2, %rcx
; AVX2-NEXT:    vmovq %rcx, %xmm2
; AVX2-NEXT:    vmovq %xmm0, %rcx
; AVX2-NEXT:    movq %rcx, %rax
; AVX2-NEXT:    mulq %rsi
; AVX2-NEXT:    subq %rdx, %rcx
; AVX2-NEXT:    shrq %rcx
; AVX2-NEXT:    addq %rdx, %rcx
; AVX2-NEXT:    shrq $2, %rcx
; AVX2-NEXT:    vmovq %rcx, %xmm0
; AVX2-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm2[0]
; AVX2-NEXT:    vinserti128 $1, %xmm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %res = udiv <4 x i64> %a, <i64 7, i64 7, i64 7, i64 7>
  ret <4 x i64> %res
}

define <8 x i32> @test_div7_8i32(<8 x i32> %a) nounwind {
; AVX1-LABEL: test_div7_8i32:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[1,1,3,3]
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm2 = [613566757,613566757,613566757,613566757]
; AVX1-NEXT:    vpmuludq %xmm2, %xmm1, %xmm1
; AVX1-NEXT:    vpmuludq %xmm2, %xmm0, %xmm3
; AVX1-NEXT:    vpshufd {{.*#+}} xmm3 = xmm3[1,1,3,3]
; AVX1-NEXT:    vpblendw {{.*#+}} xmm1 = xmm3[0,1],xmm1[2,3],xmm3[4,5],xmm1[6,7]
; AVX1-NEXT:    vpsubd %xmm1, %xmm0, %xmm3
; AVX1-NEXT:    vpsrld $1, %xmm3, %xmm3
; AVX1-NEXT:    vpaddd %xmm1, %xmm3, %xmm1
; AVX1-NEXT:    vpsrld $2, %xmm1, %xmm1
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX1-NEXT:    vpshufd {{.*#+}} xmm3 = xmm0[1,1,3,3]
; AVX1-NEXT:    vpmuludq %xmm2, %xmm3, %xmm3
; AVX1-NEXT:    vpmuludq %xmm2, %xmm0, %xmm2
; AVX1-NEXT:    vpshufd {{.*#+}} xmm2 = xmm2[1,1,3,3]
; AVX1-NEXT:    vpblendw {{.*#+}} xmm2 = xmm2[0,1],xmm3[2,3],xmm2[4,5],xmm3[6,7]
; AVX1-NEXT:    vpsubd %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vpsrld $1, %xmm0, %xmm0
; AVX1-NEXT:    vpaddd %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vpsrld $2, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm0, %ymm1, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test_div7_8i32:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpshufd {{.*#+}} ymm1 = ymm0[1,1,3,3,5,5,7,7]
; AVX2-NEXT:    vpbroadcastd {{.*#+}} ymm2 = [613566757,613566757,613566757,613566757,613566757,613566757,613566757,613566757]
; AVX2-NEXT:    vpmuludq %ymm2, %ymm1, %ymm1
; AVX2-NEXT:    vpmuludq %ymm2, %ymm0, %ymm2
; AVX2-NEXT:    vpshufd {{.*#+}} ymm2 = ymm2[1,1,3,3,5,5,7,7]
; AVX2-NEXT:    vpblendd {{.*#+}} ymm1 = ymm2[0],ymm1[1],ymm2[2],ymm1[3],ymm2[4],ymm1[5],ymm2[6],ymm1[7]
; AVX2-NEXT:    vpsubd %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vpsrld $1, %ymm0, %ymm0
; AVX2-NEXT:    vpaddd %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vpsrld $2, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %res = udiv <8 x i32> %a, <i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7>
  ret <8 x i32> %res
}

define <16 x i16> @test_div7_16i16(<16 x i16> %a) nounwind {
; AVX1-LABEL: test_div7_16i16:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm1 = [9363,9363,9363,9363,9363,9363,9363,9363]
; AVX1-NEXT:    vpmulhuw %xmm1, %xmm0, %xmm2
; AVX1-NEXT:    vpsubw %xmm2, %xmm0, %xmm3
; AVX1-NEXT:    vpsrlw $1, %xmm3, %xmm3
; AVX1-NEXT:    vpaddw %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vpsrlw $2, %xmm2, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX1-NEXT:    vpmulhuw %xmm1, %xmm0, %xmm1
; AVX1-NEXT:    vpsubw %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vpsrlw $1, %xmm0, %xmm0
; AVX1-NEXT:    vpaddw %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vpsrlw $2, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm0, %ymm2, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test_div7_16i16:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpmulhuw {{.*}}(%rip), %ymm0, %ymm1
; AVX2-NEXT:    vpsubw %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vpsrlw $1, %ymm0, %ymm0
; AVX2-NEXT:    vpaddw %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vpsrlw $2, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %res = udiv <16 x i16> %a, <i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7>
  ret <16 x i16> %res
}

define <32 x i8> @test_div7_32i8(<32 x i8> %a) nounwind {
; AVX1-LABEL: test_div7_32i8:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; AVX1-NEXT:    vpunpckhbw {{.*#+}} xmm3 = xmm1[8],xmm2[8],xmm1[9],xmm2[9],xmm1[10],xmm2[10],xmm1[11],xmm2[11],xmm1[12],xmm2[12],xmm1[13],xmm2[13],xmm1[14],xmm2[14],xmm1[15],xmm2[15]
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm4 = [37,0,37,0,37,0,37,0,37,0,37,0,37,0,37,0]
; AVX1-NEXT:    vpmullw %xmm4, %xmm3, %xmm3
; AVX1-NEXT:    vpsrlw $8, %xmm3, %xmm3
; AVX1-NEXT:    vpmovzxbw {{.*#+}} xmm5 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
; AVX1-NEXT:    vpmullw %xmm4, %xmm5, %xmm5
; AVX1-NEXT:    vpsrlw $8, %xmm5, %xmm5
; AVX1-NEXT:    vpackuswb %xmm3, %xmm5, %xmm3
; AVX1-NEXT:    vpsubb %xmm3, %xmm1, %xmm1
; AVX1-NEXT:    vpsrlw $1, %xmm1, %xmm1
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm5 = [127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127]
; AVX1-NEXT:    vpand %xmm5, %xmm1, %xmm1
; AVX1-NEXT:    vpaddb %xmm3, %xmm1, %xmm1
; AVX1-NEXT:    vpsrlw $2, %xmm1, %xmm1
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm3 = [63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63]
; AVX1-NEXT:    vpand %xmm3, %xmm1, %xmm1
; AVX1-NEXT:    vpunpckhbw {{.*#+}} xmm2 = xmm0[8],xmm2[8],xmm0[9],xmm2[9],xmm0[10],xmm2[10],xmm0[11],xmm2[11],xmm0[12],xmm2[12],xmm0[13],xmm2[13],xmm0[14],xmm2[14],xmm0[15],xmm2[15]
; AVX1-NEXT:    vpmullw %xmm4, %xmm2, %xmm2
; AVX1-NEXT:    vpsrlw $8, %xmm2, %xmm2
; AVX1-NEXT:    vpmovzxbw {{.*#+}} xmm6 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
; AVX1-NEXT:    vpmullw %xmm4, %xmm6, %xmm4
; AVX1-NEXT:    vpsrlw $8, %xmm4, %xmm4
; AVX1-NEXT:    vpackuswb %xmm2, %xmm4, %xmm2
; AVX1-NEXT:    vpsubb %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vpsrlw $1, %xmm0, %xmm0
; AVX1-NEXT:    vpand %xmm5, %xmm0, %xmm0
; AVX1-NEXT:    vpaddb %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vpsrlw $2, %xmm0, %xmm0
; AVX1-NEXT:    vpand %xmm3, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2NOBW-LABEL: test_div7_32i8:
; AVX2NOBW:       # %bb.0:
; AVX2NOBW-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX2NOBW-NEXT:    vpunpckhbw {{.*#+}} ymm2 = ymm0[8],ymm1[8],ymm0[9],ymm1[9],ymm0[10],ymm1[10],ymm0[11],ymm1[11],ymm0[12],ymm1[12],ymm0[13],ymm1[13],ymm0[14],ymm1[14],ymm0[15],ymm1[15],ymm0[24],ymm1[24],ymm0[25],ymm1[25],ymm0[26],ymm1[26],ymm0[27],ymm1[27],ymm0[28],ymm1[28],ymm0[29],ymm1[29],ymm0[30],ymm1[30],ymm0[31],ymm1[31]
; AVX2NOBW-NEXT:    vmovdqa {{.*#+}} ymm3 = [37,0,37,0,37,0,37,0,37,0,37,0,37,0,37,0,37,0,37,0,37,0,37,0,37,0,37,0,37,0,37,0]
; AVX2NOBW-NEXT:    vpmullw %ymm3, %ymm2, %ymm2
; AVX2NOBW-NEXT:    vpsrlw $8, %ymm2, %ymm2
; AVX2NOBW-NEXT:    vpunpcklbw {{.*#+}} ymm1 = ymm0[0],ymm1[0],ymm0[1],ymm1[1],ymm0[2],ymm1[2],ymm0[3],ymm1[3],ymm0[4],ymm1[4],ymm0[5],ymm1[5],ymm0[6],ymm1[6],ymm0[7],ymm1[7],ymm0[16],ymm1[16],ymm0[17],ymm1[17],ymm0[18],ymm1[18],ymm0[19],ymm1[19],ymm0[20],ymm1[20],ymm0[21],ymm1[21],ymm0[22],ymm1[22],ymm0[23],ymm1[23]
; AVX2NOBW-NEXT:    vpmullw %ymm3, %ymm1, %ymm1
; AVX2NOBW-NEXT:    vpsrlw $8, %ymm1, %ymm1
; AVX2NOBW-NEXT:    vpackuswb %ymm2, %ymm1, %ymm1
; AVX2NOBW-NEXT:    vpsubb %ymm1, %ymm0, %ymm0
; AVX2NOBW-NEXT:    vpsrlw $1, %ymm0, %ymm0
; AVX2NOBW-NEXT:    vpand {{.*}}(%rip), %ymm0, %ymm0
; AVX2NOBW-NEXT:    vpaddb %ymm1, %ymm0, %ymm0
; AVX2NOBW-NEXT:    vpsrlw $2, %ymm0, %ymm0
; AVX2NOBW-NEXT:    vpand {{.*}}(%rip), %ymm0, %ymm0
; AVX2NOBW-NEXT:    retq
;
; AVX512BW-LABEL: test_div7_32i8:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpmovzxbw {{.*#+}} zmm1 = ymm0[0],zero,ymm0[1],zero,ymm0[2],zero,ymm0[3],zero,ymm0[4],zero,ymm0[5],zero,ymm0[6],zero,ymm0[7],zero,ymm0[8],zero,ymm0[9],zero,ymm0[10],zero,ymm0[11],zero,ymm0[12],zero,ymm0[13],zero,ymm0[14],zero,ymm0[15],zero,ymm0[16],zero,ymm0[17],zero,ymm0[18],zero,ymm0[19],zero,ymm0[20],zero,ymm0[21],zero,ymm0[22],zero,ymm0[23],zero,ymm0[24],zero,ymm0[25],zero,ymm0[26],zero,ymm0[27],zero,ymm0[28],zero,ymm0[29],zero,ymm0[30],zero,ymm0[31],zero
; AVX512BW-NEXT:    vpmullw {{.*}}(%rip), %zmm1, %zmm1
; AVX512BW-NEXT:    vpsrlw $8, %zmm1, %zmm1
; AVX512BW-NEXT:    vpmovwb %zmm1, %ymm1
; AVX512BW-NEXT:    vpsubb %ymm1, %ymm0, %ymm0
; AVX512BW-NEXT:    vpsrlw $1, %ymm0, %ymm0
; AVX512BW-NEXT:    vpand {{.*}}(%rip), %ymm0, %ymm0
; AVX512BW-NEXT:    vpaddb %ymm1, %ymm0, %ymm0
; AVX512BW-NEXT:    vpsrlw $2, %ymm0, %ymm0
; AVX512BW-NEXT:    vpand {{.*}}(%rip), %ymm0, %ymm0
; AVX512BW-NEXT:    retq
  %res = udiv <32 x i8> %a, <i8 7, i8 7, i8 7, i8 7,i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7,i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7,i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7,i8 7, i8 7, i8 7, i8 7>
  ret <32 x i8> %res
}

;
; urem by 7
;

define <4 x i64> @test_rem7_4i64(<4 x i64> %a) nounwind {
; AVX1-LABEL: test_rem7_4i64:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-NEXT:    vpextrq $1, %xmm1, %rcx
; AVX1-NEXT:    movabsq $2635249153387078803, %rsi # imm = 0x2492492492492493
; AVX1-NEXT:    movq %rcx, %rax
; AVX1-NEXT:    mulq %rsi
; AVX1-NEXT:    movq %rcx, %rax
; AVX1-NEXT:    subq %rdx, %rax
; AVX1-NEXT:    shrq %rax
; AVX1-NEXT:    addq %rdx, %rax
; AVX1-NEXT:    shrq $2, %rax
; AVX1-NEXT:    leaq (,%rax,8), %rdx
; AVX1-NEXT:    subq %rdx, %rax
; AVX1-NEXT:    addq %rcx, %rax
; AVX1-NEXT:    vmovq %rax, %xmm2
; AVX1-NEXT:    vmovq %xmm1, %rcx
; AVX1-NEXT:    movq %rcx, %rax
; AVX1-NEXT:    mulq %rsi
; AVX1-NEXT:    movq %rcx, %rax
; AVX1-NEXT:    subq %rdx, %rax
; AVX1-NEXT:    shrq %rax
; AVX1-NEXT:    addq %rdx, %rax
; AVX1-NEXT:    shrq $2, %rax
; AVX1-NEXT:    leaq (,%rax,8), %rdx
; AVX1-NEXT:    subq %rdx, %rax
; AVX1-NEXT:    addq %rcx, %rax
; AVX1-NEXT:    vmovq %rax, %xmm1
; AVX1-NEXT:    vpunpcklqdq {{.*#+}} xmm1 = xmm1[0],xmm2[0]
; AVX1-NEXT:    vpextrq $1, %xmm0, %rcx
; AVX1-NEXT:    movq %rcx, %rax
; AVX1-NEXT:    mulq %rsi
; AVX1-NEXT:    movq %rcx, %rax
; AVX1-NEXT:    subq %rdx, %rax
; AVX1-NEXT:    shrq %rax
; AVX1-NEXT:    addq %rdx, %rax
; AVX1-NEXT:    shrq $2, %rax
; AVX1-NEXT:    leaq (,%rax,8), %rdx
; AVX1-NEXT:    subq %rdx, %rax
; AVX1-NEXT:    addq %rcx, %rax
; AVX1-NEXT:    vmovq %rax, %xmm2
; AVX1-NEXT:    vmovq %xmm0, %rcx
; AVX1-NEXT:    movq %rcx, %rax
; AVX1-NEXT:    mulq %rsi
; AVX1-NEXT:    movq %rcx, %rax
; AVX1-NEXT:    subq %rdx, %rax
; AVX1-NEXT:    shrq %rax
; AVX1-NEXT:    addq %rdx, %rax
; AVX1-NEXT:    shrq $2, %rax
; AVX1-NEXT:    leaq (,%rax,8), %rdx
; AVX1-NEXT:    subq %rdx, %rax
; AVX1-NEXT:    addq %rcx, %rax
; AVX1-NEXT:    vmovq %rax, %xmm0
; AVX1-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm2[0]
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test_rem7_4i64:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX2-NEXT:    vpextrq $1, %xmm1, %rcx
; AVX2-NEXT:    movabsq $2635249153387078803, %rsi # imm = 0x2492492492492493
; AVX2-NEXT:    movq %rcx, %rax
; AVX2-NEXT:    mulq %rsi
; AVX2-NEXT:    movq %rcx, %rax
; AVX2-NEXT:    subq %rdx, %rax
; AVX2-NEXT:    shrq %rax
; AVX2-NEXT:    addq %rdx, %rax
; AVX2-NEXT:    shrq $2, %rax
; AVX2-NEXT:    leaq (,%rax,8), %rdx
; AVX2-NEXT:    subq %rdx, %rax
; AVX2-NEXT:    addq %rcx, %rax
; AVX2-NEXT:    vmovq %rax, %xmm2
; AVX2-NEXT:    vmovq %xmm1, %rcx
; AVX2-NEXT:    movq %rcx, %rax
; AVX2-NEXT:    mulq %rsi
; AVX2-NEXT:    movq %rcx, %rax
; AVX2-NEXT:    subq %rdx, %rax
; AVX2-NEXT:    shrq %rax
; AVX2-NEXT:    addq %rdx, %rax
; AVX2-NEXT:    shrq $2, %rax
; AVX2-NEXT:    leaq (,%rax,8), %rdx
; AVX2-NEXT:    subq %rdx, %rax
; AVX2-NEXT:    addq %rcx, %rax
; AVX2-NEXT:    vmovq %rax, %xmm1
; AVX2-NEXT:    vpunpcklqdq {{.*#+}} xmm1 = xmm1[0],xmm2[0]
; AVX2-NEXT:    vpextrq $1, %xmm0, %rcx
; AVX2-NEXT:    movq %rcx, %rax
; AVX2-NEXT:    mulq %rsi
; AVX2-NEXT:    movq %rcx, %rax
; AVX2-NEXT:    subq %rdx, %rax
; AVX2-NEXT:    shrq %rax
; AVX2-NEXT:    addq %rdx, %rax
; AVX2-NEXT:    shrq $2, %rax
; AVX2-NEXT:    leaq (,%rax,8), %rdx
; AVX2-NEXT:    subq %rdx, %rax
; AVX2-NEXT:    addq %rcx, %rax
; AVX2-NEXT:    vmovq %rax, %xmm2
; AVX2-NEXT:    vmovq %xmm0, %rcx
; AVX2-NEXT:    movq %rcx, %rax
; AVX2-NEXT:    mulq %rsi
; AVX2-NEXT:    movq %rcx, %rax
; AVX2-NEXT:    subq %rdx, %rax
; AVX2-NEXT:    shrq %rax
; AVX2-NEXT:    addq %rdx, %rax
; AVX2-NEXT:    shrq $2, %rax
; AVX2-NEXT:    leaq (,%rax,8), %rdx
; AVX2-NEXT:    subq %rdx, %rax
; AVX2-NEXT:    addq %rcx, %rax
; AVX2-NEXT:    vmovq %rax, %xmm0
; AVX2-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm2[0]
; AVX2-NEXT:    vinserti128 $1, %xmm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %res = urem <4 x i64> %a, <i64 7, i64 7, i64 7, i64 7>
  ret <4 x i64> %res
}

define <8 x i32> @test_rem7_8i32(<8 x i32> %a) nounwind {
; AVX1-LABEL: test_rem7_8i32:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-NEXT:    vpshufd {{.*#+}} xmm2 = xmm1[1,1,3,3]
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm3 = [613566757,613566757,613566757,613566757]
; AVX1-NEXT:    vpmuludq %xmm3, %xmm2, %xmm2
; AVX1-NEXT:    vpmuludq %xmm3, %xmm1, %xmm4
; AVX1-NEXT:    vpshufd {{.*#+}} xmm4 = xmm4[1,1,3,3]
; AVX1-NEXT:    vpblendw {{.*#+}} xmm2 = xmm4[0,1],xmm2[2,3],xmm4[4,5],xmm2[6,7]
; AVX1-NEXT:    vpsubd %xmm2, %xmm1, %xmm4
; AVX1-NEXT:    vpsrld $1, %xmm4, %xmm4
; AVX1-NEXT:    vpaddd %xmm2, %xmm4, %xmm2
; AVX1-NEXT:    vpsrld $2, %xmm2, %xmm2
; AVX1-NEXT:    vpslld $3, %xmm2, %xmm4
; AVX1-NEXT:    vpsubd %xmm4, %xmm2, %xmm2
; AVX1-NEXT:    vpaddd %xmm2, %xmm1, %xmm1
; AVX1-NEXT:    vpshufd {{.*#+}} xmm2 = xmm0[1,1,3,3]
; AVX1-NEXT:    vpmuludq %xmm3, %xmm2, %xmm2
; AVX1-NEXT:    vpmuludq %xmm3, %xmm0, %xmm3
; AVX1-NEXT:    vpshufd {{.*#+}} xmm3 = xmm3[1,1,3,3]
; AVX1-NEXT:    vpblendw {{.*#+}} xmm2 = xmm3[0,1],xmm2[2,3],xmm3[4,5],xmm2[6,7]
; AVX1-NEXT:    vpsubd %xmm2, %xmm0, %xmm3
; AVX1-NEXT:    vpsrld $1, %xmm3, %xmm3
; AVX1-NEXT:    vpaddd %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vpsrld $2, %xmm2, %xmm2
; AVX1-NEXT:    vpslld $3, %xmm2, %xmm3
; AVX1-NEXT:    vpsubd %xmm3, %xmm2, %xmm2
; AVX1-NEXT:    vpaddd %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test_rem7_8i32:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpshufd {{.*#+}} ymm1 = ymm0[1,1,3,3,5,5,7,7]
; AVX2-NEXT:    vpbroadcastd {{.*#+}} ymm2 = [613566757,613566757,613566757,613566757,613566757,613566757,613566757,613566757]
; AVX2-NEXT:    vpmuludq %ymm2, %ymm1, %ymm1
; AVX2-NEXT:    vpmuludq %ymm2, %ymm0, %ymm2
; AVX2-NEXT:    vpshufd {{.*#+}} ymm2 = ymm2[1,1,3,3,5,5,7,7]
; AVX2-NEXT:    vpblendd {{.*#+}} ymm1 = ymm2[0],ymm1[1],ymm2[2],ymm1[3],ymm2[4],ymm1[5],ymm2[6],ymm1[7]
; AVX2-NEXT:    vpsubd %ymm1, %ymm0, %ymm2
; AVX2-NEXT:    vpsrld $1, %ymm2, %ymm2
; AVX2-NEXT:    vpaddd %ymm1, %ymm2, %ymm1
; AVX2-NEXT:    vpsrld $2, %ymm1, %ymm1
; AVX2-NEXT:    vpbroadcastd {{.*#+}} ymm2 = [7,7,7,7,7,7,7,7]
; AVX2-NEXT:    vpmulld %ymm2, %ymm1, %ymm1
; AVX2-NEXT:    vpsubd %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %res = urem <8 x i32> %a, <i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7>
  ret <8 x i32> %res
}

define <16 x i16> @test_rem7_16i16(<16 x i16> %a) nounwind {
; AVX1-LABEL: test_rem7_16i16:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm2 = [9363,9363,9363,9363,9363,9363,9363,9363]
; AVX1-NEXT:    vpmulhuw %xmm2, %xmm1, %xmm3
; AVX1-NEXT:    vpsubw %xmm3, %xmm1, %xmm4
; AVX1-NEXT:    vpsrlw $1, %xmm4, %xmm4
; AVX1-NEXT:    vpaddw %xmm3, %xmm4, %xmm3
; AVX1-NEXT:    vpsrlw $2, %xmm3, %xmm3
; AVX1-NEXT:    vpsllw $3, %xmm3, %xmm4
; AVX1-NEXT:    vpsubw %xmm4, %xmm3, %xmm3
; AVX1-NEXT:    vpaddw %xmm3, %xmm1, %xmm1
; AVX1-NEXT:    vpmulhuw %xmm2, %xmm0, %xmm2
; AVX1-NEXT:    vpsubw %xmm2, %xmm0, %xmm3
; AVX1-NEXT:    vpsrlw $1, %xmm3, %xmm3
; AVX1-NEXT:    vpaddw %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vpsrlw $2, %xmm2, %xmm2
; AVX1-NEXT:    vpsllw $3, %xmm2, %xmm3
; AVX1-NEXT:    vpsubw %xmm3, %xmm2, %xmm2
; AVX1-NEXT:    vpaddw %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test_rem7_16i16:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpmulhuw {{.*}}(%rip), %ymm0, %ymm1
; AVX2-NEXT:    vpsubw %ymm1, %ymm0, %ymm2
; AVX2-NEXT:    vpsrlw $1, %ymm2, %ymm2
; AVX2-NEXT:    vpaddw %ymm1, %ymm2, %ymm1
; AVX2-NEXT:    vpsrlw $2, %ymm1, %ymm1
; AVX2-NEXT:    vpmullw {{.*}}(%rip), %ymm1, %ymm1
; AVX2-NEXT:    vpsubw %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %res = urem <16 x i16> %a, <i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7>
  ret <16 x i16> %res
}

define <32 x i8> @test_rem7_32i8(<32 x i8> %a) nounwind {
; AVX1-LABEL: test_rem7_32i8:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-NEXT:    vpxor %xmm8, %xmm8, %xmm8
; AVX1-NEXT:    vpunpckhbw {{.*#+}} xmm3 = xmm1[8],xmm8[8],xmm1[9],xmm8[9],xmm1[10],xmm8[10],xmm1[11],xmm8[11],xmm1[12],xmm8[12],xmm1[13],xmm8[13],xmm1[14],xmm8[14],xmm1[15],xmm8[15]
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm4 = [37,0,37,0,37,0,37,0,37,0,37,0,37,0,37,0]
; AVX1-NEXT:    vpmullw %xmm4, %xmm3, %xmm3
; AVX1-NEXT:    vpsrlw $8, %xmm3, %xmm3
; AVX1-NEXT:    vpmovzxbw {{.*#+}} xmm5 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
; AVX1-NEXT:    vpmullw %xmm4, %xmm5, %xmm5
; AVX1-NEXT:    vpsrlw $8, %xmm5, %xmm5
; AVX1-NEXT:    vpackuswb %xmm3, %xmm5, %xmm3
; AVX1-NEXT:    vpsubb %xmm3, %xmm1, %xmm5
; AVX1-NEXT:    vpsrlw $1, %xmm5, %xmm5
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm6 = [127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127]
; AVX1-NEXT:    vpand %xmm6, %xmm5, %xmm5
; AVX1-NEXT:    vpaddb %xmm3, %xmm5, %xmm3
; AVX1-NEXT:    vpsrlw $2, %xmm3, %xmm3
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm5 = [63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63]
; AVX1-NEXT:    vpand %xmm5, %xmm3, %xmm3
; AVX1-NEXT:    vpsllw $3, %xmm3, %xmm7
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm2 = [248,248,248,248,248,248,248,248,248,248,248,248,248,248,248,248]
; AVX1-NEXT:    vpand %xmm2, %xmm7, %xmm7
; AVX1-NEXT:    vpsubb %xmm7, %xmm3, %xmm3
; AVX1-NEXT:    vpaddb %xmm3, %xmm1, %xmm1
; AVX1-NEXT:    vpunpckhbw {{.*#+}} xmm3 = xmm0[8],xmm8[8],xmm0[9],xmm8[9],xmm0[10],xmm8[10],xmm0[11],xmm8[11],xmm0[12],xmm8[12],xmm0[13],xmm8[13],xmm0[14],xmm8[14],xmm0[15],xmm8[15]
; AVX1-NEXT:    vpmullw %xmm4, %xmm3, %xmm3
; AVX1-NEXT:    vpsrlw $8, %xmm3, %xmm3
; AVX1-NEXT:    vpmovzxbw {{.*#+}} xmm7 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
; AVX1-NEXT:    vpmullw %xmm4, %xmm7, %xmm4
; AVX1-NEXT:    vpsrlw $8, %xmm4, %xmm4
; AVX1-NEXT:    vpackuswb %xmm3, %xmm4, %xmm3
; AVX1-NEXT:    vpsubb %xmm3, %xmm0, %xmm4
; AVX1-NEXT:    vpsrlw $1, %xmm4, %xmm4
; AVX1-NEXT:    vpand %xmm6, %xmm4, %xmm4
; AVX1-NEXT:    vpaddb %xmm3, %xmm4, %xmm3
; AVX1-NEXT:    vpsrlw $2, %xmm3, %xmm3
; AVX1-NEXT:    vpand %xmm5, %xmm3, %xmm3
; AVX1-NEXT:    vpsllw $3, %xmm3, %xmm4
; AVX1-NEXT:    vpand %xmm2, %xmm4, %xmm2
; AVX1-NEXT:    vpsubb %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vpaddb %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2NOBW-LABEL: test_rem7_32i8:
; AVX2NOBW:       # %bb.0:
; AVX2NOBW-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX2NOBW-NEXT:    vpunpckhbw {{.*#+}} ymm2 = ymm0[8],ymm1[8],ymm0[9],ymm1[9],ymm0[10],ymm1[10],ymm0[11],ymm1[11],ymm0[12],ymm1[12],ymm0[13],ymm1[13],ymm0[14],ymm1[14],ymm0[15],ymm1[15],ymm0[24],ymm1[24],ymm0[25],ymm1[25],ymm0[26],ymm1[26],ymm0[27],ymm1[27],ymm0[28],ymm1[28],ymm0[29],ymm1[29],ymm0[30],ymm1[30],ymm0[31],ymm1[31]
; AVX2NOBW-NEXT:    vmovdqa {{.*#+}} ymm3 = [37,0,37,0,37,0,37,0,37,0,37,0,37,0,37,0,37,0,37,0,37,0,37,0,37,0,37,0,37,0,37,0]
; AVX2NOBW-NEXT:    vpmullw %ymm3, %ymm2, %ymm2
; AVX2NOBW-NEXT:    vpsrlw $8, %ymm2, %ymm2
; AVX2NOBW-NEXT:    vpunpcklbw {{.*#+}} ymm1 = ymm0[0],ymm1[0],ymm0[1],ymm1[1],ymm0[2],ymm1[2],ymm0[3],ymm1[3],ymm0[4],ymm1[4],ymm0[5],ymm1[5],ymm0[6],ymm1[6],ymm0[7],ymm1[7],ymm0[16],ymm1[16],ymm0[17],ymm1[17],ymm0[18],ymm1[18],ymm0[19],ymm1[19],ymm0[20],ymm1[20],ymm0[21],ymm1[21],ymm0[22],ymm1[22],ymm0[23],ymm1[23]
; AVX2NOBW-NEXT:    vpmullw %ymm3, %ymm1, %ymm1
; AVX2NOBW-NEXT:    vpsrlw $8, %ymm1, %ymm1
; AVX2NOBW-NEXT:    vpackuswb %ymm2, %ymm1, %ymm1
; AVX2NOBW-NEXT:    vpsubb %ymm1, %ymm0, %ymm2
; AVX2NOBW-NEXT:    vpsrlw $1, %ymm2, %ymm2
; AVX2NOBW-NEXT:    vpand {{.*}}(%rip), %ymm2, %ymm2
; AVX2NOBW-NEXT:    vpaddb %ymm1, %ymm2, %ymm1
; AVX2NOBW-NEXT:    vpsrlw $2, %ymm1, %ymm1
; AVX2NOBW-NEXT:    vpand {{.*}}(%rip), %ymm1, %ymm1
; AVX2NOBW-NEXT:    vpsllw $3, %ymm1, %ymm2
; AVX2NOBW-NEXT:    vpand {{.*}}(%rip), %ymm2, %ymm2
; AVX2NOBW-NEXT:    vpsubb %ymm2, %ymm1, %ymm1
; AVX2NOBW-NEXT:    vpaddb %ymm1, %ymm0, %ymm0
; AVX2NOBW-NEXT:    retq
;
; AVX512BW-LABEL: test_rem7_32i8:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpmovzxbw {{.*#+}} zmm1 = ymm0[0],zero,ymm0[1],zero,ymm0[2],zero,ymm0[3],zero,ymm0[4],zero,ymm0[5],zero,ymm0[6],zero,ymm0[7],zero,ymm0[8],zero,ymm0[9],zero,ymm0[10],zero,ymm0[11],zero,ymm0[12],zero,ymm0[13],zero,ymm0[14],zero,ymm0[15],zero,ymm0[16],zero,ymm0[17],zero,ymm0[18],zero,ymm0[19],zero,ymm0[20],zero,ymm0[21],zero,ymm0[22],zero,ymm0[23],zero,ymm0[24],zero,ymm0[25],zero,ymm0[26],zero,ymm0[27],zero,ymm0[28],zero,ymm0[29],zero,ymm0[30],zero,ymm0[31],zero
; AVX512BW-NEXT:    vpmullw {{.*}}(%rip), %zmm1, %zmm1
; AVX512BW-NEXT:    vpsrlw $8, %zmm1, %zmm1
; AVX512BW-NEXT:    vpmovwb %zmm1, %ymm1
; AVX512BW-NEXT:    vpsubb %ymm1, %ymm0, %ymm2
; AVX512BW-NEXT:    vpsrlw $1, %ymm2, %ymm2
; AVX512BW-NEXT:    vpand {{.*}}(%rip), %ymm2, %ymm2
; AVX512BW-NEXT:    vpaddb %ymm1, %ymm2, %ymm1
; AVX512BW-NEXT:    vpsrlw $2, %ymm1, %ymm1
; AVX512BW-NEXT:    vpand {{.*}}(%rip), %ymm1, %ymm1
; AVX512BW-NEXT:    vpsllw $3, %ymm1, %ymm2
; AVX512BW-NEXT:    vpand {{.*}}(%rip), %ymm2, %ymm2
; AVX512BW-NEXT:    vpsubb %ymm2, %ymm1, %ymm1
; AVX512BW-NEXT:    vpaddb %ymm1, %ymm0, %ymm0
; AVX512BW-NEXT:    retq
  %res = urem <32 x i8> %a, <i8 7, i8 7, i8 7, i8 7,i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7,i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7,i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7,i8 7, i8 7, i8 7, i8 7>
  ret <32 x i8> %res
}
