
;Hello world example program
;Also illustrates how to use PUTS(aka: Trapx22)
;
.ORIG x3000
;-----------
;Instructions
;-----------
	LEA R0, MSG_TO_PRINT
	PUTS
	
	HALT
;-----------
;Local data
;-----------
	MSG_TO_PRINT	.STRINGZ	"Hello world!!!\n"
	
.END
