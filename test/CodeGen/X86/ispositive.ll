; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-- | FileCheck %s

define i32 @test1(i32 %X) {
; CHECK-LABEL: test1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    shrl $31, %eax
; CHECK-NEXT:    retl
entry:
        icmp slt i32 %X, 0              ; <i1>:0 [#uses=1]
        zext i1 %0 to i32               ; <i32>:1 [#uses=1]
        ret i32 %1
}

