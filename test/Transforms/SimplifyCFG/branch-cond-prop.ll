; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -simplifycfg -simplifycfg-require-and-preserve-domtree=1 -S | FileCheck %s

declare void @bar()

define void @test(i32 %X, i32 %Y) {
; CHECK-LABEL: @test(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP_2:%.*]] = icmp slt i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret void
;
entry:
  %tmp.2 = icmp slt i32 %X, %Y            ; <i1> [#uses=2]
  br i1 %tmp.2, label %shortcirc_next, label %UnifiedReturnBlock
shortcirc_next:         ; preds = %entry
  br i1 %tmp.2, label %UnifiedReturnBlock, label %then
then:           ; preds = %shortcirc_next
  call void @bar( )
  ret void
UnifiedReturnBlock:             ; preds = %shortcirc_next, %entry
  ret void
}

