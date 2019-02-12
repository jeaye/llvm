; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64-none-linux-gnu -mattr=+neon | FileCheck %s --check-prefix=CHECK

declare <8 x i8> @llvm.cttz.v8i8(<8 x i8>, i1)
declare <4 x i16> @llvm.cttz.v4i16(<4 x i16>, i1)
declare <2 x i32> @llvm.cttz.v2i32(<2 x i32>, i1)
declare <1 x i64> @llvm.cttz.v1i64(<1 x i64>, i1)

declare <16 x i8> @llvm.cttz.v16i8(<16 x i8>, i1)
declare <8 x i16> @llvm.cttz.v8i16(<8 x i16>, i1)
declare <4 x i32> @llvm.cttz.v4i32(<4 x i32>, i1)
declare <2 x i64> @llvm.cttz.v2i64(<2 x i64>, i1)

define <8 x i8> @cttz_v8i8(<8 x i8> %a) nounwind {
; CHECK-LABEL: cttz_v8i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.8b, #1
; CHECK-NEXT:    sub v1.8b, v0.8b, v1.8b
; CHECK-NEXT:    bic v0.8b, v1.8b, v0.8b
; CHECK-NEXT:    cnt v0.8b, v0.8b
; CHECK-NEXT:    ret
    %b = call <8 x i8> @llvm.cttz.v8i8(<8 x i8> %a, i1 true)
    ret <8 x i8> %b
}

define <4 x i16> @cttz_v4i16(<4 x i16> %a) nounwind {
; CHECK-LABEL: cttz_v4i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.4h, #1
; CHECK-NEXT:    sub v1.4h, v0.4h, v1.4h
; CHECK-NEXT:    bic v0.8b, v1.8b, v0.8b
; CHECK-NEXT:    clz v0.4h, v0.4h
; CHECK-NEXT:    movi v1.4h, #16
; CHECK-NEXT:    sub v0.4h, v1.4h, v0.4h
; CHECK-NEXT:    ret
    %b = call <4 x i16> @llvm.cttz.v4i16(<4 x i16> %a, i1 true)
    ret <4 x i16> %b
}

define <2 x i32> @cttz_v2i32(<2 x i32> %a) nounwind {
; CHECK-LABEL: cttz_v2i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.2s, #1
; CHECK-NEXT:    sub v1.2s, v0.2s, v1.2s
; CHECK-NEXT:    bic v0.8b, v1.8b, v0.8b
; CHECK-NEXT:    clz v0.2s, v0.2s
; CHECK-NEXT:    movi v1.2s, #32
; CHECK-NEXT:    sub v0.2s, v1.2s, v0.2s
; CHECK-NEXT:    ret
    %b = call <2 x i32> @llvm.cttz.v2i32(<2 x i32> %a, i1 true)
    ret <2 x i32> %b
}

define <1 x i64> @cttz_v1i64(<1 x i64> %a) nounwind {
; CHECK-LABEL: cttz_v1i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    orr w8, wzr, #0x1
; CHECK-NEXT:    fmov d1, x8
; CHECK-NEXT:    sub d1, d0, d1
; CHECK-NEXT:    bic v0.8b, v1.8b, v0.8b
; CHECK-NEXT:    cnt v0.8b, v0.8b
; CHECK-NEXT:    uaddlp v0.4h, v0.8b
; CHECK-NEXT:    uaddlp v0.2s, v0.4h
; CHECK-NEXT:    uaddlp v0.1d, v0.2s
; CHECK-NEXT:    ret
    %b = call <1 x i64> @llvm.cttz.v1i64(<1 x i64> %a, i1 true)
    ret <1 x i64> %b
}

define <16 x i8> @cttz_v16i8(<16 x i8> %a) nounwind {
; CHECK-LABEL: cttz_v16i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.16b, #1
; CHECK-NEXT:    sub v1.16b, v0.16b, v1.16b
; CHECK-NEXT:    bic v0.16b, v1.16b, v0.16b
; CHECK-NEXT:    cnt v0.16b, v0.16b
; CHECK-NEXT:    ret
    %b = call <16 x i8> @llvm.cttz.v16i8(<16 x i8> %a, i1 true)
    ret <16 x i8> %b
}

define <8 x i16> @cttz_v8i16(<8 x i16> %a) nounwind {
; CHECK-LABEL: cttz_v8i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.8h, #1
; CHECK-NEXT:    sub v1.8h, v0.8h, v1.8h
; CHECK-NEXT:    bic v0.16b, v1.16b, v0.16b
; CHECK-NEXT:    clz v0.8h, v0.8h
; CHECK-NEXT:    movi v1.8h, #16
; CHECK-NEXT:    sub v0.8h, v1.8h, v0.8h
; CHECK-NEXT:    ret
    %b = call <8 x i16> @llvm.cttz.v8i16(<8 x i16> %a, i1 true)
    ret <8 x i16> %b
}

define <4 x i32> @cttz_v4i32(<4 x i32> %a) nounwind {
; CHECK-LABEL: cttz_v4i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.4s, #1
; CHECK-NEXT:    sub v1.4s, v0.4s, v1.4s
; CHECK-NEXT:    bic v0.16b, v1.16b, v0.16b
; CHECK-NEXT:    clz v0.4s, v0.4s
; CHECK-NEXT:    movi v1.4s, #32
; CHECK-NEXT:    sub v0.4s, v1.4s, v0.4s
; CHECK-NEXT:    ret
    %b = call <4 x i32> @llvm.cttz.v4i32(<4 x i32> %a, i1 true)
    ret <4 x i32> %b
}

define <2 x i64> @cttz_v2i64(<2 x i64> %a) nounwind {
; CHECK-LABEL: cttz_v2i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    orr w8, wzr, #0x1
; CHECK-NEXT:    dup v1.2d, x8
; CHECK-NEXT:    sub v1.2d, v0.2d, v1.2d
; CHECK-NEXT:    bic v0.16b, v1.16b, v0.16b
; CHECK-NEXT:    cnt v0.16b, v0.16b
; CHECK-NEXT:    uaddlp v0.8h, v0.16b
; CHECK-NEXT:    uaddlp v0.4s, v0.8h
; CHECK-NEXT:    uaddlp v0.2d, v0.4s
; CHECK-NEXT:    ret
    %b = call <2 x i64> @llvm.cttz.v2i64(<2 x i64> %a, i1 true)
    ret <2 x i64> %b
}
