

.ORIG x3000			; Program begins here
;-------------
;Instructions
;-------------
;-------------------------------
;INSERT CODE STARTING FROM HERE
;-------------------------------
MAIN_LOOP
	LD R6, SUB_MENU
	JSRR R6
	
	LD R0, newline
	OUT

	AND R2, R2, #0
	ADD R2, R2, R1
	ADD R2, R2, #-1
	BRnp NOT_1
		LD R6, SUB_ALL_MACHINES_BUSY
		JSRR R6
		ADD R2, R2, #0
		BRz SUB_1_FREE
			LEA R0, allbusy
			PUTS
			BR MAIN_LOOP
		SUB_1_FREE
			LEA R0, allnotbusy
			PUTS
	BR MAIN_LOOP
	NOT_1
	
	AND R2, R2, #0
	ADD R2, R2, R1
	ADD R2, R2, #-2
	BRnp NOT_2
		LD R6, SUB_ALL_MACHINES_FREE
		JSRR R6
		ADD R2, R2, #0
		BRz SUB_2_BUSY
			LEA R0, allfree
			PUTS
			BR MAIN_LOOP
		SUB_2_BUSY
			LEA R0, allnotfree
			PUTS
	BR MAIN_LOOP
	NOT_2
	
	AND R2, R2, #0
	ADD R2, R2, R1
	ADD R2, R2, #-3
	BRnp NOT_3
	LD R6, SUB_NUM_BUSY_MACHINES
	JSRR R6
	LEA R0, busymachine1
	PUTS
	LD R6, SUB_PRINT_NUM
	JSRR R6
	LEA R0, busymachine2
	PUTS
	BR MAIN_LOOP
	NOT_3
	
	AND R2, R2, #0
	ADD R2, R2, R1
	ADD R2, R2, #-4
	BRnp NOT_4
	LD R6, SUB_NUM_FREE_MACHINES
	JSRR R6
	LEA R0, freemachine1
	PUTS
	LD R6, SUB_PRINT_NUM
	JSRR R6
	LEA R0, freemachine2
	PUTS
	BR MAIN_LOOP
	NOT_4
	
	AND R2, R2, #0
	ADD R2, R2, R1
	ADD R2, R2, #-5
	BRnp NOT_5
	LD R6, SUB_MACHINE_STATUS
	JSRR R6
	LEA R0, status1
	PUTS
	LD R6, SUB_PRINT_NUM
	JSRR R6
	ADD R2, R2, #0
	BRp SUB_5_FREE
		LEA R0, status2
		PUTS
		BR MAIN_LOOP
	SUB_5_FREE
		LEA R0, status3
		PUTS
	BR MAIN_LOOP
	NOT_5
	
	AND R2, R2, #0
	ADD R2, R2, R1
	ADD R2, R2, #-6
	BRnp NOT_6
	LD R6, SUB_FIRST_FREE
	JSRR R6
	ADD R1, R1, #0
	BRn NONE_AVAIL
		LEA R0, firstfree1
		PUTS
		LD R6, SUB_PRINT_NUM
		JSRR R6
		LD R0, newline
		OUT
		BR MAIN_LOOP
	NONE_AVAIL
		LEA R0, firstfree2
		PUTS
	BR MAIN_LOOP
	NOT_6
END_MAIN_LOOP

LEA R0, goodbye
PUTS

HALT
;---------------	
;Data
;---------------
;Subroutine pointers
SUB_MENU				.FILL	x3200
SUB_ALL_MACHINES_BUSY	.FILL	x3400
SUB_ALL_MACHINES_FREE	.FILL	x3600
SUB_NUM_BUSY_MACHINES	.FILL	x3800
SUB_NUM_FREE_MACHINES	.FILL	x4000
SUB_MACHINE_STATUS		.FILL	x4200
SUB_FIRST_FREE			.FILL	x4400
SUB_PRINT_NUM			.FILL	x4800

;Other data 
newline 		.fill '\n'
DECIMAL_48		.fill x30

; Strings for reports from menu subroutines:
goodbye         .stringz "Goodbye!\n"
allbusy         .stringz "All machines are busy\n"
allnotbusy      .stringz "Not all machines are busy\n"
allfree         .stringz "All machines are free\n"
allnotfree		.stringz "Not all machines are free\n"
busymachine1    .stringz "There are "
busymachine2    .stringz " busy machines\n"
freemachine1    .stringz "There are "
freemachine2    .stringz " free machines\n"
status1         .stringz "Machine "
status2		    .stringz " is busy\n"
status3		    .stringz " is free\n"
firstfree1      .stringz "The first available machine is number "
firstfree2      .stringz "No machines are free\n"

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: MENU
; Inputs: None
; Postcondition: The subroutine has printed out a menu with numerical options, invited the
;                user to select an option, and returned the selected option.
; Return Value (R1): The option selected:  #1, #2, #3, #4, #5, #6 or #7 (as a number, not a character)
;                    no other return value is possible
;-----------------------------------------------------------------------------------------------------------------
.ORIG x3200

ST R0, Backup_R0_3200
ST R2, Backup_R2_3200
ST R3, Backup_R3_3200
ST R7, Backup_R7_3200
;-------------------------------
;INSERT CODE For Subroutine MENU
;--------------------------------
START_SUB_MENU
AND R1, R1, #0
AND R2, R2, #0
AND R3, R3, #0

LD R0, Menu_string_addr
PUTS

GETC
OUT

;validate input > 0
LD R2, dec_neg_48
ADD R2, R2, R0
BRnz SUB_MENU_INVALID_INPUT

;validate input <= 7
LD R3, dec_neg_55
ADD R3, R3, R0
BRp SUB_MENU_INVALID_INPUT

;gets to here if input is valid
ADD R1, R1, R2
BR END_SUB_MENU

SUB_MENU_INVALID_INPUT
	LEA R0, Error_msg_1
	PUTS
	BR START_SUB_MENU
END_SUB_MENU_INVALID_INPUT

END_SUB_MENU

LD R0, Backup_R0_3200
LD R2, Backup_R2_3200
LD R3, Backup_R3_3200
LD R7, Backup_R7_3200

RET
;--------------------------------
;Data for subroutine MENU
;--------------------------------
Error_msg_1			.STRINGZ "\nINVALID INPUT\n"
Menu_string_addr	.FILL x5000
dec_neg_48			.FILL #-48
dec_neg_55			.FILL #-55

Backup_R0_3200		.BLKW   #1
Backup_R2_3200		.BLKW   #1
Backup_R3_3200		.BLKW   #1
Backup_R7_3200		.BLKW   #1

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: ALL_MACHINES_BUSY (#1)
; Inputs: None
; Postcondition: The subroutine has returned a value indicating whether all machines are busy
; Return value (R2): 1 if all machines are busy, 0 otherwise
;-----------------------------------------------------------------------------------------------------------------
.ORIG x3400

ST R3, Backup_R3_3400
ST R4, Backup_R4_3400
ST R7, Backup_R7_3400
;-------------------------------
;INSERT CODE For Subroutine ALL_MACHINES_BUSY
;--------------------------------
AND R2, R2, #0

LD R3, SUB_ALL_MACHINES_BUSY_MASK
LDI R4, BUSYNESS_ADDR_ALL_MACHINES_BUSY
AND R3, R3, R4
BRnp SKIP_ALL_MACHINES_BUSY
	ADD R2, R2, #1

SKIP_ALL_MACHINES_BUSY

LD R3, Backup_R3_3400
LD R4, Backup_R4_3400
LD R7, Backup_R7_3400

RET
;--------------------------------
;Data for subroutine ALL_MACHINES_BUSY
;--------------------------------
BUSYNESS_ADDR_ALL_MACHINES_BUSY .Fill xB400
SUB_ALL_MACHINES_BUSY_MASK		.Fill xFFFF

Backup_R3_3400		.BLKW   #1
Backup_R4_3400		.BLKW   #1
Backup_R7_3400		.BLKW   #1

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: ALL_MACHINES_FREE (#2)
; Inputs: None
; Postcondition: The subroutine has returned a value indicating whether all machines are free
; Return value (R2): 1 if all machines are free, 0 otherwise
;-----------------------------------------------------------------------------------------------------------------
.ORIG x3600

ST R3, Backup_R3_3600
ST R4, Backup_R4_3600
ST R7, Backup_R7_3600
;-------------------------------
;INSERT CODE For Subroutine ALL_MACHINES_FREE
;--------------------------------
AND R2, R2, #0

LD R3, SUB_ALL_MACHINES_FREE_MASK
LDI R4, BUSYNESS_ADDR_ALL_MACHINES_FREE
AND R3, R3, R4
NOT R3, R3
BRnp SKIP_ALL_MACHINES_FREE
	ADD R2, R2, #1

SKIP_ALL_MACHINES_FREE

LD R3, Backup_R3_3600
LD R4, Backup_R4_3600
LD R7, Backup_R7_3600

RET
;--------------------------------
;Data for subroutine ALL_MACHINES_FREE
;--------------------------------
BUSYNESS_ADDR_ALL_MACHINES_FREE .Fill xB400
SUB_ALL_MACHINES_FREE_MASK		.Fill xFFFF

Backup_R3_3600		.BLKW   #1
Backup_R4_3600		.BLKW   #1
Backup_R7_3600		.BLKW   #1

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: NUM_BUSY_MACHINES (#3)
; Inputs: None
; Postcondition: The subroutine has returned the number of busy machines.
; Return Value (R1): The number of machines that are busy (0)
;-----------------------------------------------------------------------------------------------------------------
.ORIG x3800

ST R3, Backup_R3_3800
ST R4, Backup_R4_3800
ST R7, Backup_R7_3800
;-------------------------------
;INSERT CODE For Subroutine NUM_BUSY_MACHINES
;--------------------------------
AND R1, R1, #0

LD R3, SUB_NUM_BUSY_MACHINES_MASK
LDI R4, BUSYNESS_ADDR_NUM_BUSY_MACHINES
AND R3, R3, R4

LD R4, SUB_NUM_BUSY_MACHINES_COUNTER
SUB_NUM_BUSY_MACHINES_LOOP
	ADD R3, R3, #0 ;lmr
	BRn SKIP_NUM_BUSY_MACHINES ;if negative then skip and dont add to R1
	ADD R1, R1, #1
	SKIP_NUM_BUSY_MACHINES
	ADD R3, R3, R3
	ADD R4, R4, #-1
	BRp SUB_NUM_BUSY_MACHINES_LOOP
END_SUB_NUM_BUSY_MACHINES_LOOP

LD R3, Backup_R3_3800
LD R4, Backup_R4_3800
LD R7, Backup_R7_3800

RET
;--------------------------------
;Data for subroutine NUM_BUSY_MACHINES
;--------------------------------
BUSYNESS_ADDR_NUM_BUSY_MACHINES .Fill xB400
SUB_NUM_BUSY_MACHINES_MASK		.Fill xFFFF
SUB_NUM_BUSY_MACHINES_COUNTER	.Fill #16

Backup_R3_3800		.BLKW   #1
Backup_R4_3800		.BLKW   #1
Backup_R7_3800		.BLKW   #1
;-----------------------------------------------------------------------------------------------------------------
; Subroutine: NUM_FREE_MACHINES (#4)
; Inputs: None
; Postcondition: The subroutine has returned the number of free machines
; Return Value (R1): The number of machines that are free (1)
;-----------------------------------------------------------------------------------------------------------------
.ORIG x4000

ST R3, Backup_R3_4000
ST R4, Backup_R4_4000
ST R7, Backup_R7_4000
;-------------------------------
;INSERT CODE For Subroutine NUM_FREE_MACHINES
;--------------------------------
AND R1, R1, #0

LD R3, SUB_NUM_FREE_MACHINES_MASK
LDI R4, BUSYNESS_ADDR_NUM_FREE_MACHINES
AND R3, R3, R4
NOT R3, R3

LD R4, SUB_NUM_FREE_MACHINES_COUNTER
SUB_NUM_FREE_MACHINES_LOOP
	ADD R3, R3, #0 ;lmr
	BRn SKIP_NUM_FREE_MACHINES ;if negative then skip and dont add to R1
	ADD R1, R1, #1
	SKIP_NUM_FREE_MACHINES
	ADD R3, R3, R3
	ADD R4, R4, #-1
	BRp SUB_NUM_FREE_MACHINES_LOOP
END_SUB_NUM_FREE_MACHINES_LOOP

LD R3, Backup_R3_4000
LD R4, Backup_R4_4000
LD R7, Backup_R7_4000

RET
;--------------------------------
;Data for subroutine NUM_FREE_MACHINES 
;--------------------------------
BUSYNESS_ADDR_NUM_FREE_MACHINES .Fill xB400
SUB_NUM_FREE_MACHINES_MASK		.Fill xFFFF
SUB_NUM_FREE_MACHINES_COUNTER	.Fill #16

Backup_R3_4000		.BLKW   #1
Backup_R4_4000		.BLKW   #1
Backup_R7_4000		.BLKW   #1

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: MACHINE_STATUS (#5)
; Input (R1): Which machine to check, guaranteed in range {0,15}
; Postcondition: The subroutine has returned a value indicating whether
;                the selected machine (R1) is busy or not.
; Return Value (R2): 0 if machine (R1) is busy, 1 if it is free
;              (R1) unchanged
;-----------------------------------------------------------------------------------------------------------------
.ORIG x4200

ST R3, Backup_R3_4200
ST R5, Backup_R5_4200
ST R6, Backup_R6_4200
ST R7, Backup_R7_4200
;-------------------------------
;INSERT CODE For Subroutine MACHINE_STATUS
;--------------------------------
AND R2, R2, #0

LD R6, GET_NUM_SUB
JSRR R6

LDI R5, BUSYNESS_ADDR_MACHINE_STATUS

LD R3, neg_fifteen	;15 because registers start at 0
ADD R3, R3, R1
NOT R3, R3
ADD R3, R3, #1	;now R3 has the value of 15 - R1

BRz END_MACHINE_STATUS_LOOP

MACHINE_STATUS_LOOP
	ADD R5, R5, R5
	ADD R3, R3, #-1
	BRp MACHINE_STATUS_LOOP
END_MACHINE_STATUS_LOOP

ADD R5, R5, #0	;lmr
BRzp SKIP_MACHINE_STATUS_LOOP	;if msb not one, skip (busy)
ADD R2, R2, #1	;(free)
SKIP_MACHINE_STATUS_LOOP

LD R3, Backup_R3_4200
LD R5, Backup_R5_4200
LD R6, Backup_R6_4200
LD R7, Backup_R7_4200

RET
;--------------------------------
;Data for subroutine MACHINE_STATUS
;--------------------------------
BUSYNESS_ADDR_MACHINE_STATUS	.Fill xB400
GET_NUM_SUB						.Fill x4600
neg_fifteen						.Fill #-15

Backup_R3_4200		.BLKW   #1
Backup_R5_4200		.BLKW   #1
Backup_R6_4200		.BLKW   #1
Backup_R7_4200		.BLKW   #1

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: FIRST_FREE (#6)
; Inputs: None
; Postcondition: The subroutine has returned a value indicating the lowest numbered free machine
; Return Value (R1): the number of the free machine
;-----------------------------------------------------------------------------------------------------------------
.ORIG x4400

ST R2, Backup_R2_4400
ST R3, Backup_R3_4400
ST R4, Backup_R4_4400
ST R5, Backup_R5_4400
ST R6, Backup_R6_4400
ST R7, Backup_R7_4400
;-------------------------------
;INSERT CODE For Subroutine FIRST_FREE
;--------------------------------
AND R1, R1, #0

LDI R2, BUSYNESS_ADDR_FIRST_FREE
LD R3, sixteen

SUB_FIRST_FREE_LOOP
	ADD R2, R2, #0
	BRzp SKIP_FIRST_FREE
	AND R1, R1, #0
	ADD R1, R1, R3
	SKIP_FIRST_FREE
	ADD R2, R2, R2
	ADD R3, R3, #-1
	BRp SUB_FIRST_FREE_LOOP
END_SUB_FIRST_FREE_LOOP

ADD R1, R1, #-1	;default for if no free register found and gives...
;correct register otherwise

LD R2, Backup_R2_4400
LD R3, Backup_R3_4400
ST R4, Backup_R4_4400
LD R5, Backup_R5_4400
LD R6, Backup_R6_4400
LD R7, Backup_R7_4400

RET
;--------------------------------
;Data for subroutine FIRST_FREE
;--------------------------------
BUSYNESS_ADDR_FIRST_FREE	.Fill xB400
sixteen						.Fill #16

Backup_R2_4400		.BLKW   #1
Backup_R3_4400		.BLKW   #1
Backup_R4_4400		.BLKW   #1
Backup_R5_4400		.BLKW   #1
Backup_R6_4400		.BLKW   #1
Backup_R7_4400		.BLKW   #1

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: GET_MACHINE_NUM
; Inputs: None
; Postcondition: The number entered by the user at the keyboard has been converted into binary,
;                and stored in R1. The number has been validated to be in the range {0,15}
; Return Value (R1): The binary equivalent of the numeric keyboard entry
; NOTE: You can use your code from assignment 4 for this subroutine, changing the prompt, 
;       and with the addition of validation to restrict acceptable values to the range {0,15}
;-----------------------------------------------------------------------------------------------------------------
.ORIG x4600

ST R0, Backup_R0_4600
ST R2, Backup_R2_4600
ST R3, Backup_R3_4600
ST R4, Backup_R4_4600
ST R5, Backup_R5_4600
ST R7, Backup_R7_4600
;-------------------------------
;INSERT CODE For Subroutine 
;--------------------------------
FIRST_INPUT
; output intro prompt
LEA R0, prompt
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
LD R0, newline2
OUT
BR GET_MACHINE_NUM_INVALID_INPUT
SKIP_NEWLINE
					; is it = '+'? if so, ignore it, go get digits
LD R3, pos_sign_DEC
ADD R3, R3, R0
BRz INPUT_LOOP
					; is it = '-'? if so, set neg flag, go get digits
LD R3, neg_sign_DEC
ADD R3, R3, R0
BRnp SKIP_NEGATIVE
LD R0, newline2
OUT
BR GET_MACHINE_NUM_INVALID_INPUT
SKIP_NEGATIVE
					; is it < '0'? if so, it is not a digit	- o/p error message, start over
LD R3, ascii_zero
ADD R3, R3, R0
BRzp SKIP_ZERO_INPUT
LD R0, newline2
OUT	
BR GET_MACHINE_NUM_INVALID_INPUT
SKIP_ZERO_INPUT
					; is it > '9'? if so, it is not a digit	- o/p error message, start over
LD R3, ascii_nine
ADD R3, R3, R0
BRnz SKIP_NINE_INPUT
LD R0, newline2
OUT	
BR GET_MACHINE_NUM_INVALID_INPUT
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
	BR END_INPUT_LOOP			
	SKIP_NEWLINE2
						;check valid input
	LD R3, ascii_zero
	ADD R3, R3, R0
	BRzp SKIP_ZERO_INPUT2
	LD R0, newline2
	OUT	
	BR GET_MACHINE_NUM_INVALID_INPUT
	SKIP_ZERO_INPUT2
	
	LD R3, ascii_nine
	ADD R3, R3, R0
	BRnz SKIP_NINE_INPUT2
	LD R0, newline2
	OUT	
	BR GET_MACHINE_NUM_INVALID_INPUT
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
;NOT R5, R5
;ADD R5, R5, #1
BR GET_MACHINE_NUM_INVALID_INPUT
SKIP_NEGATIVE_FLAG

;check range
RANGE_CHECK
	ADD R5, R5, #0
	BRn GET_MACHINE_NUM_INVALID_INPUT
	LD R3, dec_fifteen
	ADD R3, R3, R5
	BRp GET_MACHINE_NUM_INVALID_INPUT
	BR END_SUB
END_RANGE_CHECK

;statement for invalid input
GET_MACHINE_NUM_INVALID_INPUT
	LEA R0, Error_msg_2
	PUTS
	BR FIRST_INPUT
END_GET_MACHINE_NUM_INVALID_INPUT

END_SUB

;set value to be in R1
AND R1, R1, #0
ADD R1, R1, R5

LD R0, Backup_R0_4600
LD R2, Backup_R2_4600
LD R3, Backup_R3_4600
ST R4, Backup_R4_4600
LD R5, Backup_R5_4600
LD R7, Backup_R7_4600

RET
;--------------------------------
;Data for subroutine Get input
;--------------------------------
prompt .STRINGZ "Enter which machine you want the status of (0 - 15), followed by ENTER: "
Error_msg_2 .STRINGZ "ERROR INVALID INPUT\n"

counter5			.FILL #5
counter9			.FILL #9
newline_DEC			.FILL #-10
pos_sign_DEC		.FILL #-43
neg_sign_DEC		.FILL #-45
ascii_zero			.FILL #-48
ascii_nine			.FILL #-57
ascii_to_decimal	.FILL #-48
dec_fifteen			.FILL #-15
negative_flag		.FILL #1
newline2			.FILL '\n'
Backup_R0_4600		.BLKW   #1
Backup_R2_4600		.BLKW   #1
Backup_R3_4600		.BLKW   #1
Backup_R4_4600		.BLKW   #1
Backup_R5_4600		.BLKW   #1
Backup_R7_4600		.BLKW   #1
;-----------------------------------------------------------------------------------------------------------------
; Subroutine: PRINT_NUM
; Inputs: R1, which is guaranteed to be in range {0,16}
; Postcondition: The subroutine has output the number in R1 as a decimal ascii string, 
;                WITHOUT leading 0's, a leading sign, or a trailing newline.
; Return Value: None; the value in R1 is unchanged
;-----------------------------------------------------------------------------------------------------------------
.ORIG x4800

ST R0, Backup_R0_4800
ST R2, Backup_R2_4800
ST R3, Backup_R3_4800
ST R5, Backup_R5_4800
ST R7, Backup_R7_4800
;-------------------------------
;INSERT CODE For Subroutine 
;--------------------------------
AND R0, R0, #0
AND R2, R2, #0
AND R3, R3, #0
AND R5, R5, #0

ADD R5, R5, R1

TEN_LOOP
	LD R3, DEC_10	;Subtract 10k and check if its negative
	ADD R5, R5, R3
	BRn RESET_TEN
	ADD R2, R2, #1
	BR TEN_LOOP
	
	RESET_TEN
	NOT R3, R3
	ADD R3, R3, #1
	ADD R5, R5, R3	;Leaves R1 with remainder before it went negative
	
	AND R0, R0, #0
	ADD R0, R0, R2	;Output digit
	BRz END_TEN_LOOP
	LD R3, DEC_48
	ADD R0, R0, R3
	OUT
END_TEN_LOOP

AND R0, R0, #0
ADD R0, R0, R5
LD R3, DEC_48
ADD R0, R0, R3
OUT

LD R0, Backup_R0_4800
LD R2, Backup_R2_4800
LD R3, Backup_R3_4800
LD R5, Backup_R5_4800
LD R7, Backup_R7_4800

RET
;--------------------------------
;Data for subroutine print number
;--------------------------------
DEC_10				.FILL	#-10
DEC_48				.FILL	#48
Backup_R0_4800		.BLKW   #1
Backup_R2_4800		.BLKW   #1
Backup_R3_4800		.BLKW   #1
Backup_R5_4800		.BLKW   #1
Backup_R7_4800		.BLKW   #1


.ORIG x5000
MENUSTRING .STRINGZ "**********************\n* The Busyness Server *\n**********************\n1. Check to see whether all machines are busy\n2. Check to see whether all machines are free\n3. Report the number of busy machines\n4. Report the number of free machines\n5. Report the status of machine n\n6. Report the number of the first available machine\n7. Quit\n"

.ORIG xB400			; Remote data
BUSYNESS .FILL x8000 	; <----!!!BUSYNESS VECTOR!!! Change this value to test your program.

;---------------	
;END of PROGRAM
;---------------	
.END
