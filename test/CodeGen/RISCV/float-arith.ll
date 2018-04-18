; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+f -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV32IF %s

define float @fadd_s(float %a, float %b) nounwind {
; RV32IF-LABEL: fadd_s:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.w.x ft0, a1
; RV32IF-NEXT:    fmv.w.x ft1, a0
; RV32IF-NEXT:    fadd.s ft0, ft1, ft0
; RV32IF-NEXT:    fmv.x.w a0, ft0
; RV32IF-NEXT:    ret
  %1 = fadd float %a, %b
  ret float %1
}

define float @fsub_s(float %a, float %b) nounwind {
; RV32IF-LABEL: fsub_s:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.w.x ft0, a1
; RV32IF-NEXT:    fmv.w.x ft1, a0
; RV32IF-NEXT:    fsub.s ft0, ft1, ft0
; RV32IF-NEXT:    fmv.x.w a0, ft0
; RV32IF-NEXT:    ret
  %1 = fsub float %a, %b
  ret float %1
}

define float @fmul_s(float %a, float %b) nounwind {
; RV32IF-LABEL: fmul_s:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.w.x ft0, a1
; RV32IF-NEXT:    fmv.w.x ft1, a0
; RV32IF-NEXT:    fmul.s ft0, ft1, ft0
; RV32IF-NEXT:    fmv.x.w a0, ft0
; RV32IF-NEXT:    ret
  %1 = fmul float %a, %b
  ret float %1
}

define float @fdiv_s(float %a, float %b) nounwind {
; RV32IF-LABEL: fdiv_s:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.w.x ft0, a1
; RV32IF-NEXT:    fmv.w.x ft1, a0
; RV32IF-NEXT:    fdiv.s ft0, ft1, ft0
; RV32IF-NEXT:    fmv.x.w a0, ft0
; RV32IF-NEXT:    ret
  %1 = fdiv float %a, %b
  ret float %1
}

declare float @llvm.sqrt.f32(float)

define float @fsqrt_s(float %a) nounwind {
; RV32IF-LABEL: fsqrt_s:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.w.x ft0, a0
; RV32IF-NEXT:    fsqrt.s ft0, ft0
; RV32IF-NEXT:    fmv.x.w a0, ft0
; RV32IF-NEXT:    ret
  %1 = call float @llvm.sqrt.f32(float %a)
  ret float %1
}

declare float @llvm.copysign.f32(float, float)

define float @fsgnj_s(float %a, float %b) nounwind {
; RV32IF-LABEL: fsgnj_s:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.w.x ft0, a1
; RV32IF-NEXT:    fmv.w.x ft1, a0
; RV32IF-NEXT:    fsgnj.s ft0, ft1, ft0
; RV32IF-NEXT:    fmv.x.w a0, ft0
; RV32IF-NEXT:    ret
  %1 = call float @llvm.copysign.f32(float %a, float %b)
  ret float %1
}

define float @fneg_s(float %a) nounwind {
; TODO: doesn't test the fneg selection pattern because
; DAGCombiner::visitBITCAST will generate a xor on the incoming integer
; argument
; RV32IF-LABEL: fneg_s:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    lui a1, 524288
; RV32IF-NEXT:    mv a1, a1
; RV32IF-NEXT:    xor a0, a0, a1
; RV32IF-NEXT:    ret
  %1 = fsub float -0.0, %a
  ret float %1
}

define float @fsgnjn_s(float %a, float %b) nounwind {
; TODO: fsgnjn.s isn't selected because DAGCombiner::visitBITCAST will convert
; (bitconvert (fneg x)) to a xor
; RV32IF-LABEL: fsgnjn_s:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    lui a2, 524288
; RV32IF-NEXT:    mv a2, a2
; RV32IF-NEXT:    xor a1, a1, a2
; RV32IF-NEXT:    fmv.w.x ft0, a1
; RV32IF-NEXT:    fmv.w.x ft1, a0
; RV32IF-NEXT:    fsgnj.s ft0, ft1, ft0
; RV32IF-NEXT:    fmv.x.w a0, ft0
; RV32IF-NEXT:    ret
  %1 = fsub float -0.0, %b
  %2 = call float @llvm.copysign.f32(float %a, float %1)
  ret float %2
}

declare float @llvm.fabs.f32(float)

define float @fabs_s(float %a) nounwind {
; TODO: doesn't test the fabs selection pattern because
; DAGCombiner::visitBITCAST will generate an and on the incoming integer
; argument
; RV32IF-LABEL: fabs_s:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    lui a1, 524288
; RV32IF-NEXT:    addi a1, a1, -1
; RV32IF-NEXT:    and a0, a0, a1
; RV32IF-NEXT:    ret
  %1 = call float @llvm.fabs.f32(float %a)
  ret float %1
}

declare float @llvm.minnum.f32(float, float)

define float @fmin_s(float %a, float %b) nounwind {
; RV32IF-LABEL: fmin_s:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.w.x ft0, a1
; RV32IF-NEXT:    fmv.w.x ft1, a0
; RV32IF-NEXT:    fmin.s ft0, ft1, ft0
; RV32IF-NEXT:    fmv.x.w a0, ft0
; RV32IF-NEXT:    ret
  %1 = call float @llvm.minnum.f32(float %a, float %b)
  ret float %1
}

declare float @llvm.maxnum.f32(float, float)

define float @fmax_s(float %a, float %b) nounwind {
; RV32IF-LABEL: fmax_s:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.w.x ft0, a1
; RV32IF-NEXT:    fmv.w.x ft1, a0
; RV32IF-NEXT:    fmax.s ft0, ft1, ft0
; RV32IF-NEXT:    fmv.x.w a0, ft0
; RV32IF-NEXT:    ret
  %1 = call float @llvm.maxnum.f32(float %a, float %b)
  ret float %1
}

define i32 @feq_s(float %a, float %b) nounwind {
; RV32IF-LABEL: feq_s:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.w.x ft0, a1
; RV32IF-NEXT:    fmv.w.x ft1, a0
; RV32IF-NEXT:    feq.s a0, ft1, ft0
; RV32IF-NEXT:    ret
  %1 = fcmp oeq float %a, %b
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define i32 @flt_s(float %a, float %b) nounwind {
; RV32IF-LABEL: flt_s:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.w.x ft0, a1
; RV32IF-NEXT:    fmv.w.x ft1, a0
; RV32IF-NEXT:    flt.s a0, ft1, ft0
; RV32IF-NEXT:    ret
  %1 = fcmp olt float %a, %b
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define i32 @fle_s(float %a, float %b) nounwind {
; RV32IF-LABEL: fle_s:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.w.x ft0, a1
; RV32IF-NEXT:    fmv.w.x ft1, a0
; RV32IF-NEXT:    fle.s a0, ft1, ft0
; RV32IF-NEXT:    ret
  %1 = fcmp ole float %a, %b
  %2 = zext i1 %1 to i32
  ret i32 %2
}
