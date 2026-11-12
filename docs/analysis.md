# Experimental Analysis

## 1. Performance Differences Across Benchmarks

The experimental results show that ASan introduced different levels of performance overhead across the three benchmarks.

Cholesky showed the highest execution time overhead (212.81%), while MVT had the lowest (55.33%). This difference may be related to the characteristics and computational operations of each benchmark. Different workloads may interact with ASan's memory instrumentation in different ways.

For memory usage, the overhead ranged from 18.18% to 25.74%. GEMM showed the highest memory overhead, while Cholesky showed the lowest.

Overall, the results suggest that ASan overhead depends on the workload rather than remaining constant across different programs.

## 2. Comparison with the Original Paper

The original AddressSanitizer paper reported an average runtime slowdown of 73% and an average memory usage increase of approximately 3.37 times in its evaluation.

Our experiments also showed additional execution time and memory usage when ASan was enabled. However, the measured overheads were different from those reported in the original paper.

There are several reasons for this difference:

- **Benchmark differences:** The original paper used SPEC CPU2006, while our experiments used three benchmarks from PolyBench/C.
- **Hardware and environment:** The original paper and our experiments used different hardware and software environments. In addition, the project README specifies Clang 21.1.8, while our actual experiments were conducted using Ubuntu Clang 18.1.3.
- **Workload characteristics:** The three selected benchmarks have different computational and memory access patterns.
- **Measurement conditions:** Differences in compiler versions, compilation settings, and measurement methods may also affect the results.

Therefore, the results should not be directly compared as if they came from the same experimental conditions.

## 3. Experimental Limitations

There are several limitations in our current experiments.

First, only three benchmarks were evaluated, so the results may not represent the performance overhead of ASan across all types of applications.

Second, each benchmark version was executed three times. More repetitions could provide more reliable measurements.

Third, MVT had a very short execution time, which made its timing overhead less precise because of the limited resolution of the timing tool.

These limitations should be considered when interpreting the results.