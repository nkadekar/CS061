
; test harness
					.orig x3000
	
LD R4, Stack_BASE
LD R5, Stack_MAX
LD R6, Stack_BASE

LEA R0, prompt1
PUTS		 
GETC
OUT
ADD R0, R0, #-12
ADD R0, R0, #-12
ADD R0, R0, #-12
ADD R0, R0, #-12
LD R2, SUB_STACK_PUSH
JSRR R2

LD R0, newline
OUT	
LEA R0, prompt1
PUTS
GETC
OUT
ADD R0, R0, #-12
ADD R0, R0, #-12
ADD R0, R0, #-12
ADD R0, R0, #-12
LD R2, SUB_STACK_PUSH
JSRR R2

LD R0, newline
OUT	
LEA R0, prompt2
PUTS
GETC
OUT
LD R2, SUB_RPN_MULTIPLY
JSRR R2

LD R0, newline
OUT	
LD R2, SUB_STACK_POP
JSRR R2
ADD R5, R0, #0
LD R2, SUB_PRINT_DECIMAL
JSRR R2

LD R0, newline
OUT
				 
					halt
;-----------------------------------------------------------------------------------------------
; test harness local data:
Stack_BASE			.FILL	xA000
Stack_MAX			.FILL	xA005
Counter6			.FILL	#6
prompt1				.STRINGZ	"Input a number\n"
prompt2				.STRINGZ	"Input Multiplication Sign\n"
newline				.FILL	'\n'

SUB_STACK_PUSH		.FILL	x3200
SUB_STACK_POP		.FILL	x3400
SUB_RPN_MULTIPLY	.FILL	x3600
SUB_PRINT_DECIMAL	.FILL	x3800

.orig xA001
.BLKW #5

;===============================================================================================


; subroutines:

;------------------------------------------------------------------------------------------
; Subroutine: SUB_STACK_PUSH
; Parameter (R0): The value to push onto the stack
; Parameter (R4): BASE: A pointer to the base (one less than the lowest available
;                       address) of the stack
; Parameter (R5): MAX: The "highest" available address in the stack
; Parameter (R6): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has pushed (R0) onto the stack (i.e to address TOS+1). 
;		    If the stack was already full (TOS = MAX), the subroutine has printed an
;		    overflow error message and terminated.
; Return Value: R6 ← updated TOS
;------------------------------------------------------------------------------------------
					.orig x3200
				 
ST R0, Backup_R0_3200
ST R1, Backup_R1_3200
ST R2, Backup_R2_3200
ST R3, Backup_R3_3200
ST R7, Backup_R7_3200

ADD R1, R5, #0	;Max val now copied to R1
NOT R1, R1
ADD R1, R1, #1

ADD R1, R1, R6	;TOS - MAX
BRz OVERFLOW
ADD R6, R6, #1	;Return value: Updated TOS
STR R0, R6, #0
BR END_SUB_STACK_PUSH

OVERFLOW
	LEA R0, Overflow_message
	PUTS
END_OVERFLOW

END_SUB_STACK_PUSH

LD R0, Backup_R0_3200
LD R1, Backup_R1_3200
LD R2, Backup_R2_3200
LD R3, Backup_R3_3200
LD R7, Backup_R7_3200		  
				 
					ret
;-----------------------------------------------------------------------------------------------
; SUB_STACK_PUSH local data
Overflow_message	.STRINGZ	"Stack overflow error. No Space available in the stack."

Backup_R0_3200		.BLKW   #1
Backup_R1_3200		.BLKW   #1
Backup_R2_3200		.BLKW   #1
Backup_R3_3200		.BLKW   #1
Backup_R7_3200		.BLKW   #1

;===============================================================================================


;------------------------------------------------------------------------------------------
; Subroutine: SUB_STACK_POP
; Parameter (R4): BASE: A pointer to the base (one less than the lowest available                      
;                       address) of the stack
; Parameter (R5): MAX: The "highest" available address in the stack
; Parameter (R6): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has popped MEM[TOS] off of the stack.
;		    If the stack was already empty (TOS = BASE), the subroutine has printed
;                an underflow error message and terminated.
; Return Value: R0 ← value popped off the stack
;		   R6 ← updated TOS
;------------------------------------------------------------------------------------------
					.orig x3400
				 
ST R1, Backup_R1_3400
ST R2, Backup_R2_3400
ST R3, Backup_R3_3400
ST R7, Backup_R7_3400

ADD R1, R4, #0	;Max val now copied to R1
NOT R1, R1
ADD R1, R1, #1

ADD R1, R1, R6	;TOS - MAX
BRz UNDERFLOW
LDR R0, R6, #0	;Return value: R0
ADD R6, R6, #-1	;Return value: Updated TOS
BR END_SUB_STACK_POP

UNDERFLOW
	LEA R0, Underflow_message
	PUTS
	AND R0, R0, #0
END_UNDERFLOW

END_SUB_STACK_POP

LD R1, Backup_R1_3400
LD R2, Backup_R2_3400
LD R3, Backup_R3_3400
LD R7, Backup_R7_3400					 
				  
					ret
;-----------------------------------------------------------------------------------------------
; SUB_STACK_POP local data
Underflow_message	.STRINGZ	"Stack Underflow error. Stack is already Empty."

Backup_R1_3400		.BLKW   #1
Backup_R2_3400		.BLKW   #1
Backup_R3_3400		.BLKW   #1
Backup_R7_3400		.BLKW   #1

;===============================================================================================

;------------------------------------------------------------------------------------------
; Subroutine: SUB_RPN_MULTIPLY
; Parameter (R4): BASE: A pointer to the base (one less than the lowest available
;                       address) of the stack
; Parameter (R5): MAX: The "highest" available address in the stack
; Parameter (R6): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has popped off the top two values of the stack,
;		    multiplied them together, and pushed the resulting value back
;		    onto the stack.
; Return Value: R6 ← updated TOS address
;------------------------------------------------------------------------------------------
					.orig x3600

ST R0, Backup_R0_3600
ST R1, Backup_R1_3600
ST R2, Backup_R2_3600
ST R3, Backup_R3_3600
ST R7, Backup_R7_3600
				 
LD R2, SUB_STACK_POP2
JSRR R2
ADD R1, R0, #0

LD R2, SUB_STACK_POP2
JSRR R2
ADD R3, R0, #0

AND R2, R2, #0
ADD R3, R3, #0	;lmr
MULT_LOOP
	ADD R2, R2, R1
	ADD R3, R3, #-1
	BRp MULT_LOOP
END_MULT_LOOP

ADD R0, R2, #0
LD R2, SUB_STACK_PUSH2
JSRR R2
				 
LD R0, Backup_R0_3600
LD R1, Backup_R1_3600
LD R2, Backup_R2_3600
LD R3, Backup_R3_3600
LD R7, Backup_R7_3600	
		 
					ret
;-----------------------------------------------------------------------------------------------
; SUB_RPN_MULTIPLY local data
SUB_STACK_PUSH2		.FILL	x3200
SUB_STACK_POP2		.FILL	x3400

Backup_R0_3600		.BLKW   #1
Backup_R1_3600		.BLKW   #1
Backup_R2_3600		.BLKW   #1
Backup_R3_3600		.BLKW   #1
Backup_R7_3600		.BLKW   #1

;===============================================================================================

;------------------------------------------------------------------------
; Subroutine: SUB_PRINT_DECIMAL
; Parameters: R5 containing the hard coded value
; Postcondition: Print the new value to the console as decimal number
; Return Value: NONE
;------------------------------------------------------------------------
.ORIG x3800
; (1) backup affected registers:
    ST R0, Backup_R0_3800
    ST R1, Backup_R1_3800
    ST R2, Backup_R2_3800
    ST R3, Backup_R3_3800
    ST R7, Backup_R7_3800
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

AND R2, R2, #0
TEN_LOOP
	LD R3, DEC_10	;Subtract 10 and check if its negative
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
    LD R0, Backup_R0_3800
    LD R1, Backup_R1_3800
    LD R2, Backup_R2_3800
    LD R3, Backup_R3_3800
    LD R7, Backup_R7_3800

; (4) Return:
    RET

;------------------------------------------------------------------------
; SUB_PRINT_DEC local data
Backup_R0_3800      .BLKW   #1
Backup_R1_3800      .BLKW   #1
Backup_R2_3800      .BLKW   #1
Backup_R3_3800      .BLKW   #1
Backup_R7_3800      .BLKW   #1

NegativeSign		.FILL	'-'
DEC_10				.FILL	#-10
DEC_48				.FILL	#48

;========================================================================

.END
