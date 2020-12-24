; NOTE: Assertions have been autogenerated by utils/update_test_checks.py

; To test epilogue-vectorization we need to make sure that the vectorizer actually vectorizes the loop.
; Without a target triple this becomes difficult, unless we force vectorization through user hints.
; Currently user provided vectorization hints prevent epilogue vectorization unless the forced
; VF is the same as the epilogue vectorization VF. To make these tests target independent we'll use a
; trick where both VFs are forced to be the same value. Mismatching VFs are tested in target specific tests.
; RUN: opt -passes='loop-vectorize' -force-vector-width=4 -enable-epilogue-vectorization -epilogue-vectorization-force-VF=4 -S %s | FileCheck %s

; Some simpler cases are found profitable even without triple or user hints.
; RUN: opt -passes='loop-vectorize' -enable-epilogue-vectorization -epilogue-vectorization-force-VF=2 -S %s | FileCheck --check-prefix=CHECK-PROFITABLE-BY-DEFAULT %s

target datalayout = "e-m:e-i64:64-n32:64-v128:128:128"

define dso_local void @f1(float* noalias %aa, float* noalias %bb, float* noalias %cc, i32 signext %N) {
; CHECK-LABEL: @f1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[AA1:%.*]] = bitcast float* [[AA:%.*]] to i8*
; CHECK-NEXT:    [[BB3:%.*]] = bitcast float* [[BB:%.*]] to i8*
; CHECK-NEXT:    [[CC6:%.*]] = bitcast float* [[CC:%.*]] to i8*
; CHECK-NEXT:    [[CMP1:%.*]] = icmp sgt i32 [[N:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP1]], label [[ITER_CHECK:%.*]], label [[FOR_END:%.*]]
; CHECK:       iter.check:
; CHECK-NEXT:    [[WIDE_TRIP_COUNT:%.*]] = zext i32 [[N]] to i64
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 [[WIDE_TRIP_COUNT]], 4
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[VEC_EPILOG_SCALAR_PH:%.*]], label [[VECTOR_MEMCHECK:%.*]]
; CHECK:       vector.memcheck:
; CHECK-NEXT:    [[SCEVGEP:%.*]] = getelementptr float, float* [[AA]], i64 [[WIDE_TRIP_COUNT]]
; CHECK-NEXT:    [[SCEVGEP2:%.*]] = bitcast float* [[SCEVGEP]] to i8*
; CHECK-NEXT:    [[SCEVGEP4:%.*]] = getelementptr float, float* [[BB]], i64 [[WIDE_TRIP_COUNT]]
; CHECK-NEXT:    [[SCEVGEP45:%.*]] = bitcast float* [[SCEVGEP4]] to i8*
; CHECK-NEXT:    [[SCEVGEP7:%.*]] = getelementptr float, float* [[CC]], i64 [[WIDE_TRIP_COUNT]]
; CHECK-NEXT:    [[SCEVGEP78:%.*]] = bitcast float* [[SCEVGEP7]] to i8*
; CHECK-NEXT:    [[BOUND0:%.*]] = icmp ult i8* [[AA1]], [[SCEVGEP45]]
; CHECK-NEXT:    [[BOUND1:%.*]] = icmp ult i8* [[BB3]], [[SCEVGEP2]]
; CHECK-NEXT:    [[FOUND_CONFLICT:%.*]] = and i1 [[BOUND0]], [[BOUND1]]
; CHECK-NEXT:    [[BOUND09:%.*]] = icmp ult i8* [[AA1]], [[SCEVGEP78]]
; CHECK-NEXT:    [[BOUND110:%.*]] = icmp ult i8* [[CC6]], [[SCEVGEP2]]
; CHECK-NEXT:    [[FOUND_CONFLICT11:%.*]] = and i1 [[BOUND09]], [[BOUND110]]
; CHECK-NEXT:    [[CONFLICT_RDX:%.*]] = or i1 [[FOUND_CONFLICT]], [[FOUND_CONFLICT11]]
; CHECK-NEXT:    [[MEMCHECK_CONFLICT:%.*]] = and i1 [[CONFLICT_RDX]], true
; CHECK-NEXT:    br i1 [[MEMCHECK_CONFLICT]], label [[VEC_EPILOG_SCALAR_PH]], label [[VECTOR_MAIN_LOOP_ITER_CHECK:%.*]]
; CHECK:       vector.main.loop.iter.check:
; CHECK-NEXT:    [[MIN_ITERS_CHECK12:%.*]] = icmp ult i64 [[WIDE_TRIP_COUNT]], 4
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK12]], label [[VEC_EPILOG_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i64 [[WIDE_TRIP_COUNT]], 4
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i64 [[WIDE_TRIP_COUNT]], [[N_MOD_VF]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds float, float* [[BB]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds float, float* [[TMP1]], i32 0
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast float* [[TMP2]] to <4 x float>*
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <4 x float>, <4 x float>* [[TMP3]], align 4, !alias.scope !0
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds float, float* [[CC]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr inbounds float, float* [[TMP4]], i32 0
; CHECK-NEXT:    [[TMP6:%.*]] = bitcast float* [[TMP5]] to <4 x float>*
; CHECK-NEXT:    [[WIDE_LOAD13:%.*]] = load <4 x float>, <4 x float>* [[TMP6]], align 4, !alias.scope !3
; CHECK-NEXT:    [[TMP7:%.*]] = fadd fast <4 x float> [[WIDE_LOAD]], [[WIDE_LOAD13]]
; CHECK-NEXT:    [[TMP8:%.*]] = getelementptr inbounds float, float* [[AA]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP9:%.*]] = getelementptr inbounds float, float* [[TMP8]], i32 0
; CHECK-NEXT:    [[TMP10:%.*]] = bitcast float* [[TMP9]] to <4 x float>*
; CHECK-NEXT:    store <4 x float> [[TMP7]], <4 x float>* [[TMP10]], align 4, !alias.scope !5, !noalias !7
; CHECK-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 4
; CHECK-NEXT:    [[TMP11:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP11]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], [[LOOP8:!llvm.loop !.*]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 [[WIDE_TRIP_COUNT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_END_LOOPEXIT:%.*]], label [[VEC_EPILOG_ITER_CHECK:%.*]]
; CHECK:       vec.epilog.iter.check:
; CHECK-NEXT:    [[N_VEC_REMAINING:%.*]] = sub i64 [[WIDE_TRIP_COUNT]], [[N_VEC]]
; CHECK-NEXT:    [[MIN_EPILOG_ITERS_CHECK:%.*]] = icmp ult i64 [[N_VEC_REMAINING]], 4
; CHECK-NEXT:    br i1 [[MIN_EPILOG_ITERS_CHECK]], label [[VEC_EPILOG_SCALAR_PH]], label [[VEC_EPILOG_PH]]
; CHECK:       vec.epilog.ph:
; CHECK-NEXT:    [[VEC_EPILOG_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[VEC_EPILOG_ITER_CHECK]] ], [ 0, [[VECTOR_MAIN_LOOP_ITER_CHECK]] ]
; CHECK-NEXT:    [[N_MOD_VF14:%.*]] = urem i64 [[WIDE_TRIP_COUNT]], 4
; CHECK-NEXT:    [[N_VEC15:%.*]] = sub i64 [[WIDE_TRIP_COUNT]], [[N_MOD_VF14]]
; CHECK-NEXT:    br label [[VEC_EPILOG_VECTOR_BODY:%.*]]
; CHECK:       vec.epilog.vector.body:
; CHECK-NEXT:    [[INDEX16:%.*]] = phi i64 [ [[VEC_EPILOG_RESUME_VAL]], [[VEC_EPILOG_PH]] ], [ [[INDEX_NEXT17:%.*]], [[VEC_EPILOG_VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP12:%.*]] = add i64 [[INDEX16]], 0
; CHECK-NEXT:    [[TMP13:%.*]] = getelementptr inbounds float, float* [[BB]], i64 [[TMP12]]
; CHECK-NEXT:    [[TMP14:%.*]] = getelementptr inbounds float, float* [[TMP13]], i32 0
; CHECK-NEXT:    [[TMP15:%.*]] = bitcast float* [[TMP14]] to <4 x float>*
; CHECK-NEXT:    [[WIDE_LOAD19:%.*]] = load <4 x float>, <4 x float>* [[TMP15]], align 4
; CHECK-NEXT:    [[TMP16:%.*]] = getelementptr inbounds float, float* [[CC]], i64 [[TMP12]]
; CHECK-NEXT:    [[TMP17:%.*]] = getelementptr inbounds float, float* [[TMP16]], i32 0
; CHECK-NEXT:    [[TMP18:%.*]] = bitcast float* [[TMP17]] to <4 x float>*
; CHECK-NEXT:    [[WIDE_LOAD20:%.*]] = load <4 x float>, <4 x float>* [[TMP18]], align 4
; CHECK-NEXT:    [[TMP19:%.*]] = fadd fast <4 x float> [[WIDE_LOAD19]], [[WIDE_LOAD20]]
; CHECK-NEXT:    [[TMP20:%.*]] = getelementptr inbounds float, float* [[AA]], i64 [[TMP12]]
; CHECK-NEXT:    [[TMP21:%.*]] = getelementptr inbounds float, float* [[TMP20]], i32 0
; CHECK-NEXT:    [[TMP22:%.*]] = bitcast float* [[TMP21]] to <4 x float>*
; CHECK-NEXT:    store <4 x float> [[TMP19]], <4 x float>* [[TMP22]], align 4
; CHECK-NEXT:    [[INDEX_NEXT17]] = add i64 [[INDEX16]], 4
; CHECK-NEXT:    [[TMP23:%.*]] = icmp eq i64 [[INDEX_NEXT17]], [[N_VEC15]]
; CHECK-NEXT:    br i1 [[TMP23]], label [[VEC_EPILOG_MIDDLE_BLOCK:%.*]], label [[VEC_EPILOG_VECTOR_BODY]], [[LOOP10:!llvm.loop !.*]]
; CHECK:       vec.epilog.middle.block:
; CHECK-NEXT:    [[CMP_N18:%.*]] = icmp eq i64 [[WIDE_TRIP_COUNT]], [[N_VEC15]]
; CHECK-NEXT:    br i1 [[CMP_N18]], label [[FOR_END_LOOPEXIT_LOOPEXIT:%.*]], label [[VEC_EPILOG_SCALAR_PH]]
; CHECK:       vec.epilog.scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC15]], [[VEC_EPILOG_MIDDLE_BLOCK]] ], [ [[N_VEC]], [[VEC_EPILOG_ITER_CHECK]] ], [ 0, [[VECTOR_MEMCHECK]] ], [ 0, [[ITER_CHECK]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[VEC_EPILOG_SCALAR_PH]] ], [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds float, float* [[BB]], i64 [[INDVARS_IV]]
; CHECK-NEXT:    [[TMP24:%.*]] = load float, float* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[ARRAYIDX2:%.*]] = getelementptr inbounds float, float* [[CC]], i64 [[INDVARS_IV]]
; CHECK-NEXT:    [[TMP25:%.*]] = load float, float* [[ARRAYIDX2]], align 4
; CHECK-NEXT:    [[ADD:%.*]] = fadd fast float [[TMP24]], [[TMP25]]
; CHECK-NEXT:    [[ARRAYIDX4:%.*]] = getelementptr inbounds float, float* [[AA]], i64 [[INDVARS_IV]]
; CHECK-NEXT:    store float [[ADD]], float* [[ARRAYIDX4]], align 4
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp ne i64 [[INDVARS_IV_NEXT]], [[WIDE_TRIP_COUNT]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_BODY]], label [[FOR_END_LOOPEXIT_LOOPEXIT]], [[LOOP12:!llvm.loop !.*]]
; CHECK:       for.end.loopexit.loopexit:
; CHECK-NEXT:    br label [[FOR_END_LOOPEXIT]]
; CHECK:       for.end.loopexit:
; CHECK-NEXT:    br label [[FOR_END]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
; CHECK-PROFITABLE-BY-DEFAULT-LABEL: @f1(
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:  entry:
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[CMP1:%.*]] = icmp sgt i32 [[N:%.*]], 0
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    br i1 [[CMP1]], label [[FOR_BODY_PREHEADER:%.*]], label [[FOR_END:%.*]]
; CHECK-PROFITABLE-BY-DEFAULT:       for.body.preheader:
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[WIDE_TRIP_COUNT:%.*]] = zext i32 [[N]] to i64
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK-PROFITABLE-BY-DEFAULT:       for.body:
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ 0, [[FOR_BODY_PREHEADER]] ], [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY]] ]
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds float, float* [[BB:%.*]], i64 [[INDVARS_IV]]
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[TMP0:%.*]] = load float, float* [[ARRAYIDX]], align 4
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[ARRAYIDX2:%.*]] = getelementptr inbounds float, float* [[CC:%.*]], i64 [[INDVARS_IV]]
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[TMP1:%.*]] = load float, float* [[ARRAYIDX2]], align 4
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[ADD:%.*]] = fadd fast float [[TMP0]], [[TMP1]]
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[ARRAYIDX4:%.*]] = getelementptr inbounds float, float* [[AA:%.*]], i64 [[INDVARS_IV]]
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    store float [[ADD]], float* [[ARRAYIDX4]], align 4
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[EXITCOND:%.*]] = icmp ne i64 [[INDVARS_IV_NEXT]], [[WIDE_TRIP_COUNT]]
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    br i1 [[EXITCOND]], label [[FOR_BODY]], label [[FOR_END_LOOPEXIT:%.*]]
; CHECK-PROFITABLE-BY-DEFAULT:       for.end.loopexit:
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    br label [[FOR_END]]
; CHECK-PROFITABLE-BY-DEFAULT:       for.end:
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    ret void
;
entry:
  %cmp1 = icmp sgt i32 %N, 0
  br i1 %cmp1, label %for.body.preheader, label %for.end

for.body.preheader:                               ; preds = %entry
  %wide.trip.count = zext i32 %N to i64
  br label %for.body

for.body:                                         ; preds = %for.body.preheader, %for.body
  %indvars.iv = phi i64 [ 0, %for.body.preheader ], [ %indvars.iv.next, %for.body ]
  %arrayidx = getelementptr inbounds float, float* %bb, i64 %indvars.iv
  %0 = load float, float* %arrayidx, align 4
  %arrayidx2 = getelementptr inbounds float, float* %cc, i64 %indvars.iv
  %1 = load float, float* %arrayidx2, align 4
  %add = fadd fast float %0, %1
  %arrayidx4 = getelementptr inbounds float, float* %aa, i64 %indvars.iv
  store float %add, float* %arrayidx4, align 4
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond = icmp ne i64 %indvars.iv.next, %wide.trip.count
  br i1 %exitcond, label %for.body, label %for.end.loopexit

for.end.loopexit:                                 ; preds = %for.body
  br label %for.end

for.end:                                          ; preds = %for.end.loopexit, %entry
  ret void
}

define dso_local signext i32 @f2(float* noalias %A, float* noalias %B, i32 signext %n) {
; CHECK-LABEL: @f2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A1:%.*]] = bitcast float* [[A:%.*]] to i8*
; CHECK-NEXT:    [[CMP1:%.*]] = icmp sgt i32 [[N:%.*]], 1
; CHECK-NEXT:    br i1 [[CMP1]], label [[ITER_CHECK:%.*]], label [[FOR_END:%.*]]
; CHECK:       iter.check:
; CHECK-NEXT:    [[TMP0:%.*]] = add i32 [[N]], -1
; CHECK-NEXT:    [[WIDE_TRIP_COUNT:%.*]] = zext i32 [[TMP0]] to i64
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 [[WIDE_TRIP_COUNT]], 4
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[VEC_EPILOG_SCALAR_PH:%.*]], label [[VECTOR_SCEVCHECK:%.*]]
; CHECK:       vector.scevcheck:
; CHECK-NEXT:    [[TMP1:%.*]] = add nsw i64 [[WIDE_TRIP_COUNT]], -1
; CHECK-NEXT:    [[TMP2:%.*]] = trunc i64 [[TMP1]] to i32
; CHECK-NEXT:    [[MUL:%.*]] = call { i32, i1 } @llvm.umul.with.overflow.i32(i32 1, i32 [[TMP2]])
; CHECK-NEXT:    [[MUL_RESULT:%.*]] = extractvalue { i32, i1 } [[MUL]], 0
; CHECK-NEXT:    [[MUL_OVERFLOW:%.*]] = extractvalue { i32, i1 } [[MUL]], 1
; CHECK-NEXT:    [[TMP3:%.*]] = add i32 [[TMP0]], [[MUL_RESULT]]
; CHECK-NEXT:    [[TMP4:%.*]] = sub i32 [[TMP0]], [[MUL_RESULT]]
; CHECK-NEXT:    [[TMP5:%.*]] = icmp sgt i32 [[TMP4]], [[TMP0]]
; CHECK-NEXT:    [[TMP6:%.*]] = icmp slt i32 [[TMP3]], [[TMP0]]
; CHECK-NEXT:    [[TMP7:%.*]] = select i1 true, i1 [[TMP5]], i1 [[TMP6]]
; CHECK-NEXT:    [[TMP8:%.*]] = icmp ugt i64 [[TMP1]], 4294967295
; CHECK-NEXT:    [[TMP9:%.*]] = or i1 [[TMP7]], [[TMP8]]
; CHECK-NEXT:    [[TMP10:%.*]] = or i1 [[TMP9]], [[MUL_OVERFLOW]]
; CHECK-NEXT:    [[TMP11:%.*]] = or i1 false, [[TMP10]]
; CHECK-NEXT:    br i1 [[TMP11]], label [[VEC_EPILOG_SCALAR_PH]], label [[VECTOR_MEMCHECK:%.*]]
; CHECK:       vector.memcheck:
; CHECK-NEXT:    [[SCEVGEP:%.*]] = getelementptr float, float* [[A]], i64 [[WIDE_TRIP_COUNT]]
; CHECK-NEXT:    [[SCEVGEP2:%.*]] = bitcast float* [[SCEVGEP]] to i8*
; CHECK-NEXT:    [[TMP12:%.*]] = sext i32 [[TMP0]] to i64
; CHECK-NEXT:    [[TMP13:%.*]] = add i64 [[TMP12]], 1
; CHECK-NEXT:    [[TMP14:%.*]] = sub i64 [[TMP13]], [[WIDE_TRIP_COUNT]]
; CHECK-NEXT:    [[SCEVGEP3:%.*]] = getelementptr float, float* [[B:%.*]], i64 [[TMP14]]
; CHECK-NEXT:    [[SCEVGEP34:%.*]] = bitcast float* [[SCEVGEP3]] to i8*
; CHECK-NEXT:    [[TMP15:%.*]] = add nsw i64 [[TMP12]], 1
; CHECK-NEXT:    [[SCEVGEP5:%.*]] = getelementptr float, float* [[B]], i64 [[TMP15]]
; CHECK-NEXT:    [[SCEVGEP56:%.*]] = bitcast float* [[SCEVGEP5]] to i8*
; CHECK-NEXT:    [[BOUND0:%.*]] = icmp ult i8* [[A1]], [[SCEVGEP56]]
; CHECK-NEXT:    [[BOUND1:%.*]] = icmp ult i8* [[SCEVGEP34]], [[SCEVGEP2]]
; CHECK-NEXT:    [[FOUND_CONFLICT:%.*]] = and i1 [[BOUND0]], [[BOUND1]]
; CHECK-NEXT:    [[MEMCHECK_CONFLICT:%.*]] = and i1 [[FOUND_CONFLICT]], true
; CHECK-NEXT:    br i1 [[MEMCHECK_CONFLICT]], label [[VEC_EPILOG_SCALAR_PH]], label [[VECTOR_MAIN_LOOP_ITER_CHECK:%.*]]
; CHECK:       vector.main.loop.iter.check:
; CHECK-NEXT:    [[MIN_ITERS_CHECK7:%.*]] = icmp ult i64 [[WIDE_TRIP_COUNT]], 4
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK7]], label [[VEC_EPILOG_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i64 [[WIDE_TRIP_COUNT]], 4
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i64 [[WIDE_TRIP_COUNT]], [[N_MOD_VF]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP16:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[OFFSET_IDX:%.*]] = trunc i64 [[INDEX]] to i32
; CHECK-NEXT:    [[TMP17:%.*]] = add i32 [[OFFSET_IDX]], 0
; CHECK-NEXT:    [[TMP18:%.*]] = xor i32 [[TMP17]], -1
; CHECK-NEXT:    [[TMP19:%.*]] = add i32 [[TMP18]], [[N]]
; CHECK-NEXT:    [[TMP20:%.*]] = sext i32 [[TMP19]] to i64
; CHECK-NEXT:    [[TMP21:%.*]] = getelementptr inbounds float, float* [[B]], i64 [[TMP20]]
; CHECK-NEXT:    [[TMP22:%.*]] = getelementptr inbounds float, float* [[TMP21]], i32 0
; CHECK-NEXT:    [[TMP23:%.*]] = getelementptr inbounds float, float* [[TMP22]], i32 -3
; CHECK-NEXT:    [[TMP24:%.*]] = bitcast float* [[TMP23]] to <4 x float>*
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <4 x float>, <4 x float>* [[TMP24]], align 4, !alias.scope !13
; CHECK-NEXT:    [[REVERSE:%.*]] = shufflevector <4 x float> [[WIDE_LOAD]], <4 x float> poison, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:    [[TMP25:%.*]] = fadd fast <4 x float> [[REVERSE]], <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>
; CHECK-NEXT:    [[TMP26:%.*]] = getelementptr inbounds float, float* [[A]], i64 [[TMP16]]
; CHECK-NEXT:    [[TMP27:%.*]] = getelementptr inbounds float, float* [[TMP26]], i32 0
; CHECK-NEXT:    [[TMP28:%.*]] = bitcast float* [[TMP27]] to <4 x float>*
; CHECK-NEXT:    store <4 x float> [[TMP25]], <4 x float>* [[TMP28]], align 4, !alias.scope !16, !noalias !13
; CHECK-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 4
; CHECK-NEXT:    [[TMP29:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP29]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], [[LOOP18:!llvm.loop !.*]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 [[WIDE_TRIP_COUNT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_END_LOOPEXIT:%.*]], label [[VEC_EPILOG_ITER_CHECK:%.*]]
; CHECK:       vec.epilog.iter.check:
; CHECK-NEXT:    [[IND_END13:%.*]] = trunc i64 [[N_VEC]] to i32
; CHECK-NEXT:    [[N_VEC_REMAINING:%.*]] = sub i64 [[WIDE_TRIP_COUNT]], [[N_VEC]]
; CHECK-NEXT:    [[MIN_EPILOG_ITERS_CHECK:%.*]] = icmp ult i64 [[N_VEC_REMAINING]], 4
; CHECK-NEXT:    br i1 [[MIN_EPILOG_ITERS_CHECK]], label [[VEC_EPILOG_SCALAR_PH]], label [[VEC_EPILOG_PH]]
; CHECK:       vec.epilog.ph:
; CHECK-NEXT:    [[VEC_EPILOG_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[VEC_EPILOG_ITER_CHECK]] ], [ 0, [[VECTOR_MAIN_LOOP_ITER_CHECK]] ]
; CHECK-NEXT:    [[N_MOD_VF8:%.*]] = urem i64 [[WIDE_TRIP_COUNT]], 4
; CHECK-NEXT:    [[N_VEC9:%.*]] = sub i64 [[WIDE_TRIP_COUNT]], [[N_MOD_VF8]]
; CHECK-NEXT:    [[IND_END:%.*]] = trunc i64 [[N_VEC9]] to i32
; CHECK-NEXT:    br label [[VEC_EPILOG_VECTOR_BODY:%.*]]
; CHECK:       vec.epilog.vector.body:
; CHECK-NEXT:    [[INDEX10:%.*]] = phi i64 [ [[VEC_EPILOG_RESUME_VAL]], [[VEC_EPILOG_PH]] ], [ [[INDEX_NEXT11:%.*]], [[VEC_EPILOG_VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP30:%.*]] = add i64 [[INDEX10]], 0
; CHECK-NEXT:    [[OFFSET_IDX15:%.*]] = trunc i64 [[INDEX10]] to i32
; CHECK-NEXT:    [[TMP31:%.*]] = add i32 [[OFFSET_IDX15]], 0
; CHECK-NEXT:    [[TMP32:%.*]] = xor i32 [[TMP31]], -1
; CHECK-NEXT:    [[TMP33:%.*]] = add i32 [[TMP32]], [[N]]
; CHECK-NEXT:    [[TMP34:%.*]] = sext i32 [[TMP33]] to i64
; CHECK-NEXT:    [[TMP35:%.*]] = getelementptr inbounds float, float* [[B]], i64 [[TMP34]]
; CHECK-NEXT:    [[TMP36:%.*]] = getelementptr inbounds float, float* [[TMP35]], i32 0
; CHECK-NEXT:    [[TMP37:%.*]] = getelementptr inbounds float, float* [[TMP36]], i32 -3
; CHECK-NEXT:    [[TMP38:%.*]] = bitcast float* [[TMP37]] to <4 x float>*
; CHECK-NEXT:    [[WIDE_LOAD16:%.*]] = load <4 x float>, <4 x float>* [[TMP38]], align 4
; CHECK-NEXT:    [[REVERSE17:%.*]] = shufflevector <4 x float> [[WIDE_LOAD16]], <4 x float> poison, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:    [[TMP39:%.*]] = fadd fast <4 x float> [[REVERSE17]], <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>
; CHECK-NEXT:    [[TMP40:%.*]] = getelementptr inbounds float, float* [[A]], i64 [[TMP30]]
; CHECK-NEXT:    [[TMP41:%.*]] = getelementptr inbounds float, float* [[TMP40]], i32 0
; CHECK-NEXT:    [[TMP42:%.*]] = bitcast float* [[TMP41]] to <4 x float>*
; CHECK-NEXT:    store <4 x float> [[TMP39]], <4 x float>* [[TMP42]], align 4
; CHECK-NEXT:    [[INDEX_NEXT11]] = add i64 [[INDEX10]], 4
; CHECK-NEXT:    [[TMP43:%.*]] = icmp eq i64 [[INDEX_NEXT11]], [[N_VEC9]]
; CHECK-NEXT:    br i1 [[TMP43]], label [[VEC_EPILOG_MIDDLE_BLOCK:%.*]], label [[VEC_EPILOG_VECTOR_BODY]], [[LOOP19:!llvm.loop !.*]]
; CHECK:       vec.epilog.middle.block:
; CHECK-NEXT:    [[CMP_N14:%.*]] = icmp eq i64 [[WIDE_TRIP_COUNT]], [[N_VEC9]]
; CHECK-NEXT:    br i1 [[CMP_N14]], label [[FOR_END_LOOPEXIT_LOOPEXIT:%.*]], label [[VEC_EPILOG_SCALAR_PH]]
; CHECK:       vec.epilog.scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC9]], [[VEC_EPILOG_MIDDLE_BLOCK]] ], [ [[N_VEC]], [[VEC_EPILOG_ITER_CHECK]] ], [ 0, [[VECTOR_SCEVCHECK]] ], [ 0, [[VECTOR_MEMCHECK]] ], [ 0, [[ITER_CHECK]] ]
; CHECK-NEXT:    [[BC_RESUME_VAL12:%.*]] = phi i32 [ [[IND_END]], [[VEC_EPILOG_MIDDLE_BLOCK]] ], [ [[IND_END13]], [[VEC_EPILOG_ITER_CHECK]] ], [ 0, [[VECTOR_SCEVCHECK]] ], [ 0, [[VECTOR_MEMCHECK]] ], [ 0, [[ITER_CHECK]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[VEC_EPILOG_SCALAR_PH]] ], [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[I_014:%.*]] = phi i32 [ [[BC_RESUME_VAL12]], [[VEC_EPILOG_SCALAR_PH]] ], [ [[INC:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[TMP44:%.*]] = xor i32 [[I_014]], -1
; CHECK-NEXT:    [[SUB2:%.*]] = add i32 [[TMP44]], [[N]]
; CHECK-NEXT:    [[IDXPROM:%.*]] = sext i32 [[SUB2]] to i64
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds float, float* [[B]], i64 [[IDXPROM]]
; CHECK-NEXT:    [[TMP45:%.*]] = load float, float* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[CONV3:%.*]] = fadd fast float [[TMP45]], 1.000000e+00
; CHECK-NEXT:    [[ARRAYIDX5:%.*]] = getelementptr inbounds float, float* [[A]], i64 [[INDVARS_IV]]
; CHECK-NEXT:    store float [[CONV3]], float* [[ARRAYIDX5]], align 4
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[INC]] = add nuw nsw i32 [[I_014]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp ne i64 [[INDVARS_IV_NEXT]], [[WIDE_TRIP_COUNT]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_BODY]], label [[FOR_END_LOOPEXIT_LOOPEXIT]], [[LOOP20:!llvm.loop !.*]]
; CHECK:       for.end.loopexit.loopexit:
; CHECK-NEXT:    br label [[FOR_END_LOOPEXIT]]
; CHECK:       for.end.loopexit:
; CHECK-NEXT:    br label [[FOR_END]]
; CHECK:       for.end:
; CHECK-NEXT:    ret i32 0
;
; CHECK-PROFITABLE-BY-DEFAULT-LABEL: @f2(
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:  entry:
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[CMP1:%.*]] = icmp sgt i32 [[N:%.*]], 1
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    br i1 [[CMP1]], label [[FOR_BODY_PREHEADER:%.*]], label [[FOR_END:%.*]]
; CHECK-PROFITABLE-BY-DEFAULT:       for.body.preheader:
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[TMP0:%.*]] = add i32 [[N]], -1
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[WIDE_TRIP_COUNT:%.*]] = zext i32 [[TMP0]] to i64
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK-PROFITABLE-BY-DEFAULT:       for.body:
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ 0, [[FOR_BODY_PREHEADER]] ], [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY]] ]
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[I_014:%.*]] = phi i32 [ 0, [[FOR_BODY_PREHEADER]] ], [ [[INC:%.*]], [[FOR_BODY]] ]
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[TMP1:%.*]] = xor i32 [[I_014]], -1
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[SUB2:%.*]] = add i32 [[TMP1]], [[N]]
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[IDXPROM:%.*]] = sext i32 [[SUB2]] to i64
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds float, float* [[B:%.*]], i64 [[IDXPROM]]
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[TMP2:%.*]] = load float, float* [[ARRAYIDX]], align 4
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[CONV3:%.*]] = fadd fast float [[TMP2]], 1.000000e+00
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[ARRAYIDX5:%.*]] = getelementptr inbounds float, float* [[A:%.*]], i64 [[INDVARS_IV]]
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    store float [[CONV3]], float* [[ARRAYIDX5]], align 4
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[INC]] = add nuw nsw i32 [[I_014]], 1
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[EXITCOND:%.*]] = icmp ne i64 [[INDVARS_IV_NEXT]], [[WIDE_TRIP_COUNT]]
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    br i1 [[EXITCOND]], label [[FOR_BODY]], label [[FOR_END_LOOPEXIT:%.*]]
; CHECK-PROFITABLE-BY-DEFAULT:       for.end.loopexit:
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    br label [[FOR_END]]
; CHECK-PROFITABLE-BY-DEFAULT:       for.end:
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    ret i32 0
;
entry:
  %cmp1 = icmp sgt i32 %n, 1
  br i1 %cmp1, label %for.body.preheader, label %for.end

for.body.preheader:                               ; preds = %entry
  %0 = add i32 %n, -1
  %wide.trip.count = zext i32 %0 to i64
  br label %for.body

for.body:                                         ; preds = %for.body.preheader, %for.body
  %indvars.iv = phi i64 [ 0, %for.body.preheader ], [ %indvars.iv.next, %for.body ]
  %i.014 = phi i32 [ 0, %for.body.preheader ], [ %inc, %for.body ]
  %1 = xor i32 %i.014, -1
  %sub2 = add i32 %1, %n
  %idxprom = sext i32 %sub2 to i64
  %arrayidx = getelementptr inbounds float, float* %B, i64 %idxprom
  %2 = load float, float* %arrayidx, align 4
  %conv3 = fadd fast float %2, 1.000000e+00
  %arrayidx5 = getelementptr inbounds float, float* %A, i64 %indvars.iv
  store float %conv3, float* %arrayidx5, align 4
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %inc = add nuw nsw i32 %i.014, 1
  %exitcond = icmp ne i64 %indvars.iv.next, %wide.trip.count
  br i1 %exitcond, label %for.body, label %for.end.loopexit

for.end.loopexit:                                 ; preds = %for.body
  br label %for.end

for.end:                                          ; preds = %for.end.loopexit, %entry
  ret i32 0
}

define void @f3(i8* noalias %A, i64 %n) {
; CHECK-LABEL: @f3(
; CHECK-NEXT:  iter.check:
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 [[N:%.*]], 4
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[VEC_EPILOG_SCALAR_PH:%.*]], label [[VECTOR_MAIN_LOOP_ITER_CHECK:%.*]]
; CHECK:       vector.main.loop.iter.check:
; CHECK-NEXT:    [[MIN_ITERS_CHECK1:%.*]] = icmp ult i64 [[N]], 4
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK1]], label [[VEC_EPILOG_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i64 [[N]], 4
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i64 [[N]], [[N_MOD_VF]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds i8, i8* [[A:%.*]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i8, i8* [[TMP1]], i32 0
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast i8* [[TMP2]] to <4 x i8>*
; CHECK-NEXT:    store <4 x i8> <i8 1, i8 1, i8 1, i8 1>, <4 x i8>* [[TMP3]], align 1
; CHECK-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 4
; CHECK-NEXT:    [[TMP4:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP4]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], [[LOOP21:!llvm.loop !.*]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 [[N]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_END_LOOPEXIT:%.*]], label [[VEC_EPILOG_ITER_CHECK:%.*]]
; CHECK:       vec.epilog.iter.check:
; CHECK-NEXT:    [[N_VEC_REMAINING:%.*]] = sub i64 [[N]], [[N_VEC]]
; CHECK-NEXT:    [[MIN_EPILOG_ITERS_CHECK:%.*]] = icmp ult i64 [[N_VEC_REMAINING]], 4
; CHECK-NEXT:    br i1 [[MIN_EPILOG_ITERS_CHECK]], label [[VEC_EPILOG_SCALAR_PH]], label [[VEC_EPILOG_PH]]
; CHECK:       vec.epilog.ph:
; CHECK-NEXT:    [[VEC_EPILOG_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[VEC_EPILOG_ITER_CHECK]] ], [ 0, [[VECTOR_MAIN_LOOP_ITER_CHECK]] ]
; CHECK-NEXT:    [[N_MOD_VF2:%.*]] = urem i64 [[N]], 4
; CHECK-NEXT:    [[N_VEC3:%.*]] = sub i64 [[N]], [[N_MOD_VF2]]
; CHECK-NEXT:    br label [[VEC_EPILOG_VECTOR_BODY:%.*]]
; CHECK:       vec.epilog.vector.body:
; CHECK-NEXT:    [[INDEX4:%.*]] = phi i64 [ [[VEC_EPILOG_RESUME_VAL]], [[VEC_EPILOG_PH]] ], [ [[INDEX_NEXT5:%.*]], [[VEC_EPILOG_VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP5:%.*]] = add i64 [[INDEX4]], 0
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr inbounds i8, i8* [[A]], i64 [[TMP5]]
; CHECK-NEXT:    [[TMP7:%.*]] = getelementptr inbounds i8, i8* [[TMP6]], i32 0
; CHECK-NEXT:    [[TMP8:%.*]] = bitcast i8* [[TMP7]] to <4 x i8>*
; CHECK-NEXT:    store <4 x i8> <i8 1, i8 1, i8 1, i8 1>, <4 x i8>* [[TMP8]], align 1
; CHECK-NEXT:    [[INDEX_NEXT5]] = add i64 [[INDEX4]], 4
; CHECK-NEXT:    [[TMP9:%.*]] = icmp eq i64 [[INDEX_NEXT5]], [[N_VEC3]]
; CHECK-NEXT:    br i1 [[TMP9]], label [[VEC_EPILOG_MIDDLE_BLOCK:%.*]], label [[VEC_EPILOG_VECTOR_BODY]], [[LOOP22:!llvm.loop !.*]]
; CHECK:       vec.epilog.middle.block:
; CHECK-NEXT:    [[CMP_N6:%.*]] = icmp eq i64 [[N]], [[N_VEC3]]
; CHECK-NEXT:    br i1 [[CMP_N6]], label [[FOR_END_LOOPEXIT_LOOPEXIT:%.*]], label [[VEC_EPILOG_SCALAR_PH]]
; CHECK:       vec.epilog.scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC3]], [[VEC_EPILOG_MIDDLE_BLOCK]] ], [ [[N_VEC]], [[VEC_EPILOG_ITER_CHECK]] ], [ 0, [[ITER_CHECK:%.*]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[VEC_EPILOG_SCALAR_PH]] ], [ [[IV_NEXT:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i8, i8* [[A]], i64 [[IV]]
; CHECK-NEXT:    store i8 1, i8* [[ARRAYIDX]], align 1
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp ne i64 [[IV_NEXT]], [[N]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_BODY]], label [[FOR_END_LOOPEXIT_LOOPEXIT]], [[LOOP23:!llvm.loop !.*]]
; CHECK:       for.end.loopexit.loopexit:
; CHECK-NEXT:    br label [[FOR_END_LOOPEXIT]]
; CHECK:       for.end.loopexit:
; CHECK-NEXT:    br label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
; CHECK-PROFITABLE-BY-DEFAULT-LABEL: @f3(
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:  iter.check:
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 [[N:%.*]], 2
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[VEC_EPILOG_SCALAR_PH:%.*]], label [[VECTOR_MAIN_LOOP_ITER_CHECK:%.*]]
; CHECK-PROFITABLE-BY-DEFAULT:       vector.main.loop.iter.check:
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[MIN_ITERS_CHECK1:%.*]] = icmp ult i64 [[N]], 4
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    br i1 [[MIN_ITERS_CHECK1]], label [[VEC_EPILOG_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK-PROFITABLE-BY-DEFAULT:       vector.ph:
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[N_MOD_VF:%.*]] = urem i64 [[N]], 4
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[N_VEC:%.*]] = sub i64 [[N]], [[N_MOD_VF]]
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK-PROFITABLE-BY-DEFAULT:       vector.body:
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[TMP0:%.*]] = add i64 [[INDEX]], 0
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[TMP1:%.*]] = getelementptr inbounds i8, i8* [[A:%.*]], i64 [[TMP0]]
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i8, i8* [[TMP1]], i32 0
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[TMP3:%.*]] = bitcast i8* [[TMP2]] to <4 x i8>*
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    store <4 x i8> <i8 1, i8 1, i8 1, i8 1>, <4 x i8>* [[TMP3]], align 1
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 4
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[TMP4:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    br i1 [[TMP4]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], [[LOOP0:!llvm.loop !.*]]
; CHECK-PROFITABLE-BY-DEFAULT:       middle.block:
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[CMP_N:%.*]] = icmp eq i64 [[N]], [[N_VEC]]
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    br i1 [[CMP_N]], label [[FOR_END_LOOPEXIT:%.*]], label [[VEC_EPILOG_ITER_CHECK:%.*]]
; CHECK-PROFITABLE-BY-DEFAULT:       vec.epilog.iter.check:
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[N_VEC_REMAINING:%.*]] = sub i64 [[N]], [[N_VEC]]
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[MIN_EPILOG_ITERS_CHECK:%.*]] = icmp ult i64 [[N_VEC_REMAINING]], 2
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    br i1 [[MIN_EPILOG_ITERS_CHECK]], label [[VEC_EPILOG_SCALAR_PH]], label [[VEC_EPILOG_PH]]
; CHECK-PROFITABLE-BY-DEFAULT:       vec.epilog.ph:
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[VEC_EPILOG_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[VEC_EPILOG_ITER_CHECK]] ], [ 0, [[VECTOR_MAIN_LOOP_ITER_CHECK]] ]
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[N_MOD_VF2:%.*]] = urem i64 [[N]], 2
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[N_VEC3:%.*]] = sub i64 [[N]], [[N_MOD_VF2]]
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    br label [[VEC_EPILOG_VECTOR_BODY:%.*]]
; CHECK-PROFITABLE-BY-DEFAULT:       vec.epilog.vector.body:
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[INDEX4:%.*]] = phi i64 [ [[VEC_EPILOG_RESUME_VAL]], [[VEC_EPILOG_PH]] ], [ [[INDEX_NEXT5:%.*]], [[VEC_EPILOG_VECTOR_BODY]] ]
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[TMP5:%.*]] = add i64 [[INDEX4]], 0
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[TMP6:%.*]] = getelementptr inbounds i8, i8* [[A]], i64 [[TMP5]]
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[TMP7:%.*]] = getelementptr inbounds i8, i8* [[TMP6]], i32 0
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[TMP8:%.*]] = bitcast i8* [[TMP7]] to <2 x i8>*
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    store <2 x i8> <i8 1, i8 1>, <2 x i8>* [[TMP8]], align 1
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[INDEX_NEXT5]] = add i64 [[INDEX4]], 2
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[TMP9:%.*]] = icmp eq i64 [[INDEX_NEXT5]], [[N_VEC3]]
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    br i1 [[TMP9]], label [[VEC_EPILOG_MIDDLE_BLOCK:%.*]], label [[VEC_EPILOG_VECTOR_BODY]], [[LOOP2:!llvm.loop !.*]]
; CHECK-PROFITABLE-BY-DEFAULT:       vec.epilog.middle.block:
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[CMP_N6:%.*]] = icmp eq i64 [[N]], [[N_VEC3]]
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    br i1 [[CMP_N6]], label [[FOR_END_LOOPEXIT_LOOPEXIT:%.*]], label [[VEC_EPILOG_SCALAR_PH]]
; CHECK-PROFITABLE-BY-DEFAULT:       vec.epilog.scalar.ph:
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC3]], [[VEC_EPILOG_MIDDLE_BLOCK]] ], [ [[N_VEC]], [[VEC_EPILOG_ITER_CHECK]] ], [ 0, [[ITER_CHECK:%.*]] ]
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK-PROFITABLE-BY-DEFAULT:       for.body:
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[VEC_EPILOG_SCALAR_PH]] ], [ [[IV_NEXT:%.*]], [[FOR_BODY]] ]
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i8, i8* [[A]], i64 [[IV]]
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    store i8 1, i8* [[ARRAYIDX]], align 1
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[IV_NEXT]] = add nuw nsw i64 [[IV]], 1
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    [[EXITCOND:%.*]] = icmp ne i64 [[IV_NEXT]], [[N]]
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    br i1 [[EXITCOND]], label [[FOR_BODY]], label [[FOR_END_LOOPEXIT_LOOPEXIT]], [[LOOP4:!llvm.loop !.*]]
; CHECK-PROFITABLE-BY-DEFAULT:       for.end.loopexit.loopexit:
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    br label [[FOR_END_LOOPEXIT]]
; CHECK-PROFITABLE-BY-DEFAULT:       for.end.loopexit:
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    br label [[FOR_END:%.*]]
; CHECK-PROFITABLE-BY-DEFAULT:       for.end:
; CHECK-PROFITABLE-BY-DEFAULT-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %for.body.preheader, %for.body
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %arrayidx = getelementptr inbounds i8, i8* %A, i64 %iv
  store i8 1, i8* %arrayidx, align 1
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp ne i64 %iv.next, %n
  br i1 %exitcond, label %for.body, label %for.end.loopexit

for.end.loopexit:                                 ; preds = %for.body
  br label %for.end

for.end:                                          ; preds = %for.end.loopexit, %entry
  ret void
}
