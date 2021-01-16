; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve.fp,+fp64 -verify-machineinstrs %s -o - | FileCheck %s

define void @arm_cmplx_mag_squared_f16(half* nocapture readonly %pSrc, half* nocapture %pDst, i32 %numSamples) {
; CHECK-LABEL: arm_cmplx_mag_squared_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r7, lr}
; CHECK-NEXT:    push {r4, r5, r7, lr}
; CHECK-NEXT:    cbz r2, .LBB0_8
; CHECK-NEXT:  @ %bb.1: @ %while.body.preheader
; CHECK-NEXT:    cmp r2, #8
; CHECK-NEXT:    blo .LBB0_9
; CHECK-NEXT:  @ %bb.2: @ %vector.memcheck
; CHECK-NEXT:    add.w r3, r0, r2, lsl #2
; CHECK-NEXT:    cmp r3, r1
; CHECK-NEXT:    itt hi
; CHECK-NEXT:    addhi.w r3, r1, r2, lsl #1
; CHECK-NEXT:    cmphi r3, r0
; CHECK-NEXT:    bhi .LBB0_9
; CHECK-NEXT:  @ %bb.3: @ %vector.ph
; CHECK-NEXT:    bic r4, r2, #7
; CHECK-NEXT:    movs r5, #1
; CHECK-NEXT:    sub.w r3, r4, #8
; CHECK-NEXT:    add.w r12, r1, r4, lsl #1
; CHECK-NEXT:    add.w lr, r5, r3, lsr #3
; CHECK-NEXT:    add.w r3, r0, r4, lsl #2
; CHECK-NEXT:    dls lr, lr
; CHECK-NEXT:    and r5, r2, #7
; CHECK-NEXT:  .LBB0_4: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vld20.16 {q0, q1}, [r0]
; CHECK-NEXT:    vld21.16 {q0, q1}, [r0]!
; CHECK-NEXT:    vmul.f16 q2, q0, q0
; CHECK-NEXT:    vfma.f16 q2, q1, q1
; CHECK-NEXT:    vstrb.8 q2, [r1], #16
; CHECK-NEXT:    le lr, .LBB0_4
; CHECK-NEXT:  @ %bb.5: @ %middle.block
; CHECK-NEXT:    cmp r4, r2
; CHECK-NEXT:    it eq
; CHECK-NEXT:    popeq {r4, r5, r7, pc}
; CHECK-NEXT:  .LBB0_6: @ %while.body.preheader26
; CHECK-NEXT:    dls lr, r5
; CHECK-NEXT:  .LBB0_7: @ %while.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldr.16 s0, [r3]
; CHECK-NEXT:    vldr.16 s2, [r3, #2]
; CHECK-NEXT:    adds r3, #4
; CHECK-NEXT:    vmul.f16 s0, s0, s0
; CHECK-NEXT:    vfma.f16 s0, s2, s2
; CHECK-NEXT:    vstr.16 s0, [r12]
; CHECK-NEXT:    add.w r12, r12, #2
; CHECK-NEXT:    le lr, .LBB0_7
; CHECK-NEXT:  .LBB0_8: @ %while.end
; CHECK-NEXT:    pop {r4, r5, r7, pc}
; CHECK-NEXT:  .LBB0_9:
; CHECK-NEXT:    mov r3, r0
; CHECK-NEXT:    mov r12, r1
; CHECK-NEXT:    mov r5, r2
; CHECK-NEXT:    b .LBB0_6
entry:
  %cmp.not11 = icmp eq i32 %numSamples, 0
  br i1 %cmp.not11, label %while.end, label %while.body.preheader

while.body.preheader:                             ; preds = %entry
  %min.iters.check = icmp ult i32 %numSamples, 8
  br i1 %min.iters.check, label %while.body.preheader26, label %vector.memcheck

vector.memcheck:                                  ; preds = %while.body.preheader
  %scevgep = getelementptr half, half* %pDst, i32 %numSamples
  %0 = shl i32 %numSamples, 1
  %scevgep18 = getelementptr half, half* %pSrc, i32 %0
  %bound0 = icmp ugt half* %scevgep18, %pDst
  %bound1 = icmp ugt half* %scevgep, %pSrc
  %found.conflict = and i1 %bound0, %bound1
  br i1 %found.conflict, label %while.body.preheader26, label %vector.ph

vector.ph:                                        ; preds = %vector.memcheck
  %n.vec = and i32 %numSamples, -8
  %1 = shl i32 %n.vec, 1
  %ind.end = getelementptr half, half* %pSrc, i32 %1
  %ind.end21 = getelementptr half, half* %pDst, i32 %n.vec
  %ind.end23 = and i32 %numSamples, 7
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %2 = shl i32 %index, 1
  %next.gep = getelementptr half, half* %pSrc, i32 %2
  %next.gep24 = getelementptr half, half* %pDst, i32 %index
  %3 = bitcast half* %next.gep to <16 x half>*
  %wide.vec = load <16 x half>, <16 x half>* %3, align 2
  %4 = fmul fast <16 x half> %wide.vec, %wide.vec
  %5 = shufflevector <16 x half> %4, <16 x half> undef, <8 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14>
  %6 = fmul fast <16 x half> %wide.vec, %wide.vec
  %7 = shufflevector <16 x half> %6, <16 x half> undef, <8 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15>
  %8 = fadd fast <8 x half> %7, %5
  %9 = bitcast half* %next.gep24 to <8 x half>*
  store <8 x half> %8, <8 x half>* %9, align 2
  %index.next = add i32 %index, 8
  %10 = icmp eq i32 %index.next, %n.vec
  br i1 %10, label %middle.block, label %vector.body

middle.block:                                     ; preds = %vector.body
  %cmp.n = icmp eq i32 %n.vec, %numSamples
  br i1 %cmp.n, label %while.end, label %while.body.preheader26

while.body.preheader26:                           ; preds = %middle.block, %vector.memcheck, %while.body.preheader
  %pSrc.addr.014.ph = phi half* [ %pSrc, %vector.memcheck ], [ %pSrc, %while.body.preheader ], [ %ind.end, %middle.block ]
  %pDst.addr.013.ph = phi half* [ %pDst, %vector.memcheck ], [ %pDst, %while.body.preheader ], [ %ind.end21, %middle.block ]
  %blkCnt.012.ph = phi i32 [ %numSamples, %vector.memcheck ], [ %numSamples, %while.body.preheader ], [ %ind.end23, %middle.block ]
  br label %while.body

while.body:                                       ; preds = %while.body.preheader26, %while.body
  %pSrc.addr.014 = phi half* [ %incdec.ptr1, %while.body ], [ %pSrc.addr.014.ph, %while.body.preheader26 ]
  %pDst.addr.013 = phi half* [ %incdec.ptr3, %while.body ], [ %pDst.addr.013.ph, %while.body.preheader26 ]
  %blkCnt.012 = phi i32 [ %dec, %while.body ], [ %blkCnt.012.ph, %while.body.preheader26 ]
  %incdec.ptr = getelementptr inbounds half, half* %pSrc.addr.014, i32 1
  %11 = load half, half* %pSrc.addr.014, align 2
  %incdec.ptr1 = getelementptr inbounds half, half* %pSrc.addr.014, i32 2
  %12 = load half, half* %incdec.ptr, align 2
  %mul = fmul fast half %11, %11
  %mul2 = fmul fast half %12, %12
  %add = fadd fast half %mul2, %mul
  %incdec.ptr3 = getelementptr inbounds half, half* %pDst.addr.013, i32 1
  store half %add, half* %pDst.addr.013, align 2
  %dec = add i32 %blkCnt.012, -1
  %cmp.not = icmp eq i32 %dec, 0
  br i1 %cmp.not, label %while.end, label %while.body

while.end:                                        ; preds = %while.body, %middle.block, %entry
  ret void
}

define void @arm_cmplx_mag_squared_f32(float* nocapture readonly %pSrc, float* nocapture %pDst, i32 %numSamples) {
; CHECK-LABEL: arm_cmplx_mag_squared_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r7, lr}
; CHECK-NEXT:    push {r4, r5, r7, lr}
; CHECK-NEXT:    cbz r2, .LBB1_8
; CHECK-NEXT:  @ %bb.1: @ %while.body.preheader
; CHECK-NEXT:    cmp r2, #4
; CHECK-NEXT:    blo .LBB1_9
; CHECK-NEXT:  @ %bb.2: @ %vector.memcheck
; CHECK-NEXT:    add.w r3, r0, r2, lsl #3
; CHECK-NEXT:    cmp r3, r1
; CHECK-NEXT:    itt hi
; CHECK-NEXT:    addhi.w r3, r1, r2, lsl #2
; CHECK-NEXT:    cmphi r3, r0
; CHECK-NEXT:    bhi .LBB1_9
; CHECK-NEXT:  @ %bb.3: @ %vector.ph
; CHECK-NEXT:    bic r4, r2, #3
; CHECK-NEXT:    movs r5, #1
; CHECK-NEXT:    subs r3, r4, #4
; CHECK-NEXT:    add.w r12, r1, r4, lsl #2
; CHECK-NEXT:    add.w lr, r5, r3, lsr #2
; CHECK-NEXT:    add.w r3, r0, r4, lsl #3
; CHECK-NEXT:    dls lr, lr
; CHECK-NEXT:    and r5, r2, #3
; CHECK-NEXT:  .LBB1_4: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vld20.32 {q0, q1}, [r0]
; CHECK-NEXT:    vld21.32 {q0, q1}, [r0]!
; CHECK-NEXT:    vmul.f32 q2, q0, q0
; CHECK-NEXT:    vfma.f32 q2, q1, q1
; CHECK-NEXT:    vstrb.8 q2, [r1], #16
; CHECK-NEXT:    le lr, .LBB1_4
; CHECK-NEXT:  @ %bb.5: @ %middle.block
; CHECK-NEXT:    cmp r4, r2
; CHECK-NEXT:    it eq
; CHECK-NEXT:    popeq {r4, r5, r7, pc}
; CHECK-NEXT:  .LBB1_6: @ %while.body.preheader26
; CHECK-NEXT:    dls lr, r5
; CHECK-NEXT:  .LBB1_7: @ %while.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldr s0, [r3]
; CHECK-NEXT:    vldr s2, [r3, #4]
; CHECK-NEXT:    adds r3, #8
; CHECK-NEXT:    vmul.f32 s0, s0, s0
; CHECK-NEXT:    vfma.f32 s0, s2, s2
; CHECK-NEXT:    vstr s0, [r12]
; CHECK-NEXT:    add.w r12, r12, #4
; CHECK-NEXT:    le lr, .LBB1_7
; CHECK-NEXT:  .LBB1_8: @ %while.end
; CHECK-NEXT:    pop {r4, r5, r7, pc}
; CHECK-NEXT:  .LBB1_9:
; CHECK-NEXT:    mov r3, r0
; CHECK-NEXT:    mov r12, r1
; CHECK-NEXT:    mov r5, r2
; CHECK-NEXT:    b .LBB1_6
entry:
  %cmp.not11 = icmp eq i32 %numSamples, 0
  br i1 %cmp.not11, label %while.end, label %while.body.preheader

while.body.preheader:                             ; preds = %entry
  %min.iters.check = icmp ult i32 %numSamples, 4
  br i1 %min.iters.check, label %while.body.preheader26, label %vector.memcheck

vector.memcheck:                                  ; preds = %while.body.preheader
  %scevgep = getelementptr float, float* %pDst, i32 %numSamples
  %0 = shl i32 %numSamples, 1
  %scevgep18 = getelementptr float, float* %pSrc, i32 %0
  %bound0 = icmp ugt float* %scevgep18, %pDst
  %bound1 = icmp ugt float* %scevgep, %pSrc
  %found.conflict = and i1 %bound0, %bound1
  br i1 %found.conflict, label %while.body.preheader26, label %vector.ph

vector.ph:                                        ; preds = %vector.memcheck
  %n.vec = and i32 %numSamples, -4
  %1 = shl i32 %n.vec, 1
  %ind.end = getelementptr float, float* %pSrc, i32 %1
  %ind.end21 = getelementptr float, float* %pDst, i32 %n.vec
  %ind.end23 = and i32 %numSamples, 3
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %2 = shl i32 %index, 1
  %next.gep = getelementptr float, float* %pSrc, i32 %2
  %next.gep24 = getelementptr float, float* %pDst, i32 %index
  %3 = bitcast float* %next.gep to <8 x float>*
  %wide.vec = load <8 x float>, <8 x float>* %3, align 4
  %4 = fmul fast <8 x float> %wide.vec, %wide.vec
  %5 = shufflevector <8 x float> %4, <8 x float> undef, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
  %6 = fmul fast <8 x float> %wide.vec, %wide.vec
  %7 = shufflevector <8 x float> %6, <8 x float> undef, <4 x i32> <i32 1, i32 3, i32 5, i32 7>
  %8 = fadd fast <4 x float> %7, %5
  %9 = bitcast float* %next.gep24 to <4 x float>*
  store <4 x float> %8, <4 x float>* %9, align 4
  %index.next = add i32 %index, 4
  %10 = icmp eq i32 %index.next, %n.vec
  br i1 %10, label %middle.block, label %vector.body

middle.block:                                     ; preds = %vector.body
  %cmp.n = icmp eq i32 %n.vec, %numSamples
  br i1 %cmp.n, label %while.end, label %while.body.preheader26

while.body.preheader26:                           ; preds = %middle.block, %vector.memcheck, %while.body.preheader
  %pSrc.addr.014.ph = phi float* [ %pSrc, %vector.memcheck ], [ %pSrc, %while.body.preheader ], [ %ind.end, %middle.block ]
  %pDst.addr.013.ph = phi float* [ %pDst, %vector.memcheck ], [ %pDst, %while.body.preheader ], [ %ind.end21, %middle.block ]
  %blkCnt.012.ph = phi i32 [ %numSamples, %vector.memcheck ], [ %numSamples, %while.body.preheader ], [ %ind.end23, %middle.block ]
  br label %while.body

while.body:                                       ; preds = %while.body.preheader26, %while.body
  %pSrc.addr.014 = phi float* [ %incdec.ptr1, %while.body ], [ %pSrc.addr.014.ph, %while.body.preheader26 ]
  %pDst.addr.013 = phi float* [ %incdec.ptr3, %while.body ], [ %pDst.addr.013.ph, %while.body.preheader26 ]
  %blkCnt.012 = phi i32 [ %dec, %while.body ], [ %blkCnt.012.ph, %while.body.preheader26 ]
  %incdec.ptr = getelementptr inbounds float, float* %pSrc.addr.014, i32 1
  %11 = load float, float* %pSrc.addr.014, align 4
  %incdec.ptr1 = getelementptr inbounds float, float* %pSrc.addr.014, i32 2
  %12 = load float, float* %incdec.ptr, align 4
  %mul = fmul fast float %11, %11
  %mul2 = fmul fast float %12, %12
  %add = fadd fast float %mul2, %mul
  %incdec.ptr3 = getelementptr inbounds float, float* %pDst.addr.013, i32 1
  store float %add, float* %pDst.addr.013, align 4
  %dec = add i32 %blkCnt.012, -1
  %cmp.not = icmp eq i32 %dec, 0
  br i1 %cmp.not, label %while.end, label %while.body

while.end:                                        ; preds = %while.body, %middle.block, %entry
  ret void
}
