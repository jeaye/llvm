; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -march=amdgcn -verify-machineinstrs -simplifycfg-require-and-preserve-domtree=1 < %s | FileCheck -enable-var-scope %s

; Although it's modeled without any control flow in order to get better code
; out of the structurizer, @llvm.amdgcn.kill actually ends the thread that calls
; it with "true". In case it's called in a provably infinite loop, we still
; need to successfully exit and export something, even if we can't know where
; to jump to in the LLVM IR. Therefore we insert a null export ourselves in
; this case right before the s_endpgm to avoid GPU hangs, which is what this
; tests.

define amdgpu_ps void @return_void(float %0) #0 {
; CHECK-LABEL: return_void:
; CHECK:       ; %bb.0: ; %main_body
; CHECK-NEXT:    s_mov_b64 s[0:1], exec
; CHECK-NEXT:    s_mov_b32 s2, 0x41200000
; CHECK-NEXT:    v_cmp_ngt_f32_e32 vcc, s2, v0
; CHECK-NEXT:    s_and_saveexec_b64 s[2:3], vcc
; CHECK-NEXT:    s_xor_b64 s[2:3], exec, s[2:3]
; CHECK-NEXT:    s_cbranch_execz BB0_3
; CHECK-NEXT:  BB0_1: ; %loop
; CHECK-NEXT:    ; =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    s_andn2_b64 s[0:1], s[0:1], exec
; CHECK-NEXT:    s_cbranch_scc0 BB0_6
; CHECK-NEXT:  ; %bb.2: ; %loop
; CHECK-NEXT:    ; in Loop: Header=BB0_1 Depth=1
; CHECK-NEXT:    s_mov_b64 exec, 0
; CHECK-NEXT:    s_mov_b64 vcc, 0
; CHECK-NEXT:    s_branch BB0_1
; CHECK-NEXT:  BB0_3: ; %Flow1
; CHECK-NEXT:    s_or_saveexec_b64 s[0:1], s[2:3]
; CHECK-NEXT:    s_xor_b64 exec, exec, s[0:1]
; CHECK-NEXT:    s_cbranch_execz BB0_5
; CHECK-NEXT:  ; %bb.4: ; %end
; CHECK-NEXT:    v_mov_b32_e32 v0, 1.0
; CHECK-NEXT:    v_mov_b32_e32 v1, 0
; CHECK-NEXT:    exp mrt0 v1, v1, v1, v0 vm
; CHECK-NEXT:  BB0_5: ; %UnifiedReturnBlock
; CHECK-NEXT:    s_waitcnt expcnt(0)
; CHECK-NEXT:    s_or_b64 exec, exec, s[0:1]
; CHECK-NEXT:    exp null off, off, off, off done vm
; CHECK-NEXT:    s_endpgm
; CHECK-NEXT:  BB0_6:
; CHECK-NEXT:    s_mov_b64 exec, 0
; CHECK-NEXT:    exp null off, off, off, off done vm
; CHECK-NEXT:    s_endpgm
main_body:
  %cmp = fcmp olt float %0, 1.000000e+01
  br i1 %cmp, label %end, label %loop

loop:
  call void @llvm.amdgcn.kill(i1 false) #3
  br label %loop

end:
  call void @llvm.amdgcn.exp.f32(i32 0, i32 15, float 0., float 0., float 0., float 1., i1 true, i1 true) #3
  ret void
}

define amdgpu_ps void @return_void_compr(float %0) #0 {
; CHECK-LABEL: return_void_compr:
; CHECK:       ; %bb.0: ; %main_body
; CHECK-NEXT:    s_mov_b64 s[0:1], exec
; CHECK-NEXT:    s_mov_b32 s2, 0x41200000
; CHECK-NEXT:    v_cmp_ngt_f32_e32 vcc, s2, v0
; CHECK-NEXT:    s_and_saveexec_b64 s[2:3], vcc
; CHECK-NEXT:    s_xor_b64 s[2:3], exec, s[2:3]
; CHECK-NEXT:    s_cbranch_execz BB1_3
; CHECK-NEXT:  BB1_1: ; %loop
; CHECK-NEXT:    ; =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    s_andn2_b64 s[0:1], s[0:1], exec
; CHECK-NEXT:    s_cbranch_scc0 BB1_6
; CHECK-NEXT:  ; %bb.2: ; %loop
; CHECK-NEXT:    ; in Loop: Header=BB1_1 Depth=1
; CHECK-NEXT:    s_mov_b64 exec, 0
; CHECK-NEXT:    s_mov_b64 vcc, 0
; CHECK-NEXT:    s_branch BB1_1
; CHECK-NEXT:  BB1_3: ; %Flow1
; CHECK-NEXT:    s_or_saveexec_b64 s[0:1], s[2:3]
; CHECK-NEXT:    s_xor_b64 exec, exec, s[0:1]
; CHECK-NEXT:    s_cbranch_execz BB1_5
; CHECK-NEXT:  ; %bb.4: ; %end
; CHECK-NEXT:    v_mov_b32_e32 v0, 0
; CHECK-NEXT:    exp mrt0 v0, off, v0, off compr vm
; CHECK-NEXT:  BB1_5: ; %UnifiedReturnBlock
; CHECK-NEXT:    s_waitcnt expcnt(0)
; CHECK-NEXT:    s_or_b64 exec, exec, s[0:1]
; CHECK-NEXT:    exp null off, off, off, off done vm
; CHECK-NEXT:    s_endpgm
; CHECK-NEXT:  BB1_6:
; CHECK-NEXT:    s_mov_b64 exec, 0
; CHECK-NEXT:    exp null off, off, off, off done vm
; CHECK-NEXT:    s_endpgm
main_body:
  %cmp = fcmp olt float %0, 1.000000e+01
  br i1 %cmp, label %end, label %loop

loop:
  call void @llvm.amdgcn.kill(i1 false) #3
  br label %loop

end:
  call void @llvm.amdgcn.exp.compr.v2i16(i32 0, i32 5, <2 x i16> < i16 0, i16 0 >, <2 x i16> < i16 0, i16 0 >, i1 true, i1 true) #3
  ret void
}

; test the case where there's only a kill in an infinite loop
define amdgpu_ps void @only_kill() #0 {
; CHECK-LABEL: only_kill:
; CHECK:       ; %bb.0: ; %main_body
; CHECK-NEXT:    s_mov_b64 s[0:1], exec
; CHECK-NEXT:  BB2_1: ; %loop
; CHECK-NEXT:    ; =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    s_andn2_b64 s[0:1], s[0:1], exec
; CHECK-NEXT:    s_cbranch_scc0 BB2_4
; CHECK-NEXT:  ; %bb.2: ; %loop
; CHECK-NEXT:    ; in Loop: Header=BB2_1 Depth=1
; CHECK-NEXT:    s_mov_b64 exec, 0
; CHECK-NEXT:    s_mov_b64 vcc, exec
; CHECK-NEXT:    s_cbranch_execnz BB2_1
; CHECK-NEXT:  ; %bb.3: ; %UnifiedReturnBlock
; CHECK-NEXT:    exp null off, off, off, off done vm
; CHECK-NEXT:    s_endpgm
; CHECK-NEXT:  BB2_4:
; CHECK-NEXT:    s_mov_b64 exec, 0
; CHECK-NEXT:    exp null off, off, off, off done vm
; CHECK-NEXT:    s_endpgm
main_body:
  br label %loop

loop:
  call void @llvm.amdgcn.kill(i1 false) #3
  br label %loop
}

; Check that the epilog is the final block
define amdgpu_ps float @return_nonvoid(float %0) #0 {
; CHECK-LABEL: return_nonvoid:
; CHECK:       ; %bb.0: ; %main_body
; CHECK-NEXT:    s_mov_b64 s[0:1], exec
; CHECK-NEXT:    s_mov_b32 s2, 0x41200000
; CHECK-NEXT:    v_cmp_ngt_f32_e32 vcc, s2, v0
; CHECK-NEXT:    s_and_saveexec_b64 s[2:3], vcc
; CHECK-NEXT:    s_xor_b64 s[2:3], exec, s[2:3]
; CHECK-NEXT:    s_cbranch_execz BB3_3
; CHECK-NEXT:  BB3_1: ; %loop
; CHECK-NEXT:    ; =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    s_andn2_b64 s[0:1], s[0:1], exec
; CHECK-NEXT:    s_cbranch_scc0 BB3_4
; CHECK-NEXT:  ; %bb.2: ; %loop
; CHECK-NEXT:    ; in Loop: Header=BB3_1 Depth=1
; CHECK-NEXT:    s_mov_b64 exec, 0
; CHECK-NEXT:    s_mov_b64 vcc, exec
; CHECK-NEXT:    s_cbranch_execnz BB3_1
; CHECK-NEXT:  BB3_3: ; %Flow1
; CHECK-NEXT:    s_or_b64 exec, exec, s[2:3]
; CHECK-NEXT:    v_mov_b32_e32 v0, 0
; CHECK-NEXT:    s_branch BB3_5
; CHECK-NEXT:  BB3_4:
; CHECK-NEXT:    s_mov_b64 exec, 0
; CHECK-NEXT:    exp null off, off, off, off done vm
; CHECK-NEXT:    s_endpgm
; CHECK-NEXT:  BB3_5:
main_body:
  %cmp = fcmp olt float %0, 1.000000e+01
  br i1 %cmp, label %end, label %loop

loop:
  call void @llvm.amdgcn.kill(i1 false) #3
  br label %loop

end:
  ret float 0.
}

declare void @llvm.amdgcn.kill(i1) #0
declare void @llvm.amdgcn.exp.f32(i32 immarg, i32 immarg, float, float, float, float, i1 immarg, i1 immarg) #0
declare void @llvm.amdgcn.exp.compr.v2i16(i32 immarg, i32 immarg, <2 x i16>, <2 x i16>, i1 immarg, i1 immarg) #0

attributes #0 = { nounwind }
