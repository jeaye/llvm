; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-- -mcpu=pwr7 %s -o - | FileCheck %s --check-prefix=PWR7
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-- -mcpu=pwr9 %s -o - | FileCheck %s --check-prefix=PWR9

@value8 = dso_local global { i8 } zeroinitializer, align 1
@value16 = dso_local global { i16 } zeroinitializer, align 2
@global_int = dso_local local_unnamed_addr global i32 0, align 4

define dso_local zeroext i32 @testI8(i8 zeroext %val) local_unnamed_addr #0 {
; PWR7-LABEL: testI8:
; PWR7:       # %bb.0: # %entry
; PWR7-NEXT:    addis 4, 2, value8@toc@ha
; PWR7-NEXT:    li 6, 255
; PWR7-NEXT:    sync
; PWR7-NEXT:    addi 5, 4, value8@toc@l
; PWR7-NEXT:    rlwinm 4, 5, 3, 27, 28
; PWR7-NEXT:    rldicr 5, 5, 0, 61
; PWR7-NEXT:    xori 4, 4, 24
; PWR7-NEXT:    slw 7, 3, 4
; PWR7-NEXT:    slw 3, 6, 4
; PWR7-NEXT:    and 6, 7, 3
; PWR7-NEXT:  .LBB0_1: # %entry
; PWR7-NEXT:    #
; PWR7-NEXT:    lwarx 7, 0, 5
; PWR7-NEXT:    andc 8, 7, 3
; PWR7-NEXT:    or 8, 6, 8
; PWR7-NEXT:    stwcx. 8, 0, 5
; PWR7-NEXT:    bne 0, .LBB0_1
; PWR7-NEXT:  # %bb.2: # %entry
; PWR7-NEXT:    srw 3, 7, 4
; PWR7-NEXT:    addis 5, 2, global_int@toc@ha
; PWR7-NEXT:    lwsync
; PWR7-NEXT:    clrlwi 4, 3, 24
; PWR7-NEXT:    li 3, 55
; PWR7-NEXT:    stw 4, global_int@toc@l(5)
; PWR7-NEXT:    blr
;
; PWR9-LABEL: testI8:
; PWR9:       # %bb.0: # %entry
; PWR9-NEXT:    addis 4, 2, value8@toc@ha
; PWR9-NEXT:    sync
; PWR9-NEXT:    addi 5, 4, value8@toc@l
; PWR9-NEXT:  .LBB0_1: # %entry
; PWR9-NEXT:    #
; PWR9-NEXT:    lbarx 4, 0, 5
; PWR9-NEXT:    stbcx. 3, 0, 5
; PWR9-NEXT:    bne 0, .LBB0_1
; PWR9-NEXT:  # %bb.2: # %entry
; PWR9-NEXT:    clrlwi 3, 4, 24
; PWR9-NEXT:    addis 4, 2, global_int@toc@ha
; PWR9-NEXT:    lwsync
; PWR9-NEXT:    stw 3, global_int@toc@l(4)
; PWR9-NEXT:    li 3, 55
; PWR9-NEXT:    blr
entry:
  %0 = atomicrmw xchg i8* getelementptr inbounds ({ i8 }, { i8 }* @value8, i64 0, i32 0), i8 %val seq_cst, align 1
  %conv = zext i8 %0 to i32
  store i32 %conv, i32* @global_int, align 4
  ret i32 55
}

define dso_local zeroext i32 @testI16(i16 zeroext %val) local_unnamed_addr #0 {
; PWR7-LABEL: testI16:
; PWR7:       # %bb.0: # %entry
; PWR7-NEXT:    addis 4, 2, value16@toc@ha
; PWR7-NEXT:    li 6, 0
; PWR7-NEXT:    sync
; PWR7-NEXT:    addi 5, 4, value16@toc@l
; PWR7-NEXT:    ori 6, 6, 65535
; PWR7-NEXT:    rlwinm 4, 5, 3, 27, 27
; PWR7-NEXT:    rldicr 5, 5, 0, 61
; PWR7-NEXT:    xori 4, 4, 16
; PWR7-NEXT:    slw 7, 3, 4
; PWR7-NEXT:    slw 3, 6, 4
; PWR7-NEXT:    and 6, 7, 3
; PWR7-NEXT:  .LBB1_1: # %entry
; PWR7-NEXT:    #
; PWR7-NEXT:    lwarx 7, 0, 5
; PWR7-NEXT:    andc 8, 7, 3
; PWR7-NEXT:    or 8, 6, 8
; PWR7-NEXT:    stwcx. 8, 0, 5
; PWR7-NEXT:    bne 0, .LBB1_1
; PWR7-NEXT:  # %bb.2: # %entry
; PWR7-NEXT:    srw 3, 7, 4
; PWR7-NEXT:    addis 5, 2, global_int@toc@ha
; PWR7-NEXT:    lwsync
; PWR7-NEXT:    clrlwi 4, 3, 16
; PWR7-NEXT:    li 3, 55
; PWR7-NEXT:    stw 4, global_int@toc@l(5)
; PWR7-NEXT:    blr
;
; PWR9-LABEL: testI16:
; PWR9:       # %bb.0: # %entry
; PWR9-NEXT:    addis 4, 2, value16@toc@ha
; PWR9-NEXT:    sync
; PWR9-NEXT:    addi 5, 4, value16@toc@l
; PWR9-NEXT:  .LBB1_1: # %entry
; PWR9-NEXT:    #
; PWR9-NEXT:    lharx 4, 0, 5
; PWR9-NEXT:    sthcx. 3, 0, 5
; PWR9-NEXT:    bne 0, .LBB1_1
; PWR9-NEXT:  # %bb.2: # %entry
; PWR9-NEXT:    clrlwi 3, 4, 16
; PWR9-NEXT:    addis 4, 2, global_int@toc@ha
; PWR9-NEXT:    lwsync
; PWR9-NEXT:    stw 3, global_int@toc@l(4)
; PWR9-NEXT:    li 3, 55
; PWR9-NEXT:    blr
entry:
  %0 = atomicrmw xchg i16* getelementptr inbounds ({ i16 }, { i16 }* @value16, i64 0, i32 0), i16 %val seq_cst, align 2
  %conv = zext i16 %0 to i32
  store i32 %conv, i32* @global_int, align 4
  ret i32 55
}

attributes #0 = { nounwind }
