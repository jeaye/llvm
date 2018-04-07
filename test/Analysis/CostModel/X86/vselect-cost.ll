; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt < %s -cost-model -analyze -mtriple=x86_64-unknown-linux-gnu -mattr=+sse2 | FileCheck %s -check-prefixes=CHECK,SSE,SSE2
; RUN: opt < %s -cost-model -analyze -mtriple=x86_64-unknown-linux-gnu -mattr=+sse4.1 | FileCheck %s -check-prefixes=CHECK,SSE,SSE41
; RUN: opt < %s -cost-model -analyze -mtriple=x86_64-unknown-linux-gnu -mattr=+avx | FileCheck %s -check-prefixes=CHECK,AVX,AVX1
; RUN: opt < %s -cost-model -analyze -mtriple=x86_64-unknown-linux-gnu -mattr=+avx2 | FileCheck %s -check-prefixes=CHECK,AVX,AVX2


; Verify the cost of vector select instructions.

; SSE41 added blend instructions with an immediate for <2 x double> and
; <4 x float>. Integers of the same size should also use those instructions.

define <2 x i64> @test_2i64(<2 x i64> %a, <2 x i64> %b) {
; CHECK-LABEL: 'test_2i64'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sel = select <2 x i1> <i1 true, i1 false>, <2 x i64> %a, <2 x i64> %b
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <2 x i64> %sel
;
  %sel = select <2 x i1> <i1 true, i1 false>, <2 x i64> %a, <2 x i64> %b
  ret <2 x i64> %sel
}

define <2 x double> @test_2double(<2 x double> %a, <2 x double> %b) {
; CHECK-LABEL: 'test_2double'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sel = select <2 x i1> <i1 true, i1 false>, <2 x double> %a, <2 x double> %b
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <2 x double> %sel
;
  %sel = select <2 x i1> <i1 true, i1 false>, <2 x double> %a, <2 x double> %b
  ret <2 x double> %sel
}

define <4 x i32> @test_4i32(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: 'test_4i32'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sel = select <4 x i1> <i1 true, i1 false, i1 true, i1 false>, <4 x i32> %a, <4 x i32> %b
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i32> %sel
;
  %sel = select <4 x i1> <i1 true, i1 false, i1 true, i1 false>, <4 x i32> %a, <4 x i32> %b
  ret <4 x i32> %sel
}

define <4 x float> @test_4float(<4 x float> %a, <4 x float> %b) {
; CHECK-LABEL: 'test_4float'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sel = select <4 x i1> <i1 true, i1 false, i1 true, i1 true>, <4 x float> %a, <4 x float> %b
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x float> %sel
;
  %sel = select <4 x i1> <i1 true, i1 false, i1 true, i1 true>, <4 x float> %a, <4 x float> %b
  ret <4 x float> %sel
}

define <16 x i8> @test_16i8(<16 x i8> %a, <16 x i8> %b) {
; CHECK-LABEL: 'test_16i8'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sel = select <16 x i1> <i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true>, <16 x i8> %a, <16 x i8> %b
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <16 x i8> %sel
;
  %sel = select <16 x i1> <i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true>, <16 x i8> %a, <16 x i8> %b
  ret <16 x i8> %sel
}

; AVX added blend instructions with an immediate for <4 x double> and
; <8 x float>. Integers of the same size should also use those instructions.
define <4 x i64> @test_4i64(<4 x i64> %a, <4 x i64> %b) {
; SSE-LABEL: 'test_4i64'
; SSE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %sel = select <4 x i1> <i1 true, i1 false, i1 false, i1 true>, <4 x i64> %a, <4 x i64> %b
; SSE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i64> %sel
;
; AVX-LABEL: 'test_4i64'
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sel = select <4 x i1> <i1 true, i1 false, i1 false, i1 true>, <4 x i64> %a, <4 x i64> %b
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i64> %sel
;
  %sel = select <4 x i1> <i1 true, i1 false, i1 false, i1 true>, <4 x i64> %a, <4 x i64> %b
  ret <4 x i64> %sel
}

define <4 x double> @test_4double(<4 x double> %a, <4 x double> %b) {
; SSE-LABEL: 'test_4double'
; SSE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %sel = select <4 x i1> <i1 true, i1 false, i1 true, i1 false>, <4 x double> %a, <4 x double> %b
; SSE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x double> %sel
;
; AVX-LABEL: 'test_4double'
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sel = select <4 x i1> <i1 true, i1 false, i1 true, i1 false>, <4 x double> %a, <4 x double> %b
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x double> %sel
;
  %sel = select <4 x i1> <i1 true, i1 false, i1 true, i1 false>, <4 x double> %a, <4 x double> %b
  ret <4 x double> %sel
}

define <8 x i32> @test_8i32(<8 x i32> %a, <8 x i32> %b) {
; SSE-LABEL: 'test_8i32'
; SSE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %sel = select <8 x i1> <i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 false>, <8 x i32> %a, <8 x i32> %b
; SSE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x i32> %sel
;
; AVX-LABEL: 'test_8i32'
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sel = select <8 x i1> <i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 false>, <8 x i32> %a, <8 x i32> %b
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x i32> %sel
;
  %sel = select <8 x i1> <i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 false>, <8 x i32> %a, <8 x i32> %b
  ret <8 x i32> %sel
}

define <8 x float> @test_8float(<8 x float> %a, <8 x float> %b) {
; SSE-LABEL: 'test_8float'
; SSE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %sel = select <8 x i1> <i1 true, i1 false, i1 false, i1 false, i1 true, i1 false, i1 false, i1 false>, <8 x float> %a, <8 x float> %b
; SSE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x float> %sel
;
; AVX-LABEL: 'test_8float'
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sel = select <8 x i1> <i1 true, i1 false, i1 false, i1 false, i1 true, i1 false, i1 false, i1 false>, <8 x float> %a, <8 x float> %b
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x float> %sel
;
  %sel = select <8 x i1> <i1 true, i1 false, i1 false, i1 false, i1 true, i1 false, i1 false, i1 false>, <8 x float> %a, <8 x float> %b
  ret <8 x float> %sel
}

; AVX2
define <16 x i16> @test_16i16(<16 x i16> %a, <16 x i16> %b) {
; SSE-LABEL: 'test_16i16'
; SSE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %sel = select <16 x i1> <i1 true, i1 false, i1 false, i1 false, i1 true, i1 false, i1 false, i1 false, i1 true, i1 false, i1 false, i1 false, i1 true, i1 false, i1 false, i1 false>, <16 x i16> %a, <16 x i16> %b
; SSE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <16 x i16> %sel
;
; AVX-LABEL: 'test_16i16'
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sel = select <16 x i1> <i1 true, i1 false, i1 false, i1 false, i1 true, i1 false, i1 false, i1 false, i1 true, i1 false, i1 false, i1 false, i1 true, i1 false, i1 false, i1 false>, <16 x i16> %a, <16 x i16> %b
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <16 x i16> %sel
;
  %sel = select <16 x i1> <i1 true, i1 false, i1 false, i1 false, i1 true, i1 false, i1 false, i1 false, i1 true, i1 false, i1 false, i1 false, i1 true, i1 false, i1 false, i1 false>, <16 x i16> %a, <16 x i16> %b
  ret <16 x i16> %sel
}

define <32 x i8> @test_32i8(<32 x i8> %a, <32 x i8> %b) {
; SSE-LABEL: 'test_32i8'
; SSE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %sel = select <32 x i1> <i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true>, <32 x i8> %a, <32 x i8> %b
; SSE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <32 x i8> %sel
;
; AVX-LABEL: 'test_32i8'
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sel = select <32 x i1> <i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true>, <32 x i8> %a, <32 x i8> %b
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <32 x i8> %sel
;
  %sel = select <32 x i1> <i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true>, <32 x i8> %a, <32 x i8> %b
  ret <32 x i8> %sel
}

