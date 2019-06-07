; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu \
; RUN:     -mcpu=pwr8 -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr < %s | \
; RUN: FileCheck %s --check-prefix=CHECK-P8
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu \
; RUN:     -mcpu=pwr9 -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr < %s | \
; RUN: FileCheck %s --check-prefix=CHECK-P9
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-linux-gnu \
; RUN:     -mcpu=pwr9 -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr < %s | \
; RUN: FileCheck %s --check-prefix=CHECK-BE

define <2 x double> @test2elt(<2 x i64> %a) local_unnamed_addr #0 {
; CHECK-P8-LABEL: test2elt:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    xvcvuxddp v2, v2
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test2elt:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    xvcvuxddp v2, v2
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test2elt:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    xvcvuxddp v2, v2
; CHECK-BE-NEXT:    blr
entry:
  %0 = uitofp <2 x i64> %a to <2 x double>
  ret <2 x double> %0
}

define void @test4elt(<4 x double>* noalias nocapture sret %agg.result, <4 x i64>* nocapture readonly) local_unnamed_addr #1 {
; CHECK-P8-LABEL: test4elt:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    li r5, 16
; CHECK-P8-NEXT:    lxvd2x vs1, 0, r4
; CHECK-P8-NEXT:    lxvd2x vs0, r4, r5
; CHECK-P8-NEXT:    xvcvuxddp vs1, vs1
; CHECK-P8-NEXT:    xvcvuxddp vs0, vs0
; CHECK-P8-NEXT:    stxvd2x vs0, r3, r5
; CHECK-P8-NEXT:    stxvd2x vs1, 0, r3
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test4elt:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxv v2, 16(r4)
; CHECK-P9-NEXT:    lxv v3, 0(r4)
; CHECK-P9-NEXT:    xvcvuxddp vs0, v3
; CHECK-P9-NEXT:    xvcvuxddp vs1, v2
; CHECK-P9-NEXT:    stxv vs1, 16(r3)
; CHECK-P9-NEXT:    stxv vs0, 0(r3)
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test4elt:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv v2, 16(r4)
; CHECK-BE-NEXT:    lxv v3, 0(r4)
; CHECK-BE-NEXT:    xvcvuxddp vs0, v3
; CHECK-BE-NEXT:    xvcvuxddp vs1, v2
; CHECK-BE-NEXT:    stxv vs1, 16(r3)
; CHECK-BE-NEXT:    stxv vs0, 0(r3)
; CHECK-BE-NEXT:    blr
entry:
  %a = load <4 x i64>, <4 x i64>* %0, align 32
  %1 = uitofp <4 x i64> %a to <4 x double>
  store <4 x double> %1, <4 x double>* %agg.result, align 32
  ret void
}

define void @test8elt(<8 x double>* noalias nocapture sret %agg.result, <8 x i64>* nocapture readonly) local_unnamed_addr #1 {
; CHECK-P8-LABEL: test8elt:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    li r5, 16
; CHECK-P8-NEXT:    li r6, 32
; CHECK-P8-NEXT:    li r7, 48
; CHECK-P8-NEXT:    lxvd2x vs3, 0, r4
; CHECK-P8-NEXT:    lxvd2x vs0, r4, r5
; CHECK-P8-NEXT:    lxvd2x vs1, r4, r6
; CHECK-P8-NEXT:    lxvd2x vs2, r4, r7
; CHECK-P8-NEXT:    xvcvuxddp vs3, vs3
; CHECK-P8-NEXT:    xvcvuxddp vs0, vs0
; CHECK-P8-NEXT:    xvcvuxddp vs1, vs1
; CHECK-P8-NEXT:    xvcvuxddp vs2, vs2
; CHECK-P8-NEXT:    stxvd2x vs2, r3, r7
; CHECK-P8-NEXT:    stxvd2x vs1, r3, r6
; CHECK-P8-NEXT:    stxvd2x vs0, r3, r5
; CHECK-P8-NEXT:    stxvd2x vs3, 0, r3
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test8elt:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxv v2, 48(r4)
; CHECK-P9-NEXT:    lxv v3, 32(r4)
; CHECK-P9-NEXT:    lxv v4, 16(r4)
; CHECK-P9-NEXT:    lxv v5, 0(r4)
; CHECK-P9-NEXT:    xvcvuxddp vs0, v5
; CHECK-P9-NEXT:    xvcvuxddp vs1, v4
; CHECK-P9-NEXT:    xvcvuxddp vs2, v3
; CHECK-P9-NEXT:    xvcvuxddp vs3, v2
; CHECK-P9-NEXT:    stxv vs3, 48(r3)
; CHECK-P9-NEXT:    stxv vs2, 32(r3)
; CHECK-P9-NEXT:    stxv vs1, 16(r3)
; CHECK-P9-NEXT:    stxv vs0, 0(r3)
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test8elt:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv v2, 48(r4)
; CHECK-BE-NEXT:    lxv v3, 32(r4)
; CHECK-BE-NEXT:    lxv v4, 16(r4)
; CHECK-BE-NEXT:    lxv v5, 0(r4)
; CHECK-BE-NEXT:    xvcvuxddp vs0, v5
; CHECK-BE-NEXT:    xvcvuxddp vs1, v4
; CHECK-BE-NEXT:    xvcvuxddp vs2, v3
; CHECK-BE-NEXT:    xvcvuxddp vs3, v2
; CHECK-BE-NEXT:    stxv vs3, 48(r3)
; CHECK-BE-NEXT:    stxv vs2, 32(r3)
; CHECK-BE-NEXT:    stxv vs1, 16(r3)
; CHECK-BE-NEXT:    stxv vs0, 0(r3)
; CHECK-BE-NEXT:    blr
entry:
  %a = load <8 x i64>, <8 x i64>* %0, align 64
  %1 = uitofp <8 x i64> %a to <8 x double>
  store <8 x double> %1, <8 x double>* %agg.result, align 64
  ret void
}

define void @test16elt(<16 x double>* noalias nocapture sret %agg.result, <16 x i64>* nocapture readonly) local_unnamed_addr #1 {
; CHECK-P8-LABEL: test16elt:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    li r5, 16
; CHECK-P8-NEXT:    li r6, 32
; CHECK-P8-NEXT:    li r7, 64
; CHECK-P8-NEXT:    li r8, 96
; CHECK-P8-NEXT:    li r9, 112
; CHECK-P8-NEXT:    li r10, 80
; CHECK-P8-NEXT:    li r11, 48
; CHECK-P8-NEXT:    lxvd2x vs0, r4, r5
; CHECK-P8-NEXT:    lxvd2x vs1, r4, r6
; CHECK-P8-NEXT:    lxvd2x vs2, r4, r7
; CHECK-P8-NEXT:    lxvd2x vs3, r4, r8
; CHECK-P8-NEXT:    lxvd2x vs4, r4, r9
; CHECK-P8-NEXT:    lxvd2x vs5, r4, r10
; CHECK-P8-NEXT:    lxvd2x vs6, r4, r11
; CHECK-P8-NEXT:    lxvd2x vs7, 0, r4
; CHECK-P8-NEXT:    xvcvuxddp vs0, vs0
; CHECK-P8-NEXT:    xvcvuxddp vs1, vs1
; CHECK-P8-NEXT:    xvcvuxddp vs2, vs2
; CHECK-P8-NEXT:    xvcvuxddp vs3, vs3
; CHECK-P8-NEXT:    xvcvuxddp vs4, vs4
; CHECK-P8-NEXT:    xvcvuxddp vs5, vs5
; CHECK-P8-NEXT:    xvcvuxddp vs6, vs6
; CHECK-P8-NEXT:    xvcvuxddp vs7, vs7
; CHECK-P8-NEXT:    stxvd2x vs4, r3, r9
; CHECK-P8-NEXT:    stxvd2x vs3, r3, r8
; CHECK-P8-NEXT:    stxvd2x vs5, r3, r10
; CHECK-P8-NEXT:    stxvd2x vs2, r3, r7
; CHECK-P8-NEXT:    stxvd2x vs6, r3, r11
; CHECK-P8-NEXT:    stxvd2x vs1, r3, r6
; CHECK-P8-NEXT:    stxvd2x vs0, r3, r5
; CHECK-P8-NEXT:    stxvd2x vs7, 0, r3
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test16elt:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxv v2, 112(r4)
; CHECK-P9-NEXT:    lxv v3, 96(r4)
; CHECK-P9-NEXT:    lxv v4, 80(r4)
; CHECK-P9-NEXT:    lxv v5, 64(r4)
; CHECK-P9-NEXT:    xvcvuxddp vs4, v5
; CHECK-P9-NEXT:    lxv v0, 48(r4)
; CHECK-P9-NEXT:    lxv v1, 32(r4)
; CHECK-P9-NEXT:    lxv v6, 16(r4)
; CHECK-P9-NEXT:    lxv v7, 0(r4)
; CHECK-P9-NEXT:    xvcvuxddp vs0, v7
; CHECK-P9-NEXT:    xvcvuxddp vs1, v6
; CHECK-P9-NEXT:    xvcvuxddp vs2, v1
; CHECK-P9-NEXT:    xvcvuxddp vs3, v0
; CHECK-P9-NEXT:    xvcvuxddp vs5, v4
; CHECK-P9-NEXT:    xvcvuxddp vs6, v3
; CHECK-P9-NEXT:    xvcvuxddp vs7, v2
; CHECK-P9-NEXT:    stxv vs7, 112(r3)
; CHECK-P9-NEXT:    stxv vs6, 96(r3)
; CHECK-P9-NEXT:    stxv vs5, 80(r3)
; CHECK-P9-NEXT:    stxv vs4, 64(r3)
; CHECK-P9-NEXT:    stxv vs3, 48(r3)
; CHECK-P9-NEXT:    stxv vs2, 32(r3)
; CHECK-P9-NEXT:    stxv vs1, 16(r3)
; CHECK-P9-NEXT:    stxv vs0, 0(r3)
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test16elt:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv v2, 112(r4)
; CHECK-BE-NEXT:    lxv v3, 96(r4)
; CHECK-BE-NEXT:    lxv v4, 80(r4)
; CHECK-BE-NEXT:    lxv v5, 64(r4)
; CHECK-BE-NEXT:    xvcvuxddp vs4, v5
; CHECK-BE-NEXT:    lxv v0, 48(r4)
; CHECK-BE-NEXT:    lxv v1, 32(r4)
; CHECK-BE-NEXT:    lxv v6, 16(r4)
; CHECK-BE-NEXT:    lxv v7, 0(r4)
; CHECK-BE-NEXT:    xvcvuxddp vs0, v7
; CHECK-BE-NEXT:    xvcvuxddp vs1, v6
; CHECK-BE-NEXT:    xvcvuxddp vs2, v1
; CHECK-BE-NEXT:    xvcvuxddp vs3, v0
; CHECK-BE-NEXT:    xvcvuxddp vs5, v4
; CHECK-BE-NEXT:    xvcvuxddp vs6, v3
; CHECK-BE-NEXT:    xvcvuxddp vs7, v2
; CHECK-BE-NEXT:    stxv vs7, 112(r3)
; CHECK-BE-NEXT:    stxv vs6, 96(r3)
; CHECK-BE-NEXT:    stxv vs5, 80(r3)
; CHECK-BE-NEXT:    stxv vs4, 64(r3)
; CHECK-BE-NEXT:    stxv vs3, 48(r3)
; CHECK-BE-NEXT:    stxv vs2, 32(r3)
; CHECK-BE-NEXT:    stxv vs1, 16(r3)
; CHECK-BE-NEXT:    stxv vs0, 0(r3)
; CHECK-BE-NEXT:    blr
entry:
  %a = load <16 x i64>, <16 x i64>* %0, align 128
  %1 = uitofp <16 x i64> %a to <16 x double>
  store <16 x double> %1, <16 x double>* %agg.result, align 128
  ret void
}

define <2 x double> @test2elt_signed(<2 x i64> %a) local_unnamed_addr #0 {
; CHECK-P8-LABEL: test2elt_signed:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    xvcvsxddp v2, v2
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test2elt_signed:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    xvcvsxddp v2, v2
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test2elt_signed:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    xvcvsxddp v2, v2
; CHECK-BE-NEXT:    blr
entry:
  %0 = sitofp <2 x i64> %a to <2 x double>
  ret <2 x double> %0
}

define void @test4elt_signed(<4 x double>* noalias nocapture sret %agg.result, <4 x i64>* nocapture readonly) local_unnamed_addr #1 {
; CHECK-P8-LABEL: test4elt_signed:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    li r5, 16
; CHECK-P8-NEXT:    lxvd2x vs1, 0, r4
; CHECK-P8-NEXT:    lxvd2x vs0, r4, r5
; CHECK-P8-NEXT:    xvcvsxddp vs1, vs1
; CHECK-P8-NEXT:    xvcvsxddp vs0, vs0
; CHECK-P8-NEXT:    stxvd2x vs0, r3, r5
; CHECK-P8-NEXT:    stxvd2x vs1, 0, r3
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test4elt_signed:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxv v2, 16(r4)
; CHECK-P9-NEXT:    lxv v3, 0(r4)
; CHECK-P9-NEXT:    xvcvsxddp vs0, v3
; CHECK-P9-NEXT:    xvcvsxddp vs1, v2
; CHECK-P9-NEXT:    stxv vs1, 16(r3)
; CHECK-P9-NEXT:    stxv vs0, 0(r3)
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test4elt_signed:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv v2, 16(r4)
; CHECK-BE-NEXT:    lxv v3, 0(r4)
; CHECK-BE-NEXT:    xvcvsxddp vs0, v3
; CHECK-BE-NEXT:    xvcvsxddp vs1, v2
; CHECK-BE-NEXT:    stxv vs1, 16(r3)
; CHECK-BE-NEXT:    stxv vs0, 0(r3)
; CHECK-BE-NEXT:    blr
entry:
  %a = load <4 x i64>, <4 x i64>* %0, align 32
  %1 = sitofp <4 x i64> %a to <4 x double>
  store <4 x double> %1, <4 x double>* %agg.result, align 32
  ret void
}

define void @test8elt_signed(<8 x double>* noalias nocapture sret %agg.result, <8 x i64>* nocapture readonly) local_unnamed_addr #1 {
; CHECK-P8-LABEL: test8elt_signed:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    li r5, 16
; CHECK-P8-NEXT:    li r6, 32
; CHECK-P8-NEXT:    li r7, 48
; CHECK-P8-NEXT:    lxvd2x vs3, 0, r4
; CHECK-P8-NEXT:    lxvd2x vs0, r4, r5
; CHECK-P8-NEXT:    lxvd2x vs1, r4, r6
; CHECK-P8-NEXT:    lxvd2x vs2, r4, r7
; CHECK-P8-NEXT:    xvcvsxddp vs3, vs3
; CHECK-P8-NEXT:    xvcvsxddp vs0, vs0
; CHECK-P8-NEXT:    xvcvsxddp vs1, vs1
; CHECK-P8-NEXT:    xvcvsxddp vs2, vs2
; CHECK-P8-NEXT:    stxvd2x vs2, r3, r7
; CHECK-P8-NEXT:    stxvd2x vs1, r3, r6
; CHECK-P8-NEXT:    stxvd2x vs0, r3, r5
; CHECK-P8-NEXT:    stxvd2x vs3, 0, r3
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test8elt_signed:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxv v2, 48(r4)
; CHECK-P9-NEXT:    lxv v3, 32(r4)
; CHECK-P9-NEXT:    lxv v4, 16(r4)
; CHECK-P9-NEXT:    lxv v5, 0(r4)
; CHECK-P9-NEXT:    xvcvsxddp vs0, v5
; CHECK-P9-NEXT:    xvcvsxddp vs1, v4
; CHECK-P9-NEXT:    xvcvsxddp vs2, v3
; CHECK-P9-NEXT:    xvcvsxddp vs3, v2
; CHECK-P9-NEXT:    stxv vs3, 48(r3)
; CHECK-P9-NEXT:    stxv vs2, 32(r3)
; CHECK-P9-NEXT:    stxv vs1, 16(r3)
; CHECK-P9-NEXT:    stxv vs0, 0(r3)
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test8elt_signed:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv v2, 48(r4)
; CHECK-BE-NEXT:    lxv v3, 32(r4)
; CHECK-BE-NEXT:    lxv v4, 16(r4)
; CHECK-BE-NEXT:    lxv v5, 0(r4)
; CHECK-BE-NEXT:    xvcvsxddp vs0, v5
; CHECK-BE-NEXT:    xvcvsxddp vs1, v4
; CHECK-BE-NEXT:    xvcvsxddp vs2, v3
; CHECK-BE-NEXT:    xvcvsxddp vs3, v2
; CHECK-BE-NEXT:    stxv vs3, 48(r3)
; CHECK-BE-NEXT:    stxv vs2, 32(r3)
; CHECK-BE-NEXT:    stxv vs1, 16(r3)
; CHECK-BE-NEXT:    stxv vs0, 0(r3)
; CHECK-BE-NEXT:    blr
entry:
  %a = load <8 x i64>, <8 x i64>* %0, align 64
  %1 = sitofp <8 x i64> %a to <8 x double>
  store <8 x double> %1, <8 x double>* %agg.result, align 64
  ret void
}

define void @test16elt_signed(<16 x double>* noalias nocapture sret %agg.result, <16 x i64>* nocapture readonly) local_unnamed_addr #1 {
; CHECK-P8-LABEL: test16elt_signed:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    li r5, 16
; CHECK-P8-NEXT:    li r6, 32
; CHECK-P8-NEXT:    li r7, 64
; CHECK-P8-NEXT:    li r8, 96
; CHECK-P8-NEXT:    li r9, 112
; CHECK-P8-NEXT:    li r10, 80
; CHECK-P8-NEXT:    li r11, 48
; CHECK-P8-NEXT:    lxvd2x vs0, r4, r5
; CHECK-P8-NEXT:    lxvd2x vs1, r4, r6
; CHECK-P8-NEXT:    lxvd2x vs2, r4, r7
; CHECK-P8-NEXT:    lxvd2x vs3, r4, r8
; CHECK-P8-NEXT:    lxvd2x vs4, r4, r9
; CHECK-P8-NEXT:    lxvd2x vs5, r4, r10
; CHECK-P8-NEXT:    lxvd2x vs6, r4, r11
; CHECK-P8-NEXT:    lxvd2x vs7, 0, r4
; CHECK-P8-NEXT:    xvcvsxddp vs0, vs0
; CHECK-P8-NEXT:    xvcvsxddp vs1, vs1
; CHECK-P8-NEXT:    xvcvsxddp vs2, vs2
; CHECK-P8-NEXT:    xvcvsxddp vs3, vs3
; CHECK-P8-NEXT:    xvcvsxddp vs4, vs4
; CHECK-P8-NEXT:    xvcvsxddp vs5, vs5
; CHECK-P8-NEXT:    xvcvsxddp vs6, vs6
; CHECK-P8-NEXT:    xvcvsxddp vs7, vs7
; CHECK-P8-NEXT:    stxvd2x vs4, r3, r9
; CHECK-P8-NEXT:    stxvd2x vs3, r3, r8
; CHECK-P8-NEXT:    stxvd2x vs5, r3, r10
; CHECK-P8-NEXT:    stxvd2x vs2, r3, r7
; CHECK-P8-NEXT:    stxvd2x vs6, r3, r11
; CHECK-P8-NEXT:    stxvd2x vs1, r3, r6
; CHECK-P8-NEXT:    stxvd2x vs0, r3, r5
; CHECK-P8-NEXT:    stxvd2x vs7, 0, r3
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test16elt_signed:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxv v2, 112(r4)
; CHECK-P9-NEXT:    lxv v3, 96(r4)
; CHECK-P9-NEXT:    lxv v4, 80(r4)
; CHECK-P9-NEXT:    lxv v5, 64(r4)
; CHECK-P9-NEXT:    xvcvsxddp vs4, v5
; CHECK-P9-NEXT:    lxv v0, 48(r4)
; CHECK-P9-NEXT:    lxv v1, 32(r4)
; CHECK-P9-NEXT:    lxv v6, 16(r4)
; CHECK-P9-NEXT:    lxv v7, 0(r4)
; CHECK-P9-NEXT:    xvcvsxddp vs0, v7
; CHECK-P9-NEXT:    xvcvsxddp vs1, v6
; CHECK-P9-NEXT:    xvcvsxddp vs2, v1
; CHECK-P9-NEXT:    xvcvsxddp vs3, v0
; CHECK-P9-NEXT:    xvcvsxddp vs5, v4
; CHECK-P9-NEXT:    xvcvsxddp vs6, v3
; CHECK-P9-NEXT:    xvcvsxddp vs7, v2
; CHECK-P9-NEXT:    stxv vs7, 112(r3)
; CHECK-P9-NEXT:    stxv vs6, 96(r3)
; CHECK-P9-NEXT:    stxv vs5, 80(r3)
; CHECK-P9-NEXT:    stxv vs4, 64(r3)
; CHECK-P9-NEXT:    stxv vs3, 48(r3)
; CHECK-P9-NEXT:    stxv vs2, 32(r3)
; CHECK-P9-NEXT:    stxv vs1, 16(r3)
; CHECK-P9-NEXT:    stxv vs0, 0(r3)
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test16elt_signed:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv v2, 112(r4)
; CHECK-BE-NEXT:    lxv v3, 96(r4)
; CHECK-BE-NEXT:    lxv v4, 80(r4)
; CHECK-BE-NEXT:    lxv v5, 64(r4)
; CHECK-BE-NEXT:    xvcvsxddp vs4, v5
; CHECK-BE-NEXT:    lxv v0, 48(r4)
; CHECK-BE-NEXT:    lxv v1, 32(r4)
; CHECK-BE-NEXT:    lxv v6, 16(r4)
; CHECK-BE-NEXT:    lxv v7, 0(r4)
; CHECK-BE-NEXT:    xvcvsxddp vs0, v7
; CHECK-BE-NEXT:    xvcvsxddp vs1, v6
; CHECK-BE-NEXT:    xvcvsxddp vs2, v1
; CHECK-BE-NEXT:    xvcvsxddp vs3, v0
; CHECK-BE-NEXT:    xvcvsxddp vs5, v4
; CHECK-BE-NEXT:    xvcvsxddp vs6, v3
; CHECK-BE-NEXT:    xvcvsxddp vs7, v2
; CHECK-BE-NEXT:    stxv vs7, 112(r3)
; CHECK-BE-NEXT:    stxv vs6, 96(r3)
; CHECK-BE-NEXT:    stxv vs5, 80(r3)
; CHECK-BE-NEXT:    stxv vs4, 64(r3)
; CHECK-BE-NEXT:    stxv vs3, 48(r3)
; CHECK-BE-NEXT:    stxv vs2, 32(r3)
; CHECK-BE-NEXT:    stxv vs1, 16(r3)
; CHECK-BE-NEXT:    stxv vs0, 0(r3)
; CHECK-BE-NEXT:    blr
entry:
  %a = load <16 x i64>, <16 x i64>* %0, align 128
  %1 = sitofp <16 x i64> %a to <16 x double>
  store <16 x double> %1, <16 x double>* %agg.result, align 128
  ret void
}
