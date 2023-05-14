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

#define BAUD_TWI 100000 // bps

// Temperature sensor slave address
#define MAX7500 ((uint8_t)0x48)

// Temperature register address
#define TEMPERATURE ((uint8_t)0x00)

void I2C_init() {
	// 100 kbps
	TWI0.MBAUD = (uint8_t)((F_CPU / 2 / BAUD_TWI) - 5);
	
	// Force bus into idle state
	TWI0.MSTATUS = TWI_BUSSTATE_IDLE_gc;
	
	// Enable TWI
	TWI0.MCTRLA = TWI_ENABLE_bm;
}

enum rw_t {
	rw_write,
	rw_read
};

uint8_t I2C_start(uint8_t address, uint8_t rw) {
	// Send START condition
	TWI0.MADDR = (address << 1) | rw;
	
	// Wait for write interrupt flag
	while (!(TWI0.MSTATUS & (TWI_WIF_bm | TWI_RIF_bm)));
	TWI0.MSTATUS |= rw? TWI_RIF_bm : TWI_WIF_bm;
	
	// Return false (0) if arbitration lost or bus error
	if ((TWI0.MSTATUS & TWI_ARBLOST_bm)) return 0;
	
	// Return true (!0) if slave gave an ACK
	return !(TWI0.MSTATUS & TWI_RXACK_bm);
}

void I2C_stop() {
	// Send ACK / STOP
	TWI0.MCTRLB = TWI_ACKACT_bm | TWI_MCMD_STOP_gc;
}

uint8_t I2C_write(uint8_t data) {
	// send data
	TWI0.MDATA = data;
	
	// Wait for write interrupt flag
	while (!(TWI0.MSTATUS & (TWI_WIF_bm)));
	TWI0.MSTATUS |= TWI_WIF_bm;
	
	// Do nothing on bus (no ACK etc.)
	TWI0.MCTRLB = TWI_MCMD_RECVTRANS_gc;
	
	// Returns true (!0) if slave gave an ACK
	return !(TWI0.MSTATUS & TWI_RXACK_bm);
}

uint8_t I2C_read(uint8_t last_byte) {
	// Wait for Clk Hold flag to be high
	while (!(TWI0.MSTATUS & TWI_CLKHOLD_bm));
	
	if (last_byte) {
		// Send NACK
		TWI0.MCTRLB = TWI_ACKACT_bm | TWI_MCMD_STOP_gc;
		
	} else {
		// Send ACK
		TWI0.MCTRLB = TWI_MCMD_RECVTRANS_gc;
	}
	
	return TWI0.MDATA;
}

uint16_t read_half(uint8_t addr, uint8_t reg) {
	// I2C
	I2C_start(addr, rw_write);
	I2C_write(reg);
	I2C_start(addr, rw_read);
	uint16_t val = (uint16_t)I2C_read(0) << 8;
	val |= I2C_read(1);
	I2C_stop();
	
	return ((val >> 8) & 0x7F) | (val & 0x8000);
}

void display_value(int8_t val) {
	// Display number if in range
	if (0 <= val && val <= 9)
		PORTC.OUT = seg[val];
	
	// Delay pulse
	_delay_ms(PULSE / 2);
}

int main(void) {
	// Display pins as output
	PORTC.DIR = 0xFF;

	// Display selector as output
	PORTE.DIR = 0x0C;
	
	I2C_init();
	
	while (1) {
		// Read temperature sensor
		uint16_t val = read_half(MAX7500, TEMPERATURE);
		
		// Display value
		for (uint8_t i = 0; i < CYCLE / PULSE; i++) {
			PORTC.OUT = 0x00;
			PORTE.OUT = 0x04;
			display_value(val / 10);

			PORTC.OUT = 0x00;
			PORTE.OUT = 0x08;
			display_value(val % 10);
		}
	}
}
