// Dominik Matijaca 0036524568

#define F_CPU 3333333
#include <avr/io.h>
#include <stdio.h>
#include <util/delay.h>

#define BAUD_RATE 115200

#define SAMPLES 100
#define SAMPLE_DELAY 10 // ms

int USART3_putchar(char c, FILE* stream) {
	// Wait for previous transmission to complete
	while (!(USART3.STATUS & USART_DREIF_bm));

	// Put character into stream
	USART3.TXDATAL = c;
	return 0;
}

FILE _stdout = FDEV_SETUP_STREAM(USART3_putchar, NULL, _FDEV_SETUP_WRITE);

void USART3_init() {
	stdout = &_stdout;

	// Calculate baud rate register
	USART3.BAUD = (float)(F_CPU * 64) / (16 * BAUD_RATE) + 0.5f;

	// Enable transmitter only
	USART3.CTRLB |= USART_TXEN_bm;

	// Set TX pin as output
	PORTB.DIR |= 0x01;
}

void ADC0_init() {
	// Set reference voltage to VCC (3.3V)
	ADC0.CTRLC |= ADC_REFSEL_VDDREF_gc;

	// Enable ADC
	ADC0.CTRLA |= ADC_ENABLE_bm;

	// Set ADC channel
	ADC0.MUXPOS = ADC_MUXPOS_AIN0_gc;
}

int16_t ADC0_read() {
	// Start ADC conversion
	ADC0.COMMAND = ADC_STCONV_bm;

	// Wait until ADC conversion is finished
	while (!(ADC0.INTFLAGS & ADC_RESRDY_bm));

	// Acknowledge
	ADC0.INTFLAGS = ADC_RESRDY_bm;

	return ADC0.RES;
}

int main(void) {
	USART3_init();
	ADC0_init();

	printf("Started!");

	float avg = 0;
	uint16_t i = 0;

	while (1) {
		avg += ADC0_read() / 1023.0f * 3.3f / SAMPLES;
		
		if (++i == SAMPLES) {
			printf("%d mV\r\n", (int)(avg * 1000));
			avg = 0;
			i = 0;
		}
		
		_delay_ms(SAMPLE_DELAY);
	}
}
