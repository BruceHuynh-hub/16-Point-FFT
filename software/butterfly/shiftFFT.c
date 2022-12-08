#include "shiftFFT.h"

void shiftFFT(signed in, signed out_re[], signed out_im[]) {
  static signed a[16] = {0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0};
  signed b_re[16], b_im[16];
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
  
  for (i = 0; i < 16; i++) {
  	out_re[i] = b_re[i];
  	out_im[i] = b_im[i];
  }
  
  // Compute 4 butterfly units
  for (i = 0; i < 4; i++) {
  	out_re[i+0] = c_re[i+0] + c_re[i+4] + c_re[i+8] + c_re[i+12];
  	out_im[i+0] = c_im[i+0] + c_im[i+4] + c_im[i+8] + c_im[i+12];
  	
  	out_re[i+4] = c_re[i+0]          - c_re[i+8];
  	out_im[i+4] = c_im[i+0] - c_re[i+4]          + c_re[i+12];
  	
  	out_re[i+8] = c_re[i+0] - c_re[i+4] + c_re[i+8] - c_re[i+12];
  	out_im[i+8] = c_im[i+0];
  	
  	out_re[i+12] = c_re[i+0]          - c_re[i+8];
  	out_im[i+12] = c_im[i+0] + c_re[i+4]          - c_re[i+12];
  }
}
