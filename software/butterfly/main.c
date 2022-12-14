#include "omsp_system.h"
#include "omsp_uart.h"
#include "butterfly_fft.h"
#include "shiftFFT.h"

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

unsigned long long hwtranspose(unsigned long long a) {
	unsigned long long b = 0;
	/*FFT_REG1 = (a >> 48) & 0xffff;
	FFT_REG2 = (a >> 32) & 0xffff;
	FFT_REG3 = (a >> 16) & 0xffff;
	FFT_REG4 = a & 0xffff;
	
	b = FFT_REG4;
	b |= ((unsigned long long) FFT_REG3 << 16);
	b |= ((unsigned long long) FFT_REG2 << 32);
	b |= ((unsigned long long) FFT_REG1 << 48);*/
  return b;
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
    //shiftFFT((16-i)*(16-i)*10, fft_re, fft_im);
    sw_check += fft_re[0];
    sw_time += TimerLap();
    putchar('*');
  }
  
  putchar('\n');
  for (i=0; i<2; i++) {
    putchar('r'); putchar(c16[i]); putchar('=');
    puthex(fft_re[i]);
    putchar(' ');
    putchar('i'); putchar(c16[i]); putchar('=');
    puthex(fft_im[i]);
    putchar('\n');
  }
  
	putchar('>');
  prngseed();
  hw_check = 0;
  hw_time  = 0;
  for (i=0; i<16; i++) {
    TimerLap();
    FFT_FIFO = (16-i)*(16-i)*10;
    hw_check += FFT_OUT1;
    hw_time += TimerLap();
    putchar('#');
  }
	
	putchar('\n');
	putchar('r'); putchar(c16[0]); putchar('=');
  puthex(FFT_OUT0);
  putchar(' ');
  putchar('i'); putchar(c16[0]); putchar('=');
  puthex(FFT_OUT1);
  putchar('\n');
  putchar('r'); putchar(c16[1]); putchar('=');
  puthex(FFT_OUT2);
  putchar(' ');
  putchar('i'); putchar(c16[1]); putchar('=');
  puthex(FFT_OUT3);
	
	putchar('\n'); putchar('\n');
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
	
	if (sw_check == hw_check) {
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
