; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve.fp -verify-machineinstrs %s -o - | FileCheck %s

define void @vldst4(half* nocapture readonly %pIn, half* nocapture %pOut, i32 %numRows, i32 %numCols, i32 %scale.coerce) #0 {
; CHECK-LABEL: vldst4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r7, lr}
; CHECK-NEXT:    push {r4, r5, r7, lr}
; CHECK-NEXT:    .vsave {d8, d9, d10, d11, d12, d13, d14, d15}
; CHECK-NEXT:    vpush {d8, d9, d10, d11, d12, d13, d14, d15}
; CHECK-NEXT:    .pad #80
; CHECK-NEXT:    sub sp, #80
; CHECK-NEXT:    mul r12, r3, r2
; CHECK-NEXT:    movs r2, #0
; CHECK-NEXT:    cmp.w r2, r12, lsr #2
; CHECK-NEXT:    beq.w .LBB0_3
; CHECK-NEXT:  @ %bb.1: @ %vector.ph
; CHECK-NEXT:    mvn r3, #7
; CHECK-NEXT:    ldr r5, [sp, #160]
; CHECK-NEXT:    and.w r3, r3, r12, lsr #2
; CHECK-NEXT:    sub.w r12, r3, #8
; CHECK-NEXT:    movs r3, #1
; CHECK-NEXT:    add.w lr, r3, r12, lsr #3
; CHECK-NEXT:  .LBB0_2: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrh.u16 q5, [r0, #32]
; CHECK-NEXT:    vldrh.u16 q3, [r0, #48]
; CHECK-NEXT:    vldrh.u16 q7, [r0], #64
; CHECK-NEXT:    vmov r2, s20
; CHECK-NEXT:    vmovx.f16 s8, s12
; CHECK-NEXT:    vmov.16 q0[4], r2
; CHECK-NEXT:    vmov r3, s22
; CHECK-NEXT:    vmov.16 q0[5], r3
; CHECK-NEXT:    vmov r2, s12
; CHECK-NEXT:    vmov.16 q0[6], r2
; CHECK-NEXT:    vmov r2, s28
; CHECK-NEXT:    vldrh.u16 q6, [r0, #-48]
; CHECK-NEXT:    vmov.16 q1[0], r2
; CHECK-NEXT:    vmov r3, s30
; CHECK-NEXT:    vmov.16 q1[1], r3
; CHECK-NEXT:    vmov r2, s24
; CHECK-NEXT:    vmov.16 q1[2], r2
; CHECK-NEXT:    vmov r2, s14
; CHECK-NEXT:    vmov.16 q0[7], r2
; CHECK-NEXT:    vmov r2, s26
; CHECK-NEXT:    vmov.16 q1[3], r2
; CHECK-NEXT:    vmov.f32 s6, s2
; CHECK-NEXT:    vmov.f32 s7, s3
; CHECK-NEXT:    vmul.f16 q0, q1, r5
; CHECK-NEXT:    vmovx.f16 s4, s24
; CHECK-NEXT:    vmov q4, q0
; CHECK-NEXT:    vstrw.32 q0, [sp, #48] @ 16-byte Spill
; CHECK-NEXT:    vmovx.f16 s0, s30
; CHECK-NEXT:    vmov r3, s3
; CHECK-NEXT:    vmov r2, s0
; CHECK-NEXT:    vmovx.f16 s0, s28
; CHECK-NEXT:    vmov r4, s0
; CHECK-NEXT:    vmov.16 q0[0], r4
; CHECK-NEXT:    vmov.16 q0[1], r2
; CHECK-NEXT:    vmov r2, s4
; CHECK-NEXT:    vmovx.f16 s4, s22
; CHECK-NEXT:    vmov.16 q0[2], r2
; CHECK-NEXT:    vmov r2, s4
; CHECK-NEXT:    vmovx.f16 s4, s20
; CHECK-NEXT:    vmov r4, s4
; CHECK-NEXT:    vmov.16 q1[4], r4
; CHECK-NEXT:    vmov.16 q1[5], r2
; CHECK-NEXT:    vmov r2, s8
; CHECK-NEXT:    vmovx.f16 s8, s14
; CHECK-NEXT:    vmov.16 q1[6], r2
; CHECK-NEXT:    vmov r2, s8
; CHECK-NEXT:    vmovx.f16 s8, s26
; CHECK-NEXT:    vmov.16 q1[7], r2
; CHECK-NEXT:    vmov r2, s8
; CHECK-NEXT:    vmov.16 q0[3], r2
; CHECK-NEXT:    vmovx.f16 s8, s13
; CHECK-NEXT:    vmov.f32 s2, s6
; CHECK-NEXT:    vmov.f32 s3, s7
; CHECK-NEXT:    vmov.16 q1[0], r3
; CHECK-NEXT:    vmul.f16 q0, q0, r5
; CHECK-NEXT:    vmov r3, s23
; CHECK-NEXT:    vmov r2, s3
; CHECK-NEXT:    vstrw.32 q0, [sp, #64] @ 16-byte Spill
; CHECK-NEXT:    vmovx.f16 s0, s19
; CHECK-NEXT:    vmov.16 q1[1], r2
; CHECK-NEXT:    vmov r2, s0
; CHECK-NEXT:    vmov.16 q1[4], r2
; CHECK-NEXT:    vmov r2, s21
; CHECK-NEXT:    vmov.16 q0[4], r2
; CHECK-NEXT:    vmov r2, s13
; CHECK-NEXT:    vmov.16 q0[5], r3
; CHECK-NEXT:    vmov r3, s29
; CHECK-NEXT:    vstrw.32 q1, [sp, #16] @ 16-byte Spill
; CHECK-NEXT:    vmov.16 q0[6], r2
; CHECK-NEXT:    vmov r2, s31
; CHECK-NEXT:    vmov.16 q1[0], r3
; CHECK-NEXT:    vmov.16 q1[1], r2
; CHECK-NEXT:    vmov r2, s25
; CHECK-NEXT:    vmov.16 q1[2], r2
; CHECK-NEXT:    vmov r2, s15
; CHECK-NEXT:    vmov.16 q0[7], r2
; CHECK-NEXT:    vmov r2, s27
; CHECK-NEXT:    vmov.16 q1[3], r2
; CHECK-NEXT:    vmov.f32 s6, s2
; CHECK-NEXT:    vmov.f32 s7, s3
; CHECK-NEXT:    vmovx.f16 s0, s31
; CHECK-NEXT:    vmov r2, s0
; CHECK-NEXT:    vmovx.f16 s0, s29
; CHECK-NEXT:    vmov r4, s0
; CHECK-NEXT:    vmul.f16 q4, q1, r5
; CHECK-NEXT:    vmov.16 q0[0], r4
; CHECK-NEXT:    vmovx.f16 s4, s25
; CHECK-NEXT:    vmov.16 q0[1], r2
; CHECK-NEXT:    vmov r2, s4
; CHECK-NEXT:    vmovx.f16 s4, s23
; CHECK-NEXT:    vmov.16 q0[2], r2
; CHECK-NEXT:    vmov r2, s4
; CHECK-NEXT:    vmovx.f16 s4, s21
; CHECK-NEXT:    vmov r4, s4
; CHECK-NEXT:    vstrw.32 q4, [sp, #32] @ 16-byte Spill
; CHECK-NEXT:    vmov.16 q1[4], r4
; CHECK-NEXT:    vmov r3, s16
; CHECK-NEXT:    vmov.16 q1[5], r2
; CHECK-NEXT:    vmov r2, s8
; CHECK-NEXT:    vmovx.f16 s8, s15
; CHECK-NEXT:    vmov.16 q1[6], r2
; CHECK-NEXT:    vmov r2, s8
; CHECK-NEXT:    vmovx.f16 s8, s27
; CHECK-NEXT:    vmov.16 q1[7], r2
; CHECK-NEXT:    vmov r2, s8
; CHECK-NEXT:    vmov.16 q0[3], r2
; CHECK-NEXT:    vldrw.u32 q2, [sp, #48] @ 16-byte Reload
; CHECK-NEXT:    vmov.f32 s2, s6
; CHECK-NEXT:    vmov.f32 s3, s7
; CHECK-NEXT:    vmov.16 q1[2], r3
; CHECK-NEXT:    vmul.f16 q6, q0, r5
; CHECK-NEXT:    vmovx.f16 s0, s16
; CHECK-NEXT:    vmov r2, s24
; CHECK-NEXT:    vmov.16 q1[3], r2
; CHECK-NEXT:    vmov r2, s0
; CHECK-NEXT:    vmovx.f16 s0, s24
; CHECK-NEXT:    vmov.16 q1[6], r2
; CHECK-NEXT:    vmov r2, s0
; CHECK-NEXT:    vmovx.f16 s0, s8
; CHECK-NEXT:    vmov.16 q1[7], r2
; CHECK-NEXT:    vmov r2, s8
; CHECK-NEXT:    vstrw.32 q1, [sp] @ 16-byte Spill
; CHECK-NEXT:    vldrw.u32 q1, [sp, #64] @ 16-byte Reload
; CHECK-NEXT:    vmov.16 q5[0], r2
; CHECK-NEXT:    vmov r2, s0
; CHECK-NEXT:    vmov r3, s4
; CHECK-NEXT:    vmovx.f16 s0, s4
; CHECK-NEXT:    vmov.16 q5[1], r3
; CHECK-NEXT:    vmov r3, s25
; CHECK-NEXT:    vmov.16 q5[4], r2
; CHECK-NEXT:    vmov r2, s0
; CHECK-NEXT:    vmov.16 q5[5], r2
; CHECK-NEXT:    vmov r2, s17
; CHECK-NEXT:    vmov.16 q3[2], r2
; CHECK-NEXT:    vmovx.f16 s0, s17
; CHECK-NEXT:    vmov.16 q3[3], r3
; CHECK-NEXT:    vmov r2, s0
; CHECK-NEXT:    vmovx.f16 s0, s25
; CHECK-NEXT:    vmov.16 q3[6], r2
; CHECK-NEXT:    vmov r2, s0
; CHECK-NEXT:    vmovx.f16 s0, s9
; CHECK-NEXT:    vmov.16 q3[7], r2
; CHECK-NEXT:    vmov r2, s9
; CHECK-NEXT:    vmov.16 q7[0], r2
; CHECK-NEXT:    vmov r3, s5
; CHECK-NEXT:    vmov.16 q7[1], r3
; CHECK-NEXT:    vmov r2, s0
; CHECK-NEXT:    vmovx.f16 s0, s5
; CHECK-NEXT:    vmov.16 q7[4], r2
; CHECK-NEXT:    vmov r2, s0
; CHECK-NEXT:    vldrw.u32 q0, [sp, #32] @ 16-byte Reload
; CHECK-NEXT:    vmov.16 q7[5], r2
; CHECK-NEXT:    vmov r3, s26
; CHECK-NEXT:    vmov r2, s2
; CHECK-NEXT:    vmovx.f16 s0, s2
; CHECK-NEXT:    vmov.16 q2[2], r2
; CHECK-NEXT:    vmov q4, q1
; CHECK-NEXT:    vldrw.u32 q1, [sp, #48] @ 16-byte Reload
; CHECK-NEXT:    vmov.16 q2[3], r3
; CHECK-NEXT:    vmov r2, s0
; CHECK-NEXT:    vmovx.f16 s0, s26
; CHECK-NEXT:    vmov.16 q2[6], r2
; CHECK-NEXT:    vmov r2, s0
; CHECK-NEXT:    vmov.16 q2[7], r2
; CHECK-NEXT:    vmov r2, s6
; CHECK-NEXT:    vmov r3, s18
; CHECK-NEXT:    vmov.16 q0[0], r2
; CHECK-NEXT:    vmovx.f16 s4, s6
; CHECK-NEXT:    vmov.16 q0[1], r3
; CHECK-NEXT:    vmov r2, s4
; CHECK-NEXT:    vmovx.f16 s4, s18
; CHECK-NEXT:    vldrw.u32 q4, [sp, #32] @ 16-byte Reload
; CHECK-NEXT:    vmov.16 q0[4], r2
; CHECK-NEXT:    vmov r2, s4
; CHECK-NEXT:    vmov.16 q0[5], r2
; CHECK-NEXT:    vmov r2, s19
; CHECK-NEXT:    vmov r3, s27
; CHECK-NEXT:    vmov.16 q1[2], r2
; CHECK-NEXT:    vmovx.f16 s16, s19
; CHECK-NEXT:    vmov.16 q1[3], r3
; CHECK-NEXT:    vmov r2, s16
; CHECK-NEXT:    vmovx.f16 s16, s27
; CHECK-NEXT:    vmov.16 q1[6], r2
; CHECK-NEXT:    vmov r2, s16
; CHECK-NEXT:    vldrw.u32 q4, [sp, #64] @ 16-byte Reload
; CHECK-NEXT:    vmov.16 q1[7], r2
; CHECK-NEXT:    vmov.f32 s1, s9
; CHECK-NEXT:    vldrw.u32 q6, [sp] @ 16-byte Reload
; CHECK-NEXT:    vmovx.f16 s16, s19
; CHECK-NEXT:    vmov.f32 s3, s11
; CHECK-NEXT:    vmov r2, s16
; CHECK-NEXT:    vldrw.u32 q4, [sp, #16] @ 16-byte Reload
; CHECK-NEXT:    vmov.f32 s21, s25
; CHECK-NEXT:    vstrh.16 q0, [r1, #32]
; CHECK-NEXT:    vmov.16 q4[5], r2
; CHECK-NEXT:    vmov.f32 s29, s13
; CHECK-NEXT:    vmov q2, q4
; CHECK-NEXT:    vmov.f32 s23, s27
; CHECK-NEXT:    vmov.f32 s9, s5
; CHECK-NEXT:    vmov.f32 s11, s7
; CHECK-NEXT:    vstrh.16 q2, [r1, #48]
; CHECK-NEXT:    vstrh.16 q5, [r1], #64
; CHECK-NEXT:    vmov.f32 s31, s15
; CHECK-NEXT:    vstrh.16 q7, [r1, #-48]
; CHECK-NEXT:    le lr, .LBB0_2
; CHECK-NEXT:  .LBB0_3: @ %while.end
; CHECK-NEXT:    add sp, #80
; CHECK-NEXT:    vpop {d8, d9, d10, d11, d12, d13, d14, d15}
; CHECK-NEXT:    pop {r4, r5, r7, pc}
entry:
  %tmp.0.extract.trunc = trunc i32 %scale.coerce to i16
  %l0 = bitcast i16 %tmp.0.extract.trunc to half
  %mul = mul i32 %numCols, %numRows
  %shr = lshr i32 %mul, 2
  %cmp38 = icmp eq i32 %shr, 0
  br i1 %cmp38, label %while.end, label %vector.ph

vector.ph:                                        ; preds = %vector.memcheck
  %n.vec = and i32 %shr, 1073741816
  %l2 = shl nuw i32 %n.vec, 2
  %ind.end = getelementptr half, half* %pIn, i32 %l2
  %l3 = shl nuw i32 %n.vec, 2
  %ind.end48 = getelementptr half, half* %pOut, i32 %l3
  %ind.end50 = sub nsw i32 %shr, %n.vec
  %broadcast.splatinsert55 = insertelement <8 x half> undef, half %l0, i32 0
  %broadcast.splat56 = shufflevector <8 x half> %broadcast.splatinsert55, <8 x half> undef, <8 x i32> zeroinitializer
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %l4 = shl i32 %index, 2
  %next.gep = getelementptr half, half* %pIn, i32 %l4
  %l5 = shl i32 %index, 2
  %l6 = bitcast half* %next.gep to <32 x half>*
  %wide.vec = load <32 x half>, <32 x half>* %l6, align 2
  %strided.vec = shufflevector <32 x half> %wide.vec, <32 x half> undef, <8 x i32> <i32 0, i32 4, i32 8, i32 12, i32 16, i32 20, i32 24, i32 28>
  %strided.vec52 = shufflevector <32 x half> %wide.vec, <32 x half> undef, <8 x i32> <i32 1, i32 5, i32 9, i32 13, i32 17, i32 21, i32 25, i32 29>
  %strided.vec53 = shufflevector <32 x half> %wide.vec, <32 x half> undef, <8 x i32> <i32 2, i32 6, i32 10, i32 14, i32 18, i32 22, i32 26, i32 30>
  %strided.vec54 = shufflevector <32 x half> %wide.vec, <32 x half> undef, <8 x i32> <i32 3, i32 7, i32 11, i32 15, i32 19, i32 23, i32 27, i32 31>
  %l7 = fmul <8 x half> %strided.vec, %broadcast.splat56
  %l8 = fmul <8 x half> %strided.vec52, %broadcast.splat56
  %l9 = fmul <8 x half> %strided.vec53, %broadcast.splat56
  %l10 = fmul <8 x half> %strided.vec54, %broadcast.splat56
  %l11 = getelementptr inbounds half, half* %pOut, i32 %l5
  %l12 = bitcast half* %l11 to <32 x half>*
  %l13 = shufflevector <8 x half> %l7, <8 x half> %l8, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %l14 = shufflevector <8 x half> %l9, <8 x half> %l10, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %interleaved.vec = shufflevector <16 x half> %l13, <16 x half> %l14, <32 x i32> <i32 0, i32 8, i32 16, i32 24, i32 1, i32 9, i32 17, i32 25, i32 2, i32 10, i32 18, i32 26, i32 3, i32 11, i32 19, i32 27, i32 4, i32 12, i32 20, i32 28, i32 5, i32 13, i32 21, i32 29, i32 6, i32 14, i32 22, i32 30, i32 7, i32 15, i32 23, i32 31>
  store <32 x half> %interleaved.vec, <32 x half>* %l12, align 2
  %index.next = add i32 %index, 8
  %l15 = icmp eq i32 %index.next, %n.vec
  br i1 %l15, label %while.end, label %vector.body

while.end:                                        ; preds = %while.body, %middle.block, %entry
  ret void
}
