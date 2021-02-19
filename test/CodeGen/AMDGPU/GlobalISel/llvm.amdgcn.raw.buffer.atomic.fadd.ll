; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=gfx908 -stop-after=instruction-select -verify-machineinstrs -o - %s | FileCheck %s -check-prefix=GFX908
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=gfx90a -stop-after=instruction-select -verify-machineinstrs -o - %s | FileCheck %s -check-prefix=GFX90A

; Natural mapping
define amdgpu_ps void @raw_buffer_atomic_add_f32_noret__vgpr_val__sgpr_rsrc__vgpr_voffset__sgpr_soffset(float %val, <4 x i32> inreg %rsrc, i32 %voffset, i32 inreg %soffset) {
  ; GFX908-LABEL: name: raw_buffer_atomic_add_f32_noret__vgpr_val__sgpr_rsrc__vgpr_voffset__sgpr_soffset
  ; GFX908: bb.1 (%ir-block.0):
  ; GFX908:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0, $vgpr1
  ; GFX908:   [[COPY:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; GFX908:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; GFX908:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; GFX908:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; GFX908:   [[COPY4:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; GFX908:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY1]], %subreg.sub0, [[COPY2]], %subreg.sub1, [[COPY3]], %subreg.sub2, [[COPY4]], %subreg.sub3
  ; GFX908:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; GFX908:   [[COPY6:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; GFX908:   BUFFER_ATOMIC_ADD_F32_OFFEN [[COPY]], [[COPY5]], [[REG_SEQUENCE]], [[COPY6]], 0, 0, implicit $exec :: (volatile dereferenceable load store 4 on custom "BufferResource", align 1, addrspace 4)
  ; GFX908:   S_ENDPGM 0
  ; GFX90A-LABEL: name: raw_buffer_atomic_add_f32_noret__vgpr_val__sgpr_rsrc__vgpr_voffset__sgpr_soffset
  ; GFX90A: bb.1 (%ir-block.0):
  ; GFX90A:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0, $vgpr1
  ; GFX90A:   [[COPY:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; GFX90A:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; GFX90A:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; GFX90A:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; GFX90A:   [[COPY4:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; GFX90A:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY1]], %subreg.sub0, [[COPY2]], %subreg.sub1, [[COPY3]], %subreg.sub2, [[COPY4]], %subreg.sub3
  ; GFX90A:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; GFX90A:   [[COPY6:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; GFX90A:   [[BUFFER_ATOMIC_ADD_F32_OFFEN_RTN:%[0-9]+]]:vgpr_32 = BUFFER_ATOMIC_ADD_F32_OFFEN_RTN [[COPY]], [[COPY5]], [[REG_SEQUENCE]], [[COPY6]], 0, 1, 0, implicit $exec :: (volatile dereferenceable load store 4 on custom "BufferResource", align 1, addrspace 4)
  ; GFX90A:   S_ENDPGM 0
  %ret = call float @llvm.amdgcn.raw.buffer.atomic.fadd.f32(float %val, <4 x i32> %rsrc, i32 %voffset, i32 %soffset, i32 0)
  ret void
}

define amdgpu_ps void @raw_buffer_atomic_add_f32_noret__vgpr_val__sgpr_rsrc__vgpr_voffset_plus4095__sgpr_soffset(float %val, <4 x i32> inreg %rsrc, i32 %voffset, i32 inreg %soffset) {
  ; GFX908-LABEL: name: raw_buffer_atomic_add_f32_noret__vgpr_val__sgpr_rsrc__vgpr_voffset_plus4095__sgpr_soffset
  ; GFX908: bb.1 (%ir-block.0):
  ; GFX908:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0, $vgpr1
  ; GFX908:   [[COPY:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; GFX908:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; GFX908:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; GFX908:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; GFX908:   [[COPY4:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; GFX908:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY1]], %subreg.sub0, [[COPY2]], %subreg.sub1, [[COPY3]], %subreg.sub2, [[COPY4]], %subreg.sub3
  ; GFX908:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; GFX908:   [[COPY6:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; GFX908:   BUFFER_ATOMIC_ADD_F32_OFFEN [[COPY]], [[COPY5]], [[REG_SEQUENCE]], [[COPY6]], 4095, 0, implicit $exec :: (volatile dereferenceable load store 4 on custom "BufferResource" + 4095, align 1, addrspace 4)
  ; GFX908:   S_ENDPGM 0
  ; GFX90A-LABEL: name: raw_buffer_atomic_add_f32_noret__vgpr_val__sgpr_rsrc__vgpr_voffset_plus4095__sgpr_soffset
  ; GFX90A: bb.1 (%ir-block.0):
  ; GFX90A:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0, $vgpr1
  ; GFX90A:   [[COPY:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; GFX90A:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; GFX90A:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; GFX90A:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; GFX90A:   [[COPY4:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; GFX90A:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY1]], %subreg.sub0, [[COPY2]], %subreg.sub1, [[COPY3]], %subreg.sub2, [[COPY4]], %subreg.sub3
  ; GFX90A:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; GFX90A:   [[COPY6:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; GFX90A:   [[BUFFER_ATOMIC_ADD_F32_OFFEN_RTN:%[0-9]+]]:vgpr_32 = BUFFER_ATOMIC_ADD_F32_OFFEN_RTN [[COPY]], [[COPY5]], [[REG_SEQUENCE]], [[COPY6]], 4095, 1, 0, implicit $exec :: (volatile dereferenceable load store 4 on custom "BufferResource" + 4095, align 1, addrspace 4)
  ; GFX90A:   S_ENDPGM 0
  %voffset.add = add i32 %voffset, 4095
  %ret = call float @llvm.amdgcn.raw.buffer.atomic.fadd.f32(float %val, <4 x i32> %rsrc, i32 %voffset.add, i32 %soffset, i32 0)
  ret void
}

define amdgpu_ps void @raw_buffer_atomic_add_f32_noret__vgpr_val__sgpr_rsrc__vgpr_voffset_4095__sgpr_soffset(float %val, <4 x i32> inreg %rsrc, i32 inreg %soffset) {
  ; GFX908-LABEL: name: raw_buffer_atomic_add_f32_noret__vgpr_val__sgpr_rsrc__vgpr_voffset_4095__sgpr_soffset
  ; GFX908: bb.1 (%ir-block.0):
  ; GFX908:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0
  ; GFX908:   [[COPY:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; GFX908:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; GFX908:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; GFX908:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; GFX908:   [[COPY4:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; GFX908:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY1]], %subreg.sub0, [[COPY2]], %subreg.sub1, [[COPY3]], %subreg.sub2, [[COPY4]], %subreg.sub3
  ; GFX908:   [[COPY5:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; GFX908:   BUFFER_ATOMIC_ADD_F32_OFFSET [[COPY]], [[REG_SEQUENCE]], [[COPY5]], 4095, 0, implicit $exec :: (volatile dereferenceable load store 4 on custom "BufferResource" + 4095, align 1, addrspace 4)
  ; GFX908:   S_ENDPGM 0
  ; GFX90A-LABEL: name: raw_buffer_atomic_add_f32_noret__vgpr_val__sgpr_rsrc__vgpr_voffset_4095__sgpr_soffset
  ; GFX90A: bb.1 (%ir-block.0):
  ; GFX90A:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0
  ; GFX90A:   [[COPY:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; GFX90A:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; GFX90A:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; GFX90A:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; GFX90A:   [[COPY4:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; GFX90A:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY1]], %subreg.sub0, [[COPY2]], %subreg.sub1, [[COPY3]], %subreg.sub2, [[COPY4]], %subreg.sub3
  ; GFX90A:   [[COPY5:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; GFX90A:   [[BUFFER_ATOMIC_ADD_F32_OFFSET_RTN:%[0-9]+]]:vgpr_32 = BUFFER_ATOMIC_ADD_F32_OFFSET_RTN [[COPY]], [[REG_SEQUENCE]], [[COPY5]], 4095, 1, 0, implicit $exec :: (volatile dereferenceable load store 4 on custom "BufferResource" + 4095, align 1, addrspace 4)
  ; GFX90A:   S_ENDPGM 0
  %ret = call float @llvm.amdgcn.raw.buffer.atomic.fadd.f32(float %val, <4 x i32> %rsrc, i32 4095, i32 %soffset, i32 0)
  ret void
}

; Natural mapping, no voffset
define amdgpu_ps void @raw_buffer_atomic_add_f32_noret__vgpr_val__sgpr_rsrc__0_voffset__sgpr_soffset(float %val, <4 x i32> inreg %rsrc, i32 inreg %soffset) {
  ; GFX908-LABEL: name: raw_buffer_atomic_add_f32_noret__vgpr_val__sgpr_rsrc__0_voffset__sgpr_soffset
  ; GFX908: bb.1 (%ir-block.0):
  ; GFX908:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0
  ; GFX908:   [[COPY:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; GFX908:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; GFX908:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; GFX908:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; GFX908:   [[COPY4:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; GFX908:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY1]], %subreg.sub0, [[COPY2]], %subreg.sub1, [[COPY3]], %subreg.sub2, [[COPY4]], %subreg.sub3
  ; GFX908:   [[COPY5:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; GFX908:   BUFFER_ATOMIC_ADD_F32_OFFSET [[COPY]], [[REG_SEQUENCE]], [[COPY5]], 0, 0, implicit $exec :: (volatile dereferenceable load store 4 on custom "BufferResource", align 1, addrspace 4)
  ; GFX908:   S_ENDPGM 0
  ; GFX90A-LABEL: name: raw_buffer_atomic_add_f32_noret__vgpr_val__sgpr_rsrc__0_voffset__sgpr_soffset
  ; GFX90A: bb.1 (%ir-block.0):
  ; GFX90A:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0
  ; GFX90A:   [[COPY:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; GFX90A:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; GFX90A:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; GFX90A:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; GFX90A:   [[COPY4:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; GFX90A:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY1]], %subreg.sub0, [[COPY2]], %subreg.sub1, [[COPY3]], %subreg.sub2, [[COPY4]], %subreg.sub3
  ; GFX90A:   [[COPY5:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; GFX90A:   [[BUFFER_ATOMIC_ADD_F32_OFFSET_RTN:%[0-9]+]]:vgpr_32 = BUFFER_ATOMIC_ADD_F32_OFFSET_RTN [[COPY]], [[REG_SEQUENCE]], [[COPY5]], 0, 1, 0, implicit $exec :: (volatile dereferenceable load store 4 on custom "BufferResource", align 1, addrspace 4)
  ; GFX90A:   S_ENDPGM 0
  %ret = call float @llvm.amdgcn.raw.buffer.atomic.fadd.f32(float %val, <4 x i32> %rsrc, i32 0, i32 %soffset, i32 0)
  ret void
}

; All operands need regbank legalization
define amdgpu_ps void @raw_buffer_atomic_add_f32_noret__sgpr_val__vgpr_rsrc__sgpr_voffset__vgpr_soffset(float inreg %val, <4 x i32> %rsrc, i32 inreg %voffset, i32 %soffset) {
  ; GFX908-LABEL: name: raw_buffer_atomic_add_f32_noret__sgpr_val__vgpr_rsrc__sgpr_voffset__vgpr_soffset
  ; GFX908: bb.1 (%ir-block.0):
  ; GFX908:   successors: %bb.2(0x80000000)
  ; GFX908:   liveins: $sgpr2, $sgpr3, $vgpr0, $vgpr1, $vgpr2, $vgpr3, $vgpr4
  ; GFX908:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; GFX908:   [[COPY1:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; GFX908:   [[COPY2:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; GFX908:   [[COPY3:%[0-9]+]]:vgpr_32 = COPY $vgpr2
  ; GFX908:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr3
  ; GFX908:   [[REG_SEQUENCE:%[0-9]+]]:vreg_128 = REG_SEQUENCE [[COPY1]], %subreg.sub0, [[COPY2]], %subreg.sub1, [[COPY3]], %subreg.sub2, [[COPY4]], %subreg.sub3
  ; GFX908:   [[COPY5:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; GFX908:   [[COPY6:%[0-9]+]]:vgpr_32 = COPY $vgpr4
  ; GFX908:   [[COPY7:%[0-9]+]]:vgpr_32 = COPY [[COPY]]
  ; GFX908:   [[COPY8:%[0-9]+]]:vgpr_32 = COPY [[COPY5]]
  ; GFX908:   [[COPY9:%[0-9]+]]:vreg_64 = COPY [[REG_SEQUENCE]].sub0_sub1
  ; GFX908:   [[COPY10:%[0-9]+]]:vreg_64 = COPY [[REG_SEQUENCE]].sub2_sub3
  ; GFX908:   [[S_MOV_B64_term:%[0-9]+]]:sreg_64_xexec = S_MOV_B64_term $exec
  ; GFX908: bb.2:
  ; GFX908:   successors: %bb.3(0x40000000), %bb.2(0x40000000)
  ; GFX908:   [[V_READFIRSTLANE_B32_:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY9]].sub0, implicit $exec
  ; GFX908:   [[V_READFIRSTLANE_B32_1:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY9]].sub1, implicit $exec
  ; GFX908:   [[REG_SEQUENCE1:%[0-9]+]]:sreg_64_xexec = REG_SEQUENCE [[V_READFIRSTLANE_B32_]], %subreg.sub0, [[V_READFIRSTLANE_B32_1]], %subreg.sub1
  ; GFX908:   [[V_CMP_EQ_U64_e64_:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U64_e64 [[REG_SEQUENCE1]], [[COPY9]], implicit $exec
  ; GFX908:   [[V_READFIRSTLANE_B32_2:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY10]].sub0, implicit $exec
  ; GFX908:   [[V_READFIRSTLANE_B32_3:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY10]].sub1, implicit $exec
  ; GFX908:   [[REG_SEQUENCE2:%[0-9]+]]:sreg_64_xexec = REG_SEQUENCE [[V_READFIRSTLANE_B32_2]], %subreg.sub0, [[V_READFIRSTLANE_B32_3]], %subreg.sub1
  ; GFX908:   [[V_CMP_EQ_U64_e64_1:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U64_e64 [[REG_SEQUENCE2]], [[COPY10]], implicit $exec
  ; GFX908:   [[S_AND_B64_:%[0-9]+]]:sreg_64_xexec = S_AND_B64 [[V_CMP_EQ_U64_e64_1]], [[V_CMP_EQ_U64_e64_]], implicit-def $scc
  ; GFX908:   [[REG_SEQUENCE3:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[V_READFIRSTLANE_B32_]], %subreg.sub0, [[V_READFIRSTLANE_B32_1]], %subreg.sub1, [[V_READFIRSTLANE_B32_2]], %subreg.sub2, [[V_READFIRSTLANE_B32_3]], %subreg.sub3
  ; GFX908:   [[V_READFIRSTLANE_B32_4:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY6]], implicit $exec
  ; GFX908:   [[V_CMP_EQ_U32_e64_:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U32_e64 [[V_READFIRSTLANE_B32_4]], [[COPY6]], implicit $exec
  ; GFX908:   [[S_AND_B64_1:%[0-9]+]]:sreg_64_xexec = S_AND_B64 [[V_CMP_EQ_U32_e64_]], [[S_AND_B64_]], implicit-def $scc
  ; GFX908:   BUFFER_ATOMIC_ADD_F32_OFFEN [[COPY7]], [[COPY8]], [[REG_SEQUENCE3]], [[V_READFIRSTLANE_B32_4]], 0, 0, implicit $exec :: (volatile dereferenceable load store 4 on custom "BufferResource", align 1, addrspace 4)
  ; GFX908:   [[S_AND_SAVEEXEC_B64_:%[0-9]+]]:sreg_64_xexec = S_AND_SAVEEXEC_B64 killed [[S_AND_B64_1]], implicit-def $exec, implicit-def $scc, implicit $exec
  ; GFX908:   $exec = S_XOR_B64_term $exec, [[S_AND_SAVEEXEC_B64_]], implicit-def $scc
  ; GFX908:   S_CBRANCH_EXECNZ %bb.2, implicit $exec
  ; GFX908: bb.3:
  ; GFX908:   successors: %bb.4(0x80000000)
  ; GFX908:   $exec = S_MOV_B64_term [[S_MOV_B64_term]]
  ; GFX908: bb.4:
  ; GFX908:   S_ENDPGM 0
  ; GFX90A-LABEL: name: raw_buffer_atomic_add_f32_noret__sgpr_val__vgpr_rsrc__sgpr_voffset__vgpr_soffset
  ; GFX90A: bb.1 (%ir-block.0):
  ; GFX90A:   successors: %bb.2(0x80000000)
  ; GFX90A:   liveins: $sgpr2, $sgpr3, $vgpr0, $vgpr1, $vgpr2, $vgpr3, $vgpr4
  ; GFX90A:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; GFX90A:   [[COPY1:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; GFX90A:   [[COPY2:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; GFX90A:   [[COPY3:%[0-9]+]]:vgpr_32 = COPY $vgpr2
  ; GFX90A:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr3
  ; GFX90A:   [[REG_SEQUENCE:%[0-9]+]]:vreg_128_align2 = REG_SEQUENCE [[COPY1]], %subreg.sub0, [[COPY2]], %subreg.sub1, [[COPY3]], %subreg.sub2, [[COPY4]], %subreg.sub3
  ; GFX90A:   [[COPY5:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; GFX90A:   [[COPY6:%[0-9]+]]:vgpr_32 = COPY $vgpr4
  ; GFX90A:   [[COPY7:%[0-9]+]]:vgpr_32 = COPY [[COPY]]
  ; GFX90A:   [[COPY8:%[0-9]+]]:vgpr_32 = COPY [[COPY5]]
  ; GFX90A:   [[COPY9:%[0-9]+]]:vreg_64_align2 = COPY [[REG_SEQUENCE]].sub0_sub1
  ; GFX90A:   [[COPY10:%[0-9]+]]:vreg_64_align2 = COPY [[REG_SEQUENCE]].sub2_sub3
  ; GFX90A:   [[S_MOV_B64_term:%[0-9]+]]:sreg_64_xexec = S_MOV_B64_term $exec
  ; GFX90A: bb.2:
  ; GFX90A:   successors: %bb.3(0x40000000), %bb.2(0x40000000)
  ; GFX90A:   [[V_READFIRSTLANE_B32_:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY9]].sub0, implicit $exec
  ; GFX90A:   [[V_READFIRSTLANE_B32_1:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY9]].sub1, implicit $exec
  ; GFX90A:   [[REG_SEQUENCE1:%[0-9]+]]:sreg_64_xexec = REG_SEQUENCE [[V_READFIRSTLANE_B32_]], %subreg.sub0, [[V_READFIRSTLANE_B32_1]], %subreg.sub1
  ; GFX90A:   [[V_CMP_EQ_U64_e64_:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U64_e64 [[REG_SEQUENCE1]], [[COPY9]], implicit $exec
  ; GFX90A:   [[V_READFIRSTLANE_B32_2:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY10]].sub0, implicit $exec
  ; GFX90A:   [[V_READFIRSTLANE_B32_3:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY10]].sub1, implicit $exec
  ; GFX90A:   [[REG_SEQUENCE2:%[0-9]+]]:sreg_64_xexec = REG_SEQUENCE [[V_READFIRSTLANE_B32_2]], %subreg.sub0, [[V_READFIRSTLANE_B32_3]], %subreg.sub1
  ; GFX90A:   [[V_CMP_EQ_U64_e64_1:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U64_e64 [[REG_SEQUENCE2]], [[COPY10]], implicit $exec
  ; GFX90A:   [[S_AND_B64_:%[0-9]+]]:sreg_64_xexec = S_AND_B64 [[V_CMP_EQ_U64_e64_1]], [[V_CMP_EQ_U64_e64_]], implicit-def $scc
  ; GFX90A:   [[REG_SEQUENCE3:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[V_READFIRSTLANE_B32_]], %subreg.sub0, [[V_READFIRSTLANE_B32_1]], %subreg.sub1, [[V_READFIRSTLANE_B32_2]], %subreg.sub2, [[V_READFIRSTLANE_B32_3]], %subreg.sub3
  ; GFX90A:   [[V_READFIRSTLANE_B32_4:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY6]], implicit $exec
  ; GFX90A:   [[V_CMP_EQ_U32_e64_:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U32_e64 [[V_READFIRSTLANE_B32_4]], [[COPY6]], implicit $exec
  ; GFX90A:   [[S_AND_B64_1:%[0-9]+]]:sreg_64_xexec = S_AND_B64 [[V_CMP_EQ_U32_e64_]], [[S_AND_B64_]], implicit-def $scc
  ; GFX90A:   [[BUFFER_ATOMIC_ADD_F32_OFFEN_RTN:%[0-9]+]]:vgpr_32 = BUFFER_ATOMIC_ADD_F32_OFFEN_RTN [[COPY7]], [[COPY8]], [[REG_SEQUENCE3]], [[V_READFIRSTLANE_B32_4]], 0, 1, 0, implicit $exec :: (volatile dereferenceable load store 4 on custom "BufferResource", align 1, addrspace 4)
  ; GFX90A:   [[S_AND_SAVEEXEC_B64_:%[0-9]+]]:sreg_64_xexec = S_AND_SAVEEXEC_B64 killed [[S_AND_B64_1]], implicit-def $exec, implicit-def $scc, implicit $exec
  ; GFX90A:   $exec = S_XOR_B64_term $exec, [[S_AND_SAVEEXEC_B64_]], implicit-def $scc
  ; GFX90A:   S_CBRANCH_EXECNZ %bb.2, implicit $exec
  ; GFX90A: bb.3:
  ; GFX90A:   successors: %bb.4(0x80000000)
  ; GFX90A:   $exec = S_MOV_B64_term [[S_MOV_B64_term]]
  ; GFX90A: bb.4:
  ; GFX90A:   S_ENDPGM 0
  %ret = call float @llvm.amdgcn.raw.buffer.atomic.fadd.f32(float %val, <4 x i32> %rsrc, i32 %voffset, i32 %soffset, i32 0)
  ret void
}

; All operands need regbank legalization, no voffset
define amdgpu_ps void @raw_buffer_atomic_add_f32_noret__sgpr_val__vgpr_rsrc__0_voffset__vgpr_soffset(float inreg %val, <4 x i32> %rsrc, i32 %soffset) {
  ; GFX908-LABEL: name: raw_buffer_atomic_add_f32_noret__sgpr_val__vgpr_rsrc__0_voffset__vgpr_soffset
  ; GFX908: bb.1 (%ir-block.0):
  ; GFX908:   successors: %bb.2(0x80000000)
  ; GFX908:   liveins: $sgpr2, $vgpr0, $vgpr1, $vgpr2, $vgpr3, $vgpr4
  ; GFX908:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; GFX908:   [[COPY1:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; GFX908:   [[COPY2:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; GFX908:   [[COPY3:%[0-9]+]]:vgpr_32 = COPY $vgpr2
  ; GFX908:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr3
  ; GFX908:   [[REG_SEQUENCE:%[0-9]+]]:vreg_128 = REG_SEQUENCE [[COPY1]], %subreg.sub0, [[COPY2]], %subreg.sub1, [[COPY3]], %subreg.sub2, [[COPY4]], %subreg.sub3
  ; GFX908:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr4
  ; GFX908:   [[COPY6:%[0-9]+]]:vgpr_32 = COPY [[COPY]]
  ; GFX908:   [[COPY7:%[0-9]+]]:vreg_64 = COPY [[REG_SEQUENCE]].sub0_sub1
  ; GFX908:   [[COPY8:%[0-9]+]]:vreg_64 = COPY [[REG_SEQUENCE]].sub2_sub3
  ; GFX908:   [[S_MOV_B64_term:%[0-9]+]]:sreg_64_xexec = S_MOV_B64_term $exec
  ; GFX908: bb.2:
  ; GFX908:   successors: %bb.3(0x40000000), %bb.2(0x40000000)
  ; GFX908:   [[V_READFIRSTLANE_B32_:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY7]].sub0, implicit $exec
  ; GFX908:   [[V_READFIRSTLANE_B32_1:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY7]].sub1, implicit $exec
  ; GFX908:   [[REG_SEQUENCE1:%[0-9]+]]:sreg_64_xexec = REG_SEQUENCE [[V_READFIRSTLANE_B32_]], %subreg.sub0, [[V_READFIRSTLANE_B32_1]], %subreg.sub1
  ; GFX908:   [[V_CMP_EQ_U64_e64_:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U64_e64 [[REG_SEQUENCE1]], [[COPY7]], implicit $exec
  ; GFX908:   [[V_READFIRSTLANE_B32_2:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY8]].sub0, implicit $exec
  ; GFX908:   [[V_READFIRSTLANE_B32_3:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY8]].sub1, implicit $exec
  ; GFX908:   [[REG_SEQUENCE2:%[0-9]+]]:sreg_64_xexec = REG_SEQUENCE [[V_READFIRSTLANE_B32_2]], %subreg.sub0, [[V_READFIRSTLANE_B32_3]], %subreg.sub1
  ; GFX908:   [[V_CMP_EQ_U64_e64_1:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U64_e64 [[REG_SEQUENCE2]], [[COPY8]], implicit $exec
  ; GFX908:   [[S_AND_B64_:%[0-9]+]]:sreg_64_xexec = S_AND_B64 [[V_CMP_EQ_U64_e64_1]], [[V_CMP_EQ_U64_e64_]], implicit-def $scc
  ; GFX908:   [[REG_SEQUENCE3:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[V_READFIRSTLANE_B32_]], %subreg.sub0, [[V_READFIRSTLANE_B32_1]], %subreg.sub1, [[V_READFIRSTLANE_B32_2]], %subreg.sub2, [[V_READFIRSTLANE_B32_3]], %subreg.sub3
  ; GFX908:   [[V_READFIRSTLANE_B32_4:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY5]], implicit $exec
  ; GFX908:   [[V_CMP_EQ_U32_e64_:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U32_e64 [[V_READFIRSTLANE_B32_4]], [[COPY5]], implicit $exec
  ; GFX908:   [[S_AND_B64_1:%[0-9]+]]:sreg_64_xexec = S_AND_B64 [[V_CMP_EQ_U32_e64_]], [[S_AND_B64_]], implicit-def $scc
  ; GFX908:   BUFFER_ATOMIC_ADD_F32_OFFSET [[COPY6]], [[REG_SEQUENCE3]], [[V_READFIRSTLANE_B32_4]], 0, 0, implicit $exec :: (volatile dereferenceable load store 4 on custom "BufferResource", align 1, addrspace 4)
  ; GFX908:   [[S_AND_SAVEEXEC_B64_:%[0-9]+]]:sreg_64_xexec = S_AND_SAVEEXEC_B64 killed [[S_AND_B64_1]], implicit-def $exec, implicit-def $scc, implicit $exec
  ; GFX908:   $exec = S_XOR_B64_term $exec, [[S_AND_SAVEEXEC_B64_]], implicit-def $scc
  ; GFX908:   S_CBRANCH_EXECNZ %bb.2, implicit $exec
  ; GFX908: bb.3:
  ; GFX908:   successors: %bb.4(0x80000000)
  ; GFX908:   $exec = S_MOV_B64_term [[S_MOV_B64_term]]
  ; GFX908: bb.4:
  ; GFX908:   S_ENDPGM 0
  ; GFX90A-LABEL: name: raw_buffer_atomic_add_f32_noret__sgpr_val__vgpr_rsrc__0_voffset__vgpr_soffset
  ; GFX90A: bb.1 (%ir-block.0):
  ; GFX90A:   successors: %bb.2(0x80000000)
  ; GFX90A:   liveins: $sgpr2, $vgpr0, $vgpr1, $vgpr2, $vgpr3, $vgpr4
  ; GFX90A:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; GFX90A:   [[COPY1:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; GFX90A:   [[COPY2:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; GFX90A:   [[COPY3:%[0-9]+]]:vgpr_32 = COPY $vgpr2
  ; GFX90A:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr3
  ; GFX90A:   [[REG_SEQUENCE:%[0-9]+]]:vreg_128_align2 = REG_SEQUENCE [[COPY1]], %subreg.sub0, [[COPY2]], %subreg.sub1, [[COPY3]], %subreg.sub2, [[COPY4]], %subreg.sub3
  ; GFX90A:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr4
  ; GFX90A:   [[COPY6:%[0-9]+]]:vgpr_32 = COPY [[COPY]]
  ; GFX90A:   [[COPY7:%[0-9]+]]:vreg_64_align2 = COPY [[REG_SEQUENCE]].sub0_sub1
  ; GFX90A:   [[COPY8:%[0-9]+]]:vreg_64_align2 = COPY [[REG_SEQUENCE]].sub2_sub3
  ; GFX90A:   [[S_MOV_B64_term:%[0-9]+]]:sreg_64_xexec = S_MOV_B64_term $exec
  ; GFX90A: bb.2:
  ; GFX90A:   successors: %bb.3(0x40000000), %bb.2(0x40000000)
  ; GFX90A:   [[V_READFIRSTLANE_B32_:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY7]].sub0, implicit $exec
  ; GFX90A:   [[V_READFIRSTLANE_B32_1:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY7]].sub1, implicit $exec
  ; GFX90A:   [[REG_SEQUENCE1:%[0-9]+]]:sreg_64_xexec = REG_SEQUENCE [[V_READFIRSTLANE_B32_]], %subreg.sub0, [[V_READFIRSTLANE_B32_1]], %subreg.sub1
  ; GFX90A:   [[V_CMP_EQ_U64_e64_:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U64_e64 [[REG_SEQUENCE1]], [[COPY7]], implicit $exec
  ; GFX90A:   [[V_READFIRSTLANE_B32_2:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY8]].sub0, implicit $exec
  ; GFX90A:   [[V_READFIRSTLANE_B32_3:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY8]].sub1, implicit $exec
  ; GFX90A:   [[REG_SEQUENCE2:%[0-9]+]]:sreg_64_xexec = REG_SEQUENCE [[V_READFIRSTLANE_B32_2]], %subreg.sub0, [[V_READFIRSTLANE_B32_3]], %subreg.sub1
  ; GFX90A:   [[V_CMP_EQ_U64_e64_1:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U64_e64 [[REG_SEQUENCE2]], [[COPY8]], implicit $exec
  ; GFX90A:   [[S_AND_B64_:%[0-9]+]]:sreg_64_xexec = S_AND_B64 [[V_CMP_EQ_U64_e64_1]], [[V_CMP_EQ_U64_e64_]], implicit-def $scc
  ; GFX90A:   [[REG_SEQUENCE3:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[V_READFIRSTLANE_B32_]], %subreg.sub0, [[V_READFIRSTLANE_B32_1]], %subreg.sub1, [[V_READFIRSTLANE_B32_2]], %subreg.sub2, [[V_READFIRSTLANE_B32_3]], %subreg.sub3
  ; GFX90A:   [[V_READFIRSTLANE_B32_4:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY5]], implicit $exec
  ; GFX90A:   [[V_CMP_EQ_U32_e64_:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U32_e64 [[V_READFIRSTLANE_B32_4]], [[COPY5]], implicit $exec
  ; GFX90A:   [[S_AND_B64_1:%[0-9]+]]:sreg_64_xexec = S_AND_B64 [[V_CMP_EQ_U32_e64_]], [[S_AND_B64_]], implicit-def $scc
  ; GFX90A:   [[BUFFER_ATOMIC_ADD_F32_OFFSET_RTN:%[0-9]+]]:vgpr_32 = BUFFER_ATOMIC_ADD_F32_OFFSET_RTN [[COPY6]], [[REG_SEQUENCE3]], [[V_READFIRSTLANE_B32_4]], 0, 1, 0, implicit $exec :: (volatile dereferenceable load store 4 on custom "BufferResource", align 1, addrspace 4)
  ; GFX90A:   [[S_AND_SAVEEXEC_B64_:%[0-9]+]]:sreg_64_xexec = S_AND_SAVEEXEC_B64 killed [[S_AND_B64_1]], implicit-def $exec, implicit-def $scc, implicit $exec
  ; GFX90A:   $exec = S_XOR_B64_term $exec, [[S_AND_SAVEEXEC_B64_]], implicit-def $scc
  ; GFX90A:   S_CBRANCH_EXECNZ %bb.2, implicit $exec
  ; GFX90A: bb.3:
  ; GFX90A:   successors: %bb.4(0x80000000)
  ; GFX90A:   $exec = S_MOV_B64_term [[S_MOV_B64_term]]
  ; GFX90A: bb.4:
  ; GFX90A:   S_ENDPGM 0
  %ret = call float @llvm.amdgcn.raw.buffer.atomic.fadd.f32(float %val, <4 x i32> %rsrc, i32 0, i32 %soffset, i32 0)
  ret void
}

define amdgpu_ps void @raw_buffer_atomic_add_f32_noret__vgpr_val__sgpr_rsrc__vgpr_voffset__sgpr_soffset_voffset_add4095(float %val, <4 x i32> inreg %rsrc, i32 %voffset.base, i32 inreg %soffset) {
  ; GFX908-LABEL: name: raw_buffer_atomic_add_f32_noret__vgpr_val__sgpr_rsrc__vgpr_voffset__sgpr_soffset_voffset_add4095
  ; GFX908: bb.1 (%ir-block.0):
  ; GFX908:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0, $vgpr1
  ; GFX908:   [[COPY:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; GFX908:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; GFX908:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; GFX908:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; GFX908:   [[COPY4:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; GFX908:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY1]], %subreg.sub0, [[COPY2]], %subreg.sub1, [[COPY3]], %subreg.sub2, [[COPY4]], %subreg.sub3
  ; GFX908:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; GFX908:   [[COPY6:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; GFX908:   BUFFER_ATOMIC_ADD_F32_OFFEN [[COPY]], [[COPY5]], [[REG_SEQUENCE]], [[COPY6]], 4095, 0, implicit $exec :: (volatile dereferenceable load store 4 on custom "BufferResource" + 4095, align 1, addrspace 4)
  ; GFX908:   S_ENDPGM 0
  ; GFX90A-LABEL: name: raw_buffer_atomic_add_f32_noret__vgpr_val__sgpr_rsrc__vgpr_voffset__sgpr_soffset_voffset_add4095
  ; GFX90A: bb.1 (%ir-block.0):
  ; GFX90A:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0, $vgpr1
  ; GFX90A:   [[COPY:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; GFX90A:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; GFX90A:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; GFX90A:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; GFX90A:   [[COPY4:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; GFX90A:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY1]], %subreg.sub0, [[COPY2]], %subreg.sub1, [[COPY3]], %subreg.sub2, [[COPY4]], %subreg.sub3
  ; GFX90A:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; GFX90A:   [[COPY6:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; GFX90A:   [[BUFFER_ATOMIC_ADD_F32_OFFEN_RTN:%[0-9]+]]:vgpr_32 = BUFFER_ATOMIC_ADD_F32_OFFEN_RTN [[COPY]], [[COPY5]], [[REG_SEQUENCE]], [[COPY6]], 4095, 1, 0, implicit $exec :: (volatile dereferenceable load store 4 on custom "BufferResource" + 4095, align 1, addrspace 4)
  ; GFX90A:   S_ENDPGM 0
  %voffset = add i32 %voffset.base, 4095
  %ret = call float @llvm.amdgcn.raw.buffer.atomic.fadd.f32(float %val, <4 x i32> %rsrc, i32 %voffset, i32 %soffset, i32 0)
  ret void
}

; Natural mapping + slc
define amdgpu_ps void @raw_buffer_atomic_add_f32_noret__vgpr_val__sgpr_rsrc__vgpr_voffset__sgpr_soffset_slc(float %val, <4 x i32> inreg %rsrc, i32 %voffset, i32 inreg %soffset) {
  ; GFX908-LABEL: name: raw_buffer_atomic_add_f32_noret__vgpr_val__sgpr_rsrc__vgpr_voffset__sgpr_soffset_slc
  ; GFX908: bb.1 (%ir-block.0):
  ; GFX908:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0, $vgpr1
  ; GFX908:   [[COPY:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; GFX908:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; GFX908:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; GFX908:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; GFX908:   [[COPY4:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; GFX908:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY1]], %subreg.sub0, [[COPY2]], %subreg.sub1, [[COPY3]], %subreg.sub2, [[COPY4]], %subreg.sub3
  ; GFX908:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; GFX908:   [[COPY6:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; GFX908:   BUFFER_ATOMIC_ADD_F32_OFFEN [[COPY]], [[COPY5]], [[REG_SEQUENCE]], [[COPY6]], 0, 1, implicit $exec :: (volatile dereferenceable load store 4 on custom "BufferResource", align 1, addrspace 4)
  ; GFX908:   S_ENDPGM 0
  ; GFX90A-LABEL: name: raw_buffer_atomic_add_f32_noret__vgpr_val__sgpr_rsrc__vgpr_voffset__sgpr_soffset_slc
  ; GFX90A: bb.1 (%ir-block.0):
  ; GFX90A:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0, $vgpr1
  ; GFX90A:   [[COPY:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; GFX90A:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; GFX90A:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; GFX90A:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; GFX90A:   [[COPY4:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; GFX90A:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY1]], %subreg.sub0, [[COPY2]], %subreg.sub1, [[COPY3]], %subreg.sub2, [[COPY4]], %subreg.sub3
  ; GFX90A:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; GFX90A:   [[COPY6:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; GFX90A:   [[BUFFER_ATOMIC_ADD_F32_OFFEN_RTN:%[0-9]+]]:vgpr_32 = BUFFER_ATOMIC_ADD_F32_OFFEN_RTN [[COPY]], [[COPY5]], [[REG_SEQUENCE]], [[COPY6]], 0, 1, 1, implicit $exec :: (volatile dereferenceable load store 4 on custom "BufferResource", align 1, addrspace 4)
  ; GFX90A:   S_ENDPGM 0
  %ret = call float @llvm.amdgcn.raw.buffer.atomic.fadd.f32(float %val, <4 x i32> %rsrc, i32 %voffset, i32 %soffset, i32 2)
  ret void
}

define amdgpu_ps void @raw_buffer_atomic_add_v2f16_noret__vgpr_val__sgpr_rsrc__vgpr_voffset__sgpr_soffset(<2 x half> %val, <4 x i32> inreg %rsrc, i32 %voffset, i32 inreg %soffset) {
  ; GFX908-LABEL: name: raw_buffer_atomic_add_v2f16_noret__vgpr_val__sgpr_rsrc__vgpr_voffset__sgpr_soffset
  ; GFX908: bb.1 (%ir-block.0):
  ; GFX908:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0, $vgpr1
  ; GFX908:   [[COPY:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; GFX908:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; GFX908:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; GFX908:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; GFX908:   [[COPY4:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; GFX908:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY1]], %subreg.sub0, [[COPY2]], %subreg.sub1, [[COPY3]], %subreg.sub2, [[COPY4]], %subreg.sub3
  ; GFX908:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; GFX908:   [[COPY6:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; GFX908:   BUFFER_ATOMIC_PK_ADD_F16_OFFEN [[COPY]], [[COPY5]], [[REG_SEQUENCE]], [[COPY6]], 0, 0, implicit $exec :: (volatile dereferenceable load store 4 on custom "BufferResource", align 1, addrspace 4)
  ; GFX908:   S_ENDPGM 0
  ; GFX90A-LABEL: name: raw_buffer_atomic_add_v2f16_noret__vgpr_val__sgpr_rsrc__vgpr_voffset__sgpr_soffset
  ; GFX90A: bb.1 (%ir-block.0):
  ; GFX90A:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0, $vgpr1
  ; GFX90A:   [[COPY:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; GFX90A:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; GFX90A:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; GFX90A:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; GFX90A:   [[COPY4:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; GFX90A:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY1]], %subreg.sub0, [[COPY2]], %subreg.sub1, [[COPY3]], %subreg.sub2, [[COPY4]], %subreg.sub3
  ; GFX90A:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; GFX90A:   [[COPY6:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; GFX90A:   [[BUFFER_ATOMIC_PK_ADD_F16_OFFEN_RTN:%[0-9]+]]:vgpr_32 = BUFFER_ATOMIC_PK_ADD_F16_OFFEN_RTN [[COPY]], [[COPY5]], [[REG_SEQUENCE]], [[COPY6]], 0, 1, 0, implicit $exec :: (volatile dereferenceable load store 4 on custom "BufferResource", align 1, addrspace 4)
  ; GFX90A:   S_ENDPGM 0
  %ret = call <2 x half> @llvm.amdgcn.raw.buffer.atomic.fadd.v2f16(<2 x half> %val, <4 x i32> %rsrc, i32 %voffset, i32 %soffset, i32 0)
  ret void
}

define amdgpu_ps void @raw_buffer_atomic_add_v2f16_noret__vgpr_val__sgpr_rsrc__0_voffset__sgpr_soffset(<2 x half> %val, <4 x i32> inreg %rsrc, i32 %voffset, i32 inreg %soffset) {
  ; GFX908-LABEL: name: raw_buffer_atomic_add_v2f16_noret__vgpr_val__sgpr_rsrc__0_voffset__sgpr_soffset
  ; GFX908: bb.1 (%ir-block.0):
  ; GFX908:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0
  ; GFX908:   [[COPY:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; GFX908:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; GFX908:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; GFX908:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; GFX908:   [[COPY4:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; GFX908:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY1]], %subreg.sub0, [[COPY2]], %subreg.sub1, [[COPY3]], %subreg.sub2, [[COPY4]], %subreg.sub3
  ; GFX908:   [[COPY5:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; GFX908:   BUFFER_ATOMIC_PK_ADD_F16_OFFSET [[COPY]], [[REG_SEQUENCE]], [[COPY5]], 0, 0, implicit $exec :: (volatile dereferenceable load store 4 on custom "BufferResource", align 1, addrspace 4)
  ; GFX908:   S_ENDPGM 0
  ; GFX90A-LABEL: name: raw_buffer_atomic_add_v2f16_noret__vgpr_val__sgpr_rsrc__0_voffset__sgpr_soffset
  ; GFX90A: bb.1 (%ir-block.0):
  ; GFX90A:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0
  ; GFX90A:   [[COPY:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; GFX90A:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; GFX90A:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; GFX90A:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; GFX90A:   [[COPY4:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; GFX90A:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY1]], %subreg.sub0, [[COPY2]], %subreg.sub1, [[COPY3]], %subreg.sub2, [[COPY4]], %subreg.sub3
  ; GFX90A:   [[COPY5:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; GFX90A:   [[BUFFER_ATOMIC_PK_ADD_F16_OFFSET_RTN:%[0-9]+]]:vgpr_32 = BUFFER_ATOMIC_PK_ADD_F16_OFFSET_RTN [[COPY]], [[REG_SEQUENCE]], [[COPY5]], 0, 1, 0, implicit $exec :: (volatile dereferenceable load store 4 on custom "BufferResource", align 1, addrspace 4)
  ; GFX90A:   S_ENDPGM 0
  %ret = call <2 x half> @llvm.amdgcn.raw.buffer.atomic.fadd.v2f16(<2 x half> %val, <4 x i32> %rsrc, i32 0, i32 %soffset, i32 0)
  ret void
}

declare float @llvm.amdgcn.raw.buffer.atomic.fadd.f32(float, <4 x i32>, i32, i32, i32 immarg) #0
declare <2 x half> @llvm.amdgcn.raw.buffer.atomic.fadd.v2f16(<2 x half>, <4 x i32>, i32, i32, i32 immarg) #0

attributes #0 = { nounwind }
