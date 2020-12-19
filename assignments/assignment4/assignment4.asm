

;=================================================================================
;THE BINARY REPRESENTATION OF THE USER-ENTERED DECIMAL NUMBER MUST BE STORED IN R5
;=================================================================================

					.ORIG x3000		
;-------------
;Instructions
;-------------
FIRST_INPUT
; output intro prompt
LD R0, introPromptPtr
PUTS
						
; Set up flags, counters, accumulators as needed
LD R1, counter5	;R1 holds counter
AND R2, R2, #0	;R2 is the negative flag. 0 is positive, 1 if negative
AND R3, R3, #0	;input checking register
AND R5, R5, #0	;R5 is accumulator


; Get first character, test for '\n', '+', '-', digit/non-digit 
GETC
OUT					
					; is very first character = '\n'? if so, just quit (no message)!
LD R3, newline_DEC
ADD R3, R3, R0
BRnp SKIP_NEWLINE
BR END_PROGRAM
SKIP_NEWLINE
					; is it = '+'? if so, ignore it, go get digits
LD R3, pos_sign_DEC
ADD R3, R3, R0
BRz INPUT_LOOP
					; is it = '-'? if so, set neg flag, go get digits
LD R3, neg_sign_DEC
ADD R3, R3, R0
BRnp SKIP_NEGATIVE
ADD R2, R2, #1	;negative flag is "on"
BR INPUT_LOOP
SKIP_NEGATIVE
					; is it < '0'? if so, it is not a digit	- o/p error message, start over
LD R3, ascii_zero
ADD R3, R3, R0
BRzp SKIP_ZERO_INPUT
LD R0, errorMessagePtr
PUTS
BR FIRST_INPUT
SKIP_ZERO_INPUT
					; is it > '9'? if so, it is not a digit	- o/p error message, start over
LD R3, ascii_nine
ADD R3, R3, R0
BRnz SKIP_NINE_INPUT
LD R0, errorMessagePtr
PUTS
BR FIRST_INPUT
SKIP_NINE_INPUT	
				    ; if none of the above, first character is first numeric digit - convert it to number & store in target register!
ADD R1, R1, #-1	;reduce counter by 1 because first char was a number
LD R3, ascii_to_decimal
ADD R3, R3, R0
ADD R5, R5, R3
			
			
					
; Now get remaining digits from user in a loop (max 5), testing each to see if it is a digit, and build up number in accumulator
INPUT_LOOP
	GETC
	OUT
						;check newline
	LD R3, newline_DEC
	ADD R3, R3, R0
	BRnp SKIP_NEWLINE2
	BR END_INPUT_LOOP			;IS THIS CORRECT????????
	SKIP_NEWLINE2
						;check valid input
	LD R3, ascii_zero
	ADD R3, R3, R0
	BRzp SKIP_ZERO_INPUT2
	LD R0, errorMessagePtr
	PUTS
	BR FIRST_INPUT
	SKIP_ZERO_INPUT2
	
	LD R3, ascii_nine
	ADD R3, R3, R0
	BRnz SKIP_NINE_INPUT2
	LD R0, errorMessagePtr
	PUTS
	BR FIRST_INPUT
	SKIP_NINE_INPUT2
						;valid input confirmed. take in value
	AND R4, R4, #0
	ADD R4, R4, R5 ;holds value of R5
	LD R3, counter9
	MULTIPLY_BY_TEN_LOOP 
		ADD R5, R5, R4
		ADD R3, R3, #-1
		BRp MULTIPLY_BY_TEN_LOOP
	END_MULTIPLY_BY_TEN_LOOP
	LD R3, ascii_to_decimal
	ADD R3, R3, R0
	ADD R5, R5, R3
	ADD R1, R1, #-1
	BRp INPUT_LOOP
END_INPUT_LOOP

					;checking negative flag
ADD R2, R2, #0 ;LMR
BRnz SKIP_NEGATIVE_FLAG
NOT R5, R5
ADD R5, R5, #1
SKIP_NEGATIVE_FLAG
					; remember to end with a newline!
ADD R0, R0, #-10
BRz	END_PROGRAM
LD R0, newline
OUT	
END_PROGRAM

					HALT

;---------------	
; Program Data
;---------------

introPromptPtr		.FILL xB000
errorMessagePtr		.FILL xB200
counter5			.FILL #5
counter9			.FILL #9
newline_DEC			.FILL #-10
pos_sign_DEC		.FILL #-43
neg_sign_DEC		.FILL #-45
ascii_zero			.FILL #-48
ascii_nine			.FILL #-57
ascii_to_decimal	.FILL #-48
newline				.FILL '\n'
negative_flag		.FILL #1

tester				.STRINGZ "Hello"

;------------
; Remote data
;------------
					.ORIG xB000			; intro prompt
					.STRINGZ	"Input a positive or negative decimal number (max 5 digits), followed by ENTER\n"
					
					
					.ORIG xB200			; error message
					.STRINGZ	"\nERROR: invalid input\n"

;---------------
; END of PROGRAM
;---------------
					.END

;-------------------
; PURPOSE of PROGRAM
;-------------------
; Convert a sequence of up to 5 user-entered ascii numeric digits into a 16-bit two's complement binary representation of the number.
; if the input sequence is less than 5 digits, it will be user-terminated with a newline (ENTER).
; Otherwise, the program will emit its own newline after 5 input digits.
; The program must end with a *single* newline, entered either by the user (< 5 digits), or by the program (5 digits)
; Input validation is performed on the individual characters as they are input, but not on the magnitude of the number.
