; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64-none-linux-gnu | FileCheck %s

define i8 @test() {
; CHECK-LABEL: test:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    adrp x8, foo
; CHECK-NEXT:    ldrb w0, [x8, :lo12:foo]
; CHECK-NEXT:    ret
entry:
  %0 = load i8, i8* bitcast (void (...)* @foo to i8*), align 1
  ret i8 %0
}

declare void @foo(...)
