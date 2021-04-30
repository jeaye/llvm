# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=thumbv7-gnueabihf-linux -mcpu=cortex-a57 -timeline -iterations=10 < %s | FileCheck %s

# Test case from PR50174.
# NOP consumes zero resources, and it is 0 uOPs.

  pop     {r3, r4, r5, r6, r7, pc}
  nop

# CHECK:      Iterations:        10
# CHECK-NEXT: Instructions:      20
# CHECK-NEXT: Total Cycles:      43
# CHECK-NEXT: Total uOps:        80

# CHECK:      Dispatch Width:    3
# CHECK-NEXT: uOps Per Cycle:    1.86
# CHECK-NEXT: IPC:               0.47
# CHECK-NEXT: Block RThroughput: 4.0

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  8      4     4.00    *             U     pop	{r3, r4, r5, r6, r7, pc}
# CHECK-NEXT:  0      0     0.00    *      *      U     nop

# CHECK:      Resources:
# CHECK-NEXT: [0]   - A57UnitB
# CHECK-NEXT: [1.0] - A57UnitI
# CHECK-NEXT: [1.1] - A57UnitI
# CHECK-NEXT: [2]   - A57UnitL
# CHECK-NEXT: [3]   - A57UnitM
# CHECK-NEXT: [4]   - A57UnitS
# CHECK-NEXT: [5]   - A57UnitW
# CHECK-NEXT: [6]   - A57UnitX

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1.0]  [1.1]  [2]    [3]    [4]    [5]    [6]
# CHECK-NEXT:  -     2.00   2.00   4.00    -      -      -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1.0]  [1.1]  [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  -     2.00   2.00   4.00    -      -      -      -     pop	{r3, r4, r5, r6, r7, pc}
# CHECK-NEXT:  -      -      -      -      -      -      -      -     nop

# CHECK:      Timeline view:
# CHECK-NEXT:                     0123456789          0123456789
# CHECK-NEXT: Index     0123456789          0123456789          012

# CHECK:      [0,0]     DeeeeER   .    .    .    .    .    .    . .   pop	{r3, r4, r5, r6, r7, pc}
# CHECK-NEXT: [0,1]     . D---R   .    .    .    .    .    .    . .   nop
# CHECK-NEXT: [1,0]     .  D=eeeeER    .    .    .    .    .    . .   pop	{r3, r4, r5, r6, r7, pc}
# CHECK-NEXT: [1,1]     .    D----R    .    .    .    .    .    . .   nop
# CHECK-NEXT: [2,0]     .    .D==eeeeER.    .    .    .    .    . .   pop	{r3, r4, r5, r6, r7, pc}
# CHECK-NEXT: [2,1]     .    .  DE----R.    .    .    .    .    . .   nop
# CHECK-NEXT: [3,0]     .    .   D===eeeeER .    .    .    .    . .   pop	{r3, r4, r5, r6, r7, pc}
# CHECK-NEXT: [3,1]     .    .    .D=E----R .    .    .    .    . .   nop
# CHECK-NEXT: [4,0]     .    .    . D====eeeeER  .    .    .    . .   pop	{r3, r4, r5, r6, r7, pc}
# CHECK-NEXT: [4,1]     .    .    .   D==E----R  .    .    .    . .   nop
# CHECK-NEXT: [5,0]     .    .    .    D=====eeeeER   .    .    . .   pop	{r3, r4, r5, r6, r7, pc}
# CHECK-NEXT: [5,1]     .    .    .    . D===E----R   .    .    . .   nop
# CHECK-NEXT: [6,0]     .    .    .    .  D======eeeeER    .    . .   pop	{r3, r4, r5, r6, r7, pc}
# CHECK-NEXT: [6,1]     .    .    .    .    D====E----R    .    . .   nop
# CHECK-NEXT: [7,0]     .    .    .    .    .D=======eeeeER.    . .   pop	{r3, r4, r5, r6, r7, pc}
# CHECK-NEXT: [7,1]     .    .    .    .    .  D=====E----R.    . .   nop
# CHECK-NEXT: [8,0]     .    .    .    .    .   D========eeeeER . .   pop	{r3, r4, r5, r6, r7, pc}
# CHECK-NEXT: [8,1]     .    .    .    .    .    .D======E----R . .   nop
# CHECK-NEXT: [9,0]     .    .    .    .    .    . D=========eeeeER   pop	{r3, r4, r5, r6, r7, pc}
# CHECK-NEXT: [9,1]     .    .    .    .    .    .   D=======E----R   nop

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     10    5.5    0.1    0.0       pop	{r3, r4, r5, r6, r7, pc}
# CHECK-NEXT: 1.     10    3.6    0.0    3.9       nop
# CHECK-NEXT:        10    4.6    0.1    2.0       <total>
