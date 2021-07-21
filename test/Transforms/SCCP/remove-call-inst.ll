; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -S -ipsccp | FileCheck %s
; PR5596

; IPSCCP should propagate the 0 argument, eliminate the switch, and propagate
; the result.

define i32 @main() noreturn nounwind {
; CHECK-LABEL: @main(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret i32 123
;
entry:
  %call2 = tail call i32 @wwrite(i64 0) nounwind
  ret i32 %call2
}

define internal i32 @wwrite(i64 %i) nounwind readnone willreturn {
; CHECK-LABEL: @wwrite(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[SW_DEFAULT:%.*]]
; CHECK:       sw.default:
; CHECK-NEXT:    ret i32 undef
;
entry:
  switch i64 %i, label %sw.default [
  i64 3, label %return
  i64 10, label %return
  ]

sw.default:
  ret i32 123

return:
  ret i32 0
}

; CHECK: attributes #0 = { noreturn nounwind }
; CHECK: attributes #1 = { nounwind readnone willreturn }
