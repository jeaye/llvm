; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -instcombine -S < %s | FileCheck %s

define float @matching_scalar(<4 x float>* dereferenceable(16) %p) {
; CHECK-LABEL: @matching_scalar(
; CHECK-NEXT:    [[BC:%.*]] = getelementptr inbounds <4 x float>, <4 x float>* [[P:%.*]], i64 0, i64 0
; CHECK-NEXT:    [[R:%.*]] = load float, float* [[BC]], align 16
; CHECK-NEXT:    ret float [[R]]
;
  %bc = bitcast <4 x float>* %p to float*
  %r = load float, float* %bc, align 16
  ret float %r
}

define i32 @nonmatching_scalar(<4 x float>* dereferenceable(16) %p) {
; CHECK-LABEL: @nonmatching_scalar(
; CHECK-NEXT:    [[BC:%.*]] = bitcast <4 x float>* [[P:%.*]] to i32*
; CHECK-NEXT:    [[R:%.*]] = load i32, i32* [[BC]], align 16
; CHECK-NEXT:    ret i32 [[R]]
;
  %bc = bitcast <4 x float>* %p to i32*
  %r = load i32, i32* %bc, align 16
  ret i32 %r
}

define i64 @larger_scalar(<4 x float>* dereferenceable(16) %p) {
; CHECK-LABEL: @larger_scalar(
; CHECK-NEXT:    [[BC:%.*]] = bitcast <4 x float>* [[P:%.*]] to i64*
; CHECK-NEXT:    [[R:%.*]] = load i64, i64* [[BC]], align 16
; CHECK-NEXT:    ret i64 [[R]]
;
  %bc = bitcast <4 x float>* %p to i64*
  %r = load i64, i64* %bc, align 16
  ret i64 %r
}

define i8 @smaller_scalar(<4 x float>* dereferenceable(16) %p) {
; CHECK-LABEL: @smaller_scalar(
; CHECK-NEXT:    [[BC:%.*]] = bitcast <4 x float>* [[P:%.*]] to i8*
; CHECK-NEXT:    [[R:%.*]] = load i8, i8* [[BC]], align 16
; CHECK-NEXT:    ret i8 [[R]]
;
  %bc = bitcast <4 x float>* %p to i8*
  %r = load i8, i8* %bc, align 16
  ret i8 %r
}

define i8 @smaller_scalar_less_aligned(<4 x float>* dereferenceable(16) %p) {
; CHECK-LABEL: @smaller_scalar_less_aligned(
; CHECK-NEXT:    [[BC:%.*]] = bitcast <4 x float>* [[P:%.*]] to i8*
; CHECK-NEXT:    [[R:%.*]] = load i8, i8* [[BC]], align 4
; CHECK-NEXT:    ret i8 [[R]]
;
  %bc = bitcast <4 x float>* %p to i8*
  %r = load i8, i8* %bc, align 4
  ret i8 %r
}

define float @matching_scalar_small_deref(<4 x float>* dereferenceable(15) %p) {
; CHECK-LABEL: @matching_scalar_small_deref(
; CHECK-NEXT:    [[BC:%.*]] = getelementptr inbounds <4 x float>, <4 x float>* [[P:%.*]], i64 0, i64 0
; CHECK-NEXT:    [[R:%.*]] = load float, float* [[BC]], align 16
; CHECK-NEXT:    ret float [[R]]
;
  %bc = bitcast <4 x float>* %p to float*
  %r = load float, float* %bc, align 16
  ret float %r
}

define float @matching_scalar_smallest_deref(<4 x float>* dereferenceable(1) %p) {
; CHECK-LABEL: @matching_scalar_smallest_deref(
; CHECK-NEXT:    [[BC:%.*]] = getelementptr inbounds <4 x float>, <4 x float>* [[P:%.*]], i64 0, i64 0
; CHECK-NEXT:    [[R:%.*]] = load float, float* [[BC]], align 16
; CHECK-NEXT:    ret float [[R]]
;
  %bc = bitcast <4 x float>* %p to float*
  %r = load float, float* %bc, align 16
  ret float %r
}

define float @matching_scalar_smallest_deref_or_null(<4 x float>* dereferenceable_or_null(1) %p) {
; CHECK-LABEL: @matching_scalar_smallest_deref_or_null(
; CHECK-NEXT:    [[BC:%.*]] = getelementptr inbounds <4 x float>, <4 x float>* [[P:%.*]], i64 0, i64 0
; CHECK-NEXT:    [[R:%.*]] = load float, float* [[BC]], align 16
; CHECK-NEXT:    ret float [[R]]
;
  %bc = bitcast <4 x float>* %p to float*
  %r = load float, float* %bc, align 16
  ret float %r
}

; TODO: Is a null pointer inbounds in any address space?

define float @matching_scalar_smallest_deref_or_null_addrspace(<4 x float> addrspace(4)* dereferenceable_or_null(1) %p) {
; CHECK-LABEL: @matching_scalar_smallest_deref_or_null_addrspace(
; CHECK-NEXT:    [[BC:%.*]] = getelementptr inbounds <4 x float>, <4 x float> addrspace(4)* [[P:%.*]], i64 0, i64 0
; CHECK-NEXT:    [[R:%.*]] = load float, float addrspace(4)* [[BC]], align 16
; CHECK-NEXT:    ret float [[R]]
;
  %bc = bitcast <4 x float> addrspace(4)* %p to float addrspace(4)*
  %r = load float, float addrspace(4)* %bc, align 16
  ret float %r
}

define float @matching_scalar_volatile(<4 x float>* dereferenceable(16) %p) {
; CHECK-LABEL: @matching_scalar_volatile(
; CHECK-NEXT:    [[BC:%.*]] = getelementptr inbounds <4 x float>, <4 x float>* [[P:%.*]], i64 0, i64 0
; CHECK-NEXT:    [[R:%.*]] = load volatile float, float* [[BC]], align 16
; CHECK-NEXT:    ret float [[R]]
;
  %bc = bitcast <4 x float>* %p to float*
  %r = load volatile float, float* %bc, align 16
  ret float %r
}

define float @nonvector(double* dereferenceable(16) %p) {
; CHECK-LABEL: @nonvector(
; CHECK-NEXT:    [[BC:%.*]] = bitcast double* [[P:%.*]] to float*
; CHECK-NEXT:    [[R:%.*]] = load float, float* [[BC]], align 16
; CHECK-NEXT:    ret float [[R]]
;
  %bc = bitcast double* %p to float*
  %r = load float, float* %bc, align 16
  ret float %r
}
