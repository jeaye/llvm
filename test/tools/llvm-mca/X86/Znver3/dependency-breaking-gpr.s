# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=znver3 -timeline -timeline-max-iterations=2 -iterations=1000 < %s | FileCheck %s

# LLVM-MCA-BEGIN
sbbl %eax, %eax
mulxl %eax, %eax, %eax
# LLVM-MCA-END

# LLVM-MCA-BEGIN
sbbq %rax, %rax
mulxq %rax, %rax, %rax
# LLVM-MCA-END

# LLVM-MCA-BEGIN
mulxl %eax, %eax, %eax
cmpl %eax, %eax
cmovael %eax, %ecx
# LLVM-MCA-END

# LLVM-MCA-BEGIN
mulxq %rax, %rax, %rax
cmpq %rax, %rax
cmovaeq %rax, %rcx
# LLVM-MCA-END

# CHECK:      [0] Code Region

# CHECK:      Iterations:        1000
# CHECK-NEXT: Instructions:      2000
# CHECK-NEXT: Total Cycles:      1259
# CHECK-NEXT: Total uOps:        3000

# CHECK:      Dispatch Width:    6
# CHECK-NEXT: uOps Per Cycle:    2.38
# CHECK-NEXT: IPC:               1.59
# CHECK-NEXT: Block RThroughput: 1.0

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      1     1.00                        sbbl	%eax, %eax
# CHECK-NEXT:  2      4     1.00                        mulxl	%eax, %eax, %eax

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
# CHECK-NEXT:  -      -      -     1.25   1.25   1.25   1.25    -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12.0] [12.1] [13]   [14.0] [14.1] [14.2] [15.0] [15.1] [15.2] [16.0] [16.1] Instructions:
# CHECK-NEXT:  -      -      -     1.25   0.25   1.25   1.25    -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -     sbbl	%eax, %eax
# CHECK-NEXT:  -      -      -      -     1.00    -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -     mulxl	%eax, %eax, %eax

# CHECK:      Timeline view:
# CHECK-NEXT: Index     012345678

# CHECK:      [0,0]     DeER .  .   sbbl	%eax, %eax
# CHECK-NEXT: [0,1]     D=eeeeER.   mulxl	%eax, %eax, %eax
# CHECK-NEXT: [1,0]     D=eE---R.   sbbl	%eax, %eax
# CHECK-NEXT: [1,1]     D==eeeeER   mulxl	%eax, %eax, %eax

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     2     1.5    0.5    1.5       sbbl	%eax, %eax
# CHECK-NEXT: 1.     2     2.5    0.0    0.0       mulxl	%eax, %eax, %eax
# CHECK-NEXT:        2     2.0    0.3    0.8       <total>

# CHECK:      [1] Code Region

# CHECK:      Iterations:        1000
# CHECK-NEXT: Instructions:      2000
# CHECK-NEXT: Total Cycles:      1259
# CHECK-NEXT: Total uOps:        3000

# CHECK:      Dispatch Width:    6
# CHECK-NEXT: uOps Per Cycle:    2.38
# CHECK-NEXT: IPC:               1.59
# CHECK-NEXT: Block RThroughput: 1.0

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      1     1.00                        sbbq	%rax, %rax
# CHECK-NEXT:  2      4     1.00                        mulxq	%rax, %rax, %rax

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
# CHECK-NEXT:  -      -      -     1.25   1.25   1.25   1.25    -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12.0] [12.1] [13]   [14.0] [14.1] [14.2] [15.0] [15.1] [15.2] [16.0] [16.1] Instructions:
# CHECK-NEXT:  -      -      -     1.25   0.25   1.25   1.25    -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -     sbbq	%rax, %rax
# CHECK-NEXT:  -      -      -      -     1.00    -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -     mulxq	%rax, %rax, %rax

# CHECK:      Timeline view:
# CHECK-NEXT: Index     012345678

# CHECK:      [0,0]     DeER .  .   sbbq	%rax, %rax
# CHECK-NEXT: [0,1]     D=eeeeER.   mulxq	%rax, %rax, %rax
# CHECK-NEXT: [1,0]     D=eE---R.   sbbq	%rax, %rax
# CHECK-NEXT: [1,1]     D==eeeeER   mulxq	%rax, %rax, %rax

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     2     1.5    0.5    1.5       sbbq	%rax, %rax
# CHECK-NEXT: 1.     2     2.5    0.0    0.0       mulxq	%rax, %rax, %rax
# CHECK-NEXT:        2     2.0    0.3    0.8       <total>

# CHECK:      [2] Code Region

# CHECK:      Iterations:        1000
# CHECK-NEXT: Instructions:      3000
# CHECK-NEXT: Total Cycles:      4005
# CHECK-NEXT: Total uOps:        4000

# CHECK:      Dispatch Width:    6
# CHECK-NEXT: uOps Per Cycle:    1.00
# CHECK-NEXT: IPC:               0.75
# CHECK-NEXT: Block RThroughput: 1.0

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  2      4     1.00                        mulxl	%eax, %eax, %eax
# CHECK-NEXT:  1      1     0.25                        cmpl	%eax, %eax
# CHECK-NEXT:  1      1     0.50                        cmovael	%eax, %ecx

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
# CHECK-NEXT:  -      -      -     0.67   1.00   0.67   0.67    -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12.0] [12.1] [13]   [14.0] [14.1] [14.2] [15.0] [15.1] [15.2] [16.0] [16.1] Instructions:
# CHECK-NEXT:  -      -      -      -     1.00    -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -     mulxl	%eax, %eax, %eax
# CHECK-NEXT:  -      -      -      -      -     0.67   0.33    -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -     cmpl	%eax, %eax
# CHECK-NEXT:  -      -      -     0.67    -      -     0.33    -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -     cmovael	%eax, %ecx

# CHECK:      Timeline view:
# CHECK-NEXT:                     012
# CHECK-NEXT: Index     0123456789

# CHECK:      [0,0]     DeeeeER   . .   mulxl	%eax, %eax, %eax
# CHECK-NEXT: [0,1]     D====eER  . .   cmpl	%eax, %eax
# CHECK-NEXT: [0,2]     D=====eER . .   cmovael	%eax, %ecx
# CHECK-NEXT: [1,0]     D====eeeeER .   mulxl	%eax, %eax, %eax
# CHECK-NEXT: [1,1]     .D=======eER.   cmpl	%eax, %eax
# CHECK-NEXT: [1,2]     .D========eER   cmovael	%eax, %ecx

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     2     3.0    0.5    0.0       mulxl	%eax, %eax, %eax
# CHECK-NEXT: 1.     2     6.5    0.0    0.0       cmpl	%eax, %eax
# CHECK-NEXT: 2.     2     7.5    0.0    0.0       cmovael	%eax, %ecx
# CHECK-NEXT:        2     5.7    0.2    0.0       <total>

# CHECK:      [3] Code Region

# CHECK:      Iterations:        1000
# CHECK-NEXT: Instructions:      3000
# CHECK-NEXT: Total Cycles:      4005
# CHECK-NEXT: Total uOps:        4000

# CHECK:      Dispatch Width:    6
# CHECK-NEXT: uOps Per Cycle:    1.00
# CHECK-NEXT: IPC:               0.75
# CHECK-NEXT: Block RThroughput: 1.0

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  2      4     1.00                        mulxq	%rax, %rax, %rax
# CHECK-NEXT:  1      1     0.25                        cmpq	%rax, %rax
# CHECK-NEXT:  1      1     0.50                        cmovaeq	%rax, %rcx

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
# CHECK-NEXT:  -      -      -     0.67   1.00   0.67   0.67    -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12.0] [12.1] [13]   [14.0] [14.1] [14.2] [15.0] [15.1] [15.2] [16.0] [16.1] Instructions:
# CHECK-NEXT:  -      -      -      -     1.00    -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -     mulxq	%rax, %rax, %rax
# CHECK-NEXT:  -      -      -      -      -     0.67   0.33    -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -     cmpq	%rax, %rax
# CHECK-NEXT:  -      -      -     0.67    -      -     0.33    -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -     cmovaeq	%rax, %rcx

# CHECK:      Timeline view:
# CHECK-NEXT:                     012
# CHECK-NEXT: Index     0123456789

# CHECK:      [0,0]     DeeeeER   . .   mulxq	%rax, %rax, %rax
# CHECK-NEXT: [0,1]     D====eER  . .   cmpq	%rax, %rax
# CHECK-NEXT: [0,2]     D=====eER . .   cmovaeq	%rax, %rcx
# CHECK-NEXT: [1,0]     D====eeeeER .   mulxq	%rax, %rax, %rax
# CHECK-NEXT: [1,1]     .D=======eER.   cmpq	%rax, %rax
# CHECK-NEXT: [1,2]     .D========eER   cmovaeq	%rax, %rcx

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     2     3.0    0.5    0.0       mulxq	%rax, %rax, %rax
# CHECK-NEXT: 1.     2     6.5    0.0    0.0       cmpq	%rax, %rax
# CHECK-NEXT: 2.     2     7.5    0.0    0.0       cmovaeq	%rax, %rcx
# CHECK-NEXT:        2     5.7    0.2    0.0       <total>
