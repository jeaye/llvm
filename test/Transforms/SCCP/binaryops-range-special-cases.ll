; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -ipsccp -S | FileCheck %s

declare void @use(i1)
define void @sdiv1_cmp_constants(i32 %x) {
; CHECK-LABEL: @sdiv1_cmp_constants(
; CHECK-NEXT:    [[D:%.*]] = sdiv i32 1, [[X:%.*]]
; CHECK-NEXT:    [[C_0:%.*]] = icmp slt i32 0, [[D]]
; CHECK-NEXT:    call void @use(i1 [[C_0]])
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    [[C_3:%.*]] = icmp eq i32 1, [[D]]
; CHECK-NEXT:    call void @use(i1 [[C_3]])
; CHECK-NEXT:    [[C_4:%.*]] = icmp eq i32 0, [[D]]
; CHECK-NEXT:    call void @use(i1 [[C_4]])
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    ret void
;
  %d = sdiv i32 1, %x
  %c.0 = icmp slt i32 0, %d
  call void @use(i1 %c.0)
  %c.1 = icmp slt i32 1, %d
  call void @use(i1 %c.1)
  %c.2 = icmp slt i32 2, %d
  call void @use(i1 %c.2)

  %c.3 = icmp eq i32 1, %d
  call void @use(i1 %c.3)
  %c.4 = icmp eq i32 0, %d
  call void @use(i1 %c.4)
  %c.5 = icmp eq i32 2, %d
  call void @use(i1 %c.5)

  ret void
}

define void @sdiv1_cmp_range_1(i32 %x, i1 %c) {
; CHECK-LABEL: @sdiv1_cmp_range_1(
; CHECK-NEXT:    br i1 [[C:%.*]], label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br label [[BB3:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    br label [[BB3]]
; CHECK:       bb3:
; CHECK-NEXT:    [[P:%.*]] = phi i32 [ 1, [[BB1]] ], [ 2, [[BB2]] ]
; CHECK-NEXT:    [[D:%.*]] = sdiv i32 1, [[X:%.*]]
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    [[C_1:%.*]] = icmp eq i32 [[P]], [[D]]
; CHECK-NEXT:    call void @use(i1 [[C_1]])
; CHECK-NEXT:    ret void
;
  br i1 %c, label %bb1, label %bb2
bb1:
  br label %bb3
bb2:
  br label %bb3

bb3:
  %p = phi i32 [1, %bb1], [2, %bb2]
  %d = sdiv i32 1, %x
  %c.0 = icmp slt i32 %p, %d
  call void @use(i1 %c.0)
  %c.1 = icmp eq i32 %p, %d
  call void @use(i1 %c.1)
  ret void
}


define void @sdiv1_cmp_range_2(i32 %x, i1 %c) {
; CHECK-LABEL: @sdiv1_cmp_range_2(
; CHECK-NEXT:    br i1 [[C:%.*]], label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br label [[BB3:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    br label [[BB3]]
; CHECK:       bb3:
; CHECK-NEXT:    [[P:%.*]] = phi i32 [ 3, [[BB1]] ], [ 2, [[BB2]] ]
; CHECK-NEXT:    [[D:%.*]] = sdiv i32 1, [[X:%.*]]
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    ret void
;
  br i1 %c, label %bb1, label %bb2
bb1:
  br label %bb3
bb2:
  br label %bb3

bb3:
  %p = phi i32 [3, %bb1], [2, %bb2]
  %d = sdiv i32 1, %x
  %c.0 = icmp slt i32 %p, %d
  call void @use(i1 %c.0)
  %c.1 = icmp eq i32 %p, %d
  call void @use(i1 %c.1)
  ret void
}

define void @urem_cmp_constants() {
; CHECK-LABEL: @urem_cmp_constants(
; CHECK-NEXT:    [[UREM_1:%.*]] = urem i16 12704, 12704
; CHECK-NEXT:    [[C_1:%.*]] = icmp eq i16 [[UREM_1]], 0
; CHECK-NEXT:    call void @use(i1 [[C_1]])
; CHECK-NEXT:    [[C_2:%.*]] = icmp eq i16 [[UREM_1]], 1
; CHECK-NEXT:    call void @use(i1 [[C_2]])
; CHECK-NEXT:    [[UREM_2:%.*]] = urem i16 12704, 3
; CHECK-NEXT:    [[C_3:%.*]] = icmp eq i16 [[UREM_2]], 2
; CHECK-NEXT:    call void @use(i1 [[C_3]])
; CHECK-NEXT:    [[C_4:%.*]] = icmp eq i16 [[UREM_2]], 1
; CHECK-NEXT:    call void @use(i1 [[C_4]])
; CHECK-NEXT:    [[UREM_3:%.*]] = urem i16 12704, 0
; CHECK-NEXT:    [[C_5:%.*]] = icmp eq i16 [[UREM_3]], 1
; CHECK-NEXT:    call void @use(i1 [[C_5]])
; CHECK-NEXT:    ret void
;
  %sel = select i1 false, i16 0, i16 12704
  %urem.1 = urem i16 %sel, 12704
  %c.1 = icmp eq i16 %urem.1, 0
  call void @use(i1 %c.1)
  %c.2 = icmp eq i16 %urem.1, 1
  call void @use(i1 %c.2)
  %urem.2 = urem i16 %sel, 3
  %c.3 = icmp eq i16 %urem.2, 2
  call void @use(i1 %c.3)
  %c.4 = icmp eq i16 %urem.2, 1
  call void @use(i1 %c.4)
  %urem.3 = urem i16 %sel, 0
  %c.5 = icmp eq i16 %urem.3, 1
  call void @use(i1 %c.5)
  ret void
}

define void @srem_cmp_constants() {
; CHECK-LABEL: @srem_cmp_constants(
; CHECK-NEXT:    [[SREM_1:%.*]] = srem i16 12704, 12704
; CHECK-NEXT:    [[C_1:%.*]] = icmp eq i16 [[SREM_1]], 0
; CHECK-NEXT:    call void @use(i1 [[C_1]])
; CHECK-NEXT:    [[C_2:%.*]] = icmp eq i16 [[SREM_1]], 1
; CHECK-NEXT:    call void @use(i1 [[C_2]])
; CHECK-NEXT:    [[SREM_2:%.*]] = srem i16 12704, 3
; CHECK-NEXT:    [[C_3:%.*]] = icmp eq i16 [[SREM_2]], 2
; CHECK-NEXT:    call void @use(i1 [[C_3]])
; CHECK-NEXT:    [[C_4:%.*]] = icmp eq i16 [[SREM_2]], 1
; CHECK-NEXT:    call void @use(i1 [[C_4]])
; CHECK-NEXT:    [[SREM_3:%.*]] = srem i16 12704, 0
; CHECK-NEXT:    [[C_5:%.*]] = icmp eq i16 [[SREM_3]], 1
; CHECK-NEXT:    call void @use(i1 [[C_5]])
; CHECK-NEXT:    ret void
;
  %sel = select i1 false, i16 0, i16 12704
  %srem.1 = srem i16 %sel, 12704
  %c.1 = icmp eq i16 %srem.1, 0
  call void @use(i1 %c.1)
  %c.2 = icmp eq i16 %srem.1, 1
  call void @use(i1 %c.2)
  %srem.2 = srem i16 %sel, 3
  %c.3 = icmp eq i16 %srem.2, 2
  call void @use(i1 %c.3)
  %c.4 = icmp eq i16 %srem.2, 1
  call void @use(i1 %c.4)
  %srem.3 = srem i16 %sel, 0
  %c.5 = icmp eq i16 %srem.3, 1
  call void @use(i1 %c.5)
  ret void
}
