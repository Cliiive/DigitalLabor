/*
 * Aufgabe_7_1.S
 *
 * SoSe 2024
 *
 *  Created on: <01.07.2024>
 *      Author: <Artem Kabin>
 *
 *	Aufgabe : Bitmanipulation in C
 */
#include <stdint.h>
#include <stdio.h>
#include "Aufgabe7_1.h"


// Ausgehend von der Konstanten A laden Sie folgende Werte (alle Indexe in Informatikerzählweise),
// falls nicht anders vermerkt, in 32 Bit breite uint Variablen:
// • value_a – soll nur eine 16 Bit Variable sein. Sie enthält den Wert des ersten Bytes
// • value_b – enthält den inversen Binären Wert (kein exklusives oder!)
// • value_c – das Nibble Nr 5 ist invertiert, ansonsten sind alle anderen Nibbles unverändert.
// • value_d – alle Nibbles, bis auf die Nibbels eins und drei sollten auf den Wert 1 gesetzt
// werden, die Nibbels eins und drei sollten unverändert bleiben.
// • Zerlegen Sie die CONSTANTE_A in ein Feld „{….}“ aus uint8 Nibbles .
// Ausgehend von den Konstanten Low und High:
// • Packen Sie die beiden Konstanten als zwei 8 Bit Werte in eine 16 Bit uint Big Indian
// Variable.
// • Packen Sie die beiden Konstanten als zwei 16 Bit Werte in eine 32 Bit uint Little Indian
// Variable.

int main(void) {
    
    uint16_t value_a = (CONSTANT_A >> 24) & 0xFFFF;
    uint32_t value_b = ~CONSTANT_A;
    uint32_t value_c = (CONSTANT_A & 0xFF0FFFFF) | ((~(CONSTANT_A >> 20) & 0xF) << 20);
    uint32_t value_d = (CONSTANT_A & 0xFF0F0F0F) | ((CONSTANT_A & 0xF0F0F0F0) & 0x11111111);
    
    uint8_t nibbles[4] = {
        (CONSTANT_A >> 24) & 0xFF,
        (CONSTANT_A >> 16) & 0xFF,
        (CONSTANT_A >> 8) & 0xFF,
        CONSTANT_A & 0xFF
    };
    
    uint16_t big_endian = (CONSTANT_HIGH << 8) | CONSTANT_LOW;
    uint32_t little_endian = (CONSTANT_HIGH << 16) | CONSTANT_LOW;
    
    // Let us see the Magic happening
    printf("value_a: 0x%04X\n", value_a);
    printf("value_b: 0x%08X\n", value_b);
    printf("value_c: 0x%08X\n", value_c);
    printf("value_d: 0x%08X\n", value_d);
    
    printf("nibbles: {0x%02X, 0x%02X, 0x%02X, 0x%02X}\n", nibbles[0], nibbles[1], nibbles[2], nibbles[3]);
    
    printf("big_endian: 0x%04X\n", big_endian);
    printf("little_endian: 0x%08X\n", little_endian);
    
    return 0;
}