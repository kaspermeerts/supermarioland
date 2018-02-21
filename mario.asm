INCLUDE "gbhw.asm"

SECTION "bank0", ROM0[$0000]

; RST addresses
SECTION "RST 0", ROM0[$0000]
	jp $0185

SECTION "RST 8", ROM0[$0008]
	jp $0185

SECTION "RST 28", ROM0[$0028]
; Immediately following the return address is a jump table
; A is used as index
TableJump::
	add a		; Multiply A by 2, as addresses are 16 bit
	pop hl
	ld e, a
	ld d, 00
	add hl, de	; Add the offset to the base address
	ld e, [hl]	; Load the address at that offset into DE
	inc hl
	ld d, [hl]
	push de		; Jump to the target address
	pop hl
	jp hl

; Interrupts
SECTION "Interrupt VBlank", ROM0[$0040]
	jp $60

SECTION "Interrupt LCD STAT", ROM0[$0048]
	jp $95

SECTION "Interrupt Timer", ROM0[$0050]
; Switch to bank 3 (XXX contains music code?)
	push af
	ld a, 03
	ld [MBC1RomBank], a
	call $7FF0
	ld a, [$FF00+$FD]
	ld [MBC1RomBank], a
	pop af
	reti

INCBIN "baserom.gb", $0060, $0100 - $0060

SECTION "Entry point", ROM0[$0100]
	nop
	jp Start

; TODO Declare this here, or use rgbfix?
INCBIN "baserom.gb", $0104, $0150 - $0104
Start::	; 0150
	jp Init

INCBIN "baserom.gb", $0153, $0185 - $0153
Init::	; 0185
	ld a, $03
	di
	ld [rIF], a
	ld [rIE], a
	ld a, $40
	ld [rSTAT], a
	xor a
	ld [rSCY], a
	ld [rSCX], a
	ldh [$A4], a
	ld a, $80
	ld [rLCDC], a
.wait
	ld a, [rLY]
	cp a, $94 ; TODO magic
	jr nz, .wait
	ld a, $3
	ld [rLCDC], a
	ld a, $E4
	ld [rBGP], a
	ld [rOBP0], a
	ld a, $54
	ld [rOBP1], a
	ld hl, rNR52
	ld a, $80
	ldd [hl], a		; Turn the sound on
	ld a, $FF
	ldd [hl], a		; Output all sounds to both terminals
	ld [hl], $77	; Turn the volume up to the max
	ld sp, $CFFF
	xor a
	ld hl, $DFFF	; End of Work RAM
	ld c, $40
	ld b, 0			; CB = $4000, size of Work RAM
.clearWRAMloop		; Also clears non-existent cartridge RAM. Bug?
	ldd [hl], a
	dec b
	jr nz, .clearWRAMloop
	dec c
	jr nz, .clearWRAMloop ; Why this doesn't use a loop on BC is beyond me...
	ld hl, $9FFF	; End of Video RAM
	ld c, $20		; CB = $2000, size of Video RAM
	xor a
	ld b, 0
.clearVRAMloop
	ldd [hl], a
	dec b
	jr nz, .clearVRAMloop
	dec c
	jr nz, .clearVRAMloop
	ld hl, $FEFF	; End of OAM (well, over the end)
	ld b, 0			; Underflow, clear $FF bytes
.clearOAMloop
	ldd [hl], a
	dec b
	jr nz, .clearOAMloop
	ld hl, $FFFE	; End of High RAM
	ld b, $80		; Size of High RAM
.clearHRAMloop
	ldd [hl], a
	dec b
	jr nz, .clearHRAMloop
	ld c, $FFB6 % $100 ; TODO Name?
	ld b, DMARoutineEnd - DMARoutine
	ld hl, DMARoutine
.copyDMAroutine		; No memory can be accessed during DMA other than HRAM,
	ldi a, [hl]		; so the routine is copied and executed there
	ld [$FF00+c], a ; together with two bytes I don't know the function of TODO
	inc c
	dec b
	jr nz, .copyDMAroutine

INCBIN "baserom.gb", $01FA, $05DE - $01FA

CopyData::	; 05DE
; Copy BC bytes from HL to DE
	ldi a, [hl]
	ld [de], a
	inc de
	dec bc
	ld a, b
	or c
	jr nz, CopyData
	ret

INCBIN "baserom.gb", $05E7, $3F92 - $05E7

DMARoutine::
	ld a, $C0 ; TODO Name
	ld [rDMA], a
	ld a, $28
.wait
	dec a
	jr nz, .wait
	ret
db $16, $0A ; TODO What's this?
DMARoutineEnd:

INCBIN "baserom.gb", $3F9E, $4000 - $3F9E

SECTION "bank1", ROMX, BANK[1]
INCBIN "baserom.gb", $4000, $4000

SECTION "bank2", ROMX, BANK[2]
INCBIN "baserom.gb", $8000, $4000

SECTION "bank3", ROMX, BANK[3]
INCBIN "baserom.gb", $C000, $4000

