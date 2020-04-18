; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basicaa -newgvn -S | FileCheck %s
;; Now that we do store refinement, we have to verify that we add fake uses
;; when we skip existing stores.
;; We also are testing that various variations that cause stores to move classes
;; have the right class movement happen
;; All of these tests result in verification failures if it does not.

source_filename = "bugpoint-output-daef094.bc"
target triple = "x86_64-apple-darwin16.5.0"

%struct.eggs = type {}

define void @spam(i32 *%a) {
; CHECK-LABEL: @spam(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[FOO:%.*]] = bitcast i32* [[A:%.*]] to %struct.eggs**
; CHECK-NEXT:    store %struct.eggs* null, %struct.eggs** [[FOO]]
; CHECK-NEXT:    br label [[BB1:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br i1 undef, label [[BB3:%.*]], label [[BB2:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    call void @baz()
; CHECK-NEXT:    br label [[BB1]]
; CHECK:       bb3:
; CHECK-NEXT:    store i32 0, i32* undef
; CHECK-NEXT:    store %struct.eggs* null, %struct.eggs** [[FOO]]
; CHECK-NEXT:    unreachable
;
bb:
  %foo = bitcast i32 *%a to %struct.eggs**
  store %struct.eggs* null, %struct.eggs** %foo
  br label %bb1

bb1:                                              ; preds = %bb2, %bb
  br i1 undef, label %bb3, label %bb2

bb2:                                              ; preds = %bb1
  call void @baz()
  br label %bb1

bb3:                                              ; preds = %bb1
  store i32 0, i32* undef
;; This store is defined by a memoryphi of the call and the first store
;; At first, we will prove it equivalent to the first store above.
;; Then the call will become reachable, and the equivalence will be removed
;; Without it being a use of the first store, we will not update the store
;; to reflect this.
  store %struct.eggs* null, %struct.eggs** %foo
  unreachable
}

declare void @baz()


define void @a() {
; CHECK-LABEL: @a(
; CHECK-NEXT:  b:
; CHECK-NEXT:    br label [[C:%.*]]
; CHECK:       c:
; CHECK-NEXT:    store i64 undef, i64* null
; CHECK-NEXT:    br label [[E:%.*]]
; CHECK:       e:
; CHECK-NEXT:    [[G:%.*]] = load i64*, i64** null
; CHECK-NEXT:    store i64* undef, i64** null
; CHECK-NEXT:    br i1 undef, label [[C]], label [[E]]
;
b:
  br label %c

c:                                                ; preds = %e, %b
  %d = phi i64* [ undef, %b ], [ null, %e ]
  store i64 undef, i64* %d
  br label %e

e:                                                ; preds = %e, %c
;; The memory for this load starts out equivalent to just the store in c, we later discover the store after us, and
;; need to make sure the right set of values get marked as changed after memory leaders change
  %g = load i64*, i64** null
  %0 = bitcast i64* %g to i64*
  store i64* undef, i64** null
  br i1 undef, label %c, label %e
}

%struct.hoge = type {}

define void @widget(%struct.hoge* %arg) {
; CHECK-LABEL: @widget(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    br label [[BB1:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[TMP:%.*]] = phi %struct.hoge* [ [[ARG:%.*]], [[BB:%.*]] ], [ null, [[BB1]] ]
; CHECK-NEXT:    store %struct.hoge* [[TMP]], %struct.hoge** undef
; CHECK-NEXT:    br i1 undef, label [[BB1]], label [[BB2:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    [[TMP3:%.*]] = phi i64 [ [[TMP8:%.*]], [[BB7:%.*]] ], [ 0, [[BB1]] ]
; CHECK-NEXT:    [[TMP4:%.*]] = icmp eq i64 [[TMP3]], 0
; CHECK-NEXT:    br i1 [[TMP4]], label [[BB7]], label [[BB5:%.*]]
; CHECK:       bb5:
; CHECK-NEXT:    [[TMP6:%.*]] = load i64, i64* null
; CHECK-NEXT:    call void @quux()
; CHECK-NEXT:    store i64 [[TMP6]], i64* undef
; CHECK-NEXT:    br label [[BB7]]
; CHECK:       bb7:
; CHECK-NEXT:    [[TMP8]] = add i64 [[TMP3]], 1
; CHECK-NEXT:    br label [[BB2]]
;
bb:
  br label %bb1

bb1:                                              ; preds = %bb1, %bb
  %tmp = phi %struct.hoge* [ %arg, %bb ], [ null, %bb1 ]
  store %struct.hoge* %tmp, %struct.hoge** undef
  br i1 undef, label %bb1, label %bb2

bb2:                                              ; preds = %bb7, %bb1
  %tmp3 = phi i64 [ %tmp8, %bb7 ], [ 0, %bb1 ]
  %tmp4 = icmp eq i64 %tmp3, 0
  br i1 %tmp4, label %bb7, label %bb5

bb5:                                              ; preds = %bb2
  ;; Originally thought equal to the store that comes after it until the phi edges
  ;; are completely traversed
  %tmp6 = load i64, i64* null
  call void @quux()
  store i64 %tmp6, i64* undef
  br label %bb7

bb7:                                              ; preds = %bb5, %bb2
  %tmp8 = add i64 %tmp3, 1
  br label %bb2
}

declare void @quux()

%struct.a = type {}

define void @b() {
; CHECK-LABEL: @b(
; CHECK-NEXT:    [[C:%.*]] = alloca [[STRUCT_A:%.*]]
; CHECK-NEXT:    br label [[D:%.*]]
; CHECK:       m:
; CHECK-NEXT:    unreachable
; CHECK:       d:
; CHECK-NEXT:    [[G:%.*]] = bitcast %struct.a* [[C]] to i8*
; CHECK-NEXT:    [[F:%.*]] = bitcast i8* [[G]] to i32*
; CHECK-NEXT:    [[E:%.*]] = load i32, i32* [[F]]
; CHECK-NEXT:    br i1 undef, label [[I:%.*]], label [[J:%.*]]
; CHECK:       i:
; CHECK-NEXT:    br i1 undef, label [[K:%.*]], label [[M:%.*]]
; CHECK:       k:
; CHECK-NEXT:    br label [[L:%.*]]
; CHECK:       l:
; CHECK-NEXT:    unreachable
; CHECK:       j:
; CHECK-NEXT:    br label [[M]]
;
  %c = alloca %struct.a
  br label %d

m:                                                ; preds = %j, %i
  store i32 %e, i32* %f
  unreachable

d:                                                ; preds = %0
  %g = bitcast %struct.a* %c to i8*
  %h = getelementptr i8, i8* %g
  %f = bitcast i8* %h to i32*
  %e = load i32, i32* %f
  br i1 undef, label %i, label %j

i:                                                ; preds = %d
  br i1 undef, label %k, label %m

k:                                                ; preds = %i
  br label %l

l:                                                ; preds = %k
  %n = phi i32 [ %e, %k ]
  ;; Becomes equal and then not equal to the other store, and
  ;; along the way, the load.
  store i32 %n, i32* %f
  unreachable

j:                                                ; preds = %d
  br label %m
}
