; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-linux-gnu   | FileCheck %s -check-prefix=X86
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu | FileCheck %s -check-prefix=X64
; RUN: llc < %s -mtriple=x86_64-linux-gnux32      | FileCheck %s -check-prefix=X32

define zeroext i8 @foo() nounwind ssp {
; X86-LABEL: foo:
; X86:       # %bb.0: # %entry
; X86-NEXT:    subl $12, %esp
; X86-NEXT:    calll bar
; X86-NEXT:    movb %ah, %al
; X86-NEXT:    addl $12, %esp
; X86-NEXT:    retl
;
; X64-LABEL: foo:
; X64:       # %bb.0: # %entry
; X64-NEXT:    pushq %rax
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    callq bar
; X64-NEXT:    # kill: def $ax killed $ax def $eax
; X64-NEXT:    shrl $8, %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    popq %rcx
; X64-NEXT:    retq
;
; X32-LABEL: foo:
; X32:       # %bb.0: # %entry
; X32-NEXT:    pushq %rax
; X32-NEXT:    xorl %eax, %eax
; X32-NEXT:    callq bar
; X32-NEXT:    # kill: def $ax killed $ax def $eax
; X32-NEXT:    shrl $8, %eax
; X32-NEXT:    # kill: def $al killed $al killed $eax
; X32-NEXT:    popq %rcx
; X32-NEXT:    retq
entry:
  %0 = tail call zeroext i16 (...) @bar() nounwind
  %1 = lshr i16 %0, 8
  %2 = trunc i16 %1 to i8
  ret i8 %2



}

declare zeroext i16 @bar(...)
