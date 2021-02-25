; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --check-attributes
; RUN: opt -indvars -S %s | FileCheck %s

; Test cases inspired by PR48965.

; %len is zero-extended before being used to compute %p.end, which guarantees
; the offset is positive. %i.ult.ext can be simplified.
define i1 @can_simplify_ult_i32_ptr_len_zext(i32* %p.base, i32 %len) {
; CHECK-LABEL: @can_simplify_ult_i32_ptr_len_zext(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[EXT:%.*]] = zext i32 [[LEN:%.*]] to i64
; CHECK-NEXT:    [[P_END:%.*]] = getelementptr inbounds i32, i32* [[P_BASE:%.*]], i64 [[EXT]]
; CHECK-NEXT:    [[LEN_NONZERO:%.*]] = icmp ne i32 [[LEN]], 0
; CHECK-NEXT:    br i1 [[LEN_NONZERO]], label [[HEADER_PREHEADER:%.*]], label [[TRAP:%.*]]
; CHECK:       header.preheader:
; CHECK-NEXT:    br label [[HEADER:%.*]]
; CHECK:       trap.loopexit:
; CHECK-NEXT:    br label [[TRAP]]
; CHECK:       trap:
; CHECK-NEXT:    ret i1 false
; CHECK:       header:
; CHECK-NEXT:    [[P:%.*]] = phi i32* [ [[P_INC:%.*]], [[LATCH:%.*]] ], [ [[P_BASE]], [[HEADER_PREHEADER]] ]
; CHECK-NEXT:    [[I:%.*]] = phi i64 [ [[I_INC:%.*]], [[LATCH]] ], [ 0, [[HEADER_PREHEADER]] ]
; CHECK-NEXT:    [[I_INC]] = add nuw nsw i64 [[I]], 1
; CHECK-NEXT:    [[I_ULT_EXT:%.*]] = icmp ult i64 [[I]], [[EXT]]
; CHECK-NEXT:    br i1 [[I_ULT_EXT]], label [[LATCH]], label [[TRAP_LOOPEXIT:%.*]]
; CHECK:       latch:
; CHECK-NEXT:    [[P_INC]] = getelementptr inbounds i32, i32* [[P]], i64 1
; CHECK-NEXT:    [[C:%.*]] = icmp ne i32* [[P_INC]], [[P_END]]
; CHECK-NEXT:    store i32 0, i32* [[P]], align 4
; CHECK-NEXT:    br i1 [[C]], label [[HEADER]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret i1 true
;
entry:
  %ext = zext i32 %len to i64
  %p.end = getelementptr inbounds i32, i32* %p.base, i64 %ext
  %len.nonzero = icmp ne i32 %len, 0
  br i1 %len.nonzero, label %header, label %trap

trap:
  ret i1 false

header:
  %p = phi i32* [ %p.base, %entry ], [ %p.inc, %latch ]
  %i = phi i64 [ 0, %entry ], [ %i.inc, %latch]
  %i.inc = add nsw nuw i64 %i, 1
  %i.ult.ext = icmp ult i64 %i, %ext
  br i1 %i.ult.ext, label %latch, label %trap

latch:
  %p.inc = getelementptr inbounds i32, i32* %p, i64 1
  %c = icmp ne i32* %p.inc, %p.end
  store i32 0, i32* %p
  br i1 %c, label %header, label %exit

exit:
  ret i1 true
}

; %len may be (signed) negative, %i.ult.ext cannot be simplified.
define i1 @cannot_simplify_ult_i32_ptr_len_ult(i32* %p.base, i64 %len) {
; CHECK-LABEL: @cannot_simplify_ult_i32_ptr_len_ult(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[P_END:%.*]] = getelementptr inbounds i32, i32* [[P_BASE:%.*]], i64 [[LEN:%.*]]
; CHECK-NEXT:    [[LEN_NONZERO:%.*]] = icmp ne i64 [[LEN]], 0
; CHECK-NEXT:    br i1 [[LEN_NONZERO]], label [[HEADER_PREHEADER:%.*]], label [[TRAP:%.*]]
; CHECK:       header.preheader:
; CHECK-NEXT:    br label [[HEADER:%.*]]
; CHECK:       trap.loopexit:
; CHECK-NEXT:    br label [[TRAP]]
; CHECK:       trap:
; CHECK-NEXT:    ret i1 false
; CHECK:       header:
; CHECK-NEXT:    [[P:%.*]] = phi i32* [ [[P_INC:%.*]], [[LATCH:%.*]] ], [ [[P_BASE]], [[HEADER_PREHEADER]] ]
; CHECK-NEXT:    [[I:%.*]] = phi i64 [ [[I_INC:%.*]], [[LATCH]] ], [ 0, [[HEADER_PREHEADER]] ]
; CHECK-NEXT:    [[I_INC]] = add nuw nsw i64 [[I]], 1
; CHECK-NEXT:    [[I_ULT_EXT:%.*]] = icmp ult i64 [[I]], [[LEN]]
; CHECK-NEXT:    br i1 [[I_ULT_EXT]], label [[LATCH]], label [[TRAP_LOOPEXIT:%.*]]
; CHECK:       latch:
; CHECK-NEXT:    [[P_INC]] = getelementptr inbounds i32, i32* [[P]], i64 1
; CHECK-NEXT:    [[C:%.*]] = icmp ne i32* [[P_INC]], [[P_END]]
; CHECK-NEXT:    store i32 0, i32* [[P]], align 4
; CHECK-NEXT:    br i1 [[C]], label [[HEADER]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret i1 true
;
entry:
  %p.end = getelementptr inbounds i32, i32* %p.base, i64 %len
  %len.nonzero = icmp ne i64 %len, 0
  br i1 %len.nonzero, label %header, label %trap

trap:
  ret i1 false

header:
  %p = phi i32* [ %p.base, %entry ], [ %p.inc, %latch ]
  %i = phi i64 [ 0, %entry ], [ %i.inc, %latch]
  %i.inc = add nsw nuw i64 %i, 1
  %i.ult.ext = icmp ult i64 %i, %len
  br i1 %i.ult.ext, label %latch, label %trap

latch:
  %p.inc = getelementptr inbounds i32, i32* %p, i64 1
  %c = icmp ne i32* %p.inc, %p.end
  store i32 0, i32* %p
  br i1 %c, label %header, label %exit

exit:
  ret i1 true
}

; Similar to can_simplify_ult_i32_ptr_len_zext, but %i has 1 as start value. %i.ult.ext cannot be simplified.
define i1 @cannot_simplify_ult_i32_ptr_len_zext(i32* %p.base, i32 %len) {
; CHECK-LABEL: @cannot_simplify_ult_i32_ptr_len_zext(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[EXT:%.*]] = zext i32 [[LEN:%.*]] to i64
; CHECK-NEXT:    [[P_END:%.*]] = getelementptr inbounds i32, i32* [[P_BASE:%.*]], i64 [[EXT]]
; CHECK-NEXT:    [[LEN_NONZERO:%.*]] = icmp ne i32 [[LEN]], 0
; CHECK-NEXT:    br i1 [[LEN_NONZERO]], label [[HEADER_PREHEADER:%.*]], label [[TRAP:%.*]]
; CHECK:       header.preheader:
; CHECK-NEXT:    br label [[HEADER:%.*]]
; CHECK:       trap.loopexit:
; CHECK-NEXT:    br label [[TRAP]]
; CHECK:       trap:
; CHECK-NEXT:    ret i1 false
; CHECK:       header:
; CHECK-NEXT:    [[P:%.*]] = phi i32* [ [[P_INC:%.*]], [[LATCH:%.*]] ], [ [[P_BASE]], [[HEADER_PREHEADER]] ]
; CHECK-NEXT:    [[I:%.*]] = phi i64 [ [[I_INC:%.*]], [[LATCH]] ], [ 1, [[HEADER_PREHEADER]] ]
; CHECK-NEXT:    [[I_INC]] = add nuw nsw i64 [[I]], 1
; CHECK-NEXT:    [[I_ULT_EXT:%.*]] = icmp ult i64 [[I]], [[EXT]]
; CHECK-NEXT:    br i1 [[I_ULT_EXT]], label [[LATCH]], label [[TRAP_LOOPEXIT:%.*]]
; CHECK:       latch:
; CHECK-NEXT:    [[P_INC]] = getelementptr inbounds i32, i32* [[P]], i64 1
; CHECK-NEXT:    [[C:%.*]] = icmp ne i32* [[P_INC]], [[P_END]]
; CHECK-NEXT:    store i32 0, i32* [[P]], align 4
; CHECK-NEXT:    br i1 [[C]], label [[HEADER]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret i1 true
;
entry:
  %ext = zext i32 %len to i64
  %p.end = getelementptr inbounds i32, i32* %p.base, i64 %ext
  %len.nonzero = icmp ne i32 %len, 0
  br i1 %len.nonzero, label %header, label %trap

trap:
  ret i1 false

header:
  %p = phi i32* [ %p.base, %entry ], [ %p.inc, %latch ]
  %i = phi i64 [ 1, %entry ], [ %i.inc, %latch]
  %i.inc = add nsw nuw i64 %i, 1
  %i.ult.ext = icmp ult i64 %i, %ext
  br i1 %i.ult.ext, label %latch, label %trap

latch:
  %p.inc = getelementptr inbounds i32, i32* %p, i64 1
  %c = icmp ne i32* %p.inc, %p.end
  store i32 0, i32* %p
  br i1 %c, label %header, label %exit

exit:
  ret i1 true
}

define i1 @can_simplify_ule_i32_ptr_len_zext(i32* %p.base, i32 %len) {
; CHECK-LABEL: @can_simplify_ule_i32_ptr_len_zext(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[EXT:%.*]] = zext i32 [[LEN:%.*]] to i64
; CHECK-NEXT:    [[P_END:%.*]] = getelementptr inbounds i32, i32* [[P_BASE:%.*]], i64 [[EXT]]
; CHECK-NEXT:    [[LEN_NONZERO:%.*]] = icmp ne i32 [[LEN]], 0
; CHECK-NEXT:    br i1 [[LEN_NONZERO]], label [[HEADER_PREHEADER:%.*]], label [[TRAP:%.*]]
; CHECK:       header.preheader:
; CHECK-NEXT:    br label [[HEADER:%.*]]
; CHECK:       trap.loopexit:
; CHECK-NEXT:    br label [[TRAP]]
; CHECK:       trap:
; CHECK-NEXT:    ret i1 false
; CHECK:       header:
; CHECK-NEXT:    [[P:%.*]] = phi i32* [ [[P_INC:%.*]], [[LATCH:%.*]] ], [ [[P_BASE]], [[HEADER_PREHEADER]] ]
; CHECK-NEXT:    [[I:%.*]] = phi i64 [ [[I_INC:%.*]], [[LATCH]] ], [ 1, [[HEADER_PREHEADER]] ]
; CHECK-NEXT:    [[I_INC]] = add nuw nsw i64 [[I]], 1
; CHECK-NEXT:    [[I_ULT_EXT:%.*]] = icmp ule i64 [[I]], [[EXT]]
; CHECK-NEXT:    br i1 [[I_ULT_EXT]], label [[LATCH]], label [[TRAP_LOOPEXIT:%.*]]
; CHECK:       latch:
; CHECK-NEXT:    [[P_INC]] = getelementptr inbounds i32, i32* [[P]], i64 1
; CHECK-NEXT:    [[C:%.*]] = icmp ne i32* [[P_INC]], [[P_END]]
; CHECK-NEXT:    store i32 0, i32* [[P]], align 4
; CHECK-NEXT:    br i1 [[C]], label [[HEADER]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret i1 true
;
entry:
  %ext = zext i32 %len to i64
  %p.end = getelementptr inbounds i32, i32* %p.base, i64 %ext
  %len.nonzero = icmp ne i32 %len, 0
  br i1 %len.nonzero, label %header, label %trap

trap:
  ret i1 false

header:
  %p = phi i32* [ %p.base, %entry ], [ %p.inc, %latch ]
  %i = phi i64 [ 1, %entry ], [ %i.inc, %latch]
  %i.inc = add nsw nuw i64 %i, 1
  %i.ult.ext = icmp ule i64 %i, %ext
  br i1 %i.ult.ext, label %latch, label %trap

latch:
  %p.inc = getelementptr inbounds i32, i32* %p, i64 1
  %c = icmp ne i32* %p.inc, %p.end
  store i32 0, i32* %p
  br i1 %c, label %header, label %exit

exit:
  ret i1 true
}

; %len is zero-extended before being used to compute %p.end, which guarantees
; the offset is positive. %i.uge.ext can be simplified.
define i1 @can_simplify_uge_i32_ptr_len_zext(i32* %p.base, i32 %len) {
; CHECK-LABEL: @can_simplify_uge_i32_ptr_len_zext(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[EXT:%.*]] = zext i32 [[LEN:%.*]] to i64
; CHECK-NEXT:    [[P_END:%.*]] = getelementptr inbounds i32, i32* [[P_BASE:%.*]], i64 [[EXT]]
; CHECK-NEXT:    [[LEN_NONZERO:%.*]] = icmp ne i32 [[LEN]], 0
; CHECK-NEXT:    br i1 [[LEN_NONZERO]], label [[HEADER_PREHEADER:%.*]], label [[TRAP:%.*]]
; CHECK:       header.preheader:
; CHECK-NEXT:    br label [[HEADER:%.*]]
; CHECK:       trap.loopexit:
; CHECK-NEXT:    br label [[TRAP]]
; CHECK:       trap:
; CHECK-NEXT:    ret i1 false
; CHECK:       header:
; CHECK-NEXT:    [[P:%.*]] = phi i32* [ [[P_INC:%.*]], [[LATCH:%.*]] ], [ [[P_BASE]], [[HEADER_PREHEADER]] ]
; CHECK-NEXT:    [[I:%.*]] = phi i64 [ [[I_INC:%.*]], [[LATCH]] ], [ 0, [[HEADER_PREHEADER]] ]
; CHECK-NEXT:    [[I_INC]] = add nuw nsw i64 [[I]], 1
; CHECK-NEXT:    [[I_UGE_EXT:%.*]] = icmp uge i64 [[I]], [[EXT]]
; CHECK-NEXT:    br i1 [[I_UGE_EXT]], label [[TRAP_LOOPEXIT:%.*]], label [[LATCH]]
; CHECK:       latch:
; CHECK-NEXT:    [[P_INC]] = getelementptr inbounds i32, i32* [[P]], i64 1
; CHECK-NEXT:    [[C:%.*]] = icmp ne i32* [[P_INC]], [[P_END]]
; CHECK-NEXT:    store i32 0, i32* [[P]], align 4
; CHECK-NEXT:    br i1 [[C]], label [[HEADER]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret i1 true
;
entry:
  %ext = zext i32 %len to i64
  %p.end = getelementptr inbounds i32, i32* %p.base, i64 %ext
  %len.nonzero = icmp ne i32 %len, 0
  br i1 %len.nonzero, label %header, label %trap

trap:
  ret i1 false

header:
  %p = phi i32* [ %p.base, %entry ], [ %p.inc, %latch ]
  %i = phi i64 [ 0, %entry ], [ %i.inc, %latch]
  %i.inc = add nsw nuw i64 %i, 1
  %i.uge.ext = icmp uge i64 %i, %ext
  br i1 %i.uge.ext, label %trap, label %latch

latch:
  %p.inc = getelementptr inbounds i32, i32* %p, i64 1
  %c = icmp ne i32* %p.inc, %p.end
  store i32 0, i32* %p
  br i1 %c, label %header, label %exit

exit:
  ret i1 true
}

define i1 @cannot_simplify_uge_i32_ptr_len(i32* %p.base, i64 %len) {
; CHECK-LABEL: @cannot_simplify_uge_i32_ptr_len(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[P_END:%.*]] = getelementptr inbounds i32, i32* [[P_BASE:%.*]], i64 [[LEN:%.*]]
; CHECK-NEXT:    [[LEN_NONZERO:%.*]] = icmp ne i64 [[LEN]], 0
; CHECK-NEXT:    br i1 [[LEN_NONZERO]], label [[HEADER_PREHEADER:%.*]], label [[TRAP:%.*]]
; CHECK:       header.preheader:
; CHECK-NEXT:    br label [[HEADER:%.*]]
; CHECK:       trap.loopexit:
; CHECK-NEXT:    br label [[TRAP]]
; CHECK:       trap:
; CHECK-NEXT:    ret i1 false
; CHECK:       header:
; CHECK-NEXT:    [[P:%.*]] = phi i32* [ [[P_INC:%.*]], [[LATCH:%.*]] ], [ [[P_BASE]], [[HEADER_PREHEADER]] ]
; CHECK-NEXT:    [[I:%.*]] = phi i64 [ [[I_INC:%.*]], [[LATCH]] ], [ 0, [[HEADER_PREHEADER]] ]
; CHECK-NEXT:    [[I_INC]] = add nuw nsw i64 [[I]], 1
; CHECK-NEXT:    [[I_UGE_EXT:%.*]] = icmp uge i64 [[I]], [[LEN]]
; CHECK-NEXT:    br i1 [[I_UGE_EXT]], label [[TRAP_LOOPEXIT:%.*]], label [[LATCH]]
; CHECK:       latch:
; CHECK-NEXT:    [[P_INC]] = getelementptr inbounds i32, i32* [[P]], i64 1
; CHECK-NEXT:    [[C:%.*]] = icmp ne i32* [[P_INC]], [[P_END]]
; CHECK-NEXT:    store i32 0, i32* [[P]], align 4
; CHECK-NEXT:    br i1 [[C]], label [[HEADER]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret i1 true
;
entry:
  %p.end = getelementptr inbounds i32, i32* %p.base, i64 %len
  %len.nonzero = icmp ne i64 %len, 0
  br i1 %len.nonzero, label %header, label %trap

trap:
  ret i1 false

header:
  %p = phi i32* [ %p.base, %entry ], [ %p.inc, %latch ]
  %i = phi i64 [ 0, %entry ], [ %i.inc, %latch]
  %i.inc = add nsw nuw i64 %i, 1
  %i.uge.ext = icmp uge i64 %i, %len
  br i1 %i.uge.ext, label %trap, label %latch

latch:
  %p.inc = getelementptr inbounds i32, i32* %p, i64 1
  %c = icmp ne i32* %p.inc, %p.end
  store i32 0, i32* %p
  br i1 %c, label %header, label %exit

exit:
  ret i1 true
}

define i1 @cannot_simplify_uge_i32_ptr_len_zext_step_2(i32* %p.base, i32 %len) {
; CHECK-LABEL: @cannot_simplify_uge_i32_ptr_len_zext_step_2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[EXT:%.*]] = zext i32 [[LEN:%.*]] to i64
; CHECK-NEXT:    [[P_END:%.*]] = getelementptr inbounds i32, i32* [[P_BASE:%.*]], i64 [[EXT]]
; CHECK-NEXT:    [[LEN_NONZERO:%.*]] = icmp ne i32 [[LEN]], 0
; CHECK-NEXT:    br i1 [[LEN_NONZERO]], label [[HEADER_PREHEADER:%.*]], label [[TRAP:%.*]]
; CHECK:       header.preheader:
; CHECK-NEXT:    br label [[HEADER:%.*]]
; CHECK:       trap.loopexit:
; CHECK-NEXT:    br label [[TRAP]]
; CHECK:       trap:
; CHECK-NEXT:    ret i1 false
; CHECK:       header:
; CHECK-NEXT:    [[P:%.*]] = phi i32* [ [[P_INC:%.*]], [[LATCH:%.*]] ], [ [[P_BASE]], [[HEADER_PREHEADER]] ]
; CHECK-NEXT:    [[I:%.*]] = phi i64 [ [[I_INC:%.*]], [[LATCH]] ], [ 0, [[HEADER_PREHEADER]] ]
; CHECK-NEXT:    [[I_INC]] = add nuw nsw i64 [[I]], 2
; CHECK-NEXT:    [[I_UGE_EXT:%.*]] = icmp uge i64 [[I]], [[EXT]]
; CHECK-NEXT:    br i1 [[I_UGE_EXT]], label [[TRAP_LOOPEXIT:%.*]], label [[LATCH]]
; CHECK:       latch:
; CHECK-NEXT:    [[P_INC]] = getelementptr inbounds i32, i32* [[P]], i64 1
; CHECK-NEXT:    [[C:%.*]] = icmp ne i32* [[P_INC]], [[P_END]]
; CHECK-NEXT:    store i32 0, i32* [[P]], align 4
; CHECK-NEXT:    br i1 [[C]], label [[HEADER]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret i1 true
;
entry:
  %ext = zext i32 %len to i64
  %p.end = getelementptr inbounds i32, i32* %p.base, i64 %ext
  %len.nonzero = icmp ne i32 %len, 0
  br i1 %len.nonzero, label %header, label %trap

trap:
  ret i1 false

header:
  %p = phi i32* [ %p.base, %entry ], [ %p.inc, %latch ]
  %i = phi i64 [ 0, %entry ], [ %i.inc, %latch]
  %i.inc = add nsw nuw i64 %i, 2
  %i.uge.ext = icmp uge i64 %i, %ext
  br i1 %i.uge.ext, label %trap, label %latch

latch:
  %p.inc = getelementptr inbounds i32, i32* %p, i64 1
  %c = icmp ne i32* %p.inc, %p.end
  store i32 0, i32* %p
  br i1 %c, label %header, label %exit

exit:
  ret i1 true
}
