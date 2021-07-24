; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basic-aa -licm -S | FileCheck %s
; RUN: opt < %s -basic-aa -licm -S -enable-mssa-loop-dependency=true -verify-memoryssa | FileCheck %s


declare i32 @strlen(i8*) readonly nounwind

declare void @foo()

; Sink readonly function.
define i32 @test1(i8* %P) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       Loop:
; CHECK-NEXT:    br i1 false, label [[LOOP]], label [[OUT:%.*]]
; CHECK:       Out:
; CHECK-NEXT:    [[A_LE:%.*]] = call i32 @strlen(i8* [[P:%.*]]) #[[ATTR3:[0-9]+]]
; CHECK-NEXT:    ret i32 [[A_LE]]
;
  br label %Loop

Loop:		; preds = %Loop, %0
  %A = call i32 @strlen( i8* %P ) readonly
  br i1 false, label %Loop, label %Out

Out:		; preds = %Loop
  ret i32 %A
}

declare double @sin(double) readnone nounwind

; Sink readnone function out of loop with unknown memory behavior.
define double @test2(double %X) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       Loop:
; CHECK-NEXT:    call void @foo()
; CHECK-NEXT:    br i1 true, label [[LOOP]], label [[OUT:%.*]]
; CHECK:       Out:
; CHECK-NEXT:    [[A_LE:%.*]] = call double @sin(double [[X:%.*]]) #[[ATTR4:[0-9]+]]
; CHECK-NEXT:    ret double [[A_LE]]
;
  br label %Loop

Loop:		; preds = %Loop, %0
  call void @foo( )
  %A = call double @sin( double %X ) readnone
  br i1 true, label %Loop, label %Out

Out:		; preds = %Loop
  ret double %A
}

; FIXME: Should be able to sink this case
define i32 @test2b(i32 %X) {
; CHECK-LABEL: @test2b(
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       Loop:
; CHECK-NEXT:    call void @foo()
; CHECK-NEXT:    br i1 true, label [[LOOP]], label [[OUT:%.*]]
; CHECK:       Out:
; CHECK-NEXT:    [[A_LE:%.*]] = sdiv i32 10, [[X:%.*]]
; CHECK-NEXT:    ret i32 [[A_LE]]
;
  br label %Loop

Loop:		; preds = %Loop, %0
  call void @foo( )
  %A = sdiv i32 10, %X
  br i1 true, label %Loop, label %Out

Out:		; preds = %Loop
  ret i32 %A
}

define double @test2c(double* %P) {
; CHECK-LABEL: @test2c(
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       Loop:
; CHECK-NEXT:    call void @foo()
; CHECK-NEXT:    br i1 true, label [[LOOP]], label [[OUT:%.*]]
; CHECK:       Out:
; CHECK-NEXT:    [[A_LE:%.*]] = load double, double* [[P:%.*]], align 8, !invariant.load !0
; CHECK-NEXT:    ret double [[A_LE]]
;
  br label %Loop

Loop:		; preds = %Loop, %0
  call void @foo( )
  %A = load double, double* %P, !invariant.load !{}
  br i1 true, label %Loop, label %Out

Out:		; preds = %Loop
  ret double %A
}

; This testcase checks to make sure the sinker does not cause problems with
; critical edges.
define void @test3() {
; CHECK-LABEL: @test3(
; CHECK-NEXT:  Entry:
; CHECK-NEXT:    br i1 false, label [[LOOP_PREHEADER:%.*]], label [[EXIT:%.*]]
; CHECK:       Loop.preheader:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       Loop:
; CHECK-NEXT:    br i1 false, label [[LOOP]], label [[EXIT_LOOPEXIT:%.*]]
; CHECK:       Exit.loopexit:
; CHECK-NEXT:    [[X_LE:%.*]] = add i32 0, 1
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       Exit:
; CHECK-NEXT:    [[Y:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[X_LE]], [[EXIT_LOOPEXIT]] ]
; CHECK-NEXT:    ret void
;
Entry:
  br i1 false, label %Loop, label %Exit
Loop:
  %X = add i32 0, 1
  br i1 false, label %Loop, label %Exit
Exit:
  %Y = phi i32 [ 0, %Entry ], [ %X, %Loop ]
  ret void


}

; If the result of an instruction is only used outside of the loop, sink
; the instruction to the exit blocks instead of executing it on every
; iteration of the loop.
;
define i32 @test4(i32 %N) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:  Entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       Loop:
; CHECK-NEXT:    [[N_ADDR_0_PN:%.*]] = phi i32 [ [[DEC:%.*]], [[LOOP]] ], [ [[N:%.*]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[DEC]] = add i32 [[N_ADDR_0_PN]], -1
; CHECK-NEXT:    [[TMP_1:%.*]] = icmp ne i32 [[N_ADDR_0_PN]], 1
; CHECK-NEXT:    br i1 [[TMP_1]], label [[LOOP]], label [[OUT:%.*]]
; CHECK:       Out:
; CHECK-NEXT:    [[N_ADDR_0_PN_LCSSA:%.*]] = phi i32 [ [[N_ADDR_0_PN]], [[LOOP]] ]
; CHECK-NEXT:    [[TMP_6_LE:%.*]] = mul i32 [[N]], [[N_ADDR_0_PN_LCSSA]]
; CHECK-NEXT:    [[TMP_7_LE:%.*]] = sub i32 [[TMP_6_LE]], [[N]]
; CHECK-NEXT:    ret i32 [[TMP_7_LE]]
;
Entry:
  br label %Loop
Loop:		; preds = %Loop, %Entry
  %N_addr.0.pn = phi i32 [ %dec, %Loop ], [ %N, %Entry ]
  %tmp.6 = mul i32 %N, %N_addr.0.pn		; <i32> [#uses=1]
  %tmp.7 = sub i32 %tmp.6, %N		; <i32> [#uses=1]
  %dec = add i32 %N_addr.0.pn, -1		; <i32> [#uses=1]
  %tmp.1 = icmp ne i32 %N_addr.0.pn, 1		; <i1> [#uses=1]
  br i1 %tmp.1, label %Loop, label %Out
Out:		; preds = %Loop
  ret i32 %tmp.7
}

; To reduce register pressure, if a load is hoistable out of the loop, and the
; result of the load is only used outside of the loop, sink the load instead of
; hoisting it!
;
@X = global i32 5		; <i32*> [#uses=1]

define i32 @test5(i32 %N) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:  Entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       Loop:
; CHECK-NEXT:    [[N_ADDR_0_PN:%.*]] = phi i32 [ [[DEC:%.*]], [[LOOP]] ], [ [[N:%.*]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[DEC]] = add i32 [[N_ADDR_0_PN]], -1
; CHECK-NEXT:    [[TMP_1:%.*]] = icmp ne i32 [[N_ADDR_0_PN]], 1
; CHECK-NEXT:    br i1 [[TMP_1]], label [[LOOP]], label [[OUT:%.*]]
; CHECK:       Out:
; CHECK-NEXT:    [[TMP_6_LE:%.*]] = load i32, i32* @X, align 4
; CHECK-NEXT:    ret i32 [[TMP_6_LE]]
;
Entry:
  br label %Loop
Loop:		; preds = %Loop, %Entry
  %N_addr.0.pn = phi i32 [ %dec, %Loop ], [ %N, %Entry ]
  %tmp.6 = load i32, i32* @X		; <i32> [#uses=1]
  %dec = add i32 %N_addr.0.pn, -1		; <i32> [#uses=1]
  %tmp.1 = icmp ne i32 %N_addr.0.pn, 1		; <i1> [#uses=1]
  br i1 %tmp.1, label %Loop, label %Out
Out:		; preds = %Loop
  ret i32 %tmp.6
}



; The loop sinker was running from the bottom of the loop to the top, causing
; it to miss opportunities to sink instructions that depended on sinking other
; instructions from the loop.  Instead they got hoisted, which is better than
; leaving them in the loop, but increases register pressure pointlessly.

  %Ty = type { i32, i32 }
@X2 = external global %Ty

define i32 @test6() {
; CHECK-LABEL: @test6(
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       Loop:
; CHECK-NEXT:    br i1 false, label [[LOOP]], label [[OUT:%.*]]
; CHECK:       Out:
; CHECK-NEXT:    [[DEAD_LE:%.*]] = getelementptr [[TY:%.*]], %Ty* @X2, i64 0, i32 0
; CHECK-NEXT:    [[SUNK2_LE:%.*]] = load i32, i32* [[DEAD_LE]], align 4
; CHECK-NEXT:    ret i32 [[SUNK2_LE]]
;
  br label %Loop
Loop:
  %dead = getelementptr %Ty, %Ty* @X2, i64 0, i32 0
  %sunk2 = load i32, i32* %dead
  br i1 false, label %Loop, label %Out
Out:		; preds = %Loop
  ret i32 %sunk2
}



; This testcase ensures that we can sink instructions from loops with
; multiple exits.
;
define i32 @test7(i32 %N, i1 %C) {
; CHECK-LABEL: @test7(
; CHECK-NEXT:  Entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       Loop:
; CHECK-NEXT:    [[N_ADDR_0_PN:%.*]] = phi i32 [ [[DEC:%.*]], [[CONTLOOP:%.*]] ], [ [[N:%.*]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[DEC]] = add i32 [[N_ADDR_0_PN]], -1
; CHECK-NEXT:    br i1 [[C:%.*]], label [[CONTLOOP]], label [[OUT1:%.*]]
; CHECK:       ContLoop:
; CHECK-NEXT:    [[TMP_1:%.*]] = icmp ne i32 [[N_ADDR_0_PN]], 1
; CHECK-NEXT:    br i1 [[TMP_1]], label [[LOOP]], label [[OUT2:%.*]]
; CHECK:       Out1:
; CHECK-NEXT:    [[N_ADDR_0_PN_LCSSA:%.*]] = phi i32 [ [[N_ADDR_0_PN]], [[LOOP]] ]
; CHECK-NEXT:    [[TMP_6_LE:%.*]] = mul i32 [[N]], [[N_ADDR_0_PN_LCSSA]]
; CHECK-NEXT:    [[TMP_7_LE2:%.*]] = sub i32 [[TMP_6_LE]], [[N]]
; CHECK-NEXT:    ret i32 [[TMP_7_LE2]]
; CHECK:       Out2:
; CHECK-NEXT:    [[N_ADDR_0_PN_LCSSA5:%.*]] = phi i32 [ [[N_ADDR_0_PN]], [[CONTLOOP]] ]
; CHECK-NEXT:    [[TMP_6_LE4:%.*]] = mul i32 [[N]], [[N_ADDR_0_PN_LCSSA5]]
; CHECK-NEXT:    [[TMP_7_LE:%.*]] = sub i32 [[TMP_6_LE4]], [[N]]
; CHECK-NEXT:    ret i32 [[TMP_7_LE]]
;
Entry:
  br label %Loop
Loop:		; preds = %ContLoop, %Entry
  %N_addr.0.pn = phi i32 [ %dec, %ContLoop ], [ %N, %Entry ]
  %tmp.6 = mul i32 %N, %N_addr.0.pn
  %tmp.7 = sub i32 %tmp.6, %N		; <i32> [#uses=2]
  %dec = add i32 %N_addr.0.pn, -1		; <i32> [#uses=1]
  br i1 %C, label %ContLoop, label %Out1
ContLoop:
  %tmp.1 = icmp ne i32 %N_addr.0.pn, 1
  br i1 %tmp.1, label %Loop, label %Out2
Out1:		; preds = %Loop
  ret i32 %tmp.7
Out2:		; preds = %ContLoop
  ret i32 %tmp.7
}


; This testcase checks to make sure we can sink values which are only live on
; some exits out of the loop, and that we can do so without breaking dominator
; info.
define i32 @test8(i1 %C1, i1 %C2, i32* %P, i32* %Q) {
; CHECK-LABEL: @test8(
; CHECK-NEXT:  Entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       Loop:
; CHECK-NEXT:    br i1 [[C1:%.*]], label [[CONT:%.*]], label [[EXIT1:%.*]]
; CHECK:       Cont:
; CHECK-NEXT:    [[X:%.*]] = load i32, i32* [[P:%.*]], align 4
; CHECK-NEXT:    store i32 [[X]], i32* [[Q:%.*]], align 4
; CHECK-NEXT:    br i1 [[C2:%.*]], label [[LOOP]], label [[EXIT2:%.*]]
; CHECK:       exit1:
; CHECK-NEXT:    ret i32 0
; CHECK:       exit2:
; CHECK-NEXT:    [[X_LCSSA:%.*]] = phi i32 [ [[X]], [[CONT]] ]
; CHECK-NEXT:    [[V_LE:%.*]] = add i32 [[X_LCSSA]], 1
; CHECK-NEXT:    ret i32 [[V_LE]]
;
Entry:
  br label %Loop
Loop:		; preds = %Cont, %Entry
  br i1 %C1, label %Cont, label %exit1
Cont:		; preds = %Loop
  %X = load i32, i32* %P		; <i32> [#uses=2]
  store i32 %X, i32* %Q
  %V = add i32 %X, 1		; <i32> [#uses=1]
  br i1 %C2, label %Loop, label %exit2
exit1:		; preds = %Loop
  ret i32 0
exit2:		; preds = %Cont
  ret i32 %V
}


define void @test9() {
; CHECK-LABEL: @test9(
; CHECK-NEXT:  loopentry.2.i:
; CHECK-NEXT:    br i1 false, label [[NO_EXIT_1_I_PREHEADER:%.*]], label [[LOOPENTRY_3_I_PREHEADER:%.*]]
; CHECK:       no_exit.1.i.preheader:
; CHECK-NEXT:    br label [[NO_EXIT_1_I:%.*]]
; CHECK:       no_exit.1.i:
; CHECK-NEXT:    br i1 false, label [[RETURN_I:%.*]], label [[ENDIF_8_I:%.*]]
; CHECK:       endif.8.i:
; CHECK-NEXT:    br i1 false, label [[NO_EXIT_1_I]], label [[LOOPENTRY_3_I_PREHEADER_LOOPEXIT:%.*]]
; CHECK:       loopentry.3.i.preheader.loopexit:
; CHECK-NEXT:    [[INC_1_I_LE:%.*]] = add i32 0, 1
; CHECK-NEXT:    br label [[LOOPENTRY_3_I_PREHEADER]]
; CHECK:       loopentry.3.i.preheader:
; CHECK-NEXT:    [[ARG_NUM_0_I_PH13000:%.*]] = phi i32 [ 0, [[LOOPENTRY_2_I:%.*]] ], [ [[INC_1_I_LE]], [[LOOPENTRY_3_I_PREHEADER_LOOPEXIT]] ]
; CHECK-NEXT:    ret void
; CHECK:       return.i:
; CHECK-NEXT:    ret void
;
loopentry.2.i:
  br i1 false, label %no_exit.1.i.preheader, label %loopentry.3.i.preheader
no_exit.1.i.preheader:		; preds = %loopentry.2.i
  br label %no_exit.1.i
no_exit.1.i:		; preds = %endif.8.i, %no_exit.1.i.preheader
  br i1 false, label %return.i, label %endif.8.i
endif.8.i:		; preds = %no_exit.1.i
  %inc.1.i = add i32 0, 1		; <i32> [#uses=1]
  br i1 false, label %no_exit.1.i, label %loopentry.3.i.preheader.loopexit
loopentry.3.i.preheader.loopexit:		; preds = %endif.8.i
  br label %loopentry.3.i.preheader
loopentry.3.i.preheader:		; preds = %loopentry.3.i.preheader.loopexit, %loopentry.2.i
  %arg_num.0.i.ph13000 = phi i32 [ 0, %loopentry.2.i ], [ %inc.1.i, %loopentry.3.i.preheader.loopexit ]		; <i32> [#uses=0]
  ret void
return.i:		; preds = %no_exit.1.i
  ret void

}


; Potentially trapping instructions may be sunk as long as they are guaranteed
; to be executed.
define i32 @test10(i32 %N) {
; CHECK-LABEL: @test10(
; CHECK-NEXT:  Entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       Loop:
; CHECK-NEXT:    [[N_ADDR_0_PN:%.*]] = phi i32 [ [[DEC:%.*]], [[LOOP]] ], [ [[N:%.*]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[DEC]] = add i32 [[N_ADDR_0_PN]], -1
; CHECK-NEXT:    [[TMP_1:%.*]] = icmp ne i32 [[N_ADDR_0_PN]], 0
; CHECK-NEXT:    br i1 [[TMP_1]], label [[LOOP]], label [[OUT:%.*]]
; CHECK:       Out:
; CHECK-NEXT:    [[N_ADDR_0_PN_LCSSA:%.*]] = phi i32 [ [[N_ADDR_0_PN]], [[LOOP]] ]
; CHECK-NEXT:    [[TMP_6_LE:%.*]] = sdiv i32 [[N]], [[N_ADDR_0_PN_LCSSA]]
; CHECK-NEXT:    ret i32 [[TMP_6_LE]]
;
Entry:
  br label %Loop
Loop:		; preds = %Loop, %Entry
  %N_addr.0.pn = phi i32 [ %dec, %Loop ], [ %N, %Entry ]		; <i32> [#uses=3]
  %tmp.6 = sdiv i32 %N, %N_addr.0.pn		; <i32> [#uses=1]
  %dec = add i32 %N_addr.0.pn, -1		; <i32> [#uses=1]
  %tmp.1 = icmp ne i32 %N_addr.0.pn, 0		; <i1> [#uses=1]
  br i1 %tmp.1, label %Loop, label %Out
Out:		; preds = %Loop
  ret i32 %tmp.6

}

; Should delete, not sink, dead instructions.
define void @test11() {
; CHECK-LABEL: @test11(
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       Loop:
; CHECK-NEXT:    br i1 false, label [[LOOP]], label [[OUT:%.*]]
; CHECK:       Out:
; CHECK-NEXT:    ret void
;
  br label %Loop
Loop:
  %dead1 = getelementptr %Ty, %Ty* @X2, i64 0, i32 0
  %dead2 = getelementptr %Ty, %Ty* @X2, i64 0, i32 1
  br i1 false, label %Loop, label %Out
Out:
  ret void
}

@c = common global [1 x i32] zeroinitializer, align 4

; Test a *many* way nested loop with multiple exit blocks both of which exit
; multiple loop nests. This exercises LCSSA corner cases.
define i32 @PR18753(i1* %a, i1* %b, i1* %c, i1* %d) {
; CHECK-LABEL: @PR18753(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[L1_HEADER:%.*]]
; CHECK:       l1.header:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[IV_NEXT:%.*]], [[L1_LATCH:%.*]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[ARRAYIDX_I:%.*]] = getelementptr inbounds [1 x i32], [1 x i32]* @c, i64 0, i64 [[IV]]
; CHECK-NEXT:    br label [[L2_HEADER:%.*]]
; CHECK:       l2.header:
; CHECK-NEXT:    [[X0:%.*]] = load i1, i1* [[C:%.*]], align 4
; CHECK-NEXT:    br i1 [[X0]], label [[L1_LATCH]], label [[L3_PREHEADER:%.*]]
; CHECK:       l3.preheader:
; CHECK-NEXT:    br label [[L3_HEADER:%.*]]
; CHECK:       l3.header:
; CHECK-NEXT:    [[X1:%.*]] = load i1, i1* [[D:%.*]], align 4
; CHECK-NEXT:    br i1 [[X1]], label [[L2_LATCH:%.*]], label [[L4_PREHEADER:%.*]]
; CHECK:       l4.preheader:
; CHECK-NEXT:    br label [[L4_HEADER:%.*]]
; CHECK:       l4.header:
; CHECK-NEXT:    [[X2:%.*]] = load i1, i1* [[A:%.*]], align 1
; CHECK-NEXT:    br i1 [[X2]], label [[L3_LATCH:%.*]], label [[L4_BODY:%.*]]
; CHECK:       l4.body:
; CHECK-NEXT:    call void @f(i32* [[ARRAYIDX_I]])
; CHECK-NEXT:    [[X3:%.*]] = load i1, i1* [[B:%.*]], align 1
; CHECK-NEXT:    br i1 [[X3]], label [[L4_LATCH:%.*]], label [[EXIT:%.*]]
; CHECK:       l4.latch:
; CHECK-NEXT:    call void @g()
; CHECK-NEXT:    [[X4:%.*]] = load i1, i1* [[B]], align 4
; CHECK-NEXT:    br i1 [[X4]], label [[L4_HEADER]], label [[EXIT]]
; CHECK:       l3.latch:
; CHECK-NEXT:    br label [[L3_HEADER]]
; CHECK:       l2.latch:
; CHECK-NEXT:    br label [[L2_HEADER]]
; CHECK:       l1.latch:
; CHECK-NEXT:    [[IV_NEXT]] = add nsw i64 [[IV]], 1
; CHECK-NEXT:    br label [[L1_HEADER]]
; CHECK:       exit:
; CHECK-NEXT:    [[IV_LCSSA:%.*]] = phi i64 [ [[IV]], [[L4_LATCH]] ], [ [[IV]], [[L4_BODY]] ]
; CHECK-NEXT:    [[L_LE:%.*]] = trunc i64 [[IV_LCSSA]] to i32
; CHECK-NEXT:    ret i32 [[L_LE]]
;
entry:
  br label %l1.header

l1.header:
  %iv = phi i64 [ %iv.next, %l1.latch ], [ 0, %entry ]
  %arrayidx.i = getelementptr inbounds [1 x i32], [1 x i32]* @c, i64 0, i64 %iv
  br label %l2.header

l2.header:
  %x0 = load i1, i1* %c, align 4
  br i1 %x0, label %l1.latch, label %l3.preheader

l3.preheader:
  br label %l3.header

l3.header:
  %x1 = load i1, i1* %d, align 4
  br i1 %x1, label %l2.latch, label %l4.preheader

l4.preheader:
  br label %l4.header

l4.header:
  %x2 = load i1, i1* %a
  br i1 %x2, label %l3.latch, label %l4.body

l4.body:
  call void @f(i32* %arrayidx.i)
  %x3 = load i1, i1* %b
  %l = trunc i64 %iv to i32
  br i1 %x3, label %l4.latch, label %exit

l4.latch:
  call void @g()
  %x4 = load i1, i1* %b, align 4
  br i1 %x4, label %l4.header, label %exit

l3.latch:
  br label %l3.header

l2.latch:
  br label %l2.header

l1.latch:
  %iv.next = add nsw i64 %iv, 1
  br label %l1.header

exit:
  %lcssa = phi i32 [ %l, %l4.latch ], [ %l, %l4.body ]

  ret i32 %lcssa
}

; @test12 moved to sink-promote.ll, as it tests sinking and promotion.

; Test that we don't crash when trying to sink stores and there's no preheader
; available (which is used for creating loads that may be used by the SSA
; updater)
define void @test13() {
; CHECK-LABEL: @test13(
; CHECK-NEXT:    br label [[LAB59:%.*]]
; CHECK:       lab19:
; CHECK-NEXT:    br i1 false, label [[LAB20:%.*]], label [[LAB38_LOOPEXIT:%.*]]
; CHECK:       lab20:
; CHECK-NEXT:    br label [[LAB60:%.*]]
; CHECK:       lab21:
; CHECK-NEXT:    br i1 undef, label [[LAB22:%.*]], label [[LAB38:%.*]]
; CHECK:       lab22:
; CHECK-NEXT:    br label [[LAB38]]
; CHECK:       lab38.loopexit:
; CHECK-NEXT:    br label [[LAB38]]
; CHECK:       lab38:
; CHECK-NEXT:    ret void
; CHECK:       lab59:
; CHECK-NEXT:    indirectbr i8* undef, [label [[LAB60]], label %lab38]
; CHECK:       lab60:
; CHECK-NEXT:    store i32 2145244101, i32* undef, align 4
; CHECK-NEXT:    indirectbr i8* undef, [label [[LAB21:%.*]], label %lab19]
;
  br label %lab59

lab19:
  br i1 undef, label %lab20, label %lab38

lab20:
  br label %lab60

lab21:
  br i1 undef, label %lab22, label %lab38

lab22:
  br label %lab38

lab38:
  ret void

lab59:
  indirectbr i8* undef, [label %lab60, label %lab38]

lab60:
  store i32 2145244101, i32* undef, align 4
  indirectbr i8* undef, [label %lab21, label %lab19]
}

; Check if LICM can sink a sinkable instruction the exit blocks through
; a non-trivially replacable PHI node.
define i32 @test14(i32 %N, i32 %N2, i1 %C) {
; CHECK-LABEL: @test14(
; CHECK-NEXT:  Entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       Loop:
; CHECK-NEXT:    [[N_ADDR_0_PN:%.*]] = phi i32 [ [[DEC:%.*]], [[CONTLOOP:%.*]] ], [ [[N:%.*]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[DEC]] = add i32 [[N_ADDR_0_PN]], -1
; CHECK-NEXT:    br i1 [[C:%.*]], label [[CONTLOOP]], label [[OUT12_SPLIT_LOOP_EXIT1:%.*]]
; CHECK:       ContLoop:
; CHECK-NEXT:    [[TMP_1:%.*]] = icmp ne i32 [[N_ADDR_0_PN]], 1
; CHECK-NEXT:    br i1 [[TMP_1]], label [[LOOP]], label [[OUT12_SPLIT_LOOP_EXIT:%.*]]
; CHECK:       Out12.split.loop.exit:
; CHECK-NEXT:    [[N_ADDR_0_PN_LCSSA4:%.*]] = phi i32 [ [[N_ADDR_0_PN]], [[CONTLOOP]] ]
; CHECK-NEXT:    [[SINK_MUL_LE3:%.*]] = mul i32 [[N]], [[N_ADDR_0_PN_LCSSA4]]
; CHECK-NEXT:    br label [[OUT12:%.*]]
; CHECK:       Out12.split.loop.exit1:
; CHECK-NEXT:    [[N_ADDR_0_PN_LCSSA:%.*]] = phi i32 [ [[N_ADDR_0_PN]], [[LOOP]] ]
; CHECK-NEXT:    [[SINK_MUL_LE:%.*]] = mul i32 [[N]], [[N_ADDR_0_PN_LCSSA]]
; CHECK-NEXT:    [[SINK_SUB_LE:%.*]] = sub i32 [[SINK_MUL_LE]], [[N]]
; CHECK-NEXT:    br label [[OUT12]]
; CHECK:       Out12:
; CHECK-NEXT:    [[TMP:%.*]] = phi i32 [ [[SINK_MUL_LE3]], [[OUT12_SPLIT_LOOP_EXIT]] ], [ [[SINK_SUB_LE]], [[OUT12_SPLIT_LOOP_EXIT1]] ]
; CHECK-NEXT:    ret i32 [[TMP]]
;
Entry:
  br label %Loop
Loop:
  %N_addr.0.pn = phi i32 [ %dec, %ContLoop ], [ %N, %Entry ]
  %sink.mul = mul i32 %N, %N_addr.0.pn
  %sink.sub = sub i32 %sink.mul, %N
  %dec = add i32 %N_addr.0.pn, -1
  br i1 %C, label %ContLoop, label %Out12
ContLoop:
  %tmp.1 = icmp ne i32 %N_addr.0.pn, 1
  br i1 %tmp.1, label %Loop, label %Out12
Out12:
  %tmp = phi i32 [%sink.mul,  %ContLoop], [%sink.sub, %Loop]
  ret i32 %tmp
}

; In this test, splitting predecessors is not really required because the
; operations of sinkable instructions (sub and mul) are same. In this case, we
; can sink the same sinkable operations and modify the PHI to pass the operands
; to the shared operations. As of now, we split predecessors of non-trivially
; replicalbe PHIs by default in LICM because all incoming edges of a
; non-trivially replacable PHI in LCSSA is critical.
define i32 @test15(i32 %N, i32 %N2, i1 %C) {
; CHECK-LABEL: @test15(
; CHECK-NEXT:  Entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       Loop:
; CHECK-NEXT:    [[N_ADDR_0_PN:%.*]] = phi i32 [ [[DEC:%.*]], [[CONTLOOP:%.*]] ], [ [[N:%.*]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[DEC]] = add i32 [[N_ADDR_0_PN]], -1
; CHECK-NEXT:    br i1 [[C:%.*]], label [[CONTLOOP]], label [[OUT12_SPLIT_LOOP_EXIT1:%.*]]
; CHECK:       ContLoop:
; CHECK-NEXT:    [[TMP_1:%.*]] = icmp ne i32 [[N_ADDR_0_PN]], 1
; CHECK-NEXT:    br i1 [[TMP_1]], label [[LOOP]], label [[OUT12_SPLIT_LOOP_EXIT:%.*]]
; CHECK:       Out12.split.loop.exit:
; CHECK-NEXT:    [[N_ADDR_0_PN_LCSSA5:%.*]] = phi i32 [ [[N_ADDR_0_PN]], [[CONTLOOP]] ]
; CHECK-NEXT:    [[SINK_MUL_LE4:%.*]] = mul i32 [[N]], [[N_ADDR_0_PN_LCSSA5]]
; CHECK-NEXT:    [[SINK_SUB2_LE:%.*]] = sub i32 [[SINK_MUL_LE4]], [[N2:%.*]]
; CHECK-NEXT:    br label [[OUT12:%.*]]
; CHECK:       Out12.split.loop.exit1:
; CHECK-NEXT:    [[N_ADDR_0_PN_LCSSA:%.*]] = phi i32 [ [[N_ADDR_0_PN]], [[LOOP]] ]
; CHECK-NEXT:    [[SINK_MUL_LE:%.*]] = mul i32 [[N]], [[N_ADDR_0_PN_LCSSA]]
; CHECK-NEXT:    [[SINK_SUB_LE:%.*]] = sub i32 [[SINK_MUL_LE]], [[N]]
; CHECK-NEXT:    br label [[OUT12]]
; CHECK:       Out12:
; CHECK-NEXT:    [[TMP:%.*]] = phi i32 [ [[SINK_SUB2_LE]], [[OUT12_SPLIT_LOOP_EXIT]] ], [ [[SINK_SUB_LE]], [[OUT12_SPLIT_LOOP_EXIT1]] ]
; CHECK-NEXT:    ret i32 [[TMP]]
;
Entry:
  br label %Loop
Loop:
  %N_addr.0.pn = phi i32 [ %dec, %ContLoop ], [ %N, %Entry ]
  %sink.mul = mul i32 %N, %N_addr.0.pn
  %sink.sub = sub i32 %sink.mul, %N
  %sink.sub2 = sub i32 %sink.mul, %N2
  %dec = add i32 %N_addr.0.pn, -1
  br i1 %C, label %ContLoop, label %Out12
ContLoop:
  %tmp.1 = icmp ne i32 %N_addr.0.pn, 1
  br i1 %tmp.1, label %Loop, label %Out12
Out12:
  %tmp = phi i32 [%sink.sub2, %ContLoop], [%sink.sub, %Loop]
  ret i32 %tmp
}

; Sink through a non-trivially replacable PHI node which use the same sinkable
; instruction multiple times.
define i32 @test16(i1 %c, i8** %P, i32* %P2, i64 %V) {
; CHECK-LABEL: @test16(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP_PH:%.*]]
; CHECK:       loop.ph:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       Loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ 0, [[LOOP_PH]] ], [ [[NEXT:%.*]], [[CONTLOOP:%.*]] ]
; CHECK-NEXT:    [[L2:%.*]] = call i32 @getv()
; CHECK-NEXT:    switch i32 [[L2]], label [[CONTLOOP]] [
; CHECK-NEXT:    i32 32, label [[OUT_SPLIT_LOOP_EXIT1:%.*]]
; CHECK-NEXT:    i32 46, label [[OUT_SPLIT_LOOP_EXIT1]]
; CHECK-NEXT:    i32 95, label [[OUT_SPLIT_LOOP_EXIT1]]
; CHECK-NEXT:    ]
; CHECK:       ContLoop:
; CHECK-NEXT:    [[NEXT]] = add nuw i64 [[IV]], 1
; CHECK-NEXT:    [[C1:%.*]] = call i1 @getc()
; CHECK-NEXT:    br i1 [[C1]], label [[LOOP]], label [[OUT_SPLIT_LOOP_EXIT:%.*]]
; CHECK:       Out.split.loop.exit:
; CHECK-NEXT:    [[IDX_PH:%.*]] = phi i32 [ [[L2]], [[CONTLOOP]] ]
; CHECK-NEXT:    br label [[OUT:%.*]]
; CHECK:       Out.split.loop.exit1:
; CHECK-NEXT:    [[IV_LCSSA:%.*]] = phi i64 [ [[IV]], [[LOOP]] ], [ [[IV]], [[LOOP]] ], [ [[IV]], [[LOOP]] ]
; CHECK-NEXT:    [[L2_LCSSA:%.*]] = phi i32 [ [[L2]], [[LOOP]] ], [ [[L2]], [[LOOP]] ], [ [[L2]], [[LOOP]] ]
; CHECK-NEXT:    [[T_LE:%.*]] = trunc i64 [[IV_LCSSA]] to i32
; CHECK-NEXT:    [[SINKABLE_LE:%.*]] = mul i32 [[L2_LCSSA]], [[T_LE]]
; CHECK-NEXT:    br label [[OUT]]
; CHECK:       Out:
; CHECK-NEXT:    [[IDX:%.*]] = phi i32 [ [[IDX_PH]], [[OUT_SPLIT_LOOP_EXIT]] ], [ [[SINKABLE_LE]], [[OUT_SPLIT_LOOP_EXIT1]] ]
; CHECK-NEXT:    ret i32 [[IDX]]
;
entry:
  br label %loop.ph
loop.ph:
  br label %Loop
Loop:
  %iv = phi i64 [ 0, %loop.ph ], [ %next, %ContLoop ]
  %l2 = call i32 @getv()
  %t = trunc i64 %iv to i32
  %sinkable = mul i32 %l2,  %t
  switch i32 %l2, label %ContLoop [
  i32 32, label %Out
  i32 46, label %Out
  i32 95, label %Out
  ]
ContLoop:
  %next = add nuw i64 %iv, 1
  %c1 = call i1 @getc()
  br i1 %c1, label %Loop, label %Out
Out:
  %idx = phi i32 [ %l2, %ContLoop ], [ %sinkable, %Loop ], [ %sinkable, %Loop ], [ %sinkable, %Loop ]
  ret i32 %idx
}

; Sink a sinkable instruction through multiple non-trivially replacable PHIs in
; differect exit blocks.
define i32 @test17(i32 %N, i32 %N2) {
; CHECK-LABEL: @test17(
; CHECK-NEXT:  Entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       Loop:
; CHECK-NEXT:    [[N_ADDR_0_PN:%.*]] = phi i32 [ [[DEC:%.*]], [[CONTLOOP3:%.*]] ], [ [[N:%.*]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[C0:%.*]] = call i1 @getc()
; CHECK-NEXT:    br i1 [[C0]], label [[CONTLOOP1:%.*]], label [[OUTA_SPLIT_LOOP_EXIT3:%.*]]
; CHECK:       ContLoop1:
; CHECK-NEXT:    [[C1:%.*]] = call i1 @getc()
; CHECK-NEXT:    br i1 [[C1]], label [[CONTLOOP2:%.*]], label [[OUTA_SPLIT_LOOP_EXIT:%.*]]
; CHECK:       ContLoop2:
; CHECK-NEXT:    [[C2:%.*]] = call i1 @getc()
; CHECK-NEXT:    br i1 [[C2]], label [[CONTLOOP3]], label [[OUTB_SPLIT_LOOP_EXIT1:%.*]]
; CHECK:       ContLoop3:
; CHECK-NEXT:    [[C3:%.*]] = call i1 @getc()
; CHECK-NEXT:    [[DEC]] = add i32 [[N_ADDR_0_PN]], -1
; CHECK-NEXT:    br i1 [[C3]], label [[LOOP]], label [[OUTB_SPLIT_LOOP_EXIT:%.*]]
; CHECK:       OutA.split.loop.exit:
; CHECK-NEXT:    [[N_ADDR_0_PN_LCSSA:%.*]] = phi i32 [ [[N_ADDR_0_PN]], [[CONTLOOP1]] ]
; CHECK-NEXT:    [[SINK_MUL_LE:%.*]] = mul i32 [[N]], [[N_ADDR_0_PN_LCSSA]]
; CHECK-NEXT:    br label [[OUTA:%.*]]
; CHECK:       OutA.split.loop.exit3:
; CHECK-NEXT:    [[TMP1_PH4:%.*]] = phi i32 [ [[N2:%.*]], [[LOOP]] ]
; CHECK-NEXT:    br label [[OUTA]]
; CHECK:       OutA:
; CHECK-NEXT:    [[TMP1:%.*]] = phi i32 [ [[SINK_MUL_LE]], [[OUTA_SPLIT_LOOP_EXIT]] ], [ [[TMP1_PH4]], [[OUTA_SPLIT_LOOP_EXIT3]] ]
; CHECK-NEXT:    br label [[OUT12:%.*]]
; CHECK:       OutB.split.loop.exit:
; CHECK-NEXT:    [[TMP2_PH:%.*]] = phi i32 [ [[DEC]], [[CONTLOOP3]] ]
; CHECK-NEXT:    br label [[OUTB:%.*]]
; CHECK:       OutB.split.loop.exit1:
; CHECK-NEXT:    [[N_ADDR_0_PN_LCSSA6:%.*]] = phi i32 [ [[N_ADDR_0_PN]], [[CONTLOOP2]] ]
; CHECK-NEXT:    [[SINK_MUL_LE5:%.*]] = mul i32 [[N]], [[N_ADDR_0_PN_LCSSA6]]
; CHECK-NEXT:    br label [[OUTB]]
; CHECK:       OutB:
; CHECK-NEXT:    [[TMP2:%.*]] = phi i32 [ [[TMP2_PH]], [[OUTB_SPLIT_LOOP_EXIT]] ], [ [[SINK_MUL_LE5]], [[OUTB_SPLIT_LOOP_EXIT1]] ]
; CHECK-NEXT:    br label [[OUT12]]
; CHECK:       Out12:
; CHECK-NEXT:    [[TMP:%.*]] = phi i32 [ [[TMP1]], [[OUTA]] ], [ [[TMP2]], [[OUTB]] ]
; CHECK-NEXT:    ret i32 [[TMP]]
;
Entry:
  br label %Loop
Loop:
  %N_addr.0.pn = phi i32 [ %dec, %ContLoop3 ], [ %N, %Entry ]
  %sink.mul = mul i32 %N, %N_addr.0.pn
  %c0 = call i1 @getc()
  br i1 %c0 , label %ContLoop1, label %OutA
ContLoop1:
  %c1 = call i1 @getc()
  br i1 %c1, label %ContLoop2, label %OutA

ContLoop2:
  %c2 = call i1 @getc()
  br i1 %c2, label %ContLoop3, label %OutB
ContLoop3:
  %c3 = call i1 @getc()
  %dec = add i32 %N_addr.0.pn, -1
  br i1 %c3, label %Loop, label %OutB
OutA:
  %tmp1 = phi i32 [%sink.mul, %ContLoop1], [%N2, %Loop]
  br label %Out12
OutB:
  %tmp2 = phi i32 [%sink.mul, %ContLoop2], [%dec, %ContLoop3]
  br label %Out12
Out12:
  %tmp = phi i32 [%tmp1, %OutA], [%tmp2, %OutB]
  ret i32 %tmp
}


; Sink a sinkable instruction through both trivially and non-trivially replacable PHIs.
define i32 @test18(i32 %N, i32 %N2) {
; CHECK-LABEL: @test18(
; CHECK-NEXT:  Entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       Loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ [[DEC:%.*]], [[CONTLOOP:%.*]] ], [ [[N:%.*]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[C0:%.*]] = call i1 @getc()
; CHECK-NEXT:    br i1 [[C0]], label [[CONTLOOP]], label [[OUT12_SPLIT_LOOP_EXIT1:%.*]]
; CHECK:       ContLoop:
; CHECK-NEXT:    [[DEC]] = add i32 [[IV]], -1
; CHECK-NEXT:    [[C1:%.*]] = call i1 @getc()
; CHECK-NEXT:    br i1 [[C1]], label [[LOOP]], label [[OUT12_SPLIT_LOOP_EXIT:%.*]]
; CHECK:       Out12.split.loop.exit:
; CHECK-NEXT:    [[IV_LCSSA:%.*]] = phi i32 [ [[IV]], [[CONTLOOP]] ]
; CHECK-NEXT:    [[TMP2_PH:%.*]] = phi i32 [ [[DEC]], [[CONTLOOP]] ]
; CHECK-NEXT:    [[SINK_MUL_LE:%.*]] = mul i32 [[N]], [[IV_LCSSA]]
; CHECK-NEXT:    [[SINK_SUB_LE4:%.*]] = sub i32 [[SINK_MUL_LE]], [[N2:%.*]]
; CHECK-NEXT:    br label [[OUT12:%.*]]
; CHECK:       Out12.split.loop.exit1:
; CHECK-NEXT:    [[IV_LCSSA7:%.*]] = phi i32 [ [[IV]], [[LOOP]] ]
; CHECK-NEXT:    [[SINK_MUL_LE6:%.*]] = mul i32 [[N]], [[IV_LCSSA7]]
; CHECK-NEXT:    [[SINK_SUB_LE:%.*]] = sub i32 [[SINK_MUL_LE6]], [[N2]]
; CHECK-NEXT:    br label [[OUT12]]
; CHECK:       Out12:
; CHECK-NEXT:    [[TMP1:%.*]] = phi i32 [ [[SINK_SUB_LE4]], [[OUT12_SPLIT_LOOP_EXIT]] ], [ [[SINK_SUB_LE]], [[OUT12_SPLIT_LOOP_EXIT1]] ]
; CHECK-NEXT:    [[TMP2:%.*]] = phi i32 [ [[TMP2_PH]], [[OUT12_SPLIT_LOOP_EXIT]] ], [ [[SINK_SUB_LE]], [[OUT12_SPLIT_LOOP_EXIT1]] ]
; CHECK-NEXT:    [[ADD:%.*]] = add i32 [[TMP1]], [[TMP2]]
; CHECK-NEXT:    ret i32 [[ADD]]
;
Entry:
  br label %Loop
Loop:
  %iv = phi i32 [ %dec, %ContLoop ], [ %N, %Entry ]
  %sink.mul = mul i32 %N, %iv
  %sink.sub = sub i32 %sink.mul, %N2
  %c0 = call i1 @getc()
  br i1 %c0, label %ContLoop, label %Out12
ContLoop:
  %dec = add i32 %iv, -1
  %c1 = call i1 @getc()
  br i1 %c1, label %Loop, label %Out12
Out12:
  %tmp1 = phi i32 [%sink.sub, %ContLoop], [%sink.sub, %Loop]
  %tmp2 = phi i32 [%dec, %ContLoop], [%sink.sub, %Loop]
  %add = add i32 %tmp1, %tmp2
  ret i32 %add
}

; Do not sink an instruction through a non-trivially replacable PHI, to avoid
; assert while splitting predecessors, if the terminator of predecessor is an
; indirectbr.
define i32 @test19(i1 %cond, i1 %cond2, i8* %address, i32 %v1) nounwind {
; CHECK-LABEL: @test19(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[INDIRECT_GOTO_DEST:%.*]] = select i1 [[COND:%.*]], i8* blockaddress(@test19, [[EXIT:%.*]]), i8* [[ADDRESS:%.*]]
; CHECK-NEXT:    [[INDIRECT_GOTO_DEST2:%.*]] = select i1 [[COND2:%.*]], i8* blockaddress(@test19, [[EXIT]]), i8* [[ADDRESS]]
; CHECK-NEXT:    br label [[L0:%.*]]
; CHECK:       L0:
; CHECK-NEXT:    [[V2:%.*]] = call i32 @getv()
; CHECK-NEXT:    [[SINKABLE:%.*]] = mul i32 [[V1:%.*]], [[V2]]
; CHECK-NEXT:    [[SINKABLE2:%.*]] = add i32 [[V1]], [[V2]]
; CHECK-NEXT:    indirectbr i8* [[INDIRECT_GOTO_DEST]], [label [[L1:%.*]], label %exit]
; CHECK:       L1:
; CHECK-NEXT:    indirectbr i8* [[INDIRECT_GOTO_DEST2]], [label [[L0]], label %exit]
; CHECK:       exit:
; CHECK-NEXT:    [[R:%.*]] = phi i32 [ [[SINKABLE]], [[L0]] ], [ [[SINKABLE2]], [[L1]] ]
; CHECK-NEXT:    ret i32 [[R]]
;
entry:
  br label %L0
L0:
  %indirect.goto.dest = select i1 %cond, i8* blockaddress(@test19, %exit), i8* %address
  %v2 = call i32 @getv()
  %sinkable = mul i32 %v1, %v2
  %sinkable2 = add i32 %v1, %v2
  indirectbr i8* %indirect.goto.dest, [label %L1, label %exit]

L1:
  %indirect.goto.dest2 = select i1 %cond2, i8* blockaddress(@test19, %exit), i8* %address
  indirectbr i8* %indirect.goto.dest2, [label %L0, label %exit]

exit:
  %r = phi i32 [%sinkable, %L0], [%sinkable2, %L1]
  ret i32 %r
}


; Do not sink through a non-trivially replacable PHI if splitting predecessors
; not allowed in SplitBlockPredecessors().
define void @test20(i32* %s, i1 %b, i32 %v1, i32 %v2) personality i32 (...)* @__CxxFrameHandler3 {
; CHECK-LABEL: @test20(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[WHILE_COND:%.*]]
; CHECK:       while.cond:
; CHECK-NEXT:    [[V:%.*]] = call i32 @getv()
; CHECK-NEXT:    [[SINKABLE:%.*]] = mul i32 [[V]], [[V2:%.*]]
; CHECK-NEXT:    [[SINKABLE2:%.*]] = add i32 [[V]], [[V2]]
; CHECK-NEXT:    br i1 [[B:%.*]], label [[TRY_CONT:%.*]], label [[WHILE_BODY:%.*]]
; CHECK:       while.body:
; CHECK-NEXT:    invoke void @may_throw()
; CHECK-NEXT:    to label [[WHILE_BODY2:%.*]] unwind label [[CATCH_DISPATCH:%.*]]
; CHECK:       while.body2:
; CHECK-NEXT:    invoke void @may_throw2()
; CHECK-NEXT:    to label [[WHILE_COND]] unwind label [[CATCH_DISPATCH]]
; CHECK:       catch.dispatch:
; CHECK-NEXT:    [[DOTLCSSA1:%.*]] = phi i32 [ [[SINKABLE]], [[WHILE_BODY]] ], [ [[SINKABLE2]], [[WHILE_BODY2]] ]
; CHECK-NEXT:    [[CP:%.*]] = cleanuppad within none []
; CHECK-NEXT:    store i32 [[DOTLCSSA1]], i32* [[S:%.*]], align 4
; CHECK-NEXT:    cleanupret from [[CP]] unwind to caller
; CHECK:       try.cont:
; CHECK-NEXT:    ret void
;
entry:
  br label %while.cond
while.cond:
  %v = call i32 @getv()
  %sinkable = mul i32 %v, %v2
  %sinkable2 = add  i32 %v, %v2
  br i1 %b, label %try.cont, label %while.body
while.body:
  invoke void @may_throw()
  to label %while.body2 unwind label %catch.dispatch
while.body2:
  invoke void @may_throw2()
  to label %while.cond unwind label %catch.dispatch
catch.dispatch:
  %.lcssa1 = phi i32 [ %sinkable, %while.body ], [ %sinkable2, %while.body2 ]
  %cp = cleanuppad within none []
  store i32 %.lcssa1, i32* %s
  cleanupret from %cp unwind to caller
try.cont:
  ret void
}

; The sinkable call should be sunk into an exit block split. After splitting
; the exit block, BlockColor for new blocks should be added properly so
; that we should be able to access valid ColorVector.
define i32 @test21_pr36184(i8* %P) personality i32 (...)* @__CxxFrameHandler3 {
; CHECK-LABEL: @test21_pr36184(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP_PH:%.*]]
; CHECK:       loop.ph:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       Loop:
; CHECK-NEXT:    br i1 false, label [[CONTLOOP:%.*]], label [[OUT_SPLIT_LOOP_EXIT1:%.*]]
; CHECK:       ContLoop:
; CHECK-NEXT:    br i1 false, label [[LOOP]], label [[OUT_SPLIT_LOOP_EXIT:%.*]]
; CHECK:       Out.split.loop.exit:
; CHECK-NEXT:    [[IDX_PH:%.*]] = phi i32 [ 0, [[CONTLOOP]] ]
; CHECK-NEXT:    br label [[OUT:%.*]]
; CHECK:       Out.split.loop.exit1:
; CHECK-NEXT:    [[SINKABLECALL_LE:%.*]] = call i32 @strlen(i8* [[P:%.*]]) #[[ATTR3]]
; CHECK-NEXT:    br label [[OUT]]
; CHECK:       Out:
; CHECK-NEXT:    [[IDX:%.*]] = phi i32 [ [[IDX_PH]], [[OUT_SPLIT_LOOP_EXIT]] ], [ [[SINKABLECALL_LE]], [[OUT_SPLIT_LOOP_EXIT1]] ]
; CHECK-NEXT:    ret i32 [[IDX]]
;
entry:
  br label %loop.ph

loop.ph:
  br label %Loop

Loop:
  %sinkableCall = call i32 @strlen( i8* %P ) readonly
  br i1 undef, label %ContLoop, label %Out

ContLoop:
  br i1 undef, label %Loop, label %Out

Out:
  %idx = phi i32 [ %sinkableCall, %Loop ], [0, %ContLoop ]
  ret i32 %idx
}

; We do not support splitting a landingpad block if BlockColors is not empty.
define void @test22(i1 %b, i32 %v1, i32 %v2) personality i32 (...)* @__CxxFrameHandler3 {
; CHECK-LABEL: @test22(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[WHILE_COND:%.*]]
; CHECK:       while.cond:
; CHECK-NEXT:    br i1 [[B:%.*]], label [[TRY_CONT:%.*]], label [[WHILE_BODY:%.*]]
; CHECK:       while.body:
; CHECK-NEXT:    invoke void @may_throw()
; CHECK-NEXT:    to label [[WHILE_BODY2:%.*]] unwind label [[LPADBB:%.*]]
; CHECK:       while.body2:
; CHECK-NEXT:    [[V:%.*]] = call i32 @getv()
; CHECK-NEXT:    [[MUL:%.*]] = mul i32 [[V]], [[V2:%.*]]
; CHECK-NEXT:    invoke void @may_throw2()
; CHECK-NEXT:    to label [[WHILE_COND]] unwind label [[LPADBB]]
; CHECK:       lpadBB:
; CHECK-NEXT:    [[DOTLCSSA1:%.*]] = phi i32 [ 0, [[WHILE_BODY]] ], [ [[MUL]], [[WHILE_BODY2]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = landingpad { i8*, i32 }
; CHECK-NEXT:    catch i8* null
; CHECK-NEXT:    br label [[LPADBBSUCC1:%.*]]
; CHECK:       lpadBBSucc1:
; CHECK-NEXT:    ret void
; CHECK:       try.cont:
; CHECK-NEXT:    ret void
;
entry:
  br label %while.cond
while.cond:
  br i1 %b, label %try.cont, label %while.body

while.body:
  invoke void @may_throw()
  to label %while.body2 unwind label %lpadBB

while.body2:
  %v = call i32 @getv()
  %mul = mul i32 %v, %v2
  invoke void @may_throw2()
  to label %while.cond unwind label %lpadBB
lpadBB:
  %.lcssa1 = phi i32 [ 0, %while.body ], [ %mul, %while.body2 ]
  landingpad { i8*, i32 }
  catch i8* null
  br label %lpadBBSucc1

lpadBBSucc1:
  ret void

try.cont:
  ret void
}

declare void @may_throw()
declare void @may_throw2()
declare i32 @__CxxFrameHandler3(...)
declare i32 @getv()
declare i1 @getc()
declare void @f(i32*)
declare void @g()
