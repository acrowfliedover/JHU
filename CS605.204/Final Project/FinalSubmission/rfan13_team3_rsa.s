#
# File name: rfan13_team3_rsa.s # change this to <Your JHEDID>_team#_rsa.s.
# Author: Rong Fan
# Date: 04/20/2024
# Purpose: This is the main program for the final project

# 1.generate random keys											go to line 48
# Range: currently generating p and q from 10 to 100, can be changed later

# 2.generate keys by entering primes								go to line 111
# Will check if entered is between 10 and 100 can be changed to used larger numbers

# 3.encrypt															go to line 219
# enter n, e, and the message you want to encrypt and output into a file encrypted.txt

# 4.decrypt															go to line 252
# enter n, d, assuming your encrypted file is called encrypted.txt, 

# for case 1 and 2
# r4 = p
# r5 = q
# r6 = n
# r7 = phi
# r8 = e

.text
.global main

main:
# store lr on stack
	SUB sp, sp, #4
	STR lr, [sp]

input:
# Prompt user for a function to use
	LDR r0, =askFunction
	BL printf

# Input number
	LDR r0, =formatDecimal
	LDR r1, =action
	BL scanf

# Load number inputted
	LDR r0, =action
	LDR r1, [r0]

# Case 1 generate random keys
	CMP r1, #1
	BNE case2

	generateRandomPrime1:
	# generate random number between 10 and 100
	# by generating a number between 1 and 91 and then add 9
		MOV r0, #91
		BL getRandom
		ADD r4, r0, #9
	
	# check if it is a prime, if it's not, repeat
		MOV r0, r4
		BL checkPrime
		CMP r0, #0
		BEQ generateRandomPrime1
	
	generateRandomPrime2:
	# else continue to generate next random prime
		MOV r0, #91
		BL getRandom
		ADD r5, r0, #9
	
	# check if it is a prime or if it's equal to the first one
		CMP r5, r4
		BEQ generateRandomPrime2
		MOV r0, r5
		BL checkPrime
		CMP r0, #0
		BEQ generateRandomPrime2
	
	# after generated the two primes calculate n = p*q in r6 and phi=(p-1)(q-1) in r7
	# after that p and q are not useful anymore
		MUL r6, r4, r5
		SUB r4, #1
		SUB r5, #1
		MUL r7, r4, r5

	# call cpubexp and store e in r8
		MOV r0, r7
		BL cpubexp
		MOV r8, r0

	# output public keys
		MOV r2, r0
		MOV r1, r6
		LDR r0, =outputPublicKey
		BL printf
	
	# call cprivexp
		MOV r0, r8
		MOV r1, r7
		BL cprivexp

	# output private keys
		MOV r2, r0
		MOV r1, r6
		LDR r0, =outputPrivateKey
		BL printf
	
	# exit to main menu	
		B input

# Case 2 generate keys by entering primes
case2:
	CMP r1, #2
	BNE case3

	askPrime1:
	# ask for the first prime
		LDR r0, =promptPrime1
		BL printf
		LDR r0, =formatDecimal
		LDR r1, =number1
		BL scanf

	# check if input is valid	
		LDR r0, =number1
		LDR r0, [r0]

	# use r1 as condition checker, false if not 0
		MOV r1, #0
		CMP r0, #10
		ADDLT r1, #1
		CMP r0, #100
		ADDGT r1, #1
		CMP r1, #0
		BEQ checkPrime1
			LDR r0, =askOutOfRange
			BL printf
			B askPrime1
	

	checkPrime1:
	# call checkPrime, make sure move r0 away first
		MOV r4, r0 
		BL checkPrime
		CMP r0, #0
		BNE askPrime2
			LDR r0, =askNotPrime
			BL printf
			B askPrime1
	
	askPrime2:
	# ask again for the second prime
		LDR r0, =promptPrime2
		BL printf
		LDR r0, =formatDecimal
		LDR r1, =number2
		BL scanf

	# check if input is valid	
		LDR r0, =number2
		LDR r0, [r0]

	# use r1 as condition checker, false if not 0
		MOV r1, #0
		CMP r0, #10
		ADDLT r1, #1
		CMP r0, #100
		ADDGT r1, #1
		CMP r1, #0
		BEQ checkPrime2
			LDR r0, =askOutOfRange
			BL printf
			B askPrime2
	

	checkPrime2:
	# call checkPrime, make sure move r0 away first
		MOV r5, r0 
		BL checkPrime
		CMP r0, #0
		BNE gotPQ
			LDR r0, =askNotPrime
			BL printf
			B askPrime2

	gotPQ:
	# now r4 and r5 are p and q, calculate n and phi
		MUL r6, r4, r5
		SUB r4, #1
		SUB r5, #1
		MUL r7, r4, r5

	# generate public keys calling cpubexp
		MOV r0, r7
		BL cpubexp
		MOV r8, r0

	# output public keys
		LDR r0, =outputPublicKey
		MOV r1, r6
		MOV r2, r8
		BL printf

	# generate private keys calling cprivexp
		MOV r0, r8
		MOV r1, r7
		BL cprivexp
	
	# output private keys
		MOV r2, r0
		LDR r0, =outputPrivateKey
		MOV r1, r6
		BL printf

	# return to main menu
		B input


# Case 3 call encrypt
case3:
	CMP r1, #3
	BNE case4

	# ask for public keys
	LDR r0, =askPublicKeyn
	BL printf
	LDR r0, =formatDecimal
	LDR r1, =number1 @number1 is now public key n
	BL scanf
	LDR r0, =askPublicKeye
	BL printf
	LDR r0, =formatDecimal
	LDR r1, =number2 @number2 is now public key e
	BL scanf

	# clear the buffer
	BL getchar

	# call encrypt
	LDR r0, =number2
	LDR r0, [r0]
	LDR r1, =number1
	LDR r1, [r1]
	BL encrypt

	LDR r0, =outputEncrypt
	BL printf 

	# return to main menu
	B input

# case 4 call decrypt
case4:
	CMP r1, #4
	BNE case0	

	# ask for private keys
	LDR r0, =askPrivateKeyn
	BL printf
	LDR r0, =formatDecimal
	LDR r1, =number1 @number1 is n
	BL scanf
	LDR r0, =askPrivateKeyd
	BL printf
	LDR r0, =formatDecimal
	LDR r1, =number2 @number2 is d
	BL scanf

	# clear the buffer
	BL getchar
	
	# call decrypt
	LDR r0, =number2
	LDR r0, [r0]
	LDR r1, =number1
	LDR r1, [r1]
	BL decrypt

	# return to main menu
	B input

# Case -1 exit the program, else return to input
case0:
	CMP r1, #-1
	BEQ endProgram
		LDR r0, =askNewCommand
		BL printf
		B input

endProgram:
# move lr back and return
	LDR lr, [sp]
	ADD sp, #4
	MOV pc, lr

.data
	askFunction: .asciz "\nHello user 10001, enter a number to run the corresponding function.\nEnter [1] to generate keys using random primes.\nEnter [2] to generate keys using inputted primes.\nEnter [3] to encrypt a message and output to encrypted.txt.\nEnter [4] to decrypt a message from encrypted.txt. \nEnter [-1] to exit. \n"
	promptPrime1: .asciz "Please enter a prime \n"
	promptPrime2: .asciz "Please enter a different prime \n"
	askNotPrime: .asciz "You entered a non-prime. Please enter a prime. \n"
	askOutOfRange: .asciz "You entered a number out of range.  Please enter a number between 10 and 50. \n"
	askNewCommand: .asciz "You entered an invalid command \n"
	
	askPublicKeyn: .asciz "Please enter the public keys you got. Enter n first, that is the product of the two primes.\n"
	askPublicKeye: .asciz "Please enter the other part of the public key, the exponent e.\n"

	askPrivateKeyn: .asciz "Please enter your private keys. Enter n first, that is the product of the two primes. \n"
	askPrivateKeyd: .asciz "Please enter the other part of the private key, the exponent d.\n"
	
	formatDecimal: .asciz "%d"
	formatString: .asciz "%s"    

	outputPublicKey: .asciz "Your public keys are: n = %d and e = %d.\n"
	outputPrivateKey: .asciz "Your private keys are: n = %d and d = %d.\n"
	outputEncrypt: .asciz "Encryption succeed.\n"

	action: .word 0
	number1: .word 0
	number2: .word 0
	message: .space 100
	fileName: .asciz ""


# End main
