#include <iostream>
#include <cstdlib>
#include <string>

#include "img_utils.hpp"

using namespace std;

__global__ void vecRGBtoG(float *imgIn, float *imgOut, int width, int height, int channels) {
  
  int x = blockIdx.x*blockDim.x + threadIdx.x; //col
  int y = blockIdx.y*blockDim.y + threadIdx.y; //row

  if (x < width && y < height) {
    int grayOffset = y * width + x;
    int rgbOffset = grayOffset*channels;
    float r = imgIn[rgbOffset];
    float g = imgIn[rgbOffset+1];
    float b = imgIn[rgbOffset+2];
    imgOut[grayOffset] = (0.21*r + 0.71*g + 0.07*b);
  }
      
}
 
int main(int argc, char **argv)
{
  if(argc!=3) {cout<<"Program takes two image filenames as parameters"<<endl;exit(3);}
  float *imgIn, *imgOut;
  int nCols, nRows, channels;

  imgIn = read_image_asfloat(argv[1],&nCols, &nRows, &channels);
  if(channels!=3){cout<<"Input image is not a colored image"<<endl;exit(4);}
  imgOut = (float *)calloc(nCols*nRows, sizeof(float));

  int size_in = sizeof(float)*nCols*nRows*channels;
  int size_out = size_in/channels;

  float *d_imgIn, *d_imgOut;
  cudaMalloc((void **) &d_imgIn, size_in);
  cudaMalloc((void **) &d_imgOut, size_out);

  cudaMemcpy(d_imgIn, imgIn, size_in,cudaMemcpyHostToDevice);

  dim3 DimGrid((nRows-1)/16 + 1, (nCols-1)/16+1, 1);
  dim3 DimBlock(16, 16, 1);
  //dim3 DimGrid((nRows-1)/32+ 1, (nCols-1)/32+1, 1);
  //dim3 DimBlock(32, 32, 1);
  
  vecRGBtoG<<<DimGrid,DimBlock>>>(d_imgIn, d_imgOut, nCols, nRows, channels);
  cudaMemcpy(imgOut, d_imgOut, size_out, cudaMemcpyDeviceToHost);

  write_image_fromfloat(argv[2], imgOut, nCols, nRows, 1);

  cudaFree(d_imgIn); cudaFree(d_imgOut); 


  return 0;
}
