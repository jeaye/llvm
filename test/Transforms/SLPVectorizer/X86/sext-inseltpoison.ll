; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -mtriple=x86_64-unknown -basic-aa -slp-vectorizer -S | FileCheck %s --check-prefixes=SSE,SSE2
; RUN: opt < %s -mtriple=x86_64-unknown -mcpu=slm -basic-aa -slp-vectorizer -S | FileCheck %s --check-prefixes=SSE,SLM
; RUN: opt < %s -mtriple=x86_64-unknown -mcpu=corei7-avx -basic-aa -slp-vectorizer -S | FileCheck %s --check-prefixes=AVX
; RUN: opt < %s -mtriple=x86_64-unknown -mcpu=core-avx2 -basic-aa -slp-vectorizer -S | FileCheck %s --check-prefixes=AVX
; RUN: opt < %s -mtriple=x86_64-unknown -mcpu=knl -basic-aa -slp-vectorizer -S | FileCheck %s --check-prefixes=AVX
; RUN: opt < %s -mtriple=x86_64-unknown -mcpu=skx -mattr=+avx512bw -basic-aa -slp-vectorizer -S | FileCheck %s --check-prefixes=AVX

;
; vXi8
;

define <2 x i64> @loadext_2i8_to_2i64(i8* %p0) {
; SSE-LABEL: @loadext_2i8_to_2i64(
; SSE-NEXT:    [[P1:%.*]] = getelementptr inbounds i8, i8* [[P0:%.*]], i64 1
; SSE-NEXT:    [[TMP1:%.*]] = bitcast i8* [[P0]] to <2 x i8>*
; SSE-NEXT:    [[TMP2:%.*]] = load <2 x i8>, <2 x i8>* [[TMP1]], align 1
; SSE-NEXT:    [[TMP3:%.*]] = sext <2 x i8> [[TMP2]] to <2 x i64>
; SSE-NEXT:    ret <2 x i64> [[TMP3]]
;
; AVX-LABEL: @loadext_2i8_to_2i64(
; AVX-NEXT:    [[P1:%.*]] = getelementptr inbounds i8, i8* [[P0:%.*]], i64 1
; AVX-NEXT:    [[TMP1:%.*]] = bitcast i8* [[P0]] to <2 x i8>*
; AVX-NEXT:    [[TMP2:%.*]] = load <2 x i8>, <2 x i8>* [[TMP1]], align 1
; AVX-NEXT:    [[TMP3:%.*]] = sext <2 x i8> [[TMP2]] to <2 x i64>
; AVX-NEXT:    ret <2 x i64> [[TMP3]]
;
  %p1 = getelementptr inbounds i8, i8* %p0, i64 1
  %i0 = load i8, i8* %p0, align 1
  %i1 = load i8, i8* %p1, align 1
  %x0 = sext i8 %i0 to i64
  %x1 = sext i8 %i1 to i64
  %v0 = insertelement <2 x i64> poison, i64 %x0, i32 0
  %v1 = insertelement <2 x i64>   %v0, i64 %x1, i32 1
  ret <2 x i64> %v1
}

define <4 x i32> @loadext_4i8_to_4i32(i8* %p0) {
; SSE-LABEL: @loadext_4i8_to_4i32(
; SSE-NEXT:    [[P1:%.*]] = getelementptr inbounds i8, i8* [[P0:%.*]], i64 1
; SSE-NEXT:    [[P2:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 2
; SSE-NEXT:    [[P3:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 3
; SSE-NEXT:    [[TMP1:%.*]] = bitcast i8* [[P0]] to <4 x i8>*
; SSE-NEXT:    [[TMP2:%.*]] = load <4 x i8>, <4 x i8>* [[TMP1]], align 1
; SSE-NEXT:    [[TMP3:%.*]] = sext <4 x i8> [[TMP2]] to <4 x i32>
; SSE-NEXT:    ret <4 x i32> [[TMP3]]
;
; AVX-LABEL: @loadext_4i8_to_4i32(
; AVX-NEXT:    [[P1:%.*]] = getelementptr inbounds i8, i8* [[P0:%.*]], i64 1
; AVX-NEXT:    [[P2:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 2
; AVX-NEXT:    [[P3:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 3
; AVX-NEXT:    [[TMP1:%.*]] = bitcast i8* [[P0]] to <4 x i8>*
; AVX-NEXT:    [[TMP2:%.*]] = load <4 x i8>, <4 x i8>* [[TMP1]], align 1
; AVX-NEXT:    [[TMP3:%.*]] = sext <4 x i8> [[TMP2]] to <4 x i32>
; AVX-NEXT:    ret <4 x i32> [[TMP3]]
;
  %p1 = getelementptr inbounds i8, i8* %p0, i64 1
  %p2 = getelementptr inbounds i8, i8* %p0, i64 2
  %p3 = getelementptr inbounds i8, i8* %p0, i64 3
  %i0 = load i8, i8* %p0, align 1
  %i1 = load i8, i8* %p1, align 1
  %i2 = load i8, i8* %p2, align 1
  %i3 = load i8, i8* %p3, align 1
  %x0 = sext i8 %i0 to i32
  %x1 = sext i8 %i1 to i32
  %x2 = sext i8 %i2 to i32
  %x3 = sext i8 %i3 to i32
  %v0 = insertelement <4 x i32> poison, i32 %x0, i32 0
  %v1 = insertelement <4 x i32>   %v0, i32 %x1, i32 1
  %v2 = insertelement <4 x i32>   %v1, i32 %x2, i32 2
  %v3 = insertelement <4 x i32>   %v2, i32 %x3, i32 3
  ret <4 x i32> %v3
}

define <4 x i64> @loadext_4i8_to_4i64(i8* %p0) {
; SSE-LABEL: @loadext_4i8_to_4i64(
; SSE-NEXT:    [[P1:%.*]] = getelementptr inbounds i8, i8* [[P0:%.*]], i64 1
; SSE-NEXT:    [[P2:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 2
; SSE-NEXT:    [[P3:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 3
; SSE-NEXT:    [[TMP1:%.*]] = bitcast i8* [[P0]] to <4 x i8>*
; SSE-NEXT:    [[TMP2:%.*]] = load <4 x i8>, <4 x i8>* [[TMP1]], align 1
; SSE-NEXT:    [[TMP3:%.*]] = sext <4 x i8> [[TMP2]] to <4 x i64>
; SSE-NEXT:    ret <4 x i64> [[TMP3]]
;
; AVX-LABEL: @loadext_4i8_to_4i64(
; AVX-NEXT:    [[P1:%.*]] = getelementptr inbounds i8, i8* [[P0:%.*]], i64 1
; AVX-NEXT:    [[P2:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 2
; AVX-NEXT:    [[P3:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 3
; AVX-NEXT:    [[TMP1:%.*]] = bitcast i8* [[P0]] to <4 x i8>*
; AVX-NEXT:    [[TMP2:%.*]] = load <4 x i8>, <4 x i8>* [[TMP1]], align 1
; AVX-NEXT:    [[TMP3:%.*]] = sext <4 x i8> [[TMP2]] to <4 x i64>
; AVX-NEXT:    ret <4 x i64> [[TMP3]]
;
  %p1 = getelementptr inbounds i8, i8* %p0, i64 1
  %p2 = getelementptr inbounds i8, i8* %p0, i64 2
  %p3 = getelementptr inbounds i8, i8* %p0, i64 3
  %i0 = load i8, i8* %p0, align 1
  %i1 = load i8, i8* %p1, align 1
  %i2 = load i8, i8* %p2, align 1
  %i3 = load i8, i8* %p3, align 1
  %x0 = sext i8 %i0 to i64
  %x1 = sext i8 %i1 to i64
  %x2 = sext i8 %i2 to i64
  %x3 = sext i8 %i3 to i64
  %v0 = insertelement <4 x i64> poison, i64 %x0, i32 0
  %v1 = insertelement <4 x i64>   %v0, i64 %x1, i32 1
  %v2 = insertelement <4 x i64>   %v1, i64 %x2, i32 2
  %v3 = insertelement <4 x i64>   %v2, i64 %x3, i32 3
  ret <4 x i64> %v3
}

define <8 x i16> @loadext_8i8_to_8i16(i8* %p0) {
; SSE-LABEL: @loadext_8i8_to_8i16(
; SSE-NEXT:    [[P1:%.*]] = getelementptr inbounds i8, i8* [[P0:%.*]], i64 1
; SSE-NEXT:    [[P2:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 2
; SSE-NEXT:    [[P3:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 3
; SSE-NEXT:    [[P4:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 4
; SSE-NEXT:    [[P5:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 5
; SSE-NEXT:    [[P6:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 6
; SSE-NEXT:    [[P7:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 7
; SSE-NEXT:    [[TMP1:%.*]] = bitcast i8* [[P0]] to <8 x i8>*
; SSE-NEXT:    [[TMP2:%.*]] = load <8 x i8>, <8 x i8>* [[TMP1]], align 1
; SSE-NEXT:    [[TMP3:%.*]] = sext <8 x i8> [[TMP2]] to <8 x i16>
; SSE-NEXT:    ret <8 x i16> [[TMP3]]
;
; AVX-LABEL: @loadext_8i8_to_8i16(
; AVX-NEXT:    [[P1:%.*]] = getelementptr inbounds i8, i8* [[P0:%.*]], i64 1
; AVX-NEXT:    [[P2:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 2
; AVX-NEXT:    [[P3:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 3
; AVX-NEXT:    [[P4:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 4
; AVX-NEXT:    [[P5:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 5
; AVX-NEXT:    [[P6:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 6
; AVX-NEXT:    [[P7:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 7
; AVX-NEXT:    [[TMP1:%.*]] = bitcast i8* [[P0]] to <8 x i8>*
; AVX-NEXT:    [[TMP2:%.*]] = load <8 x i8>, <8 x i8>* [[TMP1]], align 1
; AVX-NEXT:    [[TMP3:%.*]] = sext <8 x i8> [[TMP2]] to <8 x i16>
; AVX-NEXT:    ret <8 x i16> [[TMP3]]
;
  %p1 = getelementptr inbounds i8, i8* %p0, i64 1
  %p2 = getelementptr inbounds i8, i8* %p0, i64 2
  %p3 = getelementptr inbounds i8, i8* %p0, i64 3
  %p4 = getelementptr inbounds i8, i8* %p0, i64 4
  %p5 = getelementptr inbounds i8, i8* %p0, i64 5
  %p6 = getelementptr inbounds i8, i8* %p0, i64 6
  %p7 = getelementptr inbounds i8, i8* %p0, i64 7
  %i0 = load i8, i8* %p0, align 1
  %i1 = load i8, i8* %p1, align 1
  %i2 = load i8, i8* %p2, align 1
  %i3 = load i8, i8* %p3, align 1
  %i4 = load i8, i8* %p4, align 1
  %i5 = load i8, i8* %p5, align 1
  %i6 = load i8, i8* %p6, align 1
  %i7 = load i8, i8* %p7, align 1
  %x0 = sext i8 %i0 to i16
  %x1 = sext i8 %i1 to i16
  %x2 = sext i8 %i2 to i16
  %x3 = sext i8 %i3 to i16
  %x4 = sext i8 %i4 to i16
  %x5 = sext i8 %i5 to i16
  %x6 = sext i8 %i6 to i16
  %x7 = sext i8 %i7 to i16
  %v0 = insertelement <8 x i16> poison, i16 %x0, i32 0
  %v1 = insertelement <8 x i16>   %v0, i16 %x1, i32 1
  %v2 = insertelement <8 x i16>   %v1, i16 %x2, i32 2
  %v3 = insertelement <8 x i16>   %v2, i16 %x3, i32 3
  %v4 = insertelement <8 x i16>   %v3, i16 %x4, i32 4
  %v5 = insertelement <8 x i16>   %v4, i16 %x5, i32 5
  %v6 = insertelement <8 x i16>   %v5, i16 %x6, i32 6
  %v7 = insertelement <8 x i16>   %v6, i16 %x7, i32 7
  ret <8 x i16> %v7
}

define <8 x i32> @loadext_8i8_to_8i32(i8* %p0) {
; SSE-LABEL: @loadext_8i8_to_8i32(
; SSE-NEXT:    [[P1:%.*]] = getelementptr inbounds i8, i8* [[P0:%.*]], i64 1
; SSE-NEXT:    [[P2:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 2
; SSE-NEXT:    [[P3:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 3
; SSE-NEXT:    [[P4:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 4
; SSE-NEXT:    [[P5:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 5
; SSE-NEXT:    [[P6:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 6
; SSE-NEXT:    [[P7:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 7
; SSE-NEXT:    [[TMP1:%.*]] = bitcast i8* [[P0]] to <8 x i8>*
; SSE-NEXT:    [[TMP2:%.*]] = load <8 x i8>, <8 x i8>* [[TMP1]], align 1
; SSE-NEXT:    [[TMP3:%.*]] = sext <8 x i8> [[TMP2]] to <8 x i32>
; SSE-NEXT:    ret <8 x i32> [[TMP3]]
;
; AVX-LABEL: @loadext_8i8_to_8i32(
; AVX-NEXT:    [[P1:%.*]] = getelementptr inbounds i8, i8* [[P0:%.*]], i64 1
; AVX-NEXT:    [[P2:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 2
; AVX-NEXT:    [[P3:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 3
; AVX-NEXT:    [[P4:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 4
; AVX-NEXT:    [[P5:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 5
; AVX-NEXT:    [[P6:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 6
; AVX-NEXT:    [[P7:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 7
; AVX-NEXT:    [[TMP1:%.*]] = bitcast i8* [[P0]] to <8 x i8>*
; AVX-NEXT:    [[TMP2:%.*]] = load <8 x i8>, <8 x i8>* [[TMP1]], align 1
; AVX-NEXT:    [[TMP3:%.*]] = sext <8 x i8> [[TMP2]] to <8 x i32>
; AVX-NEXT:    ret <8 x i32> [[TMP3]]
;
  %p1 = getelementptr inbounds i8, i8* %p0, i64 1
  %p2 = getelementptr inbounds i8, i8* %p0, i64 2
  %p3 = getelementptr inbounds i8, i8* %p0, i64 3
  %p4 = getelementptr inbounds i8, i8* %p0, i64 4
  %p5 = getelementptr inbounds i8, i8* %p0, i64 5
  %p6 = getelementptr inbounds i8, i8* %p0, i64 6
  %p7 = getelementptr inbounds i8, i8* %p0, i64 7
  %i0 = load i8, i8* %p0, align 1
  %i1 = load i8, i8* %p1, align 1
  %i2 = load i8, i8* %p2, align 1
  %i3 = load i8, i8* %p3, align 1
  %i4 = load i8, i8* %p4, align 1
  %i5 = load i8, i8* %p5, align 1
  %i6 = load i8, i8* %p6, align 1
  %i7 = load i8, i8* %p7, align 1
  %x0 = sext i8 %i0 to i32
  %x1 = sext i8 %i1 to i32
  %x2 = sext i8 %i2 to i32
  %x3 = sext i8 %i3 to i32
  %x4 = sext i8 %i4 to i32
  %x5 = sext i8 %i5 to i32
  %x6 = sext i8 %i6 to i32
  %x7 = sext i8 %i7 to i32
  %v0 = insertelement <8 x i32> poison, i32 %x0, i32 0
  %v1 = insertelement <8 x i32>   %v0, i32 %x1, i32 1
  %v2 = insertelement <8 x i32>   %v1, i32 %x2, i32 2
  %v3 = insertelement <8 x i32>   %v2, i32 %x3, i32 3
  %v4 = insertelement <8 x i32>   %v3, i32 %x4, i32 4
  %v5 = insertelement <8 x i32>   %v4, i32 %x5, i32 5
  %v6 = insertelement <8 x i32>   %v5, i32 %x6, i32 6
  %v7 = insertelement <8 x i32>   %v6, i32 %x7, i32 7
  ret <8 x i32> %v7
}

define <16 x i16> @loadext_16i8_to_16i16(i8* %p0) {
; SSE-LABEL: @loadext_16i8_to_16i16(
; SSE-NEXT:    [[P1:%.*]] = getelementptr inbounds i8, i8* [[P0:%.*]], i64 1
; SSE-NEXT:    [[P2:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 2
; SSE-NEXT:    [[P3:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 3
; SSE-NEXT:    [[P4:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 4
; SSE-NEXT:    [[P5:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 5
; SSE-NEXT:    [[P6:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 6
; SSE-NEXT:    [[P7:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 7
; SSE-NEXT:    [[P8:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 8
; SSE-NEXT:    [[P9:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 9
; SSE-NEXT:    [[P10:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 10
; SSE-NEXT:    [[P11:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 11
; SSE-NEXT:    [[P12:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 12
; SSE-NEXT:    [[P13:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 13
; SSE-NEXT:    [[P14:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 14
; SSE-NEXT:    [[P15:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 15
; SSE-NEXT:    [[TMP1:%.*]] = bitcast i8* [[P0]] to <16 x i8>*
; SSE-NEXT:    [[TMP2:%.*]] = load <16 x i8>, <16 x i8>* [[TMP1]], align 1
; SSE-NEXT:    [[TMP3:%.*]] = sext <16 x i8> [[TMP2]] to <16 x i16>
; SSE-NEXT:    ret <16 x i16> [[TMP3]]
;
; AVX-LABEL: @loadext_16i8_to_16i16(
; AVX-NEXT:    [[P1:%.*]] = getelementptr inbounds i8, i8* [[P0:%.*]], i64 1
; AVX-NEXT:    [[P2:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 2
; AVX-NEXT:    [[P3:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 3
; AVX-NEXT:    [[P4:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 4
; AVX-NEXT:    [[P5:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 5
; AVX-NEXT:    [[P6:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 6
; AVX-NEXT:    [[P7:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 7
; AVX-NEXT:    [[P8:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 8
; AVX-NEXT:    [[P9:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 9
; AVX-NEXT:    [[P10:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 10
; AVX-NEXT:    [[P11:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 11
; AVX-NEXT:    [[P12:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 12
; AVX-NEXT:    [[P13:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 13
; AVX-NEXT:    [[P14:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 14
; AVX-NEXT:    [[P15:%.*]] = getelementptr inbounds i8, i8* [[P0]], i64 15
; AVX-NEXT:    [[TMP1:%.*]] = bitcast i8* [[P0]] to <16 x i8>*
; AVX-NEXT:    [[TMP2:%.*]] = load <16 x i8>, <16 x i8>* [[TMP1]], align 1
; AVX-NEXT:    [[TMP3:%.*]] = sext <16 x i8> [[TMP2]] to <16 x i16>
; AVX-NEXT:    ret <16 x i16> [[TMP3]]
;
  %p1  = getelementptr inbounds i8, i8* %p0, i64 1
  %p2  = getelementptr inbounds i8, i8* %p0, i64 2
  %p3  = getelementptr inbounds i8, i8* %p0, i64 3
  %p4  = getelementptr inbounds i8, i8* %p0, i64 4
  %p5  = getelementptr inbounds i8, i8* %p0, i64 5
  %p6  = getelementptr inbounds i8, i8* %p0, i64 6
  %p7  = getelementptr inbounds i8, i8* %p0, i64 7
  %p8  = getelementptr inbounds i8, i8* %p0, i64 8
  %p9  = getelementptr inbounds i8, i8* %p0, i64 9
  %p10 = getelementptr inbounds i8, i8* %p0, i64 10
  %p11 = getelementptr inbounds i8, i8* %p0, i64 11
  %p12 = getelementptr inbounds i8, i8* %p0, i64 12
  %p13 = getelementptr inbounds i8, i8* %p0, i64 13
  %p14 = getelementptr inbounds i8, i8* %p0, i64 14
  %p15 = getelementptr inbounds i8, i8* %p0, i64 15
  %i0  = load i8, i8* %p0,  align 1
  %i1  = load i8, i8* %p1,  align 1
  %i2  = load i8, i8* %p2,  align 1
  %i3  = load i8, i8* %p3,  align 1
  %i4  = load i8, i8* %p4,  align 1
  %i5  = load i8, i8* %p5,  align 1
  %i6  = load i8, i8* %p6,  align 1
  %i7  = load i8, i8* %p7,  align 1
  %i8  = load i8, i8* %p8,  align 1
  %i9  = load i8, i8* %p9,  align 1
  %i10 = load i8, i8* %p10, align 1
  %i11 = load i8, i8* %p11, align 1
  %i12 = load i8, i8* %p12, align 1
  %i13 = load i8, i8* %p13, align 1
  %i14 = load i8, i8* %p14, align 1
  %i15 = load i8, i8* %p15, align 1
  %x0  = sext i8 %i0  to i16
  %x1  = sext i8 %i1  to i16
  %x2  = sext i8 %i2  to i16
  %x3  = sext i8 %i3  to i16
  %x4  = sext i8 %i4  to i16
  %x5  = sext i8 %i5  to i16
  %x6  = sext i8 %i6  to i16
  %x7  = sext i8 %i7  to i16
  %x8  = sext i8 %i8  to i16
  %x9  = sext i8 %i9  to i16
  %x10 = sext i8 %i10 to i16
  %x11 = sext i8 %i11 to i16
  %x12 = sext i8 %i12 to i16
  %x13 = sext i8 %i13 to i16
  %x14 = sext i8 %i14 to i16
  %x15 = sext i8 %i15 to i16
  %v0  = insertelement <16 x i16> poison, i16 %x0,  i32 0
  %v1  = insertelement <16 x i16>  %v0,  i16 %x1,  i32 1
  %v2  = insertelement <16 x i16>  %v1,  i16 %x2,  i32 2
  %v3  = insertelement <16 x i16>  %v2,  i16 %x3,  i32 3
  %v4  = insertelement <16 x i16>  %v3,  i16 %x4,  i32 4
  %v5  = insertelement <16 x i16>  %v4,  i16 %x5,  i32 5
  %v6  = insertelement <16 x i16>  %v5,  i16 %x6,  i32 6
  %v7  = insertelement <16 x i16>  %v6,  i16 %x7,  i32 7
  %v8  = insertelement <16 x i16>  %v7,  i16 %x8,  i32 8
  %v9  = insertelement <16 x i16>  %v8,  i16 %x9,  i32 9
  %v10 = insertelement <16 x i16>  %v9,  i16 %x10, i32 10
  %v11 = insertelement <16 x i16>  %v10, i16 %x11, i32 11
  %v12 = insertelement <16 x i16>  %v11, i16 %x12, i32 12
  %v13 = insertelement <16 x i16>  %v12, i16 %x13, i32 13
  %v14 = insertelement <16 x i16>  %v13, i16 %x14, i32 14
  %v15 = insertelement <16 x i16>  %v14, i16 %x15, i32 15
  ret <16 x i16> %v15
}

;
; vXi16
;

define <2 x i64> @loadext_2i16_to_2i64(i16* %p0) {
; SSE-LABEL: @loadext_2i16_to_2i64(
; SSE-NEXT:    [[P1:%.*]] = getelementptr inbounds i16, i16* [[P0:%.*]], i64 1
; SSE-NEXT:    [[TMP1:%.*]] = bitcast i16* [[P0]] to <2 x i16>*
; SSE-NEXT:    [[TMP2:%.*]] = load <2 x i16>, <2 x i16>* [[TMP1]], align 1
; SSE-NEXT:    [[TMP3:%.*]] = sext <2 x i16> [[TMP2]] to <2 x i64>
; SSE-NEXT:    ret <2 x i64> [[TMP3]]
;
; AVX-LABEL: @loadext_2i16_to_2i64(
; AVX-NEXT:    [[P1:%.*]] = getelementptr inbounds i16, i16* [[P0:%.*]], i64 1
; AVX-NEXT:    [[TMP1:%.*]] = bitcast i16* [[P0]] to <2 x i16>*
; AVX-NEXT:    [[TMP2:%.*]] = load <2 x i16>, <2 x i16>* [[TMP1]], align 1
; AVX-NEXT:    [[TMP3:%.*]] = sext <2 x i16> [[TMP2]] to <2 x i64>
; AVX-NEXT:    ret <2 x i64> [[TMP3]]
;
  %p1 = getelementptr inbounds i16, i16* %p0, i64 1
  %i0 = load i16, i16* %p0, align 1
  %i1 = load i16, i16* %p1, align 1
  %x0 = sext i16 %i0 to i64
  %x1 = sext i16 %i1 to i64
  %v0 = insertelement <2 x i64> poison, i64 %x0, i32 0
  %v1 = insertelement <2 x i64>   %v0, i64 %x1, i32 1
  ret <2 x i64> %v1
}

define <4 x i32> @loadext_4i16_to_4i32(i16* %p0) {
; SSE-LABEL: @loadext_4i16_to_4i32(
; SSE-NEXT:    [[P1:%.*]] = getelementptr inbounds i16, i16* [[P0:%.*]], i64 1
; SSE-NEXT:    [[P2:%.*]] = getelementptr inbounds i16, i16* [[P0]], i64 2
; SSE-NEXT:    [[P3:%.*]] = getelementptr inbounds i16, i16* [[P0]], i64 3
; SSE-NEXT:    [[TMP1:%.*]] = bitcast i16* [[P0]] to <4 x i16>*
; SSE-NEXT:    [[TMP2:%.*]] = load <4 x i16>, <4 x i16>* [[TMP1]], align 1
; SSE-NEXT:    [[TMP3:%.*]] = sext <4 x i16> [[TMP2]] to <4 x i32>
; SSE-NEXT:    ret <4 x i32> [[TMP3]]
;
; AVX-LABEL: @loadext_4i16_to_4i32(
; AVX-NEXT:    [[P1:%.*]] = getelementptr inbounds i16, i16* [[P0:%.*]], i64 1
; AVX-NEXT:    [[P2:%.*]] = getelementptr inbounds i16, i16* [[P0]], i64 2
; AVX-NEXT:    [[P3:%.*]] = getelementptr inbounds i16, i16* [[P0]], i64 3
; AVX-NEXT:    [[TMP1:%.*]] = bitcast i16* [[P0]] to <4 x i16>*
; AVX-NEXT:    [[TMP2:%.*]] = load <4 x i16>, <4 x i16>* [[TMP1]], align 1
; AVX-NEXT:    [[TMP3:%.*]] = sext <4 x i16> [[TMP2]] to <4 x i32>
; AVX-NEXT:    ret <4 x i32> [[TMP3]]
;
  %p1 = getelementptr inbounds i16, i16* %p0, i64 1
  %p2 = getelementptr inbounds i16, i16* %p0, i64 2
  %p3 = getelementptr inbounds i16, i16* %p0, i64 3
  %i0 = load i16, i16* %p0, align 1
  %i1 = load i16, i16* %p1, align 1
  %i2 = load i16, i16* %p2, align 1
  %i3 = load i16, i16* %p3, align 1
  %x0 = sext i16 %i0 to i32
  %x1 = sext i16 %i1 to i32
  %x2 = sext i16 %i2 to i32
  %x3 = sext i16 %i3 to i32
  %v0 = insertelement <4 x i32> poison, i32 %x0, i32 0
  %v1 = insertelement <4 x i32>   %v0, i32 %x1, i32 1
  %v2 = insertelement <4 x i32>   %v1, i32 %x2, i32 2
  %v3 = insertelement <4 x i32>   %v2, i32 %x3, i32 3
  ret <4 x i32> %v3
}

define <4 x i64> @loadext_4i16_to_4i64(i16* %p0) {
; SSE2-LABEL: @loadext_4i16_to_4i64(
; SSE2-NEXT:    [[P1:%.*]] = getelementptr inbounds i16, i16* [[P0:%.*]], i64 1
; SSE2-NEXT:    [[P2:%.*]] = getelementptr inbounds i16, i16* [[P0]], i64 2
; SSE2-NEXT:    [[P3:%.*]] = getelementptr inbounds i16, i16* [[P0]], i64 3
; SSE2-NEXT:    [[TMP1:%.*]] = bitcast i16* [[P0]] to <2 x i16>*
; SSE2-NEXT:    [[TMP2:%.*]] = load <2 x i16>, <2 x i16>* [[TMP1]], align 1
; SSE2-NEXT:    [[TMP3:%.*]] = bitcast i16* [[P2]] to <2 x i16>*
; SSE2-NEXT:    [[TMP4:%.*]] = load <2 x i16>, <2 x i16>* [[TMP3]], align 1
; SSE2-NEXT:    [[TMP5:%.*]] = sext <2 x i16> [[TMP2]] to <2 x i64>
; SSE2-NEXT:    [[TMP6:%.*]] = sext <2 x i16> [[TMP4]] to <2 x i64>
; SSE2-NEXT:    [[TMP7:%.*]] = shufflevector <2 x i64> [[TMP5]], <2 x i64> poison, <4 x i32> <i32 0, i32 1, i32 undef, i32 undef>
; SSE2-NEXT:    [[V12:%.*]] = shufflevector <4 x i64> poison, <4 x i64> [[TMP7]], <4 x i32> <i32 4, i32 5, i32 2, i32 3>
; SSE2-NEXT:    [[TMP8:%.*]] = shufflevector <2 x i64> [[TMP6]], <2 x i64> poison, <4 x i32> <i32 0, i32 1, i32 undef, i32 undef>
; SSE2-NEXT:    [[V31:%.*]] = shufflevector <4 x i64> [[V12]], <4 x i64> [[TMP8]], <4 x i32> <i32 0, i32 1, i32 4, i32 5>
; SSE2-NEXT:    ret <4 x i64> [[V31]]
;
; SLM-LABEL: @loadext_4i16_to_4i64(
; SLM-NEXT:    [[P1:%.*]] = getelementptr inbounds i16, i16* [[P0:%.*]], i64 1
; SLM-NEXT:    [[P2:%.*]] = getelementptr inbounds i16, i16* [[P0]], i64 2
; SLM-NEXT:    [[P3:%.*]] = getelementptr inbounds i16, i16* [[P0]], i64 3
; SLM-NEXT:    [[TMP1:%.*]] = bitcast i16* [[P0]] to <4 x i16>*
; SLM-NEXT:    [[TMP2:%.*]] = load <4 x i16>, <4 x i16>* [[TMP1]], align 1
; SLM-NEXT:    [[TMP3:%.*]] = sext <4 x i16> [[TMP2]] to <4 x i64>
; SLM-NEXT:    ret <4 x i64> [[TMP3]]
;
; AVX-LABEL: @loadext_4i16_to_4i64(
; AVX-NEXT:    [[P1:%.*]] = getelementptr inbounds i16, i16* [[P0:%.*]], i64 1
; AVX-NEXT:    [[P2:%.*]] = getelementptr inbounds i16, i16* [[P0]], i64 2
; AVX-NEXT:    [[P3:%.*]] = getelementptr inbounds i16, i16* [[P0]], i64 3
; AVX-NEXT:    [[TMP1:%.*]] = bitcast i16* [[P0]] to <4 x i16>*
; AVX-NEXT:    [[TMP2:%.*]] = load <4 x i16>, <4 x i16>* [[TMP1]], align 1
; AVX-NEXT:    [[TMP3:%.*]] = sext <4 x i16> [[TMP2]] to <4 x i64>
; AVX-NEXT:    ret <4 x i64> [[TMP3]]
;
  %p1 = getelementptr inbounds i16, i16* %p0, i64 1
  %p2 = getelementptr inbounds i16, i16* %p0, i64 2
  %p3 = getelementptr inbounds i16, i16* %p0, i64 3
  %i0 = load i16, i16* %p0, align 1
  %i1 = load i16, i16* %p1, align 1
  %i2 = load i16, i16* %p2, align 1
  %i3 = load i16, i16* %p3, align 1
  %x0 = sext i16 %i0 to i64
  %x1 = sext i16 %i1 to i64
  %x2 = sext i16 %i2 to i64
  %x3 = sext i16 %i3 to i64
  %v0 = insertelement <4 x i64> poison, i64 %x0, i32 0
  %v1 = insertelement <4 x i64>   %v0, i64 %x1, i32 1
  %v2 = insertelement <4 x i64>   %v1, i64 %x2, i32 2
  %v3 = insertelement <4 x i64>   %v2, i64 %x3, i32 3
  ret <4 x i64> %v3
}

define <8 x i32> @loadext_8i16_to_8i32(i16* %p0) {
; SSE-LABEL: @loadext_8i16_to_8i32(
; SSE-NEXT:    [[P1:%.*]] = getelementptr inbounds i16, i16* [[P0:%.*]], i64 1
; SSE-NEXT:    [[P2:%.*]] = getelementptr inbounds i16, i16* [[P0]], i64 2
; SSE-NEXT:    [[P3:%.*]] = getelementptr inbounds i16, i16* [[P0]], i64 3
; SSE-NEXT:    [[P4:%.*]] = getelementptr inbounds i16, i16* [[P0]], i64 4
; SSE-NEXT:    [[P5:%.*]] = getelementptr inbounds i16, i16* [[P0]], i64 5
; SSE-NEXT:    [[P6:%.*]] = getelementptr inbounds i16, i16* [[P0]], i64 6
; SSE-NEXT:    [[P7:%.*]] = getelementptr inbounds i16, i16* [[P0]], i64 7
; SSE-NEXT:    [[TMP1:%.*]] = bitcast i16* [[P0]] to <8 x i16>*
; SSE-NEXT:    [[TMP2:%.*]] = load <8 x i16>, <8 x i16>* [[TMP1]], align 1
; SSE-NEXT:    [[TMP3:%.*]] = sext <8 x i16> [[TMP2]] to <8 x i32>
; SSE-NEXT:    ret <8 x i32> [[TMP3]]
;
; AVX-LABEL: @loadext_8i16_to_8i32(
; AVX-NEXT:    [[P1:%.*]] = getelementptr inbounds i16, i16* [[P0:%.*]], i64 1
; AVX-NEXT:    [[P2:%.*]] = getelementptr inbounds i16, i16* [[P0]], i64 2
; AVX-NEXT:    [[P3:%.*]] = getelementptr inbounds i16, i16* [[P0]], i64 3
; AVX-NEXT:    [[P4:%.*]] = getelementptr inbounds i16, i16* [[P0]], i64 4
; AVX-NEXT:    [[P5:%.*]] = getelementptr inbounds i16, i16* [[P0]], i64 5
; AVX-NEXT:    [[P6:%.*]] = getelementptr inbounds i16, i16* [[P0]], i64 6
; AVX-NEXT:    [[P7:%.*]] = getelementptr inbounds i16, i16* [[P0]], i64 7
; AVX-NEXT:    [[TMP1:%.*]] = bitcast i16* [[P0]] to <8 x i16>*
; AVX-NEXT:    [[TMP2:%.*]] = load <8 x i16>, <8 x i16>* [[TMP1]], align 1
; AVX-NEXT:    [[TMP3:%.*]] = sext <8 x i16> [[TMP2]] to <8 x i32>
; AVX-NEXT:    ret <8 x i32> [[TMP3]]
;
  %p1 = getelementptr inbounds i16, i16* %p0, i64 1
  %p2 = getelementptr inbounds i16, i16* %p0, i64 2
  %p3 = getelementptr inbounds i16, i16* %p0, i64 3
  %p4 = getelementptr inbounds i16, i16* %p0, i64 4
  %p5 = getelementptr inbounds i16, i16* %p0, i64 5
  %p6 = getelementptr inbounds i16, i16* %p0, i64 6
  %p7 = getelementptr inbounds i16, i16* %p0, i64 7
  %i0 = load i16, i16* %p0, align 1
  %i1 = load i16, i16* %p1, align 1
  %i2 = load i16, i16* %p2, align 1
  %i3 = load i16, i16* %p3, align 1
  %i4 = load i16, i16* %p4, align 1
  %i5 = load i16, i16* %p5, align 1
  %i6 = load i16, i16* %p6, align 1
  %i7 = load i16, i16* %p7, align 1
  %x0 = sext i16 %i0 to i32
  %x1 = sext i16 %i1 to i32
  %x2 = sext i16 %i2 to i32
  %x3 = sext i16 %i3 to i32
  %x4 = sext i16 %i4 to i32
  %x5 = sext i16 %i5 to i32
  %x6 = sext i16 %i6 to i32
  %x7 = sext i16 %i7 to i32
  %v0 = insertelement <8 x i32> poison, i32 %x0, i32 0
  %v1 = insertelement <8 x i32>   %v0, i32 %x1, i32 1
  %v2 = insertelement <8 x i32>   %v1, i32 %x2, i32 2
  %v3 = insertelement <8 x i32>   %v2, i32 %x3, i32 3
  %v4 = insertelement <8 x i32>   %v3, i32 %x4, i32 4
  %v5 = insertelement <8 x i32>   %v4, i32 %x5, i32 5
  %v6 = insertelement <8 x i32>   %v5, i32 %x6, i32 6
  %v7 = insertelement <8 x i32>   %v6, i32 %x7, i32 7
  ret <8 x i32> %v7
}

;
; vXi32
;

define <2 x i64> @loadext_2i32_to_2i64(i32* %p0) {
; SSE-LABEL: @loadext_2i32_to_2i64(
; SSE-NEXT:    [[P1:%.*]] = getelementptr inbounds i32, i32* [[P0:%.*]], i64 1
; SSE-NEXT:    [[TMP1:%.*]] = bitcast i32* [[P0]] to <2 x i32>*
; SSE-NEXT:    [[TMP2:%.*]] = load <2 x i32>, <2 x i32>* [[TMP1]], align 1
; SSE-NEXT:    [[TMP3:%.*]] = sext <2 x i32> [[TMP2]] to <2 x i64>
; SSE-NEXT:    ret <2 x i64> [[TMP3]]
;
; AVX-LABEL: @loadext_2i32_to_2i64(
; AVX-NEXT:    [[P1:%.*]] = getelementptr inbounds i32, i32* [[P0:%.*]], i64 1
; AVX-NEXT:    [[TMP1:%.*]] = bitcast i32* [[P0]] to <2 x i32>*
; AVX-NEXT:    [[TMP2:%.*]] = load <2 x i32>, <2 x i32>* [[TMP1]], align 1
; AVX-NEXT:    [[TMP3:%.*]] = sext <2 x i32> [[TMP2]] to <2 x i64>
; AVX-NEXT:    ret <2 x i64> [[TMP3]]
;
  %p1 = getelementptr inbounds i32, i32* %p0, i64 1
  %i0 = load i32, i32* %p0, align 1
  %i1 = load i32, i32* %p1, align 1
  %x0 = sext i32 %i0 to i64
  %x1 = sext i32 %i1 to i64
  %v0 = insertelement <2 x i64> poison, i64 %x0, i32 0
  %v1 = insertelement <2 x i64>   %v0, i64 %x1, i32 1
  ret <2 x i64> %v1
}

define <4 x i64> @loadext_4i32_to_4i64(i32* %p0) {
; SSE-LABEL: @loadext_4i32_to_4i64(
; SSE-NEXT:    [[P1:%.*]] = getelementptr inbounds i32, i32* [[P0:%.*]], i64 1
; SSE-NEXT:    [[P2:%.*]] = getelementptr inbounds i32, i32* [[P0]], i64 2
; SSE-NEXT:    [[P3:%.*]] = getelementptr inbounds i32, i32* [[P0]], i64 3
; SSE-NEXT:    [[TMP1:%.*]] = bitcast i32* [[P0]] to <4 x i32>*
; SSE-NEXT:    [[TMP2:%.*]] = load <4 x i32>, <4 x i32>* [[TMP1]], align 1
; SSE-NEXT:    [[TMP3:%.*]] = sext <4 x i32> [[TMP2]] to <4 x i64>
; SSE-NEXT:    ret <4 x i64> [[TMP3]]
;
; AVX-LABEL: @loadext_4i32_to_4i64(
; AVX-NEXT:    [[P1:%.*]] = getelementptr inbounds i32, i32* [[P0:%.*]], i64 1
; AVX-NEXT:    [[P2:%.*]] = getelementptr inbounds i32, i32* [[P0]], i64 2
; AVX-NEXT:    [[P3:%.*]] = getelementptr inbounds i32, i32* [[P0]], i64 3
; AVX-NEXT:    [[TMP1:%.*]] = bitcast i32* [[P0]] to <4 x i32>*
; AVX-NEXT:    [[TMP2:%.*]] = load <4 x i32>, <4 x i32>* [[TMP1]], align 1
; AVX-NEXT:    [[TMP3:%.*]] = sext <4 x i32> [[TMP2]] to <4 x i64>
; AVX-NEXT:    ret <4 x i64> [[TMP3]]
;
  %p1 = getelementptr inbounds i32, i32* %p0, i64 1
  %p2 = getelementptr inbounds i32, i32* %p0, i64 2
  %p3 = getelementptr inbounds i32, i32* %p0, i64 3
  %i0 = load i32, i32* %p0, align 1
  %i1 = load i32, i32* %p1, align 1
  %i2 = load i32, i32* %p2, align 1
  %i3 = load i32, i32* %p3, align 1
  %x0 = sext i32 %i0 to i64
  %x1 = sext i32 %i1 to i64
  %x2 = sext i32 %i2 to i64
  %x3 = sext i32 %i3 to i64
  %v0 = insertelement <4 x i64> poison, i64 %x0, i32 0
  %v1 = insertelement <4 x i64>   %v0, i64 %x1, i32 1
  %v2 = insertelement <4 x i64>   %v1, i64 %x2, i32 2
  %v3 = insertelement <4 x i64>   %v2, i64 %x3, i32 3
  ret <4 x i64> %v3
}
