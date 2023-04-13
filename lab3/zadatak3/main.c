// Dominik Matijaca 0036524568

#define F_CPU 3333333
#include <avr/io.h>
#include <util/delay.h>

#define CYCLE 1000
#define PULSE 10

/*
    A1
  F2  B0
    G3
  E5  C4
    D7   DP6
*/

const uint8_t seg[10] = {
	0b10110111,
	0b00010001,
	0b10101011,
	0b10011011,
	0b00011101,
	0b10011110,
	0b10111110,
	0b00010011,
	0b10111111,
	0b10011111
};


int main(void) {
	// Display pins as output
	PORTC.DIR = 0xFF;

	// Display selector as output
	PORTE.DIR = 0x0C;

	uint8_t d = 0, j = 0;

	while (1) {
		// Display number
		for (uint8_t i = 0; i < CYCLE / PULSE; i++) {
			PORTE.OUT = 0x04;
			PORTC.OUT = seg[d];
			_delay_ms(PULSE / 2);

			PORTE.OUT = 0x08;
			PORTC.OUT = seg[j];
			_delay_ms(PULSE / 2);
		}

		// Next number
		if (++j >= 10) {
			j = 0;
			
			if (++d >= 10)
				d = 0;
		}
	}
}
