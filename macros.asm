WAIT_FOR_HBLANK: MACRO
.loop\@
	ldh a, [rSTAT]
	and a, %11
	jr nz, .loop\@
ENDM

FAR_CALL: MACRO
	SAVE_AND_SWITCH_ROM_BANK \1
	call \2
	RESTORE_ROM_BANK
ENDM

SAVE_AND_SWITCH_ROM_BANK: MACRO
	ldh a, [hActiveRomBank]
	ldh [hSavedRomBank], a
	ld a, \1
	ldh [hActiveRomBank], a
	ld [MBC1RomBank], a
ENDM

RESTORE_ROM_BANK: MACRO
	ldh a, [hSavedRomBank]
	ldh [hActiveRomBank], a
	ld [MBC1RomBank], a
ENDM
