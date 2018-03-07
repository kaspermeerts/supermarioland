SECTION "High RAM", HRAM

hJoyHeld:: ; FF80 keys currently pressed
	ds 1

hJoyPressed:: ; FF81 keys pressed since last time
	ds 1

ds $85 - $82

hVBlankOccurred::	; FF85
	ds 1

ds $99 - $86

hSuperStatus:: ; FF99 TODO constants
	ds 1

hWinCount::		; FF9A TODO mirrored at C0E1?
	ds 1

ds $AC - $9B

hFrameCounter::
	ds 1

ds $B2 - $AD

hGamePaused::	; FFB2
	ds 1

hGameState::	; FFB3
	ds 1

hWorldAndLevel::; FFB4
	ds 1

ds $B6 - $B5

hDMARoutine::	; FFB6
	ds $A
hDMARoutineEnd:: ; TODO temporary

ds $DF - $C0

hPauseMusic::	; FFDF
	ds 1

ds $E4 - $E0

hLevelIndex::	; FFE4
	ds 1

hLevelBlock::	; FFE5
	ds 1

hColumnIndex::	; FFE6
	ds 1

hColumnPointerHi::	; FFE7
	ds 1

hColumnPointerLo:: ; FFE8
	ds 1

ds $FA - $E9

hCoins::		; FFFA
	ds 1
