; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

define <2 x float> @vtrn1(<2 x i32> %v)
; CHECK-LABEL: @vtrn1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast <2 x i32> [[V:%.*]] to <2 x float>
; CHECK-NEXT:    [[R:%.*]] = shufflevector <2 x float> [[TMP0]], <2 x float> undef, <2 x i32> zeroinitializer
; CHECK-NEXT:    ret <2 x float> [[R]]
;
{
entry:
  %vb1 = bitcast <2 x i32> %v to <2 x float>
  %vb2 = bitcast <2 x i32> %v to <2 x float>
  %r = shufflevector <2 x float> %vb1, <2 x float> %vb2, <2 x i32> <i32 0, i32 2>
  ret <2 x float> %r
}

define <2 x float> @vtrn2(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @vtrn2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[R_UNCASTED:%.*]] = shufflevector <2 x i32> [[X:%.*]], <2 x i32> [[Y:%.*]], <2 x i32> <i32 1, i32 3>
; CHECK-NEXT:    [[R:%.*]] = bitcast <2 x i32> [[R_UNCASTED]] to <2 x float>
; CHECK-NEXT:    ret <2 x float> [[R]]
;
entry:
  %xb = bitcast <2 x i32> %x to <2 x float>
  %yb = bitcast <2 x i32> %y to <2 x float>
  %r = shufflevector <2 x float> %xb, <2 x float> %yb, <2 x i32> <i32 1, i32 3>
  ret <2 x float> %r
}


define <4 x float> @bc_shuf_lenchange(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @bc_shuf_lenchange(
; CHECK-NEXT:    [[R_UNCASTED:%.*]] = shufflevector <2 x i32> [[X:%.*]], <2 x i32> [[Y:%.*]], <4 x i32> <i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:    [[R:%.*]] = bitcast <4 x i32> [[R_UNCASTED]] to <4 x float>
; CHECK-NEXT:    ret <4 x float> [[R]]
;
  %xb = bitcast <2 x i32> %x to <2 x float>
  %yb = bitcast <2 x i32> %y to <2 x float>
  %r = shufflevector <2 x float> %xb, <2 x float> %yb, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
  ret <4 x float> %r
}


define <4 x float> @bc_shuf_nonvec(i64 %x, i64 %y) {
; CHECK-LABEL: @bc_shuf_nonvec(
; CHECK-NEXT:    [[XB:%.*]] = bitcast i64 [[X:%.*]] to <2 x float>
; CHECK-NEXT:    [[YB:%.*]] = bitcast i64 [[Y:%.*]] to <2 x float>
; CHECK-NEXT:    [[R:%.*]] = shufflevector <2 x float> [[XB]], <2 x float> [[YB]], <4 x i32> <i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:    ret <4 x float> [[R]]
;
  %xb = bitcast i64 %x to <2 x float>
  %yb = bitcast i64 %y to <2 x float>
  %r = shufflevector <2 x float> %xb, <2 x float> %yb, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
  ret <4 x float> %r
}

define <4 x double> @bc_shuf_size(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: @bc_shuf_size(
; CHECK-NEXT:    [[XB:%.*]] = bitcast <4 x i32> [[X:%.*]] to <2 x double>
; CHECK-NEXT:    [[YB:%.*]] = bitcast <4 x i32> [[Y:%.*]] to <2 x double>
; CHECK-NEXT:    [[R:%.*]] = shufflevector <2 x double> [[XB]], <2 x double> [[YB]], <4 x i32> <i32 1, i32 3, i32 0, i32 2>
; CHECK-NEXT:    ret <4 x double> [[R]]
;
  %xb = bitcast <4 x i32> %x to <2 x double>
  %yb = bitcast <4 x i32> %y to <2 x double>
  %r = shufflevector <2 x double> %xb, <2 x double> %yb, <4 x i32> <i32 1, i32 3, i32 0, i32 2>
  ret <4 x double> %r
}

define <2 x double> @bc_shuf_mismatch(<4 x i32> %x, <2 x i64> %y) {
; CHECK-LABEL: @bc_shuf_mismatch(
; CHECK-NEXT:    [[XB:%.*]] = bitcast <4 x i32> [[X:%.*]] to <2 x double>
; CHECK-NEXT:    [[YB:%.*]] = bitcast <2 x i64> [[Y:%.*]] to <2 x double>
; CHECK-NEXT:    [[R:%.*]] = shufflevector <2 x double> [[XB]], <2 x double> [[YB]], <2 x i32> <i32 1, i32 3>
; CHECK-NEXT:    ret <2 x double> [[R]]
;
  %xb = bitcast <4 x i32> %x to <2 x double>
  %yb = bitcast <2 x i64> %y to <2 x double>
  %r = shufflevector <2 x double> %xb, <2 x double> %yb, <2 x i32> <i32 1, i32 3>
  ret <2 x double> %r
}

define <8 x half> @bc_shuf_i8_float(<8 x i8> %x, <8 x i8> %y) {
; CHECK-LABEL: @bc_shuf_i8_float(
; CHECK-NEXT:    [[XB:%.*]] = bitcast <8 x i8> [[X:%.*]] to <4 x half>
; CHECK-NEXT:    [[YB:%.*]] = bitcast <8 x i8> [[Y:%.*]] to <4 x half>
; CHECK-NEXT:    [[R:%.*]] = shufflevector <4 x half> [[XB]], <4 x half> [[YB]], <8 x i32> <i32 3, i32 2, i32 1, i32 0, i32 7, i32 6, i32 5, i32 4>
; CHECK-NEXT:    ret <8 x half> [[R]]
;
  %xb = bitcast <8 x i8> %x to <4 x half>
  %yb = bitcast <8 x i8> %y to <4 x half>
  %r = shufflevector <4 x half> %xb, <4 x half> %yb, <8 x i32> <i32 3, i32 2, i32 1, i32 0, i32 7, i32 6, i32 5, i32 4>
  ret <8 x half> %r
}

define <4 x i16> @bc_shuf_elemtype_mismatch(<2 x half> %x, <2 x bfloat> %y) {
; CHECK-LABEL: @bc_shuf_elemtype_mismatch(
; CHECK-NEXT:    [[XB:%.*]] = bitcast <2 x half> [[X:%.*]] to <2 x i16>
; CHECK-NEXT:    [[YB:%.*]] = bitcast <2 x bfloat> [[Y:%.*]] to <2 x i16>
; CHECK-NEXT:    [[R:%.*]] = shufflevector <2 x i16> [[XB]], <2 x i16> [[YB]], <4 x i32> <i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:    ret <4 x i16> [[R]]
;
  %xb = bitcast <2 x half> %x to <2 x i16>
  %yb = bitcast <2 x bfloat> %y to <2 x i16>
  %r = shufflevector <2 x i16> %xb, <2 x i16> %yb, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
  ret <4 x i16> %r
}

define <2 x float> @bc_shuf_reuse(<4 x i32> %x){
; CHECK-LABEL: @bc_shuf_reuse(
; CHECK-NEXT:    [[XB:%.*]] = bitcast <4 x i32> [[X:%.*]] to <4 x float>
; CHECK-NEXT:    [[R:%.*]] = shufflevector <4 x float> [[XB]], <4 x float> undef, <2 x i32> zeroinitializer
; CHECK-NEXT:    ret <2 x float> [[R]]
;
  %xb = bitcast <4 x i32> %x to <4 x float>
  %r = shufflevector <4 x float> %xb, <4 x float> %xb, <2 x i32> <i32 0, i32 4>
  ret <2 x float> %r
}

define <4 x float> @bc_shuf_y_hasoneuse(<4 x i32> %x, <4 x i32> %y){
; CHECK-LABEL: @bc_shuf_y_hasoneuse(
; CHECK-NEXT:    [[XB:%.*]] = bitcast <4 x i32> [[X:%.*]] to <4 x float>
; CHECK-NEXT:    [[SHUF_UNCASTED:%.*]] = shufflevector <4 x i32> [[X]], <4 x i32> [[Y:%.*]], <4 x i32> <i32 0, i32 1, i32 4, i32 5>
; CHECK-NEXT:    [[SHUF:%.*]] = bitcast <4 x i32> [[SHUF_UNCASTED]] to <4 x float>
; CHECK-NEXT:    [[R:%.*]] = fadd <4 x float> [[XB]], [[SHUF]]
; CHECK-NEXT:    ret <4 x float> [[R]]
;
  %xb = bitcast <4 x i32> %x to <4 x float>
  %yb = bitcast <4 x i32> %y to <4 x float>
  %shuf = shufflevector <4 x float> %xb, <4 x float> %yb, <4 x i32> <i32 0, i32 1, i32 4, i32 5>
  %r = fadd <4 x float> %xb, %shuf
  ret <4 x float> %r
}

define <4 x float> @bc_shuf_neither_hasoneuse(<4 x i32> %x, <4 x i32> %y){
; CHECK-LABEL: @bc_shuf_neither_hasoneuse(
; CHECK-NEXT:    [[XB:%.*]] = bitcast <4 x i32> [[X:%.*]] to <4 x float>
; CHECK-NEXT:    [[YB:%.*]] = bitcast <4 x i32> [[Y:%.*]] to <4 x float>
; CHECK-NEXT:    [[SHUF:%.*]] = shufflevector <4 x float> [[XB]], <4 x float> undef, <4 x i32> <i32 0, i32 1, i32 0, i32 1>
; CHECK-NEXT:    [[SUM:%.*]] = fadd <4 x float> [[XB]], [[YB]]
; CHECK-NEXT:    [[R:%.*]] = fadd <4 x float> [[SUM]], [[SHUF]]
; CHECK-NEXT:    ret <4 x float> [[R]]
;
  %xb = bitcast <4 x i32> %x to <4 x float>
  %yb = bitcast <4 x i32> %y to <4 x float>
  %shuf = shufflevector <4 x float> %xb, <4 x float> %xb, <4 x i32> <i32 0, i32 1, i32 4, i32 5>
  %sum = fadd <4 x float> %xb, %yb
  %r = fadd <4 x float> %sum, %shuf
  ret <4 x float> %r
}
