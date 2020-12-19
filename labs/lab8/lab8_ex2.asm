
.ORIG x3000

AND R5, R5, #0

GETC
OUT

ADD R5, R5, R0

LD R6, SUB_OUTPUT_ONES
JSRR R6

LD R0, Newline
OUT

LEA R0, Message
PUTS

AND R0, R0, #0
ADD R0, R0, R5
OUT

LEA R0, Message2
PUTS

LD R0, DEC_48
ADD R0, R0, R4
OUT

LD R0, Newline
OUT

HALT

; Test Harness Local Data
SUB_OUTPUT_ONES		.FILL		x3200
Message				.STRINGZ	"The number of 1's in '"
Message2			.STRINGZ	"' is: "
DEC_48				.FILL		#48
Newline				.FILL		'\n'
;========================================================================

;-------------------------------------------------------------------------
; Subroutine: SUB_OUTPUT_ONES
; Parameters: R5
; Postcondition: Take value in R5 and store number of 1's in R4
; Return Value: R4
;-------------------------------------------------------------------------
.ORIG x3200
; (1) backup affected registers:
    ST R0, Backup_R0_3200
    ST R1, Backup_R1_3200
    ST R2, Backup_R2_3200
    ST R3, Backup_R3_3200
    ST R7, Backup_R7_3200
    
; (2) subroutine algorithm:
AND R4, R4, #0
AND R2, R2, #0
ADD R2, R2, R5
LD R1, DEC_16	;counter for loop

LOOP
	ADD R2, R2, #0
	BRzp NOT_NEGATIVE
		ADD R4, R4, #1
	NOT_NEGATIVE
	ADD R2, R2, R2
	ADD R1, R1, #-1
	BRp LOOP
END_LOOP 

; (3) restore backed up registers
    LD R0, Backup_R0_3200
    LD R1, Backup_R1_3200
    LD R2, Backup_R2_3200
    LD R3, Backup_R3_3200
    LD R7, Backup_R7_3200

; (4) Return:
    RET

;------------------------------------------------------------------------
; SUB_PRINT_DEC local data
Backup_R0_3200      .BLKW   #1
Backup_R1_3200      .BLKW   #1
Backup_R2_3200      .BLKW   #1
Backup_R3_3200      .BLKW   #1
Backup_R7_3200      .BLKW   #1
DEC_16				.FILL	#16
;========================================================================

.END
