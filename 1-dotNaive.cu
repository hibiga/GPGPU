#include <stdio.h>
#include <cuda.h>

// Initialize host vectors
float init(float *a, float *b, int n) {
  srand(0);
  float dot = 0.0;
  for (int i=0; i < n; ++i) {
    a[i] = rand()/((float) RAND_MAX);
    b[i] = rand()/((float) RAND_MAX);
    dot += a[i]*b[i];
  }
  return dot;
}

#define BLOCK_SIZE 1024
// Cuda kernel
__global__ void dotNaive(float *a, float *b, float *res, int n) {
  // @TODO@ : Complete here kernel code
	__shared__ float partialSum[2*BLOCK_SIZE];
	unsigned int t = threadIdx.x;
	unsigned int start = 2*blockIdx.x*blockDim.x;
	
	// creation memoire partagée
	if (start + t < n)
		partialSum[t] = a[start + t] * b[start + t];
	else 
		partialSum[t] = 0.0;
	
	if (start + blockDim.x+t < n)
		partialSum[blockDim.x+t] = a[start + blockDim.x+t] * b[start + blockDim.x+t];
  	else
  		partialSum[blockDim.x+t] = 0.0;
  		
  	// calcul
	for (unsigned int stride = blockDim.x; stride > 0; stride /= 2) {
		__syncthreads();
		if (t < stride)
			partialSum[t] += partialSum[t+stride];
	}
	res[blockIdx.x] = partialSum[0];

}
    	
int main(int argc, char **argv)
{
  if(argc!=2) {printf("Give the vector size as first parameter\n");exit(2);}
  int n = atoi(argv[1]);
  // condition qu'on peut enlever pour version global 
  // if(n<2*BLOCK_SIZE) {printf("Parameter value is too small\n");exit(2);}
  printf("Vector size is %d\n",n);
  
  // @TODO@ : Complete block number
  // int block_nb =  1; // (start with 1 in the first version)
  int block_nb = (n - 1)/(2*BLOCK_SIZE)+1;

  // host pointers
  float *host_a, *host_b, *host_res;
  // Device pointers
  float *dev_a, *dev_b, *dev_res;

  // Allocations on host
  host_a = (float *)calloc(n, sizeof(float));
  host_b = (float *)calloc(n, sizeof(float));
  host_res = (float *)calloc(block_nb, sizeof(float));

  // Initialize vectors
  float dot_true = init(host_a,host_b,n);

  // Allocations on device
  cudaMalloc((void **) &dev_a, n*sizeof(float));
  cudaMalloc((void **) &dev_b, n*sizeof(float));
  cudaMalloc((void **) &dev_res, block_nb*sizeof(float));

  // Copy from host to device
  cudaMemcpy(dev_a, host_a, n*sizeof(float), cudaMemcpyHostToDevice);
  cudaMemcpy(dev_b, host_b, n*sizeof(float), cudaMemcpyHostToDevice);

  // Invoke kernel
  dotNaive<<<block_nb,BLOCK_SIZE>>>(dev_a, dev_b, dev_res, n);

  // Copy result from device to host
  cudaMemcpy(host_res, dev_res, block_nb*sizeof(float), cudaMemcpyDeviceToHost);

  // Final host reduction : cpu
  for(int i=1; i<block_nb; i++)
    host_res[0] += host_res[i];

  // Check result
  if(fabs(host_res[0]-dot_true)/dot_true<1e-4)
    printf("Result Ok : \n");
  else
    printf("Wrong result (%g)\n",fabs(host_res[0]-dot_true)/dot_true);

  // Free device memory
  cudaFree(dev_a); cudaFree(dev_b); cudaFree(dev_res);
  // Free host memory
  free(host_a); free(host_b); free(host_res);
  return 0;
}
