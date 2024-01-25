#include <cstdio>
#include <cstdlib>

#define cudaCheckError() {                                                                       \
        cudaError_t e=cudaGetLastError();                                                        \
        if(e!=cudaSuccess) {                                                                     \
            printf("Cuda failure %s:%d: '%s'\n",__FILE__,__LINE__,cudaGetErrorString(e));        \
            exit(EXIT_FAILURE);                                                                  \
        }                                                                                        \
    }

__global__ void kernel(int *a, int N) {
  int i=blockIdx.x*blockDim.x+threadIdx.x;

  /* 
  if (i > N) {
  printf("%d\n", i);
  }
  */
  
  if (i < N) {  //or il y a 33 blocks donc i depasse 4097 
  		//juste le premier thread du 33eme block est lu, le reste est en trop
  		//en testant i depasse N qui est égale a 4097 
  	
  	a[i]=i;
  }
  
}
//err = out of bounds 
  // donc i va trop loin par rapport a la taille du tab a[]
  // avec cuda-memcheck on voit que erreur sur le thread (63,0,0) au thread (32,0,0) 
  // dans le block (32,0,0)

int main() {
  
  int N=4097; 				//nombre d'element dans le tableau
  int threads=128;			//nombre de threads par blocks
  int blocks=(N+threads-1)/threads;	//calcul du nombre de blocks : arrondi au superieur
  int *a;

  cudaMallocManaged(&a,N*sizeof(int));
  kernel<<<blocks,threads>>>(a, N);
  cudaDeviceSynchronize();

  printf("\n   ICI   \n");
  for(int i=0;i<10;i++)
    printf("%d\n",a[i]);

  cudaFree(a);

  cudaCheckError();
  return 0;
}
