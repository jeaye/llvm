; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+avx512vl | FileCheck %s --check-prefix=X86
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512vl | FileCheck %s --check-prefix=X64

define void @vec3_setcc_crash(<3 x i32>* %in, <3 x i32>* %out) {
; X86-LABEL: vec3_setcc_crash:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    vmovdqa (%ecx), %xmm0
; X86-NEXT:    vptestnmd %xmm0, %xmm0, %k1
; X86-NEXT:    vmovdqa32 %xmm0, %xmm0 {%k1} {z}
; X86-NEXT:    vpextrd $2, %xmm0, 8(%eax)
; X86-NEXT:    vpextrd $1, %xmm0, 4(%eax)
; X86-NEXT:    vmovd %xmm0, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: vec3_setcc_crash:
; X64:       # %bb.0:
; X64-NEXT:    vmovdqa (%rdi), %xmm0
; X64-NEXT:    vptestnmd %xmm0, %xmm0, %k1
; X64-NEXT:    vmovdqa32 %xmm0, %xmm0 {%k1} {z}
; X64-NEXT:    vpextrd $2, %xmm0, 8(%rsi)
; X64-NEXT:    vmovq %xmm0, (%rsi)
; X64-NEXT:    retq
  %a = load <3 x i32>, <3 x i32>* %in
  %cmp = icmp eq <3 x i32> %a, zeroinitializer
  %c = select <3 x i1> %cmp, <3 x i32> %a, <3 x i32> zeroinitializer
  store <3 x i32> %c, <3 x i32>* %out
  ret void
}
