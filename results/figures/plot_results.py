import matplotlib.pyplot as plt

benchmarks = ["GEMM", "Cholesky", "MVT"]

# Experimental overhead (%)
time_overhead = [96.66, 212.81, 55.33]
memory_overhead = [25.74, 18.18, 24.07]

# Figure 1: Execution Time Overhead
plt.figure(figsize=(8, 5))
bars = plt.bar(benchmarks, time_overhead)

plt.title("Execution Time Overhead of ASan")
plt.xlabel("Benchmark")
plt.ylabel("Time Overhead (%)")
plt.bar_label(bars, fmt="%.2f%%", padding=3)
plt.ylim(0, 250)
plt.tight_layout()
plt.savefig("results/figures/execution_time_overhead.png", dpi=300)
plt.close()

# Figure 2: Memory Overhead
plt.figure(figsize=(8, 5))
bars = plt.bar(benchmarks, memory_overhead)

plt.title("Memory Overhead of ASan")
plt.xlabel("Benchmark")
plt.ylabel("Memory Overhead (%)")
plt.bar_label(bars, fmt="%.2f%%", padding=3)
plt.ylim(0, 35)
plt.tight_layout()
plt.savefig("results/figures/memory_overhead.png", dpi=300)
plt.close()

print("Both figures have been generated successfully.")
