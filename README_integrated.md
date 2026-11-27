# CS340 EX2: AddressSanitizer (ASan) Replication

This repository contains the replication and extension framework for the USENIX ATC 2012 paper: ***AddressSanitizer: A Fast Address Sanity Checker*** (Serebryany et al.). Using custom C vulnerability test cases and the PolyBench/C benchmark suite (`gemm`, `cholesky`, `mvt`), this project evaluates:

1. **Claim 1 (Detection Capability):** Effectiveness in detecting Heap, Stack, and Global Buffer Overflows as well as Use-After-Free errors, along with boundary cases.
2. **Claim 2 (Performance & Memory Overhead):** Execution time slowdown and Peak RSS memory overhead introduced by `-fsanitize=address`.
3. **Extension (Workload-Dependent Overhead):** Sensitivity of ASan runtime and memory overhead across distinct PolyBench/C computational kernels.

## Team Members & Roles

- **Member A:** xuhuaze (1240031225) — Paper Analysis, Claims Extraction & Verification
- **Member B:** pengrui (1240020556) — Environment Setup, Automation Scripts, Docker & Reproducibility
- **Member C:** weiyuchen (1240023961) — Memory Error Testing & Benchmark Execution
- **Member D:** yuankexin (1240024103) — Statistical Analysis, Visualization & Discrepancy Analysis

## Repository Structure

- `Makefile`: Automated build rules for compiling baseline (`*_normal`) and ASan-instrumented (`*_asan`) executables.
- `Dockerfile`: Pinned container specification (`ubuntu:24.04` + `clang-18`) for isolated, clean-environment reproducibility.
- `.gitignore`: Excludes compiled binaries, downloaded benchmark sources, and temporary OS files.
- `docs/`: Complete project documentation, including paper analysis, extracted claims, claim verification, experimental design, environment setup (`environment.md`), and paper-vs-ours deviations (`deviations.md`).
- `scripts/`: Automation scripts (`download_benchmarks.sh`, `run_experiments.sh`) for fetching PolyBench/C and executing repeated performance measurements.
- `tests/`: Intentional C memory bug test cases (`test_asan.c`, `test_stack.c`, `test_global.c`, `test_uaf.c`) and boundary/edge-case tests (`sptest_dfs.c`, `sptest_loop.c`, `wrong_case.c`).
- `results/`: Collected experimental outputs, including ASan detection logs (`.log`), `detection_results.md`, WSL2 benchmark data (`raw_data.csv`), statistical summaries (`statistical_summary.csv`, `overhead_summary.csv`), `analysis.py`, and generated plots under `results/figures/`.
- `results_from_docker/`: Cross-environment validation datasets (`raw_data.csv`, `raw_data_extended.csv`), environment snapshots, and compile logs generated inside Docker.

## Environment Requirements

| Environment | OS / Base Image | Compiler | Build & Measurement Tools |
| :--- | :--- | :--- | :--- |
| **Local (WSL2)** | Ubuntu on WSL2 (Intel i7-12800HX) | Clang 21.1.8 | GNU Make 4.4.1, GNU `time`, `bc`, Python 3 (`pandas`, `numpy`, `matplotlib`) |
| **Docker (Pinned)** | `ubuntu:24.04` | `clang-18` (aliased to `clang`) | `build-essential`, `wget`, `unzip`, `time`, `bc` |

---

## Quick Start & Reproducibility Guide

### Option A: Docker (Recommended for Clean Environment)

```bash
# 1. Build the pinned Docker image (~1-2 min)
docker build -t asan-replication .

# 2. Launch an interactive container
docker run -it --rm asan-replication /bin/bash
```

### Option B: Local Ubuntu / WSL2

```bash
# 1. Install core dependencies
sudo apt-get update
sudo apt-get install -y build-essential clang make wget unzip time bc

# 2. Ensure scripts are executable
chmod +x scripts/*.sh
```

---

## Running the Experiments

Execute all commands below from the repository root (inside either Docker or local Ubuntu/WSL2):

### 1. Fetch PolyBench/C & Compile Benchmarks

```bash
./scripts/download_benchmarks.sh
make
```

- **Expected Output:** Downloads PolyBench/C and compiles paired baseline (`*_normal`) and ASan (`*_asan`) binaries with identical compiler optimization flags.
- **Estimated Runtime:** ~15–30 seconds (depends on network speed).

### 2. Claim 1: Memory Error Detection Tests

```bash
mkdir -p results

clang -fsanitize=address -g tests/test_asan.c   -o test_heap   && ./test_heap   2>&1 | tee results/heap_overflow.log   || true
clang -fsanitize=address -g tests/test_stack.c  -o test_stack  && ./test_stack  2>&1 | tee results/stack_overflow.log  || true
clang -fsanitize=address -g tests/test_global.c -o test_global && ./test_global 2>&1 | tee results/global_overflow.log || true
clang -fsanitize=address -g tests/test_uaf.c    -o test_uaf    && ./test_uaf    2>&1 | tee results/uaf.log             || true
```

- **Expected Output:** Each binary terminates immediately (fail-fast) with an `ERROR: AddressSanitizer:` report identifying `heap-buffer-overflow`, `stack-buffer-overflow`, `global-buffer-overflow`, and `heap-use-after-free`, respectively.
- **Data Saved To:** `results/*.log` (summarized in `results/detection_results.md`).
- **Estimated Runtime:** < 5 seconds total.

### 3. Claim 2 & Extension: Performance & Memory Overhead

```bash
./scripts/run_experiments.sh
```

- **Expected Output:** Runs each PolyBench/C kernel (`gemm`, `cholesky`, `mvt`) for at least 3 independent trials under both Normal and ASan builds, recording wall-clock execution time (seconds) and Peak RSS (KB) via `/usr/bin/time -v`.
- **Expected Trends:** Normalized execution time overhead is workload-dependent—approximately **1.55x** (`mvt`), **1.97x** (`gemm`), and **3.13x** (`cholesky`)—while Peak RSS increases stably by **~18%–26%**.
- **Data Saved To:** `results/raw_data.csv` (WSL2) and `results_from_docker/raw_data_extended.csv` (Docker).
- **Estimated Runtime:** ~2–5 minutes for the full multi-workload suite (`gemm` alone takes < 15 seconds).

### 4. Statistical Analysis & Visualization

```bash
python3 results/analysis.py
python3 results/figures/plot_results.py
```

- **Expected Output:** Computes Mean ± Standard Deviation and relative overhead ratios, updating CSV summaries in `results/` and generating `execution_time_overhead.png` and `memory_overhead.png` under `results/figures/`.
- **Estimated Runtime:** < 5 seconds.

---

## References & Third-Party Sources

- **Original Paper:** Konstantin Serebryany, Derek Bruening, Alexander Potapenko, and Dmitry Vyukov. *"AddressSanitizer: A Fast Address Sanity Checker."* USENIX Annual Technical Conference (USENIX ATC 2012).
- **Benchmark Suite:** PolyBench/C (open-source polyhedral benchmark suite), retrieved via `scripts/download_benchmarks.sh` to substitute the proprietary SPEC CPU2006 suite (see `docs/deviations.md` for full justification).


---

## Supplementary Research Context

This section adds research context and interpretation notes to the original project guide. It does not replace the build instructions, experiment commands, or file descriptions above.

### Research Questions

The experiments are organized around three questions:

| ID | Research question | Evaluation focus |
| :--- | :--- | :--- |
| **C1 – Detection Capability** | Can ASan detect the selected memory errors? | Heap buffer overflow, stack buffer overflow, global buffer overflow, and use-after-free test cases. |
| **C2 – Performance Overhead** | How does ASan affect execution time? | Comparison of Normal and ASan builds for GEMM, Cholesky, and MVT. |
| **C3 – Memory Overhead** | How does ASan affect memory usage? | Comparison of the memory measurements recorded for Normal and ASan builds. The available CSV files label these values as RSS. |

The four vulnerability test cases are used to examine detection capability. The PolyBench/C kernels are used for performance and memory measurements. These are separate parts of the evaluation and should be interpreted separately.

### How ASan Detects Memory Errors

The ASan build is enabled through compiler instrumentation. In the recorded WSL2 build configuration, the command-line options include:

```bash
-fsanitize=address -g
```

The main mechanisms relevant to this project are:

- **Compiler instrumentation:** the compiler adds checks around relevant memory accesses. At runtime, these checks can detect accesses to memory that ASan has marked as invalid.
- **Shadow memory:** ASan maintains metadata that describes whether application-memory addresses are accessible. The runtime checks this metadata when instrumented code accesses memory.
- **Redzones:** ASan places protected regions around selected memory objects and marks those regions as inaccessible. An out-of-bounds access that reaches a redzone can therefore be detected.

The `-g` option generates debugging information. It helps ASan produce reports that identify the source location associated with a detected error.

These mechanisms explain the detection approach; they are not additional experimental metrics in this project.

### Experimental Design and Measurement Notes

The study compares two build configurations:

- **Normal build:** compiled without AddressSanitizer instrumentation.
- **ASan build:** compiled with AddressSanitizer instrumentation.

For performance and memory evaluation, the selected PolyBench/C workloads are GEMM, Cholesky, and MVT. The project workflow uses the Makefile and `scripts/run_experiments.sh` to automate builds and measurements.

The available CSV structure contains individual run fields and average fields for execution time and RSS. Statistical summaries should be treated as final only after the raw records have been checked for:

1. the number of valid runs for each workload and build type;
2. correct pairing between Normal and ASan runs;
3. missing or invalid measurements; and
4. consistency between the raw values and the reported averages and standard deviations.

Do not infer a complete set of valid repeated trials solely from the presence of three run columns in a CSV file.

### Cross-Environment Validation

The project records the following GEMM timing comparison:

| Environment | Normal build | ASan build |
| :--- | ---: | ---: |
| WSL2 | 0.30 s | 0.57 s |
| Docker | 0.30 s | 0.58 s |

The close timings provide an initial indication that the GEMM result is similar in these two recorded environments. This comparison is limited to the reported GEMM measurements. By itself, it does not establish reproducibility for every workload, hardware platform, or measurement.

### Relationship to the Original Paper

The current study adapts the original paper's evaluation to the tools and workloads available to the project. The project materials identify the following differences:

| Dimension | Original-paper setup recorded in the project materials | Current study |
| :--- | :--- | :--- |
| Benchmark suite | SPEC CPU2006 | PolyBench/C (`gemm`, `cholesky`, `mvt`) |
| Hardware | HP Z600 workstation | Intel i9 and i7 machines |
| Memory metric | VmPeak | RSS, as labelled in the available CSV headers |

These differences affect how the results should be interpreted. PolyBench/C is not the same benchmark suite as SPEC CPU2006, and RSS is not the same memory metric as VmPeak. The results should therefore be presented as a replication-oriented evaluation using a modified experimental setup, not as a direct numerical reproduction of the original paper.

### Evidence Scope and Current Limitations

The repository contains source files, scripts, raw CSV data, logs, environment records, analysis outputs, and research documentation. Derived summaries and plots should remain traceable to the corresponding raw measurements.

The following details require confirmation from the original run records and the contributors who produced them before making stronger claims:

1. **CSV provenance:** the reported batch mapping (`first_i9_second_i7_extended_i9`) and the mapping of individual rows to source machines.
2. **Workload coverage:** whether all three PolyBench/C workloads were completed on both hardware platforms.
3. **Memory collection method:** the exact command and sampling method used to obtain the RSS values in the CSV files.
4. **Build configuration:** the compiler version and paired compilation flags used for every Normal/ASan build in each environment.
5. **Statistical processing:** the valid run count, Normal/ASan pairing, and consistency of the raw values with the calculated averages and standard deviations.

Until these points have been checked, conclusions that depend on them should be described as preliminary. In particular, a single cross-environment GEMM comparison should not be generalized to the full workload suite.

### Interpreting the Results

The project evaluates three related but distinct aspects of AddressSanitizer:

- **Detection:** whether the selected memory errors are reported.
- **Performance:** how much execution time changes between Normal and ASan builds.
- **Memory:** how the recorded memory-use measurements change between Normal and ASan builds.

These results should be reported separately before drawing an overall conclusion about the engineering trade-off. A claim should be treated as supported only when the relevant raw data, execution configuration, and measurement procedure are available for inspection.
