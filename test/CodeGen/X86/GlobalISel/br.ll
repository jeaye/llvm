; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -O0 -mtriple=x86_64-linux-gnu    -global-isel -verify-machineinstrs %s -o - | FileCheck %s

define void @uncondbr() {
; CHECK-LABEL: uncondbr:
; CHECK:       # %bb.1: # %entry
; CHECK-NEXT:    jmp .LBB0_3
; CHECK-NEXT:  .LBB0_2: # %end
; CHECK-NEXT:    retq
; CHECK-NEXT:  .LBB0_3: # %bb2
; CHECK-NEXT:    jmp .LBB0_2
entry:
  br label %bb2
end:
  ret void
bb2:
  br label %end
}

