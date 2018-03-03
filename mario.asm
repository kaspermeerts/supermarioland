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
.waitHBlank
	ldh a, [rSTAT]
	and a, $03
	jr nz, .waitHBlank
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
	call call_3EE6
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
	call $09F1			; kill mario with an animation?
	call $1736
.jmp_238
	ldh a, [$FF00+$FD]	; Again, ROM bank?
	ldh [$FF00+$E1], a	; temporarily store for some reason
	ld a, 3
	ldh [$FF00+$FD], a
	ld [MBC1RomBank], a
	call $47F2			; Determines pressed buttons (FF80) and new buttons (FF81)
	ldh a, [$FF00+$E1]	; TODO probably the rom for the tiles of this level?
	ldh [$FF00+$FD], a	; another bank switch
	ld [MBC1RomBank], a
	ldh a, [$FF00+$9F]	; Demo mode?
	and a
	jr nz, .jmp_25A
	call pauseOrReset
	ldh a, [hGamePaused]
	and a
	jr nz, .halt
.jmp_25A
	ld hl, $FFA6		; General purpose state counter?
	ld b, 2
.next
	ld a, [hl]
	and a
	jr z, .skip
	dec [hl]			; FFA{6,7} are timers for frame based animations
.skip
	inc l
	dec b
	jr nz, .next
	ldh a, [$FF00+$9F]	; Equal to 28 in menu and during demo
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
	ldh [$FF00+$FD], a
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
dw $06DC ; 0x02   Reset to checkpoint
dw $0B8D ; 0x03   Pre dying
dw $0BD6 ; 0x04   Dying animation
dw $0C73 ; 0x05   Explosion/Score counting down
dw $0CCB ; 0x06   End of level
dw $0C40 ; 0x07   End of level gate, music
dw $0D49 ; 0x08 ✓ Increment Level, load tiles
dw $161B ; 0x09   Going down a pipe
dw $162F ; 0x0A   Warping to underground?
dw $166C ; 0x0B   Going right in a pipe
dw $16DA ; 0x0C   Going up out of a pipe
dw $2376 ; 0x0D   Auto scrolling level
dw $0322 ; 0x0E ✓ Init menu
dw $04C3 ; 0x0F ✓ Start menu
dw $05CE ; 0x10  
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
dw $0DF9 ; 0x1B   Leaving Bonus game
dw $0E15 ; 0x1C   Smth with the gate after a boss
dw $0E31 ; 0x1D  
dw $0E5D ; 0x1E   Gate opening
dw $0E96 ; 0x1F   Gate open
dw $0EA9 ; 0x20   Walk off button
dw $0ECD ; 0x21   Mario offscreen
dw $0F12 ; 0x22   Scroll to fake Daisy
dw $0F33 ; 0x23   Walk to fake Daisy
dw $0F6A ; 0x24   Fake Daisy speak
dw $0FFD ; 0x25   Fake Daisy morphing
dw $1055 ; 0x26   Fake Daisy monster jumping away
dw $1099 ; 0x27   Tatanga dying
dw $0EA9 ; 0x28   Tatanga dead, plane moves forward
dw $1116 ; 0x29  
dw $1165 ; 0x2A   Daisy speaking
dw $1194 ; 0x2B   Daisy moving
dw $11D0 ; 0x2C   Daisy kissing
dw $121B ; 0x2D   Daisy quest over
dw $1254 ; 0x2E   Mario credits running
dw $12A1 ; 0x2F   Entering airplane
dw $12C2 ; 0x30   Airplane taking off
dw $12F1 ; 0x31   Airplane moving forward
dw $138E ; 0x32   Airplane leaving hanger?
dw $13F0 ; 0x33   In between two credits?
dw $1441 ; 0x34   Credits coming up
dw $145A ; 0x35   Credits stand still
dw $1466 ; 0x36   Credits leave
dw $1488 ; 0x37   Airplane leaving
dw $14DC ; 0x38   THE END letters flying
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
	ldh [$FF00+$A4], a	; smth to do with the map scrolling
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
	call FillTileMapWithEmptyTile
	xor a
	ldh [$FF00+$E5], a	; Level block TODO
	ldh a, [$FF00+$E4]
	push af
	ld a, $0C
	ldh [$FF00+$E4], a
	call call_807			; Draw level into tile map TODO based on FFE4?
	pop af
	ldh [$FF00+$E4], a
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

; 450
GameState_0F::
.startPressed
	ld a, [wOAMBuffer + 4]
	cp a, $78	; usual start Y position
	jr z, .dontContinue
	ld a, [wNumContinues]	; if not, use up a continue
	dec a
	ld [wNumContinues], a
	ld a, [$C0A8]			; TODO BCD level on which you game overed?
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
	ldh a, [$FFFD]
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
	call call_5E7	; todo
	call FillTileMapWithEmptyTile
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
	call $2442			; superfluous? happens in GameState_08.loadWorldTiles?
	call call_3D1A		; todo
	call DisplayCoins
	call UpdateLives.displayLives
	ldh a, [hWorldAndLevel]
	call GameState_08.loadWorldTiles
	ret

FillTileMapWithEmptyTile:: ; 05CF  What a waste
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

; 5E7
; prepare tiles
call_5E7::	; the three upper banks have tiles at the same location?
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
	ld hl, $FFA6	; definitely a counter or timer
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

; lots of calls to other banks. Later
Gamestate_02::
INCBIN "baserom.gb", $06DC, $07DA - $06DC

pauseOrReset::
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
call_807::
	ld hl, $211D
	ld de, $C200
	ld b, $51
.copyLoop				; some sort of initialisation
	ldi a, [hl]
	ld [de], a
	inc de
	dec b				; What's the point of a CopyData routine,
	jr nz, .copyLoop	; if you're not going to fucking use it
	ldh a, [hSuperStatus]
	and a
	jr z, .smallMario
	ld a, $10
	ld [$C203], a		; animation index. upper nibble is 1 of large mario
.smallMario				; does weird things in autoscroll
	ld hl, $FFE6
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
	ldh a, [hLevelIndex]		; current level or smth
	cp a, $0C			; start menu doesn't scroll
	jr z, .drawLoop
	ld b, $1B			; load 27 tiles (20 visible, 7 preloaded)
.drawLoop
	push bc
	call $21B1			; load a column of the level into C0B0
	call $2258			; draw it onscreen
	pop bc
	dec b
	jr nz, .drawLoop
	ret

INCBIN "baserom.gb", $84E, $D39 - $84E

GameState_08::
.world1Tiles
	di
	ld a, c
	ld [MBC1RomBank], a
	ldh [$FFFD], a	; todo
	xor a
	ldh [rLCDC], a		; turn off LCD
	call call_5E7		; again? why????
	jp .out
.entryPoint:: ; D49
	ld hl, $FFA6		; timer thingy
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
	ldh [$FFFD], a ; todo
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
	ldh [$FFE5], a
	xor a
	ld [$C0D2], a
	ldh [$FFF9], a
	ld a, $02
	ldh [hGameState], a
	call $2442
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

INCBIN "baserom.gb", $E15, $1BFF - $E15


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
	ldh a, [$FF00+$9F]	; Demo mode?
	and a
	ret nz
	ld a, [wLivesEarnedLost]		; FF removes one life, 
	or a							; any other non-zero value adds one
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
.displayUpdatedLives
	daa
	ld [wNumLives], a
.displayLives
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
.waitHBlank1
	ldh a, [rSTAT]
	and a, $03
	jr nz, .waitHBlank1
.waitHBlank2
	ldh a, [rSTAT]
	and a, $03
	jr nz, .waitHBlank2
	ld [hl], c
	inc l
	inc de
	dec b
	jr nz, .loop
	ld a, $10
	ld [$DFE8], a
	ldh a, [hWorldAndLevel]			; level on which we were? BCD encoded
	ld [$C0A8], a			; level on which game overed?
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
	ld [$DA1D], a			; has to do with time up
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
	call nz, $1530			; TODO
	ret

; prepare time up
GameState_3B:: ; 1CF0
	ld hl, $9C00			; tile map for window
	ld de, .data_1D14
	ld c, 9
.loop
	ld a, [de]
	ld b, a
.waitHBlank
	ldh a, [rSTAT]
	and a, $03
	jr nz, .waitHBlank
	ld [hl], b
	inc l
	inc de
	dec c
	jr nz, .loop	; copy the words "time up" into vram
	ld hl, rLCDC
	set 5, [hl]		; turn on window
	ld a, $A0
	ldh [$FFA6], a		; definitely some sort of counter
	ld hl, hGameState
	inc [hl]		; 3B → 3C
	ret
.data_1D14
	db " time up "

GameState_3C:: ; 1D1D
	ldh a, [$FFA6]
	and a
	ret nz
	ld a, $01;		; dead
	ldh [hGameState], a
	ret

INCBIN "baserom.gb", $1D26, $2401 - $1D26

AnimateBackground::
	ld a, [$D014] 		; boolean?
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
Data_2436::
	db 0, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 0

INCBIN "baserom.gb", $2442, $3D1A - $2442

; called at level start, is some sort of init
call_3D1A; 3D1A
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

GameState_12::
; entering bonus game. Clear the background, and print amount of lives
	ld hl, $DFE8
	ld a, $09
	ld [hl], a
	xor a
	ldh [rLCDC], a
	ldh [$FFA4], a
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
	ld a, [wNumLives]
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

GameState_13::
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

GameState_16::
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
call_3EE6:: ; 3EE6
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
call_3F13::
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

