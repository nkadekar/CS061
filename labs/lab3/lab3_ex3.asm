
.ORIG x3000

LEA R1, ARRAY
LD R2, COUNTER_10

DO_WHILE
	GETC
	OUT

	STR R0, R1, #0
	ADD R1, R1, #1
	ADD R2, R2, #-1

	BRp DO_WHILE

END_DO_WHILE

LEA R1, ARRAY
LD R2, COUNTER_10

LD R0, newline
OUT

DO_WHILE_LOOP

	LDR R0, R1, #0
	OUT
	LD R0, newline
	OUT
	ADD R1, R1, #1
	ADD R2, R2, #-1
	
	BRp DO_WHILE_LOOP

END_DO_WHILE_LOOP

HALT

ARRAY	.BLKW	#10
COUNTER_10	.FILL	#10
newline	.FILL	'\n'

.END
