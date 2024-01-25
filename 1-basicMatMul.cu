#include <stdio.h>
#include <cuda.h>
#include <time.h>

#include "matmul_utils.hpp"


// Cuda kernel
__global__ void dgemm(float *A, float *B, float *C,
                      int numARows, int numAColumns, int numBRows, int numBColumns) {
  int x =blockIdx.x*blockDim.x + threadIdx.x; //col
  int y =blockIdx.y*blockDim.y + threadIdx.y; //row

  
  if (x < numBColumns && y < numARows) {
    int emp_c = x + y*numBColumns;
    C[emp_c]=0; //initialise
    for(int k = 0; k < numAColumns; k++) {
        int mat1 = k + y*numAColumns;
        int mat2 = x + k*numBColumns;
        C[emp_c] += A[mat1] * B[mat2];
    }
  }
}

int main(int argc, char **argv)
{
  if(argc!=4) {printf("Usage : %s [nb of rows for A] [nb of cols for A] [nb of cols for B]\n", argv[0]);exit(2);}
  //initilize a pseudo-random number generator
  srand(time(0));

  int numARows, numAColumns,numBRows, numBColumns,numCRows, numCColumns;
  // Read given dimensions
    //atoi : convert string to integer
  numARows = atoi(argv[1]);
  numAColumns = atoi(argv[2]);
  numBColumns  = atoi(argv[3]); 
  // Compute the remaining dimensions for given ones
  numBRows = numAColumns; 
  numCRows = numARows; 
  numCColumns = numBColumns; 
  printf("Matrix multiplication dimensions: [%d;%d] = [%d;%d] x [%d;%d]\n",
         numCRows, numCColumns, numARows, numAColumns, numBRows, numBColumns);
  // host pointers
  float *host_a, *host_b, *host_c;
  // Device pointers
  float *dev_a, *dev_b, *dev_c;
  
  int size = sizeof(float);
  int size_a = numAColumns*numARows*size;
  int size_b = numBColumns*numBRows*size;
  int size_c = numCColumns*numCRows*size;

  // Allocations on host
  host_a = (float *)calloc(numARows*numAColumns, size_a);
  host_b = (float *)calloc(numBRows*numBColumns, size_b);
  host_c = (float *)calloc(numCRows*numCColumns,size_c);

  // Initialize vectors
  init(host_a,host_b,numARows, numAColumns, numBRows, numBColumns);

  // Allocations on device
  cudaMalloc((void **) &dev_a, size_a);
  cudaMalloc((void **) &dev_b, size_b);
  cudaMalloc((void **) &dev_c, size_c);

  // Copy from host to device
  cudaMemcpy(dev_a, host_a, size_a,cudaMemcpyHostToDevice);
  cudaMemcpy(dev_b, host_b, size_b,cudaMemcpyHostToDevice);

  // Invoke kernel
  dim3 DimBlock(32,32,1);
  dim3 DimGrid((numARows-1)/DimBlock.x + 1, (numBColumns-1)/DimBlock.y+1, 1);

  // Initialize C device data
  cudaMemset(dev_c, 0, numARows * numBColumns * size);

  // Call the kernel
  dgemm<<<DimGrid,DimBlock>>>(dev_a, dev_b, dev_c, numARows, numAColumns, numBRows, numBColumns);

  // Copy result from device to host
  cudaMemcpy(host_c, dev_c, size_c,cudaMemcpyDeviceToHost);

  // Check result
  check(host_a,host_b,host_c,numARows, numAColumns, numBRows, numBColumns);

  // Free device memory
  cudaFree(dev_a); cudaFree(dev_b); cudaFree(dev_c);

  return 0;
}
