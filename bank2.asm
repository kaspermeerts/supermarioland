INCLUDE "charmap.asm"
INCLUDE "gbhw.asm"

SECTION "bank 2", ROMX, BANK[2]
LevelPointersBank2:: ; 2:4000
	dw $6192	; 1-1
	dw $61B7	; 1-2
	dw $61DA	; 1-3
	dw $6192
	dw $61B7
	dw $61DA
	dw $6192
	dw $61B7
	dw $61DA
	dw $6192
	dw $61B7
	dw $61DA
	dw $6190	; Start Menu

LevelEnemyPointersBank2:: ; 2:401A
	dw $6002	; 1-1
	dw $6073	; 1-2
	dw $60FE	; 1-3
	dw $6002
	dw $6073
	dw $60FE
	dw $6002
	dw $6073
	dw $60FE
	dw $6002
	dw $6073
	dw $60FE

INCBIN "gfx/commonTiles1.2bpp"
INCBIN "gfx/enemiesWorld1.2bpp"
INCBIN "gfx/commonTiles2.2bpp"
INCBIN "gfx/backgroundWorld1.2bpp"
INCBIN "gfx/commonTiles3.2bpp"

; 5832
; Bonus game GameState routines
; No idea why this level of indirection
GameState_14:: ; 5832
	jp _GameState_14
GameState_15:: ; 5835
	jp _GameState_15
GameState_17:: ; 5838
	jp _GameState_17
GameState_18:: ; 583B
	jp _GameState_18
GameState_19:: ; 583E
	jp _GameState_19
GameState_1A:: ; 5841
	jp _GameState_1A

; why
UpdateTimerAndFloaties:: ; 5844
	call UpdateGameTimer
	call UpdateFloaties
	ret

; Make the Timer count down. The logic in this routine is unnecessarily
; convoluted. Bug
UpdateGameTimer:: ; 584B
	ld a, [wGameTimerExpiringFlag]
	cp a, 3
	ret z
	ld hl, wGameTimer
	ld a, [hl]
	dec a				; decrement the unseen "hundredths" counter
	ld [hl], a
	ret nz
	ld a, $28			; 40 frames per tick, 2/3rd second. Why not 60?
	ld [hl], a
	inc hl
	ldi a, [hl]			; ones and tens
	ld c, [hl]			; hundreds
	dec hl
	sub a, 1
	daa
	ldi [hl], a
	cp a, $99
	jr nz, .checkTimerExpiration
	dec c				; decrement one from the hundreds
	ld a, c
	ld [hl], a
	ret

.checkTimerExpiration	; called almost every frame. Ridiculous, bug
	ld hl, wGameTimerExpiringFlag
	cp a, $50
	jr z, .checkIfUnder50
	and a
	ret nz
	or c
	jr nz, .checkIfUnder100
	ld a, 3
	ld [hl], a
	ret

.checkIfUnder50
	ld a, c
	and a
	ret nz
	ld a, 2
	ld [hl], a
	ld a, $50
	ldh [rTMA], a		; speed up timer, speeds up music
	ret

.checkIfUnder100
	ld a, c
	cp a, $01
	ret nz
	ld a, 1
	ld [hl], a
	ld a, $30
	ldh [rTMA], a		; speed up timer
	ret

UpdateFloaties:: ; 5892
	ldh a, [hFloatyControl]
	ld b, a
	and a					; if non zero, spawn a new floaty
	jp z, .updateFloaties
	ld a, [wNextFloatyOAMIndex]
	ld l, a
	ld h, HIGH(wOAMBuffer)
	ld de, $8				; two objects per floaty
	push hl
	add hl, de
	ld a, l
	ld [wNextFloatyOAMIndex], a
	cp a, $50				; Four slots are used: 30 - 38 - 40 - 48
	jr nz, .initFloatyParameters
	ld a, $30
	ld [wNextFloatyOAMIndex], a
.initFloatyParameters
	pop hl
	ld c, $20				; default floaty TTL is 20 times 2 frames
	ld d, $F6				; only used for the coin?
	ld a, l
	cp a, $30
	jr nz, .checkFloaty1
	ld a, c
	ld [wFloaty0_TTL], a
	ld a, d
	ld [wFloaty0_SpriteIfCoin], a
	ld a, b
	cp a, $C0
	jr nz, .setupCoordinates
	ld [wFloaty0_IsCoin], a
	jr .setupCoordinates

.checkFloaty1
	cp a, $38
	jr nz, .checkFloaty2
	ld a, c
	ld [wFloaty1_TTL], a
	ld a, d
	ld [wFloaty1_SpriteIfCoin], a
	ld a, b
	cp a, $C0
	jr nz, .setupCoordinates
	ld [wFloaty1_IsCoin], a
	jr .setupCoordinates

.checkFloaty2
	cp a, $40
	jr nz, .checkFloaty3
	ld a, c
	ld [wFloaty2_TTL], a
	ld a, d
	ld [wFloaty2_SpriteIfCoin], a
	ld a, b
	cp a, $C0
	jr nz, .setupCoordinates
	ld [wFloaty2_IsCoin], a
	jr .setupCoordinates

.checkFloaty3
	ld a, c
	ld [wFloaty3_TTL], a
	ld a, d
	ld [wFloaty3_SpriteIfCoin], a
	ld a, b
	cp a, $C0
	jr nz, .setupCoordinates
	ld [wFloaty3_IsCoin], a
.setupCoordinates
	ldh a, [hFloatyY]
	ldi [hl], a			; OAM Y
	ldh a, [hFloatyX]
	ldi [hl], a			; OAM X
	ld a, b
	ld de, $5958		;  1 00
	cp a, $01
	jr z, .setupTiles
	inc d			; 6058  2 00
	cp a, $02
	jr z, .setupTiles
	inc d			; 6158  4 00
	cp a, $04
	jr z, .setupTiles
	inc d			; 6258  5 00
	cp a, $05
	jr z, .setupTiles
	inc d			; 6358  8 00
	cp a, $08
	jr z, .setupTiles
	ld d, $59
	dec e			; 5957 10 00
	cp a, $10
	jr z, .setupTiles
	inc d			; 5A57 20 00
	cp a, $20
	jr z, .setupTiles
	inc d			; 5B57 40 00
	cp a, $40
	jr z, .setupTiles
	inc d			; 5C57 50 00
	cp a, $50
	jr z, .setupTiles
	inc d			; 5D57 80 00
	cp a, $80
	jr z, .setupTiles
	inc d			; 5E57 80 00
	ld e, $5F		; 5E5F  1UP
	cp a, $FF
	jr z, .setupTiles
	ld de, $F6FE	; F6FE coin sprite
.setupTiles
	ld a, d			; left object
	ldi [hl], a
	inc hl
	ldh a, [hFloatyY]
	ldi [hl], a
	ldh a, [hFloatyX]
	add a, $8		; one tile to the right
	ldi [hl], a
	ld a, e			; right object
	ld [hl], a
	xor a
	ldh [hFloatyControl], a
	ldh [hFloatyY], a
	ldh [hFloatyX], a
	ld a, b			; floaty control
	ld de, $0100	;  100
	cp a, $01
	jr z, .addFloatyScore
	inc d			;  200
	cp a, $02
	jr z, .addFloatyScore
	inc d
	inc d			;  400
	cp a, $04
	jr z, .addFloatyScore
	inc d			;  500
	cp a, $05
	jr z, .addFloatyScore
	ld d, $08		;  800
	cp a, $08
	jr z, .addFloatyScore
	ld d, $10		; 1000
	cp a, $10
	jr z, .addFloatyScore
	ld d, $20		; 2000
	cp a, $20
	jr z, .addFloatyScore
	ld d, $40		; 4000
	cp a, $40
	jr z, .addFloatyScore
	ld d, $50		; 5000
	cp a, $50
	jr z, .addFloatyScore
	ld d, $80		; 8000
	cp a, $80
	jr z, .addFloatyScore
	jr .updateFloaties

.addFloatyScore
	call AddScore
.updateFloaties
	ld hl, wOAMBuffer + $30
.updateFloaty
	push hl
	ld a, [hl]
	and a
	jp z, .nextFloaty
	ld a, l
	ld bc, wFloaty3_TTL
	ld de, wFloaty3_SpriteIfCoin
	ld hl, $DA13
	cp a, $48
	jr z, .moveFloaty3
	dec c
	dec e
	dec l
	cp a, $40
	jr z, .moveFloaty2
	dec c
	dec e
	dec l
	cp a, $38
	jr z, .moveFloaty1
	dec c
	dec e
	dec l
.moveFloaty0			; unused jump
	ld a, [wFloaty0_IsCoin]
	cp a, $C0
	jr z, .moveFloaty
	ld a, [hl]
	inc a
	ld [hl], a
	cp a, $02
	jp nz, .nextFloaty
	xor a
	ld [hl], a
	jr .moveFloaty

.moveFloaty1
	ld a, [wFloaty1_IsCoin]
	cp a, $C0
	jr z, .moveFloaty
	ld a, [hl]
	inc a
	ld [hl], a
	cp a, $02
	jp nz, .nextFloaty
	xor a
	ld [hl], a
	jr .moveFloaty

.moveFloaty2
	ld a, [wFloaty2_IsCoin]
	cp a, $C0
	jr z, .moveFloaty
	ld a, [hl]
	inc a
	ld [hl], a
	cp a, $02
	jr nz, .nextFloaty
	xor a
	ld [hl], a
	jr .moveFloaty

.moveFloaty3
	ld a, [wFloaty3_IsCoin]
	cp a, $C0
	jr z, .moveFloaty
	ld a, [hl]
	inc a
	ld [hl], a
	cp a, $02
	jr nz, .nextFloaty
	xor a
	ld [hl], a
.moveFloaty
	pop hl
	push hl
	dec [hl]		; Y pos, one pixel up
	inc l
	inc l
	inc l
	inc l
	dec [hl]		; move up second sprite
	dec l
	dec l
	ld a, [hl]		; todo unentangle this logic
	cp a, $F6		; first coin sprite
	jr c, .decrementTTL
	ld a, [de]		; wFloatyN_SpriteIfCoin
	inc a
	ld [de], a
	ld [hl], a
	cp a, $F9		; one more than the last coin sprite
	jr c, .decrementTTL
	dec a
	dec a
	ld [hl], a
	cp a, $F7
	jr z, .decrementTTL
	dec a
	dec a
	ld [de], a
	ld [hl], a
.decrementTTL
	ld a, [bc]		; wFloatyN_TTL
	dec a
	ld [bc], a
	jr nz, .nextFloaty
	ld a, $20		; reset floaty
	ld [bc], a
	ld a, $F6
	ld [de], a
	xor a			; hide objects
	ldd [hl], a		; object tile
	ldd [hl], a		; object X pos
	ldi [hl], a		; object Y pos
	inc l
	inc l
	inc l
	ldi [hl], a		; Y pos
	ldi [hl], a		; X pos
	ld [hl], a		; tile number
	ld a, l
	ld hl, wFloaty0_IsCoin
	ld bc, $0004
	cp a, $36
	jr z, .resetCoinStatus
	inc l
	cp a, $3E
	jr z, .resetCoinStatus
	inc l
	cp a, $46
	jr z, .resetCoinStatus
	inc l
.resetCoinStatus
	xor a
	ld [hl], a		; wFloatyN_IsCoin
	add hl, bc
	ld [hl], a		; wFloatyN_?
.nextFloaty
	pop hl
	ld de, $0008
	add hl, de
	ld a, l
	cp a, $50
	jp nz, .updateFloaty
	ret

; setup Mario's sprite in OAM
_GameState_14:: ; 5A72
	ld hl, wOAMBuffer + 4*$C
	ldh a, [rDIV]
	and a, $3
	inc a
	ld b, a
	ld a, $20
.loop
	add a, $18
	dec b
	jr nz, .loop		; A = $20 + $18 * rand(1,4)
	ld b, a
	ldi [hl], a		; Y pos
	ld a, $10
	ld c, a
	ldi [hl], a		; X pos
	xor a
	ld d, a
	ldh a, [hSuperStatus]
	cp a, $02
	jr nz, .jmp_5A93
	ld a, $20
	ld d, a
.jmp_5A93
	ld a, d
	ldi [hl], a		; tile number
	inc l			; no attributes
	ld a, b
	ldi [hl], a		; Y pos
	ld a, c
	add a, $08		; one to the right
	ldi [hl], a		; X pos
	ld a, d
	inc a
	ldi [hl], a		; tile number
	inc l			; no attributes
	ld a, b
	add a, $08		; one down
	ld b, a
	ldi [hl], a		; Y pos
	ld a, c
	ldi [hl], a		; X pos
	ld a, d
	add a, $10
	ld d, a
	ldi [hl], a		; tile number
	inc l			; no attributes
	ld a, b
	ldi [hl], a		; Y pos
	ld a, c
	add a, $08		; one to the right
	ldi [hl], a		; X pos
	inc d
	ld a, d
	ld [hl], a		; tile number
	ld a, $15
	ldh [hGameState], a
	ret

_GameState_15:: ; 5ABB
	ld a, [$DA27]	; ladder status?
	bit 0, a
	jr z, .jmp_5AC9
	ldh a, [hJoyHeld]
	bit 0, a		; A button todo
	jp nz, .jmp_5B56
.jmp_5AC9
	ld hl, wBonusGameFrameCounter
	ld a, [hl]
	inc a
	ld [hl], a
	cp a, 3			; animate every 3 frames
	ret nz
	xor a
	ld [hl], a
	ld a, [$DA27]
	bit 0, a
	jr z, .jmp_5B07
	ld hl, wOAMBuffer + 4*$C
	ld b, $04
	ld a, [hl]		; Y pos
	cp a, $80		; bottom floor
	jr z, .jmp_5AF1
.loop1
	ld a, $18
	add [hl]		; down 3 tiles
	ldi [hl], a
	inc l
	inc l
	inc l
	dec b
	jr nz, .loop1
	jr .jmp_5B07

.jmp_5AF1
	ld b, $02		; 2 bottom objects
	ld a, $38		; top floor
.loop2
	ldi [hl], a
	inc l
	inc l
	inc l
	dec b
	jr nz, .loop2
	ld b, $02		; 2 top objects
	ld a, $40
.loop3
	ldi [hl], a
	inc l
	inc l
	inc l
	dec b
	jr nz, .loop3
.jmp_5B07
	ld hl, $98EA	; ladder top floor position
	ld bc, $0060	; 3 screen widths
	ld de, $DA27
	ld a, [de]
	inc a
	ld [de], a
	cp a, $03
	jr c, .jmp_5B27
	add hl, bc
	cp a, $05
	jr c, .jmp_5B27
	add hl, bc
	cp a, $07
	jr c, .jmp_5B27
	ld hl, $98EA
	xor a
	inc a
	ld [de], a
.jmp_5B27
	ld a, h
	ld [wLadderLocationHi], a
	ld a, l
	ld [wLadderLocationLo], a
	ld hl, wLadderTiles
	ld a, [de]
	bit 0, a
	jr z, .jmp_5B45
	ld a, $2E
	ldi [hl], a
	ld a, $2F
	ldi [hl], a
	ld a, $2F
	ldi [hl], a
	ld a, $30
	ld [hl], a
	jr .jmp_5B51

.jmp_5B45
	ld a, $2D
	ldi [hl], a
	ld a, $2C
	ldi [hl], a
	ld a, $2C
	ldi [hl], a
	ld a, $2D
	ld [hl], a
.jmp_5B51
	ld a, $16
	ldh [hGameState], a
	ret

.jmp_5B56
	xor a
	ld [$DA22], a
	ld [$DA27], a
	ld [$DA1A], a
	ld a, $17
	ldh [hGameState], a
	ret

_GameState_17:: ; 5B65
	ld hl, $DA1C			; 1 if walking
	ld a, [hl]
	and a
	jr nz, .jmp_5B73
	inc [hl]				; start walking
	ld hl, $DFE8
	ld a, $0A				; walking music
	ld [hl], a
.jmp_5B73
	ld hl, wOAMBuffer + 4*$C + 1	; X pos
	ld de, $5C9D			; todo
	ld b, $04
	ld a, [$DA14]			; animation index
	and a
	jr z, .objectLoop		; Tssk
.loop
	inc de
	dec a
	jr nz, .loop			; "ADD DE, A"
.objectLoop
	inc [hl]				; move one pixel forwards
	inc l
	ld a, [de]
	ld c, a
	cp a, $FF				; end of animation, restart
	jr nz, .checkSuper
	ld de, $5C9D			; End of animation, restart
	xor a
	ld [$DA14], a
	ld a, [de]
	ld c, a
.checkSuper
	ldh a, [hSuperStatus]
	cp a, $02
	jr nz, .loadTileNumber
	ld a, c
	add a, $20				; The corresponding tile for Super Mario is always $20
	ld c, a					; tiles further
.loadTileNumber
	ld a, c
	ldi [hl], a				; tile number
	inc de
	inc l
	inc l
	dec b
	jr nz, .objectLoop
	ld a, [$DA14]
	add a, $04
	ld [$DA14], a
	ld hl, wOAMBuffer + 4*$C + 1
	ldd a, [hl]
	cp a, $80
	jr nc, .getPrize
	add a, $04
	ldh [$FFAE], a
	ld a, [hl]
	add a, $10
	ldh [$FFAD], a
	ld bc, $DA16
	ld a, [bc]
	dec a
	ld [bc], a
	ret nz
	ld a, $01
	ld [bc], a
	call LookupTile
	ld a, [hl]
	cp a, $2E			; ladder top
	jr z, .goDownLadder
	cp a, $30
	jr z, .goUpLadder
	ret

.goDownLadder
	ld a, $18
	ldh [hGameState], a
	ret

.goUpLadder
	ld a, $19
	ldh [hGameState], a
	ret

.getPrize
	xor a
	ld [$DA1C], a
	ld a, $1A
	ldh [hGameState], a
	ret

_GameState_18:: ; 5BEB
	ld hl, wOAMBuffer + 4*$C
	ld b, $04			; 4 objects per sprite
	ld de, $5C9D
	ld a, [$DA14]
	and a
	jr z, .objectLoop
	ld c, a
.loop
	inc de
	dec c
	jr nz, .loop
.objectLoop
	inc [hl]			; go down one pixel
	inc l
	inc l
	ld a, [de]
	ld c, a
	cp a, $FF
	jr nz, .checkSuper
	ld de, $5C9D		; reset animation
	xor a
	ld [$DA14], a
	ld a, [de]
	ld c, a
.checkSuper
	ldh a, [hSuperStatus]
	cp a, 2
	jr nz, .loadTileNumber
	ld a, c
	add a, $20
	ld c, a
.loadTileNumber
	ld a, c
	ldi [hl], a
	inc de
	inc l
	dec b
	jr nz, .objectLoop
	ld a, [$DA14]
	add a, $04
	ld [$DA14], a
	ld hl, wOAMBuffer + 4*$C
	ld a, [hl]
	cp a, $50
	jr z, .resumeWalking
	cp a, $68
	jr z, .resumeWalking
	cp a, $80
	jr z, .resumeWalking
	ret

.resumeWalking
	ld a, $08
	ld [$DA16], a
	ld a, $17
	ldh [hGameState], a
	ret

_GameState_19:: ; 5C44
	ld hl, wOAMBuffer + 4*$C
	ld b, $04			; 4 objects per sprite
	ld de, $5C9D
	ld a, [$DA14]
	and a
	jr z, .objectLoop
	ld c, a
.loop
	inc de
	dec c
	jr nz, .loop
.objectLoop
	dec [hl]			; go up one pixel
	inc l
	inc l
	ld a, [de]
	ld c, a
	cp a, $FF
	jr nz, .checkSuper
	ld de, $5C9D		; reset animation
	xor a
	ld [$DA14], a
	ld a, [de]
	ld c, a
.checkSuper
	ldh a, [hSuperStatus]
	cp a, 2
	jr nz, .loadTileNumber
	ld a, c
	add a, $20
	ld c, a
.loadTileNumber
	ld a, c
	ldi [hl], a
	inc de
	inc l
	dec b
	jr nz, .objectLoop
	ld a, [$DA14]
	add a, $04
	ld [$DA14], a
	ld hl, wOAMBuffer + 4*$C
	ld a, [hl]
	cp a, $38				; top floor
	jr z, .resumeWalking
	cp a, $50				; high mid floor
	jr z, .resumeWalking
	cp a, $68				; low mid floor
	jr z, .resumeWalking
	ret

.resumeWalking
	ld a, $08
	ld [$DA16], a
	ld a, $17
	ldh [hGameState], a
	ret

; Is it possible (or even necessary) to document this more?
Data_5C9D:: ; FC9D
	db $02, $03, $12, $13
	db $02, $03, $12, $13
	db $02, $03, $12, $13
	db $02, $03, $12, $13
	db $04, $05, $14, $15
	db $04, $05, $14, $15
	db $04, $05, $14, $15
	db $04, $05, $14, $15
	db $00, $01, $16, $17
	db $00, $01, $16, $17
	db $00, $01, $16, $17
	db $00, $01, $16, $17
	db $04, $05, $14, $15
	db $04, $05, $14, $15
	db $04, $05, $14, $15
	db $04, $05, $14, $15
	db $FF

_GameState_1A:: ; 5CDE
	ld a, [$DA17]
	and a
	jp nz, .jmp_5D69
	ld c, 2
.erasePrizes
	ld hl, $98D1			; the * of the top prize
	ld de, $0060
	ld a, [wOAMBuffer + 4*$C]	; Y coordinate
	ld b, a
	cp a, $38
	jr z, .checkHiMidFloor
	ld a, " "
	ldi [hl], a				; erase the *
	ldd [hl], a				; and the prize
.checkHiMidFloor
	add hl, de				; next floor
	ld a, b
	cp a, $50
	jr z, .checkLoMidFloor
	ld a, " "
	ldi [hl], a				; erase the *
	ldd [hl], a				; and the prize
.checkLoMidFloor
	add hl, de				; next floor
	ld a, b
	cp a, $68
	jr z, .checkBottomFloor
	ld a, " "
	ldi [hl], a				; erase the *
	ldd [hl], a				; and the prize
.checkBottomFloor
	add hl, de				; next floor
	ld a, b
	cp a, $80
	jr z, .checkPrize
	ld a, " "
	ldi [hl], a				; erase the *
	ld [hl], a				; and the prize
.checkPrize
	dec c					; erase prizes twice. todo why
	jr nz, .erasePrizes
	ld hl, wOAMBuffer + 4*$C + 1	; X
	ldd a, [hl]
	add a, $18				; 3 tiles ahead
	ldh [$FFAE], a
	ld a, [hl]				; Y
	add a, $08				; 1 tile down
	ldh [$FFAD], a
	call LookupTile
	ld a, [hl]
	cp a, $03				; 3-UP
	jr z, .get3UP
	cp a, $E5				; Flower
	jr z, .getFlower
	cp a, $02				; 2-UP
	jr z, .get2UP
	ld a, $02				; 1-UP
	ld [$DA17], a
.playWinSound
	ld hl, $DFE8
	ld a, $0D
	ld [hl], a				; Win sound
	ret

.get2UP
	ld a, $03
	ld [$DA17], a
	jr .playWinSound

.get3UP
	ld a, $04
	ld [$DA17], a
	jr .playWinSound

.getFlower
	ldh a, [hSuperballMario]
	and a
	jr z, .awardFlower
	ld hl, $DFE8
	ld a, $0E				; Lose sound
	ld [hl], a
	ld a, $01				; no prize
	ld [$DA17], a
	ret

.awardFlower
	ld a, $10
	ld [$DA17], a
	jr .playWinSound

.jmp_5D69
	ld a, [$DA17]
	cp a, $10			; grow into superball mario
	jr nc, .jmp_5DA0
	cp a, $02			; add lives
	jp nc, .jmp_5E02
	ld a, [wBonusGameEndTimer]
	dec a
	ld [wBonusGameEndTimer], a
	ret nz
	ld a, $40
	ld [wBonusGameEndTimer], a
	xor a
	ld [$DA17], a
	ld [$DA14], a
	ld [$DA1C], a
	ld [wBonusGameGrowAnimationFlag], a
	ld [$DA20], a
	inc a
	ld [$DA16], a
	ld a, $40
	ld [wBonusGameAnimationTimer], a
	ld a, $1B
	ldh [hGameState], a		; Leave bonus game
	ret

.jmp_5DA0
	ld a, [wBonusGameAnimationTimer]
	dec a
	ld [wBonusGameAnimationTimer], a
	ret nz
	ld a, $03
	ld [wBonusGameAnimationTimer], a
	ld a, [$DA17]
	inc a
	ld [$DA17], a
	cp a, $28
	jr z, .jmp_5DF7
	ld a, [$DA1C]
	and a
	jr nz, .powerupAnimation
	inc a
	ld [$DA1C], a
	ld hl, $DFE0
	ld a, $04				; powerup sound
	ld [hl], a
	ldh a, [hSuperStatus]
	cp a, $02
	jr z, .jmp_5DF7
.powerupAnimation
	ld hl, wOAMBuffer + 4*$C + 2	; tile number
	ld b, $04				; 4 objects
	ld a, [wBonusGameGrowAnimationFlag]
	and a
	jr nz, .makeMarioSmall
	inc a
	ld [wBonusGameGrowAnimationFlag], a
.superLoop
	ld a, [hl]
	add a, $20
	ldi [hl], a
	inc l
	inc l
	inc l
	dec b
	jr nz, .superLoop
	ret

.makeMarioSmall
	dec a
	ld [wBonusGameGrowAnimationFlag], a
.smallLoop
	ld a, [hl]
	sub a, $20
	ldi [hl], a
	inc l
	inc l
	inc l
	dec b
	jr nz, .smallLoop
	ret

.jmp_5DF7
	ld a, $01
	ld [$DA17], a
	inc a
	ldh [hSuperStatus], a
	ldh [hSuperballMario], a
	ret

.jmp_5E02
	ld a, [wBonusGameAnimationTimer]
	dec a
	ld [wBonusGameAnimationTimer], a
	ret nz
	ld a, $04
	ld [wBonusGameAnimationTimer], a
	ld a, [$DA20]
	and a
	jr nz, .jmp_5E3F
	ld hl, wOAMBuffer + 4*$C
	ld a, $38
	ld b, a
	ldi [hl], a
	ld a, $58
	ld c, a
	ldi [hl], a
	inc l
	inc l
	ld a, b
	ldi [hl], a
	ld a, c
	add a, $08
	ldi [hl], a
	inc l
	inc l
	ld a, b
	add a, $08
	ld b, a
	ldi [hl], a
	ld a, c
	ldi [hl], a
	inc l
	inc l
	ld a, b
	ldi [hl], a
	ld a, c
	add a, $08
	ldi [hl], a
	xor a
	inc a
	ld [$DA20], a
	ret

.jmp_5E3F
	ld hl, wOAMBuffer + 4*$C
	ld a, [$DA21]
	cp a, $02
	jp z, .jmp_5EDA
	and a
	jr nz, .jmp_5EB2
	ld a, [hl]
	dec a
	ldi [hl], a
	inc l
	ld a, $08
	ld b, a
	ldh a, [hSuperStatus]
	cp a, $02
	jr nz, .jmp_5E5E
	ld a, b
	add a, $20
	ld b, a
.jmp_5E5E
	ld a, b
	ldi [hl], a
	inc l
	ld a, [hl]
	dec a
	ldi [hl], a
	inc l
	ld a, b
	inc a
	ldi [hl], a
	inc l
	ld a, [hl]
	dec a
	ldi [hl], a
	inc l
	ld a, b
	add a, $10
	ld b, a
	ldi [hl], a
	inc l
	ld a, [hl]
	dec a
	ldi [hl], a
	inc l
	ld a, b
	inc a
	ld [hl], a
	ld a, [$DA20]
	inc a
	ld [$DA20], a
	cp a, $06
	ret nz
	ld hl, $DFE0
	ld a, $08			; 1UP sound
	ld [hl], a
	ld a, [wLives]
	and a
	cp a, $99
	jr nc, .jmp_5EA9
	add a, 1
	daa
	ld [wLives], a
	ld de, $988B		; Lives counter ones
	ld a, [wLives]
	ld b, a
	and a, $0F
	ld [de], a
	dec e				; Lives counter tens
	ld a, b
	and a, $F0
	swap a
	ld [de], a
.jmp_5EA9
	ld a, $01
	ld [$DA20], a
	ld [$DA21], a
	ret

.jmp_5EB2
	ld a, [hl]
	inc a
	ldi [hl], a
	inc l
	inc l
	inc l
	ld a, [hl]
	inc a
	ldi [hl], a
	inc l
	inc l
	inc l
	ld a, [hl]
	inc a
	ldi [hl], a
	inc l
	inc l
	inc l
	ld a, [hl]
	inc a
	ld [hl], a
	ld a, [$DA20]
	inc a
	ld [$DA20], a
	cp a, $05
	ret nz
	ld hl, $DFE0
	ld a, $02
	ld [$DA21], a
	ret

.jmp_5EDA
	ld a, [hl]
	inc a
	ldi [hl], a
	inc l
	xor a
	ld b, a
	ldh a, [hSuperStatus]
	cp a, $02
	jr nz, .jmp_5EEA
	ld a, b
	add a, $20
	ld b, a
.jmp_5EEA
	ld a, b
	ldi [hl], a
	inc l
	ld a, [hl]
	inc a
	ldi [hl], a
	inc l
	ld a, b
	inc a
	ldi [hl], a
	inc l
	ld a, [hl]
	inc a
	ldi [hl], a
	inc l
	ld a, b
	add a, $10
	ld b, a
	ldi [hl], a
	inc l
	ld a, [hl]
	inc a
	ldi [hl], a
	inc l
	ld a, b
	inc a
	ld [hl], a
	xor a
	ld [$DA20], a
	ld [$DA21], a
	ld a, [$DA17]
	dec a
	ld [$DA17], a
	ret

INCBIN "baserom.gb", $9F15, $791A - $5F15

INCBIN "gfx/menuTiles1.2bpp"
INCBIN "gfx/menuTiles2.2bpp"
