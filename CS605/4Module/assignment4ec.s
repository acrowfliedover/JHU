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
	LDR r1, =float
	BL scanf

#Convert the float to a double
	LDR r0, =float
	LDR r1, =double
	VLDR s1, [r0]
#	VLDR d2, [r1]
	VCVT.F64.F32 d2,s1
	VSTR.f64 d2,[r1]	

#output
	LDR r0, =output
	LDR r1, =double
	LDR r1, [r1, #0]
	BL printf

#Add back to stack
	LDR lr, [sp, #0]
	ADD sp, sp, #4
	MOV pc, lr

.data
	askFloat: .asciz "Hello user 10001, please give me a float32 \n"
	float: .word 0
	double: .double 0
	output: .asciz "You entered %.15f displayed a float64 \n"
	formatFloat: .asciz " %f"
	formatFloat64: .asciz ".15f"
#End main
