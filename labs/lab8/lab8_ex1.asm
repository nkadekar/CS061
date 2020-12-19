
.ORIG x3000

LD R6, SUB_CREATE_FILL
JSRR R6

ADD R5, R5, #1

LD R6, SUB_OUTPUT_DECIMAL
JSRR R6

HALT

; Test Harness Local Data
SUB_CREATE_FILL		.FILL	x3200	
SUB_OUTPUT_DECIMAL	.FILL	x3400
;========================================================================
;-------------------------------------------------------------------------
; Subroutine: SUB_CREATE_FILL
; Parameters: None
; Postcondition: Fill R5 with the hard coded value
; Return Value: R5
;-------------------------------------------------------------------------
.ORIG x3200
; (1) backup affected registers:
    ST R7, Backup_R7_3200
; (2) subroutine algorithm:

    LD R5, VALUE_TO_FILL

; (3) restore backed up registers
    LD R7, Backup_R7_3200

; (4) Return:
    RET
    
;------------------------------------------------------------------------
; SUB_CREATE_FILL local data
Backup_R7_3200   .BLKW    #1
VALUE_TO_FILL    .FILL    #32767
;========================================================================

;------------------------------------------------------------------------
; Subroutine: SUB_OUTPUT_DECIMAL
; Parameters: R5 containing the hard coded value
; Postcondition: Print the new value to the console as decimal number
; Return Value: NONE
;------------------------------------------------------------------------
.ORIG x3400
; (1) backup affected registers:
    ST R0, Backup_R0_3400
    ST R1, Backup_R1_3400
    ST R2, Backup_R2_3400
    ST R3, Backup_R3_3400
    ST R7, Backup_R7_3400
; (2) subroutine algorithm:
AND R0, R0, #0
AND R1, R1, #0
AND R2, R2, #0
AND R3, R3, #0

ADD R1, R5, #0
BRzp NOT_NEGATIVE
	LD R0, NegativeSign
	OUT
	NOT R1, R1
	ADD R1, R1, #1

NOT_NEGATIVE

TEN_K_LOOP
	LD R3, DEC_10K	;Subtract 10k and check if its negative
	ADD R1, R1, R3
	BRn RESET_TEN_K
	ADD R2, R2, #1
	BR TEN_K_LOOP
	
	RESET_TEN_K
	NOT R3, R3
	ADD R3, R3, #1
	ADD R1, R1, R3	;Leaves R1 with remainder before it went negative
	
	AND R0, R0, #0
	ADD R0, R0, R2	;Output digit
	LD R3, DEC_48
	ADD R0, R0, R3
	OUT
	
END_TEN_K_LOOP

AND R2, R2, #0
K_LOOP
	LD R3, DEC_K	;Subtract 10k and check if its negative
	ADD R1, R1, R3
	BRn RESET_K
	ADD R2, R2, #1
	BR K_LOOP
	
	RESET_K
	NOT R3, R3
	ADD R3, R3, #1
	ADD R1, R1, R3	;Leaves R1 with remainder before it went negative
	
	AND R0, R0, #0
	ADD R0, R0, R2	;Output digit
	LD R3, DEC_48
	ADD R0, R0, R3
	OUT
	
END_K_LOOP

AND R2, R2, #0
H_LOOP
	LD R3, DEC_H	;Subtract 10k and check if its negative
	ADD R1, R1, R3
	BRn RESET_H
	ADD R2, R2, #1
	BR H_LOOP
	
	RESET_H
	NOT R3, R3
	ADD R3, R3, #1
	ADD R1, R1, R3	;Leaves R1 with remainder before it went negative
	
	AND R0, R0, #0
	ADD R0, R0, R2	;Output digit
	LD R3, DEC_48
	ADD R0, R0, R3
	OUT
	
END_H_LOOP

AND R2, R2, #0
TEN_LOOP
	LD R3, DEC_10	;Subtract 10k and check if its negative
	ADD R1, R1, R3
	BRn RESET_TEN
	ADD R2, R2, #1
	BR TEN_LOOP
	
	RESET_TEN
	NOT R3, R3
	ADD R3, R3, #1
	ADD R1, R1, R3	;Leaves R1 with remainder before it went negative
	
	AND R0, R0, #0
	ADD R0, R0, R2	;Output digit
	LD R3, DEC_48
	ADD R0, R0, R3
	OUT
	
END_TEN_LOOP

AND R0, R0, #0
ADD R0, R0, R1
LD R3, DEC_48
ADD R0, R0, R3
OUT

; (3) restore backed up registers
    LD R0, Backup_R0_3400
    LD R1, Backup_R1_3400
    LD R2, Backup_R2_3400
    LD R3, Backup_R3_3400
    LD R7, Backup_R7_3400

; (4) Return:
    RET

;------------------------------------------------------------------------
; SUB_PRINT_DEC local data
Backup_R0_3400      .BLKW   #1
Backup_R1_3400      .BLKW   #1
Backup_R2_3400      .BLKW   #1
Backup_R3_3400      .BLKW   #1
Backup_R7_3400      .BLKW   #1
NegativeSign		.FILL	'-'
DEC_10K				.FILL	#-10000
DEC_K				.FILL	#-1000
DEC_H				.FILL	#-100
DEC_10				.FILL	#-10
DEC_48				.FILL	#48

;========================================================================
.END
