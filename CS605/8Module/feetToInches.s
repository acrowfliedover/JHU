#
#Program Name: 	feetToInches.s
#Author: 	Rong Fan
#Date:		2/21/2024
#Purpose:	3.Convert feet and inches to inches

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
	LDR r1, =feet
	BL scanf

#Prompt for inches
	LDR r0, =askInch
	BL printf

#Ask for inches
	LDR r0, =formatString
	LDR r1, =inch
	BL scanf
	
#Do calculation
	LDR r6, =feet
	LDR r6, [r6]
	LSL r5, r6, #3 	// r5 = r6 * 8
	LSL r4, r6, #2	// r4 = r6 * 4
	ADD r3, r4, r5	// r3 = r6 * 12
	
	LDR r2, =inch
	LDR r2, [r2]
	ADD r1, r2, r3 	// r1 = r2 + r3
	
#output
	LDR r0, =output
	BL printf

#Add back to stack
	LDR lr, [sp, #0]
	ADD sp, sp, #4
	MOV pc, lr

.data
	askInt: .asciz "Hello user 10001, please give me a feet number. \n"
	feet: .word 0
	askInch: .asciz "And a inch number. \n"
	inch: .word 0
	formatString: .asciz " %d"
	output: .asciz "That is %d inches. \n"
#End main
