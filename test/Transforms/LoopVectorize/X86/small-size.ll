; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basic-aa -loop-vectorize -force-vector-interleave=1 -force-vector-width=4 -loop-vectorize-with-block-frequency -dce -instcombine -S | FileCheck %s

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.8.0"

@b = common global [2048 x i32] zeroinitializer, align 16
@c = common global [2048 x i32] zeroinitializer, align 16
@a = common global [2048 x i32] zeroinitializer, align 16
@G = common global [32 x [1024 x i32]] zeroinitializer, align 16
@ub = common global [1024 x i32] zeroinitializer, align 16
@uc = common global [1024 x i32] zeroinitializer, align 16
@d = common global [2048 x i32] zeroinitializer, align 16
@fa = common global [1024 x float] zeroinitializer, align 16
@fb = common global [1024 x float] zeroinitializer, align 16
@ic = common global [1024 x i32] zeroinitializer, align 16
@da = common global [1024 x float] zeroinitializer, align 16
@db = common global [1024 x float] zeroinitializer, align 16
@dc = common global [1024 x float] zeroinitializer, align 16
@dd = common global [1024 x float] zeroinitializer, align 16
@dj = common global [1024 x i32] zeroinitializer, align 16

; We can optimize this test without a tail.
define void @example1() optsize {
; CHECK-LABEL: @example1(
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds [2048 x i32], [2048 x i32]* @b, i64 0, i64 [[INDEX]]
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast i32* [[TMP1]] to <4 x i32>*
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <4 x i32>, <4 x i32>* [[TMP2]], align 16
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr inbounds [2048 x i32], [2048 x i32]* @c, i64 0, i64 [[INDEX]]
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast i32* [[TMP3]] to <4 x i32>*
; CHECK-NEXT:    [[WIDE_LOAD1:%.*]] = load <4 x i32>, <4 x i32>* [[TMP4]], align 16
; CHECK-NEXT:    [[TMP5:%.*]] = add nsw <4 x i32> [[WIDE_LOAD1]], [[WIDE_LOAD]]
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr inbounds [2048 x i32], [2048 x i32]* @a, i64 0, i64 [[INDEX]]
; CHECK-NEXT:    [[TMP7:%.*]] = bitcast i32* [[TMP6]] to <4 x i32>*
; CHECK-NEXT:    store <4 x i32> [[TMP5]], <4 x i32>* [[TMP7]], align 16
; CHECK-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 4
; CHECK-NEXT:    [[TMP8:%.*]] = icmp eq i64 [[INDEX_NEXT]], 256
; CHECK-NEXT:    br i1 [[TMP8]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], [[LOOP0:!llvm.loop !.*]]
; CHECK:       middle.block:
; CHECK-NEXT:    br i1 true, label [[TMP10:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    br label [[TMP9:%.*]]
; CHECK:       9:
; CHECK-NEXT:    br i1 undef, label [[TMP10]], label [[TMP9]], [[LOOP2:!llvm.loop !.*]]
; CHECK:       10:
; CHECK-NEXT:    ret void
;
  br label %1

; <label>:1                                       ; preds = %1, %0
  %indvars.iv = phi i64 [ 0, %0 ], [ %indvars.iv.next, %1 ]
  %2 = getelementptr inbounds [2048 x i32], [2048 x i32]* @b, i64 0, i64 %indvars.iv
  %3 = load i32, i32* %2, align 4
  %4 = getelementptr inbounds [2048 x i32], [2048 x i32]* @c, i64 0, i64 %indvars.iv
  %5 = load i32, i32* %4, align 4
  %6 = add nsw i32 %5, %3
  %7 = getelementptr inbounds [2048 x i32], [2048 x i32]* @a, i64 0, i64 %indvars.iv
  store i32 %6, i32* %7, align 4
  %indvars.iv.next = add i64 %indvars.iv, 1
  %lftr.wideiv = trunc i64 %indvars.iv.next to i32
  %exitcond = icmp eq i32 %lftr.wideiv, 256
  br i1 %exitcond, label %8, label %1

; <label>:8                                       ; preds = %1
  ret void
}

; Can vectorize in 'optsize' mode by masking the needed tail.
define void @example2(i32 %n, i32 %x) optsize {
; CHECK-LABEL: @example2(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp sgt i32 [[N:%.*]], 0
; CHECK-NEXT:    br i1 [[TMP1]], label [[DOTLR_PH5_PREHEADER:%.*]], label [[DOTPREHEADER:%.*]]
; CHECK:       .lr.ph5.preheader:
; CHECK-NEXT:    [[TMP2:%.*]] = add i32 [[N]], -1
; CHECK-NEXT:    [[TMP3:%.*]] = zext i32 [[TMP2]] to i64
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_RND_UP:%.*]] = add nuw nsw i64 [[TMP3]], 4
; CHECK-NEXT:    [[N_VEC:%.*]] = and i64 [[N_RND_UP]], 8589934588
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <4 x i64> poison, i64 [[TMP3]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <4 x i64> [[BROADCAST_SPLATINSERT]], <4 x i64> poison, <4 x i32> zeroinitializer
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[PRED_STORE_CONTINUE6:%.*]] ]
; CHECK-NEXT:    [[VEC_IND:%.*]] = phi <4 x i64> [ <i64 0, i64 1, i64 2, i64 3>, [[VECTOR_PH]] ], [ [[VEC_IND_NEXT:%.*]], [[PRED_STORE_CONTINUE6]] ]
; CHECK-NEXT:    [[TMP4:%.*]] = icmp ule <4 x i64> [[VEC_IND]], [[BROADCAST_SPLAT]]
; CHECK-NEXT:    [[TMP5:%.*]] = extractelement <4 x i1> [[TMP4]], i32 0
; CHECK-NEXT:    br i1 [[TMP5]], label [[PRED_STORE_IF:%.*]], label [[PRED_STORE_CONTINUE:%.*]]
; CHECK:       pred.store.if:
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr inbounds [2048 x i32], [2048 x i32]* @b, i64 0, i64 [[INDEX]]
; CHECK-NEXT:    store i32 [[X:%.*]], i32* [[TMP6]], align 16
; CHECK-NEXT:    br label [[PRED_STORE_CONTINUE]]
; CHECK:       pred.store.continue:
; CHECK-NEXT:    [[TMP7:%.*]] = extractelement <4 x i1> [[TMP4]], i32 1
; CHECK-NEXT:    br i1 [[TMP7]], label [[PRED_STORE_IF1:%.*]], label [[PRED_STORE_CONTINUE2:%.*]]
; CHECK:       pred.store.if1:
; CHECK-NEXT:    [[TMP8:%.*]] = or i64 [[INDEX]], 1
; CHECK-NEXT:    [[TMP9:%.*]] = getelementptr inbounds [2048 x i32], [2048 x i32]* @b, i64 0, i64 [[TMP8]]
; CHECK-NEXT:    store i32 [[X]], i32* [[TMP9]], align 4
; CHECK-NEXT:    br label [[PRED_STORE_CONTINUE2]]
; CHECK:       pred.store.continue2:
; CHECK-NEXT:    [[TMP10:%.*]] = extractelement <4 x i1> [[TMP4]], i32 2
; CHECK-NEXT:    br i1 [[TMP10]], label [[PRED_STORE_IF3:%.*]], label [[PRED_STORE_CONTINUE4:%.*]]
; CHECK:       pred.store.if3:
; CHECK-NEXT:    [[TMP11:%.*]] = or i64 [[INDEX]], 2
; CHECK-NEXT:    [[TMP12:%.*]] = getelementptr inbounds [2048 x i32], [2048 x i32]* @b, i64 0, i64 [[TMP11]]
; CHECK-NEXT:    store i32 [[X]], i32* [[TMP12]], align 8
; CHECK-NEXT:    br label [[PRED_STORE_CONTINUE4]]
; CHECK:       pred.store.continue4:
; CHECK-NEXT:    [[TMP13:%.*]] = extractelement <4 x i1> [[TMP4]], i32 3
; CHECK-NEXT:    br i1 [[TMP13]], label [[PRED_STORE_IF5:%.*]], label [[PRED_STORE_CONTINUE6]]
; CHECK:       pred.store.if5:
; CHECK-NEXT:    [[TMP14:%.*]] = or i64 [[INDEX]], 3
; CHECK-NEXT:    [[TMP15:%.*]] = getelementptr inbounds [2048 x i32], [2048 x i32]* @b, i64 0, i64 [[TMP14]]
; CHECK-NEXT:    store i32 [[X]], i32* [[TMP15]], align 4
; CHECK-NEXT:    br label [[PRED_STORE_CONTINUE6]]
; CHECK:       pred.store.continue6:
; CHECK-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 4
; CHECK-NEXT:    [[VEC_IND_NEXT]] = add <4 x i64> [[VEC_IND]], <i64 4, i64 4, i64 4, i64 4>
; CHECK-NEXT:    [[TMP16:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP16]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], [[LOOP4:!llvm.loop !.*]]
; CHECK:       middle.block:
; CHECK-NEXT:    br i1 true, label [[DOT_PREHEADER_CRIT_EDGE:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    br label [[DOTLR_PH5:%.*]]
; CHECK:       ..preheader_crit_edge:
; CHECK-NEXT:    [[PHITMP:%.*]] = sext i32 [[N]] to i64
; CHECK-NEXT:    br label [[DOTPREHEADER]]
; CHECK:       .preheader:
; CHECK-NEXT:    [[I_0_LCSSA:%.*]] = phi i64 [ [[PHITMP]], [[DOT_PREHEADER_CRIT_EDGE]] ], [ 0, [[TMP0:%.*]] ]
; CHECK-NEXT:    [[TMP17:%.*]] = icmp eq i32 [[N]], 0
; CHECK-NEXT:    br i1 [[TMP17]], label [[DOT_CRIT_EDGE:%.*]], label [[DOTLR_PH_PREHEADER:%.*]]
; CHECK:       .lr.ph.preheader:
; CHECK-NEXT:    [[TMP18:%.*]] = add i32 [[N]], -1
; CHECK-NEXT:    [[TMP19:%.*]] = zext i32 [[TMP18]] to i64
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH8:%.*]], label [[VECTOR_PH10:%.*]]
; CHECK:       vector.ph10:
; CHECK-NEXT:    [[N_RND_UP11:%.*]] = add nuw nsw i64 [[TMP19]], 4
; CHECK-NEXT:    [[N_VEC13:%.*]] = and i64 [[N_RND_UP11]], 8589934588
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT20:%.*]] = insertelement <4 x i64> poison, i64 [[TMP19]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT21:%.*]] = shufflevector <4 x i64> [[BROADCAST_SPLATINSERT20]], <4 x i64> poison, <4 x i32> zeroinitializer
; CHECK-NEXT:    br label [[VECTOR_BODY9:%.*]]
; CHECK:       vector.body9:
; CHECK-NEXT:    [[INDEX14:%.*]] = phi i64 [ 0, [[VECTOR_PH10]] ], [ [[INDEX_NEXT15:%.*]], [[PRED_STORE_CONTINUE51:%.*]] ]
; CHECK-NEXT:    [[OFFSET_IDX:%.*]] = add i64 [[I_0_LCSSA]], [[INDEX14]]
; CHECK-NEXT:    [[TMP20:%.*]] = add i64 [[OFFSET_IDX]], 1
; CHECK-NEXT:    [[TMP21:%.*]] = add i64 [[OFFSET_IDX]], 2
; CHECK-NEXT:    [[TMP22:%.*]] = add i64 [[OFFSET_IDX]], 3
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT28:%.*]] = insertelement <4 x i64> poison, i64 [[INDEX14]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT29:%.*]] = shufflevector <4 x i64> [[BROADCAST_SPLATINSERT28]], <4 x i64> poison, <4 x i32> zeroinitializer
; CHECK-NEXT:    [[VEC_IV:%.*]] = or <4 x i64> [[BROADCAST_SPLAT29]], <i64 0, i64 1, i64 2, i64 3>
; CHECK-NEXT:    [[TMP23:%.*]] = icmp ule <4 x i64> [[VEC_IV]], [[BROADCAST_SPLAT21]]
; CHECK-NEXT:    [[TMP24:%.*]] = extractelement <4 x i1> [[TMP23]], i32 0
; CHECK-NEXT:    br i1 [[TMP24]], label [[PRED_LOAD_IF:%.*]], label [[PRED_LOAD_CONTINUE:%.*]]
; CHECK:       pred.load.if:
; CHECK-NEXT:    [[TMP25:%.*]] = getelementptr inbounds [2048 x i32], [2048 x i32]* @b, i64 0, i64 [[OFFSET_IDX]]
; CHECK-NEXT:    [[TMP26:%.*]] = load i32, i32* [[TMP25]], align 4
; CHECK-NEXT:    br label [[PRED_LOAD_CONTINUE]]
; CHECK:       pred.load.continue:
; CHECK-NEXT:    [[TMP27:%.*]] = phi i32 [ poison, [[VECTOR_BODY9]] ], [ [[TMP26]], [[PRED_LOAD_IF]] ]
; CHECK-NEXT:    [[TMP28:%.*]] = extractelement <4 x i1> [[TMP23]], i32 1
; CHECK-NEXT:    br i1 [[TMP28]], label [[PRED_LOAD_IF30:%.*]], label [[PRED_LOAD_CONTINUE31:%.*]]
; CHECK:       pred.load.if30:
; CHECK-NEXT:    [[TMP29:%.*]] = getelementptr inbounds [2048 x i32], [2048 x i32]* @b, i64 0, i64 [[TMP20]]
; CHECK-NEXT:    [[TMP30:%.*]] = load i32, i32* [[TMP29]], align 4
; CHECK-NEXT:    br label [[PRED_LOAD_CONTINUE31]]
; CHECK:       pred.load.continue31:
; CHECK-NEXT:    [[TMP31:%.*]] = phi i32 [ poison, [[PRED_LOAD_CONTINUE]] ], [ [[TMP30]], [[PRED_LOAD_IF30]] ]
; CHECK-NEXT:    [[TMP32:%.*]] = extractelement <4 x i1> [[TMP23]], i32 2
; CHECK-NEXT:    br i1 [[TMP32]], label [[PRED_LOAD_IF32:%.*]], label [[PRED_LOAD_CONTINUE33:%.*]]
; CHECK:       pred.load.if32:
; CHECK-NEXT:    [[TMP33:%.*]] = getelementptr inbounds [2048 x i32], [2048 x i32]* @b, i64 0, i64 [[TMP21]]
; CHECK-NEXT:    [[TMP34:%.*]] = load i32, i32* [[TMP33]], align 4
; CHECK-NEXT:    br label [[PRED_LOAD_CONTINUE33]]
; CHECK:       pred.load.continue33:
; CHECK-NEXT:    [[TMP35:%.*]] = phi i32 [ poison, [[PRED_LOAD_CONTINUE31]] ], [ [[TMP34]], [[PRED_LOAD_IF32]] ]
; CHECK-NEXT:    [[TMP36:%.*]] = extractelement <4 x i1> [[TMP23]], i32 3
; CHECK-NEXT:    br i1 [[TMP36]], label [[PRED_LOAD_IF34:%.*]], label [[PRED_LOAD_CONTINUE35:%.*]]
; CHECK:       pred.load.if34:
; CHECK-NEXT:    [[TMP37:%.*]] = getelementptr inbounds [2048 x i32], [2048 x i32]* @b, i64 0, i64 [[TMP22]]
; CHECK-NEXT:    [[TMP38:%.*]] = load i32, i32* [[TMP37]], align 4
; CHECK-NEXT:    br label [[PRED_LOAD_CONTINUE35]]
; CHECK:       pred.load.continue35:
; CHECK-NEXT:    [[TMP39:%.*]] = phi i32 [ poison, [[PRED_LOAD_CONTINUE33]] ], [ [[TMP38]], [[PRED_LOAD_IF34]] ]
; CHECK-NEXT:    [[TMP40:%.*]] = extractelement <4 x i1> [[TMP23]], i32 0
; CHECK-NEXT:    br i1 [[TMP40]], label [[PRED_LOAD_IF36:%.*]], label [[PRED_LOAD_CONTINUE37:%.*]]
; CHECK:       pred.load.if36:
; CHECK-NEXT:    [[TMP41:%.*]] = getelementptr inbounds [2048 x i32], [2048 x i32]* @c, i64 0, i64 [[OFFSET_IDX]]
; CHECK-NEXT:    [[TMP42:%.*]] = load i32, i32* [[TMP41]], align 4
; CHECK-NEXT:    br label [[PRED_LOAD_CONTINUE37]]
; CHECK:       pred.load.continue37:
; CHECK-NEXT:    [[TMP43:%.*]] = phi i32 [ poison, [[PRED_LOAD_CONTINUE35]] ], [ [[TMP42]], [[PRED_LOAD_IF36]] ]
; CHECK-NEXT:    [[TMP44:%.*]] = extractelement <4 x i1> [[TMP23]], i32 1
; CHECK-NEXT:    br i1 [[TMP44]], label [[PRED_LOAD_IF38:%.*]], label [[PRED_LOAD_CONTINUE39:%.*]]
; CHECK:       pred.load.if38:
; CHECK-NEXT:    [[TMP45:%.*]] = getelementptr inbounds [2048 x i32], [2048 x i32]* @c, i64 0, i64 [[TMP20]]
; CHECK-NEXT:    [[TMP46:%.*]] = load i32, i32* [[TMP45]], align 4
; CHECK-NEXT:    br label [[PRED_LOAD_CONTINUE39]]
; CHECK:       pred.load.continue39:
; CHECK-NEXT:    [[TMP47:%.*]] = phi i32 [ poison, [[PRED_LOAD_CONTINUE37]] ], [ [[TMP46]], [[PRED_LOAD_IF38]] ]
; CHECK-NEXT:    [[TMP48:%.*]] = extractelement <4 x i1> [[TMP23]], i32 2
; CHECK-NEXT:    br i1 [[TMP48]], label [[PRED_LOAD_IF40:%.*]], label [[PRED_LOAD_CONTINUE41:%.*]]
; CHECK:       pred.load.if40:
; CHECK-NEXT:    [[TMP49:%.*]] = getelementptr inbounds [2048 x i32], [2048 x i32]* @c, i64 0, i64 [[TMP21]]
; CHECK-NEXT:    [[TMP50:%.*]] = load i32, i32* [[TMP49]], align 4
; CHECK-NEXT:    br label [[PRED_LOAD_CONTINUE41]]
; CHECK:       pred.load.continue41:
; CHECK-NEXT:    [[TMP51:%.*]] = phi i32 [ poison, [[PRED_LOAD_CONTINUE39]] ], [ [[TMP50]], [[PRED_LOAD_IF40]] ]
; CHECK-NEXT:    [[TMP52:%.*]] = extractelement <4 x i1> [[TMP23]], i32 3
; CHECK-NEXT:    br i1 [[TMP52]], label [[PRED_LOAD_IF42:%.*]], label [[PRED_LOAD_CONTINUE43:%.*]]
; CHECK:       pred.load.if42:
; CHECK-NEXT:    [[TMP53:%.*]] = getelementptr inbounds [2048 x i32], [2048 x i32]* @c, i64 0, i64 [[TMP22]]
; CHECK-NEXT:    [[TMP54:%.*]] = load i32, i32* [[TMP53]], align 4
; CHECK-NEXT:    br label [[PRED_LOAD_CONTINUE43]]
; CHECK:       pred.load.continue43:
; CHECK-NEXT:    [[TMP55:%.*]] = phi i32 [ poison, [[PRED_LOAD_CONTINUE41]] ], [ [[TMP54]], [[PRED_LOAD_IF42]] ]
; CHECK-NEXT:    [[TMP56:%.*]] = extractelement <4 x i1> [[TMP23]], i32 0
; CHECK-NEXT:    br i1 [[TMP56]], label [[PRED_STORE_IF44:%.*]], label [[PRED_STORE_CONTINUE45:%.*]]
; CHECK:       pred.store.if44:
; CHECK-NEXT:    [[TMP57:%.*]] = and i32 [[TMP43]], [[TMP27]]
; CHECK-NEXT:    [[TMP58:%.*]] = getelementptr inbounds [2048 x i32], [2048 x i32]* @a, i64 0, i64 [[OFFSET_IDX]]
; CHECK-NEXT:    store i32 [[TMP57]], i32* [[TMP58]], align 4
; CHECK-NEXT:    br label [[PRED_STORE_CONTINUE45]]
; CHECK:       pred.store.continue45:
; CHECK-NEXT:    [[TMP59:%.*]] = extractelement <4 x i1> [[TMP23]], i32 1
; CHECK-NEXT:    br i1 [[TMP59]], label [[PRED_STORE_IF46:%.*]], label [[PRED_STORE_CONTINUE47:%.*]]
; CHECK:       pred.store.if46:
; CHECK-NEXT:    [[TMP60:%.*]] = and i32 [[TMP47]], [[TMP31]]
; CHECK-NEXT:    [[TMP61:%.*]] = getelementptr inbounds [2048 x i32], [2048 x i32]* @a, i64 0, i64 [[TMP20]]
; CHECK-NEXT:    store i32 [[TMP60]], i32* [[TMP61]], align 4
; CHECK-NEXT:    br label [[PRED_STORE_CONTINUE47]]
; CHECK:       pred.store.continue47:
; CHECK-NEXT:    [[TMP62:%.*]] = extractelement <4 x i1> [[TMP23]], i32 2
; CHECK-NEXT:    br i1 [[TMP62]], label [[PRED_STORE_IF48:%.*]], label [[PRED_STORE_CONTINUE49:%.*]]
; CHECK:       pred.store.if48:
; CHECK-NEXT:    [[TMP63:%.*]] = and i32 [[TMP51]], [[TMP35]]
; CHECK-NEXT:    [[TMP64:%.*]] = getelementptr inbounds [2048 x i32], [2048 x i32]* @a, i64 0, i64 [[TMP21]]
; CHECK-NEXT:    store i32 [[TMP63]], i32* [[TMP64]], align 4
; CHECK-NEXT:    br label [[PRED_STORE_CONTINUE49]]
; CHECK:       pred.store.continue49:
; CHECK-NEXT:    [[TMP65:%.*]] = extractelement <4 x i1> [[TMP23]], i32 3
; CHECK-NEXT:    br i1 [[TMP65]], label [[PRED_STORE_IF50:%.*]], label [[PRED_STORE_CONTINUE51]]
; CHECK:       pred.store.if50:
; CHECK-NEXT:    [[TMP66:%.*]] = and i32 [[TMP55]], [[TMP39]]
; CHECK-NEXT:    [[TMP67:%.*]] = getelementptr inbounds [2048 x i32], [2048 x i32]* @a, i64 0, i64 [[TMP22]]
; CHECK-NEXT:    store i32 [[TMP66]], i32* [[TMP67]], align 4
; CHECK-NEXT:    br label [[PRED_STORE_CONTINUE51]]
; CHECK:       pred.store.continue51:
; CHECK-NEXT:    [[INDEX_NEXT15]] = add i64 [[INDEX14]], 4
; CHECK-NEXT:    [[TMP68:%.*]] = icmp eq i64 [[INDEX_NEXT15]], [[N_VEC13]]
; CHECK-NEXT:    br i1 [[TMP68]], label [[MIDDLE_BLOCK7:%.*]], label [[VECTOR_BODY9]], [[LOOP5:!llvm.loop !.*]]
; CHECK:       middle.block7:
; CHECK-NEXT:    br i1 true, label [[DOT_CRIT_EDGE_LOOPEXIT:%.*]], label [[SCALAR_PH8]]
; CHECK:       scalar.ph8:
; CHECK-NEXT:    br label [[DOTLR_PH:%.*]]
; CHECK:       .lr.ph5:
; CHECK-NEXT:    br i1 undef, label [[DOT_PREHEADER_CRIT_EDGE]], label [[DOTLR_PH5]], [[LOOP6:!llvm.loop !.*]]
; CHECK:       .lr.ph:
; CHECK-NEXT:    br i1 undef, label [[DOT_CRIT_EDGE_LOOPEXIT]], label [[DOTLR_PH]], [[LOOP7:!llvm.loop !.*]]
; CHECK:       ._crit_edge.loopexit:
; CHECK-NEXT:    br label [[DOT_CRIT_EDGE]]
; CHECK:       ._crit_edge:
; CHECK-NEXT:    ret void
;
  %1 = icmp sgt i32 %n, 0
  br i1 %1, label %.lr.ph5, label %.preheader

..preheader_crit_edge:                            ; preds = %.lr.ph5
  %phitmp = sext i32 %n to i64
  br label %.preheader

.preheader:                                       ; preds = %..preheader_crit_edge, %0
  %i.0.lcssa = phi i64 [ %phitmp, %..preheader_crit_edge ], [ 0, %0 ]
  %2 = icmp eq i32 %n, 0
  br i1 %2, label %._crit_edge, label %.lr.ph

.lr.ph5:                                          ; preds = %0, %.lr.ph5
  %indvars.iv6 = phi i64 [ %indvars.iv.next7, %.lr.ph5 ], [ 0, %0 ]
  %3 = getelementptr inbounds [2048 x i32], [2048 x i32]* @b, i64 0, i64 %indvars.iv6
  store i32 %x, i32* %3, align 4
  %indvars.iv.next7 = add i64 %indvars.iv6, 1
  %lftr.wideiv = trunc i64 %indvars.iv.next7 to i32
  %exitcond = icmp eq i32 %lftr.wideiv, %n
  br i1 %exitcond, label %..preheader_crit_edge, label %.lr.ph5

.lr.ph:                                           ; preds = %.preheader, %.lr.ph
  %indvars.iv = phi i64 [ %indvars.iv.next, %.lr.ph ], [ %i.0.lcssa, %.preheader ]
  %.02 = phi i32 [ %4, %.lr.ph ], [ %n, %.preheader ]
  %4 = add nsw i32 %.02, -1
  %5 = getelementptr inbounds [2048 x i32], [2048 x i32]* @b, i64 0, i64 %indvars.iv
  %6 = load i32, i32* %5, align 4
  %7 = getelementptr inbounds [2048 x i32], [2048 x i32]* @c, i64 0, i64 %indvars.iv
  %8 = load i32, i32* %7, align 4
  %9 = and i32 %8, %6
  %10 = getelementptr inbounds [2048 x i32], [2048 x i32]* @a, i64 0, i64 %indvars.iv
  store i32 %9, i32* %10, align 4
  %indvars.iv.next = add i64 %indvars.iv, 1
  %11 = icmp eq i32 %4, 0
  br i1 %11, label %._crit_edge, label %.lr.ph

._crit_edge:                                      ; preds = %.lr.ph, %.preheader
  ret void
}

; Loop has no primary induction as its integer IV has step -1 starting at
; unknown N, but can still be vectorized.
define void @example3(i32 %n, i32* noalias nocapture %p, i32* noalias nocapture %q) optsize {
; CHECK-LABEL: @example3(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq i32 [[N:%.*]], 0
; CHECK-NEXT:    br i1 [[TMP1]], label [[DOT_CRIT_EDGE:%.*]], label [[DOTLR_PH_PREHEADER:%.*]]
; CHECK:       .lr.ph.preheader:
; CHECK-NEXT:    [[TMP2:%.*]] = add i32 [[N]], -1
; CHECK-NEXT:    [[TMP3:%.*]] = zext i32 [[TMP2]] to i64
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_RND_UP:%.*]] = add nuw nsw i64 [[TMP3]], 4
; CHECK-NEXT:    [[N_VEC:%.*]] = and i64 [[N_RND_UP]], 8589934588
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <4 x i64> poison, i64 [[TMP3]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <4 x i64> [[BROADCAST_SPLATINSERT]], <4 x i64> poison, <4 x i32> zeroinitializer
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[PRED_STORE_CONTINUE27:%.*]] ]
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT14:%.*]] = insertelement <4 x i64> poison, i64 [[INDEX]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT15:%.*]] = shufflevector <4 x i64> [[BROADCAST_SPLATINSERT14]], <4 x i64> poison, <4 x i32> zeroinitializer
; CHECK-NEXT:    [[VEC_IV:%.*]] = or <4 x i64> [[BROADCAST_SPLAT15]], <i64 0, i64 1, i64 2, i64 3>
; CHECK-NEXT:    [[TMP4:%.*]] = icmp ule <4 x i64> [[VEC_IV]], [[BROADCAST_SPLAT]]
; CHECK-NEXT:    [[TMP5:%.*]] = extractelement <4 x i1> [[TMP4]], i32 0
; CHECK-NEXT:    br i1 [[TMP5]], label [[PRED_LOAD_IF:%.*]], label [[PRED_LOAD_CONTINUE:%.*]]
; CHECK:       pred.load.if:
; CHECK-NEXT:    [[NEXT_GEP10:%.*]] = getelementptr i32, i32* [[Q:%.*]], i64 [[INDEX]]
; CHECK-NEXT:    [[TMP6:%.*]] = load i32, i32* [[NEXT_GEP10]], align 16
; CHECK-NEXT:    br label [[PRED_LOAD_CONTINUE]]
; CHECK:       pred.load.continue:
; CHECK-NEXT:    [[TMP7:%.*]] = phi i32 [ poison, [[VECTOR_BODY]] ], [ [[TMP6]], [[PRED_LOAD_IF]] ]
; CHECK-NEXT:    [[TMP8:%.*]] = extractelement <4 x i1> [[TMP4]], i32 1
; CHECK-NEXT:    br i1 [[TMP8]], label [[PRED_LOAD_IF16:%.*]], label [[PRED_LOAD_CONTINUE17:%.*]]
; CHECK:       pred.load.if16:
; CHECK-NEXT:    [[TMP9:%.*]] = or i64 [[INDEX]], 1
; CHECK-NEXT:    [[NEXT_GEP11:%.*]] = getelementptr i32, i32* [[Q]], i64 [[TMP9]]
; CHECK-NEXT:    [[TMP10:%.*]] = load i32, i32* [[NEXT_GEP11]], align 16
; CHECK-NEXT:    br label [[PRED_LOAD_CONTINUE17]]
; CHECK:       pred.load.continue17:
; CHECK-NEXT:    [[TMP11:%.*]] = phi i32 [ poison, [[PRED_LOAD_CONTINUE]] ], [ [[TMP10]], [[PRED_LOAD_IF16]] ]
; CHECK-NEXT:    [[TMP12:%.*]] = extractelement <4 x i1> [[TMP4]], i32 2
; CHECK-NEXT:    br i1 [[TMP12]], label [[PRED_LOAD_IF18:%.*]], label [[PRED_LOAD_CONTINUE19:%.*]]
; CHECK:       pred.load.if18:
; CHECK-NEXT:    [[TMP13:%.*]] = or i64 [[INDEX]], 2
; CHECK-NEXT:    [[NEXT_GEP12:%.*]] = getelementptr i32, i32* [[Q]], i64 [[TMP13]]
; CHECK-NEXT:    [[TMP14:%.*]] = load i32, i32* [[NEXT_GEP12]], align 16
; CHECK-NEXT:    br label [[PRED_LOAD_CONTINUE19]]
; CHECK:       pred.load.continue19:
; CHECK-NEXT:    [[TMP15:%.*]] = phi i32 [ poison, [[PRED_LOAD_CONTINUE17]] ], [ [[TMP14]], [[PRED_LOAD_IF18]] ]
; CHECK-NEXT:    [[TMP16:%.*]] = extractelement <4 x i1> [[TMP4]], i32 3
; CHECK-NEXT:    br i1 [[TMP16]], label [[PRED_LOAD_IF20:%.*]], label [[PRED_LOAD_CONTINUE21:%.*]]
; CHECK:       pred.load.if20:
; CHECK-NEXT:    [[TMP17:%.*]] = or i64 [[INDEX]], 3
; CHECK-NEXT:    [[NEXT_GEP13:%.*]] = getelementptr i32, i32* [[Q]], i64 [[TMP17]]
; CHECK-NEXT:    [[TMP18:%.*]] = load i32, i32* [[NEXT_GEP13]], align 16
; CHECK-NEXT:    br label [[PRED_LOAD_CONTINUE21]]
; CHECK:       pred.load.continue21:
; CHECK-NEXT:    [[TMP19:%.*]] = phi i32 [ poison, [[PRED_LOAD_CONTINUE19]] ], [ [[TMP18]], [[PRED_LOAD_IF20]] ]
; CHECK-NEXT:    [[TMP20:%.*]] = extractelement <4 x i1> [[TMP4]], i32 0
; CHECK-NEXT:    br i1 [[TMP20]], label [[PRED_STORE_IF:%.*]], label [[PRED_STORE_CONTINUE:%.*]]
; CHECK:       pred.store.if:
; CHECK-NEXT:    [[NEXT_GEP:%.*]] = getelementptr i32, i32* [[P:%.*]], i64 [[INDEX]]
; CHECK-NEXT:    store i32 [[TMP7]], i32* [[NEXT_GEP]], align 16
; CHECK-NEXT:    br label [[PRED_STORE_CONTINUE]]
; CHECK:       pred.store.continue:
; CHECK-NEXT:    [[TMP21:%.*]] = extractelement <4 x i1> [[TMP4]], i32 1
; CHECK-NEXT:    br i1 [[TMP21]], label [[PRED_STORE_IF22:%.*]], label [[PRED_STORE_CONTINUE23:%.*]]
; CHECK:       pred.store.if22:
; CHECK-NEXT:    [[TMP22:%.*]] = or i64 [[INDEX]], 1
; CHECK-NEXT:    [[NEXT_GEP7:%.*]] = getelementptr i32, i32* [[P]], i64 [[TMP22]]
; CHECK-NEXT:    store i32 [[TMP11]], i32* [[NEXT_GEP7]], align 16
; CHECK-NEXT:    br label [[PRED_STORE_CONTINUE23]]
; CHECK:       pred.store.continue23:
; CHECK-NEXT:    [[TMP23:%.*]] = extractelement <4 x i1> [[TMP4]], i32 2
; CHECK-NEXT:    br i1 [[TMP23]], label [[PRED_STORE_IF24:%.*]], label [[PRED_STORE_CONTINUE25:%.*]]
; CHECK:       pred.store.if24:
; CHECK-NEXT:    [[TMP24:%.*]] = or i64 [[INDEX]], 2
; CHECK-NEXT:    [[NEXT_GEP8:%.*]] = getelementptr i32, i32* [[P]], i64 [[TMP24]]
; CHECK-NEXT:    store i32 [[TMP15]], i32* [[NEXT_GEP8]], align 16
; CHECK-NEXT:    br label [[PRED_STORE_CONTINUE25]]
; CHECK:       pred.store.continue25:
; CHECK-NEXT:    [[TMP25:%.*]] = extractelement <4 x i1> [[TMP4]], i32 3
; CHECK-NEXT:    br i1 [[TMP25]], label [[PRED_STORE_IF26:%.*]], label [[PRED_STORE_CONTINUE27]]
; CHECK:       pred.store.if26:
; CHECK-NEXT:    [[TMP26:%.*]] = or i64 [[INDEX]], 3
; CHECK-NEXT:    [[NEXT_GEP9:%.*]] = getelementptr i32, i32* [[P]], i64 [[TMP26]]
; CHECK-NEXT:    store i32 [[TMP19]], i32* [[NEXT_GEP9]], align 16
; CHECK-NEXT:    br label [[PRED_STORE_CONTINUE27]]
; CHECK:       pred.store.continue27:
; CHECK-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 4
; CHECK-NEXT:    [[TMP27:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP27]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], [[LOOP8:!llvm.loop !.*]]
; CHECK:       middle.block:
; CHECK-NEXT:    br i1 true, label [[DOT_CRIT_EDGE_LOOPEXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    br label [[DOTLR_PH:%.*]]
; CHECK:       .lr.ph:
; CHECK-NEXT:    br i1 undef, label [[DOT_CRIT_EDGE_LOOPEXIT]], label [[DOTLR_PH]], [[LOOP9:!llvm.loop !.*]]
; CHECK:       ._crit_edge.loopexit:
; CHECK-NEXT:    br label [[DOT_CRIT_EDGE]]
; CHECK:       ._crit_edge:
; CHECK-NEXT:    ret void
;
  %1 = icmp eq i32 %n, 0
  br i1 %1, label %._crit_edge, label %.lr.ph

.lr.ph:                                           ; preds = %0, %.lr.ph
  %.05 = phi i32 [ %2, %.lr.ph ], [ %n, %0 ]
  %.014 = phi i32* [ %5, %.lr.ph ], [ %p, %0 ]
  %.023 = phi i32* [ %3, %.lr.ph ], [ %q, %0 ]
  %2 = add nsw i32 %.05, -1
  %3 = getelementptr inbounds i32, i32* %.023, i64 1
  %4 = load i32, i32* %.023, align 16
  %5 = getelementptr inbounds i32, i32* %.014, i64 1
  store i32 %4, i32* %.014, align 16
  %6 = icmp eq i32 %2, 0
  br i1 %6, label %._crit_edge, label %.lr.ph

._crit_edge:                                      ; preds = %.lr.ph, %0
  ret void
}

; We can't vectorize this one because we need a runtime ptr check.
define void @example23(i16* nocapture %src, i32* nocapture %dst) optsize {
; CHECK-LABEL: @example23(
; CHECK-NEXT:    br label [[TMP1:%.*]]
; CHECK:       1:
; CHECK-NEXT:    [[DOT04:%.*]] = phi i16* [ [[SRC:%.*]], [[TMP0:%.*]] ], [ [[TMP2:%.*]], [[TMP1]] ]
; CHECK-NEXT:    [[DOT013:%.*]] = phi i32* [ [[DST:%.*]], [[TMP0]] ], [ [[TMP6:%.*]], [[TMP1]] ]
; CHECK-NEXT:    [[I_02:%.*]] = phi i32 [ 0, [[TMP0]] ], [ [[TMP7:%.*]], [[TMP1]] ]
; CHECK-NEXT:    [[TMP2]] = getelementptr inbounds i16, i16* [[DOT04]], i64 1
; CHECK-NEXT:    [[TMP3:%.*]] = load i16, i16* [[DOT04]], align 2
; CHECK-NEXT:    [[TMP4:%.*]] = zext i16 [[TMP3]] to i32
; CHECK-NEXT:    [[TMP5:%.*]] = shl nuw nsw i32 [[TMP4]], 7
; CHECK-NEXT:    [[TMP6]] = getelementptr inbounds i32, i32* [[DOT013]], i64 1
; CHECK-NEXT:    store i32 [[TMP5]], i32* [[DOT013]], align 4
; CHECK-NEXT:    [[TMP7]] = add nuw nsw i32 [[I_02]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i32 [[TMP7]], 256
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[TMP8:%.*]], label [[TMP1]]
; CHECK:       8:
; CHECK-NEXT:    ret void
;
  br label %1

; <label>:1                                       ; preds = %1, %0
  %.04 = phi i16* [ %src, %0 ], [ %2, %1 ]
  %.013 = phi i32* [ %dst, %0 ], [ %6, %1 ]
  %i.02 = phi i32 [ 0, %0 ], [ %7, %1 ]
  %2 = getelementptr inbounds i16, i16* %.04, i64 1
  %3 = load i16, i16* %.04, align 2
  %4 = zext i16 %3 to i32
  %5 = shl nuw nsw i32 %4, 7
  %6 = getelementptr inbounds i32, i32* %.013, i64 1
  store i32 %5, i32* %.013, align 4
  %7 = add nsw i32 %i.02, 1
  %exitcond = icmp eq i32 %7, 256
  br i1 %exitcond, label %8, label %1

; <label>:8                                       ; preds = %1
  ret void
}


; We CAN vectorize this example because the pointers are marked as noalias.
define void @example23b(i16* noalias nocapture %src, i32* noalias nocapture %dst) optsize {
; CHECK-LABEL: @example23b(
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[NEXT_GEP:%.*]] = getelementptr i16, i16* [[SRC:%.*]], i64 [[INDEX]]
; CHECK-NEXT:    [[NEXT_GEP4:%.*]] = getelementptr i32, i32* [[DST:%.*]], i64 [[INDEX]]
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i16* [[NEXT_GEP]] to <4 x i16>*
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <4 x i16>, <4 x i16>* [[TMP1]], align 2
; CHECK-NEXT:    [[TMP2:%.*]] = zext <4 x i16> [[WIDE_LOAD]] to <4 x i32>
; CHECK-NEXT:    [[TMP3:%.*]] = shl nuw nsw <4 x i32> [[TMP2]], <i32 7, i32 7, i32 7, i32 7>
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast i32* [[NEXT_GEP4]] to <4 x i32>*
; CHECK-NEXT:    store <4 x i32> [[TMP3]], <4 x i32>* [[TMP4]], align 4
; CHECK-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 4
; CHECK-NEXT:    [[TMP5:%.*]] = icmp eq i64 [[INDEX_NEXT]], 256
; CHECK-NEXT:    br i1 [[TMP5]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], [[LOOP10:!llvm.loop !.*]]
; CHECK:       middle.block:
; CHECK-NEXT:    br i1 true, label [[TMP7:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    br label [[TMP6:%.*]]
; CHECK:       6:
; CHECK-NEXT:    br i1 undef, label [[TMP7]], label [[TMP6]], [[LOOP11:!llvm.loop !.*]]
; CHECK:       7:
; CHECK-NEXT:    ret void
;
  br label %1

; <label>:1                                       ; preds = %1, %0
  %.04 = phi i16* [ %src, %0 ], [ %2, %1 ]
  %.013 = phi i32* [ %dst, %0 ], [ %6, %1 ]
  %i.02 = phi i32 [ 0, %0 ], [ %7, %1 ]
  %2 = getelementptr inbounds i16, i16* %.04, i64 1
  %3 = load i16, i16* %.04, align 2
  %4 = zext i16 %3 to i32
  %5 = shl nuw nsw i32 %4, 7
  %6 = getelementptr inbounds i32, i32* %.013, i64 1
  store i32 %5, i32* %.013, align 4
  %7 = add nsw i32 %i.02, 1
  %exitcond = icmp eq i32 %7, 256
  br i1 %exitcond, label %8, label %1

; <label>:8                                       ; preds = %1
  ret void
}

; We CAN vectorize this example by folding the tail it entails.
define void @example23c(i16* noalias nocapture %src, i32* noalias nocapture %dst) optsize {
; CHECK-LABEL: @example23c(
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[PRED_STORE_CONTINUE22:%.*]] ]
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <4 x i64> poison, i64 [[INDEX]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <4 x i64> [[BROADCAST_SPLATINSERT]], <4 x i64> poison, <4 x i32> zeroinitializer
; CHECK-NEXT:    [[INDUCTION:%.*]] = or <4 x i64> [[BROADCAST_SPLAT]], <i64 0, i64 1, i64 2, i64 3>
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ult <4 x i64> [[INDUCTION]], <i64 257, i64 257, i64 257, i64 257>
; CHECK-NEXT:    [[TMP2:%.*]] = extractelement <4 x i1> [[TMP1]], i32 0
; CHECK-NEXT:    br i1 [[TMP2]], label [[PRED_LOAD_IF:%.*]], label [[PRED_LOAD_CONTINUE:%.*]]
; CHECK:       pred.load.if:
; CHECK-NEXT:    [[NEXT_GEP:%.*]] = getelementptr i16, i16* [[SRC:%.*]], i64 [[INDEX]]
; CHECK-NEXT:    [[TMP3:%.*]] = load i16, i16* [[NEXT_GEP]], align 2
; CHECK-NEXT:    br label [[PRED_LOAD_CONTINUE]]
; CHECK:       pred.load.continue:
; CHECK-NEXT:    [[TMP4:%.*]] = phi i16 [ poison, [[VECTOR_BODY]] ], [ [[TMP3]], [[PRED_LOAD_IF]] ]
; CHECK-NEXT:    [[TMP5:%.*]] = extractelement <4 x i1> [[TMP1]], i32 1
; CHECK-NEXT:    br i1 [[TMP5]], label [[PRED_LOAD_IF11:%.*]], label [[PRED_LOAD_CONTINUE12:%.*]]
; CHECK:       pred.load.if11:
; CHECK-NEXT:    [[TMP6:%.*]] = or i64 [[INDEX]], 1
; CHECK-NEXT:    [[NEXT_GEP4:%.*]] = getelementptr i16, i16* [[SRC]], i64 [[TMP6]]
; CHECK-NEXT:    [[TMP7:%.*]] = load i16, i16* [[NEXT_GEP4]], align 2
; CHECK-NEXT:    br label [[PRED_LOAD_CONTINUE12]]
; CHECK:       pred.load.continue12:
; CHECK-NEXT:    [[TMP8:%.*]] = phi i16 [ poison, [[PRED_LOAD_CONTINUE]] ], [ [[TMP7]], [[PRED_LOAD_IF11]] ]
; CHECK-NEXT:    [[TMP9:%.*]] = extractelement <4 x i1> [[TMP1]], i32 2
; CHECK-NEXT:    br i1 [[TMP9]], label [[PRED_LOAD_IF13:%.*]], label [[PRED_LOAD_CONTINUE14:%.*]]
; CHECK:       pred.load.if13:
; CHECK-NEXT:    [[TMP10:%.*]] = or i64 [[INDEX]], 2
; CHECK-NEXT:    [[NEXT_GEP5:%.*]] = getelementptr i16, i16* [[SRC]], i64 [[TMP10]]
; CHECK-NEXT:    [[TMP11:%.*]] = load i16, i16* [[NEXT_GEP5]], align 2
; CHECK-NEXT:    br label [[PRED_LOAD_CONTINUE14]]
; CHECK:       pred.load.continue14:
; CHECK-NEXT:    [[TMP12:%.*]] = phi i16 [ poison, [[PRED_LOAD_CONTINUE12]] ], [ [[TMP11]], [[PRED_LOAD_IF13]] ]
; CHECK-NEXT:    [[TMP13:%.*]] = extractelement <4 x i1> [[TMP1]], i32 3
; CHECK-NEXT:    br i1 [[TMP13]], label [[PRED_LOAD_IF15:%.*]], label [[PRED_LOAD_CONTINUE16:%.*]]
; CHECK:       pred.load.if15:
; CHECK-NEXT:    [[TMP14:%.*]] = or i64 [[INDEX]], 3
; CHECK-NEXT:    [[NEXT_GEP6:%.*]] = getelementptr i16, i16* [[SRC]], i64 [[TMP14]]
; CHECK-NEXT:    [[TMP15:%.*]] = load i16, i16* [[NEXT_GEP6]], align 2
; CHECK-NEXT:    br label [[PRED_LOAD_CONTINUE16]]
; CHECK:       pred.load.continue16:
; CHECK-NEXT:    [[TMP16:%.*]] = phi i16 [ poison, [[PRED_LOAD_CONTINUE14]] ], [ [[TMP15]], [[PRED_LOAD_IF15]] ]
; CHECK-NEXT:    [[TMP17:%.*]] = extractelement <4 x i1> [[TMP1]], i32 0
; CHECK-NEXT:    br i1 [[TMP17]], label [[PRED_STORE_IF:%.*]], label [[PRED_STORE_CONTINUE:%.*]]
; CHECK:       pred.store.if:
; CHECK-NEXT:    [[TMP18:%.*]] = zext i16 [[TMP4]] to i32
; CHECK-NEXT:    [[TMP19:%.*]] = shl nuw nsw i32 [[TMP18]], 7
; CHECK-NEXT:    [[NEXT_GEP7:%.*]] = getelementptr i32, i32* [[DST:%.*]], i64 [[INDEX]]
; CHECK-NEXT:    store i32 [[TMP19]], i32* [[NEXT_GEP7]], align 4
; CHECK-NEXT:    br label [[PRED_STORE_CONTINUE]]
; CHECK:       pred.store.continue:
; CHECK-NEXT:    [[TMP20:%.*]] = extractelement <4 x i1> [[TMP1]], i32 1
; CHECK-NEXT:    br i1 [[TMP20]], label [[PRED_STORE_IF17:%.*]], label [[PRED_STORE_CONTINUE18:%.*]]
; CHECK:       pred.store.if17:
; CHECK-NEXT:    [[TMP21:%.*]] = zext i16 [[TMP8]] to i32
; CHECK-NEXT:    [[TMP22:%.*]] = shl nuw nsw i32 [[TMP21]], 7
; CHECK-NEXT:    [[TMP23:%.*]] = or i64 [[INDEX]], 1
; CHECK-NEXT:    [[NEXT_GEP8:%.*]] = getelementptr i32, i32* [[DST]], i64 [[TMP23]]
; CHECK-NEXT:    store i32 [[TMP22]], i32* [[NEXT_GEP8]], align 4
; CHECK-NEXT:    br label [[PRED_STORE_CONTINUE18]]
; CHECK:       pred.store.continue18:
; CHECK-NEXT:    [[TMP24:%.*]] = extractelement <4 x i1> [[TMP1]], i32 2
; CHECK-NEXT:    br i1 [[TMP24]], label [[PRED_STORE_IF19:%.*]], label [[PRED_STORE_CONTINUE20:%.*]]
; CHECK:       pred.store.if19:
; CHECK-NEXT:    [[TMP25:%.*]] = zext i16 [[TMP12]] to i32
; CHECK-NEXT:    [[TMP26:%.*]] = shl nuw nsw i32 [[TMP25]], 7
; CHECK-NEXT:    [[TMP27:%.*]] = or i64 [[INDEX]], 2
; CHECK-NEXT:    [[NEXT_GEP9:%.*]] = getelementptr i32, i32* [[DST]], i64 [[TMP27]]
; CHECK-NEXT:    store i32 [[TMP26]], i32* [[NEXT_GEP9]], align 4
; CHECK-NEXT:    br label [[PRED_STORE_CONTINUE20]]
; CHECK:       pred.store.continue20:
; CHECK-NEXT:    [[TMP28:%.*]] = extractelement <4 x i1> [[TMP1]], i32 3
; CHECK-NEXT:    br i1 [[TMP28]], label [[PRED_STORE_IF21:%.*]], label [[PRED_STORE_CONTINUE22]]
; CHECK:       pred.store.if21:
; CHECK-NEXT:    [[TMP29:%.*]] = zext i16 [[TMP16]] to i32
; CHECK-NEXT:    [[TMP30:%.*]] = shl nuw nsw i32 [[TMP29]], 7
; CHECK-NEXT:    [[TMP31:%.*]] = or i64 [[INDEX]], 3
; CHECK-NEXT:    [[NEXT_GEP10:%.*]] = getelementptr i32, i32* [[DST]], i64 [[TMP31]]
; CHECK-NEXT:    store i32 [[TMP30]], i32* [[NEXT_GEP10]], align 4
; CHECK-NEXT:    br label [[PRED_STORE_CONTINUE22]]
; CHECK:       pred.store.continue22:
; CHECK-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 4
; CHECK-NEXT:    [[TMP32:%.*]] = icmp eq i64 [[INDEX_NEXT]], 260
; CHECK-NEXT:    br i1 [[TMP32]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], [[LOOP12:!llvm.loop !.*]]
; CHECK:       middle.block:
; CHECK-NEXT:    br i1 true, label [[TMP34:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    br label [[TMP33:%.*]]
; CHECK:       33:
; CHECK-NEXT:    br i1 undef, label [[TMP34]], label [[TMP33]], [[LOOP13:!llvm.loop !.*]]
; CHECK:       34:
; CHECK-NEXT:    ret void
;
  br label %1

; <label>:1                                       ; preds = %1, %0
  %.04 = phi i16* [ %src, %0 ], [ %2, %1 ]
  %.013 = phi i32* [ %dst, %0 ], [ %6, %1 ]
  %i.02 = phi i64 [ 0, %0 ], [ %7, %1 ]
  %2 = getelementptr inbounds i16, i16* %.04, i64 1
  %3 = load i16, i16* %.04, align 2
  %4 = zext i16 %3 to i32
  %5 = shl nuw nsw i32 %4, 7
  %6 = getelementptr inbounds i32, i32* %.013, i64 1
  store i32 %5, i32* %.013, align 4
  %7 = add nsw i64 %i.02, 1
  %exitcond = icmp eq i64 %7, 257
  br i1 %exitcond, label %8, label %1

; <label>:8                                       ; preds = %1
  ret void
}

; We CAN'T vectorize this example because it would entail a tail and an
; induction is used outside the loop.
define i64 @example23d(i16* noalias nocapture %src, i32* noalias nocapture %dst) optsize {
; CHECK-LABEL: @example23d(
; CHECK-NEXT:    br label [[TMP1:%.*]]
; CHECK:       1:
; CHECK-NEXT:    [[DOT04:%.*]] = phi i16* [ [[SRC:%.*]], [[TMP0:%.*]] ], [ [[TMP2:%.*]], [[TMP1]] ]
; CHECK-NEXT:    [[DOT013:%.*]] = phi i32* [ [[DST:%.*]], [[TMP0]] ], [ [[TMP6:%.*]], [[TMP1]] ]
; CHECK-NEXT:    [[I_02:%.*]] = phi i64 [ 0, [[TMP0]] ], [ [[TMP7:%.*]], [[TMP1]] ]
; CHECK-NEXT:    [[TMP2]] = getelementptr inbounds i16, i16* [[DOT04]], i64 1
; CHECK-NEXT:    [[TMP3:%.*]] = load i16, i16* [[DOT04]], align 2
; CHECK-NEXT:    [[TMP4:%.*]] = zext i16 [[TMP3]] to i32
; CHECK-NEXT:    [[TMP5:%.*]] = shl nuw nsw i32 [[TMP4]], 7
; CHECK-NEXT:    [[TMP6]] = getelementptr inbounds i32, i32* [[DOT013]], i64 1
; CHECK-NEXT:    store i32 [[TMP5]], i32* [[DOT013]], align 4
; CHECK-NEXT:    [[TMP7]] = add nuw nsw i64 [[I_02]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[TMP7]], 257
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[TMP8:%.*]], label [[TMP1]]
; CHECK:       8:
; CHECK-NEXT:    ret i64 [[TMP7]]
;
  br label %1

; <label>:1                                       ; preds = %1, %0
  %.04 = phi i16* [ %src, %0 ], [ %2, %1 ]
  %.013 = phi i32* [ %dst, %0 ], [ %6, %1 ]
  %i.02 = phi i64 [ 0, %0 ], [ %7, %1 ]
  %2 = getelementptr inbounds i16, i16* %.04, i64 1
  %3 = load i16, i16* %.04, align 2
  %4 = zext i16 %3 to i32
  %5 = shl nuw nsw i32 %4, 7
  %6 = getelementptr inbounds i32, i32* %.013, i64 1
  store i32 %5, i32* %.013, align 4
  %7 = add nsw i64 %i.02, 1
  %exitcond = icmp eq i64 %7, 257
  br i1 %exitcond, label %8, label %1

; <label>:8                                       ; preds = %1
  ret i64 %7
}
