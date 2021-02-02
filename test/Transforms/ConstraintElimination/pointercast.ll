; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -constraint-elimination -S %s | FileCheck %s

define i1 @bitcast_and_cmp(i32* readonly %src, i32* readnone %min, i32* readnone %max) {
; CHECK-LABEL: @bitcast_and_cmp(
; CHECK-NEXT:  check.0.min:
; CHECK-NEXT:    [[SRC_C:%.*]] = bitcast i32* [[SRC:%.*]] to i8*
; CHECK-NEXT:    [[MIN_C:%.*]] = bitcast i32* [[MIN:%.*]] to i8*
; CHECK-NEXT:    [[MAX_C:%.*]] = bitcast i32* [[MAX:%.*]] to i16*
; CHECK-NEXT:    [[GEP_3:%.*]] = getelementptr inbounds i32, i32* [[SRC]], i64 3
; CHECK-NEXT:    [[GEP_3_C:%.*]] = bitcast i32* [[GEP_3]] to i16*
; CHECK-NEXT:    [[C_MIN_0:%.*]] = icmp ult i8* [[SRC_C]], [[MIN_C]]
; CHECK-NEXT:    [[C_MAX_3:%.*]] = icmp ugt i16* [[GEP_3_C]], [[MAX_C]]
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[C_MIN_0]], [[C_MAX_3]]
; CHECK-NEXT:    br i1 [[OR]], label [[TRAP:%.*]], label [[CHECKS:%.*]]
; CHECK:       trap:
; CHECK-NEXT:    ret i1 false
; CHECK:       checks:
; CHECK-NEXT:    [[C_3_MIN:%.*]] = icmp ult i32* [[GEP_3]], [[MIN]]
; CHECK-NEXT:    [[C_3_MAX:%.*]] = icmp ult i32* [[GEP_3]], [[MAX]]
; CHECK-NEXT:    [[RES_1:%.*]] = xor i1 [[C_3_MIN]], [[C_3_MAX]]
; CHECK-NEXT:    [[GEP_1:%.*]] = getelementptr inbounds i32, i32* [[SRC]], i64 1
; CHECK-NEXT:    [[C_1_MIN:%.*]] = icmp ult i32* [[GEP_1]], [[MIN]]
; CHECK-NEXT:    [[C_1_MAX:%.*]] = icmp ult i32* [[GEP_1]], [[MAX]]
; CHECK-NEXT:    [[RES_2:%.*]] = xor i1 [[C_1_MIN]], [[C_1_MAX]]
; CHECK-NEXT:    [[GEP_2:%.*]] = getelementptr inbounds i32, i32* [[SRC]], i64 2
; CHECK-NEXT:    [[C_2_MIN:%.*]] = icmp ult i32* [[GEP_2]], [[MIN]]
; CHECK-NEXT:    [[C_2_MAX:%.*]] = icmp ult i32* [[GEP_2]], [[MAX]]
; CHECK-NEXT:    [[RES_3:%.*]] = xor i1 [[C_2_MIN]], [[C_2_MAX]]
; CHECK-NEXT:    [[GEP_4:%.*]] = getelementptr inbounds i32, i32* [[SRC]], i64 4
; CHECK-NEXT:    [[C_4_MIN:%.*]] = icmp ult i32* [[GEP_2]], [[MIN]]
; CHECK-NEXT:    [[C_4_MAX:%.*]] = icmp ult i32* [[GEP_2]], [[MAX]]
; CHECK-NEXT:    [[RES_4:%.*]] = xor i1 [[C_4_MIN]], [[C_4_MAX]]
; CHECK-NEXT:    [[RES_5:%.*]] = xor i1 [[RES_1]], [[RES_2]]
; CHECK-NEXT:    [[RES_6:%.*]] = xor i1 [[RES_5]], [[RES_3]]
; CHECK-NEXT:    [[RES_7:%.*]] = xor i1 [[RES_6]], [[RES_4]]
; CHECK-NEXT:    ret i1 [[RES_7]]
;
check.0.min:
  %src.c = bitcast i32* %src to i8*
  %min.c = bitcast i32* %min to i8*
  %max.c = bitcast i32* %max to i16*

  %gep.3 = getelementptr inbounds i32, i32* %src, i64 3
  %gep.3.c = bitcast i32* %gep.3 to i16*
  %c.min.0 = icmp ult i8* %src.c, %min.c
  %c.max.3 = icmp ugt i16* %gep.3.c, %max.c

  %or = or i1 %c.min.0, %c.max.3
  br i1 %or, label %trap, label %checks

trap:
  ret i1 0

checks:
  %c.3.min = icmp ult i32* %gep.3, %min
  %c.3.max = icmp ult i32* %gep.3, %max
  %res.1 = xor i1 %c.3.min, %c.3.max

  %gep.1 = getelementptr inbounds i32, i32* %src, i64 1
  %c.1.min = icmp ult i32* %gep.1, %min
  %c.1.max = icmp ult i32* %gep.1, %max
  %res.2 = xor i1 %c.1.min, %c.1.max

  %gep.2 = getelementptr inbounds i32, i32* %src, i64 2
  %c.2.min = icmp ult i32* %gep.2, %min
  %c.2.max = icmp ult i32* %gep.2, %max
  %res.3 = xor i1 %c.2.min, %c.2.max

  %gep.4 = getelementptr inbounds i32, i32* %src, i64 4
  %c.4.min = icmp ult i32* %gep.2, %min
  %c.4.max = icmp ult i32* %gep.2, %max
  %res.4 = xor i1 %c.4.min, %c.4.max

  %res.5 = xor i1 %res.1, %res.2
  %res.6 = xor i1 %res.5, %res.3
  %res.7 = xor i1 %res.6, %res.4

  ret i1 %res.7
}
