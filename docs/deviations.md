# Experimental Deviations from the Original Paper

This document summarizes the key differences between the original AddressSanitizer (ASan) paper setup and our replication setup, along with their potential impact on the observed results.

## Deviation Summary Table

| Dimension | Original Paper Setup | Our Replication Setup | Rationale & Potential Impact |
| :--- | :--- | :--- | :--- |
| **Benchmark Suite** | SPEC CPU2006 and large real-world applications (e.g., Chromium) | PolyBench/C (starting with `gemm` and extended kernels) | SPEC CPU2006 requires a commercial license. PolyBench/C is open-source and reproducible, though compute-heavy kernels may show different overhead ratios than general-purpose SPEC workloads. |
| **Compiler & ASan Version** | Early LLVM/Clang prototype (circa 2012) | Ubuntu Clang 21.1.8 (`-fsanitize=address`) | Modern Clang includes over a decade of compiler and ASan runtime optimizations, which may reduce instrumentation overhead compared to the 2012 baseline. |
| **Execution Environment** | Bare-metal Linux workstation | Ubuntu on WSL2 (Windows host) & Docker container | Virtualization (WSL2) and containerization (Docker) ensure strict cross-machine reproducibility, though minor scheduling jitter may occur. |
| **Hardware** | 2012-era x86_64 CPU | 12th Gen Intel Core i7-12800HX (7.6 GiB WSL2 RAM) | Modern CPU caches and memory bandwidth alter the absolute execution time and memory access penalty of shadow memory lookups. |
| **Measurement Method** | Custom paper benchmarking harness | GNU `/usr/bin/time -v` (Wall-clock time & Peak RSS), >= 3 runs | Standardized Linux measurement tool; reporting Mean ± Standard Deviation across multiple runs ensures statistical traceability. |

## Notes on Interpretation
- Because PolyBench/C kernels do not directly map 1-to-1 to the overall average of SPEC CPU2006, single-workload overhead numbers should not be treated as an exact equivalent to the paper's headline average.
- All raw logs and environment metadata are preserved in `results/` and `results_from_docker/` for full traceability.
