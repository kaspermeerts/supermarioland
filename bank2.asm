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
	jp $5A72
	jp $5ABB
	jp $5B65
	jp $5BEB
	jp $5C44
	jp $5CDE

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

INCBIN "baserom.gb", $9A72, $791A - $5A72

INCBIN "gfx/menuTiles1.2bpp"
INCBIN "gfx/menuTiles2.2bpp"
