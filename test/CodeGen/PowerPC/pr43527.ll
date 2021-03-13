; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -ppc-asm-full-reg-names -verify-machineinstrs \
; RUN:   -mtriple=powerpc64le-unknown-linux-gnu -mcpu=pwr8 < %s | FileCheck %s
; We don't want to produce a CTR loop due to the call to lrint in the body.
define dso_local void @test(i64 %arg, i64 %arg1) {
; CHECK-LABEL: test:
; CHECK:       # %bb.0: # %bb
; CHECK-NEXT:    bc 4, 4*cr5+lt, .LBB0_5
; CHECK-NEXT:  # %bb.1: # %bb3
; CHECK-NEXT:    bc 12, 4*cr5+lt, .LBB0_6
; CHECK-NEXT:  # %bb.2: # %bb4
; CHECK-NEXT:    mflr r0
; CHECK-NEXT:    .cfi_def_cfa_offset 64
; CHECK-NEXT:    .cfi_offset lr, 16
; CHECK-NEXT:    .cfi_offset r29, -24
; CHECK-NEXT:    .cfi_offset r30, -16
; CHECK-NEXT:    std r29, -24(r1) # 8-byte Folded Spill
; CHECK-NEXT:    std r30, -16(r1) # 8-byte Folded Spill
; CHECK-NEXT:    std r0, 16(r1)
; CHECK-NEXT:    stdu r1, -64(r1)
; CHECK-NEXT:    sub r30, r4, r3
; CHECK-NEXT:    li r29, -4
; CHECK-NEXT:    .p2align 5
; CHECK-NEXT:  .LBB0_3: # %bb5
; CHECK-NEXT:    #
; CHECK-NEXT:    lfsu f1, 4(r29)
; CHECK-NEXT:    bl lrint
; CHECK-NEXT:    nop
; CHECK-NEXT:    addi r30, r30, -1
; CHECK-NEXT:    cmpldi r30, 0
; CHECK-NEXT:    bne cr0, .LBB0_3
; CHECK-NEXT:  # %bb.4: # %bb15
; CHECK-NEXT:    stb r3, 0(r3)
; CHECK-NEXT:    addi r1, r1, 64
; CHECK-NEXT:    ld r0, 16(r1)
; CHECK-NEXT:    ld r30, -16(r1) # 8-byte Folded Reload
; CHECK-NEXT:    ld r29, -24(r1) # 8-byte Folded Reload
; CHECK-NEXT:    mtlr r0
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB0_5: # %bb2
; CHECK-NEXT:  .LBB0_6: # %bb14
bb:
  br i1 undef, label %bb3, label %bb2

bb2:                                              ; preds = %bb
  unreachable

bb3:                                              ; preds = %bb
  %tmp = sub i64 %arg1, %arg
  br i1 undef, label %bb4, label %bb14

bb4:                                              ; preds = %bb3
  br label %bb5

bb5:                                              ; preds = %bb5, %bb4
  %tmp6 = phi i64 [ %tmp12, %bb5 ], [ 0, %bb4 ]
  %tmp7 = getelementptr inbounds float, float* null, i64 %tmp6
  %tmp8 = load float, float* %tmp7, align 4
  %tmp9 = fpext float %tmp8 to double
  %tmp10 = tail call i64 @llvm.lrint.i64.f64(double %tmp9) #2
  %tmp11 = trunc i64 %tmp10 to i8
  store i8 %tmp11, i8* undef, align 1
  %tmp12 = add nuw i64 %tmp6, 1
  %tmp13 = icmp eq i64 %tmp12, %tmp
  br i1 %tmp13, label %bb15, label %bb5

bb14:                                             ; preds = %bb3
  unreachable

bb15:                                             ; preds = %bb5
  ret void
}

declare i64 @llvm.lrint.i64.f64(double)
