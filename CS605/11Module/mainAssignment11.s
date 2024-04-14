#
# File name: mainAssignment10.s
# Author: Rong Fan
# Date: 04/10/2024
# Purpose: This is the main program used to test and run the 2 functions in libAssignment11.s
# Testing functions 1. Mult, 2. Fib

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

# Case 1 run function Mult
	CMP r1, #1
	BNE case2
	# ask for inputs
		LDR r0, =askMult
		BL printf
		LDR r0, =formatDecimal
		LDR r1, =number1
		BL scanf
		LDR r0, =formatDecimal
		LDR r1, =number2
		BL scanf

	# load the variables and call Mult
		LDR r0, =number1
		LDR r0, [r0]
		LDR r1, =number2
		LDR r1, [r1]
		BL Mult
		
	# output result
		MOV r1, r0
		LDR r0, =outputMult
		BL printf
		B input

# Case 2 run function Fib
case2:
	CMP r1, #2
	BNE case0
	askAgain:
	# ask for an integer
		LDR r0, =askFib
		BL printf
		LDR r0, =formatDecimal
		LDR r1, =number1
		BL scanf
		LDR r0, =number1
		LDR r0, [r0]

	# check if input is valid
		CMP r0, #0
		BLT invalidFib
			BL Fib

	# output result
			MOV r2, r0
			LDR r0, =outputFib
			LDR r1, =number1
			LDR r1, [r1]
			BL printf
			B input

 	invalidFib:
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
	askFunction: .asciz "\nHello user 10001, please give me a number to test for functions.\nEnter [1] to test Mult. \nEnter [2] to test Fib. \nEnter [-1] to exit. \n"
	askMult: .asciz "Please enter two integers and I will give you their products. \n"
	askFib: .asciz "Please enter an integer n and I will give you the nth Fibonacci number. \n"
	askNewCommand: .asciz "You entered a non-valid command, please enter a correct number. \n"

	formatDecimal: .asciz "%d"

	outputInvalid: .asciz "You entered an invalid integer, please enter a number larger than 0. \n"
	outputMult: .asciz "Their product is %d"
	outputFib: .asciz "The %dth Fibonacchi number is %d"
	
	action: .word 0
	number1: .word 0
	number2: .word 0

# End main
