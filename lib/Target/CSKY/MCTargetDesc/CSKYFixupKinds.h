//===-- CSKYFixupKinds.h - CSKY Specific Fixup Entries ----------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_CSKY_MCTARGETDESC_CSKYFIXUPKINDS_H
#define LLVM_LIB_TARGET_CSKY_MCTARGETDESC_CSKYFIXUPKINDS_H

#include "llvm/MC/MCFixup.h"

namespace llvm {
namespace CSKY {
enum Fixups {
  fixup_csky_addr32 = FirstTargetFixupKind,

  fixup_csky_pcrel_imm16_scale2,

  fixup_csky_pcrel_uimm16_scale4,

  fixup_csky_pcrel_imm26_scale2,

  fixup_csky_pcrel_imm18_scale2,

  // Marker
  fixup_csky_invalid,
  NumTargetFixupKinds = fixup_csky_invalid - FirstTargetFixupKind
};
} // end namespace CSKY
} // end namespace llvm

#endif // LLVM_LIB_TARGET_CSKY_MCTARGETDESC_CSKYFIXUPKINDS_H
