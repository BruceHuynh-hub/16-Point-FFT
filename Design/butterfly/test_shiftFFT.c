#include <stdio.h>

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
  
  const signed short W1_re = 0b0111011001000001;
  const signed short W1_im = 0b1100111100000100;
  const signed short W2_re = 0b0101101010000010;
  const signed short W2_im = 0b1010010101111110;
  const signed short W3_re = 0b0011000011111011;
  const signed short W3_im = 0b1000100110111110;
  const signed short W6_re = 0b1010010101111110;
  const signed short W6_im = 0b1010010101111110;
  const signed short W9_re = 0b1000100110111110;
  const signed short W9_im = 0b0011000011111011;
  
	c_re[ 0] = b_re[ 0]; c_im[ 0] = b_im[ 0];
	c_re[ 1] = b_re[ 1]; c_im[ 1] = b_im[ 1];
	printf("C1:%x\n", c_re[1]);
	c_re[ 2] = b_re[ 2]; c_im[ 2] = b_im[ 2];
	c_re[ 3] = b_re[ 3]; c_im[ 3] = b_im[ 3];
	
	c_re[ 4] = b_re[ 4]; c_im[ 4] = b_im[ 4];
	c_re[ 5] = (W1_re * b_re[ 5] - W1_im * b_im[ 5]) >> 15;
	printf("C5:%x\n", c_re[5]);
	c_im[ 5] = (W1_re * b_im[ 5] + W1_im * b_re[ 5]) >> 15;
	c_re[ 6] = (W2_re * b_re[ 6] - W2_im * b_im[ 6]) >> 15;
	c_im[ 6] = (W2_re * b_im[ 6] + W2_im * b_re[ 6]) >> 15;
	c_re[ 7] = (W3_re * b_re[ 7] - W3_im * b_im[ 7]) >> 15;
	c_im[ 7] = (W3_re * b_im[ 7] + W3_im * b_re[ 7]) >> 15;
	
	c_re[ 8] = b_re[ 8]; c_im[ 8] = b_im[ 8];
	c_re[ 9] = (W2_re * b_re[ 9] - W2_im * b_im[ 9]) >> 15;
	printf("C9:%x\n", c_re[9]);
	c_im[ 9] = (W2_re * b_im[ 9] + W2_im * b_re[ 9]) >> 15;
	c_re[10] = -1 * b_im[10];
	c_im[10] = -1 * b_re[10];
	c_re[11] = (W6_re * b_re[11] - W6_im * b_im[11]) >> 15;
	c_im[11] = (W6_re * b_im[11] + W6_im * b_re[11]) >> 15;
	
	c_re[12] = b_re[12]; c_im[12] = b_im[12];
	c_re[13] = (W3_re * b_re[13] - W3_im * b_im[13]) >> 15;
	printf("CD:%x\n", c_re[13]);
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

int main() {
	signed short fft_re[16] = {0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0};
  signed short fft_im[16] = {0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0};
  
	printf("\n--- Test shiftFFT ---\n\n");
	
	int i = 0;
	for (i = 0; i < 16; i++) {
		shiftFFT((16-i)*(16-i)*10, fft_re, fft_im);
	}
	
	for (i = 0; i < 16; i++) {
		printf("%2d: re = %6d, im = %6d\n", i, fft_re[i], fft_im[i]);
	}
	
	return 0;
}
