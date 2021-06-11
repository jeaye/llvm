; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-linux-android -mattr=+mmx -enable-legalize-types-checking | FileCheck %s
;
; D31946
; Check that we dont end up with the ""LLVM ERROR: Cannot select" error.
; Additionally ensure that the output code actually put fp128 values in SSE registers.

declare fp128 @llvm.fabs.f128(fp128)
declare fp128 @llvm.copysign.f128(fp128, fp128)

define fp128 @TestSelect(fp128 %a, fp128 %b) {
; CHECK-LABEL: TestSelect:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    subq $32, %rsp
; CHECK-NEXT:    .cfi_def_cfa_offset 48
; CHECK-NEXT:    .cfi_offset %rbx, -16
; CHECK-NEXT:    movaps %xmm1, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; CHECK-NEXT:    movaps %xmm0, (%rsp) # 16-byte Spill
; CHECK-NEXT:    callq __gttf2@PLT
; CHECK-NEXT:    movl %eax, %ebx
; CHECK-NEXT:    movaps (%rsp), %xmm0 # 16-byte Reload
; CHECK-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm1 # 16-byte Reload
; CHECK-NEXT:    callq __subtf3@PLT
; CHECK-NEXT:    testl %ebx, %ebx
; CHECK-NEXT:    jg .LBB0_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    xorps %xmm0, %xmm0
; CHECK-NEXT:  .LBB0_2:
; CHECK-NEXT:    addq $32, %rsp
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    retq
  %cmp = fcmp ogt fp128 %a, %b
  %sub = fsub fp128 %a, %b
  %res = select i1 %cmp, fp128 %sub, fp128 0xL00000000000000000000000000000000
  ret fp128 %res
}

define fp128 @TestFabs(fp128 %a) {
; CHECK-LABEL: TestFabs:
; CHECK:       # %bb.0:
; CHECK-NEXT:    andps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; CHECK-NEXT:    retq
  %res = call fp128 @llvm.fabs.f128(fp128 %a)
  ret fp128 %res
}

define fp128 @TestCopysign(fp128 %a, fp128 %b) {
; CHECK-LABEL: TestCopysign:
; CHECK:       # %bb.0:
; CHECK-NEXT:    andps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1
; CHECK-NEXT:    andps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; CHECK-NEXT:    orps %xmm1, %xmm0
; CHECK-NEXT:    retq
  %res = call fp128 @llvm.copysign.f128(fp128 %a, fp128 %b)
  ret fp128 %res
}

define fp128 @TestFneg(fp128 %a) {
; CHECK-LABEL: TestFneg:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    movaps %xmm0, %xmm1
; CHECK-NEXT:    callq __multf3@PLT
; CHECK-NEXT:    xorps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    retq
  %mul = fmul fp128 %a, %a
  %res = fsub fp128 0xL00000000000000008000000000000000, %mul
  ret fp128 %res
}
