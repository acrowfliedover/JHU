# program name: finalExam.s
# Author: Rong Fan
# Purpose: prompt user for input until -1, and calculate the number of inputs, the total value and average value
# assume the average value is a int for now

# Psudocode:
#
# Initialize count = 0
# totalValue = 0
# prompt= "Enter a number"
# int currentNumber = 0,
#
# print prompt
# scanf(%d,=currentNumber)
# while (currentNumber!=-1){
#   count++
#   totalValue+=currentNumber
#   print prompt
#   scanf(%d,=currentNumber)
# } 
# 
# if(count==0)
#   print noInputMessage
#
# else{
#   print("You entered %d numbers.", =count)
#   print("Their sum is %d.", =totalValue)
#   int average = totalValue/count
#   print("Their average is %d.", average)
#}
#

# r4 : currentCount
# r5 : currentSum

.global main

.text
main:

# store lr on stack
	SUB sp, sp, #4
	STR lr, [sp]

# store r4 and r5 and initialize them
    SUB sp, $8
    STR r4, [sp]
    STR r5, [sp,#4]
    MOV r4, #0
    MOV r5, #0

# ask user input
askInput:
    LDR r0, =prompt
    BL printf
    LDR r0, =formatDecimal
    LDR r1, =currentNumber
    BL scanf

# check if entered -1, the exit
    LDR r0, =currentNumber
    LDR r0, [r0]
    CMP r0, #-1
    BEQ exitInput

# add the numbers and increase count
    ADD r4, #1
    ADD r5, r0
    B askInput

exitInput:
# check if count is 0, then output noInputMessage
    CMP r4, #0
    BNE continueOutput
        LDR r0, =noInputMessage
        BL printf
        BL exitProgram

continueOutput:
# output count and sum
    LDR r0, =outputCount
    MOV r1, r4
    BL printf
    LDR r0, =outputSum
    MOV r1, r5
    BL printf

# calculate and output average
    MOV r0, r5
    MOV r1, r4
    BL __aeabi_idiv
    MOV r1, r0
    LDR r0, =outputAverage
    BL printf

exitProgram:
    LDR r4, [sp]
    LDR r5, [sp, #4]
    LDR lr, [sp, #8]
    ADD sp, #12
    MOV pc, lr


.data
    prompt: .asciz "Please enter a number, enter [-1] to exit.\n"
	noInputMessage: .asciz "You entered no numbers.\n"
	outputCount: .asciz "You entered %d numbers.\n"
	outputSum: .asciz "Their sum is %d.\n"
    outputAverage: .asciz "Their average is %d.\n"

    formatDecimal:.asciz "%d"

	currentNumber: .word 0
	number2: .word 0

# End main