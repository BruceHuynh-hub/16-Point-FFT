#include "omsp_system.h"
#include "omsp_uart.h"

#define REG1   (*(volatile unsigned *) 0x110)
#define REG2   (*(volatile unsigned *) 0x112)
#define REG3   (*(volatile unsigned *) 0x114)
#define REG4   (*(volatile unsigned *) 0x116)

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

unsigned long long prng() {
    unsigned long long result = s0 + s1;
    s1 ^= s0;
    s0 = ((s0 << 55) | (s0 >> 9)) ^ s1 ^ (s1 << 14);
    s1 = (s1 << 36) | (s1 >> 28);
    return result;
}

unsigned long long transpose(unsigned long long a) {
  unsigned r1, r2, r3, r4, r5, r6, r7, r8;
  unsigned long long c, d;
  unsigned i;

  r1 = (a >> 56);
  r2 = (a >> 48) & 0xff;
  r3 = (a >> 40) & 0xff;
  r4 = (a >> 32) & 0xff;
  r5 = (a >> 24) & 0xff;
  r6 = (a >> 16) & 0xff;
  r7 = (a >>  8) & 0xff;
  r8 = (a      ) & 0xff;

  c = 0;
  for (i = 0; i<8; i++) {
    
    d = ((r1 & 1) << 7)
      | ((r2 & 1) << 6)
      | ((r3 & 1) << 5)
      | ((r4 & 1) << 4)
      | ((r5 & 1) << 3)
      | ((r6 & 1) << 2)
      | ((r7 & 1) << 1)
      | ((r8 & 1));
      
    c = (d << 56) + (c >> 8);

    r1 = r1 >> 1;
    r2 = r2 >> 1;
    r3 = r3 >> 1;
    r4 = r4 >> 1;
    r5 = r5 >> 1;
    r6 = r6 >> 1;
    r7 = r7 >> 1;
    r8 = r8 >> 1;

  }

  return c;
}

unsigned long long hwtranspose(unsigned long long a) {
	unsigned long long b;
	REG1 = (a >> 48) & 0xffff;
	REG2 = (a >> 32) & 0xffff;
	REG3 = (a >> 16) & 0xffff;
	REG4 = a & 0xffff;
	
	b = REG4;
	b |= ((unsigned long long) REG3 << 16);
	b |= ((unsigned long long) REG2 << 32);
	b |= ((unsigned long long) REG1 << 48);
  return b;
}
  
int main(void) {
  unsigned i;
  unsigned long long sw_time;
  unsigned long long hw_time;
  unsigned long long sw_check;
  unsigned long long hw_check;
  
  WDTCTL = WDTPW | WDTHOLD;  // Disable watchdog timer
  TACTL  |= (TASSEL1 | MC1 | TACLR); // Configure timer

  uartinit();

  putchar('>');
  putchar('\n');

  prngseed();
  sw_check = 0;
  sw_time = 0;
  for (i=0; i<16; i++) {
    TimerLap();
    sw_check += transpose(prng());
    sw_time += TimerLap();
    putchar('*');
  }
  
	putchar('\n');
  prngseed();
  hw_check = 0;
  hw_time  = 0;
  for (i=0; i<16; i++) {
    TimerLap();
    hw_check += hwtranspose(prng());
    hw_time += TimerLap();
    putchar('#');
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
