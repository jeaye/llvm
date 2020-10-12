; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -mtriple=i686-apple-macosx -instcombine %s | FileCheck %s

declare x86_fp80 @fabsl(x86_fp80)

define x86_fp80 @replace_fabs_call_f80(x86_fp80 %x) {
; CHECK-LABEL: @replace_fabs_call_f80(
; CHECK-NEXT:    [[FABSL:%.*]] = call x86_fp80 @llvm.fabs.f80(x86_fp80 [[X:%.*]])
; CHECK-NEXT:    ret x86_fp80 [[FABSL]]
;
  %fabsl = tail call x86_fp80 @fabsl(x86_fp80 %x)
  ret x86_fp80 %fabsl
}

define x86_fp80 @fmf_replace_fabs_call_f80(x86_fp80 %x) {
; CHECK-LABEL: @fmf_replace_fabs_call_f80(
; CHECK-NEXT:    [[FABSL:%.*]] = call nnan x86_fp80 @llvm.fabs.f80(x86_fp80 [[X:%.*]])
; CHECK-NEXT:    ret x86_fp80 [[FABSL]]
;
  %fabsl = tail call nnan x86_fp80 @fabsl(x86_fp80 %x)
  ret x86_fp80 %fabsl
}

