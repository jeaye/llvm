; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -basic-aa -gvn < %s | FileCheck %s
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:128:128-n8:16:32"
target triple = "i386-apple-darwin11.0.0"

@sortlist = external global [5001 x i32], align 4

define void @Bubble() nounwind noinline {
; CHECK-LABEL: @Bubble(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP7_PRE:%.*]] = load i32, i32* getelementptr inbounds ([5001 x i32], [5001 x i32]* @sortlist, i32 0, i32 1), align 4
; CHECK-NEXT:    br label [[WHILE_BODY5:%.*]]
; CHECK:       while.body5:
; CHECK-NEXT:    [[TMP7:%.*]] = phi i32 [ [[TMP7_PRE]], [[ENTRY:%.*]] ], [ [[TMP71:%.*]], [[IF_END:%.*]] ]
; CHECK-NEXT:    [[INDVAR:%.*]] = phi i32 [ 0, [[ENTRY]] ], [ [[TMP6:%.*]], [[IF_END]] ]
; CHECK-NEXT:    [[TMP5:%.*]] = add i32 [[INDVAR]], 2
; CHECK-NEXT:    [[ARRAYIDX9:%.*]] = getelementptr [5001 x i32], [5001 x i32]* @sortlist, i32 0, i32 [[TMP5]]
; CHECK-NEXT:    [[TMP6]] = add i32 [[INDVAR]], 1
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr [5001 x i32], [5001 x i32]* @sortlist, i32 0, i32 [[TMP6]]
; CHECK-NEXT:    [[TMP10:%.*]] = load i32, i32* [[ARRAYIDX9]], align 4
; CHECK-NEXT:    [[CMP11:%.*]] = icmp sgt i32 [[TMP7]], [[TMP10]]
; CHECK-NEXT:    br i1 [[CMP11]], label [[IF_THEN:%.*]], label [[IF_END]]
; CHECK:       if.then:
; CHECK-NEXT:    store i32 [[TMP10]], i32* [[ARRAYIDX]], align 4
; CHECK-NEXT:    store i32 [[TMP7]], i32* [[ARRAYIDX9]], align 4
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    [[TMP71]] = phi i32 [ [[TMP7]], [[IF_THEN]] ], [ [[TMP10]], [[WHILE_BODY5]] ]
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i32 [[TMP6]], 100
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[WHILE_END_LOOPEXIT:%.*]], label [[WHILE_BODY5]]
; CHECK:       while.end.loopexit:
; CHECK-NEXT:    ret void
;
entry:
  br label %while.body5

while.body5:
  %indvar = phi i32 [ 0, %entry ], [ %tmp6, %if.end ]
  %tmp5 = add i32 %indvar, 2
  %arrayidx9 = getelementptr [5001 x i32], [5001 x i32]* @sortlist, i32 0, i32 %tmp5
  %tmp6 = add i32 %indvar, 1
  %arrayidx = getelementptr [5001 x i32], [5001 x i32]* @sortlist, i32 0, i32 %tmp6
  %tmp7 = load i32, i32* %arrayidx, align 4
  %tmp10 = load i32, i32* %arrayidx9, align 4
  %cmp11 = icmp sgt i32 %tmp7, %tmp10
  br i1 %cmp11, label %if.then, label %if.end

if.then:
  store i32 %tmp10, i32* %arrayidx, align 4
  store i32 %tmp7, i32* %arrayidx9, align 4
  br label %if.end

if.end:
  %exitcond = icmp eq i32 %tmp6, 100
  br i1 %exitcond, label %while.end.loopexit, label %while.body5

while.end.loopexit:
  ret void
}

declare void @hold(i32) readonly
declare void @clobber()

; This is a classic LICM case
define i32 @test1(i1 %cnd, i32* %p) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[V1_PRE:%.*]] = load i32, i32* [[P:%.*]], align 4
; CHECK-NEXT:    br label [[HEADER:%.*]]
; CHECK:       header:
; CHECK-NEXT:    call void @hold(i32 [[V1_PRE]])
; CHECK-NEXT:    br label [[HEADER]]
;
entry:
  br label %header

header:
  %v1 = load i32, i32* %p
  call void @hold(i32 %v1)
  br label %header
}


; Slightly more complicated case to highlight that MemoryDependenceAnalysis
; can compute availability for internal control flow.  In this case, because
; the value is fully available across the backedge, we only need to establish
; anticipation for the preheader block (which is trivial in this case.)
define i32 @test2(i1 %cnd, i32* %p) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[V1_PRE:%.*]] = load i32, i32* [[P:%.*]], align 4
; CHECK-NEXT:    br label [[HEADER:%.*]]
; CHECK:       header:
; CHECK-NEXT:    call void @hold(i32 [[V1_PRE]])
; CHECK-NEXT:    br i1 [[CND:%.*]], label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br label [[MERGE:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    br label [[MERGE]]
; CHECK:       merge:
; CHECK-NEXT:    br label [[HEADER]]
;
entry:
  br label %header

header:
  %v1 = load i32, i32* %p
  call void @hold(i32 %v1)
  br i1 %cnd, label %bb1, label %bb2

bb1:
  br label %merge

bb2:
  br label %merge

merge:
  br label %header
}


; TODO: at the moment, our anticipation check does not handle anything
; other than straight-line unconditional fallthrough.  This particular
; case could be solved through either a backwards anticipation walk or
; use of the "safe to speculate" status (if we annotate the param)
define i32 @test3(i1 %cnd, i32* %p) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[HEADER:%.*]]
; CHECK:       header:
; CHECK-NEXT:    br i1 [[CND:%.*]], label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br label [[MERGE:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    br label [[MERGE]]
; CHECK:       merge:
; CHECK-NEXT:    [[V1:%.*]] = load i32, i32* [[P:%.*]], align 4
; CHECK-NEXT:    call void @hold(i32 [[V1]])
; CHECK-NEXT:    br label [[HEADER]]
;
entry:
  br label %header

header:
  br i1 %cnd, label %bb1, label %bb2

bb1:
  br label %merge

bb2:
  br label %merge

merge:
  %v1 = load i32, i32* %p
  call void @hold(i32 %v1)
  br label %header
}

; Highlight that we can PRE into a latch block when there are multiple
; latches only one of which clobbers an otherwise invariant value.
define i32 @test4(i1 %cnd, i32* %p) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[V1:%.*]] = load i32, i32* [[P:%.*]], align 4
; CHECK-NEXT:    call void @hold(i32 [[V1]])
; CHECK-NEXT:    br label [[HEADER:%.*]]
; CHECK:       header:
; CHECK-NEXT:    [[V2:%.*]] = phi i32 [ [[V2_PRE:%.*]], [[BB2:%.*]] ], [ [[V2]], [[BB1:%.*]] ], [ [[V1]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    call void @hold(i32 [[V2]])
; CHECK-NEXT:    br i1 [[CND:%.*]], label [[BB1]], label [[BB2]]
; CHECK:       bb1:
; CHECK-NEXT:    br label [[HEADER]]
; CHECK:       bb2:
; CHECK-NEXT:    call void @clobber()
; CHECK-NEXT:    [[V2_PRE]] = load i32, i32* [[P]], align 4
; CHECK-NEXT:    br label [[HEADER]]
;
entry:
  %v1 = load i32, i32* %p
  call void @hold(i32 %v1)
  br label %header

header:
  %v2 = load i32, i32* %p
  call void @hold(i32 %v2)
  br i1 %cnd, label %bb1, label %bb2

bb1:
  br label %header

bb2:

  call void @clobber()
  br label %header
}

; Highlight the fact that we can PRE into a single clobbering latch block
; even in loop simplify form (though multiple applications of the same
; transformation).
define i32 @test5(i1 %cnd, i32* %p) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[V1:%.*]] = load i32, i32* [[P:%.*]], align 4
; CHECK-NEXT:    call void @hold(i32 [[V1]])
; CHECK-NEXT:    br label [[HEADER:%.*]]
; CHECK:       header:
; CHECK-NEXT:    [[V2_PRE2:%.*]] = phi i32 [ [[V2_PRE:%.*]], [[MERGE:%.*]] ], [ [[V1]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    call void @hold(i32 [[V2_PRE2]])
; CHECK-NEXT:    br i1 [[CND:%.*]], label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br label [[MERGE]]
; CHECK:       bb2:
; CHECK-NEXT:    call void @clobber()
; CHECK-NEXT:    [[V2_PRE_PRE:%.*]] = load i32, i32* [[P]], align 4
; CHECK-NEXT:    br label [[MERGE]]
; CHECK:       merge:
; CHECK-NEXT:    [[V2_PRE]] = phi i32 [ [[V2_PRE_PRE]], [[BB2]] ], [ [[V2_PRE2]], [[BB1]] ]
; CHECK-NEXT:    br label [[HEADER]]
;
entry:
  %v1 = load i32, i32* %p
  call void @hold(i32 %v1)
  br label %header

header:
  %v2 = load i32, i32* %p
  call void @hold(i32 %v2)
  br i1 %cnd, label %bb1, label %bb2

bb1:
  br label %merge

bb2:

  call void @clobber()
  br label %merge

merge:
  br label %header
}

declare void @llvm.experimental.guard(i1 %cnd, ...)

; These two tests highlight speculation safety when we can not establish
; anticipation (since the original load might actually not execcute)
define i32 @test6a(i1 %cnd, i32* %p) {
; CHECK-LABEL: @test6a(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[HEADER:%.*]]
; CHECK:       header:
; CHECK-NEXT:    call void (i1, ...) @llvm.experimental.guard(i1 [[CND:%.*]]) [ "deopt"() ]
; CHECK-NEXT:    [[V1:%.*]] = load i32, i32* [[P:%.*]], align 4
; CHECK-NEXT:    call void @hold(i32 [[V1]])
; CHECK-NEXT:    br label [[HEADER]]
;
entry:
  br label %header

header:
  call void (i1, ...) @llvm.experimental.guard(i1 %cnd) ["deopt"()]
  %v1 = load i32, i32* %p
  call void @hold(i32 %v1)
  br label %header
}

define i32 @test6b(i1 %cnd, i32* dereferenceable(8) align 4 %p) nofree nosync {
; CHECK-LABEL: @test6b(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[V1_PRE:%.*]] = load i32, i32* [[P:%.*]], align 4
; CHECK-NEXT:    br label [[HEADER:%.*]]
; CHECK:       header:
; CHECK-NEXT:    call void (i1, ...) @llvm.experimental.guard(i1 [[CND:%.*]]) [ "deopt"() ]
; CHECK-NEXT:    call void @hold(i32 [[V1_PRE]])
; CHECK-NEXT:    br label [[HEADER]]
;
entry:
  br label %header

header:
  call void (i1, ...) @llvm.experimental.guard(i1 %cnd) ["deopt"()]
  %v1 = load i32, i32* %p
  call void @hold(i32 %v1)
  br label %header
}
