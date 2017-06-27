; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu -mcpu=corei7 | FileCheck %s

define void @i24_or(i24* %a) {
; CHECK-LABEL: i24_or:
; CHECK:       # BB#0:
; CHECK-NEXT:    movzwl (%rdi), %eax
; CHECK-NEXT:    movzbl 2(%rdi), %ecx
; CHECK-NEXT:    movb %cl, 2(%rdi)
; CHECK-NEXT:    shll $16, %ecx
; CHECK-NEXT:    orl %eax, %ecx
; CHECK-NEXT:    orl $384, %ecx # imm = 0x180
; CHECK-NEXT:    movw %cx, (%rdi)
; CHECK-NEXT:    retq
  %aa = load i24, i24* %a, align 1
  %b = or i24 %aa, 384
  store i24 %b, i24* %a, align 1
  ret void
}

define void @i24_and_or(i24* %a) {
; CHECK-LABEL: i24_and_or:
; CHECK:       # BB#0:
; CHECK-NEXT:    movzwl (%rdi), %eax
; CHECK-NEXT:    movzbl 2(%rdi), %ecx
; CHECK-NEXT:    movb %cl, 2(%rdi)
; CHECK-NEXT:    shll $16, %ecx
; CHECK-NEXT:    orl %eax, %ecx
; CHECK-NEXT:    orl $384, %ecx # imm = 0x180
; CHECK-NEXT:    andl $16777088, %ecx # imm = 0xFFFF80
; CHECK-NEXT:    movw %cx, (%rdi)
; CHECK-NEXT:    retq
  %b = load i24, i24* %a, align 1
  %c = and i24 %b, -128
  %d = or i24 %c, 384
  store i24 %d, i24* %a, align 1
  ret void
}

define void @i24_insert_bit(i24* %a, i1 zeroext %bit) {
; CHECK-LABEL: i24_insert_bit:
; CHECK:       # BB#0:
; CHECK-NEXT:    movzbl %sil, %eax
; CHECK-NEXT:    movzwl (%rdi), %ecx
; CHECK-NEXT:    movzbl 2(%rdi), %edx
; CHECK-NEXT:    movb %dl, 2(%rdi)
; CHECK-NEXT:    shll $16, %edx
; CHECK-NEXT:    orl %ecx, %edx
; CHECK-NEXT:    shll $13, %eax
; CHECK-NEXT:    andl $16769023, %edx # imm = 0xFFDFFF
; CHECK-NEXT:    orl %eax, %edx
; CHECK-NEXT:    movw %dx, (%rdi)
; CHECK-NEXT:    retq
  %extbit = zext i1 %bit to i24
  %b = load i24, i24* %a, align 1
  %extbit.shl = shl nuw nsw i24 %extbit, 13
  %c = and i24 %b, -8193
  %d = or i24 %c, %extbit.shl
  store i24 %d, i24* %a, align 1
  ret void
}

define void @i56_or(i56* %a) {
; CHECK-LABEL: i56_or:
; CHECK:       # BB#0:
; CHECK-NEXT:    movzwl 4(%rdi), %eax
; CHECK-NEXT:    movzbl 6(%rdi), %ecx
; CHECK-NEXT:    movl (%rdi), %edx
; CHECK-NEXT:    movb %cl, 6(%rdi)
; CHECK-NEXT:    # kill: %ECX<def> %ECX<kill> %RCX<kill> %RCX<def>
; CHECK-NEXT:    shll $16, %ecx
; CHECK-NEXT:    orl %eax, %ecx
; CHECK-NEXT:    shlq $32, %rcx
; CHECK-NEXT:    orq %rcx, %rdx
; CHECK-NEXT:    orq $384, %rdx # imm = 0x180
; CHECK-NEXT:    movl %edx, (%rdi)
; CHECK-NEXT:    shrq $32, %rdx
; CHECK-NEXT:    movw %dx, 4(%rdi)
; CHECK-NEXT:    retq
  %aa = load i56, i56* %a, align 1
  %b = or i56 %aa, 384
  store i56 %b, i56* %a, align 1
  ret void
}

define void @i56_and_or(i56* %a) {
; CHECK-LABEL: i56_and_or:
; CHECK:       # BB#0:
; CHECK-NEXT:    movzwl 4(%rdi), %eax
; CHECK-NEXT:    movzbl 6(%rdi), %ecx
; CHECK-NEXT:    movl (%rdi), %edx
; CHECK-NEXT:    movb %cl, 6(%rdi)
; CHECK-NEXT:    # kill: %ECX<def> %ECX<kill> %RCX<kill> %RCX<def>
; CHECK-NEXT:    shll $16, %ecx
; CHECK-NEXT:    orl %eax, %ecx
; CHECK-NEXT:    shlq $32, %rcx
; CHECK-NEXT:    orq %rcx, %rdx
; CHECK-NEXT:    orq $384, %rdx # imm = 0x180
; CHECK-NEXT:    movabsq $72057594037927808, %rax # imm = 0xFFFFFFFFFFFF80
; CHECK-NEXT:    andq %rdx, %rax
; CHECK-NEXT:    movl %eax, (%rdi)
; CHECK-NEXT:    shrq $32, %rax
; CHECK-NEXT:    movw %ax, 4(%rdi)
; CHECK-NEXT:    retq
  %b = load i56, i56* %a, align 1
  %c = and i56 %b, -128
  %d = or i56 %c, 384
  store i56 %d, i56* %a, align 1
  ret void
}

define void @i56_insert_bit(i56* %a, i1 zeroext %bit) {
; CHECK-LABEL: i56_insert_bit:
; CHECK:       # BB#0:
; CHECK-NEXT:    movzwl 4(%rdi), %eax
; CHECK-NEXT:    movzbl 6(%rdi), %ecx
; CHECK-NEXT:    movl (%rdi), %edx
; CHECK-NEXT:    movb %cl, 6(%rdi)
; CHECK-NEXT:    movzbl %sil, %esi
; CHECK-NEXT:    # kill: %ECX<def> %ECX<kill> %RCX<kill> %RCX<def>
; CHECK-NEXT:    shll $16, %ecx
; CHECK-NEXT:    orl %eax, %ecx
; CHECK-NEXT:    shlq $32, %rcx
; CHECK-NEXT:    orq %rcx, %rdx
; CHECK-NEXT:    shlq $13, %rsi
; CHECK-NEXT:    movabsq $72057594037919743, %rax # imm = 0xFFFFFFFFFFDFFF
; CHECK-NEXT:    andq %rdx, %rax
; CHECK-NEXT:    orq %rsi, %rax
; CHECK-NEXT:    movl %eax, (%rdi)
; CHECK-NEXT:    shrq $32, %rax
; CHECK-NEXT:    movw %ax, 4(%rdi)
; CHECK-NEXT:    retq
  %extbit = zext i1 %bit to i56
  %b = load i56, i56* %a, align 1
  %extbit.shl = shl nuw nsw i56 %extbit, 13
  %c = and i56 %b, -8193
  %d = or i56 %c, %extbit.shl
  store i56 %d, i56* %a, align 1
  ret void
}

