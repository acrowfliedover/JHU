#
# Library name: LibConversions.s
# Author: Rong Fan
# Date: 03/16/2024
# Contents:
# 1.A: miles2kilometer		go to line 11
# 1.B: kph			go to line 50
# 2.A: CtoF			go to line 89
# 2.B: InchesToFt		go to line 122

.global miles2kilometer

.text
miles2kilometer:
	# input: integer representing miles in r0
	# output: integer representing kilometers in r0
	# convert mile to kilometers
	# We multiply first before divide to we can keep in more precision.
	# If done the other way, for example 99 miles will be 0 kilometer
	# An easy way to increase precision is to increase the number of digits to multiply and divide
	# Multiply by 1609344 then divide by 1000000 for example
	# Problem this will limit the size of input to be a smaller number, otherwise it will overflow
	# A smarter way is to use fractions
	# 25146 / 15625 = 1.609344
	# 6336 / 3937 = 1.609347
	# So we can use them according to our need for precision and magnitude

# store lr on stack
	SUB sp, sp, #4
	STR lr, [sp]
	
# Multiply by 161 stored in r0
	MOV r1, r0
	ADD r0, r0, r1, LSL #7
	ADD r0, r0, r1, LSL #5

# Divide by 100 using __aeabi_idiv
	MOV r1, #100
	BL __aeabi_idiv

# move lr back from stack and return
	LDR lr, [sp]
	ADD sp, #4
	MOV pc, lr
.data

# End miles2kilometer


.global kph

.text
kph:
	# input1: integer representing hours in r0
	# input2: integer representing miles in r1
	# output: integer representing kilometers per hour in r0
	# convert miles to kilometers then divide by hours

# store lr on stack
	SUB sp, sp, #4
	STR lr, [sp]

# store extra data on stack
	SUB sp, sp, #4
	STR r0, [sp]
	
# Call miles2kilometer
	MOV r0, r1	// r0 is now miles
	BL miles2kilometer // now r0 stores the kilometer


# Divide by hours	
	LDR r1, [sp]
	BL __aeabi_idiv
	
# Add back used stack
	ADD sp, #4

# move lr back from stack and return
	LDR lr, [sp]
	ADD sp, #4
	MOV pc, lr

.data

# End kph


.global CToF

.text
CToF:
	# input: integer representing degree Celius in r0
	# output: integer representing degree Fahrenheit in r0
	# F = C * 9 / 5 + 32
	
# store lr on stack
	SUB sp, sp, #4
	STR lr, [sp]

# multiply r0 by 9
	MOV r1, r0
	ADD r0, r0, r1, LSL #3

# divide r0 by 5
	MOV r1, #5
	BL __aeabi_idiv

# add r0 by 32
	ADD r0, #32

# move lr back from stack and return
	LDR lr, [sp]
	ADD sp, #4
	MOV pc, lr

.data

# End CToF


.global InchesToFt

.text
InchesToFt:
	# input: integer representing inches in r0
	# output1: integer representing feet in r0
	# output2: integer representing decimal value for left over in r1, leave 1 decimal space
	# For example 16 inches = 1.3 feet output: r0 = 1, r1 = 3

# store lr on stack
	SUB sp, sp, #4
	STR lr, [sp]

# store r0 on stack
	SUB sp, #4
	STR r0, [sp]

# divide by 12, store in r2
	MOV r1, #12
	BL __aeabi_idiv
	MOV r2, r0

# take out data from stack and store r2
	LDR r3, [sp]
	STR r2, [sp]	

# calculate remainder store in r1
	MOV r1, r2, LSL #3
	ADD r1, r1, r2, LSL #2
	SUB r1, r3, r1

# calculate decimal by multiply by 5 then divide by 6
	MOV r0, r1
	ADD r0, r1, LSL #2
	MOV r1, #6
	BL __aeabi_idiv

# move variables to correct output registers 
	MOV r1, r0
	LDR r0, [sp]
	ADD sp, #4

# add back to stack
	LDR lr, [sp]
	ADD sp, #4
	MOV pc, lr

.data
# End InchesToFt
