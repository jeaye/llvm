; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-apple-macosx | FileCheck %s

; TODO: We can get rid of movq here by using different offset and %rax.
define i32 @test_01(i32* %p, i64 %len, i32 %x) {
; CHECK-LABEL: test_01:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    movq %rsi, %rax
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  LBB0_1: ## %loop
; CHECK-NEXT:    ## =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    subq $1, %rax
; CHECK-NEXT:    jb LBB0_4
; CHECK-NEXT:  ## %bb.2: ## %backedge
; CHECK-NEXT:    ## in Loop: Header=BB0_1 Depth=1
; CHECK-NEXT:    cmpl %edx, -4(%rdi,%rsi,4)
; CHECK-NEXT:    movq %rax, %rsi
; CHECK-NEXT:    jne LBB0_1
; CHECK-NEXT:  ## %bb.3: ## %failure
; CHECK-NEXT:    ud2
; CHECK-NEXT:  LBB0_4: ## %exit
; CHECK-NEXT:    movl $-1, %eax
; CHECK-NEXT:    retq
entry:
  br label %loop

loop:                                             ; preds = %backedge, %entry
  %iv = phi i64 [ %iv.next, %backedge ], [ %len, %entry ]
  %iv.next = add nsw i64 %iv, -1
  %cond_1 = icmp eq i64 %iv, 0
  br i1 %cond_1, label %exit, label %backedge

backedge:                                         ; preds = %loop
  %addr = getelementptr inbounds i32, i32* %p, i64 %iv.next
  %loaded = load atomic i32, i32* %addr unordered, align 4
  %cond_2 = icmp eq i32 %loaded, %x
  br i1 %cond_2, label %failure, label %loop

exit:                                             ; preds = %loop
  ret i32 -1

failure:                                          ; preds = %backedge
  unreachable
}

define i32 @test_02(i32* %p, i64 %len, i32 %x) {
; CHECK-LABEL: test_02:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  LBB1_1: ## %loop
; CHECK-NEXT:    ## =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    testq %rsi, %rsi
; CHECK-NEXT:    je LBB1_4
; CHECK-NEXT:  ## %bb.2: ## %backedge
; CHECK-NEXT:    ## in Loop: Header=BB1_1 Depth=1
; CHECK-NEXT:    cmpl %edx, -4(%rdi,%rsi,4)
; CHECK-NEXT:    leaq -1(%rsi), %rsi
; CHECK-NEXT:    jne LBB1_1
; CHECK-NEXT:  ## %bb.3: ## %failure
; CHECK-NEXT:    ud2
; CHECK-NEXT:  LBB1_4: ## %exit
; CHECK-NEXT:    movl $-1, %eax
; CHECK-NEXT:    retq
entry:
  %start = add i64 %len, -1
  br label %loop

loop:                                             ; preds = %backedge, %entry
  %iv = phi i64 [ %iv.next, %backedge ], [ %start, %entry ]
  %iv.next = add nsw i64 %iv, -1
  %iv.offset = add i64 %iv, 1
  %iv.next.offset = add i64 %iv.next, 1
  %cond_1 = icmp eq i64 %iv.offset, 0
  br i1 %cond_1, label %exit, label %backedge

backedge:                                         ; preds = %loop
  %addr = getelementptr inbounds i32, i32* %p, i64 %iv.next.offset
  %loaded = load atomic i32, i32* %addr unordered, align 4
  %cond_2 = icmp eq i32 %loaded, %x
  br i1 %cond_2, label %failure, label %loop

exit:                                             ; preds = %loop
  ret i32 -1

failure:                                          ; preds = %backedge
  unreachable
}

define i32 @test_03(i32* %p, i64 %len, i32 %x) {
; CHECK-LABEL: test_03:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  LBB2_1: ## %loop
; CHECK-NEXT:    ## =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    testq %rsi, %rsi
; CHECK-NEXT:    je LBB2_4
; CHECK-NEXT:  ## %bb.2: ## %backedge
; CHECK-NEXT:    ## in Loop: Header=BB2_1 Depth=1
; CHECK-NEXT:    cmpl %edx, -4(%rdi,%rsi,4)
; CHECK-NEXT:    leaq -1(%rsi), %rsi
; CHECK-NEXT:    jne LBB2_1
; CHECK-NEXT:  ## %bb.3: ## %failure
; CHECK-NEXT:    ud2
; CHECK-NEXT:  LBB2_4: ## %exit
; CHECK-NEXT:    movl $-1, %eax
; CHECK-NEXT:    retq
entry:
  %start = add i64 %len, -100
  br label %loop

loop:                                             ; preds = %backedge, %entry
  %iv = phi i64 [ %iv.next, %backedge ], [ %start, %entry ]
  %iv.next = add nsw i64 %iv, -1
  %iv.offset = add i64 %iv, 100
  %iv.next.offset = add i64 %iv.next, 100
  %cond_1 = icmp eq i64 %iv.offset, 0
  br i1 %cond_1, label %exit, label %backedge

backedge:                                         ; preds = %loop
  %addr = getelementptr inbounds i32, i32* %p, i64 %iv.next.offset
  %loaded = load atomic i32, i32* %addr unordered, align 4
  %cond_2 = icmp eq i32 %loaded, %x
  br i1 %cond_2, label %failure, label %loop

exit:                                             ; preds = %loop
  ret i32 -1

failure:                                          ; preds = %backedge
  unreachable
}
