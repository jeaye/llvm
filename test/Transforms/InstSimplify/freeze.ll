; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instsimplify -S | FileCheck %s

define i32 @fold(i32 %x) {
; CHECK-LABEL: @fold(
; CHECK-NEXT:    [[Y:%.*]] = freeze i32 [[X:%.*]]
; CHECK-NEXT:    ret i32 [[Y]]
;
  %y = freeze i32 %x
  %z = freeze i32 %y
  ret i32 %z
}

define i32 @make_const() {
; CHECK-LABEL: @make_const(
; CHECK-NEXT:    ret i32 10
;
  %x = freeze i32 10
  ret i32 %x
}

define i1 @brcond(i1 %c, i1 %c2) {
; CHECK-LABEL: @brcond(
; CHECK-NEXT:    br i1 [[C:%.*]], label [[A:%.*]], label [[B:%.*]]
; CHECK:       A:
; CHECK-NEXT:    br i1 [[C2:%.*]], label [[A2:%.*]], label [[B]]
; CHECK:       A2:
; CHECK-NEXT:    ret i1 [[C]]
; CHECK:       B:
; CHECK-NEXT:    ret i1 [[C]]
;
  br i1 %c, label %A, label %B
A:
  br i1 %c2, label %A2, label %B
A2:
  %f1 = freeze i1 %c
  ret i1 %f1
B:
  %f2 = freeze i1 %c
  ret i1 %f2
}

define i32 @brcond_switch(i32 %x) {
; CHECK-LABEL: @brcond_switch(
; CHECK-NEXT:    switch i32 [[X:%.*]], label [[EXIT:%.*]] [
; CHECK-NEXT:    i32 0, label [[A:%.*]]
; CHECK-NEXT:    ]
; CHECK:       A:
; CHECK-NEXT:    ret i32 [[X]]
; CHECK:       EXIT:
; CHECK-NEXT:    ret i32 [[X]]
;
  switch i32 %x, label %EXIT [ i32 0, label %A ]
A:
  %fr1 = freeze i32 %x
  ret i32 %fr1
EXIT:
  %fr2 = freeze i32 %x
  ret i32 %fr2
}

define i1 @brcond_noopt(i1 %c, i1 %c2) {
; CHECK-LABEL: @brcond_noopt(
; CHECK-NEXT:    [[F:%.*]] = freeze i1 [[C:%.*]]
; CHECK-NEXT:    call void @f1(i1 [[F]])
; CHECK-NEXT:    call void @f2()
; CHECK-NEXT:    br i1 [[C]], label [[A:%.*]], label [[B:%.*]]
; CHECK:       A:
; CHECK-NEXT:    ret i1 false
; CHECK:       B:
; CHECK-NEXT:    ret i1 true
;
  %f = freeze i1 %c
  call void @f1(i1 %f) ; cannot optimize i1 %f to %c
  call void @f2()      ; .. because if f2() exits, `br %c` cannot be reached
  br i1 %c, label %A, label %B
A:
  ret i1 0
B:
  ret i1 1
}
declare void @f1(i1)
declare void @f2()
