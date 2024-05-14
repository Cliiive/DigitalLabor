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

//Daten
data:
  .word 0x1
  .word 0x2
  .word 0x3
  .word 0x4
  .word 0x5
  .word 0x6
  .word 0x7
  .word 0x8

main:
  mov r0,#0
  mov r4,#8
  mov r2,#0
  ldr r5,=data

  while:
    ldr r1, [r5]
    add r5, r5, #4
    cmp r1, r2
    movgt r1,#1
    movle r1,#0
    mov r0, r0, lsl#4
    orr r0, r0, r1
    
    mov r8,#3 //Parameter für delay
    bl delay_function

    subs r4,#1
    bne while
  
  b stop
  


delay_function:
  loop:
    subs r8, r8, #1
    bne loop
  bx lr


stop:
	nop
	bal stop

.end
