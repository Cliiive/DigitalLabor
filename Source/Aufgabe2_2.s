/*
 * Aufgabe_2_2.S
 *
 * SoSe 2024
 *
 *  Created on: <13.04.2024>
 *      Author: <Jonas Sasowski>
 *
 *	Aufgabe : Multiplikation
 */
.text /* Specify that code goes in text segment */
.code 32 /* Select ARM instruction set */
.global main /* Specify global symbol */
main:
  mov r0,#5 //Multiplikator
  mov r1,# (1 << 31) //Zahl
  mov r2,#0 //Ergebnis

  mov r3,#0 //Überläufe
  mov r4,#1
  
  while:
    movs r0,r0
    beq stop
    adds r2, r2, r1 //Zahl auf Ergebnis addieren
    addcs r3, r3, r4
    
    sub r0,#1
    b while


stop:
	nop
	bal stop

.end
