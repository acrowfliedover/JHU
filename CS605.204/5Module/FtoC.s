#
#Program Name: 	FtoC.s
#Author: 	Rong Fan
#Date:		2/21/2024
#Purpose:	1.Convert a user input in degree F to C

.text
.global main
main:

#take from stack
	SUB sp, sp, #4
	STR lr, [sp, #0]

#Prompt for user input
	LDR r0, =askInt
	BL printf 

#Ask for an Int
	LDR r0, =formatString
	LDR r1, =degree
	BL scanf

	
#Do calculation
	LDR r6, =degree
	LDR r3, [r6]
	
	SUB r2, r3, #32	// r2 = r3 - 32
	LSL r1, r2, #2	// r1 = r2 * 4
	ADD r0, r1, r2	// r0 = r2 * 5
	MOV r1, #9
	BL __aeabi_idiv	// r0 = r0 / r1
	
	MOV r2, r0
#output
	LDR r0, =output
	LDR r1, =degree
	LDR r1, [r1]
	BL printf

#Add back to stack
	LDR lr, [sp, #0]
	ADD sp, sp, #4
	MOV pc, lr

.data
	askInt: .asciz "Hello user 10001, tell me your temperature in Fahrenheit. \n"
	degree: .word 0
	formatString: .asciz " %d"
	output: .asciz "%d F is %d C \n"
#End main
