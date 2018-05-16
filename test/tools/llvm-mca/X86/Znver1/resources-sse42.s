# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=znver1 -instruction-tables < %s | FileCheck %s

crc32b      %al, %ecx
crc32b      (%rax), %ecx

crc32l      %eax, %ecx
crc32l      (%rax), %ecx

crc32w      %ax, %ecx
crc32w      (%rax), %ecx

crc32b      %al, %rcx
crc32b      (%rax), %rcx

crc32q      %rax, %rcx
crc32q      (%rax), %rcx

pcmpestri   $1, %xmm0, %xmm2
pcmpestri   $1, (%rax), %xmm2

pcmpestrm   $1, %xmm0, %xmm2
pcmpestrm   $1, (%rax), %xmm2

pcmpistri   $1, %xmm0, %xmm2
pcmpistri   $1, (%rax), %xmm2

pcmpistrm   $1, %xmm0, %xmm2
pcmpistrm   $1, (%rax), %xmm2

pcmpgtq     %xmm0, %xmm2
pcmpgtq     (%rax), %xmm2

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      3     1.00                        crc32b	%al, %ecx
# CHECK-NEXT:  1      10    1.00    *                   crc32b	(%rax), %ecx
# CHECK-NEXT:  1      3     1.00                        crc32l	%eax, %ecx
# CHECK-NEXT:  1      10    1.00    *                   crc32l	(%rax), %ecx
# CHECK-NEXT:  1      3     1.00                        crc32w	%ax, %ecx
# CHECK-NEXT:  1      10    1.00    *                   crc32w	(%rax), %ecx
# CHECK-NEXT:  1      3     1.00                        crc32b	%al, %rcx
# CHECK-NEXT:  1      10    1.00    *                   crc32b	(%rax), %rcx
# CHECK-NEXT:  1      3     1.00                        crc32q	%rax, %rcx
# CHECK-NEXT:  1      10    1.00    *                   crc32q	(%rax), %rcx
# CHECK-NEXT:  1      100    -                          pcmpestri	$1, %xmm0, %xmm2
# CHECK-NEXT:  1      100    -      *                   pcmpestri	$1, (%rax), %xmm2
# CHECK-NEXT:  1      100    -                          pcmpestrm	$1, %xmm0, %xmm2
# CHECK-NEXT:  1      100    -      *                   pcmpestrm	$1, (%rax), %xmm2
# CHECK-NEXT:  1      100    -                          pcmpistri	$1, %xmm0, %xmm2
# CHECK-NEXT:  1      100    -      *                   pcmpistri	$1, (%rax), %xmm2
# CHECK-NEXT:  1      100    -                          pcmpistrm	$1, %xmm0, %xmm2
# CHECK-NEXT:  1      100    -      *                   pcmpistrm	$1, (%rax), %xmm2
# CHECK-NEXT:  1      1     0.50                        pcmpgtq	%xmm0, %xmm2
# CHECK-NEXT:  1      8     0.50    *                   pcmpgtq	(%rax), %xmm2

# CHECK:      Resources:
# CHECK-NEXT: [0]   - ZnAGU0
# CHECK-NEXT: [1]   - ZnAGU1
# CHECK-NEXT: [2]   - ZnALU0
# CHECK-NEXT: [3]   - ZnALU1
# CHECK-NEXT: [4]   - ZnALU2
# CHECK-NEXT: [5]   - ZnALU3
# CHECK-NEXT: [6]   - ZnDivider
# CHECK-NEXT: [7]   - ZnFPU0
# CHECK-NEXT: [8]   - ZnFPU1
# CHECK-NEXT: [9]   - ZnFPU2
# CHECK-NEXT: [10]  - ZnFPU3
# CHECK-NEXT: [11]  - ZnMultiplier

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]
# CHECK-NEXT: 3.00   3.00    -      -      -      -      -     11.00   -      -     1.00    -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   Instructions:
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -      -      -     crc32b	%al, %ecx
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -     1.00    -      -      -      -     crc32b	(%rax), %ecx
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -      -      -     crc32l	%eax, %ecx
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -     1.00    -      -      -      -     crc32l	(%rax), %ecx
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -      -      -     crc32w	%ax, %ecx
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -     1.00    -      -      -      -     crc32w	(%rax), %ecx
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -      -      -     crc32b	%al, %rcx
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -     1.00    -      -      -      -     crc32b	(%rax), %rcx
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -      -      -     crc32q	%rax, %rcx
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -     1.00    -      -      -      -     crc32q	(%rax), %rcx
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -     pcmpestri	$1, %xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -     pcmpestri	$1, (%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -     pcmpestrm	$1, %xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -     pcmpestrm	$1, (%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -     pcmpistri	$1, %xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -     pcmpistri	$1, (%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -     pcmpistrm	$1, %xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -     pcmpistrm	$1, (%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -     0.50    -      -     0.50    -     pcmpgtq	%xmm0, %xmm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -     0.50    -      -     0.50    -     pcmpgtq	(%rax), %xmm2

