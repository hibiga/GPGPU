#include <stdio.h>
#include <cuda.h>
#include <time.h>

#include "matmul_utils.hpp"


// Cuda kernel
__global__ void MatMulTiled(float *A, float *B, float *C, int width) {

  const int TILE_SIZE = 32;

  __shared__ float As[TILE_SIZE][TILE_SIZE];
  __shared__ float Bs[TILE_SIZE][TILE_SIZE];
  
  int bx = blockIdx.x, by = blockIdx.y, tx = threadIdx.x, ty = threadIdx.y;
      
  int y = by * TILE_SIZE + ty; // row = ligne verticale
  int x = bx * TILE_SIZE + tx; // col = colonne horizontale
  float cij=0.0;

  for (int k = 0; k < (TILE_SIZE+width-1)/TILE_SIZE; k++) {
    if (k*TILE_SIZE + tx < width && y < width)
        As[ty][tx] = A[y * width + k * TILE_SIZE + tx];
    else 
    	As[ty][tx] = 0.0;
    if (k*TILE_SIZE + ty < width && x < width)
        Bs[ty][tx] = B[(k * TILE_SIZE + ty) * width + x];
    else
    	Bs[ty][tx] = 0.0;
    __syncthreads();

    for (int n = 0; n < TILE_SIZE; n++)
        cij += As[ty][n] * Bs[n][tx];

    __syncthreads();
    }
    
  if (y < width && x < width)
  	//C[((by*blockDim.y + ty)*width)+(bx*blockDim.x)+tx] = cij;
  	C[y * width + x] = cij;
}

int main(int argc, char **argv)
{
  if(argc!=4) {printf("Usage : %s [nb of rows for A] [nb of cols for A] [nb of cols for B]\n", argv[0]);exit(2);}
  //initilize a pseudo-random number generator
  srand(time(0));

  // Read given dimensions
  int width;
  width = atoi(argv[1]); 
  //tile_size = atoi(argv[1]); 
   
  printf("Matrix multiplication dimensions: [%d;%d] = [%d;%d] x [%d;%d]\n",
         width, width, width, width, width, width);
  // host pointers
  float *host_a, *host_b, *host_c;
  // Device pointers
  float *dev_a, *dev_b, *dev_c;

  int size = width*width*sizeof(float);
  int size_matrix = width*width;
  
  // Allocations on host
  host_a = (float *)calloc(size_matrix, sizeof(float));
  host_b = (float *)calloc(size_matrix, sizeof(float));
  host_c = (float *)calloc(size_matrix, sizeof(float));

  // Initialize vectors
  init(host_a,host_b,width, width, width, width);

  // Allocations on device
  cudaMalloc((void **) &dev_a, size);
  cudaMalloc((void **) &dev_b, size);
  cudaMalloc((void **) &dev_c, size);

  // Copy from host to device
  cudaMemcpy(dev_a, host_a, size, cudaMemcpyHostToDevice);
  cudaMemcpy(dev_b, host_b, size, cudaMemcpyHostToDevice);

  // Invoke kernel
  dim3 DimBlock(32,32);
  //dim3 DimGrid((width-1)/DimBlock.x + 1, (width-1)/DimBlock.x+1);
  dim3 DimGrid((width + DimBlock.x - 1) / DimBlock.x, (width+DimBlock.y-1)/DimBlock.y);

  // Initialize C device data
  cudaMemset(dev_c, 0, size);

  // Call the kernel
  MatMulTiled<<<DimGrid,DimBlock>>>(dev_a, dev_b, dev_c, width);

  // Copy result from device to host
  cudaMemcpy(host_c, dev_c, size, cudaMemcpyDeviceToHost);

  // Check result
  check(host_a,host_b,host_c,width, width, width, width);

  // Free device memory
  cudaFree(dev_a); cudaFree(dev_b); cudaFree(dev_c);

  return 0;
}

