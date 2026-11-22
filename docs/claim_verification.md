# Member A — Preliminary Claim Verification
Status: **Preliminary audit draft — not final experimental verdicts**

## Summary
The repository contains a summary of four ASan detection tests and benchmark measurements for GEMM, Cholesky, and MVT. The group reports that i7 and i9 environments were both used, but exact row-to-machine mapping, benchmark coverage on each machine, and the memory measurement method remain unresolved.

## C1 — Detection
`detection_results.md` reports:
- Heap: `heap-buffer-overflow`
- Stack: `stack-buffer-overflow`
- Global: `global-buffer-overflow`
- Use-after-free: `heap-use-after-free`

It reports non-zero exit status and successful detection for all four tests.

**Preliminary verdict: SUPPORTED within the four tested examples**, conditional on verifying the raw stderr logs and source files. This does not establish complete detection coverage.

Retain each test source, exact compile command, compiler version, full stderr output, exit code, and interpretation.

## C2 — Runtime overhead
The paper reports 73% average runtime slowdown on SPEC CPU2006. The group uses PolyBench/C, a different benchmark suite. The B-provided terminal output contains three runtime columns for Normal and ASan versions of GEMM, Cholesky, and MVT. However, benchmark-to-machine mapping and controlled pairing are not yet established.

**Preliminary verdict: INCONCLUSIVE for quantitative reproduction of the paper's aggregate claim.**

Before reporting a project-level runtime result, confirm:
1. Which machine produced every CSV row.
2. All three workloads were run in both modes on the same machine.
3. At least three independent runs per condition.
4. Same source revision, inputs, optimization level, and compiler version within each pair.
5. Timing method and exclusion of compile time.
6. Recomputed mean, sample SD, and overhead from raw observations.

## C3 — Memory overhead
The CSV header uses `RSS (KB)`, but the collection method is unknown. The paper's 3.37× figure comes from its own SPEC CPU2006 evaluation setup. These metrics must not be treated as equivalent without checking definitions.

**Preliminary verdict: INCONCLUSIVE.**

Confirm exact tool/command, whether the value is peak or sampled RSS, unit, child-process handling, and consistent use for Normal and ASan. Preserve raw output.

## Overall preliminary verdict
| Claim | Verdict | Reason |
|---|---|---|
| C1 Detection | Supported within four test cases, pending raw-log verification | Summary reports expected diagnostics |
| C2 Runtime | Inconclusive | Machine mapping and controlled-pair evidence incomplete |
| C3 Memory | Inconclusive | Measurement method and provenance unknown |

The current PolyBench/C experiments are a modified reproduction. They do not reproduce the paper's SPEC CPU2006 aggregate results or Chromium deployment evidence.
