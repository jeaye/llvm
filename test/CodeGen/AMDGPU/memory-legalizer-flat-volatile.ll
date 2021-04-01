; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx700 -verify-machineinstrs < %s | FileCheck --check-prefixes=GFX7 %s
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx1010 -verify-machineinstrs < %s | FileCheck --check-prefixes=GFX10-WGP %s
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx1010 -mattr=+cumode -verify-machineinstrs < %s | FileCheck --check-prefixes=GFX10-CU %s
; RUN: llc -mtriple=amdgcn-amd-amdpal -mcpu=gfx700 -amdgcn-skip-cache-invalidations -verify-machineinstrs < %s | FileCheck --check-prefixes=SKIP-CACHE-INV %s

define amdgpu_kernel void @flat_nontemporal_load_0(
; GFX7-LABEL: flat_nontemporal_load_0:
; GFX7:       ; %bb.0: ; %entry
; GFX7-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x0
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    v_mov_b32_e32 v0, s0
; GFX7-NEXT:    v_mov_b32_e32 v1, s1
; GFX7-NEXT:    flat_load_dword v0, v[0:1] glc
; GFX7-NEXT:    s_waitcnt vmcnt(0)
; GFX7-NEXT:    v_mov_b32_e32 v2, s2
; GFX7-NEXT:    v_mov_b32_e32 v3, s3
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    flat_store_dword v[2:3], v0
; GFX7-NEXT:    s_endpgm
;
; GFX10-WGP-LABEL: flat_nontemporal_load_0:
; GFX10-WGP:       ; %bb.0: ; %entry
; GFX10-WGP-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x0
; GFX10-WGP-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-WGP-NEXT:    v_mov_b32_e32 v0, s0
; GFX10-WGP-NEXT:    v_mov_b32_e32 v1, s1
; GFX10-WGP-NEXT:    flat_load_dword v2, v[0:1] glc dlc
; GFX10-WGP-NEXT:    s_waitcnt vmcnt(0)
; GFX10-WGP-NEXT:    v_mov_b32_e32 v0, s2
; GFX10-WGP-NEXT:    v_mov_b32_e32 v1, s3
; GFX10-WGP-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-WGP-NEXT:    flat_store_dword v[0:1], v2
; GFX10-WGP-NEXT:    s_endpgm
;
; GFX10-CU-LABEL: flat_nontemporal_load_0:
; GFX10-CU:       ; %bb.0: ; %entry
; GFX10-CU-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x0
; GFX10-CU-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-CU-NEXT:    v_mov_b32_e32 v0, s0
; GFX10-CU-NEXT:    v_mov_b32_e32 v1, s1
; GFX10-CU-NEXT:    flat_load_dword v2, v[0:1] glc dlc
; GFX10-CU-NEXT:    s_waitcnt vmcnt(0)
; GFX10-CU-NEXT:    v_mov_b32_e32 v0, s2
; GFX10-CU-NEXT:    v_mov_b32_e32 v1, s3
; GFX10-CU-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-CU-NEXT:    flat_store_dword v[0:1], v2
; GFX10-CU-NEXT:    s_endpgm
;
; SKIP-CACHE-INV-LABEL: flat_nontemporal_load_0:
; SKIP-CACHE-INV:       ; %bb.0: ; %entry
; SKIP-CACHE-INV-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x9
; SKIP-CACHE-INV-NEXT:    s_waitcnt lgkmcnt(0)
; SKIP-CACHE-INV-NEXT:    v_mov_b32_e32 v0, s0
; SKIP-CACHE-INV-NEXT:    v_mov_b32_e32 v1, s1
; SKIP-CACHE-INV-NEXT:    flat_load_dword v0, v[0:1] glc
; SKIP-CACHE-INV-NEXT:    s_waitcnt vmcnt(0)
; SKIP-CACHE-INV-NEXT:    v_mov_b32_e32 v2, s2
; SKIP-CACHE-INV-NEXT:    v_mov_b32_e32 v3, s3
; SKIP-CACHE-INV-NEXT:    s_waitcnt lgkmcnt(0)
; SKIP-CACHE-INV-NEXT:    flat_store_dword v[2:3], v0
; SKIP-CACHE-INV-NEXT:    s_endpgm
    i32* %in, i32* %out) {
entry:
  %val = load volatile i32, i32* %in, align 4
  store i32 %val, i32* %out
  ret void
}

define amdgpu_kernel void @flat_nontemporal_load_1(
; GFX7-LABEL: flat_nontemporal_load_1:
; GFX7:       ; %bb.0: ; %entry
; GFX7-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x0
; GFX7-NEXT:    v_lshlrev_b32_e32 v2, 2, v0
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    v_mov_b32_e32 v3, s1
; GFX7-NEXT:    v_add_i32_e32 v2, vcc, s0, v2
; GFX7-NEXT:    v_addc_u32_e32 v3, vcc, 0, v3, vcc
; GFX7-NEXT:    flat_load_dword v2, v[2:3] glc
; GFX7-NEXT:    s_waitcnt vmcnt(0)
; GFX7-NEXT:    v_mov_b32_e32 v0, s2
; GFX7-NEXT:    v_mov_b32_e32 v1, s3
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    flat_store_dword v[0:1], v2
; GFX7-NEXT:    s_endpgm
;
; GFX10-WGP-LABEL: flat_nontemporal_load_1:
; GFX10-WGP:       ; %bb.0: ; %entry
; GFX10-WGP-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x0
; GFX10-WGP-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GFX10-WGP-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-WGP-NEXT:    v_add_co_u32 v0, s0, s0, v0
; GFX10-WGP-NEXT:    v_add_co_ci_u32_e64 v1, s0, s1, 0, s0
; GFX10-WGP-NEXT:    flat_load_dword v2, v[0:1] glc dlc
; GFX10-WGP-NEXT:    s_waitcnt vmcnt(0)
; GFX10-WGP-NEXT:    v_mov_b32_e32 v0, s2
; GFX10-WGP-NEXT:    v_mov_b32_e32 v1, s3
; GFX10-WGP-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-WGP-NEXT:    flat_store_dword v[0:1], v2
; GFX10-WGP-NEXT:    s_endpgm
;
; GFX10-CU-LABEL: flat_nontemporal_load_1:
; GFX10-CU:       ; %bb.0: ; %entry
; GFX10-CU-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x0
; GFX10-CU-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GFX10-CU-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-CU-NEXT:    v_add_co_u32 v0, s0, s0, v0
; GFX10-CU-NEXT:    v_add_co_ci_u32_e64 v1, s0, s1, 0, s0
; GFX10-CU-NEXT:    flat_load_dword v2, v[0:1] glc dlc
; GFX10-CU-NEXT:    s_waitcnt vmcnt(0)
; GFX10-CU-NEXT:    v_mov_b32_e32 v0, s2
; GFX10-CU-NEXT:    v_mov_b32_e32 v1, s3
; GFX10-CU-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-CU-NEXT:    flat_store_dword v[0:1], v2
; GFX10-CU-NEXT:    s_endpgm
;
; SKIP-CACHE-INV-LABEL: flat_nontemporal_load_1:
; SKIP-CACHE-INV:       ; %bb.0: ; %entry
; SKIP-CACHE-INV-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x9
; SKIP-CACHE-INV-NEXT:    v_lshlrev_b32_e32 v2, 2, v0
; SKIP-CACHE-INV-NEXT:    s_waitcnt lgkmcnt(0)
; SKIP-CACHE-INV-NEXT:    v_mov_b32_e32 v3, s1
; SKIP-CACHE-INV-NEXT:    v_add_i32_e32 v2, vcc, s0, v2
; SKIP-CACHE-INV-NEXT:    v_addc_u32_e32 v3, vcc, 0, v3, vcc
; SKIP-CACHE-INV-NEXT:    flat_load_dword v2, v[2:3] glc
; SKIP-CACHE-INV-NEXT:    s_waitcnt vmcnt(0)
; SKIP-CACHE-INV-NEXT:    v_mov_b32_e32 v0, s2
; SKIP-CACHE-INV-NEXT:    v_mov_b32_e32 v1, s3
; SKIP-CACHE-INV-NEXT:    s_waitcnt lgkmcnt(0)
; SKIP-CACHE-INV-NEXT:    flat_store_dword v[0:1], v2
; SKIP-CACHE-INV-NEXT:    s_endpgm
    i32* %in, i32* %out) {
entry:
  %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %val.gep = getelementptr inbounds i32, i32* %in, i32 %tid
  %val = load volatile i32, i32* %val.gep, align 4
  store i32 %val, i32* %out
  ret void
}

define amdgpu_kernel void @flat_nontemporal_store_0(
; GFX7-LABEL: flat_nontemporal_store_0:
; GFX7:       ; %bb.0: ; %entry
; GFX7-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x0
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    v_mov_b32_e32 v0, s0
; GFX7-NEXT:    v_mov_b32_e32 v1, s1
; GFX7-NEXT:    flat_load_dword v0, v[0:1]
; GFX7-NEXT:    v_mov_b32_e32 v2, s2
; GFX7-NEXT:    v_mov_b32_e32 v3, s3
; GFX7-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX7-NEXT:    flat_store_dword v[2:3], v0
; GFX7-NEXT:    s_waitcnt vmcnt(0)
; GFX7-NEXT:    s_endpgm
;
; GFX10-WGP-LABEL: flat_nontemporal_store_0:
; GFX10-WGP:       ; %bb.0: ; %entry
; GFX10-WGP-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x0
; GFX10-WGP-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-WGP-NEXT:    v_mov_b32_e32 v0, s0
; GFX10-WGP-NEXT:    v_mov_b32_e32 v1, s1
; GFX10-WGP-NEXT:    flat_load_dword v2, v[0:1]
; GFX10-WGP-NEXT:    v_mov_b32_e32 v0, s2
; GFX10-WGP-NEXT:    v_mov_b32_e32 v1, s3
; GFX10-WGP-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX10-WGP-NEXT:    flat_store_dword v[0:1], v2
; GFX10-WGP-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-WGP-NEXT:    s_endpgm
;
; GFX10-CU-LABEL: flat_nontemporal_store_0:
; GFX10-CU:       ; %bb.0: ; %entry
; GFX10-CU-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x0
; GFX10-CU-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-CU-NEXT:    v_mov_b32_e32 v0, s0
; GFX10-CU-NEXT:    v_mov_b32_e32 v1, s1
; GFX10-CU-NEXT:    flat_load_dword v2, v[0:1]
; GFX10-CU-NEXT:    v_mov_b32_e32 v0, s2
; GFX10-CU-NEXT:    v_mov_b32_e32 v1, s3
; GFX10-CU-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX10-CU-NEXT:    flat_store_dword v[0:1], v2
; GFX10-CU-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-CU-NEXT:    s_endpgm
;
; SKIP-CACHE-INV-LABEL: flat_nontemporal_store_0:
; SKIP-CACHE-INV:       ; %bb.0: ; %entry
; SKIP-CACHE-INV-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x9
; SKIP-CACHE-INV-NEXT:    s_waitcnt lgkmcnt(0)
; SKIP-CACHE-INV-NEXT:    v_mov_b32_e32 v0, s0
; SKIP-CACHE-INV-NEXT:    v_mov_b32_e32 v1, s1
; SKIP-CACHE-INV-NEXT:    flat_load_dword v0, v[0:1]
; SKIP-CACHE-INV-NEXT:    v_mov_b32_e32 v2, s2
; SKIP-CACHE-INV-NEXT:    v_mov_b32_e32 v3, s3
; SKIP-CACHE-INV-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; SKIP-CACHE-INV-NEXT:    flat_store_dword v[2:3], v0
; SKIP-CACHE-INV-NEXT:    s_waitcnt vmcnt(0)
; SKIP-CACHE-INV-NEXT:    s_endpgm
    i32* %in, i32* %out) {
entry:
  %val = load i32, i32* %in, align 4
  store volatile i32 %val, i32* %out
  ret void
}

define amdgpu_kernel void @flat_nontemporal_store_1(
; GFX7-LABEL: flat_nontemporal_store_1:
; GFX7:       ; %bb.0: ; %entry
; GFX7-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x0
; GFX7-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    v_mov_b32_e32 v1, s0
; GFX7-NEXT:    v_mov_b32_e32 v2, s1
; GFX7-NEXT:    flat_load_dword v2, v[1:2]
; GFX7-NEXT:    v_mov_b32_e32 v1, s3
; GFX7-NEXT:    v_add_i32_e32 v0, vcc, s2, v0
; GFX7-NEXT:    v_addc_u32_e32 v1, vcc, 0, v1, vcc
; GFX7-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX7-NEXT:    flat_store_dword v[0:1], v2
; GFX7-NEXT:    s_waitcnt vmcnt(0)
; GFX7-NEXT:    s_endpgm
;
; GFX10-WGP-LABEL: flat_nontemporal_store_1:
; GFX10-WGP:       ; %bb.0: ; %entry
; GFX10-WGP-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x0
; GFX10-WGP-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GFX10-WGP-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-WGP-NEXT:    v_mov_b32_e32 v1, s0
; GFX10-WGP-NEXT:    v_mov_b32_e32 v2, s1
; GFX10-WGP-NEXT:    v_add_co_u32 v0, s0, s2, v0
; GFX10-WGP-NEXT:    flat_load_dword v2, v[1:2]
; GFX10-WGP-NEXT:    v_add_co_ci_u32_e64 v1, s0, s3, 0, s0
; GFX10-WGP-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX10-WGP-NEXT:    flat_store_dword v[0:1], v2
; GFX10-WGP-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-WGP-NEXT:    s_endpgm
;
; GFX10-CU-LABEL: flat_nontemporal_store_1:
; GFX10-CU:       ; %bb.0: ; %entry
; GFX10-CU-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x0
; GFX10-CU-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GFX10-CU-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-CU-NEXT:    v_mov_b32_e32 v1, s0
; GFX10-CU-NEXT:    v_mov_b32_e32 v2, s1
; GFX10-CU-NEXT:    v_add_co_u32 v0, s0, s2, v0
; GFX10-CU-NEXT:    flat_load_dword v2, v[1:2]
; GFX10-CU-NEXT:    v_add_co_ci_u32_e64 v1, s0, s3, 0, s0
; GFX10-CU-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX10-CU-NEXT:    flat_store_dword v[0:1], v2
; GFX10-CU-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-CU-NEXT:    s_endpgm
;
; SKIP-CACHE-INV-LABEL: flat_nontemporal_store_1:
; SKIP-CACHE-INV:       ; %bb.0: ; %entry
; SKIP-CACHE-INV-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x9
; SKIP-CACHE-INV-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; SKIP-CACHE-INV-NEXT:    s_waitcnt lgkmcnt(0)
; SKIP-CACHE-INV-NEXT:    v_mov_b32_e32 v1, s0
; SKIP-CACHE-INV-NEXT:    v_mov_b32_e32 v2, s1
; SKIP-CACHE-INV-NEXT:    flat_load_dword v2, v[1:2]
; SKIP-CACHE-INV-NEXT:    v_mov_b32_e32 v1, s3
; SKIP-CACHE-INV-NEXT:    v_add_i32_e32 v0, vcc, s2, v0
; SKIP-CACHE-INV-NEXT:    v_addc_u32_e32 v1, vcc, 0, v1, vcc
; SKIP-CACHE-INV-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; SKIP-CACHE-INV-NEXT:    flat_store_dword v[0:1], v2
; SKIP-CACHE-INV-NEXT:    s_waitcnt vmcnt(0)
; SKIP-CACHE-INV-NEXT:    s_endpgm
    i32* %in, i32* %out) {
entry:
  %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %val = load i32, i32* %in, align 4
  %out.gep = getelementptr inbounds i32, i32* %out, i32 %tid
  store volatile i32 %val, i32* %out.gep
  ret void
}

define amdgpu_kernel void @flat_volatile_workgroup_acquire_load(
; GFX7-LABEL: flat_volatile_workgroup_acquire_load:
; GFX7:       ; %bb.0: ; %entry
; GFX7-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x0
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    v_mov_b32_e32 v0, s0
; GFX7-NEXT:    v_mov_b32_e32 v1, s1
; GFX7-NEXT:    flat_load_dword v0, v[0:1]
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    v_mov_b32_e32 v2, s2
; GFX7-NEXT:    v_mov_b32_e32 v3, s3
; GFX7-NEXT:    s_waitcnt vmcnt(0)
; GFX7-NEXT:    flat_store_dword v[2:3], v0
; GFX7-NEXT:    s_endpgm
;
; GFX10-WGP-LABEL: flat_volatile_workgroup_acquire_load:
; GFX10-WGP:       ; %bb.0: ; %entry
; GFX10-WGP-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x0
; GFX10-WGP-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-WGP-NEXT:    v_mov_b32_e32 v0, s0
; GFX10-WGP-NEXT:    v_mov_b32_e32 v1, s1
; GFX10-WGP-NEXT:    flat_load_dword v2, v[0:1] glc
; GFX10-WGP-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX10-WGP-NEXT:    buffer_gl0_inv
; GFX10-WGP-NEXT:    v_mov_b32_e32 v0, s2
; GFX10-WGP-NEXT:    v_mov_b32_e32 v1, s3
; GFX10-WGP-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-WGP-NEXT:    flat_store_dword v[0:1], v2
; GFX10-WGP-NEXT:    s_endpgm
;
; GFX10-CU-LABEL: flat_volatile_workgroup_acquire_load:
; GFX10-CU:       ; %bb.0: ; %entry
; GFX10-CU-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x0
; GFX10-CU-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-CU-NEXT:    v_mov_b32_e32 v0, s0
; GFX10-CU-NEXT:    v_mov_b32_e32 v1, s1
; GFX10-CU-NEXT:    flat_load_dword v2, v[0:1]
; GFX10-CU-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-CU-NEXT:    v_mov_b32_e32 v0, s2
; GFX10-CU-NEXT:    v_mov_b32_e32 v1, s3
; GFX10-CU-NEXT:    s_waitcnt vmcnt(0)
; GFX10-CU-NEXT:    flat_store_dword v[0:1], v2
; GFX10-CU-NEXT:    s_endpgm
;
; SKIP-CACHE-INV-LABEL: flat_volatile_workgroup_acquire_load:
; SKIP-CACHE-INV:       ; %bb.0: ; %entry
; SKIP-CACHE-INV-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x9
; SKIP-CACHE-INV-NEXT:    s_waitcnt lgkmcnt(0)
; SKIP-CACHE-INV-NEXT:    v_mov_b32_e32 v0, s0
; SKIP-CACHE-INV-NEXT:    v_mov_b32_e32 v1, s1
; SKIP-CACHE-INV-NEXT:    flat_load_dword v0, v[0:1]
; SKIP-CACHE-INV-NEXT:    s_waitcnt lgkmcnt(0)
; SKIP-CACHE-INV-NEXT:    v_mov_b32_e32 v2, s2
; SKIP-CACHE-INV-NEXT:    v_mov_b32_e32 v3, s3
; SKIP-CACHE-INV-NEXT:    s_waitcnt vmcnt(0)
; SKIP-CACHE-INV-NEXT:    flat_store_dword v[2:3], v0
; SKIP-CACHE-INV-NEXT:    s_endpgm
    i32* %in, i32* %out) {
entry:
  %val = load atomic volatile i32, i32* %in syncscope("workgroup") acquire, align 4
  store i32 %val, i32* %out
  ret void
}

define amdgpu_kernel void @flat_volatile_workgroup_release_store(
; GFX7-LABEL: flat_volatile_workgroup_release_store:
; GFX7:       ; %bb.0: ; %entry
; GFX7-NEXT:    s_load_dword s2, s[4:5], 0x0
; GFX7-NEXT:    s_load_dwordx2 s[0:1], s[4:5], 0x2
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    v_mov_b32_e32 v2, s2
; GFX7-NEXT:    v_mov_b32_e32 v0, s0
; GFX7-NEXT:    v_mov_b32_e32 v1, s1
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    flat_store_dword v[0:1], v2
; GFX7-NEXT:    s_endpgm
;
; GFX10-WGP-LABEL: flat_volatile_workgroup_release_store:
; GFX10-WGP:       ; %bb.0: ; %entry
; GFX10-WGP-NEXT:    s_clause 0x1
; GFX10-WGP-NEXT:    s_load_dwordx2 s[0:1], s[4:5], 0x8
; GFX10-WGP-NEXT:    s_load_dword s2, s[4:5], 0x0
; GFX10-WGP-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-WGP-NEXT:    v_mov_b32_e32 v0, s0
; GFX10-WGP-NEXT:    v_mov_b32_e32 v1, s1
; GFX10-WGP-NEXT:    v_mov_b32_e32 v2, s2
; GFX10-WGP-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX10-WGP-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-WGP-NEXT:    flat_store_dword v[0:1], v2
; GFX10-WGP-NEXT:    s_endpgm
;
; GFX10-CU-LABEL: flat_volatile_workgroup_release_store:
; GFX10-CU:       ; %bb.0: ; %entry
; GFX10-CU-NEXT:    s_clause 0x1
; GFX10-CU-NEXT:    s_load_dwordx2 s[0:1], s[4:5], 0x8
; GFX10-CU-NEXT:    s_load_dword s2, s[4:5], 0x0
; GFX10-CU-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-CU-NEXT:    v_mov_b32_e32 v0, s0
; GFX10-CU-NEXT:    v_mov_b32_e32 v1, s1
; GFX10-CU-NEXT:    v_mov_b32_e32 v2, s2
; GFX10-CU-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-CU-NEXT:    flat_store_dword v[0:1], v2
; GFX10-CU-NEXT:    s_endpgm
;
; SKIP-CACHE-INV-LABEL: flat_volatile_workgroup_release_store:
; SKIP-CACHE-INV:       ; %bb.0: ; %entry
; SKIP-CACHE-INV-NEXT:    s_load_dword s2, s[0:1], 0x9
; SKIP-CACHE-INV-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0xb
; SKIP-CACHE-INV-NEXT:    s_waitcnt lgkmcnt(0)
; SKIP-CACHE-INV-NEXT:    v_mov_b32_e32 v2, s2
; SKIP-CACHE-INV-NEXT:    v_mov_b32_e32 v0, s0
; SKIP-CACHE-INV-NEXT:    v_mov_b32_e32 v1, s1
; SKIP-CACHE-INV-NEXT:    s_waitcnt lgkmcnt(0)
; SKIP-CACHE-INV-NEXT:    flat_store_dword v[0:1], v2
; SKIP-CACHE-INV-NEXT:    s_endpgm
   i32 %in, i32* %out) {
entry:
  store atomic volatile i32 %in, i32* %out syncscope("workgroup") release, align 4
  ret void
}

declare i32 @llvm.amdgcn.workitem.id.x()
