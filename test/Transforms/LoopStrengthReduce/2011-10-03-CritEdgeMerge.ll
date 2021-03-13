; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -loop-reduce -S < %s | FileCheck %s
;
; Test LSR's use of SplitCriticalEdge during phi rewriting.

target triple = "x86_64-apple-darwin"

; Provide legal integer types.
target datalayout = "n8:16:32:64"

; Verify that identical edges are merged. rdar://problem/6453893

define i8* @test1() {
;
; CHECK-LABEL: @test1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[LSR_IV:%.*]] = phi i64 [ [[LSR_IV_NEXT:%.*]], [[LOOP]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[LSR_IV_NEXT]] = add nuw nsw i64 [[LSR_IV]], 1
; CHECK-NEXT:    [[LSR_IV_NEXT1:%.*]] = inttoptr i64 [[LSR_IV_NEXT]] to i8*
; CHECK-NEXT:    br i1 false, label [[LOOP]], label [[LOOPEXIT:%.*]]
; CHECK:       loopexit:
; CHECK-NEXT:    br i1 false, label [[BBA:%.*]], label [[BBB:%.*]]
; CHECK:       bbA:
; CHECK-NEXT:    switch i32 0, label [[BBA_BB89_CRIT_EDGE:%.*]] [
; CHECK-NEXT:    i32 47, label [[BBA_BB89_CRIT_EDGE]]
; CHECK-NEXT:    i32 58, label [[BBA_BB89_CRIT_EDGE]]
; CHECK-NEXT:    ]
; CHECK:       bbA.bb89_crit_edge:
; CHECK-NEXT:    br label [[BB89:%.*]]
; CHECK:       bbB:
; CHECK-NEXT:    switch i8 0, label [[BBB_BB89_CRIT_EDGE:%.*]] [
; CHECK-NEXT:    i8 47, label [[BBB_BB89_CRIT_EDGE]]
; CHECK-NEXT:    i8 58, label [[BBB_BB89_CRIT_EDGE]]
; CHECK-NEXT:    ]
; CHECK:       bbB.bb89_crit_edge:
; CHECK-NEXT:    br label [[BB89]]
; CHECK:       bb89:
; CHECK-NEXT:    [[TMP75PHI:%.*]] = phi i8* [ [[LSR_IV_NEXT1]], [[BBA_BB89_CRIT_EDGE]] ], [ [[LSR_IV_NEXT1]], [[BBB_BB89_CRIT_EDGE]] ]
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret i8* [[TMP75PHI]]
;
entry:
  br label %loop

loop:
  %rec = phi i32 [ %next, %loop ], [ 0, %entry ]
  %next = add i32 %rec, 1
  %tmp75 = getelementptr i8, i8* null, i32 %next
  br i1 false, label %loop, label %loopexit

loopexit:
  br i1 false, label %bbA, label %bbB

bbA:
  switch i32 0, label %bb89 [
  i32 47, label %bb89
  i32 58, label %bb89
  ]

bbB:
  switch i8 0, label %bb89 [
  i8 47, label %bb89
  i8 58, label %bb89
  ]

bb89:
  %tmp75phi = phi i8* [ %tmp75, %bbA ], [ %tmp75, %bbA ], [ %tmp75, %bbA ], [ %tmp75, %bbB ], [ %tmp75, %bbB ], [ %tmp75, %bbB ]
  br label %exit

exit:
  ret i8* %tmp75phi
}

; Handle single-predecessor phis: PR13756
define i8* @test2() {
;
; CHECK-LABEL: @test2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[LSR_IV:%.*]] = phi i64 [ [[LSR_IV_NEXT:%.*]], [[LOOP]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[LSR_IV_NEXT]] = add nuw nsw i64 [[LSR_IV]], 1
; CHECK-NEXT:    [[LSR_IV_NEXT1:%.*]] = inttoptr i64 [[LSR_IV_NEXT]] to i8*
; CHECK-NEXT:    br i1 false, label [[LOOP]], label [[LOOPEXIT:%.*]]
; CHECK:       loopexit:
; CHECK-NEXT:    br i1 false, label [[BBA:%.*]], label [[BBB:%.*]]
; CHECK:       bbA:
; CHECK-NEXT:    switch i32 0, label [[BB89:%.*]] [
; CHECK-NEXT:    i32 47, label [[BB89]]
; CHECK-NEXT:    i32 58, label [[BB89]]
; CHECK-NEXT:    ]
; CHECK:       bbB:
; CHECK-NEXT:    switch i8 0, label [[BBB_EXIT_CRIT_EDGE:%.*]] [
; CHECK-NEXT:    i8 47, label [[BBB_EXIT_CRIT_EDGE]]
; CHECK-NEXT:    i8 58, label [[BBB_EXIT_CRIT_EDGE]]
; CHECK-NEXT:    ]
; CHECK:       bbB.exit_crit_edge:
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       bb89:
; CHECK-NEXT:    [[TMP75PHI:%.*]] = phi i8* [ [[LSR_IV_NEXT1]], [[BBA]] ], [ [[LSR_IV_NEXT1]], [[BBA]] ], [ [[LSR_IV_NEXT1]], [[BBA]] ]
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    [[RESULT:%.*]] = phi i8* [ [[TMP75PHI]], [[BB89]] ], [ [[LSR_IV_NEXT1]], [[BBB_EXIT_CRIT_EDGE]] ]
; CHECK-NEXT:    ret i8* [[RESULT]]
;
entry:
  br label %loop

loop:
  %rec = phi i32 [ %next, %loop ], [ 0, %entry ]
  %next = add i32 %rec, 1
  %tmp75 = getelementptr i8, i8* null, i32 %next
  br i1 false, label %loop, label %loopexit

loopexit:
  br i1 false, label %bbA, label %bbB

bbA:
  switch i32 0, label %bb89 [
  i32 47, label %bb89
  i32 58, label %bb89
  ]

bbB:
  switch i8 0, label %exit [
  i8 47, label %exit
  i8 58, label %exit
  ]

bb89:
  %tmp75phi = phi i8* [ %tmp75, %bbA ], [ %tmp75, %bbA ], [ %tmp75, %bbA ]
  br label %exit

exit:
  %result = phi i8* [ %tmp75phi, %bb89 ], [ %tmp75, %bbB ], [ %tmp75, %bbB ], [ %tmp75, %bbB ]
  ret i8* %result
}
