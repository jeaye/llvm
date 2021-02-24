; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -nary-reassociate -S | FileCheck %s
; RUN: opt < %s -passes='nary-reassociate' -S | FileCheck %s

declare i32 @llvm.umax.i32(i32 %a, i32 %b)

; m1 = umax(a,b) ; has side uses
; m2 = umax(umax((b,c), a) -> m2 = umax(m1, c)
define i32 @umax_test1(i32 %a, i32 %b, i32 %c) {
; CHECK-LABEL: @umax_test1(
; CHECK-NEXT:    [[C1:%.*]] = icmp ugt i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[UMAX1:%.*]] = select i1 [[C1]], i32 [[A]], i32 [[B]]
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ugt i32 [[UMAX1]], [[C:%.*]]
; CHECK-NEXT:    [[UMAX3_NARY:%.*]] = select i1 [[TMP1]], i32 [[UMAX1]], i32 [[C]]
; CHECK-NEXT:    [[RES:%.*]] = add i32 [[UMAX1]], [[UMAX3_NARY]]
; CHECK-NEXT:    ret i32 [[RES]]
;
  %c1 = icmp ugt i32 %a, %b
  %umax1 = select i1 %c1, i32 %a, i32 %b
  %c2 = icmp ugt i32 %b, %c
  %umax2 = select i1 %c2, i32 %b, i32 %c
  %c3 = icmp ugt i32 %umax2, %a
  %umax3 = select i1 %c3, i32 %umax2, i32 %a
  %res = add i32 %umax1, %umax3
  ret i32 %res
}

; m1 = umax(a,b) ; has side uses
; m2 = umax(b, (umax(a, c))) -> m2 = umax(m1, c)
define i32 @umax_test2(i32 %a, i32 %b, i32 %c) {
; CHECK-LABEL: @umax_test2(
; CHECK-NEXT:    [[C1:%.*]] = icmp ugt i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[UMAX1:%.*]] = select i1 [[C1]], i32 [[A]], i32 [[B]]
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ugt i32 [[UMAX1]], [[C:%.*]]
; CHECK-NEXT:    [[UMAX3_NARY:%.*]] = select i1 [[TMP1]], i32 [[UMAX1]], i32 [[C]]
; CHECK-NEXT:    [[RES:%.*]] = add i32 [[UMAX1]], [[UMAX3_NARY]]
; CHECK-NEXT:    ret i32 [[RES]]
;
  %c1 = icmp ugt i32 %a, %b
  %umax1 = select i1 %c1, i32 %a, i32 %b
  %c2 = icmp ugt i32 %a, %c
  %umax2 = select i1 %c2, i32 %a, i32 %c
  %c3 = icmp ugt i32 %b, %umax2
  %umax3 = select i1 %c3, i32 %b, i32 %umax2
  %res = add i32 %umax1, %umax3
  ret i32 %res
}

; Same test as umax_test1 but uses @llvm.umax intrinsic
define i32 @umax_test3(i32 %a, i32 %b, i32 %c) {
; CHECK-LABEL: @umax_test3(
; CHECK-NEXT:    [[UMAX1:%.*]] = call i32 @llvm.umax.i32(i32 [[A:%.*]], i32 [[B:%.*]])
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ugt i32 [[UMAX1]], [[C:%.*]]
; CHECK-NEXT:    [[UMAX3_NARY:%.*]] = select i1 [[TMP1]], i32 [[UMAX1]], i32 [[C]]
; CHECK-NEXT:    [[RES:%.*]] = add i32 [[UMAX1]], [[UMAX3_NARY]]
; CHECK-NEXT:    ret i32 [[RES]]
;
  %umax1 = call i32 @llvm.umax.i32(i32 %a, i32 %b)
  %umax2 = call i32 @llvm.umax.i32(i32 %b, i32 %c)
  %umax3 = call i32 @llvm.umax.i32(i32 %umax2, i32 %a)
  %res = add i32 %umax1, %umax3
  ret i32 %res
}

; m1 = umax(a,b) ; has side uses
; m2 = umax(umax_or_eq((b,c), a) -> m2 = umax(m1, c)
define i32 @umax_test4(i32 %a, i32 %b, i32 %c) {
; CHECK-LABEL: @umax_test4(
; CHECK-NEXT:    [[C1:%.*]] = icmp ugt i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[UMAX1:%.*]] = select i1 [[C1]], i32 [[A]], i32 [[B]]
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ugt i32 [[UMAX1]], [[C:%.*]]
; CHECK-NEXT:    [[UMAX3_NARY:%.*]] = select i1 [[TMP1]], i32 [[UMAX1]], i32 [[C]]
; CHECK-NEXT:    [[RES:%.*]] = add i32 [[UMAX1]], [[UMAX3_NARY]]
; CHECK-NEXT:    ret i32 [[RES]]
;
  %c1 = icmp ugt i32 %a, %b
  %umax1 = select i1 %c1, i32 %a, i32 %b
  %c2 = icmp uge i32 %b, %c
  %umax_or_eq2 = select i1 %c2, i32 %b, i32 %c
  %c3 = icmp ugt i32 %umax_or_eq2, %a
  %umax3 = select i1 %c3, i32 %umax_or_eq2, i32 %a
  %res = add i32 %umax1, %umax3
  ret i32 %res
}

; m1 = umax_or_eq(a,b) ; has side uses
; m2 = umax_or_eq(umax((b,c), a) -> m2 = umax(m1, c)
define i32 @umax_test5(i32 %a, i32 %b, i32 %c) {
; CHECK-LABEL: @umax_test5(
; CHECK-NEXT:    [[C1:%.*]] = icmp uge i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[UMAX_OR_EQ1:%.*]] = select i1 [[C1]], i32 [[A]], i32 [[B]]
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ugt i32 [[UMAX_OR_EQ1]], [[C:%.*]]
; CHECK-NEXT:    [[UMAX_OR_EQ3_NARY:%.*]] = select i1 [[TMP1]], i32 [[UMAX_OR_EQ1]], i32 [[C]]
; CHECK-NEXT:    [[RES:%.*]] = add i32 [[UMAX_OR_EQ1]], [[UMAX_OR_EQ3_NARY]]
; CHECK-NEXT:    ret i32 [[RES]]
;
  %c1 = icmp uge i32 %a, %b
  %umax_or_eq1 = select i1 %c1, i32 %a, i32 %b
  %c2 = icmp ugt i32 %b, %c
  %umax2 = select i1 %c2, i32 %b, i32 %c
  %c3 = icmp uge i32 %umax2, %a
  %umax_or_eq3 = select i1 %c3, i32 %umax2, i32 %a
  %res = add i32 %umax_or_eq1, %umax_or_eq3
  ret i32 %res
}

; m1 = umax(a,b) ; has side uses
; m2 = umax(smax((b,c), a) ; check that signed and unsigned maxs are not mixed
define i32 @umax_test6(i32 %a, i32 %b, i32 %c) {
; CHECK-LABEL: @umax_test6(
; CHECK-NEXT:    [[C1:%.*]] = icmp ugt i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[UMAX1:%.*]] = select i1 [[C1]], i32 [[A]], i32 [[B]]
; CHECK-NEXT:    [[C2:%.*]] = icmp sgt i32 [[B]], [[C:%.*]]
; CHECK-NEXT:    [[SMAX2:%.*]] = select i1 [[C2]], i32 [[B]], i32 [[C]]
; CHECK-NEXT:    [[C3:%.*]] = icmp ugt i32 [[SMAX2]], [[A]]
; CHECK-NEXT:    [[UMAX3:%.*]] = select i1 [[C3]], i32 [[SMAX2]], i32 [[A]]
; CHECK-NEXT:    [[RES:%.*]] = add i32 [[UMAX1]], [[UMAX3]]
; CHECK-NEXT:    ret i32 [[RES]]
;
  %c1 = icmp ugt i32 %a, %b
  %umax1 = select i1 %c1, i32 %a, i32 %b
  %c2 = icmp sgt i32 %b, %c
  %smax2 = select i1 %c2, i32 %b, i32 %c
  %c3 = icmp ugt i32 %smax2, %a
  %umax3 = select i1 %c3, i32 %smax2, i32 %a
  %res = add i32 %umax1, %umax3
  ret i32 %res
}

; m1 = umax(a,b) ; has side uses
; m2 = umax(umin((b,c), a) ; check that max and min are not mixed
define i32 @umax_test7(i32 %a, i32 %b, i32 %c) {
; CHECK-LABEL: @umax_test7(
; CHECK-NEXT:    [[C1:%.*]] = icmp ugt i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[UMAX1:%.*]] = select i1 [[C1]], i32 [[A]], i32 [[B]]
; CHECK-NEXT:    [[C2:%.*]] = icmp ult i32 [[B]], [[C:%.*]]
; CHECK-NEXT:    [[UMAX2:%.*]] = select i1 [[C2]], i32 [[B]], i32 [[C]]
; CHECK-NEXT:    [[C3:%.*]] = icmp ugt i32 [[UMAX2]], [[A]]
; CHECK-NEXT:    [[UMAX3:%.*]] = select i1 [[C3]], i32 [[UMAX2]], i32 [[A]]
; CHECK-NEXT:    [[RES:%.*]] = add i32 [[UMAX1]], [[UMAX3]]
; CHECK-NEXT:    ret i32 [[RES]]
;
  %c1 = icmp ugt i32 %a, %b
  %umax1 = select i1 %c1, i32 %a, i32 %b
  %c2 = icmp ult i32 %b, %c
  %umax2 = select i1 %c2, i32 %b, i32 %c
  %c3 = icmp ugt i32 %umax2, %a
  %umax3 = select i1 %c3, i32 %umax2, i32 %a
  %res = add i32 %umax1, %umax3
  ret i32 %res
}
