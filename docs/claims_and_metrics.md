# Member A — Claims and Metrics Mapping

Paper: Serebryany et al., *AddressSanitizer: A Fast Address Sanity Checker*, USENIX ATC 2012.

## Scope
The group currently uses four small C detection tests and PolyBench/C workloads (GEMM, Cholesky, MVT), rather than the paper's SPEC CPU2006 evaluation. Describe this as a **partial / modified reproduction**, not an exact replication.

## C1 — Detection capability
**Paper-level claim:** ASan detects out-of-bounds accesses to heap, stack, and global objects, and heap use-after-free errors.

**Group test:** Verify expected diagnostics from four representative programs.

| Test | Expected diagnostic | Current evidence | Preliminary status |
|---|---|---|---|
| Heap out-of-bounds | `heap-buffer-overflow` | `detection_results.md`, `tests/test_asan.c` | Reported detected |
| Stack out-of-bounds | `stack-buffer-overflow` | `detection_results.md`, `tests/test_stack.c` | Reported detected |
| Global out-of-bounds | `global-buffer-overflow` | `detection_results.md`, `tests/test_global.c` | Reported detected |
| Use-after-free | `heap-use-after-free` | `detection_results.md`, `tests/test_uaf.c` | Reported detected |

Metrics: expected diagnostic (yes/no), diagnostic category, exit status, preserved stderr log.

Scope limitation: These four examples do not prove ASan detects every memory bug and do not reproduce the paper's Chromium deployment study.

## C2 — Runtime overhead
Paper result: 73% average runtime slowdown on SPEC CPU2006.

Group question: What runtime overhead does ASan introduce on each selected PolyBench/C workload?

`Runtime overhead (%) = ((mean ASan runtime - mean Normal runtime) / mean Normal runtime) × 100`

Report each workload separately, with at least three runs per condition and mean ± standard deviation. PolyBench/C results are not directly equivalent to the paper's SPEC CPU2006 aggregate.

## C3 — Memory overhead
Paper result: 3.37× average memory usage increase in the paper's SPEC CPU2006 evaluation.

Group question: What is the ASan-to-Normal ratio for a consistently measured memory metric?

`Memory ratio = mean ASan RSS / mean Normal RSS`

Do not call a value “peak RSS” unless the tool actually measures peak RSS. Do not mix RSS, VmPeak, virtual memory size, and allocator-requested bytes.

## Claim-to-evidence map
| Claim | Group evidence required | Current status |
|---|---|---|
| C1 Detection | Four source files, compiler commands, stderr logs, exit codes | Preliminary support; verify raw logs |
| C2 Runtime | Raw per-run times, environment, flags, workload/input identity, script | Inconclusive pending audit |
| C3 Memory | Raw per-run values, exact metric/tool, environment, logs | Inconclusive pending audit |

## Verdict definitions
- Supported: valid evidence supports the claim within the tested scope.
- Partially supported: evidence supports only part or a narrower statement.
- Not supported: a valid test contradicts the claim within the tested scope.
- Inconclusive: evidence is missing, untraceable, or confounded.

Use scoped verdicts. “Supported for our four representative tests” is defensible; “ASan detects all memory errors” is not.
