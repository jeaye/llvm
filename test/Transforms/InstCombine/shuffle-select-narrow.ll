; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

; Narrow the select operands to eliminate the existing shuffles and replace a wide select with a narrow select.

define <2 x i8> @narrow_shuffle_of_select(<2 x i1> %cmp, <4 x i8> %x, <4 x i8> %y) {
; CHECK-LABEL: @narrow_shuffle_of_select(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <4 x i8> [[X:%.*]], <4 x i8> poison, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <4 x i8> [[Y:%.*]], <4 x i8> poison, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[R:%.*]] = select <2 x i1> [[CMP:%.*]], <2 x i8> [[TMP1]], <2 x i8> [[TMP2]]
; CHECK-NEXT:    ret <2 x i8> [[R]]
;
  %widecmp = shufflevector <2 x i1> %cmp, <2 x i1> undef, <4 x i32> <i32 0, i32 1, i32 undef, i32 undef>
  %widesel = select <4 x i1> %widecmp, <4 x i8> %x, <4 x i8> %y
  %r = shufflevector <4 x i8> %widesel, <4 x i8> undef, <2 x i32> <i32 0, i32 1>
  ret <2 x i8> %r
}

; The 1st shuffle is not extending with undefs, but demanded elements corrects that.

define <2 x i8> @narrow_shuffle_of_select_overspecified_extend(<2 x i1> %cmp, <4 x i8> %x, <4 x i8> %y) {
; CHECK-LABEL: @narrow_shuffle_of_select_overspecified_extend(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <4 x i8> [[X:%.*]], <4 x i8> poison, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <4 x i8> [[Y:%.*]], <4 x i8> poison, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[R:%.*]] = select <2 x i1> [[CMP:%.*]], <2 x i8> [[TMP1]], <2 x i8> [[TMP2]]
; CHECK-NEXT:    ret <2 x i8> [[R]]
;
  %widecmp = shufflevector <2 x i1> %cmp, <2 x i1> undef, <4 x i32> <i32 0, i32 1, i32 0, i32 1>
  %widesel = select <4 x i1> %widecmp, <4 x i8> %x, <4 x i8> %y
  %r = shufflevector <4 x i8> %widesel, <4 x i8> undef, <2 x i32> <i32 0, i32 1>
  ret <2 x i8> %r
}

; Verify that undef elements are acceptable for identity shuffle mask. Also check FP types.

define <3 x float> @narrow_shuffle_of_select_undefs(<3 x i1> %cmp, <4 x float> %x, <4 x float> %y) {
; CHECK-LABEL: @narrow_shuffle_of_select_undefs(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <4 x float> [[X:%.*]], <4 x float> poison, <3 x i32> <i32 0, i32 1, i32 undef>
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <4 x float> [[Y:%.*]], <4 x float> poison, <3 x i32> <i32 0, i32 1, i32 undef>
; CHECK-NEXT:    [[R:%.*]] = select <3 x i1> [[CMP:%.*]], <3 x float> [[TMP1]], <3 x float> [[TMP2]]
; CHECK-NEXT:    ret <3 x float> [[R]]
;
  %widecmp = shufflevector <3 x i1> %cmp, <3 x i1> undef, <4 x i32> <i32 undef, i32 1, i32 2, i32 undef>
  %widesel = select <4 x i1> %widecmp, <4 x float> %x, <4 x float> %y
  %r = shufflevector <4 x float> %widesel, <4 x float> undef, <3 x i32> <i32 0, i32 1, i32 undef>
  ret <3 x float> %r
}

declare void @use(<4 x i8>)
declare void @use_cmp(<4 x i1>)

; Negative test - extra use would require more instructions than we started with.

define <2 x i8> @narrow_shuffle_of_select_use1(<2 x i1> %cmp, <4 x i8> %x, <4 x i8> %y) {
; CHECK-LABEL: @narrow_shuffle_of_select_use1(
; CHECK-NEXT:    [[WIDECMP:%.*]] = shufflevector <2 x i1> [[CMP:%.*]], <2 x i1> undef, <4 x i32> <i32 0, i32 1, i32 undef, i32 undef>
; CHECK-NEXT:    [[WIDESEL:%.*]] = select <4 x i1> [[WIDECMP]], <4 x i8> [[X:%.*]], <4 x i8> [[Y:%.*]]
; CHECK-NEXT:    call void @use(<4 x i8> [[WIDESEL]])
; CHECK-NEXT:    [[R:%.*]] = shufflevector <4 x i8> [[WIDESEL]], <4 x i8> undef, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    ret <2 x i8> [[R]]
;
  %widecmp = shufflevector <2 x i1> %cmp, <2 x i1> undef, <4 x i32> <i32 0, i32 1, i32 undef, i32 undef>
  %widesel = select <4 x i1> %widecmp, <4 x i8> %x, <4 x i8> %y
  call void @use(<4 x i8> %widesel)
  %r = shufflevector <4 x i8> %widesel, <4 x i8> undef, <2 x i32> <i32 0, i32 1>
  ret <2 x i8> %r
}

; Negative test - extra use would require more instructions than we started with.

define <2 x i8> @narrow_shuffle_of_select_use2(<2 x i1> %cmp, <4 x i8> %x, <4 x i8> %y) {
; CHECK-LABEL: @narrow_shuffle_of_select_use2(
; CHECK-NEXT:    [[WIDECMP:%.*]] = shufflevector <2 x i1> [[CMP:%.*]], <2 x i1> undef, <4 x i32> <i32 0, i32 1, i32 undef, i32 undef>
; CHECK-NEXT:    call void @use_cmp(<4 x i1> [[WIDECMP]])
; CHECK-NEXT:    [[WIDESEL:%.*]] = select <4 x i1> [[WIDECMP]], <4 x i8> [[X:%.*]], <4 x i8> [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = shufflevector <4 x i8> [[WIDESEL]], <4 x i8> undef, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    ret <2 x i8> [[R]]
;
  %widecmp = shufflevector <2 x i1> %cmp, <2 x i1> undef, <4 x i32> <i32 0, i32 1, i32 undef, i32 undef>
  call void @use_cmp(<4 x i1> %widecmp)
  %widesel = select <4 x i1> %widecmp, <4 x i8> %x, <4 x i8> %y
  %r = shufflevector <4 x i8> %widesel, <4 x i8> undef, <2 x i32> <i32 0, i32 1>
  ret <2 x i8> %r
}

; Negative test - mismatched types would require extra shuffling.

define <3 x i8> @narrow_shuffle_of_select_mismatch_types1(<2 x i1> %cmp, <4 x i8> %x, <4 x i8> %y) {
; CHECK-LABEL: @narrow_shuffle_of_select_mismatch_types1(
; CHECK-NEXT:    [[WIDECMP:%.*]] = shufflevector <2 x i1> [[CMP:%.*]], <2 x i1> undef, <4 x i32> <i32 0, i32 1, i32 undef, i32 undef>
; CHECK-NEXT:    [[WIDESEL:%.*]] = select <4 x i1> [[WIDECMP]], <4 x i8> [[X:%.*]], <4 x i8> [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = shufflevector <4 x i8> [[WIDESEL]], <4 x i8> undef, <3 x i32> <i32 0, i32 1, i32 2>
; CHECK-NEXT:    ret <3 x i8> [[R]]
;
  %widecmp = shufflevector <2 x i1> %cmp, <2 x i1> undef, <4 x i32> <i32 0, i32 1, i32 undef, i32 undef>
  %widesel = select <4 x i1> %widecmp, <4 x i8> %x, <4 x i8> %y
  %r = shufflevector <4 x i8> %widesel, <4 x i8> undef, <3 x i32> <i32 0, i32 1, i32 2>
  ret <3 x i8> %r
}

; Negative test - mismatched types would require extra shuffling.

define <3 x i8> @narrow_shuffle_of_select_mismatch_types2(<4 x i1> %cmp, <6 x i8> %x, <6 x i8> %y) {
; CHECK-LABEL: @narrow_shuffle_of_select_mismatch_types2(
; CHECK-NEXT:    [[WIDECMP:%.*]] = shufflevector <4 x i1> [[CMP:%.*]], <4 x i1> undef, <6 x i32> <i32 0, i32 1, i32 2, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[WIDESEL:%.*]] = select <6 x i1> [[WIDECMP]], <6 x i8> [[X:%.*]], <6 x i8> [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = shufflevector <6 x i8> [[WIDESEL]], <6 x i8> undef, <3 x i32> <i32 0, i32 1, i32 2>
; CHECK-NEXT:    ret <3 x i8> [[R]]
;
  %widecmp = shufflevector <4 x i1> %cmp, <4 x i1> undef, <6 x i32> <i32 0, i32 1, i32 2, i32 3, i32 undef, i32 undef>
  %widesel = select <6 x i1> %widecmp, <6 x i8> %x, <6 x i8> %y
  %r = shufflevector <6 x i8> %widesel, <6 x i8> undef, <3 x i32> <i32 0, i32 1, i32 2>
  ret <3 x i8> %r
}

; Narrowing constants does not require creating new narrowing shuffle instructions.

define <2 x i8> @narrow_shuffle_of_select_consts(<2 x i1> %cmp) {
; CHECK-LABEL: @narrow_shuffle_of_select_consts(
; CHECK-NEXT:    [[R:%.*]] = select <2 x i1> [[CMP:%.*]], <2 x i8> <i8 -1, i8 -2>, <2 x i8> <i8 1, i8 2>
; CHECK-NEXT:    ret <2 x i8> [[R]]
;
  %widecmp = shufflevector <2 x i1> %cmp, <2 x i1> undef, <4 x i32> <i32 0, i32 1, i32 undef, i32 undef>
  %widesel = select <4 x i1> %widecmp, <4 x i8> <i8 -1, i8 -2, i8 -3, i8 -4>, <4 x i8> <i8 1, i8 2, i8 3, i8 4>
  %r = shufflevector <4 x i8> %widesel, <4 x i8> undef, <2 x i32> <i32 0, i32 1>
  ret <2 x i8> %r
}

; PR38691 - https://bugs.llvm.org/show_bug.cgi?id=38691
; If the operands are widened only to be narrowed back, then all of the shuffles are unnecessary.

define <2 x i8> @narrow_shuffle_of_select_with_widened_ops(<2 x i1> %cmp, <2 x i8> %x, <2 x i8> %y) {
; CHECK-LABEL: @narrow_shuffle_of_select_with_widened_ops(
; CHECK-NEXT:    [[R:%.*]] = select <2 x i1> [[CMP:%.*]], <2 x i8> [[X:%.*]], <2 x i8> [[Y:%.*]]
; CHECK-NEXT:    ret <2 x i8> [[R]]
;
  %widex = shufflevector <2 x i8> %x, <2 x i8> undef, <4 x i32> <i32 0, i32 1, i32 undef, i32 undef>
  %widey = shufflevector <2 x i8> %y, <2 x i8> undef, <4 x i32> <i32 0, i32 1, i32 undef, i32 undef>
  %widecmp = shufflevector <2 x i1> %cmp, <2 x i1> undef, <4 x i32> <i32 0, i32 1, i32 undef, i32 undef>
  %widesel = select <4 x i1> %widecmp, <4 x i8> %widex, <4 x i8> %widey
  %r = shufflevector <4 x i8> %widesel, <4 x i8> undef, <2 x i32> <i32 0, i32 1>
  ret <2 x i8> %r
}

