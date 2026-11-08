# Claim–Experiment–Evidence Matrix

| Claim | Paper evidence / source | Group experiment | Metric / observation | Evidence to commit | Status |
|---|---|---|---|---|---|
| C1: ASan detects representative heap, stack, global out-of-bounds accesses and use-after-free | Paper abstract, Introduction, design discussion and conclusion | Four small C programs, one per error class; compile/run normal and ASan variants | Whether ASan produces the expected diagnostic; diagnostic category; exit status | `tests/`, compiler commands, `results/detection_results.md`, raw logs | Planned |
| C2: ASan introduces runtime overhead | Paper Section 4; SPEC CPU2006 evaluation reports 73% average slowdown | Run selected PolyBench/C workloads as normal and ASan builds using identical input/settings | Runtime per run; mean; standard deviation; overhead percentage | `results/raw_data.csv`, logs, analysis script, figures | Planned |
| C3: ASan increases memory usage | Paper Section 4 and Table 1; reports 3.37× average memory usage increase on SPEC CPU2006 | Measure peak RSS for normal and ASan builds on selected workloads | Peak RSS in a consistent unit; mean; ratio ASan/normal | `results/raw_data.csv`, measurement method, logs, figures | Planned |
| Supporting observation: ASan may affect binary size | Paper Section 4 reports 2.5× average binary-size increase | Compare executable file sizes, if feasible | Bytes or KiB; ratio | File-size records | Optional |

## Important distinction

The paper's quantitative performance and memory results were obtained using SPEC CPU2006. The group's current repository is based on PolyBench/C and includes a GEMM target. Unless the group adds the original benchmark suite and reproduces the original environment, our measurements are a **modified reproduction on different workloads**.

The detection suite is also a group-designed verification exercise. The paper describes ASan's detection categories, but our four small programs are not a recreation of the paper's Chromium deployment or all of its bug-finding evidence.

## Decision rules

- **Supported:** The experiment was valid, the required evidence was collected, and the result is consistent with the claim within the tested scope.
- **Partially supported:** Some tested cases or workloads support the claim, but others do not, or the result supports only a narrower statement.
- **Not supported:** A valid test produces evidence inconsistent with the claim within the tested scope.
- **Inconclusive:** The test did not run correctly, evidence is insufficient, or confounding factors prevent a defensible conclusion.

Do not assign a verdict based only on one failed run or an unverified environment.
