; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-linux | FileCheck %s

; No overflow flags, same type width.
define i32 @test_01(i32* %p, i64 %len, i32 %x) {
; CHECK-LABEL: test_01:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addq $-4, %rdi
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB0_1: # %loop
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    subq $1, %rsi
; CHECK-NEXT:    jb .LBB0_4
; CHECK-NEXT:  # %bb.2: # %backedge
; CHECK-NEXT:    # in Loop: Header=BB0_1 Depth=1
; CHECK-NEXT:    cmpl %edx, (%rdi)
; CHECK-NEXT:    leaq 4(%rdi), %rdi
; CHECK-NEXT:    jne .LBB0_1
; CHECK-NEXT:  # %bb.3: # %failure
; CHECK-NEXT:  .LBB0_4: # %exit
; CHECK-NEXT:    movl $-1, %eax
; CHECK-NEXT:    retq
entry:
  %scevgep = getelementptr i32, i32* %p, i64 -1
  br label %loop

loop:                                             ; preds = %backedge, %entry
  %iv = phi i64 [ %iv.next, %backedge ], [ 0, %entry ]
  %iv.next = add i64 %iv, 1
  %cond_1 = icmp eq i64 %iv, %len
  br i1 %cond_1, label %exit, label %backedge

backedge:                                         ; preds = %loop
  %scevgep1 = getelementptr i32, i32* %scevgep, i64 %iv
  %loaded = load atomic i32, i32* %scevgep1 unordered, align 4
  %cond_2 = icmp eq i32 %loaded, %x
  br i1 %cond_2, label %failure, label %loop

exit:                                             ; preds = %loop
  ret i32 -1

failure:                                          ; preds = %backedge
  unreachable
}

; nsw flag, same type width.
define i32 @test_02(i32* %p, i64 %len, i32 %x) {
; CHECK-LABEL: test_02:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addq $-4, %rdi
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB1_1: # %loop
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    subq $1, %rsi
; CHECK-NEXT:    jb .LBB1_4
; CHECK-NEXT:  # %bb.2: # %backedge
; CHECK-NEXT:    # in Loop: Header=BB1_1 Depth=1
; CHECK-NEXT:    cmpl %edx, (%rdi)
; CHECK-NEXT:    leaq 4(%rdi), %rdi
; CHECK-NEXT:    jne .LBB1_1
; CHECK-NEXT:  # %bb.3: # %failure
; CHECK-NEXT:  .LBB1_4: # %exit
; CHECK-NEXT:    movl $-1, %eax
; CHECK-NEXT:    retq
entry:
  %scevgep = getelementptr i32, i32* %p, i64 -1
  br label %loop

loop:                                             ; preds = %backedge, %entry
  %iv = phi i64 [ %iv.next, %backedge ], [ 0, %entry ]
  %iv.next = add nsw i64 %iv, 1
  %cond_1 = icmp eq i64 %iv, %len
  br i1 %cond_1, label %exit, label %backedge

backedge:                                         ; preds = %loop
  %scevgep1 = getelementptr i32, i32* %scevgep, i64 %iv
  %loaded = load atomic i32, i32* %scevgep1 unordered, align 4
  %cond_2 = icmp eq i32 %loaded, %x
  br i1 %cond_2, label %failure, label %loop

exit:                                             ; preds = %loop
  ret i32 -1

failure:                                          ; preds = %backedge
  unreachable
}

; nsw flag, optimization is possible because memory instruction is dominated by loop-exiting check against iv.next.
define i32 @test_02_nopoison(i32* %p, i64 %len, i32 %x) {
; CHECK-LABEL: test_02_nopoison:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addq $-4, %rdi
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB2_1: # %loop
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    subq $1, %rsi
; CHECK-NEXT:    jb .LBB2_4
; CHECK-NEXT:  # %bb.2: # %backedge
; CHECK-NEXT:    # in Loop: Header=BB2_1 Depth=1
; CHECK-NEXT:    cmpl %edx, (%rdi)
; CHECK-NEXT:    leaq 4(%rdi), %rdi
; CHECK-NEXT:    jne .LBB2_1
; CHECK-NEXT:  # %bb.3: # %failure
; CHECK-NEXT:  .LBB2_4: # %exit
; CHECK-NEXT:    movl $-1, %eax
; CHECK-NEXT:    retq
entry:
  %len.plus.1 = add i64 %len, 1
  %scevgep = getelementptr i32, i32* %p, i64 -1
  br label %loop

loop:                                             ; preds = %backedge, %entry
  %iv = phi i64 [ %iv.next, %backedge ], [ 0, %entry ]
  %iv.next = add nsw i64 %iv, 1
  %cond_1 = icmp eq i64 %iv.next, %len.plus.1
  br i1 %cond_1, label %exit, label %backedge

backedge:                                         ; preds = %loop
  %scevgep1 = getelementptr i32, i32* %scevgep, i64 %iv
  %loaded = load atomic i32, i32* %scevgep1 unordered, align 4
  %cond_2 = icmp eq i32 %loaded, %x
  br i1 %cond_2, label %failure, label %loop

exit:                                             ; preds = %loop
  ret i32 -1

failure:                                          ; preds = %backedge
  unreachable
}


; nuw flag, same type width.
define i32 @test_03(i32* %p, i64 %len, i32 %x) {
; CHECK-LABEL: test_03:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addq $-4, %rdi
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB3_1: # %loop
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    subq $1, %rsi
; CHECK-NEXT:    jb .LBB3_4
; CHECK-NEXT:  # %bb.2: # %backedge
; CHECK-NEXT:    # in Loop: Header=BB3_1 Depth=1
; CHECK-NEXT:    cmpl %edx, (%rdi)
; CHECK-NEXT:    leaq 4(%rdi), %rdi
; CHECK-NEXT:    jne .LBB3_1
; CHECK-NEXT:  # %bb.3: # %failure
; CHECK-NEXT:  .LBB3_4: # %exit
; CHECK-NEXT:    movl $-1, %eax
; CHECK-NEXT:    retq
entry:
  %scevgep = getelementptr i32, i32* %p, i64 -1
  br label %loop

loop:                                             ; preds = %backedge, %entry
  %iv = phi i64 [ %iv.next, %backedge ], [ 0, %entry ]
  %iv.next = add nuw i64 %iv, 1
  %cond_1 = icmp eq i64 %iv, %len
  br i1 %cond_1, label %exit, label %backedge

backedge:                                         ; preds = %loop
  %scevgep1 = getelementptr i32, i32* %scevgep, i64 %iv
  %loaded = load atomic i32, i32* %scevgep1 unordered, align 4
  %cond_2 = icmp eq i32 %loaded, %x
  br i1 %cond_2, label %failure, label %loop

exit:                                             ; preds = %loop
  ret i32 -1

failure:                                          ; preds = %backedge
  unreachable
}

; nuw flag, optimization is possible because memory instruction is dominated by loop-exiting check against iv.next.
define i32 @test_03_nopoison(i32* %p, i64 %len, i32 %x) {
; CHECK-LABEL: test_03_nopoison:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addq $-4, %rdi
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB4_1: # %loop
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    subq $1, %rsi
; CHECK-NEXT:    jb .LBB4_4
; CHECK-NEXT:  # %bb.2: # %backedge
; CHECK-NEXT:    # in Loop: Header=BB4_1 Depth=1
; CHECK-NEXT:    cmpl %edx, (%rdi)
; CHECK-NEXT:    leaq 4(%rdi), %rdi
; CHECK-NEXT:    jne .LBB4_1
; CHECK-NEXT:  # %bb.3: # %failure
; CHECK-NEXT:  .LBB4_4: # %exit
; CHECK-NEXT:    movl $-1, %eax
; CHECK-NEXT:    retq
entry:
  %len.plus.1 = add i64 %len, 1
  %scevgep = getelementptr i32, i32* %p, i64 -1
  br label %loop

loop:                                             ; preds = %backedge, %entry
  %iv = phi i64 [ %iv.next, %backedge ], [ 0, %entry ]
  %iv.next = add nuw i64 %iv, 1
  %cond_1 = icmp eq i64 %iv.next, %len.plus.1
  br i1 %cond_1, label %exit, label %backedge

backedge:                                         ; preds = %loop
  %scevgep1 = getelementptr i32, i32* %scevgep, i64 %iv
  %loaded = load atomic i32, i32* %scevgep1 unordered, align 4
  %cond_2 = icmp eq i32 %loaded, %x
  br i1 %cond_2, label %failure, label %loop

exit:                                             ; preds = %loop
  ret i32 -1

failure:                                          ; preds = %backedge
  unreachable
}
