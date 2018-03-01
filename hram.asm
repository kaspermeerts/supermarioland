SECTION "High RAM", HRAM

hJoyHeld:: ; FF80 keys currently pressed
	ds 1

hJoyPressed:: ; FF81 keys pressed since last time
	ds 1

ds $85 - $82

hVBlankOccurred::	; FF85
	ds 1

ds $9A - $86

hWinCount::		; FF9A TODO mirrored at C0E1?
	ds 1

ds $B2 - $9B

hGamePaused::	; FFB2
	ds 1

hGameState::	; FFB3
	ds 1

ds $B6 - $B4

hDMARoutine::	; FFB6
	ds $A
hDMARoutineEnd:: ; TODO temporary

ds $FA - $C0
hCoins::		; FFFA
	ds 1
