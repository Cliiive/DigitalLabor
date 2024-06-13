/*
 * Aufgabe_6.S
 *
 * SoSe 2024
 *
 *  Created on: <$Date>
 *      Author: <$Name>
 *
 *	Aufgabe : Softwareinterrupt
 */
.text /* Specify that code goes in text segment */
.code 32 /* Select ARM instruction set */
.global main /* Specify global symbol */
.global swi_handler /* Specify global symbol */

.equ ledInit, 0<<16
.equ ledOn, 1<<16
.equ ledOff, 2<<16
.equ ledToggle, 3<<16
.equ keyInit, 4<<16
.equ isPressed, 5<<16
.equ delay, 6<<16

EntryTable:
.word  _ledInit
.word  _ledOn
.word  _ledOff
.word  _ledToggle
.word  _keyInit
.word  _isPressed
.word  _delay


.equ IOPIN0, 0xE0028000
.equ IOPIN1, 0xE0028010

.equ IOSET, 0x04
.equ IODIR, 0x08
.equ IOCLR, 0x0C

.equ BUTTON_0_bm, (1<<10)
.equ BUTTON_1_bm, (1<<11)
.equ BUTTON_2_bm, (1<<12)
.equ BUTTON_3_bm, (1<<13)

.equ LED_0_bm, (1<<16)
.equ LED_1_bm, (1<<17)
.equ LED_2_bm, (1<<18)
.equ LED_3_bm, (1<<19)
.equ LED_4_bm, (1<<20)
.equ LED_5_bm, (1<<21)
.equ LED_6_bm, (1<<22)
.equ LED_7_bm, (1<<23)

main:


swi_handler:
  STMFD R13!,{R0-R3,R14} // Arbeitsregister sichern (R14 RücksprungAdresse) (R13 Stackpointer)

  ldr R3,[R14,#-4] // den Opcode der SWI Funktion holen
  bic R3,R3,#0xff000000 // Opcode der SWI Anweisung entfernen

  ldr R0, =#0xffff // Lade 0xffff in ein Register
  bic R1, R3, R0 // Parameter entfernen (Bits 15..0)
  ldr R2,=EntryTable // lade Adresse der Funktionstabelle
  ldr R15,[R2,R1,LSR#14] // führe die Funktion aus (adresse in PC laden)

swi_end:
  LDMFD R13!,{R0-R3,R15}^// Arbeitsregister wiederherstellen

_ledInit:
  
     

.end