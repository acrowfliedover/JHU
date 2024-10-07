#
#Program Name: 	assignment4ec.s
#Author: 	Rong Fan
#Date:		2/17/2024
#Purpose: 	5.take in a float from scanf and output a float using printf
#
.text

.global main
main:

#take from stack
	SUB sp, sp, #4
	STR lr, [sp, #0]

#Ask for a float
	LDR r0, =askFloat
	BL printf 


#Input a float
	LDR r0, =formatFloat
	LDR r1, =myFloat
	BL scanf

#Convert the float to a double

#output

#Add back to stack
	LDR lr, [sp, #0]
	ADD sp, sp, #4
	MOV pc, lr

.data

	askFloat:	 .asciz "Hello user 10001, please give me a float32 \n"
.align 2
	myFloat:	 .word 0
	secondFloat:	 .float 56.78
	double:		 .double 0.1
	output:		 .asciz "You entered %f displayed as float64 \n"
	formatFloat:	 .asciz "%f"
	formatFloat64:	 .asciz "%f"
#End main
