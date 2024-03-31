#
# File name: mainAssignment9.s
# Author: Rong Fan
# Date: 03/30/2024
# Purpose: This is the main program used to test and run the 4 functions in libAssignment9.s

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
	LDR r4, [r0]

# Case 1 run function checkAlphaChar
	CMP r4, #1
	BNE case2
		LDR r0, =askChar
		BL printf
		LDR r0, =formatChar
		LDR r1, =character
		BL scanf
		LDR r0, =character
		LDR r0, [r0]
		BL checkAlphaChar
	# Processing output
		CMP r0, #0
		BEQ notLetter
			LDR r0, =outputIsLetter
			BL printf
			B input	
		notLetter:
		LDR r0, =outputIsNotLetter
		BL printf
		B input

# Case 2 run function checkAlphaCharWithoutLogical
case2:
	CMP r4, #2
	BNE case3
		LDR r0, =askChar
		BL printf
		LDR r0, =formatChar
		LDR r1, =character
		BL scanf
		LDR r0, =character
		LDR r0, [r0]
		BL checkAlphaCharWithoutLogical

	# Processing output
		CMP r0, #0
		BEQ notLetter2
			LDR r0, =outputIsLetter
			BL printf
			B input
		notLetter2:
		LDR r0, =outputIsNotLetter
		BL printf
		B input

# Case 3 run function gradeCheck
case3:
	CMP r4, #3
	BNE case4
	# Ask user for name
		LDR r0, =askName
		BL printf
		LDR r0, =formatString
		LDR r1, =name
		BL scanf

	# Ask user for grade
		LDR r0, =askGrade
		BL printf
		LDR r0, =formatDecimal
		LDR r1, =grade
		BL scanf

	# Processing input, note that outputting grade is done in gradeCheck
		LDR r0, =outputName
		LDR r1, =name
		BL printf
		LDR r0, =grade
		LDR r0, [r0]
		BL gradeCheck
		B input

# Case 4 run function findMaxOf3
case4:
	CMP r4, #4
	BNE case0
	# Ask user for 3 integers
		LDR r0, =askFirstInt
		BL printf
		LDR r0, =formatDecimal
		LDR r1, =int1
		BL scanf

		LDR r0, =askSecondInt
		BL printf
		LDR r0, =formatDecimal
		LDR r1, =int2
		BL scanf

		LDR r0, =askLastInt
		BL printf
		LDR r0, =formatDecimal
		LDR r1, =int3
		BL scanf

	# Process input
		LDR r0, =int1
		LDR r0, [r0]
		LDR r1, =int2
		LDR r1, [r1]
		LDR r2, =int3
		LDR r2, [r2]
		BL findMaxOf3
	
	# Output
		MOV r1, r0
		LDR r0, =outputMax
		BL printf
		B input 

# Case 0 exit the program, else return to input
case0:
	CMP r4, #0
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
	askFunction: .asciz "\nHello user 10001, please give a me a number to test for functions.\nEnter [1] to test checkAlphaChar. \nEnter [2] to test checkAlphaCharWithoutLogical. \nEnter [3] to test gradeCheck. \nEnter [4] to test findMaxOf3. \nEnter [0] to exit. \n"
	askChar: .asciz "Please enter a character and I will tell you whether or not it's a letter. \n"
	askName: .asciz "Please enter your name. \n"
	askGrade: .asciz "Please enter your grade that is an integer. \n"
	askFirstInt: .asciz "Please enter an integer \n"
	askSecondInt: .asciz "Please enter another integer \n"
	askLastInt: .asciz "Please enter the last integer \n"
	askNewCommand: .asciz "You entered a non-valid command, please enter a correct number. \n"

	formatDecimal: .asciz "%d"
	formatChar: .asciz "%s"
	formatString: .asciz "%s"	

	outputIsLetter: .asciz "You entered an alphabetic character. \n"
	outputIsNotLetter: .asciz "You entered a non-alphabetic character. \n"
	outputName: .asciz "Hi %s, "
	outputMax: .asciz "The max of the three is %d \n"
	
	action: .word 0
	character: .word 0
	name: .space 20
	grade: .word 0
	int1: .word 0
	int2: .word 0
	int3: .word 0

# End main
