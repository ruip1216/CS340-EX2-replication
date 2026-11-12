# Extension Experiment

## 1. Motivation

To extend the initial experiment, we evaluated two additional benchmarks from PolyBench/C: Cholesky and MVT.

The initial experiment only used GEMM. Adding more benchmarks allowed us to examine whether ASan introduces different levels of performance overhead across different workloads.

## 2. Experimental Setup

Three benchmarks were selected:

- **GEMM:** Matrix multiplication.
- **Cholesky:** Matrix decomposition.
- **MVT:** Matrix-vector operations.

For each benchmark, we prepared two versions:

- Normal version: compiled without AddressSanitizer.
- ASan version: compiled with AddressSanitizer enabled.

Each version was executed three times. Execution time and maximum resident set size (RSS) were recorded for each run. The average values were then calculated.

All experiments were conducted in the same Docker environment using Ubuntu Clang 18.1.3.

## 3. Extension Results

The extended experiment produced the following results:

| Benchmark | Time Overhead | Memory Overhead |
|---|---:|---:|
| GEMM | 96.66% | 25.74% |
| Cholesky | 212.81% | 18.18% |
| MVT | 55.33% | 24.07% |

Among the three benchmarks, Cholesky showed the highest execution time overhead, while MVT showed the lowest. GEMM had the highest memory overhead.

The results demonstrate that ASan overhead varies across different workloads.

## 4. Extension Findings

By adding Cholesky and MVT to the initial GEMM experiment, we observed that the performance impact of ASan was not consistent across benchmarks.

This extension provides a broader evaluation than the initial GEMM-only experiment. It also suggests that benchmark characteristics should be considered when evaluating the performance overhead of AddressSanitizer.