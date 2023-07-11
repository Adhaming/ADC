
RS BIT P2.0
E BIT P2.1
OE BIT P2.2   //RD
SOC BIT P2.3   //WR
EOC BIT P2.4    //INTR

	
ORG 0000H
	
	MOV P0,#00H     ;INTALIZE AS OUTPUT PORT 
	MOV P1,#0FFH     ;INTIALIZE AS INPUT PORT 
	SETB EOC        ;INTALIZE AS INPUT PORT 
	ACALL INT_LCD
//-----------------------------------------------------------------
AGAIN:  CLR SOC   //wr
   ACALL SDELAY
   SETB SOC
STOP :JB EOC,STOP   //INTR

    CLR OE
	ACALL SDELAY 
	MOV A,P1    //output digital code ADC
	SETB OE
	
	
	//vin = temperatur/100 
	//BECAUSE VREF/2= 1.28  
	//step=vref/(2^n)    n=8   and vref=2.56
	// STEP =0.01  
	//digital output= vin/step 
	// from this calculation digital output is value will dipaly on lcd
	MOV B,#10
	DIV AB       //27/10 = A=2  B=7
	ADD A,#30H
	ACALL DAT
	MOV A,B
	ADD A,#30H
	ACALL DAT
	MOV A,#" "
	ACALL DAT
	MOV A,#"C"
	ACALL DAT
	
	MOV A,#80H
	ACALL COMMAND
	
	SJMP AGAIN
	
//--------------------------------------------------------------------------------------	








INT_LCD:
MOV A,#38H
ACALL COMMAND
MOV A,#0CH
ACALL COMMAND 
MOV A,#06H
ACALL COMMAND  
MOV A,#01H
ACALL COMMAND
MOV A,#80H
ACALL COMMAND 
RET 

COMMAND:
MOV P0,A
CLR RS
SETB E
ACALL SDELAY 
CLR E
ACALL LDELAY 
RET 

DAT:
MOV P0,A
SETB RS
SETB E
ACALL SDELAY 
CLR E
ACALL LDELAY
RET

SDELAY:
MOV R3,#55
H1:MOV R2,#7
H0:DJNZ R2,H0
   DJNZ R3,H1
RET
 
LDELAY:
 MOV R3,#50
 H11:MOV R2,#255
 H00:DJNZ R2,H00
     DJNZ R3,H11
RET



END 
