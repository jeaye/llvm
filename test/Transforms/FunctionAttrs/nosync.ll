; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --check-attributes
; RUN: opt < %s -function-attrs -S | FileCheck %s
; RUN: opt < %s -passes=function-attrs -S | FileCheck %s

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

; Base case, empty function
define void @test1() {
; CHECK: Function Attrs: nofree norecurse nosync nounwind readnone willreturn mustprogress
; CHECK-LABEL: @test1(
; CHECK-NEXT:    ret void
;
  ret void
}

; Show the bottom up walk
define void @test2() {
; CHECK: Function Attrs: nofree norecurse nosync nounwind readnone willreturn mustprogress
; CHECK-LABEL: @test2(
; CHECK-NEXT:    call void @test1()
; CHECK-NEXT:    ret void
;
  call void @test1()
  ret void
}

declare void @unknown() convergent

; Negative case with convergent function
define void @test3() convergent {
; CHECK: Function Attrs: convergent
; CHECK-LABEL: @test3(
; CHECK-NEXT:    call void @unknown()
; CHECK-NEXT:    ret void
;
  call void @unknown()
  ret void
}

define i32 @test4(i32 %a, i32 %b) {
; CHECK: Function Attrs: nofree norecurse nosync nounwind readnone willreturn mustprogress
; CHECK-LABEL: @test4(
; CHECK-NEXT:    [[ADD:%.*]] = add i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    ret i32 [[A]]
;
  %add = add i32 %a, %b
  ret i32 %a
}

; negative case - explicit sync
define void @test5(i8* %p) {
; CHECK: Function Attrs: nofree norecurse nounwind willreturn mustprogress
; CHECK-LABEL: @test5(
; CHECK-NEXT:    store atomic i8 0, i8* [[P:%.*]] seq_cst, align 1
; CHECK-NEXT:    ret void
;
  store atomic i8 0, i8* %p seq_cst, align 1
  ret void
}

; negative case - explicit sync
define i8 @test6(i8* %p) {
; CHECK: Function Attrs: nofree norecurse nounwind willreturn mustprogress
; CHECK-LABEL: @test6(
; CHECK-NEXT:    [[V:%.*]] = load atomic i8, i8* [[P:%.*]] seq_cst, align 1
; CHECK-NEXT:    ret i8 [[V]]
;
  %v = load atomic i8, i8* %p seq_cst, align 1
  ret i8 %v
}

; negative case - explicit sync
define void @test7(i8* %p) {
; CHECK: Function Attrs: nofree norecurse nounwind willreturn mustprogress
; CHECK-LABEL: @test7(
; CHECK-NEXT:    [[TMP1:%.*]] = atomicrmw add i8* [[P:%.*]], i8 0 seq_cst, align 1
; CHECK-NEXT:    ret void
;
  atomicrmw add i8* %p, i8 0 seq_cst, align 1
  ret void
}

; negative case - explicit sync
define void @test8(i8* %p) {
; CHECK: Function Attrs: nofree norecurse nounwind willreturn mustprogress
; CHECK-LABEL: @test8(
; CHECK-NEXT:    fence seq_cst
; CHECK-NEXT:    ret void
;
  fence seq_cst
  ret void
}

; singlethread fences are okay
define void @test9(i8* %p) {
; CHECK: Function Attrs: nofree norecurse nosync nounwind willreturn mustprogress
; CHECK-LABEL: @test9(
; CHECK-NEXT:    fence syncscope("singlethread") seq_cst
; CHECK-NEXT:    ret void
;
  fence syncscope("singlethread") seq_cst
  ret void
}

; atomic load with monotonic ordering
define i32 @load_monotonic(i32* nocapture readonly %0) norecurse nounwind uwtable {
; CHECK: Function Attrs: nofree norecurse nounwind uwtable willreturn mustprogress
; CHECK-LABEL: @load_monotonic(
; CHECK-NEXT:    [[TMP2:%.*]] = load atomic i32, i32* [[TMP0:%.*]] monotonic, align 4
; CHECK-NEXT:    ret i32 [[TMP2]]
;
  %2 = load atomic i32, i32* %0 monotonic, align 4
  ret i32 %2
}

; atomic store with monotonic ordering.
define void @store_monotonic(i32* nocapture %0) norecurse nounwind uwtable {
; CHECK: Function Attrs: nofree norecurse nounwind uwtable willreturn mustprogress
; CHECK-LABEL: @store_monotonic(
; CHECK-NEXT:    store atomic i32 10, i32* [[TMP0:%.*]] monotonic, align 4
; CHECK-NEXT:    ret void
;
  store atomic i32 10, i32* %0 monotonic, align 4
  ret void
}

; negative, should not deduce nosync
; atomic load with acquire ordering.
define i32 @load_acquire(i32* nocapture readonly %0) norecurse nounwind uwtable {
; CHECK: Function Attrs: nofree norecurse nounwind uwtable willreturn mustprogress
; CHECK-LABEL: @load_acquire(
; CHECK-NEXT:    [[TMP2:%.*]] = load atomic i32, i32* [[TMP0:%.*]] acquire, align 4
; CHECK-NEXT:    ret i32 [[TMP2]]
;
  %2 = load atomic i32, i32* %0 acquire, align 4
  ret i32 %2
}

define i32 @load_unordered(i32* nocapture readonly %0) norecurse nounwind uwtable {
; CHECK: Function Attrs: nofree norecurse nosync nounwind readonly uwtable willreturn mustprogress
; CHECK-LABEL: @load_unordered(
; CHECK-NEXT:    [[TMP2:%.*]] = load atomic i32, i32* [[TMP0:%.*]] unordered, align 4
; CHECK-NEXT:    ret i32 [[TMP2]]
;
  %2 = load atomic i32, i32* %0 unordered, align 4
  ret i32 %2
}

; atomic store with unordered ordering.
define void @store_unordered(i32* nocapture %0) norecurse nounwind uwtable {
; CHECK: Function Attrs: nofree norecurse nosync nounwind uwtable willreturn writeonly mustprogress
; CHECK-LABEL: @store_unordered(
; CHECK-NEXT:    store atomic i32 10, i32* [[TMP0:%.*]] unordered, align 4
; CHECK-NEXT:    ret void
;
  store atomic i32 10, i32* %0 unordered, align 4
  ret void
}


; negative, should not deduce nosync
; atomic load with release ordering
define void @load_release(i32* nocapture %0) norecurse nounwind uwtable {
; CHECK: Function Attrs: nofree norecurse nounwind uwtable willreturn mustprogress
; CHECK-LABEL: @load_release(
; CHECK-NEXT:    store atomic volatile i32 10, i32* [[TMP0:%.*]] release, align 4
; CHECK-NEXT:    ret void
;
  store atomic volatile i32 10, i32* %0 release, align 4
  ret void
}

; negative volatile, relaxed atomic
define void @load_volatile_release(i32* nocapture %0) norecurse nounwind uwtable {
; CHECK: Function Attrs: nofree norecurse nounwind uwtable willreturn mustprogress
; CHECK-LABEL: @load_volatile_release(
; CHECK-NEXT:    store atomic volatile i32 10, i32* [[TMP0:%.*]] release, align 4
; CHECK-NEXT:    ret void
;
  store atomic volatile i32 10, i32* %0 release, align 4
  ret void
}

; volatile store.
define void @volatile_store(i32* %0) norecurse nounwind uwtable {
; CHECK: Function Attrs: nofree norecurse nounwind uwtable willreturn mustprogress
; CHECK-LABEL: @volatile_store(
; CHECK-NEXT:    store volatile i32 14, i32* [[TMP0:%.*]], align 4
; CHECK-NEXT:    ret void
;
  store volatile i32 14, i32* %0, align 4
  ret void
}

; negative, should not deduce nosync
; volatile load.
define i32 @volatile_load(i32* %0) norecurse nounwind uwtable {
; CHECK: Function Attrs: nofree norecurse nounwind uwtable willreturn mustprogress
; CHECK-LABEL: @volatile_load(
; CHECK-NEXT:    [[TMP2:%.*]] = load volatile i32, i32* [[TMP0:%.*]], align 4
; CHECK-NEXT:    ret i32 [[TMP2]]
;
  %2 = load volatile i32, i32* %0, align 4
  ret i32 %2
}

; CHECK: Function Attrs: noinline nosync nounwind uwtable
; CHECK-NEXT: declare void @nosync_function()
declare void @nosync_function() noinline nounwind uwtable nosync

define void @call_nosync_function() nounwind uwtable noinline {
; CHECK: Function Attrs: noinline nosync nounwind uwtable
; CHECK-LABEL: @call_nosync_function(
; CHECK-NEXT:    tail call void @nosync_function() #[[ATTR8:[0-9]+]]
; CHECK-NEXT:    ret void
;
  tail call void @nosync_function() noinline nounwind uwtable
  ret void
}

; CHECK: Function Attrs: noinline nounwind uwtable
; CHECK-NEXT: declare void @might_sync()
declare void @might_sync() noinline nounwind uwtable

define void @call_might_sync() nounwind uwtable noinline {
; CHECK: Function Attrs: noinline nounwind uwtable
; CHECK-LABEL: @call_might_sync(
; CHECK-NEXT:    tail call void @might_sync() #[[ATTR8]]
; CHECK-NEXT:    ret void
;
  tail call void @might_sync() noinline nounwind uwtable
  ret void
}

declare void @llvm.memcpy(i8* %dest, i8* %src, i32 %len, i1 %isvolatile)
declare void @llvm.memset(i8* %dest, i8 %val, i32 %len, i1 %isvolatile)

; negative, checking volatile intrinsics.
define i32 @memcpy_volatile(i8* %ptr1, i8* %ptr2) {
; CHECK: Function Attrs: nofree nounwind willreturn mustprogress
; CHECK-LABEL: @memcpy_volatile(
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i32(i8* [[PTR1:%.*]], i8* [[PTR2:%.*]], i32 8, i1 true)
; CHECK-NEXT:    ret i32 4
;
  call void @llvm.memcpy(i8* %ptr1, i8* %ptr2, i32 8, i1 1)
  ret i32 4
}

; positive, non-volatile intrinsic.
define i32 @memset_non_volatile(i8* %ptr1, i8 %val) {
; CHECK: Function Attrs: nofree nosync nounwind willreturn writeonly mustprogress
; CHECK-LABEL: @memset_non_volatile(
; CHECK-NEXT:    call void @llvm.memset.p0i8.i32(i8* [[PTR1:%.*]], i8 [[VAL:%.*]], i32 8, i1 false)
; CHECK-NEXT:    ret i32 4
;
  call void @llvm.memset(i8* %ptr1, i8 %val, i32 8, i1 0)
  ret i32 4
}

; negative, inline assembly.
define i32 @inline_asm_test(i32 %x) {
; CHECK-LABEL: @inline_asm_test(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 asm "bswap $0", "=r,r"(i32 [[X:%.*]])
; CHECK-NEXT:    ret i32 4
;
  call i32 asm "bswap $0", "=r,r"(i32 %x)
  ret i32 4
}

declare void @readnone_test() convergent readnone

; negative. Convergent
define void @convergent_readnone(){
; CHECK: Function Attrs: nofree nosync readnone
; CHECK-LABEL: @convergent_readnone(
; CHECK-NEXT:    call void @readnone_test()
; CHECK-NEXT:    ret void
;
  call void @readnone_test()
  ret void
}

; CHECK: Function Attrs: nounwind
; CHECK-NEXT: declare void @llvm.x86.sse2.clflush(i8*)
declare void @llvm.x86.sse2.clflush(i8*)
@a = common global i32 0, align 4

; negative. Synchronizing intrinsic
define void @i_totally_sync() {
; CHECK: Function Attrs: nounwind
; CHECK-LABEL: @i_totally_sync(
; CHECK-NEXT:    tail call void @llvm.x86.sse2.clflush(i8* bitcast (i32* @a to i8*))
; CHECK-NEXT:    ret void
;
  tail call void @llvm.x86.sse2.clflush(i8* bitcast (i32* @a to i8*))
  ret void
}

declare float @llvm.cos(float %val) readnone

define float @cos_test(float %x) {
; CHECK: Function Attrs: nofree nosync nounwind readnone willreturn mustprogress
; CHECK-LABEL: @cos_test(
; CHECK-NEXT:    [[C:%.*]] = call float @llvm.cos.f32(float [[X:%.*]])
; CHECK-NEXT:    ret float [[C]]
;
  %c = call float @llvm.cos(float %x)
  ret float %c
}
