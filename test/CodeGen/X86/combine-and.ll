; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64-unknown-unknown -mattr=+sse4.1 < %s | FileCheck %s

define i32 @and_self(i32 %x) {
; CHECK-LABEL: and_self:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    retq
  %and = and i32 %x, %x
  ret i32 %and
}

define <4 x i32> @and_self_vec(<4 x i32> %x) {
; CHECK-LABEL: and_self_vec:
; CHECK:       # %bb.0:
; CHECK-NEXT:    retq
  %and = and <4 x i32> %x, %x
  ret <4 x i32> %and
}

;
; Verify that the DAGCombiner is able to fold a vector AND into a blend
; if one of the operands to the AND is a vector of all constants, and each
; constant element is either zero or all-ones.
;

define <4 x i32> @test1(<4 x i32> %A) {
; CHECK-LABEL: test1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pxor %xmm1, %xmm1
; CHECK-NEXT:    pblendw {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3,4,5,6,7]
; CHECK-NEXT:    retq
  %1 = and <4 x i32> %A, <i32 -1, i32 0, i32 0, i32 0>
  ret <4 x i32> %1
}

define <4 x i32> @test2(<4 x i32> %A) {
; CHECK-LABEL: test2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pxor %xmm1, %xmm1
; CHECK-NEXT:    pblendw {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3],xmm1[4,5,6,7]
; CHECK-NEXT:    retq
  %1 = and <4 x i32> %A, <i32 0, i32 -1, i32 0, i32 0>
  ret <4 x i32> %1
}

define <4 x i32> @test3(<4 x i32> %A) {
; CHECK-LABEL: test3:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pxor %xmm1, %xmm1
; CHECK-NEXT:    pblendw {{.*#+}} xmm0 = xmm1[0,1,2,3],xmm0[4,5],xmm1[6,7]
; CHECK-NEXT:    retq
  %1 = and <4 x i32> %A, <i32 0, i32 0, i32 -1, i32 0>
  ret <4 x i32> %1
}

define <4 x i32> @test4(<4 x i32> %A) {
; CHECK-LABEL: test4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pxor %xmm1, %xmm1
; CHECK-NEXT:    pblendw {{.*#+}} xmm0 = xmm1[0,1,2,3,4,5],xmm0[6,7]
; CHECK-NEXT:    retq
  %1 = and <4 x i32> %A, <i32 0, i32 0, i32 0, i32 -1>
  ret <4 x i32> %1
}

define <4 x i32> @test5(<4 x i32> %A) {
; CHECK-LABEL: test5:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pxor %xmm1, %xmm1
; CHECK-NEXT:    pblendw {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3],xmm0[4,5],xmm1[6,7]
; CHECK-NEXT:    retq
  %1 = and <4 x i32> %A, <i32 -1, i32 0, i32 -1, i32 0>
  ret <4 x i32> %1
}

define <4 x i32> @test6(<4 x i32> %A) {
; CHECK-LABEL: test6:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pxor %xmm1, %xmm1
; CHECK-NEXT:    pblendw {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3],xmm1[4,5],xmm0[6,7]
; CHECK-NEXT:    retq
  %1 = and <4 x i32> %A, <i32 0, i32 -1, i32 0, i32 -1>
  ret <4 x i32> %1
}

define <4 x i32> @test7(<4 x i32> %A) {
; CHECK-LABEL: test7:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pxor %xmm1, %xmm1
; CHECK-NEXT:    pblendw {{.*#+}} xmm0 = xmm1[0,1,2,3],xmm0[4,5,6,7]
; CHECK-NEXT:    retq
  %1 = and <4 x i32> %A, <i32 0, i32 0, i32 -1, i32 -1>
  ret <4 x i32> %1
}

define <4 x i32> @test8(<4 x i32> %A) {
; CHECK-LABEL: test8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pxor %xmm1, %xmm1
; CHECK-NEXT:    pblendw {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3,4,5],xmm0[6,7]
; CHECK-NEXT:    retq
  %1 = and <4 x i32> %A, <i32 -1, i32 0, i32 0, i32 -1>
  ret <4 x i32> %1
}

define <4 x i32> @test9(<4 x i32> %A) {
; CHECK-LABEL: test9:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq {{.*#+}} xmm0 = xmm0[0],zero
; CHECK-NEXT:    retq
  %1 = and <4 x i32> %A, <i32 -1, i32 -1, i32 0, i32 0>
  ret <4 x i32> %1
}

define <4 x i32> @test10(<4 x i32> %A) {
; CHECK-LABEL: test10:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pxor %xmm1, %xmm1
; CHECK-NEXT:    pblendw {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3,4,5],xmm1[6,7]
; CHECK-NEXT:    retq
  %1 = and <4 x i32> %A, <i32 0, i32 -1, i32 -1, i32 0>
  ret <4 x i32> %1
}

define <4 x i32> @test11(<4 x i32> %A) {
; CHECK-LABEL: test11:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pxor %xmm1, %xmm1
; CHECK-NEXT:    pblendw {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3,4,5,6,7]
; CHECK-NEXT:    retq
  %1 = and <4 x i32> %A, <i32 0, i32 -1, i32 -1, i32 -1>
  ret <4 x i32> %1
}

define <4 x i32> @test12(<4 x i32> %A) {
; CHECK-LABEL: test12:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pxor %xmm1, %xmm1
; CHECK-NEXT:    pblendw {{.*#+}} xmm0 = xmm0[0,1,2,3,4,5],xmm1[6,7]
; CHECK-NEXT:    retq
  %1 = and <4 x i32> %A, <i32 -1, i32 -1, i32 -1, i32 0>
  ret <4 x i32> %1
}

define <4 x i32> @test13(<4 x i32> %A) {
; CHECK-LABEL: test13:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pxor %xmm1, %xmm1
; CHECK-NEXT:    pblendw {{.*#+}} xmm0 = xmm0[0,1,2,3],xmm1[4,5],xmm0[6,7]
; CHECK-NEXT:    retq
  %1 = and <4 x i32> %A, <i32 -1, i32 -1, i32 0, i32 -1>
  ret <4 x i32> %1
}

define <4 x i32> @test14(<4 x i32> %A) {
; CHECK-LABEL: test14:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pxor %xmm1, %xmm1
; CHECK-NEXT:    pblendw {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3],xmm0[4,5,6,7]
; CHECK-NEXT:    retq
  %1 = and <4 x i32> %A, <i32 -1, i32 0, i32 -1, i32 -1>
  ret <4 x i32> %1
}

define <4 x i32> @test15(<4 x i32> %A, <4 x i32> %B) {
; CHECK-LABEL: test15:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pblendw {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3],xmm0[4,5,6,7]
; CHECK-NEXT:    retq
  %1 = and <4 x i32> %A, <i32 -1, i32 0, i32 -1, i32 -1>
  %2 = and <4 x i32> %B, <i32 0, i32 -1, i32 0, i32 0>
  %3 = or <4 x i32> %1, %2
  ret <4 x i32> %3
}

define <4 x i32> @test16(<4 x i32> %A, <4 x i32> %B) {
; CHECK-LABEL: test16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pblendw {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3],xmm0[4,5],xmm1[6,7]
; CHECK-NEXT:    retq
  %1 = and <4 x i32> %A, <i32 -1, i32 0, i32 -1, i32 0>
  %2 = and <4 x i32> %B, <i32 0, i32 -1, i32 0, i32 -1>
  %3 = or <4 x i32> %1, %2
  ret <4 x i32> %3
}

define <4 x i32> @test17(<4 x i32> %A, <4 x i32> %B) {
; CHECK-LABEL: test17:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pblendw {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3],xmm1[4,5],xmm0[6,7]
; CHECK-NEXT:    retq
  %1 = and <4 x i32> %A, <i32 0, i32 -1, i32 0, i32 -1>
  %2 = and <4 x i32> %B, <i32 -1, i32 0, i32 -1, i32 0>
  %3 = or <4 x i32> %1, %2
  ret <4 x i32> %3
}

;
; fold (and (or x, C), D) -> D if (C & D) == D
;

define <2 x i64> @and_or_v2i64(<2 x i64> %a0) {
; CHECK-LABEL: and_or_v2i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movaps {{.*#+}} xmm0 = [8,8]
; CHECK-NEXT:    retq
  %1 = or <2 x i64> %a0, <i64 255, i64 255>
  %2 = and <2 x i64> %1, <i64 8, i64 8>
  ret <2 x i64> %2
}

define <4 x i32> @and_or_v4i32(<4 x i32> %a0) {
; CHECK-LABEL: and_or_v4i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movaps {{.*#+}} xmm0 = [3,3,3,3]
; CHECK-NEXT:    retq
  %1 = or <4 x i32> %a0, <i32 15, i32 15, i32 15, i32 15>
  %2 = and <4 x i32> %1, <i32 3, i32 3, i32 3, i32 3>
  ret <4 x i32> %2
}

;
; known bits folding
;

define <2 x i64> @and_or_zext_v2i32(<2 x i32> %a0) {
; CHECK-LABEL: and_or_zext_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorps %xmm0, %xmm0
; CHECK-NEXT:    retq
  %1 = zext <2 x i32> %a0 to <2 x i64>
  %2 = or <2 x i64> %1, <i64 1, i64 1>
  %3 = and <2 x i64> %2, <i64 4294967296, i64 4294967296>
  ret <2 x i64> %3
}

define <4 x i32> @and_or_zext_v4i16(<4 x i16> %a0) {
; CHECK-LABEL: and_or_zext_v4i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorps %xmm0, %xmm0
; CHECK-NEXT:    retq
  %1 = zext <4 x i16> %a0 to <4 x i32>
  %2 = or <4 x i32> %1, <i32 1, i32 1, i32 1, i32 1>
  %3 = and <4 x i32> %2, <i32 65536, i32 65536, i32 65536, i32 65536>
  ret <4 x i32> %3
}

;
; known sign bits folding
;

define <8 x i16> @ashr_mask1_v8i16(<8 x i16> %a0) {
; CHECK-LABEL: ashr_mask1_v8i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    psrlw $15, %xmm0
; CHECK-NEXT:    retq
  %1 = ashr <8 x i16> %a0, <i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15>
  %2 = and <8 x i16> %1, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  ret <8 x i16> %2
}

define <4 x i32> @ashr_mask7_v4i32(<4 x i32> %a0) {
; CHECK-LABEL: ashr_mask7_v4i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    psrad $31, %xmm0
; CHECK-NEXT:    psrld $29, %xmm0
; CHECK-NEXT:    retq
  %1 = ashr <4 x i32> %a0, <i32 31, i32 31, i32 31, i32 31>
  %2 = and <4 x i32> %1, <i32 7, i32 7, i32 7, i32 7>
  ret <4 x i32> %2
}

;
; SimplifyDemandedBits
;

; PR34620 - redundant PAND after vector shift of a byte vector (PSRLW)
define <16 x i8> @PR34620(<16 x i8> %a0, <16 x i8> %a1) {
; CHECK-LABEL: PR34620:
; CHECK:       # %bb.0:
; CHECK-NEXT:    psrlw $1, %xmm0
; CHECK-NEXT:    pand {{.*}}(%rip), %xmm0
; CHECK-NEXT:    pand {{.*}}(%rip), %xmm0
; CHECK-NEXT:    paddb %xmm1, %xmm0
; CHECK-NEXT:    retq
  %1 = lshr <16 x i8> %a0, <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>
  %2 = and <16 x i8> %1, <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>
  %3 = add <16 x i8> %2, %a1
  ret <16 x i8> %3
}
