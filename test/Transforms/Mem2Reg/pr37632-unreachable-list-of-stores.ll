; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -mem2reg < %s -S | FileCheck %s

define void @patatino() {
; CHECK-LABEL: @patatino(
; CHECK-NEXT:    ret void
; CHECK:       cantreachme:
; CHECK-NEXT:    [[DEC:%.*]] = add nsw i32 undef, -1
; CHECK-NEXT:    br label [[CANTREACHME:%.*]]
;
  %a = alloca i32, align 4
  ret void
cantreachme:
  %dec = add nsw i32 %tmp, -1
  store i32 %dec, i32* %a
  store i32 %tmp, i32* %a
  %tmp = load i32, i32* %a
  br label %cantreachme
}
