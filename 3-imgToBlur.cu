#include <iostream>
#include <cstdlib>
#include <string>

#include "img_utils.hpp"

using namespace std;

__global__ void vecblurKernel(float* imgIn, float* imgOut, int width, int height, int channels) {
  int x =blockIdx.x*blockDim.x + threadIdx.x; 
  int y =blockIdx.y*blockDim.y + threadIdx.y; 
  if (y < height && x < width) {
    float sum_r = 0;
    float sum_g = 0;
    float sum_b = 0;
    float sum_grey = 0;
    int total = 0;
    int grey_o = y * width + x;
    int rgb_o = channels * grey_o;
    if (y < 3 || x < 3 || y > height - 4 || x > width - 4) {
      for (int blurCol = -3; blurCol < 4; blurCol++) {
        int inCol = x + blurCol;
        if(inCol > -1 && inCol < width) {
          total += 1;
          if(channels == 3){
            int idx = channels * (y * width + inCol) ;
            sum_r += imgIn[idx ];
            sum_g += imgIn[idx + 1];
            sum_b += imgIn[idx + 2];
          } else{
            int idx = y * width + inCol;
            sum_grey += imgIn[idx];
          }
        }
      }
      if(channels == 3){
        imgOut[rgb_o ] = sum_r/total;
        imgOut[rgb_o + 1] = sum_g/total;
        imgOut[rgb_o + 2] = sum_b/total;
      } else{
        imgOut[grey_o ] = sum_grey/total;
      }
    } else{
      for (int blurRow = -3; blurRow < 4; blurRow++) {
        for (int blurCol = -3; blurCol < 4; blurCol++) {
          int inRow = y + blurRow;
	  int inCol = x + blurCol;
	   if(inRow > -3 || inRow < height || inCol > -3 || inCol < width) {
	    total += 1;
	    int grey_v = inRow * width + inCol;
	    if(channels == 3){
	      int rgb_v = channels*grey_v;
	      sum_r += imgIn[rgb_v ]; 
	      sum_g += imgIn[rgb_v + 1];
	      sum_b += imgIn[rgb_v + 2]; 
	    } else{
	      sum_grey += imgIn[grey_v ];
	    }
          }
        } 
      }
      if(channels == 3){
        imgOut[rgb_o] = sum_r/total;
        imgOut[rgb_o + 1] = sum_g/total;
        imgOut[rgb_o + 2] = sum_b/total;
      } else{
        imgOut[grey_o ] = sum_grey/total;
      }
    }
  }
}

#define stream_nb 4

int main(int argc, char **argv)
{
 if(argc!=3) {cout<<"Program takes two image filenames as parameters"<<endl;exit(3);}
 float *imgIn, *imgOut;
 int nCols, nRows, channels;

 imgIn = read_image_asfloat(argv[1],&nCols, &nRows, &channels);
 if(channels!=3){cout<<"Input image is not a colored image"<<endl;exit(4);}
 imgOut = (float *)calloc(nCols*nRows*channels, sizeof(float));

// int stream_nb = nCols*nRows*channels;

 int size = nCols*nRows*channels; 
 int stream_size = size/stream_nb;
 
// int col = nCols/stream_nb;
 int row = nRows/stream_nb ;

 cudaStream_t* stream;
 stream = (cudaStream_t*)malloc(stream_size);
// cudaStream_t stream[stream_nb];
 
 cout<<"Size stream "<<stream_size<<endl;

// memoire partage
// cudaHostAlloc((void **) &imgIn, size*sizeof(float), cudaHostAllocDefault);
 cudaHostAlloc((void **) &imgOut, size*sizeof(float), cudaHostAllocDefault);

 // float *d_imgIn, *d_imgOut;
 float *d_imgIn[stream_nb];
 float *d_imgOut[stream_nb];
 
// stream
 for (int i=0; i<stream_nb; i++){
    cudaStreamCreate(&(stream[i]));
    cudaMalloc((void **) &d_imgIn[i], (stream_size) * sizeof(float));
    cudaMalloc((void **) &d_imgOut[i], (stream_size) * sizeof(float));
  }

  for (int i = 0; i < stream_nb; i++){
    int start = i * stream_size;
    cudaMemcpyAsync(d_imgIn[i], imgIn + start, stream_size * sizeof(float), cudaMemcpyHostToDevice, stream[i]);
  } 

 dim3 DimBlock(16, 16);
 dim3 DimGrid(ceil(nCols/DimBlock.x), ceil(nRows/DimBlock.y));
 
 for (int i = 0; i < stream_nb; i++){
    vecblurKernel<<<DimGrid, DimBlock, 0, stream[i]>>>(d_imgIn[i], d_imgOut[i], nCols, row, channels);
  } 
  
  auto err = cudaGetLastError();
  cout<<"Done"<<endl;
  
 for (int i = 0; i < stream_nb; i++) {
    int start = i * stream_size;
    cudaMemcpyAsync(imgOut + start, d_imgOut[i], stream_size * sizeof(float), cudaMemcpyDeviceToHost, stream[i]);
  }
 
 cudaDeviceSynchronize();
 write_image_fromfloat(argv[2], imgOut, nCols, nRows, channels);
 
 free(imgIn); cudaFreeHost(imgOut);

 for (int k=0; k<stream_nb; k++){
    cudaFree(d_imgIn[k]); cudaFree(d_imgOut[k]); 
 }
 free(stream);
 
 return 0;
}
