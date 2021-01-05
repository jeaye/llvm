; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-amd-amdpal -mcpu=gfx900 < %s | FileCheck --check-prefix=GFX9 %s
; RUN: llc -global-isel -mtriple=amdgcn-amd-amdpal -mcpu=fiji < %s | FileCheck --check-prefix=GFX8 %s
; RUN: llc -global-isel -mtriple=amdgcn-amd-amdpal -mcpu=tahiti < %s | FileCheck --check-prefix=GFX6 %s

define i64 @zextload_global_i1_to_i64(i1 addrspace(1)* %ptr) {
; GFX9-LABEL: zextload_global_i1_to_i64:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    global_load_ubyte v0, v[0:1], off
; GFX9-NEXT:    v_mov_b32_e32 v1, 0
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_and_b32_e32 v0, 1, v0
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: zextload_global_i1_to_i64:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    flat_load_ubyte v0, v[0:1]
; GFX8-NEXT:    v_mov_b32_e32 v1, 0
; GFX8-NEXT:    s_waitcnt vmcnt(0)
; GFX8-NEXT:    v_and_b32_e32 v0, 1, v0
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX6-LABEL: zextload_global_i1_to_i64:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    s_mov_b32 s6, 0
; GFX6-NEXT:    s_mov_b32 s7, 0xf000
; GFX6-NEXT:    s_mov_b64 s[4:5], 0
; GFX6-NEXT:    buffer_load_ubyte v0, v[0:1], s[4:7], 0 addr64
; GFX6-NEXT:    v_mov_b32_e32 v1, 0
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    v_and_b32_e32 v0, 1, v0
; GFX6-NEXT:    s_setpc_b64 s[30:31]
  %load = load i1, i1 addrspace(1)* %ptr
  %ext = zext i1 %load to i64
  ret i64 %ext
}

define i64 @zextload_global_i8_to_i64(i8 addrspace(1)* %ptr) {
; GFX9-LABEL: zextload_global_i8_to_i64:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    global_load_ubyte v0, v[0:1], off
; GFX9-NEXT:    v_mov_b32_e32 v1, 0
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: zextload_global_i8_to_i64:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    flat_load_ubyte v0, v[0:1]
; GFX8-NEXT:    v_mov_b32_e32 v1, 0
; GFX8-NEXT:    s_waitcnt vmcnt(0)
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX6-LABEL: zextload_global_i8_to_i64:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    s_mov_b32 s6, 0
; GFX6-NEXT:    s_mov_b32 s7, 0xf000
; GFX6-NEXT:    s_mov_b64 s[4:5], 0
; GFX6-NEXT:    buffer_load_ubyte v0, v[0:1], s[4:7], 0 addr64
; GFX6-NEXT:    v_mov_b32_e32 v1, 0
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    s_setpc_b64 s[30:31]
  %load = load i8, i8 addrspace(1)* %ptr
  %ext = zext i8 %load to i64
  ret i64 %ext
}

define i64 @zextload_global_i16_to_i64(i16 addrspace(1)* %ptr) {
; GFX9-LABEL: zextload_global_i16_to_i64:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    global_load_ushort v0, v[0:1], off
; GFX9-NEXT:    v_mov_b32_e32 v1, 0
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: zextload_global_i16_to_i64:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    flat_load_ushort v0, v[0:1]
; GFX8-NEXT:    v_mov_b32_e32 v1, 0
; GFX8-NEXT:    s_waitcnt vmcnt(0)
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX6-LABEL: zextload_global_i16_to_i64:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    s_mov_b32 s6, 0
; GFX6-NEXT:    s_mov_b32 s7, 0xf000
; GFX6-NEXT:    s_mov_b64 s[4:5], 0
; GFX6-NEXT:    buffer_load_ushort v0, v[0:1], s[4:7], 0 addr64
; GFX6-NEXT:    v_mov_b32_e32 v1, 0
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    s_setpc_b64 s[30:31]
  %load = load i16, i16 addrspace(1)* %ptr
  %ext = zext i16 %load to i64
  ret i64 %ext
}

define i64 @zextload_global_i32_to_i64(i32 addrspace(1)* %ptr) {
; GFX9-LABEL: zextload_global_i32_to_i64:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    global_load_dword v0, v[0:1], off
; GFX9-NEXT:    v_mov_b32_e32 v1, 0
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: zextload_global_i32_to_i64:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    flat_load_dword v0, v[0:1]
; GFX8-NEXT:    v_mov_b32_e32 v1, 0
; GFX8-NEXT:    s_waitcnt vmcnt(0)
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX6-LABEL: zextload_global_i32_to_i64:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    s_mov_b32 s6, 0
; GFX6-NEXT:    s_mov_b32 s7, 0xf000
; GFX6-NEXT:    s_mov_b64 s[4:5], 0
; GFX6-NEXT:    buffer_load_dword v0, v[0:1], s[4:7], 0 addr64
; GFX6-NEXT:    v_mov_b32_e32 v1, 0
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    s_setpc_b64 s[30:31]
  %load = load i32, i32 addrspace(1)* %ptr
  %ext = zext i32 %load to i64
  ret i64 %ext
}

define i96 @zextload_global_i32_to_i96(i32 addrspace(1)* %ptr) {
; GFX9-LABEL: zextload_global_i32_to_i96:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    global_load_dword v0, v[0:1], off
; GFX9-NEXT:    v_mov_b32_e32 v1, 0
; GFX9-NEXT:    v_mov_b32_e32 v2, 0
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: zextload_global_i32_to_i96:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    flat_load_dword v0, v[0:1]
; GFX8-NEXT:    v_mov_b32_e32 v1, 0
; GFX8-NEXT:    v_mov_b32_e32 v2, 0
; GFX8-NEXT:    s_waitcnt vmcnt(0)
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX6-LABEL: zextload_global_i32_to_i96:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    s_mov_b32 s6, 0
; GFX6-NEXT:    s_mov_b32 s7, 0xf000
; GFX6-NEXT:    s_mov_b64 s[4:5], 0
; GFX6-NEXT:    buffer_load_dword v0, v[0:1], s[4:7], 0 addr64
; GFX6-NEXT:    v_mov_b32_e32 v1, 0
; GFX6-NEXT:    v_mov_b32_e32 v2, 0
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    s_setpc_b64 s[30:31]
  %load = load i32, i32 addrspace(1)* %ptr
  %ext = zext i32 %load to i96
  ret i96 %ext
}

define i128 @zextload_global_i32_to_i128(i32 addrspace(1)* %ptr) {
; GFX9-LABEL: zextload_global_i32_to_i128:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    global_load_dword v0, v[0:1], off
; GFX9-NEXT:    v_mov_b32_e32 v1, 0
; GFX9-NEXT:    v_mov_b32_e32 v2, 0
; GFX9-NEXT:    v_mov_b32_e32 v3, 0
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: zextload_global_i32_to_i128:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    flat_load_dword v0, v[0:1]
; GFX8-NEXT:    v_mov_b32_e32 v1, 0
; GFX8-NEXT:    v_mov_b32_e32 v2, 0
; GFX8-NEXT:    v_mov_b32_e32 v3, 0
; GFX8-NEXT:    s_waitcnt vmcnt(0)
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX6-LABEL: zextload_global_i32_to_i128:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    s_mov_b32 s6, 0
; GFX6-NEXT:    s_mov_b32 s7, 0xf000
; GFX6-NEXT:    s_mov_b64 s[4:5], 0
; GFX6-NEXT:    buffer_load_dword v0, v[0:1], s[4:7], 0 addr64
; GFX6-NEXT:    v_mov_b32_e32 v1, 0
; GFX6-NEXT:    v_mov_b32_e32 v2, 0
; GFX6-NEXT:    v_mov_b32_e32 v3, 0
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    s_setpc_b64 s[30:31]
  %load = load i32, i32 addrspace(1)* %ptr
  %ext = zext i32 %load to i128
  ret i128 %ext
}
