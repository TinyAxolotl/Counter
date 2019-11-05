
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega8A
;Program type           : Application
;Clock frequency        : 8,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega8A
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _i=R4
	.DEF _i_msb=R5
	.DEF _counter_sec=R6
	.DEF _counter_sec_msb=R7
	.DEF _screen=R8
	.DEF _screen_msb=R9

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer1_ovf_isr
	RJMP _timer0_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0038

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0

_0x0:
	.DB  0x25,0x30,0x32,0x69,0x3A,0x25,0x30,0x32
	.DB  0x69,0x3A,0x25,0x30,0x32,0x69,0x0,0x25
	.DB  0x30,0x32,0x69,0x2C,0x25,0x30,0x31,0x69
	.DB  0x2C,0x25,0x30,0x32,0x69,0x0,0x4B,0x20
	.DB  0x4F,0x46,0x46,0x0,0x4B,0x20,0x4F,0x4E
	.DB  0x0,0x53,0x20,0x4F,0x46,0x46,0x0,0x53
	.DB  0x20,0x4F,0x4E,0x0,0x48,0x41,0x43,0x54
	.DB  0x52,0x4F,0x75,0x4B,0x41,0x0,0x41,0x42
	.DB  0x54,0x4F,0x4B,0x4F,0x50,0x4D,0x79,0x4C
	.DB  0x4C,0x49,0x4B,0x41,0x0,0x50,0x41,0x52
	.DB  0x20,0x31,0x20,0x20,0x20,0x4F,0x4E,0x20
	.DB  0x20,0x4F,0x46,0x46,0x0,0x50,0x4F,0x44
	.DB  0x43,0x42,0x45,0x54,0x4B,0x41,0x0,0x50
	.DB  0x41,0x52,0x20,0x32,0x20,0x20,0x20,0x4F
	.DB  0x4E,0x20,0x20,0x4F,0x46,0x46,0x0,0x45
	.DB  0x58,0x49,0x54,0x3F,0x0,0x42,0x20,0x4B
	.DB  0x20,0x4A,0x49,0x0,0x42,0x20,0x62,0x49
	.DB  0x20,0x4B,0x20,0x4A,0x49,0x0
_0x2020003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x06
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x02
	.DW  __base_y_G101
	.DW  _0x2020003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 22.08.2018
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega8A
;Program type            : Application
;AVR Core Clock frequency: 8,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;
;#define DS1302_E 2
;#define DS1302_SCLK 0
;#define DS1302_IO 1
;#define DS1302_DDR_RTC DDRC
;#define DS1302_PORT_RTC PORTC
;#define DS1302_PIN_RTC PINC
;#define IN1   PORTB.7
;#define IN2   PORTD.5
;#define IN3   PORTD.6
;#define IN4   PORTD.7
;#define left_button  PINB.4
;#define right_button  PINB.3
;#define OK_button      PINB.2
;
;#define step 4096
;
;#define AM 0
;#define PM 0b00100000
;
;#define H12 0b10000000
;#define H24 0
;
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <io.h>
;#include <stdio.h>
;
;// Alphanumeric LCD functions
;#include <alcd.h>
;
;// Declare your global variables here
;   char buffer[16];
;   unsigned long int steps=0;
;   int i=0, counter_sec=0, screen=0;
;   bit flag_get_date=0, flag_start_motor=0, flag_forward=0, left=1, right=1, OK=1, flag_feed=0, flag_first_move=0, flag_ ...
;   volatile eeprom int flag_activ_korm=0, flag_activ_svet=0;
;
;
;typedef    struct
;    {
;    int        Sec;
;    int        Min;
;    int        Hour;
;    int        Month;
;    int        Day;
;    int        Year;
;    int        WeekDay;
;    int        AMPM;
;    int        H12_24;
;    } tpDateTime;
;
;tpDateTime    DateTime;
;
;int DS1302_Bin8_To_BCD(int data)
; 0000 004E {

	.CSEG
; 0000 004F    int nibh;
; 0000 0050    int nibl;
; 0000 0051 
; 0000 0052    nibh=data/10;
;	data -> Y+4
;	nibh -> R16,R17
;	nibl -> R18,R19
; 0000 0053    nibl=data-(nibh*10);
; 0000 0054 
; 0000 0055    return((nibh<<4)|nibl);
; 0000 0056 }
;
;int DS1302_BCD_To_Bin8(int data)
; 0000 0059 {
_DS1302_BCD_To_Bin8:
; .FSTART _DS1302_BCD_To_Bin8
; 0000 005A unsigned char result;
; 0000 005B     result = ((data>>4) & 0b00000111);
	RCALL SUBOPT_0x0
	ST   -Y,R17
;	data -> Y+1
;	result -> R17
	RCALL SUBOPT_0x1
	RCALL __ASRW4
	ANDI R30,LOW(0x7)
	MOV  R17,R30
; 0000 005C     data &= 0x0F;
	RCALL SUBOPT_0x1
	ANDI R30,LOW(0xF)
	ANDI R31,HIGH(0xF)
	STD  Y+1,R30
	STD  Y+1+1,R31
; 0000 005D     data = data + result*10;
	LDI  R30,LOW(10)
	MUL  R30,R17
	MOVW R30,R0
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+1,R30
	STD  Y+1+1,R31
; 0000 005E     return data;
	RCALL SUBOPT_0x1
	LDD  R17,Y+0
	ADIW R28,3
	RET
; 0000 005F }
; .FEND
;
;//посылаем команду или байт данных в часы
;void ds1302_write(unsigned char cmd)
; 0000 0063 {
_ds1302_write:
; .FSTART _ds1302_write
; 0000 0064 unsigned char i;
; 0000 0065     DS1302_DDR_RTC |= (1<<DS1302_E) | (1<<DS1302_SCLK);
	ST   -Y,R26
	ST   -Y,R17
;	cmd -> Y+1
;	i -> R17
	IN   R30,0x14
	ORI  R30,LOW(0x5)
	OUT  0x14,R30
; 0000 0066     DS1302_PORT_RTC |= (1<<DS1302_E);//E=1
	SBI  0x15,2
; 0000 0067     delay_us(1);
	RCALL SUBOPT_0x2
; 0000 0068     DS1302_DDR_RTC |= (1<<DS1302_IO);//выход
	SBI  0x14,1
; 0000 0069     for(i=0; i<8; i++)
	LDI  R17,LOW(0)
_0x4:
	CPI  R17,8
	BRLO PC+2
	RJMP _0x5
; 0000 006A     {
; 0000 006B         if((cmd&(1<<i)) == 1<<i)
	RCALL SUBOPT_0x3
	LDD  R26,Y+1
	LDI  R27,0
	AND  R30,R26
	AND  R31,R27
	MOVW R22,R30
	RCALL SUBOPT_0x3
	CP   R30,R22
	CPC  R31,R23
	BREQ PC+2
	RJMP _0x6
; 0000 006C         {
; 0000 006D             DS1302_PORT_RTC |= (1<<DS1302_IO);
	SBI  0x15,1
; 0000 006E         }
; 0000 006F         else
	RJMP _0x7
_0x6:
; 0000 0070         {
; 0000 0071             DS1302_PORT_RTC &= ~(1<<DS1302_IO);
	CBI  0x15,1
; 0000 0072         }
_0x7:
; 0000 0073         DS1302_PORT_RTC |= (1<<DS1302_SCLK);
	SBI  0x15,0
; 0000 0074         delay_us(1);
	RCALL SUBOPT_0x2
; 0000 0075         DS1302_PORT_RTC &= ~(1<<DS1302_IO);
	CBI  0x15,1
; 0000 0076         DS1302_PORT_RTC &= ~(1<<DS1302_SCLK);
	CBI  0x15,0
; 0000 0077     }
_0x3:
	SUBI R17,-1
	RJMP _0x4
_0x5:
; 0000 0078 }
	LDD  R17,Y+0
	ADIW R28,2
	RET
; .FEND
;//вызываем после записи байта данных в часы
;void ds1302_end_write_data()
; 0000 007B {
; 0000 007C     DS1302_PORT_RTC &= ~(1<<DS1302_E);
; 0000 007D }
;
;unsigned char ds1302_read()
; 0000 0080 {
_ds1302_read:
; .FSTART _ds1302_read
; 0000 0081 unsigned char readbyte;
; 0000 0082 unsigned char i;
; 0000 0083     readbyte=0;
	RCALL __SAVELOCR2
;	readbyte -> R17
;	i -> R16
	LDI  R17,LOW(0)
; 0000 0084     DS1302_DDR_RTC &= ~(1<<DS1302_IO);
	CBI  0x14,1
; 0000 0085     for(i=0;i<8;i++)
	LDI  R16,LOW(0)
_0x9:
	CPI  R16,8
	BRLO PC+2
	RJMP _0xA
; 0000 0086     {
; 0000 0087         DS1302_PORT_RTC |= 1<<DS1302_SCLK;
	SBI  0x15,0
; 0000 0088         if((DS1302_PIN_RTC & (1<<DS1302_IO))==0)
	SBIC 0x13,1
	RJMP _0xB
; 0000 0089         {
; 0000 008A             readbyte &= ~(1<<i);
	MOV  R30,R16
	LDI  R26,LOW(1)
	RCALL __LSLB12
	COM  R30
	AND  R17,R30
; 0000 008B         }
; 0000 008C         else
	RJMP _0xC
_0xB:
; 0000 008D         {
; 0000 008E             readbyte |= 1<<i;
	MOV  R30,R16
	LDI  R26,LOW(1)
	RCALL __LSLB12
	OR   R17,R30
; 0000 008F         }
_0xC:
; 0000 0090         delay_us(1);
	RCALL SUBOPT_0x2
; 0000 0091         DS1302_PORT_RTC &= ~(1<<DS1302_SCLK);
	CBI  0x15,0
; 0000 0092         delay_us(1);
	RCALL SUBOPT_0x2
; 0000 0093     }
_0x8:
	SUBI R16,-1
	RJMP _0x9
_0xA:
; 0000 0094     DS1302_PORT_RTC &= ~(1<<DS1302_E);
	CBI  0x15,2
; 0000 0095     delay_us(1);
	RCALL SUBOPT_0x2
; 0000 0096     return readbyte;
	MOV  R30,R17
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 0097 }
; .FEND
;
;void DS1302_ReadDateTime() {
; 0000 0099 void DS1302_ReadDateTime() {
_DS1302_ReadDateTime:
; .FSTART _DS1302_ReadDateTime
; 0000 009A     //read seconds
; 0000 009B     ds1302_write(0x81);
	LDI  R26,LOW(129)
	RCALL SUBOPT_0x4
; 0000 009C     DateTime.Sec = DS1302_BCD_To_Bin8(ds1302_read());
	STS  _DateTime,R30
	STS  _DateTime+1,R31
; 0000 009D     //read minutes
; 0000 009E     ds1302_write(0x83);
	LDI  R26,LOW(131)
	RCALL SUBOPT_0x4
; 0000 009F     DateTime.Min = DS1302_BCD_To_Bin8(ds1302_read());
	__PUTW1MN _DateTime,2
; 0000 00A0     //read hour
; 0000 00A1     ds1302_write(0x85);
	LDI  R26,LOW(133)
	RCALL _ds1302_write
; 0000 00A2     DateTime.Hour = ds1302_read();
	RCALL _ds1302_read
	__POINTW2MN _DateTime,4
	LDI  R31,0
	RCALL SUBOPT_0x5
; 0000 00A3     DateTime.AMPM = (DateTime.Hour & 0b00100000);
	RCALL SUBOPT_0x6
	ANDI R30,LOW(0x20)
	ANDI R31,HIGH(0x20)
	__PUTW1MN _DateTime,14
; 0000 00A4     DateTime.H12_24 = (DateTime.Hour & 0b10000000);
	RCALL SUBOPT_0x6
	ANDI R30,LOW(0x80)
	ANDI R31,HIGH(0x80)
	__PUTW1MN _DateTime,16
; 0000 00A5     if (DateTime.H12_24 == H12) {
	__GETW2MN _DateTime,16
	CPI  R26,LOW(0x80)
	LDI  R30,HIGH(0x80)
	CPC  R27,R30
	BREQ PC+2
	RJMP _0xD
; 0000 00A6         DateTime.Hour = DateTime.Hour & 0b00011111;
	RCALL SUBOPT_0x6
	ANDI R30,LOW(0x1F)
	ANDI R31,HIGH(0x1F)
	RCALL SUBOPT_0x7
; 0000 00A7     }
; 0000 00A8     else {
	RJMP _0xE
_0xD:
; 0000 00A9         DateTime.Hour = DateTime.Hour & 0b00111111;
	RCALL SUBOPT_0x6
	ANDI R30,LOW(0x3F)
	ANDI R31,HIGH(0x3F)
	RCALL SUBOPT_0x7
; 0000 00AA     }
_0xE:
; 0000 00AB     DateTime.Hour = DS1302_BCD_To_Bin8(DateTime.Hour);
	RCALL SUBOPT_0x8
	RCALL _DS1302_BCD_To_Bin8
	RCALL SUBOPT_0x7
; 0000 00AC     //read day
; 0000 00AD     ds1302_write(0x87);
	LDI  R26,LOW(135)
	RCALL SUBOPT_0x4
; 0000 00AE     DateTime.Day = DS1302_BCD_To_Bin8(ds1302_read());
	__PUTW1MN _DateTime,8
; 0000 00AF     //read month
; 0000 00B0     ds1302_write(0x89);
	LDI  R26,LOW(137)
	RCALL SUBOPT_0x4
; 0000 00B1     DateTime.Month = DS1302_BCD_To_Bin8(ds1302_read());
	__PUTW1MN _DateTime,6
; 0000 00B2     //read weekday
; 0000 00B3     ds1302_write(0x8B);
	LDI  R26,LOW(139)
	RCALL _ds1302_write
; 0000 00B4 	DateTime.WeekDay=ds1302_read();
	RCALL _ds1302_read
	__POINTW2MN _DateTime,12
	LDI  R31,0
	RCALL SUBOPT_0x5
; 0000 00B5 	//read year
; 0000 00B6 	ds1302_write(0x8D);
	LDI  R26,LOW(141)
	RCALL SUBOPT_0x4
; 0000 00B7 	DateTime.Year = DS1302_BCD_To_Bin8(ds1302_read());
	__PUTW1MN _DateTime,10
; 0000 00B8 }
	RET
; .FEND
;
;void DS1302_WriteDateTime() {
; 0000 00BA void DS1302_WriteDateTime() {
; 0000 00BB int tmp;
; 0000 00BC 	//set seconds
; 0000 00BD 	ds1302_write(0x80);
;	tmp -> R16,R17
; 0000 00BE 	ds1302_write(DS1302_Bin8_To_BCD(DateTime.Sec));
; 0000 00BF 	ds1302_end_write_data();
; 0000 00C0 	//set minutes
; 0000 00C1 	ds1302_write(0x82);
; 0000 00C2 	ds1302_write(DS1302_Bin8_To_BCD(DateTime.Min));
; 0000 00C3 	ds1302_end_write_data();
; 0000 00C4 	//set hour
; 0000 00C5 	tmp = (DS1302_Bin8_To_BCD(DateTime.Hour) | DateTime.AMPM | DateTime.H12_24);
; 0000 00C6 	ds1302_write(0x84);
; 0000 00C7 	ds1302_write(tmp);
; 0000 00C8 	ds1302_end_write_data();
; 0000 00C9 	//set dade
; 0000 00CA 	ds1302_write(0x86);
; 0000 00CB 	ds1302_write(DS1302_Bin8_To_BCD(DateTime.Day));
; 0000 00CC 	ds1302_end_write_data();
; 0000 00CD 	//set month
; 0000 00CE 	ds1302_write(0x88);
; 0000 00CF 	ds1302_write(DS1302_Bin8_To_BCD(DateTime.Month));
; 0000 00D0 	ds1302_end_write_data();
; 0000 00D1 	//set day (of week)
; 0000 00D2 	ds1302_write(0x8A);
; 0000 00D3 	ds1302_write(DateTime.WeekDay);
; 0000 00D4 	ds1302_end_write_data();
; 0000 00D5 	//set year
; 0000 00D6 	ds1302_write(0x8C);
; 0000 00D7 	ds1302_write(DS1302_Bin8_To_BCD(DateTime.Year));
; 0000 00D8 	ds1302_end_write_data();
; 0000 00D9 }
;
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 00DE {
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R0
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00DF // Reinitialize Timer 0 value
; 0000 00E0 TCNT0=0x83;
	LDI  R30,LOW(131)
	OUT  0x32,R30
; 0000 00E1 if (steps > 0)
	RCALL SUBOPT_0x9
	BRLO PC+2
	RJMP _0xF
; 0000 00E2 {
; 0000 00E3 
; 0000 00E4     switch(i)
	MOVW R30,R4
; 0000 00E5         {
; 0000 00E6         case 0:   IN1=0; break;
	SBIW R30,0
	BREQ PC+2
	RJMP _0x13
	CBI  0x18,7
	RJMP _0x12
; 0000 00E7         case 1:   IN3=1; break;
_0x13:
	RCALL SUBOPT_0xA
	BREQ PC+2
	RJMP _0x16
	SBI  0x12,6
	RJMP _0x12
; 0000 00E8         case 2:   IN4=0; break;
_0x16:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x19
	CBI  0x12,7
	RJMP _0x12
; 0000 00E9         case 3:   IN2=1; break;
_0x19:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x1C
	SBI  0x12,5
	RJMP _0x12
; 0000 00EA         case 4:   IN3=0; break;
_0x1C:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x1F
	CBI  0x12,6
	RJMP _0x12
; 0000 00EB         case 5:   IN1=1; break;
_0x1F:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x22
	SBI  0x18,7
	RJMP _0x12
; 0000 00EC         case 6:   IN2=0; break;
_0x22:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x25
	CBI  0x12,5
	RJMP _0x12
; 0000 00ED         case 7:   IN4=1; break;
_0x25:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x12
	SBI  0x12,7
; 0000 00EE         }
_0x12:
; 0000 00EF 
; 0000 00F0 
; 0000 00F1     if(flag_forward==0)
	SBRC R2,2
	RJMP _0x2B
; 0000 00F2         {
; 0000 00F3         i++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 00F4         if(i>7)
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CP   R30,R4
	CPC  R31,R5
	BRLT PC+2
	RJMP _0x2C
; 0000 00F5             i=0;
	CLR  R4
	CLR  R5
; 0000 00F6         }
_0x2C:
; 0000 00F7     else
	RJMP _0x2D
_0x2B:
; 0000 00F8         {
; 0000 00F9         i--;
	MOVW R30,R4
	SBIW R30,1
	MOVW R4,R30
; 0000 00FA         if(i<0)
	CLR  R0
	CP   R4,R0
	CPC  R5,R0
	BRLT PC+2
	RJMP _0x2E
; 0000 00FB             i=7;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	MOVW R4,R30
; 0000 00FC         }
_0x2E:
_0x2D:
; 0000 00FD     steps--;
	LDI  R26,LOW(_steps)
	LDI  R27,HIGH(_steps)
	RCALL __GETD1P_INC
	SBIW R30,1
	SBCI R22,0
	SBCI R23,0
	RCALL __PUTDP1_DEC
; 0000 00FE 
; 0000 00FF }
; 0000 0100 else
	RJMP _0x2F
_0xF:
; 0000 0101     {
; 0000 0102     IN1=0;
	CBI  0x18,7
; 0000 0103     IN2=0;
	CBI  0x12,5
; 0000 0104     IN3=0;
	CBI  0x12,6
; 0000 0105     IN4=0;
	CBI  0x12,7
; 0000 0106     }
_0x2F:
; 0000 0107 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;// Timer1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 010B {
_timer1_ovf_isr:
; .FSTART _timer1_ovf_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 010C 
; 0000 010D TCNT1H=0xCF2C >> 8;
	LDI  R30,LOW(207)
	OUT  0x2D,R30
; 0000 010E TCNT1L=0xCF2C & 0xff;
	LDI  R30,LOW(44)
	OUT  0x2C,R30
; 0000 010F switch(screen)                     // Вывод меню
	MOVW R30,R8
; 0000 0110  {
; 0000 0111     case 0:                                           // Вывод основной инф.
	SBIW R30,0
	BREQ PC+2
	RJMP _0x3B
; 0000 0112     {
; 0000 0113         DS1302_ReadDateTime();
	RCALL _DS1302_ReadDateTime
; 0000 0114         sprintf(buffer, "%02i:%02i:%02i", DateTime.Hour, DateTime.Min, DateTime.Sec);
	RCALL SUBOPT_0xB
	__POINTW1FN _0x0,0
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0xD
	__GETW1MN _DateTime,2
	RCALL SUBOPT_0xD
	LDS  R30,_DateTime
	LDS  R31,_DateTime+1
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xE
; 0000 0115         lcd_gotoxy(0,0);
	RCALL SUBOPT_0xF
; 0000 0116         lcd_puts(buffer);
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	RCALL _lcd_puts
; 0000 0117 
; 0000 0118         if(flag_get_date == 0 || (DateTime.Hour>23 && DateTime.Min>59))
	SBRS R2,0
	RJMP _0x3D
	RCALL SUBOPT_0x8
	SBIW R26,24
	BRGE PC+2
	RJMP _0x3E
	__GETW2MN _DateTime,2
	SBIW R26,60
	BRGE PC+2
	RJMP _0x3E
	RJMP _0x3D
_0x3E:
	RJMP _0x3C
_0x3D:
; 0000 0119             {
; 0000 011A             sprintf(buffer, "%02i,%01i,%02i", DateTime.Day, DateTime.Month, DateTime.Year);
	RCALL SUBOPT_0xB
	__POINTW1FN _0x0,15
	RCALL SUBOPT_0xC
	__GETW1MN _DateTime,8
	RCALL SUBOPT_0xD
	__GETW1MN _DateTime,6
	RCALL SUBOPT_0xD
	__GETW1MN _DateTime,10
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xE
; 0000 011B             lcd_gotoxy(0,1);
	RCALL SUBOPT_0x10
; 0000 011C             lcd_puts(buffer);
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	RCALL _lcd_puts
; 0000 011D             flag_get_date = 1;
	SET
	BLD  R2,0
; 0000 011E             };
_0x3C:
; 0000 011F 
; 0000 0120         if (flag_activ_korm==0)
	RCALL SUBOPT_0x11
	RCALL __EEPROMRDW
	SBIW R30,0
	BREQ PC+2
	RJMP _0x41
; 0000 0121             {
; 0000 0122             lcd_gotoxy(10,0);
	LDI  R30,LOW(10)
	RCALL SUBOPT_0x12
; 0000 0123             lcd_putsf("K OFF");
	__POINTW2FN _0x0,30
	RCALL _lcd_putsf
; 0000 0124             }
; 0000 0125         else
	RJMP _0x42
_0x41:
; 0000 0126             {
; 0000 0127             lcd_gotoxy(10,0);
	LDI  R30,LOW(10)
	RCALL SUBOPT_0x12
; 0000 0128             lcd_putsf("K ON");
	__POINTW2FN _0x0,36
	RCALL _lcd_putsf
; 0000 0129             }
_0x42:
; 0000 012A 
; 0000 012B 
; 0000 012C         if (flag_activ_svet==0)
	RCALL SUBOPT_0x13
	RCALL __EEPROMRDW
	SBIW R30,0
	BREQ PC+2
	RJMP _0x43
; 0000 012D             {
; 0000 012E             lcd_gotoxy(10,1);
	LDI  R30,LOW(10)
	RCALL SUBOPT_0x14
; 0000 012F             lcd_putsf("S OFF");
	__POINTW2FN _0x0,41
	RCALL _lcd_putsf
; 0000 0130             }
; 0000 0131         else
	RJMP _0x44
_0x43:
; 0000 0132             {
; 0000 0133             lcd_gotoxy(10,1);
	LDI  R30,LOW(10)
	RCALL SUBOPT_0x14
; 0000 0134             lcd_putsf("S ON");
	__POINTW2FN _0x0,47
	RCALL _lcd_putsf
; 0000 0135             }
_0x44:
; 0000 0136         if(left==0 || right==0)
	SBRS R2,3
	RJMP _0x46
	SBRS R2,4
	RJMP _0x46
	RJMP _0x45
_0x46:
; 0000 0137             {
; 0000 0138             screen=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RCALL SUBOPT_0x15
; 0000 0139             left=1;
; 0000 013A             right=1;
	RCALL SUBOPT_0x16
; 0000 013B             }
; 0000 013C         if(OK==0);
_0x45:
	SBRC R2,5
	RJMP _0x48
; 0000 013D             OK=1;
_0x48:
	RCALL SUBOPT_0x17
; 0000 013E         break;
	RJMP _0x3A
; 0000 013F     }
; 0000 0140 
; 0000 0141     case 1:                                            // Возможность войти в меню настройки
_0x3B:
	RCALL SUBOPT_0xA
	BREQ PC+2
	RJMP _0x49
; 0000 0142     {
; 0000 0143         lcd_clear();
	RCALL _lcd_clear
; 0000 0144         lcd_gotoxy(3,1);
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x14
; 0000 0145         lcd_putsf("HACTROuKA");
	__POINTW2FN _0x0,52
	RCALL _lcd_putsf
; 0000 0146 
; 0000 0147         if(left==0 || right==0)
	SBRS R2,3
	RJMP _0x4B
	SBRS R2,4
	RJMP _0x4B
	RJMP _0x4A
_0x4B:
; 0000 0148             {
; 0000 0149             lcd_clear();
	RCALL _lcd_clear
; 0000 014A             screen=0;
	CLR  R8
	CLR  R9
; 0000 014B             left=1;
	RCALL SUBOPT_0x18
; 0000 014C             right=1;
; 0000 014D             flag_get_date=0;
	CLT
	BLD  R2,0
; 0000 014E             };
_0x4A:
; 0000 014F         if(OK==0)
	SBRC R2,5
	RJMP _0x4D
; 0000 0150             {
; 0000 0151             OK=1;
	RCALL SUBOPT_0x17
; 0000 0152             screen=2;
	RCALL SUBOPT_0x19
	MOVW R8,R30
; 0000 0153             }
; 0000 0154         break;
_0x4D:
	RJMP _0x3A
; 0000 0155     }
; 0000 0156 
; 0000 0157     case 2:
_0x49:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x4E
; 0000 0158     {
; 0000 0159                                                         // Настройка параметра 1. Вкл\выкл автокормушки
; 0000 015A         lcd_clear();
	RCALL _lcd_clear
; 0000 015B         lcd_gotoxy(1,0);
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x12
; 0000 015C         lcd_putsf("ABTOKOPMyLLIKA");
	RCALL SUBOPT_0x1A
; 0000 015D         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x14
; 0000 015E         lcd_putsf("PAR 1   ON  OFF");
	__POINTW2FN _0x0,77
	RCALL _lcd_putsf
; 0000 015F 
; 0000 0160         if(left==0)
	SBRC R2,3
	RJMP _0x4F
; 0000 0161             {
; 0000 0162             screen=10;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL SUBOPT_0x15
; 0000 0163             left=1;
; 0000 0164             }
; 0000 0165         if(right==0)
_0x4F:
	SBRC R2,4
	RJMP _0x50
; 0000 0166             {
; 0000 0167             screen=3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	MOVW R8,R30
; 0000 0168             right=1;
	RCALL SUBOPT_0x16
; 0000 0169             }
; 0000 016A         if(OK==0)
_0x50:
	SBRC R2,5
	RJMP _0x51
; 0000 016B             {
; 0000 016C             screen=20;
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	RCALL SUBOPT_0x1B
; 0000 016D             OK=1;
; 0000 016E             }
; 0000 016F         break;
_0x51:
	RJMP _0x3A
; 0000 0170     }
; 0000 0171 
; 0000 0172     case 3:
_0x4E:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x52
; 0000 0173     {
; 0000 0174         lcd_clear();
	RCALL _lcd_clear
; 0000 0175         lcd_gotoxy(4,0);
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x12
; 0000 0176         lcd_putsf("PODCBETKA");                       // Настройка параметра 2. Вкл\выкл света
	RCALL SUBOPT_0x1C
; 0000 0177         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x14
; 0000 0178         lcd_putsf("PAR 2   ON  OFF");
	__POINTW2FN _0x0,103
	RCALL _lcd_putsf
; 0000 0179 
; 0000 017A         if(left==0)
	SBRC R2,3
	RJMP _0x53
; 0000 017B             {
; 0000 017C             screen=2;
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x15
; 0000 017D             left=1;
; 0000 017E             }
; 0000 017F         if(right==0)
_0x53:
	SBRC R2,4
	RJMP _0x54
; 0000 0180             {
; 0000 0181             screen=10;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	MOVW R8,R30
; 0000 0182             right=1;
	RCALL SUBOPT_0x16
; 0000 0183             }
; 0000 0184         if(OK==0)
_0x54:
	SBRC R2,5
	RJMP _0x55
; 0000 0185             {
; 0000 0186             screen=30;
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	RCALL SUBOPT_0x1B
; 0000 0187             OK=1;
; 0000 0188             }
; 0000 0189         break;
_0x55:
	RJMP _0x3A
; 0000 018A     }
; 0000 018B 
; 0000 018C     case 10:                                            // Выход из настройки
_0x52:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x56
; 0000 018D     {
; 0000 018E         lcd_clear();
	RCALL _lcd_clear
; 0000 018F         lcd_gotoxy(5,0);
	LDI  R30,LOW(5)
	RCALL SUBOPT_0x12
; 0000 0190         lcd_putsf("EXIT?");
	__POINTW2FN _0x0,119
	RCALL _lcd_putsf
; 0000 0191 
; 0000 0192         if(left==0)
	SBRC R2,3
	RJMP _0x57
; 0000 0193             {
; 0000 0194             screen=3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RCALL SUBOPT_0x15
; 0000 0195             left=1;
; 0000 0196             }
; 0000 0197         if(right==0)
_0x57:
	SBRC R2,4
	RJMP _0x58
; 0000 0198             {
; 0000 0199             screen=2;
	RCALL SUBOPT_0x19
	MOVW R8,R30
; 0000 019A             right=1;
	RCALL SUBOPT_0x16
; 0000 019B             }
; 0000 019C         if(OK==0)
_0x58:
	SBRC R2,5
	RJMP _0x59
; 0000 019D             {
; 0000 019E             lcd_clear();
	RCALL _lcd_clear
; 0000 019F             flag_get_date=0;
	CLT
	BLD  R2,0
; 0000 01A0             screen=0;
	CLR  R8
	CLR  R9
; 0000 01A1             OK=1;
	RCALL SUBOPT_0x17
; 0000 01A2             }
; 0000 01A3         break;
_0x59:
	RJMP _0x3A
; 0000 01A4     }
; 0000 01A5 
; 0000 01A6     case 20:                                             // Вкл\выкл автокормушки
_0x56:
	CPI  R30,LOW(0x14)
	LDI  R26,HIGH(0x14)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x5A
; 0000 01A7     {
; 0000 01A8         lcd_clear();
	RCALL _lcd_clear
; 0000 01A9         if(left==0)
	SBRC R2,3
	RJMP _0x5B
; 0000 01AA             {
; 0000 01AB                 flag_activ_korm=1;
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x1D
; 0000 01AC                 left=1;
; 0000 01AD                 right=1;
; 0000 01AE             };
_0x5B:
; 0000 01AF         if(right==0)
	SBRC R2,4
	RJMP _0x5C
; 0000 01B0             {
; 0000 01B1                 flag_activ_korm=0;
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x1E
; 0000 01B2                 left=1;
; 0000 01B3                 right=1;
; 0000 01B4 
; 0000 01B5             };
_0x5C:
; 0000 01B6         if(flag_activ_korm==1)
	RCALL SUBOPT_0x11
	RCALL __EEPROMRDW
	RCALL SUBOPT_0xA
	BREQ PC+2
	RJMP _0x5D
; 0000 01B7             {
; 0000 01B8                 lcd_gotoxy(1,0);
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x12
; 0000 01B9                 lcd_putsf("ABTOKOPMyLLIKA");
	RCALL SUBOPT_0x1A
; 0000 01BA                 lcd_gotoxy(4,1);
	RCALL SUBOPT_0x1F
; 0000 01BB                 lcd_putsf("B K JI");
	__POINTW2FN _0x0,125
	RCALL _lcd_putsf
; 0000 01BC             }
; 0000 01BD         else
	RJMP _0x5E
_0x5D:
; 0000 01BE             {
; 0000 01BF                 lcd_gotoxy(1,0);
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x12
; 0000 01C0                 lcd_putsf("ABTOKOPMyLLIKA");
	RCALL SUBOPT_0x1A
; 0000 01C1                 lcd_gotoxy(4,1);
	RCALL SUBOPT_0x1F
; 0000 01C2                 lcd_putsf("B bI K JI");
	__POINTW2FN _0x0,132
	RCALL _lcd_putsf
; 0000 01C3             }
_0x5E:
; 0000 01C4         if(OK==0)
	SBRC R2,5
	RJMP _0x5F
; 0000 01C5             {
; 0000 01C6                 screen=2;
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x1B
; 0000 01C7                 OK=1;
; 0000 01C8             }
; 0000 01C9         break;
_0x5F:
	RJMP _0x3A
; 0000 01CA     }
; 0000 01CB 
; 0000 01CC         case 30:                                             // Вкл\выкл подсветки
_0x5A:
	CPI  R30,LOW(0x1E)
	LDI  R26,HIGH(0x1E)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x3A
; 0000 01CD     {
; 0000 01CE         lcd_clear();
	RCALL _lcd_clear
; 0000 01CF         if(left==0)
	SBRC R2,3
	RJMP _0x61
; 0000 01D0             {
; 0000 01D1                 flag_activ_svet=1;
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x1D
; 0000 01D2                 left=1;
; 0000 01D3                 right=1;
; 0000 01D4             };
_0x61:
; 0000 01D5         if(right==0)
	SBRC R2,4
	RJMP _0x62
; 0000 01D6             {
; 0000 01D7                 flag_activ_svet=0;
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x1E
; 0000 01D8 
; 0000 01D9                 left=1;
; 0000 01DA                 right=1;
; 0000 01DB             };
_0x62:
; 0000 01DC         if(flag_activ_svet==1)
	RCALL SUBOPT_0x13
	RCALL __EEPROMRDW
	RCALL SUBOPT_0xA
	BREQ PC+2
	RJMP _0x63
; 0000 01DD             {
; 0000 01DE                 lcd_gotoxy(4,0);
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x12
; 0000 01DF                 lcd_putsf("PODCBETKA");
	RCALL SUBOPT_0x1C
; 0000 01E0                 lcd_gotoxy(4,1);
	RCALL SUBOPT_0x1F
; 0000 01E1                 lcd_putsf("B K JI");
	__POINTW2FN _0x0,125
	RCALL _lcd_putsf
; 0000 01E2             }
; 0000 01E3         else
	RJMP _0x64
_0x63:
; 0000 01E4             {
; 0000 01E5                 lcd_gotoxy(4,0);
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x12
; 0000 01E6                 lcd_putsf("PODCBETKA");
	RCALL SUBOPT_0x1C
; 0000 01E7                 lcd_gotoxy(4,1);
	RCALL SUBOPT_0x1F
; 0000 01E8                 lcd_putsf("B bI K JI");
	__POINTW2FN _0x0,132
	RCALL _lcd_putsf
; 0000 01E9             }
_0x64:
; 0000 01EA         if(OK==0)
	SBRC R2,5
	RJMP _0x65
; 0000 01EB             {
; 0000 01EC                 screen=3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RCALL SUBOPT_0x1B
; 0000 01ED                 OK=1;
; 0000 01EE             }
; 0000 01EF         break;
_0x65:
; 0000 01F0     }
; 0000 01F1 
; 0000 01F2 }
_0x3A:
; 0000 01F3 
; 0000 01F4 if(counter_sec%10==0)               // Опрос кнопок каждую секунду
	MOVW R26,R6
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	SBIW R30,0
	BREQ PC+2
	RJMP _0x66
; 0000 01F5     {
; 0000 01F6         if(left_button==0)
	SBIC 0x16,4
	RJMP _0x67
; 0000 01F7             left=0;
	CLT
	BLD  R2,3
; 0000 01F8         if(right_button==0)
_0x67:
	SBIC 0x16,3
	RJMP _0x68
; 0000 01F9             right=0;
	CLT
	BLD  R2,4
; 0000 01FA         if(OK_button==0)
_0x68:
	SBIC 0x16,2
	RJMP _0x69
; 0000 01FB             OK=0;
	CLT
	BLD  R2,5
; 0000 01FC     }
_0x69:
; 0000 01FD 
; 0000 01FE if(flag_activ_korm==1 && DateTime.Hour == 20 && flag_start_motor == 0 && flag_feed == 0)
_0x66:
	RCALL SUBOPT_0x11
	RCALL __EEPROMRDW
	SBIW R30,1
	BREQ PC+2
	RJMP _0x6B
	RCALL SUBOPT_0x8
	SBIW R26,20
	BREQ PC+2
	RJMP _0x6B
	SBRC R2,1
	RJMP _0x6B
	SBRC R2,6
	RJMP _0x6B
	RJMP _0x6C
_0x6B:
	RJMP _0x6A
_0x6C:
; 0000 01FF     {
; 0000 0200         flag_start_motor=1;
	SET
	BLD  R2,1
; 0000 0201         flag_forward=0;
	CLT
	BLD  R2,2
; 0000 0202         flag_feed=1;
	SET
	BLD  R2,6
; 0000 0203         flag_first_move=1;
	BLD  R2,7
; 0000 0204     }
; 0000 0205 
; 0000 0206 if(DateTime.Hour != 20)
_0x6A:
	RCALL SUBOPT_0x8
	SBIW R26,20
	BRNE PC+2
	RJMP _0x6D
; 0000 0207     flag_feed=0;
	CLT
	BLD  R2,6
; 0000 0208 
; 0000 0209 if(flag_start_motor == 1 && flag_forward == 0 && steps == 0 && flag_first_move==1)
_0x6D:
	SBRS R2,1
	RJMP _0x6F
	SBRC R2,2
	RJMP _0x6F
	RCALL SUBOPT_0x9
	BREQ PC+2
	RJMP _0x6F
	SBRS R2,7
	RJMP _0x6F
	RJMP _0x70
_0x6F:
	RJMP _0x6E
_0x70:
; 0000 020A {
; 0000 020B     steps = step * 30;
	__GETD1N 0x1E000
	RCALL SUBOPT_0x20
; 0000 020C     flag_first_move=0;
	CLT
	BLD  R2,7
; 0000 020D }
; 0000 020E 
; 0000 020F if(flag_start_motor == 1 && flag_forward == 0 && steps == 0 && flag_first_move == 0)
_0x6E:
	SBRS R2,1
	RJMP _0x72
	SBRC R2,2
	RJMP _0x72
	RCALL SUBOPT_0x9
	BREQ PC+2
	RJMP _0x72
	SBRC R2,7
	RJMP _0x72
	RJMP _0x73
_0x72:
	RJMP _0x71
_0x73:
; 0000 0210 {
; 0000 0211     flag_forward = 1;
	SET
	BLD  R2,2
; 0000 0212     flag_start_motor=0;
	CLT
	BLD  R2,1
; 0000 0213     steps = step * 50;
	__GETD1N 0x32000
	RCALL SUBOPT_0x20
; 0000 0214     flag_return=1;
	SET
	BLD  R3,0
; 0000 0215 }
; 0000 0216 
; 0000 0217 if(flag_return == 1 && steps==0 && flag_forward==1)
_0x71:
	SBRS R3,0
	RJMP _0x75
	RCALL SUBOPT_0x9
	BREQ PC+2
	RJMP _0x75
	SBRS R2,2
	RJMP _0x75
	RJMP _0x76
_0x75:
	RJMP _0x74
_0x76:
; 0000 0218 {
; 0000 0219     flag_forward = 0;
	CLT
	BLD  R2,2
; 0000 021A     steps = step * 20;
	__GETD1N 0x14000
	RCALL SUBOPT_0x20
; 0000 021B     flag_return=0;
	CLT
	BLD  R3,0
; 0000 021C }
; 0000 021D 
; 0000 021E if(flag_activ_svet == 1 && (DateTime.Hour > 8 && DateTime.Hour < 23))
_0x74:
	RCALL SUBOPT_0x13
	RCALL __EEPROMRDW
	SBIW R30,1
	BREQ PC+2
	RJMP _0x78
	RCALL SUBOPT_0x8
	SBIW R26,9
	BRGE PC+2
	RJMP _0x79
	RCALL SUBOPT_0x8
	SBIW R26,23
	BRLT PC+2
	RJMP _0x79
	RJMP _0x7A
_0x79:
	RJMP _0x78
_0x7A:
	RJMP _0x7B
_0x78:
	RJMP _0x77
_0x7B:
; 0000 021F     {
; 0000 0220     PORTB.5 = 1;
	SBI  0x18,5
; 0000 0221     }
; 0000 0222 else
	RJMP _0x7E
_0x77:
; 0000 0223     {
; 0000 0224     PORTB.5 = 0;
	CBI  0x18,5
; 0000 0225     }
_0x7E:
; 0000 0226 
; 0000 0227 counter_sec++;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0000 0228 if (counter_sec>50)
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	CP   R30,R6
	CPC  R31,R7
	BRLT PC+2
	RJMP _0x81
; 0000 0229     counter_sec=0;
	CLR  R6
	CLR  R7
; 0000 022A }
_0x81:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;
;void main(void)
; 0000 022E {
_main:
; .FSTART _main
; 0000 022F // Declare your local variables here
; 0000 0230 
; 0000 0231 // Input/Output Ports initialization
; 0000 0232 // Port B initialization
; 0000 0233 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 0234 DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(227)
	OUT  0x17,R30
; 0000 0235 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 0236 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (1<<PORTB4) | (1<<PORTB3) | (1<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(28)
	OUT  0x18,R30
; 0000 0237 
; 0000 0238 // Port C initialization
; 0000 0239 // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=Out Bit0=Out
; 0000 023A DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (1<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(3)
	OUT  0x14,R30
; 0000 023B // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=0 Bit0=0
; 0000 023C PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 023D 
; 0000 023E // Port D initialization
; 0000 023F // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 0240 DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 0241 // State: Bit7=1 Bit6=1 Bit5=1 Bit4=1 Bit3=1 Bit2=1 Bit1=1 Bit0=1
; 0000 0242 PORTD=(1<<PORTD7) | (1<<PORTD6) | (1<<PORTD5) | (1<<PORTD4) | (1<<PORTD3) | (1<<PORTD2) | (1<<PORTD1) | (1<<PORTD0);
	OUT  0x12,R30
; 0000 0243 
; 0000 0244 // Timer/Counter 0 initialization
; 0000 0245 // Clock source: System Clock
; 0000 0246 // Clock value: 7,813 kHz
; 0000 0247 //TCCR0=(1<<CS02) | (0<<CS01) | (1<<CS00);
; 0000 0248 //TCNT0=0xB2;
; 0000 0249 TCCR0=(0<<CS02) | (1<<CS01) | (1<<CS00);
	LDI  R30,LOW(3)
	OUT  0x33,R30
; 0000 024A TCNT0=0x83;
	LDI  R30,LOW(131)
	OUT  0x32,R30
; 0000 024B 
; 0000 024C // Timer/Counter 1 initialization
; 0000 024D // Clock source: System Clock
; 0000 024E // Clock value: 125,000 kHz
; 0000 024F // Mode: Normal top=0xFFFF
; 0000 0250 // OC1A output: Disconnected
; 0000 0251 // OC1B output: Disconnected
; 0000 0252 // Noise Canceler: Off
; 0000 0253 // Input Capture on Falling Edge
; 0000 0254 // Timer Period: 0,5 s
; 0000 0255 // Timer1 Overflow Interrupt: On
; 0000 0256 // Input Capture Interrupt: Off
; 0000 0257 // Compare A Match Interrupt: Off
; 0000 0258 // Compare B Match Interrupt: Off
; 0000 0259 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 025A TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (1<<CS11) | (1<<CS10);
	LDI  R30,LOW(3)
	OUT  0x2E,R30
; 0000 025B TCNT1H=0x0B;
	LDI  R30,LOW(11)
	OUT  0x2D,R30
; 0000 025C TCNT1L=0xDC;
	LDI  R30,LOW(220)
	OUT  0x2C,R30
; 0000 025D ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
; 0000 025E ICR1L=0x00;
	OUT  0x26,R30
; 0000 025F OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0260 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0261 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0262 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0263 
; 0000 0264 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0265 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (1<<TOIE0);
	LDI  R30,LOW(5)
	OUT  0x39,R30
; 0000 0266 
; 0000 0267 
; 0000 0268 // Alphanumeric LCD initialization
; 0000 0269 // Connections are specified in the
; 0000 026A // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 026B // RS - PORTD Bit 0
; 0000 026C // RD - PORTB Bit 1
; 0000 026D // EN - PORTD Bit 1
; 0000 026E // D4 - PORTD Bit 2
; 0000 026F // D5 - PORTD Bit 3
; 0000 0270 // D6 - PORTD Bit 4
; 0000 0271 // D7 - PORTB Bit 6
; 0000 0272 // Characters/line: 16
; 0000 0273 lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 0274 
; 0000 0275 /*
; 0000 0276 
; 0000 0277 if(flag_set_time<0 && flag_set_time>0)
; 0000 0278 {
; 0000 0279    // Задаем время и параметры (AM/PM следует задавать только при H12)
; 0000 027A     DateTime.Sec = 0;
; 0000 027B     DateTime.Min = 13;
; 0000 027C     DateTime.Hour = 21;
; 0000 027D     DateTime.Month = 9;
; 0000 027E     DateTime.Day = 27;
; 0000 027F     DateTime.Year = 18;
; 0000 0280     //DateTime.WeekDay = 2;
; 0000 0281     //DateTime.AMPM = AM;   //AM/PM
; 0000 0282     DateTime.H12_24 = H24;  //H12/H24
; 0000 0283 
; 0000 0284 // Записываем время в микросхему ds1302
; 0000 0285     DS1302_WriteDateTime();
; 0000 0286 
; 0000 0287     flag_set_time = 1;
; 0000 0288 
; 0000 0289 }
; 0000 028A 
; 0000 028B  */
; 0000 028C 
; 0000 028D // Global enable interrupts
; 0000 028E #asm("sei")
	sei
; 0000 028F 
; 0000 0290 while (1)
_0x82:
; 0000 0291       {
; 0000 0292 
; 0000 0293 
; 0000 0294       }
	RJMP _0x82
_0x84:
; 0000 0295 }
_0x85:
	RJMP _0x85
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G100:
; .FSTART _put_buff_G100
	RCALL SUBOPT_0x0
	RCALL __SAVELOCR2
	RCALL SUBOPT_0x21
	ADIW R26,2
	RCALL __GETW1P
	SBIW R30,0
	BRNE PC+2
	RJMP _0x2000010
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x22
	MOVW R16,R30
	SBIW R30,0
	BREQ PC+2
	RJMP _0x2000011
	RJMP _0x2000012
_0x2000011:
	__CPWRN 16,17,2
	BRSH PC+2
	RJMP _0x2000013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2000012:
	RCALL SUBOPT_0x21
	ADIW R26,2
	RCALL SUBOPT_0x23
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2000013:
	RCALL SUBOPT_0x21
	RCALL __GETW1P
	TST  R31
	BRPL PC+2
	RJMP _0x2000014
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x23
_0x2000014:
	RJMP _0x2000015
_0x2000010:
	RCALL SUBOPT_0x21
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RCALL SUBOPT_0x5
_0x2000015:
	RCALL __LOADLOCR2
	ADIW R28,5
	RET
; .FEND
__print_G100:
; .FSTART __print_G100
	RCALL SUBOPT_0x0
	SBIW R28,6
	RCALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RCALL SUBOPT_0x5
_0x2000016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BREQ PC+2
	RJMP _0x200001C
	CPI  R18,37
	BREQ PC+2
	RJMP _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	RCALL SUBOPT_0x24
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BREQ PC+2
	RJMP _0x200001F
	CPI  R18,37
	BREQ PC+2
	RJMP _0x2000020
	RCALL SUBOPT_0x24
	LDI  R17,LOW(0)
	RJMP _0x200001B
_0x2000020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BREQ PC+2
	RJMP _0x2000021
	LDI  R16,LOW(1)
	RJMP _0x200001B
_0x2000021:
	CPI  R18,43
	BREQ PC+2
	RJMP _0x2000022
	LDI  R20,LOW(43)
	RJMP _0x200001B
_0x2000022:
	CPI  R18,32
	BREQ PC+2
	RJMP _0x2000023
	LDI  R20,LOW(32)
	RJMP _0x200001B
_0x2000023:
	RJMP _0x2000024
_0x200001F:
	CPI  R30,LOW(0x2)
	BREQ PC+2
	RJMP _0x2000025
_0x2000024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BREQ PC+2
	RJMP _0x2000026
	ORI  R16,LOW(128)
	RJMP _0x200001B
_0x2000026:
	RJMP _0x2000027
_0x2000025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x200001B
_0x2000027:
	CPI  R18,48
	BRSH PC+2
	RJMP _0x200002A
	CPI  R18,58
	BRLO PC+2
	RJMP _0x200002A
	RJMP _0x200002B
_0x200002A:
	RJMP _0x2000029
_0x200002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200001B
_0x2000029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BREQ PC+2
	RJMP _0x200002F
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x25
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x27
	RJMP _0x2000030
	RJMP _0x2000031
_0x200002F:
	CPI  R30,LOW(0x73)
	BREQ PC+2
	RJMP _0x2000032
_0x2000031:
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x2A
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
	RJMP _0x2000034
_0x2000032:
	CPI  R30,LOW(0x70)
	BREQ PC+2
	RJMP _0x2000035
_0x2000034:
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x2A
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2000036
	RJMP _0x2000037
_0x2000035:
	CPI  R30,LOW(0x64)
	BREQ PC+2
	RJMP _0x2000038
_0x2000037:
	RJMP _0x2000039
_0x2000038:
	CPI  R30,LOW(0x69)
	BREQ PC+2
	RJMP _0x200003A
_0x2000039:
	ORI  R16,LOW(4)
	RJMP _0x200003B
_0x200003A:
	CPI  R30,LOW(0x75)
	BREQ PC+2
	RJMP _0x200003C
_0x200003B:
	LDI  R30,LOW(_tbl10_G100*2)
	LDI  R31,HIGH(_tbl10_G100*2)
	RCALL SUBOPT_0x2B
	LDI  R17,LOW(5)
	RJMP _0x200003D
	RJMP _0x200003E
_0x200003C:
	CPI  R30,LOW(0x58)
	BREQ PC+2
	RJMP _0x200003F
_0x200003E:
	ORI  R16,LOW(8)
	RJMP _0x2000040
_0x200003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2000071
_0x2000040:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	RCALL SUBOPT_0x2B
	LDI  R17,LOW(4)
_0x200003D:
	SBRS R16,2
	RJMP _0x2000042
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x2C
	LDD  R26,Y+11
	TST  R26
	BRMI PC+2
	RJMP _0x2000043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RCALL __ANEGW1
	RCALL SUBOPT_0x2C
	LDI  R20,LOW(45)
_0x2000043:
	CPI  R20,0
	BRNE PC+2
	RJMP _0x2000044
	SUBI R17,-LOW(1)
	RJMP _0x2000045
_0x2000044:
	ANDI R16,LOW(251)
_0x2000045:
	RJMP _0x2000046
_0x2000042:
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x2C
_0x2000046:
_0x2000036:
	SBRC R16,0
	RJMP _0x2000047
_0x2000048:
	CP   R17,R21
	BRLO PC+2
	RJMP _0x200004A
	SBRS R16,7
	RJMP _0x200004B
	SBRS R16,2
	RJMP _0x200004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x200004D
_0x200004C:
	LDI  R18,LOW(48)
_0x200004D:
	RJMP _0x200004E
_0x200004B:
	LDI  R18,LOW(32)
_0x200004E:
	RCALL SUBOPT_0x24
	SUBI R21,LOW(1)
	RJMP _0x2000048
_0x200004A:
_0x2000047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x200004F
_0x2000050:
	CPI  R19,0
	BRNE PC+2
	RJMP _0x2000052
	SBRS R16,3
	RJMP _0x2000053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	RCALL SUBOPT_0x2B
	RJMP _0x2000054
_0x2000053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000054:
	RCALL SUBOPT_0x24
	CPI  R21,0
	BRNE PC+2
	RJMP _0x2000055
	SUBI R21,LOW(1)
_0x2000055:
	SUBI R19,LOW(1)
	RJMP _0x2000050
_0x2000052:
	RJMP _0x2000056
_0x200004F:
_0x2000058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	RCALL SUBOPT_0x2B
_0x200005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRSH PC+2
	RJMP _0x200005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	RCALL SUBOPT_0x2C
	RJMP _0x200005A
_0x200005C:
	CPI  R18,58
	BRSH PC+2
	RJMP _0x200005D
	SBRS R16,3
	RJMP _0x200005E
	SUBI R18,-LOW(7)
	RJMP _0x200005F
_0x200005E:
	SUBI R18,-LOW(39)
_0x200005F:
_0x200005D:
	SBRS R16,4
	RJMP _0x2000060
	RJMP _0x2000061
_0x2000060:
	CPI  R18,49
	BRLO PC+2
	RJMP _0x2000063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE PC+2
	RJMP _0x2000063
	RJMP _0x2000062
_0x2000063:
	ORI  R16,LOW(16)
	RJMP _0x2000065
_0x2000062:
	CP   R21,R19
	BRSH PC+2
	RJMP _0x2000067
	SBRC R16,0
	RJMP _0x2000067
	RJMP _0x2000068
_0x2000067:
	RJMP _0x2000066
_0x2000068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2000069
	LDI  R18,LOW(48)
	ORI  R16,LOW(16)
_0x2000065:
	SBRS R16,2
	RJMP _0x200006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	RCALL SUBOPT_0x27
	CPI  R21,0
	BRNE PC+2
	RJMP _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	RCALL SUBOPT_0x24
	CPI  R21,0
	BRNE PC+2
	RJMP _0x200006C
	SUBI R21,LOW(1)
_0x200006C:
_0x2000066:
	SUBI R19,LOW(1)
_0x2000057:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRSH PC+2
	RJMP _0x2000059
	RJMP _0x2000058
_0x2000059:
_0x2000056:
	SBRS R16,0
	RJMP _0x200006D
_0x200006E:
	CPI  R21,0
	BRNE PC+2
	RJMP _0x2000070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0x27
	RJMP _0x200006E
_0x2000070:
_0x200006D:
_0x2000071:
_0x2000030:
	LDI  R17,LOW(0)
_0x200002E:
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RCALL __GETW1P
	RCALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	RCALL __SAVELOCR4
	RCALL SUBOPT_0x2D
	SBIW R30,0
	BREQ PC+2
	RJMP _0x2000072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RCALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
_0x2000072:
	MOVW R26,R28
	ADIW R26,6
	RCALL __ADDW2R15
	MOVW R16,R26
	RCALL SUBOPT_0x2D
	RCALL SUBOPT_0x2B
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __ADDW2R15
	RCALL __GETW1P
	RCALL SUBOPT_0xC
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	RCALL SUBOPT_0xC
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G100
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
	RCALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G101:
; .FSTART __lcd_write_nibble_G101
	ST   -Y,R26
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BRNE PC+2
	RJMP _0x2020004
	SBI  0x12,2
	RJMP _0x2020005
_0x2020004:
	CBI  0x12,2
_0x2020005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BRNE PC+2
	RJMP _0x2020006
	SBI  0x12,3
	RJMP _0x2020007
_0x2020006:
	CBI  0x12,3
_0x2020007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BRNE PC+2
	RJMP _0x2020008
	SBI  0x12,4
	RJMP _0x2020009
_0x2020008:
	CBI  0x12,4
_0x2020009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BRNE PC+2
	RJMP _0x202000A
	SBI  0x18,6
	RJMP _0x202000B
_0x202000A:
	CBI  0x18,6
_0x202000B:
	RCALL SUBOPT_0x2E
	SBI  0x12,1
	RCALL SUBOPT_0x2E
	CBI  0x12,1
	RCALL SUBOPT_0x2E
	ADIW R28,1
	RET
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G101
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G101
	__DELAY_USB 133
	ADIW R28,1
	RET
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G101)
	SBCI R31,HIGH(-__base_y_G101)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	RCALL SUBOPT_0x2F
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x2F
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE PC+2
	RJMP _0x2020011
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO PC+2
	RJMP _0x2020011
	RJMP _0x2020010
_0x2020011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ PC+2
	RJMP _0x2020013
	ADIW R28,1
	RET
_0x2020013:
_0x2020010:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x12,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x12,0
	ADIW R28,1
	RET
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	RCALL SUBOPT_0x0
	ST   -Y,R17
_0x2020014:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2020016
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2020014
_0x2020016:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_putsf:
; .FSTART _lcd_putsf
	RCALL SUBOPT_0x0
	ST   -Y,R17
_0x2020017:
	RCALL SUBOPT_0x1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2020019
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2020017
_0x2020019:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	SBI  0x11,2
	SBI  0x11,3
	SBI  0x11,4
	SBI  0x17,6
	SBI  0x11,1
	SBI  0x11,0
	SBI  0x17,1
	CBI  0x12,1
	CBI  0x12,0
	CBI  0x18,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G101,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G101,3
	LDI  R26,LOW(20)
	LDI  R27,0
	RCALL _delay_ms
	RCALL SUBOPT_0x30
	RCALL SUBOPT_0x30
	RCALL SUBOPT_0x30
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G101
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
	ADIW R28,1
	RET
; .FEND

	.CSEG

	.CSEG
_strlen:
; .FSTART _strlen
	RCALL SUBOPT_0x0
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	RCALL SUBOPT_0x0
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.DSEG
_buffer:
	.BYTE 0x10
_steps:
	.BYTE 0x4

	.ESEG
_flag_activ_korm:
	.DB  0x0,0x0
_flag_activ_svet:
	.DB  0x0,0x0

	.DSEG
_DateTime:
	.BYTE 0x12
__base_y_G101:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x0:
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2:
	__DELAY_USB 3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	MOV  R30,R17
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	RCALL __LSLW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x4:
	RCALL _ds1302_write
	RCALL _ds1302_read
	LDI  R31,0
	MOVW R26,R30
	RJMP _DS1302_BCD_To_Bin8

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x6:
	__GETW1MN _DateTime,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x7:
	__PUTW1MN _DateTime,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x8:
	__GETW2MN _DateTime,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x9:
	LDS  R26,_steps
	LDS  R27,_steps+1
	LDS  R24,_steps+2
	LDS  R25,_steps+3
	RCALL __CPD02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xA:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0xD:
	RCALL __CWD1
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xE:
	LDI  R24,12
	RCALL _sprintf
	ADIW R28,16
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xF:
	LDI  R26,LOW(0)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x10:
	LDI  R26,LOW(1)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x11:
	LDI  R26,LOW(_flag_activ_korm)
	LDI  R27,HIGH(_flag_activ_korm)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x12:
	ST   -Y,R30
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x13:
	LDI  R26,LOW(_flag_activ_svet)
	LDI  R27,HIGH(_flag_activ_svet)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x14:
	ST   -Y,R30
	RJMP SUBOPT_0x10

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x15:
	MOVW R8,R30
	SET
	BLD  R2,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x16:
	SET
	BLD  R2,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x17:
	SET
	BLD  R2,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x18:
	SET
	BLD  R2,3
	RJMP SUBOPT_0x16

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1A:
	__POINTW2FN _0x0,62
	RJMP _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	MOVW R8,R30
	RJMP SUBOPT_0x17

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1C:
	__POINTW2FN _0x0,93
	RJMP _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RCALL __EEPROMWRW
	RJMP SUBOPT_0x18

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RCALL __EEPROMWRW
	RJMP SUBOPT_0x18

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	LDI  R30,LOW(4)
	RJMP SUBOPT_0x14

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x20:
	STS  _steps,R30
	STS  _steps+1,R31
	STS  _steps+2,R22
	STS  _steps+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x21:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x22:
	ADIW R26,4
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x23:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x24:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x25:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x26:
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x27:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	RCALL SUBOPT_0x25
	RJMP SUBOPT_0x26

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x29:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	RJMP SUBOPT_0x22

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2A:
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2B:
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2C:
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2D:
	MOVW R26,R28
	ADIW R26,12
	RCALL __ADDW2R15
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2E:
	__DELAY_USB 13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2F:
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x30:
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G101
	__DELAY_USW 200
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSLW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __LSLW12R
__LSLW12L:
	LSL  R30
	ROL  R31
	DEC  R0
	BRNE __LSLW12L
__LSLW12R:
	RET

__ASRW4:
	ASR  R31
	ROR  R30
__ASRW3:
	ASR  R31
	ROR  R30
__ASRW2:
	ASR  R31
	ROR  R30
	ASR  R31
	ROR  R30
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P_INC:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	RET

__PUTDP1_DEC:
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
