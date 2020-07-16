; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -march=amdgcn -global-isel -stop-after=irtranslator %s -o - | FileCheck %s

define i16 @uaddsat_i16(i16 %lhs, i16 %rhs) {
  ; CHECK-LABEL: name: uaddsat_i16
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $vgpr0, $vgpr1, $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; CHECK:   [[TRUNC:%[0-9]+]]:_(s16) = G_TRUNC [[COPY]](s32)
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; CHECK:   [[TRUNC1:%[0-9]+]]:_(s16) = G_TRUNC [[COPY1]](s32)
  ; CHECK:   [[COPY2:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   [[UADDSAT:%[0-9]+]]:_(s16) = G_UADDSAT [[TRUNC]], [[TRUNC1]]
  ; CHECK:   [[ANYEXT:%[0-9]+]]:_(s32) = G_ANYEXT [[UADDSAT]](s16)
  ; CHECK:   $vgpr0 = COPY [[ANYEXT]](s32)
  ; CHECK:   [[COPY3:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY2]]
  ; CHECK:   S_SETPC_B64_return [[COPY3]], implicit $vgpr0
  %res = call i16 @llvm.uadd.sat.i16(i16 %lhs, i16 %rhs)
  ret i16 %res
}
declare i16 @llvm.uadd.sat.i16(i16, i16)

define i32 @uaddsat_i32(i32 %lhs, i32 %rhs) {
  ; CHECK-LABEL: name: uaddsat_i32
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $vgpr0, $vgpr1, $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; CHECK:   [[COPY2:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   [[UADDSAT:%[0-9]+]]:_(s32) = G_UADDSAT [[COPY]], [[COPY1]]
  ; CHECK:   $vgpr0 = COPY [[UADDSAT]](s32)
  ; CHECK:   [[COPY3:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY2]]
  ; CHECK:   S_SETPC_B64_return [[COPY3]], implicit $vgpr0
  %res = call i32 @llvm.uadd.sat.i32(i32 %lhs, i32 %rhs)
  ret i32 %res
}
declare i32 @llvm.uadd.sat.i32(i32, i32)

define i64 @uaddsat_i64(i64 %lhs, i64 %rhs) {
  ; CHECK-LABEL: name: uaddsat_i64
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $vgpr0, $vgpr1, $vgpr2, $vgpr3, $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; CHECK:   [[COPY2:%[0-9]+]]:_(s32) = COPY $vgpr2
  ; CHECK:   [[COPY3:%[0-9]+]]:_(s32) = COPY $vgpr3
  ; CHECK:   [[COPY4:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   [[MV:%[0-9]+]]:_(s64) = G_MERGE_VALUES [[COPY]](s32), [[COPY1]](s32)
  ; CHECK:   [[MV1:%[0-9]+]]:_(s64) = G_MERGE_VALUES [[COPY2]](s32), [[COPY3]](s32)
  ; CHECK:   [[UADDSAT:%[0-9]+]]:_(s64) = G_UADDSAT [[MV]], [[MV1]]
  ; CHECK:   [[UV:%[0-9]+]]:_(s32), [[UV1:%[0-9]+]]:_(s32) = G_UNMERGE_VALUES [[UADDSAT]](s64)
  ; CHECK:   $vgpr0 = COPY [[UV]](s32)
  ; CHECK:   $vgpr1 = COPY [[UV1]](s32)
  ; CHECK:   [[COPY5:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY4]]
  ; CHECK:   S_SETPC_B64_return [[COPY5]], implicit $vgpr0, implicit $vgpr1
  %res = call i64 @llvm.uadd.sat.i64(i64 %lhs, i64 %rhs)
  ret i64 %res
}
declare i64 @llvm.uadd.sat.i64(i64, i64)

define <2 x i32> @uaddsat_v2i32(<2 x i32> %lhs, <2 x i32> %rhs) {
  ; CHECK-LABEL: name: uaddsat_v2i32
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $vgpr0, $vgpr1, $vgpr2, $vgpr3, $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; CHECK:   [[COPY2:%[0-9]+]]:_(s32) = COPY $vgpr2
  ; CHECK:   [[COPY3:%[0-9]+]]:_(s32) = COPY $vgpr3
  ; CHECK:   [[COPY4:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   [[BUILD_VECTOR:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32)
  ; CHECK:   [[BUILD_VECTOR1:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[COPY2]](s32), [[COPY3]](s32)
  ; CHECK:   [[UADDSAT:%[0-9]+]]:_(<2 x s32>) = G_UADDSAT [[BUILD_VECTOR]], [[BUILD_VECTOR1]]
  ; CHECK:   [[UV:%[0-9]+]]:_(s32), [[UV1:%[0-9]+]]:_(s32) = G_UNMERGE_VALUES [[UADDSAT]](<2 x s32>)
  ; CHECK:   $vgpr0 = COPY [[UV]](s32)
  ; CHECK:   $vgpr1 = COPY [[UV1]](s32)
  ; CHECK:   [[COPY5:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY4]]
  ; CHECK:   S_SETPC_B64_return [[COPY5]], implicit $vgpr0, implicit $vgpr1
  %res = call <2 x i32> @llvm.uadd.sat.v2i32(<2 x i32> %lhs, <2 x i32> %rhs)
  ret <2 x i32> %res
}
declare <2 x i32> @llvm.uadd.sat.v2i32(<2 x i32>, <2 x i32>)

define i16 @saddsat_i16(i16 %lhs, i16 %rhs) {
  ; CHECK-LABEL: name: saddsat_i16
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $vgpr0, $vgpr1, $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; CHECK:   [[TRUNC:%[0-9]+]]:_(s16) = G_TRUNC [[COPY]](s32)
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; CHECK:   [[TRUNC1:%[0-9]+]]:_(s16) = G_TRUNC [[COPY1]](s32)
  ; CHECK:   [[COPY2:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   [[SADDSAT:%[0-9]+]]:_(s16) = G_SADDSAT [[TRUNC]], [[TRUNC1]]
  ; CHECK:   [[ANYEXT:%[0-9]+]]:_(s32) = G_ANYEXT [[SADDSAT]](s16)
  ; CHECK:   $vgpr0 = COPY [[ANYEXT]](s32)
  ; CHECK:   [[COPY3:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY2]]
  ; CHECK:   S_SETPC_B64_return [[COPY3]], implicit $vgpr0
  %res = call i16 @llvm.sadd.sat.i16(i16 %lhs, i16 %rhs)
  ret i16 %res
}
declare i16 @llvm.sadd.sat.i16(i16, i16)

define i32 @saddsat_i32(i32 %lhs, i32 %rhs) {
  ; CHECK-LABEL: name: saddsat_i32
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $vgpr0, $vgpr1, $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; CHECK:   [[COPY2:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   [[SADDSAT:%[0-9]+]]:_(s32) = G_SADDSAT [[COPY]], [[COPY1]]
  ; CHECK:   $vgpr0 = COPY [[SADDSAT]](s32)
  ; CHECK:   [[COPY3:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY2]]
  ; CHECK:   S_SETPC_B64_return [[COPY3]], implicit $vgpr0
  %res = call i32 @llvm.sadd.sat.i32(i32 %lhs, i32 %rhs)
  ret i32 %res
}
declare i32 @llvm.sadd.sat.i32(i32, i32)

define i64 @saddsat_i64(i64 %lhs, i64 %rhs) {
  ; CHECK-LABEL: name: saddsat_i64
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $vgpr0, $vgpr1, $vgpr2, $vgpr3, $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; CHECK:   [[COPY2:%[0-9]+]]:_(s32) = COPY $vgpr2
  ; CHECK:   [[COPY3:%[0-9]+]]:_(s32) = COPY $vgpr3
  ; CHECK:   [[COPY4:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   [[MV:%[0-9]+]]:_(s64) = G_MERGE_VALUES [[COPY]](s32), [[COPY1]](s32)
  ; CHECK:   [[MV1:%[0-9]+]]:_(s64) = G_MERGE_VALUES [[COPY2]](s32), [[COPY3]](s32)
  ; CHECK:   [[SADDSAT:%[0-9]+]]:_(s64) = G_SADDSAT [[MV]], [[MV1]]
  ; CHECK:   [[UV:%[0-9]+]]:_(s32), [[UV1:%[0-9]+]]:_(s32) = G_UNMERGE_VALUES [[SADDSAT]](s64)
  ; CHECK:   $vgpr0 = COPY [[UV]](s32)
  ; CHECK:   $vgpr1 = COPY [[UV1]](s32)
  ; CHECK:   [[COPY5:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY4]]
  ; CHECK:   S_SETPC_B64_return [[COPY5]], implicit $vgpr0, implicit $vgpr1
  %res = call i64 @llvm.sadd.sat.i64(i64 %lhs, i64 %rhs)
  ret i64 %res
}
declare i64 @llvm.sadd.sat.i64(i64, i64)

define <2 x i32> @saddsat_v2i32(<2 x i32> %lhs, <2 x i32> %rhs) {
  ; CHECK-LABEL: name: saddsat_v2i32
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $vgpr0, $vgpr1, $vgpr2, $vgpr3, $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; CHECK:   [[COPY2:%[0-9]+]]:_(s32) = COPY $vgpr2
  ; CHECK:   [[COPY3:%[0-9]+]]:_(s32) = COPY $vgpr3
  ; CHECK:   [[COPY4:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   [[BUILD_VECTOR:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32)
  ; CHECK:   [[BUILD_VECTOR1:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[COPY2]](s32), [[COPY3]](s32)
  ; CHECK:   [[SADDSAT:%[0-9]+]]:_(<2 x s32>) = G_SADDSAT [[BUILD_VECTOR]], [[BUILD_VECTOR1]]
  ; CHECK:   [[UV:%[0-9]+]]:_(s32), [[UV1:%[0-9]+]]:_(s32) = G_UNMERGE_VALUES [[SADDSAT]](<2 x s32>)
  ; CHECK:   $vgpr0 = COPY [[UV]](s32)
  ; CHECK:   $vgpr1 = COPY [[UV1]](s32)
  ; CHECK:   [[COPY5:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY4]]
  ; CHECK:   S_SETPC_B64_return [[COPY5]], implicit $vgpr0, implicit $vgpr1
  %res = call <2 x i32> @llvm.sadd.sat.v2i32(<2 x i32> %lhs, <2 x i32> %rhs)
  ret <2 x i32> %res
}
declare <2 x i32> @llvm.sadd.sat.v2i32(<2 x i32>, <2 x i32>)

define i16 @usubsat_i16(i16 %lhs, i16 %rhs) {
  ; CHECK-LABEL: name: usubsat_i16
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $vgpr0, $vgpr1, $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; CHECK:   [[TRUNC:%[0-9]+]]:_(s16) = G_TRUNC [[COPY]](s32)
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; CHECK:   [[TRUNC1:%[0-9]+]]:_(s16) = G_TRUNC [[COPY1]](s32)
  ; CHECK:   [[COPY2:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   [[USUBSAT:%[0-9]+]]:_(s16) = G_USUBSAT [[TRUNC]], [[TRUNC1]]
  ; CHECK:   [[ANYEXT:%[0-9]+]]:_(s32) = G_ANYEXT [[USUBSAT]](s16)
  ; CHECK:   $vgpr0 = COPY [[ANYEXT]](s32)
  ; CHECK:   [[COPY3:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY2]]
  ; CHECK:   S_SETPC_B64_return [[COPY3]], implicit $vgpr0
  %res = call i16 @llvm.usub.sat.i16(i16 %lhs, i16 %rhs)
  ret i16 %res
}
declare i16 @llvm.usub.sat.i16(i16, i16)

define i32 @usubsat_i32(i32 %lhs, i32 %rhs) {
  ; CHECK-LABEL: name: usubsat_i32
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $vgpr0, $vgpr1, $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; CHECK:   [[COPY2:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   [[USUBSAT:%[0-9]+]]:_(s32) = G_USUBSAT [[COPY]], [[COPY1]]
  ; CHECK:   $vgpr0 = COPY [[USUBSAT]](s32)
  ; CHECK:   [[COPY3:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY2]]
  ; CHECK:   S_SETPC_B64_return [[COPY3]], implicit $vgpr0
  %res = call i32 @llvm.usub.sat.i32(i32 %lhs, i32 %rhs)
  ret i32 %res
}
declare i32 @llvm.usub.sat.i32(i32, i32)

define i64 @usubsat_i64(i64 %lhs, i64 %rhs) {
  ; CHECK-LABEL: name: usubsat_i64
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $vgpr0, $vgpr1, $vgpr2, $vgpr3, $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; CHECK:   [[COPY2:%[0-9]+]]:_(s32) = COPY $vgpr2
  ; CHECK:   [[COPY3:%[0-9]+]]:_(s32) = COPY $vgpr3
  ; CHECK:   [[COPY4:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   [[MV:%[0-9]+]]:_(s64) = G_MERGE_VALUES [[COPY]](s32), [[COPY1]](s32)
  ; CHECK:   [[MV1:%[0-9]+]]:_(s64) = G_MERGE_VALUES [[COPY2]](s32), [[COPY3]](s32)
  ; CHECK:   [[USUBSAT:%[0-9]+]]:_(s64) = G_USUBSAT [[MV]], [[MV1]]
  ; CHECK:   [[UV:%[0-9]+]]:_(s32), [[UV1:%[0-9]+]]:_(s32) = G_UNMERGE_VALUES [[USUBSAT]](s64)
  ; CHECK:   $vgpr0 = COPY [[UV]](s32)
  ; CHECK:   $vgpr1 = COPY [[UV1]](s32)
  ; CHECK:   [[COPY5:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY4]]
  ; CHECK:   S_SETPC_B64_return [[COPY5]], implicit $vgpr0, implicit $vgpr1
  %res = call i64 @llvm.usub.sat.i64(i64 %lhs, i64 %rhs)
  ret i64 %res
}
declare i64 @llvm.usub.sat.i64(i64, i64)

define <2 x i32> @usubsat_v2i32(<2 x i32> %lhs, <2 x i32> %rhs) {
  ; CHECK-LABEL: name: usubsat_v2i32
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $vgpr0, $vgpr1, $vgpr2, $vgpr3, $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; CHECK:   [[COPY2:%[0-9]+]]:_(s32) = COPY $vgpr2
  ; CHECK:   [[COPY3:%[0-9]+]]:_(s32) = COPY $vgpr3
  ; CHECK:   [[COPY4:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   [[BUILD_VECTOR:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32)
  ; CHECK:   [[BUILD_VECTOR1:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[COPY2]](s32), [[COPY3]](s32)
  ; CHECK:   [[USUBSAT:%[0-9]+]]:_(<2 x s32>) = G_USUBSAT [[BUILD_VECTOR]], [[BUILD_VECTOR1]]
  ; CHECK:   [[UV:%[0-9]+]]:_(s32), [[UV1:%[0-9]+]]:_(s32) = G_UNMERGE_VALUES [[USUBSAT]](<2 x s32>)
  ; CHECK:   $vgpr0 = COPY [[UV]](s32)
  ; CHECK:   $vgpr1 = COPY [[UV1]](s32)
  ; CHECK:   [[COPY5:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY4]]
  ; CHECK:   S_SETPC_B64_return [[COPY5]], implicit $vgpr0, implicit $vgpr1
  %res = call <2 x i32> @llvm.usub.sat.v2i32(<2 x i32> %lhs, <2 x i32> %rhs)
  ret <2 x i32> %res
}
declare <2 x i32> @llvm.usub.sat.v2i32(<2 x i32>, <2 x i32>)

define i16 @ssubsat_i16(i16 %lhs, i16 %rhs) {
  ; CHECK-LABEL: name: ssubsat_i16
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $vgpr0, $vgpr1, $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; CHECK:   [[TRUNC:%[0-9]+]]:_(s16) = G_TRUNC [[COPY]](s32)
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; CHECK:   [[TRUNC1:%[0-9]+]]:_(s16) = G_TRUNC [[COPY1]](s32)
  ; CHECK:   [[COPY2:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   [[SSUBSAT:%[0-9]+]]:_(s16) = G_SSUBSAT [[TRUNC]], [[TRUNC1]]
  ; CHECK:   [[ANYEXT:%[0-9]+]]:_(s32) = G_ANYEXT [[SSUBSAT]](s16)
  ; CHECK:   $vgpr0 = COPY [[ANYEXT]](s32)
  ; CHECK:   [[COPY3:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY2]]
  ; CHECK:   S_SETPC_B64_return [[COPY3]], implicit $vgpr0
  %res = call i16 @llvm.ssub.sat.i16(i16 %lhs, i16 %rhs)
  ret i16 %res
}
declare i16 @llvm.ssub.sat.i16(i16, i16)

define i32 @ssubsat_i32(i32 %lhs, i32 %rhs) {
  ; CHECK-LABEL: name: ssubsat_i32
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $vgpr0, $vgpr1, $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; CHECK:   [[COPY2:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   [[SSUBSAT:%[0-9]+]]:_(s32) = G_SSUBSAT [[COPY]], [[COPY1]]
  ; CHECK:   $vgpr0 = COPY [[SSUBSAT]](s32)
  ; CHECK:   [[COPY3:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY2]]
  ; CHECK:   S_SETPC_B64_return [[COPY3]], implicit $vgpr0
  %res = call i32 @llvm.ssub.sat.i32(i32 %lhs, i32 %rhs)
  ret i32 %res
}
declare i32 @llvm.ssub.sat.i32(i32, i32)

define i64 @ssubsat_i64(i64 %lhs, i64 %rhs) {
  ; CHECK-LABEL: name: ssubsat_i64
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $vgpr0, $vgpr1, $vgpr2, $vgpr3, $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; CHECK:   [[COPY2:%[0-9]+]]:_(s32) = COPY $vgpr2
  ; CHECK:   [[COPY3:%[0-9]+]]:_(s32) = COPY $vgpr3
  ; CHECK:   [[COPY4:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   [[MV:%[0-9]+]]:_(s64) = G_MERGE_VALUES [[COPY]](s32), [[COPY1]](s32)
  ; CHECK:   [[MV1:%[0-9]+]]:_(s64) = G_MERGE_VALUES [[COPY2]](s32), [[COPY3]](s32)
  ; CHECK:   [[SSUBSAT:%[0-9]+]]:_(s64) = G_SSUBSAT [[MV]], [[MV1]]
  ; CHECK:   [[UV:%[0-9]+]]:_(s32), [[UV1:%[0-9]+]]:_(s32) = G_UNMERGE_VALUES [[SSUBSAT]](s64)
  ; CHECK:   $vgpr0 = COPY [[UV]](s32)
  ; CHECK:   $vgpr1 = COPY [[UV1]](s32)
  ; CHECK:   [[COPY5:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY4]]
  ; CHECK:   S_SETPC_B64_return [[COPY5]], implicit $vgpr0, implicit $vgpr1
  %res = call i64 @llvm.ssub.sat.i64(i64 %lhs, i64 %rhs)
  ret i64 %res
}
declare i64 @llvm.ssub.sat.i64(i64, i64)

define <2 x i32> @ssubsat_v2i32(<2 x i32> %lhs, <2 x i32> %rhs) {
  ; CHECK-LABEL: name: ssubsat_v2i32
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $vgpr0, $vgpr1, $vgpr2, $vgpr3, $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; CHECK:   [[COPY2:%[0-9]+]]:_(s32) = COPY $vgpr2
  ; CHECK:   [[COPY3:%[0-9]+]]:_(s32) = COPY $vgpr3
  ; CHECK:   [[COPY4:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   [[BUILD_VECTOR:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32)
  ; CHECK:   [[BUILD_VECTOR1:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[COPY2]](s32), [[COPY3]](s32)
  ; CHECK:   [[SSUBSAT:%[0-9]+]]:_(<2 x s32>) = G_SSUBSAT [[BUILD_VECTOR]], [[BUILD_VECTOR1]]
  ; CHECK:   [[UV:%[0-9]+]]:_(s32), [[UV1:%[0-9]+]]:_(s32) = G_UNMERGE_VALUES [[SSUBSAT]](<2 x s32>)
  ; CHECK:   $vgpr0 = COPY [[UV]](s32)
  ; CHECK:   $vgpr1 = COPY [[UV1]](s32)
  ; CHECK:   [[COPY5:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY4]]
  ; CHECK:   S_SETPC_B64_return [[COPY5]], implicit $vgpr0, implicit $vgpr1
  %res = call <2 x i32> @llvm.ssub.sat.v2i32(<2 x i32> %lhs, <2 x i32> %rhs)
  ret <2 x i32> %res
}
declare <2 x i32> @llvm.ssub.sat.v2i32(<2 x i32>, <2 x i32>)

define i16 @ushlsat_i16(i16 %lhs, i16 %rhs) {
  ; CHECK-LABEL: name: ushlsat_i16
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $vgpr0, $vgpr1, $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; CHECK:   [[TRUNC:%[0-9]+]]:_(s16) = G_TRUNC [[COPY]](s32)
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; CHECK:   [[TRUNC1:%[0-9]+]]:_(s16) = G_TRUNC [[COPY1]](s32)
  ; CHECK:   [[COPY2:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   [[USHLSAT:%[0-9]+]]:_(s16) = G_USHLSAT [[TRUNC]], [[TRUNC1]]
  ; CHECK:   [[ANYEXT:%[0-9]+]]:_(s32) = G_ANYEXT [[USHLSAT]](s16)
  ; CHECK:   $vgpr0 = COPY [[ANYEXT]](s32)
  ; CHECK:   [[COPY3:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY2]]
  ; CHECK:   S_SETPC_B64_return [[COPY3]], implicit $vgpr0
  %res = call i16 @llvm.ushl.sat.i16(i16 %lhs, i16 %rhs)
  ret i16 %res
}
declare i16 @llvm.ushl.sat.i16(i16, i16)

define i32 @ushlsat_i32(i32 %lhs, i32 %rhs) {
  ; CHECK-LABEL: name: ushlsat_i32
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $vgpr0, $vgpr1, $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; CHECK:   [[COPY2:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   [[USHLSAT:%[0-9]+]]:_(s32) = G_USHLSAT [[COPY]], [[COPY1]]
  ; CHECK:   $vgpr0 = COPY [[USHLSAT]](s32)
  ; CHECK:   [[COPY3:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY2]]
  ; CHECK:   S_SETPC_B64_return [[COPY3]], implicit $vgpr0
  %res = call i32 @llvm.ushl.sat.i32(i32 %lhs, i32 %rhs)
  ret i32 %res
}
declare i32 @llvm.ushl.sat.i32(i32, i32)

define i64 @ushlsat_i64(i64 %lhs, i64 %rhs) {
  ; CHECK-LABEL: name: ushlsat_i64
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $vgpr0, $vgpr1, $vgpr2, $vgpr3, $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; CHECK:   [[COPY2:%[0-9]+]]:_(s32) = COPY $vgpr2
  ; CHECK:   [[COPY3:%[0-9]+]]:_(s32) = COPY $vgpr3
  ; CHECK:   [[COPY4:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   [[MV:%[0-9]+]]:_(s64) = G_MERGE_VALUES [[COPY]](s32), [[COPY1]](s32)
  ; CHECK:   [[MV1:%[0-9]+]]:_(s64) = G_MERGE_VALUES [[COPY2]](s32), [[COPY3]](s32)
  ; CHECK:   [[USHLSAT:%[0-9]+]]:_(s64) = G_USHLSAT [[MV]], [[MV1]]
  ; CHECK:   [[UV:%[0-9]+]]:_(s32), [[UV1:%[0-9]+]]:_(s32) = G_UNMERGE_VALUES [[USHLSAT]](s64)
  ; CHECK:   $vgpr0 = COPY [[UV]](s32)
  ; CHECK:   $vgpr1 = COPY [[UV1]](s32)
  ; CHECK:   [[COPY5:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY4]]
  ; CHECK:   S_SETPC_B64_return [[COPY5]], implicit $vgpr0, implicit $vgpr1
  %res = call i64 @llvm.ushl.sat.i64(i64 %lhs, i64 %rhs)
  ret i64 %res
}
declare i64 @llvm.ushl.sat.i64(i64, i64)

define <2 x i32> @ushlsat_v2i32(<2 x i32> %lhs, <2 x i32> %rhs) {
  ; CHECK-LABEL: name: ushlsat_v2i32
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $vgpr0, $vgpr1, $vgpr2, $vgpr3, $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; CHECK:   [[COPY2:%[0-9]+]]:_(s32) = COPY $vgpr2
  ; CHECK:   [[COPY3:%[0-9]+]]:_(s32) = COPY $vgpr3
  ; CHECK:   [[COPY4:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   [[BUILD_VECTOR:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32)
  ; CHECK:   [[BUILD_VECTOR1:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[COPY2]](s32), [[COPY3]](s32)
  ; CHECK:   [[USHLSAT:%[0-9]+]]:_(<2 x s32>) = G_USHLSAT [[BUILD_VECTOR]], [[BUILD_VECTOR1]]
  ; CHECK:   [[UV:%[0-9]+]]:_(s32), [[UV1:%[0-9]+]]:_(s32) = G_UNMERGE_VALUES [[USHLSAT]](<2 x s32>)
  ; CHECK:   $vgpr0 = COPY [[UV]](s32)
  ; CHECK:   $vgpr1 = COPY [[UV1]](s32)
  ; CHECK:   [[COPY5:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY4]]
  ; CHECK:   S_SETPC_B64_return [[COPY5]], implicit $vgpr0, implicit $vgpr1
  %res = call <2 x i32> @llvm.ushl.sat.v2i32(<2 x i32> %lhs, <2 x i32> %rhs)
  ret <2 x i32> %res
}
declare <2 x i32> @llvm.ushl.sat.v2i32(<2 x i32>, <2 x i32>)

define i16 @sshlsat_i16(i16 %lhs, i16 %rhs) {
  ; CHECK-LABEL: name: sshlsat_i16
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $vgpr0, $vgpr1, $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; CHECK:   [[TRUNC:%[0-9]+]]:_(s16) = G_TRUNC [[COPY]](s32)
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; CHECK:   [[TRUNC1:%[0-9]+]]:_(s16) = G_TRUNC [[COPY1]](s32)
  ; CHECK:   [[COPY2:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   [[SSHLSAT:%[0-9]+]]:_(s16) = G_SSHLSAT [[TRUNC]], [[TRUNC1]]
  ; CHECK:   [[ANYEXT:%[0-9]+]]:_(s32) = G_ANYEXT [[SSHLSAT]](s16)
  ; CHECK:   $vgpr0 = COPY [[ANYEXT]](s32)
  ; CHECK:   [[COPY3:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY2]]
  ; CHECK:   S_SETPC_B64_return [[COPY3]], implicit $vgpr0
  %res = call i16 @llvm.sshl.sat.i16(i16 %lhs, i16 %rhs)
  ret i16 %res
}
declare i16 @llvm.sshl.sat.i16(i16, i16)

define i32 @sshlsat_i32(i32 %lhs, i32 %rhs) {
  ; CHECK-LABEL: name: sshlsat_i32
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $vgpr0, $vgpr1, $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; CHECK:   [[COPY2:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   [[SSHLSAT:%[0-9]+]]:_(s32) = G_SSHLSAT [[COPY]], [[COPY1]]
  ; CHECK:   $vgpr0 = COPY [[SSHLSAT]](s32)
  ; CHECK:   [[COPY3:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY2]]
  ; CHECK:   S_SETPC_B64_return [[COPY3]], implicit $vgpr0
  %res = call i32 @llvm.sshl.sat.i32(i32 %lhs, i32 %rhs)
  ret i32 %res
}
declare i32 @llvm.sshl.sat.i32(i32, i32)

define i64 @sshlsat_i64(i64 %lhs, i64 %rhs) {
  ; CHECK-LABEL: name: sshlsat_i64
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $vgpr0, $vgpr1, $vgpr2, $vgpr3, $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; CHECK:   [[COPY2:%[0-9]+]]:_(s32) = COPY $vgpr2
  ; CHECK:   [[COPY3:%[0-9]+]]:_(s32) = COPY $vgpr3
  ; CHECK:   [[COPY4:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   [[MV:%[0-9]+]]:_(s64) = G_MERGE_VALUES [[COPY]](s32), [[COPY1]](s32)
  ; CHECK:   [[MV1:%[0-9]+]]:_(s64) = G_MERGE_VALUES [[COPY2]](s32), [[COPY3]](s32)
  ; CHECK:   [[SSHLSAT:%[0-9]+]]:_(s64) = G_SSHLSAT [[MV]], [[MV1]]
  ; CHECK:   [[UV:%[0-9]+]]:_(s32), [[UV1:%[0-9]+]]:_(s32) = G_UNMERGE_VALUES [[SSHLSAT]](s64)
  ; CHECK:   $vgpr0 = COPY [[UV]](s32)
  ; CHECK:   $vgpr1 = COPY [[UV1]](s32)
  ; CHECK:   [[COPY5:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY4]]
  ; CHECK:   S_SETPC_B64_return [[COPY5]], implicit $vgpr0, implicit $vgpr1
  %res = call i64 @llvm.sshl.sat.i64(i64 %lhs, i64 %rhs)
  ret i64 %res
}
declare i64 @llvm.sshl.sat.i64(i64, i64)

define <2 x i32> @sshlsat_v2i32(<2 x i32> %lhs, <2 x i32> %rhs) {
  ; CHECK-LABEL: name: sshlsat_v2i32
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $vgpr0, $vgpr1, $vgpr2, $vgpr3, $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; CHECK:   [[COPY2:%[0-9]+]]:_(s32) = COPY $vgpr2
  ; CHECK:   [[COPY3:%[0-9]+]]:_(s32) = COPY $vgpr3
  ; CHECK:   [[COPY4:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   [[BUILD_VECTOR:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32)
  ; CHECK:   [[BUILD_VECTOR1:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[COPY2]](s32), [[COPY3]](s32)
  ; CHECK:   [[SSHLSAT:%[0-9]+]]:_(<2 x s32>) = G_SSHLSAT [[BUILD_VECTOR]], [[BUILD_VECTOR1]]
  ; CHECK:   [[UV:%[0-9]+]]:_(s32), [[UV1:%[0-9]+]]:_(s32) = G_UNMERGE_VALUES [[SSHLSAT]](<2 x s32>)
  ; CHECK:   $vgpr0 = COPY [[UV]](s32)
  ; CHECK:   $vgpr1 = COPY [[UV1]](s32)
  ; CHECK:   [[COPY5:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY4]]
  ; CHECK:   S_SETPC_B64_return [[COPY5]], implicit $vgpr0, implicit $vgpr1
  %res = call <2 x i32> @llvm.sshl.sat.v2i32(<2 x i32> %lhs, <2 x i32> %rhs)
  ret <2 x i32> %res
}
declare <2 x i32> @llvm.sshl.sat.v2i32(<2 x i32>, <2 x i32>)
