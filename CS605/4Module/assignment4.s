.text
.global main
main:

#take from stack
	SUB sp, sp, #4
	STR lr, [sp]

#Hello What's your name?
	LDR r0, =helloWorld
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
	LDR r0, =formatString
	LDR r1, =age
	BL scanf

#output
	LDR r0, =output
	LDR r1, =name
	LDR r2, =age
	BL printf

#Add back to stack
	LDR lr, [sp]
	ADD sp, sp, #4
	MOV pc, lr

.data
	helloWorld: .asciz "Hello World, What is your name? \n"
	name: .space 40
	askAge: .asciz "What is your age, %s? \n"
	age: .space 41
	output: .asciz "Hi %s, I know your age is %s. \n"
	formatString: .asciz "%s"
#End main
