; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -sroa -S | FileCheck %s
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-n8:16:32:64"

@a = external global i16, align 1

declare void @maybe_writes()

define void @f2() {
; CHECK-LABEL: @f2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 undef, label [[IF_THEN:%.*]], label [[IF_ELSE:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    br label [[CLEANUP:%.*]]
; CHECK:       cleanup:
; CHECK-NEXT:    [[G_0_SROA_SPECULATE_LOAD_CLEANUP:%.*]] = load i16, i16* @a, align 1
; CHECK-NEXT:    switch i32 2, label [[CLEANUP7:%.*]] [
; CHECK-NEXT:    i32 0, label [[LBL1:%.*]]
; CHECK-NEXT:    i32 2, label [[LBL1]]
; CHECK-NEXT:    ]
; CHECK:       if.else:
; CHECK-NEXT:    br label [[LBL1]]
; CHECK:       lbl1:
; CHECK-NEXT:    [[G_0_SROA_SPECULATED:%.*]] = phi i16 [ [[G_0_SROA_SPECULATE_LOAD_CLEANUP]], [[CLEANUP]] ], [ [[G_0_SROA_SPECULATE_LOAD_CLEANUP]], [[CLEANUP]] ], [ undef, [[IF_ELSE]] ]
; CHECK-NEXT:    unreachable
; CHECK:       cleanup7:
; CHECK-NEXT:    ret void
;
entry:
  %e = alloca i16, align 1
  br i1 undef, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  br label %cleanup

cleanup:                                          ; preds = %if.then
  switch i32 2, label %cleanup7 [
  i32 0, label %lbl1
  i32 2, label %lbl1
  ]

if.else:                                          ; preds = %entry
  br label %lbl1

lbl1:                                             ; preds = %if.else, %cleanup, %cleanup
  %g.0 = phi i16* [ @a, %cleanup ], [ @a, %cleanup ], [ %e, %if.else ]
  %0 = load i16, i16* %g.0, align 1
  unreachable

cleanup7:                                         ; preds = %cleanup
  ret void
}

define void @f3() {
; CHECK-LABEL: @f3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[E:%.*]] = alloca i16, align 1
; CHECK-NEXT:    br i1 undef, label [[IF_THEN:%.*]], label [[IF_ELSE:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    br label [[CLEANUP:%.*]]
; CHECK:       cleanup:
; CHECK-NEXT:    switch i32 2, label [[CLEANUP7:%.*]] [
; CHECK-NEXT:    i32 0, label [[LBL1:%.*]]
; CHECK-NEXT:    i32 2, label [[LBL1]]
; CHECK-NEXT:    ]
; CHECK:       if.else:
; CHECK-NEXT:    br label [[LBL1]]
; CHECK:       lbl1:
; CHECK-NEXT:    [[G_0:%.*]] = phi i16* [ @a, [[CLEANUP]] ], [ @a, [[CLEANUP]] ], [ [[E]], [[IF_ELSE]] ]
; CHECK-NEXT:    br label [[FINAL:%.*]]
; CHECK:       final:
; CHECK-NEXT:    [[TMP0:%.*]] = load i16, i16* [[G_0]], align 1
; CHECK-NEXT:    unreachable
; CHECK:       cleanup7:
; CHECK-NEXT:    ret void
;
entry:
  %e = alloca i16, align 1
  br i1 undef, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  br label %cleanup

cleanup:                                          ; preds = %if.then
  switch i32 2, label %cleanup7 [
  i32 0, label %lbl1
  i32 2, label %lbl1
  ]

if.else:                                          ; preds = %entry
  br label %lbl1

lbl1:                                             ; preds = %if.else, %cleanup, %cleanup
  %g.0 = phi i16* [ @a, %cleanup ], [ @a, %cleanup ], [ %e, %if.else ]
  br label %final

final:
  %0 = load i16, i16* %g.0, align 1
  unreachable

cleanup7:                                         ; preds = %cleanup
  ret void
}

define void @f4() {
; CHECK-LABEL: @f4(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[E:%.*]] = alloca i16, align 1
; CHECK-NEXT:    br i1 undef, label [[IF_THEN:%.*]], label [[IF_ELSE:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    br label [[CLEANUP:%.*]]
; CHECK:       cleanup:
; CHECK-NEXT:    switch i32 2, label [[CLEANUP7:%.*]] [
; CHECK-NEXT:    i32 0, label [[LBL1:%.*]]
; CHECK-NEXT:    i32 2, label [[LBL1]]
; CHECK-NEXT:    ]
; CHECK:       if.else:
; CHECK-NEXT:    br label [[LBL1]]
; CHECK:       lbl1:
; CHECK-NEXT:    [[G_0:%.*]] = phi i16* [ @a, [[CLEANUP]] ], [ @a, [[CLEANUP]] ], [ [[E]], [[IF_ELSE]] ]
; CHECK-NEXT:    br label [[FINAL:%.*]]
; CHECK:       final:
; CHECK-NEXT:    call void @maybe_writes()
; CHECK-NEXT:    [[TMP0:%.*]] = load i16, i16* [[G_0]], align 1
; CHECK-NEXT:    unreachable
; CHECK:       cleanup7:
; CHECK-NEXT:    ret void
;
entry:
  %e = alloca i16, align 1
  br i1 undef, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  br label %cleanup

cleanup:                                          ; preds = %if.then
  switch i32 2, label %cleanup7 [
  i32 0, label %lbl1
  i32 2, label %lbl1
  ]

if.else:                                          ; preds = %entry
  br label %lbl1

lbl1:                                             ; preds = %if.else, %cleanup, %cleanup
  %g.0 = phi i16* [ @a, %cleanup ], [ @a, %cleanup ], [ %e, %if.else ]
  br label %final

final:
  call void @maybe_writes()
  %0 = load i16, i16* %g.0, align 1
  unreachable

cleanup7:                                         ; preds = %cleanup
  ret void
}

define void @f5() {
; CHECK-LABEL: @f5(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[E:%.*]] = alloca i16, align 1
; CHECK-NEXT:    br i1 undef, label [[IF_THEN:%.*]], label [[IF_ELSE:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    br label [[CLEANUP:%.*]]
; CHECK:       cleanup:
; CHECK-NEXT:    switch i32 2, label [[CLEANUP7:%.*]] [
; CHECK-NEXT:    i32 0, label [[LBL1:%.*]]
; CHECK-NEXT:    i32 2, label [[LBL1]]
; CHECK-NEXT:    ]
; CHECK:       if.else:
; CHECK-NEXT:    br label [[LBL1]]
; CHECK:       lbl1:
; CHECK-NEXT:    [[G_0:%.*]] = phi i16* [ @a, [[CLEANUP]] ], [ @a, [[CLEANUP]] ], [ [[E]], [[IF_ELSE]] ]
; CHECK-NEXT:    br i1 undef, label [[FINAL:%.*]], label [[CLEANUP7]]
; CHECK:       final:
; CHECK-NEXT:    [[TMP0:%.*]] = load i16, i16* [[G_0]], align 1
; CHECK-NEXT:    unreachable
; CHECK:       cleanup7:
; CHECK-NEXT:    ret void
;
entry:
  %e = alloca i16, align 1
  br i1 undef, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  br label %cleanup

cleanup:                                          ; preds = %if.then
  switch i32 2, label %cleanup7 [
  i32 0, label %lbl1
  i32 2, label %lbl1
  ]

if.else:                                          ; preds = %entry
  br label %lbl1

lbl1:                                             ; preds = %if.else, %cleanup, %cleanup
  %g.0 = phi i16* [ @a, %cleanup ], [ @a, %cleanup ], [ %e, %if.else ]
  br i1 undef, label %final, label %cleanup7

final:
  %0 = load i16, i16* %g.0, align 1
  unreachable

cleanup7:                                         ; preds = %cleanup
  ret void
}

define void @f6() {
; CHECK-LABEL: @f6(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[E:%.*]] = alloca i16, align 1
; CHECK-NEXT:    br i1 undef, label [[IF_THEN:%.*]], label [[IF_ELSE:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    br label [[CLEANUP:%.*]]
; CHECK:       cleanup:
; CHECK-NEXT:    switch i32 2, label [[CLEANUP7:%.*]] [
; CHECK-NEXT:    i32 0, label [[LBL1:%.*]]
; CHECK-NEXT:    i32 2, label [[LBL1]]
; CHECK-NEXT:    ]
; CHECK:       if.else:
; CHECK-NEXT:    br label [[LBL1]]
; CHECK:       lbl1:
; CHECK-NEXT:    [[G_0:%.*]] = phi i16* [ @a, [[CLEANUP]] ], [ @a, [[CLEANUP]] ], [ [[E]], [[IF_ELSE]] ]
; CHECK-NEXT:    br label [[FINAL:%.*]]
; CHECK:       unreachable_pred:
; CHECK-NEXT:    br label [[FINAL]]
; CHECK:       final:
; CHECK-NEXT:    call void @maybe_writes()
; CHECK-NEXT:    [[TMP0:%.*]] = load i16, i16* [[G_0]], align 1
; CHECK-NEXT:    unreachable
; CHECK:       cleanup7:
; CHECK-NEXT:    ret void
;
entry:
  %e = alloca i16, align 1
  br i1 undef, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  br label %cleanup

cleanup:                                          ; preds = %if.then
  switch i32 2, label %cleanup7 [
  i32 0, label %lbl1
  i32 2, label %lbl1
  ]

if.else:                                          ; preds = %entry
  br label %lbl1

lbl1:                                             ; preds = %if.else, %cleanup, %cleanup
  %g.0 = phi i16* [ @a, %cleanup ], [ @a, %cleanup ], [ %e, %if.else ]
  br label %final

unreachable_pred:
  br label %final

final:
  call void @maybe_writes()
  %0 = load i16, i16* %g.0, align 1
  unreachable

cleanup7:                                         ; preds = %cleanup
  ret void
}
