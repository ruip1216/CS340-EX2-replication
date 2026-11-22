# Claim Verification (Revised Evidence Audit)

**Status:** Evidence-based interim verification. Quantitative results are separated by machine. This is not a claim of exact reproduction of the original paper.

## 1. Evidence inventory and provenance

### 1.1 i9 evidence supplied by Member C

`benchmark_run(1).log` identifies:
- CPU: 13th Gen Intel Core i9-13900H
- OS: Linux on WSL2
- Kernel: 6.18.54.1-microsoft-standard-WSL2
- Compiler: Ubuntu Clang 18.1.3 (1ubuntu1)
- Architecture: x86_64
- Optimization: `-O2`
- ASan flags: `-fsanitize=address -g`

Important provenance limitation: the log explicitly says it is **reconstructed from `raw_data_extended.csv` and environment/compilation records**, not a contemporaneously captured terminal execution log. It records three runs each for GEMM, Cholesky, and MVT under Normal and ASan conditions.

### 1.2 i7 evidence supplied by Member B

`benchmark_run(2).log` records a V2 run on Member B's i7 machine, but the supplied excerpt contains only one GEMM Normal measurement and one GEMM ASan measurement:
- Normal: 0.2866 s; reported Peak RSS 29,493 KB
- ASan: 0.5666 s; reported Peak RSS 37,526 KB

This is a **single-run observation**, not a three-run sample. It cannot be combined with the i9 results or used to claim complete i7 coverage.

The earlier `raw_data (1).csv`, associated with the second batch in the previously supplied environment mapping, contains three GEMM runs per condition:
- Normal times: 0.41, 0.43, 0.39 s; RSS: 29,456, 29,292, 29,452 KB
- ASan times: 0.80, 0.90, 0.91 s; RSS: 37,188, 37,160, 37,196 KB

The three-run CSV and the later V2 single-run log are retained as separate records because their values differ. Do not merge or average them. The mapping of the second batch to i7 follows the group's previously supplied mapping; the V2 log itself does not independently print the CPU model.

### 1.3 Additional i9 GEMM batch

The earlier `raw_data.csv` contains three GEMM runs per condition and was mapped to the first batch in the group's earlier provenance note. It is retained separately from `raw_data_extended.csv`. The extended i9 data is the complete three-workload dataset used for the main i9 calculations below.

## 2. C1 — Detection capability

The detection summary reports four successful tests:
- Heap: `heap-buffer-overflow`
- Stack: `stack-buffer-overflow`
- Global: `global-buffer-overflow`
- Use-after-free: `heap-use-after-free`

The inspected raw logs independently confirm:
- `stack_overflow.log`: `stack-buffer-overflow`, with `stack_array` identified.
- `global_overflow.log`: `global-buffer-overflow`, with `global_array` identified.
- `uaf.log`: `heap-use-after-free`, with allocation and free traces.

The inspected file set did not contain a standalone `heap_overflow.log`. The summary reports the expected heap diagnostic, but the raw diagnostic should be committed before treating all four log records as independently audited.

**Interim verdict: PARTIALLY SUPPORTED pending heap raw-log verification.**  
If the heap log is recovered and matches `heap-buffer-overflow`, the project may state: “ASan detected all four representative error classes tested.” Do not generalize this to all memory bugs.

## 3. C2 — Runtime overhead

### 3.1 Main i9 results (three runs per condition)

Source: `raw_data_extended.csv`, environment and compilation metadata summarized in Member C's `benchmark_run(1).log`.

| Benchmark | Normal mean ± sample SD (s) | ASan mean ± sample SD (s) | Runtime overhead |
|---|---:|---:|---:|
| GEMM | 0.2967 ± 0.0058 | 0.5833 ± 0.0252 | 96.63% |
| Cholesky | 17.3767 ± 0.9874 | 54.3567 ± 3.6371 | 212.81% |
| MVT | 0.0300 ± 0.0000 | 0.0467 ± 0.0058 | 55.56% |

Interpretation:
- All three i9 workloads ran slower in the ASan condition.
- Cholesky had the largest observed relative runtime overhead.
- MVT has a very short baseline runtime (about 0.03 s), so its relative overhead is particularly sensitive to timer resolution and system noise.
- These are workload-specific PolyBench/C observations, not a reproduction of the paper's 73% SPEC CPU2006 average.

### 3.2 i7 GEMM results (three-run CSV batch)

Source: `raw_data (1).csv`, associated with the second batch in the group's earlier machine mapping.

| Condition | Mean runtime ± sample SD (s) | Mean recorded RSS ± sample SD (KB) |
|---|---:|---:|
| Normal | 0.4100 ± 0.0200 | 29,400.00 ± 93.55 |
| ASan | 0.8700 ± 0.0608 | 37,181.33 ± 18.90 |

Observed GEMM runtime overhead: **112.20%**.

This is a separate i7 result and must not be pooled with i9. The more recent B V2 log has only one run per condition and is recorded separately in the evidence inventory.

### 3.3 Additional first-batch GEMM data

Source: `raw_data.csv` (three runs per condition; first batch in the earlier mapping).

| Condition | Mean runtime ± sample SD (s) | Mean recorded RSS ± sample SD (KB) |
|---|---:|---:|
| Normal | 0.3000 ± 0.0173 | 29,494.67 ± 36.95 |
| ASan | 0.5667 ± 0.0058 | 37,594.67 ± 94.35 |

Observed GEMM runtime overhead: **88.89%**.

This batch is not substituted for the extended i9 dataset; retain it as a separate batch until the group confirms the exact run history and why the extended measurements were repeated.

**Interim verdict: SUPPORTED for the narrow statement that ASan increased measured runtime in the available paired PolyBench/C runs.**  
**Not supported as an exact quantitative reproduction of the paper's 73% aggregate slowdown.** i7 coverage remains incomplete because Cholesky and MVT three-run pairs were not provided in the current i7 evidence set.

## 4. C3 — Memory overhead

### 4.1 Main i9 results (recorded RSS, reported as Peak RSS in the log)

| Benchmark | Normal mean ± sample SD (KB) | ASan mean ± sample SD (KB) | ASan / Normal ratio | Memory overhead |
|---|---:|---:|---:|---:|
| GEMM | 29,670.67 ± 10.07 | 37,308.00 ± 117.23 | 1.257× | 25.74% |
| Cholesky | 63,898.67 ± 11.55 | 75,513.33 ± 149.74 | 1.182× | 18.18% |
| MVT | 32,730.67 ± 66.97 | 40,609.33 ± 49.69 | 1.241× | 24.07% |

All three i9 workloads show higher recorded RSS in the ASan condition.

### 4.2 i7 GEMM (three-run CSV batch)

- Normal mean recorded RSS: 29,400.00 KB
- ASan mean recorded RSS: 37,181.33 KB
- ASan / Normal ratio: **1.265×**
- Memory overhead: **26.47%**

### 4.3 i7 V2 single-run observation

From Member B's `benchmark_run(2).log`:
- Normal: 29,493 KB
- ASan: 37,526 KB
- Ratio: approximately **1.272×**
- Single-run memory increase: approximately **27.23%**

This single observation is descriptive only and is not merged into the three-run i7 dataset.

**Measurement limitation:** The CSV column is `RSS (KB)` and the logs label the values “Peak RSS”, but the exact command/field that generated them has not yet been independently verified. The report should therefore use “recorded RSS (reported as Peak RSS)” until the collection command is confirmed. The paper's 3.37× figure is identified in the paper notes as VmPeak; it is not directly comparable to the group's RSS values.

**Interim verdict: PARTIALLY SUPPORTED for the narrow statement that recorded RSS was higher in the ASan runs.**  
A final measurement-quality verdict requires the exact RSS collection command and confirmation that the same method was used for Normal and ASan.

## 5. Overall interim verdict

| Claim | Interim verdict | Defensible statement |
|---|---|---|
| C1 Detection | Partially Supported | Three raw logs confirm expected diagnostics; heap is reported in the summary but its standalone raw log remains to be verified. |
| C2 Runtime | Supported within available paired workloads | ASan increased runtime in the available paired PolyBench/C data. Exact paper-level quantitative reproduction is not established. |
| C3 Memory | Partially Supported | Recorded RSS increased in the available paired data; exact measurement method remains unverified and differs from paper VmPeak. |

## 6. Remaining evidence required before final submission

1. Recover and commit the raw heap-overflow stderr log.
2. Ask Member B to provide three-run i7 Cholesky and MVT Normal/ASan data, or explicitly state that the i7 study covers GEMM only.
3. Confirm whether the i7 three-run CSV (`raw_data (1).csv`) and the later B V2 single-run log are separate experiments and document why their values differ.
4. Provide the exact memory measurement command and the exact field used to extract RSS.
5. Confirm the exact workload input sizes / PolyBench dataset parameters and source revision.
6. Confirm the compiler version and flags for the i7 dataset; do not assume the i9 Clang 18.1.3 metadata applies to i7.
7. Confirm whether the first-batch GEMM dataset and extended i9 GEMM dataset are separate runs, and retain both without pooling.
8. Re-run MVT with a longer measurement interval or repeated timing if the group has time; its ~0.03–0.05 s duration limits precision.
9. Add a machine identifier and batch identifier to every raw-data row or provide a separate provenance manifest.
10. Finalize Claim verdicts only after the above evidence is resolved or explicitly recorded as a limitation.

## 7. Reproduction boundary

This project is a modified reproduction using PolyBench/C and representative C error tests. It does not reproduce the paper's SPEC CPU2006 aggregate benchmark, original hardware/software stack, or Chromium deployment study.
