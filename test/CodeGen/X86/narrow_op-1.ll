; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-- | FileCheck %s

	%struct.bf = type { i64, i16, i16, i32 }
@bfi = common dso_local global %struct.bf zeroinitializer, align 16

define dso_local void @t1() nounwind optsize ssp {
; CHECK-LABEL: t1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    orb $1, bfi+10(%rip)
; CHECK-NEXT:    retq
entry:
	%0 = load i32, i32* bitcast (i16* getelementptr (%struct.bf, %struct.bf* @bfi, i32 0, i32 1) to i32*), align 8
	%1 = or i32 %0, 65536
	store i32 %1, i32* bitcast (i16* getelementptr (%struct.bf, %struct.bf* @bfi, i32 0, i32 1) to i32*), align 8
	ret void

}

define dso_local void @t2() nounwind optsize ssp {
; CHECK-LABEL: t2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    orl $16842752, bfi+8(%rip) # imm = 0x1010000
; CHECK-NEXT:    retq
entry:
	%0 = load i32, i32* bitcast (i16* getelementptr (%struct.bf, %struct.bf* @bfi, i32 0, i32 1) to i32*), align 8
	%1 = or i32 %0, 16842752
	store i32 %1, i32* bitcast (i16* getelementptr (%struct.bf, %struct.bf* @bfi, i32 0, i32 1) to i32*), align 8
	ret void

}
