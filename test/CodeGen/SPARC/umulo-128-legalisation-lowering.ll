; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=sparc-unknown-linux-gnu | FileCheck %s --check-prefixes=SPARC
; RUN: llc < %s -mtriple=sparc64-unknown-linux-gnu | FileCheck %s --check-prefixes=SPARC64

define { i128, i8 } @muloti_test(i128 %l, i128 %r) unnamed_addr #0 {
; SPARC-LABEL: muloti_test:
; SPARC:         .cfi_startproc
; SPARC-NEXT:  ! %bb.0: ! %start
; SPARC-NEXT:    save %sp, -120, %sp
; SPARC-NEXT:    .cfi_def_cfa_register %fp
; SPARC-NEXT:    .cfi_window_save
; SPARC-NEXT:    .cfi_register %o7, %i7
; SPARC-NEXT:    ld [%fp+92], %l4
; SPARC-NEXT:    ld [%fp+96], %g2
; SPARC-NEXT:    umul %i2, %i5, %g3
; SPARC-NEXT:    rd %y, %g4
; SPARC-NEXT:    st %g4, [%fp+-12] ! 4-byte Folded Spill
; SPARC-NEXT:    umul %i4, %i3, %g4
; SPARC-NEXT:    rd %y, %l0
; SPARC-NEXT:    st %l0, [%fp+-16] ! 4-byte Folded Spill
; SPARC-NEXT:    st %g2, [%sp+96]
; SPARC-NEXT:    umul %i5, %i3, %l0
; SPARC-NEXT:    rd %y, %l6
; SPARC-NEXT:    st %l4, [%sp+92]
; SPARC-NEXT:    umul %l4, %i1, %l2
; SPARC-NEXT:    rd %y, %l1
; SPARC-NEXT:    st %l1, [%fp+-4] ! 4-byte Folded Spill
; SPARC-NEXT:    add %g4, %g3, %g3
; SPARC-NEXT:    umul %i0, %g2, %g4
; SPARC-NEXT:    rd %y, %l1
; SPARC-NEXT:    st %l1, [%fp+-8] ! 4-byte Folded Spill
; SPARC-NEXT:    add %l6, %g3, %l3
; SPARC-NEXT:    umul %i1, %g2, %g2
; SPARC-NEXT:    rd %y, %l1
; SPARC-NEXT:    add %g4, %l2, %g3
; SPARC-NEXT:    add %l1, %g3, %l2
; SPARC-NEXT:    addcc %g2, %l0, %l7
; SPARC-NEXT:    mov %g0, %l0
; SPARC-NEXT:    addxcc %l2, %l3, %l5
; SPARC-NEXT:    mov %l0, %o0
; SPARC-NEXT:    mov %l0, %o1
; SPARC-NEXT:    mov %i2, %o2
; SPARC-NEXT:    mov %i3, %o3
; SPARC-NEXT:    mov %l0, %o4
; SPARC-NEXT:    call __multi3
; SPARC-NEXT:    mov %l0, %o5
; SPARC-NEXT:    addcc %o1, %l7, %i3
; SPARC-NEXT:    addxcc %o0, %l5, %g2
; SPARC-NEXT:    mov 1, %g3
; SPARC-NEXT:    cmp %g2, %o0
; SPARC-NEXT:    bcs .LBB0_2
; SPARC-NEXT:    mov %g3, %o4
; SPARC-NEXT:  ! %bb.1: ! %start
; SPARC-NEXT:    mov %l0, %o4
; SPARC-NEXT:  .LBB0_2: ! %start
; SPARC-NEXT:    cmp %i3, %o1
; SPARC-NEXT:    bcs .LBB0_4
; SPARC-NEXT:    mov %g3, %g4
; SPARC-NEXT:  ! %bb.3: ! %start
; SPARC-NEXT:    mov %l0, %g4
; SPARC-NEXT:  .LBB0_4: ! %start
; SPARC-NEXT:    cmp %g2, %o0
; SPARC-NEXT:    be .LBB0_6
; SPARC-NEXT:    nop
; SPARC-NEXT:  ! %bb.5: ! %start
; SPARC-NEXT:    mov %o4, %g4
; SPARC-NEXT:  .LBB0_6: ! %start
; SPARC-NEXT:    cmp %i2, 0
; SPARC-NEXT:    bne .LBB0_8
; SPARC-NEXT:    mov %g3, %i2
; SPARC-NEXT:  ! %bb.7: ! %start
; SPARC-NEXT:    mov %l0, %i2
; SPARC-NEXT:  .LBB0_8: ! %start
; SPARC-NEXT:    cmp %i4, 0
; SPARC-NEXT:    bne .LBB0_10
; SPARC-NEXT:    mov %g3, %o1
; SPARC-NEXT:  ! %bb.9: ! %start
; SPARC-NEXT:    mov %l0, %o1
; SPARC-NEXT:  .LBB0_10: ! %start
; SPARC-NEXT:    ld [%fp+-16], %l5 ! 4-byte Folded Reload
; SPARC-NEXT:    cmp %l5, 0
; SPARC-NEXT:    bne .LBB0_12
; SPARC-NEXT:    mov %g3, %o0
; SPARC-NEXT:  ! %bb.11: ! %start
; SPARC-NEXT:    mov %l0, %o0
; SPARC-NEXT:  .LBB0_12: ! %start
; SPARC-NEXT:    ld [%fp+-12], %l5 ! 4-byte Folded Reload
; SPARC-NEXT:    cmp %l5, 0
; SPARC-NEXT:    bne .LBB0_14
; SPARC-NEXT:    mov %g3, %l5
; SPARC-NEXT:  ! %bb.13: ! %start
; SPARC-NEXT:    mov %l0, %l5
; SPARC-NEXT:  .LBB0_14: ! %start
; SPARC-NEXT:    cmp %l3, %l6
; SPARC-NEXT:    bcs .LBB0_16
; SPARC-NEXT:    mov %g3, %l3
; SPARC-NEXT:  ! %bb.15: ! %start
; SPARC-NEXT:    mov %l0, %l3
; SPARC-NEXT:  .LBB0_16: ! %start
; SPARC-NEXT:    cmp %l4, 0
; SPARC-NEXT:    bne .LBB0_18
; SPARC-NEXT:    mov %g3, %l4
; SPARC-NEXT:  ! %bb.17: ! %start
; SPARC-NEXT:    mov %l0, %l4
; SPARC-NEXT:  .LBB0_18: ! %start
; SPARC-NEXT:    cmp %i0, 0
; SPARC-NEXT:    bne .LBB0_20
; SPARC-NEXT:    mov %g3, %l7
; SPARC-NEXT:  ! %bb.19: ! %start
; SPARC-NEXT:    mov %l0, %l7
; SPARC-NEXT:  .LBB0_20: ! %start
; SPARC-NEXT:    ld [%fp+-8], %l6 ! 4-byte Folded Reload
; SPARC-NEXT:    cmp %l6, 0
; SPARC-NEXT:    bne .LBB0_22
; SPARC-NEXT:    mov %g3, %l6
; SPARC-NEXT:  ! %bb.21: ! %start
; SPARC-NEXT:    mov %l0, %l6
; SPARC-NEXT:  .LBB0_22: ! %start
; SPARC-NEXT:    and %o1, %i2, %i2
; SPARC-NEXT:    ld [%fp+-4], %o1 ! 4-byte Folded Reload
; SPARC-NEXT:    cmp %o1, 0
; SPARC-NEXT:    and %l7, %l4, %o1
; SPARC-NEXT:    bne .LBB0_24
; SPARC-NEXT:    mov %g3, %l4
; SPARC-NEXT:  ! %bb.23: ! %start
; SPARC-NEXT:    mov %l0, %l4
; SPARC-NEXT:  .LBB0_24: ! %start
; SPARC-NEXT:    or %i2, %o0, %l7
; SPARC-NEXT:    cmp %l2, %l1
; SPARC-NEXT:    or %o1, %l6, %l2
; SPARC-NEXT:    bcs .LBB0_26
; SPARC-NEXT:    mov %g3, %i2
; SPARC-NEXT:  ! %bb.25: ! %start
; SPARC-NEXT:    mov %l0, %i2
; SPARC-NEXT:  .LBB0_26: ! %start
; SPARC-NEXT:    or %l7, %l5, %l1
; SPARC-NEXT:    or %i5, %i4, %i4
; SPARC-NEXT:    cmp %i4, 0
; SPARC-NEXT:    or %l2, %l4, %l2
; SPARC-NEXT:    bne .LBB0_28
; SPARC-NEXT:    mov %g3, %i4
; SPARC-NEXT:  ! %bb.27: ! %start
; SPARC-NEXT:    mov %l0, %i4
; SPARC-NEXT:  .LBB0_28: ! %start
; SPARC-NEXT:    or %l1, %l3, %i5
; SPARC-NEXT:    or %i1, %i0, %i0
; SPARC-NEXT:    cmp %i0, 0
; SPARC-NEXT:    bne .LBB0_30
; SPARC-NEXT:    or %l2, %i2, %i0
; SPARC-NEXT:  ! %bb.29: ! %start
; SPARC-NEXT:    mov %l0, %g3
; SPARC-NEXT:  .LBB0_30: ! %start
; SPARC-NEXT:    and %g3, %i4, %i1
; SPARC-NEXT:    or %i1, %i0, %i0
; SPARC-NEXT:    or %i0, %i5, %i0
; SPARC-NEXT:    or %i0, %g4, %i0
; SPARC-NEXT:    and %i0, 1, %i4
; SPARC-NEXT:    mov %g2, %i0
; SPARC-NEXT:    mov %i3, %i1
; SPARC-NEXT:    mov %o2, %i2
; SPARC-NEXT:    ret
; SPARC-NEXT:    restore %g0, %o3, %o3
;
; SPARC64-LABEL: muloti_test:
; SPARC64:         .cfi_startproc
; SPARC64-NEXT:    .register %g2, #scratch
; SPARC64-NEXT:  ! %bb.0: ! %start
; SPARC64-NEXT:    save %sp, -176, %sp
; SPARC64-NEXT:    .cfi_def_cfa_register %fp
; SPARC64-NEXT:    .cfi_window_save
; SPARC64-NEXT:    .cfi_register %o7, %i7
; SPARC64-NEXT:    srax %i2, 63, %o0
; SPARC64-NEXT:    srax %i1, 63, %o2
; SPARC64-NEXT:    mov %i2, %o1
; SPARC64-NEXT:    call __multi3
; SPARC64-NEXT:    mov %i1, %o3
; SPARC64-NEXT:    mov %o0, %i4
; SPARC64-NEXT:    mov %o1, %i5
; SPARC64-NEXT:    srax %i0, 63, %o0
; SPARC64-NEXT:    srax %i3, 63, %o2
; SPARC64-NEXT:    mov %i0, %o1
; SPARC64-NEXT:    call __multi3
; SPARC64-NEXT:    mov %i3, %o3
; SPARC64-NEXT:    mov %o0, %l0
; SPARC64-NEXT:    add %o1, %i5, %i5
; SPARC64-NEXT:    mov 0, %o0
; SPARC64-NEXT:    mov %i1, %o1
; SPARC64-NEXT:    mov %o0, %o2
; SPARC64-NEXT:    call __multi3
; SPARC64-NEXT:    mov %i3, %o3
; SPARC64-NEXT:    add %o0, %i5, %i1
; SPARC64-NEXT:    mov %g0, %i3
; SPARC64-NEXT:    cmp %i1, %o0
; SPARC64-NEXT:    mov %i3, %i5
; SPARC64-NEXT:    movcs %xcc, 1, %i5
; SPARC64-NEXT:    cmp %i4, 0
; SPARC64-NEXT:    mov %i3, %i4
; SPARC64-NEXT:    movne %xcc, 1, %i4
; SPARC64-NEXT:    cmp %l0, 0
; SPARC64-NEXT:    mov %i3, %g2
; SPARC64-NEXT:    movne %xcc, 1, %g2
; SPARC64-NEXT:    cmp %i2, 0
; SPARC64-NEXT:    mov %i3, %i2
; SPARC64-NEXT:    movne %xcc, 1, %i2
; SPARC64-NEXT:    cmp %i0, 0
; SPARC64-NEXT:    movne %xcc, 1, %i3
; SPARC64-NEXT:    and %i3, %i2, %i0
; SPARC64-NEXT:    or %i0, %g2, %i0
; SPARC64-NEXT:    or %i0, %i4, %i0
; SPARC64-NEXT:    or %i0, %i5, %i0
; SPARC64-NEXT:    srl %i0, 0, %i2
; SPARC64-NEXT:    mov %i1, %i0
; SPARC64-NEXT:    ret
; SPARC64-NEXT:    restore %g0, %o1, %o1
start:
  %0 = tail call { i128, i1 } @llvm.umul.with.overflow.i128(i128 %l, i128 %r) #2
  %1 = extractvalue { i128, i1 } %0, 0
  %2 = extractvalue { i128, i1 } %0, 1
  %3 = zext i1 %2 to i8
  %4 = insertvalue { i128, i8 } undef, i128 %1, 0
  %5 = insertvalue { i128, i8 } %4, i8 %3, 1
  ret { i128, i8 } %5
}

; Function Attrs: nounwind readnone speculatable
declare { i128, i1 } @llvm.umul.with.overflow.i128(i128, i128) #1

attributes #0 = { nounwind readnone uwtable }
attributes #1 = { nounwind readnone speculatable }
attributes #2 = { nounwind }
