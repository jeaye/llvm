; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -target-abi ilp32f -mattr=+f < %s \
; RUN:     | FileCheck --check-prefix=RV32F %s
; RUN: llc -mtriple=riscv32 -target-abi ilp32d -mattr=+f,+d < %s \
; RUN:     | FileCheck --check-prefix=RV32D %s
; RUN: llc -mtriple=riscv64 -target-abi lp64f -mattr=+f < %s \
; RUN:     | FileCheck --check-prefix=RV64F %s
; RUN: llc -mtriple=riscv64 -target-abi lp64d -mattr=+f,+d < %s \
; RUN:     | FileCheck --check-prefix=RV64D %s

define float @f32_positive_zero(float *%pf) nounwind {
; RV32F-LABEL: f32_positive_zero:
; RV32F:       # %bb.0:
; RV32F-NEXT:    lui a0, %hi(.LCPI0_0)
; RV32F-NEXT:    addi a0, a0, %lo(.LCPI0_0)
; RV32F-NEXT:    flw fa0, 0(a0)
; RV32F-NEXT:    ret
;
; RV32D-LABEL: f32_positive_zero:
; RV32D:       # %bb.0:
; RV32D-NEXT:    lui a0, %hi(.LCPI0_0)
; RV32D-NEXT:    addi a0, a0, %lo(.LCPI0_0)
; RV32D-NEXT:    flw fa0, 0(a0)
; RV32D-NEXT:    ret
;
; RV64F-LABEL: f32_positive_zero:
; RV64F:       # %bb.0:
; RV64F-NEXT:    lui a0, %hi(.LCPI0_0)
; RV64F-NEXT:    addi a0, a0, %lo(.LCPI0_0)
; RV64F-NEXT:    flw fa0, 0(a0)
; RV64F-NEXT:    ret
;
; RV64D-LABEL: f32_positive_zero:
; RV64D:       # %bb.0:
; RV64D-NEXT:    lui a0, %hi(.LCPI0_0)
; RV64D-NEXT:    addi a0, a0, %lo(.LCPI0_0)
; RV64D-NEXT:    flw fa0, 0(a0)
; RV64D-NEXT:    ret
  ret float 0.0
}

define float @f32_negative_zero(float *%pf) nounwind {
; RV32F-LABEL: f32_negative_zero:
; RV32F:       # %bb.0:
; RV32F-NEXT:    lui a0, %hi(.LCPI1_0)
; RV32F-NEXT:    addi a0, a0, %lo(.LCPI1_0)
; RV32F-NEXT:    flw fa0, 0(a0)
; RV32F-NEXT:    ret
;
; RV32D-LABEL: f32_negative_zero:
; RV32D:       # %bb.0:
; RV32D-NEXT:    lui a0, %hi(.LCPI1_0)
; RV32D-NEXT:    addi a0, a0, %lo(.LCPI1_0)
; RV32D-NEXT:    flw fa0, 0(a0)
; RV32D-NEXT:    ret
;
; RV64F-LABEL: f32_negative_zero:
; RV64F:       # %bb.0:
; RV64F-NEXT:    lui a0, %hi(.LCPI1_0)
; RV64F-NEXT:    addi a0, a0, %lo(.LCPI1_0)
; RV64F-NEXT:    flw fa0, 0(a0)
; RV64F-NEXT:    ret
;
; RV64D-LABEL: f32_negative_zero:
; RV64D:       # %bb.0:
; RV64D-NEXT:    lui a0, %hi(.LCPI1_0)
; RV64D-NEXT:    addi a0, a0, %lo(.LCPI1_0)
; RV64D-NEXT:    flw fa0, 0(a0)
; RV64D-NEXT:    ret
  ret float -0.0
}

define double @f64_positive_zero(double *%pd) nounwind {
; RV32F-LABEL: f64_positive_zero:
; RV32F:       # %bb.0:
; RV32F-NEXT:    mv a0, zero
; RV32F-NEXT:    mv a1, zero
; RV32F-NEXT:    ret
;
; RV32D-LABEL: f64_positive_zero:
; RV32D:       # %bb.0:
; RV32D-NEXT:    lui a0, %hi(.LCPI2_0)
; RV32D-NEXT:    addi a0, a0, %lo(.LCPI2_0)
; RV32D-NEXT:    fld fa0, 0(a0)
; RV32D-NEXT:    ret
;
; RV64F-LABEL: f64_positive_zero:
; RV64F:       # %bb.0:
; RV64F-NEXT:    mv a0, zero
; RV64F-NEXT:    ret
;
; RV64D-LABEL: f64_positive_zero:
; RV64D:       # %bb.0:
; RV64D-NEXT:    lui a0, %hi(.LCPI2_0)
; RV64D-NEXT:    addi a0, a0, %lo(.LCPI2_0)
; RV64D-NEXT:    fld fa0, 0(a0)
; RV64D-NEXT:    ret
  ret double 0.0
}

define double @f64_negative_zero(double *%pd) nounwind {
; RV32F-LABEL: f64_negative_zero:
; RV32F:       # %bb.0:
; RV32F-NEXT:    lui a1, 524288
; RV32F-NEXT:    mv a0, zero
; RV32F-NEXT:    ret
;
; RV32D-LABEL: f64_negative_zero:
; RV32D:       # %bb.0:
; RV32D-NEXT:    lui a0, %hi(.LCPI3_0)
; RV32D-NEXT:    addi a0, a0, %lo(.LCPI3_0)
; RV32D-NEXT:    fld fa0, 0(a0)
; RV32D-NEXT:    ret
;
; RV64F-LABEL: f64_negative_zero:
; RV64F:       # %bb.0:
; RV64F-NEXT:    addi a0, zero, -1
; RV64F-NEXT:    slli a0, a0, 63
; RV64F-NEXT:    ret
;
; RV64D-LABEL: f64_negative_zero:
; RV64D:       # %bb.0:
; RV64D-NEXT:    lui a0, %hi(.LCPI3_0)
; RV64D-NEXT:    addi a0, a0, %lo(.LCPI3_0)
; RV64D-NEXT:    fld fa0, 0(a0)
; RV64D-NEXT:    ret
  ret double -0.0
}
