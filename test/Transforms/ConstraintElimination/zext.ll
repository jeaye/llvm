; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -constraint-elimination -S %s | FileCheck %s

declare void @use(i1)

define void @uge_zext(i16 %x, i32 %y) {
; CHECK-LABEL: @uge_zext(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[X_EXT:%.*]] = zext i16 [[X:%.*]] to i32
; CHECK-NEXT:    [[C_1:%.*]] = icmp uge i32 [[X_EXT]], [[Y:%.*]]
; CHECK-NEXT:    br i1 [[C_1]], label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[T_1:%.*]] = icmp uge i32 [[X_EXT]], [[Y]]
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    [[C_2:%.*]] = icmp uge i32 [[X_EXT]], 10
; CHECK-NEXT:    call void @use(i1 [[C_2]])
; CHECK-NEXT:    [[C_3:%.*]] = icmp uge i32 [[Y]], [[X_EXT]]
; CHECK-NEXT:    call void @use(i1 [[C_3]])
; CHECK-NEXT:    [[C_4:%.*]] = icmp uge i32 10, [[X_EXT]]
; CHECK-NEXT:    call void @use(i1 [[C_4]])
; CHECK-NEXT:    ret void
; CHECK:       bb2:
; CHECK-NEXT:    [[T_2:%.*]] = icmp uge i32 [[Y]], [[X_EXT]]
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    [[F_1:%.*]] = icmp uge i32 [[X_EXT]], [[Y]]
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    [[C_5:%.*]] = icmp uge i32 [[X_EXT]], 10
; CHECK-NEXT:    call void @use(i1 [[C_5]])
; CHECK-NEXT:    [[C_6:%.*]] = icmp uge i32 10, [[X_EXT]]
; CHECK-NEXT:    call void @use(i1 [[C_6]])
; CHECK-NEXT:    ret void
;
entry:
  %x.ext = zext i16 %x to i32
  %c.1 = icmp uge i32 %x.ext, %y
  br i1 %c.1, label %bb1, label %bb2

bb1:
  %t.1 = icmp uge i32 %x.ext, %y
  call void @use(i1 %t.1)
  %c.2 = icmp uge i32 %x.ext, 10
  call void @use(i1 %c.2)
  %c.3 = icmp uge i32 %y, %x.ext
  call void @use(i1 %c.3)
  %c.4 = icmp uge i32 10, %x.ext
  call void @use(i1 %c.4)
  ret void

bb2:
  %t.2 = icmp uge i32 %y, %x.ext
  call void @use(i1 %t.2)
  %f.1 = icmp uge i32 %x.ext, %y
  call void @use(i1 %f.1)
  %c.5 = icmp uge i32 %x.ext, 10
  call void @use(i1 %c.5)
  %c.6 = icmp uge i32 10, %x.ext
  call void @use(i1 %c.6)
  ret void
}

define void @uge_compare_short_and_extended(i16 %x, i16 %y) {
; CHECK-LABEL: @uge_compare_short_and_extended(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C_1:%.*]] = icmp uge i16 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[X_EXT:%.*]] = zext i16 [[X]] to i32
; CHECK-NEXT:    [[Y_EXT:%.*]] = zext i16 [[Y]] to i32
; CHECK-NEXT:    br i1 [[C_1]], label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[T_1:%.*]] = icmp uge i32 [[X_EXT]], [[Y_EXT]]
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    [[C_2:%.*]] = icmp uge i32 [[X_EXT]], 10
; CHECK-NEXT:    call void @use(i1 [[C_2]])
; CHECK-NEXT:    [[C_3:%.*]] = icmp sge i32 [[Y_EXT]], [[X_EXT]]
; CHECK-NEXT:    call void @use(i1 [[C_3]])
; CHECK-NEXT:    [[C_4:%.*]] = icmp uge i32 10, [[X_EXT]]
; CHECK-NEXT:    call void @use(i1 [[C_4]])
; CHECK-NEXT:    ret void
; CHECK:       bb2:
; CHECK-NEXT:    [[T_2:%.*]] = icmp uge i32 [[Y_EXT]], [[X_EXT]]
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    [[F_1:%.*]] = icmp uge i32 [[X_EXT]], [[Y_EXT]]
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    [[C_5:%.*]] = icmp uge i32 [[X_EXT]], 10
; CHECK-NEXT:    call void @use(i1 [[C_5]])
; CHECK-NEXT:    [[C_6:%.*]] = icmp uge i32 10, [[X_EXT]]
; CHECK-NEXT:    call void @use(i1 [[C_6]])
; CHECK-NEXT:    ret void
;
entry:
  %c.1 = icmp uge i16 %x, %y
  %x.ext = zext i16 %x to i32
  %y.ext = zext i16 %y to i32
  br i1 %c.1, label %bb1, label %bb2

bb1:
  %t.1 = icmp uge i32 %x.ext, %y.ext
  call void @use(i1 %t.1)
  %c.2 = icmp uge i32 %x.ext, 10
  call void @use(i1 %c.2)
  %c.3 = icmp sge i32 %y.ext, %x.ext
  call void @use(i1 %c.3)
  %c.4 = icmp uge i32 10, %x.ext
  call void @use(i1 %c.4)
  ret void

bb2:
  %t.2 = icmp uge i32 %y.ext, %x.ext
  call void @use(i1 %t.2)
  %f.1 = icmp uge i32 %x.ext, %y.ext
  call void @use(i1 %f.1)
  %c.5 = icmp uge i32 %x.ext, 10
  call void @use(i1 %c.5)
  %c.6 = icmp uge i32 10, %x.ext
  call void @use(i1 %c.6)
  ret void
}

define void @uge_zext_add(i16 %x, i32 %y) {
; CHECK-LABEL: @uge_zext_add(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[X_ADD_1:%.*]] = add nuw nsw i16 [[X:%.*]], 1
; CHECK-NEXT:    [[X_ADD_1_EXT:%.*]] = zext i16 [[X_ADD_1]] to i32
; CHECK-NEXT:    [[X_EXT:%.*]] = zext i16 [[X]] to i32
; CHECK-NEXT:    [[C_1:%.*]] = icmp uge i32 [[X_ADD_1_EXT]], [[Y:%.*]]
; CHECK-NEXT:    br i1 [[C_1]], label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[T_1:%.*]] = icmp uge i32 [[X_EXT]], [[Y]]
; CHECK-NEXT:    call void @use(i1 [[T_1]])
; CHECK-NEXT:    [[C_2:%.*]] = icmp uge i32 [[X_EXT]], 10
; CHECK-NEXT:    call void @use(i1 [[C_2]])
; CHECK-NEXT:    [[C_3:%.*]] = icmp uge i32 [[Y]], [[X_EXT]]
; CHECK-NEXT:    call void @use(i1 [[C_3]])
; CHECK-NEXT:    [[C_4:%.*]] = icmp uge i32 10, [[X_EXT]]
; CHECK-NEXT:    call void @use(i1 [[C_4]])
; CHECK-NEXT:    ret void
; CHECK:       bb2:
; CHECK-NEXT:    [[T_2:%.*]] = icmp uge i32 [[Y]], [[X_EXT]]
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    [[F_1:%.*]] = icmp uge i32 [[X_EXT]], [[Y]]
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    [[C_5:%.*]] = icmp uge i32 [[X_EXT]], 10
; CHECK-NEXT:    call void @use(i1 [[C_5]])
; CHECK-NEXT:    [[C_6:%.*]] = icmp uge i32 10, [[X_EXT]]
; CHECK-NEXT:    call void @use(i1 [[C_6]])
; CHECK-NEXT:    ret void
;
entry:
  %x.add.1 = add nuw nsw i16 %x, 1
  %x.add.1.ext = zext i16 %x.add.1 to i32
  %x.ext = zext i16 %x to i32
  %c.1 = icmp uge i32 %x.add.1.ext, %y
  br i1 %c.1, label %bb1, label %bb2

bb1:
  %t.1 = icmp uge i32 %x.ext, %y
  call void @use(i1 %t.1)
  %c.2 = icmp uge i32 %x.ext, 10
  call void @use(i1 %c.2)
  %c.3 = icmp uge i32 %y, %x.ext
  call void @use(i1 %c.3)
  %c.4 = icmp uge i32 10, %x.ext
  call void @use(i1 %c.4)
  ret void

bb2:
  %t.2 = icmp uge i32 %y, %x.ext
  call void @use(i1 %t.2)
  %f.1 = icmp uge i32 %x.ext, %y
  call void @use(i1 %f.1)
  %c.5 = icmp uge i32 %x.ext, 10
  call void @use(i1 %c.5)
  %c.6 = icmp uge i32 10, %x.ext
  call void @use(i1 %c.6)
  ret void
}


define void @sge_zext(i16 %x, i32 %y) {
; CHECK-LABEL: @sge_zext(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[X_EXT:%.*]] = zext i16 [[X:%.*]] to i32
; CHECK-NEXT:    [[C_1:%.*]] = icmp sge i32 [[X_EXT]], [[Y:%.*]]
; CHECK-NEXT:    br i1 [[C_1]], label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[T_1:%.*]] = icmp sge i32 [[X_EXT]], [[Y]]
; CHECK-NEXT:    call void @use(i1 [[T_1]])
; CHECK-NEXT:    [[C_2:%.*]] = icmp sge i32 [[X_EXT]], 10
; CHECK-NEXT:    call void @use(i1 [[C_2]])
; CHECK-NEXT:    [[C_3:%.*]] = icmp sge i32 [[Y]], [[X_EXT]]
; CHECK-NEXT:    call void @use(i1 [[C_3]])
; CHECK-NEXT:    [[C_4:%.*]] = icmp sge i32 10, [[X_EXT]]
; CHECK-NEXT:    call void @use(i1 [[C_4]])
; CHECK-NEXT:    ret void
; CHECK:       bb2:
; CHECK-NEXT:    [[T_2:%.*]] = icmp sge i32 [[Y]], [[X_EXT]]
; CHECK-NEXT:    call void @use(i1 [[T_2]])
; CHECK-NEXT:    [[F_1:%.*]] = icmp sge i32 [[X_EXT]], [[Y]]
; CHECK-NEXT:    call void @use(i1 [[F_1]])
; CHECK-NEXT:    [[C_5:%.*]] = icmp sge i32 [[X_EXT]], 10
; CHECK-NEXT:    call void @use(i1 [[C_5]])
; CHECK-NEXT:    [[C_6:%.*]] = icmp sge i32 10, [[X_EXT]]
; CHECK-NEXT:    call void @use(i1 [[C_6]])
; CHECK-NEXT:    ret void
;
entry:
  %x.ext = zext i16 %x to i32
  %c.1 = icmp sge i32 %x.ext, %y
  br i1 %c.1, label %bb1, label %bb2

bb1:
  %t.1 = icmp sge i32 %x.ext, %y
  call void @use(i1 %t.1)
  %c.2 = icmp sge i32 %x.ext, 10
  call void @use(i1 %c.2)
  %c.3 = icmp sge i32 %y, %x.ext
  call void @use(i1 %c.3)
  %c.4 = icmp sge i32 10, %x.ext
  call void @use(i1 %c.4)
  ret void

bb2:
  %t.2 = icmp sge i32 %y, %x.ext
  call void @use(i1 %t.2)
  %f.1 = icmp sge i32 %x.ext, %y
  call void @use(i1 %f.1)
  %c.5 = icmp sge i32 %x.ext, 10
  call void @use(i1 %c.5)
  %c.6 = icmp sge i32 10, %x.ext
  call void @use(i1 %c.6)
  ret void
}


define void @sge_compare_short_and_extended(i16 %x, i16 %y) {
; CHECK-LABEL: @sge_compare_short_and_extended(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C_1:%.*]] = icmp sge i16 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[X_EXT:%.*]] = zext i16 [[X]] to i32
; CHECK-NEXT:    [[Y_EXT:%.*]] = zext i16 [[Y]] to i32
; CHECK-NEXT:    br i1 [[C_1]], label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[T_1:%.*]] = icmp sge i32 [[X_EXT]], [[Y_EXT]]
; CHECK-NEXT:    call void @use(i1 [[T_1]])
; CHECK-NEXT:    [[C_2:%.*]] = icmp sge i32 [[X_EXT]], 10
; CHECK-NEXT:    call void @use(i1 [[C_2]])
; CHECK-NEXT:    [[C_3:%.*]] = icmp sge i32 [[Y_EXT]], [[X_EXT]]
; CHECK-NEXT:    call void @use(i1 [[C_3]])
; CHECK-NEXT:    [[C_4:%.*]] = icmp sge i32 10, [[X_EXT]]
; CHECK-NEXT:    call void @use(i1 [[C_4]])
; CHECK-NEXT:    ret void
; CHECK:       bb2:
; CHECK-NEXT:    [[T_2:%.*]] = icmp sge i32 [[Y_EXT]], [[X_EXT]]
; CHECK-NEXT:    call void @use(i1 [[T_2]])
; CHECK-NEXT:    [[F_1:%.*]] = icmp sge i32 [[X_EXT]], [[Y_EXT]]
; CHECK-NEXT:    call void @use(i1 [[F_1]])
; CHECK-NEXT:    [[C_5:%.*]] = icmp sge i32 [[X_EXT]], 10
; CHECK-NEXT:    call void @use(i1 [[C_5]])
; CHECK-NEXT:    [[C_6:%.*]] = icmp sge i32 10, [[X_EXT]]
; CHECK-NEXT:    call void @use(i1 [[C_6]])
; CHECK-NEXT:    ret void
;
entry:
  %c.1 = icmp sge i16 %x, %y
  %x.ext = zext i16 %x to i32
  %y.ext = zext i16 %y to i32
  br i1 %c.1, label %bb1, label %bb2

bb1:
  %t.1 = icmp sge i32 %x.ext, %y.ext
  call void @use(i1 %t.1)
  %c.2 = icmp sge i32 %x.ext, 10
  call void @use(i1 %c.2)
  %c.3 = icmp sge i32 %y.ext, %x.ext
  call void @use(i1 %c.3)
  %c.4 = icmp sge i32 10, %x.ext
  call void @use(i1 %c.4)
  ret void

bb2:
  %t.2 = icmp sge i32 %y.ext, %x.ext
  call void @use(i1 %t.2)
  %f.1 = icmp sge i32 %x.ext, %y.ext
  call void @use(i1 %f.1)
  %c.5 = icmp sge i32 %x.ext, 10
  call void @use(i1 %c.5)
  %c.6 = icmp sge i32 10, %x.ext
  call void @use(i1 %c.6)
  ret void
}
