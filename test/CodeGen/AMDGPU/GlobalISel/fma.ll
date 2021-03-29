; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -march=amdgcn -mcpu=tahiti < %s | FileCheck -check-prefix=GFX6 %s
; RUN: llc -global-isel -march=amdgcn -mcpu=fiji < %s | FileCheck -check-prefix=GFX8 %s
; RUN: llc -global-isel -march=amdgcn -mcpu=gfx900 < %s | FileCheck -check-prefix=GFX9 %s
; RUN: llc -global-isel -march=amdgcn -mcpu=gfx1010 < %s | FileCheck -check-prefix=GFX10 %s

define float @v_fma_f32(float %x, float %y, float %z) {
; GFX6-LABEL: v_fma_f32:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    v_fma_f32 v0, v0, v1, v2
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_fma_f32:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_fma_f32 v0, v0, v1, v2
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_fma_f32:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_fma_f32 v0, v0, v1, v2
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_fma_f32:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_fma_f32 v0, v0, v1, v2
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %fma = call float @llvm.fma.f32(float %x, float %y, float %z)
  ret float %fma
}

define <2 x float> @v_fma_v2f32(<2 x float> %x, <2 x float> %y, <2 x float> %z) {
; GFX6-LABEL: v_fma_v2f32:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    v_fma_f32 v0, v0, v2, v4
; GFX6-NEXT:    v_fma_f32 v1, v1, v3, v5
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_fma_v2f32:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_fma_f32 v0, v0, v2, v4
; GFX8-NEXT:    v_fma_f32 v1, v1, v3, v5
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_fma_v2f32:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_fma_f32 v0, v0, v2, v4
; GFX9-NEXT:    v_fma_f32 v1, v1, v3, v5
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_fma_v2f32:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_fma_f32 v0, v0, v2, v4
; GFX10-NEXT:    v_fma_f32 v1, v1, v3, v5
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %fma = call <2 x float> @llvm.fma.v2f32(<2 x float> %x, <2 x float> %y, <2 x float> %z)
  ret <2 x float> %fma
}

define half @v_fma_f16(half %x, half %y, half %z) {
; GFX6-LABEL: v_fma_f16:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    v_cvt_f32_f16_e32 v0, v0
; GFX6-NEXT:    v_cvt_f32_f16_e32 v1, v1
; GFX6-NEXT:    v_cvt_f32_f16_e32 v2, v2
; GFX6-NEXT:    v_fma_f32 v0, v0, v1, v2
; GFX6-NEXT:    v_cvt_f16_f32_e32 v0, v0
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_fma_f16:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_fma_f16 v0, v0, v1, v2
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_fma_f16:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_fma_f16 v0, v0, v1, v2
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_fma_f16:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_fmac_f16_e32 v2, v0, v1
; GFX10-NEXT:    v_mov_b32_e32 v0, v2
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %fma = call half @llvm.fma.f16(half %x, half %y, half %z)
  ret half %fma
}

define <2 x half> @v_fma_v2f16(<2 x half> %x, <2 x half> %y, <2 x half> %z) {
; GFX6-LABEL: v_fma_v2f16:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    v_lshrrev_b32_e32 v3, 16, v0
; GFX6-NEXT:    v_lshrrev_b32_e32 v4, 16, v1
; GFX6-NEXT:    v_lshrrev_b32_e32 v5, 16, v2
; GFX6-NEXT:    v_cvt_f32_f16_e32 v0, v0
; GFX6-NEXT:    v_cvt_f32_f16_e32 v1, v1
; GFX6-NEXT:    v_cvt_f32_f16_e32 v2, v2
; GFX6-NEXT:    v_cvt_f32_f16_e32 v3, v3
; GFX6-NEXT:    v_cvt_f32_f16_e32 v4, v4
; GFX6-NEXT:    v_cvt_f32_f16_e32 v5, v5
; GFX6-NEXT:    v_fma_f32 v0, v0, v1, v2
; GFX6-NEXT:    v_cvt_f16_f32_e32 v0, v0
; GFX6-NEXT:    v_fma_f32 v1, v3, v4, v5
; GFX6-NEXT:    v_cvt_f16_f32_e32 v1, v1
; GFX6-NEXT:    v_bfe_u32 v0, v0, 0, 16
; GFX6-NEXT:    v_bfe_u32 v1, v1, 0, 16
; GFX6-NEXT:    v_lshlrev_b32_e32 v1, 16, v1
; GFX6-NEXT:    v_or_b32_e32 v0, v0, v1
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_fma_v2f16:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_lshrrev_b32_e32 v3, 16, v0
; GFX8-NEXT:    v_lshrrev_b32_e32 v4, 16, v1
; GFX8-NEXT:    v_lshrrev_b32_e32 v5, 16, v2
; GFX8-NEXT:    v_fma_f16 v0, v0, v1, v2
; GFX8-NEXT:    v_fma_f16 v1, v3, v4, v5
; GFX8-NEXT:    v_mov_b32_e32 v2, 16
; GFX8-NEXT:    v_lshlrev_b32_sdwa v1, v2, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GFX8-NEXT:    v_or_b32_sdwa v0, v0, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_fma_v2f16:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_pk_fma_f16 v0, v0, v1, v2
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_fma_v2f16:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_pk_fma_f16 v0, v0, v1, v2
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %fma = call <2 x half> @llvm.fma.v2f16(<2 x half> %x, <2 x half> %y, <2 x half> %z)
  ret <2 x half> %fma
}

define <2 x half> @v_fma_v2f16_fneg_lhs(<2 x half> %x, <2 x half> %y, <2 x half> %z) {
; GFX6-LABEL: v_fma_v2f16_fneg_lhs:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    v_xor_b32_e32 v0, 0x80008000, v0
; GFX6-NEXT:    v_lshrrev_b32_e32 v3, 16, v0
; GFX6-NEXT:    v_lshrrev_b32_e32 v4, 16, v1
; GFX6-NEXT:    v_lshrrev_b32_e32 v5, 16, v2
; GFX6-NEXT:    v_cvt_f32_f16_e32 v0, v0
; GFX6-NEXT:    v_cvt_f32_f16_e32 v1, v1
; GFX6-NEXT:    v_cvt_f32_f16_e32 v2, v2
; GFX6-NEXT:    v_cvt_f32_f16_e32 v3, v3
; GFX6-NEXT:    v_cvt_f32_f16_e32 v4, v4
; GFX6-NEXT:    v_cvt_f32_f16_e32 v5, v5
; GFX6-NEXT:    v_fma_f32 v0, v0, v1, v2
; GFX6-NEXT:    v_cvt_f16_f32_e32 v0, v0
; GFX6-NEXT:    v_fma_f32 v1, v3, v4, v5
; GFX6-NEXT:    v_cvt_f16_f32_e32 v1, v1
; GFX6-NEXT:    v_bfe_u32 v0, v0, 0, 16
; GFX6-NEXT:    v_bfe_u32 v1, v1, 0, 16
; GFX6-NEXT:    v_lshlrev_b32_e32 v1, 16, v1
; GFX6-NEXT:    v_or_b32_e32 v0, v0, v1
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_fma_v2f16_fneg_lhs:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_xor_b32_e32 v0, 0x80008000, v0
; GFX8-NEXT:    v_lshrrev_b32_e32 v3, 16, v0
; GFX8-NEXT:    v_lshrrev_b32_e32 v4, 16, v1
; GFX8-NEXT:    v_lshrrev_b32_e32 v5, 16, v2
; GFX8-NEXT:    v_fma_f16 v0, v0, v1, v2
; GFX8-NEXT:    v_fma_f16 v1, v3, v4, v5
; GFX8-NEXT:    v_mov_b32_e32 v2, 16
; GFX8-NEXT:    v_lshlrev_b32_sdwa v1, v2, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GFX8-NEXT:    v_or_b32_sdwa v0, v0, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_fma_v2f16_fneg_lhs:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_pk_fma_f16 v0, v0, v1, v2 neg_lo:[1,0,0] neg_hi:[1,0,0]
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_fma_v2f16_fneg_lhs:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_pk_fma_f16 v0, v0, v1, v2 neg_lo:[1,0,0] neg_hi:[1,0,0]
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %x.fneg = fneg <2 x half> %x
  %fma = call <2 x half> @llvm.fma.v2f16(<2 x half> %x.fneg, <2 x half> %y, <2 x half> %z)
  ret <2 x half> %fma
}

define <2 x half> @v_fma_v2f16_fneg_rhs(<2 x half> %x, <2 x half> %y, <2 x half> %z) {
; GFX6-LABEL: v_fma_v2f16_fneg_rhs:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    v_xor_b32_e32 v1, 0x80008000, v1
; GFX6-NEXT:    v_lshrrev_b32_e32 v3, 16, v0
; GFX6-NEXT:    v_lshrrev_b32_e32 v4, 16, v1
; GFX6-NEXT:    v_lshrrev_b32_e32 v5, 16, v2
; GFX6-NEXT:    v_cvt_f32_f16_e32 v0, v0
; GFX6-NEXT:    v_cvt_f32_f16_e32 v1, v1
; GFX6-NEXT:    v_cvt_f32_f16_e32 v2, v2
; GFX6-NEXT:    v_cvt_f32_f16_e32 v3, v3
; GFX6-NEXT:    v_cvt_f32_f16_e32 v4, v4
; GFX6-NEXT:    v_cvt_f32_f16_e32 v5, v5
; GFX6-NEXT:    v_fma_f32 v0, v0, v1, v2
; GFX6-NEXT:    v_cvt_f16_f32_e32 v0, v0
; GFX6-NEXT:    v_fma_f32 v1, v3, v4, v5
; GFX6-NEXT:    v_cvt_f16_f32_e32 v1, v1
; GFX6-NEXT:    v_bfe_u32 v0, v0, 0, 16
; GFX6-NEXT:    v_bfe_u32 v1, v1, 0, 16
; GFX6-NEXT:    v_lshlrev_b32_e32 v1, 16, v1
; GFX6-NEXT:    v_or_b32_e32 v0, v0, v1
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_fma_v2f16_fneg_rhs:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_xor_b32_e32 v1, 0x80008000, v1
; GFX8-NEXT:    v_lshrrev_b32_e32 v3, 16, v0
; GFX8-NEXT:    v_lshrrev_b32_e32 v4, 16, v1
; GFX8-NEXT:    v_lshrrev_b32_e32 v5, 16, v2
; GFX8-NEXT:    v_fma_f16 v0, v0, v1, v2
; GFX8-NEXT:    v_fma_f16 v1, v3, v4, v5
; GFX8-NEXT:    v_mov_b32_e32 v2, 16
; GFX8-NEXT:    v_lshlrev_b32_sdwa v1, v2, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GFX8-NEXT:    v_or_b32_sdwa v0, v0, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_fma_v2f16_fneg_rhs:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_pk_fma_f16 v0, v0, v1, v2 neg_lo:[0,1,0] neg_hi:[0,1,0]
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_fma_v2f16_fneg_rhs:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_pk_fma_f16 v0, v0, v1, v2 neg_lo:[0,1,0] neg_hi:[0,1,0]
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %y.fneg = fneg <2 x half> %y
  %fma = call <2 x half> @llvm.fma.v2f16(<2 x half> %x, <2 x half> %y.fneg, <2 x half> %z)
  ret <2 x half> %fma
}

define <2 x half> @v_fma_v2f16_fneg_lhs_rhs(<2 x half> %x, <2 x half> %y, <2 x half> %z) {
; GFX6-LABEL: v_fma_v2f16_fneg_lhs_rhs:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    s_mov_b32 s4, 0x80008000
; GFX6-NEXT:    v_xor_b32_e32 v0, s4, v0
; GFX6-NEXT:    v_xor_b32_e32 v1, s4, v1
; GFX6-NEXT:    v_lshrrev_b32_e32 v3, 16, v0
; GFX6-NEXT:    v_lshrrev_b32_e32 v4, 16, v1
; GFX6-NEXT:    v_lshrrev_b32_e32 v5, 16, v2
; GFX6-NEXT:    v_cvt_f32_f16_e32 v0, v0
; GFX6-NEXT:    v_cvt_f32_f16_e32 v1, v1
; GFX6-NEXT:    v_cvt_f32_f16_e32 v2, v2
; GFX6-NEXT:    v_cvt_f32_f16_e32 v3, v3
; GFX6-NEXT:    v_cvt_f32_f16_e32 v4, v4
; GFX6-NEXT:    v_cvt_f32_f16_e32 v5, v5
; GFX6-NEXT:    v_fma_f32 v0, v0, v1, v2
; GFX6-NEXT:    v_cvt_f16_f32_e32 v0, v0
; GFX6-NEXT:    v_fma_f32 v1, v3, v4, v5
; GFX6-NEXT:    v_cvt_f16_f32_e32 v1, v1
; GFX6-NEXT:    v_bfe_u32 v0, v0, 0, 16
; GFX6-NEXT:    v_bfe_u32 v1, v1, 0, 16
; GFX6-NEXT:    v_lshlrev_b32_e32 v1, 16, v1
; GFX6-NEXT:    v_or_b32_e32 v0, v0, v1
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_fma_v2f16_fneg_lhs_rhs:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    s_mov_b32 s4, 0x80008000
; GFX8-NEXT:    v_xor_b32_e32 v0, s4, v0
; GFX8-NEXT:    v_xor_b32_e32 v1, s4, v1
; GFX8-NEXT:    v_lshrrev_b32_e32 v3, 16, v0
; GFX8-NEXT:    v_lshrrev_b32_e32 v4, 16, v1
; GFX8-NEXT:    v_lshrrev_b32_e32 v5, 16, v2
; GFX8-NEXT:    v_fma_f16 v0, v0, v1, v2
; GFX8-NEXT:    v_fma_f16 v1, v3, v4, v5
; GFX8-NEXT:    v_mov_b32_e32 v2, 16
; GFX8-NEXT:    v_lshlrev_b32_sdwa v1, v2, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GFX8-NEXT:    v_or_b32_sdwa v0, v0, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_fma_v2f16_fneg_lhs_rhs:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_pk_fma_f16 v0, v0, v1, v2 neg_lo:[1,1,0] neg_hi:[1,1,0]
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_fma_v2f16_fneg_lhs_rhs:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_pk_fma_f16 v0, v0, v1, v2 neg_lo:[1,1,0] neg_hi:[1,1,0]
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %x.fneg = fneg <2 x half> %x
  %y.fneg = fneg <2 x half> %y
  %fma = call <2 x half> @llvm.fma.v2f16(<2 x half> %x.fneg, <2 x half> %y.fneg, <2 x half> %z)
  ret <2 x half> %fma
}

; FIXME:
; define <3 x half> @v_fma_v3f16(<3 x half> %x, <3 x half> %y, <3 x half> %z) {
;   %fma = call <3 x half> @llvm.fma.v3f16(<3 x half> %x, <3 x half> %y, <3 x half> %z)
;   ret <3 x half> %fma
; }

define <4 x half> @v_fma_v4f16(<4 x half> %x, <4 x half> %y, <4 x half> %z) {
; GFX6-LABEL: v_fma_v4f16:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    v_cvt_f32_f16_e32 v0, v0
; GFX6-NEXT:    v_cvt_f32_f16_e32 v4, v4
; GFX6-NEXT:    v_cvt_f32_f16_e32 v8, v8
; GFX6-NEXT:    v_cvt_f32_f16_e32 v1, v1
; GFX6-NEXT:    v_cvt_f32_f16_e32 v5, v5
; GFX6-NEXT:    v_cvt_f32_f16_e32 v9, v9
; GFX6-NEXT:    v_fma_f32 v0, v0, v4, v8
; GFX6-NEXT:    v_cvt_f32_f16_e32 v4, v6
; GFX6-NEXT:    v_cvt_f32_f16_e32 v6, v7
; GFX6-NEXT:    v_fma_f32 v1, v1, v5, v9
; GFX6-NEXT:    v_cvt_f32_f16_e32 v2, v2
; GFX6-NEXT:    v_cvt_f32_f16_e32 v5, v10
; GFX6-NEXT:    v_cvt_f32_f16_e32 v3, v3
; GFX6-NEXT:    v_cvt_f32_f16_e32 v7, v11
; GFX6-NEXT:    v_cvt_f16_f32_e32 v0, v0
; GFX6-NEXT:    v_fma_f32 v2, v2, v4, v5
; GFX6-NEXT:    v_cvt_f16_f32_e32 v1, v1
; GFX6-NEXT:    v_fma_f32 v3, v3, v6, v7
; GFX6-NEXT:    v_cvt_f16_f32_e32 v2, v2
; GFX6-NEXT:    v_cvt_f16_f32_e32 v3, v3
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_fma_v4f16:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_lshrrev_b32_e32 v6, 16, v0
; GFX8-NEXT:    v_lshrrev_b32_e32 v8, 16, v2
; GFX8-NEXT:    v_lshrrev_b32_e32 v10, 16, v4
; GFX8-NEXT:    v_fma_f16 v0, v0, v2, v4
; GFX8-NEXT:    v_lshrrev_b32_e32 v7, 16, v1
; GFX8-NEXT:    v_lshrrev_b32_e32 v9, 16, v3
; GFX8-NEXT:    v_lshrrev_b32_e32 v11, 16, v5
; GFX8-NEXT:    v_fma_f16 v2, v6, v8, v10
; GFX8-NEXT:    v_mov_b32_e32 v4, 16
; GFX8-NEXT:    v_fma_f16 v1, v1, v3, v5
; GFX8-NEXT:    v_lshlrev_b32_sdwa v2, v4, v2 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GFX8-NEXT:    v_fma_f16 v3, v7, v9, v11
; GFX8-NEXT:    v_or_b32_sdwa v0, v0, v2 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    v_lshlrev_b32_sdwa v2, v4, v3 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GFX8-NEXT:    v_or_b32_sdwa v1, v1, v2 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_fma_v4f16:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_pk_fma_f16 v0, v0, v2, v4
; GFX9-NEXT:    v_pk_fma_f16 v1, v1, v3, v5
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_fma_v4f16:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_pk_fma_f16 v0, v0, v2, v4
; GFX10-NEXT:    v_pk_fma_f16 v1, v1, v3, v5
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %fma = call <4 x half> @llvm.fma.v4f16(<4 x half> %x, <4 x half> %y, <4 x half> %z)
  ret <4 x half> %fma
}

define double @v_fma_f64(double %x, double %y, double %z) {
; GFX6-LABEL: v_fma_f64:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    v_fma_f64 v[0:1], v[0:1], v[2:3], v[4:5]
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_fma_f64:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_fma_f64 v[0:1], v[0:1], v[2:3], v[4:5]
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_fma_f64:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_fma_f64 v[0:1], v[0:1], v[2:3], v[4:5]
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_fma_f64:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_fma_f64 v[0:1], v[0:1], v[2:3], v[4:5]
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %fma = call double @llvm.fma.f64(double %x, double %y, double %z)
  ret double %fma
}

define double @v_fma_f64_fneg_all(double %x, double %y, double %z) {
; GFX6-LABEL: v_fma_f64_fneg_all:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    v_fma_f64 v[0:1], -v[0:1], -v[2:3], -v[4:5]
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_fma_f64_fneg_all:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_fma_f64 v[0:1], -v[0:1], -v[2:3], -v[4:5]
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_fma_f64_fneg_all:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_fma_f64 v[0:1], -v[0:1], -v[2:3], -v[4:5]
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_fma_f64_fneg_all:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_fma_f64 v[0:1], -v[0:1], -v[2:3], -v[4:5]
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %neg.x = fneg double %x
  %neg.y = fneg double %y
  %neg.z = fneg double %z
  %fma = call double @llvm.fma.f64(double %neg.x, double %neg.y, double %neg.z)
  ret double %fma
}

define <2 x double> @v_fma_v2f64(<2 x double> %x, <2 x double> %y, <2 x double> %z) {
; GFX6-LABEL: v_fma_v2f64:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    v_fma_f64 v[0:1], v[0:1], v[4:5], v[8:9]
; GFX6-NEXT:    v_fma_f64 v[2:3], v[2:3], v[6:7], v[10:11]
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_fma_v2f64:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_fma_f64 v[0:1], v[0:1], v[4:5], v[8:9]
; GFX8-NEXT:    v_fma_f64 v[2:3], v[2:3], v[6:7], v[10:11]
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_fma_v2f64:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_fma_f64 v[0:1], v[0:1], v[4:5], v[8:9]
; GFX9-NEXT:    v_fma_f64 v[2:3], v[2:3], v[6:7], v[10:11]
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_fma_v2f64:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_mov_b32_e32 v14, v0
; GFX10-NEXT:    v_mov_b32_e32 v15, v1
; GFX10-NEXT:    v_mov_b32_e32 v12, v2
; GFX10-NEXT:    v_mov_b32_e32 v13, v3
; GFX10-NEXT:    v_fma_f64 v[0:1], v[14:15], v[4:5], v[8:9]
; GFX10-NEXT:    v_fma_f64 v[2:3], v[12:13], v[6:7], v[10:11]
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %fma = call <2 x double> @llvm.fma.v2f64(<2 x double> %x, <2 x double> %y, <2 x double> %z)
  ret <2 x double> %fma
}

define float @v_fma_f32_fabs_lhs(float %x, float %y, float %z) {
; GFX6-LABEL: v_fma_f32_fabs_lhs:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    v_fma_f32 v0, |v0|, v1, v2
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_fma_f32_fabs_lhs:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_fma_f32 v0, |v0|, v1, v2
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_fma_f32_fabs_lhs:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_fma_f32 v0, |v0|, v1, v2
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_fma_f32_fabs_lhs:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_fma_f32 v0, v1, |v0|, v2
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %fabs.x = call float @llvm.fabs.f32(float %x)
  %fma = call float @llvm.fma.f32(float %fabs.x, float %y, float %z)
  ret float %fma
}

define float @v_fma_f32_fabs_rhs(float %x, float %y, float %z) {
; GFX6-LABEL: v_fma_f32_fabs_rhs:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    v_fma_f32 v0, v0, |v1|, v2
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_fma_f32_fabs_rhs:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_fma_f32 v0, v0, |v1|, v2
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_fma_f32_fabs_rhs:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_fma_f32 v0, v0, |v1|, v2
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_fma_f32_fabs_rhs:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_fma_f32 v0, |v1|, v0, v2
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %fabs.y = call float @llvm.fabs.f32(float %y)
  %fma = call float @llvm.fma.f32(float %x, float %fabs.y, float %z)
  ret float %fma
}

define float @v_fma_f32_fabs_lhs_rhs(float %x, float %y, float %z) {
; GFX6-LABEL: v_fma_f32_fabs_lhs_rhs:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    v_fma_f32 v0, |v0|, |v1|, v2
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_fma_f32_fabs_lhs_rhs:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_fma_f32 v0, |v0|, |v1|, v2
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_fma_f32_fabs_lhs_rhs:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_fma_f32 v0, |v0|, |v1|, v2
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_fma_f32_fabs_lhs_rhs:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_fma_f32 v0, |v1|, |v0|, v2
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %fabs.x = call float @llvm.fabs.f32(float %x)
  %fabs.y = call float @llvm.fabs.f32(float %y)
  %fma = call float @llvm.fma.f32(float %fabs.x, float %fabs.y, float %z)
  ret float %fma
}

define amdgpu_ps float @v_fma_f32_sgpr_vgpr_vgpr(float inreg %x, float %y, float %z) {
; GFX6-LABEL: v_fma_f32_sgpr_vgpr_vgpr:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    v_fma_f32 v0, s0, v0, v1
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX8-LABEL: v_fma_f32_sgpr_vgpr_vgpr:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    v_fma_f32 v0, s0, v0, v1
; GFX8-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: v_fma_f32_sgpr_vgpr_vgpr:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_fma_f32 v0, s0, v0, v1
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: v_fma_f32_sgpr_vgpr_vgpr:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_fma_f32 v0, s0, v0, v1
; GFX10-NEXT:    ; return to shader part epilog
  %fma = call float @llvm.fma.f32(float %x, float %y, float %z)
  ret float %fma
}

define amdgpu_ps float @v_fma_f32_vgpr_sgpr_vgpr(float %x, float inreg %y, float %z) {
; GFX6-LABEL: v_fma_f32_vgpr_sgpr_vgpr:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    v_fma_f32 v0, v0, s0, v1
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX8-LABEL: v_fma_f32_vgpr_sgpr_vgpr:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    v_fma_f32 v0, v0, s0, v1
; GFX8-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: v_fma_f32_vgpr_sgpr_vgpr:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_fma_f32 v0, v0, s0, v1
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: v_fma_f32_vgpr_sgpr_vgpr:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_fma_f32 v0, s0, v0, v1
; GFX10-NEXT:    ; return to shader part epilog
  %fma = call float @llvm.fma.f32(float %x, float %y, float %z)
  ret float %fma
}

define amdgpu_ps float @v_fma_f32_sgpr_sgpr_sgpr(float inreg %x, float inreg %y, float inreg %z) {
; GFX6-LABEL: v_fma_f32_sgpr_sgpr_sgpr:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    v_mov_b32_e32 v0, s1
; GFX6-NEXT:    v_mov_b32_e32 v1, s2
; GFX6-NEXT:    v_fma_f32 v0, s0, v0, v1
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX8-LABEL: v_fma_f32_sgpr_sgpr_sgpr:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    v_mov_b32_e32 v0, s1
; GFX8-NEXT:    v_mov_b32_e32 v1, s2
; GFX8-NEXT:    v_fma_f32 v0, s0, v0, v1
; GFX8-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: v_fma_f32_sgpr_sgpr_sgpr:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_mov_b32_e32 v0, s1
; GFX9-NEXT:    v_mov_b32_e32 v1, s2
; GFX9-NEXT:    v_fma_f32 v0, s0, v0, v1
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: v_fma_f32_sgpr_sgpr_sgpr:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_mov_b32_e32 v0, s2
; GFX10-NEXT:    v_fma_f32 v0, s1, s0, v0
; GFX10-NEXT:    ; return to shader part epilog
  %fma = call float @llvm.fma.f32(float %x, float %y, float %z)
  ret float %fma
}

define float @v_fma_f32_fneg_lhs(float %x, float %y, float %z) {
; GFX6-LABEL: v_fma_f32_fneg_lhs:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    v_fma_f32 v0, -v0, v1, v2
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_fma_f32_fneg_lhs:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_fma_f32 v0, -v0, v1, v2
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_fma_f32_fneg_lhs:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_fma_f32 v0, -v0, v1, v2
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_fma_f32_fneg_lhs:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_fma_f32 v0, v1, -v0, v2
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %neg.x = fneg float %x
  %fma = call float @llvm.fma.f32(float %neg.x, float %y, float %z)
  ret float %fma
}

define float @v_fma_f32_fneg_rhs(float %x, float %y, float %z) {
; GFX6-LABEL: v_fma_f32_fneg_rhs:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    v_fma_f32 v0, v0, -v1, v2
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_fma_f32_fneg_rhs:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_fma_f32 v0, v0, -v1, v2
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_fma_f32_fneg_rhs:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_fma_f32 v0, v0, -v1, v2
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_fma_f32_fneg_rhs:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_fma_f32 v0, -v1, v0, v2
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %neg.y = fneg float %y
  %fma = call float @llvm.fma.f32(float %x, float %neg.y, float %z)
  ret float %fma
}

define float @v_fma_f32_fneg_z(float %x, float %y, float %z) {
; GFX6-LABEL: v_fma_f32_fneg_z:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    v_fma_f32 v0, v0, v1, -v2
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_fma_f32_fneg_z:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_fma_f32 v0, v0, v1, -v2
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_fma_f32_fneg_z:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_fma_f32 v0, v0, v1, -v2
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_fma_f32_fneg_z:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_fma_f32 v0, v0, v1, -v2
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %neg.z = fneg float %z
  %fma = call float @llvm.fma.f32(float %x, float %y, float %neg.z)
  ret float %fma
}

declare half @llvm.fma.f16(half, half, half) #0
declare float @llvm.fma.f32(float, float, float) #0
declare double @llvm.fma.f64(double, double, double) #0

declare half @llvm.fabs.f16(half) #0
declare float @llvm.fabs.f32(float) #0

declare <2 x half> @llvm.fma.v2f16(<2 x half>, <2 x half>, <2 x half>) #0
declare <2 x float> @llvm.fma.v2f32(<2 x float>, <2 x float>, <2 x float>) #0
declare <2 x double> @llvm.fma.v2f64(<2 x double>, <2 x double>, <2 x double>) #0

declare <3 x half> @llvm.fma.v3f16(<3 x half>, <3 x half>, <3 x half>) #0
declare <4 x half> @llvm.fma.v4f16(<4 x half>, <4 x half>, <4 x half>) #0

attributes #0 = { nounwind readnone speculatable willreturn }
