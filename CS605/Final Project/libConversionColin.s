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
	# r1: an integer n which is the exponent e
	# r2: an integer m which is the modulo number n
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
# end condition: if n = 1 return r0 which stores either the initial base or the last remainder 
	CMP r5, #1
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

.text
.global encryptArray
encryptArray:
    @ Inputs:
    @   r0: Pointer to the source null-terminated string
    @   r1: Value for e
    @   r2: Value for n
    @ Outputs:
    @   r1: Contents of the source string copied to the destination array

    SUB sp, sp, #20      @ Subtract 12 from the stack pointer to make space for 3 items
    STR lr, [sp, #16] @store lr #20
    STR r0, [sp,#12] @store string pointer
    STR r1, [sp, #8] @store e #12
    STR r2, [sp, #4] @store n #8

    @Open the file "encrypted.txt"
    LDR r0, =fout @filename into r0
    LDR r1, =w @edit mode
    BL fopen
    LDR r1, =fout @filename into
    STR r0, [r1] @store 
    str r0, [sp] @store filename in #4

copy_loop:
    ldr r0, [sp,#12] @load string pointer
    ldrb r2, [r0], #1   @ Load a character from the source string into r2
    str r0, [sp,#12] @store string point
    cmp r2, #0  @ Check if the character is null (end of string)
    beq copy_done     @ If null, exit loop

    mov r0, r2 @ move character to 40
    ldr r1, [sp, #8] @store e #12
    ldr r2, [sp, #4] @store n #8

    bl moduloPower

    mov r2, r0 @ move return to r2
    ldr r0, [sp] @ load filename
    LDR r1, =format @load format
    BL fprintf


    @Write a comma into the file
    LDR r1, =commaFormat @load comma
    ldr r0, [sp] @ load filename
    BL fprintf
    @ Continue looping
    b copy_loop

copy_done:
    @ Null-terminate the destination array

    @Close the file
    LDR r1, =fout @set filename
    LDR r0, [r1] 
    BL fclose @close file
    LDR lr, [sp, #16]   @Load the value of lr
    ADD sp, sp, #20   @reset stack
    MOV pc, lr
.data
    fout: .asciz "encrypted.txt"
    w: .asciz "w"
    buffer: .space 100
    format: .asciz "%d"
    commaFormat: .asciz ","
@ End
.text
.global encrypt
encrypt:
    @inputs
    @r0: Value for e
    @r1: Value for n 
    SUB sp, sp, #12
    STR lr, [sp,#8]
    STR r0, [sp,#4] @store e in #4
    STR r1, [sp] @store n

    mov r2, r0
    mov r3, r1

    LDR r0, =prompt_message     @ Load the address of the prompt message into r0
    BL printf 

    LDR r0, =format_input    @ Load the format string address into r0
    LDR r1, =user_input      @ Load the address of the reserved memory for user input into r1
    BL scanf                 @ Call scanf to read user input

    ldr r0, =user_input
    ldr r1, [sp,#4] @load e in r1
    ldr r2, [sp] @load n in r2
    bl encryptArray


    LDR lr, [sp, #8]   @Load the value of lr
    ADD sp,sp,#12
    MOV pc,lr
.data
user_input:  .space 100    @ Reserve space to store user input
format_input:  .asciz "%99[^\n]"   @ Format string for scanf (reads a string)
destination_array: .space 100 @ Allocate space for the destination array
prompt_message:  .asciz "Enter a string: "   @ Prompt message for user input
