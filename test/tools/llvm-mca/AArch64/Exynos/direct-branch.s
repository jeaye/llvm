# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=aarch64-linux-gnu -mcpu=exynos-m3 -resource-pressure=false < %s | FileCheck %s -check-prefixes=ALL,M3
# RUN: llvm-mca -mtriple=aarch64-linux-gnu -mcpu=exynos-m4 -resource-pressure=false < %s | FileCheck %s -check-prefixes=ALL,M4
# RUN: llvm-mca -mtriple=aarch64-linux-gnu -mcpu=exynos-m5 -resource-pressure=false < %s | FileCheck %s -check-prefixes=ALL,M5

  b	main

# ALL:      Iterations:        100
# ALL-NEXT: Instructions:      100

# M3-NEXT:  Total Cycles:      18
# M4-NEXT:  Total Cycles:      18
# M5-NEXT:  Total Cycles:      18

# ALL-NEXT: Total uOps:        100

# M3:       Dispatch Width:    6
# M3-NEXT:  uOps Per Cycle:    5.56
# M3-NEXT:  IPC:               5.56
# M3-NEXT:  Block RThroughput: 0.2

# M4:       Dispatch Width:    6
# M4-NEXT:  uOps Per Cycle:    5.56
# M4-NEXT:  IPC:               5.56
# M4-NEXT:  Block RThroughput: 0.2

# M5:       Dispatch Width:    6
# M5-NEXT:  uOps Per Cycle:    5.56
# M5-NEXT:  IPC:               5.56
# M5-NEXT:  Block RThroughput: 0.2

# ALL:      Instruction Info:
# ALL-NEXT: [1]: #uOps
# ALL-NEXT: [2]: Latency
# ALL-NEXT: [3]: RThroughput
# ALL-NEXT: [4]: MayLoad
# ALL-NEXT: [5]: MayStore
# ALL-NEXT: [6]: HasSideEffects (U)

# ALL:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:

# M3-NEXT:   1      0     0.17                        b	main
# M4-NEXT:   1      0     0.17                        b	main
# M5-NEXT:   1      0     0.17                        b	main
