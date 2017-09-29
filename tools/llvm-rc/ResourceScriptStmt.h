//===-- ResourceScriptStmt.h ------------------------------------*- C++-*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===---------------------------------------------------------------------===//
//
// This lists all the resource and statement types occurring in RC scripts.
//
//===---------------------------------------------------------------------===//

#ifndef LLVM_TOOLS_LLVMRC_RESOURCESCRIPTSTMT_H
#define LLVM_TOOLS_LLVMRC_RESOURCESCRIPTSTMT_H

#include "ResourceScriptToken.h"
#include "ResourceVisitor.h"

#include "llvm/ADT/StringSet.h"

namespace llvm {
namespace rc {

// A class holding a name - either an integer or a reference to the string.
class IntOrString {
private:
  union Data {
    uint32_t Int;
    StringRef String;
    Data(uint32_t Value) : Int(Value) {}
    Data(const StringRef Value) : String(Value) {}
    Data(const RCToken &Token) {
      if (Token.kind() == RCToken::Kind::Int)
        Int = Token.intValue();
      else
        String = Token.value();
    }
  } Data;
  bool IsInt;

public:
  IntOrString() : IntOrString(0) {}
  IntOrString(uint32_t Value) : Data(Value), IsInt(1) {}
  IntOrString(StringRef Value) : Data(Value), IsInt(0) {}
  IntOrString(const RCToken &Token)
      : Data(Token), IsInt(Token.kind() == RCToken::Kind::Int) {}

  bool equalsLower(const char *Str) {
    return !IsInt && Data.String.equals_lower(Str);
  }

  bool isInt() const { return IsInt; }

  uint32_t getInt() const {
    assert(IsInt);
    return Data.Int;
  }

  const StringRef &getString() const {
    assert(!IsInt);
    return Data.String;
  }

  operator Twine() const {
    return isInt() ? Twine(getInt()) : Twine(getString());
  }

  friend raw_ostream &operator<<(raw_ostream &, const IntOrString &);
};

enum ResourceKind {
  // These resource kinds have corresponding .res resource type IDs
  // (TYPE in RESOURCEHEADER structure). The numeric value assigned to each
  // kind is equal to this type ID.
  RkNull = 0,
  RkMenu = 4,
  RkDialog = 5,
  RkAccelerators = 9,
  RkVersionInfo = 16,
  RkHTML = 23,

  // These kinds don't have assigned type IDs (they might be the resources
  // of invalid kind, expand to many resource structures in .res files,
  // or have variable type ID). In order to avoid ID clashes with IDs above,
  // we assign the kinds the values 256 and larger.
  RkInvalid = 256,
  RkBase,
  RkCursor,
  RkIcon,
  RkUser
};

// Non-zero memory flags.
// Ref: msdn.microsoft.com/en-us/library/windows/desktop/ms648027(v=vs.85).aspx
enum MemoryFlags {
  MfMoveable = 0x10,
  MfPure = 0x20,
  MfPreload = 0x40,
  MfDiscardable = 0x1000
};

// Base resource. All the resources should derive from this base.
class RCResource {
public:
  IntOrString ResName;

  RCResource() = default;
  RCResource(RCResource &&) = default;
  void setName(const IntOrString &Name) { ResName = Name; }
  virtual raw_ostream &log(raw_ostream &OS) const {
    return OS << "Base statement\n";
  };
  virtual ~RCResource() {}

  virtual Error visit(Visitor *) const {
    llvm_unreachable("This is unable to call methods from Visitor base");
  }

  // By default, memory flags are DISCARDABLE | PURE | MOVEABLE.
  virtual uint16_t getMemoryFlags() const {
    return MfDiscardable | MfPure | MfMoveable;
  }
  virtual ResourceKind getKind() const { return RkBase; }
  static bool classof(const RCResource *Res) { return true; }

  virtual IntOrString getResourceType() const {
    llvm_unreachable("This cannot be called on objects without types.");
  }
  virtual Twine getResourceTypeName() const {
    llvm_unreachable("This cannot be called on objects without types.");
  };
};

// An empty resource. It has no content, type 0, ID 0 and all of its
// characteristics are equal to 0.
class NullResource : public RCResource {
public:
  raw_ostream &log(raw_ostream &OS) const override {
    return OS << "Null resource\n";
  }
  Error visit(Visitor *V) const override { return V->visitNullResource(this); }
  IntOrString getResourceType() const override { return 0; }
  Twine getResourceTypeName() const override { return "(NULL)"; }
  uint16_t getMemoryFlags() const override { return 0; }
};

// Optional statement base. All such statements should derive from this base.
class OptionalStmt : public RCResource {};

class OptionalStmtList : public OptionalStmt {
  std::vector<std::unique_ptr<OptionalStmt>> Statements;

public:
  OptionalStmtList() {}
  virtual raw_ostream &log(raw_ostream &OS) const;

  void addStmt(std::unique_ptr<OptionalStmt> Stmt) {
    Statements.push_back(std::move(Stmt));
  }
};

class OptStatementsRCResource : public RCResource {
public:
  std::unique_ptr<OptionalStmtList> OptStatements;

  OptStatementsRCResource(OptionalStmtList &&Stmts)
      : OptStatements(llvm::make_unique<OptionalStmtList>(std::move(Stmts))) {}
};

// LANGUAGE statement. It can occur both as a top-level statement (in such
// a situation, it changes the default language until the end of the file)
// and as an optional resource statement (then it changes the language
// of a single resource).
//
// Ref: msdn.microsoft.com/en-us/library/windows/desktop/aa381019(v=vs.85).aspx
class LanguageResource : public OptionalStmt {
public:
  uint32_t Lang, SubLang;

  LanguageResource(uint32_t LangId, uint32_t SubLangId)
      : Lang(LangId), SubLang(SubLangId) {}
  raw_ostream &log(raw_ostream &) const override;

  // This is not a regular top-level statement; when it occurs, it just
  // modifies the language context.
  Error visit(Visitor *V) const override { return V->visitLanguageStmt(this); }
  Twine getResourceTypeName() const override { return "LANGUAGE"; }
};

// ACCELERATORS resource. Defines a named table of accelerators for the app.
//
// Ref: msdn.microsoft.com/en-us/library/windows/desktop/aa380610(v=vs.85).aspx
class AcceleratorsResource : public OptStatementsRCResource {
public:
  class Accelerator {
  public:
    IntOrString Event;
    uint32_t Id;
    uint16_t Flags;

    enum Options {
      // This is actually 0x0000 (accelerator is assumed to be ASCII if it's
      // not VIRTKEY). However, rc.exe behavior is different in situations
      // "only ASCII defined" and "neither ASCII nor VIRTKEY defined".
      // Therefore, we include ASCII as another flag. This must be zeroed
      // when serialized.
      ASCII = 0x8000,
      VIRTKEY = 0x0001,
      NOINVERT = 0x0002,
      ALT = 0x0010,
      SHIFT = 0x0004,
      CONTROL = 0x0008
    };

    static constexpr size_t NumFlags = 6;
    static StringRef OptionsStr[NumFlags];
    static uint32_t OptionsFlags[NumFlags];
  };

  using OptStatementsRCResource::OptStatementsRCResource;
  void addAccelerator(IntOrString Event, uint32_t Id, uint16_t Flags) {
    Accelerators.push_back(Accelerator{Event, Id, Flags});
  }
  raw_ostream &log(raw_ostream &) const override;

private:
  std::vector<Accelerator> Accelerators;
};

// CURSOR resource. Represents a single cursor (".cur") file.
//
// Ref: msdn.microsoft.com/en-us/library/windows/desktop/aa380920(v=vs.85).aspx
class CursorResource : public RCResource {
  StringRef CursorLoc;

public:
  CursorResource(StringRef Location) : CursorLoc(Location) {}
  raw_ostream &log(raw_ostream &) const override;
};

// ICON resource. Represents a single ".ico" file containing a group of icons.
//
// Ref: msdn.microsoft.com/en-us/library/windows/desktop/aa381018(v=vs.85).aspx
class IconResource : public RCResource {
  StringRef IconLoc;

public:
  IconResource(StringRef Location) : IconLoc(Location) {}
  raw_ostream &log(raw_ostream &) const override;
};

// HTML resource. Represents a local webpage that is to be embedded into the
// resulting resource file. It embeds a file only - no additional resources
// (images etc.) are included with this resource.
//
// Ref: msdn.microsoft.com/en-us/library/windows/desktop/aa966018(v=vs.85).aspx
class HTMLResource : public RCResource {
public:
  StringRef HTMLLoc;

  HTMLResource(StringRef Location) : HTMLLoc(Location) {}
  raw_ostream &log(raw_ostream &) const override;

  Error visit(Visitor *V) const override { return V->visitHTMLResource(this); }

  // Curiously, file resources don't have DISCARDABLE flag set.
  uint16_t getMemoryFlags() const override { return MfPure | MfMoveable; }
  IntOrString getResourceType() const override { return RkHTML; }
  Twine getResourceTypeName() const override { return "HTML"; }
  ResourceKind getKind() const override { return RkHTML; }
  static bool classof(const RCResource *Res) {
    return Res->getKind() == RkHTML;
  }
};

// -- MENU resource and its helper classes --
// This resource describes the contents of an application menu
// (usually located in the upper part of the dialog.)
//
// Ref: msdn.microsoft.com/en-us/library/windows/desktop/aa381025(v=vs.85).aspx

// Description of a single submenu item.
class MenuDefinition {
public:
  enum Options {
    CHECKED = 0x0008,
    GRAYED = 0x0001,
    HELP = 0x4000,
    INACTIVE = 0x0002,
    MENUBARBREAK = 0x0020,
    MENUBREAK = 0x0040
  };

  static constexpr size_t NumFlags = 6;
  static StringRef OptionsStr[NumFlags];
  static uint32_t OptionsFlags[NumFlags];
  static raw_ostream &logFlags(raw_ostream &, uint16_t Flags);
  virtual raw_ostream &log(raw_ostream &OS) const {
    return OS << "Base menu definition\n";
  }
  virtual ~MenuDefinition() {}
};

// Recursive description of a whole submenu.
class MenuDefinitionList : public MenuDefinition {
  std::vector<std::unique_ptr<MenuDefinition>> Definitions;

public:
  void addDefinition(std::unique_ptr<MenuDefinition> Def) {
    Definitions.push_back(std::move(Def));
  }
  raw_ostream &log(raw_ostream &) const override;
};

// Separator in MENU definition (MENUITEM SEPARATOR).
//
// Ref: msdn.microsoft.com/en-us/library/windows/desktop/aa381024(v=vs.85).aspx
class MenuSeparator : public MenuDefinition {
public:
  raw_ostream &log(raw_ostream &) const override;
};

// MENUITEM statement definition.
//
// Ref: msdn.microsoft.com/en-us/library/windows/desktop/aa381024(v=vs.85).aspx
class MenuItem : public MenuDefinition {
  StringRef Name;
  uint32_t Id;
  uint16_t Flags;

public:
  MenuItem(StringRef Caption, uint32_t ItemId, uint16_t ItemFlags)
      : Name(Caption), Id(ItemId), Flags(ItemFlags) {}
  raw_ostream &log(raw_ostream &) const override;
};

// POPUP statement definition.
//
// Ref: msdn.microsoft.com/en-us/library/windows/desktop/aa381030(v=vs.85).aspx
class PopupItem : public MenuDefinition {
  StringRef Name;
  uint16_t Flags;
  MenuDefinitionList SubItems;

public:
  PopupItem(StringRef Caption, uint16_t ItemFlags,
            MenuDefinitionList &&SubItemsList)
      : Name(Caption), Flags(ItemFlags), SubItems(std::move(SubItemsList)) {}
  raw_ostream &log(raw_ostream &) const override;
};

// Menu resource definition.
class MenuResource : public OptStatementsRCResource {
  MenuDefinitionList Elements;

public:
  MenuResource(OptionalStmtList &&OptStmts, MenuDefinitionList &&Items)
      : OptStatementsRCResource(std::move(OptStmts)),
        Elements(std::move(Items)) {}
  raw_ostream &log(raw_ostream &) const override;
};

// STRINGTABLE resource. Contains a list of strings, each having its unique ID.
//
// Ref: msdn.microsoft.com/en-us/library/windows/desktop/aa381050(v=vs.85).aspx
class StringTableResource : public OptStatementsRCResource {
  std::vector<std::pair<uint32_t, StringRef>> Table;

public:
  using OptStatementsRCResource::OptStatementsRCResource;
  void addString(uint32_t ID, StringRef String) {
    Table.emplace_back(ID, String);
  }
  raw_ostream &log(raw_ostream &) const override;
};

// -- DIALOG(EX) resource and its helper classes --
//
// This resource describes dialog boxes and controls residing inside them.
//
// Ref: msdn.microsoft.com/en-us/library/windows/desktop/aa381003(v=vs.85).aspx
// Ref: msdn.microsoft.com/en-us/library/windows/desktop/aa381002(v=vs.85).aspx

// Single control definition.
class Control {
  StringRef Type, Title;
  uint32_t ID, X, Y, Width, Height;
  Optional<uint32_t> Style, ExtStyle, HelpID;

public:
  Control(StringRef CtlType, StringRef CtlTitle, uint32_t CtlID, uint32_t PosX,
          uint32_t PosY, uint32_t ItemWidth, uint32_t ItemHeight,
          Optional<uint32_t> ItemStyle, Optional<uint32_t> ExtItemStyle,
          Optional<uint32_t> CtlHelpID)
      : Type(CtlType), Title(CtlTitle), ID(CtlID), X(PosX), Y(PosY),
        Width(ItemWidth), Height(ItemHeight), Style(ItemStyle),
        ExtStyle(ExtItemStyle), HelpID(CtlHelpID) {}

  static const StringSet<> SupportedCtls;
  static const StringSet<> CtlsWithTitle;

  raw_ostream &log(raw_ostream &) const;
};

// Single dialog definition. We don't create distinct classes for DIALOG and
// DIALOGEX because of their being too similar to each other. We only have a
// flag determining the type of the dialog box.
class DialogResource : public OptStatementsRCResource {
  uint32_t X, Y, Width, Height, HelpID;
  std::vector<Control> Controls;
  bool IsExtended;

public:
  DialogResource(uint32_t PosX, uint32_t PosY, uint32_t DlgWidth,
                 uint32_t DlgHeight, uint32_t DlgHelpID,
                 OptionalStmtList &&OptStmts, bool IsDialogEx)
      : OptStatementsRCResource(std::move(OptStmts)), X(PosX), Y(PosY),
        Width(DlgWidth), Height(DlgHeight), HelpID(DlgHelpID),
        IsExtended(IsDialogEx) {}

  void addControl(Control &&Ctl) { Controls.push_back(std::move(Ctl)); }

  raw_ostream &log(raw_ostream &) const override;
};

// User-defined resource. It is either:
//   * a link to the file, e.g. NAME TYPE "filename",
//   * or contains a list of integers and strings, e.g. NAME TYPE {1, "a", 2}.
class UserDefinedResource : public RCResource {
  IntOrString Type;
  StringRef FileLoc;
  std::vector<IntOrString> Contents;
  bool IsFileResource;

public:
  UserDefinedResource(IntOrString ResourceType, StringRef FileLocation)
      : Type(ResourceType), FileLoc(FileLocation), IsFileResource(true) {}
  UserDefinedResource(IntOrString ResourceType, std::vector<IntOrString> &&Data)
      : Type(ResourceType), Contents(std::move(Data)), IsFileResource(false) {}

  raw_ostream &log(raw_ostream &) const override;
};

// -- VERSIONINFO resource and its helper classes --
//
// This resource lists the version information on the executable/library.
// The declaration consists of the following items:
//   * A number of fixed optional version statements (e.g. FILEVERSION, FILEOS)
//   * BEGIN
//   * A number of BLOCK and/or VALUE statements. BLOCK recursively defines
//       another block of version information, whereas VALUE defines a
//       key -> value correspondence. There might be more than one value
//       corresponding to the single key.
//   * END
//
// Ref: msdn.microsoft.com/en-us/library/windows/desktop/aa381058(v=vs.85).aspx

// A single VERSIONINFO statement;
class VersionInfoStmt {
public:
  virtual raw_ostream &log(raw_ostream &OS) const { return OS << "VI stmt\n"; }
  virtual ~VersionInfoStmt() {}
};

// BLOCK definition; also the main VERSIONINFO declaration is considered a
// BLOCK, although it has no name.
// The correct top-level blocks are "VarFileInfo" and "StringFileInfo". We don't
// care about them at the parsing phase.
class VersionInfoBlock : public VersionInfoStmt {
  std::vector<std::unique_ptr<VersionInfoStmt>> Stmts;
  StringRef Name;

public:
  VersionInfoBlock(StringRef BlockName) : Name(BlockName) {}
  void addStmt(std::unique_ptr<VersionInfoStmt> Stmt) {
    Stmts.push_back(std::move(Stmt));
  }
  raw_ostream &log(raw_ostream &) const override;
};

class VersionInfoValue : public VersionInfoStmt {
  StringRef Key;
  std::vector<IntOrString> Values;

public:
  VersionInfoValue(StringRef InfoKey, std::vector<IntOrString> &&Vals)
      : Key(InfoKey), Values(std::move(Vals)) {}
  raw_ostream &log(raw_ostream &) const override;
};

class VersionInfoResource : public RCResource {
public:
  // A class listing fixed VERSIONINFO statements (occuring before main BEGIN).
  // If any of these is not specified, it is assumed by the original tool to
  // be equal to 0.
  class VersionInfoFixed {
  public:
    enum VersionInfoFixedType {
      FtUnknown,
      FtFileVersion,
      FtProductVersion,
      FtFileFlagsMask,
      FtFileFlags,
      FtFileOS,
      FtFileType,
      FtFileSubtype,
      FtNumTypes
    };

  private:
    static const StringMap<VersionInfoFixedType> FixedFieldsInfoMap;
    static const StringRef FixedFieldsNames[FtNumTypes];

  public:
    SmallVector<uint32_t, 4> FixedInfo[FtNumTypes];
    SmallVector<bool, FtNumTypes> IsTypePresent;

    static VersionInfoFixedType getFixedType(StringRef Type);
    static bool isTypeSupported(VersionInfoFixedType Type);
    static bool isVersionType(VersionInfoFixedType Type);

    VersionInfoFixed() : IsTypePresent(FtNumTypes, false) {}

    void setValue(VersionInfoFixedType Type, ArrayRef<uint32_t> Value) {
      FixedInfo[Type] = SmallVector<uint32_t, 4>(Value.begin(), Value.end());
      IsTypePresent[Type] = true;
    }

    raw_ostream &log(raw_ostream &) const;
  };

private:
  VersionInfoBlock MainBlock;
  VersionInfoFixed FixedData;

public:
  VersionInfoResource(VersionInfoBlock &&TopLevelBlock,
                      VersionInfoFixed &&FixedInfo)
      : MainBlock(std::move(TopLevelBlock)), FixedData(std::move(FixedInfo)) {}

  raw_ostream &log(raw_ostream &) const override;
};

// CHARACTERISTICS optional statement.
//
// Ref: msdn.microsoft.com/en-us/library/windows/desktop/aa380872(v=vs.85).aspx
class CharacteristicsStmt : public OptionalStmt {
  uint32_t Value;

public:
  CharacteristicsStmt(uint32_t Characteristic) : Value(Characteristic) {}
  raw_ostream &log(raw_ostream &) const override;
};

// VERSION optional statement.
//
// Ref: msdn.microsoft.com/en-us/library/windows/desktop/aa381059(v=vs.85).aspx
class VersionStmt : public OptionalStmt {
  uint32_t Value;

public:
  VersionStmt(uint32_t Version) : Value(Version) {}
  raw_ostream &log(raw_ostream &) const override;
};

// CAPTION optional statement.
//
// Ref: msdn.microsoft.com/en-us/library/windows/desktop/aa380778(v=vs.85).aspx
class CaptionStmt : public OptionalStmt {
  StringRef Value;

public:
  CaptionStmt(StringRef Caption) : Value(Caption) {}
  raw_ostream &log(raw_ostream &) const override;
};

// FONT optional statement.
// Note that the documentation is inaccurate: it expects five arguments to be
// given, however the example provides only two. In fact, the original tool
// expects two arguments - point size and name of the typeface.
//
// Ref: msdn.microsoft.com/en-us/library/windows/desktop/aa381013(v=vs.85).aspx
class FontStmt : public OptionalStmt {
  uint32_t Size;
  StringRef Typeface;

public:
  FontStmt(uint32_t FontSize, StringRef FontName)
      : Size(FontSize), Typeface(FontName) {}
  raw_ostream &log(raw_ostream &) const override;
};

// STYLE optional statement.
//
// Ref: msdn.microsoft.com/en-us/library/windows/desktop/aa381051(v=vs.85).aspx
class StyleStmt : public OptionalStmt {
  uint32_t Value;

public:
  StyleStmt(uint32_t Style) : Value(Style) {}
  raw_ostream &log(raw_ostream &) const override;
};

} // namespace rc
} // namespace llvm

#endif
