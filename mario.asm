INCLUDE "charmap.asm"
INCLUDE "gbhw.asm"
INCLUDE "wram.asm"
INCLUDE "hram.asm"

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
	jp VBlank

SECTION "Interrupt LCD STAT", ROM0[$0048]
	jp LCDStatus

SECTION "Interrupt Timer", ROM0[$0050]
; Switch to bank 3 (XXX contains music code?)
; Overlaps into serial interrupt mid opcode, but it's unused anyway
	push af
	ld a, $03
	ld [MBC1RomBank], a
	call $7FF0 ; TODO
	ld a, [$FF00+$FD] ; Some sort of last active ROM bank?
	ld [MBC1RomBank], a
	pop af
	reti

VBlank:: ; $0060
; Coincides with the joypad interrupt, which is unused afaict
	push af
	push bc
	push de
	push hl
	call $2258			; Loading in new areas of the map
	call $1B86			; Collision with coins, coin blocks, etc...?
	call UpdateLives
	call hDMARoutine
	call DisplayScore
	call $3D6A			; Update time?
	call $2401
	ld hl, $FFAC
	inc [hl]
	ld a, [$FF00+$B3]	; TODO Gamestate?
	cp a, $3A			; Game over?
	jr nz, .jmp_88
	ld hl, rLCDC
	set 5, [hl]			; Turn on window
.jmp_88
	xor a
	ld [rSCX], a
	ld [rSCY], a
	inc a
	ld [$FF00+$85], a
	pop hl
	pop de
	pop bc
	pop af
	reti

LCDStatus::
	push af
	push hl
.wait
	ld a, [rSTAT]
	and a, $03
	jr nz, .wait	; Wait for HBlank
	ld a, [$C0A5]
	and a
	jr nz, .jmp_CF
	ld a, [$FF00+$A4]
	ld [rSCX], a
	ld a, [$C0DE]
	and a
	jr z, .jmp_B2
	ld a, [$C0DF]
	ld [rSCY], a
.jmp_B2
	ld a, [$FF00+$B3]
	cp a, $3A
	jr nz, .jmp_CC
	ld hl, rWY
	ld a, [hl]
	cp a, $40
	jr z, .jmp_DE
	dec [hl]
	cp a, $87
	jr nc, .jmp_CC
.jmp_C5
	add a, $08
	ld [rLYC], a
	ld [$C0A5], a
.jmp_CC
	pop hl
	pop af
	reti
.jmp_CF
	ld hl, rLCDC
	res 5, [hl]		; Turn off Window
	ld a, $0F
	ld [rLYC], a
	xor a
	ld [$C0A5], a
	jr .jmp_CC
.jmp_DE
	push af
	ld a, [$FF00+$FB]
	and a
	jr z, .jmp_EA
	dec a
	ld [$FF00+$FB], a
.jmp_E7
	pop af
	jr .jmp_C5
.jmp_EA
	ld a, $FF
	ld [$C0AD], a
	jr .jmp_E7


SECTION "Entry point", ROM0[$0100]
	nop
	jp Start

; Missing values will be filled in by rgbfix
SECTION "Header", ROM0[$104]
	ds $30		; Nintendo Logo
				; SUPER MARIOLAND in ASCII
	db $53, $55, $50, $45, $52, $20, $4D, $41, $52, $49, $4F, $4C, $41, $4E, $44
	db 00		; DMG - classic Game Boy
	db 00, 00	; No new licensee code
	db 00		; No SGB functions
	db 01		; MBC1 
	db 01		; 64kB, 4 banks
	db 00		; No RAM
	db 00		; Japanese
	db 01		; Old licensee code: Nintendo
	db 01		; First revision
	ds 1		; Header Checksum
	ds 2		; Global Checksum

Start::	; 0150
	jp Init

INCBIN "baserom.gb", $0153, $0185 - $0153
Init::	; 0185
	ld a, (1 << VBLANK) | (1 << LCD_STAT)
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
	ld b, DMARoutineEnd - DMARoutine + 2 ; TODO
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

INCBIN "baserom.gb", $05E7, $1C33 - $05E7

; 1C33
UpdateLives::
	ld a, [$FF00+$9F]	; Demo mode?
	and a
	ret nz
	ld a, [$C0A3]		; FF removes one life, any other non-zero value adds one
	or a
	ret z
	cp a, $FF			; FF = -1
	ld a, [wNumLives]
	jr z, .loseLife
	cp a, $99			; Saturate at 99 lives
	jr z, .out
	push af
	ld a, $08
	ld [$DFE0], a
	ld [$FF00+$D3], a
	pop af
	add a, 1			; Add one life
.displayLives
	daa
	ld [wNumLives], a
	ld a, [wNumLives]	; Huh? Bug?
	ld b, a
	and a, $0F
	ld [$9807], a
	ld a, b
	and a, $F0
	swap a
	ld [$9806], a		; TODO Gives these fellas a name
.out
	xor a
	ld [$C0A3], a
	ret
.gameOver
	ld a, $39			; Game over :'(
	ld [$FF00+$B3], a	; Game state TODO
	ld [$C0A4], a
	jr .out
.loseLife
	and a
	jr z, .gameOver		; No lives anymore
	sub a, 1			; Subtract one life
	jr .displayLives

INCBIN "baserom.gb", $1C7C, $3F39 - $1C7C

; Display the score at wScore. Print spaces instead of leading zeroes
DisplayScore::
	ld a, [$FF00+$B1]	; Some check to see if the score needs to be  
	and a				; updated?
	ret z
	ld a, [$C0E2]
	and a
	ret nz
	ld a, [$FF00+$EA]
	cp a, 02
	ret z
	ld de, wScore + 2	; Start with the ten and hundred thousands
	ld hl, $9820		; TODO VRAM layout
	xor a
	ld [$FF00+$B1], a	; Start by printing spaces instead of leading zeroes
	ld c, $03			; Maximum 3 digit pairs
.printDigitPair
	ld a, [de]
	ld b, a
	swap a				; Start with the more significant digit
	and a, $0F
	jr nz, .startNumber1
	ld a, [$FF00+$B1]	; If it's zero, check if the number has already started
	and a
	ld a, 0
	jr nz, .printFirstDigit
	ld a, $2C			; If not, start with spaces, not leading zeroes
.printFirstDigit
	ldi [hl], a			; Place the digit or space in VRAM
	ld a, b				; Now the lesser significant digit
	and a, $0F
	jr nz, .startNumber2; If non-zero, number has started (or already is)
	ld a, [$FF00+$B1]
	and a				; If zero, check if already started
	ld a, 0
	jr nz, .printSecondDigit
	ld a, 1				; If the number still hasn't started at the ones,
	cp c				; score is 0. Print just one 0
	ld a, 0
	jr z, .printSecondDigit
	ld a, $2C			; Otherwise, print another space
.printSecondDigit
	ldi [hl], a			; Put the second digit in VRAM
	dec e				; Go to the next pair of digits in memory
	dec c				; Which is less significant
	jr nz, .printDigitPair
	xor a
	ld [$FF00+$B1], a
	ret
.startNumber1
	push af
	ld a, 1
	ld [$FF00+$B1], a	; Number has start, print "0" instead of " "
	pop af
	jr .printFirstDigit
.startNumber2
	push af
	ld a, 1
	ld [$FF00+$B1], a	; Number has start, print "0" instead of " "
	pop af
	jr .printSecondDigit

DMARoutine::
	ld a, wOAMBuffer / $100
	ld [rDMA], a
	ld a, $28
.wait
	dec a
	jr nz, .wait
	ret
DMARoutineEnd:

; TODO Give this a name
db "mario*    world time"
db "       $*   1-1  000"

; TODO contains the flickering candle from world 1-3, the waves from 2-1
; maybe more animated sprites
INCBIN "baserom.gb", $3FC4, $4000 - $3FC4
SECTION "bank1", ROMX, BANK[1]
INCBIN "baserom.gb", $4000, $4000

SECTION "bank2", ROMX, BANK[2]
INCBIN "baserom.gb", $8000, $4000

SECTION "bank3", ROMX, BANK[3]
INCBIN "baserom.gb", $C000, $4000

