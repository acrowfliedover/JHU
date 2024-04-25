#
# File name: mainRong.s
# Author: Rong Fan
# Date: 04/20/2024
# Purpose: This is the main program for the final project, currently only generaty public and private key functions
# Testing cases
# 1.generate random keys									go to line xxx
# Range: currently generating p and q from 10 to 50, can be changed later
# 2.generate keys by entering primes								go to line xxx
# Will check if entered is between 10 and 50 can be changed to used larger numbers

# r4 = p
# r5 = q
# r6 = n
# r7 = phi
# r8 = e




.text
.global main

main:
# store lr on stack
	SUB sp, sp, #40
	STR lr, [sp]

input:
# Prompt user for a function to use
	LDR r0, =askFunction
	BL printf

# Input number
	LDR r0, =formatDecimal
	LDR r1, =action
	BL scanf

# Load number inputted
	LDR r0, =action
	LDR r1, [r0]

# Case 1 generate random keys
	CMP r1, #1
	BNE case2

	generateRandomPrime1:
	# generate random number between 10 and 50
	# by generating a number between 1 and 41 and then add 9
		MOV r0, #41
		BL getRandom
		ADD r4, r0, #9
	
	# check if it is a prime, if it's not, repeat
		MOV r0, r4
		BL checkPrime
		CMP r0, #0
		BEQ generateRandomPrime1
	
	generateRandomPrime2:
	# else continue to generate next random prime
		MOV r0, #41
		BL getRandom
		ADD r5, r0, #9
	
	# check if it is a prime or if it's equal to the first one
		CMP r5, r4
		BEQ generateRandomPrime2
		MOV r0, r5
		BL checkPrime
		CMP r0, #0
		BEQ generateRandomPrime2
	
	# after generated the two primes calculate n = p*q in r6 and phi=(p-1)(q-1) in r7
	# after that p and q are not useful anymore
		MUL r6, r4, r5
		SUB r4, #1
		SUB r5, #1
		MUL r7, r4, r5

	# call cpubexp and store e in r8
		MOV r0, r7
		BL cpubexp
		MOV r8, r0

	# output public keys
		MOV r2, r0
		MOV r1, r6
		LDR r0, =outputPublicKey
		BL printf
	
	# call cprivexp
		MOV r0, r8
		MOV r1, r7
		BL cprivexp

	# output private keys
		MOV r2, r0
		MOV r7, r2
		MOV r1, r6
		LDR r0, =outputPrivateKey
		BL printf
	
                                B Encryption
                                B Decryption
	# exit to main menu	
		#B input

# Case 2 generate keys by entering primes
case2:
	CMP r1, #2
	BNE case0

	askPrime1:
	# ask for the first prime
		LDR r0, =promptPrime1
		BL printf
		LDR r0, =formatDecimal
		LDR r1, =number1
		BL scanf

	# check if input is valid	
		LDR r0, =number1
		LDR r0, [r0]

	# use r1 as condition checker, false if not 0
		MOV r1, #0
		CMP r0, #10
		ADDLT r1, #1
		CMP r0, #50
		ADDGT r1, #1
		CMP r1, #0
		BEQ checkPrime1
			LDR r0, =askOutOfRange
			BL printf
			B askPrime1
	

	checkPrime1:
	# call checkPrime, make sure move r0 away first
		MOV r4, r0 
		BL checkPrime
		CMP r0, #0
		BNE askPrime2
			LDR r0, =askNotPrime
			BL printf
			B askPrime1
	
	askPrime2:
	# ask again for the second prime
		LDR r0, =promptPrime2
		BL printf
		LDR r0, =formatDecimal
		LDR r1, =number2
		BL scanf

	# check if input is valid	
		LDR r0, =number2
		LDR r0, [r0]

	# use r1 as condition checker, false if not 0
		MOV r1, #0
		CMP r0, #10
		ADDLT r1, #1
		CMP r0, #50
		ADDGT r1, #1
		CMP r1, #0
		BEQ checkPrime2
			LDR r0, =askOutOfRange
			BL printf
			B askPrime2
	

	checkPrime2:
	# call checkPrime, make sure move r0 away first
		MOV r5, r0 
		BL checkPrime
		CMP r0, #0
		BNE gotPQ
			LDR r0, =askNotPrime
			BL printf
			B askPrime2

	gotPQ:
	# now r4 and r5 are p and q, calculate n and phi
		MUL r6, r4, r5
		SUB r4, #1
		SUB r5, #1
		MUL r7, r4, r5

	# generate public keys calling cpubexp
		MOV r0, r7
		BL cpubexp
		MOV r8, r0

	# output public keys
		LDR r0, =outputPublicKey
		MOV r1, r6
		MOV r2, r8     @r8 - PublicKey
		BL printf

	# generate private keys calling cprivexp
		MOV r0, r8
		MOV r1, r7
		BL cprivexp
	
	# output private keys
                                
		MOV r2, r0
                                MOV r7, r2
		LDR r0, =outputPrivateKey
		MOV r1, r6
		BL printf

                                @r7 - PrivateKey
                                B Encryption
                                B Decryption
           
	# return to main menu
		#B input

# Case -1 exit the program, else return to input
case0:
	CMP r1, #-1
	BEQ endProgram
		LDR r0, =askNewCommand
		BL printf
		B input

endProgram:


Encryption:
               #Prompt user to input the message
               LDR r0, =promptInputText1
               BL printf

               LDR r0, =inputTextFormat
               LDR r1, =inputText
               BL scanf

               LDR r1, =inputText
               MOV r5, r1

    	LDR r0, =fout
    	LDR r1, =w
    	BL fopen
    	LDR r1, =fout
    	STR r0, [r1]
    	MOV r10, r0
    	MOV r4, #0

Loop:
    
    LDRB r3, [r5, r4]
    cmp r3, #0          @ Check for end of string
    beq done
    
    MOV r0, r3
    MOV r1, r8
    MOV r2, r6
    BL encrypt
    MOV r9, r0       


   MOV r0, r10
   LDR r1, =splitChar
   MOV r2, r9
   BL fprintf

   add r4, r4, #1
   B Loop
                               
done:               
    LDR r1, =fout
    LDR r0, [r1]
    BL fclose
    B Decryption


Decryption:          
    #r6 - n
    #r7 - privatekey                
    MOV r10, r6
    MOV r7, r7


   LDR r0, =fin  @Here we can not use fout!
   LDR r1, =r
   BL fopen
   LDR r1, =fin
   STR r0, [r1]



   #Initialize related values
   MOV r4, #0  @Count
   MOV r5, r0
   LDR r6, =size
   LDR r6, [r6]
   LDR r11, =array
   
   

StartLoop:
         
         #Open encrypted file        
         LDR r0, =buffer
         MOV r1, #200
         MOV r2, r5
                  
         BL fgets
         
         #StartSplitLoop:
         #Identified by delimeter
         MOV r0, r0
         LDR r1, =delimeter
         BL strtok      

         CMP r0, #0
         BEQ EndSplitLoop

         
         #Convert string into integer
         BL atoi


         MOV r8, r0
         
         #Decrypt each character from the file
         MOV r0, r8
         MOV r1, r7
         MOV r2, r10
         BL decrypt


         #MOV r1, r0
         #LDR  r0, =tempOutput
         #BL printf
 
         
         #Store the interger into r1
         MOV r1, r0

         
         #Store r1 in list r11 and locate at r4
         STR r1, [r11, r4, LSL #2]
         

         #If r4 <= r6, exit the loop
         #Else continue the loop
         CMP r4, r6          
         BGE EndLoop
         ADD r4, r4, #1
         B StartLoop
         

    EndSplitLoop:        
         B EndLoop

EndLoop:
         #Call related function to output the whole array
         #r5 - counter
         #r7 - size of the array
         #r8 - elements get form the array
         MOV r5, #0  
         MOV r7, r6  
         MOV r8, #0  
         BL printArray   
         
       
         BL arrayIntoFile

         #B input


# move lr back and return
	LDR lr, [sp]
	ADD sp, #40
	MOV pc, lr








.data
	askFunction: .asciz "\nHello user 10001, please give me a number to test for functions.\nEnter [1] to generate keys using random primes. \nEnter [2] to generate keys using inputted primes. \nEnter [-1] to exit. \n"
	promptPrime1: .asciz "Please enter a prime \n"
	promptPrime2: .asciz "Please enter a different prime \n"
	askNotPrime: .asciz "You entered a non-prime. Please enter a prime. \n"
	askOutOfRange: .asciz "You entered a number out of range.  Please enter a number between 10 and 50. \n"
	askNewCommand: .asciz "You entered an invalid command \n"

	formatDecimal: .asciz "%d"

	outputPublicKey: .asciz "Your public keys are: n = %d and e = %d.\n"
	outputPrivateKey: .asciz "Your private keys are: n = %d and d = %d.\n"
	outputFib: .asciz "The %dth Fibonacchi number is %d"
	
	action: .word 0
	number1: .word 0
	number2: .word 0

                promptInputText1: .asciz "\nPlease enter the text you want to encrypt: \n"
                inputTextFormat: .asciz "%s"
                inputText: .space 256
                outputText: .asciz "The text you input is: %s\n"


                promptInputText2: .asciz "\nPlease enter the target buffer: \n"
	encryptedBuffer: .space 256
                fout: .asciz "encrypted.txt"
                fin: .asciz "encrypted.txt"
                w: .asciz "w"
                r: .asciz "r"
	splitChar: .asciz "%d,"
                tempOutput: .asciz "The value is: %d\n"
                array: .space 150
	buffer: .space 100
                delimeter: .asciz ","
                size: .word 80
                plaintext: .asciz "plaintext.txt"
                format: .asciz "%d,"

# End main
