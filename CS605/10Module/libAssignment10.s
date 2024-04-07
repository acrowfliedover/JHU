#
# Library name: libAssignment10.s
# Author: Rong Fan
# Date: 04/06/2024
# Contents:
# 2.1: checkDivisible			go to line 13
# 2.2: getRoughSquareRoot		go to line 55
# 2.3: checkPrime			go to line 104
# 3.0: modulo				go to line 169
# 3.1: getRandom 			go to line 207
# 3:2: guessRandom			go to line 246

.global checkDivisible

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


.global getRoughSquareRoot

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


.global checkPrime
 
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


.global modulo

.text
modulo:
	# input1: an integer a in r0
	# input2: another integer b in r1
	# output: return a%b in r0

# store lr on stack
	SUB sp, #4
	STR lr, [sp]

# store other variables
	SUB sp, #8
	STR r4, [sp]
	STR r5, [sp, #4] 

# find the quotient 
	MOV r4, r0
	MOV r5, r1
	BL __aeabi_idiv

# find the remainder
	MUL r0, r5
	SUB r0, r4, r0

# return the stack
	LDR r4, [sp]
	LDR r5, [sp, #4]
	LDR lr, [sp, #8]
	ADD sp, #12
	MOV pc, lr

.data

# End modulo


.global getRandom

.text
getRandom:
	# input: an integer n representing the upperbound in r0
	# output: an integer between 1 and n (inclusive)
	# calling the c rand() funtion

# store lr on stack
	SUB sp, #4
	STR lr, [sp]

# store r4 on stack and put r0 there
	SUB sp, #4
	STR r4, [sp]
	MOV r4, r0

# call C functions
	MOV r0, #0
	BL time
	BL srand
	BL rand

# call modulo function, answer in r0
	MOV r1, r4
	BL modulo
	ADD r0, #1
	
# return the stack
	LDR r4, [sp]
	LDR lr, [sp, #4]
	ADD sp, #8
	MOV pc, lr

.data
	
# End getRandom


.global guessRandom

.text
guessRandom:
	# input: an integer representing the maximum possible number in r0
	# prompts user for guesses
	# output: displayed on screen
	# first generate a random number between 1 and n
	# cases:
	# 1. If user's guess is out of the range, display guess again in the range a to b
	# 2. If guess is less than answer, display less than and guess again
	# 3. If guess is more than answer, display more than and guess again
	# 4. If guess is correct display correct and guessed times and exit

	# Dictionary:
	# r4: the answer generated
	# r5: the current maximum
	# r6: the current minimum
	# r7: the number of guesses
	
# store lr on stack
	SUB sp, sp, #4
	STR lr, [sp]

# store variables r4-r7
	SUB sp, #16
	STR r4, [sp]
	STR r5, [sp, #4]
	STR r6, [sp, #8]
	STR r7, [sp, #12]
	MOV r5, r0

# generate random number between 1 and n and initialize variables
	BL getRandom
	MOV r4, r0
	MOV r6, #1
	MOV r7, #0
	
# prompt for guess
prompt:
	ADD r7, #1
	LDR r0, =promptForGuess
	MOV r1, r6
	MOV r2, r5
	BL printf
	LDR r0, =inputDecimal
	LDR r1, =currentInput
	BL scanf

# check for case 1
	LDR r3, =currentInput
	LDR r3, [r3]
	MOV r0, #0
	MOV r1, #0
	CMP r3, r6
	ADDLT r0, #1
	CMP r3, r5
	ADDGT r1, #1
	ORR r0, r1
	CMP r0, #1
	BNE validEntry
		LDR r0, =promptOutOfBound
		BL printf
		B prompt

# check for case 2
validEntry:
	CMP r3, r4
	BGE notLessThan
		LDR r0, =lessThanMessage
		ADD r6, r3, #1
		BL printf
		B prompt
	
# check for case 3
notLessThan:
	CMP r3, r4
	BEQ guessedCorrect
		LDR r0, =greaterThanMessage
		SUB r5, r3, #1
		BL printf
		B prompt

guessedCorrect:
	LDR r0, =winningMessage
	MOV r1, r4
	MOV r2, r7
	BL printf
		
# add back to stack
	LDR r4, [sp]
	LDR r5, [sp, #4]
	LDR r6, [sp, #8]
	LDR r7, [sp, #12]
	LDR lr, [sp, #16]
	ADD sp, #20
	MOV pc, lr

.data
	promptForGuess: .asciz "Please guess a number between %d and %d (inclusive).\n"
	promptOutOfBound: .asciz "You enter a number outside of range. \n"
	winningMessage: .asciz "You guessed right! The answer is %d. It took you %d guesses.\n"
	lessThanMessage: .asciz "Your guess is less than the correct answer. \n"
	greaterThanMessage: .asciz "Your guess is greater than the correct answer. \n"

	inputDecimal: .asciz "%d"
	currentInput: .word 0

# End guessRandom
