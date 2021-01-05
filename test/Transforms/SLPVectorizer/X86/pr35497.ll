; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -mtriple=x86_64-unknown-linux-gnu -slp-vectorizer -slp-vectorizer -mattr=+sse2 -S | FileCheck %s --check-prefix=SSE
; RUN: opt < %s -mtriple=x86_64-unknown-linux-gnu -slp-vectorizer -slp-vectorizer -mattr=+avx  -S | FileCheck %s --check-prefix=AVX
; RUN: opt < %s -mtriple=x86_64-unknown-linux-gnu -slp-vectorizer -slp-vectorizer -mattr=+avx2 -S | FileCheck %s --check-prefix=AVX

%class.1 = type { %class.2 }
%class.2 = type { %"class.3" }
%"class.3" = type { %"struct.1", i64 }
%"struct.1" = type { [8 x i64] }

$_ZN1C10SwitchModeEv = comdat any

; Function Attrs: uwtable
define void @_ZN1C10SwitchModeEv() local_unnamed_addr #0 comdat align 2 {
; SSE-LABEL: @_ZN1C10SwitchModeEv(
; SSE-NEXT:  for.body.lr.ph.i:
; SSE-NEXT:    [[OR_1:%.*]] = or i64 undef, 1
; SSE-NEXT:    store i64 [[OR_1]], i64* undef, align 8
; SSE-NEXT:    [[FOO_1:%.*]] = getelementptr inbounds [[CLASS_1:%.*]], %class.1* undef, i64 0, i32 0, i32 0, i32 0, i32 0, i64 0
; SSE-NEXT:    [[FOO_3:%.*]] = load i64, i64* [[FOO_1]], align 8
; SSE-NEXT:    [[FOO_2:%.*]] = getelementptr inbounds [[CLASS_1]], %class.1* undef, i64 0, i32 0, i32 0, i32 0, i32 0, i64 1
; SSE-NEXT:    [[FOO_4:%.*]] = load i64, i64* [[FOO_2]], align 8
; SSE-NEXT:    [[BAR5:%.*]] = load i64, i64* undef, align 8
; SSE-NEXT:    [[AND_2:%.*]] = and i64 [[OR_1]], [[FOO_3]]
; SSE-NEXT:    [[AND_1:%.*]] = and i64 [[BAR5]], [[FOO_4]]
; SSE-NEXT:    [[BAR3:%.*]] = getelementptr inbounds [[CLASS_2:%.*]], %class.2* undef, i64 0, i32 0, i32 0, i32 0, i64 0
; SSE-NEXT:    store i64 [[AND_2]], i64* [[BAR3]], align 8
; SSE-NEXT:    [[BAR4:%.*]] = getelementptr inbounds [[CLASS_2]], %class.2* undef, i64 0, i32 0, i32 0, i32 0, i64 1
; SSE-NEXT:    store i64 [[AND_1]], i64* [[BAR4]], align 8
; SSE-NEXT:    ret void
;
; AVX-LABEL: @_ZN1C10SwitchModeEv(
; AVX-NEXT:  for.body.lr.ph.i:
; AVX-NEXT:    [[OR_1:%.*]] = or i64 undef, 1
; AVX-NEXT:    store i64 [[OR_1]], i64* undef, align 8
; AVX-NEXT:    [[FOO_1:%.*]] = getelementptr inbounds [[CLASS_1:%.*]], %class.1* undef, i64 0, i32 0, i32 0, i32 0, i32 0, i64 0
; AVX-NEXT:    [[FOO_2:%.*]] = getelementptr inbounds [[CLASS_1]], %class.1* undef, i64 0, i32 0, i32 0, i32 0, i32 0, i64 1
; AVX-NEXT:    [[TMP0:%.*]] = bitcast i64* [[FOO_1]] to <2 x i64>*
; AVX-NEXT:    [[TMP1:%.*]] = load <2 x i64>, <2 x i64>* [[TMP0]], align 8
; AVX-NEXT:    [[BAR5:%.*]] = load i64, i64* undef, align 8
; AVX-NEXT:    [[TMP2:%.*]] = insertelement <2 x i64> poison, i64 [[OR_1]], i32 0
; AVX-NEXT:    [[TMP3:%.*]] = insertelement <2 x i64> [[TMP2]], i64 [[BAR5]], i32 1
; AVX-NEXT:    [[TMP4:%.*]] = and <2 x i64> [[TMP3]], [[TMP1]]
; AVX-NEXT:    [[BAR3:%.*]] = getelementptr inbounds [[CLASS_2:%.*]], %class.2* undef, i64 0, i32 0, i32 0, i32 0, i64 0
; AVX-NEXT:    [[BAR4:%.*]] = getelementptr inbounds [[CLASS_2]], %class.2* undef, i64 0, i32 0, i32 0, i32 0, i64 1
; AVX-NEXT:    [[TMP5:%.*]] = bitcast i64* [[BAR3]] to <2 x i64>*
; AVX-NEXT:    store <2 x i64> [[TMP4]], <2 x i64>* [[TMP5]], align 8
; AVX-NEXT:    ret void
;
for.body.lr.ph.i:
  %or.1 = or i64 undef, 1
  store i64 %or.1, i64* undef, align 8
  %foo.1 = getelementptr inbounds %class.1, %class.1* undef, i64 0, i32 0, i32 0, i32 0, i32 0, i64 0
  %foo.3 = load i64, i64* %foo.1, align 8
  %foo.2 = getelementptr inbounds %class.1, %class.1* undef, i64 0, i32 0, i32 0, i32 0, i32 0, i64 1
  %foo.4 = load i64, i64* %foo.2, align 8
  %bar5 = load i64, i64* undef, align 8
  %and.2 = and i64 %or.1, %foo.3
  %and.1 = and i64 %bar5, %foo.4
  %bar3 = getelementptr inbounds %class.2, %class.2* undef, i64 0, i32 0, i32 0, i32 0, i64 0
  store i64 %and.2, i64* %bar3, align 8
  %bar4 = getelementptr inbounds %class.2, %class.2* undef, i64 0, i32 0, i32 0, i32 0, i64 1
  store i64 %and.1, i64* %bar4, align 8
  ret void
}

; Function Attrs: norecurse nounwind uwtable
define void @pr35497() local_unnamed_addr #0 {
; SSE-LABEL: @pr35497(
; SSE-NEXT:  entry:
; SSE-NEXT:    [[TMP0:%.*]] = load i64, i64* undef, align 1
; SSE-NEXT:    [[AND:%.*]] = shl i64 [[TMP0]], 2
; SSE-NEXT:    [[SHL:%.*]] = and i64 [[AND]], 20
; SSE-NEXT:    [[ADD:%.*]] = add i64 undef, undef
; SSE-NEXT:    store i64 [[ADD]], i64* undef, align 1
; SSE-NEXT:    [[ARRAYIDX2_1:%.*]] = getelementptr inbounds [0 x i64], [0 x i64]* undef, i64 0, i64 5
; SSE-NEXT:    [[AND_1:%.*]] = shl i64 undef, 2
; SSE-NEXT:    [[SHL_1:%.*]] = and i64 [[AND_1]], 20
; SSE-NEXT:    [[SHR_1:%.*]] = lshr i64 undef, 6
; SSE-NEXT:    [[ADD_1:%.*]] = add nuw nsw i64 [[SHL]], [[SHR_1]]
; SSE-NEXT:    [[ARRAYIDX2_2:%.*]] = getelementptr inbounds [0 x i64], [0 x i64]* undef, i64 0, i64 4
; SSE-NEXT:    [[SHR_2:%.*]] = lshr i64 undef, 6
; SSE-NEXT:    [[ADD_2:%.*]] = add nuw nsw i64 [[SHL_1]], [[SHR_2]]
; SSE-NEXT:    [[AND_4:%.*]] = shl i64 [[ADD]], 2
; SSE-NEXT:    [[SHL_4:%.*]] = and i64 [[AND_4]], 20
; SSE-NEXT:    [[ARRAYIDX2_5:%.*]] = getelementptr inbounds [0 x i64], [0 x i64]* undef, i64 0, i64 1
; SSE-NEXT:    store i64 [[ADD_1]], i64* [[ARRAYIDX2_5]], align 1
; SSE-NEXT:    [[AND_5:%.*]] = shl nuw nsw i64 [[ADD_1]], 2
; SSE-NEXT:    [[SHL_5:%.*]] = and i64 [[AND_5]], 20
; SSE-NEXT:    [[SHR_5:%.*]] = lshr i64 [[ADD_1]], 6
; SSE-NEXT:    [[ADD_5:%.*]] = add nuw nsw i64 [[SHL_4]], [[SHR_5]]
; SSE-NEXT:    store i64 [[ADD_5]], i64* [[ARRAYIDX2_1]], align 1
; SSE-NEXT:    [[ARRAYIDX2_6:%.*]] = getelementptr inbounds [0 x i64], [0 x i64]* undef, i64 0, i64 0
; SSE-NEXT:    store i64 [[ADD_2]], i64* [[ARRAYIDX2_6]], align 1
; SSE-NEXT:    [[SHR_6:%.*]] = lshr i64 [[ADD_2]], 6
; SSE-NEXT:    [[ADD_6:%.*]] = add nuw nsw i64 [[SHL_5]], [[SHR_6]]
; SSE-NEXT:    store i64 [[ADD_6]], i64* [[ARRAYIDX2_2]], align 1
; SSE-NEXT:    ret void
;
; AVX-LABEL: @pr35497(
; AVX-NEXT:  entry:
; AVX-NEXT:    [[TMP0:%.*]] = load i64, i64* undef, align 1
; AVX-NEXT:    [[ADD:%.*]] = add i64 undef, undef
; AVX-NEXT:    store i64 [[ADD]], i64* undef, align 1
; AVX-NEXT:    [[ARRAYIDX2_1:%.*]] = getelementptr inbounds [0 x i64], [0 x i64]* undef, i64 0, i64 5
; AVX-NEXT:    [[TMP1:%.*]] = insertelement <2 x i64> <i64 undef, i64 poison>, i64 [[TMP0]], i32 1
; AVX-NEXT:    [[TMP2:%.*]] = shl <2 x i64> [[TMP1]], <i64 2, i64 2>
; AVX-NEXT:    [[TMP3:%.*]] = and <2 x i64> [[TMP2]], <i64 20, i64 20>
; AVX-NEXT:    [[ARRAYIDX2_2:%.*]] = getelementptr inbounds [0 x i64], [0 x i64]* undef, i64 0, i64 4
; AVX-NEXT:    [[TMP4:%.*]] = add nuw nsw <2 x i64> [[TMP3]], zeroinitializer
; AVX-NEXT:    [[ARRAYIDX2_5:%.*]] = getelementptr inbounds [0 x i64], [0 x i64]* undef, i64 0, i64 1
; AVX-NEXT:    [[TMP5:%.*]] = extractelement <2 x i64> [[TMP4]], i32 1
; AVX-NEXT:    [[TMP6:%.*]] = insertelement <2 x i64> poison, i64 [[TMP5]], i32 0
; AVX-NEXT:    [[TMP7:%.*]] = insertelement <2 x i64> [[TMP6]], i64 [[ADD]], i32 1
; AVX-NEXT:    [[TMP8:%.*]] = shl <2 x i64> [[TMP7]], <i64 2, i64 2>
; AVX-NEXT:    [[TMP9:%.*]] = and <2 x i64> [[TMP8]], <i64 20, i64 20>
; AVX-NEXT:    [[ARRAYIDX2_6:%.*]] = getelementptr inbounds [0 x i64], [0 x i64]* undef, i64 0, i64 0
; AVX-NEXT:    [[TMP10:%.*]] = bitcast i64* [[ARRAYIDX2_6]] to <2 x i64>*
; AVX-NEXT:    store <2 x i64> [[TMP4]], <2 x i64>* [[TMP10]], align 1
; AVX-NEXT:    [[TMP11:%.*]] = extractelement <2 x i64> [[TMP4]], i32 0
; AVX-NEXT:    [[TMP12:%.*]] = insertelement <2 x i64> poison, i64 [[TMP11]], i32 0
; AVX-NEXT:    [[TMP13:%.*]] = insertelement <2 x i64> [[TMP12]], i64 [[TMP5]], i32 1
; AVX-NEXT:    [[TMP14:%.*]] = lshr <2 x i64> [[TMP13]], <i64 6, i64 6>
; AVX-NEXT:    [[TMP15:%.*]] = add nuw nsw <2 x i64> [[TMP9]], [[TMP14]]
; AVX-NEXT:    [[TMP16:%.*]] = bitcast i64* [[ARRAYIDX2_2]] to <2 x i64>*
; AVX-NEXT:    store <2 x i64> [[TMP15]], <2 x i64>* [[TMP16]], align 1
; AVX-NEXT:    ret void
;
entry:
  %0 = load i64, i64* undef, align 1
  %and = shl i64 %0, 2
  %shl = and i64 %and, 20
  %add = add i64 undef, undef
  store i64 %add, i64* undef, align 1
  %arrayidx2.1 = getelementptr inbounds [0 x i64], [0 x i64]* undef, i64 0, i64 5
  %and.1 = shl i64 undef, 2
  %shl.1 = and i64 %and.1, 20
  %shr.1 = lshr i64 undef, 6
  %add.1 = add nuw nsw i64 %shl, %shr.1
  %arrayidx2.2 = getelementptr inbounds [0 x i64], [0 x i64]* undef, i64 0, i64 4
  %shr.2 = lshr i64 undef, 6
  %add.2 = add nuw nsw i64 %shl.1, %shr.2
  %and.4 = shl i64 %add, 2
  %shl.4 = and i64 %and.4, 20
  %arrayidx2.5 = getelementptr inbounds [0 x i64], [0 x i64]* undef, i64 0, i64 1
  store i64 %add.1, i64* %arrayidx2.5, align 1
  %and.5 = shl nuw nsw i64 %add.1, 2
  %shl.5 = and i64 %and.5, 20
  %shr.5 = lshr i64 %add.1, 6
  %add.5 = add nuw nsw i64 %shl.4, %shr.5
  store i64 %add.5, i64* %arrayidx2.1, align 1
  %arrayidx2.6 = getelementptr inbounds [0 x i64], [0 x i64]* undef, i64 0, i64 0
  store i64 %add.2, i64* %arrayidx2.6, align 1
  %shr.6 = lshr i64 %add.2, 6
  %add.6 = add nuw nsw i64 %shl.5, %shr.6
  store i64 %add.6, i64* %arrayidx2.2, align 1
  ret void
}
