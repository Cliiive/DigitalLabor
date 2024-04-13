/*
 * Aufgabe_2_1.S
 *
 * SoSe 2024
 *
 *  Created on: <13.04.2024>
 *      Author: <Jonas Sasowski>
 *
 *	Aufgabe : 64 Bit Addition
 */
.text /* Specify that code goes in text segment */
.code 32 /* Select ARM instruction set */
.global main /* Specify global symbol */
main:
  //Zahl 1
  mov r0,# (1 << 31) //Lower-Word
  mov r1,# (1 << 31)  //Higher-Word

  //Zahl 2
  mov r2,# (1 << 31) //Lower-Word
  mov r3,# (1 << 31) //Higher-Word

  //Starten mit der Addition
  adds r4, r0, r2 //Lower-Word Ergebnis
  mov r7,#0 
  movcs r7,#1 //Überlauf temporär speichern falls C Flag = 1

  adds r5, r1, r2 //Higher-Word Ergebnis
  mov r8,#0
  movcs r8,#1 //Überlauf temporär speichern falls C Flag = 1

  adds r5, r7, r5 //Überlauf von Lower mit Higher addieren & überlauf speichern
  mov r9,#0
  movcs r9,#1

  add r6, r9, r8 //Beide Überläufe addieren


stop:
	nop
	bal stop

.end
