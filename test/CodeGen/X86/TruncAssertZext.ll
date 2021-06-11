; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -O2 -mtriple=x86_64-unknown-unknown | FileCheck %s
; Checks that a zeroing mov is inserted for the trunc/zext pair even when
; the source of the zext is an AssertZext node
; PR28540

define i64 @foo() {
; CHECK-LABEL: foo:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq $-1, %rax
; CHECK-NEXT:    retq
  ret i64 -1
}

define i64 @main() {
; CHECK-LABEL: main:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq foo@PLT
; CHECK-NEXT:    movabsq $-4294967041, %rcx # imm = 0xFFFFFFFF000000FF
; CHECK-NEXT:    andq %rax, %rcx
; CHECK-NEXT:    movl %ecx, %ecx
; CHECK-NEXT:    leaq (,%rcx,8), %rax
; CHECK-NEXT:    subq %rcx, %rax
; CHECK-NEXT:    shrq $32, %rax
; CHECK-NEXT:    popq %rcx
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    retq
  %b = call i64 @foo()
  %or = and i64 %b, 18446744069414584575 ; this is 0xffffffff000000ff
  %trunc = trunc i64 %or to i32
  br label %l
l:
  %ext = zext i32 %trunc to i64
  %mul = mul i64 %ext, 7
  br label %m
m: ; keeps dag combine from seeing the multiply and the shift together
  %shr = lshr i64 %mul, 32
  trunc i64 %or to i32 ; keeps the and alive so it doesn't simplify
  ret i64 %shr
}
