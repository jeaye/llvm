; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -slp-vectorizer -S | FileCheck %s

target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-unknown-linux-gnu"

define <2 x float> @insertelement-fixed-vector() {
; CHECK-LABEL: @insertelement-fixed-vector(
; CHECK-NEXT:    [[TMP1:%.*]] = call fast <2 x float> @llvm.fabs.v2f32(<2 x float> poison)
; CHECK-NEXT:    ret <2 x float> [[TMP1]]
;
  %f0 = tail call fast float @llvm.fabs.f32(float undef)
  %f1 = tail call fast float @llvm.fabs.f32(float undef)
  %i0 = insertelement <2 x float> undef, float %f0, i32 0
  %i1 = insertelement <2 x float> %i0, float %f1, i32 1
  ret <2 x float> %i1
}

; TODO: llvm.fabs could be optimized in vector form. It's legal to extract
; elements from fixed-length vector and insert into scalable vector.
define <vscale x 2 x float> @insertelement-scalable-vector() {
; CHECK-LABEL: @insertelement-scalable-vector(
; CHECK-NEXT:    [[F0:%.*]] = tail call fast float @llvm.fabs.f32(float undef)
; CHECK-NEXT:    [[F1:%.*]] = tail call fast float @llvm.fabs.f32(float undef)
; CHECK-NEXT:    [[I0:%.*]] = insertelement <vscale x 2 x float> undef, float [[F0]], i32 0
; CHECK-NEXT:    [[I1:%.*]] = insertelement <vscale x 2 x float> [[I0]], float [[F1]], i32 1
; CHECK-NEXT:    ret <vscale x 2 x float> [[I1]]
;
  %f0 = tail call fast float @llvm.fabs.f32(float undef)
  %f1 = tail call fast float @llvm.fabs.f32(float undef)
  %i0 = insertelement <vscale x 2 x float> undef, float %f0, i32 0
  %i1 = insertelement <vscale x 2 x float> %i0, float %f1, i32 1
  ret <vscale x 2 x float> %i1
}

; Function Attrs: nounwind readnone speculatable willreturn
declare float @llvm.fabs.f32(float)
