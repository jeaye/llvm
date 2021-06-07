; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -mcpu=bdver1 -loop-vectorize -instcombine -simplifycfg < %s -S -o - | FileCheck %s --check-prefix=CHECK
; RUN: opt -mcpu=bdver1 -loop-vectorize -debug-only=loop-vectorize -disable-output < %s 2>&1 | FileCheck %s --check-prefix=CHECK-COST
; REQUIRES: asserts

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; CHECK-COST-LABEL: uaddsat
; CHECK-COST: Found an estimated cost of 2 for VF 1 For instruction:   %1 = tail call i16 @llvm.uadd.sat.i16(i16 %0, i16 %offset)
; CHECK-COST: Found an estimated cost of 1 for VF 2 For instruction:   %1 = tail call i16 @llvm.uadd.sat.i16(i16 %0, i16 %offset)
; CHECK-COST: Found an estimated cost of 1 for VF 4 For instruction:   %1 = tail call i16 @llvm.uadd.sat.i16(i16 %0, i16 %offset)
; CHECK-COST: Found an estimated cost of 1 for VF 8 For instruction:   %1 = tail call i16 @llvm.uadd.sat.i16(i16 %0, i16 %offset)
; CHECK-COST: Found an estimated cost of 4 for VF 16 For instruction:   %1 = tail call i16 @llvm.uadd.sat.i16(i16 %0, i16 %offset)

define void @uaddsat(i16* nocapture readonly %pSrc, i16 signext %offset, i16* nocapture noalias %pDst, i32 %blockSize) #0 {
; CHECK-LABEL: @uaddsat(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP_NOT6:%.*]] = icmp eq i32 [[BLOCKSIZE:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP_NOT6]], label [[WHILE_END:%.*]], label [[ITER_CHECK:%.*]]
; CHECK:       iter.check:
; CHECK-NEXT:    [[TMP0:%.*]] = add i32 [[BLOCKSIZE]], -1
; CHECK-NEXT:    [[TMP1:%.*]] = zext i32 [[TMP0]] to i64
; CHECK-NEXT:    [[TMP2:%.*]] = add nuw nsw i64 [[TMP1]], 1
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i32 [[TMP0]], 7
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[VEC_EPILOG_SCALAR_PH:%.*]], label [[VECTOR_MAIN_LOOP_ITER_CHECK:%.*]]
; CHECK:       vector.main.loop.iter.check:
; CHECK-NEXT:    [[MIN_ITERS_CHECK1:%.*]] = icmp ult i32 [[TMP0]], 63
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK1]], label [[VEC_EPILOG_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_VEC:%.*]] = and i64 [[TMP2]], 8589934528
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <16 x i16> poison, i16 [[OFFSET:%.*]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <16 x i16> [[BROADCAST_SPLATINSERT]], <16 x i16> poison, <16 x i32> zeroinitializer
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT12:%.*]] = insertelement <16 x i16> poison, i16 [[OFFSET]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT13:%.*]] = shufflevector <16 x i16> [[BROADCAST_SPLATINSERT12]], <16 x i16> poison, <16 x i32> zeroinitializer
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT14:%.*]] = insertelement <16 x i16> poison, i16 [[OFFSET]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT15:%.*]] = shufflevector <16 x i16> [[BROADCAST_SPLATINSERT14]], <16 x i16> poison, <16 x i32> zeroinitializer
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT16:%.*]] = insertelement <16 x i16> poison, i16 [[OFFSET]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT17:%.*]] = shufflevector <16 x i16> [[BROADCAST_SPLATINSERT16]], <16 x i16> poison, <16 x i32> zeroinitializer
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[NEXT_GEP:%.*]] = getelementptr i16, i16* [[PSRC:%.*]], i64 [[INDEX]]
; CHECK-NEXT:    [[NEXT_GEP5:%.*]] = getelementptr i16, i16* [[PDST:%.*]], i64 [[INDEX]]
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast i16* [[NEXT_GEP]] to <16 x i16>*
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <16 x i16>, <16 x i16>* [[TMP3]], align 2
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr i16, i16* [[NEXT_GEP]], i64 16
; CHECK-NEXT:    [[TMP5:%.*]] = bitcast i16* [[TMP4]] to <16 x i16>*
; CHECK-NEXT:    [[WIDE_LOAD9:%.*]] = load <16 x i16>, <16 x i16>* [[TMP5]], align 2
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr i16, i16* [[NEXT_GEP]], i64 32
; CHECK-NEXT:    [[TMP7:%.*]] = bitcast i16* [[TMP6]] to <16 x i16>*
; CHECK-NEXT:    [[WIDE_LOAD10:%.*]] = load <16 x i16>, <16 x i16>* [[TMP7]], align 2
; CHECK-NEXT:    [[TMP8:%.*]] = getelementptr i16, i16* [[NEXT_GEP]], i64 48
; CHECK-NEXT:    [[TMP9:%.*]] = bitcast i16* [[TMP8]] to <16 x i16>*
; CHECK-NEXT:    [[WIDE_LOAD11:%.*]] = load <16 x i16>, <16 x i16>* [[TMP9]], align 2
; CHECK-NEXT:    [[TMP10:%.*]] = call <16 x i16> @llvm.uadd.sat.v16i16(<16 x i16> [[WIDE_LOAD]], <16 x i16> [[BROADCAST_SPLAT]])
; CHECK-NEXT:    [[TMP11:%.*]] = call <16 x i16> @llvm.uadd.sat.v16i16(<16 x i16> [[WIDE_LOAD9]], <16 x i16> [[BROADCAST_SPLAT13]])
; CHECK-NEXT:    [[TMP12:%.*]] = call <16 x i16> @llvm.uadd.sat.v16i16(<16 x i16> [[WIDE_LOAD10]], <16 x i16> [[BROADCAST_SPLAT15]])
; CHECK-NEXT:    [[TMP13:%.*]] = call <16 x i16> @llvm.uadd.sat.v16i16(<16 x i16> [[WIDE_LOAD11]], <16 x i16> [[BROADCAST_SPLAT17]])
; CHECK-NEXT:    [[TMP14:%.*]] = bitcast i16* [[NEXT_GEP5]] to <16 x i16>*
; CHECK-NEXT:    store <16 x i16> [[TMP10]], <16 x i16>* [[TMP14]], align 2
; CHECK-NEXT:    [[TMP15:%.*]] = getelementptr i16, i16* [[NEXT_GEP5]], i64 16
; CHECK-NEXT:    [[TMP16:%.*]] = bitcast i16* [[TMP15]] to <16 x i16>*
; CHECK-NEXT:    store <16 x i16> [[TMP11]], <16 x i16>* [[TMP16]], align 2
; CHECK-NEXT:    [[TMP17:%.*]] = getelementptr i16, i16* [[NEXT_GEP5]], i64 32
; CHECK-NEXT:    [[TMP18:%.*]] = bitcast i16* [[TMP17]] to <16 x i16>*
; CHECK-NEXT:    store <16 x i16> [[TMP12]], <16 x i16>* [[TMP18]], align 2
; CHECK-NEXT:    [[TMP19:%.*]] = getelementptr i16, i16* [[NEXT_GEP5]], i64 48
; CHECK-NEXT:    [[TMP20:%.*]] = bitcast i16* [[TMP19]] to <16 x i16>*
; CHECK-NEXT:    store <16 x i16> [[TMP13]], <16 x i16>* [[TMP20]], align 2
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 64
; CHECK-NEXT:    [[TMP21:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP21]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], [[LOOP0:!llvm.loop !.*]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 [[TMP2]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[WHILE_END]], label [[VEC_EPILOG_ITER_CHECK:%.*]]
; CHECK:       vec.epilog.iter.check:
; CHECK-NEXT:    [[IND_END29:%.*]] = getelementptr i16, i16* [[PDST]], i64 [[N_VEC]]
; CHECK-NEXT:    [[IND_END26:%.*]] = getelementptr i16, i16* [[PSRC]], i64 [[N_VEC]]
; CHECK-NEXT:    [[CAST_CRD22:%.*]] = trunc i64 [[N_VEC]] to i32
; CHECK-NEXT:    [[IND_END23:%.*]] = sub i32 [[BLOCKSIZE]], [[CAST_CRD22]]
; CHECK-NEXT:    [[N_VEC_REMAINING:%.*]] = and i64 [[TMP2]], 56
; CHECK-NEXT:    [[MIN_EPILOG_ITERS_CHECK:%.*]] = icmp eq i64 [[N_VEC_REMAINING]], 0
; CHECK-NEXT:    br i1 [[MIN_EPILOG_ITERS_CHECK]], label [[VEC_EPILOG_SCALAR_PH]], label [[VEC_EPILOG_PH]]
; CHECK:       vec.epilog.ph:
; CHECK-NEXT:    [[VEC_EPILOG_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[VEC_EPILOG_ITER_CHECK]] ], [ 0, [[VECTOR_MAIN_LOOP_ITER_CHECK]] ]
; CHECK-NEXT:    [[TMP22:%.*]] = add i32 [[BLOCKSIZE]], -1
; CHECK-NEXT:    [[TMP23:%.*]] = zext i32 [[TMP22]] to i64
; CHECK-NEXT:    [[TMP24:%.*]] = add nuw nsw i64 [[TMP23]], 1
; CHECK-NEXT:    [[N_VEC19:%.*]] = and i64 [[TMP24]], 8589934584
; CHECK-NEXT:    [[CAST_CRD:%.*]] = trunc i64 [[N_VEC19]] to i32
; CHECK-NEXT:    [[IND_END:%.*]] = sub i32 [[BLOCKSIZE]], [[CAST_CRD]]
; CHECK-NEXT:    [[IND_END25:%.*]] = getelementptr i16, i16* [[PSRC]], i64 [[N_VEC19]]
; CHECK-NEXT:    [[IND_END28:%.*]] = getelementptr i16, i16* [[PDST]], i64 [[N_VEC19]]
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT35:%.*]] = insertelement <8 x i16> poison, i16 [[OFFSET]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT36:%.*]] = shufflevector <8 x i16> [[BROADCAST_SPLATINSERT35]], <8 x i16> poison, <8 x i32> zeroinitializer
; CHECK-NEXT:    br label [[VEC_EPILOG_VECTOR_BODY:%.*]]
; CHECK:       vec.epilog.vector.body:
; CHECK-NEXT:    [[INDEX20:%.*]] = phi i64 [ [[VEC_EPILOG_RESUME_VAL]], [[VEC_EPILOG_PH]] ], [ [[INDEX_NEXT21:%.*]], [[VEC_EPILOG_VECTOR_BODY]] ]
; CHECK-NEXT:    [[NEXT_GEP32:%.*]] = getelementptr i16, i16* [[PSRC]], i64 [[INDEX20]]
; CHECK-NEXT:    [[NEXT_GEP33:%.*]] = getelementptr i16, i16* [[PDST]], i64 [[INDEX20]]
; CHECK-NEXT:    [[TMP25:%.*]] = bitcast i16* [[NEXT_GEP32]] to <8 x i16>*
; CHECK-NEXT:    [[WIDE_LOAD34:%.*]] = load <8 x i16>, <8 x i16>* [[TMP25]], align 2
; CHECK-NEXT:    [[TMP26:%.*]] = call <8 x i16> @llvm.uadd.sat.v8i16(<8 x i16> [[WIDE_LOAD34]], <8 x i16> [[BROADCAST_SPLAT36]])
; CHECK-NEXT:    [[TMP27:%.*]] = bitcast i16* [[NEXT_GEP33]] to <8 x i16>*
; CHECK-NEXT:    store <8 x i16> [[TMP26]], <8 x i16>* [[TMP27]], align 2
; CHECK-NEXT:    [[INDEX_NEXT21]] = add nuw i64 [[INDEX20]], 8
; CHECK-NEXT:    [[TMP28:%.*]] = icmp eq i64 [[INDEX_NEXT21]], [[N_VEC19]]
; CHECK-NEXT:    br i1 [[TMP28]], label [[VEC_EPILOG_MIDDLE_BLOCK:%.*]], label [[VEC_EPILOG_VECTOR_BODY]], [[LOOP2:!llvm.loop !.*]]
; CHECK:       vec.epilog.middle.block:
; CHECK-NEXT:    [[CMP_N30:%.*]] = icmp eq i64 [[TMP24]], [[N_VEC19]]
; CHECK-NEXT:    br i1 [[CMP_N30]], label [[WHILE_END]], label [[VEC_EPILOG_SCALAR_PH]]
; CHECK:       vec.epilog.scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i32 [ [[IND_END]], [[VEC_EPILOG_MIDDLE_BLOCK]] ], [ [[IND_END23]], [[VEC_EPILOG_ITER_CHECK]] ], [ [[BLOCKSIZE]], [[ITER_CHECK]] ]
; CHECK-NEXT:    [[BC_RESUME_VAL24:%.*]] = phi i16* [ [[IND_END25]], [[VEC_EPILOG_MIDDLE_BLOCK]] ], [ [[IND_END26]], [[VEC_EPILOG_ITER_CHECK]] ], [ [[PSRC]], [[ITER_CHECK]] ]
; CHECK-NEXT:    [[BC_RESUME_VAL27:%.*]] = phi i16* [ [[IND_END28]], [[VEC_EPILOG_MIDDLE_BLOCK]] ], [ [[IND_END29]], [[VEC_EPILOG_ITER_CHECK]] ], [ [[PDST]], [[ITER_CHECK]] ]
; CHECK-NEXT:    br label [[WHILE_BODY:%.*]]
; CHECK:       while.body:
; CHECK-NEXT:    [[BLKCNT_09:%.*]] = phi i32 [ [[DEC:%.*]], [[WHILE_BODY]] ], [ [[BC_RESUME_VAL]], [[VEC_EPILOG_SCALAR_PH]] ]
; CHECK-NEXT:    [[PSRC_ADDR_08:%.*]] = phi i16* [ [[INCDEC_PTR:%.*]], [[WHILE_BODY]] ], [ [[BC_RESUME_VAL24]], [[VEC_EPILOG_SCALAR_PH]] ]
; CHECK-NEXT:    [[PDST_ADDR_07:%.*]] = phi i16* [ [[INCDEC_PTR3:%.*]], [[WHILE_BODY]] ], [ [[BC_RESUME_VAL27]], [[VEC_EPILOG_SCALAR_PH]] ]
; CHECK-NEXT:    [[INCDEC_PTR]] = getelementptr inbounds i16, i16* [[PSRC_ADDR_08]], i64 1
; CHECK-NEXT:    [[TMP29:%.*]] = load i16, i16* [[PSRC_ADDR_08]], align 2
; CHECK-NEXT:    [[TMP30:%.*]] = tail call i16 @llvm.uadd.sat.i16(i16 [[TMP29]], i16 [[OFFSET]])
; CHECK-NEXT:    [[INCDEC_PTR3]] = getelementptr inbounds i16, i16* [[PDST_ADDR_07]], i64 1
; CHECK-NEXT:    store i16 [[TMP30]], i16* [[PDST_ADDR_07]], align 2
; CHECK-NEXT:    [[DEC]] = add i32 [[BLKCNT_09]], -1
; CHECK-NEXT:    [[CMP_NOT:%.*]] = icmp eq i32 [[DEC]], 0
; CHECK-NEXT:    br i1 [[CMP_NOT]], label [[WHILE_END]], label [[WHILE_BODY]], [[LOOP4:!llvm.loop !.*]]
; CHECK:       while.end:
; CHECK-NEXT:    ret void
;
entry:
  %cmp.not6 = icmp eq i32 %blockSize, 0
  br i1 %cmp.not6, label %while.end, label %while.body

while.body:                                       ; preds = %entry, %while.body
  %blkCnt.09 = phi i32 [ %dec, %while.body ], [ %blockSize, %entry ]
  %pSrc.addr.08 = phi i16* [ %incdec.ptr, %while.body ], [ %pSrc, %entry ]
  %pDst.addr.07 = phi i16* [ %incdec.ptr3, %while.body ], [ %pDst, %entry ]
  %incdec.ptr = getelementptr inbounds i16, i16* %pSrc.addr.08, i32 1
  %0 = load i16, i16* %pSrc.addr.08, align 2
  %1 = tail call i16 @llvm.uadd.sat.i16(i16 %0, i16 %offset)
  %incdec.ptr3 = getelementptr inbounds i16, i16* %pDst.addr.07, i32 1
  store i16 %1, i16* %pDst.addr.07, align 2
  %dec = add i32 %blkCnt.09, -1
  %cmp.not = icmp eq i32 %dec, 0
  br i1 %cmp.not, label %while.end, label %while.body

while.end:                                        ; preds = %while.body, %entry
  ret void
}

; CHECK-COST-LABEL: cttz
; CHECK-COST: Found an estimated cost of 1 for VF 1 For instruction:   %1 = tail call i8 @llvm.fshl.i8(i8 %0, i8 %0, i8 %offset)
; CHECK-COST: Found an estimated cost of 1 for VF 2 For instruction:   %1 = tail call i8 @llvm.fshl.i8(i8 %0, i8 %0, i8 %offset)
; CHECK-COST: Found an estimated cost of 1 for VF 4 For instruction:   %1 = tail call i8 @llvm.fshl.i8(i8 %0, i8 %0, i8 %offset)
; CHECK-COST: Found an estimated cost of 1 for VF 8 For instruction:   %1 = tail call i8 @llvm.fshl.i8(i8 %0, i8 %0, i8 %offset)
; CHECK-COST: Found an estimated cost of 1 for VF 16 For instruction:   %1 = tail call i8 @llvm.fshl.i8(i8 %0, i8 %0, i8 %offset)
; CHECK-COST: Found an estimated cost of 4 for VF 32 For instruction:   %1 = tail call i8 @llvm.fshl.i8(i8 %0, i8 %0, i8 %offset)

define void @cttz(i8* nocapture readonly %pSrc, i8 signext %offset, i8* nocapture noalias %pDst, i32 %blockSize) #0 {
; CHECK-LABEL: @cttz(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP_NOT6:%.*]] = icmp eq i32 [[BLOCKSIZE:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP_NOT6]], label [[WHILE_END:%.*]], label [[ITER_CHECK:%.*]]
; CHECK:       iter.check:
; CHECK-NEXT:    [[TMP0:%.*]] = add i32 [[BLOCKSIZE]], -1
; CHECK-NEXT:    [[TMP1:%.*]] = zext i32 [[TMP0]] to i64
; CHECK-NEXT:    [[TMP2:%.*]] = add nuw nsw i64 [[TMP1]], 1
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i32 [[TMP0]], 15
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[VEC_EPILOG_SCALAR_PH:%.*]], label [[VECTOR_MAIN_LOOP_ITER_CHECK:%.*]]
; CHECK:       vector.main.loop.iter.check:
; CHECK-NEXT:    [[MIN_ITERS_CHECK1:%.*]] = icmp ult i32 [[TMP0]], 127
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK1]], label [[VEC_EPILOG_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_VEC:%.*]] = and i64 [[TMP2]], 8589934464
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <32 x i8> poison, i8 [[OFFSET:%.*]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <32 x i8> [[BROADCAST_SPLATINSERT]], <32 x i8> poison, <32 x i32> zeroinitializer
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT12:%.*]] = insertelement <32 x i8> poison, i8 [[OFFSET]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT13:%.*]] = shufflevector <32 x i8> [[BROADCAST_SPLATINSERT12]], <32 x i8> poison, <32 x i32> zeroinitializer
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT14:%.*]] = insertelement <32 x i8> poison, i8 [[OFFSET]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT15:%.*]] = shufflevector <32 x i8> [[BROADCAST_SPLATINSERT14]], <32 x i8> poison, <32 x i32> zeroinitializer
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT16:%.*]] = insertelement <32 x i8> poison, i8 [[OFFSET]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT17:%.*]] = shufflevector <32 x i8> [[BROADCAST_SPLATINSERT16]], <32 x i8> poison, <32 x i32> zeroinitializer
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[NEXT_GEP:%.*]] = getelementptr i8, i8* [[PSRC:%.*]], i64 [[INDEX]]
; CHECK-NEXT:    [[NEXT_GEP5:%.*]] = getelementptr i8, i8* [[PDST:%.*]], i64 [[INDEX]]
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast i8* [[NEXT_GEP]] to <32 x i8>*
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <32 x i8>, <32 x i8>* [[TMP3]], align 2
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr i8, i8* [[NEXT_GEP]], i64 32
; CHECK-NEXT:    [[TMP5:%.*]] = bitcast i8* [[TMP4]] to <32 x i8>*
; CHECK-NEXT:    [[WIDE_LOAD9:%.*]] = load <32 x i8>, <32 x i8>* [[TMP5]], align 2
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr i8, i8* [[NEXT_GEP]], i64 64
; CHECK-NEXT:    [[TMP7:%.*]] = bitcast i8* [[TMP6]] to <32 x i8>*
; CHECK-NEXT:    [[WIDE_LOAD10:%.*]] = load <32 x i8>, <32 x i8>* [[TMP7]], align 2
; CHECK-NEXT:    [[TMP8:%.*]] = getelementptr i8, i8* [[NEXT_GEP]], i64 96
; CHECK-NEXT:    [[TMP9:%.*]] = bitcast i8* [[TMP8]] to <32 x i8>*
; CHECK-NEXT:    [[WIDE_LOAD11:%.*]] = load <32 x i8>, <32 x i8>* [[TMP9]], align 2
; CHECK-NEXT:    [[TMP10:%.*]] = call <32 x i8> @llvm.fshl.v32i8(<32 x i8> [[WIDE_LOAD]], <32 x i8> [[WIDE_LOAD]], <32 x i8> [[BROADCAST_SPLAT]])
; CHECK-NEXT:    [[TMP11:%.*]] = call <32 x i8> @llvm.fshl.v32i8(<32 x i8> [[WIDE_LOAD9]], <32 x i8> [[WIDE_LOAD9]], <32 x i8> [[BROADCAST_SPLAT13]])
; CHECK-NEXT:    [[TMP12:%.*]] = call <32 x i8> @llvm.fshl.v32i8(<32 x i8> [[WIDE_LOAD10]], <32 x i8> [[WIDE_LOAD10]], <32 x i8> [[BROADCAST_SPLAT15]])
; CHECK-NEXT:    [[TMP13:%.*]] = call <32 x i8> @llvm.fshl.v32i8(<32 x i8> [[WIDE_LOAD11]], <32 x i8> [[WIDE_LOAD11]], <32 x i8> [[BROADCAST_SPLAT17]])
; CHECK-NEXT:    [[TMP14:%.*]] = bitcast i8* [[NEXT_GEP5]] to <32 x i8>*
; CHECK-NEXT:    store <32 x i8> [[TMP10]], <32 x i8>* [[TMP14]], align 2
; CHECK-NEXT:    [[TMP15:%.*]] = getelementptr i8, i8* [[NEXT_GEP5]], i64 32
; CHECK-NEXT:    [[TMP16:%.*]] = bitcast i8* [[TMP15]] to <32 x i8>*
; CHECK-NEXT:    store <32 x i8> [[TMP11]], <32 x i8>* [[TMP16]], align 2
; CHECK-NEXT:    [[TMP17:%.*]] = getelementptr i8, i8* [[NEXT_GEP5]], i64 64
; CHECK-NEXT:    [[TMP18:%.*]] = bitcast i8* [[TMP17]] to <32 x i8>*
; CHECK-NEXT:    store <32 x i8> [[TMP12]], <32 x i8>* [[TMP18]], align 2
; CHECK-NEXT:    [[TMP19:%.*]] = getelementptr i8, i8* [[NEXT_GEP5]], i64 96
; CHECK-NEXT:    [[TMP20:%.*]] = bitcast i8* [[TMP19]] to <32 x i8>*
; CHECK-NEXT:    store <32 x i8> [[TMP13]], <32 x i8>* [[TMP20]], align 2
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 128
; CHECK-NEXT:    [[TMP21:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP21]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], [[LOOP5:!llvm.loop !.*]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 [[TMP2]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[WHILE_END]], label [[VEC_EPILOG_ITER_CHECK:%.*]]
; CHECK:       vec.epilog.iter.check:
; CHECK-NEXT:    [[IND_END29:%.*]] = getelementptr i8, i8* [[PDST]], i64 [[N_VEC]]
; CHECK-NEXT:    [[IND_END26:%.*]] = getelementptr i8, i8* [[PSRC]], i64 [[N_VEC]]
; CHECK-NEXT:    [[CAST_CRD22:%.*]] = trunc i64 [[N_VEC]] to i32
; CHECK-NEXT:    [[IND_END23:%.*]] = sub i32 [[BLOCKSIZE]], [[CAST_CRD22]]
; CHECK-NEXT:    [[N_VEC_REMAINING:%.*]] = and i64 [[TMP2]], 112
; CHECK-NEXT:    [[MIN_EPILOG_ITERS_CHECK:%.*]] = icmp eq i64 [[N_VEC_REMAINING]], 0
; CHECK-NEXT:    br i1 [[MIN_EPILOG_ITERS_CHECK]], label [[VEC_EPILOG_SCALAR_PH]], label [[VEC_EPILOG_PH]]
; CHECK:       vec.epilog.ph:
; CHECK-NEXT:    [[VEC_EPILOG_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[VEC_EPILOG_ITER_CHECK]] ], [ 0, [[VECTOR_MAIN_LOOP_ITER_CHECK]] ]
; CHECK-NEXT:    [[TMP22:%.*]] = add i32 [[BLOCKSIZE]], -1
; CHECK-NEXT:    [[TMP23:%.*]] = zext i32 [[TMP22]] to i64
; CHECK-NEXT:    [[TMP24:%.*]] = add nuw nsw i64 [[TMP23]], 1
; CHECK-NEXT:    [[N_VEC19:%.*]] = and i64 [[TMP24]], 8589934576
; CHECK-NEXT:    [[CAST_CRD:%.*]] = trunc i64 [[N_VEC19]] to i32
; CHECK-NEXT:    [[IND_END:%.*]] = sub i32 [[BLOCKSIZE]], [[CAST_CRD]]
; CHECK-NEXT:    [[IND_END25:%.*]] = getelementptr i8, i8* [[PSRC]], i64 [[N_VEC19]]
; CHECK-NEXT:    [[IND_END28:%.*]] = getelementptr i8, i8* [[PDST]], i64 [[N_VEC19]]
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT35:%.*]] = insertelement <16 x i8> poison, i8 [[OFFSET]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT36:%.*]] = shufflevector <16 x i8> [[BROADCAST_SPLATINSERT35]], <16 x i8> poison, <16 x i32> zeroinitializer
; CHECK-NEXT:    br label [[VEC_EPILOG_VECTOR_BODY:%.*]]
; CHECK:       vec.epilog.vector.body:
; CHECK-NEXT:    [[INDEX20:%.*]] = phi i64 [ [[VEC_EPILOG_RESUME_VAL]], [[VEC_EPILOG_PH]] ], [ [[INDEX_NEXT21:%.*]], [[VEC_EPILOG_VECTOR_BODY]] ]
; CHECK-NEXT:    [[NEXT_GEP32:%.*]] = getelementptr i8, i8* [[PSRC]], i64 [[INDEX20]]
; CHECK-NEXT:    [[NEXT_GEP33:%.*]] = getelementptr i8, i8* [[PDST]], i64 [[INDEX20]]
; CHECK-NEXT:    [[TMP25:%.*]] = bitcast i8* [[NEXT_GEP32]] to <16 x i8>*
; CHECK-NEXT:    [[WIDE_LOAD34:%.*]] = load <16 x i8>, <16 x i8>* [[TMP25]], align 2
; CHECK-NEXT:    [[TMP26:%.*]] = call <16 x i8> @llvm.fshl.v16i8(<16 x i8> [[WIDE_LOAD34]], <16 x i8> [[WIDE_LOAD34]], <16 x i8> [[BROADCAST_SPLAT36]])
; CHECK-NEXT:    [[TMP27:%.*]] = bitcast i8* [[NEXT_GEP33]] to <16 x i8>*
; CHECK-NEXT:    store <16 x i8> [[TMP26]], <16 x i8>* [[TMP27]], align 2
; CHECK-NEXT:    [[INDEX_NEXT21]] = add nuw i64 [[INDEX20]], 16
; CHECK-NEXT:    [[TMP28:%.*]] = icmp eq i64 [[INDEX_NEXT21]], [[N_VEC19]]
; CHECK-NEXT:    br i1 [[TMP28]], label [[VEC_EPILOG_MIDDLE_BLOCK:%.*]], label [[VEC_EPILOG_VECTOR_BODY]], [[LOOP6:!llvm.loop !.*]]
; CHECK:       vec.epilog.middle.block:
; CHECK-NEXT:    [[CMP_N30:%.*]] = icmp eq i64 [[TMP24]], [[N_VEC19]]
; CHECK-NEXT:    br i1 [[CMP_N30]], label [[WHILE_END]], label [[VEC_EPILOG_SCALAR_PH]]
; CHECK:       vec.epilog.scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i32 [ [[IND_END]], [[VEC_EPILOG_MIDDLE_BLOCK]] ], [ [[IND_END23]], [[VEC_EPILOG_ITER_CHECK]] ], [ [[BLOCKSIZE]], [[ITER_CHECK]] ]
; CHECK-NEXT:    [[BC_RESUME_VAL24:%.*]] = phi i8* [ [[IND_END25]], [[VEC_EPILOG_MIDDLE_BLOCK]] ], [ [[IND_END26]], [[VEC_EPILOG_ITER_CHECK]] ], [ [[PSRC]], [[ITER_CHECK]] ]
; CHECK-NEXT:    [[BC_RESUME_VAL27:%.*]] = phi i8* [ [[IND_END28]], [[VEC_EPILOG_MIDDLE_BLOCK]] ], [ [[IND_END29]], [[VEC_EPILOG_ITER_CHECK]] ], [ [[PDST]], [[ITER_CHECK]] ]
; CHECK-NEXT:    br label [[WHILE_BODY:%.*]]
; CHECK:       while.body:
; CHECK-NEXT:    [[BLKCNT_09:%.*]] = phi i32 [ [[DEC:%.*]], [[WHILE_BODY]] ], [ [[BC_RESUME_VAL]], [[VEC_EPILOG_SCALAR_PH]] ]
; CHECK-NEXT:    [[PSRC_ADDR_08:%.*]] = phi i8* [ [[INCDEC_PTR:%.*]], [[WHILE_BODY]] ], [ [[BC_RESUME_VAL24]], [[VEC_EPILOG_SCALAR_PH]] ]
; CHECK-NEXT:    [[PDST_ADDR_07:%.*]] = phi i8* [ [[INCDEC_PTR3:%.*]], [[WHILE_BODY]] ], [ [[BC_RESUME_VAL27]], [[VEC_EPILOG_SCALAR_PH]] ]
; CHECK-NEXT:    [[INCDEC_PTR]] = getelementptr inbounds i8, i8* [[PSRC_ADDR_08]], i64 1
; CHECK-NEXT:    [[TMP29:%.*]] = load i8, i8* [[PSRC_ADDR_08]], align 2
; CHECK-NEXT:    [[TMP30:%.*]] = tail call i8 @llvm.fshl.i8(i8 [[TMP29]], i8 [[TMP29]], i8 [[OFFSET]])
; CHECK-NEXT:    [[INCDEC_PTR3]] = getelementptr inbounds i8, i8* [[PDST_ADDR_07]], i64 1
; CHECK-NEXT:    store i8 [[TMP30]], i8* [[PDST_ADDR_07]], align 2
; CHECK-NEXT:    [[DEC]] = add i32 [[BLKCNT_09]], -1
; CHECK-NEXT:    [[CMP_NOT:%.*]] = icmp eq i32 [[DEC]], 0
; CHECK-NEXT:    br i1 [[CMP_NOT]], label [[WHILE_END]], label [[WHILE_BODY]], [[LOOP7:!llvm.loop !.*]]
; CHECK:       while.end:
; CHECK-NEXT:    ret void
;
entry:
  %cmp.not6 = icmp eq i32 %blockSize, 0
  br i1 %cmp.not6, label %while.end, label %while.body

while.body:                                       ; preds = %entry, %while.body
  %blkCnt.09 = phi i32 [ %dec, %while.body ], [ %blockSize, %entry ]
  %pSrc.addr.08 = phi i8* [ %incdec.ptr, %while.body ], [ %pSrc, %entry ]
  %pDst.addr.07 = phi i8* [ %incdec.ptr3, %while.body ], [ %pDst, %entry ]
  %incdec.ptr = getelementptr inbounds i8, i8* %pSrc.addr.08, i32 1
  %0 = load i8, i8* %pSrc.addr.08, align 2
  %1 = tail call i8 @llvm.fshl.i8(i8 %0, i8 %0, i8 %offset)
  %incdec.ptr3 = getelementptr inbounds i8, i8* %pDst.addr.07, i32 1
  store i8 %1, i8* %pDst.addr.07, align 2
  %dec = add i32 %blkCnt.09, -1
  %cmp.not = icmp eq i32 %dec, 0
  br i1 %cmp.not, label %while.end, label %while.body

while.end:                                        ; preds = %while.body, %entry
  ret void
}

declare i16 @llvm.uadd.sat.i16(i16, i16)
declare i8 @llvm.fshl.i8(i8, i8, i8)

