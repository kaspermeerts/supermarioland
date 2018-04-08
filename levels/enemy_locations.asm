INCLUDE "enemies.asm"

SECTION "level 1_1 enemies", ROMX[$6002], BANK[2]

level_1_1_enemies:
	db $0C, $0F, CHIBIBO
	db $0F, $0F, CHIBIBO | $80
	db $13, $0C, NOKOBON | $80
	db $21, $0C, CHIBIBO
	db $25, $0C, NOKOBON | $80
	db $28, $04, CHIBIBO
	db $29, $04, CHIBIBO
	db $2A, $06, NOKOBON | $80
	db $2D, $8B, FLY | $80
	db $32, $0F, NOKOBON | $80
	db $3B, $0F, NOKOBON
	db $3C, $0F, NOKOBON | $80
	db $3D, $0F, NOKOBON | $80
	db $40, $03, FLY | $80
	db $42, $0F, FLY | $80
	db $46, $8D, NOKOBON | $80
	db $4F, $0F, CHIBIBO
	db $52, $04, FLY | $80
	db $52, $8F, FLY
	db $53, $8D, NOKOBON | $80
	db $55, $0F, CHIBIBO
	db $57, $0C, NOKOBON | $80
	db $5D, $0C, CHIBIBO
	db $5E, $8C, CHIBIBO | $80
	db $60, $0C, CHIBIBO | $80
	db $62, $0C, CHIBIBO
	db $64, $0F, CHIBIBO
	db $69, $0F, CHIBIBO
	db $6D, $0F, NOKOBON | $80
	db $75, $0F, FLY
	db $78, $0F, NOKOBON | $80
	db $7A, $0F, FLY
	db $80, $0C, NOKOBON | $80
	db $81, $08, GAO | $80
	db $89, $03, FLY | $80
	db $8E, $87, HORIZONTAL_PLATFORM
	db $92, $84, VERTICAL_PLATFORM
	db $FF ; end of list
	db $FF ; end of list (again, sigh)

SECTION "level 1_2 enemies", ROMX[$6073], BANK[2]

level_1_2_enemies:
	db $0E, $0C, NOKOBON | $80
	db $10, $0A, NOKOBON | $80
	db $11, $05, BUNBUN | $80
	db $13, $08, CHIBIBO
	db $15, $06, BUNBUN | $80
	db $17, $08, BUNBUN
	db $18, $08, NOKOBON | $80
	db $1A, $07, BUNBUN | $80
	db $1C, $05, BUNBUN
	db $1E, $08, BUNBUN | $80
	db $22, $0C, NOKOBON
	db $24, $0A, NOKOBON
	db $27, $08, NOKOBON | $80
	db $2F, $04, NOKOBON
	db $2F, $08, NOKOBON | $80
	db $30, $08, CHIBIBO
	db $34, $85, HORIZONTAL_PLATFORM
	db $37, $8A, HORIZONTAL_PLATFORM
	db $39, $04, BUNBUN | $80
	db $3E, $08, NOKOBON | $80
	db $3F, $08, BUNBUN | $80
	db $42, $07, BUNBUN | $80
	db $44, $06, BUNBUN
	db $47, $06, BUNBUN
	db $49, $04, BUNBUN | $80
	db $4B, $08, NOKOBON | $80
	db $4C, $07, BUNBUN | $80
	db $4E, $05, BUNBUN
	db $50, $08, BUNBUN
	db $53, $0F, NOKOBON | $80
	db $58, $0C, CHIBIBO
	db $59, $89, CHIBIBO
	db $5D, $88, HORIZONTAL_PLATFORM
	db $60, $04, HORIZONTAL_PLATFORM
	db $62, $89, HORIZONTAL_PLATFORM
	db $67, $04, BUNBUN | $80
	db $68, $8B, NOKOBON
	db $6B, $04, BUNBUN
	db $6C, $08, NOKOBON | $80
	db $74, $0A, VERTICAL_PLATFORM
	db $7E, $0C, NOKOBON | $80
	db $7F, $0A, BUNBUN
	db $81, $06, BUNBUN
	db $84, $07, HORIZONTAL_PLATFORM
	db $87, $85, DROP_BLOCK
	db $88, $05, DROP_BLOCK
	db $FF ; end of list

SECTION "level 1_3 enemies", ROMX[$60FE], BANK[2]

level_1_3_enemies:
	db $0D, $4D, PAKKUN_FLOWER
	db $0F, $0A, NOKOBON | $80
	db $13, $0F, NOKOBON | $80
	db $1B, $06, FALLING_SLAB
	db $1C, $06, FALLING_SLAB
	db $1D, $4F, PAKKUN_FLOWER
	db $1F, $0D, CHIBIBO | $80
	db $24, $4F, PAKKUN_FLOWER
	db $27, $4F, PAKKUN_FLOWER | $80
	db $28, $06, FALLING_SLAB | $80
	db $28, $4D, PAKKUN_FLOWER
	db $2A, $0F, NOKOBON | $80
	db $2F, $08, FALLING_SLAB | $80
	db $30, $08, FALLING_SLAB
	db $31, $08, FALLING_SLAB | $80
	db $32, $CE, PAKKUN_FLOWER
	db $35, $0B, NOKOBON | $80
	db $37, $4C, PAKKUN_FLOWER
	db $39, $CD, PAKKUN_FLOWER
	db $40, $04, FALLING_SLAB
	db $41, $04, FALLING_SLAB
	db $42, $8D, GAO | $80
	db $4A, $0B, GAO | $80
	db $4C, $8D, GAO
	db $51, $04, FALLING_SLAB | $80
	db $52, $04, FALLING_SLAB | $80
	db $54, $44, PAKKUN_FLOWER | $80
	db $55, $85, FALLING_SLAB | $80
	db $5E, $0C, NOKOBON
	db $5E, $0E, CHIBIBO | $80
	db $61, $84, FALLING_SLAB | $80
	db $62, $84, FALLING_SLAB | $80
	db $65, $84, FALLING_SLAB
	db $66, $84, FALLING_SLAB
	db $67, $84, FALLING_SLAB
	db $69, $10, NOKOBON | $80
	db $6F, $0A, GAO | $80
	db $75, $8D, DROP_BLOCK
	db $76, $0D, DROP_BLOCK
	db $76, $8D, DROP_BLOCK
	db $77, $0D, DROP_BLOCK
	db $77, $8D, DROP_BLOCK
	db $7D, $8E, GAO
	db $80, $0D, GAO | $80
	db $87, $8E, GAO | $80
	db $8A, $0D, GAO
	db $8D, $05, FALLING_SLAB | $80
	db $92, $0D, KING_TOTOMESU
	db $FF ; end of list
	db $FF ; end of list (again, sigh)

SECTION "level 2_1 enemies", ROMX[$5179], BANK[1]

level_2_1_enemies:
	db $0E, $13, HONEN
	db $10, $13, HONEN
	db $11, $0D, NOKOBON | $80
	db $12, $04, NOKOBON | $80
	db $17, $0B, NOKOBON | $80
	db $1A, $93, HONEN
	db $1B, $05, NOKOBON | $80
	db $1C, $93, HONEN
	db $21, $09, VERTICAL_PLATFORM
	db $25, $06, VERTICAL_PLATFORM
	db $2A, $0F, NOKOBON | $80
	db $2D, $0C, NOKOBON | $80
	db $2E, $13, CHIBIBO
	db $2F, $05, NOKOBON | $80
	db $34, $13, HONEN
	db $37, $13, HONEN
	db $3A, $13, HONEN
	db $3D, $13, HONEN
	db $40, $13, HONEN
	db $41, $08, NOKOBON
	db $43, $13, HONEN
	db $47, $93, HONEN
	db $49, $93, HONEN
	db $4C, $13, YURARIN_BOO | $80
	db $4E, $13, HONEN
	db $51, $07, CHIBIBO
	db $52, $07, CHIBIBO
	db $57, $04, CHIBIBO
	db $58, $04, CHIBIBO
	db $59, $04, CHIBIBO
	db $5C, $93, HONEN
	db $5E, $93, HONEN
	db $60, $93, HONEN
	db $62, $93, HONEN
	db $66, $93, HONEN
	db $68, $93, HONEN
	db $6A, $93, YURARIN_BOO
	db $6C, $93, HONEN | $80
	db $6F, $4E, PAKKUN_FLOWER
	db $71, $0F, NOKOBON | $80
	db $78, $07, CHIBIBO
	db $79, $07, CHIBIBO
	db $7D, $0B, NOKOBON | $80
	db $7D, $87, NOKOBON | $80
	db $7F, $04, CHIBIBO
	db $80, $04, CHIBIBO | $80
	db $84, $13, HONEN | $80
	db $87, $13, YURARIN_BOO
	db $88, $08, NOKOBON | $80
	db $8B, $93, YURARIN_BOO
	db $8E, $0F, NOKOBON | $80
	db $90, $08, HORIZONTAL_PLATFORM
	db $98, $08, HORIZONTAL_PLATFORM
	db $99, $10, NOKOBON | $80
	db $9C, $05, DROP_BLOCK
	db $9C, $85, DROP_BLOCK
	db $FF ; end of list

SECTION "level 2_2 enemies", ROMX[$5222], BANK[1]

level_2_2_enemies:
	db $0C, $0C, MEKABON
	db $12, $0C, NOKOBON | $80
	db $16, $0B, CHIBIBO
	db $17, $07, NOKOBON
	db $1D, $0B, NOKOBON
	db $22, $07, VERTICAL_PLATFORM
	db $23, $13, YURARIN_BOO | $80
	db $27, $07, VERTICAL_PLATFORM
	db $2A, $0D, NOKOBON
	db $31, $09, MEKABON
	db $36, $09, NOKOBON
	db $37, $0E, CHIBIBO
	db $3A, $09, CHIBIBO | $80
	db $3E, $09, MEKABON
	db $41, $0E, CHIBIBO
	db $44, $09, CHIBIBO | $80
	db $46, $09, NOKOBON
	db $48, $09, MEKABON
	db $4B, $0E, CHIBIBO
	db $57, $8F, NOKOBON
	db $58, $0E, NOKOBON | $80
	db $59, $0C, CHIBIBO
	db $5B, $13, YURARIN_BOO
	db $60, $8F, MEKABON
	db $65, $85, HORIZONTAL_PLATFORM
	db $6B, $0A, VERTICAL_PLATFORM
	db $70, $0D, NOKOBON
	db $71, $13, YURARIN_BOO | $80
	db $73, $13, YURARIN_BOO
	db $77, $4B, PAKKUN_FLOWER
	db $78, $09, NOKOBON | $80
	db $79, $8B, CHIBIBO
	db $7A, $C9, PAKKUN_FLOWER
	db $7D, $05, NOKOBON
	db $7F, $05, NOKOBON | $80
	db $83, $13, YURARIN_BOO | $80
	db $87, $85, DROP_BLOCK
	db $88, $03, VERTICAL_PLATFORM
	db $88, $89, DROP_BLOCK
	db $89, $8D, DROP_BLOCK
	db $FF ; end of list

SECTION "level 2_3 enemies", ROMX[$529B], BANK[1]

level_2_3_enemies:
	db $0F, $05, ENEMY_2F | $80
	db $19, $0E, ENEMY_2F
	db $1B, $53, HONEN
	db $23, $0E, YURARIN | $80
	db $25, $0B, YURARIN
	db $27, $08, YURARIN | $80
	db $29, $05, YURARIN
	db $2D, $08, ENEMY_2F
	db $2F, $53, HONEN
	db $39, $53, HONEN
	db $3B, $05, YURARIN
	db $3E, $05, YURARIN | $80
	db $40, $0D, YURARIN
	db $43, $0D, YURARIN | $80
	db $43, $13, HONEN
	db $49, $07, YURARIN
	db $4D, $13, HONEN
	db $4E, $07, ENEMY_2F
	db $54, $08, GUNION
	db $57, $08, YURARIN
	db $5F, $09, GUNION
	db $69, $07, GUNION
	db $69, $0D, GUNION
	db $73, $07, ENEMY_2F
	db $75, $13, YURARIN_BOO
	db $78, $0C, YURARIN
	db $7F, $13, YURARIN_BOO
	db $85, $0A, GUNION
	db $88, $0C, ENEMY_2F
	db $89, $13, YURARIN_BOO | $80
	db $8E, $0F, YURARIN
	db $92, $0F, YURARIN | $80
	db $9B, $0D, GUNION
	db $9C, $0F, YURARIN | $80
	db $A5, $07, GUNION | $80
	db $A8, $0F, YURARIN
	db $AE, $0B, TAMAO
	db $AF, $0A, TAMAO | $80
	db $B0, $0C, DRAGONZAMASU
	db $FF ; end of list

SECTION "level 3_1 enemies", ROMX[$4E74], BANK[3]

level_3_1_enemies:
	db $0F, $0F, BATADON
	db $10, $4F, PIPE_CANNON | $80
	db $14, $0F, NOKOBON
	db $18, $0F, DROP_BLOCK
	db $18, $8F, DROP_BLOCK
	db $19, $0F, DROP_BLOCK
	db $19, $8F, DROP_BLOCK
	db $1A, $0F, DROP_BLOCK
	db $1A, $8F, DROP_BLOCK
	db $1D, $0F, NOKOBON
	db $1F, $07, BATADON | $80
	db $1F, $4E, PIPE_CANNON | $80
	db $23, $0F, NOKOBON | $80
	db $24, $4F, PIPE_CANNON
	db $31, $04, NOKOBON
	db $31, $04, BATADON
	db $34, $87, HORIZONTAL_PLATFORM
	db $37, $8A, SMALL_VERTICAL_PLATFORM
	db $3A, $89, HORIZONTAL_PLATFORM
	db $3C, $4F, PAKKUN_FLOWER
	db $3E, $8B, NOKOBON
	db $41, $09, NOKOBON | $80
	db $47, $4E, PAKKUN_FLOWER
	db $4C, $4F, PIPE_CANNON
	db $51, $0F, TOKOTOKO | $80
	db $53, $0F, NOKOBON
	db $57, $0E, TOKOTOKO
	db $58, $0F, NOKOBON
	db $5E, $8A, NOKOBON | $80
	db $60, $08, TOKOTOKO
	db $63, $04, BATADON
	db $6A, $08, NOKOBON
	db $6D, $04, BATADON
	db $71, $10, VERTICAL_PLATFORM
	db $72, $06, SMALL_VERTICAL_PLATFORM
	db $77, $06, VERTICAL_PLATFORM
	db $79, $4E, PIPE_CANNON
	db $7E, $4F, PIPE_CANNON
	db $86, $4A, PAKKUN_FLOWER
	db $88, $0F, TOKOTOKO
	db $89, $0F, TOKOTOKO
	db $89, $87, BATADON
	db $8A, $0F, TOKOTOKO
	db $8D, $87, NOKOBON | $80
	db $8E, $0F, BATADON
	db $90, $4A, PIPE_CANNON
	db $95, $0B, TOKOTOKO
	db $9B, $05, GANCHAN_SPAWN
	db $A5, $05, GANCHAN_SPAWN
	db $AF, $05, GANCHAN_SPAWN
	db $B9, $05, GANCHAN_SPAWN
	db $C3, $45, GANCHAN_SPAWN
	db $D7, $05, GANCHAN_SPAWN
	db $E1, $8A, SMALL_HORIZONTAL_PLATFORM
	db $E3, $07, DROP_BLOCK
	db $E4, $05, DROP_BLOCK
	db $FF ; end of list

SECTION "level 3_2 enemies", ROMX[$4F1D], BANK[3]

level_3_2_enemies:
	db $0C, $85, SUU
	db $0F, $10, NOKOBON
	db $10, $8C, NOKOBON | $80
	db $13, $05, SUU
	db $13, $0F, FLY | $80
	db $16, $0F, NOKOBON
	db $19, $88, SUU
	db $1A, $88, SUU
	db $1D, $4E, PAKKUN_FLOWER
	db $1E, $05, SUU
	db $20, $04, FALLING_SPIKE | $80
	db $21, $C4, PAKKUN_FLOWER
	db $28, $07, SUU
	db $2A, $0C, FLY
	db $2C, $0F, NOKOBON
	db $2D, $83, FALLING_SPIKE | $80
	db $2E, $06, SUU
	db $31, $0C, NOKOBON | $80
	db $32, $04, FALLING_SPIKE | $80
	db $33, $02, NOKOBON
	db $34, $0C, NOKOBON | $80
	db $37, $8F, NOKOBON
	db $3B, $86, FALLING_SPIKE
	db $3E, $0C, NOKOBON | $80
	db $40, $0C, NOKOBON
	db $44, $06, SUU
	db $45, $0B, FLY
	db $46, $08, SUU
	db $49, $0F, NOKOBON
	db $4B, $84, FALLING_SPIKE | $80
	db $4E, $08, FLY
	db $4F, $0C, NOKOBON | $80
	db $51, $CE, PIPE_CANNON
	db $53, $05, SUU
	db $55, $0F, FLY | $80
	db $56, $0C, NOKOBON
	db $58, $0E, FLY | $80
	db $63, $0B, FLY
	db $69, $83, GANCHAN_SPAWN
	db $73, $83, GANCHAN_SPAWN
	db $7B, $05, FALLING_SPIKE | $80
	db $7B, $CF, PIPE_CANNON
	db $7C, $88, SUU
	db $7E, $0F, FLY
	db $7F, $0F, NOKOBON | $80
	db $81, $4E, PAKKUN_FLOWER
	db $84, $08, HORIZONTAL_PLATFORM
	db $88, $0D, NOKOBON
	db $89, $47, SMALL_VERTICAL_PLATFORM
	db $8C, $8A, DROP_BLOCK
	db $8D, $0A, DROP_BLOCK
	db $8E, $89, DROP_BLOCK
	db $8F, $09, DROP_BLOCK
	db $92, $8A, DROP_BLOCK
	db $94, $0B, DROP_BLOCK
	db $94, $8B, DROP_BLOCK
	db $96, $8B, DROP_BLOCK
	db $98, $0A, DROP_BLOCK
	db $99, $89, DROP_BLOCK
	db $9B, $08, DROP_BLOCK
	db $9C, $87, DROP_BLOCK
	db $9E, $05, DROP_BLOCK
	db $FF ; end of list

SECTION "level 3_3 enemies", ROMX[$4FD8], BANK[3]

level_3_3_enemies:
	db $0E, $8C, VERTICAL_PLATFORM
	db $12, $09, DIAGONAL_PLATFORM_NE
	db $14, $09, DIAGONAL_PLATFORM_NW
	db $19, $88, DIAGONAL_PLATFORM_NE
	db $1D, $05, SMALL_HORIZONTAL_PLATFORM
	db $26, $0A, SMALL_VERTICAL_PLATFORM
	db $27, $08, DROP_BLOCK
	db $27, $88, DROP_BLOCK
	db $27, $0D, GANCHAN
	db $28, $C6, PAKKUN_FLOWER
	db $29, $0D, NOKOBON
	db $35, $10, FLY
	db $37, $07, NOKOBON
	db $39, $10, FLY
	db $3F, $0E, VERTICAL_PLATFORM
	db $41, $8C, DIAGONAL_PLATFORM_NE
	db $44, $8C, DIAGONAL_PLATFORM_NW
	db $46, $84, SMALL_VERTICAL_PLATFORM
	db $4C, $04, VERTICAL_PLATFORM
	db $4E, $10, VERTICAL_PLATFORM
	db $55, $09, DROP_BLOCK
	db $55, $89, DROP_BLOCK
	db $57, $10, VERTICAL_PLATFORM
	db $5D, $10, SMALL_HORIZONTAL_PLATFORM
	db $60, $91, SMALL_HORIZONTAL_PLATFORM
	db $6F, $0F, BATADON
	db $71, $0F, TOKOTOKO | $80
	db $73, $0F, TOKOTOKO
	db $7A, $8F, BATADON | $80
	db $7B, $0A, NOKOBON | $80
	db $7C, $8F, GANCHAN
	db $88, $0C, BATADON | $80
	db $89, $8A, BATADON
	db $92, $0E, HIYOIHOI
	db $FF ; end of list

SECTION "level 4_1 enemies", ROMX[$5311], BANK[1]

level_4_1_enemies:
	db $0F, $CC, REVERSE_PAKKUN_FLOWER
	db $11, $D1, PAKKUN_FLOWER
	db $19, $51, PAKKUN_FLOWER
	db $1A, $0B, PIONPI | $80
	db $1B, $0F, NOKOBON | $80
	db $1C, $0F, PIONPI
	db $1F, $89, HORIZONTAL_PLATFORM
	db $24, $87, VERTICAL_PLATFORM
	db $2C, $0F, NOKOBON | $80
	db $2D, $51, PIPE_CANNON
	db $2F, $0F, PIONPI
	db $37, $0E, NOKOBON | $80
	db $39, $8E, NOKOBON
	db $3A, $0E, PIONPI
	db $40, $0E, PIONPI
	db $41, $0E, NOKOBON
	db $43, $8E, NOKOBON
	db $4A, $0F, PIONPI
	db $4B, $51, PAKKUN_FLOWER
	db $4D, $0B, PIONPI
	db $4D, $0F, NOKOBON | $80
	db $51, $51, PAKKUN_FLOWER | $80
	db $53, $51, PAKKUN_FLOWER
	db $54, $4F, PAKKUN_FLOWER
	db $55, $CD, PIPE_CANNON
	db $5B, $4E, PAKKUN_FLOWER
	db $5E, $0A, PIONPI
	db $5E, $8A, NOKOBON
	db $62, $4D, PAKKUN_FLOWER
	db $63, $4E, PIPE_CANNON | $80
	db $67, $0E, DIAGONAL_PLATFORM_NW
	db $6B, $0A, DIAGONAL_PLATFORM_NE
	db $6F, $CF, PAKKUN_FLOWER
	db $71, $CC, REVERSE_PAKKUN_FLOWER
	db $73, $CC, REVERSE_PAKKUN_FLOWER
	db $75, $D1, PAKKUN_FLOWER
	db $79, $CF, PIPE_CANNON
	db $7B, $CC, REVERSE_PAKKUN_FLOWER
	db $7C, $0F, CHIBIBO | $80
	db $7D, $CC, REVERSE_PAKKUN_FLOWER
	db $7E, $0F, CHIBIBO
	db $7F, $D1, PAKKUN_FLOWER
	db $83, $CF, PIPE_CANNON
	db $85, $CC, REVERSE_PAKKUN_FLOWER
	db $87, $CC, REVERSE_PAKKUN_FLOWER
	db $88, $0F, NOKOBON | $80
	db $89, $D1, PAKKUN_FLOWER
	db $8A, $86, FALLING_SLAB
	db $8E, $8D, VERTICAL_PLATFORM
	db $92, $06, DIAGONAL_PLATFORM_NE
	db $95, $85, DROP_BLOCK
	db $96, $05, DROP_BLOCK
	db $98, $05, DROP_BLOCK
	db $98, $85, DROP_BLOCK
	db $9A, $06, DROP_BLOCK
	db $9A, $86, DROP_BLOCK
	db $9D, $06, HORIZONTAL_PLATFORM
	db $A1, $51, PAKKUN_FLOWER | $80
	db $A2, $51, PIPE_CANNON
	db $A3, $51, PAKKUN_FLOWER | $80
	db $A4, $4F, PAKKUN_FLOWER | $80
	db $A5, $CD, PIPE_CANNON | $80
	db $A7, $89, PIONPI
	db $AE, $0E, PIONPI
	db $AF, $0E, NOKOBON
	db $B1, $8E, NOKOBON
	db $B2, $0E, PIONPI
	db $B4, $09, HORIZONTAL_PLATFORM
	db $C2, $D1, PIPE_CANNON
	db $C4, $CF, PIPE_CANNON
	db $C5, $8A, NOKOBON
	db $C6, $C9, PIPE_CANNON
	db $CF, $05, PIONPI
	db $CF, $08, PIONPI
	db $CF, $0E, PIONPI
	db $D4, $90, DROP_BLOCK
	db $D5, $10, DROP_BLOCK
	db $D7, $D1, PIPE_CANNON
	db $D8, $CF, PIPE_CANNON
	db $D9, $CC, PIPE_CANNON
	db $DE, $88, DIAGONAL_PLATFORM_NW
	db $FF ; end of list

SECTION "level 4_2 enemies", ROMX[$5405], BANK[1]

level_4_2_enemies:
	db $0F, $0B, NOKOBON
	db $11, $09, POMPON_FLOWER | $80
	db $15, $0F, NOKOBON
	db $19, $0B, NOKOBON
	db $1B, $0F, POMPON_FLOWER
	db $1F, $50, PIPE_CANNON
	db $20, $0F, NOKOBON | $80
	db $23, $0D, NOKOBON
	db $27, $0B, POMPON_FLOWER
	db $29, $50, PIPE_CANNON
	db $2A, $0F, NOKOBON | $80
	db $2D, $8D, GAO | $80
	db $30, $0B, GAO
	db $34, $CD, REVERSE_PAKKUN_FLOWER
	db $37, $09, NOKOBON
	db $37, $CD, REVERSE_PAKKUN_FLOWER
	db $3A, $CC, REVERSE_PAKKUN_FLOWER
	db $3E, $CD, REVERSE_PAKKUN_FLOWER
	db $40, $50, PIPE_CANNON | $80
	db $41, $CD, REVERSE_PAKKUN_FLOWER
	db $43, $50, PIPE_CANNON
	db $44, $CC, REVERSE_PAKKUN_FLOWER
	db $47, $09, NOKOBON
	db $48, $0F, CHIBIBO
	db $4B, $0C, GAO | $80
	db $4D, $0E, POMPON_FLOWER
	db $53, $0F, ROTO_DISC
	db $54, $4C, PAKKUN_FLOWER
	db $56, $07, ROTO_DISC
	db $59, $0F, ROTO_DISC
	db $5A, $0F, CHIBIBO
	db $5D, $0F, ROTO_DISC
	db $60, $07, ROTO_DISC
	db $63, $0F, ROTO_DISC
	db $68, $0C, ROTO_DISC
	db $6A, $0F, NOKOBON
	db $6C, $0D, ROTO_DISC
	db $70, $8F, ROTO_DISC | $80
	db $72, $8E, VERTICAL_PLATFORM
	db $76, $8C, VERTICAL_PLATFORM
	db $7A, $0F, NOKOBON
	db $7C, $0C, ROTO_DISC
	db $7E, $0F, NOKOBON
	db $80, $0D, ROTO_DISC
	db $84, $8F, ROTO_DISC | $80
	db $86, $8E, VERTICAL_PLATFORM
	db $8A, $8C, VERTICAL_PLATFORM
	db $8B, $87, ROTO_DISC | $80
	db $8F, $0F, NOKOBON
	db $91, $0C, GAO
	db $94, $8A, NOKOBON
	db $95, $87, ROTO_DISC
	db $99, $0F, ROTO_DISC
	db $9C, $07, ROTO_DISC
	db $9D, $8D, NOKOBON
	db $9F, $0F, ROTO_DISC
	db $A3, $0F, GAO
	db $A5, $0C, NOKOBON
	db $A7, $8D, GAO | $80
	db $A8, $8A, NOKOBON
	db $A9, $87, ROTO_DISC
	db $B1, $0F, GIRA | $80
	db $B5, $4C, REVERSE_PAKKUN_FLOWER
	db $B7, $06, SMALL_VERTICAL_PLATFORM
	db $BC, $06, DROP_BLOCK
	db $BF, $0E, DROP_BLOCK
	db $BF, $8B, DROP_BLOCK
	db $C0, $08, DROP_BLOCK
	db $C0, $86, DROP_BLOCK
	db $FF ; end of list

SECTION "level 4_3 enemies", ROMX[$54D5], BANK[1]

level_4_3_enemies:
	db $10, $06, CHICKEN
	db $11, $0F, CHICKEN | $80
	db $13, $08, CHICKEN
	db $14, $0D, CHICKEN
	db $17, $0A, CHICKEN
	db $19, $06, CHICKEN
	db $1A, $0F, CHICKEN | $80
	db $1C, $0C, CHICKEN
	db $1D, $09, CHICKEN
	db $23, $06, CHICKEN
	db $24, $08, CHICKEN | $80
	db $25, $0A, CHICKEN
	db $27, $0E, CHICKEN
	db $28, $0C, CHICKEN | $80
	db $29, $0A, CHICKEN
	db $2B, $06, CHICKEN
	db $2C, $05, ROKETON
	db $2E, $05, ROKETON | $80
	db $30, $05, ROKETON
	db $34, $0F, ROKETON
	db $36, $0F, ROKETON | $80
	db $38, $0F, ROKETON
	db $3C, $05, ROKETON
	db $3D, $0A, ROKETON | $80
	db $3E, $0F, ROKETON
	db $42, $06, ROKETON
	db $43, $0D, ROKETON
	db $4C, $05, CHICKEN
	db $4D, $8B, CHIKAKO
	db $4E, $06, CHICKEN | $80
	db $4E, $0C, ROKETON
	db $50, $85, CHIKAKO
	db $52, $0F, ROKETON
	db $52, $06, CHICKEN
	db $56, $06, CHIKAKO
	db $57, $0E, CHICKEN
	db $58, $8F, CHIKAKO
	db $5A, $06, ROKETON
	db $5A, $0E, ROKETON | $80
	db $5C, $0F, CHICKEN
	db $5D, $09, CHIKAKO
	db $5F, $08, CHICKEN
	db $60, $0D, CHIKAKO
	db $63, $05, CHICKEN
	db $63, $0A, ROKETON
	db $65, $0E, CHICKEN
	db $67, $09, CHIKAKO
	db $68, $09, CHICKEN
	db $69, $0E, ROKETON | $80
	db $6B, $09, CHIKAKO
	db $6C, $08, CHICKEN
	db $71, $8A, CHIKAKO
	db $72, $07, CHICKEN
	db $73, $0A, ROKETON
	db $75, $0C, ROKETON
	db $76, $8F, CHIKAKO
	db $78, $08, ROKETON
	db $7A, $0A, CHICKEN
	db $7B, $0E, CHIKAKO
	db $7D, $07, CHICKEN
	db $7E, $0D, CHICKEN
	db $80, $8C, CHIKAKO
	db $85, $05, CHICKEN
	db $87, $0E, CHICKEN
	db $89, $0E, ROKETON | $80
	db $8E, $0A, ROKETON
	db $90, $07, ROKETON
	db $93, $0D, CHICKEN
	db $93, $06, ROKETON
	db $CF, $8A, ROTO_DISC
	db $D9, $87, ROTO_DISC | $80
	db $DB, $0C, ROTO_DISC
	db $DC, $0D, GENKOTSU | $80
	db $E0, $08, GENKOTSU
	db $E1, $08, GENKOTSU
	db $EC, $8A, BIOKINTON
	db $FF ; end of list
	db $FF ; end of list (again, sigh)

