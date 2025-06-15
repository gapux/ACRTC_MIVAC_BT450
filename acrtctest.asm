;registers definition
;system regs
OPCN	equ	0fffeh
OPSEL	equ	0fffdh
OPHA	equ	0fffch
DULA	equ	0fffbh
IULA	equ	0fffah
TULA	equ	0fff9h
SULA	equ	0fff8h
WCY2	equ	0fff6h
WCY1	equ	0fff5h
WMB	equ	0fff4h
RFC	equ	0fff2h
TCKS	equ	0fff0h

;peripheral regs
IRQ	equ	104h
IIW1	equ	104h
IPFW	equ	104h
IMDW	equ	104h
IMKW	equ	105h
IIW2	equ	105h
IIW3	equ	105h
IIW4	equ	105h


TCT0	equ	114h
TCT1	equ	115h
TCT2	equ	116h
TMD	equ	117h

SRB	equ	124h
STB	equ	124h
SST	equ	125h
SCM	equ	125h
SMD	equ	126h
SIMK	equ	127h

DICM	equ	130h
DCH	equ	131h
DBCL	equ	132h
DBCH	equ	133h
DBAL	equ	134h
DBAH	equ	135h
DBAU	equ	136h
DDCL	equ	138h
DDCH	equ	139h
DMD	equ	13ah
DST	equ	13bh
DMK	equ	13ch


;constants
DIV16_96		equ 	12; clock 7.3728MHz, clock prescale 4, 16 clocks per bit, 9600bps
TSTPTN equ 0a5h


	org 0h

;entry point (0f000h:0000h)

ENTRY:


;init peripheral
	mov dx,OPCN
	mov al,00001111b	;intl1=scu,intl2=tct1
	out dx,al

	mov dx,OPSEL
	mov al,00001111b	;scu,tcu,icu,dmau enable
	out dx,al

	mov dx,OPHA
	mov al,1h	;internal periph.high addr=1h(0100h)
	out dx,al

	mov dx,DULA
	mov al,30h	;dmau low address=3xh(013xh)
	out dx,al

	mov dx,IULA
	mov al,04h	;icu low address=04h(0104h-0107h)
	out dx,al

	mov dx,TULA
	mov al,14h	;tcu low address=14h(0114h-0117h)
	out dx,al

	mov dx,SULA
	mov al,24h	;scu low address=24h(0124h-0127h)
	out dx,al

	mov dx,WMB
	mov al,73h	;lmb=lower512kb,umb=highest 128kb
	out dx,al

	mov dx,WCY1
	mov al,00000000b	;io 0waits,um 0waits,mm,lm 0waits
	out dx,al

	mov dx,WCY2
	mov al,00001000b	;dma 2waits, refresh 0waits
	out dx,al

	mov dx,RFC
	mov al,00001011b	;disable refresh, timer factor 11
	out dx,al

	mov dx,TCKS
	mov al,00000001b	;all timers internal clock prescale by 4
	out dx,al

;set peripherals registers

;
	mov dx,TMD
	mov al,00110110b	;set tct0 in mode 3
	out dx,al
	mov dx,TCT0
	mov al,00
	out dx,al
	mov al,0f0h
	out dx,al

	mov dx,TMD
	mov al,01110110b	;set tct1 in mode 3
	out dx,al
	mov dx,TCT1
	mov al,DIV16_96	;9600bpsx16
	out dx,al
	mov al,00h
	out dx,al

	mov dx,TMD
	mov al,10110110b	;set tct2 in mode 3
	out dx,al
	mov dx,TCT2
	mov al,33h	;freq. ca. 1kHz
	out dx,al
	mov al,07h
	out dx,al

;set scu
	mov dx,SMD
	mov al,01001110b	;stop:1,parity:n,data:8,clk:1/16
	out dx,al

	mov dx,SCM
	mov al,00110101b	
;SRDY,clear error flag, txd, reception enable, transmission enable
	out dx,al

	mov dx,SIMK
	mov al,00000010b	;tbrdy:masked,rbrdy:not masked
	out dx,al

	mov dx,IIW1
	mov al,00010010b	;edge trigger, single, no iiw4write
	out dx,al

	mov dx,IIW2
	mov al,00000000b	;int vector set to 0
	out dx,al

	mov dx,IIW3
	mov al,00000000b	;none slave input
	out dx,al

	mov dx,IIW4
	mov al,00000011b	;self f1 mode
	out dx,al

	mov dx,IMKW
	mov al,11111111b	;all ints are masked
	out dx,al

	mov dx,IPFW
	mov al,00000000b	;
	out dx,al

	mov dx,IMDW
	mov al,00001000b	;nop
	out dx,al

	mov dx,DICM
	mov al,00000000b	;dma0 reset
	out dx,al

	mov dx,DCH
	mov al,00000000b	;dma1 reset
	out dx,al

	mov dx,DBCL
	mov al,00000000b	;dma2 reset
	out dx,al

	mov dx,DBCH
	mov al,00000000b	;dma3 reset
	out dx,al

	mov dx,DBAL
	mov al,00000000b	;dma reset
	out dx,al

	mov dx,DBAH
	mov al,00000000b	;dma reset
	out dx,al

	mov dx,DBAU
	mov al,00000000b	;dma reset
	out dx,al

	mov dx,DDCL
	mov al,00000000b	;dma reset
	out dx,al

	mov dx,DDCH
	mov al,00000000b	;dma reset
	out dx,al

	mov dx,DMD
	mov al,00000000b	;dma reset
	out dx,al

	mov dx,DST
	mov al,00000000b	;dma reset
	out dx,al

	mov dx,DMK
	mov al,00000000b	;dma reset
	out dx,al


;start
	mov dx,0200h
	mov al,0
	out dx,al		;turn off leds

	
	mov dx,TMD
	mov al,10110110b	;set tct2 in mode 3
	out dx,al
	mov dx,TCT2
	mov al,43h	;freq. ca. 1kHz
	out dx,al
	mov al,07h
	out dx,al
	
	mov cx,0C000h
SLOOP1:
	nop
	nop
	nop
	nop
	nop
	nop
	nop

	loop SLOOP1

	
	mov dx,TMD
	mov al,10110000b	;set tct2 in mode 0
	out dx,al
	mov dx,TCT2
	mov al,2eh	;freq. ca. 1kHz
	out dx,al
	mov al,07h
	out dx,al

	

;initialize dram
;enable refresh
	mov dx,RFC
	mov al,10000111b	;enable refresh, timer factor 8
	out dx,al
	mov cx,54000
SLOOP2:
	nop
	nop
	nop

	loop SLOOP2



	mov dx,TMD
	mov al,10110110b	;set tct2 in mode 3
	out dx,al
	mov dx,TCT2
	mov al,0cch	;freq. ca. 250Hz
	out dx,al
	mov al,1ch
	out dx,al
ACRTC_RS EQU 0400h
ACRTC_RG EQU 0402h
DAC_REG equ 0404h
DAC_PAL equ 0406h

;init DAC

;0 (black) r-g-b 0-0-0
	mov dx, DAC_REG
	mov al, 0
	out dx, al
	mov dx, DAC_PAL
	mov al, 0
	out dx, al
	mov al, 0
	out dx, al
	mov al, 0
	out dx, al

;1 (maroon)8-0-0
	mov dx, DAC_REG
	mov al, 1
	out dx, al
	mov dx, DAC_PAL
	mov al, 8
	out dx, al
	mov al, 0
	out dx, al
	mov al, 0
	out dx, al

;2 (green)0-8-0
	mov dx, DAC_REG
	mov al, 2
	out dx, al
	mov dx, DAC_PAL
	mov al, 0
	out dx, al
	mov al, 8
	out dx, al
	mov al, 0
	out dx, al

;3 (olive)8-8-0
	mov dx, DAC_REG
	mov al, 3
	out dx, al
	mov dx, DAC_PAL
	mov al, 8
	out dx, al
	mov al, 8
	out dx, al
	mov al, 0
	out dx, al

;4 (navy)0-0-8
	mov dx, DAC_REG
	mov al, 4
	out dx, al
	mov dx, DAC_PAL
	mov al, 0
	out dx, al
	mov al, 0
	out dx, al
	mov al, 8
	out dx, al

;5 (purple)8-0-8
	mov dx, DAC_REG
	mov al, 5
	out dx, al
	mov dx, DAC_PAL
	mov al, 8
	out dx, al
	mov al, 0
	out dx, al
	mov al, 8
	out dx, al

;6 (teal)0-8-8
	mov dx, DAC_REG
	mov al, 6
	out dx, al
	mov dx, DAC_PAL
	mov al, 0
	out dx, al
	mov al, 8
	out dx, al
	mov al, 8
	out dx, al

;7 (gray)8-8-8
	mov dx, DAC_REG
	mov al, 7
	out dx, al
	mov dx, DAC_PAL
	mov al, 8
	out dx, al
	mov al, 8
	out dx, al
	mov al, 8
	out dx, al

;8 (silver)12-12-12
	mov dx, DAC_REG
	mov al, 8
	out dx, al
	mov dx, DAC_PAL
	mov al, 12
	out dx, al
	mov al, 12
	out dx, al
	mov al, 12
	out dx, al

;9 (red)15-0-0
	mov dx, DAC_REG
	mov al, 9
	out dx, al
	mov dx, DAC_PAL
	mov al, 15
	out dx, al
	mov al, 0
	out dx, al
	mov al, 0
	out dx, al

;10 (lime)0-15-0
	mov dx, DAC_REG
	mov al, 10
	out dx, al
	mov dx, DAC_PAL
	mov al, 0
	out dx, al
	mov al, 15
	out dx, al
	mov al, 0
	out dx, al

;11 (yellow)15-15-0
	mov dx, DAC_REG
	mov al, 11
	out dx, al
	mov dx, DAC_PAL
	mov al, 15
	out dx, al
	mov al, 15
	out dx, al
	mov al, 0
	out dx, al

;12 (blue)0-0-15
	mov dx, DAC_REG
	mov al, 12
	out dx, al
	mov dx, DAC_PAL
	mov al, 0
	out dx, al
	mov al, 0
	out dx, al
	mov al, 15
	out dx, al

;13 (magenta)15-0-15
	mov dx, DAC_REG
	mov al, 13
	out dx, al
	mov dx, DAC_PAL
	mov al, 15
	out dx, al
	mov al, 0
	out dx, al
	mov al, 15
	out dx, al

;14 (cyan)0-15-15
	mov dx, DAC_REG
	mov al, 14
	out dx, al
	mov dx, DAC_PAL
	mov al, 0
	out dx, al
	mov al, 15
	out dx, al
	mov al, 15
	out dx, al

;15 (white)15-15-15
	mov dx, DAC_REG
	mov al, 15
	out dx, al
	mov dx, DAC_PAL
	mov al, 15
	out dx, al
	mov al, 15
	out dx, al
	mov al, 15
	out dx, al



;init ACRTC
 

;display timings
	mov dx, ACRTC_RS
	mov al, 82h
	out dx, al
	mov dx, ACRTC_RG

;vga timings period 800 sync 96 front p.16 back p. 48
;1tcy=16dots (single mode)
;horiz. period = 50tcy(31h), sync width= 6tcy, front =1tcy, back =3tcy, disp. period =40tcy(27h)
; display skew(r04, bit1:0) = 0tcy
;r82-r83 3106h, r84-r85 0227h(not satisfying ACRTC front porch length)

;modified timings
; Horiz. period=50tcy(31h), sync width=3tcy, backporch2tcy
; display skew(r04, bit1:0) = 0tcy  

	mov al, 31h
	out dx, al
	mov al, 03h
	out dx, al
	mov al, 01h
	out dx, al
	mov al, 27h
	out dx, al


;r86-r87 020dh, r88-r89 2102h Vert. 1 (VC, VDS, VSW)
	mov al, 02h
	out dx, al
	mov al, 0dh
	out dx, al
	mov al, 21h
	out dx, al
	mov al, 02h
	out dx, al

;r8A-r8b 01e0h Vert. 2 (VDW)
	mov al, 01h
	out dx, al
	mov al, 0e0h
	out dx, al

;r8c-r8d 0001h Vert. SP1
	mov al, 00h
	out dx, al
	mov al, 00h
	out dx, al

;r8e-r8f 0001h Vert. SP2
	mov al, 00h
	out dx, al
	mov al, 00h
	out dx, al

;r90 00h blink 1
	mov al, 00h
	out dx, al

;r91 00h blink 2
	mov al, 00h
	out dx, al

;r92 01h Horiz. Window start
	mov al, 01h
	out dx, al

;r93 01h Horiz. Window width
	mov al, 01h
	out dx, al

;r94-r95 0001h Vert.Window start
	mov al, 00h
	out dx, al
	mov al, 01h
	out dx, al

;r96-r97 0001h Vert. Window height
	mov al, 00h
	out dx, al
	mov al, 01h
	out dx, al

;r98-r99 0000h Graph. cursor X
	mov al, 00h
	out dx, al
	mov al, 00h
	out dx, al

;r9A-r9B 0000h Graph. cursor YS
	mov al, 00h
	out dx, al
	mov al, 00h
	out dx, al
	
;r9C-r9D 0000h Graph. cursor YE
	mov al, 00h
	out dx, al
	mov al, 00h
	out dx, al


;Memory Width
	mov dx, ACRTC_RS
	mov al, 0c0h
	out dx, al
	mov dx, ACRTC_RG

;rc0-rc1 0000h LRA1, FRA1
	mov al, 00h
	out dx, al
	mov al, 00h
	out dx, al

;rc2-rc3 00a0h Mem. Width 1
	mov al, 00h
	out dx, al
	mov al, 0a0h
	out dx, al

;rc4-rc5 0000h SDA1, SAH1/SRA1
	mov al, 00h
	out dx, al
	mov al, 00h
	out dx, al

;rc6-rc7 0000h SAL1
	mov al, 00h
	out dx, al
	mov al, 00h
	out dx, al

;rc8-rc9 0000h LRAB, FRAB
	mov al, 00h
	out dx, al
	mov al, 00h
	out dx, al

;rca-rcb 00a0h Mem. Width Base
	mov al, 00h
	out dx, al
	mov al, 0a0h
	out dx, al

;rcc-rcd 0004h SDAB, SAHB/SRAB 40000h
	mov al, 00h
	out dx, al
	mov al, 04h
	out dx, al

;rce-rcf 0000h SALB
	mov al, 00h
	out dx, al
	mov al, 00h
	out dx, al

;rd0-rd1 0000h LRA1, FRA1
	mov al, 00h
	out dx, al
	mov al, 00h
	out dx, al

;rd2-rd3 00a0h Mem. Width 2
	mov al, 00h
	out dx, al
	mov al, 0a0h
	out dx, al

;rd4-rd5 0000h SDA2, SAH/SRA2
	mov al, 00h
	out dx, al
	mov al, 00h
	out dx, al

;rd6-rd7 0000h SAL2
	mov al, 00h
	out dx, al
	mov al, 00h
	out dx, al

;rd8-rd9 0000h LRAW, FRAW
	mov al, 00h
	out dx, al
	mov al, 00h
	out dx, al

;rda-rdb 00a0h Mem. Width Window
	mov al, 00h
	out dx, al
	mov al, 0a0h
	out dx, al

;rdc-rdd 0000h SDAW, SAH/SRAW
	mov al, 00h
	out dx, al
	mov al, 00h
	out dx, al

;rde-rdf 0000h SALW
	mov al, 00h
	out dx, al
	mov al, 00h
	out dx, al

;re0-re1 0000h CCW1, CCSR1, CCER1
	mov al, 00h
	out dx, al
	mov al, 00h
	out dx, al

;re2-re3 0000h CCA1
	mov al, 00h
	out dx, al
	mov al, 00h
	out dx, al

;re4-re5 0000h CCW2, CCSR2, CCER2
	mov al, 00h
	out dx, al
	mov al, 00h
	out dx, al

;re6-re7 0000h CCA2
	mov al, 00h
	out dx, al
	mov al, 00h
	out dx, al

;re8-re9 0000h CM, CON1, COFF1, CON2, COFF2
	mov al, 00h
	out dx, al
	mov al, 00h
	out dx, al

;rea 00h HZF, VZF
	mov al, 00h
	out dx, al


;MIVAC MODE F (640x480, 4bpp, 2-chip ram, 16/960, +4SA, 1Mx8)

;basic settings
;r02-r03 0200h
	mov dx, ACRTC_RS
	mov al, 02h
	out dx, al
	mov dx, ACRTC_RG
	mov al, 02h
	out dx, al
	mov dx, ACRTC_RS
	mov al, 03h
	out dx, al
	mov dx, ACRTC_RG
	mov al, 00h
	out dx, al


;r06-r07 c06fh
	mov dx, ACRTC_RS
	mov al, 06h
	out dx, al
	mov dx, ACRTC_RG
	mov al, 0c0h
	out dx, al
	mov dx, ACRTC_RS
	mov al, 07h
	out dx, al
	mov dx, ACRTC_RG
	mov al, 6fh
	out dx, al
;attrib. MUXEN=0,VMD=1(1Mx4),CUR1=1:0=10b(color code inverted),VCF3:0=0fh(Mode F)

;r04-r05 8020h
;DRAM, +4SA for 2-chip
	mov dx, ACRTC_RS
	mov al, 04h
	out dx, al
	mov dx, ACRTC_RG
	mov al, 80h		;Master, Disp skew 0tcy
	out dx, al
	mov dx, ACRTC_RS
	mov al, 05h
	out dx, al
	mov dx, ACRTC_RG
	mov al, 20h		;DRAM, +4SA, noninterlace
	out dx, al





;start display signal
SDLOOP:
	mov cx, 100
	nop
	loop SDLOOP

	mov dx, ACRTC_RS
	mov al, 04h
	out dx, al

;
	mov dx, ACRTC_RG
	in al, dx
	or al, 40h	;sta=1
	out dx, al
;start
;ACRTC_RS EQU 0400h
;ACRTC_RG EQU 0402h
;DAC_REG equ 0404h
;DAC_PAL equ 0406h

A_ORG_H equ 04h
A_ORG_L equ 00h
A_WPR_H equ 08h
A_WPR_L equ 00h
A_RPR_H equ 0ch
A_RPR_L equ 00h
A_WPTN_H equ 18h
A_WPTN_L equ 00h
A_RPTN_H equ 1ch
A_RPTN_L equ 00h

A_CL0 equ 00h
A_CL1 equ 01h
A_CCMP equ 02h
A_EDG equ 03h
A_MASK equ 04h
A_PRC5 equ 05h
A_PRC6 equ 06h
A_PRC7 equ 07h
A_XMIN equ 08h
A_YMIN equ 09h
A_XMAX equ 0ah
A_YMAX equ 0bh
A_RWPH equ 0ch
A_RWPL equ 0dh
A_DPAH equ 10h
A_DPAL equ 11h
A_CPX equ 12h
A_CPY equ 13h

A_RMV_H equ 84h
A_RMV_L equ 00h

;write down register value at ds:bx=f8000h
	mov ax, 0f000h
	mov ds, ax
	mov bx, 8002h
	mov ah, 02h
READREGS:
	mov dx, ACRTC_RS
	mov al, ah
	out dx, al
	mov dx, ACRTC_RG
	in al, dx
	mov byte ptr [bx], al
	inc bx
	inc ah
	jnz READREGS

;
	mov dx, ACRTC_RS
	mov al, 0	;Command FIFO
	out dx, al

;
	mov dx, ACRTC_RG
;set display origin
	mov al,A_ORG_H
	out dx, al
	mov al,A_ORG_L
	out dx, al
; base display origin at 40000h+0dot
	mov al,40h
	out dx, al
	mov al,40h
	out dx, al

	mov al,00h
	out dx, al
	mov al,00h
	out dx, al



; wait for write fifo empty
WATFIFO1:
	mov dx, ACRTC_RS
	mov al, 0	
	in al, dx	;read status
	test al, 1	;Write FIFO empty?
	jz WATFIFO1
;
	mov dx, ACRTC_RG

;set CL0
	mov al,A_WPR_H
	out dx, al
	mov al,A_WPR_L
	or al,A_CL0
	out dx, al
; 
	mov al,00h
	out dx, al
	mov al,00h
	out dx, al

;set CL1
	mov al,A_WPR_H
	out dx, al
	mov al,A_WPR_L
	or al,A_CL1
	out dx, al
; 
	mov al,0ffh
	out dx, al
	mov al,0ffh
	out dx, al

; wait for write fifo empty
WATFIFO2:
	mov dx, ACRTC_RS
	mov al, 0	
	in al, dx	;read status
	test al, 1	;Write FIFO empty?
	jz WATFIFO2
;
	mov dx, ACRTC_RG

;set XMIN=0, XMAX=639
	mov al,A_WPR_H
	out dx, al
	mov al,A_WPR_L
	or al,A_XMIN
	out dx, al
; 
	mov al,00h
	out dx, al
	mov al,000h
	out dx, al
;
	mov al,A_WPR_H
	out dx, al
	mov al,A_WPR_L
	or al,A_XMAX
	out dx, al
; 
	mov al,02h
	out dx, al
	mov al,07fh
	out dx, al




;set YMIN=-479, YMAX=0
	mov al,A_WPR_H
	out dx, al
	mov al,A_WPR_L
	or al,A_YMIN
	out dx, al
; 
	mov al,0feh
	out dx, al
	mov al,21h
	out dx, al
;
	mov al,A_WPR_H
	out dx, al
	mov al,A_WPR_L
	or al,A_YMAX
	out dx, al
; 
	mov al,00h
	out dx, al
	mov al,00h
	out dx, al


; wait for write fifo empty
WATFIFO3:
	mov dx, ACRTC_RS
	mov al, 0	
	in al, dx	;read status
	test al, 1	;Write FIFO empty?
	jz WATFIFO3
;
	mov dx, ACRTC_RG




;reset boundary checker (RMOVE 0, 0)
	mov al, A_RMV_H
	out dx, al
	mov al, A_RMV_L
	out dx, al
	mov al, 0
	out dx, al
	mov al, 0
	out dx, al
	mov al, 0
	out dx, al
	mov al, 0
	out dx, al

WATFIFO4:
	mov dx, ACRTC_RS
	mov al, 0	
	in al, dx	;read status
	test al, 1	;Write FIFO empty?
	jz WATFIFO4
;
	mov dx, ACRTC_RG


;set PTN from 0
	mov al,A_WPTN_H
	out dx, al
	mov al,A_WPTN_L
	or al,0  ;start from PRA $0
	out dx, al
;write 2 words
	mov al,0
	out dx, al
	mov al,2
	out dx, al
;pattern 1 (PRA $0)
	mov al,0ffh
	out dx, al
	mov al,0ffh
	out dx, al
;pattern 2 (PRA $1)
	mov al,0f0h
	out dx, al
	mov al,0f0h
	out dx, al

; wait for write fifo empty
WATFIFO5:
	mov dx, ACRTC_RS
	mov al, 0	
	in al, dx	;read status
	test al, 1	;Write FIFO empty?
	jz WATFIFO5
;
	mov dx, ACRTC_RG

;clear block
	;set current pointer at display origin
	mov al,A_WPR_H
	out dx, al
	mov al,A_WPR_L
	or al, A_RWPH	;select RWP
	out dx, al

	mov al, 40h
	out dx, al
	mov al, 40h
	out dx, al

	mov al,A_WPR_H
	out dx, al
	mov al,A_WPR_L
	or al, A_RWPL
	out dx, al

	mov al, 00h
	out dx, al
	mov al, 00h 
	out dx, al

	;clr
	mov al,58h
	out dx, al
	mov al,00h
	out dx, al

	mov al, 00h
	out dx, al
	mov al, 00h
	out dx, al

	mov al, 00h
	out dx, al
	mov al, 9fh
	out dx, al

	mov al, 0feh
	out dx, al
	mov al, 21h 
	out dx, al

WATFIFO6:
	mov dx, ACRTC_RS
	mov al, 0	
	in al, dx	;read status
	test al, 1	;Write FIFO empty?
	jz WATFIFO6
;
	mov dx, ACRTC_RG

;select pattern
	mov al,A_WPR_H
	out dx, al
	mov al,A_WPR_L
	or al,A_PRC5
	out dx, al
;
	mov al,00h	;PPY=0, PZCY=0
	out dx, al
	mov al,00h	;PPX=0, PZCX=0
	out dx, al

	mov al,A_WPR_H
	out dx, al
	mov al,A_WPR_L
	or al,A_PRC6
	out dx, al
			;PY=0 (pattern PRA $0)
	mov al,00h	;PSY=0, void
	out dx, al
	mov al,00h	;PSX=0, void
	out dx, al

	mov al,A_WPR_H
	out dx, al
	mov al,A_WPR_L
	or al,A_PRC7
	out dx, al
;
	mov al,00h	;PEY=0, PZY=0 (1x)
	out dx, al
	mov al,0f0h	;PEX=15, PZX=0 (1x)
	out dx, al



; wait for write fifo empty
WATFIFO7:
	mov dx, ACRTC_RS
	mov al, 0	
	in al, dx	;read status
	test al, 1	;Write FIFO empty?
	jz WATFIFO7
;
	mov dx, ACRTC_RG


;AMOVE (0,0)
	mov al,80h
	out dx, al
	mov al,00h
	out dx, al

;x
	mov al,00h
	out dx, al
	mov al,00h
	out dx, al

;y
	mov al,00h
	out dx, al
	mov al,00h
	out dx, al



;ALINE -(639,-479),AREA=000b, COL=00b,OPM=000b 
	mov al,88h
	out dx, al
	mov al,000000000b
	out dx, al

;endx
	mov al,02h
	out dx, al
	mov al,7fh
	out dx, al

;endy
	mov al,0feh
	out dx, al
	mov al,21h
	out dx, al

;DOT (639,-479)
	mov al,0cch
	out dx, al
	mov al,000000000b
	out dx, al

WATFIFO8:
	mov dx, ACRTC_RS
	mov al, 0	
	in al, dx	;read status
	test al, 1	;Write FIFO empty?
	jz WATFIFO8
;
	mov dx, ACRTC_RG

;AMOVE (0,-479)
	mov al,80h
	out dx, al
	mov al,00h
	out dx, al

;x
	mov al,00h
	out dx, al
	mov al,00h
	out dx, al

;y
	mov al,0feh
	out dx, al
	mov al,21h
	out dx, al



; wait for write fifo empty
WATFIFO9:
	mov dx, ACRTC_RS
	mov al, 0	
	in al, dx	;read status
	test al, 1	;Write FIFO empty?
	jz WATFIFO9
;
	mov dx, ACRTC_RG


;select pattern
	mov al,A_WPR_H
	out dx, al
	mov al,A_WPR_L
	or al,A_PRC5
	out dx, al
;
	mov al,01h	;PPY=1, PZCY=0
	out dx, al
	mov al,00h	;PPX=0, PZCX=0
	out dx, al

	mov al,A_WPR_H
	out dx, al
	mov al,A_WPR_L
	or al,A_PRC6
	out dx, al
			;PY=1 (pattern PRA $1)
	mov al,10h	;PSY=1, void
	out dx, al
	mov al,00h	;PSX=0, void
	out dx, al

	mov al,A_WPR_H
	out dx, al
	mov al,A_WPR_L
	or al,A_PRC7
	out dx, al
;
	mov al,10h	;PEY=1, PZY=0 (1x)
	out dx, al
	mov al,0f0h	;PEX=15, PZX=0 (1x)
	out dx, al


; wait for write fifo empty
WATFIFOA:
	mov dx, ACRTC_RS
	mov al, 0	
	in al, dx	;read status
	test al, 1	;Write FIFO empty?
	jz WATFIFOA
;
	mov dx, ACRTC_RG


;ALINE -(639,0),AREA=000b, COL=00b,OPM=000b 
	mov al,88h
	out dx, al
	mov al,000000000b
	out dx, al

;endx
	mov al,02h
	out dx, al
	mov al,7fh
	out dx, al

;endy
	mov al,00h
	out dx, al
	mov al,00h
	out dx, al

;DOT (639,-479)
	mov al,0cch
	out dx, al
	mov al,000000000b
	out dx, al

;
;	jmp WATFIFO4
	hlt
	org 0fff0h
;jump to the entry point after reset
	jmp 0f000h:0000h



	end