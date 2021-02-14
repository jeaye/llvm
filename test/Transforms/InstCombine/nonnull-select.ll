; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

; Passing select(cond, null, v) as nonnull should be optimized to passing v

define nonnull i32* @pr48975(i32** %.0) {
; CHECK-LABEL: @pr48975(
; CHECK-NEXT:    [[DOT1:%.*]] = load i32*, i32** [[DOT0:%.*]], align 8
; CHECK-NEXT:    [[DOT2:%.*]] = icmp eq i32* [[DOT1]], null
; CHECK-NEXT:    [[DOT3:%.*]] = bitcast i32** [[DOT0]] to i32*
; CHECK-NEXT:    [[DOT4:%.*]] = select i1 [[DOT2]], i32* null, i32* [[DOT3]]
; CHECK-NEXT:    ret i32* [[DOT4]]
;
  %.1 = load i32*, i32** %.0, align 8
  %.2 = icmp eq i32* %.1, null
  %.3 = bitcast i32** %.0 to i32*
  %.4 = select i1 %.2, i32* null, i32* %.3
  ret i32* %.4
}

define nonnull i32* @nonnull_ret(i1 %cond, i32* %p) {
; CHECK-LABEL: @nonnull_ret(
; CHECK-NEXT:    [[RES:%.*]] = select i1 [[COND:%.*]], i32* [[P:%.*]], i32* null
; CHECK-NEXT:    ret i32* [[RES]]
;
  %res = select i1 %cond, i32* %p, i32* null
  ret i32* %res
}

define void @nonnull_call(i1 %cond, i32* %p) {
; CHECK-LABEL: @nonnull_call(
; CHECK-NEXT:    [[RES:%.*]] = select i1 [[COND:%.*]], i32* null, i32* [[P:%.*]]
; CHECK-NEXT:    call void @f(i32* nonnull [[RES]])
; CHECK-NEXT:    ret void
;
  %res = select i1 %cond, i32* null, i32* %p
  call void @f(i32* nonnull %res)
  ret void
}

declare void @f(i32*)
