; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -simplifycfg -simplifycfg-require-and-preserve-domtree=1 -keep-loops=0 < %s | FileCheck %s

; Merge 2 undefined incoming values.

define i32 @undef_merge(i32 %x) {
; CHECK-LABEL: @undef_merge(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    switch i32 [[X:%.*]], label [[EXIT:%.*]] [
; CHECK-NEXT:    i32 4, label [[G:%.*]]
; CHECK-NEXT:    i32 12, label [[G]]
; CHECK-NEXT:    ]
; CHECK:       g:
; CHECK-NEXT:    [[K3:%.*]] = phi i64 [ undef, [[ENTRY:%.*]] ], [ [[K3]], [[G]] ], [ undef, [[ENTRY]] ]
; CHECK-NEXT:    br label [[G]]
; CHECK:       exit:
; CHECK-NEXT:    ret i32 undef
;
entry:
  switch i32 %x, label %exit [
  i32 4, label %loop
  i32 12, label %g
  ]

loop:
  %k2 = phi i64 [ %k3, %g ], [ undef, %entry ]
  br label %g

g:
  %k3 = phi i64 [ %k2, %loop ], [ undef, %entry ]
  br label %loop

exit:
  ret i32 undef
}

; Merge 2 poison incoming values.

define i32 @poison_merge(i32 %x) {
; CHECK-LABEL: @poison_merge(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    switch i32 [[X:%.*]], label [[EXIT:%.*]] [
; CHECK-NEXT:    i32 4, label [[G:%.*]]
; CHECK-NEXT:    i32 12, label [[G]]
; CHECK-NEXT:    ]
; CHECK:       g:
; CHECK-NEXT:    [[K3:%.*]] = phi i64 [ poison, [[ENTRY:%.*]] ], [ [[K3]], [[G]] ], [ poison, [[ENTRY]] ]
; CHECK-NEXT:    br label [[G]]
; CHECK:       exit:
; CHECK-NEXT:    ret i32 undef
;
entry:
  switch i32 %x, label %exit [
  i32 4, label %loop
  i32 12, label %g
  ]

loop:
  %k2 = phi i64 [ %k3, %g ], [ poison, %entry ]
  br label %g

g:
  %k3 = phi i64 [ %k2, %loop ], [ poison, %entry ]
  br label %loop

exit:
  ret i32 undef
}

; Merge equal defined incoming values.

define i32 @defined_merge(i32 %x) {
; CHECK-LABEL: @defined_merge(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    switch i32 [[X:%.*]], label [[EXIT:%.*]] [
; CHECK-NEXT:    i32 4, label [[G:%.*]]
; CHECK-NEXT:    i32 12, label [[G]]
; CHECK-NEXT:    ]
; CHECK:       g:
; CHECK-NEXT:    [[K3:%.*]] = phi i64 [ 42, [[ENTRY:%.*]] ], [ [[K3]], [[G]] ], [ 42, [[ENTRY]] ]
; CHECK-NEXT:    br label [[G]]
; CHECK:       exit:
; CHECK-NEXT:    ret i32 undef
;
entry:
  switch i32 %x, label %exit [
  i32 4, label %loop
  i32 12, label %g
  ]

loop:
  %k2 = phi i64 [ %k3, %g ], [ 42, %entry ]
  br label %g

g:
  %k3 = phi i64 [ %k2, %loop ], [ 42, %entry ]
  br label %loop

exit:
  ret i32 undef
}

; Merge defined and undef incoming values.

define i32 @defined_and_undef_merge(i32 %x) {
; CHECK-LABEL: @defined_and_undef_merge(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    switch i32 [[X:%.*]], label [[EXIT:%.*]] [
; CHECK-NEXT:    i32 4, label [[G:%.*]]
; CHECK-NEXT:    i32 12, label [[G]]
; CHECK-NEXT:    ]
; CHECK:       g:
; CHECK-NEXT:    [[K3:%.*]] = phi i64 [ 42, [[ENTRY:%.*]] ], [ [[K3]], [[G]] ], [ 42, [[ENTRY]] ]
; CHECK-NEXT:    br label [[G]]
; CHECK:       exit:
; CHECK-NEXT:    ret i32 undef
;
entry:
  switch i32 %x, label %exit [
  i32 4, label %loop
  i32 12, label %g
  ]

loop:
  %k2 = phi i64 [ %k3, %g ], [ undef, %entry ]
  br label %g

g:
  %k3 = phi i64 [ %k2, %loop ], [ 42, %entry ]
  br label %loop

exit:
  ret i32 undef
}

; Merge defined and poison incoming values.

define i32 @defined_and_poison_merge(i32 %x) {
; CHECK-LABEL: @defined_and_poison_merge(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    switch i32 [[X:%.*]], label [[EXIT:%.*]] [
; CHECK-NEXT:    i32 4, label [[G:%.*]]
; CHECK-NEXT:    i32 12, label [[G]]
; CHECK-NEXT:    ]
; CHECK:       g:
; CHECK-NEXT:    [[K3:%.*]] = phi i64 [ 42, [[ENTRY:%.*]] ], [ [[K3]], [[G]] ], [ 42, [[ENTRY]] ]
; CHECK-NEXT:    br label [[G]]
; CHECK:       exit:
; CHECK-NEXT:    ret i32 undef
;
entry:
  switch i32 %x, label %exit [
  i32 4, label %loop
  i32 12, label %g
  ]

loop:
  %k2 = phi i64 [ %k3, %g ], [ poison, %entry ]
  br label %g

g:
  %k3 = phi i64 [ %k2, %loop ], [ 42, %entry ]
  br label %loop

exit:
  ret i32 undef
}

; Do not crash trying to merge poison and undef into a single phi.

define i32 @PR49218(i32 %x) {
; CHECK-LABEL: @PR49218(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    switch i32 [[X:%.*]], label [[EXIT:%.*]] [
; CHECK-NEXT:    i32 4, label [[G:%.*]]
; CHECK-NEXT:    i32 12, label [[G]]
; CHECK-NEXT:    ]
; CHECK:       g:
; CHECK-NEXT:    [[K3:%.*]] = phi i64 [ undef, [[ENTRY:%.*]] ], [ [[K3]], [[G]] ], [ undef, [[ENTRY]] ]
; CHECK-NEXT:    br label [[G]]
; CHECK:       exit:
; CHECK-NEXT:    ret i32 undef
;
entry:
  switch i32 %x, label %exit [
  i32 4, label %loop
  i32 12, label %g
  ]

loop:
  %k2 = phi i64 [ %k3, %g ], [ undef, %entry ]
  br label %g

g:
  %k3 = phi i64 [ %k2, %loop ], [ poison, %entry ]
  br label %loop

exit:
  ret i32 undef
}
