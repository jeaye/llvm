; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+sse4.1 | FileCheck %s --check-prefix=X86
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.1 | FileCheck %s --check-prefix=X64

define <4 x i32> @add_4i32(<4 x i32> %a0, <4 x i32> %a1) {
; X86-LABEL: add_4i32:
; X86:       # %bb.0:
; X86-NEXT:    paddd %xmm1, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: add_4i32:
; X64:       # %bb.0:
; X64-NEXT:    paddd %xmm1, %xmm0
; X64-NEXT:    retq
  %1 = add <4 x i32> %a0, <i32  1, i32 -2, i32  3, i32 -4>
  %2 = add <4 x i32> %a1, <i32 -1, i32  2, i32 -3, i32  4>
  %3 = add <4 x i32> %1, %2
  ret <4 x i32> %3
}

define <4 x i32> @add_4i32_commute(<4 x i32> %a0, <4 x i32> %a1) {
; X86-LABEL: add_4i32_commute:
; X86:       # %bb.0:
; X86-NEXT:    paddd %xmm1, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: add_4i32_commute:
; X64:       # %bb.0:
; X64-NEXT:    paddd %xmm1, %xmm0
; X64-NEXT:    retq
  %1 = add <4 x i32> <i32  1, i32 -2, i32  3, i32 -4>, %a0
  %2 = add <4 x i32> <i32 -1, i32  2, i32 -3, i32  4>, %a1
  %3 = add <4 x i32> %1, %2
  ret <4 x i32> %3
}

define <4 x i32> @mul_4i32(<4 x i32> %a0, <4 x i32> %a1) {
; X86-LABEL: mul_4i32:
; X86:       # %bb.0:
; X86-NEXT:    pmulld %xmm1, %xmm0
; X86-NEXT:    pmulld {{\.?LCPI[0-9]+_[0-9]+}}, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: mul_4i32:
; X64:       # %bb.0:
; X64-NEXT:    pmulld %xmm1, %xmm0
; X64-NEXT:    pmulld {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; X64-NEXT:    retq
  %1 = mul <4 x i32> %a0, <i32 1, i32 2, i32 3, i32 4>
  %2 = mul <4 x i32> %a1, <i32 4, i32 3, i32 2, i32 1>
  %3 = mul <4 x i32> %1, %2
  ret <4 x i32> %3
}

define <4 x i32> @mul_4i32_commute(<4 x i32> %a0, <4 x i32> %a1) {
; X86-LABEL: mul_4i32_commute:
; X86:       # %bb.0:
; X86-NEXT:    pmulld %xmm1, %xmm0
; X86-NEXT:    pmulld {{\.?LCPI[0-9]+_[0-9]+}}, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: mul_4i32_commute:
; X64:       # %bb.0:
; X64-NEXT:    pmulld %xmm1, %xmm0
; X64-NEXT:    pmulld {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; X64-NEXT:    retq
  %1 = mul <4 x i32> <i32 1, i32 2, i32 3, i32 4>, %a0
  %2 = mul <4 x i32> <i32 4, i32 3, i32 2, i32 1>, %a1
  %3 = mul <4 x i32> %1, %2
  ret <4 x i32> %3
}

define <4 x i32> @and_4i32(<4 x i32> %a0, <4 x i32> %a1) {
; X86-LABEL: and_4i32:
; X86:       # %bb.0:
; X86-NEXT:    andps %xmm1, %xmm0
; X86-NEXT:    andps {{\.?LCPI[0-9]+_[0-9]+}}, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: and_4i32:
; X64:       # %bb.0:
; X64-NEXT:    andps %xmm1, %xmm0
; X64-NEXT:    andps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; X64-NEXT:    retq
  %1 = and <4 x i32> %a0, <i32 -2, i32 -2, i32  3, i32  3>
  %2 = and <4 x i32> %a1, <i32 -1, i32 -1, i32  1, i32  1>
  %3 = and <4 x i32> %1, %2
  ret <4 x i32> %3
}

define <4 x i32> @and_4i32_commute(<4 x i32> %a0, <4 x i32> %a1) {
; X86-LABEL: and_4i32_commute:
; X86:       # %bb.0:
; X86-NEXT:    andps %xmm1, %xmm0
; X86-NEXT:    andps {{\.?LCPI[0-9]+_[0-9]+}}, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: and_4i32_commute:
; X64:       # %bb.0:
; X64-NEXT:    andps %xmm1, %xmm0
; X64-NEXT:    andps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; X64-NEXT:    retq
  %1 = and <4 x i32> <i32 -2, i32 -2, i32  3, i32  3>, %a0
  %2 = and <4 x i32> <i32 -1, i32 -1, i32  1, i32  1>, %a1
  %3 = and <4 x i32> %1, %2
  ret <4 x i32> %3
}

define <4 x i32> @or_4i32(<4 x i32> %a0, <4 x i32> %a1) {
; X86-LABEL: or_4i32:
; X86:       # %bb.0:
; X86-NEXT:    orps %xmm1, %xmm0
; X86-NEXT:    orps {{\.?LCPI[0-9]+_[0-9]+}}, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: or_4i32:
; X64:       # %bb.0:
; X64-NEXT:    orps %xmm1, %xmm0
; X64-NEXT:    orps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; X64-NEXT:    retq
  %1 = or <4 x i32> %a0, <i32 -2, i32 -2, i32  3, i32  3>
  %2 = or <4 x i32> %a1, <i32 -1, i32 -1, i32  1, i32  1>
  %3 = or <4 x i32> %1, %2
  ret <4 x i32> %3
}

define <4 x i32> @or_4i32_commute(<4 x i32> %a0, <4 x i32> %a1) {
; X86-LABEL: or_4i32_commute:
; X86:       # %bb.0:
; X86-NEXT:    orps %xmm1, %xmm0
; X86-NEXT:    orps {{\.?LCPI[0-9]+_[0-9]+}}, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: or_4i32_commute:
; X64:       # %bb.0:
; X64-NEXT:    orps %xmm1, %xmm0
; X64-NEXT:    orps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; X64-NEXT:    retq
  %1 = or <4 x i32> <i32 -2, i32 -2, i32  3, i32  3>, %a0
  %2 = or <4 x i32> <i32 -1, i32 -1, i32  1, i32  1>, %a1
  %3 = or <4 x i32> %1, %2
  ret <4 x i32> %3
}

define <4 x i32> @xor_4i32(<4 x i32> %a0, <4 x i32> %a1) {
; X86-LABEL: xor_4i32:
; X86:       # %bb.0:
; X86-NEXT:    xorps %xmm1, %xmm0
; X86-NEXT:    xorps {{\.?LCPI[0-9]+_[0-9]+}}, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: xor_4i32:
; X64:       # %bb.0:
; X64-NEXT:    xorps %xmm1, %xmm0
; X64-NEXT:    xorps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; X64-NEXT:    retq
  %1 = xor <4 x i32> %a0, <i32 -2, i32 -2, i32  3, i32  3>
  %2 = xor <4 x i32> %a1, <i32 -1, i32 -1, i32  1, i32  1>
  %3 = xor <4 x i32> %1, %2
  ret <4 x i32> %3
}

define <4 x i32> @xor_4i32_commute(<4 x i32> %a0, <4 x i32> %a1) {
; X86-LABEL: xor_4i32_commute:
; X86:       # %bb.0:
; X86-NEXT:    xorps %xmm1, %xmm0
; X86-NEXT:    xorps {{\.?LCPI[0-9]+_[0-9]+}}, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: xor_4i32_commute:
; X64:       # %bb.0:
; X64-NEXT:    xorps %xmm1, %xmm0
; X64-NEXT:    xorps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; X64-NEXT:    retq
  %1 = xor <4 x i32> <i32 -2, i32 -2, i32  3, i32  3>, %a0
  %2 = xor <4 x i32> <i32 -1, i32 -1, i32  1, i32  1>, %a1
  %3 = xor <4 x i32> %1, %2
  ret <4 x i32> %3
}
