; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mcpu=pentium4 | FileCheck %s

@f1 = global float 1.000000e+00, align 4

define zeroext i1 @_Z9test_log2v() {
; CHECK-LABEL: _Z9test_log2v:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushl %eax
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    flds f1
; CHECK-NEXT:    #APP
; CHECK-NEXT:    fld1
; CHECK-NEXT:    fxch %st(1)
; CHECK-NEXT:    fyl2x
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    fstps (%esp)
; CHECK-NEXT:    xorps %xmm0, %xmm0
; CHECK-NEXT:    cmpeqss (%esp), %xmm0
; CHECK-NEXT:    movd %xmm0, %eax
; CHECK-NEXT:    andl $1, %eax
; CHECK-NEXT:    # kill: def $al killed $al killed $eax
; CHECK-NEXT:    popl %ecx
; CHECK-NEXT:    .cfi_def_cfa_offset 4
; CHECK-NEXT:    retl
entry:
  %0 = load float, float* @f1, align 4
  %1 = fpext float %0 to x86_fp80
  %2 = tail call x86_fp80 asm "fld1; fxch; fyl2x", "={st},0,~{st(1)},~{dirflag},~{fpsr},~{flags}"(x86_fp80 %1)
  %conv = fptrunc x86_fp80 %2 to float
  %3 = fcmp oeq float %conv, 0.000000e+00
  ret i1 %3
}

@fpi = external dso_local global float, align 4

define zeroext i1 @_Z8test_cosv() {
; CHECK-LABEL: _Z8test_cosv:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    subl $8, %esp
; CHECK-NEXT:    .cfi_def_cfa_offset 12
; CHECK-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; CHECK-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; CHECK-NEXT:    divss {{\.?LCPI[0-9]+_[0-9]+}}, %xmm0
; CHECK-NEXT:    movss %xmm0, {{[0-9]+}}(%esp)
; CHECK-NEXT:    flds {{[0-9]+}}(%esp)
; CHECK-NEXT:    #APP
; CHECK-NEXT:    fcos
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    fstps (%esp)
; CHECK-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; CHECK-NEXT:    ucomiss %xmm0, %xmm1
; CHECK-NEXT:    setae %cl
; CHECK-NEXT:    ucomiss {{\.?LCPI[0-9]+_[0-9]+}}, %xmm0
; CHECK-NEXT:    setae %al
; CHECK-NEXT:    andb %cl, %al
; CHECK-NEXT:    addl $8, %esp
; CHECK-NEXT:    .cfi_def_cfa_offset 4
; CHECK-NEXT:    retl
entry:
  %0 = load float, float* @fpi, align 4
  %div = fdiv float %0, 6.000000e+00
  %1 = fpext float %div to x86_fp80
  %2 = tail call x86_fp80 asm "fcos", "={st},0,~{dirflag},~{fpsr},~{flags}"(x86_fp80 %1)
  %conv = fptrunc x86_fp80 %2 to float
  %cmp = fcmp ole float %conv, 0x3FEBD70A40000000
  %cmp1 = fcmp oge float %conv, 0x3FEB851EC0000000
  %or.cond = and i1 %cmp, %cmp1
  ret i1 %or.cond
}
