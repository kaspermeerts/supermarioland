SECTION "High RAM", HRAM

ds $9A - $80

hWinCount::		; $FF9A TODO mirrored at C0E1?
	ds 1

ds $B3 - $9B

hGameState::	; $FFB3
	ds 1

ds $B6 - $B4

hDMARoutine::
	ds $A
