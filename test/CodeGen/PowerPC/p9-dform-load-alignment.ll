; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mcpu=pwr9 -mtriple=powerpc64le-unknown-unknown \
; RUN:   -verify-machineinstrs -ppc-asm-full-reg-names \
; RUN:   -ppc-vsr-nums-as-vr < %s | FileCheck %s

@best8x8mode = external dso_local local_unnamed_addr global [4 x i16], align 2
define dso_local void @AlignDSForm() local_unnamed_addr {
; CHECK-LABEL: AlignDSForm:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addis r3, r2, best8x8mode@toc@ha
; CHECK-NEXT:    addi r3, r3, best8x8mode@toc@l
; CHECK-NEXT:    ld r3, 0(r3)
; CHECK-NEXT:    std r3, 0(r3)
entry:
  %0 = load <4 x i16>, <4 x i16>* bitcast ([4 x i16]* @best8x8mode to <4 x i16>*), align 2
  store <4 x i16> %0, <4 x i16>* undef, align 4
  unreachable
}

