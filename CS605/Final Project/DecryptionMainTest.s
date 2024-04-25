.text
.global main


main:
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

   #Prompt for p input
   LDR r0, =promptp
   BL printf

   #Input p value
   LDR r1, =p
   LDR r0, =pFormat
   BL scanf
   LDR r1, =p
   LDR r1, [r1]
   MOV r7, r1

   #Prompt for q input
   LDR r0, =promptq
   BL printf

   #Input q value
   LDR r1, =q
   LDR r0, =qFormat
   BL scanf
   LDR r1, =q
   LDR r1, [r1]
   MOV r8, r1

   #Calculate the phi
   SUB r7, r7, #1
   SUB r8, r8, #1
   MUL r9, r7, r8 @phi

   #Calculate the public key
   MOV r0, r9
   BL cpubexp 
   MOV r10, r0   @r10 stores pubKey
   
   #Output the public key
   MOV r1, r10
   LDR r0, =outputPubKey
   BL printf


   #Calculate the private key
   MOV r0, r10
   MOV r1, r9  @Phi
   BL cprivexp      
   MOV r10, r0       @r10 stores priKey


   #Output the private key
   MOV r1, r0
   LDR r0, =outputPriKey
   BL printf

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

         #Calculate n = p * q
         #Since we just calculated the phi = (p-1)(q-1), r7 = p-1, r8 = q-1
         #We have to turn r7 into p, r8 into q
         # p = (r7 + 1)
         # q = (r8 + 1)
         ADD r7, r7, #1
         ADD r8, r8, #1
         
         #Decrypt each character from the file
         MOV r0, r0
         MOV r1, r10
         MUL r2, r7, r8 
         BL decrypt

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
   promptp: .asciz "Please enter p: "
   pFormat: .asciz "%d"
   p: .word 0
   promptq: .asciz "Please enter q: "
   qFormat: .asciz "%d"
   q: .word 0
   outputPubKey: .asciz "The public key is: %d\n"
   outputPriKey: .asciz "The private key is: %d\n"
   delimeter: .asciz ","
