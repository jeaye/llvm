; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx900 < %s | FileCheck -enable-var-scope -check-prefix=GCN %s

; Load argument depends on waitcnt which should be skipped.
define amdgpu_kernel void @call_memory_arg_load(i32 addrspace(3)* %ptr, i32) #0 {
; GCN-LABEL: call_memory_arg_load:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dword s4, s[4:5], 0x0
; GCN-NEXT:    s_mov_b32 s33, s9
; GCN-NEXT:    s_add_u32 flat_scratch_lo, s6, s33
; GCN-NEXT:    s_addc_u32 flat_scratch_hi, s7, 0
; GCN-NEXT:    s_mov_b32 s32, s33
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    v_mov_b32_e32 v0, s4
; GCN-NEXT:    ds_read_b32 v0, v0
; GCN-NEXT:    s_getpc_b64 s[4:5]
; GCN-NEXT:    s_add_u32 s4, s4, func@rel32@lo+4
; GCN-NEXT:    s_addc_u32 s5, s5, func@rel32@hi+4
; GCN-NEXT:    s_swappc_b64 s[30:31], s[4:5]
; GCN-NEXT:    s_endpgm
  %vgpr = load volatile i32, i32 addrspace(3)* %ptr
  call void @func(i32 %vgpr)
  ret void
}

; Memory waitcnt with no register dependence on the call
define amdgpu_kernel void @call_memory_no_dep(i32 addrspace(1)* %ptr, i32) #0 {
; GCN-LABEL: call_memory_no_dep:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dwordx2 s[4:5], s[4:5], 0x0
; GCN-NEXT:    s_mov_b32 s33, s9
; GCN-NEXT:    s_add_u32 flat_scratch_lo, s6, s33
; GCN-NEXT:    v_mov_b32_e32 v2, 0
; GCN-NEXT:    s_addc_u32 flat_scratch_hi, s7, 0
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    v_mov_b32_e32 v0, s4
; GCN-NEXT:    v_mov_b32_e32 v1, s5
; GCN-NEXT:    global_store_dword v[0:1], v2, off
; GCN-NEXT:    v_mov_b32_e32 v0, 0
; GCN-NEXT:    s_getpc_b64 s[6:7]
; GCN-NEXT:    s_add_u32 s6, s6, func@rel32@lo+4
; GCN-NEXT:    s_addc_u32 s7, s7, func@rel32@hi+4
; GCN-NEXT:    s_mov_b32 s32, s33
; GCN-NEXT:    s_swappc_b64 s[30:31], s[6:7]
; GCN-NEXT:    s_endpgm
  store i32 0, i32 addrspace(1)* %ptr
  call void @func(i32 0)
  ret void
}

; Should not wait after the call before memory
define amdgpu_kernel void @call_no_wait_after_call(i32 addrspace(1)* %ptr, i32) #0 {
; GCN-LABEL: call_no_wait_after_call:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dwordx2 s[34:35], s[4:5], 0x0
; GCN-NEXT:    s_mov_b32 s33, s9
; GCN-NEXT:    s_add_u32 flat_scratch_lo, s6, s33
; GCN-NEXT:    s_addc_u32 flat_scratch_hi, s7, 0
; GCN-NEXT:    v_mov_b32_e32 v0, 0
; GCN-NEXT:    s_getpc_b64 s[4:5]
; GCN-NEXT:    s_add_u32 s4, s4, func@rel32@lo+4
; GCN-NEXT:    s_addc_u32 s5, s5, func@rel32@hi+4
; GCN-NEXT:    s_mov_b32 s32, s33
; GCN-NEXT:    v_mov_b32_e32 v32, 0
; GCN-NEXT:    s_swappc_b64 s[30:31], s[4:5]
; GCN-NEXT:    v_mov_b32_e32 v0, s34
; GCN-NEXT:    v_mov_b32_e32 v1, s35
; GCN-NEXT:    global_store_dword v[0:1], v32, off
; GCN-NEXT:    s_endpgm
  call void @func(i32 0)
  store i32 0, i32 addrspace(1)* %ptr
  ret void
}

define amdgpu_kernel void @call_no_wait_after_call_return_val(i32 addrspace(1)* %ptr, i32) #0 {
; GCN-LABEL: call_no_wait_after_call_return_val:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dwordx2 s[34:35], s[4:5], 0x0
; GCN-NEXT:    s_mov_b32 s33, s9
; GCN-NEXT:    s_add_u32 flat_scratch_lo, s6, s33
; GCN-NEXT:    s_addc_u32 flat_scratch_hi, s7, 0
; GCN-NEXT:    v_mov_b32_e32 v0, 0
; GCN-NEXT:    s_getpc_b64 s[4:5]
; GCN-NEXT:    s_add_u32 s4, s4, func.return@rel32@lo+4
; GCN-NEXT:    s_addc_u32 s5, s5, func.return@rel32@hi+4
; GCN-NEXT:    s_mov_b32 s32, s33
; GCN-NEXT:    s_swappc_b64 s[30:31], s[4:5]
; GCN-NEXT:    v_mov_b32_e32 v1, s34
; GCN-NEXT:    v_mov_b32_e32 v2, s35
; GCN-NEXT:    global_store_dword v[1:2], v0, off
; GCN-NEXT:    s_endpgm
  %rv = call i32 @func.return(i32 0)
  store i32 %rv, i32 addrspace(1)* %ptr
  ret void
}

; Need to wait for the address dependency
define amdgpu_kernel void @call_got_load(i32 addrspace(1)* %ptr, i32) #0 {
; GCN-LABEL: call_got_load:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_mov_b32 s33, s9
; GCN-NEXT:    s_add_u32 flat_scratch_lo, s6, s33
; GCN-NEXT:    s_addc_u32 flat_scratch_hi, s7, 0
; GCN-NEXT:    s_getpc_b64 s[4:5]
; GCN-NEXT:    s_add_u32 s4, s4, got.func@gotpcrel32@lo+4
; GCN-NEXT:    s_addc_u32 s5, s5, got.func@gotpcrel32@hi+4
; GCN-NEXT:    s_load_dwordx2 s[4:5], s[4:5], 0x0
; GCN-NEXT:    v_mov_b32_e32 v0, 0
; GCN-NEXT:    s_mov_b32 s32, s33
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_swappc_b64 s[30:31], s[4:5]
; GCN-NEXT:    s_endpgm
  call void @got.func(i32 0)
  ret void
}

; Need to wait for the address dependency
define void @tailcall_got_load(i32 addrspace(1)* %ptr, i32) #0 {
; GCN-LABEL: tailcall_got_load:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    s_getpc_b64 s[6:7]
; GCN-NEXT:    s_add_u32 s6, s6, got.func@gotpcrel32@lo+4
; GCN-NEXT:    s_addc_u32 s7, s7, got.func@gotpcrel32@hi+4
; GCN-NEXT:    s_load_dwordx2 s[6:7], s[6:7], 0x0
; GCN-NEXT:    v_mov_b32_e32 v0, 0
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_setpc_b64 s[6:7]
  tail call void @got.func(i32 0)
  ret void
}

; No need to wait for the load.
define void @tail_call_memory_arg_load(i32 addrspace(3)* %ptr, i32) #0 {
; GCN-LABEL: tail_call_memory_arg_load:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    ds_read_b32 v0, v0
; GCN-NEXT:    s_getpc_b64 s[6:7]
; GCN-NEXT:    s_add_u32 s6, s6, func@rel32@lo+4
; GCN-NEXT:    s_addc_u32 s7, s7, func@rel32@hi+4
; GCN-NEXT:    s_setpc_b64 s[6:7]
  %vgpr = load volatile i32, i32 addrspace(3)* %ptr
  tail call void @func(i32 %vgpr)
  ret void
}

declare hidden void @func(i32) #0
declare hidden i32 @func.return(i32) #0
declare void @got.func(i32) #0

attributes #0 = { nounwind }
