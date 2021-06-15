; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -S -passes='default<O1>' -mtriple aarch64 -mcpu=cortex-a55 | FileCheck %s -check-prefix=CHECK-A55
; RUN: opt < %s -S -passes='default<O1>' -mtriple aarch64 | FileCheck %s -check-prefix=CHECK-GENERIC

; Testing that, while runtime unrolling is performed on in-order cores (such as the cortex-a55), it is not performed when -mcpu is not specified
define void @runtime_unroll_generic(i32 %arg_0, i32* %arg_1, i16* %arg_2, i16* %arg_3) {
; CHECK-A55-LABEL: @runtime_unroll_generic(
; CHECK-A55-NEXT:  entry:
; CHECK-A55-NEXT:    [[ARRAYIDX10:%.*]] = getelementptr inbounds i16, i16* [[ARG_2:%.*]], i64 undef
; CHECK-A55-NEXT:    [[ARRAYIDX14:%.*]] = getelementptr inbounds i16, i16* [[ARG_3:%.*]], i64 undef
; CHECK-A55-NEXT:    [[ARRAYIDX20:%.*]] = getelementptr inbounds i32, i32* [[ARG_1:%.*]], i64 undef
; CHECK-A55-NEXT:    [[CMP52_NOT:%.*]] = icmp eq i32 [[ARG_0:%.*]], 0
; CHECK-A55-NEXT:    br i1 [[CMP52_NOT]], label [[FOR_END:%.*]], label [[FOR_BODY6_PREHEADER:%.*]]
; CHECK-A55:       for.body6.preheader:
; CHECK-A55-NEXT:    [[TMP0:%.*]] = add i32 [[ARG_0]], -1
; CHECK-A55-NEXT:    [[XTRAITER:%.*]] = and i32 [[ARG_0]], 3
; CHECK-A55-NEXT:    [[TMP1:%.*]] = icmp ult i32 [[TMP0]], 3
; CHECK-A55-NEXT:    br i1 [[TMP1]], label [[FOR_END_LOOPEXIT_UNR_LCSSA:%.*]], label [[FOR_BODY6_PREHEADER_NEW:%.*]]
; CHECK-A55:       for.body6.preheader.new:
; CHECK-A55-NEXT:    [[UNROLL_ITER:%.*]] = and i32 [[ARG_0]], -4
; CHECK-A55-NEXT:    br label [[FOR_BODY6:%.*]]
; CHECK-A55:       for.body6:
; CHECK-A55-NEXT:    [[NITER:%.*]] = phi i32 [ [[UNROLL_ITER]], [[FOR_BODY6_PREHEADER_NEW]] ], [ [[NITER_NSUB_3:%.*]], [[FOR_BODY6]] ]
; CHECK-A55-NEXT:    [[TMP2:%.*]] = load i16, i16* [[ARRAYIDX10]], align 2
; CHECK-A55-NEXT:    [[CONV:%.*]] = sext i16 [[TMP2]] to i32
; CHECK-A55-NEXT:    [[TMP3:%.*]] = load i16, i16* [[ARRAYIDX14]], align 2
; CHECK-A55-NEXT:    [[CONV15:%.*]] = sext i16 [[TMP3]] to i32
; CHECK-A55-NEXT:    [[MUL16:%.*]] = mul nsw i32 [[CONV15]], [[CONV]]
; CHECK-A55-NEXT:    [[TMP4:%.*]] = load i32, i32* [[ARRAYIDX20]], align 4
; CHECK-A55-NEXT:    [[ADD21:%.*]] = add nsw i32 [[MUL16]], [[TMP4]]
; CHECK-A55-NEXT:    store i32 [[ADD21]], i32* [[ARRAYIDX20]], align 4
; CHECK-A55-NEXT:    [[TMP5:%.*]] = load i16, i16* [[ARRAYIDX10]], align 2
; CHECK-A55-NEXT:    [[CONV_1:%.*]] = sext i16 [[TMP5]] to i32
; CHECK-A55-NEXT:    [[TMP6:%.*]] = load i16, i16* [[ARRAYIDX14]], align 2
; CHECK-A55-NEXT:    [[CONV15_1:%.*]] = sext i16 [[TMP6]] to i32
; CHECK-A55-NEXT:    [[MUL16_1:%.*]] = mul nsw i32 [[CONV15_1]], [[CONV_1]]
; CHECK-A55-NEXT:    [[ADD21_1:%.*]] = add nsw i32 [[MUL16_1]], [[ADD21]]
; CHECK-A55-NEXT:    store i32 [[ADD21_1]], i32* [[ARRAYIDX20]], align 4
; CHECK-A55-NEXT:    [[TMP7:%.*]] = load i16, i16* [[ARRAYIDX10]], align 2
; CHECK-A55-NEXT:    [[CONV_2:%.*]] = sext i16 [[TMP7]] to i32
; CHECK-A55-NEXT:    [[TMP8:%.*]] = load i16, i16* [[ARRAYIDX14]], align 2
; CHECK-A55-NEXT:    [[CONV15_2:%.*]] = sext i16 [[TMP8]] to i32
; CHECK-A55-NEXT:    [[MUL16_2:%.*]] = mul nsw i32 [[CONV15_2]], [[CONV_2]]
; CHECK-A55-NEXT:    [[ADD21_2:%.*]] = add nsw i32 [[MUL16_2]], [[ADD21_1]]
; CHECK-A55-NEXT:    store i32 [[ADD21_2]], i32* [[ARRAYIDX20]], align 4
; CHECK-A55-NEXT:    [[TMP9:%.*]] = load i16, i16* [[ARRAYIDX10]], align 2
; CHECK-A55-NEXT:    [[CONV_3:%.*]] = sext i16 [[TMP9]] to i32
; CHECK-A55-NEXT:    [[TMP10:%.*]] = load i16, i16* [[ARRAYIDX14]], align 2
; CHECK-A55-NEXT:    [[CONV15_3:%.*]] = sext i16 [[TMP10]] to i32
; CHECK-A55-NEXT:    [[MUL16_3:%.*]] = mul nsw i32 [[CONV15_3]], [[CONV_3]]
; CHECK-A55-NEXT:    [[ADD21_3:%.*]] = add nsw i32 [[MUL16_3]], [[ADD21_2]]
; CHECK-A55-NEXT:    store i32 [[ADD21_3]], i32* [[ARRAYIDX20]], align 4
; CHECK-A55-NEXT:    [[NITER_NSUB_3]] = add i32 [[NITER]], -4
; CHECK-A55-NEXT:    [[NITER_NCMP_3_NOT:%.*]] = icmp eq i32 [[NITER_NSUB_3]], 0
; CHECK-A55-NEXT:    br i1 [[NITER_NCMP_3_NOT]], label [[FOR_END_LOOPEXIT_UNR_LCSSA]], label [[FOR_BODY6]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK-A55:       for.end.loopexit.unr-lcssa:
; CHECK-A55-NEXT:    [[LCMP_MOD_NOT:%.*]] = icmp eq i32 [[XTRAITER]], 0
; CHECK-A55-NEXT:    br i1 [[LCMP_MOD_NOT]], label [[FOR_END]], label [[FOR_BODY6_EPIL:%.*]]
; CHECK-A55:       for.body6.epil:
; CHECK-A55-NEXT:    [[TMP11:%.*]] = load i16, i16* [[ARRAYIDX10]], align 2
; CHECK-A55-NEXT:    [[CONV_EPIL:%.*]] = sext i16 [[TMP11]] to i32
; CHECK-A55-NEXT:    [[TMP12:%.*]] = load i16, i16* [[ARRAYIDX14]], align 2
; CHECK-A55-NEXT:    [[CONV15_EPIL:%.*]] = sext i16 [[TMP12]] to i32
; CHECK-A55-NEXT:    [[MUL16_EPIL:%.*]] = mul nsw i32 [[CONV15_EPIL]], [[CONV_EPIL]]
; CHECK-A55-NEXT:    [[TMP13:%.*]] = load i32, i32* [[ARRAYIDX20]], align 4
; CHECK-A55-NEXT:    [[ADD21_EPIL:%.*]] = add nsw i32 [[MUL16_EPIL]], [[TMP13]]
; CHECK-A55-NEXT:    store i32 [[ADD21_EPIL]], i32* [[ARRAYIDX20]], align 4
; CHECK-A55-NEXT:    [[EPIL_ITER_CMP_NOT:%.*]] = icmp eq i32 [[XTRAITER]], 1
; CHECK-A55-NEXT:    br i1 [[EPIL_ITER_CMP_NOT]], label [[FOR_END]], label [[FOR_BODY6_EPIL_1:%.*]]
; CHECK-A55:       for.end:
; CHECK-A55-NEXT:    ret void
; CHECK-A55:       for.body6.epil.1:
; CHECK-A55-NEXT:    [[TMP14:%.*]] = load i16, i16* [[ARRAYIDX10]], align 2
; CHECK-A55-NEXT:    [[CONV_EPIL_1:%.*]] = sext i16 [[TMP14]] to i32
; CHECK-A55-NEXT:    [[TMP15:%.*]] = load i16, i16* [[ARRAYIDX14]], align 2
; CHECK-A55-NEXT:    [[CONV15_EPIL_1:%.*]] = sext i16 [[TMP15]] to i32
; CHECK-A55-NEXT:    [[MUL16_EPIL_1:%.*]] = mul nsw i32 [[CONV15_EPIL_1]], [[CONV_EPIL_1]]
; CHECK-A55-NEXT:    [[TMP16:%.*]] = load i32, i32* [[ARRAYIDX20]], align 4
; CHECK-A55-NEXT:    [[ADD21_EPIL_1:%.*]] = add nsw i32 [[MUL16_EPIL_1]], [[TMP16]]
; CHECK-A55-NEXT:    store i32 [[ADD21_EPIL_1]], i32* [[ARRAYIDX20]], align 4
; CHECK-A55-NEXT:    [[EPIL_ITER_CMP_1_NOT:%.*]] = icmp eq i32 [[XTRAITER]], 2
; CHECK-A55-NEXT:    br i1 [[EPIL_ITER_CMP_1_NOT]], label [[FOR_END]], label [[FOR_BODY6_EPIL_2:%.*]]
; CHECK-A55:       for.body6.epil.2:
; CHECK-A55-NEXT:    [[TMP17:%.*]] = load i16, i16* [[ARRAYIDX10]], align 2
; CHECK-A55-NEXT:    [[CONV_EPIL_2:%.*]] = sext i16 [[TMP17]] to i32
; CHECK-A55-NEXT:    [[TMP18:%.*]] = load i16, i16* [[ARRAYIDX14]], align 2
; CHECK-A55-NEXT:    [[CONV15_EPIL_2:%.*]] = sext i16 [[TMP18]] to i32
; CHECK-A55-NEXT:    [[MUL16_EPIL_2:%.*]] = mul nsw i32 [[CONV15_EPIL_2]], [[CONV_EPIL_2]]
; CHECK-A55-NEXT:    [[TMP19:%.*]] = load i32, i32* [[ARRAYIDX20]], align 4
; CHECK-A55-NEXT:    [[ADD21_EPIL_2:%.*]] = add nsw i32 [[MUL16_EPIL_2]], [[TMP19]]
; CHECK-A55-NEXT:    store i32 [[ADD21_EPIL_2]], i32* [[ARRAYIDX20]], align 4
; CHECK-A55-NEXT:    br label [[FOR_END]]
;
; CHECK-GENERIC-LABEL: @runtime_unroll_generic(
; CHECK-GENERIC-NEXT:  entry:
; CHECK-GENERIC-NEXT:    [[ARRAYIDX10:%.*]] = getelementptr inbounds i16, i16* [[ARG_2:%.*]], i64 undef
; CHECK-GENERIC-NEXT:    [[ARRAYIDX14:%.*]] = getelementptr inbounds i16, i16* [[ARG_3:%.*]], i64 undef
; CHECK-GENERIC-NEXT:    [[ARRAYIDX20:%.*]] = getelementptr inbounds i32, i32* [[ARG_1:%.*]], i64 undef
; CHECK-GENERIC-NEXT:    [[CMP52_NOT:%.*]] = icmp eq i32 [[ARG_0:%.*]], 0
; CHECK-GENERIC-NEXT:    br i1 [[CMP52_NOT]], label [[FOR_END:%.*]], label [[FOR_BODY6:%.*]]
; CHECK-GENERIC:       for.body6:
; CHECK-GENERIC-NEXT:    [[K_03:%.*]] = phi i32 [ [[INC:%.*]], [[FOR_BODY6]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-GENERIC-NEXT:    [[TMP0:%.*]] = load i16, i16* [[ARRAYIDX10]], align 2
; CHECK-GENERIC-NEXT:    [[CONV:%.*]] = sext i16 [[TMP0]] to i32
; CHECK-GENERIC-NEXT:    [[TMP1:%.*]] = load i16, i16* [[ARRAYIDX14]], align 2
; CHECK-GENERIC-NEXT:    [[CONV15:%.*]] = sext i16 [[TMP1]] to i32
; CHECK-GENERIC-NEXT:    [[MUL16:%.*]] = mul nsw i32 [[CONV15]], [[CONV]]
; CHECK-GENERIC-NEXT:    [[TMP2:%.*]] = load i32, i32* [[ARRAYIDX20]], align 4
; CHECK-GENERIC-NEXT:    [[ADD21:%.*]] = add nsw i32 [[MUL16]], [[TMP2]]
; CHECK-GENERIC-NEXT:    store i32 [[ADD21]], i32* [[ARRAYIDX20]], align 4
; CHECK-GENERIC-NEXT:    [[INC]] = add nuw i32 [[K_03]], 1
; CHECK-GENERIC-NEXT:    [[CMP5:%.*]] = icmp ult i32 [[INC]], [[ARG_0]]
; CHECK-GENERIC-NEXT:    br i1 [[CMP5]], label [[FOR_BODY6]], label [[FOR_END]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK-GENERIC:       for.end:
; CHECK-GENERIC-NEXT:    ret void
;
entry:
  %arg_0.addr = alloca i32, align 4
  %arg_1.addr = alloca i32*, align 8
  %arg_2.addr = alloca i16*, align 8
  %arg_3.addr = alloca i16*, align 8
  %k = alloca i32, align 4
  store i32 %arg_0, i32* %arg_0.addr, align 4
  store i32* %arg_1, i32** %arg_1.addr, align 8
  store i16* %arg_2, i16** %arg_2.addr, align 8
  store i16* %arg_3, i16** %arg_3.addr, align 8
  br label %for.cond

for.cond:                                         ; preds = %entry
  br label %for.body

for.body:                                         ; preds = %for.cond
  br label %for.cond1

for.cond1:                                        ; preds = %for.body
  br label %for.body3

for.body3:                                        ; preds = %for.cond1
  store i32 0, i32* %k, align 4
  br label %for.cond4

for.cond4:                                        ; preds = %for.inc, %for.body3
  %0 = load i32, i32* %k, align 4
  %1 = load i32, i32* %arg_0.addr, align 4
  %cmp5 = icmp ult i32 %0, %1
  br i1 %cmp5, label %for.body6, label %for.end

for.body6:                                        ; preds = %for.cond4
  %2 = load i16*, i16** %arg_2.addr, align 8
  %arrayidx10 = getelementptr inbounds i16, i16* %2, i64 undef
  %3 = load i16, i16* %arrayidx10, align 2
  %conv = sext i16 %3 to i32
  %4 = load i16*, i16** %arg_3.addr, align 8
  %arrayidx14 = getelementptr inbounds i16, i16* %4, i64 undef
  %5 = load i16, i16* %arrayidx14, align 2
  %conv15 = sext i16 %5 to i32
  %mul16 = mul nsw i32 %conv, %conv15
  %6 = load i32*, i32** %arg_1.addr, align 8
  %arrayidx20 = getelementptr inbounds i32, i32* %6, i64 undef
  %7 = load i32, i32* %arrayidx20, align 4
  %add21 = add nsw i32 %7, %mul16
  store i32 %add21, i32* %arrayidx20, align 4
  br label %for.inc

for.inc:                                          ; preds = %for.body6
  %8 = load i32, i32* %k, align 4
  %inc = add i32 %8, 1
  store i32 %inc, i32* %k, align 4
  br label %for.cond4, !llvm.loop !0

for.end:                                          ; preds = %for.cond4
  ret void
}

!0 = distinct !{!0, !1}
!1 = !{!"llvm.loop.mustprogress"}
