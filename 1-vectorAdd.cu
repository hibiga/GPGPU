#include <stdio.h>
#include <cuda.h>

// Initialize host vectors
void init(float *a, float *b, int n) {
  for (int i=0; i < n; ++i) {
    a[i] = i;
    b[i] = n-i;
  }
}

// Check result correctness
void check(float *c, int n) {
  int i = 0;
  while (i < n && c[i] == n) {
    ++i;
  }
  if (i == n)
    printf("Ok\n");
  else
    printf("Non ok\n");
}


// Cuda kernel
__global__ void vecAddKernel(float *a, float *b, float *c, int n) {
  //@TODO@ : complete kernel code
  int i = threadIdx.x+blockDim.x*blockIdx.x;
  if (i<n) c[i] = a[i] + b[i];
}

void vecAdd(float *host_a, float *host_b, float *host_c, int n) {
  // Device pointers
  float *dev_a, *dev_b, *dev_c;
  int size = n * sizeof(float);

  // Allocations on device
  //@TODO@ : complete here
  cudaMalloc((void **) &dev_a, size);
  cudaMalloc((void **) &dev_b, size);
  cudaMalloc((void **) &dev_c, size);

  // Copy from host to device
  //@TODO@ : complete here
  cudaMemcpy(dev_a, host_a, size,cudaMemcpyHostToDevice);
  cudaMemcpy(dev_b, host_b, size,cudaMemcpyHostToDevice);

  // Invoke kernel
  //@TODO@ : complete here
  // droit a plus de thread que de block
  /*
  //force a utiliser un seul thread par block 
  dim3 DimGrid((n-1)/256+1,1,1);
  dim3 DimBlock(1,1,1);
  */
  /*
  //force a utiliser un seul block
  dim3 DimBlock(256,1,1);
  dim3 DimGrid(1,1,1); 
  */
  // plusieurs thread par blocks et plusieurs blocks 
  dim3 DimBlock(256,1,1);
  dim3 DimGrid(1+(n-1)/DimBlock.x,1,1); 

  vecAddKernel<<<DimGrid,DimBlock>>>(dev_a, dev_b, dev_c,n);

  // Copy result from device to host
  //@TODO@ : complete here
  cudaMemcpy(host_c, dev_c, size,cudaMemcpyDeviceToHost);

    // Free device memory
  cudaFree(dev_a); cudaFree(dev_b); cudaFree(dev_c);
}

int main(int argc, char **argv)
{
  if(argc!=2) {printf("Give the vector size as first parameter\n");exit(2);}
  int n = atoi(argv[1]); 
  printf("Vector size is %d\n",n);
  // host pointers
  float *a, *b, *c;
  int size = n * sizeof(float);

  // Allocations on host
  //@TODO@ : complete here

  a = (float *)malloc(size);
  if (a==NULL) return 1;
  b = (float *)malloc(size);
  if (b==NULL) return 1;
  c = (float *)malloc(size);
  if (c==NULL) return 1;

  // Initialize vectors
  init(a,b,n);

  // Call function
  vecAdd(a,b,c,n);

  // Check result
  check(c,n);

  // Free host memory
  free(a); free(b); free(c);
  return 0;
}
