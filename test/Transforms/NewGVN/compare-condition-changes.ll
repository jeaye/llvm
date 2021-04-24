; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -newgvn -S %s | FileCheck %s

; Test cases to make sure the blocks are properly marked as executable, if the
; state of the branch condition changes.

; Test case to make sure the case where a condition cannot be simplified is
; handled properly.
define i1 @test1() {
; CHECK-LABEL: @test1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CALL:%.*]] = tail call i1 @foo()
; CHECK-NEXT:    br i1 [[CALL]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    ret i1 true
; CHECK:       else:
; CHECK-NEXT:    ret i1 false
;
entry:
  %call = tail call i1 @foo()
  br i1 %call, label %then, label %else

then:
  ret i1 true

else:
  ret i1 false
}

declare i1 @foo()

; Make sure state changes are propagated across freeze to branches.
define void @test2(i1 %c) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP_HEADER:%.*]]
; CHECK:       loop.header:
; CHECK-NEXT:    [[P_0:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[INC:%.*]], [[LOOP_LATCH:%.*]] ]
; CHECK-NEXT:    [[P_1:%.*]] = phi i32 [ 1, [[ENTRY]] ], [ [[P_2:%.*]], [[LOOP_LATCH]] ]
; CHECK-NEXT:    br label [[LOOP_BB_1:%.*]]
; CHECK:       loop.bb.1:
; CHECK-NEXT:    [[INC]] = add nsw i32 [[P_0]], 1
; CHECK-NEXT:    [[C_1:%.*]] = icmp slt i32 [[P_0]], 0
; CHECK-NEXT:    [[C_1_FREEZE:%.*]] = freeze i1 [[C_1]]
; CHECK-NEXT:    br i1 [[C_1_FREEZE]], label [[LOOP_BB_2:%.*]], label [[LOOP_LATCH]]
; CHECK:       loop.bb.2:
; CHECK-NEXT:    br label [[LOOP_LATCH]]
; CHECK:       loop.latch:
; CHECK-NEXT:    [[P_2]] = phi i32 [ 0, [[LOOP_BB_2]] ], [ [[P_1]], [[LOOP_BB_1]] ]
; CHECK-NEXT:    [[C_2:%.*]] = icmp eq i32 [[P_2]], 123
; CHECK-NEXT:    br i1 [[C_2]], label [[EXIT:%.*]], label [[LOOP_HEADER]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop.header

loop.header:
  %p.0 = phi i32 [ 0, %entry ], [ %p.3, %loop.latch ]
  %p.1 = phi i32 [ 1, %entry ], [ %p.2, %loop.latch ]
  br label %loop.bb.1

loop.bb.1:
  %inc = add nsw i32 %p.0, 1
  %c.1 = icmp slt i32 %p.0, 0
  %c.1.freeze = freeze i1 %c.1
  br i1 %c.1.freeze, label %loop.bb.2, label %loop.latch

loop.bb.2:
  br label %loop.latch

loop.latch:
  %p.2 = phi i32 [ 0, %loop.bb.2 ], [ %p.1, %loop.bb.1 ]
  %p.3 = phi i32 [ %inc, %loop.bb.2 ], [ %inc, %loop.bb.1 ]
  %c.2 = icmp eq i32 %p.2, 123
  br i1 %c.2, label %exit, label %loop.header

exit:
  ret void
}
