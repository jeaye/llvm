; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mcpu=skx -mtriple=x86_64-unknown-linux-gnu < %s | FileCheck %s

; This test crashed during type legalization of SETCC result type.
define <3 x i8 > @foo(<3 x i8>%x, <3 x i8>%a, <3 x i8>%b) {
; CHECK-LABEL: foo:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovd %edi, %xmm0
; CHECK-NEXT:    vpinsrd $1, %esi, %xmm0, %xmm0
; CHECK-NEXT:    vpinsrd $2, %edx, %xmm0, %xmm0
; CHECK-NEXT:    vpslld $24, %xmm0, %xmm0
; CHECK-NEXT:    vpsrad $24, %xmm0, %xmm0
; CHECK-NEXT:    vmovd %ecx, %xmm1
; CHECK-NEXT:    vpinsrd $1, %r8d, %xmm1, %xmm1
; CHECK-NEXT:    vpinsrd $2, %r9d, %xmm1, %xmm1
; CHECK-NEXT:    vpslld $24, %xmm1, %xmm1
; CHECK-NEXT:    vpsrad $24, %xmm1, %xmm1
; CHECK-NEXT:    vpcmpgtd %xmm0, %xmm1, %k0
; CHECK-NEXT:    vpmovm2d %k0, %xmm0
; CHECK-NEXT:    vpextrb $0, %xmm0, %eax
; CHECK-NEXT:    vpextrb $4, %xmm0, %edx
; CHECK-NEXT:    vpextrb $8, %xmm0, %ecx
; CHECK-NEXT:    # kill: %al<def> %al<kill> %eax<kill>
; CHECK-NEXT:    # kill: %dl<def> %dl<kill> %edx<kill>
; CHECK-NEXT:    # kill: %cl<def> %cl<kill> %ecx<kill>
; CHECK-NEXT:    retq
  %cmp.i = icmp slt <3 x i8> %x, %a
  %res = sext <3 x i1> %cmp.i to <3 x i8>
  ret <3 x i8> %res
}

