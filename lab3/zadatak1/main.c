// Dominik Matijaca 0036524568

#define F_CPU 3333333
#include <avr/io.h>
#include <util/delay.h>

uint8_t state = 0;

int main(void) {
	// LED pins as output
	PORTD.DIR |= 0xF0;

	// Enable pull-up for buttons
	for (register8_t* i = &PORTA.PIN4CTRL; i <= &PORTA.PIN7CTRL; i++)
		*i |= PORT_PULLUPEN_bm;

    while (1) {
		// Flip PORTA.IN because of negative logic
		uint8_t rising = ~state & ~PORTA.IN;
		state = ~PORTA.IN;

		// If button created rising edge, turn its LED on
		for (uint8_t i = 4; i < 8; i++) {
			uint8_t bm = (1 << i);
			if (rising & bm)
				PORTD.OUT = bm;
		}

		_delay_ms(8);
    }
}
