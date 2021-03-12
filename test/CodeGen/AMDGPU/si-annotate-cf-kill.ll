; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -march=amdgcn -mcpu=verde -verify-machineinstrs | FileCheck --check-prefix=SI %s
; RUN: llc < %s -march=amdgcn -mcpu=tonga -mattr=-flat-for-global -verify-machineinstrs | FileCheck --check-prefix=FLAT %s

define amdgpu_ps float @uniform_kill(float %a, i32 %b, float %c) {
; SI-LABEL: uniform_kill:
; SI:       ; %bb.0: ; %entry
; SI-NEXT:    v_cvt_i32_f32_e32 v0, v0
; SI-NEXT:    s_mov_b64 s[0:1], exec
; SI-NEXT:    s_mov_b64 s[2:3], -1
; SI-NEXT:    v_or_b32_e32 v0, v1, v0
; SI-NEXT:    v_and_b32_e32 v0, 1, v0
; SI-NEXT:    v_cmp_eq_u32_e32 vcc, 1, v0
; SI-NEXT:    s_and_saveexec_b64 s[4:5], vcc
; SI-NEXT:  ; %bb.1: ; %if1
; SI-NEXT:    s_xor_b64 s[2:3], exec, -1
; SI-NEXT:  ; %bb.2: ; %endif1
; SI-NEXT:    s_or_b64 exec, exec, s[4:5]
; SI-NEXT:    s_wqm_b64 s[4:5], s[2:3]
; SI-NEXT:    s_xor_b64 s[4:5], s[4:5], exec
; SI-NEXT:    s_andn2_b64 s[0:1], s[0:1], s[4:5]
; SI-NEXT:    s_cbranch_scc0 BB0_6
; SI-NEXT:  ; %bb.3: ; %endif1
; SI-NEXT:    s_and_b64 exec, exec, s[0:1]
; SI-NEXT:    v_mov_b32_e32 v0, 0
; SI-NEXT:    s_and_saveexec_b64 s[0:1], s[2:3]
; SI-NEXT:    s_cbranch_execz BB0_5
; SI-NEXT:  ; %bb.4: ; %if2
; SI-NEXT:    s_mov_b32 s3, 0
; SI-NEXT:    v_add_f32_e32 v0, 1.0, v2
; SI-NEXT:    s_load_dwordx4 s[4:7], s[2:3], 0x0
; SI-NEXT:    v_cvt_i32_f32_e32 v0, v0
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    buffer_atomic_swap v0, off, s[4:7], 0 offset:4 glc
; SI-NEXT:    s_waitcnt vmcnt(0) expcnt(0)
; SI-NEXT:    v_cvt_f32_i32_e32 v0, v0
; SI-NEXT:  BB0_5: ; %endif2
; SI-NEXT:    s_or_b64 exec, exec, s[0:1]
; SI-NEXT:    s_branch BB0_7
; SI-NEXT:  BB0_6:
; SI-NEXT:    s_mov_b64 exec, 0
; SI-NEXT:    exp null off, off, off, off done vm
; SI-NEXT:    s_endpgm
; SI-NEXT:  BB0_7:
;
; FLAT-LABEL: uniform_kill:
; FLAT:       ; %bb.0: ; %entry
; FLAT-NEXT:    v_cvt_i32_f32_e32 v0, v0
; FLAT-NEXT:    s_mov_b64 s[0:1], exec
; FLAT-NEXT:    s_mov_b64 s[2:3], -1
; FLAT-NEXT:    v_or_b32_e32 v0, v1, v0
; FLAT-NEXT:    v_and_b32_e32 v0, 1, v0
; FLAT-NEXT:    v_cmp_eq_u32_e32 vcc, 1, v0
; FLAT-NEXT:    s_and_saveexec_b64 s[4:5], vcc
; FLAT-NEXT:  ; %bb.1: ; %if1
; FLAT-NEXT:    s_xor_b64 s[2:3], exec, -1
; FLAT-NEXT:  ; %bb.2: ; %endif1
; FLAT-NEXT:    s_or_b64 exec, exec, s[4:5]
; FLAT-NEXT:    s_wqm_b64 s[4:5], s[2:3]
; FLAT-NEXT:    s_xor_b64 s[4:5], s[4:5], exec
; FLAT-NEXT:    s_andn2_b64 s[0:1], s[0:1], s[4:5]
; FLAT-NEXT:    s_cbranch_scc0 BB0_6
; FLAT-NEXT:  ; %bb.3: ; %endif1
; FLAT-NEXT:    s_and_b64 exec, exec, s[0:1]
; FLAT-NEXT:    v_mov_b32_e32 v0, 0
; FLAT-NEXT:    s_and_saveexec_b64 s[0:1], s[2:3]
; FLAT-NEXT:    s_cbranch_execz BB0_5
; FLAT-NEXT:  ; %bb.4: ; %if2
; FLAT-NEXT:    s_mov_b32 s3, 0
; FLAT-NEXT:    v_add_f32_e32 v0, 1.0, v2
; FLAT-NEXT:    s_load_dwordx4 s[4:7], s[2:3], 0x0
; FLAT-NEXT:    v_cvt_i32_f32_e32 v0, v0
; FLAT-NEXT:    s_waitcnt lgkmcnt(0)
; FLAT-NEXT:    buffer_atomic_swap v0, off, s[4:7], 0 offset:4 glc
; FLAT-NEXT:    s_waitcnt vmcnt(0)
; FLAT-NEXT:    v_cvt_f32_i32_e32 v0, v0
; FLAT-NEXT:  BB0_5: ; %endif2
; FLAT-NEXT:    s_or_b64 exec, exec, s[0:1]
; FLAT-NEXT:    s_branch BB0_7
; FLAT-NEXT:  BB0_6:
; FLAT-NEXT:    s_mov_b64 exec, 0
; FLAT-NEXT:    exp null off, off, off, off done vm
; FLAT-NEXT:    s_endpgm
; FLAT-NEXT:  BB0_7:
entry:
  %.1 = fptosi float %a to i32
  %.2 = or i32 %b, %.1
  %.3 = and i32 %.2, 1
  %.not = icmp eq i32 %.3, 0
  br i1 %.not, label %endif1, label %if1

if1:
  br i1 false, label %if3, label %endif1

if3:
  br label %endif1

endif1:
  %.0 = phi i1 [ false, %if3 ], [ false, %if1 ], [ true, %entry ]
  %.4 = call i1 @llvm.amdgcn.wqm.vote(i1 %.0)
  ; This kill must be uniformly executed
  call void @llvm.amdgcn.kill(i1 %.4)
  %.test0 = fadd nsz arcp float %c, 1.0
  %.test1 = fptosi float %.test0 to i32
  br i1 %.0, label %if2, label %endif2

if2:
  %.5 = getelementptr inbounds <4 x i32>, <4 x i32> addrspace(6)* undef, i32 31, !amdgpu.uniform !0
  %.6 = load <4 x i32>, <4 x i32> addrspace(6)* %.5, align 16, !invariant.load !0
  %.7 = call i32 @llvm.amdgcn.raw.buffer.atomic.swap.i32(i32 %.test1, <4 x i32> %.6, i32 4, i32 0, i32 0)
  %.8 = sitofp i32 %.7 to float
  br label %endif2

endif2:
  %.9 = phi float [ %.8, %if2 ], [ 0.0, %endif1 ]
  ret float %.9
}


declare i32 @llvm.amdgcn.raw.buffer.atomic.swap.i32(i32, <4 x i32>, i32, i32, i32 immarg) #2
declare i1 @llvm.amdgcn.wqm.vote(i1) #3
declare void @llvm.amdgcn.kill(i1) #4
declare float @llvm.amdgcn.wqm.f32(float) #1

attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { nounwind willreturn }
attributes #3 = { convergent nounwind readnone willreturn }
attributes #4 = { nounwind }

!0 = !{}
