; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=i686-linux-gnu -mattr=-ermsb < %s -o - | FileCheck %s --check-prefix=NOFAST32
; RUN: llc -mtriple=i686-linux-gnu -mattr=+ermsb < %s -o - | FileCheck %s --check-prefix=FAST32
; RUN: llc -mtriple=x86_64-linux-gnu -mattr=-ermsb < %s -o - | FileCheck %s --check-prefix=NOFAST
; RUN: llc -mtriple=x86_64-linux-gnu -mattr=+ermsb < %s -o - | FileCheck %s --check-prefix=FAST
; RUN: llc -mtriple=x86_64-linux-gnu -mcpu=generic < %s -o - | FileCheck %s --check-prefix=NOFAST
; RUN: llc -mtriple=x86_64-linux-gnu -mcpu=haswell < %s -o - | FileCheck %s --check-prefix=FAST
; RUN: llc -mtriple=x86_64-linux-gnu -mcpu=skylake < %s -o - | FileCheck %s --check-prefix=FAST
; FIXME: The documentation states that ivybridge has ermsb, but this is not
; enabled right now since I could not confirm by testing.
; RUN: llc -mtriple=x86_64-linux-gnu -mcpu=ivybridge < %s -o - | FileCheck %s --check-prefix=NOFAST

%struct.large = type { [4096 x i8] }

declare void @foo(%struct.large* align 8 byval(%struct.large)) nounwind

define void @test1(%struct.large* nocapture %x) nounwind {
; NOFAST32-LABEL: test1:
; NOFAST32:       # %bb.0:
; NOFAST32-NEXT:    pushl %edi
; NOFAST32-NEXT:    pushl %esi
; NOFAST32-NEXT:    subl $4100, %esp # imm = 0x1004
; NOFAST32-NEXT:    movl {{[0-9]+}}(%esp), %esi
; NOFAST32-NEXT:    movl $1024, %ecx # imm = 0x400
; NOFAST32-NEXT:    movl %esp, %edi
; NOFAST32-NEXT:    rep;movsl (%esi), %es:(%edi)
; NOFAST32-NEXT:    calll foo@PLT
; NOFAST32-NEXT:    addl $4100, %esp # imm = 0x1004
; NOFAST32-NEXT:    popl %esi
; NOFAST32-NEXT:    popl %edi
; NOFAST32-NEXT:    retl
;
; FAST32-LABEL: test1:
; FAST32:       # %bb.0:
; FAST32-NEXT:    pushl %edi
; FAST32-NEXT:    pushl %esi
; FAST32-NEXT:    subl $4100, %esp # imm = 0x1004
; FAST32-NEXT:    movl {{[0-9]+}}(%esp), %esi
; FAST32-NEXT:    movl $4096, %ecx # imm = 0x1000
; FAST32-NEXT:    movl %esp, %edi
; FAST32-NEXT:    rep;movsb (%esi), %es:(%edi)
; FAST32-NEXT:    calll foo@PLT
; FAST32-NEXT:    addl $4100, %esp # imm = 0x1004
; FAST32-NEXT:    popl %esi
; FAST32-NEXT:    popl %edi
; FAST32-NEXT:    retl
;
; NOFAST-LABEL: test1:
; NOFAST:       # %bb.0:
; NOFAST-NEXT:    subq $4104, %rsp # imm = 0x1008
; NOFAST-NEXT:    movq %rdi, %rsi
; NOFAST-NEXT:    movl $512, %ecx # imm = 0x200
; NOFAST-NEXT:    movq %rsp, %rdi
; NOFAST-NEXT:    rep;movsq (%rsi), %es:(%rdi)
; NOFAST-NEXT:    callq foo@PLT
; NOFAST-NEXT:    addq $4104, %rsp # imm = 0x1008
; NOFAST-NEXT:    retq
;
; FAST-LABEL: test1:
; FAST:       # %bb.0:
; FAST-NEXT:    subq $4104, %rsp # imm = 0x1008
; FAST-NEXT:    movq %rdi, %rsi
; FAST-NEXT:    movl $4096, %ecx # imm = 0x1000
; FAST-NEXT:    movq %rsp, %rdi
; FAST-NEXT:    rep;movsb (%rsi), %es:(%rdi)
; FAST-NEXT:    callq foo@PLT
; FAST-NEXT:    addq $4104, %rsp # imm = 0x1008
; FAST-NEXT:    retq
  call void @foo(%struct.large* align 8 byval(%struct.large) %x)
  ret void

}

define void @test2(%struct.large* nocapture %x) nounwind minsize {
; NOFAST32-LABEL: test2:
; NOFAST32:       # %bb.0:
; NOFAST32-NEXT:    pushl %edi
; NOFAST32-NEXT:    pushl %esi
; NOFAST32-NEXT:    subl $4100, %esp # imm = 0x1004
; NOFAST32-NEXT:    movl {{[0-9]+}}(%esp), %esi
; NOFAST32-NEXT:    movl $1024, %ecx # imm = 0x400
; NOFAST32-NEXT:    movl %esp, %edi
; NOFAST32-NEXT:    rep;movsl (%esi), %es:(%edi)
; NOFAST32-NEXT:    calll foo@PLT
; NOFAST32-NEXT:    addl $4100, %esp # imm = 0x1004
; NOFAST32-NEXT:    popl %esi
; NOFAST32-NEXT:    popl %edi
; NOFAST32-NEXT:    retl
;
; FAST32-LABEL: test2:
; FAST32:       # %bb.0:
; FAST32-NEXT:    pushl %edi
; FAST32-NEXT:    pushl %esi
; FAST32-NEXT:    subl $4100, %esp # imm = 0x1004
; FAST32-NEXT:    movl {{[0-9]+}}(%esp), %esi
; FAST32-NEXT:    movl $4096, %ecx # imm = 0x1000
; FAST32-NEXT:    movl %esp, %edi
; FAST32-NEXT:    rep;movsb (%esi), %es:(%edi)
; FAST32-NEXT:    calll foo@PLT
; FAST32-NEXT:    addl $4100, %esp # imm = 0x1004
; FAST32-NEXT:    popl %esi
; FAST32-NEXT:    popl %edi
; FAST32-NEXT:    retl
;
; NOFAST-LABEL: test2:
; NOFAST:       # %bb.0:
; NOFAST-NEXT:    subq $4104, %rsp # imm = 0x1008
; NOFAST-NEXT:    movq %rdi, %rsi
; NOFAST-NEXT:    movl $512, %ecx # imm = 0x200
; NOFAST-NEXT:    movq %rsp, %rdi
; NOFAST-NEXT:    rep;movsq (%rsi), %es:(%rdi)
; NOFAST-NEXT:    callq foo@PLT
; NOFAST-NEXT:    addq $4104, %rsp # imm = 0x1008
; NOFAST-NEXT:    retq
;
; FAST-LABEL: test2:
; FAST:       # %bb.0:
; FAST-NEXT:    subq $4104, %rsp # imm = 0x1008
; FAST-NEXT:    movq %rdi, %rsi
; FAST-NEXT:    movl $4096, %ecx # imm = 0x1000
; FAST-NEXT:    movq %rsp, %rdi
; FAST-NEXT:    rep;movsb (%rsi), %es:(%rdi)
; FAST-NEXT:    callq foo@PLT
; FAST-NEXT:    addq $4104, %rsp # imm = 0x1008
; FAST-NEXT:    retq
  call void @foo(%struct.large* align 8 byval(%struct.large) %x)
  ret void

}

%struct.large_oddsize = type { [4095 x i8] }

declare void @foo_oddsize(%struct.large_oddsize* align 8 byval(%struct.large_oddsize)) nounwind

define void @test3(%struct.large_oddsize* nocapture %x) nounwind minsize {
; NOFAST32-LABEL: test3:
; NOFAST32:       # %bb.0:
; NOFAST32-NEXT:    pushl %edi
; NOFAST32-NEXT:    pushl %esi
; NOFAST32-NEXT:    subl $4100, %esp # imm = 0x1004
; NOFAST32-NEXT:    movl {{[0-9]+}}(%esp), %esi
; NOFAST32-NEXT:    movl $4095, %ecx # imm = 0xFFF
; NOFAST32-NEXT:    movl %esp, %edi
; NOFAST32-NEXT:    rep;movsb (%esi), %es:(%edi)
; NOFAST32-NEXT:    calll foo_oddsize@PLT
; NOFAST32-NEXT:    addl $4100, %esp # imm = 0x1004
; NOFAST32-NEXT:    popl %esi
; NOFAST32-NEXT:    popl %edi
; NOFAST32-NEXT:    retl
;
; FAST32-LABEL: test3:
; FAST32:       # %bb.0:
; FAST32-NEXT:    pushl %edi
; FAST32-NEXT:    pushl %esi
; FAST32-NEXT:    subl $4100, %esp # imm = 0x1004
; FAST32-NEXT:    movl {{[0-9]+}}(%esp), %esi
; FAST32-NEXT:    movl $4095, %ecx # imm = 0xFFF
; FAST32-NEXT:    movl %esp, %edi
; FAST32-NEXT:    rep;movsb (%esi), %es:(%edi)
; FAST32-NEXT:    calll foo_oddsize@PLT
; FAST32-NEXT:    addl $4100, %esp # imm = 0x1004
; FAST32-NEXT:    popl %esi
; FAST32-NEXT:    popl %edi
; FAST32-NEXT:    retl
;
; NOFAST-LABEL: test3:
; NOFAST:       # %bb.0:
; NOFAST-NEXT:    subq $4104, %rsp # imm = 0x1008
; NOFAST-NEXT:    movq %rdi, %rsi
; NOFAST-NEXT:    movl $4095, %ecx # imm = 0xFFF
; NOFAST-NEXT:    movq %rsp, %rdi
; NOFAST-NEXT:    rep;movsb (%rsi), %es:(%rdi)
; NOFAST-NEXT:    callq foo_oddsize@PLT
; NOFAST-NEXT:    addq $4104, %rsp # imm = 0x1008
; NOFAST-NEXT:    retq
;
; FAST-LABEL: test3:
; FAST:       # %bb.0:
; FAST-NEXT:    subq $4104, %rsp # imm = 0x1008
; FAST-NEXT:    movq %rdi, %rsi
; FAST-NEXT:    movl $4095, %ecx # imm = 0xFFF
; FAST-NEXT:    movq %rsp, %rdi
; FAST-NEXT:    rep;movsb (%rsi), %es:(%rdi)
; FAST-NEXT:    callq foo_oddsize@PLT
; FAST-NEXT:    addq $4104, %rsp # imm = 0x1008
; FAST-NEXT:    retq
  call void @foo_oddsize(%struct.large_oddsize* align 8 byval(%struct.large_oddsize) %x)
  ret void

}
