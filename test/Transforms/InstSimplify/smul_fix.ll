; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -S -instsimplify | FileCheck %s

declare i16 @llvm.smul.fix.i16(i16, i16, i32)
declare i16 @llvm.smul.fix.sat.i16(i16, i16, i32)
declare <2 x i16> @llvm.smul.fix.v2i16(<2 x i16>, <2 x i16>, i32)
declare <2 x i16> @llvm.smul.fix.sat.v2i16(<2 x i16>, <2 x i16>, i32)

;;
;; llvm.smul.fix (scalar)
;;

; X * 0 -> X
define i16 @smul_fix_0(i16 %arg) {
; CHECK-LABEL: @smul_fix_0(
; CHECK-NEXT:    ret i16 0
;
  %res = call i16 @llvm.smul.fix.i16(i16 %arg, i16 0, i32 15)
  ret i16 %res
}

; 0 * X -> X
define i16 @smul_fix_1(i16 %arg) {
; CHECK-LABEL: @smul_fix_1(
; CHECK-NEXT:    ret i16 0
;
  %res = call i16 @llvm.smul.fix.i16(i16 0, i16 %arg, i32 15)
  ret i16 %res
}

; X * undef -> undef
define i16 @smul_fix_2(i16 %arg) {
; CHECK-LABEL: @smul_fix_2(
; CHECK-NEXT:    ret i16 0
;
  %res = call i16 @llvm.smul.fix.i16(i16 %arg, i16 undef, i32 15)
  ret i16 %res
}

; undef * X -> undef
define i16 @smul_fix_3(i16 %arg) {
; CHECK-LABEL: @smul_fix_3(
; CHECK-NEXT:    ret i16 0
;
  %res = call i16 @llvm.smul.fix.i16(i16 undef, i16 %arg, i32 15)
  ret i16 %res
}

; X * 1 -> X
define i16 @smul_fix_4(i16 %arg) {
; CHECK-LABEL: @smul_fix_4(
; CHECK-NEXT:    ret i16 [[ARG:%.*]]
;
  %res = call i16 @llvm.smul.fix.i16(i16 %arg, i16 16384, i32 14)
  ret i16 %res
}

; 1 * X -> X
define i16 @smul_fix_5(i16 %arg) {
; CHECK-LABEL: @smul_fix_5(
; CHECK-NEXT:    ret i16 [[ARG:%.*]]
;
  %res = call i16 @llvm.smul.fix.i16(i16 2, i16 %arg, i32 1)
  ret i16 %res
}

;;
;; llvm.smul.fix.sat (scalar)
;;

; X * 0 -> X
define i16 @smul_fix_sat_0(i16 %arg) {
; CHECK-LABEL: @smul_fix_sat_0(
; CHECK-NEXT:    ret i16 0
;
  %res = call i16 @llvm.smul.fix.sat.i16(i16 %arg, i16 0, i32 15)
  ret i16 %res
}

; 0 * X -> X
define i16 @smul_fix_sat_1(i16 %arg) {
; CHECK-LABEL: @smul_fix_sat_1(
; CHECK-NEXT:    ret i16 0
;
  %res = call i16 @llvm.smul.fix.sat.i16(i16 0, i16 %arg, i32 15)
  ret i16 %res
}

; X * undef -> undef
define i16 @smul_fix_sat_2(i16 %arg) {
; CHECK-LABEL: @smul_fix_sat_2(
; CHECK-NEXT:    ret i16 0
;
  %res = call i16 @llvm.smul.fix.sat.i16(i16 %arg, i16 undef, i32 15)
  ret i16 %res
}

; undef * X -> undef
define i16 @smul_fix_sat_3(i16 %arg) {
; CHECK-LABEL: @smul_fix_sat_3(
; CHECK-NEXT:    ret i16 0
;
  %res = call i16 @llvm.smul.fix.sat.i16(i16 undef, i16 %arg, i32 15)
  ret i16 %res
}

; X * 1 -> X
define i16 @smul_fix_sat_4(i16 %arg) {
; CHECK-LABEL: @smul_fix_sat_4(
; CHECK-NEXT:    ret i16 [[ARG:%.*]]
;
  %res = call i16 @llvm.smul.fix.sat.i16(i16 %arg, i16 16384, i32 14)
  ret i16 %res
}

; 1 * X -> X
define i16 @smul_fix_sat_5(i16 %arg) {
; CHECK-LABEL: @smul_fix_sat_5(
; CHECK-NEXT:    ret i16 [[ARG:%.*]]
;
  %res = call i16 @llvm.smul.fix.sat.i16(i16 2, i16 %arg, i32 1)
  ret i16 %res
}

;;
;; llvm.smul.fix (vector)
;;

; X * 0 -> X
define <2 x i16> @smul_fix_vec_0(<2 x i16> %arg) {
; CHECK-LABEL: @smul_fix_vec_0(
; CHECK-NEXT:    ret <2 x i16> zeroinitializer
;
  %res = call <2 x i16> @llvm.smul.fix.v2i16(<2 x i16> %arg, <2 x i16> zeroinitializer, i32 15)
  ret <2 x i16> %res
}

; 0 * X -> X
define <2 x i16> @smul_fix_vec_1(<2 x i16> %arg) {
; CHECK-LABEL: @smul_fix_vec_1(
; CHECK-NEXT:    ret <2 x i16> zeroinitializer
;
  %res = call <2 x i16> @llvm.smul.fix.v2i16(<2 x i16> zeroinitializer, <2 x i16> %arg, i32 15)
  ret <2 x i16> %res
}

; X * undef -> undef
define <2 x i16> @smul_fix_vec_2(<2 x i16> %arg) {
; CHECK-LABEL: @smul_fix_vec_2(
; CHECK-NEXT:    ret <2 x i16> zeroinitializer
;
  %res = call <2 x i16> @llvm.smul.fix.v2i16(<2 x i16> %arg, <2 x i16> undef, i32 15)
  ret <2 x i16> %res
}

; undef * X -> undef
define <2 x i16> @smul_fix_vec_3(<2 x i16> %arg) {
; CHECK-LABEL: @smul_fix_vec_3(
; CHECK-NEXT:    ret <2 x i16> zeroinitializer
;
  %res = call <2 x i16> @llvm.smul.fix.v2i16(<2 x i16> undef, <2 x i16> %arg, i32 15)
  ret <2 x i16> %res
}

; X * 1 -> X
define <2 x i16> @smul_fix_vec_4(<2 x i16> %arg) {
; CHECK-LABEL: @smul_fix_vec_4(
; CHECK-NEXT:    ret <2 x i16> [[ARG:%.*]]
;
  %res = call <2 x i16> @llvm.smul.fix.v2i16(<2 x i16> %arg, <2 x i16> <i16 16384, i16 16384>, i32 14)
  ret <2 x i16> %res
}

; 1 * X -> X
define <2 x i16> @smul_fix_vec_5(<2 x i16> %arg) {
; CHECK-LABEL: @smul_fix_vec_5(
; CHECK-NEXT:    ret <2 x i16> [[ARG:%.*]]
;
  %res = call <2 x i16> @llvm.smul.fix.v2i16(<2 x i16> <i16 2, i16 2>, <2 x i16> %arg, i32 1)
  ret <2 x i16> %res
}

;;
;; llvm.smul.fix.sat (vector)
;;

; X * 0 -> X
define <2 x i16> @smul_fix_sat_vec_0(<2 x i16> %arg) {
; CHECK-LABEL: @smul_fix_sat_vec_0(
; CHECK-NEXT:    ret <2 x i16> zeroinitializer
;
  %res = call <2 x i16> @llvm.smul.fix.sat.v2i16(<2 x i16> %arg, <2 x i16> zeroinitializer, i32 15)
  ret <2 x i16> %res
}

; 0 * X -> X
define <2 x i16> @smul_fix_sat_vec_1(<2 x i16> %arg) {
; CHECK-LABEL: @smul_fix_sat_vec_1(
; CHECK-NEXT:    ret <2 x i16> zeroinitializer
;
  %res = call <2 x i16> @llvm.smul.fix.sat.v2i16(<2 x i16> zeroinitializer, <2 x i16> %arg, i32 15)
  ret <2 x i16> %res
}

; X * undef -> undef
define <2 x i16> @smul_fix_sat_vec_2(<2 x i16> %arg) {
; CHECK-LABEL: @smul_fix_sat_vec_2(
; CHECK-NEXT:    ret <2 x i16> zeroinitializer
;
  %res = call <2 x i16> @llvm.smul.fix.sat.v2i16(<2 x i16> %arg, <2 x i16> undef, i32 15)
  ret <2 x i16> %res
}

; undef * X -> undef
define <2 x i16> @smul_fix_sat_vec_3(<2 x i16> %arg) {
; CHECK-LABEL: @smul_fix_sat_vec_3(
; CHECK-NEXT:    ret <2 x i16> zeroinitializer
;
  %res = call <2 x i16> @llvm.smul.fix.sat.v2i16(<2 x i16> undef, <2 x i16> %arg, i32 15)
  ret <2 x i16> %res
}

; X * 1 -> X
define <2 x i16> @smul_fix_sat_vec_4(<2 x i16> %arg) {
; CHECK-LABEL: @smul_fix_sat_vec_4(
; CHECK-NEXT:    ret <2 x i16> [[ARG:%.*]]
;
  %res = call <2 x i16> @llvm.smul.fix.sat.v2i16(<2 x i16> %arg, <2 x i16> <i16 16384, i16 16384>, i32 14)
  ret <2 x i16> %res
}

; 1 * X -> X
define <2 x i16> @smul_fix_sat_vec_5(<2 x i16> %arg) {
; CHECK-LABEL: @smul_fix_sat_vec_5(
; CHECK-NEXT:    ret <2 x i16> [[ARG:%.*]]
;
  %res = call <2 x i16> @llvm.smul.fix.sat.v2i16(<2 x i16> <i16 2, i16 2>, <2 x i16> %arg, i32 1)
  ret <2 x i16> %res
}
