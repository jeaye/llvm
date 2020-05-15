; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt -cost-model -analyze -mtriple=thumbv8m.main < %s | FileCheck %s --check-prefix=V8M
; RUN: opt -cost-model -analyze -mtriple=armv8a-linux-gnueabihf < %s | FileCheck %s --check-prefix=NEON
; RUN: opt -cost-model -analyze -mtriple=armv8.1m.main -mattr=+mve < %s | FileCheck %s --check-prefix=MVE

declare i64        @llvm.uadd.sat.i64(i64, i64)
declare <2 x i64>  @llvm.uadd.sat.v2i64(<2 x i64>, <2 x i64>)
declare <4 x i64>  @llvm.uadd.sat.v4i64(<4 x i64>, <4 x i64>)
declare <8 x i64>  @llvm.uadd.sat.v8i64(<8 x i64>, <8 x i64>)

declare i32        @llvm.uadd.sat.i32(i32, i32)
declare <4 x i32>  @llvm.uadd.sat.v4i32(<4 x i32>, <4 x i32>)
declare <8 x i32>  @llvm.uadd.sat.v8i32(<8 x i32>, <8 x i32>)
declare <16 x i32> @llvm.uadd.sat.v16i32(<16 x i32>, <16 x i32>)

declare i16        @llvm.uadd.sat.i16(i16, i16)
declare <8 x i16>  @llvm.uadd.sat.v8i16(<8 x i16>, <8 x i16>)
declare <16 x i16> @llvm.uadd.sat.v16i16(<16 x i16>, <16 x i16>)
declare <32 x i16> @llvm.uadd.sat.v32i16(<32 x i16>, <32 x i16>)

declare i8         @llvm.uadd.sat.i8(i8,  i8)
declare <16 x i8>  @llvm.uadd.sat.v16i8(<16 x i8>, <16 x i8>)
declare <32 x i8>  @llvm.uadd.sat.v32i8(<32 x i8>, <32 x i8>)
declare <64 x i8>  @llvm.uadd.sat.v64i8(<64 x i8>, <64 x i8>)

define i32 @add(i32 %arg) {
; V8M-LABEL: 'add'
; V8M-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %I64 = call i64 @llvm.uadd.sat.i64(i64 undef, i64 undef)
; V8M-NEXT:  Cost Model: Found an estimated cost of 18 for instruction: %V2I64 = call <2 x i64> @llvm.uadd.sat.v2i64(<2 x i64> undef, <2 x i64> undef)
; V8M-NEXT:  Cost Model: Found an estimated cost of 36 for instruction: %V4I64 = call <4 x i64> @llvm.uadd.sat.v4i64(<4 x i64> undef, <4 x i64> undef)
; V8M-NEXT:  Cost Model: Found an estimated cost of 72 for instruction: %V8I64 = call <8 x i64> @llvm.uadd.sat.v8i64(<8 x i64> undef, <8 x i64> undef)
; V8M-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %I32 = call i32 @llvm.uadd.sat.i32(i32 undef, i32 undef)
; V8M-NEXT:  Cost Model: Found an estimated cost of 20 for instruction: %V4I32 = call <4 x i32> @llvm.uadd.sat.v4i32(<4 x i32> undef, <4 x i32> undef)
; V8M-NEXT:  Cost Model: Found an estimated cost of 40 for instruction: %V8I32 = call <8 x i32> @llvm.uadd.sat.v8i32(<8 x i32> undef, <8 x i32> undef)
; V8M-NEXT:  Cost Model: Found an estimated cost of 80 for instruction: %V16I32 = call <16 x i32> @llvm.uadd.sat.v16i32(<16 x i32> undef, <16 x i32> undef)
; V8M-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %I16 = call i16 @llvm.uadd.sat.i16(i16 undef, i16 undef)
; V8M-NEXT:  Cost Model: Found an estimated cost of 40 for instruction: %V8I16 = call <8 x i16> @llvm.uadd.sat.v8i16(<8 x i16> undef, <8 x i16> undef)
; V8M-NEXT:  Cost Model: Found an estimated cost of 80 for instruction: %V16I16 = call <16 x i16> @llvm.uadd.sat.v16i16(<16 x i16> undef, <16 x i16> undef)
; V8M-NEXT:  Cost Model: Found an estimated cost of 160 for instruction: %V32I16 = call <32 x i16> @llvm.uadd.sat.v32i16(<32 x i16> undef, <32 x i16> undef)
; V8M-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %I8 = call i8 @llvm.uadd.sat.i8(i8 undef, i8 undef)
; V8M-NEXT:  Cost Model: Found an estimated cost of 80 for instruction: %V16I8 = call <16 x i8> @llvm.uadd.sat.v16i8(<16 x i8> undef, <16 x i8> undef)
; V8M-NEXT:  Cost Model: Found an estimated cost of 160 for instruction: %V32I8 = call <32 x i8> @llvm.uadd.sat.v32i8(<32 x i8> undef, <32 x i8> undef)
; V8M-NEXT:  Cost Model: Found an estimated cost of 320 for instruction: %V64I8 = call <64 x i8> @llvm.uadd.sat.v64i8(<64 x i8> undef, <64 x i8> undef)
; V8M-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; NEON-LABEL: 'add'
; NEON-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %I64 = call i64 @llvm.uadd.sat.i64(i64 undef, i64 undef)
; NEON-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %V2I64 = call <2 x i64> @llvm.uadd.sat.v2i64(<2 x i64> undef, <2 x i64> undef)
; NEON-NEXT:  Cost Model: Found an estimated cost of 23 for instruction: %V4I64 = call <4 x i64> @llvm.uadd.sat.v4i64(<4 x i64> undef, <4 x i64> undef)
; NEON-NEXT:  Cost Model: Found an estimated cost of 58 for instruction: %V8I64 = call <8 x i64> @llvm.uadd.sat.v8i64(<8 x i64> undef, <8 x i64> undef)
; NEON-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %I32 = call i32 @llvm.uadd.sat.i32(i32 undef, i32 undef)
; NEON-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %V4I32 = call <4 x i32> @llvm.uadd.sat.v4i32(<4 x i32> undef, <4 x i32> undef)
; NEON-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %V8I32 = call <8 x i32> @llvm.uadd.sat.v8i32(<8 x i32> undef, <8 x i32> undef)
; NEON-NEXT:  Cost Model: Found an estimated cost of 12 for instruction: %V16I32 = call <16 x i32> @llvm.uadd.sat.v16i32(<16 x i32> undef, <16 x i32> undef)
; NEON-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %I16 = call i16 @llvm.uadd.sat.i16(i16 undef, i16 undef)
; NEON-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %V8I16 = call <8 x i16> @llvm.uadd.sat.v8i16(<8 x i16> undef, <8 x i16> undef)
; NEON-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %V16I16 = call <16 x i16> @llvm.uadd.sat.v16i16(<16 x i16> undef, <16 x i16> undef)
; NEON-NEXT:  Cost Model: Found an estimated cost of 12 for instruction: %V32I16 = call <32 x i16> @llvm.uadd.sat.v32i16(<32 x i16> undef, <32 x i16> undef)
; NEON-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %I8 = call i8 @llvm.uadd.sat.i8(i8 undef, i8 undef)
; NEON-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %V16I8 = call <16 x i8> @llvm.uadd.sat.v16i8(<16 x i8> undef, <16 x i8> undef)
; NEON-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %V32I8 = call <32 x i8> @llvm.uadd.sat.v32i8(<32 x i8> undef, <32 x i8> undef)
; NEON-NEXT:  Cost Model: Found an estimated cost of 12 for instruction: %V64I8 = call <64 x i8> @llvm.uadd.sat.v64i8(<64 x i8> undef, <64 x i8> undef)
; NEON-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; MVE-LABEL: 'add'
; MVE-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %I64 = call i64 @llvm.uadd.sat.i64(i64 undef, i64 undef)
; MVE-NEXT:  Cost Model: Found an estimated cost of 40 for instruction: %V2I64 = call <2 x i64> @llvm.uadd.sat.v2i64(<2 x i64> undef, <2 x i64> undef)
; MVE-NEXT:  Cost Model: Found an estimated cost of 128 for instruction: %V4I64 = call <4 x i64> @llvm.uadd.sat.v4i64(<4 x i64> undef, <4 x i64> undef)
; MVE-NEXT:  Cost Model: Found an estimated cost of 448 for instruction: %V8I64 = call <8 x i64> @llvm.uadd.sat.v8i64(<8 x i64> undef, <8 x i64> undef)
; MVE-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %I32 = call i32 @llvm.uadd.sat.i32(i32 undef, i32 undef)
; MVE-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %V4I32 = call <4 x i32> @llvm.uadd.sat.v4i32(<4 x i32> undef, <4 x i32> undef)
; MVE-NEXT:  Cost Model: Found an estimated cost of 12 for instruction: %V8I32 = call <8 x i32> @llvm.uadd.sat.v8i32(<8 x i32> undef, <8 x i32> undef)
; MVE-NEXT:  Cost Model: Found an estimated cost of 24 for instruction: %V16I32 = call <16 x i32> @llvm.uadd.sat.v16i32(<16 x i32> undef, <16 x i32> undef)
; MVE-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %I16 = call i16 @llvm.uadd.sat.i16(i16 undef, i16 undef)
; MVE-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %V8I16 = call <8 x i16> @llvm.uadd.sat.v8i16(<8 x i16> undef, <8 x i16> undef)
; MVE-NEXT:  Cost Model: Found an estimated cost of 12 for instruction: %V16I16 = call <16 x i16> @llvm.uadd.sat.v16i16(<16 x i16> undef, <16 x i16> undef)
; MVE-NEXT:  Cost Model: Found an estimated cost of 24 for instruction: %V32I16 = call <32 x i16> @llvm.uadd.sat.v32i16(<32 x i16> undef, <32 x i16> undef)
; MVE-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %I8 = call i8 @llvm.uadd.sat.i8(i8 undef, i8 undef)
; MVE-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %V16I8 = call <16 x i8> @llvm.uadd.sat.v16i8(<16 x i8> undef, <16 x i8> undef)
; MVE-NEXT:  Cost Model: Found an estimated cost of 12 for instruction: %V32I8 = call <32 x i8> @llvm.uadd.sat.v32i8(<32 x i8> undef, <32 x i8> undef)
; MVE-NEXT:  Cost Model: Found an estimated cost of 24 for instruction: %V64I8 = call <64 x i8> @llvm.uadd.sat.v64i8(<64 x i8> undef, <64 x i8> undef)
; MVE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
  %I64 = call i64 @llvm.uadd.sat.i64(i64 undef, i64 undef)
  %V2I64 = call <2 x i64> @llvm.uadd.sat.v2i64(<2 x i64> undef, <2 x i64> undef)
  %V4I64 = call <4 x i64> @llvm.uadd.sat.v4i64(<4 x i64> undef, <4 x i64> undef)
  %V8I64 = call <8 x i64> @llvm.uadd.sat.v8i64(<8 x i64> undef, <8 x i64> undef)

  %I32 = call i32 @llvm.uadd.sat.i32(i32 undef, i32 undef)
  %V4I32  = call <4 x i32>  @llvm.uadd.sat.v4i32(<4 x i32> undef, <4 x i32> undef)
  %V8I32  = call <8 x i32>  @llvm.uadd.sat.v8i32(<8 x i32> undef, <8 x i32> undef)
  %V16I32 = call <16 x i32> @llvm.uadd.sat.v16i32(<16 x i32> undef, <16 x i32> undef)

  %I16 = call i16 @llvm.uadd.sat.i16(i16 undef, i16 undef)
  %V8I16  = call <8 x i16>  @llvm.uadd.sat.v8i16(<8 x i16> undef, <8 x i16> undef)
  %V16I16 = call <16 x i16> @llvm.uadd.sat.v16i16(<16 x i16> undef, <16 x i16> undef)
  %V32I16 = call <32 x i16> @llvm.uadd.sat.v32i16(<32 x i16> undef, <32 x i16> undef)

  %I8 = call i8 @llvm.uadd.sat.i8(i8 undef, i8 undef)
  %V16I8 = call <16 x i8> @llvm.uadd.sat.v16i8(<16 x i8> undef, <16 x i8> undef)
  %V32I8 = call <32 x i8> @llvm.uadd.sat.v32i8(<32 x i8> undef, <32 x i8> undef)
  %V64I8 = call <64 x i8> @llvm.uadd.sat.v64i8(<64 x i8> undef, <64 x i8> undef)

  ret i32 undef
}

declare i64        @llvm.usub.sat.i64(i64, i64)
declare <2 x i64>  @llvm.usub.sat.v2i64(<2 x i64>, <2 x i64>)
declare <4 x i64>  @llvm.usub.sat.v4i64(<4 x i64>, <4 x i64>)
declare <8 x i64>  @llvm.usub.sat.v8i64(<8 x i64>, <8 x i64>)

declare i32        @llvm.usub.sat.i32(i32, i32)
declare <4 x i32>  @llvm.usub.sat.v4i32(<4 x i32>, <4 x i32>)
declare <8 x i32>  @llvm.usub.sat.v8i32(<8 x i32>, <8 x i32>)
declare <16 x i32> @llvm.usub.sat.v16i32(<16 x i32>, <16 x i32>)

declare i16        @llvm.usub.sat.i16(i16, i16)
declare <8 x i16>  @llvm.usub.sat.v8i16(<8 x i16>, <8 x i16>)
declare <16 x i16> @llvm.usub.sat.v16i16(<16 x i16>, <16 x i16>)
declare <32 x i16> @llvm.usub.sat.v32i16(<32 x i16>, <32 x i16>)

declare i8         @llvm.usub.sat.i8(i8,  i8)
declare <16 x i8>  @llvm.usub.sat.v16i8(<16 x i8>, <16 x i8>)
declare <32 x i8>  @llvm.usub.sat.v32i8(<32 x i8>, <32 x i8>)
declare <64 x i8>  @llvm.usub.sat.v64i8(<64 x i8>, <64 x i8>)

define i32 @sub(i32 %arg) {
; V8M-LABEL: 'sub'
; V8M-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %I64 = call i64 @llvm.usub.sat.i64(i64 undef, i64 undef)
; V8M-NEXT:  Cost Model: Found an estimated cost of 18 for instruction: %V2I64 = call <2 x i64> @llvm.usub.sat.v2i64(<2 x i64> undef, <2 x i64> undef)
; V8M-NEXT:  Cost Model: Found an estimated cost of 36 for instruction: %V4I64 = call <4 x i64> @llvm.usub.sat.v4i64(<4 x i64> undef, <4 x i64> undef)
; V8M-NEXT:  Cost Model: Found an estimated cost of 72 for instruction: %V8I64 = call <8 x i64> @llvm.usub.sat.v8i64(<8 x i64> undef, <8 x i64> undef)
; V8M-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %I32 = call i32 @llvm.usub.sat.i32(i32 undef, i32 undef)
; V8M-NEXT:  Cost Model: Found an estimated cost of 20 for instruction: %V4I32 = call <4 x i32> @llvm.usub.sat.v4i32(<4 x i32> undef, <4 x i32> undef)
; V8M-NEXT:  Cost Model: Found an estimated cost of 40 for instruction: %V8I32 = call <8 x i32> @llvm.usub.sat.v8i32(<8 x i32> undef, <8 x i32> undef)
; V8M-NEXT:  Cost Model: Found an estimated cost of 80 for instruction: %V16I32 = call <16 x i32> @llvm.usub.sat.v16i32(<16 x i32> undef, <16 x i32> undef)
; V8M-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %I16 = call i16 @llvm.usub.sat.i16(i16 undef, i16 undef)
; V8M-NEXT:  Cost Model: Found an estimated cost of 40 for instruction: %V8I16 = call <8 x i16> @llvm.usub.sat.v8i16(<8 x i16> undef, <8 x i16> undef)
; V8M-NEXT:  Cost Model: Found an estimated cost of 80 for instruction: %V16I16 = call <16 x i16> @llvm.usub.sat.v16i16(<16 x i16> undef, <16 x i16> undef)
; V8M-NEXT:  Cost Model: Found an estimated cost of 160 for instruction: %V32I16 = call <32 x i16> @llvm.usub.sat.v32i16(<32 x i16> undef, <32 x i16> undef)
; V8M-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %I8 = call i8 @llvm.usub.sat.i8(i8 undef, i8 undef)
; V8M-NEXT:  Cost Model: Found an estimated cost of 80 for instruction: %V16I8 = call <16 x i8> @llvm.usub.sat.v16i8(<16 x i8> undef, <16 x i8> undef)
; V8M-NEXT:  Cost Model: Found an estimated cost of 160 for instruction: %V32I8 = call <32 x i8> @llvm.usub.sat.v32i8(<32 x i8> undef, <32 x i8> undef)
; V8M-NEXT:  Cost Model: Found an estimated cost of 320 for instruction: %V64I8 = call <64 x i8> @llvm.usub.sat.v64i8(<64 x i8> undef, <64 x i8> undef)
; V8M-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; NEON-LABEL: 'sub'
; NEON-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %I64 = call i64 @llvm.usub.sat.i64(i64 undef, i64 undef)
; NEON-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %V2I64 = call <2 x i64> @llvm.usub.sat.v2i64(<2 x i64> undef, <2 x i64> undef)
; NEON-NEXT:  Cost Model: Found an estimated cost of 23 for instruction: %V4I64 = call <4 x i64> @llvm.usub.sat.v4i64(<4 x i64> undef, <4 x i64> undef)
; NEON-NEXT:  Cost Model: Found an estimated cost of 58 for instruction: %V8I64 = call <8 x i64> @llvm.usub.sat.v8i64(<8 x i64> undef, <8 x i64> undef)
; NEON-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %I32 = call i32 @llvm.usub.sat.i32(i32 undef, i32 undef)
; NEON-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %V4I32 = call <4 x i32> @llvm.usub.sat.v4i32(<4 x i32> undef, <4 x i32> undef)
; NEON-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %V8I32 = call <8 x i32> @llvm.usub.sat.v8i32(<8 x i32> undef, <8 x i32> undef)
; NEON-NEXT:  Cost Model: Found an estimated cost of 12 for instruction: %V16I32 = call <16 x i32> @llvm.usub.sat.v16i32(<16 x i32> undef, <16 x i32> undef)
; NEON-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %I16 = call i16 @llvm.usub.sat.i16(i16 undef, i16 undef)
; NEON-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %V8I16 = call <8 x i16> @llvm.usub.sat.v8i16(<8 x i16> undef, <8 x i16> undef)
; NEON-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %V16I16 = call <16 x i16> @llvm.usub.sat.v16i16(<16 x i16> undef, <16 x i16> undef)
; NEON-NEXT:  Cost Model: Found an estimated cost of 12 for instruction: %V32I16 = call <32 x i16> @llvm.usub.sat.v32i16(<32 x i16> undef, <32 x i16> undef)
; NEON-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %I8 = call i8 @llvm.usub.sat.i8(i8 undef, i8 undef)
; NEON-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %V16I8 = call <16 x i8> @llvm.usub.sat.v16i8(<16 x i8> undef, <16 x i8> undef)
; NEON-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %V32I8 = call <32 x i8> @llvm.usub.sat.v32i8(<32 x i8> undef, <32 x i8> undef)
; NEON-NEXT:  Cost Model: Found an estimated cost of 12 for instruction: %V64I8 = call <64 x i8> @llvm.usub.sat.v64i8(<64 x i8> undef, <64 x i8> undef)
; NEON-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; MVE-LABEL: 'sub'
; MVE-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %I64 = call i64 @llvm.usub.sat.i64(i64 undef, i64 undef)
; MVE-NEXT:  Cost Model: Found an estimated cost of 40 for instruction: %V2I64 = call <2 x i64> @llvm.usub.sat.v2i64(<2 x i64> undef, <2 x i64> undef)
; MVE-NEXT:  Cost Model: Found an estimated cost of 128 for instruction: %V4I64 = call <4 x i64> @llvm.usub.sat.v4i64(<4 x i64> undef, <4 x i64> undef)
; MVE-NEXT:  Cost Model: Found an estimated cost of 448 for instruction: %V8I64 = call <8 x i64> @llvm.usub.sat.v8i64(<8 x i64> undef, <8 x i64> undef)
; MVE-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %I32 = call i32 @llvm.usub.sat.i32(i32 undef, i32 undef)
; MVE-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %V4I32 = call <4 x i32> @llvm.usub.sat.v4i32(<4 x i32> undef, <4 x i32> undef)
; MVE-NEXT:  Cost Model: Found an estimated cost of 12 for instruction: %V8I32 = call <8 x i32> @llvm.usub.sat.v8i32(<8 x i32> undef, <8 x i32> undef)
; MVE-NEXT:  Cost Model: Found an estimated cost of 24 for instruction: %V16I32 = call <16 x i32> @llvm.usub.sat.v16i32(<16 x i32> undef, <16 x i32> undef)
; MVE-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %I16 = call i16 @llvm.usub.sat.i16(i16 undef, i16 undef)
; MVE-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %V8I16 = call <8 x i16> @llvm.usub.sat.v8i16(<8 x i16> undef, <8 x i16> undef)
; MVE-NEXT:  Cost Model: Found an estimated cost of 12 for instruction: %V16I16 = call <16 x i16> @llvm.usub.sat.v16i16(<16 x i16> undef, <16 x i16> undef)
; MVE-NEXT:  Cost Model: Found an estimated cost of 24 for instruction: %V32I16 = call <32 x i16> @llvm.usub.sat.v32i16(<32 x i16> undef, <32 x i16> undef)
; MVE-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %I8 = call i8 @llvm.usub.sat.i8(i8 undef, i8 undef)
; MVE-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %V16I8 = call <16 x i8> @llvm.usub.sat.v16i8(<16 x i8> undef, <16 x i8> undef)
; MVE-NEXT:  Cost Model: Found an estimated cost of 12 for instruction: %V32I8 = call <32 x i8> @llvm.usub.sat.v32i8(<32 x i8> undef, <32 x i8> undef)
; MVE-NEXT:  Cost Model: Found an estimated cost of 24 for instruction: %V64I8 = call <64 x i8> @llvm.usub.sat.v64i8(<64 x i8> undef, <64 x i8> undef)
; MVE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
  %I64 = call i64 @llvm.usub.sat.i64(i64 undef, i64 undef)
  %V2I64 = call <2 x i64> @llvm.usub.sat.v2i64(<2 x i64> undef, <2 x i64> undef)
  %V4I64 = call <4 x i64> @llvm.usub.sat.v4i64(<4 x i64> undef, <4 x i64> undef)
  %V8I64 = call <8 x i64> @llvm.usub.sat.v8i64(<8 x i64> undef, <8 x i64> undef)

  %I32 = call i32 @llvm.usub.sat.i32(i32 undef, i32 undef)
  %V4I32  = call <4 x i32>  @llvm.usub.sat.v4i32(<4 x i32> undef, <4 x i32> undef)
  %V8I32  = call <8 x i32>  @llvm.usub.sat.v8i32(<8 x i32> undef, <8 x i32> undef)
  %V16I32 = call <16 x i32> @llvm.usub.sat.v16i32(<16 x i32> undef, <16 x i32> undef)

  %I16 = call i16 @llvm.usub.sat.i16(i16 undef, i16 undef)
  %V8I16  = call <8 x i16>  @llvm.usub.sat.v8i16(<8 x i16> undef, <8 x i16> undef)
  %V16I16 = call <16 x i16> @llvm.usub.sat.v16i16(<16 x i16> undef, <16 x i16> undef)
  %V32I16 = call <32 x i16> @llvm.usub.sat.v32i16(<32 x i16> undef, <32 x i16> undef)

  %I8 = call i8 @llvm.usub.sat.i8(i8 undef, i8 undef)
  %V16I8 = call <16 x i8> @llvm.usub.sat.v16i8(<16 x i8> undef, <16 x i8> undef)
  %V32I8 = call <32 x i8> @llvm.usub.sat.v32i8(<32 x i8> undef, <32 x i8> undef)
  %V64I8 = call <64 x i8> @llvm.usub.sat.v64i8(<64 x i8> undef, <64 x i8> undef)

  ret i32 undef
}
