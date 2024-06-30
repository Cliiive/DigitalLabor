/*
 * Aufgabe_7_2.S
 *
 * SoSe 2024
 *
 *  Created on: <30.06.2024>
 *      Author: <Jonas Sasowski>
 *
 *	Aufgabe : GPIO in C
 */
#include <stdint.h>
#include "LPC21XX.H"

#define OUTPUT_MASK 0x00FF0000
#define LAMP0_MASK (1<<16)
#define DELAY_PARAMETER_9 
#define DELAY_PARAMETER_1 

void configure() {
  IODIR1 = OUTPUT_MASK; //Alle Lampen auf Output Setzen
}

void delay(uint32_t delayParameter) {
  while (delayParameter != 0) {
    delayParameter--;
  }
}

void runlight() {
  while (1) {
    uint32_t mask = LAMP0_MASK;
    for (uint8_t i=0; i<8; i++) {
      IOSET1 = IOSET1 | mask;
      delay(0x900000);
      IOCLR1 = mask;
      delay(0x100000);
      mask = (mask << 1);
    }
  }
}

int main(void) {
  configure();
  runlight();
}
