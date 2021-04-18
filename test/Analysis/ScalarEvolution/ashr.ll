; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt < %s --data-layout="e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128" -S -analyze -enable-new-pm=0 -scalar-evolution | FileCheck %s
; RUN: opt < %s --data-layout="e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128" -S -disable-output "-passes=print<scalar-evolution>" 2>&1 | FileCheck %s
; RUN: opt < %s --data-layout="e-m:e-p:32:32-p270:32:32-p271:32:32-p272:64:64-f64:32:64-f80:32-n8:16:32-S128" -S -analyze -enable-new-pm=0 -scalar-evolution | FileCheck %s
; RUN: opt < %s --data-layout="e-m:e-p:32:32-p270:32:32-p271:32:32-p272:64:64-f64:32:64-f80:32-n8:16:32-S128" -S -disable-output "-passes=print<scalar-evolution>" 2>&1 | FileCheck %s

; In general, we can't deal with ashr.
define i32 @t0(i32 %x, i32 %y) {
; CHECK-LABEL: 't0'
; CHECK-NEXT:  Classifying expressions for: @t0
; CHECK-NEXT:    %i0 = ashr i32 %x, %y
; CHECK-NEXT:    --> %i0 U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @t0
;
  %i0 = ashr i32 %x, %y
  ret i32 %i0
}
; Not even if we know it's exact
define i32 @t1(i32 %x, i32 %y) {
; CHECK-LABEL: 't1'
; CHECK-NEXT:  Classifying expressions for: @t1
; CHECK-NEXT:    %i0 = ashr exact i32 %x, %y
; CHECK-NEXT:    --> %i0 U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @t1
;
  %i0 = ashr exact i32 %x, %y
  ret i32 %i0
}
; Not even if the shift amount is a constant.
define i32 @t2(i32 %x, i32 %y) {
; CHECK-LABEL: 't2'
; CHECK-NEXT:  Classifying expressions for: @t2
; CHECK-NEXT:    %i0 = ashr i32 %x, 4
; CHECK-NEXT:    --> %i0 U: [-134217728,134217728) S: [-134217728,134217728)
; CHECK-NEXT:  Determining loop execution counts for: @t2
;
  %i0 = ashr i32 %x, 4
  ret i32 %i0
}
; However, if it's a constant AND the shift is exact, we can model it!
define i32 @t3(i32 %x, i32 %y) {
; CHECK-LABEL: 't3'
; CHECK-NEXT:  Classifying expressions for: @t3
; CHECK-NEXT:    %i0 = ashr exact i32 %x, 4
; CHECK-NEXT:    --> %i0 U: [-134217728,134217728) S: [-134217728,134217728)
; CHECK-NEXT:  Determining loop execution counts for: @t3
;
  %i0 = ashr exact i32 %x, 4
  ret i32 %i0
}
; As long as the shift amount is in-bounds
define i32 @t4(i32 %x, i32 %y) {
; CHECK-LABEL: 't4'
; CHECK-NEXT:  Classifying expressions for: @t4
; CHECK-NEXT:    %i0 = ashr exact i32 %x, 32
; CHECK-NEXT:    --> %i0 U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @t4
;
  %i0 = ashr exact i32 %x, 32
  ret i32 %i0
}

; One more test, just to see that we model constant correctly
define i32 @t5(i32 %x, i32 %y) {
; CHECK-LABEL: 't5'
; CHECK-NEXT:  Classifying expressions for: @t5
; CHECK-NEXT:    %i0 = ashr exact i32 %x, 5
; CHECK-NEXT:    --> %i0 U: [-67108864,67108864) S: [-67108864,67108864)
; CHECK-NEXT:  Determining loop execution counts for: @t5
;
  %i0 = ashr exact i32 %x, 5
  ret i32 %i0
}
