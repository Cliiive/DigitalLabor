/*
 * Aufgabe_4_3.S
 *
 * SoSe 2024
 *
 *  Created on: <02.06.2024>
 *      Author: <Jonas Sasowski>
 *
 *	Aufgabe : Maximalwert eines Datenblocks ermitteln
 */
.text /* Specify that code goes in text segment */
.code 32 /* Select ARM instruction set */
.global main /* Specify global symbol */

//Test 1: Maximum kann berrechnet werden
Datablock_1:
  .hword 0xEEEE // Kennzeichnung
  .byte 4 // Size
  .byte 0 // Status
  .byte 0 // Max Value
  .byte 20, 140, 60, 30 // Data
  .byte 0, 0, 0 // Padding

//Test 2: Kennzeichnung falsch
Datablock_2:
  .hword 0xEEEF // Kennzeichnung
  .byte 4 // Size
  .byte 0 // Status
  .byte 0 // Max Value
  .byte 20, 140, 60, 30 // Data
  .byte 0, 0, 0 // Padding

//Test 3: Maximum schon berrechnet
Datablock_3:
  .hword 0xEEEE // Kennzeichnung
  .byte 4 // Size
  .byte 4 // Status
  .byte 140 // Max Value
  .byte 20, 140, 60, 30 // Data
  .byte 0, 0, 0 // Padding

main:

  ldr r0,=Datablock_1 //parameter (pointer auf kennzeichnung)
  bl max_data //datenzeiger auf kennzeichnung in r0 (fehlercode in r1)

stop:
	nop
	bal stop

max_data:
  push {r0, r2-r5, lr}

  ldrh r1, [r0] //Kennzeichnung laden

  ldr r2,=#0xEEEE
  cmp r1, r2 //Vergleichen mit gültiger Kennzeichnung

  //Falls nicht korrekt:
  movne r1,#-2
  bne function_end
  
  //Falls korrekt:
  ldrb r1, [r0, #3] //Status holen
  
  cmp r1,#0x0 //Maximum nicht eingetragen?

  //Falls maximum schon eingetragen
  movne r1,#-1
  bne function_end

  //Falls maximum noch nicht eingetragen
  mov r1,#0x0 //maximum = 0
  ldrb r3,[r0, #2] // Size holen
  mov r4, r0 // Temporären Datenzeiger initialisieren
  add r4, #5 //Zeiger auf Daten verschieben

  loop:
    ldrb r2, [r4] // Wert laden

    cmp r2, r1
    movgt r1, r2 // Max = Wert, falls Wert > Max

    add r4, #1 // Datenzeiger verschieben

    subs r3, #1
    bne loop
  
  mov r5, #0x4
  strb r5, [r0, #3] //Status ändern
  strb r1, [r0, #4] //Maximal wert speichern
  mov r1, #0x0

  function_end:
    pop {r0, r2-r5, pc}




.end