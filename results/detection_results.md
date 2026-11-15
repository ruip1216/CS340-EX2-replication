# Claim 1: Detection Coverage Verification Results

## Summary Table

| Bug Type | Source File | Compiler Command | Exit Status | Result |
|---|---|---|---|---|
| Heap Buffer Overflow | `tests/test_asan.c` | `clang -fsanitize=address -g tests/test_asan.c -o test_asan_bin` | Non-zero | Detected |
| Stack Buffer Overflow | `tests/test_stack.c` | `clang -fsanitize=address -g tests/test_stack.c -o test_stack_bin` | Non-zero | Detected |
| Global Buffer Overflow | `tests/test_global.c` | `clang -fsanitize=address -g tests/test_global.c -o test_global_bin` | Non-zero | Detected |
| Use-After-Free (UAF) | `tests/test_uaf.c` | `clang -fsanitize=address -g tests/test_uaf.c -o test_uaf_bin` | Non-zero | Detected |

## Diagnostic Evidence (Standard Error Logs)

### 1. Heap Buffer Overflow
- **Diagnostic:** `ERROR: AddressSanitizer: heap-buffer-overflow`
- **Observation:** Successfully identified illegal read/write outside the bounds of dynamically allocated heap memory.

### 2. Stack Buffer Overflow
- **Diagnostic:** `ERROR: AddressSanitizer: stack-buffer-overflow`
- **Observation:** Successfully caught out-of-bounds access on a stack-allocated local array.

### 3. Global Buffer Overflow
- **Diagnostic:** `ERROR: AddressSanitizer: global-buffer-overflow`
- **Observation:** Successfully intercepted out-of-bounds access on an initialized global variable.

### 4. Use-After-Free
- **Diagnostic:** `ERROR: AddressSanitizer: heap-use-after-free`
- **Observation:** Successfully detected access to a heap memory block that had already been passed to `free()`.

## Conclusion
All four representative memory error classes were successfully intercepted by the ASan build, producing the expected diagnostic category and terminating the process safely. This fully supports Claim 1 within the scope of our project tests.
