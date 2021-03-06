; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -rewrite-statepoints-for-gc -S 2>&1 | FileCheck %s
; RUN: opt < %s -passes=rewrite-statepoints-for-gc -S 2>&1 | FileCheck %s

@global = external addrspace(1) global i8

define i8 @test(i64 %offset) gc "statepoint-example" {
; CHECK-LABEL: @test(
; CHECK-NEXT:    [[DERIVED:%.*]] = getelementptr i8, i8 addrspace(1)* @global, i64 [[OFFSET:%.*]]
; CHECK-NEXT:    [[STATEPOINT_TOKEN:%.*]] = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @extern, i32 0, i32 0, i32 0, i32 0)
; CHECK-NEXT:    [[LOAD:%.*]] = load i8, i8 addrspace(1)* [[DERIVED]], align 1
; CHECK-NEXT:    ret i8 [[LOAD]]
;
  %derived = getelementptr i8, i8 addrspace(1)* @global, i64 %offset
  call void @extern()
  %load = load i8, i8 addrspace(1)* %derived
  ret i8 %load
}

declare void @extern() gc "statepoint-example"

declare token @llvm.experimental.gc.statepoint.p0f_isVoidf(i64, i32, void ()*, i32, i32, ...)
