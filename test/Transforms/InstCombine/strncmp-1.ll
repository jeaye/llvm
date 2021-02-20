; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; Test that the strncmp library call simplifier works correctly.
; RUN: opt < %s -instcombine -S | FileCheck %s

target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:128:128"

@hello = constant [6 x i8] c"hello\00"
@hell = constant [5 x i8] c"hell\00"
@bell = constant [5 x i8] c"bell\00"
@null = constant [1 x i8] zeroinitializer

declare i32 @strncmp(i8*, i8*, i32)

; strncmp("", x, n) -> -*x
define i32 @test1(i8* %str2) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    [[STRCMPLOAD:%.*]] = load i8, i8* [[STR2:%.*]], align 1
; CHECK-NEXT:    [[TMP1:%.*]] = zext i8 [[STRCMPLOAD]] to i32
; CHECK-NEXT:    [[TMP2:%.*]] = sub nsw i32 0, [[TMP1]]
; CHECK-NEXT:    ret i32 [[TMP2]]
;

  %str1 = getelementptr inbounds [1 x i8], [1 x i8]* @null, i32 0, i32 0
  %temp1 = call i32 @strncmp(i8* %str1, i8* %str2, i32 10)
  ret i32 %temp1
}

; strncmp(x, "", n) -> *x
define i32 @test2(i8* %str1) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[STRCMPLOAD:%.*]] = load i8, i8* [[STR1:%.*]], align 1
; CHECK-NEXT:    [[TMP1:%.*]] = zext i8 [[STRCMPLOAD]] to i32
; CHECK-NEXT:    ret i32 [[TMP1]]
;

  %str2 = getelementptr inbounds [1 x i8], [1 x i8]* @null, i32 0, i32 0
  %temp1 = call i32 @strncmp(i8* %str1, i8* %str2, i32 10)
  ret i32 %temp1
}

; strncmp(x, y, n)  -> cnst
define i32 @test3() {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    ret i32 -1
;

  %str1 = getelementptr inbounds [5 x i8], [5 x i8]* @hell, i32 0, i32 0
  %str2 = getelementptr inbounds [6 x i8], [6 x i8]* @hello, i32 0, i32 0
  %temp1 = call i32 @strncmp(i8* %str1, i8* %str2, i32 10)
  ret i32 %temp1
}

define i32 @test4() {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    ret i32 1
;

  %str1 = getelementptr inbounds [5 x i8], [5 x i8]* @hell, i32 0, i32 0
  %str2 = getelementptr inbounds [1 x i8], [1 x i8]* @null, i32 0, i32 0
  %temp1 = call i32 @strncmp(i8* %str1, i8* %str2, i32 10)
  ret i32 %temp1
}

define i32 @test5() {
; CHECK-LABEL: @test5(
; CHECK-NEXT:    ret i32 0
;

  %str1 = getelementptr inbounds [5 x i8], [5 x i8]* @hell, i32 0, i32 0
  %str2 = getelementptr inbounds [6 x i8], [6 x i8]* @hello, i32 0, i32 0
  %temp1 = call i32 @strncmp(i8* %str1, i8* %str2, i32 4)
  ret i32 %temp1
}

; strncmp(x,y,1) -> memcmp(x,y,1)
define i32 @test6(i8* %str1, i8* %str2) {
; CHECK-LABEL: @test6(
; CHECK-NEXT:    [[LHSC:%.*]] = load i8, i8* [[STR1:%.*]], align 1
; CHECK-NEXT:    [[LHSV:%.*]] = zext i8 [[LHSC]] to i32
; CHECK-NEXT:    [[RHSC:%.*]] = load i8, i8* [[STR2:%.*]], align 1
; CHECK-NEXT:    [[RHSV:%.*]] = zext i8 [[RHSC]] to i32
; CHECK-NEXT:    [[CHARDIFF:%.*]] = sub nsw i32 [[LHSV]], [[RHSV]]
; CHECK-NEXT:    ret i32 [[CHARDIFF]]
;

  %temp1 = call i32 @strncmp(i8* %str1, i8* %str2, i32 1)
  ret i32 %temp1
}

; strncmp(x,y,0)   -> 0
define i32 @test7(i8* %str1, i8* %str2) {
; CHECK-LABEL: @test7(
; CHECK-NEXT:    ret i32 0
;

  %temp1 = call i32 @strncmp(i8* %str1, i8* %str2, i32 0)
  ret i32 %temp1
}

; strncmp(x,x,n)  -> 0
define i32 @test8(i8* %str, i32 %n) {
; CHECK-LABEL: @test8(
; CHECK-NEXT:    ret i32 0
;

  %temp1 = call i32 @strncmp(i8* %str, i8* %str, i32 %n)
  ret i32 %temp1
}

; strncmp(nonnull x, nonnull y, n)  -> strncmp(x, y, n)
define i32 @test9(i8* %str1, i8* %str2, i32 %n) {
; CHECK-LABEL: @test9(
; CHECK-NEXT:    [[TEMP1:%.*]] = call i32 @strncmp(i8* nonnull [[STR1:%.*]], i8* nonnull [[STR2:%.*]], i32 [[N:%.*]])
; CHECK-NEXT:    ret i32 [[TEMP1]]
;

  %temp1 = call i32 @strncmp(i8* nonnull %str1, i8* nonnull %str2, i32 %n)
  ret i32 %temp1
}

; strncmp(nonnull x, nonnull y, 0)  -> 0
define i32 @test10(i8* %str1, i8* %str2, i32 %n) {
; CHECK-LABEL: @test10(
; CHECK-NEXT:    ret i32 0
;

  %temp1 = call i32 @strncmp(i8* nonnull %str1, i8* nonnull %str2, i32 0)
  ret i32 %temp1
}

; strncmp(x, y, 5)  -> strncmp(nonnull x, nonnull y, 5)
define i32 @test11(i8* %str1, i8* %str2, i32 %n) {
; CHECK-LABEL: @test11(
; CHECK-NEXT:    [[TEMP1:%.*]] = call i32 @strncmp(i8* nonnull dereferenceable(1) [[STR1:%.*]], i8* nonnull dereferenceable(1) [[STR2:%.*]], i32 5)
; CHECK-NEXT:    ret i32 [[TEMP1]]
;

  %temp1 = call i32 @strncmp(i8* %str1, i8* %str2, i32 5)
  ret i32 %temp1
}

define i32 @test12(i8* %str1, i8* %str2, i32 %n) null_pointer_is_valid {
; CHECK-LABEL: @test12(
; CHECK-NEXT:    [[TEMP1:%.*]] = call i32 @strncmp(i8* [[STR1:%.*]], i8* [[STR2:%.*]], i32 [[N:%.*]])
; CHECK-NEXT:    ret i32 [[TEMP1]]
;

  %temp1 = call i32 @strncmp(i8* %str1, i8* %str2, i32 %n)
  ret i32 %temp1
}
