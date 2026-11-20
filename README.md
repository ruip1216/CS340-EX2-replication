# CS340 EX2: AddressSanitizer (ASan) Replication

This repository contains the replication framework for the AddressSanitizer (ASan) paper. Using the PolyBench/C benchmark suite and custom C vulnerability test cases, this project evaluates both the memory error detection capabilities (Claim 1) and the execution time / memory overhead (Claim 2) of ASan.

## Team Members & Roles

- **Member A:** xuhuaze (1240031225)
- **Member B:** pengrui (1240020556)
- **Member C:** weiyuchen (1240023961)
- **Member D:** yuankexin (1240024103)

## Repository Structure

- `Makefile`: Automated build engine for compiling baseline and ASan-instrumented binaries.
- `Dockerfile`: Configuration for isolated, reproducible containerized execution.
- `.gitignore`: Rules to prevent compiled binaries and temporary datasets from polluting the repository.
- `docs/`: Complete project documentation, including paper analysis, extracted claims, experimental design, and final analysis reports.
- `scripts/`: Automation scripts (`download_benchmarks.sh`, `run_experiments.sh`) for fetching PolyBench/C and running performance benchmarks.
- `tests/`: C source files (`test_asan.c`, `test_stack.c`, `test_global.c`, `test_uaf.c`) containing intentional memory vulnerabilities for Claim 1 verification.
- `results/`: Collected experimental outputs, including ASan detection logs (`.log`), `detection_results.md`, benchmark data (`raw_data.csv`), statistical summaries, and Python analysis/plotting scripts (`analysis.py`, `figures/plot_results.py`).
- `results_from_docker/`: Standardized and extended benchmark datasets (`raw_data.csv`, `raw_data_extended.csv`) and compile logs generated inside the Docker container for cross-environment verification.

## Environment Requirements

To ensure strict reproducibility, this project is built and tested on:
- **OS:** Ubuntu (WSL2 recommended for Windows users)
- **Compiler:** Clang 21.1.8 (with native `-fsanitize=address` support)
- **Build System:** GNU Make 4.4.1
- **Benchmark Suite:** PolyBench/C
- **Analysis:** Python 3 (with `pandas`, `numpy`, `matplotlib`)

### Install Core Dependencies (Ubuntu / WSL2)

```bash
sudo apt-get update
sudo apt-get install build-essential clang make wget unzip time bc -y
