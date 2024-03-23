/*
 * Aufgabe_1_1.S
 *
 * SoSe 2024
 *
 *  Created on: <23.03.2024>
 *      Author: <Jonas Sasowski>
 *
 *	Aufgabe : Zahlendarstellung
 */
.text /* Specify that code goes in text segment */
.code 32 /* Select ARM instruction set */
.global main /* Specify global symbol */
main:
  mov r0, #0xFFFFFFF4
  mov r1, #4294967284
  mov r2, #-12
  mov r3, #-0xC
  mov r4, #~11
  mov r5, #0b11111111111111111111111111110100


stop:
	nop
	bal stop

.end
