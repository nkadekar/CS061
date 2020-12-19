

; test harness
					.orig x3000
				 
LD R6, SUB_PRINT_OPCODE_TABLE
JSRR R6	

AND R1, R1, #0
ADD R1, R1, #5
REPEAT	
LD R6, SUB_FIND_OPCODE
JSRR R6
ADD R1, R1, #-1
BRp REPEAT
 
					halt
;-----------------------------------------------------------------------------------------------
; test harness local data:
SUB_PRINT_OPCODE_TABLE	.fill	x3200
SUB_FIND_OPCODE			.fill	x3600

;===============================================================================================


; subroutines:
;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_PRINT_OPCODE_TABLE
; Parameters: None
; Postcondition: The subroutine has printed out a list of every LC3 instruction
;				 and corresponding opcode in the following format:
;					ADD = 0001
;					AND = 0101
;					BR = 0000
;					…
; Return Value: None
;-----------------------------------------------------------------------------------------------
					.orig x3200
					
ST R0, Backup_R0_3200
ST R1, Backup_R1_3200
ST R2, Backup_R2_3200
ST R3, Backup_R3_3200
ST R6, Backup_R3_3200
ST R7, Backup_R7_3200
					
LD R1, instructions_po_ptr
LD R2, opcodes_po_ptr

TABLE_LOOP
	PUTS_LOOP
		LDR R0, R1, #0
		BRz END_PUTS_LOOP                            
		OUT
		ADD R1, R1, #1                                     
		BR PUTS_LOOP
	END_PUTS_LOOP
	
	LEA R0, equalSign
	PUTS
	
	LD R6, SUB_PRINT_OPCODE ;run 2nd subroutine
	JSRR R6
	ADD R2, R2, #1
	
	LD R0, newline
	OUT
	
	ADD R1, R1, #1
	LDR R3, R1, #0
	BRn END_TABLE_LOOP
	BR TABLE_LOOP
END_TABLE_LOOP

LD R0, Backup_R0_3200
LD R1, Backup_R1_3200
LD R2, Backup_R2_3200
LD R3, Backup_R3_3200
LD R6, Backup_R3_3200
LD R7, Backup_R7_3200
 				 	 
					ret
;-----------------------------------------------------------------------------------------------
; SUB_PRINT_OPCODE_TABLE local data
opcodes_po_ptr		.fill x4000				; local pointer to remote table of opcodes
instructions_po_ptr	.fill x4100				; local pointer to remote table of instructions
equalSign			.stringz " = "
newline				.fill '\n'
DEC_1				.fill #1
SUB_PRINT_OPCODE	.fill x3400
Backup_R0_3200		.BLKW	#1
Backup_R1_3200		.BLKW	#1
Backup_R2_3200		.BLKW	#1
Backup_R3_3200		.BLKW	#1
Backup_R6_3200		.BLKW	#1
Backup_R7_3200		.BLKW	#1
;===============================================================================================


;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_PRINT_OPCODE
; Parameters: R2 containing a 4-bit op-code in the 4 LSBs of the register
; Postcondition: The subroutine has printed out just the 4 bits as 4 ascii 1s and 0s
;				 The output is NOT newline terminated.
; Return Value: None
;-----------------------------------------------------------------------------------------------
					.orig x3400
				 
ST R0, Backup_R0_3400
ST R1, Backup_R1_3400
ST R3, Backup_R3_3400
ST R4, Backup_R4_3400
ST R7, Backup_R7_3400

AND R4, R4, #0

LDR R1, R2, #0
ADD R4, R4, #12 ;counter of 12
LOOP_12
	ADD R1, R1, R1
	ADD R4, R4, #-1
	BRp LOOP_12
END_LOOP_12

ADD R4, R4, #4 ;counter reset to 4
LOOP_4
	ADD R1, R1, #0 ;LMR
		BRzp POSITIVE
			NEGATIVE: ;if number is neg, MSB is 1
				AND R0, R0, #0
				ADD R0, R0, #1 ;load 1
				ADD R0, R0, #12
				ADD R0, R0, #12
				ADD R0, R0, #12
				ADD R0, R0, #12
				OUT
				BR END_OUT_IF
			POSITIVE: ;if number is pos, MSB is 0
				AND R0, R0, #0 ;load 0
				ADD R0, R0, #12
				ADD R0, R0, #12
				ADD R0, R0, #12
				ADD R0, R0, #12
				OUT
		END_OUT_IF
		ADD R1, R1, R1
		ADD R4, R4, #-1
		BRp LOOP_4
END_LOOP_4

LD R0, Backup_R0_3400
LD R1, Backup_R1_3400
LD R3, Backup_R3_3400
LD R4, Backup_R4_3400
LD R7, Backup_R7_3400
				 
					ret
;-----------------------------------------------------------------------------------------------
; SUB_PRINT_OPCODE local data
Backup_R0_3400		.BLKW	#1
Backup_R1_3400		.BLKW	#1
Backup_R3_3400		.BLKW	#1
Backup_R4_3400		.BLKW	#1
Backup_R7_3400		.BLKW	#1
;===============================================================================================


;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_FIND_OPCODE
; Parameters: None
; Postcondition: The subroutine has invoked the SUB_GET_STRING subroutine and stored a string
; 				as local data; it has searched the AL instruction list for that string, and reported
;				either the instruction/opcode pair, OR "Invalid instruction"
; Return Value: None
;-----------------------------------------------------------------------------------------------
					.orig x3600
			
ST R0, Backup_R0_3600
ST R1, Backup_R1_3600
ST R2, Backup_R2_3600
ST R3, Backup_R3_3600
ST R4, Backup_R4_3600
ST R7, Backup_R7_3600		
	
LEA R2, Storage

LD R6, SUB_GET_STRING	
JSRR R6

LEA R2, Storage
LD R1, instructions_fo_ptr
LD R6, opcodes_fo_ptr	

SEARCH_LOOP
		LDR R3, R1, #0
		BRn INVALID_INPUT ;instructions table hits -1
		LDR R4, R2, #0
		BRz POSSIBLE_COMPLETE ;storage word is over
		
		ADD R3, R3, #0
		BRz FIX_ISSUE ;instructions table word is over but store word is not over
		
		NOT R4, R4
		ADD R4, R4, #1
		ADD R5, R3, R4 ;Add the two chars together
		BRnp NOT_ZERO
		ADD R1, R1, #1 ;if letters are same
		ADD R2, R2, #1
		BR SEARCH_LOOP
		
		NOT_ZERO ;if letters are not the same
		LEA R2, Storage
		NEXT_WORD_LOOP ;
			ADD R1, R1, #1
			LDR R3, R1, #0
			ADD R3, R3, #0
			BRp NEXT_WORD_LOOP
			BRn INVALID_INPUT
			BRp NEXT_WORD_LOOP
			ADD R1, R1, #1
			ADD R6, R6, #1 ;increment opcodes table
			BR SEARCH_LOOP
		END_NEXT_WORD_LOOP
		BR SEARCH_LOOP ;just in case code gets to this line
	END_SEARCH_LOOP

FIX_ISSUE ;fixes the issue of JSR after JSRR when R1 must be reduced by 1 before NOT_ZERO loop
ADD R1, R1, #-1
BR NOT_ZERO

POSSIBLE_COMPLETE ;must check if both words are at '0'
NOT R4, R4
ADD R4, R4, #1
ADD R5, R3, R4
BRz MATCH_COMPLETE
BR NOT_ZERO

MATCH_COMPLETE ;if instruction is found
LEA R2, Storage
OUTPUT_LOOP
	LDR R0, R2, #0
	BRz END_OUTPUT_LOOP                            
	OUT
	ADD R2, R2, #1                                     
	BR OUTPUT_LOOP
END_OUTPUT_LOOP
LEA R0, equalSign2
PUTS
AND R2, R2, #0
ADD R2, R2, R6
LD R6, SUB_PRINT_OPCODE2 ;run 2nd subroutine
JSRR R6
BR END_SUB

INVALID_INPUT ;if instruction is not found
LEA R0, invalid_input
PUTS
BR END_SUB

END_SUB
	 
LD R0, newline2 ;terminating newline. Mostly to look nice when testing
OUT

LEA R2, Storage
RESET_STRING
	LDR R3, R2, #0
	BRz END_RESET_STRING
	AND R3, R3, #0
	STR R3, R2, #0
	ADD R2, R2, #1
	BR RESET_STRING
END_RESET_STRING
	 
LD R0, Backup_R0_3600
LD R1, Backup_R1_3600
LD R2, Backup_R2_3600
LD R3, Backup_R3_3600
LD R4, Backup_R4_3600
LD R7, Backup_R7_3600				 
				 	 
				 ret
;-----------------------------------------------------------------------------------------------
; SUB_FIND_OPCODE local data
opcodes_fo_ptr			.fill x4000
instructions_fo_ptr		.fill x4100
SUB_GET_STRING			.fill	x3800
Storage					.BLKW	#15
invalid_input			.stringz "Invalid Instruction"
equalSign2			.stringz " = "
newline2				.fill '\n'
SUB_PRINT_OPCODE2	.fill x3400
Backup_R0_3600		.BLKW	#1
Backup_R1_3600		.BLKW	#1
Backup_R2_3600		.BLKW	#1
Backup_R3_3600		.BLKW	#1
Backup_R4_3600		.BLKW	#1
Backup_R7_3600		.BLKW	#1
;===============================================================================================


;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_GET_STRING
; Parameters: R2 - the address to which the null-terminated string will be stored.
; Postcondition: The subroutine has prompted the user to enter a short string, terminated 
; 				by [ENTER]. That string has been stored as a null-terminated character array 
; 				at the address in R2
; Return Value: None (the address in R2 does not need to be preserved)
;-----------------------------------------------------------------------------------------------
					.orig x3800

ST R0, Backup_R0_3800
ST R1, Backup_R1_3800
ST R3, Backup_R3_3800
ST R4, Backup_R4_3800
ST R7, Backup_R7_3800		
			
;R2 hold address
INPUT_LOOP
	GETC
	OUT
	LD R1, newline_DEC
	ADD R1, R1, R0
	BRz END_INPUT_LOOP
	STR R0, R2, #0
	ADD R2, R2, #1
	BR INPUT_LOOP
END_INPUT_LOOP

LD R0, Backup_R0_3800
LD R1, Backup_R1_3800
LD R3, Backup_R3_3800
LD R4, Backup_R4_3800
LD R7, Backup_R7_3800
				 
					ret
;-----------------------------------------------------------------------------------------------
; SUB_GET_STRING local data
newline_DEC			.FILL #-10
Backup_R0_3800		.BLKW	#1
Backup_R1_3800		.BLKW	#1
Backup_R3_3800		.BLKW	#1
Backup_R4_3800		.BLKW	#1
Backup_R7_3800		.BLKW	#1
;===============================================================================================


;-----------------------------------------------------------------------------------------------
; REMOTE DATA
					.ORIG x4000			; list opcodes as numbers from #0 through #15, e.g. .fill #12 or .fill xC
.fill		#1
.fill		#5
.fill		#0
.fill		#-4
.fill		#4
.fill		#4
.fill		#2
.fill		#-6
.fill		#6
.fill		#-2
.fill		#-7
.fill		#-4
.fill		#-8
.fill		#3
.fill		#-5
.fill		#7
.fill		#-1


					.ORIG x4100			; list AL instructions as null-terminated character strings, e.g. .stringz "JMP"
								 		; - be sure to follow same order in opcode & instruction arrays!
.stringz	"ADD"
.stringz	"AND"
.stringz	"BR"
.stringz	"JMP"
.stringz	"JSR"
.stringz	"JSRR"
.stringz	"LD"
.stringz	"LDI"
.stringz	"LDR"
.stringz	"LEA"
.stringz	"NOT"
.stringz	"RET"
.stringz	"RTI"
.stringz	"ST"
.stringz	"STI"
.stringz	"STR"
.stringz	"TRAP"
.fill		#-1

;===============================================================================================
