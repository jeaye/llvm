; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -O2 -mtriple=m68k-linux-gnu -verify-machineinstrs \
; RUN:              -code-model=medium -relocation-model=pic \
; RUN:   | FileCheck %s

@ptr = external global i32*
@dst = external global i32
@src = external global i32

define void @test0() nounwind {
; CHECK-LABEL: test0:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    move.l (dst@GOTPCREL,%pc), %a0
; CHECK-NEXT:    move.l (ptr@GOTPCREL,%pc), %a1
; CHECK-NEXT:    move.l %a0, (%a1)
; CHECK-NEXT:    move.l (src@GOTPCREL,%pc), %a1
; CHECK-NEXT:    move.l (%a1), (%a0)
; CHECK-NEXT:    rts
entry:
    store i32* @dst, i32** @ptr
    %tmp.s = load i32, i32* @src
    store i32 %tmp.s, i32* @dst
    ret void
}

@ptr2 = global i32* null
@dst2 = global i32 0
@src2 = global i32 0

define void @test1() nounwind {
; CHECK-LABEL: test1:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    move.l (dst2@GOTPCREL,%pc), %a0
; CHECK-NEXT:    move.l (ptr2@GOTPCREL,%pc), %a1
; CHECK-NEXT:    move.l %a0, (%a1)
; CHECK-NEXT:    move.l (src2@GOTPCREL,%pc), %a1
; CHECK-NEXT:    move.l (%a1), (%a0)
; CHECK-NEXT:    rts
entry:
    store i32* @dst2, i32** @ptr2
    %tmp.s = load i32, i32* @src2
    store i32 %tmp.s, i32* @dst2
    ret void
}

declare i8* @malloc(i32)

define void @test2() nounwind {
; CHECK-LABEL: test2:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    sub.l #4, %sp
; CHECK-NEXT:    move.l #40, (%sp)
; CHECK-NEXT:    jsr (malloc@PLT,%pc)
; CHECK-NEXT:    add.l #4, %sp
; CHECK-NEXT:    rts
entry:
    %ptr = call i8* @malloc(i32 40)
    ret void
}

@pfoo = external global void(...)*
declare void(...)* @afoo(...)

define void @test3() nounwind {
; CHECK-LABEL: test3:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    sub.l #4, %sp
; CHECK-NEXT:    jsr (afoo@PLT,%pc)
; CHECK-NEXT:    move.l %d0, %a0
; CHECK-NEXT:    move.l (pfoo@GOTPCREL,%pc), %a1
; CHECK-NEXT:    move.l %a0, (%a1)
; CHECK-NEXT:    jsr (%a0)
; CHECK-NEXT:    add.l #4, %sp
; CHECK-NEXT:    rts
entry:
    %tmp = call void(...)*(...) @afoo()
    store void(...)* %tmp, void(...)** @pfoo
    %tmp1 = load void(...)*, void(...)** @pfoo
    call void(...) %tmp1()
    ret void
}

declare void @foo(...)

define void @test4() nounwind {
; CHECK-LABEL: test4:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    sub.l #4, %sp
; CHECK-NEXT:    jsr (foo@PLT,%pc)
; CHECK-NEXT:    add.l #4, %sp
; CHECK-NEXT:    rts
entry:
    call void(...) @foo()
    ret void
}

@ptr6 = internal global i32* null
@dst6 = internal global i32 0
@src6 = internal global i32 0

define void @test5() nounwind {
; CHECK-LABEL: test5:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    lea (_GLOBAL_OFFSET_TABLE_@GOTPCREL,%pc), %a0
; CHECK-NEXT:    move.l %a0, %a1
; CHECK-NEXT:    add.l #dst6@GOTOFF, %a1
; CHECK-NEXT:    move.l #ptr6@GOTOFF, %d0
; CHECK-NEXT:    move.l %a1, (0,%a0,%d0)
; CHECK-NEXT:    move.l #src6@GOTOFF, %d0
; CHECK-NEXT:    move.l #dst6@GOTOFF, %d1
; CHECK-NEXT:    move.l (0,%a0,%d0), (0,%a0,%d1)
; CHECK-NEXT:    rts
entry:
    store i32* @dst6, i32** @ptr6
    %tmp.s = load i32, i32* @src6
    store i32 %tmp.s, i32* @dst6
    ret void
}

define void @test7(i32 %n.u) nounwind {
; CHECK-LABEL: test7:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    move.l (4,%sp), %d0
; CHECK-NEXT:    add.l #-1, %d0
; CHECK-NEXT:    move.l %d0, %d1
; CHECK-NEXT:    sub.l #12, %d1
; CHECK-NEXT:    bhi .LBB6_12
; CHECK-NEXT:  ; %bb.1: ; %entry
; CHECK-NEXT:    lea (_GLOBAL_OFFSET_TABLE_@GOTPCREL,%pc), %a0
; CHECK-NEXT:    lsl.l #2, %d0
; CHECK-NEXT:    move.l %a0, %a1
; CHECK-NEXT:    add.l #.LJTI6_0@GOTOFF, %a1
; CHECK-NEXT:    add.l (0,%a1,%d0), %a0
; CHECK-NEXT:    jmp (%a0)
; CHECK-NEXT:  .LBB6_12: ; %bb2
; CHECK-NEXT:    bra foo6@PLT ; TAILCALL
; CHECK-NEXT:  .LBB6_3: ; %bb6
; CHECK-NEXT:    bra foo1@PLT ; TAILCALL
; CHECK-NEXT:  .LBB6_8: ; %bb1
; CHECK-NEXT:    bra foo2@PLT ; TAILCALL
; CHECK-NEXT:  .LBB6_9: ; %bb3
; CHECK-NEXT:    bra foo3@PLT ; TAILCALL
; CHECK-NEXT:  .LBB6_10: ; %bb4
; CHECK-NEXT:    bra foo4@PLT ; TAILCALL
; CHECK-NEXT:  .LBB6_14: ; %bb11
; CHECK-NEXT:    bra foo5@PLT ; TAILCALL
entry:
    switch i32 %n.u, label %bb12 [i32 1, label %bb i32 2, label %bb6 i32 4, label %bb7 i32 5, label %bb8 i32 6, label %bb10 i32 7, label %bb1 i32 8, label %bb3 i32 9, label %bb4 i32 10, label %bb9 i32 11, label %bb2 i32 12, label %bb5 i32 13, label %bb11 ]
bb:
    tail call void(...) @foo1()
    ret void
bb1:
    tail call void(...) @foo2()
    ret void
bb2:
    tail call void(...) @foo6()
    ret void
bb3:
    tail call void(...) @foo3()
    ret void
bb4:
    tail call void(...) @foo4()
    ret void
bb5:
    tail call void(...) @foo5()
    ret void
bb6:
    tail call void(...) @foo1()
    ret void
bb7:
    tail call void(...) @foo2()
    ret void
bb8:
    tail call void(...) @foo6()
    ret void
bb9:
    tail call void(...) @foo3()
    ret void
bb10:
    tail call void(...) @foo4()
    ret void
bb11:
    tail call void(...) @foo5()
    ret void
bb12:
    tail call void(...) @foo6()
    ret void
}

declare void @foo1(...)
declare void @foo2(...)
declare void @foo6(...)
declare void @foo3(...)
declare void @foo4(...)
declare void @foo5(...)
