; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
 ; RUN: opt < %s -analyze -enable-new-pm=0 -scalar-evolution | FileCheck %s
 ; RUN: opt < %s -disable-output "-passes=print<scalar-evolution>" 2>&1 | FileCheck %s


; Collection of cases exercising range logic, mostly (but not exclusively)
; involving SCEVUnknowns.

declare void @llvm.assume(i1)

define i32 @ashr(i32 %a) {
; CHECK-LABEL: 'ashr'
; CHECK-NEXT:  Classifying expressions for: @ashr
; CHECK-NEXT:    %ashr = ashr i32 %a, 31
; CHECK-NEXT:    --> %ashr U: [0,1) S: [0,1)
; CHECK-NEXT:  Determining loop execution counts for: @ashr
;
  %pos = icmp sge i32 %a, 0
  call void @llvm.assume(i1 %pos)
  %ashr = ashr i32 %a, 31
  ret i32 %ashr
}

define i32 @shl(i32 %a) {
; CHECK-LABEL: 'shl'
; CHECK-NEXT:  Classifying expressions for: @shl
; CHECK-NEXT:    %res = shl i32 %a, 2
; CHECK-NEXT:    --> (4 * %a) U: [0,-3) S: [-2147483648,2147483645)
; CHECK-NEXT:  Determining loop execution counts for: @shl
;
  %pos = icmp slt i32 %a, 1024
  call void @llvm.assume(i1 %pos)
  %res = shl i32 %a, 2
  ret i32 %res
}

define i32 @lshr(i32 %a) {
; CHECK-LABEL: 'lshr'
; CHECK-NEXT:  Classifying expressions for: @lshr
; CHECK-NEXT:    %res = lshr i32 %a, 31
; CHECK-NEXT:    --> (%a /u -2147483648) U: [0,2) S: [0,2)
; CHECK-NEXT:  Determining loop execution counts for: @lshr
;
  %pos = icmp sge i32 %a, 0
  call void @llvm.assume(i1 %pos)
  %res = lshr i32 %a, 31
  ret i32 %res
}


define i32 @udiv(i32 %a) {
; CHECK-LABEL: 'udiv'
; CHECK-NEXT:  Classifying expressions for: @udiv
; CHECK-NEXT:    %res = udiv i32 %a, -2147483648
; CHECK-NEXT:    --> (%a /u -2147483648) U: [0,2) S: [0,2)
; CHECK-NEXT:  Determining loop execution counts for: @udiv
;
  %pos = icmp sge i32 %a, 0
  call void @llvm.assume(i1 %pos)
  %res = udiv i32 %a, 2147483648
  ret i32 %res
}

define i64 @sext(i32 %a) {
; CHECK-LABEL: 'sext'
; CHECK-NEXT:  Classifying expressions for: @sext
; CHECK-NEXT:    %res = sext i32 %a to i64
; CHECK-NEXT:    --> (sext i32 %a to i64) U: [-2147483648,2147483648) S: [-2147483648,2147483648)
; CHECK-NEXT:  Determining loop execution counts for: @sext
;
  %pos = icmp sge i32 %a, 0
  call void @llvm.assume(i1 %pos)
  %res = sext i32 %a to i64
  ret i64 %res
}

define i64 @zext(i32 %a) {
; CHECK-LABEL: 'zext'
; CHECK-NEXT:  Classifying expressions for: @zext
; CHECK-NEXT:    %res = zext i32 %a to i64
; CHECK-NEXT:    --> (zext i32 %a to i64) U: [0,4294967296) S: [0,4294967296)
; CHECK-NEXT:  Determining loop execution counts for: @zext
;
  %pos = icmp sge i32 %a, 0
  call void @llvm.assume(i1 %pos)
  %res = zext i32 %a to i64
  ret i64 %res
}
