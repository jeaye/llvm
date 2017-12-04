; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-apple-darwin -mattr=clflushopt | FileCheck %s --check-prefix=X86
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mattr=clflushopt | FileCheck %s --check-prefix=X64

define void @clflushopt(i8* %p) nounwind {
; X86-LABEL: clflushopt:
; X86:       ## %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    clflushopt (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: clflushopt:
; X64:       ## %bb.0:
; X64-NEXT:    clflushopt (%rdi)
; X64-NEXT:    retq
  tail call void @llvm.x86.clflushopt(i8* %p)
  ret void
}
declare void @llvm.x86.clflushopt(i8*) nounwind
