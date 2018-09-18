; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown | FileCheck %s --check-prefix=X32
; RUN: llc < %s -mtriple=x86_64-unknown | FileCheck %s --check-prefix=X64

define zeroext i8 @test_udivrem_zext_ah(i8 %x, i8 %y) {
; X32-LABEL: test_udivrem_zext_ah:
; X32:       # %bb.0:
; X32-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    # kill: def $eax killed $eax def $ax
; X32-NEXT:    divb {{[0-9]+}}(%esp)
; X32-NEXT:    movzbl %ah, %ecx
; X32-NEXT:    movb %al, z
; X32-NEXT:    movl %ecx, %eax
; X32-NEXT:    retl
;
; X64-LABEL: test_udivrem_zext_ah:
; X64:       # %bb.0:
; X64-NEXT:    movzbl %dil, %eax
; X64-NEXT:    # kill: def $eax killed $eax def $ax
; X64-NEXT:    divb %sil
; X64-NEXT:    movzbl %ah, %ecx
; X64-NEXT:    movb %al, {{.*}}(%rip)
; X64-NEXT:    movl %ecx, %eax
; X64-NEXT:    retq
  %div = udiv i8 %x, %y
  store i8 %div, i8* @z
  %1 = urem i8 %x, %y
  ret i8 %1
}

define zeroext i8 @test_urem_zext_ah(i8 %x, i8 %y) {
; X32-LABEL: test_urem_zext_ah:
; X32:       # %bb.0:
; X32-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    # kill: def $eax killed $eax def $ax
; X32-NEXT:    divb {{[0-9]+}}(%esp)
; X32-NEXT:    movzbl %ah, %eax
; X32-NEXT:    # kill: def $al killed $al killed $eax
; X32-NEXT:    retl
;
; X64-LABEL: test_urem_zext_ah:
; X64:       # %bb.0:
; X64-NEXT:    movzbl %dil, %eax
; X64-NEXT:    # kill: def $eax killed $eax def $ax
; X64-NEXT:    divb %sil
; X64-NEXT:    movzbl %ah, %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %1 = urem i8 %x, %y
  ret i8 %1
}

define i8 @test_urem_noext_ah(i8 %x, i8 %y) {
; X32-LABEL: test_urem_noext_ah:
; X32:       # %bb.0:
; X32-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X32-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    # kill: def $eax killed $eax def $ax
; X32-NEXT:    divb %cl
; X32-NEXT:    movzbl %ah, %eax
; X32-NEXT:    addb %cl, %al
; X32-NEXT:    # kill: def $al killed $al killed $eax
; X32-NEXT:    retl
;
; X64-LABEL: test_urem_noext_ah:
; X64:       # %bb.0:
; X64-NEXT:    movzbl %dil, %eax
; X64-NEXT:    # kill: def $eax killed $eax def $ax
; X64-NEXT:    divb %sil
; X64-NEXT:    movzbl %ah, %eax
; X64-NEXT:    addb %sil, %al
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %1 = urem i8 %x, %y
  %2 = add i8 %1, %y
  ret i8 %2
}

define i64 @test_urem_zext64_ah(i8 %x, i8 %y) {
; X32-LABEL: test_urem_zext64_ah:
; X32:       # %bb.0:
; X32-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    # kill: def $eax killed $eax def $ax
; X32-NEXT:    divb {{[0-9]+}}(%esp)
; X32-NEXT:    movzbl %ah, %eax
; X32-NEXT:    xorl %edx, %edx
; X32-NEXT:    retl
;
; X64-LABEL: test_urem_zext64_ah:
; X64:       # %bb.0:
; X64-NEXT:    movzbl %dil, %eax
; X64-NEXT:    # kill: def $eax killed $eax def $ax
; X64-NEXT:    divb %sil
; X64-NEXT:    movzbl %ah, %eax
; X64-NEXT:    retq
  %1 = urem i8 %x, %y
  %2 = zext i8 %1 to i64
  ret i64 %2
}

define signext i8 @test_sdivrem_sext_ah(i8 %x, i8 %y) {
; X32-LABEL: test_sdivrem_sext_ah:
; X32:       # %bb.0:
; X32-NEXT:    movb {{[0-9]+}}(%esp), %al
; X32-NEXT:    cbtw
; X32-NEXT:    idivb {{[0-9]+}}(%esp)
; X32-NEXT:    movsbl %ah, %ecx
; X32-NEXT:    movb %al, z
; X32-NEXT:    movl %ecx, %eax
; X32-NEXT:    retl
;
; X64-LABEL: test_sdivrem_sext_ah:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    cbtw
; X64-NEXT:    idivb %sil
; X64-NEXT:    movsbl %ah, %ecx
; X64-NEXT:    movb %al, {{.*}}(%rip)
; X64-NEXT:    movl %ecx, %eax
; X64-NEXT:    retq
  %div = sdiv i8 %x, %y
  store i8 %div, i8* @z
  %1 = srem i8 %x, %y
  ret i8 %1
}

define signext i8 @test_srem_sext_ah(i8 %x, i8 %y) {
; X32-LABEL: test_srem_sext_ah:
; X32:       # %bb.0:
; X32-NEXT:    movb {{[0-9]+}}(%esp), %al
; X32-NEXT:    cbtw
; X32-NEXT:    idivb {{[0-9]+}}(%esp)
; X32-NEXT:    movsbl %ah, %eax
; X32-NEXT:    # kill: def $al killed $al killed $eax
; X32-NEXT:    retl
;
; X64-LABEL: test_srem_sext_ah:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    cbtw
; X64-NEXT:    idivb %sil
; X64-NEXT:    movsbl %ah, %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %1 = srem i8 %x, %y
  ret i8 %1
}

define i8 @test_srem_noext_ah(i8 %x, i8 %y) {
; X32-LABEL: test_srem_noext_ah:
; X32:       # %bb.0:
; X32-NEXT:    movb {{[0-9]+}}(%esp), %al
; X32-NEXT:    cbtw
; X32-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X32-NEXT:    idivb %cl
; X32-NEXT:    movsbl %ah, %eax
; X32-NEXT:    addb %cl, %al
; X32-NEXT:    # kill: def $al killed $al killed $eax
; X32-NEXT:    retl
;
; X64-LABEL: test_srem_noext_ah:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    cbtw
; X64-NEXT:    idivb %sil
; X64-NEXT:    movsbl %ah, %eax
; X64-NEXT:    addb %sil, %al
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %1 = srem i8 %x, %y
  %2 = add i8 %1, %y
  ret i8 %2
}

define i64 @test_srem_sext64_ah(i8 %x, i8 %y) {
; X32-LABEL: test_srem_sext64_ah:
; X32:       # %bb.0:
; X32-NEXT:    movb {{[0-9]+}}(%esp), %al
; X32-NEXT:    cbtw
; X32-NEXT:    idivb {{[0-9]+}}(%esp)
; X32-NEXT:    movsbl %ah, %eax
; X32-NEXT:    movl %eax, %edx
; X32-NEXT:    sarl $31, %edx
; X32-NEXT:    retl
;
; X64-LABEL: test_srem_sext64_ah:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    cbtw
; X64-NEXT:    idivb %sil
; X64-NEXT:    movsbl %ah, %eax
; X64-NEXT:    cltq
; X64-NEXT:    retq
  %1 = srem i8 %x, %y
  %2 = sext i8 %1 to i64
  ret i64 %2
}

define i64 @pr25754(i8 %a, i8 %c) {
; X32-LABEL: pr25754:
; X32:       # %bb.0:
; X32-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    # kill: def $eax killed $eax def $ax
; X32-NEXT:    divb {{[0-9]+}}(%esp)
; X32-NEXT:    movzbl %ah, %ecx
; X32-NEXT:    movzbl %al, %eax
; X32-NEXT:    addl %ecx, %eax
; X32-NEXT:    xorl %edx, %edx
; X32-NEXT:    retl
;
; X64-LABEL: pr25754:
; X64:       # %bb.0:
; X64-NEXT:    movzbl %dil, %eax
; X64-NEXT:    # kill: def $eax killed $eax def $ax
; X64-NEXT:    divb %sil
; X64-NEXT:    movzbl %ah, %ecx
; X64-NEXT:    movzbl %al, %eax
; X64-NEXT:    addq %rcx, %rax
; X64-NEXT:    retq
  %r1 = urem i8 %a, %c
  %d1 = udiv i8 %a, %c
  %r2 = zext i8 %r1 to i64
  %d2 = zext i8 %d1 to i64
  %ret = add i64 %r2, %d2
  ret i64 %ret
}

@z = external global i8
