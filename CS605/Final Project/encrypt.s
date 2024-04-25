    .data
msg_prompt:         .asciz "Enter a message for encryption:\n"
msg_format:         .asciz " %99[^\n]\n"
encrypted_file:     .asciz "encrypted.txt"
n:                  .word 55       
e:                  .word 17       

    .bss
input_msg:          .space 100     
encrypted_msg:      .space 100     

    .text
.global main
.extern printf, scanf, fopen, fprintf, fclose, putchar

main:
    SUB sp, sp, #4
    STR lr, [sp,#0]

    ldr r0, =msg_prompt
    bl printf

    ldr r0, =msg_format
    ldr r1, =input_msg
    bl scanf

    ldrb r2, [r1, r3]  
    strb r2, [r1, r3]  
    mov r2, #0         
    strb r2, [r1, r3+1]  

    ldr r1, =input_msg    
    ldr r2, =encrypted_msg    
    bl encrypt_message

    ldr r0, =encrypted_msg
    bl printf

    lDR lr,[sp,#0]
    ADD sp,sp,#4
    MOV pc,lr

encrypt_message:
    ldrb r3, [r1], #1     
    cmp r3, #0            
    beq end_encrypt_loop 

    bl encrypt_char       
    strb r4, [r2]     
    add r2, r2, #1    
    b encrypt_message

end_encrypt_loop:
    bx lr

encrypt_char:
    ldr r4, =n             
    ldr r4, [r4]
    ldr r5, =e             
    ldr r5, [r5]
    mul r6, r3, r5         
    mov r4, r6, lsr #32    
    bx lr

write_to_file:
    mov r4, #0              
    bl fopen                
    cmp r0, #0              
    bne file_opened         
    mov r0, #1              
    ldr r1, =encrypted_file 
    bl fopen                
    cmp r0, #0              
    bne fopen_error         
file_opened:
    mov r1, r0              
    ldr r0, =encrypted_file 
    mov r2, #1              
    ldr r3, =encrypted_msg  
    bl fprintf              
    mov r0, r1              
    bl fclose               
    bx lr

fopen_error:
    ldr r0, =err_msg
    bl perror
    mov r7, #1
    mov r0, #-1
    swi 0

err_msg:    .asciz "Error: Unable to open file.\n"
