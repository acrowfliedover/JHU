#
# Library name: libRong.s
# Author: Rong Fan
# Date: 04/16/2024
# Contents:

# 1.1: checkDivisible			go to line 20	Check if a number is a divisor of another
# 1.2: getRoughSquareRoot		go to line 63	Get a number slightly more than the square root of a number
# 1.3: checkPrime			go to line 113	Check if a number is prime

# 2.1: modulo				go to line 178	Get x%y
# 2.2: moduloPower			go to line 217	Get (x^y)%z
 
# 3.1: getRandom 			go to line 275  Generate a random integer between 1 and n
# 3.2: gcd				go to line 314	Find the greatest common devisor of x and y
					
# 4.1: cpubexp				go to line 367	Generate public exponent e
# 4.2: cprivexp				go to line 423	Generate private exponent d

.global testModuloPower

.text
testModuloPower:
	# this in place of main to test if we can include multiple libs
	# this will do the job of main case 3, call moduloPower

# store lr on stack
	SUB sp, sp, #4
	STR lr, [sp]
	
# prompt user for inputs
# ask for base
	LDR r0, =promptForBase
	BL printf
	LDR r0, =formatDecimal
	LDR r1, =base
	BL scanf

# ask for exponent
	LDR r0, =promptForExponent
	BL printf
	LDR r0, =formatDecimal
	LDR r1, =exponent
	BL scanf

# ask for modulo
	LDR r0, =promptForModulo
	BL printf
	LDR r0, =formatDecimal
	LDR r1, =modulo
	BL scanf

# load the numbers and call moduloPower
	LDR r0, =base
	LDR r0, [r0]
	LDR r1, =exponent
	LDR r1, [r1]
	LDR r2, =modulo
	LDR r2, [r2]
	BL moduloPower

# output the result and return
	MOV r1, r0
	LDR r0, =output
	BL printf

# move lr back from stack and return
	LDR lr, [sp]
	ADD sp, #4
	MOV pc, lr
.data
	promptForBase: .asciz "Please enter a base \n"
	promptForExponent: .asciz "Please enter an exponent \n"
	promptForModulo: .asciz "Please enter a modulo \n"

	formatDecimal: .asciz "%d"	

	output: .asciz "The answer is %d \n"

	base: .word 0
	exponent: .word 0
	modulo: .word 0

# End testModuloPower



