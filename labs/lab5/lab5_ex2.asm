
.ORIG x3000

LD R1, ARRAY_PTR

LD R5, SUB_GET_STRING
JSRR R5

LD R4, SUB_IS_PALINDROME
JSRR R4

LEA R0, String1
PUTS

LD R0, Quote
OUT

LD R0, ARRAY_PTR
PUTS

LD R0, Quote
OUT

LEA R0, String2
PUTS

ADD R4, R4, #0
Brp PAL
LEA R0, String3
PUTS

PAL:
LEA R0, String4
PUTS

HALT

;Local Data
ARRAY_PTR	.FILL	x4000
SUB_GET_STRING	.FILL	x3200 ;address of subroutine1
SUB_IS_PALINDROME	.FILL	x3400 ;address of subroutine2
String1	.STRINGZ	"The string "
String2	.STRINGZ	" IS "
String3	.STRINGZ	"NOT "
String4	.STRINGZ	"a palindrome"
Quote	.FILL	'"'

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
    LD R6, Backup_R6_3200
    LD R7, Backup_R7_3200
; (4) Return:
    RET

;local data backups for subroutine
Backup_R0_3200	.BLKW	#1
Backup_R2_3200	.BLKW	#1
Backup_R6_3200	.BLKW	#1
Backup_R7_3200	.BLKW	#1

;END OF SUB_GET_STRING


;-------------------------------------------------------------------------
; Subroutine: SUB_IS_PALINDROME
; Parameter (R1): The starting address of a null-terminated string
; Parameter (R5): The number of characters in the array.
; Postcondition: The subroutine has determined whether the string at (R1)
; is a palindrome or not, and returned a flag to that effect.
; Return Value: R4 {1 if the string is a palindrome, 0 otherwise}
;-------------------------------------------------------------------------
.ORIG x3400
; (1) backup affected registers:
    ST R0, Backup_R0_3400
    ST R2, Backup_R2_3400
    ST R3, Backup_R3_3400
    ST R6, Backup_R6_3400
    ST R7, Backup_R7_3400
; (2) subroutine algorithm:
ADD R2, R1, #0 ;stores array in R2
AND R3, R3, #0 ;used for checking if 2 ascii are same
AND R4, R4, #0 ;return register
ADD R0, R5, #-1 ;stores difference. used to find corresponding letter on other side of string

BRn END_ALL

LOOP
LDR R6, R2, #0 ;gets left side letter
ADD R3, R6, #0 ;stores letter in R3
ADD R2, R2, R0 ;iterates to right side letter
LDR R6, R2, #0 ;gets right side letter
NOT R6, R6
ADD R6, R6, #1
ADD R3, R3, R6
BRnp END_ALL ;this means it is not a palindrome
NOT R0, R0
ADD R0, R0, #1 ;change R0 to negative
ADD R2, R2, R0 ;R2 = R2 - R0 revert R2 back to left side letter
ADD R2, R2, #1 ;increments R2
NOT R0, R0
ADD R0, R0, #1 ;change R0 to positive
ADD R0, R0, #-2 ;subtract 2 from R0. difference decreases by 2
BRnz TRUE
BR LOOP

TRUE:
	ADD R4, R4, #1
	
END_ALL
; (3) restore backed up registers
	LD R0, Backup_R0_3400
    LD R2, Backup_R2_3400
    LD R3, Backup_R3_3400
    LD R6, Backup_R6_3400
    LD R7, Backup_R7_3400
; (4) Return:
    RET

;local data backups for subroutine
Backup_R0_3400	.BLKW	#1
Backup_R2_3400	.BLKW	#1
Backup_R3_3400	.BLKW	#1
Backup_R6_3400	.BLKW	#1
Backup_R7_3400	.BLKW	#1

;END OF SUB_IS_PALINDROME

.END
