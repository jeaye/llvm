//===-- InitLLVM.cpp -----------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "llvm/Support/InitLLVM.h"
#include "llvm/Support/Error.h"
#include "llvm/Support/ManagedStatic.h"
#include "llvm/Support/PrettyStackTrace.h"
#include "llvm/Support/Process.h"
#include "llvm/Support/Signals.h"
#include <string>

#ifdef _WIN32
#include "Windows/WindowsSupport.h"
#endif

using namespace llvm;
using namespace llvm::sys;

InitLLVM::InitLLVM(int &Argc, const char **&Argv,
                   bool InstallPipeSignalExitHandler)
    : StackPrinter(Argc, Argv) {
  if (InstallPipeSignalExitHandler)
    sys::SetOneShotPipeSignalFunction(sys::DefaultOneShotPipeSignalHandler);
  sys::PrintStackTraceOnErrorSignal(Argv[0]);
  install_out_of_memory_new_handler();

#ifdef _WIN32
  // We use UTF-8 as the internal character encoding. On Windows,
  // arguments passed to main() may not be encoded in UTF-8. In order
  // to reliably detect encoding of command line arguments, we use an
  // Windows API to obtain arguments, convert them to UTF-8, and then
  // write them back to the Argv vector.
  //
  // There's probably other way to do the same thing (e.g. using
  // wmain() instead of main()), but this way seems less intrusive
  // than that.
  std::string Banner = std::string(Argv[0]) + ": ";
  ExitOnError ExitOnErr(Banner);

  ExitOnErr(errorCodeToError(windows::GetCommandLineArguments(Args, Alloc)));

  // GetCommandLineArguments doesn't terminate the vector with a
  // nullptr.  Do it to make it compatible with the real argv.
  Args.push_back(nullptr);

  Argc = Args.size() - 1;
  Argv = Args.data();
#endif
}

InitLLVM::~InitLLVM() { llvm_shutdown(); }
