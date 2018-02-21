SECTION "wram", WRAM0

wOAMBuffer::
	ds $A0

wScore::
	ds 3

ds $DA15 - $C0A3
wNumLives::	ds 1	; $DA15
