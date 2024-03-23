/*
 * Aufgabe_1_2.S
 *
 * SoSe 2024
 *
 *  Created on: <$Date>
 *      Author: <$Name>
 *
 *	Aufgabe : Addition von Zahlen
 */
.text /* Specify that code goes in text segment */
.code 32 /* Select ARM instruction set */
.global main /* Specify global symbol */
main:
  mov r0, #0xffffffff
  mov r1, #1
  add r2, r0, r1

  mov r3, #0x80000000
  add r4, r3, r3


stop:
	nop
	bal stop

.end
fffffffe