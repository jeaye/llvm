; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instsimplify -S | FileCheck %s


; Verify that floor(10.1) is folded to 10.0 when the exception behavior is 'ignore'.
define double @floor_01() #0 {
; CHECK-LABEL: @floor_01(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret double 1.000000e+01
;
entry:
  %result = call double @llvm.experimental.constrained.floor.f64(double 1.010000e+01, metadata !"fpexcept.ignore") #0
  ret double %result
}

; Verify that floor(-10.1) is folded to -11.0 when the exception behavior is not 'ignore'.
define double @floor_02() #0 {
; CHECK-LABEL: @floor_02(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[RESULT:%.*]] = call double @llvm.experimental.constrained.floor.f64(double -1.010000e+01, metadata !"fpexcept.strict") #[[ATTR0:[0-9]+]]
; CHECK-NEXT:    ret double -1.100000e+01
;
entry:
  %result = call double @llvm.experimental.constrained.floor.f64(double -1.010000e+01, metadata !"fpexcept.strict") #0
  ret double %result
}

; Verify that ceil(10.1) is folded to 11.0 when the exception behavior is 'ignore'.
define double @ceil_01() #0 {
; CHECK-LABEL: @ceil_01(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret double 1.100000e+01
;
entry:
  %result = call double @llvm.experimental.constrained.ceil.f64(double 1.010000e+01, metadata !"fpexcept.ignore") #0
  ret double %result
}

; Verify that ceil(-10.1) is folded to -10.0 when the exception behavior is not 'ignore'.
define double @ceil_02() #0 {
; CHECK-LABEL: @ceil_02(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[RESULT:%.*]] = call double @llvm.experimental.constrained.ceil.f64(double -1.010000e+01, metadata !"fpexcept.strict") #[[ATTR0]]
; CHECK-NEXT:    ret double -1.000000e+01
;
entry:
  %result = call double @llvm.experimental.constrained.ceil.f64(double -1.010000e+01, metadata !"fpexcept.strict") #0
  ret double %result
}

; Verify that trunc(10.1) is folded to 10.0 when the exception behavior is 'ignore'.
define double @trunc_01() #0 {
; CHECK-LABEL: @trunc_01(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret double 1.000000e+01
;
entry:
  %result = call double @llvm.experimental.constrained.trunc.f64(double 1.010000e+01, metadata !"fpexcept.ignore") #0
  ret double %result
}

; Verify that trunc(-10.1) is folded to -10.0 when the exception behavior is NOT 'ignore'.
define double @trunc_02() #0 {
; CHECK-LABEL: @trunc_02(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[RESULT:%.*]] = call double @llvm.experimental.constrained.trunc.f64(double -1.010000e+01, metadata !"fpexcept.strict") #[[ATTR0]]
; CHECK-NEXT:    ret double -1.000000e+01
;
entry:
  %result = call double @llvm.experimental.constrained.trunc.f64(double -1.010000e+01, metadata !"fpexcept.strict") #0
  ret double %result
}

; Verify that round(10.5) is folded to 11.0 when the exception behavior is 'ignore'.
define double @round_01() #0 {
; CHECK-LABEL: @round_01(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret double 1.100000e+01
;
entry:
  %result = call double @llvm.experimental.constrained.round.f64(double 1.050000e+01, metadata !"fpexcept.ignore") #0
  ret double %result
}

; Verify that floor(-10.5) is folded to -11.0 when the exception behavior is NOT 'ignore'.
define double @round_02() #0 {
; CHECK-LABEL: @round_02(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[RESULT:%.*]] = call double @llvm.experimental.constrained.round.f64(double -1.050000e+01, metadata !"fpexcept.strict") #[[ATTR0]]
; CHECK-NEXT:    ret double -1.100000e+01
;
entry:
  %result = call double @llvm.experimental.constrained.round.f64(double -1.050000e+01, metadata !"fpexcept.strict") #0
  ret double %result
}

; Verify that nearbyint(10.5) is folded to 11.0 when the rounding mode is 'upward'.
define double @nearbyint_01() #0 {
; CHECK-LABEL: @nearbyint_01(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret double 1.100000e+01
;
entry:
  %result = call double @llvm.experimental.constrained.nearbyint.f64(double 1.050000e+01, metadata !"round.upward", metadata !"fpexcept.ignore") #0
  ret double %result
}

; Verify that nearbyint(10.5) is folded to 10.0 when the rounding mode is 'downward'.
define double @nearbyint_02() #0 {
; CHECK-LABEL: @nearbyint_02(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret double 1.000000e+01
;
entry:
  %result = call double @llvm.experimental.constrained.nearbyint.f64(double 1.050000e+01, metadata !"round.downward", metadata !"fpexcept.maytrap") #0
  ret double %result
}

; Verify that nearbyint(10.5) is folded to 10.0 when the rounding mode is 'towardzero'.
define double @nearbyint_03() #0 {
; CHECK-LABEL: @nearbyint_03(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[RESULT:%.*]] = call double @llvm.experimental.constrained.nearbyint.f64(double 1.050000e+01, metadata !"round.towardzero", metadata !"fpexcept.strict") #[[ATTR0]]
; CHECK-NEXT:    ret double 1.000000e+01
;
entry:
  %result = call double @llvm.experimental.constrained.nearbyint.f64(double 1.050000e+01, metadata !"round.towardzero", metadata !"fpexcept.strict") #0
  ret double %result
}

; Verify that nearbyint(10.5) is folded to 10.0 when the rounding mode is 'tonearest'.
define double @nearbyint_04() #0 {
; CHECK-LABEL: @nearbyint_04(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[RESULT:%.*]] = call double @llvm.experimental.constrained.nearbyint.f64(double 1.050000e+01, metadata !"round.tonearest", metadata !"fpexcept.strict") #[[ATTR0]]
; CHECK-NEXT:    ret double 1.000000e+01
;
entry:
  %result = call double @llvm.experimental.constrained.nearbyint.f64(double 1.050000e+01, metadata !"round.tonearest", metadata !"fpexcept.strict") #0
  ret double %result
}

; Verify that nearbyint(10.5) is NOT folded if the rounding mode is 'dynamic'.
define double @nearbyint_05() #0 {
; CHECK-LABEL: @nearbyint_05(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[RESULT:%.*]] = call double @llvm.experimental.constrained.nearbyint.f64(double 1.050000e+01, metadata !"round.dynamic", metadata !"fpexcept.strict") #[[ATTR0]]
; CHECK-NEXT:    ret double [[RESULT]]
;
entry:
  %result = call double @llvm.experimental.constrained.nearbyint.f64(double 1.050000e+01, metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret double %result
}

; Verify that trunc(SNAN) is NOT folded if the exception behavior mode is not 'ignore'.
define double @nonfinite_01() #0 {
; CHECK-LABEL: @nonfinite_01(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[RESULT:%.*]] = call double @llvm.experimental.constrained.trunc.f64(double 0x7FF4000000000000, metadata !"fpexcept.strict") #[[ATTR0]]
; CHECK-NEXT:    ret double [[RESULT]]
;
entry:
  %result = call double @llvm.experimental.constrained.trunc.f64(double 0x7ff4000000000000, metadata !"fpexcept.strict") #0
  ret double %result
}

; Verify that trunc(SNAN) is folded to QNAN if the exception behavior mode is 'ignore'.
define double @nonfinite_02() #0 {
; CHECK-LABEL: @nonfinite_02(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret double 0x7FF8000000000000
;
entry:
  %result = call double @llvm.experimental.constrained.trunc.f64(double 0x7ff4000000000000, metadata !"fpexcept.ignore") #0
  ret double %result
}

; Verify that trunc(QNAN) is folded even if the exception behavior mode is not 'ignore'.
define double @nonfinite_03() #0 {
; CHECK-LABEL: @nonfinite_03(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[RESULT:%.*]] = call double @llvm.experimental.constrained.trunc.f64(double 0x7FF8000000000000, metadata !"fpexcept.strict") #[[ATTR0]]
; CHECK-NEXT:    ret double 0x7FF8000000000000
;
entry:
  %result = call double @llvm.experimental.constrained.trunc.f64(double 0x7ff8000000000000, metadata !"fpexcept.strict") #0
  ret double %result
}

; Verify that trunc(+Inf) is folded even if the exception behavior mode is not 'ignore'.
define double @nonfinite_04() #0 {
; CHECK-LABEL: @nonfinite_04(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[RESULT:%.*]] = call double @llvm.experimental.constrained.trunc.f64(double 0x7FF0000000000000, metadata !"fpexcept.strict") #[[ATTR0]]
; CHECK-NEXT:    ret double 0x7FF0000000000000
;
entry:
  %result = call double @llvm.experimental.constrained.trunc.f64(double 0x7ff0000000000000, metadata !"fpexcept.strict") #0
  ret double %result
}

; Verify that rint(10) is folded to 10.0 when the rounding mode is 'tonearest'.
define double @rint_01() #0 {
; CHECK-LABEL: @rint_01(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[RESULT:%.*]] = call double @llvm.experimental.constrained.rint.f64(double 1.000000e+01, metadata !"round.tonearest", metadata !"fpexcept.strict") #[[ATTR0]]
; CHECK-NEXT:    ret double 1.000000e+01
;
entry:
  %result = call double @llvm.experimental.constrained.rint.f64(double 1.000000e+01, metadata !"round.tonearest", metadata !"fpexcept.strict") #0
  ret double %result
}

; Verify that rint(10.1) is NOT folded to 10.0 when the exception behavior is 'strict'.
define double @rint_02() #0 {
; CHECK-LABEL: @rint_02(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[RESULT:%.*]] = call double @llvm.experimental.constrained.rint.f64(double 1.010000e+01, metadata !"round.tonearest", metadata !"fpexcept.strict") #[[ATTR0]]
; CHECK-NEXT:    ret double [[RESULT]]
;
entry:
  %result = call double @llvm.experimental.constrained.rint.f64(double 1.010000e+01, metadata !"round.tonearest", metadata !"fpexcept.strict") #0
  ret double %result
}

; Verify that rint(10.1) is folded to 10.0 when the exception behavior is not 'strict'.
define double @rint_03() #0 {
; CHECK-LABEL: @rint_03(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret double 1.000000e+01
;
entry:
  %result = call double @llvm.experimental.constrained.rint.f64(double 1.010000e+01, metadata !"round.tonearest", metadata !"fpexcept.maytrap") #0
  ret double %result
}

define float @fadd_01() #0 {
; CHECK-LABEL: @fadd_01(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret float 3.000000e+01
;
entry:
  %result = call float @llvm.experimental.constrained.fadd.f32(float 1.000000e+01, float 2.000000e+01, metadata !"round.tonearest", metadata !"fpexcept.ignore") #0
  ret float %result
}

; Inexact result does not prevent from folding if exceptions are ignored and
; rounding mode is known.
define double @fadd_02() #0 {
; CHECK-LABEL: @fadd_02(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret double 2.000000e+00
;
entry:
  %result = call double @llvm.experimental.constrained.fadd.f64(double 1.0, double 0x3FF0000000000001, metadata !"round.tonearest", metadata !"fpexcept.ignore") #0
  ret double %result
}

define double @fadd_03() #0 {
; CHECK-LABEL: @fadd_03(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret double 0x4000000000000001
;
entry:
  %result = call double @llvm.experimental.constrained.fadd.f64(double 1.0, double 0x3FF0000000000001, metadata !"round.upward", metadata !"fpexcept.ignore") #0
  ret double %result
}

; Inexact result prevents from folding if exceptions may be checked.
define double @fadd_04() #0 {
; CHECK-LABEL: @fadd_04(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[RESULT:%.*]] = call double @llvm.experimental.constrained.fadd.f64(double 1.000000e+00, double 0x3FF0000000000001, metadata !"round.tonearest", metadata !"fpexcept.strict") #[[ATTR0]]
; CHECK-NEXT:    ret double [[RESULT]]
;
entry:
  %result = call double @llvm.experimental.constrained.fadd.f64(double 1.0, double 0x3FF0000000000001, metadata !"round.tonearest", metadata !"fpexcept.strict") #0
  ret double %result
}

; If result is exact, folding is allowed even if exceptions may be checked.
define double @fadd_05() #0 {
; CHECK-LABEL: @fadd_05(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret double 3.000000e+00
;
entry:
  %result = call double @llvm.experimental.constrained.fadd.f64(double 1.0, double 2.0, metadata !"round.tonearest", metadata !"fpexcept.strict") #0
  ret double %result
}

; Dynamic rounding mode does not prevent from folding if the result is exact.
define double @fadd_06() #0 {
; CHECK-LABEL: @fadd_06(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret double 3.000000e+00
;
entry:
  %result = call double @llvm.experimental.constrained.fadd.f64(double 1.0, double 2.0, metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret double %result
}

; Inexact results prevents from folding if rounding mode is unknown.
define double @fadd_07() #0 {
; CHECK-LABEL: @fadd_07(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[RESULT:%.*]] = call double @llvm.experimental.constrained.fadd.f64(double 1.000000e+00, double 0x3FF0000000000001, metadata !"round.dynamic", metadata !"fpexcept.ignore") #[[ATTR0]]
; CHECK-NEXT:    ret double [[RESULT]]
;
entry:
  %result = call double @llvm.experimental.constrained.fadd.f64(double 1.0, double 0x3FF0000000000001, metadata !"round.dynamic", metadata !"fpexcept.ignore") #0
  ret double %result
}

; Infinite result does not prevent from folding unless exceptions are tracked.
define double @fadd_08() #0 {
; CHECK-LABEL: @fadd_08(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret double 0x7FF0000000000000
;
entry:
  %result = call double @llvm.experimental.constrained.fadd.f64(double 0x7fEFFFFFFFFFFFFF, double 0x7fEFFFFFFFFFFFFF, metadata !"round.tonearest", metadata !"fpexcept.ignore") #0
  ret double %result
}

define double @fadd_09() #0 {
; CHECK-LABEL: @fadd_09(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[RESULT:%.*]] = call double @llvm.experimental.constrained.fadd.f64(double 0x7FEFFFFFFFFFFFFF, double 0x7FEFFFFFFFFFFFFF, metadata !"round.tonearest", metadata !"fpexcept.strict") #[[ATTR0]]
; CHECK-NEXT:    ret double [[RESULT]]
;
entry:
  %result = call double @llvm.experimental.constrained.fadd.f64(double 0x7fEFFFFFFFFFFFFF, double 0x7fEFFFFFFFFFFFFF, metadata !"round.tonearest", metadata !"fpexcept.strict") #0
  ret double %result
}

define half @fadd_10() #0 {
; CHECK-LABEL: @fadd_10(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret half 0xH4200
;
entry:
  %result = call half @llvm.experimental.constrained.fadd.f16(half 1.0, half 2.0, metadata !"round.tonearest", metadata !"fpexcept.ignore") #0
  ret half %result
}

define bfloat @fadd_11() #0 {
; CHECK-LABEL: @fadd_11(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret bfloat 0xR4040
;
entry:
  %result = call bfloat @llvm.experimental.constrained.fadd.bf16(bfloat 1.0, bfloat 2.0, metadata !"round.tonearest", metadata !"fpexcept.ignore") #0
  ret bfloat %result
}

define double @fsub_01() #0 {
; CHECK-LABEL: @fsub_01(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret double -1.000000e+00
;
entry:
  %result = call double @llvm.experimental.constrained.fsub.f64(double 1.0, double 2.0, metadata !"round.tonearest", metadata !"fpexcept.ignore") #0
  ret double %result
}

define double @fmul_01() #0 {
; CHECK-LABEL: @fmul_01(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret double 2.000000e+00
;
entry:
  %result = call double @llvm.experimental.constrained.fmul.f64(double 1.0, double 2.0, metadata !"round.tonearest", metadata !"fpexcept.ignore") #0
  ret double %result
}

define double @fdiv_01() #0 {
; CHECK-LABEL: @fdiv_01(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret double 5.000000e-01
;
entry:
  %result = call double @llvm.experimental.constrained.fdiv.f64(double 1.0, double 2.0, metadata !"round.tonearest", metadata !"fpexcept.ignore") #0
  ret double %result
}

define double @frem_01() #0 {
; CHECK-LABEL: @frem_01(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret double 1.000000e+00
;
entry:
  %result = call double @llvm.experimental.constrained.frem.f64(double 1.0, double 2.0, metadata !"round.dynamic", metadata !"fpexcept.ignore") #0
  ret double %result
}

define double @fma_01() #0 {
; CHECK-LABEL: @fma_01(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret double 5.000000e+00
;
entry:
  %result = call double @llvm.experimental.constrained.fma.f64(double 1.0, double 2.0, double 3.0, metadata !"round.dynamic", metadata !"fpexcept.ignore") #0
  ret double %result
}

define double @fmuladd_01() #0 {
; CHECK-LABEL: @fmuladd_01(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret double 5.000000e+00
;
entry:
  %result = call double @llvm.experimental.constrained.fmuladd.f64(double 1.0, double 2.0, double 3.0, metadata !"round.dynamic", metadata !"fpexcept.ignore") #0
  ret double %result
}


attributes #0 = { strictfp }

declare double @llvm.experimental.constrained.nearbyint.f64(double, metadata, metadata)
declare double @llvm.experimental.constrained.floor.f64(double, metadata)
declare double @llvm.experimental.constrained.ceil.f64(double, metadata)
declare double @llvm.experimental.constrained.trunc.f64(double, metadata)
declare double @llvm.experimental.constrained.round.f64(double, metadata)
declare double @llvm.experimental.constrained.rint.f64(double, metadata, metadata)
declare double @llvm.experimental.constrained.fadd.f64(double, double, metadata, metadata)
declare float @llvm.experimental.constrained.fadd.f32(float, float, metadata, metadata)
declare half @llvm.experimental.constrained.fadd.f16(half, half, metadata, metadata)
declare bfloat @llvm.experimental.constrained.fadd.bf16(bfloat, bfloat, metadata, metadata)
declare double @llvm.experimental.constrained.fsub.f64(double, double, metadata, metadata)
declare double @llvm.experimental.constrained.fmul.f64(double, double, metadata, metadata)
declare double @llvm.experimental.constrained.fdiv.f64(double, double, metadata, metadata)
declare double @llvm.experimental.constrained.frem.f64(double, double, metadata, metadata)
declare double @llvm.experimental.constrained.fma.f64(double, double, double, metadata, metadata)
declare double @llvm.experimental.constrained.fmuladd.f64(double, double, double, metadata, metadata)

