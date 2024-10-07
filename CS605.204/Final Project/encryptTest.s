    .text
    .global main
main:
    sub sp, sp, #4
    str lr, [sp, #0]

    mov r0, "This is a test"
    bl encrypt

    
    ldr lr, [sp,#0]
    add sp, sp, #4
    mov pc, lr