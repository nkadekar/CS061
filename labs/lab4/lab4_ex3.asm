
.ORIG x3000

LD R1, ARRAY_PTR ;load pointer to array
AND R2, R2, #0
ADD R2, R2, #1 ;2^0 = 1

ADD R3, R3, #10 ;counter
WHILE_LOOP
	STR R2, R1, #0 ;stores value into array
	ADD R1, R1, #1 ;go to next mem index in array
	ADD R2, R2, R2 ;add R2 to itself aka multiply by 2
	ADD R3, R3, #-1 ; decrement ptr
	BRp WHILE_LOOP

ADD R1, R1, #-10 ;reset array to first index
ADD R1, R1, #6 ;iterate to index 6 of array
LDR R2, R1, #0 ;load it into R2

HALT

ARRAY_PTR	.FILL	x4000

.ORIG x4000
.BLKW	#10

.END
