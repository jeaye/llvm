; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -O2 -preserve-alignment-assumptions-during-inlining=0 < %s | FileCheck %s --check-prefixes=CHECK,ASSUMPTIONS-OFF,FALLBACK-0
; RUN: opt -S -O2 -preserve-alignment-assumptions-during-inlining=1 < %s | FileCheck %s --check-prefixes=CHECK,ASSUMPTIONS-ON,FALLBACK-1
; RUN: opt -S -O2 < %s | FileCheck %s --check-prefixes=CHECK,ASSUMPTIONS-OFF,FALLBACK-DEFAULT

target datalayout = "e-p:64:64-p5:32:32-A5"

; This illustrates an optimization difference caused by instruction counting
; heuristics, which are affected by the additional instructions of the
; alignment assumption.

define internal i1 @callee1(i1 %c, i64* align 8 %ptr) {
  store volatile i64 0, i64* %ptr
  ret i1 %c
}

define void @caller1(i1 %c, i64* align 1 %ptr) {
; ASSUMPTIONS-OFF-LABEL: @caller1(
; ASSUMPTIONS-OFF-NEXT:    br i1 [[C:%.*]], label [[TRUE2:%.*]], label [[FALSE2:%.*]]
; ASSUMPTIONS-OFF:       true2:
; ASSUMPTIONS-OFF-NEXT:    store volatile i64 0, i64* [[PTR:%.*]], align 8
; ASSUMPTIONS-OFF-NEXT:    store volatile i64 -1, i64* [[PTR]], align 4
; ASSUMPTIONS-OFF-NEXT:    store volatile i64 -1, i64* [[PTR]], align 4
; ASSUMPTIONS-OFF-NEXT:    store volatile i64 -1, i64* [[PTR]], align 4
; ASSUMPTIONS-OFF-NEXT:    store volatile i64 -1, i64* [[PTR]], align 4
; ASSUMPTIONS-OFF-NEXT:    store volatile i64 -1, i64* [[PTR]], align 4
; ASSUMPTIONS-OFF-NEXT:    store volatile i64 2, i64* [[PTR]], align 4
; ASSUMPTIONS-OFF-NEXT:    ret void
; ASSUMPTIONS-OFF:       false2:
; ASSUMPTIONS-OFF-NEXT:    store volatile i64 1, i64* [[PTR]], align 4
; ASSUMPTIONS-OFF-NEXT:    store volatile i64 0, i64* [[PTR]], align 8
; ASSUMPTIONS-OFF-NEXT:    store volatile i64 -1, i64* [[PTR]], align 4
; ASSUMPTIONS-OFF-NEXT:    store volatile i64 -1, i64* [[PTR]], align 4
; ASSUMPTIONS-OFF-NEXT:    store volatile i64 -1, i64* [[PTR]], align 4
; ASSUMPTIONS-OFF-NEXT:    store volatile i64 -1, i64* [[PTR]], align 4
; ASSUMPTIONS-OFF-NEXT:    store volatile i64 -1, i64* [[PTR]], align 4
; ASSUMPTIONS-OFF-NEXT:    store volatile i64 3, i64* [[PTR]], align 4
; ASSUMPTIONS-OFF-NEXT:    ret void
;
; ASSUMPTIONS-ON-LABEL: @caller1(
; ASSUMPTIONS-ON-NEXT:    br i1 [[C:%.*]], label [[TRUE2_CRITEDGE:%.*]], label [[FALSE1:%.*]]
; ASSUMPTIONS-ON:       false1:
; ASSUMPTIONS-ON-NEXT:    store volatile i64 1, i64* [[PTR:%.*]], align 8
; ASSUMPTIONS-ON-NEXT:    call void @llvm.assume(i1 true) [ "align"(i64* [[PTR]], i64 8) ]
; ASSUMPTIONS-ON-NEXT:    store volatile i64 0, i64* [[PTR]], align 8
; ASSUMPTIONS-ON-NEXT:    store volatile i64 -1, i64* [[PTR]], align 8
; ASSUMPTIONS-ON-NEXT:    store volatile i64 -1, i64* [[PTR]], align 8
; ASSUMPTIONS-ON-NEXT:    store volatile i64 -1, i64* [[PTR]], align 8
; ASSUMPTIONS-ON-NEXT:    store volatile i64 -1, i64* [[PTR]], align 8
; ASSUMPTIONS-ON-NEXT:    store volatile i64 -1, i64* [[PTR]], align 8
; ASSUMPTIONS-ON-NEXT:    store volatile i64 3, i64* [[PTR]], align 8
; ASSUMPTIONS-ON-NEXT:    ret void
; ASSUMPTIONS-ON:       true2.critedge:
; ASSUMPTIONS-ON-NEXT:    call void @llvm.assume(i1 true) [ "align"(i64* [[PTR]], i64 8) ]
; ASSUMPTIONS-ON-NEXT:    store volatile i64 0, i64* [[PTR]], align 8
; ASSUMPTIONS-ON-NEXT:    store volatile i64 -1, i64* [[PTR]], align 8
; ASSUMPTIONS-ON-NEXT:    store volatile i64 -1, i64* [[PTR]], align 8
; ASSUMPTIONS-ON-NEXT:    store volatile i64 -1, i64* [[PTR]], align 8
; ASSUMPTIONS-ON-NEXT:    store volatile i64 -1, i64* [[PTR]], align 8
; ASSUMPTIONS-ON-NEXT:    store volatile i64 -1, i64* [[PTR]], align 8
; ASSUMPTIONS-ON-NEXT:    store volatile i64 2, i64* [[PTR]], align 8
; ASSUMPTIONS-ON-NEXT:    ret void
;
  br i1 %c, label %true1, label %false1

true1:
  %c2 = call i1 @callee1(i1 %c, i64* %ptr)
  store volatile i64 -1, i64* %ptr
  store volatile i64 -1, i64* %ptr
  store volatile i64 -1, i64* %ptr
  store volatile i64 -1, i64* %ptr
  store volatile i64 -1, i64* %ptr
  br i1 %c2, label %true2, label %false2

false1:
  store volatile i64 1, i64* %ptr
  br label %true1

true2:
  store volatile i64 2, i64* %ptr
  ret void

false2:
  store volatile i64 3, i64* %ptr
  ret void
}

; This test checks that alignment assumptions do not prevent SROA.
; See PR45763.

define internal void @callee2(i64* noalias sret align 8 %arg) {
  store i64 0, i64* %arg, align 8
  ret void
}

define amdgpu_kernel void @caller2() {
; ASSUMPTIONS-OFF-LABEL: @caller2(
; ASSUMPTIONS-OFF-NEXT:    ret void
;
; ASSUMPTIONS-ON-LABEL: @caller2(
; ASSUMPTIONS-ON-NEXT:    ret void
;
  %alloca = alloca i64, align 8, addrspace(5)
  %cast = addrspacecast i64 addrspace(5)* %alloca to i64*
  call void @callee2(i64* sret align 8 %cast)
  ret void
}
