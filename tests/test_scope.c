#include <stdio.h>
#include <stdlib.h>

int main() {
    int *arr = (int *)malloc(10 * sizeof(int));
    
    if (arr[5] > 0) { 
        printf("Condition met!\n");
    } else {
        printf("Condition not met!\n");
    }
    
    free(arr);
    return 0;
}
