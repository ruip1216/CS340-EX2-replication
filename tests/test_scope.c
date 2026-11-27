#include <stdio.h>

int main() {
    int *ptr = NULL;
    {
        int local_var = 42;
        ptr = &local_var; 
    } 
    printf("Value: %d\n", *ptr); 
    return 0;
}
