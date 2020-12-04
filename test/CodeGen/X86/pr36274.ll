; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i386-unknown-linux-gnu | FileCheck %s

; This tests is checking for a case where the x86 load-op-store fusion
; misses a dependence between the fused load and a non-fused operand
; to the load causing a cycle. Here the dependence in question comes
; from the carry in input of the adcl.

@vx = external dso_local local_unnamed_addr global <2 x i32>, align 8

define void @pr36274(i32* %somewhere) {
; CHECK-LABEL: pr36274:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl vx+4, %eax
; CHECK-NEXT:    addl $1, vx
; CHECK-NEXT:    adcl $0, %eax
; CHECK-NEXT:    movl %eax, vx+4
; CHECK-NEXT:    retl
  %a0  = getelementptr <2 x i32>, <2 x i32>* @vx, i32 0, i32 0
  %a1  = getelementptr <2 x i32>, <2 x i32>* @vx, i32 0, i32 1
  %x1  = load volatile i32, i32* %a1, align 4
  %x0  = load volatile i32, i32* %a0, align 8
  %vx0 = insertelement <2 x i32> undef, i32 %x0, i32 0
  %vx1 = insertelement <2 x i32> %vx0, i32 %x1, i32 1
  %x = bitcast <2 x i32> %vx1 to i64
  %add = add i64 %x, 1
  %vadd = bitcast i64 %add to <2 x i32>
  %vx1_0 = extractelement <2 x i32> %vadd, i32 0
  %vx1_1 = extractelement <2 x i32> %vadd, i32 1
  store i32 %vx1_0, i32* %a0, align 8
  store i32 %vx1_1, i32* %a1, align 4
  ret void
}
