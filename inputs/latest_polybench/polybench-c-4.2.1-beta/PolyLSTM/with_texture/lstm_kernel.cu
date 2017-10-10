#include <stdio.h> 
#define DEVICECODE true 
#include "lstm_kernel.hu"
__global__ void kernel0(float c_F[400][2850], float *o, float s_F[ns <= 0 ? 399 : 400][2850], int ns, int c0)
{
    int b0 = blockIdx.x;
    int t0 = threadIdx.x;

    for (int c1 = 32 * b0; c1 < ns; c1 += 1048576)
      if (ns >= t0 + c1 + 1)
        s_F[c0 - 1][t0 + c1] = (c_F[c0 - 1][t0 + c1] * o[t0 + c1]);
}
__global__ void kernel1(float *i, int ns, int c0)
{
    int b0 = blockIdx.x;
    int t0 = threadIdx.x;

    if (32 * b0 + t0 <= 2849)
      i[32 * b0 + t0] = 0.0;
}
__global__ void kernel2(float *f, int ns, int c0)
{
    int b0 = blockIdx.x;
    int t0 = threadIdx.x;

    if (32 * b0 + t0 <= 2849)
      f[32 * b0 + t0] = 0.0;
}
__global__ void kernel3(float *g, int ns, int c0)
{
    int b0 = blockIdx.x;
    int t0 = threadIdx.x;

    if (32 * b0 + t0 <= 2849)
      g[32 * b0 + t0] = 0.0;
}
__global__ void kernel4(float *o, int ns, int c0)
{
    int b0 = blockIdx.x;
    int t0 = threadIdx.x;

    if (32 * b0 + t0 <= 2849)
      o[32 * b0 + t0] = 0.0;
}
__global__ void kernel5(float *f, int ns, int c0)
{
    int b0 = blockIdx.x;
    int t0 = threadIdx.x;

    #define ppcg_min(x,y)    ({ __typeof__(x) _x = (x); __typeof__(y) _y = (y); _x < _y ? _x : _y; })
    for (int c2 = 0; c2 <= 2999; c2 += 32) {
      if (32 * b0 + t0 <= 2849)
        for (int c4 = 0; c4 <= ppcg_min(31, -c2 + 2999); c4 += 1)
          f[32 * b0 + t0] += ((tex2D(texRef_U_f, c2 + c4, 32 * b0 + t0)) * (tex2D(texRef_inp_F, c2 + c4, c0)));
      __syncthreads();
    }
}
__global__ void kernel6(float *g, int ns, int c0)
{
    int b0 = blockIdx.x;
    int t0 = threadIdx.x;

    #define ppcg_min(x,y)    ({ __typeof__(x) _x = (x); __typeof__(y) _y = (y); _x < _y ? _x : _y; })
    for (int c2 = 0; c2 <= 2999; c2 += 32) {
      if (32 * b0 + t0 <= 2849)
        for (int c4 = 0; c4 <= ppcg_min(31, -c2 + 2999); c4 += 1)
          g[32 * b0 + t0] += ((tex2D(texRef_U_g, c2 + c4, 32 * b0 + t0)) * (tex2D(texRef_inp_F, c2 + c4, c0)));
      __syncthreads();
    }
}
__global__ void kernel7(float *i, int ns, int c0)
{
    int b0 = blockIdx.x;
    int t0 = threadIdx.x;

    #define ppcg_min(x,y)    ({ __typeof__(x) _x = (x); __typeof__(y) _y = (y); _x < _y ? _x : _y; })
    for (int c2 = 0; c2 <= 2999; c2 += 32) {
      if (32 * b0 + t0 <= 2849)
        for (int c4 = 0; c4 <= ppcg_min(31, -c2 + 2999); c4 += 1)
          i[32 * b0 + t0] += ((tex2D(texRef_U_i, c2 + c4, 32 * b0 + t0)) * (tex2D(texRef_inp_F, c2 + c4, c0)));
      __syncthreads();
    }
}
__global__ void kernel8(float *f, float s_F[ns <= 0 ? 399 : 400][2850], int ns, int c0)
{
    int b0 = blockIdx.x;
    int t0 = threadIdx.x;

    #define ppcg_min(x,y)    ({ __typeof__(x) _x = (x); __typeof__(y) _y = (y); _x < _y ? _x : _y; })
    for (int c2 = 0; c2 <= 2849; c2 += 32) {
      if (32 * b0 + t0 <= 2849)
        for (int c4 = 0; c4 <= ppcg_min(31, -c2 + 2849); c4 += 1)
          f[32 * b0 + t0] += ((tex2D(texRef_W_f, c2 + c4, 32 * b0 + t0)) * s_F[c0 - 1][c2 + c4]);
      __syncthreads();
    }
}
__global__ void kernel9(float *o, int ns, int c0)
{
    int b0 = blockIdx.x;
    int t0 = threadIdx.x;

    #define ppcg_min(x,y)    ({ __typeof__(x) _x = (x); __typeof__(y) _y = (y); _x < _y ? _x : _y; })
    for (int c2 = 0; c2 <= 2999; c2 += 32) {
      if (32 * b0 + t0 <= 2849)
        for (int c4 = 0; c4 <= ppcg_min(31, -c2 + 2999); c4 += 1)
          o[32 * b0 + t0] += ((tex2D(texRef_U_o, c2 + c4, 32 * b0 + t0)) * (tex2D(texRef_inp_F, c2 + c4, c0)));
      __syncthreads();
    }
}
__global__ void kernel10(float *i, float s_F[ns <= 0 ? 399 : 400][2850], int ns, int c0)
{
    int b0 = blockIdx.x;
    int t0 = threadIdx.x;

    #define ppcg_min(x,y)    ({ __typeof__(x) _x = (x); __typeof__(y) _y = (y); _x < _y ? _x : _y; })
    for (int c2 = 0; c2 <= 2849; c2 += 32) {
      if (32 * b0 + t0 <= 2849)
        for (int c4 = 0; c4 <= ppcg_min(31, -c2 + 2849); c4 += 1)
          i[32 * b0 + t0] += ((tex2D(texRef_W_i, c2 + c4, 32 * b0 + t0)) * s_F[c0 - 1][c2 + c4]);
      __syncthreads();
    }
}
__global__ void kernel11(float *g, float s_F[ns <= 0 ? 399 : 400][2850], int ns, int c0)
{
    int b0 = blockIdx.x;
    int t0 = threadIdx.x;

    #define ppcg_min(x,y)    ({ __typeof__(x) _x = (x); __typeof__(y) _y = (y); _x < _y ? _x : _y; })
    for (int c2 = 0; c2 <= 2849; c2 += 32) {
      if (32 * b0 + t0 <= 2849)
        for (int c4 = 0; c4 <= ppcg_min(31, -c2 + 2849); c4 += 1)
          g[32 * b0 + t0] += ((tex2D(texRef_W_g, c2 + c4, 32 * b0 + t0)) * s_F[c0 - 1][c2 + c4]);
      __syncthreads();
    }
}
__global__ void kernel12(float *o, float s_F[ns <= 0 ? 399 : 400][2850], int ns, int c0)
{
    int b0 = blockIdx.x;
    int t0 = threadIdx.x;

    #define ppcg_min(x,y)    ({ __typeof__(x) _x = (x); __typeof__(y) _y = (y); _x < _y ? _x : _y; })
    for (int c2 = 0; c2 <= 2849; c2 += 32) {
      if (32 * b0 + t0 <= 2849)
        for (int c4 = 0; c4 <= ppcg_min(31, -c2 + 2849); c4 += 1)
          o[32 * b0 + t0] += ((tex2D(texRef_W_o, c2 + c4, 32 * b0 + t0)) * s_F[c0 - 1][c2 + c4]);
      __syncthreads();
    }
}
__global__ void kernel13(float c_F[400][2850], float *f, float *g, float *i, int ns, int c0)
{
    int b0 = blockIdx.x;
    int t0 = threadIdx.x;

    for (int c1 = 32 * b0; c1 < ns; c1 += 1048576)
      if (ns >= t0 + c1 + 1)
        c_F[c0][t0 + c1] = ((c_F[c0 - 1][t0 + c1] * f[t0 + c1]) + (g[t0 + c1] * i[t0 + c1]));
}