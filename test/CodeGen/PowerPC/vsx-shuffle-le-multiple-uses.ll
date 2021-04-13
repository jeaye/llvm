; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py

; RUN: llc -verify-machineinstrs -mcpu=pwr9 -mattr=+vsx \
; RUN:   -mtriple=powerpc64le-unknown-linux-gnu < %s | FileCheck %s

define <2 x double> @loadHasMultipleUses(<2 x double>* %p1, <2 x double>* %p2) {
; CHECK-LABEL: loadHasMultipleUses:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lxv 0, 0(3)
; CHECK-NEXT:    xxswapd 34, 0
; CHECK-NEXT:    stxv 0, 0(4)
; CHECK-NEXT:    blr
  %v1 = load <2 x double>, <2 x double>* %p1
  store <2 x double> %v1, <2 x double>* %p2, align 16
  %v2 = shufflevector <2 x double> %v1, <2 x double> %v1, <2 x i32> < i32 1, i32 0>
  ret <2 x double> %v2
}

define <2 x double> @storeHasMultipleUses(<2 x double> %v, <2 x double>* %p) {
; CHECK-LABEL: storeHasMultipleUses:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xxswapd 34, 34
; CHECK-NEXT:    stxv 34, 256(5)
; CHECK-NEXT:    blr
  %v1 = shufflevector <2 x double> %v, <2 x double> %v, <2 x i32> < i32 1, i32 0>
  %addr = getelementptr inbounds <2 x double>, <2 x double>* %p, i64 16
  store <2 x double> %v1, <2 x double>* %addr, align 16
  %v2 = shufflevector <2 x double> %v, <2 x double> %v, <2 x i32> < i32 1, i32 2>
  ret <2 x double> %v2
}

