#include <stm32f4xx.h>

extern volatile uint32_t msTicks; // Protekle ms

void __attribute__((interrupt)) SysTick_Handler(void);

void __attribute__((interrupt)) SysTick_Handler(void) {
	msTicks++; // Povecava se za 1 svake milisekunde
}
