; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature
; RUN: llvm-as --force-opaque-pointers < %s | llvm-dis --force-opaque-pointers | FileCheck %s
; RUN: llvm-as < %s | llvm-dis --force-opaque-pointers | FileCheck %s
; RUN: opt --force-opaque-pointers < %s -S | FileCheck %s

; CHECK: @g = external global i16
@g = external global i16

; CHECK: @llvm.global_ctors = appending global [1 x { i32, ptr, ptr }] [{ i32, ptr, ptr } { i32 1, ptr null, ptr null }]
@llvm.global_ctors = appending global [1 x { i32, void ()*, i8* }] [{ i32, void ()*, i8* } { i32 1, void ()* null, i8* null }]

; CHECK: @ga = alias i18, ptr @g2
@g2 = global i18 0
@ga = alias i18, i18* @g2

; CHECK: @ga2 = alias i19, ptr @g2
@ga2 = alias i19, i19* bitcast (i18* @g2 to i19*)

define void @f(i32* %p) {
; CHECK-LABEL: define {{[^@]+}}@f
; CHECK-SAME: (ptr [[P:%.*]]) {
; CHECK-NEXT:    [[A:%.*]] = alloca i17, align 4
; CHECK-NEXT:    call void @fn.fwd(i32 0)
; CHECK-NEXT:    store i32 0, ptr @g.fwd, align 4
; CHECK-NEXT:    ret void
;
  %a = alloca i17
  call void @fn.fwd(i32 0)
  store i32 0, i32* @g.fwd
  ret void
}

@g.fwd = global i32 0
declare void @fn.fwd(i32)

define void @f2(i32** %p) {
; CHECK-LABEL: define {{[^@]+}}@f2
; CHECK-SAME: (ptr [[P:%.*]]) {
; CHECK-NEXT:    unreachable
;
  unreachable
}

define void @f3(i32 addrspace(1)* addrspace(2)* %p) {
; CHECK-LABEL: define {{[^@]+}}@f3
; CHECK-SAME: (ptr addrspace(2) [[P:%.*]]) {
; CHECK-NEXT:    unreachable
;
  unreachable
}
