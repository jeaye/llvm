# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=x86-64 -iterations=1500 -timeline -timeline-max-iterations=3 < %s | FileCheck %s

# The ILP is limited by the false dependency on %dx. So, the mov cannot execute
# in parallel with the add.

add %cx, %dx
mov %ax, %dx
xor %bx, %dx

# CHECK:      Iterations:        1500
# CHECK-NEXT: Instructions:      4500
# CHECK-NEXT: Total Cycles:      1504
# CHECK-NEXT: Total uOps:        4500

# CHECK:      Dispatch Width:    4
# CHECK-NEXT: uOps Per Cycle:    2.99
# CHECK-NEXT: IPC:               2.99
# CHECK-NEXT: Block RThroughput: 1.0

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      1     0.33                        addw	%cx, %dx
# CHECK-NEXT:  1      1     0.33                        movw	%ax, %dx
# CHECK-NEXT:  1      1     0.33                        xorw	%bx, %dx

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
# CHECK-NEXT:  -      -     1.00   1.00    -     1.00    -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6.0]  [6.1]  Instructions:
# CHECK-NEXT:  -      -     0.67    -      -     0.33    -      -     addw	%cx, %dx
# CHECK-NEXT:  -      -      -     0.67    -     0.33    -      -     movw	%ax, %dx
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33    -      -     xorw	%bx, %dx

# CHECK:      Timeline view:
# CHECK-NEXT: Index     0123456

# CHECK:      [0,0]     DeER ..   addw	%cx, %dx
# CHECK-NEXT: [0,1]     DeER ..   movw	%ax, %dx
# CHECK-NEXT: [0,2]     D=eER..   xorw	%bx, %dx
# CHECK-NEXT: [1,0]     D==eER.   addw	%cx, %dx
# CHECK-NEXT: [1,1]     .DeE-R.   movw	%ax, %dx
# CHECK-NEXT: [1,2]     .D=eER.   xorw	%bx, %dx
# CHECK-NEXT: [2,0]     .D==eER   addw	%cx, %dx
# CHECK-NEXT: [2,1]     .DeE--R   movw	%ax, %dx
# CHECK-NEXT: [2,2]     . DeE-R   xorw	%bx, %dx

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     3     2.3    0.3    0.0       addw	%cx, %dx
# CHECK-NEXT: 1.     3     1.0    1.0    1.0       movw	%ax, %dx
# CHECK-NEXT: 2.     3     1.7    0.0    0.3       xorw	%bx, %dx
