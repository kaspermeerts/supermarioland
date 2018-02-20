SECTION "bank0", ROM0[$0000]
INCBIN "baserom.gb", $0000, $4000

SECTION "bank1", ROMX, BANK[1]
INCBIN "baserom.gb", $4000, $4000

SECTION "bank2", ROMX, BANK[2]
INCBIN "baserom.gb", $8000, $4000

SECTION "bank3", ROMX, BANK[3]
INCBIN "baserom.gb", $C000, $4000

