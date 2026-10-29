# CS340 EX2: AddressSanitizer (ASan) Replication

This repository contains the replication framework for the AddressSanitizer paper. The project utilizes the PolyBench/C benchmark suite to evaluate the performance overhead and detection capabilities of ASan.

## 1. Repository Structure
- `test_asan.c`: Basic verification code demonstrating heap buffer overflow interception.
- `download_benchmarks.sh`: Automated script to fetch and extract the PolyBench/C dataset.
- `Makefile`: Automated build engine for compiling baseline and ASan-instrumented binaries.
- `.gitignore`: Rules to prevent binary and dataset pollution in the repository.
- `Dockerfile`: Configuration for isolated containerized execution.

## 2. Local Environment Execution (WSL / Ubuntu)

### Step 2.1: Dataset Preparation
Fetch the PolyBench/C benchmark suite:
```bash
chmod +x download_benchmarks.sh
./download_benchmarks.sh
