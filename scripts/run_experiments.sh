#!/bin/bash

echo "Starting V2 experiments..."

mkdir -p results
OUTPUT_CSV="results/raw_data.csv"
ENV_LOG="results/environment_info.txt"
ERR_LOG="results/compile_errors.log"

echo "=== System Environment ===" > $ENV_LOG
uname -a >> $ENV_LOG
lscpu | grep "Model name" >> $ENV_LOG || true
echo "=== Compiler Version ===" >> $ENV_LOG
clang --version >> $ENV_LOG || true
echo "Environment logged to $ENV_LOG"

echo "Benchmark,Version,Run1_Time(s),Run1_RSS(KB),Run2_Time(s),Run2_RSS(KB),Run3_Time(s),Run3_RSS(KB),AvgTime(s),AvgRSS(KB)" > $OUTPUT_CSV

echo "Recompiling..."
make clean > /dev/null 2>&1
make > /dev/null 2> $ERR_LOG

run_and_measure() {
    local bin_name=$1
    local bench_name=$2
    local version_name=$3

    if [ ! -f "./$bin_name" ]; then
        echo "Error: $bin_name missing. See $ERR_LOG"
        return
    fi

    echo "Running $bin_name..."

    /usr/bin/time -f "%e,%M" ./$bin_name > /dev/null 2> time1.txt
    /usr/bin/time -f "%e,%M" ./$bin_name > /dev/null 2> time2.txt
    /usr/bin/time -f "%e,%M" ./$bin_name > /dev/null 2> time3.txt

    local t1=$(cut -d',' -f1 time1.txt)
    local m1=$(cut -d',' -f2 time1.txt)
    local t2=$(cut -d',' -f1 time2.txt)
    local m2=$(cut -d',' -f2 time2.txt)
    local t3=$(cut -d',' -f1 time3.txt)
    local m3=$(cut -d',' -f2 time3.txt)

    local total_t=$(echo "$t1 + $t2 + $t3" | bc)
    local avg_t=$(echo "scale=4; $total_t / 3" | bc)

    local total_m=$(echo "$m1 + $m2 + $m3" | bc)
    local avg_m=$(echo "$total_m / 3" | bc)

    rm time1.txt time2.txt time3.txt

    echo "-> Time: $avg_t s | Peak RSS: $avg_m KB"
    echo "----------------------------------------"

    echo "$bench_name,$version_name,$t1,$m1,$t2,$m2,$t3,$m3,$avg_t,$avg_m" >> $OUTPUT_CSV
}

WORKLOADS=("gemm")

for wl in "${WORKLOADS[@]}"; do
    run_and_measure "${wl}_normal" "$wl" "Normal"
    run_and_measure "${wl}_asan" "$wl" "ASan"
done

echo "Done. Check results folder."
