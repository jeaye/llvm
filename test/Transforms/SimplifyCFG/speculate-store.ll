; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -simplifycfg -simplifycfg-require-and-preserve-domtree=1 -S < %s | FileCheck %s

define void @ifconvertstore(i32* %A, i32 %B, i32 %C, i32 %D) {
; CHECK-LABEL: @ifconvertstore(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store i32 [[B:%.*]], i32* [[A:%.*]], align 4
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i32 [[D:%.*]], 42
; CHECK-NEXT:    [[SPEC_STORE_SELECT:%.*]] = select i1 [[CMP]], i32 [[C:%.*]], i32 [[B]], !prof [[PROF0:![0-9]+]]
; CHECK-NEXT:    store i32 [[SPEC_STORE_SELECT]], i32* [[A]], align 4
; CHECK-NEXT:    ret void
;
entry:
; First store to the location.
  store i32 %B, i32* %A
  %cmp = icmp sgt i32 %D, 42
  br i1 %cmp, label %if.then, label %ret.end, !prof !0

; Make sure we speculate stores like the following one. It is cheap compared to
; a mispredicated branch.
if.then:
  store i32 %C, i32* %A
  br label %ret.end

ret.end:
  ret void
}

; Store to a different location.

define void @noifconvertstore1(i32* %A1, i32* %A2, i32 %B, i32 %C, i32 %D) {
; CHECK-LABEL: @noifconvertstore1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store i32 [[B:%.*]], i32* [[A1:%.*]], align 4
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i32 [[D:%.*]], 42
; CHECK-NEXT:    br i1 [[CMP]], label [[IF_THEN:%.*]], label [[RET_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    store i32 [[C:%.*]], i32* [[A2:%.*]], align 4
; CHECK-NEXT:    br label [[RET_END]]
; CHECK:       ret.end:
; CHECK-NEXT:    ret void
;
entry:
  store i32 %B, i32* %A1
  %cmp = icmp sgt i32 %D, 42
  br i1 %cmp, label %if.then, label %ret.end

if.then:
  store i32 %C, i32* %A2
  br label %ret.end

ret.end:
  ret void
}

; This function could store to our address, so we can't repeat the first store a second time.
declare void @unknown_fun()

define void @noifconvertstore2(i32* %A, i32 %B, i32 %C, i32 %D) {
; CHECK-LABEL: @noifconvertstore2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store i32 [[B:%.*]], i32* [[A:%.*]], align 4
; CHECK-NEXT:    call void @unknown_fun()
; CHECK-NEXT:    [[CMP6:%.*]] = icmp sgt i32 [[D:%.*]], 42
; CHECK-NEXT:    br i1 [[CMP6]], label [[IF_THEN:%.*]], label [[RET_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    store i32 [[C:%.*]], i32* [[A]], align 4
; CHECK-NEXT:    br label [[RET_END]]
; CHECK:       ret.end:
; CHECK-NEXT:    ret void
;
entry:
; First store to the location.
  store i32 %B, i32* %A
  call void @unknown_fun()
  %cmp6 = icmp sgt i32 %D, 42
  br i1 %cmp6, label %if.then, label %ret.end

if.then:
  store i32 %C, i32* %A
  br label %ret.end

ret.end:
  ret void
}

; Make sure we don't speculate volatile stores.

define void @noifconvertstore_volatile(i32* %A, i32 %B, i32 %C, i32 %D) {
; CHECK-LABEL: @noifconvertstore_volatile(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store i32 [[B:%.*]], i32* [[A:%.*]], align 4
; CHECK-NEXT:    [[CMP6:%.*]] = icmp sgt i32 [[D:%.*]], 42
; CHECK-NEXT:    br i1 [[CMP6]], label [[IF_THEN:%.*]], label [[RET_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    store volatile i32 [[C:%.*]], i32* [[A]], align 4
; CHECK-NEXT:    br label [[RET_END]]
; CHECK:       ret.end:
; CHECK-NEXT:    ret void
;
entry:
; First store to the location.
  store i32 %B, i32* %A
  %cmp6 = icmp sgt i32 %D, 42
  br i1 %cmp6, label %if.then, label %ret.end

if.then:
  store volatile i32 %C, i32* %A
  br label %ret.end

ret.end:
  ret void
}

define void @different_type(ptr %ptr, i1 %cmp) {
; CHECK-LABEL: @different_type(
; CHECK-NEXT:    store i32 0, ptr [[PTR:%.*]], align 4
; CHECK-NEXT:    br i1 [[CMP:%.*]], label [[IF_THEN:%.*]], label [[RET_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    store i64 1, ptr [[PTR]], align 4
; CHECK-NEXT:    br label [[RET_END]]
; CHECK:       ret.end:
; CHECK-NEXT:    ret void
;
  store i32 0, ptr %ptr
  br i1 %cmp, label %if.then, label %ret.end

if.then:
  store i64 1, ptr %ptr
  br label %ret.end

ret.end:
  ret void
}

; CHECK: !0 = !{!"branch_weights", i32 3, i32 5}
!0 = !{!"branch_weights", i32 3, i32 5}

