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
  while ((delayParameter != 0)) {
    delayParameter--;
  }
}

uint8_t processKeys() {
  if ((~IOPIN0 & (BUTTON_0_bm | BUTTON_2_bm)) == (BUTTON_0_bm | BUTTON_2_bm)) {
    //delay(0x900000);
    return 4;
  }
  else if (~IOPIN0 & BUTTON_0_bm) {
    return 0;
  }
  else if (~IOPIN0 & BUTTON_1_bm) {
    return 1;
  }
  else if (~IOPIN0 & BUTTON_2_bm) {
    delay(0x90000);
    return 2;
  }
  else if (~IOPIN0 & BUTTON_3_bm) {
    return 3;
  }
  else {
    return 5;
  }
}

void runLightLeft(uint8_t counter, int *mask) {
    if (counter == 0) {
      *mask = (1<<24);
    }
    //IOCLR1 = *mask;
    IOCLR1 = *mask;
    *mask = (*mask>>1);
    IOSET1 = IOSET1 | *mask;
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
  uint8_t direction = 0;
  int *mask;
  int defaultMask = (1<<15);
  mask = &defaultMask;

  while (1) {
    uint8_t action = processKeys();

    if (action == 0) {isRunning = 1;}
    else if (action == 1) {IOCLR1 = OUTPUT_MASK;break;} //Terminate the Program
    else if (action == 2) {isRunning = !isRunning;} //Pause/Continue
    else if (action == 3) { //Reset the Program
      isRunning = 0; 
      counter = 0;
      direction = 0;
      int *mask;
      int defaultMask = (1<<15);
      mask = &defaultMask;
      IOCLR1 = OUTPUT_MASK;
    }
    else if (action == 4) { //Change direction
    isRunning = 1; direction = !direction;
    }

    if (isRunning) {
      if (direction == 0) {
        runLightRight(counter, mask);
      }
      else {
        runLightLeft(counter, mask);
      }
      counter = (counter+1)%9;
    }
    
    delay(0x99999);
    
  }
  
}

int main(void) {
  configure();
  runProgram();
}
