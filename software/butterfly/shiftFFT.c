#include "shiftFFT.h"

void shiftFFT(signed short in, signed short out_re[], signed short out_im[]) {
  static signed short a[16] = {0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0};
  signed short b_re[16], b_im[16], c_re[16], c_im[16];
  register signed i;
  
  // Shift the FIFO
  for (i = 15; i > 0; i--) {
  	a[i] = a[i-1];
  }
  a[0] = in;
  
  // Compute 4 butterfly units
  for (i = 0; i < 4; i++) {
  	b_re[4*i+0] = a[i+0] + a[i+4] + a[i+8] + a[i+12];
  	b_re[4*i+1] = a[i+0]          - a[i+8];
  	b_re[4*i+2] = a[i+0] - a[i+4] + a[i+8] - a[i+12];
  	b_re[4*i+3] = a[i+0]          - a[i+8];
  	b_im[4*i+0] = 0;
  	b_im[4*i+1] =        - a[i+4]          + a[i+12];
  	b_im[4*i+2] = 0;
  	b_im[4*i+3] =          a[i+4]          - a[i+12];
  }
  
  const signed long W1_re =  30274;
  const signed long W1_im = -12540;
  const signed long W2_re =  23170;
  const signed long W2_im = -23170;
  const signed long W3_re =  12540;
  const signed long W3_im = -30274;
  const signed long W6_re = -23170;
  const signed long W6_im = -23170;
  const signed long W9_re = -30274;
  const signed long W9_im =  12540;
  
	c_re[ 0] = b_re[ 0]; c_im[ 0] = b_im[ 0];
	c_re[ 1] = b_re[ 1]; c_im[ 1] = b_im[ 1];
	c_re[ 2] = b_re[ 2]; c_im[ 2] = b_im[ 2];
	c_re[ 3] = b_re[ 3]; c_im[ 3] = b_im[ 3];
	
	c_re[ 4] = b_re[ 4]; c_im[ 4] = b_im[ 4];
	c_re[ 5] = (W1_re * b_re[ 5] - W1_im * b_im[ 5]) >> 15;
	c_im[ 5] = (W1_re * b_im[ 5] + W1_im * b_re[ 5]) >> 15;
	c_re[ 6] = (W2_re * b_re[ 6] - W2_im * b_im[ 6]) >> 15;
	c_im[ 6] = (W2_re * b_im[ 6] + W2_im * b_re[ 6]) >> 15;
	c_re[ 7] = (W3_re * b_re[ 7] - W3_im * b_im[ 7]) >> 15;
	c_im[ 7] = (W3_re * b_im[ 7] + W3_im * b_re[ 7]) >> 15;
	
	c_re[ 8] = b_re[ 8]; c_im[ 8] = b_im[ 8];
	c_re[ 9] = (W2_re * b_re[ 9] - W2_im * b_im[ 9]) >> 15;
	c_im[ 9] = (W2_re * b_im[ 9] + W2_im * b_re[ 9]) >> 15;
	c_re[10] = -1 * b_im[10];
	c_im[10] = -1 * b_re[10];
	c_re[11] = (W6_re * b_re[11] - W6_im * b_im[11]) >> 15;
	c_im[11] = (W6_re * b_im[11] + W6_im * b_re[11]) >> 15;
	
	c_re[12] = b_re[12]; c_im[12] = b_im[12];
	c_re[13] = (W3_re * b_re[13] - W3_im * b_im[13]) >> 15;
	c_im[13] = (W3_re * b_im[13] + W3_im * b_re[13]) >> 15;
	c_re[14] = (W6_re * b_re[14] - W6_im * b_im[14]) >> 15;
	c_im[14] = (W6_re * b_im[14] + W6_im * b_re[14]) >> 15;
	c_re[15] = (W9_re * b_re[15] - W9_im * b_im[15]) >> 15;
	c_im[15] = (W9_re * b_im[15] + W9_im * b_re[15]) >> 15;
	
  
  // Compute 4 butterfly units
  for (i = 0; i < 4; i++) {
  	out_re[i+0]  = c_re[i+0] + c_re[i+4] + c_re[i+8] + c_re[i+12];
  	out_im[i+0]  = c_im[i+0] + c_im[i+4] + c_im[i+8] + c_im[i+12];
  	
  	out_re[i+4]  = c_re[i+0] + c_im[i+4] - c_re[i+8] - c_im[i+12];
  	out_im[i+4]  = c_im[i+0] - c_re[i+4] - c_im[i+8] + c_re[i+12];
  	
  	out_re[i+8]  = c_re[i+0] - c_re[i+4] + c_re[i+8] - c_re[i+12];
  	out_im[i+8]  = c_im[i+0] - c_im[i+4] + c_im[i+8] - c_im[i+12];
  	
  	out_re[i+12] = c_re[i+0] - c_im[i+4] - c_re[i+8] + c_im[i+12];
  	out_im[i+12] = c_im[i+0] + c_re[i+4] - c_im[i+8] - c_re[i+12];
  }
}
