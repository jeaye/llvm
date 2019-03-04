# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=btver2 -iterations=1500 -noalias=false -timeline -timeline-max-iterations=1 -bottleneck-analysis < %s | FileCheck %s

vmovaps (%rsi), %xmm0
vmovaps %xmm0, (%rdi)
vmovaps 16(%rsi), %xmm0
vmovaps %xmm0, 16(%rdi)
vmovaps 32(%rsi), %xmm0
vmovaps %xmm0, 32(%rdi)
vmovaps 48(%rsi), %xmm0
vmovaps %xmm0, 48(%rdi)

# CHECK:      Iterations:        1500
# CHECK-NEXT: Instructions:      12000
# CHECK-NEXT: Total Cycles:      36003
# CHECK-NEXT: Total uOps:        12000

# CHECK:      Dispatch Width:    2
# CHECK-NEXT: uOps Per Cycle:    0.33
# CHECK-NEXT: IPC:               0.33
# CHECK-NEXT: Block RThroughput: 4.0

# CHECK:      Cycles with backend pressure increase [ 99.89% ]
# CHECK-NEXT: Throughput Bottlenecks:
# CHECK-NEXT:   Resource Pressure       [ 0.00% ]
# CHECK-NEXT:   Data Dependencies:      [ 99.89% ]
# CHECK-NEXT:   - Register Dependencies [ 0.00% ]
# CHECK-NEXT:   - Memory Dependencies   [ 99.89% ]

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      5     1.00    *                   vmovaps	(%rsi), %xmm0
# CHECK-NEXT:  1      1     1.00           *            vmovaps	%xmm0, (%rdi)
# CHECK-NEXT:  1      5     1.00    *                   vmovaps	16(%rsi), %xmm0
# CHECK-NEXT:  1      1     1.00           *            vmovaps	%xmm0, 16(%rdi)
# CHECK-NEXT:  1      5     1.00    *                   vmovaps	32(%rsi), %xmm0
# CHECK-NEXT:  1      1     1.00           *            vmovaps	%xmm0, 32(%rdi)
# CHECK-NEXT:  1      5     1.00    *                   vmovaps	48(%rsi), %xmm0
# CHECK-NEXT:  1      1     1.00           *            vmovaps	%xmm0, 48(%rdi)

# CHECK:      Resources:
# CHECK-NEXT: [0]   - JALU0
# CHECK-NEXT: [1]   - JALU1
# CHECK-NEXT: [2]   - JDiv
# CHECK-NEXT: [3]   - JFPA
# CHECK-NEXT: [4]   - JFPM
# CHECK-NEXT: [5]   - JFPU0
# CHECK-NEXT: [6]   - JFPU1
# CHECK-NEXT: [7]   - JLAGU
# CHECK-NEXT: [8]   - JMul
# CHECK-NEXT: [9]   - JSAGU
# CHECK-NEXT: [10]  - JSTC
# CHECK-NEXT: [11]  - JVALU0
# CHECK-NEXT: [12]  - JVALU1
# CHECK-NEXT: [13]  - JVIMUL

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12]   [13]
# CHECK-NEXT:  -      -      -     2.00   2.00   4.00   4.00   4.00    -     4.00   4.00    -      -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12]   [13]   Instructions:
# CHECK-NEXT:  -      -      -      -     1.00   1.00    -     1.00    -      -      -      -      -      -     vmovaps	(%rsi), %xmm0
# CHECK-NEXT:  -      -      -      -      -      -     1.00    -      -     1.00   1.00    -      -      -     vmovaps	%xmm0, (%rdi)
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     1.00    -      -      -      -      -      -     vmovaps	16(%rsi), %xmm0
# CHECK-NEXT:  -      -      -      -      -      -     1.00    -      -     1.00   1.00    -      -      -     vmovaps	%xmm0, 16(%rdi)
# CHECK-NEXT:  -      -      -      -     1.00   1.00    -     1.00    -      -      -      -      -      -     vmovaps	32(%rsi), %xmm0
# CHECK-NEXT:  -      -      -      -      -      -     1.00    -      -     1.00   1.00    -      -      -     vmovaps	%xmm0, 32(%rdi)
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     1.00    -      -      -      -      -      -     vmovaps	48(%rsi), %xmm0
# CHECK-NEXT:  -      -      -      -      -      -     1.00    -      -     1.00   1.00    -      -      -     vmovaps	%xmm0, 48(%rdi)

# CHECK:      Timeline view:
# CHECK-NEXT:                     0123456789
# CHECK-NEXT: Index     0123456789          0123456

# CHECK:      [0,0]     DeeeeeER  .    .    .    ..   vmovaps	(%rsi), %xmm0
# CHECK-NEXT: [0,1]     D=====eER .    .    .    ..   vmovaps	%xmm0, (%rdi)
# CHECK-NEXT: [0,2]     .D=====eeeeeER .    .    ..   vmovaps	16(%rsi), %xmm0
# CHECK-NEXT: [0,3]     .D==========eER.    .    ..   vmovaps	%xmm0, 16(%rdi)
# CHECK-NEXT: [0,4]     . D==========eeeeeER.    ..   vmovaps	32(%rsi), %xmm0
# CHECK-NEXT: [0,5]     . D===============eER    ..   vmovaps	%xmm0, 32(%rdi)
# CHECK-NEXT: [0,6]     .  D===============eeeeeER.   vmovaps	48(%rsi), %xmm0
# CHECK-NEXT: [0,7]     .  D====================eER   vmovaps	%xmm0, 48(%rdi)

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     1     1.0    1.0    0.0       vmovaps	(%rsi), %xmm0
# CHECK-NEXT: 1.     1     6.0    0.0    0.0       vmovaps	%xmm0, (%rdi)
# CHECK-NEXT: 2.     1     6.0    0.0    0.0       vmovaps	16(%rsi), %xmm0
# CHECK-NEXT: 3.     1     11.0   0.0    0.0       vmovaps	%xmm0, 16(%rdi)
# CHECK-NEXT: 4.     1     11.0   0.0    0.0       vmovaps	32(%rsi), %xmm0
# CHECK-NEXT: 5.     1     16.0   0.0    0.0       vmovaps	%xmm0, 32(%rdi)
# CHECK-NEXT: 6.     1     16.0   0.0    0.0       vmovaps	48(%rsi), %xmm0
# CHECK-NEXT: 7.     1     21.0   0.0    0.0       vmovaps	%xmm0, 48(%rdi)
