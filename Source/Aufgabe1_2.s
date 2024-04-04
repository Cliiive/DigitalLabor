/*
 * Aufgabe_1_2.S
 *
 * SoSe 2024
 *
 *  Created on: <23.03.2024>
 *      Author: <Jonas Sasowski>
 *
 *	Aufgabe : Addition von Zahlen
 */
.text /* Specify that code goes in text segment */
.code 32 /* Select ARM instruction set */
.global main /* Specify global symbol */
main:
  //a
  mov r0, #0xffffffff
  mov r1, #1
  add r2, r0, r1

  //b
  mov r0, #-1
  mov r1, #1
  add r2, r0, r1
  
  //c
  mov r3, #1 << 31
  add r4, r3, r3


stop:
	nop
	bal stop

.end
fffffffe