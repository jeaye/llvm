; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt < %s -mtriple=amdgcn-unknown-amdhsa -cost-model -cost-kind=throughput -analyze | FileCheck %s

define i32 @reduce_i1(i32 %arg) {
; CHECK-LABEL: 'reduce_i1'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V1 = call i1 @llvm.vector.reduce.and.v1i1(<1 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V2 = call i1 @llvm.vector.reduce.and.v2i1(<2 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: %V4 = call i1 @llvm.vector.reduce.and.v4i1(<4 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 22 for instruction: %V8 = call i1 @llvm.vector.reduce.and.v8i1(<8 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 46 for instruction: %V16 = call i1 @llvm.vector.reduce.and.v16i1(<16 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 94 for instruction: %V32 = call i1 @llvm.vector.reduce.and.v32i1(<32 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 190 for instruction: %V64 = call i1 @llvm.vector.reduce.and.v64i1(<64 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 382 for instruction: %V128 = call i1 @llvm.vector.reduce.and.v128i1(<128 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: ret i32 undef
;
  %V1   = call i1 @llvm.vector.reduce.and.v1i1(<1 x i1> undef)
  %V2   = call i1 @llvm.vector.reduce.and.v2i1(<2 x i1> undef)
  %V4   = call i1 @llvm.vector.reduce.and.v4i1(<4 x i1> undef)
  %V8   = call i1 @llvm.vector.reduce.and.v8i1(<8 x i1> undef)
  %V16  = call i1 @llvm.vector.reduce.and.v16i1(<16 x i1> undef)
  %V32  = call i1 @llvm.vector.reduce.and.v32i1(<32 x i1> undef)
  %V64  = call i1 @llvm.vector.reduce.and.v64i1(<64 x i1> undef)
  %V128 = call i1 @llvm.vector.reduce.and.v128i1(<128 x i1> undef)
  ret i32 undef
}

declare i1 @llvm.vector.reduce.and.v1i1(<1 x i1>)
declare i1 @llvm.vector.reduce.and.v2i1(<2 x i1>)
declare i1 @llvm.vector.reduce.and.v4i1(<4 x i1>)
declare i1 @llvm.vector.reduce.and.v8i1(<8 x i1>)
declare i1 @llvm.vector.reduce.and.v16i1(<16 x i1>)
declare i1 @llvm.vector.reduce.and.v32i1(<32 x i1>)
declare i1 @llvm.vector.reduce.and.v64i1(<64 x i1>)
declare i1 @llvm.vector.reduce.and.v128i1(<128 x i1>)
