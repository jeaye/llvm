; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -O2 -S -enable-memcpyopt-memoryssa=0 | FileCheck %s
; RUN: opt < %s -O2 -S -enable-memcpyopt-memoryssa=1 -verify-memoryssa | FileCheck %s

; performCallSlotOptzn in MemCpy should not exchange the calls to
; @llvm.lifetime.start and @llvm.memcpy.

declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture, i8* nocapture readonly, i64, i1) #1
declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) #1
declare void @llvm.lifetime.end.p0i8(i64, i8* nocapture) #1

define void @call_slot(i8* nocapture dereferenceable(16) %arg1) {
; CHECK-LABEL: @call_slot(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[TMP_SROA_3_0_ARG1_SROA_RAW_IDX:%.*]] = getelementptr inbounds i8, i8* [[ARG1:%.*]], i64 7
; CHECK-NEXT:    store i8 0, i8* [[TMP_SROA_3_0_ARG1_SROA_RAW_IDX]], align 1
; CHECK-NEXT:    ret void
;
bb:
  %tmp = alloca [8 x i8], align 8
  %tmp5 = bitcast [8 x i8]* %tmp to i8*
  call void @llvm.lifetime.start.p0i8(i64 16, i8* %tmp5)
  %tmp10 = getelementptr inbounds i8, i8* %tmp5, i64 7
  store i8 0, i8* %tmp10, align 1
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %arg1, i8* align 8 %tmp5, i64 16, i1 false)
  call void @llvm.lifetime.end.p0i8(i64 16, i8* %tmp5)
  ret void
}

define void @memcpy_memcpy_across_lifetime(i8* noalias %p1, i8* noalias %p2, i8* noalias %p3) {
; CHECK-LABEL: @memcpy_memcpy_across_lifetime(
; CHECK-NEXT:    [[A:%.*]] = alloca [16 x i8], align 1
; CHECK-NEXT:    [[A8:%.*]] = getelementptr inbounds [16 x i8], [16 x i8]* [[A]], i64 0, i64 0
; CHECK-NEXT:    call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull [[A8]])
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(16) [[A8]], i8* nonnull align 1 dereferenceable(16) [[P1:%.*]], i64 16, i1 false)
; CHECK-NEXT:    tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(16) [[P1]], i8* nonnull align 1 dereferenceable(16) [[P2:%.*]], i64 16, i1 false)
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(16) [[P2]], i8* nonnull align 1 dereferenceable(16) [[A8]], i64 16, i1 false)
; CHECK-NEXT:    call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull [[A8]])
; CHECK-NEXT:    tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(16) [[P3:%.*]], i8* nonnull align 1 dereferenceable(16) [[P2]], i64 16, i1 false)
; CHECK-NEXT:    ret void
;
  %a = alloca [16 x i8]
  %a8 = bitcast [16 x i8]* %a to i8*
  call void @llvm.lifetime.start.p0i8(i64 16, i8* %a8)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %a8, i8* %p1, i64 16, i1 false)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %p1, i8* %p2, i64 16, i1 false)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %p2, i8* %a8, i64 16, i1 false)
  call void @llvm.lifetime.end.p0i8(i64 16, i8* %a8)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %p3, i8* %p2, i64 16, i1 false)
  ret void
}

attributes #1 = { argmemonly nounwind }
