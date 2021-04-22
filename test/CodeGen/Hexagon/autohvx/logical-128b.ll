; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -march=hexagon < %s | FileCheck %s

declare <128 x i1> @llvm.hexagon.V6.vandvrt.128B(<32 x i32>, i32) #0
declare <32 x i32> @llvm.hexagon.V6.vandqrt.128B(<128 x i1>, i32) #0
declare <32 x i1> @llvm.hexagon.V6.pred.typecast.128B.v32i1.v128i1(<128 x i1>) #0
declare <128 x i1> @llvm.hexagon.V6.pred.typecast.128B.v128i1.v32i1(<32 x i1>) #0
declare <64 x i1> @llvm.hexagon.V6.pred.typecast.128B.v64i1.v128i1(<128 x i1>) #0
declare <128 x i1> @llvm.hexagon.V6.pred.typecast.128B.v128i1.v64i1(<64 x i1>) #0

define <32 x i32> @f0(<32 x i32> %a0, <32 x i32> %a1) #1 {
; CHECK-LABEL: f0:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = #-1
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     q0 = vand(v0,r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     q1 = vand(v1,r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     q0 = and(q0,q1)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = vand(q0,r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = call <128 x i1> @llvm.hexagon.V6.vandvrt.128B(<32 x i32> %a0, i32 -1)
  %v1 = call <32 x i1> @llvm.hexagon.V6.pred.typecast.128B.v32i1.v128i1(<128 x i1> %v0)
  %v2 = call <128 x i1> @llvm.hexagon.V6.vandvrt.128B(<32 x i32> %a1, i32 -1)
  %v3 = call <32 x i1> @llvm.hexagon.V6.pred.typecast.128B.v32i1.v128i1(<128 x i1> %v2)
  %v4 = and <32 x i1> %v1, %v3
  %v5 = call <128 x i1> @llvm.hexagon.V6.pred.typecast.128B.v128i1.v32i1(<32 x i1> %v4)
  %v6 = call <32 x i32> @llvm.hexagon.V6.vandqrt.128B(<128 x i1> %v5, i32 -1)
  ret <32 x i32> %v6
}

define <32 x i32> @f1(<32 x i32> %a0, <32 x i32> %a1) #1 {
; CHECK-LABEL: f1:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = #-1
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     q0 = vand(v0,r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     q1 = vand(v1,r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     q0 = or(q0,q1)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = vand(q0,r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = call <128 x i1> @llvm.hexagon.V6.vandvrt.128B(<32 x i32> %a0, i32 -1)
  %v1 = call <32 x i1> @llvm.hexagon.V6.pred.typecast.128B.v32i1.v128i1(<128 x i1> %v0)
  %v2 = call <128 x i1> @llvm.hexagon.V6.vandvrt.128B(<32 x i32> %a1, i32 -1)
  %v3 = call <32 x i1> @llvm.hexagon.V6.pred.typecast.128B.v32i1.v128i1(<128 x i1> %v2)
  %v4 = or <32 x i1> %v1, %v3
  %v5 = call <128 x i1> @llvm.hexagon.V6.pred.typecast.128B.v128i1.v32i1(<32 x i1> %v4)
  %v6 = call <32 x i32> @llvm.hexagon.V6.vandqrt.128B(<128 x i1> %v5, i32 -1)
  ret <32 x i32> %v6
}

define <32 x i32> @f2(<32 x i32> %a0, <32 x i32> %a1) #1 {
; CHECK-LABEL: f2:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = #-1
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     q0 = vand(v0,r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     q1 = vand(v1,r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     q0 = xor(q0,q1)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = vand(q0,r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = call <128 x i1> @llvm.hexagon.V6.vandvrt.128B(<32 x i32> %a0, i32 -1)
  %v1 = call <32 x i1> @llvm.hexagon.V6.pred.typecast.128B.v32i1.v128i1(<128 x i1> %v0)
  %v2 = call <128 x i1> @llvm.hexagon.V6.vandvrt.128B(<32 x i32> %a1, i32 -1)
  %v3 = call <32 x i1> @llvm.hexagon.V6.pred.typecast.128B.v32i1.v128i1(<128 x i1> %v2)
  %v4 = xor <32 x i1> %v1, %v3
  %v5 = call <128 x i1> @llvm.hexagon.V6.pred.typecast.128B.v128i1.v32i1(<32 x i1> %v4)
  %v6 = call <32 x i32> @llvm.hexagon.V6.vandqrt.128B(<128 x i1> %v5, i32 -1)
  ret <32 x i32> %v6
}

define <32 x i32> @f3(<32 x i32> %a0, <32 x i32> %a1) #1 {
; CHECK-LABEL: f3:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = #-1
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     q0 = vand(v0,r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     q1 = vand(v1,r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     q0 = and(q0,!q1)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = vand(q0,r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = call <128 x i1> @llvm.hexagon.V6.vandvrt.128B(<32 x i32> %a0, i32 -1)
  %v1 = call <32 x i1> @llvm.hexagon.V6.pred.typecast.128B.v32i1.v128i1(<128 x i1> %v0)
  %v2 = call <128 x i1> @llvm.hexagon.V6.vandvrt.128B(<32 x i32> %a1, i32 -1)
  %v3 = call <32 x i1> @llvm.hexagon.V6.pred.typecast.128B.v32i1.v128i1(<128 x i1> %v2)
  %v4 = xor <32 x i1> %v3, <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>
  %v5 = and <32 x i1> %v1, %v4
  %v6 = call <128 x i1> @llvm.hexagon.V6.pred.typecast.128B.v128i1.v32i1(<32 x i1> %v5)
  %v7 = call <32 x i32> @llvm.hexagon.V6.vandqrt.128B(<128 x i1> %v6, i32 -1)
  ret <32 x i32> %v7
}

define <32 x i32> @f4(<32 x i32> %a0, <32 x i32> %a1) #1 {
; CHECK-LABEL: f4:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = #-1
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     q0 = vand(v0,r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     q1 = vand(v1,r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     q0 = or(q0,!q1)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = vand(q0,r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = call <128 x i1> @llvm.hexagon.V6.vandvrt.128B(<32 x i32> %a0, i32 -1)
  %v1 = call <32 x i1> @llvm.hexagon.V6.pred.typecast.128B.v32i1.v128i1(<128 x i1> %v0)
  %v2 = call <128 x i1> @llvm.hexagon.V6.vandvrt.128B(<32 x i32> %a1, i32 -1)
  %v3 = call <32 x i1> @llvm.hexagon.V6.pred.typecast.128B.v32i1.v128i1(<128 x i1> %v2)
  %v4 = xor <32 x i1> %v3, <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>
  %v5 = or <32 x i1> %v1, %v4
  %v6 = call <128 x i1> @llvm.hexagon.V6.pred.typecast.128B.v128i1.v32i1(<32 x i1> %v5)
  %v7 = call <32 x i32> @llvm.hexagon.V6.vandqrt.128B(<128 x i1> %v6, i32 -1)
  ret <32 x i32> %v7
}

define <32 x i32> @f5(<32 x i32> %a0, <32 x i32> %a1) #1 {
; CHECK-LABEL: f5:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = #-1
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     q0 = vand(v0,r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     q1 = vand(v1,r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     q0 = and(q0,q1)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = vand(q0,r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = call <128 x i1> @llvm.hexagon.V6.vandvrt.128B(<32 x i32> %a0, i32 -1)
  %v1 = call <64 x i1> @llvm.hexagon.V6.pred.typecast.128B.v64i1.v128i1(<128 x i1> %v0)
  %v2 = call <128 x i1> @llvm.hexagon.V6.vandvrt.128B(<32 x i32> %a1, i32 -1)
  %v3 = call <64 x i1> @llvm.hexagon.V6.pred.typecast.128B.v64i1.v128i1(<128 x i1> %v2)
  %v4 = and <64 x i1> %v1, %v3
  %v5 = call <128 x i1> @llvm.hexagon.V6.pred.typecast.128B.v128i1.v64i1(<64 x i1> %v4)
  %v6 = call <32 x i32> @llvm.hexagon.V6.vandqrt.128B(<128 x i1> %v5, i32 -1)
  ret <32 x i32> %v6
}

define <32 x i32> @f6(<32 x i32> %a0, <32 x i32> %a1) #1 {
; CHECK-LABEL: f6:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = #-1
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     q0 = vand(v0,r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     q1 = vand(v1,r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     q0 = or(q0,q1)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = vand(q0,r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = call <128 x i1> @llvm.hexagon.V6.vandvrt.128B(<32 x i32> %a0, i32 -1)
  %v1 = call <64 x i1> @llvm.hexagon.V6.pred.typecast.128B.v64i1.v128i1(<128 x i1> %v0)
  %v2 = call <128 x i1> @llvm.hexagon.V6.vandvrt.128B(<32 x i32> %a1, i32 -1)
  %v3 = call <64 x i1> @llvm.hexagon.V6.pred.typecast.128B.v64i1.v128i1(<128 x i1> %v2)
  %v4 = or <64 x i1> %v1, %v3
  %v5 = call <128 x i1> @llvm.hexagon.V6.pred.typecast.128B.v128i1.v64i1(<64 x i1> %v4)
  %v6 = call <32 x i32> @llvm.hexagon.V6.vandqrt.128B(<128 x i1> %v5, i32 -1)
  ret <32 x i32> %v6
}

define <32 x i32> @f7(<32 x i32> %a0, <32 x i32> %a1) #1 {
; CHECK-LABEL: f7:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = #-1
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     q0 = vand(v0,r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     q1 = vand(v1,r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     q0 = xor(q0,q1)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = vand(q0,r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = call <128 x i1> @llvm.hexagon.V6.vandvrt.128B(<32 x i32> %a0, i32 -1)
  %v1 = call <64 x i1> @llvm.hexagon.V6.pred.typecast.128B.v64i1.v128i1(<128 x i1> %v0)
  %v2 = call <128 x i1> @llvm.hexagon.V6.vandvrt.128B(<32 x i32> %a1, i32 -1)
  %v3 = call <64 x i1> @llvm.hexagon.V6.pred.typecast.128B.v64i1.v128i1(<128 x i1> %v2)
  %v4 = xor <64 x i1> %v1, %v3
  %v5 = call <128 x i1> @llvm.hexagon.V6.pred.typecast.128B.v128i1.v64i1(<64 x i1> %v4)
  %v6 = call <32 x i32> @llvm.hexagon.V6.vandqrt.128B(<128 x i1> %v5, i32 -1)
  ret <32 x i32> %v6
}

define <32 x i32> @f8(<32 x i32> %a0, <32 x i32> %a1) #1 {
; CHECK-LABEL: f8:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = #-1
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     q0 = vand(v0,r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     q1 = vand(v1,r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     q0 = and(q0,!q1)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = vand(q0,r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = call <128 x i1> @llvm.hexagon.V6.vandvrt.128B(<32 x i32> %a0, i32 -1)
  %v1 = call <64 x i1> @llvm.hexagon.V6.pred.typecast.128B.v64i1.v128i1(<128 x i1> %v0)
  %v2 = call <128 x i1> @llvm.hexagon.V6.vandvrt.128B(<32 x i32> %a1, i32 -1)
  %v3 = call <64 x i1> @llvm.hexagon.V6.pred.typecast.128B.v64i1.v128i1(<128 x i1> %v2)
  %v4 = xor <64 x i1> %v3, <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>
  %v5 = and <64 x i1> %v1, %v4
  %v6 = call <128 x i1> @llvm.hexagon.V6.pred.typecast.128B.v128i1.v64i1(<64 x i1> %v5)
  %v7 = call <32 x i32> @llvm.hexagon.V6.vandqrt.128B(<128 x i1> %v6, i32 -1)
  ret <32 x i32> %v7
}

define <32 x i32> @f9(<32 x i32> %a0, <32 x i32> %a1) #1 {
; CHECK-LABEL: f9:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = #-1
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     q0 = vand(v0,r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     q1 = vand(v1,r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     q0 = or(q0,!q1)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = vand(q0,r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = call <128 x i1> @llvm.hexagon.V6.vandvrt.128B(<32 x i32> %a0, i32 -1)
  %v1 = call <64 x i1> @llvm.hexagon.V6.pred.typecast.128B.v64i1.v128i1(<128 x i1> %v0)
  %v2 = call <128 x i1> @llvm.hexagon.V6.vandvrt.128B(<32 x i32> %a1, i32 -1)
  %v3 = call <64 x i1> @llvm.hexagon.V6.pred.typecast.128B.v64i1.v128i1(<128 x i1> %v2)
  %v4 = xor <64 x i1> %v3, <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>
  %v5 = or <64 x i1> %v1, %v4
  %v6 = call <128 x i1> @llvm.hexagon.V6.pred.typecast.128B.v128i1.v64i1(<64 x i1> %v5)
  %v7 = call <32 x i32> @llvm.hexagon.V6.vandqrt.128B(<128 x i1> %v6, i32 -1)
  ret <32 x i32> %v7
}

define <32 x i32> @f10(<32 x i32> %a0, <32 x i32> %a1) #1 {
; CHECK-LABEL: f10:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = #-1
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     q0 = vand(v0,r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     q1 = vand(v1,r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     q0 = and(q0,q1)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = vand(q0,r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = call <128 x i1> @llvm.hexagon.V6.vandvrt.128B(<32 x i32> %a0, i32 -1)
  %v1 = call <128 x i1> @llvm.hexagon.V6.vandvrt.128B(<32 x i32> %a1, i32 -1)
  %v2 = and <128 x i1> %v0, %v1
  %v3 = call <32 x i32> @llvm.hexagon.V6.vandqrt.128B(<128 x i1> %v2, i32 -1)
  ret <32 x i32> %v3
}

define <32 x i32> @f11(<32 x i32> %a0, <32 x i32> %a1) #1 {
; CHECK-LABEL: f11:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = #-1
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     q0 = vand(v0,r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     q1 = vand(v1,r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     q0 = or(q0,q1)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = vand(q0,r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = call <128 x i1> @llvm.hexagon.V6.vandvrt.128B(<32 x i32> %a0, i32 -1)
  %v1 = call <128 x i1> @llvm.hexagon.V6.vandvrt.128B(<32 x i32> %a1, i32 -1)
  %v2 = or <128 x i1> %v0, %v1
  %v3 = call <32 x i32> @llvm.hexagon.V6.vandqrt.128B(<128 x i1> %v2, i32 -1)
  ret <32 x i32> %v3
}

define <32 x i32> @f12(<32 x i32> %a0, <32 x i32> %a1) #1 {
; CHECK-LABEL: f12:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = #-1
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     q0 = vand(v0,r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     q1 = vand(v1,r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     q0 = xor(q0,q1)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = vand(q0,r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = call <128 x i1> @llvm.hexagon.V6.vandvrt.128B(<32 x i32> %a0, i32 -1)
  %v1 = call <128 x i1> @llvm.hexagon.V6.vandvrt.128B(<32 x i32> %a1, i32 -1)
  %v2 = xor <128 x i1> %v0, %v1
  %v3 = call <32 x i32> @llvm.hexagon.V6.vandqrt.128B(<128 x i1> %v2, i32 -1)
  ret <32 x i32> %v3
}

define <32 x i32> @f13(<32 x i32> %a0, <32 x i32> %a1) #1 {
; CHECK-LABEL: f13:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = #-1
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     q0 = vand(v0,r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     q1 = vand(v1,r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     q0 = and(q0,!q1)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = vand(q0,r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = call <128 x i1> @llvm.hexagon.V6.vandvrt.128B(<32 x i32> %a0, i32 -1)
  %v1 = call <128 x i1> @llvm.hexagon.V6.vandvrt.128B(<32 x i32> %a1, i32 -1)
  %v2 = xor <128 x i1> %v1, <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>
  %v3 = and <128 x i1> %v0, %v2
  %v4 = call <32 x i32> @llvm.hexagon.V6.vandqrt.128B(<128 x i1> %v3, i32 -1)
  ret <32 x i32> %v4
}

define <32 x i32> @f14(<32 x i32> %a0, <32 x i32> %a1) #1 {
; CHECK-LABEL: f14:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = #-1
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     q0 = vand(v0,r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     q1 = vand(v1,r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     q0 = or(q0,!q1)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = vand(q0,r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = call <128 x i1> @llvm.hexagon.V6.vandvrt.128B(<32 x i32> %a0, i32 -1)
  %v1 = call <128 x i1> @llvm.hexagon.V6.vandvrt.128B(<32 x i32> %a1, i32 -1)
  %v2 = xor <128 x i1> %v1, <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>
  %v3 = or <128 x i1> %v0, %v2
  %v4 = call <32 x i32> @llvm.hexagon.V6.vandqrt.128B(<128 x i1> %v3, i32 -1)
  ret <32 x i32> %v4
}

attributes #0 = { nounwind readnone }
attributes #1 = { nounwind "target-cpu"="hexagonv66" "target-features"="+hvxv66,+hvx-length128b,-packets" }
