#
#Program Name: 	CtoF.s
#Author: 	Rong Fan
#Date:		2/21/2024
#Purpose:	1.Convert a user input in degree C to F

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

	LSL r2, r3, #3 	// r2 = r3 multiply by 8
	ADD r0, r2, r3 	// r0 = r3 multiply by 9
	MOV r1, #5	// load r1 to be divided
	BL __aeabi_idiv	// division result stored to r0
	ADD r2, r0, #32	// store result of conversion in r2

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
	askInt: .asciz "Hello user 10001, tell me your temperature in Celsius. \n"
	degree: .word 0
	formatString: .asciz " %d"
	output: .asciz "%d C is %d F \n"
#End main
