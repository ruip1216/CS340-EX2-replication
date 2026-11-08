# Paper Results — Source Baseline for Comparison

**Source:** Serebryany et al., *AddressSanitizer: A Fast Address Sanity Checker*, USENIX ATC 2012, pp. 309–318.

## 1. Reported evaluation setup

The paper evaluates C and C++ benchmarks from SPEC CPU2006. The reported measurements were performed in 64-bit mode on an HP Z600 machine with two quad-core Intel Xeon E5620 CPUs and 24 GB RAM. The authors compare instrumented binaries with regular LLVM-compiled binaries using `clang -O2`.

The paper states that 32-byte redzones were used, stack unwinding during `malloc` and `free` was disabled, and quarantine size was set to zero for the performance measurements.

## 2. Headline quantitative results

| Metric | Paper-reported result | Scope / note |
|---|---:|---|
| Average runtime slowdown | 73% | Average on SPEC CPU2006 |
| Average memory usage increase | 3.37× | SPEC CPU2006; based on VmPeak |
| Average binary-size increase | 2.5× | SPEC CPU2006 |
| Slowdown when only writes are instrumented | 26% | Separate instrumentation mode |
| Largest reported slowdown | 2.67× | `xalancbmk`; `perlbench` was 2.60× |

## 3. Detection-related evaluation evidence

- The paper reports three bugs found in SPEC CPU2006: one stack and one global buffer overflow in `h264ref`, and one use-after-realloc in `perlbench`.
- In Chromium deployment over the first ten months described in the paper, ASan detected more than 300 previously unknown bugs.
- The paper reports that heap-use-after-free was the most frequent bug category in Chromium.

These are the paper's reported results, not results produced by our group.

## 4. Paper's resource-use controls

The paper discusses three important controls:

- **Stack unwinding depth:** affects speed and diagnostic stack-trace detail.
- **Quarantine size:** affects the ability to find heap-use-after-free bugs.
- **Heap redzone size:** affects the ability to find heap buffer overflows and resource usage.

These settings should be recorded if the group changes them. Do not change them casually between normal/ASan comparisons.

## 5. Comparison cautions

1. The paper's 73% and 3.37× figures are aggregate results on SPEC CPU2006. A single GEMM or PolyBench/C result is not directly comparable to those aggregate values.
2. The original machine, compiler/toolchain, benchmark suite, and sanitizer settings differ from the group's current environment unless explicitly reproduced.
3. The paper's Chromium bug-finding result is deployment evidence, not a small benchmark test that can be replicated with the current repository.
4. A result that differs from the paper is not automatically a contradiction. First check workload, input size, compiler flags, runtime configuration, measurement method, and hardware.

## 6. Citation

Serebryany, K., Bruening, D., Potapenko, A., & Vyukov, D. (2012). AddressSanitizer: A Fast Address Sanity Checker. *Proceedings of the 2012 USENIX Annual Technical Conference*, 309–318.

Paper PDF: https://www.usenix.org/system/files/conference/atc12/atc12-final39.pdf

Google Research copy: https://research.google.com/pubs/archive/37752.pdf
