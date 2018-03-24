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

INCBIN "baserom.gb", $C032, $8000 - $4032
