# Experimental Environment Specification

This document records the hardware and software configurations used to replicate the AddressSanitizer (ASan) experiments.

## 1. Local Execution Environment (WSL2 / Ubuntu)

| Component | Specification |
| :--- | :--- |
| **CPU** | 12th Gen Intel(R) Core(TM) i7-12800HX |
| **Architecture** | x86_64 (`x86_64-pc-linux-gnu`) |
| **Memory (RAM)** | 7.6 GiB (WSL2 allocated) + 2.0 GiB Swap |
| **Operating System** | Ubuntu (WSL2 on Windows) |
| **Kernel Version** | `6.18.33.2-microsoft-standard-WSL2` (#1 SMP PREEMPT_DYNAMIC) |
| **Compiler** | Ubuntu clang version 21.1.8 (`6ubuntu1`, `-fsanitize=address`) |
| **Thread Model** | POSIX |
| **Build System** | GNU Make 4.4.1 |
| **Benchmark Suite** | PolyBench/C |
| **Measurement Tools** | GNU `time` (`/usr/bin/time -v`), `bc` |

## 2. Containerized Environment (Docker)

To verify cross-environment reproducibility, benchmark runs were also executed inside an isolated Docker container defined by the root `Dockerfile`.
- **Base Image:** Ubuntu (configured in `Dockerfile`)
- **Logged Metadata:** Archived in `results_from_docker/environment_info.txt` and `results_from_docker/environment_info_extended.txt`.

## 3. Reproducibility Notes

- All performance measurements (Normal vs. ASan) were conducted on the same machine under identical compiler optimization flags to minimize environmental variance.
- Raw environment snapshots are automatically captured by `scripts/run_experiments.sh` and saved to `results/environment_info.txt`.
