//===----- RegisterEHFrames.h -- Register EH frame sections -----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Support for dynamically registering and deregistering eh-frame sections
// in-process via libunwind.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_EXECUTIONENGINE_ORC_TARGETPROCESS_REGISTEREHFRAMES_H
#define LLVM_EXECUTIONENGINE_ORC_TARGETPROCESS_REGISTEREHFRAMES_H

#include "llvm/ExecutionEngine/Orc/Shared/TargetProcessControlTypes.h"
#include "llvm/Support/Error.h"

namespace llvm {
namespace orc {

/// Register frames in the given eh-frame section with libunwind.
Error registerEHFrameSection(const void *EHFrameSectionAddr,
                             size_t EHFrameSectionSize);

/// Unregister frames in the given eh-frame section with libunwind.
Error deregisterEHFrameSection(const void *EHFrameSectionAddr,
                               size_t EHFrameSectionSize);

} // end namespace orc
} // end namespace llvm

extern "C" llvm::orc::tpctypes::CWrapperFunctionResult
llvm_orc_registerEHFrameSectionWrapper(uint8_t *Data, uint64_t Size);

extern "C" llvm::orc::tpctypes::CWrapperFunctionResult
llvm_orc_deregisterEHFrameSectionWrapper(uint8_t *Data, uint64_t Size);

#endif // LLVM_EXECUTIONENGINE_ORC_TARGETPROCESS_REGISTEREHFRAMES_H
