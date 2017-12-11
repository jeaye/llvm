; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV32I %s

%struct.key_t = type { i32, [16 x i8] }

; FIXME: prologue and epilogue insertion must be implemented to complete this
; test

define i32 @test() nounwind {
; RV32I-LABEL: test:
; RV32I:       # %bb.0:
; RV32I-NEXT:    sw ra, 28(sp)
; RV32I-NEXT:    sw zero, -8(s0)
; RV32I-NEXT:    sw zero, -12(s0)
; RV32I-NEXT:    sw zero, -16(s0)
; RV32I-NEXT:    sw zero, -20(s0)
; RV32I-NEXT:    sw zero, -24(s0)
; RV32I-NEXT:    lui a0, %hi(test1)
; RV32I-NEXT:    addi a1, a0, %lo(test1)
; RV32I-NEXT:    addi a0, s0, -20
; RV32I-NEXT:    jalr ra, a1, 0
; RV32I-NEXT:    addi a0, zero, 0
; RV32I-NEXT:    lw ra, 28(sp)
; RV32I-NEXT:    jalr zero, ra, 0
  %key = alloca %struct.key_t, align 4
  %1 = bitcast %struct.key_t* %key to i8*
  call void @llvm.memset.p0i8.i64(i8* %1, i8 0, i64 20, i32 4, i1 false)
  %2 = getelementptr inbounds %struct.key_t, %struct.key_t* %key, i64 0, i32 1, i64 0
  call void @test1(i8* %2) #3
  ret i32 0
}

declare void @llvm.memset.p0i8.i64(i8* nocapture, i8, i64, i32, i1)

declare void @test1(i8*)
