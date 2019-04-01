/*
 * File: _coder_netest2_api.h
 *
 * MATLAB Coder version            : 3.1
 * C/C++ source code generated on  : 24-Apr-2017 17:06:25
 */

#ifndef _CODER_NETEST2_API_H
#define _CODER_NETEST2_API_H

/* Include Files */
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"
#include <stddef.h>
#include <stdlib.h>
#include "_coder_netest2_api.h"

/* Variable Declarations */
extern emlrtCTX emlrtRootTLSGlobal;
extern emlrtContext emlrtContextGlobal;

/* Function Declarations */
extern void netest2(real_T x1[12], real_T b_y1[6]);
extern void netest2_api(const mxArray *prhs[1], const mxArray *plhs[1]);
extern void netest2_atexit(void);
extern void netest2_initialize(void);
extern void netest2_terminate(void);
extern void netest2_xil_terminate(void);

#endif

/*
 * File trailer for _coder_netest2_api.h
 *
 * [EOF]
 */
