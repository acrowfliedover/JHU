#
# File name: mainAssignment10.s
# Author: Rong Fan
# Date: 04/06/2024
# Purpose: This is the main program used to test and run the 2 functions in libAssignment10.s

.text
.global main

main:
# store lr on stack
	SUB sp, sp, #4
	STR lr, [sp]

input:
# Prompt user for a function to use
	LDR r0, =askFunction
	BL printf

# Input number
	LDR r0, =formatDecimal
	LDR r1, =action
	BL scanf

# Load number inputted
	LDR r0, =action
	LDR r1, [r0]

# Case 1 run function checkPrime
	CMP r1, #1
	BNE case2
		LDR r0, =askPrime
		BL printf
		LDR r0, =formatDecimal
		LDR r1, =number
		BL scanf
		LDR r3, =number
		LDR r3, [r3]

	# check if input is 1, 0 or negative
		CMP r3, #1
		BGT greaterThan1
			LDR r0, =outputInvalid
			BL printf
			B input

	# check if input is 2 or 3
	greaterThan1:
		CMP r3, #3
		BGT greaterThan3
			LDR r0, =outputIsPrime
			BL printf
			B input

	# check other cases
	greaterThan3:
		MOV r0, r3
		BL checkPrime
		CMP r0, #1
		BEQ isPrime
			LDR r0, =outputIsNotPrime
			BL printf
			B input
	
	# if it is prime
	isPrime:
		LDR r0, =outputIsPrime
		BL printf
		B input

# Case 2 run function guessRandom
case2:
	CMP r1, #2
	BNE case0
	askAgain:
		LDR r0, =askMaximum
		BL printf
		LDR r0, =formatDecimal
		LDR r1, =number
		BL scanf
		LDR r0, =number
		LDR r0, [r0]
		CMP r0, #1
		BLT invalidMaximum
			BL guessRandom
			B input
 	invalidMaximum:
		LDR r0, =outputInvalid
		BL printf
		B askAgain

# Case -1 exit the program, else return to input
case0:
	CMP r1, #-1
	BEQ endProgram
		LDR r0, =askNewCommand
		BL printf
		B input

endProgram:
# move lr back and return
	LDR lr, [sp]
	ADD sp, #4
	MOV pc, lr

.data
	askFunction: .asciz "\nHello user 10001, please give a me a number to test for functions.\nEnter [1] to test checkPrime. \nEnter [2] to test guessRandom. \nEnter [-1] to exit. \n"
	askPrime: .asciz "Please enter an integer and I will tell you whether or not it's a prime. \n"
	askMaximum: .asciz "Please enter the maximum number you want to guess. The random number will be between 1 and the number you gave.\n"
	askNewCommand: .asciz "You entered a non-valid command, please enter a correct number. \n"

	formatDecimal: .asciz "%d"

	outputInvalid: .asciz "You entered an invalid integer, please enter a number larger than 1. \n"
	outputIsPrime: .asciz "That is a prime number"
	outputIsNotPrime: .asciz "That is not a prime number"
	
	action: .word 0
	number: .word 0

# End main
