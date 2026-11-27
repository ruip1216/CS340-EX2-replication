#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv) {
    if (argc < 2) return 1;
    FILE *f = fopen(argv[1], "rb");
    if (!f) return 1;

    char buf[10];
    size_t len = fread(buf, 1, 30, f);
    
    if (len > 0) {
        printf("Read %zu bytes: %s\n", len, buf);
    }
    fclose(f);
    return 0;
}
