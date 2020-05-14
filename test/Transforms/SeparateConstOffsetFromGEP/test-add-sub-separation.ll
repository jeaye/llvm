; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -separate-const-offset-from-gep < %s | FileCheck %s

define void @matchingExtensions(i32* %ap, i32* %bp, i64* %result) {
; CHECK-LABEL: @matchingExtensions(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = load i32, i32* [[AP:%.*]], align 4
; CHECK-NEXT:    [[B:%.*]] = load i32, i32* [[BP:%.*]], align 4
; CHECK-NEXT:    [[EB:%.*]] = sext i32 [[B]] to i64
; CHECK-NEXT:    [[SUBAB:%.*]] = sub nsw i32 [[A]], [[B]]
; CHECK-NEXT:    [[EA:%.*]] = sext i32 [[A]] to i64
; CHECK-NEXT:    [[ADDEAEB:%.*]] = add nsw i64 [[EA]], [[EB]]
; CHECK-NEXT:    [[EXTSUB:%.*]] = sext i32 [[SUBAB]] to i64
; CHECK-NEXT:    [[IDX:%.*]] = getelementptr i32, i32* [[AP]], i64 [[EXTSUB]]
; CHECK-NEXT:    store i64 [[ADDEAEB]], i64* [[RESULT:%.*]]
; CHECK-NEXT:    store i32 [[SUBAB]], i32* [[IDX]]
; CHECK-NEXT:    ret void
;
entry:
  %a = load i32, i32* %ap
  %b = load i32, i32* %bp
  %eb = sext i32 %b to i64
  %subab = sub nsw i32 %a, %b
  %ea = sext i32 %a to i64
  %addeaeb = add nsw i64 %ea, %eb
  %extsub = sext i32 %subab to i64
  %idx = getelementptr i32, i32* %ap, i64 %extsub
  store i64 %addeaeb, i64* %result
  store i32 %subab, i32* %idx
  ret void
}
