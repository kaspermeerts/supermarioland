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

db ; C0A7

wContinueWorldAndLevel:: ; C0A8
	db

wSuperballTTL:: ; C0A9
	db

ds $C0 - $AA

wTopScore:: ; C0C0
	ds 3

ds $C0D3 - $C0C3

wInvincibilityTimer:: ; C0D3
	db

ds $C0DF - $C0D4

wScrollY:: ; C0DF
	db

ds 1		; C0F0

wWinCount:: ; C0E1
	db

; D100 - D190: enemies
ds $D013 - $C0E2

wObjectsDrawn:: ; D013 The upper 20 objects are used for enemies
	db

wBackgroundAnimated::	; D014
	db

ds $DA00 - $D015

wGameTimer:: ; DA00-DA02
	ds 3

ds $DA15 - $DA03

wLives::	db	; $DA15

ds $1D - $16

wGameTimerExpiringFlag:: ; DA1D do i have a better name?
	db
