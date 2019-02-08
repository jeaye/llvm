; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -gvn -S | FileCheck %s

; This test checks that we don't hang trying to split a critical edge in scalar
; PRE when the control flow uses a callbr instruction.

define void @wombat(i64 %arg, i64* %arg1, i64 %arg2, i32* %arg3) {
; CHECK-LABEL: @wombat(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[TMP5:%.*]] = or i64 [[ARG2:%.*]], [[ARG:%.*]]
; CHECK-NEXT:    callbr void asm sideeffect "", "X,X"(i8* blockaddress(@wombat, [[BB7:%.*]]), i8* blockaddress(@wombat, [[BB9:%.*]]))
; CHECK-NEXT:    to label [[BB6:%.*]] [label [[BB7]], label %bb9]
; CHECK:       bb6:
; CHECK-NEXT:    br label [[BB7]]
; CHECK:       bb7:
; CHECK-NEXT:    [[TMP8:%.*]] = trunc i64 [[TMP5]] to i32
; CHECK-NEXT:    tail call void @barney(i32 [[TMP8]])
; CHECK-NEXT:    br label [[BB9]]
; CHECK:       bb9:
; CHECK-NEXT:    [[TMP10:%.*]] = trunc i64 [[TMP5]] to i32
; CHECK-NEXT:    store i32 [[TMP10]], i32* [[ARG3:%.*]]
; CHECK-NEXT:    ret void
;
bb:
  %tmp5 = or i64 %arg2, %arg
  callbr void asm sideeffect "", "X,X"(i8* blockaddress(@wombat, %bb7), i8* blockaddress(@wombat, %bb9))
          to label %bb6 [label %bb7, label %bb9]

bb6:                                              ; preds = %bb
  br label %bb7

bb7:                                              ; preds = %bb6, %bb
  %tmp8 = trunc i64 %tmp5 to i32
  tail call void @barney(i32 %tmp8)
  br label %bb9

bb9:                                              ; preds = %bb7, %bb
  %tmp10 = trunc i64 %tmp5 to i32
  store i32 %tmp10, i32* %arg3
  ret void
}

declare void @barney(i32)
