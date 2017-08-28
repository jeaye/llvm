; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=x86-64 -mattr=+ssse3 | FileCheck %s --check-prefix=CHECK --check-prefix=GENERIC
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=atom | FileCheck %s --check-prefix=CHECK --check-prefix=ATOM
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=slm | FileCheck %s --check-prefix=CHECK --check-prefix=SLM
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=sandybridge | FileCheck %s --check-prefix=CHECK --check-prefix=SANDY
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=ivybridge | FileCheck %s --check-prefix=CHECK --check-prefix=SANDY
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=haswell | FileCheck %s --check-prefix=CHECK --check-prefix=HASWELL
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=skylake | FileCheck %s --check-prefix=CHECK --check-prefix=HASWELL
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=btver2 | FileCheck %s --check-prefix=CHECK --check-prefix=BTVER2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=znver1 | FileCheck %s --check-prefix=CHECK --check-prefix=ZNVER1

define <16 x i8> @test_pabsb(<16 x i8> %a0, <16 x i8> *%a1) {
; GENERIC-LABEL: test_pabsb:
; GENERIC:       # BB#0:
; GENERIC-NEXT:    pabsb %xmm0, %xmm1 # sched: [1:0.50]
; GENERIC-NEXT:    pabsb (%rdi), %xmm0 # sched: [7:0.50]
; GENERIC-NEXT:    por %xmm1, %xmm0 # sched: [1:0.33]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; ATOM-LABEL: test_pabsb:
; ATOM:       # BB#0:
; ATOM-NEXT:    pabsb (%rdi), %xmm1 # sched: [1:1.00]
; ATOM-NEXT:    pabsb %xmm0, %xmm0 # sched: [1:0.50]
; ATOM-NEXT:    por %xmm0, %xmm1 # sched: [1:0.50]
; ATOM-NEXT:    movdqa %xmm1, %xmm0 # sched: [1:0.50]
; ATOM-NEXT:    retq # sched: [79:39.50]
;
; SLM-LABEL: test_pabsb:
; SLM:       # BB#0:
; SLM-NEXT:    pabsb %xmm0, %xmm1 # sched: [1:0.50]
; SLM-NEXT:    pabsb (%rdi), %xmm0 # sched: [4:1.00]
; SLM-NEXT:    por %xmm1, %xmm0 # sched: [1:0.50]
; SLM-NEXT:    retq # sched: [4:1.00]
;
; SANDY-LABEL: test_pabsb:
; SANDY:       # BB#0:
; SANDY-NEXT:    vpabsb %xmm0, %xmm0 # sched: [1:0.50]
; SANDY-NEXT:    vpabsb (%rdi), %xmm1 # sched: [7:0.50]
; SANDY-NEXT:    vpor %xmm1, %xmm0, %xmm0 # sched: [1:0.33]
; SANDY-NEXT:    retq # sched: [1:1.00]
;
; HASWELL-LABEL: test_pabsb:
; HASWELL:       # BB#0:
; HASWELL-NEXT:    vpabsb %xmm0, %xmm0 # sched: [1:0.50]
; HASWELL-NEXT:    vpabsb (%rdi), %xmm1 # sched: [1:0.50]
; HASWELL-NEXT:    vpor %xmm1, %xmm0, %xmm0 # sched: [1:0.33]
; HASWELL-NEXT:    retq # sched: [2:1.00]
;
; BTVER2-LABEL: test_pabsb:
; BTVER2:       # BB#0:
; BTVER2-NEXT:    vpabsb (%rdi), %xmm1 # sched: [6:1.00]
; BTVER2-NEXT:    vpabsb %xmm0, %xmm0 # sched: [1:0.50]
; BTVER2-NEXT:    vpor %xmm1, %xmm0, %xmm0 # sched: [1:0.50]
; BTVER2-NEXT:    retq # sched: [4:1.00]
;
; ZNVER1-LABEL: test_pabsb:
; ZNVER1:       # BB#0:
; ZNVER1-NEXT:    vpabsb (%rdi), %xmm1 # sched: [8:0.50]
; ZNVER1-NEXT:    vpabsb %xmm0, %xmm0 # sched: [1:0.25]
; ZNVER1-NEXT:    vpor %xmm1, %xmm0, %xmm0 # sched: [1:0.25]
; ZNVER1-NEXT:    retq # sched: [5:0.50]
  %1 = call <16 x i8> @llvm.x86.ssse3.pabs.b.128(<16 x i8> %a0)
  %2 = load <16 x i8>, <16 x i8> *%a1, align 16
  %3 = call <16 x i8> @llvm.x86.ssse3.pabs.b.128(<16 x i8> %2)
  %4 = or <16 x i8> %1, %3
  ret <16 x i8> %4
}
declare <16 x i8> @llvm.x86.ssse3.pabs.b.128(<16 x i8>) nounwind readnone

define <4 x i32> @test_pabsd(<4 x i32> %a0, <4 x i32> *%a1) {
; GENERIC-LABEL: test_pabsd:
; GENERIC:       # BB#0:
; GENERIC-NEXT:    pabsd %xmm0, %xmm1 # sched: [1:0.50]
; GENERIC-NEXT:    pabsd (%rdi), %xmm0 # sched: [7:0.50]
; GENERIC-NEXT:    por %xmm1, %xmm0 # sched: [1:0.33]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; ATOM-LABEL: test_pabsd:
; ATOM:       # BB#0:
; ATOM-NEXT:    pabsd (%rdi), %xmm1 # sched: [1:1.00]
; ATOM-NEXT:    pabsd %xmm0, %xmm0 # sched: [1:0.50]
; ATOM-NEXT:    por %xmm0, %xmm1 # sched: [1:0.50]
; ATOM-NEXT:    movdqa %xmm1, %xmm0 # sched: [1:0.50]
; ATOM-NEXT:    retq # sched: [79:39.50]
;
; SLM-LABEL: test_pabsd:
; SLM:       # BB#0:
; SLM-NEXT:    pabsd %xmm0, %xmm1 # sched: [1:0.50]
; SLM-NEXT:    pabsd (%rdi), %xmm0 # sched: [4:1.00]
; SLM-NEXT:    por %xmm1, %xmm0 # sched: [1:0.50]
; SLM-NEXT:    retq # sched: [4:1.00]
;
; SANDY-LABEL: test_pabsd:
; SANDY:       # BB#0:
; SANDY-NEXT:    vpabsd %xmm0, %xmm0 # sched: [1:0.50]
; SANDY-NEXT:    vpabsd (%rdi), %xmm1 # sched: [7:0.50]
; SANDY-NEXT:    vpor %xmm1, %xmm0, %xmm0 # sched: [1:0.33]
; SANDY-NEXT:    retq # sched: [1:1.00]
;
; HASWELL-LABEL: test_pabsd:
; HASWELL:       # BB#0:
; HASWELL-NEXT:    vpabsd %xmm0, %xmm0 # sched: [1:0.50]
; HASWELL-NEXT:    vpabsd (%rdi), %xmm1 # sched: [1:0.50]
; HASWELL-NEXT:    vpor %xmm1, %xmm0, %xmm0 # sched: [1:0.33]
; HASWELL-NEXT:    retq # sched: [2:1.00]
;
; BTVER2-LABEL: test_pabsd:
; BTVER2:       # BB#0:
; BTVER2-NEXT:    vpabsd (%rdi), %xmm1 # sched: [6:1.00]
; BTVER2-NEXT:    vpabsd %xmm0, %xmm0 # sched: [1:0.50]
; BTVER2-NEXT:    vpor %xmm1, %xmm0, %xmm0 # sched: [1:0.50]
; BTVER2-NEXT:    retq # sched: [4:1.00]
;
; ZNVER1-LABEL: test_pabsd:
; ZNVER1:       # BB#0:
; ZNVER1-NEXT:    vpabsd (%rdi), %xmm1 # sched: [8:0.50]
; ZNVER1-NEXT:    vpabsd %xmm0, %xmm0 # sched: [1:0.25]
; ZNVER1-NEXT:    vpor %xmm1, %xmm0, %xmm0 # sched: [1:0.25]
; ZNVER1-NEXT:    retq # sched: [5:0.50]
  %1 = call <4 x i32> @llvm.x86.ssse3.pabs.d.128(<4 x i32> %a0)
  %2 = load <4 x i32>, <4 x i32> *%a1, align 16
  %3 = call <4 x i32> @llvm.x86.ssse3.pabs.d.128(<4 x i32> %2)
  %4 = or <4 x i32> %1, %3
  ret <4 x i32> %4
}
declare <4 x i32> @llvm.x86.ssse3.pabs.d.128(<4 x i32>) nounwind readnone

define <8 x i16> @test_pabsw(<8 x i16> %a0, <8 x i16> *%a1) {
; GENERIC-LABEL: test_pabsw:
; GENERIC:       # BB#0:
; GENERIC-NEXT:    pabsw %xmm0, %xmm1 # sched: [1:0.50]
; GENERIC-NEXT:    pabsw (%rdi), %xmm0 # sched: [7:0.50]
; GENERIC-NEXT:    por %xmm1, %xmm0 # sched: [1:0.33]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; ATOM-LABEL: test_pabsw:
; ATOM:       # BB#0:
; ATOM-NEXT:    pabsw (%rdi), %xmm1 # sched: [1:1.00]
; ATOM-NEXT:    pabsw %xmm0, %xmm0 # sched: [1:0.50]
; ATOM-NEXT:    por %xmm0, %xmm1 # sched: [1:0.50]
; ATOM-NEXT:    movdqa %xmm1, %xmm0 # sched: [1:0.50]
; ATOM-NEXT:    retq # sched: [79:39.50]
;
; SLM-LABEL: test_pabsw:
; SLM:       # BB#0:
; SLM-NEXT:    pabsw %xmm0, %xmm1 # sched: [1:0.50]
; SLM-NEXT:    pabsw (%rdi), %xmm0 # sched: [4:1.00]
; SLM-NEXT:    por %xmm1, %xmm0 # sched: [1:0.50]
; SLM-NEXT:    retq # sched: [4:1.00]
;
; SANDY-LABEL: test_pabsw:
; SANDY:       # BB#0:
; SANDY-NEXT:    vpabsw %xmm0, %xmm0 # sched: [1:0.50]
; SANDY-NEXT:    vpabsw (%rdi), %xmm1 # sched: [7:0.50]
; SANDY-NEXT:    vpor %xmm1, %xmm0, %xmm0 # sched: [1:0.33]
; SANDY-NEXT:    retq # sched: [1:1.00]
;
; HASWELL-LABEL: test_pabsw:
; HASWELL:       # BB#0:
; HASWELL-NEXT:    vpabsw %xmm0, %xmm0 # sched: [1:0.50]
; HASWELL-NEXT:    vpabsw (%rdi), %xmm1 # sched: [1:0.50]
; HASWELL-NEXT:    vpor %xmm1, %xmm0, %xmm0 # sched: [1:0.33]
; HASWELL-NEXT:    retq # sched: [2:1.00]
;
; BTVER2-LABEL: test_pabsw:
; BTVER2:       # BB#0:
; BTVER2-NEXT:    vpabsw (%rdi), %xmm1 # sched: [6:1.00]
; BTVER2-NEXT:    vpabsw %xmm0, %xmm0 # sched: [1:0.50]
; BTVER2-NEXT:    vpor %xmm1, %xmm0, %xmm0 # sched: [1:0.50]
; BTVER2-NEXT:    retq # sched: [4:1.00]
;
; ZNVER1-LABEL: test_pabsw:
; ZNVER1:       # BB#0:
; ZNVER1-NEXT:    vpabsw (%rdi), %xmm1 # sched: [8:0.50]
; ZNVER1-NEXT:    vpabsw %xmm0, %xmm0 # sched: [1:0.25]
; ZNVER1-NEXT:    vpor %xmm1, %xmm0, %xmm0 # sched: [1:0.25]
; ZNVER1-NEXT:    retq # sched: [5:0.50]
  %1 = call <8 x i16> @llvm.x86.ssse3.pabs.w.128(<8 x i16> %a0)
  %2 = load <8 x i16>, <8 x i16> *%a1, align 16
  %3 = call <8 x i16> @llvm.x86.ssse3.pabs.w.128(<8 x i16> %2)
  %4 = or <8 x i16> %1, %3
  ret <8 x i16> %4
}
declare <8 x i16> @llvm.x86.ssse3.pabs.w.128(<8 x i16>) nounwind readnone

define <8 x i16> @test_palignr(<8 x i16> %a0, <8 x i16> %a1, <8 x i16> *%a2) {
; GENERIC-LABEL: test_palignr:
; GENERIC:       # BB#0:
; GENERIC-NEXT:    palignr {{.*#+}} xmm1 = xmm0[6,7,8,9,10,11,12,13,14,15],xmm1[0,1,2,3,4,5] sched: [1:0.50]
; GENERIC-NEXT:    palignr {{.*#+}} xmm1 = mem[14,15],xmm1[0,1,2,3,4,5,6,7,8,9,10,11,12,13] sched: [7:0.50]
; GENERIC-NEXT:    movdqa %xmm1, %xmm0 # sched: [1:0.33]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; ATOM-LABEL: test_palignr:
; ATOM:       # BB#0:
; ATOM-NEXT:    palignr {{.*#+}} xmm1 = xmm0[6,7,8,9,10,11,12,13,14,15],xmm1[0,1,2,3,4,5] sched: [1:1.00]
; ATOM-NEXT:    palignr {{.*#+}} xmm1 = mem[14,15],xmm1[0,1,2,3,4,5,6,7,8,9,10,11,12,13] sched: [1:1.00]
; ATOM-NEXT:    movdqa %xmm1, %xmm0 # sched: [1:0.50]
; ATOM-NEXT:    nop # sched: [1:0.50]
; ATOM-NEXT:    nop # sched: [1:0.50]
; ATOM-NEXT:    retq # sched: [79:39.50]
;
; SLM-LABEL: test_palignr:
; SLM:       # BB#0:
; SLM-NEXT:    palignr {{.*#+}} xmm1 = xmm0[6,7,8,9,10,11,12,13,14,15],xmm1[0,1,2,3,4,5] sched: [1:1.00]
; SLM-NEXT:    palignr {{.*#+}} xmm1 = mem[14,15],xmm1[0,1,2,3,4,5,6,7,8,9,10,11,12,13] sched: [4:1.00]
; SLM-NEXT:    movdqa %xmm1, %xmm0 # sched: [1:0.50]
; SLM-NEXT:    retq # sched: [4:1.00]
;
; SANDY-LABEL: test_palignr:
; SANDY:       # BB#0:
; SANDY-NEXT:    vpalignr {{.*#+}} xmm0 = xmm0[6,7,8,9,10,11,12,13,14,15],xmm1[0,1,2,3,4,5] sched: [1:0.50]
; SANDY-NEXT:    vpalignr {{.*#+}} xmm0 = mem[14,15],xmm0[0,1,2,3,4,5,6,7,8,9,10,11,12,13] sched: [7:0.50]
; SANDY-NEXT:    retq # sched: [1:1.00]
;
; HASWELL-LABEL: test_palignr:
; HASWELL:       # BB#0:
; HASWELL-NEXT:    vpalignr {{.*#+}} xmm0 = xmm0[6,7,8,9,10,11,12,13,14,15],xmm1[0,1,2,3,4,5] sched: [1:1.00]
; HASWELL-NEXT:    vpalignr {{.*#+}} xmm0 = mem[14,15],xmm0[0,1,2,3,4,5,6,7,8,9,10,11,12,13] sched: [1:1.00]
; HASWELL-NEXT:    retq # sched: [2:1.00]
;
; BTVER2-LABEL: test_palignr:
; BTVER2:       # BB#0:
; BTVER2-NEXT:    vpalignr {{.*#+}} xmm0 = xmm0[6,7,8,9,10,11,12,13,14,15],xmm1[0,1,2,3,4,5] sched: [1:0.50]
; BTVER2-NEXT:    vpalignr {{.*#+}} xmm0 = mem[14,15],xmm0[0,1,2,3,4,5,6,7,8,9,10,11,12,13] sched: [6:1.00]
; BTVER2-NEXT:    retq # sched: [4:1.00]
;
; ZNVER1-LABEL: test_palignr:
; ZNVER1:       # BB#0:
; ZNVER1-NEXT:    vpalignr {{.*#+}} xmm0 = xmm0[6,7,8,9,10,11,12,13,14,15],xmm1[0,1,2,3,4,5] sched: [1:0.25]
; ZNVER1-NEXT:    vpalignr {{.*#+}} xmm0 = mem[14,15],xmm0[0,1,2,3,4,5,6,7,8,9,10,11,12,13] sched: [8:0.50]
; ZNVER1-NEXT:    retq # sched: [5:0.50]
  %1 = shufflevector <8 x i16> %a0, <8 x i16> %a1, <8 x i32> <i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10>
  %2 = load <8 x i16>, <8 x i16> *%a2, align 16
  %3 = shufflevector <8 x i16> %2, <8 x i16> %1, <8 x i32> <i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14>
  ret <8 x i16> %3
}

define <4 x i32> @test_phaddd(<4 x i32> %a0, <4 x i32> %a1, <4 x i32> *%a2) {
; GENERIC-LABEL: test_phaddd:
; GENERIC:       # BB#0:
; GENERIC-NEXT:    phaddd %xmm1, %xmm0 # sched: [3:1.50]
; GENERIC-NEXT:    phaddd (%rdi), %xmm0 # sched: [9:1.50]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; ATOM-LABEL: test_phaddd:
; ATOM:       # BB#0:
; ATOM-NEXT:    phaddd %xmm1, %xmm0 # sched: [3:1.50]
; ATOM-NEXT:    phaddd (%rdi), %xmm0 # sched: [4:2.00]
; ATOM-NEXT:    retq # sched: [79:39.50]
;
; SLM-LABEL: test_phaddd:
; SLM:       # BB#0:
; SLM-NEXT:    phaddd %xmm1, %xmm0 # sched: [1:0.50]
; SLM-NEXT:    phaddd (%rdi), %xmm0 # sched: [4:1.00]
; SLM-NEXT:    retq # sched: [4:1.00]
;
; SANDY-LABEL: test_phaddd:
; SANDY:       # BB#0:
; SANDY-NEXT:    vphaddd %xmm1, %xmm0, %xmm0 # sched: [3:1.50]
; SANDY-NEXT:    vphaddd (%rdi), %xmm0, %xmm0 # sched: [9:1.50]
; SANDY-NEXT:    retq # sched: [1:1.00]
;
; HASWELL-LABEL: test_phaddd:
; HASWELL:       # BB#0:
; HASWELL-NEXT:    vphaddd %xmm1, %xmm0, %xmm0 # sched: [3:2.00]
; HASWELL-NEXT:    vphaddd (%rdi), %xmm0, %xmm0 # sched: [3:2.00]
; HASWELL-NEXT:    retq # sched: [2:1.00]
;
; BTVER2-LABEL: test_phaddd:
; BTVER2:       # BB#0:
; BTVER2-NEXT:    vphaddd %xmm1, %xmm0, %xmm0 # sched: [1:0.50]
; BTVER2-NEXT:    vphaddd (%rdi), %xmm0, %xmm0 # sched: [6:1.00]
; BTVER2-NEXT:    retq # sched: [4:1.00]
;
; ZNVER1-LABEL: test_phaddd:
; ZNVER1:       # BB#0:
; ZNVER1-NEXT:    vphaddd %xmm1, %xmm0, %xmm0 # sched: [1:0.25]
; ZNVER1-NEXT:    vphaddd (%rdi), %xmm0, %xmm0 # sched: [8:0.50]
; ZNVER1-NEXT:    retq # sched: [5:0.50]
  %1 = call <4 x i32> @llvm.x86.ssse3.phadd.d.128(<4 x i32> %a0, <4 x i32> %a1)
  %2 = load <4 x i32>, <4 x i32> *%a2, align 16
  %3 = call <4 x i32> @llvm.x86.ssse3.phadd.d.128(<4 x i32> %1, <4 x i32> %2)
  ret <4 x i32> %3
}
declare <4 x i32> @llvm.x86.ssse3.phadd.d.128(<4 x i32>, <4 x i32>) nounwind readnone

define <8 x i16> @test_phaddsw(<8 x i16> %a0, <8 x i16> %a1, <8 x i16> *%a2) {
; GENERIC-LABEL: test_phaddsw:
; GENERIC:       # BB#0:
; GENERIC-NEXT:    phaddsw %xmm1, %xmm0 # sched: [3:1.50]
; GENERIC-NEXT:    phaddsw (%rdi), %xmm0 # sched: [9:1.50]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; ATOM-LABEL: test_phaddsw:
; ATOM:       # BB#0:
; ATOM-NEXT:    phaddsw %xmm1, %xmm0 # sched: [7:3.50]
; ATOM-NEXT:    phaddsw (%rdi), %xmm0 # sched: [8:4.00]
; ATOM-NEXT:    retq # sched: [79:39.50]
;
; SLM-LABEL: test_phaddsw:
; SLM:       # BB#0:
; SLM-NEXT:    phaddsw %xmm1, %xmm0 # sched: [1:0.50]
; SLM-NEXT:    phaddsw (%rdi), %xmm0 # sched: [4:1.00]
; SLM-NEXT:    retq # sched: [4:1.00]
;
; SANDY-LABEL: test_phaddsw:
; SANDY:       # BB#0:
; SANDY-NEXT:    vphaddsw %xmm1, %xmm0, %xmm0 # sched: [3:1.50]
; SANDY-NEXT:    vphaddsw (%rdi), %xmm0, %xmm0 # sched: [9:1.50]
; SANDY-NEXT:    retq # sched: [1:1.00]
;
; HASWELL-LABEL: test_phaddsw:
; HASWELL:       # BB#0:
; HASWELL-NEXT:    vphaddsw %xmm1, %xmm0, %xmm0 # sched: [3:2.00]
; HASWELL-NEXT:    vphaddsw (%rdi), %xmm0, %xmm0 # sched: [3:2.00]
; HASWELL-NEXT:    retq # sched: [2:1.00]
;
; BTVER2-LABEL: test_phaddsw:
; BTVER2:       # BB#0:
; BTVER2-NEXT:    vphaddsw %xmm1, %xmm0, %xmm0 # sched: [1:0.50]
; BTVER2-NEXT:    vphaddsw (%rdi), %xmm0, %xmm0 # sched: [6:1.00]
; BTVER2-NEXT:    retq # sched: [4:1.00]
;
; ZNVER1-LABEL: test_phaddsw:
; ZNVER1:       # BB#0:
; ZNVER1-NEXT:    vphaddsw %xmm1, %xmm0, %xmm0 # sched: [1:0.25]
; ZNVER1-NEXT:    vphaddsw (%rdi), %xmm0, %xmm0 # sched: [8:0.50]
; ZNVER1-NEXT:    retq # sched: [5:0.50]
  %1 = call <8 x i16> @llvm.x86.ssse3.phadd.sw.128(<8 x i16> %a0, <8 x i16> %a1)
  %2 = load <8 x i16>, <8 x i16> *%a2, align 16
  %3 = call <8 x i16> @llvm.x86.ssse3.phadd.sw.128(<8 x i16> %1, <8 x i16> %2)
  ret <8 x i16> %3
}
declare <8 x i16> @llvm.x86.ssse3.phadd.sw.128(<8 x i16>, <8 x i16>) nounwind readnone

define <8 x i16> @test_phaddw(<8 x i16> %a0, <8 x i16> %a1, <8 x i16> *%a2) {
; GENERIC-LABEL: test_phaddw:
; GENERIC:       # BB#0:
; GENERIC-NEXT:    phaddw %xmm1, %xmm0 # sched: [3:1.50]
; GENERIC-NEXT:    phaddw (%rdi), %xmm0 # sched: [9:1.50]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; ATOM-LABEL: test_phaddw:
; ATOM:       # BB#0:
; ATOM-NEXT:    phaddw %xmm1, %xmm0 # sched: [7:3.50]
; ATOM-NEXT:    phaddw (%rdi), %xmm0 # sched: [8:4.00]
; ATOM-NEXT:    retq # sched: [79:39.50]
;
; SLM-LABEL: test_phaddw:
; SLM:       # BB#0:
; SLM-NEXT:    phaddw %xmm1, %xmm0 # sched: [1:0.50]
; SLM-NEXT:    phaddw (%rdi), %xmm0 # sched: [4:1.00]
; SLM-NEXT:    retq # sched: [4:1.00]
;
; SANDY-LABEL: test_phaddw:
; SANDY:       # BB#0:
; SANDY-NEXT:    vphaddw %xmm1, %xmm0, %xmm0 # sched: [3:1.50]
; SANDY-NEXT:    vphaddw (%rdi), %xmm0, %xmm0 # sched: [9:1.50]
; SANDY-NEXT:    retq # sched: [1:1.00]
;
; HASWELL-LABEL: test_phaddw:
; HASWELL:       # BB#0:
; HASWELL-NEXT:    vphaddw %xmm1, %xmm0, %xmm0 # sched: [3:2.00]
; HASWELL-NEXT:    vphaddw (%rdi), %xmm0, %xmm0 # sched: [3:2.00]
; HASWELL-NEXT:    retq # sched: [2:1.00]
;
; BTVER2-LABEL: test_phaddw:
; BTVER2:       # BB#0:
; BTVER2-NEXT:    vphaddw %xmm1, %xmm0, %xmm0 # sched: [1:0.50]
; BTVER2-NEXT:    vphaddw (%rdi), %xmm0, %xmm0 # sched: [6:1.00]
; BTVER2-NEXT:    retq # sched: [4:1.00]
;
; ZNVER1-LABEL: test_phaddw:
; ZNVER1:       # BB#0:
; ZNVER1-NEXT:    vphaddw %xmm1, %xmm0, %xmm0 # sched: [1:0.25]
; ZNVER1-NEXT:    vphaddw (%rdi), %xmm0, %xmm0 # sched: [8:0.50]
; ZNVER1-NEXT:    retq # sched: [5:0.50]
  %1 = call <8 x i16> @llvm.x86.ssse3.phadd.w.128(<8 x i16> %a0, <8 x i16> %a1)
  %2 = load <8 x i16>, <8 x i16> *%a2, align 16
  %3 = call <8 x i16> @llvm.x86.ssse3.phadd.w.128(<8 x i16> %1, <8 x i16> %2)
  ret <8 x i16> %3
}
declare <8 x i16> @llvm.x86.ssse3.phadd.w.128(<8 x i16>, <8 x i16>) nounwind readnone

define <4 x i32> @test_phsubd(<4 x i32> %a0, <4 x i32> %a1, <4 x i32> *%a2) {
; GENERIC-LABEL: test_phsubd:
; GENERIC:       # BB#0:
; GENERIC-NEXT:    phsubd %xmm1, %xmm0 # sched: [3:1.50]
; GENERIC-NEXT:    phsubd (%rdi), %xmm0 # sched: [9:1.50]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; ATOM-LABEL: test_phsubd:
; ATOM:       # BB#0:
; ATOM-NEXT:    phsubd %xmm1, %xmm0 # sched: [3:1.50]
; ATOM-NEXT:    phsubd (%rdi), %xmm0 # sched: [4:2.00]
; ATOM-NEXT:    retq # sched: [79:39.50]
;
; SLM-LABEL: test_phsubd:
; SLM:       # BB#0:
; SLM-NEXT:    phsubd %xmm1, %xmm0 # sched: [1:0.50]
; SLM-NEXT:    phsubd (%rdi), %xmm0 # sched: [4:1.00]
; SLM-NEXT:    retq # sched: [4:1.00]
;
; SANDY-LABEL: test_phsubd:
; SANDY:       # BB#0:
; SANDY-NEXT:    vphsubd %xmm1, %xmm0, %xmm0 # sched: [3:1.50]
; SANDY-NEXT:    vphsubd (%rdi), %xmm0, %xmm0 # sched: [9:1.50]
; SANDY-NEXT:    retq # sched: [1:1.00]
;
; HASWELL-LABEL: test_phsubd:
; HASWELL:       # BB#0:
; HASWELL-NEXT:    vphsubd %xmm1, %xmm0, %xmm0 # sched: [3:2.00]
; HASWELL-NEXT:    vphsubd (%rdi), %xmm0, %xmm0 # sched: [3:2.00]
; HASWELL-NEXT:    retq # sched: [2:1.00]
;
; BTVER2-LABEL: test_phsubd:
; BTVER2:       # BB#0:
; BTVER2-NEXT:    vphsubd %xmm1, %xmm0, %xmm0 # sched: [1:0.50]
; BTVER2-NEXT:    vphsubd (%rdi), %xmm0, %xmm0 # sched: [6:1.00]
; BTVER2-NEXT:    retq # sched: [4:1.00]
;
; ZNVER1-LABEL: test_phsubd:
; ZNVER1:       # BB#0:
; ZNVER1-NEXT:    vphsubd %xmm1, %xmm0, %xmm0 # sched: [1:0.25]
; ZNVER1-NEXT:    vphsubd (%rdi), %xmm0, %xmm0 # sched: [8:0.50]
; ZNVER1-NEXT:    retq # sched: [5:0.50]
  %1 = call <4 x i32> @llvm.x86.ssse3.phsub.d.128(<4 x i32> %a0, <4 x i32> %a1)
  %2 = load <4 x i32>, <4 x i32> *%a2, align 16
  %3 = call <4 x i32> @llvm.x86.ssse3.phsub.d.128(<4 x i32> %1, <4 x i32> %2)
  ret <4 x i32> %3
}
declare <4 x i32> @llvm.x86.ssse3.phsub.d.128(<4 x i32>, <4 x i32>) nounwind readnone

define <8 x i16> @test_phsubsw(<8 x i16> %a0, <8 x i16> %a1, <8 x i16> *%a2) {
; GENERIC-LABEL: test_phsubsw:
; GENERIC:       # BB#0:
; GENERIC-NEXT:    phsubsw %xmm1, %xmm0 # sched: [3:1.50]
; GENERIC-NEXT:    phsubsw (%rdi), %xmm0 # sched: [9:1.50]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; ATOM-LABEL: test_phsubsw:
; ATOM:       # BB#0:
; ATOM-NEXT:    phsubsw %xmm1, %xmm0 # sched: [7:3.50]
; ATOM-NEXT:    phsubsw (%rdi), %xmm0 # sched: [8:4.00]
; ATOM-NEXT:    retq # sched: [79:39.50]
;
; SLM-LABEL: test_phsubsw:
; SLM:       # BB#0:
; SLM-NEXT:    phsubsw %xmm1, %xmm0 # sched: [1:0.50]
; SLM-NEXT:    phsubsw (%rdi), %xmm0 # sched: [4:1.00]
; SLM-NEXT:    retq # sched: [4:1.00]
;
; SANDY-LABEL: test_phsubsw:
; SANDY:       # BB#0:
; SANDY-NEXT:    vphsubsw %xmm1, %xmm0, %xmm0 # sched: [3:1.50]
; SANDY-NEXT:    vphsubsw (%rdi), %xmm0, %xmm0 # sched: [9:1.50]
; SANDY-NEXT:    retq # sched: [1:1.00]
;
; HASWELL-LABEL: test_phsubsw:
; HASWELL:       # BB#0:
; HASWELL-NEXT:    vphsubsw %xmm1, %xmm0, %xmm0 # sched: [3:2.00]
; HASWELL-NEXT:    vphsubsw (%rdi), %xmm0, %xmm0 # sched: [3:2.00]
; HASWELL-NEXT:    retq # sched: [2:1.00]
;
; BTVER2-LABEL: test_phsubsw:
; BTVER2:       # BB#0:
; BTVER2-NEXT:    vphsubsw %xmm1, %xmm0, %xmm0 # sched: [1:0.50]
; BTVER2-NEXT:    vphsubsw (%rdi), %xmm0, %xmm0 # sched: [6:1.00]
; BTVER2-NEXT:    retq # sched: [4:1.00]
;
; ZNVER1-LABEL: test_phsubsw:
; ZNVER1:       # BB#0:
; ZNVER1-NEXT:    vphsubsw %xmm1, %xmm0, %xmm0 # sched: [1:0.25]
; ZNVER1-NEXT:    vphsubsw (%rdi), %xmm0, %xmm0 # sched: [8:0.50]
; ZNVER1-NEXT:    retq # sched: [5:0.50]
  %1 = call <8 x i16> @llvm.x86.ssse3.phsub.sw.128(<8 x i16> %a0, <8 x i16> %a1)
  %2 = load <8 x i16>, <8 x i16> *%a2, align 16
  %3 = call <8 x i16> @llvm.x86.ssse3.phsub.sw.128(<8 x i16> %1, <8 x i16> %2)
  ret <8 x i16> %3
}
declare <8 x i16> @llvm.x86.ssse3.phsub.sw.128(<8 x i16>, <8 x i16>) nounwind readnone

define <8 x i16> @test_phsubw(<8 x i16> %a0, <8 x i16> %a1, <8 x i16> *%a2) {
; GENERIC-LABEL: test_phsubw:
; GENERIC:       # BB#0:
; GENERIC-NEXT:    phsubw %xmm1, %xmm0 # sched: [3:1.50]
; GENERIC-NEXT:    phsubw (%rdi), %xmm0 # sched: [9:1.50]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; ATOM-LABEL: test_phsubw:
; ATOM:       # BB#0:
; ATOM-NEXT:    phsubw %xmm1, %xmm0 # sched: [7:3.50]
; ATOM-NEXT:    phsubw (%rdi), %xmm0 # sched: [8:4.00]
; ATOM-NEXT:    retq # sched: [79:39.50]
;
; SLM-LABEL: test_phsubw:
; SLM:       # BB#0:
; SLM-NEXT:    phsubw %xmm1, %xmm0 # sched: [1:0.50]
; SLM-NEXT:    phsubw (%rdi), %xmm0 # sched: [4:1.00]
; SLM-NEXT:    retq # sched: [4:1.00]
;
; SANDY-LABEL: test_phsubw:
; SANDY:       # BB#0:
; SANDY-NEXT:    vphsubw %xmm1, %xmm0, %xmm0 # sched: [3:1.50]
; SANDY-NEXT:    vphsubw (%rdi), %xmm0, %xmm0 # sched: [9:1.50]
; SANDY-NEXT:    retq # sched: [1:1.00]
;
; HASWELL-LABEL: test_phsubw:
; HASWELL:       # BB#0:
; HASWELL-NEXT:    vphsubw %xmm1, %xmm0, %xmm0 # sched: [3:2.00]
; HASWELL-NEXT:    vphsubw (%rdi), %xmm0, %xmm0 # sched: [3:2.00]
; HASWELL-NEXT:    retq # sched: [2:1.00]
;
; BTVER2-LABEL: test_phsubw:
; BTVER2:       # BB#0:
; BTVER2-NEXT:    vphsubw %xmm1, %xmm0, %xmm0 # sched: [1:0.50]
; BTVER2-NEXT:    vphsubw (%rdi), %xmm0, %xmm0 # sched: [6:1.00]
; BTVER2-NEXT:    retq # sched: [4:1.00]
;
; ZNVER1-LABEL: test_phsubw:
; ZNVER1:       # BB#0:
; ZNVER1-NEXT:    vphsubw %xmm1, %xmm0, %xmm0 # sched: [1:0.25]
; ZNVER1-NEXT:    vphsubw (%rdi), %xmm0, %xmm0 # sched: [8:0.50]
; ZNVER1-NEXT:    retq # sched: [5:0.50]
  %1 = call <8 x i16> @llvm.x86.ssse3.phsub.w.128(<8 x i16> %a0, <8 x i16> %a1)
  %2 = load <8 x i16>, <8 x i16> *%a2, align 16
  %3 = call <8 x i16> @llvm.x86.ssse3.phsub.w.128(<8 x i16> %1, <8 x i16> %2)
  ret <8 x i16> %3
}
declare <8 x i16> @llvm.x86.ssse3.phsub.w.128(<8 x i16>, <8 x i16>) nounwind readnone

define <8 x i16> @test_pmaddubsw(<16 x i8> %a0, <16 x i8> %a1, <16 x i8> *%a2) {
; GENERIC-LABEL: test_pmaddubsw:
; GENERIC:       # BB#0:
; GENERIC-NEXT:    pmaddubsw %xmm1, %xmm0 # sched: [3:1.00]
; GENERIC-NEXT:    pmaddubsw (%rdi), %xmm0 # sched: [9:1.00]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; ATOM-LABEL: test_pmaddubsw:
; ATOM:       # BB#0:
; ATOM-NEXT:    pmaddubsw %xmm1, %xmm0 # sched: [5:5.00]
; ATOM-NEXT:    pmaddubsw (%rdi), %xmm0 # sched: [5:5.00]
; ATOM-NEXT:    retq # sched: [79:39.50]
;
; SLM-LABEL: test_pmaddubsw:
; SLM:       # BB#0:
; SLM-NEXT:    pmaddubsw %xmm1, %xmm0 # sched: [4:1.00]
; SLM-NEXT:    pmaddubsw (%rdi), %xmm0 # sched: [7:1.00]
; SLM-NEXT:    retq # sched: [4:1.00]
;
; SANDY-LABEL: test_pmaddubsw:
; SANDY:       # BB#0:
; SANDY-NEXT:    vpmaddubsw %xmm1, %xmm0, %xmm0 # sched: [3:1.00]
; SANDY-NEXT:    vpmaddubsw (%rdi), %xmm0, %xmm0 # sched: [9:1.00]
; SANDY-NEXT:    retq # sched: [1:1.00]
;
; HASWELL-LABEL: test_pmaddubsw:
; HASWELL:       # BB#0:
; HASWELL-NEXT:    vpmaddubsw %xmm1, %xmm0, %xmm0 # sched: [5:1.00]
; HASWELL-NEXT:    vpmaddubsw (%rdi), %xmm0, %xmm0 # sched: [5:1.00]
; HASWELL-NEXT:    retq # sched: [2:1.00]
;
; BTVER2-LABEL: test_pmaddubsw:
; BTVER2:       # BB#0:
; BTVER2-NEXT:    vpmaddubsw %xmm1, %xmm0, %xmm0 # sched: [2:1.00]
; BTVER2-NEXT:    vpmaddubsw (%rdi), %xmm0, %xmm0 # sched: [7:1.00]
; BTVER2-NEXT:    retq # sched: [4:1.00]
;
; ZNVER1-LABEL: test_pmaddubsw:
; ZNVER1:       # BB#0:
; ZNVER1-NEXT:    vpmaddubsw %xmm1, %xmm0, %xmm0 # sched: [4:1.00]
; ZNVER1-NEXT:    vpmaddubsw (%rdi), %xmm0, %xmm0 # sched: [11:1.00]
; ZNVER1-NEXT:    retq # sched: [5:0.50]
  %1 = call <8 x i16> @llvm.x86.ssse3.pmadd.ub.sw.128(<16 x i8> %a0, <16 x i8> %a1)
  %2 = load <16 x i8>, <16 x i8> *%a2, align 16
  %3 = bitcast <8 x i16> %1 to <16 x i8>
  %4 = call <8 x i16> @llvm.x86.ssse3.pmadd.ub.sw.128(<16 x i8> %3, <16 x i8> %2)
  ret <8 x i16> %4
}
declare <8 x i16> @llvm.x86.ssse3.pmadd.ub.sw.128(<16 x i8>, <16 x i8>) nounwind readnone

define <8 x i16> @test_pmulhrsw(<8 x i16> %a0, <8 x i16> %a1, <8 x i16> *%a2) {
; GENERIC-LABEL: test_pmulhrsw:
; GENERIC:       # BB#0:
; GENERIC-NEXT:    pmulhrsw %xmm1, %xmm0 # sched: [3:1.00]
; GENERIC-NEXT:    pmulhrsw (%rdi), %xmm0 # sched: [9:1.00]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; ATOM-LABEL: test_pmulhrsw:
; ATOM:       # BB#0:
; ATOM-NEXT:    pmulhrsw %xmm1, %xmm0 # sched: [5:5.00]
; ATOM-NEXT:    pmulhrsw (%rdi), %xmm0 # sched: [5:5.00]
; ATOM-NEXT:    retq # sched: [79:39.50]
;
; SLM-LABEL: test_pmulhrsw:
; SLM:       # BB#0:
; SLM-NEXT:    pmulhrsw %xmm1, %xmm0 # sched: [4:1.00]
; SLM-NEXT:    pmulhrsw (%rdi), %xmm0 # sched: [7:1.00]
; SLM-NEXT:    retq # sched: [4:1.00]
;
; SANDY-LABEL: test_pmulhrsw:
; SANDY:       # BB#0:
; SANDY-NEXT:    vpmulhrsw %xmm1, %xmm0, %xmm0 # sched: [3:1.00]
; SANDY-NEXT:    vpmulhrsw (%rdi), %xmm0, %xmm0 # sched: [9:1.00]
; SANDY-NEXT:    retq # sched: [1:1.00]
;
; HASWELL-LABEL: test_pmulhrsw:
; HASWELL:       # BB#0:
; HASWELL-NEXT:    vpmulhrsw %xmm1, %xmm0, %xmm0 # sched: [5:1.00]
; HASWELL-NEXT:    vpmulhrsw (%rdi), %xmm0, %xmm0 # sched: [5:1.00]
; HASWELL-NEXT:    retq # sched: [2:1.00]
;
; BTVER2-LABEL: test_pmulhrsw:
; BTVER2:       # BB#0:
; BTVER2-NEXT:    vpmulhrsw %xmm1, %xmm0, %xmm0 # sched: [2:1.00]
; BTVER2-NEXT:    vpmulhrsw (%rdi), %xmm0, %xmm0 # sched: [7:1.00]
; BTVER2-NEXT:    retq # sched: [4:1.00]
;
; ZNVER1-LABEL: test_pmulhrsw:
; ZNVER1:       # BB#0:
; ZNVER1-NEXT:    vpmulhrsw %xmm1, %xmm0, %xmm0 # sched: [4:1.00]
; ZNVER1-NEXT:    vpmulhrsw (%rdi), %xmm0, %xmm0 # sched: [11:1.00]
; ZNVER1-NEXT:    retq # sched: [5:0.50]
  %1 = call <8 x i16> @llvm.x86.ssse3.pmul.hr.sw.128(<8 x i16> %a0, <8 x i16> %a1)
  %2 = load <8 x i16>, <8 x i16> *%a2, align 16
  %3 = call <8 x i16> @llvm.x86.ssse3.pmul.hr.sw.128(<8 x i16> %1, <8 x i16> %2)
  ret <8 x i16> %3
}
declare <8 x i16> @llvm.x86.ssse3.pmul.hr.sw.128(<8 x i16>, <8 x i16>) nounwind readnone

define <16 x i8> @test_pshufb(<16 x i8> %a0, <16 x i8> %a1, <16 x i8> *%a2) {
; GENERIC-LABEL: test_pshufb:
; GENERIC:       # BB#0:
; GENERIC-NEXT:    pshufb %xmm1, %xmm0 # sched: [1:0.50]
; GENERIC-NEXT:    pshufb (%rdi), %xmm0 # sched: [7:0.50]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; ATOM-LABEL: test_pshufb:
; ATOM:       # BB#0:
; ATOM-NEXT:    pshufb %xmm1, %xmm0 # sched: [4:2.00]
; ATOM-NEXT:    pshufb (%rdi), %xmm0 # sched: [5:2.50]
; ATOM-NEXT:    retq # sched: [79:39.50]
;
; SLM-LABEL: test_pshufb:
; SLM:       # BB#0:
; SLM-NEXT:    pshufb %xmm1, %xmm0 # sched: [1:1.00]
; SLM-NEXT:    pshufb (%rdi), %xmm0 # sched: [4:1.00]
; SLM-NEXT:    retq # sched: [4:1.00]
;
; SANDY-LABEL: test_pshufb:
; SANDY:       # BB#0:
; SANDY-NEXT:    vpshufb %xmm1, %xmm0, %xmm0 # sched: [1:0.50]
; SANDY-NEXT:    vpshufb (%rdi), %xmm0, %xmm0 # sched: [7:0.50]
; SANDY-NEXT:    retq # sched: [1:1.00]
;
; HASWELL-LABEL: test_pshufb:
; HASWELL:       # BB#0:
; HASWELL-NEXT:    vpshufb %xmm1, %xmm0, %xmm0 # sched: [1:1.00]
; HASWELL-NEXT:    vpshufb (%rdi), %xmm0, %xmm0 # sched: [1:1.00]
; HASWELL-NEXT:    retq # sched: [2:1.00]
;
; BTVER2-LABEL: test_pshufb:
; BTVER2:       # BB#0:
; BTVER2-NEXT:    vpshufb %xmm1, %xmm0, %xmm0 # sched: [1:0.50]
; BTVER2-NEXT:    vpshufb (%rdi), %xmm0, %xmm0 # sched: [6:1.00]
; BTVER2-NEXT:    retq # sched: [4:1.00]
;
; ZNVER1-LABEL: test_pshufb:
; ZNVER1:       # BB#0:
; ZNVER1-NEXT:    vpshufb %xmm1, %xmm0, %xmm0 # sched: [1:0.25]
; ZNVER1-NEXT:    vpshufb (%rdi), %xmm0, %xmm0 # sched: [8:0.50]
; ZNVER1-NEXT:    retq # sched: [5:0.50]
  %1 = call <16 x i8> @llvm.x86.ssse3.pshuf.b.128(<16 x i8> %a0, <16 x i8> %a1)
  %2 = load <16 x i8>, <16 x i8> *%a2, align 16
  %3 = call <16 x i8> @llvm.x86.ssse3.pshuf.b.128(<16 x i8> %1, <16 x i8> %2)
  ret <16 x i8> %3
}
declare <16 x i8> @llvm.x86.ssse3.pshuf.b.128(<16 x i8>, <16 x i8>) nounwind readnone

define <16 x i8> @test_psignb(<16 x i8> %a0, <16 x i8> %a1, <16 x i8> *%a2) {
; GENERIC-LABEL: test_psignb:
; GENERIC:       # BB#0:
; GENERIC-NEXT:    psignb %xmm1, %xmm0 # sched: [1:0.50]
; GENERIC-NEXT:    psignb (%rdi), %xmm0 # sched: [7:0.50]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; ATOM-LABEL: test_psignb:
; ATOM:       # BB#0:
; ATOM-NEXT:    psignb %xmm1, %xmm0 # sched: [1:0.50]
; ATOM-NEXT:    psignb (%rdi), %xmm0 # sched: [1:1.00]
; ATOM-NEXT:    nop # sched: [1:0.50]
; ATOM-NEXT:    nop # sched: [1:0.50]
; ATOM-NEXT:    nop # sched: [1:0.50]
; ATOM-NEXT:    nop # sched: [1:0.50]
; ATOM-NEXT:    retq # sched: [79:39.50]
;
; SLM-LABEL: test_psignb:
; SLM:       # BB#0:
; SLM-NEXT:    psignb %xmm1, %xmm0 # sched: [1:0.50]
; SLM-NEXT:    psignb (%rdi), %xmm0 # sched: [4:1.00]
; SLM-NEXT:    retq # sched: [4:1.00]
;
; SANDY-LABEL: test_psignb:
; SANDY:       # BB#0:
; SANDY-NEXT:    vpsignb %xmm1, %xmm0, %xmm0 # sched: [1:0.50]
; SANDY-NEXT:    vpsignb (%rdi), %xmm0, %xmm0 # sched: [7:0.50]
; SANDY-NEXT:    retq # sched: [1:1.00]
;
; HASWELL-LABEL: test_psignb:
; HASWELL:       # BB#0:
; HASWELL-NEXT:    vpsignb %xmm1, %xmm0, %xmm0 # sched: [1:0.50]
; HASWELL-NEXT:    vpsignb (%rdi), %xmm0, %xmm0 # sched: [1:0.50]
; HASWELL-NEXT:    retq # sched: [2:1.00]
;
; BTVER2-LABEL: test_psignb:
; BTVER2:       # BB#0:
; BTVER2-NEXT:    vpsignb %xmm1, %xmm0, %xmm0 # sched: [1:0.50]
; BTVER2-NEXT:    vpsignb (%rdi), %xmm0, %xmm0 # sched: [6:1.00]
; BTVER2-NEXT:    retq # sched: [4:1.00]
;
; ZNVER1-LABEL: test_psignb:
; ZNVER1:       # BB#0:
; ZNVER1-NEXT:    vpsignb %xmm1, %xmm0, %xmm0 # sched: [1:0.25]
; ZNVER1-NEXT:    vpsignb (%rdi), %xmm0, %xmm0 # sched: [8:0.50]
; ZNVER1-NEXT:    retq # sched: [5:0.50]
  %1 = call <16 x i8> @llvm.x86.ssse3.psign.b.128(<16 x i8> %a0, <16 x i8> %a1)
  %2 = load <16 x i8>, <16 x i8> *%a2, align 16
  %3 = call <16 x i8> @llvm.x86.ssse3.psign.b.128(<16 x i8> %1, <16 x i8> %2)
  ret <16 x i8> %3
}
declare <16 x i8> @llvm.x86.ssse3.psign.b.128(<16 x i8>, <16 x i8>) nounwind readnone

define <4 x i32> @test_psignd(<4 x i32> %a0, <4 x i32> %a1, <4 x i32> *%a2) {
; GENERIC-LABEL: test_psignd:
; GENERIC:       # BB#0:
; GENERIC-NEXT:    psignd %xmm1, %xmm0 # sched: [1:0.50]
; GENERIC-NEXT:    psignd (%rdi), %xmm0 # sched: [7:0.50]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; ATOM-LABEL: test_psignd:
; ATOM:       # BB#0:
; ATOM-NEXT:    psignd %xmm1, %xmm0 # sched: [1:0.50]
; ATOM-NEXT:    psignd (%rdi), %xmm0 # sched: [1:1.00]
; ATOM-NEXT:    nop # sched: [1:0.50]
; ATOM-NEXT:    nop # sched: [1:0.50]
; ATOM-NEXT:    nop # sched: [1:0.50]
; ATOM-NEXT:    nop # sched: [1:0.50]
; ATOM-NEXT:    retq # sched: [79:39.50]
;
; SLM-LABEL: test_psignd:
; SLM:       # BB#0:
; SLM-NEXT:    psignd %xmm1, %xmm0 # sched: [1:0.50]
; SLM-NEXT:    psignd (%rdi), %xmm0 # sched: [4:1.00]
; SLM-NEXT:    retq # sched: [4:1.00]
;
; SANDY-LABEL: test_psignd:
; SANDY:       # BB#0:
; SANDY-NEXT:    vpsignd %xmm1, %xmm0, %xmm0 # sched: [1:0.50]
; SANDY-NEXT:    vpsignd (%rdi), %xmm0, %xmm0 # sched: [7:0.50]
; SANDY-NEXT:    retq # sched: [1:1.00]
;
; HASWELL-LABEL: test_psignd:
; HASWELL:       # BB#0:
; HASWELL-NEXT:    vpsignd %xmm1, %xmm0, %xmm0 # sched: [1:0.50]
; HASWELL-NEXT:    vpsignd (%rdi), %xmm0, %xmm0 # sched: [1:0.50]
; HASWELL-NEXT:    retq # sched: [2:1.00]
;
; BTVER2-LABEL: test_psignd:
; BTVER2:       # BB#0:
; BTVER2-NEXT:    vpsignd %xmm1, %xmm0, %xmm0 # sched: [1:0.50]
; BTVER2-NEXT:    vpsignd (%rdi), %xmm0, %xmm0 # sched: [6:1.00]
; BTVER2-NEXT:    retq # sched: [4:1.00]
;
; ZNVER1-LABEL: test_psignd:
; ZNVER1:       # BB#0:
; ZNVER1-NEXT:    vpsignd %xmm1, %xmm0, %xmm0 # sched: [1:0.25]
; ZNVER1-NEXT:    vpsignd (%rdi), %xmm0, %xmm0 # sched: [8:0.50]
; ZNVER1-NEXT:    retq # sched: [5:0.50]
  %1 = call <4 x i32> @llvm.x86.ssse3.psign.d.128(<4 x i32> %a0, <4 x i32> %a1)
  %2 = load <4 x i32>, <4 x i32> *%a2, align 16
  %3 = call <4 x i32> @llvm.x86.ssse3.psign.d.128(<4 x i32> %1, <4 x i32> %2)
  ret <4 x i32> %3
}
declare <4 x i32> @llvm.x86.ssse3.psign.d.128(<4 x i32>, <4 x i32>) nounwind readnone

define <8 x i16> @test_psignw(<8 x i16> %a0, <8 x i16> %a1, <8 x i16> *%a2) {
; GENERIC-LABEL: test_psignw:
; GENERIC:       # BB#0:
; GENERIC-NEXT:    psignw %xmm1, %xmm0 # sched: [1:0.50]
; GENERIC-NEXT:    psignw (%rdi), %xmm0 # sched: [7:0.50]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; ATOM-LABEL: test_psignw:
; ATOM:       # BB#0:
; ATOM-NEXT:    psignw %xmm1, %xmm0 # sched: [1:0.50]
; ATOM-NEXT:    psignw (%rdi), %xmm0 # sched: [1:1.00]
; ATOM-NEXT:    nop # sched: [1:0.50]
; ATOM-NEXT:    nop # sched: [1:0.50]
; ATOM-NEXT:    nop # sched: [1:0.50]
; ATOM-NEXT:    nop # sched: [1:0.50]
; ATOM-NEXT:    retq # sched: [79:39.50]
;
; SLM-LABEL: test_psignw:
; SLM:       # BB#0:
; SLM-NEXT:    psignw %xmm1, %xmm0 # sched: [1:0.50]
; SLM-NEXT:    psignw (%rdi), %xmm0 # sched: [4:1.00]
; SLM-NEXT:    retq # sched: [4:1.00]
;
; SANDY-LABEL: test_psignw:
; SANDY:       # BB#0:
; SANDY-NEXT:    vpsignw %xmm1, %xmm0, %xmm0 # sched: [1:0.50]
; SANDY-NEXT:    vpsignw (%rdi), %xmm0, %xmm0 # sched: [7:0.50]
; SANDY-NEXT:    retq # sched: [1:1.00]
;
; HASWELL-LABEL: test_psignw:
; HASWELL:       # BB#0:
; HASWELL-NEXT:    vpsignw %xmm1, %xmm0, %xmm0 # sched: [1:0.50]
; HASWELL-NEXT:    vpsignw (%rdi), %xmm0, %xmm0 # sched: [1:0.50]
; HASWELL-NEXT:    retq # sched: [2:1.00]
;
; BTVER2-LABEL: test_psignw:
; BTVER2:       # BB#0:
; BTVER2-NEXT:    vpsignw %xmm1, %xmm0, %xmm0 # sched: [1:0.50]
; BTVER2-NEXT:    vpsignw (%rdi), %xmm0, %xmm0 # sched: [6:1.00]
; BTVER2-NEXT:    retq # sched: [4:1.00]
;
; ZNVER1-LABEL: test_psignw:
; ZNVER1:       # BB#0:
; ZNVER1-NEXT:    vpsignw %xmm1, %xmm0, %xmm0 # sched: [1:0.25]
; ZNVER1-NEXT:    vpsignw (%rdi), %xmm0, %xmm0 # sched: [8:0.50]
; ZNVER1-NEXT:    retq # sched: [5:0.50]
  %1 = call <8 x i16> @llvm.x86.ssse3.psign.w.128(<8 x i16> %a0, <8 x i16> %a1)
  %2 = load <8 x i16>, <8 x i16> *%a2, align 16
  %3 = call <8 x i16> @llvm.x86.ssse3.psign.w.128(<8 x i16> %1, <8 x i16> %2)
  ret <8 x i16> %3
}
declare <8 x i16> @llvm.x86.ssse3.psign.w.128(<8 x i16>, <8 x i16>) nounwind readnone
