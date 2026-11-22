# Completion Status, Outstanding Work, and Handover

**Project:** CS340 EX2 — AddressSanitizer Replication

## A. Work completed in this package

### Week 2
- Defined C1 detection, C2 runtime overhead, and C3 memory overhead.
- Mapped each claim to its group experiment and required evidence.
- Distinguished original-paper claims from the group's modified reproduction.
- Defined scoped verdict language and statistical reporting requirements.

### Week 3
- Audited detection evidence and identified the missing standalone heap stderr log.
- Recomputed mean and sample standard deviation from the three-run CSV batches.
- Calculated per-workload runtime overhead and recorded-RSS overhead.
- Kept i7 and i9 results separate.
- Kept B's later V2 single-run result separate from the earlier i7 three-run CSV.
- Compared the original paper's SPEC CPU2006 setup with the group's PolyBench/C setup.
- Corrected the paper binary-size figure to 2.5× based on the group's `paper_results.md` source notes; this must remain traceable to the paper citation in the final report.

## B. Current results snapshot

### i9 extended dataset — three runs per condition

| Benchmark | Runtime overhead | Recorded RSS overhead |
|---|---:|---:|
| GEMM | 96.63% | 25.74% |
| Cholesky | 212.81% | 18.18% |
| MVT | 55.56% | 24.07% |

### i7 second-batch CSV — three runs per condition, GEMM only

| Benchmark | Runtime overhead | Recorded RSS overhead |
|---|---:|---:|
| GEMM | 112.20% | 26.47% |

### i7 V2 log — one run per condition, GEMM only

| Metric | Normal | ASan |
|---|---:|---:|
| Runtime (s) | 0.2866 | 0.5666 |
| Recorded RSS (KB) | 29,493 | 37,526 |

This V2 run is descriptive only and is not merged with the three-run i7 dataset.

## C. Documentation and analysis tasks completed / pending

- [x] Revise `claims_and_metrics.md`.
- [x] Revise `claim_verification.md`.
- [x] Revise `paper_ours_notes.md`.
- [x] Recompute statistics from available three-run CSV files.
- [x] Separate i7 and i9 evidence.
- [x] Record evidence limitations and next actions.
- [ ] Upload this revised package to the group's GitHub repository.
- [ ] After evidence arrives, update final C1/C2/C3 verdicts and commit the final version.

## D. Items requiring other members' evidence

| Owner | Required action | Why it matters |
|---|---|---|
| Member B (i7) | Provide three-run Cholesky and MVT Normal/ASan results, or confirm i7 was GEMM-only | Establish i7 workload coverage |
| Member B (i7) | Confirm CPU model, OS/kernel, compiler version, `-O2` and ASan flags | Validate the i7 experimental environment |
| Member B (i7) | Explain whether the V2 one-run log is a new rerun separate from `raw_data (1).csv` | Preserve data provenance |
| Member C (i9) | Recover/commit raw heap-overflow stderr log and confirm source/compile command | Complete C1 raw evidence |
| Member C (i9) | Confirm exact RSS collection command and field | Validate C3 metric |
| Member D / experiment operator | Confirm exact timing and RSS commands, input parameters, source revision, and whether compilation time was excluded | Validate C2/C3 controls |

## E. Final evidence checklist

- [ ] `heap_overflow.log` containing `ERROR: AddressSanitizer: heap-buffer-overflow`.
- [ ] Four test source files and exact compile commands.
- [ ] All four raw stderr logs and exit statuses.
- [ ] i7/i9 CPU, OS, compiler and flag metadata.
- [ ] i7 Cholesky/MVT data or an explicit scope limitation.
- [ ] Exact PolyBench/C dataset/input size and source revision.
- [ ] Exact timing tool/command and confirmation compile time was excluded.
- [ ] Exact memory tool/command and field (e.g. GNU time maximum resident set size, if that is what was used).
- [ ] Explanation for distinct i7 CSV and V2 GEMM values.
- [ ] Final verdicts updated only after the above checks.

## F. What can be claimed now

1. The group has tested four representative memory-error categories. Three raw logs were inspected and match the expected diagnostics; the heap result is reported in the summary but its standalone raw log is missing from the inspected files.
2. In the available three-run i9 PolyBench/C dataset, all three workloads show higher runtime and recorded RSS in the ASan condition.
3. In the available three-run i7 GEMM dataset, ASan also shows higher runtime and recorded RSS.
4. The group's results are a modified reproduction and must not be presented as reproducing the paper's SPEC CPU2006 averages or Chromium bug-finding results.

## G. What must not be claimed yet

- Do not claim all four detection logs have been independently verified until the heap log is available.
- Do not claim i7 completed all three benchmarks.
- Do not combine i7 and i9 observations into one average.
- Do not merge B's V2 one-run log with the earlier i7 three-run CSV.
- Do not call the group's memory metric definitively “Peak RSS” until the exact collection command/field is confirmed.
- Do not compare the group's RSS ratio directly with the paper's VmPeak 3.37× figure.
- Do not claim exact quantitative reproduction of the paper's 73% runtime slowdown.

## H. Recommended next sequence

1. Commit this research documentation package.
2. Request the missing items from B, C, and D using the table in Section D.
3. Update the provenance register when replies arrive.
4. Re-run calculations only from traceable, per-machine raw observations.
5. Freeze C1/C2/C3 verdicts and prepare the final report / presentation narrative.
