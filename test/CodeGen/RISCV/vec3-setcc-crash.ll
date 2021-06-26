; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+experimental-v -verify-machineinstrs < %s \
; RUN:     | FileCheck %s --check-prefix=RV32
; RUN: llc -mtriple=riscv64 -mattr=+experimental-v -verify-machineinstrs < %s \
; RUN:     | FileCheck %s --check-prefix=RV64

; This test would lead one of the DAGCombiner's visitVSELECT optimizations to
; call getSetCCResultType, from which we'd return an invalid MVT (<3 x i1>)
; upon seeing that the V extension is enabled. The invalid MVT has a null
; Type*, which then segfaulted when accessed (as an EVT).
define void @vec3_setcc_crash(<3 x i8>* %in, <3 x i8>* %out) {
; RV32-LABEL: vec3_setcc_crash:
; RV32:       # %bb.0:
; RV32-NEXT:    lw a0, 0(a0)
; RV32-NEXT:    lui a2, 16
; RV32-NEXT:    addi a2, a2, -256
; RV32-NEXT:    and a2, a0, a2
; RV32-NEXT:    slli a3, a2, 16
; RV32-NEXT:    srai a6, a3, 24
; RV32-NEXT:    slli a4, a0, 24
; RV32-NEXT:    srai a3, a4, 24
; RV32-NEXT:    slli a4, a0, 8
; RV32-NEXT:    mv a5, a0
; RV32-NEXT:    bgtz a3, .LBB0_2
; RV32-NEXT:  # %bb.1:
; RV32-NEXT:    mv a5, zero
; RV32-NEXT:  .LBB0_2:
; RV32-NEXT:    srai a4, a4, 24
; RV32-NEXT:    andi a5, a5, 255
; RV32-NEXT:    bgtz a6, .LBB0_4
; RV32-NEXT:  # %bb.3:
; RV32-NEXT:    mv a2, zero
; RV32-NEXT:    j .LBB0_5
; RV32-NEXT:  .LBB0_4:
; RV32-NEXT:    srli a2, a2, 8
; RV32-NEXT:  .LBB0_5:
; RV32-NEXT:    slli a2, a2, 8
; RV32-NEXT:    or a2, a5, a2
; RV32-NEXT:    bgtz a4, .LBB0_7
; RV32-NEXT:  # %bb.6:
; RV32-NEXT:    mv a0, zero
; RV32-NEXT:    j .LBB0_8
; RV32-NEXT:  .LBB0_7:
; RV32-NEXT:    srli a0, a0, 16
; RV32-NEXT:  .LBB0_8:
; RV32-NEXT:    sb a0, 2(a1)
; RV32-NEXT:    sh a2, 0(a1)
; RV32-NEXT:    ret
;
; RV64-LABEL: vec3_setcc_crash:
; RV64:       # %bb.0:
; RV64-NEXT:    lwu a0, 0(a0)
; RV64-NEXT:    lui a2, 16
; RV64-NEXT:    addiw a2, a2, -256
; RV64-NEXT:    and a2, a0, a2
; RV64-NEXT:    slli a3, a2, 48
; RV64-NEXT:    srai a6, a3, 56
; RV64-NEXT:    slli a4, a0, 56
; RV64-NEXT:    srai a3, a4, 56
; RV64-NEXT:    slli a4, a0, 40
; RV64-NEXT:    mv a5, a0
; RV64-NEXT:    bgtz a3, .LBB0_2
; RV64-NEXT:  # %bb.1:
; RV64-NEXT:    mv a5, zero
; RV64-NEXT:  .LBB0_2:
; RV64-NEXT:    srai a4, a4, 56
; RV64-NEXT:    andi a5, a5, 255
; RV64-NEXT:    bgtz a6, .LBB0_4
; RV64-NEXT:  # %bb.3:
; RV64-NEXT:    mv a2, zero
; RV64-NEXT:    j .LBB0_5
; RV64-NEXT:  .LBB0_4:
; RV64-NEXT:    srliw a2, a2, 8
; RV64-NEXT:  .LBB0_5:
; RV64-NEXT:    slli a2, a2, 8
; RV64-NEXT:    or a2, a5, a2
; RV64-NEXT:    bgtz a4, .LBB0_7
; RV64-NEXT:  # %bb.6:
; RV64-NEXT:    mv a0, zero
; RV64-NEXT:    j .LBB0_8
; RV64-NEXT:  .LBB0_7:
; RV64-NEXT:    srliw a0, a0, 16
; RV64-NEXT:  .LBB0_8:
; RV64-NEXT:    sb a0, 2(a1)
; RV64-NEXT:    sh a2, 0(a1)
; RV64-NEXT:    ret
  %a = load <3 x i8>, <3 x i8>* %in
  %cmp = icmp sgt <3 x i8> %a, zeroinitializer
  %c = select <3 x i1> %cmp, <3 x i8> %a, <3 x i8> zeroinitializer
  store <3 x i8> %c, <3 x i8>* %out
  ret void
}
