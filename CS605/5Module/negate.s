#
#Program Name: 	negate.s
#Author: 	Rong Fan
#Date:		2/21/2024
#Purpose:	2.Convert an integer to its negative

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
	LDR r1, =integer
	BL scanf

	
#Do calculation
	LDR r6, =integer
	LDR r4, [r6]
	MVN r3, r4	// negate all bits of r6
	ADD r2, r3, #1	// r2 = r3 + 1
	
#output
	LDR r0, =output
	LDR r1, =integer
	LDR r1, [r1]
	BL printf

#Add back to stack
	LDR lr, [sp, #0]
	ADD sp, sp, #4
	MOV pc, lr

.data
	askInt: .asciz "Hello user 10001, please give me an integer. \n"
	integer: .word 0
	formatString: .asciz " %d"
	output: .asciz "negative %d is %d. \n"
#End main
