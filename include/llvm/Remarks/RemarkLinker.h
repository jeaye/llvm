//===-- llvm/Remarks/RemarkLinker.h -----------------------------*- C++/-*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file provides an interface to link together multiple remark files.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_REMARKS_REMARK_LINKER_H
#define LLVM_REMARKS_REMARK_LINKER_H

#include "llvm/Object/ObjectFile.h"
#include "llvm/Remarks/Remark.h"
#include "llvm/Remarks/RemarkFormat.h"
#include "llvm/Remarks/RemarkStringTable.h"
#include "llvm/Support/Error.h"
#include <memory>
#include <set>

namespace llvm {
namespace remarks {

struct RemarkLinker {
private:
  /// Compare through the pointers.
  struct RemarkPtrCompare {
    bool operator()(const std::unique_ptr<Remark> &LHS,
                    const std::unique_ptr<Remark> &RHS) const {
      assert(LHS && RHS && "Invalid pointers to compare.");
      return *LHS < *RHS;
    };
  };

  /// The main string table for the remarks.
  /// Note: all remarks should use the strings from this string table to avoid
  /// dangling references.
  StringTable StrTab;

  /// A set holding unique remarks.
  /// FIXME: std::set is probably not the most appropriate data structure here.
  /// Due to the limitation of having a move-only key, there isn't another
  /// obvious choice for now.
  std::set<std::unique_ptr<Remark>, RemarkPtrCompare> Remarks;

  /// A path to append before the external file path found in remark metadata.
  Optional<std::string> PrependPath;

  /// Keep this remark. If it's already in the set, discard it.
  Remark &keep(std::unique_ptr<Remark> Remark);

public:
  /// Set a path to prepend to the external file path.
  void setExternalFilePrependPath(StringRef PrependPath);

  /// Link the remarks found in \p Buffer.
  /// If \p RemarkFormat is not provided, try to deduce it from the metadata in
  /// \p Buffer.
  /// \p Buffer can be either a standalone remark container or just
  /// metadata. This takes care of uniquing and merging the remarks.
  Error link(StringRef Buffer, Optional<Format> RemarkFormat = None);

  /// Link the remarks found in \p Obj by looking for the right section and
  /// calling the method above.
  Error link(const object::ObjectFile &Obj,
             Optional<Format> RemarkFormat = None);

  /// Serialize the linked remarks to the stream \p OS, using the format \p
  /// RemarkFormat.
  /// This clears internal state such as the string table.
  /// Note: this implies that the serialization mode is standalone.
  Error serialize(raw_ostream &OS, Format RemarksFormat) const;

  /// Check whether there are any remarks linked.
  bool empty() const { return Remarks.empty(); }

  /// Return a collection of the linked unique remarks to iterate on.
  /// Ex:
  /// for (const Remark &R : RL.remarks() { [...] }
  using iterator = pointee_iterator<decltype(Remarks)::const_iterator>;

  iterator_range<iterator> remarks() const {
    return {Remarks.begin(), Remarks.end()};
  }
};

/// Returns a buffer with the contents of the remarks section depending on the
/// format of the file. If the section doesn't exist, this returns an empty
/// optional.
Expected<Optional<StringRef>>
getRemarksSectionContents(const object::ObjectFile &Obj);

} // end namespace remarks
} // end namespace llvm

#endif /* LLVM_REMARKS_REMARK_LINKER_H */
