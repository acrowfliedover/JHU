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
