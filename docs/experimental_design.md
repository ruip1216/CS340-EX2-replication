# Experimental Design — Member A Draft

## 1. Overall research question

How effectively does AddressSanitizer detect representative memory errors, and what runtime and memory overhead does it introduce on selected workloads?

## 2. Study structure

The study has two core reproduction components and one extension:

1. **Detection verification:** test representative heap, stack, and global out-of-bounds accesses and use-after-free.
2. **Performance/resource measurement:** compare normal and ASan-instrumented builds on selected PolyBench/C workloads.
3. **Extension:** examine whether runtime overhead differs across workload types.

The extension should be attempted only after the core experiments are reliable.

## 3. Experiment A — Detection verification

### Test cases

- Heap Buffer Overflow: access outside a heap allocation.
- Stack Buffer Overflow: access outside a stack array.
- Global Buffer Overflow: access outside a global array.
- Use-after-free: access heap memory after it has been freed.

### Procedure

1. Put each bug pattern in a separate minimal C program.
2. Compile each program without ASan and record the command.
3. Compile each program with `-fsanitize=address` and debugging information.
4. Run both binaries in a controlled environment.
5. Save standard output, standard error, exit code, compiler version, and source file.
6. Check whether the ASan output identifies the expected error category.

### Interpretation

The normal build is a baseline without ASan diagnostics; it is not a guarantee that the invalid access will crash or be harmless. The ASan build should be evaluated by its diagnostic report. A test that does not reproduce reliably must be marked inconclusive and investigated.

## 4. Experiment B — Runtime overhead

### Conditions

- **Baseline:** normal build.
- **Instrumented:** ASan build.

Use the same source, input size, compiler version, optimization level, and machine for each pair. The existing Makefile uses `-O2` and `-fsanitize=address -g` for the ASan target; verify that the normal and ASan targets otherwise use comparable settings. Record any differences.

### Workloads

Start with GEMM because the current Makefile already defines it. Add other PolyBench/C workloads only after confirming they build and run reliably. Select workloads that represent different computational or memory-access patterns where possible.

### Repetitions and metric

- Run each condition at least three independent times.
- Record every individual time; do not record only the average.
- Use the same timing method for both builds.
- Record input size, compiler flags, hardware, OS/kernel, and background-load conditions.

For each workload:

`Runtime Overhead (%) = ((Mean ASan Time - Mean Normal Time) / Mean Normal Time) × 100`

A positive value means the ASan build took longer. Report per-workload results before any aggregate.

## 5. Experiment C — Memory overhead

Measure one consistent metric, preferably peak resident set size (peak RSS), for normal and ASan runs. Use the same measurement tool and method for both conditions.

`Memory Overhead Ratio = Peak RSS (ASan) / Peak RSS (Normal)`

Report the metric name, unit, measurement tool/version, and whether the value is a peak or a point-in-time measurement. Do not mix RSS, virtual memory size, and allocator-requested bytes.

## 6. Extension — Workload-dependent overhead

**Research question:** Does ASan introduce different runtime overhead across different PolyBench/C workloads?

- Independent variable: workload/program.
- Dependent variables: runtime overhead and, if measured consistently, memory overhead.
- Controlled variables: machine, OS/kernel, compiler version, optimization flags, input-size policy, timing method, and number of repetitions.

Use GEMM plus two or more additional workloads if feasible. If only one workload can be run reliably, do not claim to have completed this extension; report the limitation and select a smaller feasible extension only with group agreement.

## 7. Fair-comparison requirements

- Normal and ASan binaries must use the same source version.
- Keep compiler version and optimization level consistent.
- Record all sanitizer-specific flags.
- Use identical inputs and workload parameters.
- Run on the same machine and avoid heavy background processes.
- Preserve all raw runs, including unusual results.
- Do not silently remove outliers. Investigate and explain them.
- Distinguish compile-time instrumentation overhead from runtime measurement; do not include compilation time in program runtime.

## 8. Comparison with the paper

The paper reports its headline performance and memory figures using SPEC CPU2006. Our current repository uses PolyBench/C. The comparison should therefore be qualitative and metric-aligned unless the group reproduces the original benchmark and a sufficiently comparable setup.

A valid report should say:
- what was reproduced;
- what was changed;
- why the change was necessary;
- how the change limits direct comparison.

## 9. Risks and fallback decisions

- If Docker cannot build, record the failure and use a documented local environment only if the group agrees; do not mix environments without labeling them.
- If a workload fails to compile, record the error and replace it only after checking that the replacement serves the same experimental purpose.
- If memory measurement is unreliable, report runtime as the primary metric and clearly mark memory results as unavailable rather than inventing values.
- If the full workload set cannot be completed, prioritize a smaller, repeatable set over many incomplete runs.
