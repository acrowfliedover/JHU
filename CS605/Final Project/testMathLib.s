# This is a test file to make sure that the mathLib power function works

.text

.global main

main:
# Save and return to os on stack
	PUSH {lr}

# Prompt for an input for first number: base
	LDR r0, =prompt1
	BL  printf

# Scanf user input for first number: base
	LDR r0, =input1
	MOV r1, sp
	BL scanf


# Prompt the user for a second input: exponent 
	LDR r0, =prompt2
	BL printf

# Scanf user input for second number
	LDR r0, =input2
	MOV r1, sp
	BL scanf

	BL pow
	LDR r1, =format1
	BL printf

# Calculate using pow function 
	POP {lr}
	BX lr

# Return
.data
	prompt1: .asciz "Enter the base: \n"
	prompt2: .asciz "Enter the exponent: \n"
	format1: .asciz "\nThe power is: %d\n"
	input1: .asciz "%d"
	input2: .asciz "%d"

