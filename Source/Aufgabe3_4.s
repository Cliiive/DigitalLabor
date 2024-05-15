/*
 * Aufgabe_3_4.S
 *
 * SoSe 2024
 *
 *  Created on: <$Date>
 *      Author: <$Name>
 *
 *	Aufgabe : nterprogrammaufruf mit Übergebe von mehreren Parametern - Division
 */
.text /* Specify that code goes in text segment */
.code 32 /* Select ARM instruction set */
.global main /* Specify global symbol */
main:
  ldr r0,=7 //Dividend
  ldr r1,=2 //Divisor
  ldr r2,=0 //Qoutient
  ldr r3,=0 //Rest

  ldr r7,=0 // Error Register

  bl divide_function
  b stop
  //Ergebnis in r2, Rest in r3


divide_function:
  push {r4, r5, r6, lr} //Temporäre Register sichern

  // Laufzeitwerte initialisieren
  mov r4, r0 //Dividend
  mov r5, r1 //Divisor
  mov r6, r2 //Qoutient

  //Überprüfen ob der Divisor 0 ist
  cmp r1,#0
  moveq r7,#1
  beq stop

  division_loop:
    add r6, r6, #1
    subs r4, r4, r5
    bpl division_loop

    //Einen Schleifendurchlauf rückgängig machen
    sub r6, r6, #1
    add r4, r4, r5
  
  mov r2, r6 //Ergebnis in r2 speichern
  mov r3, r4 //Rest in r3 speichern
  pop {r4, r5, r6, pc}

stop:
	nop
	bal stop

.end
