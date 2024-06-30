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

uint8_t noButtonPressed();

void configure() {
  IODIR1 = OUTPUT_MASK; //Alle Lampen auf Output Setzen
}


void delay(uint32_t delayParameter) {
  while ((delayParameter != 0)) {
    delayParameter--;
  }
}

uint8_t processKeys() {
  if (~IOPIN0 & BUTTON_0_bm) {
    return 0;
  }
  else if (~IOPIN0 & BUTTON_1_bm) {
    return 1;
  }
  else if (~IOPIN0 & BUTTON_2_bm) {
    return 2;
  }
  else if (~IOPIN0 & BUTTON_3_bm) {
    return 3;
  }
  else if (~IOPIN0 & (BUTTON_0_bm | BUTTON_2_bm)) {
    return 4;
  }
  else {
    return 5;
  }
}

uint8_t noEscapePressed() {
  uint8_t action = processKeys();
  if (action == 5 || action == 2) {
    return 1;
  } 
  else {
    return 0;
  }
}

void runLightLeft() {
  uint32_t paused = 0;
  uint8_t counter = 0;
  int mask = (1<<16);
  while (noEscapePressed()){
      if (counter == 0) {
        mask = (1<<16);
      }

      IOSET1 = IOSET1 | mask;
      if (processKeys() == 2) {
        paused = !paused;
        delay(0xB0000);
      }
      if (!paused) {
      delay(0x90000);
      IOCLR1 = mask;
      mask = (mask<<1);
      counter = (counter+1)%8;
      }
  }
}

void runLightRight() {
  uint32_t paused = 0;
  uint8_t counter = 0;
  int mask = (1<<16);
  while (noEscapePressed()){
      if (counter == 0) {
        mask = (1<<16);
      }

      IOSET1 = IOSET1 | mask;
      if (processKeys() == 2) {
        paused = !paused;
        delay(0xB0000);
      }
      if (!paused) {
      delay(0x90000);
      IOCLR1 = mask;
      mask = (mask<<1);
      counter = (counter+1)%8;
      }
  }
}



void runProgram() {
  uint8_t isRunning = 0;
  uint8_t pause = 0;
  uint8_t currentRight = 1;
  while (1) {
    uint32_t action = processKeys();
    if (action == 0) {
      uint8_t currentRight = 1;
      isRunning = 1;
      runLightRight();
    }
    if (isRunning) {
      if (action == 1) {
        isRunning = 0;
      }
      else if (action == 3) {
        IOCLR1 = IOCLR1 & OUTPUT_MASK;
      }
      else if (action == 4) {
        if (currentRight) {
          currentRight = 0;
          delay(0x40000);
          runLightLeft();
        }
        else {
          currentRight = 1;
          delay(0x40000);
          runLightRight();
          }
        }
    }
    else {
      delay(0x10000);
    }
}
  
}

int main(void) {
  configure();
  runProgram();
}
