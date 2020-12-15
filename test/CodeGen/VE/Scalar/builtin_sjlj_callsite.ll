; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=ve -exception-model sjlj | FileCheck %s
; RUN: llc < %s -mtriple=ve -exception-model sjlj -relocation-model pic | \
; RUN:     FileCheck %s -check-prefix=PIC

; Function Attrs: noinline nounwind optnone
define void @test_callsite() personality i32 (...)* @__gxx_personality_sj0 {
; CHECK-LABEL: test_callsite:
; CHECK:       # %bb.0:
; CHECK-NEXT:    st %s9, (, %s11)
; CHECK-NEXT:    st %s10, 8(, %s11)
; CHECK-NEXT:    or %s9, 0, %s11
; CHECK-NEXT:    lea %s11, -432(, %s11)
; CHECK-NEXT:    brge.l %s11, %s8, .LBB0_7
; CHECK-NEXT:  # %bb.6:
; CHECK-NEXT:    ld %s61, 24(, %s14)
; CHECK-NEXT:    or %s62, 0, %s0
; CHECK-NEXT:    lea %s63, 315
; CHECK-NEXT:    shm.l %s63, (%s61)
; CHECK-NEXT:    shm.l %s8, 8(%s61)
; CHECK-NEXT:    shm.l %s11, 16(%s61)
; CHECK-NEXT:    monc
; CHECK-NEXT:    or %s0, 0, %s62
; CHECK-NEXT:  .LBB0_7:
; CHECK-NEXT:    st %s18, 48(, %s9) # 8-byte Folded Spill
; CHECK-NEXT:    st %s19, 56(, %s9) # 8-byte Folded Spill
; CHECK-NEXT:    st %s20, 64(, %s9) # 8-byte Folded Spill
; CHECK-NEXT:    st %s21, 72(, %s9) # 8-byte Folded Spill
; CHECK-NEXT:    st %s22, 80(, %s9) # 8-byte Folded Spill
; CHECK-NEXT:    st %s23, 88(, %s9) # 8-byte Folded Spill
; CHECK-NEXT:    st %s24, 96(, %s9) # 8-byte Folded Spill
; CHECK-NEXT:    st %s25, 104(, %s9) # 8-byte Folded Spill
; CHECK-NEXT:    st %s26, 112(, %s9) # 8-byte Folded Spill
; CHECK-NEXT:    st %s27, 120(, %s9) # 8-byte Folded Spill
; CHECK-NEXT:    st %s28, 128(, %s9) # 8-byte Folded Spill
; CHECK-NEXT:    st %s29, 136(, %s9) # 8-byte Folded Spill
; CHECK-NEXT:    st %s30, 144(, %s9) # 8-byte Folded Spill
; CHECK-NEXT:    st %s31, 152(, %s9) # 8-byte Folded Spill
; CHECK-NEXT:    st %s32, 160(, %s9) # 8-byte Folded Spill
; CHECK-NEXT:    st %s33, 168(, %s9) # 8-byte Folded Spill
; CHECK-NEXT:    lea %s0, __gxx_personality_sj0@lo
; CHECK-NEXT:    and %s0, %s0, (32)0
; CHECK-NEXT:    lea.sl %s0, __gxx_personality_sj0@hi(, %s0)
; CHECK-NEXT:    st %s0, -56(, %s9)
; CHECK-NEXT:    lea %s0, GCC_except_table0@lo
; CHECK-NEXT:    and %s0, %s0, (32)0
; CHECK-NEXT:    lea.sl %s0, GCC_except_table0@hi(, %s0)
; CHECK-NEXT:    st %s0, -48(, %s9)
; CHECK-NEXT:    st %s9, -40(, %s9)
; CHECK-NEXT:    st %s11, -24(, %s9)
; CHECK-NEXT:    lea %s0, .LBB0_3@lo
; CHECK-NEXT:    and %s0, %s0, (32)0
; CHECK-NEXT:    lea.sl %s0, .LBB0_3@hi(, %s0)
; CHECK-NEXT:    st %s0, -32(, %s9)
; CHECK-NEXT:    or %s0, 1, (0)1
; CHECK-NEXT:    st %s0, -96(, %s9)
; CHECK-NEXT:    lea %s0, _Unwind_SjLj_Register@lo
; CHECK-NEXT:    and %s0, %s0, (32)0
; CHECK-NEXT:    lea.sl %s12, _Unwind_SjLj_Register@hi(, %s0)
; CHECK-NEXT:    lea %s0, -104(, %s9)
; CHECK-NEXT:    bsic %s10, (, %s12)
; CHECK-NEXT:  .Ltmp0:
; CHECK-NEXT:    lea %s0, f@lo
; CHECK-NEXT:    and %s0, %s0, (32)0
; CHECK-NEXT:    lea.sl %s12, f@hi(, %s0)
; CHECK-NEXT:    bsic %s10, (, %s12)
; CHECK-NEXT:  .Ltmp1:
; CHECK-NEXT:  .LBB0_2: # %try.cont
; CHECK-NEXT:    or %s0, -1, (0)1
; CHECK-NEXT:    st %s0, -96(, %s9)
; CHECK-NEXT:    lea %s0, _Unwind_SjLj_Unregister@lo
; CHECK-NEXT:    and %s0, %s0, (32)0
; CHECK-NEXT:    lea.sl %s18, _Unwind_SjLj_Unregister@hi(, %s0)
; CHECK-NEXT:    lea %s0, -192(, %s9)
; CHECK-NEXT:    or %s12, 0, %s18
; CHECK-NEXT:    bsic %s10, (, %s12)
; CHECK-NEXT:    lea %s0, -104(, %s9)
; CHECK-NEXT:    or %s12, 0, %s18
; CHECK-NEXT:    bsic %s10, (, %s12)
; CHECK-NEXT:    ld %s33, 168(, %s9) # 8-byte Folded Reload
; CHECK-NEXT:    ld %s32, 160(, %s9) # 8-byte Folded Reload
; CHECK-NEXT:    ld %s31, 152(, %s9) # 8-byte Folded Reload
; CHECK-NEXT:    ld %s30, 144(, %s9) # 8-byte Folded Reload
; CHECK-NEXT:    ld %s29, 136(, %s9) # 8-byte Folded Reload
; CHECK-NEXT:    ld %s28, 128(, %s9) # 8-byte Folded Reload
; CHECK-NEXT:    ld %s27, 120(, %s9) # 8-byte Folded Reload
; CHECK-NEXT:    ld %s26, 112(, %s9) # 8-byte Folded Reload
; CHECK-NEXT:    ld %s25, 104(, %s9) # 8-byte Folded Reload
; CHECK-NEXT:    ld %s24, 96(, %s9) # 8-byte Folded Reload
; CHECK-NEXT:    ld %s23, 88(, %s9) # 8-byte Folded Reload
; CHECK-NEXT:    ld %s22, 80(, %s9) # 8-byte Folded Reload
; CHECK-NEXT:    ld %s21, 72(, %s9) # 8-byte Folded Reload
; CHECK-NEXT:    ld %s20, 64(, %s9) # 8-byte Folded Reload
; CHECK-NEXT:    ld %s19, 56(, %s9) # 8-byte Folded Reload
; CHECK-NEXT:    ld %s18, 48(, %s9) # 8-byte Folded Reload
; CHECK-NEXT:    or %s11, 0, %s9
; CHECK-NEXT:    ld %s10, 8(, %s11)
; CHECK-NEXT:    ld %s9, (, %s11)
; CHECK-NEXT:    b.l.t (, %s10)
; CHECK-NEXT:  .LBB0_3:
; CHECK-NEXT:    ldl.zx %s0, -96(, %s9)
; CHECK-NEXT:    brgt.l 1, %s0, .LBB0_4
; CHECK-NEXT:  # %bb.5:
; CHECK-NEXT:    lea %s0, abort@lo
; CHECK-NEXT:    and %s0, %s0, (32)0
; CHECK-NEXT:    lea.sl %s0, abort@hi(, %s0)
; CHECK-NEXT:    bsic %s10, (, %s0)
; CHECK-NEXT:  .LBB0_4:
; CHECK-NEXT:    lea %s1, .LJTI0_0@lo
; CHECK-NEXT:    and %s1, %s1, (32)0
; CHECK-NEXT:    lea.sl %s1, .LJTI0_0@hi(, %s1)
; CHECK-NEXT:    sll %s0, %s0, 3
; CHECK-NEXT:    ld %s0, (%s0, %s1)
; CHECK-NEXT:    b.l.t (, %s0)
; CHECK-NEXT:  .LBB0_1: # %lpad
; CHECK-NEXT:  .Ltmp2:
; CHECK-NEXT:    ld %s0, -88(, %s9)
; CHECK-NEXT:    ld %s0, -80(, %s9)
; CHECK-NEXT:    br.l.t .LBB0_2
;
; PIC-LABEL: test_callsite:
; PIC:       # %bb.0:
; PIC-NEXT:    st %s9, (, %s11)
; PIC-NEXT:    st %s10, 8(, %s11)
; PIC-NEXT:    st %s15, 24(, %s11)
; PIC-NEXT:    st %s16, 32(, %s11)
; PIC-NEXT:    or %s9, 0, %s11
; PIC-NEXT:    lea %s11, -432(, %s11)
; PIC-NEXT:    brge.l %s11, %s8, .LBB0_7
; PIC-NEXT:  # %bb.6:
; PIC-NEXT:    ld %s61, 24(, %s14)
; PIC-NEXT:    or %s62, 0, %s0
; PIC-NEXT:    lea %s63, 315
; PIC-NEXT:    shm.l %s63, (%s61)
; PIC-NEXT:    shm.l %s8, 8(%s61)
; PIC-NEXT:    shm.l %s11, 16(%s61)
; PIC-NEXT:    monc
; PIC-NEXT:    or %s0, 0, %s62
; PIC-NEXT:  .LBB0_7:
; PIC-NEXT:    st %s18, 48(, %s9) # 8-byte Folded Spill
; PIC-NEXT:    st %s19, 56(, %s9) # 8-byte Folded Spill
; PIC-NEXT:    st %s20, 64(, %s9) # 8-byte Folded Spill
; PIC-NEXT:    st %s21, 72(, %s9) # 8-byte Folded Spill
; PIC-NEXT:    st %s22, 80(, %s9) # 8-byte Folded Spill
; PIC-NEXT:    st %s23, 88(, %s9) # 8-byte Folded Spill
; PIC-NEXT:    st %s24, 96(, %s9) # 8-byte Folded Spill
; PIC-NEXT:    st %s25, 104(, %s9) # 8-byte Folded Spill
; PIC-NEXT:    st %s26, 112(, %s9) # 8-byte Folded Spill
; PIC-NEXT:    st %s27, 120(, %s9) # 8-byte Folded Spill
; PIC-NEXT:    st %s28, 128(, %s9) # 8-byte Folded Spill
; PIC-NEXT:    st %s29, 136(, %s9) # 8-byte Folded Spill
; PIC-NEXT:    st %s30, 144(, %s9) # 8-byte Folded Spill
; PIC-NEXT:    st %s31, 152(, %s9) # 8-byte Folded Spill
; PIC-NEXT:    st %s32, 160(, %s9) # 8-byte Folded Spill
; PIC-NEXT:    st %s33, 168(, %s9) # 8-byte Folded Spill
; PIC-NEXT:    lea %s15, _GLOBAL_OFFSET_TABLE_@pc_lo(-24)
; PIC-NEXT:    and %s15, %s15, (32)0
; PIC-NEXT:    sic %s16
; PIC-NEXT:    lea.sl %s15, _GLOBAL_OFFSET_TABLE_@pc_hi(%s16, %s15)
; PIC-NEXT:    lea %s0, __gxx_personality_sj0@got_lo
; PIC-NEXT:    and %s0, %s0, (32)0
; PIC-NEXT:    lea.sl %s0, __gxx_personality_sj0@got_hi(, %s0)
; PIC-NEXT:    ld %s0, (%s0, %s15)
; PIC-NEXT:    st %s0, -56(, %s9)
; PIC-NEXT:    lea %s0, GCC_except_table0@gotoff_lo
; PIC-NEXT:    and %s0, %s0, (32)0
; PIC-NEXT:    lea.sl %s0, GCC_except_table0@gotoff_hi(%s0, %s15)
; PIC-NEXT:    st %s0, -48(, %s9)
; PIC-NEXT:    st %s9, -40(, %s9)
; PIC-NEXT:    st %s11, -24(, %s9)
; PIC-NEXT:    lea %s0, .LBB0_3@gotoff_lo
; PIC-NEXT:    and %s0, %s0, (32)0
; PIC-NEXT:    lea.sl %s0, .LBB0_3@gotoff_hi(%s0, %s15)
; PIC-NEXT:    st %s0, -32(, %s9)
; PIC-NEXT:    or %s0, 1, (0)1
; PIC-NEXT:    st %s0, -96(, %s9)
; PIC-NEXT:    lea %s12, _Unwind_SjLj_Register@plt_lo(-24)
; PIC-NEXT:    and %s12, %s12, (32)0
; PIC-NEXT:    sic %s16
; PIC-NEXT:    lea.sl %s12, _Unwind_SjLj_Register@plt_hi(%s16, %s12)
; PIC-NEXT:    lea %s0, -104(, %s9)
; PIC-NEXT:    bsic %s10, (, %s12)
; PIC-NEXT:  .Ltmp0:
; PIC-NEXT:    lea %s12, f@plt_lo(-24)
; PIC-NEXT:    and %s12, %s12, (32)0
; PIC-NEXT:    sic %s16
; PIC-NEXT:    lea.sl %s12, f@plt_hi(%s16, %s12)
; PIC-NEXT:    bsic %s10, (, %s12)
; PIC-NEXT:  .Ltmp1:
; PIC-NEXT:  .LBB0_2: # %try.cont
; PIC-NEXT:    or %s0, -1, (0)1
; PIC-NEXT:    st %s0, -96(, %s9)
; PIC-NEXT:    lea %s18, _Unwind_SjLj_Unregister@plt_lo(-24)
; PIC-NEXT:    and %s18, %s18, (32)0
; PIC-NEXT:    sic %s16
; PIC-NEXT:    lea.sl %s18, _Unwind_SjLj_Unregister@plt_hi(%s16, %s18)
; PIC-NEXT:    lea %s0, -192(, %s9)
; PIC-NEXT:    or %s12, 0, %s18
; PIC-NEXT:    bsic %s10, (, %s12)
; PIC-NEXT:    lea %s0, -104(, %s9)
; PIC-NEXT:    or %s12, 0, %s18
; PIC-NEXT:    bsic %s10, (, %s12)
; PIC-NEXT:    ld %s33, 168(, %s9) # 8-byte Folded Reload
; PIC-NEXT:    ld %s32, 160(, %s9) # 8-byte Folded Reload
; PIC-NEXT:    ld %s31, 152(, %s9) # 8-byte Folded Reload
; PIC-NEXT:    ld %s30, 144(, %s9) # 8-byte Folded Reload
; PIC-NEXT:    ld %s29, 136(, %s9) # 8-byte Folded Reload
; PIC-NEXT:    ld %s28, 128(, %s9) # 8-byte Folded Reload
; PIC-NEXT:    ld %s27, 120(, %s9) # 8-byte Folded Reload
; PIC-NEXT:    ld %s26, 112(, %s9) # 8-byte Folded Reload
; PIC-NEXT:    ld %s25, 104(, %s9) # 8-byte Folded Reload
; PIC-NEXT:    ld %s24, 96(, %s9) # 8-byte Folded Reload
; PIC-NEXT:    ld %s23, 88(, %s9) # 8-byte Folded Reload
; PIC-NEXT:    ld %s22, 80(, %s9) # 8-byte Folded Reload
; PIC-NEXT:    ld %s21, 72(, %s9) # 8-byte Folded Reload
; PIC-NEXT:    ld %s20, 64(, %s9) # 8-byte Folded Reload
; PIC-NEXT:    ld %s19, 56(, %s9) # 8-byte Folded Reload
; PIC-NEXT:    ld %s18, 48(, %s9) # 8-byte Folded Reload
; PIC-NEXT:    or %s11, 0, %s9
; PIC-NEXT:    ld %s16, 32(, %s11)
; PIC-NEXT:    ld %s15, 24(, %s11)
; PIC-NEXT:    ld %s10, 8(, %s11)
; PIC-NEXT:    ld %s9, (, %s11)
; PIC-NEXT:    b.l.t (, %s10)
; PIC-NEXT:  .LBB0_3:
; PIC-NEXT:    ldl.zx %s0, -96(, %s9)
; PIC-NEXT:    lea %s15, _GLOBAL_OFFSET_TABLE_@pc_lo(-24)
; PIC-NEXT:    and %s15, %s15, (32)0
; PIC-NEXT:    sic %s16
; PIC-NEXT:    lea.sl %s15, _GLOBAL_OFFSET_TABLE_@pc_hi(%s16, %s15)
; PIC-NEXT:    brgt.l 1, %s0, .LBB0_4
; PIC-NEXT:  # %bb.5:
; PIC-NEXT:    lea %s0, abort@plt_lo(-24)
; PIC-NEXT:    and %s0, %s0, (32)0
; PIC-NEXT:    sic %s16
; PIC-NEXT:    lea.sl %s0, abort@plt_hi(%s16, %s0)
; PIC-NEXT:    bsic %s10, (, %s0)
; PIC-NEXT:  .LBB0_4:
; PIC-NEXT:    lea %s1, .LJTI0_0@gotoff_lo
; PIC-NEXT:    and %s1, %s1, (32)0
; PIC-NEXT:    lea.sl %s1, .LJTI0_0@gotoff_hi(%s1, %s15)
; PIC-NEXT:    sll %s0, %s0, 2
; PIC-NEXT:    ldl.zx %s0, (%s0, %s1)
; PIC-NEXT:    lea %s1, test_callsite@gotoff_lo
; PIC-NEXT:    and %s1, %s1, (32)0
; PIC-NEXT:    lea.sl %s1, test_callsite@gotoff_hi(%s1, %s15)
; PIC-NEXT:    adds.l %s0, %s0, %s1
; PIC-NEXT:    b.l.t (, %s0)
; PIC-NEXT:  .LBB0_1: # %lpad
; PIC-NEXT:  .Ltmp2:
; PIC-NEXT:    ld %s0, -88(, %s9)
; PIC-NEXT:    ld %s0, -80(, %s9)
; PIC-NEXT:    br.l.t .LBB0_2
  %fn_context = alloca { i8*, i32, [4 x i32], i8*, i8*, [5 x i8*] }, align 4
  call void @llvm.eh.sjlj.callsite(i32 0)
  invoke void @f()
          to label %try.cont unwind label %lpad

lpad:                                             ; preds = %entry
  %1 = landingpad { i8*, i32 }
          cleanup
;;  %__data = getelementptr { i8*, i32, [4 x i32], i8*, i8*, [5 x i8*] }, { i8*, i32, [4 x i32], i8*, i8*, [5 x i8*] }* %fn_context, i32 0, i32 2
;;  %exception_gep = getelementptr [4 x i32], [4 x i32]* %__data, i32 0, i32 0
;;  %exn_val = load volatile i32, i32* %exception_gep, align 4
;;  %2 = inttoptr i32 %exn_val to i8*
;;  %exn_selector_gep = getelementptr [4 x i32], [4 x i32]* %__data, i32 0, i32 1
;;  %exn_selector_val = load volatile i32, i32* %exn_selector_gep, align 4
  br label %try.cont

try.cont:                                         ; preds = %lpad, %entry
  call void @_Unwind_SjLj_Unregister({ i8*, i32, [4 x i32], i8*, i8*, [5 x i8*] }* %fn_context)
  ret void
}

declare void @f()

declare i32 @__gxx_personality_sj0(...)

declare void @_Unwind_SjLj_Unregister({ i8*, i32, [4 x i32], i8*, i8*, [5 x i8*] }*)

; Function Attrs: nounwind readnone
declare void @llvm.eh.sjlj.callsite(i32)
