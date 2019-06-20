; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basicaa -slp-vectorizer -dce -S -mtriple=x86_64-apple-macosx10.8.0 -mcpu=corei7 | FileCheck %s

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.8.0"

%struct.GPar.0.16.26 = type { [0 x double], double }

@d = external global double, align 8

declare %struct.GPar.0.16.26* @Rf_gpptr(...)

define void @Rf_GReset() {
; CHECK-LABEL: @Rf_GReset(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load double, double* @d, align 8
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <2 x double> undef, double [[TMP0]], i32 1
; CHECK-NEXT:    [[TMP2:%.*]] = fsub <2 x double> <double -0.000000e+00, double -0.000000e+00>, [[TMP1]]
; CHECK-NEXT:    br i1 icmp eq (%struct.GPar.0.16.26* (...)* inttoptr (i64 115 to %struct.GPar.0.16.26* (...)*), %struct.GPar.0.16.26* (...)* @Rf_gpptr), label [[IF_THEN:%.*]], label [[IF_END7:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    [[TMP3:%.*]] = fsub <2 x double> [[TMP2]], undef
; CHECK-NEXT:    [[TMP4:%.*]] = fdiv <2 x double> [[TMP3]], undef
; CHECK-NEXT:    [[TMP5:%.*]] = extractelement <2 x double> [[TMP4]], i32 0
; CHECK-NEXT:    [[TMP6:%.*]] = extractelement <2 x double> [[TMP4]], i32 1
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ogt double [[TMP5]], [[TMP6]]
; CHECK-NEXT:    br i1 [[CMP]], label [[IF_THEN6:%.*]], label [[IF_END7]]
; CHECK:       if.then6:
; CHECK-NEXT:    br label [[IF_END7]]
; CHECK:       if.end7:
; CHECK-NEXT:    ret void
;
entry:
  %sub = fsub double -0.000000e+00, undef
  %0 = load double, double* @d, align 8
  %sub1 = fsub double -0.000000e+00, %0
  br i1 icmp eq (%struct.GPar.0.16.26* (...)* inttoptr (i64 115 to %struct.GPar.0.16.26* (...)*), %struct.GPar.0.16.26* (...)* @Rf_gpptr), label %if.then, label %if.end7

if.then:                                          ; preds = %entry
  %sub2 = fsub double %sub, undef
  %div.i = fdiv double %sub2, undef
  %sub4 = fsub double %sub1, undef
  %div.i16 = fdiv double %sub4, undef
  %cmp = fcmp ogt double %div.i, %div.i16
  br i1 %cmp, label %if.then6, label %if.end7

if.then6:                                         ; preds = %if.then
  br label %if.end7

if.end7:                                          ; preds = %if.then6, %if.then, %entry
  %g.0 = phi double [ 0.000000e+00, %if.then6 ], [ %sub, %if.then ], [ %sub, %entry ]
  ret void
}

define void @Rf_GReset_unary_fneg() {
; CHECK-LABEL: @Rf_GReset_unary_fneg(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SUB:%.*]] = fneg double undef
; CHECK-NEXT:    [[TMP0:%.*]] = load double, double* @d, align 8
; CHECK-NEXT:    [[SUB1:%.*]] = fneg double [[TMP0]]
; CHECK-NEXT:    br i1 icmp eq (%struct.GPar.0.16.26* (...)* inttoptr (i64 115 to %struct.GPar.0.16.26* (...)*), %struct.GPar.0.16.26* (...)* @Rf_gpptr), label [[IF_THEN:%.*]], label [[IF_END7:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <2 x double> undef, double [[SUB]], i32 0
; CHECK-NEXT:    [[TMP2:%.*]] = insertelement <2 x double> [[TMP1]], double [[SUB1]], i32 1
; CHECK-NEXT:    [[TMP3:%.*]] = fsub <2 x double> [[TMP2]], undef
; CHECK-NEXT:    [[TMP4:%.*]] = fdiv <2 x double> [[TMP3]], undef
; CHECK-NEXT:    [[TMP5:%.*]] = extractelement <2 x double> [[TMP4]], i32 0
; CHECK-NEXT:    [[TMP6:%.*]] = extractelement <2 x double> [[TMP4]], i32 1
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ogt double [[TMP5]], [[TMP6]]
; CHECK-NEXT:    br i1 [[CMP]], label [[IF_THEN6:%.*]], label [[IF_END7]]
; CHECK:       if.then6:
; CHECK-NEXT:    br label [[IF_END7]]
; CHECK:       if.end7:
; CHECK-NEXT:    ret void
;
entry:
  %sub = fneg double undef
  %0 = load double, double* @d, align 8
  %sub1 = fneg double %0
  br i1 icmp eq (%struct.GPar.0.16.26* (...)* inttoptr (i64 115 to %struct.GPar.0.16.26* (...)*), %struct.GPar.0.16.26* (...)* @Rf_gpptr), label %if.then, label %if.end7

if.then:                                          ; preds = %entry
  %sub2 = fsub double %sub, undef
  %div.i = fdiv double %sub2, undef
  %sub4 = fsub double %sub1, undef
  %div.i16 = fdiv double %sub4, undef
  %cmp = fcmp ogt double %div.i, %div.i16
  br i1 %cmp, label %if.then6, label %if.end7

if.then6:                                         ; preds = %if.then
  br label %if.end7

if.end7:                                          ; preds = %if.then6, %if.then, %entry
  %g.0 = phi double [ 0.000000e+00, %if.then6 ], [ %sub, %if.then ], [ %sub, %entry ]
  ret void
}
