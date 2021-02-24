; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -nary-reassociate -S | FileCheck %s
; RUN: opt < %s -passes='nary-reassociate' -S | FileCheck %s

declare i32 @llvm.umin.i32(i32 %a, i32 %b)

; m1 = umin(a,b) ; has side uses
; m2 = umin(umin((b,c), a) -> m2 = umin(m1, c)
define i32 @umin_test1(i32 %a, i32 %b, i32 %c) {
; CHECK-LABEL: @umin_test1(
; CHECK-NEXT:    [[C1:%.*]] = icmp ult i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[UMIN1:%.*]] = select i1 [[C1]], i32 [[A]], i32 [[B]]
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ult i32 [[UMIN1]], [[C:%.*]]
; CHECK-NEXT:    [[UMIN3_NARY:%.*]] = select i1 [[TMP1]], i32 [[UMIN1]], i32 [[C]]
; CHECK-NEXT:    [[RES:%.*]] = add i32 [[UMIN1]], [[UMIN3_NARY]]
; CHECK-NEXT:    ret i32 [[RES]]
;
  %c1 = icmp ult i32 %a, %b
  %umin1 = select i1 %c1, i32 %a, i32 %b
  %c2 = icmp ult i32 %b, %c
  %umin2 = select i1 %c2, i32 %b, i32 %c
  %c3 = icmp ult i32 %umin2, %a
  %umin3 = select i1 %c3, i32 %umin2, i32 %a
  %res = add i32 %umin1, %umin3
  ret i32 %res
}

; m1 = umin(a,b) ; has side uses
; m2 = umin(b, (umin(a, c))) -> m2 = umin(m1, c)
define i32 @umin_test2(i32 %a, i32 %b, i32 %c) {
; CHECK-LABEL: @umin_test2(
; CHECK-NEXT:    [[C1:%.*]] = icmp ult i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[UMIN1:%.*]] = select i1 [[C1]], i32 [[A]], i32 [[B]]
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ult i32 [[UMIN1]], [[C:%.*]]
; CHECK-NEXT:    [[UMIN3_NARY:%.*]] = select i1 [[TMP1]], i32 [[UMIN1]], i32 [[C]]
; CHECK-NEXT:    [[RES:%.*]] = add i32 [[UMIN1]], [[UMIN3_NARY]]
; CHECK-NEXT:    ret i32 [[RES]]
;
  %c1 = icmp ult i32 %a, %b
  %umin1 = select i1 %c1, i32 %a, i32 %b
  %c2 = icmp ult i32 %a, %c
  %umin2 = select i1 %c2, i32 %a, i32 %c
  %c3 = icmp ult i32 %b, %umin2
  %umin3 = select i1 %c3, i32 %b, i32 %umin2
  %res = add i32 %umin1, %umin3
  ret i32 %res
}

; Same test as umin_test1 but uses @llvm.umin intrinsic
define i32 @umin_test3(i32 %a, i32 %b, i32 %c) {
; CHECK-LABEL: @umin_test3(
; CHECK-NEXT:    [[UMIN1:%.*]] = call i32 @llvm.umin.i32(i32 [[A:%.*]], i32 [[B:%.*]])
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ult i32 [[UMIN1]], [[C:%.*]]
; CHECK-NEXT:    [[UMIN3_NARY:%.*]] = select i1 [[TMP1]], i32 [[UMIN1]], i32 [[C]]
; CHECK-NEXT:    [[RES:%.*]] = add i32 [[UMIN1]], [[UMIN3_NARY]]
; CHECK-NEXT:    ret i32 [[RES]]
;
  %umin1 = call i32 @llvm.umin.i32(i32 %a, i32 %b)
  %umin2 = call i32 @llvm.umin.i32(i32 %b, i32 %c)
  %umin3 = call i32 @llvm.umin.i32(i32 %umin2, i32 %a)
  %res = add i32 %umin1, %umin3
  ret i32 %res
}

; m1 = umin(a,b) ; has side uses
; m2 = umin(umin_or_eq((b,c), a) -> m2 = umin(m1, c)
define i32 @umin_test4(i32 %a, i32 %b, i32 %c) {
; CHECK-LABEL: @umin_test4(
; CHECK-NEXT:    [[C1:%.*]] = icmp ult i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[UMIN1:%.*]] = select i1 [[C1]], i32 [[A]], i32 [[B]]
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ult i32 [[UMIN1]], [[C:%.*]]
; CHECK-NEXT:    [[UMIN3_NARY:%.*]] = select i1 [[TMP1]], i32 [[UMIN1]], i32 [[C]]
; CHECK-NEXT:    [[RES:%.*]] = add i32 [[UMIN1]], [[UMIN3_NARY]]
; CHECK-NEXT:    ret i32 [[RES]]
;
  %c1 = icmp ult i32 %a, %b
  %umin1 = select i1 %c1, i32 %a, i32 %b
  %c2 = icmp ule i32 %b, %c
  %umin_or_eq2 = select i1 %c2, i32 %b, i32 %c
  %c3 = icmp ult i32 %umin_or_eq2, %a
  %umin3 = select i1 %c3, i32 %umin_or_eq2, i32 %a
  %res = add i32 %umin1, %umin3
  ret i32 %res
}

; m1 = umin_or_eq(a,b) ; has side uses
; m2 = umin_or_eq(umin((b,c), a) -> m2 = umin(m1, c)
define i32 @umin_test5(i32 %a, i32 %b, i32 %c) {
; CHECK-LABEL: @umin_test5(
; CHECK-NEXT:    [[C1:%.*]] = icmp ule i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[UMIN_OR_EQ1:%.*]] = select i1 [[C1]], i32 [[A]], i32 [[B]]
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ult i32 [[UMIN_OR_EQ1]], [[C:%.*]]
; CHECK-NEXT:    [[UMIN_OR_EQ3_NARY:%.*]] = select i1 [[TMP1]], i32 [[UMIN_OR_EQ1]], i32 [[C]]
; CHECK-NEXT:    [[RES:%.*]] = add i32 [[UMIN_OR_EQ1]], [[UMIN_OR_EQ3_NARY]]
; CHECK-NEXT:    ret i32 [[RES]]
;
  %c1 = icmp ule i32 %a, %b
  %umin_or_eq1 = select i1 %c1, i32 %a, i32 %b
  %c2 = icmp ult i32 %b, %c
  %umin2 = select i1 %c2, i32 %b, i32 %c
  %c3 = icmp ule i32 %umin2, %a
  %umin_or_eq3 = select i1 %c3, i32 %umin2, i32 %a
  %res = add i32 %umin_or_eq1, %umin_or_eq3
  ret i32 %res
}

; m1 = umin(a,b) ; has side uses
; m2 = umin(smin((b,c), a) ; check that signed and unsigned mins are not mixed
define i32 @umin_test6(i32 %a, i32 %b, i32 %c) {
; CHECK-LABEL: @umin_test6(
; CHECK-NEXT:    [[C1:%.*]] = icmp ult i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[UMIN1:%.*]] = select i1 [[C1]], i32 [[A]], i32 [[B]]
; CHECK-NEXT:    [[C2:%.*]] = icmp slt i32 [[B]], [[C:%.*]]
; CHECK-NEXT:    [[SMIN2:%.*]] = select i1 [[C2]], i32 [[B]], i32 [[C]]
; CHECK-NEXT:    [[C3:%.*]] = icmp ult i32 [[SMIN2]], [[A]]
; CHECK-NEXT:    [[UMIN3:%.*]] = select i1 [[C3]], i32 [[SMIN2]], i32 [[A]]
; CHECK-NEXT:    [[RES:%.*]] = add i32 [[UMIN1]], [[UMIN3]]
; CHECK-NEXT:    ret i32 [[RES]]
;
  %c1 = icmp ult i32 %a, %b
  %umin1 = select i1 %c1, i32 %a, i32 %b
  %c2 = icmp slt i32 %b, %c
  %smin2 = select i1 %c2, i32 %b, i32 %c
  %c3 = icmp ult i32 %smin2, %a
  %umin3 = select i1 %c3, i32 %smin2, i32 %a
  %res = add i32 %umin1, %umin3
  ret i32 %res
}

; m1 = umin(a,b) ; has side uses
; m2 = umin(umax((b,c), a) ; check that min and max are not mixed
define i32 @umin_test7(i32 %a, i32 %b, i32 %c) {
; CHECK-LABEL: @umin_test7(
; CHECK-NEXT:    [[C1:%.*]] = icmp ult i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[UMIN1:%.*]] = select i1 [[C1]], i32 [[A]], i32 [[B]]
; CHECK-NEXT:    [[C2:%.*]] = icmp ugt i32 [[B]], [[C:%.*]]
; CHECK-NEXT:    [[UMAX2:%.*]] = select i1 [[C2]], i32 [[B]], i32 [[C]]
; CHECK-NEXT:    [[C3:%.*]] = icmp ult i32 [[UMAX2]], [[A]]
; CHECK-NEXT:    [[UMIN3:%.*]] = select i1 [[C3]], i32 [[UMAX2]], i32 [[A]]
; CHECK-NEXT:    [[RES:%.*]] = add i32 [[UMIN1]], [[UMIN3]]
; CHECK-NEXT:    ret i32 [[RES]]
;
  %c1 = icmp ult i32 %a, %b
  %umin1 = select i1 %c1, i32 %a, i32 %b
  %c2 = icmp ugt i32 %b, %c
  %umax2 = select i1 %c2, i32 %b, i32 %c
  %c3 = icmp ult i32 %umax2, %a
  %umin3 = select i1 %c3, i32 %umax2, i32 %a
  %res = add i32 %umin1, %umin3
  ret i32 %res
}
