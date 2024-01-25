#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "matmul_utils.hpp"

int main( int argc, char **argv){
  float * restrict a, * restrict b, * restrict c;

  if(argc!=4) {printf("Usage : %s [nb of rows for A] [nb of cols for A] [nb of cols for B]\n", argv[0]);exit(2);}
  srand(time(0));

  int numARows, numAColumns,numBRows, numBColumns,numCRows, numCColumns;
  numARows = atoi(argv[1]);
  numAColumns = atoi(argv[2]);
  numBColumns  = atoi(argv[3]); 
  numBRows = numAColumns; 
  numCRows = numARows; 
  numCColumns = numBColumns; 

  printf("Matrix multiplication dimensions: [%d;%d] = [%d;%d] x [%d;%d]\n",
         numCRows, numCColumns, numARows, numAColumns, numBRows, numBColumns);

  a = (float *)calloc(numARows*numAColumns, sizeof(float));
  b = (float *)calloc(numBRows*numBColumns, sizeof(float));
  c = (float *)calloc(numCRows*numCColumns, sizeof(float));

  init(a, b, numARows, numAColumns, numBRows, numBColumns);

  // Call function
  #pragma acc data copy (a[0:numARows*numAColumns], b[0:numBRows*numBColumns], c[0:numCRows*numCColumns])
  {
  #pragma acc parallel
  {
  #pragma acc loop
    for (int x=0; x<numBColumns; x++){
  #pragma acc loop
        for (int y=0; y<numARows; y++){
            float emp_c = 0;
  #pragma acc loop reduction(+:emp_c)
            for (int k=0; k<numAColumns; k++){
                emp_c += a[k+numAColumns*y] * b[x+numBColumns*k];
            }
        c[x+numBColumns*y] = emp_c;
        }
    }
  }
  }

  // Check result
  check(a, b, c, numARows, numAColumns, numBRows, numBColumns);

  // Free host memory
  free(a); free(b); free(c);

  return 0;
}