; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -matrix-allow-contract=false -lower-matrix-intrinsics -S < %s | FileCheck  %s
; RUN: opt -matrix-allow-contract=false -passes='lower-matrix-intrinsics' -S < %s | FileCheck %s

define <8 x double> @fadd_transpose(<8 x double> %a, <8 x double> %b) {
; CHECK-LABEL: @fadd_transpose(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SPLIT:%.*]] = shufflevector <8 x double> [[A:%.*]], <8 x double> poison, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[SPLIT1:%.*]] = shufflevector <8 x double> [[A]], <8 x double> poison, <2 x i32> <i32 2, i32 3>
; CHECK-NEXT:    [[SPLIT2:%.*]] = shufflevector <8 x double> [[A]], <8 x double> poison, <2 x i32> <i32 4, i32 5>
; CHECK-NEXT:    [[SPLIT3:%.*]] = shufflevector <8 x double> [[A]], <8 x double> poison, <2 x i32> <i32 6, i32 7>
; CHECK-NEXT:    [[SPLIT4:%.*]] = shufflevector <8 x double> [[B:%.*]], <8 x double> poison, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[SPLIT5:%.*]] = shufflevector <8 x double> [[B]], <8 x double> poison, <2 x i32> <i32 2, i32 3>
; CHECK-NEXT:    [[SPLIT6:%.*]] = shufflevector <8 x double> [[B]], <8 x double> poison, <2 x i32> <i32 4, i32 5>
; CHECK-NEXT:    [[SPLIT7:%.*]] = shufflevector <8 x double> [[B]], <8 x double> poison, <2 x i32> <i32 6, i32 7>
; CHECK-NEXT:    [[TMP0:%.*]] = fadd <2 x double> [[SPLIT]], [[SPLIT4]]
; CHECK-NEXT:    [[TMP1:%.*]] = fadd <2 x double> [[SPLIT1]], [[SPLIT5]]
; CHECK-NEXT:    [[TMP2:%.*]] = fadd <2 x double> [[SPLIT2]], [[SPLIT6]]
; CHECK-NEXT:    [[TMP3:%.*]] = fadd <2 x double> [[SPLIT3]], [[SPLIT7]]
; CHECK-NEXT:    [[TMP4:%.*]] = extractelement <2 x double> [[TMP0]], i64 0
; CHECK-NEXT:    [[TMP5:%.*]] = insertelement <4 x double> undef, double [[TMP4]], i64 0
; CHECK-NEXT:    [[TMP6:%.*]] = extractelement <2 x double> [[TMP1]], i64 0
; CHECK-NEXT:    [[TMP7:%.*]] = insertelement <4 x double> [[TMP5]], double [[TMP6]], i64 1
; CHECK-NEXT:    [[TMP8:%.*]] = extractelement <2 x double> [[TMP2]], i64 0
; CHECK-NEXT:    [[TMP9:%.*]] = insertelement <4 x double> [[TMP7]], double [[TMP8]], i64 2
; CHECK-NEXT:    [[TMP10:%.*]] = extractelement <2 x double> [[TMP3]], i64 0
; CHECK-NEXT:    [[TMP11:%.*]] = insertelement <4 x double> [[TMP9]], double [[TMP10]], i64 3
; CHECK-NEXT:    [[TMP12:%.*]] = extractelement <2 x double> [[TMP0]], i64 1
; CHECK-NEXT:    [[TMP13:%.*]] = insertelement <4 x double> undef, double [[TMP12]], i64 0
; CHECK-NEXT:    [[TMP14:%.*]] = extractelement <2 x double> [[TMP1]], i64 1
; CHECK-NEXT:    [[TMP15:%.*]] = insertelement <4 x double> [[TMP13]], double [[TMP14]], i64 1
; CHECK-NEXT:    [[TMP16:%.*]] = extractelement <2 x double> [[TMP2]], i64 1
; CHECK-NEXT:    [[TMP17:%.*]] = insertelement <4 x double> [[TMP15]], double [[TMP16]], i64 2
; CHECK-NEXT:    [[TMP18:%.*]] = extractelement <2 x double> [[TMP3]], i64 1
; CHECK-NEXT:    [[TMP19:%.*]] = insertelement <4 x double> [[TMP17]], double [[TMP18]], i64 3
; CHECK-NEXT:    [[TMP20:%.*]] = shufflevector <4 x double> [[TMP11]], <4 x double> [[TMP19]], <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
; CHECK-NEXT:    ret <8 x double> [[TMP20]]
;
entry:
  %add = fadd <8 x double> %a, %b
  %c  = call <8 x double> @llvm.matrix.transpose(<8 x double> %add, i32 2, i32 4)
  ret <8 x double> %c
}

define <8 x double> @load_fadd_transpose(<8 x double>* %A.Ptr, <8 x double> %b) {
; CHECK-LABEL: @load_fadd_transpose(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast <8 x double>* [[A_PTR:%.*]] to double*
; CHECK-NEXT:    [[VEC_CAST:%.*]] = bitcast double* [[TMP0]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST]], align 8
; CHECK-NEXT:    [[VEC_GEP:%.*]] = getelementptr double, double* [[TMP0]], i64 2
; CHECK-NEXT:    [[VEC_CAST1:%.*]] = bitcast double* [[VEC_GEP]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD2:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST1]], align 8
; CHECK-NEXT:    [[VEC_GEP3:%.*]] = getelementptr double, double* [[TMP0]], i64 4
; CHECK-NEXT:    [[VEC_CAST4:%.*]] = bitcast double* [[VEC_GEP3]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD5:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST4]], align 8
; CHECK-NEXT:    [[VEC_GEP6:%.*]] = getelementptr double, double* [[TMP0]], i64 6
; CHECK-NEXT:    [[VEC_CAST7:%.*]] = bitcast double* [[VEC_GEP6]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD8:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST7]], align 8
; CHECK-NEXT:    [[SPLIT:%.*]] = shufflevector <8 x double> [[B:%.*]], <8 x double> poison, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[SPLIT9:%.*]] = shufflevector <8 x double> [[B]], <8 x double> poison, <2 x i32> <i32 2, i32 3>
; CHECK-NEXT:    [[SPLIT10:%.*]] = shufflevector <8 x double> [[B]], <8 x double> poison, <2 x i32> <i32 4, i32 5>
; CHECK-NEXT:    [[SPLIT11:%.*]] = shufflevector <8 x double> [[B]], <8 x double> poison, <2 x i32> <i32 6, i32 7>
; CHECK-NEXT:    [[TMP1:%.*]] = fadd <2 x double> [[COL_LOAD]], [[SPLIT]]
; CHECK-NEXT:    [[TMP2:%.*]] = fadd <2 x double> [[COL_LOAD2]], [[SPLIT9]]
; CHECK-NEXT:    [[TMP3:%.*]] = fadd <2 x double> [[COL_LOAD5]], [[SPLIT10]]
; CHECK-NEXT:    [[TMP4:%.*]] = fadd <2 x double> [[COL_LOAD8]], [[SPLIT11]]
; CHECK-NEXT:    [[TMP5:%.*]] = extractelement <2 x double> [[TMP1]], i64 0
; CHECK-NEXT:    [[TMP6:%.*]] = insertelement <4 x double> undef, double [[TMP5]], i64 0
; CHECK-NEXT:    [[TMP7:%.*]] = extractelement <2 x double> [[TMP2]], i64 0
; CHECK-NEXT:    [[TMP8:%.*]] = insertelement <4 x double> [[TMP6]], double [[TMP7]], i64 1
; CHECK-NEXT:    [[TMP9:%.*]] = extractelement <2 x double> [[TMP3]], i64 0
; CHECK-NEXT:    [[TMP10:%.*]] = insertelement <4 x double> [[TMP8]], double [[TMP9]], i64 2
; CHECK-NEXT:    [[TMP11:%.*]] = extractelement <2 x double> [[TMP4]], i64 0
; CHECK-NEXT:    [[TMP12:%.*]] = insertelement <4 x double> [[TMP10]], double [[TMP11]], i64 3
; CHECK-NEXT:    [[TMP13:%.*]] = extractelement <2 x double> [[TMP1]], i64 1
; CHECK-NEXT:    [[TMP14:%.*]] = insertelement <4 x double> undef, double [[TMP13]], i64 0
; CHECK-NEXT:    [[TMP15:%.*]] = extractelement <2 x double> [[TMP2]], i64 1
; CHECK-NEXT:    [[TMP16:%.*]] = insertelement <4 x double> [[TMP14]], double [[TMP15]], i64 1
; CHECK-NEXT:    [[TMP17:%.*]] = extractelement <2 x double> [[TMP3]], i64 1
; CHECK-NEXT:    [[TMP18:%.*]] = insertelement <4 x double> [[TMP16]], double [[TMP17]], i64 2
; CHECK-NEXT:    [[TMP19:%.*]] = extractelement <2 x double> [[TMP4]], i64 1
; CHECK-NEXT:    [[TMP20:%.*]] = insertelement <4 x double> [[TMP18]], double [[TMP19]], i64 3
; CHECK-NEXT:    [[TMP21:%.*]] = shufflevector <4 x double> [[TMP12]], <4 x double> [[TMP20]], <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
; CHECK-NEXT:    ret <8 x double> [[TMP21]]
;


entry:
  %a = load <8 x double>, <8 x double>* %A.Ptr, align 8
  %add = fadd <8 x double> %a, %b
  %c  = call <8 x double> @llvm.matrix.transpose(<8 x double> %add, i32 2, i32 4)
  ret <8 x double> %c
}

define <8 x double> @load_fneg_transpose(<8 x double>* %A.Ptr) {
; CHECK-LABEL: @load_fneg_transpose(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast <8 x double>* [[A_PTR:%.*]] to double*
; CHECK-NEXT:    [[VEC_CAST:%.*]] = bitcast double* [[TMP0]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST]], align 8
; CHECK-NEXT:    [[VEC_GEP:%.*]] = getelementptr double, double* [[TMP0]], i64 2
; CHECK-NEXT:    [[VEC_CAST1:%.*]] = bitcast double* [[VEC_GEP]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD2:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST1]], align 8
; CHECK-NEXT:    [[VEC_GEP3:%.*]] = getelementptr double, double* [[TMP0]], i64 4
; CHECK-NEXT:    [[VEC_CAST4:%.*]] = bitcast double* [[VEC_GEP3]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD5:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST4]], align 8
; CHECK-NEXT:    [[VEC_GEP6:%.*]] = getelementptr double, double* [[TMP0]], i64 6
; CHECK-NEXT:    [[VEC_CAST7:%.*]] = bitcast double* [[VEC_GEP6]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD8:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST7]], align 8
; CHECK-NEXT:    [[TMP1:%.*]] = fneg <2 x double> [[COL_LOAD]]
; CHECK-NEXT:    [[TMP2:%.*]] = fneg <2 x double> [[COL_LOAD2]]
; CHECK-NEXT:    [[TMP3:%.*]] = fneg <2 x double> [[COL_LOAD5]]
; CHECK-NEXT:    [[TMP4:%.*]] = fneg <2 x double> [[COL_LOAD8]]
; CHECK-NEXT:    [[TMP5:%.*]] = extractelement <2 x double> [[TMP1]], i64 0
; CHECK-NEXT:    [[TMP6:%.*]] = insertelement <4 x double> undef, double [[TMP5]], i64 0
; CHECK-NEXT:    [[TMP7:%.*]] = extractelement <2 x double> [[TMP2]], i64 0
; CHECK-NEXT:    [[TMP8:%.*]] = insertelement <4 x double> [[TMP6]], double [[TMP7]], i64 1
; CHECK-NEXT:    [[TMP9:%.*]] = extractelement <2 x double> [[TMP3]], i64 0
; CHECK-NEXT:    [[TMP10:%.*]] = insertelement <4 x double> [[TMP8]], double [[TMP9]], i64 2
; CHECK-NEXT:    [[TMP11:%.*]] = extractelement <2 x double> [[TMP4]], i64 0
; CHECK-NEXT:    [[TMP12:%.*]] = insertelement <4 x double> [[TMP10]], double [[TMP11]], i64 3
; CHECK-NEXT:    [[TMP13:%.*]] = extractelement <2 x double> [[TMP1]], i64 1
; CHECK-NEXT:    [[TMP14:%.*]] = insertelement <4 x double> undef, double [[TMP13]], i64 0
; CHECK-NEXT:    [[TMP15:%.*]] = extractelement <2 x double> [[TMP2]], i64 1
; CHECK-NEXT:    [[TMP16:%.*]] = insertelement <4 x double> [[TMP14]], double [[TMP15]], i64 1
; CHECK-NEXT:    [[TMP17:%.*]] = extractelement <2 x double> [[TMP3]], i64 1
; CHECK-NEXT:    [[TMP18:%.*]] = insertelement <4 x double> [[TMP16]], double [[TMP17]], i64 2
; CHECK-NEXT:    [[TMP19:%.*]] = extractelement <2 x double> [[TMP4]], i64 1
; CHECK-NEXT:    [[TMP20:%.*]] = insertelement <4 x double> [[TMP18]], double [[TMP19]], i64 3
; CHECK-NEXT:    [[TMP21:%.*]] = shufflevector <4 x double> [[TMP12]], <4 x double> [[TMP20]], <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
; CHECK-NEXT:    ret <8 x double> [[TMP21]]
;
entry:
  %a = load <8 x double>, <8 x double>* %A.Ptr, align 8
  %neg = fneg <8 x double> %a
  %c  = call <8 x double> @llvm.matrix.transpose(<8 x double> %neg, i32 2, i32 4)
  ret <8 x double> %c
}
declare <8 x double> @llvm.matrix.transpose(<8 x double>, i32, i32)
