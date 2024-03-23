/*
 * Aufgabe_1_3.S
 *
 * SoSe 2024
 *
 *  Created on: <23.03.2024>
 *      Author: <Jonas Sasowski>
 *
 *	Aufgabe : Flags und bedingte Ausführung
 */
.text /* Specify that code goes in text segment */
.code 32 /* Select ARM instruction set */
.global main /* Specify global symbol */
main:
  //Version 1
  mov r0,#3 //value
  mov r1,#2 //threshold
  cmp r0, r1 
  bgt greater //größer
  ble lesser //kleiner oder gleich


greater:
  mov r0, #1
  b version2

lesser:
  mov r0, #0
  b version2

//Version 2
version2:
  //Test1
  mov r0,#1 //value
  mov r1,#2 //threshold
  cmp r0,r1
  movgt r0,#1
  movle r0,#0

  //Test2
  mov r0,#2 //value
  mov r1,#2 //threshold
  cmp r0,r1
  movgt r0,#1
  movle r0,#0

  //Test3
  mov r0,#3 //value
  mov r1,#2 //threshold
  cmp r0,r1
  movgt r0,#1
  movle r0,#0

  //Test4
  mov r0,#0 //value
  mov r1,#2 //threshold
  cmp r0,r1
  movgt r0,#1
  movle r0,#0

  //Test5
  mov r0,#0xFFFFFFF //value
  mov r1,#2 //threshold
  cmp r0,r1
  movgt r0,#1
  movle r0,#0
  

stop:
	nop
	bal stop


.end