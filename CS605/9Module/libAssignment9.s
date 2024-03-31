#
# Library name: libAssignment9.s
# Author: Rong Fan
# Date: 03/30/2024
# Contents:
# 1.1: checkAlphaChar			go to line 11
# 1.2: checkAlphaCharWithoutLogical	go to line 58
# 2: gradeCheck				go to line 110
<<<<<<< HEAD
# 3: findMaxOf3				go to line 193
=======
# 3: findMaxOf3				go to line 199
>>>>>>> bffa67866479782790f602df096c2b6aa220cfcd

.global checkAlphaChar

.text

checkAlphaChar:
	# input: a word representing a char in r0 
	# output: a boolean in r0
	# 0 if input is not an alpha character, 1 if it is
	# the ascii value of alpha chars: 0x40 < c <= 0x5A or 0x60 < c <= 0x7A

# store lr on stack
	SUB sp, sp, #4
	STR lr, [sp]
	
# use logical variables in r1-r3 	
	MOV r1, #0
	MOV r2, #0
	MOV r3, #0
	
# first part of requirement in r1
	CMP r0, #0x40
	MOVGT r2, #1
	CMP r0, #0x5A
	MOVLE r3, #1
	AND r1, r2, r3

# second part of requirement in r2
	MOV r2, #0
	MOV r3, #0
	CMP r0, #0x60
	MOVGT r2, #1
	CMP r0, #0x7A
	MOVLE r3, #1
	AND r2, r2, r3

# output result
	ORR r0, r1, r2
	
# move lr back from stack and return
	LDR lr, [sp]
	ADD sp, #4
	MOV pc, lr
.data

# End checkAlphaChar


.global checkAlphaCharWithoutLogical

.text
checkAlphaCharWithoutLogical:
	# input: a word representing a char in r0
	# output: a boolean in r0
	# 0 if input is not an alpha character, 1 if it is
	# 0x40 < c <= 0x5A or 0x60 < c <= 0x7A
	# This time does not use logical variables
	# This honestly looks cleaner than I expected
	# Also beware that branching takes much longer than other instructions
	# Not sure if this is spaghette code, as it reuses branches
	
# store lr on stack
	SUB sp, sp, #4
	STR lr, [sp]

# first check 
	CMP r0, #0x40
	BLE output0

# second check
	CMP r0, #0x5A
	BLE output1

# third check
	CMP r0, #0x60	
	BLE output0

# fourth check
	CMP r0, #0x7A
	BLE output1
	
# else
output0:
	MOV r0, #0
	B output

output1:
	MOV r0, #1	
	
output:
# move lr back from stack and return
	LDR lr, [sp]
	ADD sp, #4
	MOV pc, lr

.data

# End checkAlphaCharWithoutLogical


.global gradeCheck
 
.text
gradeCheck:
	# input: integer representing a grade in r0
	# output: to console the grade letter
	# g < 0 OR g > 100 output 'E' for error (technically we can go above 100 from extra credits)
	# g >= 90 output A
	# else g >= 80 output B
	# else g >= 70 output C
	# else output F
	
# store lr on stack
	SUB sp, sp, #4
	STR lr, [sp]

# move r0 to a safe space
	SUB sp, sp, #4
	STR r5, [sp]
	MOV r5, r0	

# check for error 0
	CMP r5, #0 
	BGE checkF 
		LDR r0, =outputE
		BL printf
		B outputGrade
		
# check for grade F
checkF:
	CMP r5, #70
	BGE checkC
		LDR r0, =outputF
		BL printf
		B outputGrade

# check for grade C
checkC:
	CMP r5, #80
	BGE checkB
		LDR r0, =outputC
		BL printf
		B outputGrade

# check for grade B
checkB:
	CMP r5, #90
	BGE checkA
		LDR r0, =outputB
		BL printf
		B outputGrade
		
# check for grade A
checkA:
	CMP r5, #100
	BGT error
		LDR r0, =outputA
		BL printf
		B outputGrade

# else error g > 100  
error:
	LDR r0, =outputE
	BL printf
	
# move lr back from stack and return
outputGrade:
	LDR r5, [sp]
	ADD sp, #4
	LDR lr, [sp]
	ADD sp, #4
	MOV pc, lr

# I have to insert the breaks to break the strings, otherwise outputE would include every string below for some reason
# Probably related how strings from .data are stored when run from a library
.data
	outputE: .asciz "Your grade is outside of normal range 0 <= g <= 100. \n"
	outputF: .asciz "Your grade is F. \n"
	outputC: .asciz "Your grade is C. \n"
	outputB: .asciz "Your grade is B. \n"
	outputA: .asciz "Your grade is A. \n"

# End gradeCheck


.global findMaxOf3

.text
findMaxOf3:
	# input: three integers in r0, r1, r2
	# output: the largest integer in r0
	# find the max of r0 and r1 and store in r0
	# find the max of r0 and r2 and store in r0

# store lr on stack
	SUB sp, sp, #4
	STR lr, [sp]

# find the max of r0 and r1 and store in r0
	CMP r0, r1
	BGE step2
		MOV r0, r1
	
# find the max of r0 and r2 and store in r0
step2:
	CMP r0, r2
	BGE outputMax
		MOV r0, r2
	
outputMax:
# add back to stack
	LDR lr, [sp]
	ADD sp, #4
	MOV pc, lr

.data
# End findMaxOf3
