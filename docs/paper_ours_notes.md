# Member A — Paper vs. Our Study
Status: Draft; group numerical results are withheld where provenance is not verified.

## Paper setup and reported results
The group's `paper_results.md` records that the paper evaluated C/C++ SPEC CPU2006 benchmarks in 64-bit mode on an HP Z600 with two quad-core Intel Xeon E5620 CPUs and 24 GB RAM. The paper compared instrumented binaries with regular LLVM-compiled binaries using `clang -O2`.

Paper-reported figures:
- Average runtime slowdown: 73%.
- Average memory usage increase: 3.37×.
- Average binary-size increase: 2.5%.
- Write-only instrumentation slowdown: 26%.
- Largest slowdowns: 2.60× for `perlbench` and 2.67× for `xalancbmk`.

These are paper results, not group results.

## Our current setup
- Workload suite: PolyBench/C, not SPEC CPU2006.
- Workloads in current project materials: GEMM, Cholesky, MVT.
- Conditions: Normal and ASan builds.
- Detection suite: heap, stack, global out-of-bounds, use-after-free.
- The supplied terminal output shows three run fields per benchmark/version.
- `analysis.py` computes mean and sample standard deviation from three time and RSS observations and calculates overhead.

## Deviations
| Item | Paper | Our current study | Impact |
|---|---|---|---|
| Benchmark | SPEC CPU2006 | PolyBench/C | Not directly comparable as aggregate |
| Hardware | HP Z600, dual Xeon E5620, 24 GB | i7 and i9 reportedly used; row mapping incomplete | Hardware may affect results |
| Compiler | LLVM; paper notes `clang -O2` | Clang in build files; exact version/paired flags unconfirmed | Toolchain may affect results |
| Workloads | SPEC CPU2006 programs | GEMM, Cholesky, MVT | Modified workload scope |
| Detection | Paper's benchmark and Chromium evidence | Four purpose-built C tests | Representative tests only |
| Memory metric | Paper's stated evaluation metric (paper notes identify VmPeak) | CSV column labelled RSS (KB); collection method unknown | Not metric-equivalent yet |
| ASan settings | Paper-specific redzone, quarantine, unwinding settings | Exact group settings need confirmation | Configuration can affect overhead |

## Responsible comparison
- Compare detection categories qualitatively.
- Report per-workload runtime overhead only after provenance and controlled-pair checks.
- Do not compare unverified RSS directly with the paper's 3.37×.
- Do not claim the group reproduced the paper's 73% aggregate slowdown.

## Discrepancy analysis procedure
For every difference: state the verified result; list confirmed setup differences; separate demonstrated causes from hypotheses; use controlled reruns to test explanations; otherwise label them limitations, not findings.

## Provisional conclusion
The group has tested selected ASan detection behaviours and conducted a modified PolyBench/C performance study. Detection evidence is promising within four cases. Quantitative runtime and memory conclusions remain provisional pending machine mapping, benchmark coverage, and measurement-method verification.
