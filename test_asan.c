#include <stdio.h>
#include <stdlib.h>

int main() {
    char *array = (char*)malloc(10);
    if (array == NULL) return 1;
    
    array[100] = 'x'; 
    
    free(array);
    return 0;
}
