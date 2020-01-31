; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -amdgpu-scalarize-global-loads=false  -march=amdgcn -mattr=-flat-for-global -verify-machineinstrs | FileCheck %s -check-prefixes=GCN,SI
; RUN: llc < %s -amdgpu-scalarize-global-loads=false  -march=amdgcn -mcpu=tonga -mattr=-flat-for-global -verify-machineinstrs | FileCheck %s -check-prefixes=GCN,VI

; XXX - Why the packing?
define amdgpu_kernel void @scalar_to_vector_v2i32(<4 x i16> addrspace(1)* %out, i32 addrspace(1)* %in) nounwind {
; SI-LABEL: scalar_to_vector_v2i32:
; SI:       ; %bb.0:
; SI-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x9
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    s_mov_b32 s10, s6
; SI-NEXT:    s_mov_b32 s11, s7
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_mov_b32 s8, s2
; SI-NEXT:    s_mov_b32 s9, s3
; SI-NEXT:    buffer_load_dword v0, off, s[8:11], 0
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    v_lshrrev_b32_e32 v0, 16, v0
; SI-NEXT:    v_lshlrev_b32_e32 v1, 16, v0
; SI-NEXT:    v_or_b32_e32 v0, v0, v1
; SI-NEXT:    s_mov_b32 s4, s0
; SI-NEXT:    s_mov_b32 s5, s1
; SI-NEXT:    v_mov_b32_e32 v1, v0
; SI-NEXT:    buffer_store_dwordx2 v[0:1], off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: scalar_to_vector_v2i32:
; VI:       ; %bb.0:
; VI-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; VI-NEXT:    s_mov_b32 s3, 0xf000
; VI-NEXT:    s_mov_b32 s2, -1
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    s_mov_b32 s0, s4
; VI-NEXT:    s_mov_b32 s1, s5
; VI-NEXT:    s_mov_b32 s4, s6
; VI-NEXT:    s_mov_b32 s5, s7
; VI-NEXT:    s_mov_b32 s6, s2
; VI-NEXT:    s_mov_b32 s7, s3
; VI-NEXT:    buffer_load_dword v0, off, s[4:7], 0
; VI-NEXT:    s_waitcnt vmcnt(0)
; VI-NEXT:    v_lshrrev_b32_e32 v0, 16, v0
; VI-NEXT:    v_lshlrev_b32_e32 v1, 16, v0
; VI-NEXT:    v_or_b32_e32 v0, v0, v1
; VI-NEXT:    v_mov_b32_e32 v1, v0
; VI-NEXT:    buffer_store_dwordx2 v[0:1], off, s[0:3], 0
; VI-NEXT:    s_endpgm
  %tmp1 = load i32, i32 addrspace(1)* %in, align 4
  %bc = bitcast i32 %tmp1 to <2 x i16>
  %tmp2 = shufflevector <2 x i16> %bc, <2 x i16> undef, <4 x i32> <i32 1, i32 1, i32 1, i32 1>
  store <4 x i16> %tmp2, <4 x i16> addrspace(1)* %out, align 8
  ret void
}

define amdgpu_kernel void @scalar_to_vector_v2f32(<4 x i16> addrspace(1)* %out, float addrspace(1)* %in) nounwind {
; SI-LABEL: scalar_to_vector_v2f32:
; SI:       ; %bb.0:
; SI-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x9
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    s_mov_b32 s10, s6
; SI-NEXT:    s_mov_b32 s11, s7
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_mov_b32 s8, s2
; SI-NEXT:    s_mov_b32 s9, s3
; SI-NEXT:    buffer_load_dword v0, off, s[8:11], 0
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    v_lshrrev_b32_e32 v0, 16, v0
; SI-NEXT:    v_lshlrev_b32_e32 v1, 16, v0
; SI-NEXT:    v_or_b32_e32 v0, v0, v1
; SI-NEXT:    s_mov_b32 s4, s0
; SI-NEXT:    s_mov_b32 s5, s1
; SI-NEXT:    v_mov_b32_e32 v1, v0
; SI-NEXT:    buffer_store_dwordx2 v[0:1], off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: scalar_to_vector_v2f32:
; VI:       ; %bb.0:
; VI-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; VI-NEXT:    s_mov_b32 s3, 0xf000
; VI-NEXT:    s_mov_b32 s2, -1
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    s_mov_b32 s0, s4
; VI-NEXT:    s_mov_b32 s1, s5
; VI-NEXT:    s_mov_b32 s4, s6
; VI-NEXT:    s_mov_b32 s5, s7
; VI-NEXT:    s_mov_b32 s6, s2
; VI-NEXT:    s_mov_b32 s7, s3
; VI-NEXT:    buffer_load_dword v0, off, s[4:7], 0
; VI-NEXT:    s_waitcnt vmcnt(0)
; VI-NEXT:    v_lshrrev_b32_e32 v0, 16, v0
; VI-NEXT:    v_lshlrev_b32_e32 v1, 16, v0
; VI-NEXT:    v_or_b32_e32 v0, v0, v1
; VI-NEXT:    v_mov_b32_e32 v1, v0
; VI-NEXT:    buffer_store_dwordx2 v[0:1], off, s[0:3], 0
; VI-NEXT:    s_endpgm
  %tmp1 = load float, float addrspace(1)* %in, align 4
  %bc = bitcast float %tmp1 to <2 x i16>
  %tmp2 = shufflevector <2 x i16> %bc, <2 x i16> undef, <4 x i32> <i32 1, i32 1, i32 1, i32 1>
  store <4 x i16> %tmp2, <4 x i16> addrspace(1)* %out, align 8
  ret void
}

define amdgpu_kernel void @scalar_to_vector_v4i16() {
; SI-LABEL: scalar_to_vector_v4i16:
; SI:       ; %bb.0: ; %bb
; SI-NEXT:    s_mov_b32 s3, 0xf000
; SI-NEXT:    s_mov_b32 s2, -1
; SI-NEXT:    buffer_load_ubyte v0, off, s[0:3], 0
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    v_lshlrev_b32_e32 v1, 8, v0
; SI-NEXT:    v_or_b32_e32 v0, v1, v0
; SI-NEXT:    v_lshrrev_b32_e32 v1, 8, v0
; SI-NEXT:    v_lshlrev_b32_e32 v2, 8, v1
; SI-NEXT:    v_or_b32_e32 v1, v1, v2
; SI-NEXT:    v_lshlrev_b32_e32 v2, 16, v1
; SI-NEXT:    v_or_b32_e32 v1, v1, v2
; SI-NEXT:    v_or_b32_e32 v0, v0, v2
; SI-NEXT:    buffer_store_dwordx2 v[0:1], off, s[0:3], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: scalar_to_vector_v4i16:
; VI:       ; %bb.0: ; %bb
; VI-NEXT:    s_mov_b32 s3, 0xf000
; VI-NEXT:    s_mov_b32 s2, -1
; VI-NEXT:    buffer_load_ubyte v0, off, s[0:3], 0
; VI-NEXT:    s_waitcnt vmcnt(0)
; VI-NEXT:    v_lshlrev_b16_e32 v1, 8, v0
; VI-NEXT:    v_or_b32_e32 v0, v1, v0
; VI-NEXT:    v_lshrrev_b16_e32 v1, 8, v0
; VI-NEXT:    v_lshlrev_b16_e32 v2, 8, v1
; VI-NEXT:    v_or_b32_e32 v1, v1, v2
; VI-NEXT:    v_lshlrev_b32_e32 v2, 16, v1
; VI-NEXT:    v_or_b32_sdwa v1, v1, v2 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; VI-NEXT:    v_or_b32_sdwa v0, v0, v2 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; VI-NEXT:    buffer_store_dwordx2 v[0:1], off, s[0:3], 0
; VI-NEXT:    s_endpgm
bb:
  %tmp = load <2 x i8>, <2 x i8> addrspace(1)* undef, align 1
  %tmp1 = shufflevector <2 x i8> %tmp, <2 x i8> zeroinitializer, <8 x i32> <i32 0, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>
  %tmp2 = shufflevector <8 x i8> %tmp1, <8 x i8> undef, <8 x i32> <i32 0, i32 9, i32 9, i32 9, i32 9, i32 9, i32 9, i32 9>
  store <8 x i8> %tmp2, <8 x i8> addrspace(1)* undef, align 8
  ret void
}

define amdgpu_kernel void @scalar_to_vector_v4f16() {
; SI-LABEL: scalar_to_vector_v4f16:
; SI:       ; %bb.0: ; %bb
; SI-NEXT:    s_mov_b32 s3, 0xf000
; SI-NEXT:    s_mov_b32 s2, -1
; SI-NEXT:    buffer_load_ubyte v0, off, s[0:3], 0
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    v_lshlrev_b32_e32 v1, 8, v0
; SI-NEXT:    v_or_b32_e32 v0, v1, v0
; SI-NEXT:    v_lshrrev_b32_e32 v1, 8, v0
; SI-NEXT:    v_lshlrev_b32_e32 v2, 8, v1
; SI-NEXT:    v_or_b32_e32 v1, v1, v2
; SI-NEXT:    v_lshlrev_b32_e32 v2, 16, v1
; SI-NEXT:    v_or_b32_e32 v1, v1, v2
; SI-NEXT:    v_or_b32_e32 v0, v0, v2
; SI-NEXT:    buffer_store_dwordx2 v[0:1], off, s[0:3], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: scalar_to_vector_v4f16:
; VI:       ; %bb.0: ; %bb
; VI-NEXT:    s_mov_b32 s3, 0xf000
; VI-NEXT:    s_mov_b32 s2, -1
; VI-NEXT:    buffer_load_ubyte v0, off, s[0:3], 0
; VI-NEXT:    s_waitcnt vmcnt(0)
; VI-NEXT:    v_lshlrev_b16_e32 v1, 8, v0
; VI-NEXT:    v_or_b32_e32 v0, v1, v0
; VI-NEXT:    v_lshrrev_b16_e32 v1, 8, v0
; VI-NEXT:    v_lshlrev_b16_e32 v2, 8, v1
; VI-NEXT:    v_or_b32_e32 v1, v1, v2
; VI-NEXT:    v_lshlrev_b32_e32 v2, 16, v1
; VI-NEXT:    v_or_b32_sdwa v1, v1, v2 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; VI-NEXT:    v_or_b32_sdwa v0, v0, v2 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; VI-NEXT:    buffer_store_dwordx2 v[0:1], off, s[0:3], 0
; VI-NEXT:    s_endpgm
bb:
  %load = load half, half addrspace(1)* undef, align 1
  %tmp = bitcast half %load to <2 x i8>
  %tmp1 = shufflevector <2 x i8> %tmp, <2 x i8> zeroinitializer, <8 x i32> <i32 0, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>
  %tmp2 = shufflevector <8 x i8> %tmp1, <8 x i8> undef, <8 x i32> <i32 0, i32 9, i32 9, i32 9, i32 9, i32 9, i32 9, i32 9>
  store <8 x i8> %tmp2, <8 x i8> addrspace(1)* undef, align 8
  ret void
}

; Getting a SCALAR_TO_VECTOR seems to be tricky. These cases managed
; to produce one, but for some reason never made it to selection.


; define amdgpu_kernel void @scalar_to_vector_test2(<8 x i8> addrspace(1)* %out, i32 addrspace(1)* %in) nounwind {
;   %tmp1 = load i32, i32 addrspace(1)* %in, align 4
;   %bc = bitcast i32 %tmp1 to <4 x i8>

;   %tmp2 = shufflevector <4 x i8> %bc, <4 x i8> undef, <8 x i32> <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>
;   store <8 x i8> %tmp2, <8 x i8> addrspace(1)* %out, align 4
;   ret void
; }

; define amdgpu_kernel void @scalar_to_vector_test3(<4 x i32> addrspace(1)* %out) nounwind {
;   %newvec0 = insertelement <2 x i64> undef, i64 12345, i32 0
;   %newvec1 = insertelement <2 x i64> %newvec0, i64 undef, i32 1
;   %bc = bitcast <2 x i64> %newvec1 to <4 x i32>
;   %add = add <4 x i32> %bc, <i32 1, i32 2, i32 3, i32 4>
;   store <4 x i32> %add, <4 x i32> addrspace(1)* %out, align 16
;   ret void
; }

; define amdgpu_kernel void @scalar_to_vector_test4(<8 x i16> addrspace(1)* %out) nounwind {
;   %newvec0 = insertelement <4 x i32> undef, i32 12345, i32 0
;   %bc = bitcast <4 x i32> %newvec0 to <8 x i16>
;   %add = add <8 x i16> %bc, <i16 1, i16 2, i16 3, i16 4, i16 1, i16 2, i16 3, i16 4>
;   store <8 x i16> %add, <8 x i16> addrspace(1)* %out, align 16
;   ret void
; }

; define amdgpu_kernel void @scalar_to_vector_test5(<4 x i16> addrspace(1)* %out) nounwind {
;   %newvec0 = insertelement <2 x i32> undef, i32 12345, i32 0
;   %bc = bitcast <2 x i32> %newvec0 to <4 x i16>
;   %add = add <4 x i16> %bc, <i16 1, i16 2, i16 3, i16 4>
;   store <4 x i16> %add, <4 x i16> addrspace(1)* %out, align 16
;   ret void
; }

define amdgpu_kernel void @scalar_to_vector_test6(<2 x half> addrspace(1)* %out, i8 zeroext %val) nounwind {
; SI-LABEL: scalar_to_vector_test6:
; SI:       ; %bb.0:
; SI-NEXT:    s_load_dword s2, s[0:1], 0xb
; SI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x9
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    v_mov_b32_e32 v0, s2
; SI-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: scalar_to_vector_test6:
; VI:       ; %bb.0:
; VI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x24
; VI-NEXT:    s_load_dword s0, s[0:1], 0x2c
; VI-NEXT:    s_mov_b32 s7, 0xf000
; VI-NEXT:    s_mov_b32 s6, -1
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_mov_b32_e32 v0, s0
; VI-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; VI-NEXT:    s_endpgm
  %newvec0 = insertelement <4 x i8> undef, i8 %val, i32 0
  %bc = bitcast <4 x i8> %newvec0 to <2 x half>
  store <2 x half> %bc, <2 x half> addrspace(1)* %out
  ret void
}
