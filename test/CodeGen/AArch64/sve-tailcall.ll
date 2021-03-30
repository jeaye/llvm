; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64 -mattr=+sve < %s 2>%t | FileCheck %s
; RUN: FileCheck --check-prefix=WARN --allow-empty %s <%t

; If this check fails please read test/CodeGen/AArch64/README for instructions on how to resolve it.
; WARN-NOT: warning

; Check that a tail call from an SVE function to another SVE function
; can use a tail-call, as the same registers will be preserved by the
; callee.
define <vscale x 4 x i32> @sve_caller_sve_callee() nounwind {
; CHECK-LABEL: sve_caller_sve_callee:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x29, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-2
; CHECK-NEXT:    str z10, [sp] // 16-byte Folded Spill
; CHECK-NEXT:    str z9, [sp, #1, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    //APP
; CHECK-NEXT:    //NO_APP
; CHECK-NEXT:    ldr z10, [sp] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z9, [sp, #1, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    addvl sp, sp, #2
; CHECK-NEXT:    ldr x29, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    b sve_callee
  tail call void asm sideeffect "", "~{z9},~{z10}"()
  %call = tail call <vscale x 4 x i32> @sve_callee()
  ret <vscale x 4 x i32> %call
}

define <vscale x 4 x i32> @sve_caller_sve_callee_fastcc() nounwind {
; CHECK-LABEL: sve_caller_sve_callee_fastcc:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x29, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-2
; CHECK-NEXT:    str z10, [sp] // 16-byte Folded Spill
; CHECK-NEXT:    str z9, [sp, #1, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    //APP
; CHECK-NEXT:    //NO_APP
; CHECK-NEXT:    ldr z10, [sp] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z9, [sp, #1, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    addvl sp, sp, #2
; CHECK-NEXT:    ldr x29, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    b sve_callee
  tail call void asm sideeffect "", "~{z9},~{z10}"()
  %call = tail call fastcc <vscale x 4 x i32> @sve_callee()
  ret <vscale x 4 x i32> %call
}

declare <vscale x 4 x i32> @sve_callee()

; Check that a tail call from an SVE function to a non-SVE function
; does not use a tail-call, because after the call many of the SVE
; registers may be clobbered and needs to be restored.
define i32 @sve_caller_non_sve_callee(<vscale x 4 x i32> %arg) nounwind {
; CHECK-LABEL: sve_caller_non_sve_callee:
; CHECK:       // %bb.0:
; CHECK-NEXT:    stp x29, x30, [sp, #-16]! // 16-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-18
; CHECK-NEXT:    str p15, [sp, #4, mul vl] // 2-byte Folded Spill
; CHECK-NEXT:    str p14, [sp, #5, mul vl] // 2-byte Folded Spill
; CHECK-NEXT:    str p13, [sp, #6, mul vl] // 2-byte Folded Spill
; CHECK-NEXT:    str p12, [sp, #7, mul vl] // 2-byte Folded Spill
; CHECK-NEXT:    str p11, [sp, #8, mul vl] // 2-byte Folded Spill
; CHECK-NEXT:    str p10, [sp, #9, mul vl] // 2-byte Folded Spill
; CHECK-NEXT:    str p9, [sp, #10, mul vl] // 2-byte Folded Spill
; CHECK-NEXT:    str p8, [sp, #11, mul vl] // 2-byte Folded Spill
; CHECK-NEXT:    str p7, [sp, #12, mul vl] // 2-byte Folded Spill
; CHECK-NEXT:    str p6, [sp, #13, mul vl] // 2-byte Folded Spill
; CHECK-NEXT:    str p5, [sp, #14, mul vl] // 2-byte Folded Spill
; CHECK-NEXT:    str p4, [sp, #15, mul vl] // 2-byte Folded Spill
; CHECK-NEXT:    str z23, [sp, #2, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    str z22, [sp, #3, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    str z21, [sp, #4, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    str z20, [sp, #5, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    str z19, [sp, #6, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    str z18, [sp, #7, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    str z17, [sp, #8, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    str z16, [sp, #9, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    str z15, [sp, #10, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    str z14, [sp, #11, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    str z13, [sp, #12, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    str z12, [sp, #13, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    str z11, [sp, #14, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    str z10, [sp, #15, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    str z9, [sp, #16, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    str z8, [sp, #17, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    //APP
; CHECK-NEXT:    //NO_APP
; CHECK-NEXT:    bl non_sve_callee
; CHECK-NEXT:    ldr p15, [sp, #4, mul vl] // 2-byte Folded Reload
; CHECK-NEXT:    ldr p14, [sp, #5, mul vl] // 2-byte Folded Reload
; CHECK-NEXT:    ldr p13, [sp, #6, mul vl] // 2-byte Folded Reload
; CHECK-NEXT:    ldr p12, [sp, #7, mul vl] // 2-byte Folded Reload
; CHECK-NEXT:    ldr p11, [sp, #8, mul vl] // 2-byte Folded Reload
; CHECK-NEXT:    ldr p10, [sp, #9, mul vl] // 2-byte Folded Reload
; CHECK-NEXT:    ldr p9, [sp, #10, mul vl] // 2-byte Folded Reload
; CHECK-NEXT:    ldr p8, [sp, #11, mul vl] // 2-byte Folded Reload
; CHECK-NEXT:    ldr p7, [sp, #12, mul vl] // 2-byte Folded Reload
; CHECK-NEXT:    ldr p6, [sp, #13, mul vl] // 2-byte Folded Reload
; CHECK-NEXT:    ldr p5, [sp, #14, mul vl] // 2-byte Folded Reload
; CHECK-NEXT:    ldr p4, [sp, #15, mul vl] // 2-byte Folded Reload
; CHECK-NEXT:    ldr z23, [sp, #2, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z22, [sp, #3, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z21, [sp, #4, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z20, [sp, #5, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z19, [sp, #6, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z18, [sp, #7, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z17, [sp, #8, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z16, [sp, #9, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z15, [sp, #10, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z14, [sp, #11, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z13, [sp, #12, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z12, [sp, #13, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z11, [sp, #14, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z10, [sp, #15, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z9, [sp, #16, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z8, [sp, #17, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    addvl sp, sp, #18
; CHECK-NEXT:    ldp x29, x30, [sp], #16 // 16-byte Folded Reload
; CHECK-NEXT:    ret
  tail call void asm sideeffect "", "~{z9},~{z10}"()
  %call = tail call i32 @non_sve_callee()
  ret i32 %call
}

; Check that a tail call from an SVE function to a non-SVE function
; does not use a tail-call, because after the call many of the SVE
; registers may be clobbered and needs to be restored.
define i32 @sve_caller_non_sve_callee_fastcc(<vscale x 4 x i32> %arg) nounwind {
; CHECK-LABEL: sve_caller_non_sve_callee_fastcc:
; CHECK:       // %bb.0:
; CHECK-NEXT:    stp x29, x30, [sp, #-16]! // 16-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-18
; CHECK-NEXT:    str p15, [sp, #4, mul vl] // 2-byte Folded Spill
; CHECK-NEXT:    str p14, [sp, #5, mul vl] // 2-byte Folded Spill
; CHECK-NEXT:    str p13, [sp, #6, mul vl] // 2-byte Folded Spill
; CHECK-NEXT:    str p12, [sp, #7, mul vl] // 2-byte Folded Spill
; CHECK-NEXT:    str p11, [sp, #8, mul vl] // 2-byte Folded Spill
; CHECK-NEXT:    str p10, [sp, #9, mul vl] // 2-byte Folded Spill
; CHECK-NEXT:    str p9, [sp, #10, mul vl] // 2-byte Folded Spill
; CHECK-NEXT:    str p8, [sp, #11, mul vl] // 2-byte Folded Spill
; CHECK-NEXT:    str p7, [sp, #12, mul vl] // 2-byte Folded Spill
; CHECK-NEXT:    str p6, [sp, #13, mul vl] // 2-byte Folded Spill
; CHECK-NEXT:    str p5, [sp, #14, mul vl] // 2-byte Folded Spill
; CHECK-NEXT:    str p4, [sp, #15, mul vl] // 2-byte Folded Spill
; CHECK-NEXT:    str z23, [sp, #2, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    str z22, [sp, #3, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    str z21, [sp, #4, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    str z20, [sp, #5, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    str z19, [sp, #6, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    str z18, [sp, #7, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    str z17, [sp, #8, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    str z16, [sp, #9, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    str z15, [sp, #10, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    str z14, [sp, #11, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    str z13, [sp, #12, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    str z12, [sp, #13, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    str z11, [sp, #14, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    str z10, [sp, #15, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    str z9, [sp, #16, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    str z8, [sp, #17, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    //APP
; CHECK-NEXT:    //NO_APP
; CHECK-NEXT:    bl non_sve_callee
; CHECK-NEXT:    ldr p15, [sp, #4, mul vl] // 2-byte Folded Reload
; CHECK-NEXT:    ldr p14, [sp, #5, mul vl] // 2-byte Folded Reload
; CHECK-NEXT:    ldr p13, [sp, #6, mul vl] // 2-byte Folded Reload
; CHECK-NEXT:    ldr p12, [sp, #7, mul vl] // 2-byte Folded Reload
; CHECK-NEXT:    ldr p11, [sp, #8, mul vl] // 2-byte Folded Reload
; CHECK-NEXT:    ldr p10, [sp, #9, mul vl] // 2-byte Folded Reload
; CHECK-NEXT:    ldr p9, [sp, #10, mul vl] // 2-byte Folded Reload
; CHECK-NEXT:    ldr p8, [sp, #11, mul vl] // 2-byte Folded Reload
; CHECK-NEXT:    ldr p7, [sp, #12, mul vl] // 2-byte Folded Reload
; CHECK-NEXT:    ldr p6, [sp, #13, mul vl] // 2-byte Folded Reload
; CHECK-NEXT:    ldr p5, [sp, #14, mul vl] // 2-byte Folded Reload
; CHECK-NEXT:    ldr p4, [sp, #15, mul vl] // 2-byte Folded Reload
; CHECK-NEXT:    ldr z23, [sp, #2, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z22, [sp, #3, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z21, [sp, #4, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z20, [sp, #5, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z19, [sp, #6, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z18, [sp, #7, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z17, [sp, #8, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z16, [sp, #9, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z15, [sp, #10, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z14, [sp, #11, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z13, [sp, #12, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z12, [sp, #13, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z11, [sp, #14, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z10, [sp, #15, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z9, [sp, #16, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z8, [sp, #17, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    addvl sp, sp, #18
; CHECK-NEXT:    ldp x29, x30, [sp], #16 // 16-byte Folded Reload
; CHECK-NEXT:    ret
  tail call void asm sideeffect "", "~{z9},~{z10}"()
  %call = tail call fastcc i32 @non_sve_callee()
  ret i32 %call
}

declare i32 @non_sve_callee()
