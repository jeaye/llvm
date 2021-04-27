; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -nary-reassociate -S | FileCheck %s
; RUN: opt < %s -passes='nary-reassociate' -S | FileCheck %s

declare i32 @llvm.smax.i32(i32 %a, i32 %b)
declare i64 @llvm.umin.i64(i64, i64) 

; This is a negative test. We should not optimize if intermediate result
; has a use outside of optimizable pattern. In other words %smax2 has one
; use from %smax3 and side use from %res2.
define i32 @smax_test1(i32 %a, i32 %b, i32 %c) {
; CHECK-LABEL: @smax_test1(
; CHECK-NEXT:    [[C1:%.*]] = icmp sgt i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[SMAX1:%.*]] = select i1 [[C1]], i32 [[A]], i32 [[B]]
; CHECK-NEXT:    [[C2:%.*]] = icmp sgt i32 [[B]], [[C:%.*]]
; CHECK-NEXT:    [[SMAX2:%.*]] = select i1 [[C2]], i32 [[B]], i32 [[C]]
; CHECK-NEXT:    [[C3:%.*]] = icmp sgt i32 [[SMAX2]], [[A]]
; CHECK-NEXT:    [[SMAX3:%.*]] = select i1 [[C3]], i32 [[SMAX2]], i32 [[A]]
; CHECK-NEXT:    [[RES:%.*]] = add i32 [[SMAX1]], [[SMAX3]]
; CHECK-NEXT:    [[RES2:%.*]] = add i32 [[RES]], [[SMAX2]]
; CHECK-NEXT:    ret i32 [[RES]]
;
  %c1 = icmp sgt i32 %a, %b
  %smax1 = select i1 %c1, i32 %a, i32 %b
  %c2 = icmp sgt i32 %b, %c
  %smax2 = select i1 %c2, i32 %b, i32 %c
  %c3 = icmp sgt i32 %smax2, %a
  %smax3 = select i1 %c3, i32 %smax2, i32 %a
  %res = add i32 %smax1, %smax3
  %res2 = add i32 %res, %smax2
  ret i32 %res
}

; This is a negative test. It similar to the previous one
; but a bit more complex. In particular after first iteration
; e10 is replaced with %e10.nary = call i64 @llvm.umin.i64(i64 %e5, i64 %e).
; No more reassociation should be applied to %e10.nary since
; %e5 has side use in %e6.
define void @test2(i64 %arg) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[E:%.*]] = sub i64 undef, 0
; CHECK-NEXT:    [[E1:%.*]] = sub i64 [[ARG:%.*]], 0
; CHECK-NEXT:    [[E2:%.*]] = call i64 @llvm.umin.i64(i64 [[E]], i64 [[E1]])
; CHECK-NEXT:    [[E3:%.*]] = call i64 @llvm.umin.i64(i64 [[E2]], i64 16384)
; CHECK-NEXT:    [[E4:%.*]] = sub i64 [[ARG]], 0
; CHECK-NEXT:    [[E5:%.*]] = call i64 @llvm.umin.i64(i64 [[E4]], i64 16384)
; CHECK-NEXT:    [[E6:%.*]] = icmp ugt i64 [[E5]], 0
; CHECK-NEXT:    [[E10_NARY:%.*]] = call i64 @llvm.umin.i64(i64 [[E5]], i64 [[E]])
; CHECK-NEXT:    unreachable
;
bb:
  %e = sub i64 undef, 0
  %e1 = sub i64 %arg, 0
  %e2 = call i64 @llvm.umin.i64(i64 %e, i64 %e1)
  %e3 = call i64 @llvm.umin.i64(i64 %e2, i64 16384)
  %e4 = sub i64 %arg, 0
  %e5 = call i64 @llvm.umin.i64(i64 %e4, i64 16384)
  %e6 = icmp ugt i64 %e5, 0
  %e7 = sub i64 undef, 0
  %e8 = sub i64 %arg, 0
  %e9 = call i64 @llvm.umin.i64(i64 %e7, i64 %e8)
  %e10 = call i64 @llvm.umin.i64(i64 %e9, i64 16384)
  unreachable
}

