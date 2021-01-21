//===--------------------- ResourcePressureView.h ---------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
/// \file
///
/// This file define class ResourcePressureView.
/// Class ResourcePressureView observes hardware events generated by
/// the Pipeline object and collects statistics related to resource usage at
/// instruction granularity.
/// Resource pressure information is then printed out to a stream in the
/// form of a table like the one from the example below:
///
/// Resources:
/// [0] - JALU0
/// [1] - JALU1
/// [2] - JDiv
/// [3] - JFPM
/// [4] - JFPU0
/// [5] - JFPU1
/// [6] - JLAGU
/// [7] - JSAGU
/// [8] - JSTC
/// [9] - JVIMUL
///
/// Resource pressure per iteration:
/// [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]
/// 0.00   0.00   0.00   0.00   2.00   2.00   0.00   0.00   0.00   0.00
///
/// Resource pressure by instruction:
/// [0]  [1]  [2]  [3]  [4]  [5]  [6]  [7]  [8]  [9]  Instructions:
///  -    -    -    -    -   1.00  -    -    -    -   vpermilpd  $1,    %xmm0,
///  %xmm1
///  -    -    -    -   1.00  -    -    -    -    -   vaddps     %xmm0, %xmm1,
///  %xmm2
///  -    -    -    -    -   1.00  -    -    -    -   vmovshdup  %xmm2, %xmm3
///  -    -    -    -   1.00  -    -    -    -    -   vaddss     %xmm2, %xmm3,
///  %xmm4
///
/// In this example, we have AVX code executed on AMD Jaguar (btver2).
/// Both shuffles and vector floating point add operations on XMM registers have
/// a reciprocal throughput of 1cy.
/// Each add is issued to pipeline JFPU0, while each shuffle is issued to
/// pipeline JFPU1. The overall pressure per iteration is reported by two
/// tables: the first smaller table is the resource pressure per iteration;
/// the second table reports resource pressure per instruction. Values are the
/// average resource cycles consumed by an instruction.
/// Every vector add from the example uses resource JFPU0 for an average of 1cy
/// per iteration. Consequently, the resource pressure on JFPU0 is of 2cy per
/// iteration.
///
//===----------------------------------------------------------------------===//

#ifndef LLVM_TOOLS_LLVM_MCA_RESOURCEPRESSUREVIEW_H
#define LLVM_TOOLS_LLVM_MCA_RESOURCEPRESSUREVIEW_H

#include "Views/InstructionView.h"
#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCInstPrinter.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/Support/JSON.h"

namespace llvm {
namespace mca {

/// This class collects resource pressure statistics and it is able to print
/// out all the collected information as a table to an output stream.
class ResourcePressureView : public InstructionView {
  unsigned LastInstructionIdx;

  // Map to quickly obtain the ResourceUsage column index from a processor
  // resource ID.
  llvm::DenseMap<unsigned, unsigned> Resource2VecIndex;

  // Table of resources used by instructions.
  std::vector<ResourceCycles> ResourceUsage;
  unsigned NumResourceUnits;

  void printResourcePressurePerIter(llvm::raw_ostream &OS) const;
  void printResourcePressurePerInst(llvm::raw_ostream &OS) const;

public:
  ResourcePressureView(const llvm::MCSubtargetInfo &sti,
                       llvm::MCInstPrinter &Printer,
                       llvm::ArrayRef<llvm::MCInst> S);

  void onEvent(const HWInstructionEvent &Event) override;
  void printView(llvm::raw_ostream &OS) const override {
    printResourcePressurePerIter(OS);
    printResourcePressurePerInst(OS);
  }
  StringRef getNameAsString() const override { return "ResourcePressureView"; }
  json::Value toJSON() const;
};
} // namespace mca
} // namespace llvm

#endif
