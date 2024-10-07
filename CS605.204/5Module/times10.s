#
#Program Name: 	times10.s
#Author: 	Rong Fan
#Date:		2/21/2024
#Purpose:	4.Multiply user input by 10

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
	LDR r1, =integer
	LDR r1, [r1]
	
	LSL r5, r1, #3 	// r5 = r1 * 8
	LSL r4, r1, #1	// r4 = r1 * 2
	ADD r2, r4, r5	// r2 = r1 * 10
	
#output
	LDR r0, =output
	BL printf

#Add back to stack
	LDR lr, [sp, #0]
	ADD sp, sp, #4
	MOV pc, lr

.data
	askInt: .asciz "Hello user 10001, please give me an integer. \n"
	integer: .word 0
	formatString: .asciz " %d"
	output: .asciz "%d times 10 is %d. \n"
#End main
