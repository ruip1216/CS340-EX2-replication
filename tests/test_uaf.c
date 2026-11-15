#include <stdlib.h>

int main() {
    int *array = malloc(10 * sizeof(int));
    free(array);
    return array[1];
}

