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




void FIQ_Handler (void)__attribute__((interrupt ("FIQ")));
void IRQ (void)__attribute__((interrupt ("IRQ")));

void configure() {
  //Enable alternative Function AIN0
  PINSEL1 &= ~(3 << 22); // Clear bits 22 and 23
  PINSEL1 |=  (1 << 22); // Set bit 22 to 1 and bit 23 to 0 

  ADCR = (1 << 0)     // AIN0 ausgewählt
       | (5 << 8)     // CLKDIV = 5 für ADC clock von 3 MHz (Peripherie Clock 18,5 / 5 = 3)
       | (0 << 16)    // BURST = 0
       | (1 << 21)    // PDN = 1, ADC eingeschaltet
       | (1 << 24);   // START = 0x1, manuelle Wandlung
}


int main() {

}