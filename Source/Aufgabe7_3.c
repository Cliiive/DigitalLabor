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
  if (action == 5) {
    return 1;
  } 
  else {
    return 0;
  }
}

void runLightLeft(uint8_t counter, int *mask) {
    if (counter == 0) {
      *mask = (1<<23);
    }
    IOCLR1 = *mask;
    IOSET1 = IOSET1 | *mask;
    *mask = (*mask>>1);
}

void runLightRight(uint8_t counter, int *mask) {
    if (counter == 0) {
      *mask = (1<<15);
    }
    //IOCLR1 = *mask;
    IOCLR1 = *mask;
    *mask = (*mask<<1);
    IOSET1 = IOSET1 | *mask;
    
    
}



void runProgram() {
  uint8_t isRunning = 0;
  uint8_t counter = 0;
  int *mask;
  int value = (1<<15);
  mask = &value;

  while (1) {
    uint8_t action = processKeys();

    if (action == 0) {isRunning = 1;}
    else if (action == 1) {break;}
    else if (action == 2) {isRunning = 0;}

    if (isRunning) {
      runLightRight(counter, mask);
      counter = (counter+1)%9;
    }

    delay(0x99999);
  }
  
}

int main(void) {
  configure();
  runProgram();
}
