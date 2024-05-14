/*
 * Aufgabe_3_3.S
 *
 * SoSe 2024
 *
 *  Created on: <14.05.2024>
 *      Author: <Jonas Sasowski>
 *
 *	Aufgabe : Unterprogrammaufruf  mit Parameterübergabe über dem Stack
 */
.text /* Specify that code goes in text segment */
.code 32 /* Select ARM instruction set */
.global main /* Specify global symbol */
main:
  ldr r6,=3

  push {r6} //Parameter auf dem Stack speichern
  bl delay_function
  
  add sp, sp, #4 // Stack berreinigen (von dem Parameter r6)

delay_function:

  push {r0, lr} //Speichern von dem Arbeitsregister
  ldr r0, [sp, #8]  // Lade den Parameter vom Stack in r0 (Offset 8 wegen push => sp ist gerade auf lr)
  loop:
    subs r0, r0, #1
    bne loop
  
  pop {r0, pc}


stop:
	nop
	bal stop

.end
