import csv
import statistics
from pathlib import Path

input_file = Path("results_from_docker/raw_data_extended.csv")
summary_file = Path("results/statistical_summary.csv")
overhead_file = Path("results/overhead_summary.csv")

results = {}
with input_file.open("r", newline="") as file:
    reader = csv.DictReader(file)

    for row in reader:
        benchmark = row["Benchmark"]
        version = row["Version"]

        runtime_values = [
            float(row["Run1_Time(s)"]),
            float(row["Run2_Time(s)"]),
            float(row["Run3_Time(s)"])
        ]

        memory_values = [
            float(row["Run1_RSS(KB)"]),
            float(row["Run2_RSS(KB)"]),
            float(row["Run3_RSS(KB)"])
        ]

        results[(benchmark, version)] = {
            "runtime_mean": statistics.mean(runtime_values),
            "runtime_sd": statistics.stdev(runtime_values),
            "memory_mean": statistics.mean(memory_values),
            "memory_sd": statistics.stdev(memory_values)
        }

with summary_file.open("w", newline="") as file:
    writer = csv.writer(file)

    writer.writerow([
        "Benchmark",
        "Version",
        "Runtime_Mean_s",
        "Runtime_SD_s",
        "Memory_Mean_KB",
        "Memory_SD_KB"
    ])

    for (benchmark, version), data in results.items():
        writer.writerow([
            benchmark,
            version,
            round(data["runtime_mean"], 4),
            round(data["runtime_sd"], 4),
            round(data["memory_mean"], 2),
            round(data["memory_sd"], 2)
        ])

with overhead_file.open("w", newline="") as file:
    writer = csv.writer(file)

    writer.writerow([
        "Benchmark",
        "Runtime_Overhead_pct",
        "Memory_Overhead_pct",
        "Memory_Ratio"
    ])

    for benchmark in sorted(set(key[0] for key in results)):
        normal = results[(benchmark, "Normal")]
        asan = results[(benchmark, "ASan")]

        runtime_overhead = (
            (asan["runtime_mean"] - normal["runtime_mean"])
            / normal["runtime_mean"] * 100
        )

        memory_overhead = (
            (asan["memory_mean"] - normal["memory_mean"])
            / normal["memory_mean"] * 100
        )

        memory_ratio = asan["memory_mean"] / normal["memory_mean"]

        writer.writerow([
            benchmark,
            round(runtime_overhead, 2),
            round(memory_overhead, 2),
            round(memory_ratio, 3)
        ])

print("Statistical Summary")
print("-" * 60)

for (benchmark, version), data in results.items():
    print(f"\n{benchmark} - {version}")
    print(
        f"Runtime: {data['runtime_mean']:.4f} "
        f"+/- {data['runtime_sd']:.4f} seconds"
    )
    print(
        f"Memory: {data['memory_mean']:.2f} "
        f"+/- {data['memory_sd']:.2f} KB"
    )

print("\nOverhead Summary")
print("-" * 60)

for benchmark in sorted(set(key[0] for key in results)):
    normal = results[(benchmark, "Normal")]
    asan = results[(benchmark, "ASan")]

    runtime_overhead = (
        (asan["runtime_mean"] - normal["runtime_mean"])
        / normal["runtime_mean"] * 100
    )
    memory_overhead = (
        (asan["memory_mean"] - normal["memory_mean"])
        / normal["memory_mean"] * 100
    )

    print(
        f"{benchmark}: Runtime Overhead = {runtime_overhead:.2f}%, "
        f"Memory Overhead = {memory_overhead:.2f}%"
    )

print("\nAnalysis completed!")
print(f"Statistical summary saved to: {summary_file}")
print(f"Overhead summary saved to: {overhead_file}")
