.data
array:  .space 100   @ Initialize an array with values 1, 2, 3, 4, 5
source_string: .ascii "This is a test\0"
destination_array: .space 20 @ Allocate space for the destination array
n: .word 143
e: .word 7
.text
.global main
main:
    SUB sp, sp, #4
    STR lr, [sp,#0]

    ldr r0, =e
    ldr r0, [r0]
    ldr r1, =n
    ldr r1, [r1]
    bl encrypt

    LDR lr,[sp,#0]
    ADD sp,sp,#4
    MOV pc,lr
