#
#Program Name: 	assignment4.s
#Author: 	Rong Fan
#Date:		2/17/2024
#Purpose:	1.Ask User's age and output it
#		2.Output string with tabs
#		3.Quotes in formated string 

.text
.global main
main:

#take from stack
	SUB sp, sp, #4
	STR lr, [sp, #0]

#Hello What's your name?
	LDR r0, =askName
	BL printf 

#Ask for name
	LDR r0, =formatString
	LDR r1, =name
	BL scanf

#What is your age?
	LDR r0, =askAge
	LDR r1, =name
	BL printf
	
#Ask for age
	LDR r0, =formatInt
	LDR r1, =age
	BL scanf

#output
	LDR r0, =output
	LDR r1, =name
	LDR r2, =age
	LDR r2, [r2, #0]
	BL printf

#Add back to stack
	LDR lr, [sp, #0]
	ADD sp, sp, #4
	MOV pc, lr

.data
	askName: .asciz "Hello user 10001, What is your name? \n"
	name: .space 40
	formatString: .asciz " %s"
	askAge: .asciz "What is your age, %s? \n"
	age: .word 0
	output: .asciz "Hi %s, so how did your last\t %d\t years go? \"Wink\" \"Wink\" \n"
	formatInt: .asciz " %d"
#End main
