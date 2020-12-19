
.ORIG x3000

LD R1, ARRAY_PTR ;load pointer to array
AND R2, R2, #0

ADD R3, R3, #10 ;counter
WHILE_LOOP
	STR R2, R1, #0 ;stores value into array
	ADD R1, R1, #1 ;go to next mem index in array
	ADD R2, R2, #1 ;increment value in R2
	ADD R3, R3, #-1 ; decrement ptr
	BRp WHILE_LOOP

ADD R1, R1, #-10 ;reset array to first index
ADD R1, R1, #6 ;iterate to index 6 of array
LDR R2, R1, #0 ;load it into R2

ADD R1, R1, #-6 ;reset array to first index
ADD R3, R3, #10 ;counter
WHILE_LOOP2
	LDR R0, R1, #0 ;load value in R1 to R0
	ADD R0, R0, #12 ;changing val from number to ascii
	ADD R0, R0, #12
	ADD R0, R0, #12
	ADD R0, R0, #12
	ADD R1, R1, #1 ;go to next index in array
	ADD R3, R3, #-1 ;decrement counter
	OUT
	BRp WHILE_LOOP2

HALT

ARRAY_PTR	.FILL	x4000

.ORIG x4000
.BLKW	#10

.END
