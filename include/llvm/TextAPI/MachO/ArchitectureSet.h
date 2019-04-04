//===- llvm/TextAPI/MachO/ArchitectureSet.h - ArchitectureSet ---*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Defines the architecture set.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_TEXTAPI_MACHO_ARCHITECTURE_SET_H
#define LLVM_TEXTAPI_MACHO_ARCHITECTURE_SET_H

#include "llvm/Support/raw_ostream.h"
#include "llvm/TextAPI/MachO/Architecture.h"
#include <cstddef>
#include <iterator>
#include <limits>
#include <vector>

namespace llvm {
namespace MachO {

class ArchitectureSet {
private:
  using ArchSetType = uint32_t;

  const static ArchSetType EndIndexVal =
      std::numeric_limits<ArchSetType>::max();
  ArchSetType ArchSet{0};

public:
  constexpr ArchitectureSet() = default;
  constexpr ArchitectureSet(ArchSetType Raw) : ArchSet(Raw) {}
  ArchitectureSet(Architecture Arch) : ArchitectureSet() { set(Arch); }
  ArchitectureSet(const std::vector<Architecture> &Archs);

  void set(Architecture Arch) {
    if (Arch == AK_unknown)
      return;
    ArchSet |= 1U << static_cast<int>(Arch);
  }

  void clear(Architecture Arch) { ArchSet &= ~(1U << static_cast<int>(Arch)); }

  bool has(Architecture Arch) const {
    return ArchSet & (1U << static_cast<int>(Arch));
  }

  bool contains(ArchitectureSet Archs) const {
    return (ArchSet & Archs.ArchSet) == Archs.ArchSet;
  }

  size_t count() const;

  bool empty() const { return ArchSet == 0; }

  ArchSetType rawValue() const { return ArchSet; }

  template <typename Ty>
  class arch_iterator
      : public std::iterator<std::forward_iterator_tag, Architecture, size_t> {
  private:
    ArchSetType Index;
    Ty *ArchSet;

    void findNextSetBit() {
      if (Index == EndIndexVal)
        return;

      do {
        if (*ArchSet & (1UL << ++Index))
          return;
      } while (Index < sizeof(Ty) * 8);

      Index = EndIndexVal;
    }

  public:
    arch_iterator(Ty *ArchSet, ArchSetType Index = 0)
        : Index(Index), ArchSet(ArchSet) {
      if (Index != EndIndexVal && !(*ArchSet & (1UL << Index)))
        findNextSetBit();
    }

    Architecture operator*() const { return static_cast<Architecture>(Index); }

    arch_iterator &operator++() {
      findNextSetBit();
      return *this;
    }

    arch_iterator operator++(int) {
      auto tmp = *this;
      findNextSetBit();
      return tmp;
    }

    bool operator==(const arch_iterator &o) const {
      return std::tie(Index, ArchSet) == std::tie(o.Index, o.ArchSet);
    }

    bool operator!=(const arch_iterator &o) const { return !(*this == o); }
  };

  ArchitectureSet operator&(const ArchitectureSet &o) {
    return {ArchSet & o.ArchSet};
  }

  ArchitectureSet operator|(const ArchitectureSet &o) {
    return {ArchSet | o.ArchSet};
  }

  ArchitectureSet &operator|=(const ArchitectureSet &o) {
    ArchSet |= o.ArchSet;
    return *this;
  }

  ArchitectureSet &operator|=(const Architecture &Arch) {
    set(Arch);
    return *this;
  }

  bool operator==(const ArchitectureSet &o) const {
    return ArchSet == o.ArchSet;
  }

  bool operator!=(const ArchitectureSet &o) const {
    return ArchSet != o.ArchSet;
  }

  bool operator<(const ArchitectureSet &o) const { return ArchSet < o.ArchSet; }

  using iterator = arch_iterator<ArchSetType>;
  using const_iterator = arch_iterator<const ArchSetType>;

  iterator begin() { return {&ArchSet}; }
  iterator end() { return {&ArchSet, EndIndexVal}; }

  const_iterator begin() const { return {&ArchSet}; }
  const_iterator end() const { return {&ArchSet, EndIndexVal}; }

  operator std::string() const;
  operator std::vector<Architecture>() const;
  void print(raw_ostream &OS) const;
};

inline ArchitectureSet operator|(const Architecture &lhs,
                                 const Architecture &rhs) {
  return ArchitectureSet(lhs) | ArchitectureSet(rhs);
}

raw_ostream &operator<<(raw_ostream &OS, ArchitectureSet Set);

} // end namespace MachO.
} // end namespace llvm.

#endif // LLVM_TEXTAPI_MACHO_ARCHITECTURE_SET_H
