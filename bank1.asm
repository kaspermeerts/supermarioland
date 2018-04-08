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


INCBIN "baserom.gb", $4FB2, $5179 - $4FB2

SECTION "bank 1 levels", ROMX[$55BB], BANK[1]
INCBIN "baserom.gb", $55BB, $8000 - $55BB
