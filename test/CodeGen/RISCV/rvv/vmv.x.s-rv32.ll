; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+experimental-v -verify-machineinstrs < %s | FileCheck %s

declare i8 @llvm.riscv.vmv.x.s.nxv1i8(<vscale x 1 x i8>)

define signext i8 @intrinsic_vmv.x.s_s_nxv1i8(<vscale x 1 x i8> %0) nounwind {
; CHECK-LABEL: intrinsic_vmv.x.s_s_nxv1i8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, zero, e8,mf8,ta,mu
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
entry:
  %a = call i8 @llvm.riscv.vmv.x.s.nxv1i8(<vscale x 1 x i8> %0)
  ret i8 %a
}

declare i8 @llvm.riscv.vmv.x.s.nxv2i8(<vscale x 2 x i8>)

define signext i8 @intrinsic_vmv.x.s_s_nxv2i8(<vscale x 2 x i8> %0) nounwind {
; CHECK-LABEL: intrinsic_vmv.x.s_s_nxv2i8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, zero, e8,mf4,ta,mu
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
entry:
  %a = call i8 @llvm.riscv.vmv.x.s.nxv2i8(<vscale x 2 x i8> %0)
  ret i8 %a
}

declare i8 @llvm.riscv.vmv.x.s.nxv4i8(<vscale x 4 x i8>)

define signext i8 @intrinsic_vmv.x.s_s_nxv4i8(<vscale x 4 x i8> %0) nounwind {
; CHECK-LABEL: intrinsic_vmv.x.s_s_nxv4i8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, zero, e8,mf2,ta,mu
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
entry:
  %a = call i8 @llvm.riscv.vmv.x.s.nxv4i8(<vscale x 4 x i8> %0)
  ret i8 %a
}

declare i8 @llvm.riscv.vmv.x.s.nxv8i8(<vscale x 8 x i8>)

define signext i8 @intrinsic_vmv.x.s_s_nxv8i8(<vscale x 8 x i8> %0) nounwind {
; CHECK-LABEL: intrinsic_vmv.x.s_s_nxv8i8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, zero, e8,m1,ta,mu
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
entry:
  %a = call i8 @llvm.riscv.vmv.x.s.nxv8i8(<vscale x 8 x i8> %0)
  ret i8 %a
}

declare i8 @llvm.riscv.vmv.x.s.nxv16i8(<vscale x 16 x i8>)

define signext i8 @intrinsic_vmv.x.s_s_nxv16i8(<vscale x 16 x i8> %0) nounwind {
; CHECK-LABEL: intrinsic_vmv.x.s_s_nxv16i8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, zero, e8,m2,ta,mu
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
entry:
  %a = call i8 @llvm.riscv.vmv.x.s.nxv16i8(<vscale x 16 x i8> %0)
  ret i8 %a
}

declare i8 @llvm.riscv.vmv.x.s.nxv32i8(<vscale x 32 x i8>)

define signext i8 @intrinsic_vmv.x.s_s_nxv32i8(<vscale x 32 x i8> %0) nounwind {
; CHECK-LABEL: intrinsic_vmv.x.s_s_nxv32i8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, zero, e8,m4,ta,mu
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
entry:
  %a = call i8 @llvm.riscv.vmv.x.s.nxv32i8(<vscale x 32 x i8> %0)
  ret i8 %a
}

declare i8 @llvm.riscv.vmv.x.s.nxv64i8(<vscale x 64 x i8>)

define signext i8 @intrinsic_vmv.x.s_s_nxv64i8(<vscale x 64 x i8> %0) nounwind {
; CHECK-LABEL: intrinsic_vmv.x.s_s_nxv64i8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, zero, e8,m8,ta,mu
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
entry:
  %a = call i8 @llvm.riscv.vmv.x.s.nxv64i8(<vscale x 64 x i8> %0)
  ret i8 %a
}

declare i16 @llvm.riscv.vmv.x.s.nxv1i16(<vscale x 1 x i16>)

define signext i16 @intrinsic_vmv.x.s_s_nxv1i16(<vscale x 1 x i16> %0) nounwind {
; CHECK-LABEL: intrinsic_vmv.x.s_s_nxv1i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, zero, e16,mf4,ta,mu
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
entry:
  %a = call i16 @llvm.riscv.vmv.x.s.nxv1i16(<vscale x 1 x i16> %0)
  ret i16 %a
}

declare i16 @llvm.riscv.vmv.x.s.nxv2i16(<vscale x 2 x i16>)

define signext i16 @intrinsic_vmv.x.s_s_nxv2i16(<vscale x 2 x i16> %0) nounwind {
; CHECK-LABEL: intrinsic_vmv.x.s_s_nxv2i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, zero, e16,mf2,ta,mu
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
entry:
  %a = call i16 @llvm.riscv.vmv.x.s.nxv2i16(<vscale x 2 x i16> %0)
  ret i16 %a
}

declare i16 @llvm.riscv.vmv.x.s.nxv4i16(<vscale x 4 x i16>)

define signext i16 @intrinsic_vmv.x.s_s_nxv4i16(<vscale x 4 x i16> %0) nounwind {
; CHECK-LABEL: intrinsic_vmv.x.s_s_nxv4i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, zero, e16,m1,ta,mu
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
entry:
  %a = call i16 @llvm.riscv.vmv.x.s.nxv4i16(<vscale x 4 x i16> %0)
  ret i16 %a
}

declare i16 @llvm.riscv.vmv.x.s.nxv8i16(<vscale x 8 x i16>)

define signext i16 @intrinsic_vmv.x.s_s_nxv8i16(<vscale x 8 x i16> %0) nounwind {
; CHECK-LABEL: intrinsic_vmv.x.s_s_nxv8i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, zero, e16,m2,ta,mu
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
entry:
  %a = call i16 @llvm.riscv.vmv.x.s.nxv8i16(<vscale x 8 x i16> %0)
  ret i16 %a
}

declare i16 @llvm.riscv.vmv.x.s.nxv16i16(<vscale x 16 x i16>)

define signext i16 @intrinsic_vmv.x.s_s_nxv16i16(<vscale x 16 x i16> %0) nounwind {
; CHECK-LABEL: intrinsic_vmv.x.s_s_nxv16i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, zero, e16,m4,ta,mu
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
entry:
  %a = call i16 @llvm.riscv.vmv.x.s.nxv16i16( <vscale x 16 x i16> %0)
  ret i16 %a
}

declare i16 @llvm.riscv.vmv.x.s.nxv32i16( <vscale x 32 x i16>)

define signext i16 @intrinsic_vmv.x.s_s_nxv32i16(<vscale x 32 x i16> %0) nounwind {
; CHECK-LABEL: intrinsic_vmv.x.s_s_nxv32i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, zero, e16,m8,ta,mu
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
entry:
  %a = call i16 @llvm.riscv.vmv.x.s.nxv32i16( <vscale x 32 x i16> %0)
  ret i16 %a
}

declare i32 @llvm.riscv.vmv.x.s.nxv1i32( <vscale x 1 x i32>)

define i32 @intrinsic_vmv.x.s_s_nxv1i32(<vscale x 1 x i32> %0) nounwind {
; CHECK-LABEL: intrinsic_vmv.x.s_s_nxv1i32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, zero, e32,mf2,ta,mu
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
entry:
  %a = call i32 @llvm.riscv.vmv.x.s.nxv1i32( <vscale x 1 x i32> %0)
  ret i32 %a
}

declare i32 @llvm.riscv.vmv.x.s.nxv2i32( <vscale x 2 x i32>)

define i32 @intrinsic_vmv.x.s_s_nxv2i32(<vscale x 2 x i32> %0) nounwind {
; CHECK-LABEL: intrinsic_vmv.x.s_s_nxv2i32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, zero, e32,m1,ta,mu
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
entry:
  %a = call i32 @llvm.riscv.vmv.x.s.nxv2i32( <vscale x 2 x i32> %0)
  ret i32 %a
}

declare i32 @llvm.riscv.vmv.x.s.nxv4i32( <vscale x 4 x i32>)

define i32 @intrinsic_vmv.x.s_s_nxv4i32(<vscale x 4 x i32> %0) nounwind {
; CHECK-LABEL: intrinsic_vmv.x.s_s_nxv4i32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, zero, e32,m2,ta,mu
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
entry:
  %a = call i32 @llvm.riscv.vmv.x.s.nxv4i32( <vscale x 4 x i32> %0)
  ret i32 %a
}

declare i32 @llvm.riscv.vmv.x.s.nxv8i32( <vscale x 8 x i32>)

define i32 @intrinsic_vmv.x.s_s_nxv8i32(<vscale x 8 x i32> %0) nounwind {
; CHECK-LABEL: intrinsic_vmv.x.s_s_nxv8i32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, zero, e32,m4,ta,mu
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
entry:
  %a = call i32 @llvm.riscv.vmv.x.s.nxv8i32( <vscale x 8 x i32> %0)
  ret i32 %a
}

declare i32 @llvm.riscv.vmv.x.s.nxv16i32( <vscale x 16 x i32>)

define i32 @intrinsic_vmv.x.s_s_nxv16i32(<vscale x 16 x i32> %0) nounwind {
; CHECK-LABEL: intrinsic_vmv.x.s_s_nxv16i32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, zero, e32,m8,ta,mu
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
entry:
  %a = call i32 @llvm.riscv.vmv.x.s.nxv16i32( <vscale x 16 x i32> %0)
  ret i32 %a
}

declare i64 @llvm.riscv.vmv.x.s.nxv1i64( <vscale x 1 x i64>)

define i64 @intrinsic_vmv.x.s_s_nxv1i64(<vscale x 1 x i64> %0) nounwind {
; CHECK-LABEL: intrinsic_vmv.x.s_s_nxv1i64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addi a0, zero, 32
; CHECK-NEXT:    vsetivli zero, 1, e64,m1,ta,mu
; CHECK-NEXT:    vsrl.vx v25, v8, a0
; CHECK-NEXT:    vmv.x.s a1, v25
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
entry:
  %a = call i64 @llvm.riscv.vmv.x.s.nxv1i64( <vscale x 1 x i64> %0)
  ret i64 %a
}

declare i64 @llvm.riscv.vmv.x.s.nxv2i64( <vscale x 2 x i64>)

define i64 @intrinsic_vmv.x.s_s_nxv2i64(<vscale x 2 x i64> %0) nounwind {
; CHECK-LABEL: intrinsic_vmv.x.s_s_nxv2i64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addi a0, zero, 32
; CHECK-NEXT:    vsetivli zero, 1, e64,m2,ta,mu
; CHECK-NEXT:    vsrl.vx v26, v8, a0
; CHECK-NEXT:    vmv.x.s a1, v26
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
entry:
  %a = call i64 @llvm.riscv.vmv.x.s.nxv2i64( <vscale x 2 x i64> %0)
  ret i64 %a
}

declare i64 @llvm.riscv.vmv.x.s.nxv4i64( <vscale x 4 x i64>)

define i64 @intrinsic_vmv.x.s_s_nxv4i64(<vscale x 4 x i64> %0) nounwind {
; CHECK-LABEL: intrinsic_vmv.x.s_s_nxv4i64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addi a0, zero, 32
; CHECK-NEXT:    vsetivli zero, 1, e64,m4,ta,mu
; CHECK-NEXT:    vsrl.vx v28, v8, a0
; CHECK-NEXT:    vmv.x.s a1, v28
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
entry:
  %a = call i64 @llvm.riscv.vmv.x.s.nxv4i64( <vscale x 4 x i64> %0)
  ret i64 %a
}

declare i64 @llvm.riscv.vmv.x.s.nxv8i64(<vscale x 8 x i64>)

define i64 @intrinsic_vmv.x.s_s_nxv8i64(<vscale x 8 x i64> %0) nounwind {
; CHECK-LABEL: intrinsic_vmv.x.s_s_nxv8i64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addi a0, zero, 32
; CHECK-NEXT:    vsetivli zero, 1, e64,m8,ta,mu
; CHECK-NEXT:    vsrl.vx v16, v8, a0
; CHECK-NEXT:    vmv.x.s a1, v16
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
entry:
  %a = call i64 @llvm.riscv.vmv.x.s.nxv8i64(<vscale x 8 x i64> %0)
  ret i64 %a
}
