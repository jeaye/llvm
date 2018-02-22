; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=mipsel-unknown-linux-gnu   -mcpu=mips32   -relocation-model=pic -verify-machineinstrs | FileCheck %s -check-prefix=32
; RUN: llc < %s -mtriple=mipsel-unknown-linux-gnu   -mcpu=mips32r2 -relocation-model=pic -verify-machineinstrs | FileCheck %s -check-prefix=32R2
; RUN: llc < %s -mtriple=mipsel-unknown-linux-gnu   -mcpu=mips32r6 -relocation-model=pic -verify-machineinstrs | FileCheck %s -check-prefix=32R6
; RUN: llc < %s -mtriple=mips64el-unknown-linux-gnu -mcpu=mips64   -relocation-model=pic -verify-machineinstrs | FileCheck %s -check-prefix=64
; RUN: llc < %s -mtriple=mips64el-unknown-linux-gnu -mcpu=mips64r2 -relocation-model=pic -verify-machineinstrs | FileCheck %s -check-prefix=64R2
; RUN: llc < %s -mtriple=mips64el-unknown-linux-gnu -mcpu=mips64r6 -relocation-model=pic -verify-machineinstrs | FileCheck %s -check-prefix=64R6

@d2 = external global double
@d3 = external global double

define i32 @i32_icmp_ne_i32_val(i32 signext %s, i32 signext %f0, i32 signext %f1) nounwind readnone {
; 32-LABEL: i32_icmp_ne_i32_val:
; 32:       # %bb.0: # %entry
; 32-NEXT:    movn $5, $6, $4
; 32-NEXT:    jr $ra
; 32-NEXT:    move $2, $5
;
; 32R2-LABEL: i32_icmp_ne_i32_val:
; 32R2:       # %bb.0: # %entry
; 32R2-NEXT:    movn $5, $6, $4
; 32R2-NEXT:    jr $ra
; 32R2-NEXT:    move $2, $5
;
; 32R6-LABEL: i32_icmp_ne_i32_val:
; 32R6:       # %bb.0: # %entry
; 32R6-NEXT:    seleqz $1, $5, $4
; 32R6-NEXT:    selnez $2, $6, $4
; 32R6-NEXT:    jr $ra
; 32R6-NEXT:    or $2, $2, $1
;
; 64-LABEL: i32_icmp_ne_i32_val:
; 64:       # %bb.0: # %entry
; 64-NEXT:    movn $5, $6, $4
; 64-NEXT:    jr $ra
; 64-NEXT:    move $2, $5
;
; 64R2-LABEL: i32_icmp_ne_i32_val:
; 64R2:       # %bb.0: # %entry
; 64R2-NEXT:    movn $5, $6, $4
; 64R2-NEXT:    jr $ra
; 64R2-NEXT:    move $2, $5
;
; 64R6-LABEL: i32_icmp_ne_i32_val:
; 64R6:       # %bb.0: # %entry
; 64R6-NEXT:    seleqz $1, $5, $4
; 64R6-NEXT:    selnez $2, $6, $4
; 64R6-NEXT:    jr $ra
; 64R6-NEXT:    or $2, $2, $1
entry:
  %tobool = icmp ne i32 %s, 0
  %cond = select i1 %tobool, i32 %f1, i32 %f0
  ret i32 %cond
}

; FIXME: The sll works around an implementation detail in the code generator
;        (setcc's result is i32 so bits 32-63 are undefined). It's not really
;        needed.

define i64 @i32_icmp_ne_i64_val(i32 signext %s, i64 %f0, i64 %f1) nounwind readnone {
; 32-LABEL: i32_icmp_ne_i64_val:
; 32:       # %bb.0: # %entry
; 32-NEXT:    lw $1, 16($sp)
; 32-NEXT:    movn $6, $1, $4
; 32-NEXT:    lw $1, 20($sp)
; 32-NEXT:    movn $7, $1, $4
; 32-NEXT:    move $2, $6
; 32-NEXT:    jr $ra
; 32-NEXT:    move $3, $7
;
; 32R2-LABEL: i32_icmp_ne_i64_val:
; 32R2:       # %bb.0: # %entry
; 32R2-NEXT:    lw $1, 16($sp)
; 32R2-NEXT:    movn $6, $1, $4
; 32R2-NEXT:    lw $1, 20($sp)
; 32R2-NEXT:    movn $7, $1, $4
; 32R2-NEXT:    move $2, $6
; 32R2-NEXT:    jr $ra
; 32R2-NEXT:    move $3, $7
;
; 32R6-LABEL: i32_icmp_ne_i64_val:
; 32R6:       # %bb.0: # %entry
; 32R6-NEXT:    seleqz $1, $6, $4
; 32R6-NEXT:    lw $2, 16($sp)
; 32R6-NEXT:    selnez $2, $2, $4
; 32R6-NEXT:    or $2, $2, $1
; 32R6-NEXT:    seleqz $1, $7, $4
; 32R6-NEXT:    lw $3, 20($sp)
; 32R6-NEXT:    selnez $3, $3, $4
; 32R6-NEXT:    jr $ra
; 32R6-NEXT:    or $3, $3, $1
;
; 64-LABEL: i32_icmp_ne_i64_val:
; 64:       # %bb.0: # %entry
; 64-NEXT:    movn $5, $6, $4
; 64-NEXT:    jr $ra
; 64-NEXT:    move $2, $5
;
; 64R2-LABEL: i32_icmp_ne_i64_val:
; 64R2:       # %bb.0: # %entry
; 64R2-NEXT:    movn $5, $6, $4
; 64R2-NEXT:    jr $ra
; 64R2-NEXT:    move $2, $5
;
; 64R6-LABEL: i32_icmp_ne_i64_val:
; 64R6:       # %bb.0: # %entry
; 64R6-NEXT:    sll $1, $4, 0
; 64R6-NEXT:    seleqz $2, $5, $1
; 64R6-NEXT:    selnez $1, $6, $1
; 64R6-NEXT:    jr $ra
; 64R6-NEXT:    or $2, $1, $2
entry:
  %tobool = icmp ne i32 %s, 0
  %cond = select i1 %tobool, i64 %f1, i64 %f0
  ret i64 %cond
}

define i64 @i64_icmp_ne_i64_val(i64 %s, i64 %f0, i64 %f1) nounwind readnone {
; 32-LABEL: i64_icmp_ne_i64_val:
; 32:       # %bb.0: # %entry
; 32-NEXT:    or $1, $4, $5
; 32-NEXT:    lw $2, 16($sp)
; 32-NEXT:    movn $6, $2, $1
; 32-NEXT:    lw $2, 20($sp)
; 32-NEXT:    movn $7, $2, $1
; 32-NEXT:    move $2, $6
; 32-NEXT:    jr $ra
; 32-NEXT:    move $3, $7
;
; 32R2-LABEL: i64_icmp_ne_i64_val:
; 32R2:       # %bb.0: # %entry
; 32R2-NEXT:    or $1, $4, $5
; 32R2-NEXT:    lw $2, 16($sp)
; 32R2-NEXT:    movn $6, $2, $1
; 32R2-NEXT:    lw $2, 20($sp)
; 32R2-NEXT:    movn $7, $2, $1
; 32R2-NEXT:    move $2, $6
; 32R2-NEXT:    jr $ra
; 32R2-NEXT:    move $3, $7
;
; 32R6-LABEL: i64_icmp_ne_i64_val:
; 32R6:       # %bb.0: # %entry
; 32R6-NEXT:    or $1, $4, $5
; 32R6-NEXT:    seleqz $2, $6, $1
; 32R6-NEXT:    lw $3, 16($sp)
; 32R6-NEXT:    selnez $3, $3, $1
; 32R6-NEXT:    or $2, $3, $2
; 32R6-NEXT:    seleqz $3, $7, $1
; 32R6-NEXT:    lw $4, 20($sp)
; 32R6-NEXT:    selnez $1, $4, $1
; 32R6-NEXT:    jr $ra
; 32R6-NEXT:    or $3, $1, $3
;
; 64-LABEL: i64_icmp_ne_i64_val:
; 64:       # %bb.0: # %entry
; 64-NEXT:    movn $5, $6, $4
; 64-NEXT:    jr $ra
; 64-NEXT:    move $2, $5
;
; 64R2-LABEL: i64_icmp_ne_i64_val:
; 64R2:       # %bb.0: # %entry
; 64R2-NEXT:    movn $5, $6, $4
; 64R2-NEXT:    jr $ra
; 64R2-NEXT:    move $2, $5
;
; 64R6-LABEL: i64_icmp_ne_i64_val:
; 64R6:       # %bb.0: # %entry
; 64R6-NEXT:    seleqz $1, $5, $4
; 64R6-NEXT:    selnez $2, $6, $4
; 64R6-NEXT:    jr $ra
; 64R6-NEXT:    or $2, $2, $1
entry:
  %tobool = icmp ne i64 %s, 0
  %cond = select i1 %tobool, i64 %f1, i64 %f0
  ret i64 %cond
}

define float @i32_icmp_ne_f32_val(i32 signext %s, float %f0, float %f1) nounwind readnone {
; 32-LABEL: i32_icmp_ne_f32_val:
; 32:       # %bb.0: # %entry
; 32-NEXT:    mtc1 $6, $f0
; 32-NEXT:    mtc1 $5, $f1
; 32-NEXT:    jr $ra
; 32-NEXT:    movn.s $f0, $f1, $4
;
; 32R2-LABEL: i32_icmp_ne_f32_val:
; 32R2:       # %bb.0: # %entry
; 32R2-NEXT:    mtc1 $6, $f0
; 32R2-NEXT:    mtc1 $5, $f1
; 32R2-NEXT:    jr $ra
; 32R2-NEXT:    movn.s $f0, $f1, $4
;
; 32R6-LABEL: i32_icmp_ne_f32_val:
; 32R6:       # %bb.0: # %entry
; 32R6-NEXT:    sltu $1, $zero, $4
; 32R6-NEXT:    negu $1, $1
; 32R6-NEXT:    mtc1 $5, $f1
; 32R6-NEXT:    mtc1 $6, $f2
; 32R6-NEXT:    mtc1 $1, $f0
; 32R6-NEXT:    jr $ra
; 32R6-NEXT:    sel.s $f0, $f2, $f1
;
; 64-LABEL: i32_icmp_ne_f32_val:
; 64:       # %bb.0: # %entry
; 64-NEXT:    movn.s $f14, $f13, $4
; 64-NEXT:    jr $ra
; 64-NEXT:    mov.s $f0, $f14
;
; 64R2-LABEL: i32_icmp_ne_f32_val:
; 64R2:       # %bb.0: # %entry
; 64R2-NEXT:    movn.s $f14, $f13, $4
; 64R2-NEXT:    jr $ra
; 64R2-NEXT:    mov.s $f0, $f14
;
; 64R6-LABEL: i32_icmp_ne_f32_val:
; 64R6:       # %bb.0: # %entry
; 64R6-NEXT:    sltu $1, $zero, $4
; 64R6-NEXT:    negu $1, $1
; 64R6-NEXT:    mtc1 $1, $f0
; 64R6-NEXT:    jr $ra
; 64R6-NEXT:    sel.s $f0, $f14, $f13
entry:
  %tobool = icmp ne i32 %s, 0
  %cond = select i1 %tobool, float %f0, float %f1
  ret float %cond
}

define double @i32_icmp_ne_f64_val(i32 signext %s, double %f0, double %f1) nounwind readnone {
; 32-LABEL: i32_icmp_ne_f64_val:
; 32:       # %bb.0: # %entry
; 32-NEXT:    mtc1 $6, $f2
; 32-NEXT:    mtc1 $7, $f3
; 32-NEXT:    ldc1 $f0, 16($sp)
; 32-NEXT:    jr $ra
; 32-NEXT:    movn.d $f0, $f2, $4
;
; 32R2-LABEL: i32_icmp_ne_f64_val:
; 32R2:       # %bb.0: # %entry
; 32R2-NEXT:    mtc1 $6, $f2
; 32R2-NEXT:    mthc1 $7, $f2
; 32R2-NEXT:    ldc1 $f0, 16($sp)
; 32R2-NEXT:    jr $ra
; 32R2-NEXT:    movn.d $f0, $f2, $4
;
; 32R6-LABEL: i32_icmp_ne_f64_val:
; 32R6:       # %bb.0: # %entry
; 32R6-NEXT:    mtc1 $6, $f1
; 32R6-NEXT:    mthc1 $7, $f1
; 32R6-NEXT:    sltu $1, $zero, $4
; 32R6-NEXT:    negu $1, $1
; 32R6-NEXT:    mtc1 $1, $f0
; 32R6-NEXT:    ldc1 $f2, 16($sp)
; 32R6-NEXT:    jr $ra
; 32R6-NEXT:    sel.d $f0, $f2, $f1
;
; 64-LABEL: i32_icmp_ne_f64_val:
; 64:       # %bb.0: # %entry
; 64-NEXT:    movn.d $f14, $f13, $4
; 64-NEXT:    jr $ra
; 64-NEXT:    mov.d $f0, $f14
;
; 64R2-LABEL: i32_icmp_ne_f64_val:
; 64R2:       # %bb.0: # %entry
; 64R2-NEXT:    movn.d $f14, $f13, $4
; 64R2-NEXT:    jr $ra
; 64R2-NEXT:    mov.d $f0, $f14
;
; 64R6-LABEL: i32_icmp_ne_f64_val:
; 64R6:       # %bb.0: # %entry
; 64R6-NEXT:    sltu $1, $zero, $4
; 64R6-NEXT:    negu $1, $1
; 64R6-NEXT:    mtc1 $1, $f0
; 64R6-NEXT:    jr $ra
; 64R6-NEXT:    sel.d $f0, $f14, $f13
entry:
  %tobool = icmp ne i32 %s, 0
  %cond = select i1 %tobool, double %f0, double %f1
  ret double %cond
}

define float @f32_fcmp_oeq_f32_val(float %f0, float %f1, float %f2, float %f3) nounwind readnone {
; 32-LABEL: f32_fcmp_oeq_f32_val:
; 32:       # %bb.0: # %entry
; 32-NEXT:    mtc1 $7, $f0
; 32-NEXT:    mtc1 $6, $f1
; 32-NEXT:    c.eq.s $f1, $f0
; 32-NEXT:    movt.s $f14, $f12, $fcc0
; 32-NEXT:    jr $ra
; 32-NEXT:    mov.s $f0, $f14
;
; 32R2-LABEL: f32_fcmp_oeq_f32_val:
; 32R2:       # %bb.0: # %entry
; 32R2-NEXT:    mtc1 $7, $f0
; 32R2-NEXT:    mtc1 $6, $f1
; 32R2-NEXT:    c.eq.s $f1, $f0
; 32R2-NEXT:    movt.s $f14, $f12, $fcc0
; 32R2-NEXT:    jr $ra
; 32R2-NEXT:    mov.s $f0, $f14
;
; 32R6-LABEL: f32_fcmp_oeq_f32_val:
; 32R6:       # %bb.0: # %entry
; 32R6-NEXT:    mtc1 $7, $f0
; 32R6-NEXT:    mtc1 $6, $f1
; 32R6-NEXT:    cmp.eq.s $f0, $f1, $f0
; 32R6-NEXT:    jr $ra
; 32R6-NEXT:    sel.s $f0, $f14, $f12
;
; 64-LABEL: f32_fcmp_oeq_f32_val:
; 64:       # %bb.0: # %entry
; 64-NEXT:    c.eq.s $f14, $f15
; 64-NEXT:    movt.s $f13, $f12, $fcc0
; 64-NEXT:    jr $ra
; 64-NEXT:    mov.s $f0, $f13
;
; 64R2-LABEL: f32_fcmp_oeq_f32_val:
; 64R2:       # %bb.0: # %entry
; 64R2-NEXT:    c.eq.s $f14, $f15
; 64R2-NEXT:    movt.s $f13, $f12, $fcc0
; 64R2-NEXT:    jr $ra
; 64R2-NEXT:    mov.s $f0, $f13
;
; 64R6-LABEL: f32_fcmp_oeq_f32_val:
; 64R6:       # %bb.0: # %entry
; 64R6-NEXT:    cmp.eq.s $f0, $f14, $f15
; 64R6-NEXT:    jr $ra
; 64R6-NEXT:    sel.s $f0, $f13, $f12
entry:
  %cmp = fcmp oeq float %f2, %f3
  %cond = select i1 %cmp, float %f0, float %f1
  ret float %cond
}

define float @f32_fcmp_olt_f32_val(float %f0, float %f1, float %f2, float %f3) nounwind readnone {
; 32-LABEL: f32_fcmp_olt_f32_val:
; 32:       # %bb.0: # %entry
; 32-NEXT:    mtc1 $7, $f0
; 32-NEXT:    mtc1 $6, $f1
; 32-NEXT:    c.olt.s $f1, $f0
; 32-NEXT:    movt.s $f14, $f12, $fcc0
; 32-NEXT:    jr $ra
; 32-NEXT:    mov.s $f0, $f14
;
; 32R2-LABEL: f32_fcmp_olt_f32_val:
; 32R2:       # %bb.0: # %entry
; 32R2-NEXT:    mtc1 $7, $f0
; 32R2-NEXT:    mtc1 $6, $f1
; 32R2-NEXT:    c.olt.s $f1, $f0
; 32R2-NEXT:    movt.s $f14, $f12, $fcc0
; 32R2-NEXT:    jr $ra
; 32R2-NEXT:    mov.s $f0, $f14
;
; 32R6-LABEL: f32_fcmp_olt_f32_val:
; 32R6:       # %bb.0: # %entry
; 32R6-NEXT:    mtc1 $7, $f0
; 32R6-NEXT:    mtc1 $6, $f1
; 32R6-NEXT:    cmp.lt.s $f0, $f1, $f0
; 32R6-NEXT:    jr $ra
; 32R6-NEXT:    sel.s $f0, $f14, $f12
;
; 64-LABEL: f32_fcmp_olt_f32_val:
; 64:       # %bb.0: # %entry
; 64-NEXT:    c.olt.s $f14, $f15
; 64-NEXT:    movt.s $f13, $f12, $fcc0
; 64-NEXT:    jr $ra
; 64-NEXT:    mov.s $f0, $f13
;
; 64R2-LABEL: f32_fcmp_olt_f32_val:
; 64R2:       # %bb.0: # %entry
; 64R2-NEXT:    c.olt.s $f14, $f15
; 64R2-NEXT:    movt.s $f13, $f12, $fcc0
; 64R2-NEXT:    jr $ra
; 64R2-NEXT:    mov.s $f0, $f13
;
; 64R6-LABEL: f32_fcmp_olt_f32_val:
; 64R6:       # %bb.0: # %entry
; 64R6-NEXT:    cmp.lt.s $f0, $f14, $f15
; 64R6-NEXT:    jr $ra
; 64R6-NEXT:    sel.s $f0, $f13, $f12
entry:
  %cmp = fcmp olt float %f2, %f3
  %cond = select i1 %cmp, float %f0, float %f1
  ret float %cond
}

define float @f32_fcmp_ogt_f32_val(float %f0, float %f1, float %f2, float %f3) nounwind readnone {
; 32-LABEL: f32_fcmp_ogt_f32_val:
; 32:       # %bb.0: # %entry
; 32-NEXT:    mtc1 $7, $f0
; 32-NEXT:    mtc1 $6, $f1
; 32-NEXT:    c.ule.s $f1, $f0
; 32-NEXT:    movf.s $f14, $f12, $fcc0
; 32-NEXT:    jr $ra
; 32-NEXT:    mov.s $f0, $f14
;
; 32R2-LABEL: f32_fcmp_ogt_f32_val:
; 32R2:       # %bb.0: # %entry
; 32R2-NEXT:    mtc1 $7, $f0
; 32R2-NEXT:    mtc1 $6, $f1
; 32R2-NEXT:    c.ule.s $f1, $f0
; 32R2-NEXT:    movf.s $f14, $f12, $fcc0
; 32R2-NEXT:    jr $ra
; 32R2-NEXT:    mov.s $f0, $f14
;
; 32R6-LABEL: f32_fcmp_ogt_f32_val:
; 32R6:       # %bb.0: # %entry
; 32R6-NEXT:    mtc1 $6, $f0
; 32R6-NEXT:    mtc1 $7, $f1
; 32R6-NEXT:    cmp.lt.s $f0, $f1, $f0
; 32R6-NEXT:    jr $ra
; 32R6-NEXT:    sel.s $f0, $f14, $f12
;
; 64-LABEL: f32_fcmp_ogt_f32_val:
; 64:       # %bb.0: # %entry
; 64-NEXT:    c.ule.s $f14, $f15
; 64-NEXT:    movf.s $f13, $f12, $fcc0
; 64-NEXT:    jr $ra
; 64-NEXT:    mov.s $f0, $f13
;
; 64R2-LABEL: f32_fcmp_ogt_f32_val:
; 64R2:       # %bb.0: # %entry
; 64R2-NEXT:    c.ule.s $f14, $f15
; 64R2-NEXT:    movf.s $f13, $f12, $fcc0
; 64R2-NEXT:    jr $ra
; 64R2-NEXT:    mov.s $f0, $f13
;
; 64R6-LABEL: f32_fcmp_ogt_f32_val:
; 64R6:       # %bb.0: # %entry
; 64R6-NEXT:    cmp.lt.s $f0, $f15, $f14
; 64R6-NEXT:    jr $ra
; 64R6-NEXT:    sel.s $f0, $f13, $f12
entry:
  %cmp = fcmp ogt float %f2, %f3
  %cond = select i1 %cmp, float %f0, float %f1
  ret float %cond
}

define double @f32_fcmp_ogt_f64_val(double %f0, double %f1, float %f2, float %f3) nounwind readnone {
; 32-LABEL: f32_fcmp_ogt_f64_val:
; 32:       # %bb.0: # %entry
; 32-NEXT:    lwc1 $f0, 20($sp)
; 32-NEXT:    lwc1 $f1, 16($sp)
; 32-NEXT:    c.ule.s $f1, $f0
; 32-NEXT:    movf.d $f14, $f12, $fcc0
; 32-NEXT:    jr $ra
; 32-NEXT:    mov.d $f0, $f14
;
; 32R2-LABEL: f32_fcmp_ogt_f64_val:
; 32R2:       # %bb.0: # %entry
; 32R2-NEXT:    lwc1 $f0, 20($sp)
; 32R2-NEXT:    lwc1 $f1, 16($sp)
; 32R2-NEXT:    c.ule.s $f1, $f0
; 32R2-NEXT:    movf.d $f14, $f12, $fcc0
; 32R2-NEXT:    jr $ra
; 32R2-NEXT:    mov.d $f0, $f14
;
; 32R6-LABEL: f32_fcmp_ogt_f64_val:
; 32R6:       # %bb.0: # %entry
; 32R6-NEXT:    lwc1 $f0, 16($sp)
; 32R6-NEXT:    lwc1 $f1, 20($sp)
; 32R6-NEXT:    cmp.lt.s $f0, $f1, $f0
; 32R6-NEXT:    mfc1 $1, $f0
; 32R6-NEXT:    mtc1 $1, $f0
; 32R6-NEXT:    jr $ra
; 32R6-NEXT:    sel.d $f0, $f14, $f12
;
; 64-LABEL: f32_fcmp_ogt_f64_val:
; 64:       # %bb.0: # %entry
; 64-NEXT:    c.ule.s $f14, $f15
; 64-NEXT:    movf.d $f13, $f12, $fcc0
; 64-NEXT:    jr $ra
; 64-NEXT:    mov.d $f0, $f13
;
; 64R2-LABEL: f32_fcmp_ogt_f64_val:
; 64R2:       # %bb.0: # %entry
; 64R2-NEXT:    c.ule.s $f14, $f15
; 64R2-NEXT:    movf.d $f13, $f12, $fcc0
; 64R2-NEXT:    jr $ra
; 64R2-NEXT:    mov.d $f0, $f13
;
; 64R6-LABEL: f32_fcmp_ogt_f64_val:
; 64R6:       # %bb.0: # %entry
; 64R6-NEXT:    cmp.lt.s $f0, $f15, $f14
; 64R6-NEXT:    mfc1 $1, $f0
; 64R6-NEXT:    mtc1 $1, $f0
; 64R6-NEXT:    jr $ra
; 64R6-NEXT:    sel.d $f0, $f13, $f12
entry:
  %cmp = fcmp ogt float %f2, %f3
  %cond = select i1 %cmp, double %f0, double %f1
  ret double %cond
}

define double @f64_fcmp_oeq_f64_val(double %f0, double %f1, double %f2, double %f3) nounwind readnone {
; 32-LABEL: f64_fcmp_oeq_f64_val:
; 32:       # %bb.0: # %entry
; 32-NEXT:    ldc1 $f0, 24($sp)
; 32-NEXT:    ldc1 $f2, 16($sp)
; 32-NEXT:    c.eq.d $f2, $f0
; 32-NEXT:    movt.d $f14, $f12, $fcc0
; 32-NEXT:    jr $ra
; 32-NEXT:    mov.d $f0, $f14
;
; 32R2-LABEL: f64_fcmp_oeq_f64_val:
; 32R2:       # %bb.0: # %entry
; 32R2-NEXT:    ldc1 $f0, 24($sp)
; 32R2-NEXT:    ldc1 $f2, 16($sp)
; 32R2-NEXT:    c.eq.d $f2, $f0
; 32R2-NEXT:    movt.d $f14, $f12, $fcc0
; 32R2-NEXT:    jr $ra
; 32R2-NEXT:    mov.d $f0, $f14
;
; 32R6-LABEL: f64_fcmp_oeq_f64_val:
; 32R6:       # %bb.0: # %entry
; 32R6-NEXT:    ldc1 $f0, 24($sp)
; 32R6-NEXT:    ldc1 $f1, 16($sp)
; 32R6-NEXT:    cmp.eq.d $f0, $f1, $f0
; 32R6-NEXT:    mfc1 $1, $f0
; 32R6-NEXT:    mtc1 $1, $f0
; 32R6-NEXT:    jr $ra
; 32R6-NEXT:    sel.d $f0, $f14, $f12
;
; 64-LABEL: f64_fcmp_oeq_f64_val:
; 64:       # %bb.0: # %entry
; 64-NEXT:    c.eq.d $f14, $f15
; 64-NEXT:    movt.d $f13, $f12, $fcc0
; 64-NEXT:    jr $ra
; 64-NEXT:    mov.d $f0, $f13
;
; 64R2-LABEL: f64_fcmp_oeq_f64_val:
; 64R2:       # %bb.0: # %entry
; 64R2-NEXT:    c.eq.d $f14, $f15
; 64R2-NEXT:    movt.d $f13, $f12, $fcc0
; 64R2-NEXT:    jr $ra
; 64R2-NEXT:    mov.d $f0, $f13
;
; 64R6-LABEL: f64_fcmp_oeq_f64_val:
; 64R6:       # %bb.0: # %entry
; 64R6-NEXT:    cmp.eq.d $f0, $f14, $f15
; 64R6-NEXT:    mfc1 $1, $f0
; 64R6-NEXT:    mtc1 $1, $f0
; 64R6-NEXT:    jr $ra
; 64R6-NEXT:    sel.d $f0, $f13, $f12
entry:
  %cmp = fcmp oeq double %f2, %f3
  %cond = select i1 %cmp, double %f0, double %f1
  ret double %cond
}

define double @f64_fcmp_olt_f64_val(double %f0, double %f1, double %f2, double %f3) nounwind readnone {
; 32-LABEL: f64_fcmp_olt_f64_val:
; 32:       # %bb.0: # %entry
; 32-NEXT:    ldc1 $f0, 24($sp)
; 32-NEXT:    ldc1 $f2, 16($sp)
; 32-NEXT:    c.olt.d $f2, $f0
; 32-NEXT:    movt.d $f14, $f12, $fcc0
; 32-NEXT:    jr $ra
; 32-NEXT:    mov.d $f0, $f14
;
; 32R2-LABEL: f64_fcmp_olt_f64_val:
; 32R2:       # %bb.0: # %entry
; 32R2-NEXT:    ldc1 $f0, 24($sp)
; 32R2-NEXT:    ldc1 $f2, 16($sp)
; 32R2-NEXT:    c.olt.d $f2, $f0
; 32R2-NEXT:    movt.d $f14, $f12, $fcc0
; 32R2-NEXT:    jr $ra
; 32R2-NEXT:    mov.d $f0, $f14
;
; 32R6-LABEL: f64_fcmp_olt_f64_val:
; 32R6:       # %bb.0: # %entry
; 32R6-NEXT:    ldc1 $f0, 24($sp)
; 32R6-NEXT:    ldc1 $f1, 16($sp)
; 32R6-NEXT:    cmp.lt.d $f0, $f1, $f0
; 32R6-NEXT:    mfc1 $1, $f0
; 32R6-NEXT:    mtc1 $1, $f0
; 32R6-NEXT:    jr $ra
; 32R6-NEXT:    sel.d $f0, $f14, $f12
;
; 64-LABEL: f64_fcmp_olt_f64_val:
; 64:       # %bb.0: # %entry
; 64-NEXT:    c.olt.d $f14, $f15
; 64-NEXT:    movt.d $f13, $f12, $fcc0
; 64-NEXT:    jr $ra
; 64-NEXT:    mov.d $f0, $f13
;
; 64R2-LABEL: f64_fcmp_olt_f64_val:
; 64R2:       # %bb.0: # %entry
; 64R2-NEXT:    c.olt.d $f14, $f15
; 64R2-NEXT:    movt.d $f13, $f12, $fcc0
; 64R2-NEXT:    jr $ra
; 64R2-NEXT:    mov.d $f0, $f13
;
; 64R6-LABEL: f64_fcmp_olt_f64_val:
; 64R6:       # %bb.0: # %entry
; 64R6-NEXT:    cmp.lt.d $f0, $f14, $f15
; 64R6-NEXT:    mfc1 $1, $f0
; 64R6-NEXT:    mtc1 $1, $f0
; 64R6-NEXT:    jr $ra
; 64R6-NEXT:    sel.d $f0, $f13, $f12
entry:
  %cmp = fcmp olt double %f2, %f3
  %cond = select i1 %cmp, double %f0, double %f1
  ret double %cond
}

define double @f64_fcmp_ogt_f64_val(double %f0, double %f1, double %f2, double %f3) nounwind readnone {
; 32-LABEL: f64_fcmp_ogt_f64_val:
; 32:       # %bb.0: # %entry
; 32-NEXT:    ldc1 $f0, 24($sp)
; 32-NEXT:    ldc1 $f2, 16($sp)
; 32-NEXT:    c.ule.d $f2, $f0
; 32-NEXT:    movf.d $f14, $f12, $fcc0
; 32-NEXT:    jr $ra
; 32-NEXT:    mov.d $f0, $f14
;
; 32R2-LABEL: f64_fcmp_ogt_f64_val:
; 32R2:       # %bb.0: # %entry
; 32R2-NEXT:    ldc1 $f0, 24($sp)
; 32R2-NEXT:    ldc1 $f2, 16($sp)
; 32R2-NEXT:    c.ule.d $f2, $f0
; 32R2-NEXT:    movf.d $f14, $f12, $fcc0
; 32R2-NEXT:    jr $ra
; 32R2-NEXT:    mov.d $f0, $f14
;
; 32R6-LABEL: f64_fcmp_ogt_f64_val:
; 32R6:       # %bb.0: # %entry
; 32R6-NEXT:    ldc1 $f0, 16($sp)
; 32R6-NEXT:    ldc1 $f1, 24($sp)
; 32R6-NEXT:    cmp.lt.d $f0, $f1, $f0
; 32R6-NEXT:    mfc1 $1, $f0
; 32R6-NEXT:    mtc1 $1, $f0
; 32R6-NEXT:    jr $ra
; 32R6-NEXT:    sel.d $f0, $f14, $f12
;
; 64-LABEL: f64_fcmp_ogt_f64_val:
; 64:       # %bb.0: # %entry
; 64-NEXT:    c.ule.d $f14, $f15
; 64-NEXT:    movf.d $f13, $f12, $fcc0
; 64-NEXT:    jr $ra
; 64-NEXT:    mov.d $f0, $f13
;
; 64R2-LABEL: f64_fcmp_ogt_f64_val:
; 64R2:       # %bb.0: # %entry
; 64R2-NEXT:    c.ule.d $f14, $f15
; 64R2-NEXT:    movf.d $f13, $f12, $fcc0
; 64R2-NEXT:    jr $ra
; 64R2-NEXT:    mov.d $f0, $f13
;
; 64R6-LABEL: f64_fcmp_ogt_f64_val:
; 64R6:       # %bb.0: # %entry
; 64R6-NEXT:    cmp.lt.d $f0, $f15, $f14
; 64R6-NEXT:    mfc1 $1, $f0
; 64R6-NEXT:    mtc1 $1, $f0
; 64R6-NEXT:    jr $ra
; 64R6-NEXT:    sel.d $f0, $f13, $f12
entry:
  %cmp = fcmp ogt double %f2, %f3
  %cond = select i1 %cmp, double %f0, double %f1
  ret double %cond
}

define float @f64_fcmp_ogt_f32_val(float %f0, float %f1, double %f2, double %f3) nounwind readnone {
; 32-LABEL: f64_fcmp_ogt_f32_val:
; 32:       # %bb.0: # %entry
; 32-NEXT:    mtc1 $6, $f0
; 32-NEXT:    mtc1 $7, $f1
; 32-NEXT:    ldc1 $f2, 16($sp)
; 32-NEXT:    c.ule.d $f0, $f2
; 32-NEXT:    movf.s $f14, $f12, $fcc0
; 32-NEXT:    jr $ra
; 32-NEXT:    mov.s $f0, $f14
;
; 32R2-LABEL: f64_fcmp_ogt_f32_val:
; 32R2:       # %bb.0: # %entry
; 32R2-NEXT:    mtc1 $6, $f0
; 32R2-NEXT:    mthc1 $7, $f0
; 32R2-NEXT:    ldc1 $f2, 16($sp)
; 32R2-NEXT:    c.ule.d $f0, $f2
; 32R2-NEXT:    movf.s $f14, $f12, $fcc0
; 32R2-NEXT:    jr $ra
; 32R2-NEXT:    mov.s $f0, $f14
;
; 32R6-LABEL: f64_fcmp_ogt_f32_val:
; 32R6:       # %bb.0: # %entry
; 32R6-NEXT:    mtc1 $6, $f0
; 32R6-NEXT:    mthc1 $7, $f0
; 32R6-NEXT:    ldc1 $f1, 16($sp)
; 32R6-NEXT:    cmp.lt.d $f0, $f1, $f0
; 32R6-NEXT:    jr $ra
; 32R6-NEXT:    sel.s $f0, $f14, $f12
;
; 64-LABEL: f64_fcmp_ogt_f32_val:
; 64:       # %bb.0: # %entry
; 64-NEXT:    c.ule.d $f14, $f15
; 64-NEXT:    movf.s $f13, $f12, $fcc0
; 64-NEXT:    jr $ra
; 64-NEXT:    mov.s $f0, $f13
;
; 64R2-LABEL: f64_fcmp_ogt_f32_val:
; 64R2:       # %bb.0: # %entry
; 64R2-NEXT:    c.ule.d $f14, $f15
; 64R2-NEXT:    movf.s $f13, $f12, $fcc0
; 64R2-NEXT:    jr $ra
; 64R2-NEXT:    mov.s $f0, $f13
;
; 64R6-LABEL: f64_fcmp_ogt_f32_val:
; 64R6:       # %bb.0: # %entry
; 64R6-NEXT:    cmp.lt.d $f0, $f15, $f14
; 64R6-NEXT:    jr $ra
; 64R6-NEXT:    sel.s $f0, $f13, $f12
entry:
  %cmp = fcmp ogt double %f2, %f3
  %cond = select i1 %cmp, float %f0, float %f1
  ret float %cond
}

define i32 @f32_fcmp_oeq_i32_val(i32 signext %f0, i32 signext %f1, float %f2, float %f3) nounwind readnone {
; 32-LABEL: f32_fcmp_oeq_i32_val:
; 32:       # %bb.0: # %entry
; 32-NEXT:    mtc1 $7, $f0
; 32-NEXT:    mtc1 $6, $f1
; 32-NEXT:    c.eq.s $f1, $f0
; 32-NEXT:    movt $5, $4, $fcc0
; 32-NEXT:    jr $ra
; 32-NEXT:    move $2, $5
;
; 32R2-LABEL: f32_fcmp_oeq_i32_val:
; 32R2:       # %bb.0: # %entry
; 32R2-NEXT:    mtc1 $7, $f0
; 32R2-NEXT:    mtc1 $6, $f1
; 32R2-NEXT:    c.eq.s $f1, $f0
; 32R2-NEXT:    movt $5, $4, $fcc0
; 32R2-NEXT:    jr $ra
; 32R2-NEXT:    move $2, $5
;
; 32R6-LABEL: f32_fcmp_oeq_i32_val:
; 32R6:       # %bb.0: # %entry
; 32R6-NEXT:    mtc1 $7, $f0
; 32R6-NEXT:    mtc1 $6, $f1
; 32R6-NEXT:    cmp.eq.s $f0, $f1, $f0
; 32R6-NEXT:    mfc1 $1, $f0
; 32R6-NEXT:    andi $1, $1, 1
; 32R6-NEXT:    seleqz $2, $5, $1
; 32R6-NEXT:    selnez $1, $4, $1
; 32R6-NEXT:    jr $ra
; 32R6-NEXT:    or $2, $1, $2
;
; 64-LABEL: f32_fcmp_oeq_i32_val:
; 64:       # %bb.0: # %entry
; 64-NEXT:    c.eq.s $f14, $f15
; 64-NEXT:    movt $5, $4, $fcc0
; 64-NEXT:    jr $ra
; 64-NEXT:    move $2, $5
;
; 64R2-LABEL: f32_fcmp_oeq_i32_val:
; 64R2:       # %bb.0: # %entry
; 64R2-NEXT:    c.eq.s $f14, $f15
; 64R2-NEXT:    movt $5, $4, $fcc0
; 64R2-NEXT:    jr $ra
; 64R2-NEXT:    move $2, $5
;
; 64R6-LABEL: f32_fcmp_oeq_i32_val:
; 64R6:       # %bb.0: # %entry
; 64R6-NEXT:    cmp.eq.s $f0, $f14, $f15
; 64R6-NEXT:    mfc1 $1, $f0
; 64R6-NEXT:    andi $1, $1, 1
; 64R6-NEXT:    seleqz $2, $5, $1
; 64R6-NEXT:    selnez $1, $4, $1
; 64R6-NEXT:    jr $ra
; 64R6-NEXT:    or $2, $1, $2
entry:
  %cmp = fcmp oeq float %f2, %f3
  %cond = select i1 %cmp, i32 %f0, i32 %f1
  ret i32 %cond
}

define i32 @f32_fcmp_olt_i32_val(i32 signext %f0, i32 signext %f1, float %f2, float %f3) nounwind readnone {
; 32-LABEL: f32_fcmp_olt_i32_val:
; 32:       # %bb.0: # %entry
; 32-NEXT:    mtc1 $7, $f0
; 32-NEXT:    mtc1 $6, $f1
; 32-NEXT:    c.olt.s $f1, $f0
; 32-NEXT:    movt $5, $4, $fcc0
; 32-NEXT:    jr $ra
; 32-NEXT:    move $2, $5
;
; 32R2-LABEL: f32_fcmp_olt_i32_val:
; 32R2:       # %bb.0: # %entry
; 32R2-NEXT:    mtc1 $7, $f0
; 32R2-NEXT:    mtc1 $6, $f1
; 32R2-NEXT:    c.olt.s $f1, $f0
; 32R2-NEXT:    movt $5, $4, $fcc0
; 32R2-NEXT:    jr $ra
; 32R2-NEXT:    move $2, $5
;
; 32R6-LABEL: f32_fcmp_olt_i32_val:
; 32R6:       # %bb.0: # %entry
; 32R6-NEXT:    mtc1 $7, $f0
; 32R6-NEXT:    mtc1 $6, $f1
; 32R6-NEXT:    cmp.lt.s $f0, $f1, $f0
; 32R6-NEXT:    mfc1 $1, $f0
; 32R6-NEXT:    andi $1, $1, 1
; 32R6-NEXT:    seleqz $2, $5, $1
; 32R6-NEXT:    selnez $1, $4, $1
; 32R6-NEXT:    jr $ra
; 32R6-NEXT:    or $2, $1, $2
;
; 64-LABEL: f32_fcmp_olt_i32_val:
; 64:       # %bb.0: # %entry
; 64-NEXT:    c.olt.s $f14, $f15
; 64-NEXT:    movt $5, $4, $fcc0
; 64-NEXT:    jr $ra
; 64-NEXT:    move $2, $5
;
; 64R2-LABEL: f32_fcmp_olt_i32_val:
; 64R2:       # %bb.0: # %entry
; 64R2-NEXT:    c.olt.s $f14, $f15
; 64R2-NEXT:    movt $5, $4, $fcc0
; 64R2-NEXT:    jr $ra
; 64R2-NEXT:    move $2, $5
;
; 64R6-LABEL: f32_fcmp_olt_i32_val:
; 64R6:       # %bb.0: # %entry
; 64R6-NEXT:    cmp.lt.s $f0, $f14, $f15
; 64R6-NEXT:    mfc1 $1, $f0
; 64R6-NEXT:    andi $1, $1, 1
; 64R6-NEXT:    seleqz $2, $5, $1
; 64R6-NEXT:    selnez $1, $4, $1
; 64R6-NEXT:    jr $ra
; 64R6-NEXT:    or $2, $1, $2
entry:
  %cmp = fcmp olt float %f2, %f3
  %cond = select i1 %cmp, i32 %f0, i32 %f1
  ret i32 %cond
}

define i32 @f32_fcmp_ogt_i32_val(i32 signext %f0, i32 signext %f1, float %f2, float %f3) nounwind readnone {
; 32-LABEL: f32_fcmp_ogt_i32_val:
; 32:       # %bb.0: # %entry
; 32-NEXT:    mtc1 $7, $f0
; 32-NEXT:    mtc1 $6, $f1
; 32-NEXT:    c.ule.s $f1, $f0
; 32-NEXT:    movf $5, $4, $fcc0
; 32-NEXT:    jr $ra
; 32-NEXT:    move $2, $5
;
; 32R2-LABEL: f32_fcmp_ogt_i32_val:
; 32R2:       # %bb.0: # %entry
; 32R2-NEXT:    mtc1 $7, $f0
; 32R2-NEXT:    mtc1 $6, $f1
; 32R2-NEXT:    c.ule.s $f1, $f0
; 32R2-NEXT:    movf $5, $4, $fcc0
; 32R2-NEXT:    jr $ra
; 32R2-NEXT:    move $2, $5
;
; 32R6-LABEL: f32_fcmp_ogt_i32_val:
; 32R6:       # %bb.0: # %entry
; 32R6-NEXT:    mtc1 $6, $f0
; 32R6-NEXT:    mtc1 $7, $f1
; 32R6-NEXT:    cmp.lt.s $f0, $f1, $f0
; 32R6-NEXT:    mfc1 $1, $f0
; 32R6-NEXT:    andi $1, $1, 1
; 32R6-NEXT:    seleqz $2, $5, $1
; 32R6-NEXT:    selnez $1, $4, $1
; 32R6-NEXT:    jr $ra
; 32R6-NEXT:    or $2, $1, $2
;
; 64-LABEL: f32_fcmp_ogt_i32_val:
; 64:       # %bb.0: # %entry
; 64-NEXT:    c.ule.s $f14, $f15
; 64-NEXT:    movf $5, $4, $fcc0
; 64-NEXT:    jr $ra
; 64-NEXT:    move $2, $5
;
; 64R2-LABEL: f32_fcmp_ogt_i32_val:
; 64R2:       # %bb.0: # %entry
; 64R2-NEXT:    c.ule.s $f14, $f15
; 64R2-NEXT:    movf $5, $4, $fcc0
; 64R2-NEXT:    jr $ra
; 64R2-NEXT:    move $2, $5
;
; 64R6-LABEL: f32_fcmp_ogt_i32_val:
; 64R6:       # %bb.0: # %entry
; 64R6-NEXT:    cmp.lt.s $f0, $f15, $f14
; 64R6-NEXT:    mfc1 $1, $f0
; 64R6-NEXT:    andi $1, $1, 1
; 64R6-NEXT:    seleqz $2, $5, $1
; 64R6-NEXT:    selnez $1, $4, $1
; 64R6-NEXT:    jr $ra
; 64R6-NEXT:    or $2, $1, $2
entry:
  %cmp = fcmp ogt float %f2, %f3
  %cond = select i1 %cmp, i32 %f0, i32 %f1
  ret i32 %cond
}

define i32 @f64_fcmp_oeq_i32_val(i32 signext %f0, i32 signext %f1) nounwind readonly {
; 32-LABEL: f64_fcmp_oeq_i32_val:
; 32:       # %bb.0: # %entry
; 32-NEXT:    lui $2, %hi(_gp_disp)
; 32-NEXT:    addiu $2, $2, %lo(_gp_disp)
; 32-NEXT:    addu $1, $2, $25
; 32-NEXT:    lw $2, %got(d3)($1)
; 32-NEXT:    ldc1 $f0, 0($2)
; 32-NEXT:    lw $1, %got(d2)($1)
; 32-NEXT:    ldc1 $f2, 0($1)
; 32-NEXT:    c.eq.d $f2, $f0
; 32-NEXT:    movt $5, $4, $fcc0
; 32-NEXT:    jr $ra
; 32-NEXT:    move $2, $5
;
; 32R2-LABEL: f64_fcmp_oeq_i32_val:
; 32R2:       # %bb.0: # %entry
; 32R2-NEXT:    lui $2, %hi(_gp_disp)
; 32R2-NEXT:    addiu $2, $2, %lo(_gp_disp)
; 32R2-NEXT:    addu $1, $2, $25
; 32R2-NEXT:    lw $2, %got(d3)($1)
; 32R2-NEXT:    ldc1 $f0, 0($2)
; 32R2-NEXT:    lw $1, %got(d2)($1)
; 32R2-NEXT:    ldc1 $f2, 0($1)
; 32R2-NEXT:    c.eq.d $f2, $f0
; 32R2-NEXT:    movt $5, $4, $fcc0
; 32R2-NEXT:    jr $ra
; 32R2-NEXT:    move $2, $5
;
; 32R6-LABEL: f64_fcmp_oeq_i32_val:
; 32R6:       # %bb.0: # %entry
; 32R6-NEXT:    lui $2, %hi(_gp_disp)
; 32R6-NEXT:    addiu $2, $2, %lo(_gp_disp)
; 32R6-NEXT:    addu $1, $2, $25
; 32R6-NEXT:    lw $2, %got(d3)($1)
; 32R6-NEXT:    ldc1 $f0, 0($2)
; 32R6-NEXT:    lw $1, %got(d2)($1)
; 32R6-NEXT:    ldc1 $f1, 0($1)
; 32R6-NEXT:    cmp.eq.d $f0, $f1, $f0
; 32R6-NEXT:    mfc1 $1, $f0
; 32R6-NEXT:    andi $1, $1, 1
; 32R6-NEXT:    seleqz $2, $5, $1
; 32R6-NEXT:    selnez $1, $4, $1
; 32R6-NEXT:    jr $ra
; 32R6-NEXT:    or $2, $1, $2
;
; 64-LABEL: f64_fcmp_oeq_i32_val:
; 64:       # %bb.0: # %entry
; 64-NEXT:    lui $1, %hi(%neg(%gp_rel(f64_fcmp_oeq_i32_val)))
; 64-NEXT:    daddu $1, $1, $25
; 64-NEXT:    daddiu $1, $1, %lo(%neg(%gp_rel(f64_fcmp_oeq_i32_val)))
; 64-NEXT:    ld $2, %got_disp(d3)($1)
; 64-NEXT:    ldc1 $f0, 0($2)
; 64-NEXT:    ld $1, %got_disp(d2)($1)
; 64-NEXT:    ldc1 $f1, 0($1)
; 64-NEXT:    c.eq.d $f1, $f0
; 64-NEXT:    movt $5, $4, $fcc0
; 64-NEXT:    jr $ra
; 64-NEXT:    move $2, $5
;
; 64R2-LABEL: f64_fcmp_oeq_i32_val:
; 64R2:       # %bb.0: # %entry
; 64R2-NEXT:    lui $1, %hi(%neg(%gp_rel(f64_fcmp_oeq_i32_val)))
; 64R2-NEXT:    daddu $1, $1, $25
; 64R2-NEXT:    daddiu $1, $1, %lo(%neg(%gp_rel(f64_fcmp_oeq_i32_val)))
; 64R2-NEXT:    ld $2, %got_disp(d3)($1)
; 64R2-NEXT:    ldc1 $f0, 0($2)
; 64R2-NEXT:    ld $1, %got_disp(d2)($1)
; 64R2-NEXT:    ldc1 $f1, 0($1)
; 64R2-NEXT:    c.eq.d $f1, $f0
; 64R2-NEXT:    movt $5, $4, $fcc0
; 64R2-NEXT:    jr $ra
; 64R2-NEXT:    move $2, $5
;
; 64R6-LABEL: f64_fcmp_oeq_i32_val:
; 64R6:       # %bb.0: # %entry
; 64R6-NEXT:    lui $1, %hi(%neg(%gp_rel(f64_fcmp_oeq_i32_val)))
; 64R6-NEXT:    daddu $1, $1, $25
; 64R6-NEXT:    daddiu $1, $1, %lo(%neg(%gp_rel(f64_fcmp_oeq_i32_val)))
; 64R6-NEXT:    ld $2, %got_disp(d3)($1)
; 64R6-NEXT:    ldc1 $f0, 0($2)
; 64R6-NEXT:    ld $1, %got_disp(d2)($1)
; 64R6-NEXT:    ldc1 $f1, 0($1)
; 64R6-NEXT:    cmp.eq.d $f0, $f1, $f0
; 64R6-NEXT:    mfc1 $1, $f0
; 64R6-NEXT:    andi $1, $1, 1
; 64R6-NEXT:    seleqz $2, $5, $1
; 64R6-NEXT:    selnez $1, $4, $1
; 64R6-NEXT:    jr $ra
; 64R6-NEXT:    or $2, $1, $2
entry:
  %tmp = load double, double* @d2, align 8
  %tmp1 = load double, double* @d3, align 8
  %cmp = fcmp oeq double %tmp, %tmp1
  %cond = select i1 %cmp, i32 %f0, i32 %f1
  ret i32 %cond
}

define i32 @f64_fcmp_olt_i32_val(i32 signext %f0, i32 signext %f1) nounwind readonly {
; 32-LABEL: f64_fcmp_olt_i32_val:
; 32:       # %bb.0: # %entry
; 32-NEXT:    lui $2, %hi(_gp_disp)
; 32-NEXT:    addiu $2, $2, %lo(_gp_disp)
; 32-NEXT:    addu $1, $2, $25
; 32-NEXT:    lw $2, %got(d3)($1)
; 32-NEXT:    ldc1 $f0, 0($2)
; 32-NEXT:    lw $1, %got(d2)($1)
; 32-NEXT:    ldc1 $f2, 0($1)
; 32-NEXT:    c.olt.d $f2, $f0
; 32-NEXT:    movt $5, $4, $fcc0
; 32-NEXT:    jr $ra
; 32-NEXT:    move $2, $5
;
; 32R2-LABEL: f64_fcmp_olt_i32_val:
; 32R2:       # %bb.0: # %entry
; 32R2-NEXT:    lui $2, %hi(_gp_disp)
; 32R2-NEXT:    addiu $2, $2, %lo(_gp_disp)
; 32R2-NEXT:    addu $1, $2, $25
; 32R2-NEXT:    lw $2, %got(d3)($1)
; 32R2-NEXT:    ldc1 $f0, 0($2)
; 32R2-NEXT:    lw $1, %got(d2)($1)
; 32R2-NEXT:    ldc1 $f2, 0($1)
; 32R2-NEXT:    c.olt.d $f2, $f0
; 32R2-NEXT:    movt $5, $4, $fcc0
; 32R2-NEXT:    jr $ra
; 32R2-NEXT:    move $2, $5
;
; 32R6-LABEL: f64_fcmp_olt_i32_val:
; 32R6:       # %bb.0: # %entry
; 32R6-NEXT:    lui $2, %hi(_gp_disp)
; 32R6-NEXT:    addiu $2, $2, %lo(_gp_disp)
; 32R6-NEXT:    addu $1, $2, $25
; 32R6-NEXT:    lw $2, %got(d3)($1)
; 32R6-NEXT:    ldc1 $f0, 0($2)
; 32R6-NEXT:    lw $1, %got(d2)($1)
; 32R6-NEXT:    ldc1 $f1, 0($1)
; 32R6-NEXT:    cmp.lt.d $f0, $f1, $f0
; 32R6-NEXT:    mfc1 $1, $f0
; 32R6-NEXT:    andi $1, $1, 1
; 32R6-NEXT:    seleqz $2, $5, $1
; 32R6-NEXT:    selnez $1, $4, $1
; 32R6-NEXT:    jr $ra
; 32R6-NEXT:    or $2, $1, $2
;
; 64-LABEL: f64_fcmp_olt_i32_val:
; 64:       # %bb.0: # %entry
; 64-NEXT:    lui $1, %hi(%neg(%gp_rel(f64_fcmp_olt_i32_val)))
; 64-NEXT:    daddu $1, $1, $25
; 64-NEXT:    daddiu $1, $1, %lo(%neg(%gp_rel(f64_fcmp_olt_i32_val)))
; 64-NEXT:    ld $2, %got_disp(d3)($1)
; 64-NEXT:    ldc1 $f0, 0($2)
; 64-NEXT:    ld $1, %got_disp(d2)($1)
; 64-NEXT:    ldc1 $f1, 0($1)
; 64-NEXT:    c.olt.d $f1, $f0
; 64-NEXT:    movt $5, $4, $fcc0
; 64-NEXT:    jr $ra
; 64-NEXT:    move $2, $5
;
; 64R2-LABEL: f64_fcmp_olt_i32_val:
; 64R2:       # %bb.0: # %entry
; 64R2-NEXT:    lui $1, %hi(%neg(%gp_rel(f64_fcmp_olt_i32_val)))
; 64R2-NEXT:    daddu $1, $1, $25
; 64R2-NEXT:    daddiu $1, $1, %lo(%neg(%gp_rel(f64_fcmp_olt_i32_val)))
; 64R2-NEXT:    ld $2, %got_disp(d3)($1)
; 64R2-NEXT:    ldc1 $f0, 0($2)
; 64R2-NEXT:    ld $1, %got_disp(d2)($1)
; 64R2-NEXT:    ldc1 $f1, 0($1)
; 64R2-NEXT:    c.olt.d $f1, $f0
; 64R2-NEXT:    movt $5, $4, $fcc0
; 64R2-NEXT:    jr $ra
; 64R2-NEXT:    move $2, $5
;
; 64R6-LABEL: f64_fcmp_olt_i32_val:
; 64R6:       # %bb.0: # %entry
; 64R6-NEXT:    lui $1, %hi(%neg(%gp_rel(f64_fcmp_olt_i32_val)))
; 64R6-NEXT:    daddu $1, $1, $25
; 64R6-NEXT:    daddiu $1, $1, %lo(%neg(%gp_rel(f64_fcmp_olt_i32_val)))
; 64R6-NEXT:    ld $2, %got_disp(d3)($1)
; 64R6-NEXT:    ldc1 $f0, 0($2)
; 64R6-NEXT:    ld $1, %got_disp(d2)($1)
; 64R6-NEXT:    ldc1 $f1, 0($1)
; 64R6-NEXT:    cmp.lt.d $f0, $f1, $f0
; 64R6-NEXT:    mfc1 $1, $f0
; 64R6-NEXT:    andi $1, $1, 1
; 64R6-NEXT:    seleqz $2, $5, $1
; 64R6-NEXT:    selnez $1, $4, $1
; 64R6-NEXT:    jr $ra
; 64R6-NEXT:    or $2, $1, $2
entry:
  %tmp = load double, double* @d2, align 8
  %tmp1 = load double, double* @d3, align 8
  %cmp = fcmp olt double %tmp, %tmp1
  %cond = select i1 %cmp, i32 %f0, i32 %f1
  ret i32 %cond
}

define i32 @f64_fcmp_ogt_i32_val(i32 signext %f0, i32 signext %f1) nounwind readonly {
; 32-LABEL: f64_fcmp_ogt_i32_val:
; 32:       # %bb.0: # %entry
; 32-NEXT:    lui $2, %hi(_gp_disp)
; 32-NEXT:    addiu $2, $2, %lo(_gp_disp)
; 32-NEXT:    addu $1, $2, $25
; 32-NEXT:    lw $2, %got(d3)($1)
; 32-NEXT:    ldc1 $f0, 0($2)
; 32-NEXT:    lw $1, %got(d2)($1)
; 32-NEXT:    ldc1 $f2, 0($1)
; 32-NEXT:    c.ule.d $f2, $f0
; 32-NEXT:    movf $5, $4, $fcc0
; 32-NEXT:    jr $ra
; 32-NEXT:    move $2, $5
;
; 32R2-LABEL: f64_fcmp_ogt_i32_val:
; 32R2:       # %bb.0: # %entry
; 32R2-NEXT:    lui $2, %hi(_gp_disp)
; 32R2-NEXT:    addiu $2, $2, %lo(_gp_disp)
; 32R2-NEXT:    addu $1, $2, $25
; 32R2-NEXT:    lw $2, %got(d3)($1)
; 32R2-NEXT:    ldc1 $f0, 0($2)
; 32R2-NEXT:    lw $1, %got(d2)($1)
; 32R2-NEXT:    ldc1 $f2, 0($1)
; 32R2-NEXT:    c.ule.d $f2, $f0
; 32R2-NEXT:    movf $5, $4, $fcc0
; 32R2-NEXT:    jr $ra
; 32R2-NEXT:    move $2, $5
;
; 32R6-LABEL: f64_fcmp_ogt_i32_val:
; 32R6:       # %bb.0: # %entry
; 32R6-NEXT:    lui $2, %hi(_gp_disp)
; 32R6-NEXT:    addiu $2, $2, %lo(_gp_disp)
; 32R6-NEXT:    addu $1, $2, $25
; 32R6-NEXT:    lw $2, %got(d2)($1)
; 32R6-NEXT:    ldc1 $f0, 0($2)
; 32R6-NEXT:    lw $1, %got(d3)($1)
; 32R6-NEXT:    ldc1 $f1, 0($1)
; 32R6-NEXT:    cmp.lt.d $f0, $f1, $f0
; 32R6-NEXT:    mfc1 $1, $f0
; 32R6-NEXT:    andi $1, $1, 1
; 32R6-NEXT:    seleqz $2, $5, $1
; 32R6-NEXT:    selnez $1, $4, $1
; 32R6-NEXT:    jr $ra
; 32R6-NEXT:    or $2, $1, $2
;
; 64-LABEL: f64_fcmp_ogt_i32_val:
; 64:       # %bb.0: # %entry
; 64-NEXT:    lui $1, %hi(%neg(%gp_rel(f64_fcmp_ogt_i32_val)))
; 64-NEXT:    daddu $1, $1, $25
; 64-NEXT:    daddiu $1, $1, %lo(%neg(%gp_rel(f64_fcmp_ogt_i32_val)))
; 64-NEXT:    ld $2, %got_disp(d3)($1)
; 64-NEXT:    ldc1 $f0, 0($2)
; 64-NEXT:    ld $1, %got_disp(d2)($1)
; 64-NEXT:    ldc1 $f1, 0($1)
; 64-NEXT:    c.ule.d $f1, $f0
; 64-NEXT:    movf $5, $4, $fcc0
; 64-NEXT:    jr $ra
; 64-NEXT:    move $2, $5
;
; 64R2-LABEL: f64_fcmp_ogt_i32_val:
; 64R2:       # %bb.0: # %entry
; 64R2-NEXT:    lui $1, %hi(%neg(%gp_rel(f64_fcmp_ogt_i32_val)))
; 64R2-NEXT:    daddu $1, $1, $25
; 64R2-NEXT:    daddiu $1, $1, %lo(%neg(%gp_rel(f64_fcmp_ogt_i32_val)))
; 64R2-NEXT:    ld $2, %got_disp(d3)($1)
; 64R2-NEXT:    ldc1 $f0, 0($2)
; 64R2-NEXT:    ld $1, %got_disp(d2)($1)
; 64R2-NEXT:    ldc1 $f1, 0($1)
; 64R2-NEXT:    c.ule.d $f1, $f0
; 64R2-NEXT:    movf $5, $4, $fcc0
; 64R2-NEXT:    jr $ra
; 64R2-NEXT:    move $2, $5
;
; 64R6-LABEL: f64_fcmp_ogt_i32_val:
; 64R6:       # %bb.0: # %entry
; 64R6-NEXT:    lui $1, %hi(%neg(%gp_rel(f64_fcmp_ogt_i32_val)))
; 64R6-NEXT:    daddu $1, $1, $25
; 64R6-NEXT:    daddiu $1, $1, %lo(%neg(%gp_rel(f64_fcmp_ogt_i32_val)))
; 64R6-NEXT:    ld $2, %got_disp(d2)($1)
; 64R6-NEXT:    ldc1 $f0, 0($2)
; 64R6-NEXT:    ld $1, %got_disp(d3)($1)
; 64R6-NEXT:    ldc1 $f1, 0($1)
; 64R6-NEXT:    cmp.lt.d $f0, $f1, $f0
; 64R6-NEXT:    mfc1 $1, $f0
; 64R6-NEXT:    andi $1, $1, 1
; 64R6-NEXT:    seleqz $2, $5, $1
; 64R6-NEXT:    selnez $1, $4, $1
; 64R6-NEXT:    jr $ra
; 64R6-NEXT:    or $2, $1, $2
entry:
  %tmp = load double, double* @d2, align 8
  %tmp1 = load double, double* @d3, align 8
  %cmp = fcmp ogt double %tmp, %tmp1
  %cond = select i1 %cmp, i32 %f0, i32 %f1
  ret i32 %cond
}
