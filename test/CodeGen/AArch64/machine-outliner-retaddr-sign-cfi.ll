; RUN: llc -verify-machineinstrs -enable-machine-outliner -mtriple \
; RUN: aarch64-arm-none-eabi %s -o - | FileCheck %s

; Function a's outlining candidate contains a sp modifying add without a
; corresponsing sub, so we shouldn't outline it.
define void @a() "sign-return-address"="all" "sign-return-address-key"="b_key" {
; CHECK-LABEL:      a:                                     // @a
; CHECK:            // %bb.0:
; CHECK-NEXT:           .cfi_b_key_frame
; CHECK-NEXT:           pacibsp
; CHECK-NEXT:           .cfi_negate_ra_state
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i32 1, i32* %1, align 4
  store i32 2, i32* %2, align 4
  store i32 3, i32* %3, align 4
  store i32 4, i32* %4, align 4
  store i32 5, i32* %5, align 4
  store i32 6, i32* %6, align 4
; CHECK-NOT:          bl OUTLINED_FUNCTION_{{[0-9]+}}
; CHECK:              autibsp
; CECK-NEXT:          ret
  ret void
}

define void @b() "sign-return-address"="all" "sign-return-address-key"="b_key" nounwind {
; CHECK-LABEL:      b:                                     // @b
; CHECK-NEXT:       // %bb.0:
; CHECK-NEXT:           pacibsp
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i32 1, i32* %1, align 4
  store i32 2, i32* %2, align 4
  store i32 3, i32* %3, align 4
  store i32 4, i32* %4, align 4
  store i32 5, i32* %5, align 4
  store i32 6, i32* %6, align 4
; CHECK:                bl [[OUTLINED_FUNC:OUTLINED_FUNCTION_[0-9]+]]
; CHECK:                autibsp
; CHECK-NEXT:           ret
  ret void
}

define void @c() "sign-return-address"="all" "sign-return-address-key"="b_key" nounwind {
; CHECK-LABEL:      c:                                     // @c
; CHECK-NEXT:       // %bb.0:
; CHECK-NEXT:           pacibsp
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i32 1, i32* %1, align 4
  store i32 2, i32* %2, align 4
  store i32 3, i32* %3, align 4
  store i32 4, i32* %4, align 4
  store i32 5, i32* %5, align 4
  store i32 6, i32* %6, align 4
; CHECK:                bl [[OUTLINED_FUNC]]
; CHECK:                autibsp
; CHECK-NEXT:           ret
  ret void
}

; CHECK:            [[OUTLINED_FUNC]]
; CHECK:            // %bb.0:
; CHECK-NEXT:           .cfi_b_key_frame
; CHECK-NEXT:           pacibsp
; CHECK-NEXT:           .cfi_negate_ra_state
; CHECK:                autibsp
; CHECK-NEXT:           ret
