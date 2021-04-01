; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --check-attributes
; RUN: opt < %s -function-attrs -S | FileCheck %s
; RUN: opt < %s -passes=function-attrs -S | FileCheck %s

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

define void @_Z4foo1Pi(i32* nocapture readnone %a) local_unnamed_addr #0 {
; CHECK: Function Attrs: uwtable
; CHECK-LABEL: @_Z4foo1Pi(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    tail call void @_Z3extv()
; CHECK-NEXT:    ret void
;
entry:
  tail call void @_Z3extv()
  ret void
}

declare void @_Z3extv() local_unnamed_addr

define void @_Z4foo2Pi(i32* nocapture %a) local_unnamed_addr #1 {
; CHECK: Function Attrs: nounwind uwtable
; CHECK-LABEL: @_Z4foo2Pi(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i32* [[A:%.*]] to i8*
; CHECK-NEXT:    tail call void @free(i8* [[TMP0]]) #[[ATTR2:[0-9]+]]
; CHECK-NEXT:    ret void
;
entry:
  %0 = bitcast i32* %a to i8*
  tail call void @free(i8* %0) #2
  ret void
}

declare void @free(i8* nocapture) local_unnamed_addr #2

define i32 @_Z4foo3Pi(i32* nocapture readonly %a) local_unnamed_addr #3 {
; CHECK: Function Attrs: norecurse nounwind readonly uwtable willreturn
; CHECK-LABEL: @_Z4foo3Pi(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* [[A:%.*]], align 4
; CHECK-NEXT:    ret i32 [[TMP0]]
;
entry:
  %0 = load i32, i32* %a, align 4
  ret i32 %0
}

define double @_Z4foo4Pd(double* nocapture readonly %a) local_unnamed_addr #1 {
; CHECK: Function Attrs: nounwind uwtable
; CHECK-LABEL: @_Z4foo4Pd(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load double, double* [[A:%.*]], align 8
; CHECK-NEXT:    [[CALL:%.*]] = tail call double @cos(double [[TMP0]]) #[[ATTR2]]
; CHECK-NEXT:    ret double [[CALL]]
;
entry:
  %0 = load double, double* %a, align 8
  %call = tail call double @cos(double %0) #2
  ret double %call
}

declare double @cos(double) local_unnamed_addr #2

define noalias i32* @_Z4foo5Pm(i64* nocapture readonly %a) local_unnamed_addr #1 {
; CHECK: Function Attrs: nounwind uwtable
; CHECK-LABEL: @_Z4foo5Pm(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load i64, i64* [[A:%.*]], align 8
; CHECK-NEXT:    [[CALL:%.*]] = tail call noalias i8* @malloc(i64 [[TMP0]]) #[[ATTR2]]
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i8* [[CALL]] to i32*
; CHECK-NEXT:    ret i32* [[TMP1]]
;
entry:
  %0 = load i64, i64* %a, align 8
  %call = tail call noalias i8* @malloc(i64 %0) #2
  %1 = bitcast i8* %call to i32*
  ret i32* %1
}

declare noalias i8* @malloc(i64) local_unnamed_addr #2

define noalias i64* @_Z4foo6Pm(i64* nocapture %a) local_unnamed_addr #1 {
; CHECK: Function Attrs: nounwind uwtable
; CHECK-LABEL: @_Z4foo6Pm(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i64* [[A:%.*]] to i8*
; CHECK-NEXT:    [[TMP1:%.*]] = load i64, i64* [[A]], align 8
; CHECK-NEXT:    [[CALL:%.*]] = tail call i8* @realloc(i8* [[TMP0]], i64 [[TMP1]]) #[[ATTR2]]
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast i8* [[CALL]] to i64*
; CHECK-NEXT:    ret i64* [[TMP2]]
;
entry:
  %0 = bitcast i64* %a to i8*
  %1 = load i64, i64* %a, align 8
  %call = tail call i8* @realloc(i8* %0, i64 %1) #2
  %2 = bitcast i8* %call to i64*
  ret i64* %2
}

declare noalias i8* @realloc(i8* nocapture, i64) local_unnamed_addr #2

define void @_Z4foo7Pi(i32* %a) local_unnamed_addr #1 {
; CHECK: Function Attrs: nounwind uwtable
; CHECK-LABEL: @_Z4foo7Pi(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ISNULL:%.*]] = icmp eq i32* [[A:%.*]], null
; CHECK-NEXT:    br i1 [[ISNULL]], label [[DELETE_END:%.*]], label [[DELETE_NOTNULL:%.*]]
; CHECK:       delete.notnull:
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i32* [[A]] to i8*
; CHECK-NEXT:    tail call void @_ZdlPv(i8* [[TMP0]]) #[[ATTR6:[0-9]+]]
; CHECK-NEXT:    br label [[DELETE_END]]
; CHECK:       delete.end:
; CHECK-NEXT:    ret void
;
entry:
  %isnull = icmp eq i32* %a, null
  br i1 %isnull, label %delete.end, label %delete.notnull

delete.notnull:                                   ; preds = %entry
  %0 = bitcast i32* %a to i8*
  tail call void @_ZdlPv(i8* %0) #5
  br label %delete.end

delete.end:                                       ; preds = %delete.notnull, %entry
  ret void
}

declare void @_ZdlPv(i8*) local_unnamed_addr #4

define void @_Z4foo8Pi(i32* %a) local_unnamed_addr #1 {
; CHECK: Function Attrs: nounwind uwtable
; CHECK-LABEL: @_Z4foo8Pi(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ISNULL:%.*]] = icmp eq i32* [[A:%.*]], null
; CHECK-NEXT:    br i1 [[ISNULL]], label [[DELETE_END:%.*]], label [[DELETE_NOTNULL:%.*]]
; CHECK:       delete.notnull:
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i32* [[A]] to i8*
; CHECK-NEXT:    tail call void @_ZdaPv(i8* [[TMP0]]) #[[ATTR6]]
; CHECK-NEXT:    br label [[DELETE_END]]
; CHECK:       delete.end:
; CHECK-NEXT:    ret void
;
entry:
  %isnull = icmp eq i32* %a, null
  br i1 %isnull, label %delete.end, label %delete.notnull

delete.notnull:                                   ; preds = %entry
  %0 = bitcast i32* %a to i8*
  tail call void @_ZdaPv(i8* %0) #5
  br label %delete.end

delete.end:                                       ; preds = %delete.notnull, %entry
  ret void
}

declare void @may_free()

define void @nofree_callsite_attr(i32* %a) {
; CHECK: Function Attrs: nofree
; CHECK-LABEL: @nofree_callsite_attr(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    call void @may_free() #[[ATTR5:[0-9]+]]
; CHECK-NEXT:    ret void
;
entry:
  call void @may_free() nofree
  ret void
}

declare void @_ZdaPv(i8*) local_unnamed_addr #4

attributes #0 = { uwtable }
attributes #1 = { nounwind uwtable }
attributes #2 = { nounwind }
attributes #3 = { norecurse nounwind readonly uwtable }
attributes #4 = { nobuiltin nounwind }
attributes #5 = { builtin nounwind }
