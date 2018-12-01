; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -loop-vectorize -S -mattr=avx512f  -instcombine < %s | FileCheck %s

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; first test checks that loop with a reduction and a uniform store gets
; vectorized.
; CHECK-LABEL: inv_val_store_to_inv_address_with_reduction
; CHECK-LABEL: vector.memcheck:
; CHECK:    found.conflict

; CHECK-LABEL: vector.body:
; CHECK:         %vec.phi = phi <16 x i32>  [ zeroinitializer, %vector.ph ], [ [[ADD:%[a-zA-Z0-9.]+]], %vector.body ]
; CHECK:         %wide.load = load <16 x i32>
; CHECK:         [[ADD]] = add <16 x i32> %vec.phi, %wide.load
; CHECK:         store i32 %ntrunc, i32* %a
; CHECK-NOT:     store i32 %ntrunc, i32* %a
; CHECK:         %index.next = add i64 %index, 64

; CHECK-LABEL: middle.block:
; CHECK:         %rdx.shuf = shufflevector <16 x i32>
define i32 @inv_val_store_to_inv_address_with_reduction(i32* %a, i64 %n, i32* %b) {
entry:
  %ntrunc = trunc i64 %n to i32
  br label %for.body

for.body:                                         ; preds = %for.body, %entry
  %i = phi i64 [ %i.next, %for.body ], [ 0, %entry ]
  %tmp0 = phi i32 [ %tmp3, %for.body ], [ 0, %entry ]
  %tmp1 = getelementptr inbounds i32, i32* %b, i64 %i
  %tmp2 = load i32, i32* %tmp1, align 8
  %tmp3 = add i32 %tmp0, %tmp2
  store i32 %ntrunc, i32* %a
  %i.next = add nuw nsw i64 %i, 1
  %cond = icmp slt i64 %i.next, %n
  br i1 %cond, label %for.body, label %for.end

for.end:                                          ; preds = %for.body
  %tmp4 = phi i32 [ %tmp3, %for.body ]
  ret i32 %tmp4
}

; Conditional store
; if (b[i] == k) a = ntrunc
define void @inv_val_store_to_inv_address_conditional(i32* %a, i64 %n, i32* %b, i32 %k) {
; CHECK-LABEL: @inv_val_store_to_inv_address_conditional(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[NTRUNC:%.*]] = trunc i64 [[N:%.*]] to i32
; CHECK-NEXT:    [[TMP0:%.*]] = icmp sgt i64 [[N]], 1
; CHECK-NEXT:    [[SMAX:%.*]] = select i1 [[TMP0]], i64 [[N]], i64 1
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 [[SMAX]], 16
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_MEMCHECK:%.*]]
; CHECK:       vector.memcheck:
; CHECK-NEXT:    [[A4:%.*]] = bitcast i32* [[A:%.*]] to i8*
; CHECK-NEXT:    [[B1:%.*]] = bitcast i32* [[B:%.*]] to i8*
; CHECK-NEXT:    [[TMP1:%.*]] = icmp sgt i64 [[N]], 1
; CHECK-NEXT:    [[SMAX2:%.*]] = select i1 [[TMP1]], i64 [[N]], i64 1
; CHECK-NEXT:    [[SCEVGEP:%.*]] = getelementptr i32, i32* [[B]], i64 [[SMAX2]]
; CHECK-NEXT:    [[UGLYGEP:%.*]] = getelementptr i8, i8* [[A4]], i64 1
; CHECK-NEXT:    [[BOUND0:%.*]] = icmp ugt i8* [[UGLYGEP]], [[B1]]
; CHECK-NEXT:    [[BOUND1:%.*]] = icmp ugt i32* [[SCEVGEP]], [[A]]
; CHECK-NEXT:    [[FOUND_CONFLICT:%.*]] = and i1 [[BOUND0]], [[BOUND1]]
; CHECK-NEXT:    br i1 [[FOUND_CONFLICT]], label [[SCALAR_PH]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_VEC:%.*]] = and i64 [[SMAX]], 9223372036854775792
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT5:%.*]] = insertelement <16 x i32> undef, i32 [[K:%.*]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT6:%.*]] = shufflevector <16 x i32> [[BROADCAST_SPLATINSERT5]], <16 x i32> undef, <16 x i32> zeroinitializer
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT7:%.*]] = insertelement <16 x i32> undef, i32 [[NTRUNC]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT8:%.*]] = shufflevector <16 x i32> [[BROADCAST_SPLATINSERT7]], <16 x i32> undef, <16 x i32> zeroinitializer
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT9:%.*]] = insertelement <16 x i32*> undef, i32* [[A]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT10:%.*]] = shufflevector <16 x i32*> [[BROADCAST_SPLATINSERT9]], <16 x i32*> undef, <16 x i32> zeroinitializer
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i32, i32* [[B]], i64 [[INDEX]]
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast i32* [[TMP2]] to <16 x i32>*
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <16 x i32>, <16 x i32>* [[TMP3]], align 8, !alias.scope !8, !noalias !11
; CHECK-NEXT:    [[TMP4:%.*]] = icmp eq <16 x i32> [[WIDE_LOAD]], [[BROADCAST_SPLAT6]]
; CHECK-NEXT:    [[TMP5:%.*]] = bitcast i32* [[TMP2]] to <16 x i32>*
; CHECK-NEXT:    store <16 x i32> [[BROADCAST_SPLAT8]], <16 x i32>* [[TMP5]], align 4, !alias.scope !8, !noalias !11
; CHECK-NEXT:    call void @llvm.masked.scatter.v16i32.v16p0i32(<16 x i32> [[BROADCAST_SPLAT8]], <16 x i32*> [[BROADCAST_SPLAT10]], i32 4, <16 x i1> [[TMP4]]), !alias.scope !11
; CHECK-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 16
; CHECK-NEXT:    [[TMP6:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP6]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop !13
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 [[SMAX]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ], [ 0, [[VECTOR_MEMCHECK]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I:%.*]] = phi i64 [ [[I_NEXT:%.*]], [[LATCH:%.*]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds i32, i32* [[B]], i64 [[I]]
; CHECK-NEXT:    [[TMP2:%.*]] = load i32, i32* [[TMP1]], align 8
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[TMP2]], [[K]]
; CHECK-NEXT:    store i32 [[NTRUNC]], i32* [[TMP1]], align 4
; CHECK-NEXT:    br i1 [[CMP]], label [[COND_STORE:%.*]], label [[LATCH]]
; CHECK:       cond_store:
; CHECK-NEXT:    store i32 [[NTRUNC]], i32* [[A]], align 4
; CHECK-NEXT:    br label [[LATCH]]
; CHECK:       latch:
; CHECK-NEXT:    [[I_NEXT]] = add nuw nsw i64 [[I]], 1
; CHECK-NEXT:    [[COND:%.*]] = icmp slt i64 [[I_NEXT]], [[N]]
; CHECK-NEXT:    br i1 [[COND]], label [[FOR_BODY]], label [[FOR_END]], !llvm.loop !14
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  %ntrunc = trunc i64 %n to i32
  br label %for.body

for.body:                                         ; preds = %for.body, %entry
  %i = phi i64 [ %i.next, %latch ], [ 0, %entry ]
  %tmp1 = getelementptr inbounds i32, i32* %b, i64 %i
  %tmp2 = load i32, i32* %tmp1, align 8
  %cmp = icmp eq i32 %tmp2, %k
  store i32 %ntrunc, i32* %tmp1
  br i1 %cmp, label %cond_store, label %latch

cond_store:
  store i32 %ntrunc, i32* %a
  br label %latch

latch:
  %i.next = add nuw nsw i64 %i, 1
  %cond = icmp slt i64 %i.next, %n
  br i1 %cond, label %for.body, label %for.end

for.end:                                          ; preds = %for.body
  ret void
}

define void @variant_val_store_to_inv_address_conditional(i32* %a, i64 %n, i32* %b, i32* %c, i32 %k) {
; CHECK-LABEL: @variant_val_store_to_inv_address_conditional(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[NTRUNC:%.*]] = trunc i64 [[N:%.*]] to i32
; CHECK-NEXT:    [[TMP0:%.*]] = icmp sgt i64 [[N]], 1
; CHECK-NEXT:    [[SMAX:%.*]] = select i1 [[TMP0]], i64 [[N]], i64 1
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 [[SMAX]], 16
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_MEMCHECK:%.*]]
; CHECK:       vector.memcheck:
; CHECK-NEXT:    [[C5:%.*]] = bitcast i32* [[C:%.*]] to i8*
; CHECK-NEXT:    [[B1:%.*]] = bitcast i32* [[B:%.*]] to i8*
; CHECK-NEXT:    [[A4:%.*]] = bitcast i32* [[A:%.*]] to i8*
; CHECK-NEXT:    [[TMP1:%.*]] = icmp sgt i64 [[N]], 1
; CHECK-NEXT:    [[SMAX2:%.*]] = select i1 [[TMP1]], i64 [[N]], i64 1
; CHECK-NEXT:    [[SCEVGEP:%.*]] = getelementptr i32, i32* [[B]], i64 [[SMAX2]]
; CHECK-NEXT:    [[UGLYGEP:%.*]] = getelementptr i8, i8* [[A4]], i64 1
; CHECK-NEXT:    [[SCEVGEP6:%.*]] = getelementptr i32, i32* [[C]], i64 [[SMAX2]]
; CHECK-NEXT:    [[BOUND0:%.*]] = icmp ugt i8* [[UGLYGEP]], [[B1]]
; CHECK-NEXT:    [[BOUND1:%.*]] = icmp ugt i32* [[SCEVGEP]], [[A]]
; CHECK-NEXT:    [[FOUND_CONFLICT:%.*]] = and i1 [[BOUND0]], [[BOUND1]]
; CHECK-NEXT:    [[BOUND08:%.*]] = icmp ugt i32* [[SCEVGEP6]], [[B]]
; CHECK-NEXT:    [[BOUND19:%.*]] = icmp ugt i32* [[SCEVGEP]], [[C]]
; CHECK-NEXT:    [[FOUND_CONFLICT10:%.*]] = and i1 [[BOUND08]], [[BOUND19]]
; CHECK-NEXT:    [[CONFLICT_RDX:%.*]] = or i1 [[FOUND_CONFLICT]], [[FOUND_CONFLICT10]]
; CHECK-NEXT:    [[BOUND012:%.*]] = icmp ugt i32* [[SCEVGEP6]], [[A]]
; CHECK-NEXT:    [[BOUND113:%.*]] = icmp ugt i8* [[UGLYGEP]], [[C5]]
; CHECK-NEXT:    [[FOUND_CONFLICT14:%.*]] = and i1 [[BOUND012]], [[BOUND113]]
; CHECK-NEXT:    [[CONFLICT_RDX15:%.*]] = or i1 [[CONFLICT_RDX]], [[FOUND_CONFLICT14]]
; CHECK-NEXT:    br i1 [[CONFLICT_RDX15]], label [[SCALAR_PH]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_VEC:%.*]] = and i64 [[SMAX]], 9223372036854775792
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT16:%.*]] = insertelement <16 x i32> undef, i32 [[K:%.*]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT17:%.*]] = shufflevector <16 x i32> [[BROADCAST_SPLATINSERT16]], <16 x i32> undef, <16 x i32> zeroinitializer
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT18:%.*]] = insertelement <16 x i32> undef, i32 [[NTRUNC]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT19:%.*]] = shufflevector <16 x i32> [[BROADCAST_SPLATINSERT18]], <16 x i32> undef, <16 x i32> zeroinitializer
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT20:%.*]] = insertelement <16 x i32*> undef, i32* [[A]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT21:%.*]] = shufflevector <16 x i32*> [[BROADCAST_SPLATINSERT20]], <16 x i32*> undef, <16 x i32> zeroinitializer
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i32, i32* [[B]], i64 [[INDEX]]
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast i32* [[TMP2]] to <16 x i32>*
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <16 x i32>, <16 x i32>* [[TMP3]], align 8, !alias.scope !15, !noalias !18
; CHECK-NEXT:    [[TMP4:%.*]] = icmp eq <16 x i32> [[WIDE_LOAD]], [[BROADCAST_SPLAT17]]
; CHECK-NEXT:    [[TMP5:%.*]] = bitcast i32* [[TMP2]] to <16 x i32>*
; CHECK-NEXT:    store <16 x i32> [[BROADCAST_SPLAT19]], <16 x i32>* [[TMP5]], align 4, !alias.scope !15, !noalias !18
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr inbounds i32, i32* [[C]], i64 [[INDEX]]
; CHECK-NEXT:    [[TMP7:%.*]] = bitcast i32* [[TMP6]] to <16 x i32>*
; CHECK-NEXT:    [[WIDE_MASKED_LOAD:%.*]] = call <16 x i32> @llvm.masked.load.v16i32.p0v16i32(<16 x i32>* [[TMP7]], i32 8, <16 x i1> [[TMP4]], <16 x i32> undef), !alias.scope !21
; CHECK-NEXT:    call void @llvm.masked.scatter.v16i32.v16p0i32(<16 x i32> [[WIDE_MASKED_LOAD]], <16 x i32*> [[BROADCAST_SPLAT21]], i32 4, <16 x i1> [[TMP4]]), !alias.scope !22, !noalias !21
; CHECK-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 16
; CHECK-NEXT:    [[TMP8:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP8]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop !23
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 [[SMAX]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ], [ 0, [[VECTOR_MEMCHECK]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I:%.*]] = phi i64 [ [[I_NEXT:%.*]], [[LATCH:%.*]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds i32, i32* [[B]], i64 [[I]]
; CHECK-NEXT:    [[TMP2:%.*]] = load i32, i32* [[TMP1]], align 8
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[TMP2]], [[K]]
; CHECK-NEXT:    store i32 [[NTRUNC]], i32* [[TMP1]], align 4
; CHECK-NEXT:    br i1 [[CMP]], label [[COND_STORE:%.*]], label [[LATCH]]
; CHECK:       cond_store:
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr inbounds i32, i32* [[C]], i64 [[I]]
; CHECK-NEXT:    [[TMP4:%.*]] = load i32, i32* [[TMP3]], align 8
; CHECK-NEXT:    store i32 [[TMP4]], i32* [[A]], align 4
; CHECK-NEXT:    br label [[LATCH]]
; CHECK:       latch:
; CHECK-NEXT:    [[I_NEXT]] = add nuw nsw i64 [[I]], 1
; CHECK-NEXT:    [[COND:%.*]] = icmp slt i64 [[I_NEXT]], [[N]]
; CHECK-NEXT:    br i1 [[COND]], label [[FOR_BODY]], label [[FOR_END]], !llvm.loop !24
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  %ntrunc = trunc i64 %n to i32
  br label %for.body

for.body:                                         ; preds = %for.body, %entry
  %i = phi i64 [ %i.next, %latch ], [ 0, %entry ]
  %tmp1 = getelementptr inbounds i32, i32* %b, i64 %i
  %tmp2 = load i32, i32* %tmp1, align 8
  %cmp = icmp eq i32 %tmp2, %k
  store i32 %ntrunc, i32* %tmp1
  br i1 %cmp, label %cond_store, label %latch

cond_store:
  %tmp3 = getelementptr inbounds i32, i32* %c, i64 %i
  %tmp4 = load i32, i32* %tmp3, align 8
  store i32 %tmp4, i32* %a
  br label %latch

latch:
  %i.next = add nuw nsw i64 %i, 1
  %cond = icmp slt i64 %i.next, %n
  br i1 %cond, label %for.body, label %for.end

for.end:                                          ; preds = %for.body
  ret void
}
