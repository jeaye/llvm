; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx900 -verify-machineinstrs < %s | FileCheck -check-prefix=GCN %s

; SelectionDAG builder was using the IR value kind to decide how to
; split the types for copyToRegs/copyFromRegs in all contexts. This
; was incorrect if the ABI-like value such as a call was used outside
; of the block. The value in that case is not used directly, but
; through another set of copies to potentially different register
; types in the parent block.

; This would then end up producing inconsistent pairs of copies with
; the wrong sizes when the vector type result from the call was split
; into multiple pieces, but expected to be a single register in the
; cross-block copy.
;
; This isn't exactly ideal for AMDGPU, since in reality the
; intermediate vector register type is undesirable anyway, but it
; requires more work to be able to split all vector copies in all
; contexts.
;
; This was only an issue if the value was used directly in another
; block. If there was an intermediate operation or a phi it was fine,
; since that didn't look like an ABI copy.


define float @call_split_type_used_outside_block_v2f32() #0 {
; GCN-LABEL: call_split_type_used_outside_block_v2f32:
; GCN:       ; %bb.0: ; %bb0
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    s_mov_b32 s5, s32
; GCN-NEXT:    s_add_u32 s32, s32, 0x400
; GCN-NEXT:    s_or_saveexec_b64 s[6:7], -1
; GCN-NEXT:    buffer_store_dword v32, off, s[0:3], s5 ; 4-byte Folded Spill
; GCN-NEXT:    s_mov_b64 exec, s[6:7]
; GCN-NEXT:    v_writelane_b32 v32, s34, 0
; GCN-NEXT:    v_writelane_b32 v32, s35, 1
; GCN-NEXT:    v_writelane_b32 v32, s36, 2
; GCN-NEXT:    s_getpc_b64 s[6:7]
; GCN-NEXT:    s_add_u32 s6, s6, func_v2f32@rel32@lo+4
; GCN-NEXT:    s_addc_u32 s7, s7, func_v2f32@rel32@hi+4
; GCN-NEXT:    s_mov_b64 s[34:35], s[30:31]
; GCN-NEXT:    s_mov_b32 s36, s5
; GCN-NEXT:    s_swappc_b64 s[30:31], s[6:7]
; GCN-NEXT:    s_mov_b32 s5, s36
; GCN-NEXT:    s_mov_b64 s[30:31], s[34:35]
; GCN-NEXT:    v_readlane_b32 s36, v32, 2
; GCN-NEXT:    v_readlane_b32 s35, v32, 1
; GCN-NEXT:    v_readlane_b32 s34, v32, 0
; GCN-NEXT:    s_or_saveexec_b64 s[6:7], -1
; GCN-NEXT:    buffer_load_dword v32, off, s[0:3], s5 ; 4-byte Folded Reload
; GCN-NEXT:    s_mov_b64 exec, s[6:7]
; GCN-NEXT:    s_sub_u32 s32, s32, 0x400
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    s_setpc_b64 s[30:31]
bb0:
  %split.ret.type = call <2 x float> @func_v2f32()
  br label %bb1

bb1:
  %extract = extractelement <2 x float> %split.ret.type, i32 0
  ret float %extract
}

define float @call_split_type_used_outside_block_v3f32() #0 {
; GCN-LABEL: call_split_type_used_outside_block_v3f32:
; GCN:       ; %bb.0: ; %bb0
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    s_mov_b32 s5, s32
; GCN-NEXT:    s_add_u32 s32, s32, 0x400
; GCN-NEXT:    s_or_saveexec_b64 s[6:7], -1
; GCN-NEXT:    buffer_store_dword v32, off, s[0:3], s5 ; 4-byte Folded Spill
; GCN-NEXT:    s_mov_b64 exec, s[6:7]
; GCN-NEXT:    v_writelane_b32 v32, s34, 0
; GCN-NEXT:    v_writelane_b32 v32, s35, 1
; GCN-NEXT:    v_writelane_b32 v32, s36, 2
; GCN-NEXT:    s_getpc_b64 s[6:7]
; GCN-NEXT:    s_add_u32 s6, s6, func_v3f32@rel32@lo+4
; GCN-NEXT:    s_addc_u32 s7, s7, func_v3f32@rel32@hi+4
; GCN-NEXT:    s_mov_b64 s[34:35], s[30:31]
; GCN-NEXT:    s_mov_b32 s36, s5
; GCN-NEXT:    s_swappc_b64 s[30:31], s[6:7]
; GCN-NEXT:    s_mov_b32 s5, s36
; GCN-NEXT:    s_mov_b64 s[30:31], s[34:35]
; GCN-NEXT:    v_readlane_b32 s36, v32, 2
; GCN-NEXT:    v_readlane_b32 s35, v32, 1
; GCN-NEXT:    v_readlane_b32 s34, v32, 0
; GCN-NEXT:    s_or_saveexec_b64 s[6:7], -1
; GCN-NEXT:    buffer_load_dword v32, off, s[0:3], s5 ; 4-byte Folded Reload
; GCN-NEXT:    s_mov_b64 exec, s[6:7]
; GCN-NEXT:    s_sub_u32 s32, s32, 0x400
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    s_setpc_b64 s[30:31]
bb0:
  %split.ret.type = call <3 x float> @func_v3f32()
  br label %bb1

bb1:
  %extract = extractelement <3 x float> %split.ret.type, i32 0
  ret float %extract
}

define half @call_split_type_used_outside_block_v4f16() #0 {
; GCN-LABEL: call_split_type_used_outside_block_v4f16:
; GCN:       ; %bb.0: ; %bb0
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    s_mov_b32 s5, s32
; GCN-NEXT:    s_add_u32 s32, s32, 0x400
; GCN-NEXT:    s_or_saveexec_b64 s[6:7], -1
; GCN-NEXT:    buffer_store_dword v32, off, s[0:3], s5 ; 4-byte Folded Spill
; GCN-NEXT:    s_mov_b64 exec, s[6:7]
; GCN-NEXT:    v_writelane_b32 v32, s34, 0
; GCN-NEXT:    v_writelane_b32 v32, s35, 1
; GCN-NEXT:    v_writelane_b32 v32, s36, 2
; GCN-NEXT:    s_getpc_b64 s[6:7]
; GCN-NEXT:    s_add_u32 s6, s6, func_v4f16@rel32@lo+4
; GCN-NEXT:    s_addc_u32 s7, s7, func_v4f16@rel32@hi+4
; GCN-NEXT:    s_mov_b64 s[34:35], s[30:31]
; GCN-NEXT:    s_mov_b32 s36, s5
; GCN-NEXT:    s_swappc_b64 s[30:31], s[6:7]
; GCN-NEXT:    s_mov_b32 s5, s36
; GCN-NEXT:    s_mov_b64 s[30:31], s[34:35]
; GCN-NEXT:    v_readlane_b32 s36, v32, 2
; GCN-NEXT:    v_readlane_b32 s35, v32, 1
; GCN-NEXT:    v_readlane_b32 s34, v32, 0
; GCN-NEXT:    s_or_saveexec_b64 s[6:7], -1
; GCN-NEXT:    buffer_load_dword v32, off, s[0:3], s5 ; 4-byte Folded Reload
; GCN-NEXT:    s_mov_b64 exec, s[6:7]
; GCN-NEXT:    s_sub_u32 s32, s32, 0x400
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    s_setpc_b64 s[30:31]
bb0:
  %split.ret.type = call <4 x half> @func_v4f16()
  br label %bb1

bb1:
  %extract = extractelement <4 x half> %split.ret.type, i32 0
  ret half %extract
}

define { i32, half } @call_split_type_used_outside_block_struct() #0 {
; GCN-LABEL: call_split_type_used_outside_block_struct:
; GCN:       ; %bb.0: ; %bb0
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    s_mov_b32 s5, s32
; GCN-NEXT:    s_add_u32 s32, s32, 0x400
; GCN-NEXT:    s_or_saveexec_b64 s[6:7], -1
; GCN-NEXT:    buffer_store_dword v32, off, s[0:3], s5 ; 4-byte Folded Spill
; GCN-NEXT:    s_mov_b64 exec, s[6:7]
; GCN-NEXT:    v_writelane_b32 v32, s34, 0
; GCN-NEXT:    v_writelane_b32 v32, s35, 1
; GCN-NEXT:    v_writelane_b32 v32, s36, 2
; GCN-NEXT:    s_getpc_b64 s[6:7]
; GCN-NEXT:    s_add_u32 s6, s6, func_struct@rel32@lo+4
; GCN-NEXT:    s_addc_u32 s7, s7, func_struct@rel32@hi+4
; GCN-NEXT:    s_mov_b64 s[34:35], s[30:31]
; GCN-NEXT:    s_mov_b32 s36, s5
; GCN-NEXT:    s_swappc_b64 s[30:31], s[6:7]
; GCN-NEXT:    s_mov_b32 s5, s36
; GCN-NEXT:    v_mov_b32_e32 v1, v4
; GCN-NEXT:    s_mov_b64 s[30:31], s[34:35]
; GCN-NEXT:    v_readlane_b32 s36, v32, 2
; GCN-NEXT:    v_readlane_b32 s35, v32, 1
; GCN-NEXT:    v_readlane_b32 s34, v32, 0
; GCN-NEXT:    s_or_saveexec_b64 s[6:7], -1
; GCN-NEXT:    buffer_load_dword v32, off, s[0:3], s5 ; 4-byte Folded Reload
; GCN-NEXT:    s_mov_b64 exec, s[6:7]
; GCN-NEXT:    s_sub_u32 s32, s32, 0x400
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    s_setpc_b64 s[30:31]
bb0:
  %split.ret.type = call { <4 x i32>, <4 x half> } @func_struct()
  br label %bb1

bb1:
  %val0 = extractvalue { <4 x i32>, <4 x half> } %split.ret.type, 0
  %val1 = extractvalue { <4 x i32>, <4 x half> } %split.ret.type, 1
  %extract0 = extractelement <4 x i32> %val0, i32 0
  %extract1 = extractelement <4 x half> %val1, i32 0
  %ins0 = insertvalue { i32, half } undef, i32 %extract0, 0
  %ins1 = insertvalue { i32, half } %ins0, half %extract1, 1
  ret { i32, half } %ins1
}


declare hidden <2 x float> @func_v2f32() #0
declare hidden <3 x float> @func_v3f32() #0
declare hidden <4 x float> @func_v4f32() #0
declare hidden <4 x half> @func_v4f16() #0

declare hidden { <4 x i32>, <4 x half> } @func_struct() #0

attributes #0 = { nounwind}
