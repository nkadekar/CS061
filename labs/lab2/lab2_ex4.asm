
.ORIG x3000

LD R0, DEC_61
LD R1, HEX_1A

DO_WHILE_LOOP
	OUT
	ADD R0, R0, #1
	ADD R1, R1, #-1	
	BRp DO_WHILE_LOOP

HALT

DEC_61	.FILL	x61
HEX_1A	.FILL	#10

.END