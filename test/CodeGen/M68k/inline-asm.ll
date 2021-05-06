; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=m68k < %s -o - | FileCheck %s

; This function is primarily testing constant constraints that can NOT
; be easily checked by Clang. For example, 'K' and 'M' are both
; constraints for values that are outside certain numerical range.
define void @constant_constraints() {
; CHECK-LABEL: constant_constraints:
; CHECK:         .cfi_startproc
; CHECK-NEXT:  ; %bb.0: ; %entry
; CHECK-NEXT:    ;APP
; CHECK-NEXT:    move.l #1, %d1
; CHECK-NEXT:    ;NO_APP
; CHECK-NEXT:    ;APP
; CHECK-NEXT:    move.l #8, %d1
; CHECK-NEXT:    ;NO_APP
; CHECK-NEXT:    ;APP
; CHECK-NEXT:    move.l #-32768, %d1
; CHECK-NEXT:    ;NO_APP
; CHECK-NEXT:    ;APP
; CHECK-NEXT:    move.l #32767, %d1
; CHECK-NEXT:    ;NO_APP
; CHECK-NEXT:    ;APP
; CHECK-NEXT:    move.l #-129, %d1
; CHECK-NEXT:    ;NO_APP
; CHECK-NEXT:    ;APP
; CHECK-NEXT:    move.l #128, %d1
; CHECK-NEXT:    ;NO_APP
; CHECK-NEXT:    ;APP
; CHECK-NEXT:    move.l #-8, %d1
; CHECK-NEXT:    ;NO_APP
; CHECK-NEXT:    ;APP
; CHECK-NEXT:    move.l #-1, %d1
; CHECK-NEXT:    ;NO_APP
; CHECK-NEXT:    ;APP
; CHECK-NEXT:    move.l #-257, %d1
; CHECK-NEXT:    ;NO_APP
; CHECK-NEXT:    ;APP
; CHECK-NEXT:    move.l #256, %d1
; CHECK-NEXT:    ;NO_APP
; CHECK-NEXT:    ;APP
; CHECK-NEXT:    move.l #24, %d1
; CHECK-NEXT:    ;NO_APP
; CHECK-NEXT:    ;APP
; CHECK-NEXT:    move.l #31, %d1
; CHECK-NEXT:    ;NO_APP
; CHECK-NEXT:    ;APP
; CHECK-NEXT:    move.l #16, %d1
; CHECK-NEXT:    ;NO_APP
; CHECK-NEXT:    ;APP
; CHECK-NEXT:    move.l #8, %d1
; CHECK-NEXT:    ;NO_APP
; CHECK-NEXT:    ;APP
; CHECK-NEXT:    move.l #15, %d1
; CHECK-NEXT:    ;NO_APP
; CHECK-NEXT:    ;APP
; CHECK-NEXT:    move.l #0, %d1
; CHECK-NEXT:    ;NO_APP
; CHECK-NEXT:    ;APP
; CHECK-NEXT:    move.l #1, %d1
; CHECK-NEXT:    ;NO_APP
; CHECK-NEXT:    ;APP
; CHECK-NEXT:    move.l #-32769, %d1
; CHECK-NEXT:    ;NO_APP
; CHECK-NEXT:    ;APP
; CHECK-NEXT:    move.l #32768, %d1
; CHECK-NEXT:    ;NO_APP
; CHECK-NEXT:    rts
entry:
  call void asm sideeffect "move.l $0, %d1", "I"(i32 1)
  call void asm sideeffect "move.l $0, %d1", "I"(i32 8)
  call void asm sideeffect "move.l $0, %d1", "J"(i32 -32768)
  call void asm sideeffect "move.l $0, %d1", "J"(i32 32767)
  call void asm sideeffect "move.l $0, %d1", "K"(i32 -129)
  call void asm sideeffect "move.l $0, %d1", "K"(i32 128)
  call void asm sideeffect "move.l $0, %d1", "L"(i32 -8)
  call void asm sideeffect "move.l $0, %d1", "L"(i32 -1)
  call void asm sideeffect "move.l $0, %d1", "M"(i32 -257)
  call void asm sideeffect "move.l $0, %d1", "M"(i32 256)
  call void asm sideeffect "move.l $0, %d1", "N"(i32 24)
  call void asm sideeffect "move.l $0, %d1", "N"(i32 31)
  call void asm sideeffect "move.l $0, %d1", "O"(i32 16)
  call void asm sideeffect "move.l $0, %d1", "P"(i32 8)
  call void asm sideeffect "move.l $0, %d1", "P"(i32 15)
  call void asm sideeffect "move.l $0, %d1", "^C0"(i32 0)
  call void asm sideeffect "move.l $0, %d1", "^Ci"(i32 1)
  call void asm sideeffect "move.l $0, %d1", "^Cj"(i32 -32769)
  call void asm sideeffect "move.l $0, %d1", "^Cj"(i32 32768)
  ret void
}

define void @register_constraints() {
; CHECK-LABEL: register_constraints:
; CHECK:         .cfi_startproc
; CHECK-NEXT:  ; %bb.0: ; %entry
; CHECK-NEXT:    sub.l #4, %sp
; CHECK-NEXT:    .cfi_def_cfa_offset -8
; CHECK-NEXT:    ;APP
; CHECK-NEXT:    move.l #94, %d0
; CHECK-NEXT:    ;NO_APP
; CHECK-NEXT:    move.l %d0, (0,%sp)
; CHECK-NEXT:    ;APP
; CHECK-NEXT:    move.l #87, %d0
; CHECK-NEXT:    ;NO_APP
; CHECK-NEXT:    move.l %d0, (0,%sp)
; CHECK-NEXT:    ;APP
; CHECK-NEXT:    move.l #66, %a0
; CHECK-NEXT:    ;NO_APP
; CHECK-NEXT:    move.l %a0, (0,%sp)
; CHECK-NEXT:    add.l #4, %sp
; CHECK-NEXT:    rts
entry:
  %out = alloca i32, align 4
  %0 = call i32 asm sideeffect "move.l #94, $0", "=r"()
  store i32 %0, i32* %out, align 4
  %1 = call i32 asm sideeffect "move.l #87, $0", "=d"()
  store i32 %1, i32* %out, align 4
  %2 = call i32 asm sideeffect "move.l #66, $0", "=a"()
  store i32 %2, i32* %out, align 4
  ret void
}

