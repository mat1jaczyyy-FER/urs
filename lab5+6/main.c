#include <stm32f4xx.h>
#include <core_cm4.h>
#include <stdio.h> // FILE, __stdin, __stdout

extern volatile uint32_t msTicks; // Protekle ms
volatile uint32_t msTicks = 0;

static FILE* fMorse;
	
void Delay(uint32_t NoOfTicks);
void Delay(uint32_t NoOfTicks) {
	uint32_t curTicks;
	curTicks = msTicks;
	while ((msTicks - curTicks) < NoOfTicks);
}

int main(void) {
	volatile uint32_t tmp;
	
	RCC->AHB1ENR |= RCC_AHB1ENR_GPIOBEN | RCC_AHB1ENR_GPIODEN | RCC_AHB1ENR_GPIOEEN;
	
	tmp = RCC->AHB1ENR;
	
	/* Zadatak 5. */
	// Configure pins 12, 13 of PORTD as output.
	GPIOD->MODER &= ~((0x3UL << 24U) | (0x3UL << 26U));
	GPIOD->MODER |= ((0x1UL << 24U) | (0x1UL << 26U));
	
	// LED on pin 13 OFF, LED on pin 12 ON.
	GPIOD->ODR &= ~(0x1UL << 13U); // OFF
	GPIOD->ODR |= (0x1UL << 12U); // ON
	
	/* Zadatak 6. */
	GPIOB->MODER &= ~((0x3UL << 26U) | (0x3UL << 28U) | (0x3UL << 30U));
	GPIOB->MODER |= ((0x1UL << 26U) | (0x1UL << 28U) | (0x1UL << 30U));
	
	GPIOB->ODR &= ~(0x1UL << 13U);
	GPIOB->ODR &= ~(0x1UL << 14U);
	GPIOB->ODR &= ~(0x1UL << 15U);
	
	for (uint8_t i = 0; i < 3; i++) {
		// Red
		GPIOB->ODR |= (0x1UL << 13U);
		Delay(1000);
		
		// Green
		GPIOB->ODR &= ~(0x1UL << 13U);
		GPIOB->ODR |= (0x1UL << 15U);
		Delay(1000);
		
		// Blue
		GPIOB->ODR &= ~(0x1UL << 15U);
		GPIOB->ODR |= (0x1UL << 14U);
		Delay(1000);
		
		GPIOB->ODR &= ~(0x1UL << 14U);
	}
	
	/* Zadatak 7. */
	printf("Redefinicija sistemskih poziva uspjesno napravljena!\n"); // najveci zajeb ikad
	
	/* Zadatak 8. */
	GPIOE->MODER &= ~(0x3UL << 22U);
	GPIOE->MODER |= (0x1UL << 22U);
	
	fMorse = fopen("Morse", "w");
	fprintf(fMorse, "SOS - SOS - URS");
	fclose(fMorse);
	
	// Kraj
	while (1);
}
