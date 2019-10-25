; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-- -mattr=+popcntd < %s      | FileCheck %s --check-prefixes=ANY,FAST
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-- -mattr=+slow-popcntd < %s | FileCheck %s --check-prefixes=ANY,SLOW

define i16 @zpop_i8_i16(i8 %x) {
; FAST-LABEL: zpop_i8_i16:
; FAST:       # %bb.0:
; FAST-NEXT:    rlwinm 3, 3, 0, 24, 31
; FAST-NEXT:    popcntw 3, 3
; FAST-NEXT:    blr
;
; SLOW-LABEL: zpop_i8_i16:
; SLOW:       # %bb.0:
; SLOW-NEXT:    clrlwi 5, 3, 24
; SLOW-NEXT:    rlwinm 3, 3, 31, 0, 31
; SLOW-NEXT:    andi. 3, 3, 85
; SLOW-NEXT:    lis 4, 13107
; SLOW-NEXT:    subf 3, 3, 5
; SLOW-NEXT:    ori 4, 4, 13107
; SLOW-NEXT:    rotlwi 5, 3, 30
; SLOW-NEXT:    and 3, 3, 4
; SLOW-NEXT:    andis. 4, 5, 13107
; SLOW-NEXT:    andi. 5, 5, 13107
; SLOW-NEXT:    or 4, 5, 4
; SLOW-NEXT:    add 3, 3, 4
; SLOW-NEXT:    lis 5, 3855
; SLOW-NEXT:    srwi 4, 3, 4
; SLOW-NEXT:    add 3, 3, 4
; SLOW-NEXT:    lis 4, 257
; SLOW-NEXT:    ori 5, 5, 3855
; SLOW-NEXT:    and 3, 3, 5
; SLOW-NEXT:    ori 4, 4, 257
; SLOW-NEXT:    mullw 3, 3, 4
; SLOW-NEXT:    srwi 3, 3, 24
; SLOW-NEXT:    blr
  %z = zext i8 %x to i16
  %pop = tail call i16 @llvm.ctpop.i16(i16 %z)
  ret i16 %pop
}

define i16 @popz_i8_i16(i8 %x) {
; FAST-LABEL: popz_i8_i16:
; FAST:       # %bb.0:
; FAST-NEXT:    clrldi 3, 3, 56
; FAST-NEXT:    popcntd 3, 3
; FAST-NEXT:    blr
;
; SLOW-LABEL: popz_i8_i16:
; SLOW:       # %bb.0:
; SLOW-NEXT:    clrlwi 5, 3, 24
; SLOW-NEXT:    rlwinm 3, 3, 31, 0, 31
; SLOW-NEXT:    andi. 3, 3, 85
; SLOW-NEXT:    lis 4, 13107
; SLOW-NEXT:    subf 3, 3, 5
; SLOW-NEXT:    ori 4, 4, 13107
; SLOW-NEXT:    rotlwi 5, 3, 30
; SLOW-NEXT:    and 3, 3, 4
; SLOW-NEXT:    andis. 4, 5, 13107
; SLOW-NEXT:    andi. 5, 5, 13107
; SLOW-NEXT:    or 4, 5, 4
; SLOW-NEXT:    add 3, 3, 4
; SLOW-NEXT:    lis 5, 3855
; SLOW-NEXT:    srwi 4, 3, 4
; SLOW-NEXT:    add 3, 3, 4
; SLOW-NEXT:    lis 4, 257
; SLOW-NEXT:    ori 5, 5, 3855
; SLOW-NEXT:    and 3, 3, 5
; SLOW-NEXT:    ori 4, 4, 257
; SLOW-NEXT:    mullw 3, 3, 4
; SLOW-NEXT:    rlwinm 3, 3, 8, 24, 31
; SLOW-NEXT:    blr
  %pop = tail call i8 @llvm.ctpop.i8(i8 %x)
  %z = zext i8 %pop to i16
  ret i16 %z
}

define i32 @zpop_i8_i32(i8 %x) {
; FAST-LABEL: zpop_i8_i32:
; FAST:       # %bb.0:
; FAST-NEXT:    rlwinm 3, 3, 0, 24, 31
; FAST-NEXT:    popcntw 3, 3
; FAST-NEXT:    blr
;
; SLOW-LABEL: zpop_i8_i32:
; SLOW:       # %bb.0:
; SLOW-NEXT:    clrlwi 5, 3, 24
; SLOW-NEXT:    rlwinm 3, 3, 31, 0, 31
; SLOW-NEXT:    andi. 3, 3, 85
; SLOW-NEXT:    lis 4, 13107
; SLOW-NEXT:    subf 3, 3, 5
; SLOW-NEXT:    ori 4, 4, 13107
; SLOW-NEXT:    rotlwi 5, 3, 30
; SLOW-NEXT:    and 3, 3, 4
; SLOW-NEXT:    andis. 4, 5, 13107
; SLOW-NEXT:    andi. 5, 5, 13107
; SLOW-NEXT:    or 4, 5, 4
; SLOW-NEXT:    add 3, 3, 4
; SLOW-NEXT:    lis 5, 3855
; SLOW-NEXT:    srwi 4, 3, 4
; SLOW-NEXT:    add 3, 3, 4
; SLOW-NEXT:    lis 4, 257
; SLOW-NEXT:    ori 5, 5, 3855
; SLOW-NEXT:    and 3, 3, 5
; SLOW-NEXT:    ori 4, 4, 257
; SLOW-NEXT:    mullw 3, 3, 4
; SLOW-NEXT:    srwi 3, 3, 24
; SLOW-NEXT:    blr
  %z = zext i8 %x to i32
  %pop = tail call i32 @llvm.ctpop.i32(i32 %z)
  ret i32 %pop
}

define i32 @popz_i8_32(i8 %x) {
; FAST-LABEL: popz_i8_32:
; FAST:       # %bb.0:
; FAST-NEXT:    clrldi 3, 3, 56
; FAST-NEXT:    popcntd 3, 3
; FAST-NEXT:    blr
;
; SLOW-LABEL: popz_i8_32:
; SLOW:       # %bb.0:
; SLOW-NEXT:    clrlwi 5, 3, 24
; SLOW-NEXT:    rlwinm 3, 3, 31, 0, 31
; SLOW-NEXT:    andi. 3, 3, 85
; SLOW-NEXT:    lis 4, 13107
; SLOW-NEXT:    subf 3, 3, 5
; SLOW-NEXT:    ori 4, 4, 13107
; SLOW-NEXT:    rotlwi 5, 3, 30
; SLOW-NEXT:    and 3, 3, 4
; SLOW-NEXT:    andis. 4, 5, 13107
; SLOW-NEXT:    andi. 5, 5, 13107
; SLOW-NEXT:    or 4, 5, 4
; SLOW-NEXT:    add 3, 3, 4
; SLOW-NEXT:    lis 5, 3855
; SLOW-NEXT:    srwi 4, 3, 4
; SLOW-NEXT:    add 3, 3, 4
; SLOW-NEXT:    lis 4, 257
; SLOW-NEXT:    ori 5, 5, 3855
; SLOW-NEXT:    and 3, 3, 5
; SLOW-NEXT:    ori 4, 4, 257
; SLOW-NEXT:    mullw 3, 3, 4
; SLOW-NEXT:    rlwinm 3, 3, 8, 24, 31
; SLOW-NEXT:    blr
  %pop = tail call i8 @llvm.ctpop.i8(i8 %x)
  %z = zext i8 %pop to i32
  ret i32 %z
}

define i32 @zpop_i16_i32(i16 %x) {
; FAST-LABEL: zpop_i16_i32:
; FAST:       # %bb.0:
; FAST-NEXT:    rlwinm 3, 3, 0, 16, 31
; FAST-NEXT:    popcntw 3, 3
; FAST-NEXT:    blr
;
; SLOW-LABEL: zpop_i16_i32:
; SLOW:       # %bb.0:
; SLOW-NEXT:    clrlwi 5, 3, 16
; SLOW-NEXT:    rlwinm 3, 3, 31, 0, 31
; SLOW-NEXT:    andi. 3, 3, 21845
; SLOW-NEXT:    lis 4, 13107
; SLOW-NEXT:    subf 3, 3, 5
; SLOW-NEXT:    ori 4, 4, 13107
; SLOW-NEXT:    rotlwi 5, 3, 30
; SLOW-NEXT:    and 3, 3, 4
; SLOW-NEXT:    andis. 4, 5, 13107
; SLOW-NEXT:    andi. 5, 5, 13107
; SLOW-NEXT:    or 4, 5, 4
; SLOW-NEXT:    add 3, 3, 4
; SLOW-NEXT:    lis 5, 3855
; SLOW-NEXT:    srwi 4, 3, 4
; SLOW-NEXT:    add 3, 3, 4
; SLOW-NEXT:    lis 4, 257
; SLOW-NEXT:    ori 5, 5, 3855
; SLOW-NEXT:    and 3, 3, 5
; SLOW-NEXT:    ori 4, 4, 257
; SLOW-NEXT:    mullw 3, 3, 4
; SLOW-NEXT:    srwi 3, 3, 24
; SLOW-NEXT:    blr
  %z = zext i16 %x to i32
  %pop = tail call i32 @llvm.ctpop.i32(i32 %z)
  ret i32 %pop
}

define i32 @popz_i16_32(i16 %x) {
; FAST-LABEL: popz_i16_32:
; FAST:       # %bb.0:
; FAST-NEXT:    clrldi 3, 3, 48
; FAST-NEXT:    popcntd 3, 3
; FAST-NEXT:    blr
;
; SLOW-LABEL: popz_i16_32:
; SLOW:       # %bb.0:
; SLOW-NEXT:    clrlwi 5, 3, 16
; SLOW-NEXT:    rlwinm 3, 3, 31, 0, 31
; SLOW-NEXT:    andi. 3, 3, 21845
; SLOW-NEXT:    lis 4, 13107
; SLOW-NEXT:    subf 3, 3, 5
; SLOW-NEXT:    ori 4, 4, 13107
; SLOW-NEXT:    rotlwi 5, 3, 30
; SLOW-NEXT:    and 3, 3, 4
; SLOW-NEXT:    andis. 4, 5, 13107
; SLOW-NEXT:    andi. 5, 5, 13107
; SLOW-NEXT:    or 4, 5, 4
; SLOW-NEXT:    add 3, 3, 4
; SLOW-NEXT:    lis 5, 3855
; SLOW-NEXT:    srwi 4, 3, 4
; SLOW-NEXT:    add 3, 3, 4
; SLOW-NEXT:    lis 4, 257
; SLOW-NEXT:    ori 5, 5, 3855
; SLOW-NEXT:    and 3, 3, 5
; SLOW-NEXT:    ori 4, 4, 257
; SLOW-NEXT:    mullw 3, 3, 4
; SLOW-NEXT:    rlwinm 3, 3, 8, 24, 31
; SLOW-NEXT:    blr
  %pop = tail call i16 @llvm.ctpop.i16(i16 %x)
  %z = zext i16 %pop to i32
  ret i32 %z
}

define i64 @zpop_i32_i64(i32 %x) {
; FAST-LABEL: zpop_i32_i64:
; FAST:       # %bb.0:
; FAST-NEXT:    clrldi 3, 3, 32
; FAST-NEXT:    popcntd 3, 3
; FAST-NEXT:    blr
;
; SLOW-LABEL: zpop_i32_i64:
; SLOW:       # %bb.0:
; SLOW-NEXT:    rlwinm 5, 3, 31, 1, 0
; SLOW-NEXT:    lis 4, 13107
; SLOW-NEXT:    andis. 6, 5, 21845
; SLOW-NEXT:    andi. 5, 5, 21845
; SLOW-NEXT:    ori 4, 4, 13107
; SLOW-NEXT:    or 5, 5, 6
; SLOW-NEXT:    clrldi 3, 3, 32
; SLOW-NEXT:    rldimi 4, 4, 32, 0
; SLOW-NEXT:    sub 3, 3, 5
; SLOW-NEXT:    and 5, 3, 4
; SLOW-NEXT:    rotldi 3, 3, 62
; SLOW-NEXT:    and 3, 3, 4
; SLOW-NEXT:    add 3, 5, 3
; SLOW-NEXT:    lis 4, 3855
; SLOW-NEXT:    rldicl 5, 3, 60, 4
; SLOW-NEXT:    ori 4, 4, 3855
; SLOW-NEXT:    add 3, 3, 5
; SLOW-NEXT:    lis 5, 257
; SLOW-NEXT:    rldimi 4, 4, 32, 0
; SLOW-NEXT:    ori 5, 5, 257
; SLOW-NEXT:    and 3, 3, 4
; SLOW-NEXT:    rldimi 5, 5, 32, 0
; SLOW-NEXT:    mulld 3, 3, 5
; SLOW-NEXT:    rldicl 3, 3, 8, 56
; SLOW-NEXT:    blr
  %z = zext i32 %x to i64
  %pop = tail call i64 @llvm.ctpop.i64(i64 %z)
  ret i64 %pop
}

define i64 @popz_i32_i64(i32 %x) {
; FAST-LABEL: popz_i32_i64:
; FAST:       # %bb.0:
; FAST-NEXT:    popcntw 3, 3
; FAST-NEXT:    clrldi 3, 3, 32
; FAST-NEXT:    blr
;
; SLOW-LABEL: popz_i32_i64:
; SLOW:       # %bb.0:
; SLOW-NEXT:    rotlwi 5, 3, 31
; SLOW-NEXT:    andis. 6, 5, 21845
; SLOW-NEXT:    andi. 5, 5, 21845
; SLOW-NEXT:    or 5, 5, 6
; SLOW-NEXT:    lis 4, 13107
; SLOW-NEXT:    subf 3, 5, 3
; SLOW-NEXT:    ori 4, 4, 13107
; SLOW-NEXT:    rotlwi 5, 3, 30
; SLOW-NEXT:    and 3, 3, 4
; SLOW-NEXT:    andis. 4, 5, 13107
; SLOW-NEXT:    andi. 5, 5, 13107
; SLOW-NEXT:    or 4, 5, 4
; SLOW-NEXT:    add 3, 3, 4
; SLOW-NEXT:    lis 5, 3855
; SLOW-NEXT:    srwi 4, 3, 4
; SLOW-NEXT:    add 3, 3, 4
; SLOW-NEXT:    lis 4, 257
; SLOW-NEXT:    ori 5, 5, 3855
; SLOW-NEXT:    and 3, 3, 5
; SLOW-NEXT:    ori 4, 4, 257
; SLOW-NEXT:    mullw 3, 3, 4
; SLOW-NEXT:    rlwinm 3, 3, 8, 24, 31
; SLOW-NEXT:    blr
  %pop = tail call i32 @llvm.ctpop.i32(i32 %x)
  %z = zext i32 %pop to i64
  ret i64 %z
}

define i64 @popa_i16_i64(i16 %x) {
; FAST-LABEL: popa_i16_i64:
; FAST:       # %bb.0:
; FAST-NEXT:    rlwinm 3, 3, 0, 16, 31
; FAST-NEXT:    popcntw 3, 3
; FAST-NEXT:    andi. 3, 3, 16
; FAST-NEXT:    blr
;
; SLOW-LABEL: popa_i16_i64:
; SLOW:       # %bb.0:
; SLOW-NEXT:    clrlwi 5, 3, 16
; SLOW-NEXT:    rlwinm 3, 3, 31, 0, 31
; SLOW-NEXT:    andi. 3, 3, 21845
; SLOW-NEXT:    lis 4, 13107
; SLOW-NEXT:    subf 3, 3, 5
; SLOW-NEXT:    ori 4, 4, 13107
; SLOW-NEXT:    rotlwi 5, 3, 30
; SLOW-NEXT:    and 3, 3, 4
; SLOW-NEXT:    andis. 4, 5, 13107
; SLOW-NEXT:    andi. 5, 5, 13107
; SLOW-NEXT:    or 4, 5, 4
; SLOW-NEXT:    add 3, 3, 4
; SLOW-NEXT:    lis 5, 3855
; SLOW-NEXT:    srwi 4, 3, 4
; SLOW-NEXT:    add 3, 3, 4
; SLOW-NEXT:    lis 4, 257
; SLOW-NEXT:    ori 5, 5, 3855
; SLOW-NEXT:    and 3, 3, 5
; SLOW-NEXT:    ori 4, 4, 257
; SLOW-NEXT:    mullw 3, 3, 4
; SLOW-NEXT:    srwi 3, 3, 24
; SLOW-NEXT:    andi. 3, 3, 16
; SLOW-NEXT:    blr
  %pop = call i16 @llvm.ctpop.i16(i16 %x)
  %z = zext i16 %pop to i64 ; SimplifyDemandedBits may turn zext (or sext) into aext
  %a = and i64 %z, 16
  ret i64 %a
}

declare i8 @llvm.ctpop.i8(i8) nounwind readnone
declare i16 @llvm.ctpop.i16(i16) nounwind readnone
declare i32 @llvm.ctpop.i32(i32) nounwind readnone
declare i64 @llvm.ctpop.i64(i64) nounwind readnone
