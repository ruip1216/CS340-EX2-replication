# Paper Analysis

## 1. Bibliographic information

- **Title:** AddressSanitizer: A Fast Address Sanity Checker
- **Authors:** Konstantin Serebryany, Derek Bruening, Alexander Potapenko, Dmitry Vyukov
- **Venue:** USENIX Annual Technical Conference (USENIX ATC 2012)
- **Pages:** 309–318
- **Paper:** https://www.usenix.org/system/files/conference/atc12/atc12-final39.pdf
- **Tool documentation:** https://clang.llvm.org/docs/AddressSanitizer.html

## 2. Research motivation

Memory-access bugs in C and C++ programs include out-of-bounds accesses and accesses to memory after it has been freed. These bugs can cause crashes, incorrect results, or security vulnerabilities.

The paper identifies a practical tension among memory-error detection tools: some tools detect many bug types but have high runtime overhead, while others are faster but detect fewer types of bugs. The authors propose AddressSanitizer (ASan) as a tool intended to combine broad detection coverage with comparatively low overhead.

## 3. What AddressSanitizer does

The paper describes ASan as having two main parts:

1. **Compiler instrumentation:** instrumented code checks shadow-memory state when application memory is accessed. The instrumentation and poisoned redzones help detect out-of-bounds accesses for stack and global objects.
2. **Runtime library:** the runtime manages shadow memory and replaces allocation functions such as `malloc` and `free`. It adds poisoned redzones around heap allocations and delays reuse of freed heap regions, helping detect heap out-of-bounds accesses and use-after-free.

A central mechanism is **shadow memory**: metadata describing whether application-memory locations are addressable. The paper presents a compact shadow-memory mapping and a specialized allocator designed around this representation.

## 4. Main contributions stated by the paper

The paper's contributions include:

- Showing that shadow memory can provide broad memory-error detection with lower overhead than conventional expectations.
- Presenting a compact shadow-state encoding, with a mapping as compact as 128:1.
- Describing a specialized memory allocator designed for the shadow-memory encoding.
- Evaluating a publicly available tool for detecting memory bugs.

## 5. Error classes addressed

The paper states that ASan finds:

- Out-of-bounds accesses to heap objects.
- Out-of-bounds accesses to stack objects.
- Out-of-bounds accesses to global objects.
- Use-after-free bugs involving freed heap memory.

These categories motivate the group's small detection-verification programs. The programs are project-level tests of representative cases, not a claim that the group has reproduced every detection experiment in the paper.

## 6. Evaluation reported in the paper

The paper's performance evaluation uses C and C++ benchmarks from **SPEC CPU2006**. The reported setup includes 64-bit mode on an HP Z600 machine with two quad-core Intel Xeon E5620 CPUs and 24 GB RAM. The authors compare instrumented binaries with regular LLVM-compiled binaries using `clang -O2`.

Key reported results:

- Average runtime slowdown on SPEC CPU2006: **73%**.
- Average memory-usage increase: **3.37×**.
- Average binary-size increase: **2.5×**.
- When only writes are instrumented, the reported average slowdown is **26%**.
- The largest slowdowns reported were for `perlbench` and `xalancbmk`, at 2.60× and 2.67× respectively. The paper associates these with malloc-intensive workloads and many small memory accesses.

The paper also reports three bugs found in SPEC CPU2006: a stack and a global buffer overflow in `h264ref`, and a use-after-realloc in `perlbench`.

## 7. Real-world deployment evidence

The paper reports that ASan had been used to test Chromium and detected more than 300 previously unknown bugs during the first ten months described by the authors. The paper lists multiple bug categories, with heap-use-after-free and heap-buffer-overflow prominent.

This deployment result supports the practical usefulness of ASan, but it is not something the group can reproduce merely by running the current PolyBench/C repository.

## 8. Controls and limitations discussed by the paper

The paper discusses runtime/resource controls including:

- Stack-unwinding depth, which affects speed and diagnostic stack-trace detail.
- Quarantine size, which affects the ability to detect heap-use-after-free.
- Heap redzone size, which affects the ability to detect some heap buffer overflows and resource usage.

The paper also discusses limitations and trade-offs. Therefore, the project should avoid claiming that ASan detects every possible memory bug in every program.

## 9. Relevance to our project

The group's current repository contains a `test_asan.c` heap-overflow example, a PolyBench/C download script, a Makefile with normal and ASan GEMM build targets, and a Dockerfile.

These files provide a starting point for:

- Verifying that ASan reports a representative memory error.
- Comparing normal and ASan-instrumented executions.
- Measuring runtime and memory usage on selected PolyBench/C workloads.

However, PolyBench/C is not the SPEC CPU2006 suite used for the paper's headline performance results. Our evaluation must therefore be described as a modified or partial reproduction. We should compare measurement concepts and individual results carefully, not claim a direct reproduction of the paper's 73% aggregate slowdown.

## 10. Questions for the group

1. Can the current Dockerfile and Makefile build and run both GEMM variants successfully?
2. Which PolyBench/C workloads can be built and run reliably in the available time?
3. What consistent tool will be used to measure peak memory usage?
4. Will the group implement four representative detection tests (heap, stack, global, use-after-free)?
5. Which paper claims can be tested directly, and which can only be discussed using the paper's reported evidence?
