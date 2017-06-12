	CODEORG 0
;might as well be explicit about the start of code space

RESET:	LOADIMM R0,32767	;the address of the virtual uart
	LOADIMM R1,72		; 'H'
	STORE R1,R0		;write it to the uart
	LOADIMM R1,69		; 'E'
	STORE R1,R0		;write it to the uart
	LOADIMM R1,76		; 'L'
	STORE R1,R0		;write it to the uart
	LOADIMM R1,76		; 'L'
	STORE R1,R0		;write it to the uart
	LOADIMM R1,79		; 'O'
	STORE R1,R0		;write it to the uart
	LOADIMM R1,32		; ' '
	STORE R1,R0		;write it to the uart

	LOADIMM R1,85		; 'W'
	STORE R1,R0		;write it to the uart
	LOADIMM R1,79		; 'O'
	STORE R1,R0		;write it to the uart
	LOADIMM R1,82		; 'R'
	STORE R1,R0		;write it to the uart
	LOADIMM R1,76		; 'L'
	STORE R1,R0		;write it to the uart
	LOADIMM R1,68		; 'D'
	STORE R1,R0		;write it to the uart
	LOADIMM R1,10		; CR
	STORE R1,R0		;write it to the uart
	LOADIMM R1,13		; LF
	STORE R1,R0		;write it to the uart

	LOADIMM R2,RESET
	JUMPABS R2

;some dummy data to test compiler
	DATAORG 200
		
DATA1:	WORD 45678
	WORD 12333
	WORD 12

NEWLBL:	MOVE R12,R1
	JUMPRIMM NEWLBL
	
	
;	    a  b  c  d  e  f  g  h  i  j  k  l  m  n  o  p  q  r  s  t  w  
;           65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85


