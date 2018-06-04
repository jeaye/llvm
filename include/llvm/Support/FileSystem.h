//===- llvm/Support/FileSystem.h - File System OS Concept -------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file declares the llvm::sys::fs namespace. It is designed after
// TR2/boost filesystem (v3), but modified to remove exception handling and the
// path class.
//
// All functions return an error_code and their actual work via the last out
// argument. The out argument is defined if and only if errc::success is
// returned. A function may return any error code in the generic or system
// category. However, they shall be equivalent to any error conditions listed
// in each functions respective documentation if the condition applies. [ note:
// this does not guarantee that error_code will be in the set of explicitly
// listed codes, but it does guarantee that if any of the explicitly listed
// errors occur, the correct error_code will be used ]. All functions may
// return errc::not_enough_memory if there is not enough memory to complete the
// operation.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_SUPPORT_FILESYSTEM_H
#define LLVM_SUPPORT_FILESYSTEM_H

#include "llvm/ADT/SmallString.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/ADT/Twine.h"
#include "llvm/Config/llvm-config.h"
#include "llvm/Support/Chrono.h"
#include "llvm/Support/Error.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/ErrorOr.h"
#include "llvm/Support/MD5.h"
#include <cassert>
#include <cstdint>
#include <ctime>
#include <memory>
#include <stack>
#include <string>
#include <system_error>
#include <tuple>
#include <vector>

#ifdef HAVE_SYS_STAT_H
#include <sys/stat.h>
#endif

namespace llvm {
namespace sys {
namespace fs {

#if defined(_WIN32)
// A Win32 HANDLE is a typedef of void*
using file_t = void *;
#else
using file_t = int;
#endif

extern const file_t kInvalidFile;

/// An enumeration for the file system's view of the type.
enum class file_type {
  status_error,
  file_not_found,
  regular_file,
  directory_file,
  symlink_file,
  block_file,
  character_file,
  fifo_file,
  socket_file,
  type_unknown
};

/// space_info - Self explanatory.
struct space_info {
  uint64_t capacity;
  uint64_t free;
  uint64_t available;
};

enum perms {
  no_perms = 0,
  owner_read = 0400,
  owner_write = 0200,
  owner_exe = 0100,
  owner_all = owner_read | owner_write | owner_exe,
  group_read = 040,
  group_write = 020,
  group_exe = 010,
  group_all = group_read | group_write | group_exe,
  others_read = 04,
  others_write = 02,
  others_exe = 01,
  others_all = others_read | others_write | others_exe,
  all_read = owner_read | group_read | others_read,
  all_write = owner_write | group_write | others_write,
  all_exe = owner_exe | group_exe | others_exe,
  all_all = owner_all | group_all | others_all,
  set_uid_on_exe = 04000,
  set_gid_on_exe = 02000,
  sticky_bit = 01000,
  all_perms = all_all | set_uid_on_exe | set_gid_on_exe | sticky_bit,
  perms_not_known = 0xFFFF
};

// Helper functions so that you can use & and | to manipulate perms bits:
inline perms operator|(perms l, perms r) {
  return static_cast<perms>(static_cast<unsigned short>(l) |
                            static_cast<unsigned short>(r));
}
inline perms operator&(perms l, perms r) {
  return static_cast<perms>(static_cast<unsigned short>(l) &
                            static_cast<unsigned short>(r));
}
inline perms &operator|=(perms &l, perms r) {
  l = l | r;
  return l;
}
inline perms &operator&=(perms &l, perms r) {
  l = l & r;
  return l;
}
inline perms operator~(perms x) {
  // Avoid UB by explicitly truncating the (unsigned) ~ result.
  return static_cast<perms>(
      static_cast<unsigned short>(~static_cast<unsigned short>(x)));
}

class UniqueID {
  uint64_t Device;
  uint64_t File;

public:
  UniqueID() = default;
  UniqueID(uint64_t Device, uint64_t File) : Device(Device), File(File) {}

  bool operator==(const UniqueID &Other) const {
    return Device == Other.Device && File == Other.File;
  }
  bool operator!=(const UniqueID &Other) const { return !(*this == Other); }
  bool operator<(const UniqueID &Other) const {
    return std::tie(Device, File) < std::tie(Other.Device, Other.File);
  }

  uint64_t getDevice() const { return Device; }
  uint64_t getFile() const { return File; }
};

/// Represents the result of a call to directory_iterator::status(). This is a
/// subset of the information returned by a regular sys::fs::status() call, and
/// represents the information provided by Windows FileFirstFile/FindNextFile.
class basic_file_status {
protected:
  #if defined(LLVM_ON_UNIX)
  time_t fs_st_atime = 0;
  time_t fs_st_mtime = 0;
  uid_t fs_st_uid = 0;
  gid_t fs_st_gid = 0;
  off_t fs_st_size = 0;
  #elif defined (_WIN32)
  uint32_t LastAccessedTimeHigh = 0;
  uint32_t LastAccessedTimeLow = 0;
  uint32_t LastWriteTimeHigh = 0;
  uint32_t LastWriteTimeLow = 0;
  uint32_t FileSizeHigh = 0;
  uint32_t FileSizeLow = 0;
  #endif
  file_type Type = file_type::status_error;
  perms Perms = perms_not_known;

public:
  basic_file_status() = default;

  explicit basic_file_status(file_type Type) : Type(Type) {}

  #if defined(LLVM_ON_UNIX)
  basic_file_status(file_type Type, perms Perms, time_t ATime, time_t MTime,
                    uid_t UID, gid_t GID, off_t Size)
      : fs_st_atime(ATime), fs_st_mtime(MTime), fs_st_uid(UID), fs_st_gid(GID),
        fs_st_size(Size), Type(Type), Perms(Perms) {}
#elif defined(_WIN32)
  basic_file_status(file_type Type, perms Perms, uint32_t LastAccessTimeHigh,
                    uint32_t LastAccessTimeLow, uint32_t LastWriteTimeHigh,
                    uint32_t LastWriteTimeLow, uint32_t FileSizeHigh,
                    uint32_t FileSizeLow)
      : LastAccessedTimeHigh(LastAccessTimeHigh),
        LastAccessedTimeLow(LastAccessTimeLow),
        LastWriteTimeHigh(LastWriteTimeHigh),
        LastWriteTimeLow(LastWriteTimeLow), FileSizeHigh(FileSizeHigh),
        FileSizeLow(FileSizeLow), Type(Type), Perms(Perms) {}
  #endif

  // getters
  file_type type() const { return Type; }
  perms permissions() const { return Perms; }
  TimePoint<> getLastAccessedTime() const;
  TimePoint<> getLastModificationTime() const;

  #if defined(LLVM_ON_UNIX)
  uint32_t getUser() const { return fs_st_uid; }
  uint32_t getGroup() const { return fs_st_gid; }
  uint64_t getSize() const { return fs_st_size; }
  #elif defined (_WIN32)
  uint32_t getUser() const {
    return 9999; // Not applicable to Windows, so...
  }

  uint32_t getGroup() const {
    return 9999; // Not applicable to Windows, so...
  }

  uint64_t getSize() const {
    return (uint64_t(FileSizeHigh) << 32) + FileSizeLow;
  }
  #endif

  // setters
  void type(file_type v) { Type = v; }
  void permissions(perms p) { Perms = p; }
};

/// Represents the result of a call to sys::fs::status().
class file_status : public basic_file_status {
  friend bool equivalent(file_status A, file_status B);

  #if defined(LLVM_ON_UNIX)
  dev_t fs_st_dev = 0;
  nlink_t fs_st_nlinks = 0;
  ino_t fs_st_ino = 0;
  #elif defined (_WIN32)
  uint32_t NumLinks = 0;
  uint32_t VolumeSerialNumber = 0;
  uint32_t FileIndexHigh = 0;
  uint32_t FileIndexLow = 0;
  #endif

public:
  file_status() = default;

  explicit file_status(file_type Type) : basic_file_status(Type) {}

  #if defined(LLVM_ON_UNIX)
  file_status(file_type Type, perms Perms, dev_t Dev, nlink_t Links, ino_t Ino,
              time_t ATime, time_t MTime, uid_t UID, gid_t GID, off_t Size)
      : basic_file_status(Type, Perms, ATime, MTime, UID, GID, Size),
        fs_st_dev(Dev), fs_st_nlinks(Links), fs_st_ino(Ino) {}
  #elif defined(_WIN32)
  file_status(file_type Type, perms Perms, uint32_t LinkCount,
              uint32_t LastAccessTimeHigh, uint32_t LastAccessTimeLow,
              uint32_t LastWriteTimeHigh, uint32_t LastWriteTimeLow,
              uint32_t VolumeSerialNumber, uint32_t FileSizeHigh,
              uint32_t FileSizeLow, uint32_t FileIndexHigh,
              uint32_t FileIndexLow)
      : basic_file_status(Type, Perms, LastAccessTimeHigh, LastAccessTimeLow,
                          LastWriteTimeHigh, LastWriteTimeLow, FileSizeHigh,
                          FileSizeLow),
        NumLinks(LinkCount), VolumeSerialNumber(VolumeSerialNumber),
        FileIndexHigh(FileIndexHigh), FileIndexLow(FileIndexLow) {}
  #endif

  UniqueID getUniqueID() const;
  uint32_t getLinkCount() const;
};

/// @}
/// @name Physical Operators
/// @{

/// Make \a path an absolute path.
///
/// Makes \a path absolute using the \a current_directory if it is not already.
/// An empty \a path will result in the \a current_directory.
///
/// /absolute/path   => /absolute/path
/// relative/../path => <current-directory>/relative/../path
///
/// @param path A path that is modified to be an absolute path.
/// @returns errc::success if \a path has been made absolute, otherwise a
///          platform-specific error_code.
std::error_code make_absolute(const Twine &current_directory,
                              SmallVectorImpl<char> &path);

/// Make \a path an absolute path.
///
/// Makes \a path absolute using the current directory if it is not already. An
/// empty \a path will result in the current directory.
///
/// /absolute/path   => /absolute/path
/// relative/../path => <current-directory>/relative/../path
///
/// @param path A path that is modified to be an absolute path.
/// @returns errc::success if \a path has been made absolute, otherwise a
///          platform-specific error_code.
std::error_code make_absolute(SmallVectorImpl<char> &path);

/// Create all the non-existent directories in path.
///
/// @param path Directories to create.
/// @returns errc::success if is_directory(path), otherwise a platform
///          specific error_code. If IgnoreExisting is false, also returns
///          error if the directory already existed.
std::error_code create_directories(const Twine &path,
                                   bool IgnoreExisting = true,
                                   perms Perms = owner_all | group_all);

/// Create the directory in path.
///
/// @param path Directory to create.
/// @returns errc::success if is_directory(path), otherwise a platform
///          specific error_code. If IgnoreExisting is false, also returns
///          error if the directory already existed.
std::error_code create_directory(const Twine &path, bool IgnoreExisting = true,
                                 perms Perms = owner_all | group_all);

/// Create a link from \a from to \a to.
///
/// The link may be a soft or a hard link, depending on the platform. The caller
/// may not assume which one. Currently on windows it creates a hard link since
/// soft links require extra privileges. On unix, it creates a soft link since
/// hard links don't work on SMB file systems.
///
/// @param to The path to hard link to.
/// @param from The path to hard link from. This is created.
/// @returns errc::success if the link was created, otherwise a platform
/// specific error_code.
std::error_code create_link(const Twine &to, const Twine &from);

/// Create a hard link from \a from to \a to, or return an error.
///
/// @param to The path to hard link to.
/// @param from The path to hard link from. This is created.
/// @returns errc::success if the link was created, otherwise a platform
/// specific error_code.
std::error_code create_hard_link(const Twine &to, const Twine &from);

/// Collapse all . and .. patterns, resolve all symlinks, and optionally
///        expand ~ expressions to the user's home directory.
///
/// @param path The path to resolve.
/// @param output The location to store the resolved path.
/// @param expand_tilde If true, resolves ~ expressions to the user's home
///                     directory.
std::error_code real_path(const Twine &path, SmallVectorImpl<char> &output,
                          bool expand_tilde = false);

/// Get the current path.
///
/// @param result Holds the current path on return.
/// @returns errc::success if the current path has been stored in result,
///          otherwise a platform-specific error_code.
std::error_code current_path(SmallVectorImpl<char> &result);

/// Set the current path.
///
/// @param path The path to set.
/// @returns errc::success if the current path was successfully set,
///          otherwise a platform-specific error_code.
std::error_code set_current_path(const Twine &path);

/// Remove path. Equivalent to POSIX remove().
///
/// @param path Input path.
/// @returns errc::success if path has been removed or didn't exist, otherwise a
///          platform-specific error code. If IgnoreNonExisting is false, also
///          returns error if the file didn't exist.
std::error_code remove(const Twine &path, bool IgnoreNonExisting = true);

/// Recursively delete a directory.
///
/// @param path Input path.
/// @returns errc::success if path has been removed or didn't exist, otherwise a
///          platform-specific error code.
std::error_code remove_directories(const Twine &path, bool IgnoreErrors = true);

/// Rename \a from to \a to.
///
/// Files are renamed as if by POSIX rename(), except that on Windows there may
/// be a short interval of time during which the destination file does not
/// exist.
///
/// @param from The path to rename from.
/// @param to The path to rename to. This is created.
std::error_code rename(const Twine &from, const Twine &to);

/// Copy the contents of \a From to \a To.
///
/// @param From The path to copy from.
/// @param To The path to copy to. This is created.
std::error_code copy_file(const Twine &From, const Twine &To);

/// Resize path to size. File is resized as if by POSIX truncate().
///
/// @param FD Input file descriptor.
/// @param Size Size to resize to.
/// @returns errc::success if \a path has been resized to \a size, otherwise a
///          platform-specific error_code.
std::error_code resize_file(int FD, uint64_t Size);

/// Compute an MD5 hash of a file's contents.
///
/// @param FD Input file descriptor.
/// @returns An MD5Result with the hash computed, if successful, otherwise a
///          std::error_code.
ErrorOr<MD5::MD5Result> md5_contents(int FD);

/// Version of compute_md5 that doesn't require an open file descriptor.
ErrorOr<MD5::MD5Result> md5_contents(const Twine &Path);

/// @}
/// @name Physical Observers
/// @{

/// Does file exist?
///
/// @param status A basic_file_status previously returned from stat.
/// @returns True if the file represented by status exists, false if it does
///          not.
bool exists(const basic_file_status &status);

enum class AccessMode { Exist, Write, Execute };

/// Can the file be accessed?
///
/// @param Path Input path.
/// @returns errc::success if the path can be accessed, otherwise a
///          platform-specific error_code.
std::error_code access(const Twine &Path, AccessMode Mode);

/// Does file exist?
///
/// @param Path Input path.
/// @returns True if it exists, false otherwise.
inline bool exists(const Twine &Path) {
  return !access(Path, AccessMode::Exist);
}

/// Can we execute this file?
///
/// @param Path Input path.
/// @returns True if we can execute it, false otherwise.
bool can_execute(const Twine &Path);

/// Can we write this file?
///
/// @param Path Input path.
/// @returns True if we can write to it, false otherwise.
inline bool can_write(const Twine &Path) {
  return !access(Path, AccessMode::Write);
}

/// Do file_status's represent the same thing?
///
/// @param A Input file_status.
/// @param B Input file_status.
///
/// assert(status_known(A) || status_known(B));
///
/// @returns True if A and B both represent the same file system entity, false
///          otherwise.
bool equivalent(file_status A, file_status B);

/// Do paths represent the same thing?
///
/// assert(status_known(A) || status_known(B));
///
/// @param A Input path A.
/// @param B Input path B.
/// @param result Set to true if stat(A) and stat(B) have the same device and
///               inode (or equivalent).
/// @returns errc::success if result has been successfully set, otherwise a
///          platform-specific error_code.
std::error_code equivalent(const Twine &A, const Twine &B, bool &result);

/// Simpler version of equivalent for clients that don't need to
///        differentiate between an error and false.
inline bool equivalent(const Twine &A, const Twine &B) {
  bool result;
  return !equivalent(A, B, result) && result;
}

/// Is the file mounted on a local filesystem?
///
/// @param path Input path.
/// @param result Set to true if \a path is on fixed media such as a hard disk,
///               false if it is not.
/// @returns errc::success if result has been successfully set, otherwise a
///          platform specific error_code.
std::error_code is_local(const Twine &path, bool &result);

/// Version of is_local accepting an open file descriptor.
std::error_code is_local(int FD, bool &result);

/// Simpler version of is_local for clients that don't need to
///        differentiate between an error and false.
inline bool is_local(const Twine &Path) {
  bool Result;
  return !is_local(Path, Result) && Result;
}

/// Simpler version of is_local accepting an open file descriptor for
///        clients that don't need to differentiate between an error and false.
inline bool is_local(int FD) {
  bool Result;
  return !is_local(FD, Result) && Result;
}

/// Does status represent a directory?
///
/// @param Path The path to get the type of.
/// @param Follow For symbolic links, indicates whether to return the file type
///               of the link itself, or of the target.
/// @returns A value from the file_type enumeration indicating the type of file.
file_type get_file_type(const Twine &Path, bool Follow = true);

/// Does status represent a directory?
///
/// @param status A basic_file_status previously returned from status.
/// @returns status.type() == file_type::directory_file.
bool is_directory(const basic_file_status &status);

/// Is path a directory?
///
/// @param path Input path.
/// @param result Set to true if \a path is a directory (after following
///               symlinks, false if it is not. Undefined otherwise.
/// @returns errc::success if result has been successfully set, otherwise a
///          platform-specific error_code.
std::error_code is_directory(const Twine &path, bool &result);

/// Simpler version of is_directory for clients that don't need to
///        differentiate between an error and false.
inline bool is_directory(const Twine &Path) {
  bool Result;
  return !is_directory(Path, Result) && Result;
}

/// Does status represent a regular file?
///
/// @param status A basic_file_status previously returned from status.
/// @returns status_known(status) && status.type() == file_type::regular_file.
bool is_regular_file(const basic_file_status &status);

/// Is path a regular file?
///
/// @param path Input path.
/// @param result Set to true if \a path is a regular file (after following
///               symlinks), false if it is not. Undefined otherwise.
/// @returns errc::success if result has been successfully set, otherwise a
///          platform-specific error_code.
std::error_code is_regular_file(const Twine &path, bool &result);

/// Simpler version of is_regular_file for clients that don't need to
///        differentiate between an error and false.
inline bool is_regular_file(const Twine &Path) {
  bool Result;
  if (is_regular_file(Path, Result))
    return false;
  return Result;
}

/// Does status represent a symlink file?
///
/// @param status A basic_file_status previously returned from status.
/// @returns status_known(status) && status.type() == file_type::symlink_file.
bool is_symlink_file(const basic_file_status &status);

/// Is path a symlink file?
///
/// @param path Input path.
/// @param result Set to true if \a path is a symlink file, false if it is not.
///               Undefined otherwise.
/// @returns errc::success if result has been successfully set, otherwise a
///          platform-specific error_code.
std::error_code is_symlink_file(const Twine &path, bool &result);

/// Simpler version of is_symlink_file for clients that don't need to
///        differentiate between an error and false.
inline bool is_symlink_file(const Twine &Path) {
  bool Result;
  if (is_symlink_file(Path, Result))
    return false;
  return Result;
}

/// Does this status represent something that exists but is not a
///        directory or regular file?
///
/// @param status A basic_file_status previously returned from status.
/// @returns exists(s) && !is_regular_file(s) && !is_directory(s)
bool is_other(const basic_file_status &status);

/// Is path something that exists but is not a directory,
///        regular file, or symlink?
///
/// @param path Input path.
/// @param result Set to true if \a path exists, but is not a directory, regular
///               file, or a symlink, false if it does not. Undefined otherwise.
/// @returns errc::success if result has been successfully set, otherwise a
///          platform-specific error_code.
std::error_code is_other(const Twine &path, bool &result);

/// Get file status as if by POSIX stat().
///
/// @param path Input path.
/// @param result Set to the file status.
/// @param follow When true, follows symlinks.  Otherwise, the symlink itself is
///               statted.
/// @returns errc::success if result has been successfully set, otherwise a
///          platform-specific error_code.
std::error_code status(const Twine &path, file_status &result,
                       bool follow = true);

/// A version for when a file descriptor is already available.
std::error_code status(int FD, file_status &Result);

/// Set file permissions.
///
/// @param Path File to set permissions on.
/// @param Permissions New file permissions.
/// @returns errc::success if the permissions were successfully set, otherwise
///          a platform-specific error_code.
/// @note On Windows, all permissions except *_write are ignored. Using any of
///       owner_write, group_write, or all_write will make the file writable.
///       Otherwise, the file will be marked as read-only.
std::error_code setPermissions(const Twine &Path, perms Permissions);

/// Get file permissions.
///
/// @param Path File to get permissions from.
/// @returns the permissions if they were successfully retrieved, otherwise a
///          platform-specific error_code.
/// @note On Windows, if the file does not have the FILE_ATTRIBUTE_READONLY
///       attribute, all_all will be returned. Otherwise, all_read | all_exe
///       will be returned.
ErrorOr<perms> getPermissions(const Twine &Path);

/// Get file size.
///
/// @param Path Input path.
/// @param Result Set to the size of the file in \a Path.
/// @returns errc::success if result has been successfully set, otherwise a
///          platform-specific error_code.
inline std::error_code file_size(const Twine &Path, uint64_t &Result) {
  file_status Status;
  std::error_code EC = status(Path, Status);
  if (EC)
    return EC;
  Result = Status.getSize();
  return std::error_code();
}

/// Set the file modification and access time.
///
/// @returns errc::success if the file times were successfully set, otherwise a
///          platform-specific error_code or errc::function_not_supported on
///          platforms where the functionality isn't available.
std::error_code setLastModificationAndAccessTime(int FD, TimePoint<> Time);

/// Is status available?
///
/// @param s Input file status.
/// @returns True if status() != status_error.
bool status_known(const basic_file_status &s);

/// Is status available?
///
/// @param path Input path.
/// @param result Set to true if status() != status_error.
/// @returns errc::success if result has been successfully set, otherwise a
///          platform-specific error_code.
std::error_code status_known(const Twine &path, bool &result);

enum OpenFlags : unsigned {
  F_None = 0,

  /// F_Excl - When opening a file, this flag makes raw_fd_ostream
  /// report an error if the file already exists.
  F_Excl = 1,

  /// F_Append - When opening a file, if it already exists append to the
  /// existing file instead of returning an error.  This may not be specified
  /// with F_Excl.
  F_Append = 2,

  /// F_NoTrunc - When opening a file, if it already exists don't truncate
  /// the file contents.  F_Append implies F_NoTrunc, but F_Append seeks to
  /// the end of the file, which F_NoTrunc doesn't.
  F_NoTrunc = 4,

  /// The file should be opened in text mode on platforms that make this
  /// distinction.
  F_Text = 8,

  /// Open the file for read and write.
  F_RW = 16,

  /// Delete the file on close. Only makes a difference on windows.
  F_Delete = 32
};

/// Create a uniquely named file.
///
/// Generates a unique path suitable for a temporary file and then opens it as a
/// file. The name is based on \a model with '%' replaced by a random char in
/// [0-9a-f]. If \a model is not an absolute path, the temporary file will be
/// created in the current directory.
///
/// Example: clang-%%-%%-%%-%%-%%.s => clang-a0-b1-c2-d3-e4.s
///
/// This is an atomic operation. Either the file is created and opened, or the
/// file system is left untouched.
///
/// The intended use is for files that are to be kept, possibly after
/// renaming them. For example, when running 'clang -c foo.o', the file can
/// be first created as foo-abc123.o and then renamed.
///
/// @param Model Name to base unique path off of.
/// @param ResultFD Set to the opened file's file descriptor.
/// @param ResultPath Set to the opened file's absolute path.
/// @returns errc::success if Result{FD,Path} have been successfully set,
///          otherwise a platform-specific error_code.
std::error_code createUniqueFile(const Twine &Model, int &ResultFD,
                                 SmallVectorImpl<char> &ResultPath,
                                 unsigned Mode = all_read | all_write,
                                 sys::fs::OpenFlags Flags = sys::fs::F_RW);

/// Simpler version for clients that don't want an open file. An empty
/// file will still be created.
std::error_code createUniqueFile(const Twine &Model,
                                 SmallVectorImpl<char> &ResultPath,
                                 unsigned Mode = all_read | all_write);

/// Represents a temporary file.
///
/// The temporary file must be eventually discarded or given a final name and
/// kept.
///
/// The destructor doesn't implicitly discard because there is no way to
/// properly handle errors in a destructor.
class TempFile {
  bool Done = false;
  TempFile(StringRef Name, int FD);

public:
  /// This creates a temporary file with createUniqueFile and schedules it for
  /// deletion with sys::RemoveFileOnSignal.
  static Expected<TempFile> create(const Twine &Model,
                                   unsigned Mode = all_read | all_write);
  TempFile(TempFile &&Other);
  TempFile &operator=(TempFile &&Other);

  // Name of the temporary file.
  std::string TmpName;

  // The open file descriptor.
  int FD = -1;

  // Keep this with the given name.
  Error keep(const Twine &Name);

  // Keep this with the temporary name.
  Error keep();

  // Delete the file.
  Error discard();

  // This checks that keep or delete was called.
  ~TempFile();
};

/// Create a file in the system temporary directory.
///
/// The filename is of the form prefix-random_chars.suffix. Since the directory
/// is not know to the caller, Prefix and Suffix cannot have path separators.
/// The files are created with mode 0600.
///
/// This should be used for things like a temporary .s that is removed after
/// running the assembler.
std::error_code createTemporaryFile(const Twine &Prefix, StringRef Suffix,
                                    int &ResultFD,
                                    SmallVectorImpl<char> &ResultPath,
                                    sys::fs::OpenFlags Flags = sys::fs::F_RW);

/// Simpler version for clients that don't want an open file. An empty
/// file will still be created.
std::error_code createTemporaryFile(const Twine &Prefix, StringRef Suffix,
                                    SmallVectorImpl<char> &ResultPath);

std::error_code createUniqueDirectory(const Twine &Prefix,
                                      SmallVectorImpl<char> &ResultPath);

/// Get a unique name, not currently exisiting in the filesystem. Subject
/// to race conditions, prefer to use createUniqueFile instead.
///
/// Similar to createUniqueFile, but instead of creating a file only
/// checks if it exists. This function is subject to race conditions, if you
/// want to use the returned name to actually create a file, use
/// createUniqueFile instead.
std::error_code getPotentiallyUniqueFileName(const Twine &Model,
                                             SmallVectorImpl<char> &ResultPath);

/// Get a unique temporary file name, not currently exisiting in the
/// filesystem. Subject to race conditions, prefer to use createTemporaryFile
/// instead.
///
/// Similar to createTemporaryFile, but instead of creating a file only
/// checks if it exists. This function is subject to race conditions, if you
/// want to use the returned name to actually create a file, use
/// createTemporaryFile instead.
std::error_code
getPotentiallyUniqueTempFileName(const Twine &Prefix, StringRef Suffix,
                                 SmallVectorImpl<char> &ResultPath);

inline OpenFlags operator|(OpenFlags A, OpenFlags B) {
  return OpenFlags(unsigned(A) | unsigned(B));
}

inline OpenFlags &operator|=(OpenFlags &A, OpenFlags B) {
  A = A | B;
  return A;
}

/// @brief Opens the file with the given name in a write-only or read-write
/// mode, returning its open file descriptor. If the file does not exist, it
/// is created.
///
/// The caller is responsible for closing the file descriptor once they are
/// finished with it.
///
/// @param Name The path of the file to open, relative or absolute.
/// @param ResultFD If the file could be opened successfully, its descriptor
///                 is stored in this location. Otherwise, this is set to -1.
/// @param Flags Additional flags used to determine whether the file should be
///              opened in, for example, read-write or in write-only mode.
/// @param Mode The access permissions of the file, represented in octal.
/// @returns errc::success if \a Name has been opened, otherwise a
///          platform-specific error_code.
std::error_code openFileForWrite(const Twine &Name, int &ResultFD,
                                 OpenFlags Flags, unsigned Mode = 0666);

/// @brief Opens the file with the given name in a write-only or read-write
/// mode, returning its open file descriptor. If the file does not exist, it
/// is created.
///
/// The caller is responsible for closing the freeing the file once they are
/// finished with it.
///
/// @param Name The path of the file to open, relative or absolute.
/// @param Flags Additional flags used to determine whether the file should be
///              opened in, for example, read-write or in write-only mode.
/// @param Mode The access permissions of the file, represented in octal.
/// @returns a platform-specific file descriptor if \a Name has been opened,
///          otherwise an error object.
Expected<file_t> openNativeFileForWrite(const Twine &Name, OpenFlags Flags,
                                        unsigned Mode = 0666);

/// @brief Opens the file with the given name in a read-only mode, returning
/// its open file descriptor.
///
/// The caller is responsible for closing the file descriptor once they are
/// finished with it.
///
/// @param Name The path of the file to open, relative or absolute.
/// @param ResultFD If the file could be opened successfully, its descriptor
///                 is stored in this location. Otherwise, this is set to -1.
/// @param RealPath If nonnull, extra work is done to determine the real path
///                 of the opened file, and that path is stored in this
///                 location.
/// @returns errc::success if \a Name has been opened, otherwise a
///          platform-specific error_code.
std::error_code openFileForRead(const Twine &Name, int &ResultFD,
                                SmallVectorImpl<char> *RealPath = nullptr);

/// @brief Opens the file with the given name in a read-only mode, returning
/// its open file descriptor.
///
/// The caller is responsible for closing the freeing the file once they are
/// finished with it.
///
/// @param Name The path of the file to open, relative or absolute.
/// @param RealPath If nonnull, extra work is done to determine the real path
///                 of the opened file, and that path is stored in this
///                 location.
/// @returns a platform-specific file descriptor if \a Name has been opened,
///          otherwise an error object.
Expected<file_t>
openNativeFileForRead(const Twine &Name,
                      SmallVectorImpl<char> *RealPath = nullptr);

/// @brief Close the file object.  This should be used instead of ::close for
/// portability.
///
/// @param F On input, this is the file to close.  On output, the file is
/// set to kInvalidFile.
void closeFile(file_t &F);

std::error_code getUniqueID(const Twine Path, UniqueID &Result);

/// Get disk space usage information.
///
/// Note: Users must be careful about "Time Of Check, Time Of Use" kind of bug.
/// Note: Windows reports results according to the quota allocated to the user.
///
/// @param Path Input path.
/// @returns a space_info structure filled with the capacity, free, and
/// available space on the device \a Path is on. A platform specific error_code
/// is returned on error.
ErrorOr<space_info> disk_space(const Twine &Path);

/// This class represents a memory mapped file. It is based on
/// boost::iostreams::mapped_file.
class mapped_file_region {
public:
  enum mapmode {
    readonly, ///< May only access map via const_data as read only.
    readwrite, ///< May access map via data and modify it. Written to path.
    priv ///< May modify via data, but changes are lost on destruction.
  };

private:
  /// Platform-specific mapping state.
  size_t Size;
  void *Mapping;
  int FD;
  mapmode Mode;

  std::error_code init(int FD, uint64_t Offset, mapmode Mode);

public:
  mapped_file_region() = delete;
  mapped_file_region(mapped_file_region&) = delete;
  mapped_file_region &operator =(mapped_file_region&) = delete;

  /// \param fd An open file descriptor to map. mapped_file_region takes
  ///   ownership if closefd is true. It must have been opended in the correct
  ///   mode.
  mapped_file_region(int fd, mapmode mode, size_t length, uint64_t offset,
                     std::error_code &ec);

  ~mapped_file_region();

  size_t size() const;
  char *data() const;

  /// Get a const view of the data. Modifying this memory has undefined
  /// behavior.
  const char *const_data() const;

  /// \returns The minimum alignment offset must be.
  static int alignment();
};

/// Return the path to the main executable, given the value of argv[0] from
/// program startup and the address of main itself. In extremis, this function
/// may fail and return an empty path.
std::string getMainExecutable(const char *argv0, void *MainExecAddr);

/// @}
/// @name Iterators
/// @{

/// directory_entry - A single entry in a directory. Caches the status either
/// from the result of the iteration syscall, or the first time status is
/// called.
class directory_entry {
  std::string Path;
  bool FollowSymlinks;
  basic_file_status Status;

public:
  explicit directory_entry(const Twine &path, bool follow_symlinks = true,
                           basic_file_status st = basic_file_status())
      : Path(path.str()), FollowSymlinks(follow_symlinks), Status(st) {}

  directory_entry() = default;

  void assign(const Twine &path, basic_file_status st = basic_file_status()) {
    Path = path.str();
    Status = st;
  }

  void replace_filename(const Twine &filename,
                        basic_file_status st = basic_file_status());

  const std::string &path() const { return Path; }
  ErrorOr<basic_file_status> status() const;

  bool operator==(const directory_entry& rhs) const { return Path == rhs.Path; }
  bool operator!=(const directory_entry& rhs) const { return !(*this == rhs); }
  bool operator< (const directory_entry& rhs) const;
  bool operator<=(const directory_entry& rhs) const;
  bool operator> (const directory_entry& rhs) const;
  bool operator>=(const directory_entry& rhs) const;
};

namespace detail {

  struct DirIterState;

  std::error_code directory_iterator_construct(DirIterState &, StringRef, bool);
  std::error_code directory_iterator_increment(DirIterState &);
  std::error_code directory_iterator_destruct(DirIterState &);

  /// Keeps state for the directory_iterator.
  struct DirIterState {
    ~DirIterState() {
      directory_iterator_destruct(*this);
    }

    intptr_t IterationHandle = 0;
    directory_entry CurrentEntry;
  };

} // end namespace detail

/// directory_iterator - Iterates through the entries in path. There is no
/// operator++ because we need an error_code. If it's really needed we can make
/// it call report_fatal_error on error.
class directory_iterator {
  std::shared_ptr<detail::DirIterState> State;
  bool FollowSymlinks = true;

public:
  explicit directory_iterator(const Twine &path, std::error_code &ec,
                              bool follow_symlinks = true)
      : FollowSymlinks(follow_symlinks) {
    State = std::make_shared<detail::DirIterState>();
    SmallString<128> path_storage;
    ec = detail::directory_iterator_construct(
        *State, path.toStringRef(path_storage), FollowSymlinks);
    update_error_code_for_current_entry(ec);
  }

  explicit directory_iterator(const directory_entry &de, std::error_code &ec,
                              bool follow_symlinks = true)
      : FollowSymlinks(follow_symlinks) {
    State = std::make_shared<detail::DirIterState>();
    ec = detail::directory_iterator_construct(
        *State, de.path(), FollowSymlinks);
    update_error_code_for_current_entry(ec);
  }

  /// Construct end iterator.
  directory_iterator() = default;

  // No operator++ because we need error_code.
  directory_iterator &increment(std::error_code &ec) {
    ec = directory_iterator_increment(*State);
    update_error_code_for_current_entry(ec);
    return *this;
  }

  const directory_entry &operator*() const { return State->CurrentEntry; }
  const directory_entry *operator->() const { return &State->CurrentEntry; }

  bool operator==(const directory_iterator &RHS) const {
    if (State == RHS.State)
      return true;
    if (!RHS.State)
      return State->CurrentEntry == directory_entry();
    if (!State)
      return RHS.State->CurrentEntry == directory_entry();
    return State->CurrentEntry == RHS.State->CurrentEntry;
  }

  bool operator!=(const directory_iterator &RHS) const {
    return !(*this == RHS);
  }
  // Other members as required by
  // C++ Std, 24.1.1 Input iterators [input.iterators]

private:
  // Checks if current entry is valid and populates error code. For example,
  // current entry may not exist due to broken symbol links.
  void update_error_code_for_current_entry(std::error_code &ec) {
    // Bail out if error has already occured earlier to avoid overwriting it.
    if (ec)
      return;

    // Empty directory entry is used to mark the end of an interation, it's not
    // an error.
    if (State->CurrentEntry == directory_entry())
      return;

    ErrorOr<basic_file_status> status = State->CurrentEntry.status();
    if (!status)
      ec = status.getError();
  }
};

namespace detail {

  /// Keeps state for the recursive_directory_iterator.
  struct RecDirIterState {
    std::stack<directory_iterator, std::vector<directory_iterator>> Stack;
    uint16_t Level = 0;
    bool HasNoPushRequest = false;
  };

} // end namespace detail

/// recursive_directory_iterator - Same as directory_iterator except for it
/// recurses down into child directories.
class recursive_directory_iterator {
  std::shared_ptr<detail::RecDirIterState> State;
  bool Follow;

public:
  recursive_directory_iterator() = default;
  explicit recursive_directory_iterator(const Twine &path, std::error_code &ec,
                                        bool follow_symlinks = true)
      : State(std::make_shared<detail::RecDirIterState>()),
        Follow(follow_symlinks) {
    State->Stack.push(directory_iterator(path, ec, Follow));
    if (State->Stack.top() == directory_iterator())
      State.reset();
  }

  // No operator++ because we need error_code.
  recursive_directory_iterator &increment(std::error_code &ec) {
    const directory_iterator end_itr = {};

    if (State->HasNoPushRequest)
      State->HasNoPushRequest = false;
    else {
      ErrorOr<basic_file_status> status = State->Stack.top()->status();
      if (status && is_directory(*status)) {
        State->Stack.push(directory_iterator(*State->Stack.top(), ec, Follow));
        if (State->Stack.top() != end_itr) {
          ++State->Level;
          return *this;
        }
        State->Stack.pop();
      }
    }

    while (!State->Stack.empty()
           && State->Stack.top().increment(ec) == end_itr) {
      State->Stack.pop();
      --State->Level;
    }

    // Check if we are done. If so, create an end iterator.
    if (State->Stack.empty())
      State.reset();

    return *this;
  }

  const directory_entry &operator*() const { return *State->Stack.top(); }
  const directory_entry *operator->() const { return &*State->Stack.top(); }

  // observers
  /// Gets the current level. Starting path is at level 0.
  int level() const { return State->Level; }

  /// Returns true if no_push has been called for this directory_entry.
  bool no_push_request() const { return State->HasNoPushRequest; }

  // modifiers
  /// Goes up one level if Level > 0.
  void pop() {
    assert(State && "Cannot pop an end iterator!");
    assert(State->Level > 0 && "Cannot pop an iterator with level < 1");

    const directory_iterator end_itr = {};
    std::error_code ec;
    do {
      if (ec)
        report_fatal_error("Error incrementing directory iterator.");
      State->Stack.pop();
      --State->Level;
    } while (!State->Stack.empty()
             && State->Stack.top().increment(ec) == end_itr);

    // Check if we are done. If so, create an end iterator.
    if (State->Stack.empty())
      State.reset();
  }

  /// Does not go down into the current directory_entry.
  void no_push() { State->HasNoPushRequest = true; }

  bool operator==(const recursive_directory_iterator &RHS) const {
    return State == RHS.State;
  }

  bool operator!=(const recursive_directory_iterator &RHS) const {
    return !(*this == RHS);
  }
  // Other members as required by
  // C++ Std, 24.1.1 Input iterators [input.iterators]
};

/// @}

} // end namespace fs
} // end namespace sys
} // end namespace llvm

#endif // LLVM_SUPPORT_FILESYSTEM_H
