/*
 * Aufgabe_7_3.S
 *
 * SoSe 2024
 *
 *  Created on: <30.06.2024>
 *      Author: <Jonas Sasowski>
 *
 *	Aufgabe : Umschaltbares Lauflicht
 */
#include <stdint.h>
#include "LPC21XX.H"
#define OUTPUT_MASK 0x00FF0000

#define BUTTON_0_bm (1<<10)
#define BUTTON_1_bm (1<<11)
#define BUTTON_2_bm (1<<12)
#define BUTTON_3_bm (1<<13)


void configure() {
  IODIR1 = OUTPUT_MASK; //Alle Lampen auf Output Setzen
}


void delay(uint32_t delayParameter) {
  while (delayParameter != 0) {
    delayParameter--;
  }
}

uint8_t processKeys() {
  if (IOPIN0 & BUTTON_0_bm) {
    return 0;
  }
  else if (IOPIN0 & BUTTON_1_bm) {
    return 1;
  }
  else if (IOPIN0 & BUTTON_2_bm) {
    return 2;
  }
  else if (IOPIN0 & BUTTON_3_bm) {
    return 3;
  }
  else if (IOPIN0 & BUTTON_0_bm & BUTTON_2_bm) {
    return 4;
  }
  else {
    return 5;
  }
}

void runLightLeft(uint32_t *mask) {
    for (uint8_t i=0; i<8; i++) {
      uint32_t action = processKeys();
      if (action == 5) {
        IOSET1 = IOSET1 | *mask;
        delay(0x900000);
        IOCLR1 = *mask;
        delay(0x100000);
        *mask = (*mask>>1);
      }
      else {
        break;
      }
  }
}

void runLightRight(uint32_t *mask) {
    for (uint8_t i=0; i<8; i++) {
      uint32_t action = processKeys();
      if (action == 5) {
        IOSET1 = IOSET1 | *mask;
        delay(0x900000);
        IOCLR1 = *mask;
        delay(0x100000);
        *mask = (*mask<<1);
      }
      else {
        break;
      }
      
  }
}



void runProgram() {
  uint32_t currentAction = 0;
  uint8_t currentRight;
  uint32_t *mask;
  *mask = (1<<16);
  while (1) {
    uint32_t action = processKeys();
    if (action != 2) {
      if (action == 0) {
        uint8_t currentRight = 1;
        runLightRight(mask);
      }
      else if (action == 1) {
        break;
      }
      else if (action == 3) {
        IOCLR1 = IOCLR1 & OUTPUT_MASK;
      }
      else if (action == 4) {
        if (currentRight) {
          runLightRight(mask);
        }
        else {
          runLightLeft(mask);
        }
      }
      
    }
}
  
}

int main(void) {
  configure();
  runProgram();
}
