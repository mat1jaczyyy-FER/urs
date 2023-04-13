/* URS example: Blinky */
#define F_CPU 3333333
#include <avr/io.h>
#include <util/delay.h>

int main(void)
{
	// PORTF.DIR |= (1 << 5); // set PF.5 as output (Curiosity Nano)
	PORTD.DIR |= (1 << 7); // set PD.7 as output (URS board)
	while (1)
	{
		// PORTF.OUT |= (1 << 5); // LED ON
		PORTD.OUT |= (1 << 7); // LED ON
		_delay_ms(100);
		// PORTF.OUT &= ~(1 << 5); // LED OFF
		PORTD.OUT &= ~(1 << 7); // LED OFF
		_delay_ms(100);
	}
}
