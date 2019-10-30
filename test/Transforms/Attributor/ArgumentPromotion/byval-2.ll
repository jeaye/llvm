; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --scrub-attributes
; RUN: opt -S -passes=attributor -aa-pipeline='basic-aa' -attributor-disable=false -attributor-max-iterations-verify -attributor-max-iterations=3 < %s | FileCheck %s

%struct.ss = type { i32, i64 }

define internal void @f(%struct.ss* byval  %b, i32* byval %X) nounwind  {
; CHECK-LABEL: define {{[^@]+}}@f
; CHECK-SAME: (i32 [[TMP0:%.*]], i64 [[TMP1:%.*]], i32 [[TMP2:%.*]])
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[X_PRIV:%.*]] = alloca i32
; CHECK-NEXT:    store i32 [[TMP2]], i32* [[X_PRIV]]
; CHECK-NEXT:    [[B_PRIV:%.*]] = alloca [[STRUCT_SS:%.*]]
; CHECK-NEXT:    [[B_PRIV_CAST:%.*]] = bitcast %struct.ss* [[B_PRIV]] to i32*
; CHECK-NEXT:    store i32 [[TMP0]], i32* [[B_PRIV_CAST]]
; CHECK-NEXT:    [[B_PRIV_0_1:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[B_PRIV]], i32 0, i32 1
; CHECK-NEXT:    store i64 [[TMP1]], i64* [[B_PRIV_0_1]]
; CHECK-NEXT:    [[TMP:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[B_PRIV]], i32 0, i32 0
; CHECK-NEXT:    [[TMP1:%.*]] = load i32, i32* [[TMP]], align 8
; CHECK-NEXT:    [[TMP2:%.*]] = add i32 [[TMP1]], 1
; CHECK-NEXT:    store i32 [[TMP2]], i32* [[TMP]], align 8
; CHECK-NEXT:    store i32 0, i32* [[X_PRIV]]
; CHECK-NEXT:    ret void
;
entry:
  %tmp = getelementptr %struct.ss, %struct.ss* %b, i32 0, i32 0
  %tmp1 = load i32, i32* %tmp, align 4
  %tmp2 = add i32 %tmp1, 1
  store i32 %tmp2, i32* %tmp, align 4

  store i32 0, i32* %X
  ret void
}

define i32 @test(i32* %X) {
; CHECK-LABEL: define {{[^@]+}}@test
; CHECK-SAME: (i32* nocapture nofree readonly [[X:%.*]])
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[S:%.*]] = alloca [[STRUCT_SS:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[S]], i32 0, i32 0
; CHECK-NEXT:    store i32 1, i32* [[TMP1]], align 8
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[S]], i32 0, i32 1
; CHECK-NEXT:    store i64 2, i64* [[TMP4]], align 4
; CHECK-NEXT:    [[S_CAST:%.*]] = bitcast %struct.ss* [[S]] to i32*
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* [[S_CAST]], align 1
; CHECK-NEXT:    [[S_0_1:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[S]], i32 0, i32 1
; CHECK-NEXT:    [[TMP1:%.*]] = load i64, i64* [[S_0_1]], align 1
; CHECK-NEXT:    [[TMP2:%.*]] = load i32, i32* [[X]], align 1
; CHECK-NEXT:    call void @f(i32 [[TMP0]], i64 [[TMP1]], i32 [[TMP2]])
; CHECK-NEXT:    ret i32 0
;
entry:
  %S = alloca %struct.ss
  %tmp1 = getelementptr %struct.ss, %struct.ss* %S, i32 0, i32 0
  store i32 1, i32* %tmp1, align 8
  %tmp4 = getelementptr %struct.ss, %struct.ss* %S, i32 0, i32 1
  store i64 2, i64* %tmp4, align 4
  call void @f( %struct.ss* byval %S, i32* byval %X)
  ret i32 0
}
