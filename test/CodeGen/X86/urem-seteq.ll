; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=i686-unknown-linux-gnu < %s | FileCheck %s --check-prefixes=CHECK,X86
; RUN: llc -mtriple=x86_64-unknown-linux-gnu < %s | FileCheck %s --check-prefixes=CHECK,X64

; This tests the BuildREMEqFold optimization with UREM, i32, odd divisor, SETEQ.
; The corresponding pseudocode is:
; Q <- [N * multInv(5, 2^32)] <=> [N * 0xCCCCCCCD] <=> [N * (-858993459)]
; res <- [Q <= (2^32 - 1) / 5] <=> [Q <= 858993459] <=> [Q < 858993460]
define i32 @test_urem_odd(i32 %X) nounwind readnone {
; X86-LABEL: test_urem_odd:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl $-858993459, %edx # imm = 0xCCCCCCCD
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:    mull %edx
; X86-NEXT:    shrl $2, %edx
; X86-NEXT:    leal (%edx,%edx,4), %edx
; X86-NEXT:    xorl %eax, %eax
; X86-NEXT:    cmpl %edx, %ecx
; X86-NEXT:    sete %al
; X86-NEXT:    retl
;
; X64-LABEL: test_urem_odd:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    movl $3435973837, %ecx # imm = 0xCCCCCCCD
; X64-NEXT:    imulq %rax, %rcx
; X64-NEXT:    shrq $34, %rcx
; X64-NEXT:    leal (%rcx,%rcx,4), %ecx
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    cmpl %ecx, %edi
; X64-NEXT:    sete %al
; X64-NEXT:    retq
  %urem = urem i32 %X, 5
  %cmp = icmp eq i32 %urem, 0
  %ret = zext i1 %cmp to i32
  ret i32 %ret
}

; This is like test_urem_odd, except the divisor has bit 30 set.
define i32 @test_urem_odd_bit30(i32 %X) nounwind readnone {
; X86-LABEL: test_urem_odd_bit30:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl $-11, %edx
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:    mull %edx
; X86-NEXT:    shrl $30, %edx
; X86-NEXT:    imull $1073741827, %edx, %edx # imm = 0x40000003
; X86-NEXT:    xorl %eax, %eax
; X86-NEXT:    cmpl %edx, %ecx
; X86-NEXT:    sete %al
; X86-NEXT:    retl
;
; X64-LABEL: test_urem_odd_bit30:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    movl $4294967285, %ecx # imm = 0xFFFFFFF5
; X64-NEXT:    imulq %rax, %rcx
; X64-NEXT:    shrq $62, %rcx
; X64-NEXT:    imull $1073741827, %ecx, %ecx # imm = 0x40000003
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    cmpl %ecx, %edi
; X64-NEXT:    sete %al
; X64-NEXT:    retq
  %urem = urem i32 %X, 1073741827
  %cmp = icmp eq i32 %urem, 0
  %ret = zext i1 %cmp to i32
  ret i32 %ret
}

; This is like test_urem_odd, except the divisor has bit 31 set.
define i32 @test_urem_odd_bit31(i32 %X) nounwind readnone {
; X86-LABEL: test_urem_odd_bit31:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl $1073741823, %edx # imm = 0x3FFFFFFF
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:    mull %edx
; X86-NEXT:    shrl $29, %edx
; X86-NEXT:    imull $-2147483645, %edx, %edx # imm = 0x80000003
; X86-NEXT:    xorl %eax, %eax
; X86-NEXT:    cmpl %edx, %ecx
; X86-NEXT:    sete %al
; X86-NEXT:    retl
;
; X64-LABEL: test_urem_odd_bit31:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    movq %rax, %rcx
; X64-NEXT:    shlq $30, %rcx
; X64-NEXT:    subq %rax, %rcx
; X64-NEXT:    shrq $61, %rcx
; X64-NEXT:    imull $-2147483645, %ecx, %ecx # imm = 0x80000003
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    cmpl %ecx, %edi
; X64-NEXT:    sete %al
; X64-NEXT:    retq
  %urem = urem i32 %X, 2147483651
  %cmp = icmp eq i32 %urem, 0
  %ret = zext i1 %cmp to i32
  ret i32 %ret
}

; This tests the BuildREMEqFold optimization with UREM, i16, even divisor, SETNE.
; In this case, D <=> 14 <=> 7 * 2^1, so D0 = 7 and K = 1.
; The corresponding pseudocode is:
; Q <- [N * multInv(D0, 2^16)] <=> [N * multInv(7, 2^16)] <=> [N * 28087]
; Q <- [Q >>rot K] <=> [Q >>rot 1]
; res <- ![Q <= (2^16 - 1) / 7] <=> ![Q <= 9362] <=> [Q > 9362]
define i16 @test_urem_even(i16 %X) nounwind readnone {
; X86-LABEL: test_urem_even:
; X86:       # %bb.0:
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:    shrl %eax
; X86-NEXT:    imull $18725, %eax, %eax # imm = 0x4925
; X86-NEXT:    shrl $17, %eax
; X86-NEXT:    movl %eax, %edx
; X86-NEXT:    shll $4, %edx
; X86-NEXT:    subl %eax, %edx
; X86-NEXT:    subl %eax, %edx
; X86-NEXT:    xorl %eax, %eax
; X86-NEXT:    cmpw %dx, %cx
; X86-NEXT:    setne %al
; X86-NEXT:    # kill: def $ax killed $ax killed $eax
; X86-NEXT:    retl
;
; X64-LABEL: test_urem_even:
; X64:       # %bb.0:
; X64-NEXT:    movzwl %di, %ecx
; X64-NEXT:    movl %ecx, %eax
; X64-NEXT:    shrl %eax
; X64-NEXT:    imull $18725, %eax, %eax # imm = 0x4925
; X64-NEXT:    shrl $17, %eax
; X64-NEXT:    movl %eax, %edx
; X64-NEXT:    shll $4, %edx
; X64-NEXT:    subl %eax, %edx
; X64-NEXT:    subl %eax, %edx
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    cmpw %dx, %cx
; X64-NEXT:    setne %al
; X64-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NEXT:    retq
  %urem = urem i16 %X, 14
  %cmp = icmp ne i16 %urem, 0
  %ret = zext i1 %cmp to i16
  ret i16 %ret
}

; This is like test_urem_even, except the divisor has bit 30 set.
define i32 @test_urem_even_bit30(i32 %X) nounwind readnone {
; X86-LABEL: test_urem_even_bit30:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl $-415, %edx # imm = 0xFE61
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:    mull %edx
; X86-NEXT:    shrl $30, %edx
; X86-NEXT:    imull $1073741928, %edx, %edx # imm = 0x40000068
; X86-NEXT:    xorl %eax, %eax
; X86-NEXT:    cmpl %edx, %ecx
; X86-NEXT:    sete %al
; X86-NEXT:    retl
;
; X64-LABEL: test_urem_even_bit30:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    movl $4294966881, %ecx # imm = 0xFFFFFE61
; X64-NEXT:    imulq %rax, %rcx
; X64-NEXT:    shrq $62, %rcx
; X64-NEXT:    imull $1073741928, %ecx, %ecx # imm = 0x40000068
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    cmpl %ecx, %edi
; X64-NEXT:    sete %al
; X64-NEXT:    retq
  %urem = urem i32 %X, 1073741928
  %cmp = icmp eq i32 %urem, 0
  %ret = zext i1 %cmp to i32
  ret i32 %ret
}

; This is like test_urem_odd, except the divisor has bit 31 set.
define i32 @test_urem_even_bit31(i32 %X) nounwind readnone {
; X86-LABEL: test_urem_even_bit31:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl $2147483547, %edx # imm = 0x7FFFFF9B
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:    mull %edx
; X86-NEXT:    shrl $30, %edx
; X86-NEXT:    imull $-2147483546, %edx, %edx # imm = 0x80000066
; X86-NEXT:    xorl %eax, %eax
; X86-NEXT:    cmpl %edx, %ecx
; X86-NEXT:    sete %al
; X86-NEXT:    retl
;
; X64-LABEL: test_urem_even_bit31:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    imulq $2147483547, %rax, %rax # imm = 0x7FFFFF9B
; X64-NEXT:    shrq $62, %rax
; X64-NEXT:    imull $-2147483546, %eax, %ecx # imm = 0x80000066
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    cmpl %ecx, %edi
; X64-NEXT:    sete %al
; X64-NEXT:    retq
  %urem = urem i32 %X, 2147483750
  %cmp = icmp eq i32 %urem, 0
  %ret = zext i1 %cmp to i32
  ret i32 %ret
}

; We should not proceed with this fold if the divisor is 1 or -1
define i32 @test_urem_one(i32 %X) nounwind readnone {
; CHECK-LABEL: test_urem_one:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl $1, %eax
; CHECK-NEXT:    ret{{[l|q]}}
  %urem = urem i32 %X, 1
  %cmp = icmp eq i32 %urem, 0
  %ret = zext i1 %cmp to i32
  ret i32 %ret
}

; We should not proceed with this fold if we can not compute
; multiplicative inverse
define i32 @test_urem_100(i32 %X) nounwind readnone {
; X86-LABEL: test_urem_100:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl $1374389535, %edx # imm = 0x51EB851F
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:    mull %edx
; X86-NEXT:    shrl $5, %edx
; X86-NEXT:    imull $100, %edx, %edx
; X86-NEXT:    xorl %eax, %eax
; X86-NEXT:    cmpl %edx, %ecx
; X86-NEXT:    sete %al
; X86-NEXT:    retl
;
; X64-LABEL: test_urem_100:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    imulq $1374389535, %rax, %rax # imm = 0x51EB851F
; X64-NEXT:    shrq $37, %rax
; X64-NEXT:    imull $100, %eax, %ecx
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    cmpl %ecx, %edi
; X64-NEXT:    sete %al
; X64-NEXT:    retq
  %urem = urem i32 %X, 100
  %cmp = icmp eq i32 %urem, 0
  %ret = zext i1 %cmp to i32
  ret i32 %ret
}

; We can lower remainder of division by powers of two much better elsewhere;
; also, BuildREMEqFold does not work when the only odd factor of the divisor is 1.
; This ensures we don't touch powers of two.
define i32 @test_urem_pow2(i32 %X) nounwind readnone {
; X86-LABEL: test_urem_pow2:
; X86:       # %bb.0:
; X86-NEXT:    xorl %eax, %eax
; X86-NEXT:    testb $15, {{[0-9]+}}(%esp)
; X86-NEXT:    sete %al
; X86-NEXT:    retl
;
; X64-LABEL: test_urem_pow2:
; X64:       # %bb.0:
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    testb $15, %dil
; X64-NEXT:    sete %al
; X64-NEXT:    retq
  %urem = urem i32 %X, 16
  %cmp = icmp eq i32 %urem, 0
  %ret = zext i1 %cmp to i32
  ret i32 %ret
}
