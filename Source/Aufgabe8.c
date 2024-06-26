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
#include <stdlib.h>
#include "LPC21XX.h"

void FIQ_Handler (void)__attribute__((interrupt ("FIQ")));
void IRQ (void)__attribute__((interrupt ("IRQ")));


//Aufgabe1
typedef struct{
uint32_t value;
uint8_t carry;
} result_t;

void add32(uint32_t a, uint32_t b, result_t* result) {
    asm(" adds r0, %[value_a],%[value_b] \n\
          mov %[result_value],r0 \n\
          movcs %[result_carry], #1 \n\
          movcc %[result_carry], #0"
          : [result_value]"=r" (result->value), // definiert die Ausgangsvariable
            [result_carry]"=r" (result->carry)
          : [value_a]"r" (a), // definiert die Eingangsvariable a
            [value_b]"r" (b) // definiert die Eingangsvariable b
          : "cc","r0"
          ); // Flags und r0 werden von der Funktion manipuliert

};


uint8_t* unpack(uint8_t value) {
    // Speicher für das Ergebnisfeld auf dem Heap reservieren
    uint8_t* result = (uint8_t*)malloc(8 * sizeof(uint8_t));
    if (result == NULL) {
        // Fehler beim Allokieren des Speichers
        return NULL;
    }

    // Inline-Assembly-Block für die Konvertierung
    asm (
        "mov r1, %[value_asm] \n"           // Lade den Eingabewert in r1
        "mov r2, %[result_asm] \n"           // Lade die Adresse des Ergebnisfeldes in r2
        "mov r3, #8 \n"           // Setze den Zähler auf 8

        "loop: \n"
        "lsr r4, r1, #7 \n"       // Extrahiere das höchste Bit
        "strb r4, [r2], #1 \n"    // Speichere das Bit im Ergebnisfeld und inkrementiere die Adresse
        "lsl r1, r1, #1 \n"       // Verschiebe den Eingabewert um 1 Bit nach links
        "and r1, r1, #0b11111111  \n"
        "subs r3, r3, #1 \n"      // Dekrementiere den Zähler
        "bne loop \n"               // Wiederhole, solange der Zähler nicht 0 ist
        // "sub r2, #7 \n"

        : [result_asm]"+r" (result)           // Ausgabe: result (wird nicht direkt genutzt, aber als Placeholder für den Speicherort)
        : [value_asm]"r" (value)             // Eingabe: value (der 8-Bit-Wert)
        : "r1", "r2", "r3", "r4"  // Clobbered Registers
    );

    return result;                // Rückgabe des Ergebnisfeldes
}

//Aufgabe 8 b)
uint8_t pack(uint8_t* bits) {
    uint8_t value = 0;

    // Inline-Assembly-Block für die Konvertierung
    asm (
        "mov r2, %[bits_asm] \n"        // Lade die Adresse des Eingabefeldes in r2
        "mov r3, #8 \n"                 // Setze den Zähler auf 8

        "loop_pack: \n"
        "ldrb r4, [r2], #1 \n"          // Lade das Bit aus dem Eingabefeld und inkrementiere die Adresse
        "lsl %[value_asm], %[value_asm], #1 \n"  // Verschiebe den aktuellen Wert um 1 Bit nach links
        "orr %[value_asm], %[value_asm], r4 \n"  // Setze das Bit an die niedrigste Stelle
        "subs r3, r3, #1 \n"            // Dekrementiere den Zähler
        "bne loop_pack \n"              // Wiederhole, solange der Zähler nicht 0 ist

        : [value_asm]"+r" (value)       // Ausgabe: value (der zusammengesetzte 8-Bit-Wert)
        : [bits_asm]"r" (bits)          // Eingabe: bits (das Feld mit den Bits)
        : "r2", "r3", "r4"              // Clobbered Registers
    );

    return value;                       // Rückgabe des zusammengesetzten Wertes
}

int main() {
  result_t* result1;
  uint32_t a = 0xffffffff;
  uint32_t b = 0xffffffff;

  add32(a, b, result1);

  uint8_t value = 0x98;         // Beispielwert: 10011000 in binär
  uint8_t* result2 = unpack(value);

  uint8_t result3 = pack(result2); 
};