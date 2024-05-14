/*
 * Aufgabe_3_1.S
 *
 * SoSe 2024
 *
 *  Created on: <14.05.2024>
 *      Author: <Jonas Sasowski>
 *
 *	Aufgabe : Unterprogrammaufruf
 */
.text /* Specify that code goes in text segment */
.code 32 /* Select ARM instruction set */
.global main /* Specify global symbol */

.equ DELAY_CONSTANT, 3

main:
  ldr r0,=4 //Testwert
  bl delay_function
  ldr r0,=5 //Testwert
  b stop

delay_function:

  stmfd sp!, {r0, lr} //Speichern von dem Arbeitsregister (falls es gerade in benutzung is)
  ldr r0, =DELAY_CONSTANT

  loop:
    subs r0, r0, #1
    bne loop
  
  ldmfd sp!, {r0, pc}


stop:
	nop
	bal stop

.end
