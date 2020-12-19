
.ORIG x3000

LD R1, ARRAY_PTR

LD R5, SUB_GET_STRING
JSRR R5

AND R0, R0, #0
LD R0, ARRAY_PTR
PUTS

HALT

;Local Data
ARRAY_PTR	.FILL	x4000
SUB_GET_STRING	.FILL	x3200 ;address of subroutine

.ORIG x4000
ARRAY	.BLKW	#100

;------------------------------------------------------------------------
; Subroutine: SUB_GET_STRING
; Parameter (R1): The starting address of the character array
; Postcondition: The subroutine has prompted the user to input a string,
;terminated by the [ENTER] key (the "sentinel"), and has stored
;the received characters in an array of characters starting at (R1).
;the array is NULL-terminated; the sentinel character is NOT stored.
; Return Value (R5): The number of ​ non-sentinel​ chars read from the user.
;R1 contains the starting address of the array unchanged.
;-------------------------------------------------------------------------
.ORIG x3200
; (1) backup affected registers:
    ST R0, Backup_R0_3200
    ST R2, Backup_R2_3200
    ST R6, Backup_R6_3200
    ST R7, Backup_R7_3200
; (2) subroutine algorithm:

ADD R6, R1, #0 ;value of parameter stored in R1
AND R5, R5, #0 ;tracks size of array and is returned

WHILE_LOOP
	GETC ;cin
	OUT
	ADD R2, R0, #-10 ;check if its a '\n'
	BRz END_LOOP
	STR R0, R6, #0 ;store in array
	ADD R6, R6, #1 ;iterate to next value in the array
	ADD R5, R5, #1 ;size of array increment
BR WHILE_LOOP
END_LOOP

AND R0, R0, #0
STR R0, R6, #0 ;null terminate here

; (3) restore backed up registers
	LD R0, Backup_R0_3200
    LD R2, Backup_R2_3200
    ST R6, Backup_R6_3200
    LD R7, Backup_R7_3200
; (4) Return:
    RET

;local data backups for subroutine
Backup_R0_3200	.BLKW	#1
Backup_R2_3200	.BLKW	#1
Backup_R6_3200	.BLKW	#1
Backup_R7_3200	.BLKW	#1

;END OF SUB_GET_STRING


.END
