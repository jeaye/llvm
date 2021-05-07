; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -mtriple=hexagon -S -hexagon-vc -instcombine < %s | FileCheck %s

; Check that Hexagon Vector Combine propagates (TBAA) metadata to the
; generated output. (Use instcombine to clean the output up a bit.)

target datalayout = "e-m:e-p:32:32:32-a:0-n16:32-i64:64:64-i32:32:32-i16:16:16-i1:8:8-f32:32:32-f64:64:64-v32:32:32-v64:64:64-v512:512:512-v1024:1024:1024-v2048:2048:2048"
target triple = "hexagon"

; Two unaligned loads, both with the same TBAA tag.
;
define <64 x i16> @f0(i16* %a0, i32 %a1) #0 {
; CHECK-LABEL: @f0(
; CHECK-NEXT:  b0:
; CHECK-NEXT:    [[V0:%.*]] = add i32 [[A1:%.*]], 64
; CHECK-NEXT:    [[V1:%.*]] = getelementptr i16, i16* [[A0:%.*]], i32 [[V0]]
; CHECK-NEXT:    [[TMP0:%.*]] = ptrtoint i16* [[V1]] to i32
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 [[TMP0]], -128
; CHECK-NEXT:    [[TMP2:%.*]] = inttoptr i32 [[TMP1]] to <64 x i16>*
; CHECK-NEXT:    [[TMP3:%.*]] = ptrtoint i16* [[V1]] to i32
; CHECK-NEXT:    [[TMP4:%.*]] = inttoptr i32 [[TMP1]] to <32 x i32>*
; CHECK-NEXT:    [[TMP5:%.*]] = load <32 x i32>, <32 x i32>* [[TMP4]], align 128, !tbaa [[TBAA0:![0-9]+]]
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr <64 x i16>, <64 x i16>* [[TMP2]], i32 1
; CHECK-NEXT:    [[TMP7:%.*]] = bitcast <64 x i16>* [[TMP6]] to <128 x i8>*
; CHECK-NEXT:    [[TMP8:%.*]] = load <128 x i8>, <128 x i8>* [[TMP7]], align 128, !tbaa [[TBAA0]]
; CHECK-NEXT:    [[TMP9:%.*]] = getelementptr <64 x i16>, <64 x i16>* [[TMP2]], i32 2
; CHECK-NEXT:    [[TMP10:%.*]] = bitcast <64 x i16>* [[TMP9]] to <32 x i32>*
; CHECK-NEXT:    [[TMP11:%.*]] = load <32 x i32>, <32 x i32>* [[TMP10]], align 128, !tbaa [[TBAA0]]
; CHECK-NEXT:    [[TMP12:%.*]] = bitcast <128 x i8> [[TMP8]] to <32 x i32>
; CHECK-NEXT:    [[TMP13:%.*]] = call <32 x i32> @llvm.hexagon.V6.valignb.128B(<32 x i32> [[TMP12]], <32 x i32> [[TMP5]], i32 [[TMP3]])
; CHECK-NEXT:    [[TMP14:%.*]] = bitcast <128 x i8> [[TMP8]] to <32 x i32>
; CHECK-NEXT:    [[TMP15:%.*]] = call <32 x i32> @llvm.hexagon.V6.valignb.128B(<32 x i32> [[TMP11]], <32 x i32> [[TMP14]], i32 [[TMP3]])
; CHECK-NEXT:    [[TMP16:%.*]] = bitcast <32 x i32> [[TMP13]] to <64 x i16>
; CHECK-NEXT:    [[TMP17:%.*]] = bitcast <32 x i32> [[TMP15]] to <64 x i16>
; CHECK-NEXT:    [[V8:%.*]] = add <64 x i16> [[TMP16]], [[TMP17]]
; CHECK-NEXT:    ret <64 x i16> [[V8]]
;
b0:
  %v0 = add i32 %a1, 64
  %v1 = getelementptr i16, i16* %a0, i32 %v0
  %v2 = bitcast i16* %v1 to <64 x i16>*
  %v3 = load <64 x i16>, <64 x i16>* %v2, align 2, !tbaa !0
  %v4 = add i32 %a1, 128
  %v5 = getelementptr i16, i16* %a0, i32 %v4
  %v6 = bitcast i16* %v5 to <64 x i16>*
  %v7 = load <64 x i16>, <64 x i16>* %v6, align 2, !tbaa !0
  %v8 = add <64 x i16> %v3, %v7
  ret <64 x i16> %v8
}

; Two unaligned loads, only one with a TBAA tag.
;
define <64 x i16> @f1(i16* %a0, i32 %a1) #0 {
; CHECK-LABEL: @f1(
; CHECK-NEXT:  b0:
; CHECK-NEXT:    [[V0:%.*]] = add i32 [[A1:%.*]], 64
; CHECK-NEXT:    [[V1:%.*]] = getelementptr i16, i16* [[A0:%.*]], i32 [[V0]]
; CHECK-NEXT:    [[TMP0:%.*]] = ptrtoint i16* [[V1]] to i32
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 [[TMP0]], -128
; CHECK-NEXT:    [[TMP2:%.*]] = inttoptr i32 [[TMP1]] to <64 x i16>*
; CHECK-NEXT:    [[TMP3:%.*]] = ptrtoint i16* [[V1]] to i32
; CHECK-NEXT:    [[TMP4:%.*]] = inttoptr i32 [[TMP1]] to <32 x i32>*
; CHECK-NEXT:    [[TMP5:%.*]] = load <32 x i32>, <32 x i32>* [[TMP4]], align 128, !tbaa [[TBAA0]]
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr <64 x i16>, <64 x i16>* [[TMP2]], i32 1
; CHECK-NEXT:    [[TMP7:%.*]] = bitcast <64 x i16>* [[TMP6]] to <128 x i8>*
; CHECK-NEXT:    [[TMP8:%.*]] = load <128 x i8>, <128 x i8>* [[TMP7]], align 128
; CHECK-NEXT:    [[TMP9:%.*]] = getelementptr <64 x i16>, <64 x i16>* [[TMP2]], i32 2
; CHECK-NEXT:    [[TMP10:%.*]] = bitcast <64 x i16>* [[TMP9]] to <32 x i32>*
; CHECK-NEXT:    [[TMP11:%.*]] = load <32 x i32>, <32 x i32>* [[TMP10]], align 128
; CHECK-NEXT:    [[TMP12:%.*]] = bitcast <128 x i8> [[TMP8]] to <32 x i32>
; CHECK-NEXT:    [[TMP13:%.*]] = call <32 x i32> @llvm.hexagon.V6.valignb.128B(<32 x i32> [[TMP12]], <32 x i32> [[TMP5]], i32 [[TMP3]])
; CHECK-NEXT:    [[TMP14:%.*]] = bitcast <128 x i8> [[TMP8]] to <32 x i32>
; CHECK-NEXT:    [[TMP15:%.*]] = call <32 x i32> @llvm.hexagon.V6.valignb.128B(<32 x i32> [[TMP11]], <32 x i32> [[TMP14]], i32 [[TMP3]])
; CHECK-NEXT:    [[TMP16:%.*]] = bitcast <32 x i32> [[TMP13]] to <64 x i16>
; CHECK-NEXT:    [[TMP17:%.*]] = bitcast <32 x i32> [[TMP15]] to <64 x i16>
; CHECK-NEXT:    [[V8:%.*]] = add <64 x i16> [[TMP16]], [[TMP17]]
; CHECK-NEXT:    ret <64 x i16> [[V8]]
;
b0:
  %v0 = add i32 %a1, 64
  %v1 = getelementptr i16, i16* %a0, i32 %v0
  %v2 = bitcast i16* %v1 to <64 x i16>*
  %v3 = load <64 x i16>, <64 x i16>* %v2, align 2, !tbaa !0
  %v4 = add i32 %a1, 128
  %v5 = getelementptr i16, i16* %a0, i32 %v4
  %v6 = bitcast i16* %v5 to <64 x i16>*
  %v7 = load <64 x i16>, <64 x i16>* %v6, align 2
  %v8 = add <64 x i16> %v3, %v7
  ret <64 x i16> %v8
}

; Two unaligned loads, with different TBAA tags.
;
define <64 x i16> @f2(i16* %a0, i32 %a1) #0 {
; CHECK-LABEL: @f2(
; CHECK-NEXT:  b0:
; CHECK-NEXT:    [[V0:%.*]] = add i32 [[A1:%.*]], 64
; CHECK-NEXT:    [[V1:%.*]] = getelementptr i16, i16* [[A0:%.*]], i32 [[V0]]
; CHECK-NEXT:    [[TMP0:%.*]] = ptrtoint i16* [[V1]] to i32
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 [[TMP0]], -128
; CHECK-NEXT:    [[TMP2:%.*]] = inttoptr i32 [[TMP1]] to <64 x i16>*
; CHECK-NEXT:    [[TMP3:%.*]] = ptrtoint i16* [[V1]] to i32
; CHECK-NEXT:    [[TMP4:%.*]] = inttoptr i32 [[TMP1]] to <32 x i32>*
; CHECK-NEXT:    [[TMP5:%.*]] = load <32 x i32>, <32 x i32>* [[TMP4]], align 128, !tbaa [[TBAA0]]
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr <64 x i16>, <64 x i16>* [[TMP2]], i32 1
; CHECK-NEXT:    [[TMP7:%.*]] = bitcast <64 x i16>* [[TMP6]] to <128 x i8>*
; CHECK-NEXT:    [[TMP8:%.*]] = load <128 x i8>, <128 x i8>* [[TMP7]], align 128
; CHECK-NEXT:    [[TMP9:%.*]] = getelementptr <64 x i16>, <64 x i16>* [[TMP2]], i32 2
; CHECK-NEXT:    [[TMP10:%.*]] = bitcast <64 x i16>* [[TMP9]] to <32 x i32>*
; CHECK-NEXT:    [[TMP11:%.*]] = load <32 x i32>, <32 x i32>* [[TMP10]], align 128, !tbaa [[TBAA3:![0-9]+]]
; CHECK-NEXT:    [[TMP12:%.*]] = bitcast <128 x i8> [[TMP8]] to <32 x i32>
; CHECK-NEXT:    [[TMP13:%.*]] = call <32 x i32> @llvm.hexagon.V6.valignb.128B(<32 x i32> [[TMP12]], <32 x i32> [[TMP5]], i32 [[TMP3]])
; CHECK-NEXT:    [[TMP14:%.*]] = bitcast <128 x i8> [[TMP8]] to <32 x i32>
; CHECK-NEXT:    [[TMP15:%.*]] = call <32 x i32> @llvm.hexagon.V6.valignb.128B(<32 x i32> [[TMP11]], <32 x i32> [[TMP14]], i32 [[TMP3]])
; CHECK-NEXT:    [[TMP16:%.*]] = bitcast <32 x i32> [[TMP13]] to <64 x i16>
; CHECK-NEXT:    [[TMP17:%.*]] = bitcast <32 x i32> [[TMP15]] to <64 x i16>
; CHECK-NEXT:    [[V8:%.*]] = add <64 x i16> [[TMP16]], [[TMP17]]
; CHECK-NEXT:    ret <64 x i16> [[V8]]
;
b0:
  %v0 = add i32 %a1, 64
  %v1 = getelementptr i16, i16* %a0, i32 %v0
  %v2 = bitcast i16* %v1 to <64 x i16>*
  %v3 = load <64 x i16>, <64 x i16>* %v2, align 2, !tbaa !0
  %v4 = add i32 %a1, 128
  %v5 = getelementptr i16, i16* %a0, i32 %v4
  %v6 = bitcast i16* %v5 to <64 x i16>*
  %v7 = load <64 x i16>, <64 x i16>* %v6, align 2, !tbaa !3
  %v8 = add <64 x i16> %v3, %v7
  ret <64 x i16> %v8
}

; Two unaligned stores, both with the same TBAA tag.
;
define void @f3(i16* %a0, i32 %a1, <64 x i16> %a2, <64 x i16> %a3) #0 {
; CHECK-LABEL: @f3(
; CHECK-NEXT:  b0:
; CHECK-NEXT:    [[V0:%.*]] = add i32 [[A1:%.*]], 64
; CHECK-NEXT:    [[V1:%.*]] = getelementptr i16, i16* [[A0:%.*]], i32 [[V0]]
; CHECK-NEXT:    [[TMP0:%.*]] = ptrtoint i16* [[V1]] to i32
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 [[TMP0]], -128
; CHECK-NEXT:    [[TMP2:%.*]] = inttoptr i32 [[TMP1]] to <64 x i16>*
; CHECK-NEXT:    [[TMP3:%.*]] = ptrtoint i16* [[V1]] to i32
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast <64 x i16> [[A2:%.*]] to <32 x i32>
; CHECK-NEXT:    [[TMP5:%.*]] = call <32 x i32> @llvm.hexagon.V6.vlalignb.128B(<32 x i32> [[TMP4]], <32 x i32> undef, i32 [[TMP3]])
; CHECK-NEXT:    [[TMP6:%.*]] = bitcast <32 x i32> [[TMP5]] to <128 x i8>
; CHECK-NEXT:    [[TMP7:%.*]] = call <32 x i32> @llvm.hexagon.V6.vlalignb.128B(<32 x i32> <i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1>, <32 x i32> zeroinitializer, i32 [[TMP3]])
; CHECK-NEXT:    [[TMP8:%.*]] = bitcast <32 x i32> [[TMP7]] to <128 x i8>
; CHECK-NEXT:    [[TMP9:%.*]] = bitcast <64 x i16> [[A3:%.*]] to <32 x i32>
; CHECK-NEXT:    [[TMP10:%.*]] = bitcast <64 x i16> [[A2]] to <32 x i32>
; CHECK-NEXT:    [[TMP11:%.*]] = call <32 x i32> @llvm.hexagon.V6.vlalignb.128B(<32 x i32> [[TMP9]], <32 x i32> [[TMP10]], i32 [[TMP3]])
; CHECK-NEXT:    [[TMP12:%.*]] = bitcast <32 x i32> [[TMP11]] to <128 x i8>
; CHECK-NEXT:    [[TMP13:%.*]] = call <32 x i32> @llvm.hexagon.V6.vlalignb.128B(<32 x i32> <i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1>, <32 x i32> <i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1>, i32 [[TMP3]])
; CHECK-NEXT:    [[TMP14:%.*]] = bitcast <32 x i32> [[TMP13]] to <128 x i8>
; CHECK-NEXT:    [[TMP15:%.*]] = bitcast <64 x i16> [[A3]] to <32 x i32>
; CHECK-NEXT:    [[TMP16:%.*]] = call <32 x i32> @llvm.hexagon.V6.vlalignb.128B(<32 x i32> undef, <32 x i32> [[TMP15]], i32 [[TMP3]])
; CHECK-NEXT:    [[TMP17:%.*]] = bitcast <32 x i32> [[TMP16]] to <128 x i8>
; CHECK-NEXT:    [[TMP18:%.*]] = call <32 x i32> @llvm.hexagon.V6.vlalignb.128B(<32 x i32> zeroinitializer, <32 x i32> <i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1>, i32 [[TMP3]])
; CHECK-NEXT:    [[TMP19:%.*]] = bitcast <32 x i32> [[TMP18]] to <128 x i8>
; CHECK-NEXT:    [[TMP20:%.*]] = inttoptr i32 [[TMP1]] to <128 x i8>*
; CHECK-NEXT:    [[TMP21:%.*]] = trunc <128 x i8> [[TMP8]] to <128 x i1>
; CHECK-NEXT:    call void @llvm.masked.store.v128i8.p0v128i8(<128 x i8> [[TMP6]], <128 x i8>* [[TMP20]], i32 128, <128 x i1> [[TMP21]]), !tbaa [[TBAA5:![0-9]+]]
; CHECK-NEXT:    [[TMP22:%.*]] = getelementptr <64 x i16>, <64 x i16>* [[TMP2]], i32 1
; CHECK-NEXT:    [[TMP23:%.*]] = bitcast <64 x i16>* [[TMP22]] to <128 x i8>*
; CHECK-NEXT:    [[TMP24:%.*]] = trunc <128 x i8> [[TMP14]] to <128 x i1>
; CHECK-NEXT:    call void @llvm.masked.store.v128i8.p0v128i8(<128 x i8> [[TMP12]], <128 x i8>* [[TMP23]], i32 128, <128 x i1> [[TMP24]]), !tbaa [[TBAA5]]
; CHECK-NEXT:    [[TMP25:%.*]] = getelementptr <64 x i16>, <64 x i16>* [[TMP2]], i32 2
; CHECK-NEXT:    [[TMP26:%.*]] = bitcast <64 x i16>* [[TMP25]] to <128 x i8>*
; CHECK-NEXT:    [[TMP27:%.*]] = trunc <128 x i8> [[TMP19]] to <128 x i1>
; CHECK-NEXT:    call void @llvm.masked.store.v128i8.p0v128i8(<128 x i8> [[TMP17]], <128 x i8>* [[TMP26]], i32 128, <128 x i1> [[TMP27]]), !tbaa [[TBAA5]]
; CHECK-NEXT:    ret void
;
b0:
  %v0 = add i32 %a1, 64
  %v1 = getelementptr i16, i16* %a0, i32 %v0
  %v2 = bitcast i16* %v1 to <64 x i16>*
  store <64 x i16> %a2, <64 x i16>* %v2, align 2, !tbaa !5
  %v3 = add i32 %a1, 128
  %v4 = getelementptr i16, i16* %a0, i32 %v3
  %v5 = bitcast i16* %v4 to <64 x i16>*
  store <64 x i16> %a3, <64 x i16>* %v5, align 2, !tbaa !5
  ret void
}

; Two unaligned stores, only one with a TBAA tag.
;
define void @f4(i16* %a0, i32 %a1, <64 x i16> %a2, <64 x i16> %a3) #0 {
; CHECK-LABEL: @f4(
; CHECK-NEXT:  b0:
; CHECK-NEXT:    [[V0:%.*]] = add i32 [[A1:%.*]], 64
; CHECK-NEXT:    [[V1:%.*]] = getelementptr i16, i16* [[A0:%.*]], i32 [[V0]]
; CHECK-NEXT:    [[TMP0:%.*]] = ptrtoint i16* [[V1]] to i32
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 [[TMP0]], -128
; CHECK-NEXT:    [[TMP2:%.*]] = inttoptr i32 [[TMP1]] to <64 x i16>*
; CHECK-NEXT:    [[TMP3:%.*]] = ptrtoint i16* [[V1]] to i32
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast <64 x i16> [[A2:%.*]] to <32 x i32>
; CHECK-NEXT:    [[TMP5:%.*]] = call <32 x i32> @llvm.hexagon.V6.vlalignb.128B(<32 x i32> [[TMP4]], <32 x i32> undef, i32 [[TMP3]])
; CHECK-NEXT:    [[TMP6:%.*]] = bitcast <32 x i32> [[TMP5]] to <128 x i8>
; CHECK-NEXT:    [[TMP7:%.*]] = call <32 x i32> @llvm.hexagon.V6.vlalignb.128B(<32 x i32> <i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1>, <32 x i32> zeroinitializer, i32 [[TMP3]])
; CHECK-NEXT:    [[TMP8:%.*]] = bitcast <32 x i32> [[TMP7]] to <128 x i8>
; CHECK-NEXT:    [[TMP9:%.*]] = bitcast <64 x i16> [[A3:%.*]] to <32 x i32>
; CHECK-NEXT:    [[TMP10:%.*]] = bitcast <64 x i16> [[A2]] to <32 x i32>
; CHECK-NEXT:    [[TMP11:%.*]] = call <32 x i32> @llvm.hexagon.V6.vlalignb.128B(<32 x i32> [[TMP9]], <32 x i32> [[TMP10]], i32 [[TMP3]])
; CHECK-NEXT:    [[TMP12:%.*]] = bitcast <32 x i32> [[TMP11]] to <128 x i8>
; CHECK-NEXT:    [[TMP13:%.*]] = call <32 x i32> @llvm.hexagon.V6.vlalignb.128B(<32 x i32> <i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1>, <32 x i32> <i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1>, i32 [[TMP3]])
; CHECK-NEXT:    [[TMP14:%.*]] = bitcast <32 x i32> [[TMP13]] to <128 x i8>
; CHECK-NEXT:    [[TMP15:%.*]] = bitcast <64 x i16> [[A3]] to <32 x i32>
; CHECK-NEXT:    [[TMP16:%.*]] = call <32 x i32> @llvm.hexagon.V6.vlalignb.128B(<32 x i32> undef, <32 x i32> [[TMP15]], i32 [[TMP3]])
; CHECK-NEXT:    [[TMP17:%.*]] = bitcast <32 x i32> [[TMP16]] to <128 x i8>
; CHECK-NEXT:    [[TMP18:%.*]] = call <32 x i32> @llvm.hexagon.V6.vlalignb.128B(<32 x i32> zeroinitializer, <32 x i32> <i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1>, i32 [[TMP3]])
; CHECK-NEXT:    [[TMP19:%.*]] = bitcast <32 x i32> [[TMP18]] to <128 x i8>
; CHECK-NEXT:    [[TMP20:%.*]] = inttoptr i32 [[TMP1]] to <128 x i8>*
; CHECK-NEXT:    [[TMP21:%.*]] = trunc <128 x i8> [[TMP8]] to <128 x i1>
; CHECK-NEXT:    call void @llvm.masked.store.v128i8.p0v128i8(<128 x i8> [[TMP6]], <128 x i8>* [[TMP20]], i32 128, <128 x i1> [[TMP21]])
; CHECK-NEXT:    [[TMP22:%.*]] = getelementptr <64 x i16>, <64 x i16>* [[TMP2]], i32 1
; CHECK-NEXT:    [[TMP23:%.*]] = bitcast <64 x i16>* [[TMP22]] to <128 x i8>*
; CHECK-NEXT:    [[TMP24:%.*]] = trunc <128 x i8> [[TMP14]] to <128 x i1>
; CHECK-NEXT:    call void @llvm.masked.store.v128i8.p0v128i8(<128 x i8> [[TMP12]], <128 x i8>* [[TMP23]], i32 128, <128 x i1> [[TMP24]])
; CHECK-NEXT:    [[TMP25:%.*]] = getelementptr <64 x i16>, <64 x i16>* [[TMP2]], i32 2
; CHECK-NEXT:    [[TMP26:%.*]] = bitcast <64 x i16>* [[TMP25]] to <128 x i8>*
; CHECK-NEXT:    [[TMP27:%.*]] = trunc <128 x i8> [[TMP19]] to <128 x i1>
; CHECK-NEXT:    call void @llvm.masked.store.v128i8.p0v128i8(<128 x i8> [[TMP17]], <128 x i8>* [[TMP26]], i32 128, <128 x i1> [[TMP27]]), !tbaa [[TBAA5]]
; CHECK-NEXT:    ret void
;
b0:
  %v0 = add i32 %a1, 64
  %v1 = getelementptr i16, i16* %a0, i32 %v0
  %v2 = bitcast i16* %v1 to <64 x i16>*
  store <64 x i16> %a2, <64 x i16>* %v2, align 2
  %v3 = add i32 %a1, 128
  %v4 = getelementptr i16, i16* %a0, i32 %v3
  %v5 = bitcast i16* %v4 to <64 x i16>*
  store <64 x i16> %a3, <64 x i16>* %v5, align 2, !tbaa !5
  ret void
}

; Two unaligned store, with different TBAA tags.
;
define void @f5(i16* %a0, i32 %a1, <64 x i16> %a2, <64 x i16> %a3) #0 {
; CHECK-LABEL: @f5(
; CHECK-NEXT:  b0:
; CHECK-NEXT:    [[V0:%.*]] = add i32 [[A1:%.*]], 64
; CHECK-NEXT:    [[V1:%.*]] = getelementptr i16, i16* [[A0:%.*]], i32 [[V0]]
; CHECK-NEXT:    [[TMP0:%.*]] = ptrtoint i16* [[V1]] to i32
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 [[TMP0]], -128
; CHECK-NEXT:    [[TMP2:%.*]] = inttoptr i32 [[TMP1]] to <64 x i16>*
; CHECK-NEXT:    [[TMP3:%.*]] = ptrtoint i16* [[V1]] to i32
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast <64 x i16> [[A2:%.*]] to <32 x i32>
; CHECK-NEXT:    [[TMP5:%.*]] = call <32 x i32> @llvm.hexagon.V6.vlalignb.128B(<32 x i32> [[TMP4]], <32 x i32> undef, i32 [[TMP3]])
; CHECK-NEXT:    [[TMP6:%.*]] = bitcast <32 x i32> [[TMP5]] to <128 x i8>
; CHECK-NEXT:    [[TMP7:%.*]] = call <32 x i32> @llvm.hexagon.V6.vlalignb.128B(<32 x i32> <i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1>, <32 x i32> zeroinitializer, i32 [[TMP3]])
; CHECK-NEXT:    [[TMP8:%.*]] = bitcast <32 x i32> [[TMP7]] to <128 x i8>
; CHECK-NEXT:    [[TMP9:%.*]] = bitcast <64 x i16> [[A3:%.*]] to <32 x i32>
; CHECK-NEXT:    [[TMP10:%.*]] = bitcast <64 x i16> [[A2]] to <32 x i32>
; CHECK-NEXT:    [[TMP11:%.*]] = call <32 x i32> @llvm.hexagon.V6.vlalignb.128B(<32 x i32> [[TMP9]], <32 x i32> [[TMP10]], i32 [[TMP3]])
; CHECK-NEXT:    [[TMP12:%.*]] = bitcast <32 x i32> [[TMP11]] to <128 x i8>
; CHECK-NEXT:    [[TMP13:%.*]] = call <32 x i32> @llvm.hexagon.V6.vlalignb.128B(<32 x i32> <i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1>, <32 x i32> <i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1>, i32 [[TMP3]])
; CHECK-NEXT:    [[TMP14:%.*]] = bitcast <32 x i32> [[TMP13]] to <128 x i8>
; CHECK-NEXT:    [[TMP15:%.*]] = bitcast <64 x i16> [[A3]] to <32 x i32>
; CHECK-NEXT:    [[TMP16:%.*]] = call <32 x i32> @llvm.hexagon.V6.vlalignb.128B(<32 x i32> undef, <32 x i32> [[TMP15]], i32 [[TMP3]])
; CHECK-NEXT:    [[TMP17:%.*]] = bitcast <32 x i32> [[TMP16]] to <128 x i8>
; CHECK-NEXT:    [[TMP18:%.*]] = call <32 x i32> @llvm.hexagon.V6.vlalignb.128B(<32 x i32> zeroinitializer, <32 x i32> <i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1>, i32 [[TMP3]])
; CHECK-NEXT:    [[TMP19:%.*]] = bitcast <32 x i32> [[TMP18]] to <128 x i8>
; CHECK-NEXT:    [[TMP20:%.*]] = inttoptr i32 [[TMP1]] to <128 x i8>*
; CHECK-NEXT:    [[TMP21:%.*]] = trunc <128 x i8> [[TMP8]] to <128 x i1>
; CHECK-NEXT:    call void @llvm.masked.store.v128i8.p0v128i8(<128 x i8> [[TMP6]], <128 x i8>* [[TMP20]], i32 128, <128 x i1> [[TMP21]]), !tbaa [[TBAA5]]
; CHECK-NEXT:    [[TMP22:%.*]] = getelementptr <64 x i16>, <64 x i16>* [[TMP2]], i32 1
; CHECK-NEXT:    [[TMP23:%.*]] = bitcast <64 x i16>* [[TMP22]] to <128 x i8>*
; CHECK-NEXT:    [[TMP24:%.*]] = trunc <128 x i8> [[TMP14]] to <128 x i1>
; CHECK-NEXT:    call void @llvm.masked.store.v128i8.p0v128i8(<128 x i8> [[TMP12]], <128 x i8>* [[TMP23]], i32 128, <128 x i1> [[TMP24]])
; CHECK-NEXT:    [[TMP25:%.*]] = getelementptr <64 x i16>, <64 x i16>* [[TMP2]], i32 2
; CHECK-NEXT:    [[TMP26:%.*]] = bitcast <64 x i16>* [[TMP25]] to <128 x i8>*
; CHECK-NEXT:    [[TMP27:%.*]] = trunc <128 x i8> [[TMP19]] to <128 x i1>
; CHECK-NEXT:    call void @llvm.masked.store.v128i8.p0v128i8(<128 x i8> [[TMP17]], <128 x i8>* [[TMP26]], i32 128, <128 x i1> [[TMP27]]), !tbaa [[TBAA7:![0-9]+]]
; CHECK-NEXT:    ret void
;
b0:
  %v0 = add i32 %a1, 64
  %v1 = getelementptr i16, i16* %a0, i32 %v0
  %v2 = bitcast i16* %v1 to <64 x i16>*
  store <64 x i16> %a2, <64 x i16>* %v2, align 2, !tbaa !5
  %v3 = add i32 %a1, 128
  %v4 = getelementptr i16, i16* %a0, i32 %v3
  %v5 = bitcast i16* %v4 to <64 x i16>*
  store <64 x i16> %a3, <64 x i16>* %v5, align 2, !tbaa !7
  ret void
}

attributes #0 = { nounwind "target-cpu"="hexagonv66" "target-features"="+hvx,+hvx-length128b" }

!0 = !{!1, !1, i64 0}
!1 = !{!"load type 1", !2}
!2 = !{!"Simple C/C++ TBAA"}
!3 = !{!4, !4, i64 0}
!4 = !{!"load type 2", !2}
!5 = !{!6, !6, i64 0}
!6 = !{!"store type 1", !2}
!7 = !{!8, !8, i64 0}
!8 = !{!"store type 2", !2}
