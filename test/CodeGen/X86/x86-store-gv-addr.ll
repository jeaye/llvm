; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-apple-darwin -relocation-model=static | FileCheck %s --check-prefix=x86_64-darwin
; RUN: llc < %s -mtriple=x86_64-pc-linux-gnu -relocation-model=static | FileCheck %s --check-prefix=x86_64-linux

@v = external global i32, align 8
@v_addr = external global i32*, align 8

define void @t() nounwind optsize {
; x86_64-darwin-LABEL: t:
; x86_64-darwin:       ## %bb.0:
; x86_64-darwin-NEXT:    movq _v@GOTPCREL(%rip), %rax
; x86_64-darwin-NEXT:    movq _v_addr@GOTPCREL(%rip), %rcx
; x86_64-darwin-NEXT:    movq %rax, (%rcx)
; x86_64-darwin-NEXT:    ud2
;
; x86_64-linux-LABEL: t:
; x86_64-linux:       # %bb.0:
; x86_64-linux-NEXT:    movq v@GOTPCREL(%rip), %rax
; x86_64-linux-NEXT:    movq v_addr@GOTPCREL(%rip), %rcx
; x86_64-linux-NEXT:    movq %rax, (%rcx)
	store i32* @v, i32** @v_addr, align 8
	unreachable
}
