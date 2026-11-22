# Original Paper vs. Our Study (Revised)

**Status:** Revised comparison using the group's paper notes, repository files, and the newly supplied i9/i7 benchmark logs.

## 1. Original paper setup

Serebryany et al. (2012), *AddressSanitizer: A Fast Address Sanity Checker*, USENIX ATC 2012.

According to the group's `paper_results.md`:
- Benchmark suite: SPEC CPU2006, C/C++ programs.
- Execution mode: 64-bit.
- Machine: HP Z600, two quad-core Intel Xeon E5620 CPUs, 24 GB RAM.
- Compiler comparison: instrumented binaries versus regular LLVM-compiled binaries; `clang -O2`.
- Paper-specific settings recorded in the group's notes: 32-byte redzones; stack unwinding during `malloc`/`free` disabled; quarantine size set to zero for performance measurements.

Paper-reported results:
| Metric | Paper result |
|---|---:|
| Average runtime slowdown | 73% |
| Average memory usage | 3.37× |
| Average binary-size increase | 2.5× |
| Write-only instrumentation slowdown | 26% |
| Largest slowdown | 2.67× (`xalancbmk`); `perlbench` 2.60× |

These are the paper's results, not group results. The binary-size value is **2.5×**, not 2.5%.

The paper also reports three SPEC CPU2006 bugs and more than 300 previously unknown Chromium bugs during the deployment period described by the authors. These deployment findings are not reproduced by the group's four small C tests.

## 2. Our study setup

### 2.1 Workloads and experiments

- Detection: four representative C tests — heap out-of-bounds, stack out-of-bounds, global out-of-bounds, and use-after-free.
- Performance/resource study: PolyBench/C GEMM, Cholesky, and MVT.
- Conditions: Normal and ASan builds.
- i9 evidence: Intel Core i9-13900H; Linux on WSL2; Ubuntu Clang 18.1.3; `-O2`; ASan build uses `-fsanitize=address -g`.
- i7 evidence: Member B's machine is identified by the group as i7. The latest supplied V2 log gives one GEMM observation per condition. The earlier second-batch CSV provides three GEMM observations per condition. Full i7 Cholesky/MVT data has not been supplied in the inspected evidence set.

### 2.2 Main i9 results

| Benchmark | Runtime overhead | Recorded RSS overhead |
|---|---:|---:|
| GEMM | 96.63% | 25.74% |
| Cholesky | 212.81% | 18.18% |
| MVT | 55.56% | 24.07% |

The calculations use the three-run `raw_data_extended.csv` batch. Means and sample standard deviations are provided in `claim_verification.md` and `results/derived_metrics.csv`.

### 2.3 i7 GEMM results

The three-run second-batch CSV gives:
- Runtime overhead: 112.20%.
- Recorded RSS overhead: 26.47%.

Member B's later V2 log gives one additional GEMM observation:
- Normal: 0.2866 s and 29,493 KB.
- ASan: 0.5666 s and 37,526 KB.

The V2 log is a single-run record and differs from the earlier three-run CSV. The two data sources are not merged.

## 3. Deviation analysis

| Dimension | Original paper | Group study | Consequence |
|---|---|---|---|
| Benchmark suite | SPEC CPU2006 | PolyBench/C: GEMM, Cholesky, MVT | Workload mix differs; group averages are not comparable to the paper's aggregate. |
| Detection evidence | Paper's benchmark findings and Chromium deployment | Four purpose-built C tests | Demonstrates selected error categories only; not equivalent to real-world bug discovery. |
| Hardware | HP Z600, dual Xeon E5620, 24 GB | i9-13900H and a separate i7 system, both reported by members | Hardware differences affect absolute time and memory measurements; report results separately. |
| OS / execution | Paper's 64-bit Linux evaluation | Linux on WSL2 is documented for i9; i7 details need confirmation | Virtualization and host scheduling may affect measurements. |
| Compiler | Early LLVM/Clang-era toolchain; paper notes `clang -O2` | i9: Ubuntu Clang 18.1.3; i7 version not verified | Compiler/runtime version differences may affect instrumentation overhead. |
| Optimization | `-O2` | i9 compile logs show `-O2`; i7 flags need confirmation | Comparability depends on matched flags within each Normal/ASan pair. |
| ASan settings | Paper-specific redzone/quarantine/unwinding settings | Group build shows `-fsanitize=address -g`; full runtime settings need confirmation | Sanitizer configuration may change detection and overhead. |
| Runtime metric | Paper's SPEC CPU2006 timing procedure | CSV time in seconds; exact timing command needs confirmation | Timing methods must be verified before strong quantitative comparison. |
| Memory metric | Paper notes identify VmPeak | CSV labels RSS (KB); log describes Peak RSS; exact collection field unknown | Not metric-equivalent; do not compare 3.37× directly with group RSS ratios. |
| Repetitions | Paper's own evaluation methodology | Three runs in the main CSV batches; latest B V2 log is one run | Single-run V2 values are descriptive, not statistical. |

## 4. Interpretation

The available group data is consistent with the qualitative expectation that ASan adds execution and memory overhead:
- In the i9 extended dataset, all three workloads show increased runtime and recorded RSS under ASan.
- In the i7 GEMM three-run batch, runtime and recorded RSS are also higher under ASan.
- The magnitude varies by workload and machine/batch.

The data does **not** establish that our study reproduced the paper's 73% runtime slowdown or 3.37× memory result. The workloads, hardware, compiler versions, and memory metric differ. In particular, the paper's VmPeak and the group's recorded RSS must not be treated as interchangeable.

The large Cholesky runtime increase is an observed result, not proof of a specific cause. Potential explanations such as workload characteristics, compiler/runtime versions, system load, or instrumentation cost should be presented as hypotheses unless tested through controlled experiments.

## 5. Limitations and next evidence

1. Obtain i7 Cholesky and MVT three-run Normal/ASan measurements if the group intends to claim three-workload coverage on both machines.
2. Confirm the i7 CPU model, OS/kernel, compiler version, optimization flags, and sanitizer flags.
3. Confirm the exact timing command and ensure compile time was excluded.
4. Confirm the exact RSS collection command/field and whether it is peak RSS.
5. Recover the raw heap diagnostic log.
6. Record the PolyBench/C dataset/input parameters and exact source revision.
7. Explain the difference between the i7 three-run GEMM CSV and the later V2 one-run log.
8. Keep i7 and i9 measurements separate; do not calculate a pooled mean across different machines.

## 6. Conclusion

The group has completed a modified reproduction of selected ASan behaviours and performance/resource measurements using four representative memory-error tests and three PolyBench/C workloads. Current evidence supports the qualitative finding that ASan detects several representative memory errors and increases runtime and recorded RSS in the measured conditions. However, the evidence does not constitute an exact reproduction of the paper's SPEC CPU2006 aggregate results or Chromium deployment findings. Final quantitative conclusions remain bounded by incomplete i7 workload coverage and unresolved memory-measurement provenance.

## Reference

Serebryany, K., Bruening, D., Potapenko, A., & Vyukov, D. (2012). *AddressSanitizer: A Fast Address Sanity Checker*. Proceedings of the 2012 USENIX Annual Technical Conference, 309–318. https://www.usenix.org/system/files/conference/atc12/atc12-final39.pdf
