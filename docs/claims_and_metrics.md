# Claims and Metrics Mapping (Revised)

**Project:** CS340 EX2 — AddressSanitizer (ASan) Replication  
**Paper:** Serebryany et al., *AddressSanitizer: A Fast Address Sanity Checker*, USENIX ATC 2012  
**Status:** Revised from the available paper notes, repository materials, CSV files, and member-provided benchmark logs.

## 1. Study scope

This is a **modified / partial reproduction**, not an exact replication of the original paper.

- Original paper: SPEC CPU2006 and real-world deployment evidence, including Chromium.
- Group study: four purpose-built C memory-error tests and selected PolyBench/C workloads (GEMM, Cholesky, MVT).
- Environments reported by the group: Intel i9 and Intel i7 systems running Linux under WSL2.
- Compiler/build information available for the i9 extended run: Ubuntu Clang 18.1.3, `-O2`; ASan build additionally uses `-fsanitize=address -g`.

The group must not present PolyBench/C measurements as a reproduction of the paper's SPEC CPU2006 aggregate figures.

## 2. C1 — Detection capability

**Paper-level claim:** ASan detects out-of-bounds accesses to heap, stack, and global objects, and heap use-after-free errors.

**Group verification question:** Does the ASan-instrumented build report the expected diagnostic for one representative test of each of these four error classes?

| Test case | Expected ASan diagnostic | Evidence currently available | Status |
|---|---|---|---|
| Heap out-of-bounds | `heap-buffer-overflow` | `detection_results.md` reports detection; `tests/test_asan.c` is referenced. A standalone raw `heap_overflow.log` was not present in the inspected files. | Reported detected; raw-log verification outstanding |
| Stack out-of-bounds | `stack-buffer-overflow` | `stack_overflow.log` contains the expected ASan diagnostic and identifies `stack_array` as the overflowed object. | Supported for this test |
| Global out-of-bounds | `global-buffer-overflow` | `global_overflow.log` contains the expected diagnostic and identifies `global_array`. | Supported for this test |
| Use-after-free | `heap-use-after-free` | `uaf.log` contains the expected diagnostic and allocation/free trace. | Supported for this test |

**Metrics / observations**
- Expected diagnostic category: yes/no.
- Process exit status: non-zero when ASan terminates the invalid test.
- Full standard-error log preserved.
- Test source and exact compiler command preserved.

**Scoped interpretation:** Current evidence supports detection of the stack, global, and use-after-free examples. The heap case is reported in the detection summary but its standalone raw log was not available in the inspected file set. Once that log is committed and checked, C1 may be described as supported across the four representative test cases. This does not prove that ASan detects every possible memory error.

## 3. C2 — Runtime overhead

**Paper-level result:** The paper reports an average runtime slowdown of 73% on SPEC CPU2006.

**Group verification question:** What runtime overhead does ASan introduce for each selected PolyBench/C workload under the group's recorded conditions?

For each benchmark:

`Runtime overhead (%) = ((mean ASan time - mean Normal time) / mean Normal time) × 100`

Report per-workload values first. For each condition, report the three raw observations, arithmetic mean, and sample standard deviation.

**Data-quality rules**
1. Do not combine measurements from different machines into one paired result.
2. Normal and ASan observations must use the same workload, input, source revision, compiler version, and comparable optimization settings.
3. Compilation time must not be included in program runtime.
4. Preserve all runs; do not silently discard outliers.
5. Report i7 and i9 results separately.
6. A one-run measurement is descriptive only; it does not meet the group's three-run reporting design.

## 4. C3 — Memory overhead

**Paper-level result:** The paper reports a 3.37× average memory-usage figure for its SPEC CPU2006 evaluation. The paper's metric is identified in the group's source notes as VmPeak.

**Group verification question:** How does the group's measured resident-memory metric change between Normal and ASan builds for the selected workloads?

`Memory ratio = mean ASan RSS / mean Normal RSS`

`Memory overhead (%) = (Memory ratio - 1) × 100`

The available group CSV files label the metric `RSS (KB)`, and member logs describe it as `Peak RSS`. The exact collection command/field has not yet been independently verified. Therefore, the report must call it **recorded RSS (reported as Peak RSS in the logs)** until the exact measurement command and field are confirmed. Do not claim that RSS is equivalent to the paper's VmPeak.

## 5. Claim-to-evidence map

| Claim | Required evidence | Current state |
|---|---|---|
| C1 Detection | Four source files, exact compile commands, exit codes, full stderr logs | Three raw logs inspected; heap raw log missing from inspected files |
| C2 Runtime | Per-machine raw runs, workload/input identity, compiler/build records, timing method | i9 three-workload data available; i7 GEMM data available; i7 coverage incomplete |
| C3 Memory | Per-machine raw observations, exact metric/tool/command, units, measurement logs | CSV values available; exact RSS collection method unresolved |

## 6. Verdict definitions

- **Supported:** Valid evidence supports the claim within the tested scope.
- **Partially supported:** Evidence supports only a subset or narrower version of the claim.
- **Not supported:** A valid test contradicts the claim within the tested scope.
- **Inconclusive:** Evidence is missing, untraceable, or confounded.

Do not assign a stronger verdict than the evidence allows.
