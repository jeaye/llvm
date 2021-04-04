; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv64 -mattr=+experimental-b -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV64IB
; RUN: llc -mtriple=riscv64 -mattr=+experimental-zbb -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV64IBB

declare i32 @llvm.riscv.orc.b.i32(i32)

define signext i32 @orcb32(i32 signext %a) nounwind {
; RV64IB-LABEL: orcb32:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    gorciw a0, a0, 7
; RV64IB-NEXT:    ret
;
; RV64IBB-LABEL: orcb32:
; RV64IBB:       # %bb.0:
; RV64IBB-NEXT:    orc.b a0, a0
; RV64IBB-NEXT:    sext.w a0, a0
; RV64IBB-NEXT:    ret
  %tmp = call i32 @llvm.riscv.orc.b.i32(i32 %a)
 ret i32 %tmp
}

declare i64 @llvm.riscv.orc.b.i64(i64)

define i64 @orcb64(i64 %a) nounwind {
; RV64IB-LABEL: orcb64:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    orc.b a0, a0
; RV64IB-NEXT:    ret
;
; RV64IBB-LABEL: orcb64:
; RV64IBB:       # %bb.0:
; RV64IBB-NEXT:    orc.b a0, a0
; RV64IBB-NEXT:    ret
  %tmp = call i64 @llvm.riscv.orc.b.i64(i64 %a)
 ret i64 %tmp
}
