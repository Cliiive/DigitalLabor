/*
 * Aufgabe_4_2.S
 *
 * SoSe 2024
 *
 *  Created on: <$Date>
 *      Author: <$Name>
 *
 *	Aufgabe : Addition von zwei 8 stelligen BCD Zahlen
 */
.text /* Specify that code goes in text segment */
.code 32 /* Select ARM instruction set */
.global main /* Specify global symbol */
main:

  ldr r0,=0x11751151 //parameter 1
  ldr r1,=0x11751151 //parameter 2
  bl bcd_addition //Rückgabe in r2

stop:
	nop
	bal stop

bcd_addition:
  push {r0-r1, r3-r8, lr}
  
  ldr r4,=8 //Stellenzähler
  ldr r3,=0x0000000f //Stellenmaske
  ldr r2,=0x00000000 //Rückgabewert
  ldr r5,=0//Überlauf
  
  loop:
    //Beide niderwertige Stellen isolieren
    and r6, r0, r3
    and r7, r1, r3
    
    add r8, r6, r7 //beide Stellen addieren (ggf flag setzen)

    add r8, r5 //überlauf berücksichtigen
    
    subs r8, #10
    //falls r8 >= 0
    movge r5, #1 //merke Üertrag

    //falls r8 < 0
    movlt r5, #0 //keinen übertrag merken
    addlt r8, #10 //wieder 10 addieren

    
    orr r2, r2, r8 //Ergebniss aktualisieren

    //Zahlen Rotieren
    mov r0, r0, ror #4
    mov r1, r1, ror #4
    mov r2, r2, ror #4

    subs r4, #1
    bne loop

  pop {r0-r1, r3-r8, pc}






    


    


    


    sub r2, r2, #1
    bne loop



.end