# Library functions required for Final Project

.global checkPrime
.global gcd
.global pow
.global modulo
.global checkDivisible
.global getRoughSquareRoot

.text
checkDivisible:
	# input: an integer, the dividend in r0
	# input: an integer, the divisor in r1
	# output: a boolean in r0
	# 1 if r0 is a multiple of r1
	# 0 if r0 is not a multiple of r1

# store lr on stack
	SUB sp, sp, #4
	STR lr, [sp]
	
# store values in a safe place 	 
	SUB sp, #8
	STR r4, [sp]
	STR r5, [sp, #4]

	MOV r4, r0
	MOV r5, r1	
	
# divide r0 by r1 and get quotient in r0
	BL __aeabi_idiv
	
# multiply the quotient with the divisor and compare with dividend
	MUL r1, r0, r5
	MOV r0, #0
	CMP r1, r4
	MOVEQ r0, #1

# move lr back from stack and return
	LDR r4, [sp]
	LDR r5, [sp, #4]
	LDR lr, [sp, #8]
	ADD sp, #12
	MOV pc, lr
.data

# End checkDivisible

.text
getRoughSquareRoot:
	# input: an integer in r0
	# output: an integer roughly representing the square root of r0, in r0
	# it needs to be >= the actual square root
	# algorithm: first find the largest significant bit n (first bit is 0th bit)
	# then shift the number to the right by n/2
	# the largest possible input is 0b0111 1111 1111 1111 1111 1111 1111 1111

	# r1, the original integer
	# r2, the counter for the bit
	# r3, the power of 2 stored
	 
# store lr on stack
	SUB sp, sp, #4
	STR lr, [sp]

# check if the highest order bit is 1
# r2 is the counter for highest order bit 
	MOV r3, #0x40000000
	MOV r2, #30
	MOV r1, r0

# the start of loop
checkHighestBit:
	AND r0, r1, r3
	CMP r0, #0
	BNE outputSqrt
		SUB r2, #1
		ASR r3, #1
		B checkHighestBit

# shift the original int  
outputSqrt:
	ASR r2, #1
	ASR r0, r1, r2 

# move lr back from stack and return
	LDR lr, [sp]
	ADD sp, #4
	MOV pc, lr

.data

# End getRoughSquareRoot
 
.text
checkPrime:
	# input: integer n in r0
	# input is between 4 and intMax
	# everything else is handled in main
	# output: 1 if the integer is prime, 0 if it's not in r0
	# find the square root of n = r
	# search from 2 to r, if n is divisible by any number, return 0
	# else return 1
	
	# r4 stores the original integer
	# r5 stores the current checking number
	# r6 stores the square root of n

# store lr on stack
	SUB sp, sp, #4
	STR lr, [sp]

# move r4-r6 to a safe space
	SUB sp, #12
	STR r4, [sp]
	STR r5, [sp, #4]
	STR r6, [sp, #8]

# initialize the numbers
	MOV r4, r0
	MOV r5, #2
	BL getRoughSquareRoot
	MOV r6, r0
 
# start of loop
checkReachSquareRoot:
	CMP r5, r6
	BGT outputIsPrime
		MOV r0, r4
		MOV r1, r5
		BL checkDivisible
		CMP r0, #1
		BEQ outputIsNotPrime
			ADD r5, #1
			B checkReachSquareRoot

outputIsPrime:
	MOV r0, #1
	B outputCheckPrime

outputIsNotPrime:
	MOV r0, #0
	B outputCheckPrime

outputCheckPrime:
	LDR r4, [sp]
	LDR r5, [sp, #4]
	LDR r6, [sp, #8]
	LDR lr, [sp, #12]
	ADD sp, #16
	MOV pc, lr

.data

# End checkPrime

.text
	# r2 has first number
	# r3 has second number
gcd:
	# push stack
	SUB sp, sp, #4
	STR lr, [sp]

	# Find the greatest common denominator 
	MOV r2, r0
	MOV r3, r1

	loop: 
	   CMP r3, #0
	   BEQ done
	   BGT cond1
	   B cond2

	cond1: 
	   SUB r2, r3
	   B gcd
	
	cond2:
	   SUB r3, r2
	   B gcd
	   B loop 
	
	done:

	# pop stack
	LDR lr, [sp]
	ADD sp, sp, #4
	MOV pc, lr
	
.data

#END gcd

.text
	# R2 has the base value in it
	# R3 has the exponent value in it
	# R0 has the answer in it
pow: 
	# push stack
	SUB sp, sp, #4
	STR lr, [sp]

	# calculate the power of two numbers given X^x
	MOV r2, r0
	MOV r3, r1

	MOV r4, #1

	powerLoop: 
	   CMP r3, #0
	   BEQ donePow
	
	   MUL r5, r4, r2
	   MOV r4, r5
	   SUB r3, r3, #1
	
	   B powerLoop

	donePow: 
	   MOV r0, r4

	# pop stack
	LDR lr, [sp]
	ADD sp, sp, #4
	MOV pc, lr

.data
#END pow

.text
	# r2 will contain the dividend
	# r3 will contain the divisor
modulo:
	# push stack
	SUB sp, sp, #4
	STR lr, [sp]

	# Calculate the modulo operator
	MOV r2, r0
	MOV r3, r1
	
	# If the divisor is 0, return -1 (error)
	CMP r3, #0
	BEQ error
	BL __aeabi_idivmod
	MOV r0, r1
	
	# Pop stack
	LDR lr, [sp]
   	ADD sp, sp, #4
    	MOV pc, lr 
	
	error:
	MOV r0, #-1
	
	# pop stack
	LDR lr, [sp]
	ADD sp, sp, #4
	MOV pc, lr

.data

#END modulo
