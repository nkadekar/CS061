
; test harness
					.orig x3000
AND R0, R0, #0	;Holds value being pushed
LD R4, Stack_BASE
LD R5, Stack_MAX
LD R6, Stack_BASE

LD R1, Counter7
TEST_LOOP
	ADD R0, R0, #1
	LD R2, SUB_STACK_PUSH
	JSRR R2
	ADD R1, R1, #-1
	BRp TEST_LOOP
END_TEST_LOOP

LD R1, Counter9
TEST_LOOP2
	LD R2, SUB_STACK_POP
	JSRR R2
	ADD R0, R0, #12
	ADD R0, R0, #12
	ADD R0, R0, #12
	ADD R0, R0, #12
	OUT
	ADD R1, R1, #-1
	BRp TEST_LOOP2
END_TEST_LOOP2				 
				 
					halt
;-----------------------------------------------------------------------------------------------
; test harness local data:
Stack_BASE		.FILL	xA000
Stack_MAX		.FILL	xA005
Counter7		.FILL	#7
Counter9		.FILL	#9
SUB_STACK_PUSH	.FILL	x3200
SUB_STACK_POP	.FILL	x3400

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

.END
