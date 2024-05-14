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
    
    bl delay_function

    subs r4,#1
    bne while
  
  b stop
  
delay_function:

  stmfd sp!, {r0, lr} //Speichern von dem Arbeitsregister
  ldr r0, =DELAY_CONSTANT

  loop:
    subs r0, r0, #1
    bne loop
  
  ldmfd sp!, {r0, pc}

stop:
	nop
	bal stop

.end
