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

ds 1			; FF9B unknown

hStompChainTimer:: ; FF9C
	ds 1

hStompChain::	; FF9D
	ds 1

ds $A4 - $9E

hScrollX::		; FFA4
	ds 1

ds 1			; FFA5 unknown

hTimer::		; FFA6 Generic frame based timer
	ds 1

ds $AC - $A7

hFrameCounter:: ; FFAC
	ds 1

ds $B2 - $AD

hGamePaused::	; FFB2
	ds 1

hGameState::	; FFB3
	ds 1

hWorldAndLevel::; FFB4
	ds 1

hSuperballMario::; FFB5
	ds 1

hDMARoutine::	; FFB6
	ds $A

ds $D0 - $C0

hCurrentChannel:: ; FFD0 Used in music routine
	ds 1

ds $DE - $D1

hPauseTuneTimer:: ; FFDE
	ds 1

hPauseUnpauseMusic::; FFDF
	ds 1

ds 1			; FFE0

hSavedRomBank::	; FFE1
	ds 1

hTextCursorHi:: ; FFE2
	ds 1

hTextCursorLo:: ; FFE3
	ds 1

hLevelIndex::	; FFE4
	ds 1

hScreenIndex::	; FFE5
	ds 1

hColumnIndex::	; FFE6
	ds 1

hColumnPointerHi::	; FFE7
	ds 1

hColumnPointerLo:: ; FFE8
	ds 1

ds 2 ; FFE9 FFEA

hFloatyX:: ; FFEB
	ds 1

hFloatyY:: ; FFEC
	ds 1

hFloatyControl:: ; FFED
	ds 1

ds $FA - $EE

hCoins::	; FFFA
	ds 1

ds 2

hActiveRomBank::	; FFFD
	ds 1
