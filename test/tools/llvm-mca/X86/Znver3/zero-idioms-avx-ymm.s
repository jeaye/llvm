# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=znver3 -timeline -timeline-max-iterations=2 -register-file-stats -iterations=10000 < %s | FileCheck %s

# LLVM-MCA-BEGIN
vxorps %ymm0, %ymm0, %ymm0
vxorps %ymm1, %ymm0, %ymm0
# LLVM-MCA-END

# LLVM-MCA-BEGIN
vxorpd %ymm0, %ymm0, %ymm0
vxorpd %ymm1, %ymm0, %ymm0
# LLVM-MCA-END

# LLVM-MCA-BEGIN
vandnps %ymm0, %ymm0, %ymm0
vandnps %ymm1, %ymm0, %ymm0
# LLVM-MCA-END

# LLVM-MCA-BEGIN
vandnpd %ymm0, %ymm0, %ymm0
vandnpd %ymm1, %ymm0, %ymm0
# LLVM-MCA-END

# LLVM-MCA-BEGIN
vpxor %ymm0, %ymm0, %ymm0
vpxor %ymm1, %ymm0, %ymm0
# LLVM-MCA-END

# CHECK:      [0] Code Region

# CHECK:      Iterations:        10000
# CHECK-NEXT: Instructions:      20000
# CHECK-NEXT: Total Cycles:      3337
# CHECK-NEXT: Total uOps:        20000

# CHECK:      Dispatch Width:    6
# CHECK-NEXT: uOps Per Cycle:    5.99
# CHECK-NEXT: IPC:               5.99
# CHECK-NEXT: Block RThroughput: 0.3

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      0     0.17                        vxorps	%ymm0, %ymm0, %ymm0
# CHECK-NEXT:  1      1     0.25                        vxorps	%ymm1, %ymm0, %ymm0

# CHECK:      Register File statistics:
# CHECK-NEXT: Total number of mappings created:    10000
# CHECK-NEXT: Max number of mappings used:         9

# CHECK:      *  Register File #1 -- Zn3FpPRF:
# CHECK-NEXT:    Number of physical registers:     160
# CHECK-NEXT:    Total number of mappings created: 10000
# CHECK-NEXT:    Max number of mappings used:      9

# CHECK:      *  Register File #2 -- Zn3IntegerPRF:
# CHECK-NEXT:    Number of physical registers:     192
# CHECK-NEXT:    Total number of mappings created: 0
# CHECK-NEXT:    Max number of mappings used:      0

# CHECK:      Resources:
# CHECK-NEXT: [0]   - Zn3AGU0
# CHECK-NEXT: [1]   - Zn3AGU1
# CHECK-NEXT: [2]   - Zn3AGU2
# CHECK-NEXT: [3]   - Zn3ALU0
# CHECK-NEXT: [4]   - Zn3ALU1
# CHECK-NEXT: [5]   - Zn3ALU2
# CHECK-NEXT: [6]   - Zn3ALU3
# CHECK-NEXT: [7]   - Zn3BRU1
# CHECK-NEXT: [8]   - Zn3FPP0
# CHECK-NEXT: [9]   - Zn3FPP1
# CHECK-NEXT: [10]  - Zn3FPP2
# CHECK-NEXT: [11]  - Zn3FPP3
# CHECK-NEXT: [12.0] - Zn3FPP45
# CHECK-NEXT: [12.1] - Zn3FPP45
# CHECK-NEXT: [13]  - Zn3FPSt
# CHECK-NEXT: [14.0] - Zn3LSU
# CHECK-NEXT: [14.1] - Zn3LSU
# CHECK-NEXT: [14.2] - Zn3LSU
# CHECK-NEXT: [15.0] - Zn3Load
# CHECK-NEXT: [15.1] - Zn3Load
# CHECK-NEXT: [15.2] - Zn3Load
# CHECK-NEXT: [16.0] - Zn3Store
# CHECK-NEXT: [16.1] - Zn3Store

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12.0] [12.1] [13]   [14.0] [14.1] [14.2] [15.0] [15.1] [15.2] [16.0] [16.1]
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -      -      -      -      -      -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12.0] [12.1] [13]   [14.0] [14.1] [14.2] [15.0] [15.1] [15.2] [16.0] [16.1] Instructions:
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -     vxorps	%ymm0, %ymm0, %ymm0
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -      -      -      -      -      -      -     vxorps	%ymm1, %ymm0, %ymm0

# CHECK:      Timeline view:
# CHECK-NEXT: Index     0123

# CHECK:      [0,0]     DR .   vxorps	%ymm0, %ymm0, %ymm0
# CHECK-NEXT: [0,1]     DeER   vxorps	%ymm1, %ymm0, %ymm0
# CHECK-NEXT: [1,0]     D--R   vxorps	%ymm0, %ymm0, %ymm0
# CHECK-NEXT: [1,1]     DeER   vxorps	%ymm1, %ymm0, %ymm0

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     2     0.0    0.0    1.0       vxorps	%ymm0, %ymm0, %ymm0
# CHECK-NEXT: 1.     2     1.0    1.0    0.0       vxorps	%ymm1, %ymm0, %ymm0
# CHECK-NEXT:        2     0.5    0.5    0.5       <total>

# CHECK:      [1] Code Region

# CHECK:      Iterations:        10000
# CHECK-NEXT: Instructions:      20000
# CHECK-NEXT: Total Cycles:      3337
# CHECK-NEXT: Total uOps:        20000

# CHECK:      Dispatch Width:    6
# CHECK-NEXT: uOps Per Cycle:    5.99
# CHECK-NEXT: IPC:               5.99
# CHECK-NEXT: Block RThroughput: 0.3

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      0     0.17                        vxorpd	%ymm0, %ymm0, %ymm0
# CHECK-NEXT:  1      1     0.25                        vxorpd	%ymm1, %ymm0, %ymm0

# CHECK:      Register File statistics:
# CHECK-NEXT: Total number of mappings created:    10000
# CHECK-NEXT: Max number of mappings used:         9

# CHECK:      *  Register File #1 -- Zn3FpPRF:
# CHECK-NEXT:    Number of physical registers:     160
# CHECK-NEXT:    Total number of mappings created: 10000
# CHECK-NEXT:    Max number of mappings used:      9

# CHECK:      *  Register File #2 -- Zn3IntegerPRF:
# CHECK-NEXT:    Number of physical registers:     192
# CHECK-NEXT:    Total number of mappings created: 0
# CHECK-NEXT:    Max number of mappings used:      0

# CHECK:      Resources:
# CHECK-NEXT: [0]   - Zn3AGU0
# CHECK-NEXT: [1]   - Zn3AGU1
# CHECK-NEXT: [2]   - Zn3AGU2
# CHECK-NEXT: [3]   - Zn3ALU0
# CHECK-NEXT: [4]   - Zn3ALU1
# CHECK-NEXT: [5]   - Zn3ALU2
# CHECK-NEXT: [6]   - Zn3ALU3
# CHECK-NEXT: [7]   - Zn3BRU1
# CHECK-NEXT: [8]   - Zn3FPP0
# CHECK-NEXT: [9]   - Zn3FPP1
# CHECK-NEXT: [10]  - Zn3FPP2
# CHECK-NEXT: [11]  - Zn3FPP3
# CHECK-NEXT: [12.0] - Zn3FPP45
# CHECK-NEXT: [12.1] - Zn3FPP45
# CHECK-NEXT: [13]  - Zn3FPSt
# CHECK-NEXT: [14.0] - Zn3LSU
# CHECK-NEXT: [14.1] - Zn3LSU
# CHECK-NEXT: [14.2] - Zn3LSU
# CHECK-NEXT: [15.0] - Zn3Load
# CHECK-NEXT: [15.1] - Zn3Load
# CHECK-NEXT: [15.2] - Zn3Load
# CHECK-NEXT: [16.0] - Zn3Store
# CHECK-NEXT: [16.1] - Zn3Store

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12.0] [12.1] [13]   [14.0] [14.1] [14.2] [15.0] [15.1] [15.2] [16.0] [16.1]
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -      -      -      -      -      -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12.0] [12.1] [13]   [14.0] [14.1] [14.2] [15.0] [15.1] [15.2] [16.0] [16.1] Instructions:
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -     vxorpd	%ymm0, %ymm0, %ymm0
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -      -      -      -      -      -      -     vxorpd	%ymm1, %ymm0, %ymm0

# CHECK:      Timeline view:
# CHECK-NEXT: Index     0123

# CHECK:      [0,0]     DR .   vxorpd	%ymm0, %ymm0, %ymm0
# CHECK-NEXT: [0,1]     DeER   vxorpd	%ymm1, %ymm0, %ymm0
# CHECK-NEXT: [1,0]     D--R   vxorpd	%ymm0, %ymm0, %ymm0
# CHECK-NEXT: [1,1]     DeER   vxorpd	%ymm1, %ymm0, %ymm0

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     2     0.0    0.0    1.0       vxorpd	%ymm0, %ymm0, %ymm0
# CHECK-NEXT: 1.     2     1.0    1.0    0.0       vxorpd	%ymm1, %ymm0, %ymm0
# CHECK-NEXT:        2     0.5    0.5    0.5       <total>

# CHECK:      [2] Code Region

# CHECK:      Iterations:        10000
# CHECK-NEXT: Instructions:      20000
# CHECK-NEXT: Total Cycles:      3337
# CHECK-NEXT: Total uOps:        20000

# CHECK:      Dispatch Width:    6
# CHECK-NEXT: uOps Per Cycle:    5.99
# CHECK-NEXT: IPC:               5.99
# CHECK-NEXT: Block RThroughput: 0.3

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      0     0.17                        vandnps	%ymm0, %ymm0, %ymm0
# CHECK-NEXT:  1      1     0.25                        vandnps	%ymm1, %ymm0, %ymm0

# CHECK:      Register File statistics:
# CHECK-NEXT: Total number of mappings created:    10000
# CHECK-NEXT: Max number of mappings used:         9

# CHECK:      *  Register File #1 -- Zn3FpPRF:
# CHECK-NEXT:    Number of physical registers:     160
# CHECK-NEXT:    Total number of mappings created: 10000
# CHECK-NEXT:    Max number of mappings used:      9

# CHECK:      *  Register File #2 -- Zn3IntegerPRF:
# CHECK-NEXT:    Number of physical registers:     192
# CHECK-NEXT:    Total number of mappings created: 0
# CHECK-NEXT:    Max number of mappings used:      0

# CHECK:      Resources:
# CHECK-NEXT: [0]   - Zn3AGU0
# CHECK-NEXT: [1]   - Zn3AGU1
# CHECK-NEXT: [2]   - Zn3AGU2
# CHECK-NEXT: [3]   - Zn3ALU0
# CHECK-NEXT: [4]   - Zn3ALU1
# CHECK-NEXT: [5]   - Zn3ALU2
# CHECK-NEXT: [6]   - Zn3ALU3
# CHECK-NEXT: [7]   - Zn3BRU1
# CHECK-NEXT: [8]   - Zn3FPP0
# CHECK-NEXT: [9]   - Zn3FPP1
# CHECK-NEXT: [10]  - Zn3FPP2
# CHECK-NEXT: [11]  - Zn3FPP3
# CHECK-NEXT: [12.0] - Zn3FPP45
# CHECK-NEXT: [12.1] - Zn3FPP45
# CHECK-NEXT: [13]  - Zn3FPSt
# CHECK-NEXT: [14.0] - Zn3LSU
# CHECK-NEXT: [14.1] - Zn3LSU
# CHECK-NEXT: [14.2] - Zn3LSU
# CHECK-NEXT: [15.0] - Zn3Load
# CHECK-NEXT: [15.1] - Zn3Load
# CHECK-NEXT: [15.2] - Zn3Load
# CHECK-NEXT: [16.0] - Zn3Store
# CHECK-NEXT: [16.1] - Zn3Store

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12.0] [12.1] [13]   [14.0] [14.1] [14.2] [15.0] [15.1] [15.2] [16.0] [16.1]
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -      -      -      -      -      -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12.0] [12.1] [13]   [14.0] [14.1] [14.2] [15.0] [15.1] [15.2] [16.0] [16.1] Instructions:
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -     vandnps	%ymm0, %ymm0, %ymm0
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -      -      -      -      -      -      -     vandnps	%ymm1, %ymm0, %ymm0

# CHECK:      Timeline view:
# CHECK-NEXT: Index     0123

# CHECK:      [0,0]     DR .   vandnps	%ymm0, %ymm0, %ymm0
# CHECK-NEXT: [0,1]     DeER   vandnps	%ymm1, %ymm0, %ymm0
# CHECK-NEXT: [1,0]     D--R   vandnps	%ymm0, %ymm0, %ymm0
# CHECK-NEXT: [1,1]     DeER   vandnps	%ymm1, %ymm0, %ymm0

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     2     0.0    0.0    1.0       vandnps	%ymm0, %ymm0, %ymm0
# CHECK-NEXT: 1.     2     1.0    1.0    0.0       vandnps	%ymm1, %ymm0, %ymm0
# CHECK-NEXT:        2     0.5    0.5    0.5       <total>

# CHECK:      [3] Code Region

# CHECK:      Iterations:        10000
# CHECK-NEXT: Instructions:      20000
# CHECK-NEXT: Total Cycles:      3337
# CHECK-NEXT: Total uOps:        20000

# CHECK:      Dispatch Width:    6
# CHECK-NEXT: uOps Per Cycle:    5.99
# CHECK-NEXT: IPC:               5.99
# CHECK-NEXT: Block RThroughput: 0.3

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      0     0.17                        vandnpd	%ymm0, %ymm0, %ymm0
# CHECK-NEXT:  1      1     0.25                        vandnpd	%ymm1, %ymm0, %ymm0

# CHECK:      Register File statistics:
# CHECK-NEXT: Total number of mappings created:    10000
# CHECK-NEXT: Max number of mappings used:         9

# CHECK:      *  Register File #1 -- Zn3FpPRF:
# CHECK-NEXT:    Number of physical registers:     160
# CHECK-NEXT:    Total number of mappings created: 10000
# CHECK-NEXT:    Max number of mappings used:      9

# CHECK:      *  Register File #2 -- Zn3IntegerPRF:
# CHECK-NEXT:    Number of physical registers:     192
# CHECK-NEXT:    Total number of mappings created: 0
# CHECK-NEXT:    Max number of mappings used:      0

# CHECK:      Resources:
# CHECK-NEXT: [0]   - Zn3AGU0
# CHECK-NEXT: [1]   - Zn3AGU1
# CHECK-NEXT: [2]   - Zn3AGU2
# CHECK-NEXT: [3]   - Zn3ALU0
# CHECK-NEXT: [4]   - Zn3ALU1
# CHECK-NEXT: [5]   - Zn3ALU2
# CHECK-NEXT: [6]   - Zn3ALU3
# CHECK-NEXT: [7]   - Zn3BRU1
# CHECK-NEXT: [8]   - Zn3FPP0
# CHECK-NEXT: [9]   - Zn3FPP1
# CHECK-NEXT: [10]  - Zn3FPP2
# CHECK-NEXT: [11]  - Zn3FPP3
# CHECK-NEXT: [12.0] - Zn3FPP45
# CHECK-NEXT: [12.1] - Zn3FPP45
# CHECK-NEXT: [13]  - Zn3FPSt
# CHECK-NEXT: [14.0] - Zn3LSU
# CHECK-NEXT: [14.1] - Zn3LSU
# CHECK-NEXT: [14.2] - Zn3LSU
# CHECK-NEXT: [15.0] - Zn3Load
# CHECK-NEXT: [15.1] - Zn3Load
# CHECK-NEXT: [15.2] - Zn3Load
# CHECK-NEXT: [16.0] - Zn3Store
# CHECK-NEXT: [16.1] - Zn3Store

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12.0] [12.1] [13]   [14.0] [14.1] [14.2] [15.0] [15.1] [15.2] [16.0] [16.1]
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -      -      -      -      -      -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12.0] [12.1] [13]   [14.0] [14.1] [14.2] [15.0] [15.1] [15.2] [16.0] [16.1] Instructions:
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -     vandnpd	%ymm0, %ymm0, %ymm0
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -      -      -      -      -      -      -     vandnpd	%ymm1, %ymm0, %ymm0

# CHECK:      Timeline view:
# CHECK-NEXT: Index     0123

# CHECK:      [0,0]     DR .   vandnpd	%ymm0, %ymm0, %ymm0
# CHECK-NEXT: [0,1]     DeER   vandnpd	%ymm1, %ymm0, %ymm0
# CHECK-NEXT: [1,0]     D--R   vandnpd	%ymm0, %ymm0, %ymm0
# CHECK-NEXT: [1,1]     DeER   vandnpd	%ymm1, %ymm0, %ymm0

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     2     0.0    0.0    1.0       vandnpd	%ymm0, %ymm0, %ymm0
# CHECK-NEXT: 1.     2     1.0    1.0    0.0       vandnpd	%ymm1, %ymm0, %ymm0
# CHECK-NEXT:        2     0.5    0.5    0.5       <total>

# CHECK:      [4] Code Region

# CHECK:      Iterations:        10000
# CHECK-NEXT: Instructions:      20000
# CHECK-NEXT: Total Cycles:      3337
# CHECK-NEXT: Total uOps:        20000

# CHECK:      Dispatch Width:    6
# CHECK-NEXT: uOps Per Cycle:    5.99
# CHECK-NEXT: IPC:               5.99
# CHECK-NEXT: Block RThroughput: 0.3

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      0     0.17                        vpxor	%ymm0, %ymm0, %ymm0
# CHECK-NEXT:  1      1     0.25                        vpxor	%ymm1, %ymm0, %ymm0

# CHECK:      Register File statistics:
# CHECK-NEXT: Total number of mappings created:    10000
# CHECK-NEXT: Max number of mappings used:         9

# CHECK:      *  Register File #1 -- Zn3FpPRF:
# CHECK-NEXT:    Number of physical registers:     160
# CHECK-NEXT:    Total number of mappings created: 10000
# CHECK-NEXT:    Max number of mappings used:      9

# CHECK:      *  Register File #2 -- Zn3IntegerPRF:
# CHECK-NEXT:    Number of physical registers:     192
# CHECK-NEXT:    Total number of mappings created: 0
# CHECK-NEXT:    Max number of mappings used:      0

# CHECK:      Resources:
# CHECK-NEXT: [0]   - Zn3AGU0
# CHECK-NEXT: [1]   - Zn3AGU1
# CHECK-NEXT: [2]   - Zn3AGU2
# CHECK-NEXT: [3]   - Zn3ALU0
# CHECK-NEXT: [4]   - Zn3ALU1
# CHECK-NEXT: [5]   - Zn3ALU2
# CHECK-NEXT: [6]   - Zn3ALU3
# CHECK-NEXT: [7]   - Zn3BRU1
# CHECK-NEXT: [8]   - Zn3FPP0
# CHECK-NEXT: [9]   - Zn3FPP1
# CHECK-NEXT: [10]  - Zn3FPP2
# CHECK-NEXT: [11]  - Zn3FPP3
# CHECK-NEXT: [12.0] - Zn3FPP45
# CHECK-NEXT: [12.1] - Zn3FPP45
# CHECK-NEXT: [13]  - Zn3FPSt
# CHECK-NEXT: [14.0] - Zn3LSU
# CHECK-NEXT: [14.1] - Zn3LSU
# CHECK-NEXT: [14.2] - Zn3LSU
# CHECK-NEXT: [15.0] - Zn3Load
# CHECK-NEXT: [15.1] - Zn3Load
# CHECK-NEXT: [15.2] - Zn3Load
# CHECK-NEXT: [16.0] - Zn3Store
# CHECK-NEXT: [16.1] - Zn3Store

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12.0] [12.1] [13]   [14.0] [14.1] [14.2] [15.0] [15.1] [15.2] [16.0] [16.1]
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -      -      -      -      -      -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12.0] [12.1] [13]   [14.0] [14.1] [14.2] [15.0] [15.1] [15.2] [16.0] [16.1] Instructions:
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -     vpxor	%ymm0, %ymm0, %ymm0
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -      -      -      -      -      -      -     vpxor	%ymm1, %ymm0, %ymm0

# CHECK:      Timeline view:
# CHECK-NEXT: Index     0123

# CHECK:      [0,0]     DR .   vpxor	%ymm0, %ymm0, %ymm0
# CHECK-NEXT: [0,1]     DeER   vpxor	%ymm1, %ymm0, %ymm0
# CHECK-NEXT: [1,0]     D--R   vpxor	%ymm0, %ymm0, %ymm0
# CHECK-NEXT: [1,1]     DeER   vpxor	%ymm1, %ymm0, %ymm0

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     2     0.0    0.0    1.0       vpxor	%ymm0, %ymm0, %ymm0
# CHECK-NEXT: 1.     2     1.0    1.0    0.0       vpxor	%ymm1, %ymm0, %ymm0
# CHECK-NEXT:        2     0.5    0.5    0.5       <total>
