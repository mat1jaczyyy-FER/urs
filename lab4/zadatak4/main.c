// Dominik Matijaca 0036524568

#define F_CPU 3333333
#include <avr/io.h>
#include <util/delay.h>

int main(void) {
	// Heater pin as output
	PORTF.DIR |= PIN5_bm;
	
	// Select Port F
	PORTMUX.TCAROUTEA = PORTMUX_TCA0_PORTF_gc;
	
	// Enable SPLITM
	TCA0.SPLIT.CTRLD |= TCA_SPLIT_SPLITM_bm;
	
	// Enable HCMP2EN
	TCA0.SPLIT.CTRLB |= TCA_SPLIT_HCMP2EN_bm;
	
	// TOP value for timer
	// https://www.desmos.com/calculator/evgcnuhoit
	TCA0.SPLIT.HPER = 0x0C;
	
	// Compare value
	TCA0.SPLIT.HCMP2 = 0x09;
	
	// Prescaler CLKSEL and Enable timer
	TCA0.SPLIT.CTRLA = TCA_SINGLE_CLKSEL_DIV256_gc | TCA_SPLIT_ENABLE_bm;
	
	while (1) {
		_delay_ms(1000);
	}
}
