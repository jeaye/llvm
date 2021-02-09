; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; REQUIRES: asserts

; RUN: opt < %s -instcombine --debug-counter=assume-queries-counter-skip=0,assume-queries-counter-count=1 -S | FileCheck %s --check-prefixes=COUNTER1
; RUN: opt < %s -instcombine --debug-counter=assume-queries-counter-skip=1,assume-queries-counter-count=2 -S | FileCheck %s --check-prefixes=COUNTER2
; RUN: opt < %s -instcombine --debug-counter=assume-queries-counter-skip=2,assume-queries-counter-count=5 -S | FileCheck %s --check-prefixes=COUNTER3

declare i1 @get_val()
declare void @llvm.assume(i1)

define dso_local i1 @test1(i32* readonly %0) {
; COUNTER1-LABEL: @test1(
; COUNTER1-NEXT:    call void @llvm.assume(i1 true) [ "nonnull"(i32* [[TMP0:%.*]]) ]
; COUNTER1-NEXT:    ret i1 false
;
; COUNTER2-LABEL: @test1(
; COUNTER2-NEXT:    call void @llvm.assume(i1 true) [ "nonnull"(i32* [[TMP0:%.*]]) ]
; COUNTER2-NEXT:    [[TMP2:%.*]] = icmp eq i32* [[TMP0]], null
; COUNTER2-NEXT:    ret i1 [[TMP2]]
;
; COUNTER3-LABEL: @test1(
; COUNTER3-NEXT:    call void @llvm.assume(i1 true) [ "nonnull"(i32* [[TMP0:%.*]]) ]
; COUNTER3-NEXT:    [[TMP2:%.*]] = icmp eq i32* [[TMP0]], null
; COUNTER3-NEXT:    ret i1 [[TMP2]]
;
  call void @llvm.assume(i1 true) ["nonnull"(i32* %0)]
  %2 = icmp eq i32* %0, null
  ret i1 %2
}

define dso_local i1 @test2(i32* readonly %0) {
; COUNTER1-LABEL: @test2(
; COUNTER1-NEXT:    [[TMP2:%.*]] = icmp eq i32* [[TMP0:%.*]], null
; COUNTER1-NEXT:    call void @llvm.assume(i1 true) [ "nonnull"(i32* [[TMP0]]) ]
; COUNTER1-NEXT:    ret i1 [[TMP2]]
;
; COUNTER2-LABEL: @test2(
; COUNTER2-NEXT:    [[TMP2:%.*]] = icmp eq i32* [[TMP0:%.*]], null
; COUNTER2-NEXT:    call void @llvm.assume(i1 true) [ "nonnull"(i32* [[TMP0]]) ]
; COUNTER2-NEXT:    ret i1 [[TMP2]]
;
; COUNTER3-LABEL: @test2(
; COUNTER3-NEXT:    call void @llvm.assume(i1 true) [ "nonnull"(i32* [[TMP0:%.*]]) ]
; COUNTER3-NEXT:    ret i1 false
;
  %2 = icmp eq i32* %0, null
  call void @llvm.assume(i1 true) ["nonnull"(i32* %0)]
  ret i1 %2
}

define dso_local i32 @test4(i32* readonly %0, i1 %cond) {
; COUNTER1-LABEL: @test4(
; COUNTER1-NEXT:    call void @llvm.assume(i1 true) [ "dereferenceable"(i32* [[TMP0:%.*]], i32 4) ]
; COUNTER1-NEXT:    br i1 [[COND:%.*]], label [[A:%.*]], label [[B:%.*]]
; COUNTER1:       B:
; COUNTER1-NEXT:    br label [[A]]
; COUNTER1:       A:
; COUNTER1-NEXT:    [[TMP2:%.*]] = icmp eq i32* [[TMP0]], null
; COUNTER1-NEXT:    br i1 [[TMP2]], label [[TMP5:%.*]], label [[TMP3:%.*]]
; COUNTER1:       3:
; COUNTER1-NEXT:    [[TMP4:%.*]] = load i32, i32* [[TMP0]], align 4
; COUNTER1-NEXT:    br label [[TMP5]]
; COUNTER1:       5:
; COUNTER1-NEXT:    [[TMP6:%.*]] = phi i32 [ [[TMP4]], [[TMP3]] ], [ 0, [[A]] ]
; COUNTER1-NEXT:    ret i32 [[TMP6]]
;
; COUNTER2-LABEL: @test4(
; COUNTER2-NEXT:    call void @llvm.assume(i1 true) [ "dereferenceable"(i32* [[TMP0:%.*]], i32 4) ]
; COUNTER2-NEXT:    br i1 [[COND:%.*]], label [[A:%.*]], label [[B:%.*]]
; COUNTER2:       B:
; COUNTER2-NEXT:    br label [[A]]
; COUNTER2:       A:
; COUNTER2-NEXT:    [[TMP2:%.*]] = icmp eq i32* [[TMP0]], null
; COUNTER2-NEXT:    br i1 [[TMP2]], label [[TMP5:%.*]], label [[TMP3:%.*]]
; COUNTER2:       3:
; COUNTER2-NEXT:    [[TMP4:%.*]] = load i32, i32* [[TMP0]], align 4
; COUNTER2-NEXT:    br label [[TMP5]]
; COUNTER2:       5:
; COUNTER2-NEXT:    [[TMP6:%.*]] = phi i32 [ [[TMP4]], [[TMP3]] ], [ 0, [[A]] ]
; COUNTER2-NEXT:    ret i32 [[TMP6]]
;
; COUNTER3-LABEL: @test4(
; COUNTER3-NEXT:    call void @llvm.assume(i1 true) [ "dereferenceable"(i32* [[TMP0:%.*]], i32 4) ]
; COUNTER3-NEXT:    br i1 [[COND:%.*]], label [[A:%.*]], label [[B:%.*]]
; COUNTER3:       B:
; COUNTER3-NEXT:    br label [[A]]
; COUNTER3:       A:
; COUNTER3-NEXT:    br i1 false, label [[TMP4:%.*]], label [[TMP2:%.*]]
; COUNTER3:       2:
; COUNTER3-NEXT:    [[TMP3:%.*]] = load i32, i32* [[TMP0]], align 4
; COUNTER3-NEXT:    br label [[TMP4]]
; COUNTER3:       4:
; COUNTER3-NEXT:    [[TMP5:%.*]] = phi i32 [ [[TMP3]], [[TMP2]] ], [ 0, [[A]] ]
; COUNTER3-NEXT:    ret i32 [[TMP5]]
;
  call void @llvm.assume(i1 true) ["dereferenceable"(i32* %0, i32 4)]
  br i1 %cond, label %A, label %B

B:
  br label %A

A:
  %2 = icmp eq i32* %0, null
  br i1 %2, label %5, label %3

3:                                                ; preds = %1
  %4 = load i32, i32* %0, align 4
  br label %5

5:                                                ; preds = %1, %3
  %6 = phi i32 [ %4, %3 ], [ 0, %A ]
  ret i32 %6
}
