; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -slp-vectorizer < %s | FileCheck %s

define void @main() {
; CHECK-LABEL: @main(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load <2 x i64>, <2 x i64>* undef, align 16
; CHECK-NEXT:    [[VEC_0_VEC_EXTRACT_I:%.*]] = extractelement <2 x i64> [[TMP0]], i32 0
; CHECK-NEXT:    [[ADD_I:%.*]] = add i64 [[VEC_0_VEC_EXTRACT_I]], 1
; CHECK-NEXT:    [[VEC_0_VEC_INSERT_I:%.*]] = insertelement <2 x i64> [[TMP0]], i64 [[ADD_I]], i32 0
; CHECK-NEXT:    [[CMP_I:%.*]] = icmp eq i64 [[ADD_I]], 0
; CHECK-NEXT:    [[VEC_8_VEC_EXTRACT_I:%.*]] = extractelement <2 x i64> [[TMP0]], i32 1
; CHECK-NEXT:    [[INC_I:%.*]] = add i64 [[VEC_8_VEC_EXTRACT_I]], 1
; CHECK-NEXT:    [[VEC_8_VEC_INSERT_I:%.*]] = insertelement <2 x i64> [[VEC_0_VEC_INSERT_I]], i64 [[INC_I]], i32 1
; CHECK-NEXT:    [[VEC_0_I:%.*]] = select i1 [[CMP_I]], <2 x i64> [[VEC_8_VEC_INSERT_I]], <2 x i64> [[VEC_0_VEC_INSERT_I]]
; CHECK-NEXT:    ret void
;
entry:
  %0 = load <2 x i64>, <2 x i64>* undef, align 16
  %vec.0.vec.extract.i = extractelement <2 x i64> %0, i32 0
  %add.i = add i64 %vec.0.vec.extract.i, 1
  %vec.0.vec.insert.i = insertelement <2 x i64> %0, i64 %add.i, i32 0
  %cmp.i = icmp eq i64 %add.i, 0
  %vec.8.vec.extract.i = extractelement <2 x i64> %0, i32 1
  %inc.i = add i64 %vec.8.vec.extract.i, 1
  %vec.8.vec.insert.i = insertelement <2 x i64> %vec.0.vec.insert.i, i64 %inc.i, i32 1
  %vec.0.i = select i1 %cmp.i, <2 x i64> %vec.8.vec.insert.i, <2 x i64> %vec.0.vec.insert.i
  ret void
}

