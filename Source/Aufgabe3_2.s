/*
 * Aufgabe_3_2.S
 *
 * SoSe 2024
 *
 *  Created on: <$Date>
 *      Author: <$Name>
 *
 *	Aufgabe : Unterprogrammaufruf  mit Parametern
 */
.text /* Specify that code goes in text segment */
.code 32 /* Select ARM instruction set */
.global main /* Specify global symbol */

main:
  mov r0,#3 //Parameter für delay
  bl delay_function
  b stop

delay_function:
  loop:
    subs r0, r0, #1
    bne loop
  bx lr


stop:
	nop
	bal stop

.end
