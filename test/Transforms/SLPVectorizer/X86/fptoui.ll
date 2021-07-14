; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -mtriple=x86_64-unknown -basic-aa -slp-vectorizer -S | FileCheck %s --check-prefixes=CHECK,SSE
; RUN: opt < %s -mtriple=x86_64-unknown -mcpu=corei7-avx -basic-aa -slp-vectorizer -S | FileCheck %s --check-prefixes=CHECK,AVX,AVX256NODQ
; RUN: opt < %s -mtriple=x86_64-unknown -mcpu=bdver1 -basic-aa -slp-vectorizer -S | FileCheck %s --check-prefixes=CHECK,AVX,AVX256NODQ
; RUN: opt < %s -mtriple=x86_64-unknown -mcpu=core-avx2 -basic-aa -slp-vectorizer -S | FileCheck %s --check-prefixes=CHECK,AVX,AVX256NODQ
; RUN: opt < %s -mtriple=x86_64-unknown -mcpu=skylake-avx512 -mattr=-prefer-256-bit -basic-aa -slp-vectorizer -S | FileCheck %s --check-prefixes=CHECK,AVX,AVX512F
; RUN: opt < %s -mtriple=x86_64-unknown -mcpu=skylake-avx512 -mattr=+prefer-256-bit -basic-aa -slp-vectorizer -S | FileCheck %s --check-prefixes=CHECK,AVX,AVX256DQ

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

@src64 = common global [8 x double] zeroinitializer, align 64
@src32 = common global [16 x float] zeroinitializer, align 64
@dst64 = common global [8 x i64] zeroinitializer, align 64
@dst32 = common global [16 x i32] zeroinitializer, align 64
@dst16 = common global [32 x i16] zeroinitializer, align 64
@dst8 = common global [64 x i8] zeroinitializer, align 64

;
; FPTOUI vXf64
;

define void @fptoui_8f64_8i64() #0 {
; SSE-LABEL: @fptoui_8f64_8i64(
; SSE-NEXT:    [[A0:%.*]] = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 0), align 8
; SSE-NEXT:    [[A1:%.*]] = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 1), align 8
; SSE-NEXT:    [[A2:%.*]] = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 2), align 8
; SSE-NEXT:    [[A3:%.*]] = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 3), align 8
; SSE-NEXT:    [[A4:%.*]] = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 4), align 8
; SSE-NEXT:    [[A5:%.*]] = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 5), align 8
; SSE-NEXT:    [[A6:%.*]] = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 6), align 8
; SSE-NEXT:    [[A7:%.*]] = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 7), align 8
; SSE-NEXT:    [[CVT0:%.*]] = fptoui double [[A0]] to i64
; SSE-NEXT:    [[CVT1:%.*]] = fptoui double [[A1]] to i64
; SSE-NEXT:    [[CVT2:%.*]] = fptoui double [[A2]] to i64
; SSE-NEXT:    [[CVT3:%.*]] = fptoui double [[A3]] to i64
; SSE-NEXT:    [[CVT4:%.*]] = fptoui double [[A4]] to i64
; SSE-NEXT:    [[CVT5:%.*]] = fptoui double [[A5]] to i64
; SSE-NEXT:    [[CVT6:%.*]] = fptoui double [[A6]] to i64
; SSE-NEXT:    [[CVT7:%.*]] = fptoui double [[A7]] to i64
; SSE-NEXT:    store i64 [[CVT0]], i64* getelementptr inbounds ([8 x i64], [8 x i64]* @dst64, i32 0, i64 0), align 8
; SSE-NEXT:    store i64 [[CVT1]], i64* getelementptr inbounds ([8 x i64], [8 x i64]* @dst64, i32 0, i64 1), align 8
; SSE-NEXT:    store i64 [[CVT2]], i64* getelementptr inbounds ([8 x i64], [8 x i64]* @dst64, i32 0, i64 2), align 8
; SSE-NEXT:    store i64 [[CVT3]], i64* getelementptr inbounds ([8 x i64], [8 x i64]* @dst64, i32 0, i64 3), align 8
; SSE-NEXT:    store i64 [[CVT4]], i64* getelementptr inbounds ([8 x i64], [8 x i64]* @dst64, i32 0, i64 4), align 8
; SSE-NEXT:    store i64 [[CVT5]], i64* getelementptr inbounds ([8 x i64], [8 x i64]* @dst64, i32 0, i64 5), align 8
; SSE-NEXT:    store i64 [[CVT6]], i64* getelementptr inbounds ([8 x i64], [8 x i64]* @dst64, i32 0, i64 6), align 8
; SSE-NEXT:    store i64 [[CVT7]], i64* getelementptr inbounds ([8 x i64], [8 x i64]* @dst64, i32 0, i64 7), align 8
; SSE-NEXT:    ret void
;
; AVX256NODQ-LABEL: @fptoui_8f64_8i64(
; AVX256NODQ-NEXT:    [[A0:%.*]] = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 0), align 8
; AVX256NODQ-NEXT:    [[A1:%.*]] = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 1), align 8
; AVX256NODQ-NEXT:    [[A2:%.*]] = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 2), align 8
; AVX256NODQ-NEXT:    [[A3:%.*]] = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 3), align 8
; AVX256NODQ-NEXT:    [[A4:%.*]] = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 4), align 8
; AVX256NODQ-NEXT:    [[A5:%.*]] = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 5), align 8
; AVX256NODQ-NEXT:    [[A6:%.*]] = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 6), align 8
; AVX256NODQ-NEXT:    [[A7:%.*]] = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 7), align 8
; AVX256NODQ-NEXT:    [[CVT0:%.*]] = fptoui double [[A0]] to i64
; AVX256NODQ-NEXT:    [[CVT1:%.*]] = fptoui double [[A1]] to i64
; AVX256NODQ-NEXT:    [[CVT2:%.*]] = fptoui double [[A2]] to i64
; AVX256NODQ-NEXT:    [[CVT3:%.*]] = fptoui double [[A3]] to i64
; AVX256NODQ-NEXT:    [[CVT4:%.*]] = fptoui double [[A4]] to i64
; AVX256NODQ-NEXT:    [[CVT5:%.*]] = fptoui double [[A5]] to i64
; AVX256NODQ-NEXT:    [[CVT6:%.*]] = fptoui double [[A6]] to i64
; AVX256NODQ-NEXT:    [[CVT7:%.*]] = fptoui double [[A7]] to i64
; AVX256NODQ-NEXT:    store i64 [[CVT0]], i64* getelementptr inbounds ([8 x i64], [8 x i64]* @dst64, i32 0, i64 0), align 8
; AVX256NODQ-NEXT:    store i64 [[CVT1]], i64* getelementptr inbounds ([8 x i64], [8 x i64]* @dst64, i32 0, i64 1), align 8
; AVX256NODQ-NEXT:    store i64 [[CVT2]], i64* getelementptr inbounds ([8 x i64], [8 x i64]* @dst64, i32 0, i64 2), align 8
; AVX256NODQ-NEXT:    store i64 [[CVT3]], i64* getelementptr inbounds ([8 x i64], [8 x i64]* @dst64, i32 0, i64 3), align 8
; AVX256NODQ-NEXT:    store i64 [[CVT4]], i64* getelementptr inbounds ([8 x i64], [8 x i64]* @dst64, i32 0, i64 4), align 8
; AVX256NODQ-NEXT:    store i64 [[CVT5]], i64* getelementptr inbounds ([8 x i64], [8 x i64]* @dst64, i32 0, i64 5), align 8
; AVX256NODQ-NEXT:    store i64 [[CVT6]], i64* getelementptr inbounds ([8 x i64], [8 x i64]* @dst64, i32 0, i64 6), align 8
; AVX256NODQ-NEXT:    store i64 [[CVT7]], i64* getelementptr inbounds ([8 x i64], [8 x i64]* @dst64, i32 0, i64 7), align 8
; AVX256NODQ-NEXT:    ret void
;
; AVX512F-LABEL: @fptoui_8f64_8i64(
; AVX512F-NEXT:    [[TMP1:%.*]] = load <8 x double>, <8 x double>* bitcast ([8 x double]* @src64 to <8 x double>*), align 8
; AVX512F-NEXT:    [[TMP2:%.*]] = fptoui <8 x double> [[TMP1]] to <8 x i64>
; AVX512F-NEXT:    store <8 x i64> [[TMP2]], <8 x i64>* bitcast ([8 x i64]* @dst64 to <8 x i64>*), align 8
; AVX512F-NEXT:    ret void
;
; AVX256DQ-LABEL: @fptoui_8f64_8i64(
; AVX256DQ-NEXT:    [[TMP1:%.*]] = load <4 x double>, <4 x double>* bitcast ([8 x double]* @src64 to <4 x double>*), align 8
; AVX256DQ-NEXT:    [[TMP2:%.*]] = load <4 x double>, <4 x double>* bitcast (double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 4) to <4 x double>*), align 8
; AVX256DQ-NEXT:    [[TMP3:%.*]] = fptoui <4 x double> [[TMP1]] to <4 x i64>
; AVX256DQ-NEXT:    [[TMP4:%.*]] = fptoui <4 x double> [[TMP2]] to <4 x i64>
; AVX256DQ-NEXT:    store <4 x i64> [[TMP3]], <4 x i64>* bitcast ([8 x i64]* @dst64 to <4 x i64>*), align 8
; AVX256DQ-NEXT:    store <4 x i64> [[TMP4]], <4 x i64>* bitcast (i64* getelementptr inbounds ([8 x i64], [8 x i64]* @dst64, i32 0, i64 4) to <4 x i64>*), align 8
; AVX256DQ-NEXT:    ret void
;
  %a0 = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 0), align 8
  %a1 = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 1), align 8
  %a2 = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 2), align 8
  %a3 = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 3), align 8
  %a4 = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 4), align 8
  %a5 = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 5), align 8
  %a6 = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 6), align 8
  %a7 = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 7), align 8
  %cvt0 = fptoui double %a0 to i64
  %cvt1 = fptoui double %a1 to i64
  %cvt2 = fptoui double %a2 to i64
  %cvt3 = fptoui double %a3 to i64
  %cvt4 = fptoui double %a4 to i64
  %cvt5 = fptoui double %a5 to i64
  %cvt6 = fptoui double %a6 to i64
  %cvt7 = fptoui double %a7 to i64
  store i64 %cvt0, i64* getelementptr inbounds ([8 x i64], [8 x i64]* @dst64, i32 0, i64 0), align 8
  store i64 %cvt1, i64* getelementptr inbounds ([8 x i64], [8 x i64]* @dst64, i32 0, i64 1), align 8
  store i64 %cvt2, i64* getelementptr inbounds ([8 x i64], [8 x i64]* @dst64, i32 0, i64 2), align 8
  store i64 %cvt3, i64* getelementptr inbounds ([8 x i64], [8 x i64]* @dst64, i32 0, i64 3), align 8
  store i64 %cvt4, i64* getelementptr inbounds ([8 x i64], [8 x i64]* @dst64, i32 0, i64 4), align 8
  store i64 %cvt5, i64* getelementptr inbounds ([8 x i64], [8 x i64]* @dst64, i32 0, i64 5), align 8
  store i64 %cvt6, i64* getelementptr inbounds ([8 x i64], [8 x i64]* @dst64, i32 0, i64 6), align 8
  store i64 %cvt7, i64* getelementptr inbounds ([8 x i64], [8 x i64]* @dst64, i32 0, i64 7), align 8
  ret void
}

define void @fptoui_8f64_8i32() #0 {
; SSE-LABEL: @fptoui_8f64_8i32(
; SSE-NEXT:    [[TMP1:%.*]] = load <4 x double>, <4 x double>* bitcast ([8 x double]* @src64 to <4 x double>*), align 8
; SSE-NEXT:    [[TMP2:%.*]] = load <4 x double>, <4 x double>* bitcast (double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 4) to <4 x double>*), align 8
; SSE-NEXT:    [[TMP3:%.*]] = fptoui <4 x double> [[TMP1]] to <4 x i32>
; SSE-NEXT:    [[TMP4:%.*]] = fptoui <4 x double> [[TMP2]] to <4 x i32>
; SSE-NEXT:    store <4 x i32> [[TMP3]], <4 x i32>* bitcast ([16 x i32]* @dst32 to <4 x i32>*), align 4
; SSE-NEXT:    store <4 x i32> [[TMP4]], <4 x i32>* bitcast (i32* getelementptr inbounds ([16 x i32], [16 x i32]* @dst32, i32 0, i64 4) to <4 x i32>*), align 4
; SSE-NEXT:    ret void
;
; AVX-LABEL: @fptoui_8f64_8i32(
; AVX-NEXT:    [[TMP1:%.*]] = load <8 x double>, <8 x double>* bitcast ([8 x double]* @src64 to <8 x double>*), align 8
; AVX-NEXT:    [[TMP2:%.*]] = fptoui <8 x double> [[TMP1]] to <8 x i32>
; AVX-NEXT:    store <8 x i32> [[TMP2]], <8 x i32>* bitcast ([16 x i32]* @dst32 to <8 x i32>*), align 4
; AVX-NEXT:    ret void
;
  %a0 = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 0), align 8
  %a1 = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 1), align 8
  %a2 = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 2), align 8
  %a3 = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 3), align 8
  %a4 = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 4), align 8
  %a5 = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 5), align 8
  %a6 = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 6), align 8
  %a7 = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 7), align 8
  %cvt0 = fptoui double %a0 to i32
  %cvt1 = fptoui double %a1 to i32
  %cvt2 = fptoui double %a2 to i32
  %cvt3 = fptoui double %a3 to i32
  %cvt4 = fptoui double %a4 to i32
  %cvt5 = fptoui double %a5 to i32
  %cvt6 = fptoui double %a6 to i32
  %cvt7 = fptoui double %a7 to i32
  store i32 %cvt0, i32* getelementptr inbounds ([16 x i32], [16 x i32]* @dst32, i32 0, i64 0), align 4
  store i32 %cvt1, i32* getelementptr inbounds ([16 x i32], [16 x i32]* @dst32, i32 0, i64 1), align 4
  store i32 %cvt2, i32* getelementptr inbounds ([16 x i32], [16 x i32]* @dst32, i32 0, i64 2), align 4
  store i32 %cvt3, i32* getelementptr inbounds ([16 x i32], [16 x i32]* @dst32, i32 0, i64 3), align 4
  store i32 %cvt4, i32* getelementptr inbounds ([16 x i32], [16 x i32]* @dst32, i32 0, i64 4), align 4
  store i32 %cvt5, i32* getelementptr inbounds ([16 x i32], [16 x i32]* @dst32, i32 0, i64 5), align 4
  store i32 %cvt6, i32* getelementptr inbounds ([16 x i32], [16 x i32]* @dst32, i32 0, i64 6), align 4
  store i32 %cvt7, i32* getelementptr inbounds ([16 x i32], [16 x i32]* @dst32, i32 0, i64 7), align 4
  ret void
}

define void @fptoui_8f64_8i16() #0 {
; CHECK-LABEL: @fptoui_8f64_8i16(
; CHECK-NEXT:    [[TMP1:%.*]] = load <8 x double>, <8 x double>* bitcast ([8 x double]* @src64 to <8 x double>*), align 8
; CHECK-NEXT:    [[TMP2:%.*]] = fptoui <8 x double> [[TMP1]] to <8 x i16>
; CHECK-NEXT:    store <8 x i16> [[TMP2]], <8 x i16>* bitcast ([32 x i16]* @dst16 to <8 x i16>*), align 2
; CHECK-NEXT:    ret void
;
  %a0 = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 0), align 8
  %a1 = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 1), align 8
  %a2 = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 2), align 8
  %a3 = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 3), align 8
  %a4 = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 4), align 8
  %a5 = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 5), align 8
  %a6 = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 6), align 8
  %a7 = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 7), align 8
  %cvt0 = fptoui double %a0 to i16
  %cvt1 = fptoui double %a1 to i16
  %cvt2 = fptoui double %a2 to i16
  %cvt3 = fptoui double %a3 to i16
  %cvt4 = fptoui double %a4 to i16
  %cvt5 = fptoui double %a5 to i16
  %cvt6 = fptoui double %a6 to i16
  %cvt7 = fptoui double %a7 to i16
  store i16 %cvt0, i16* getelementptr inbounds ([32 x i16], [32 x i16]* @dst16, i32 0, i64 0), align 2
  store i16 %cvt1, i16* getelementptr inbounds ([32 x i16], [32 x i16]* @dst16, i32 0, i64 1), align 2
  store i16 %cvt2, i16* getelementptr inbounds ([32 x i16], [32 x i16]* @dst16, i32 0, i64 2), align 2
  store i16 %cvt3, i16* getelementptr inbounds ([32 x i16], [32 x i16]* @dst16, i32 0, i64 3), align 2
  store i16 %cvt4, i16* getelementptr inbounds ([32 x i16], [32 x i16]* @dst16, i32 0, i64 4), align 2
  store i16 %cvt5, i16* getelementptr inbounds ([32 x i16], [32 x i16]* @dst16, i32 0, i64 5), align 2
  store i16 %cvt6, i16* getelementptr inbounds ([32 x i16], [32 x i16]* @dst16, i32 0, i64 6), align 2
  store i16 %cvt7, i16* getelementptr inbounds ([32 x i16], [32 x i16]* @dst16, i32 0, i64 7), align 2
  ret void
}

define void @fptoui_8f64_8i8() #0 {
; CHECK-LABEL: @fptoui_8f64_8i8(
; CHECK-NEXT:    [[A0:%.*]] = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 0), align 8
; CHECK-NEXT:    [[A1:%.*]] = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 1), align 8
; CHECK-NEXT:    [[A2:%.*]] = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 2), align 8
; CHECK-NEXT:    [[A3:%.*]] = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 3), align 8
; CHECK-NEXT:    [[A4:%.*]] = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 4), align 8
; CHECK-NEXT:    [[A5:%.*]] = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 5), align 8
; CHECK-NEXT:    [[A6:%.*]] = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 6), align 8
; CHECK-NEXT:    [[A7:%.*]] = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 7), align 8
; CHECK-NEXT:    [[CVT0:%.*]] = fptoui double [[A0]] to i8
; CHECK-NEXT:    [[CVT1:%.*]] = fptoui double [[A1]] to i8
; CHECK-NEXT:    [[CVT2:%.*]] = fptoui double [[A2]] to i8
; CHECK-NEXT:    [[CVT3:%.*]] = fptoui double [[A3]] to i8
; CHECK-NEXT:    [[CVT4:%.*]] = fptoui double [[A4]] to i8
; CHECK-NEXT:    [[CVT5:%.*]] = fptoui double [[A5]] to i8
; CHECK-NEXT:    [[CVT6:%.*]] = fptoui double [[A6]] to i8
; CHECK-NEXT:    [[CVT7:%.*]] = fptoui double [[A7]] to i8
; CHECK-NEXT:    store i8 [[CVT0]], i8* getelementptr inbounds ([64 x i8], [64 x i8]* @dst8, i32 0, i64 0), align 1
; CHECK-NEXT:    store i8 [[CVT1]], i8* getelementptr inbounds ([64 x i8], [64 x i8]* @dst8, i32 0, i64 1), align 1
; CHECK-NEXT:    store i8 [[CVT2]], i8* getelementptr inbounds ([64 x i8], [64 x i8]* @dst8, i32 0, i64 2), align 1
; CHECK-NEXT:    store i8 [[CVT3]], i8* getelementptr inbounds ([64 x i8], [64 x i8]* @dst8, i32 0, i64 3), align 1
; CHECK-NEXT:    store i8 [[CVT4]], i8* getelementptr inbounds ([64 x i8], [64 x i8]* @dst8, i32 0, i64 4), align 1
; CHECK-NEXT:    store i8 [[CVT5]], i8* getelementptr inbounds ([64 x i8], [64 x i8]* @dst8, i32 0, i64 5), align 1
; CHECK-NEXT:    store i8 [[CVT6]], i8* getelementptr inbounds ([64 x i8], [64 x i8]* @dst8, i32 0, i64 6), align 1
; CHECK-NEXT:    store i8 [[CVT7]], i8* getelementptr inbounds ([64 x i8], [64 x i8]* @dst8, i32 0, i64 7), align 1
; CHECK-NEXT:    ret void
;
  %a0 = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 0), align 8
  %a1 = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 1), align 8
  %a2 = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 2), align 8
  %a3 = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 3), align 8
  %a4 = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 4), align 8
  %a5 = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 5), align 8
  %a6 = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 6), align 8
  %a7 = load double, double* getelementptr inbounds ([8 x double], [8 x double]* @src64, i32 0, i64 7), align 8
  %cvt0 = fptoui double %a0 to i8
  %cvt1 = fptoui double %a1 to i8
  %cvt2 = fptoui double %a2 to i8
  %cvt3 = fptoui double %a3 to i8
  %cvt4 = fptoui double %a4 to i8
  %cvt5 = fptoui double %a5 to i8
  %cvt6 = fptoui double %a6 to i8
  %cvt7 = fptoui double %a7 to i8
  store i8 %cvt0, i8* getelementptr inbounds ([64 x i8], [64 x i8]* @dst8, i32 0, i64 0), align 1
  store i8 %cvt1, i8* getelementptr inbounds ([64 x i8], [64 x i8]* @dst8, i32 0, i64 1), align 1
  store i8 %cvt2, i8* getelementptr inbounds ([64 x i8], [64 x i8]* @dst8, i32 0, i64 2), align 1
  store i8 %cvt3, i8* getelementptr inbounds ([64 x i8], [64 x i8]* @dst8, i32 0, i64 3), align 1
  store i8 %cvt4, i8* getelementptr inbounds ([64 x i8], [64 x i8]* @dst8, i32 0, i64 4), align 1
  store i8 %cvt5, i8* getelementptr inbounds ([64 x i8], [64 x i8]* @dst8, i32 0, i64 5), align 1
  store i8 %cvt6, i8* getelementptr inbounds ([64 x i8], [64 x i8]* @dst8, i32 0, i64 6), align 1
  store i8 %cvt7, i8* getelementptr inbounds ([64 x i8], [64 x i8]* @dst8, i32 0, i64 7), align 1
  ret void
}

;
; FPTOUI vXf32
;

define void @fptoui_8f32_8i64() #0 {
; SSE-LABEL: @fptoui_8f32_8i64(
; SSE-NEXT:    [[A0:%.*]] = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 0), align 4
; SSE-NEXT:    [[A1:%.*]] = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 1), align 4
; SSE-NEXT:    [[A2:%.*]] = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 2), align 4
; SSE-NEXT:    [[A3:%.*]] = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 3), align 4
; SSE-NEXT:    [[A4:%.*]] = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 4), align 4
; SSE-NEXT:    [[A5:%.*]] = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 5), align 4
; SSE-NEXT:    [[A6:%.*]] = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 6), align 4
; SSE-NEXT:    [[A7:%.*]] = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 7), align 4
; SSE-NEXT:    [[CVT0:%.*]] = fptoui float [[A0]] to i64
; SSE-NEXT:    [[CVT1:%.*]] = fptoui float [[A1]] to i64
; SSE-NEXT:    [[CVT2:%.*]] = fptoui float [[A2]] to i64
; SSE-NEXT:    [[CVT3:%.*]] = fptoui float [[A3]] to i64
; SSE-NEXT:    [[CVT4:%.*]] = fptoui float [[A4]] to i64
; SSE-NEXT:    [[CVT5:%.*]] = fptoui float [[A5]] to i64
; SSE-NEXT:    [[CVT6:%.*]] = fptoui float [[A6]] to i64
; SSE-NEXT:    [[CVT7:%.*]] = fptoui float [[A7]] to i64
; SSE-NEXT:    store i64 [[CVT0]], i64* getelementptr inbounds ([8 x i64], [8 x i64]* @dst64, i32 0, i64 0), align 8
; SSE-NEXT:    store i64 [[CVT1]], i64* getelementptr inbounds ([8 x i64], [8 x i64]* @dst64, i32 0, i64 1), align 8
; SSE-NEXT:    store i64 [[CVT2]], i64* getelementptr inbounds ([8 x i64], [8 x i64]* @dst64, i32 0, i64 2), align 8
; SSE-NEXT:    store i64 [[CVT3]], i64* getelementptr inbounds ([8 x i64], [8 x i64]* @dst64, i32 0, i64 3), align 8
; SSE-NEXT:    store i64 [[CVT4]], i64* getelementptr inbounds ([8 x i64], [8 x i64]* @dst64, i32 0, i64 4), align 8
; SSE-NEXT:    store i64 [[CVT5]], i64* getelementptr inbounds ([8 x i64], [8 x i64]* @dst64, i32 0, i64 5), align 8
; SSE-NEXT:    store i64 [[CVT6]], i64* getelementptr inbounds ([8 x i64], [8 x i64]* @dst64, i32 0, i64 6), align 8
; SSE-NEXT:    store i64 [[CVT7]], i64* getelementptr inbounds ([8 x i64], [8 x i64]* @dst64, i32 0, i64 7), align 8
; SSE-NEXT:    ret void
;
; AVX256NODQ-LABEL: @fptoui_8f32_8i64(
; AVX256NODQ-NEXT:    [[A0:%.*]] = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 0), align 4
; AVX256NODQ-NEXT:    [[A1:%.*]] = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 1), align 4
; AVX256NODQ-NEXT:    [[A2:%.*]] = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 2), align 4
; AVX256NODQ-NEXT:    [[A3:%.*]] = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 3), align 4
; AVX256NODQ-NEXT:    [[A4:%.*]] = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 4), align 4
; AVX256NODQ-NEXT:    [[A5:%.*]] = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 5), align 4
; AVX256NODQ-NEXT:    [[A6:%.*]] = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 6), align 4
; AVX256NODQ-NEXT:    [[A7:%.*]] = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 7), align 4
; AVX256NODQ-NEXT:    [[CVT0:%.*]] = fptoui float [[A0]] to i64
; AVX256NODQ-NEXT:    [[CVT1:%.*]] = fptoui float [[A1]] to i64
; AVX256NODQ-NEXT:    [[CVT2:%.*]] = fptoui float [[A2]] to i64
; AVX256NODQ-NEXT:    [[CVT3:%.*]] = fptoui float [[A3]] to i64
; AVX256NODQ-NEXT:    [[CVT4:%.*]] = fptoui float [[A4]] to i64
; AVX256NODQ-NEXT:    [[CVT5:%.*]] = fptoui float [[A5]] to i64
; AVX256NODQ-NEXT:    [[CVT6:%.*]] = fptoui float [[A6]] to i64
; AVX256NODQ-NEXT:    [[CVT7:%.*]] = fptoui float [[A7]] to i64
; AVX256NODQ-NEXT:    store i64 [[CVT0]], i64* getelementptr inbounds ([8 x i64], [8 x i64]* @dst64, i32 0, i64 0), align 8
; AVX256NODQ-NEXT:    store i64 [[CVT1]], i64* getelementptr inbounds ([8 x i64], [8 x i64]* @dst64, i32 0, i64 1), align 8
; AVX256NODQ-NEXT:    store i64 [[CVT2]], i64* getelementptr inbounds ([8 x i64], [8 x i64]* @dst64, i32 0, i64 2), align 8
; AVX256NODQ-NEXT:    store i64 [[CVT3]], i64* getelementptr inbounds ([8 x i64], [8 x i64]* @dst64, i32 0, i64 3), align 8
; AVX256NODQ-NEXT:    store i64 [[CVT4]], i64* getelementptr inbounds ([8 x i64], [8 x i64]* @dst64, i32 0, i64 4), align 8
; AVX256NODQ-NEXT:    store i64 [[CVT5]], i64* getelementptr inbounds ([8 x i64], [8 x i64]* @dst64, i32 0, i64 5), align 8
; AVX256NODQ-NEXT:    store i64 [[CVT6]], i64* getelementptr inbounds ([8 x i64], [8 x i64]* @dst64, i32 0, i64 6), align 8
; AVX256NODQ-NEXT:    store i64 [[CVT7]], i64* getelementptr inbounds ([8 x i64], [8 x i64]* @dst64, i32 0, i64 7), align 8
; AVX256NODQ-NEXT:    ret void
;
; AVX512F-LABEL: @fptoui_8f32_8i64(
; AVX512F-NEXT:    [[TMP1:%.*]] = load <8 x float>, <8 x float>* bitcast ([16 x float]* @src32 to <8 x float>*), align 4
; AVX512F-NEXT:    [[TMP2:%.*]] = fptoui <8 x float> [[TMP1]] to <8 x i64>
; AVX512F-NEXT:    store <8 x i64> [[TMP2]], <8 x i64>* bitcast ([8 x i64]* @dst64 to <8 x i64>*), align 8
; AVX512F-NEXT:    ret void
;
; AVX256DQ-LABEL: @fptoui_8f32_8i64(
; AVX256DQ-NEXT:    [[TMP1:%.*]] = load <4 x float>, <4 x float>* bitcast ([16 x float]* @src32 to <4 x float>*), align 4
; AVX256DQ-NEXT:    [[TMP2:%.*]] = load <4 x float>, <4 x float>* bitcast (float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 4) to <4 x float>*), align 4
; AVX256DQ-NEXT:    [[TMP3:%.*]] = fptoui <4 x float> [[TMP1]] to <4 x i64>
; AVX256DQ-NEXT:    [[TMP4:%.*]] = fptoui <4 x float> [[TMP2]] to <4 x i64>
; AVX256DQ-NEXT:    store <4 x i64> [[TMP3]], <4 x i64>* bitcast ([8 x i64]* @dst64 to <4 x i64>*), align 8
; AVX256DQ-NEXT:    store <4 x i64> [[TMP4]], <4 x i64>* bitcast (i64* getelementptr inbounds ([8 x i64], [8 x i64]* @dst64, i32 0, i64 4) to <4 x i64>*), align 8
; AVX256DQ-NEXT:    ret void
;
  %a0 = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 0), align 4
  %a1 = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 1), align 4
  %a2 = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 2), align 4
  %a3 = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 3), align 4
  %a4 = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 4), align 4
  %a5 = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 5), align 4
  %a6 = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 6), align 4
  %a7 = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 7), align 4
  %cvt0 = fptoui float %a0 to i64
  %cvt1 = fptoui float %a1 to i64
  %cvt2 = fptoui float %a2 to i64
  %cvt3 = fptoui float %a3 to i64
  %cvt4 = fptoui float %a4 to i64
  %cvt5 = fptoui float %a5 to i64
  %cvt6 = fptoui float %a6 to i64
  %cvt7 = fptoui float %a7 to i64
  store i64 %cvt0, i64* getelementptr inbounds ([8 x i64], [8 x i64]* @dst64, i32 0, i64 0), align 8
  store i64 %cvt1, i64* getelementptr inbounds ([8 x i64], [8 x i64]* @dst64, i32 0, i64 1), align 8
  store i64 %cvt2, i64* getelementptr inbounds ([8 x i64], [8 x i64]* @dst64, i32 0, i64 2), align 8
  store i64 %cvt3, i64* getelementptr inbounds ([8 x i64], [8 x i64]* @dst64, i32 0, i64 3), align 8
  store i64 %cvt4, i64* getelementptr inbounds ([8 x i64], [8 x i64]* @dst64, i32 0, i64 4), align 8
  store i64 %cvt5, i64* getelementptr inbounds ([8 x i64], [8 x i64]* @dst64, i32 0, i64 5), align 8
  store i64 %cvt6, i64* getelementptr inbounds ([8 x i64], [8 x i64]* @dst64, i32 0, i64 6), align 8
  store i64 %cvt7, i64* getelementptr inbounds ([8 x i64], [8 x i64]* @dst64, i32 0, i64 7), align 8
  ret void
}

define void @fptoui_8f32_8i32() #0 {
; SSE-LABEL: @fptoui_8f32_8i32(
; SSE-NEXT:    [[TMP1:%.*]] = load <4 x float>, <4 x float>* bitcast ([16 x float]* @src32 to <4 x float>*), align 4
; SSE-NEXT:    [[TMP2:%.*]] = load <4 x float>, <4 x float>* bitcast (float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 4) to <4 x float>*), align 4
; SSE-NEXT:    [[TMP3:%.*]] = fptoui <4 x float> [[TMP1]] to <4 x i32>
; SSE-NEXT:    [[TMP4:%.*]] = fptoui <4 x float> [[TMP2]] to <4 x i32>
; SSE-NEXT:    store <4 x i32> [[TMP3]], <4 x i32>* bitcast ([16 x i32]* @dst32 to <4 x i32>*), align 4
; SSE-NEXT:    store <4 x i32> [[TMP4]], <4 x i32>* bitcast (i32* getelementptr inbounds ([16 x i32], [16 x i32]* @dst32, i32 0, i64 4) to <4 x i32>*), align 4
; SSE-NEXT:    ret void
;
; AVX-LABEL: @fptoui_8f32_8i32(
; AVX-NEXT:    [[TMP1:%.*]] = load <8 x float>, <8 x float>* bitcast ([16 x float]* @src32 to <8 x float>*), align 4
; AVX-NEXT:    [[TMP2:%.*]] = fptoui <8 x float> [[TMP1]] to <8 x i32>
; AVX-NEXT:    store <8 x i32> [[TMP2]], <8 x i32>* bitcast ([16 x i32]* @dst32 to <8 x i32>*), align 4
; AVX-NEXT:    ret void
;
  %a0 = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 0), align 4
  %a1 = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 1), align 4
  %a2 = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 2), align 4
  %a3 = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 3), align 4
  %a4 = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 4), align 4
  %a5 = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 5), align 4
  %a6 = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 6), align 4
  %a7 = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 7), align 4
  %cvt0 = fptoui float %a0 to i32
  %cvt1 = fptoui float %a1 to i32
  %cvt2 = fptoui float %a2 to i32
  %cvt3 = fptoui float %a3 to i32
  %cvt4 = fptoui float %a4 to i32
  %cvt5 = fptoui float %a5 to i32
  %cvt6 = fptoui float %a6 to i32
  %cvt7 = fptoui float %a7 to i32
  store i32 %cvt0, i32* getelementptr inbounds ([16 x i32], [16 x i32]* @dst32, i32 0, i64 0), align 4
  store i32 %cvt1, i32* getelementptr inbounds ([16 x i32], [16 x i32]* @dst32, i32 0, i64 1), align 4
  store i32 %cvt2, i32* getelementptr inbounds ([16 x i32], [16 x i32]* @dst32, i32 0, i64 2), align 4
  store i32 %cvt3, i32* getelementptr inbounds ([16 x i32], [16 x i32]* @dst32, i32 0, i64 3), align 4
  store i32 %cvt4, i32* getelementptr inbounds ([16 x i32], [16 x i32]* @dst32, i32 0, i64 4), align 4
  store i32 %cvt5, i32* getelementptr inbounds ([16 x i32], [16 x i32]* @dst32, i32 0, i64 5), align 4
  store i32 %cvt6, i32* getelementptr inbounds ([16 x i32], [16 x i32]* @dst32, i32 0, i64 6), align 4
  store i32 %cvt7, i32* getelementptr inbounds ([16 x i32], [16 x i32]* @dst32, i32 0, i64 7), align 4
  ret void
}

define void @fptoui_8f32_8i16() #0 {
; CHECK-LABEL: @fptoui_8f32_8i16(
; CHECK-NEXT:    [[TMP1:%.*]] = load <8 x float>, <8 x float>* bitcast ([16 x float]* @src32 to <8 x float>*), align 4
; CHECK-NEXT:    [[TMP2:%.*]] = fptoui <8 x float> [[TMP1]] to <8 x i16>
; CHECK-NEXT:    store <8 x i16> [[TMP2]], <8 x i16>* bitcast ([32 x i16]* @dst16 to <8 x i16>*), align 2
; CHECK-NEXT:    ret void
;
  %a0 = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 0), align 4
  %a1 = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 1), align 4
  %a2 = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 2), align 4
  %a3 = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 3), align 4
  %a4 = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 4), align 4
  %a5 = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 5), align 4
  %a6 = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 6), align 4
  %a7 = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 7), align 4
  %cvt0 = fptoui float %a0 to i16
  %cvt1 = fptoui float %a1 to i16
  %cvt2 = fptoui float %a2 to i16
  %cvt3 = fptoui float %a3 to i16
  %cvt4 = fptoui float %a4 to i16
  %cvt5 = fptoui float %a5 to i16
  %cvt6 = fptoui float %a6 to i16
  %cvt7 = fptoui float %a7 to i16
  store i16 %cvt0, i16* getelementptr inbounds ([32 x i16], [32 x i16]* @dst16, i32 0, i64 0), align 2
  store i16 %cvt1, i16* getelementptr inbounds ([32 x i16], [32 x i16]* @dst16, i32 0, i64 1), align 2
  store i16 %cvt2, i16* getelementptr inbounds ([32 x i16], [32 x i16]* @dst16, i32 0, i64 2), align 2
  store i16 %cvt3, i16* getelementptr inbounds ([32 x i16], [32 x i16]* @dst16, i32 0, i64 3), align 2
  store i16 %cvt4, i16* getelementptr inbounds ([32 x i16], [32 x i16]* @dst16, i32 0, i64 4), align 2
  store i16 %cvt5, i16* getelementptr inbounds ([32 x i16], [32 x i16]* @dst16, i32 0, i64 5), align 2
  store i16 %cvt6, i16* getelementptr inbounds ([32 x i16], [32 x i16]* @dst16, i32 0, i64 6), align 2
  store i16 %cvt7, i16* getelementptr inbounds ([32 x i16], [32 x i16]* @dst16, i32 0, i64 7), align 2
  ret void
}

define void @fptoui_8f32_8i8() #0 {
; CHECK-LABEL: @fptoui_8f32_8i8(
; CHECK-NEXT:    [[A0:%.*]] = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 0), align 4
; CHECK-NEXT:    [[A1:%.*]] = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 1), align 4
; CHECK-NEXT:    [[A2:%.*]] = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 2), align 4
; CHECK-NEXT:    [[A3:%.*]] = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 3), align 4
; CHECK-NEXT:    [[A4:%.*]] = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 4), align 4
; CHECK-NEXT:    [[A5:%.*]] = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 5), align 4
; CHECK-NEXT:    [[A6:%.*]] = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 6), align 4
; CHECK-NEXT:    [[A7:%.*]] = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 7), align 4
; CHECK-NEXT:    [[CVT0:%.*]] = fptoui float [[A0]] to i8
; CHECK-NEXT:    [[CVT1:%.*]] = fptoui float [[A1]] to i8
; CHECK-NEXT:    [[CVT2:%.*]] = fptoui float [[A2]] to i8
; CHECK-NEXT:    [[CVT3:%.*]] = fptoui float [[A3]] to i8
; CHECK-NEXT:    [[CVT4:%.*]] = fptoui float [[A4]] to i8
; CHECK-NEXT:    [[CVT5:%.*]] = fptoui float [[A5]] to i8
; CHECK-NEXT:    [[CVT6:%.*]] = fptoui float [[A6]] to i8
; CHECK-NEXT:    [[CVT7:%.*]] = fptoui float [[A7]] to i8
; CHECK-NEXT:    store i8 [[CVT0]], i8* getelementptr inbounds ([64 x i8], [64 x i8]* @dst8, i32 0, i64 0), align 1
; CHECK-NEXT:    store i8 [[CVT1]], i8* getelementptr inbounds ([64 x i8], [64 x i8]* @dst8, i32 0, i64 1), align 1
; CHECK-NEXT:    store i8 [[CVT2]], i8* getelementptr inbounds ([64 x i8], [64 x i8]* @dst8, i32 0, i64 2), align 1
; CHECK-NEXT:    store i8 [[CVT3]], i8* getelementptr inbounds ([64 x i8], [64 x i8]* @dst8, i32 0, i64 3), align 1
; CHECK-NEXT:    store i8 [[CVT4]], i8* getelementptr inbounds ([64 x i8], [64 x i8]* @dst8, i32 0, i64 4), align 1
; CHECK-NEXT:    store i8 [[CVT5]], i8* getelementptr inbounds ([64 x i8], [64 x i8]* @dst8, i32 0, i64 5), align 1
; CHECK-NEXT:    store i8 [[CVT6]], i8* getelementptr inbounds ([64 x i8], [64 x i8]* @dst8, i32 0, i64 6), align 1
; CHECK-NEXT:    store i8 [[CVT7]], i8* getelementptr inbounds ([64 x i8], [64 x i8]* @dst8, i32 0, i64 7), align 1
; CHECK-NEXT:    ret void
;
  %a0 = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 0), align 4
  %a1 = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 1), align 4
  %a2 = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 2), align 4
  %a3 = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 3), align 4
  %a4 = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 4), align 4
  %a5 = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 5), align 4
  %a6 = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 6), align 4
  %a7 = load float, float* getelementptr inbounds ([16 x float], [16 x float]* @src32, i32 0, i64 7), align 4
  %cvt0 = fptoui float %a0 to i8
  %cvt1 = fptoui float %a1 to i8
  %cvt2 = fptoui float %a2 to i8
  %cvt3 = fptoui float %a3 to i8
  %cvt4 = fptoui float %a4 to i8
  %cvt5 = fptoui float %a5 to i8
  %cvt6 = fptoui float %a6 to i8
  %cvt7 = fptoui float %a7 to i8
  store i8 %cvt0, i8* getelementptr inbounds ([64 x i8], [64 x i8]* @dst8, i32 0, i64 0), align 1
  store i8 %cvt1, i8* getelementptr inbounds ([64 x i8], [64 x i8]* @dst8, i32 0, i64 1), align 1
  store i8 %cvt2, i8* getelementptr inbounds ([64 x i8], [64 x i8]* @dst8, i32 0, i64 2), align 1
  store i8 %cvt3, i8* getelementptr inbounds ([64 x i8], [64 x i8]* @dst8, i32 0, i64 3), align 1
  store i8 %cvt4, i8* getelementptr inbounds ([64 x i8], [64 x i8]* @dst8, i32 0, i64 4), align 1
  store i8 %cvt5, i8* getelementptr inbounds ([64 x i8], [64 x i8]* @dst8, i32 0, i64 5), align 1
  store i8 %cvt6, i8* getelementptr inbounds ([64 x i8], [64 x i8]* @dst8, i32 0, i64 6), align 1
  store i8 %cvt7, i8* getelementptr inbounds ([64 x i8], [64 x i8]* @dst8, i32 0, i64 7), align 1
  ret void
}

attributes #0 = { nounwind }
