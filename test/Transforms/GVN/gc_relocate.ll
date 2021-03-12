; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -basic-aa -gvn -S < %s | FileCheck %s

declare void @func()
declare i32 @"personality_function"()

define i1 @test_trivial(i32 addrspace(1)* %in) gc "statepoint-example" {
; CHECK-LABEL: @test_trivial(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SAFEPOINT_TOKEN:%.*]] = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 0, i32 0, void ()* @func, i32 0, i32 0, i32 0, i32 0) [ "gc-live"(i32 addrspace(1)* [[IN:%.*]]) ]
; CHECK-NEXT:    [[A:%.*]] = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token [[SAFEPOINT_TOKEN]], i32 0, i32 0)
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i32 addrspace(1)* [[A]], null
; CHECK-NEXT:    ret i1 [[CMP1]]
;
entry:
  %safepoint_token = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 0, i32 0, void ()* @func, i32 0, i32 0, i32 0, i32 0) ["gc-live"(i32 addrspace(1)* %in)]
  %a = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token %safepoint_token,  i32 0, i32 0)
  %b = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token %safepoint_token,  i32 0, i32 0)
  %cmp1 = icmp eq i32 addrspace(1)* %a, null
  %cmp2 = icmp eq i32 addrspace(1)* %b, null
  %cmp = and i1 %cmp1, %cmp2
  ret i1 %cmp
}

@G = external global i32

define i1 @test_readnone(i32 addrspace(1)* %in) gc "statepoint-example" {
; CHECK-LABEL: @test_readnone(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SAFEPOINT_TOKEN:%.*]] = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 0, i32 0, void ()* @func, i32 0, i32 0, i32 0, i32 0) [ "gc-live"(i32 addrspace(1)* [[IN:%.*]]) ]
; CHECK-NEXT:    [[A:%.*]] = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token [[SAFEPOINT_TOKEN]], i32 0, i32 0)
; CHECK-NEXT:    store i32 0, i32* @G, align 4
; CHECK-NEXT:    [[B:%.*]] = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token [[SAFEPOINT_TOKEN]], i32 0, i32 0)
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i32 addrspace(1)* [[A]], null
; CHECK-NEXT:    [[CMP2:%.*]] = icmp eq i32 addrspace(1)* [[B]], null
; CHECK-NEXT:    [[CMP:%.*]] = and i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
entry:
  %safepoint_token = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 0, i32 0, void ()* @func, i32 0, i32 0, i32 0, i32 0) ["gc-live"(i32 addrspace(1)* %in)]
  %a = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token %safepoint_token,  i32 0, i32 0)
  store i32 0, i32* @G
  %b = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token %safepoint_token,  i32 0, i32 0)
  %cmp1 = icmp eq i32 addrspace(1)* %a, null
  %cmp2 = icmp eq i32 addrspace(1)* %b, null
  %cmp = and i1 %cmp1, %cmp2
  ret i1 %cmp
}

define i1 @test_call(i32 addrspace(1)* %in) gc "statepoint-example" {
; CHECK-LABEL: @test_call(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SAFEPOINT_TOKEN:%.*]] = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 0, i32 0, void ()* @func, i32 0, i32 0, i32 0, i32 0) [ "gc-live"(i32 addrspace(1)* [[IN:%.*]], i32 addrspace(1)* [[IN]]) ]
; CHECK-NEXT:    [[BASE:%.*]] = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token [[SAFEPOINT_TOKEN]], i32 0, i32 0)
; CHECK-NEXT:    [[DERIVED:%.*]] = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token [[SAFEPOINT_TOKEN]], i32 0, i32 1)
; CHECK-NEXT:    [[SAFEPOINT_TOKEN2:%.*]] = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 0, i32 0, void ()* @func, i32 0, i32 0, i32 0, i32 0) [ "gc-live"(i32 addrspace(1)* [[BASE]], i32 addrspace(1)* [[DERIVED]]) ]
; CHECK-NEXT:    [[BASE_RELOC:%.*]] = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token [[SAFEPOINT_TOKEN2]], i32 0, i32 0)
; CHECK-NEXT:    [[DERIVED_RELOC:%.*]] = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token [[SAFEPOINT_TOKEN2]], i32 0, i32 1)
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i32 addrspace(1)* [[BASE_RELOC]], null
; CHECK-NEXT:    [[CMP2:%.*]] = icmp eq i32 addrspace(1)* [[DERIVED_RELOC]], null
; CHECK-NEXT:    [[CMP:%.*]] = and i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
entry:
  %safepoint_token = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 0, i32 0, void ()* @func, i32 0, i32 0, i32 0, i32 0) ["gc-live"(i32 addrspace(1)* %in, i32 addrspace(1)* %in)]
  %base = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token %safepoint_token,  i32 0, i32 0)
  %derived = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token %safepoint_token,  i32 0, i32 1)
  %safepoint_token2 = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 0, i32 0, void ()* @func, i32 0, i32 0, i32 0, i32 0) ["gc-live"(i32 addrspace(1)* %base, i32 addrspace(1)* %derived)]
  br label %next

next:
  %base_reloc = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token %safepoint_token2,  i32 0, i32 0)
  %derived_reloc = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token %safepoint_token2,  i32 0, i32 1)
  %cmp1 = icmp eq i32 addrspace(1)* %base_reloc, null
  %cmp2 = icmp eq i32 addrspace(1)* %derived_reloc, null
  %cmp = and i1 %cmp1, %cmp2
  ret i1 %cmp
}

; Negative test: Check that relocates from different statepoints are not CSE'd
define i1 @test_two_calls(i32 addrspace(1)* %in1, i32 addrspace(1)* %in2) gc "statepoint-example" {
; CHECK-LABEL: @test_two_calls(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SAFEPOINT_TOKEN:%.*]] = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 0, i32 0, void ()* @func, i32 0, i32 0, i32 0, i32 0) [ "gc-live"(i32 addrspace(1)* [[IN1:%.*]], i32 addrspace(1)* [[IN2:%.*]]) ]
; CHECK-NEXT:    [[IN1_RELOC1:%.*]] = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token [[SAFEPOINT_TOKEN]], i32 0, i32 0)
; CHECK-NEXT:    [[IN2_RELOC1:%.*]] = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token [[SAFEPOINT_TOKEN]], i32 1, i32 1)
; CHECK-NEXT:    [[SAFEPOINT_TOKEN2:%.*]] = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 0, i32 0, void ()* @func, i32 0, i32 0, i32 0, i32 0) [ "gc-live"(i32 addrspace(1)* [[IN1_RELOC1]], i32 addrspace(1)* [[IN2_RELOC1]]) ]
; CHECK-NEXT:    [[IN1_RELOC2:%.*]] = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token [[SAFEPOINT_TOKEN2]], i32 0, i32 1)
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i32 addrspace(1)* [[IN1_RELOC2]], null
; CHECK-NEXT:    ret i1 [[CMP1]]
;
entry:
  %safepoint_token = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 0, i32 0, void ()* @func, i32 0, i32 0, i32 0, i32 0) ["gc-live"(i32 addrspace(1)* %in1, i32 addrspace(1)* %in2)]
  %in1.reloc1 = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token %safepoint_token,  i32 0, i32 0)
  %in2.reloc1 = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token %safepoint_token,  i32 1, i32 1)
  %safepoint_token2 = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 0, i32 0, void ()* @func, i32 0, i32 0, i32 0, i32 0) ["gc-live"(i32 addrspace(1)* %in1.reloc1, i32 addrspace(1)* %in2.reloc1)]
  %in1.reloc2 = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token %safepoint_token2,  i32 0, i32 1)
  %in2.reloc2 = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token %safepoint_token2,  i32 0, i32 1)
  %cmp1 = icmp eq i32 addrspace(1)* %in1.reloc2, null
  %cmp2 = icmp eq i32 addrspace(1)* %in2.reloc2, null
  %cmp = and i1 %cmp1, %cmp2
  ret i1 %cmp
}

; Negative test: Check that relocates from normal and exceptional pathes are not be CSE'd
define i32 addrspace(1)* @test_invoke(i32 addrspace(1)* %in) gc "statepoint-example" personality i32 ()* @"personality_function" {
; CHECK-LABEL: @test_invoke(
; CHECK-NEXT:    [[SAFEPOINT_TOKEN:%.*]] = invoke token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 0, i32 0, void ()* @func, i32 0, i32 0, i32 0, i32 0) [ "gc-live"(i32 addrspace(1)* [[IN:%.*]]) ]
; CHECK-NEXT:    to label [[INVOKE_NORMAL_DEST:%.*]] unwind label [[EXCEPTIONAL_RETURN:%.*]]
; CHECK:       invoke_normal_dest:
; CHECK-NEXT:    [[OUT:%.*]] = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token [[SAFEPOINT_TOKEN]], i32 0, i32 0)
; CHECK-NEXT:    ret i32 addrspace(1)* [[OUT]]
; CHECK:       exceptional_return:
; CHECK-NEXT:    [[LANDING_PAD:%.*]] = landingpad token
; CHECK-NEXT:    cleanup
; CHECK-NEXT:    [[OUT1:%.*]] = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token [[LANDING_PAD]], i32 0, i32 0)
; CHECK-NEXT:    ret i32 addrspace(1)* [[OUT1]]
;
  %safepoint_token = invoke token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 0, i32 0, void ()* @func, i32 0, i32 0, i32 0, i32 0) ["gc-live"(i32 addrspace(1)* %in)]
  to label %invoke_normal_dest unwind label %exceptional_return

invoke_normal_dest:
  %out = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token %safepoint_token,  i32 0, i32 0)
  ret i32 addrspace(1)* %out

exceptional_return:
  %landing_pad = landingpad token
  cleanup
  %out1 = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token %landing_pad, i32 0, i32 0)
  ret i32 addrspace(1)* %out1
}

; negative test - neither dominates the other
define i1 @test_non_dominating(i1 %c, i32 addrspace(1)* %in) gc "statepoint-example" {
;
; CHECK-LABEL: @test_non_dominating(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SAFEPOINT_TOKEN:%.*]] = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 0, i32 0, void ()* @func, i32 0, i32 0, i32 0, i32 0) [ "gc-live"(i32 addrspace(1)* [[IN:%.*]]) ]
; CHECK-NEXT:    br i1 [[C:%.*]], label [[TAKEN:%.*]], label [[UNTAKEN:%.*]]
; CHECK:       taken:
; CHECK-NEXT:    [[A:%.*]] = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token [[SAFEPOINT_TOKEN]], i32 0, i32 0)
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 addrspace(1)* [[A]], null
; CHECK-NEXT:    ret i1 [[CMP]]
; CHECK:       untaken:
; CHECK-NEXT:    [[B:%.*]] = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token [[SAFEPOINT_TOKEN]], i32 0, i32 0)
; CHECK-NEXT:    [[CMP2:%.*]] = icmp eq i32 addrspace(1)* [[B]], null
; CHECK-NEXT:    ret i1 [[CMP2]]
;
entry:
  %safepoint_token = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 0, i32 0, void ()* @func, i32 0, i32 0, i32 0, i32 0) ["gc-live"(i32 addrspace(1)* %in)]
  br i1 %c, label %taken, label %untaken
taken:
  %a = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token %safepoint_token,  i32 0, i32 0)
  %cmp = icmp eq i32 addrspace(1)* %a, null
  ret i1 %cmp
untaken:
  %b = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token %safepoint_token,  i32 0, i32 0)
  %cmp2 = icmp eq i32 addrspace(1)* %b, null
  ret i1 %cmp2
}

declare token @llvm.experimental.gc.statepoint.p0f_isVoidf(i64, i32, void ()*, i32, i32, ...)
declare i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token, i32, i32)
