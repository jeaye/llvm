; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -loop-vectorize -S -mattr=avx512f  -instcombine < %s | FileCheck %s

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; first test checks that loop with a reduction and a uniform store gets
; vectorized.

define i32 @inv_val_store_to_inv_address_with_reduction(i32* %a, i64 %n, i32* %b) {
; CHECK-LABEL: @inv_val_store_to_inv_address_with_reduction(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[NTRUNC:%.*]] = trunc i64 [[N:%.*]] to i32
; CHECK-NEXT:    [[TMP0:%.*]] = icmp sgt i64 [[N]], 1
; CHECK-NEXT:    [[SMAX:%.*]] = select i1 [[TMP0]], i64 [[N]], i64 1
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 [[SMAX]], 64
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_MEMCHECK:%.*]]
; CHECK:       vector.memcheck:
; CHECK-NEXT:    [[B2:%.*]] = bitcast i32* [[B:%.*]] to i8*
; CHECK-NEXT:    [[A1:%.*]] = bitcast i32* [[A:%.*]] to i8*
; CHECK-NEXT:    [[UGLYGEP:%.*]] = getelementptr i8, i8* [[A1]], i64 1
; CHECK-NEXT:    [[TMP1:%.*]] = icmp sgt i64 [[N]], 1
; CHECK-NEXT:    [[SMAX3:%.*]] = select i1 [[TMP1]], i64 [[N]], i64 1
; CHECK-NEXT:    [[SCEVGEP:%.*]] = getelementptr i32, i32* [[B]], i64 [[SMAX3]]
; CHECK-NEXT:    [[BOUND0:%.*]] = icmp ugt i32* [[SCEVGEP]], [[A]]
; CHECK-NEXT:    [[BOUND1:%.*]] = icmp ugt i8* [[UGLYGEP]], [[B2]]
; CHECK-NEXT:    [[FOUND_CONFLICT:%.*]] = and i1 [[BOUND0]], [[BOUND1]]
; CHECK-NEXT:    br i1 [[FOUND_CONFLICT]], label [[SCALAR_PH]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_VEC:%.*]] = and i64 [[SMAX]], 9223372036854775744
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_PHI:%.*]] = phi <16 x i32> [ zeroinitializer, [[VECTOR_PH]] ], [ [[TMP10:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_PHI5:%.*]] = phi <16 x i32> [ zeroinitializer, [[VECTOR_PH]] ], [ [[TMP11:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_PHI6:%.*]] = phi <16 x i32> [ zeroinitializer, [[VECTOR_PH]] ], [ [[TMP12:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_PHI7:%.*]] = phi <16 x i32> [ zeroinitializer, [[VECTOR_PH]] ], [ [[TMP13:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i32, i32* [[B]], i64 [[INDEX]]
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast i32* [[TMP2]] to <16 x i32>*
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <16 x i32>, <16 x i32>* [[TMP3]], align 8, !alias.scope !0
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds i32, i32* [[TMP2]], i64 16
; CHECK-NEXT:    [[TMP5:%.*]] = bitcast i32* [[TMP4]] to <16 x i32>*
; CHECK-NEXT:    [[WIDE_LOAD8:%.*]] = load <16 x i32>, <16 x i32>* [[TMP5]], align 8, !alias.scope !0
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr inbounds i32, i32* [[TMP2]], i64 32
; CHECK-NEXT:    [[TMP7:%.*]] = bitcast i32* [[TMP6]] to <16 x i32>*
; CHECK-NEXT:    [[WIDE_LOAD9:%.*]] = load <16 x i32>, <16 x i32>* [[TMP7]], align 8, !alias.scope !0
; CHECK-NEXT:    [[TMP8:%.*]] = getelementptr inbounds i32, i32* [[TMP2]], i64 48
; CHECK-NEXT:    [[TMP9:%.*]] = bitcast i32* [[TMP8]] to <16 x i32>*
; CHECK-NEXT:    [[WIDE_LOAD10:%.*]] = load <16 x i32>, <16 x i32>* [[TMP9]], align 8, !alias.scope !0
; CHECK-NEXT:    [[TMP10]] = add <16 x i32> [[VEC_PHI]], [[WIDE_LOAD]]
; CHECK-NEXT:    [[TMP11]] = add <16 x i32> [[VEC_PHI5]], [[WIDE_LOAD8]]
; CHECK-NEXT:    [[TMP12]] = add <16 x i32> [[VEC_PHI6]], [[WIDE_LOAD9]]
; CHECK-NEXT:    [[TMP13]] = add <16 x i32> [[VEC_PHI7]], [[WIDE_LOAD10]]
; CHECK-NEXT:    store i32 [[NTRUNC]], i32* [[A]], align 4, !alias.scope !3, !noalias !0
; CHECK-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 64
; CHECK-NEXT:    [[TMP14:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP14]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], [[LOOP5:!llvm.loop !.*]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[BIN_RDX:%.*]] = add <16 x i32> [[TMP11]], [[TMP10]]
; CHECK-NEXT:    [[BIN_RDX11:%.*]] = add <16 x i32> [[TMP12]], [[BIN_RDX]]
; CHECK-NEXT:    [[BIN_RDX12:%.*]] = add <16 x i32> [[TMP13]], [[BIN_RDX11]]
; CHECK-NEXT:    [[TMP15:%.*]] = call i32 @llvm.vector.reduce.add.v16i32(<16 x i32> [[BIN_RDX12]])
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 [[SMAX]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ], [ 0, [[VECTOR_MEMCHECK]] ]
; CHECK-NEXT:    [[BC_MERGE_RDX:%.*]] = phi i32 [ [[TMP15]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY]] ], [ 0, [[VECTOR_MEMCHECK]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I:%.*]] = phi i64 [ [[I_NEXT:%.*]], [[FOR_BODY]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[T0:%.*]] = phi i32 [ [[T3:%.*]], [[FOR_BODY]] ], [ [[BC_MERGE_RDX]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[T1:%.*]] = getelementptr inbounds i32, i32* [[B]], i64 [[I]]
; CHECK-NEXT:    [[T2:%.*]] = load i32, i32* [[T1]], align 8
; CHECK-NEXT:    [[T3]] = add i32 [[T0]], [[T2]]
; CHECK-NEXT:    store i32 [[NTRUNC]], i32* [[A]], align 4
; CHECK-NEXT:    [[I_NEXT]] = add nuw nsw i64 [[I]], 1
; CHECK-NEXT:    [[COND:%.*]] = icmp slt i64 [[I_NEXT]], [[N]]
; CHECK-NEXT:    br i1 [[COND]], label [[FOR_BODY]], label [[FOR_END]], [[LOOP7:!llvm.loop !.*]]
; CHECK:       for.end:
; CHECK-NEXT:    [[T4:%.*]] = phi i32 [ [[T3]], [[FOR_BODY]] ], [ [[TMP15]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    ret i32 [[T4]]
;
entry:
  %ntrunc = trunc i64 %n to i32
  br label %for.body

for.body:                                         ; preds = %for.body, %entry
  %i = phi i64 [ %i.next, %for.body ], [ 0, %entry ]
  %t0 = phi i32 [ %t3, %for.body ], [ 0, %entry ]
  %t1 = getelementptr inbounds i32, i32* %b, i64 %i
  %t2 = load i32, i32* %t1, align 8
  %t3 = add i32 %t0, %t2
  store i32 %ntrunc, i32* %a
  %i.next = add nuw nsw i64 %i, 1
  %cond = icmp slt i64 %i.next, %n
  br i1 %cond, label %for.body, label %for.end

for.end:                                          ; preds = %for.body
  %t4 = phi i32 [ %t3, %for.body ]
  ret i32 %t4
}

; Conditional store
; if (b[i] == k) a = ntrunc
define void @inv_val_store_to_inv_address_conditional(i32* %a, i64 %n, i32* %b, i32 %k) {
; CHECK-LABEL: @inv_val_store_to_inv_address_conditional(
; CHECK-NEXT:  iter.check:
; CHECK-NEXT:    [[NTRUNC:%.*]] = trunc i64 [[N:%.*]] to i32
; CHECK-NEXT:    [[TMP0:%.*]] = icmp sgt i64 [[N]], 1
; CHECK-NEXT:    [[SMAX:%.*]] = select i1 [[TMP0]], i64 [[N]], i64 1
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 [[SMAX]], 8
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[VEC_EPILOG_SCALAR_PH:%.*]], label [[VECTOR_MEMCHECK:%.*]]
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
; CHECK-NEXT:    br i1 [[FOUND_CONFLICT]], label [[VEC_EPILOG_SCALAR_PH]], label [[VECTOR_MAIN_LOOP_ITER_CHECK:%.*]]
; CHECK:       vector.main.loop.iter.check:
; CHECK-NEXT:    [[MIN_ITERS_CHECK5:%.*]] = icmp ult i64 [[SMAX]], 16
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK5]], label [[VEC_EPILOG_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_VEC:%.*]] = and i64 [[SMAX]], 9223372036854775792
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <16 x i32> poison, i32 [[K:%.*]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <16 x i32> [[BROADCAST_SPLATINSERT]], <16 x i32> poison, <16 x i32> zeroinitializer
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT6:%.*]] = insertelement <16 x i32> poison, i32 [[NTRUNC]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT7:%.*]] = shufflevector <16 x i32> [[BROADCAST_SPLATINSERT6]], <16 x i32> poison, <16 x i32> zeroinitializer
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT8:%.*]] = insertelement <16 x i32*> poison, i32* [[A]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT9:%.*]] = shufflevector <16 x i32*> [[BROADCAST_SPLATINSERT8]], <16 x i32*> poison, <16 x i32> zeroinitializer
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i32, i32* [[B]], i64 [[INDEX]]
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast i32* [[TMP2]] to <16 x i32>*
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <16 x i32>, <16 x i32>* [[TMP3]], align 8, !alias.scope !8, !noalias !11
; CHECK-NEXT:    [[TMP4:%.*]] = icmp eq <16 x i32> [[WIDE_LOAD]], [[BROADCAST_SPLAT]]
; CHECK-NEXT:    [[TMP5:%.*]] = bitcast i32* [[TMP2]] to <16 x i32>*
; CHECK-NEXT:    store <16 x i32> [[BROADCAST_SPLAT7]], <16 x i32>* [[TMP5]], align 4, !alias.scope !8, !noalias !11
; CHECK-NEXT:    call void @llvm.masked.scatter.v16i32.v16p0i32(<16 x i32> [[BROADCAST_SPLAT7]], <16 x i32*> [[BROADCAST_SPLAT9]], i32 4, <16 x i1> [[TMP4]]), !alias.scope !11
; CHECK-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 16
; CHECK-NEXT:    [[TMP6:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP6]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], [[LOOP13:!llvm.loop !.*]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 [[SMAX]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_END:%.*]], label [[VEC_EPILOG_ITER_CHECK:%.*]]
; CHECK:       vec.epilog.iter.check:
; CHECK-NEXT:    [[N_VEC_REMAINING:%.*]] = and i64 [[SMAX]], 8
; CHECK-NEXT:    [[MIN_EPILOG_ITERS_CHECK_NOT_NOT:%.*]] = icmp eq i64 [[N_VEC_REMAINING]], 0
; CHECK-NEXT:    br i1 [[MIN_EPILOG_ITERS_CHECK_NOT_NOT]], label [[VEC_EPILOG_SCALAR_PH]], label [[VEC_EPILOG_PH]]
; CHECK:       vec.epilog.ph:
; CHECK-NEXT:    [[VEC_EPILOG_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[VEC_EPILOG_ITER_CHECK]] ], [ 0, [[VECTOR_MAIN_LOOP_ITER_CHECK]] ]
; CHECK-NEXT:    [[TMP7:%.*]] = icmp sgt i64 [[N]], 1
; CHECK-NEXT:    [[SMAX10:%.*]] = select i1 [[TMP7]], i64 [[N]], i64 1
; CHECK-NEXT:    [[N_VEC12:%.*]] = and i64 [[SMAX10]], 9223372036854775800
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT17:%.*]] = insertelement <8 x i32> poison, i32 [[K]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT18:%.*]] = shufflevector <8 x i32> [[BROADCAST_SPLATINSERT17]], <8 x i32> poison, <8 x i32> zeroinitializer
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT19:%.*]] = insertelement <8 x i32> poison, i32 [[NTRUNC]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT20:%.*]] = shufflevector <8 x i32> [[BROADCAST_SPLATINSERT19]], <8 x i32> poison, <8 x i32> zeroinitializer
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT21:%.*]] = insertelement <8 x i32*> poison, i32* [[A]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT22:%.*]] = shufflevector <8 x i32*> [[BROADCAST_SPLATINSERT21]], <8 x i32*> poison, <8 x i32> zeroinitializer
; CHECK-NEXT:    br label [[VEC_EPILOG_VECTOR_BODY:%.*]]
; CHECK:       vec.epilog.vector.body:
; CHECK-NEXT:    [[INDEX13:%.*]] = phi i64 [ [[VEC_EPILOG_RESUME_VAL]], [[VEC_EPILOG_PH]] ], [ [[INDEX_NEXT14:%.*]], [[VEC_EPILOG_VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP8:%.*]] = getelementptr inbounds i32, i32* [[B]], i64 [[INDEX13]]
; CHECK-NEXT:    [[TMP9:%.*]] = bitcast i32* [[TMP8]] to <8 x i32>*
; CHECK-NEXT:    [[WIDE_LOAD16:%.*]] = load <8 x i32>, <8 x i32>* [[TMP9]], align 8
; CHECK-NEXT:    [[TMP10:%.*]] = icmp eq <8 x i32> [[WIDE_LOAD16]], [[BROADCAST_SPLAT18]]
; CHECK-NEXT:    [[TMP11:%.*]] = bitcast i32* [[TMP8]] to <8 x i32>*
; CHECK-NEXT:    store <8 x i32> [[BROADCAST_SPLAT20]], <8 x i32>* [[TMP11]], align 4
; CHECK-NEXT:    call void @llvm.masked.scatter.v8i32.v8p0i32(<8 x i32> [[BROADCAST_SPLAT20]], <8 x i32*> [[BROADCAST_SPLAT22]], i32 4, <8 x i1> [[TMP10]])
; CHECK-NEXT:    [[INDEX_NEXT14]] = add i64 [[INDEX13]], 8
; CHECK-NEXT:    [[TMP12:%.*]] = icmp eq i64 [[INDEX_NEXT14]], [[N_VEC12]]
; CHECK-NEXT:    br i1 [[TMP12]], label [[VEC_EPILOG_MIDDLE_BLOCK:%.*]], label [[VEC_EPILOG_VECTOR_BODY]], [[LOOP14:!llvm.loop !.*]]
; CHECK:       vec.epilog.middle.block:
; CHECK-NEXT:    [[CMP_N15:%.*]] = icmp eq i64 [[SMAX10]], [[N_VEC12]]
; CHECK-NEXT:    br i1 [[CMP_N15]], label [[FOR_END_LOOPEXIT:%.*]], label [[VEC_EPILOG_SCALAR_PH]]
; CHECK:       vec.epilog.scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC12]], [[VEC_EPILOG_MIDDLE_BLOCK]] ], [ [[N_VEC]], [[VEC_EPILOG_ITER_CHECK]] ], [ 0, [[VECTOR_MEMCHECK]] ], [ 0, [[ITER_CHECK:%.*]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I:%.*]] = phi i64 [ [[I_NEXT:%.*]], [[LATCH:%.*]] ], [ [[BC_RESUME_VAL]], [[VEC_EPILOG_SCALAR_PH]] ]
; CHECK-NEXT:    [[T1:%.*]] = getelementptr inbounds i32, i32* [[B]], i64 [[I]]
; CHECK-NEXT:    [[T2:%.*]] = load i32, i32* [[T1]], align 8
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[T2]], [[K]]
; CHECK-NEXT:    store i32 [[NTRUNC]], i32* [[T1]], align 4
; CHECK-NEXT:    br i1 [[CMP]], label [[COND_STORE:%.*]], label [[LATCH]]
; CHECK:       cond_store:
; CHECK-NEXT:    store i32 [[NTRUNC]], i32* [[A]], align 4
; CHECK-NEXT:    br label [[LATCH]]
; CHECK:       latch:
; CHECK-NEXT:    [[I_NEXT]] = add nuw nsw i64 [[I]], 1
; CHECK-NEXT:    [[COND:%.*]] = icmp slt i64 [[I_NEXT]], [[N]]
; CHECK-NEXT:    br i1 [[COND]], label [[FOR_BODY]], label [[FOR_END_LOOPEXIT]], [[LOOP16:!llvm.loop !.*]]
; CHECK:       for.end.loopexit:
; CHECK-NEXT:    br label [[FOR_END]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  %ntrunc = trunc i64 %n to i32
  br label %for.body

for.body:                                         ; preds = %for.body, %entry
  %i = phi i64 [ %i.next, %latch ], [ 0, %entry ]
  %t1 = getelementptr inbounds i32, i32* %b, i64 %i
  %t2 = load i32, i32* %t1, align 8
  %cmp = icmp eq i32 %t2, %k
  store i32 %ntrunc, i32* %t1
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
; CHECK-NEXT:  iter.check:
; CHECK-NEXT:    [[NTRUNC:%.*]] = trunc i64 [[N:%.*]] to i32
; CHECK-NEXT:    [[TMP0:%.*]] = icmp sgt i64 [[N]], 1
; CHECK-NEXT:    [[SMAX:%.*]] = select i1 [[TMP0]], i64 [[N]], i64 1
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 [[SMAX]], 8
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[VEC_EPILOG_SCALAR_PH:%.*]], label [[VECTOR_MEMCHECK:%.*]]
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
; CHECK-NEXT:    br i1 [[CONFLICT_RDX15]], label [[VEC_EPILOG_SCALAR_PH]], label [[VECTOR_MAIN_LOOP_ITER_CHECK:%.*]]
; CHECK:       vector.main.loop.iter.check:
; CHECK-NEXT:    [[MIN_ITERS_CHECK16:%.*]] = icmp ult i64 [[SMAX]], 16
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK16]], label [[VEC_EPILOG_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_VEC:%.*]] = and i64 [[SMAX]], 9223372036854775792
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <16 x i32> poison, i32 [[K:%.*]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <16 x i32> [[BROADCAST_SPLATINSERT]], <16 x i32> poison, <16 x i32> zeroinitializer
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT17:%.*]] = insertelement <16 x i32> poison, i32 [[NTRUNC]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT18:%.*]] = shufflevector <16 x i32> [[BROADCAST_SPLATINSERT17]], <16 x i32> poison, <16 x i32> zeroinitializer
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT19:%.*]] = insertelement <16 x i32*> poison, i32* [[A]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT20:%.*]] = shufflevector <16 x i32*> [[BROADCAST_SPLATINSERT19]], <16 x i32*> poison, <16 x i32> zeroinitializer
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i32, i32* [[B]], i64 [[INDEX]]
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast i32* [[TMP2]] to <16 x i32>*
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <16 x i32>, <16 x i32>* [[TMP3]], align 8, !alias.scope !17, !noalias !20
; CHECK-NEXT:    [[TMP4:%.*]] = icmp eq <16 x i32> [[WIDE_LOAD]], [[BROADCAST_SPLAT]]
; CHECK-NEXT:    [[TMP5:%.*]] = bitcast i32* [[TMP2]] to <16 x i32>*
; CHECK-NEXT:    store <16 x i32> [[BROADCAST_SPLAT18]], <16 x i32>* [[TMP5]], align 4, !alias.scope !17, !noalias !20
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr inbounds i32, i32* [[C]], i64 [[INDEX]]
; CHECK-NEXT:    [[TMP7:%.*]] = bitcast i32* [[TMP6]] to <16 x i32>*
; CHECK-NEXT:    [[WIDE_MASKED_LOAD:%.*]] = call <16 x i32> @llvm.masked.load.v16i32.p0v16i32(<16 x i32>* [[TMP7]], i32 8, <16 x i1> [[TMP4]], <16 x i32> poison), !alias.scope !23
; CHECK-NEXT:    call void @llvm.masked.scatter.v16i32.v16p0i32(<16 x i32> [[WIDE_MASKED_LOAD]], <16 x i32*> [[BROADCAST_SPLAT20]], i32 4, <16 x i1> [[TMP4]]), !alias.scope !24, !noalias !23
; CHECK-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 16
; CHECK-NEXT:    [[TMP8:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP8]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], [[LOOP25:!llvm.loop !.*]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 [[SMAX]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_END:%.*]], label [[VEC_EPILOG_ITER_CHECK:%.*]]
; CHECK:       vec.epilog.iter.check:
; CHECK-NEXT:    [[N_VEC_REMAINING:%.*]] = and i64 [[SMAX]], 8
; CHECK-NEXT:    [[MIN_EPILOG_ITERS_CHECK_NOT_NOT:%.*]] = icmp eq i64 [[N_VEC_REMAINING]], 0
; CHECK-NEXT:    br i1 [[MIN_EPILOG_ITERS_CHECK_NOT_NOT]], label [[VEC_EPILOG_SCALAR_PH]], label [[VEC_EPILOG_PH]]
; CHECK:       vec.epilog.ph:
; CHECK-NEXT:    [[VEC_EPILOG_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[VEC_EPILOG_ITER_CHECK]] ], [ 0, [[VECTOR_MAIN_LOOP_ITER_CHECK]] ]
; CHECK-NEXT:    [[TMP9:%.*]] = icmp sgt i64 [[N]], 1
; CHECK-NEXT:    [[SMAX21:%.*]] = select i1 [[TMP9]], i64 [[N]], i64 1
; CHECK-NEXT:    [[N_VEC23:%.*]] = and i64 [[SMAX21]], 9223372036854775800
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT28:%.*]] = insertelement <8 x i32> poison, i32 [[K]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT29:%.*]] = shufflevector <8 x i32> [[BROADCAST_SPLATINSERT28]], <8 x i32> poison, <8 x i32> zeroinitializer
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT30:%.*]] = insertelement <8 x i32> poison, i32 [[NTRUNC]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT31:%.*]] = shufflevector <8 x i32> [[BROADCAST_SPLATINSERT30]], <8 x i32> poison, <8 x i32> zeroinitializer
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT33:%.*]] = insertelement <8 x i32*> poison, i32* [[A]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT34:%.*]] = shufflevector <8 x i32*> [[BROADCAST_SPLATINSERT33]], <8 x i32*> poison, <8 x i32> zeroinitializer
; CHECK-NEXT:    br label [[VEC_EPILOG_VECTOR_BODY:%.*]]
; CHECK:       vec.epilog.vector.body:
; CHECK-NEXT:    [[INDEX24:%.*]] = phi i64 [ [[VEC_EPILOG_RESUME_VAL]], [[VEC_EPILOG_PH]] ], [ [[INDEX_NEXT25:%.*]], [[VEC_EPILOG_VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP10:%.*]] = getelementptr inbounds i32, i32* [[B]], i64 [[INDEX24]]
; CHECK-NEXT:    [[TMP11:%.*]] = bitcast i32* [[TMP10]] to <8 x i32>*
; CHECK-NEXT:    [[WIDE_LOAD27:%.*]] = load <8 x i32>, <8 x i32>* [[TMP11]], align 8
; CHECK-NEXT:    [[TMP12:%.*]] = icmp eq <8 x i32> [[WIDE_LOAD27]], [[BROADCAST_SPLAT29]]
; CHECK-NEXT:    [[TMP13:%.*]] = bitcast i32* [[TMP10]] to <8 x i32>*
; CHECK-NEXT:    store <8 x i32> [[BROADCAST_SPLAT31]], <8 x i32>* [[TMP13]], align 4
; CHECK-NEXT:    [[TMP14:%.*]] = getelementptr inbounds i32, i32* [[C]], i64 [[INDEX24]]
; CHECK-NEXT:    [[TMP15:%.*]] = bitcast i32* [[TMP14]] to <8 x i32>*
; CHECK-NEXT:    [[WIDE_MASKED_LOAD32:%.*]] = call <8 x i32> @llvm.masked.load.v8i32.p0v8i32(<8 x i32>* [[TMP15]], i32 8, <8 x i1> [[TMP12]], <8 x i32> poison)
; CHECK-NEXT:    call void @llvm.masked.scatter.v8i32.v8p0i32(<8 x i32> [[WIDE_MASKED_LOAD32]], <8 x i32*> [[BROADCAST_SPLAT34]], i32 4, <8 x i1> [[TMP12]])
; CHECK-NEXT:    [[INDEX_NEXT25]] = add i64 [[INDEX24]], 8
; CHECK-NEXT:    [[TMP16:%.*]] = icmp eq i64 [[INDEX_NEXT25]], [[N_VEC23]]
; CHECK-NEXT:    br i1 [[TMP16]], label [[VEC_EPILOG_MIDDLE_BLOCK:%.*]], label [[VEC_EPILOG_VECTOR_BODY]], [[LOOP26:!llvm.loop !.*]]
; CHECK:       vec.epilog.middle.block:
; CHECK-NEXT:    [[CMP_N26:%.*]] = icmp eq i64 [[SMAX21]], [[N_VEC23]]
; CHECK-NEXT:    br i1 [[CMP_N26]], label [[FOR_END_LOOPEXIT:%.*]], label [[VEC_EPILOG_SCALAR_PH]]
; CHECK:       vec.epilog.scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC23]], [[VEC_EPILOG_MIDDLE_BLOCK]] ], [ [[N_VEC]], [[VEC_EPILOG_ITER_CHECK]] ], [ 0, [[VECTOR_MEMCHECK]] ], [ 0, [[ITER_CHECK:%.*]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I:%.*]] = phi i64 [ [[I_NEXT:%.*]], [[LATCH:%.*]] ], [ [[BC_RESUME_VAL]], [[VEC_EPILOG_SCALAR_PH]] ]
; CHECK-NEXT:    [[T1:%.*]] = getelementptr inbounds i32, i32* [[B]], i64 [[I]]
; CHECK-NEXT:    [[T2:%.*]] = load i32, i32* [[T1]], align 8
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[T2]], [[K]]
; CHECK-NEXT:    store i32 [[NTRUNC]], i32* [[T1]], align 4
; CHECK-NEXT:    br i1 [[CMP]], label [[COND_STORE:%.*]], label [[LATCH]]
; CHECK:       cond_store:
; CHECK-NEXT:    [[T3:%.*]] = getelementptr inbounds i32, i32* [[C]], i64 [[I]]
; CHECK-NEXT:    [[T4:%.*]] = load i32, i32* [[T3]], align 8
; CHECK-NEXT:    store i32 [[T4]], i32* [[A]], align 4
; CHECK-NEXT:    br label [[LATCH]]
; CHECK:       latch:
; CHECK-NEXT:    [[I_NEXT]] = add nuw nsw i64 [[I]], 1
; CHECK-NEXT:    [[COND:%.*]] = icmp slt i64 [[I_NEXT]], [[N]]
; CHECK-NEXT:    br i1 [[COND]], label [[FOR_BODY]], label [[FOR_END_LOOPEXIT]], [[LOOP27:!llvm.loop !.*]]
; CHECK:       for.end.loopexit:
; CHECK-NEXT:    br label [[FOR_END]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  %ntrunc = trunc i64 %n to i32
  br label %for.body

for.body:                                         ; preds = %for.body, %entry
  %i = phi i64 [ %i.next, %latch ], [ 0, %entry ]
  %t1 = getelementptr inbounds i32, i32* %b, i64 %i
  %t2 = load i32, i32* %t1, align 8
  %cmp = icmp eq i32 %t2, %k
  store i32 %ntrunc, i32* %t1
  br i1 %cmp, label %cond_store, label %latch

cond_store:
  %t3 = getelementptr inbounds i32, i32* %c, i64 %i
  %t4 = load i32, i32* %t3, align 8
  store i32 %t4, i32* %a
  br label %latch

latch:
  %i.next = add nuw nsw i64 %i, 1
  %cond = icmp slt i64 %i.next, %n
  br i1 %cond, label %for.body, label %for.end

for.end:                                          ; preds = %for.body
  ret void
}
