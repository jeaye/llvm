; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64-- | FileCheck %s

declare <1 x i8> @llvm.sadd.sat.v1i8(<1 x i8>, <1 x i8>)
declare <2 x i8> @llvm.sadd.sat.v2i8(<2 x i8>, <2 x i8>)
declare <4 x i8> @llvm.sadd.sat.v4i8(<4 x i8>, <4 x i8>)
declare <8 x i8> @llvm.sadd.sat.v8i8(<8 x i8>, <8 x i8>)
declare <12 x i8> @llvm.sadd.sat.v12i8(<12 x i8>, <12 x i8>)
declare <16 x i8> @llvm.sadd.sat.v16i8(<16 x i8>, <16 x i8>)
declare <32 x i8> @llvm.sadd.sat.v32i8(<32 x i8>, <32 x i8>)
declare <64 x i8> @llvm.sadd.sat.v64i8(<64 x i8>, <64 x i8>)

declare <1 x i16> @llvm.sadd.sat.v1i16(<1 x i16>, <1 x i16>)
declare <2 x i16> @llvm.sadd.sat.v2i16(<2 x i16>, <2 x i16>)
declare <4 x i16> @llvm.sadd.sat.v4i16(<4 x i16>, <4 x i16>)
declare <8 x i16> @llvm.sadd.sat.v8i16(<8 x i16>, <8 x i16>)
declare <12 x i16> @llvm.sadd.sat.v12i16(<12 x i16>, <12 x i16>)
declare <16 x i16> @llvm.sadd.sat.v16i16(<16 x i16>, <16 x i16>)
declare <32 x i16> @llvm.sadd.sat.v32i16(<32 x i16>, <32 x i16>)

declare <16 x i1> @llvm.sadd.sat.v16i1(<16 x i1>, <16 x i1>)
declare <16 x i4> @llvm.sadd.sat.v16i4(<16 x i4>, <16 x i4>)

declare <2 x i32> @llvm.sadd.sat.v2i32(<2 x i32>, <2 x i32>)
declare <4 x i32> @llvm.sadd.sat.v4i32(<4 x i32>, <4 x i32>)
declare <8 x i32> @llvm.sadd.sat.v8i32(<8 x i32>, <8 x i32>)
declare <16 x i32> @llvm.sadd.sat.v16i32(<16 x i32>, <16 x i32>)
declare <2 x i64> @llvm.sadd.sat.v2i64(<2 x i64>, <2 x i64>)
declare <4 x i64> @llvm.sadd.sat.v4i64(<4 x i64>, <4 x i64>)
declare <8 x i64> @llvm.sadd.sat.v8i64(<8 x i64>, <8 x i64>)

declare <4 x i24> @llvm.sadd.sat.v4i24(<4 x i24>, <4 x i24>)
declare <2 x i128> @llvm.sadd.sat.v2i128(<2 x i128>, <2 x i128>)

define <16 x i8> @v16i8(<16 x i8> %x, <16 x i8> %y) nounwind {
; CHECK-LABEL: v16i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    add v2.16b, v0.16b, v1.16b
; CHECK-NEXT:    cmlt v4.16b, v2.16b, #0
; CHECK-NEXT:    movi v3.16b, #127
; CHECK-NEXT:    cmlt v1.16b, v1.16b, #0
; CHECK-NEXT:    cmgt v0.16b, v0.16b, v2.16b
; CHECK-NEXT:    mvn v5.16b, v4.16b
; CHECK-NEXT:    bsl v3.16b, v4.16b, v5.16b
; CHECK-NEXT:    eor v0.16b, v1.16b, v0.16b
; CHECK-NEXT:    bsl v0.16b, v3.16b, v2.16b
; CHECK-NEXT:    ret
  %z = call <16 x i8> @llvm.sadd.sat.v16i8(<16 x i8> %x, <16 x i8> %y)
  ret <16 x i8> %z
}

define <32 x i8> @v32i8(<32 x i8> %x, <32 x i8> %y) nounwind {
; CHECK-LABEL: v32i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    add v4.16b, v0.16b, v2.16b
; CHECK-NEXT:    cmlt v7.16b, v4.16b, #0
; CHECK-NEXT:    movi v6.16b, #127
; CHECK-NEXT:    mvn v16.16b, v7.16b
; CHECK-NEXT:    bsl v6.16b, v7.16b, v16.16b
; CHECK-NEXT:    add v7.16b, v1.16b, v3.16b
; CHECK-NEXT:    cmlt v2.16b, v2.16b, #0
; CHECK-NEXT:    cmgt v0.16b, v0.16b, v4.16b
; CHECK-NEXT:    cmlt v16.16b, v7.16b, #0
; CHECK-NEXT:    movi v5.16b, #127
; CHECK-NEXT:    cmlt v3.16b, v3.16b, #0
; CHECK-NEXT:    cmgt v1.16b, v1.16b, v7.16b
; CHECK-NEXT:    eor v0.16b, v2.16b, v0.16b
; CHECK-NEXT:    mvn v2.16b, v16.16b
; CHECK-NEXT:    eor v1.16b, v3.16b, v1.16b
; CHECK-NEXT:    bsl v5.16b, v16.16b, v2.16b
; CHECK-NEXT:    bsl v0.16b, v6.16b, v4.16b
; CHECK-NEXT:    bsl v1.16b, v5.16b, v7.16b
; CHECK-NEXT:    ret
  %z = call <32 x i8> @llvm.sadd.sat.v32i8(<32 x i8> %x, <32 x i8> %y)
  ret <32 x i8> %z
}

define <64 x i8> @v64i8(<64 x i8> %x, <64 x i8> %y) nounwind {
; CHECK-LABEL: v64i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    add v16.16b, v0.16b, v4.16b
; CHECK-NEXT:    cmlt v24.16b, v16.16b, #0
; CHECK-NEXT:    movi v18.16b, #127
; CHECK-NEXT:    add v19.16b, v1.16b, v5.16b
; CHECK-NEXT:    mvn v25.16b, v24.16b
; CHECK-NEXT:    bsl v18.16b, v24.16b, v25.16b
; CHECK-NEXT:    cmlt v24.16b, v19.16b, #0
; CHECK-NEXT:    movi v20.16b, #127
; CHECK-NEXT:    add v21.16b, v2.16b, v6.16b
; CHECK-NEXT:    mvn v25.16b, v24.16b
; CHECK-NEXT:    bsl v20.16b, v24.16b, v25.16b
; CHECK-NEXT:    cmlt v24.16b, v21.16b, #0
; CHECK-NEXT:    cmlt v4.16b, v4.16b, #0
; CHECK-NEXT:    cmgt v0.16b, v0.16b, v16.16b
; CHECK-NEXT:    movi v22.16b, #127
; CHECK-NEXT:    add v23.16b, v3.16b, v7.16b
; CHECK-NEXT:    mvn v25.16b, v24.16b
; CHECK-NEXT:    eor v0.16b, v4.16b, v0.16b
; CHECK-NEXT:    cmlt v4.16b, v5.16b, #0
; CHECK-NEXT:    cmgt v1.16b, v1.16b, v19.16b
; CHECK-NEXT:    bsl v22.16b, v24.16b, v25.16b
; CHECK-NEXT:    cmlt v24.16b, v23.16b, #0
; CHECK-NEXT:    eor v1.16b, v4.16b, v1.16b
; CHECK-NEXT:    cmlt v4.16b, v6.16b, #0
; CHECK-NEXT:    cmgt v2.16b, v2.16b, v21.16b
; CHECK-NEXT:    movi v17.16b, #127
; CHECK-NEXT:    mvn v25.16b, v24.16b
; CHECK-NEXT:    eor v2.16b, v4.16b, v2.16b
; CHECK-NEXT:    cmlt v4.16b, v7.16b, #0
; CHECK-NEXT:    cmgt v3.16b, v3.16b, v23.16b
; CHECK-NEXT:    bsl v17.16b, v24.16b, v25.16b
; CHECK-NEXT:    eor v3.16b, v4.16b, v3.16b
; CHECK-NEXT:    bsl v0.16b, v18.16b, v16.16b
; CHECK-NEXT:    bsl v1.16b, v20.16b, v19.16b
; CHECK-NEXT:    bsl v2.16b, v22.16b, v21.16b
; CHECK-NEXT:    bsl v3.16b, v17.16b, v23.16b
; CHECK-NEXT:    ret
  %z = call <64 x i8> @llvm.sadd.sat.v64i8(<64 x i8> %x, <64 x i8> %y)
  ret <64 x i8> %z
}

define <8 x i16> @v8i16(<8 x i16> %x, <8 x i16> %y) nounwind {
; CHECK-LABEL: v8i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    add v2.8h, v0.8h, v1.8h
; CHECK-NEXT:    cmlt v4.8h, v2.8h, #0
; CHECK-NEXT:    mvni v3.8h, #128, lsl #8
; CHECK-NEXT:    cmlt v1.8h, v1.8h, #0
; CHECK-NEXT:    cmgt v0.8h, v0.8h, v2.8h
; CHECK-NEXT:    mvn v5.16b, v4.16b
; CHECK-NEXT:    bsl v3.16b, v4.16b, v5.16b
; CHECK-NEXT:    eor v0.16b, v1.16b, v0.16b
; CHECK-NEXT:    bsl v0.16b, v3.16b, v2.16b
; CHECK-NEXT:    ret
  %z = call <8 x i16> @llvm.sadd.sat.v8i16(<8 x i16> %x, <8 x i16> %y)
  ret <8 x i16> %z
}

define <16 x i16> @v16i16(<16 x i16> %x, <16 x i16> %y) nounwind {
; CHECK-LABEL: v16i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    add v4.8h, v0.8h, v2.8h
; CHECK-NEXT:    cmlt v7.8h, v4.8h, #0
; CHECK-NEXT:    mvni v6.8h, #128, lsl #8
; CHECK-NEXT:    mvn v16.16b, v7.16b
; CHECK-NEXT:    bsl v6.16b, v7.16b, v16.16b
; CHECK-NEXT:    add v7.8h, v1.8h, v3.8h
; CHECK-NEXT:    cmlt v2.8h, v2.8h, #0
; CHECK-NEXT:    cmgt v0.8h, v0.8h, v4.8h
; CHECK-NEXT:    cmlt v16.8h, v7.8h, #0
; CHECK-NEXT:    mvni v5.8h, #128, lsl #8
; CHECK-NEXT:    cmlt v3.8h, v3.8h, #0
; CHECK-NEXT:    cmgt v1.8h, v1.8h, v7.8h
; CHECK-NEXT:    eor v0.16b, v2.16b, v0.16b
; CHECK-NEXT:    mvn v2.16b, v16.16b
; CHECK-NEXT:    eor v1.16b, v3.16b, v1.16b
; CHECK-NEXT:    bsl v5.16b, v16.16b, v2.16b
; CHECK-NEXT:    bsl v0.16b, v6.16b, v4.16b
; CHECK-NEXT:    bsl v1.16b, v5.16b, v7.16b
; CHECK-NEXT:    ret
  %z = call <16 x i16> @llvm.sadd.sat.v16i16(<16 x i16> %x, <16 x i16> %y)
  ret <16 x i16> %z
}

define <32 x i16> @v32i16(<32 x i16> %x, <32 x i16> %y) nounwind {
; CHECK-LABEL: v32i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    add v16.8h, v0.8h, v4.8h
; CHECK-NEXT:    cmlt v24.8h, v16.8h, #0
; CHECK-NEXT:    mvni v18.8h, #128, lsl #8
; CHECK-NEXT:    add v19.8h, v1.8h, v5.8h
; CHECK-NEXT:    mvn v25.16b, v24.16b
; CHECK-NEXT:    bsl v18.16b, v24.16b, v25.16b
; CHECK-NEXT:    cmlt v24.8h, v19.8h, #0
; CHECK-NEXT:    mvni v20.8h, #128, lsl #8
; CHECK-NEXT:    add v21.8h, v2.8h, v6.8h
; CHECK-NEXT:    mvn v25.16b, v24.16b
; CHECK-NEXT:    bsl v20.16b, v24.16b, v25.16b
; CHECK-NEXT:    cmlt v24.8h, v21.8h, #0
; CHECK-NEXT:    cmlt v4.8h, v4.8h, #0
; CHECK-NEXT:    cmgt v0.8h, v0.8h, v16.8h
; CHECK-NEXT:    mvni v22.8h, #128, lsl #8
; CHECK-NEXT:    add v23.8h, v3.8h, v7.8h
; CHECK-NEXT:    mvn v25.16b, v24.16b
; CHECK-NEXT:    eor v0.16b, v4.16b, v0.16b
; CHECK-NEXT:    cmlt v4.8h, v5.8h, #0
; CHECK-NEXT:    cmgt v1.8h, v1.8h, v19.8h
; CHECK-NEXT:    bsl v22.16b, v24.16b, v25.16b
; CHECK-NEXT:    cmlt v24.8h, v23.8h, #0
; CHECK-NEXT:    eor v1.16b, v4.16b, v1.16b
; CHECK-NEXT:    cmlt v4.8h, v6.8h, #0
; CHECK-NEXT:    cmgt v2.8h, v2.8h, v21.8h
; CHECK-NEXT:    mvni v17.8h, #128, lsl #8
; CHECK-NEXT:    mvn v25.16b, v24.16b
; CHECK-NEXT:    eor v2.16b, v4.16b, v2.16b
; CHECK-NEXT:    cmlt v4.8h, v7.8h, #0
; CHECK-NEXT:    cmgt v3.8h, v3.8h, v23.8h
; CHECK-NEXT:    bsl v17.16b, v24.16b, v25.16b
; CHECK-NEXT:    eor v3.16b, v4.16b, v3.16b
; CHECK-NEXT:    bsl v0.16b, v18.16b, v16.16b
; CHECK-NEXT:    bsl v1.16b, v20.16b, v19.16b
; CHECK-NEXT:    bsl v2.16b, v22.16b, v21.16b
; CHECK-NEXT:    bsl v3.16b, v17.16b, v23.16b
; CHECK-NEXT:    ret
  %z = call <32 x i16> @llvm.sadd.sat.v32i16(<32 x i16> %x, <32 x i16> %y)
  ret <32 x i16> %z
}

define void @v8i8(<8 x i8>* %px, <8 x i8>* %py, <8 x i8>* %pz) nounwind {
; CHECK-LABEL: v8i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr d0, [x0]
; CHECK-NEXT:    ldr d1, [x1]
; CHECK-NEXT:    movi v2.8b, #127
; CHECK-NEXT:    add v3.8b, v0.8b, v1.8b
; CHECK-NEXT:    cmlt v4.8b, v3.8b, #0
; CHECK-NEXT:    cmlt v1.8b, v1.8b, #0
; CHECK-NEXT:    cmgt v0.8b, v0.8b, v3.8b
; CHECK-NEXT:    mvn v5.8b, v4.8b
; CHECK-NEXT:    bsl v2.8b, v4.8b, v5.8b
; CHECK-NEXT:    eor v0.8b, v1.8b, v0.8b
; CHECK-NEXT:    bsl v0.8b, v2.8b, v3.8b
; CHECK-NEXT:    str d0, [x2]
; CHECK-NEXT:    ret
  %x = load <8 x i8>, <8 x i8>* %px
  %y = load <8 x i8>, <8 x i8>* %py
  %z = call <8 x i8> @llvm.sadd.sat.v8i8(<8 x i8> %x, <8 x i8> %y)
  store <8 x i8> %z, <8 x i8>* %pz
  ret void
}

define void @v4i8(<4 x i8>* %px, <4 x i8>* %py, <4 x i8>* %pz) nounwind {
; CHECK-LABEL: v4i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldrsb w8, [x0]
; CHECK-NEXT:    ldrsb w9, [x1]
; CHECK-NEXT:    ldrsb w10, [x0, #1]
; CHECK-NEXT:    ldrsb w11, [x1, #1]
; CHECK-NEXT:    fmov s0, w8
; CHECK-NEXT:    fmov s1, w9
; CHECK-NEXT:    ldrsb w8, [x0, #2]
; CHECK-NEXT:    ldrsb w9, [x1, #2]
; CHECK-NEXT:    mov v0.h[1], w10
; CHECK-NEXT:    mov v1.h[1], w11
; CHECK-NEXT:    ldrsb w10, [x0, #3]
; CHECK-NEXT:    ldrsb w11, [x1, #3]
; CHECK-NEXT:    mov v0.h[2], w8
; CHECK-NEXT:    mov v1.h[2], w9
; CHECK-NEXT:    mov v0.h[3], w10
; CHECK-NEXT:    mov v1.h[3], w11
; CHECK-NEXT:    add v0.4h, v0.4h, v1.4h
; CHECK-NEXT:    movi v1.4h, #127
; CHECK-NEXT:    smin v0.4h, v0.4h, v1.4h
; CHECK-NEXT:    mvni v1.4h, #127
; CHECK-NEXT:    smax v0.4h, v0.4h, v1.4h
; CHECK-NEXT:    xtn v0.8b, v0.8h
; CHECK-NEXT:    str s0, [x2]
; CHECK-NEXT:    ret
  %x = load <4 x i8>, <4 x i8>* %px
  %y = load <4 x i8>, <4 x i8>* %py
  %z = call <4 x i8> @llvm.sadd.sat.v4i8(<4 x i8> %x, <4 x i8> %y)
  store <4 x i8> %z, <4 x i8>* %pz
  ret void
}

define void @v2i8(<2 x i8>* %px, <2 x i8>* %py, <2 x i8>* %pz) nounwind {
; CHECK-LABEL: v2i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldrsb w8, [x0]
; CHECK-NEXT:    ldrsb w9, [x1]
; CHECK-NEXT:    ldrsb w10, [x0, #1]
; CHECK-NEXT:    ldrsb w11, [x1, #1]
; CHECK-NEXT:    fmov s0, w8
; CHECK-NEXT:    fmov s1, w9
; CHECK-NEXT:    mov v0.s[1], w10
; CHECK-NEXT:    mov v1.s[1], w11
; CHECK-NEXT:    add v0.2s, v0.2s, v1.2s
; CHECK-NEXT:    movi v1.2s, #127
; CHECK-NEXT:    smin v0.2s, v0.2s, v1.2s
; CHECK-NEXT:    mvni v1.2s, #127
; CHECK-NEXT:    smax v0.2s, v0.2s, v1.2s
; CHECK-NEXT:    mov w8, v0.s[1]
; CHECK-NEXT:    fmov w9, s0
; CHECK-NEXT:    strb w8, [x2, #1]
; CHECK-NEXT:    strb w9, [x2]
; CHECK-NEXT:    ret
  %x = load <2 x i8>, <2 x i8>* %px
  %y = load <2 x i8>, <2 x i8>* %py
  %z = call <2 x i8> @llvm.sadd.sat.v2i8(<2 x i8> %x, <2 x i8> %y)
  store <2 x i8> %z, <2 x i8>* %pz
  ret void
}

define void @v4i16(<4 x i16>* %px, <4 x i16>* %py, <4 x i16>* %pz) nounwind {
; CHECK-LABEL: v4i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr d0, [x0]
; CHECK-NEXT:    ldr d1, [x1]
; CHECK-NEXT:    mvni v2.4h, #128, lsl #8
; CHECK-NEXT:    add v3.4h, v0.4h, v1.4h
; CHECK-NEXT:    cmlt v4.4h, v3.4h, #0
; CHECK-NEXT:    cmlt v1.4h, v1.4h, #0
; CHECK-NEXT:    cmgt v0.4h, v0.4h, v3.4h
; CHECK-NEXT:    mvn v5.8b, v4.8b
; CHECK-NEXT:    bsl v2.8b, v4.8b, v5.8b
; CHECK-NEXT:    eor v0.8b, v1.8b, v0.8b
; CHECK-NEXT:    bsl v0.8b, v2.8b, v3.8b
; CHECK-NEXT:    str d0, [x2]
; CHECK-NEXT:    ret
  %x = load <4 x i16>, <4 x i16>* %px
  %y = load <4 x i16>, <4 x i16>* %py
  %z = call <4 x i16> @llvm.sadd.sat.v4i16(<4 x i16> %x, <4 x i16> %y)
  store <4 x i16> %z, <4 x i16>* %pz
  ret void
}

define void @v2i16(<2 x i16>* %px, <2 x i16>* %py, <2 x i16>* %pz) nounwind {
; CHECK-LABEL: v2i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldrsh w8, [x0]
; CHECK-NEXT:    ldrsh w9, [x1]
; CHECK-NEXT:    ldrsh w10, [x0, #2]
; CHECK-NEXT:    ldrsh w11, [x1, #2]
; CHECK-NEXT:    fmov s0, w8
; CHECK-NEXT:    fmov s1, w9
; CHECK-NEXT:    mov v0.s[1], w10
; CHECK-NEXT:    mov v1.s[1], w11
; CHECK-NEXT:    add v0.2s, v0.2s, v1.2s
; CHECK-NEXT:    movi v1.2s, #127, msl #8
; CHECK-NEXT:    smin v0.2s, v0.2s, v1.2s
; CHECK-NEXT:    mvni v1.2s, #127, msl #8
; CHECK-NEXT:    smax v0.2s, v0.2s, v1.2s
; CHECK-NEXT:    mov w8, v0.s[1]
; CHECK-NEXT:    fmov w9, s0
; CHECK-NEXT:    strh w8, [x2, #2]
; CHECK-NEXT:    strh w9, [x2]
; CHECK-NEXT:    ret
  %x = load <2 x i16>, <2 x i16>* %px
  %y = load <2 x i16>, <2 x i16>* %py
  %z = call <2 x i16> @llvm.sadd.sat.v2i16(<2 x i16> %x, <2 x i16> %y)
  store <2 x i16> %z, <2 x i16>* %pz
  ret void
}

define <12 x i8> @v12i8(<12 x i8> %x, <12 x i8> %y) nounwind {
; CHECK-LABEL: v12i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    add v2.16b, v0.16b, v1.16b
; CHECK-NEXT:    cmlt v4.16b, v2.16b, #0
; CHECK-NEXT:    movi v3.16b, #127
; CHECK-NEXT:    cmlt v1.16b, v1.16b, #0
; CHECK-NEXT:    cmgt v0.16b, v0.16b, v2.16b
; CHECK-NEXT:    mvn v5.16b, v4.16b
; CHECK-NEXT:    bsl v3.16b, v4.16b, v5.16b
; CHECK-NEXT:    eor v0.16b, v1.16b, v0.16b
; CHECK-NEXT:    bsl v0.16b, v3.16b, v2.16b
; CHECK-NEXT:    ret
  %z = call <12 x i8> @llvm.sadd.sat.v12i8(<12 x i8> %x, <12 x i8> %y)
  ret <12 x i8> %z
}

define void @v12i16(<12 x i16>* %px, <12 x i16>* %py, <12 x i16>* %pz) nounwind {
; CHECK-LABEL: v12i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldp q0, q1, [x0]
; CHECK-NEXT:    ldp q3, q2, [x1]
; CHECK-NEXT:    mvni v5.8h, #128, lsl #8
; CHECK-NEXT:    mvni v4.8h, #128, lsl #8
; CHECK-NEXT:    add v6.8h, v1.8h, v2.8h
; CHECK-NEXT:    cmlt v7.8h, v6.8h, #0
; CHECK-NEXT:    mvn v16.16b, v7.16b
; CHECK-NEXT:    bsl v5.16b, v7.16b, v16.16b
; CHECK-NEXT:    add v7.8h, v0.8h, v3.8h
; CHECK-NEXT:    cmlt v2.8h, v2.8h, #0
; CHECK-NEXT:    cmgt v1.8h, v1.8h, v6.8h
; CHECK-NEXT:    cmlt v16.8h, v7.8h, #0
; CHECK-NEXT:    cmlt v3.8h, v3.8h, #0
; CHECK-NEXT:    cmgt v0.8h, v0.8h, v7.8h
; CHECK-NEXT:    eor v1.16b, v2.16b, v1.16b
; CHECK-NEXT:    mvn v2.16b, v16.16b
; CHECK-NEXT:    eor v0.16b, v3.16b, v0.16b
; CHECK-NEXT:    bsl v4.16b, v16.16b, v2.16b
; CHECK-NEXT:    bsl v1.16b, v5.16b, v6.16b
; CHECK-NEXT:    bsl v0.16b, v4.16b, v7.16b
; CHECK-NEXT:    str q0, [x2]
; CHECK-NEXT:    str d1, [x2, #16]
; CHECK-NEXT:    ret
  %x = load <12 x i16>, <12 x i16>* %px
  %y = load <12 x i16>, <12 x i16>* %py
  %z = call <12 x i16> @llvm.sadd.sat.v12i16(<12 x i16> %x, <12 x i16> %y)
  store <12 x i16> %z, <12 x i16>* %pz
  ret void
}

define void @v1i8(<1 x i8>* %px, <1 x i8>* %py, <1 x i8>* %pz) nounwind {
; CHECK-LABEL: v1i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr b0, [x0]
; CHECK-NEXT:    ldr b1, [x1]
; CHECK-NEXT:    movi v2.8b, #127
; CHECK-NEXT:    add v3.8b, v0.8b, v1.8b
; CHECK-NEXT:    cmlt v4.8b, v3.8b, #0
; CHECK-NEXT:    cmlt v1.8b, v1.8b, #0
; CHECK-NEXT:    cmgt v0.8b, v0.8b, v3.8b
; CHECK-NEXT:    mvn v5.8b, v4.8b
; CHECK-NEXT:    bsl v2.8b, v4.8b, v5.8b
; CHECK-NEXT:    eor v0.8b, v1.8b, v0.8b
; CHECK-NEXT:    bsl v0.8b, v2.8b, v3.8b
; CHECK-NEXT:    st1 { v0.b }[0], [x2]
; CHECK-NEXT:    ret
  %x = load <1 x i8>, <1 x i8>* %px
  %y = load <1 x i8>, <1 x i8>* %py
  %z = call <1 x i8> @llvm.sadd.sat.v1i8(<1 x i8> %x, <1 x i8> %y)
  store <1 x i8> %z, <1 x i8>* %pz
  ret void
}

define void @v1i16(<1 x i16>* %px, <1 x i16>* %py, <1 x i16>* %pz) nounwind {
; CHECK-LABEL: v1i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr h0, [x0]
; CHECK-NEXT:    ldr h1, [x1]
; CHECK-NEXT:    mvni v2.4h, #128, lsl #8
; CHECK-NEXT:    add v3.4h, v0.4h, v1.4h
; CHECK-NEXT:    cmlt v4.4h, v3.4h, #0
; CHECK-NEXT:    cmlt v1.4h, v1.4h, #0
; CHECK-NEXT:    cmgt v0.4h, v0.4h, v3.4h
; CHECK-NEXT:    mvn v5.8b, v4.8b
; CHECK-NEXT:    bsl v2.8b, v4.8b, v5.8b
; CHECK-NEXT:    eor v0.8b, v1.8b, v0.8b
; CHECK-NEXT:    bsl v0.8b, v2.8b, v3.8b
; CHECK-NEXT:    str h0, [x2]
; CHECK-NEXT:    ret
  %x = load <1 x i16>, <1 x i16>* %px
  %y = load <1 x i16>, <1 x i16>* %py
  %z = call <1 x i16> @llvm.sadd.sat.v1i16(<1 x i16> %x, <1 x i16> %y)
  store <1 x i16> %z, <1 x i16>* %pz
  ret void
}

define <16 x i4> @v16i4(<16 x i4> %x, <16 x i4> %y) nounwind {
; CHECK-LABEL: v16i4:
; CHECK:       // %bb.0:
; CHECK-NEXT:    shl v0.16b, v0.16b, #4
; CHECK-NEXT:    shl v1.16b, v1.16b, #4
; CHECK-NEXT:    sshr v0.16b, v0.16b, #4
; CHECK-NEXT:    movi v2.16b, #7
; CHECK-NEXT:    ssra v0.16b, v1.16b, #4
; CHECK-NEXT:    smin v0.16b, v0.16b, v2.16b
; CHECK-NEXT:    movi v1.16b, #248
; CHECK-NEXT:    smax v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %z = call <16 x i4> @llvm.sadd.sat.v16i4(<16 x i4> %x, <16 x i4> %y)
  ret <16 x i4> %z
}

define <16 x i1> @v16i1(<16 x i1> %x, <16 x i1> %y) nounwind {
; CHECK-LABEL: v16i1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    shl v0.16b, v0.16b, #7
; CHECK-NEXT:    shl v1.16b, v1.16b, #7
; CHECK-NEXT:    sshr v0.16b, v0.16b, #7
; CHECK-NEXT:    movi v2.2d, #0000000000000000
; CHECK-NEXT:    ssra v0.16b, v1.16b, #7
; CHECK-NEXT:    smin v0.16b, v0.16b, v2.16b
; CHECK-NEXT:    movi v1.2d, #0xffffffffffffffff
; CHECK-NEXT:    smax v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %z = call <16 x i1> @llvm.sadd.sat.v16i1(<16 x i1> %x, <16 x i1> %y)
  ret <16 x i1> %z
}

define <2 x i32> @v2i32(<2 x i32> %x, <2 x i32> %y) nounwind {
; CHECK-LABEL: v2i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    add v2.2s, v0.2s, v1.2s
; CHECK-NEXT:    cmlt v4.2s, v2.2s, #0
; CHECK-NEXT:    mvni v3.2s, #128, lsl #24
; CHECK-NEXT:    cmlt v1.2s, v1.2s, #0
; CHECK-NEXT:    cmgt v0.2s, v0.2s, v2.2s
; CHECK-NEXT:    mvn v5.8b, v4.8b
; CHECK-NEXT:    bsl v3.8b, v4.8b, v5.8b
; CHECK-NEXT:    eor v0.8b, v1.8b, v0.8b
; CHECK-NEXT:    bsl v0.8b, v3.8b, v2.8b
; CHECK-NEXT:    ret
  %z = call <2 x i32> @llvm.sadd.sat.v2i32(<2 x i32> %x, <2 x i32> %y)
  ret <2 x i32> %z
}

define <4 x i32> @v4i32(<4 x i32> %x, <4 x i32> %y) nounwind {
; CHECK-LABEL: v4i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    add v2.4s, v0.4s, v1.4s
; CHECK-NEXT:    cmlt v4.4s, v2.4s, #0
; CHECK-NEXT:    mvni v3.4s, #128, lsl #24
; CHECK-NEXT:    cmlt v1.4s, v1.4s, #0
; CHECK-NEXT:    cmgt v0.4s, v0.4s, v2.4s
; CHECK-NEXT:    mvn v5.16b, v4.16b
; CHECK-NEXT:    bsl v3.16b, v4.16b, v5.16b
; CHECK-NEXT:    eor v0.16b, v1.16b, v0.16b
; CHECK-NEXT:    bsl v0.16b, v3.16b, v2.16b
; CHECK-NEXT:    ret
  %z = call <4 x i32> @llvm.sadd.sat.v4i32(<4 x i32> %x, <4 x i32> %y)
  ret <4 x i32> %z
}

define <8 x i32> @v8i32(<8 x i32> %x, <8 x i32> %y) nounwind {
; CHECK-LABEL: v8i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    add v4.4s, v0.4s, v2.4s
; CHECK-NEXT:    cmlt v7.4s, v4.4s, #0
; CHECK-NEXT:    mvni v6.4s, #128, lsl #24
; CHECK-NEXT:    mvn v16.16b, v7.16b
; CHECK-NEXT:    bsl v6.16b, v7.16b, v16.16b
; CHECK-NEXT:    add v7.4s, v1.4s, v3.4s
; CHECK-NEXT:    cmlt v2.4s, v2.4s, #0
; CHECK-NEXT:    cmgt v0.4s, v0.4s, v4.4s
; CHECK-NEXT:    cmlt v16.4s, v7.4s, #0
; CHECK-NEXT:    mvni v5.4s, #128, lsl #24
; CHECK-NEXT:    cmlt v3.4s, v3.4s, #0
; CHECK-NEXT:    cmgt v1.4s, v1.4s, v7.4s
; CHECK-NEXT:    eor v0.16b, v2.16b, v0.16b
; CHECK-NEXT:    mvn v2.16b, v16.16b
; CHECK-NEXT:    eor v1.16b, v3.16b, v1.16b
; CHECK-NEXT:    bsl v5.16b, v16.16b, v2.16b
; CHECK-NEXT:    bsl v0.16b, v6.16b, v4.16b
; CHECK-NEXT:    bsl v1.16b, v5.16b, v7.16b
; CHECK-NEXT:    ret
  %z = call <8 x i32> @llvm.sadd.sat.v8i32(<8 x i32> %x, <8 x i32> %y)
  ret <8 x i32> %z
}

define <16 x i32> @v16i32(<16 x i32> %x, <16 x i32> %y) nounwind {
; CHECK-LABEL: v16i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    add v16.4s, v0.4s, v4.4s
; CHECK-NEXT:    cmlt v24.4s, v16.4s, #0
; CHECK-NEXT:    mvni v18.4s, #128, lsl #24
; CHECK-NEXT:    add v19.4s, v1.4s, v5.4s
; CHECK-NEXT:    mvn v25.16b, v24.16b
; CHECK-NEXT:    bsl v18.16b, v24.16b, v25.16b
; CHECK-NEXT:    cmlt v24.4s, v19.4s, #0
; CHECK-NEXT:    mvni v20.4s, #128, lsl #24
; CHECK-NEXT:    add v21.4s, v2.4s, v6.4s
; CHECK-NEXT:    mvn v25.16b, v24.16b
; CHECK-NEXT:    bsl v20.16b, v24.16b, v25.16b
; CHECK-NEXT:    cmlt v24.4s, v21.4s, #0
; CHECK-NEXT:    cmlt v4.4s, v4.4s, #0
; CHECK-NEXT:    cmgt v0.4s, v0.4s, v16.4s
; CHECK-NEXT:    mvni v22.4s, #128, lsl #24
; CHECK-NEXT:    add v23.4s, v3.4s, v7.4s
; CHECK-NEXT:    mvn v25.16b, v24.16b
; CHECK-NEXT:    eor v0.16b, v4.16b, v0.16b
; CHECK-NEXT:    cmlt v4.4s, v5.4s, #0
; CHECK-NEXT:    cmgt v1.4s, v1.4s, v19.4s
; CHECK-NEXT:    bsl v22.16b, v24.16b, v25.16b
; CHECK-NEXT:    cmlt v24.4s, v23.4s, #0
; CHECK-NEXT:    eor v1.16b, v4.16b, v1.16b
; CHECK-NEXT:    cmlt v4.4s, v6.4s, #0
; CHECK-NEXT:    cmgt v2.4s, v2.4s, v21.4s
; CHECK-NEXT:    mvni v17.4s, #128, lsl #24
; CHECK-NEXT:    mvn v25.16b, v24.16b
; CHECK-NEXT:    eor v2.16b, v4.16b, v2.16b
; CHECK-NEXT:    cmlt v4.4s, v7.4s, #0
; CHECK-NEXT:    cmgt v3.4s, v3.4s, v23.4s
; CHECK-NEXT:    bsl v17.16b, v24.16b, v25.16b
; CHECK-NEXT:    eor v3.16b, v4.16b, v3.16b
; CHECK-NEXT:    bsl v0.16b, v18.16b, v16.16b
; CHECK-NEXT:    bsl v1.16b, v20.16b, v19.16b
; CHECK-NEXT:    bsl v2.16b, v22.16b, v21.16b
; CHECK-NEXT:    bsl v3.16b, v17.16b, v23.16b
; CHECK-NEXT:    ret
  %z = call <16 x i32> @llvm.sadd.sat.v16i32(<16 x i32> %x, <16 x i32> %y)
  ret <16 x i32> %z
}

define <2 x i64> @v2i64(<2 x i64> %x, <2 x i64> %y) nounwind {
; CHECK-LABEL: v2i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    add v2.2d, v0.2d, v1.2d
; CHECK-NEXT:    mov x8, #9223372036854775807
; CHECK-NEXT:    cmlt v3.2d, v2.2d, #0
; CHECK-NEXT:    cmlt v1.2d, v1.2d, #0
; CHECK-NEXT:    dup v4.2d, x8
; CHECK-NEXT:    cmgt v0.2d, v0.2d, v2.2d
; CHECK-NEXT:    mvn v5.16b, v3.16b
; CHECK-NEXT:    bsl v4.16b, v3.16b, v5.16b
; CHECK-NEXT:    eor v0.16b, v1.16b, v0.16b
; CHECK-NEXT:    bsl v0.16b, v4.16b, v2.16b
; CHECK-NEXT:    ret
  %z = call <2 x i64> @llvm.sadd.sat.v2i64(<2 x i64> %x, <2 x i64> %y)
  ret <2 x i64> %z
}

define <4 x i64> @v4i64(<4 x i64> %x, <4 x i64> %y) nounwind {
; CHECK-LABEL: v4i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    add v4.2d, v0.2d, v2.2d
; CHECK-NEXT:    mov x8, #9223372036854775807
; CHECK-NEXT:    cmlt v5.2d, v4.2d, #0
; CHECK-NEXT:    dup v6.2d, x8
; CHECK-NEXT:    mvn v7.16b, v5.16b
; CHECK-NEXT:    mov v16.16b, v6.16b
; CHECK-NEXT:    bsl v16.16b, v5.16b, v7.16b
; CHECK-NEXT:    add v5.2d, v1.2d, v3.2d
; CHECK-NEXT:    cmlt v2.2d, v2.2d, #0
; CHECK-NEXT:    cmgt v0.2d, v0.2d, v4.2d
; CHECK-NEXT:    cmlt v7.2d, v5.2d, #0
; CHECK-NEXT:    cmlt v3.2d, v3.2d, #0
; CHECK-NEXT:    cmgt v1.2d, v1.2d, v5.2d
; CHECK-NEXT:    eor v0.16b, v2.16b, v0.16b
; CHECK-NEXT:    mvn v2.16b, v7.16b
; CHECK-NEXT:    eor v1.16b, v3.16b, v1.16b
; CHECK-NEXT:    bsl v6.16b, v7.16b, v2.16b
; CHECK-NEXT:    bsl v0.16b, v16.16b, v4.16b
; CHECK-NEXT:    bsl v1.16b, v6.16b, v5.16b
; CHECK-NEXT:    ret
  %z = call <4 x i64> @llvm.sadd.sat.v4i64(<4 x i64> %x, <4 x i64> %y)
  ret <4 x i64> %z
}

define <8 x i64> @v8i64(<8 x i64> %x, <8 x i64> %y) nounwind {
; CHECK-LABEL: v8i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    add v16.2d, v0.2d, v4.2d
; CHECK-NEXT:    mov x8, #9223372036854775807
; CHECK-NEXT:    add v17.2d, v1.2d, v5.2d
; CHECK-NEXT:    cmlt v20.2d, v16.2d, #0
; CHECK-NEXT:    dup v21.2d, x8
; CHECK-NEXT:    add v18.2d, v2.2d, v6.2d
; CHECK-NEXT:    cmlt v22.2d, v17.2d, #0
; CHECK-NEXT:    mvn v24.16b, v20.16b
; CHECK-NEXT:    mov v25.16b, v21.16b
; CHECK-NEXT:    cmlt v23.2d, v18.2d, #0
; CHECK-NEXT:    bsl v25.16b, v20.16b, v24.16b
; CHECK-NEXT:    mvn v20.16b, v22.16b
; CHECK-NEXT:    mov v24.16b, v21.16b
; CHECK-NEXT:    cmlt v4.2d, v4.2d, #0
; CHECK-NEXT:    cmgt v0.2d, v0.2d, v16.2d
; CHECK-NEXT:    add v19.2d, v3.2d, v7.2d
; CHECK-NEXT:    bsl v24.16b, v22.16b, v20.16b
; CHECK-NEXT:    mvn v20.16b, v23.16b
; CHECK-NEXT:    mov v22.16b, v21.16b
; CHECK-NEXT:    eor v0.16b, v4.16b, v0.16b
; CHECK-NEXT:    cmlt v4.2d, v5.2d, #0
; CHECK-NEXT:    cmgt v1.2d, v1.2d, v17.2d
; CHECK-NEXT:    bsl v22.16b, v23.16b, v20.16b
; CHECK-NEXT:    cmlt v20.2d, v19.2d, #0
; CHECK-NEXT:    eor v1.16b, v4.16b, v1.16b
; CHECK-NEXT:    cmlt v4.2d, v6.2d, #0
; CHECK-NEXT:    cmgt v2.2d, v2.2d, v18.2d
; CHECK-NEXT:    mvn v23.16b, v20.16b
; CHECK-NEXT:    eor v2.16b, v4.16b, v2.16b
; CHECK-NEXT:    cmlt v4.2d, v7.2d, #0
; CHECK-NEXT:    cmgt v3.2d, v3.2d, v19.2d
; CHECK-NEXT:    bsl v21.16b, v20.16b, v23.16b
; CHECK-NEXT:    eor v3.16b, v4.16b, v3.16b
; CHECK-NEXT:    bsl v0.16b, v25.16b, v16.16b
; CHECK-NEXT:    bsl v1.16b, v24.16b, v17.16b
; CHECK-NEXT:    bsl v2.16b, v22.16b, v18.16b
; CHECK-NEXT:    bsl v3.16b, v21.16b, v19.16b
; CHECK-NEXT:    ret
  %z = call <8 x i64> @llvm.sadd.sat.v8i64(<8 x i64> %x, <8 x i64> %y)
  ret <8 x i64> %z
}

define <2 x i128> @v2i128(<2 x i128> %x, <2 x i128> %y) nounwind {
; CHECK-LABEL: v2i128:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmp x7, #0 // =0
; CHECK-NEXT:    cset w9, ge
; CHECK-NEXT:    csinc w9, w9, wzr, ne
; CHECK-NEXT:    cmp x3, #0 // =0
; CHECK-NEXT:    cset w10, ge
; CHECK-NEXT:    csinc w10, w10, wzr, ne
; CHECK-NEXT:    cmp w10, w9
; CHECK-NEXT:    cset w9, eq
; CHECK-NEXT:    adds x11, x2, x6
; CHECK-NEXT:    adcs x12, x3, x7
; CHECK-NEXT:    cmp x12, #0 // =0
; CHECK-NEXT:    cset w13, ge
; CHECK-NEXT:    mov x8, #9223372036854775807
; CHECK-NEXT:    csinc w13, w13, wzr, ne
; CHECK-NEXT:    cinv x14, x8, ge
; CHECK-NEXT:    cmp w10, w13
; CHECK-NEXT:    cset w13, ne
; CHECK-NEXT:    asr x10, x12, #63
; CHECK-NEXT:    tst w9, w13
; CHECK-NEXT:    csel x3, x14, x12, ne
; CHECK-NEXT:    csel x2, x10, x11, ne
; CHECK-NEXT:    cmp x5, #0 // =0
; CHECK-NEXT:    cset w9, ge
; CHECK-NEXT:    csinc w9, w9, wzr, ne
; CHECK-NEXT:    cmp x1, #0 // =0
; CHECK-NEXT:    cset w10, ge
; CHECK-NEXT:    csinc w10, w10, wzr, ne
; CHECK-NEXT:    cmp w10, w9
; CHECK-NEXT:    cset w9, eq
; CHECK-NEXT:    adds x11, x0, x4
; CHECK-NEXT:    adcs x12, x1, x5
; CHECK-NEXT:    cmp x12, #0 // =0
; CHECK-NEXT:    cset w13, ge
; CHECK-NEXT:    csinc w13, w13, wzr, ne
; CHECK-NEXT:    cinv x8, x8, ge
; CHECK-NEXT:    cmp w10, w13
; CHECK-NEXT:    cset w10, ne
; CHECK-NEXT:    tst w9, w10
; CHECK-NEXT:    asr x9, x12, #63
; CHECK-NEXT:    csel x9, x9, x11, ne
; CHECK-NEXT:    csel x1, x8, x12, ne
; CHECK-NEXT:    fmov d0, x9
; CHECK-NEXT:    mov v0.d[1], x1
; CHECK-NEXT:    fmov x0, d0
; CHECK-NEXT:    ret
  %z = call <2 x i128> @llvm.sadd.sat.v2i128(<2 x i128> %x, <2 x i128> %y)
  ret <2 x i128> %z
}
