; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve.fp,+fp64 -verify-machineinstrs %s -o - | FileCheck %s

; i32

define <8 x i32> *@vst2_v4i32(<4 x i32> *%src, <8 x i32> *%dst) {
; CHECK-LABEL: vst2_v4i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q1, [r0, #16]
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    vst20.32 {q0, q1}, [r1]
; CHECK-NEXT:    vst21.32 {q0, q1}, [r1]!
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    bx lr
entry:
  %s1 = getelementptr <4 x i32>, <4 x i32>* %src, i32 0
  %l1 = load <4 x i32>, <4 x i32>* %s1, align 4
  %s2 = getelementptr <4 x i32>, <4 x i32>* %src, i32 1
  %l2 = load <4 x i32>, <4 x i32>* %s2, align 4
  %s = shufflevector <4 x i32> %l1, <4 x i32> %l2, <8 x i32> <i32 0, i32 4, i32 1, i32 5, i32 2, i32 6, i32 3, i32 7>
  store <8 x i32> %s, <8 x i32> *%dst
  %ret = getelementptr inbounds <8 x i32>, <8 x i32>* %dst, i32 1
  ret <8 x i32> *%ret
}

; i16

define <16 x i16> *@vst2_v8i16(<8 x i16> *%src, <16 x i16> *%dst) {
; CHECK-LABEL: vst2_v8i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q1, [r0, #16]
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    vst20.16 {q0, q1}, [r1]
; CHECK-NEXT:    vst21.16 {q0, q1}, [r1]!
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    bx lr
entry:
  %s1 = getelementptr <8 x i16>, <8 x i16>* %src, i32 0
  %l1 = load <8 x i16>, <8 x i16>* %s1, align 4
  %s2 = getelementptr <8 x i16>, <8 x i16>* %src, i32 1
  %l2 = load <8 x i16>, <8 x i16>* %s2, align 4
  %s = shufflevector <8 x i16> %l1, <8 x i16> %l2, <16 x i32> <i32 0, i32 8, i32 1, i32 9, i32 2, i32 10, i32 3, i32 11, i32 4, i32 12, i32 5, i32 13, i32 6, i32 14, i32 7, i32 15>
  store <16 x i16> %s, <16 x i16> *%dst
  %ret = getelementptr inbounds <16 x i16>, <16 x i16>* %dst, i32 1
  ret <16 x i16> *%ret
}

; i8

define <32 x i8> *@vst2_v16i8(<16 x i8> *%src, <32 x i8> *%dst) {
; CHECK-LABEL: vst2_v16i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q1, [r0, #16]
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    vst20.8 {q0, q1}, [r1]
; CHECK-NEXT:    vst21.8 {q0, q1}, [r1]!
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    bx lr
entry:
  %s1 = getelementptr <16 x i8>, <16 x i8>* %src, i32 0
  %l1 = load <16 x i8>, <16 x i8>* %s1, align 4
  %s2 = getelementptr <16 x i8>, <16 x i8>* %src, i32 1
  %l2 = load <16 x i8>, <16 x i8>* %s2, align 4
  %s = shufflevector <16 x i8> %l1, <16 x i8> %l2, <32 x i32> <i32 0, i32 16, i32 1, i32 17, i32 2, i32 18, i32 3, i32 19, i32 4, i32 20, i32 5, i32 21, i32 6, i32 22, i32 7, i32 23, i32 8, i32 24, i32 9, i32 25, i32 10, i32 26, i32 11, i32 27, i32 12, i32 28, i32 13, i32 29, i32 14, i32 30, i32 15, i32 31>
  store <32 x i8> %s, <32 x i8> *%dst
  %ret = getelementptr inbounds <32 x i8>, <32 x i8>* %dst, i32 1
  ret <32 x i8> *%ret
}

; i64

define <4 x i64> *@vst2_v2i64(<2 x i64> *%src, <4 x i64> *%dst) {
; CHECK-LABEL: vst2_v2i64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    vldrw.u32 q1, [r0, #16]
; CHECK-NEXT:    add.w r0, r1, #32
; CHECK-NEXT:    vmov.f64 d4, d1
; CHECK-NEXT:    vmov.f32 s9, s3
; CHECK-NEXT:    vmov.f32 s2, s4
; CHECK-NEXT:    vmov.f32 s10, s6
; CHECK-NEXT:    vmov.f32 s3, s5
; CHECK-NEXT:    vmov.f32 s11, s7
; CHECK-NEXT:    vstrb.8 q0, [r1], #16
; CHECK-NEXT:    vstrw.32 q2, [r1]
; CHECK-NEXT:    bx lr
entry:
  %s1 = getelementptr <2 x i64>, <2 x i64>* %src, i32 0
  %l1 = load <2 x i64>, <2 x i64>* %s1, align 4
  %s2 = getelementptr <2 x i64>, <2 x i64>* %src, i32 1
  %l2 = load <2 x i64>, <2 x i64>* %s2, align 4
  %s = shufflevector <2 x i64> %l1, <2 x i64> %l2, <4 x i32> <i32 0, i32 2, i32 1, i32 3>
  store <4 x i64> %s, <4 x i64> *%dst
  %ret = getelementptr inbounds <4 x i64>, <4 x i64>* %dst, i32 1
  ret <4 x i64> *%ret
}

; f32

define <8 x float> *@vst2_v4f32(<4 x float> *%src, <8 x float> *%dst) {
; CHECK-LABEL: vst2_v4f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q1, [r0, #16]
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    vst20.32 {q0, q1}, [r1]
; CHECK-NEXT:    vst21.32 {q0, q1}, [r1]!
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    bx lr
entry:
  %s1 = getelementptr <4 x float>, <4 x float>* %src, i32 0
  %l1 = load <4 x float>, <4 x float>* %s1, align 4
  %s2 = getelementptr <4 x float>, <4 x float>* %src, i32 1
  %l2 = load <4 x float>, <4 x float>* %s2, align 4
  %s = shufflevector <4 x float> %l1, <4 x float> %l2, <8 x i32> <i32 0, i32 4, i32 1, i32 5, i32 2, i32 6, i32 3, i32 7>
  store <8 x float> %s, <8 x float> *%dst
  %ret = getelementptr inbounds <8 x float>, <8 x float>* %dst, i32 1
  ret <8 x float> *%ret
}

; f16

define <16 x half> *@vst2_v8f16(<8 x half> *%src, <16 x half> *%dst) {
; CHECK-LABEL: vst2_v8f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q1, [r0, #16]
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    vst20.16 {q0, q1}, [r1]
; CHECK-NEXT:    vst21.16 {q0, q1}, [r1]!
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    bx lr
entry:
  %s1 = getelementptr <8 x half>, <8 x half>* %src, i32 0
  %l1 = load <8 x half>, <8 x half>* %s1, align 4
  %s2 = getelementptr <8 x half>, <8 x half>* %src, i32 1
  %l2 = load <8 x half>, <8 x half>* %s2, align 4
  %s = shufflevector <8 x half> %l1, <8 x half> %l2, <16 x i32> <i32 0, i32 8, i32 1, i32 9, i32 2, i32 10, i32 3, i32 11, i32 4, i32 12, i32 5, i32 13, i32 6, i32 14, i32 7, i32 15>
  store <16 x half> %s, <16 x half> *%dst
  %ret = getelementptr inbounds <16 x half>, <16 x half>* %dst, i32 1
  ret <16 x half> *%ret
}

; f64

define <4 x double> *@vst2_v2f64(<2 x double> *%src, <4 x double> *%dst) {
; CHECK-LABEL: vst2_v2f64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    vldrw.u32 q0, [r0, #16]
; CHECK-NEXT:    vmov.f64 d4, d2
; CHECK-NEXT:    vmov.f64 d5, d0
; CHECK-NEXT:    vmov.f64 d0, d3
; CHECK-NEXT:    vstrw.32 q0, [r1, #16]
; CHECK-NEXT:    vstrw.32 q2, [r1], #32
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    bx lr
entry:
  %s1 = getelementptr <2 x double>, <2 x double>* %src, i32 0
  %l1 = load <2 x double>, <2 x double>* %s1, align 4
  %s2 = getelementptr <2 x double>, <2 x double>* %src, i32 1
  %l2 = load <2 x double>, <2 x double>* %s2, align 4
  %s = shufflevector <2 x double> %l1, <2 x double> %l2, <4 x i32> <i32 0, i32 2, i32 1, i32 3>
  store <4 x double> %s, <4 x double> *%dst
  %ret = getelementptr inbounds <4 x double>, <4 x double>* %dst, i32 1
  ret <4 x double> *%ret
}
