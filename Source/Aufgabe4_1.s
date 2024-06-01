/*
 * Aufgabe_4_1.S
 *
 * SoSe 2024
 *
 *  Created on: <01.06.2024>
 *      Author: <Jonas Sasowski>
 *
 *	Aufgabe : Verwendung von Stack
 */
.text /* Specify that code goes in text segment */
.code 32 /* Select ARM instruction set */
.global main /* Specify global symbol */

main:
  mov r0, #0x44
  mov r1, #0x55

  mov r2, #3 //Counter

  loop:
    bl function_1
    subs r2, r2, #1
    bne loop

stop:
	nop
	bal stop

function_1:
  push {r0, r1, lr}

  //speicher für lokale Variablen allokieren
  sub sp, sp, #8
  
  //variablen auf dem Stack initialisieren
  //a
  ldr r0,=-5
  strb r0, [sp]

  //b
  ldr r0,=2
  strh r0, [sp, #2] 

  //c
  ldr r0,=0
  str r0, [sp, #4]

  ldrsb r0, [sp] //a in r0 laden
  ldrh r1, [sp, #2] //b in r1 laden

  bl function_2

  str r0, [sp, #4] //wert von r0 in c speichern
  
  //Stack bereinigen & Register zurückschreiben
  add sp, sp, #8
  pop {r0, r1, pc}


function_2:
  //r1 von r0 subtrahieren
  subs r0, r0, r1
  
  //Betrag von r0 bilden
  cmp r0,#0
  rsbmi r0, r0, #0

  bx lr

  

.end