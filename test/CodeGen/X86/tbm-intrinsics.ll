; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+tbm,+cmov | FileCheck %s --check-prefix=X86
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+tbm | FileCheck %s --check-prefix=X64

define i32 @test_x86_tbm_bextri_u32(i32 %a) nounwind readnone {
; X86-LABEL: test_x86_tbm_bextri_u32:
; X86:       # %bb.0: # %entry
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    addl %eax, %eax
; X86-NEXT:    bextrl $3841, %eax, %eax # imm = 0xF01
; X86-NEXT:    retl
;
; X64-LABEL: test_x86_tbm_bextri_u32:
; X64:       # %bb.0: # %entry
; X64-NEXT:    addl %edi, %edi
; X64-NEXT:    bextrl $3841, %edi, %eax # imm = 0xF01
; X64-NEXT:    retq
entry:
  %0 = add i32 %a, %a
  %1 = tail call i32 @llvm.x86.tbm.bextri.u32(i32 %0, i32 3841)
  ret i32 %1
}

declare i32 @llvm.x86.tbm.bextri.u32(i32, i32) nounwind readnone

define i32 @test_x86_tbm_bextri_u32_m(i32* nocapture %a) nounwind readonly {
; X86-LABEL: test_x86_tbm_bextri_u32_m:
; X86:       # %bb.0: # %entry
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    bextrl $3841, (%eax), %eax # imm = 0xF01
; X86-NEXT:    retl
;
; X64-LABEL: test_x86_tbm_bextri_u32_m:
; X64:       # %bb.0: # %entry
; X64-NEXT:    bextrl $3841, (%rdi), %eax # imm = 0xF01
; X64-NEXT:    retq
entry:
  %tmp1 = load i32, i32* %a, align 4
  %0 = tail call i32 @llvm.x86.tbm.bextri.u32(i32 %tmp1, i32 3841)
  ret i32 %0
}

define i32 @test_x86_tbm_bextri_u32_z(i32 %a, i32 %b) nounwind readonly {
; X86-LABEL: test_x86_tbm_bextri_u32_z:
; X86:       # %bb.0: # %entry
; X86-NEXT:    bextrl $3841, {{[0-9]+}}(%esp), %eax # imm = 0xF01
; X86-NEXT:    jne .LBB2_2
; X86-NEXT:  # %bb.1: # %entry
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:  .LBB2_2: # %entry
; X86-NEXT:    retl
;
; X64-LABEL: test_x86_tbm_bextri_u32_z:
; X64:       # %bb.0: # %entry
; X64-NEXT:    bextrl $3841, %edi, %eax # imm = 0xF01
; X64-NEXT:    cmovel %esi, %eax
; X64-NEXT:    retq
entry:
  %0 = tail call i32 @llvm.x86.tbm.bextri.u32(i32 %a, i32 3841)
  %1 = icmp eq i32 %0, 0
  %2 = select i1 %1, i32 %b, i32 %0
  ret i32 %2
}

define i32 @test_x86_tbm_bextri_demandedbits(i32 %x) nounwind readonly {
; X86-LABEL: test_x86_tbm_bextri_demandedbits:
; X86:       # %bb.0:
; X86-NEXT:    bextrl $3841, {{[0-9]+}}(%esp), %eax # imm = 0xF01
; X86-NEXT:    retl
;
; X64-LABEL: test_x86_tbm_bextri_demandedbits:
; X64:       # %bb.0:
; X64-NEXT:    bextrl $3841, %edi, %eax # imm = 0xF01
; X64-NEXT:    retq
  %a = or i32 %x, 4294901761
  %b = tail call i32 @llvm.x86.tbm.bextri.u32(i32 %a, i32 3841)
  ret i32 %b
}
