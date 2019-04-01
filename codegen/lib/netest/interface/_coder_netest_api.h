/*
 * File: _coder_netest_api.h
 *
 * MATLAB Coder version            : 3.1
 * C/C++ source code generated on  : 24-Apr-2017 16:05:07
 */

#ifndef _CODER_NETEST_API_H
#define _CODER_NETEST_API_H

/* Include Files */
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"
#include <stddef.h>
#include <stdlib.h>
#include "_coder_netest_api.h"

/* Variable Declarations */
extern emlrtCTX emlrtRootTLSGlobal;
extern emlrtContext emlrtContextGlobal;

/* Function Declarations */
extern void netest(real_T x1[15], real_T b_y1[9]);
extern void netest_api(const mxArray *prhs[1], const mxArray *plhs[1]);
extern void netest_atexit(void);
extern void netest_initialize(void);
extern void netest_terminate(void);
extern void netest_xil_terminate(void);

#endif

/*
 * File trailer for _coder_netest_api.h
 *
 * [EOF]
 */
