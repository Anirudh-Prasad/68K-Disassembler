*-----------------------------------------------------------
* Title      : Disassembler 
* Written by : ProjectGroup 4
* Date       : 08/18/2020
* Description: 
*  Disassembler that converts a memory image of instructions and data back to 68000 assembly language and 
*  output the disassembled code to the display. This disassembler supports the following OP Codes:
*  NOP,MOVE,MOVEM,ADD,SUB,MULS,DIVU,LEA,AND,NOT,LSL,ASL,Bcc(BGT,BLE,BEQ),JSR,RTS and BRA.
*  and the following Effective Addressing Modes:
*  Data Register Direct,Address Register Direct, Address Register Indirect, Immediate Data, Address Register Indirect with Post incrementing
*  Address Register Indirect with Pre decrementing,Absolute Long Address and Absolute Word Address.
*-----------------------------------------------------------
    ORG    $1000
START:  

*********I/O Section*************
BEGIN              
    LEA     WELCOME_MESSAGE, A1 ; Loads welcome-MESSAGE into address register A1
    MOVE.B  #14, D0             ; Moves the number 14 into data register D0
    TRAP    #15                 ; Message is displayed
    JSR     GETINPUT            ; Jumps to subroutine to get input from user
    BRA     CONTINUE            ; Continues disassebler process
    
GETINPUT 
    MOVE.B  #$00, LOOP_COUNTER
    MOVE.B  #$00, MOVEM_COUNTER
    MOVE.B  #$00, REGISTER_COUNTER
    MOVE.B  #$00, IMMEDIATE_SIZE_FLAG
*    MOVE.L  #$00000000, TOTAL_LINES

    LEA     STARTADDRESS_MESSAGE, A1    ; Print Starting Address input Message
    MOVE.B  #14, D0          
    TRAP    #15  
    
    LEA     INPUT_FROM_USER, A1 
    MOVE.B  #2,D0        ; Trap task 2 does the following:
    TRAP    #15          ; Read string from keyboard and store at (A1), NULL terminated, length retuned in D1.W (max 80)
    
    CMP.B   #8, D1       ; Test Starting Address length
    BNE     ADDR_ERROR   ; Branch to Address Error if Address has invalid length, exit program
    
    ADD.B   #1,D1        ; increment by 1, since we want to go through all 8 chars        
    MOVEA.L #$200,A3 
    JSR     CONVERTTOHEX ; Jump to subroutine to convert input to hex value
    
    MOVE.L  D5, D6       ; We move address into D6
    MOVE.B  #31, D7      ; Move 31 into D7 as we want to shit 31 bits
    LSL.L   D7, D6       ; We shift 31 bits to the left 
    LSR.L   D7, D6       ; Isolates last bit
    CMP.B   #$1, D6      ; Compares last bit to check if Address is even
    BEQ     ADDR_ERROR   ; If 1 then even, then we branch to invalid address
    
    MOVE.L  D5, StartAddress
   
    
    MOVE.B  #0, D2       ; Start D2 with 0, to properly counter in the printAddressLoop
    MOVE.B  #0, D3       ; Start D3 with 0, to properly counter in the change_loop
    MOVE.B  #0, D4       ; Start D4 with 0, to properly counter in the shifting 
    
    LEA     ENDADDRESS_MESSAGE, A1 ; Print Ending Address input Message
    MOVE.B  #14, D0                
    TRAP    #15                    
    
    LEA     USERINPUT, A1 
    MOVE.B  #2,D0        ; Trap task 2 does the following:
    TRAP    #15          ; Read string from keyboard and store at (A1), NULL terminated, length retuned in D1.W (max 80)
    
    CMP.B   #8, D1       ; Test Ending Address length
    BNE     ADDR_ERROR   ; Branch to Address Error if Address is invalid, exit program

    ADD.B   #1,D1        ; Increment by 1, since we want to go through all 8 chars        
    MOVEA.L #$200,A3
    JSR     CONVERTTOHEX ; Jump to subroutine to convert input to hex value
    
    MOVE.L  D5, D6       ; We move the ending address into D6
    MOVE.B  #31, D7      
    LSL.L   D7, D6       ; Shift 31 bits to the left 
    LSR.L   D7, D6       ; Shift 31 bits to the right to isolate last bit
    CMP.B   #$1, D6      ; Compares last bit to check if Address is even
    BEQ     ADDR_ERROR   ; If the bit is 1 then the address is odd so we branch to invalid address
    
    CMP.L   StartAddress, D5    ; Compare Starting address with ending Address
    BLT     ADDR_VALUE_ERROR    ; Branch to error if starting address is greater than ending address 
    MOVE.L  StartAddress,D5
    MOVE.L  StartAddress,A4     ; Moved into address register to use when printing all values later 
    
    RTS                  

ADDR_ERROR
    LEA     ADDRESS_ERROR, A1   ; Print address error message
    MOVE.B  #14, D0          
    TRAP    #15               
    BRA     NEXT_OP_STAGE     
    
ADDR_VALUE_ERROR
    LEA     ADDRESS_VAL_ERROR, A1 ; Print address value error message
    MOVE.B  #14, D0          
    TRAP    #15               
    BRA     NEXT_OP_STAGE     
    
CONVERTTOHEX             ; Loop to convert/change from ASCII to hex
    MOVE.B  (A1)+,D5     
    ADD.B   #1,D3        ; Increment the loop counter 
    CMP.B   D3,D1        ; Check if we reached the end, being done going through all chars
    BEQ     TRANSFER     ; Branch if reached end of loop
    
    CMP.B   #$40,D5      ; Check if it is a letter
    BGT     LETTER
    
    CMP.B   #$3A,D5      ; Check if it is a number
    BLT     NUMBER
    
LETTER
    SUB.B   #$37,D5      ; Subtract to get the letter
    MOVE.B  D5,(A3)+
    BRA     CONVERTTOHEX ; Conversion is done

NUMBER
    SUB.B   #$30,D5      ; Subtract to get the number
    MOVE.B  D5,(A3)+     
    BRA     CONVERTTOHEX  ; Conversion is done

TRANSFER
    MOVEA.L #$200,A3 
    MOVE.B  #0,D3        ; Initialize to 0, will be used as counter variable in loop below

SHIFTING
    ADD.B   #1,D3        ; Increment the variable
    CMP.B   #2,D3        ; Since we will transfer 4 at a time, we only loop twice
    BGT     RESUME       ; Branch if greater than 2, to make sure we loop twice
    MOVE.B  (A3)+,D4     ; Transfer the value
    LSL.L   #4,D4        ; Shift left one spot, for the next value
    ADD.B   (A3)+,D4     ; Do the same as above 2 more times, but use ADD, successfully adding 4 values
    LSL.L   #4,D4
    ADD.B   (A3)+,D4
    LSL.L   #4,D4
    ADD.B   (A3)+,D4
    LSL.L   #4,D5        ; Shift left 4 times, using LSL lines below, to add the values from D4
    LSL.L   #4,D5
    LSL.L   #4,D5
    LSL.L   #4,D5
    ADD.W   D4,D5        ; Add the values found from D4 into D5, where shifting was done
    BRA     SHIFTING
    
    
PRINTADDRESSLOOP      ; Loop to print each digit of the address
    ADD.B   #1,LOOP_COUNTER
    CMP.B   #9,LOOP_COUNTER
    BEQ     RESUME
    ROL.L   #4,D5     ; Move the original value also at the location assigned for user input
    MOVE.B  D5,D6
    AND.B   #$0F,D6
    JSR     COMPARE   ; Jump to compare subroutine to print digit
    BRA     PRINTADDRESSLOOP 
    
COMPARE               ; Compare given digit to values from 0 to F and branch to print function
    CMP.B   #$0,D6
    BEQ     PRINT0
    CMP.B   #$1,D6
    BEQ     PRINT1
    CMP.B   #$2,D6
    BEQ     PRINT2
    CMP.B   #$3,D6
    BEQ     PRINT3
    CMP.B   #$4,D6
    BEQ     PRINT4
    CMP.B   #$5,D6
    BEQ     PRINT5
    CMP.B   #$6,D6
    BEQ     PRINT6
    CMP.B   #$7,D6
    BEQ     PRINT7
    CMP.B   #$8,D6
    BEQ     PRINT8
    CMP.B   #$9,D6
    BEQ     PRINT9
    CMP.B   #$A,D6
    BEQ     PRINTA
    CMP.B   #$B,D6
    BEQ     PRINTB
    CMP.B   #$C,D6
    BEQ     PRINTC
    CMP.B   #$D,D6
    BEQ     PRINTD
    CMP.B   #$E,D6
    BEQ     PRINTE
    CMP.B   #$F,D6
    BEQ     PRINTF
    
PRINT0              ; Print 0
    MOVE.B  #$30,D1
    MOVE.B  #6,D0
    TRAP    #15
    RTS

PRINT1              ; Print 1
    MOVE.W  #$31,D1
    MOVE.B  #6,D0
    TRAP    #15
    RTS

PRINT2              ; Print 2
    MOVE.B  #$32,D1
    MOVE.B  #6,D0
    TRAP    #15
    RTS
    
PRINT3              ; Print 3
    MOVE.B  #$33,D1
    MOVE.B  #6,D0
    TRAP    #15
    RTS
    
PRINT4              ; Print 4
    MOVE.B  #$34,D1
    MOVE.B  #6,D0
    TRAP    #15
    RTS
    
PRINT5              ; Print 5
    MOVE.B  #$35,D1
    MOVE.B  #6,D0
    TRAP    #15
    RTS
    
PRINT6              ; Print 6
    MOVE.B  #$36,D1
    MOVE.B  #6,D0
    TRAP    #15
    RTS
    
PRINT7              ; Print 7
    MOVE.B  #$37,D1
    MOVE.B  #6,D0
    TRAP    #15
    RTS
    
PRINT8              ; Print 8
    MOVE.B  #$38,D1
    MOVE.B  #6,D0
    TRAP    #15
    RTS
    
PRINT9              ; Print 9
    MOVE.B  #$39,D1
    MOVE.B  #6,D0
    TRAP    #15
    RTS
    
PRINTA              ; Print A
    MOVE.B  #$41,D1
    MOVE.B  #6,D0
    TRAP    #15
    RTS
    
PRINTB              ; Print B
    MOVE.B  #$42,D1
    MOVE.B  #6,D0
    TRAP    #15
    RTS
    
PRINTC              ; Print C
    MOVE.B  #$43,D1
    MOVE.B  #6,D0
    TRAP    #15
    RTS
    
PRINTD              ; Print D
    MOVE.B  #$44,D1
    MOVE.B  #6,D0
    TRAP    #15
    RTS
    
PRINTE              ; Print E
    MOVE.B  #$45,D1
    MOVE.B  #6,D0
    TRAP    #15
    RTS
    
PRINTF              ; Print F
    MOVE.B  #$46,D1
    MOVE.B  #6,D0
    TRAP    #15
    RTS

RESUME
    CLR     LOOP_COUNTER    ; Clear the loop counter
    RTS

CONTINUE
    ADD.B   #1, TOTAL_LINES ; Counter to track the total number of lines printed so far
    LEA     NEW_LINE,A1     ; Print new line to the console
    MOVE.B  #14,D0
    TRAP    #15
    CLR     D1
    
    JSR     PRINTADDRESSLOOP   ; Print the address
                   
    MOVEA.L A4,A6
    MOVE.W  (A4)+,D0        ; Loop through and store each instruction in D0
    MOVE.L  A4,D5           ; Save each address in D5
    
    CMP.W   #$FFFF,D0       ; Check to see if the last instruction is reached and if so, branch to end the current part of program
    BEQ     NEXT_OP_STAGE   ; Branch to the next ending part of the program
                      
    CLR     D1              ; Clear all the data registers
    CLR     D3
    CLR     D6
    CLR     D7    
    
    MOVEA.L #$00000000,A0   ; All the address registers to clear
    MOVEA.L #$00000000,A1
    MOVEA.L #$00000000,A2
    MOVEA.L #$00000000,A3
    
    MOVE.W  D0,D3           ; Move the original value to D3, so we have 2 copies of instruction and we can isolate first 4 bits
    MOVE.B  #12,D6
    LSR.W   D6,D3           ; Shift 12 bits to the right to isolate first 4 bits  (yyyy xxxx xxxx xxxx)

    CMP.W   #%0001,D3       ; Check to see if the first 4 bits fit MOVE.B
    BEQ     CHECK_MOVEB
    
    CMP.W   #%0010,D3       ; Check to see if the first 4 bits fit MOVE.L
    BEQ     CHECK_MOVEL
    
    CMP.W   #%0011,D3       ; Check to see if the first 4 bits fit MOVE.W
    BEQ     CHECK_MOVEW
    
    CMP.W   #%0100,D3       ; Check to see if the first 4 bits fit Group0100
    BEQ     CHECK_GROUP0100
    
    CMP.W   #%0110,D3       ; Check to see if the first 4 bits fit Branches
    BEQ     CHECK_BRANCHES
    
    CMP.W   #%1000,D3       ; Check to see if the first 4 bits fit DIVU.W
    BEQ     CHECK_DIVUW
    
    CMP.W   #%1001,D3       ; Check to see if the first 4 bits fit SUB.B
    BEQ     CHECK_SUB     
    
    CMP.W   #%1100,D3       ; Check to see if the first 4 bits fit MULS.W and AND
    BEQ     CHECK_MULSWAND
    
    CMP.W   #%1101,D3       ; Check to see if the first 4 bits fit ADD
    BEQ     CHECK_ADD
    
    CMP.W   #%1110,D3       ; Check to see if the first 4 bits fit Shifts
    BEQ     CHECK_SHIFTS
    
    MOVE.L  #$00000000,INVALID_DATA_VALUE   ; Set Invalid data value to 0
    ADD.L   D0,INVALID_DATA_VALUE           ; Add data to invalid data value variable for printing purposes
    BRA     INVALID_OPCODE                  ; Branch invalid opcode handling function
    
*Jumping to Specific OP code group for decoding
 
CHECK_MOVEB                 ; Jump to MOVEB
    CLR     D3
    JSR     MOVE
    BRA     RESET_SCREEN    ; Branch to reset screen to see if the screen needs to be cleared and redisplayed

CHECK_MOVEL                 ; Jump to MOVEL
    CLR     D3
    JSR     MOVE
    BRA     RESET_SCREEN

CHECK_MOVEW                 ; Jump to MOVEW
    CLR     D3
    JSR     MOVE
    BRA     RESET_SCREEN

CHECK_GROUP0100             ; Jump to GROUP0100
    CLR     D3
    JSR     GROUP0100
    BRA     RESET_SCREEN

CHECK_BRANCHES              ; Jump to BRANCHES
    CLR     D3
    JSR     BRANCHES
    BRA     RESET_SCREEN

CHECK_DIVUW                 ; Jump to DIVUW
    CLR     D3
    JSR     DIVUW
    BRA     RESET_SCREEN

CHECK_SUB                   ; Jump to SUB
    CLR     D3
    JSR     SUB
    BRA     RESET_SCREEN  

CHECK_MULSWAND              ; Jump to MULSWAND
    CLR     D3
    JSR     MULSWAND
    BRA     RESET_SCREEN

CHECK_ADD                   ; Jump to ADD
    CLR     D3
    JSR     ADD
    BRA     RESET_SCREEN

CHECK_SHIFTS                ; Jump to SHIFTS
    CLR     D3
    JSR     SHIFTS
    BRA     RESET_SCREEN
 
*********OP Code Section*************    
MOVE
    CLR     D4                ; Clear D4 to manipulate bits for decoding 
    MOVE.W  D0,D4             ; Move instruction to D4 
    
    LSR.W   #7,D4             ; Shift to get first 2 bits and ensure operation is correct (yyxx xxxx xxxx xxxx)
    LSR.W   #7,D4
    CMP.B   #$00,D4
    BEQ     MOVE_OUTPUT       ; Branch to print OP Code label
    
    RTS                       ; RTS to continue disassembler process

GROUP0100
    CMP.W   NOP_OPCODE,D0     ; Compare if its NOP
    BEQ     NOP_OUTPUT
    
    CMP.W   RTS_OPCODE,D0     ; Compare if its RTS
    BEQ     RTS_OUTPUT
    
    CLR     D4
    MOVE.W  D0,D4
    LSR.W   #6,D4             ; Shift to get first 10 bits (yyyy yyyy yyxx xxxx)
    CMP.W   JSR_OPCODE,D4     ; Compare to JSR bits
    BEQ     JSR_OUTPUT
    
    CLR     D4
    MOVE.W  D0,D4
    LSR.W   #8,D4             ; Shift to get first 8 bits (yyyy yyyy xxxx xxxx)
    CMP.W   NOT_OPCODE,D4     ; Compare to NOT bits
    BEQ     NOT_OUTPUT
    
    CLR     D4
    MOVE.W  D0,D4
    LSL.W   #7,D4             ; Shift to get the 8th bit (xxxx xxxy xxxx xxxx)
    LSR.W   #8,D4
    LSR.W   #7,D4             ; Shift to isolate the 8th bit (xxxx xxxx xxxx xxxy)
    CMP.W   #$1,D4            ; Since only LEA has 1 as the 8th bit, check if that's true here 
    BEQ     LEA_OUTPUT   
    
    CLR     D4
    MOVE.W  D0,D4           
    LSL.W   #4,D4             ; Shift to get the 5 bits from 5th bit to 9th bit (yyyy yxxx xxxx xxxx)
    LSR.W   #8,D4             
    LSR.W   #3,D4             ; Shift to isolate the 5 bits (xxxx xxxx xxxy yyyy)
    
    CMP.W   #$19,D4           ; Check if hex value, which is unique, 19, only for MOVEM for the 5 bits, if it matches
    BEQ     MOVEM_OUTPUT      ; print MOVEM and do that OP Code related operations accordingly
    
    CMP.W   #$11,D4           ; Check if hex value, which is unique, 11, only for MOVEM for the 5 bits, if it matches
    BEQ     MOVEM_OUTPUT      ; print MOVEM and do that OP Code related operations accordingly

    MOVE.L  #$00000000,INVALID_DATA_VALUE
    ADD.L   D0,INVALID_DATA_VALUE       ; Add data to invalid data value variable for printing purposes
    
    BRA     INVALID_OPCODE    ; If the OPMode does that satisfy above conditions, then it is invalid and branches

    RTS

BRANCHES
    CLR     D4
    MOVE.W  D0,D4
    LSL.W   #4,D4             ; Shift to get condition bits (xxxx yyyy xxxx xxxx) --> (yyyy xxxx xxxx xxxx)    
    LSR.W   #6,D4
    LSR.W   #6,D4             ; We have isolated the condition bits (xxxx xxxx xxxx yyyy)
    
    CMP.W   #$0,D4            ; Compare to BRA bits
    BEQ     BRA_OUTPUT 
    
    CMP.W   #$E,D4            ; Compare to BGT bits
    BEQ     BGT_OUTPUT 
    
    CMP.W   #$F,D4            ; Compare to BLE bits
    BEQ     BLE_OUTPUT 
    
    CMP.W   #$7,D4            ; Compare to BEQ bits
    BEQ     BEQ_OUTPUT 
    
    CMP.W   #$4,D4            ; Compare to BCC bits
    BEQ     BCC_OUTPUT 
    
    MOVE.L  #$00000000,INVALID_DATA_VALUE
    ADD.L   D0,INVALID_DATA_VALUE      ; Add data to invalid data value variable for printing purpose
    
    BRA     INVALID_OPCODE    ; If the OPMode does that satisfy above conditions, then it is invalid and branches
    
    RTS

DIVUW
    CLR     D4
    MOVE.W  D0,D4
    LSR.W   #6,D4             
    LSR.W   #6,D4             ; Shift to get first 4 bits and validate (yyyy xxxx xxxx xxxx) 
    CMP.W   #$8,D4            ; Compare to DIVUW bits
    BEQ     DIVUW_OUTPUT      ; Branch to print DIVU and do further operations of the same OP Code

    RTS

SUB
    CLR     D4
    MOVE.W  D0,D4    
    LSL.W   #7,D4             ; Shift to get the first 3 OP Mode bits (yyyy xxxx xxxx xxxx)
    LSR.W   #8,D4             
    LSR.W   #5,D4             ; Isolate the 3 OP Mode bits (xxxx xxxx xxxx yyyy)
    
    MOVE.L  #$00000000,INVALID_DATA_VALUE
    ADD.L   D0,INVALID_DATA_VALUE   ; Add data to invalid data value variable for printing purpose
    
    
    CMP.B   #$3,D4          ; Check if it is not SUB, since SUB only supports all values apart from 3 and 7 
    BEQ     INVALID_OPCODE  ; Branch if invalid
    
    CMP.B   #$7,D4          ; Check if it is not SUB, since SUB only supports all values apart from 3 and 7
    BEQ     INVALID_OPCODE  ; Branch if invalid

    CLR     D4
    MOVE.W  D0,D4    
    LSR.W   #6,D4             
    LSR.W   #6,D4         ; Shift to confirm first four bits (yyyy xxxx xxxx xxxx) --> (xxxx xxxx xxxx yyyy) 
    
    CMP.W   #$9,D4        ; Compare to SUB bits
    BEQ     SUB_OUTPUT
    
    RTS

MULSWAND
    CLR     D4
    MOVE.W  D0,D4    
    LSL.W   #7,D4             
    LSR.W   #8,D4             
    LSR.W   #5,D4             ; Shift to get 8th 9th and 10th bits (xxxx xxxy yyxx xxxx)
    
    CMP.W   #$7,D4            ; Compare to MULSW bits
    BEQ     MULSW_OUTPUT  
    
       
    CMP.W   #$0,D4            ; Compare to AND OPMode bits
    BEQ     AND_OUTPUT

    CMP.W   #$1,D4            ; Compare to AND OPMode bits
    BEQ     AND_OUTPUT
    
    CMP.W   #$2,D4            ; Compare to AND OPMode bits
    BEQ     AND_OUTPUT
    
    CMP.W   #$4,D4            ; Compare to AND OPMode bits
    BEQ     AND_OUTPUT

    CMP.W   #$5,D4            ; Compare to AND OPMode bits
    BEQ     AND_OUTPUT
    
    CMP.W   #$6,D4            ; Compare to AND OPMode bits
    BEQ     AND_OUTPUT
    
    MOVE.L  #$00000000,INVALID_DATA_VALUE
    ADD.L   D0,INVALID_DATA_VALUE ; Add data to invalid data value variable for printing purpose
    
    
    BRA     INVALID_OPCODE    ; If the OPMode does that satisfy above conditions, then it is invalid and branches to the label

    RTS

ADD
    MOVE.L  #$00000000,INVALID_DATA_VALUE
    ADD.L   D0,INVALID_DATA_VALUE   ; Add data to invalid data value variable for printing purpose
    
    CLR    D4
    MOVE.W D0,D4
    LSL.W  #7,D4
    LSR.W  #8,D4
    LSR.W  #5,D4             ; Check for direction bit to make sure it only work for shifting to the left
    
    CMP.B  #3,D4             ; Check if it is ADDA
    BEQ    INVALID_OPCODE    ; If the OPMode does that satisfy above conditions, then it is invalid and branches to the label
    
    CMP.B  #7,D4             ; Check if it is ADDA
    BEQ    INVALID_OPCODE    ; If the OPMode does that satisfy above conditions, then it is invalid and branches to the label

    CLR     D4
    MOVE.W  D0,D4    
    LSR.W   #6,D4           ; Shift to validate first four bits (yyyy xxxx xxxx xxxx)  
    LSR.W   #6,D4
    
    CMP.W   #$D,D4          ; Compare to ADD bits
    BEQ     ADD_OUTPUT
    
    RTS

SHIFTS
    MOVE.L  #$00000000,INVALID_DATA_VALUE
    ADD.L   D0,INVALID_DATA_VALUE   ; Add data to invalid data value variable for printing purpose
    
    CLR    D4
    MOVE.W D0,D4
    LSL.W  #7,D4
    LSR.W  #8,D4
    LSR.W  #7,D4             ; Check for direction bit to make sure it only work for shifting to the left
    
    CMP.B  #0,D4            
    BEQ    INVALID_OPCODE    ; If the OPMode does that satisfy above conditions, then it is invalid and branches to the label
    
    CLR    D4
    MOVE.W D0,D4
    LSL.W  #8,D4
    LSR.W  #7,D4
    LSR.W  #7,D4           ; Shift to get 9th and 10 th bits(xxxx xxxx yyxx xxxx) 
        
    CMP.B  #$3,D4          ; Check if its LSL(Memory shift) or ASL(Memory shift)
    BEQ    MEMORY_SHIFT 
    
    BRA    ASL_LSL_SHIFT   ; Every other number will indicate the size for ASL or LSL
    
    RTS
    
MEMORY_SHIFT
    CLR    D4
    MOVE.W D0,D4
    LSL.W  #5,D4
    LSR.W  #8,D4
    LSR.W  #7,D4            ; Find the bit that is 0 for LSL/ASL and 1 for ROL (xxxx xyxx xxxx xxxx)

    MOVE.L  #$00000000,INVALID_DATA_VALUE
    ADD.L   D0,INVALID_DATA_VALUE       ; Make sure correct value is printed for invalid data
    
    CMP.B  #$1,D4           ; Check to make sure its ASL/LSL but if not, then it is invalid op code
    BEQ    INVALID_OPCODE     
    
    CLR    D4
    MOVE.W D0,D4
    LSL.W  #6,D4
    LSR.W  #8,D4
    LSR.W  #7,D4    ; Shift to differenciate between ASL and LSL (xxxx xxyx xxxx xxxx)
    
    CMP.B  #$1,D4
    BEQ    LSL_MEMORY_SHIFT_OUTPUT      ; Check the 7th bit, which is 1 for LSL and 0 for ASL 
    
    BRA    ASL_MEMORY_SHIFT_OUTPUT      ; If the 7th bit is 0, then got to ASL memory shift
    
    RTS

ASL_LSL_SHIFT    
    CLR    D4
    MOVE.W D0,D4
    LSL.W  #8,D4    
    LSL.W  #3,D4
    LSR.W  #8,D4
    LSR.W  #7,D4                ; find the bit that is 0 for LSL/ASL and 1 for ROL (xxxx xxxx xxxy xxxx)

    MOVE.L  #$00000000,INVALID_DATA_VALUE
    ADD.L   D0,INVALID_DATA_VALUE       ; Make sure correct value is printed for invalid data
    
    CMP.B  #$1,D4               ; check to make sure its ASL/LSL but if not, then it is invalid op code
    BEQ    INVALID_OPCODE     
    
    CLR    D4
    MOVE.W D0,D4    
    LSL.W  #8,D4
    LSL.W  #4,D4
    LSR.W  #8,D4
    LSR.W  #7,D4        ; Shift to differenciate between ASL and LSL (xxxx xxxx xxxx yxxx)
    
    CMP.B  #$1,D4
    BEQ    LSL_LOGIC_SHIFT_OUTPUT     ; Check the differentiating bit, which is 1 for LSL and 0 for ASL 
    
    BRA    ASL_LOGIC_SHIFT_OUTPUT     ; If the bit is 0, then got to ASL memory shift
    
    RTS

RESET_SCREEN                    ; Check to see if the screen needs to be cleared and redisplayed
    CMP.B   #$18,TOTAL_LINES
    BEQ     PRINT_AFTER_ENTER   ; Prompt user to display more lines 
    BRA     CONTINUE
    

PRINT_AFTER_ENTER
    MOVE.L  #$00000000,A1
    LEA     ENTER_AGAIN_MESSAGE, A1    ; "Press enter for more lines" message displayed
    MOVE.B  #14, D0          
    TRAP    #15  
    
    MOVE.L  #$00000000, INPUT_FROM_USER
    LEA     INPUT_USER , A1 
    MOVE.B  #2,D0        ; Trap task 2 does the following:
    TRAP    #15          ; Read string from keyboard and store at (A1), NULL terminated, length retuned in D1.W (max 80)
    
    CLR     TOTAL_LINES  ; Restart line Count 
    
    BRA     CONTINUE     ; Branch to resume disassembly
 
* all output labels here
MOVE_OUTPUT
    CLR     D4
    MOVE.L  D0,D4
    
    LEA     PRINT_MOVE,A1   ; Print OP Code Label
    MOVE.B  #14,D0
    TRAP    #15
    
    CLR     D3
    MOVE.L  D4,D3 
    
    LSL.W   #2,D3             
    LSR.W   #7,D3             
    LSR.W   #7,D3           ; Shift to get size bits (xxyy xxxx xxxx xxxx)
    
    CMP.B   #$1,D3            ; 01 - byte 
    BEQ     Print_MOVE_BYTE
    
    * Default MOVE works as a MOVE.W and has the same properties.

    CMP.B   #$3,D3            ; 11 - word
    BEQ     Print_MOVE_WORD

    CMP.B   LONG_VAR,D3       ; 10 - long 
    BEQ     Print_MOVE_LONG
    
    JSR     EA_MOVE           ; Jump to EA decoding
    RTS
    
NOP_OUTPUT                      ; Print NOP output
    LEA     PRINT_NOP,A1       
    MOVE.B  #14,D0
    TRAP    #15
    RTS
    
RTS_OUTPUT                      ; Print RTS output
    LEA     PRINT_RTS,A1
    MOVE.B  #14,D0
    TRAP    #15
    RTS
    
JSR_OUTPUT                      ; Print JSR output
    CLR     D4
    MOVE.L  D0,D4

    LEA     PRINT_JSR,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    JSR     EA_JSR              ; Jump to EA Decoding 
    RTS
    
NOT_OUTPUT
    CLR     D4
    MOVE.L  D0,D4

    LEA     PRINT_NOT,A1      ; Print NOT Label
    MOVE.B  #14,D0
    TRAP    #15
    
    CLR     D3
    MOVE.L  D4,D3             ; Move original value to D3, since D3 will change below
    
    LSL.W   #8,D3             ; Shift to get size bits (xxxx xxxx yyxx xxxx) 
    LSR.W   #7,D3             
    LSR.W   #7,D3             ; Shift to isolate the 2 size bits (xxxx xxxx xxxx xxyy)
    
    CMP.B   BYTE_VAR,D3       ; 00 - byte 
    BEQ     Print_NOT_BYTE

    * Default NOT works as a NOT.W and has the same properties.

    CMP.B   WORD_VAR,D3       ; 01 - word
    BEQ     Print_NOT_WORD

    CMP.B   LONG_VAR,D3       ; 10 - long 
    BEQ     Print_NOT_LONG 
    
    JSR     EA_NOT            ; Jump to EA decoding
    RTS
    
LEA_OUTPUT
    CLR     D4
    MOVE.L  D0,D4

    LEA     PRINT_LEA,A1      ; Print LEA Label
    MOVE.B  #14,D0
    TRAP    #15
    
    JSR     EA_LEA            ; Jump to Ea Decoding
    RTS
    
Print_MOVE_BYTE 
    MOVE.B  #$0,IMMEDIATE_SIZE_FLAG
    JSR     Print_BYTE_SIZE   ; Print .B on the screen, using the label
    BRA     MOVE_REST_CODE
Print_MOVE_WORD
    MOVE.B  #$0,IMMEDIATE_SIZE_FLAG
    JSR     Print_WORD_SIZE   ; Print .W on the screen, using the label
    BRA     MOVE_REST_CODE
Print_MOVE_LONG
    MOVE.B  #$1,IMMEDIATE_SIZE_FLAG
    JSR     Print_LONG_SIZE   ; Print .L on the screen, using the label
    BRA     MOVE_REST_CODE
    
MOVE_REST_CODE
    JSR     EA_MOVE            ; Jump to EA Decoding
    RTS
    
Print_NOT_BYTE
    MOVE.B  #$0,IMMEDIATE_SIZE_FLAG
    JSR     Print_BYTE_SIZE   ; Print .B on the screen, using the label
    BRA     NOT_REST_CODE

Print_NOT_WORD
    MOVE.B  #$0,IMMEDIATE_SIZE_FLAG
    JSR     Print_WORD_SIZE   ; Print .W on the screen, using the label
    BRA     NOT_REST_CODE

Print_NOT_LONG
    MOVE.B  #$1,IMMEDIATE_SIZE_FLAG
    JSR     Print_LONG_SIZE   ; Print .L on the screen, using the label
    BRA     NOT_REST_CODE

NOT_REST_CODE
    JSR     EA_NOT            ; Jump to EA Decoding
    RTS

MOVEM_OUTPUT
    CLR     D4
    MOVE.L  D0,D4

    LEA     PRINT_MOVEM,A1    ; MOVEM Label
    MOVE.B  #14,D0
    TRAP    #15
    
    CLR     D3
    MOVE.L  D4,D3 
    
    LSL.W   #8,D3
    LSL.W   #1,D3             
    LSR.W   #8,D3             
    LSR.W   #7,D3             ; Shift to get size bit(xxxx xxxx xyxx xxxx)
    
    * Default MOVEM works as a MOVEM.W and has the same properties.

    CMP.B   #$0,D3            ; 0 - word
    BEQ     Print_MOVEM_WORD

    CMP.B   #$1,D3            ; 1 - long 
    BEQ     Print_MOVEM_LONG
    
    JSR     EA_MOVEM          ; Jump to EA Decoding
    RTS
    
Print_MOVEM_WORD
    MOVE.B  #$0,IMMEDIATE_SIZE_FLAG
    JSR     Print_WORD_SIZE   ; Print .W on the screen, using the label
    BRA     MOVEM_REST_CODE
Print_MOVEM_LONG
    MOVE.B  #$1,IMMEDIATE_SIZE_FLAG
    JSR     Print_LONG_SIZE   ; Print .L on the screen, using the label
    BRA     MOVEM_REST_CODE
    
MOVEM_REST_CODE
    JSR     EA_MOVEM          ; Jump To EA Decoding
    RTS

BRA_OUTPUT 
    CLR     D4
    MOVE.L  D0,D4

    LEA     PRINT_BRA,A1      ; Print BRA Label
    MOVE.B  #14,D0
    TRAP    #15
    
    JSR     EA_BRANCHES       ; Jump to EA Decoding
    RTS
    
BGT_OUTPUT
    CLR     D4
    MOVE.L  D0,D4

    LEA     PRINT_BGT,A1      ; Print BGT label
    MOVE.B  #14,D0
    TRAP    #15
    
    JSR     EA_BRANCHES       ; Jump to EA Decoding
    RTS
    
BLE_OUTPUT 
    CLR     D4
    MOVE.L  D0,D4

    LEA     PRINT_BLE,A1      ; Print BLE Label
    MOVE.B  #14,D0
    TRAP    #15
    
    JSR     EA_BRANCHES       ; Jump to EA Decoding
    RTS
    
BEQ_OUTPUT 
    CLR     D4
    MOVE.L  D0,D4

    LEA     PRINT_BEQ,A1      ; Print BEQ Label
    MOVE.B  #14,D0
    TRAP    #15
    
    JSR     EA_BRANCHES       ; Jump to EA Decoding
    RTS
    
BCC_OUTPUT 
    CLR     D4
    MOVE.L  D0,D4

    LEA     PRINT_BCC,A1      ; Print BCC Label
    MOVE.B  #14,D0
    TRAP    #15
    
    JSR     EA_BRANCHES       ; Jump to EA Decoding
    RTS
    
DIVUW_OUTPUT
    CLR     D4
    MOVE.L  D0,D4

    LEA     PRINT_DIVUW,A1    ; Print DIVUW Label
    MOVE.B  #14,D0
    TRAP    #15   
    
    JSR     EA_DIVUW          ; Jump to EA Decoding
    RTS


MULSW_OUTPUT
    CLR     D4
    MOVE.L  D0,D4

    LEA     PRINT_MULSW,A1    ; Print MULSW Label
    MOVE.B  #14,D0
    TRAP    #15   
    
    JSR     EA_MULSW          ; Jump to EA Decoding
    RTS


AND_OUTPUT
    CLR     D4
    MOVE.L  D0,D4             ; Move original value to D4, since D0 will change below

    LEA     PRINT_AND,A1      ; Print AND Label
    MOVE.B  #14,D0
    TRAP    #15
    
    CLR     D3
    MOVE.L  D4,D3             ; Move original value also at D3, since we want to modify original value, so need multiple copies
    
    LSL.W   #8,D3             ; Shift to get the 9th and 10th bit (xxxx xxxx yyxx xxxx) 
    LSR.W   #8,D3             
    LSR.W   #6,D3             ; Shift to isolate the 2 bits(xxxx xxxx xxxx xxyy)
    
    CMP.B   #$0,D3            ; 00 - byte
    BEQ     Print_AND_BYTE
    
    CMP.B   #$1,D3            ; 01 - word
    BEQ     Print_AND_WORD

    CMP.B   #$2,D3            ; 10 - long
    BEQ     Print_AND_LONG

    JSR     EA_AND            ; Jump to EA Decoding
    RTS
    
    
Print_AND_BYTE 
    MOVE.B  #$0,IMMEDIATE_SIZE_FLAG
    JSR     Print_BYTE_SIZE   ; Print .B on the screen, using the label
    BRA     AND_REST_CODE
    
Print_AND_WORD
    MOVE.B  #$0,IMMEDIATE_SIZE_FLAG
    JSR     Print_WORD_SIZE   ; Print .W on the screen, using the label
    BRA     AND_REST_CODE

Print_AND_LONG
    MOVE.B  #$1,IMMEDIATE_SIZE_FLAG
    JSR     Print_LONG_SIZE   ; Print .L on the screen, using the label
    BRA     AND_REST_CODE
    
AND_REST_CODE
    JSR     EA_AND            ; Jump to EA Decoding
    RTS
    
ADD_OUTPUT
    CLR     D4
    MOVE.L  D0,D4             ; Move original value to D4, since D0 will change below

    LEA     PRINT_ADD,A1      ; Print ADD Label
    MOVE.B  #14,D0
    TRAP    #15
    
    CLR     D3
    MOVE.L  D4,D3             
    
    LSL.W   #8,D3             ; Shift to get the 9th and 10th bit (xxxx xxxx yyxx xxxx) 
    LSR.W   #8,D3             
    LSR.W   #6,D3             ; Shift to isolate the 2 bits(xxxx xxxx xxxx xxyy)
    
    CMP.B   #$0,D3            ; 00 - byte
    BEQ     Print_ADD_BYTE
    
    CMP.B   #$1,D3            ; 01 - word
    BEQ     Print_ADD_WORD

    CMP.B   #$2,D3            ; 10 - long
    BEQ     Print_ADD_LONG

    JSR     EA_ADD_SUB        ; Jump to EA Decoding
    RTS
    
Print_ADD_BYTE 
    MOVE.B  #$0,IMMEDIATE_SIZE_FLAG
    JSR     Print_BYTE_SIZE   ; Print .B on the screen, using the label
    BRA     ADD_REST_CODE
    
Print_ADD_WORD
    MOVE.B  #$0,IMMEDIATE_SIZE_FLAG
    JSR     Print_WORD_SIZE   ; Print .W on the screen, using the label
    BRA     ADD_REST_CODE

Print_ADD_LONG
    MOVE.B  #$1,IMMEDIATE_SIZE_FLAG
    JSR     Print_LONG_SIZE   ; Print .L on the screen, using the label
    BRA     ADD_REST_CODE
    
ADD_REST_CODE
    JSR     EA_ADD_SUB        ; Jump to EA Decoding
    RTS
    
SUB_OUTPUT
    CLR     D4
    MOVE.L  D0,D4             ; Move original value to D4, since D0 will change below

    LEA     PRINT_SUB,A1      ; Print SUB Label
    MOVE.B  #14,D0
    TRAP    #15
    
    CLR     D3
    MOVE.L  D4,D3             ; Move original value also at D3, since we want to modify original value, so need multiple copies
    
    LSL.W   #8,D3             ; Shift to get the 9th and 10th bit (xx xxxx yyxx xxxx) 
    LSR.W   #8,D3             
    LSR.W   #6,D3             ; Shift to isolate the 2 bits (xxxx xxxx xxxx xxyy)
    
    CMP.B   #$0,D3            ; 00 - byte
    BEQ     Print_SUB_BYTE
    
    CMP.B   #$1,D3            ; 01 - word
    BEQ     Print_SUB_WORD

    CMP.B   #$2,D3            ; 10 - long
    BEQ     Print_SUB_LONG

    JSR     EA_ADD_SUB        ; Jump to EA Decoding
    RTS
   
Print_SUB_BYTE 
    MOVE.B  #$0,IMMEDIATE_SIZE_FLAG
    JSR     Print_BYTE_SIZE   ; Print .B on the screen, using the label
    BRA     SUB_REST_CODE
    
Print_SUB_WORD
    MOVE.B  #$0,IMMEDIATE_SIZE_FLAG
    JSR     Print_WORD_SIZE   ; Print .W on the screen, using the label
    BRA     SUB_REST_CODE

Print_SUB_LONG
    MOVE.B  #$1,IMMEDIATE_SIZE_FLAG
    JSR     Print_LONG_SIZE   ; Print .L on the screen, using the label
    BRA     SUB_REST_CODE
    
SUB_REST_CODE
    JSR     EA_ADD_SUB        ; Jump to EA Decoding
    RTS


LSL_MEMORY_SHIFT_OUTPUT     
    CLR     D4
    MOVE.L  D0,D4             ; Move original value to D4, since D0 will change below

    LEA     PRINT_LSL,A1      ; Print LSL Label
    MOVE.B  #14,D0
    TRAP    #15
    
    LEA     PRINT_WORD,A1     ; Print .W
    MOVE.B  #14,D0
    TRAP    #15    
    
    JSR     EA_LSL_ASL_MEMORY ; Jump to EA Decoding
    RTS
    
ASL_MEMORY_SHIFT_OUTPUT 
    CLR     D4
    MOVE.L  D0,D4             ; Move original value to D4, since D0 will change below

    LEA     PRINT_ASL,A1      ; Print ASL Label
    MOVE.B  #14,D0
    TRAP    #15
    
    LEA     PRINT_WORD,A1     ; Print .W
    MOVE.B  #14,D0
    TRAP    #15   
    
    JSR     EA_LSL_ASL_MEMORY ; Jump to EA Decoding
    RTS
    

LSL_LOGIC_SHIFT_OUTPUT 
    CLR     D4
    MOVE.L  D0,D4             ; Move original value to D4, since D0 will change below

    LEA     PRINT_LSL,A1      ; Print LSL Label
    MOVE.B  #14,D0
    TRAP    #15
    
    CLR     D3
    MOVE.L  D4,D3             ; Move original value also at D3, since we want to modify original value, so need multiple copies
    
    LSL.W   #8,D3             ; Shift to get the 9th and 10th bit (xxxx xxxx yyxx xxxx) 
    LSR.W   #7,D3             
    LSR.W   #7,D3             ; Shift to isolate the 2 bits(xxxx xxxx xxxx xxyy)
    
    CMP.B   #$0,D3            ; 00 - byte
    BEQ     Print_LSL_ASL_LOGIC_BYTE
    
    CMP.B   #$1,D3            ; 01 - word
    BEQ     Print_LSL_ASL_LOGIC_WORD

    CMP.B   #$2,D3            ; 10 - long
    BEQ     Print_LSL_ASL_LOGIC_LONG

    JSR     EA_LSL_ASL_LOGIC  ; Jump to EA Decoding
    RTS
    
ASL_LOGIC_SHIFT_OUTPUT 
    CLR     D4
    MOVE.L  D0,D4             ; Move original value to D4, since D0 will change below

    LEA     PRINT_ASL,A1      ; Print ASL Label
    MOVE.B  #14,D0
    TRAP    #15
     
    CLR     D3
    MOVE.L  D4,D3             ; Move original value also at D3, since we want to modify original value, so need multiple copies
    
    LSL.W   #8,D3             ; Shift to get the 9th and 10th bit (xxxx xxxx yyxx xxxx) 
    LSR.W   #7,D3             
    LSR.W   #7,D3             ; Shift to isolate the 2 bits (xxxx xxxx xxxx xxyy)
    
    CMP.B   #$0,D3            ; 00 - byte
    BEQ     Print_LSL_ASL_LOGIC_BYTE
    
    CMP.B   #$1,D3            ; 01 - word
    BEQ     Print_LSL_ASL_LOGIC_WORD

    CMP.B   #$2,D3            ; 10 - long
    BEQ     Print_LSL_ASL_LOGIC_LONG

    JSR     EA_LSL_ASL_LOGIC  ; Jump to EA Decoding
    RTS
    
Print_LSL_ASL_LOGIC_BYTE
    MOVE.B  #$0,IMMEDIATE_SIZE_FLAG
    JSR     Print_BYTE_SIZE   ; Print .B on the screen, using the label
    BRA     LSL_ASL_LOGIC_REST_CODE

Print_LSL_ASL_LOGIC_WORD
    MOVE.B  #$0,IMMEDIATE_SIZE_FLAG
    JSR     Print_WORD_SIZE   ; Print .W on the screen, using the label
    BRA     LSL_ASL_LOGIC_REST_CODE

Print_LSL_ASL_LOGIC_LONG
    MOVE.B  #$1,IMMEDIATE_SIZE_FLAG
    JSR     Print_LONG_SIZE   ; Print .L on the screen, using the label
    BRA     LSL_ASL_LOGIC_REST_CODE

LSL_ASL_LOGIC_REST_CODE
    JSR     EA_LSL_ASL_LOGIC  ; Jump to EA Decoding
    RTS
    
*********EA Section************* 
EA_MOVE
    MOVE.L  #$00000000,INVALID_DATA_VALUE
    * D4 has the instruction format
    
    CLR     D2          ; Mode
    CLR     D6          ; Register
    CLR     D3
    
    MOVE.W  D4,D2
    LSL.W   #5,D2
    LSL.W   #5,D2
    LSR.W   #8,D2
    LSR.W   #5,D2       ; Shift to get Source Mode (xxxx xxxx xxyy yxxx)
    
    ADD.L   D4,INVALID_DATA_VALUE

    MOVE.W  D4,D6
    LSL.W   #8,D6       
    LSL.W   #5,D6       ; Shift to get last 3 bits for Source Register (xxxx xxxx xxxx xyyy)
    LSR.W   #8,D6       
    LSR.W   #5,D6       
       
    CMP.B   #$0,D6      ; Make sure the register is in range
    BLT     INVALID_EA
    
    CMP.B   #$7,D6      ; Check if its not out of bounds
    BGT     INVALID_EA

    JSR     EA_Check_Mode ; Jump to Print EA Mode
    
    LEA     PRINT_COMMA,A1    
    MOVE.B  #14,D0
    TRAP    #15
    
    CLR     D2
    CLR     D6
    
    MOVE.W  D4,D2
    LSL.W   #7,D2
    LSR.W   #8,D2
    LSR.W   #5,D2       ; Shift to get Destination Mode (xxxx xxxy yyxx xxxx)
    
    CMP.B   An_MODE_VAL,D2  ; Compare to An to check invalid Mode
    BEQ     INVALID_EA 
    
    MOVE.W  D4,D6
    LSL.W   #4,D6       
    LSR.W   #8,D6       
    LSR.W   #5,D6       ; Shift to get the Destination Register bits (xxxx yyyx xxxx xxxx)
    
    CMP.B   #$0,D6      ; Make sure the register is in range
    BLT     INVALID_EA
    
    CMP.B   #$7,D6      ; Check if its not out of bounds
    BGT     INVALID_EA
    

    CMP.B   IMMDATA_MODE_VAL, D2    ; Check if Invalid EA
    BEQ     IMMEDIATE_CHECK_MOVE
    
    JSR     EA_Check_Mode   ; Jump to Print EA Mode
        
    RTS
    
IMMEDIATE_CHECK_MOVE
    CMP.B   IMMDATA_REGISTER_VAL,D6 ; Compare to IMMDATA for Invalid EA
    BEQ     INVALID_EA
    
    BRA     EA_Check_Mode   ; Jump to Print EA Mode

EA_JSR
    MOVE.L  #$00000000,INVALID_DATA_VALUE
    * D4 has the instruction format
    
    CLR     D2          ; Source Mode      
    CLR     D6          ; Source Register
    CLR     D3   
    
    MOVE.W  D4,D2
    LSL.W   #5,D2       
    LSL.W   #5,D2       ; Shift to get last 6 bits (xxxx xxxx xxyy yyyy) 
    LSR.W   #8,D2       
    LSR.W   #5,D2       ; Shift to get the Mode bits (xxxx xxxx xxyy yxxx)
    
    ADD.L   D4,INVALID_DATA_VALUE   ; Add value to invalid for printing purposes
    
    * Compare Invalid EAs for JSR
    CMP.B   Dn_MODE_VAL,D2 
    *Loading D2 as error data value into INVALID_DATA_VALUE
    BEQ     INVALID_EA
    
    CMP.B   An_MODE_VAL,D2
    BEQ     INVALID_EA   
    
    CMP.B   POSTINCR_An_MODE_VAL,D2
    BEQ     INVALID_EA
    
    CMP.B   PREDECR_An_MODE_VAL,D2
    BEQ     INVALID_EA
    
    
    MOVE.W  D4,D6
    LSL.W   #8,D6       
    LSL.W   #5,D6       ; Shift to get last 6 bits(xxxx xxxx xxyy yyyy)
    LSR.W   #8,D6       
    LSR.W   #5,D6       ; Shift to get register bits(xxxx xxxx xxxx xyyy)
    
       
    CMP.B   #$0,D6      ; Make sure the register is in range
    BLT     INVALID_EA
    
    CMP.B   #$7,D6      ; Check if its not out of bounds
    BGT     INVALID_EA

    CMP.B   IMMDATA_MODE_VAL, D2    ; Check for Immediate data 
    BEQ     IMMEDIATE_CHECK_JSR   
    
    JSR     EA_Check_Mode  ; Jump to print EA mode
    
    CLR     INVALID_DATA_VALUE
    
    RTS

IMMEDIATE_CHECK_JSR
    CMP.B   IMMDATA_REGISTER_VAL,D6 ; Check for invalid imm data EA
    BEQ     UNSIZED_INVALID_EA
    
    BRA     EA_Check_Mode  ; Jump to print EA mode if valid


EA_NOT
    MOVE.L  #$00000000,INVALID_DATA_VALUE
    * D4 has the instruction format
    
    CLR     D2          ; Source Mode
    CLR     D6          ; Source Register
    CLR     D3          
    
    MOVE.W  D4,D2
    LSL.W   #5,D2       
    LSL.W   #5,D2       ; Shift to get last 6 bits (xxxx xxxx xxyy yyyy)
    LSR.W   #8,D2       
    LSR.W   #5,D2       ; Shift to get Mode bits (xxxx xxxx xxyy yxxx)
    
    ADD.L   D4,INVALID_DATA_VALUE
    
    CMP.B   An_MODE_VAL,D2  ; Make sure its not invalid Mode
    BEQ     INVALID_EA   
    
    MOVE.W  D4,D6
    LSL.W   #8,D6       
    LSL.W   #5,D6       ; Shift to get last 6 bits (xxxx xxxx xxyy yyyy)
    LSR.W   #8,D6       
    LSR.W   #5,D6       ; Shift to get Register bits (xxxx xxxx xxxx xyyy)
       
    CMP.B   #$0,D6      ; Make sure the register is in range
    BLT     INVALID_EA
    
    CMP.B   #$7,D6      ; Check if its not out of bounds
    BGT     INVALID_EA
    
    CMP.B   IMMDATA_MODE_VAL, D2 ; Check if its immediate data
    BEQ     IMMEDIATE_CHECK_NOT
    
    JSR     EA_Check_Mode ; Jump to print EA mode
    
    CLR     INVALID_DATA_VALUE
    
    RTS

IMMEDIATE_CHECK_NOT
    CMP.B   IMMDATA_REGISTER_VAL,D6 ; Check for Invalid Immdata
    BEQ     INVALID_EA
    
    BRA     EA_Check_Mode ; Jump to print EA mode if valid
    
EA_LEA
    MOVE.L  #$00000000,INVALID_DATA_VALUE
    * D4 has the instruction format
    
    CLR     D2          ; Source Mode
    CLR     D6          ; Source Register
    CLR     D3          
    
    MOVE.W  D4,D2
    LSL.W   #5,D2       
    LSL.W   #5,D2       ; Shift to get last 6 bits (xxxx xxxx xxyy yyyy)
    LSR.W   #8,D2       
    LSR.W   #5,D2       ; Shift to get Mode bits (xxxx xxxx xxyy yxxx)
    
    ADD.L   D4,INVALID_DATA_VALUE ; Load data to invalid for printing purposes
    
    * Check for invalid Modes
    CMP.B   Dn_MODE_VAL,D2 
    BEQ     INVALID_EA
    
    CMP.B   An_MODE_VAL,D2
    BEQ     INVALID_EA   
    
    CMP.B   POSTINCR_An_MODE_VAL,D2
    BEQ     INVALID_EA
    
    CMP.B   PREDECR_An_MODE_VAL,D2
    BEQ     INVALID_EA
    
    MOVE.W  D4,D6
    LSL.W   #8,D6       
    LSL.W   #5,D6       ; Shift to get last 6 bits (xxxx xxxx xxyy yyyy)
    LSR.W   #8,D6       
    LSR.W   #5,D6       ; Shift to get Register bits (xxxx xxxx xxxx xyyy)
          
    CMP.B   #$0,D6      ; Make sure the register is in range
    BLT     INVALID_EA
    
    CMP.B   #$7,D6      ; Check if its not out of bounds
    BGT     INVALID_EA

    CMP.B   IMMDATA_MODE_VAL, D2 ; Check for Immediate data
    BEQ     IMMEDIATE_CHECK_LEA

    
LEA_NEXT_PART
    JSR     EA_Check_Mode  ; Jump to print EA mode
    
    CLR     INVALID_DATA_VALUE

    LEA     PRINT_COMMA,A1    ; Print a comma
    MOVE.B  #14,D0
    TRAP    #15
    
    CLR     D6

    MOVE.W  D4,D6
    LSL.W   #4,D6       
    LSR.W   #8,D6       
    LSR.W   #5,D6       ; Shift to get Address Register bits (xxxx yyyx xxxx xxxx)

    JSR    Print_An_Mode   ; Jump to print An mode
    
    RTS
    
IMMEDIATE_CHECK_LEA
    CMP.B   IMMDATA_REGISTER_VAL,D6 ; Check for invalid ImmData
    BEQ     INVALID_EA
    
    BRA     LEA_NEXT_PART  


EA_MOVEM
    MOVE.L  #$00000000,INVALID_DATA_VALUE
    * D4 has the instruction format
    
    CLR     D2          ; Source Mode
    CLR     D6          ; Source Register
    CLR     D3
    
    MOVE.W  D4,D3
    LSL.W   #5,D3
    LSR.W   #8,D3       
    LSR.W   #7,D3       ; Shift to get Direction bit (xxxx xyxx xxxx xxxx) 
    
    ADD.L   D4,INVALID_DATA_VALUE ; Load instruction to invalid value for printing purposes
    
    CMP.B   #$0,D3
    BEQ     MOVEM_REGISTER_TO_MEMORY    ; register to memory if the direction is 0
    
    CMP.B   #$1,D3
    BEQ     MOVEM_MEMORY_TO_REGISTER    ; memory to register if the direction is 1
    
    RTS


MOVEM_REGISTER_TO_MEMORY    
    CLR     D2          ; Source Mode
    CLR     D6          ; Source Register
    CLR     D3          
    
    MOVE.W  D4,D2
    LSL.W   #5,D2       
    LSL.W   #5,D2       ; Shift to get last 6 bits (xxxx xxxx xxyy yyyy)
    LSR.W   #8,D2       
    LSR.W   #5,D2       ; Shift to get Mode bits (xxxx xxxx xxyy yxxx)
    
    *Check for invalid Modes
    CMP.B   Dn_MODE_VAL,D2
    BEQ     INVALID_EA
    
    CMP.B   An_MODE_VAL,D2
    BEQ     INVALID_EA   
    
    CMP.B   POSTINCR_An_MODE_VAL,D2
    BEQ     INVALID_EA
    
    
    MOVE.W  D4,D6
    LSL.W   #8,D6       
    LSL.W   #5,D6       ; Shift to get last 6 bits (xxxx xxxx xxyy yyyy)
    LSR.W   #8,D6       
    LSR.W   #5,D6       ; Shift to get Register bits (xxxx xxxx xxxx xyyy)
          
    CMP.B   #$0,D6      ; Make sure the register is in range
    BLT     INVALID_EA
    
    CMP.B   #$7,D6      ; Check if its not out of bounds
    BGT     INVALID_EA
    
    CLR     D7
    MOVE.B  D6,D7
    
    CMP.B   PREDECR_An_MODE_VAL,D2  ; Check for predecrement mode since it has separate printing mechanism
    BEQ     MOVEM_PreDecr_List

    
    CMP.B   IMMDATA_MODE_VAL, D2 ; Check for Immdata Mode
    BEQ     IMMEDIATE_CHECK_MOVEM
    
    CLR     D3
    MOVE.W  (A4)+,D3    ; Read an extra word    

    JSR     Print_MOVEM_AllModes_List ; Jump to print all MOVEM modes List
    
    MOVE.W  A4,D5       ; Reset D5 to store the next address
    MOVE.B  #$00, IMMEDIATE_SIZE_FLAG
    
    RTS
    
Print_MOVEM_AllModes_List
    ROR.W   #1,D3      ; Rotate the last bit out to see if it is a 1 or 0 in binary
    BCS     Print_AllModes_Dn_List  ; If it is a 1, branch to a label to print the respective format
    ADD.B   #1,REGISTER_COUNTER ; Increment the register counter
    ADD.B   #1,MOVEM_COUNTER    ; Increment the loop counter
    CMP.B   #8,MOVEM_COUNTER
    BEQ     CLEAR_ALLMODES_MOVEM_COUNTER    ; Branch to next label once we checked all 8 bits
    BRA     Print_MOVEM_AllModes_List   ; If it is a 0, return back to the loop
    
    RTS    
    
Print_AllModes_Dn_List              
    CMP.B   #0,REGISTER_COUNTER     ; Check for case when there is Register is 0 and the carry bit is 1
    BEQ     Print_AllModes_REGISTER_ZERO

    MOVE.B  REGISTER_COUNTER,D6     ; Move the register number to D6 for printing
    JSR     Print_Dn_Mode           ; Print the Dn mode
                       
    ADD.B   #1,REGISTER_COUNTER     ; Increment the register counter
    ADD.B   #1,MOVEM_COUNTER        ; Increment the loop counter

    LEA     PRINT_SLASH,A1          ; Print a slash
    MOVE.B  #14,D0
    TRAP    #15

    CMP.B   #8,MOVEM_COUNTER        ; Branch to next label once we checked all 8 bits
    BEQ     CLEAR_ALLMODES_MOVEM_COUNTER
    
    BRA     Print_MOVEM_AllModes_List   ; Branch back to the loop if we haven't checked all the bits yet
    RTS
                       
Print_AllModes_REGISTER_ZERO        ; Special printing case for when the register is 0
    MOVE.B  REGISTER_COUNTER,D6    
    JSR     Print_Dn_Mode
    
    ADD.B   #1,REGISTER_COUNTER
    ADD.B   #1,MOVEM_COUNTER
    
    LEA     PRINT_SLASH,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    BRA     Print_MOVEM_AllModes_List   ; Branch back to the loop
    
CLEAR_ALLMODES_MOVEM_COUNTER
    MOVE.B  #$00, MOVEM_COUNTER         ; Clear loop counter
    MOVE.B  #$00, REGISTER_COUNTER      ; Clear register counter
    BRA     Print_AllModes_An_List_Loop ; Branch to next label to print An modes
    
Print_AllModes_An_List_Loop
    ROR.W   #1,D3                       ; Rotate the last bit out to see if it is a 1 or 0 in binary 
    BCS     Print_AllModes_An_List      ; If it is a 1, branch to a label to print the respective format
    ADD.B   #1,REGISTER_COUNTER         ; Increment the register counter
    ADD.B   #1,MOVEM_COUNTER            ; Increment the loop counter
    CMP.B   #8,MOVEM_COUNTER
    BEQ     CLEAR_MOVEM_AllModes_An_COUNTER ; Branch to next label once we checked all 8 bits
    BRA     Print_AllModes_An_List_Loop     ; If it is a 0, return back to the loop

    RTS
    
Print_AllModes_An_List
    CMP.B   #0,REGISTER_COUNTER                 ; Check for case when there is Register is 0 and the carry bit is 1
    BEQ     Print_AllModes_REGISTER_ZERO_An     
    
    MOVE.B  REGISTER_COUNTER,D6                 ; Move the register number to D6 for printing                      
    JSR     Print_An_Mode                       ; Print the An mode
    
    ADD.B   #1,REGISTER_COUNTER                 ; Increment the register counter
    ADD.B   #1,MOVEM_COUNTER                    ; Increment the loop counter
    
    CMP.B   #8,MOVEM_COUNTER                    ; Branch to next label once we checked all 8 bits
    BEQ     CLEAR_MOVEM_AllModes_An_COUNTER

    
    LEA     PRINT_SLASH,A1                      ; Print a slash
    MOVE.B  #14,D0
    TRAP    #15
    
    BRA     Print_AllModes_An_List_Loop         ; Branch back into the loop
                        
Print_AllModes_REGISTER_ZERO_An                 ; Special printing case for when the register is 0

    MOVE.B  REGISTER_COUNTER,D6
    JSR     Print_An_Mode
    
    ADD.B   #1,REGISTER_COUNTER
    ADD.B   #1,MOVEM_COUNTER
    
    LEA     PRINT_SLASH,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    BRA     Print_AllModes_An_List_Loop         ; Branch back to the loop
                        
CLEAR_MOVEM_AllModes_An_COUNTER
    MOVE.B  #$00, MOVEM_COUNTER                 ; Clear loop counter
    MOVE.B  #$00, REGISTER_COUNTER              ; Clear register counter
    BRA     AllModes_Rest_Code                  ; Branch to next label to print the respective mode and register
    
AllModes_Rest_Code
    LEA     PRINT_COMMA,A1                      ; Print a comma
    MOVE.B  #14,D0
    TRAP    #15
    
    MOVE.B  D7,D6       ; D7 has the original register value, since D6 got changed during the list printing
    
    JSR     EA_Check_Mode                       ; Print the correct mode and register
    
    RTS

    
MOVEM_MEMORY_TO_REGISTER 
    CLR     D2          ; Source Mode
    CLR     D6          ; Source Register
    CLR     D3          
    
    MOVE.W  D4,D2
    LSL.W   #5,D2       
    LSL.W   #5,D2       ; Shift to get last 6 bits (xxxx xxxx xxyy yyyy)
    LSR.W   #8,D2       
    LSR.W   #5,D2       ; Shift to get Mode bits (xxxx xxxx xxyy yxxx)
    
    *Check for invalid Modes    
    CMP.B   Dn_MODE_VAL,D2
    BEQ     INVALID_EA
    
    CMP.B   An_MODE_VAL,D2
    BEQ     INVALID_EA   
    
    CMP.B   PREDECR_An_MODE_VAL,D2
    BEQ     INVALID_EA
    
    MOVE.W  D4,D6
    LSL.W   #8,D6       
    LSL.W   #5,D6       ; Shift to get last 6 bits (xxxx xxxx xxyy yyyy)
    LSR.W   #8,D6       
    LSR.W   #5,D6       ; Shift to get Register bits (xxxx xxxx xxxx xyyy)
          
    CMP.B   #$0,D6      ; Make sure the register is in range
    BLT     INVALID_EA
    
    CMP.B   #$7,D6      ; Check if its not out of bounds
    BGT     INVALID_EA
    
    CLR     D7
    MOVE.B  D6,D7
    
    CMP.B   IMMDATA_MODE_VAL, D2    ; Check for Imm data Mode
    BEQ     IMMEDIATE_CHECK_MOVEM_MEM_TO_REG
    
    BRA     MOVEM_MEM_TO_REG_NEXT_PART 
    
MOVEM_MEM_TO_REG_NEXT_PART
    JSR     EA_Check_Mode  ; Print EA Mode and register
    
    CLR     INVALID_DATA_VALUE

    LEA     PRINT_COMMA,A1  ; Print a comma    
    MOVE.B  #14,D0
    TRAP    #15
    
    CLR     D6
    CLR     D3
    
    MOVE.W  (A4)+,D3   ; Read an extra word    

    JSR     MOVEM_AllModes_List_MEM_TO_REG ; Jump to get list of Modes
    
    MOVE.W  A4,D5      ; Reset D5 to store the next address
    MOVE.B  #$00, IMMEDIATE_SIZE_FLAG

    RTS
    
IMMEDIATE_CHECK_MOVEM_MEM_TO_REG
    CMP.B   IMMDATA_REGISTER_VAL,D6 ; Check for invalid Imm Data
    BEQ     INVALID_EA
    
    BRA     MOVEM_MEM_TO_REG_NEXT_PART  ; Branch to the next part 
    
MOVEM_AllModes_List_MEM_TO_REG
    ROR.W   #1,D3                           ; Rotate the last bit out to see if it is a 1 or 0 in binary 
    BCS     AllModes_Dn_List_MEM_TO_REG     ; If it is a 1, branch to a label to print the respective format
    ADD.B   #1,REGISTER_COUNTER             ; Increment the register counter
    ADD.B   #1,MOVEM_COUNTER                ; Increment the loop counter
    CMP.B   #8,MOVEM_COUNTER
    BEQ     CLEAR_MOVEM_COUNTER_MEM_REG     ; Branch to next label once we checked all 8 bits
    BRA     MOVEM_AllModes_List_MEM_TO_REG  ; If it is a 0, return back to the loop
    
    RTS
    
AllModes_Dn_List_MEM_TO_REG
    CMP.B   #0,REGISTER_COUNTER             ; Check for case when there is Register is 0 and the carry bit is 1
    BEQ     AllModes_REGISTER_ZERO_MEM_REG

    MOVE.B  REGISTER_COUNTER,D6             ; Move the register number to D6 for printing
    JSR     Print_Dn_Mode                   ; Print the Dn mode

    ADD.B   #1,REGISTER_COUNTER             ; Increment the register counter
    ADD.B   #1,MOVEM_COUNTER                ; Increment the loop counter

    LEA     PRINT_SLASH,A1                  ; Print a slash
    MOVE.B  #14,D0
    TRAP    #15        
 
    CMP.B   #8,MOVEM_COUNTER                ; Branch to next label once we checked all 8 bits
    BEQ     CLEAR_MOVEM_COUNTER_MEM_REG
    
    BRA     MOVEM_AllModes_List_MEM_TO_REG  ; Branch back into the loop
    RTS
    
CLEAR_MOVEM_COUNTER_MEM_REG     
    MOVE.B  #$00, MOVEM_COUNTER             ; Clear loop counter
    MOVE.B  #$00, REGISTER_COUNTER          ; Clear register counter
    BRA     Print_An_List_MEM_REG_Loop      ; Branch to the next label to print the An List  
    
Print_An_List_MEM_REG_Loop
    ROR.W   #1,D3                           ; Rotate the last bit out to see if it is a 1 or 0 in binary         
    BCS     Print_An_List_MEM_REG           ; If it is a 1, branch to a label to print the respective format
    ADD.B   #1,REGISTER_COUNTER             ; Increment the register counter
    ADD.B   #1,MOVEM_COUNTER                ; Increment the loop counter
    CMP.B   #8,MOVEM_COUNTER
    BEQ     CLEAR_MOVEM_An_COUNTER_MEM_REG  ; Branch to next label once we checked all 8 bits
    BRA     Print_An_List_MEM_REG_Loop      ; If it is a 0, return back to the loop

    RTS                
    
Print_An_List_MEM_REG
    CMP.B   #0,REGISTER_COUNTER
    BEQ     Print_REGISTER_ZERO_An_MEM_REG  ; Check for case when there is Register is 0 and the carry bit is 1

    MOVE.B  REGISTER_COUNTER,D6             ; Move the register number to D6 for printing 
    JSR     Print_An_Mode                   ; Print the An mode
    
    ADD.B   #1,REGISTER_COUNTER             ; Increment the register counter
    ADD.B   #1,MOVEM_COUNTER                ; Increment the loop counter
    
    CMP.B   #8,MOVEM_COUNTER                ; Branch to next label once we checked all 8 bits
    BEQ     CLEAR_MOVEM_An_COUNTER_MEM_REG

                       
    LEA     PRINT_SLASH,A1                  ; Print a slash
    MOVE.B  #14,D0
    TRAP    #15
    
    BRA     Print_An_List_MEM_REG_Loop      ; Branch back into the loop
    
Print_REGISTER_ZERO_An_MEM_REG
    MOVE.B  REGISTER_COUNTER,D6             ; Move the register number to D6 for printing
    JSR     Print_An_Mode                   ; Print the An mode
                       
    ADD.B   #1,REGISTER_COUNTER             ; Increment the register counter
    ADD.B   #1,MOVEM_COUNTER                ; Increment the loop counter
    
    LEA     PRINT_SLASH,A1                  ; Print a slash
    MOVE.B  #14,D0
    TRAP    #15
    
    BRA     Print_An_List_MEM_REG_Loop      ; Branch back into the loop
    
CLEAR_MOVEM_An_COUNTER_MEM_REG
    MOVE.B  #$00, MOVEM_COUNTER             ; Clear loop counter
    MOVE.B  #$00, REGISTER_COUNTER          ; Clear register counter
    RTS
                       
AllModes_REGISTER_ZERO_MEM_REG
    MOVE.B  REGISTER_COUNTER,D6             ; Move the register number to D6 for printing 
    JSR     Print_Dn_Mode                   ; Print the Dn mode
    
    ADD.B   #1,REGISTER_COUNTER             ; Increment the register counter
    ADD.B   #1,MOVEM_COUNTER                ; Increment the loop counter
    
    LEA     PRINT_SLASH,A1                  ; Print a slash
    MOVE.B  #14,D0
    TRAP    #15
    
    BRA     MOVEM_AllModes_List_MEM_TO_REG  ; Branch back into the loop
    
IMMEDIATE_CHECK_MOVEM
    CMP.B   IMMDATA_REGISTER_VAL,D6         ; Check for imm data mode
    BEQ     INVALID_EA
    
    CLR     D7                              ; Have an extra copy of the register number, since D6 will be changed 
    MOVE.B  D6,D7
    
    CLR     D3
    MOVE.W  (A4)+,D3   ; Read an extra word    

    JSR     Print_MOVEM_AllModes_List
  
    MOVE.W  A4,D5      ; Reset D5 to store the next address
    MOVE.B  #$00, IMMEDIATE_SIZE_FLAG
    
    RTS

    
MOVEM_PreDecr_List
    CLR     D3
    MOVE.W  (A4)+,D3    ; Read an extra word  
     
*    MOVE.B  #$00, MOVEM_COUNTER
*    MOVE.B  #$00, REGISTER_COUNTER
    JSR     Print_MOVEM_PreDecr_List 
     
    MOVE.W  A4,D5       ; Reset D5 to store the next address
    MOVE.B  #$00, IMMEDIATE_SIZE_FLAG
    RTS
    
Print_MOVEM_PreDecr_List
    ROL.W   #1,D3                   ; Rotate the first bit out to see if it is a 1 or 0 in binary  
    BCS     Print_PreDecr_Dn_List   ; If it is a 1, branch to a label to print the respective format
    ADD.B   #1,REGISTER_COUNTER     ; Increment the register counter
    ADD.B   #1,MOVEM_COUNTER        ; Increment the loop counter
    CMP.B   #8,MOVEM_COUNTER
    BEQ     CLEAR_MOVEM_COUNTERS    ; Branch to next label once we checked all 8 bits
    BRA     Print_MOVEM_PreDecr_List    ; If it is a 0, return back to the loop
    RTS 
    
Print_PreDecr_Dn_List
    CMP.B   #0,REGISTER_COUNTER     ; Check for case when there is Register is 0 and the carry bit is 1
    BEQ     Print_WHEN_REGISTER_ZERO

    MOVE.B  REGISTER_COUNTER,D6     ; Move the register number to D6 for printing 
    JSR     Print_Dn_Mode           ; Print the Dn mode

    ADD.B   #1,REGISTER_COUNTER     ; Increment the register counter
    ADD.B   #1,MOVEM_COUNTER        ; Increment the loop counter

    LEA     PRINT_SLASH,A1          ; Print a slash
    MOVE.B  #14,D0
    TRAP    #15
                       
    CMP.B   #8,MOVEM_COUNTER
    BEQ     CLEAR_MOVEM_COUNTERS    ; Branch to next label once we checked all 8 bits
    
    BRA     Print_MOVEM_PreDecr_List    ; Branch back into the loop 
    
Print_WHEN_REGISTER_ZERO
    MOVE.B  REGISTER_COUNTER,D6     ; Move the register number to D6 for printing 
    JSR     Print_Dn_Mode           ; Print the Dn mode
    
    ADD.B   #1,REGISTER_COUNTER     ; Increment the register counter
    ADD.B   #1,MOVEM_COUNTER        ; Increment the loop counter
    
    LEA     PRINT_SLASH,A1          ; Print a slash
    MOVE.B  #14,D0
    TRAP    #15
    
    BRA     Print_MOVEM_PreDecr_List    ; Branch back into the loop 
    
CLEAR_MOVEM_COUNTERS
    MOVE.B  #$00, MOVEM_COUNTER         ; Clear loop counter
    MOVE.B  #$00, REGISTER_COUNTER      ; Clear register counter
    BRA     Print_PreDecr_An_List_Loop  ; Branch to next label
    
Print_PreDecr_An_List_Loop
    ROL.W   #1,D3                       ; Rotate the first bit out to see if it is a 1 or 0 in binary
    BCS     Print_PreDecr_An_List       ; If it is a 1, branch to a label to print the respective format
    ADD.B   #1,REGISTER_COUNTER         ; Increment the register counter
    ADD.B   #1,MOVEM_COUNTER            ; Increment the loop counter
    CMP.B   #8,MOVEM_COUNTER
    BEQ     CLEAR_MOVEM_An_COUNTER      ; Branch to next label once we checked all 8 bits
    BRA     Print_PreDecr_An_List_Loop  ; If it is a 0, return back to the loop

    RTS
                       
Print_PreDecr_An_List
    CMP.B   #0,REGISTER_COUNTER
    BEQ     Print_WHEN_REGISTER_ZERO_An ; Check for case when there is Register is 0 and the carry bit is 1

    MOVE.B  REGISTER_COUNTER,D6         ; Move the register number to D6 for printing 
    JSR     Print_An_Mode               ; Print the An mode
    
    ADD.B   #1,REGISTER_COUNTER         ; Increment the register counter
    ADD.B   #1,MOVEM_COUNTER            ; Increment the loop counter
    
    CMP.B   #8,MOVEM_COUNTER
    BEQ     CLEAR_MOVEM_An_COUNTER      ; Branch to next label once we checked all 8 bits
    
    LEA     PRINT_SLASH,A1              ; Print a slash
    MOVE.B  #14,D0
    TRAP    #15
    
    BRA     Print_PreDecr_An_List_Loop  ; Branch back into the loop
                        
CLEAR_MOVEM_An_COUNTER
    MOVE.B  #$00, MOVEM_COUNTER         ; Clear loop counter         
    MOVE.B  #$00, REGISTER_COUNTER      ; Clear register counter
    BRA     PreDecr_Rest_Code           ; Branch to the next label
    
PreDecr_Rest_Code    
    LEA     PRINT_COMMA,A1              ; Print a comma
    MOVE.B  #14,D0
    TRAP    #15
    
    MOVE.B  D7,D6      ; D7 has the original register value, since D6 got changed during the list printing
    
    JSR     EA_Check_Mode               Print the appropriate mode and register
    
    RTS
    
Print_WHEN_REGISTER_ZERO_An
    MOVE.B  REGISTER_COUNTER,D6         ; Move the register number to D6 for printing 
    JSR     Print_An_Mode               ; Print the An mode
    
    ADD.B   #1,REGISTER_COUNTER         ; Increment the register counter
    ADD.B   #1,MOVEM_COUNTER            ; Increment the loop counter
    
    LEA     PRINT_SLASH,A1              ; Print a slash
    MOVE.B  #14,D0
    TRAP    #15
    
    BRA     Print_PreDecr_An_List_Loop  ; Branch back into the loop   


EA_BRANCHES
    MOVE.L  #$00000000,INVALID_DATA_VALUE
    * D4 has the instruction format
    
    CLR     D2         ; Source Mode
    CLR     D6         ; Source Register
    CLR     D3
    
    MOVE.W  D4,D3
    LSL.W   #8,D3      
    LSR.W   #8,D3      ; Shift to get Displacement bits(xxxx xxxx yyyy yyyy)
    
    ADD.L   D4,INVALID_DATA_VALUE ; Load data for printing purposes
    
    CMP.B   #$00,D3    ; Compare to IMM Word
    BEQ     Print_Branch_Immediate_Word
    
    CMP.B   #$FF,D3    ; Compare to IMM Long
    BEQ     Print_Branch_Immediate_Long
    
    BRA     Print_Branch_Byte ; If not then invalid
    
    RTS
    
Print_Branch_Byte
    JSR     Print_BYTE_SIZE
    
    CLR     D3
    CLR     D5
    
    MOVE.W  D4,D5
    LSL.W   #8,D5      
    LSR.W   #8,D5      ; Shift to get Displacement bits(xxxx xxxx yyyy yyyy)
    
    ADD.L   A6,D5
    ADD.L   #$00000002,D5 
    
    LSL.L   #8,D5
    LSL.L   #8,D5
    LSR.L   #8,D5
    LSR.L   #8,D5      ; get rid of the 1 at the beginning of only 4-bit value we print 
    
    CLR     LOOP_COUNTER 
    JSR     PRINTADDRESSLOOP
    
    CLR     D5
    MOVE.W  A4,D5      ; Reset D5 to store the address and the not the value in the address
    MOVE.B  #$00, IMMEDIATE_SIZE_FLAG
    
    RTS
    

Print_Branch_Immediate_Word
    JSR     Print_WORD_SIZE
    
    CLR     D5
    MOVE.W  (A4)+,D5   ; Read an extra word
    ADD.L   A6,D5
    ADD.L   #$00000002,D5 
    
    LSL.L   #8,D5
    LSL.L   #8,D5
    LSR.L   #8,D5
    LSR.L   #8,D5
    
    CLR     LOOP_COUNTER 
    JSR     PRINTADDRESSLOOP    
    
    CLR     D5
    MOVE.W  A4,D5      ; Reset D5 to store the address and the not the value in the address
    MOVE.B  #$00, IMMEDIATE_SIZE_FLAG
    RTS

Print_Branch_Immediate_Long
    JSR     Print_WORD_SIZE
    CLR     D5
    MOVE.L  (A4)+,D5   ; Read an extra word 
    ADD.L   A6,D5
    ADD.L   #$00000002,D5
    
    LSL.L   #8,D5
    LSL.L   #8,D5
    LSR.L   #8,D5
    LSR.L   #8,D5
    
    CLR     LOOP_COUNTER 
    JSR     PRINTADDRESSLOOP    
    
    CLR     D5
    MOVE.L  A4,D5      ; Reset D5 to store the address and the not the value in the address
    MOVE.B  #$00, IMMEDIATE_SIZE_FLAG
    RTS        

EA_DIVUW
    MOVE.L  #$00000000,INVALID_DATA_VALUE
    * D4 has the instruction format
    
    CLR     D2          ; Source Mode
    CLR     D6          ; Source Register
    CLR     D3          
    
    MOVE.W  D4,D2
    LSL.W   #5,D2       
    LSL.W   #5,D2       ; Shift to get last 6 bits (xxxx xxxx xxyy yyyy)
    LSR.W   #8,D2       
    LSR.W   #5,D2       ; Shift to get Mode bits (xxxx xxxx xxyy yxxx)
    
    ADD.L   D4,INVALID_DATA_VALUE ; Load data to invalid value for printing purposes
    
    CMP.B   An_MODE_VAL,D2 ; Check for invalid Mode
    BEQ     INVALID_EA   

    MOVE.W  D4,D6
    LSL.W   #8,D6       
    LSL.W   #5,D6       ; Shift to get last 6 bits (xxxx xxxx xxyy yyyy)
    LSR.W   #8,D6       
    LSR.W   #5,D6       ; Shift to get Register bits (xxxx xxxx xxyy yxxx)
          
    CMP.B   #$0,D6      ; Make sure the register is in range
    BLT     INVALID_EA
    
    CMP.B   #$7,D6      ; Check if its not out of bounds
    BGT     INVALID_EA
    
    JSR     EA_Check_Mode ; Jump to print Mode
    
    CLR     INVALID_DATA_VALUE

    LEA     PRINT_COMMA,A1    
    MOVE.B  #14,D0
    TRAP    #15
    
    CLR     D6

    MOVE.W  D4,D6
    LSL.W   #4,D6       
    LSR.W   #8,D6       
    LSR.W   #5,D6       ; Shift to get Register Bits(xxxx yyyx xxxx xxxx)

    JSR     Print_Dn_Mode  
    
    RTS
    
    
EA_MULSW
    MOVE.L  #$00000000,INVALID_DATA_VALUE
    * D4 has the instruction format
    
    CLR     D2          ; Source Mode
    CLR     D6          ; Source Register
    CLR     D3          
    
    MOVE.W  D4,D2
    LSL.W   #5,D2       
    LSL.W   #5,D2       ; Shift to get last 6 bits (xxxx xxxx xxyy yyyy)
    LSR.W   #8,D2       
    LSR.W   #5,D2       ; Shift to get Mode bits (xxxx xxxx xxyy yxxx)
    
    ADD.L   D4,INVALID_DATA_VALUE ; Load data to invalid value for printing purposes
    
    CMP.B   An_MODE_VAL,D2 ; Check for invalid Mode
    BEQ     INVALID_EA   

    MOVE.W  D4,D6
    LSL.W   #8,D6       
    LSL.W   #5,D6       ; Shift to get last 6 bits (xxxx xxxx xxyy yyyy)
    LSR.W   #8,D6        
    LSR.W   #5,D6       ; Shift to get Register bits (xxxx xxxx xxxx xyyy)
          
    CMP.B   #$0,D6      ; Make sure the register is in range
    BLT     INVALID_EA
    
    CMP.B   #$7,D6      ; Check if its not out of bounds
    BGT     INVALID_EA
    
    JSR     EA_Check_Mode ; Jump to Print Mode
    
    CLR     INVALID_DATA_VALUE

    LEA     PRINT_COMMA,A1    
    MOVE.B  #14,D0
    TRAP    #15
    
    CLR     D6

    MOVE.W  D4,D6
    LSL.W   #4,D6       
    LSR.W   #8,D6       
    LSR.W   #5,D6       ; Shift to get Register bits (xxxx yyyx xxxx xxxx)

    JSR     Print_Dn_Mode   
    
    RTS


EA_AND 
    MOVE.L  #$00000000,INVALID_DATA_VALUE
    * D4 has the instruction format
    
    CLR     D2          ; Source Mode
    CLR     D6          ; Source Register
    CLR     D3          
    
    MOVE.W  D4,D3
    LSL.W   #7,D3
    LSR.W   #8,D3
    LSR.W   #7,D3       ; Shift to get Operation bit (xxxx xxxy xxxx xxxx)
    
    CMP.B   #$0,D3
    BEQ     AND_TO_DATA_REGISTER    
    
    CMP.B   #$1,D3
    BEQ     AND_FROM_DATA_REGISTER_TO_EA   
    
    RTS
    
    
AND_TO_DATA_REGISTER
    MOVE.L  #$00000000,INVALID_DATA_VALUE
    * D4 has the instruction format
    
    CLR     D2          ; Source Mode
    CLR     D6          ; Source Register
    CLR     D3          
    
    MOVE.W  D4,D2
    LSL.W   #5,D2       
    LSL.W   #5,D2       ; Shift to get last 6 bits (xxxx xxxx xxyy yyyy)
    LSR.W   #8,D2       
    LSR.W   #5,D2       ; Shift to get Mode bits (xxxx xxxx xxyy yxxx)
    
    ADD.L   D4,INVALID_DATA_VALUE ; Load data to invalid value for printing purposes
    
    CMP.B   An_MODE_VAL,D2 ; Check for invalid Mode
    BEQ     INVALID_EA  
    
    
    MOVE.W  D4,D6
    LSL.W   #8,D6       
    LSL.W   #5,D6       ; Shift to get last 6 bits (xxxx xxxx xxyy yyyy)
    LSR.W   #8,D6       
    LSR.W   #5,D6       ; Shift to get Register bits (xxxx xxxx xxxx xyyy)
          
    CMP.B   #$0,D6      ; Make sure the register is in range
    BLT     INVALID_EA
    
    CMP.B   #$7,D6      ; Check if its not out of bounds
    BGT     INVALID_EA
    
    JSR     EA_Check_Mode ; Jump to print Mode

    LEA     PRINT_COMMA,A1    
    MOVE.B  #14,D0
    TRAP    #15
    
    CLR     D6

    MOVE.W  D4,D6
    LSL.W   #4,D6       
    LSR.W   #8,D6       
    LSR.W   #5,D6       ; Shift to get register(xxxx yyyx xxxx xxxx)

    JSR     Print_Dn_Mode    
        
    RTS        
    
    
AND_FROM_DATA_REGISTER_TO_EA
    MOVE.L  #$00000000,INVALID_DATA_VALUE
    * D4 has the instruction format
        
    CLR     D2          ; Source Mode
    CLR     D6          ; Source Register
    CLR     D3          
    
    MOVE.W  D4,D6       
    LSL.W   #4,D6       ; Shift to get register
    LSR.W   #8,D6       
    LSR.W   #5,D6       ; Shift to get the 3 register bits (xxxx yyyx xxxx xxxx)
    
    ADD.L   D4,INVALID_DATA_VALUE
    
    JSR    Print_Dn_Mode       
    
    LEA     PRINT_COMMA,A1    
    MOVE.B  #14,D0
    TRAP    #15

    CLR     D2          ; Source Mode
    CLR     D6          ; Source Register
    CLR     D3          
    
    MOVE.W  D4,D2
    LSL.W   #5,D2       
    LSL.W   #5,D2       ; Shift to get last 6 bits (xxxx xxxx xxyy yyyy)
    LSR.W   #8,D2       
    LSR.W   #5,D2       ; Shift to get Mode bits (xxxx xxxx xxyy yxxx)
    
    ; Check for invalid Modes
    CMP.B   Dn_MODE_VAL,D2
    BEQ     INVALID_EA
    
    CMP.B   An_MODE_VAL,D2
    BEQ     INVALID_EA      

    MOVE.W  D4,D6
    LSL.W   #8,D6       
    LSL.W   #5,D6       ; Shift to get last 6 bits (xxxx xxxx xxyy yyyy)
    LSR.W   #8,D6       
    LSR.W   #5,D6       ; Shift to get the last 3 bits (xxxx xxxx xxxx xyyy)
          
    CMP.B   #$0,D6      ; Make sure the register is in range
    BLT     INVALID_EA
    
    CMP.B   #$7,D6      ; Check if its not out of bounds
    BGT     INVALID_EA

    CMP.B   IMMDATA_MODE_VAL, D2 ; Check for IMM data Mode
    BEQ     IMMEDIATE_CHECK_AND

    JSR     EA_Check_Mode ; Jump to Print Mode

    RTS


IMMEDIATE_CHECK_AND
    CMP.B   IMMDATA_REGISTER_VAL,D6 ; Check for invalid Imm data 
    BEQ     INVALID_EA
    
    BRA     EA_Check_Mode ; Jump to Print Mode
    
EA_ADD_SUB
    MOVE.L  #$00000000,INVALID_DATA_VALUE
    * D4 has the instruction format
    
    CLR     D2          ; Source Mode
    CLR     D6          ; Source Register
    CLR     D3          
    
    MOVE.W  D4,D3
    LSL.W   #7,D3
    LSR.W   #8,D3
    LSR.W   #7,D3       ; Shift to get Direction bit (xxxx xxxy xxxx xxxx)
    
    CMP.B   #$0,D3
    BEQ     ADD_SUB_TO_DATA_REGISTER    
    
    CMP.B   #$1,D3
    BEQ     ADD_SUB_FROM_DATA_REGISTER_TO_EA 
    RTS
    
ADD_SUB_TO_DATA_REGISTER 
    MOVE.L  #$00000000,INVALID_DATA_VALUE
    * D4 has the instruction format
    
    CLR     D2          ; Source Mode
    CLR     D6          ; Source Register
    CLR     D3          
    
    MOVE.W  D4,D2
    LSL.W   #5,D2       
    LSL.W   #5,D2       ; Shift to get last 6 bits (xxxx xxxx xxyy yyyy)
    LSR.W   #8,D2       
    LSR.W   #5,D2       ; Shift to get Mode bits (xxxx xxxx xxyy yxxx)
    
    ADD.L   D4,INVALID_DATA_VALUE ; Load data to invalid value for printing purposes   
    
    MOVE.W  D4,D6
    LSL.W   #8,D6       
    LSL.W   #5,D6       ; Shift to get last 6 bits (xxxx xxxx xxyy yyyy)
    LSR.W   #8,D6       
    LSR.W   #5,D6       ; Shift to get Register bits (xxxx xxxx xxxx xyyy)
          
    CMP.B   #$0,D6      ; Make sure the register is in range
    BLT     INVALID_EA
    
    CMP.B   #$7,D6      ; Check if its not out of bounds
    BGT     INVALID_EA
    
    JSR     EA_Check_Mode ; Jump to Print Mode

    LEA     PRINT_COMMA,A1    
    MOVE.B  #14,D0
    TRAP    #15
    
    CLR     D6

    MOVE.W  D4,D6
    LSL.W   #4,D6       
    LSR.W   #8,D6       
    LSR.W   #5,D6       ; Shift to get register bits (xxxx yyyx xxxx xxxx)

    JSR     Print_Dn_Mode    
        
    RTS        


ADD_SUB_FROM_DATA_REGISTER_TO_EA
    MOVE.L  #$00000000,INVALID_DATA_VALUE
    * D4 has the instruction format
        
    CLR     D2          ; Source Mode
    CLR     D6          ; Source Register
    CLR     D3          
    
    MOVE.W  D4,D6       
    LSL.W   #4,D6       ; Shift to get last REGISTER bits
    LSR.W   #8,D6       
    LSR.W   #5,D6       ; Shift to get the 3 register bits (xxxx yyyx xxxx xxxx)
    
    ADD.L   D4,INVALID_DATA_VALUE
    
    JSR    Print_Dn_Mode       
    
    LEA     PRINT_COMMA,A1    
    MOVE.B  #14,D0
    TRAP    #15

    CLR     D2          ; Source Mode
    CLR     D6          ; Source Register
    CLR     D3          
    
    MOVE.W  D4,D2
    LSL.W   #5,D2       
    LSL.W   #5,D2       ; Shift to get last 6 bits (xxxx xxxx xxyy yyyy)
    LSR.W   #8,D2       
    LSR.W   #5,D2       ; Shift to get Mode bits (xxxx xxxx xxyy yxxx)
    
    ; Check for invalid Modes
    CMP.B   Dn_MODE_VAL,D2
    BEQ     INVALID_EA
    
    CMP.B   An_MODE_VAL,D2
    BEQ     INVALID_EA      

    MOVE.W  D4,D6
    LSL.W   #8,D6       
    LSL.W   #5,D6       ; Shift to get last 6 bits (xxxx xxxx xxyy yyyy)
    LSR.W   #8,D6       
    LSR.W   #5,D6       ; Shift to get register bits (xxxx xxxx xxxx xyyy)
          
    CMP.B   #$0,D6      ; Make sure the register is in range
    BLT     INVALID_EA
    
    CMP.B   #$7,D6      ; Check if its not out of bounds
    BGT     INVALID_EA

    CMP.B   IMMDATA_MODE_VAL, D2 ; Check for Imm data Mode
    BEQ     IMMEDIATE_CHECK_ADD_SUB

    JSR     EA_Check_Mode ; Jump to Print Mode

    RTS
    
IMMEDIATE_CHECK_ADD_SUB
    CMP.B   IMMDATA_REGISTER_VAL,D6 ; Check for Invalid IMM data
    BEQ     INVALID_EA
    
    BRA     EA_Check_Mode ; Jump to Print EA Mode
    
    
EA_LSL_ASL_LOGIC
    MOVE.L  #$00000000,INVALID_DATA_VALUE
    * D4 has the instruction format
        
    CLR     D2          ; Source Mode
    CLR     D6          ; Source Register
    CLR     D3  
    
    MOVE.W  D4,D3   
    LSL.W   #7,D3
    LSR.W   #8,D3
    LSR.W   #7,D3       ; Shift to get direction bit (xxxx xxxy xxxx xxxx)
    
    ADD.L   D4,INVALID_DATA_VALUE  ; Load data to invalid value for printing purposes
    
    CMP.B   #$0,D3      ; Check if invalid Opcode
    BEQ     INVALID_OPCODE
    
    CLR     D3
    MOVE.W  D4,D3   *i/r
    LSL.W   #8,D3
    LSL.W   #2,D3
    LSR.W   #8,D3
    LSR.W   #7,D3       ; Shift to get i/r bits (xxxx xxxx xxyy yxxx)
    
    CMP.B   #$0,D3
    BEQ     LSL_ASL_IMMEDIATE_SHIFT

    BRA     LSL_ASL_DATA_REGISTER_SHIFT
    RTS
    
LSL_ASL_IMMEDIATE_SHIFT
    CLR     D3
    MOVE.W  D4,D3
    LSL.W   #4,D3
    LSR.W   #8,D3
    LSR.W   #5,D3       ; Shift to get Register bits (xxxx yyyx xxxx xxxx)
    MOVE.W  D3,D6       
    
    CMP.B   #$0,D6      ; Make sure the register is in range
    BLT     INVALID_EA
    
    CMP.B   #$7,D6      ; check if its not out of bounds
    BGT     INVALID_EA
    
    CMP.B   #$0,D6
    BEQ     CHANGE_SIZE_COUNT_TO_8 ; if 0 then must print 8
    
    BRA     LSL_ASL_REST_CODE
    
LSL_ASL_REST_CODE
    LEA     PRINT_IMMDATA,A1   ; Print IMMData Label
    MOVE.B  #14,D0
    TRAP    #15

    JSR     Print_Register
    
    LEA     PRINT_COMMA,A1    
    MOVE.B  #14,D0
    TRAP    #15
    
    CLR     D6
    MOVE.W  D4,D6       
    LSL.W   #8,D6       
    LSL.W   #5,D6       ; Shift to get last REGISTER bits
    LSR.W   #8,D6       
    LSR.W   #5,D6       ; Shift to get the 3 register bits (xxxx xxxx xxxx xyyy)
    
    CMP.B   #$0,D6      ; Make sure the register is in range
    BLT     INVALID_EA
    
    CMP.B   #$7,D6      ; Check if its not out of bounds
    BGT     INVALID_EA
    
    JSR     Print_Dn_Mode 
    
    RTS

CHANGE_SIZE_COUNT_TO_8
    CLR     D6
    MOVE.B  #$8,D6      ; Print 8 if 0 on bits
    BRA     LSL_ASL_REST_CODE
    
    
LSL_ASL_DATA_REGISTER_SHIFT
    CLR     D2          ; Source Mode
    CLR     D6          ; Source Register
    CLR     D3  

    MOVE.W  D4,D3      
    LSL.W   #4,D3
    LSR.W   #8,D3
    LSR.W   #5,D3       ; Shift to get register bits (xxxx yyyx xxxx xxxx)
    MOVE.W  D3,D6
    
    CMP.B   #$0,D6      ; Make sure the register is in range
    BLT     INVALID_EA
    
    CMP.B   #$7,D6      ; Check if its not out of bounds
    BGT     INVALID_EA
    
    JSR     Print_Dn_Mode

    LEA     PRINT_COMMA,A1    
    MOVE.B  #14,D0
    TRAP    #15

    CLR     D6
    MOVE.W  D4,D6       
    LSL.W   #8,D6       
    LSL.W   #5,D6       ; Shift to get last REGISTER bits
    LSR.W   #8,D6       
    LSR.W   #5,D6       ; Shift to get the 3 register bits (xxxx xxxx xxxx xyyy)
    
    CMP.B   #$0,D6      ; Make sure the register is in range
    BLT     INVALID_EA
    
    CMP.B   #$7,D6      ; Check if its not out of bounds
    BGT     INVALID_EA
    
    JSR     Print_Dn_Mode 
    
    RTS     


EA_LSL_ASL_MEMORY
    MOVE.L  #$00000000,INVALID_DATA_VALUE
    * D4 has the instruction format
        
    CLR     D2          ; Source Mode
    CLR     D6          ; Source Register
    CLR     D3  
    
    MOVE.W  D4,D3   
    LSL.W   #7,D3
    LSR.W   #8,D3
    LSR.W   #7,D3       ; Shift to get Direction bit (xxxx xxxy xxxx xxxx)
    
    ADD.L   D4,INVALID_DATA_VALUE  ; Load data to invalid value for printing purposes
    
    CMP.B   #$0,D3      ; Check for invalid Op code
    BEQ     INVALID_OPCODE 
    
    CLR     D3          
    
    MOVE.W  D4,D2
    LSL.W   #5,D2       
    LSL.W   #5,D2       ; Shift to get last 6 bits (xxxx xxxx xxyy yyyy)
    LSR.W   #8,D2       
    LSR.W   #5,D2       ; Shift to get Mode Bits (xxxx xxxx xxyy yxxx)
    
    ; Check for Invalid Modes
    CMP.B   Dn_MODE_VAL,D2
    BEQ     INVALID_EA  
    
    CMP.B   An_MODE_VAL,D2
    BEQ     INVALID_EA  
        
    MOVE.W  D4,D6
    LSL.W   #8,D6       
    LSL.W   #5,D6       ; Shift to get last 6 bits (xxxx xxxx xxyy yyyy)
    LSR.W   #8,D6       
    LSR.W   #5,D6       ; Shift to get the last 3 bits (xxxx xxxx xxxx xyyy)
          
    CMP.B   #$0,D6      ; Make sure the register is in range
    BLT     INVALID_EA
    
    CMP.B   #$7,D6      ; Check if its not out of bounds
    BGT     INVALID_EA

    CMP.B   IMMDATA_MODE_VAL, D2 ; Check for Imm Data Mode
    BEQ     IMMEDIATE_CHECK_LSL_ASL_MEMORY

    JSR     EA_Check_Mode ; Jump to Print Mode
    
    RTS

IMMEDIATE_CHECK_LSL_ASL_MEMORY
    CMP.B   IMMDATA_REGISTER_VAL,D6 ; Check for invalid Imm data
    BEQ     INVALID_EA
    
    BRA     EA_Check_Mode ; Jump to Print Mode if valid

*EA MODES PRINTING      ;
EA_Check_Mode
    CMP.B   Dn_MODE_VAL,D2              ; Check if its a data register
    BEQ     Print_Dn_Mode
    
    CMP.B   An_MODE_VAL,D2              ; Check if its an address register direct
    BEQ     Print_An_Mode
    
    CMP.B   INDIRECT_An_MODE_VAL,D2     ; Check if its an address register indirect
    BEQ     Print_INDIRECT_An_Mode
    
    CMP.B   POSTINCR_An_MODE_VAL,D2     ; Check if its an address register indirect with post-increment
    BEQ     Print_POSTINCR_An_Mode
    
    CMP.B   PREDECR_An_MODE_VAL,D2      ; Check if its an address register indirect with pre-decrement
    BEQ     Print_PREDECR_An_Mode
    
    CMP.B   MISC_MODE_VAL,D2            ; Check if its an absolute word/long address and immediate data, since all 3 have same mode value
    BEQ     Print_Remaining_Modes
    
    *Loaded D2 in error data value into INVALID_DATA_VALUE
    BRA     INVALID_EA                  ; Check for not supported Modes


* Print all modes
Print_Dn_Mode             ; Print D and then the register to the console
    LEA     PRINT_Dn,A1    
    MOVE.B  #14,D0
    TRAP    #15
    
    JSR     Print_Register
    
    RTS       
    
Print_An_Mode             ; Print A and then the register to the console
    LEA     PRINT_An,A1    
    MOVE.B  #14,D0
    TRAP    #15
    
    JSR     Print_Register
    
    RTS 
    
Print_INDIRECT_An_Mode    ; Print (A and then the register to the console and then )
    LEA     PRINT_INDIRECT_An,A1    
    MOVE.B  #14,D0
    TRAP    #15
    
    JSR     Print_Register
    
    LEA     PRINT_INDIRECT_An_END,A1    
    MOVE.B  #14,D0
    TRAP    #15
    
    RTS 

Print_POSTINCR_An_Mode    ;  Print (A and then the register to the console then )+
    LEA     PRINT_POSTINCR_An,A1    
    MOVE.B  #14,D0
    TRAP    #15
    
    JSR     Print_Register
    
    LEA     PRINT_POSTINCR_An_END,A1    
    MOVE.B  #14,D0
    TRAP    #15
    
    RTS 
    
Print_PREDECR_An_Mode     ;  Print -(A and then the register to the console then )
    LEA     PRINT_PREDECR_An,A1    
    MOVE.B  #14,D0
    TRAP    #15
    
    JSR     Print_Register
    
    LEA     PRINT_PREDECR_An_END,A1    
    MOVE.B  #14,D0
    TRAP    #15
    
    RTS 
    
Print_Remaining_Modes     ; Print Remaining Modes
    CMP.B   ABS_WORD_REGISTER_VAL,D6
    BEQ     Print_Absolute_Word
    
    CMP.B   ABS_LONG_REGISTER_VAL,D6
    BEQ     Print_Absolute_Long
    
    CMP.B   IMMDATA_REGISTER_VAL,D6
    BEQ     Print_Immediate_Data

    BRA     INVALID_EA    ; Check for not supported Modes

Print_Absolute_Word
    CLR     D5
    MOVE.W  (A4)+, D5     ; Read an extra word 
    
    CLR     LOOP_COUNTER 
    JSR     PRINTADDRESSLOOP    
    
    MOVE.W  A4,D5         ; Reset D5 to store the address and the not the value in the address
    RTS

Print_Absolute_Long
    CLR     D5
    MOVE.L  (A4)+, D5     ; Read an extra word 
    
    CLR     LOOP_COUNTER 
    JSR     PRINTADDRESSLOOP    
    
    MOVE.L  A4,D5         ; Reset D5 to store the address and the not the value in the address
    RTS

Print_Immediate_Data
    CMP.B   #$0,IMMEDIATE_SIZE_FLAG
    BEQ     Print_Immediate_Word
    
    BRA     Print_Immediate_Long
    
    
Print_Immediate_Word
    CLR     D5
    MOVE.W  (A4)+,D5      ; Read an extra word 
    
    CLR     LOOP_COUNTER 
    JSR     PRINTADDRESSLOOP    
    
    MOVE.W  A4,D5         ; Reset D5 to store the address and the not the value in the address
    MOVE.B  #$00, IMMEDIATE_SIZE_FLAG
    RTS

Print_Immediate_Long
    CLR     D5
    MOVE.L  (A4)+,D5      ; Read an extra word 
    
    CLR     LOOP_COUNTER 
    JSR     PRINTADDRESSLOOP    
    
    MOVE.L  A4,D5         ; Reset D5 to store the address and the not the value in the address
    MOVE.B  #$00, IMMEDIATE_SIZE_FLAG
    RTS

Print_Register
    JSR     COMPARE       ; Jump to print register 
    RTS
    
Print_BYTE_SIZE           ; Print .B to the console
    LEA     PRINT_BYTE,A1
    MOVE.B  #14,D0
    TRAP    #15
    RTS
    
Print_WORD_SIZE           ; Print .W to the console
    LEA     PRINT_WORD,A1
    MOVE.B  #14,D0
    TRAP    #15
    RTS
    
Print_LONG_SIZE           ; Print .L to the console
    LEA     PRINT_LONG,A1
    MOVE.B  #14,D0
    TRAP    #15
    RTS

*Invalid opcode and EA printing    
INVALID_OPCODE
    LEA     INVALID_OPCODE_MESS,A1    ; Print invalid op code message    
    MOVE.B  #14,D0
    TRAP    #15
    
    MOVE.L  INVALID_DATA_VALUE,D5     
    JSR     PRINTADDRESSLOOP          ; Print the invalid data value
    CLR     INVALID_DATA_VALUE        ; Clear so can be used again 
    MOVE.W  A4,D5
    BRA     RESET_SCREEN              ; Check how many lines on the screen and if reached max, reset screen in the label

         
INVALID_EA
    LEA     INVALID_EA_MESS,A1        ; Print invalid op code message    
    MOVE.B  #14,D0
    TRAP    #15
    
    MOVE.L  INVALID_DATA_VALUE,D5     
    JSR     PRINTADDRESSLOOP          ; Print the invalid data value
    CLR     INVALID_DATA_VALUE        ; Clear so can be used again 
    CLR     D2
    MOVE.W  A4,D5
    BRA     RESET_SCREEN              ; Check how many lines on the screen and if reached max, reset screen in the label

UNSIZED_INVALID_EA
    LEA     UNSIZED_INVALID_EA_MESS,A1  ; Print invalid op code message    
    MOVE.B  #14,D0
    TRAP    #15
    
    CLR     D2
    MOVE.W  A4,D5
    BRA     RESET_SCREEN              ; Check how many lines on the screen and if reached max, reset screen in the label


FINISH                                ; Reset registers  
    MOVE.L  #$00000000, A1
    MOVE.L  #$00000000, D0
    MOVE.L  #$00000000, D1
    
    BRA     BEGIN

NEXT_OP_STAGE                         ; Clear registers and variables for either reset or end disassembler
    MOVE.B  #$00,IMMEDIATE_SIZE_FLAG  
    MOVE.B  #$00,LOOP_COUNTER  
    MOVE.B  #$00,MOVEM_COUNTER     
    MOVE.B  #$00,REGISTER_COUNTER 
    
    MOVE.W  #$0000, INDIRECT_An_Flag    ; Clear all the flags
    MOVE.W  #$0000, POSTINCR_An_Flag  
    MOVE.W  #$0000, PREDECR_An_Flag 
    
    MOVE.L  #$00000000, TOTAL_LINES         ; Clear all the different variables used to save values throughout code
    MOVE.L  #$00000000, SOURCE_MODE_VAR 
    MOVE.L  #$00000000, SOURCE_REGISTER_VAR
    MOVE.L  #$00000000, DEST_MODE_VAR
    MOVE.L  #$00000000, DEST_REGISTER_VAR
    MOVE.L  #$00000000, INVALID_DATA_VALUE
    
    MOVE.L  #$00000000, A0           ; Clear all the address registers
    MOVE.L  #$00000000, A1
    MOVE.L  #$00000000, A2
    MOVE.L  #$00000000, A3   
    MOVE.L  #$00000000, A4
    MOVE.L  #$00000000, A5
    MOVE.L  #$00000000, A6
    MOVE.L  #$00000000, A7
    
    MOVE.L  #$00000000, D0          ; Clear all the data registers
    MOVE.L  #$00000000, D1
    MOVE.L  #$00000000, D2
    MOVE.L  #$00000000, D3    
    MOVE.L  #$00000000, D4
    MOVE.L  #$00000000, D5
    MOVE.L  #$00000000, D6
    MOVE.L  #$00000000, D7 
    
    LEA     DISASS_AGAIN_MESSAGE,A1   ; Print use again code message    
    MOVE.B  #14,D0
    TRAP    #15
    
    LEA     INPUTUSER,A1              ; Read user input 
    MOVE.B  #2,D0
    TRAP    #15        
    
    CMP.B   #$79,(A1)                 ; Check to see if input is y
    BEQ     FINISH
    
    LEA     FINISH_MESSAGE,A1         ; If chose to Finish print finish message 
    MOVE.B  #14,D0
    TRAP    #15   
    
    SIMHALT                           ; halt simulator


* Put variables and constants here
CR          EQU     $0D
LF          EQU     $0A
HT          EQU     $09
NEW_LINE    DC.B    CR,LF,0

STARTADDRESS_MESSAGE    DC.B    CR,LF,'Enter a starting address (0-9, A-F): ',0
ENDADDRESS_MESSAGE      DC.B    CR,LF,'Enter an ending address (0-9, A-F): ',0
WELCOME_MESSAGE         DC.B    'Welcome to the disassembler!',0
DISASS_AGAIN_MESSAGE    DC.B    CR,LF,'Please enter y to disassemble again, otherwise enter any other key to finish: ',0
FINISH_MESSAGE          DC.B    'I hope you enjoyed our disassembler program!',0
ADDRESS_ERROR           DC.B    'ERROR: INVALID ADDRESS', 0
ADDRESS_VAL_ERROR       DC.B    'ERROR: END ADDRESS SMALLER THAN START ADDRESS', 0
INPUT_FROM_USER         DS.L    1
USERINPUT               DS.L    1
INPUT_USER              DS.L    1
INPUTUSER               DS.L    1
TOTAL_LINES             EQU     $0FF0   
ENTER_AGAIN_MESSAGE     DC.B    CR,LF,'Press enter each time you want to print more lines: ',0
INVALID_OPCODE_MESS     DC.B    HT,'DATA   $',0
INVALID_EA_MESS         DC.B    'Error: Invalid EA,          DATA   $',0
UNSIZED_INVALID_EA_MESS DC.B    'Error: Invalid EA,          DATA',0

PRINT_NOP               DC.B    HT,'NOP',0
PRINT_RTS               DC.B    HT,'RTS',0
PRINT_JSR               DC.B    HT,'JSR',HT,0
PRINT_NOT               DC.B    HT,'NOT',0
PRINT_LEA               DC.B    HT,'LEA',HT,0
PRINT_MOVEM             DC.B    HT,'MOVEM',0
PRINT_MOVE              DC.B    HT,'MOVE',0
PRINT_DIVUW             DC.B    HT,'DIVU.W   ',0
PRINT_MULSW             DC.B    HT,'MULS.W   ',0
PRINT_AND               DC.B    HT,'AND',0
PRINT_ADD               DC.B    HT,'ADD',0
PRINT_SUB               DC.B    HT,'SUB',0
PRINT_LSL               DC.B    HT,'LSL',0
PRINT_ASL               DC.B    HT,'ASL',0
PRINT_BRA               DC.B    HT,'BRA',0
PRINT_BGT               DC.B    HT,'BGT',0
PRINT_BLE               DC.B    HT,'BLE',0
PRINT_BCC               DC.B    HT,'BCC',0
PRINT_BEQ               DC.B    HT,'BEQ',0


PRINT_BYTE              DC.B    '.B  ',0
PRINT_WORD              DC.B    '.W  ',0
PRINT_LONG              DC.B    '.L  ',0


PRINT_Dn                DC.B    'D',0
PRINT_An                DC.B    'A',0
PRINT_INDIRECT_An       DC.B    '(A',0
PRINT_INDIRECT_An_END   DC.B    ')',0
PRINT_POSTINCR_An       DC.B    '(A',0
PRINT_POSTINCR_An_END   DC.B    ')+',0
PRINT_PREDECR_An        DC.B    '-(A',0
PRINT_PREDECR_An_END    DC.B    ')',0
PRINT_IMMDATA           DC.B    '#',0
PRINT_COMMA             DC.B    ',',0
PRINT_SLASH             DC.B    '/',0

INDIRECT_An_Flag        DS.W    1
POSTINCR_An_Flag        DS.W    1
PREDECR_An_Flag         DS.W    1

Dn_MODE_VAL             DC.B    $0
An_MODE_VAL             DC.B    $1
INDIRECT_An_MODE_VAL    DC.B    $2
POSTINCR_An_MODE_VAL    DC.B    $3
PREDECR_An_MODE_VAL     DC.B    $4
ABS_WORD_MODE_VAL       DC.B    $7
ABS_LONG_MODE_VAL       DC.B    $7
IMMDATA_MODE_VAL        DC.B    $7
MISC_MODE_VAL           DC.B    $7

ABS_WORD_REGISTER_VAL   DC.B    $0
ABS_LONG_REGISTER_VAL   DC.B    $1
IMMDATA_REGISTER_VAL    DC.B    $4

StartAddress            DS.L    1
EndAddress              DS.L    1  

BYTE_VAR                DC.B    $0
WORD_VAR                DC.B    $1
LONG_VAR                DC.B    $2

IMMEDIATE_SIZE_FLAG     DS.B    1

NOP_OPCODE              DC.W    $4E71
RTS_OPCODE              DC.W    $4E75
JSR_OPCODE              DC.W    $013A
NOT_OPCODE              DC.W    $0046

SOURCE_MODE_VAR         DS.L    1
SOURCE_REGISTER_VAR     DS.L    1
DEST_MODE_VAR           DS.L    1
DEST_REGISTER_VAR       DS.L    1


LOOP_COUNTER            DS.B    1
MOVEM_COUNTER           DS.B    1
REGISTER_COUNTER        DS.B    1
INVALID_DATA_VALUE      DS.L    1

   
    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
