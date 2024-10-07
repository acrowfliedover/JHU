#
#Program Name: 	assignment4ec.s
#Author: 	Rong Fan
#Date:		2/17/2024
#Purpose: 	5.take in a float from scanf and output a float using printf
#
.text
.align 2
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

#Convert the float32 to float64 stored in 2 registers 
	LDR r0, =myFloat
	VLDR s0, [r0]	

	VCVT.F64.F32 d1,s0
	VMOV r1,r2,d1	

#output
	LDR r0, =output
	BL printf

#Add back to stack
	LDR lr, [sp, #0]
	ADD sp, sp, #4
	MOV pc, lr

.data
	askFloat:	 .asciz "Hello user 10001, please give me a float32 \n"
.align 2
	myFloat:	 .float 0.0
	output:		 .asciz "You entered %f displayed as float64 \n"
	formatFloat:	 .asciz "%f"
#End main
