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

.equ BUTTON_0_bm, (1<<0)
.equ BUTTON_1_bm, (1<<1)
.equ BUTTON_2_bm, (1<<2)
.equ BUTTON_3_bm, (1<<3)

.equ LED_0_bm, 1<<0
.equ LED_1_bm, 1<<1
.equ LED_2_bm, 1<<2
.equ LED_3_bm, 1<<3
.equ LED_4_bm, 1<<4
.equ LED_5_bm, 1<<5
.equ LED_6_bm, 1<<6
.equ LED_7_bm, 1<<7

swi_handler:
  STMFD R13!,{R0-R5,R14} // Arbeitsregister sichern (R14 RücksprungAdresse) (R13 Stackpointer)

  ldr R3,[R14,#-4] // den Opcode der SWI Funktion holen
  bic R3,R3,#0xff000000 // Opcode der SWI Anweisung entfernen


  ldr R5, =#0xffff // Lade 0xffff in ein Register
  bic R4, R3, R5 // Parameter entfernen (Bits 15..0)

  ands R2, R3,#0xff00 //Parameter 1 extrahieren
  lsr R2, #8 //normalisieren
  movne R1, R2 //Falls gültig parameter in R1 laden

  ands R2, R3,#0xff //Parameter 2 extrahieren
  movne R0, R2 //Falls gültig parameter in R0 laden

  ldr R2,=EntryTable // lade Adresse der Funktionstabelle
  ldr R2,[R2,R4,LSR#14] //Zeiger auf Funktion zusammensetzen
  bx R2 // führe die Funktion aus (adresse in PC laden)

swi_end:
  LDMFD R13!,{R0-R5,R15}^// Arbeitsregister wiederherstellen

_ledInit:
  //In R0 liegt der Parameter für die lampe die an gehen soll

  push {r0-r3}

  ldr r2, =IOPIN1
  add r2, #IODIR
  ldr r3, [r2] //Inhalt von IODIR1 in r3 laden

  lsl r0, #16 //LED Parameter um 16 nach links shiften
  orr r0, r0, r3 //Verodern
  str r0, [r2] //Ergebnis im SET register speichern

  pop {r0-r3}
  b swi_end

_ledOn:
  //In R0 liegt der Parameter für die lampe die an gehen soll

  push {r0-r3}

  ldr r2, =IOPIN1
  add r2, #IOSET
  ldr r3, [r2] //Inhalt von IOSET1 in r3 laden

  lsl r0, #16 //LED Parameter um 16 nach links shiften
  orr r0, r0, r3 //Verodern
  str r0, [r2] //Ergebnis im SET register speichern

  pop {r0-r3}
  b swi_end

_ledOff:
  //In R0 liegt der Parameter für die lampe die an gehen soll
  push {r0-r3}

  ldr r2, =IOPIN1
  add r2, #IOCLR
  ldr r3, [r2] //Inhalt von IOCLR1 in r3 laden

  lsl r0, #16 //LED Parameter um 16 nach links shiften
  orr r0, r0, r3
  str r0, [r2] //Ergebnis im SET register speichern

  pop {r0-r3}
  b swi_end

_ledToggle:
  //In R0 liegt der Parameter für die lampe die an gehen soll
  push {r0-r3}

  lsl r0, #16 //LED Parameter um 16 nach links shiften

  ldr r2, =IOPIN1
  ldr r3, [r2] //Inhalt von IOCLR1 in r3 laden
  and r1, r0, r3
  cmp r1, r0

  beq ledIsOn
  b ledIsOff

  ledIsOn:
    ldr r2, =IOPIN1
    add r2, #IOCLR
    ldr r3, [r2] //Inhalt von IOCLR1 in r3 laden
    orr r0, r0, r3
    str r0, [r2] //Ergebnis im SET register speichern
    b toggleEnd

  ledIsOff:
    ldr r2, =IOPIN1
    add r2, #IOSET
    ldr r3, [r2] //Inhalt von IOSET1 in r3 laden
    orr r0, r0, r3 //Verodern
    str r0, [r2] //Ergebnis im SET register speichern

  toggleEnd:
    pop {r0-r3}
    b swi_end
  
_keyInit:
  push {r0-r2}
  lsl r0, #10 //Parameter um 10 nach links shiften
  mvn r0, r0 //Register invertieren

  ldr r1, =IOPIN0
  add r1, #IODIR
  ldr r2, [r1]
  and r0, r2
  str r0, [r1]

  pop {r0-r2}
  b swi_end
  
_isPressed:
  push {r1, r2}
  lsl r0, #10 //Parameter um 10 nach links shiften

  ldr r1, =IOPIN0 // Load input values from IOPIN to register r0
  ldr r2, [r1]
  ands r0, r0, r2 // check if button is pressed
  bne notPressed // branch if button is not pressed

  // button is pressed,
  mov r7, #1
  b check_done // brunch to end

  // button is not pressed
  notPressed:
    mov r7, #0
  
  // r0 = 0 if not pressed, r0 = 1 if pressed
  check_done:
    pop {r1, r2}
    b swi_end

_delay:
  
main:
  
  swi keyInit+BUTTON_0_bm
  swi ledInit+LED_0_bm
  swi ledInit+LED_1_bm
  swi ledInit+LED_2_bm
  swi ledInit+LED_3_bm
  swi ledInit+LED_4_bm
  swi ledInit+LED_5_bm
  swi ledInit+LED_6_bm
  swi ledInit+LED_7_bm
  
  jump:
  swi isPressed+BUTTON_0_bm
  cmp r7, #1

  swieq ledOn+LED_0_bm
  beq jump

  swi ledOff+LED_0_bm
  b jump
  
     
stop:
	nop
	bal stop

.end