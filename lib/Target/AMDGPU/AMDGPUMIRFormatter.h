//===-- llvm/Target/AMDGPU/AMDGPUMIRFormatter.h -----------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
/// \file
/// AMDGPU specific overrides of MIRFormatter.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_AMDGPUMIRFORMATTER_H
#define LLVM_LIB_TARGET_AMDGPUMIRFORMATTER_H

#include "llvm/ADT/Optional.h"
#include "llvm/CodeGen/MIRFormatter.h"
#include "llvm/CodeGen/PseudoSourceValue.h"
#include "llvm/Support/raw_ostream.h"
#include <cstdint>

namespace llvm {

class MachineFunction;
class MachineInstr;
struct PerFunctionMIParsingState;
struct SlotMapping;

class AMDGPUMIRFormatter final : public MIRFormatter {
public:
  AMDGPUMIRFormatter() {}
  virtual ~AMDGPUMIRFormatter() = default;

  /// Implement target specific parsing of target custom pseudo source value.
  virtual bool
  parseCustomPseudoSourceValue(StringRef Src, MachineFunction &MF,
                               PerFunctionMIParsingState &PFS,
                               const PseudoSourceValue *&PSV,
                               ErrorCallbackType ErrorCallback) const override;
};

} // end namespace llvm

#endif
