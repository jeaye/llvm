; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc %s -verify-machineinstrs -mtriple aarch64-apple-darwin -global-isel -global-isel-abort=1 -o - 2>&1 | FileCheck %s

; Check that we get a tail call to foo without saving fp/lr.
define void @bar(i32 %a) #1 {
; CHECK-LABEL: bar:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    b _zoo
entry:
  tail call void @zoo(i32 undef)
  ret void
}

define void @zoo(i32 %a) {
entry:
  ret void
}

attributes #1 = { "frame-pointer"="all" }

