; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -interleaved-access -S %s | FileCheck %s

target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.15.0"

; No interleaved load instruction is generated, but the shuffle is moved just
; after the load.
define <2 x double> @shuffle_binop_fol(<4 x double>* %ptr) {
; CHECK-LABEL: @shuffle_binop_fol(
; CHECK-NEXT:  vector.body.preheader:
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <4 x double>, <4 x double>* [[PTR:%.*]], align 8
; CHECK-NEXT:    [[EXTRACTED1:%.*]] = shufflevector <4 x double> [[WIDE_LOAD]], <4 x double> poison, <2 x i32> <i32 0, i32 2>
; CHECK-NEXT:    [[EXTRACTED2:%.*]] = shufflevector <4 x double> <double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00>, <4 x double> poison, <2 x i32> <i32 0, i32 2>
; CHECK-NEXT:    [[FADD3:%.*]] = fadd <2 x double> [[EXTRACTED1]], [[EXTRACTED2]]
; CHECK-NEXT:    ret <2 x double> [[FADD3]]
;
vector.body.preheader:
  %wide.load = load <4 x double>, <4 x double>* %ptr, align 8
  %fadd = fadd <4 x double> %wide.load, <double 1.0, double 1.0, double 1.0, double 1.0>
  %extracted = shufflevector <4 x double> %fadd, <4 x double> undef, <2 x i32> <i32 0, i32 2>
  ret <2 x double> %extracted
}

define <2 x double> @shuffle_binop_fol_oob(<4 x double>* %ptr) {
; CHECK-LABEL: @shuffle_binop_fol_oob(
; CHECK-NEXT:  vector.body.preheader:
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <4 x double>, <4 x double>* [[PTR:%.*]], align 8
; CHECK-NEXT:    [[FADD:%.*]] = fadd <4 x double> [[WIDE_LOAD]], <double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00>
; CHECK-NEXT:    [[EXTRACTED:%.*]] = shufflevector <4 x double> [[FADD]], <4 x double> undef, <2 x i32> <i32 0, i32 4>
; CHECK-NEXT:    ret <2 x double> [[EXTRACTED]]
;
vector.body.preheader:
  %wide.load = load <4 x double>, <4 x double>* %ptr, align 8
  %fadd = fadd <4 x double> %wide.load, <double 1.0, double 1.0, double 1.0, double 1.0>
  %extracted = shufflevector <4 x double> %fadd, <4 x double> undef, <2 x i32> <i32 0, i32 4>
  ret <2 x double> %extracted
}

; No interleaved load instruction is generated, but the extractelement
; instructions are updated to use the shuffle instead of the load.
define void @shuffle_extract(<4 x double>* %ptr, i1 %c) {
; CHECK-LABEL: @shuffle_extract(
; CHECK-NEXT:  vector.body.preheader:
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <4 x double>, <4 x double>* [[PTR:%.*]], align 8
; CHECK-NEXT:    [[EXTRACTED:%.*]] = shufflevector <4 x double> [[WIDE_LOAD]], <4 x double> undef, <2 x i32> <i32 0, i32 2>
; CHECK-NEXT:    br i1 [[C:%.*]], label [[IF_THEN:%.*]], label [[IF_MERGE:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    [[TMP0:%.*]] = extractelement <2 x double> [[EXTRACTED]], i64 0
; CHECK-NEXT:    call void @use(double [[TMP0]])
; CHECK-NEXT:    br label [[IF_MERGE]]
; CHECK:       if.merge:
; CHECK-NEXT:    [[TMP1:%.*]] = extractelement <2 x double> [[EXTRACTED]], i64 1
; CHECK-NEXT:    call void @use(double [[TMP1]])
; CHECK-NEXT:    ret void
;
vector.body.preheader:
  %wide.load = load <4 x double>, <4 x double>* %ptr, align 8
  %extracted = shufflevector <4 x double> %wide.load, <4 x double> undef, <2 x i32> <i32 0, i32 2>
  br i1 %c, label %if.then, label %if.merge

if.then:
  %e0 = extractelement <4 x double> %wide.load, i32 0
  call void @use(double %e0)
  br label %if.merge

if.merge:
  %e1 = extractelement <4 x double> %wide.load, i32 2
  call void @use(double %e1)
  ret void
}

declare void @use(double)
