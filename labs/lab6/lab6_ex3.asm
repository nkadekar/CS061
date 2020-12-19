
.ORIG x3000

AND R2, R2, #0
LD R6, SUB_TRANSLATE_BINARY
JSRR R6

LD R6, STORAGE_PTR
STR R2, R6, #0

LD R0, newline2
OUT

LD R5, SUB_OUTPUT_BINARY
JSRR R5

HALT

;Local Data
SUB_TRANSLATE_BINARY	.FILL	x3200
SUB_OUTPUT_BINARY	.FILL	x3400
STORAGE_PTR	.FILL	x4000
newline2 .FILL	'\n' ;newline ascii char

.ORIG x4000
.BLKW	#1

;------------------------------------------------------------------------
; Subroutine: SUB_TRANSLATE_BINARY
; Parameter : None
; Postcondition: Takes in a 16 bit binary value in ascii preceded by the
; char 'b' from user and translates it into a 16 bit actual binary value.
; Return Value (R2): Single 16-bit value in R2
;-------------------------------------------------------------------------
.ORIG x3200
; (1) backup affected registers:
	ST R0, Backup_R0_3200
	ST R1, Backup_R1_3200
	ST R3, Backup_R3_3200
	ST R4, Backup_R4_3200
    ST R7, Backup_R7_3200

; (2) subroutine algorithm:
LEA R0, StartMes
PUTS

LD R0, newline3
OUT

RESTART
AND R2, R2, #0
LD R1, DEC_16 ;counter

LD R3, DEC_98 ;ascii value of 'b'
NOT R3, R3
ADD R3, R3, #1 ;R3 is now -98

GETC ;takes in the first char
OUT
ADD R0, R0, R3 ;first char must be a 'b'
BRz SKIP
	LEA R0, ErrMess1
	PUTS
	LD R0, newline3
	OUT
	BR RESTART
SKIP

SUB_TRANSLATE_BINARY_WHILE_LOOP
	RESTART_ITERATION
	GETC
	OUT
	LD R3, DEC_32 ;ascii value of ' '
	NOT R3, R3
	ADD R3, R3, #1 ;R3 is now -32
	ADD R0, R0, R3
	BRnp SKIP2
		BR RESTART_ITERATION
	SKIP2
	
	ADD R0, R0, #-12 ;change from ascii to decimal
	ADD R0, R0, #-4
	
	BRnp SKIP3 ;check if num is '0'. If not zero don't multiply R2 yet
		ADD R2, R2, R2 ;multiply R2 by 2 for IF NUM IS '0'
		BR END_IF
		SKIP3
		ADD R0, R0, #-1 ;check if num is '1'
		BRnp ERROR ;if not '1' skip to error messaging
			ADD R2, R2, R2 ;multiply R2 by 2 for IF NUM IS '1'
			ADD R2, R2, #1 ;add the '1'
			BR END_IF
			
			ERROR:
				LEA R0, ErrMess2
				PUTS
				LD R0, newline3
				OUT
				BR RESTART_ITERATION
			END_ERROR
			
	END_IF
	
	ADD R1, R1, #-1 ;LMR
	BRp SUB_TRANSLATE_BINARY_WHILE_LOOP
END_SUB_TRANSLATE_BINARY_WHILE_LOOP
		
; (3) restore backed up registers
	LD R0, Backup_R0_3200
	LD R1, Backup_R1_3200
	LD R3, Backup_R3_3200
	LD R4, Backup_R4_3200
    LD R7, Backup_R7_3200
; (4) Return:
    RET

;local data backups for subroutine
Backup_R0_3200	.BLKW	#1
Backup_R1_3200	.BLKW	#1
Backup_R3_3200	.BLKW	#1
Backup_R4_3200	.BLKW	#1
Backup_R7_3200	.BLKW	#1
DEC_16	.FILL	#16
DEC_98	.FILL	#98
DEC_32	.FILL	#32
StartMes	.STRINGZ	"Enter a 16 bit binary number starting with 'b'"
ErrMess1	.STRINGZ	"Please enter a 'b' before the numbers."
ErrMess2	.STRINGZ	"Please enter a valid character."
newline3	.FILL	'\n' ;newline ascii char

;END OF SUB_TRANSLATE_BINARY


;------------------------------------------------------------------------
; Subroutine: SUB_OUTPUT_BINARY
; Parameter (R6): The address of the value
; Postcondition: Takes in the address of a value and outputs it
; in binary representation.
; Return Value : None
;-------------------------------------------------------------------------
.ORIG x3400
; (1) backup affected registers:
	ST R0, Backup_R0_3400
	ST R1, Backup_R1_3400
    ST R2, Backup_R2_3400
    ST R3, Backup_R3_3400
    ST R4, Backup_R4_3400
    ST R7, Backup_R7_3400

; (2) subroutine algorithm:
LDR R1, R6, #0 ; R1 <-- value to be displayed as binary 
AND R2, R2, #0
AND R3, R3, #0
AND R4, R4, #0
ADD R2, R2, #4 ;counter for outputting spaces
ADD R3, R3, #4 ;
ADD R4, R4, #3 ;counter to deal with space problem at the end

ADD R3, R3, #0 ;LMR
BINARY_LOOP
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
		
	ADD R2, R2, #-1 ;decrement count and LMR
	BRz SPACE
		BR END_SPACE_IF 
		SPACE: ;add space every 4 numbers
		
			ADD R4, R4, #0 ;LMR
			BRz LAST_SET
				NOT_LAST_SET:
					LD R0, SPACE_ASCII
					OUT
					BR END_LAST_SET
				LAST_SET:
			END_LAST_SET
			
			ADD R2, R2, #4
			ADD R3, R3, #-1
			ADD R4, R4, #-1
	END_SPACE_IF
	
	ADD R1, R1, R1 ;shift over binary values to the left
	ADD R3, R3, #0 ;LMR
	BRp BINARY_LOOP
END_BINARY_LOOP

LD R0, newline
OUT

; (3) restore backed up registers
	LD R0, Backup_R0_3400
	LD R1, Backup_R1_3400
	LD R2, Backup_R2_3400
    LD R3, Backup_R3_3400
    LD R4, Backup_R4_3400
    LD R7, Backup_R7_3400
; (4) Return:
    RET

;local data backups for subroutine
Backup_R0_3400	.BLKW	#1
Backup_R1_3400	.BLKW	#1
Backup_R2_3400	.BLKW	#1
Backup_R3_3400	.BLKW	#1
Backup_R4_3400	.BLKW	#1
Backup_R7_3400	.BLKW	#1
SPACE_ASCII	.FILL	' ' ;space ascii char
newline	.FILL	'\n' ;newline ascii char

;END OF SUB_OUTPUT_BINARY


.END
