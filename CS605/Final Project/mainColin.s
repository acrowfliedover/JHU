.data
array:  .space 100   @ Initialize an array with values 1, 2, 3, 4, 5
source_string: .ascii "Hello\0"
destination_array: .space 20 @ Allocate space for the destination array
.text
.global main
main:
    SUB sp, sp, #4
    STR lr, [sp,#0]

    ldr r0, =source_string
    ldr r1, =destination_array

    bl encryptArray

    mov r11, r6

    bl arrayIntoFile

    LDR lr,[sp,#0]
    ADD sp,sp,#4
    MOV pc,lr