; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -O0 -mtriple=mipsel-linux-gnu -global-isel -stop-after=irtranslator -verify-machineinstrs %s -o - | FileCheck %s -check-prefixes=MIPS32


define void @void() {
  ; MIPS32-LABEL: name: void
  ; MIPS32: bb.1.entry:
  ; MIPS32:   RetRA
entry:
  ret void
}
