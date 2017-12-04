; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=arm-eabi -mattr=+neon %s -o - | FileCheck %s

define <4 x i32> @test1(<4 x i32> %a) nounwind {
; CHECK-LABEL: test1:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmov d17, r2, r3
; CHECK-NEXT:    vmov d16, r0, r1
; CHECK-NEXT:    vabs.s32 q8, q8
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    vmov r2, r3, d17
; CHECK-NEXT:    mov pc, lr
        %tmp1neg = sub <4 x i32> zeroinitializer, %a
        %b = icmp sgt <4 x i32> %a, <i32 -1, i32 -1, i32 -1, i32 -1>
        %abs = select <4 x i1> %b, <4 x i32> %a, <4 x i32> %tmp1neg
        ret <4 x i32> %abs
}

define <4 x i32> @test2(<4 x i32> %a) nounwind {
; CHECK-LABEL: test2:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmov d17, r2, r3
; CHECK-NEXT:    vmov d16, r0, r1
; CHECK-NEXT:    vabs.s32 q8, q8
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    vmov r2, r3, d17
; CHECK-NEXT:    mov pc, lr
        %tmp1neg = sub <4 x i32> zeroinitializer, %a
        %b = icmp sge <4 x i32> %a, zeroinitializer
        %abs = select <4 x i1> %b, <4 x i32> %a, <4 x i32> %tmp1neg
        ret <4 x i32> %abs
}

define <8 x i16> @test3(<8 x i16> %a) nounwind {
; CHECK-LABEL: test3:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmov d17, r2, r3
; CHECK-NEXT:    vmov d16, r0, r1
; CHECK-NEXT:    vabs.s16 q8, q8
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    vmov r2, r3, d17
; CHECK-NEXT:    mov pc, lr
        %tmp1neg = sub <8 x i16> zeroinitializer, %a
        %b = icmp sgt <8 x i16> %a, zeroinitializer
        %abs = select <8 x i1> %b, <8 x i16> %a, <8 x i16> %tmp1neg
        ret <8 x i16> %abs
}

define <16 x i8> @test4(<16 x i8> %a) nounwind {
; CHECK-LABEL: test4:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmov d17, r2, r3
; CHECK-NEXT:    vmov d16, r0, r1
; CHECK-NEXT:    vabs.s8 q8, q8
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    vmov r2, r3, d17
; CHECK-NEXT:    mov pc, lr
        %tmp1neg = sub <16 x i8> zeroinitializer, %a
        %b = icmp slt <16 x i8> %a, zeroinitializer
        %abs = select <16 x i1> %b, <16 x i8> %tmp1neg, <16 x i8> %a
        ret <16 x i8> %abs
}

define <4 x i32> @test5(<4 x i32> %a) nounwind {
; CHECK-LABEL: test5:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmov d17, r2, r3
; CHECK-NEXT:    vmov d16, r0, r1
; CHECK-NEXT:    vabs.s32 q8, q8
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    vmov r2, r3, d17
; CHECK-NEXT:    mov pc, lr
        %tmp1neg = sub <4 x i32> zeroinitializer, %a
        %b = icmp sle <4 x i32> %a, zeroinitializer
        %abs = select <4 x i1> %b, <4 x i32> %tmp1neg, <4 x i32> %a
        ret <4 x i32> %abs
}

define <2 x i32> @test6(<2 x i32> %a) nounwind {
; CHECK-LABEL: test6:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmov d16, r0, r1
; CHECK-NEXT:    vabs.s32 d16, d16
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    mov pc, lr
        %tmp1neg = sub <2 x i32> zeroinitializer, %a
        %b = icmp sgt <2 x i32> %a, <i32 -1, i32 -1>
        %abs = select <2 x i1> %b, <2 x i32> %a, <2 x i32> %tmp1neg
        ret <2 x i32> %abs
}

define <2 x i32> @test7(<2 x i32> %a) nounwind {
; CHECK-LABEL: test7:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmov d16, r0, r1
; CHECK-NEXT:    vabs.s32 d16, d16
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    mov pc, lr
        %tmp1neg = sub <2 x i32> zeroinitializer, %a
        %b = icmp sge <2 x i32> %a, zeroinitializer
        %abs = select <2 x i1> %b, <2 x i32> %a, <2 x i32> %tmp1neg
        ret <2 x i32> %abs
}

define <4 x i16> @test8(<4 x i16> %a) nounwind {
; CHECK-LABEL: test8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmov d16, r0, r1
; CHECK-NEXT:    vabs.s16 d16, d16
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    mov pc, lr
        %tmp1neg = sub <4 x i16> zeroinitializer, %a
        %b = icmp sgt <4 x i16> %a, zeroinitializer
        %abs = select <4 x i1> %b, <4 x i16> %a, <4 x i16> %tmp1neg
        ret <4 x i16> %abs
}

define <8 x i8> @test9(<8 x i8> %a) nounwind {
; CHECK-LABEL: test9:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmov d16, r0, r1
; CHECK-NEXT:    vabs.s8 d16, d16
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    mov pc, lr
        %tmp1neg = sub <8 x i8> zeroinitializer, %a
        %b = icmp slt <8 x i8> %a, zeroinitializer
        %abs = select <8 x i1> %b, <8 x i8> %tmp1neg, <8 x i8> %a
        ret <8 x i8> %abs
}

define <2 x i32> @test10(<2 x i32> %a) nounwind {
; CHECK-LABEL: test10:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmov d16, r0, r1
; CHECK-NEXT:    vabs.s32 d16, d16
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    mov pc, lr
        %tmp1neg = sub <2 x i32> zeroinitializer, %a
        %b = icmp sle <2 x i32> %a, zeroinitializer
        %abs = select <2 x i1> %b, <2 x i32> %tmp1neg, <2 x i32> %a
        ret <2 x i32> %abs
}

;; Check that absdiff patterns as emitted by log2 shuffles are
;; matched by VABD.

define <4 x i32> @test11(<4 x i16> %a, <4 x i16> %b) nounwind {
; CHECK-LABEL: test11:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmov d16, r2, r3
; CHECK-NEXT:    vmov d17, r0, r1
; CHECK-NEXT:    vabdl.u16 q8, d17, d16
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    vmov r2, r3, d17
; CHECK-NEXT:    mov pc, lr
        %zext1 = zext <4 x i16> %a to <4 x i32>
        %zext2 = zext <4 x i16> %b to <4 x i32>
        %diff = sub <4 x i32> %zext1, %zext2
        %shift1 = ashr <4 x i32> %diff, <i32 31, i32 31, i32 31, i32 31>
        %add1 = add <4 x i32> %shift1, %diff
        %res = xor <4 x i32> %shift1, %add1
        ret <4 x i32> %res
}
define <8 x i16> @test12(<8 x i8> %a, <8 x i8> %b) nounwind {
; CHECK-LABEL: test12:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmov d16, r2, r3
; CHECK-NEXT:    vmov d17, r0, r1
; CHECK-NEXT:    vabdl.u8 q8, d17, d16
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    vmov r2, r3, d17
; CHECK-NEXT:    mov pc, lr
        %zext1 = zext <8 x i8> %a to <8 x i16>
        %zext2 = zext <8 x i8> %b to <8 x i16>
        %diff = sub <8 x i16> %zext1, %zext2
        %shift1 = ashr <8 x i16> %diff,<i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15>
        %add1 = add <8 x i16> %shift1, %diff
        %res = xor <8 x i16> %shift1, %add1
        ret <8 x i16> %res
}

define <2 x i64> @test13(<2 x i32> %a, <2 x i32> %b) nounwind {
; CHECK-LABEL: test13:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmov d16, r2, r3
; CHECK-NEXT:    vmov d17, r0, r1
; CHECK-NEXT:    vabdl.u32 q8, d17, d16
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    vmov r2, r3, d17
; CHECK-NEXT:    mov pc, lr
        %zext1 = zext <2 x i32> %a to <2 x i64>
        %zext2 = zext <2 x i32> %b to <2 x i64>
        %diff = sub <2 x i64> %zext1, %zext2
        %shift1 = ashr <2 x i64> %diff,<i64 63, i64 63>
        %add1 = add <2 x i64> %shift1, %diff
        %res = xor <2 x i64> %shift1, %add1
        ret <2 x i64> %res
}
