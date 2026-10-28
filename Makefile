CC = clang
CFLAGS = -O2 -I./polybench/utilities -I./polybench/linear-algebra/blas/gemm
POLYBENCH_UTILS = ./polybench/utilities/polybench.c

ASAN_FLAGS = -fsanitize=address -g

TARGET_NORMAL = gemm_normal
TARGET_ASAN = gemm_asan

SRC = ./polybench/linear-algebra/blas/gemm/gemm.c

all: $(TARGET_NORMAL) $(TARGET_ASAN)

$(TARGET_NORMAL): $(SRC)
	$(CC) $(CFLAGS) $(POLYBENCH_UTILS) $(SRC) -o $(TARGET_NORMAL)

$(TARGET_ASAN): $(SRC)
	$(CC) $(CFLAGS) $(ASAN_FLAGS) $(POLYBENCH_UTILS) $(SRC) -o $(TARGET_ASAN)

clean:
	rm -f $(TARGET_NORMAL) $(TARGET_ASAN)
