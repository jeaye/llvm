; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --scrub-attributes --check-globals
; call site specific analysis is disabled

; RUN: opt -attributor -enable-new-pm=0 -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=1 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM

; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=1 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM

; RUN: opt -attributor-cgscc -enable-new-pm=0 -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM

; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM

define i32 @test_range(i32 %unknown) {
; CHECK-LABEL: define {{[^@]+}}@test_range
; CHECK-SAME: (i32 [[UNKNOWN:%.*]]) #[[ATTR0:[0-9]+]] {
; CHECK-NEXT:    [[TMP1:%.*]] = icmp sgt i32 [[UNKNOWN]], 100
; CHECK-NEXT:    [[TMP2:%.*]] = select i1 [[TMP1]], i32 100, i32 0
; CHECK-NEXT:    ret i32 [[TMP2]]
;
  %1 = icmp sgt i32 %unknown, 100
  %2 = select i1 %1, i32 100, i32 0
  ret i32 %2
}

define i32 @test1(i32 %unknown, i32 %b) {
; IS__TUNIT____-LABEL: define {{[^@]+}}@test1
; IS__TUNIT____-SAME: (i32 [[UNKNOWN:%.*]], i32 [[B:%.*]]) #[[ATTR0]] {
; IS__TUNIT____-NEXT:    [[TMP1:%.*]] = call i32 @test_range(i32 [[UNKNOWN]]) #[[ATTR0]], !range [[RNG0:![0-9]+]]
; IS__TUNIT____-NEXT:    [[TMP2:%.*]] = sub nsw i32 [[TMP1]], [[B]]
; IS__TUNIT____-NEXT:    ret i32 [[TMP2]]
;
; IS__CGSCC____-LABEL: define {{[^@]+}}@test1
; IS__CGSCC____-SAME: (i32 [[UNKNOWN:%.*]], i32 [[B:%.*]]) #[[ATTR0]] {
; IS__CGSCC____-NEXT:    [[TMP1:%.*]] = call i32 @test_range(i32 [[UNKNOWN]]) #[[ATTR1:[0-9]+]], !range [[RNG0:![0-9]+]]
; IS__CGSCC____-NEXT:    [[TMP2:%.*]] = sub nsw i32 [[TMP1]], [[B]]
; IS__CGSCC____-NEXT:    ret i32 [[TMP2]]
;
  %1 = call i32 @test_range(i32 %unknown)
  %2 = sub nsw i32 %1, %b
  ret i32 %2
}

define i32 @test2(i32 %unknown, i32 %b) {
; IS__TUNIT____-LABEL: define {{[^@]+}}@test2
; IS__TUNIT____-SAME: (i32 [[UNKNOWN:%.*]], i32 [[B:%.*]]) #[[ATTR0]] {
; IS__TUNIT____-NEXT:    [[TMP1:%.*]] = call i32 @test_range(i32 [[UNKNOWN]]) #[[ATTR0]], !range [[RNG0]]
; IS__TUNIT____-NEXT:    [[TMP2:%.*]] = add nsw i32 [[TMP1]], [[B]]
; IS__TUNIT____-NEXT:    ret i32 [[TMP2]]
;
; IS__CGSCC____-LABEL: define {{[^@]+}}@test2
; IS__CGSCC____-SAME: (i32 [[UNKNOWN:%.*]], i32 [[B:%.*]]) #[[ATTR0]] {
; IS__CGSCC____-NEXT:    [[TMP1:%.*]] = call i32 @test_range(i32 [[UNKNOWN]]) #[[ATTR1]], !range [[RNG0]]
; IS__CGSCC____-NEXT:    [[TMP2:%.*]] = add nsw i32 [[TMP1]], [[B]]
; IS__CGSCC____-NEXT:    ret i32 [[TMP2]]
;
  %1 = call i32 @test_range(i32 %unknown)
  %2 = add nsw i32 %1, %b
  ret i32 %2
}

; Positive checks

define i32 @test1_pcheck(i32 %unknown) {
; NOT_CGSCC_NPM-LABEL: define {{[^@]+}}@test1_pcheck
; NOT_CGSCC_NPM-SAME: (i32 [[UNKNOWN:%.*]]) #[[ATTR0]] {
; NOT_CGSCC_NPM-NEXT:    [[TMP1:%.*]] = call i32 @test1(i32 [[UNKNOWN]], i32 noundef 20)
; NOT_CGSCC_NPM-NEXT:    [[TMP2:%.*]] = icmp sle i32 [[TMP1]], 90
; NOT_CGSCC_NPM-NEXT:    [[TMP3:%.*]] = zext i1 [[TMP2]] to i32
; NOT_CGSCC_NPM-NEXT:    ret i32 [[TMP3]]
;
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@test1_pcheck
; IS__CGSCC_NPM-SAME: (i32 [[UNKNOWN:%.*]]) #[[ATTR0]] {
; IS__CGSCC_NPM-NEXT:    [[TMP1:%.*]] = call i32 @test1(i32 [[UNKNOWN]], i32 noundef 20) #[[ATTR1]], !range [[RNG1:![0-9]+]]
; IS__CGSCC_NPM-NEXT:    [[TMP2:%.*]] = icmp sle i32 [[TMP1]], 90
; IS__CGSCC_NPM-NEXT:    [[TMP3:%.*]] = zext i1 [[TMP2]] to i32
; IS__CGSCC_NPM-NEXT:    ret i32 [[TMP3]]
;
  %1 = call i32 @test1(i32 %unknown, i32 20)
  %2 = icmp sle i32 %1, 90
  %3 = zext i1 %2 to i32
  ret i32 %3
}

define i32 @test2_pcheck(i32 %unknown) {
; CHECK-LABEL: define {{[^@]+}}@test2_pcheck
; CHECK-SAME: (i32 [[UNKNOWN:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @test2(i32 [[UNKNOWN]], i32 noundef 20)
; CHECK-NEXT:    [[TMP2:%.*]] = icmp sge i32 [[TMP1]], 20
; CHECK-NEXT:    [[TMP3:%.*]] = zext i1 [[TMP2]] to i32
; CHECK-NEXT:    ret i32 [[TMP3]]
;
  %1 = call i32 @test2(i32 %unknown, i32 20)
  %2 = icmp sge i32 %1, 20
  %3 = zext i1 %2 to i32
  ret i32 %3
}

; Negative checks

define i32 @test1_ncheck(i32 %unknown) {
; NOT_CGSCC_NPM-LABEL: define {{[^@]+}}@test1_ncheck
; NOT_CGSCC_NPM-SAME: (i32 [[UNKNOWN:%.*]]) #[[ATTR0]] {
; NOT_CGSCC_NPM-NEXT:    [[TMP1:%.*]] = call i32 @test1(i32 [[UNKNOWN]], i32 noundef 20)
; NOT_CGSCC_NPM-NEXT:    [[TMP2:%.*]] = icmp sle i32 [[TMP1]], 10
; NOT_CGSCC_NPM-NEXT:    [[TMP3:%.*]] = zext i1 [[TMP2]] to i32
; NOT_CGSCC_NPM-NEXT:    ret i32 [[TMP3]]
;
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@test1_ncheck
; IS__CGSCC_NPM-SAME: (i32 [[UNKNOWN:%.*]]) #[[ATTR0]] {
; IS__CGSCC_NPM-NEXT:    [[TMP1:%.*]] = call i32 @test1(i32 [[UNKNOWN]], i32 noundef 20) #[[ATTR1]], !range [[RNG1]]
; IS__CGSCC_NPM-NEXT:    [[TMP2:%.*]] = icmp sle i32 [[TMP1]], 10
; IS__CGSCC_NPM-NEXT:    [[TMP3:%.*]] = zext i1 [[TMP2]] to i32
; IS__CGSCC_NPM-NEXT:    ret i32 [[TMP3]]
;
  %1 = call i32 @test1(i32 %unknown, i32 20)
  %2 = icmp sle i32 %1, 10
  %3 = zext i1 %2 to i32
  ret i32 %3
}

define i32 @test2_ncheck(i32 %unknown) {
; CHECK-LABEL: define {{[^@]+}}@test2_ncheck
; CHECK-SAME: (i32 [[UNKNOWN:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @test2(i32 [[UNKNOWN]], i32 noundef 20)
; CHECK-NEXT:    [[TMP2:%.*]] = icmp sge i32 [[TMP1]], 30
; CHECK-NEXT:    [[TMP3:%.*]] = zext i1 [[TMP2]] to i32
; CHECK-NEXT:    ret i32 [[TMP3]]
;
  %1 = call i32 @test2(i32 %unknown, i32 20)
  %2 = icmp sge i32 %1, 30
  %3 = zext i1 %2 to i32
  ret i32 %3
}
;.
; IS__TUNIT____: attributes #[[ATTR0]] = { nofree nosync nounwind readnone willreturn }
;.
; IS__CGSCC____: attributes #[[ATTR0]] = { nofree norecurse nosync nounwind readnone willreturn }
; IS__CGSCC____: attributes #[[ATTR1]] = { readnone willreturn }
;.
; NOT_CGSCC_NPM: [[META0:![0-9]+]] = !{i32 0, i32 101}
;.
; IS__CGSCC_NPM: [[RNG0]] = !{i32 0, i32 101}
; IS__CGSCC_NPM: [[RNG1]] = !{i32 -2147483647, i32 -2147483648}
;.
