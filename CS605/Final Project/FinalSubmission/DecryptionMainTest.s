.text
.global decrypt


decrypt:
   #Push the stack
   SUB sp, sp, #40
   STR lr, [sp]
   STR r4, [sp, #4]
   STR r5, [sp, #8]
   STR r6, [sp, #12]
   STR r7, [sp, #16]
   STR r8, [sp, #20]
   STR r9, [sp, #24]
   STR r10, [sp, #28]
   STR r11, [sp, #32]

   #Prompt for n input
   LDR r0, =promptn
   BL printf

   #Input n value
   LDR r1, =n
   LDR r0, =nFormat
   BL scanf
   LDR r1, =n
   LDR r1, [r1]
   MOV r10, r1

   #Prompt for d input
   LDR r0, =promptd
   BL printf

   #Input d value
   LDR r1, =d
   LDR r0, =dFormat
   BL scanf
   LDR r1, =d
   LDR r1, [r1]
   MOV r7, r1



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



    LDR r1, =fin 
    LDR r0, [r1] 
    BL fclose 


   LDR lr, [sp]
   LDR r4, [sp, #4]
   LDR r5, [sp, #8]
   LDR r6, [sp, #12]
   LDR r7, [sp, #16]
   LDR r8, [sp, #20]
   LDR r9, [sp, #24]
   LDR r10, [sp, #28]
   LDR r11, [sp, #32]
   ADD sp, sp, #40
   MOV pc, lr



.data
   array: .space 150
   fin: .asciz "encrypted.txt"
   fout: .asciz "plaintext.txt"
   r: .asciz "r"
   w: .asciz "w"
   size: .word 80
   buffer: .space 100
   promptn: .asciz "Please enter n: "
   nFormat: .asciz "%d"
   n: .word 0
   promptd: .asciz "Please enter d: "
   dFormat: .asciz "%d"
   d: .word 0
   middleOutput: .asciz "The current value is: %d\n"
  
   delimeter: .asciz ","
