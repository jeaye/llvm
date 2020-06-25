; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-- -mattr=+sse | FileCheck %s --check-prefix=SSE
; RUN: llc < %s -mtriple=i686-- -mattr=+avx | FileCheck %s --check-prefix=SSE
; RUN: llc < %s -mtriple=i686-- -mattr=+sse,+prfchw | FileCheck %s -check-prefix=PRFCHWSSE
; RUN: llc < %s -mtriple=i686-- -mattr=+prfchw | FileCheck %s -check-prefix=PRFCHWSSE
; RUN: llc < %s -mtriple=i686-- -mcpu=slm | FileCheck %s -check-prefix=PRFCHWSSE
; RUN: llc < %s -mtriple=i686-- -mcpu=btver2 | FileCheck %s -check-prefix=PRFCHWSSE
; RUN: llc < %s -mtriple=i686-- -mcpu=btver2 -mattr=-prfchw | FileCheck %s -check-prefix=SSE
; RUN: llc < %s -mtriple=i686-- -mattr=+sse,+prefetchwt1 | FileCheck %s -check-prefix=PREFETCHWT1
; RUN: llc < %s -mtriple=i686-- -mattr=-sse,+prefetchwt1 | FileCheck %s -check-prefix=PREFETCHWT1
; RUN: llc < %s -mtriple=i686-- -mattr=-sse,+3dnow,+prefetchwt1 | FileCheck %s -check-prefix=PREFETCHWT1
; RUN: llc < %s -mtriple=i686-- -mattr=+3dnow | FileCheck %s -check-prefix=3DNOW
; RUN: llc < %s -mtriple=i686-- -mattr=+3dnow,+prfchw | FileCheck %s -check-prefix=3DNOW

; Rules:
; 3dnow by itself get you just the single prefetch instruction with no hints
; sse provides prefetch0/1/2/nta
; supporting prefetchw, but not 3dnow implicitly provides prefetcht0/1/2/nta regardless of sse setting as we need something to fall back to for the non-write hint.
; supporting prefetchwt1 implies prefetcht0/1/2/nta and prefetchw regardless of other settings. this allows levels for non-write and gives us an instruction for write+T0
; 3dnow prefetch instruction will only get used if you have no other prefetch instructions enabled

; rdar://10538297

define void @t(i8* %ptr) nounwind  {
; SSE-LABEL: t:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SSE-NEXT:    prefetcht2 (%eax)
; SSE-NEXT:    prefetcht1 (%eax)
; SSE-NEXT:    prefetcht0 (%eax)
; SSE-NEXT:    prefetchnta (%eax)
; SSE-NEXT:    prefetcht2 (%eax)
; SSE-NEXT:    prefetcht1 (%eax)
; SSE-NEXT:    prefetcht0 (%eax)
; SSE-NEXT:    prefetchnta (%eax)
; SSE-NEXT:    retl
;
; PRFCHWSSE-LABEL: t:
; PRFCHWSSE:       # %bb.0: # %entry
; PRFCHWSSE-NEXT:    movl {{[0-9]+}}(%esp), %eax
; PRFCHWSSE-NEXT:    prefetcht2 (%eax)
; PRFCHWSSE-NEXT:    prefetcht1 (%eax)
; PRFCHWSSE-NEXT:    prefetcht0 (%eax)
; PRFCHWSSE-NEXT:    prefetchnta (%eax)
; PRFCHWSSE-NEXT:    prefetchw (%eax)
; PRFCHWSSE-NEXT:    prefetchw (%eax)
; PRFCHWSSE-NEXT:    prefetchw (%eax)
; PRFCHWSSE-NEXT:    prefetchw (%eax)
; PRFCHWSSE-NEXT:    retl
;
; PREFETCHWT1-LABEL: t:
; PREFETCHWT1:       # %bb.0: # %entry
; PREFETCHWT1-NEXT:    movl {{[0-9]+}}(%esp), %eax
; PREFETCHWT1-NEXT:    prefetcht2 (%eax)
; PREFETCHWT1-NEXT:    prefetcht1 (%eax)
; PREFETCHWT1-NEXT:    prefetcht0 (%eax)
; PREFETCHWT1-NEXT:    prefetchnta (%eax)
; PREFETCHWT1-NEXT:    prefetchwt1 (%eax)
; PREFETCHWT1-NEXT:    prefetchwt1 (%eax)
; PREFETCHWT1-NEXT:    prefetchw (%eax)
; PREFETCHWT1-NEXT:    prefetchwt1 (%eax)
; PREFETCHWT1-NEXT:    retl
;
; 3DNOW-LABEL: t:
; 3DNOW:       # %bb.0: # %entry
; 3DNOW-NEXT:    movl {{[0-9]+}}(%esp), %eax
; 3DNOW-NEXT:    prefetch (%eax)
; 3DNOW-NEXT:    prefetch (%eax)
; 3DNOW-NEXT:    prefetch (%eax)
; 3DNOW-NEXT:    prefetch (%eax)
; 3DNOW-NEXT:    prefetchw (%eax)
; 3DNOW-NEXT:    prefetchw (%eax)
; 3DNOW-NEXT:    prefetchw (%eax)
; 3DNOW-NEXT:    prefetchw (%eax)
; 3DNOW-NEXT:    retl
entry:
	tail call void @llvm.prefetch( i8* %ptr, i32 0, i32 1, i32 1 )
	tail call void @llvm.prefetch( i8* %ptr, i32 0, i32 2, i32 1 )
	tail call void @llvm.prefetch( i8* %ptr, i32 0, i32 3, i32 1 )
	tail call void @llvm.prefetch( i8* %ptr, i32 0, i32 0, i32 1 )
	tail call void @llvm.prefetch( i8* %ptr, i32 1, i32 1, i32 1 )
	tail call void @llvm.prefetch( i8* %ptr, i32 1, i32 2, i32 1 )
	tail call void @llvm.prefetch( i8* %ptr, i32 1, i32 3, i32 1 )
	tail call void @llvm.prefetch( i8* %ptr, i32 1, i32 0, i32 1 )
	ret void
}

declare void @llvm.prefetch(i8*, i32, i32, i32) nounwind
