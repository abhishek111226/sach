#include <assert.h>
#include <stdio.h>
#define HOSTCODE true 
#include "3mm_kernel.hu"
/**
 * This version is stamped on May 10, 2016
 *
 * Contact:
 *   Louis-Noel Pouchet <pouchet.ohio-state.edu>
 *   Tomofumi Yuki <tomofumi.yuki.fr>
 *
 * Web address: http://polybench.sourceforge.net
 */
/* 3mm.c: this file is part of PolyBench/C */

#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <math.h>

/* Include polybench common header. */
extern "C"{
#include <polybench.h>
}
/* Include benchmark-specific header. */
#include "3mm.h"


/* Array initialization. */
static
void init_array(int ni, int nj, int nk, int nl, int nm,
		DATA_TYPE POLYBENCH_2D(A,NI,NK,ni,nk),
		DATA_TYPE POLYBENCH_2D(B,NK,NJ,nk,nj),
		DATA_TYPE POLYBENCH_2D(C,NJ,NM,nj,nm),
		DATA_TYPE POLYBENCH_2D(D,NM,NL,nm,nl))
{
  int i, j;

  for (i = 0; i < ni; i++)
    for (j = 0; j < nk; j++)
      A[i][j] = (DATA_TYPE) ((i*j+1) % ni) / (5*ni);
  for (i = 0; i < nk; i++)
    for (j = 0; j < nj; j++)
      B[i][j] = (DATA_TYPE) ((i*(j+1)+2) % nj) / (5*nj);
  for (i = 0; i < nj; i++)
    for (j = 0; j < nm; j++)
      C[i][j] = (DATA_TYPE) (i*(j+3) % nl) / (5*nl);
  for (i = 0; i < nm; i++)
    for (j = 0; j < nl; j++)
      D[i][j] = (DATA_TYPE) ((i*(j+2)+2) % nk) / (5*nk);
}


/* DCE code. Must scan the entire live-out data.
   Can be used also to check the correctness of the output. */
static
void print_array(int ni, int nl,
		 DATA_TYPE POLYBENCH_2D(G,NI,NL,ni,nl))
{
  int i, j;

  POLYBENCH_DUMP_START;
  POLYBENCH_DUMP_BEGIN("G");
  for (i = 0; i < ni; i++)
    for (j = 0; j < nl; j++) {
	if ((i * ni + j) % 20 == 0) fprintf (POLYBENCH_DUMP_TARGET, "\n");
	fprintf (POLYBENCH_DUMP_TARGET, DATA_PRINTF_MODIFIER, G[i][j]);
    }
  POLYBENCH_DUMP_END("G");
  POLYBENCH_DUMP_FINISH;
}


/* Main computational kernel. The whole function will be timed,
   including the call and return. */
static
void kernel_3mm(int ni, int nj, int nk, int nl, int nm,
		DATA_TYPE POLYBENCH_2D(E,NI,NJ,ni,nj),
		DATA_TYPE POLYBENCH_2D(A,NI,NK,ni,nk),
		DATA_TYPE POLYBENCH_2D(B,NK,NJ,nk,nj),
		DATA_TYPE POLYBENCH_2D(F,NJ,NL,nj,nl),
		DATA_TYPE POLYBENCH_2D(C,NJ,NM,nj,nm),
		DATA_TYPE POLYBENCH_2D(D,NM,NL,nm,nl),
		DATA_TYPE POLYBENCH_2D(G,NI,NL,ni,nl))
{
  int i, j, k;

  {
#define cudaCheckReturn(ret) \
  do { \
    cudaError_t cudaCheckReturn_e = (ret); \
    if (cudaCheckReturn_e != cudaSuccess) { \
      fprintf(stderr, "CUDA error: %s\n", cudaGetErrorString(cudaCheckReturn_e)); \
      fflush(stderr); \
    } \
    assert(cudaCheckReturn_e == cudaSuccess); \
  } while(0)
#define cudaCheckKernel() \
  do { \
    cudaCheckReturn(cudaGetLastError()); \
  } while(0)

    float (*dev_A)[1000];
    float (*dev_C)[1200];
    float (*dev_E)[900];
    float (*dev_F)[1100];
    float (*dev_G)[1100];
    
    cudaCheckReturn(cudaMalloc((void **) &dev_A, (800) * (1000) * sizeof(float)));
    cudaCheckReturn(cudaMalloc((void **) &dev_C, (900) * (1200) * sizeof(float)));
    cudaCheckReturn(cudaMalloc((void **) &dev_E, (800) * (900) * sizeof(float)));
    cudaCheckReturn(cudaMalloc((void **) &dev_F, (900) * (1100) * sizeof(float)));
    cudaCheckReturn(cudaMalloc((void **) &dev_G, (800) * (1100) * sizeof(float)));
    
    
    cudaArray* cuArr_B;
    cudaChannelFormatDesc channelDesc_B= cudaCreateChannelDesc<float>();
    cudaMallocArray(&cuArr_B, &channelDesc_B, 900, 1000);
    cudaMemcpyToArray(cuArr_B, 0, 0, B, (1000) * (900) * sizeof(float), cudaMemcpyHostToDevice);
    cudaBindTextureToArray(texRef_B, cuArr_B, channelDesc_B);
    
    cudaArray* cuArr_D;
    cudaChannelFormatDesc channelDesc_D= cudaCreateChannelDesc<float>();
    cudaMallocArray(&cuArr_D, &channelDesc_D, 1100, 1200);
    cudaMemcpyToArray(cuArr_D, 0, 0, D, (1200) * (1100) * sizeof(float), cudaMemcpyHostToDevice);
    cudaBindTextureToArray(texRef_D, cuArr_D, channelDesc_D);
    
    cudaCheckReturn(cudaMemcpy(dev_A, A, (800) * (1000) * sizeof(float), cudaMemcpyHostToDevice));
    cudaCheckReturn(cudaMemcpy(dev_C, C, (900) * (1200) * sizeof(float), cudaMemcpyHostToDevice));
    {
      dim3 k0_dimBlock(16, 32);
      dim3 k0_dimGrid(29, 25);
      kernel0 <<<k0_dimGrid, k0_dimBlock>>> (dev_A, dev_E);
      cudaCheckKernel();
    }
    
    {
      dim3 k1_dimBlock(16, 32);
      dim3 k1_dimGrid(35, 29);
      kernel1 <<<k1_dimGrid, k1_dimBlock>>> (dev_C, dev_F);
      cudaCheckKernel();
    }
    
    {
      dim3 k2_dimBlock(16, 32);
      dim3 k2_dimGrid(35, 25);
      kernel2 <<<k2_dimGrid, k2_dimBlock>>> (dev_E, dev_F, dev_G);
      cudaCheckKernel();
    }
    
    cudaCheckReturn(cudaMemcpy(E, dev_E, (800) * (900) * sizeof(float), cudaMemcpyDeviceToHost));
    cudaCheckReturn(cudaMemcpy(F, dev_F, (900) * (1100) * sizeof(float), cudaMemcpyDeviceToHost));
    cudaCheckReturn(cudaMemcpy(G, dev_G, (800) * (1100) * sizeof(float), cudaMemcpyDeviceToHost));
    
    cudaUnbindTexture(texRef_B);
    cudaUnbindTexture(texRef_D);
    
    cudaFreeArray(cuArr_B);
    cudaFreeArray(cuArr_D);
    cudaCheckReturn(cudaFree(dev_A));
    cudaCheckReturn(cudaFree(dev_C));
    cudaCheckReturn(cudaFree(dev_E));
    cudaCheckReturn(cudaFree(dev_F));
    cudaCheckReturn(cudaFree(dev_G));
  }

}


int main(int argc, char** argv)
{
  /* Retrieve problem size. */
  int ni = NI;
  int nj = NJ;
  int nk = NK;
  int nl = NL;
  int nm = NM;

  /* Variable declaration/allocation. */
  POLYBENCH_2D_ARRAY_DECL(E, DATA_TYPE, NI, NJ, ni, nj);
  POLYBENCH_2D_ARRAY_DECL(A, DATA_TYPE, NI, NK, ni, nk);
  POLYBENCH_2D_ARRAY_DECL(B, DATA_TYPE, NK, NJ, nk, nj);
  POLYBENCH_2D_ARRAY_DECL(F, DATA_TYPE, NJ, NL, nj, nl);
  POLYBENCH_2D_ARRAY_DECL(C, DATA_TYPE, NJ, NM, nj, nm);
  POLYBENCH_2D_ARRAY_DECL(D, DATA_TYPE, NM, NL, nm, nl);
  POLYBENCH_2D_ARRAY_DECL(G, DATA_TYPE, NI, NL, ni, nl);

  /* Initialize array(s). */
  init_array (ni, nj, nk, nl, nm,
	      POLYBENCH_ARRAY(A),
	      POLYBENCH_ARRAY(B),
	      POLYBENCH_ARRAY(C),
	      POLYBENCH_ARRAY(D));

  /* Start timer. */
  polybench_start_instruments;

  /* Run kernel. */
  kernel_3mm (ni, nj, nk, nl, nm,
	      POLYBENCH_ARRAY(E),
	      POLYBENCH_ARRAY(A),
	      POLYBENCH_ARRAY(B),
	      POLYBENCH_ARRAY(F),
	      POLYBENCH_ARRAY(C),
	      POLYBENCH_ARRAY(D),
	      POLYBENCH_ARRAY(G));

  /* Stop and print timer. */
  polybench_stop_instruments;
  polybench_print_instruments;

  /* Prevent dead-code elimination. All live-out data must be printed
     by the function call in argument. */
  polybench_prevent_dce(print_array(ni, nl,  POLYBENCH_ARRAY(G)));

  /* Be clean. */
  POLYBENCH_FREE_ARRAY(E);
  POLYBENCH_FREE_ARRAY(A);
  POLYBENCH_FREE_ARRAY(B);
  POLYBENCH_FREE_ARRAY(F);
  POLYBENCH_FREE_ARRAY(C);
  POLYBENCH_FREE_ARRAY(D);
  POLYBENCH_FREE_ARRAY(G);

  return 0;
}
