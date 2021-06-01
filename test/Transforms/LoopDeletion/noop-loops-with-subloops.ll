; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -loop-deletion -verify-dom-info -S | FileCheck %s

target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64"

%pair_t = type { i64, i64 }

; The loop %inner cannot be removed, because it has outgoing values. But the
; outer loop is a no-op and can be removed.
define void @test1(i64 %N, i64 %M, %pair_t* %ptr) willreturn {
; CHECK-LABEL: @test1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %outer.header

outer.header:
  %outer.iv = phi i64 [ 0, %entry ], [ %outer.iv.next, %outer.latch ]

  br label %inner

inner:
  %inner.iv = phi i64 [ 0, %outer.header ], [ %inner.iv.next, %inner ]
  %gep = getelementptr %pair_t, %pair_t* %ptr, i64 %inner.iv
  %p = load %pair_t, %pair_t* %gep
  %v.0 = extractvalue %pair_t %p, 0
  %v.1 = extractvalue %pair_t %p, 1
  %inner.ec = icmp ult i64 %v.0, %v.1
  %inner.iv.next = add i64 %inner.iv, 1
  br i1 %inner.ec, label %outer.latch, label %inner

outer.latch:
  %lcssa = phi i64 [ %v.1, %inner ]
  %outer.ec = icmp ult i64 %outer.iv, %lcssa
  %outer.iv.next = add i64 %outer.iv, 1
  br i1 %outer.ec, label %exit, label %outer.header

exit:
  ret void
}

declare void @sideeffect()

; Same as @test1, but with a call in the outer loop. Nothing can be deleted.
define void @test2_sideeffect_in_outer(i64 %N, i64 %M, %pair_t* %ptr) willreturn {
; CHECK-LABEL: @test2_sideeffect_in_outer(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[OUTER_HEADER:%.*]]
; CHECK:       outer.header:
; CHECK-NEXT:    [[OUTER_IV:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ [[OUTER_IV_NEXT:%.*]], [[OUTER_LATCH:%.*]] ]
; CHECK-NEXT:    br label [[INNER:%.*]]
; CHECK:       inner:
; CHECK-NEXT:    [[INNER_IV:%.*]] = phi i64 [ 0, [[OUTER_HEADER]] ], [ [[INNER_IV_NEXT:%.*]], [[INNER]] ]
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr [[PAIR_T:%.*]], %pair_t* [[PTR:%.*]], i64 [[INNER_IV]]
; CHECK-NEXT:    [[P:%.*]] = load [[PAIR_T]], %pair_t* [[GEP]], align 4
; CHECK-NEXT:    [[V_0:%.*]] = extractvalue [[PAIR_T]] [[P]], 0
; CHECK-NEXT:    [[V_1:%.*]] = extractvalue [[PAIR_T]] [[P]], 1
; CHECK-NEXT:    [[INNER_EC:%.*]] = icmp ult i64 [[V_0]], [[V_1]]
; CHECK-NEXT:    [[INNER_IV_NEXT]] = add i64 [[INNER_IV]], 1
; CHECK-NEXT:    br i1 [[INNER_EC]], label [[OUTER_LATCH]], label [[INNER]]
; CHECK:       outer.latch:
; CHECK-NEXT:    [[LCSSA:%.*]] = phi i64 [ [[V_1]], [[INNER]] ]
; CHECK-NEXT:    [[OUTER_EC:%.*]] = icmp ult i64 [[OUTER_IV]], [[LCSSA]]
; CHECK-NEXT:    [[OUTER_IV_NEXT]] = add i64 [[OUTER_IV]], 1
; CHECK-NEXT:    call void @sideeffect()
; CHECK-NEXT:    br i1 [[OUTER_EC]], label [[EXIT:%.*]], label [[OUTER_HEADER]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %outer.header

outer.header:
  %outer.iv = phi i64 [ 0, %entry ], [ %outer.iv.next, %outer.latch ]

  br label %inner

inner:
  %inner.iv = phi i64 [ 0, %outer.header ], [ %inner.iv.next, %inner ]
  %gep = getelementptr %pair_t, %pair_t* %ptr, i64 %inner.iv
  %p = load %pair_t, %pair_t* %gep
  %v.0 = extractvalue %pair_t %p, 0
  %v.1 = extractvalue %pair_t %p, 1
  %inner.ec = icmp ult i64 %v.0, %v.1
  %inner.iv.next = add i64 %inner.iv, 1
  br i1 %inner.ec, label %outer.latch, label %inner

outer.latch:
  %lcssa = phi i64 [ %v.1, %inner ]
  %outer.ec = icmp ult i64 %outer.iv, %lcssa
  %outer.iv.next = add i64 %outer.iv, 1
  call void @sideeffect()
  br i1 %outer.ec, label %exit, label %outer.header

exit:
  ret void
}

; Same as @test1, but with a call in the inner loop. Nothing can be deleted.
define void @test3_sideeffect_in_inner(i64 %N, i64 %M, %pair_t* %ptr) willreturn {
; CHECK-LABEL: @test3_sideeffect_in_inner(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[OUTER_HEADER:%.*]]
; CHECK:       outer.header:
; CHECK-NEXT:    [[OUTER_IV:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ [[OUTER_IV_NEXT:%.*]], [[OUTER_LATCH:%.*]] ]
; CHECK-NEXT:    br label [[INNER:%.*]]
; CHECK:       inner:
; CHECK-NEXT:    [[INNER_IV:%.*]] = phi i64 [ 0, [[OUTER_HEADER]] ], [ [[INNER_IV_NEXT:%.*]], [[INNER]] ]
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr [[PAIR_T:%.*]], %pair_t* [[PTR:%.*]], i64 [[INNER_IV]]
; CHECK-NEXT:    [[P:%.*]] = load [[PAIR_T]], %pair_t* [[GEP]], align 4
; CHECK-NEXT:    [[V_0:%.*]] = extractvalue [[PAIR_T]] [[P]], 0
; CHECK-NEXT:    [[V_1:%.*]] = extractvalue [[PAIR_T]] [[P]], 1
; CHECK-NEXT:    [[INNER_EC:%.*]] = icmp ult i64 [[V_0]], [[V_1]]
; CHECK-NEXT:    [[INNER_IV_NEXT]] = add i64 [[INNER_IV]], 1
; CHECK-NEXT:    call void @sideeffect()
; CHECK-NEXT:    br i1 [[INNER_EC]], label [[OUTER_LATCH]], label [[INNER]]
; CHECK:       outer.latch:
; CHECK-NEXT:    [[LCSSA:%.*]] = phi i64 [ [[V_1]], [[INNER]] ]
; CHECK-NEXT:    [[OUTER_EC:%.*]] = icmp ult i64 [[OUTER_IV]], [[LCSSA]]
; CHECK-NEXT:    [[OUTER_IV_NEXT]] = add i64 [[OUTER_IV]], 1
; CHECK-NEXT:    br i1 [[OUTER_EC]], label [[EXIT:%.*]], label [[OUTER_HEADER]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %outer.header

outer.header:
  %outer.iv = phi i64 [ 0, %entry ], [ %outer.iv.next, %outer.latch ]

  br label %inner

inner:
  %inner.iv = phi i64 [ 0, %outer.header ], [ %inner.iv.next, %inner ]
  %gep = getelementptr %pair_t, %pair_t* %ptr, i64 %inner.iv
  %p = load %pair_t, %pair_t* %gep
  %v.0 = extractvalue %pair_t %p, 0
  %v.1 = extractvalue %pair_t %p, 1
  %inner.ec = icmp ult i64 %v.0, %v.1
  %inner.iv.next = add i64 %inner.iv, 1
  call void @sideeffect()
  br i1 %inner.ec, label %outer.latch, label %inner

outer.latch:
  %lcssa = phi i64 [ %v.1, %inner ]
  %outer.ec = icmp ult i64 %outer.iv, %lcssa
  %outer.iv.next = add i64 %outer.iv, 1
  br i1 %outer.ec, label %exit, label %outer.header

exit:
  ret void
}

; The inner loop may not terminate, so we cannot remove it, unless the
; function/loop is mustprogress. Test case from PR50511.
define void @inner_loop_may_be_infinite(i1 %c1, i1 %c2) {
; CHECK-LABEL: @inner_loop_may_be_infinite(
; CHECK-NEXT:    br label [[LOOP1:%.*]]
; CHECK:       loop1:
; CHECK-NEXT:    br i1 [[C1:%.*]], label [[LOOP1_LATCH:%.*]], label [[LOOP2_PREHEADER:%.*]]
; CHECK:       loop2.preheader:
; CHECK-NEXT:    br label [[LOOP2:%.*]]
; CHECK:       loop2:
; CHECK-NEXT:    br i1 [[C2:%.*]], label [[LOOP1_LATCH_LOOPEXIT:%.*]], label [[LOOP2]]
; CHECK:       loop1.latch.loopexit:
; CHECK-NEXT:    br label [[LOOP1_LATCH]]
; CHECK:       loop1.latch:
; CHECK-NEXT:    br i1 false, label [[LOOP1_LATCH_LOOP1_CRIT_EDGE:%.*]], label [[EXIT:%.*]]
; CHECK:       loop1.latch.loop1_crit_edge:
; CHECK-NEXT:    unreachable
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
  br label %loop1

loop1:
  br i1 %c1, label %loop1.latch, label %loop2

loop2:
  br i1 %c2, label %loop1.latch, label %loop2

loop1.latch:
  br i1 false, label %loop1, label %exit

exit:
  ret void
}

; Similar to @inner_loop_may_be_infinite, but the function is marked as
; mustprogress. The loops can be removed.
define void @inner_loop_may_be_infinite_but_fn_mustprogress(i1 %c1, i1 %c2) mustprogress {
; CHECK-LABEL: @inner_loop_may_be_infinite_but_fn_mustprogress(
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
  br label %loop1

loop1:
  br i1 %c1, label %loop1.latch, label %loop2

loop2:
  br i1 %c2, label %loop1.latch, label %loop2

loop1.latch:
  br i1 false, label %loop1, label %exit

exit:
  ret void
}

; Similar to @inner_loop_may_be_infinite, but the parent loop loop1 is marked
; as mustprogress. The loops can be removed.
define void @inner_loop_may_be_infinite_but_top_loop_mustprogress(i1 %c1, i1 %c2) {
; CHECK-LABEL: @inner_loop_may_be_infinite_but_top_loop_mustprogress(
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
  br label %loop1

loop1:
  br i1 %c1, label %loop1.latch, label %loop2

loop2:
  br i1 %c2, label %loop1.latch, label %loop2

loop1.latch:
  br i1 false, label %loop1, label %exit, !llvm.loop !3

exit:
  ret void
}

; loop3 and loop1 are not marked as mustprogress, but loop2 (parent of loop3)
; is. The loops can be removed.
define void @loop2_mustprogress_but_not_child_loop_loop3(i1 %c1, i1 %c2, i1 %c3) {
; CHECK-LABEL: @loop2_mustprogress_but_not_child_loop_loop3(
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
  br label %loop1

loop1:
  br i1 %c1, label %loop1.latch, label %loop2

loop2:
  br label %loop3

loop3:
  br i1 %c2, label %loop2.latch, label %loop3

loop2.latch:
  br i1 %c3, label %loop1.latch, label %loop2, !llvm.loop !3

loop1.latch:
  br i1 false, label %loop1, label %exit

exit:
  ret void
}

; Cannot remove loop3 or loop1, as they are not mustprogress. loop2 is
; mustprogress and can be removed.
define void @loop2_mustprogress_but_not_sibling_loop(i1 %c1, i1 %c2, i1 %c3) {
; CHECK-LABEL: @loop2_mustprogress_but_not_sibling_loop(
; CHECK-NEXT:    br label [[LOOP1:%.*]]
; CHECK:       loop1:
; CHECK-NEXT:    br i1 [[C1:%.*]], label [[LOOP1_LATCH:%.*]], label [[LOOP2_PREHEADER:%.*]]
; CHECK:       loop2.preheader:
; CHECK-NEXT:    br label [[LOOP3_PREHEADER:%.*]]
; CHECK:       loop3.preheader:
; CHECK-NEXT:    br label [[LOOP3:%.*]]
; CHECK:       loop3:
; CHECK-NEXT:    br i1 [[C3:%.*]], label [[LOOP1_LATCH_LOOPEXIT:%.*]], label [[LOOP3]]
; CHECK:       loop1.latch.loopexit:
; CHECK-NEXT:    br label [[LOOP1_LATCH]]
; CHECK:       loop1.latch:
; CHECK-NEXT:    br i1 false, label [[LOOP1_LATCH_LOOP1_CRIT_EDGE:%.*]], label [[EXIT:%.*]]
; CHECK:       loop1.latch.loop1_crit_edge:
; CHECK-NEXT:    unreachable
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
  br label %loop1

loop1:
  br i1 %c1, label %loop1.latch, label %loop2

loop2:
  br i1 %c2, label %loop3, label %loop2, !llvm.loop !4

loop3:
  br i1 %c3, label %loop1.latch, label %loop3

loop1.latch:
  br i1 false, label %loop1, label %exit

exit:
  ret void
}

define void @loop2_finite_but_child_is_not(i1 %c1, i1 %c2, i1 %c3) {
; CHECK-LABEL: @loop2_finite_but_child_is_not(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP1:%.*]]
; CHECK:       loop1:
; CHECK-NEXT:    [[IV1:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[IV1_NEXT:%.*]], [[LOOP1_LATCH:%.*]] ]
; CHECK-NEXT:    br i1 [[C1:%.*]], label [[LOOP1_LATCH]], label [[LOOP2_PREHEADER:%.*]]
; CHECK:       loop2.preheader:
; CHECK-NEXT:    br label [[LOOP2:%.*]]
; CHECK:       loop2:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ [[IV_NEXT:%.*]], [[LOOP2_LATCH:%.*]] ], [ 0, [[LOOP2_PREHEADER]] ]
; CHECK-NEXT:    br label [[LOOP3:%.*]]
; CHECK:       loop3:
; CHECK-NEXT:    br i1 [[C2:%.*]], label [[LOOP2_LATCH]], label [[LOOP3]]
; CHECK:       loop2.latch:
; CHECK-NEXT:    [[IV_NEXT]] = add nuw i32 [[IV]], 1
; CHECK-NEXT:    [[C:%.*]] = icmp ugt i32 [[IV]], 200
; CHECK-NEXT:    br i1 [[C]], label [[LOOP1_LATCH_LOOPEXIT:%.*]], label [[LOOP2]]
; CHECK:       loop1.latch.loopexit:
; CHECK-NEXT:    br label [[LOOP1_LATCH]]
; CHECK:       loop1.latch:
; CHECK-NEXT:    [[IV1_NEXT]] = add nuw i32 [[IV1]], 1
; CHECK-NEXT:    [[C4:%.*]] = icmp ult i32 [[IV1_NEXT]], 200
; CHECK-NEXT:    br i1 [[C4]], label [[LOOP1]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop1

loop1:
  %iv1 = phi i32 [ 0, %entry ], [ %iv1.next, %loop1.latch ]
  br i1 %c1, label %loop1.latch, label %loop2

loop2:
  %iv = phi i32 [ 0, %loop1 ], [ %iv.next, %loop2.latch ]
  br label %loop3

loop3:
  br i1 %c2, label %loop2.latch, label %loop3

loop2.latch:
  %iv.next = add nuw i32 %iv, 1
  %c = icmp ugt i32 %iv, 200
  br i1 %c, label %loop1.latch, label %loop2

loop1.latch:
  %iv1.next = add nuw i32 %iv1, 1
  %c4 = icmp ult i32 %iv1.next, 200
  br i1 %c4, label %loop1, label %exit

exit:
  ret void
}

define void @loop2_finite_and_child_is_mustprogress(i1 %c1, i1 %c2, i1 %c3) {
; CHECK-LABEL: @loop2_finite_and_child_is_mustprogress(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop1

loop1:
  %iv1 = phi i32 [ 0, %entry ], [ %iv1.next, %loop1.latch ]
  br i1 %c1, label %loop1.latch, label %loop2

loop2:
  %iv = phi i32 [ 0, %loop1 ], [ %iv.next, %loop2.latch ]
  br label %loop3

loop3:
  br i1 %c2, label %loop2.latch, label %loop3, !llvm.loop !5

loop2.latch:
  %iv.next = add nuw i32 %iv, 1
  %c = icmp ugt i32 %iv, 200
  br i1 %c, label %loop1.latch, label %loop2

loop1.latch:
  %iv1.next = add nuw i32 %iv1, 1
  %c4 = icmp ult i32 %iv1.next, 200
  br i1 %c4, label %loop1, label %exit

exit:
  ret void
}

!1 = !{!"llvm.loop.mustprogress"}
!2 = distinct !{!2, !1}
!3 = distinct !{!3, !1}
!4 = distinct !{!4, !1}
!5 = distinct !{!5, !1}
