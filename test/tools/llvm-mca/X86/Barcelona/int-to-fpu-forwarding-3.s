# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=x86-64 -iterations=500 -timeline -timeline-max-iterations=3 < %s | FileCheck %s

add %eax, %eax
pinsrw $0, %eax, %xmm0
pinsrw $1, %eax, %xmm0

# CHECK:      Iterations:        500
# CHECK-NEXT: Instructions:      1500
# CHECK-NEXT: Total Cycles:      2004
# CHECK-NEXT: Total uOps:        2500

# CHECK:      Dispatch Width:    4
# CHECK-NEXT: uOps Per Cycle:    1.25
# CHECK-NEXT: IPC:               0.75
# CHECK-NEXT: Block RThroughput: 2.0

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      1     0.33                        addl	%eax, %eax
# CHECK-NEXT:  2      2     1.00                        pinsrw	$0, %eax, %xmm0
# CHECK-NEXT:  2      2     1.00                        pinsrw	$1, %eax, %xmm0

# CHECK:      Resources:
# CHECK-NEXT: [0]   - SBDivider
# CHECK-NEXT: [1]   - SBFPDivider
# CHECK-NEXT: [2]   - SBPort0
# CHECK-NEXT: [3]   - SBPort1
# CHECK-NEXT: [4]   - SBPort4
# CHECK-NEXT: [5]   - SBPort5
# CHECK-NEXT: [6.0] - SBPort23
# CHECK-NEXT: [6.1] - SBPort23

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6.0]  [6.1]
# CHECK-NEXT:  -      -     0.98   2.01    -     2.01    -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6.0]  [6.1]  Instructions:
# CHECK-NEXT:  -      -     0.98   0.01    -     0.01    -      -     addl	%eax, %eax
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -      -     pinsrw	$0, %eax, %xmm0
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -      -     pinsrw	$1, %eax, %xmm0

# CHECK:      Timeline view:
# CHECK-NEXT:                     012345
# CHECK-NEXT: Index     0123456789

# CHECK:      [0,0]     DeER .    .    .   addl	%eax, %eax
# CHECK-NEXT: [0,1]     D=eeER    .    .   pinsrw	$0, %eax, %xmm0
# CHECK-NEXT: [0,2]     .D==eeER  .    .   pinsrw	$1, %eax, %xmm0
# CHECK-NEXT: [1,0]     .DeE---R  .    .   addl	%eax, %eax
# CHECK-NEXT: [1,1]     . D===eeER.    .   pinsrw	$0, %eax, %xmm0
# CHECK-NEXT: [1,2]     . D=====eeER   .   pinsrw	$1, %eax, %xmm0
# CHECK-NEXT: [2,0]     .  DeE-----R   .   addl	%eax, %eax
# CHECK-NEXT: [2,1]     .  D======eeER .   pinsrw	$0, %eax, %xmm0
# CHECK-NEXT: [2,2]     .   D=======eeER   pinsrw	$1, %eax, %xmm0

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     3     1.0    0.7    2.7       addl	%eax, %eax
# CHECK-NEXT: 1.     3     4.3    0.0    0.0       pinsrw	$0, %eax, %xmm0
# CHECK-NEXT: 2.     3     5.7    0.0    0.0       pinsrw	$1, %eax, %xmm0
