; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mcpu=a2 < %s | FileCheck %s -check-prefix=FPCVT
; RUN: llc -verify-machineinstrs -mcpu=ppc64 < %s | FileCheck %s -check-prefix=PPC64
; RUN: llc -verify-machineinstrs -mcpu=pwr9 < %s | FileCheck %s -check-prefix=PWR9
target datalayout = "E-m:e-i64:64-n32:64"
target triple = "powerpc64-unknown-linux-gnu"

; Function Attrs: nounwind readnone
define float @fool(float %X) #0 {
; FPCVT-LABEL: fool:
; FPCVT:       # %bb.0: # %entry
; FPCVT-NEXT:    friz 1, 1
; FPCVT-NEXT:    blr
;
; PPC64-LABEL: fool:
; PPC64:       # %bb.0: # %entry
; PPC64-NEXT:    fctidz 0, 1
; PPC64-NEXT:    fcfid 0, 0
; PPC64-NEXT:    frsp 1, 0
; PPC64-NEXT:    blr
;
; PWR9-LABEL: fool:
; PWR9:       # %bb.0: # %entry
; PWR9-NEXT:    xsrdpiz 1, 1
; PWR9-NEXT:    blr
entry:
  %conv = fptosi float %X to i64
  %conv1 = sitofp i64 %conv to float
  ret float %conv1


}

; Function Attrs: nounwind readnone
define double @foodl(double %X) #0 {
; FPCVT-LABEL: foodl:
; FPCVT:       # %bb.0: # %entry
; FPCVT-NEXT:    friz 1, 1
; FPCVT-NEXT:    blr
;
; PPC64-LABEL: foodl:
; PPC64:       # %bb.0: # %entry
; PPC64-NEXT:    fctidz 0, 1
; PPC64-NEXT:    fcfid 1, 0
; PPC64-NEXT:    blr
;
; PWR9-LABEL: foodl:
; PWR9:       # %bb.0: # %entry
; PWR9-NEXT:    xsrdpiz 1, 1
; PWR9-NEXT:    blr
entry:
  %conv = fptosi double %X to i64
  %conv1 = sitofp i64 %conv to double
  ret double %conv1


}

; Function Attrs: nounwind readnone
define float @fooul(float %X) #0 {
; FPCVT-LABEL: fooul:
; FPCVT:       # %bb.0: # %entry
; FPCVT-NEXT:    friz 1, 1
; FPCVT-NEXT:    blr
;
; PPC64-LABEL: fooul:
; PPC64:       # %bb.0: # %entry
; PPC64-NEXT:    addis 3, 2, .LCPI2_0@toc@ha
; PPC64-NEXT:    li 4, 1
; PPC64-NEXT:    lfs 0, .LCPI2_0@toc@l(3)
; PPC64-NEXT:    sldi 4, 4, 63
; PPC64-NEXT:    fsubs 2, 1, 0
; PPC64-NEXT:    fcmpu 0, 1, 0
; PPC64-NEXT:    fctidz 2, 2
; PPC64-NEXT:    stfd 2, -8(1)
; PPC64-NEXT:    fctidz 2, 1
; PPC64-NEXT:    stfd 2, -16(1)
; PPC64-NEXT:    ld 3, -8(1)
; PPC64-NEXT:    ld 5, -16(1)
; PPC64-NEXT:    xor 3, 3, 4
; PPC64-NEXT:    bc 12, 0, .LBB2_1
; PPC64-NEXT:    b .LBB2_2
; PPC64-NEXT:  .LBB2_1: # %entry
; PPC64-NEXT:    addi 3, 5, 0
; PPC64-NEXT:  .LBB2_2: # %entry
; PPC64-NEXT:    sradi 4, 3, 53
; PPC64-NEXT:    clrldi 5, 3, 63
; PPC64-NEXT:    addi 4, 4, 1
; PPC64-NEXT:    cmpldi 4, 1
; PPC64-NEXT:    rldicl 4, 3, 63, 1
; PPC64-NEXT:    or 5, 5, 4
; PPC64-NEXT:    rldicl 6, 5, 11, 53
; PPC64-NEXT:    addi 6, 6, 1
; PPC64-NEXT:    clrldi 7, 5, 53
; PPC64-NEXT:    cmpldi 1, 6, 1
; PPC64-NEXT:    clrldi 6, 3, 53
; PPC64-NEXT:    addi 7, 7, 2047
; PPC64-NEXT:    addi 6, 6, 2047
; PPC64-NEXT:    or 4, 7, 4
; PPC64-NEXT:    or 6, 6, 3
; PPC64-NEXT:    rldicl 4, 4, 53, 11
; PPC64-NEXT:    rldicr 6, 6, 0, 52
; PPC64-NEXT:    bc 12, 1, .LBB2_4
; PPC64-NEXT:  # %bb.3: # %entry
; PPC64-NEXT:    ori 6, 3, 0
; PPC64-NEXT:    b .LBB2_4
; PPC64-NEXT:  .LBB2_4: # %entry
; PPC64-NEXT:    rldicl 4, 4, 11, 1
; PPC64-NEXT:    cmpdi 3, 0
; PPC64-NEXT:    std 6, -32(1)
; PPC64-NEXT:    bc 12, 5, .LBB2_6
; PPC64-NEXT:  # %bb.5: # %entry
; PPC64-NEXT:    ori 4, 5, 0
; PPC64-NEXT:    b .LBB2_6
; PPC64-NEXT:  .LBB2_6: # %entry
; PPC64-NEXT:    std 4, -24(1)
; PPC64-NEXT:    bc 12, 0, .LBB2_8
; PPC64-NEXT:  # %bb.7: # %entry
; PPC64-NEXT:    lfd 0, -32(1)
; PPC64-NEXT:    fcfid 0, 0
; PPC64-NEXT:    frsp 1, 0
; PPC64-NEXT:    blr
; PPC64-NEXT:  .LBB2_8:
; PPC64-NEXT:    lfd 0, -24(1)
; PPC64-NEXT:    fcfid 0, 0
; PPC64-NEXT:    frsp 0, 0
; PPC64-NEXT:    fadds 1, 0, 0
; PPC64-NEXT:    blr
;
; PWR9-LABEL: fooul:
; PWR9:       # %bb.0: # %entry
; PWR9-NEXT:    xsrdpiz 1, 1
; PWR9-NEXT:    blr
entry:
  %conv = fptoui float %X to i64
  %conv1 = uitofp i64 %conv to float
  ret float %conv1

}

; Function Attrs: nounwind readnone
define double @fooudl(double %X) #0 {
; FPCVT-LABEL: fooudl:
; FPCVT:       # %bb.0: # %entry
; FPCVT-NEXT:    friz 1, 1
; FPCVT-NEXT:    blr
;
; PPC64-LABEL: fooudl:
; PPC64:       # %bb.0: # %entry
; PPC64-NEXT:    addis 3, 2, .LCPI3_0@toc@ha
; PPC64-NEXT:    li 4, 1
; PPC64-NEXT:    lfs 0, .LCPI3_0@toc@l(3)
; PPC64-NEXT:    sldi 4, 4, 63
; PPC64-NEXT:    fsub 2, 1, 0
; PPC64-NEXT:    fcmpu 0, 1, 0
; PPC64-NEXT:    fctidz 2, 2
; PPC64-NEXT:    stfd 2, -8(1)
; PPC64-NEXT:    fctidz 2, 1
; PPC64-NEXT:    stfd 2, -16(1)
; PPC64-NEXT:    ld 3, -8(1)
; PPC64-NEXT:    ld 5, -16(1)
; PPC64-NEXT:    xor 3, 3, 4
; PPC64-NEXT:    li 4, 1107
; PPC64-NEXT:    sldi 4, 4, 52
; PPC64-NEXT:    bc 12, 0, .LBB3_1
; PPC64-NEXT:    b .LBB3_2
; PPC64-NEXT:  .LBB3_1: # %entry
; PPC64-NEXT:    addi 3, 5, 0
; PPC64-NEXT:  .LBB3_2: # %entry
; PPC64-NEXT:    rldicl 5, 3, 32, 32
; PPC64-NEXT:    clrldi 3, 3, 32
; PPC64-NEXT:    or 4, 5, 4
; PPC64-NEXT:    addis 5, 2, .LCPI3_1@toc@ha
; PPC64-NEXT:    std 4, -24(1)
; PPC64-NEXT:    li 4, 1075
; PPC64-NEXT:    sldi 4, 4, 52
; PPC64-NEXT:    or 3, 3, 4
; PPC64-NEXT:    lfd 0, .LCPI3_1@toc@l(5)
; PPC64-NEXT:    std 3, -32(1)
; PPC64-NEXT:    lfd 1, -24(1)
; PPC64-NEXT:    lfd 2, -32(1)
; PPC64-NEXT:    fsub 0, 1, 0
; PPC64-NEXT:    fadd 1, 2, 0
; PPC64-NEXT:    blr
;
; PWR9-LABEL: fooudl:
; PWR9:       # %bb.0: # %entry
; PWR9-NEXT:    xsrdpiz 1, 1
; PWR9-NEXT:    blr
entry:
  %conv = fptoui double %X to i64
  %conv1 = uitofp i64 %conv to double
  ret double %conv1

}

; Function Attrs: nounwind readnone
define i1 @f64_to_si1(double %X) #0 {
; FPCVT-LABEL: f64_to_si1:
; FPCVT:       # %bb.0: # %entry
; FPCVT-NEXT:    fctiwz 0, 1
; FPCVT-NEXT:    addi 3, 1, -4
; FPCVT-NEXT:    stfiwx 0, 0, 3
; FPCVT-NEXT:    lwz 3, -4(1)
; FPCVT-NEXT:    blr
;
; PPC64-LABEL: f64_to_si1:
; PPC64:       # %bb.0: # %entry
; PPC64-NEXT:    addi 3, 1, -4
; PPC64-NEXT:    fctiwz 0, 1
; PPC64-NEXT:    stfiwx 0, 0, 3
; PPC64-NEXT:    lwz 3, -4(1)
; PPC64-NEXT:    blr
;
; PWR9-LABEL: f64_to_si1:
; PWR9:       # %bb.0: # %entry
; PWR9-NEXT:    xscvdpsxws 0, 1
; PWR9-NEXT:    mffprwz 3, 0
; PWR9-NEXT:    blr
entry:
  %conv = fptosi double %X to i1
  ret i1 %conv

}

; Function Attrs: nounwind readnone
define i1 @f64_to_ui1(double %X) #0 {
; FPCVT-LABEL: f64_to_ui1:
; FPCVT:       # %bb.0: # %entry
; FPCVT-NEXT:    fctiwz 0, 1
; FPCVT-NEXT:    addi 3, 1, -4
; FPCVT-NEXT:    stfiwx 0, 0, 3
; FPCVT-NEXT:    lwz 3, -4(1)
; FPCVT-NEXT:    blr
;
; PPC64-LABEL: f64_to_ui1:
; PPC64:       # %bb.0: # %entry
; PPC64-NEXT:    addi 3, 1, -4
; PPC64-NEXT:    fctiwz 0, 1
; PPC64-NEXT:    stfiwx 0, 0, 3
; PPC64-NEXT:    lwz 3, -4(1)
; PPC64-NEXT:    blr
;
; PWR9-LABEL: f64_to_ui1:
; PWR9:       # %bb.0: # %entry
; PWR9-NEXT:    xscvdpsxws 0, 1
; PWR9-NEXT:    mffprwz 3, 0
; PWR9-NEXT:    blr
entry:
  %conv = fptoui double %X to i1
  ret i1 %conv

}

; Function Attrs: nounwind readnone
define double @si1_to_f64(i1 %X) #0 {
; FPCVT-LABEL: si1_to_f64:
; FPCVT:       # %bb.0: # %entry
; FPCVT-NEXT:    andi. 3, 3, 1
; FPCVT-NEXT:    li 4, 0
; FPCVT-NEXT:    li 3, -1
; FPCVT-NEXT:    iselgt 3, 3, 4
; FPCVT-NEXT:    addi 4, 1, -4
; FPCVT-NEXT:    stw 3, -4(1)
; FPCVT-NEXT:    lfiwax 0, 0, 4
; FPCVT-NEXT:    fcfid 1, 0
; FPCVT-NEXT:    blr
;
; PPC64-LABEL: si1_to_f64:
; PPC64:       # %bb.0: # %entry
; PPC64-NEXT:    andi. 3, 3, 1
; PPC64-NEXT:    li 4, -1
; PPC64-NEXT:    li 3, 0
; PPC64-NEXT:    bc 12, 1, .LBB6_1
; PPC64-NEXT:    b .LBB6_2
; PPC64-NEXT:  .LBB6_1: # %entry
; PPC64-NEXT:    addi 3, 4, 0
; PPC64-NEXT:  .LBB6_2: # %entry
; PPC64-NEXT:    std 3, -8(1)
; PPC64-NEXT:    lfd 0, -8(1)
; PPC64-NEXT:    fcfid 1, 0
; PPC64-NEXT:    blr
;
; PWR9-LABEL: si1_to_f64:
; PWR9:       # %bb.0: # %entry
; PWR9-NEXT:    andi. 3, 3, 1
; PWR9-NEXT:    li 3, 0
; PWR9-NEXT:    li 4, -1
; PWR9-NEXT:    iselgt 3, 4, 3
; PWR9-NEXT:    mtfprwa 0, 3
; PWR9-NEXT:    xscvsxddp 1, 0
; PWR9-NEXT:    blr
entry:
  %conv = sitofp i1 %X to double
  ret double %conv

}

; Function Attrs: nounwind readnone
define double @ui1_to_f64(i1 %X) #0 {
; FPCVT-LABEL: ui1_to_f64:
; FPCVT:       # %bb.0: # %entry
; FPCVT-NEXT:    clrlwi 3, 3, 31
; FPCVT-NEXT:    addi 4, 1, -4
; FPCVT-NEXT:    stw 3, -4(1)
; FPCVT-NEXT:    lfiwax 0, 0, 4
; FPCVT-NEXT:    fcfid 1, 0
; FPCVT-NEXT:    blr
;
; PPC64-LABEL: ui1_to_f64:
; PPC64:       # %bb.0: # %entry
; PPC64-NEXT:    clrldi 3, 3, 63
; PPC64-NEXT:    std 3, -8(1)
; PPC64-NEXT:    lfd 0, -8(1)
; PPC64-NEXT:    fcfid 1, 0
; PPC64-NEXT:    blr
;
; PWR9-LABEL: ui1_to_f64:
; PWR9:       # %bb.0: # %entry
; PWR9-NEXT:    clrlwi 3, 3, 31
; PWR9-NEXT:    mtfprwa 0, 3
; PWR9-NEXT:    xscvsxddp 1, 0
; PWR9-NEXT:    blr
entry:
  %conv = uitofp i1 %X to double
  ret double %conv

}
attributes #0 = { nounwind readnone "no-signed-zeros-fp-math"="true" }

