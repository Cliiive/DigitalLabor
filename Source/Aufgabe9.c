/*
 * Aufgabe_9.S
 *
 *  Created on: <26.06.2024>
 *      Author: <Jonas Sasowski>
 *
 *	Aufgabe : Analog – Digital Wandlung
 */

#include <stdint.h>
#include "LPC21XX.h"
#define LED_MASK 0x00FF0000




void FIQ_Handler (void)__attribute__((interrupt ("FIQ")));
void IRQ (void)__attribute__((interrupt ("IRQ")));

//Aufgabe 1
void configure() {
  //Enable alternative Function AIN0
  PINSEL1 &= ~(3 << 22); // Clear bits 22 and 23
  PINSEL1 |=  (1 << 22); // Set bit 22 to 1 and bit 23 to 0 

  ADCR = (1 << 0)     // AIN0 ausgewählt
       | (5 << 8)     // CLKDIV = 5 für ADC clock von 3 MHz (Peripherie Clock 18,5 / 5 = 3)
       | (0 << 16)    // BURST = 0
       | (1 << 21)    // PDN = 1, ADC eingeschaltet
       | (1 << 24);   // START = 0x1, manuelle Wandlung
  
  IODIR1 = LED_MASK;
}

unsigned int readADC() {
    // Start ADC conversion
    ADCR |= (1 << 24);  // Start conversion

    // Wait for conversion to complete
    while (!(ADDR & (1 << 31)));  // Check DONE bit

    // Read the result
    return (ADDR >> 6) & 0x3FF;  // Extract 10-bit result
}

void displayOnLED(unsigned int value) {
    // Convert 10-bit ADC value to 8-bit for LED display
    unsigned int ledValue = value >> 2;  // Scale down 10-bit to 8-bit

    // Update LED display
    IOCLR1 = LED_MASK;    // Clear LED port
    IOSET1 = ledValue & LED_MASK;  // Set LED port with new value
}

int main() {
  configure();

  while (1) {
      unsigned int adcValue = readADC();
      displayOnLED(adcValue);
  }

}