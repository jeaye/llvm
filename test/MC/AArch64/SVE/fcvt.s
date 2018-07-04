// RUN: llvm-mc -triple=aarch64 -show-encoding -mattr=+sve < %s \
// RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
// RUN: not llvm-mc -triple=aarch64 -show-encoding < %s 2>&1 \
// RUN:        | FileCheck %s --check-prefix=CHECK-ERROR
// RUN: llvm-mc -triple=aarch64 -filetype=obj -mattr=+sve < %s \
// RUN:        | llvm-objdump -d -mattr=+sve - | FileCheck %s --check-prefix=CHECK-INST
// RUN: llvm-mc -triple=aarch64 -filetype=obj -mattr=+sve < %s \
// RUN:        | llvm-objdump -d - | FileCheck %s --check-prefix=CHECK-UNKNOWN

fcvt    z0.h, p0/m, z0.s
// CHECK-INST: fcvt    z0.h, p0/m, z0.s
// CHECK-ENCODING: [0x00,0xa0,0x88,0x65]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 00 a0 88 65 <unknown>

fcvt    z0.h, p0/m, z0.d
// CHECK-INST: fcvt    z0.h, p0/m, z0.d
// CHECK-ENCODING: [0x00,0xa0,0xc8,0x65]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 00 a0 c8 65 <unknown>

fcvt    z0.s, p0/m, z0.h
// CHECK-INST: fcvt    z0.s, p0/m, z0.h
// CHECK-ENCODING: [0x00,0xa0,0x89,0x65]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 00 a0 89 65 <unknown>

fcvt    z0.s, p0/m, z0.d
// CHECK-INST: fcvt    z0.s, p0/m, z0.d
// CHECK-ENCODING: [0x00,0xa0,0xca,0x65]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 00 a0 ca 65 <unknown>

fcvt    z0.d, p0/m, z0.h
// CHECK-INST: fcvt    z0.d, p0/m, z0.h
// CHECK-ENCODING: [0x00,0xa0,0xc9,0x65]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 00 a0 c9 65 <unknown>

fcvt    z0.d, p0/m, z0.s
// CHECK-INST: fcvt    z0.d, p0/m, z0.s
// CHECK-ENCODING: [0x00,0xa0,0xcb,0x65]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 00 a0 cb 65 <unknown>
