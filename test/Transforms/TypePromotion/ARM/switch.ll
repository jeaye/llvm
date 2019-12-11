; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -mtriple=arm -type-promotion -verify -S %s -o - | FileCheck %s

define void @truncate_source_phi_switch(i8* %memblock, i8* %store, i16 %arg) {
; CHECK-LABEL: @truncate_source_phi_switch(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[PRE:%.*]] = load i8, i8* [[MEMBLOCK:%.*]], align 1
; CHECK-NEXT:    [[TMP0:%.*]] = zext i8 [[PRE]] to i32
; CHECK-NEXT:    [[CONV:%.*]] = trunc i16 [[ARG:%.*]] to i8
; CHECK-NEXT:    [[TMP1:%.*]] = zext i8 [[CONV]] to i32
; CHECK-NEXT:    br label [[HEADER:%.*]]
; CHECK:       header:
; CHECK-NEXT:    [[PHI_0:%.*]] = phi i32 [ [[TMP0]], [[ENTRY:%.*]] ], [ [[COUNT:%.*]], [[LATCH:%.*]] ]
; CHECK-NEXT:    [[PHI_1:%.*]] = phi i32 [ [[TMP1]], [[ENTRY]] ], [ [[PHI_3:%.*]], [[LATCH]] ]
; CHECK-NEXT:    [[PHI_2:%.*]] = phi i32 [ 0, [[ENTRY]] ], [ [[COUNT]], [[LATCH]] ]
; CHECK-NEXT:    switch i32 [[PHI_0]], label [[DEFAULT:%.*]] [
; CHECK-NEXT:    i32 43, label [[FOR_INC_I:%.*]]
; CHECK-NEXT:    i32 45, label [[FOR_INC_I_I:%.*]]
; CHECK-NEXT:    ]
; CHECK:       for.inc.i:
; CHECK-NEXT:    [[XOR:%.*]] = xor i32 [[PHI_1]], 1
; CHECK-NEXT:    br label [[LATCH]]
; CHECK:       for.inc.i.i:
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[PHI_1]], 3
; CHECK-NEXT:    br label [[LATCH]]
; CHECK:       default:
; CHECK-NEXT:    [[SUB:%.*]] = sub i32 [[PHI_0]], 1
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ugt i32 [[SUB]], 4
; CHECK-NEXT:    br i1 [[CMP2]], label [[LATCH]], label [[EXIT:%.*]]
; CHECK:       latch:
; CHECK-NEXT:    [[PHI_3]] = phi i32 [ [[XOR]], [[FOR_INC_I]] ], [ [[AND]], [[FOR_INC_I_I]] ], [ [[PHI_2]], [[DEFAULT]] ]
; CHECK-NEXT:    [[COUNT]] = add nuw i32 [[PHI_2]], 1
; CHECK-NEXT:    [[TMP2:%.*]] = trunc i32 [[COUNT]] to i8
; CHECK-NEXT:    store i8 [[TMP2]], i8* [[STORE:%.*]], align 1
; CHECK-NEXT:    br label [[HEADER]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  %pre = load i8, i8* %memblock, align 1
  %conv = trunc i16 %arg to i8
  br label %header

header:
  %phi.0 = phi i8 [ %pre, %entry ], [ %count, %latch ]
  %phi.1 = phi i8 [ %conv, %entry ], [ %phi.3, %latch ]
  %phi.2 = phi i8 [ 0, %entry], [ %count, %latch ]
  switch i8 %phi.0, label %default [
  i8 43, label %for.inc.i
  i8 45, label %for.inc.i.i
  ]

for.inc.i:
  %xor = xor i8 %phi.1, 1
  br label %latch

for.inc.i.i:
  %and = and i8 %phi.1, 3
  br label %latch

default:
  %sub = sub i8 %phi.0, 1
  %cmp2 = icmp ugt i8 %sub, 4
  br i1 %cmp2, label %latch, label %exit

latch:
  %phi.3 = phi i8 [ %xor, %for.inc.i ], [ %and, %for.inc.i.i ], [ %phi.2, %default ]
  %count = add nuw i8 %phi.2, 1
  store i8 %count, i8* %store, align 1
  br label %header

exit:
  ret void
}

define i16 @icmp_switch_source(i16 zeroext %arg) {
; CHECK-LABEL: @icmp_switch_source(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = zext i16 [[ARG:%.*]] to i32
; CHECK-NEXT:    [[CONV:%.*]] = add nuw i32 [[TMP0]], 15
; CHECK-NEXT:    [[MUL:%.*]] = mul nuw nsw i32 [[CONV]], 3
; CHECK-NEXT:    switch i32 [[TMP0]], label [[DEFAULT:%.*]] [
; CHECK-NEXT:    i32 0, label [[SW_BB:%.*]]
; CHECK-NEXT:    i32 1, label [[SW_BB_I:%.*]]
; CHECK-NEXT:    ]
; CHECK:       sw.bb:
; CHECK-NEXT:    [[CMP0:%.*]] = icmp ult i32 [[MUL]], 127
; CHECK-NEXT:    [[SELECT:%.*]] = select i1 [[CMP0]], i32 [[MUL]], i32 127
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       sw.bb.i:
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ugt i32 [[MUL]], 34
; CHECK-NEXT:    [[SELECT_I:%.*]] = select i1 [[CMP1]], i32 [[MUL]], i32 34
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       default:
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    [[RES:%.*]] = phi i32 [ [[SELECT]], [[SW_BB]] ], [ [[SELECT_I]], [[SW_BB_I]] ], [ [[MUL]], [[DEFAULT]] ]
; CHECK-NEXT:    [[TMP1:%.*]] = trunc i32 [[RES]] to i16
; CHECK-NEXT:    ret i16 [[TMP1]]
;
entry:
  %conv = add nuw i16 %arg, 15
  %mul = mul nuw nsw i16 %conv, 3
  switch i16 %arg, label %default [
  i16 0, label %sw.bb
  i16 1, label %sw.bb.i
  ]

sw.bb:
  %cmp0 = icmp ult i16 %mul, 127
  %select = select i1 %cmp0, i16 %mul, i16 127
  br label %exit

sw.bb.i:
  %cmp1 = icmp ugt i16 %mul, 34
  %select.i = select i1 %cmp1, i16 %mul, i16 34
  br label %exit

default:
  br label %exit

exit:
  %res = phi i16 [ %select, %sw.bb ], [ %select.i, %sw.bb.i ], [ %mul, %default ]
  ret i16 %res
}

define i16 @icmp_switch_narrow_source(i8 zeroext %arg) {
; CHECK-LABEL: @icmp_switch_narrow_source(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = zext i8 [[ARG:%.*]] to i32
; CHECK-NEXT:    [[ADD:%.*]] = add nuw i32 [[TMP0]], 15
; CHECK-NEXT:    [[MUL:%.*]] = mul nuw nsw i32 [[ADD]], 3
; CHECK-NEXT:    [[TMP1:%.*]] = trunc i32 [[TMP0]] to i8
; CHECK-NEXT:    switch i8 [[TMP1]], label [[DEFAULT:%.*]] [
; CHECK-NEXT:    i8 0, label [[SW_BB:%.*]]
; CHECK-NEXT:    i8 1, label [[SW_BB_I:%.*]]
; CHECK-NEXT:    ]
; CHECK:       sw.bb:
; CHECK-NEXT:    [[CMP0:%.*]] = icmp ult i32 [[MUL]], 127
; CHECK-NEXT:    [[SELECT:%.*]] = select i1 [[CMP0]], i32 [[MUL]], i32 127
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       sw.bb.i:
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ugt i32 [[MUL]], 34
; CHECK-NEXT:    [[SELECT_I:%.*]] = select i1 [[CMP1]], i32 [[MUL]], i32 34
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       default:
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    [[RES:%.*]] = phi i32 [ [[SELECT]], [[SW_BB]] ], [ [[SELECT_I]], [[SW_BB_I]] ], [ [[MUL]], [[DEFAULT]] ]
; CHECK-NEXT:    [[TMP2:%.*]] = trunc i32 [[RES]] to i16
; CHECK-NEXT:    ret i16 [[TMP2]]
;
entry:
  %conv = zext i8 %arg to i16
  %add = add nuw i16 %conv, 15
  %mul = mul nuw nsw i16 %add, 3
  switch i8 %arg, label %default [
  i8 0, label %sw.bb
  i8 1, label %sw.bb.i
  ]

sw.bb:
  %cmp0 = icmp ult i16 %mul, 127
  %select = select i1 %cmp0, i16 %mul, i16 127
  br label %exit

sw.bb.i:
  %cmp1 = icmp ugt i16 %mul, 34
  %select.i = select i1 %cmp1, i16 %mul, i16 34
  br label %exit

default:
  br label %exit

exit:
  %res = phi i16 [ %select, %sw.bb ], [ %select.i, %sw.bb.i ], [ %mul, %default ]
  ret i16 %res
}

define i16 @icmp_switch_trunc(i16 zeroext %arg) {
; CHECK-LABEL: @icmp_switch_trunc(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = zext i16 [[ARG:%.*]] to i32
; CHECK-NEXT:    [[CONV:%.*]] = add nuw i32 [[TMP0]], 15
; CHECK-NEXT:    [[MUL:%.*]] = mul nuw nsw i32 [[CONV]], 3
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 [[TMP0]], 7
; CHECK-NEXT:    [[TMP2:%.*]] = trunc i32 [[TMP1]] to i3
; CHECK-NEXT:    switch i3 [[TMP2]], label [[DEFAULT:%.*]] [
; CHECK-NEXT:    i3 0, label [[SW_BB:%.*]]
; CHECK-NEXT:    i3 1, label [[SW_BB_I:%.*]]
; CHECK-NEXT:    ]
; CHECK:       sw.bb:
; CHECK-NEXT:    [[CMP0:%.*]] = icmp ult i32 [[MUL]], 127
; CHECK-NEXT:    [[SELECT:%.*]] = select i1 [[CMP0]], i32 [[MUL]], i32 127
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       sw.bb.i:
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ugt i32 [[MUL]], 34
; CHECK-NEXT:    [[SELECT_I:%.*]] = select i1 [[CMP1]], i32 [[MUL]], i32 34
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       default:
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    [[RES:%.*]] = phi i32 [ [[SELECT]], [[SW_BB]] ], [ [[SELECT_I]], [[SW_BB_I]] ], [ [[MUL]], [[DEFAULT]] ]
; CHECK-NEXT:    [[TMP3:%.*]] = trunc i32 [[RES]] to i16
; CHECK-NEXT:    ret i16 [[TMP3]]
;
entry:
  %conv = add nuw i16 %arg, 15
  %mul = mul nuw nsw i16 %conv, 3
  %trunc = trunc i16 %arg to i3
  switch i3 %trunc, label %default [
  i3 0, label %sw.bb
  i3 1, label %sw.bb.i
  ]

sw.bb:
  %cmp0 = icmp ult i16 %mul, 127
  %select = select i1 %cmp0, i16 %mul, i16 127
  br label %exit

sw.bb.i:
  %cmp1 = icmp ugt i16 %mul, 34
  %select.i = select i1 %cmp1, i16 %mul, i16 34
  br label %exit

default:
  br label %exit

exit:
  %res = phi i16 [ %select, %sw.bb ], [ %select.i, %sw.bb.i ], [ %mul, %default ]
  ret i16 %res
}

%class.ae = type { i8 }
%class.x = type { i8 }
%class.v = type { %class.q }
%class.q = type { i16 }
declare %class.x* @_ZNK2ae2afEv(%class.ae*) local_unnamed_addr
declare %class.v* @_ZN1x2acEv(%class.x*) local_unnamed_addr

define i32 @trunc_i16_i9_switch(%class.ae* %this) {
; CHECK-LABEL: @trunc_i16_i9_switch(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CALL:%.*]] = tail call %class.x* @_ZNK2ae2afEv(%class.ae* [[THIS:%.*]])
; CHECK-NEXT:    [[CALL2:%.*]] = tail call %class.v* @_ZN1x2acEv(%class.x* [[CALL]])
; CHECK-NEXT:    [[TMP0:%.*]] = getelementptr inbounds [[CLASS_V:%.*]], %class.v* [[CALL2]], i32 0, i32 0, i32 0
; CHECK-NEXT:    [[TMP1:%.*]] = load i16, i16* [[TMP0]], align 2
; CHECK-NEXT:    [[TMP2:%.*]] = zext i16 [[TMP1]] to i32
; CHECK-NEXT:    [[TMP3:%.*]] = and i32 [[TMP2]], 511
; CHECK-NEXT:    [[TRUNC:%.*]] = and i32 [[TMP3]], 448
; CHECK-NEXT:    [[TMP4:%.*]] = trunc i32 [[TRUNC]] to i9
; CHECK-NEXT:    switch i9 [[TMP4]], label [[CLEANUP_FOLD_SPLIT:%.*]] [
; CHECK-NEXT:    i9 0, label [[CLEANUP:%.*]]
; CHECK-NEXT:    i9 -256, label [[IF_THEN7:%.*]]
; CHECK-NEXT:    ]
; CHECK:       if.then7:
; CHECK-NEXT:    [[TMP5:%.*]] = and i32 [[TMP2]], 7
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp eq i32 [[TMP5]], 0
; CHECK-NEXT:    [[COND:%.*]] = select i1 [[TOBOOL]], i32 2, i32 1
; CHECK-NEXT:    br label [[CLEANUP]]
; CHECK:       cleanup.fold.split:
; CHECK-NEXT:    br label [[CLEANUP]]
; CHECK:       cleanup:
; CHECK-NEXT:    [[RETVAL_0:%.*]] = phi i32 [ [[COND]], [[IF_THEN7]] ], [ 0, [[ENTRY:%.*]] ], [ 2, [[CLEANUP_FOLD_SPLIT]] ]
; CHECK-NEXT:    ret i32 [[RETVAL_0]]
;
entry:
  %call = tail call %class.x* @_ZNK2ae2afEv(%class.ae* %this)
  %call2 = tail call %class.v* @_ZN1x2acEv(%class.x* %call)
  %0 = getelementptr inbounds %class.v, %class.v* %call2, i32 0, i32 0, i32 0
  %1 = load i16, i16* %0, align 2
  %2 = trunc i16 %1 to i9
  %trunc = and i9 %2, -64
  switch i9 %trunc, label %cleanup.fold.split [
  i9 0, label %cleanup
  i9 -256, label %if.then7
  ]

if.then7:
  %3 = and i16 %1, 7
  %tobool = icmp eq i16 %3, 0
  %cond = select i1 %tobool, i32 2, i32 1
  br label %cleanup

cleanup.fold.split:
  br label %cleanup

cleanup:
  %retval.0 = phi i32 [ %cond, %if.then7 ], [ 0, %entry ], [ 2, %cleanup.fold.split ]
  ret i32 %retval.0
}
