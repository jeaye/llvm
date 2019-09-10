; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -S -expandmemcmp -verify-dom-info -mtriple=aarch64-linux-gnu -data-layout="e-m:e-i64:64-n32:64" | FileCheck %s
; RUN: opt < %s -S -expandmemcmp -verify-dom-info -mtriple=aarch64-linux-gnu -mattr=strict-align -data-layout="E-m:e-i64:64-n32:64"  | FileCheck %s --check-prefix=CHECK-STRICTALIGN

declare i32 @bcmp(i8*, i8*, i64) nounwind readonly
declare i32 @memcmp(i8*, i8*, i64) nounwind readonly

define i1 @bcmp_b2(i8* %s1, i8* %s2) {
; CHECK-LABEL: @bcmp_b2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i8* [[S1:%.*]] to i64*
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i8* [[S2:%.*]] to i64*
; CHECK-NEXT:    [[TMP2:%.*]] = load i64, i64* [[TMP0]]
; CHECK-NEXT:    [[TMP3:%.*]] = load i64, i64* [[TMP1]]
; CHECK-NEXT:    [[TMP4:%.*]] = xor i64 [[TMP2]], [[TMP3]]
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr i8, i8* [[S1]], i8 7
; CHECK-NEXT:    [[TMP6:%.*]] = bitcast i8* [[TMP5]] to i64*
; CHECK-NEXT:    [[TMP7:%.*]] = getelementptr i8, i8* [[S2]], i8 7
; CHECK-NEXT:    [[TMP8:%.*]] = bitcast i8* [[TMP7]] to i64*
; CHECK-NEXT:    [[TMP9:%.*]] = load i64, i64* [[TMP6]]
; CHECK-NEXT:    [[TMP10:%.*]] = load i64, i64* [[TMP8]]
; CHECK-NEXT:    [[TMP11:%.*]] = xor i64 [[TMP9]], [[TMP10]]
; CHECK-NEXT:    [[TMP12:%.*]] = or i64 [[TMP4]], [[TMP11]]
; CHECK-NEXT:    [[TMP13:%.*]] = icmp ne i64 [[TMP12]], 0
; CHECK-NEXT:    [[TMP14:%.*]] = zext i1 [[TMP13]] to i32
; CHECK-NEXT:    [[RET:%.*]] = icmp eq i32 [[TMP14]], 0
; CHECK-NEXT:    ret i1 [[RET]]
;
; CHECK-STRICTALIGN-LABEL: @bcmp_b2(
; CHECK-STRICTALIGN-NEXT:  entry:
; CHECK-STRICTALIGN-NEXT:    [[TMP0:%.*]] = bitcast i8* [[S1:%.*]] to i64*
; CHECK-STRICTALIGN-NEXT:    [[TMP1:%.*]] = bitcast i8* [[S2:%.*]] to i64*
; CHECK-STRICTALIGN-NEXT:    [[TMP2:%.*]] = load i64, i64* [[TMP0]]
; CHECK-STRICTALIGN-NEXT:    [[TMP3:%.*]] = load i64, i64* [[TMP1]]
; CHECK-STRICTALIGN-NEXT:    [[TMP4:%.*]] = xor i64 [[TMP2]], [[TMP3]]
; CHECK-STRICTALIGN-NEXT:    [[TMP5:%.*]] = getelementptr i8, i8* [[S1]], i8 8
; CHECK-STRICTALIGN-NEXT:    [[TMP6:%.*]] = bitcast i8* [[TMP5]] to i32*
; CHECK-STRICTALIGN-NEXT:    [[TMP7:%.*]] = getelementptr i8, i8* [[S2]], i8 8
; CHECK-STRICTALIGN-NEXT:    [[TMP8:%.*]] = bitcast i8* [[TMP7]] to i32*
; CHECK-STRICTALIGN-NEXT:    [[TMP9:%.*]] = load i32, i32* [[TMP6]]
; CHECK-STRICTALIGN-NEXT:    [[TMP10:%.*]] = load i32, i32* [[TMP8]]
; CHECK-STRICTALIGN-NEXT:    [[TMP11:%.*]] = zext i32 [[TMP9]] to i64
; CHECK-STRICTALIGN-NEXT:    [[TMP12:%.*]] = zext i32 [[TMP10]] to i64
; CHECK-STRICTALIGN-NEXT:    [[TMP13:%.*]] = xor i64 [[TMP11]], [[TMP12]]
; CHECK-STRICTALIGN-NEXT:    [[TMP14:%.*]] = getelementptr i8, i8* [[S1]], i8 12
; CHECK-STRICTALIGN-NEXT:    [[TMP15:%.*]] = bitcast i8* [[TMP14]] to i16*
; CHECK-STRICTALIGN-NEXT:    [[TMP16:%.*]] = getelementptr i8, i8* [[S2]], i8 12
; CHECK-STRICTALIGN-NEXT:    [[TMP17:%.*]] = bitcast i8* [[TMP16]] to i16*
; CHECK-STRICTALIGN-NEXT:    [[TMP18:%.*]] = load i16, i16* [[TMP15]]
; CHECK-STRICTALIGN-NEXT:    [[TMP19:%.*]] = load i16, i16* [[TMP17]]
; CHECK-STRICTALIGN-NEXT:    [[TMP20:%.*]] = zext i16 [[TMP18]] to i64
; CHECK-STRICTALIGN-NEXT:    [[TMP21:%.*]] = zext i16 [[TMP19]] to i64
; CHECK-STRICTALIGN-NEXT:    [[TMP22:%.*]] = xor i64 [[TMP20]], [[TMP21]]
; CHECK-STRICTALIGN-NEXT:    [[TMP23:%.*]] = getelementptr i8, i8* [[S1]], i8 14
; CHECK-STRICTALIGN-NEXT:    [[TMP24:%.*]] = getelementptr i8, i8* [[S2]], i8 14
; CHECK-STRICTALIGN-NEXT:    [[TMP25:%.*]] = load i8, i8* [[TMP23]]
; CHECK-STRICTALIGN-NEXT:    [[TMP26:%.*]] = load i8, i8* [[TMP24]]
; CHECK-STRICTALIGN-NEXT:    [[TMP27:%.*]] = zext i8 [[TMP25]] to i64
; CHECK-STRICTALIGN-NEXT:    [[TMP28:%.*]] = zext i8 [[TMP26]] to i64
; CHECK-STRICTALIGN-NEXT:    [[TMP29:%.*]] = xor i64 [[TMP27]], [[TMP28]]
; CHECK-STRICTALIGN-NEXT:    [[TMP30:%.*]] = or i64 [[TMP4]], [[TMP13]]
; CHECK-STRICTALIGN-NEXT:    [[TMP31:%.*]] = or i64 [[TMP22]], [[TMP29]]
; CHECK-STRICTALIGN-NEXT:    [[TMP32:%.*]] = or i64 [[TMP30]], [[TMP31]]
; CHECK-STRICTALIGN-NEXT:    [[TMP33:%.*]] = icmp ne i64 [[TMP32]], 0
; CHECK-STRICTALIGN-NEXT:    [[TMP34:%.*]] = zext i1 [[TMP33]] to i32
; CHECK-STRICTALIGN-NEXT:    [[RET:%.*]] = icmp eq i32 [[TMP34]], 0
; CHECK-STRICTALIGN-NEXT:    ret i1 [[RET]]
;
entry:
  %bcmp = call i32 @bcmp(i8* %s1, i8* %s2, i64 15)
  %ret = icmp eq i32 %bcmp, 0
  ret i1 %ret
}

define i1 @bcmp_bs(i8* %s1, i8* %s2) optsize {
; CHECK-LABEL: @bcmp_bs(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i8* [[S1:%.*]] to i64*
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i8* [[S2:%.*]] to i64*
; CHECK-NEXT:    [[TMP2:%.*]] = load i64, i64* [[TMP0]]
; CHECK-NEXT:    [[TMP3:%.*]] = load i64, i64* [[TMP1]]
; CHECK-NEXT:    [[TMP4:%.*]] = xor i64 [[TMP2]], [[TMP3]]
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr i8, i8* [[S1]], i8 8
; CHECK-NEXT:    [[TMP6:%.*]] = bitcast i8* [[TMP5]] to i64*
; CHECK-NEXT:    [[TMP7:%.*]] = getelementptr i8, i8* [[S2]], i8 8
; CHECK-NEXT:    [[TMP8:%.*]] = bitcast i8* [[TMP7]] to i64*
; CHECK-NEXT:    [[TMP9:%.*]] = load i64, i64* [[TMP6]]
; CHECK-NEXT:    [[TMP10:%.*]] = load i64, i64* [[TMP8]]
; CHECK-NEXT:    [[TMP11:%.*]] = xor i64 [[TMP9]], [[TMP10]]
; CHECK-NEXT:    [[TMP12:%.*]] = getelementptr i8, i8* [[S1]], i8 16
; CHECK-NEXT:    [[TMP13:%.*]] = bitcast i8* [[TMP12]] to i64*
; CHECK-NEXT:    [[TMP14:%.*]] = getelementptr i8, i8* [[S2]], i8 16
; CHECK-NEXT:    [[TMP15:%.*]] = bitcast i8* [[TMP14]] to i64*
; CHECK-NEXT:    [[TMP16:%.*]] = load i64, i64* [[TMP13]]
; CHECK-NEXT:    [[TMP17:%.*]] = load i64, i64* [[TMP15]]
; CHECK-NEXT:    [[TMP18:%.*]] = xor i64 [[TMP16]], [[TMP17]]
; CHECK-NEXT:    [[TMP19:%.*]] = getelementptr i8, i8* [[S1]], i8 23
; CHECK-NEXT:    [[TMP20:%.*]] = bitcast i8* [[TMP19]] to i64*
; CHECK-NEXT:    [[TMP21:%.*]] = getelementptr i8, i8* [[S2]], i8 23
; CHECK-NEXT:    [[TMP22:%.*]] = bitcast i8* [[TMP21]] to i64*
; CHECK-NEXT:    [[TMP23:%.*]] = load i64, i64* [[TMP20]]
; CHECK-NEXT:    [[TMP24:%.*]] = load i64, i64* [[TMP22]]
; CHECK-NEXT:    [[TMP25:%.*]] = xor i64 [[TMP23]], [[TMP24]]
; CHECK-NEXT:    [[TMP26:%.*]] = or i64 [[TMP4]], [[TMP11]]
; CHECK-NEXT:    [[TMP27:%.*]] = or i64 [[TMP18]], [[TMP25]]
; CHECK-NEXT:    [[TMP28:%.*]] = or i64 [[TMP26]], [[TMP27]]
; CHECK-NEXT:    [[TMP29:%.*]] = icmp ne i64 [[TMP28]], 0
; CHECK-NEXT:    [[TMP30:%.*]] = zext i1 [[TMP29]] to i32
; CHECK-NEXT:    [[RET:%.*]] = icmp eq i32 [[TMP30]], 0
; CHECK-NEXT:    ret i1 [[RET]]
;
; CHECK-STRICTALIGN-LABEL: @bcmp_bs(
; CHECK-STRICTALIGN-NEXT:  entry:
; CHECK-STRICTALIGN-NEXT:    [[MEMCMP:%.*]] = call i32 @memcmp(i8* [[S1:%.*]], i8* [[S2:%.*]], i64 31)
; CHECK-STRICTALIGN-NEXT:    [[RET:%.*]] = icmp eq i32 [[MEMCMP]], 0
; CHECK-STRICTALIGN-NEXT:    ret i1 [[RET]]
;
entry:
  %memcmp = call i32 @memcmp(i8* %s1, i8* %s2, i64 31)
  %ret = icmp eq i32 %memcmp, 0
  ret i1 %ret
}


