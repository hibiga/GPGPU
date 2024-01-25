#include <stdio.h>

_global_void mykernel(void) {

}

int main(void) {
    mykernel<<<1,1>>>>();
    printf("Hello World!\n");
    return 0;
}