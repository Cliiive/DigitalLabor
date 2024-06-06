/*
 * Aufgabe_5_1.S
 *
 * SoSe 2024
 *
 *  Created on: <06.06.2024>
 *      Author: <Jonas Sasowski>
 *
 *	Aufgabe : Fortschrittsanzeige
 */
.text /* Specify that code goes in text segment */
.code 32 /* Select ARM instruction set */
.global main /* Specify global symbol */

.equ IODIR1, 0xE0028018
.equ IOSET1, 0xE0028014

.equ LED_bm, (1<<16)

.equ RESET_MASK, 0x00FF0000

main:
  ldr sp, =0x40001000 //Stack initialisieren

  //alle Lampen aus schalten
  ldr r0, =IODIR1 //Adresse in r0 laden
  ldr r1, =RESET_MASK //Maske um die register zurückzusetzen in r1 laden
  str r1, [r0] //register der lampen auf 1 setzen (senden)
  
  ldr r2, =0x8 //Zähler für den loop
  ldr r3, =LED_bm //Maske für die erste Lampe
  ldr r4, =IOSET1 //Adresse vom SET Register in r4 laden
  loop:
    ldr r1, [r4] //Inhalt von r4 in r1 laden
    orr r3, r3, r1 //LED_bm mit dem inhalt von SET register verodern
    str r3, [r4] //Ergebnis im SET Register speichern (lampe geht an)
    mov r3, r3, lsl#1 //Maske um 1 bit nach links verschieben

    ldr r5, =0xFFFFFF //Delay parameter
    push {r5} //Parameter auf dem Stack übergeben
    bl delay_function

    subs r2, r2, #1
    bne loop
    
stop:
	nop
	bal stop

delay_function:
  push {r0, lr} //Speichern von dem Arbeitsregister
  ldr r0, [sp, #8]  // Lade den Parameter vom Stack in r0 (Offset 8 wegen push => sp ist gerade auf lr)
  delay_loop:
    subs r0, r0, #1
    bne delay_loop
  
  pop {r0, pc}

.end