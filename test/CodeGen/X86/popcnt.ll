; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown | FileCheck %s --check-prefix=X32
; RUN: llc < %s -mtriple=x86_64-unknown | FileCheck %s --check-prefix=X64
; RUN: llc < %s -mtriple=i686-unknown -mattr=+popcnt | FileCheck %s --check-prefix=X32-POPCNT
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+popcnt | FileCheck %s --check-prefix=X64-POPCNT

define i8 @cnt8(i8 %x) nounwind readnone {
; X32-LABEL: cnt8:
; X32:       # %bb.0:
; X32-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X32-NEXT:    movl %ecx, %eax
; X32-NEXT:    shrb %al
; X32-NEXT:    andb $85, %al
; X32-NEXT:    subb %al, %cl
; X32-NEXT:    movl %ecx, %eax
; X32-NEXT:    andb $51, %al
; X32-NEXT:    shrb $2, %cl
; X32-NEXT:    andb $51, %cl
; X32-NEXT:    addb %al, %cl
; X32-NEXT:    movl %ecx, %eax
; X32-NEXT:    shrb $4, %al
; X32-NEXT:    addb %cl, %al
; X32-NEXT:    andb $15, %al
; X32-NEXT:    retl
;
; X64-LABEL: cnt8:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shrb %al
; X64-NEXT:    andb $85, %al
; X64-NEXT:    subb %al, %dil
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    andb $51, %al
; X64-NEXT:    shrb $2, %dil
; X64-NEXT:    andb $51, %dil
; X64-NEXT:    addb %al, %dil
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shrb $4, %al
; X64-NEXT:    addb %dil, %al
; X64-NEXT:    andb $15, %al
; X64-NEXT:    retq
;
; X32-POPCNT-LABEL: cnt8:
; X32-POPCNT:       # %bb.0:
; X32-POPCNT-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; X32-POPCNT-NEXT:    popcntl %eax, %eax
; X32-POPCNT-NEXT:    # kill: def $al killed $al killed $eax
; X32-POPCNT-NEXT:    retl
;
; X64-POPCNT-LABEL: cnt8:
; X64-POPCNT:       # %bb.0:
; X64-POPCNT-NEXT:    movzbl %dil, %eax
; X64-POPCNT-NEXT:    popcntl %eax, %eax
; X64-POPCNT-NEXT:    # kill: def $al killed $al killed $eax
; X64-POPCNT-NEXT:    retq
  %cnt = tail call i8 @llvm.ctpop.i8(i8 %x)
  ret i8 %cnt
}

define i16 @cnt16(i16 %x) nounwind readnone {
; X32-LABEL: cnt16:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl %eax, %ecx
; X32-NEXT:    shrl %ecx
; X32-NEXT:    andl $21845, %ecx # imm = 0x5555
; X32-NEXT:    subl %ecx, %eax
; X32-NEXT:    movl %eax, %ecx
; X32-NEXT:    andl $13107, %ecx # imm = 0x3333
; X32-NEXT:    shrl $2, %eax
; X32-NEXT:    andl $13107, %eax # imm = 0x3333
; X32-NEXT:    addl %ecx, %eax
; X32-NEXT:    movl %eax, %ecx
; X32-NEXT:    shrl $4, %ecx
; X32-NEXT:    addl %eax, %ecx
; X32-NEXT:    andl $3855, %ecx # imm = 0xF0F
; X32-NEXT:    movl %ecx, %eax
; X32-NEXT:    shll $8, %eax
; X32-NEXT:    addl %ecx, %eax
; X32-NEXT:    movzbl %ah, %eax
; X32-NEXT:    # kill: def $ax killed $ax killed $eax
; X32-NEXT:    retl
;
; X64-LABEL: cnt16:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shrl %eax
; X64-NEXT:    andl $21845, %eax # imm = 0x5555
; X64-NEXT:    subl %eax, %edi
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    andl $13107, %eax # imm = 0x3333
; X64-NEXT:    shrl $2, %edi
; X64-NEXT:    andl $13107, %edi # imm = 0x3333
; X64-NEXT:    addl %eax, %edi
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shrl $4, %eax
; X64-NEXT:    addl %edi, %eax
; X64-NEXT:    andl $3855, %eax # imm = 0xF0F
; X64-NEXT:    movl %eax, %ecx
; X64-NEXT:    shll $8, %ecx
; X64-NEXT:    addl %eax, %ecx
; X64-NEXT:    movzbl %ch, %eax
; X64-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NEXT:    retq
;
; X32-POPCNT-LABEL: cnt16:
; X32-POPCNT:       # %bb.0:
; X32-POPCNT-NEXT:    popcntw {{[0-9]+}}(%esp), %ax
; X32-POPCNT-NEXT:    retl
;
; X64-POPCNT-LABEL: cnt16:
; X64-POPCNT:       # %bb.0:
; X64-POPCNT-NEXT:    popcntw %di, %ax
; X64-POPCNT-NEXT:    retq
  %cnt = tail call i16 @llvm.ctpop.i16(i16 %x)
  ret i16 %cnt
}

define i32 @cnt32(i32 %x) nounwind readnone {
; X32-LABEL: cnt32:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl %eax, %ecx
; X32-NEXT:    shrl %ecx
; X32-NEXT:    andl $1431655765, %ecx # imm = 0x55555555
; X32-NEXT:    subl %ecx, %eax
; X32-NEXT:    movl %eax, %ecx
; X32-NEXT:    andl $858993459, %ecx # imm = 0x33333333
; X32-NEXT:    shrl $2, %eax
; X32-NEXT:    andl $858993459, %eax # imm = 0x33333333
; X32-NEXT:    addl %ecx, %eax
; X32-NEXT:    movl %eax, %ecx
; X32-NEXT:    shrl $4, %ecx
; X32-NEXT:    addl %eax, %ecx
; X32-NEXT:    andl $252645135, %ecx # imm = 0xF0F0F0F
; X32-NEXT:    imull $16843009, %ecx, %eax # imm = 0x1010101
; X32-NEXT:    shrl $24, %eax
; X32-NEXT:    retl
;
; X64-LABEL: cnt32:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shrl %eax
; X64-NEXT:    andl $1431655765, %eax # imm = 0x55555555
; X64-NEXT:    subl %eax, %edi
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    andl $858993459, %eax # imm = 0x33333333
; X64-NEXT:    shrl $2, %edi
; X64-NEXT:    andl $858993459, %edi # imm = 0x33333333
; X64-NEXT:    addl %eax, %edi
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shrl $4, %eax
; X64-NEXT:    addl %edi, %eax
; X64-NEXT:    andl $252645135, %eax # imm = 0xF0F0F0F
; X64-NEXT:    imull $16843009, %eax, %eax # imm = 0x1010101
; X64-NEXT:    shrl $24, %eax
; X64-NEXT:    retq
;
; X32-POPCNT-LABEL: cnt32:
; X32-POPCNT:       # %bb.0:
; X32-POPCNT-NEXT:    popcntl {{[0-9]+}}(%esp), %eax
; X32-POPCNT-NEXT:    retl
;
; X64-POPCNT-LABEL: cnt32:
; X64-POPCNT:       # %bb.0:
; X64-POPCNT-NEXT:    popcntl %edi, %eax
; X64-POPCNT-NEXT:    retq
  %cnt = tail call i32 @llvm.ctpop.i32(i32 %x)
  ret i32 %cnt
}

define i64 @cnt64(i64 %x) nounwind readnone {
; X32-LABEL: cnt64:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl %ecx, %edx
; X32-NEXT:    shrl %edx
; X32-NEXT:    andl $1431655765, %edx # imm = 0x55555555
; X32-NEXT:    subl %edx, %ecx
; X32-NEXT:    movl %ecx, %edx
; X32-NEXT:    andl $858993459, %edx # imm = 0x33333333
; X32-NEXT:    shrl $2, %ecx
; X32-NEXT:    andl $858993459, %ecx # imm = 0x33333333
; X32-NEXT:    addl %edx, %ecx
; X32-NEXT:    movl %ecx, %edx
; X32-NEXT:    shrl $4, %edx
; X32-NEXT:    addl %ecx, %edx
; X32-NEXT:    andl $252645135, %edx # imm = 0xF0F0F0F
; X32-NEXT:    imull $16843009, %edx, %ecx # imm = 0x1010101
; X32-NEXT:    shrl $24, %ecx
; X32-NEXT:    movl %eax, %edx
; X32-NEXT:    shrl %edx
; X32-NEXT:    andl $1431655765, %edx # imm = 0x55555555
; X32-NEXT:    subl %edx, %eax
; X32-NEXT:    movl %eax, %edx
; X32-NEXT:    andl $858993459, %edx # imm = 0x33333333
; X32-NEXT:    shrl $2, %eax
; X32-NEXT:    andl $858993459, %eax # imm = 0x33333333
; X32-NEXT:    addl %edx, %eax
; X32-NEXT:    movl %eax, %edx
; X32-NEXT:    shrl $4, %edx
; X32-NEXT:    addl %eax, %edx
; X32-NEXT:    andl $252645135, %edx # imm = 0xF0F0F0F
; X32-NEXT:    imull $16843009, %edx, %eax # imm = 0x1010101
; X32-NEXT:    shrl $24, %eax
; X32-NEXT:    addl %ecx, %eax
; X32-NEXT:    xorl %edx, %edx
; X32-NEXT:    retl
;
; X64-LABEL: cnt64:
; X64:       # %bb.0:
; X64-NEXT:    movq %rdi, %rax
; X64-NEXT:    shrq %rax
; X64-NEXT:    movabsq $6148914691236517205, %rcx # imm = 0x5555555555555555
; X64-NEXT:    andq %rax, %rcx
; X64-NEXT:    subq %rcx, %rdi
; X64-NEXT:    movabsq $3689348814741910323, %rax # imm = 0x3333333333333333
; X64-NEXT:    movq %rdi, %rcx
; X64-NEXT:    andq %rax, %rcx
; X64-NEXT:    shrq $2, %rdi
; X64-NEXT:    andq %rax, %rdi
; X64-NEXT:    addq %rcx, %rdi
; X64-NEXT:    movq %rdi, %rax
; X64-NEXT:    shrq $4, %rax
; X64-NEXT:    leaq (%rax,%rdi), %rax
; X64-NEXT:    movabsq $1085102592571150095, %rcx # imm = 0xF0F0F0F0F0F0F0F
; X64-NEXT:    andq %rax, %rcx
; X64-NEXT:    movabsq $72340172838076673, %rax # imm = 0x101010101010101
; X64-NEXT:    imulq %rcx, %rax
; X64-NEXT:    shrq $56, %rax
; X64-NEXT:    retq
;
; X32-POPCNT-LABEL: cnt64:
; X32-POPCNT:       # %bb.0:
; X32-POPCNT-NEXT:    popcntl {{[0-9]+}}(%esp), %ecx
; X32-POPCNT-NEXT:    popcntl {{[0-9]+}}(%esp), %eax
; X32-POPCNT-NEXT:    addl %ecx, %eax
; X32-POPCNT-NEXT:    xorl %edx, %edx
; X32-POPCNT-NEXT:    retl
;
; X64-POPCNT-LABEL: cnt64:
; X64-POPCNT:       # %bb.0:
; X64-POPCNT-NEXT:    popcntq %rdi, %rax
; X64-POPCNT-NEXT:    retq
  %cnt = tail call i64 @llvm.ctpop.i64(i64 %x)
  ret i64 %cnt
}

declare i8 @llvm.ctpop.i8(i8) nounwind readnone
declare i16 @llvm.ctpop.i16(i16) nounwind readnone
declare i32 @llvm.ctpop.i32(i32) nounwind readnone
declare i64 @llvm.ctpop.i64(i64) nounwind readnone
