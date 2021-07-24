; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv64 -mattr=+f -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV64IF

; This file exhaustively checks float<->i32 conversions. In general,
; fcvt.l[u].s can be selected instead of fcvt.w[u].s because poison is
; generated for an fpto[s|u]i conversion if the result doesn't fit in the
; target type.

define i32 @aext_fptosi(float %a) nounwind {
; RV64IF-LABEL: aext_fptosi:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fmv.w.x ft0, a0
; RV64IF-NEXT:    fcvt.w.s a0, ft0, rtz
; RV64IF-NEXT:    ret
  %1 = fptosi float %a to i32
  ret i32 %1
}

define signext i32 @sext_fptosi(float %a) nounwind {
; RV64IF-LABEL: sext_fptosi:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fmv.w.x ft0, a0
; RV64IF-NEXT:    fcvt.w.s a0, ft0, rtz
; RV64IF-NEXT:    ret
  %1 = fptosi float %a to i32
  ret i32 %1
}

define zeroext i32 @zext_fptosi(float %a) nounwind {
; RV64IF-LABEL: zext_fptosi:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fmv.w.x ft0, a0
; RV64IF-NEXT:    fcvt.w.s a0, ft0, rtz
; RV64IF-NEXT:    slli a0, a0, 32
; RV64IF-NEXT:    srli a0, a0, 32
; RV64IF-NEXT:    ret
  %1 = fptosi float %a to i32
  ret i32 %1
}

define i32 @aext_fptoui(float %a) nounwind {
; RV64IF-LABEL: aext_fptoui:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fmv.w.x ft0, a0
; RV64IF-NEXT:    fcvt.wu.s a0, ft0, rtz
; RV64IF-NEXT:    ret
  %1 = fptoui float %a to i32
  ret i32 %1
}

define signext i32 @sext_fptoui(float %a) nounwind {
; RV64IF-LABEL: sext_fptoui:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fmv.w.x ft0, a0
; RV64IF-NEXT:    fcvt.wu.s a0, ft0, rtz
; RV64IF-NEXT:    ret
  %1 = fptoui float %a to i32
  ret i32 %1
}

define zeroext i32 @zext_fptoui(float %a) nounwind {
; RV64IF-LABEL: zext_fptoui:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fmv.w.x ft0, a0
; RV64IF-NEXT:    fcvt.lu.s a0, ft0, rtz
; RV64IF-NEXT:    ret
  %1 = fptoui float %a to i32
  ret i32 %1
}

define i32 @bcvt_f32_to_aext_i32(float %a, float %b) nounwind {
; RV64IF-LABEL: bcvt_f32_to_aext_i32:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fmv.w.x ft0, a1
; RV64IF-NEXT:    fmv.w.x ft1, a0
; RV64IF-NEXT:    fadd.s ft0, ft1, ft0
; RV64IF-NEXT:    fmv.x.w a0, ft0
; RV64IF-NEXT:    ret
  %1 = fadd float %a, %b
  %2 = bitcast float %1 to i32
  ret i32 %2
}

define signext i32 @bcvt_f32_to_sext_i32(float %a, float %b) nounwind {
; RV64IF-LABEL: bcvt_f32_to_sext_i32:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fmv.w.x ft0, a1
; RV64IF-NEXT:    fmv.w.x ft1, a0
; RV64IF-NEXT:    fadd.s ft0, ft1, ft0
; RV64IF-NEXT:    fmv.x.w a0, ft0
; RV64IF-NEXT:    ret
  %1 = fadd float %a, %b
  %2 = bitcast float %1 to i32
  ret i32 %2
}

define zeroext i32 @bcvt_f32_to_zext_i32(float %a, float %b) nounwind {
; RV64IF-LABEL: bcvt_f32_to_zext_i32:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fmv.w.x ft0, a1
; RV64IF-NEXT:    fmv.w.x ft1, a0
; RV64IF-NEXT:    fadd.s ft0, ft1, ft0
; RV64IF-NEXT:    fmv.x.w a0, ft0
; RV64IF-NEXT:    slli a0, a0, 32
; RV64IF-NEXT:    srli a0, a0, 32
; RV64IF-NEXT:    ret
  %1 = fadd float %a, %b
  %2 = bitcast float %1 to i32
  ret i32 %2
}

define float @bcvt_i64_to_f32_via_i32(i64 %a, i64 %b) nounwind {
; RV64IF-LABEL: bcvt_i64_to_f32_via_i32:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fmv.w.x ft0, a0
; RV64IF-NEXT:    fmv.w.x ft1, a1
; RV64IF-NEXT:    fadd.s ft0, ft0, ft1
; RV64IF-NEXT:    fmv.x.w a0, ft0
; RV64IF-NEXT:    ret
  %1 = trunc i64 %a to i32
  %2 = trunc i64 %b to i32
  %3 = bitcast i32 %1 to float
  %4 = bitcast i32 %2 to float
  %5 = fadd float %3, %4
  ret float %5
}

define float @uitofp_aext_i32_to_f32(i32 %a) nounwind {
; RV64IF-LABEL: uitofp_aext_i32_to_f32:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fcvt.s.wu ft0, a0
; RV64IF-NEXT:    fmv.x.w a0, ft0
; RV64IF-NEXT:    ret
  %1 = uitofp i32 %a to float
  ret float %1
}

define float @uitofp_sext_i32_to_f32(i32 signext %a) nounwind {
; RV64IF-LABEL: uitofp_sext_i32_to_f32:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fcvt.s.wu ft0, a0
; RV64IF-NEXT:    fmv.x.w a0, ft0
; RV64IF-NEXT:    ret
  %1 = uitofp i32 %a to float
  ret float %1
}

define float @uitofp_zext_i32_to_f32(i32 zeroext %a) nounwind {
; RV64IF-LABEL: uitofp_zext_i32_to_f32:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fcvt.s.wu ft0, a0
; RV64IF-NEXT:    fmv.x.w a0, ft0
; RV64IF-NEXT:    ret
  %1 = uitofp i32 %a to float
  ret float %1
}

define float @sitofp_aext_i32_to_f32(i32 %a) nounwind {
; RV64IF-LABEL: sitofp_aext_i32_to_f32:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fcvt.s.w ft0, a0
; RV64IF-NEXT:    fmv.x.w a0, ft0
; RV64IF-NEXT:    ret
  %1 = sitofp i32 %a to float
  ret float %1
}

define float @sitofp_sext_i32_to_f32(i32 signext %a) nounwind {
; RV64IF-LABEL: sitofp_sext_i32_to_f32:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fcvt.s.w ft0, a0
; RV64IF-NEXT:    fmv.x.w a0, ft0
; RV64IF-NEXT:    ret
  %1 = sitofp i32 %a to float
  ret float %1
}

define float @sitofp_zext_i32_to_f32(i32 zeroext %a) nounwind {
; RV64IF-LABEL: sitofp_zext_i32_to_f32:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fcvt.s.w ft0, a0
; RV64IF-NEXT:    fmv.x.w a0, ft0
; RV64IF-NEXT:    ret
  %1 = sitofp i32 %a to float
  ret float %1
}
