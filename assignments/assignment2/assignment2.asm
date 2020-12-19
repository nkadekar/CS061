

.ORIG x3000			; Program begins here
;-------------
;Instructions
;-------------

;----------------------------------------------
;output prompt
;----------------------------------------------	
LEA R0, intro			; get starting address of prompt string
PUTS			    	; Invokes BIOS routine to output string

;-------------------------------
;INSERT YOUR CODE here
;--------------------------------
AND R3, R3, #0

GETC ;get first num
OUT
ADD R1, R0, #0 ;store num1 in R1

LD R0, newline 
OUT

GETC ;get second num
OUT
ADD R2, R0, #0 ;store num2 in R2

LD R0, newline
OUT

ADD R0, R1, #0 ;display num1
OUT

LEA R0, dash1 ;display " - "
PUTS

ADD R0, R2, #0 ;display num2
OUT

LEA R0, equal ;display " = "
PUTS

ADD R3, R3, #4 ;counter
WHILE_LOOP ;loop to change num1 and num2 to two's complement
	ADD R1, R1, #-12
	ADD R2, R2, #-12
	ADD R3, R3, #-1
	BRp WHILE_LOOP
END_WHILE_LOOP

NOT R2, R2 ;change num2 to a negative number for substraction
ADD R2, R2, #1

ADD R4, R1, R2 ;store the result of subtraction in R4
BRzp SKIP ;if R4 is negative, it goes into the block, if not it Skips
	NOT R4, R4
	ADD R4, R4, #1
	LEA R0, dash2
	PUTS
SKIP

ADD R3, R3, #4 ;counter
WHILE_LOOP2 ;loop to convert back to decimal
	ADD R4, R4, #12
	ADD R3, R3, #-1
	BRp WHILE_LOOP2
END_WHILE_LOOP2

ADD R0, R4, #0 ;store R4 into R0 to display
OUT

LD R0, newline ;newline to terminate
OUT


HALT				; Stop execution of program
;------	
;Data
;------
; String to prompt user. Note: already includes terminating newline!
intro 	.STRINGZ	"ENTER two numbers (i.e '0'....'9')\n" 		; prompt string - use with LEA, followed by PUTS.
newline .FILL '\n'	; newline character - use with LD followed by OUT
dash1	.STRINGZ	" - "
equal	.STRINGZ	" = "
dash2	.STRINGZ	"-"

;---------------	
;END of PROGRAM
;---------------	
.END

