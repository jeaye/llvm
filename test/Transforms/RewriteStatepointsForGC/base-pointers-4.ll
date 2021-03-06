; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -rewrite-statepoints-for-gc -S 2>&1 | FileCheck %s
; RUN: opt < %s -passes=rewrite-statepoints-for-gc -S 2>&1 | FileCheck %s

declare void @foo()

declare i64 addrspace(1)* @generate_obj()

declare void @consume_obj(i64 addrspace(1)*)

; derived %obj_to_consume base %obj_to_consume.base
define void @test(i32 %condition) gc "statepoint-example" {
; CHECK-LABEL: @test(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[STATEPOINT_TOKEN:%.*]] = call token (i64, i32, i64 addrspace(1)* ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_p1i64f(i64 2882400000, i32 0, i64 addrspace(1)* ()* @generate_obj, i32 0, i32 0, i32 0, i32 0) [ "deopt"(i32 0, i32 -1, i32 0, i32 0, i32 0) ]
; CHECK-NEXT:    [[TMP0:%.*]] = call i64 addrspace(1)* @llvm.experimental.gc.result.p1i64(token [[STATEPOINT_TOKEN]])
; CHECK-NEXT:    switch i32 [[CONDITION:%.*]], label [[DEST_A:%.*]] [
; CHECK-NEXT:    i32 0, label [[DEST_B:%.*]]
; CHECK-NEXT:    i32 1, label [[DEST_C:%.*]]
; CHECK-NEXT:    ]
; CHECK:       dest_a:
; CHECK-NEXT:    br label [[MERGE:%.*]]
; CHECK:       dest_b:
; CHECK-NEXT:    br label [[MERGE]]
; CHECK:       dest_c:
; CHECK-NEXT:    br label [[MERGE]]
; CHECK:       merge:
; CHECK-NEXT:    [[OBJ_TO_CONSUME_BASE:%.*]] = phi i64 addrspace(1)* [ [[TMP0]], [[DEST_A]] ], [ null, [[DEST_B]] ], [ null, [[DEST_C]] ], !is_base_value !0
; CHECK-NEXT:    [[OBJ_TO_CONSUME:%.*]] = phi i64 addrspace(1)* [ [[TMP0]], [[DEST_A]] ], [ null, [[DEST_B]] ], [ null, [[DEST_C]] ]
; CHECK-NEXT:    [[STATEPOINT_TOKEN1:%.*]] = call token (i64, i32, void (i64 addrspace(1)*)*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidp1i64f(i64 2882400000, i32 0, void (i64 addrspace(1)*)* @consume_obj, i32 1, i32 0, i64 addrspace(1)* [[OBJ_TO_CONSUME]], i32 0, i32 0) [ "deopt"(i32 0, i32 -1, i32 0, i32 0, i32 0), "gc-live"(i64 addrspace(1)* [[OBJ_TO_CONSUME_BASE]], i64 addrspace(1)* [[OBJ_TO_CONSUME]]) ]
; CHECK-NEXT:    [[OBJ_TO_CONSUME_BASE_RELOCATED:%.*]] = call coldcc i8 addrspace(1)* @llvm.experimental.gc.relocate.p1i8(token [[STATEPOINT_TOKEN1]], i32 0, i32 0)
; CHECK-NEXT:    [[OBJ_TO_CONSUME_BASE_RELOCATED_CASTED:%.*]] = bitcast i8 addrspace(1)* [[OBJ_TO_CONSUME_BASE_RELOCATED]] to i64 addrspace(1)*
; CHECK-NEXT:    [[OBJ_TO_CONSUME_RELOCATED:%.*]] = call coldcc i8 addrspace(1)* @llvm.experimental.gc.relocate.p1i8(token [[STATEPOINT_TOKEN1]], i32 0, i32 1)
; CHECK-NEXT:    [[OBJ_TO_CONSUME_RELOCATED_CASTED:%.*]] = bitcast i8 addrspace(1)* [[OBJ_TO_CONSUME_RELOCATED]] to i64 addrspace(1)*
; CHECK-NEXT:    br label [[MERGE_SPLIT:%.*]]
; CHECK:       merge.split:
; CHECK-NEXT:    [[STATEPOINT_TOKEN2:%.*]] = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @foo, i32 0, i32 0, i32 0, i32 0) [ "deopt"(i32 0, i32 -1, i32 0, i32 0, i32 0) ]
; CHECK-NEXT:    br label [[LOOP]]
;
entry:
  br label %loop

loop:                                             ; preds = %merge.split, %entry
  %0 = call i64 addrspace(1)* @generate_obj() [ "deopt"(i32 0, i32 -1, i32 0, i32 0, i32 0) ]
  switch i32 %condition, label %dest_a [
  i32 0, label %dest_b
  i32 1, label %dest_c
  ]

dest_a:                                           ; preds = %loop
  br label %merge

dest_b:                                           ; preds = %loop
  br label %merge

dest_c:                                           ; preds = %loop
  br label %merge

merge:                                            ; preds = %dest_c, %dest_b, %dest_a
  %obj_to_consume = phi i64 addrspace(1)* [ %0, %dest_a ], [ null, %dest_b ], [ null, %dest_c ]
  call void @consume_obj(i64 addrspace(1)* %obj_to_consume) [ "deopt"(i32 0, i32 -1, i32 0, i32 0, i32 0) ]
  br label %merge.split

merge.split:                                      ; preds = %merge
  call void @foo() [ "deopt"(i32 0, i32 -1, i32 0, i32 0, i32 0) ]
  br label %loop
}
