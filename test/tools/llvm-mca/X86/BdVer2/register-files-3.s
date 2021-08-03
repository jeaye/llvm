# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=bdver2 -register-file-size=5 -iterations=2 -dispatch-stats -register-file-stats -timeline < %s | FileCheck %s

idiv %eax

# CHECK:      Iterations:        2
# CHECK-NEXT: Instructions:      2
# CHECK-NEXT: Total Cycles:      42
# CHECK-NEXT: Total uOps:        4

# CHECK:      Dispatch Width:    4
# CHECK-NEXT: uOps Per Cycle:    0.10
# CHECK-NEXT: IPC:               0.05
# CHECK-NEXT: Block RThroughput: 25.0

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  2      14    25.00                 U     idivl	%eax

# CHECK:      Dynamic Dispatch Stall Cycles:
# CHECK-NEXT: RAT     - Register unavailable:                      16  (38.1%)
# CHECK-NEXT: RCU     - Retire tokens unavailable:                 0
# CHECK-NEXT: SCHEDQ  - Scheduler full:                            0
# CHECK-NEXT: LQ      - Load queue full:                           0
# CHECK-NEXT: SQ      - Store queue full:                          0
# CHECK-NEXT: GROUP   - Static restrictions on the dispatch group: 0
# CHECK-NEXT: USH     - Uncategorised Structural Hazard:           0

# CHECK:      Dispatch Logic - number of cycles where we saw N micro opcodes dispatched:
# CHECK-NEXT: [# dispatched], [# cycles]
# CHECK-NEXT:  0,              40  (95.2%)
# CHECK-NEXT:  2,              2  (4.8%)

# CHECK:      Register File statistics:
# CHECK-NEXT: Total number of mappings created:    6
# CHECK-NEXT: Max number of mappings used:         3

# CHECK:      *  Register File #1 -- PdFpuPRF:
# CHECK-NEXT:    Number of physical registers:     160
# CHECK-NEXT:    Total number of mappings created: 0
# CHECK-NEXT:    Max number of mappings used:      0

# CHECK:      *  Register File #2 -- PdIntegerPRF:
# CHECK-NEXT:    Number of physical registers:     96
# CHECK-NEXT:    Total number of mappings created: 6
# CHECK-NEXT:    Max number of mappings used:      3

# CHECK:      Resources:
# CHECK-NEXT: [0.0] - PdAGLU01
# CHECK-NEXT: [0.1] - PdAGLU01
# CHECK-NEXT: [1]   - PdBranch
# CHECK-NEXT: [2]   - PdCount
# CHECK-NEXT: [3]   - PdDiv
# CHECK-NEXT: [4]   - PdEX0
# CHECK-NEXT: [5]   - PdEX1
# CHECK-NEXT: [6]   - PdFPCVT
# CHECK-NEXT: [7.0] - PdFPFMA
# CHECK-NEXT: [7.1] - PdFPFMA
# CHECK-NEXT: [8.0] - PdFPMAL
# CHECK-NEXT: [8.1] - PdFPMAL
# CHECK-NEXT: [9]   - PdFPMMA
# CHECK-NEXT: [10]  - PdFPSTO
# CHECK-NEXT: [11]  - PdFPU0
# CHECK-NEXT: [12]  - PdFPU1
# CHECK-NEXT: [13]  - PdFPU2
# CHECK-NEXT: [14]  - PdFPU3
# CHECK-NEXT: [15]  - PdFPXBR
# CHECK-NEXT: [16.0] - PdLoad
# CHECK-NEXT: [16.1] - PdLoad
# CHECK-NEXT: [17]  - PdMul
# CHECK-NEXT: [18]  - PdStore

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0.0]  [0.1]  [1]    [2]    [3]    [4]    [5]    [6]    [7.0]  [7.1]  [8.0]  [8.1]  [9]    [10]   [11]   [12]   [13]   [14]   [15]   [16.0] [16.1] [17]   [18]
# CHECK-NEXT:  -      -      -      -     25.00   -     1.00    -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0.0]  [0.1]  [1]    [2]    [3]    [4]    [5]    [6]    [7.0]  [7.1]  [8.0]  [8.1]  [9]    [10]   [11]   [12]   [13]   [14]   [15]   [16.0] [16.1] [17]   [18]   Instructions:
# CHECK-NEXT:  -      -      -      -     25.00   -     1.00    -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -     idivl	%eax

# CHECK:      Timeline view:
# CHECK-NEXT:                     0123456789          0123456789
# CHECK-NEXT: Index     0123456789          0123456789          01

# CHECK:      [0,0]     DeeeeeeeeeeeeeeER   .    .    .    .    ..   idivl	%eax
# CHECK-NEXT: [1,0]     .    .    .    .D=========eeeeeeeeeeeeeeER   idivl	%eax

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     2     5.5    5.5    0.0       idivl	%eax
