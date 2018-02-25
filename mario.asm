INCLUDE "charmap.asm"
INCLUDE "gbhw.asm"
INCLUDE "wram.asm"
INCLUDE "hram.asm"

SECTION "bank0", ROM0[$0000]

; RST vectors
SECTION "RST 0", ROM0[$0000]
	jp Init

SECTION "RST 8", ROM0[$0008]
	jp Init

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
	ldh a, [$FF00+$FD] ; Some sort of last active ROM bank?
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
	call DisplayTimer
	call $2401
	ld hl, $FFAC
	inc [hl]
	ldh a, [hGameState]
	cp a, $3A			; Game over? TODO
	jr nz, .jmp_88
	ld hl, rLCDC
	set 5, [hl]			; Turn on window
.jmp_88
	xor a
	ldh [rSCX], a
	ldh [rSCY], a
	inc a
	ldh [$FF00+$85], a
	pop hl
	pop de
	pop bc
	pop af
	reti

; Update scroll registers. Don't understand the logic yet
LCDStatus::
	push af
	push hl
.wait
	ldh a, [rSTAT]
	and a, $03
	jr nz, .wait	; Wait for HBlank
	ld a, [$C0A5]
	and a
	jr nz, .jmp_CF
	ldh a, [$FF00+$A4]
	ldh [rSCX], a
	ld a, [$C0DE]
	and a
	jr z, .jmp_B2
	ld a, [$C0DF]
	ldh [rSCY], a
.jmp_B2
	ldh a, [hGameState]
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
	ldh [rLYC], a
	ld [$C0A5], a
.jmp_CC
	pop hl
	pop af
	reti
.jmp_CF
	ld hl, rLCDC
	res 5, [hl]		; Turn off Window
	ld a, $0F
	ldh [rLYC], a
	xor a
	ld [$C0A5], a
	jr .jmp_CC
.jmp_DE
	push af
	ldh a, [$FF00+$FB]
	and a
	jr z, .jmp_EA
	dec a
	ldh [$FF00+$FB], a
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

; FFAD is ~ x coordinate, FFAE ~ y coordinate
; FFAF least significant 5 bits are x, rest 3 are y??
; 3EE6 shifts and ands them together. But why?
; maybe find scroll coordinates from Mario's position in the level?
.mystery_153:
	call $3EE6
.wait1
	ldh a, [rSTAT]
	and a, $03
	jr nz, .wait1
	ld b, [hl]
.wait2
	ldh a, [rSTAT]
	and a, $03
	jr nz, .wait2
	ld a, [hl]
	and b
	ret

; Add BCD encoded DE to the score. Signal that the displayed version
; needs to be updated
AddScore:: ; 0166
	ldh a, [$FF00+$9F]	; Demo mode?
	and a
	ret nz
	ld a, e
	ld hl, wScore
	add [hl]
	daa
	ldi [hl], a
	ld a, d
	adc [hl]
	daa
	ldi [hl], a
	ld a, 0				; No score addition is larger than 9999
	adc [hl]			; Add 0 to propagate carry
	daa
	ld [hl], a
	ld a, 1
	ldh [$FF00+$B1], a	; TODO We've seen this address before
	ret nc
	ld a, $99			; Score saturates at 999999
	ldd [hl], a
	ldd [hl], a
	ld [hl], a
	ret

Init::	; 0185
	ld a, (1 << VBLANK) | (1 << LCD_STAT)
	di
	ldh [rIF], a
	ldh [rIE], a
	ld a, $40
	ldh [rSTAT], a
	xor a
	ldh [rSCY], a
	ldh [rSCX], a
	ldh [$A4], a
	ld a, $80
	ldh [rLCDC], a	; Turn LCD on, but don't display anything
.wait
	ldh a, [rLY]
	cp a, $94 ; TODO magic
	jr nz, .wait	; Waits for VBlank?
	ld a, $3
	ldh [rLCDC], a	; Turn LCD off
	ld a, $E4
	ldh [rBGP], a
	ldh [rOBP0], a
	ld a, $54
	ldh [rOBP1], a
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
	dec c			; Why this doesn't use a loop on BC is beyond me...
	jr nz, .clearWRAMloop
	ld hl, $9FFF	; End of Video RAM
	ld c, $20		; CB = $2000, size of Video RAM

	xor a			; Unnecessary
	ld b, 0
.clearVRAMloop
	ldd [hl], a
	dec b
	jr nz, .clearVRAMloop
	dec c
	jr nz, .clearVRAMloop

	ld hl, $FEFF	; End of OAM (well, over the end, bug?)
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

	ld c, LOW($FFB6) ; TODO Name?
	ld b, DMARoutineEnd - DMARoutine + 2 ; TODO Bug?
	ld hl, DMARoutine
.copyDMAroutine		; No memory can be accessed during DMA other than HRAM,
	ldi a, [hl]		; so the routine is copied and executed there
	ld [$FF00+c], a ; together with two bytes I don't know the function of TODO
	inc c
	dec b
	jr nz, .copyDMAroutine

	xor a
	ldh [$FF00+$E4], a
	ld a, $11
	ldh [$FF00+$B4], a
	ld [$C0A8], a
	ld a, 2
	ld [$C0DC], a
	ld a, $0E
	ldh [hGameState], a	; TODO
	ld a, 3
	ld [MBC1RomBank], a
	ld [$C0A4], a
	ld a, 0
	ld [$C0E1], a
	ldh [hWinCount], a
	call $7FF3			; This seems to set up sound
	ld a, 2
	ld [MBC1RomBank], a
	ldh [$FF00+$FD], a	; TODO Stores the ROM bank?? We've been over this

.jmp_226				; MAIN LOOP (well, i think)
	ld a, [$DA1D]		; TODO DA1D is 0 in normal play, 1 if time < 100
	cp a, 3				; 2 if time < 50, 3 if time == 0? FF if time up
	jr nz, .jmp_238
	ld a, $FF			; Here DA1D is changed from 3 to FF?
	ld [$DA1D], a
	call $09F1
	call $1736
.jmp_238
	ldh a, [$FF00+$FD]	; Again, ROM bank?
	ldh [$FF00+$E1], a	; temporarily store for some reason
	ld a, 3
	ldh [$FF00+$FD], a
	ld [MBC1RomBank], a
	call $47F2			; Determines pressed buttons (FF80) and new buttons (FF91)
	ldh a, [$FF00+$E1]
	ldh [$FF00+$FD], a	; another bank switch
	ld [MBC1RomBank], a
	ldh a, [$FF00+$9F]	; Demo mode?
	and a
	jr nz, .jmp_25A
	call $07DA			; TODO 7E5 reboots if A+B+Start+Select is pressed,
	ldh a, [$FF00+$B2]	; seems this also starts the game? Checks for Start
	and a
	jr nz, .jmp_296
.jmp_25A
	ld hl, $FFA6		; General purpose state counter?
	ld b, 2
.jmp_25F
	ld a, [hl]
	and a
	jr z, .jmp_264
	dec [hl]			; FFA6 and FFA7 are timers for frame based animations
.jmp_264
	inc l
	dec b
	jr nz, .jmp_25F
	ldh a, [$FF00+$9F]	; Demo mode?
	and a
	jr z, .jmp_293
	ldh a, [$FF00+$80]		; keys pressed
	bit 3, a			; test for Start
	jr nz, .jmp_283
	ldh a, [$FF00+$AC]
	and a, $0F
	jr nz, .jmp_293
	ld hl, $C0D7
	ld a, [hl]
	and a
	jr z, .jmp_283
	dec [hl]
	jr .jmp_293
.jmp_283
	ldh a, [hGameState]	; 0 corresponds to normal gameplay...
	and a
	jr nz, .jmp_293
	ld a, 2
	ld [MBC1RomBank], a
	ldh [$FF00+$FD], a
	ld a, $0E
	ldh [hGameState], a
.jmp_293
	call .jmp_2A3		; This will the return address for the imminent rst $28
.jmp_296
	halt
	ldh a, [$FF00+$85]
	and a
	jr z, .jmp_296
	xor a
	ldh [$FF00+$85], a
	jr .jmp_226
.jmp_2A1
	jr .jmp_2A1 ; Infinite loop??
.jmp_2A3
	ldh a, [hGameState]
	rst $28		; Jump Table
	; 2A6
dw $0627 ; 0x00 Normal gameplay
dw $06BC ; 0x01 Dead?
dw $06DC ; 0x02 Reset to checkpoint
dw $0B8D ; 0x03 Pre dying
dw $0BD6 ; 0x04 Dying animation
dw $0C73 ; 0x05 Explosion/Score counting down
dw $0CCB ; 0x06 End of level
dw $0C40 ; 0x07 End of level gate, music
dw $0D49 ; 0x08
dw $161B ; 0x09 Going down a pipe
dw $162F ; 0x0A Warping to underground?
dw $166C ; 0x0B Going right in a pipe
dw $16DA ; 0x0C Going up out of a pipe
dw $2376 ; 0x0D Auto scrolling level
dw $0322 ; 0x0E Init menu
dw $04C3 ; 0x0F Start menu
dw $05CE ; 0x10
dw $0576 ; 0x11 Continue?
dw $3D97 ; 0x12 Go to Bonus game
dw $3DD7 ; 0x13 Entering Bonus game
dw $5832 ; 0x14
dw $5835 ; 0x15 Bonus game
dw $3EA7 ; 0x16
dw $5838 ; 0x17 Bonus game walking
dw $583B ; 0x18 Bonus game descending ladder
dw $583E ; 0x19 Bonus game ascending ladder
dw $5841 ; 0x1A Getting price
dw $0DF9 ; 0x1B Leaving Bonus game
dw $0E15 ; 0x1C Smth with the gate after a boss
dw $0E31 ; 0x1D
dw $0E5D ; 0x1E Gate opening
dw $0E96 ; 0x1F Gate open
dw $0EA9 ; 0x20 Walk off button
dw $0ECD ; 0x21 Mario offscreen
dw $0F12 ; 0x22 Scroll to fake Daisy
dw $0F33 ; 0x23 Walk to fake Daisy
dw $0F6A ; 0x24 Fake Daisy speak
dw $0FFD ; 0x25 Fake Daisy morphing
dw $1055 ; 0x26 Fake Daisy monster jumping away
dw $1099 ; 0x27	Tatanga dying
dw $0EA9 ; 0x28 Tatanga dead, plane moves forward
dw $1116 ; 0x29
dw $1165 ; 0x2A Daisy speaking
dw $1194 ; 0x2B Daisy moving
dw $11D0 ; 0x2C Daisy kissing
dw $121B ; 0x2D Daisy quest over
dw $1254 ; 0x2E Mario credits running
dw $12A1 ; 0x2F Entering airplane
dw $12C2 ; 0x30 Airplane taking off
dw $12F1 ; 0x31 Airplane moving forward
dw $138E ; 0x32 Airplane leaving hanger?
dw $13F0 ; 0x33 In between two credits?
dw $1441 ; 0x34 Credits coming up
dw $145A ; 0x35 Credits stand still
dw $1466 ; 0x36 Credits leave
dw $1488 ; 0x37 Airplane leaving
dw $14DC ; 0x38 THE END letters flying
dw $1C7C ; 0x39 Pre game over?
dw $1CE8 ; 0x3A Game over
dw $1CF0 ; 0x3B Pre time up
dw $1D1D ; 0x3C Time up
dw $06BB ; 0x3D

;322
	xor a
	ldh [rLCDC], a	; Turn off LCD
	di
	ldh [$FF00+$A4], a	; smth to do with the map scrolling
	ld hl, wOAMBuffer
	ld b, $9F
.clearOAMBufferLoop
	ldi [hl], a
	dec b
	jr nz, .clearOAMBufferLoop
	ldh [$FF99], a
	ld [$C0A5], a	; these are in the hblank routine as well
	ld [$C0AD], a
	ld hl, $C0D8
	ldi [hl], a
	ldi [hl], a
	ldi [hl], a
	ld a, [$C0E1]
	ldh [hWinCount], a
	ld hl, $791A	; TODO give name
	ld de, $9300
	ld bc, $0500
	call CopyData	; loads tiles for the menu
	ld hl, $7E1A
	ld de, $8800
	ld bc, $0170
	call CopyData	; and more tiles
	ld hl, $4862
	ldh a, [hWinCount]
	cp a, 1
	jr c, .noWins	; no win yet
	ld hl, $4E72
.noWins
	ld de, $8AC0
	ld bc, $0010
	call CopyData	; mushroom sprite (or mario head)
	ld hl, $5032
	ld de, $9000
	ld bc, $02C0
	call CopyData	; font, coins
	ld hl, $5032
	ld de, $8000
	ld bc, $02A0
	call CopyData	; same, but to the other tile data bank
	call FillVRAMWithEmptyTile
	xor a
	ldh [$FF00+$E5], a	; Level block TODO
	ldh a, [$FF00+$E4]
	push af
	ld a, $0C
	ldh [$FF00+$E4], a
	call $0807			; Draw level into tile map TODO based on FFE4?
	pop af
	ldh [$FF00+$E4], a
	ld a, $3C
	ld hl, $9800		; tile map
	call $056F			; smth with where the HUD goes
	ld hl, $9804
	ld [hl], $94
	ld hl, $9822
	ld [hl], $95
	inc l
	ld [hl], $96		; Mario's head
	inc l
	ld [hl], $8C
	ld hl, $982F		; Clouds in top right
	ld [hl], $3F
	inc l
	ld [hl], $4C
	inc l
	ld [hl], $4D
	ld hl, wScore + 2
	ld de, wTopScore + 2
	ld b, 3
.compareScores			; Compare the last score to the top score
	ld a, [de]
	sub [hl]
	jr c, .newTopScore
	jr nz, .printTopScore
	dec e
	dec l
	dec b
	jr nz, .compareScores
	jr .printTopScore
.newTopScore
	ld hl, wScore + 2
	ld de, wTopScore + 2
	ld b, 3
.replaceTopScore
	ldd a, [hl]
	ld [de], a
	dec e
	dec b
	jr nz, .replaceTopScore
.printTopScore
	ld de, wTopScore + 2
	ld hl, $9969
	call PrintScore	; tiens
	ld hl, wOAMBuffer + 4
	ld [hl], $78	; Y
	ld a, [wNumContinues]
	and a
	jr z, .noContinues
	ldh a, [hWinCount]
	cp a, 2					; after two wins, you don't need 100k points,
	jr c, .printContinues	; you can just always level select
	jr .noContinues
.printContinues
	ld hl, $0446	; "CONTINUE *"
	ld de, $99C6
	ld b, $0A
.loop
	ldi a, [hl]
	ld [de], a
	inc e
	dec b
	jr nz, .loop
	ld hl, wOAMBuffer
	ld [hl], $80	; Y
	inc l
	ld [hl], $88	; X
	inc l
	ld a, [wNumContinues]
	ld [hl], a
	inc l
	ld [hl], 0		; no sprite attributes
	inc l
	ld [hl], $80	; Y
.noContinues
	inc l
	ld [hl], $28	; X
	inc l
	ld [hl], $AC	; mushroom/mario head
	xor a
	ldh [rIF], a	; Clear all interrupts
	ld a, $C3
	ldh [rLCDC], a	; Turn on LCD, BG, sprites, and change WIN tile map
	ei
	ld a, $0F		; TODO
	ldh [hGameState], a
	xor a
	ldh [$FF00+$F9], a
	ld a, $28
	ld [$C0D7], a
	ldh [$FF00+$9F], a
	ld hl, $C0DC
	inc [hl]
	ld a, [hl]
	cp a, 3
	ret nz
	ld [hl], 0
	ret

; 446 TODO give a name
db "continue *"
INCBIN "baserom.gb", $450, $05CF - $450

FillVRAMWithEmptyTile:: ; 05CF  What a waste
	ld hl, $9BFF	; TODO... name
	ld bc, $0400
.loop
	ld a, " "
	ldd [hl], a
	dec bc
	ld a, b
	or c
	jr nz, .loop
	ret

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
	ldh a, [$FF00+$9F]	; Demo mode?
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
	ldh [$FF00+$D3], a
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
	ld a, $39			; TODO Game over :'(
	ldh [hGameState], a
	ld [$C0A4], a
	jr .out
.loseLife
	and a
	jr z, .gameOver		; No lives anymore
	sub a, 1			; Subtract one life
	jr .displayLives

INCBIN "baserom.gb", $1C7C, $3D1A - $1C7C


; 3D1A
	ld hl, $C030	; TODO ? wOAMBuffer + $30 ? used for "dynamic" sprites?
	ld b, $20
	xor a
.jmp_3D20
	ldi [hl], a
	dec b
	jr nz, .jmp_3D20
	ld hl, $DA00
	ld a, $28		; 40 frames per time unit
	ldi [hl], a		; DA00 - Time hundredths	
	xor a
	ldi [hl], a		; DA01 - Time ones and tens
	ld a, $04
	ldi [hl], a		; DA02 - Time hundreds
	call DisplayTimer.printTimer	; TODO
	ld a, $20		; Some sort of timers? For "dynamic" sprites?
	ldi [hl], a		; DA03
	ldi [hl], a		; DA04
	ldi [hl], a		; DA05
	ldi [hl], a		; DA06
	ld a, $F6		; One for each "timer"?
	ldi [hl], a		; DA07
	ldi [hl], a		; DA08
	ldi [hl], a		; DA09
	ldi [hl], a		; DA0A
	ld a, $30		; Cycles between the three "timers"
	ldi [hl], a		; DA0B
	xor a
	ld b, $09
.loop
	ldi [hl], a		; DA0C - DA14
	dec b
	jr nz, .loop
	ld a, 2
	ldi [hl], a		; DA15 - Lives
	dec a
	ldi [hl], a		; DA16 - TODO
	xor a
	ldi [hl], a		; DA17 - Bonus game from here...
	ldi [hl], a		; DA18
	ldi [hl], a		; DA19
	ldi [hl], a		; DA1A
	ld a, $40
	ldi [hl], a		; DA1B
	xor a
	ldi [hl], a		; DA1C
	ldi [hl], a		; DA1D
	ldi [hl], a		; DA1E
	ld a, $40
	ldi [hl], a		; DA1F
	xor a
	ld b, $08
.loop2
	ldi [hl], a		; DA20 - DA27 - ... to here
	dec b
	jr nz, .loop2
	ld a, $04
	ldi [hl], a		; DA28
	ld a, $11
	ld [hl], a		; DA29 - Changes during the bonus game..
	ret

DisplayTimer:: ; 3D6A ; TODO better name?
	ld a, [$C0A4]		; stores game over?
	and a
	ret nz
	ldh a, [hGameState]
	cp a, $12			; game states > $12 don't make the timer count TODO
	ret nc
	ld a, [$DA00]		; Timer subdivision
	cp a, $28			; 40 frames per time unit (why not 60?)
	ret nz
	call .printTimer	; well, that's silly, could've just fallen through. Bug?
	ret
.printTimer ; 3D7E
	ld de, $9833		; TODO VRAM
	ld a, [$DA01]		; Ones and Tens
	ld b, a
	and a, $0F
	ld [de], a
	dec e
	ld a, b
	and a, $F0
	swap a
	ld [de], a
	dec e
	ld a, [$DA02]		; Hundreds
	and a, $0F
	ld [de], a
	ret

INCBIN "baserom.gb", $3D97, $3F39 - $3D97

DisplayScore:: ; 3F39
; Display the score at wScore to the top right corner
	ldh a, [$FF00+$B1]	; Some check to see if the score needs to be  
	and a				; updated?
	ret z
	ld a, [$C0E2]
	and a
	ret nz
	ldh a, [$FF00+$EA]
	cp a, 02
	ret z
	ld de, wScore + 2	; Start with the ten and hundred thousands
	ld hl, $9820		; TODO VRAM layout
PrintScore::
; Displays BCD encoded score at DE, DE-1 and DE-2 to the VRAM at HL
; Print spaces instead of leading zeroes TODO Reuses FFB1?
	xor a
	ldh [$FF00+$B1], a	; Start by printing spaces instead of leading zeroes
	ld c, $03			; Maximum 3 digit pairs
.printDigitPair
	ld a, [de]
	ld b, a
	swap a				; Start with the more significant digit
	and a, $0F
	jr nz, .startNumber1
	ldh a, [$FF00+$B1]	; If it's zero, check if the number has already started
	and a
	ld a, "0"
	jr nz, .printFirstDigit
	ld a, " "			; If not, start with spaces, not leading zeroes
.printFirstDigit
	ldi [hl], a			; Place the digit or space in VRAM
	ld a, b				; Now the lesser significant digit
	and a, $0F
	jr nz, .startNumber2; If non-zero, number has started (or already is)
	ldh a, [$FF00+$B1]
	and a				; If zero, check if already started
	ld a, "0"
	jr nz, .printSecondDigit
	ld a, 1				; If the number still hasn't started at the ones,
	cp c				; score is 0. Print just one 0
	ld a, "0"
	jr z, .printSecondDigit
	ld a, " "			; Otherwise, print another space
.printSecondDigit
	ldi [hl], a			; Put the second digit in VRAM
	dec e				; Go to the next pair of digits in memory
	dec c				; Which is less significant
	jr nz, .printDigitPair
	xor a
	ldh [$FF00+$B1], a
	ret
.startNumber1
	push af
	ld a, 1
	ldh [$FF00+$B1], a	; Number has start, print "0" instead of " "
	pop af
	jr .printFirstDigit
.startNumber2
	push af
	ld a, 1
	ldh [$FF00+$B1], a	; Number has start, print "0" instead of " "
	pop af
	jr .printSecondDigit

DMARoutine::
	ld a, HIGH(wOAMBuffer)
	ldh [rDMA], a
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

