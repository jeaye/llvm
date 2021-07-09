; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv64 -mattr=+m -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV64I
; RUN: llc -mtriple=riscv64 -mattr=+m,+experimental-b -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV64IB
; RUN: llc -mtriple=riscv64 -mattr=+m,+experimental-zba -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV64IBA

define i64 @slliuw(i64 %a) nounwind {
; RV64I-LABEL: slliuw:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 32
; RV64I-NEXT:    srli a0, a0, 31
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: slliuw:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    slli.uw a0, a0, 1
; RV64IB-NEXT:    ret
;
; RV64IBA-LABEL: slliuw:
; RV64IBA:       # %bb.0:
; RV64IBA-NEXT:    slli.uw a0, a0, 1
; RV64IBA-NEXT:    ret
  %conv1 = shl i64 %a, 1
  %shl = and i64 %conv1, 8589934590
  ret i64 %shl
}

define i128 @slliuw_2(i32 signext %0, i128* %1) {
; RV64I-LABEL: slliuw_2:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 32
; RV64I-NEXT:    srli a0, a0, 28
; RV64I-NEXT:    add a1, a1, a0
; RV64I-NEXT:    ld a0, 0(a1)
; RV64I-NEXT:    ld a1, 8(a1)
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: slliuw_2:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    slli.uw a0, a0, 4
; RV64IB-NEXT:    add a1, a1, a0
; RV64IB-NEXT:    ld a0, 0(a1)
; RV64IB-NEXT:    ld a1, 8(a1)
; RV64IB-NEXT:    ret
;
; RV64IBA-LABEL: slliuw_2:
; RV64IBA:       # %bb.0:
; RV64IBA-NEXT:    slli.uw a0, a0, 4
; RV64IBA-NEXT:    add a1, a1, a0
; RV64IBA-NEXT:    ld a0, 0(a1)
; RV64IBA-NEXT:    ld a1, 8(a1)
; RV64IBA-NEXT:    ret
  %3 = zext i32 %0 to i64
  %4 = getelementptr inbounds i128, i128* %1, i64 %3
  %5 = load i128, i128* %4
  ret i128 %5
}

define i64 @adduw(i64 %a, i64 %b) nounwind {
; RV64I-LABEL: adduw:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a1, a1, 32
; RV64I-NEXT:    srli a1, a1, 32
; RV64I-NEXT:    add a0, a1, a0
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: adduw:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    add.uw a0, a1, a0
; RV64IB-NEXT:    ret
;
; RV64IBA-LABEL: adduw:
; RV64IBA:       # %bb.0:
; RV64IBA-NEXT:    add.uw a0, a1, a0
; RV64IBA-NEXT:    ret
  %and = and i64 %b, 4294967295
  %add = add i64 %and, %a
  ret i64 %add
}

define signext i8 @adduw_2(i32 signext %0, i8* %1) {
; RV64I-LABEL: adduw_2:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 32
; RV64I-NEXT:    srli a0, a0, 32
; RV64I-NEXT:    add a0, a1, a0
; RV64I-NEXT:    lb a0, 0(a0)
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: adduw_2:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    add.uw a0, a0, a1
; RV64IB-NEXT:    lb a0, 0(a0)
; RV64IB-NEXT:    ret
;
; RV64IBA-LABEL: adduw_2:
; RV64IBA:       # %bb.0:
; RV64IBA-NEXT:    add.uw a0, a0, a1
; RV64IBA-NEXT:    lb a0, 0(a0)
; RV64IBA-NEXT:    ret
  %3 = zext i32 %0 to i64
  %4 = getelementptr inbounds i8, i8* %1, i64 %3
  %5 = load i8, i8* %4
  ret i8 %5
}

define i64 @zextw_i64(i64 %a) nounwind {
; RV64I-LABEL: zextw_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 32
; RV64I-NEXT:    srli a0, a0, 32
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: zextw_i64:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    zext.w a0, a0
; RV64IB-NEXT:    ret
;
; RV64IBA-LABEL: zextw_i64:
; RV64IBA:       # %bb.0:
; RV64IBA-NEXT:    zext.w a0, a0
; RV64IBA-NEXT:    ret
  %and = and i64 %a, 4294967295
  ret i64 %and
}

; This makes sure targetShrinkDemandedConstant changes the and immmediate to
; allow zext.w or slli+srli.
define i64 @zextw_demandedbits_i64(i64 %0) {
; RV64I-LABEL: zextw_demandedbits_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    ori a0, a0, 1
; RV64I-NEXT:    slli a0, a0, 32
; RV64I-NEXT:    srli a0, a0, 32
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: zextw_demandedbits_i64:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    ori a0, a0, 1
; RV64IB-NEXT:    zext.w a0, a0
; RV64IB-NEXT:    ret
;
; RV64IBA-LABEL: zextw_demandedbits_i64:
; RV64IBA:       # %bb.0:
; RV64IBA-NEXT:    ori a0, a0, 1
; RV64IBA-NEXT:    zext.w a0, a0
; RV64IBA-NEXT:    ret
  %2 = and i64 %0, 4294967294
  %3 = or i64 %2, 1
  ret i64 %3
}

define signext i16 @sh1add(i64 %0, i16* %1) {
; RV64I-LABEL: sh1add:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 1
; RV64I-NEXT:    add a0, a1, a0
; RV64I-NEXT:    lh a0, 0(a0)
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sh1add:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    sh1add a0, a0, a1
; RV64IB-NEXT:    lh a0, 0(a0)
; RV64IB-NEXT:    ret
;
; RV64IBA-LABEL: sh1add:
; RV64IBA:       # %bb.0:
; RV64IBA-NEXT:    sh1add a0, a0, a1
; RV64IBA-NEXT:    lh a0, 0(a0)
; RV64IBA-NEXT:    ret
  %3 = getelementptr inbounds i16, i16* %1, i64 %0
  %4 = load i16, i16* %3
  ret i16 %4
}

define signext i32 @sh2add(i64 %0, i32* %1) {
; RV64I-LABEL: sh2add:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 2
; RV64I-NEXT:    add a0, a1, a0
; RV64I-NEXT:    lw a0, 0(a0)
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sh2add:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    sh2add a0, a0, a1
; RV64IB-NEXT:    lw a0, 0(a0)
; RV64IB-NEXT:    ret
;
; RV64IBA-LABEL: sh2add:
; RV64IBA:       # %bb.0:
; RV64IBA-NEXT:    sh2add a0, a0, a1
; RV64IBA-NEXT:    lw a0, 0(a0)
; RV64IBA-NEXT:    ret
  %3 = getelementptr inbounds i32, i32* %1, i64 %0
  %4 = load i32, i32* %3
  ret i32 %4
}

define i64 @sh3add(i64 %0, i64* %1) {
; RV64I-LABEL: sh3add:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 3
; RV64I-NEXT:    add a0, a1, a0
; RV64I-NEXT:    ld a0, 0(a0)
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sh3add:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    sh3add a0, a0, a1
; RV64IB-NEXT:    ld a0, 0(a0)
; RV64IB-NEXT:    ret
;
; RV64IBA-LABEL: sh3add:
; RV64IBA:       # %bb.0:
; RV64IBA-NEXT:    sh3add a0, a0, a1
; RV64IBA-NEXT:    ld a0, 0(a0)
; RV64IBA-NEXT:    ret
  %3 = getelementptr inbounds i64, i64* %1, i64 %0
  %4 = load i64, i64* %3
  ret i64 %4
}

define signext i16 @sh1adduw(i32 signext %0, i16* %1) {
; RV64I-LABEL: sh1adduw:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 32
; RV64I-NEXT:    srli a0, a0, 31
; RV64I-NEXT:    add a0, a1, a0
; RV64I-NEXT:    lh a0, 0(a0)
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sh1adduw:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    sh1add.uw a0, a0, a1
; RV64IB-NEXT:    lh a0, 0(a0)
; RV64IB-NEXT:    ret
;
; RV64IBA-LABEL: sh1adduw:
; RV64IBA:       # %bb.0:
; RV64IBA-NEXT:    sh1add.uw a0, a0, a1
; RV64IBA-NEXT:    lh a0, 0(a0)
; RV64IBA-NEXT:    ret
  %3 = zext i32 %0 to i64
  %4 = getelementptr inbounds i16, i16* %1, i64 %3
  %5 = load i16, i16* %4
  ret i16 %5
}

define i64 @sh1adduw_2(i64 %0, i64 %1) {
; RV64I-LABEL: sh1adduw_2:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 32
; RV64I-NEXT:    srli a0, a0, 31
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sh1adduw_2:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    sh1add.uw a0, a0, a1
; RV64IB-NEXT:    ret
;
; RV64IBA-LABEL: sh1adduw_2:
; RV64IBA:       # %bb.0:
; RV64IBA-NEXT:    sh1add.uw a0, a0, a1
; RV64IBA-NEXT:    ret
  %3 = shl i64 %0, 1
  %4 = and i64 %3, 8589934590
  %5 = add i64 %4, %1
  ret i64 %5
}

define signext i32 @sh2adduw(i32 signext %0, i32* %1) {
; RV64I-LABEL: sh2adduw:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 32
; RV64I-NEXT:    srli a0, a0, 30
; RV64I-NEXT:    add a0, a1, a0
; RV64I-NEXT:    lw a0, 0(a0)
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sh2adduw:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    sh2add.uw a0, a0, a1
; RV64IB-NEXT:    lw a0, 0(a0)
; RV64IB-NEXT:    ret
;
; RV64IBA-LABEL: sh2adduw:
; RV64IBA:       # %bb.0:
; RV64IBA-NEXT:    sh2add.uw a0, a0, a1
; RV64IBA-NEXT:    lw a0, 0(a0)
; RV64IBA-NEXT:    ret
  %3 = zext i32 %0 to i64
  %4 = getelementptr inbounds i32, i32* %1, i64 %3
  %5 = load i32, i32* %4
  ret i32 %5
}

define i64 @sh2adduw_2(i64 %0, i64 %1) {
; RV64I-LABEL: sh2adduw_2:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 32
; RV64I-NEXT:    srli a0, a0, 30
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sh2adduw_2:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    sh2add.uw a0, a0, a1
; RV64IB-NEXT:    ret
;
; RV64IBA-LABEL: sh2adduw_2:
; RV64IBA:       # %bb.0:
; RV64IBA-NEXT:    sh2add.uw a0, a0, a1
; RV64IBA-NEXT:    ret
  %3 = shl i64 %0, 2
  %4 = and i64 %3, 17179869180
  %5 = add i64 %4, %1
  ret i64 %5
}

define i64 @sh3adduw(i32 signext %0, i64* %1) {
; RV64I-LABEL: sh3adduw:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 32
; RV64I-NEXT:    srli a0, a0, 29
; RV64I-NEXT:    add a0, a1, a0
; RV64I-NEXT:    ld a0, 0(a0)
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sh3adduw:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    sh3add.uw a0, a0, a1
; RV64IB-NEXT:    ld a0, 0(a0)
; RV64IB-NEXT:    ret
;
; RV64IBA-LABEL: sh3adduw:
; RV64IBA:       # %bb.0:
; RV64IBA-NEXT:    sh3add.uw a0, a0, a1
; RV64IBA-NEXT:    ld a0, 0(a0)
; RV64IBA-NEXT:    ret
  %3 = zext i32 %0 to i64
  %4 = getelementptr inbounds i64, i64* %1, i64 %3
  %5 = load i64, i64* %4
  ret i64 %5
}

define i64 @sh3adduw_2(i64 %0, i64 %1) {
; RV64I-LABEL: sh3adduw_2:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 32
; RV64I-NEXT:    srli a0, a0, 29
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sh3adduw_2:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    sh3add.uw a0, a0, a1
; RV64IB-NEXT:    ret
;
; RV64IBA-LABEL: sh3adduw_2:
; RV64IBA:       # %bb.0:
; RV64IBA-NEXT:    sh3add.uw a0, a0, a1
; RV64IBA-NEXT:    ret
  %3 = shl i64 %0, 3
  %4 = and i64 %3, 34359738360
  %5 = add i64 %4, %1
  ret i64 %5
}

define i64 @addmul6(i64 %a, i64 %b) {
; RV64I-LABEL: addmul6:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a2, zero, 6
; RV64I-NEXT:    mul a0, a0, a2
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: addmul6:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    sh1add a0, a0, a0
; RV64IB-NEXT:    sh1add a0, a0, a1
; RV64IB-NEXT:    ret
;
; RV64IBA-LABEL: addmul6:
; RV64IBA:       # %bb.0:
; RV64IBA-NEXT:    sh1add a0, a0, a0
; RV64IBA-NEXT:    sh1add a0, a0, a1
; RV64IBA-NEXT:    ret
  %c = mul i64 %a, 6
  %d = add i64 %c, %b
  ret i64 %d
}

define i64 @addmul10(i64 %a, i64 %b) {
; RV64I-LABEL: addmul10:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a2, zero, 10
; RV64I-NEXT:    mul a0, a0, a2
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: addmul10:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    sh2add a0, a0, a0
; RV64IB-NEXT:    sh1add a0, a0, a1
; RV64IB-NEXT:    ret
;
; RV64IBA-LABEL: addmul10:
; RV64IBA:       # %bb.0:
; RV64IBA-NEXT:    sh2add a0, a0, a0
; RV64IBA-NEXT:    sh1add a0, a0, a1
; RV64IBA-NEXT:    ret
  %c = mul i64 %a, 10
  %d = add i64 %c, %b
  ret i64 %d
}

define i64 @addmul12(i64 %a, i64 %b) {
; RV64I-LABEL: addmul12:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a2, zero, 12
; RV64I-NEXT:    mul a0, a0, a2
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: addmul12:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    sh1add a0, a0, a0
; RV64IB-NEXT:    sh2add a0, a0, a1
; RV64IB-NEXT:    ret
;
; RV64IBA-LABEL: addmul12:
; RV64IBA:       # %bb.0:
; RV64IBA-NEXT:    sh1add a0, a0, a0
; RV64IBA-NEXT:    sh2add a0, a0, a1
; RV64IBA-NEXT:    ret
  %c = mul i64 %a, 12
  %d = add i64 %c, %b
  ret i64 %d
}

define i64 @addmul18(i64 %a, i64 %b) {
; RV64I-LABEL: addmul18:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a2, zero, 18
; RV64I-NEXT:    mul a0, a0, a2
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: addmul18:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    sh3add a0, a0, a0
; RV64IB-NEXT:    sh1add a0, a0, a1
; RV64IB-NEXT:    ret
;
; RV64IBA-LABEL: addmul18:
; RV64IBA:       # %bb.0:
; RV64IBA-NEXT:    sh3add a0, a0, a0
; RV64IBA-NEXT:    sh1add a0, a0, a1
; RV64IBA-NEXT:    ret
  %c = mul i64 %a, 18
  %d = add i64 %c, %b
  ret i64 %d
}

define i64 @addmul20(i64 %a, i64 %b) {
; RV64I-LABEL: addmul20:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a2, zero, 20
; RV64I-NEXT:    mul a0, a0, a2
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: addmul20:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    sh2add a0, a0, a0
; RV64IB-NEXT:    sh2add a0, a0, a1
; RV64IB-NEXT:    ret
;
; RV64IBA-LABEL: addmul20:
; RV64IBA:       # %bb.0:
; RV64IBA-NEXT:    sh2add a0, a0, a0
; RV64IBA-NEXT:    sh2add a0, a0, a1
; RV64IBA-NEXT:    ret
  %c = mul i64 %a, 20
  %d = add i64 %c, %b
  ret i64 %d
}

define i64 @addmul24(i64 %a, i64 %b) {
; RV64I-LABEL: addmul24:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a2, zero, 24
; RV64I-NEXT:    mul a0, a0, a2
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: addmul24:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    sh1add a0, a0, a0
; RV64IB-NEXT:    sh3add a0, a0, a1
; RV64IB-NEXT:    ret
;
; RV64IBA-LABEL: addmul24:
; RV64IBA:       # %bb.0:
; RV64IBA-NEXT:    sh1add a0, a0, a0
; RV64IBA-NEXT:    sh3add a0, a0, a1
; RV64IBA-NEXT:    ret
  %c = mul i64 %a, 24
  %d = add i64 %c, %b
  ret i64 %d
}

define i64 @addmul36(i64 %a, i64 %b) {
; RV64I-LABEL: addmul36:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a2, zero, 36
; RV64I-NEXT:    mul a0, a0, a2
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: addmul36:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    sh3add a0, a0, a0
; RV64IB-NEXT:    sh2add a0, a0, a1
; RV64IB-NEXT:    ret
;
; RV64IBA-LABEL: addmul36:
; RV64IBA:       # %bb.0:
; RV64IBA-NEXT:    sh3add a0, a0, a0
; RV64IBA-NEXT:    sh2add a0, a0, a1
; RV64IBA-NEXT:    ret
  %c = mul i64 %a, 36
  %d = add i64 %c, %b
  ret i64 %d
}

define i64 @addmul40(i64 %a, i64 %b) {
; RV64I-LABEL: addmul40:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a2, zero, 40
; RV64I-NEXT:    mul a0, a0, a2
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: addmul40:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    sh2add a0, a0, a0
; RV64IB-NEXT:    sh3add a0, a0, a1
; RV64IB-NEXT:    ret
;
; RV64IBA-LABEL: addmul40:
; RV64IBA:       # %bb.0:
; RV64IBA-NEXT:    sh2add a0, a0, a0
; RV64IBA-NEXT:    sh3add a0, a0, a1
; RV64IBA-NEXT:    ret
  %c = mul i64 %a, 40
  %d = add i64 %c, %b
  ret i64 %d
}

define i64 @addmul72(i64 %a, i64 %b) {
; RV64I-LABEL: addmul72:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a2, zero, 72
; RV64I-NEXT:    mul a0, a0, a2
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: addmul72:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    sh3add a0, a0, a0
; RV64IB-NEXT:    sh3add a0, a0, a1
; RV64IB-NEXT:    ret
;
; RV64IBA-LABEL: addmul72:
; RV64IBA:       # %bb.0:
; RV64IBA-NEXT:    sh3add a0, a0, a0
; RV64IBA-NEXT:    sh3add a0, a0, a1
; RV64IBA-NEXT:    ret
  %c = mul i64 %a, 72
  %d = add i64 %c, %b
  ret i64 %d
}

define i64 @mul96(i64 %a) {
; RV64I-LABEL: mul96:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a1, zero, 96
; RV64I-NEXT:    mul a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: mul96:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    addi a1, zero, 96
; RV64IB-NEXT:    mul a0, a0, a1
; RV64IB-NEXT:    ret
;
; RV64IBA-LABEL: mul96:
; RV64IBA:       # %bb.0:
; RV64IBA-NEXT:    addi a1, zero, 96
; RV64IBA-NEXT:    mul a0, a0, a1
; RV64IBA-NEXT:    ret
  %c = mul i64 %a, 96
  ret i64 %c
}

define i64 @mul160(i64 %a) {
; RV64I-LABEL: mul160:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a1, zero, 160
; RV64I-NEXT:    mul a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: mul160:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    addi a1, zero, 160
; RV64IB-NEXT:    mul a0, a0, a1
; RV64IB-NEXT:    ret
;
; RV64IBA-LABEL: mul160:
; RV64IBA:       # %bb.0:
; RV64IBA-NEXT:    addi a1, zero, 160
; RV64IBA-NEXT:    mul a0, a0, a1
; RV64IBA-NEXT:    ret
  %c = mul i64 %a, 160
  ret i64 %c
}

define i64 @mul288(i64 %a) {
; RV64I-LABEL: mul288:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a1, zero, 288
; RV64I-NEXT:    mul a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: mul288:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    addi a1, zero, 288
; RV64IB-NEXT:    mul a0, a0, a1
; RV64IB-NEXT:    ret
;
; RV64IBA-LABEL: mul288:
; RV64IBA:       # %bb.0:
; RV64IBA-NEXT:    addi a1, zero, 288
; RV64IBA-NEXT:    mul a0, a0, a1
; RV64IBA-NEXT:    ret
  %c = mul i64 %a, 288
  ret i64 %c
}

define i64 @sh1add_imm(i64 %0) {
; RV64I-LABEL: sh1add_imm:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 1
; RV64I-NEXT:    addi a0, a0, 5
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sh1add_imm:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    slli a0, a0, 1
; RV64IB-NEXT:    addi a0, a0, 5
; RV64IB-NEXT:    ret
;
; RV64IBA-LABEL: sh1add_imm:
; RV64IBA:       # %bb.0:
; RV64IBA-NEXT:    slli a0, a0, 1
; RV64IBA-NEXT:    addi a0, a0, 5
; RV64IBA-NEXT:    ret
  %a = shl i64 %0, 1
  %b = add i64 %a, 5
  ret i64 %b
}

define i64 @sh2add_imm(i64 %0) {
; RV64I-LABEL: sh2add_imm:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 2
; RV64I-NEXT:    addi a0, a0, -6
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sh2add_imm:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    slli a0, a0, 2
; RV64IB-NEXT:    addi a0, a0, -6
; RV64IB-NEXT:    ret
;
; RV64IBA-LABEL: sh2add_imm:
; RV64IBA:       # %bb.0:
; RV64IBA-NEXT:    slli a0, a0, 2
; RV64IBA-NEXT:    addi a0, a0, -6
; RV64IBA-NEXT:    ret
  %a = shl i64 %0, 2
  %b = add i64 %a, -6
  ret i64 %b
}

define i64 @sh3add_imm(i64 %0) {
; RV64I-LABEL: sh3add_imm:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 3
; RV64I-NEXT:    ori a0, a0, 7
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sh3add_imm:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    slli a0, a0, 3
; RV64IB-NEXT:    ori a0, a0, 7
; RV64IB-NEXT:    ret
;
; RV64IBA-LABEL: sh3add_imm:
; RV64IBA:       # %bb.0:
; RV64IBA-NEXT:    slli a0, a0, 3
; RV64IBA-NEXT:    ori a0, a0, 7
; RV64IBA-NEXT:    ret
  %a = shl i64 %0, 3
  %b = add i64 %a, 7
  ret i64 %b
}

define i64 @sh1adduw_imm(i32 signext %0) {
; RV64I-LABEL: sh1adduw_imm:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 32
; RV64I-NEXT:    srli a0, a0, 31
; RV64I-NEXT:    addi a0, a0, 11
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sh1adduw_imm:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    slli.uw a0, a0, 1
; RV64IB-NEXT:    addi a0, a0, 11
; RV64IB-NEXT:    ret
;
; RV64IBA-LABEL: sh1adduw_imm:
; RV64IBA:       # %bb.0:
; RV64IBA-NEXT:    slli.uw a0, a0, 1
; RV64IBA-NEXT:    addi a0, a0, 11
; RV64IBA-NEXT:    ret
  %a = zext i32 %0 to i64
  %b = shl i64 %a, 1
  %c = add i64 %b, 11
  ret i64 %c
}

define i64 @sh2adduw_imm(i32 signext %0) {
; RV64I-LABEL: sh2adduw_imm:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 32
; RV64I-NEXT:    srli a0, a0, 30
; RV64I-NEXT:    addi a0, a0, -12
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sh2adduw_imm:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    slli.uw a0, a0, 2
; RV64IB-NEXT:    addi a0, a0, -12
; RV64IB-NEXT:    ret
;
; RV64IBA-LABEL: sh2adduw_imm:
; RV64IBA:       # %bb.0:
; RV64IBA-NEXT:    slli.uw a0, a0, 2
; RV64IBA-NEXT:    addi a0, a0, -12
; RV64IBA-NEXT:    ret
  %a = zext i32 %0 to i64
  %b = shl i64 %a, 2
  %c = add i64 %b, -12
  ret i64 %c
}

define i64 @sh3adduw_imm(i32 signext %0) {
; RV64I-LABEL: sh3adduw_imm:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 32
; RV64I-NEXT:    srli a0, a0, 29
; RV64I-NEXT:    addi a0, a0, 13
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sh3adduw_imm:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    slli.uw a0, a0, 3
; RV64IB-NEXT:    addi a0, a0, 13
; RV64IB-NEXT:    ret
;
; RV64IBA-LABEL: sh3adduw_imm:
; RV64IBA:       # %bb.0:
; RV64IBA-NEXT:    slli.uw a0, a0, 3
; RV64IBA-NEXT:    addi a0, a0, 13
; RV64IBA-NEXT:    ret
  %a = zext i32 %0 to i64
  %b = shl i64 %a, 3
  %c = add i64 %b, 13
  ret i64 %c
}

define i64 @adduw_imm(i32 signext %0) nounwind {
; RV64I-LABEL: adduw_imm:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 32
; RV64I-NEXT:    srli a0, a0, 32
; RV64I-NEXT:    addi a0, a0, 5
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: adduw_imm:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    zext.w a0, a0
; RV64IB-NEXT:    addi a0, a0, 5
; RV64IB-NEXT:    ret
;
; RV64IBA-LABEL: adduw_imm:
; RV64IBA:       # %bb.0:
; RV64IBA-NEXT:    zext.w a0, a0
; RV64IBA-NEXT:    addi a0, a0, 5
; RV64IBA-NEXT:    ret
  %a = zext i32 %0 to i64
  %b = add i64 %a, 5
  ret i64 %b
}

define i64 @mul258(i64 %a) {
; RV64I-LABEL: mul258:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a1, zero, 258
; RV64I-NEXT:    mul a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: mul258:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    addi a1, zero, 258
; RV64IB-NEXT:    mul a0, a0, a1
; RV64IB-NEXT:    ret
;
; RV64IBA-LABEL: mul258:
; RV64IBA:       # %bb.0:
; RV64IBA-NEXT:    addi a1, zero, 258
; RV64IBA-NEXT:    mul a0, a0, a1
; RV64IBA-NEXT:    ret
  %c = mul i64 %a, 258
  ret i64 %c
}

define i64 @mul260(i64 %a) {
; RV64I-LABEL: mul260:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a1, zero, 260
; RV64I-NEXT:    mul a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: mul260:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    addi a1, zero, 260
; RV64IB-NEXT:    mul a0, a0, a1
; RV64IB-NEXT:    ret
;
; RV64IBA-LABEL: mul260:
; RV64IBA:       # %bb.0:
; RV64IBA-NEXT:    addi a1, zero, 260
; RV64IBA-NEXT:    mul a0, a0, a1
; RV64IBA-NEXT:    ret
  %c = mul i64 %a, 260
  ret i64 %c
}

define i64 @mul264(i64 %a) {
; RV64I-LABEL: mul264:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a1, zero, 264
; RV64I-NEXT:    mul a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: mul264:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    addi a1, zero, 264
; RV64IB-NEXT:    mul a0, a0, a1
; RV64IB-NEXT:    ret
;
; RV64IBA-LABEL: mul264:
; RV64IBA:       # %bb.0:
; RV64IBA-NEXT:    addi a1, zero, 264
; RV64IBA-NEXT:    mul a0, a0, a1
; RV64IBA-NEXT:    ret
  %c = mul i64 %a, 264
  ret i64 %c
}
