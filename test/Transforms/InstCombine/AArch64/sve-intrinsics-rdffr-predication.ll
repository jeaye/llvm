; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -instcombine < %s | FileCheck %s

target triple = "aarch64-unknown-linux-gnu"

; Test that rdffr is substituted with predicated form which enables ptest optimization later.
define <vscale x 16 x i1> @predicate_rdffr() #0 {
; CHECK-LABEL: @predicate_rdffr(
; CHECK-NEXT:    [[TMP1:%.*]] = call <vscale x 16 x i1> @llvm.aarch64.sve.ptrue.nxv16i1(i32 31)
; CHECK-NEXT:    [[OUT:%.*]] = call <vscale x 16 x i1> @llvm.aarch64.sve.rdffr.z(<vscale x 16 x i1> [[TMP1]])
; CHECK-NEXT:    ret <vscale x 16 x i1> [[OUT]]
;
  %out = call <vscale x 16 x i1> @llvm.aarch64.sve.rdffr()
  ret <vscale x 16 x i1> %out
}

declare <vscale x 16 x i1> @llvm.aarch64.sve.rdffr()

attributes #0 = { "target-features"="+sve" }
