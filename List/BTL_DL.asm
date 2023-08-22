
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega16
;Program type             : Application
;Clock frequency          : 8.000000 MHz
;Memory model             : Small
;Optimize for             : Speed
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: Yes
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1119
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

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
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
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
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	.DEF _rx_wr_index=R5
	.DEF _rx_rd_index=R4
	.DEF _rx_counter=R7
	.DEF _Data=R6
	.DEF _str_adc=R8
	.DEF _str_nguong=R10
	.DEF _Temp=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart_rx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _ext_int2_isr
	JMP  0x00
	JMP  0x00

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0
_conv_delay_G104:
	.DB  0x64,0x0,0xC8,0x0,0x90,0x1,0x20,0x3
_bit_mask_G104:
	.DB  0xF8,0xFF,0xFC,0xFF,0xFE,0xFF,0xFF,0xFF

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0xA:
	.DB  0x64
_0xB:
	.DB  0x96
_0xC:
	.DB  0x3
_0xD:
	.DB  0x50
_0xE:
	.DB  0x1E
_0x0:
	.DB  0x25,0x35,0x69,0x0,0x20,0x0,0x43,0x41
	.DB  0x4E,0x48,0x20,0x42,0x41,0x4F,0x20,0x43
	.DB  0x48,0x41,0x59,0x0,0x4D,0x55,0x43,0x20
	.DB  0x31,0x0,0x4D,0x55,0x43,0x20,0x32,0x0
	.DB  0x43,0x41,0x4E,0x48,0x20,0x42,0x41,0x4F
	.DB  0x0,0x44,0x4B,0x20,0x50,0x48,0x4F,0x4E
	.DB  0x47,0x0,0x4E,0x64,0x0,0x41,0x73,0x0
	.DB  0x4E,0x67,0x75,0x6F,0x6E,0x67,0x5F,0x4E
	.DB  0x64,0x0,0x31,0x5F,0x4E,0x67,0x75,0x6F
	.DB  0x6E,0x67,0x5F,0x41,0x73,0x0,0x32,0x5F
	.DB  0x4E,0x67,0x75,0x6F,0x6E,0x67,0x5F,0x41
	.DB  0x73,0x0,0x61,0x31,0x2D,0x0,0x61,0x31
	.DB  0x2B,0x0,0x61,0x32,0x2B,0x0,0x61,0x32
	.DB  0x2D,0x0,0x61,0x33,0x5F,0x31,0x2D,0x0
	.DB  0x61,0x33,0x5F,0x32,0x2D,0x0,0x61,0x33
	.DB  0x2B,0x0,0x4E,0x48,0x49,0x45,0x54,0x20
	.DB  0x44,0x4F,0x3A,0x0,0x4E,0x47,0x55,0x4F
	.DB  0x4E,0x47,0x20,0x3A,0x20,0x25,0x34,0x69
	.DB  0x0,0x43,0x41,0x4E,0x48,0x20,0x42,0x41
	.DB  0x4F,0x20,0x43,0x48,0x41,0x59,0x3A,0x0
	.DB  0x4E,0x47,0x55,0x4F,0x4E,0x47,0x20,0x31
	.DB  0x20,0x3A,0x20,0x25,0x34,0x69,0x0,0x4E
	.DB  0x47,0x55,0x4F,0x4E,0x47,0x20,0x32,0x20
	.DB  0x3A,0x20,0x25,0x34,0x69,0x0,0x41,0x4E
	.DB  0x48,0x20,0x53,0x41,0x4E,0x47,0x3A,0x0
	.DB  0x4E,0x47,0x55,0x4F,0x4E,0x47,0x20,0x31
	.DB  0x3A,0x20,0x25,0x34,0x69,0x0,0x4E,0x47
	.DB  0x55,0x4F,0x4E,0x47,0x20,0x32,0x3A,0x20
	.DB  0x25,0x34,0x69,0x0,0x57,0x41,0x49,0x54
	.DB  0x49,0x4E,0x47,0x20,0x46,0x4F,0x52,0x0
	.DB  0x53,0x45,0x54,0x54,0x49,0x4E,0x47,0x20
	.DB  0x55,0x50,0x0,0x42,0x54,0x4C,0x20,0x44
	.DB  0x4C,0x54,0x44,0x44,0x4B,0x0,0x42,0x59
	.DB  0x3A,0x20,0x53,0x43,0x4E,0x54,0x20,0x47
	.DB  0x52,0x4F,0x55,0x50,0x0,0x53,0x45,0x54
	.DB  0x20,0x55,0x50,0x0,0x50,0x4C,0x45,0x41
	.DB  0x53,0x45,0x21,0x0,0x41,0x4E,0x20,0x54
	.DB  0x4F,0x41,0x4E,0x0
_0x2000003:
	.DB  0x80,0xC0
_0x2040060:
	.DB  0x1
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x01
	.DW  _nguong_khoi_1
	.DW  _0xA*2

	.DW  0x01
	.DW  _nguong_khoi_2
	.DW  _0xB*2

	.DW  0x01
	.DW  _nguong_as_1
	.DW  _0xC*2

	.DW  0x01
	.DW  _nguong_as_2
	.DW  _0xD*2

	.DW  0x01
	.DW  _nguong_nhiet
	.DW  _0xE*2

	.DW  0x02
	.DW  _0x30
	.DW  _0x0*2+4

	.DW  0x0E
	.DW  _0x3E
	.DW  _0x0*2+6

	.DW  0x06
	.DW  _0x3E+14
	.DW  _0x0*2+20

	.DW  0x0E
	.DW  _0x3E+20
	.DW  _0x0*2+6

	.DW  0x06
	.DW  _0x3E+34
	.DW  _0x0*2+26

	.DW  0x09
	.DW  _0x3E+40
	.DW  _0x0*2+32

	.DW  0x09
	.DW  _0x3E+49
	.DW  _0x0*2+41

	.DW  0x0A
	.DW  _0x6A
	.DW  _0x0*2+122

	.DW  0x0F
	.DW  _0x6A+10
	.DW  _0x0*2+145

	.DW  0x0F
	.DW  _0x6A+25
	.DW  _0x0*2+145

	.DW  0x0A
	.DW  _0x6A+40
	.DW  _0x0*2+190

	.DW  0x0A
	.DW  _0x6A+50
	.DW  _0x0*2+190

	.DW  0x0C
	.DW  _0x6A+60
	.DW  _0x0*2+228

	.DW  0x0B
	.DW  _0x6A+72
	.DW  _0x0*2+240

	.DW  0x0B
	.DW  _0x70
	.DW  _0x0*2+251

	.DW  0x0F
	.DW  _0x70+11
	.DW  _0x0*2+262

	.DW  0x07
	.DW  _0x70+26
	.DW  _0x0*2+277

	.DW  0x08
	.DW  _0x70+33
	.DW  _0x0*2+284

	.DW  0x08
	.DW  _0x70+41
	.DW  _0x0*2+292

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

	.DW  0x01
	.DW  __seed_G102
	.DW  _0x2040060*2

_0xFFFFFFFF:
	.DW  0

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

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

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

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;#include <main.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <main.h>
;
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 8
;char rx_buffer[RX_BUFFER_SIZE];
;
;#if RX_BUFFER_SIZE <= 256
;unsigned char rx_wr_index,rx_rd_index,rx_counter;
;#else
;unsigned int rx_wr_index,rx_rd_index,rx_counter;
;#endif
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;// TRINH PHUC VU NGAT DE NHAN DU LIEU
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 0001 {

	.CSEG
_usart_rx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;char status,data;
;status=UCSRA;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,11
;data=UDR;
	IN   R16,12
;if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x3
;   {
;   rx_buffer[rx_wr_index++]=data;
	MOV  R30,R5
	INC  R5
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
;#if RX_BUFFER_SIZE == 256
;   // special case for receiver buffer size=256
;   if (++rx_counter == 0)
;      {
;#else
;   if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	LDI  R30,LOW(8)
	CP   R30,R5
	BRNE _0x4
	CLR  R5
;   if (++rx_counter == RX_BUFFER_SIZE)
_0x4:
	INC  R7
	LDI  R30,LOW(8)
	CP   R30,R7
	BRNE _0x5
;      {
;      rx_counter=0;
	CLR  R7
;#endif
;      rx_buffer_overflow=1;
	SET
	BLD  R2,0
;      }
;   }
_0x5:
;}
_0x3:
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
;{
;char data;
;while (rx_counter==0);
;	data -> R17
;data=rx_buffer[rx_rd_index++];
;#if RX_BUFFER_SIZE != 256
;if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
;#endif
;#asm("cli")
;--rx_counter;
;#asm("sei")
;return data;
;}
;#pragma used-
;#endif
;// ------------------END OF FILE-------------------
;// ------------------------------------------------

	.DSEG

	.CSEG
_but_ton_khoi_1:
	SBIC 0x16,3
	RJMP _0xF
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	SBIC 0x16,3
	RJMP _0x10
	LDI  R26,LOW(_nguong_khoi_1)
	LDI  R27,HIGH(_nguong_khoi_1)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDS  R26,_nguong_khoi_1
	LDS  R27,_nguong_khoi_1+1
	CPI  R26,LOW(0x3FF)
	LDI  R30,HIGH(0x3FF)
	CPC  R27,R30
	BRLO _0x11
	LDI  R30,LOW(0)
	STS  _nguong_khoi_1,R30
	STS  _nguong_khoi_1+1,R30
_0x11:
_0x10:
_0xF:
	SBIC 0x16,4
	RJMP _0x12
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	SBIC 0x16,4
	RJMP _0x13
	LDI  R26,LOW(_nguong_khoi_1)
	LDI  R27,HIGH(_nguong_khoi_1)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
	ADIW R30,1
	LDS  R26,_nguong_khoi_1
	LDS  R27,_nguong_khoi_1+1
	SBIW R26,0
	BRNE _0x14
	LDI  R30,LOW(1023)
	LDI  R31,HIGH(1023)
	STS  _nguong_khoi_1,R30
	STS  _nguong_khoi_1+1,R31
_0x14:
_0x13:
_0x12:
	RET
_but_ton_khoi_2:
	SBIC 0x16,3
	RJMP _0x15
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	SBIC 0x16,3
	RJMP _0x16
	LDI  R26,LOW(_nguong_khoi_2)
	LDI  R27,HIGH(_nguong_khoi_2)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDS  R26,_nguong_khoi_2
	LDS  R27,_nguong_khoi_2+1
	CPI  R26,LOW(0x3FF)
	LDI  R30,HIGH(0x3FF)
	CPC  R27,R30
	BRLO _0x17
	LDI  R30,LOW(0)
	STS  _nguong_khoi_2,R30
	STS  _nguong_khoi_2+1,R30
_0x17:
_0x16:
_0x15:
	SBIC 0x16,4
	RJMP _0x18
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	SBIC 0x16,4
	RJMP _0x19
	LDI  R26,LOW(_nguong_khoi_2)
	LDI  R27,HIGH(_nguong_khoi_2)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
	ADIW R30,1
	LDS  R26,_nguong_khoi_2
	LDS  R27,_nguong_khoi_2+1
	SBIW R26,0
	BRNE _0x1A
	LDI  R30,LOW(1023)
	LDI  R31,HIGH(1023)
	STS  _nguong_khoi_2,R30
	STS  _nguong_khoi_2+1,R31
_0x1A:
_0x19:
_0x18:
	RET
_but_ton_nhiet:
	SBIC 0x16,3
	RJMP _0x1B
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	SBIC 0x16,3
	RJMP _0x1C
	LDI  R26,LOW(_nguong_nhiet)
	LDI  R27,HIGH(_nguong_nhiet)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDS  R26,_nguong_nhiet
	LDS  R27,_nguong_nhiet+1
	CPI  R26,LOW(0x7D)
	LDI  R30,HIGH(0x7D)
	CPC  R27,R30
	BRLO _0x1D
	LDI  R30,LOW(0)
	STS  _nguong_nhiet,R30
	STS  _nguong_nhiet+1,R30
_0x1D:
_0x1C:
_0x1B:
	SBIC 0x16,4
	RJMP _0x1E
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	SBIC 0x16,4
	RJMP _0x1F
	LDI  R26,LOW(_nguong_nhiet)
	LDI  R27,HIGH(_nguong_nhiet)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
	ADIW R30,1
	LDS  R26,_nguong_nhiet
	LDS  R27,_nguong_nhiet+1
	SBIW R26,0
	BRNE _0x20
	LDI  R30,LOW(124)
	LDI  R31,HIGH(124)
	STS  _nguong_nhiet,R30
	STS  _nguong_nhiet+1,R31
_0x20:
_0x1F:
_0x1E:
	RET
_but_ton_as_1:
	SBIC 0x16,3
	RJMP _0x21
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	SBIC 0x16,3
	RJMP _0x22
	LDI  R26,LOW(_nguong_as_1)
	LDI  R27,HIGH(_nguong_as_1)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDS  R26,_nguong_as_1
	LDS  R27,_nguong_as_1+1
	CPI  R26,LOW(0x3FF)
	LDI  R30,HIGH(0x3FF)
	CPC  R27,R30
	BRLO _0x23
	LDI  R30,LOW(0)
	STS  _nguong_as_1,R30
	STS  _nguong_as_1+1,R30
_0x23:
_0x22:
_0x21:
	SBIC 0x16,4
	RJMP _0x24
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	SBIC 0x16,4
	RJMP _0x25
	LDI  R26,LOW(_nguong_as_1)
	LDI  R27,HIGH(_nguong_as_1)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
	ADIW R30,1
	LDS  R26,_nguong_as_1
	LDS  R27,_nguong_as_1+1
	SBIW R26,0
	BRNE _0x26
	LDI  R30,LOW(99)
	LDI  R31,HIGH(99)
	STS  _nguong_as_1,R30
	STS  _nguong_as_1+1,R31
_0x26:
_0x25:
_0x24:
	RET
_but_ton_as_2:
	SBIC 0x16,3
	RJMP _0x27
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	SBIC 0x16,3
	RJMP _0x28
	LDI  R26,LOW(_nguong_as_2)
	LDI  R27,HIGH(_nguong_as_2)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDS  R26,_nguong_as_2
	LDS  R27,_nguong_as_2+1
	CPI  R26,LOW(0x3FF)
	LDI  R30,HIGH(0x3FF)
	CPC  R27,R30
	BRLO _0x29
	LDI  R30,LOW(0)
	STS  _nguong_as_2,R30
	STS  _nguong_as_2+1,R30
_0x29:
_0x28:
_0x27:
	SBIC 0x16,4
	RJMP _0x2A
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	SBIC 0x16,4
	RJMP _0x2B
	LDI  R26,LOW(_nguong_as_2)
	LDI  R27,HIGH(_nguong_as_2)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
	ADIW R30,1
	LDS  R26,_nguong_as_2
	LDS  R27,_nguong_as_2+1
	SBIW R26,0
	BRNE _0x2C
	LDI  R30,LOW(99)
	LDI  R31,HIGH(99)
	STS  _nguong_as_2,R30
	STS  _nguong_as_2+1,R31
_0x2C:
_0x2B:
_0x2A:
	RET
_read_adc:
;	adc_channel -> Y+0
	LD   R30,Y
	OUT  0x7,R30
	SBI  0x6,6
_0x2D:
	SBIS 0x6,4
	RJMP _0x2D
	SBI  0x6,4
	IN   R30,0x4
	IN   R31,0x4+1
	JMP  _0x20E0005
;	*ch -> Y+2
;	x -> Y+0

	.DSEG
_0x30:
	.BYTE 0x2

	.CSEG
_read_parameter:
	LDS  R30,_T
	LDS  R31,_T+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _ds18b20_temperature
	CALL __CFD1
	MOVW R12,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _read_adc
	STS  _khoi,R30
	STS  _khoi+1,R31
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _read_adc
	CLR  R22
	CLR  R23
	CALL __CDF1
	__GETD2N 0x3E2E147B
	CALL __MULF12
	LDI  R26,LOW(_anh_sang)
	LDI  R27,HIGH(_anh_sang)
	CALL __CFD1U
	ST   X+,R30
	ST   X,R31
	RET
_so_sanh:
	LDS  R26,_Temp_0_G000
	LDS  R27,_Temp_0_G000+1
	MOVW R30,R12
	SUB  R30,R26
	SBC  R31,R27
	STS  _Temp_ss,R30
	STS  _Temp_ss+1,R31
	LDS  R26,_khoi_0_1_G000
	LDS  R27,_khoi_0_1_G000+1
	LDS  R30,_khoi
	LDS  R31,_khoi+1
	SUB  R30,R26
	SBC  R31,R27
	STS  _khoi_ss_1,R30
	STS  _khoi_ss_1+1,R31
	LDS  R26,_khoi_0_2_G000
	LDS  R27,_khoi_0_2_G000+1
	LDS  R30,_khoi
	LDS  R31,_khoi+1
	SUB  R30,R26
	SBC  R31,R27
	STS  _khoi_ss_2,R30
	STS  _khoi_ss_2+1,R31
	LDS  R26,_anh_sang_0_1_G000
	LDS  R27,_anh_sang_0_1_G000+1
	LDS  R30,_anh_sang
	LDS  R31,_anh_sang+1
	SUB  R30,R26
	SBC  R31,R27
	STS  _anh_sang_ss_1,R30
	STS  _anh_sang_ss_1+1,R31
	LDS  R26,_anh_sang_0_2_G000
	LDS  R27,_anh_sang_0_2_G000+1
	LDS  R30,_anh_sang
	LDS  R31,_anh_sang+1
	SUB  R30,R26
	SBC  R31,R27
	STS  _anh_sang_ss_2,R30
	STS  _anh_sang_ss_2+1,R31
	LDS  R26,_Temp_ss+1
	TST  R26
	BRMI _0x31
	LDI  R30,LOW(0)
	STS  _cb_Temp_G000,R30
	STS  _cb_Temp_G000+1,R30
	RJMP _0x32
_0x31:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _cb_Temp_G000,R30
	STS  _cb_Temp_G000+1,R31
_0x32:
	LDS  R26,_khoi_ss_1+1
	TST  R26
	BRMI _0x34
	LDS  R26,_khoi_ss_2+1
	TST  R26
	BRMI _0x35
_0x34:
	RJMP _0x33
_0x35:
	LDI  R30,LOW(0)
	STS  _cb_khoi_1_G000,R30
	STS  _cb_khoi_1_G000+1,R30
	RJMP _0x36
_0x33:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _cb_khoi_1_G000,R30
	STS  _cb_khoi_1_G000+1,R31
_0x36:
	LDS  R26,_khoi_ss_2+1
	TST  R26
	BRMI _0x37
	LDI  R30,LOW(0)
	STS  _cb_khoi_2_G000,R30
	STS  _cb_khoi_2_G000+1,R30
	RJMP _0x38
_0x37:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _cb_khoi_2_G000,R30
	STS  _cb_khoi_2_G000+1,R31
_0x38:
	LDS  R26,_anh_sang_ss_1
	LDS  R27,_anh_sang_ss_1+1
	CALL __CPW02
	BRLT _0x39
	LDI  R30,LOW(0)
	STS  _cb_anh_sang_1_G000,R30
	STS  _cb_anh_sang_1_G000+1,R30
	RJMP _0x3A
_0x39:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _cb_anh_sang_1_G000,R30
	STS  _cb_anh_sang_1_G000+1,R31
_0x3A:
	LDS  R26,_anh_sang_ss_2+1
	TST  R26
	BRMI _0x3B
	LDI  R30,LOW(0)
	STS  _cb_anh_sang_2_G000,R30
	STS  _cb_anh_sang_2_G000+1,R30
	RJMP _0x3C
_0x3B:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _cb_anh_sang_2_G000,R30
	STS  _cb_anh_sang_2_G000+1,R31
_0x3C:
	RET
_dis_LCD_cb:
	CALL _lcd_clear
	LDS  R30,_cb_khoi_1_G000
	LDS  R31,_cb_khoi_1_G000+1
	SBIW R30,0
	BRNE _0x3D
	CALL _lcd_clear
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	CALL _lcd_gotoxy
	__POINTW1MN _0x3E,0
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
	__POINTW1MN _0x3E,14
	RJMP _0x88
_0x3D:
	LDS  R30,_cb_khoi_2_G000
	LDS  R31,_cb_khoi_2_G000+1
	SBIW R30,0
	BRNE _0x40
	CALL _lcd_clear
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	CALL _lcd_gotoxy
	__POINTW1MN _0x3E,20
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
	__POINTW1MN _0x3E,34
	RJMP _0x88
_0x40:
	LDS  R30,_cb_Temp_G000
	LDS  R31,_cb_Temp_G000+1
	SBIW R30,0
	BREQ _0x43
	LDS  R30,_cb_anh_sang_1_G000
	LDS  R31,_cb_anh_sang_1_G000+1
	SBIW R30,0
	BREQ _0x43
	LDS  R30,_cb_anh_sang_2_G000
	LDS  R31,_cb_anh_sang_2_G000+1
	SBIW R30,0
	BRNE _0x42
_0x43:
	CALL _lcd_clear
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	CALL _lcd_gotoxy
	__POINTW1MN _0x3E,40
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
	__POINTW1MN _0x3E,49
_0x88:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
_0x42:
	RET

	.DSEG
_0x3E:
	.BYTE 0x3A

	.CSEG
_dis_PC_parameter:
	LDI  R30,LOW(_str)
	LDI  R31,HIGH(_str)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,50
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _sprintf
	ADIW R28,4
	ST   -Y,R13
	ST   -Y,R12
	ST   -Y,R9
	ST   -Y,R8
	CALL _itoa
	LDI  R30,LOW(_str1)
	LDI  R31,HIGH(_str1)
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R9
	ST   -Y,R8
	CALL _strcpy
	LD   R30,Z
	LDI  R30,LOW(_str)
	LDI  R31,HIGH(_str)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_str1)
	LDI  R31,HIGH(_str1)
	ST   -Y,R31
	ST   -Y,R30
	CALL _strcat
	LDI  R30,LOW(_str)
	LDI  R31,HIGH(_str)
	ST   -Y,R31
	ST   -Y,R30
	CALL _puts
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	LDI  R30,LOW(_str)
	LDI  R31,HIGH(_str)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,53
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _sprintf
	ADIW R28,4
	LDS  R30,_anh_sang
	LDS  R31,_anh_sang+1
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R9
	ST   -Y,R8
	CALL _itoa
	LDI  R30,LOW(_str1)
	LDI  R31,HIGH(_str1)
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R9
	ST   -Y,R8
	RJMP _0x20E0006
_dis_PC_nguong:
	LDI  R30,LOW(_str)
	LDI  R31,HIGH(_str)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,56
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _sprintf
	ADIW R28,4
	LDS  R30,_Temp_0_G000
	LDS  R31,_Temp_0_G000+1
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R11
	ST   -Y,R10
	CALL _itoa
	LDI  R30,LOW(_str1)
	LDI  R31,HIGH(_str1)
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R11
	ST   -Y,R10
	CALL _strcpy
	LD   R30,Z
	LDI  R30,LOW(_str)
	LDI  R31,HIGH(_str)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_str1)
	LDI  R31,HIGH(_str1)
	ST   -Y,R31
	ST   -Y,R30
	CALL _strcat
	LDI  R30,LOW(_str)
	LDI  R31,HIGH(_str)
	ST   -Y,R31
	ST   -Y,R30
	CALL _puts
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	LDI  R30,LOW(_str)
	LDI  R31,HIGH(_str)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,66
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _sprintf
	ADIW R28,4
	LDS  R30,_anh_sang_0_1_G000
	LDS  R31,_anh_sang_0_1_G000+1
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R11
	ST   -Y,R10
	CALL _itoa
	LDI  R30,LOW(_str1)
	LDI  R31,HIGH(_str1)
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R11
	ST   -Y,R10
	CALL _strcpy
	LD   R30,Z
	LDI  R30,LOW(_str)
	LDI  R31,HIGH(_str)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_str1)
	LDI  R31,HIGH(_str1)
	ST   -Y,R31
	ST   -Y,R30
	CALL _strcat
	LDI  R30,LOW(_str)
	LDI  R31,HIGH(_str)
	ST   -Y,R31
	ST   -Y,R30
	CALL _puts
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	LDI  R30,LOW(_str)
	LDI  R31,HIGH(_str)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,78
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _sprintf
	ADIW R28,4
	LDS  R30,_anh_sang_0_2_G000
	LDS  R31,_anh_sang_0_2_G000+1
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R11
	ST   -Y,R10
	CALL _itoa
	LDI  R30,LOW(_str1)
	LDI  R31,HIGH(_str1)
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R11
	ST   -Y,R10
_0x20E0006:
	CALL _strcpy
	LD   R30,Z
	LDI  R30,LOW(_str)
	LDI  R31,HIGH(_str)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_str1)
	LDI  R31,HIGH(_str1)
	ST   -Y,R31
	ST   -Y,R30
	CALL _strcat
	LDI  R30,LOW(_str)
	LDI  R31,HIGH(_str)
	ST   -Y,R31
	ST   -Y,R30
	CALL _puts
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	RET
_dis_PC_cb:
	LDS  R30,_Temp_0_G000
	LDS  R31,_Temp_0_G000+1
	CP   R30,R12
	CPC  R31,R13
	BRSH _0x45
	LDI  R30,LOW(_str)
	LDI  R31,HIGH(_str)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,90
	RJMP _0x89
_0x45:
	LDI  R30,LOW(_str)
	LDI  R31,HIGH(_str)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,94
_0x89:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _sprintf
	ADIW R28,4
	LDI  R30,LOW(_str)
	LDI  R31,HIGH(_str)
	ST   -Y,R31
	ST   -Y,R30
	CALL _puts
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	LDS  R30,_anh_sang
	LDS  R31,_anh_sang+1
	LDS  R26,_anh_sang_0_1_G000
	LDS  R27,_anh_sang_0_1_G000+1
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x48
	LDS  R30,_anh_sang_0_2_G000
	LDS  R31,_anh_sang_0_2_G000+1
	LDS  R26,_anh_sang
	LDS  R27,_anh_sang+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x49
_0x48:
	RJMP _0x47
_0x49:
	LDI  R30,LOW(_str)
	LDI  R31,HIGH(_str)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,98
	RJMP _0x8A
_0x47:
	LDI  R30,LOW(_str)
	LDI  R31,HIGH(_str)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,102
_0x8A:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _sprintf
	ADIW R28,4
	LDI  R30,LOW(_str)
	LDI  R31,HIGH(_str)
	ST   -Y,R31
	ST   -Y,R30
	CALL _puts
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	LDS  R30,_khoi_0_1_G000
	LDS  R31,_khoi_0_1_G000+1
	LDS  R26,_khoi
	LDS  R27,_khoi+1
	CP   R30,R26
	CPC  R31,R27
	BRSH _0x4C
	LDS  R30,_khoi_0_2_G000
	LDS  R31,_khoi_0_2_G000+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x4D
_0x4C:
	RJMP _0x4B
_0x4D:
	LDI  R30,LOW(_str)
	LDI  R31,HIGH(_str)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,106
	RJMP _0x8B
_0x4B:
	LDS  R30,_khoi_0_2_G000
	LDS  R31,_khoi_0_2_G000+1
	LDS  R26,_khoi
	LDS  R27,_khoi+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x4F
	LDI  R30,LOW(_str)
	LDI  R31,HIGH(_str)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,112
	RJMP _0x8B
_0x4F:
	LDI  R30,LOW(_str)
	LDI  R31,HIGH(_str)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,118
_0x8B:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _sprintf
	ADIW R28,4
	LDI  R30,LOW(_str)
	LDI  R31,HIGH(_str)
	ST   -Y,R31
	ST   -Y,R30
	CALL _puts
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	RET
_control:
	LDS  R30,_cb_Temp_G000
	LDS  R31,_cb_Temp_G000+1
	SBIW R30,0
	BRNE _0x51
	SBI  0x18,0
_0x51:
	LDS  R26,_cb_Temp_G000
	LDS  R27,_cb_Temp_G000+1
	SBIW R26,1
	BRNE _0x52
	CBI  0x18,0
_0x52:
	LDS  R30,_anh_sang_0_1_G000
	LDS  R31,_anh_sang_0_1_G000+1
	LDS  R26,_anh_sang
	LDS  R27,_anh_sang+1
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x53
	SBI  0x18,1
	RJMP _0x54
_0x53:
	CBI  0x18,1
_0x54:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	LDS  R30,_cb_khoi_1_G000
	LDS  R31,_cb_khoi_1_G000+1
	SBIW R30,0
	BRNE _0x55
	SBI  0x18,7
_0x55:
	LDS  R30,_cb_khoi_2_G000
	LDS  R31,_cb_khoi_2_G000+1
	SBIW R30,0
	BRNE _0x56
	SBIW R28,2
;	i -> Y+0
	LDI  R30,LOW(0)
	STD  Y+0,R30
	STD  Y+0+1,R30
_0x58:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,10
	BRSH _0x59
	SBI  0x18,7
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	CBI  0x18,7
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
	RJMP _0x58
_0x59:
	ADIW R28,2
_0x56:
	LDS  R26,_cb_khoi_1_G000
	LDS  R27,_cb_khoi_1_G000+1
	SBIW R26,1
	BRNE _0x5B
	LDS  R26,_cb_khoi_2_G000
	LDS  R27,_cb_khoi_2_G000+1
	SBIW R26,1
	BREQ _0x5C
_0x5B:
	RJMP _0x5A
_0x5C:
	CBI  0x18,7
_0x5A:
	RET
;	*str -> Y+6
;	index -> Y+4
;	i -> Y+2
;	nn -> Y+0
;	*str -> Y+6
;	index -> Y+4
;	nn -> Y+2
;	i -> Y+0
;unsigned int mode2;
;// External Interrupt 2 service routine
;interrupt [EXT_INT2] void ext_int2_isr(void)
; 0000 0005 {
_ext_int2_isr:
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
; 0000 0006     delay_ms(200);
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 0007     if(!(PINB & 0x04)){
	SBIC 0x16,2
	RJMP _0x67
; 0000 0008         mode1++;   // mode1 tang 1 dv sau moi lan bam
	LDI  R26,LOW(_mode1)
	LDI  R27,HIGH(_mode1)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
; 0000 0009     }
; 0000 000A 
; 0000 000B     mode2 = mode1;
_0x67:
	LDS  R30,_mode1
	LDS  R31,_mode1+1
	STS  _mode2,R30
	STS  _mode2+1,R31
; 0000 000C     if (mode1 == 8) mode1 = 0;
	LDS  R26,_mode1
	LDS  R27,_mode1+1
	SBIW R26,8
	BRNE _0x68
	LDI  R30,LOW(0)
	STS  _mode1,R30
	STS  _mode1+1,R30
; 0000 000D }
_0x68:
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
;void set_nguong(){
; 0000 000E void set_nguong(){
_set_nguong:
; 0000 000F     // kiem tra gia tri mode 1 va set cac gia tri nguong
; 0000 0010     /* thuc hien dieu khien: khi nhan button
; 0000 0011     - lan 1: dieu khien nhiet do
; 0000 0012         + up: tang nhiet do nguong
; 0000 0013         + down: giam nhiet do nguong
; 0000 0014         + mode1 = 1
; 0000 0015     - lan 2: dieu khien anh sang : mode1 = 2
; 0000 0016     - lan 3: dieu khien bao chay : mode1  = 3
; 0000 0017     - lan 4: quay ve che do hien thi trang thai
; 0000 0018     */
; 0000 0019     if (mode1 == 1){
	LDS  R26,_mode1
	LDS  R27,_mode1+1
	SBIW R26,1
	BRNE _0x69
; 0000 001A         but_ton_nhiet();
	RCALL _but_ton_nhiet
; 0000 001B         Temp_0 = nguong_nhiet;
	LDS  R30,_nguong_nhiet
	LDS  R31,_nguong_nhiet+1
	STS  _Temp_0_G000,R30
	STS  _Temp_0_G000+1,R31
; 0000 001C         lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 001D         lcd_puts("NHIET DO:");
	__POINTW1MN _0x6A,0
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 001E         sprintf(LCD_Buffer,"NGUONG : %4i",Temp_0);
	LDI  R30,LOW(_LCD_Buffer)
	LDI  R31,HIGH(_LCD_Buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,132
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_Temp_0_G000
	LDS  R31,_Temp_0_G000+1
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 001F         lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 0020         lcd_puts(LCD_Buffer);
	LDI  R30,LOW(_LCD_Buffer)
	LDI  R31,HIGH(_LCD_Buffer)
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 0021 
; 0000 0022     }
; 0000 0023 
; 0000 0024     if (mode1 == 4){
_0x69:
	LDS  R26,_mode1
	LDS  R27,_mode1+1
	SBIW R26,4
	BRNE _0x6B
; 0000 0025         but_ton_khoi_1();
	RCALL _but_ton_khoi_1
; 0000 0026         khoi_0_1 = nguong_khoi_1;
	LDS  R30,_nguong_khoi_1
	LDS  R31,_nguong_khoi_1+1
	STS  _khoi_0_1_G000,R30
	STS  _khoi_0_1_G000+1,R31
; 0000 0027         lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 0028         lcd_puts("CANH BAO CHAY:");
	__POINTW1MN _0x6A,10
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 0029         sprintf(LCD_Buffer,"NGUONG 1 : %4i",khoi_0_1);
	LDI  R30,LOW(_LCD_Buffer)
	LDI  R31,HIGH(_LCD_Buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,160
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_khoi_0_1_G000
	LDS  R31,_khoi_0_1_G000+1
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 002A         lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 002B         lcd_puts(LCD_Buffer);
	LDI  R30,LOW(_LCD_Buffer)
	LDI  R31,HIGH(_LCD_Buffer)
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 002C     }
; 0000 002D 
; 0000 002E     if (mode1 == 5){
_0x6B:
	LDS  R26,_mode1
	LDS  R27,_mode1+1
	SBIW R26,5
	BRNE _0x6C
; 0000 002F         but_ton_khoi_2();
	RCALL _but_ton_khoi_2
; 0000 0030         khoi_0_2 = nguong_khoi_2;
	LDS  R30,_nguong_khoi_2
	LDS  R31,_nguong_khoi_2+1
	STS  _khoi_0_2_G000,R30
	STS  _khoi_0_2_G000+1,R31
; 0000 0031         lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 0032         lcd_puts("CANH BAO CHAY:");
	__POINTW1MN _0x6A,25
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 0033         sprintf(LCD_Buffer,"NGUONG 2 : %4i",khoi_0_2);
	LDI  R30,LOW(_LCD_Buffer)
	LDI  R31,HIGH(_LCD_Buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,175
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_khoi_0_2_G000
	LDS  R31,_khoi_0_2_G000+1
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 0034         lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 0035         lcd_puts(LCD_Buffer);
	LDI  R30,LOW(_LCD_Buffer)
	LDI  R31,HIGH(_LCD_Buffer)
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 0036 
; 0000 0037     }
; 0000 0038 
; 0000 0039     if (mode1 == 2){
_0x6C:
	LDS  R26,_mode1
	LDS  R27,_mode1+1
	SBIW R26,2
	BRNE _0x6D
; 0000 003A         but_ton_as_1();
	RCALL _but_ton_as_1
; 0000 003B         anh_sang_0_1 = nguong_as_1;
	LDS  R30,_nguong_as_1
	LDS  R31,_nguong_as_1+1
	STS  _anh_sang_0_1_G000,R30
	STS  _anh_sang_0_1_G000+1,R31
; 0000 003C         lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 003D         lcd_puts("ANH SANG:");
	__POINTW1MN _0x6A,40
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 003E         sprintf(LCD_Buffer,"NGUONG 1: %4i",anh_sang_0_1);
	LDI  R30,LOW(_LCD_Buffer)
	LDI  R31,HIGH(_LCD_Buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,200
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_anh_sang_0_1_G000
	LDS  R31,_anh_sang_0_1_G000+1
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 003F         lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 0040         lcd_puts(LCD_Buffer);
	LDI  R30,LOW(_LCD_Buffer)
	LDI  R31,HIGH(_LCD_Buffer)
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 0041     }
; 0000 0042     if (mode1 == 3){
_0x6D:
	LDS  R26,_mode1
	LDS  R27,_mode1+1
	SBIW R26,3
	BRNE _0x6E
; 0000 0043         but_ton_as_2();
	RCALL _but_ton_as_2
; 0000 0044         anh_sang_0_2 = nguong_as_2;
	LDS  R30,_nguong_as_2
	LDS  R31,_nguong_as_2+1
	STS  _anh_sang_0_2_G000,R30
	STS  _anh_sang_0_2_G000+1,R31
; 0000 0045         lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 0046         lcd_puts("ANH SANG:");
	__POINTW1MN _0x6A,50
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 0047         sprintf(LCD_Buffer,"NGUONG 2: %4i",anh_sang_0_2);
	LDI  R30,LOW(_LCD_Buffer)
	LDI  R31,HIGH(_LCD_Buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,214
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_anh_sang_0_2_G000
	LDS  R31,_anh_sang_0_2_G000+1
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 0048         lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 0049         lcd_puts(LCD_Buffer);
	LDI  R30,LOW(_LCD_Buffer)
	LDI  R31,HIGH(_LCD_Buffer)
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 004A     }
; 0000 004B 
; 0000 004C     if (mode1 == 6){
_0x6E:
	LDS  R26,_mode1
	LDS  R27,_mode1+1
	SBIW R26,6
	BRNE _0x6F
; 0000 004D         lcd_clear();
	CALL _lcd_clear
; 0000 004E         lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 004F         lcd_puts("WAITING FOR");
	__POINTW1MN _0x6A,60
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 0050         lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 0051         lcd_puts("SETTING UP");
	__POINTW1MN _0x6A,72
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 0052         delay_ms(3000);
	LDI  R30,LOW(3000)
	LDI  R31,HIGH(3000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 0053         mode1++;
	LDI  R26,LOW(_mode1)
	LDI  R27,HIGH(_mode1)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0054         lcd_clear();
	CALL _lcd_clear
; 0000 0055     }
; 0000 0056 
; 0000 0057 }
_0x6F:
	RET

	.DSEG
_0x6A:
	.BYTE 0x53
;
;void main(void){
; 0000 0059 void main(void){

	.CSEG
_main:
; 0000 005A     char Data;
; 0000 005B     // ADC
; 0000 005C     ADCSRA=(1<<ADEN)|(1<<ADPS2)|(1<<ADPS0);     //enable ADC, khong dung interrupt
;	Data -> R17
	LDI  R30,LOW(133)
	OUT  0x6,R30
; 0000 005D     ADMUX=ADC_VREF_TYPE;                         //chon kieu dien ap tham chieu
	LDI  R30,LOW(0)
	OUT  0x7,R30
; 0000 005E     // input,output port
; 0000 005F     PORTC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x15,R30
; 0000 0060     DDRC=0xff;
	OUT  0x14,R30
; 0000 0061     DDRA = 0x00;
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 0062     DDRB=0x83;
	LDI  R30,LOW(131)
	OUT  0x17,R30
; 0000 0063 
; 0000 0064 
; 0000 0065     DDRD = 0xff;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 0066 
; 0000 0067     // USART initialization
; 0000 0068     // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0069     // USART Receiver: On
; 0000 006A     // USART Transmitter: On
; 0000 006B     // USART Mode: Asynchronous
; 0000 006C     // USART Baud Rate: 38400
; 0000 006D     UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 006E     UCSRB=0x18;
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 006F     UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 0070     UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0071     UBRRL=0x0C;
	LDI  R30,LOW(12)
	OUT  0x9,R30
; 0000 0072 
; 0000 0073     // External Interrupt(s) initialization
; 0000 0074     // INT0: Off
; 0000 0075     // INT1: Off
; 0000 0076     // INT2: On
; 0000 0077     // INT2 Mode: Falling Edge
; 0000 0078     GICR|=0x20;
	IN   R30,0x3B
	ORI  R30,0x20
	OUT  0x3B,R30
; 0000 0079     MCUCR=0x00;
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 007A     MCUCSR=0x00;
	OUT  0x34,R30
; 0000 007B     GIFR=0x20;
	LDI  R30,LOW(32)
	OUT  0x3A,R30
; 0000 007C 
; 0000 007D     TCCR1A=0x22;   // CAU HINH CHO CAC CHE DO CHO TIMER
	LDI  R30,LOW(34)
	OUT  0x2F,R30
; 0000 007E     TCCR1B=0x1A;
	LDI  R30,LOW(26)
	OUT  0x2E,R30
; 0000 007F     TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 0080     TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0081 
; 0000 0082     // PWM KENH A =====================================================
; 0000 0083     ICR1H=0x4e;
	LDI  R30,LOW(78)
	OUT  0x27,R30
; 0000 0084     ICR1L=0x20;
	LDI  R30,LOW(32)
	OUT  0x26,R30
; 0000 0085     //ICR1 = 20000;
; 0000 0086 
; 0000 0087     //Bo chia Timer: sau 1us, TCNT1 tang 1 don vi
; 0000 0088     //ICR1 = 20000 --> CHU KY cua xung tin hieu T = 20000us = 20ms
; 0000 0089 
; 0000 008A     OCR1AH=0x00;
	LDI  R30,LOW(0)
	OUT  0x2B,R30
; 0000 008B     OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 008C     OCR1B = 3000;
	LDI  R30,LOW(3000)
	LDI  R31,HIGH(3000)
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 008D     //OCR1 = 10000 --> Thoi gian tin hieu o muc 1 T1 = 10000us =10000ms
; 0000 008E     //Vay D = T1/T = 50%
; 0000 008F     // PWM KENH B =====================================================
; 0000 0090     //OCR1BH=0x00;
; 0000 0091     //OCR1BL=0x00;
; 0000 0092 
; 0000 0093 
; 0000 0094     // Global enable interrupts
; 0000 0095     #asm("sei")    // Cho phep ngat toan cuc
	sei
; 0000 0096 
; 0000 0097     // khoi tao DS18B20
; 0000 0098     w1_init(); // cau hinh su dung 1 wire
	CALL _w1_init
; 0000 0099     ds18b20_init(T,0,0,DS18B20_9BIT_RES);  // Khoi tao DS18b20, do phan giai 12bit
	LDS  R30,_T
	LDS  R31,_T+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	CALL _ds18b20_init
; 0000 009A 
; 0000 009B     // khoi tao LCD
; 0000 009C     lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	RCALL _lcd_init
; 0000 009D     lcd_clear();
	RCALL _lcd_clear
; 0000 009E 
; 0000 009F     lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	RCALL _lcd_gotoxy
; 0000 00A0     lcd_puts("BTL DLTDDK");
	__POINTW1MN _0x70,0
	ST   -Y,R31
	ST   -Y,R30
	RCALL _lcd_puts
; 0000 00A1     lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _lcd_gotoxy
; 0000 00A2     lcd_puts("BY: SCNT GROUP");
	__POINTW1MN _0x70,11
	ST   -Y,R31
	ST   -Y,R30
	RCALL _lcd_puts
; 0000 00A3     delay_ms(2000);
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 00A4     lcd_clear();
	RCALL _lcd_clear
; 0000 00A5 
; 0000 00A6     lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	RCALL _lcd_gotoxy
; 0000 00A7     lcd_puts("SET UP");
	__POINTW1MN _0x70,26
	ST   -Y,R31
	ST   -Y,R30
	RCALL _lcd_puts
; 0000 00A8     lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _lcd_gotoxy
; 0000 00A9     lcd_puts("PLEASE!");
	__POINTW1MN _0x70,33
	ST   -Y,R31
	ST   -Y,R30
	RCALL _lcd_puts
; 0000 00AA     while (1){
_0x71:
; 0000 00AB 
; 0000 00AC         while (mode1<6){
_0x74:
	LDS  R26,_mode1
	LDS  R27,_mode1+1
	SBIW R26,6
	BRSH _0x76
; 0000 00AD             set_nguong();
	RCALL _set_nguong
; 0000 00AE 
; 0000 00AF 
; 0000 00B0         }
	RJMP _0x74
_0x76:
; 0000 00B1         read_parameter(); // doc cac thong so
	RCALL _read_parameter
; 0000 00B2         dis_PC_nguong();
	RCALL _dis_PC_nguong
; 0000 00B3         //-------------------------hien thi PC----------------------------------
; 0000 00B4         if (Temp>=0){
	CLR  R0
	CP   R12,R0
	CPC  R13,R0
	BRGE PC+3
	JMP _0x77
; 0000 00B5             if ((Temp != Temp1)||(khoi != khoi1) || (anh_sang != anh_sang1)){
	LDS  R30,_Temp1
	LDS  R31,_Temp1+1
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x79
	LDS  R30,_khoi1
	LDS  R31,_khoi1+1
	LDS  R26,_khoi
	LDS  R27,_khoi+1
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x79
	LDS  R30,_anh_sang1
	LDS  R31,_anh_sang1+1
	LDS  R26,_anh_sang
	LDS  R27,_anh_sang+1
	CP   R30,R26
	CPC  R31,R27
	BREQ _0x78
_0x79:
; 0000 00B6                 dis_PC_parameter();
	RCALL _dis_PC_parameter
; 0000 00B7                 dis_PC_cb();
	RCALL _dis_PC_cb
; 0000 00B8             }
; 0000 00B9             Temp1=Temp;    // doc gia tri nhiet do va gan vao  bien Temp
_0x78:
	__PUTWMRN _Temp1,0,12,13
; 0000 00BA             khoi1 = khoi;    // doc gia tri khoi
	LDS  R30,_khoi
	LDS  R31,_khoi+1
	STS  _khoi1,R30
	STS  _khoi1+1,R31
; 0000 00BB             anh_sang1 =  anh_sang;// doc gia tri cuong do anh sang
	LDS  R30,_anh_sang
	LDS  R31,_anh_sang+1
	STS  _anh_sang1,R30
	STS  _anh_sang1+1,R31
; 0000 00BC             //-------------------------so sanh nguong----------------------------------
; 0000 00BD             so_sanh();
	RCALL _so_sanh
; 0000 00BE             //--------------------------bao tren LCD-----------------------------------
; 0000 00BF             if ((Temp<Temp_0) && (khoi<khoi_0_1) && (anh_sang>anh_sang_0_1)) {
	LDS  R30,_Temp_0_G000
	LDS  R31,_Temp_0_G000+1
	CP   R12,R30
	CPC  R13,R31
	BRSH _0x7C
	LDS  R30,_khoi_0_1_G000
	LDS  R31,_khoi_0_1_G000+1
	LDS  R26,_khoi
	LDS  R27,_khoi+1
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x7C
	LDS  R30,_anh_sang_0_1_G000
	LDS  R31,_anh_sang_0_1_G000+1
	LDS  R26,_anh_sang
	LDS  R27,_anh_sang+1
	CP   R30,R26
	CPC  R31,R27
	BRLO _0x7D
_0x7C:
	RJMP _0x7B
_0x7D:
; 0000 00C0                 lcd_clear();
	RCALL _lcd_clear
; 0000 00C1                 lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	RCALL _lcd_gotoxy
; 0000 00C2                 lcd_puts("AN TOAN"); // neu ca 3 thong so =1 thi an toan
	__POINTW1MN _0x70,41
	ST   -Y,R31
	ST   -Y,R30
	RCALL _lcd_puts
; 0000 00C3             }
; 0000 00C4             else {
	RJMP _0x7E
_0x7B:
; 0000 00C5                 dis_LCD_cb();
	RCALL _dis_LCD_cb
; 0000 00C6             }
_0x7E:
; 0000 00C7 
; 0000 00C8             //-------------------------dieu khien--------------------------------------
; 0000 00C9             control();
	RCALL _control
; 0000 00CA             if ((anh_sang >= anh_sang_0_1)&&( anh_sang <= anh_sang_0_2)) {
	LDS  R30,_anh_sang_0_1_G000
	LDS  R31,_anh_sang_0_1_G000+1
	LDS  R26,_anh_sang
	LDS  R27,_anh_sang+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x80
	LDS  R30,_anh_sang_0_2_G000
	LDS  R31,_anh_sang_0_2_G000+1
	CP   R30,R26
	CPC  R31,R27
	BRSH _0x81
_0x80:
	RJMP _0x7F
_0x81:
; 0000 00CB                 cbi(L298, EN); //rem khong hoat dong
	CBI  0x12,5
; 0000 00CC                 m=0;
	LDI  R30,LOW(0)
	STS  _m,R30
	STS  _m+1,R30
; 0000 00CD                 n=0;
	STS  _n,R30
	STS  _n+1,R30
; 0000 00CE                 OCR1B = 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 00CF             }
; 0000 00D0             else {
	RJMP _0x82
_0x7F:
; 0000 00D1 
; 0000 00D2                 if (anh_sang < anh_sang_0_1) {
	LDS  R30,_anh_sang_0_1_G000
	LDS  R31,_anh_sang_0_1_G000+1
	LDS  R26,_anh_sang
	LDS  R27,_anh_sang+1
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x83
; 0000 00D3                     if (m==0){
	LDS  R30,_m
	LDS  R31,_m+1
	SBIW R30,0
	BRNE _0x84
; 0000 00D4                         // keo rem
; 0000 00D5                         OCR1B = 2500;
	LDI  R30,LOW(2500)
	LDI  R31,HIGH(2500)
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 00D6                         sbi(L298, EN); //rem khong hoat dong
	SBI  0x12,5
; 0000 00D7                         cbi(L298, IN1);
	CBI  0x12,3
; 0000 00D8                         //cbi(L298, IN2);
; 0000 00D9                         delay_ms(900);
	LDI  R30,LOW(900)
	LDI  R31,HIGH(900)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 00DA                     }
; 0000 00DB                     m++;
_0x84:
	LDI  R26,LOW(_m)
	LDI  R27,HIGH(_m)
	RJMP _0x8D
; 0000 00DC                     //tat rem
; 0000 00DD                     cbi(L298, EN); //rem khong hoat dong
; 0000 00DE                     //OCR1B = 0;
; 0000 00DF                 }
; 0000 00E0 
; 0000 00E1                 else  {
_0x83:
; 0000 00E2                     if (n==0){
	LDS  R30,_n
	LDS  R31,_n+1
	SBIW R30,0
	BRNE _0x86
; 0000 00E3                         // keo rem
; 0000 00E4                         OCR1B = 18500;
	LDI  R30,LOW(18500)
	LDI  R31,HIGH(18500)
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 00E5                         sbi(L298, EN); //rem khong hoat dong
	SBI  0x12,5
; 0000 00E6                         sbi(L298, IN1);
	SBI  0x12,3
; 0000 00E7                         //sbi(L298, IN2);
; 0000 00E8                         delay_ms(7000);
	LDI  R30,LOW(7000)
	LDI  R31,HIGH(7000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 00E9                     }
; 0000 00EA                     n++;
_0x86:
	LDI  R26,LOW(_n)
	LDI  R27,HIGH(_n)
_0x8D:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 00EB                     //tat rem
; 0000 00EC                     cbi(L298, EN); //rem khong hoat dong
	CBI  0x12,5
; 0000 00ED                     //OCR1B = 0;
; 0000 00EE                 }
; 0000 00EF             }
_0x82:
; 0000 00F0         }
; 0000 00F1     }
_0x77:
	RJMP _0x71
; 0000 00F2 }
_0x87:
	RJMP _0x87

	.DSEG
_0x70:
	.BYTE 0x31
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2000004
	SBI  0x15,4
	RJMP _0x2000005
_0x2000004:
	CBI  0x15,4
_0x2000005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2000006
	SBI  0x15,5
	RJMP _0x2000007
_0x2000006:
	CBI  0x15,5
_0x2000007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2000008
	SBI  0x15,6
	RJMP _0x2000009
_0x2000008:
	CBI  0x15,6
_0x2000009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x200000A
	SBI  0x15,7
	RJMP _0x200000B
_0x200000A:
	CBI  0x15,7
_0x200000B:
	__DELAY_USB 5
	SBI  0x15,2
	__DELAY_USB 13
	CBI  0x15,2
	__DELAY_USB 13
	JMP  _0x20E0005
__lcd_write_data:
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 133
	RJMP _0x20E0005
_lcd_gotoxy:
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R30,R26
	ST   -Y,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
_lcd_clear:
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	LDI  R30,LOW(12)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
_lcd_putchar:
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000011
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2000010
_0x2000011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R30,__lcd_y
	SUBI R30,-LOW(1)
	STS  __lcd_y,R30
	ST   -Y,R30
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000013
	RJMP _0x20E0005
_0x2000013:
_0x2000010:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x15,0
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_data
	CBI  0x15,0
	RJMP _0x20E0005
_lcd_puts:
	ST   -Y,R17
_0x2000014:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000016
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2000014
_0x2000016:
	JMP  _0x20E0002
_lcd_init:
	SBI  0x14,4
	SBI  0x14,5
	SBI  0x14,6
	SBI  0x14,7
	SBI  0x14,2
	SBI  0x14,0
	SBI  0x14,1
	CBI  0x15,2
	CBI  0x15,0
	CBI  0x15,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	LDI  R30,LOW(48)
	ST   -Y,R30
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R30,LOW(48)
	ST   -Y,R30
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R30,LOW(48)
	ST   -Y,R30
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R30,LOW(40)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(4)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(133)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(6)
	ST   -Y,R30
	RCALL __lcd_write_data
	RCALL _lcd_clear
	RJMP _0x20E0005
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_putchar:
putchar0:
     sbis usr,udre
     rjmp putchar0
     ld   r30,y
     out  udr,r30
_0x20E0005:
	ADIW R28,1
	RET
_puts:
	ST   -Y,R17
_0x2020003:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2020005
	ST   -Y,R17
	RCALL _putchar
	RJMP _0x2020003
_0x2020005:
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _putchar
	JMP  _0x20E0002
_put_buff_G101:
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2020010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2020012
	__CPWRN 16,17,2
	BRLO _0x2020013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2020012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2020014
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x2020014:
_0x2020013:
	RJMP _0x2020015
_0x2020010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2020015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x20E0001
__print_G101:
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2020016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x2020018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x202001C
	CPI  R18,37
	BRNE _0x202001D
	LDI  R17,LOW(1)
	RJMP _0x202001E
_0x202001D:
	ST   -Y,R18
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
_0x202001E:
	RJMP _0x202001B
_0x202001C:
	CPI  R30,LOW(0x1)
	BRNE _0x202001F
	CPI  R18,37
	BRNE _0x2020020
	ST   -Y,R18
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RJMP _0x20200C9
_0x2020020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2020021
	LDI  R16,LOW(1)
	RJMP _0x202001B
_0x2020021:
	CPI  R18,43
	BRNE _0x2020022
	LDI  R20,LOW(43)
	RJMP _0x202001B
_0x2020022:
	CPI  R18,32
	BRNE _0x2020023
	LDI  R20,LOW(32)
	RJMP _0x202001B
_0x2020023:
	RJMP _0x2020024
_0x202001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2020025
_0x2020024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2020026
	ORI  R16,LOW(128)
	RJMP _0x202001B
_0x2020026:
	RJMP _0x2020027
_0x2020025:
	CPI  R30,LOW(0x3)
	BREQ PC+3
	JMP _0x202001B
_0x2020027:
	CPI  R18,48
	BRLO _0x202002A
	CPI  R18,58
	BRLO _0x202002B
_0x202002A:
	RJMP _0x2020029
_0x202002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x202001B
_0x2020029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x202002F
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	LDD  R26,Z+4
	ST   -Y,R26
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RJMP _0x2020030
_0x202002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2020032
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2020033
_0x2020032:
	CPI  R30,LOW(0x70)
	BRNE _0x2020035
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2020033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2020036
_0x2020035:
	CPI  R30,LOW(0x64)
	BREQ _0x2020039
	CPI  R30,LOW(0x69)
	BRNE _0x202003A
_0x2020039:
	ORI  R16,LOW(4)
	RJMP _0x202003B
_0x202003A:
	CPI  R30,LOW(0x75)
	BRNE _0x202003C
_0x202003B:
	LDI  R30,LOW(_tbl10_G101*2)
	LDI  R31,HIGH(_tbl10_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x202003D
_0x202003C:
	CPI  R30,LOW(0x58)
	BRNE _0x202003F
	ORI  R16,LOW(8)
	RJMP _0x2020040
_0x202003F:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x2020071
_0x2020040:
	LDI  R30,LOW(_tbl16_G101*2)
	LDI  R31,HIGH(_tbl16_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x202003D:
	SBRS R16,2
	RJMP _0x2020042
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2020043
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2020043:
	CPI  R20,0
	BREQ _0x2020044
	SUBI R17,-LOW(1)
	RJMP _0x2020045
_0x2020044:
	ANDI R16,LOW(251)
_0x2020045:
	RJMP _0x2020046
_0x2020042:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
_0x2020046:
_0x2020036:
	SBRC R16,0
	RJMP _0x2020047
_0x2020048:
	CP   R17,R21
	BRSH _0x202004A
	SBRS R16,7
	RJMP _0x202004B
	SBRS R16,2
	RJMP _0x202004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x202004D
_0x202004C:
	LDI  R18,LOW(48)
_0x202004D:
	RJMP _0x202004E
_0x202004B:
	LDI  R18,LOW(32)
_0x202004E:
	ST   -Y,R18
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	SUBI R21,LOW(1)
	RJMP _0x2020048
_0x202004A:
_0x2020047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x202004F
_0x2020050:
	CPI  R19,0
	BREQ _0x2020052
	SBRS R16,3
	RJMP _0x2020053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2020054
_0x2020053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2020054:
	ST   -Y,R18
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	CPI  R21,0
	BREQ _0x2020055
	SUBI R21,LOW(1)
_0x2020055:
	SUBI R19,LOW(1)
	RJMP _0x2020050
_0x2020052:
	RJMP _0x2020056
_0x202004F:
_0x2020058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x202005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x202005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x202005A
_0x202005C:
	CPI  R18,58
	BRLO _0x202005D
	SBRS R16,3
	RJMP _0x202005E
	SUBI R18,-LOW(7)
	RJMP _0x202005F
_0x202005E:
	SUBI R18,-LOW(39)
_0x202005F:
_0x202005D:
	SBRC R16,4
	RJMP _0x2020061
	CPI  R18,49
	BRSH _0x2020063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2020062
_0x2020063:
	RJMP _0x20200CA
_0x2020062:
	CP   R21,R19
	BRLO _0x2020067
	SBRS R16,0
	RJMP _0x2020068
_0x2020067:
	RJMP _0x2020066
_0x2020068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2020069
	LDI  R18,LOW(48)
_0x20200CA:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x202006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	CPI  R21,0
	BREQ _0x202006B
	SUBI R21,LOW(1)
_0x202006B:
_0x202006A:
_0x2020069:
_0x2020061:
	ST   -Y,R18
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	CPI  R21,0
	BREQ _0x202006C
	SUBI R21,LOW(1)
_0x202006C:
_0x2020066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2020059
	RJMP _0x2020058
_0x2020059:
_0x2020056:
	SBRS R16,0
	RJMP _0x202006D
_0x202006E:
	CPI  R21,0
	BREQ _0x2020070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RJMP _0x202006E
_0x2020070:
_0x202006D:
_0x2020071:
_0x2020030:
_0x20200C9:
	LDI  R17,LOW(0)
_0x202001B:
	RJMP _0x2020016
_0x2020018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
_sprintf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	SBIW R30,0
	BRNE _0x2020072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20E0004
_0x2020072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G101)
	LDI  R31,HIGH(_put_buff_G101)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,10
	ST   -Y,R31
	ST   -Y,R30
	RCALL __print_G101
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20E0004:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET

	.CSEG
_itoa:
    ld   r26,y+
    ld   r27,y+
    ld   r30,y+
    ld   r31,y+
    adiw r30,0
    brpl __itoa0
    com  r30
    com  r31
    adiw r30,1
    ldi  r22,'-'
    st   x+,r22
__itoa0:
    clt
    ldi  r24,low(10000)
    ldi  r25,high(10000)
    rcall __itoa1
    ldi  r24,low(1000)
    ldi  r25,high(1000)
    rcall __itoa1
    ldi  r24,100
    clr  r25
    rcall __itoa1
    ldi  r24,10
    rcall __itoa1
    mov  r22,r30
    rcall __itoa5
    clr  r22
    st   x,r22
    ret

__itoa1:
    clr	 r22
__itoa2:
    cp   r30,r24
    cpc  r31,r25
    brlo __itoa3
    inc  r22
    sub  r30,r24
    sbc  r31,r25
    brne __itoa2
__itoa3:
    tst  r22
    brne __itoa4
    brts __itoa5
    ret
__itoa4:
    set
__itoa5:
    subi r22,-0x30
    st   x+,r22
    ret

	.DSEG

	.CSEG

	.CSEG
_strcat:
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcat0:
    ld   r22,x+
    tst  r22
    brne strcat0
    sbiw r26,1
strcat1:
    ld   r22,z+
    st   x+,r22
    tst  r22
    brne strcat1
    movw r30,r24
    ret
_strcpy:
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpy0:
    ld   r22,z+
    st   x+,r22
    tst  r22
    brne strcpy0
    movw r30,r24
    ret
_strlen:
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
_strlenf:
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

	.CSEG
_ds18b20_select:
	ST   -Y,R17
	CALL _w1_init
	CPI  R30,0
	BRNE _0x2080003
	LDI  R30,LOW(0)
	RJMP _0x20E0002
_0x2080003:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	SBIW R30,0
	BREQ _0x2080004
	LDI  R30,LOW(85)
	ST   -Y,R30
	CALL _w1_write
	LDI  R17,LOW(0)
_0x2080006:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	ST   -Y,R30
	CALL _w1_write
	SUBI R17,-LOW(1)
	CPI  R17,8
	BRLO _0x2080006
	RJMP _0x2080008
_0x2080004:
	LDI  R30,LOW(204)
	ST   -Y,R30
	CALL _w1_write
_0x2080008:
	LDI  R30,LOW(1)
	RJMP _0x20E0002
_ds18b20_read_spd:
	CALL __SAVELOCR4
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ds18b20_select
	CPI  R30,0
	BRNE _0x2080009
	LDI  R30,LOW(0)
	RJMP _0x20E0003
_0x2080009:
	LDI  R30,LOW(190)
	ST   -Y,R30
	CALL _w1_write
	LDI  R17,LOW(0)
	__POINTWRM 18,19,___ds18b20_scratch_pad
_0x208000B:
	PUSH R19
	PUSH R18
	__ADDWRN 18,19,1
	CALL _w1_read
	POP  R26
	POP  R27
	ST   X,R30
	SUBI R17,-LOW(1)
	CPI  R17,9
	BRLO _0x208000B
	LDI  R30,LOW(___ds18b20_scratch_pad)
	LDI  R31,HIGH(___ds18b20_scratch_pad)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(9)
	ST   -Y,R30
	CALL _w1_dow_crc8
	CALL __LNEGB1
_0x20E0003:
	CALL __LOADLOCR4
	ADIW R28,6
	RET
_ds18b20_temperature:
	ST   -Y,R17
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ds18b20_read_spd
	CPI  R30,0
	BRNE _0x208000D
	__GETD1N 0xC61C3C00
	RJMP _0x20E0002
_0x208000D:
	__GETB2MN ___ds18b20_scratch_pad,4
	LDI  R27,0
	LDI  R30,LOW(5)
	CALL __ASRW12
	ANDI R30,LOW(0x3)
	MOV  R17,R30
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ds18b20_select
	CPI  R30,0
	BRNE _0x208000E
	__GETD1N 0xC61C3C00
	RJMP _0x20E0002
_0x208000E:
	LDI  R30,LOW(68)
	ST   -Y,R30
	CALL _w1_write
	MOV  R30,R17
	LDI  R26,LOW(_conv_delay_G104*2)
	LDI  R27,HIGH(_conv_delay_G104*2)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	CALL __GETW1PF
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ds18b20_read_spd
	CPI  R30,0
	BRNE _0x208000F
	__GETD1N 0xC61C3C00
	RJMP _0x20E0002
_0x208000F:
	CALL _w1_init
	MOV  R30,R17
	LDI  R26,LOW(_bit_mask_G104*2)
	LDI  R27,HIGH(_bit_mask_G104*2)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	CALL __GETW1PF
	LDS  R26,___ds18b20_scratch_pad
	LDS  R27,___ds18b20_scratch_pad+1
	AND  R30,R26
	AND  R31,R27
	CALL __CWD1
	CALL __CDF1
	__GETD2N 0x3D800000
	CALL __MULF12
_0x20E0002:
	LDD  R17,Y+0
	ADIW R28,3
	RET
_ds18b20_init:
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ds18b20_select
	CPI  R30,0
	BRNE _0x2080010
	LDI  R30,LOW(0)
	RJMP _0x20E0001
_0x2080010:
	LD   R30,Y
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	ORI  R30,LOW(0x1F)
	ST   Y,R30
	LDI  R30,LOW(78)
	ST   -Y,R30
	CALL _w1_write
	LDD  R30,Y+1
	ST   -Y,R30
	CALL _w1_write
	LDD  R30,Y+2
	ST   -Y,R30
	CALL _w1_write
	LD   R30,Y
	ST   -Y,R30
	CALL _w1_write
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ds18b20_read_spd
	CPI  R30,0
	BRNE _0x2080011
	LDI  R30,LOW(0)
	RJMP _0x20E0001
_0x2080011:
	__GETB2MN ___ds18b20_scratch_pad,3
	LDD  R30,Y+2
	CP   R30,R26
	BRNE _0x2080013
	__GETB2MN ___ds18b20_scratch_pad,2
	LDD  R30,Y+1
	CP   R30,R26
	BRNE _0x2080013
	__GETB2MN ___ds18b20_scratch_pad,4
	LD   R30,Y
	CP   R30,R26
	BREQ _0x2080012
_0x2080013:
	LDI  R30,LOW(0)
	RJMP _0x20E0001
_0x2080012:
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ds18b20_select
	CPI  R30,0
	BRNE _0x2080015
	LDI  R30,LOW(0)
	RJMP _0x20E0001
_0x2080015:
	LDI  R30,LOW(72)
	ST   -Y,R30
	CALL _w1_write
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	CALL _w1_init
_0x20E0001:
	ADIW R28,5
	RET

	.CSEG

	.CSEG

	.DSEG
_rx_buffer:
	.BYTE 0x8
___ds18b20_scratch_pad:
	.BYTE 0x9
_str:
	.BYTE 0xF
_LCD_Buffer:
	.BYTE 0xF
_str1:
	.BYTE 0xC
_Temp1:
	.BYTE 0x2
_T:
	.BYTE 0x2
_khoi:
	.BYTE 0x2
_anh_sang:
	.BYTE 0x2
_khoi1:
	.BYTE 0x2
_anh_sang1:
	.BYTE 0x2
_khoi_0_1_G000:
	.BYTE 0x2
_khoi_0_2_G000:
	.BYTE 0x2
_anh_sang_0_1_G000:
	.BYTE 0x2
_anh_sang_0_2_G000:
	.BYTE 0x2
_Temp_0_G000:
	.BYTE 0x2
_cb_Temp_G000:
	.BYTE 0x2
_cb_khoi_1_G000:
	.BYTE 0x2
_cb_khoi_2_G000:
	.BYTE 0x2
_cb_anh_sang_1_G000:
	.BYTE 0x2
_cb_anh_sang_2_G000:
	.BYTE 0x2
_khoi_ss_1:
	.BYTE 0x2
_khoi_ss_2:
	.BYTE 0x2
_anh_sang_ss_1:
	.BYTE 0x2
_anh_sang_ss_2:
	.BYTE 0x2
_Temp_ss:
	.BYTE 0x2
_mode1:
	.BYTE 0x2
_nguong_khoi_1:
	.BYTE 0x2
_nguong_khoi_2:
	.BYTE 0x2
_nguong_as_1:
	.BYTE 0x2
_nguong_as_2:
	.BYTE 0x2
_nguong_nhiet:
	.BYTE 0x2
_m:
	.BYTE 0x2
_n:
	.BYTE 0x2
_mode2:
	.BYTE 0x2
__base_y_G100:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1
__seed_G102:
	.BYTE 0x4

	.CSEG

	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

	.equ __w1_port=0x15
	.equ __w1_bit=0x03

_w1_init:
	clr  r30
	cbi  __w1_port,__w1_bit
	sbi  __w1_port-1,__w1_bit
	__DELAY_USW 0x3C0
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x25
	sbis __w1_port-2,__w1_bit
	ret
	__DELAY_USB 0xCB
	sbis __w1_port-2,__w1_bit
	ldi  r30,1
	__DELAY_USW 0x30C
	ret

__w1_read_bit:
	sbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x5
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x1D
	clc
	sbic __w1_port-2,__w1_bit
	sec
	ror  r30
	__DELAY_USB 0xD5
	ret

__w1_write_bit:
	clt
	sbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x5
	sbrc r23,0
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x23
	sbic __w1_port-2,__w1_bit
	rjmp __w1_write_bit0
	sbrs r23,0
	rjmp __w1_write_bit1
	ret
__w1_write_bit0:
	sbrs r23,0
	ret
__w1_write_bit1:
	__DELAY_USB 0xC8
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0xD
	set
	ret

_w1_read:
	ldi  r22,8
	__w1_read0:
	rcall __w1_read_bit
	dec  r22
	brne __w1_read0
	ret

_w1_write:
	ldi  r22,8
	ld   r23,y+
	clr  r30
__w1_write0:
	rcall __w1_write_bit
	brtc __w1_write1
	ror  r23
	dec  r22
	brne __w1_write0
	inc  r30
__w1_write1:
	ret

_w1_dow_crc8:
	clr  r30
	ld   r24,y
	tst  r24
	breq __w1_dow_crc83
	ldi  r22,0x18
	ldd  r26,y+1
	ldd  r27,y+2
__w1_dow_crc80:
	ldi  r25,8
	ld   r31,x+
__w1_dow_crc81:
	mov  r23,r31
	eor  r23,r30
	ror  r23
	brcc __w1_dow_crc82
	eor  r30,r22
__w1_dow_crc82:
	ror  r30
	lsr  r31
	dec  r25
	brne __w1_dow_crc81
	dec  r24
	brne __w1_dow_crc80
__w1_dow_crc83:
	adiw r28,3
	ret

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

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

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__ASRW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __ASRW12R
__ASRW12L:
	ASR  R31
	ROR  R30
	DEC  R0
	BRNE __ASRW12L
__ASRW12R:
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__LNEGB1:
	TST  R30
	LDI  R30,1
	BREQ __LNEGB1F
	CLR  R30
__LNEGB1F:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
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

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
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
