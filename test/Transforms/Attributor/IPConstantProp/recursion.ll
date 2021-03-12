; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-attributes --check-globals
; RUN: opt -attributor -enable-new-pm=0 -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=1 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=1 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM
; RUN: opt -attributor-cgscc -enable-new-pm=0 -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM

; CHECK-NOT: %X

define internal i32 @foo(i32 %X) {
; IS__CGSCC____: Function Attrs: nofree norecurse noreturn nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@foo
; IS__CGSCC____-SAME: () #[[ATTR0:[0-9]+]] {
; IS__CGSCC____-NEXT:    unreachable
;
  %Y = call i32 @foo( i32 %X )            ; <i32> [#uses=1]
  %Z = add i32 %Y, 1              ; <i32> [#uses=1]
  ret i32 %Z
}

define void @bar() {
; IS__TUNIT____: Function Attrs: nofree noreturn nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@bar
; IS__TUNIT____-SAME: () #[[ATTR0:[0-9]+]] {
; IS__TUNIT____-NEXT:    unreachable
;
; IS__CGSCC____: Function Attrs: nofree norecurse noreturn nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@bar
; IS__CGSCC____-SAME: () #[[ATTR0]] {
; IS__CGSCC____-NEXT:    unreachable
;
  call i32 @foo( i32 17 )         ; <i32>:1 [#uses=0]
  ret void
}

;.
; IS__TUNIT____: attributes #[[ATTR0]] = { nofree noreturn nosync nounwind readnone willreturn }
;.
; IS__CGSCC____: attributes #[[ATTR0]] = { nofree norecurse noreturn nosync nounwind readnone willreturn }
;.
