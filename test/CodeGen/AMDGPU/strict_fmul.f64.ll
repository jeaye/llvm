; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=amdgcn-mesa-mesa3d -mcpu=gfx900 < %s | FileCheck -check-prefix=GCN %s
; RUN: llc -mtriple=amdgcn-mesa-mesa3d -mcpu=gfx1010 < %s | FileCheck -check-prefix=GFX10 %s

define double @v_constained_fmul_f64_fpexcept_strict(double %x, double %y) #0 {
; GCN-LABEL: v_constained_fmul_f64_fpexcept_strict:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_mul_f64 v[0:1], v[0:1], v[2:3]
; GCN-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_constained_fmul_f64_fpexcept_strict:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_mul_f64 v[0:1], v[0:1], v[2:3]
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %val = call double @llvm.experimental.constrained.fmul.f64(double %x, double %y, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret double %val
}

define double @v_constained_fmul_f64_fpexcept_ignore(double %x, double %y) #0 {
; GCN-LABEL: v_constained_fmul_f64_fpexcept_ignore:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_mul_f64 v[0:1], v[0:1], v[2:3]
; GCN-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_constained_fmul_f64_fpexcept_ignore:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_mul_f64 v[0:1], v[0:1], v[2:3]
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %val = call double @llvm.experimental.constrained.fmul.f64(double %x, double %y, metadata !"round.tonearest", metadata !"fpexcept.ignore")
  ret double %val
}

define double @v_constained_fmul_f64_fpexcept_maytrap(double %x, double %y) #0 {
; GCN-LABEL: v_constained_fmul_f64_fpexcept_maytrap:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_mul_f64 v[0:1], v[0:1], v[2:3]
; GCN-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_constained_fmul_f64_fpexcept_maytrap:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_mul_f64 v[0:1], v[0:1], v[2:3]
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %val = call double @llvm.experimental.constrained.fmul.f64(double %x, double %y, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
  ret double %val
}

define <2 x double> @v_constained_fmul_v2f64_fpexcept_strict(<2 x double> %x, <2 x double> %y) #0 {
; GCN-LABEL: v_constained_fmul_v2f64_fpexcept_strict:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_mul_f64 v[0:1], v[0:1], v[4:5]
; GCN-NEXT:    v_mul_f64 v[2:3], v[2:3], v[6:7]
; GCN-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_constained_fmul_v2f64_fpexcept_strict:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_mov_b32_e32 v9, v3
; GFX10-NEXT:    v_mov_b32_e32 v8, v2
; GFX10-NEXT:    v_mov_b32_e32 v11, v1
; GFX10-NEXT:    v_mov_b32_e32 v10, v0
; GFX10-NEXT:    v_mul_f64 v[2:3], v[8:9], v[6:7]
; GFX10-NEXT:    v_mul_f64 v[0:1], v[10:11], v[4:5]
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %val = call <2 x double> @llvm.experimental.constrained.fmul.v2f64(<2 x double> %x, <2 x double> %y, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x double> %val
}

define <2 x double> @v_constained_fmul_v2f64_fpexcept_ignore(<2 x double> %x, <2 x double> %y) #0 {
; GCN-LABEL: v_constained_fmul_v2f64_fpexcept_ignore:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_mul_f64 v[0:1], v[0:1], v[4:5]
; GCN-NEXT:    v_mul_f64 v[2:3], v[2:3], v[6:7]
; GCN-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_constained_fmul_v2f64_fpexcept_ignore:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_mov_b32_e32 v9, v3
; GFX10-NEXT:    v_mov_b32_e32 v8, v2
; GFX10-NEXT:    v_mov_b32_e32 v11, v1
; GFX10-NEXT:    v_mov_b32_e32 v10, v0
; GFX10-NEXT:    v_mul_f64 v[2:3], v[8:9], v[6:7]
; GFX10-NEXT:    v_mul_f64 v[0:1], v[10:11], v[4:5]
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %val = call <2 x double> @llvm.experimental.constrained.fmul.v2f64(<2 x double> %x, <2 x double> %y, metadata !"round.tonearest", metadata !"fpexcept.ignore")
  ret <2 x double> %val
}

define <2 x double> @v_constained_fmul_v2f64_fpexcept_maytrap(<2 x double> %x, <2 x double> %y) #0 {
; GCN-LABEL: v_constained_fmul_v2f64_fpexcept_maytrap:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_mul_f64 v[0:1], v[0:1], v[4:5]
; GCN-NEXT:    v_mul_f64 v[2:3], v[2:3], v[6:7]
; GCN-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_constained_fmul_v2f64_fpexcept_maytrap:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_mov_b32_e32 v9, v3
; GFX10-NEXT:    v_mov_b32_e32 v8, v2
; GFX10-NEXT:    v_mov_b32_e32 v11, v1
; GFX10-NEXT:    v_mov_b32_e32 v10, v0
; GFX10-NEXT:    v_mul_f64 v[2:3], v[8:9], v[6:7]
; GFX10-NEXT:    v_mul_f64 v[0:1], v[10:11], v[4:5]
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %val = call <2 x double> @llvm.experimental.constrained.fmul.v2f64(<2 x double> %x, <2 x double> %y, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
  ret <2 x double> %val
}

define <3 x double> @v_constained_fmul_v3f64_fpexcept_strict(<3 x double> %x, <3 x double> %y) #0 {
; GCN-LABEL: v_constained_fmul_v3f64_fpexcept_strict:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_mul_f64 v[0:1], v[0:1], v[6:7]
; GCN-NEXT:    v_mul_f64 v[2:3], v[2:3], v[8:9]
; GCN-NEXT:    v_mul_f64 v[4:5], v[4:5], v[10:11]
; GCN-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_constained_fmul_v3f64_fpexcept_strict:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_mul_f64 v[0:1], v[0:1], v[6:7]
; GFX10-NEXT:    v_mul_f64 v[2:3], v[2:3], v[8:9]
; GFX10-NEXT:    v_mul_f64 v[4:5], v[4:5], v[10:11]
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %val = call <3 x double> @llvm.experimental.constrained.fmul.v3f64(<3 x double> %x, <3 x double> %y, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <3 x double> %val
}

define amdgpu_ps <2 x float> @s_constained_fmul_f64_fpexcept_strict(double inreg %x, double inreg %y) #0 {
; GCN-LABEL: s_constained_fmul_f64_fpexcept_strict:
; GCN:       ; %bb.0:
; GCN-NEXT:    v_mov_b32_e32 v0, s4
; GCN-NEXT:    v_mov_b32_e32 v1, s5
; GCN-NEXT:    v_mul_f64 v[0:1], s[2:3], v[0:1]
; GCN-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: s_constained_fmul_f64_fpexcept_strict:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_mul_f64 v[0:1], s[2:3], s[4:5]
; GFX10-NEXT:    ; return to shader part epilog
  %val = call double @llvm.experimental.constrained.fmul.f64(double %x, double %y, metadata !"round.tonearest", metadata !"fpexcept.strict")
  %cast = bitcast double %val to <2 x float>
  ret <2 x float> %cast
}

declare double @llvm.experimental.constrained.fmul.f64(double, double, metadata, metadata) #1
declare <2 x double> @llvm.experimental.constrained.fmul.v2f64(<2 x double>, <2 x double>, metadata, metadata) #1
declare <3 x double> @llvm.experimental.constrained.fmul.v3f64(<3 x double>, <3 x double>, metadata, metadata) #1

attributes #0 = { strictfp }
attributes #1 = { inaccessiblememonly nounwind willreturn }
