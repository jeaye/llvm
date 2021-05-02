; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -loop-simplify -loop-rotate -instcombine -indvars -S -verify-loop-info -verify-dom-info | FileCheck %s

; Loopsimplify should be able to merge the two loop exits
; into one, so that loop rotate can rotate the loop, so
; that indvars can promote the induction variable to i64
; without needing casts.

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n32:64"

define float @test1(float* %pTmp1, float* %peakWeight, i32 %bandEdgeIndex) nounwind {
; CHECK-LABEL: @test1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[T0:%.*]] = load float, float* [[PEAKWEIGHT:%.*]], align 4
; CHECK-NEXT:    [[T11:%.*]] = add i32 [[BANDEDGEINDEX:%.*]], -1
; CHECK-NEXT:    [[T121:%.*]] = icmp sgt i32 [[T11]], 0
; CHECK-NEXT:    br i1 [[T121]], label [[BB_LR_PH:%.*]], label [[BB3:%.*]]
; CHECK:       bb.lr.ph:
; CHECK-NEXT:    [[TMP0:%.*]] = sext i32 [[T11]] to i64
; CHECK-NEXT:    br label [[BB:%.*]]
; CHECK:       bb:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ 0, [[BB_LR_PH]] ], [ [[INDVARS_IV_NEXT:%.*]], [[BB]] ]
; CHECK-NEXT:    [[DISTERBHI_04:%.*]] = phi float [ 0.000000e+00, [[BB_LR_PH]] ], [ [[T4:%.*]], [[BB]] ]
; CHECK-NEXT:    [[PEAKCOUNT_02:%.*]] = phi float [ [[T0]], [[BB_LR_PH]] ], [ [[T9:%.*]], [[BB]] ]
; CHECK-NEXT:    [[T2:%.*]] = getelementptr float, float* [[PTMP1:%.*]], i64 [[INDVARS_IV]]
; CHECK-NEXT:    [[T3:%.*]] = load float, float* [[T2]], align 4
; CHECK-NEXT:    [[T4]] = fadd float [[T3]], [[DISTERBHI_04]]
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[T7:%.*]] = getelementptr float, float* [[PEAKWEIGHT]], i64 [[INDVARS_IV_NEXT]]
; CHECK-NEXT:    [[T8:%.*]] = load float, float* [[T7]], align 4
; CHECK-NEXT:    [[T9]] = fadd float [[T8]], [[PEAKCOUNT_02]]
; CHECK-NEXT:    [[T10:%.*]] = fcmp olt float [[T4]], 2.500000e+00
; CHECK-NEXT:    [[T12:%.*]] = icmp sgt i64 [[TMP0]], [[INDVARS_IV_NEXT]]
; CHECK-NEXT:    [[OR_COND:%.*]] = select i1 [[T10]], i1 [[T12]], i1 false
; CHECK-NEXT:    br i1 [[OR_COND]], label [[BB]], label [[BB1_BB3_CRIT_EDGE:%.*]]
; CHECK:       bb1.bb3_crit_edge:
; CHECK-NEXT:    [[T4_LCSSA:%.*]] = phi float [ [[T4]], [[BB]] ]
; CHECK-NEXT:    [[T9_LCSSA:%.*]] = phi float [ [[T9]], [[BB]] ]
; CHECK-NEXT:    br label [[BB3]]
; CHECK:       bb3:
; CHECK-NEXT:    [[PEAKCOUNT_0_LCSSA:%.*]] = phi float [ [[T9_LCSSA]], [[BB1_BB3_CRIT_EDGE]] ], [ [[T0]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[DISTERBHI_0_LCSSA:%.*]] = phi float [ [[T4_LCSSA]], [[BB1_BB3_CRIT_EDGE]] ], [ 0.000000e+00, [[ENTRY]] ]
; CHECK-NEXT:    [[T13:%.*]] = fdiv float [[PEAKCOUNT_0_LCSSA]], [[DISTERBHI_0_LCSSA]]
; CHECK-NEXT:    ret float [[T13]]
;
entry:
  %t0 = load float, float* %peakWeight, align 4
  br label %bb1

bb:		; preds = %bb2
  %t1 = sext i32 %hiPart.0 to i64
  %t2 = getelementptr float, float* %pTmp1, i64 %t1
  %t3 = load float, float* %t2, align 4
  %t4 = fadd float %t3, %distERBhi.0
  %t5 = add i32 %hiPart.0, 1
  %t6 = sext i32 %t5 to i64
  %t7 = getelementptr float, float* %peakWeight, i64 %t6
  %t8 = load float, float* %t7, align 4
  %t9 = fadd float %t8, %peakCount.0
  br label %bb1

bb1:		; preds = %bb, %entry
  %peakCount.0 = phi float [ %t0, %entry ], [ %t9, %bb ]
  %hiPart.0 = phi i32 [ 0, %entry ], [ %t5, %bb ]
  %distERBhi.0 = phi float [ 0.000000e+00, %entry ], [ %t4, %bb ]
  %t10 = fcmp uge float %distERBhi.0, 2.500000e+00
  br i1 %t10, label %bb3, label %bb2

bb2:		; preds = %bb1
  %t11 = add i32 %bandEdgeIndex, -1
  %t12 = icmp sgt i32 %t11, %hiPart.0
  br i1 %t12, label %bb, label %bb3

bb3:		; preds = %bb2, %bb1
  %t13 = fdiv float %peakCount.0, %distERBhi.0
  ret float %t13
}

; Same test as above.
; This would crash because we assumed TTI was available to process the metadata.

define float @merge_branches_profile_metadata(float* %pTmp1, float* %peakWeight, i32 %bandEdgeIndex) nounwind {
; CHECK-LABEL: @merge_branches_profile_metadata(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[T0:%.*]] = load float, float* [[PEAKWEIGHT:%.*]], align 4
; CHECK-NEXT:    [[T11:%.*]] = add i32 [[BANDEDGEINDEX:%.*]], -1
; CHECK-NEXT:    [[T121:%.*]] = icmp sgt i32 [[T11]], 0
; CHECK-NEXT:    br i1 [[T121]], label [[BB_LR_PH:%.*]], label [[BB3:%.*]], !prof !0
; CHECK:       bb.lr.ph:
; CHECK-NEXT:    [[TMP0:%.*]] = sext i32 [[T11]] to i64
; CHECK-NEXT:    br label [[BB:%.*]]
; CHECK:       bb:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ 0, [[BB_LR_PH]] ], [ [[INDVARS_IV_NEXT:%.*]], [[BB]] ]
; CHECK-NEXT:    [[DISTERBHI_04:%.*]] = phi float [ 0.000000e+00, [[BB_LR_PH]] ], [ [[T4:%.*]], [[BB]] ]
; CHECK-NEXT:    [[PEAKCOUNT_02:%.*]] = phi float [ [[T0]], [[BB_LR_PH]] ], [ [[T9:%.*]], [[BB]] ]
; CHECK-NEXT:    [[T2:%.*]] = getelementptr float, float* [[PTMP1:%.*]], i64 [[INDVARS_IV]]
; CHECK-NEXT:    [[T3:%.*]] = load float, float* [[T2]], align 4
; CHECK-NEXT:    [[T4]] = fadd float [[T3]], [[DISTERBHI_04]]
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[T7:%.*]] = getelementptr float, float* [[PEAKWEIGHT]], i64 [[INDVARS_IV_NEXT]]
; CHECK-NEXT:    [[T8:%.*]] = load float, float* [[T7]], align 4
; CHECK-NEXT:    [[T9]] = fadd float [[T8]], [[PEAKCOUNT_02]]
; CHECK-NEXT:    [[T10:%.*]] = fcmp olt float [[T4]], 2.500000e+00
; CHECK-NEXT:    [[T12:%.*]] = icmp sgt i64 [[TMP0]], [[INDVARS_IV_NEXT]]
; CHECK-NEXT:    [[OR_COND:%.*]] = select i1 [[T10]], i1 [[T12]], i1 false
; CHECK-NEXT:    br i1 [[OR_COND]], label [[BB]], label [[BB1_BB3_CRIT_EDGE:%.*]], !prof !0
; CHECK:       bb1.bb3_crit_edge:
; CHECK-NEXT:    [[T4_LCSSA:%.*]] = phi float [ [[T4]], [[BB]] ]
; CHECK-NEXT:    [[T9_LCSSA:%.*]] = phi float [ [[T9]], [[BB]] ]
; CHECK-NEXT:    br label [[BB3]]
; CHECK:       bb3:
; CHECK-NEXT:    [[PEAKCOUNT_0_LCSSA:%.*]] = phi float [ [[T9_LCSSA]], [[BB1_BB3_CRIT_EDGE]] ], [ [[T0]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[DISTERBHI_0_LCSSA:%.*]] = phi float [ [[T4_LCSSA]], [[BB1_BB3_CRIT_EDGE]] ], [ 0.000000e+00, [[ENTRY]] ]
; CHECK-NEXT:    [[T13:%.*]] = fdiv float [[PEAKCOUNT_0_LCSSA]], [[DISTERBHI_0_LCSSA]]
; CHECK-NEXT:    ret float [[T13]]
;
entry:
  %t0 = load float, float* %peakWeight, align 4
  br label %bb1

bb:		; preds = %bb2
  %t1 = sext i32 %hiPart.0 to i64
  %t2 = getelementptr float, float* %pTmp1, i64 %t1
  %t3 = load float, float* %t2, align 4
  %t4 = fadd float %t3, %distERBhi.0
  %t5 = add i32 %hiPart.0, 1
  %t6 = sext i32 %t5 to i64
  %t7 = getelementptr float, float* %peakWeight, i64 %t6
  %t8 = load float, float* %t7, align 4
  %t9 = fadd float %t8, %peakCount.0
  br label %bb1

bb1:		; preds = %bb, %entry
  %peakCount.0 = phi float [ %t0, %entry ], [ %t9, %bb ]
  %hiPart.0 = phi i32 [ 0, %entry ], [ %t5, %bb ]
  %distERBhi.0 = phi float [ 0.000000e+00, %entry ], [ %t4, %bb ]
  %t10 = fcmp uge float %distERBhi.0, 2.500000e+00
  br i1 %t10, label %bb3, label %bb2, !prof !0

bb2:		; preds = %bb1
  %t11 = add i32 %bandEdgeIndex, -1
  %t12 = icmp sgt i32 %t11, %hiPart.0
  br i1 %t12, label %bb, label %bb3

bb3:		; preds = %bb2, %bb1
  %t13 = fdiv float %peakCount.0, %distERBhi.0
  ret float %t13
}

!0 = !{!"branch_weights", i32 2000, i32 1}
