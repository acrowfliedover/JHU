
.text 
.global arrayWriteFile
arrayWriteFile:
        # input: 
        # r0: an array containing values to be printed
        # output: 
        # write each character into file
                

   SUB sp, sp, #12          @ Allocate space on the stack
   STR lr, [sp, #8]   
   str r1, [sp, #4]
   
   #Open the file "encrypted.txt"
   LDR r0, =fout @filename into r0
   LDR r1, =w @edit mode
   BL fopen
   LDR r1, =fout @filename into
   STR r0, [r1] @store 
   str r0, [sp] @store filename

WriteLoop:
   ldr r0, [sp,#4] @ load array point
   LDRB r2, [r0], #1 @load array @ pointer
   str r0, [sp,#4] @store array pointer


   CMP r2, #0 @if equal to 0, end loop
   BEQ EndWriteLoop


   ldr r0, [sp] @ load filename
   LDR r1, =format
   BL fprintf

   @Write a comma into the file
   ldr r0, [sp] @load filename
   LDR r1, =commaFormat
   BL fprintf

   B WriteLoop

EndWriteLoop:

   @Close the file
   LDR r1, =fout
   LDR r0, [r1]
   BL fclose

   LDR lr,[sp,#8]
   ADD sp,sp,#12
   MOV pc,lr

.data 
   fout: .asciz "encrypted.txt"
   w: .asciz "w"
   buffer: .space 100
   format: .asciz "%d"
   commaFormat: .asciz ","
@ END


.text
.global encryptArray
encryptArray:
    @ Inputs:
    @   r0: Pointer to the source null-terminated string
    @   r1: Pointer to the destination array
    @   r2: Value for e
    @   r3: Value for n
    @ Outputs:
    @   r1: Contents of the source string copied to the destination array

    SUB sp, sp, #24      @ Subtract 12 from the stack pointer to make space for 3 items
    STR lr, [sp, #20]
    STR r1, [sp, #16]
    STR r2, [sp, #12]
    STR r3, [sp, #8]

copy_loop:
    ldrb r2, [r0], #1   @ Load a character from the source string into r2
    cmp r2, #0  @ Check if the character is null (end of string)
    beq copy_done     @ If null, exit loop

    STR r0, [sp, #4]
    str r1, [sp]
    mov r0, r2 @ move character to 40
    ldr r2, [sp, #8]
    ldr r1, [sp, #12]

    bl moduloPower

    mov r2, r0 @ move return to r2
    LDR r1, [sp] @ move string pointer to r0
    ldr r0, [sp, #4]


    strb r2, [r1], #1     @ Store the character into the destination array

    @ Continue looping
    b copy_loop

copy_done:
    @ Null-terminate the destination array

    mov r2, #0
    strb r2, [r1] @move null terminator into array
    LDR r1, [sp,#16]
    LDR lr, [sp, #20]   @Load the value of lr
    ADD sp, sp, #24   @reset stack
    MOV pc, lr

@ End
.text
.global encrypt
encrypt:
    @inputs
    @r0: Value for e
    @r1: Value for n 
    SUB sp, sp, #12
    STR lr, [sp,#8]
    STR r0, [sp,#4]
    STR r1, [sp]

    mov r2, r0
    mov r3, r1

    LDR r0, =prompt_message     @ Load the address of the prompt message into r0
    BL printf 

    LDR r0, =format_input    @ Load the format string address into r0
    LDR r1, =user_input      @ Load the address of the reserved memory for user input into r1
    BL scanf                 @ Call scanf to read user input

    ldr r0, =user_input
    ldr r1, =destination_array
    ldr r2, [sp,#4]
    ldr r3, [sp]
    bl encryptArray

    bl arrayWriteFile

    LDR lr, [sp, #8]   @Load the value of lr
    ADD sp,sp,#12
    MOV pc,lr
.data
user_input:  .space 100    @ Reserve space to store user input
format_input:  .asciz "%99[^\n]"   @ Format string for scanf (reads a string)
destination_array: .space 100 @ Allocate space for the destination array
prompt_message:  .asciz "Enter a string: "   @ Prompt message for user input
