int a[10];

int main() {
    a[12] = 1; // 越界了，但恰好落在了 b 数组的内存里
    return 0;
}
