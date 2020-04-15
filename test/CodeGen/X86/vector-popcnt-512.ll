; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f | FileCheck %s --check-prefix=AVX512 --check-prefix=AVX512F
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512bw | FileCheck %s --check-prefix=AVX512 --check-prefix=AVX512BW
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512vpopcntdq | FileCheck %s --check-prefix=AVX512 --check-prefix=AVX512VPOPCNTDQ --check-prefix=AVX512VPOPCNTDQ-NOBW
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512vpopcntdq,+avx512bw | FileCheck %s --check-prefix=AVX512 --check-prefix=AVX512VPOPCNTDQ --check-prefix=AVX512VPOPCNTDQ-BW
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512bitalg | FileCheck %s --check-prefix=AVX512 --check-prefix=BITALG

define <8 x i64> @testv8i64(<8 x i64> %in) nounwind {
; AVX512F-LABEL: testv8i64:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vextracti64x4 $1, %zmm0, %ymm1
; AVX512F-NEXT:    vmovdqa {{.*#+}} ymm2 = [15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15]
; AVX512F-NEXT:    vpand %ymm2, %ymm1, %ymm3
; AVX512F-NEXT:    vmovdqa {{.*#+}} ymm4 = [0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4]
; AVX512F-NEXT:    vpshufb %ymm3, %ymm4, %ymm3
; AVX512F-NEXT:    vpsrlw $4, %ymm1, %ymm1
; AVX512F-NEXT:    vpand %ymm2, %ymm1, %ymm1
; AVX512F-NEXT:    vpshufb %ymm1, %ymm4, %ymm1
; AVX512F-NEXT:    vpaddb %ymm3, %ymm1, %ymm1
; AVX512F-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX512F-NEXT:    vpsadbw %ymm3, %ymm1, %ymm1
; AVX512F-NEXT:    vpand %ymm2, %ymm0, %ymm5
; AVX512F-NEXT:    vpshufb %ymm5, %ymm4, %ymm5
; AVX512F-NEXT:    vpsrlw $4, %ymm0, %ymm0
; AVX512F-NEXT:    vpand %ymm2, %ymm0, %ymm0
; AVX512F-NEXT:    vpshufb %ymm0, %ymm4, %ymm0
; AVX512F-NEXT:    vpaddb %ymm5, %ymm0, %ymm0
; AVX512F-NEXT:    vpsadbw %ymm3, %ymm0, %ymm0
; AVX512F-NEXT:    vinserti64x4 $1, %ymm1, %zmm0, %zmm0
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: testv8i64:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vmovdqa64 {{.*#+}} zmm1 = [15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15]
; AVX512BW-NEXT:    vpandq %zmm1, %zmm0, %zmm2
; AVX512BW-NEXT:    vmovdqa64 {{.*#+}} zmm3 = [0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4]
; AVX512BW-NEXT:    vpshufb %zmm2, %zmm3, %zmm2
; AVX512BW-NEXT:    vpsrlw $4, %zmm0, %zmm0
; AVX512BW-NEXT:    vpandq %zmm1, %zmm0, %zmm0
; AVX512BW-NEXT:    vpshufb %zmm0, %zmm3, %zmm0
; AVX512BW-NEXT:    vpaddb %zmm2, %zmm0, %zmm0
; AVX512BW-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX512BW-NEXT:    vpsadbw %zmm1, %zmm0, %zmm0
; AVX512BW-NEXT:    retq
;
; AVX512VPOPCNTDQ-LABEL: testv8i64:
; AVX512VPOPCNTDQ:       # %bb.0:
; AVX512VPOPCNTDQ-NEXT:    vpopcntq %zmm0, %zmm0
; AVX512VPOPCNTDQ-NEXT:    retq
;
; BITALG-LABEL: testv8i64:
; BITALG:       # %bb.0:
; BITALG-NEXT:    vpopcntb %zmm0, %zmm0
; BITALG-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; BITALG-NEXT:    vpsadbw %zmm1, %zmm0, %zmm0
; BITALG-NEXT:    retq
  %out = call <8 x i64> @llvm.ctpop.v8i64(<8 x i64> %in)
  ret <8 x i64> %out
}

define <16 x i32> @testv16i32(<16 x i32> %in) nounwind {
; AVX512F-LABEL: testv16i32:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vextracti64x4 $1, %zmm0, %ymm1
; AVX512F-NEXT:    vmovdqa {{.*#+}} ymm2 = [15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15]
; AVX512F-NEXT:    vpand %ymm2, %ymm1, %ymm3
; AVX512F-NEXT:    vmovdqa {{.*#+}} ymm4 = [0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4]
; AVX512F-NEXT:    vpshufb %ymm3, %ymm4, %ymm3
; AVX512F-NEXT:    vpsrlw $4, %ymm1, %ymm1
; AVX512F-NEXT:    vpand %ymm2, %ymm1, %ymm1
; AVX512F-NEXT:    vpshufb %ymm1, %ymm4, %ymm1
; AVX512F-NEXT:    vpaddb %ymm3, %ymm1, %ymm1
; AVX512F-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX512F-NEXT:    vpunpckhdq {{.*#+}} ymm5 = ymm1[2],ymm3[2],ymm1[3],ymm3[3],ymm1[6],ymm3[6],ymm1[7],ymm3[7]
; AVX512F-NEXT:    vpsadbw %ymm3, %ymm5, %ymm5
; AVX512F-NEXT:    vpunpckldq {{.*#+}} ymm1 = ymm1[0],ymm3[0],ymm1[1],ymm3[1],ymm1[4],ymm3[4],ymm1[5],ymm3[5]
; AVX512F-NEXT:    vpsadbw %ymm3, %ymm1, %ymm1
; AVX512F-NEXT:    vpackuswb %ymm5, %ymm1, %ymm1
; AVX512F-NEXT:    vpand %ymm2, %ymm0, %ymm5
; AVX512F-NEXT:    vpshufb %ymm5, %ymm4, %ymm5
; AVX512F-NEXT:    vpsrlw $4, %ymm0, %ymm0
; AVX512F-NEXT:    vpand %ymm2, %ymm0, %ymm0
; AVX512F-NEXT:    vpshufb %ymm0, %ymm4, %ymm0
; AVX512F-NEXT:    vpaddb %ymm5, %ymm0, %ymm0
; AVX512F-NEXT:    vpunpckhdq {{.*#+}} ymm2 = ymm0[2],ymm3[2],ymm0[3],ymm3[3],ymm0[6],ymm3[6],ymm0[7],ymm3[7]
; AVX512F-NEXT:    vpsadbw %ymm3, %ymm2, %ymm2
; AVX512F-NEXT:    vpunpckldq {{.*#+}} ymm0 = ymm0[0],ymm3[0],ymm0[1],ymm3[1],ymm0[4],ymm3[4],ymm0[5],ymm3[5]
; AVX512F-NEXT:    vpsadbw %ymm3, %ymm0, %ymm0
; AVX512F-NEXT:    vpackuswb %ymm2, %ymm0, %ymm0
; AVX512F-NEXT:    vinserti64x4 $1, %ymm1, %zmm0, %zmm0
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: testv16i32:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vmovdqa64 {{.*#+}} zmm1 = [15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15]
; AVX512BW-NEXT:    vpandq %zmm1, %zmm0, %zmm2
; AVX512BW-NEXT:    vmovdqa64 {{.*#+}} zmm3 = [0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4]
; AVX512BW-NEXT:    vpshufb %zmm2, %zmm3, %zmm2
; AVX512BW-NEXT:    vpsrlw $4, %zmm0, %zmm0
; AVX512BW-NEXT:    vpandq %zmm1, %zmm0, %zmm0
; AVX512BW-NEXT:    vpshufb %zmm0, %zmm3, %zmm0
; AVX512BW-NEXT:    vpaddb %zmm2, %zmm0, %zmm0
; AVX512BW-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX512BW-NEXT:    vpunpckhdq {{.*#+}} zmm2 = zmm0[2],zmm1[2],zmm0[3],zmm1[3],zmm0[6],zmm1[6],zmm0[7],zmm1[7],zmm0[10],zmm1[10],zmm0[11],zmm1[11],zmm0[14],zmm1[14],zmm0[15],zmm1[15]
; AVX512BW-NEXT:    vpsadbw %zmm1, %zmm2, %zmm2
; AVX512BW-NEXT:    vpunpckldq {{.*#+}} zmm0 = zmm0[0],zmm1[0],zmm0[1],zmm1[1],zmm0[4],zmm1[4],zmm0[5],zmm1[5],zmm0[8],zmm1[8],zmm0[9],zmm1[9],zmm0[12],zmm1[12],zmm0[13],zmm1[13]
; AVX512BW-NEXT:    vpsadbw %zmm1, %zmm0, %zmm0
; AVX512BW-NEXT:    vpackuswb %zmm2, %zmm0, %zmm0
; AVX512BW-NEXT:    retq
;
; AVX512VPOPCNTDQ-LABEL: testv16i32:
; AVX512VPOPCNTDQ:       # %bb.0:
; AVX512VPOPCNTDQ-NEXT:    vpopcntd %zmm0, %zmm0
; AVX512VPOPCNTDQ-NEXT:    retq
;
; BITALG-LABEL: testv16i32:
; BITALG:       # %bb.0:
; BITALG-NEXT:    vpopcntb %zmm0, %zmm0
; BITALG-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; BITALG-NEXT:    vpunpckhdq {{.*#+}} zmm2 = zmm0[2],zmm1[2],zmm0[3],zmm1[3],zmm0[6],zmm1[6],zmm0[7],zmm1[7],zmm0[10],zmm1[10],zmm0[11],zmm1[11],zmm0[14],zmm1[14],zmm0[15],zmm1[15]
; BITALG-NEXT:    vpsadbw %zmm1, %zmm2, %zmm2
; BITALG-NEXT:    vpunpckldq {{.*#+}} zmm0 = zmm0[0],zmm1[0],zmm0[1],zmm1[1],zmm0[4],zmm1[4],zmm0[5],zmm1[5],zmm0[8],zmm1[8],zmm0[9],zmm1[9],zmm0[12],zmm1[12],zmm0[13],zmm1[13]
; BITALG-NEXT:    vpsadbw %zmm1, %zmm0, %zmm0
; BITALG-NEXT:    vpackuswb %zmm2, %zmm0, %zmm0
; BITALG-NEXT:    retq
  %out = call <16 x i32> @llvm.ctpop.v16i32(<16 x i32> %in)
  ret <16 x i32> %out
}

define <32 x i16> @testv32i16(<32 x i16> %in) nounwind {
; AVX512F-LABEL: testv32i16:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vmovdqa {{.*#+}} ymm1 = [15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15]
; AVX512F-NEXT:    vpand %ymm1, %ymm0, %ymm2
; AVX512F-NEXT:    vmovdqa {{.*#+}} ymm3 = [0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4]
; AVX512F-NEXT:    vpshufb %ymm2, %ymm3, %ymm2
; AVX512F-NEXT:    vpsrlw $4, %ymm0, %ymm4
; AVX512F-NEXT:    vpand %ymm1, %ymm4, %ymm4
; AVX512F-NEXT:    vpshufb %ymm4, %ymm3, %ymm4
; AVX512F-NEXT:    vpaddb %ymm2, %ymm4, %ymm2
; AVX512F-NEXT:    vpsllw $8, %ymm2, %ymm4
; AVX512F-NEXT:    vpaddb %ymm2, %ymm4, %ymm2
; AVX512F-NEXT:    vpsrlw $8, %ymm2, %ymm2
; AVX512F-NEXT:    vextracti64x4 $1, %zmm0, %ymm0
; AVX512F-NEXT:    vpand %ymm1, %ymm0, %ymm4
; AVX512F-NEXT:    vpshufb %ymm4, %ymm3, %ymm4
; AVX512F-NEXT:    vpsrlw $4, %ymm0, %ymm0
; AVX512F-NEXT:    vpand %ymm1, %ymm0, %ymm0
; AVX512F-NEXT:    vpshufb %ymm0, %ymm3, %ymm0
; AVX512F-NEXT:    vpaddb %ymm4, %ymm0, %ymm0
; AVX512F-NEXT:    vpsllw $8, %ymm0, %ymm1
; AVX512F-NEXT:    vpaddb %ymm0, %ymm1, %ymm0
; AVX512F-NEXT:    vpsrlw $8, %ymm0, %ymm0
; AVX512F-NEXT:    vinserti64x4 $1, %ymm0, %zmm2, %zmm0
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: testv32i16:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vmovdqa64 {{.*#+}} zmm1 = [15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15]
; AVX512BW-NEXT:    vpandq %zmm1, %zmm0, %zmm2
; AVX512BW-NEXT:    vmovdqa64 {{.*#+}} zmm3 = [0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4]
; AVX512BW-NEXT:    vpshufb %zmm2, %zmm3, %zmm2
; AVX512BW-NEXT:    vpsrlw $4, %zmm0, %zmm0
; AVX512BW-NEXT:    vpandq %zmm1, %zmm0, %zmm0
; AVX512BW-NEXT:    vpshufb %zmm0, %zmm3, %zmm0
; AVX512BW-NEXT:    vpaddb %zmm2, %zmm0, %zmm0
; AVX512BW-NEXT:    vpsllw $8, %zmm0, %zmm1
; AVX512BW-NEXT:    vpaddb %zmm0, %zmm1, %zmm0
; AVX512BW-NEXT:    vpsrlw $8, %zmm0, %zmm0
; AVX512BW-NEXT:    retq
;
; AVX512VPOPCNTDQ-NOBW-LABEL: testv32i16:
; AVX512VPOPCNTDQ-NOBW:       # %bb.0:
; AVX512VPOPCNTDQ-NOBW-NEXT:    vpmovzxwd {{.*#+}} zmm1 = ymm0[0],zero,ymm0[1],zero,ymm0[2],zero,ymm0[3],zero,ymm0[4],zero,ymm0[5],zero,ymm0[6],zero,ymm0[7],zero,ymm0[8],zero,ymm0[9],zero,ymm0[10],zero,ymm0[11],zero,ymm0[12],zero,ymm0[13],zero,ymm0[14],zero,ymm0[15],zero
; AVX512VPOPCNTDQ-NOBW-NEXT:    vpopcntd %zmm1, %zmm1
; AVX512VPOPCNTDQ-NOBW-NEXT:    vpmovdw %zmm1, %ymm1
; AVX512VPOPCNTDQ-NOBW-NEXT:    vextracti64x4 $1, %zmm0, %ymm0
; AVX512VPOPCNTDQ-NOBW-NEXT:    vpmovzxwd {{.*#+}} zmm0 = ymm0[0],zero,ymm0[1],zero,ymm0[2],zero,ymm0[3],zero,ymm0[4],zero,ymm0[5],zero,ymm0[6],zero,ymm0[7],zero,ymm0[8],zero,ymm0[9],zero,ymm0[10],zero,ymm0[11],zero,ymm0[12],zero,ymm0[13],zero,ymm0[14],zero,ymm0[15],zero
; AVX512VPOPCNTDQ-NOBW-NEXT:    vpopcntd %zmm0, %zmm0
; AVX512VPOPCNTDQ-NOBW-NEXT:    vpmovdw %zmm0, %ymm0
; AVX512VPOPCNTDQ-NOBW-NEXT:    vinserti64x4 $1, %ymm0, %zmm1, %zmm0
; AVX512VPOPCNTDQ-NOBW-NEXT:    retq
;
; AVX512VPOPCNTDQ-BW-LABEL: testv32i16:
; AVX512VPOPCNTDQ-BW:       # %bb.0:
; AVX512VPOPCNTDQ-BW-NEXT:    vmovdqa64 {{.*#+}} zmm1 = [15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15]
; AVX512VPOPCNTDQ-BW-NEXT:    vpandq %zmm1, %zmm0, %zmm2
; AVX512VPOPCNTDQ-BW-NEXT:    vmovdqa64 {{.*#+}} zmm3 = [0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4]
; AVX512VPOPCNTDQ-BW-NEXT:    vpshufb %zmm2, %zmm3, %zmm2
; AVX512VPOPCNTDQ-BW-NEXT:    vpsrlw $4, %zmm0, %zmm0
; AVX512VPOPCNTDQ-BW-NEXT:    vpandq %zmm1, %zmm0, %zmm0
; AVX512VPOPCNTDQ-BW-NEXT:    vpshufb %zmm0, %zmm3, %zmm0
; AVX512VPOPCNTDQ-BW-NEXT:    vpaddb %zmm2, %zmm0, %zmm0
; AVX512VPOPCNTDQ-BW-NEXT:    vpsllw $8, %zmm0, %zmm1
; AVX512VPOPCNTDQ-BW-NEXT:    vpaddb %zmm0, %zmm1, %zmm0
; AVX512VPOPCNTDQ-BW-NEXT:    vpsrlw $8, %zmm0, %zmm0
; AVX512VPOPCNTDQ-BW-NEXT:    retq
;
; BITALG-LABEL: testv32i16:
; BITALG:       # %bb.0:
; BITALG-NEXT:    vpopcntw %zmm0, %zmm0
; BITALG-NEXT:    retq
  %out = call <32 x i16> @llvm.ctpop.v32i16(<32 x i16> %in)
  ret <32 x i16> %out
}

define <64 x i8> @testv64i8(<64 x i8> %in) nounwind {
; AVX512F-LABEL: testv64i8:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vextracti64x4 $1, %zmm0, %ymm1
; AVX512F-NEXT:    vmovdqa {{.*#+}} ymm2 = [15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15]
; AVX512F-NEXT:    vpand %ymm2, %ymm1, %ymm3
; AVX512F-NEXT:    vmovdqa {{.*#+}} ymm4 = [0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4]
; AVX512F-NEXT:    vpshufb %ymm3, %ymm4, %ymm3
; AVX512F-NEXT:    vpsrlw $4, %ymm1, %ymm1
; AVX512F-NEXT:    vpand %ymm2, %ymm1, %ymm1
; AVX512F-NEXT:    vpshufb %ymm1, %ymm4, %ymm1
; AVX512F-NEXT:    vpaddb %ymm3, %ymm1, %ymm1
; AVX512F-NEXT:    vpand %ymm2, %ymm0, %ymm3
; AVX512F-NEXT:    vpshufb %ymm3, %ymm4, %ymm3
; AVX512F-NEXT:    vpsrlw $4, %ymm0, %ymm0
; AVX512F-NEXT:    vpand %ymm2, %ymm0, %ymm0
; AVX512F-NEXT:    vpshufb %ymm0, %ymm4, %ymm0
; AVX512F-NEXT:    vpaddb %ymm3, %ymm0, %ymm0
; AVX512F-NEXT:    vinserti64x4 $1, %ymm1, %zmm0, %zmm0
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: testv64i8:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vmovdqa64 {{.*#+}} zmm1 = [15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15]
; AVX512BW-NEXT:    vpandq %zmm1, %zmm0, %zmm2
; AVX512BW-NEXT:    vmovdqa64 {{.*#+}} zmm3 = [0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4]
; AVX512BW-NEXT:    vpshufb %zmm2, %zmm3, %zmm2
; AVX512BW-NEXT:    vpsrlw $4, %zmm0, %zmm0
; AVX512BW-NEXT:    vpandq %zmm1, %zmm0, %zmm0
; AVX512BW-NEXT:    vpshufb %zmm0, %zmm3, %zmm0
; AVX512BW-NEXT:    vpaddb %zmm2, %zmm0, %zmm0
; AVX512BW-NEXT:    retq
;
; AVX512VPOPCNTDQ-NOBW-LABEL: testv64i8:
; AVX512VPOPCNTDQ-NOBW:       # %bb.0:
; AVX512VPOPCNTDQ-NOBW-NEXT:    vextracti64x4 $1, %zmm0, %ymm1
; AVX512VPOPCNTDQ-NOBW-NEXT:    vmovdqa {{.*#+}} ymm2 = [15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15]
; AVX512VPOPCNTDQ-NOBW-NEXT:    vpand %ymm2, %ymm1, %ymm3
; AVX512VPOPCNTDQ-NOBW-NEXT:    vmovdqa {{.*#+}} ymm4 = [0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4]
; AVX512VPOPCNTDQ-NOBW-NEXT:    vpshufb %ymm3, %ymm4, %ymm3
; AVX512VPOPCNTDQ-NOBW-NEXT:    vpsrlw $4, %ymm1, %ymm1
; AVX512VPOPCNTDQ-NOBW-NEXT:    vpand %ymm2, %ymm1, %ymm1
; AVX512VPOPCNTDQ-NOBW-NEXT:    vpshufb %ymm1, %ymm4, %ymm1
; AVX512VPOPCNTDQ-NOBW-NEXT:    vpaddb %ymm3, %ymm1, %ymm1
; AVX512VPOPCNTDQ-NOBW-NEXT:    vpand %ymm2, %ymm0, %ymm3
; AVX512VPOPCNTDQ-NOBW-NEXT:    vpshufb %ymm3, %ymm4, %ymm3
; AVX512VPOPCNTDQ-NOBW-NEXT:    vpsrlw $4, %ymm0, %ymm0
; AVX512VPOPCNTDQ-NOBW-NEXT:    vpand %ymm2, %ymm0, %ymm0
; AVX512VPOPCNTDQ-NOBW-NEXT:    vpshufb %ymm0, %ymm4, %ymm0
; AVX512VPOPCNTDQ-NOBW-NEXT:    vpaddb %ymm3, %ymm0, %ymm0
; AVX512VPOPCNTDQ-NOBW-NEXT:    vinserti64x4 $1, %ymm1, %zmm0, %zmm0
; AVX512VPOPCNTDQ-NOBW-NEXT:    retq
;
; AVX512VPOPCNTDQ-BW-LABEL: testv64i8:
; AVX512VPOPCNTDQ-BW:       # %bb.0:
; AVX512VPOPCNTDQ-BW-NEXT:    vmovdqa64 {{.*#+}} zmm1 = [15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15]
; AVX512VPOPCNTDQ-BW-NEXT:    vpandq %zmm1, %zmm0, %zmm2
; AVX512VPOPCNTDQ-BW-NEXT:    vmovdqa64 {{.*#+}} zmm3 = [0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4]
; AVX512VPOPCNTDQ-BW-NEXT:    vpshufb %zmm2, %zmm3, %zmm2
; AVX512VPOPCNTDQ-BW-NEXT:    vpsrlw $4, %zmm0, %zmm0
; AVX512VPOPCNTDQ-BW-NEXT:    vpandq %zmm1, %zmm0, %zmm0
; AVX512VPOPCNTDQ-BW-NEXT:    vpshufb %zmm0, %zmm3, %zmm0
; AVX512VPOPCNTDQ-BW-NEXT:    vpaddb %zmm2, %zmm0, %zmm0
; AVX512VPOPCNTDQ-BW-NEXT:    retq
;
; BITALG-LABEL: testv64i8:
; BITALG:       # %bb.0:
; BITALG-NEXT:    vpopcntb %zmm0, %zmm0
; BITALG-NEXT:    retq
  %out = call <64 x i8> @llvm.ctpop.v64i8(<64 x i8> %in)
  ret <64 x i8> %out
}

declare <8 x i64> @llvm.ctpop.v8i64(<8 x i64>)
declare <16 x i32> @llvm.ctpop.v16i32(<16 x i32>)
declare <32 x i16> @llvm.ctpop.v32i16(<32 x i16>)
declare <64 x i8> @llvm.ctpop.v64i8(<64 x i8>)
