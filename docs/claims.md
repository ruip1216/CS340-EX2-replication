# Proposed Research Claims

This document separates claims explicitly supported by the paper from questions the group will test in its modified reproduction.

## Claim 1 — Detection coverage

**Paper-supported claim:** AddressSanitizer is designed to detect out-of-bounds accesses to heap, stack, and global objects, as well as use-after-free bugs.

**Group verification question:** Can our ASan build detect representative examples of these four error classes in small C test programs?

**Evidence required from our project:**
- Source code for each test case.
- Exact compiler command.
- Program exit status.
- Standard error/output containing the ASan diagnostic, if detected.
- A result table recording detected / not detected / inconclusive.

**Important qualification:** The group tests are representative functional checks. They do not establish universal detection of every possible memory error.

## Claim 2 — Runtime performance overhead

**Paper-supported claim:** ASan introduces runtime overhead. In the paper's SPEC CPU2006 evaluation, the reported average slowdown was 73%.

**Group verification question:** What runtime overhead does ASan introduce for each selected PolyBench/C workload under our controlled environment?

**Evidence required from our project:**
- Same source workload and input size for normal and ASan builds.
- Compiler and optimization flags.
- At least three independent runs per condition.
- Raw timing results and summary statistics.
- Per-workload overhead calculation.

**Important qualification:** PolyBench/C results must not be presented as a direct reproduction of the paper's SPEC CPU2006 average.

## Claim 3 — Memory/resource overhead

**Paper-supported claim:** ASan increases memory consumption. The paper reports an average memory-usage increase of 3.37× in its SPEC CPU2006 evaluation. It also reports an average binary-size increase of 2.5×.

**Group verification question:** How does peak memory usage change between normal and ASan builds for our selected workloads?

**Evidence required from our project:**
- One consistent memory metric (preferably peak resident set size / peak RSS).
- Same workload and input size for both builds.
- Tool name, version, unit, and collection procedure.
- At least three independent runs where feasible.
- Raw data and summary statistics.

**Important qualification:** Peak RSS measurement may be affected by the measurement tool, operating system, allocator, and workload. Record these conditions. Binary size can be included as a secondary metric if time permits.

## Claims not selected as primary experimental claims

The paper also reports real-world deployment results, including more than 300 previously unknown bugs found in Chromium during the period described by the authors. Reproducing this result is outside the scope of the current student project. It can be discussed as motivation and external evidence, but must not be presented as our own experimental result.

## Final selection status

These are the group's **proposed** three claims. The group should confirm that the assignment requires 1–3 claims and that the selected claims map appropriately to the paper's figures, tables, and evaluation sections before freezing the scope.
