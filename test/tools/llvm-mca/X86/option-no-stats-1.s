# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=btver2 -all-views -all-stats=false < %s | FileCheck %s

# We don't want to disable the SummaryView if flag -all-stats is set to false.

add %edi, %eax

# CHECK:      Iterations:        100
# CHECK-NEXT: Instructions:      100
# CHECK-NEXT: Total Cycles:      103
# CHECK-NEXT: Total uOps:        100

# CHECK:      Dispatch Width:    2
# CHECK-NEXT: uOps Per Cycle:    0.97
# CHECK-NEXT: IPC:               0.97
# CHECK-NEXT: Block RThroughput: 0.5

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      1     0.50                        addl	%edi, %eax

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
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12]   [13]   Instructions:
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -     addl	%edi, %eax

# CHECK:      Timeline view:
# CHECK-NEXT:                     012
# CHECK-NEXT: Index     0123456789

# CHECK:      [0,0]     DeER .    . .   addl	%edi, %eax
# CHECK-NEXT: [1,0]     D=eER.    . .   addl	%edi, %eax
# CHECK-NEXT: [2,0]     .D=eER    . .   addl	%edi, %eax
# CHECK-NEXT: [3,0]     .D==eER   . .   addl	%edi, %eax
# CHECK-NEXT: [4,0]     . D==eER  . .   addl	%edi, %eax
# CHECK-NEXT: [5,0]     . D===eER . .   addl	%edi, %eax
# CHECK-NEXT: [6,0]     .  D===eER. .   addl	%edi, %eax
# CHECK-NEXT: [7,0]     .  D====eER .   addl	%edi, %eax
# CHECK-NEXT: [8,0]     .   D====eER.   addl	%edi, %eax
# CHECK-NEXT: [9,0]     .   D=====eER   addl	%edi, %eax

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     10    3.5    0.1    0.0       addl	%edi, %eax
