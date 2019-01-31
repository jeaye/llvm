; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+f -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV32IF %s
; RUN: llc -mtriple=riscv64 -mattr=+f -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV64IF %s

define i32 @fcmp_false(float %a, float %b) nounwind {
; RV32IF-LABEL: fcmp_false:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    mv a0, zero
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fcmp_false:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    mv a0, zero
; RV64IF-NEXT:    ret
  %1 = fcmp false float %a, %b
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define i32 @fcmp_oeq(float %a, float %b) nounwind {
; RV32IF-LABEL: fcmp_oeq:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.w.x ft0, a1
; RV32IF-NEXT:    fmv.w.x ft1, a0
; RV32IF-NEXT:    feq.s a0, ft1, ft0
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fcmp_oeq:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fmv.w.x ft0, a1
; RV64IF-NEXT:    fmv.w.x ft1, a0
; RV64IF-NEXT:    feq.s a0, ft1, ft0
; RV64IF-NEXT:    ret
  %1 = fcmp oeq float %a, %b
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define i32 @fcmp_ogt(float %a, float %b) nounwind {
; RV32IF-LABEL: fcmp_ogt:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.w.x ft0, a0
; RV32IF-NEXT:    fmv.w.x ft1, a1
; RV32IF-NEXT:    flt.s a0, ft1, ft0
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fcmp_ogt:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fmv.w.x ft0, a0
; RV64IF-NEXT:    fmv.w.x ft1, a1
; RV64IF-NEXT:    flt.s a0, ft1, ft0
; RV64IF-NEXT:    ret
  %1 = fcmp ogt float %a, %b
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define i32 @fcmp_oge(float %a, float %b) nounwind {
; RV32IF-LABEL: fcmp_oge:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.w.x ft0, a0
; RV32IF-NEXT:    fmv.w.x ft1, a1
; RV32IF-NEXT:    fle.s a0, ft1, ft0
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fcmp_oge:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fmv.w.x ft0, a0
; RV64IF-NEXT:    fmv.w.x ft1, a1
; RV64IF-NEXT:    fle.s a0, ft1, ft0
; RV64IF-NEXT:    ret
  %1 = fcmp oge float %a, %b
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define i32 @fcmp_olt(float %a, float %b) nounwind {
; RV32IF-LABEL: fcmp_olt:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.w.x ft0, a1
; RV32IF-NEXT:    fmv.w.x ft1, a0
; RV32IF-NEXT:    flt.s a0, ft1, ft0
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fcmp_olt:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fmv.w.x ft0, a1
; RV64IF-NEXT:    fmv.w.x ft1, a0
; RV64IF-NEXT:    flt.s a0, ft1, ft0
; RV64IF-NEXT:    ret
  %1 = fcmp olt float %a, %b
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define i32 @fcmp_ole(float %a, float %b) nounwind {
; RV32IF-LABEL: fcmp_ole:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.w.x ft0, a1
; RV32IF-NEXT:    fmv.w.x ft1, a0
; RV32IF-NEXT:    fle.s a0, ft1, ft0
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fcmp_ole:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fmv.w.x ft0, a1
; RV64IF-NEXT:    fmv.w.x ft1, a0
; RV64IF-NEXT:    fle.s a0, ft1, ft0
; RV64IF-NEXT:    ret
  %1 = fcmp ole float %a, %b
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define i32 @fcmp_one(float %a, float %b) nounwind {
; RV32IF-LABEL: fcmp_one:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.w.x ft0, a0
; RV32IF-NEXT:    fmv.w.x ft1, a1
; RV32IF-NEXT:    feq.s a0, ft1, ft1
; RV32IF-NEXT:    feq.s a1, ft0, ft0
; RV32IF-NEXT:    and a0, a1, a0
; RV32IF-NEXT:    feq.s a1, ft0, ft1
; RV32IF-NEXT:    not a1, a1
; RV32IF-NEXT:    seqz a0, a0
; RV32IF-NEXT:    xori a0, a0, 1
; RV32IF-NEXT:    and a0, a1, a0
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fcmp_one:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fmv.w.x ft0, a0
; RV64IF-NEXT:    fmv.w.x ft1, a1
; RV64IF-NEXT:    feq.s a0, ft1, ft1
; RV64IF-NEXT:    feq.s a1, ft0, ft0
; RV64IF-NEXT:    and a0, a1, a0
; RV64IF-NEXT:    feq.s a1, ft0, ft1
; RV64IF-NEXT:    not a1, a1
; RV64IF-NEXT:    seqz a0, a0
; RV64IF-NEXT:    xori a0, a0, 1
; RV64IF-NEXT:    and a0, a1, a0
; RV64IF-NEXT:    ret
  %1 = fcmp one float %a, %b
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define i32 @fcmp_ord(float %a, float %b) nounwind {
; RV32IF-LABEL: fcmp_ord:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.w.x ft0, a1
; RV32IF-NEXT:    feq.s a1, ft0, ft0
; RV32IF-NEXT:    fmv.w.x ft0, a0
; RV32IF-NEXT:    feq.s a0, ft0, ft0
; RV32IF-NEXT:    and a0, a0, a1
; RV32IF-NEXT:    seqz a0, a0
; RV32IF-NEXT:    xori a0, a0, 1
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fcmp_ord:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fmv.w.x ft0, a1
; RV64IF-NEXT:    feq.s a1, ft0, ft0
; RV64IF-NEXT:    fmv.w.x ft0, a0
; RV64IF-NEXT:    feq.s a0, ft0, ft0
; RV64IF-NEXT:    and a0, a0, a1
; RV64IF-NEXT:    seqz a0, a0
; RV64IF-NEXT:    xori a0, a0, 1
; RV64IF-NEXT:    ret
  %1 = fcmp ord float %a, %b
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define i32 @fcmp_ueq(float %a, float %b) nounwind {
; RV32IF-LABEL: fcmp_ueq:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.w.x ft0, a1
; RV32IF-NEXT:    fmv.w.x ft1, a0
; RV32IF-NEXT:    feq.s a0, ft1, ft0
; RV32IF-NEXT:    feq.s a1, ft0, ft0
; RV32IF-NEXT:    feq.s a2, ft1, ft1
; RV32IF-NEXT:    and a1, a2, a1
; RV32IF-NEXT:    seqz a1, a1
; RV32IF-NEXT:    or a0, a0, a1
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fcmp_ueq:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fmv.w.x ft0, a1
; RV64IF-NEXT:    fmv.w.x ft1, a0
; RV64IF-NEXT:    feq.s a0, ft1, ft0
; RV64IF-NEXT:    feq.s a1, ft0, ft0
; RV64IF-NEXT:    feq.s a2, ft1, ft1
; RV64IF-NEXT:    and a1, a2, a1
; RV64IF-NEXT:    seqz a1, a1
; RV64IF-NEXT:    or a0, a0, a1
; RV64IF-NEXT:    ret
  %1 = fcmp ueq float %a, %b
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define i32 @fcmp_ugt(float %a, float %b) nounwind {
; RV32IF-LABEL: fcmp_ugt:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.w.x ft0, a1
; RV32IF-NEXT:    fmv.w.x ft1, a0
; RV32IF-NEXT:    fle.s a0, ft1, ft0
; RV32IF-NEXT:    xori a0, a0, 1
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fcmp_ugt:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fmv.w.x ft0, a1
; RV64IF-NEXT:    fmv.w.x ft1, a0
; RV64IF-NEXT:    fle.s a0, ft1, ft0
; RV64IF-NEXT:    xori a0, a0, 1
; RV64IF-NEXT:    ret
  %1 = fcmp ugt float %a, %b
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define i32 @fcmp_uge(float %a, float %b) nounwind {
; RV32IF-LABEL: fcmp_uge:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.w.x ft0, a1
; RV32IF-NEXT:    fmv.w.x ft1, a0
; RV32IF-NEXT:    flt.s a0, ft1, ft0
; RV32IF-NEXT:    xori a0, a0, 1
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fcmp_uge:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fmv.w.x ft0, a1
; RV64IF-NEXT:    fmv.w.x ft1, a0
; RV64IF-NEXT:    flt.s a0, ft1, ft0
; RV64IF-NEXT:    xori a0, a0, 1
; RV64IF-NEXT:    ret
  %1 = fcmp uge float %a, %b
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define i32 @fcmp_ult(float %a, float %b) nounwind {
; RV32IF-LABEL: fcmp_ult:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.w.x ft0, a0
; RV32IF-NEXT:    fmv.w.x ft1, a1
; RV32IF-NEXT:    fle.s a0, ft1, ft0
; RV32IF-NEXT:    xori a0, a0, 1
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fcmp_ult:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fmv.w.x ft0, a0
; RV64IF-NEXT:    fmv.w.x ft1, a1
; RV64IF-NEXT:    fle.s a0, ft1, ft0
; RV64IF-NEXT:    xori a0, a0, 1
; RV64IF-NEXT:    ret
  %1 = fcmp ult float %a, %b
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define i32 @fcmp_ule(float %a, float %b) nounwind {
; RV32IF-LABEL: fcmp_ule:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.w.x ft0, a0
; RV32IF-NEXT:    fmv.w.x ft1, a1
; RV32IF-NEXT:    flt.s a0, ft1, ft0
; RV32IF-NEXT:    xori a0, a0, 1
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fcmp_ule:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fmv.w.x ft0, a0
; RV64IF-NEXT:    fmv.w.x ft1, a1
; RV64IF-NEXT:    flt.s a0, ft1, ft0
; RV64IF-NEXT:    xori a0, a0, 1
; RV64IF-NEXT:    ret
  %1 = fcmp ule float %a, %b
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define i32 @fcmp_une(float %a, float %b) nounwind {
; RV32IF-LABEL: fcmp_une:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.w.x ft0, a1
; RV32IF-NEXT:    fmv.w.x ft1, a0
; RV32IF-NEXT:    feq.s a0, ft1, ft0
; RV32IF-NEXT:    xori a0, a0, 1
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fcmp_une:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fmv.w.x ft0, a1
; RV64IF-NEXT:    fmv.w.x ft1, a0
; RV64IF-NEXT:    feq.s a0, ft1, ft0
; RV64IF-NEXT:    xori a0, a0, 1
; RV64IF-NEXT:    ret
  %1 = fcmp une float %a, %b
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define i32 @fcmp_uno(float %a, float %b) nounwind {
; RV32IF-LABEL: fcmp_uno:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.w.x ft0, a1
; RV32IF-NEXT:    feq.s a1, ft0, ft0
; RV32IF-NEXT:    fmv.w.x ft0, a0
; RV32IF-NEXT:    feq.s a0, ft0, ft0
; RV32IF-NEXT:    and a0, a0, a1
; RV32IF-NEXT:    seqz a0, a0
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fcmp_uno:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fmv.w.x ft0, a1
; RV64IF-NEXT:    feq.s a1, ft0, ft0
; RV64IF-NEXT:    fmv.w.x ft0, a0
; RV64IF-NEXT:    feq.s a0, ft0, ft0
; RV64IF-NEXT:    and a0, a0, a1
; RV64IF-NEXT:    seqz a0, a0
; RV64IF-NEXT:    ret
  %1 = fcmp uno float %a, %b
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define i32 @fcmp_true(float %a, float %b) nounwind {
; RV32IF-LABEL: fcmp_true:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    addi a0, zero, 1
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fcmp_true:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    addi a0, zero, 1
; RV64IF-NEXT:    ret
  %1 = fcmp true float %a, %b
  %2 = zext i1 %1 to i32
  ret i32 %2
}
