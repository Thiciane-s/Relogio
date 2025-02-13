.INCLUDE "m328Pdef.inc"

.equ SEG_F		= PB0
.equ DISPLAY	= PORTC

.equ PIN_SEG_UNI 	= PB1
.equ PIN_SEG_DEZ 	= PB2

.equ PIN_MIN_UNI 	= PB3
.equ PIN_MIN_DEZ 	= PB4

.def SEG_UNI	= R16
.def SEG_DEZ	= R20
.def MIN_UNI 	= R21
.def MIN_DEZ	= R22
.def HOR_UNI 	= R23
.def HOR_DEZ	= R24
.def AUX		= R17
.def DECODENUM  = R25
.def MODE_SELECT = R26
.def DEC_OU_INC	 = R27

.ORG 0x00
RJMP init

.org 0x02  ;; Vetor de interrupção para PCINT0
RJMP EXT_INT0

.org 0x04
RJMP EXT_INT1

init:
	LDI SEG_UNI, 0x00
	LDI SEG_DEZ, 0x00
	LDI MIN_UNI, 0x00
	LDI MIN_DEZ , 0x00
	LDI HOR_UNI , 0x00
	LDI HOR_DEZ , 0x00
	LDI DEC_OU_INC, 0x01
	LDI AUX,  0xFF
	LDI MIN_UNI, 0x00
	OUT DDRD, AUX
	OUT DDRB, AUX
	OUT PORTB,AUX
	OUT DDRC, AUX
	OUT PORTC,AUX	
	OUT PORTD, AUX
    ;; Configuração da interrupção INT0 (D2 no ATmega328)
    LDI AUX, 0b00001010  ;; Configura para borda de descida
    STS EICRA, AUX       ;; Armazena no registrador de controle da interrupção
    LDI AUX, 0b00000011   ;; Habilita a interrupção externa INT0
    OUT EIMSK, AUX
    SEI   ; Ativa interrupções globais
	
	
main:
	CPI DEC_OU_INC, 0x00
	BREQ CHECKPOINT_MAINDEC_1

	RCALL delay
	; RJMP decod
	
	CPI SEG_UNI, 0x09
	BRNE incrSegUni

	LDI SEG_UNI, 0x00

	CPI SEG_DEZ, 0x05
	BRNE incrSegDez

	LDI SEG_DEZ, 0x00

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	CPI MIN_UNI, 0x09
	BRNE incrMinUni
	
	LDI MIN_UNI, 0x00

	CPI MIN_DEZ, 0x05
	BRNE incrMinDez

	LDI MIN_DEZ, 0x00

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	CPI HOR_UNI, 0x09
	BRNE incrHorUni
	
	LDI HOR_UNI, 0x00

	CPI HOR_DEZ, 0x01
	BRNE incrHorDez

	LDI HOR_DEZ, 0x00

    CPI MODE_SELECT, 0X00
	BREQ decod

    CPI MODE_SELECT, 0X01
	BREQ decod_hora

incrSegUni:
	INC SEG_UNI
    CPI MODE_SELECT, 0X00
	BREQ decod

    CPI MODE_SELECT, 0X01
	BREQ decod_hora

incrSegDez:
	INC SEG_DEZ
    CPI MODE_SELECT, 0X00
	BREQ decod

    CPI MODE_SELECT, 0X01
	BREQ decod_hora

incrMinUni:
	INC MIN_UNI
    CPI MODE_SELECT, 0X00
	BREQ decod

    CPI MODE_SELECT, 0X01
	BREQ decod_hora

incrMinDez:
	INC MIN_DEZ
    CPI MODE_SELECT, 0X00
	BREQ decod

    CPI MODE_SELECT, 0X01
	BREQ decod_hora

incrHorUni:
	INC HOR_UNI
    CPI MODE_SELECT, 0X00
	BREQ decod

    CPI MODE_SELECT, 0X01
	BREQ decod_hora

incrHorDez:
	INC HOR_DEZ
    CPI MODE_SELECT, 0X00
	BREQ decod

    CPI MODE_SELECT, 0X01
	BREQ decod_hora

CHECKPOINT_MAINDEC_1: RJMP CHECKPOINT_MAINDEC_2

decod:
	MOV DECODENUM, SEG_UNI
	SBI PORTB, PIN_SEG_DEZ
	CBI PORTB, PIN_SEG_UNI
	SBI PORTB, PIN_MIN_UNI
	SBI PORTB, PIN_MIN_DEZ
	RCALL DECODIFICADOR
	RCALL delay

	MOV DECODENUM, SEG_DEZ
	CBI PORTB, PIN_SEG_DEZ
	SBI PORTB, PIN_SEG_UNI
	SBI PORTB, PIN_MIN_UNI
	SBI PORTB, PIN_MIN_DEZ
	RCALL DECODIFICADOR
	RCALL delay

	MOV DECODENUM, MIN_UNI
	SBI PORTB, PIN_SEG_DEZ
	SBI PORTB, PIN_SEG_UNI
	SBI PORTB, PIN_MIN_DEZ
	CBI PORTB, PIN_MIN_UNI
	RCALL DECODIFICADOR
	RCALL delay

	MOV DECODENUM, MIN_DEZ
	SBI PORTB, PIN_SEG_DEZ
	SBI PORTB, PIN_SEG_UNI
	CBI PORTB, PIN_MIN_DEZ
	SBI PORTB, PIN_MIN_UNI
	RCALL DECODIFICADOR
	RCALL delay

	CPI DEC_OU_INC, 0X00
	BREQ CHECKPOINT_MAINDEC_2
	RJMP main

decod_hora:
	MOV DECODENUM, MIN_UNI
	SBI PORTB, PIN_SEG_DEZ
	CBI PORTB, PIN_SEG_UNI
	SBI PORTB, PIN_MIN_UNI
	SBI PORTB, PIN_MIN_DEZ
	RCALL DECODIFICADOR
	RCALL delay

	MOV DECODENUM, MIN_DEZ
	CBI PORTB, PIN_SEG_DEZ
	SBI PORTB, PIN_SEG_UNI
	SBI PORTB, PIN_MIN_UNI
	SBI PORTB, PIN_MIN_DEZ
	RCALL DECODIFICADOR
	RCALL delay

	MOV DECODENUM, HOR_UNI
	SBI PORTB, PIN_SEG_DEZ
	SBI PORTB, PIN_SEG_UNI
	SBI PORTB, PIN_MIN_DEZ
	CBI PORTB, PIN_MIN_UNI
	RCALL DECODIFICADOR
	RCALL delay

	MOV DECODENUM, HOR_DEZ
	SBI PORTB, PIN_SEG_DEZ
	SBI PORTB, PIN_SEG_UNI
	CBI PORTB, PIN_MIN_DEZ
	SBI PORTB, PIN_MIN_UNI
	RCALL DECODIFICADOR
	RCALL delay

	CPI DEC_OU_INC, 0X00
	BREQ CHECKPOINT_MAINDEC
	RJMP main

CHECKPOINT_MAINDEC_2: RJMP CHECKPOINT_MAINDEC

delay:
	LDI R19, 12
	
volta:
	DEC R17
	CPI R17, 0x00
	BRNE volta
	
	DEC R18
	CPI R18, 0x00
	BRNE volta
	
	DEC R19
	CPI R19, 0x00
	BRNE volta
	RET

DECODIFICADOR:
	CPI DECODENUM, 0x00
	BREQ case0

	CPI DECODENUM, 0x01
	BREQ case1

	CPI DECODENUM, 0x02
	BREQ case2
	
	CPI DECODENUM, 0x03
	BREQ case3

	CPI DECODENUM, 0x04
	BREQ case4

	CPI DECODENUM, 0x05
	BREQ case5

	CPI DECODENUM, 0x06
	BREQ case6

	CPI DECODENUM, 0x07
	BREQ case7

	CPI DECODENUM, 0x08
	BREQ case8

	CPI DECODENUM, 0x09
	BREQ case9

	LDI DECODENUM, 0x06
	RJMP DISPLAYNUM
CHECKPOINT_DECOD: RJMP decod
CHECKPOINT_DECOD_HORA: RJMP decod_hora
CHECKPOINT_MAINDEC: RJMP mainDec
CHECKPOINT_MAIN: RJMP main
case0:
	LDI AUX, 0x3F
	CBI PORTB, SEG_F
	RJMP DISPLAYNUM

case1:
	LDI AUX, 0x06
	CBI PORTB, SEG_F
	RJMP DISPLAYNUM

case2:
	LDI AUX, 0x5B
	SBI PORTB, SEG_F
	RJMP DISPLAYNUM

case3:
	LDI AUX, 0x4F
	SBI PORTB, SEG_F
	RJMP DISPLAYNUM

case4:
	LDI AUX, 0x66
	SBI PORTB, SEG_F
	RJMP DISPLAYNUM

case5:
	LDI AUX, 0x6D
	SBI PORTB, SEG_F
	RJMP DISPLAYNUM

case6:
	LDI AUX, 0x7D
	SBI PORTB, SEG_F
	RJMP DISPLAYNUM

case7:
	LDI AUX, 0x07
	CBI PORTB, SEG_F
	RJMP DISPLAYNUM

case8:
	LDI AUX, 0x7F
	SBI PORTB, SEG_F
	RJMP DISPLAYNUM

case9:
	LDI AUX, 0x6F
	SBI PORTB, SEG_F

DISPLAYNUM:
	OUT DISPLAY, AUX
	RET

decSegUni:
	DEC SEG_UNI
    CPI MODE_SELECT, 0X00
	BREQ CHECKPOINT_DECOD

    CPI MODE_SELECT, 0X01
	BREQ CHECKPOINT_DECOD_HORA

decSegDez:
	DEC SEG_DEZ
    CPI MODE_SELECT, 0X00
	BREQ CHECKPOINT_DECOD

    CPI MODE_SELECT, 0X01
	BREQ CHECKPOINT_DECOD_HORA

decMinUni:
	DEC MIN_UNI
    CPI MODE_SELECT, 0X00
	BREQ CHECKPOINT_DECOD

    CPI MODE_SELECT, 0X01
	BREQ CHECKPOINT_DECOD_HORA

decMinDez:
	DEC MIN_DEZ
    CPI MODE_SELECT, 0X00
	BREQ CHECKPOINT_DECOD

    CPI MODE_SELECT, 0X01
	BREQ CHECKPOINT_DECOD_HORA
decHorUni:
	DEC HOR_UNI
    CPI MODE_SELECT, 0X00
	BREQ CHECKPOINT_DECOD

    CPI MODE_SELECT, 0X01
	BREQ CHECKPOINT_DECOD_HORA
decHorDez:
	DEC HOR_DEZ
    CPI MODE_SELECT, 0X00
	BREQ CHECKPOINT_DECOD

    CPI MODE_SELECT, 0X01
	BREQ CHECKPOINT_DECOD_HORA	


mainDec:
	CPI DEC_OU_INC, 0x01
	BREQ CHECKPOINT_MAIN

	RCALL delay
			
	CPI SEG_UNI, 0x00
	BRNE decSegUni

	LDI SEG_UNI, 0x09

	CPI SEG_DEZ, 0x00
	BRNE decSegDez

	LDI SEG_DEZ, 0x05

	CPI MIN_UNI, 0x00
	BRNE decMinUni
	
	LDI MIN_UNI, 0x09

	CPI MIN_DEZ, 0x00
	BRNE decMinDez

	LDI MIN_DEZ, 0x05

	CPI HOR_UNI, 0x00
	BRNE decHorUni
	
	LDI HOR_UNI, 0x09

	CPI HOR_DEZ, 0x00
	BRNE decHorDez

	LDI HOR_DEZ, 0x09
	
	CPI DEC_OU_INC, 0X00
	RJMP mainDec

EXT_INT0:
    CLI 
    CPI MODE_SELECT, 0x01
    BREQ RESET_MODE
    INC MODE_SELECT  
    SEI 
    RETI  

RESET_MODE:
    LDI MODE_SELECT, 0x00 
    SEI
    RETI

EXT_INT1:
	CLI
	CPI DEC_OU_INC, 0x00
	BREQ SET_PIN

	LDI DEC_OU_INC, 0x00
	RETI

SET_PIN:
	LDI DEC_OU_INC, 0x01
	RETI
