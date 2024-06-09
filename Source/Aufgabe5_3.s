/*
 * Aufgabe_5_3.S
 *
 * SoSe 2024
 *
 *  Created on: <$Date>
 *      Author: <$Name>
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

.equ RESET_MASK, 0x00FF0000

main:

  loop:
  ldr r4, =IOPIN0

  ldr r0, =IOPIN1

  ldr r1, =IODIR
  add r1, r0, r1 
  ldr r2, =RESET_MASK //Maske um die register zurückzusetzen in r1 laden
  str r2, [r1] //register der lampen auf 1 setzen (senden)

  ldr r2, =IOSET
  add r2, r0, r2

  ldr r3, =IOCLR
  add r3, r0, r3

  bl switch_leds
  b loop


stop:
	nop
	bal stop

switch_leds:

  mov r6, #1<<16 // Load mask for the LED 0 in r6
  mov r5, #1<<10 // Load mask for the button 0 in r5
  ldr r0, [r4] // Load input values from IOPIN to register r0
  ands r0, r5, r0 // check if button 0 is pressed
  bne noled1 // branch if button is not pressed

  // button is pressed,
  str r6, [r2] // switch pins defined in r9 on (IOSET1) (first LED on)
  mov r6, r6, lsl #1 // shift mask to second LED
  str r6, [r3] // switch pins defined in r9 off (IOCLR1) (second LED off)
  b led_done // brunch to end

  // button is not pressed
  noled1:
  str r6, [r3] // switch pins defined in r9 off (IOCLR1) (first LED off)
  mov r6, r6, lsl #1 // shift mask to second LED
  str r6, [r2] // switch pins defined in r9 on (IOSET1) (second LED on)
  led_done: // End subrutine
  
  bx lr  

.end