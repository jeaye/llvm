; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -disable-lsr -ppc-asm-full-reg-names -verify-machineinstrs \
; RUN:   -mtriple=powerpc64le-unknown-linux-gnu -mcpu=pwr9 < %s | FileCheck %s

; FIXME: PPCLoopInstrFormPrep should be able to common base for "(unsigned long long *)(p + j + 5)"
; and "(unsigned long long *)(p + j + 9)", thus we only have two DS form load inside the loop.

; long long foo(char *p, int n, int count) {
;   int j = 0;
;   long long sum = 0;
;   for (int i = 0; i < n; i++) {
;     sum += *(unsigned long long *)(p + j + 5);
;     sum += *(unsigned long long *)(p + j + 9);
;     j += count;
;   }
;   return sum;
; }

define i64 @foo(i8* %p, i32 signext %n, i32 signext %count) {
; CHECK-LABEL: foo:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpwi r4, 1
; CHECK-NEXT:    blt cr0, .LBB0_4
; CHECK-NEXT:  # %bb.1: # %for.body.preheader
; CHECK-NEXT:    clrldi r4, r4, 32
; CHECK-NEXT:    extsw r5, r5
; CHECK-NEXT:    li r6, 0
; CHECK-NEXT:    li r7, 5
; CHECK-NEXT:    mtctr r4
; CHECK-NEXT:    li r8, 9
; CHECK-NEXT:    li r4, 0
; CHECK-NEXT:    .p2align 5
; CHECK-NEXT:  .LBB0_2: # %for.body
; CHECK-NEXT:    #
; CHECK-NEXT:    add r9, r3, r6
; CHECK-NEXT:    add r6, r6, r5
; CHECK-NEXT:    ldx r10, r9, r7
; CHECK-NEXT:    ldx r9, r9, r8
; CHECK-NEXT:    add r4, r10, r4
; CHECK-NEXT:    add r4, r4, r9
; CHECK-NEXT:    bdnz .LBB0_2
; CHECK-NEXT:  # %bb.3: # %for.cond.cleanup
; CHECK-NEXT:    mr r3, r4
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB0_4:
; CHECK-NEXT:    li r4, 0
; CHECK-NEXT:    mr r3, r4
; CHECK-NEXT:    blr
entry:
  %cmp16 = icmp sgt i32 %n, 0
  br i1 %cmp16, label %for.body.preheader, label %for.cond.cleanup

for.body.preheader:                               ; preds = %entry
  %0 = sext i32 %count to i64
  br label %for.body

for.cond.cleanup:                                 ; preds = %for.body, %entry
  %sum.0.lcssa = phi i64 [ 0, %entry ], [ %add5, %for.body ]
  ret i64 %sum.0.lcssa

for.body:                                         ; preds = %for.body.preheader, %for.body
  %indvars.iv = phi i64 [ 0, %for.body.preheader ], [ %indvars.iv.next, %for.body ]
  %i.019 = phi i32 [ 0, %for.body.preheader ], [ %inc, %for.body ]
  %sum.018 = phi i64 [ 0, %for.body.preheader ], [ %add5, %for.body ]
  %add.ptr = getelementptr inbounds i8, i8* %p, i64 %indvars.iv
  %add.ptr1 = getelementptr inbounds i8, i8* %add.ptr, i64 5
  %1 = bitcast i8* %add.ptr1 to i64*
  %2 = load i64, i64* %1, align 8
  %add = add i64 %2, %sum.018
  %add.ptr4 = getelementptr inbounds i8, i8* %add.ptr, i64 9
  %3 = bitcast i8* %add.ptr4 to i64*
  %4 = load i64, i64* %3, align 8
  %add5 = add i64 %add, %4
  %indvars.iv.next = add nsw i64 %indvars.iv, %0
  %inc = add nuw nsw i32 %i.019, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body
}
