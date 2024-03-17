#
# File name: mainToTest.s
# Author: Rong Fan
# Date: 03/16/2024
# Purpose: This is the main program used to test the 4 functions in LibCoversion.s

.text
.global main

main:
# store lr on stack
	SUB sp, sp, #4
	STR lr, [sp]

# Begin testing kph

# Prompt user for a mile
	LDR r0, =askMiles
	BL printf

# Input miles
	LDR r0, =formatString
	LDR r1, =miles
	BL scanf

# Prompt user for an hour 
	LDR r0, =askHour
	BL printf

# Input hours
	LDR r0, =formatString
	LDR r1, =hours
	BL scanf

# Calling kph
	LDR r0, =hours
	LDR r0, [r0]
	LDR r1, =miles
	LDR r1, [r1]
	BL kph

# Output kph
	MOV r1, r0
	LDR r0, =outputkph
	BL printf

# End testing kph~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Begin testing CToF

# Prompt user for a degree Celsius
	LDR r0, =askCelsius
	Bl printf

# Input Celsius
	LDR r0, =formatString
	LDR r1, =Celsius
	BL scanf

# Call CToF
	LDR r0, =Celsius
	LDR r0, [r0]
	BL CToF

# Output Fahrenheit
	MOV r1, r0
	LDR r0, =outputFahrenheit
	BL printf

# End testing CtoF~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Begin test InchesToFt

# Prompt user for inches
	LDR r0, =askInches
	BL printf

# Input inches
	LDR r0, =formatString
	LDR r1, =inches
	BL scanf

# Call InchesToFt
	LDR r0, =inches
	LDR r0, [r0]
	BL InchesToFt

# Output feet
	MOV r2, r1
	MOV r1, r0
	LDR r0, =outputFeet
	BL printf

# End testing InchesToFt~~~~~~~~~~~~~~~~~~~~~~


# move lr back and return
	LDR lr, [sp]
	ADD sp, #4
	MOV pc, lr

.data
	askMiles: .asciz "Hello user 10001, please enter a number of miles. \n"
	askHour: .asciz "Please enter a number of hours. \n"
	askCelsius: .asciz "Please enter a number of degree Celsius. \n"
	askInches: .asciz "Please enter a number of inches. \n"

	formatString: .asciz "%d"
	
	outputkph: .asciz "That is %d kilometers per hour. \n"
	outputFahrenheit: .asciz "That is %d in Fahrenheit. \n"
	outputFeet: .asciz "That is %d.%d feet. \n"
	
	miles: .word 0
	hours: .word 0
	Celsius: .word 0
	inches: .word 0

# End main
