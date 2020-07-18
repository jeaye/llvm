; Check that the address sanitizer pass can be reused
; RUN: opt < %s -S -run-twice -asan -enable-new-pm=0
; RUN: opt < %s -S -run-twice -passes='asan-function-pipeline'

define void @foo(i64* %b) nounwind uwtable sanitize_address {
  entry:
  store i64 0, i64* %b, align 1
  ret void
}
