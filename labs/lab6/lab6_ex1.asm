
.ORIG x3000

LD R1, ARRAY_PTR ;load pointer to array
AND R2, R2, #0
ADD R2, R2, #1 ;2^0 = 1

ADD R3, R3, #10 ;counter
WHILE_LOOP
	STR R2, R1, #0 ;stores value into array
	ADD R1, R1, #1 ;go to next mem index in array
	ADD R2, R2, R2 ;add R2 to itself aka multiply by 2
	ADD R3, R3, #-1 ; decrement ptr
	BRp WHILE_LOOP

LD R1, ARRAY_PTR
AND R3, R3, #0
ADD R3, R3, #10 ;counter
WHILE_LOOP2
	AND R6, R6, #0
	ADD R6, R1, #0
	LD R5, SUB_OUTPUT_BINARY
	JSRR R5
	ADD R1, R1, #1 ;go to next index in array
	ADD R3, R3, #-1 ;decrement counter
	BRp WHILE_LOOP2

HALT

ARRAY_PTR	.FILL	x4000
SUB_OUTPUT_BINARY	.FILL	x3200

.ORIG x4000
.BLKW	#10

;------------------------------------------------------------------------
; Subroutine: SUB_OUTPUT_BINARY
; Parameter (R6): The address of the value
; Postcondition: Takes in the address of a value and outputs it
; in binary representation.
; Return Value : None
;-------------------------------------------------------------------------
.ORIG x3200
; (1) backup affected registers:
	ST R0, Backup_R0_3200
	ST R1, Backup_R1_3200
    ST R2, Backup_R2_3200
    ST R3, Backup_R3_3200
    ST R4, Backup_R4_3200
    ST R7, Backup_R7_3200

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
	LD R0, Backup_R0_3200
	LD R1, Backup_R1_3200
	LD R2, Backup_R2_3200
    LD R3, Backup_R3_3200
    LD R4, Backup_R4_3200
    LD R7, Backup_R7_3200
; (4) Return:
    RET

;local data backups for subroutine
Backup_R0_3200	.BLKW	#1
Backup_R1_3200	.BLKW	#1
Backup_R2_3200	.BLKW	#1
Backup_R3_3200	.BLKW	#1
Backup_R4_3200	.BLKW	#1
Backup_R7_3200	.BLKW	#1
SPACE_ASCII	.FILL	' ' ;space ascii char
newline	.FILL	'\n' ;newline ascii char


;END OF SUB_OUTPUT_BINARY


.END
