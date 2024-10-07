#
# Library name: libAssignment10.s
# Author: Rong Fan
# Date: 04/08/2024
# Contents:
# 1: Mult				go to line 10
# 2.1: FibHelp				go to line 71
# 2.2: Fib				go to line 112

.global Mult

.text
Mult:	
	# To calculate multiplication using recursion
	# input: an integer, the first number to multiply in r0
	# input: an integer, the the second number in r1
	# output: the product in r0
	# m * n = m + m * (n-1)
	# if n = 0 return 0
	# else return m + m * (n-1)

	# noticed to incorperate negative numbers
	# we can negate n and negate the product

# store lr on stack
	SUB sp, sp, #4
	STR lr, [sp]
	
# store m in a safe place 	 
	SUB sp, #4
	STR r4, [sp]
	MOV r4, r0	

# case when n is 0
	CMP r1, #0
	BNE checkNegative
		MOV r0, #0
		BL returnMult

checkNegative:
# case when n is negative
	CMP r1, #0
	BGT continueRecurse
		
	# negate n and negate it back
		MVN r1, r1
		ADD r1, #1
		BL Mult
		MVN r0, r0
		ADD r0, #1
		B returnMult

# else calculate m * (n-1) and add to m
continueRecurse:
	SUB r1, #1
	BL Mult
	ADD r0, r4
	B returnMult

returnMult:
# move lr back from stack and return
	LDR r4, [sp]
	LDR lr, [sp, #4]
	ADD sp, #8
	MOV pc, lr
.data

# End Mult


.global FibHelp

.text
FibHelp:
	# input: we have three inputs
	# first input need to be (n-1, 1, 0)
	# 1. The number of times sum need to be calculated s in r0
	# 2. F(n-1), the last Fibonacci number in r1
	# 3. F(n-2), the second to last Fibonacci number in r2
	# output: only one thing needed
	# output is the last number in r0 when r0 is 0
	# If s = 0 move r1 to r0 and return, otherwise recursively call FibHelp(s-1,F(n), F(n-1))

# store lr on stack
	SUB sp, #4
	STR lr, [sp]

# check if r0 = 0, return r1
	CMP r0, #0
	BNE recurseFib
		MOV r0, r1
		B outputFibHelp

# otherwise recursively call FibHelp
recurseFib:
	SUB r0, #1
	ADD r1, r1, r2
	SUB r2, r1, r2
	BL FibHelp	
	
outputFibHelp:
# move lr back from stack
	LDR lr, [sp]
	ADD sp, #4
	MOV pc, lr

.data

# End FibHelp


.global Fib

.text
Fib:
	# input: an integer n in r0
	# output: the nth Fibonacci number, in r0
	# F(0) = 0, F(1) = 1
	# F(n) = F(n-1) + F(n-2)
	# Use the dynamic programming concept but implemented with recursion
	# Calling fibHelp which have three inputs
	# r0 = n-1, r1 = 1, r2 = 0 
	# and the output is already in the right place
	 
# store lr on stack
	SUB sp, sp, #4
	STR lr, [sp]

# check of input is 0, return 0
	CMP r0, #0
	BEQ outputFib

# Coincidentally no need to change r0, otherwise an extra step is needed
		
callFibHelp:
# calling FibHelp, it should put the correct output in r0
	SUB r0, #1
	MOV r1, #1
	MOV r2, #0
	BL FibHelp	

outputFib:
# move lr back from stack
	LDR lr, [sp]
	ADD sp, #4
	MOV pc, lr

.data

# End Fib
