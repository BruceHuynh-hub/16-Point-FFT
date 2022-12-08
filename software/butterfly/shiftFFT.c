#include "shiftFFT.h"

void shiftFFT(signed in, signed out_re[], signed out_im[]) {
  static signed a[16] = {0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0};
  signed b_re[16], b_im[16], c_re[16], c_im[16];
  register signed i;
  
  // Shift the FIFO
  for (i = 15; i > 0; i--) {
  	a[i] = a[i-1];
  }
  a[0] = in;
  
  // Compute 4 butterfly units
  for (i = 0; i < 4; i++) {
  	b_re[i+0] = a[i+0] + a[i+4] + a[i+8] + a[i+12];
  	b_re[i+1] = a[i+0]          - a[i+8];
  	b_re[i+2] = a[i+0] - a[i+4] + a[i+8] - a[i+12];
  	b_re[i+3] = a[i+0]          - a[i+8];
  	b_im[i+0] = 0;
  	b_im[i+1] =        - a[i+4]          + a[i+12];
  	b_im[i+2] = 0;
  	b_im[i+3] =          a[i+4]          - a[i+12];
  }
  
	c_re[ 0] = b_re[ 0]; c_im[ 0] = b_im[ 0];
	c_re[ 1] = b_re[ 1]; c_im[ 1] = b_im[ 1];
	c_re[ 2] = b_re[ 2]; c_im[ 2] = b_im[ 2];
	c_re[ 3] = b_re[ 3]; c_im[ 3] = b_im[ 3];
	c_re[ 4] = b_re[ 4]; c_im[ 4] = b_im[ 4];
	c_re[ 5] = b_re[ 5]; c_im[ 5] = b_im[ 5];
	c_re[ 6] = b_re[ 6]; c_im[ 6] = b_im[ 6];
	c_re[ 7] = b_re[ 7]; c_im[ 7] = b_im[ 7];
	c_re[ 8] = b_re[ 8]; c_im[ 8] = b_im[ 8];
	c_re[ 9] = b_re[ 9]; c_im[ 9] = b_im[ 9];
	c_re[10] = b_re[10]; c_im[10] = b_im[10];
	c_re[11] = b_re[11]; c_im[11] = b_im[11];
	c_re[12] = b_re[12]; c_im[12] = b_im[12];
	c_re[13] = b_re[13]; c_im[13] = b_im[13];
	c_re[14] = b_re[14]; c_im[14] = b_im[14];
	c_re[15] = b_re[15]; c_im[15] = b_im[15];
	
  
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
