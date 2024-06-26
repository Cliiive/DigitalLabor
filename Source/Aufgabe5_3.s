/*
 * Aufgabe_5_3.S
 *
 * SoSe 2024
 *
 *  Created on: <Jonas Sasowski>
 *      Author: <09.06.2024>
 *
 *	Aufgabe : Ein- und Ausgabe über Taster und LEDs
 */
.text /* Specify that code goes in text segment */
.code 32 /* Select ARM instruction set */
.global main /* Specify global symbol */


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
  ldr sp, =0x40001000 //Stack initialisieren

  ldr r4, =IOPIN0 //Adresse von Port 0 in r4 laden

  ldr r0, =IOPIN1 //Adresse von Port 1 in r0 laden

  ldr r1, =IODIR //Offset
  add r1, r0, r1 //IODIR1 in r1 laden
  ldr r2, =(LED_0_bm | LED_1_bm | LED_2_bm | LED_3_bm | LED_4_bm | LED_5_bm | LED_6_bm | LED_7_bm)  //Maske um die register zurückzusetzen in r1 laden
  str r2, [r1] //Lampen auf senden setzen

  ldr r2, =IOSET //Offset
  add r2, r0, r2 //IOSET1 in r2 laden

  ldr r3, =IOCLR //Offset
  add r3, r0, r3 //IOCLR1 in r3 laden

  loop:
  ldr r1, =0x2
  mov r7, #BUTTON_0_bm
  mov r8, #LED_0_bm
  bl switch_leds //Button in r7, LED in r8

  mov r7, #BUTTON_1_bm
  mov r8, #LED_1_bm
  bl switch_leds //Button in r7, LED in r8

  mov r7, #BUTTON_2_bm
  mov r8, #LED_4_bm
  bl switch_leds //Button in r7, LED in r8

  mov r7, #BUTTON_3_bm
  mov r8, #LED_5_bm
  bl switch_leds //Button in r7, LED in r8

  b loop


stop:
	nop
	bal stop

switch_leds:
  push {r0-r6}
  mov r6, r8 // Load mask for the LED 0 in r6
  mov r5, r7 // Load mask for the button 0 in r5
  ldr r0, [r4] // Load input values from IOPIN to register r0
  ands r0, r5, r0 // check if button 0 is pressed
  beq noled1 // branch if button is not pressed

  // button is pressed,
  str r6, [r2] // switch pins defined in r9 on (IOSET1) (first LED on)
  mov r6, r6, lsl r1 // shift mask to second LED
  str r6, [r3] // switch pins defined in r9 off (IOCLR1) (second LED off)
  b led_done // brunch to end

  // button is not pressed
  noled1:
  str r6, [r3] // switch pins defined in r9 off (IOCLR1) (first LED off)
  mov r6, r6, lsl r1 // shift mask to second LED
  str r6, [r2] // switch pins defined in r9 on (IOSET1) (second LED on)
  led_done: // End subrutine
  
  pop {r0-r6}
  bx lr  

.end