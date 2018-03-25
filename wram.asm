SECTION "wram", WRAM0

wOAMBuffer::
	ds $A0

wScore::	; C0A0
	ds 3

wLivesEarnedLost::
	ds 1	; C0A3

ds 1		; C0A4

wGameOverWindowEnabled :: ; C0A5
	db

wNumContinues::	; C0A6
	db

db ; C0A7

wContinueWorldAndLevel:: ; C0A8
	db

wSuperballTTL:: ; C0A9
	db

ds $AD - $AA

wGameOverTimerExpired:: ; C0AD
	db

ds $C0 - $AE

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

ds $D002 - $C0E2

wCurrentCommand:: ; D002
	db

wCommandArgument:: ; D003
	db

ds $D013 - $D004

wObjectsDrawn:: ; D013 The upper 20 objects are used for enemies
	db

wBackgroundAnimated::	; D014
	db

; D100 - D190: enemies
ds $DA00 - $D015

wGameTimer:: ; DA00-DA02
	ds 3

wFloaty0_TTL:: ; DA03-DA06
	db
wFloaty1_TTL::
	db
wFloaty2_TTL::
	db
wFloaty3_TTL::
	db

wFloaty0_SpriteIfCoin:: ; DA07-DA0A
	db
wFloaty1_SpriteIfCoin::
	db
wFloaty2_SpriteIfCoin::
	db
wFloaty3_SpriteIfCoin::
	db

wNextFloatyOAMIndex :: ; DA0B
	ds 1

wFloaty0_IsCoin:: ; DA0C - DA0F
	db
wFloaty1_IsCoin::
	db
wFloaty2_IsCoin::
	db
wFloaty3_IsCoin::
	db

ds $DA15 - $DA10

wLives::	db	; $DA15

ds $1D - $16

wGameTimerExpiringFlag:: ; DA1D do i have a better name?
	db
