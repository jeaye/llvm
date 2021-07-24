; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv64 -mattr=+d -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV64ID

; This file exhaustively checks double<->i32 conversions. In general,
; fcvt.l[u].d can be selected instead of fcvt.w[u].d because poison is
; generated for an fpto[s|u]i conversion if the result doesn't fit in the
; target type.

define i32 @aext_fptosi(double %a) nounwind {
; RV64ID-LABEL: aext_fptosi:
; RV64ID:       # %bb.0:
; RV64ID-NEXT:    fmv.d.x ft0, a0
; RV64ID-NEXT:    fcvt.w.d a0, ft0, rtz
; RV64ID-NEXT:    ret
  %1 = fptosi double %a to i32
  ret i32 %1
}

define signext i32 @sext_fptosi(double %a) nounwind {
; RV64ID-LABEL: sext_fptosi:
; RV64ID:       # %bb.0:
; RV64ID-NEXT:    fmv.d.x ft0, a0
; RV64ID-NEXT:    fcvt.w.d a0, ft0, rtz
; RV64ID-NEXT:    ret
  %1 = fptosi double %a to i32
  ret i32 %1
}

define zeroext i32 @zext_fptosi(double %a) nounwind {
; RV64ID-LABEL: zext_fptosi:
; RV64ID:       # %bb.0:
; RV64ID-NEXT:    fmv.d.x ft0, a0
; RV64ID-NEXT:    fcvt.w.d a0, ft0, rtz
; RV64ID-NEXT:    slli a0, a0, 32
; RV64ID-NEXT:    srli a0, a0, 32
; RV64ID-NEXT:    ret
  %1 = fptosi double %a to i32
  ret i32 %1
}

define i32 @aext_fptoui(double %a) nounwind {
; RV64ID-LABEL: aext_fptoui:
; RV64ID:       # %bb.0:
; RV64ID-NEXT:    fmv.d.x ft0, a0
; RV64ID-NEXT:    fcvt.wu.d a0, ft0, rtz
; RV64ID-NEXT:    ret
  %1 = fptoui double %a to i32
  ret i32 %1
}

define signext i32 @sext_fptoui(double %a) nounwind {
; RV64ID-LABEL: sext_fptoui:
; RV64ID:       # %bb.0:
; RV64ID-NEXT:    fmv.d.x ft0, a0
; RV64ID-NEXT:    fcvt.wu.d a0, ft0, rtz
; RV64ID-NEXT:    ret
  %1 = fptoui double %a to i32
  ret i32 %1
}

define zeroext i32 @zext_fptoui(double %a) nounwind {
; RV64ID-LABEL: zext_fptoui:
; RV64ID:       # %bb.0:
; RV64ID-NEXT:    fmv.d.x ft0, a0
; RV64ID-NEXT:    fcvt.lu.d a0, ft0, rtz
; RV64ID-NEXT:    ret
  %1 = fptoui double %a to i32
  ret i32 %1
}

define double @uitofp_aext_i32_to_f64(i32 %a) nounwind {
; RV64ID-LABEL: uitofp_aext_i32_to_f64:
; RV64ID:       # %bb.0:
; RV64ID-NEXT:    fcvt.d.wu ft0, a0
; RV64ID-NEXT:    fmv.x.d a0, ft0
; RV64ID-NEXT:    ret
  %1 = uitofp i32 %a to double
  ret double %1
}

define double @uitofp_sext_i32_to_f64(i32 signext %a) nounwind {
; RV64ID-LABEL: uitofp_sext_i32_to_f64:
; RV64ID:       # %bb.0:
; RV64ID-NEXT:    fcvt.d.wu ft0, a0
; RV64ID-NEXT:    fmv.x.d a0, ft0
; RV64ID-NEXT:    ret
  %1 = uitofp i32 %a to double
  ret double %1
}

define double @uitofp_zext_i32_to_f64(i32 zeroext %a) nounwind {
; RV64ID-LABEL: uitofp_zext_i32_to_f64:
; RV64ID:       # %bb.0:
; RV64ID-NEXT:    fcvt.d.wu ft0, a0
; RV64ID-NEXT:    fmv.x.d a0, ft0
; RV64ID-NEXT:    ret
  %1 = uitofp i32 %a to double
  ret double %1
}

define double @sitofp_aext_i32_to_f64(i32 %a) nounwind {
; RV64ID-LABEL: sitofp_aext_i32_to_f64:
; RV64ID:       # %bb.0:
; RV64ID-NEXT:    fcvt.d.w ft0, a0
; RV64ID-NEXT:    fmv.x.d a0, ft0
; RV64ID-NEXT:    ret
  %1 = sitofp i32 %a to double
  ret double %1
}

define double @sitofp_sext_i32_to_f64(i32 signext %a) nounwind {
; RV64ID-LABEL: sitofp_sext_i32_to_f64:
; RV64ID:       # %bb.0:
; RV64ID-NEXT:    fcvt.d.w ft0, a0
; RV64ID-NEXT:    fmv.x.d a0, ft0
; RV64ID-NEXT:    ret
  %1 = sitofp i32 %a to double
  ret double %1
}

define double @sitofp_zext_i32_to_f64(i32 zeroext %a) nounwind {
; RV64ID-LABEL: sitofp_zext_i32_to_f64:
; RV64ID:       # %bb.0:
; RV64ID-NEXT:    fcvt.d.w ft0, a0
; RV64ID-NEXT:    fmv.x.d a0, ft0
; RV64ID-NEXT:    ret
  %1 = sitofp i32 %a to double
  ret double %1
}
