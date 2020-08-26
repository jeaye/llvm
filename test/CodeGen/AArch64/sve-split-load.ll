; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-linux-gnu -mattr=+sve < %s 2>%t | FileCheck %s
; RUN: FileCheck --check-prefix=WARN --allow-empty %s <%t

; If this check fails please read test/CodeGen/AArch64/README for instructions on how to resolve it.
; WARN-NOT: warning

; UNPREDICATED

define <vscale x 4 x i16> @load_promote_4i16(<vscale x 4 x i16>* %a) {
; CHECK-LABEL: load_promote_4i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    ld1h { z0.s }, p0/z, [x0]
; CHECK-NEXT:    ret
  %load = load <vscale x 4 x i16>, <vscale x 4 x i16>* %a
  ret <vscale x 4 x i16> %load
}

define <vscale x 16 x i16> @load_split_i16(<vscale x 16 x i16>* %a) {
; CHECK-LABEL: load_split_i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h
; CHECK-NEXT:    ld1h { z0.h }, p0/z, [x0]
; CHECK-NEXT:    ld1h { z1.h }, p0/z, [x0, #1, mul vl]
; CHECK-NEXT:    ret
  %load = load <vscale x 16 x i16>, <vscale x 16 x i16>* %a
  ret <vscale x 16 x i16> %load
}

define <vscale x 24 x i16> @load_split_24i16(<vscale x 24 x i16>* %a) {
; CHECK-LABEL: load_split_24i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h
; CHECK-NEXT:    ld1h { z0.h }, p0/z, [x0]
; CHECK-NEXT:    ld1h { z1.h }, p0/z, [x0, #1, mul vl]
; CHECK-NEXT:    ld1h { z2.h }, p0/z, [x0, #2, mul vl]
; CHECK-NEXT:    ret
  %load = load <vscale x 24 x i16>, <vscale x 24 x i16>* %a
  ret <vscale x 24 x i16> %load
}

define <vscale x 32 x i16> @load_split_32i16(<vscale x 32 x i16>* %a) {
; CHECK-LABEL: load_split_32i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h
; CHECK-NEXT:    ld1h { z0.h }, p0/z, [x0]
; CHECK-NEXT:    ld1h { z1.h }, p0/z, [x0, #1, mul vl]
; CHECK-NEXT:    ld1h { z2.h }, p0/z, [x0, #2, mul vl]
; CHECK-NEXT:    ld1h { z3.h }, p0/z, [x0, #3, mul vl]
; CHECK-NEXT:    ret
  %load = load <vscale x 32 x i16>, <vscale x 32 x i16>* %a
  ret <vscale x 32 x i16> %load
}

define <vscale x 16 x i64> @load_split_16i64(<vscale x 16 x i64>* %a) {
; CHECK-LABEL: load_split_16i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    ld1d { z0.d }, p0/z, [x0]
; CHECK-NEXT:    ld1d { z1.d }, p0/z, [x0, #1, mul vl]
; CHECK-NEXT:    ld1d { z2.d }, p0/z, [x0, #2, mul vl]
; CHECK-NEXT:    ld1d { z3.d }, p0/z, [x0, #3, mul vl]
; CHECK-NEXT:    ld1d { z4.d }, p0/z, [x0, #4, mul vl]
; CHECK-NEXT:    ld1d { z5.d }, p0/z, [x0, #5, mul vl]
; CHECK-NEXT:    ld1d { z6.d }, p0/z, [x0, #6, mul vl]
; CHECK-NEXT:    ld1d { z7.d }, p0/z, [x0, #7, mul vl]
; CHECK-NEXT:    ret
  %load = load <vscale x 16 x i64>, <vscale x 16 x i64>* %a
  ret <vscale x 16 x i64> %load
}

; MASKED

define <vscale x 2 x i32> @masked_load_promote_2i32(<vscale x 2 x i32> *%a, <vscale x 2 x i1> %pg) {
; CHECK-LABEL: masked_load_promote_2i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ld1sw { z0.d }, p0/z, [x0]
; CHECK-NEXT:    ret
  %load = call <vscale x 2 x i32> @llvm.masked.load.nxv2i32(<vscale x 2 x i32> *%a, i32 1, <vscale x 2 x i1> %pg, <vscale x 2 x i32> undef)
  ret <vscale x 2 x i32> %load
}

define <vscale x 32 x i8> @masked_load_split_32i8(<vscale x 32 x i8> *%a, <vscale x 32 x i1> %pg) {
; CHECK-LABEL: masked_load_split_32i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ld1b { z0.b }, p0/z, [x0]
; CHECK-NEXT:    ld1b { z1.b }, p1/z, [x0, #1, mul vl]
; CHECK-NEXT:    ret
  %load = call <vscale x 32 x i8> @llvm.masked.load.nxv32i8(<vscale x 32 x i8> *%a, i32 1, <vscale x 32 x i1> %pg, <vscale x 32 x i8> undef)
  ret <vscale x 32 x i8> %load
}

define <vscale x 32 x i16> @masked_load_split_32i16(<vscale x 32 x i16> *%a, <vscale x 32 x i1> %pg) {
; CHECK-LABEL: masked_load_split_32i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    pfalse p2.b
; CHECK-NEXT:    zip1 p3.b, p0.b, p2.b
; CHECK-NEXT:    zip2 p0.b, p0.b, p2.b
; CHECK-NEXT:    ld1h { z0.h }, p3/z, [x0]
; CHECK-NEXT:    zip1 p3.b, p1.b, p2.b
; CHECK-NEXT:    ld1h { z1.h }, p0/z, [x0, #1, mul vl]
; CHECK-NEXT:    zip2 p0.b, p1.b, p2.b
; CHECK-NEXT:    ld1h { z2.h }, p3/z, [x0, #2, mul vl]
; CHECK-NEXT:    ld1h { z3.h }, p0/z, [x0, #3, mul vl]
; CHECK-NEXT:    ret
  %load = call <vscale x 32 x i16> @llvm.masked.load.nxv32i16(<vscale x 32 x i16> *%a, i32 1, <vscale x 32 x i1> %pg, <vscale x 32 x i16> undef)
  ret <vscale x 32 x i16> %load
}

define <vscale x 8 x i32> @masked_load_split_8i32(<vscale x 8 x i32> *%a, <vscale x 8 x i1> %pg) {
; CHECK-LABEL: masked_load_split_8i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    pfalse p1.b
; CHECK-NEXT:    zip1 p2.h, p0.h, p1.h
; CHECK-NEXT:    zip2 p0.h, p0.h, p1.h
; CHECK-NEXT:    ld1w { z0.s }, p2/z, [x0]
; CHECK-NEXT:    ld1w { z1.s }, p0/z, [x0, #1, mul vl]
; CHECK-NEXT:    ret
  %load = call <vscale x 8 x i32> @llvm.masked.load.nxv8i32(<vscale x 8 x i32> *%a, i32 1, <vscale x 8 x i1> %pg, <vscale x 8 x i32> undef)
  ret <vscale x 8 x i32> %load
}

define <vscale x 8 x i64> @masked_load_split_8i64(<vscale x 8 x i64> *%a, <vscale x 8 x i1> %pg) {
; CHECK-LABEL: masked_load_split_8i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    pfalse p1.b
; CHECK-NEXT:    zip1 p2.h, p0.h, p1.h
; CHECK-NEXT:    zip2 p0.h, p0.h, p1.h
; CHECK-NEXT:    zip1 p3.s, p2.s, p1.s
; CHECK-NEXT:    zip2 p2.s, p2.s, p1.s
; CHECK-NEXT:    ld1d { z0.d }, p3/z, [x0]
; CHECK-NEXT:    ld1d { z1.d }, p2/z, [x0, #1, mul vl]
; CHECK-NEXT:    zip1 p2.s, p0.s, p1.s
; CHECK-NEXT:    zip2 p0.s, p0.s, p1.s
; CHECK-NEXT:    ld1d { z2.d }, p2/z, [x0, #2, mul vl]
; CHECK-NEXT:    ld1d { z3.d }, p0/z, [x0, #3, mul vl]
; CHECK-NEXT:    ret
  %load = call <vscale x 8 x i64> @llvm.masked.load.nxv8i64(<vscale x 8 x i64> *%a, i32 1, <vscale x 8 x i1> %pg, <vscale x 8 x i64> undef)
  ret <vscale x 8 x i64> %load
}

declare <vscale x 32 x i8> @llvm.masked.load.nxv32i8(<vscale x 32 x i8>*, i32, <vscale x 32 x i1>, <vscale x 32 x i8>)

declare <vscale x 32 x i16> @llvm.masked.load.nxv32i16(<vscale x 32 x i16>*, i32, <vscale x 32 x i1>, <vscale x 32 x i16>)

declare <vscale x 2 x i32> @llvm.masked.load.nxv2i32(<vscale x 2 x i32>*, i32, <vscale x 2 x i1>, <vscale x 2 x i32>)
declare <vscale x 8 x i32> @llvm.masked.load.nxv8i32(<vscale x 8 x i32>*, i32, <vscale x 8 x i1>, <vscale x 8 x i32>)

declare <vscale x 8 x i64> @llvm.masked.load.nxv8i64(<vscale x 8 x i64>*, i32, <vscale x 8 x i1>, <vscale x 8 x i64>)
