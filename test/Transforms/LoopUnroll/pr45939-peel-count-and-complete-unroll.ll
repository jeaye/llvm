; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -loop-unroll -unroll-peel-count=2 -S %s | FileCheck --check-prefix=PEEL2 %s
; RUN: opt -loop-unroll -unroll-peel-count=8 -S %s | FileCheck --check-prefix=PEEL8 %s
; RUN: opt -loop-unroll -unroll-peel-count=2 -unroll-count=2 -S %s | FileCheck --check-prefix=PEEL2UNROLL2 %s

; Test case for PR45939. Make sure unroll count is adjusted when loop is peeled and unrolled.

@a = global [8 x i32] zeroinitializer, align 16

define void @test1() {
; PEEL2-LABEL: @test1(
; PEEL2-NEXT:  entry:
; PEEL2-NEXT:    br label [[FOR_BODY_PEEL_BEGIN:%.*]]
; PEEL2:       for.body.peel.begin:
; PEEL2-NEXT:    br label [[FOR_BODY_PEEL:%.*]]
; PEEL2:       for.body.peel:
; PEEL2-NEXT:    [[ARRAYIDX_PEEL:%.*]] = getelementptr inbounds [8 x i32], [8 x i32]* @a, i64 0, i64 0
; PEEL2-NEXT:    [[TMP0:%.*]] = trunc i64 0 to i32
; PEEL2-NEXT:    store i32 [[TMP0]], i32* [[ARRAYIDX_PEEL]], align 4
; PEEL2-NEXT:    [[INDVARS_IV_NEXT_PEEL:%.*]] = add nuw nsw i64 0, 1
; PEEL2-NEXT:    [[EXITCOND_PEEL:%.*]] = icmp ne i64 [[INDVARS_IV_NEXT_PEEL]], 8
; PEEL2-NEXT:    br i1 [[EXITCOND_PEEL]], label [[FOR_BODY_PEEL_NEXT:%.*]], label [[FOR_EXIT:%.*]]
; PEEL2:       for.body.peel.next:
; PEEL2-NEXT:    br label [[FOR_BODY_PEEL2:%.*]]
; PEEL2:       for.body.peel2:
; PEEL2-NEXT:    [[ARRAYIDX_PEEL3:%.*]] = getelementptr inbounds [8 x i32], [8 x i32]* @a, i64 0, i64 [[INDVARS_IV_NEXT_PEEL]]
; PEEL2-NEXT:    [[TMP1:%.*]] = trunc i64 [[INDVARS_IV_NEXT_PEEL]] to i32
; PEEL2-NEXT:    store i32 [[TMP1]], i32* [[ARRAYIDX_PEEL3]], align 4
; PEEL2-NEXT:    [[INDVARS_IV_NEXT_PEEL4:%.*]] = add nuw nsw i64 [[INDVARS_IV_NEXT_PEEL]], 1
; PEEL2-NEXT:    [[EXITCOND_PEEL5:%.*]] = icmp ne i64 [[INDVARS_IV_NEXT_PEEL4]], 8
; PEEL2-NEXT:    br i1 [[EXITCOND_PEEL5]], label [[FOR_BODY_PEEL_NEXT1:%.*]], label [[FOR_EXIT]]
; PEEL2:       for.body.peel.next1:
; PEEL2-NEXT:    br label [[FOR_BODY_PEEL_NEXT6:%.*]]
; PEEL2:       for.body.peel.next6:
; PEEL2-NEXT:    br label [[ENTRY_PEEL_NEWPH:%.*]]
; PEEL2:       entry.peel.newph:
; PEEL2-NEXT:    br label [[FOR_BODY:%.*]]
; PEEL2:       for.body:
; PEEL2-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds [8 x i32], [8 x i32]* @a, i64 0, i64 [[INDVARS_IV_NEXT_PEEL4]]
; PEEL2-NEXT:    [[TMP2:%.*]] = trunc i64 [[INDVARS_IV_NEXT_PEEL4]] to i32
; PEEL2-NEXT:    store i32 [[TMP2]], i32* [[ARRAYIDX]], align 4
; PEEL2-NEXT:    store i32 3, i32* getelementptr inbounds ([8 x i32], [8 x i32]* @a, i64 0, i64 3), align 4
; PEEL2-NEXT:    store i32 4, i32* getelementptr inbounds ([8 x i32], [8 x i32]* @a, i64 0, i64 4), align 4
; PEEL2-NEXT:    store i32 5, i32* getelementptr inbounds ([8 x i32], [8 x i32]* @a, i64 0, i64 5), align 4
; PEEL2-NEXT:    store i32 6, i32* getelementptr inbounds ([8 x i32], [8 x i32]* @a, i64 0, i64 6), align 4
; PEEL2-NEXT:    store i32 7, i32* getelementptr inbounds ([8 x i32], [8 x i32]* @a, i64 0, i64 7), align 4
; PEEL2-NEXT:    store i32 8, i32* getelementptr inbounds ([8 x i32], [8 x i32]* @a, i64 1, i64 0), align 4
; PEEL2-NEXT:    store i32 9, i32* getelementptr ([8 x i32], [8 x i32]* @a, i64 1, i64 1), align 4
; PEEL2-NEXT:    br label [[FOR_EXIT]]
; PEEL2:       for.exit:
; PEEL2-NEXT:    ret void
;
; PEEL8-LABEL: @test1(
; PEEL8-NEXT:  entry:
; PEEL8-NEXT:    br label [[FOR_BODY_PEEL_BEGIN:%.*]]
; PEEL8:       for.body.peel.begin:
; PEEL8-NEXT:    br label [[FOR_BODY_PEEL:%.*]]
; PEEL8:       for.body.peel:
; PEEL8-NEXT:    [[ARRAYIDX_PEEL:%.*]] = getelementptr inbounds [8 x i32], [8 x i32]* @a, i64 0, i64 0
; PEEL8-NEXT:    [[TMP0:%.*]] = trunc i64 0 to i32
; PEEL8-NEXT:    store i32 [[TMP0]], i32* [[ARRAYIDX_PEEL]], align 4
; PEEL8-NEXT:    [[INDVARS_IV_NEXT_PEEL:%.*]] = add nuw nsw i64 0, 1
; PEEL8-NEXT:    [[EXITCOND_PEEL:%.*]] = icmp ne i64 [[INDVARS_IV_NEXT_PEEL]], 8
; PEEL8-NEXT:    br i1 [[EXITCOND_PEEL]], label [[FOR_BODY_PEEL_NEXT:%.*]], label [[FOR_EXIT:%.*]]
; PEEL8:       for.body.peel.next:
; PEEL8-NEXT:    br label [[FOR_BODY_PEEL2:%.*]]
; PEEL8:       for.body.peel2:
; PEEL8-NEXT:    [[ARRAYIDX_PEEL3:%.*]] = getelementptr inbounds [8 x i32], [8 x i32]* @a, i64 0, i64 [[INDVARS_IV_NEXT_PEEL]]
; PEEL8-NEXT:    [[TMP1:%.*]] = trunc i64 [[INDVARS_IV_NEXT_PEEL]] to i32
; PEEL8-NEXT:    store i32 [[TMP1]], i32* [[ARRAYIDX_PEEL3]], align 4
; PEEL8-NEXT:    [[INDVARS_IV_NEXT_PEEL4:%.*]] = add nuw nsw i64 [[INDVARS_IV_NEXT_PEEL]], 1
; PEEL8-NEXT:    [[EXITCOND_PEEL5:%.*]] = icmp ne i64 [[INDVARS_IV_NEXT_PEEL4]], 8
; PEEL8-NEXT:    br i1 [[EXITCOND_PEEL5]], label [[FOR_BODY_PEEL_NEXT1:%.*]], label [[FOR_EXIT]]
; PEEL8:       for.body.peel.next1:
; PEEL8-NEXT:    br label [[FOR_BODY_PEEL7:%.*]]
; PEEL8:       for.body.peel7:
; PEEL8-NEXT:    [[ARRAYIDX_PEEL8:%.*]] = getelementptr inbounds [8 x i32], [8 x i32]* @a, i64 0, i64 [[INDVARS_IV_NEXT_PEEL4]]
; PEEL8-NEXT:    [[TMP2:%.*]] = trunc i64 [[INDVARS_IV_NEXT_PEEL4]] to i32
; PEEL8-NEXT:    store i32 [[TMP2]], i32* [[ARRAYIDX_PEEL8]], align 4
; PEEL8-NEXT:    [[INDVARS_IV_NEXT_PEEL9:%.*]] = add nuw nsw i64 [[INDVARS_IV_NEXT_PEEL4]], 1
; PEEL8-NEXT:    [[EXITCOND_PEEL10:%.*]] = icmp ne i64 [[INDVARS_IV_NEXT_PEEL9]], 8
; PEEL8-NEXT:    br i1 [[EXITCOND_PEEL10]], label [[FOR_BODY_PEEL_NEXT6:%.*]], label [[FOR_EXIT]]
; PEEL8:       for.body.peel.next6:
; PEEL8-NEXT:    br label [[FOR_BODY_PEEL12:%.*]]
; PEEL8:       for.body.peel12:
; PEEL8-NEXT:    [[ARRAYIDX_PEEL13:%.*]] = getelementptr inbounds [8 x i32], [8 x i32]* @a, i64 0, i64 [[INDVARS_IV_NEXT_PEEL9]]
; PEEL8-NEXT:    [[TMP3:%.*]] = trunc i64 [[INDVARS_IV_NEXT_PEEL9]] to i32
; PEEL8-NEXT:    store i32 [[TMP3]], i32* [[ARRAYIDX_PEEL13]], align 4
; PEEL8-NEXT:    [[INDVARS_IV_NEXT_PEEL14:%.*]] = add nuw nsw i64 [[INDVARS_IV_NEXT_PEEL9]], 1
; PEEL8-NEXT:    [[EXITCOND_PEEL15:%.*]] = icmp ne i64 [[INDVARS_IV_NEXT_PEEL14]], 8
; PEEL8-NEXT:    br i1 [[EXITCOND_PEEL15]], label [[FOR_BODY_PEEL_NEXT11:%.*]], label [[FOR_EXIT]]
; PEEL8:       for.body.peel.next11:
; PEEL8-NEXT:    br label [[FOR_BODY_PEEL17:%.*]]
; PEEL8:       for.body.peel17:
; PEEL8-NEXT:    [[ARRAYIDX_PEEL18:%.*]] = getelementptr inbounds [8 x i32], [8 x i32]* @a, i64 0, i64 [[INDVARS_IV_NEXT_PEEL14]]
; PEEL8-NEXT:    [[TMP4:%.*]] = trunc i64 [[INDVARS_IV_NEXT_PEEL14]] to i32
; PEEL8-NEXT:    store i32 [[TMP4]], i32* [[ARRAYIDX_PEEL18]], align 4
; PEEL8-NEXT:    [[INDVARS_IV_NEXT_PEEL19:%.*]] = add nuw nsw i64 [[INDVARS_IV_NEXT_PEEL14]], 1
; PEEL8-NEXT:    [[EXITCOND_PEEL20:%.*]] = icmp ne i64 [[INDVARS_IV_NEXT_PEEL19]], 8
; PEEL8-NEXT:    br i1 [[EXITCOND_PEEL20]], label [[FOR_BODY_PEEL_NEXT16:%.*]], label [[FOR_EXIT]]
; PEEL8:       for.body.peel.next16:
; PEEL8-NEXT:    br label [[FOR_BODY_PEEL22:%.*]]
; PEEL8:       for.body.peel22:
; PEEL8-NEXT:    [[ARRAYIDX_PEEL23:%.*]] = getelementptr inbounds [8 x i32], [8 x i32]* @a, i64 0, i64 [[INDVARS_IV_NEXT_PEEL19]]
; PEEL8-NEXT:    [[TMP5:%.*]] = trunc i64 [[INDVARS_IV_NEXT_PEEL19]] to i32
; PEEL8-NEXT:    store i32 [[TMP5]], i32* [[ARRAYIDX_PEEL23]], align 4
; PEEL8-NEXT:    [[INDVARS_IV_NEXT_PEEL24:%.*]] = add nuw nsw i64 [[INDVARS_IV_NEXT_PEEL19]], 1
; PEEL8-NEXT:    [[EXITCOND_PEEL25:%.*]] = icmp ne i64 [[INDVARS_IV_NEXT_PEEL24]], 8
; PEEL8-NEXT:    br i1 [[EXITCOND_PEEL25]], label [[FOR_BODY_PEEL_NEXT21:%.*]], label [[FOR_EXIT]]
; PEEL8:       for.body.peel.next21:
; PEEL8-NEXT:    br label [[FOR_BODY_PEEL27:%.*]]
; PEEL8:       for.body.peel27:
; PEEL8-NEXT:    [[ARRAYIDX_PEEL28:%.*]] = getelementptr inbounds [8 x i32], [8 x i32]* @a, i64 0, i64 [[INDVARS_IV_NEXT_PEEL24]]
; PEEL8-NEXT:    [[TMP6:%.*]] = trunc i64 [[INDVARS_IV_NEXT_PEEL24]] to i32
; PEEL8-NEXT:    store i32 [[TMP6]], i32* [[ARRAYIDX_PEEL28]], align 4
; PEEL8-NEXT:    [[INDVARS_IV_NEXT_PEEL29:%.*]] = add nuw nsw i64 [[INDVARS_IV_NEXT_PEEL24]], 1
; PEEL8-NEXT:    [[EXITCOND_PEEL30:%.*]] = icmp ne i64 [[INDVARS_IV_NEXT_PEEL29]], 8
; PEEL8-NEXT:    br i1 [[EXITCOND_PEEL30]], label [[FOR_BODY_PEEL_NEXT26:%.*]], label [[FOR_EXIT]]
; PEEL8:       for.body.peel.next26:
; PEEL8-NEXT:    br label [[FOR_BODY_PEEL32:%.*]]
; PEEL8:       for.body.peel32:
; PEEL8-NEXT:    [[ARRAYIDX_PEEL33:%.*]] = getelementptr inbounds [8 x i32], [8 x i32]* @a, i64 0, i64 [[INDVARS_IV_NEXT_PEEL29]]
; PEEL8-NEXT:    [[TMP7:%.*]] = trunc i64 [[INDVARS_IV_NEXT_PEEL29]] to i32
; PEEL8-NEXT:    store i32 [[TMP7]], i32* [[ARRAYIDX_PEEL33]], align 4
; PEEL8-NEXT:    [[INDVARS_IV_NEXT_PEEL34:%.*]] = add nuw nsw i64 [[INDVARS_IV_NEXT_PEEL29]], 1
; PEEL8-NEXT:    [[EXITCOND_PEEL35:%.*]] = icmp ne i64 [[INDVARS_IV_NEXT_PEEL34]], 8
; PEEL8-NEXT:    br i1 [[EXITCOND_PEEL35]], label [[FOR_BODY_PEEL_NEXT31:%.*]], label [[FOR_EXIT]]
; PEEL8:       for.body.peel.next31:
; PEEL8-NEXT:    br label [[FOR_BODY_PEEL_NEXT36:%.*]]
; PEEL8:       for.body.peel.next36:
; PEEL8-NEXT:    br label [[ENTRY_PEEL_NEWPH:%.*]]
; PEEL8:       entry.peel.newph:
; PEEL8-NEXT:    br label [[FOR_BODY:%.*]]
; PEEL8:       for.body:
; PEEL8-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds [8 x i32], [8 x i32]* @a, i64 0, i64 [[INDVARS_IV_NEXT_PEEL34]]
; PEEL8-NEXT:    [[TMP8:%.*]] = trunc i64 [[INDVARS_IV_NEXT_PEEL34]] to i32
; PEEL8-NEXT:    store i32 [[TMP8]], i32* [[ARRAYIDX]], align 4
; PEEL8-NEXT:    [[INDVARS_IV_NEXT:%.*]] = add nuw nsw i64 [[INDVARS_IV_NEXT_PEEL34]], 1
; PEEL8-NEXT:    [[ARRAYIDX_1:%.*]] = getelementptr inbounds [8 x i32], [8 x i32]* @a, i64 0, i64 [[INDVARS_IV_NEXT]]
; PEEL8-NEXT:    [[TMP9:%.*]] = trunc i64 [[INDVARS_IV_NEXT]] to i32
; PEEL8-NEXT:    store i32 [[TMP9]], i32* [[ARRAYIDX_1]], align 4
; PEEL8-NEXT:    [[INDVARS_IV_NEXT_1:%.*]] = add nuw nsw i64 [[INDVARS_IV_NEXT]], 1
; PEEL8-NEXT:    [[ARRAYIDX_2:%.*]] = getelementptr inbounds [8 x i32], [8 x i32]* @a, i64 0, i64 [[INDVARS_IV_NEXT_1]]
; PEEL8-NEXT:    [[TMP10:%.*]] = trunc i64 [[INDVARS_IV_NEXT_1]] to i32
; PEEL8-NEXT:    store i32 [[TMP10]], i32* [[ARRAYIDX_2]], align 4
; PEEL8-NEXT:    [[INDVARS_IV_NEXT_2:%.*]] = add nuw nsw i64 [[INDVARS_IV_NEXT_1]], 1
; PEEL8-NEXT:    [[ARRAYIDX_3:%.*]] = getelementptr inbounds [8 x i32], [8 x i32]* @a, i64 0, i64 [[INDVARS_IV_NEXT_2]]
; PEEL8-NEXT:    [[TMP11:%.*]] = trunc i64 [[INDVARS_IV_NEXT_2]] to i32
; PEEL8-NEXT:    store i32 [[TMP11]], i32* [[ARRAYIDX_3]], align 4
; PEEL8-NEXT:    [[INDVARS_IV_NEXT_3:%.*]] = add nuw nsw i64 [[INDVARS_IV_NEXT_2]], 1
; PEEL8-NEXT:    [[ARRAYIDX_4:%.*]] = getelementptr inbounds [8 x i32], [8 x i32]* @a, i64 0, i64 [[INDVARS_IV_NEXT_3]]
; PEEL8-NEXT:    [[TMP12:%.*]] = trunc i64 [[INDVARS_IV_NEXT_3]] to i32
; PEEL8-NEXT:    store i32 [[TMP12]], i32* [[ARRAYIDX_4]], align 4
; PEEL8-NEXT:    [[INDVARS_IV_NEXT_4:%.*]] = add nuw nsw i64 [[INDVARS_IV_NEXT_3]], 1
; PEEL8-NEXT:    [[ARRAYIDX_5:%.*]] = getelementptr inbounds [8 x i32], [8 x i32]* @a, i64 0, i64 [[INDVARS_IV_NEXT_4]]
; PEEL8-NEXT:    [[TMP13:%.*]] = trunc i64 [[INDVARS_IV_NEXT_4]] to i32
; PEEL8-NEXT:    store i32 [[TMP13]], i32* [[ARRAYIDX_5]], align 4
; PEEL8-NEXT:    [[INDVARS_IV_NEXT_5:%.*]] = add nuw nsw i64 [[INDVARS_IV_NEXT_4]], 1
; PEEL8-NEXT:    [[ARRAYIDX_6:%.*]] = getelementptr inbounds [8 x i32], [8 x i32]* @a, i64 0, i64 [[INDVARS_IV_NEXT_5]]
; PEEL8-NEXT:    [[TMP14:%.*]] = trunc i64 [[INDVARS_IV_NEXT_5]] to i32
; PEEL8-NEXT:    store i32 [[TMP14]], i32* [[ARRAYIDX_6]], align 4
; PEEL8-NEXT:    [[INDVARS_IV_NEXT_6:%.*]] = add nuw nsw i64 [[INDVARS_IV_NEXT_5]], 1
; PEEL8-NEXT:    [[ARRAYIDX_7:%.*]] = getelementptr inbounds [8 x i32], [8 x i32]* @a, i64 0, i64 [[INDVARS_IV_NEXT_6]]
; PEEL8-NEXT:    [[TMP15:%.*]] = trunc i64 [[INDVARS_IV_NEXT_6]] to i32
; PEEL8-NEXT:    store i32 [[TMP15]], i32* [[ARRAYIDX_7]], align 4
; PEEL8-NEXT:    br label [[FOR_EXIT]]
; PEEL8:       for.exit:
; PEEL8-NEXT:    ret void
;
; PEEL2UNROLL2-LABEL: @test1(
; PEEL2UNROLL2-NEXT:  entry:
; PEEL2UNROLL2-NEXT:    br label [[FOR_BODY_PEEL_BEGIN:%.*]]
; PEEL2UNROLL2:       for.body.peel.begin:
; PEEL2UNROLL2-NEXT:    br label [[FOR_BODY_PEEL:%.*]]
; PEEL2UNROLL2:       for.body.peel:
; PEEL2UNROLL2-NEXT:    [[ARRAYIDX_PEEL:%.*]] = getelementptr inbounds [8 x i32], [8 x i32]* @a, i64 0, i64 0
; PEEL2UNROLL2-NEXT:    [[TMP0:%.*]] = trunc i64 0 to i32
; PEEL2UNROLL2-NEXT:    store i32 [[TMP0]], i32* [[ARRAYIDX_PEEL]], align 4
; PEEL2UNROLL2-NEXT:    [[INDVARS_IV_NEXT_PEEL:%.*]] = add nuw nsw i64 0, 1
; PEEL2UNROLL2-NEXT:    [[EXITCOND_PEEL:%.*]] = icmp ne i64 [[INDVARS_IV_NEXT_PEEL]], 8
; PEEL2UNROLL2-NEXT:    br i1 [[EXITCOND_PEEL]], label [[FOR_BODY_PEEL_NEXT:%.*]], label [[FOR_EXIT:%.*]]
; PEEL2UNROLL2:       for.body.peel.next:
; PEEL2UNROLL2-NEXT:    br label [[FOR_BODY_PEEL2:%.*]]
; PEEL2UNROLL2:       for.body.peel2:
; PEEL2UNROLL2-NEXT:    [[ARRAYIDX_PEEL3:%.*]] = getelementptr inbounds [8 x i32], [8 x i32]* @a, i64 0, i64 [[INDVARS_IV_NEXT_PEEL]]
; PEEL2UNROLL2-NEXT:    [[TMP1:%.*]] = trunc i64 [[INDVARS_IV_NEXT_PEEL]] to i32
; PEEL2UNROLL2-NEXT:    store i32 [[TMP1]], i32* [[ARRAYIDX_PEEL3]], align 4
; PEEL2UNROLL2-NEXT:    [[INDVARS_IV_NEXT_PEEL4:%.*]] = add nuw nsw i64 [[INDVARS_IV_NEXT_PEEL]], 1
; PEEL2UNROLL2-NEXT:    [[EXITCOND_PEEL5:%.*]] = icmp ne i64 [[INDVARS_IV_NEXT_PEEL4]], 8
; PEEL2UNROLL2-NEXT:    br i1 [[EXITCOND_PEEL5]], label [[FOR_BODY_PEEL_NEXT1:%.*]], label [[FOR_EXIT]]
; PEEL2UNROLL2:       for.body.peel.next1:
; PEEL2UNROLL2-NEXT:    br label [[FOR_BODY_PEEL_NEXT6:%.*]]
; PEEL2UNROLL2:       for.body.peel.next6:
; PEEL2UNROLL2-NEXT:    br label [[ENTRY_PEEL_NEWPH:%.*]]
; PEEL2UNROLL2:       entry.peel.newph:
; PEEL2UNROLL2-NEXT:    br label [[FOR_BODY:%.*]]
; PEEL2UNROLL2:       for.body:
; PEEL2UNROLL2-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[INDVARS_IV_NEXT_PEEL4]], [[ENTRY_PEEL_NEWPH]] ], [ [[INDVARS_IV_NEXT_1:%.*]], [[FOR_BODY]] ]
; PEEL2UNROLL2-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds [8 x i32], [8 x i32]* @a, i64 0, i64 [[INDVARS_IV]]
; PEEL2UNROLL2-NEXT:    [[TMP2:%.*]] = trunc i64 [[INDVARS_IV]] to i32
; PEEL2UNROLL2-NEXT:    store i32 [[TMP2]], i32* [[ARRAYIDX]], align 4
; PEEL2UNROLL2-NEXT:    [[INDVARS_IV_NEXT:%.*]] = add nuw nsw i64 [[INDVARS_IV]], 1
; PEEL2UNROLL2-NEXT:    [[ARRAYIDX_1:%.*]] = getelementptr inbounds [8 x i32], [8 x i32]* @a, i64 0, i64 [[INDVARS_IV_NEXT]]
; PEEL2UNROLL2-NEXT:    [[TMP3:%.*]] = trunc i64 [[INDVARS_IV_NEXT]] to i32
; PEEL2UNROLL2-NEXT:    store i32 [[TMP3]], i32* [[ARRAYIDX_1]], align 4
; PEEL2UNROLL2-NEXT:    [[INDVARS_IV_NEXT_1]] = add nuw nsw i64 [[INDVARS_IV_NEXT]], 1
; PEEL2UNROLL2-NEXT:    [[EXITCOND_1:%.*]] = icmp ne i64 [[INDVARS_IV_NEXT_1]], 8
; PEEL2UNROLL2-NEXT:    br i1 [[EXITCOND_1]], label [[FOR_BODY]], label [[FOR_EXIT_LOOPEXIT:%.*]], !llvm.loop [[LOOP0:![0-9]+]]
; PEEL2UNROLL2:       for.exit.loopexit:
; PEEL2UNROLL2-NEXT:    br label [[FOR_EXIT]]
; PEEL2UNROLL2:       for.exit:
; PEEL2UNROLL2-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.body ]
  %arrayidx = getelementptr inbounds [8 x i32], [8 x i32]* @a, i64 0, i64 %indvars.iv
  %0 = trunc i64 %indvars.iv to i32
  store i32 %0, i32* %arrayidx, align 4
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond = icmp ne i64 %indvars.iv.next, 8
  br i1 %exitcond, label %for.body, label %for.exit

for.exit:                        ; preds = %for.body
  ret void
}
