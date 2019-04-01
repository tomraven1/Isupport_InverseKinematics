/*
 * File: _coder_netest_api.c
 *
 * MATLAB Coder version            : 3.1
 * C/C++ source code generated on  : 24-Apr-2017 16:05:07
 */

/* Include Files */
#include "tmwtypes.h"
#include "_coder_netest_api.h"
#include "_coder_netest_mex.h"

/* Variable Definitions */
emlrtCTX emlrtRootTLSGlobal = NULL;
emlrtContext emlrtContextGlobal = { true, false, 131434U, NULL, "netest", NULL,
  false, { 2045744189U, 2170104910U, 2743257031U, 4284093946U }, NULL };

/* Function Declarations */
static real_T (*b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId))[15];
static real_T (*c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
  const emlrtMsgIdentifier *msgId))[15];
static real_T (*emlrt_marshallIn(const emlrtStack *sp, const mxArray *x1, const
  char_T *identifier))[15];
static const mxArray *emlrt_marshallOut(const real_T u[9]);

/* Function Definitions */

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *u
 *                const emlrtMsgIdentifier *parentId
 * Return Type  : real_T (*)[15]
 */
static real_T (*b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId))[15]
{
  real_T (*y)[15];
  y = c_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}
/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *src
 *                const emlrtMsgIdentifier *msgId
 * Return Type  : real_T (*)[15]
 */
  static real_T (*c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
  const emlrtMsgIdentifier *msgId))[15]
{
  real_T (*ret)[15];
  static const int32_T dims[1] = { 15 };

  emlrtCheckBuiltInR2012b(sp, msgId, src, "double", false, 1U, dims);
  ret = (real_T (*)[15])mxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *x1
 *                const char_T *identifier
 * Return Type  : real_T (*)[15]
 */
static real_T (*emlrt_marshallIn(const emlrtStack *sp, const mxArray *x1, const
  char_T *identifier))[15]
{
  real_T (*y)[15];
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  y = b_emlrt_marshallIn(sp, emlrtAlias(x1), &thisId);
  emlrtDestroyArray(&x1);
  return y;
}
/*
 * Arguments    : const real_T u[9]
 * Return Type  : const mxArray *
 */
  static const mxArray *emlrt_marshallOut(const real_T u[9])
{
  const mxArray *y;
  const mxArray *m0;
  static const int32_T iv0[1] = { 0 };

  static const int32_T iv1[1] = { 9 };

  y = NULL;
  m0 = emlrtCreateNumericArray(1, iv0, mxDOUBLE_CLASS, mxREAL);
  mxSetData((mxArray *)m0, (void *)u);
  emlrtSetDimensions((mxArray *)m0, iv1, 1);
  emlrtAssign(&y, m0);
  return y;
}

/*
 * Arguments    : const mxArray *prhs[1]
 *                const mxArray *plhs[1]
 * Return Type  : void
 */
void netest_api(const mxArray *prhs[1], const mxArray *plhs[1])
{
  real_T (*b_y1)[9];
  real_T (*x1)[15];
  emlrtStack st = { NULL, NULL, NULL };

  st.tls = emlrtRootTLSGlobal;
  b_y1 = (real_T (*)[9])mxMalloc(sizeof(real_T [9]));
  prhs[0] = emlrtProtectR2012b(prhs[0], 0, false, -1);

  /* Marshall function inputs */
  x1 = emlrt_marshallIn(&st, emlrtAlias(prhs[0]), "x1");

  /* Invoke the target function */
  netest(*x1, *b_y1);

  /* Marshall function outputs */
  plhs[0] = emlrt_marshallOut(*b_y1);
}

/*
 * Arguments    : void
 * Return Type  : void
 */
void netest_atexit(void)
{
  emlrtStack st = { NULL, NULL, NULL };

  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  emlrtEnterRtStackR2012b(&st);
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
  netest_xil_terminate();
}

/*
 * Arguments    : void
 * Return Type  : void
 */
void netest_initialize(void)
{
  emlrtStack st = { NULL, NULL, NULL };

  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  emlrtClearAllocCountR2012b(&st, false, 0U, 0);
  emlrtEnterRtStackR2012b(&st);
  emlrtFirstTimeR2012b(emlrtRootTLSGlobal);
}

/*
 * Arguments    : void
 * Return Type  : void
 */
void netest_terminate(void)
{
  emlrtStack st = { NULL, NULL, NULL };

  st.tls = emlrtRootTLSGlobal;
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/*
 * File trailer for _coder_netest_api.c
 *
 * [EOF]
 */
