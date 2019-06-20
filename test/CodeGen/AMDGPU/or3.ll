; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=amdgcn-amd-mesa3d -mcpu=fiji -verify-machineinstrs | FileCheck -check-prefix=VI %s
; RUN: llc < %s -mtriple=amdgcn-amd-mesa3d -mcpu=gfx900 -verify-machineinstrs | FileCheck -check-prefix=GFX9 %s
; RUN: llc < %s -mtriple=amdgcn-amd-mesa3d -mcpu=gfx1010 -verify-machineinstrs | FileCheck -check-prefix=GFX10 %s

; ===================================================================================
; V_OR3_B32
; ===================================================================================

define amdgpu_ps float @or3(i32 %a, i32 %b, i32 %c) {
; VI-LABEL: or3:
; VI:       ; %bb.0:
; VI-NEXT:    v_or_b32_e32 v0, v0, v1
; VI-NEXT:    v_or_b32_e32 v0, v0, v2
; VI-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: or3:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_or3_b32 v0, v0, v1, v2
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: or3:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_or3_b32 v0, v0, v1, v2
; GFX10-NEXT:    ; implicit-def: $vcc_hi
; GFX10-NEXT:    ; return to shader part epilog
  %x = or i32 %a, %b
  %result = or i32 %x, %c
  %bc = bitcast i32 %result to float
  ret float %bc
}

; ThreeOp instruction variant not used due to Constant Bus Limitations
; TODO: with reassociation it is possible to replace a v_or_b32_e32 with an s_or_b32
define amdgpu_ps float @or3_vgpr_a(i32 %a, i32 inreg %b, i32 inreg %c) {
; VI-LABEL: or3_vgpr_a:
; VI:       ; %bb.0:
; VI-NEXT:    v_or_b32_e32 v0, s2, v0
; VI-NEXT:    v_or_b32_e32 v0, s3, v0
; VI-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: or3_vgpr_a:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_or_b32_e32 v0, s2, v0
; GFX9-NEXT:    v_or_b32_e32 v0, s3, v0
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: or3_vgpr_a:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_or3_b32 v0, v0, s2, s3
; GFX10-NEXT:    ; implicit-def: $vcc_hi
; GFX10-NEXT:    ; return to shader part epilog
  %x = or i32 %a, %b
  %result = or i32 %x, %c
  %bc = bitcast i32 %result to float
  ret float %bc
}

define amdgpu_ps float @or3_vgpr_all2(i32 %a, i32 %b, i32 %c) {
; VI-LABEL: or3_vgpr_all2:
; VI:       ; %bb.0:
; VI-NEXT:    v_or_b32_e32 v1, v1, v2
; VI-NEXT:    v_or_b32_e32 v0, v0, v1
; VI-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: or3_vgpr_all2:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_or3_b32 v0, v1, v2, v0
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: or3_vgpr_all2:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_or3_b32 v0, v1, v2, v0
; GFX10-NEXT:    ; implicit-def: $vcc_hi
; GFX10-NEXT:    ; return to shader part epilog
  %x = or i32 %b, %c
  %result = or i32 %a, %x
  %bc = bitcast i32 %result to float
  ret float %bc
}

define amdgpu_ps float @or3_vgpr_bc(i32 inreg %a, i32 %b, i32 %c) {
; VI-LABEL: or3_vgpr_bc:
; VI:       ; %bb.0:
; VI-NEXT:    v_or_b32_e32 v0, s2, v0
; VI-NEXT:    v_or_b32_e32 v0, v0, v1
; VI-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: or3_vgpr_bc:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_or3_b32 v0, s2, v0, v1
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: or3_vgpr_bc:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_or3_b32 v0, s2, v0, v1
; GFX10-NEXT:    ; implicit-def: $vcc_hi
; GFX10-NEXT:    ; return to shader part epilog
  %x = or i32 %a, %b
  %result = or i32 %x, %c
  %bc = bitcast i32 %result to float
  ret float %bc
}

define amdgpu_ps float @or3_vgpr_const(i32 %a, i32 %b) {
; VI-LABEL: or3_vgpr_const:
; VI:       ; %bb.0:
; VI-NEXT:    v_or_b32_e32 v0, v1, v0
; VI-NEXT:    v_or_b32_e32 v0, 64, v0
; VI-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: or3_vgpr_const:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_or3_b32 v0, v1, v0, 64
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: or3_vgpr_const:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_or3_b32 v0, v1, v0, 64
; GFX10-NEXT:    ; implicit-def: $vcc_hi
; GFX10-NEXT:    ; return to shader part epilog
  %x = or i32 64, %b
  %result = or i32 %x, %a
  %bc = bitcast i32 %result to float
  ret float %bc
}
