#include <stdio.h>

int *get_ptr() {
    int local_var = 42;
    return &local_var; 
}

int main() {
    int *ptr = get_ptr();
    printf("Value: %d\n", *ptr);
    return 0;
}
