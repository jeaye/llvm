; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -O3                   -S < %s  | FileCheck %s
; RUN: opt -passes='default<O3>' -S < %s  | FileCheck %s

target triple = "x86_64--"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

; PR42174 - https://bugs.llvm.org/show_bug.cgi?id=42174
; This test should match the IR produced by clang after running -mem2reg.
; All math before the final 'add' should be scalarized.

define <4 x i32> @square(<4 x i32> %num, i32 %y, i32 %x, i32 %h, i32 %k, i32 %w, i32 %p, i32 %j, i32 %u) {
; CHECK-LABEL: @square(
; CHECK-NEXT:    [[DIV:%.*]] = sdiv i32 [[K:%.*]], 2
; CHECK-NEXT:    [[MUL:%.*]] = mul nsw i32 [[P:%.*]], 6234
; CHECK-NEXT:    [[MUL5:%.*]] = mul nsw i32 [[H:%.*]], 75
; CHECK-NEXT:    [[DIV9:%.*]] = sdiv i32 [[J:%.*]], 3452
; CHECK-NEXT:    [[MUL13:%.*]] = mul nsw i32 [[W:%.*]], 53
; CHECK-NEXT:    [[DIV17:%.*]] = sdiv i32 [[X:%.*]], 820
; CHECK-NEXT:    [[MUL21:%.*]] = shl nsw i32 [[U:%.*]], 2
; CHECK-NEXT:    [[DOTSCALAR:%.*]] = add i32 [[Y:%.*]], 1
; CHECK-NEXT:    [[DOTSCALAR1:%.*]] = add i32 [[DOTSCALAR]], [[DIV17]]
; CHECK-NEXT:    [[DOTSCALAR2:%.*]] = add i32 [[DOTSCALAR1]], [[MUL5]]
; CHECK-NEXT:    [[DOTSCALAR3:%.*]] = add i32 [[DOTSCALAR2]], [[DIV]]
; CHECK-NEXT:    [[DOTSCALAR4:%.*]] = add i32 [[DOTSCALAR3]], [[MUL13]]
; CHECK-NEXT:    [[DOTSCALAR5:%.*]] = add i32 [[DOTSCALAR4]], [[MUL]]
; CHECK-NEXT:    [[DOTSCALAR6:%.*]] = add i32 [[DOTSCALAR5]], [[DIV9]]
; CHECK-NEXT:    [[DOTSCALAR7:%.*]] = add i32 [[DOTSCALAR6]], [[MUL21]]
; CHECK-NEXT:    [[DOTSCALAR8:%.*]] = add i32 [[DOTSCALAR7]], 317425
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <4 x i32> poison, i32 [[DOTSCALAR8]], i64 0
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <4 x i32> [[TMP1]], <4 x i32> poison, <4 x i32> zeroinitializer
; CHECK-NEXT:    [[ADD29:%.*]] = add <4 x i32> [[TMP2]], [[NUM:%.*]]
; CHECK-NEXT:    ret <4 x i32> [[ADD29]]
;
  %add = add <4 x i32> %num, <i32 1, i32 1, i32 1, i32 1>
  %div = sdiv i32 %k, 2
  %splatinsert = insertelement <4 x i32> poison, i32 %div, i32 0
  %splat = shufflevector <4 x i32> %splatinsert, <4 x i32> poison, <4 x i32> zeroinitializer
  %add1 = add <4 x i32> %add, %splat
  %mul = mul nsw i32 %p, 6234
  %splatinsert2 = insertelement <4 x i32> poison, i32 %mul, i32 0
  %splat3 = shufflevector <4 x i32> %splatinsert2, <4 x i32> poison, <4 x i32> zeroinitializer
  %add4 = add <4 x i32> %add1, %splat3
  %mul5 = mul nsw i32 75, %h
  %splatinsert6 = insertelement <4 x i32> poison, i32 %mul5, i32 0
  %splat7 = shufflevector <4 x i32> %splatinsert6, <4 x i32> poison, <4 x i32> zeroinitializer
  %add8 = add <4 x i32> %add4, %splat7
  %div9 = sdiv i32 %j, 3452
  %splatinsert10 = insertelement <4 x i32> poison, i32 %div9, i32 0
  %splat11 = shufflevector <4 x i32> %splatinsert10, <4 x i32> poison, <4 x i32> zeroinitializer
  %add12 = add <4 x i32> %add8, %splat11
  %mul13 = mul nsw i32 53, %w
  %splatinsert14 = insertelement <4 x i32> poison, i32 %mul13, i32 0
  %splat15 = shufflevector <4 x i32> %splatinsert14, <4 x i32> poison, <4 x i32> zeroinitializer
  %add16 = add <4 x i32> %add12, %splat15
  %div17 = sdiv i32 %x, 820
  %splatinsert18 = insertelement <4 x i32> poison, i32 %div17, i32 0
  %splat19 = shufflevector <4 x i32> %splatinsert18, <4 x i32> poison, <4 x i32> zeroinitializer
  %add20 = add <4 x i32> %add16, %splat19
  %mul21 = mul nsw i32 4, %u
  %splatinsert22 = insertelement <4 x i32> poison, i32 %mul21, i32 0
  %splat23 = shufflevector <4 x i32> %splatinsert22, <4 x i32> poison, <4 x i32> zeroinitializer
  %add24 = add <4 x i32> %add20, %splat23
  %splatinsert25 = insertelement <4 x i32> poison, i32 %y, i32 0
  %splat26 = shufflevector <4 x i32> %splatinsert25, <4 x i32> poison, <4 x i32> zeroinitializer
  %add27 = add <4 x i32> %add24, %splat26
  %add28 = add <4 x i32> %add27, <i32 25, i32 25, i32 25, i32 25>
  %add29 = add <4 x i32> %add28, <i32 317400, i32 317400, i32 317400, i32 317400>
  ret <4 x i32> %add29
}

