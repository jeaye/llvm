; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown | FileCheck %s

; Compiling the select should not create 'seta - testb $1 - jump' sequence.
define i32 @f(i32 %x, i32 %y) {
; CHECK-LABEL: f:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    cmpl %esi, %edi
; CHECK-NEXT:    ja .LBB0_2
; CHECK-NEXT:  # %bb.1: # %select.false
; CHECK-NEXT:    movl %esi, %eax
; CHECK-NEXT:  .LBB0_2: # %select.end
; CHECK-NEXT:    retq
entry:
  %cmp = icmp ugt i32 %x, %y
  %z = select i1 %cmp, i32 %x, i32 %y, !prof !0
  ret i32 %z
}

!0 = !{!"branch_weights", i32 1, i32 2000}
