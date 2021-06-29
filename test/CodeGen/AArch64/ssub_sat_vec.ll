; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64-- | FileCheck %s

declare <1 x i8> @llvm.ssub.sat.v1i8(<1 x i8>, <1 x i8>)
declare <2 x i8> @llvm.ssub.sat.v2i8(<2 x i8>, <2 x i8>)
declare <4 x i8> @llvm.ssub.sat.v4i8(<4 x i8>, <4 x i8>)
declare <8 x i8> @llvm.ssub.sat.v8i8(<8 x i8>, <8 x i8>)
declare <12 x i8> @llvm.ssub.sat.v12i8(<12 x i8>, <12 x i8>)
declare <16 x i8> @llvm.ssub.sat.v16i8(<16 x i8>, <16 x i8>)
declare <32 x i8> @llvm.ssub.sat.v32i8(<32 x i8>, <32 x i8>)
declare <64 x i8> @llvm.ssub.sat.v64i8(<64 x i8>, <64 x i8>)

declare <1 x i16> @llvm.ssub.sat.v1i16(<1 x i16>, <1 x i16>)
declare <2 x i16> @llvm.ssub.sat.v2i16(<2 x i16>, <2 x i16>)
declare <4 x i16> @llvm.ssub.sat.v4i16(<4 x i16>, <4 x i16>)
declare <8 x i16> @llvm.ssub.sat.v8i16(<8 x i16>, <8 x i16>)
declare <12 x i16> @llvm.ssub.sat.v12i16(<12 x i16>, <12 x i16>)
declare <16 x i16> @llvm.ssub.sat.v16i16(<16 x i16>, <16 x i16>)
declare <32 x i16> @llvm.ssub.sat.v32i16(<32 x i16>, <32 x i16>)

declare <16 x i1> @llvm.ssub.sat.v16i1(<16 x i1>, <16 x i1>)
declare <16 x i4> @llvm.ssub.sat.v16i4(<16 x i4>, <16 x i4>)

declare <2 x i32> @llvm.ssub.sat.v2i32(<2 x i32>, <2 x i32>)
declare <4 x i32> @llvm.ssub.sat.v4i32(<4 x i32>, <4 x i32>)
declare <8 x i32> @llvm.ssub.sat.v8i32(<8 x i32>, <8 x i32>)
declare <16 x i32> @llvm.ssub.sat.v16i32(<16 x i32>, <16 x i32>)
declare <2 x i64> @llvm.ssub.sat.v2i64(<2 x i64>, <2 x i64>)
declare <4 x i64> @llvm.ssub.sat.v4i64(<4 x i64>, <4 x i64>)
declare <8 x i64> @llvm.ssub.sat.v8i64(<8 x i64>, <8 x i64>)

declare <4 x i24> @llvm.ssub.sat.v4i24(<4 x i24>, <4 x i24>)
declare <2 x i128> @llvm.ssub.sat.v2i128(<2 x i128>, <2 x i128>)


define <16 x i8> @v16i8(<16 x i8> %x, <16 x i8> %y) nounwind {
; CHECK-LABEL: v16i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sqsub v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %z = call <16 x i8> @llvm.ssub.sat.v16i8(<16 x i8> %x, <16 x i8> %y)
  ret <16 x i8> %z
}

define <32 x i8> @v32i8(<32 x i8> %x, <32 x i8> %y) nounwind {
; CHECK-LABEL: v32i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sqsub v0.16b, v0.16b, v2.16b
; CHECK-NEXT:    sqsub v1.16b, v1.16b, v3.16b
; CHECK-NEXT:    ret
  %z = call <32 x i8> @llvm.ssub.sat.v32i8(<32 x i8> %x, <32 x i8> %y)
  ret <32 x i8> %z
}

define <64 x i8> @v64i8(<64 x i8> %x, <64 x i8> %y) nounwind {
; CHECK-LABEL: v64i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sqsub v0.16b, v0.16b, v4.16b
; CHECK-NEXT:    sqsub v1.16b, v1.16b, v5.16b
; CHECK-NEXT:    sqsub v2.16b, v2.16b, v6.16b
; CHECK-NEXT:    sqsub v3.16b, v3.16b, v7.16b
; CHECK-NEXT:    ret
  %z = call <64 x i8> @llvm.ssub.sat.v64i8(<64 x i8> %x, <64 x i8> %y)
  ret <64 x i8> %z
}

define <8 x i16> @v8i16(<8 x i16> %x, <8 x i16> %y) nounwind {
; CHECK-LABEL: v8i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sqsub v0.8h, v0.8h, v1.8h
; CHECK-NEXT:    ret
  %z = call <8 x i16> @llvm.ssub.sat.v8i16(<8 x i16> %x, <8 x i16> %y)
  ret <8 x i16> %z
}

define <16 x i16> @v16i16(<16 x i16> %x, <16 x i16> %y) nounwind {
; CHECK-LABEL: v16i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sqsub v0.8h, v0.8h, v2.8h
; CHECK-NEXT:    sqsub v1.8h, v1.8h, v3.8h
; CHECK-NEXT:    ret
  %z = call <16 x i16> @llvm.ssub.sat.v16i16(<16 x i16> %x, <16 x i16> %y)
  ret <16 x i16> %z
}

define <32 x i16> @v32i16(<32 x i16> %x, <32 x i16> %y) nounwind {
; CHECK-LABEL: v32i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sqsub v0.8h, v0.8h, v4.8h
; CHECK-NEXT:    sqsub v1.8h, v1.8h, v5.8h
; CHECK-NEXT:    sqsub v2.8h, v2.8h, v6.8h
; CHECK-NEXT:    sqsub v3.8h, v3.8h, v7.8h
; CHECK-NEXT:    ret
  %z = call <32 x i16> @llvm.ssub.sat.v32i16(<32 x i16> %x, <32 x i16> %y)
  ret <32 x i16> %z
}

define void @v8i8(<8 x i8>* %px, <8 x i8>* %py, <8 x i8>* %pz) nounwind {
; CHECK-LABEL: v8i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr d0, [x0]
; CHECK-NEXT:    ldr d1, [x1]
; CHECK-NEXT:    sqsub v0.8b, v0.8b, v1.8b
; CHECK-NEXT:    str d0, [x2]
; CHECK-NEXT:    ret
  %x = load <8 x i8>, <8 x i8>* %px
  %y = load <8 x i8>, <8 x i8>* %py
  %z = call <8 x i8> @llvm.ssub.sat.v8i8(<8 x i8> %x, <8 x i8> %y)
  store <8 x i8> %z, <8 x i8>* %pz
  ret void
}

define void @v4i8(<4 x i8>* %px, <4 x i8>* %py, <4 x i8>* %pz) nounwind {
; CHECK-LABEL: v4i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr s0, [x0]
; CHECK-NEXT:    ldr s1, [x1]
; CHECK-NEXT:    sshll v0.8h, v0.8b, #0
; CHECK-NEXT:    sshll v1.8h, v1.8b, #0
; CHECK-NEXT:    shl v1.4h, v1.4h, #8
; CHECK-NEXT:    shl v0.4h, v0.4h, #8
; CHECK-NEXT:    sqsub v0.4h, v0.4h, v1.4h
; CHECK-NEXT:    sshr v0.4h, v0.4h, #8
; CHECK-NEXT:    xtn v0.8b, v0.8h
; CHECK-NEXT:    str s0, [x2]
; CHECK-NEXT:    ret
  %x = load <4 x i8>, <4 x i8>* %px
  %y = load <4 x i8>, <4 x i8>* %py
  %z = call <4 x i8> @llvm.ssub.sat.v4i8(<4 x i8> %x, <4 x i8> %y)
  store <4 x i8> %z, <4 x i8>* %pz
  ret void
}

define void @v2i8(<2 x i8>* %px, <2 x i8>* %py, <2 x i8>* %pz) nounwind {
; CHECK-LABEL: v2i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ld1 { v0.b }[0], [x1]
; CHECK-NEXT:    ld1 { v1.b }[0], [x0]
; CHECK-NEXT:    add x8, x0, #1 // =1
; CHECK-NEXT:    add x9, x1, #1 // =1
; CHECK-NEXT:    ld1 { v0.b }[4], [x9]
; CHECK-NEXT:    ld1 { v1.b }[4], [x8]
; CHECK-NEXT:    shl v0.2s, v0.2s, #24
; CHECK-NEXT:    shl v1.2s, v1.2s, #24
; CHECK-NEXT:    sqsub v0.2s, v1.2s, v0.2s
; CHECK-NEXT:    ushr v0.2s, v0.2s, #24
; CHECK-NEXT:    mov w8, v0.s[1]
; CHECK-NEXT:    fmov w9, s0
; CHECK-NEXT:    strb w9, [x2]
; CHECK-NEXT:    strb w8, [x2, #1]
; CHECK-NEXT:    ret
  %x = load <2 x i8>, <2 x i8>* %px
  %y = load <2 x i8>, <2 x i8>* %py
  %z = call <2 x i8> @llvm.ssub.sat.v2i8(<2 x i8> %x, <2 x i8> %y)
  store <2 x i8> %z, <2 x i8>* %pz
  ret void
}

define void @v4i16(<4 x i16>* %px, <4 x i16>* %py, <4 x i16>* %pz) nounwind {
; CHECK-LABEL: v4i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr d0, [x0]
; CHECK-NEXT:    ldr d1, [x1]
; CHECK-NEXT:    sqsub v0.4h, v0.4h, v1.4h
; CHECK-NEXT:    str d0, [x2]
; CHECK-NEXT:    ret
  %x = load <4 x i16>, <4 x i16>* %px
  %y = load <4 x i16>, <4 x i16>* %py
  %z = call <4 x i16> @llvm.ssub.sat.v4i16(<4 x i16> %x, <4 x i16> %y)
  store <4 x i16> %z, <4 x i16>* %pz
  ret void
}

define void @v2i16(<2 x i16>* %px, <2 x i16>* %py, <2 x i16>* %pz) nounwind {
; CHECK-LABEL: v2i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ld1 { v0.h }[0], [x1]
; CHECK-NEXT:    ld1 { v1.h }[0], [x0]
; CHECK-NEXT:    add x8, x0, #2 // =2
; CHECK-NEXT:    add x9, x1, #2 // =2
; CHECK-NEXT:    ld1 { v0.h }[2], [x9]
; CHECK-NEXT:    ld1 { v1.h }[2], [x8]
; CHECK-NEXT:    shl v0.2s, v0.2s, #16
; CHECK-NEXT:    shl v1.2s, v1.2s, #16
; CHECK-NEXT:    sqsub v0.2s, v1.2s, v0.2s
; CHECK-NEXT:    ushr v0.2s, v0.2s, #16
; CHECK-NEXT:    mov w8, v0.s[1]
; CHECK-NEXT:    fmov w9, s0
; CHECK-NEXT:    strh w9, [x2]
; CHECK-NEXT:    strh w8, [x2, #2]
; CHECK-NEXT:    ret
  %x = load <2 x i16>, <2 x i16>* %px
  %y = load <2 x i16>, <2 x i16>* %py
  %z = call <2 x i16> @llvm.ssub.sat.v2i16(<2 x i16> %x, <2 x i16> %y)
  store <2 x i16> %z, <2 x i16>* %pz
  ret void
}

define <12 x i8> @v12i8(<12 x i8> %x, <12 x i8> %y) nounwind {
; CHECK-LABEL: v12i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sqsub v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %z = call <12 x i8> @llvm.ssub.sat.v12i8(<12 x i8> %x, <12 x i8> %y)
  ret <12 x i8> %z
}

define void @v12i16(<12 x i16>* %px, <12 x i16>* %py, <12 x i16>* %pz) nounwind {
; CHECK-LABEL: v12i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldp q0, q1, [x0]
; CHECK-NEXT:    ldp q3, q2, [x1]
; CHECK-NEXT:    sqsub v1.8h, v1.8h, v2.8h
; CHECK-NEXT:    sqsub v0.8h, v0.8h, v3.8h
; CHECK-NEXT:    str q0, [x2]
; CHECK-NEXT:    str d1, [x2, #16]
; CHECK-NEXT:    ret
  %x = load <12 x i16>, <12 x i16>* %px
  %y = load <12 x i16>, <12 x i16>* %py
  %z = call <12 x i16> @llvm.ssub.sat.v12i16(<12 x i16> %x, <12 x i16> %y)
  store <12 x i16> %z, <12 x i16>* %pz
  ret void
}

define void @v1i8(<1 x i8>* %px, <1 x i8>* %py, <1 x i8>* %pz) nounwind {
; CHECK-LABEL: v1i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr b0, [x0]
; CHECK-NEXT:    ldr b1, [x1]
; CHECK-NEXT:    sqsub v0.8b, v0.8b, v1.8b
; CHECK-NEXT:    st1 { v0.b }[0], [x2]
; CHECK-NEXT:    ret
  %x = load <1 x i8>, <1 x i8>* %px
  %y = load <1 x i8>, <1 x i8>* %py
  %z = call <1 x i8> @llvm.ssub.sat.v1i8(<1 x i8> %x, <1 x i8> %y)
  store <1 x i8> %z, <1 x i8>* %pz
  ret void
}

define void @v1i16(<1 x i16>* %px, <1 x i16>* %py, <1 x i16>* %pz) nounwind {
; CHECK-LABEL: v1i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr h0, [x0]
; CHECK-NEXT:    ldr h1, [x1]
; CHECK-NEXT:    sqsub v0.4h, v0.4h, v1.4h
; CHECK-NEXT:    str h0, [x2]
; CHECK-NEXT:    ret
  %x = load <1 x i16>, <1 x i16>* %px
  %y = load <1 x i16>, <1 x i16>* %py
  %z = call <1 x i16> @llvm.ssub.sat.v1i16(<1 x i16> %x, <1 x i16> %y)
  store <1 x i16> %z, <1 x i16>* %pz
  ret void
}

define <16 x i4> @v16i4(<16 x i4> %x, <16 x i4> %y) nounwind {
; CHECK-LABEL: v16i4:
; CHECK:       // %bb.0:
; CHECK-NEXT:    shl v0.16b, v0.16b, #4
; CHECK-NEXT:    shl v1.16b, v1.16b, #4
; CHECK-NEXT:    sshr v0.16b, v0.16b, #4
; CHECK-NEXT:    sshr v1.16b, v1.16b, #4
; CHECK-NEXT:    shl v1.16b, v1.16b, #4
; CHECK-NEXT:    shl v0.16b, v0.16b, #4
; CHECK-NEXT:    sqsub v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    sshr v0.16b, v0.16b, #4
; CHECK-NEXT:    ret
  %z = call <16 x i4> @llvm.ssub.sat.v16i4(<16 x i4> %x, <16 x i4> %y)
  ret <16 x i4> %z
}

define <16 x i1> @v16i1(<16 x i1> %x, <16 x i1> %y) nounwind {
; CHECK-LABEL: v16i1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v2.16b, #1
; CHECK-NEXT:    eor v1.16b, v1.16b, v2.16b
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %z = call <16 x i1> @llvm.ssub.sat.v16i1(<16 x i1> %x, <16 x i1> %y)
  ret <16 x i1> %z
}

define <2 x i32> @v2i32(<2 x i32> %x, <2 x i32> %y) nounwind {
; CHECK-LABEL: v2i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sqsub v0.2s, v0.2s, v1.2s
; CHECK-NEXT:    ret
  %z = call <2 x i32> @llvm.ssub.sat.v2i32(<2 x i32> %x, <2 x i32> %y)
  ret <2 x i32> %z
}

define <4 x i32> @v4i32(<4 x i32> %x, <4 x i32> %y) nounwind {
; CHECK-LABEL: v4i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sqsub v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    ret
  %z = call <4 x i32> @llvm.ssub.sat.v4i32(<4 x i32> %x, <4 x i32> %y)
  ret <4 x i32> %z
}

define <8 x i32> @v8i32(<8 x i32> %x, <8 x i32> %y) nounwind {
; CHECK-LABEL: v8i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sqsub v0.4s, v0.4s, v2.4s
; CHECK-NEXT:    sqsub v1.4s, v1.4s, v3.4s
; CHECK-NEXT:    ret
  %z = call <8 x i32> @llvm.ssub.sat.v8i32(<8 x i32> %x, <8 x i32> %y)
  ret <8 x i32> %z
}

define <16 x i32> @v16i32(<16 x i32> %x, <16 x i32> %y) nounwind {
; CHECK-LABEL: v16i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sqsub v0.4s, v0.4s, v4.4s
; CHECK-NEXT:    sqsub v1.4s, v1.4s, v5.4s
; CHECK-NEXT:    sqsub v2.4s, v2.4s, v6.4s
; CHECK-NEXT:    sqsub v3.4s, v3.4s, v7.4s
; CHECK-NEXT:    ret
  %z = call <16 x i32> @llvm.ssub.sat.v16i32(<16 x i32> %x, <16 x i32> %y)
  ret <16 x i32> %z
}

define <2 x i64> @v2i64(<2 x i64> %x, <2 x i64> %y) nounwind {
; CHECK-LABEL: v2i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sqsub v0.2d, v0.2d, v1.2d
; CHECK-NEXT:    ret
  %z = call <2 x i64> @llvm.ssub.sat.v2i64(<2 x i64> %x, <2 x i64> %y)
  ret <2 x i64> %z
}

define <4 x i64> @v4i64(<4 x i64> %x, <4 x i64> %y) nounwind {
; CHECK-LABEL: v4i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sqsub v0.2d, v0.2d, v2.2d
; CHECK-NEXT:    sqsub v1.2d, v1.2d, v3.2d
; CHECK-NEXT:    ret
  %z = call <4 x i64> @llvm.ssub.sat.v4i64(<4 x i64> %x, <4 x i64> %y)
  ret <4 x i64> %z
}

define <8 x i64> @v8i64(<8 x i64> %x, <8 x i64> %y) nounwind {
; CHECK-LABEL: v8i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sqsub v0.2d, v0.2d, v4.2d
; CHECK-NEXT:    sqsub v1.2d, v1.2d, v5.2d
; CHECK-NEXT:    sqsub v2.2d, v2.2d, v6.2d
; CHECK-NEXT:    sqsub v3.2d, v3.2d, v7.2d
; CHECK-NEXT:    ret
  %z = call <8 x i64> @llvm.ssub.sat.v8i64(<8 x i64> %x, <8 x i64> %y)
  ret <8 x i64> %z
}

define <2 x i128> @v2i128(<2 x i128> %x, <2 x i128> %y) nounwind {
; CHECK-LABEL: v2i128:
; CHECK:       // %bb.0:
; CHECK-NEXT:    subs x8, x2, x6
; CHECK-NEXT:    sbcs x12, x3, x7
; CHECK-NEXT:    mov x9, #9223372036854775807
; CHECK-NEXT:    eor x10, x3, x7
; CHECK-NEXT:    cmp x12, #0 // =0
; CHECK-NEXT:    eor x13, x3, x12
; CHECK-NEXT:    cinv x14, x9, ge
; CHECK-NEXT:    tst x10, x13
; CHECK-NEXT:    asr x10, x12, #63
; CHECK-NEXT:    csel x2, x10, x8, lt
; CHECK-NEXT:    csel x3, x14, x12, lt
; CHECK-NEXT:    subs x8, x0, x4
; CHECK-NEXT:    sbcs x10, x1, x5
; CHECK-NEXT:    eor x11, x1, x5
; CHECK-NEXT:    cmp x10, #0 // =0
; CHECK-NEXT:    eor x12, x1, x10
; CHECK-NEXT:    cinv x9, x9, ge
; CHECK-NEXT:    tst x11, x12
; CHECK-NEXT:    asr x11, x10, #63
; CHECK-NEXT:    csel x8, x11, x8, lt
; CHECK-NEXT:    csel x1, x9, x10, lt
; CHECK-NEXT:    fmov d0, x8
; CHECK-NEXT:    mov v0.d[1], x1
; CHECK-NEXT:    fmov x0, d0
; CHECK-NEXT:    ret
  %z = call <2 x i128> @llvm.ssub.sat.v2i128(<2 x i128> %x, <2 x i128> %y)
  ret <2 x i128> %z
}
