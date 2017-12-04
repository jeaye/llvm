; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=arm-eabi -mattr=+neon %s -o - -lower-interleaved-accesses=false | FileCheck %s

define <8 x i8> @vpaddi8(<8 x i8>* %A, <8 x i8>* %B) nounwind {
; CHECK-LABEL: vpaddi8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr d16, [r1]
; CHECK-NEXT:    vldr d17, [r0]
; CHECK-NEXT:    vpadd.i8 d16, d17, d16
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    mov pc, lr
	%tmp1 = load <8 x i8>, <8 x i8>* %A
	%tmp2 = load <8 x i8>, <8 x i8>* %B
	%tmp3 = call <8 x i8> @llvm.arm.neon.vpadd.v8i8(<8 x i8> %tmp1, <8 x i8> %tmp2)
	ret <8 x i8> %tmp3
}

define <4 x i16> @vpaddi16(<4 x i16>* %A, <4 x i16>* %B) nounwind {
; CHECK-LABEL: vpaddi16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr d16, [r1]
; CHECK-NEXT:    vldr d17, [r0]
; CHECK-NEXT:    vpadd.i16 d16, d17, d16
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    mov pc, lr
	%tmp1 = load <4 x i16>, <4 x i16>* %A
	%tmp2 = load <4 x i16>, <4 x i16>* %B
	%tmp3 = call <4 x i16> @llvm.arm.neon.vpadd.v4i16(<4 x i16> %tmp1, <4 x i16> %tmp2)
	ret <4 x i16> %tmp3
}

define <2 x i32> @vpaddi32(<2 x i32>* %A, <2 x i32>* %B) nounwind {
; CHECK-LABEL: vpaddi32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr d16, [r1]
; CHECK-NEXT:    vldr d17, [r0]
; CHECK-NEXT:    vpadd.i32 d16, d17, d16
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    mov pc, lr
	%tmp1 = load <2 x i32>, <2 x i32>* %A
	%tmp2 = load <2 x i32>, <2 x i32>* %B
	%tmp3 = call <2 x i32> @llvm.arm.neon.vpadd.v2i32(<2 x i32> %tmp1, <2 x i32> %tmp2)
	ret <2 x i32> %tmp3
}

define <2 x float> @vpaddf32(<2 x float>* %A, <2 x float>* %B) nounwind {
; CHECK-LABEL: vpaddf32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr d16, [r1]
; CHECK-NEXT:    vldr d17, [r0]
; CHECK-NEXT:    vpadd.f32 d16, d17, d16
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    mov pc, lr
	%tmp1 = load <2 x float>, <2 x float>* %A
	%tmp2 = load <2 x float>, <2 x float>* %B
	%tmp3 = call <2 x float> @llvm.arm.neon.vpadd.v2f32(<2 x float> %tmp1, <2 x float> %tmp2)
	ret <2 x float> %tmp3
}

declare <8 x i8>  @llvm.arm.neon.vpadd.v8i8(<8 x i8>, <8 x i8>) nounwind readnone
declare <4 x i16> @llvm.arm.neon.vpadd.v4i16(<4 x i16>, <4 x i16>) nounwind readnone
declare <2 x i32> @llvm.arm.neon.vpadd.v2i32(<2 x i32>, <2 x i32>) nounwind readnone

declare <2 x float> @llvm.arm.neon.vpadd.v2f32(<2 x float>, <2 x float>) nounwind readnone

define <4 x i16> @vpaddls8(<8 x i8>* %A) nounwind {
; CHECK-LABEL: vpaddls8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr d16, [r0]
; CHECK-NEXT:    vpaddl.s8 d16, d16
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    mov pc, lr
	%tmp1 = load <8 x i8>, <8 x i8>* %A
	%tmp2 = call <4 x i16> @llvm.arm.neon.vpaddls.v4i16.v8i8(<8 x i8> %tmp1)
	ret <4 x i16> %tmp2
}

define <2 x i32> @vpaddls16(<4 x i16>* %A) nounwind {
; CHECK-LABEL: vpaddls16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr d16, [r0]
; CHECK-NEXT:    vpaddl.s16 d16, d16
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    mov pc, lr
	%tmp1 = load <4 x i16>, <4 x i16>* %A
	%tmp2 = call <2 x i32> @llvm.arm.neon.vpaddls.v2i32.v4i16(<4 x i16> %tmp1)
	ret <2 x i32> %tmp2
}

define <1 x i64> @vpaddls32(<2 x i32>* %A) nounwind {
; CHECK-LABEL: vpaddls32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr d16, [r0]
; CHECK-NEXT:    vpaddl.s32 d16, d16
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    mov pc, lr
	%tmp1 = load <2 x i32>, <2 x i32>* %A
	%tmp2 = call <1 x i64> @llvm.arm.neon.vpaddls.v1i64.v2i32(<2 x i32> %tmp1)
	ret <1 x i64> %tmp2
}

define <4 x i16> @vpaddlu8(<8 x i8>* %A) nounwind {
; CHECK-LABEL: vpaddlu8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr d16, [r0]
; CHECK-NEXT:    vpaddl.u8 d16, d16
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    mov pc, lr
	%tmp1 = load <8 x i8>, <8 x i8>* %A
	%tmp2 = call <4 x i16> @llvm.arm.neon.vpaddlu.v4i16.v8i8(<8 x i8> %tmp1)
	ret <4 x i16> %tmp2
}

define <2 x i32> @vpaddlu16(<4 x i16>* %A) nounwind {
; CHECK-LABEL: vpaddlu16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr d16, [r0]
; CHECK-NEXT:    vpaddl.u16 d16, d16
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    mov pc, lr
	%tmp1 = load <4 x i16>, <4 x i16>* %A
	%tmp2 = call <2 x i32> @llvm.arm.neon.vpaddlu.v2i32.v4i16(<4 x i16> %tmp1)
	ret <2 x i32> %tmp2
}

define <1 x i64> @vpaddlu32(<2 x i32>* %A) nounwind {
; CHECK-LABEL: vpaddlu32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr d16, [r0]
; CHECK-NEXT:    vpaddl.u32 d16, d16
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    mov pc, lr
	%tmp1 = load <2 x i32>, <2 x i32>* %A
	%tmp2 = call <1 x i64> @llvm.arm.neon.vpaddlu.v1i64.v2i32(<2 x i32> %tmp1)
	ret <1 x i64> %tmp2
}

define <8 x i16> @vpaddlQs8(<16 x i8>* %A) nounwind {
; CHECK-LABEL: vpaddlQs8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vld1.64 {d16, d17}, [r0]
; CHECK-NEXT:    vpaddl.s8 q8, q8
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    vmov r2, r3, d17
; CHECK-NEXT:    mov pc, lr
	%tmp1 = load <16 x i8>, <16 x i8>* %A
	%tmp2 = call <8 x i16> @llvm.arm.neon.vpaddls.v8i16.v16i8(<16 x i8> %tmp1)
	ret <8 x i16> %tmp2
}

define <4 x i32> @vpaddlQs16(<8 x i16>* %A) nounwind {
; CHECK-LABEL: vpaddlQs16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vld1.64 {d16, d17}, [r0]
; CHECK-NEXT:    vpaddl.s16 q8, q8
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    vmov r2, r3, d17
; CHECK-NEXT:    mov pc, lr
	%tmp1 = load <8 x i16>, <8 x i16>* %A
	%tmp2 = call <4 x i32> @llvm.arm.neon.vpaddls.v4i32.v8i16(<8 x i16> %tmp1)
	ret <4 x i32> %tmp2
}

define <2 x i64> @vpaddlQs32(<4 x i32>* %A) nounwind {
; CHECK-LABEL: vpaddlQs32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vld1.64 {d16, d17}, [r0]
; CHECK-NEXT:    vpaddl.s32 q8, q8
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    vmov r2, r3, d17
; CHECK-NEXT:    mov pc, lr
	%tmp1 = load <4 x i32>, <4 x i32>* %A
	%tmp2 = call <2 x i64> @llvm.arm.neon.vpaddls.v2i64.v4i32(<4 x i32> %tmp1)
	ret <2 x i64> %tmp2
}

define <8 x i16> @vpaddlQu8(<16 x i8>* %A) nounwind {
; CHECK-LABEL: vpaddlQu8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vld1.64 {d16, d17}, [r0]
; CHECK-NEXT:    vpaddl.u8 q8, q8
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    vmov r2, r3, d17
; CHECK-NEXT:    mov pc, lr
	%tmp1 = load <16 x i8>, <16 x i8>* %A
	%tmp2 = call <8 x i16> @llvm.arm.neon.vpaddlu.v8i16.v16i8(<16 x i8> %tmp1)
	ret <8 x i16> %tmp2
}

define <4 x i32> @vpaddlQu16(<8 x i16>* %A) nounwind {
; CHECK-LABEL: vpaddlQu16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vld1.64 {d16, d17}, [r0]
; CHECK-NEXT:    vpaddl.u16 q8, q8
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    vmov r2, r3, d17
; CHECK-NEXT:    mov pc, lr
	%tmp1 = load <8 x i16>, <8 x i16>* %A
	%tmp2 = call <4 x i32> @llvm.arm.neon.vpaddlu.v4i32.v8i16(<8 x i16> %tmp1)
	ret <4 x i32> %tmp2
}

define <2 x i64> @vpaddlQu32(<4 x i32>* %A) nounwind {
; CHECK-LABEL: vpaddlQu32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vld1.64 {d16, d17}, [r0]
; CHECK-NEXT:    vpaddl.u32 q8, q8
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    vmov r2, r3, d17
; CHECK-NEXT:    mov pc, lr
	%tmp1 = load <4 x i32>, <4 x i32>* %A
	%tmp2 = call <2 x i64> @llvm.arm.neon.vpaddlu.v2i64.v4i32(<4 x i32> %tmp1)
	ret <2 x i64> %tmp2
}

; Combine vuzp+vadd->vpadd.
define void @addCombineToVPADD_i8(<16 x i8> *%cbcr, <8 x i8> *%X) nounwind ssp {
; CHECK-LABEL: addCombineToVPADD_i8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vld1.64 {d16, d17}, [r0]
; CHECK-NEXT:    vpadd.i8 d16, d16, d17
; CHECK-NEXT:    vstr d16, [r1]
; CHECK-NEXT:    mov pc, lr
  %tmp = load <16 x i8>, <16 x i8>* %cbcr
  %tmp1 = shufflevector <16 x i8> %tmp, <16 x i8> undef, <8 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14>
  %tmp3 = shufflevector <16 x i8> %tmp, <16 x i8> undef, <8 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15>

  %add = add <8 x i8> %tmp3, %tmp1
  store <8 x i8> %add, <8 x i8>* %X, align 8
  ret void
}

; Combine vuzp+vadd->vpadd.
define void @addCombineToVPADD_i16(<8 x i16> *%cbcr, <4 x i16> *%X) nounwind ssp {
; CHECK-LABEL: addCombineToVPADD_i16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vld1.64 {d16, d17}, [r0]
; CHECK-NEXT:    vpadd.i16 d16, d16, d17
; CHECK-NEXT:    vstr d16, [r1]
; CHECK-NEXT:    mov pc, lr
  %tmp = load <8 x i16>, <8 x i16>* %cbcr
  %tmp1 = shufflevector <8 x i16> %tmp, <8 x i16> undef, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
  %tmp3 = shufflevector <8 x i16> %tmp, <8 x i16> undef, <4 x i32> <i32 1, i32 3, i32 5, i32 7>
  %add = add <4 x i16> %tmp3, %tmp1
  store <4 x i16> %add, <4 x i16>* %X, align 8
  ret void
}

; Combine vtrn+vadd->vpadd.
define void @addCombineToVPADD_i32(<4 x i32> *%cbcr, <2 x i32> *%X) nounwind ssp {
; CHECK-LABEL: addCombineToVPADD_i32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vld1.64 {d16, d17}, [r0]
; CHECK-NEXT:    vpadd.i32 d16, d16, d17
; CHECK-NEXT:    vstr d16, [r1]
; CHECK-NEXT:    mov pc, lr
  %tmp = load <4 x i32>, <4 x i32>* %cbcr
  %tmp1 = shufflevector <4 x i32> %tmp, <4 x i32> undef, <2 x i32> <i32 0, i32 2>
  %tmp3 = shufflevector <4 x i32> %tmp, <4 x i32> undef, <2 x i32> <i32 1, i32 3>
  %add = add <2 x i32> %tmp3, %tmp1
  store <2 x i32> %add, <2 x i32>* %X, align 8
  ret void
}

; Combine vuzp+vaddl->vpaddl
define void @addCombineToVPADDLq_s8(<16 x i8> *%cbcr, <8 x i16> *%X) nounwind ssp {
; CHECK-LABEL: addCombineToVPADDLq_s8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vld1.64 {d16, d17}, [r0]
; CHECK-NEXT:    vpaddl.s8 q8, q8
; CHECK-NEXT:    vst1.64 {d16, d17}, [r1]
; CHECK-NEXT:    mov pc, lr
  %tmp = load <16 x i8>, <16 x i8>* %cbcr
  %tmp1 = shufflevector <16 x i8> %tmp, <16 x i8> undef, <8 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14>
  %tmp3 = shufflevector <16 x i8> %tmp, <16 x i8> undef, <8 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15>
  %tmp4 = sext <8 x i8> %tmp3 to <8 x i16>
  %tmp5 = sext <8 x i8> %tmp1 to <8 x i16>
  %add = add <8 x i16> %tmp4, %tmp5
  store <8 x i16> %add, <8 x i16>* %X, align 8
  ret void
}

; Combine vuzp+vaddl->vpaddl
; FIXME: Legalization butchers the shuffles.
define void @addCombineToVPADDL_s8(<16 x i8> *%cbcr, <4 x i16> *%X) nounwind ssp {
; CHECK-LABEL: addCombineToVPADDL_s8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmov.i16	d16, #0x8
; CHECK-NEXT:    vld1.64	{d18, d19}, [r0]
; CHECK-NEXT:    vext.8	d17, d18, d16, #1
; CHECK-NEXT:    vneg.s16	d16, d16
; CHECK-NEXT:    vshl.i16	d18, d18, #8
; CHECK-NEXT:    vshl.i16	d17, d17, #8
; CHECK-NEXT:    vshl.s16	d18, d18, d16
; CHECK-NEXT:    vshl.s16	d16, d17, d16
; CHECK-NEXT:    vadd.i16	d16, d16, d18
; CHECK-NEXT:    vstr	d16, [r1]
; CHECK-NEXT:    mov	pc, lr
  %tmp = load <16 x i8>, <16 x i8>* %cbcr
  %tmp1 = shufflevector <16 x i8> %tmp, <16 x i8> undef, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
  %tmp3 = shufflevector <16 x i8> %tmp, <16 x i8> undef, <4 x i32> <i32 1, i32 3, i32 5, i32 7>
  %tmp4 = sext <4 x i8> %tmp3 to <4 x i16>
  %tmp5 = sext <4 x i8> %tmp1 to <4 x i16>
  %add = add <4 x i16> %tmp4, %tmp5
  store <4 x i16> %add, <4 x i16>* %X, align 8
  ret void
}

; Combine vuzp+vaddl->vpaddl
define void @addCombineToVPADDLq_u8(<16 x i8> *%cbcr, <8 x i16> *%X) nounwind ssp {
; CHECK-LABEL: addCombineToVPADDLq_u8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vld1.64 {d16, d17}, [r0]
; CHECK-NEXT:    vpaddl.u8 q8, q8
; CHECK-NEXT:    vst1.64 {d16, d17}, [r1]
; CHECK-NEXT:    mov pc, lr
  %tmp = load <16 x i8>, <16 x i8>* %cbcr
  %tmp1 = shufflevector <16 x i8> %tmp, <16 x i8> undef, <8 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14>
  %tmp3 = shufflevector <16 x i8> %tmp, <16 x i8> undef, <8 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15>
  %tmp4 = zext <8 x i8> %tmp3 to <8 x i16>
  %tmp5 = zext <8 x i8> %tmp1 to <8 x i16>
  %add = add <8 x i16> %tmp4, %tmp5
  store <8 x i16> %add, <8 x i16>* %X, align 8
  ret void
}

; In theory, it's possible to match this to vpaddl, but rearranging the
; shuffle is awkward, so this doesn't match at the moment.
define void @addCombineToVPADDLq_u8_early_zext(<16 x i8> *%cbcr, <8 x i16> *%X) nounwind ssp {
; CHECK-LABEL: addCombineToVPADDLq_u8_early_zext:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vld1.64 {d16, d17}, [r0]
; CHECK-NEXT:    vmovl.u8 q9, d17
; CHECK-NEXT:    vmovl.u8 q8, d16
; CHECK-NEXT:    vuzp.16 q8, q9
; CHECK-NEXT:    vadd.i16 q8, q8, q9
; CHECK-NEXT:    vst1.64 {d16, d17}, [r1]
; CHECK-NEXT:    mov pc, lr
  %tmp = load <16 x i8>, <16 x i8>* %cbcr
  %tmp1 = zext <16 x i8> %tmp to <16 x i16>
  %tmp2 = shufflevector <16 x i16> %tmp1, <16 x i16> undef, <8 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14>
  %tmp3 = shufflevector <16 x i16> %tmp1, <16 x i16> undef, <8 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15>
  %add = add <8 x i16> %tmp2, %tmp3
  store <8 x i16> %add, <8 x i16>* %X, align 8
  ret void
}

; Combine vuzp+vaddl->vpaddl
; FIXME: Legalization butchers the shuffle.
define void @addCombineToVPADDL_u8(<16 x i8> *%cbcr, <4 x i16> *%X) nounwind ssp {
; CHECK-LABEL: addCombineToVPADDL_u8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vld1.64 {d16, d17}, [r0]
; CHECK-NEXT:    vext.8 d18, d16, d16, #1
; CHECK-NEXT:    vbic.i16 d16, #0xff00
; CHECK-NEXT:    vbic.i16 d18, #0xff00
; CHECK-NEXT:    vadd.i16 d16, d18, d16
; CHECK-NEXT:    vstr d16, [r1]
; CHECK-NEXT:    mov pc, lr
  %tmp = load <16 x i8>, <16 x i8>* %cbcr
  %tmp1 = shufflevector <16 x i8> %tmp, <16 x i8> undef, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
  %tmp3 = shufflevector <16 x i8> %tmp, <16 x i8> undef, <4 x i32> <i32 1, i32 3, i32 5, i32 7>
  %tmp4 = zext <4 x i8> %tmp3 to <4 x i16>
  %tmp5 = zext <4 x i8> %tmp1 to <4 x i16>
  %add = add <4 x i16> %tmp4, %tmp5
  store <4 x i16> %add, <4 x i16>* %X, align 8
  ret void
}

; Matching to vpaddl.8 requires matching shuffle(zext()).
define void @addCombineToVPADDL_u8_early_zext(<16 x i8> *%cbcr, <4 x i16> *%X) nounwind ssp {
; CHECK-LABEL: addCombineToVPADDL_u8_early_zext:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vld1.64 {d16, d17}, [r0]
; CHECK-NEXT:    vmovl.u8 q8, d16
; CHECK-NEXT:    vpadd.i16 d16, d16, d17
; CHECK-NEXT:    vstr d16, [r1]
; CHECK-NEXT:    mov pc, lr
  %tmp = load <16 x i8>, <16 x i8>* %cbcr
  %tmp1 = zext <16 x i8> %tmp to <16 x i16>
  %tmp2 = shufflevector <16 x i16> %tmp1, <16 x i16> undef, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
  %tmp3 = shufflevector <16 x i16> %tmp1, <16 x i16> undef, <4 x i32> <i32 1, i32 3, i32 5, i32 7>
  %add = add <4 x i16> %tmp2, %tmp3
  store <4 x i16> %add, <4 x i16>* %X, align 8
  ret void
}

; Combine vuzp+vaddl->vpaddl
define void @addCombineToVPADDLq_s16(<8 x i16> *%cbcr, <4 x i32> *%X) nounwind ssp {
; CHECK-LABEL: addCombineToVPADDLq_s16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vld1.64 {d16, d17}, [r0]
; CHECK-NEXT:    vpaddl.s16 q8, q8
; CHECK-NEXT:    vst1.64 {d16, d17}, [r1]
; CHECK-NEXT:    mov pc, lr
  %tmp = load <8 x i16>, <8 x i16>* %cbcr
  %tmp1 = shufflevector <8 x i16> %tmp, <8 x i16> undef, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
  %tmp3 = shufflevector <8 x i16> %tmp, <8 x i16> undef, <4 x i32> <i32 1, i32 3, i32 5, i32 7>
  %tmp4 = sext <4 x i16> %tmp3 to <4 x i32>
  %tmp5 = sext <4 x i16> %tmp1 to <4 x i32>
  %add = add <4 x i32> %tmp4, %tmp5
  store <4 x i32> %add, <4 x i32>* %X, align 8
  ret void
}

; Combine vuzp+vaddl->vpaddl
define void @addCombineToVPADDLq_u16(<8 x i16> *%cbcr, <4 x i32> *%X) nounwind ssp {
; CHECK-LABEL: addCombineToVPADDLq_u16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vld1.64 {d16, d17}, [r0]
; CHECK-NEXT:    vpaddl.u16 q8, q8
; CHECK-NEXT:    vst1.64 {d16, d17}, [r1]
; CHECK-NEXT:    mov pc, lr
  %tmp = load <8 x i16>, <8 x i16>* %cbcr
  %tmp1 = shufflevector <8 x i16> %tmp, <8 x i16> undef, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
  %tmp3 = shufflevector <8 x i16> %tmp, <8 x i16> undef, <4 x i32> <i32 1, i32 3, i32 5, i32 7>
  %tmp4 = zext <4 x i16> %tmp3 to <4 x i32>
  %tmp5 = zext <4 x i16> %tmp1 to <4 x i32>
  %add = add <4 x i32> %tmp4, %tmp5
  store <4 x i32> %add, <4 x i32>* %X, align 8
  ret void
}

; Combine vtrn+vaddl->vpaddl
define void @addCombineToVPADDLq_s32(<4 x i32> *%cbcr, <2 x i64> *%X) nounwind ssp {
; CHECK-LABEL: addCombineToVPADDLq_s32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vld1.64 {d16, d17}, [r0]
; CHECK-NEXT:    vpaddl.s32 q8, q8
; CHECK-NEXT:    vst1.64 {d16, d17}, [r1]
; CHECK-NEXT:    mov pc, lr
  %tmp = load <4 x i32>, <4 x i32>* %cbcr
  %tmp1 = shufflevector <4 x i32> %tmp, <4 x i32> undef, <2 x i32> <i32 0, i32 2>
  %tmp3 = shufflevector <4 x i32> %tmp, <4 x i32> undef, <2 x i32> <i32 1, i32 3>
  %tmp4 = sext <2 x i32> %tmp3 to <2 x i64>
  %tmp5 = sext <2 x i32> %tmp1 to <2 x i64>
  %add = add <2 x i64> %tmp4, %tmp5
  store <2 x i64> %add, <2 x i64>* %X, align 8
  ret void
}

; Combine vtrn+vaddl->vpaddl
define void @addCombineToVPADDLq_u32(<4 x i32> *%cbcr, <2 x i64> *%X) nounwind ssp {
; CHECK-LABEL: addCombineToVPADDLq_u32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vld1.64 {d16, d17}, [r0]
; CHECK-NEXT:    vpaddl.u32 q8, q8
; CHECK-NEXT:    vst1.64 {d16, d17}, [r1]
; CHECK-NEXT:    mov pc, lr
  %tmp = load <4 x i32>, <4 x i32>* %cbcr
  %tmp1 = shufflevector <4 x i32> %tmp, <4 x i32> undef, <2 x i32> <i32 0, i32 2>
  %tmp3 = shufflevector <4 x i32> %tmp, <4 x i32> undef, <2 x i32> <i32 1, i32 3>
  %tmp4 = zext <2 x i32> %tmp3 to <2 x i64>
  %tmp5 = zext <2 x i32> %tmp1 to <2 x i64>
  %add = add <2 x i64> %tmp4, %tmp5
  store <2 x i64> %add, <2 x i64>* %X, align 8
  ret void
}

; Legalization promotes the <4 x i8> to <4 x i16>.
define <4 x i8> @fromExtendingExtractVectorElt_i8(<8 x i8> %in) {
; CHECK-LABEL: fromExtendingExtractVectorElt_i8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmov d16, r0, r1
; CHECK-NEXT:    vpaddl.s8 d16, d16
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    mov pc, lr
  %tmp1 = shufflevector <8 x i8> %in, <8 x i8> undef, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
  %tmp2 = shufflevector <8 x i8> %in, <8 x i8> undef, <4 x i32> <i32 1, i32 3, i32 5, i32 7>
  %x = add <4 x i8> %tmp2, %tmp1
  ret <4 x i8> %x
}

; Legalization promotes the <2 x i16> to <2 x i32>.
define <2 x i16> @fromExtendingExtractVectorElt_i16(<4 x i16> %in) {
; CHECK-LABEL: fromExtendingExtractVectorElt_i16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmov d16, r0, r1
; CHECK-NEXT:    vpaddl.s16 d16, d16
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    mov pc, lr
  %tmp1 = shufflevector <4 x i16> %in, <4 x i16> undef, <2 x i32> <i32 0, i32 2>
  %tmp2 = shufflevector <4 x i16> %in, <4 x i16> undef, <2 x i32> <i32 1, i32 3>
  %x = add <2 x i16> %tmp2, %tmp1
  ret <2 x i16> %x
}

; And <2 x i8> to <2 x i32>
define <2 x i8> @fromExtendingExtractVectorElt_2i8(<8 x i8> %in) {
; CHECK-LABEL: fromExtendingExtractVectorElt_2i8:
; CHECK:    vadd.i32
  %tmp1 = shufflevector <8 x i8> %in, <8 x i8> undef, <2 x i32> <i32 0, i32 2>
  %tmp2 = shufflevector <8 x i8> %in, <8 x i8> undef, <2 x i32> <i32 1, i32 3>
  %x = add <2 x i8> %tmp2, %tmp1
  ret <2 x i8> %x
}

define <2 x i16> @fromExtendingExtractVectorElt_2i16(<8 x i16> %in) {
; CHECK-LABEL: fromExtendingExtractVectorElt_2i16:
; CHECK:    vadd.i32
 %tmp1 = shufflevector <8 x i16> %in, <8 x i16> undef, <2 x i32> <i32 0, i32 2>
 %tmp2 = shufflevector <8 x i16> %in, <8 x i16> undef, <2 x i32> <i32 1, i32 3>
 %x = add <2 x i16> %tmp2, %tmp1
 ret <2 x i16> %x
}


declare <4 x i16> @llvm.arm.neon.vpaddls.v4i16.v8i8(<8 x i8>) nounwind readnone
declare <2 x i32> @llvm.arm.neon.vpaddls.v2i32.v4i16(<4 x i16>) nounwind readnone
declare <1 x i64> @llvm.arm.neon.vpaddls.v1i64.v2i32(<2 x i32>) nounwind readnone

declare <4 x i16> @llvm.arm.neon.vpaddlu.v4i16.v8i8(<8 x i8>) nounwind readnone
declare <2 x i32> @llvm.arm.neon.vpaddlu.v2i32.v4i16(<4 x i16>) nounwind readnone
declare <1 x i64> @llvm.arm.neon.vpaddlu.v1i64.v2i32(<2 x i32>) nounwind readnone

declare <8 x i16> @llvm.arm.neon.vpaddls.v8i16.v16i8(<16 x i8>) nounwind readnone
declare <4 x i32> @llvm.arm.neon.vpaddls.v4i32.v8i16(<8 x i16>) nounwind readnone
declare <2 x i64> @llvm.arm.neon.vpaddls.v2i64.v4i32(<4 x i32>) nounwind readnone

declare <8 x i16> @llvm.arm.neon.vpaddlu.v8i16.v16i8(<16 x i8>) nounwind readnone
declare <4 x i32> @llvm.arm.neon.vpaddlu.v4i32.v8i16(<8 x i16>) nounwind readnone
declare <2 x i64> @llvm.arm.neon.vpaddlu.v2i64.v4i32(<4 x i32>) nounwind readnone
