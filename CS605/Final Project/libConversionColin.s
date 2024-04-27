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
.global arrayIntoFile
arrayIntoFile:
        # input: 
        # r11: an array containing values to be printed
        # output: 
        # write each character into file
                

   SUB sp, sp, #4          @ Allocate space on the stack
   STR lr, [sp, #0]        @ Save the return address
   
   #Open the file "encrypted.txt"
   LDR r0, =fout
   LDR r1, =w
   BL fopen
   LDR r1, =fout
   STR r0, [r1]
   MOV r5, r0
   MOV r6, #0   

WriteLoop:

   #Load character addresses from the array
   LDRB r7, [r11], #1


   #If the character equals '\0' then end up loop
   CMP r7, #0
   BEQ EndWriteLoop


   #Write the character into the file
   MOV r0, r5
   LDR r1, =format
   MOV r2, r7

   BL fprintf

    # Write a comma into the file
   MOV r0, r5
   LDR r1, =commaFormat
   BL fprintf

   ADD r6, r6, #1
   #Continue the loop
   B WriteLoop

EndWriteLoop:

   #Close the file
   LDR r1, =fout
   LDR r0, [r1]
   BL fclose

   LDR lr,[sp,#0]
   ADD sp,sp,#4
   MOV pc,lr

.data 
   fout: .asciz "encrypted.txt"
   w: .asciz "w"
   buffer: .space 100
   format: .asciz "%d"
   commaFormat: .asciz ","
   output: .asciz "The current value is: %c\n"
@ END


.text
.global stringToArray

stringToArray:
    SUB sp, sp, #4
    STR lr, [sp,#0]

    MOV r2, #0              @ Initialize array index to 0

copyLoop:
    LDRB r3, [r0], #1       @ Load a byte from the input string into r3 and increment the pointer
    CMP r3, #0              @ Check if the byte is null (end of string)
    BEQ endCopyLoop         @ If null, exit loop

    STRB r3, [r1, r2]       @ Store the byte into the output array and increment the index
    ADD r2, r2, #1          @ Increment the array index

    B copyLoop              @ Repeat the loop

endCopyLoop:
    MOV r3, #0              @ Null-terminate the output array
    STRB r3, [r1, r2]       @ Store null terminator at the end of the array

    LDR lr,[sp,#0]
    ADD sp,sp,#4
    MOV pc,lr


@ END

.text
.global encryptArray
encryptArray:
    @ Inputs:
    @   r0: Pointer to the source null-terminated string
    @   r1: Pointer to the destination array
    @ Outputs:
    @   Contents of the source string copied to the destination array

    SUB sp, sp, #4
    STR lr, [sp,#0]

    @ Initialize source pointer
    mov r6, r0
    @ Initialize destination pointer
    mov r4, r1

copy_loop:
    @ Load a character from the source string
    ldrb r7, [r6], #1
    @ Check if the character is null (end of string)
    cmp r7, #0
    @ If null, exit loop
    beq copy_done
    mov r0, r7
    mov r1, #3
    mov r2, #15
    bl moduloPower
    mov r7, r0
    @ Store the character into the destination array
    strb r7, [r4], #1
    @ Continue looping
    b copy_loop

copy_done:
    @ Null-terminate the destination array
    mov r5, #0
    strb r5, [r4]

    LDR lr,[sp,#0]
    ADD sp,sp,#4
    MOV pc,lr
