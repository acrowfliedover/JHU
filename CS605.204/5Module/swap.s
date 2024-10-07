#
#Program Name: 	swap.s
#Author: 	Rong Fan
#Date:		2/21/2024
#Purpose:	EC.Swap two numbers without using extra space
#
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
	LDR r1, =integer1
	BL scanf

#Prompt for second int
	LDR r0, =askInt2
	BL printf

#Input second int
	LDR r0, =formatString
	LDR r1, =integer2
	BL scanf	

#Do swap
	LDR r1, =integer1
	LDR r1, [r1]
	LDR r2, =integer2
	LDR r2, [r2]
	EOR r1, r2	// r1 = r1 EOR r2
	EOR r2, r1	// r2 = r2 EOR (r1 EOR r2) = r2 EOR r2 EOR r1 = r1
	EOR r1, r2 	// r1 EOR r2 EOR r1 = r2	

#output
	LDR r0, =output
	BL printf

#Add back to stack
	LDR lr, [sp, #0]
	ADD sp, sp, #4
	MOV pc, lr

.data
	askInt: .asciz "Hello user 10001, please give me an integer. \n"
	integer1: .word 0
	askInt2: .asciz "Please give me another one. \n"
	integer2: .word 0
	formatString: .asciz " %d"
	output: .asciz "Integer 1 is now %d and integer 2 is now %d. They are swapped. \n (they are not swapped in memory but just swapped in registers) \n"
#End main
