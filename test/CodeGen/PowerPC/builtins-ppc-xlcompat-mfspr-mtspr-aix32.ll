; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc-unknown-aix \
; RUN:   -mcpu=pwr7 < %s | FileCheck %s

declare i32 @llvm.ppc.mfspr.i32(i32 immarg)
declare void @llvm.ppc.mtspr.i32(i32 immarg, i32)

@ula = external dso_local global i32, align 4

define dso_local i32 @test_mfxer() {
; CHECK-LABEL: test_mfxer:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    mfxer 3
; CHECK-NEXT:    blr
entry:
  %0 = call i32 @llvm.ppc.mfspr.i32(i32 1)
  ret i32 %0
}

define dso_local i32 @test_mflr() {
; CHECK-LABEL: test_mflr:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    mfspr 3, 8
; CHECK-NEXT:    blr
entry:
  %0 = call i32 @llvm.ppc.mfspr.i32(i32 8)
  ret i32 %0
}

define dso_local i32 @test_mfctr() {
; CHECK-LABEL: test_mfctr:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    mfspr 3, 9
; CHECK-NEXT:    blr
entry:
  %0 = call i32 @llvm.ppc.mfspr.i32(i32 9)
  ret i32 %0
}

define dso_local i32 @test_mfppr() {
; CHECK-LABEL: test_mfppr:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    mfspr 3, 896
; CHECK-NEXT:    blr
entry:
  %0 = call i32 @llvm.ppc.mfspr.i32(i32 896)
  ret i32 %0
}

define dso_local i32 @test_mfppr32() {
; CHECK-LABEL: test_mfppr32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    mfspr 3, 898
; CHECK-NEXT:    blr
entry:
  %0 = call i32 @llvm.ppc.mfspr.i32(i32 898)
  ret i32 %0
}

define dso_local void @test_mtxer() {
; CHECK-LABEL: test_mtxer:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lwz 3, L..C0(2) # @ula
; CHECK-NEXT:    lwz 3, 0(3)
; CHECK-NEXT:    mtxer 3
; CHECK-NEXT:    blr
entry:
  %0 = load i32, i32* @ula, align 8
  tail call void @llvm.ppc.mtspr.i32(i32 1, i32 %0)
  ret void
}

define dso_local void @test_mtlr() {
; CHECK-LABEL: test_mtlr:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lwz 3, L..C0(2) # @ula
; CHECK-NEXT:    lwz 3, 0(3)
; CHECK-NEXT:    mtspr 8, 3
; CHECK-NEXT:    blr
entry:
  %0 = load i32, i32* @ula, align 8
  tail call void @llvm.ppc.mtspr.i32(i32 8, i32 %0)
  ret void
}

define dso_local void @test_mtctr() {
; CHECK-LABEL: test_mtctr:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lwz 3, L..C0(2) # @ula
; CHECK-NEXT:    lwz 3, 0(3)
; CHECK-NEXT:    mtspr 9, 3
; CHECK-NEXT:    blr
entry:
  %0 = load i32, i32* @ula, align 8
  tail call void @llvm.ppc.mtspr.i32(i32 9, i32 %0)
  ret void
}

define dso_local void @test_mtppr() {
; CHECK-LABEL: test_mtppr:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lwz 3, L..C0(2) # @ula
; CHECK-NEXT:    lwz 3, 0(3)
; CHECK-NEXT:    mtspr 896, 3
; CHECK-NEXT:    blr
entry:
  %0 = load i32, i32* @ula, align 8
  tail call void @llvm.ppc.mtspr.i32(i32 896, i32 %0)
  ret void
}

define dso_local void @test_mtppr32() {
; CHECK-LABEL: test_mtppr32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lwz 3, L..C0(2) # @ula
; CHECK-NEXT:    lwz 3, 0(3)
; CHECK-NEXT:    mtspr 898, 3
; CHECK-NEXT:    blr
entry:
  %0 = load i32, i32* @ula, align 8
  tail call void @llvm.ppc.mtspr.i32(i32 898, i32 %0)
  ret void
}
