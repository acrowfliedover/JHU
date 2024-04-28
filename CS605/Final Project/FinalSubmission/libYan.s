
#Author: Yan Chen
.global decrypt
decrypt:
    MOV r7, r0   @r0 - private key: d
    MOV r10, r1  @r1 - modulus: n


   #Open file   
   LDR r0, =fin
   LDR r1, =r
   BL fopen
   LDR r1, =fin
   STR r0, [r1]

   #Initialize related value
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
         BL decryptCharacter

         #Store the interger into r1
         MOV r1, r0
         #LDR r0, =middleOutput
         #BL printf

         
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
         B  End     
    End:
    
    BL arrayIntoFile

.data
    fin: .asciz "encrypted.txt"
    array: .space 150
    r: .asciz "r"
    delimeter: .asciz ","
    size: .word 80
  

.global decryptCharacter
.text
decryptCharacter:
	# input:
                # r0: an integer b which the base
	# r1: an integer n which is the exponent(i.e. times)
	# r2: an integer m which is the modulo number
	# output: return b ^ n % m in r0


      PUSH {r7-r10,lr}
      MOV r0, r8
      MOV r1, r7
      MOV r2, r10
      BL moduloPower
      

      POP {r7-r10,pc}

.data

.text
.global printArray
printArray:
       	# input: 
                # r5: an integer represents the location of the array
	# r8: an character from the array in the location r5
	# r11: an array containing values to be printed
	# output: 
                # print out the ascii codes into type of character
   
   PUSH {lr}


PrintLoop:
   #Get the location from array r11
   LDR r8, [r11, r5, LSL #2]
   #LDRB r8, [r11, r5]
   CMP r8, #0
   BEQ EndPrintLoop
  
   #If the character we get is '\0', end up the loop
   MOV r1, r8
   CMP r1, #0
   BEQ EndPrintLoop
   
   #Print the element
   LDR r0, =outputFormat
   BL printf
   
   #r5 - Add up the counter
   ADD r5, r5, #1

   #Compare r5 with r7.
   #If r5>r7, end up loop
   #Else continue the loop
   CMP r5, r7
   BGT EndPrintLoop
   B PrintLoop


EndPrintLoop:
   LDR r0, =newLine
   BL printf  

 
   POP {pc}


.data 
   outputFormat: .asciz "%c,"
   newLine: .asciz "\n"

#Author: Yan Chen
.text 
.global arrayIntoFile
arrayIntoFile:
        # input: 
        # r11: an array containing values to be printed
        # output: 
        # write each character into file
                       
        #Related registers:
        #r3 - each character loaded from the array
        #r5 - the pointer to the file to be written
                

   PUSH {r5-r11, lr}
   
   #Open the file "plaintext.txt"
   LDR r0, =fout
   LDR r1, =w
   BL fopen
   LDR r1, =fout
   STR r0, [r1]
   MOV r5, r0
   MOV r6, #0   

WriteLoop:

   #Load character addresses from the array
   LDR r7, [r11, r6, LSL #2]


   #If the character equals '\0' then end up loop
   CMP r7, #0
   BEQ EndWriteLoop


   #Write the character into the file
   MOV r0, r5
   LDR r1, =format
   MOV r2, r7

   BL fprintf

   ADD r6, r6, #1
   #Continue the loop
   B WriteLoop


EndWriteLoop:

   #Close the file
   LDR r1, =fout
   LDR r0, [r1]
   BL fclose

   POP {r5-r11, pc}



.data 
   fout: .asciz "plaintext.txt"
   w: .asciz "w"
   buffer: .space 100
   format: .asciz "%c"
   output: .asciz "The current value is: %c\n"
