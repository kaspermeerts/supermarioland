INCLUDE "gbhw.asm"
INCLUDE "sound_constants.asm"

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

LevelEnemyPointersBank3:: ; 3:401A
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

Call_4823:: ; 4823
	ld a, h
	ldh [$FF96], a
	ld a, l
	ldh [$FF97], a
	ld a, [hl]
	and a
	jr z, .jmp_484A
	cp a, $80
	jr z, .jmp_4848
.jmp_4831
	ldh a, [$FF96]
	ld h, a
	ldh a, [$FF97]
	ld l, a
	ld de, $0010
	add hl, de
	ldh a, [$FF8F]
	dec a
	ldh [$FF8F], a
	ret z
	jr Call_4823

.jmp_4843
	xor a
	ldh [$FF95], a
	jr .jmp_4831

.jmp_4848
	ldh [$FF95], a
.jmp_484A
	ld b, $07
	ld de, $FF86
.jmp_484F
	ldi a, [hl]
	ld [de], a
	inc de
	dec b
	jr nz, .jmp_484F
	ldh a, [$FF89]
	ld hl, $4C37
	rlca
	ld e, a
	ld d, $00
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld a, [de]
	ld l, a
	inc de
	ld a, [de]
	ld h, a
	inc de
	ld a, [de]
	ldh [$FF90], a
	inc de
	ld a, [de]
	ldh [$FF91], a
	ld e, [hl]
	inc hl
	ld d, [hl]
.jmp_4872
	inc hl
	ldh a, [$FF8C]
	ldh [$FF94], a
	ld a, [hl]
	cp a, $FF
	jr z, .jmp_4843
	cp a, $FD
	jr nz, .jmp_488C
	ldh a, [$FF8C]
	xor a, $10
	ldh [$FF94], a
	jr .jmp_4872

.jmp_4888
	inc de
	inc de
	jr .jmp_4872

.jmp_488C
	cp a, $FE
	jr z, .jmp_4888
	ldh [$FF89], a
	ldh a, [$FF87]
	ld b, a
	ld a, [de]
	ld c, a
	ldh a, [$FF8B]
	bit 6, a
	jr nz, .jmp_48A3
	ldh a, [$FF90]
	add b
	adc c
	jr .jmp_48AD

.jmp_48A3
	ld a, b
	push af
	ldh a, [$FF90]
	ld b, a
	pop af
	sub b
	sbc c
	sbc a, $08
.jmp_48AD
	ldh [$FF93], a
	ldh a, [$FF88]
	ld b, a
	inc de
	ld a, [de]
	inc de
	ld c, a
	ldh a, [$FF8B]
	bit 5, a
	jr nz, .jmp_48C2
	ldh a, [$FF91]
	add b
	adc c
	jr .jmp_48CC

.jmp_48C2
	ld a, b
	push af
	ldh a, [$FF91]
	ld b, a
	pop af
	sub b
	sbc c
	sbc a, $08
.jmp_48CC
	ldh [$FF92], a
	push hl
	ldh a, [$FF8D]
	ld h, a
	ldh a, [$FF8E]
	ld l, a
	ldh a, [$FF95]
	and a
	jr z, .jmp_48DE
	ld a, $FF
	jr .jmp_48E0

.jmp_48DE
	ldh a, [$FF93]
.jmp_48E0
	ldi [hl], a
	ldh a, [$FF92]
	ldi [hl], a
	ldh a, [$FF89]
	ldi [hl], a
	ldh a, [$FF94]
	ld b, a
	ldh a, [$FF8B]
	or b
	ld b, a
	ldh a, [$FF8A]
	or b
	ldi [hl], a
	ld a, h
	ldh [$FF8D], a
	ld a, l
	ldh [$FF8E], a
	pop hl
	jp .jmp_4872

.jmp_48FC
	ld hl, $C209
	ld a, [hl]
	ld b, a
	and a
	ret z
	dec l
	ld a, [hl]
	cp a, $0F
	ret nc
	ld [hl], b
	inc l
	ld [hl], 0
	ret

Call_490D:: ; 490D
	ld a, [bc]			; C2x8
	ld e, a
	ld d, $00
	dec c
	ld a, [bc]			; C2x7
	dec c
	dec c
	dec c
	dec c
	dec c
	dec c
	and a
	ret z
	cp a, $02
	jr z, .jmp_4933
	add hl, de
	ld a, [hl]
	cp a, $7F
	jr z, .jmp_4948
	ld a, [bc]			; C2x1
	sub [hl]
	ld [bc], a
	inc e
.jmp_4929
	ld a, e
	inc c
	inc c
	inc c
	inc c
	inc c
	inc c
	inc c
	ld [bc], a			; C2x8
	ret

.jmp_4933
	ld a, e
	cp a, $FF
	jr z, .jmp_495B
	add hl, de
	ld a, [hl]
	cp a, $7F
	jr z, .jmp_4944
.jmp_493E
	ld a, [bc]			; C2x1
	add [hl]
	ld [bc], a
	dec e
	jr .jmp_4929

.jmp_4944
	dec hl
	dec e
	jr .jmp_493E

.jmp_4948
	dec de
	dec hl
	ld a, $02
	inc c
	inc c
	inc c
	inc c
	inc c
	inc c
	ld [bc], a
	dec c
	dec c
	dec c
	dec c
	dec c
	dec c
	jr .jmp_493E

.jmp_495B
	xor a
	inc c
	inc c
	inc c
	inc c
	inc c
	inc c
	ld [bc], a
	inc c
	ld [bc], a
	ret

Jmp_4966:: ; 4966
	inc e
	ld a, [de]
	cp a, $0F
	jr nc, .jmp_49B5
	inc e
	dec a
	ld [de], a
	dec e
	ld a, $0F
	ld [de], a
	jr .jmp_49B5
.jmp_4975
	push af
	ld a, [de]
	and a
	jr nz, .jmp_4988
	ld a, [$C20C]
	cp a, $03
	ld a, $02
	jr c, .jmp_4985
	ld a, $04
.jmp_4985
	ld [$C20E], a			; walking or running
.jmp_4988
	pop af
	jr .jmp_49AC

.jmp_498B
	ldh a, [hGameState]
	cp a, $0D
	jp z, .jmp_4A7F
	ld de, $C207			; jump status
	ldh a, [hJoyPressed]
	ld b, a
	ldh a, [hJoyHeld]
	bit 1, a				; B button todo
	jr nz, .jmp_4975
	push af
	ld a, [$C20E]			; walking running
	cp a, $04
	jr nz, .jmp_49AB
	ld a, $02
	ld [$C20E], a
.jmp_49AB
	pop af
.jmp_49AC
	bit 0, a				; A button
	jr nz, .jmp_49BF
	ld a, [de]
	cp a, $01
	jr z, Jmp_4966
.jmp_49B5
	bit 7, b				; Down button
	jp nz, .jmp_4A77
.jmp_49BA
	bit 1, b				; B button
	jr nz, .jmp_49FD
	ret

.jmp_49BF
	ld a, [de]
	and a
	jr nz, .jmp_49B5
	ld hl, $C20A			; 1 if on ground
	ld a, [hl]
	and a
	jr z, .jmp_49B5
	bit 0, b				; A button
	jr z, .jmp_49B5
	ld [hl], $00
	ld hl, $C203			; animation thing
	push hl
	ld a, [hl]
	cp a, $18				; crouching big?
	jr z, .jmp_49F2
	and a, $F0
	or a, $04
	ld [hl], a
	ld a, [$C20E]			; walking running
	cp a, $04
	jr z, .jmp_49ED
	ld a, $02
	ld [$C20E], a
	ld [$C208], a
.jmp_49ED
	ld hl, $C20C
	ld [hl], $30
.jmp_49F2
	ld hl, $DFE0
	ld [hl], SFX_JUMP
	ld a, $01
	ld [de], a
	pop hl
	jr .jmp_49B5

.jmp_49FD
	ld hl, $C20C
	ld a, [hl]
	cp a, $06
	jr nz, .jmp_4A0C
	ldh a, [$FF9F]
	and a
	jr nz, .jmp_4A0C
	ld [hl], $00
.jmp_4A0C
	ldh a, [hGameState]
	cp a, $0D
	ld b, $03
	jr z, .jmp_4A1A
	ldh a, [hSuperballMario]
	and a
	ret z
	ld b, $01
.jmp_4A1A
	ld hl, $FFA9			; projectile status?
	ld de, wOAMBuffer
.jmp_4A20
	ldi a, [hl]
	and a
	jr z, .jmp_4A2C
	inc e
	inc e
	inc e
	inc e
	dec b
	jr nz, .jmp_4A20
	ret

.jmp_4A2C
	push hl
	ld hl, $C205
	ld b, [hl]
	ld hl, $C201
	ldi a, [hl]
	add a, $FE
	ld [de], a
	inc e
	ld c, $02
	bit 5, b			; left button
	jr z, .jmp_4A41
	ld c, $F8
.jmp_4A41
	ldi a, [hl]
	add c
	ld [de], a
	ld c, $60
	inc e
	ldh a, [hGameState]
	cp a, $0D
	jr nz, .jmp_4A57
	ld c, $7A
	ldh a, [hLevelIndex]
	cp a, $0B			; last level?
	jr nz, .jmp_4A57
	ld c, $6E
.jmp_4A57
	ld a, c
	ld [de], a
	inc e
	xor a
	ld [de], a
	pop hl
	dec l
	ld c, $0A
	bit 5, b			; left button?
	jr nz, .jmp_4A66
	ld c, $09
.jmp_4A66
	ld [hl], c
	ld hl, $DFE0
	ld [hl], SFX_SUPERBALL
	ld a, $0C
	ld [$C0AE], a
	ld a, $FF
	ld [wSuperballTTL], a
	ret

.jmp_4A77
	ld hl, $C20C
	ld [hl], $20
	jp .jmp_49BA
.jmp_4A7F
	ldh a, [hJoyPressed]
	and a, $03				; A or B
	jr nz, .jmp_4A0C
	ldh a, [hJoyHeld]
	bit 0, a				; A button
	ret z
	ld hl, $C0AE
	ld a, [hl]
	and a
.jmp_4A8F
	jp z, .jmp_4A0C
	dec [hl]
	ret


INCBIN "baserom.gb", $CA94, $4E74 - $4A94

SECTION "bank 3 levels", ROMX[$503F], BANK[3]

INCBIN "baserom.gb", $D03F, $6600 - $503F

Data_6600:
	dw StartJumpSFX
	dw StartSuperballSFX
	dw StartStompSFX
	dw StartGrowSFX
	dw StartCoinSFX
	dw StartInjurySFX
	dw StartBumpSFX
	dw StartOneUpSFX
	dw StartGiraSFX
	dw StartTimerTickSFX
	dw StartFlowerSFX

Data_6616:
	dw ContinueJumpSFX
	dw ContinueSquareSFX
	dw ContinueStompSFX
	dw ContinueSweepSquareSFX
	dw ContinueCoinSFX
	dw ContinueInjurySFX
	dw ContinueSquareSFX
	dw ContinueOneUpSFX
	dw ContinueSquareSFX
	dw ContinueSquareSFX
	dw ContinueSweepSquareSFX

Data_662C:
	dw StartExplosionSFX
	dw StartBrickShatterSFX
	dw StartDeathCrySFX
	dw StartFireBreathSFX
Data_6634:
	dw ContinueNoiseSFX
	dw ContinueNoiseSFX
	dw ContinueDeathCrySFX
	dw ContinueNoiseSFX

; dump_music.py
Data_663C:
	dw Song_6F98	; 1
	dw Song_6FA3
	dw Song_6FAE
	dw Song_6FB9
	dw Song_6FC4	; 5
	dw Song_6FCF
	dw Song_6FDA
	dw Song_6FE5
	dw Song_78DC
	dw Song_78E7	; 10
	dw Song_78F2
	dw Song_78FD
	dw Song_7908
	dw Song_7913
	dw Song_791E	; 15
	dw Song_7929
	dw Song_7D6A
	dw Song_7934
	dw Song_793F	; 19

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
	ld a, [$FF00+c]	; ?? To override other SFXs?
	and a
	jr z, .jmp_6688
	xor a
	ld [$FF00+c], a
	ld a, $08		; 1UP sound
	ld [$DFE0], a
.jmp_6688
	call PlaySquareSFX
	call PlayNoiseSFX	; play noise sfx
	call PlayWaveSFX	; play wave sfx
	call StartMusic
	call PlayMusic
	call PanStereo
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
	call _InitSound.muteChannels
	xor a
	ld [$DFE1], a
	ld [$DFF1], a
	ld [$DFF9], a
	ld a, $30
	ldh [hPauseTuneTimer], a
.playFirstNote
	ld hl, .pauseFirstNoteData
.playNote
	call SetupChannel.square2
	jr .out

.playSecondNote
	ld hl, .pauseSecondNoteData
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

.pauseFirstNoteData
	db $B2, $E3, $83, $C7	; 1048.6 Hz ~ C6
.pauseSecondNoteData
	db $B2, $E3, $C1, $C7	; 2080.5 Hz ~ C7

PlayWaveSFX:: ; 66F6
	ld a, [$DFF0]	; SFX channel, only has boss cry
	cp a, $01
	jr z, .startBossCry
	ld a, [$DFF1]
	cp a, $01
	jr z, .continueBossCry
	ret

.bossCryChannelData
	db $80, $3A, $20, $B0, $C6	; 198/256 seconds, full volume, ~195 Hz (~G3)

.startBossCry
	ld [$DFF1], a
	ld hl, $DF3F
	set 7, [hl]			; stops the music from using the Wave channel?
	xor a
	ld [$DFF4], a
	ldh [rNR30], a		; wave DAC power
	ld hl, BossCryWavePattern
	call SetupWavePattern
	ldh a, [rDIV]		; supposedly random, but because the music code is
	and a, $1F			; linked to the timer interrupt, rDIV might always be 1
	ld b, a				; here? Bug?
	ld a, $D0
	add b
	ld [$DFF5], a		; "random" number from D0 to FF (always ~D1?)
	ld hl, .bossCryChannelData
	jp SetupChannel.wave	; copy HL to wave registers

.continueBossCry
	ldh a, [rDIV]
	and a, $07
	ld b, a				; "random" number from 0 to 7 (always ~2?)
	ld hl, $DFF4
	inc [hl]
	ld a, [hl]
	ld hl, $DFF5
	cp a, $0E
	jr nc, .lowerFreq
	inc [hl]
	inc [hl]
.writeFreq
	ld a, [hl]
	and a, $F8			; put a "random" number in the low nibble
	or b
	ld c, LOW(rNR33)	; modulate frequency
	ld [$FF00+c], a
	ret

.lowerFreq
	cp a, $1E
	jr z, .stopBossCry
	dec [hl]
	dec [hl]
	dec [hl]
	jr .writeFreq

.stopBossCry
	xor a
	ld [$DFF1], a
	ldh [rNR30], a
	ld hl, $DF3F
	res 7, [hl]			; release wave channel?
	ld bc, $DF36
	ld a, [bc]
	ld l, a
	inc c
	ld a, [bc]
	ld h, a
	jp SetupWavePattern

; no sweep, 50% duty, 1/16 second, envelope?, 1024 Hz, trigger, counter mode
TimerTickChannelData:: ; 6769
	db $00, $B0, $53, $80, $C7

StartTimerTickSFX:: ; 676E
	ld a, $03
	ld hl, TimerTickChannelData
	jp Jmp_69C6

GiraChannelData:: ; 6776
	db $3C, $80, $A0, $50, $84 ; 138.9 Hz, C#3

StartGiraSFX:: ; 677B
	call Call_6791.jmp_679C
	ret z
	ld a, $0E
	ld hl, GiraChannelData
	jp Jmp_69C6

JumpChannelData:: ; 6787
	db $00, $80, $D2, $0A, $86 ; 261.1 Hz C4

; Superball?
SuperballChannelData:: ; 678C
	db $3D, $80, $A3, $09, $87 ; 530.7 Hz ~ C5 (24 cents off...)

; used to check if new SFX overrides the one currently playing
Call_6791:: ; 6791
	ld a, [$DFE1]
	jr .jmp_67A2 ; WTF is this bullshit

.jmp_6796
	ld a, [$DFE1]
	cp a, SFX_STOMP
	ret z
.jmp_679C
	ld a, [$DFE1]
	cp a, SFX_COIN
	ret z
.jmp_67A2
	cp a, SFX_GROW
	ret z
	cp a, SFX_INJURY
	ret z
	cp a, SFX_1UP
	ret z
	cp a, SFX_FLOWER
	ret z
	ret

StartJumpSFX:: ; 67AF
	call Call_6791.jmp_6796
	ret z
	ld a, $10
	ld hl, JumpChannelData
	call Jmp_69C6
	ld hl, $DFE4
	ld [hl], $0A
	inc l
	ld [hl], $86
	ret

ContinueJumpSFX:: ; 67C4
	call updateSoundProgress
	and a
	jp z, ContinueSquareSFX.stop
	ld hl, $DFE4
	ld e, [hl]
	inc l
	ld d, [hl]
	push hl
	ld hl, $000F		; some sort of sweep implementation
	add hl, de
	ld c, LOW(rNR13)
	ld a, l
	ld [$FF00+c], a
	ld b, a
	inc c
	ld a, h
	and a, $3F
	ld [$FF00+c], a		; rNR14
	pop hl
	ldd [hl], a
	ld [hl], b
	ret

StartSuperballSFX:: ; 67E4
	call Call_6791.jmp_6796
	ret z
	ld a, $03
	ld hl, SuperballChannelData
	jp Jmp_69C6

ContinueSquareSFX:
	call updateSoundProgress
	and a
	ret nz
.stop
	xor a
	ld [$DFE1], a
	ldh [rNR10], a
	ld a, $08
	ldh [rNR12], a
	ld a, $80
	ldh [rNR14], a
	ld hl, $DF1F
	res 7, [hl]				; unlock
	ret

CoinChannelData1::
	db $00, $80, $E2, $06, $87 ; 524.3 Hz ~ C5
CoinChannelData2::
	db $00, $80, $E2, $83, $87 ; 1049 Hz ~ C6

StartCoinSFX:: ; 6813
	call Call_6791
	ret z
	ld hl, CoinChannelData1
	jp Jmp_69C6

ContinueCoinSFX:: ; 681D
	ld hl, $DFE4
	inc [hl]
	ld a, [hl]
	cp a, $04
	jr z, .secondTone
	cp a, $18
	jp z, ContinueSquareSFX.stop
	ret

.secondTone
	ld hl, CoinChannelData2
	call SetupChannel.square1
	ret

StompChannelData1::
	db $57, $96, $8C, $30, $C7 ; 630 Hz
StompChannelData2::
	db $57, $96, $8C, $35, $C7 ; 645 Hz

StartStompSFX:: ; 683D
	call Call_6791.jmp_679C
	ret z
	ld a, $08
	ld hl, StompChannelData1
	jp Jmp_69C6

ContinueStompSFX:: ; 6849
	call updateSoundProgress
	and a
	ret nz
	ld hl, $DFE4
	ld a, [hl]
	inc [hl]
	cp a, $00
	jr z, .jmp_685D
	cp a, $01
	jp z, ContinueSquareSFX.stop
	ret

.jmp_685D
	ld hl, StompChannelData2
	jp SetupChannel.square1

FlowerChannelData:: ; 6863
	db $54, $00, $9A, $20, $87 ; 585.1 Hz ~ D5 (though 721 is closer)

StartFlowerSFX:: ; 6868
	ld a, $60
	ld [$DFE6], a
	ld a, $05
	ld hl, FlowerChannelData
	jp Jmp_69C6

GrowChannelData:
	db $27, $80, $8A, $10, $86 ; 264.3 Hz ~ C4 (17 cents off though)

StartGrowSFX:: ; 687A
	ld a, $10
	ld [$DFE6], a
	ld a, $05
	ld hl, GrowChannelData
	jp Jmp_69C6

ContinueSweepSquareSFX::
	call updateSoundProgress
	and a
	ret nz
	ld hl, $DFE6
	ld a, $10				; sweep frequency up
	add [hl]
	ld [hl], a
	cp a, $E0
	jp z, ContinueSquareSFX.stop
	ld c, LOW(rNR13)
	ld [$FF00+c], a
	inc c
	ld a, $86
	ld [$FF00+c], a			; rNR14
	ret

BumpChannelData:: ; 
	db $2C, $80, $D3, $40, $84 ; 136.5 Hz

StartBumpSFX:: ; 68A5
	call Call_6791.jmp_679C
	ret z
	ld a, $08
	ld hl, BumpChannelData
	jp Jmp_69C6

InjuryChannelData::
	db $3A, $80, $E3, $20, $86 ; 273.1 Hz (one octave above the bump thing?)
InjuryEnvelopeData:
	db $F3, $B3, $A3, $93, $83, $73, $63, $53, $43, $33, $23, $23, $13, $00

StartInjurySFX::
	ld a, [$DFE1]
	cp a, SFX_1UP
	ret z
	ld a, $06
	ld hl, InjuryChannelData
	jp Jmp_69C6

ContinueInjurySFX::
	call updateSoundProgress
	and a
	ret nz
	ld hl, $DFE4
	ld c, [hl]
	inc [hl]
	ld b, $00
	ld hl, InjuryEnvelopeData
	add hl, bc
	ld a, [hl]
	and a
	jp z, ContinueSquareSFX.stop
	ld c, LOW(rNR12)
	ld [$FF00+c], a
	inc c
	inc c
	ld a, $87			; 609.6 Hz? Trigger
	ld [$FF00+c], a		; rNR14
	ret

StartOneUpSFX::
	ld a, $06
	ld hl, OneUpNote1
	jp Jmp_69C6

; Pentatonic riff. CDEGC'A in C major
OneUpNote1::
	db $00, $30, $F0, $A7, $C7 ; 1472 Hz ~ F#6
OneUpNote2::
	db $00, $30, $F0, $B1, $C7 ; 1659 Hz ~ G#6
OneUpNote3::
	db $00, $30, $F0, $BA, $C7 ; 1872 Hz ~ A#6
OneUpNote4::
	db $00, $30, $F0, $C4, $C7 ; 2184 Hz ~ C#7 (25 cents flat, bug, 7C5 is closer)
OneUpNote5::
	db $00, $30, $F0, $D4, $C7 ; 2978 Hz ~ F#7 (11 cents sharp)
OneUpNote6::
	db $00, $30, $F0, $CB, $C7 ; 2473 Hz ~ D#7 (11 cents flat)

ContinueOneUpSFX:: ; 6916
	call updateSoundProgress
	and a
	ret nz
	ld a, [$DFE4]		; when sound has ended, increment and load a new note
	inc a
	ld [$DFE4], a
	cp a, $01
	jr z, .playNote2
	cp a, $02
	jr z, .playNote3
	cp a, $03
	jr z, .playNote4
	cp a, $04
	jr z, .playNote5
	cp a, $05
	jr z, .playNote6
	jp ContinueSquareSFX.stop

.playNote2
	ld hl, OneUpNote2
	jr .playNote

.playNote3
	ld hl, OneUpNote3
	jr .playNote

.playNote4
	ld hl, OneUpNote4
	jr .playNote

.playNote5
	ld hl, OneUpNote5
	jr .playNote

.playNote6
	ld hl, OneUpNote6
.playNote
	jp SetupChannel.square1

ExplosionChannelData:: ; 6953
	db $00, $F4, $57, $80

StartExplosionSFX:: ; 6957
	ld a, $30
	ld hl, ExplosionChannelData
	jp Jmp_69C6

Call_695F:: ; 695F
	ld a, [$DFF9]
	cp a, SFX_EXPLOSION
	ret z
	ret

DeathCryChannelData:: ; 6966
	db $00, $2C, $1E, $80

; Death cry envelope of sorts? TODO
; first nibble: clock shift, increasing, 
; second nibble: width (always narrow), divisor code
Data_696A:: ; 696A
	db $1F, $2D, $2F, $3D, $3F, $00

StartDeathCrySFX:: ; 6970
	call Call_695F
	ret z
	ld a, $06
	ld hl, DeathCryChannelData
	jp Jmp_69C6

ContinueDeathCrySFX:: ; 697C
	call updateSoundProgress
	and a
	ret nz
	ld hl, $DFFC
	ld c, [hl]
	inc [hl]
	ld b, $00
	ld hl, Data_696A
	add hl, bc
	ld a, [hl]
	and a
	jr z, ContinueNoiseSFX.stop
	ldh [rNR43], a		; noise characteristics
	ret

FireBreathChannelData:: ; 6993
	db $00, $6D, $54, $80

StartFireBreathSFX:: ; 6997
	ld a, $16
	ld hl, FireBreathChannelData
	jp Jmp_69C6

BlockShatterChannelData:: ; 699F
	db $00, $F2, $55, $80

StartBrickShatterSFX:: ; 69A3
	call Call_695F
	ret z
	ld a, $15
	ld hl, BlockShatterChannelData
	jp Jmp_69C6

ContinueNoiseSFX:: ; 69AF
	call updateSoundProgress
	and a
	ret nz
.stop
	xor a
	ld [$DFF9], a
	ld a, $08
	ldh [rNR42], a		; mute noise channel, setup envelope?
	ld a, $80
	ldh [rNR44], a		; trigger noise, consecutive mode
	ld hl, $DF4F		; noise?
	res 7, [hl]
	ret

; write SFX data to the channels (from where?)
; DE starts at DFxx + 2 (DFE2, DFFA, like that)
Jmp_69C6:: ; 69C6
	push af
	dec e			; using DFE- as example, but it holds for other engines as well
	ldh a, [$FFD1]
	ld [de], a		; DFE1 - currently playing sound
	inc e
	pop af
	inc e
	ld [de], a		; DFE3 - sound duration
	dec e
	xor a
	ld [de], a		; DFE2 - position
	inc e
	inc e
	ld [de], a		; DFE4
	inc e
	ld [de], a		; DFE5
	ld a, e
	cp a, $E5
	jr z, SetupChannel.square1
	cp a, $F5
	jr z, SetupChannel.wave
	cp a, $FD
	jr z, SetupChannel.noise
	ret

; copy HL to channel registers
SetupChannel:: ; 69E5
.square1
	push bc
	ld c, LOW(rNR10)
	ld b, $05
	jr .loopCopy

.square2
	push bc
	ld c, LOW(rNR21)
	ld b, $04
	jr .loopCopy

.wave
	push bc
	ld c, LOW(rNR30)
	ld b, $05
	jr .loopCopy

.noise
	push bc
	ld c, LOW(rNR41)
	ld b, $04
.loopCopy				; copy B bytes from HL to the channel in C
	ldi a, [hl]
	ld [$FF00+c], a
	inc c
	dec b
	jr nz, .loopCopy
	pop bc
	ret

; do a lookup in HL
LookupSoundPointer:: ; 6A07
	inc e
	ldh [$FFD1], a
.lookup
	inc e
	dec a				; go from 1-based to 0-based
	sla a				; a pointer is two bytes
	ld c, a
	ld b, $00
	add hl, bc
	ld c, [hl]
	inc hl
	ld b, [hl]			; load in BC
	ld l, c
	ld h, b
	ld a, h				; HL ← BC
	ret

updateSoundProgress:: ;; 6A19
	push de			; DE is DFE0(or other) + 2 here
	ld l, e
	ld h, d			; HL ← DE
	inc [hl]		; increment position
	ldi a, [hl]
	cp [hl]			; and compare with sound length
	jr nz, .out
	dec l			; end of sound, return zero
	xor a
	ld [hl], a
.out
	pop de
	ret

; copy HL to wave pattern
SetupWavePattern:: ; 6A26
	push bc
	ld c, $30		; FF30 Wave pattern RAM
.loop
	ldi a, [hl]
	ld [$FF00+c], a
	inc c
	ld a, c
	cp a, $40
	jr nz, .loop
	pop bc
	ret

_InitSound:: ; 6A33
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
.muteChannels
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

PlaySquareSFX:: ; 6A6A
	ld de, $DFE0			; non zero to start sfx
	ld a, [de]
	and a
	jr z, .continue			; if zero, play the current sound
	cp a, 12
	jr nc, .continue		; bounds check, 11 sound effects in this "channel"
	ld hl, $DF1F			; lock square channel 1
	set 7, [hl]
	ld hl, Data_6600
	call LookupSoundPointer	; also sets FFD1
	jp hl

.continue
	inc e
	ld a, [de]
	and a
	jr z, .out
	ld hl, Data_6616
	call LookupSoundPointer.lookup
	jp hl

.out					; RET Z? Bug
	ret

PlayNoiseSFX:: ; 6A8E
	ld de, $DFF8
	ld a, [de]
	and a
	jr z, .continue
	cp a, 5
	jr nc, .continue
	ld hl, $DF4F
	set 7, [hl]			; lock noise channel
	ld hl, Data_662C
	call LookupSoundPointer
	jp hl

.continue
	inc e
	ld a, [de]
	and a
	jr z, .out
	ld hl, Data_6634
	call LookupSoundPointer.lookup
	jp hl

.out				; forgot about RET Z? Bug
	ret

_Unreachable: ; 6AB2
	jp _InitSound

StartMusic:: ; 6AB5
	ld hl, $DFE8
	ldi a, [hl]
	and a
	ret z
	cp a, $14
	ret nc				; 19 songs, bounds check
	ld [hl], a			; DFE9
	cp a, $FF			; Can never be true. Possibly -1 was used as a sentinel
	jr z, _Unreachable	; to stop all sound, like in Pokemon
	ld b, a
	ld hl, Data_663C
	ld a, b
	and a, $1F			; Huh?
	call LookupSoundPointer.lookup
	call Call_6B8C
	jp .initStereo		; Weird

.initStereo
	ld a, [$DFE9]
	ld hl, StereoData
.loop
	dec a
	jr z, .writeStereoData
	inc hl
	inc hl
	inc hl
	inc hl
	jr .loop

.writeStereoData
	ldi a, [hl]
	ldh [hMonoOrStereo], a
	ldi a, [hl]
	ldh [hPanInterval], a
	ldi a, [hl]
	ldh [hChannelEnableMask1], a
	ldh [rNR51], a
	ldi a, [hl]
	ldh [hChannelEnableMask2], a
	xor a
	ldh [hPanTimer], a
	ldh [hPanCounter], a
	ret

PanExplosion:: ; 6AF6
	ld a, [$DFF9]
	cp a, SFX_EXPLOSION		; Hmh?
	ret nz
	ld a, [hl]				; Always FFD5. Bug
	bit 1, a				; Every two ticks?
	ld a, $F7				; Noise left enable
	jr z, .applyMask
	ld a, $7F				; Noise right enable
.applyMask
	call PanStereo.applyChannelEnableMasks
.ret
	ret

PanStereo:: ; 6B09
	ld a, [$DFE9]
	and a
	ret z
	ldh a, [hMonoOrStereo]
	cp a, $01				; 01 = Mono, 02 = Stereo
	jr z, PanExplosion.ret	; Bug... RET Z
	ld hl, hPanTimer
	call PanExplosion		; Skips over following code if explosion is playing
	inc [hl]				; FFD5 - hPanTimer
	ldi a, [hl]
	cp [hl]					; FFD6 - hPanInterval
	ret nz
	dec l
	ld [hl], $00			; FFD5 - hPanTimer
	inc l
	inc l
	inc [hl]				; FFD7 - hPanCounter
	ldh a, [hChannelEnableMask1]
	bit 0, [hl]				; Counter is only used for its lowest bit... Bug
	jr z, .applyChannelEnableMasks
	ldh a, [hChannelEnableMask2]
.applyChannelEnableMasks
	ldh [rNR51], a
	ret

; Four bytes:
; 1: hMonoOrStereo - 01 if mono, 02 if stereo
; 2: hPanInterval - Ticks between panning
; 3: hChannelEnableMask1
; 4: hChannelEnableMask2
; Quite some unused masks. Bug?
StereoData:: ; 6B2F
	db $02, $24, $ED, $DE	; Music 1
	db $01, $18, $BD, $00
	db $02, $20, $7F, $B7
	db $01, $18, $ED, $7F
	db $01, $18, $FF, $F7	; Music 5
	db $02, $40, $7F, $F7
	db $02, $40, $7F, $F7
	db $01, $18, $FF, $F7
	db $01, $10, $FF, $A5
	db $01, $00, $65, $00	; Music 10
	db $01, $00, $FF, $00
	db $02, $08, $7F, $B5
	db $01, $00, $ED, $00
	db $01, $00, $ED, $00
	db $01, $00, $FF, $00	; Music 15
	db $01, $00, $ED, $00
	db $02, $18, $7E, $E7
	db $01, $18, $ED, $E7
	db $01, $00, $DE, $00	; Music 19

; copy 2 bytes from the address at HL to DE
CopyPointerIndirect:: ; 6B7B
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
CopyPointer:: ; 6B86
	ldi a, [hl]
	ld [de], a
	inc e
	ldi a, [hl]
	ld [de], a
	ret

; setup array of addresses and such at DF00-DF4F
; HL contains the pointer from Data_663C
Call_6B8C::; 6B8C
	call _InitSound.muteChannels
	xor a
	ldh [$FFD5], a
	ldh [$FFD7], a
	ld de, $DF00
	ld b, $00
	ldi a, [hl]
	ld [de], a				; byte 0 goes into DF00 (unused, always zero?)
	inc e
	call CopyPointer			; byte 1,2 into DF01, DF02
	ld de, $DF10
	call CopyPointer			; byte 3,4 DF10
	ld de, $DF20
	call CopyPointer			; byte 5,6 DF20
	ld de, $DF30
	call CopyPointer			; byte 7,8 DF30
	ld de, $DF40
	call CopyPointer			; byte 9,10 DF40
	ld hl, $DF10			; 
	ld de, $DF14
	call CopyPointerIndirect
	ld hl, $DF20
	ld de, $DF24
	call CopyPointerIndirect
	ld hl, $DF30
	ld de, $DF34
	call CopyPointerIndirect
	ld hl, $DF40
	ld de, $DF44
	call CopyPointerIndirect
	ld bc, $0410		; 4 loops, $10 bytes between each DFx2
	ld hl, $DF12
.loop
	ld [hl], $01		; set them all to 1
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

Jmp_6BF4: ; 6BF4
	push hl
	xor a
	ldh [rNR30], a		; disable wave channel
	ld l, e
	ld h, d
	call SetupWavePattern
	pop hl
	jr Jmp_6C00.jmp_6C2A

Jmp_6C00: ; 6C00
	call IncrementPointer
	call LoadFromHLindirect
	ld e, a
	call IncrementPointer
	call LoadFromHLindirect
	ld d, a
	call IncrementPointer
	call LoadFromHLindirect
	ld c, a
	inc l
	inc l
	ld [hl], e					; DFx6- will go into NRx2
	inc l
	ld [hl], d					; DFx7 - always 0 or 6F
	inc l
	ld [hl], c					; DFx8 - will go into NRx1
	dec l
	dec l
	dec l
	dec l
	push hl
	ld hl, hCurrentChannel		; unnecessary, it's in HRAM. Bug
	ld a, [hl]
	pop hl
	cp a, 3						; wave channel
	jr z, Jmp_6BF4
.jmp_6C2A
	call IncrementPointer
	jp PlayMusic.jmp_6CD7

; increment the address located at HL
IncrementPointer:: ; 6C30
	push de
	ldi a, [hl]
	ld e, a
	ldd a, [hl]
	ld d, a
	inc de
.storeDE
	ld a, e
	ldi [hl], a
	ld a, d
	ldd [hl], a
	pop de
	ret

IncrementPointerTwice:: ; 6C3C
	push de
	ldi a, [hl]
	ld e, a
	ldd a, [hl]
	ld d, a
	inc de
	inc de
	jr IncrementPointer.storeDE

; todo name
LoadFromHLindirect:: ; 6C45
	ldi a, [hl]
	ld c, a
	ldd a, [hl]
	ld b, a				; BC ← [HL]
	ld a, [bc]			; A ← [BC]
	ld b, a				; B ← [BC]
	ret

Jmp_6C4C:
	pop hl
	jr .jmp_6C7A

.jmp_6C4F
	ldh a, [hCurrentChannel]
	cp a, $03			; wave
	jr nz, .jmp_6C65
	ld a, [$DF38]
	bit 7, a
	jr z, .jmp_6C65
	ld a, [hl]			; DF32?
	cp a, $06
	jr nz, .jmp_6C65
	ld a, $40
	ldh [rNR32], a		; wave channel volume
.jmp_6C65
	push hl
	ld a, l
	add a, $09
	ld l, a
	ld a, [hl]			; DFxB
	and a
	jr nz, Jmp_6C4C
	ld a, l
	add a, $04
	ld l, a
	bit 7, [hl]			; DFxF lock status
	jr nz, Jmp_6C4C		; jump if locked
	pop hl
	call PlayMusic.jmp_6DDC
.jmp_6C7A
	dec l
	dec l
	jp PlayMusic.nextChannel

.jmp_6C7F
	dec l
	dec l
	dec l
	dec l
	call IncrementPointerTwice
.jmp_6C86
	ld a, l
	add a, $04
	ld e, a
	ld d, h
	call CopyPointerIndirect
	cp a, $00
	jr z, .stopSong
	cp a, $FF
	jr z, .restartChannel
	inc l
	jp PlayMusic.jmp_6CD5

.restartChannel
	dec l
	push hl
	call IncrementPointerTwice		; skip over FFFF
	call LoadFromHLindirect
	ld e, a
	call IncrementPointer
	call LoadFromHLindirect
	ld d, a						; DE is restart pointer
	pop hl
	ld a, e
	ldi [hl], a					; put it in DFx0-DFx1
	ld a, d
	ldd [hl], a
	jr .jmp_6C86

.stopSong
	ld hl, $DFE9
	ld [hl], $00
	ld a, $FF
	ldh [rNR51], a
	call _InitSound.muteChannels
	ret

PlayMusic:: ; 6CBE
	ld hl, $DFE9				; music currently playing
	ld a, [hl]
	and a
	ret z
	ld a, 1						; start from channel 1, square (with sweep)
	ldh [hCurrentChannel], a
	ld hl, $DF10
.jmp_6CCB
	inc l
	ldi a, [hl]					; DFx1
	and a
	jp z, Jmp_6C4C.jmp_6C7A
	dec [hl]					; DFx2
	jp nz, Jmp_6C4C.jmp_6C4F
.jmp_6CD5
	inc l
	inc l
.jmp_6CD7
	call LoadFromHLindirect		; DFx4 - DFx5
	cp a, $00					; stores a copy in B
	jp z, Jmp_6C4C.jmp_6C7F
	cp a, $9D
	jp z, Jmp_6C00
	and a, $F0
	cp a, $A0					; set note length?
	jr nz, .jmp_6D04
	ld a, b
	and a, $0F
	ld c, a
	ld b, $00
	push hl
	ld de, $DF01
	ld a, [de]
	ld l, a
	inc de
	ld a, [de]
	ld h, a						; HL ← note lengths pointer?
	add hl, bc
	ld a, [hl]
	pop hl
	dec l
	ldi [hl], a					; DFx3
	call IncrementPointer
	call LoadFromHLindirect		; DFx4 - DFx5
.jmp_6D04
	ld a, b
	ld c, a
	ld b, $00
	call IncrementPointer		; DFx4 - DFx5
	ldh a, [hCurrentChannel]
	cp a, 4						; Noise
	jp z, .jmp_6D34
	push hl
	ld a, l
	add a, $05
	ld l, a
	ld e, l
	ld d, h						; DFx9
	inc l
	inc l
	ld a, c
	cp a, $01
	jr z, .jmp_6D2F
	ld [hl], 00					; DFxB
	ld hl, NotePitches
	add hl, bc
	ldi a, [hl]
	ld [de], a					; DFx9
	inc e
	ld a, [hl]
	ld [de], a					; DFxA
	pop hl
	jp .jmp_6D4B

.jmp_6D2F
	ld [hl], $01
	pop hl
	jr .jmp_6D4B

.jmp_6D34						; Noisy stuff
	push hl
	ld de, $DF46				; volume (envelope)?
	ld hl, Data_6F06
	add hl, bc
.loop
	ldi a, [hl]
	ld [de], a
	inc e
	ld a, e
	cp a, $4B
	jr nz, .loop
	ld c, LOW(rNR41)
	ld hl, $DF44
	jr .jmp_6D78

.jmp_6D4B
	push hl
	ldh a, [hCurrentChannel]
	cp a, 1					; Square 1
	jr z, .jmp_6D73
	cp a, 2					; Square 2
	jr z, .jmp_6D6F
	ld c, LOW(rNR30)		; Wave
	ld a, [$DF3F]			; Lock
	bit 7, a
	jr nz, .jmp_6D64
	xor a
	ld [$FF00+c], a
	ld a, $80
	ld [$FF00+c], a
.jmp_6D64
	inc c
	inc l
	inc l
	inc l
	inc l
	ldi a, [hl]
	ld e, a
	ld d, $00
	jr .jmp_6D84

.jmp_6D6F
	ld c, LOW(rNR21)
	jr .jmp_6D78

.jmp_6D73
	ld c, LOW(rNR10)
	ld a, $00
	inc c
.jmp_6D78
	inc l
	inc l
	inc l
	ldd a, [hl]				; DFx7
	and a
	jr nz, .jmp_6DCE
	ldi a, [hl]				; DFx6
	ld e, a
.jmp_6D81
	inc l
	ldi a, [hl]				; DFx8
	ld d, a
.jmp_6D84
	push hl
	inc l
	inc l
	ldi a, [hl]				; DFxB
	and a
	jr z, .jmp_6D8D
	ld e, $08
.jmp_6D8D
	inc l
	inc l
	ld [hl], $00			; DFxE
	inc l
	ld a, [hl]				; DFxF lock
	pop hl
	bit 7, a
	jr nz, .resetNoteTimer	; don't update the channel registers when locked
	ld a, d
	ld [$FF00+c], a			; NRx1
	inc c
	ld a, e
	ld [$FF00+c], a			; NRx2
	inc c
	ldi a, [hl]				; DFx9 freq lo
	ld [$FF00+c], a			; NRx3
	inc c
	ld a, [hl]				; DFxA freq hi
	or a, $80				; trigger
	ld [$FF00+c], a			; NRx4
	ld a, l
	or a, $05				; euhm
	ld l, a
	res 0, [hl]				; DFxF lock? lowest bit
.resetNoteTimer
	pop hl
	dec l
	ldd a, [hl]				; DFx4 - note length
	ldd [hl], a				; DFx3 - note timer
	dec l
.nextChannel
	ld de, hCurrentChannel
	ld a, [de]
	cp a, 4
	jr z, .jmp_6DC1			; done after 4 channels
	inc a
	ld [de], a
	ld de, $0010
	add hl, de
	jp .jmp_6CCB

.jmp_6DC1
	ld hl, $DF1E
	inc [hl]
	ld hl, $DF2E
	inc [hl]
	ld hl, $DF3E
	inc [hl]
	ret

.jmp_6DCE
	ld b, $00
	inc l
	jr .jmp_6D81

.call_6DD3
	ld a, b
	srl a
	ld l, a
	ld h, $00
	add hl, de
	ld e, [hl]
	ret

.jmp_6DDC
	push hl
	ld a, l
	add a, $06
	ld l, a
	ld a, [hl]				; DFx8
	and a, $0F
	jr z, .jmp_6DFC
	ldh [$FFD1], a
	ldh a, [hCurrentChannel]
	ld c, LOW(rNR13)
	cp a, $01				; square 1
	jr z, .jmp_6DFE
	ld c, LOW(rNR23)
	cp a, $02				; square 2
	jr z, .jmp_6DFE
	ld c, LOW(rNR33)
	cp a, $03				; wave
	jr z, .jmp_6DFE
.jmp_6DFC
	pop hl
	ret

.jmp_6DFE
	inc l
	ldi a, [hl]				; DFx9 freq lo
	ld e, a
	ld a, [hl]				; DFxA freq hi
	ld d, a
	push de					; DE ← frequency
	ld a, l
	add a, $04
	ld l, a
	ld b, [hl]				; DFxE
	ldh a, [$FFD1]
	cp a, $01				; wut
	jr .jmp_6E18			; huh?

.jmp_6E0F
	cp a, $03
	jr .jmp_6E13			; huh?

.jmp_6E13
	ld hl, $FFFF
	jr .jmp_6E34

.jmp_6E18
	ld de, Data_6E3D
	call .call_6DD3			; loads the value at DE + B/2 into E
	bit 0, b				; if B is even
	jr nz, .jmp_6E24
	swap e					; select high nibble
.jmp_6E24
	ld a, e
	and a, $0F				; lower nibble
	bit 3, a
	jr z, .jmp_6E31
	ld h, $FF
	or a, $F0
	jr .jmp_6E33

.jmp_6E31
	ld h, $00
.jmp_6E33
	ld l, a
.jmp_6E34
	pop de
	add hl, de
	ld a, l
	ld [$FF00+c], a		; freq lo
	inc c
	ld a, h
	ld [$FF00+c], a		; freq hi
	jr .jmp_6DFC

Data_6E3D:: ; 6E3D
	db $00, $00, $00, $00, $00
	db $00, $10, $00, $0F, $00, $00, $11, $00, $0F, $F0
	db $01, $12, $10, $FF, $EF, $01, $12, $10, $FF, $EF
	db $01, $12, $10, $FF, $EF, $01, $12, $10, $FF, $EF
	db $01, $12, $10, $FF, $EF, $01, $12, $10, $FF, $EF
	db $01, $12, $10, $FF, $EF, $01, $12, $10, $FF, $EF

; Chromatic pitches. The number in brackets shows how many cents the pitch
; is off from ideal
NotePitches:: ; 6E74
	dw $F00 ; Bug? Functions as $700, 512 Hz (no note)
	dw $02C ;   65.4 Hz C 2 (-0)
	dw $09C ;   69.3 Hz C#2 (-0) Bug! 09D is closer
	dw $106 ;   73.4 Hz D 2 (-1) Bug! 107 is closer
	dw $16B ;   77.8 Hz D#2 (+0)
	dw $1C9 ;   82.4 Hz E 2 (-0)
	dw $223 ;   87.3 Hz F 2 (+0)
	dw $277 ;   92.5 Hz F#2 (+0)
	dw $2C6 ;   98.0 Hz G 2 (-1) Bug! 2C7 is closer
	dw $312 ;  103.9 Hz G#2 (+1)
	dw $356 ;  109.8 Hz A 2 (-4) Bug! 357 is closer
	dw $39B ;  116.5 Hz A#2 (-0)
	dw $3DA ;  123.4 Hz B 2 (-1)
	dw $416 ;  130.8 Hz C 3 (-0)
	dw $44E ;  138.6 Hz C#3 (-0)
	dw $483 ;  146.8 Hz D 3 (-1)
	dw $4B5 ;  155.5 Hz D#3 (-1)
	dw $4E5 ;  164.9 Hz E 3 (+1)
	dw $511 ;  174.5 Hz F 3 (-1)
	dw $53B ;  184.9 Hz F#3 (-1)
	dw $563 ;  195.9 Hz G 3 (-1)
	dw $589 ;  207.7 Hz G#3 (+1)
	dw $5AC ;  219.9 Hz A 3 (-1)
	dw $5CE ;  233.2 Hz A#3 (+1)
	dw $5ED ;  246.8 Hz B 3 (-1)
	dw $60A ;  261.1 Hz C 4 (-3) Bug! 60B is closer
	dw $627 ;  277.1 Hz C#4 (-0)
	dw $642 ;  293.9 Hz D 4 (+1)
	dw $65B ;  311.3 Hz D#4 (+1)
	dw $672 ;  329.3 Hz E 4 (-2)
	dw $689 ;  349.5 Hz F 4 (+1)
	dw $69E ;  370.3 Hz F#4 (+1)
	dw $6B2 ;  392.4 Hz G 4 (+2)
	dw $6C4 ;  414.8 Hz G#4 (-2)
	dw $6D6 ;  439.8 Hz A 4 (-1)
	dw $6E7 ;  466.4 Hz A#4 (+1)
	dw $6F7 ;  494.6 Hz B 4 (+3)
	dw $706 ;  524.3 Hz C 5 (+3)
	dw $714 ;  555.4 Hz C#5 (+3)
	dw $721 ;  587.8 Hz D 5 (+1)
	dw $72D ;  621.2 Hz D#5 (-3)
	dw $739 ;  658.7 Hz E 5 (-2)
	dw $744 ;  697.2 Hz F 5 (-3)
	dw $74F ;  740.5 Hz F#5 (+1)
	dw $759 ;  784.9 Hz G 5 (+2)
	dw $762 ;  829.6 Hz G#5 (-2)
	dw $76B ;  879.7 Hz A 5 (-1)
	dw $773 ;  929.6 Hz A#5 (-5)
	dw $77B ;  985.5 Hz B 5 (-4)
	dw $783 ; 1048.6 Hz C 6 (+3)
	dw $78A ; 1110.8 Hz C#6 (+3)
	dw $790 ; 1170.3 Hz D 6 (-6)
	dw $797 ; 1248.3 Hz D#6 (+5)
	dw $79D ; 1324.0 Hz E 6 (+7)
	dw $7A2 ; 1394.4 Hz F 6 (-3)
	dw $7A7 ; 1472.7 Hz F#6 (-9)
	dw $7AC ; 1560.4 Hz G 6 (-8)
	dw $7B1 ; 1659.1 Hz G#6 (-2)
	dw $7B6 ; 1771.2 Hz A 6 (+11)
	dw $7BA ; 1872.5 Hz A#6 (+7)
	dw $7BE ; 1985.9 Hz B 6 (+9)
	dw $7C1 ; 2080.5 Hz C 7 (-10)
	dw $7C4 ; 2184.5 Hz C#7 (-26) Bug! 7C5 is closer
	dw $7C8 ; 2340.6 Hz D 7 (-6)
	dw $7CB ; 2473.1 Hz D#7 (-11)
	dw $7CE ; 2621.4 Hz E 7 (-10)
	dw $7D1 ; 2788.8 Hz F 7 (-3)
	dw $7D4 ; 2978.9 Hz F#7 (+11)
	dw $7D6 ; 3120.8 Hz G 7 (-8)
	dw $7D9 ; 3360.8 Hz G#7 (+20)
	dw $7DB ; 3542.5 Hz A 7 (+11)
	dw $7DD ; 3744.9 Hz A#7 (+7)
	dw $7DF ; 3971.9 Hz B 7 (+9)

Data_6F06:: ; 6F06
	db $00
	db $00, $00, $00, $00, $C0 ; 1
	db $A1 ,$00, $3A, $00, $C0 ; 6
	db $B1, $00, $29, $01, $C0 ; 11
	db $81, $00, $29, $04, $C0 ; 16

TriangeWavePattern:: ; 6F1B
	db $01, $23, $45, $67, $89, $AB, $CD, $EF
	db $FE, $DC, $BA, $98, $76, $54, $32, $10

SawtoothWavePattern:: ; 6F2B
	db $01, $12, $23, $34, $45, $56, $67, $78
	db $89, $9A, $AB, $BC, $CD, $DD, $EE, $FF

WavePattern_6F3B:: ; 6F3B ~sum of three cosines.
	db $01, $23, $56, $78, $99, $98, $76, $67
	db $9A, $DF, $FE, $C9, $85, $42, $11, $00

BossCryWavePattern:: ; 6F4B
	db $01, $23, $45, $67, $89, $AB, $CC, $CD
	db $00, $0C, $B0, $BB, $00, $FB, $BB, $BB

; Note lengths?
Data_6F5B:: ; 6F5B
	db 2, 3, 6, 12, 24, 48
	db       9, 18, 36
	db    4, 8

Data_6F66:: ; 6F66
	db 2, 4,  8, 16, 32, 64
	db       12, 24, 48
	db    5, 10
	db 1

Data_6F72:: ; 6F72
	db 0, 5, 10, 20, 40, 80
	db       15, 30, 60

Data_6F7B:: ; 6F7B
	db 3, 6, 12, 24, 48, 96
	db       18, 36, 72
	db    8, 16

Data_6F86:: ; 6F86
	db 0, 7, 14, 28, 56, 112
	db       21, 42, 84

; Unused, 8/7 times slower than the previous one
Data_6F8F:: ; 6F8F
	db 4, 8, 16, 32, 64, 128
	db       24, 48, 96

SECTION "TODO name", ROMX[$7FF0], BANK[3]
; gets called from timer interrupt
Call_7FF0:: ; 7FF0
	jp _Call_7FF0

InitSound:: ; 7FF3
	jp _InitSound
