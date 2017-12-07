; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=x86-64 -mattr=+rdseed | FileCheck %s --check-prefix=CHECK --check-prefix=GENERIC
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=goldmont | FileCheck %s --check-prefix=CHECK --check-prefix=GOLDMONT
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=broadwell | FileCheck %s --check-prefix=CHECK --check-prefix=BROADWELL
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=skylake | FileCheck %s --check-prefix=CHECK --check-prefix=SKYLAKE
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=skx | FileCheck %s --check-prefix=CHECK --check-prefix=SKX
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=znver1 | FileCheck %s --check-prefix=CHECK --check-prefix=ZNVER1

declare {i16, i32} @llvm.x86.rdseed.16()
declare {i32, i32} @llvm.x86.rdseed.32()
declare {i64, i32} @llvm.x86.rdseed.64()

define i16 @test_rdseed_16(i16* %random_val) {
; GENERIC-LABEL: test_rdseed_16:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    rdseedw %ax
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; GOLDMONT-LABEL: test_rdseed_16:
; GOLDMONT:       # %bb.0:
; GOLDMONT-NEXT:    rdseedw %ax
; GOLDMONT-NEXT:    retq # sched: [4:1.00]
;
; BROADWELL-LABEL: test_rdseed_16:
; BROADWELL:       # %bb.0:
; BROADWELL-NEXT:    rdseedw %ax
; BROADWELL-NEXT:    retq # sched: [7:1.00]
;
; SKYLAKE-LABEL: test_rdseed_16:
; SKYLAKE:       # %bb.0:
; SKYLAKE-NEXT:    rdseedw %ax
; SKYLAKE-NEXT:    retq # sched: [7:1.00]
;
; SKX-LABEL: test_rdseed_16:
; SKX:       # %bb.0:
; SKX-NEXT:    rdseedw %ax
; SKX-NEXT:    retq # sched: [7:1.00]
;
; ZNVER1-LABEL: test_rdseed_16:
; ZNVER1:       # %bb.0:
; ZNVER1-NEXT:    rdseedw %ax
; ZNVER1-NEXT:    retq # sched: [1:0.50]
  %call = call {i16, i32} @llvm.x86.rdseed.16()
  %randval = extractvalue {i16, i32} %call, 0
  ret i16 %randval
}

define i32 @test_rdseed_32(i16* %random_val) {
; GENERIC-LABEL: test_rdseed_32:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    rdseedl %eax
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; GOLDMONT-LABEL: test_rdseed_32:
; GOLDMONT:       # %bb.0:
; GOLDMONT-NEXT:    rdseedl %eax
; GOLDMONT-NEXT:    retq # sched: [4:1.00]
;
; BROADWELL-LABEL: test_rdseed_32:
; BROADWELL:       # %bb.0:
; BROADWELL-NEXT:    rdseedl %eax
; BROADWELL-NEXT:    retq # sched: [7:1.00]
;
; SKYLAKE-LABEL: test_rdseed_32:
; SKYLAKE:       # %bb.0:
; SKYLAKE-NEXT:    rdseedl %eax
; SKYLAKE-NEXT:    retq # sched: [7:1.00]
;
; SKX-LABEL: test_rdseed_32:
; SKX:       # %bb.0:
; SKX-NEXT:    rdseedl %eax
; SKX-NEXT:    retq # sched: [7:1.00]
;
; ZNVER1-LABEL: test_rdseed_32:
; ZNVER1:       # %bb.0:
; ZNVER1-NEXT:    rdseedl %eax
; ZNVER1-NEXT:    retq # sched: [1:0.50]
  %call = call {i32, i32} @llvm.x86.rdseed.32()
  %randval = extractvalue {i32, i32} %call, 0
  ret i32 %randval
}

define i64 @test_rdseed_64(i64* %random_val) {
; GENERIC-LABEL: test_rdseed_64:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    rdseedq %rax
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; GOLDMONT-LABEL: test_rdseed_64:
; GOLDMONT:       # %bb.0:
; GOLDMONT-NEXT:    rdseedq %rax
; GOLDMONT-NEXT:    retq # sched: [4:1.00]
;
; BROADWELL-LABEL: test_rdseed_64:
; BROADWELL:       # %bb.0:
; BROADWELL-NEXT:    rdseedq %rax
; BROADWELL-NEXT:    retq # sched: [7:1.00]
;
; SKYLAKE-LABEL: test_rdseed_64:
; SKYLAKE:       # %bb.0:
; SKYLAKE-NEXT:    rdseedq %rax
; SKYLAKE-NEXT:    retq # sched: [7:1.00]
;
; SKX-LABEL: test_rdseed_64:
; SKX:       # %bb.0:
; SKX-NEXT:    rdseedq %rax
; SKX-NEXT:    retq # sched: [7:1.00]
;
; ZNVER1-LABEL: test_rdseed_64:
; ZNVER1:       # %bb.0:
; ZNVER1-NEXT:    rdseedq %rax
; ZNVER1-NEXT:    retq # sched: [1:0.50]
  %call = call {i64, i32} @llvm.x86.rdseed.64()
  %randval = extractvalue {i64, i32} %call, 0
  ret i64 %randval
}
