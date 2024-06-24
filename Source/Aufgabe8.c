/*
 * Aufgabe_8.S
 *
 * SoSe 2024
 *
 *  Created on: <$Date>
 *      Author: <$Name>
 *
 *	Aufgabe : Assembler in C
 */

#include <stdint.h>
#include <stdio.h>
//#include "LPC21XX.h"

void FIQ_Handler (void)__attribute__((interrupt ("FIQ")));
void IRQ (void)__attribute__((interrupt ("IRQ")));

typedef struct{
uint32_t value;
uint8_t carry;
} result_t;

void add32(uint32_t a, uint32_t b, result_t* result) {
    asm(" adds r0, %[value_a],%[value_b] \n\
          mov %[result_value],r0 \n\
          movcs %[result_carry], #1"
          : [result_value]"=r" (result->value), // definiert die Ausgangsvariable
            [result_carry]"=r" (result->carry)
          : [value_a]"r" (a), // definiert die Eingangsvariable a
            [value_b]"r" (b) // definiert die Eingangsvariable b
          : "cc","r0"
          ); // Flags und r0 werden von der Funktion manipuliert

};

int main() {
  result_t* result;
  uint32_t a = 3;
  uint32_t b = 4;

  add32(a, b, result);
}