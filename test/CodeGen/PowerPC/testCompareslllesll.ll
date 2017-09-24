; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-linux-gnu -O2 \
; RUN:   -ppc-asm-full-reg-names -mcpu=pwr8 < %s | FileCheck %s \
; RUN:  --implicit-check-not cmpw --implicit-check-not cmpd --implicit-check-not cmpl
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu -O2 \
; RUN:   -ppc-asm-full-reg-names -mcpu=pwr8 < %s | FileCheck %s \
; RUN:  --implicit-check-not cmpw --implicit-check-not cmpd --implicit-check-not cmpl
; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
@glob = common local_unnamed_addr global i64 0, align 8

; Function Attrs: norecurse nounwind readnone
define i64 @test_lllesll(i64 %a, i64 %b)  {
; CHECK-LABEL: test_lllesll:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    sradi r5, r4, 63
; CHECK-NEXT:    rldicl r6, r3, 1, 63
; CHECK-NEXT:    subfc r12, r3, r4
; CHECK-NEXT:    adde r3, r5, r6
; CHECK-NEXT:    blr
entry:
  %cmp = icmp sle i64 %a, %b
  %conv1 = zext i1 %cmp to i64
  ret i64 %conv1
}

; Function Attrs: norecurse nounwind readnone
define i64 @test_lllesll_sext(i64 %a, i64 %b)  {
; CHECK-LABEL: test_lllesll_sext:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    sradi r5, r4, 63
; CHECK-NEXT:    rldicl r6, r3, 1, 63
; CHECK-NEXT:    subfc r12, r3, r4
; CHECK-NEXT:    adde r3, r5, r6
; CHECK-NEXT:    neg r3, r3
; CHECK-NEXT:    blr
entry:
  %cmp = icmp sle i64 %a, %b
  %conv1 = sext i1 %cmp to i64
  ret i64 %conv1
}

; Function Attrs: norecurse nounwind readnone
define i64 @test_lllesll_z(i64 %a)  {
; CHECK-LABEL: test_lllesll_z:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    addi r4, r3, -1
; CHECK-NEXT:    or r3, r4, r3
; CHECK-NEXT:    rldicl r3, r3, 1, 63
; CHECK-NEXT:    blr
entry:
  %cmp = icmp slt i64 %a, 1
  %conv1 = zext i1 %cmp to i64
  ret i64 %conv1
}

; Function Attrs: norecurse nounwind readnone
define i64 @test_lllesll_sext_z(i64 %a)  {
; CHECK-LABEL: test_lllesll_sext_z:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    addi r4, r3, -1
; CHECK-NEXT:    or r3, r4, r3
; CHECK-NEXT:    sradi r3, r3, 63
; CHECK-NEXT:    blr
entry:
  %cmp = icmp slt i64 %a, 1
  %conv1 = sext i1 %cmp to i64
  ret i64 %conv1
}

; Function Attrs: norecurse nounwind
define void @test_lllesll_store(i64 %a, i64 %b) {
; CHECK-LABEL: test_lllesll_store:
; CHECK:       # BB#0: # %entry
; CHECK:    sradi r6, r4, 63
; CHECK:    subfc r4, r3, r4
; CHECK:    rldicl r3, r3, 1, 63
; CHECK:    adde r3, r6, r3
; CHECK:    std r3,
; CHECK-NEXT:    blr
entry:
  %cmp = icmp sle i64 %a, %b
  %conv1 = zext i1 %cmp to i64
  store i64 %conv1, i64* @glob, align 8
  ret void
}

; Function Attrs: norecurse nounwind
define void @test_lllesll_sext_store(i64 %a, i64 %b) {
; CHECK-LABEL: test_lllesll_sext_store:
; CHECK:       # BB#0: # %entry
; CHECK:    sradi r6, r4, 63
; CHECK-DAG:    rldicl r3, r3, 1, 63
; CHECK-DAG:    subfc r4, r3, r4
; CHECK:    adde r3, r6, r3
; CHECK:    neg r3, r3
; CHECK:    std r3, 0(r4)
; CHECK-NEXT:    blr
entry:
  %cmp = icmp sle i64 %a, %b
  %conv1 = sext i1 %cmp to i64
  store i64 %conv1, i64* @glob, align 8
  ret void
}

; Function Attrs: norecurse nounwind
define void @test_lllesll_z_store(i64 %a) {
; CHECK-LABEL: test_lllesll_z_store:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    addis r4, r2, .LC0@toc@ha
; CHECK-NEXT:    addi r5, r3, -1
; CHECK-NEXT:    ld r4, .LC0@toc@l(r4)
; CHECK-NEXT:    or r3, r5, r3
; CHECK-NEXT:    rldicl r3, r3, 1, 63
; CHECK-NEXT:    std r3, 0(r4)
; CHECK-NEXT:    blr
entry:
  %cmp = icmp slt i64 %a, 1
  %conv1 = zext i1 %cmp to i64
  store i64 %conv1, i64* @glob, align 8
  ret void
}

; Function Attrs: norecurse nounwind
define void @test_lllesll_sext_z_store(i64 %a) {
; CHECK-LABEL: test_lllesll_sext_z_store:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    addis r4, r2, .LC0@toc@ha
; CHECK-NEXT:    addi r5, r3, -1
; CHECK-NEXT:    ld r4, .LC0@toc@l(r4)
; CHECK-NEXT:    or r3, r5, r3
; CHECK-NEXT:    sradi r3, r3, 63
; CHECK-NEXT:    std r3, 0(r4)
; CHECK-NEXT:    blr
entry:
  %cmp = icmp slt i64 %a, 1
  %conv1 = sext i1 %cmp to i64
  store i64 %conv1, i64* @glob, align 8
  ret void
}
