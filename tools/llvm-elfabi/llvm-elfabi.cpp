//===- llvm-elfabi.cpp ----------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===-----------------------------------------------------------------------===/

#include "ErrorCollector.h"
#include "llvm/InterfaceStub/ELFObjHandler.h"
#include "llvm/InterfaceStub/IFSHandler.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Errc.h"
#include "llvm/Support/FileOutputBuffer.h"
#include "llvm/Support/MemoryBuffer.h"
#include "llvm/Support/Path.h"
#include "llvm/Support/WithColor.h"
#include "llvm/Support/raw_ostream.h"
#include <string>

namespace llvm {
namespace elfabi {

enum class FileFormat { IFS, ELF };

} // namespace elfabi
} // end namespace llvm

using namespace llvm;
using namespace llvm::elfabi;

// Command line flags:
cl::opt<std::string> InputFilePath(cl::Positional, cl::desc("input"),
                                   cl::Required);
cl::opt<FileFormat> InputFormat(
    "input-format", cl::desc("Specify the input file format"),
    cl::values(clEnumValN(FileFormat::IFS, "IFS", "Text based ELF stub file"),
               clEnumValN(FileFormat::ELF, "ELF", "ELF object file")));
cl::opt<FileFormat> OutputFormat(
    "output-format", cl::desc("Specify the output file format"),
    cl::values(clEnumValN(FileFormat::IFS, "IFS", "Text based ELF stub file"),
               clEnumValN(FileFormat::ELF, "ELF", "ELF stub file")),
    cl::Required);
cl::opt<std::string> OptArch("arch",
                             cl::desc("Specify the architecture, e.g. x86_64"));
cl::opt<IFSBitWidthType> OptBitWidth(
    "bitwidth", cl::desc("Specify the bit width"),
    cl::values(clEnumValN(IFSBitWidthType::IFS32, "32", "32 bits"),
               clEnumValN(IFSBitWidthType::IFS64, "64", "64 bits")));
cl::opt<IFSEndiannessType> OptEndianness(
    "endianness", cl::desc("Specify the endianness"),
    cl::values(clEnumValN(IFSEndiannessType::Little, "little", "Little Endian"),
               clEnumValN(IFSEndiannessType::Big, "big", "Big Endian")));
cl::opt<std::string> OptTargetTriple(
    "target", cl::desc("Specify the target triple, e.g. x86_64-linux-gnu"));
cl::opt<std::string> OptTargetTripleHint(
    "hint-ifs-target",
    cl::desc("When --output-format is 'IFS', this flag will hint the expected "
             "target triple for IFS output"));
cl::opt<bool> StripIFSArch(
    "strip-ifs-arch",
    cl::desc("Strip target architecture information away from IFS output"));
cl::opt<bool> StripIFSBitWidth(
    "strip-ifs-bitwidth",
    cl::desc("Strip target bit width information away from IFS output"));
cl::opt<bool> StripIFSEndiannessWidth(
    "strip-ifs-endianness",
    cl::desc("Strip target endianness information away from IFS output"));
cl::opt<bool> StripIFSTarget(
    "strip-ifs-target",
    cl::desc("Strip all target information away from IFS output"));
cl::opt<std::string>
    SOName("soname",
           cl::desc("Manually set the DT_SONAME entry of any emitted files"),
           cl::value_desc("name"));
cl::opt<std::string> OutputFilePath("output", cl::desc("Output file"));
cl::opt<bool> WriteIfChanged(
    "write-if-changed",
    cl::desc("Write the output file only if it is new or has changed."));

/// writeIFS() writes a Text-Based ELF stub to a file using the latest version
/// of the YAML parser.
static Error writeIFS(StringRef FilePath, IFSStub &Stub) {
  // Write IFS to memory first.
  std::string IFSStr;
  raw_string_ostream OutStr(IFSStr);
  Error YAMLErr = writeIFSToOutputStream(OutStr, Stub);
  if (YAMLErr)
    return YAMLErr;
  OutStr.flush();

  if (WriteIfChanged) {
    if (ErrorOr<std::unique_ptr<MemoryBuffer>> BufOrError =
            MemoryBuffer::getFile(FilePath)) {
      // Compare IFS output with existing IFS file.
      // If IFS file unchanged, abort updating.
      if ((*BufOrError)->getBuffer() == IFSStr)
        return Error::success();
    }
  }
  // Open IFS file for writing.
  std::error_code SysErr;
  raw_fd_ostream Out(FilePath, SysErr);
  if (SysErr)
    return createStringError(SysErr, "Couldn't open `%s` for writing",
                             FilePath.data());
  Out << IFSStr;
  return Error::success();
}

/// readInputFile populates an IFSStub by attempting to read the
/// input file using both the IFS and binary ELF parsers.
static Expected<std::unique_ptr<IFSStub>> readInputFile(StringRef FilePath) {
  // Read in file.
  ErrorOr<std::unique_ptr<MemoryBuffer>> BufOrError =
      MemoryBuffer::getFile(FilePath);
  if (!BufOrError) {
    return createStringError(BufOrError.getError(), "Could not open `%s`",
                             FilePath.data());
  }

  std::unique_ptr<MemoryBuffer> FileReadBuffer = std::move(*BufOrError);
  ErrorCollector EC(/*UseFatalErrors=*/false);

  // First try to read as a binary (fails fast if not binary).
  if (InputFormat.getNumOccurrences() == 0 || InputFormat == FileFormat::ELF) {
    Expected<std::unique_ptr<IFSStub>> StubFromELF =
        readELFFile(FileReadBuffer->getMemBufferRef());
    if (StubFromELF) {
      return std::move(*StubFromELF);
    }
    EC.addError(StubFromELF.takeError(), "BinaryRead");
  }

  // Fall back to reading as a ifs.
  if (InputFormat.getNumOccurrences() == 0 || InputFormat == FileFormat::IFS) {
    Expected<std::unique_ptr<IFSStub>> StubFromIFS =
        readIFSFromBuffer(FileReadBuffer->getBuffer());
    if (StubFromIFS) {
      return std::move(*StubFromIFS);
    }
    EC.addError(StubFromIFS.takeError(), "YamlParse");
  }

  // If both readers fail, build a new error that includes all information.
  EC.addError(createStringError(errc::not_supported,
                                "No file readers succeeded reading `%s` "
                                "(unsupported/malformed file?)",
                                FilePath.data()),
              "ReadInputFile");
  EC.escalateToFatal();
  return EC.makeError();
}

static void fatalError(Error Err) {
  WithColor::defaultErrorHandler(std::move(Err));
  exit(1);
}

int main(int argc, char *argv[]) {
  // Parse arguments.
  cl::ParseCommandLineOptions(argc, argv);
  Expected<std::unique_ptr<IFSStub>> StubOrErr = readInputFile(InputFilePath);
  if (!StubOrErr)
    fatalError(StubOrErr.takeError());

  std::unique_ptr<IFSStub> TargetStub = std::move(StubOrErr.get());

  // Change SoName before emitting stubs.
  if (SOName.getNumOccurrences() == 1)
    TargetStub->SoName = SOName;
  Optional<IFSArch> OverrideArch;
  Optional<IFSEndiannessType> OverrideEndianness;
  Optional<IFSBitWidthType> OverrideBitWidth;
  Optional<std::string> OverrideTriple;
  if (OptArch.getNumOccurrences() == 1) {
    OverrideArch = ELF::convertArchNameToEMachine(OptArch.getValue());
  }
  if (OptEndianness.getNumOccurrences() == 1)
    OverrideEndianness = OptEndianness.getValue();
  if (OptBitWidth.getNumOccurrences() == 1)
    OverrideBitWidth = OptBitWidth.getValue();
  if (OptTargetTriple.getNumOccurrences() == 1)
    OverrideTriple = OptTargetTriple.getValue();
  Error OverrideError =
      overrideIFSTarget(*TargetStub, OverrideArch, OverrideEndianness,
                        OverrideBitWidth, OverrideTriple);
  if (OverrideError)
    fatalError(std::move(OverrideError));
  switch (OutputFormat.getValue()) {
  case FileFormat::IFS: {
    TargetStub->IfsVersion = IFSVersionCurrent;
    if (InputFormat.getValue() == FileFormat::ELF &&
        OptTargetTripleHint.getNumOccurrences() == 1) {
      std::error_code HintEC(1, std::generic_category());
      IFSTarget HintTarget = parseTriple(OptTargetTripleHint);
      if (TargetStub->Target.Arch.getValue() != HintTarget.Arch.getValue()) {
        fatalError(make_error<StringError>(
            "Triple hint does not match the actual architecture", HintEC));
      }
      if (TargetStub->Target.Endianness.getValue() !=
          HintTarget.Endianness.getValue()) {
        fatalError(make_error<StringError>(
            "Triple hint does not match the actual endianness", HintEC));
      }
      if (TargetStub->Target.BitWidth.getValue() !=
          HintTarget.BitWidth.getValue()) {
        fatalError(make_error<StringError>(
            "Triple hint does not match the actual bit width", HintEC));
      }
      stripIFSTarget(*TargetStub, true, false, false, false);
      TargetStub->Target.Triple = OptTargetTripleHint.getValue();
    } else {
      stripIFSTarget(*TargetStub, StripIFSTarget, StripIFSArch,
                     StripIFSEndiannessWidth, StripIFSBitWidth);
    }
    Error IFSWriteError = writeIFS(OutputFilePath.getValue(), *TargetStub);
    if (IFSWriteError)
      fatalError(std::move(IFSWriteError));
    break;
  }
  case FileFormat::ELF: {
    Error TargetError = validateIFSTarget(*TargetStub, true);
    if (TargetError)
      fatalError(std::move(TargetError));
    Error BinaryWriteError =
        writeBinaryStub(OutputFilePath, *TargetStub, WriteIfChanged);
    if (BinaryWriteError)
      fatalError(std::move(BinaryWriteError));
    break;
  }
  }
}
