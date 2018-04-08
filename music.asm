INCLUDE "music_macros.asm"

SECTION "Music", ROMX[$6F98], BANK[3]

Song_6F98::
	db $00
	dw $6F5B
	dw Channel1_72F3
	dw Channel2_72F7
	dw Channel3_72F9
	dw Channel4_72FB

Song_6FA3::
	db $00
	dw $6F7B
	dw Channel1_72A7
	dw Channel2_72AB
	dw Channel3_72AF
	dw Channel4_72B1

Song_6FAE::
	db $00
	dw $6F66
	dw Channel1_71ED
	dw Channel2_71F9
	dw Channel3_7205
	dw Channel4_7219

Song_6FB9::
	db $00
	dw $6F7B
	dw Channel1_7186
	dw Channel2_718C
	dw $0000
	dw Channel4_7192

Song_6FC4::
	db $00
	dw $6F5B
	dw Channel1_733E
	dw Channel2_734A
	dw Channel3_7356
	dw Channel4_7362

Song_6FCF::
	db $00
	dw $6F66
	dw Channel1_74D7
	dw Channel2_74E3
	dw Channel3_74EF
	dw Channel4_7507

Song_6FDA::
	db $00
	dw $6F66
	dw Channel1_76ED
	dw Channel2_76F7
	dw Channel3_7701
	dw Channel4_770D

Song_6FE5::
	db $00
	dw $6F7B
	dw Channel1_6FF0
	dw Channel2_6FFC
	dw Channel3_7008
	dw Channel4_7014

Channel1_6FF0::
	dw Segment_701C, Segment_7044, Segment_7044, Segment_7061, $FFFF, $6FF2

Channel2_6FFC::
	dw Segment_7024, Segment_7094, Segment_7094, Segment_70B1, $FFFF, $6FFE

Channel3_7008::
	dw Segment_7034, Segment_70E6, Segment_70E6, Segment_7117, $FFFF, $700A

Channel4_7014::
	dw Segment_7169, Segment_7178, $FFFF, $7016

Segment_701C::
	db $9D, $66, $00, $80
	db $A5
	db $01, $01
	db $00

Segment_7024::
	db $9D, $76, $00, $81
	db $A4
	db $42, $3E, $3A
	db $A9
	db $36, $36, $36, $36, $36, $36
	db $00

Segment_7034::
	db $9D, $3B, $6F, $A0
	db $A4
	db $52, $4E, $4C
	db $A9
	db $48, $48, $48, $48, $48, $48
	db $00

Segment_7044::
	db $A4
	db $01
	db $A9
	db $3A, $01
	db $A3
	db $3E
	db $A2
	db $4C
	db $A7
	db $01
	db $A9
	db $34, $4C, $01, $48
	db $A3
	db $44, $3E
	db $A9
	db $44, $01
	db $A4
	db $3E
	db $A9
	db $01
	db $A5
	db $01
	db $00

Segment_7061::
	db $A4
	db $01
	db $A9
	db $3E, $01, $3E, $01, $01, $3E, $01, $01, $01, $01, $01, $3A
	db $A3
	db $36, $34
	db $A9
	db $30, $01, $34, $01, $01, $42
	db $A4
	db $01
	db $A5
	db $01
	db $A4
	db $01
	db $A9
	db $3E, $01, $3E, $01, $01, $3E, $01, $01, $01, $01, $01, $3A
	db $A3
	db $36, $34
	db $A5
	db $01, $01
	db $00

Segment_7094::
	db $A4
	db $01
	db $A9
	db $4C, $01
	db $A3
	db $4E
	db $A2
	db $52
	db $A7
	db $01
	db $A9
	db $44, $52, $01, $4E
	db $A3
	db $4C, $48
	db $A9
	db $4C, $01
	db $A4
	db $44
	db $A9
	db $01
	db $A5
	db $01
	db $00

Segment_70B1::
	db $A4
	db $01
	db $A9
	db $4E, $01, $4E, $01, $01, $4E, $01, $01, $01, $01, $01, $4C
	db $A3
	db $48, $44
	db $A9
	db $42, $01, $44, $01, $01, $48
	db $A4
	db $01
	db $A5
	db $01
	db $A4
	db $01
	db $A9
	db $4E, $01, $4E, $01, $01, $4E, $01, $01, $01, $01, $01, $4C
	db $A3
	db $48, $44
	db $A4
	db $42, $3E, $3A, $36
	db $00

Segment_70E6::
	db $A3
	db $44
	db $A9
	db $44, $01, $3A
	db $A3
	db $44
	db $A9
	db $44, $01, $3A
	db $A3
	db $44
	db $A9
	db $44, $01, $3A
	db $A3
	db $44
	db $A9
	db $44, $01, $3A
	db $A3
	db $36
	db $A9
	db $36, $01, $44
	db $A3
	db $36
	db $A9
	db $36, $01, $44
	db $A3
	db $36
	db $A9
	db $36, $01, $44
	db $A3
	db $36
	db $A9
	db $36, $01, $44
	db $00

Segment_7117::
	db $A3
	db $48
	db $A9
	db $48, $01, $3E
	db $A3
	db $48
	db $A9
	db $48, $01, $3E
	db $A3
	db $48
	db $A9
	db $48, $01, $3E
	db $A3
	db $48
	db $A9
	db $48, $01, $3E
	db $A3
	db $3A
	db $A9
	db $3A, $01, $48
	db $A3
	db $3A
	db $A9
	db $3A, $01, $48
	db $A3
	db $3A
	db $A9
	db $3A, $01, $48
	db $A3
	db $3A
	db $A9
	db $3A, $01, $48
	db $A3
	db $48
	db $A9
	db $48, $01, $3E
	db $A3
	db $48
	db $A9
	db $48, $01, $3E
	db $A3
	db $48
	db $A9
	db $48, $01, $3E
	db $A3
	db $48
	db $A9
	db $48, $01, $3E
	db $A3
	db $52, $52, $4E, $4E, $4C, $4C, $48, $48
	db $00

Segment_7169::
	db $A3
	Noise 1, 1, 1, 1, 2, 2
	db $A9
	Noise 2, 2, 2, 2, 2, 2
	db $00

Segment_7178::
	db $A9
	Noise 1, 0, 0, 3, 0, 1, 0, 1, 0, 3, 0, 1
	db $00

Channel1_7186::
	dw Segment_7198, $FFFF, $7186

Channel2_718C::
	dw Segment_71B9, $FFFF, $718C

Channel4_7192::
	dw Segment_71D5, $FFFF, $7192

Segment_7198::
	db $9D, $73, $00, $80
	db $A9
	db $01
	db $A2
	db $1A, $01, $22, $10, $14, $18, $1A, $01, $28, $22, $01, $01, $1A, $01, $22, $10, $14, $18, $1A, $01
	db $A3
	db $01
	db $A9
	db $01, $01
	db $00

Segment_71B9::
	db $9D, $93, $00, $80
	db $A2
	db $1A, $01, $22, $10, $14, $18, $1A, $01, $28, $22, $01, $01, $1A, $01, $22, $10, $14, $18, $1A, $01
	db $A4
	db $01
	db $00

Segment_71D5::
	db $A2
	Noise 1, 0, 0, 1, 0, 1, 1, 0, 1, 1, 0, 0, 1, 0, 0, 1, 0, 1, 1, 0
	db $A4
	Noise 0
	db $00

Channel1_71ED::
	dw Segment_7224, Segment_722B, Segment_722B, Segment_725E, $FFFF, $71EF

Channel2_71F9::
	dw Segment_721F, Segment_722B, Segment_722B, Segment_725E, $FFFF, $71FB

Channel3_7205::
	dw Segment_7272, Segment_7277, Segment_7277, Segment_7277, Segment_7277, Segment_7289, Segment_7289, Segment_7277, $FFFF, $7207

Channel4_7219::
	dw Segment_7292, $FFFF, $7219

Segment_721F::
	db $9D, $80, $00, $81
	db $00

Segment_7224::
	db $9D, $30, $00, $80
	db $A7
	db $01
	db $00

Segment_722B::
	db $A4
	db $40
	db $A3
	db $3E
	db $A9
	db $38, $3E, $38
	db $AB
	db $01
	db $A8
	db $36
	db $A3
	db $28, $2A
	db $A2
	db $2A, $2E
	db $A3
	db $2A, $2E
	db $A5
	db $28
	db $A4
	db $40
	db $A3
	db $3E
	db $A9
	db $38, $3E, $38
	db $AB
	db $01
	db $A8
	db $36
	db $A3
	db $28, $2A
	db $A2
	db $2A, $2E
	db $A3
	db $32
	db $A1
	db $2E, $32, $2E, $2A
	db $A5
	db $28
	db $00

Segment_725E::
	db $A5
	db $2A
	db $A4
	db $01, $32
	db $A5
	db $3C
	db $A4
	db $38
	db $A3
	db $38
	db $A2
	db $3C, $38
	db $A5
	db $36, $01, $01, $01
	db $00

Segment_7272::
	db $9D, $3B, $6F, $A0
	db $00

Segment_7277::
	db $A3
	db $40, $42, $40, $42, $40, $42, $40, $4E, $40, $42, $40, $42, $40, $42, $40, $3C
	db $00

Segment_7289::
	db $42, $50, $42, $50, $42, $50, $42, $50
	db $00

Segment_7292::
	db $A3
	Noise 1
	db $A2
	Noise 1, 1
	db $A3
	Noise 1
	db $A2
	Noise 1, 1
	db $A3
	Noise 1
	db $A2
	Noise 1, 1
	db $A3
	Noise 2
	db $A2
	Noise 1, 1
	db $00

Channel1_72A7::
	dw Segment_72C5, $0000

Channel2_72AB::
	dw Segment_72B3, $0000

Channel3_72AF::
	dw Segment_72D6

Channel4_72B1::
	dw Segment_72E8

Segment_72B3::
	db $9D, $71, $00, $80
	db $A0
	db $01
	db $A1
	db $58, $54, $52, $4E, $4A
	db $A6
	db $01
	db $A2
	db $40, $01, $32
Segment_72C5::
	db $9D, $B1, $00, $80
	db $A1
	db $58, $54, $52, $4E, $4A
	db $A6
	db $01
	db $A2
	db $4E, $01, $52
	db $00

Segment_72D6::
	db $9D, $3B, $6F, $20
	db $A1
	db $58, $54, $52, $4E, $4A
	db $A6
	db $01
	db $A2
	db $60, $01, $62, $01, $01
Segment_72E8::
	db $A1
	Noise 1, 1, 1, 1, 1
	db $A6
	Noise 0
	db $A3
	Noise 1, 1
Channel1_72F3::
	dw Segment_72FD, $0000

Channel2_72F7::
	dw Segment_730F

Channel3_72F9::
	dw Segment_7321

Channel4_72FB::
	dw Segment_7333

Segment_72FD::
	db $9D, $60, $00, $80
	db $A8
	db $52
	db $A2
	db $52, $01, $52, $01, $52, $01
	db $A8
	db $56, $58, $5A
	db $00

Segment_730F::
	db $9D, $83, $00, $80
	db $A8
	db $4A
	db $A2
	db $4A, $01, $4A, $01, $4A, $01
	db $A8
	db $4E, $50, $52
	db $00

Segment_7321::
	db $9D, $1B, $6F, $21
	db $A8
	db $70
	db $A2
	db $70, $01, $70, $01, $70, $01
	db $A8
	db $74, $76, $78
	db $00

Segment_7333::
	db $A8
	Noise 1
	db $A3
	Noise 1, 1, 1
	db $A8
	Noise 1, 1, 1, 1
Channel1_733E::
	dw Segment_737A, Segment_73AC, Segment_73AC, Segment_7433, $FFFF, $7340

Channel2_734A::
	dw Segment_736A, Segment_73D4, Segment_73D4, Segment_7463, $FFFF, $734C

Channel3_7356::
	dw Segment_738A, Segment_740A, Segment_740A, Segment_7493, $FFFF, $7358

Channel4_7362::
	dw Segment_73A0, Segment_74BE, $FFFF, $7364

Segment_736A::
	db $9D, $A2, $00, $80
	db $A2
	db $40, $44, $01, $48, $01, $44, $01, $40
	db $A5
	db $3C
	db $00

Segment_737A::
	db $9D, $82, $00, $80
	db $A2
	db $4A, $4A, $01, $4A, $01, $4A, $01, $4A
	db $A5
	db $44
	db $00

Segment_738A::
	db $9D, $3B, $6F, $20
	db $A2
	db $52, $54, $01, $58, $01, $54, $01, $52, $40, $36, $01, $30, $28, $01, $01, $01
	db $00

Segment_73A0::
	db $A2
	Noise 1, 1, 0, 1, 0, 1, 0, 1
	db $A5
	Noise 1
	db $00

Segment_73AC::
	db $A2
	db $3A, $01, $01
	db $A7
	db $40
	db $A3
	db $3A
	db $A4
	db $01, $32
	db $AA
	db $36, $44, $44, $44, $48, $4A
	db $A5
	db $01
	db $A2
	db $3A, $3A, $01
	db $A7
	db $40
	db $A3
	db $3A
	db $A5
	db $01
	db $AA
	db $48, $01, $01, $36, $3A, $3C
	db $A5
	db $3A
	db $00

Segment_73D4::
	db $A2
	db $4A, $01, $01
	db $A7
	db $52
	db $A3
	db $4A
	db $A2
	db $44, $4E, $01, $54
	db $A4
	db $44
	db $AA
	db $48, $54, $54, $54, $58, $5C
	db $A2
	db $58, $52, $01, $4A
	db $A4
	db $40
	db $A2
	db $4A, $4A, $01
	db $A7
	db $52
	db $A3
	db $4A
	db $A2
	db $44, $4E, $01, $54
	db $A4
	db $44
	db $AA
	db $48, $01, $01, $48, $4A, $4E
	db $A5
	db $4A
	db $00

Segment_740A::
	db $A7
	db $32, $3A
	db $A3
	db $40
	db $A7
	db $3C, $44
	db $A3
	db $4A
	db $A7
	db $40, $48
	db $A3
	db $36
	db $A7
	db $32, $3A
	db $A3
	db $40
	db $A7
	db $32, $3A
	db $A3
	db $40
	db $A7
	db $3C, $44
	db $A3
	db $4A
	db $A7
	db $40, $48
	db $A3
	db $36
	db $A7
	db $32, $3A
	db $A3
	db $40
	db $00

Segment_7433::
	db $AA
	db $44, $44, $44, $44, $40, $3C
	db $A7
	db $40, $32
	db $A3
	db $01
	db $A2
	db $36, $01, $01, $36, $36, $3A, $01, $3C
	db $A5
	db $40
	db $AA
	db $44, $01, $44, $44, $48, $4A
	db $A7
	db $48, $40
	db $A3
	db $01
	db $A7
	db $44, $40
	db $A3
	db $3C
	db $A2
	db $01, $3C, $01, $01
	db $A4
	db $40
	db $00

Segment_7463::
	db $AA
	db $54, $54, $54, $54, $52, $4E
	db $A7
	db $52, $4A
	db $A3
	db $01
	db $A2
	db $48, $01, $01, $48, $48, $4A, $01, $4E
	db $A5
	db $52
	db $AA
	db $54, $01, $54, $54, $58, $5C
	db $A7
	db $58, $52
	db $A3
	db $01
	db $A7
	db $54, $52
	db $A3
	db $4E
	db $A2
	db $01, $44, $01, $01
	db $A4
	db $48
	db $00

Segment_7493::
	db $A7
	db $3C, $44
	db $A3
	db $4A
	db $A7
	db $32, $3A
	db $A3
	db $40
	db $A7
	db $40, $48
	db $A3
	db $36
	db $A7
	db $32, $3A
	db $A3
	db $40
	db $A7
	db $3C, $44
	db $A3
	db $4A
	db $A7
	db $3A, $40
	db $A3
	db $48
	db $A7
	db $3C, $44
	db $A3
	db $4A
	db $A2
	db $01, $40, $01, $01
	db $A4
	db $40
	db $00

Segment_74BE::
	db $A3
	Noise 1
	db $A9
	Noise 1, 0, 1
	db $A3
	Noise 2
	db $A9
	Noise 1, 0, 1
	db $A3
	Noise 1
	db $A9
	Noise 1, 0, 1
	db $A3
	Noise 2
	db $A9
	Noise 1, 0, 1
	db $00

Channel1_74D7::
	dw Segment_7523, Segment_7543, Segment_7543, Segment_7612, $FFFF, $74D9

Channel2_74E3::
	dw Segment_750F, Segment_7592, Segment_7592, Segment_7650, $FFFF, $74E5

Channel3_74EF::
	dw Segment_7537, Segment_75D0, Segment_75D0, Segment_75D0, Segment_75F1, Segment_75D0, Segment_75D0, Segment_75D0, Segment_75F1, Segment_768E, $FFFF, $74F1

Channel4_7507::
	dw Segment_753F, Segment_76D8, $FFFF, $7509

Segment_750F::
	db $9D, $84, $00, $00
	db $A2
	db $70, $70, $70, $01, $6A, $01, $6A, $01, $66, $01, $66, $01
	db $A4
	db $6A
	db $00

Segment_7523::
	db $9D, $74, $00, $00
	db $A2
	db $66, $66, $66, $01, $60, $01, $60, $01, $5C, $01, $5C, $01
	db $A4
	db $60
	db $00

Segment_7537::
	db $9D, $3B, $6F, $20
	db $A5
	db $01, $01
	db $00

Segment_753F::
	db $A5
	Noise 0, 0
	db $00

Segment_7543::
	db $9D, $82, $00, $00
	db $A8
	db $44
	db $A3
	db $48
	db $A4
	db $4E, $48
	db $A4
	db $44
	db $A3
	db $48, $44
	db $A4
	db $40
	db $A3
	db $3A, $36
	db $A8
	db $44
	db $A3
	db $48
	db $A4
	db $4E
	db $A3
	db $48, $44
	db $A2
	db $58, $5C
	db $A3
	db $58
	db $A2
	db $52, $58
	db $A3
	db $52
	db $A2
	db $4E, $52
	db $A3
	db $4E
	db $A2
	db $48, $44
	db $A3
	db $40
	db $A8
	db $44
	db $A3
	db $48
	db $A4
	db $4E, $48
	db $A4
	db $44
	db $A3
	db $48, $44
	db $A4
	db $40
	db $A3
	db $3A, $36
	db $A8
	db $3A
	db $A3
	db $3E, $3A, $36, $30, $2C
	db $A5
	db $30, $01
	db $00

Segment_7592::
	db $9D, $70, $00, $81
	db $A8
	db $4E
	db $A3
	db $52
	db $A4
	db $58, $52
	db $A4
	db $4E
	db $A3
	db $52, $4E
	db $A4
	db $48
	db $A3
	db $44, $40
	db $A8
	db $4E
	db $A3
	db $52
	db $A4
	db $58
	db $A3
	db $52, $4E
	db $A5
	db $52, $01
	db $A8
	db $4E
	db $A3
	db $52
	db $A4
	db $58, $52
	db $A4
	db $4E
	db $A3
	db $52, $4E
	db $A4
	db $48
	db $A3
	db $44, $40
	db $A8
	db $44
	db $A3
	db $48, $44, $40, $3A, $36
	db $A5
	db $3A, $01
	db $00

Segment_75D0::
	db $A3
	db $28
	db $A2
	db $40, $36
	db $A3
	db $28, $40
	db $A3
	db $28
	db $A2
	db $40, $36
	db $A3
	db $28, $40
	db $A3
	db $1A
	db $A2
	db $32, $28
	db $A3
	db $1A, $32
	db $A3
	db $1A
	db $A2
	db $32, $28
	db $A3
	db $1A, $32
	db $00

Segment_75F1::
	db $A3
	db $1E
	db $A2
	db $36, $2C
	db $A3
	db $1E, $36
	db $A3
	db $1E
	db $A2
	db $36, $2C
	db $A3
	db $1E, $36
	db $A3
	db $22
	db $A2
	db $3A, $30
	db $A3
	db $22, $3A
	db $A3
	db $22
	db $A2
	db $3A, $30
	db $A3
	db $22, $3A
	db $00

Segment_7612::
	db $A8
	db $5C
	db $A3
	db $60
	db $A4
	db $66
	db $A3
	db $66
	db $A2
	db $6A, $66
	db $A4
	db $60
	db $A3
	db $66, $60
	db $A3
	db $5C
	db $A2
	db $60, $5C
	db $A3
	db $58
	db $A2
	db $52, $4E
	db $A5
	db $66
	db $A8
	db $66
	db $A3
	db $60
	db $A5
	db $66, $01
	db $A8
	db $52
	db $A3
	db $58
	db $A4
	db $5C, $58
	db $A8
	db $52
	db $A3
	db $4E
	db $A4
	db $48
	db $A3
	db $44, $40
	db $A8
	db $44
	db $A3
	db $48
	db $A4
	db $4E, $52
	db $A5
	db $58, $01
	db $00

Segment_7650::
	db $A8
	db $44
	db $A3
	db $48
	db $A4
	db $4E
	db $A3
	db $4E
	db $A2
	db $52, $4E
	db $A4
	db $48
	db $A3
	db $4E, $48
	db $A3
	db $44
	db $A2
	db $48, $44
	db $A3
	db $40
	db $A2
	db $3A, $36
	db $A5
	db $4E
	db $A8
	db $4E
	db $A3
	db $48
	db $A5
	db $4E, $01
	db $A8
	db $52
	db $A3
	db $58
	db $A4
	db $5C, $58
	db $A8
	db $52
	db $A3
	db $4E
	db $A4
	db $48
	db $A3
	db $44, $40
	db $A8
	db $44
	db $A3
	db $48
	db $A4
	db $4E, $52
	db $A5
	db $58, $01
	db $00

Segment_768E::
	db $A3
	db $1E
	db $A2
	db $36, $2C
	db $A3
	db $1E, $36
	db $A3
	db $1E
	db $A2
	db $36, $2C
	db $A3
	db $1E, $36
	db $A3
	db $1A
	db $A2
	db $32, $28
	db $A3
	db $1A, $32
	db $A3
	db $1A
	db $A2
	db $32, $28
	db $A3
	db $1A, $32
	db $A3
	db $30
	db $A2
	db $48, $26
	db $A3
	db $30, $48
	db $A3
	db $30
	db $A2
	db $48, $26
	db $A3
	db $30, $48
	db $A3
	db $1E
	db $A2
	db $36, $2C
	db $A3
	db $1E, $36
	db $A3
	db $1E
	db $A2
	db $36, $2C
	db $A3
	db $1E, $36
	db $A5
	db $22, $22, $1A, $1A, $1E, $1E, $22, $22
	db $00

Segment_76D8::
	db $A3
	Noise 1
	db $A2
	Noise 1, 1
	db $A3
	Noise 2
	db $A2
	Noise 1, 1
	db $A3
	Noise 1
	db $A2
	Noise 1, 1
	db $A3
	Noise 2
	db $A2
	Noise 1, 1
	db $00

Channel1_76ED::
	dw Segment_7728, Segment_775E, Segment_7866, $FFFF, $76EF

Channel2_76F7::
	dw Segment_7715, Segment_77A2, Segment_7832, $FFFF, $76F9

Channel3_7701::
	dw Segment_7735, Segment_780E, Segment_780E, Segment_7893, $FFFF, $7703

Channel4_770D::
	dw Segment_7746, Segment_78C3, $FFFF, $770F

Segment_7715::
	db $9D, $92, $00, $80
	db $A2
	db $52, $01, $50, $01, $4E, $4A, $01, $01, $01
	db $A7
	db $40
	db $A4
	db $28
	db $00

Segment_7728::
	db $9D, $62, $00, $80
	db $A5
	db $01
	db $A2
	db $01
	db $A7
	db $28
	db $A4
	db $10
	db $00

Segment_7735::
	db $9D, $3B, $6F, $20
	db $A2
	db $70, $01, $6E, $01, $6C, $6A, $01, $01
	db $A4
	db $01, $40
	db $00

Segment_7746::
	db $A6
	Noise 1
	db $A1
	Noise 1
	db $A3
	Noise 2
	db $A6
	Noise 1
	db $A1
	Noise 1
	db $A3
	Noise 2
	db $A2
	Noise 0, 1, 0, 0
	db $A6
	Noise 2
	db $A1
	Noise 1
	db $A3
	Noise 1
	db $00

Segment_775E::
	db $A3
	db $01, $3A, $01, $3A, $01, $3A, $01, $3A, $01, $3A, $01, $3A, $01, $3A, $01, $3A, $01, $4A, $01, $4A, $01, $4A, $01, $4A
	db $A5
	db $01
	db $A3
	db $01, $6E
	db $A4
	db $6E
	db $A3
	db $01, $3A, $01, $3A, $01, $3A, $01, $3A, $01, $3A, $01, $3A, $01, $3A, $01, $3A, $01, $4A, $01, $4A, $01, $4A, $01, $4A
	db $A5
	db $01
	db $A6
	db $01
	db $A1
	db $6E
	db $A3
	db $01
	db $A4
	db $56
	db $00

Segment_77A2::
	db $A3
	db $52, $01
	db $A6
	db $4E
	db $A1
	db $4A
	db $A6
	db $01
	db $A1
	db $52
	db $A8
	db $01
	db $A6
	db $4A
	db $A1
	db $4E
	db $A2
	db $52, $01, $52, $01
	db $A3
	db $4E, $4A, $52, $54, $58, $5C, $01, $4A, $4A, $44, $40
	db $A6
	db $01
	db $A1
	db $4A
	db $A4
	db $01
	db $A3
	db $3C, $40, $44, $48
	db $A3
	db $01, $70
	db $A4
	db $70
	db $A3
	db $52, $01
	db $A6
	db $4E
	db $A1
	db $4A
	db $A6
	db $01
	db $A1
	db $52
	db $A8
	db $01
	db $A6
	db $4A
	db $A1
	db $4E
	db $A2
	db $52, $01, $52, $01
	db $A3
	db $4E, $4A, $5C, $58, $62
	db $A6
	db $52
	db $A1
	db $4E
	db $A3
	db $01, $4A, $4A, $4E, $52
	db $A6
	db $01
	db $A1
	db $4A
	db $A4
	db $01
	db $A3
	db $54, $52, $4A, $4E
	db $A6
	db $01
	db $A1
	db $70
	db $A3
	db $01
	db $A4
	db $58
	db $00

Segment_780E::
	db $A3
	db $32
	db $A6
	db $58
	db $A1
	db $28
	db $A3
	db $32, $58, $32, $5A, $32, $5A, $32, $5C, $32, $5C, $32, $5E, $44, $5E, $3C, $5C, $3C, $5C, $3A, $58, $3A, $58, $4E, $52, $54, $56
	db $A5
	db $01
	db $00

Segment_7832::
	db $A3
	db $01, $5C, $60, $62
	db $A3
	db $60
	db $A6
	db $01
	db $A1
	db $58
	db $A4
	db $01
	db $A3
	db $54, $01
	db $A6
	db $58
	db $A1
	db $54
	db $A3
	db $01
	db $A2
	db $52, $01, $54, $01, $56, $01, $58, $01
	db $A3
	db $01, $5C, $60, $62
	db $A3
	db $60
	db $A6
	db $01
	db $A1
	db $58
	db $A4
	db $01
	db $A3
	db $68, $66, $01, $62
	db $A5
	db $01
	db $00

Segment_7866::
	db $A3
	db $01, $4A, $4E, $44, $4E
	db $A6
	db $40
	db $A1
	db $48
	db $A3
	db $01, $40, $44, $3C
	db $A6
	db $48
	db $A1
	db $44
	db $A3
	db $36
	db $A5
	db $01
	db $A3
	db $01, $4A, $4E, $44, $4E
	db $A6
	db $40
	db $A1
	db $48
	db $A3
	db $01, $40, $32, $32, $01, $32, $01, $01, $01, $01
	db $00

Segment_7893::
	db $A3
	db $3C, $4A, $3C, $4A, $3A, $4A, $3A, $4A, $36, $5C, $36, $5C
	db $A2
	db $4A, $01, $4E, $01, $50, $01, $52, $01
	db $A3
	db $3C, $4A, $3C, $4A, $3A, $4A, $3A, $4A, $42, $50, $42, $50
	db $A1
	db $58, $01, $58, $01
	db $A2
	db $54, $01, $52, $01, $4E, $01
	db $00

Segment_78C3::
	db $A3
	Noise 1
	db $A6
	Noise 1
	db $A1
	Noise 1
	db $A3
	Noise 2
	db $A6
	Noise 1
	db $A1
	Noise 1
	db $A3
	Noise 1
	db $A6
	Noise 1
	db $A1
	Noise 1
	db $A3
	Noise 2
	db $A6
	Noise 1
	db $A1
	Noise 1
	db $00

Song_78DC::
	db $00
	dw $6F72
	dw Channel1_7CDC
	dw Channel2_7CE2
	dw $0000
	dw Channel4_7CE8

Song_78E7::
	db $00
	dw $6F7B
	dw Channel1_7C7D
	dw Channel2_7C81
	dw Channel3_7C83
	dw $0000

Song_78F2::
	db $00
	dw $6F66
	dw Channel1_7C2B
	dw Channel2_7C31
	dw Channel3_7C37
	dw Channel4_7C3D

Song_78FD::
	db $00
	dw $6F66
	dw Channel1_7B32
	dw Channel2_7B48
	dw Channel3_7B5C
	dw Channel4_7B60

Song_7908::
	db $00
	dw $6F5B
	dw Channel1_7ACD
	dw $0000
	dw Channel3_7AD1
	dw $0000

Song_7913::
	db $00
	dw $6F66
	dw Channel1_7B03
	dw Channel2_7B07
	dw $0000
	dw $0000

Song_791E::
	db $00
	dw $6F86
	dw Channel1_7A5C
	dw Channel2_7A66
	dw $0000
	dw $0000

Song_7929::
	db $00
	dw $6F86
	dw Channel1_7A1A
	dw Channel2_7A1E
	dw Channel3_7A20
	dw $0000

Song_7934::
	db $00
	dw $6F7B
	dw Channel1_79E2
	dw Channel2_79E8
	dw $0000
	dw $0000

Song_793F::
	db $00
	dw $6F7B
	dw Channel1_794A
	dw Channel2_7952
	dw Channel3_795A
	dw Channel4_7962

Channel1_794A::
	dw Segment_7968, Segment_79AD, $FFFF, $794C

Channel2_7952::
	dw Segment_7979, Segment_79C2, $FFFF, $7954

Channel3_795A::
	dw Segment_798A, Segment_79D0, $FFFF, $795C

Channel4_7962::
	dw Segment_799B, $FFFF, $7962

Segment_7968::
	db $9D, $90, $00, $00
	db $A5
	db $01, $1E, $20
	db $A4
	db $22, $24
	db $A3
	db $26, $28, $2A, $2C
	db $00

Segment_7979::
	db $9D, $A0, $00, $00
	db $A5
	db $01, $10, $12
	db $A4
	db $14, $16
	db $A3
	db $18, $1A, $1C, $1E
	db $00

Segment_798A::
	db $9D, $3B, $6F, $20
	db $A5
	db $01, $28, $2A
	db $A4
	db $2C, $2E
	db $A3
	db $30, $32, $34, $36
	db $00

Segment_799B::
	db $A1
	Noise 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1
	db $00

Segment_79AD::
	db $9D, $60, $00, $C1
	db $A4
	db $1E, $2A, $28, $34
	db $A5
	db $32, $01
	db $A4
	db $1E, $2A, $28, $34
	db $A5
	db $36, $01
	db $00

Segment_79C2::
	db $9D, $83, $00, $00
	db $A2
	db $10, $0E, $0C, $0A, $08, $06, $04, $02
	db $00

Segment_79D0::
	db $A1
	db $28, $40, $26, $3E, $24, $3C, $22, $3A, $20, $38, $1E, $36, $1C, $34, $1A, $32
	db $00

Channel1_79E2::
	dw Segment_79EE, $FFFF, $79E2

Channel2_79E8::
	dw Segment_7A04, $FFFF, $79E8

Segment_79EE::
	db $9D, $84, $00, $80
	db $A2
	db $40, $42, $40, $42, $40, $42, $40, $42, $40, $46, $4C, $52, $58, $52, $4C, $46
	db $00

Segment_7A04::
	db $9D, $74, $00, $80
	db $A2
	db $10, $12, $10, $12, $10, $12, $10, $12, $22, $28, $2E, $34, $3A, $34, $2E, $28
	db $00

Channel1_7A1A::
	dw Segment_7A22, $0000

Channel2_7A1E::
	dw Segment_7A3C

Channel3_7A20::
	dw Segment_7A4F

Segment_7A22::
	db $9D, $60, $00, $81
	db $A3
	db $3C, $4A, $54, $4A, $40, $4A, $3C, $3A, $2A
	db $9D, $30, $00, $81
	db $A1
	db $3A, $3C, $3A, $36
	db $A4
	db $3A
	db $00

Segment_7A3C::
	db $9D, $80, $00, $81
	db $A3
	db $44, $4A, $5C
	db $A4
	db $58
	db $A3
	db $52
	db $A4
	db $4A
	db $A3
	db $4E
	db $A5
	db $4A
	db $00

Segment_7A4F::
	db $9D, $3B, $6F, $21
	db $A8
	db $54, $52
	db $A4
	db $42
	db $A3
	db $3C
	db $A5
	db $32
Channel1_7A5C::
	dw Segment_7A6E, Segment_7A8C, Segment_7A6E, Segment_7A95, $0000

Channel2_7A66::
	dw Segment_7A9D, Segment_7ABC, Segment_7A9D, Segment_7AC5

Segment_7A6E::
	db $9D, $66, $00, $81
	db $A3
	db $58, $60, $66, $60, $56, $60, $66, $60, $54, $60, $66, $60, $52, $58, $62, $58, $50, $58, $62, $58, $4E, $58, $60, $58
	db $00

Segment_7A8C::
	db $4C, $52, $58, $5C, $58, $4A, $56, $4E
	db $00

Segment_7A95::
	db $52, $58, $5C, $56
	db $A4
	db $60, $40
	db $00

Segment_7A9D::
	db $9D, $66, $00, $81
	db $A4
	db $78
	db $A3
	db $74, $70
	db $A8
	db $78
	db $A2
	db $70, $74
	db $A3
	db $78, $78, $74, $70, $78, $7A, $7E, $82, $01, $70, $70, $68
	db $A4
	db $66, $78
	db $00

Segment_7ABC::
	db $A3
	db $6A, $70, $74, $78
	db $A4
	db $74, $66
	db $00

Segment_7AC5::
	db $A3
	db $7A, $6A, $6E, $66
	db $A5
	db $70
	db $00

Channel1_7ACD::
	dw Segment_7AD3, $0000

Channel3_7AD1::
	dw Segment_7AE5

Segment_7AD3::
	db $9D, $50, $00, $80
	db $A1
	db $40, $01, $40, $01, $40, $01
	db $A3
	db $42
	db $A2
	db $46
	db $A4
	db $4A
	db $00

Segment_7AE5::
	db $9D, $1B, $6F, $A0
	db $A2
	db $78, $78, $78
	db $A3
	db $7A
	db $A2
	db $7E
	db $A1
	db $82, $70, $82, $70, $82, $70, $82, $70, $82, $70, $82, $70, $82, $70, $82, $70
	db $00

Channel1_7B03::
	dw Segment_7B09, $0000

Channel2_7B07::
	dw Segment_7B1E

Segment_7B09::
	db $9D, $73, $00, $80
	db $A3
	db $1E
	db $A1
	db $01
	db $A3
	db $1E
	db $A1
	db $01
	db $A3
	db $1E
	db $A1
	db $01
	db $A3
	db $1E
	db $A1
	db $01
	db $00

Segment_7B1E::
	db $9D, $D3, $00, $C0
	db $A3
	db $1C
	db $A1
	db $01
	db $A3
	db $1C
	db $A1
	db $01
	db $A3
	db $1C
	db $A1
	db $01
	db $A3
	db $1C
	db $A1
	db $01
Channel1_7B32::
	dw Segment_7B66, Segment_7B6D, Segment_7B87, Segment_7B6D, Segment_7B8A, Segment_7B66, Segment_7B6D, Segment_7B87, Segment_7B6D, Segment_7B8A, $0000

Channel2_7B48::
	dw Segment_7B91, Segment_7B98, Segment_7BB0, Segment_7B98, Segment_7BB9, Segment_7B91, Segment_7B98, Segment_7BB0, Segment_7B98, Segment_7BB9

Channel3_7B5C::
	dw Segment_7BC0, Segment_7BC0

Channel4_7B60::
	dw Segment_7C06, $FFFF, $7B60

Segment_7B66::
	db $9D, $93, $00, $80
	db $A3
	db $01
	db $00

Segment_7B6D::
	db $A2
	db $01, $4A, $01, $4A, $01, $4A, $01, $4A, $01, $4A, $01, $4A, $01, $4A, $01, $4A, $01, $40, $01, $40, $01, $40, $01, $40
	db $00

Segment_7B87::
	db $A5
	db $01
	db $00

Segment_7B8A::
	db $01, $4A, $01, $4A, $4A, $01
	db $00

Segment_7B91::
	db $9D, $C3, $00, $C0
	db $A3
	db $38
	db $00

Segment_7B98::
	db $A4
	db $42
	db $A2
	db $46, $4C, $4A, $46
	db $A3
	db $50, $50
	db $A2
	db $50, $54, $4A, $4C
	db $A3
	db $46, $46
	db $A2
	db $46, $4C, $4A, $46
	db $00

Segment_7BB0::
	db $42, $5A, $58, $54, $50, $4C, $4A, $46
	db $00

Segment_7BB9::
	db $42, $50, $46, $4A, $42, $01
	db $00

Segment_7BC0::
	db $9D, $1B, $6F, $20
	db $A3
	db $01
	db $A2
	db $42, $50, $38, $50, $42, $50, $38, $50, $42, $50, $38, $50, $42, $50, $38, $50, $38, $5E, $46, $5E, $38, $5E, $46, $5E, $42, $5A, $58, $54, $50, $4C, $4A, $46, $42, $50, $38, $50, $42, $50, $38, $50, $42, $50, $38, $50, $42, $50, $38, $50, $38, $5E, $46, $5E, $38, $5E, $46, $5E, $42, $50, $38, $50, $42, $01
	db $00

Segment_7C06::
	db $A3
	Noise 0
	db $A2
	Noise 1, 2, 1, 2, 1, 2, 2, 2, 1, 2, 1, 2, 1
	db $A1
	Noise 2, 2
	db $A2
	Noise 1, 2, 1, 2, 1, 2, 1, 2, 2, 2, 2, 1, 2, 1, 2, 0
	db $00

Channel1_7C2B::
	dw Segment_7C4F, $FFFF, $7C2B

Channel2_7C31::
	dw Segment_7C43, $FFFF, $7C31

Channel3_7C37::
	dw Segment_7C5B, $FFFF, $7C37

Channel4_7C3D::
	dw Segment_7C70, $FFFF, $7C3D

Segment_7C43::
	db $9D, $54, $00, $80
	db $A2
	db $50, $4E, $4C, $4A, $48, $46
	db $00

Segment_7C4F::
	db $9D, $34, $00, $80
	db $A2
	db $3A, $38, $36, $34, $32, $30
	db $00

Segment_7C5B::
	db $9D, $1B, $6F, $20
	db $A8
	db $44
	db $A7
	db $44, $4A
	db $A8
	db $50, $50
	db $A8
	db $44
	db $A7
	db $44, $4A
	db $A8
	db $50, $50
	db $00

Segment_7C70::
	db $A2
	Noise 1, 1, 1
	db $A7
	Noise 2
	db $A2
	Noise 1, 1, 1
	db $A7
	Noise 2
	db $00

Channel1_7C7D::
	dw Segment_7C98, $0000

Channel2_7C81::
	dw Segment_7C85

Channel3_7C83::
	dw Segment_7CAD

Segment_7C85::
	db $9D, $D1, $00, $80
	db $A7
	db $32, $36, $3A, $3C, $40, $44, $48, $4A, $4E, $52, $54, $58, $5C
	db $00

Segment_7C98::
	db $9D, $41, $00, $80
	db $AA
	db $01
	db $A7
	db $32, $36, $3A, $3C, $40, $44, $48, $4A, $4E, $52, $54, $58, $5C
	db $00

Segment_7CAD::
	db $9D, $3B, $6F, $20
	db $A2
	db $4A, $01, $52, $4E, $01, $54, $52, $01, $58, $54, $01, $5C, $58, $01, $60, $5C, $01, $62, $60, $01, $66, $62, $01, $6A, $66, $01, $6C, $6A, $01, $70, $6C, $01, $74, $70, $01, $78, $74, $01, $7A, $78, $01, $7E
Channel1_7CDC::
	dw Segment_7CEE, $FFFF, $7CDC

Channel2_7CE2::
	dw Segment_7D14, $FFFF, $7CE2

Channel4_7CE8::
	dw Segment_7D5A, $FFFF, $7CE8

Segment_7CEE::
	db $9D, $91, $00, $80
	db $A2
	db $40, $4E, $40, $4E, $40, $4E, $40, $4E, $44, $52, $44, $4E, $44, $52, $44, $4E, $4A, $58, $4A, $58, $4A, $58, $4A, $58, $4E, $4E, $4A, $4A, $48, $48, $44, $44
	db $00

Segment_7D14::
	db $9D, $91, $00, $80
	db $A1
	db $60, $66, $70, $60, $66, $70, $60, $66, $70, $60, $66, $70, $60, $66, $70, $01, $5C, $64, $70, $5C, $64, $70, $5C, $64, $70, $5C, $64, $70, $5C, $64, $70, $01, $62, $6A, $70, $62, $6A, $70, $62, $6A, $70, $62, $6A, $70, $62, $6A, $70, $01, $6E, $5C, $6E, $5C, $6A, $70, $6A, $58, $66, $56, $66, $56, $62, $6A, $62, $52
	db $00

Segment_7D5A::
	db $A2
	Noise 1
	db $A1
	Noise 1, 1
	db $A2
	Noise 1
	db $A1
	Noise 1, 1
	db $A2
	Noise 1
	db $A1
	Noise 1, 1
	db $00

Song_7D6A::
	db $00
	dw $6F7B
	dw Channel1_7D75
	dw Channel2_7D83
	dw Channel3_7D91
	dw Channel4_7DAB

Channel1_7D75::
	dw Segment_7DB9, Segment_7DC5, Segment_7DE7, Segment_7DE7, Segment_7E14, $FFFF, $7D79

Channel2_7D83::
	dw Segment_7DC0, Segment_7DC5, Segment_7DE7, Segment_7DE7, Segment_7E14, $FFFF, $7D87

Channel3_7D91::
	dw Segment_7E3F, Segment_7E44, Segment_7E44, Segment_7E56, Segment_7E56, Segment_7E67, Segment_7E67, Segment_7E89, Segment_7EA3, Segment_7E89, Segment_7EAC, $FFFF, $7D9B

Channel4_7DAB::
	dw Segment_7ECD, Segment_7ECD, Segment_7ECD, Segment_7ECD, Segment_7EF6, $FFFF, $7DB3

Segment_7DB9::
	db $9D, $30, $00, $81
	db $AA
	db $01
	db $00

Segment_7DC0::
	db $9D, $90, $00, $81
	db $00

Segment_7DC5::
	db $A3
	db $4C, $3A, $44, $4C, $50, $3E, $48, $50, $52, $40, $4A, $52, $56, $44, $4E, $56, $5A, $48, $52, $5A, $5C, $4A, $52, $5C, $5A, $48, $52, $5A, $5C, $4A, $52, $5C
	db $00

Segment_7DE7::
	db $A2
	db $5A, $01, $01, $52, $01, $01, $48, $01, $01, $56, $01, $5C, $01, $5A, $56
	db $A5
	db $52, $01
	db $A2
	db $01
	db $A2
	db $5A, $01, $01, $52, $01, $01, $48, $01
	db $A4
	db $52
	db $A2
	db $01, $50, $52
	db $A4
	db $56
	db $A2
	db $01
	db $A4
	db $4C, $50, $01
	db $00

Segment_7E14::
	db $A8
	db $52
	db $A2
	db $50, $52
	db $A4
	db $56, $48
	db $A8
	db $5A
	db $A2
	db $56, $5A
	db $A3
	db $5C, $4C, $52, $50
	db $A8
	db $52
	db $A2
	db $50, $52
	db $A4
	db $56, $48
	db $A8
	db $5A
	db $A2
	db $56, $5A
	db $A3
	db $60, $4A, $52, $58
	db $A4
	db $5C, $62
	db $A5
	db $5A, $56
	db $00

Segment_7E3F::
	db $9D, $3B, $6F, $A0
	db $00

Segment_7E44::
	db $A2
	db $44, $44, $5C, $5C, $44, $44, $5C, $5C, $44, $44, $5C, $5C, $44, $44, $5C, $5C
	db $00

Segment_7E56::
	db $3A, $3A, $52, $52, $3A, $3A, $52, $52, $3A, $3A, $52, $52, $3A, $3A, $52, $52
	db $00

Segment_7E67::
	db $A3
	db $52, $52, $52, $52, $50, $50, $50, $50, $4E, $4E, $4E, $4E, $4C, $4C, $4C, $4C, $44, $44, $44, $44, $42, $42, $42, $42, $3E, $3E, $3E, $3E, $48, $48, $48, $48
	db $00

Segment_7E89::
	db $A2
	db $2C, $2C, $44, $44, $2C, $2C, $44, $44, $2C, $2C, $44, $44, $2C, $2C, $44, $44, $2A, $2A, $42, $42, $2A, $2A, $42, $42
	db $00

Segment_7EA3::
	db $26, $26, $3E, $3E, $30, $30, $48, $48
	db $00

Segment_7EAC::
	db $28, $28, $40, $40, $28, $28, $40, $40, $28, $28, $40, $40, $28, $28, $40, $40, $30, $30, $3A, $42, $30, $30, $3A, $42, $30, $30, $38, $3E, $30, $30, $38, $3E
	db $00

Segment_7ECD::
	db $A1
	Noise 1, 1
	db $A2
	Noise 2
	db $A1
	Noise 1, 1
	db $A2
	Noise 2
	db $A1
	Noise 1, 1
	db $A2
	Noise 2
	db $A1
	Noise 1, 1
	db $A2
	Noise 2
	db $A1
	Noise 1, 1
	db $A2
	Noise 2
	db $A1
	Noise 1, 1
	db $A2
	Noise 2
	db $A1
	Noise 1, 1
	db $A2
	Noise 2
	db $A1
	Noise 1, 1
	db $A2
	Noise 2
	db $00

Segment_7EF6::
	db $A2
	Noise 1, 1, 3, 1, 1, 1, 3, 1, 1, 1, 3, 1, 1, 1, 3, 1
	db $00

