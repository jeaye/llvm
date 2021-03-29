; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+sse2 | FileCheck %s --check-prefix=X86
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse2 | FileCheck %s --check-prefix=X64
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+f16c | FileCheck %s --check-prefix=F16C

define <1 x half> @ir_fadd_v1f16(<1 x half> %arg0, <1 x half> %arg1) nounwind {
; X86-LABEL: ir_fadd_v1f16:
; X86:       # %bb.0:
; X86-NEXT:    pushl %esi
; X86-NEXT:    subl $12, %esp
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl %eax, (%esp)
; X86-NEXT:    calll __gnu_h2f_ieee
; X86-NEXT:    movl %esi, (%esp)
; X86-NEXT:    fstps {{[0-9]+}}(%esp)
; X86-NEXT:    calll __gnu_h2f_ieee
; X86-NEXT:    fstps {{[0-9]+}}(%esp)
; X86-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X86-NEXT:    addss {{[0-9]+}}(%esp), %xmm0
; X86-NEXT:    movss %xmm0, (%esp)
; X86-NEXT:    calll __gnu_f2h_ieee
; X86-NEXT:    addl $12, %esp
; X86-NEXT:    popl %esi
; X86-NEXT:    retl
;
; X64-LABEL: ir_fadd_v1f16:
; X64:       # %bb.0:
; X64-NEXT:    pushq %rbx
; X64-NEXT:    subq $16, %rsp
; X64-NEXT:    movl %edi, %ebx
; X64-NEXT:    movzwl %si, %edi
; X64-NEXT:    callq __gnu_h2f_ieee@PLT
; X64-NEXT:    movss %xmm0, {{[-0-9]+}}(%r{{[sb]}}p) # 4-byte Spill
; X64-NEXT:    movzwl %bx, %edi
; X64-NEXT:    callq __gnu_h2f_ieee@PLT
; X64-NEXT:    addss {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 # 4-byte Folded Reload
; X64-NEXT:    callq __gnu_f2h_ieee@PLT
; X64-NEXT:    addq $16, %rsp
; X64-NEXT:    popq %rbx
; X64-NEXT:    retq
;
; F16C-LABEL: ir_fadd_v1f16:
; F16C:       # %bb.0:
; F16C-NEXT:    movzwl %si, %eax
; F16C-NEXT:    vmovd %eax, %xmm0
; F16C-NEXT:    vcvtph2ps %xmm0, %xmm0
; F16C-NEXT:    movzwl %di, %eax
; F16C-NEXT:    vmovd %eax, %xmm1
; F16C-NEXT:    vcvtph2ps %xmm1, %xmm1
; F16C-NEXT:    vaddss %xmm0, %xmm1, %xmm0
; F16C-NEXT:    vcvtps2ph $4, %xmm0, %xmm0
; F16C-NEXT:    vmovd %xmm0, %eax
; F16C-NEXT:    # kill: def $ax killed $ax killed $eax
; F16C-NEXT:    retq
  %retval = fadd <1 x half> %arg0, %arg1
  ret <1 x half> %retval
}

define <2 x half> @ir_fadd_v2f16(<2 x half> %arg0, <2 x half> %arg1) nounwind {
; X86-LABEL: ir_fadd_v2f16:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebp
; X86-NEXT:    movl %esp, %ebp
; X86-NEXT:    pushl %ebx
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    andl $-16, %esp
; X86-NEXT:    subl $64, %esp
; X86-NEXT:    movzwl 8(%ebp), %esi
; X86-NEXT:    movzwl 12(%ebp), %edi
; X86-NEXT:    movzwl 20(%ebp), %ebx
; X86-NEXT:    movzwl 16(%ebp), %eax
; X86-NEXT:    movl %eax, (%esp)
; X86-NEXT:    calll __gnu_h2f_ieee
; X86-NEXT:    fstpt {{[-0-9]+}}(%e{{[sb]}}p) # 10-byte Folded Spill
; X86-NEXT:    movl %ebx, (%esp)
; X86-NEXT:    calll __gnu_h2f_ieee
; X86-NEXT:    fstpt {{[-0-9]+}}(%e{{[sb]}}p) # 10-byte Folded Spill
; X86-NEXT:    movl %edi, (%esp)
; X86-NEXT:    calll __gnu_h2f_ieee
; X86-NEXT:    movl %esi, (%esp)
; X86-NEXT:    fstps {{[0-9]+}}(%esp)
; X86-NEXT:    fldt {{[-0-9]+}}(%e{{[sb]}}p) # 10-byte Folded Reload
; X86-NEXT:    fstps {{[0-9]+}}(%esp)
; X86-NEXT:    calll __gnu_h2f_ieee
; X86-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X86-NEXT:    addss {{[0-9]+}}(%esp), %xmm0
; X86-NEXT:    movss %xmm0, (%esp)
; X86-NEXT:    fstps {{[0-9]+}}(%esp)
; X86-NEXT:    fldt {{[-0-9]+}}(%e{{[sb]}}p) # 10-byte Folded Reload
; X86-NEXT:    fstps {{[0-9]+}}(%esp)
; X86-NEXT:    calll __gnu_f2h_ieee
; X86-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X86-NEXT:    addss {{[0-9]+}}(%esp), %xmm0
; X86-NEXT:    movss %xmm0, (%esp)
; X86-NEXT:    movw %ax, {{[0-9]+}}(%esp)
; X86-NEXT:    calll __gnu_f2h_ieee
; X86-NEXT:    movw %ax, {{[0-9]+}}(%esp)
; X86-NEXT:    movdqa {{[0-9]+}}(%esp), %xmm0
; X86-NEXT:    movd %xmm0, %eax
; X86-NEXT:    pextrw $1, %xmm0, %edx
; X86-NEXT:    # kill: def $ax killed $ax killed $eax
; X86-NEXT:    # kill: def $dx killed $dx killed $edx
; X86-NEXT:    leal -12(%ebp), %esp
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    popl %ebx
; X86-NEXT:    popl %ebp
; X86-NEXT:    retl
;
; X64-LABEL: ir_fadd_v2f16:
; X64:       # %bb.0:
; X64-NEXT:    pushq %rbp
; X64-NEXT:    pushq %r14
; X64-NEXT:    pushq %rbx
; X64-NEXT:    subq $32, %rsp
; X64-NEXT:    movl %edx, %ebx
; X64-NEXT:    movl %esi, %ebp
; X64-NEXT:    movl %edi, %r14d
; X64-NEXT:    movzwl %cx, %edi
; X64-NEXT:    callq __gnu_h2f_ieee@PLT
; X64-NEXT:    movss %xmm0, {{[-0-9]+}}(%r{{[sb]}}p) # 4-byte Spill
; X64-NEXT:    movzwl %bp, %edi
; X64-NEXT:    callq __gnu_h2f_ieee@PLT
; X64-NEXT:    addss {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 # 4-byte Folded Reload
; X64-NEXT:    callq __gnu_f2h_ieee@PLT
; X64-NEXT:    movw %ax, {{[0-9]+}}(%rsp)
; X64-NEXT:    movzwl %bx, %edi
; X64-NEXT:    callq __gnu_h2f_ieee@PLT
; X64-NEXT:    movss %xmm0, {{[-0-9]+}}(%r{{[sb]}}p) # 4-byte Spill
; X64-NEXT:    movzwl %r14w, %edi
; X64-NEXT:    callq __gnu_h2f_ieee@PLT
; X64-NEXT:    addss {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 # 4-byte Folded Reload
; X64-NEXT:    callq __gnu_f2h_ieee@PLT
; X64-NEXT:    movw %ax, {{[0-9]+}}(%rsp)
; X64-NEXT:    movdqa {{[0-9]+}}(%rsp), %xmm0
; X64-NEXT:    movd %xmm0, %eax
; X64-NEXT:    pextrw $1, %xmm0, %edx
; X64-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NEXT:    # kill: def $dx killed $dx killed $edx
; X64-NEXT:    addq $32, %rsp
; X64-NEXT:    popq %rbx
; X64-NEXT:    popq %r14
; X64-NEXT:    popq %rbp
; X64-NEXT:    retq
;
; F16C-LABEL: ir_fadd_v2f16:
; F16C:       # %bb.0:
; F16C-NEXT:    movzwl %cx, %eax
; F16C-NEXT:    vmovd %eax, %xmm0
; F16C-NEXT:    vcvtph2ps %xmm0, %xmm0
; F16C-NEXT:    movzwl %si, %eax
; F16C-NEXT:    vmovd %eax, %xmm1
; F16C-NEXT:    vcvtph2ps %xmm1, %xmm1
; F16C-NEXT:    vaddss %xmm0, %xmm1, %xmm0
; F16C-NEXT:    vcvtps2ph $4, %xmm0, %xmm0
; F16C-NEXT:    vpextrw $0, %xmm0, -{{[0-9]+}}(%rsp)
; F16C-NEXT:    movzwl %dx, %eax
; F16C-NEXT:    vmovd %eax, %xmm0
; F16C-NEXT:    vcvtph2ps %xmm0, %xmm0
; F16C-NEXT:    movzwl %di, %eax
; F16C-NEXT:    vmovd %eax, %xmm1
; F16C-NEXT:    vcvtph2ps %xmm1, %xmm1
; F16C-NEXT:    vaddss %xmm0, %xmm1, %xmm0
; F16C-NEXT:    vcvtps2ph $4, %xmm0, %xmm0
; F16C-NEXT:    vpextrw $0, %xmm0, -{{[0-9]+}}(%rsp)
; F16C-NEXT:    vmovdqa -{{[0-9]+}}(%rsp), %xmm0
; F16C-NEXT:    vmovd %xmm0, %eax
; F16C-NEXT:    vpextrw $1, %xmm0, %edx
; F16C-NEXT:    # kill: def $ax killed $ax killed $eax
; F16C-NEXT:    # kill: def $dx killed $dx killed $edx
; F16C-NEXT:    retq
  %retval = fadd <2 x half> %arg0, %arg1
  ret <2 x half> %retval
}
