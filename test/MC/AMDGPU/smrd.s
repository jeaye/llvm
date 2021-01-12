// RUN: not llvm-mc -arch=amdgcn -show-encoding %s | FileCheck --check-prefix=GCN  %s
// RUN: not llvm-mc -arch=amdgcn -mcpu=tahiti -show-encoding %s | FileCheck --check-prefix=GCN %s
// RUN: llvm-mc -arch=amdgcn -mcpu=bonaire -show-encoding %s | FileCheck --check-prefixes=GCN,CI %s
// RUN: not llvm-mc -arch=amdgcn -mcpu=fiji -show-encoding %s | FileCheck --check-prefix=VI %s

// RUN: not llvm-mc -arch=amdgcn %s 2>&1 | FileCheck %s --check-prefix=NOSI --implicit-check-not=error:
// RUN: not llvm-mc -arch=amdgcn -mcpu=tahiti  %s 2>&1 | FileCheck %s --check-prefix=NOSI --implicit-check-not=error:
// RUN: not llvm-mc -arch=amdgcn -mcpu=fiji  %s 2>&1 | FileCheck %s --check-prefix=NOVI --implicit-check-not=error:

//===----------------------------------------------------------------------===//
// Offset Handling
//===----------------------------------------------------------------------===//

s_load_dword s1, s[2:3], 0xfc
// GCN: s_load_dword s1, s[2:3], 0xfc ; encoding: [0xfc,0x83,0x00,0xc0]
// VI:	s_load_dword s1, s[2:3], 0xfc   ; encoding: [0x41,0x00,0x02,0xc0,0xfc,0x00,0x00,0x00]

s_load_dword s1, s[2:3], 0xff
// GCN: s_load_dword s1, s[2:3], 0xff ; encoding: [0xff,0x83,0x00,0xc0]
// VI:	s_load_dword s1, s[2:3], 0xff   ; encoding: [0x41,0x00,0x02,0xc0,0xff,0x00,0x00,0x00]

s_load_dword s1, s[2:3], 0x100
// NOSI: error: operands are not valid for this GPU or mode
// CI: s_load_dword s1, s[2:3], 0x100 ; encoding: [0xff,0x82,0x00,0xc0,0x00,0x01,0x00,0x00]
// VI: s_load_dword s1, s[2:3], 0x100 ; encoding: [0x41,0x00,0x02,0xc0,0x00,0x01,0x00,0x00]

s_load_dword s1, s[2:3], 0xfffff
// NOSI: error: operands are not valid for this GPU or mode
// CI: s_load_dword s1, s[2:3], 0xfffff ; encoding: [0xff,0x82,0x00,0xc0,0xff,0xff,0x0f,0x00]
// VI: s_load_dword s1, s[2:3], 0xfffff ; encoding: [0x41,0x00,0x02,0xc0,0xff,0xff,0x0f,0x00]

s_load_dword s1, s[2:3], 0x100000
// NOSI: error: operands are not valid for this GPU or mode
// CI: s_load_dword s1, s[2:3], 0x100000 ; encoding: [0xff,0x82,0x00,0xc0,0x00,0x00,0x10,0x00]
// NOVI: error: expected a 20-bit unsigned offset

s_load_dword s1, s[2:3], 0xffffffff
// NOSI: error: operands are not valid for this GPU or mode
// CI: s_load_dword s1, s[2:3], 0xffffffff ; encoding: [0xff,0x82,0x00,0xc0,0xff,0xff,0xff,0xff]
// NOVI: error: expected a 20-bit unsigned offset

//===----------------------------------------------------------------------===//
// Instructions
//===----------------------------------------------------------------------===//

s_load_dword s1, s[2:3], 1
// GCN: s_load_dword s1, s[2:3], 0x1 ; encoding: [0x01,0x83,0x00,0xc0]
// VI:	s_load_dword s1, s[2:3], 0x1 ; encoding: [0x41,0x00,0x02,0xc0,0x01,0x00,0x00,0x00]

s_load_dword s1, s[2:3], s4
// GCN: s_load_dword s1, s[2:3], s4 ; encoding: [0x04,0x82,0x00,0xc0]
// VI:	s_load_dword s1, s[2:3], s4 ; encoding: [0x41,0x00,0x00,0xc0,0x04,0x00,0x00,0x00]

s_load_dword tba_lo, s[2:3], s4
// GCN: s_load_dword tba_lo, s[2:3], s4 ; encoding: [0x04,0x02,0x36,0xc0]
// VI:	s_load_dword tba_lo, s[2:3], s4 ; encoding: [0x01,0x1b,0x00,0xc0,0x04,0x00,0x00,0x00]

s_load_dword tba_hi, s[2:3], s4
// GCN: s_load_dword tba_hi, s[2:3], s4 ; encoding: [0x04,0x82,0x36,0xc0]
// VI:	s_load_dword tba_hi, s[2:3], s4 ; encoding: [0x41,0x1b,0x00,0xc0,0x04,0x00,0x00,0x00]

s_load_dword tma_lo, s[2:3], s4
// GCN: s_load_dword tma_lo, s[2:3], s4 ; encoding: [0x04,0x02,0x37,0xc0]
// VI:	s_load_dword tma_lo, s[2:3], s4 ; encoding: [0x81,0x1b,0x00,0xc0,0x04,0x00,0x00,0x00]

s_load_dword tma_hi, s[2:3], s4
// GCN: s_load_dword tma_hi, s[2:3], s4 ; encoding: [0x04,0x82,0x37,0xc0]
// VI:	s_load_dword tma_hi, s[2:3], s4 ; encoding: [0xc1,0x1b,0x00,0xc0,0x04,0x00,0x00,0x00]

s_load_dword ttmp0, s[2:3], s4
// GCN: s_load_dword ttmp0, s[2:3], s4 ; encoding: [0x04,0x02,0x38,0xc0]
// VI:	s_load_dword ttmp0, s[2:3], s4 ; encoding: [0x01,0x1c,0x00,0xc0,0x04,0x00,0x00,0x00]

s_load_dwordx2 s[2:3], s[2:3], 1
// GCN: s_load_dwordx2 s[2:3], s[2:3], 0x1 ; encoding: [0x01,0x03,0x41,0xc0]
// VI:	s_load_dwordx2 s[2:3], s[2:3], 0x1 ; encoding: [0x81,0x00,0x06,0xc0,0x01,0x00,0x00,0x00]

s_load_dwordx2 s[2:3], s[2:3], s4
// GCN: s_load_dwordx2 s[2:3], s[2:3], s4 ; encoding: [0x04,0x02,0x41,0xc0]
// VI:	s_load_dwordx2 s[2:3], s[2:3], s4 ; encoding: [0x81,0x00,0x04,0xc0,0x04,0x00,0x00,0x00]

s_load_dwordx2 tba, s[2:3], s4
// GCN: s_load_dwordx2 tba, s[2:3], s4 ; encoding: [0x04,0x02,0x76,0xc0]
// VI:	s_load_dwordx2 tba, s[2:3], s4 ; encoding: [0x01,0x1b,0x04,0xc0,0x04,0x00,0x00,0x00]

s_load_dwordx2 tma, s[2:3], s4
// GCN: s_load_dwordx2 tma, s[2:3], s4 ; encoding: [0x04,0x02,0x77,0xc0]
// VI:	s_load_dwordx2 tma, s[2:3], s4 ; encoding: [0x81,0x1b,0x04,0xc0,0x04,0x00,0x00,0x00]

s_load_dwordx2 ttmp[2:3], s[2:3], s4
// GCN: s_load_dwordx2 ttmp[2:3], s[2:3], s4 ; encoding: [0x04,0x02,0x79,0xc0]
// VI:	s_load_dwordx2 ttmp[2:3], s[2:3], s4 ; encoding: [0x81,0x1c,0x04,0xc0,0x04,0x00,0x00,0x00]

s_load_dwordx4 s[4:7], s[2:3], 1
// GCN: s_load_dwordx4 s[4:7], s[2:3], 0x1 ; encoding: [0x01,0x03,0x82,0xc0]
// VI:	s_load_dwordx4 s[4:7], s[2:3], 0x1 ; encoding: [0x01,0x01,0x0a,0xc0,0x01,0x00,0x00,0x00]

s_load_dwordx4 s[4:7], s[2:3], s4
// GCN: s_load_dwordx4 s[4:7], s[2:3], s4 ; encoding: [0x04,0x02,0x82,0xc0]
// VI:	s_load_dwordx4 s[4:7], s[2:3], s4 ; encoding: [0x01,0x01,0x08,0xc0,0x04,0x00,0x00,0x00]

s_load_dwordx4 ttmp[4:7], ttmp[2:3], ttmp4
// GCN: s_load_dwordx4 ttmp[4:7], ttmp[2:3], ttmp4 ; encoding: [0x74,0x72,0xba,0xc0]
// VI:	s_load_dwordx4 ttmp[4:7], ttmp[2:3], ttmp4 ; encoding: [0x39,0x1d,0x08,0xc0,0x74,0x00,0x00,0x00]

s_load_dwordx4 s[100:103], s[2:3], s4
// GCN: s_load_dwordx4 s[100:103], s[2:3], s4 ; encoding: [0x04,0x02,0xb2,0xc0]
// NOVI: error: register not available on this GPU

s_load_dwordx8 s[8:15], s[2:3], 1
// GCN: s_load_dwordx8 s[8:15], s[2:3], 0x1 ; encoding: [0x01,0x03,0xc4,0xc0]
// VI:	s_load_dwordx8 s[8:15], s[2:3], 0x1 ; encoding: [0x01,0x02,0x0e,0xc0,0x01,0x00,0x00,0x00]

s_load_dwordx8 s[8:15], s[2:3], s4
// GCN: s_load_dwordx8 s[8:15], s[2:3], s4 ; encoding: [0x04,0x02,0xc4,0xc0]
// VI:	s_load_dwordx8 s[8:15], s[2:3], s4 ; encoding: [0x01,0x02,0x0c,0xc0,0x04,0x00,0x00,0x00]

s_load_dwordx8 s[96:103], s[2:3], s4
// GCN: s_load_dwordx8 s[96:103], s[2:3], s4 ; encoding: [0x04,0x02,0xf0,0xc0]
// NOVI: error: register not available on this GPU

s_load_dwordx16 s[16:31], s[2:3], 1
// GCN: s_load_dwordx16 s[16:31], s[2:3], 0x1 ; encoding: [0x01,0x03,0x08,0xc1]
// VI:	s_load_dwordx16 s[16:31], s[2:3], 0x1 ; encoding: [0x01,0x04,0x12,0xc0,0x01,0x00,0x00,0x00]

s_load_dwordx16 s[16:31], s[2:3], s4
// GCN: s_load_dwordx16 s[16:31], s[2:3], s4 ; encoding: [0x04,0x02,0x08,0xc1]
// VI:	s_load_dwordx16 s[16:31], s[2:3], s4 ; encoding: [0x01,0x04,0x10,0xc0,0x04,0x00,0x00,0x00]

s_load_dwordx16 s[88:103], s[2:3], s4
// GCN: s_load_dwordx16 s[88:103], s[2:3], s4 ; encoding: [0x04,0x02,0x2c,0xc1]
// NOVI: error: register not available on this GPU

s_buffer_load_dword s1, s[4:7], 1
// GCN: s_buffer_load_dword s1, s[4:7], 0x1 ; encoding: [0x01,0x85,0x00,0xc2]
// VI:	s_buffer_load_dword s1, s[4:7], 0x1    ; encoding: [0x42,0x00,0x22,0xc0,0x01,0x00,0x00,0x00]

s_buffer_load_dword s1, s[4:7], s4
// GCN: s_buffer_load_dword s1, s[4:7], s4 ; encoding: [0x04,0x84,0x00,0xc2]
// VI:	s_buffer_load_dword s1, s[4:7], s4 ; encoding: [0x42,0x00,0x20,0xc0,0x04,0x00,0x00,0x00]

s_buffer_load_dword tba_lo, s[4:7], s4
// GCN: s_buffer_load_dword tba_lo, s[4:7], s4 ; encoding: [0x04,0x04,0x36,0xc2]
// VI:	s_buffer_load_dword tba_lo, s[4:7], s4 ; encoding: [0x02,0x1b,0x20,0xc0,0x04,0x00,0x00,0x00]

s_buffer_load_dword tba_hi, s[4:7], s4
// GCN: s_buffer_load_dword tba_hi, s[4:7], s4 ; encoding: [0x04,0x84,0x36,0xc2]
// VI:	s_buffer_load_dword tba_hi, s[4:7], s4 ; encoding: [0x42,0x1b,0x20,0xc0,0x04,0x00,0x00,0x00]

s_buffer_load_dword tma_lo, s[4:7], s4
// GCN: s_buffer_load_dword tma_lo, s[4:7], s4 ; encoding: [0x04,0x04,0x37,0xc2]
// VI:	s_buffer_load_dword tma_lo, s[4:7], s4 ; encoding: [0x82,0x1b,0x20,0xc0,0x04,0x00,0x00,0x00]

s_buffer_load_dword tma_hi, s[4:7], s4
// GCN: s_buffer_load_dword tma_hi, s[4:7], s4 ; encoding: [0x04,0x84,0x37,0xc2]
// VI:	s_buffer_load_dword tma_hi, s[4:7], s4 ; encoding: [0xc2,0x1b,0x20,0xc0,0x04,0x00,0x00,0x00]

s_buffer_load_dword ttmp1, ttmp[4:7], ttmp4
// GCN: s_buffer_load_dword ttmp1, ttmp[4:7], ttmp4 ; encoding: [0x74,0xf4,0x38,0xc2]
// VI:	s_buffer_load_dword ttmp1, ttmp[4:7], ttmp4 ; encoding: [0x7a,0x1c,0x20,0xc0,0x74,0x00,0x00,0x00]

s_buffer_load_dwordx2 s[8:9], s[4:7], 1
// GCN: s_buffer_load_dwordx2 s[8:9], s[4:7], 0x1 ; encoding: [0x01,0x05,0x44,0xc2]
// VI:	s_buffer_load_dwordx2 s[8:9], s[4:7], 0x1 ; encoding: [0x02,0x02,0x26,0xc0,0x01,0x00,0x00,0x00]

s_buffer_load_dwordx2 s[8:9], s[4:7], s4
// GCN: s_buffer_load_dwordx2 s[8:9], s[4:7], s4 ; encoding: [0x04,0x04,0x44,0xc2]
// VI:	s_buffer_load_dwordx2 s[8:9], s[4:7], s4 ; encoding: [0x02,0x02,0x24,0xc0,0x04,0x00,0x00,0x00]

s_buffer_load_dwordx2 tba, s[4:7], s4
// GCN: s_buffer_load_dwordx2 tba, s[4:7], s4 ; encoding: [0x04,0x04,0x76,0xc2]
// VI:	s_buffer_load_dwordx2 tba, s[4:7], s4 ; encoding: [0x02,0x1b,0x24,0xc0,0x04,0x00,0x00,0x00]

s_buffer_load_dwordx2 tma, s[4:7], s4
// GCN: s_buffer_load_dwordx2 tma, s[4:7], s4 ; encoding: [0x04,0x04,0x77,0xc2]
// VI:	s_buffer_load_dwordx2 tma, s[4:7], s4 ; encoding: [0x82,0x1b,0x24,0xc0,0x04,0x00,0x00,0x00]

s_buffer_load_dwordx4 s[8:11], s[4:7], 1
// GCN: s_buffer_load_dwordx4 s[8:11], s[4:7], 0x1 ; encoding: [0x01,0x05,0x84,0xc2]
// VI:	s_buffer_load_dwordx4 s[8:11], s[4:7], 0x1 ; encoding: [0x02,0x02,0x2a,0xc0,0x01,0x00,0x00,0x00]

s_buffer_load_dwordx4 s[8:11], s[4:7], s4
// GCN: s_buffer_load_dwordx4 s[8:11], s[4:7], s4 ; encoding: [0x04,0x04,0x84,0xc2]
// VI:	s_buffer_load_dwordx4 s[8:11], s[4:7], s4 ; encoding: [0x02,0x02,0x28,0xc0,0x04,0x00,0x00,0x00]

s_buffer_load_dwordx4 ttmp[8:11], ttmp[4:7], ttmp4
// GCN: s_buffer_load_dwordx4 ttmp[8:11], ttmp[4:7], ttmp4 ; encoding: [0x74,0x74,0xbc,0xc2]
// VI:	s_buffer_load_dwordx4 ttmp[8:11], ttmp[4:7], ttmp4 ; encoding: [0x3a,0x1e,0x28,0xc0,0x74,0x00,0x00,0x00]

s_buffer_load_dwordx4 s[100:103], s[4:7], s4
// GCN: s_buffer_load_dwordx4 s[100:103], s[4:7], s4 ; encoding: [0x04,0x04,0xb2,0xc2]
// NOVI: error: register not available on this GPU

s_buffer_load_dwordx8 s[8:15], s[4:7], 1
// GCN: s_buffer_load_dwordx8 s[8:15], s[4:7], 0x1 ; encoding: [0x01,0x05,0xc4,0xc2]
// VI:	s_buffer_load_dwordx8 s[8:15], s[4:7], 0x1 ; encoding: [0x02,0x02,0x2e,0xc0,0x01,0x00,0x00,0x00]

s_buffer_load_dwordx8 s[8:15], s[4:7], s4
// GCN: s_buffer_load_dwordx8 s[8:15], s[4:7], s4 ; encoding: [0x04,0x04,0xc4,0xc2]
// VI:	s_buffer_load_dwordx8 s[8:15], s[4:7], s4 ; encoding: [0x02,0x02,0x2c,0xc0,0x04,0x00,0x00,0x00]

s_buffer_load_dwordx8 s[96:103], s[4:7], s4
// GCN: s_buffer_load_dwordx8 s[96:103], s[4:7], s4 ; encoding: [0x04,0x04,0xf0,0xc2]
// NOVI: error: register not available on this GPU

s_buffer_load_dwordx16 s[16:31], s[4:7], 1
// GCN: s_buffer_load_dwordx16 s[16:31], s[4:7], 0x1 ; encoding: [0x01,0x05,0x08,0xc3]
// VI:	s_buffer_load_dwordx16 s[16:31], s[4:7], 0x1 ; encoding: [0x02,0x04,0x32,0xc0,0x01,0x00,0x00,0x00]

s_buffer_load_dwordx16 s[16:31], s[4:7], s4
// GCN: s_buffer_load_dwordx16 s[16:31], s[4:7], s4 ; encoding: [0x04,0x04,0x08,0xc3]
// VI:	s_buffer_load_dwordx16 s[16:31], s[4:7], s4 ; encoding: [0x02,0x04,0x30,0xc0,0x04,0x00,0x00,0x00]

s_buffer_load_dwordx16 s[88:103], s[4:7], s4
// GCN: s_buffer_load_dwordx16 s[88:103], s[4:7], s4 ; encoding: [0x04,0x04,0x2c,0xc3]
// NOVI: error: register not available on this GPU

s_dcache_inv
// GCN: s_dcache_inv ; encoding: [0x00,0x00,0xc0,0xc7]
// VI:	s_dcache_inv                    ; encoding: [0x00,0x00,0x80,0xc0,0x00,0x00,0x00,0x00]

s_dcache_inv_vol
// CI: s_dcache_inv_vol ; encoding: [0x00,0x00,0x40,0xc7]
// NOSI: error: instruction not supported on this GPU
// VI: s_dcache_inv_vol                ; encoding: [0x00,0x00,0x88,0xc0,0x00,0x00,0x00,0x00]

s_memtime s[4:5]
// GCN: s_memtime s[4:5] ; encoding: [0x00,0x00,0x82,0xc7]
// VI:	s_memtime s[4:5] ; encoding: [0x00,0x01,0x90,0xc0,0x00,0x00,0x00,0x00]

s_memtime tba
// GCN: s_memtime tba ; encoding: [0x00,0x00,0xb6,0xc7]
// VI:	s_memtime tba ; encoding: [0x00,0x1b,0x90,0xc0,0x00,0x00,0x00,0x00]

s_memtime tma
// GCN: s_memtime tma ; encoding: [0x00,0x00,0xb7,0xc7]
// VI:	s_memtime tma ; encoding: [0x80,0x1b,0x90,0xc0,0x00,0x00,0x00,0x00]
