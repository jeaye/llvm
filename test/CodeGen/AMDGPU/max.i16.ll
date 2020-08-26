; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=amdgcn-- -mcpu=fiji -mattr=-flat-for-global -verify-machineinstrs < %s | FileCheck %s -check-prefixes=GCN,VIPLUS,VI
; RUN: llc -mtriple=amdgcn-- -mcpu=gfx900 -mattr=-flat-for-global -verify-machineinstrs < %s | FileCheck %s -check-prefixes=GCN,VIPLUS,GFX9

; FIXME: Need to handle non-uniform case for function below (load without gep).
define amdgpu_kernel void @v_test_imax_sge_i16(i16 addrspace(1)* %out, i16 addrspace(1)* %aptr, i16 addrspace(1)* %bptr) nounwind {
; VI-LABEL: v_test_imax_sge_i16:
; VI:       ; %bb.0:
; VI-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; VI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x34
; VI-NEXT:    v_lshlrev_b32_e32 v4, 1, v0
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_mov_b32_e32 v1, s7
; VI-NEXT:    v_add_u32_e32 v0, vcc, s6, v4
; VI-NEXT:    v_addc_u32_e32 v1, vcc, 0, v1, vcc
; VI-NEXT:    v_mov_b32_e32 v3, s1
; VI-NEXT:    v_add_u32_e32 v2, vcc, s0, v4
; VI-NEXT:    v_addc_u32_e32 v3, vcc, 0, v3, vcc
; VI-NEXT:    flat_load_ushort v0, v[0:1]
; VI-NEXT:    flat_load_ushort v1, v[2:3]
; VI-NEXT:    v_mov_b32_e32 v5, s5
; VI-NEXT:    v_add_u32_e32 v4, vcc, s4, v4
; VI-NEXT:    v_addc_u32_e32 v5, vcc, 0, v5, vcc
; VI-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; VI-NEXT:    v_max_i16_e32 v0, v0, v1
; VI-NEXT:    flat_store_short v[4:5], v0
; VI-NEXT:    s_endpgm
;
; GFX9-LABEL: v_test_imax_sge_i16:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; GFX9-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x34
; GFX9-NEXT:    v_lshlrev_b32_e32 v0, 1, v0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    global_load_ushort v1, v0, s[6:7]
; GFX9-NEXT:    global_load_ushort v2, v0, s[0:1]
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_max_i16_e32 v1, v1, v2
; GFX9-NEXT:    global_store_short v0, v1, s[4:5]
; GFX9-NEXT:    s_endpgm
  %tid = call i32 @llvm.amdgcn.workitem.id.x() nounwind readnone
  %gep0 = getelementptr i16, i16 addrspace(1)* %aptr, i32 %tid
  %gep1 = getelementptr i16, i16 addrspace(1)* %bptr, i32 %tid
  %outgep = getelementptr i16, i16 addrspace(1)* %out, i32 %tid
  %a = load i16, i16 addrspace(1)* %gep0, align 4
  %b = load i16, i16 addrspace(1)* %gep1, align 4
  %cmp = icmp sge i16 %a, %b
  %val = select i1 %cmp, i16 %a, i16 %b
  store i16 %val, i16 addrspace(1)* %outgep, align 4
  ret void
}

; FIXME: Need to handle non-uniform case for function below (load without gep).
define amdgpu_kernel void @v_test_imax_sge_v2i16(<2 x i16> addrspace(1)* %out, <2 x i16> addrspace(1)* %aptr, <2 x i16> addrspace(1)* %bptr) nounwind {
; VI-LABEL: v_test_imax_sge_v2i16:
; VI:       ; %bb.0:
; VI-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; VI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x34
; VI-NEXT:    v_lshlrev_b32_e32 v4, 2, v0
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_mov_b32_e32 v1, s7
; VI-NEXT:    v_add_u32_e32 v0, vcc, s6, v4
; VI-NEXT:    v_addc_u32_e32 v1, vcc, 0, v1, vcc
; VI-NEXT:    v_mov_b32_e32 v3, s1
; VI-NEXT:    v_add_u32_e32 v2, vcc, s0, v4
; VI-NEXT:    v_addc_u32_e32 v3, vcc, 0, v3, vcc
; VI-NEXT:    flat_load_dword v5, v[0:1]
; VI-NEXT:    flat_load_dword v2, v[2:3]
; VI-NEXT:    v_mov_b32_e32 v1, s5
; VI-NEXT:    v_add_u32_e32 v0, vcc, s4, v4
; VI-NEXT:    v_addc_u32_e32 v1, vcc, 0, v1, vcc
; VI-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; VI-NEXT:    v_max_i16_e32 v3, v5, v2
; VI-NEXT:    v_max_i16_sdwa v2, v5, v2 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; VI-NEXT:    v_or_b32_e32 v2, v3, v2
; VI-NEXT:    flat_store_dword v[0:1], v2
; VI-NEXT:    s_endpgm
;
; GFX9-LABEL: v_test_imax_sge_v2i16:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; GFX9-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x34
; GFX9-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    global_load_dword v1, v0, s[6:7]
; GFX9-NEXT:    global_load_dword v2, v0, s[0:1]
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_pk_max_i16 v1, v1, v2
; GFX9-NEXT:    global_store_dword v0, v1, s[4:5]
; GFX9-NEXT:    s_endpgm
  %tid = call i32 @llvm.amdgcn.workitem.id.x() nounwind readnone
  %gep0 = getelementptr <2 x i16>, <2 x i16> addrspace(1)* %aptr, i32 %tid
  %gep1 = getelementptr <2 x i16>, <2 x i16> addrspace(1)* %bptr, i32 %tid
  %outgep = getelementptr <2 x i16>, <2 x i16> addrspace(1)* %out, i32 %tid
  %a = load <2 x i16>, <2 x i16> addrspace(1)* %gep0, align 4
  %b = load <2 x i16>, <2 x i16> addrspace(1)* %gep1, align 4
  %cmp = icmp sge <2 x i16> %a, %b
  %val = select <2 x i1> %cmp, <2 x i16> %a, <2 x i16> %b
  store <2 x i16> %val, <2 x i16> addrspace(1)* %outgep, align 4
  ret void
}

; FIXME: Need to handle non-uniform case for function below (load without gep).
define amdgpu_kernel void @v_test_imax_sge_v3i16(<3 x i16> addrspace(1)* %out, <3 x i16> addrspace(1)* %aptr, <3 x i16> addrspace(1)* %bptr) nounwind {
; VI-LABEL: v_test_imax_sge_v3i16:
; VI:       ; %bb.0:
; VI-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; VI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x34
; VI-NEXT:    v_lshlrev_b32_e32 v6, 3, v0
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_mov_b32_e32 v1, s7
; VI-NEXT:    v_add_u32_e32 v0, vcc, s6, v6
; VI-NEXT:    v_addc_u32_e32 v1, vcc, 0, v1, vcc
; VI-NEXT:    v_mov_b32_e32 v3, s1
; VI-NEXT:    v_add_u32_e32 v2, vcc, s0, v6
; VI-NEXT:    v_addc_u32_e32 v3, vcc, 0, v3, vcc
; VI-NEXT:    v_add_u32_e32 v4, vcc, 4, v0
; VI-NEXT:    v_addc_u32_e32 v5, vcc, 0, v1, vcc
; VI-NEXT:    flat_load_ushort v4, v[4:5]
; VI-NEXT:    flat_load_dword v5, v[0:1]
; VI-NEXT:    v_add_u32_e32 v0, vcc, 4, v2
; VI-NEXT:    v_addc_u32_e32 v1, vcc, 0, v3, vcc
; VI-NEXT:    flat_load_dword v7, v[2:3]
; VI-NEXT:    flat_load_ushort v8, v[0:1]
; VI-NEXT:    v_add_u32_e32 v0, vcc, s4, v6
; VI-NEXT:    v_mov_b32_e32 v1, s5
; VI-NEXT:    v_addc_u32_e32 v1, vcc, 0, v1, vcc
; VI-NEXT:    v_add_u32_e32 v2, vcc, 4, v0
; VI-NEXT:    v_addc_u32_e32 v3, vcc, 0, v1, vcc
; VI-NEXT:    s_waitcnt vmcnt(1) lgkmcnt(1)
; VI-NEXT:    v_max_i16_e32 v6, v5, v7
; VI-NEXT:    v_max_i16_sdwa v5, v5, v7 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; VI-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; VI-NEXT:    v_max_i16_e32 v4, v4, v8
; VI-NEXT:    v_or_b32_e32 v5, v6, v5
; VI-NEXT:    flat_store_short v[2:3], v4
; VI-NEXT:    flat_store_dword v[0:1], v5
; VI-NEXT:    s_endpgm
;
; GFX9-LABEL: v_test_imax_sge_v3i16:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; GFX9-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x34
; GFX9-NEXT:    v_lshlrev_b32_e32 v0, 3, v0
; GFX9-NEXT:    v_mov_b32_e32 v1, 0
; GFX9-NEXT:    v_mov_b32_e32 v2, 0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    global_load_short_d16 v1, v0, s[0:1] offset:4
; GFX9-NEXT:    global_load_dword v3, v0, s[0:1]
; GFX9-NEXT:    global_load_short_d16 v2, v0, s[6:7] offset:4
; GFX9-NEXT:    global_load_dword v4, v0, s[6:7]
; GFX9-NEXT:    s_waitcnt vmcnt(1)
; GFX9-NEXT:    v_pk_max_i16 v1, v2, v1
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_pk_max_i16 v3, v4, v3
; GFX9-NEXT:    global_store_short v0, v1, s[4:5] offset:4
; GFX9-NEXT:    global_store_dword v0, v3, s[4:5]
; GFX9-NEXT:    s_endpgm
  %tid = call i32 @llvm.amdgcn.workitem.id.x() nounwind readnone
  %gep0 = getelementptr <3 x i16>, <3 x i16> addrspace(1)* %aptr, i32 %tid
  %gep1 = getelementptr <3 x i16>, <3 x i16> addrspace(1)* %bptr, i32 %tid
  %outgep = getelementptr <3 x i16>, <3 x i16> addrspace(1)* %out, i32 %tid
  %a = load <3 x i16>, <3 x i16> addrspace(1)* %gep0, align 4
  %b = load <3 x i16>, <3 x i16> addrspace(1)* %gep1, align 4
  %cmp = icmp sge <3 x i16> %a, %b
  %val = select <3 x i1> %cmp, <3 x i16> %a, <3 x i16> %b
  store <3 x i16> %val, <3 x i16> addrspace(1)* %outgep, align 4
  ret void
}

; FIXME: Need to handle non-uniform case for function below (load without gep).
define amdgpu_kernel void @v_test_imax_sge_v4i16(<4 x i16> addrspace(1)* %out, <4 x i16> addrspace(1)* %aptr, <4 x i16> addrspace(1)* %bptr) nounwind {
; VI-LABEL: v_test_imax_sge_v4i16:
; VI:       ; %bb.0:
; VI-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; VI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x34
; VI-NEXT:    v_lshlrev_b32_e32 v4, 3, v0
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_mov_b32_e32 v1, s7
; VI-NEXT:    v_add_u32_e32 v0, vcc, s6, v4
; VI-NEXT:    v_addc_u32_e32 v1, vcc, 0, v1, vcc
; VI-NEXT:    v_mov_b32_e32 v3, s1
; VI-NEXT:    v_add_u32_e32 v2, vcc, s0, v4
; VI-NEXT:    v_addc_u32_e32 v3, vcc, 0, v3, vcc
; VI-NEXT:    flat_load_dwordx2 v[0:1], v[0:1]
; VI-NEXT:    flat_load_dwordx2 v[2:3], v[2:3]
; VI-NEXT:    v_mov_b32_e32 v5, s5
; VI-NEXT:    v_add_u32_e32 v4, vcc, s4, v4
; VI-NEXT:    v_addc_u32_e32 v5, vcc, 0, v5, vcc
; VI-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; VI-NEXT:    v_max_i16_e32 v6, v1, v3
; VI-NEXT:    v_max_i16_sdwa v1, v1, v3 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; VI-NEXT:    v_max_i16_e32 v3, v0, v2
; VI-NEXT:    v_max_i16_sdwa v0, v0, v2 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; VI-NEXT:    v_or_b32_e32 v1, v6, v1
; VI-NEXT:    v_or_b32_e32 v0, v3, v0
; VI-NEXT:    flat_store_dwordx2 v[4:5], v[0:1]
; VI-NEXT:    s_endpgm
;
; GFX9-LABEL: v_test_imax_sge_v4i16:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; GFX9-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x34
; GFX9-NEXT:    v_lshlrev_b32_e32 v4, 3, v0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    global_load_dwordx2 v[0:1], v4, s[6:7]
; GFX9-NEXT:    global_load_dwordx2 v[2:3], v4, s[0:1]
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_pk_max_i16 v1, v1, v3
; GFX9-NEXT:    v_pk_max_i16 v0, v0, v2
; GFX9-NEXT:    global_store_dwordx2 v4, v[0:1], s[4:5]
; GFX9-NEXT:    s_endpgm
  %tid = call i32 @llvm.amdgcn.workitem.id.x() nounwind readnone
  %gep0 = getelementptr <4 x i16>, <4 x i16> addrspace(1)* %aptr, i32 %tid
  %gep1 = getelementptr <4 x i16>, <4 x i16> addrspace(1)* %bptr, i32 %tid
  %outgep = getelementptr <4 x i16>, <4 x i16> addrspace(1)* %out, i32 %tid
  %a = load <4 x i16>, <4 x i16> addrspace(1)* %gep0, align 4
  %b = load <4 x i16>, <4 x i16> addrspace(1)* %gep1, align 4
  %cmp = icmp sge <4 x i16> %a, %b
  %val = select <4 x i1> %cmp, <4 x i16> %a, <4 x i16> %b
  store <4 x i16> %val, <4 x i16> addrspace(1)* %outgep, align 4
  ret void
}

; FIXME: Need to handle non-uniform case for function below (load without gep).
define amdgpu_kernel void @v_test_imax_sgt_i16(i16 addrspace(1)* %out, i16 addrspace(1)* %aptr, i16 addrspace(1)* %bptr) nounwind {
; VI-LABEL: v_test_imax_sgt_i16:
; VI:       ; %bb.0:
; VI-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; VI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x34
; VI-NEXT:    v_lshlrev_b32_e32 v4, 1, v0
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_mov_b32_e32 v1, s7
; VI-NEXT:    v_add_u32_e32 v0, vcc, s6, v4
; VI-NEXT:    v_addc_u32_e32 v1, vcc, 0, v1, vcc
; VI-NEXT:    v_mov_b32_e32 v3, s1
; VI-NEXT:    v_add_u32_e32 v2, vcc, s0, v4
; VI-NEXT:    v_addc_u32_e32 v3, vcc, 0, v3, vcc
; VI-NEXT:    flat_load_ushort v0, v[0:1]
; VI-NEXT:    flat_load_ushort v1, v[2:3]
; VI-NEXT:    v_mov_b32_e32 v5, s5
; VI-NEXT:    v_add_u32_e32 v4, vcc, s4, v4
; VI-NEXT:    v_addc_u32_e32 v5, vcc, 0, v5, vcc
; VI-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; VI-NEXT:    v_max_i16_e32 v0, v0, v1
; VI-NEXT:    flat_store_short v[4:5], v0
; VI-NEXT:    s_endpgm
;
; GFX9-LABEL: v_test_imax_sgt_i16:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; GFX9-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x34
; GFX9-NEXT:    v_lshlrev_b32_e32 v0, 1, v0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    global_load_ushort v1, v0, s[6:7]
; GFX9-NEXT:    global_load_ushort v2, v0, s[0:1]
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_max_i16_e32 v1, v1, v2
; GFX9-NEXT:    global_store_short v0, v1, s[4:5]
; GFX9-NEXT:    s_endpgm
  %tid = call i32 @llvm.amdgcn.workitem.id.x() nounwind readnone
  %gep0 = getelementptr i16, i16 addrspace(1)* %aptr, i32 %tid
  %gep1 = getelementptr i16, i16 addrspace(1)* %bptr, i32 %tid
  %outgep = getelementptr i16, i16 addrspace(1)* %out, i32 %tid
  %a = load i16, i16 addrspace(1)* %gep0, align 4
  %b = load i16, i16 addrspace(1)* %gep1, align 4
  %cmp = icmp sgt i16 %a, %b
  %val = select i1 %cmp, i16 %a, i16 %b
  store i16 %val, i16 addrspace(1)* %outgep, align 4
  ret void
}

; FIXME: Need to handle non-uniform case for function below (load without gep).
define amdgpu_kernel void @v_test_umax_uge_i16(i16 addrspace(1)* %out, i16 addrspace(1)* %aptr, i16 addrspace(1)* %bptr) nounwind {
; VI-LABEL: v_test_umax_uge_i16:
; VI:       ; %bb.0:
; VI-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; VI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x34
; VI-NEXT:    v_lshlrev_b32_e32 v4, 1, v0
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_mov_b32_e32 v1, s7
; VI-NEXT:    v_add_u32_e32 v0, vcc, s6, v4
; VI-NEXT:    v_addc_u32_e32 v1, vcc, 0, v1, vcc
; VI-NEXT:    v_mov_b32_e32 v3, s1
; VI-NEXT:    v_add_u32_e32 v2, vcc, s0, v4
; VI-NEXT:    v_addc_u32_e32 v3, vcc, 0, v3, vcc
; VI-NEXT:    flat_load_ushort v0, v[0:1]
; VI-NEXT:    flat_load_ushort v1, v[2:3]
; VI-NEXT:    v_mov_b32_e32 v5, s5
; VI-NEXT:    v_add_u32_e32 v4, vcc, s4, v4
; VI-NEXT:    v_addc_u32_e32 v5, vcc, 0, v5, vcc
; VI-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; VI-NEXT:    v_max_u16_e32 v0, v0, v1
; VI-NEXT:    flat_store_short v[4:5], v0
; VI-NEXT:    s_endpgm
;
; GFX9-LABEL: v_test_umax_uge_i16:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; GFX9-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x34
; GFX9-NEXT:    v_lshlrev_b32_e32 v0, 1, v0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    global_load_ushort v1, v0, s[6:7]
; GFX9-NEXT:    global_load_ushort v2, v0, s[0:1]
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_max_u16_e32 v1, v1, v2
; GFX9-NEXT:    global_store_short v0, v1, s[4:5]
; GFX9-NEXT:    s_endpgm
  %tid = call i32 @llvm.amdgcn.workitem.id.x() nounwind readnone
  %gep0 = getelementptr i16, i16 addrspace(1)* %aptr, i32 %tid
  %gep1 = getelementptr i16, i16 addrspace(1)* %bptr, i32 %tid
  %outgep = getelementptr i16, i16 addrspace(1)* %out, i32 %tid
  %a = load i16, i16 addrspace(1)* %gep0, align 4
  %b = load i16, i16 addrspace(1)* %gep1, align 4
  %cmp = icmp uge i16 %a, %b
  %val = select i1 %cmp, i16 %a, i16 %b
  store i16 %val, i16 addrspace(1)* %outgep, align 4
  ret void
}

; FIXME: Need to handle non-uniform case for function below (load without gep).
define amdgpu_kernel void @v_test_umax_ugt_i16(i16 addrspace(1)* %out, i16 addrspace(1)* %aptr, i16 addrspace(1)* %bptr) nounwind {
; VI-LABEL: v_test_umax_ugt_i16:
; VI:       ; %bb.0:
; VI-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; VI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x34
; VI-NEXT:    v_lshlrev_b32_e32 v4, 1, v0
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_mov_b32_e32 v1, s7
; VI-NEXT:    v_add_u32_e32 v0, vcc, s6, v4
; VI-NEXT:    v_addc_u32_e32 v1, vcc, 0, v1, vcc
; VI-NEXT:    v_mov_b32_e32 v3, s1
; VI-NEXT:    v_add_u32_e32 v2, vcc, s0, v4
; VI-NEXT:    v_addc_u32_e32 v3, vcc, 0, v3, vcc
; VI-NEXT:    flat_load_ushort v0, v[0:1]
; VI-NEXT:    flat_load_ushort v1, v[2:3]
; VI-NEXT:    v_mov_b32_e32 v5, s5
; VI-NEXT:    v_add_u32_e32 v4, vcc, s4, v4
; VI-NEXT:    v_addc_u32_e32 v5, vcc, 0, v5, vcc
; VI-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; VI-NEXT:    v_max_u16_e32 v0, v0, v1
; VI-NEXT:    flat_store_short v[4:5], v0
; VI-NEXT:    s_endpgm
;
; GFX9-LABEL: v_test_umax_ugt_i16:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; GFX9-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x34
; GFX9-NEXT:    v_lshlrev_b32_e32 v0, 1, v0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    global_load_ushort v1, v0, s[6:7]
; GFX9-NEXT:    global_load_ushort v2, v0, s[0:1]
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_max_u16_e32 v1, v1, v2
; GFX9-NEXT:    global_store_short v0, v1, s[4:5]
; GFX9-NEXT:    s_endpgm
  %tid = call i32 @llvm.amdgcn.workitem.id.x() nounwind readnone
  %gep0 = getelementptr i16, i16 addrspace(1)* %aptr, i32 %tid
  %gep1 = getelementptr i16, i16 addrspace(1)* %bptr, i32 %tid
  %outgep = getelementptr i16, i16 addrspace(1)* %out, i32 %tid
  %a = load i16, i16 addrspace(1)* %gep0, align 4
  %b = load i16, i16 addrspace(1)* %gep1, align 4
  %cmp = icmp ugt i16 %a, %b
  %val = select i1 %cmp, i16 %a, i16 %b
  store i16 %val, i16 addrspace(1)* %outgep, align 4
  ret void
}

define amdgpu_kernel void @v_test_umax_ugt_v2i16(<2 x i16> addrspace(1)* %out, <2 x i16> addrspace(1)* %aptr, <2 x i16> addrspace(1)* %bptr) nounwind {
; VI-LABEL: v_test_umax_ugt_v2i16:
; VI:       ; %bb.0:
; VI-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; VI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x34
; VI-NEXT:    v_lshlrev_b32_e32 v4, 2, v0
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_mov_b32_e32 v1, s7
; VI-NEXT:    v_add_u32_e32 v0, vcc, s6, v4
; VI-NEXT:    v_addc_u32_e32 v1, vcc, 0, v1, vcc
; VI-NEXT:    v_mov_b32_e32 v3, s1
; VI-NEXT:    v_add_u32_e32 v2, vcc, s0, v4
; VI-NEXT:    v_addc_u32_e32 v3, vcc, 0, v3, vcc
; VI-NEXT:    flat_load_dword v5, v[0:1]
; VI-NEXT:    flat_load_dword v2, v[2:3]
; VI-NEXT:    v_mov_b32_e32 v1, s5
; VI-NEXT:    v_add_u32_e32 v0, vcc, s4, v4
; VI-NEXT:    v_addc_u32_e32 v1, vcc, 0, v1, vcc
; VI-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; VI-NEXT:    v_max_u16_e32 v3, v5, v2
; VI-NEXT:    v_max_u16_sdwa v2, v5, v2 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; VI-NEXT:    v_or_b32_e32 v2, v3, v2
; VI-NEXT:    flat_store_dword v[0:1], v2
; VI-NEXT:    s_endpgm
;
; GFX9-LABEL: v_test_umax_ugt_v2i16:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; GFX9-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x34
; GFX9-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    global_load_dword v1, v0, s[6:7]
; GFX9-NEXT:    global_load_dword v2, v0, s[0:1]
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_pk_max_u16 v1, v1, v2
; GFX9-NEXT:    global_store_dword v0, v1, s[4:5]
; GFX9-NEXT:    s_endpgm
  %tid = call i32 @llvm.amdgcn.workitem.id.x() nounwind readnone
  %gep0 = getelementptr <2 x i16>, <2 x i16> addrspace(1)* %aptr, i32 %tid
  %gep1 = getelementptr <2 x i16>, <2 x i16> addrspace(1)* %bptr, i32 %tid
  %outgep = getelementptr <2 x i16>, <2 x i16> addrspace(1)* %out, i32 %tid
  %a = load <2 x i16>, <2 x i16> addrspace(1)* %gep0, align 4
  %b = load <2 x i16>, <2 x i16> addrspace(1)* %gep1, align 4
  %cmp = icmp ugt <2 x i16> %a, %b
  %val = select <2 x i1> %cmp, <2 x i16> %a, <2 x i16> %b
  store <2 x i16> %val, <2 x i16> addrspace(1)* %outgep, align 4
  ret void
}

declare i32 @llvm.amdgcn.workitem.id.x() nounwind readnone
