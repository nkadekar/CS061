

.ORIG x3000			; Program begins here
;-------------
;Instructions
;-------------
LD R6, Value_ptr		; R6 <-- pointer to value to be displayed as binary
LDR R1, R6, #0			; R1 <-- value to be displayed as binary 
;-------------------------------
;INSERT CODE STARTING FROM HERE
;--------------------------------
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

HALT
;---------------	
;Data
;---------------
Value_ptr	.FILL	xCA00	; The address where value to be displayed is stored
SPACE_ASCII	.FILL	' ' ;space ascii char
newline	.FILL	'\n' ;newline ascii char

.ORIG xCA00					; Remote data
Value .FILL xABCD			; <----!!!NUMBER TO BE DISPLAYED AS BINARY!!! Note: label is redundant.
;---------------	
;END of PROGRAM
;---------------	
.END
