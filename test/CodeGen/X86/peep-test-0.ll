; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-- | FileCheck %s

define void @loop(i64 %n, double* nocapture %d) nounwind {
; CHECK-LABEL: loop:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    shlq $4, %rax
; CHECK-NEXT:    addq %rsi, %rax
; CHECK-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB0_1: # %bb
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm0, %xmm1
; CHECK-NEXT:    movsd %xmm1, (%rax)
; CHECK-NEXT:    addq $8, %rax
; CHECK-NEXT:    incq %rdi
; CHECK-NEXT:    jne .LBB0_1
; CHECK-NEXT:  # %bb.2: # %return
; CHECK-NEXT:    retq
entry:
	br label %bb

bb:
	%indvar = phi i64 [ %n, %entry ], [ %indvar.next, %bb ]
	%i.03 = add i64 %indvar, %n
	%0 = getelementptr double, double* %d, i64 %i.03
	%1 = load double, double* %0, align 8
	%2 = fmul double %1, 3.000000e+00
	store double %2, double* %0, align 8
	%indvar.next = add i64 %indvar, 1
	%exitcond = icmp eq i64 %indvar.next, 0
	br i1 %exitcond, label %return, label %bb

return:
	ret void
}
