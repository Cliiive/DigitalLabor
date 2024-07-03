/*
 * Aufgabe_9.S
 *
 *  Created on: <26.06.2024>
 *      Author: <Jonas Sasowski>
 *
 *	Aufgabe : Analog – Digital Wandlung
 */

#include <stdint.h>
#include <stdio.h>
#include "LPC21XX.h"
#define LED_MASK 0x00FF0000




void FIQ_Handler (void)__attribute__((interrupt ("FIQ")));
void IRQ (void)__attribute__((interrupt ("IRQ")));

//AUFGABE 1

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



//AUFGABE 2

unsigned int readADC() {
    // Start ADC conversion
    ADCR |= (1 << 24);  // Start conversion

    // Wait for conversion to complete
    while (!(ADDR & (1 << 31)));  // Check DONE bit
    int debug = ADDR;
    // Read the result
    return (ADDR >> 6) & 0x3FF;  // Extract 10-bit result
}

void displayOnLED(unsigned int value) {
    // Convert 10-bit ADC value to 8-bit for LED display
    unsigned int ledValue = value >> 2;  // Scale down 10-bit to 8-bit
    unsigned int mask = 0;

    int numOfLeds = ledValue/32; //2^8 = 256 values are possible, so a new Led needs to apppear for every 32'th value

    //Build the mask
    for (int i = 0; i<=numOfLeds; i++) {
        mask |= (1<<i);
    }

    mask <<= 16; //Shift Leds for 16 bits to left
    // Update LED display
    IOCLR1 = ~mask;
    IOSET1 = IOSET1 | mask;  // Set LED port with new value
}

void runLedStrip(void) {
  while (1) {
        unsigned int adcValue = readADC();
        displayOnLED(adcValue);
    }
}




//AUFGABE 3

void UART0_Init() {
    PINSEL0 = PINSEL0 & ~0x0000000f; //Löschen 
    PINSEL0 |= 0x0000005;   // P0.0 as TXD0 and P0.1 as RXD0
    U0LCR = 0x82;            // 8 bits, no Parity, 1 Stop bit, DLAB=1
    U0DLM = 0;
    U0DLL = 120;              // 9600 Baud Rate @ 18.432 MHz PCLK (18432000 / (16 * 9600) = 120)
    U0LCR = 0x02;            // DLAB = 0
    U0FCR = 0x07;            // Enable and reset TX and RX FIFO
}

void UART_SendChar(char ch) {
    while (!(U0LSR & 0x20)); // Wait for THR to be empty
    U0THR = ch;
}

void UART_SendString(char* str) {
    while (*str) {
        UART_SendChar(*str++);
    }
}

void intToHex(unsigned int value, char* str) {
    const char hexDigits[] = "0123456789ABCDEF";
    str[0] = '0';
    str[1] = 'X';
    str[2] = hexDigits[(value >> 8) & 0xF];
    str[3] = hexDigits[(value >> 4) & 0xF];
    str[4] = hexDigits[value & 0xF];
    str[5] = '\0';
}

int main(void) {
  configure();
  UART0_Init();
  while (1) {
        unsigned int adcValue = readADC();
        displayOnLED(adcValue);

        char hexString[6];
        intToHex(adcValue, hexString);
        UART_SendString(hexString);
        UART_SendChar('\n');  // Newline for next v
    }
}