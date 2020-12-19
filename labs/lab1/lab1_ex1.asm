
.orig x3000
	;-------------
	;Instructions
	;-------------
	AND R1, R1, x0 		; R1 <- (R1) AND x0000
	
	;LD R1, DEC_0		;R1 <-- #0
	LD R2, DEC_12		;R2 <-- #12
	LD R3, DEC_TEMP		;R3 <-- #6
	
	DO_WHILE_LOOP
		ADD R1,R1,R2		;R1 += R2 or R1 <-- R1 + R2
		ADD R3,R3,#1		;R3--     or R3 <-- R3 - #1
		BRn DO_WHILE_LOOP
	END_DO_WHILE_LOOP
		
	HALT
	;----------
	;Local data
	;----------
	;DEC_0	.FILL	#0		;put #0 into memory
	DEC_12	.FILL	#12		;put #12 into memory
	DEC_6	.FILL	#6		;put #6 into memory
	DEC_TEMP .FILL	#-6	
		
.end
