//===- ELFYAML.h - ELF YAMLIO implementation --------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
///
/// \file
/// This file declares classes for handling the YAML representation
/// of ELF.
///
//===----------------------------------------------------------------------===//

#ifndef LLVM_OBJECTYAML_ELFYAML_H
#define LLVM_OBJECTYAML_ELFYAML_H

#include "llvm/ADT/StringRef.h"
#include "llvm/ObjectYAML/YAML.h"
#include "llvm/Support/YAMLTraits.h"
#include <cstdint>
#include <memory>
#include <vector>

namespace llvm {
namespace ELFYAML {

StringRef dropUniqueSuffix(StringRef S);

// These types are invariant across 32/64-bit ELF, so for simplicity just
// directly give them their exact sizes. We don't need to worry about
// endianness because these are just the types in the YAMLIO structures,
// and are appropriately converted to the necessary endianness when
// reading/generating binary object files.
// The naming of these types is intended to be ELF_PREFIX, where PREFIX is
// the common prefix of the respective constants. E.g. ELF_EM corresponds
// to the `e_machine` constants, like `EM_X86_64`.
// In the future, these would probably be better suited by C++11 enum
// class's with appropriate fixed underlying type.
LLVM_YAML_STRONG_TYPEDEF(uint16_t, ELF_ET)
LLVM_YAML_STRONG_TYPEDEF(uint32_t, ELF_PT)
LLVM_YAML_STRONG_TYPEDEF(uint32_t, ELF_EM)
LLVM_YAML_STRONG_TYPEDEF(uint8_t, ELF_ELFCLASS)
LLVM_YAML_STRONG_TYPEDEF(uint8_t, ELF_ELFDATA)
LLVM_YAML_STRONG_TYPEDEF(uint8_t, ELF_ELFOSABI)
// Just use 64, since it can hold 32-bit values too.
LLVM_YAML_STRONG_TYPEDEF(uint64_t, ELF_EF)
// Just use 64, since it can hold 32-bit values too.
LLVM_YAML_STRONG_TYPEDEF(uint64_t, ELF_DYNTAG)
LLVM_YAML_STRONG_TYPEDEF(uint32_t, ELF_PF)
LLVM_YAML_STRONG_TYPEDEF(uint32_t, ELF_SHT)
LLVM_YAML_STRONG_TYPEDEF(uint32_t, ELF_REL)
LLVM_YAML_STRONG_TYPEDEF(uint8_t, ELF_RSS)
// Just use 64, since it can hold 32-bit values too.
LLVM_YAML_STRONG_TYPEDEF(uint64_t, ELF_SHF)
LLVM_YAML_STRONG_TYPEDEF(uint16_t, ELF_SHN)
LLVM_YAML_STRONG_TYPEDEF(uint8_t, ELF_STB)
LLVM_YAML_STRONG_TYPEDEF(uint8_t, ELF_STT)

LLVM_YAML_STRONG_TYPEDEF(uint8_t, MIPS_AFL_REG)
LLVM_YAML_STRONG_TYPEDEF(uint8_t, MIPS_ABI_FP)
LLVM_YAML_STRONG_TYPEDEF(uint32_t, MIPS_AFL_EXT)
LLVM_YAML_STRONG_TYPEDEF(uint32_t, MIPS_AFL_ASE)
LLVM_YAML_STRONG_TYPEDEF(uint32_t, MIPS_AFL_FLAGS1)
LLVM_YAML_STRONG_TYPEDEF(uint32_t, MIPS_ISA)

LLVM_YAML_STRONG_TYPEDEF(StringRef, YAMLFlowString)

// For now, hardcode 64 bits everywhere that 32 or 64 would be needed
// since 64-bit can hold 32-bit values too.
struct FileHeader {
  ELF_ELFCLASS Class;
  ELF_ELFDATA Data;
  ELF_ELFOSABI OSABI;
  llvm::yaml::Hex8 ABIVersion;
  ELF_ET Type;
  ELF_EM Machine;
  ELF_EF Flags;
  llvm::yaml::Hex64 Entry;

  Optional<llvm::yaml::Hex16> SHEntSize;
  Optional<llvm::yaml::Hex64> SHOff;
  Optional<llvm::yaml::Hex16> SHNum;
  Optional<llvm::yaml::Hex16> SHStrNdx;
};

struct SectionName {
  StringRef Section;
};

struct ProgramHeader {
  ELF_PT Type;
  ELF_PF Flags;
  llvm::yaml::Hex64 VAddr;
  llvm::yaml::Hex64 PAddr;
  Optional<llvm::yaml::Hex64> Align;
  Optional<llvm::yaml::Hex64> FileSize;
  Optional<llvm::yaml::Hex64> MemSize;
  Optional<llvm::yaml::Hex64> Offset;
  std::vector<SectionName> Sections;
};

struct Symbol {
  StringRef Name;
  Optional<uint32_t> NameIndex;
  ELF_STT Type;
  StringRef Section;
  Optional<ELF_SHN> Index;
  ELF_STB Binding;
  llvm::yaml::Hex64 Value;
  llvm::yaml::Hex64 Size;
  Optional<uint8_t> Other;
};

struct SectionOrType {
  StringRef sectionNameOrType;
};

struct DynamicEntry {
  ELF_DYNTAG Tag;
  llvm::yaml::Hex64 Val;
};

struct StackSizeEntry {
  llvm::yaml::Hex64 Address;
  llvm::yaml::Hex64 Size;
};

struct NoteEntry {
  StringRef Name;
  yaml::BinaryRef Desc;
  llvm::yaml::Hex32 Type;
};

struct Chunk {
  enum class ChunkKind {
    Dynamic,
    Group,
    RawContent,
    Relocation,
    NoBits,
    Note,
    Hash,
    GnuHash,
    Verdef,
    Verneed,
    StackSizes,
    SymtabShndxSection,
    Symver,
    MipsABIFlags,
    Addrsig,
    Fill,
    LinkerOptions,
    DependentLibraries,
  };

  ChunkKind Kind;
  StringRef Name;

  Chunk(ChunkKind K) : Kind(K) {}
  virtual ~Chunk();
};

struct Section : public Chunk {
  ELF_SHT Type;
  Optional<ELF_SHF> Flags;
  llvm::yaml::Hex64 Address;
  StringRef Link;
  llvm::yaml::Hex64 AddressAlign;
  Optional<llvm::yaml::Hex64> EntSize;

  // Usually sections are not created implicitly, but loaded from YAML.
  // When they are, this flag is used to signal about that.
  bool IsImplicit;

  Section(ChunkKind Kind, bool IsImplicit = false)
      : Chunk(Kind), IsImplicit(IsImplicit) {}

  static bool classof(const Chunk *S) { return S->Kind != ChunkKind::Fill; }

  // The following members are used to override section fields which is
  // useful for creating invalid objects.

  // This can be used to override the offset stored in the sh_name field.
  // It does not affect the name stored in the string table.
  Optional<llvm::yaml::Hex64> ShName;

  // This can be used to override the sh_offset field. It does not place the
  // section data at the offset specified.
  Optional<llvm::yaml::Hex64> ShOffset;

  // This can be used to override the sh_size field. It does not affect the
  // content written.
  Optional<llvm::yaml::Hex64> ShSize;
};

// Fill is a block of data which is placed outside of sections. It is
// not present in the sections header table, but it might affect the output file
// size and program headers produced.
struct Fill : Chunk {
  Optional<yaml::BinaryRef> Pattern;
  llvm::yaml::Hex64 Size;

  // We have to remember the offset of the fill, because it does not have
  // a corresponding section header, unlike a section. We might need this
  // information when writing the output.
  uint64_t ShOffset;

  Fill() : Chunk(ChunkKind::Fill) {}

  static bool classof(const Chunk *S) { return S->Kind == ChunkKind::Fill; }
};

struct StackSizesSection : Section {
  Optional<yaml::BinaryRef> Content;
  Optional<llvm::yaml::Hex64> Size;
  Optional<std::vector<StackSizeEntry>> Entries;

  StackSizesSection() : Section(ChunkKind::StackSizes) {}

  static bool classof(const Chunk *S) {
    return S->Kind == ChunkKind::StackSizes;
  }

  static bool nameMatches(StringRef Name) {
    return Name == ".stack_sizes";
  }
};

struct DynamicSection : Section {
  std::vector<DynamicEntry> Entries;
  Optional<yaml::BinaryRef> Content;

  DynamicSection() : Section(ChunkKind::Dynamic) {}

  static bool classof(const Chunk *S) { return S->Kind == ChunkKind::Dynamic; }
};

struct RawContentSection : Section {
  Optional<yaml::BinaryRef> Content;
  Optional<llvm::yaml::Hex64> Size;
  Optional<llvm::yaml::Hex64> Info;

  RawContentSection() : Section(ChunkKind::RawContent) {}

  static bool classof(const Chunk *S) {
    return S->Kind == ChunkKind::RawContent;
  }
};

struct NoBitsSection : Section {
  llvm::yaml::Hex64 Size;

  NoBitsSection() : Section(ChunkKind::NoBits) {}

  static bool classof(const Chunk *S) { return S->Kind == ChunkKind::NoBits; }
};

struct NoteSection : Section {
  Optional<yaml::BinaryRef> Content;
  Optional<llvm::yaml::Hex64> Size;
  Optional<std::vector<ELFYAML::NoteEntry>> Notes;

  NoteSection() : Section(ChunkKind::Note) {}

  static bool classof(const Chunk *S) { return S->Kind == ChunkKind::Note; }
};

struct HashSection : Section {
  Optional<yaml::BinaryRef> Content;
  Optional<llvm::yaml::Hex64> Size;
  Optional<std::vector<uint32_t>> Bucket;
  Optional<std::vector<uint32_t>> Chain;

  HashSection() : Section(ChunkKind::Hash) {}

  static bool classof(const Chunk *S) { return S->Kind == ChunkKind::Hash; }
};

struct GnuHashHeader {
  // The number of hash buckets.
  // Not used when dumping the object, but can be used to override
  // the real number of buckets when emiting an object from a YAML document.
  Optional<llvm::yaml::Hex32> NBuckets;

  // Index of the first symbol in the dynamic symbol table
  // included in the hash table.
  llvm::yaml::Hex32 SymNdx;

  // The number of words in the Bloom filter.
  // Not used when dumping the object, but can be used to override the real
  // number of words in the Bloom filter when emiting an object from a YAML
  // document.
  Optional<llvm::yaml::Hex32> MaskWords;

  // A shift constant used by the Bloom filter.
  llvm::yaml::Hex32 Shift2;
};

struct GnuHashSection : Section {
  Optional<yaml::BinaryRef> Content;

  Optional<GnuHashHeader> Header;
  Optional<std::vector<llvm::yaml::Hex64>> BloomFilter;
  Optional<std::vector<llvm::yaml::Hex32>> HashBuckets;
  Optional<std::vector<llvm::yaml::Hex32>> HashValues;

  GnuHashSection() : Section(ChunkKind::GnuHash) {}

  static bool classof(const Chunk *S) { return S->Kind == ChunkKind::GnuHash; }
};

struct VernauxEntry {
  uint32_t Hash;
  uint16_t Flags;
  uint16_t Other;
  StringRef Name;
};

struct VerneedEntry {
  uint16_t Version;
  StringRef File;
  std::vector<VernauxEntry> AuxV;
};

struct VerneedSection : Section {
  std::vector<VerneedEntry> VerneedV;
  llvm::yaml::Hex64 Info;

  VerneedSection() : Section(ChunkKind::Verneed) {}

  static bool classof(const Chunk *S) {
    return S->Kind == ChunkKind::Verneed;
  }
};

struct AddrsigSymbol {
  AddrsigSymbol(StringRef N) : Name(N), Index(None) {}
  AddrsigSymbol(llvm::yaml::Hex32 Ndx) : Name(None), Index(Ndx) {}
  AddrsigSymbol() : Name(None), Index(None) {}

  Optional<StringRef> Name;
  Optional<llvm::yaml::Hex32> Index;
};

struct AddrsigSection : Section {
  Optional<yaml::BinaryRef> Content;
  Optional<llvm::yaml::Hex64> Size;
  Optional<std::vector<AddrsigSymbol>> Symbols;

  AddrsigSection() : Section(ChunkKind::Addrsig) {}

  static bool classof(const Chunk *S) { return S->Kind == ChunkKind::Addrsig; }
};

struct LinkerOption {
  StringRef Key;
  StringRef Value;
};

struct LinkerOptionsSection : Section {
  Optional<std::vector<LinkerOption>> Options;
  Optional<yaml::BinaryRef> Content;

  LinkerOptionsSection() : Section(ChunkKind::LinkerOptions) {}

  static bool classof(const Chunk *S) {
    return S->Kind == ChunkKind::LinkerOptions;
  }
};

struct DependentLibrariesSection : Section {
  Optional<std::vector<YAMLFlowString>> Libs;
  Optional<yaml::BinaryRef> Content;

  DependentLibrariesSection() : Section(ChunkKind::DependentLibraries) {}

  static bool classof(const Chunk *S) {
    return S->Kind == ChunkKind::DependentLibraries;
  }
};

struct SymverSection : Section {
  std::vector<uint16_t> Entries;

  SymverSection() : Section(ChunkKind::Symver) {}

  static bool classof(const Chunk *S) { return S->Kind == ChunkKind::Symver; }
};

struct VerdefEntry {
  uint16_t Version;
  uint16_t Flags;
  uint16_t VersionNdx;
  uint32_t Hash;
  std::vector<StringRef> VerNames;
};

struct VerdefSection : Section {
  std::vector<VerdefEntry> Entries;
  llvm::yaml::Hex64 Info;

  VerdefSection() : Section(ChunkKind::Verdef) {}

  static bool classof(const Chunk *S) { return S->Kind == ChunkKind::Verdef; }
};

struct Group : Section {
  // Members of a group contain a flag and a list of section indices
  // that are part of the group.
  std::vector<SectionOrType> Members;
  Optional<StringRef> Signature; /* Info */

  Group() : Section(ChunkKind::Group) {}

  static bool classof(const Chunk *S) { return S->Kind == ChunkKind::Group; }
};

struct Relocation {
  llvm::yaml::Hex64 Offset;
  int64_t Addend;
  ELF_REL Type;
  Optional<StringRef> Symbol;
};

struct RelocationSection : Section {
  std::vector<Relocation> Relocations;
  StringRef RelocatableSec; /* Info */

  RelocationSection() : Section(ChunkKind::Relocation) {}

  static bool classof(const Chunk *S) {
    return S->Kind == ChunkKind::Relocation;
  }
};

struct SymtabShndxSection : Section {
  std::vector<uint32_t> Entries;

  SymtabShndxSection() : Section(ChunkKind::SymtabShndxSection) {}

  static bool classof(const Chunk *S) {
    return S->Kind == ChunkKind::SymtabShndxSection;
  }
};

// Represents .MIPS.abiflags section
struct MipsABIFlags : Section {
  llvm::yaml::Hex16 Version;
  MIPS_ISA ISALevel;
  llvm::yaml::Hex8 ISARevision;
  MIPS_AFL_REG GPRSize;
  MIPS_AFL_REG CPR1Size;
  MIPS_AFL_REG CPR2Size;
  MIPS_ABI_FP FpABI;
  MIPS_AFL_EXT ISAExtension;
  MIPS_AFL_ASE ASEs;
  MIPS_AFL_FLAGS1 Flags1;
  llvm::yaml::Hex32 Flags2;

  MipsABIFlags() : Section(ChunkKind::MipsABIFlags) {}

  static bool classof(const Chunk *S) {
    return S->Kind == ChunkKind::MipsABIFlags;
  }
};

struct Object {
  FileHeader Header;
  std::vector<ProgramHeader> ProgramHeaders;

  // An object might contain output section descriptions as well as
  // custom data that does not belong to any section.
  std::vector<std::unique_ptr<Chunk>> Chunks;

  // Although in reality the symbols reside in a section, it is a lot
  // cleaner and nicer if we read them from the YAML as a separate
  // top-level key, which automatically ensures that invariants like there
  // being a single SHT_SYMTAB section are upheld.
  Optional<std::vector<Symbol>> Symbols;
  std::vector<Symbol> DynamicSymbols;

  std::vector<Section *> getSections() {
    std::vector<Section *> Ret;
    for (const std::unique_ptr<Chunk> &Sec : Chunks)
      if (auto S = dyn_cast<ELFYAML::Section>(Sec.get()))
        Ret.push_back(S);
    return Ret;
  }
};

} // end namespace ELFYAML
} // end namespace llvm

LLVM_YAML_IS_SEQUENCE_VECTOR(llvm::ELFYAML::AddrsigSymbol)
LLVM_YAML_IS_SEQUENCE_VECTOR(llvm::ELFYAML::StackSizeEntry)
LLVM_YAML_IS_SEQUENCE_VECTOR(llvm::ELFYAML::DynamicEntry)
LLVM_YAML_IS_SEQUENCE_VECTOR(llvm::ELFYAML::LinkerOption)
LLVM_YAML_IS_SEQUENCE_VECTOR(llvm::ELFYAML::NoteEntry)
LLVM_YAML_IS_SEQUENCE_VECTOR(llvm::ELFYAML::ProgramHeader)
LLVM_YAML_IS_SEQUENCE_VECTOR(std::unique_ptr<llvm::ELFYAML::Chunk>)
LLVM_YAML_IS_SEQUENCE_VECTOR(llvm::ELFYAML::Symbol)
LLVM_YAML_IS_SEQUENCE_VECTOR(llvm::ELFYAML::VerdefEntry)
LLVM_YAML_IS_SEQUENCE_VECTOR(llvm::ELFYAML::VernauxEntry)
LLVM_YAML_IS_SEQUENCE_VECTOR(llvm::ELFYAML::VerneedEntry)
LLVM_YAML_IS_SEQUENCE_VECTOR(llvm::ELFYAML::Relocation)
LLVM_YAML_IS_SEQUENCE_VECTOR(llvm::ELFYAML::SectionOrType)
LLVM_YAML_IS_SEQUENCE_VECTOR(llvm::ELFYAML::SectionName)

namespace llvm {
namespace yaml {

template <>
struct ScalarEnumerationTraits<ELFYAML::ELF_ET> {
  static void enumeration(IO &IO, ELFYAML::ELF_ET &Value);
};

template <> struct ScalarEnumerationTraits<ELFYAML::ELF_PT> {
  static void enumeration(IO &IO, ELFYAML::ELF_PT &Value);
};

template <>
struct ScalarEnumerationTraits<ELFYAML::ELF_EM> {
  static void enumeration(IO &IO, ELFYAML::ELF_EM &Value);
};

template <>
struct ScalarEnumerationTraits<ELFYAML::ELF_ELFCLASS> {
  static void enumeration(IO &IO, ELFYAML::ELF_ELFCLASS &Value);
};

template <>
struct ScalarEnumerationTraits<ELFYAML::ELF_ELFDATA> {
  static void enumeration(IO &IO, ELFYAML::ELF_ELFDATA &Value);
};

template <>
struct ScalarEnumerationTraits<ELFYAML::ELF_ELFOSABI> {
  static void enumeration(IO &IO, ELFYAML::ELF_ELFOSABI &Value);
};

template <>
struct ScalarBitSetTraits<ELFYAML::ELF_EF> {
  static void bitset(IO &IO, ELFYAML::ELF_EF &Value);
};

template <> struct ScalarBitSetTraits<ELFYAML::ELF_PF> {
  static void bitset(IO &IO, ELFYAML::ELF_PF &Value);
};

template <>
struct ScalarEnumerationTraits<ELFYAML::ELF_SHT> {
  static void enumeration(IO &IO, ELFYAML::ELF_SHT &Value);
};

template <>
struct ScalarBitSetTraits<ELFYAML::ELF_SHF> {
  static void bitset(IO &IO, ELFYAML::ELF_SHF &Value);
};

template <> struct ScalarEnumerationTraits<ELFYAML::ELF_SHN> {
  static void enumeration(IO &IO, ELFYAML::ELF_SHN &Value);
};

template <> struct ScalarEnumerationTraits<ELFYAML::ELF_STB> {
  static void enumeration(IO &IO, ELFYAML::ELF_STB &Value);
};

template <>
struct ScalarEnumerationTraits<ELFYAML::ELF_STT> {
  static void enumeration(IO &IO, ELFYAML::ELF_STT &Value);
};

template <>
struct ScalarEnumerationTraits<ELFYAML::ELF_REL> {
  static void enumeration(IO &IO, ELFYAML::ELF_REL &Value);
};

template <>
struct ScalarEnumerationTraits<ELFYAML::ELF_DYNTAG> {
  static void enumeration(IO &IO, ELFYAML::ELF_DYNTAG &Value);
};

template <>
struct ScalarEnumerationTraits<ELFYAML::ELF_RSS> {
  static void enumeration(IO &IO, ELFYAML::ELF_RSS &Value);
};

template <>
struct ScalarEnumerationTraits<ELFYAML::MIPS_AFL_REG> {
  static void enumeration(IO &IO, ELFYAML::MIPS_AFL_REG &Value);
};

template <>
struct ScalarEnumerationTraits<ELFYAML::MIPS_ABI_FP> {
  static void enumeration(IO &IO, ELFYAML::MIPS_ABI_FP &Value);
};

template <>
struct ScalarEnumerationTraits<ELFYAML::MIPS_AFL_EXT> {
  static void enumeration(IO &IO, ELFYAML::MIPS_AFL_EXT &Value);
};

template <>
struct ScalarEnumerationTraits<ELFYAML::MIPS_ISA> {
  static void enumeration(IO &IO, ELFYAML::MIPS_ISA &Value);
};

template <>
struct ScalarBitSetTraits<ELFYAML::MIPS_AFL_ASE> {
  static void bitset(IO &IO, ELFYAML::MIPS_AFL_ASE &Value);
};

template <>
struct ScalarBitSetTraits<ELFYAML::MIPS_AFL_FLAGS1> {
  static void bitset(IO &IO, ELFYAML::MIPS_AFL_FLAGS1 &Value);
};

template <>
struct MappingTraits<ELFYAML::FileHeader> {
  static void mapping(IO &IO, ELFYAML::FileHeader &FileHdr);
};

template <> struct MappingTraits<ELFYAML::ProgramHeader> {
  static void mapping(IO &IO, ELFYAML::ProgramHeader &FileHdr);
};

template <>
struct MappingTraits<ELFYAML::Symbol> {
  static void mapping(IO &IO, ELFYAML::Symbol &Symbol);
  static StringRef validate(IO &IO, ELFYAML::Symbol &Symbol);
};

template <> struct MappingTraits<ELFYAML::StackSizeEntry> {
  static void mapping(IO &IO, ELFYAML::StackSizeEntry &Rel);
};

template <> struct MappingTraits<ELFYAML::GnuHashHeader> {
  static void mapping(IO &IO, ELFYAML::GnuHashHeader &Rel);
};

template <> struct MappingTraits<ELFYAML::DynamicEntry> {
  static void mapping(IO &IO, ELFYAML::DynamicEntry &Rel);
};

template <> struct MappingTraits<ELFYAML::NoteEntry> {
  static void mapping(IO &IO, ELFYAML::NoteEntry &N);
};

template <> struct MappingTraits<ELFYAML::VerdefEntry> {
  static void mapping(IO &IO, ELFYAML::VerdefEntry &E);
};

template <> struct MappingTraits<ELFYAML::VerneedEntry> {
  static void mapping(IO &IO, ELFYAML::VerneedEntry &E);
};

template <> struct MappingTraits<ELFYAML::VernauxEntry> {
  static void mapping(IO &IO, ELFYAML::VernauxEntry &E);
};

template <> struct MappingTraits<ELFYAML::AddrsigSymbol> {
  static void mapping(IO &IO, ELFYAML::AddrsigSymbol &Sym);
};

template <> struct MappingTraits<ELFYAML::LinkerOption> {
  static void mapping(IO &IO, ELFYAML::LinkerOption &Sym);
};

template <> struct MappingTraits<ELFYAML::Relocation> {
  static void mapping(IO &IO, ELFYAML::Relocation &Rel);
};

template <> struct MappingTraits<std::unique_ptr<ELFYAML::Chunk>> {
  static void mapping(IO &IO, std::unique_ptr<ELFYAML::Chunk> &C);
  static StringRef validate(IO &io, std::unique_ptr<ELFYAML::Chunk> &C);
};

template <>
struct MappingTraits<ELFYAML::Object> {
  static void mapping(IO &IO, ELFYAML::Object &Object);
};

template <> struct MappingTraits<ELFYAML::SectionOrType> {
  static void mapping(IO &IO, ELFYAML::SectionOrType &sectionOrType);
};

template <> struct MappingTraits<ELFYAML::SectionName> {
  static void mapping(IO &IO, ELFYAML::SectionName &sectionName);
};

} // end namespace yaml
} // end namespace llvm

#endif // LLVM_OBJECTYAML_ELFYAML_H
