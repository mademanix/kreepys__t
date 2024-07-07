; --- initial config for DASM ---	
	PROCESSOR 6502

	include "vcs.h"
	include "macro.h"
	
; --- consts ---
	include "defs.inc"
	include "colors.inc"
NTSC 			= 1
PAL 			= 2
SECAM 			= 3
START 			= $F000

; --- define RAM Usage
	SEG.U VARS
	ORG $80
; WIP
	
; --- program code ---
	SEG CODE
    ORG START			; ROM begin, 4K ROM

Init:
	CLEAN_START			; from macro.h

MainLoop:
    JSR WaitVSync     	; Wait for vertical sync
	JSR WaitVBlank		; Wait for vertical blank
    JSR Kernel      	; Draw a frame
	JSR WaitOverScan	; Wait for OverScan
    JMP MainLoop       	; Repeat

WaitVSync:
    LDA #2
	STA VSYNC
    STA WSYNC
    STA WSYNC
    STA WSYNC
	LDA #0
	STA WSYNC
	STA VSYNC
    RTS
	
; --- logic goes here ---
; --- currently wait for 37 scanlines
WaitVBlank:
    LDA #0
	STA VBLANK
	LDX #37
WaitVBlankLoop:
	STA WSYNC
	DEX
	BNE WaitVBlankLoop
	RTS

Kernel:
	; LDX GASTERCOLOR
	LDX #0
	LDY #0
	LDA #192
	
KernelLoop:
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	STX COLUBK
	NOP
	NOP
	NOP
	DEY
	STY COLUBK
	STA WSYNC

	TAX

	DEX

	TXA

	BNE KernelLoop
	
	RTS
	
WaitOverScan: 
	STA WSYNC
	LDA #2
	STA VBLANK
	LDX #27
	
WaitOverScannLoop:
	STA WSYNC
	DEX
	BNE WaitOverScannLoop
	RTS

; --- say goodbye ---
	ORG $FFFA       ; 6507 interrupt vectors address   
	.WORD Init		; NMI
	.WORD Init      ; RESET      
	.WORD Init		; IRQ
	
