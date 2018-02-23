SECTION "High RAM", HRAM

ds $B3 - $80
hGameState::	; $FFB3
	ds 1

ds $B6 - $B4

hDMARoutine::
	ds $A
