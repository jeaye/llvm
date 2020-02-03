; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+sse2,+bmi | FileCheck %s --check-prefixes=X32
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse2,+bmi | FileCheck %s --check-prefixes=X64

declare i32 @llvm.x86.bmi.bextr.32(i32, i32)

define i32 @bextr_zero_length(i32 %x, i32 %y) {
; X32-LABEL: bextr_zero_length:
; X32:       # %bb.0:
; X32-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    bextrl %eax, {{[0-9]+}}(%esp), %eax
; X32-NEXT:    retl
;
; X64-LABEL: bextr_zero_length:
; X64:       # %bb.0:
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    retq
  %1 = and i32 %y, 255
  %2 = tail call i32 @llvm.x86.bmi.bextr.32(i32 %x, i32 %1)
  ret i32 %2
}

define i32 @bextr_big_shift(i32 %x, i32 %y) {
; X32-LABEL: bextr_big_shift:
; X32:       # %bb.0:
; X32-NEXT:    movl $255, %eax
; X32-NEXT:    orl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    bextrl %eax, {{[0-9]+}}(%esp), %eax
; X32-NEXT:    retl
;
; X64-LABEL: bextr_big_shift:
; X64:       # %bb.0:
; X64-NEXT:    orl $255, %esi
; X64-NEXT:    bextrl %esi, %edi, %eax
; X64-NEXT:    retq
  %1 = or i32 %y, 255
  %2 = tail call i32 @llvm.x86.bmi.bextr.32(i32 %x, i32 %1)
  ret i32 %2
}

define float @bextr_uitofp(i32 %x, i32 %y) {
; X32-LABEL: bextr_uitofp:
; X32:       # %bb.0:
; X32-NEXT:    pushl %eax
; X32-NEXT:    .cfi_def_cfa_offset 8
; X32-NEXT:    movl $3855, %eax # imm = 0xF0F
; X32-NEXT:    bextrl %eax, {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movq {{.*#+}} xmm0 = mem[0],zero
; X32-NEXT:    movd %eax, %xmm1
; X32-NEXT:    por %xmm0, %xmm1
; X32-NEXT:    subsd %xmm0, %xmm1
; X32-NEXT:    xorps %xmm0, %xmm0
; X32-NEXT:    cvtsd2ss %xmm1, %xmm0
; X32-NEXT:    movss %xmm0, (%esp)
; X32-NEXT:    flds (%esp)
; X32-NEXT:    popl %eax
; X32-NEXT:    .cfi_def_cfa_offset 4
; X32-NEXT:    retl
;
; X64-LABEL: bextr_uitofp:
; X64:       # %bb.0:
; X64-NEXT:    movl $3855, %eax # imm = 0xF0F
; X64-NEXT:    bextrl %eax, %edi, %eax
; X64-NEXT:    cvtsi2ss %eax, %xmm0
; X64-NEXT:    retq
  %1 = tail call i32 @llvm.x86.bmi.bextr.32(i32 %x, i32 3855)
  %2 = uitofp i32 %1 to float
  ret float %2
}
