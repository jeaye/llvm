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
; CHECK-NEXT:    [[OUTER_IV:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[INNER:%.*]]
; CHECK:       inner:
; CHECK-NEXT:    [[INNER_IV:%.*]] = phi i64 [ 0, [[OUTER_HEADER]] ], [ [[INNER_IV_NEXT:%.*]], [[INNER]] ]
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr [[PAIR_T:%.*]], %pair_t* [[PTR:%.*]], i64 [[INNER_IV]]
; CHECK-NEXT:    [[P:%.*]] = load [[PAIR_T]], %pair_t* [[GEP]], align 4
; CHECK-NEXT:    [[V_0:%.*]] = extractvalue [[PAIR_T]] [[P]], 0
; CHECK-NEXT:    [[V_1:%.*]] = extractvalue [[PAIR_T]] [[P]], 1
; CHECK-NEXT:    [[INNER_EC:%.*]] = icmp ult i64 [[V_0]], [[V_1]]
; CHECK-NEXT:    [[INNER_IV_NEXT]] = add i64 [[INNER_IV]], 1
; CHECK-NEXT:    br i1 [[INNER_EC]], label [[OUTER_LATCH:%.*]], label [[INNER]]
; CHECK:       outer.latch:
; CHECK-NEXT:    [[LCSSA:%.*]] = phi i64 [ [[V_1]], [[INNER]] ]
; CHECK-NEXT:    [[OUTER_EC:%.*]] = icmp ult i64 [[OUTER_IV]], [[LCSSA]]
; CHECK-NEXT:    [[OUTER_IV_NEXT:%.*]] = add i64 [[OUTER_IV]], 1
; CHECK-NEXT:    call void @sideeffect()
; CHECK-NEXT:    br i1 [[OUTER_EC]], label [[EXIT:%.*]], label [[OUTER_LATCH_OUTER_HEADER_CRIT_EDGE:%.*]]
; CHECK:       outer.latch.outer.header_crit_edge:
; CHECK-NEXT:    unreachable
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
; CHECK-NEXT:    [[OUTER_IV:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ]
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
; CHECK-NEXT:    br i1 [[INNER_EC]], label [[OUTER_LATCH:%.*]], label [[INNER]]
; CHECK:       outer.latch:
; CHECK-NEXT:    [[LCSSA:%.*]] = phi i64 [ [[V_1]], [[INNER]] ]
; CHECK-NEXT:    [[OUTER_EC:%.*]] = icmp ult i64 [[OUTER_IV]], [[LCSSA]]
; CHECK-NEXT:    [[OUTER_IV_NEXT:%.*]] = add i64 [[OUTER_IV]], 1
; CHECK-NEXT:    br i1 [[OUTER_EC]], label [[EXIT:%.*]], label [[OUTER_LATCH_OUTER_HEADER_CRIT_EDGE:%.*]]
; CHECK:       outer.latch.outer.header_crit_edge:
; CHECK-NEXT:    unreachable
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
