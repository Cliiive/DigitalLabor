/*
 * Aufgabe_1_4.S
 *
 * SoSe 2024
 *
 *  Created on: <24.03.2024>
 *      Author: <Jonas Sasowski>
 *
 *	Aufgabe : Maskenoperationen
 */
.text /* Specify that code goes in text segment */
.code 32 /* Select ARM instruction set */
.global main /* Specify global symbol */
main:
  //Nibble 0
  .equ BREAD_bm, (1 << 0)
  .equ BUTTER_bm, (1 << 1)
  .equ CHEESE_bm, (1 << 2)
  
  //Nibble 1
  .equ ORANGE_bm, (1 << 4)
  .equ APPLE_bm, (1 << 5)
  .equ KIWI_bm, (1 << 6)
  
  //Nibble 3
  .equ ALMONDS_bm, (1 << 12)
  .equ WALNUTS_bm, (1 << 13)
  .equ PEANUTS_bm, (1 << 14)

  //Byte 1
  .equ WATER_bm, (1 << 8)
  .equ MILK_bm, (1 << 9)
  .equ RUM_bm, (1 << 10)
  .equ VODKA_bm, (1 << 11)
  .equ TEA_bm, (1 << 12)

  .equ BAKERY_GOODS_bm, (BREAD_bm | BUTTER_bm | CHEESE_bm)
  .equ FRUITS_bm, (ORANGE_bm | APPLE_bm | KIWI_bm)
  .equ NUTS_bm, (ALMONDS_bm | WALNUTS_bm | PEANUTS_bm)
  .equ DRINKS_bm, (WATER_bm | MILK_bm | RUM_bm | VODKA_bm | TEA_bm)

  .equ BREAKFAST_bm, (BAKERY_GOODS_bm | MILK_bm | PEANUTS_bm | KIWI_bm)

  ldr r0, =BREAKFAST_bm
  ldr r1, =(BREAKFAST_bm | FRUITS_bm)
  ldr r2, =(BREAKFAST_bm & ~MILK_bm | RUM_bm)
  ldr r3, =(((FRUITS_bm | MILK_bm) << 16) | MILK_bm)
  ldr r4, =((BREAKFAST_bm & ~(BUTTER_bm | CHEESE_bm | MILK_bm)) | WATER_bm)

stop:
	nop
	bal stop

.end

//1111 1111 1111 1111 1111 1111 1111 1111