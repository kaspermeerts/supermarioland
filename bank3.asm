INCLUDE "gbhw.asm"

SECTION "bank 3", ROMX, BANK[3]
LevelPointersBank3:: ; 3:4000
	dw $503F
	dw $5074
	dw $509B
	dw $503F
	dw $5074
	dw $509B
	dw $503F	; 3-1
	dw $5074	; 3-2
	dw $509B	; 3-3
	dw $503F
	dw $5074
	dw $509B
	dw $50C0	; End of world "hangar"

LevelEnemyPointersBank3:: ; 3:4000
	dw $4E74
	dw $4F1D
	dw $4FD8
	dw $4E74
	dw $4F1D
	dw $4FD8
	dw $4E74	; 3-1
	dw $4F1D	; 3-2
	dw $4FD8	; 3-3
	dw $4E74
	dw $4F1D
	dw $4FD8

INCBIN "gfx/enemiesWorld3.2bpp"
INCBIN "gfx/backgroundWorld3.2bpp"

ReadJoypad:: ; 47F2
	ld a, $20		; select button keys
	ldh [rJOYP], a
	ldh a, [rJOYP]
	ldh a, [rJOYP]	; read multiple times to avoid switch bounce
	cpl				; 0 means pressed
	and a, $0F
	swap a
	ld b, a
	ld a, $10		; select direction keys
	ldh [rJOYP], a
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	cpl
	and a, $0F
	or b
	ld c, a
	ldh a, [hJoyHeld]
	xor c			; set all bits which are different since the previous time
	and c			; and keep only the ones that are pressed now
	ldh [hJoyPressed], a
	ld a, c
	ldh [hJoyHeld], a
	ld a, $30
	ldh [rJOYP], a	; deselect keys
	ret

INCBIN "baserom.gb", $C823, $6600 - $4823

Data_6600
	dw $67AF, $67E4, $683D, $687A, $6813, $68C4, $68A5, $68F0, $677B, $676E, $6868
Data_6616
	dw $67C4, $67F0, $6849, $6887, $681D, $68D2, $67F0, $6916, $67F0, $67F0, $6887
Data_662C
	dw $6957, $69A3, $6970, $6997
Data_6634
	dw $69AF, $69AF, $697C, $69AF
Data_663C
	dw $6F98, $6FA3, $6FAE, $6FB9, $6FC4, $6FCF, $6FDA, $6FE5, $78DC, $78E7, $78F2, $78FD, $7908, $7913, $791E, $7929, $7D6A, $7934, $793F

_Call_7FF0:: ; 6662
	push af
	push bc
	push de
	push hl
	ld a, $03		; Cartridge doesn't have RAM, and it's not even the correct
	ld [$00FF], a	; way to enable it. Bug
	ei				; Is this smart
	ldh a, [hPauseUnpauseMusic]
	cp a, $01		; 1 means pause music
	jr z, .pauseMusic
	cp a, $02		; 2 means unpause music
	jr z, .unpauseMusic
	ldh a, [hPauseTuneTimer]
	and a
	jr nz, .soundPaused
	ld c, $D3
	ld a, [$FF00+c]
	and a
	jr z, .jmp_6688
	xor a
	ld [$FF00+c], a
	ld a, $08		; 1UP sound
	ld [$DFE0], a
.jmp_6688
	call Call_6A6A
	call Call_6A8E
	call Call_66F6
	call Call_6AB5
	call $6CBE
	call Call_6B09
.out
	xor a
	ld [$DFE0], a
	ld [$DFE8], a
	ld [$DFF0], a
	ld [$DFF8], a
	ldh [hPauseUnpauseMusic], a
	ld a, $07
	ld [$00FF], a	; Bug continued
	pop hl
	pop de
	pop bc
	pop af
	reti			; Interrupts are already enabled, necessary? Maybe to alert
					; peripherals to reset their interrupt flags
.pauseMusic
	call _Call_7FF3.call_6A54
	xor a
	ld [$DFE1], a
	ld [$DFF1], a
	ld [$DFF9], a
	ld a, $30
	ldh [hPauseTuneTimer], a
.playFirstNote
	ld hl, .data_66EE
.playNote
	call Call_69E5.square2
	jr .out

.playSecondNote
	ld hl, .data_66F2
	jr .playNote

.unpauseMusic
	xor a
	ldh [hPauseTuneTimer], a
	jr .jmp_6688

.soundPaused
	ld hl, hPauseTuneTimer
	dec [hl]
	ld a, [hl]
	cp a, $28				; Continue pause tune if it's still running
	jr z, .playSecondNote
	cp a, $20
	jr z, .playFirstNote
	cp a, $18
	jr z, .playSecondNote
	cp a, $10
	jr nz, .out
	inc [hl]				; Keep the hPauseTuneTimer non-zero, keeps the music
	jr .out					; paused

.data_66EE
	db $B2, $E3, $83, $C7	; 1048.6 Hz ~ C6
.data_66F2
	db $B2, $E3, $C1, $C7	; 2080.5 Hz ~ C7

Call_66F6:: ; 66F6
	ld a, [$DFF0]	; SFX channel
	cp a, $01
	jr z, .jmp_670A
	ld a, [$DFF1]
	cp a, $01
	jr z, .jmp_672F
	ret

.data_6705
	db $80, $3A, $20, $B0, $C6

.jmp_670A
	ld [$DFF1], a
	ld hl, $DF3F
	set 7, [hl]
	xor a
	ld [$DFF4], a
	ldh [rNR30], a		; wave DAC power
	ld hl, $6F4B
	call Call_6A26		; copy HL to wave pattern
	ldh a, [rDIV]
	and a, $1F
	ld b, a
	ld a, $D0
	add b
	ld [$DFF5], a
	ld hl, .data_6705
	jp Call_69E5.wave	; copy HL to wave registers

.jmp_672F
	ldh a, [rDIV]
	and a, $07
	ld b, a
	ld hl, $DFF4
	inc [hl]
	ld a, [hl]
	ld hl, $DFF5
	cp a, $0E
	jr nc, .jmp_674A
	inc [hl]
	inc [hl]
.jmp_6742
	ld a, [hl]
	and a, $F8
	or b
	ld c, LOW(rNR33)
	ld [$FF00+c], a
	ret

.jmp_674A
	cp a, $1E
	jr z, .jmp_6753
	dec [hl]
	dec [hl]
	dec [hl]
	jr .jmp_6742

.jmp_6753
	xor a
	ld [$DFF1], a
	ldh [rNR30], a
	ld hl, $DF3F
	res 7, [hl]
	ld bc, $DF36
	ld a, [bc]
	ld l, a
	inc c
	ld a, [bc]
	ld h, a
	jp Call_6A26

INCBIN "baserom.gb", $E769, $69E5 - $6769

; copy HL to channel
Call_69E5:: ; 69E5
.square1
	push bc
	ld c, LOW(rNR10)
	ld b, $05
	jr .jmp_69FF

.square2
	push bc
	ld c, LOW(rNR21)
	ld b, $04
	jr .jmp_69FF

.wave
	push bc
	ld c, LOW(rNR30)
	ld b, $05
	jr .jmp_69FF

.noise
	push bc
	ld c, LOW(rNR41)
	ld b, $04
.jmp_69FF
	ldi a, [hl]
	ld [$FF00+c], a
	inc c
	dec b
	jr nz, .jmp_69FF
	pop bc
	ret

; do a lookup in HL
Call_6A07:: ; 6A07
	inc e
	ldh [$FFD1], a
.call_6A0A
	inc e
	dec a
	sla a
	ld c, a
	ld b, $00
	add hl, bc
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld l, c
	ld h, b
	ld a, h
	ret

Call_6A19 ;; 6A19
	push de
	ld l, e
	ld h, d
	inc [hl]
	ldi a, [hl]
	cp [hl]
	jr nz, .jmp_6A24
	dec l
	xor a
	ld [hl], a
.jmp_6A24
	pop de
	ret

; copy HL to wave pattern
Call_6A26:: ; 6A26
	push bc
	ld c, $30		; wave pattern RAM
.loop
	ldi a, [hl]
	ld [$FF00+c], a
	inc c
	ld a, c
	cp a, $40
	jr nz, .loop
	pop bc
	ret

; reset sound
_Call_7FF3:: ; 6A33
	xor a
	ld [$DFE1], a
	ld [$DFE9], a
	ld [$DFF1], a
	ld [$DFF9], a	; currently playing music and sfx
	ld [$DF1F], a
	ld [$DF2F], a
	ld [$DF3F], a
	ld [$DF4F], a
	ldh [hPauseUnpauseMusic], a
	ldh [$FFDE], a
	ld a, $FF
	ldh [rNR51], a	; enable all channels to both outputs
.call_6A54
	ld a, $08
	ldh [rNR12], a
	ldh [rNR22], a
	ldh [rNR42], a	; volume to zero, enable envelope?
	ld a, $80
	ldh [rNR14], a
	ldh [rNR24], a
	ldh [rNR44], a	; restart sound, counter mode
	xor a
	ldh [rNR10], a	; disable sweep
	ldh [rNR30], a	; disable wave
	ret

Call_6A6A:: ; 6A6A
	ld de, $DFE0	; non zero to start sfx
	ld a, [de]
	and a
	jr z, .jmp_6A81	; if zero, play the current sound
	cp a, $C
	jr nc, .jmp_6A81; bounds check, $B sound effects in this "channel"
	ld hl, $DF1F	; load the new sound
	set 7, [hl]
	ld hl, Data_6600
	call Call_6A07
	jp hl

.jmp_6A81
	inc e
	ld a, [de]
	and a
	jr z, .jmp_6A8D
	ld hl, Data_6616
	call Call_6A07.call_6A0A
	jp hl

.jmp_6A8D
	ret

Call_6A8E:: ; 6A8E
	ld de, $DFF8
	ld a, [de]
	and a
	jr z, .jmp_6AA5
	cp a, $05
	jr nc, .jmp_6AA5
	ld hl, $DF4F
	set 7, [hl]
	ld hl, Data_662C
	call Call_6A07
	jp hl

.jmp_6AA5
	inc e
	ld a, [de]
	and a
	jr z, .jmp_6AB1
	ld hl, Data_6634
	call Call_6A07.call_6A0A
	jp hl

.jmp_6AB1
	ret

; Seriously?? Bug
Jmp_6AB2 ; 6AB2
	jp _Call_7FF3

; setup new music
Call_6AB5:: ; 6AB5
	ld hl, $DFE8
	ldi a, [hl]
	and a
	ret z
	cp a, $14
	ret nc		; 19 songs, bounds check
	ld [hl], a
	cp a, $FF	; can this ever be true?
	jr z, Jmp_6AB2
	ld b, a
	ld hl, Data_663C
	ld a, b
	and a, $1F
	call Call_6A07.call_6A0A	; another lookup
	call Call_6B8C
	jp .jmp_6AD3	; seriously... bug

.jmp_6AD3
	ld a, [$DFE9]
	ld hl, Data_6B2F
.jmp_6AD9
	dec a
	jr z, .jmp_6AE2
	inc hl
	inc hl
	inc hl
	inc hl
	jr .jmp_6AD9

.jmp_6AE2
	ldi a, [hl]
	ldh [$FFD8], a
	ldi a, [hl]
	ldh [$FFD6], a
	ldi a, [hl]
	ldh [$FFD9], a
	ldh [rNR51], a
	ldi a, [hl]
	ldh [$FFDA], a
	xor a
	ldh [$FFD5], a
	ldh [$FFD7], a
	ret

.call_6AF6
	ld a, [$DFF9]
	cp a, $01
	ret nz
	ld a, [hl]
	bit 1, a
	ld a, $F7
	jr z, .jmp_6B05
	ld a, $7F
.jmp_6B05
	call Call_6B09.jmp_6B2C
.jmp_6B08
	ret

Call_6B09:: ; 6B09
	ld a, [$DFE9]
	and a
	ret z
	ldh a, [$FFD8]
	cp a, $01
	jr z, Call_6AB5.jmp_6B08
	ld hl, $FFD5
	call Call_6AB5.call_6AF6
	inc [hl]
	ldi a, [hl]
	cp [hl]
	ret nz
	dec l
	ld [hl], $00
	inc l
	inc l
	inc [hl]
	ldh a, [$FFD9]
	bit 0, [hl]
	jr z, .jmp_6B2C
	ldh a, [$FFDA]
.jmp_6B2C
	ldh [rNR51], a
	ret

Data_6B2F:: ; 6B2F
	db $02, $24, $ED, $DE	; Music 1
	db $01, $18, $BD, $00
	db $02, $20, $7F, $B7
	db $01, $18, $ED, $7F
	db $01, $18, $FF, $F7
	db $02, $40, $7F, $F7
	db $02, $40, $7F, $F7
	db $01, $18, $FF, $F7
	db $01, $10, $FF, $A5
	db $01, $00, $65, $00
	db $01, $00, $FF, $00
	db $02, $08, $7F, $B5
	db $01, $00, $ED, $00
	db $01, $00, $ED, $00
	db $01, $00, $FF, $00
	db $01, $00, $ED, $00
	db $02, $18, $7E, $E7
	db $01, $18, $ED, $E7
	db $01, $00, $DE, $00	; Music 19

; copy 2 bytes from the address at HL to DE
Call_6B7B:: ; 6B7B
	ldi a, [hl]
	ld c, a
	ld a, [hl]
	ld b, a
	ld a, [bc]
	ld [de], a
	inc e
	inc bc
	ld a, [bc]
	ld [de], a
	ret

; copy 2 bytes from HL to DE
Call_6B86:: ; 6B86
	ldi a, [hl]
	ld [de], a
	inc e
	ldi a, [hl]
	ld [de], a
	ret

; setup array of addresses and such at DF00-DF4F
Call_6B8C::; 6B8C
	call _Call_7FF3.call_6A54
	xor a
	ldh [$FFD5], a
	ldh [$FFD7], a
	ld de, $DF00
	ld b, $00
	ldi a, [hl]
	ld [de], a
	inc e
	call Call_6B86
	ld de, $DF10
	call Call_6B86
	ld de, $DF20
	call Call_6B86
	ld de, $DF30
	call Call_6B86
	ld de, $DF40
	call Call_6B86
	ld hl, $DF10
	ld de, $DF14
	call Call_6B7B
	ld hl, $DF20
	ld de, $DF24
	call Call_6B7B
	ld hl, $DF30
	ld de, $DF34
	call Call_6B7B
	ld hl, $DF40
	ld de, $DF44
	call Call_6B7B
	ld bc, $0410		; 4 loops, $10 bytes between each DFx2
	ld hl, $DF12
.loop
	ld [hl], $01
	ld a, c
	add l
	ld l, a
	dec b
	jr nz, .loop
	xor a
	ld [$DF1E], a
	ld [$DF2E], a
	ld [$DF3E], a
	ret

INCBIN "baserom.gb", $EBF4, $7F07 - $6BF4

ds $E9 ; todo use SECTION?

; gets called from timer interrupt
Call_7FF0:: ; 7FF0
	jp _Call_7FF0
Call_7FF3:: ; 7FF3
	jp _Call_7FF3
