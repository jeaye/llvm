; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt < %s -mtriple=aarch64--linux-gnu -cost-model -analyze | FileCheck %s --check-prefix=COST

define i8 @add.i8.v8i8(<8 x i8> %v) {
; COST-LABEL: 'add.i8.v8i8'
; COST-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %r = call i8 @llvm.vector.reduce.add.v8i8(<8 x i8> %v)
; COST-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i8 %r
;
  %r = call i8 @llvm.vector.reduce.add.v8i8(<8 x i8> %v)
  ret i8 %r
}

define i8 @add.i8.v16i8(<16 x i8> %v) {
; COST-LABEL: 'add.i8.v16i8'
; COST-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %r = call i8 @llvm.vector.reduce.add.v16i8(<16 x i8> %v)
; COST-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i8 %r
;
  %r = call i8 @llvm.vector.reduce.add.v16i8(<16 x i8> %v)
  ret i8 %r
}

define i16 @add.i16.v4i16(<4 x i16> %v) {
; COST-LABEL: 'add.i16.v4i16'
; COST-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %r = call i16 @llvm.vector.reduce.add.v4i16(<4 x i16> %v)
; COST-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i16 %r
;
  %r = call i16 @llvm.vector.reduce.add.v4i16(<4 x i16> %v)
  ret i16 %r
}

define i16 @add.i16.v8i16(<8 x i16> %v) {
; COST-LABEL: 'add.i16.v8i16'
; COST-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %r = call i16 @llvm.vector.reduce.add.v8i16(<8 x i16> %v)
; COST-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i16 %r
;
  %r = call i16 @llvm.vector.reduce.add.v8i16(<8 x i16> %v)
  ret i16 %r
}

define i32 @add.i32.v4i32(<4 x i32> %v) {
; COST-LABEL: 'add.i32.v4i32'
; COST-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %r = call i32 @llvm.vector.reduce.add.v4i32(<4 x i32> %v)
; COST-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 %r
;
  %r = call i32 @llvm.vector.reduce.add.v4i32(<4 x i32> %v)
  ret i32 %r
}

define i8 @umin.i8.v8i8(<8 x i8> %v) {
; COST-LABEL: 'umin.i8.v8i8'
; COST-NEXT:  Cost Model: Found an estimated cost of 114 for instruction: %r = call i8 @llvm.vector.reduce.umin.v8i8(<8 x i8> %v)
; COST-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i8 %r
;
  %r = call i8 @llvm.vector.reduce.umin.v8i8(<8 x i8> %v)
  ret i8 %r
}

define i8 @umin.i8.v16i8(<16 x i8> %v) {
; COST-LABEL: 'umin.i8.v16i8'
; COST-NEXT:  Cost Model: Found an estimated cost of 280 for instruction: %r = call i8 @llvm.vector.reduce.umin.v16i8(<16 x i8> %v)
; COST-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i8 %r
;
  %r = call i8 @llvm.vector.reduce.umin.v16i8(<16 x i8> %v)
  ret i8 %r
}

define i16 @umin.i16.v4i16(<4 x i16> %v) {
; COST-LABEL: 'umin.i16.v4i16'
; COST-NEXT:  Cost Model: Found an estimated cost of 34 for instruction: %r = call i16 @llvm.vector.reduce.umin.v4i16(<4 x i16> %v)
; COST-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i16 %r
;
  %r = call i16 @llvm.vector.reduce.umin.v4i16(<4 x i16> %v)
  ret i16 %r
}

define i16 @umin.i16.v8i16(<8 x i16> %v) {
; COST-LABEL: 'umin.i16.v8i16'
; COST-NEXT:  Cost Model: Found an estimated cost of 114 for instruction: %r = call i16 @llvm.vector.reduce.umin.v8i16(<8 x i16> %v)
; COST-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i16 %r
;
  %r = call i16 @llvm.vector.reduce.umin.v8i16(<8 x i16> %v)
  ret i16 %r
}

define i32 @umin.i32.v4i32(<4 x i32> %v) {
; COST-LABEL: 'umin.i32.v4i32'
; COST-NEXT:  Cost Model: Found an estimated cost of 34 for instruction: %r = call i32 @llvm.vector.reduce.umin.v4i32(<4 x i32> %v)
; COST-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 %r
;
  %r = call i32 @llvm.vector.reduce.umin.v4i32(<4 x i32> %v)
  ret i32 %r
}

define i8 @umax.i8.v8i8(<8 x i8> %v) {
; COST-LABEL: 'umax.i8.v8i8'
; COST-NEXT:  Cost Model: Found an estimated cost of 114 for instruction: %r = call i8 @llvm.vector.reduce.umax.v8i8(<8 x i8> %v)
; COST-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i8 %r
;
  %r = call i8 @llvm.vector.reduce.umax.v8i8(<8 x i8> %v)
  ret i8 %r
}

define i8 @umax.i8.v16i8(<16 x i8> %v) {
; COST-LABEL: 'umax.i8.v16i8'
; COST-NEXT:  Cost Model: Found an estimated cost of 280 for instruction: %r = call i8 @llvm.vector.reduce.umax.v16i8(<16 x i8> %v)
; COST-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i8 %r
;
  %r = call i8 @llvm.vector.reduce.umax.v16i8(<16 x i8> %v)
  ret i8 %r
}

define i16 @umax.i16.v4i16(<4 x i16> %v) {
; COST-LABEL: 'umax.i16.v4i16'
; COST-NEXT:  Cost Model: Found an estimated cost of 34 for instruction: %r = call i16 @llvm.vector.reduce.umax.v4i16(<4 x i16> %v)
; COST-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i16 %r
;
  %r = call i16 @llvm.vector.reduce.umax.v4i16(<4 x i16> %v)
  ret i16 %r
}

define i16 @umax.i16.v8i16(<8 x i16> %v) {
; COST-LABEL: 'umax.i16.v8i16'
; COST-NEXT:  Cost Model: Found an estimated cost of 114 for instruction: %r = call i16 @llvm.vector.reduce.umax.v8i16(<8 x i16> %v)
; COST-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i16 %r
;
  %r = call i16 @llvm.vector.reduce.umax.v8i16(<8 x i16> %v)
  ret i16 %r
}

define i32 @umax.i32.v4i32(<4 x i32> %v) {
; COST-LABEL: 'umax.i32.v4i32'
; COST-NEXT:  Cost Model: Found an estimated cost of 34 for instruction: %r = call i32 @llvm.vector.reduce.umax.v4i32(<4 x i32> %v)
; COST-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 %r
;
  %r = call i32 @llvm.vector.reduce.umax.v4i32(<4 x i32> %v)
  ret i32 %r
}

define i8 @smin.i8.v8i8(<8 x i8> %v) {
; COST-LABEL: 'smin.i8.v8i8'
; COST-NEXT:  Cost Model: Found an estimated cost of 114 for instruction: %r = call i8 @llvm.vector.reduce.smin.v8i8(<8 x i8> %v)
; COST-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i8 %r
;
  %r = call i8 @llvm.vector.reduce.smin.v8i8(<8 x i8> %v)
  ret i8 %r
}

define i8 @smin.i8.v16i8(<16 x i8> %v) {
; COST-LABEL: 'smin.i8.v16i8'
; COST-NEXT:  Cost Model: Found an estimated cost of 280 for instruction: %r = call i8 @llvm.vector.reduce.smin.v16i8(<16 x i8> %v)
; COST-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i8 %r
;
  %r = call i8 @llvm.vector.reduce.smin.v16i8(<16 x i8> %v)
  ret i8 %r
}

define i16 @smin.i16.v4i16(<4 x i16> %v) {
; COST-LABEL: 'smin.i16.v4i16'
; COST-NEXT:  Cost Model: Found an estimated cost of 34 for instruction: %r = call i16 @llvm.vector.reduce.smin.v4i16(<4 x i16> %v)
; COST-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i16 %r
;
  %r = call i16 @llvm.vector.reduce.smin.v4i16(<4 x i16> %v)
  ret i16 %r
}

define i16 @smin.i16.v8i16(<8 x i16> %v) {
; COST-LABEL: 'smin.i16.v8i16'
; COST-NEXT:  Cost Model: Found an estimated cost of 114 for instruction: %r = call i16 @llvm.vector.reduce.smin.v8i16(<8 x i16> %v)
; COST-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i16 %r
;
  %r = call i16 @llvm.vector.reduce.smin.v8i16(<8 x i16> %v)
  ret i16 %r
}

define i32 @smin.i32.v4i32(<4 x i32> %v) {
; COST-LABEL: 'smin.i32.v4i32'
; COST-NEXT:  Cost Model: Found an estimated cost of 34 for instruction: %r = call i32 @llvm.vector.reduce.smin.v4i32(<4 x i32> %v)
; COST-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 %r
;
  %r = call i32 @llvm.vector.reduce.smin.v4i32(<4 x i32> %v)
  ret i32 %r
}

define i8 @smax.i8.v8i8(<8 x i8> %v) {
; COST-LABEL: 'smax.i8.v8i8'
; COST-NEXT:  Cost Model: Found an estimated cost of 114 for instruction: %r = call i8 @llvm.vector.reduce.smax.v8i8(<8 x i8> %v)
; COST-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i8 %r
;
  %r = call i8 @llvm.vector.reduce.smax.v8i8(<8 x i8> %v)
  ret i8 %r
}

define i8 @smax.i8.v16i8(<16 x i8> %v) {
; COST-LABEL: 'smax.i8.v16i8'
; COST-NEXT:  Cost Model: Found an estimated cost of 280 for instruction: %r = call i8 @llvm.vector.reduce.smax.v16i8(<16 x i8> %v)
; COST-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i8 %r
;
  %r = call i8 @llvm.vector.reduce.smax.v16i8(<16 x i8> %v)
  ret i8 %r
}

define i16 @smax.i16.v4i16(<4 x i16> %v) {
; COST-LABEL: 'smax.i16.v4i16'
; COST-NEXT:  Cost Model: Found an estimated cost of 34 for instruction: %r = call i16 @llvm.vector.reduce.smax.v4i16(<4 x i16> %v)
; COST-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i16 %r
;
  %r = call i16 @llvm.vector.reduce.smax.v4i16(<4 x i16> %v)
  ret i16 %r
}

define i16 @smax.i16.v8i16(<8 x i16> %v) {
; COST-LABEL: 'smax.i16.v8i16'
; COST-NEXT:  Cost Model: Found an estimated cost of 114 for instruction: %r = call i16 @llvm.vector.reduce.smax.v8i16(<8 x i16> %v)
; COST-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i16 %r
;
  %r = call i16 @llvm.vector.reduce.smax.v8i16(<8 x i16> %v)
  ret i16 %r
}

define i32 @smax.i32.v4i32(<4 x i32> %v) {
; COST-LABEL: 'smax.i32.v4i32'
; COST-NEXT:  Cost Model: Found an estimated cost of 34 for instruction: %r = call i32 @llvm.vector.reduce.smax.v4i32(<4 x i32> %v)
; COST-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 %r
;
  %r = call i32 @llvm.vector.reduce.smax.v4i32(<4 x i32> %v)
  ret i32 %r
}

define float @fmin.f32.v4f32(<4 x float> %v) {
; COST-LABEL: 'fmin.f32.v4f32'
; COST-NEXT:  Cost Model: Found an estimated cost of 34 for instruction: %r = call nnan float @llvm.vector.reduce.fmin.v4f32(<4 x float> %v)
; COST-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret float %r
;
  %r = call nnan float @llvm.vector.reduce.fmin.v4f32(<4 x float> %v)
  ret float %r
}

define float @fmax.f32.v4f32(<4 x float> %v) {
; COST-LABEL: 'fmax.f32.v4f32'
; COST-NEXT:  Cost Model: Found an estimated cost of 34 for instruction: %r = call nnan float @llvm.vector.reduce.fmax.v4f32(<4 x float> %v)
; COST-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret float %r
;
  %r = call nnan float @llvm.vector.reduce.fmax.v4f32(<4 x float> %v)
  ret float %r
}

declare i8 @llvm.vector.reduce.add.v8i8(<8 x i8>)
declare i8 @llvm.vector.reduce.add.v16i8(<16 x i8>)
declare i16 @llvm.vector.reduce.add.v4i16(<4 x i16>)
declare i16 @llvm.vector.reduce.add.v8i16(<8 x i16>)
declare i32 @llvm.vector.reduce.add.v4i32(<4 x i32>)

declare i8 @llvm.vector.reduce.umin.v8i8(<8 x i8>)
declare i8 @llvm.vector.reduce.umin.v16i8(<16 x i8>)
declare i16 @llvm.vector.reduce.umin.v4i16(<4 x i16>)
declare i16 @llvm.vector.reduce.umin.v8i16(<8 x i16>)
declare i32 @llvm.vector.reduce.umin.v4i32(<4 x i32>)

declare i8 @llvm.vector.reduce.umax.v8i8(<8 x i8>)
declare i8 @llvm.vector.reduce.umax.v16i8(<16 x i8>)
declare i16 @llvm.vector.reduce.umax.v4i16(<4 x i16>)
declare i16 @llvm.vector.reduce.umax.v8i16(<8 x i16>)
declare i32 @llvm.vector.reduce.umax.v4i32(<4 x i32>)

declare i8 @llvm.vector.reduce.smin.v8i8(<8 x i8>)
declare i8 @llvm.vector.reduce.smin.v16i8(<16 x i8>)
declare i16 @llvm.vector.reduce.smin.v4i16(<4 x i16>)
declare i16 @llvm.vector.reduce.smin.v8i16(<8 x i16>)
declare i32 @llvm.vector.reduce.smin.v4i32(<4 x i32>)

declare i8 @llvm.vector.reduce.smax.v8i8(<8 x i8>)
declare i8 @llvm.vector.reduce.smax.v16i8(<16 x i8>)
declare i16 @llvm.vector.reduce.smax.v4i16(<4 x i16>)
declare i16 @llvm.vector.reduce.smax.v8i16(<8 x i16>)
declare i32 @llvm.vector.reduce.smax.v4i32(<4 x i32>)

declare float @llvm.vector.reduce.fmin.v4f32(<4 x float>)

declare float @llvm.vector.reduce.fmax.v4f32(<4 x float>)
