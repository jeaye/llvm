; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -O3 -S | FileCheck %s

target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx11.0.0"

; We expect the loop to be vectorized even if it
; is not unrolled.
; Verify that fdiv is not sunk back into the loop
; after getting hoisted - based on this C source:
;
;  void vdiv(float *a, float b) {
;      for (int i = 0; i != 1024; ++i)
;        a[i] /= b;
;  }

define void @vdiv(float* %a, float %b) #0 {
; CHECK-LABEL: @vdiv(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <4 x float> poison, float [[B:%.*]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <4 x float> [[BROADCAST_SPLATINSERT]], <4 x float> poison, <4 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP0:%.*]] = fdiv fast <4 x float> <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>, [[BROADCAST_SPLAT]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds float, float* [[A:%.*]], i64 [[INDEX]]
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast float* [[TMP1]] to <4 x float>*
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <4 x float>, <4 x float>* [[TMP2]], align 4, !tbaa [[TBAA3:![0-9]+]]
; CHECK-NEXT:    [[TMP3:%.*]] = fmul fast <4 x float> [[WIDE_LOAD]], [[TMP0]]
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast float* [[TMP1]] to <4 x float>*
; CHECK-NEXT:    store <4 x float> [[TMP3]], <4 x float>* [[TMP4]], align 4, !tbaa [[TBAA3]]
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 4
; CHECK-NEXT:    [[TMP5:%.*]] = icmp eq i64 [[INDEX_NEXT]], 1024
; CHECK-NEXT:    br i1 [[TMP5]], label [[FOR_COND_CLEANUP:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP7:![0-9]+]]
; CHECK:       for.cond.cleanup:
; CHECK-NEXT:    ret void
;
entry:
  %a.addr = alloca float*, align 8
  %b.addr = alloca float, align 4
  %i = alloca i32, align 4
  store float* %a, float** %a.addr, align 8, !tbaa !3
  store float %b, float* %b.addr, align 4, !tbaa !7
  %0 = bitcast i32* %i to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %0) #2
  store i32 0, i32* %i, align 4, !tbaa !9
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %1 = load i32, i32* %i, align 4, !tbaa !9
  %cmp = icmp ne i32 %1, 1024
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  %2 = bitcast i32* %i to i8*
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %2) #2
  br label %for.end

for.body:                                         ; preds = %for.cond
  %3 = load float, float* %b.addr, align 4, !tbaa !7
  %4 = load float*, float** %a.addr, align 8, !tbaa !3
  %5 = load i32, i32* %i, align 4, !tbaa !9
  %idxprom = sext i32 %5 to i64
  %arrayidx = getelementptr inbounds float, float* %4, i64 %idxprom
  %6 = load float, float* %arrayidx, align 4, !tbaa !7
  %div = fdiv fast float %6, %3
  store float %div, float* %arrayidx, align 4, !tbaa !7
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %7 = load i32, i32* %i, align 4, !tbaa !9
  %inc = add nsw i32 %7, 1
  store i32 %inc, i32* %i, align 4, !tbaa !9
  br label %for.cond, !llvm.loop !11

for.end:                                          ; preds = %for.cond.cleanup
  ret void
}

declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

attributes #0 = { nounwind ssp uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-infs-fp-math"="true" "no-nans-fp-math"="true" "no-signed-zeros-fp-math"="true" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "tune-cpu"="generic" "unsafe-fp-math"="true" }
attributes #1 = { argmemonly nofree nosync nounwind willreturn }
attributes #2 = { nounwind }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{!"clang version 13.0.0 (https://github.com/llvm/llvm-project.git 437fb428178716db014f75701f3cdea6dea63f59)"}
!3 = !{!4, !4, i64 0}
!4 = !{!"any pointer", !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C/C++ TBAA"}
!7 = !{!8, !8, i64 0}
!8 = !{!"float", !5, i64 0}
!9 = !{!10, !10, i64 0}
!10 = !{!"int", !5, i64 0}
!11 = distinct !{!11, !12, !13}
!12 = !{!"llvm.loop.mustprogress"}
!13 = !{!"llvm.loop.unroll.disable"}
