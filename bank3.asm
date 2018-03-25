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

INCBIN "baserom.gb", $C823, $8000 - $4823
