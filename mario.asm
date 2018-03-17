INCLUDE "charmap.asm"
INCLUDE "gbhw.asm"
INCLUDE "wram.asm"
INCLUDE "hram.asm"
INCLUDE "macros.asm"

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
	ldh a, [hActiveRomBank]
	ld [MBC1RomBank], a
	pop af
	reti

VBlank:: ; $0060
; Coincides with the joypad interrupt, which is unused afaict
	push af
	push bc
	push de
	push hl
	call DrawColumn		; Drawing new areas of the map
	call Call_1B86		; Collision with coins, coin blocks, etc...?
	call UpdateLives
	call hDMARoutine
	call DisplayScore
	call DisplayTimer
	call AnimateBackground
	ld hl, hFrameCounter
	inc [hl]
	ldh a, [hGameState]
	cp a, $3A			; Game over? TODO
	jr nz, .gameNotOver
	ld hl, rLCDC
	set 5, [hl]			; Turn on window
.gameNotOver
	xor a
	ldh [rSCX], a
	ldh [rSCY], a
	inc a
	ldh [hVBlankOccurred], a
	pop hl
	pop de
	pop bc
	pop af
	reti

; Update scroll registers. Don't understand the logic yet
LCDStatus::
	push af
	push hl
	WAIT_FOR_HBLANK
	ld a, [$C0A5]
	and a
	jr nz, .jmp_CF
	ldh a, [hScrollX]
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
	ldh a, [$FFFB]
	and a
	jr z, .jmp_EA
	dec a
	ldh [$FFFB], a
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
Mystery_153::
	call Call_3EE6
	WAIT_FOR_HBLANK
	ld b, [hl]
	WAIT_FOR_HBLANK
	ld a, [hl]
	and b
	ret

; Add BCD encoded DE to the score. Signal that the displayed version
; needs to be updated
AddScore:: ; 0166
	ldh a, [$FF9F]	; Demo mode?
	and a
	ret nz
	ld a, e
	ld hl, wScore
	add [hl]			; Add E to the ones and tens
	daa
	ldi [hl], a
	ld a, d				; Add D to the hundreds and thousands
	adc [hl]			; with carry from the lower digits
	daa
	ldi [hl], a
	ld a, 0				; No score above 9999 is ever awarded, so just add
	adc [hl]			; 0 to propagate carry
	daa
	ld [hl], a
	ld a, 1
	ldh [$FFB1], a		; TODO We've seen this address before
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
	ld b, $80		; Size of High RAM, off by one, bug?
.clearHRAMloop
	ldd [hl], a
	dec b
	jr nz, .clearHRAMloop

	ld c, LOW(hDMARoutine)
	ld b, DMARoutineEnd - DMARoutine + 2 ; TODO Bug?
	ld hl, DMARoutine
.copyDMAroutine		; No memory can be accessed during DMA other than HRAM,
	ldi a, [hl]		; so the routine is copied and executed there
	ld [$FF00+c], a ; together with two bytes I don't know the function of TODO
	inc c
	dec b
	jr nz, .copyDMAroutine

	xor a
	ldh [hLevelIndex], a
	ld a, $11
	ldh [hWorldAndLevel], a
	ld [wContinueWorldAndLevel], a
	ld a, 2
	ld [$C0DC], a
	ld a, $0E
	ldh [hGameState], a	; TODO
	ld a, 3
	ld [MBC1RomBank], a
	ld [$C0A4], a
	ld a, 0
	ld [wWinCount], a
	ldh [hWinCount], a
	call $7FF3			; This seems to set up sound
	ld a, 2
	ld [MBC1RomBank], a
	ldh [hActiveRomBank], a

.jmp_226				; MAIN LOOP (well, i think)
	ld a, [wGameTimerExpiringFlag]		;  0 in normal play, 1 if time < 100
	cp a, 3				; 2 if time < 50, 3 if time = 0, FF if time up
	jr nz, .timeNotUp
	ld a, $FF
	ld [wGameTimerExpiringFlag], a
	call KillMario
	call Call_1736
.timeNotUp
	SAVE_AND_SWITCH_ROM_BANK 3
	call $47F2			; Determines pressed buttons (FF80) and new buttons (FF81)
	RESTORE_ROM_BANK
	ldh a, [$FF9F]	; Demo mode?
	and a
	jr nz, .jmp_25A
	call pauseOrReset
	ldh a, [hGamePaused]
	and a
	jr nz, .halt
.jmp_25A
	ld hl, hTimer
	ld b, 2
.nextTimer
	ld a, [hl]
	and a
	jr z, .skip			; don't decrement below 0
	dec [hl]			; FFA{6,7} are generic frame based timers
.skip
	inc l
	dec b
	jr nz, .nextTimer
	ldh a, [$FF9F]		; Equal to 28 in menu and during demo
	and a
	jr z, .jmp_293
	ldh a, [hJoyHeld]
	bit 3, a			; test for Start
	jr nz, .jmp_283
	ldh a, [hFrameCounter] ; todo
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
	jr nz, .jmp_293		; start the game?
	ld a, 2
	ld [MBC1RomBank], a
	ldh [hActiveRomBank], a
	ld a, $0E
	ldh [hGameState], a	; go back from demo to menu
.jmp_293
	call .jmp_2A3		; This will the return address for the imminent rst $28
.halt
	halt				; Halt the CPU until an interrupt is fired
	ldh a, [hVBlankOccurred]
	and a
	jr z, .halt
	xor a
	ldh [hVBlankOccurred], a
	jr .jmp_226

.jmp_2A1
	jr .jmp_2A1 ; Infinite loop??

.jmp_2A3
	ldh a, [hGameState]
	rst $28		; Jump Table
	; 2A6
dw $0627 ; 0x00   Normal gameplay
dw $06BC ; 0x01 ✓ Dead?
dw $06DC ; 0x02 ✓ Reset to checkpoint
dw $0B8D ; 0x03 ✓ Pre dying
dw $0BD6 ; 0x04 ✓ Dying animation
dw $0C73 ; 0x05 ✓ Explosion/Score counting down
dw $0CCB ; 0x06 ✓ End of level
dw $0C40 ; 0x07 ✓ End of level gate, music
dw $0D49 ; 0x08 ✓ Increment Level, load tiles
dw $161B ; 0x09 ✓ Going down a pipe
dw $162F ; 0x0A ✓ Warping to underground?
dw $166C ; 0x0B ✓ Going right in a pipe
dw $16DA ; 0x0C ✓ Going up out of a pipe
dw $2376 ; 0x0D   Auto scrolling level
dw $0322 ; 0x0E ✓ Init menu
dw $04C3 ; 0x0F ✓ Start menu
dw $05CE ; 0x10 ✓ Unused? todo
dw $0576 ; 0x11 ✓ Level start
dw $3D97 ; 0x12 ✓ Go to Bonus game
dw $3DD7 ; 0x13 ✓ Entering Bonus game
dw $5832 ; 0x14  
dw $5835 ; 0x15   Bonus game
dw $3EA7 ; 0x16 ✓ Move the ladder
dw $5838 ; 0x17   Bonus game walking
dw $583B ; 0x18   Bonus game descending ladder
dw $583E ; 0x19   Bonus game ascending ladder
dw $5841 ; 0x1A   Getting price
dw $0DF9 ; 0x1B ✓ Leaving Bonus game
dw $0E15 ; 0x1C ✓ Smth with the gate after a boss
dw $0E31 ; 0x1D ✓
dw $0E5D ; 0x1E ✓ Gate opening
dw $0E96 ; 0x1F ✓ Gate open
dw $0EA9 ; 0x20 ✓ Walk off button
dw $0ECD ; 0x21 ✓ Mario offscreen
dw $0F12 ; 0x22 ✓ Scroll to fake Daisy
dw $0F33 ; 0x23 ✓ Walk to fake Daisy
dw $0F6A ; 0x24 ✓ Fake Daisy speak
dw $0FFD ; 0x25 ✓ Fake Daisy morphing
dw $1055 ; 0x26 ✓ Fake Daisy monster jumping away
dw $1099 ; 0x27 ✓ Tatanga dying
dw $0EA9 ; 0x28 ✓ Tatanga dead, plane moves forward
dw $1116 ; 0x29 ✓ 
dw $1165 ; 0x2A ✓ Daisy speaking
dw $1194 ; 0x2B ✓ Daisy moving
dw $11D0 ; 0x2C ✓ Daisy kissing
dw $121B ; 0x2D ✓ Daisy quest over
dw $1254 ; 0x2E ✓ Mario credits running
dw $12A1 ; 0x2F ✓ Entering airplane
dw $12C2 ; 0x30 ✓ Airplane taking off
dw $12F1 ; 0x31 ✓ Airplane moving forward
dw $138E ; 0x32 ✓ Airplane leaving hanger?
dw $13F0 ; 0x33 ✓ In between two credits?
dw $1441 ; 0x34 ✓ Credits coming up
dw $145A ; 0x35 ✓ Credits stand still
dw $1466 ; 0x36 ✓ Credits leave
dw $1488 ; 0x37 ✓ Airplane leaving
dw $14DC ; 0x38 ✓ THE END letters flying
dw $1C7C ; 0x39 ✓ Pre game over?
dw $1CE8 ; 0x3A ✓ Game over
dw $1CF0 ; 0x3B ✓ Pre time up
dw $1D1D ; 0x3C ✓ Time up
dw $06BB ; 0x3D  

;322
GameState_0E::
	xor a
	ldh [rLCDC], a	; Turn off LCD
	di
	ldh [hScrollX], a
	ld hl, wOAMBuffer
	ld b, $9F
.clearOAMBufferLoop
	ldi [hl], a
	dec b
	jr nz, .clearOAMBufferLoop
	ldh [hSuperStatus], a
	ld [$C0A5], a	; these are in the hblank routine as well
	ld [$C0AD], a
	ld hl, $C0D8
	ldi [hl], a
	ldi [hl], a
	ldi [hl], a
	ld a, [wWinCount]	; restore from Work RAM, possibly overwritten for demo
	ldh [hWinCount], a	; Expert Mode activated when non zero
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
	call Call_5CF
	xor a
	ldh [hLevelBlock], a
	ldh a, [hLevelIndex]
	push af
	ld a, $0C
	ldh [hLevelIndex], a
	call Call_807			; Draw level into tile map TODO based on FFE4?
	pop af
	ldh [hLevelIndex], a
	ld a, $3C
	ld hl, $9800		; tile map
	call FillStartMenuTopRow	; usually hidden by the HUD
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
.newTopScore			; This is so not the place to do this...
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
	call PrintScore
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
	ldh [$FFF9], a
	ld a, $28
	ld [$C0D7], a
	ldh [$FF9F], a
	ld hl, $C0DC
	inc [hl]
	ld a, [hl]
	cp a, 3
	ret nz
	ld [hl], 0
	ret

; 446 TODO give a name
db "continue *"

; 450
GameState_0F::
.startPressed
	ld a, [wOAMBuffer + 4]
	cp a, $78	; usual start Y position
	jr z, .dontContinue
	ld a, [wNumContinues]	; if not, use up a continue
	dec a
	ld [wNumContinues], a
	ld a, [wContinueWorldAndLevel]
	ldh [hWorldAndLevel], a
	ld e, 0
	cp a, $11				; Convert BCD level to index
	jr z, .startLevelInE
	inc e
	cp a, $12
	jr z, .startLevelInE
	inc e
	cp a, $13
	jr z, .startLevelInE
	inc e
	cp a, $21
	jr z, .startLevelInE
	inc e
	cp a, $22
	jr z, .startLevelInE
	inc e
	cp a, $23
	jr z, .startLevelInE
	inc e
	cp a, $31
	jr z, .startLevelInE
	inc e
	cp a, $32
	jr z, .startLevelInE
	inc e
	cp a, $33
	jr z, .startLevelInE
	inc e
	cp a, $41
	jr z, .startLevelInE
	inc e
	cp a, $42
	jr z, .startLevelInE
	inc e
.startLevelInE
	ld a, e
.storeAndStartLevel
	ldh [hLevelIndex], a
	jp .jmp_53D
.dontContinue
	xor a
	ld [wNumContinues], a	; harsh
	ldh a, [hWinCount]
	cp a, 2
	jp nc, .jmp_53D
	ld a, $11
	ldh [hWorldAndLevel], a
	xor a
	jr .storeAndStartLevel
.selectPressed
	ld a, [wNumContinues]
	and a
	jr z, .checkLevelSelect	; if we have no continues, pretend like nothing happened
	ld hl, $C004
	ld a, [hl]
	xor a, $F8
	ld [hl], a
	jr .checkLevelSelect
.entryPoint::
	ldh a, [hJoyPressed]
	ld b, a
	bit 3, b		; START button
	jr nz, .startPressed
	bit 2, b		; SELECT button
	jr nz, .selectPressed
.checkLevelSelect
	ldh a, [hWinCount]
	cp a, 2
	jr c, .checkDemoTimer
	bit 0, b		; A button
	jr z, .drawLevelSelect
	ldh a, [hWorldAndLevel]	; increment the level select
	inc a			; Level
	ld b, a
	and a, $0F
	cp a, $04		; 3 levels per world
	ld a, b
	jr nz, .skip
	add a, $10 - 3	; to increment the upper nibble, the world
.skip
	ldh [hWorldAndLevel], a
	ldh a, [hLevelIndex]
	inc a
	cp a, $0C		; 12 levels in total
	jr nz, .drawNewLevelSelect
	ld a, $11		; go back to 1-1
	ldh [hWorldAndLevel], a
	xor a
.drawNewLevelSelect
	ldh [hLevelIndex], a
.drawLevelSelect	; with sprites
	ld hl, $C008
	ldh a, [hWorldAndLevel]	; nibble encoded
	ld b, $78		; Y coordinate
	ld c, a
	and a, $F0		; world
	swap a
	ld [hl], b		; Y
	inc l
	ld [hl], $78	; X for world
	inc l
	ldi [hl], a		; world sprite index
	inc l
	ld a, c
	and a, $0F
	ld [hl], b		; Y
	inc l
	ld [hl], $88	; X for level
	inc l
	ldi [hl], a		; level sprite index
	inc l
	ld [hl], b		; Y
	inc l
	ld [hl], $80	; X for -
	inc l
	ld [hl], "-"
.checkDemoTimer
	ld a, [$C0D7]	; Demo timer
	and a
	ret nz
	ld a, [$C0DC]	; Demo select
	sla a
	ld e, a
	ld d, 0
	ld hl, .data_569	; Demo levels
	add hl, de
	ldi a, [hl]
	ldh [hWorldAndLevel], a	; pseudo BCD encoded level
	ld a, [hl]
	ldh [hLevelIndex], a	; level index and encoding
	ld a, $50
	ld [$C0D7], a	; timer
	ld a, $11		; TODO
	ldh [hGameState], a
	xor a
	ldh [hWinCount], a ; to avoid expert mode in demos. Mirrored at C0E1
	ret
.jmp_53D
	ld a, $11
	ldh [hGameState], a
	xor a
	ldh [rIF], a
	ldh [$FF9F], a
	ld [$C0A4], a
	dec a
	ld [$DFE8], a
	ld a, 3
	ld [MBC1RomBank], a
	call $7FF3			; setup sound effects
	ldh a, [hActiveRomBank]
	ld [MBC1RomBank], a
	xor a
	ld [$DFE0], a
	ld [$DFF0], a
	ld [$DFF8], a
	ld a, $7			; enable timer interrupt TODO
	ld [rIE], a
	ret

; TODO more random data... Demo levels: 1-1, 1-2, 3-3
.data_569:: ; 569
db $11, $00, $12, $01, $33, $08

; What kind of garbage is this?
FillStartMenuTopRow:
	ld b, $14
.loop
	ldi [hl], a
	dec b
	jr nz, .loop
	ret

GameState_11::	; 576
; start level
.entryPoint::
	xor a
	ldh [rLCDC], a	; turn off LCD
	di
	ldh a, [$FF9F]	; seems to be only non zero in the menu
	and a
	jr nz, .jmp_58B
	xor a
	ld [wScore], a			; ones and tens
	ld [wScore+1], a		; hundreds and thousands
	ld [wScore+2], a		; ten and hundred thousands
	ldh [hCoins], a
.jmp_58B
	call Call_5E7	; todo
	call Call_5CF
	ld hl, $9C00
	ld b, $5F
	ld a, " "
.loop
	ldi [hl], a
	dec b
	jr nz, .loop
	call PrepareHUD
	ld a, $0F
	ldh [rLYC], a	; height of the hud?
	ld a, (1 << rTAC_ON) | rTAC_16384_HZ
	ldh [rTAC], a
	ld hl, rWY
	ld [hl], $85
	inc l			; rWX
	ld [hl], $60	; bottom right corner
	xor a
	ldh [rTMA], a
	ldh [rIF], a
	dec a
	ldh [$FFA7], a
	ldh [$FFB1], a
	ld a, $5B
	ldh [$FFE9], a
	call Call_2442		; superfluous? happens in GameState_08.loadWorldTiles?
	call Call_3D1A		; todo
	call DisplayCoins
	call UpdateLives.displayLives
	ldh a, [hWorldAndLevel]
	call GameState_08.loadWorldTiles
GameState_10:: ; 5CE Huh? Unused?
	ret

Call_5CF:: ; 05CF  What a waste
	ld hl, $9BFF	; TODO... name
	ld bc, $0400
EraseTileMap:: ; 5D5
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

; 5E7
; prepare tiles
Call_5E7::	; the three upper banks have tiles at the same location?
	ld hl, $5032
	ld de, $9000
	ld bc, $0800
	call CopyData
	ld hl, $4032
	ld de, $8000
	ld bc, $1000
	call CopyData
	ld hl, $5603
	ld de, $C600	; copy of the animated background tile...
	ld b, $08
.loop
	ldi a, [hl]
	ld [de], a
	inc hl
	inc de
	dec b
	jr nz, .loop
	ret

PrepareHUD::
	ld hl, DMARoutineEnd	; TODO HUD
	ld de, $9800
	ld b, $02
.loop
	ldi a, [hl]
	ld [de], a
	inc e
	ld a, e
	and a, $1F
	cp a, $14
	jr nz, .loop
	ld e, $20
	dec b
	jr nz, .loop
	ret

; Normal gameplay. Tons of function calls, let's do this later...
GameState_00::	; 627
INCBIN "baserom.gb", $0627, $06BC - $0627

; 06BC
GameState_01::
	ld hl, hTimer
	ld a, [hl]
	and a
	ret nz
	ld hl, $D100	; enemies
	ld de, $0010
	ld b, $0A
.loop
	ld [hl], $FF
	add hl, de
	dec b
	jr nz, .loop
	xor a
	ldh [hSuperStatus], a
	dec a
	ld [wLivesEarnedLost], a	; FF = -1
	ld a, 2
	ldh [hGameState], a
	ret

GameState_02::
	di
	ld a, 0
	ldh [rLCDC], a
	call Call_1ED4		; clears sprites
	call Call_165E		; clears "overlay"
	ld hl, hLevelBlock
	ld a, [$FFF9]		; nonzero if underground
	and a
	jr z, .overworld
	xor a
	ldh [$FFF9], a		; not underground anymore
	ldh a, [$FFF5]		; block in which we'd've exited out of pipe
	inc a				; to be decremented immediately after
	jr .jmp_6F8

.overworld
	ld a, [hl]
.jmp_6F8
	cp a, $03
	jr z, .findCheckpoint
	dec a
.findCheckpoint
	ld bc, $030C
	cp a, $07
	jr c, .gotoCheckpoint
	ld bc, $0734
	cp a, $0B
	jr c, .gotoCheckpoint
	ld bc, $0B5C
	cp a, $0F
	jr c, .gotoCheckpoint
	ld bc, $0F84
	cp a, $13
	jr c, .gotoCheckpoint
	ld bc, $13AC
	cp a, $17
	jr c, .gotoCheckpoint
	ld bc, $17D4
.gotoCheckpoint
	ld [hl], b
	inc l
	ld [hl], 0
	ld a, c
	ld [$C0AB], a		; "progress" in level, used to spawn enemies?
	call Call_807		; draw first block of the level
	ld hl, $982B		; right next to the coins
	ld [hl], " "
	inc l
	ldh a, [hWorldAndLevel]
	ld b, a
	and a, $F0
	swap a
	ldi [hl], a
	ld a, b
	and a, $0F
	inc l
	ld [hl], a
	ld hl, $9C00
	ld de, .text_79A
	ld b, $09
.loop
	ld a, [de]
	ldi [hl], a
	inc de
	dec b
	jr nz, .loop
	xor a
	ldh [hGameState], a
	ld [wInvincibilityTimer], a
	ld a, $C3
	ldh [rLCDC], a
	call StartLevelMusic
	xor a
	ldh [rIF], a
	ldh [hScrollX], a
	ld [$C0D2], a			; starts incrementing at end of level
	ldh [$FFEE], a			; source of collision?
	ld [wGameTimerExpiringFlag], a
	ldh [rTMA], a
	ld hl, wGameTimer + 1	; ones and tens
	ldi [hl], a				; hundreds
	ld [hl], $04
	ld a, $28
	ld [wGameTimer], a
	ld a, $5B
	ldh [$FFE9], a			; some sort of index in the level
	ldh a, [hLevelIndex]
	ld c, $0A				; submarine
	cp a, $05
	jr z, .autoscroll
	ld c, $0C				; airplane
	cp a, $0B
	jr nz, .out
.autoscroll
	ld a, $0D
	ldh [hGameState], a		; autoscroll
	ld a, [$C203]			; animation index
	and a, $F0
	or c
	ld [$C203], a
.out
	call Call_245C
	ei
	ret

.text_79A
	db " ♥pause♥ "

StartLevelMusic::
	ld a, [wInvincibilityTimer]
	and a
	ret nz
	ld a, 3
	ld [MBC1RomBank], a	; no need to save rom bank, interrupts are disabled
	call $7FF3
	ldh a, [hActiveRomBank]
	ld [MBC1RomBank], a
	ldh a, [$FFF4]		; underground?
	and a
	jr nz, .underground
	ldh a, [hLevelIndex]
	ld hl, .musicByLevel
	ld e, a
	ld d, $00
	add hl, de
	ld a, [hl]
	ld [$DFE8], a
	ret

.underground
	ld a, 4				; underground music
	ld [$DFE8], a
	ret

.musicByLevel
	db 7, 7, 3
	db 8, 8, 5
	db 7, 3, 3
	db 6, 6 ,5

pauseOrReset:: ; 7DA
	ldh a, [hJoyHeld]
	and a, $0F
	cp a, $0F			; TODO constants
	jr nz, .noReset
	jp Init				; if at any point A+B+Start+Select are pressed, reset
.noReset
	ldh a, [hJoyPressed]
	bit 3, a			; todo start button bit. (Un)Pause the game!
	ret z
	ldh a, [hGameState]
	cp a, $0E
	ret nc				; <= gamestates mostly relating to normal gameplay
	ld hl, rLCDC
	ldh a, [hGamePaused]
	xor a, 1			; (un)pause game
	ldh [hGamePaused], a
	jr z, .unpaused
	set 5, [hl]			; Display window with pause
	ld a, 1				; Pause music
.pauseMusic
	ldh [hPauseMusic], a
	ret
.unpaused
	res 5, [hl]
	ld a, 2				; Unpause music
	jr .pauseMusic

; this draw the first screen of the level. The rest is dynamically loaded
Call_807::
	ld hl, Data_211D
	ld de, $C200
	ld b, $51			; Bug? One byte too much
.copyLoop				; some sort of initialisation
	ldi a, [hl]
	ld [de], a
	inc de
	dec b				; What's the point of a CopyData routine,
	jr nz, .copyLoop	; if you're not going to fucking use it
	ldh a, [hSuperStatus]
	and a
	jr z, .drawLevel	; jump if small mario
	ld a, $10
	ld [$C203], a		; animation index. upper nibble is 1 of large mario
.drawLevel::			; does weird things in autoscroll
	ld hl, hColumnIndex
	xor a
	ld b, 6
.clearLoop
	ldi [hl], a
	dec b
	jr nz, .clearLoop	; clears FFE6-FFEB
	ldh [$FFA3], a		; switches between 0 and 8, depending on scroll coord
	ld [$C0AA], a		; and yet another scrolling thing
	ld a, $40
	ldh [$FFE9], a		; level index of some sort
	ld b, $14			; an underground level is only 20 tiles wide, no scroll
	ldh a, [hGameState]
	cp a, $0A			; pipe going underground
	jr z, .drawLoop
	ldh a, [hLevelIndex]
	cp a, $0C			; start menu doesn't scroll
	jr z, .drawLoop
	ld b, $1B			; load 27 tiles (20 visible, 7 preloaded)
.drawLoop
	push bc
	call LoadNextColumn	; load a column of the level into C0B0
	call DrawColumn		; draw it onscreen
	pop bc
	dec b
	jr nz, .drawLoop
	ret

; used in gamestate 0D?
INCBIN "baserom.gb", $84E, $9E0 - $84E

InjureMario:: ; 9E0
	ld a, 3
	ldh [hSuperStatus], a
	xor a
	ldh [hSuperballMario], a
	ld a, $50
	ldh [hTimer], a
	ld a, $06
	ld [$DFE0], a			; injury music
	ret

KillMario:: ; 9F1
	ld a, [$D007]
	and a
	ret nz
	ld a, $03				; pre dying
	ldh [hGameState], a
	xor a
	ldh [hSuperballMario], a; superball capability
	ldh [rTMA], a
	ld a, $02
	ld [$DFE8], a			; sound effect
	ld a, $80
	ld [$C200], a
	ld a, [$C201]			; Mario Y pos
	ld [$C0DD], a			; death Y pos?
	ret

; called when a hit is detected on an enemy?
Call_A10::
	push hl
	push de
	ldh a, [$FF9B]			; enemy... health?
	and a, %11000000
	swap a
	srl a
	srl a				; put two upper bits in lowest position
	ld e, a
	ld d, $00
	ld hl, .data_A29
	add hl, de
	ld a, [hl]
	ldh [$FF9E], a
	pop de
	pop hl
	ret

.data_A29
; corresponding top nibbles
;      0-3  4-7  8-B  C-F
	db $01, $04, $08, $50

; called when Mario hits a bouncing block, to hit the enemy above it
Call_A2D:: ; A2D
	ldh a, [$FFEE]
	and a
	ret z
	cp a, $C0
	ret z				; return if no collision, and if not with a coin
	ld de, $0010
	ld b, $0A
	ld hl, $D100		; enemies. and hittable objects
.loop
	ld a, [hl]
	cp a, $FF			; ff means no object
	jr nz, .checkEnemyHit
.nextEnemy
	add hl, de
	dec b
	jr nz, .loop
	ret

.checkEnemyHit
	push bc
	push hl
	ld bc, $000A
	add hl, bc			; D1xA, lower 7 bits is width + height, 7th bit is ?
	bit 7, [hl]
	jr nz, .noHit		; bit 7 is immortality?
	ld c, [hl]
	inc l
	inc l				; D1xC, health?
	ld a, [hl]
	ldh [$FF9B], a		; used in Call_A10 at least
	pop hl
	push hl
	inc l
	inc l
	ld b, [hl]			; D1x2 Y pos
	ld a, [$C201]		; player Y pos
	sub b				; Y coordinates are inverted
	jr c, .noHit		; enemy needs to be above player
	ld b, a
	ld a, $14
	sub b
	jr c, .noHit		; but not too much above the player either
	cp a, $07			; A contains $14 - (playerY - enemyY) and has to be < 7
	jr nc, .noHit		; meaning playerY - enemyY has to be at least $D
	inc l
	ld a, c				; c contains the width + height
	and a, $70			; just width
	swap a
	ld c, a
	ld a, [hl]			; D1x3 X pos, points to left bound of leftmost tile
.loopR
	add a, $08			; one tile per width
	dec c
	jr nz, .loopR
	ld c, a				; C contains right bound of enemy
	ld b, [hl]			; B contains left bound of enemy
	ld a, [$C202]		; Mario X pos
	sub a, $06			; Mario is 12 pixels wide
	sub c
	jr nc, .noHit		; left bound has to be smaller than right bound of enemy
	ld a, [$C202]
	add a, $06
	sub b
	jr c, .noHit
	dec l
	dec l
	dec l				; D1x0
	push de
	call Call_A10
	Call $2A23			; prepares death animation
	pop de
	and a
	jr z, .noHit
	ld a, [$C202]		; X pos
	add a, $FC			; or -4
	ldh [$FFEB], a
	ld a, [$C201]		; Y pos
	sub a, $10
	ldh [$FFEC], a
	ldh a, [$FF9E]
	ldh [$FFED], a
.noHit
	pop hl
	pop bc
	jp .nextEnemy

; TODO clean up these comments
; collision detection between enemy and bounding box defined by
; T B L R FFA0 FFA1 FFA2 FF8F (-_-)
; HL contains D1x0 of enemy under consideration?
; C is some sort is width? XY in both nibbles?
Call_AAF:: ; AAF
	inc l
	inc l				; D1x2 Y pos
	ld a, [hl]
	add a, $08			; Y pos is top left of bottom left sprite tile
	ld b, a				; so add 8 to get coordinate of bottom of enemy
	ldh a, [$FFA0]		; top of bounding box?
	sub b				; top - bottom
	jr nc, .noCollision ; NC if bottom < top (don't forget Y coords grow downwards)
	ld a, c
	and a, $0F			; lower nibble, height in tiles?
	ld b, a
	ld a, [hl]			; still Y pos
.loopHeight
	dec b
	jr z, .checkBottomOfBB
	sub a, $08			; subtract (c & 0F) tiles
	jr .loopHeight

.checkBottomOfBB
	ld b, a				; B contains top of enemy
	ldh a, [$FFA1]		; bottom Y
	sub b
	jr c, .noCollision	; C if top > bottom (Y coords grow downwards)
; X detection
	inc l				; D1x3 X pos
	ldh a, [$FF8F]		; right BB x
	ld b, [hl]			; left X of enemy
	sub b
	jr c, .noCollision	; C if left X of enemy > right BB X
	ld a, c
	and a, $70			; upper nibble, but only 3 bits
	swap a
	ld b, a
	ld a, [hl]			; still X pos
.loopWidth
	add a, $08			; add width tiles to get the right bound of the enemy
	dec b
	jr nz, .loopWidth
	ld b, a
	ldh a, [$FFA2]		; left BB x
	sub b
	jr nc, .noCollision	; NC if left BB x > right X of enemy
	ld a, 1				; collision detected
	ret

.noCollision
	xor a
	ret

; has to do with Mario riding on platforms and blocks
Call_AEA:: ; AEA
	ld a, [$C207]		; jump status
	cp a, 1
	ret z
	ld de, $0010
	ld b, $0A
	ld hl, $D100		; enemies again
.loop
	ld a, [hl]
	cp a, $FF
	jr nz, .checkEnemy
.nextEnemy
	add hl, de
	dec b
	jr nz, .loop
	ret

.checkEnemy
	push bc
	push hl
	ld bc, $000A
	add hl, bc
	bit 7, [hl]			; mortality?
	jp z, .notOnTop		; only dealing with immortal enemies (platforms, blocks?)
	ld a, [hl]			; mortal bit + width + height
	and a, $0F			; just height
	ldh [$FFA0], a		; hitbox? temporary storage?
	ld bc, -$8
	add hl, bc			; D1x2 Y pos
	ldh a, [$FFA0]		; ...why? do we jump into this?
	ld b, a
	ld a, [hl]			; Y pos
.loopT
	dec b
	jr z, .break		; decrement before subtracting tile height, as the Y pos
	sub a, $08			; already corresponds to the top bound
	jr .loopT

.break
	ld c, a				; enemy top bound
	ldh [$FFA0], a
	ld a, [$C201]		; player y pos
	add a, $06			; todo is mario 6 units tall or so?
	ld b, a				; mario bottom bound
	ld a, c
	sub b
	cp a, $07			; mario has to be less than 8 pixels above the enemy
	jr nc, .notOnTop
	inc l
	ld a, [$C202]		; mario x pos
	ld b, a
	ld a, [hl]			; enemy x pos
	sub b
	jr c, .checkRightBound	; if enemy x < mario x, ok
	cp a, $03
	jr nc, .notOnTop		; maximum 2 units of overhang? why not add before..
.checkRightBound
	push hl
	inc l
	inc l
	inc l
	inc l
	inc l
	inc l
	inc l
	ld a, [hl]			; D1xA
	and a, $70			; width
	swap a
	ld b, a
	pop hl
	ld a, [hl]			; x pos
.loopR
	add a, $08
	dec b
	jr nz, .loopR		; find right bound
	ld b, a
	ld a, [$C202]		; mario x pos
	sub b				; 
	jr c, .jmp_B5D
	cp a, $03
	jr nc, .notOnTop
.jmp_B5D
	dec l
	ldh a, [$FFA0]		; enemy top Y bound
	sub a, $0A
	ld [$C201], a		; position Mario 10 units above
	push hl
	dec l
	dec l				; D1x0
	call $2A01
	pop hl
	ld bc, $0009
	add hl, bc
	ld [hl], $01		; D1xB
	xor a
	ld hl, $C207
	ldi [hl], a			; C207 jump status
	ldi [hl], a			; C208
	ldi [hl], a			; C209
	ld [hl], $01		; C20A 1 if mario on the ground
	ld hl, $C20C		; two INC L's would've been cheaper >_<
	ld a, [hl]
	cp a, $07			; momentum?
	jr c, .out
	ld [hl], $06
.out
	pop hl
	pop bc
	ret

.notOnTop
	pop hl
	pop bc
	jp .nextEnemy

; prepare Mario's dying sprites. And some variables
GameState_03:: ; B8D
	ld hl, wOAMBuffer + $0C	; Mario's 4 sprites todo
	ld a, [$C0DD]		; death Y position?
	ld c, a
	sub a, $08
	ld d, a
	ld [hl], a			; Y position
	inc l
	ld a, [$C202]		; Mario's screen x position
	add a, $F8			; or subtract 8
	ld b, a
	ldi [hl], a			; X position
	ld [hl], $0F		; todo mario dying sprite top
	inc l
	ld [hl], $00		; TODO OAM bits
	inc l
	ld [hl], c			; Y position
	inc l
	ld [hl], b			; X position
	inc l
	ld [hl], $1F		; bottom dying sprite
	inc l
	ld [hl], $00		; OAM, flip
	inc l
	ld [hl], d			; Y position
	inc l
	ld a, b
	add a, $08
	ld b, a
	ldi [hl], a			; X position
	ld [hl], $0F		; top right dying mario sprite (mirrored)
	inc l
	ld [hl], $20		; OAM X flip
	inc l
	ld [hl], c			; Y
	inc l
	ld [hl], b			; X
	inc l
	ld [hl], $1F		; bottom dying sprite
	inc l
	ld [hl], $20		; OAM X flip
	ld a, $04			; dying animation
	ldh [hGameState], a
	xor a
	ld [$C0AC], a
	ldh [hSuperStatus], a
	ldh [$FFF4], a
	call Call_1ED4
	ret

; Dying animation
GameState_04:: ; BD6
	ld a, [$C0AC]		; death animation counter
	ld e, a				; use DE as an offset in the table
	inc a
	ld [$C0AC], a
	ld d, 0
	ld hl, Data_C19
	add hl, de
	ld b, [hl]			; b = Y speed
	ld a, b
	cp a, $7F			; sentinel
	jr nz, .next
	ld a, [$C0AC]
	dec a
	ld [$C0AC], a
	ld b, 2				; coast with the same speed of 2
.next
	ld hl, wOAMBuffer + 3 * 4		; 3rd sprite, first mario sprite
	ld de, 4						; 4 bytes per sprite
	ld c, 4							; 4 sprites in total
.loop
	ld a, b
	add [hl]
	ld [hl], a						; first byte is Y position
	add hl, de						; next sprite
	dec c
	jr nz, .loop
	cp a, $B4						; end animation when he goes low enough
	ret c
	ld a, [wGameTimerExpiringFlag]
	cp a, $FF
	jr nz, .deathState
	ld a, $3B						; Prepare time up
	jr .out
.deathState
	ld a, $90
	ldh [hTimer], a					; 90 frames, 1.5 seconds
	ld a, $01
.out
	ldh [hGameState], a
	ret

Data_C19::
	db -2, -2, -2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 0, -1, 0, 0, -1, 0, 0, 0, 1, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, $7F

; end of level gate, music
GameState_07:: ; C40
	ld hl, hTimer
	ld a, [hl]
	and a
	jr z, .jmp_C4B
	call Call_1736
	ret
.jmp_C4B
	ld a, [$D007]
	and a
	jr nz, .jmp_C55
	ld a, $40
	ldh [hTimer], a
.jmp_C55
	ld a, $05				; score counting down
	ldh [hGameState], a
	xor a
	ld [wGameTimerExpiringFlag], a
	ldh [rTMA], a
	ldh a, [hWorldAndLevel]
	and a, $0F				; select just the level
	cp a, 3
	ret nz
	call $2B2A				; if there was a boss fight. explode enemies?
	ldh a, [hWorldAndLevel]
	cp a, $43				; last level
	ret nz
	ld a, $06				; n
	ldh [hGameState], a
	ret

; explode enemies, count down timer and add to score
GameState_05:: ; C73
	ldh a, [hWorldAndLevel]
	and a, $0F
	cp a, 3
	jr nz, .countdown
	xor a
	ld [$C0AB], a
	call Call_2491		; explodes the enemies?
.countdown
	ldh a, [hTimer]
	and a
	ret nz
	ld hl, wGameTimer + 1
	ldi a, [hl]			; ones and tens
	ld b, [hl]			; hundreds
	or b
	jr z, .endLevel
	ld a, 1
	ld [wGameTimer], a
	SAVE_AND_SWITCH_ROM_BANK 2
	call $5844		; counts the timer down. For some reason in bank 2
	RESTORE_ROM_BANK
	ld de, $0010
	call AddScore
	ld a, 1
	ldh [hTimer], a
	xor a
	ld [wGameTimerExpiringFlag], a
	ld a, [wGameTimer + 1]
	and a, 1
	ret nz
	ld a, $0A
	ld [$DFE0], a
	ret
.endLevel
	ld a, $06
	ldh [hGameState], a
	ld a, $26
	ldh [hTimer], a
	ret

; Winning
GameState_06:: ; CCB
	ldh a, [hTimer]
	and a
	ret nz
	xor a
	ld [wGameTimerExpiringFlag], a
	ldh [rTMA], a
	ldh a, [hWorldAndLevel]
	and a, $0F
	cp a, 3			; boss level
	ld a, $1C		; smth to do with the gate to Daisy
	jr z, .bossLevel
	ld a, [$C201]	; mario on screen Y position
	cp a, $60
	jr c, .bonusGame
	cp a, $A0
	jr nc, .bonusGame
	ld a, $08		; increment level
	jr .changeState

.bonusGame
	ld a, 2			; bonus game is stored in bank 2
	ldh [hActiveRomBank], a
	ld [MBC1RomBank], a
	ld a, $12		; bonus game state
.changeState
	ldh [hGameState], a
	ret

.bossLevel
	ldh [hGameState], a
	ld a, 3
	ld [MBC1RomBank], a
	ldh [hActiveRomBank], a
	ld hl, hLevelIndex
	ld a, [hl]
	ldh [$FFFB], a
	ld [hl], $0C
	inc l				; hl ← level block
	xor a
	ldi [hl], a			; hl = hLevelBlock
	ldi [hl], a			; hl = hColumnIndex
	ldh [$FFA3], a
	inc l
	inc l
	ld a, [hl]			; ffe9, first not yet loaded column
	ldh [$FFE0], a
	ld a, $06			; next state lasts 6 frames
	ldh [hTimer], a
	ldh a, [hWorldAndLevel]
	and a, $F0
	cp a, $40
	ret nz
	xor a
	ldh [$FFFB], a
	ld a, $01
	ld [$C0DE], a
	ld a, $BF
	ldh [$FFFC], a
	ld a, $FF
	ldh [hTimer], a
	ld a, $27			; tatanga dying
	ldh [hGameState], a
	call $7FF3
	ret

GameState_08:: ; D49
.world1Tiles
	di
	ld a, c
	ld [MBC1RomBank], a
	ldh [hActiveRomBank], a	; todo
	xor a
	ldh [rLCDC], a		; turn off LCD
	call Call_5E7		; again? why????
	jp .out
.entryPoint:: ; D49
	ld hl, hTimer
	ld a, [hl]
	and a
	ret nz
	ld a, [$DFF9]
	and a
	ret nz
	ldh a, [hLevelIndex]
	inc a
	cp a, $0C			; 4*3 levels + credits?
	jr nz, .incrementLevel
	xor a
.incrementLevel
	ldh [hLevelIndex], a
	ldh a, [hWorldAndLevel]
	inc a
	ld b, a
	and a, $0F
	cp a, $04
	ld a, b
	jr nz, .notNextWorld
	add a, $10 - 3			; Add one to the World after 3 Levels
.notNextWorld
	ldh [hWorldAndLevel], a
.loadWorldTiles
	and a, $F0			; upper nibble is the world
	swap a
	cp a, 1
	ld c, 2				; world 1 tiles are in rom bank 2
.jmp_D75
	jr z, .world1Tiles	; if world 1, redo work, and in a different subroutine?
	cp a, 2
	ld c, 1				; world 2 tiles are in rom bank 1
	jr z, .jmp_D85
	cp a, 3				; world 3 tiles are in rom bank 3
	ld c, 3
	jr z, .jmp_D85
	ld c, 1				; world 4 tiles are in rom bank 1
.jmp_D85
	ld b, a
	di
	ld a, c
	ld [MBC1RomBank], a
	ldh [hActiveRomBank], a ; todo
	xor a
	ldh [rLCDC], a
	ld a, b
	dec a
	dec a
	sla a				; world 2 → 0, world 3 → 2, world 4 → 4. Index in table
	ld d, 0				; Probably because world 2 and world 4 tiles
	ld e, a				; are in the same bank
	ld hl, .enemyTileOffset
	push de
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, $8A00	; todo vram?
.enemyTileLoop
	ld a, [de]
	ldi [hl], a
	inc de
	push hl
	ld bc, $10000-$8DD0
	add hl, bc
	pop hl
	jr nc, .enemyTileLoop	; fill from 8A00 to 8DD0. World specific enemies
	pop de
	ld hl, .backdropTileOffset
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	push de
	ld hl, $9310
.backdropTileLoop
	ld a, [de]
	ldi [hl], a
	inc de
	ld a, h
	cp a, $97
	jr nz, .backdropTileLoop	; fill from 9310 to 9700. Backdrop
	pop hl
	ld de, $02C1			; Tile 2C is the animated tile
	add hl, de
	ld de, $C600			; animated tile backup
	ld b, 8
.animatedTileLoop
	ldi a, [hl]
	ld [de], a
	inc hl				; Skip every first byte of a pair, which is always 00
	inc de				; It's 1BPP encoded, with padding
	dec b
	jr nz, .animatedTileLoop
.out
	xor a
	ldh [rIF], a
	ld a, $C3
	ldh [rLCDC], a	; TODO
	ei
	ld a, $03
	ldh [hLevelBlock], a	; do all levels start on block 3 todo
	xor a
	ld [$C0D2], a
	ldh [$FFF9], a
	ld a, $02
	ldh [hGameState], a
	call Call_2442
	ret

; todo
.enemyTileOffset
	dw $4032, $4032, $47F2
.backdropTileOffset
	dw $4402, $4402, $4BC2

; leaving bonus game?
GameState_1B:: ; DF9
	di
	xor a
	ldh [rLCDC], a	; turn off lcd
	call PrepareHUD
	call DisplayCoins
	call UpdateLives.displayLives
	xor a
	ldh [rIF], a
	ld a, $C3
	ldh [rLCDC], a
	ei
	ld a, $08
	ldh [hGameState], a
	ldh [$FFB1], a
	ret

GameState_1C:: ; E15
	ldh a, [hTimer]		; wait 6 frames
	and a
	jr z, .nextState
	call LoadNextColumn	; doesn't seem to be necessary
	xor a
	ld [$C0AB], a
	call Call_2491			; explode enemies?
	call Call_1736		; mario animation?
	ret

.nextState
	ld a, $40			; 2/3 second
	ldh [hTimer], a
	ld hl, hGameState
	inc [hl]
	ret					; 1C → 1D

GameState_1D:: ; E31
	xor a
	ld [$C0AB], a
	call Call_2491
	ldh a, [hTimer]
	and a
	ret nz
	ldh a, [$FFE0]		; first column past the end
	sub a, $02			; above gate
	cp a, $40
	jr nc, .nowrap		; in case of wrap around
	add a, $20			; one screen width
.nowrap
	ld l, a
	ld h, $98
	ld de, 9 * $20		; bottom of the gate is 9 tiles under top
	add hl, de
	ld a, l
	ldh [$FFE0], a		; contains low byte of location of bottom of gate
	ld a, $05
	ldh [$FFFC], a		; gate consists of 4 segments (+1 because of shitty logic)
	ld a, $08
	ldh [hTimer], a
	ld hl, hGameState
	inc [hl]
	ret

; Open gate
GameState_1E:: ; E5D
	ldh a, [hTimer]
	and a
	ret nz
	ldh a, [$FFFC]
	dec a
	jr z, .gateIsOpen
	ldh [$FFFC], a
	ldh a, [$FFE0]
	ld l, a
	ld h, $99
	sub a, $20
	ldh [$FFE0], a
.waitHBlank
	ldh a, [$FF41]
	and a, %11
	jr nz, .waitHBlank
	ld [hl], " "
	ld a, $08
	ldh [hTimer], a
	ld a, $0B
	ld [$DFE0], a		; sound effect
	ret

.gateIsOpen
	ld a, $10
	ldh [hTimer], a
	ld a, $03
	ldh [hActiveRomBank], a
	ld [MBC1RomBank], a
	call $7FF3
	ld hl, hGameState
	inc [hl]			; 1E → 1F
	ret

; gate is open
GameState_1F:: ; E96
	ldh a, [hTimer]
	and a
	ret nz
	xor a
	ld [$C0D2], a		; increments at end of level
	ld [$C207], a		; jump status
	inc a
	ldh [$FFF9], a		; tiens, non zero in underground
	ld hl, hGameState
	inc [hl]			; 1F → 20
	ret

; Mario walks/flies off screen
GameState_28::
GameState_20:: ; EA9
	call .walkRight
	ld a, [$C202]		; mario on screen X
	cp a, $C0
	ret c
	ld a, $20
	ldh [hTimer], a
	ld hl, hGameState
	inc [hl]			; 20 → 21
	ret

.walkRight
	ld a, $10
	ldh [hJoyHeld], a	; simulate pressing Right button todo
	ld a, [$C203]		; animation index
	and a, $0F
	cp a, $0A			; animations >= $0A are sub or airplane
	call c, Call_17BC
	call Call_16F5		; animate and move mario
	ret

; preparing Fake Daisy
GameState_21:: ; ECD
	ldh a, [hTimer]
	and a
	ret nz
	call .prepareMarioAndDaisy
	xor a
	ldh [$FFEA], a		; render status?
	ldh [$FFA3], a		; switches between 0 and 8..
	ld a, $A1
	ldh [hTimer], a
	ld a, $0F
	ld [$DFE8], a		; Daisy music
	ld hl, hGameState
	inc [hl]			; 21 → 22
	ret

.prepareMarioAndDaisy::
	ld hl, $C201		; mario y position
	ld [hl], $7E
	inc l
	ld [hl], $B0		; mario x
	inc l
	ld a, [hl]			; C203
	and a, $F0
	ld [hl], a
	ld hl, $C210
	ld de, Data_211D
	ld b, $10
.loop
	ld a, [de]
	ldi [hl], a
	inc de
	dec b
	jr nz, .loop
	ld hl, $C211
	ld [hl], $7E		; sprite Y pos?
	inc l
	ld [hl], $00		; sprite X pos?
	inc l
	ld [hl], $22		; Daisy :)
	inc l
	inc l
	ld [hl], $20		; flipped
	ret


; scroll the screen
GameState_22:: ; F12
	ldh a, [hTimer]
	and a
	jr z, .nextState
	ld hl, hScrollX
	inc [hl]
	call Call_2198		; loads in columns?
	ld hl, $C202		; mario x pos
	dec [hl]
	ld hl, $C212		; fake daisy x pos
	dec [hl]
.animateMarioAndReturn
	call Call_1736
	ret

.nextState
	ldh a, [$FFFB]		; temporarily stores level index?
	ldh [hLevelIndex], a
	ld hl, hGameState
	inc [hl]			; 22 → 23
	ret

GameState_23:: ; F33
	ld a, $10			; right button
	ldh [hJoyHeld], a
	call Call_17BC
	call Call_16F5
	ld a, [$C202]
	cp a, $4C			; almost middle of screen
	ret c
	ld a, [$C203]
	and a, $F0
	ld [$C203], a		; mario standing still
	ld a, [$FFE0]		; top of gate?
	sub a, $40			; two tiles up
	add a, $04			; four to the right
	ld b, a
	and a, $F0
	cp a, $C0
	ld a, b
	jr nz, .nowrap
	sub a, $20
.nowrap
	ldh [$FFE3], a		; probably where the text will appear
	ld a, $98
	ldh [$FFE2], a
	xor a
	ldh [$FFFB], a
	ld hl, hGameState
	inc [hl]
	jr GameState_22.animateMarioAndReturn

; Fake Daisy speaking
GameState_24:: ; F6A
	ld hl, .text_FE1
	call .fakeDaisySpeech
	cp a, $FF		; end of speech
	ret nz
	ld hl, hGameState
	inc [hl]		; 24 → 25
	ld a, $80
	ld [$C210], a	; make sprite invisible
	ld a, $08
	ldh [hTimer], a
	ld a, $08
	ldh [$FFFB], a	; timer for morph
	ld a, $12
	ld [$DFE8], a	; music
	ret

.fakeDaisySpeech	; todo name
	ldh a, [hTimer]
	and a
	ret nz
	ld a, [$FFFB]	; keeps track of letters
	ld e, a
	ld d, $00
	add hl, de
	ld a, [hl]
	ld b, a
	cp a, $FE
	jr z, .newline
	cp a, $FF
	ret z
	ldh a, [$FFE2]
	ld h, a
	ld a, [$FFE3]
	ld l, a
.printLetter
	WAIT_FOR_HBLANK
	WAIT_FOR_HBLANK
	ld [hl], b
	inc hl
	ld a, h
	ldh [$FFE2], a
	ld a, l
	and $0F
	jr nz, .nowrap
	bit 4, l
	jr nz, .nowrap
	ld a, l
	sub a, $20
.nextLetter
	ldh [$FFE3], a
	inc e
	ld a, e
	ldh [$FFFB], a
	ld a, $0C
	ldh [hTimer], a
	ret

.nowrap
	ld a, l
	jr .nextLetter

.newline
	inc hl
	ldi a, [hl]			; next byte determines how many tiles to skip
	ld c, a
	ld b, $00
	ld a, [hl]
	push af
	ldh a, [$FFE2]
	ld h, a
	ldh a, [$FFE3]
	ld l, a
	add hl, bc
	pop bc
	inc de
	inc de
	jr .printLetter

.text_FE1
	db "thank you mario.", $FE, $73
	db "oh! daisy", $FF	

; Fake Daisy morphing
GameState_25:: ; FFD
	ldh a, [hTimer]
	and a
	ret nz
	ldh a, [$FFFB]
	dec a
	jr z, .nextState
	ldh [$FFFB], a
	and a, $01
	ld hl, .morphSprites1
	jr nz, .exchangeSprites
	ld hl, .morphSprites2
	ld a, 3
	ld [$DFF8], a
.exchangeSprites
	call .writeSprites
	ld a, $08
	ldh [hTimer], a
	ret

.nextState
	ld hl, $C210
	ld [hl], $00		; make sprite visible
	ld hl, hGameState
	inc [hl]			; 25 → 26
	ret

.writeSprites
	ld de, wOAMBuffer + 4 * $7	; Daisy sprite
	ld b, 4 * 4					; 4 concomitant sprites
.loop
	ldi a, [hl]
	ld [de], a
	inc e
	dec b
	jr nz, .loop
	ret

.morphSprites1
	db $78, $58, $06, $00
	db $78, $60, $06, $20
	db $80, $58, $06, $40
	db $80, $60, $06, $60

.morphSprites2
	db $78, $58, $07, $00
	db $78, $60, $07, $20
	db $80, $58, $07, $40
	db $80, $60, $07, $60

; Fake Daisy monster jumping away
GameState_26:: ; 1055
	ldh a, [hTimer]
	and a
	ret nz
	ld hl, $C213		; sprite 1 animation index?
	ld [hl], $20		; jumping enemy
	ld bc, $C218
	ld hl, Data_216D	; jumping curve
	push bc
	call $490D			; animates smth?
	pop hl
	dec l
	ld a, [hl]
	and a
	jr nz, .advanceMonster
	ld [hl], $01
	ld hl, $C213
	ld [hl], $21		; jumping enemy on the ground
	ld a, $40
	ldh [hTimer], a
.advanceMonster
	ldh a, [hFrameCounter]
	and a, %1
	jr nz, .out
	ld hl, $C212
	inc [hl]
	ld a, [hl]
	cp a, $D0
	jr nc, .monsterOutOfView
.out
	call Call_1736
	ret

.monsterOutOfView
	ld hl, hGameState
	ld [hl], $12		; go to bonus game
	ld a, $02
	ldh [hActiveRomBank], a
	ld [MBC1RomBank], a
	ret

; Shaking, explosions, blocks disappearing
; the blocks are removed by a constantly rotating bitmask ANDed with the tiles
; the bitmask goes
; 10111111 → 11100111 → 11101100 → 10001101 → 10100001 → 00100100 → 1000010 → 1000000
GameState_27::	; 1099
	ldh a, [$FFA7]
	and a
	jr nz, .jmp_10A7
	ld a, $01
	ld [$DFF8], a		; explosion sound effect
	ld a, $20
	ldh [$FFA7], a
.jmp_10A7
	xor a
	ld [$C0AB], a
	call Call_2491			; explosions?
	ldh a, [hTimer]
	ld c, a
	and a, %11			; shake every 4 frames
	jr nz, .disintegrateBlocks
	ldh a, [$FFFB]
	xor a, $01
	ldh [$FFFB], a
	ld b, -4
	jr z, .shake
	ld b, 4
.shake
	ld a, [$C0DF]		; scroll Y
	add b
	ld [$C0DF], a
.disintegrateBlocks
	ld a, c
	cp a, $80
	ret nc				; start disappearing block 128 frames before the end
	and a, $20 - 1		; every 32 frames
	ret nz
	ld hl, $8DD0		; all kinds of tiles, even tho only 3 are visible
	ld bc, 34 * $10		; 34 from the start, but it skips ahead somewhere
	ldh a, [$FFFC]		; starts at BF 10111111
	ld d, a
.maskTileRow
	WAIT_FOR_HBLANK
	ld a, [hl]
	and d
	ld e, a
	WAIT_FOR_HBLANK
	ld [hl], e
	inc hl
	ld a, h
	cp a, $8F
	jr nz, .dontSkipAhead
	ld hl, $9690
.dontSkipAhead
	rrc d				; rotate the bitmask to the right
	dec bc
	ld a, c
	or b
	jr nz, .maskTileRow
	ldh a, [$FFFC]
	sla a				; shift a new zero bit in the mask
	jr z, .allTilesGone
	swap a
	ldh [$FFFC], a
	ld a, $3F
	ldh [hTimer], a
	ret

.allTilesGone
	xor a
	ld [$C0DF], a		; stop screen shake
	ld [$C0D2], a
	inc a
	ldh [$FFF9], a
	ld hl, hGameState
	inc [hl]			; 27 → 28
	ret

GameState_29:: ; 1116
	di
	xor a
	ldh [rLCDC], a
	ldh [$FFF9], a
	ld hl, $9C00
	ld bc, $0100
	call EraseTileMap
	call Call_807.drawLevel
	call GameState_21.prepareMarioAndDaisy
	ld hl, $C202		; mario X position
	ld [hl], $38
	inc l
	ld [hl], $10		; Super Mario
	ld hl, $C212
	ld [hl], $78		; Daisy X position
	xor a
	ldh [rIF], a
	ldh [hScrollX], a
	ld [$C0DF], a		; Y isn't scrolled
	ldh [$FFFB], a
	ld hl, wOAMBuffer
	ld b, 3*4			; 3 projectiles?
.loop
	ldi [hl], a
	dec b
	jr nz, .loop
	call Call_1736
	ld a, $98
	ldh [$FFE2], a
	ld a, $A5
	ldh [$FFE3], a
	ld a, $0F
	ld [$DFE8], a
	ld a, $C3
	ldh [rLCDC], a
	ei
	ld hl, hGameState
	inc [hl]			; 29 → 2A
	ret

GameState_2A:: ; 1165
	ld hl, .text_1183
	call GameState_24.fakeDaisySpeech	; todo
	cp a, $FF
	ret nz
	xor a
	ldh [$FFFB], a
	ld a, $99
	ldh [$FFE2], a
	ld a, $02
	ldh [$FFE3], a
	ld a, $23
	ld [$C213], a		; animation index?
	ld hl, hGameState
	inc [hl]			; 2A → 2B
	ret

.text_1183
	db "oh! daisy", $FE, $1B, "daisy", $FF

; Daisy running towards Mario
GameState_2B:: ; 1194
	ld hl, .text_11BF
	call GameState_24.fakeDaisySpeech
	ldh a, [hFrameCounter]
	and a, $03
	ret nz
	ld hl, $C212		; daisy X pos
	ld a, [hl]
	cp a, $44
	jr c, .out
	dec [hl]
	call Call_1736
	ret

.out
	ld hl, hGameState
	inc [hl]
	ld hl, wOAMBuffer +  4 * $C
	ld [hl], $70		; Y pos
	inc l
	ld [hl], $3A		; X pos
	inc l
	ld [hl], "♥"		; sprite
	inc l
	ld [hl], 0
	ret

.text_11BF
	db "thank you mario.", $FF

; kiss ^_^
GameState_2C:: ; 11D0
	ldh a, [hFrameCounter]
	and a, %1
	ret nz
	ld hl, wOAMBuffer + 4 * $C ; todo sprite macro?
	dec [hl]			; Y pos
	ldi a, [hl]
	cp a, $20			; if heart gets high
	jr c, .clearMessageAndOut
	ldh a, [$FFFB]
	and a
	ld a, [hl]
	jr nz, .goRight
	dec [hl]			; heart goes left
	cp a, $30
	ret nc
.out
	ldh [$FFFB], a
	ret

.goRight
	inc [hl]
	cp a, $50
	ret c
	xor a
	jr .out

.clearMessageAndOut
	ld [hl], $F0
	ld b, $6D
	ld hl, $98A5
.loop
	WAIT_FOR_HBLANK
	WAIT_FOR_HBLANK
	ld [hl], " "
	inc hl
	dec b
	jr nz, .loop
	xor a
	ldh [$FFFB], a
	ld a, $99
	ldh [$FFE2], a
	ld a, $00
	ldh [$FFE3], a
	ld hl, hGameState
	inc [hl]			; 2C → 2D
	ret

; your quest is over
GameState_2D:: ; 121B
	ld hl, .text_123F
	call GameState_24.fakeDaisySpeech
	cp a, $FF
	ret nz
	ld hl, $C213	; daisy run
	ld [hl], $24
	inc l
	inc l
	ld [hl], $00	; facing right?
	ld hl, $C241	; spaceship entity
	ld [hl], $7E	; Y pos
	inc l
	inc l
	ld [hl], $28	; spaceship
	inc l
	inc l
	ld [hl], $00	; facing right
	ld hl, hGameState
	inc [hl]		; 2D → 2E
	ret

.text_123F
	db "-your quest is over-", $FF

; Mario & Daisy walking
GameState_2E::
	ldh a, [hFrameCounter]
	and a, $03
	jr nz, .jmp_1261
	ld hl, $C213		; daisy animation
	ld a, [hl]
	xor a, $01			; two daisy walking sprites
	ld [hl], a
.jmp_1261
	ld hl, $C240		; spaceship
	ld a, [hl]
	and a
	jr nz, .walkMarioDaisy
	inc l				; move spaceship
	inc l
	dec [hl]			; X pos
	ld a, [hl]
	cp a, $50
	jr nz, .checkIfBothAreInSpaceship	; todo name
	ld a, $80			; Mario "enters" the spaceship (becomes invisible)
	ld [$C200], a
	jr .walkMarioDaisy

.checkIfBothAreInSpaceship
	cp a, $40
	jr nz, .walkMarioDaisy
	ld a, $80
	ld [$C210], a		; Daisy "enters" the spaceship
	ld a, $40
	ldh [hTimer], a		; 40 frames, 2/3 second
	ld hl, hGameState
	inc [hl]			; 2E → 2F
.walkMarioDaisy
	call GameState_20.walkRight
	call Call_2198		; level rendering
	ldh a, [hLevelBlock]
	cp a, $03
	ret nz
	ldh a, [hColumnIndex]
	and a
	ret nz
	ld hl, $C240		; spaceship
	ld [hl], $00		; make visible?
	inc l
	inc l
	ld [hl], $C0		; X pos
	ret

; prepare for liftoff
GameState_2F:: ; 12A1
	ldh a, [hTimer]
	and a
	ret nz
	ld hl, $C240		; spaceship
	ld de, $C200		; mario
	ld b, $06
.loop
	ldi a, [hl]
	ld [de], a
	inc e
	dec b
	jr nz, .loop		; todo macro?
	ld hl, $C203		; animation
	ld [hl], $26
	ld hl, $C241		; previous spaceship
	ld [hl], $F0		; out of sight, out of mind
	ld hl, hGameState
	inc [hl]			; 2F → 30
	ret

GameState_30:: ; 12C2
	call Call_1736		; animate "Mario" (spaceship)
	ldh a, [hFrameCounter]
	ld b, a
	and a, 1
	ret nz
	ld hl, $C240
	ld [hl], $FF		; make invisible. Why not do this before?
	ld hl, $C201		; Y pos
	dec [hl]			; take off
	ldi a, [hl]
	cp a, $58
	jr z, .cruisingAltitude
	call .switchSpaceshipAnimation
	ret

.cruisingAltitude
	ld hl, hGameState
	inc [hl]				; 30 → 31
	ld a, $04
	ldh [$FFFB], a
	ret

.switchSpaceshipAnimation
	ldh a, [hFrameCounter]
	and a, 3
	ret nz
	inc l
	ld a, [hl]				; C203, animation
	xor a, 1				; switch exhaust flame
	ld [hl], a
	ret

GameState_31:: ; 12F1
	call .animateSpaceship
	call Call_2198		; loads level
	ldh a, [hScrollX]
	inc a
	call z, .call_1318
	inc a
	call z, .call_1318
	ldh [hScrollX], a
	ld a, [$DFE9]		; wait until the song is over?
	and a
	ret nz
	ld a, $11
	ld [$DFE8], a
	ret

.animateSpaceship
	ld hl, $C202		; X pos
	call GameState_30.switchSpaceshipAnimation
	call Call_1736		; animate entities
	ret

.call_1318
	push af
	ldh a, [$FFFB]
	dec a				; FFFB starts at 4. So traverse 4 blocks
	ld [$FFFB], a
	jr nz, .out
	ldh [rLYC], a		; A is 0 here. Removes HUD?
	ld a, $21
	ldh [$FFFB], a
	ld a, $54
	ldh [$FFE9], a
	call .clearColumn
	ld hl, $C210
	ld de, .data_137F
	call .replaceEntity
	ld hl, $C220		; cloud?
	ld de, .data_1384
	call .replaceEntity
	ld hl, $C230
	ld de, .data_1389
	call .replaceEntity
	ld hl, hGameState
	inc [hl]
.out
	pop af
	ret

.clearColumn
	ld hl, $C0B0
	ld b, $10
	ld a, $2C
.clearLoop
	ldi [hl], a
	dec b
	jr nz, .clearLoop
	ld a , 1
	ldh [$FFEA], a
	ld b, $02
	ldh a, [$FFE9]		; first not yet loaded column
	sub a, $20
	ld l, a
	ld h, $98
.clearLoop2
	WAIT_FOR_HBLANK
	ld [hl], " "
	ld a, l
	sub a, $20
	ld l, a
	dec b
	jr nz, .clearLoop2
	ret

.replaceEntity
	ld b, $05
.loop
	ld a, [de]
	ldi [hl], a
	inc de
	dec b
	jr nz, .loop
	ret

.data_137F
	db $00, $30, $D0, $29, $80
.data_1384
	db $80, $70, $10, $2A, $80
.data_1389
	db $80, $40, $70, $29, $80

GameState_32:: ; 138E
	call AnimateSpaceshipAndClouds
	ldh a, [hScrollX]
	inc a
	inc a
	ldh [hScrollX], a
	and a, $08
	ld b, a
	ldh a, [$FFA3]	; switches between 0 and 8, depending on column loaded
	cp b
	ret nz
	xor a, $08
	ldh [$FFA3], a
	call GameState_31.clearColumn
	ldh a, [$FFFB]
	dec a
	ldh [$FFFB], a
	ret nz
	xor a
	ldh [hScrollX], a
	ld a, $60
	ldh [rLYC], a
	ld hl, Text_1557
	ld a, h
	ldh [$FFE2], a
	ld a, l
	ldh [$FFE3], a
	ld a, $F0
	ldh [hTimer], a
	ld hl, hGameState
	inc [hl]		; 32 → 33
	ret


GameState_33:: ; 13C4
.animateClouds
	ld hl, $C212	; clouds X pos
	ld de, $0010
	ld b, $03
.floatCloud
	dec [hl]		; float to the left
	ld a, [hl]
	cp a, $01
	jr nz, .checkCloudForReset
	ld [hl], $FE
	jr .nextCloud

.checkCloudForReset
	cp a, $E0
	jr nz, .nextCloud	; reset if cloud hits E0 from the right
	push hl
	ldh a, [rDIV]	; divider register, pseudorandom
	dec l			; Y position
	add [hl]
	and a, $7F		; make Y pos <= 7F
	cp a, $68		; clear between 3F and 68 (spaceship, the end)
	jr nc, .resetCloud
	and a, $3F
.resetCloud
	ldd [hl], a
	ld [hl], 0
	pop hl
.nextCloud
	add hl, de
	dec b
	jr nz, .floatCloud
	ret

.entryPoint:: ; 13F0
	call AnimateSpaceshipAndClouds
	ldh a, [hTimer]
	and a
	ret nz
	ldh a, [$FFE2]
	ld h, a
	ldh a, [$FFE3]
	ld l, a
	ld de, $9A42	; start of first line. Below the stage, scrolled in later
.printLine
	ld a, [hl]
	cp a, $FE		; end of line
	jr z, .eraseTillEndOfLine
	inc hl
	ld b, a
.printCharacter
	WAIT_FOR_HBLANK
	WAIT_FOR_HBLANK
	ld a, b
	ld [de], a
	inc de
	ld a, e
	cp a, $54
	jr z, .nextLine
	cp a, $93
	jr z, .startCreditsScroll
	jr .printLine

.eraseTillEndOfLine
	ld b, " "
	jr .printCharacter

.nextLine
	ld de, $9A87
	inc hl
	jr .printLine

.startCreditsScroll
	inc hl
	ld a, [hl]
	cp a, $FF
	jr nz, .nextState
	ld a, $FF
	ld [$C0DE], a		; will be put in SCY
.nextState
	ld a, h
	ldh [$FFE2], a
	ld a, l
	ldh [$FFE3], a
	ld hl, hGameState
	inc [hl]			; 33 → 34
	ret

; credits entering
GameState_34::
	call AnimateSpaceshipAndClouds
	ldh a, [hFrameCounter]
	and a, 3
	ret nz
	ld hl, $C0DF		; scroll Y
	inc [hl]
	ld a, [hl]
	cp a, $20			; scroll $20 pxs up
	ret nz
	ld hl, hGameState
	inc [hl]			; 34 → 35
	ld a, $50
	ldh [hTimer], a
	ret


GameState_35:: ; 145A
	call AnimateSpaceshipAndClouds
	ldh a, [hTimer]
	and a
	ret nz
	ld hl, hGameState
	inc [hl]			; 35 → 36
	ret

; scroll credits up, out of sight
GameState_36:: ; 1466
	call AnimateSpaceshipAndClouds
	ldh a, [hFrameCounter]
	and a, 3
	ret nz
	ld hl, $C0DF
	inc [hl]
	ld a, [hl]
	cp a, $50
	ret nz
	xor a
	ld [$C0DF], a
	ld a, [$C0DE]
	cp a, $FF
	ld a, $33
	jr nz, .out
	ld a, $37
.out
	ldh [hGameState], a
	ret

; spaceship flies off, prepare "THE END"
GameState_37::
	call AnimateSpaceshipAndClouds
	ld hl, $C202		; X position
	inc [hl]
	ld a, [hl]
	cp a, $D0			; out of sight??
	ret nz
	dec l
	ld [hl], $F0
	push hl
	call Call_1736
	pop hl
	dec l
	ld [hl], $FF		; make invisible?
	ld hl, wOAMBuffer + 4 * $1C	; sprite 1C?
	ld de, .data_14C4
	ld b, $18
.loop1
	ld a, [de]
	ldi [hl], a
	inc de
	dec b
	jr nz, .loop1
	ld b, $18
	xor a
.loop2
	ldi [hl], a
	dec b
	jr nz, .loop2
	ld a, $90
	ldh [hTimer], a
	ldh a, [hWinCount]
	inc a
	ldh [hWinCount], a
	ld [wWinCount], a
	ld hl, hGameState
	inc [hl]			; 37 → 38
	ret

.data_14C4
	db $4E, $CC, $52, 00 ; T
	db $4E, $D4, $53, 00 ; H
	db $4E, $DC, $54, 00 ; E
	db $4E, $EC, $54, 00 ; E
	db $4E, $F4, $55, 00 ; N
	db $4E, $FC, $56, 00 ; D

GameState_38::
	call AnimateSpaceshipAndClouds
	ldh a, [hTimer]
	and a
	ret nz
	ld hl, $C071		; letter sprite X position
	ld a, [hl]
	cp a, $3C
	jr z, .nextLetter
.animateLetter
	dec [hl]
	dec [hl]
	dec [hl]
	ret

.nextLetter
	ld hl, $C075
	ld a, [hl]
	cp a, $44
	jr nz, .animateLetter
	ld hl, $C079
	ld a, [hl]
	cp a, $4C
	jr nz, .animateLetter
	ld hl, $C07D
	ld a, [hl]
	cp a, $5C
	jr nz, .animateLetter
	ld hl, $C081
	ld a, [hl]
	cp a, $64
	jr nz, .animateLetter
	ld hl, $C085
	ld a, [hl]
	cp a, $6C
	jr nz, .animateLetter
	call .checkForButtonPress
	xor a
	ldh [hLevelIndex], a
	ldh [hSuperStatus], a
	ldh [hSuperballMario], a
	ld [wNumContinues], a
	ld a, $11
	ldh [hWorldAndLevel], a
	ret

.checkForButtonPress
	ldh a, [hJoyPressed]
	and a
	ret z
	call $7FF3
.resetToMenu
	ld a, $02
	ldh [hActiveRomBank], a
	ld [MBC1RomBank], a
	ld [$C0DC], a
	ld [$C0A4], a
	xor a
	ld [wGameTimer], a
	ld [$C0A5], a
	ld [$C0AD], a
	ld a, $03
	ldh [rIE], a
	ld a, $0E
	ldh [hGameState], a	; init menu
	ret

AnimateSpaceshipAndClouds
	call GameState_31.animateSpaceship
	call GameState_33.animateClouds
	ret

Text_1557
	db "producer", $FE
	db "g.yokoi", $FE
	db "director", $FE
	db "s.okada", $FE
	db "programmer", $FE
	db "m.yamamoto", $FE
	db "programmer", $FE
	db "t.harada", $FE
	db "design", $FE
	db "h.matsuoka", $FE
	db "sound", $FE
	db "h.tanaka", $FE
	db "amida", $FE
	db "m.yamanaka", $FE
	db "design", $FE
	db "mashimo", $FE
	db "special thanks to:", $FE
	db "taki", $FE
	db "izushi", $FE
	db "nagata", $FE
	db "kanoh", $FE
	db "nishizawa", $FE
	db $FF

; go down pipe
GameState_09:: ; 161B
	ld hl, $C201		; Mario Y position
	ldh a, [$FFF8]		; Y position of block under pipe? Y target at least
	cp [hl]
	jr z, .toUnderground
	inc [hl]			; Y coord increases going down
	call Call_16F5		; animate or so
	ret
.toUnderground
	ld a, $0A
	ldh [hGameState], a	; warp to underground
	ldh [$FFF9], a
	ret

; warp to underground
GameState_0A:: ; 162F
	di
	xor a
	ldh [rLCDC], a
	ldh [hColumnIndex], a
	call Call_1ED4		; clears sprites that aren't player, enemy or platform?
	call Call_165E
	ldh a, [$FFF4]
	ldh [hLevelBlock], a
	call Call_807		; draws the first screen of the "level"
	call Call_245C
	ld hl, $C201		; Mario Y position
	ld [hl], $20		; up high
	inc l				; Mario X position
	ld [hl], $1D		; a little to the left
	inc l
	inc l
	ld [hl], $00		; direction mario is facing
	xor a
	ldh [rIF], a
	ldh [hGameState], a
	ldh [hScrollX], a
	ld a, $C3			; todo
	ld [rLCDC], a
	ei
	ret

; clear some sort of overlay?
Call_165E ; 165E
	ld hl, $CA3F		; the bottom rightmost tile of the total area
	ld bc, $0240
.clearLoop
	xor a
	ldd [hl], a
	dec bc
	ld a, b
	or c
	jr nz, .clearLoop	; you've got to be fucking kidding me
	ret

; going in pipe out of underground
GameState_0B:: ; 166C
	ldh a, [hFrameCounter]
	and a, $01			; slow down mario by half
	ret z
	ld hl, $C202		; screen X position
	ldh a, [$FFF8]		; goal X value?
	cp [hl]
	jr c, .toOverworld		; warp out? todo
	inc [hl]
	ld hl, $C20B		; how many frames a direction is held. For animation?
	inc [hl]
	call Call_16F5		; animate mario?
	ret
.toOverworld
	di
	ldh a, [$FFF5]		; (one less than) the block we went in?
	ldh [hLevelBlock], a
	xor a
	ldh [rLCDC], a		; turn off lcd
	ldh [hColumnIndex], a
	call Call_165E	; A is zero after this
	ld hl, $FFF4
	ldi [hl], a
	ldi [hl], a
	ldh a, [$FFF7]		; FFF6 and FFF7 contain the coords where Mario will
	ld d, a				; come out of the pipe
	ldh a, [$FFF6]
	ld e, a
	push de
	call Call_807		; draw the level
	pop de
	ld a, $80
	ld [$C204], a
	ld hl, $C201		; mario Y
	ld a, d
	ldi [hl], a
	sub a, $12			; target position is 12 units above spawn? right on top
	ldh [$FFF8], a		; of pipe?
	ld a, e
	ld [hl], a
	ldh a, [hLevelBlock]
	sub a, $04
	ld b, a
	rlca
	rlca
	rlca
	add b
	add b
	add a, $0C			; a = (hLevelBlock - 4)* 10 + 0xC....?
	ld [$C0AB], a		; sort of progress in the level in columns / 2?
	xor a
	ldh [rIF], a
	ldh [hScrollX], a
	ld a, $5B
	ldh [$FFE9], a		; first col not yet loaded in. IMO $807 should do this
	call Call_245C
	call Call_1ED4		; clears sprites
	ld a, $C3
	ldh [rLCDC], a
	ld a, $0C
	ldh [hGameState], a
	call StartLevelMusic
	ei
	ret

; coming up out of pipe
GameState_0C:: ; 16DA
	ldh a, [hFrameCounter]
	and a, $01				; slow down animation by 2
	ret z
	ld hl, $C201			; y position
	ldh a, [$FFF8]			; y target?
	cp [hl]
	jr z, .outOfPipe
	dec [hl]				; Y coordinate decrease going up
	call Call_16F5			; animate?
	ret
.outOfPipe
	xor a
	ldh [hGameState], a
	ld [$C204], a			; smth to do with mario having control?
	ldh [$FFF9], a
	ret

Call_16F5:: ; 16F5 Animate mario?
	call Call_1736
	ld a, [$C20A]			; 1 if mario on the ground
	and a
	jr z, .jmp_172C
	ld a, [$C203]			; animation index
	and a, $0F				; low nibble
	cp a, $0A
	jr nc, .jmp_172C		; JR if animation index is >= 0xA, which is sub and airplane stuff
	ld hl, $C20B			; animation frame counter?
	ld a, [$C20E]			; 2 when walking, 4 when stuff
	cp a, $23
	ld a, [hl]
	jr z, .jmp_1730			; wait, can this ever happen... Bug?
	and a, $03
	jr nz, .jmp_172C		; any 3 movement frames, change animation
.jmp_1716
	ld hl, $C203
	ld a, [hl]
	cp a, $18				; crouching Super Mario
	jr z, .jmp_172C
	inc [hl]
	ld a, [hl]
	and a, $0F
	cp a, $04				; 3 sprites in the walking animation
	jr c, .jmp_172C
	ld a, [hl]
	and a, $F0
	or a, $01
	ld [hl], a
.jmp_172C
	call Call_1D26			; check movement keys, move mario?
	ret
.jmp_1730
	and a, $01
	jr nz, .jmp_172C
	jr .jmp_1716

; animate mario?
Call_1736::
	ld a, $0C
	ldh [$FF8E], a	; oh joy, new variables..
	ld hl, $C200
	ld a, $C0
	ldh [$FF8D], a
	ld a, $05
	ldh [$FF8F], a
	SAVE_AND_SWITCH_ROM_BANK 3
	call $4823
	RESTORE_ROM_BANK
	ret

; standing on boss switch
Jmp_175B:: ; 175B
	ldh a, [hGameState]
	cp a, $0E
	jp nc, $181E
	jp Jmp_1B45				; Mario wins

; Called every frame when standing on a pipe?
Jmp_1765:: ; 1765
	ldh a, [hJoyHeld]
	bit 7, a
	jp z, Jmp_185D			; Down button
	ld bc, -$20				; one screen width?
	ld a, h
	ldh [$FFB0], a
	ld a, l
	ldh [$FFAF], a
	ld a, h
	add a, $30
	ld h, a
	ld de, $FFF4
	ld a, [hl]
	and a
	jp z, Jmp_185D
	ld [de], a
	inc e
	add hl, bc
	ld a, [hl]
	ld [de], a
	inc e
	add hl, bc
	ld a, [hl]
	ld [de], a
	inc e
	add hl, bc
	ld a, [hl]
	ld [de], a
	inc e
	push de
	call Call_3F13			; called when hitting a bouncing block
	pop de
	ld hl, $C201			; Y pos
	ldi a, [hl]
	add a, $10
	ld [de], a
	ldh a, [hScrollX]
	ld b, a
	ldh a, [$FFAE]
	sub b
	add a, $08
	ldi [hl], a
	inc l
	ld [hl], $80
	ld a, $09
	ldh [hGameState], a		; go down pipe
	ld a, [wInvincibilityTimer]
	and a
	jr nz, .skip			; Keep invincibility music going
	ld a, $04
	ld [$DFE8], a			; underground music
.skip
	call Call_1ED4			; clears some sprites
	jp Jmp_185D

; called every frame?
Call_17BC:: ; 17BC
	ld hl, $C207			; jump status
	ld a, [hl]
	cp a, $01
	ret z
	ld hl, $C201			; Y pos
	ldi a, [hl]
	add a, $0B
	ldh [$FFAD], a
	ldh a, [hScrollX]
	ld b, a
	ld a, [hl]
	add b
	add a, $FE				; -2?
	ldh [$FFAE], a
	call Mystery_153
	cp a, $70				; standing on pipe
	jr z, Jmp_1765
	cp a, $E1				; boss switch
	jp z, Jmp_175B			; can this be a JR?
	cp a, $60				; solid tiles
	jr nc, .jmp_181E		; why is this a JP? Bug?
	ld a, [$C20E]			; 02 walking, 04 running
	ld b, $04
	cp a, $04
	jr nz, .jmp_17F5
	ld a, [$C207]			; jump status
	and a
	jr nz, .jmp_17F5
	ld b, $08
.jmp_17F5
	ldh a, [$FFAE]
	add b
	ldh [$FFAE], a
	call Mystery_153
	cp a, $60
	jr nc, .jmp_181E
.jmp_1801
	ld hl, $C207
	ld a, [hl]
	cp a, $02
	ret z					; return if descending
	ld hl, $C201			; Y pos
	inc [hl]
	inc [hl]
	inc [hl]				; falling without having jumped
	ld hl, $C20A
	ld [hl], 0				; Mario not on ground
	ld a, [$C20E]
	and a
	ret nz
	ld a, $02
	ld [$C20E], a
	ret

.jmp_181E
	cp a, $ED				; spike
	push af
	jr nz, .jmp_1842
	ld a, [wInvincibilityTimer]
	and a
	jr nz, .jmp_1842
	ldh a, [hSuperStatus]
	and a
	jr z, .jmp_183C
	cp a, $04				; i frames after hit
	jr z, .jmp_1842
	cp a, $02
	jr nz, .jmp_1842
	pop af
	call InjureMario
	jr Jmp_185D

.jmp_183C
	pop af
	call KillMario
	jr Jmp_185D

.jmp_1842
	pop af
	cp a, $F4				; Coin
	jr nz, Jmp_185D
	push hl
	pop de
	ld hl, $FFEE
	ld a, [hl]
	and a
	jr nz, .jmp_1801
	ld [hl], $C0
	inc l
	ld [hl], d
	inc l
	ld [hl], e
	ld a, $05
	ld [$DFE0], a			; coin sound
	jr .jmp_1801

Jmp_185D
	ld hl, $C201
	ld a, [hl]
	dec a
	dec a
	and a, $FC				; erase lowest 2 bits
	or a, $06				; and set 2 and 1
	ld [hl], a
	xor a
	ld hl, $C207			; jump status
	ldi [hl], a				; C208 no clue
	ldi [hl], a				; C209 no clue
	ldi [hl], a				; C20A 1 if mario on the ground
	ld [hl], $01			; C20B animation counter
	ld hl, $C20C			; Why not just INC L... Bug. Momentum
	ld a, [hl]
	cp a, $07
	ret c
	ld [hl], $06
	ret

; hidden block
.jmp_187B:: ; 187B
	ldh a, [$FFEE]
	and a
	ret nz
	push hl					; HL contains VRAM location of hidden block
	ld a, h
	add a, $30				; overlay? :/
	ld h, a
	ld a, [hl]
	pop hl
	and a					; if 0, don't make the hidden block appear
	ret z					; it's from a different level screen/block
.jmp_1888
	ldh a, [$FFEE]
	and a
	ret nz
	push hl
	ld a, h
	add a, $30
	ld h, a
	ld a, [hl]				; wait, why again?
	pop hl
	and a
	jp z, $19E1
	cp a, $F0				; nothing, just a solid grey block
	jr z, .jmp_18C0
.jmp_189B
	cp a, $C0				; coin block
	jr nz, .jmp_18C7		; everything else comes out of a solid grey block
	ld a, $FF
	ld [$C0CE], a			; timer :)
.jmp_18A4
	ldh a, [$FFEE]
	and a
	ret nz
	ld a, $05
	ld [$DFE0], a			; coin sound effect
	ld a, [$C201]			; Y pos
	sub a, $10
	ldh [$FFEC], a
	ld a, $C0
	ldh [$FFED], a
	ldh [$FFFE], a
	ld a, [$C0CE]
	and a
	jr nz, .jmp_1923
.jmp_18C0
	ld a, $80
	ld [wOAMBuffer + 4*$B + 2], a
	jr .jmp_1937

.jmp_18C7
	ldh [$FFA0], a
	ld a, $80
	ld [wOAMBuffer + 4*$B + 2], a
	ld a, $07
	ld [$DFE0], a			; bump sound effect
	push hl
	pop de
	ld hl, $FFEE
	ld a, [hl]
	and a
	ret nz
	ld [hl], $02			; bounce block?
	inc l
	ld [hl], d
	inc l
	ld [hl], e
	ld a, d
	ldh [$FFB0], a
	ld a, e
	ldh [$FFAF], a
	ld a, d
	add a, $30
	ld d, a
	ld a, [de]
	ldh [$FFA0], a
	call Call_3F13
	ld hl, wOAMBuffer + 4*$B
	ld a, [$C201]
	sub a, $0B
	ldi [hl], a				; Y pos of sprite on top of mario?
	ldh [$FFC2], a			; enemy Y pos buffer?
	ldh [$FFF1], a
	ldh a, [hScrollX]
	ld b, a
	ldh a, [$FFAE]
	ldh [$FFF2], a
	sub b
	ldi [hl], a
	ldh [$FFC3], a			; enemy X pos buffer?
	inc l
	ld [hl], $00
	ldh a, [$FFA0]
	cp a, $F0
	ret z
	cp a, $28				; mushroom
	jr nz, .jmp_191F
	ldh a, [hSuperStatus]
	cp a, $02
	ld a, $28
	jr nz, .jmp_191F
	ld a, $2D				; flower
.jmp_191F
	call $254D				; make it come out?
	ret

.jmp_1923
	ldh a, [$FFEE]
	and a
	ret nz
	ld a, $82
	ld [$C02E], a
	ld a, [$DFE0]
	and a
	jr nz, .jmp_1937
	ld a, $07
	ld [$DFE0], a

.jmp_1937
	push hl
	pop de
	ld hl, $FFEE
	ld [hl], $02
	inc l
	ld [hl], d
	inc l
	ld [hl], e
	ld a, d
	ldh [$FFB0], a
	ld a, e					; store HL in FFEF, FFF0, FFB0 and FFAF?
	ld [$FFAF], a			; what a mess
	call Call_3F13
	ld hl, wOAMBuffer + 4*$B
	ld a, [$C201]			; y pos
	sub a, $B
	ldi [hl], a
	ldh [$FFF1], a
	ldh a, [hScrollX]
	ld b, a
	ld a, [$FFAE]
	ld c, a
	ldh [$FFF2], a
	sub b
	ldi [hl], a
	inc l
	ld [hl], $00
	ldh [$FFEB], a
	ret

; hitting a Mystery Block
.jmp_1966:: ; 1966
	ldh a, [$FFEE]
	and a
	ret nz
	push hl
	ld a, h
	add a, $30
	ld h, a
	ld a, [hl]
	pop hl
	and a
	jp nz, .jmp_189B
	ld a, $05				; empty Mystery Block contain a single coin
	ld [$DFE0], a
	ld a, $81
	ld [$C02E], a
	ld a, [$C201]			; ypos
	sub a, $10
	ldh [$FFEC], a
	ld a, $C0
	ldh [$FFED], a
	jr .jmp_1937

.call_198C
	ld a, [$C207]			; jump status
	cp a, $01				; ascending
	ret nz
	ld hl, $C201
	ldi a, [hl]
	add a, -$3				; look for collision on mario's head
	ldh [$FFAD], a
	ldh a, [hScrollX]
	ld b, [hl]
	add b
	add a, $02
	ldh [$FFAE], a
	call Mystery_153
	cp a, $5F				; Hidden Block
	jp z, .jmp_187B
	cp a, $60
	jr nc, .jmp_19BF
	ldh a, [$FFAE]
	add a, -$4
	ldh [$FFAE], a
	call Mystery_153
	cp a, $5F
	jp z, .jmp_187B
	cp a, $60
	ret c					; non solid block
.jmp_19BF
	call Call_1A6B			; platform-like blocks
	and a
	ret z
	cp a, $82				; breakable block
	jr z, .jmp_19E1
	cp a, $F4				; coin
	jp z, .jmp_1A57
	cp a, $81				; mystery block
	jr z, .jmp_1966
	cp a, $80
	jp z, .jmp_1888
	ld a, $02
	ld [$C207], a
	ld a, $07
	ld [$DFE0], a			; bump
	ret

.jmp_19E1
	push hl
	ld a, h
	add a, $30
	ld h, a
	ld a, [hl]
	pop hl
	cp a, $C0
	jp z, .jmp_18A4
	ldh a, [hSuperStatus]
	cp a, $02
	jp nz, .jmp_1923
	push hl
	pop de
	ld hl, $FFEE
	ld a, [hl]
	and a
	ret nz
	ld [hl], $01
	inc l
	ld [hl], d
	inc l
	ld [hl], e
	ld hl, $C210			; block fragments?
	ld de, $0010
	ld b, $04
.jmp_1A0A
	push hl
	ld [hl], $00
	inc l					; C2x1 Y
	ld a, [$C201]
	add a, -$D
	ld [hl], a
	inc l					; C2x2 X
	ld a, [$C202]
	add a, $2
	ld [hl], a
	inc l					; C2x3
	inc l                   ; C2x4
	inc l                   ; C2x5
	inc l                   ; C2x6
	inc l                   ; C2x7
	ld [hl], $01
	inc l					; C2x8
	ld [hl], $07
	pop hl
	add hl, de
	dec b
	jr nz, .jmp_1A0A
	ld hl, $C222
	ld a, [hl]
	sub a, $04
	ld [hl], a
	ld hl, $C242
	ld a, [hl]
	sub a, $04
	ld [hl], a
	ld hl, $C238
	ld [hl], $0B
	ld hl, $C248
	ld [hl], $0B
	ldh a, [hScrollX]
	ldh [$FFF3], a
	ld a, $02
	ld [$DFF8], a			; breaking block sound effect
	ld de, $0050
	call AddScore
	ld a, $02
	ld [$C207], a
	ret

.jmp_1A57
	push hl
	pop de
	ld hl, $FFEE
	ld a, [hl]
	and a
	ret nz
	ld [hl], $C0
	inc l
	ld [hl], d
	inc l
	ld [hl], e
	ld a, $05
	ld [$DFE0], a
	ret

; Clears A if it's a solid block that does not have side or top collision,
; but can be stood upon, like a platform
Call_1A6B:: ; 1A6B
	push hl
	push af
	ld b, a
	ldh a, [hWorldAndLevel]
	and a, $F0
	swap a					; just the world
	dec a
	sla a					; times two
	ld e, a
	ld d, $00
	ld hl, .data_1A93		; lookup in table
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]				; load the address in DE
.nextBlock
	ld a, [de]
	cp a, $FD
	jr z, .endOfList
	cp b
	jr z, .match
	inc de
	jr .nextBlock

.endOfList					; no match, don't clear A
	pop af
	pop hl
	ret

.match						; clear A, no collision
	pop af
	pop hl
	xor a
	ret

.data_1A93
	dw .data_1A9D
	dw .data_1AA2
	dw .data_1AA7
	dw .data_1AA9
	dw .data_1AAB

.data_1A9D
	db $68, $69, $6A, $7C, $FD		; "trees" in 1-2 , 7C never seems to appear
.data_1AA2
	db $60, $61, $63, $7C, $FD		; "mountains" in 2-1
.data_1AA7
	db $7C, $FD
.data_1AA9
	db $7C, $FD
.data_1AAB
	db $7C, $FD						; ???? World 5?? Bug?

; detects collision with environment, but only left and right?
Call_1AAD:: ; 1AAD
	ldh a, [hGameState]
	cp a, $0E
	jr nc, .noCollision		; jump if not in "normal gameplay"
	ld de, $0701
	ldh a, [hSuperStatus]
	cp a, $02				; super mario
	jr nz, .checkSide
	ld a, [$C203]			; animation index
	cp a, $18				; crouching mario
	jr z, .checkSide
	ld de, $0702			; E = 2, check lower and upper side
.checkSide
	ld hl, $C201			; Y pos
	ldi a, [hl] 			; The Y pos is about 10 px above Mario's feet
	add d					; so look about 7px lower first iteration?
	ldh [$FFAD], a
	ld a, [$C205]			; dir facing
	ld b, [hl]				; X pos
	ld c, -6				; mario is 12 pixels wide?
	and a
	jr nz, .findTile
	ld c, 6					; 6 pixels to the right if he's facing right
.findTile					; Bug? Mario's X pos is one pixel to the right of 
	ld a, c					; his center, so adding 6 is wrong, asymmetric
	add b					; with subtracting 6
	ld b, a
	ldh a, [hScrollX]
	add b					; add to find X coordinate in tile coordinates
	ldh [$FFAE], a			; used in block detection
	push de
	call Mystery_153		; block finding routine?
	call Call_1A6B			; detect if the block is passthrougable from the side
	pop de
	and a
	jr z, .checkNextTile
	cp a, $60
	jr c, .checkNextTile
	cp a, $F4
	jr z, .touchedCoin
	cp a, $77
	jr z, .touchedSidewaysPipe
	cp a, $F2				; downward fist Genkotsu
	jr z, Jmp_1B45			; ...makes Mario win? Bug? Deleted content?
.stopMario
	ld hl, $C20B			; animation frame counter
	inc [hl]
	ld a, $02
	ld [$C20E], a			; 02 walking, 04 runnning
	ld a, $FF
	ret

.checkNextTile
	ld d, -$4				; if Super Mario, check collision again 4 units higher
	dec e
	jr nz, .checkSide

.noCollision
	xor a
	ret

.touchedCoin
	push hl
	pop de
	ld hl, $FFEE
	ld a, [hl]
	and a
	ret nz					; return if collision already being handled
	ld [hl], $C0			; C0in
	inc l
	ld [hl], d
	inc l
	ld [hl], e				; store block address in FFEF-FFF0
	ld a, $05
	ld [$DFE0], a			; coin sound effect
	xor a
	ret

.touchedSidewaysPipe
	ldh a, [$FFF9]
	and a
	jr z, .stopMario		; do nothing if we're not underground
	ld a, $0B
	ldh [hGameState], a
	ld a, $80
	ld [$C204], a		; mario in control?
	ld hl, $C202		; X pos
	ldd a, [hl]
	add a, $18
	ldh [$FFF8], a		; goal X?
	ld a, [hl]			; Y pos
	and a, $F8			; zero lowest three bits
	add a, $06
	ld [hl], a
	call Call_1ED4		; clears sprites of some sort
	ld a, $FF
	ret

; makes Mario win?
Jmp_1B45:: ; 1B45
	ldh a, [hSuperStatus]
	cp a, $02			; fully grown Super Mario
	ld b, $FF
	jr z, .jmp_1B52
	ld b, $0F
	xor a
	ldh [hSuperStatus], a
.jmp_1B52
	ld a, [$C203]		; animation index
	and b
	ld [$C203], a
	ld b, a
	and a, $0F
	cp a, $0A
	jr nc, .jmp_1B66	; jmp if animation index >= 0A, which is airplane, sub stuff
	ld a, b
	and a, $F0
	ld [$C203], a
.jmp_1B66
	ld a, $07			; end of level with music?
	ldh [hGameState], a
	ld a, [$D007]
	and a
	jr nz, .jmp_1B79
	ld a, $01
	ld [$DFE8], a		; start victory music
	ld a, $F0
	ldh [hTimer], a		; countdown
.jmp_1B79
	call Call_1ED4
	xor a
	ld [$C200], a		; make mario visible again?
	ld [wGameTimerExpiringFlag], a
	ldh [rTMA], a
	ret

; collision with blocks and coins
; called every frame
Call_1B86:: ; 1B86
	xor a
	ld [$C0E2], a
	ldh a, [$FFFE]
	and a
	call nz, AddCoin
	ld hl, $FFEE		; source of the coin? :/
	ld a, [hl]
	cp a, $01			; breakable block which will break
	jr z, .jmp_1BBA
	cp a, $02			; breakable/coin block which will bounce
	jp z, .jmp_1BF7		; why is this a JP? Bug?
	cp a, $C0			; floating coin?
	jr z, .jmp_1BBA
	cp a, $04			; bounced block which will cease to be a sprite
	ret nz
	ld [hl], $00
	inc l				; hl ← FFEF
	ld d, [hl]
	inc l				; hl ← FFF0
	ld e, [hl]			; de ← place in VRAM where the coin was?
	ld a, [wOAMBuffer + $2E]		; coin block OAM sprite 3rd byte?
	cp a, $82			; normal breakable block?
	jr z, .placeBlockBackInBG
	cp a, $81			; coin block
	call z, AddCoin
	ld a, $7F			; dark block (used coinblock)
.placeBlockBackInBG
	ld [de], a
	ret

.jmp_1BBA
	ld b, [hl]
	ld [hl], 0
.jmp_1BBD				; replace coin and breakable block?
	inc l				; hl ← FFEF
	ld d, [hl]
	inc l
	ld e, [hl]			; same as above
	ld a, " "			; empty tile
	ld [de], a			; remove block
	ld a, b
	cp a, $C0
	jr z, .jmp_1BFB		; coin hit?
	ld hl, -$20			; check one tile higher for a coin
	add hl, de
	ld a, [hl]
	cp a, $F4			; coin "$"
	ret nz
	ld [hl], " "		; remove it
	ld a, $05
	ld [$DFE0], a		; todo sound effect
	ld a, h
	ld [$FFB0], a
	ld a, l
	ldh [$FFAF], a
	call Call_3F13
	ldh a, [hScrollX]
	ld b, a
	ldh a, [$FFAE]
	sub b
	ldh [$FFEB], a
	ldh a, [$FFAD]
	add a, $14
	ldh [$FFEC], a
	ld a, $C0
	ldh [$FFED], a
	call AddCoin
	ret

.jmp_1BF7
	ld [hl], $03
	jr .jmp_1BBD

.jmp_1BFB
	call AddCoin
	ret

; add one coin. Earns a life is 100 are collected
AddCoin:: ; 1BFF
	ldh a, [$FF9F]
	and a
	ret nz
	push de
	push hl
	ld de, $0100
	call AddScore
	pop hl
	pop de
	ldh a, [hCoins]
	add a, 1
	daa
	ldh [hCoins], a
	and a
	jr nz, DisplayCoins
	inc a
	ld [wLivesEarnedLost], a		; award a life for collecting 100 coins
DisplayCoins::; 1C1B
	ldh a, [hCoins]
	ld b, a
	and a, $0F
	ld [$982A], a		; coins ones
	ld a, b
	and a, $F0
	swap a
	ld [$9829], a		; coin tens
	xor a
	ldh [$FFFE], a
	inc a
	ld [$C0E2], a
	ret

; 1C33
UpdateLives::
	ldh a, [$FF9F]	; Demo mode?
	and a
	ret nz
	ld a, [wLivesEarnedLost]		; FF removes one life, 
	or a							; any other non-zero value adds one
	ret z
	cp a, $FF			; FF = -1
	ld a, [wLives]
	jr z, .loseLife
	cp a, $99			; Saturate at 99 lives
	jr z, .out
	push af
	ld a, $08
	ld [$DFE0], a
	ldh [$FFD3], a
	pop af
	add a, 1			; Add one life
.displayUpdatedLives
	daa
	ld [wLives], a
.displayLives
	ld a, [wLives]
	ld b, a
	and a, $0F
	ld [$9807], a
	ld a, b
	and a, $F0
	swap a
	ld [$9806], a		; TODO Gives these fellas a name
.out
	xor a
	ld [wLivesEarnedLost], a
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
	jr .displayUpdatedLives

GameState_39::	; 1C7C
	ld hl, $9C00			; todo window tile map?
	ld de, .label_1CD7
	ld b, $11
.loop
	ld a, [de]
	ld c, a
	WAIT_FOR_HBLANK
	WAIT_FOR_HBLANK
	ld [hl], c
	inc l
	inc de
	dec b
	jr nz, .loop
	ld a, $10
	ld [$DFE8], a
	ldh a, [hWorldAndLevel]			; level on which we were? BCD encoded
	ld [wContinueWorldAndLevel], a
	ld a, [wScore + 2]
	and a, $F0				; hundred thousands
	swap a
	ld b, a
	ld a, [wNumContinues]
	add b					; add a continue for every 100k points
	cp a, $0A
	jr c, .nineOrLess
	ld a, 9					; saturates at nine continues
.nineOrLess
	ld [wNumContinues], a
	ld hl, wOAMBuffer
	xor a
	ld b, $A0
.clearOAM
	ldi [hl], a
	dec b
	jr nz, .clearOAM
	ld [wGameTimerExpiringFlag], a
	ldh [rTMA], a
	ld hl, rWY
	ld [hl], $8F
	inc hl					; rWX
	ld [hl], $07			; left edge of the screen
	ld a, $FF
	ldh [$FFFB], a			; probably timer of some sort
	ld hl, hGameState
	inc [hl]				; 39 → 3A
	ret
.label_1CD7:				; TODO one day i gotta name all this text
	db	"     game  over  "

; game over animation and wait until menu
GameState_3A:: ; 1CE8
	ld a, [$C0AD]
	and a
	call nz, GameState_38.resetToMenu
	ret

; prepare time up
GameState_3B:: ; 1CF0
	ld hl, $9C00			; tile map for window
	ld de, .text_1D14
	ld c, 9
.loop
	ld a, [de]
	ld b, a
	WAIT_FOR_HBLANK
	ld [hl], b
	inc l
	inc de
	dec c
	jr nz, .loop	; copy the words "time up" into vram
	ld hl, rLCDC
	set 5, [hl]		; turn on window
	ld a, $A0
	ldh [hTimer], a
	ld hl, hGameState
	inc [hl]		; 3B → 3C
	ret
.text_1D14	; todo
	db " time up "

; time up. Run out frame timer
GameState_3C:: ; 1D1D
	ldh a, [hTimer]
	and a
	ret nz
	ld a, $01;		; dead
	ldh [hGameState], a
	ret

; called every frame
Call_1D26::
	ld hl, $C20D		; mario going left (20) or right (10), changing dir (01)??
	ld a, [hl]
	cp a, $01			; changing direction?
	jr nz, .notReversing
	dec l				; C20C, momentum?
	ld a, [hl]
	and a
	jr nz, .jmp_1D38
	inc l
	ld [hl], $00		; C20D again
	jr .jmp_1D71
.jmp_1D38
	dec [hl]			; decrease C20C, momentum?
	ret
.notReversing
	ld hl, $C20C		; momentum?
	ldi a, [hl]
	cp a, $06			; max momentum
	jr nz, .jmp_1D49
	inc l				; C20E. 02 when walking, 04 when running
	ld a, [hl]
	and a
	jr nz, .jmp_1D49
	ld [hl], $02		; at max momentum, go from 0 to 2?
.jmp_1D49
	ld de, $C207		; jump status. 00 on ground, 01 ascending, 02 descending
	ldh a, [hJoyHeld]
	bit 7, a			; todo constants, down button
	jr nz, .downButton
.jmp_1D52
	bit 4, a			; right button
	jr nz, .rightButton
	bit 5, a			; left button
	jp nz, .leftButton
	ld hl, $C20C		; speed?
	ld a, [hl]
	and a
	jr z, .jmp_1D6B
	xor a				; from here on we have a non-zero speed, and the movement buttons are not pressed. I think
	ld [$C20E], a		; 02 walking 04 running
	dec [hl]
	inc l				; C20B
	ld a, [hl]
	jr .jmp_1D52		; keep checking for left-right keys until C20C is 0
.jmp_1D6B
	inc l				; C20D
	ld [hl], 0
	ld a, [de]
	and a
	ret nz
.jmp_1D71
	ld a, [$C207]		; jump status
	and a
	ret nz				; no animation in the air
	ld hl, $C203		; animation index
	ld a, [hl]
	and a, $F0			; upper nibble is super status
	ld [hl], a			; stand still animation
	ld a, $01
	ld [$C20B], a		; animation frame counter
	xor a
	ld [$C20E], a		; walking nor runnning
	ret
.downButton
	push af
	ldh a, [hSuperStatus]
	cp a, $02			; full grown super mario
	jr nz, .skipCrouch	; small mario can't crouch
	ld a, [de]			; de is C207
	and a
	jr nz, .skipCrouch	; cannot crouch when jumping
	ld a, $18
	ld [$C203], a		; crouching mario, hidden daisy
	ldh a, [hJoyHeld]
	and a, $30			; test bits left and right button
	jr nz, .jmp_1DA6
	ld a, [$C20C]		; momentum?
	and a
	jr z, .jmp_1DA6
.skipCrouch
	pop af
	jr .jmp_1D52		; neither left nor right are being held
.jmp_1DA6
	xor a				; no stopping animation going into crouch?
	ld [$C20C], a		; speed?
	pop af
	ret

.rightButton
	ld hl, $C20D		; walking dir
	ld a, [hl]
	cp a, $20
	jr nz, .skip
	jp .reverseDirection	; too far to do a JR
.skip
	ld hl, $C205		; dir facing
	ld [hl], $00		; facing right
	call Call_1AAD
	and a
	ret nz
.jmp_1DC1
	ldh a, [hJoyHeld]
	bit 4, a			; right
	jr z, .jmp_1DE4
	ld a, [$C203]		; animation index
	cp a, $18			; crouching
	jr nz, .jmp_1DD8
	ld a, [$C203]		; why
	and a, $F0
	or a, $01
	ld [$C203], a		; first animation?
.jmp_1DD8
	ld hl, $C20C		; ...
	ld a, [hl]
	cp a, $06
	jr z, .jmp_1DE4
	inc [hl]			; increase momentum
	inc l				; $C20D left right changing dir
	ld [hl], $10		; going right
.jmp_1DE4
	ld hl, $C202		; on screen X pos
	ldh a, [$FFF9]
	and a
	jr nz, .jmp_1E21
	ld a, [$C0D2]
	cp a, $07
	jr c, .jmp_1DF9
	ldh a, [hScrollX]
	and a, $0C			; %1100
	jr z, .jmp_1E21
.jmp_1DF9
	ld a, $50			; ~ middle of screen
	cp [hl]				; C202?
	jr nc, .jmp_1E21	; JR if mario screen X <= 50
	call .call_1EB4		; determine walking speed
	ld b, a
	ld hl, hScrollX
	add [hl]			; scroll screen if Mario is in the middle
	ld [hl], a
	call .call_1EA4		; shift sprites
	call $2C9F
	ld hl, $C001		; projectile X positions
	ld de, $0004		; 4 bytes per sprite
	ld c, $03			; 3 projectiles
.shiftProjectiles		; todo name
	ld a, [hl]
	sub b
	ld [hl], a
	add hl, de
	dec c
	jr nz, .shiftProjectiles
.jmp_1E1C
	ld hl, $C20B		; frames a dir is held?
	inc [hl]
	ret

.jmp_1E21				; right button held, mario in middle of screen
	call .call_1EB4		; determine walking speed
	add [hl]
	ld [hl], a
	ldh a, [hGameState]
	cp a, $0D			; autoscroll
	jr z, .jmp_1E1C
	ld a, [$C0D2]
	and a
	jr z, .jmp_1E1C
	ldh a, [hScrollX]
	and a, ~%11
	ldh [hScrollX], a
	ld a, [hl]
	cp a, $A0
	jr c, .jmp_1E1C
	jp Jmp_1B45			; huh?

.leftButton
	ld hl, $C20D		; walking dir
	ld a, [hl]
	cp a, $10			; walking right
	jr nz, .jmp_1E61
.reverseDirection
	ld [hl], $01		; reverse dir?
	dec l
	ld [hl], $08		; C20C speed? momentum?
	ld a, [$C207]		; jump status
	and a
	ret nz				; nz if in air
	ld hl, $C203		; animation
	ld a, [hl]
	and a, $F0
	or a, $05			; reversing animation
	ld [hl], a
	ld a, $01
	ld [$C20B], a		; restart animation counter
	ret
.jmp_1E61
	ld hl, $C205		; dir facing
	ld [hl], $20		; facing left
	call Call_1AAD
	and a
	ret nz
	ld hl, $C202		; mario x pos
	ld a, [hl]
	cp a, $0F
	jr c, .jmp_1E9F		; jump if X < 0x0F
	push hl
	ldh a, [hJoyHeld]
	bit 5, a			; todo left button
	jr z, .jmp_1E97
	ld a, [$C203]
	cp a, $18			; crouching
	jr nz, .jmp_1E8B
	ld a, [$C203]
	and a, $F0
	or a, $01
	ld [$C203], a
.jmp_1E8B
	ld hl, $C20C		; speed?
	ld a, [hl]
	cp a, $06
	jr z, .jmp_1E97
	inc [hl]
	inc l				; C20D
	ld [hl], $20		; walking left
.jmp_1E97
	pop hl				; hl = C202, mario's x pos
	call .call_1EB4
	cpl
	inc a
	add [hl]
	ld [hl], a
.jmp_1E9F
	ld hl, $C20B
	dec [hl]
	ret

; subtract B from X coord of sprites 0x0C to 0x14?
.call_1EA4
	ld hl, wOAMBuffer + $C * 4 + 1
	ld de, $0004
	ld c, 8
.loop
	ld a, [hl]
	sub b
	ld [hl], a
	add hl, de
	dec c
	jr nz, .loop
	ret

.call_1EB4
	push de
	push hl
	ld hl, .data_1ECE
	ld a, [$C20E]		; 02 walking 04 running
	ld e, a
	ld d, $00
	ld a, [$C20F]		; 01 standing still, flips between 1 and 0 walking
	xor a, 1
	ld [$C20F], a
	add e
	ld e, a
	add hl, de
	ld a, [hl]
	pop hl
	pop de
	ret

.data_1ECE
	;  0  x  2  x  4  x
	db 0, 1, 1, 1, 1, 2

; Clears sprites 0-3, 7 to 20. Projectiles, fragments of blocks, score
; TODO name
Call_1ED4:: ; 1ED4
	push hl
	push bc
	push de
	ld hl, wOAMBuffer + $7 * 4
	ld b, $D * 4
	xor a
.clearLoop
	ldi [hl], a
	dec b
	jr nz, .clearLoop
	ld hl, wOAMBuffer + 0
	ld b, $0B			; 2 sprites and 3/4th of one ? Bug?
.clearLoop2
	ldi [hl], a
	dec b
	jr nz, .clearLoop2
	ldh [$FFA9], a		; projectile status
	ldh [$FFAA], a
	ldh [$FFAB], a
	ld hl, $C210		; todo with fragments of blocks
	ld de, $0010
	ld b, $04
	ld a, $80
.clearLoop3
	ld [hl], a
	add hl, de
	dec b
	jr nz, .clearLoop3
	pop de
	pop bc
	pop hl
	ret

Call_1F03:: ; 1F03
	ldh a, [hFrameCounter]
	and a, $03
	ret nz				; every 4 frames
	ld a, [wInvincibilityTimer]
	and a
	ret z
	cp a, $01
	jr z, .endOfInvincibility
	dec a
	ld [wInvincibilityTimer], a
	ld a, [$C200]
	xor a, $80			; blink Mario 7.5 times per second
	ld [$C200], a
	ld a, [$DFE9]		; currently playing song
	and a
	ret nz
.endOfInvincibility
	xor a
	ld [wInvincibilityTimer], a
	ld [$C200], a		; mario visible
	call StartLevelMusic
	ret

; called every frame in non autoscroll levels
Call_1F2D:: ; 1F2D
	ld b, $01			; just one superball?
	ld hl, $FFA9		; projectiles at A9, AA and AB?
	ld de, wOAMBuffer + 1 ; sprite 0, X position
.superballLoop
	ldi a, [hl]
	and a
	jr nz, .moveSuperball
.nextSuperball			; XXX more than one? how?
	inc e
	inc e
	inc e
	inc e				; next sprite
	dec b
	jr nz, .superballLoop
	ret

.moveSuperball
	push hl
	push de
	push bc
	dec l				; hl = FFA9
	ld a, [wSuperballTTL]
	and a
	jr z, .removeSuperball
	dec a
	ld [wSuperballTTL], a
	bit 0, [hl]			; going right?
	jr z, .flyingLeft
	ld a, [de]			; X pos
	inc a
	inc a
	ld [de], a			; X → X + 2
	cp a, $A2
	jr c, .detectCollisionRight
.removeSuperball
	xor a
	res 0, e			; Guess they remembered this CPU has bit instructions
	ld [de], a			; a DEC DE would have sufficed
	ld [hl], a
	jr .enemyCollision

.detectCollisionRight
	add a, $03			; check collision a little in front
	push af
	dec e				; e is now the Y coord of the sprite
	ld a, [de]
	ldh [$FFAD], a		; used in collision detection
	pop af
	call FindNeighboringTile
	jr c, .verticalMotion	; c if no collision with solid
	ld a, [hl]
	and a, %11111100
	or a,  %00000010	; reverse direction, go left
	ld [hl], a
.verticalMotion
	bit 2, [hl]			; non zero if going up
	jr z, .flyingDown
	ld a, [de]
	dec a
	dec a
	ld [de], a
	cp a, $10
	jr c, .removeSuperball		; c if out of bounds
	sub a, $01
	ldh [$FFAD], a				; check collision uo
	inc e
	ld a, [de]
	call FindNeighboringTile
	jr c, .enemyCollision		; c if no collision
	ld a, [hl]
	and a, %11110011
	or  a, %00001000	; reverse direction, go down
	ld [hl], a
.enemyCollision
	pop bc
	pop de
	pop hl
	call Call_200A		; collision with enemy?
	jr .nextSuperball

.flyingDown
	ld a, [de]
	inc a
	inc a
	ld [de], a
	cp a, $A8				; todo screen width and such
	jr nc, .removeSuperball	; nc if out of bounds
	add a, $04				; check collision down
	ldh [$FFAD], a
	inc e
	ld a, [de]
	call FindNeighboringTile
	jr c, .enemyCollision		; c if no collision
	ld a, [hl]
	and a, %11110011
	or  a, %00000100	; reverse direction, go up
	ld [hl], a
	jr .enemyCollision

.flyingLeft
	ld a, [de]
	dec a
	dec a
	ld [de], a
	cp a, $04
	jr c, .removeSuperball		; if out of bounds
	sub a, $02			; detect collision to the left
	push af
	dec e
	ld a, [de]
	ldh [$FFAD], a
	pop af
	call FindNeighboringTile
	jr c, .verticalMotion
	ld a, [hl]
	and a, %11111100
	or a,  %00000001	; reverse direction, go right
	ld [hl], a
	jr .verticalMotion

; FFAD is preloaded with the Y coord, A contains X coord
FindNeighboringTile::	; gets called in autoscroll from 514F?
	ld b, a
	ldh a, [hScrollX]
	add b
	ldh [$FFAE], a
	push de
	push hl
	call Mystery_153
	cp a, $F4			; Coin sprite
	jr nz, .checkForBreakableBlock
	ldh a, [hGameState]
	cp a, $0D			; In autoscroll levels, can't collect coins with projectiles
	jr z, .checkForSolidTile
	push hl
	pop de
	ld hl, $FFEE		; collision?
	ld a, [hl]
	and a
	jr nz, .checkForSolidTile
	ld [hl], $C0		; COin?
	inc l
	ld [hl], d
	inc l
	ld [hl], e
	ld a, $05
	ld [$DFE0], a		; coin sound effect
.checkForBreakableBlock
	cp a, $82			; breakable block
	call z, Call_200A.breakBlockInAutoscroll
	cp a, $80			; breakable block
	call z, Call_200A.breakBlockInAutoscroll
.checkForSolidTile
	pop hl
	pop de
	cp a, $60			; every sprite above $60 is solid
	ret

Call_200A::
	push hl
	push de
	push bc
	ld b, $0A
	ld hl, $D100
.enemyLoop				; todo not just enemies?
	ld a, [hl]
	cp a, $FF			; no enemy
	jr nz, .jmp_2029
.nextEnemy
	push de
	ld de, $0010
	add hl, de
	pop de
	dec b
	jr nz, .enemyLoop
	pop bc
	pop de
	pop hl
	ret

.popRegsAndNextEnemy
	pop hl
	pop de
	pop bc
	jr .nextEnemy

.jmp_2029
	push bc
	push de
	push hl
	ld bc, $000A		; lower 7 bits is width + height
	add hl, bc			; platform = B1? some sort of "type" at least
	bit 7, [hl]			; if bit 7 is set, they can't be hit
	jr nz, .popRegsAndNextEnemy
	ld c, [hl]
	inc l
	inc l				; D1XC = health?
	ld a, [hl]
	ldh [$FF9B], a		; more new variables
	ld a, [de]
	ldh [$FFA2], a		; de is still X pos of superball
	add a, $04			; X pos + 4
	ldh [$FF8F], a
	dec e				; y pos
	ld a, [de]
	ldh [$FFA0], a
	ld a, [de]
	add a, $03			; y pos + 3
	ldh [$FFA1], a		; FF8F FFA0 FFA1 FFA2, some sort of hitbox?
	pop hl
	push hl
	call Call_AAF		; hit detection?
	and a
	jr z, .popRegsAndNextEnemy
	dec l
	dec l
	dec l
	call Call_A10
	push de
	ldh a, [hGameState]
	cp a, $0D
	jr nz, .jmp_2064
	call $2AAD
	jr .jmp_2067

.jmp_2064
	call $2A68
.jmp_2067
	pop de
	and a
	jr z, .popRegsAndNextEnemy
	push af
	ld a, [de]
	sub a, $08
	ldh [$FFEC], a			; we seen this before in the coin collision routine
	inc e
	ld a, [de]
	ldh [$FFEB], a
	pop af
	cp a, $FF
	jr nz, .jmp_2083
	ld a, $03
	ld [$DFE0], a			; enemy dieing sound effect
	ldh a, [$FF9E]
	ldh [$FFED], a
.jmp_2083
	xor a
	ld [de], a
	dec e
	ld [de], a
	ld hl, $FFAB
	bit 3, e
	jr nz, .jmp_2094
	dec l
	bit 2, e
	jr nz, .jmp_2094
	dec l
.jmp_2094
	ld [hl], a
	jr .popRegsAndNextEnemy

.breakBlockInAutoscroll
	push hl
	push bc
	push de
	push af
	ldh a, [hGameState]
	cp a, $0D
	jr nz, .out				; only breakable in autoscroll
	push hl
	pop de
	ld hl, $FFEE			; collision?
	ld a, [hl]
	and a
	jr nz, .out
	ld [hl], $01
	inc l					; FFEF
	ld [hl], d
	inc l					; FFF0
	ld [hl], e
	pop af
	push af
	cp a, $80
	jr nz, .jmp_20C1
	ld a, d
	add a, $30
	ld d, a
	ld a, [de]
	and a
	jr z, .jmp_20C1
	call $254D
.jmp_20C1
	ld hl, $C210			; non player entity?
	ld de, $0010
	ld b, $04
.jmp_20C9
	push hl
	ld [hl], $00
	inc l
	ldh a, [$FFAD]			; Y coordinate in VRAM?
	add a, $00
	ld [hl], a
	inc l
	ldh a, [$FFA1]
	add a, $00
	ld [hl], a
	inc l
	inc l
	inc l
	inc l
	inc l
	ld [hl], $01
	inc l
	ld [hl], $07
	pop hl
	add hl, de
	dec b
	jr nz, .jmp_20C9
	ld hl, $C222
	ld a, [hl]
	sub a, $04
	ld [hl], a
	ld hl, $C242
	ld a, [hl]
	sub a, $04
	ld [hl], a
	ld hl, $C238
	ld [hl], $0B
	ld hl, $C248
	ld [hl], $0B
	ldh a, [hScrollX]
	ldh [$FFF3], a
	ld de, $0050
	call AddScore
	ld a, $02
	ld [$DFF8], a
.out
	pop af
	pop de
	pop bc
	pop hl
	ret

Call_2113:: ; 2113
	ldh a, [$FF9F]
	and a
	ret z
	ld a, [$C0DB]
	ldh [hJoyHeld], a
	ret

Data_211D::
	; C200. Mario's position, state, animation etc..
	db $00, $86, $32, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	; C210 - C240. Fragments from breakable block, clouds, Daisy, spaceship
	;       Y    X    sprite    flip           TTL
	db $01, $00, $00, $0F, $00, $00, $00, $00, $00
	ds 7
	db $01, $00, $00, $0F, $00, $20, $00, $00, $00
	ds 7
	db $01, $00, $00, $0F, $00, $00, $00, $00, $00
	ds 7
	db $01, $00, $00, $0F, $00, $20, $00, $00, $00
	ds 7

Data_216D::	 ; jumping "parabola"?
	db $04, $04, $03, $03, $02, $02, $02, $02, $02, $02, $02, $02, $02, $01, $01, $01, $01, $01, $01, $01, $00, $01, $00, $01, $00, $00, $7F

Jump_2188:: ; 2188
	ld a, $03
	ldh [$FFEA], a		; has to do with rendering
	ldh a, [hScrollX]
	ld b, a
	ld a, [$C0AA]		; another scroll thingy, rounded to 8 pxs?
	cp b
	ret z
	xor a
	ldh [$FFEA], a
	ret

Call_2198:: ; 2198
	ldh a, [$FFEA]
	and a
	jr nz, Jump_2188
	ldh a, [hScrollX]
	and a, $08
	ld hl, $FFA3		; switches between 0 and 8
	cp [hl]
	ret nz
	ld a, [hl]
	xor a, $08
	ld [hl], a
	and a
	jr nz, LoadNextColumn
	ld hl, $C0AB		; increments every two columns?
	inc [hl]

; decompress a column from the level
LoadNextColumn::	; 21B1
	ld b, $10			; the screen without hud is exactly 16 tiles high
	ld hl, $C0B0		; tilemap column cache
	ld a, " "			; blank tile
.clearLoop
	ldi [hl], a
	dec b
	jr nz, .clearLoop
	ldh a, [hColumnIndex]
	and a
	jr z, .startNewBlock; if zero, start a new "block" ?
	ldh a, [hColumnPointerHi]	; pointer to next column?
	ld h, a
	ldh a, [hColumnPointerLo]	; eww big endian
	ld l, a
	jr .decodeLoop

.startNewBlock
	ld hl, $4000		; contains a table with 4*3+1 pointers?
	ldh a, [hLevelIndex]; but the levels are spread around over the banks...?
	add a
	ld e, a
	ld d, $00
	add hl, de			; hl = $4000 + level * 2
	ld e, [hl]
	inc hl
	ld d, [hl]
	push de
	pop hl				; hl ← [$4000 + level * 2] ; address of table of blocks
	ldh a, [hLevelBlock]
	add a				; * 2
	ld e, a
	ld d, $00
	add hl, de			; hl ← [hl + block * 2]
	ldi a, [hl]
	cp a, $FF			; end of level?
	jr z, .endOfLevel
	ld e, a				; if not, this is a pointer to the block?
	ld d, [hl]
	push de
	pop hl

.decodeLoop
	ldi a, [hl]
	cp a, $FE
	jr z, .endOfColumn	; $FE = end of column
	ld de, $C0B0
	ld b, a
	and a, $F0			; high nibble = offset into column
	swap a
	add e
	ld e, a
	ld a, b
	and a, $0F			; low nibble = number of tiles following
	jr nz, .skip
	ld a, $10			; if count is zero, fill column
.skip
	ld b, a
.nextRow
	ldi a, [hl]
	cp a, $FD			; FD means fill the rest with the next byte
	jr z, .repeatNextTile
	ld [de], a
	cp a, $70			; pipe?
	jr nz, .notPipe
	call Call_22A9
	jr .incrementRow
.notPipe
	cp a, $80			; breakable block?
	jr nz, .notBreakableBlock
	call Call_2321
	jr .incrementRow
.notBreakableBlock
	cp a, $5F			; hidden block?
	jr nz, .notHiddenBlock
	call Call_2321
	jr .incrementRow
.notHiddenBlock
	cp a, $81			; coin block
	call z, Call_2321
.incrementRow
	inc e
	dec b
	jr nz, .nextRow
	jr .decodeLoop

.endOfLevel
	ld hl, $C0D2		; starts incrementing when the end of level is reached
	inc [hl]
	ret

.endOfColumn
	ld a, h
	ldh [hColumnPointerHi], a
	ld a, l
	ldh [hColumnPointerLo], a		; save a pointer to the next column
	ldh a, [hColumnIndex]
	inc a
	cp a, $14			; 20 columns per block?
	jr nz, .blockNotFinished
	ld hl, hLevelBlock	; next block
	inc [hl]
	xor a
.blockNotFinished
	ldh [hColumnIndex], a
	ldh a, [hScrollX]
	ld [$C0AA], a
	ld a, $01
	ldh [$FFEA], a
	ret

.repeatNextTile
	ld a, [hl]
.loop
	ld [de], a
	inc e
	dec b
	jr nz, .loop
	inc hl
	jp .decodeLoop

; draw a column in the tile map
DrawColumn:: ; 2258
	ldh a, [$FFEA]		; 01 if a new column needs to be loaded, 03 if we're 
	cp a, $01			; still standing on that spot, but we don't need a new 
	ret nz				; one, 00 otherwise. or more complicated...
	ldh a, [$FFE9]		; FFE9 holds the lower byte of the address of the first
	ld l, a				; column not yet loaded. Upper byte is always 98
	inc a
	cp a, $60			; todo constants. VRAM is $60 - $40 tiles wide
	jr nz, .noWrapAround
	ld a, $40
.noWrapAround
	ldh [$FFE9], a
	ld h, $98
	ld de, $C0B0		; the next column is preloaded here by something
	ld b, $10			; 16 tiles high
.nextRow
	push hl
	ld a, h
	add a, $30
	ld h, a
	ld [hl], 0
	pop hl
	ld a, [de]
	ld [hl], a			; set the tile in the tilemap
	cp a, $70			; pipe opening
	jr nz, .notPipe
	call Call_22FD
	jr .incrementRow
.notPipe
	cp a, $80			; breakable block
	jr nz, .notBreakableBlock
	call Call_2363
	jr .incrementRow
.notBreakableBlock
	cp a, $5F			; hidden block
	jr nz, .notHiddenBlock
	call Call_2363
	jr .incrementRow
.notHiddenBlock
	cp a, $81			; coin block
	call z, Call_2363
.incrementRow
	inc e
	push de
	ld de, $0020		; todo screenwidth or w/e
	add hl, de
	pop de
	dec b
	jr nz, .nextRow
	ld a, $02
	ldh [$FFEA], a
	ret

; is there are a warppipe at the column currently being drawn
Call_22A9::
	push hl
	push de
	push bc
	ldh a, [$FFF9]		; $0A in underground?
	and a
	jr nz, .out
	SAVE_AND_SWITCH_ROM_BANK 3
	ldh a, [hLevelIndex]
	add a
	ld e, a
	ld d, $00
	ld hl, $651C		; extract this todo
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	push de
	pop hl				; hl ← [651C + 2 * level]
.checkPipeForWarp
	ldh a, [hLevelBlock]	; first byte is level block of warping pipe
	cp [hl]
	jr z, .matchingLevelBlock
	ld a, [hl]
	cp a, $FF				; ff is end of list
	jr z, .restoreROMBankAndOut
	inc hl
.nextPipe
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	jr .checkPipeForWarp

.matchingLevelBlock
	ldh a, [hColumnIndex]	; second byte is column on which the pipe is
	inc hl
	cp [hl]
	jr nz, .nextPipe
	inc hl
	ld de, $FFF4			; room to which the pipe leads
	ldi a, [hl]
	ld [de], a
	inc e					; FFF5, room where you exit
	ldi a, [hl]
	ld [de], a
	inc e					; FFF6 x position where you leave pipe
	ldi a, [hl]
	ld [de], a
	inc e					; FFF7 y position where you leave pipe
	ld a, [hl]
	ld [de], a
.restoreROMBankAndOut
	RESTORE_ROM_BANK
.out
	pop bc
	pop de
	pop hl
	ret

; hl contains the location in VRAM of the pipe?
Call_22FD::
	ldh a, [$FFF4]	; is non-zero in underground, or when nearing a pipe?
	and a
	ret z
	push hl
	push de
	ld de, -$20
	push af
	ld a, h
	add a, $30		; C8.. is an "overlay" of VRAM, with warps/hidden blocks/...
	ld h, a			; indicated
	pop af
	ld [hl], a
	ldh a, [$FFF5]
	add hl, de
	ld [hl], a
	ldh a, [$FFF6]
	add hl, de
	ld [hl], a
	ldh a, [$FFF7]
	add hl, de
	ld [hl], a
	xor a
	ldh [$FFF4], a
	ldh [$FFF5], a
	pop de
	pop hl
	ret

Call_2321:: ; 2321
	push hl
	push de
	push bc
	SAVE_AND_SWITCH_ROM_BANK 3
	ldh a, [hLevelIndex]
	add a
	ld e, a
	ld d, $00
	ld hl, $6536		; another lookup table
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	push de
	pop hl
.checkBlock
	ldh a, [hLevelBlock]
	cp [hl]
	jr z, .matchingLevelBlock
	ld a, [hl]
	cp a, $FF			; again, end of list
	jr z, .restoreROMBankAndOut
	inc hl
.nextBlock
	inc hl
	inc hl
	jr .checkBlock

.matchingLevelBlock
	ldh a, [hColumnIndex]
	inc hl
	cp [hl]
	jr nz, .nextBlock
	inc hl
	ld a, [hl]
	ld [$C0CD], a		; contents of block
.restoreROMBankAndOut
	RESTORE_ROM_BANK
	pop bc
	pop de
	pop hl
	ret

; stores the content of the block in overlay?
Call_2363:: ; 2363
	ld a, [$C0CD]
	and a
	ret z
	push hl
	push af
	ld a, h
	add a, $30		; again to the C8.. overlay?
	ld h, a
	pop af
	ld [hl], a
	xor a
	ld [$C0CD], a
	pop hl
	ret

; too many calls to far banks
GameState_0D::
INCBIN "baserom.gb", $2376, $2401 - $2376

AnimateBackground::
	ld a, [wBackgroundAnimated]
	and a
	ret z
	ldh a, [hGameState]
	cp a, $0D			; For some reason, the background is only animated
	ret nc				; in gamestates < 0D. This is mostly normal gameplay
	ldh a, [hFrameCounter]
	and a, $07			; Animate every 7 frames
	ret nz
	ldh a, [hFrameCounter]
	bit 3, a
	jr z, .secondFrame
	ld hl, $C600		; copied to here from where?
	jr .copyTile
.secondFrame
	ld hl, Data_3FC4 ; todo
	ldh a, [hWorldAndLevel]
	and a, $F0
	sub a, $10			; A is 8 * (world - 1)
	rrca
	ld d, 0
	ld e, a
	add hl, de
.copyTile
	ld de, $95D1		; only this tile is animated
	ld b, $08
.loop
	ldi a, [hl]
	ld [de], a
	inc de
	inc de				; 1BPP encoded?
	dec b
	jr nz, .loop
	ret

; Levels with or without animated background tile. Pointless
; todo name
Data_2436::
	db 0, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 0

; wBackgroundAnimated is clear. But what are the other variables?
Call_2442::
	ld a, $0C
	ld [$C0AB], a
	call Call_245C
	xor a
	ld [$D007], a
	ld hl, Data_2436
	ldh a, [hLevelIndex]
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hl]
	ld [wBackgroundAnimated], a
	ret

; initializes objects? skips over enemies?
Call_245C::
	ld hl, $401A		; after the level pointers?
	ldh a, [hLevelIndex]
	rlca				; why not ADD A?... Carry will be zero anyway
	ld d, $00
	ld e, a
	add hl, de
	ldi a, [hl]
	ld e, a
	ld a, [hl]			; load address from the table
	ld d, a
	ld h, d
	ld l, e
	ld a, [$C0AB]		; "progress" in level
	ld b, a
.next
	ld a, [hl]			; enemy location?
	cp b
	jr nc, .storeNextEnemy	; todo name
	inc hl
	inc hl
	inc hl
	jr .next

.storeNextEnemy
	ld a, l
	ld [$D010], a
	ld a, h
	ld [$D011], a
	ld hl, $D100		; enemies, powerups, platforms
	ld de, $0010
.loop
	ld [hl], $FF		; disable
	add hl, de
	ld a, l
	cp a, $A0			; clear D100 to D190
	jp nz, .loop		; why JP and nor JR?
	ret

Call_2491:: ; 2491
	call Call_249B
	call $2648
	call $2568
	ret

; spawns enemies?
Call_249B:: ; 249B
	ld a, [$D010]
	ld l, a
	ld a, [$D011]
	ld h, a
	ld a, [hl]		; where next enemy should appear?
	ld b, a
	ld a, [$C0AB]	; progress in columns / 2
	sub b
	ret z
	ret c			; return if we're not there yet
	ld c, a
	swap c			; remember the difference in the hi nibble
	push hl
	inc hl			; Y position of the enemy, in tiles (lowest 5 bits)
	ld a, [hl]
	and a, $1F
	rlca
	rlca
	rlca			; multiply by 8
	add a, $10		; account for HUD
	ldh [$FFC2], a	; enemy buffer?
	ldi a, [hl]		; again Y position
	and a, $C0		; highest 2 bits, X position
	swap a
	add a, $D0		; TODO what's going on here
	sub c
	ldh [$FFC3], a	; future X pos
	call $24EF
	pop hl
	ld de, $0003	; 3 bytes per enemy
	add hl, de		; next one to spawn
	ld a, l
	ld [$D010], a
	ld a, h
	ld [$D011], a
	jr Call_249B

Call_24D6:: ; 24D6

INCBIN "baserom.gb", $24D6, $3D1A - $24D6

; called at level start, is some sort of init
Call_3D1A; 3D1A
	ld hl, $C030	; TODO ? wOAMBuffer + $30 ? used for "dynamic" sprites?
	ld b, $20
	xor a
.jmp_3D20
	ldi [hl], a
	dec b
	jr nz, .jmp_3D20
	ld hl, wGameTimer
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
	ldi [hl], a		; DA1D wGameTimerExpiringFlag
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
	ld a, [wGameTimer]	; Timer subdivision
	cp a, $28			; 40 frames per time unit (why not 60?)
	ret nz
	call .printTimer	; well, that's silly, could've just fallen through. Bug?
	ret
.printTimer ; 3D7E
	ld de, $9833		; TODO VRAM
	ld a, [wGameTimer + 1]	; Ones and Tens
	ld b, a
	and a, $0F
	ld [de], a
	dec e
	ld a, b
	and a, $F0
	swap a
	ld [de], a
	dec e
	ld a, [wGameTimer + 2]	; Hundreds
	and a, $0F
	ld [de], a
	ret

; entering bonus game. Clear the background, and print amount of lives
GameState_12:: ; 3D97
	ld hl, $DFE8
	ld a, $09
	ld [hl], a
	xor a
	ldh [rLCDC], a
	ldh [hScrollX], a
	ld hl, wOAMBuffer
	ld b, $A0
.oamloop			; Remove all sprites
	ldi [hl], a
	dec b
	jr nz, .oamloop
	ld hl, $9800
	ld b, $FF
	ld c, $03
	ld a, " "
.tilemapLoop		; Clear the background
	ldi [hl], a
	dec b
	jr nz, .tilemapLoop
	ld b, $FF
	dec c
	jr nz, .tilemapLoop
	ld de, $988B	; todo
	ld a, [wLives]
	ld b, a
	and a, $0F
	ld [de], a
	dec e
	ld a, b
	and a, $F0
	swap a
	ld [de], a		; Print lives at the appropriate position
	ld a, $83	; todo
	ld [rLCDC], a	; Turn on LCD, background, sprites
	ld a, $13	; todo
	ldh [hGameState], a
	ret

GameState_13:: ; 3DD7
	xor a
	ldh [rLCDC], a
	ld hl, $9800
	ld a, $F5		; Top Left corner
	ldi [hl], a
	ld b, $12		; todo screen width or smth?
	ld a, $9F
.topLoop			; Top border
	ldi [hl], a
	dec b
	jr nz, .topLoop
	ld a, $FC
	ld [hl], a		; Top Right corner
	ld de, $0020	; todo screen width
	ld l, e
	ld b, $10
	ld c, $02
	ld a, $F8
.sideLoop			; Left and right border
	ld [hl], a
	add hl, de
	dec b
	jr nz, .sideLoop
	ld l, $33
	dec h
	dec h
	ld b, $10
	dec c
	jr nz, .sideLoop
	ld hl, $9A20
	ld a, $FF
	ldi [hl], a		; Bottom Left corner
	ld b, $12
	ld a, $9F
.bottomLoop			; Bottom border
	ldi [hl], a
	dec b
	jr nz, .bottomLoop
	ld a, $E9
	ld [hl], a		; Bottom Right corner
	ld hl, $9845
	ld a, "b"
	ldi [hl], a
	ld a, "o"
	ldi [hl], a
	dec a			; n
	ldi [hl], a
	ld a, "u"
	ldi [hl], a
	ld a, "s"
	ldi [hl], a
	inc l			; space
	ld a, "g"
	ldi [hl], a
	ld a, "a"
	ldi [hl], a
	ld a, "m"
	ldi [hl], a
	ld a, "e"
	ld [hl], a		; bonus game
	ld hl, $9887
	ld a, $E4		; mario head
	ldi [hl], a
	inc l
	ld a, "*"
	ld [hl], a
	ld l, $E1
	ld a, $2D
	ld b, $12		; todo screen width?
.topFloor
	ldi [hl], a
	dec b
	jr nz, .topFloor
	ld l, $D1
	ld a, "*"
	ldi [hl], a
	ld l, $41
	inc h
	ld a, $2D
	ld b, $12		; todo
.highMidFloor
	ldi [hl], a
	dec b
	jr nz, .highMidFloor
	ld l, $31
	ld a, "*"
	ldi [hl], a
	ld l, $A1
	ld a, $2D
	ld b, $12		; todo
.lowMidFloor
	ldi [hl], a
	dec b
	jr nz, .lowMidFloor
	ld l, $91
	ld a, "*"
	ldi [hl], a
	ld l, $01
	inc h
	ld a, $2D
	ld b, $12		; todo
.bottomFloor
	ldi [hl], a
	dec b
	jr nz, .bottomFloor
	ld l, $F1
	dec h
	ld a, "*"
	ldi [hl], a
.prizePermutations					; $E5 is a flower
	db 0, 1, 2, $E5, 3, 1, 2, $E5	; These happen to be valid opcodes
	ld de, .prizePermutations		; with no side effects. Neat :) 
	ldh a, [rDIV]
	and a, $03
	inc a				; "Random" number from 1 to 4
.addAtoDE
	inc de
	dec a
	jr nz, .addAtoDE	; No ADD DE, A instruction
	ld hl, $98D2		; First prize
	ld bc, $60			; 3 screen rows
.displayPrize
	ld a, [de]
	ld [hl], a
	inc de
	add hl, bc
	ld a, l
	cp a, $52
	jr nz, .displayPrize
	ld a, $83			; TODO make this a constant
	ldh [rLCDC], a
	ld a, $14
	ldh [hGameState], a
	ret

GameState_16:: ; 3EA7
; draw the ladder
	ld bc, $0020		; todo screen width
.drawLadder
	ld de, $DA23		; TODO name... 4 tile numbers for the ladder
	ld a, [$DA18]		; high bytes of y position of top of ladder
	cp $9A
	jr z, .jmp_3EE0
	ld h, a
	ld a, [$DA19]		; low bytes of y position of top of ladder
	ld l, a
.drawLadderLoop
	ld a, [de]
	ld [hl], a
	inc de
	add hl, bc
	push hl
	ld hl, $DA28		; loop counter?
	dec [hl]
	ld a, [hl]
	pop hl
	and a
	jr nz, .drawLadderLoop
	ld a, 4				; ladder has four segments
	ld [$DA28], a
	push hl
	ld hl, $DA29
	dec [hl]
	ld a, [hl]
	pop hl
	and a
	jr nz, .drawLadder	; why tf are we doing this 3 times?
	ld a, 3
	ld [$DA29], a
.nextState
	ld a, $15
	ldh [hGameState], a
	ret
.jmp_3EE0				; TODO how could this ever get triggered :/
	xor a
	ld [$DA27], a		; ladder position in floors?
	jr .nextState

; Transform mario's pixel coordinates into the block he's currently standing on
Call_3EE6:: ; 3EE6
	ldh a, [$FFAD]		; ~Y coordinate in current level block?
	sub a, $10			; todo mario is 16 pixels tall?
	srl a
	srl a
	srl a				; divide by 8, the number of pixels per tile
	ld de, $0000
	ld e, a
	ld hl, $9800
	ld b, $20			; todo screen width
.loopY
	add hl, de
	dec b				; would make more sense to loop on a
	jr nz, .loopY
	ldh a, [$FFAE]		; ~X coordinate in current level block
	sub a, $08			; mario stands on the middle of his 16 pixel wide body?
	srl a
	srl a
	srl a
	ld de, $0000
	ld e, a
	add hl, de
	ld a, h				; "Y"
	ldh [$FFB0], a
	ld a, l				; "X"
	ldh [$FFAF], a		; we've seen these before
	ret

; called when mario hits a block that "moves" up and down
; FFB0 and FFAF now seem to contain the block above him?
; FFAD and FFAE now seem to determine where the block-sprite spawns...
Call_3F13::	; 3F13
	ldh a, [$FFB0]		; hey look at that. goes from 98 to ~9B
	ld d, a
	ldh a, [$FFAF]		; 00 to FF?
	ld e, a
	ld b, 4
.loop					; rr uses carry, used for a 16 bit shift by 4
	rr d
	rr e
	dec b
	jr nz, .loop
	ld a, e				; contains 2nd and 3rd nibble of the tile index
	sub a, $84			; 9840 is the top of the screen?
	and a, $FE			; ignore middle bit because mario is two tiles wide??
	rlca
	rlca
	add a, $08
	ldh [$FFAD], a		; override mario's y-coordinate?
	ldh a, [$FFAF]
	and a, $1F
	rla
	rla
	rla
	add a, $08
	ldh [$FFAE], a		; or maybe it's used for the block
	ret

; Display the score at wScore to the top right corner
DisplayScore:: ; 3F39
	ldh a, [$FFB1]	; Some check to see if the score needs to be  
	and a				; updated?
	ret z
	ld a, [$C0E2]
	and a
	ret nz
	ldh a, [$FFEA]
	cp a, 02
	ret z
	ld de, wScore + 2	; Start with the ten and hundred thousands
	ld hl, $9820		; TODO VRAM layout
PrintScore::
; Displays BCD encoded score at DE, DE-1 and DE-2 to the VRAM at HL
; Print spaces instead of leading zeroes TODO Reuses FFB1?
	xor a
	ldh [$FFB1], a	; Start by printing spaces instead of leading zeroes
	ld c, $03			; Maximum 3 digit pairs
.printDigitPair
	ld a, [de]
	ld b, a
	swap a				; Start with the more significant digit
	and a, $0F
	jr nz, .startNumber1
	ldh a, [$FFB1]	; If it's zero, check if the number has already started
	and a
	ld a, "0"
	jr nz, .printFirstDigit
	ld a, " "			; If not, start with spaces, not leading zeroes
.printFirstDigit
	ldi [hl], a			; Place the digit or space in VRAM
	ld a, b				; Now the lesser significant digit
	and a, $0F
	jr nz, .startNumber2; If non-zero, number has started (or already is)
	ldh a, [$FFB1]
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
	ldh [$FFB1], a
	ret

.startNumber1
	push af
	ld a, 1
	ldh [$FFB1], a	; Number has started, print "0" instead of " "
	pop af
	jr .printFirstDigit

.startNumber2
	push af
	ld a, 1
	ldh [$FFB1], a	; Number has started, print "0" instead of " "
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
DMARoutineEnd

; TODO Give this a name
db "mario*    world time"
db "       $*   1-1  000"

; TODO contains the flickering candle from world 1-3, the waves from 2-1
; maybe more animated sprites. 1BPP encoded?
; TODO put these in files
Data_3FC4::
	db $00, $00, $00, $10, $38, $38, $28, $10
	db $00, $E0, $B1, $5B, $FF, $FF, $FF, $FF
	db $7E, $3C, $18, $00, $00, $81, $42, $A5
	db $00, $E1, $33, $DE, $FF, $E7, $DB, $FF

	ds 26

	db $D3	; ....

	ds 1

SECTION "bank1", ROMX, BANK[1]
INCBIN "baserom.gb", $4000, $4000

SECTION "bank2", ROMX, BANK[2]
INCBIN "baserom.gb", $8000, $4000

SECTION "bank3", ROMX, BANK[3]
INCBIN "baserom.gb", $C000, $4000

