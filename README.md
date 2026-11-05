# CS340 EX2: AddressSanitizer (ASan) Replication

This repository contains the replication framework for the AddressSanitizer paper. The project utilizes the PolyBench/C benchmark suite to evaluate the performance overhead and detection capabilities of ASan.

##  Team Members & Roles

- **Member A :** xuhuaze 1240031225
- **Member B :** pengrui 1240020556
- **Member C :** weiyuchen 1240023961
- **Member D :** yuankexin 1240024103
##  Repository Structure
- `Makefile`: Automated build engine for compiling baseline and ASan-instrumented binaries.
- `.gitignore`: Rules to prevent binary and dataset pollution in the repository.
- `Dockerfile`: Configuration for isolated containerized execution.
- `docs/`: Project documentation, paper analysis, extracted claims, and environment logs.
- `scripts/`: Automation scripts for downloading benchmarks and running experiments.
- `tests/`: C source files containing intentional memory vulnerabilities for ASan testing.

## Local Environment Execution (WSL / Ubuntu)
To ensure strict reproducibility, this project is built and tested on:
- **OS:** Ubuntu (WSL2 recommended for Windows users)
- **Compiler:** Clang 21.1.8 (with native `-fsanitize=address` support)
- **Build System:** GNU Make 4.4.1
- **Benchmark Suite:** PolyBench/C

**Install core dependencies (Ubuntu/Debian):**
```bash
sudo apt-get update
sudo apt-get install build-essential clang make wget unzip time bc -y
