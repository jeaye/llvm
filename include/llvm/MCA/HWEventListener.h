//===----------------------- HWEventListener.h ------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
/// \file
///
/// This file defines the main interface for hardware event listeners.
///
//===----------------------------------------------------------------------===//

#ifndef LLVM_MCA_HWEVENTLISTENER_H
#define LLVM_MCA_HWEVENTLISTENER_H

#include "llvm/ADT/ArrayRef.h"
#include "llvm/MCA/Instruction.h"
#include "llvm/MCA/Support.h"

namespace llvm {
namespace mca {

// An HWInstructionEvent represents state changes of instructions that
// listeners might be interested in. Listeners can choose to ignore any event
// they are not interested in.
class HWInstructionEvent {
public:
  // This is the list of event types that are shared by all targets, that
  // generic subtarget-agnostic classes (e.g., Pipeline, HWInstructionEvent,
  // ...) and generic Views can manipulate.
  // Subtargets are free to define additional event types, that are goin to be
  // handled by generic components as opaque values, but can still be
  // emitted by subtarget-specific pipeline stages (e.g., ExecuteStage,
  // DispatchStage, ...) and interpreted by subtarget-specific EventListener
  // implementations.
  enum GenericEventType {
    Invalid = 0,
    // Events generated by the Retire Control Unit.
    Retired,
    // Events generated by the Scheduler.
    Pending,
    Ready,
    Issued,
    Executed,
    // Events generated by the Dispatch logic.
    Dispatched,

    LastGenericEventType,
  };

  HWInstructionEvent(unsigned type, const InstRef &Inst)
      : Type(type), IR(Inst) {}

  // The event type. The exact meaning depends on the subtarget.
  const unsigned Type;

  // The instruction this event was generated for.
  const InstRef &IR;
};

using ResourceRef = std::pair<uint64_t, uint64_t>;
using ResourceUse = std::pair<ResourceRef, ResourceCycles>;

class HWInstructionIssuedEvent : public HWInstructionEvent {
public:
  HWInstructionIssuedEvent(const InstRef &IR, ArrayRef<ResourceUse> UR)
      : HWInstructionEvent(HWInstructionEvent::Issued, IR), UsedResources(UR) {}

  ArrayRef<ResourceUse> UsedResources;
};

class HWInstructionDispatchedEvent : public HWInstructionEvent {
public:
  HWInstructionDispatchedEvent(const InstRef &IR, ArrayRef<unsigned> Regs,
                               unsigned UOps)
      : HWInstructionEvent(HWInstructionEvent::Dispatched, IR),
        UsedPhysRegs(Regs), MicroOpcodes(UOps) {}
  // Number of physical register allocated for this instruction. There is one
  // entry per register file.
  ArrayRef<unsigned> UsedPhysRegs;
  // Number of micro opcodes dispatched.
  // This field is often set to the total number of micro-opcodes specified by
  // the instruction descriptor of IR.
  // The only exception is when IR declares a number of micro opcodes
  // which exceeds the processor DispatchWidth, and - by construction - it
  // requires multiple cycles to be fully dispatched. In that particular case,
  // the dispatch logic would generate more than one dispatch event (one per
  // cycle), and each event would declare how many micro opcodes are effectively
  // been dispatched to the schedulers.
  unsigned MicroOpcodes;
};

class HWInstructionRetiredEvent : public HWInstructionEvent {
public:
  HWInstructionRetiredEvent(const InstRef &IR, ArrayRef<unsigned> Regs)
      : HWInstructionEvent(HWInstructionEvent::Retired, IR),
        FreedPhysRegs(Regs) {}
  // Number of register writes that have been architecturally committed. There
  // is one entry per register file.
  ArrayRef<unsigned> FreedPhysRegs;
};

// A HWStallEvent represents a pipeline stall caused by the lack of hardware
// resources.
class HWStallEvent {
public:
  enum GenericEventType {
    Invalid = 0,
    // Generic stall events generated by the DispatchStage.
    RegisterFileStall,
    RetireControlUnitStall,
    // Generic stall events generated by the Scheduler.
    DispatchGroupStall,
    SchedulerQueueFull,
    LoadQueueFull,
    StoreQueueFull,
    LastGenericEvent
  };

  HWStallEvent(unsigned type, const InstRef &Inst) : Type(type), IR(Inst) {}

  // The exact meaning of the stall event type depends on the subtarget.
  const unsigned Type;

  // The instruction this event was generated for.
  const InstRef &IR;
};

// A HWPressureEvent describes an increase in backend pressure caused by
// the presence of data dependencies or unavailability of pipeline resources.
class HWPressureEvent {
public:
  enum GenericReason {
    INVALID = 0,
    // Scheduler was unable to issue all the ready instructions because some
    // pipeline resources were unavailable.
    RESOURCES,
    // Instructions could not be issued because of register data dependencies.
    REGISTER_DEPS,
    // Instructions could not be issued because of memory dependencies.
    MEMORY_DEPS
  };

  HWPressureEvent(GenericReason reason, ArrayRef<InstRef> Insts,
                  uint64_t Mask = 0)
      : Reason(reason), AffectedInstructions(Insts), ResourceMask(Mask) {}

  // Reason for this increase in backend pressure.
  GenericReason Reason;

  // Instructions affected (i.e. delayed) by this increase in backend pressure.
  ArrayRef<InstRef> AffectedInstructions;

  // A mask of unavailable processor resources.
  const uint64_t ResourceMask;
};

class HWEventListener {
public:
  // Generic events generated by the pipeline.
  virtual void onCycleBegin() {}
  virtual void onCycleEnd() {}

  virtual void onEvent(const HWInstructionEvent &Event) {}
  virtual void onEvent(const HWStallEvent &Event) {}
  virtual void onEvent(const HWPressureEvent &Event) {}

  virtual void onResourceAvailable(const ResourceRef &RRef) {}

  // Events generated by the Scheduler when buffered resources are
  // consumed/freed for an instruction.
  virtual void onReservedBuffers(const InstRef &Inst,
                                 ArrayRef<unsigned> Buffers) {}
  virtual void onReleasedBuffers(const InstRef &Inst,
                                 ArrayRef<unsigned> Buffers) {}

  virtual ~HWEventListener() {}

private:
  virtual void anchor();
};
} // namespace mca
} // namespace llvm

#endif // LLVM_MCA_HWEVENTLISTENER_H
