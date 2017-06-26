; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+sse4.2 | FileCheck %s --check-prefix=NARROW
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+sse4.2 -x86-experimental-vector-widening-legalization | FileCheck %s --check-prefix=WIDE

; FIXME: We shouldn't require both a movd and an insert in the wide version.

define void @update(i64* %dst_i, i64* %src_i, i32 %n) nounwind {
; NARROW-LABEL: update:
; NARROW:       # BB#0: # %entry
; NARROW-NEXT:    subl $12, %esp
; NARROW-NEXT:    movl $0, (%esp)
; NARROW-NEXT:    pcmpeqd %xmm0, %xmm0
; NARROW-NEXT:    movdqa {{.*#+}} xmm1 = <0,2,4,6,8,10,12,14,u,u,u,u,u,u,u,u>
; NARROW-NEXT:    jmp .LBB0_1
; NARROW-NEXT:    .p2align 4, 0x90
; NARROW-NEXT:  .LBB0_2: # %forbody
; NARROW-NEXT:    # in Loop: Header=BB0_1 Depth=1
; NARROW-NEXT:    movl (%esp), %eax
; NARROW-NEXT:    shll $3, %eax
; NARROW-NEXT:    addl {{[0-9]+}}(%esp), %eax
; NARROW-NEXT:    movl %eax, {{[0-9]+}}(%esp)
; NARROW-NEXT:    movl (%esp), %eax
; NARROW-NEXT:    shll $3, %eax
; NARROW-NEXT:    addl {{[0-9]+}}(%esp), %eax
; NARROW-NEXT:    movl %eax, {{[0-9]+}}(%esp)
; NARROW-NEXT:    movl (%esp), %ecx
; NARROW-NEXT:    movl {{[0-9]+}}(%esp), %edx
; NARROW-NEXT:    pmovzxbw {{.*#+}} xmm2 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
; NARROW-NEXT:    psubw %xmm0, %xmm2
; NARROW-NEXT:    psllw $8, %xmm2
; NARROW-NEXT:    psraw $8, %xmm2
; NARROW-NEXT:    psraw $2, %xmm2
; NARROW-NEXT:    pshufb %xmm1, %xmm2
; NARROW-NEXT:    movq %xmm2, (%edx,%ecx,8)
; NARROW-NEXT:    incl (%esp)
; NARROW-NEXT:  .LBB0_1: # %forcond
; NARROW-NEXT:    # =>This Inner Loop Header: Depth=1
; NARROW-NEXT:    movl (%esp), %eax
; NARROW-NEXT:    cmpl {{[0-9]+}}(%esp), %eax
; NARROW-NEXT:    jl .LBB0_2
; NARROW-NEXT:  # BB#3: # %afterfor
; NARROW-NEXT:    addl $12, %esp
; NARROW-NEXT:    retl
;
; WIDE-LABEL: update:
; WIDE:       # BB#0: # %entry
; WIDE-NEXT:    subl $12, %esp
; WIDE-NEXT:    movl $0, (%esp)
; WIDE-NEXT:    pcmpeqd %xmm0, %xmm0
; WIDE-NEXT:    movdqa {{.*#+}} xmm1 = [63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63]
; WIDE-NEXT:    movdqa {{.*#+}} xmm2 = [32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32]
; WIDE-NEXT:    jmp .LBB0_1
; WIDE-NEXT:    .p2align 4, 0x90
; WIDE-NEXT:  .LBB0_2: # %forbody
; WIDE-NEXT:    # in Loop: Header=BB0_1 Depth=1
; WIDE-NEXT:    movl (%esp), %eax
; WIDE-NEXT:    shll $3, %eax
; WIDE-NEXT:    addl {{[0-9]+}}(%esp), %eax
; WIDE-NEXT:    movl %eax, {{[0-9]+}}(%esp)
; WIDE-NEXT:    movl (%esp), %eax
; WIDE-NEXT:    shll $3, %eax
; WIDE-NEXT:    addl {{[0-9]+}}(%esp), %eax
; WIDE-NEXT:    movl %eax, {{[0-9]+}}(%esp)
; WIDE-NEXT:    movl (%esp), %ecx
; WIDE-NEXT:    movl {{[0-9]+}}(%esp), %edx
; WIDE-NEXT:    movd {{.*#+}} xmm3 = mem[0],zero,zero,zero
; WIDE-NEXT:    pinsrd $1, 4(%eax,%ecx,8), %xmm3
; WIDE-NEXT:    psubb %xmm0, %xmm3
; WIDE-NEXT:    psrlw $2, %xmm3
; WIDE-NEXT:    pand %xmm1, %xmm3
; WIDE-NEXT:    pxor %xmm2, %xmm3
; WIDE-NEXT:    psubb %xmm2, %xmm3
; WIDE-NEXT:    pextrd $1, %xmm3, 4(%edx,%ecx,8)
; WIDE-NEXT:    movd %xmm3, (%edx,%ecx,8)
; WIDE-NEXT:    incl (%esp)
; WIDE-NEXT:  .LBB0_1: # %forcond
; WIDE-NEXT:    # =>This Inner Loop Header: Depth=1
; WIDE-NEXT:    movl (%esp), %eax
; WIDE-NEXT:    cmpl {{[0-9]+}}(%esp), %eax
; WIDE-NEXT:    jl .LBB0_2
; WIDE-NEXT:  # BB#3: # %afterfor
; WIDE-NEXT:    addl $12, %esp
; WIDE-NEXT:    retl
entry:
	%dst_i.addr = alloca i64*
	%src_i.addr = alloca i64*
	%n.addr = alloca i32
	%i = alloca i32, align 4
	%dst = alloca <8 x i8>*, align 4
	%src = alloca <8 x i8>*, align 4
	store i64* %dst_i, i64** %dst_i.addr
	store i64* %src_i, i64** %src_i.addr
	store i32 %n, i32* %n.addr
	store i32 0, i32* %i
	br label %forcond

forcond:
	%tmp = load i32, i32* %i
	%tmp1 = load i32, i32* %n.addr
	%cmp = icmp slt i32 %tmp, %tmp1
	br i1 %cmp, label %forbody, label %afterfor

forbody:
	%tmp2 = load i32, i32* %i
	%tmp3 = load i64*, i64** %dst_i.addr
	%arrayidx = getelementptr i64, i64* %tmp3, i32 %tmp2
	%conv = bitcast i64* %arrayidx to <8 x i8>*
	store <8 x i8>* %conv, <8 x i8>** %dst
	%tmp4 = load i32, i32* %i
	%tmp5 = load i64*, i64** %src_i.addr
	%arrayidx6 = getelementptr i64, i64* %tmp5, i32 %tmp4
	%conv7 = bitcast i64* %arrayidx6 to <8 x i8>*
	store <8 x i8>* %conv7, <8 x i8>** %src
	%tmp8 = load i32, i32* %i
	%tmp9 = load <8 x i8>*, <8 x i8>** %dst
	%arrayidx10 = getelementptr <8 x i8>, <8 x i8>* %tmp9, i32 %tmp8
	%tmp11 = load i32, i32* %i
	%tmp12 = load <8 x i8>*, <8 x i8>** %src
	%arrayidx13 = getelementptr <8 x i8>, <8 x i8>* %tmp12, i32 %tmp11
	%tmp14 = load <8 x i8>, <8 x i8>* %arrayidx13
	%add = add <8 x i8> %tmp14, < i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1 >
	%shr = ashr <8 x i8> %add, < i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2 >
	store <8 x i8> %shr, <8 x i8>* %arrayidx10
	br label %forinc

forinc:
	%tmp15 = load i32, i32* %i
	%inc = add i32 %tmp15, 1
	store i32 %inc, i32* %i
	br label %forcond

afterfor:
	ret void
}

