//===---- M68kAsmParser.cpp - Parse M68k assembly to MCInst instructions --===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "M68kInstrInfo.h"
#include "M68kRegisterInfo.h"
#include "TargetInfo/M68kTargetInfo.h"

#include "llvm/MC/MCContext.h"
#include "llvm/MC/MCParser/MCParsedAsmOperand.h"
#include "llvm/MC/MCParser/MCTargetAsmParser.h"
#include "llvm/MC/MCStreamer.h"
#include "llvm/Support/TargetRegistry.h"

#include <sstream>

#define DEBUG_TYPE "m68k-asm-parser"

using namespace llvm;

static cl::opt<bool> RegisterPrefixOptional(
    "m68k-register-prefix-optional", cl::Hidden,
    cl::desc("Enable specifying registers without the % prefix"),
    cl::init(false));

namespace {
/// Parses M68k assembly from a stream.
class M68kAsmParser : public MCTargetAsmParser {
  const MCSubtargetInfo &STI;
  MCAsmParser &Parser;
  const MCRegisterInfo *MRI;

#define GET_ASSEMBLER_HEADER
#include "M68kGenAsmMatcher.inc"

  // Helpers for Match&Emit.
  bool invalidOperand(const SMLoc &Loc, const OperandVector &Operands,
                      const uint64_t &ErrorInfo);
  bool missingFeature(const SMLoc &Loc, const uint64_t &ErrorInfo);
  bool emit(MCInst &Inst, SMLoc const &Loc, MCStreamer &Out) const;
  bool parseRegisterName(unsigned int &RegNo, SMLoc Loc,
                         StringRef RegisterName);
  OperandMatchResultTy parseRegister(unsigned int &RegNo);

  // Parser functions.
  void eatComma();

  bool isExpr();
  OperandMatchResultTy parseImm(OperandVector &Operands);
  OperandMatchResultTy parseMemOp(OperandVector &Operands);

public:
  M68kAsmParser(const MCSubtargetInfo &STI, MCAsmParser &Parser,
                const MCInstrInfo &MII, const MCTargetOptions &Options)
      : MCTargetAsmParser(Options, STI, MII), STI(STI), Parser(Parser) {
    MCAsmParserExtension::Initialize(Parser);
    MRI = getContext().getRegisterInfo();

    setAvailableFeatures(ComputeAvailableFeatures(STI.getFeatureBits()));
  }

  unsigned validateTargetOperandClass(MCParsedAsmOperand &Op,
                                      unsigned Kind) override;
  bool ParseRegister(unsigned &RegNo, SMLoc &StartLoc, SMLoc &EndLoc) override;
  OperandMatchResultTy tryParseRegister(unsigned &RegNo, SMLoc &StartLoc,
                                        SMLoc &EndLoc) override;
  bool ParseInstruction(ParseInstructionInfo &Info, StringRef Name,
                        SMLoc NameLoc, OperandVector &Operands) override;
  bool ParseDirective(AsmToken DirectiveID) override;
  bool MatchAndEmitInstruction(SMLoc IDLoc, unsigned &Opcode,
                               OperandVector &Operands, MCStreamer &Out,
                               uint64_t &ErrorInfo,
                               bool MatchingInlineAsm) override;
};

struct M68kMemOp {
  enum class Kind {
    Addr,
    Reg,
    RegIndirect,
    RegPostIncrement,
    RegPreDecrement,
    RegIndirectDisplacement,
    RegIndirectDisplacementIndex,
  };

  // These variables are used for the following forms:
  // Addr: (OuterDisp)
  // Reg: %OuterReg
  // RegIndirect: (%OuterReg)
  // RegPostIncrement: (%OuterReg)+
  // RegPreDecrement: -(%OuterReg)
  // RegIndirectDisplacement: OuterDisp(%OuterReg)
  // RegIndirectDisplacementIndex:
  //   OuterDisp(%OuterReg, %InnerReg.Size * Scale, InnerDisp)

  Kind Op;
  unsigned OuterReg;
  unsigned InnerReg;
  const MCExpr *OuterDisp;
  const MCExpr *InnerDisp;
  uint8_t Size : 4;
  uint8_t Scale : 4;
  const MCExpr *Expr;

  M68kMemOp() {}
  M68kMemOp(Kind Op) : Op(Op) {}

  void print(raw_ostream &OS) const;
};

/// An parsed M68k assembly operand.
class M68kOperand : public MCParsedAsmOperand {
  typedef MCParsedAsmOperand Base;

  enum class KindTy {
    Invalid,
    Token,
    Imm,
    MemOp,
  };

  KindTy Kind;
  SMLoc Start, End;
  union {
    StringRef Token;
    int64_t Imm;
    const MCExpr *Expr;
    M68kMemOp MemOp;
  };

public:
  M68kOperand(KindTy Kind, SMLoc Start, SMLoc End)
      : Base(), Kind(Kind), Start(Start), End(End) {}

  SMLoc getStartLoc() const override { return Start; }
  SMLoc getEndLoc() const override { return End; }

  void print(raw_ostream &OS) const override;

  bool isMem() const override { return false; }
  bool isMemOp() const { return Kind == KindTy::MemOp; }

  static void addExpr(MCInst &Inst, const MCExpr *Expr);

  // Reg
  bool isReg() const override;
  unsigned getReg() const override;
  void addRegOperands(MCInst &Inst, unsigned N) const;

  static std::unique_ptr<M68kOperand> createMemOp(M68kMemOp MemOp, SMLoc Start,
                                                  SMLoc End);

  // Token
  bool isToken() const override;
  StringRef getToken() const;
  static std::unique_ptr<M68kOperand> createToken(StringRef Token, SMLoc Start,
                                                  SMLoc End);

  // Imm
  bool isImm() const override;
  void addImmOperands(MCInst &Inst, unsigned N) const;

  static std::unique_ptr<M68kOperand> createImm(const MCExpr *Expr, SMLoc Start,
                                                SMLoc End);

  // Addr
  bool isAddr() const;
  void addAddrOperands(MCInst &Inst, unsigned N) const;

  // ARI
  bool isARI() const;
  void addARIOperands(MCInst &Inst, unsigned N) const;

  // ARID
  bool isARID() const;
  void addARIDOperands(MCInst &Inst, unsigned N) const;

  // ARII
  bool isARII() const;
  void addARIIOperands(MCInst &Inst, unsigned N) const;

  // ARIPD
  bool isARIPD() const;
  void addARIPDOperands(MCInst &Inst, unsigned N) const;

  // ARIPI
  bool isARIPI() const;
  void addARIPIOperands(MCInst &Inst, unsigned N) const;

  // PCD
  bool isPCD() const;
  void addPCDOperands(MCInst &Inst, unsigned N) const;

  // PCI
  bool isPCI() const;
  void addPCIOperands(MCInst &Inst, unsigned N) const;
};

} // end anonymous namespace.

extern "C" LLVM_EXTERNAL_VISIBILITY void LLVMInitializeM68kAsmParser() {
  RegisterMCAsmParser<M68kAsmParser> X(getTheM68kTarget());
}

#define GET_MATCHER_IMPLEMENTATION
#include "M68kGenAsmMatcher.inc"

void M68kMemOp::print(raw_ostream &OS) const {
  switch (Op) {
  case Kind::Addr:
    OS << OuterDisp;
    break;
  case Kind::Reg:
    OS << '%' << OuterReg;
    break;
  case Kind::RegIndirect:
    OS << "(%" << OuterReg << ')';
    break;
  case Kind::RegPostIncrement:
    OS << "(%" << OuterReg << ")+";
    break;
  case Kind::RegPreDecrement:
    OS << "-(%" << OuterReg << ")";
    break;
  case Kind::RegIndirectDisplacement:
    OS << OuterDisp << "(%" << OuterReg << ")";
    break;
  case Kind::RegIndirectDisplacementIndex:
    OS << OuterDisp << "(%" << OuterReg << ", " << InnerReg << "." << Size
       << ", " << InnerDisp << ")";
    break;
  }
}

void M68kOperand::addExpr(MCInst &Inst, const MCExpr *Expr) {
  if (auto Const = dyn_cast<MCConstantExpr>(Expr)) {
    Inst.addOperand(MCOperand::createImm(Const->getValue()));
    return;
  }

  Inst.addOperand(MCOperand::createExpr(Expr));
}

// Reg
bool M68kOperand::isReg() const {
  return Kind == KindTy::MemOp && MemOp.Op == M68kMemOp::Kind::Reg;
}

unsigned M68kOperand::getReg() const {
  assert(isReg());
  return MemOp.OuterReg;
}

void M68kOperand::addRegOperands(MCInst &Inst, unsigned N) const {
  assert(isReg() && "wrong operand kind");
  assert((N == 1) && "can only handle one register operand");

  Inst.addOperand(MCOperand::createReg(getReg()));
}

std::unique_ptr<M68kOperand> M68kOperand::createMemOp(M68kMemOp MemOp,
                                                      SMLoc Start, SMLoc End) {
  auto Op = std::make_unique<M68kOperand>(KindTy::MemOp, Start, End);
  Op->MemOp = MemOp;
  return Op;
}

// Token
bool M68kOperand::isToken() const { return Kind == KindTy::Token; }
StringRef M68kOperand::getToken() const {
  assert(isToken());
  return Token;
}

std::unique_ptr<M68kOperand> M68kOperand::createToken(StringRef Token,
                                                      SMLoc Start, SMLoc End) {
  auto Op = std::make_unique<M68kOperand>(KindTy::Token, Start, End);
  Op->Token = Token;
  return Op;
}

// Imm
bool M68kOperand::isImm() const { return Kind == KindTy::Imm; }
void M68kOperand::addImmOperands(MCInst &Inst, unsigned N) const {
  assert(isImm() && "wrong oeprand kind");
  assert((N == 1) && "can only handle one register operand");

  M68kOperand::addExpr(Inst, Expr);
}

std::unique_ptr<M68kOperand> M68kOperand::createImm(const MCExpr *Expr,
                                                    SMLoc Start, SMLoc End) {
  auto Op = std::make_unique<M68kOperand>(KindTy::Imm, Start, End);
  Op->Expr = Expr;
  return Op;
}

// Addr
bool M68kOperand::isAddr() const {
  return isMemOp() && MemOp.Op == M68kMemOp::Kind::Addr;
}
void M68kOperand::addAddrOperands(MCInst &Inst, unsigned N) const {
  M68kOperand::addExpr(Inst, MemOp.OuterDisp);
}

// ARI
bool M68kOperand::isARI() const {
  return isMemOp() && MemOp.Op == M68kMemOp::Kind::RegIndirect &&
         M68k::AR32RegClass.contains(MemOp.OuterReg);
}
void M68kOperand::addARIOperands(MCInst &Inst, unsigned N) const {
  Inst.addOperand(MCOperand::createReg(MemOp.OuterReg));
}

// ARID
bool M68kOperand::isARID() const {
  return isMemOp() && MemOp.Op == M68kMemOp::Kind::RegIndirectDisplacement &&
         M68k::AR32RegClass.contains(MemOp.OuterReg);
}
void M68kOperand::addARIDOperands(MCInst &Inst, unsigned N) const {
  M68kOperand::addExpr(Inst, MemOp.OuterDisp);
  Inst.addOperand(MCOperand::createReg(MemOp.OuterReg));
}

// ARII
bool M68kOperand::isARII() const {
  return isMemOp() &&
         MemOp.Op == M68kMemOp::Kind::RegIndirectDisplacementIndex &&
         M68k::AR32RegClass.contains(MemOp.OuterReg);
}
void M68kOperand::addARIIOperands(MCInst &Inst, unsigned N) const {
  M68kOperand::addExpr(Inst, MemOp.OuterDisp);
  Inst.addOperand(MCOperand::createReg(MemOp.OuterReg));
  Inst.addOperand(MCOperand::createReg(MemOp.InnerReg));
}

// ARIPD
bool M68kOperand::isARIPD() const {
  return isMemOp() && MemOp.Op == M68kMemOp::Kind::RegPreDecrement &&
         M68k::AR32RegClass.contains(MemOp.OuterReg);
}
void M68kOperand::addARIPDOperands(MCInst &Inst, unsigned N) const {
  Inst.addOperand(MCOperand::createReg(MemOp.OuterReg));
}

// ARIPI
bool M68kOperand::isARIPI() const {
  return isMemOp() && MemOp.Op == M68kMemOp::Kind::RegPostIncrement &&
         M68k::AR32RegClass.contains(MemOp.OuterReg);
}
void M68kOperand::addARIPIOperands(MCInst &Inst, unsigned N) const {
  Inst.addOperand(MCOperand::createReg(MemOp.OuterReg));
}

// PCD
bool M68kOperand::isPCD() const {
  return isMemOp() && MemOp.Op == M68kMemOp::Kind::RegIndirectDisplacement &&
         MemOp.OuterReg == M68k::PC;
}
void M68kOperand::addPCDOperands(MCInst &Inst, unsigned N) const {
  M68kOperand::addExpr(Inst, MemOp.OuterDisp);
}

// PCI
bool M68kOperand::isPCI() const {
  return isMemOp() &&
         MemOp.Op == M68kMemOp::Kind::RegIndirectDisplacementIndex &&
         MemOp.OuterReg == M68k::PC;
}
void M68kOperand::addPCIOperands(MCInst &Inst, unsigned N) const {
  M68kOperand::addExpr(Inst, MemOp.OuterDisp);
  Inst.addOperand(MCOperand::createReg(MemOp.InnerReg));
}

static inline bool checkRegisterClass(unsigned RegNo, bool Data, bool Address,
                                      bool SP) {
  switch (RegNo) {
  case M68k::A0:
  case M68k::A1:
  case M68k::A2:
  case M68k::A3:
  case M68k::A4:
  case M68k::A5:
  case M68k::A6:
    return Address;

  case M68k::SP:
    return SP;

  case M68k::D0:
  case M68k::D1:
  case M68k::D2:
  case M68k::D3:
  case M68k::D4:
  case M68k::D5:
  case M68k::D6:
  case M68k::D7:
    return Data;

  case M68k::SR:
  case M68k::CCR:
    return false;

  default:
    llvm_unreachable("unexpected register type");
    return false;
  }
}

unsigned M68kAsmParser::validateTargetOperandClass(MCParsedAsmOperand &Op,
                                                   unsigned Kind) {
  M68kOperand &Operand = (M68kOperand &)Op;

  switch (Kind) {
  case MCK_XR16:
  case MCK_SPILL:
    if (Operand.isReg() &&
        checkRegisterClass(Operand.getReg(), true, true, true)) {
      return Match_Success;
    }
    break;

  case MCK_AR16:
  case MCK_AR32:
    if (Operand.isReg() &&
        checkRegisterClass(Operand.getReg(), false, true, true)) {
      return Match_Success;
    }
    break;

  case MCK_AR32_NOSP:
    if (Operand.isReg() &&
        checkRegisterClass(Operand.getReg(), false, true, false)) {
      return Match_Success;
    }
    break;

  case MCK_DR8:
  case MCK_DR16:
  case MCK_DR32:
    if (Operand.isReg() &&
        checkRegisterClass(Operand.getReg(), true, false, false)) {
      return Match_Success;
    }
    break;

  case MCK_AR16_TC:
    if (Operand.isReg() &&
        ((Operand.getReg() == M68k::A0) || (Operand.getReg() == M68k::A1))) {
      return Match_Success;
    }
    break;

  case MCK_DR16_TC:
    if (Operand.isReg() &&
        ((Operand.getReg() == M68k::D0) || (Operand.getReg() == M68k::D1))) {
      return Match_Success;
    }
    break;

  case MCK_XR16_TC:
    if (Operand.isReg() &&
        ((Operand.getReg() == M68k::D0) || (Operand.getReg() == M68k::D1) ||
         (Operand.getReg() == M68k::A0) || (Operand.getReg() == M68k::A1))) {
      return Match_Success;
    }
    break;
  }

  return Match_InvalidOperand;
}

bool M68kAsmParser::parseRegisterName(unsigned &RegNo, SMLoc Loc,
                                      StringRef RegisterName) {
  auto RegisterNameLower = RegisterName.lower();

  // CCR register
  if (RegisterNameLower == "ccr") {
    RegNo = M68k::CCR;
    return true;
  }

  // Parse simple general-purpose registers.
  if (RegisterNameLower.size() == 2) {
    static unsigned RegistersByIndex[] = {
        M68k::D0, M68k::D1, M68k::D2, M68k::D3, M68k::D4, M68k::D5,
        M68k::D6, M68k::D7, M68k::A0, M68k::A1, M68k::A2, M68k::A3,
        M68k::A4, M68k::A5, M68k::A6, M68k::SP,
    };

    switch (RegisterNameLower[0]) {
    case 'd':
    case 'a': {
      if (isdigit(RegisterNameLower[1])) {
        unsigned IndexOffset = (RegisterNameLower[0] == 'a') ? 8 : 0;
        unsigned RegIndex = (unsigned)(RegisterNameLower[1] - '0');
        if (RegIndex < 8) {
          RegNo = RegistersByIndex[IndexOffset + RegIndex];
          return true;
        }
      }
      break;
    }

    case 's':
      if (RegisterNameLower[1] == 'p') {
        RegNo = M68k::SP;
        return true;
      } else if (RegisterNameLower[1] == 'r') {
        RegNo = M68k::SR;
        return true;
      }
      break;

    case 'p':
      if (RegisterNameLower[1] == 'c') {
        RegNo = M68k::PC;
        return true;
      }
      break;
    }
  }

  return false;
}

OperandMatchResultTy M68kAsmParser::parseRegister(unsigned &RegNo) {
  bool HasPercent = false;
  AsmToken PercentToken;

  LLVM_DEBUG(dbgs() << "parseRegister "; getTok().dump(dbgs()); dbgs() << "\n");

  if (getTok().is(AsmToken::Percent)) {
    HasPercent = true;
    PercentToken = Lex();
  } else if (!RegisterPrefixOptional.getValue()) {
    return MatchOperand_NoMatch;
  }

  if (!Parser.getTok().is(AsmToken::Identifier)) {
    if (HasPercent) {
      getLexer().UnLex(PercentToken);
    }
    return MatchOperand_NoMatch;
  }

  auto RegisterName = Parser.getTok().getString();
  if (!parseRegisterName(RegNo, Parser.getLexer().getLoc(), RegisterName)) {
    if (HasPercent) {
      getLexer().UnLex(PercentToken);
    }
    return MatchOperand_NoMatch;
  }

  Parser.Lex();
  return MatchOperand_Success;
}

bool M68kAsmParser::ParseRegister(unsigned &RegNo, SMLoc &StartLoc,
                                  SMLoc &EndLoc) {
  auto Result = tryParseRegister(RegNo, StartLoc, EndLoc);
  if (Result != MatchOperand_Success) {
    return Error(StartLoc, "expected register");
  }

  return false;
}

OperandMatchResultTy M68kAsmParser::tryParseRegister(unsigned &RegNo,
                                                     SMLoc &StartLoc,
                                                     SMLoc &EndLoc) {
  StartLoc = getLexer().getLoc();
  auto Result = parseRegister(RegNo);
  EndLoc = getLexer().getLoc();
  return Result;
}

bool M68kAsmParser::isExpr() {
  switch (Parser.getTok().getKind()) {
  case AsmToken::Identifier:
  case AsmToken::Integer:
    return true;
  case AsmToken::Minus:
    return getLexer().peekTok().getKind() == AsmToken::Integer;

  default:
    return false;
  }
}

OperandMatchResultTy M68kAsmParser::parseImm(OperandVector &Operands) {
  if (getLexer().isNot(AsmToken::Hash)) {
    return MatchOperand_NoMatch;
  }
  SMLoc Start = getLexer().getLoc();
  Parser.Lex();

  SMLoc End;
  const MCExpr *Expr;

  if (getParser().parseExpression(Expr, End)) {
    return MatchOperand_ParseFail;
  }

  Operands.push_back(M68kOperand::createImm(Expr, Start, End));
  return MatchOperand_Success;
}

OperandMatchResultTy M68kAsmParser::parseMemOp(OperandVector &Operands) {
  SMLoc Start = getLexer().getLoc();
  bool IsPD = false;
  M68kMemOp MemOp;

  // Check for a plain register.
  auto Result = parseRegister(MemOp.OuterReg);
  if (Result == MatchOperand_Success) {
    MemOp.Op = M68kMemOp::Kind::Reg;
    Operands.push_back(
        M68kOperand::createMemOp(MemOp, Start, getLexer().getLoc()));
    return MatchOperand_Success;
  }

  if (Result == MatchOperand_ParseFail) {
    return Result;
  }

  // Check for pre-decrement & outer displacement.
  bool HasDisplacement = false;
  if (getLexer().is(AsmToken::Minus)) {
    IsPD = true;
    Parser.Lex();
  } else if (isExpr()) {
    if (Parser.parseExpression(MemOp.OuterDisp)) {
      return MatchOperand_ParseFail;
    }
    HasDisplacement = true;
  }

  if (getLexer().isNot(AsmToken::LParen)) {
    if (HasDisplacement) {
      MemOp.Op = M68kMemOp::Kind::Addr;
      Operands.push_back(
          M68kOperand::createMemOp(MemOp, Start, getLexer().getLoc()));
      return MatchOperand_Success;
    } else if (IsPD) {
      Error(getLexer().getLoc(), "expected (");
      return MatchOperand_ParseFail;
    }

    return MatchOperand_NoMatch;
  }
  Parser.Lex();

  // Check for constant dereference & MIT-style displacement
  if (!HasDisplacement && isExpr()) {
    if (Parser.parseExpression(MemOp.OuterDisp)) {
      return MatchOperand_ParseFail;
    }
    HasDisplacement = true;

    // If we're not followed by a comma, we're a constant dereference.
    if (getLexer().isNot(AsmToken::Comma)) {
      MemOp.Op = M68kMemOp::Kind::Addr;
      Operands.push_back(
          M68kOperand::createMemOp(MemOp, Start, getLexer().getLoc()));
      return MatchOperand_Success;
    }

    Parser.Lex();
  }

  Result = parseRegister(MemOp.OuterReg);
  if (Result == MatchOperand_ParseFail) {
    return MatchOperand_ParseFail;
  }

  if (Result != MatchOperand_Success) {
    Error(getLexer().getLoc(), "expected register");
    return MatchOperand_ParseFail;
  }

  // Check for Index.
  bool HasIndex = false;
  if (Parser.getTok().is(AsmToken::Comma)) {
    Parser.Lex();

    Result = parseRegister(MemOp.InnerReg);
    if (Result == MatchOperand_ParseFail) {
      return Result;
    }

    if (Result == MatchOperand_NoMatch) {
      Error(getLexer().getLoc(), "expected register");
      return MatchOperand_ParseFail;
    }

    // TODO: parse size, scale and inner displacement.
    MemOp.Size = 4;
    MemOp.Scale = 1;
    MemOp.InnerDisp = MCConstantExpr::create(0, Parser.getContext(), true, 4);
    HasIndex = true;
  }

  if (Parser.getTok().isNot(AsmToken::RParen)) {
    Error(getLexer().getLoc(), "expected )");
    return MatchOperand_ParseFail;
  }
  Parser.Lex();

  bool IsPI = false;
  if (!IsPD && Parser.getTok().is(AsmToken::Plus)) {
    Parser.Lex();
    IsPI = true;
  }

  SMLoc End = getLexer().getLoc();

  unsigned OpCount = IsPD + IsPI + (HasIndex || HasDisplacement);
  if (OpCount > 1) {
    Error(Start, "only one of post-increment, pre-decrement or displacement "
                 "can be used");
    return MatchOperand_ParseFail;
  }

  if (IsPD) {
    MemOp.Op = M68kMemOp::Kind::RegPreDecrement;
  } else if (IsPI) {
    MemOp.Op = M68kMemOp::Kind::RegPostIncrement;
  } else if (HasIndex) {
    MemOp.Op = M68kMemOp::Kind::RegIndirectDisplacementIndex;
  } else if (HasDisplacement) {
    MemOp.Op = M68kMemOp::Kind::RegIndirectDisplacement;
  } else {
    MemOp.Op = M68kMemOp::Kind::RegIndirect;
  }

  Operands.push_back(M68kOperand::createMemOp(MemOp, Start, End));
  return MatchOperand_Success;
}

void M68kAsmParser::eatComma() {
  if (Parser.getTok().is(AsmToken::Comma)) {
    Parser.Lex();
  }
}

bool M68kAsmParser::ParseInstruction(ParseInstructionInfo &Info, StringRef Name,
                                     SMLoc NameLoc, OperandVector &Operands) {
  SMLoc Start = getLexer().getLoc();
  Operands.push_back(M68kOperand::createToken(Name, Start, Start));

  bool First = true;
  while (Parser.getTok().isNot(AsmToken::EndOfStatement)) {
    if (!First) {
      eatComma();
    } else {
      First = false;
    }

    auto MatchResult = MatchOperandParserImpl(Operands, Name);
    if (MatchResult == MatchOperand_Success) {
      continue;
    }

    // Add custom operand formats here...
    SMLoc Loc = getLexer().getLoc();
    Parser.eatToEndOfStatement();
    return Error(Loc, "unexpected token parsing operands");
  }

  // Eat EndOfStatement.
  Parser.Lex();
  return false;
}

bool M68kAsmParser::ParseDirective(AsmToken DirectiveID) { return true; }

bool M68kAsmParser::invalidOperand(SMLoc const &Loc,
                                   OperandVector const &Operands,
                                   uint64_t const &ErrorInfo) {
  SMLoc ErrorLoc = Loc;
  char const *Diag = 0;

  if (ErrorInfo != ~0U) {
    if (ErrorInfo >= Operands.size()) {
      Diag = "too few operands for instruction.";
    } else {
      auto const &Op = (M68kOperand const &)*Operands[ErrorInfo];
      if (Op.getStartLoc() != SMLoc()) {
        ErrorLoc = Op.getStartLoc();
      }
    }
  }

  if (!Diag) {
    Diag = "invalid operand for instruction";
  }

  return Error(ErrorLoc, Diag);
}

bool M68kAsmParser::missingFeature(llvm::SMLoc const &Loc,
                                   uint64_t const &ErrorInfo) {
  return Error(Loc, "instruction requires a CPU feature not currently enabled");
}

bool M68kAsmParser::emit(MCInst &Inst, SMLoc const &Loc,
                         MCStreamer &Out) const {
  Inst.setLoc(Loc);
  Out.emitInstruction(Inst, STI);

  return false;
}

bool M68kAsmParser::MatchAndEmitInstruction(SMLoc Loc, unsigned &Opcode,
                                            OperandVector &Operands,
                                            MCStreamer &Out,
                                            uint64_t &ErrorInfo,
                                            bool MatchingInlineAsm) {
  MCInst Inst;
  unsigned MatchResult =
      MatchInstructionImpl(Operands, Inst, ErrorInfo, MatchingInlineAsm);

  switch (MatchResult) {
  case Match_Success:
    return emit(Inst, Loc, Out);
  case Match_MissingFeature:
    return missingFeature(Loc, ErrorInfo);
  case Match_InvalidOperand:
    return invalidOperand(Loc, Operands, ErrorInfo);
  case Match_MnemonicFail:
    return Error(Loc, "invalid instruction");
  default:
    return true;
  }
}

void M68kOperand::print(raw_ostream &OS) const {
  switch (Kind) {
  case KindTy::Invalid:
    OS << "invalid";
    break;

  case KindTy::Token:
    OS << "token '" << Token << "'";
    break;

  case KindTy::Imm:
    OS << "immediate " << Imm;
    break;

  case KindTy::MemOp:
    MemOp.print(OS);
    break;
  }
}
