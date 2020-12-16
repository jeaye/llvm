; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve -tail-predication=enabled -loop-vectorize -instcombine -simplifycfg -simplifycfg-require-and-preserve-domtree=1 %s -S -o - | FileCheck %s

target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"

define arm_aapcs_vfpcc i32 @minmaxval4(i32* nocapture readonly %x, i32* nocapture %minp, i32 %N) {
; CHECK-LABEL: @minmaxval4(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP26_NOT:%.*]] = icmp eq i32 [[N:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP26_NOT]], label [[FOR_COND_CLEANUP:%.*]], label [[FOR_BODY_PREHEADER:%.*]]
; CHECK:       for.body.preheader:
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i32 [[N]], 4
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_VEC:%.*]] = and i32 [[N]], -4
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_PHI:%.*]] = phi <4 x i32> [ <i32 2147483647, i32 2147483647, i32 2147483647, i32 2147483647>, [[VECTOR_PH]] ], [ [[TMP5:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_PHI1:%.*]] = phi <4 x i32> [ <i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 -2147483648>, [[VECTOR_PH]] ], [ [[TMP3:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = getelementptr inbounds i32, i32* [[X:%.*]], i32 [[INDEX]]
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i32* [[TMP0]] to <4 x i32>*
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <4 x i32>, <4 x i32>* [[TMP1]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = icmp sgt <4 x i32> [[WIDE_LOAD]], [[VEC_PHI1]]
; CHECK-NEXT:    [[TMP3]] = select <4 x i1> [[TMP2]], <4 x i32> [[WIDE_LOAD]], <4 x i32> [[VEC_PHI1]]
; CHECK-NEXT:    [[TMP4:%.*]] = icmp slt <4 x i32> [[WIDE_LOAD]], [[VEC_PHI]]
; CHECK-NEXT:    [[TMP5]] = select <4 x i1> [[TMP4]], <4 x i32> [[WIDE_LOAD]], <4 x i32> [[VEC_PHI]]
; CHECK-NEXT:    [[INDEX_NEXT]] = add i32 [[INDEX]], 4
; CHECK-NEXT:    [[TMP6:%.*]] = icmp eq i32 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP6]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], [[LOOP0:!llvm.loop !.*]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[TMP7:%.*]] = call i32 @llvm.vector.reduce.smax.v4i32(<4 x i32> [[TMP3]])
; CHECK-NEXT:    [[TMP8:%.*]] = call i32 @llvm.vector.reduce.smin.v4i32(<4 x i32> [[TMP5]])
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i32 [[N_VEC]], [[N]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_COND_CLEANUP]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i32 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[FOR_BODY_PREHEADER]] ]
; CHECK-NEXT:    [[BC_MERGE_RDX:%.*]] = phi i32 [ [[TMP8]], [[MIDDLE_BLOCK]] ], [ 2147483647, [[FOR_BODY_PREHEADER]] ]
; CHECK-NEXT:    [[BC_MERGE_RDX2:%.*]] = phi i32 [ [[TMP7]], [[MIDDLE_BLOCK]] ], [ -2147483648, [[FOR_BODY_PREHEADER]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.cond.cleanup:
; CHECK-NEXT:    [[MAX_0_LCSSA:%.*]] = phi i32 [ -2147483648, [[ENTRY:%.*]] ], [ [[COND:%.*]], [[FOR_BODY]] ], [ [[TMP7]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    [[MIN_0_LCSSA:%.*]] = phi i32 [ 2147483647, [[ENTRY]] ], [ [[COND9:%.*]], [[FOR_BODY]] ], [ [[TMP8]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    store i32 [[MIN_0_LCSSA]], i32* [[MINP:%.*]], align 4
; CHECK-NEXT:    ret i32 [[MAX_0_LCSSA]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I_029:%.*]] = phi i32 [ [[INC:%.*]], [[FOR_BODY]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[MIN_028:%.*]] = phi i32 [ [[COND9]], [[FOR_BODY]] ], [ [[BC_MERGE_RDX]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[MAX_027:%.*]] = phi i32 [ [[COND]], [[FOR_BODY]] ], [ [[BC_MERGE_RDX2]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[X]], i32 [[I_029]]
; CHECK-NEXT:    [[TMP9:%.*]] = load i32, i32* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[CMP1:%.*]] = icmp sgt i32 [[TMP9]], [[MAX_027]]
; CHECK-NEXT:    [[COND]] = select i1 [[CMP1]], i32 [[TMP9]], i32 [[MAX_027]]
; CHECK-NEXT:    [[CMP4:%.*]] = icmp slt i32 [[TMP9]], [[MIN_028]]
; CHECK-NEXT:    [[COND9]] = select i1 [[CMP4]], i32 [[TMP9]], i32 [[MIN_028]]
; CHECK-NEXT:    [[INC]] = add nuw i32 [[I_029]], 1
; CHECK-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i32 [[INC]], [[N]]
; CHECK-NEXT:    br i1 [[EXITCOND_NOT]], label [[FOR_COND_CLEANUP]], label [[FOR_BODY]], [[LOOP2:!llvm.loop !.*]]
;
entry:
  %cmp26.not = icmp eq i32 %N, 0
  br i1 %cmp26.not, label %for.cond.cleanup, label %for.body

for.cond.cleanup:                                 ; preds = %for.body, %entry
  %max.0.lcssa = phi i32 [ -2147483648, %entry ], [ %cond, %for.body ]
  %min.0.lcssa = phi i32 [ 2147483647, %entry ], [ %cond9, %for.body ]
  store i32 %min.0.lcssa, i32* %minp, align 4
  ret i32 %max.0.lcssa

for.body:                                         ; preds = %entry, %for.body
  %i.029 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %min.028 = phi i32 [ %cond9, %for.body ], [ 2147483647, %entry ]
  %max.027 = phi i32 [ %cond, %for.body ], [ -2147483648, %entry ]
  %arrayidx = getelementptr inbounds i32, i32* %x, i32 %i.029
  %0 = load i32, i32* %arrayidx, align 4
  %cmp1 = icmp sgt i32 %0, %max.027
  %cond = select i1 %cmp1, i32 %0, i32 %max.027
  %cmp4 = icmp slt i32 %0, %min.028
  %cond9 = select i1 %cmp4, i32 %0, i32 %min.028
  %inc = add nuw i32 %i.029, 1
  %exitcond.not = icmp eq i32 %inc, %N
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body
}

