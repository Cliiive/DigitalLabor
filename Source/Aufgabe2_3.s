/*
 * Aufgabe_2_3.S
 *
 * SoSe 2024
 *
 *  Created on: <14.04.2024>
 *      Author: <Jonas Sasowski>
 *
 *	Aufgabe : Werte Binarisieren
 */
.text /* Specify that code goes in text segment */
.code 32 /* Select ARM instruction set */
.global main /* Specify global symbol */
main:  
  //Ausgaberegister Initialisieren
  mov r0,#0
  
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
  
  //Datenmenge
  mov r4,#8

  //Schwellenwert
  mov r2,#0

  //Datenzeiger auf das erste Element
  ldr r5,=data

  
  //While (Datenmenge != 0):
  while:
    //Fehler im Struktogramm: das schieben Erflogt immer nach dem verodern
    //D.h das 0-te nibble wird immer leer sein
    //Lösung: Am anfang der while schleife schieben
     
    //um ein nibble nach links schieben
    mov r0, r0, lsl#4

    //r2 mit wert aus r8 laden und Datenzeiger Inkrementieren
    ldr r1, [r5]
    add r5, r5, #4

    //Vergleichen mit dem Schwellwert
    cmp r1, r2
    movgt r1,#1
    movle r1,#0
    
    //Register verodern
    orr r0, r0, r1

    //Datenmenge-- & s
    subs r4,#1
    bne while

  
stop:
	nop
	bal stop

.end
