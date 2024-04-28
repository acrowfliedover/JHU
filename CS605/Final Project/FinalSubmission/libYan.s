
#Author: Yan Chen

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
