SECTION "wram", WRAM0

wOAMBuffer::
	ds $A0

wScore::	; C0A0
	ds 3

wLivesEarnedLost::
	ds 1	; C0A3
ds 1		; C0A4
ds 1		; C0A5

wNumContinues::	; C0A6
	db

ds 2

wSuperballTTL:: ; C0A9
	db

ds $C0 - $AA

wTopScore:: ; C0C0
	ds 3

; D100 - D190: enemies

ds $D014 - $C0C3

wBackgroundAnimated::	; D014
	ds 1

ds $DA00 - $D015

wTimer:: ; DA00-DA02
	ds 3

ds $DA15 - $DA03

wLives::	db	; $DA15
