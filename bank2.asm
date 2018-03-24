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

INCBIN "baserom.gb", $9832, $791A - $5832

INCBIN "gfx/menuTiles1.2bpp"
INCBIN "gfx/menuTiles2.2bpp"
