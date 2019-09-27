INCLUDE "sound_constants.asm"

SECTION "bank 1", ROMX, BANK[1]
; Unused slots are filled with repeats of other pointers
; todo should be named levelscreenpointers or so?
LevelPointers:: ; 4000 Same every bank
LevelPointersBank1:: ; 1:4000
	dw $55BB
	dw $55E2
	dw $5605
	dw $55BB	; 2-1
	dw $55E2	; 2-2
	dw $5605	; 2-3
	dw $55BB
	dw $55E2
	dw $5605
	dw $5630	; 4-1
	dw $5665	; 4-2
	dw $5694	; 4-3
	dw $55BB

LevelEnemyPointers:: ; 401A
LevelEnemyPointersBank1:: ; 1:401A
	dw $5311
	dw $5405
	dw $54D5
	dw $5179	; 2-1
	dw $5222	; 2-2
	dw $529B	; 2-3
	dw $5311
	dw $5405
	dw $54D5
	dw $5311	; 4-1
	dw $5405	; 4-2
	dw $54D5	; 4-3

INCBIN "gfx/enemiesWorld2.2bpp"
INCBIN "gfx/backgroundWorld2.2bpp"

INCBIN "gfx/enemiesWorld4.2bpp"
INCBIN "gfx/backgroundWorld4.2bpp"

Call_4FB2:: ; 4FB2
	ldh a, [hFrameCounter]
	and a, $01
	ret nz
	ld a, [$C0D2]
	cp a, $07
	jr c, .jmp_4FCB
	ldh a, [hScrollX]
	and a, $0C
	jr nz, .jmp_4FCB
	ldh a, [hScrollX]
	and a, $FC
	ldh [hScrollX], a
	ret

.jmp_4FCB
	ldh a, [hScrollX]
	inc a
	ldh [hScrollX], a
	ld b, $01
	call Call_1D26.call_1EA4	; scroll sprites?
	call Call_2C9F				; scroll enemies?
	ld hl, $C202				; X coord
	dec [hl]
	ld a, [hl]
	and a
	jr nz, .jmp_4FE2
	ld [hl], $F0
.jmp_4FE2
	ld c, $08
	call Call_50CC
	ld hl, $C202
	inc [hl]
	ret

Call_4FEC:: ; 4FEC
	ldh a, [hJoyHeld]
	bit 6, a					; up button
	jr nz, .jmp_5034
	bit 7, a					; down button
	jr nz, .jmp_5022
.jmp_4FF6
	ldh a, [hJoyHeld]
	bit 4, a					; right button
	jr nz, .jmp_5014
	bit 5, a					; left button
	ret z
	ld c, $FA
	call Call_50CC
	ld hl, $C202
	ld a, [hl]
	cp a, $10
	ret c
	dec [hl]
	ld a, [$C0D2]
	cp a, $07
	ret nc
	dec [hl]
	ret

.jmp_5014
	ld c, $08
	call Call_50CC
	ld hl, $C202
	ld a, [hl]
	cp a, $A0
	ret nc
	inc [hl]
	ret

.jmp_5022
	call Call_5089
	cp a, $FF
	jr z, .jmp_4FF6
	ld hl, $C201				; Y coord
	ld a, [hl]
	cp a, $94					; ?
	jr nc, .jmp_4FF6
	inc [hl]
	jr .jmp_4FF6

.jmp_5034
	call .call_5046
	cp a, $FF
	jr z, .jmp_4FF6
	ld hl, $C201
	ld a, [hl]
	cp a, $30
	jr c, .jmp_4FF6
	dec [hl]
	jr .jmp_4FF6

.call_5046
	ld hl, $C201
	ldh a, [hSuperStatus]
	ld b, $FD
	and a
	jr z, .jmp_5052
	ld b, $FC
.jmp_5052
	ldi a, [hl]
	add b
	ldh [$FFAD], a
	ldh a, [hScrollX]
	ld b, [hl]
	add b
	add a, $02
	ldh [$FFAE], a
	call LookupTile
	cp a, $60
	jr nc, .jmp_5071
	ldh a, [$FFAE]
	add a, $FA
	ldh [$FFAE], a
	call LookupTile
	cp a, $60
	ret c
.jmp_5071
	cp a, $F4
	jr z, .jmp_5078
	ld a, $FF
	ret

.jmp_5078
	push hl
	pop de
	ld hl, $FFEE
	ld [hl], $C0
	inc l
	ld [hl], d			; FFEF
	inc l
	ld [hl], e			; FFF0
	ld a, SFX_COIN
	ld [$DFE0], a
	ret

Call_5089:: ; 5089
	ld hl, $C201
	ldi a, [hl]
	add a, $0A
	ldh [$FFAD], a
	ldh a, [hScrollX]
	ld b, a
	ld a, [hl]
	add b
	add a, $FE
	ldh [$FFAE], a
	call LookupTile
	cp a, $60
	jr nc, .jmp_50B4
	ldh a, [$FFAE]
	add a, $04
	ldh [$FFAE], a
	call LookupTile
	cp a, $E1
	jp z, Jmp_1B45			; end of level?
	cp a, $60
	jr nc, .jmp_50B4
	ret

.jmp_50B4
	cp a, $F4
	jr nz, .jmp_50C9
	push hl
	pop de
	ld hl, $FFEE
	ld [hl], $C0
	inc l
	ld [hl], d
	inc l
	ld [hl], e
	ld a, SFX_COIN
	ld [$DFE0], a
	ret

.jmp_50C9
	ld a, $FF
	ret

Call_50CC:: ; 50CC
	ld de, $0502
	ldh a, [hSuperStatus]
	cp a, $02
	jr z, .jmp_50D8
	ld de, $0501
.jmp_50D8
	ld hl, $C201
	ldi a, [hl]
	add d
	ldh [$FFAD], a
	ld b, [hl]
	ld a, c
	add b
	ld b, a
	ldh a, [hScrollX]
	add b
	ldh [$FFAE], a
	push de
	call LookupTile
	pop de
	cp a, $60
	jr c, .jmp_5101
	cp a, $F4			; coin?
	jr z, .jmp_5107
	cp a, $E1			; boss switch
	jp z, Jmp_1B45
	cp a, $83			; mushroom...
	jp z, Jmp_1B45
	pop hl
	ret

.jmp_5101
	ld d, $FD
	dec e
	jr nz, .jmp_50D8
	ret

.jmp_5107
	push hl
	pop de
	ld hl, $FFEE
	ld [hl], $C0
	inc l
	ld [hl], d
	inc l
	ld [hl], e
	ld a, SFX_COIN
	ld [$DFE0], a
	ret

Call_5118:: ; 5118
	ld b, $03				; 3 projectiles
	ld hl, $FFA9			; projectile status
	ld de, wOAMBuffer + 1
.loop
	ldi a, [hl]
	and a
	jr nz, .jmp_512C
.jmp_5124
	inc e
	inc e
	inc e
	inc e
	dec b
	jr nz, .loop
	ret

.jmp_512C
	push hl
	push de
	push bc
	dec l
	ld a, [de]
	inc a
	inc a
	ld [de], a
	ldh [$FFA1], a
	ldh [$FFC3], a			; isn't this for enemies?
	cp a, $A9
	jr c, .jmp_5143
.jmp_513C
	xor a
	res 0, e
	ld [de], a
	ld [hl], a
	jr .jmp_5156

.jmp_5143
	add a, $02
	push af
	dec e
	ld a, [de]
	ldh [$FFC2], a
	add a, $06
	ldh [$FFAD], a
	pop af
	call FindNeighboringTile
	jr c, .jmp_5156
	jr .jmp_513C

.jmp_5156
	pop bc
	pop de
	pop hl
	call Call_200A			; collision with enemy
	jr .jmp_5124

.jmp_515E
	ld a, [$C202]
	cp a, $01
	jr c, .jmp_5168
	cp a, $ED
	ret c
.jmp_5168
	xor a
	ldh [hSuperStatus], a
	ldh [hSuperballMario], a
	inc a
	ldh [hGameState], a		; dead
	inc a
	ld [$DFE8], a			; MUS_DEATH
	ld a, $90
	ldh [hTimer], a
	ret

SECTION "bank 1 levels", ROMX[$55BB], BANK[1]
INCBIN "baserom.gb", $55BB, $8000 - $55BB
