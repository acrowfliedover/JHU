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

.global checkDivisible

# Helper for checkPrime
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

# Helper for checkPrime
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

# Helper for modulo power and others
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


.global moduloPower

.text
moduloPower:
	# input: r0: an integer b which the base
	# r1: an integer n which is the exponent
	# r2: an integer m which is the modulo number
	# output: return b ^ n % m in r0
	# we loop b * b, (n-1) times and mod m
	# to avoid overflow happen for b ^ n when b or n is large
	# we take the modulo every time b is multiplied
	# and use the remainder to multiply b again
	
	# r4 = b store the base
	# r5 = n store times the loop need to be run and count down
	# r6 = m stays the same

# store lr on stack
	SUB sp, #4
	STR lr, [sp]

# store the input variables and initialize the loop
	SUB sp, #12
	STR r4, [sp]
	STR r5, [sp, #4]
	STR r6, [sp, #8]
	MOV r4, r0
	MOV r5, r1
	MOV r6, r2

checkEndPower:
# end condition: if n = 0 return r0 which stores either the initial base or the last remainder 
	CMP r5, #0
	BGT continuePower
		B returnModuloPower

continuePower:
# else multiply r0 and b and mod m, and subtract n by 1
	SUB r5, #1
	MUL r0, r0, r4
	MOV r1, r6
	BL modulo
	B checkEndPower
	
returnModuloPower:
# clear the stack and return
	LDR r4, [sp]
	LDR r5, [sp, #4]
	LDR r6, [sp, #8]
	LDR lr, [sp, #12]
	ADD sp, #16
	MOV pc, lr

.data

# End moduloPower


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


.global gcd

.text
gcd:
	# input: r0 and r1 to integers
	# output: their greatest common divisor in r0
	# idea: recursively call gcd
	# if r0 > r1, find r0 mod r1 and store in r0, if it's zero, return r1
		# if it's not zero, call gcd again
	# if r0 < r1, swap them and call gcd again

# push stack
	SUB sp, #4
	STR lr, [sp]

# store r4 to be used
	SUB sp, #4
	STR r4, sp

continuegcd:
# if r0 < r1 swap them
	CMP r0, r1
	BGE goMod
		MOV r2, r1
		MOV r1, r0
		MOV r0, r2
		B continuegcd

# otherwise find r0 = r0 mod r1
goMod:
	MOV r4, r1
	BL modulo

# check if the modulo is 0
	MOV r1, r4
	CMP r0, #0
	BNE continuegcd

# if it's zero move r1 to r0 and return
	MOV r0, r1
	
returngcd:
# pop stack
	LDR r4, [sp]
	LDR lr, [sp, #4]
	ADD sp, #8
	MOV pc, lr
	
.data

# End gcd


.global cpubexp

.text
cpubexp:
	# input: an integer phi = (p-1)*(q-1)
	# output: an available e such that 1 < e < phi
	# and e is co-prime to phi
	# idea: use random number generator to generate a number
	# and check if they are co-prime
	# use gcd, and if their gcd is 1 they are co-prime
	# if they are not, generate again
	# there should be at least 1/5 numbers co-prime to phi so it would be fast enough

# store lr on stack
	SUB sp, #4
	STR lr, [sp]

# store input phi in r4 and phi-2 in r5
	SUB sp, #12
	STR r4, [sp]
	STR r5, [sp, #4]
	STR r6, [sp, #8]
	MOV r4, r0
	SUB r5, r4, #2

# generate random number between 2 and phi-1
# need to call getRandom (phi-2) then +1
generateRandom:
	MOV r0, r5
	BL getRandom

# add 1 to the random number and find gcd
# store e to r6 for output
	ADD r0, #1
	MOV r6, r0
	MOV r1, r5
	BL gcd

# if gcd is 1, return e
	CMP r0, #1
	BNE generateRandom
		MOV r0, r6

# move stored values back and return
	LDR r4, [sp]
	LDR r5, [sp, #4]
	LDR r6, [sp, #8]
	LDR lr, [sp, #12]
	ADD sp, #16
	MOV pc, lr

.data

# End cpubexp


.global cprivexp

.text
cprivexp:
	# input: an integer, the public exponent e in r0
	# the totient phi = (p-1)*(q-1) in r1
	# output the private exponent d in r0
	# idea: iterate from 2 to phi, find the one with de = 1 mod phi

	# this would take O(phi) which is quite slow
	# the optimal way takes O(logphi) but it's quite hard to implement and understand
	# will check it out if we have time

	# r4 = e
	# r5 = phi
	# r6 = counter start at 2

# store lr on stack
	SUB sp, #4
	STR lr, sp

# store other variables and initialize them
	SUB sp, #12
	STR r4, sp
	STR r5, [sp, #4]
	STR r6, [sp, #8]
	MOV r4, r0
	MOV r5, r1
	MOV r6, #2

continueCprivexp:
# find e * r5 mod phi
	MUL r0, r4, r6
	MOV r1, r5
	BL modulo

# if it equals 1, return
	CMP r0, #1
	BNE incrementD
		B returnCprivexp

# else increment and continue the loop
	ADD r6, #1
	B continueCprivexp

returnCprivexp:
	MOV r0, r6

# move back the stored variables and return
	LDR r4, sp
	LDR r5, [sp, #4]
	LDR r6, [sp, #8]
	LDR lr, [sp, #12]
	ADD sp, #16
	MOV pc, lr

.data

# End cprivexp
