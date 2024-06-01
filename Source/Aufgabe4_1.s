/*
 * Aufgabe_4_1.S
 *
 * SoSe 2024
 *
 *  Created on: <$Date>
 *      Author: <$Name>
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
  
  //Lokale variablen anlegen
  variable_a:
  .byte 0xaa
  
  variable_b:
  .hword 0xbbbb
  
  variable_c:
  .word 0xcccccccc

  //variablen auf dem Stack initialisieren
  //a
  ldr r0,=#variable_a
  ldrb r0, [r0]
  push {r0}

  //b
  ldr r0,=#variable_b
  ldrh r0, [r0]
  push {r0}

  //c
  ldr r0,=#variable_c
  ldr r0, [r0]
  push {r0}

  ldr r0, [sp, #8] //a in r0 laden
  ldr r1, [sp, #4] //b in r1 laden

  bl function_2

  str r0, [sp] //wert von r0 in c speichern
  
  //Stack bereinigen & Register zurückschreiben
  add sp, sp, #12
  pop {r0, r1, pc}


function_2:
  //r1 von r0 subtrahieren
  subs r0, r0, r1
  
  //Betrag von r0 bilden
  cmp r0,#0
  rsbmi r0, r0, #0

  bx lr

  

.end