# Initial Framework Test Log
1. ASan Capability Test: `tests/test_asan.c` successfully intercepted the heap-buffer-overflow.
2. Baseline Test: `make` successfully generated `gemm_normal` and `gemm_asan` without fatal errors.
