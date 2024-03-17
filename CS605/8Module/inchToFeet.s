#
#Program Name: 	inchToFeet.s
#Author: 	Rong Fan
#Date:		2/21/2024
#Purpose:	3.Convert inches to feet and inches

.text
.global main
main:

#take from stack
	SUB sp, sp, #4
	STR lr, [sp, #0]

#Prompt for user input feet
	LDR r0, =askInt
	BL printf 

#Ask for an Int
	LDR r0, =formatString
	LDR r1, =inch
	BL scanf
	
#Do calculation
	LDR r6, =inch
	LDR r6, [r6]
	MOV r0, r6 	// prepare for division
	MOV r1, #12
	BL __aeabi_idiv
	
	LSL r5, r0, #3 	// r5 = r0 * 8
	LSL r4, r0, #2	// r4 = r0 * 4
	ADD r3, r4, r5	// r3 = r0 * 12
	SUB r2, r6, r3 	// r2 is the remainder
	
#output
	MOV r1, r0
	LDR r0, =output
	BL printf

#Add back to stack
	LDR lr, [sp, #0]
	ADD sp, sp, #4
	MOV pc, lr

.data
	askInt: .asciz "Hello user 10001, please give me a number of inches. \n"
	inch: .word 0
	formatString: .asciz " %d"
	feet: .word 0
	output: .asciz "That is %d feet and %d inches. \n"
#End main
