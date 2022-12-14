#include "omsp_system.h"
#include "omsp_uart.h"
#include "butterfly_fft.h"
#include "shiftFFT.h"
#include <stdlib.h>

char c16[]={'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'};

void puthex(unsigned k) {
  putchar(c16[((k>>12) & 0xF)]);
  putchar(c16[((k>>8 ) & 0xF)]);
  putchar(c16[((k>>4 ) & 0xF)]);
  putchar(c16[((k    ) & 0xF)]);
}

unsigned count = 0;

unsigned TimerLap() {
  unsigned lap;
  TACTL &= ~(MC1 | MC0);
  lap = TAR - count;
  count = TAR;
  TACTL |= MC1;
  return lap;
}


unsigned long long s0;
unsigned long long s1;

void prngseed() {
  s0 = 0x0001020304050607LL;
  s1 = 0x8090A0B0C0D0E0F0LL;
}

unsigned prng() {
    unsigned long long result = s0 + s1;
    s1 ^= s0;
    s0 = ((s0 << 55) | (s0 >> 9)) ^ s1 ^ (s1 << 14);
    s1 = (s1 << 36) | (s1 >> 28);
    return (result | 0x7FFF);
}

signed sig(unsigned i) {
	// DC Offset
	//return 800;
	
	// Cosine Wave
	//return (i%4 == 3) ? 1000 : (i%4 == 1) ? -1000 : 0;
	
	// Quadratic
	return 10*(16-i)*(16-i);
	
	// Other
	// return (16-i)*(i+1)*10;
}
  
int main(void) {
  unsigned i;
  unsigned long long sw_time;
  unsigned long long hw_time = 0;
  unsigned long long sw_check;
  unsigned long long hw_check = 0;
  signed short fft_re[16] = {0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0};
  signed short fft_im[16] = {0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0};
  
  WDTCTL = WDTPW | WDTHOLD;  // Disable watchdog timer
  TACTL  |= (TASSEL1 | MC1 | TACLR); // Configure timer

  uartinit();

  putchar('>');
  prngseed();
  sw_check = 0;
  sw_time = 0;
  for (i=0; i<16; i++) {
    TimerLap();
    shiftFFT(sig(i), fft_re, fft_im);
    sw_check += 3*fft_re[0] + fft_im[1] + fft_re[2] + fft_im[4] + fft_im[7];
    sw_time += TimerLap();
    putchar('*');
  }
  
  putchar('\n');
	putchar('>');
  prngseed();
  hw_check = 0;
  hw_time  = 0;
  for (i=0; i<16; i++) {
    TimerLap();
    FFT_FIFO = sig(i);
    hw_check += 3*FFT_OUT0R + FFT_OUT1I + FFT_OUT2R + FFT_OUT4I + FFT_OUT7I;
    hw_time += TimerLap();
    putchar('#');
  }
  
  putchar('\n');
  for (i=0; i<9; i++) {
  	putchar('r'); putchar(c16[i]); putchar('=');
    puthex(fft_re[i]);
    putchar(' ');
    putchar('i'); putchar(c16[i]); putchar('=');
    puthex(fft_im[i]);
    putchar('\n');
    putchar('R'); putchar(c16[i]); putchar('=');
    puthex(*(i == 4 ? &FFT_OUT4R : (&FFT_OUT0R + 2*i)));
    putchar(' ');
    putchar('I'); putchar(c16[i]); putchar('=');
    puthex(*((&FFT_OUT0I) + 2*i));
    putchar('\n');
  }
	
	putchar('\n');
  putchar('S');
  puthex(sw_check >> 48);
  puthex(sw_check >> 32);
  puthex(sw_check >> 16);
  puthex(sw_check      );
  putchar('\n');
  putchar('T');
  puthex(sw_time  >> 48);
  puthex(sw_time  >> 32);
  puthex(sw_time  >> 16);
  puthex(sw_time       );
  putchar('\n');
  putchar('H');
  puthex(hw_check >> 48);
  puthex(hw_check >> 32);
  puthex(hw_check >> 16);
  puthex(hw_check      );
  putchar('\n');
  putchar('T');
  puthex(hw_time  >> 48);
  puthex(hw_time  >> 32);
  puthex(hw_time  >> 16);
  puthex(hw_time       );
	putchar('\n');
	
	if (abs(sw_check - hw_check) < 64) {
		putchar('P');
		putchar('A');
		putchar('S');
		putchar('S');
	} else {
		putchar('F');
		putchar('A');
		putchar('I');
		putchar('L');
	}
	putchar('\n');
  putchar('+');
  putchar('+');
  putchar('+');

  P1OUT  = 0xF0;                    //  Simulation Stopping Command
  return 0;
}
