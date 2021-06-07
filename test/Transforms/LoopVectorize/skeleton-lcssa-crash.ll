; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -loop-vectorize -force-vector-width=2 -force-vector-interleave=1 -S %s | FileCheck %s

; Make sure LV does not crash when creating runtime checks involving values from
; other loops.
define i16 @test(i16** %arg, i64 %N) {
; CHECK-LABEL: @test(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[OUTER:%.*]]
; CHECK:       outer:
; CHECK-NEXT:    [[L_1:%.*]] = load i16*, i16** [[ARG:%.*]], align 8
; CHECK-NEXT:    [[L_2:%.*]] = load i16*, i16** [[ARG]], align 8
; CHECK-NEXT:    [[C_1:%.*]] = call i1 @cond()
; CHECK-NEXT:    br i1 [[C_1]], label [[OUTER_BACKEDGE:%.*]], label [[INNER_PREHEADER:%.*]]
; CHECK:       outer.backedge:
; CHECK-NEXT:    br label [[OUTER]]
; CHECK:       inner.preheader:
; CHECK-NEXT:    br label [[INNER:%.*]]
; CHECK:       inner:
; CHECK-NEXT:    [[C_2:%.*]] = call i1 @cond()
; CHECK-NEXT:    br i1 [[C_2]], label [[OUTER_LATCH:%.*]], label [[INNER_BB:%.*]]
; CHECK:       inner.bb:
; CHECK-NEXT:    [[C_3:%.*]] = call i1 @cond()
; CHECK-NEXT:    br i1 [[C_3]], label [[LOOP3_PREHEADER:%.*]], label [[INNER_LATCH:%.*]]
; CHECK:       loop3.preheader:
; CHECK-NEXT:    [[L_1_LCSSA8:%.*]] = phi i16* [ [[L_1]], [[INNER_BB]] ]
; CHECK-NEXT:    [[L_1_LCSSA:%.*]] = phi i16* [ [[L_1]], [[INNER_BB]] ]
; CHECK-NEXT:    [[L_2_LCSSA:%.*]] = phi i16* [ [[L_2]], [[INNER_BB]] ]
; CHECK-NEXT:    [[L_2_LCSSA3:%.*]] = bitcast i16* [[L_2_LCSSA]] to i8*
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[N:%.*]], 1
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 [[TMP0]], 2
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_MEMCHECK:%.*]]
; CHECK:       vector.memcheck:
; CHECK-NEXT:    [[UGLYGEP:%.*]] = getelementptr i8, i8* [[L_2_LCSSA3]], i64 1
; CHECK-NEXT:    [[SCEVGEP:%.*]] = getelementptr i16, i16* [[L_1_LCSSA]], i64 1
; CHECK-NEXT:    [[SCEVGEP6:%.*]] = bitcast i16* [[SCEVGEP]] to i8*
; CHECK-NEXT:    [[TMP1:%.*]] = add i64 [[N]], 2
; CHECK-NEXT:    [[SCEVGEP7:%.*]] = getelementptr i16, i16* [[L_1_LCSSA8]], i64 [[TMP1]]
; CHECK-NEXT:    [[SCEVGEP710:%.*]] = bitcast i16* [[SCEVGEP7]] to i8*
; CHECK-NEXT:    [[BOUND0:%.*]] = icmp ult i8* [[L_2_LCSSA3]], [[SCEVGEP710]]
; CHECK-NEXT:    [[BOUND1:%.*]] = icmp ult i8* [[SCEVGEP6]], [[UGLYGEP]]
; CHECK-NEXT:    [[FOUND_CONFLICT:%.*]] = and i1 [[BOUND0]], [[BOUND1]]
; CHECK-NEXT:    [[MEMCHECK_CONFLICT:%.*]] = and i1 [[FOUND_CONFLICT]], true
; CHECK-NEXT:    br i1 [[MEMCHECK_CONFLICT]], label [[SCALAR_PH]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i64 [[TMP0]], 2
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i64 [[TMP0]], [[N_MOD_VF]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP2:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP3:%.*]] = add nuw nsw i64 [[TMP2]], 1
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds i16, i16* [[L_1]], i64 [[TMP3]]
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr inbounds i16, i16* [[TMP4]], i32 0
; CHECK-NEXT:    [[TMP6:%.*]] = bitcast i16* [[TMP5]] to <2 x i16>*
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <2 x i16>, <2 x i16>* [[TMP6]], align 2, !alias.scope !0
; CHECK-NEXT:    [[TMP7:%.*]] = getelementptr inbounds i16, i16* [[L_2]], i64 0
; CHECK-NEXT:    [[TMP8:%.*]] = extractelement <2 x i16> [[WIDE_LOAD]], i32 0
; CHECK-NEXT:    store i16 [[TMP8]], i16* [[TMP7]], align 2, !alias.scope !3, !noalias !0
; CHECK-NEXT:    [[TMP9:%.*]] = extractelement <2 x i16> [[WIDE_LOAD]], i32 1
; CHECK-NEXT:    store i16 [[TMP9]], i16* [[TMP7]], align 2, !alias.scope !3, !noalias !0
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 2
; CHECK-NEXT:    [[TMP10:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP10]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], [[LOOP5:!llvm.loop !.*]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 [[TMP0]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[EXIT_LOOPEXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[LOOP3_PREHEADER]] ], [ 0, [[VECTOR_MEMCHECK]] ]
; CHECK-NEXT:    br label [[LOOP3:%.*]]
; CHECK:       inner.latch:
; CHECK-NEXT:    [[C_4:%.*]] = call i1 @cond()
; CHECK-NEXT:    br i1 [[C_4]], label [[EXIT_LOOPEXIT1:%.*]], label [[INNER]]
; CHECK:       outer.latch:
; CHECK-NEXT:    br label [[OUTER_BACKEDGE]]
; CHECK:       loop3:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[IV_NEXT:%.*]], [[LOOP3]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[C_5:%.*]] = icmp ult i64 [[IV]], [[N]]
; CHECK-NEXT:    [[GEP_1:%.*]] = getelementptr inbounds i16, i16* [[L_1_LCSSA]], i64 [[IV_NEXT]]
; CHECK-NEXT:    [[LOOP_L_1:%.*]] = load i16, i16* [[GEP_1]], align 2
; CHECK-NEXT:    [[GEP_2:%.*]] = getelementptr inbounds i16, i16* [[L_2_LCSSA]], i64 0
; CHECK-NEXT:    store i16 [[LOOP_L_1]], i16* [[GEP_2]], align 2
; CHECK-NEXT:    br i1 [[C_5]], label [[LOOP3]], label [[EXIT_LOOPEXIT]], [[LOOP7:!llvm.loop !.*]]
; CHECK:       exit.loopexit:
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       exit.loopexit1:
; CHECK-NEXT:    [[L_1_LCSSA4:%.*]] = phi i16* [ [[L_1]], [[INNER_LATCH]] ]
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    [[L_15:%.*]] = phi i16* [ [[L_1_LCSSA4]], [[EXIT_LOOPEXIT1]] ], [ [[L_1_LCSSA]], [[EXIT_LOOPEXIT]] ]
; CHECK-NEXT:    [[L_3:%.*]] = load i16, i16* [[L_15]], align 2
; CHECK-NEXT:    ret i16 [[L_3]]
;
entry:
  br label %outer

outer:
  %l.1 = load i16*, i16** %arg, align 8
  %l.2 = load i16*, i16** %arg, align 8
  %c.1 = call i1 @cond()
  br i1 %c.1, label %outer, label %inner

inner:                                              ; preds = %bb15, %bb1
  %c.2 = call i1 @cond()
  br i1 %c.2, label %outer.latch, label %inner.bb

inner.bb:                                              ; preds = %bb3
  %c.3 = call i1 @cond()
  br i1 %c.3, label %loop3, label %inner.latch

inner.latch:                                             ; preds = %bb4
  %c.4 = call i1 @cond()
  br i1 %c.4, label %exit, label %inner

outer.latch:                                             ; preds = %bb3
  br label %outer

loop3:                                              ; preds = %bb9, %bb4
  %iv = phi i64 [ %iv.next, %loop3 ], [ 0, %inner.bb ]
  %iv.next = add nsw nuw i64 %iv, 1
  %c.5  = icmp ult i64 %iv, %N
  %gep.1 = getelementptr inbounds i16, i16* %l.1, i64 %iv.next
  %loop.l.1 = load i16, i16* %gep.1, align 2
  %gep.2 = getelementptr inbounds i16, i16* %l.2, i64 0
  store i16 %loop.l.1, i16* %gep.2 , align 2
  br i1 %c.5, label %loop3, label %exit

exit:                                             ; preds = %bb15, %bb5
  %l.3 = load i16, i16* %l.1, align 2
  ret i16 %l.3
}

declare i1 @cond()
