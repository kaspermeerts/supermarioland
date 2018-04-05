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
	db $01
	db $01
	db $00

Segment_7024::
	db $9D, $76, $00, $81
	db $A4
	db $42
	db $3E
	db $3A
	db $A9
	db $36
	db $36
	db $36
	db $36
	db $36
	db $36
	db $00

Segment_7034::
	db $9D, $3B, $6F, $A0
	db $A4
	db $52
	db $4E
	db $4C
	db $A9
	db $48
	db $48
	db $48
	db $48
	db $48
	db $48
	db $00

Segment_7044::
	db $A4
	db $01
	db $A9
	db $3A
	db $01
	db $A3
	db $3E
	db $A2
	db $4C
	db $A7
	db $01
	db $A9
	db $34
	db $4C
	db $01
	db $48
	db $A3
	db $44
	db $3E
	db $A9
	db $44
	db $01
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
	db $3E
	db $01
	db $3E
	db $01
	db $01
	db $3E
	db $01
	db $01
	db $01
	db $01
	db $01
	db $3A
	db $A3
	db $36
	db $34
	db $A9
	db $30
	db $01
	db $34
	db $01
	db $01
	db $42
	db $A4
	db $01
	db $A5
	db $01
	db $A4
	db $01
	db $A9
	db $3E
	db $01
	db $3E
	db $01
	db $01
	db $3E
	db $01
	db $01
	db $01
	db $01
	db $01
	db $3A
	db $A3
	db $36
	db $34
	db $A5
	db $01
	db $01
	db $00

Segment_7094::
	db $A4
	db $01
	db $A9
	db $4C
	db $01
	db $A3
	db $4E
	db $A2
	db $52
	db $A7
	db $01
	db $A9
	db $44
	db $52
	db $01
	db $4E
	db $A3
	db $4C
	db $48
	db $A9
	db $4C
	db $01
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
	db $4E
	db $01
	db $4E
	db $01
	db $01
	db $4E
	db $01
	db $01
	db $01
	db $01
	db $01
	db $4C
	db $A3
	db $48
	db $44
	db $A9
	db $42
	db $01
	db $44
	db $01
	db $01
	db $48
	db $A4
	db $01
	db $A5
	db $01
	db $A4
	db $01
	db $A9
	db $4E
	db $01
	db $4E
	db $01
	db $01
	db $4E
	db $01
	db $01
	db $01
	db $01
	db $01
	db $4C
	db $A3
	db $48
	db $44
	db $A4
	db $42
	db $3E
	db $3A
	db $36
	db $00

Segment_70E6::
	db $A3
	db $44
	db $A9
	db $44
	db $01
	db $3A
	db $A3
	db $44
	db $A9
	db $44
	db $01
	db $3A
	db $A3
	db $44
	db $A9
	db $44
	db $01
	db $3A
	db $A3
	db $44
	db $A9
	db $44
	db $01
	db $3A
	db $A3
	db $36
	db $A9
	db $36
	db $01
	db $44
	db $A3
	db $36
	db $A9
	db $36
	db $01
	db $44
	db $A3
	db $36
	db $A9
	db $36
	db $01
	db $44
	db $A3
	db $36
	db $A9
	db $36
	db $01
	db $44
	db $00

Segment_7117::
	db $A3
	db $48
	db $A9
	db $48
	db $01
	db $3E
	db $A3
	db $48
	db $A9
	db $48
	db $01
	db $3E
	db $A3
	db $48
	db $A9
	db $48
	db $01
	db $3E
	db $A3
	db $48
	db $A9
	db $48
	db $01
	db $3E
	db $A3
	db $3A
	db $A9
	db $3A
	db $01
	db $48
	db $A3
	db $3A
	db $A9
	db $3A
	db $01
	db $48
	db $A3
	db $3A
	db $A9
	db $3A
	db $01
	db $48
	db $A3
	db $3A
	db $A9
	db $3A
	db $01
	db $48
	db $A3
	db $48
	db $A9
	db $48
	db $01
	db $3E
	db $A3
	db $48
	db $A9
	db $48
	db $01
	db $3E
	db $A3
	db $48
	db $A9
	db $48
	db $01
	db $3E
	db $A3
	db $48
	db $A9
	db $48
	db $01
	db $3E
	db $A3
	db $52
	db $52
	db $4E
	db $4E
	db $4C
	db $4C
	db $48
	db $48
	db $00

Segment_7169::
	db $A3
	db $06
	db $06
	db $06
	db $06
	db $0B
	db $0B
	db $A9
	db $0B
	db $0B
	db $0B
	db $0B
	db $0B
	db $0B
	db $00

Segment_7178::
	db $A9
	db $06
	db $01
	db $01
	db $10
	db $01
	db $06
	db $01
	db $06
	db $01
	db $10
	db $01
	db $06
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
	db $1A
	db $01
	db $22
	db $10
	db $14
	db $18
	db $1A
	db $01
	db $28
	db $22
	db $01
	db $01
	db $1A
	db $01
	db $22
	db $10
	db $14
	db $18
	db $1A
	db $01
	db $A3
	db $01
	db $A9
	db $01
	db $01
	db $00

Segment_71B9::
	db $9D, $93, $00, $80
	db $A2
	db $1A
	db $01
	db $22
	db $10
	db $14
	db $18
	db $1A
	db $01
	db $28
	db $22
	db $01
	db $01
	db $1A
	db $01
	db $22
	db $10
	db $14
	db $18
	db $1A
	db $01
	db $A4
	db $01
	db $00

Segment_71D5::
	db $A2
	db $06
	db $01
	db $01
	db $06
	db $01
	db $06
	db $06
	db $01
	db $06
	db $06
	db $01
	db $01
	db $06
	db $01
	db $01
	db $06
	db $01
	db $06
	db $06
	db $01
	db $A4
	db $01
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
	db $38
	db $3E
	db $38
	db $AB
	db $01
	db $A8
	db $36
	db $A3
	db $28
	db $2A
	db $A2
	db $2A
	db $2E
	db $A3
	db $2A
	db $2E
	db $A5
	db $28
	db $A4
	db $40
	db $A3
	db $3E
	db $A9
	db $38
	db $3E
	db $38
	db $AB
	db $01
	db $A8
	db $36
	db $A3
	db $28
	db $2A
	db $A2
	db $2A
	db $2E
	db $A3
	db $32
	db $A1
	db $2E
	db $32
	db $2E
	db $2A
	db $A5
	db $28
	db $00

Segment_725E::
	db $A5
	db $2A
	db $A4
	db $01
	db $32
	db $A5
	db $3C
	db $A4
	db $38
	db $A3
	db $38
	db $A2
	db $3C
	db $38
	db $A5
	db $36
	db $01
	db $01
	db $01
	db $00

Segment_7272::
	db $9D, $3B, $6F, $A0
	db $00

Segment_7277::
	db $A3
	db $40
	db $42
	db $40
	db $42
	db $40
	db $42
	db $40
	db $4E
	db $40
	db $42
	db $40
	db $42
	db $40
	db $42
	db $40
	db $3C
	db $00

Segment_7289::
	db $42
	db $50
	db $42
	db $50
	db $42
	db $50
	db $42
	db $50
	db $00

Segment_7292::
	db $A3
	db $06
	db $A2
	db $06
	db $06
	db $A3
	db $06
	db $A2
	db $06
	db $06
	db $A3
	db $06
	db $A2
	db $06
	db $06
	db $A3
	db $0B
	db $A2
	db $06
	db $06
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
	db $58
	db $54
	db $52
	db $4E
	db $4A
	db $A6
	db $01
	db $A2
	db $40
	db $01
	db $32

Segment_72C5::
	db $9D, $B1, $00, $80
	db $A1
	db $58
	db $54
	db $52
	db $4E
	db $4A
	db $A6
	db $01
	db $A2
	db $4E
	db $01
	db $52
	db $00

Segment_72D6::
	db $9D, $3B, $6F, $20
	db $A1
	db $58
	db $54
	db $52
	db $4E
	db $4A
	db $A6
	db $01
	db $A2
	db $60
	db $01
	db $62
	db $01
	db $01

Segment_72E8::
	db $A1
	db $06
	db $06
	db $06
	db $06
	db $06
	db $A6
	db $01
	db $A3
	db $06
	db $06

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
	db $52
	db $01
	db $52
	db $01
	db $52
	db $01
	db $A8
	db $56
	db $58
	db $5A
	db $00

Segment_730F::
	db $9D, $83, $00, $80
	db $A8
	db $4A
	db $A2
	db $4A
	db $01
	db $4A
	db $01
	db $4A
	db $01
	db $A8
	db $4E
	db $50
	db $52
	db $00

Segment_7321::
	db $9D, $1B, $6F, $21
	db $A8
	db $70
	db $A2
	db $70
	db $01
	db $70
	db $01
	db $70
	db $01
	db $A8
	db $74
	db $76
	db $78
	db $00

Segment_7333::
	db $A8
	db $06
	db $A3
	db $06
	db $06
	db $06
	db $A8
	db $06
	db $06
	db $06
	db $06

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
	db $40
	db $44
	db $01
	db $48
	db $01
	db $44
	db $01
	db $40
	db $A5
	db $3C
	db $00

Segment_737A::
	db $9D, $82, $00, $80
	db $A2
	db $4A
	db $4A
	db $01
	db $4A
	db $01
	db $4A
	db $01
	db $4A
	db $A5
	db $44
	db $00

Segment_738A::
	db $9D, $3B, $6F, $20
	db $A2
	db $52
	db $54
	db $01
	db $58
	db $01
	db $54
	db $01
	db $52
	db $40
	db $36
	db $01
	db $30
	db $28
	db $01
	db $01
	db $01
	db $00

Segment_73A0::
	db $A2
	db $06
	db $06
	db $01
	db $06
	db $01
	db $06
	db $01
	db $06
	db $A5
	db $06
	db $00

Segment_73AC::
	db $A2
	db $3A
	db $01
	db $01
	db $A7
	db $40
	db $A3
	db $3A
	db $A4
	db $01
	db $32
	db $AA
	db $36
	db $44
	db $44
	db $44
	db $48
	db $4A
	db $A5
	db $01
	db $A2
	db $3A
	db $3A
	db $01
	db $A7
	db $40
	db $A3
	db $3A
	db $A5
	db $01
	db $AA
	db $48
	db $01
	db $01
	db $36
	db $3A
	db $3C
	db $A5
	db $3A
	db $00

Segment_73D4::
	db $A2
	db $4A
	db $01
	db $01
	db $A7
	db $52
	db $A3
	db $4A
	db $A2
	db $44
	db $4E
	db $01
	db $54
	db $A4
	db $44
	db $AA
	db $48
	db $54
	db $54
	db $54
	db $58
	db $5C
	db $A2
	db $58
	db $52
	db $01
	db $4A
	db $A4
	db $40
	db $A2
	db $4A
	db $4A
	db $01
	db $A7
	db $52
	db $A3
	db $4A
	db $A2
	db $44
	db $4E
	db $01
	db $54
	db $A4
	db $44
	db $AA
	db $48
	db $01
	db $01
	db $48
	db $4A
	db $4E
	db $A5
	db $4A
	db $00

Segment_740A::
	db $A7
	db $32
	db $3A
	db $A3
	db $40
	db $A7
	db $3C
	db $44
	db $A3
	db $4A
	db $A7
	db $40
	db $48
	db $A3
	db $36
	db $A7
	db $32
	db $3A
	db $A3
	db $40
	db $A7
	db $32
	db $3A
	db $A3
	db $40
	db $A7
	db $3C
	db $44
	db $A3
	db $4A
	db $A7
	db $40
	db $48
	db $A3
	db $36
	db $A7
	db $32
	db $3A
	db $A3
	db $40
	db $00

Segment_7433::
	db $AA
	db $44
	db $44
	db $44
	db $44
	db $40
	db $3C
	db $A7
	db $40
	db $32
	db $A3
	db $01
	db $A2
	db $36
	db $01
	db $01
	db $36
	db $36
	db $3A
	db $01
	db $3C
	db $A5
	db $40
	db $AA
	db $44
	db $01
	db $44
	db $44
	db $48
	db $4A
	db $A7
	db $48
	db $40
	db $A3
	db $01
	db $A7
	db $44
	db $40
	db $A3
	db $3C
	db $A2
	db $01
	db $3C
	db $01
	db $01
	db $A4
	db $40
	db $00

Segment_7463::
	db $AA
	db $54
	db $54
	db $54
	db $54
	db $52
	db $4E
	db $A7
	db $52
	db $4A
	db $A3
	db $01
	db $A2
	db $48
	db $01
	db $01
	db $48
	db $48
	db $4A
	db $01
	db $4E
	db $A5
	db $52
	db $AA
	db $54
	db $01
	db $54
	db $54
	db $58
	db $5C
	db $A7
	db $58
	db $52
	db $A3
	db $01
	db $A7
	db $54
	db $52
	db $A3
	db $4E
	db $A2
	db $01
	db $44
	db $01
	db $01
	db $A4
	db $48
	db $00

Segment_7493::
	db $A7
	db $3C
	db $44
	db $A3
	db $4A
	db $A7
	db $32
	db $3A
	db $A3
	db $40
	db $A7
	db $40
	db $48
	db $A3
	db $36
	db $A7
	db $32
	db $3A
	db $A3
	db $40
	db $A7
	db $3C
	db $44
	db $A3
	db $4A
	db $A7
	db $3A
	db $40
	db $A3
	db $48
	db $A7
	db $3C
	db $44
	db $A3
	db $4A
	db $A2
	db $01
	db $40
	db $01
	db $01
	db $A4
	db $40
	db $00

Segment_74BE::
	db $A3
	db $06
	db $A9
	db $06
	db $01
	db $06
	db $A3
	db $0B
	db $A9
	db $06
	db $01
	db $06
	db $A3
	db $06
	db $A9
	db $06
	db $01
	db $06
	db $A3
	db $0B
	db $A9
	db $06
	db $01
	db $06
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
	db $70
	db $70
	db $70
	db $01
	db $6A
	db $01
	db $6A
	db $01
	db $66
	db $01
	db $66
	db $01
	db $A4
	db $6A
	db $00

Segment_7523::
	db $9D, $74, $00, $00
	db $A2
	db $66
	db $66
	db $66
	db $01
	db $60
	db $01
	db $60
	db $01
	db $5C
	db $01
	db $5C
	db $01
	db $A4
	db $60
	db $00

Segment_7537::
	db $9D, $3B, $6F, $20
	db $A5
	db $01
	db $01
	db $00

Segment_753F::
	db $A5
	db $01
	db $01
	db $00

Segment_7543::
	db $9D, $82, $00, $00
	db $A8
	db $44
	db $A3
	db $48
	db $A4
	db $4E
	db $48
	db $A4
	db $44
	db $A3
	db $48
	db $44
	db $A4
	db $40
	db $A3
	db $3A
	db $36
	db $A8
	db $44
	db $A3
	db $48
	db $A4
	db $4E
	db $A3
	db $48
	db $44
	db $A2
	db $58
	db $5C
	db $A3
	db $58
	db $A2
	db $52
	db $58
	db $A3
	db $52
	db $A2
	db $4E
	db $52
	db $A3
	db $4E
	db $A2
	db $48
	db $44
	db $A3
	db $40
	db $A8
	db $44
	db $A3
	db $48
	db $A4
	db $4E
	db $48
	db $A4
	db $44
	db $A3
	db $48
	db $44
	db $A4
	db $40
	db $A3
	db $3A
	db $36
	db $A8
	db $3A
	db $A3
	db $3E
	db $3A
	db $36
	db $30
	db $2C
	db $A5
	db $30
	db $01
	db $00

Segment_7592::
	db $9D, $70, $00, $81
	db $A8
	db $4E
	db $A3
	db $52
	db $A4
	db $58
	db $52
	db $A4
	db $4E
	db $A3
	db $52
	db $4E
	db $A4
	db $48
	db $A3
	db $44
	db $40
	db $A8
	db $4E
	db $A3
	db $52
	db $A4
	db $58
	db $A3
	db $52
	db $4E
	db $A5
	db $52
	db $01
	db $A8
	db $4E
	db $A3
	db $52
	db $A4
	db $58
	db $52
	db $A4
	db $4E
	db $A3
	db $52
	db $4E
	db $A4
	db $48
	db $A3
	db $44
	db $40
	db $A8
	db $44
	db $A3
	db $48
	db $44
	db $40
	db $3A
	db $36
	db $A5
	db $3A
	db $01
	db $00

Segment_75D0::
	db $A3
	db $28
	db $A2
	db $40
	db $36
	db $A3
	db $28
	db $40
	db $A3
	db $28
	db $A2
	db $40
	db $36
	db $A3
	db $28
	db $40
	db $A3
	db $1A
	db $A2
	db $32
	db $28
	db $A3
	db $1A
	db $32
	db $A3
	db $1A
	db $A2
	db $32
	db $28
	db $A3
	db $1A
	db $32
	db $00

Segment_75F1::
	db $A3
	db $1E
	db $A2
	db $36
	db $2C
	db $A3
	db $1E
	db $36
	db $A3
	db $1E
	db $A2
	db $36
	db $2C
	db $A3
	db $1E
	db $36
	db $A3
	db $22
	db $A2
	db $3A
	db $30
	db $A3
	db $22
	db $3A
	db $A3
	db $22
	db $A2
	db $3A
	db $30
	db $A3
	db $22
	db $3A
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
	db $6A
	db $66
	db $A4
	db $60
	db $A3
	db $66
	db $60
	db $A3
	db $5C
	db $A2
	db $60
	db $5C
	db $A3
	db $58
	db $A2
	db $52
	db $4E
	db $A5
	db $66
	db $A8
	db $66
	db $A3
	db $60
	db $A5
	db $66
	db $01
	db $A8
	db $52
	db $A3
	db $58
	db $A4
	db $5C
	db $58
	db $A8
	db $52
	db $A3
	db $4E
	db $A4
	db $48
	db $A3
	db $44
	db $40
	db $A8
	db $44
	db $A3
	db $48
	db $A4
	db $4E
	db $52
	db $A5
	db $58
	db $01
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
	db $52
	db $4E
	db $A4
	db $48
	db $A3
	db $4E
	db $48
	db $A3
	db $44
	db $A2
	db $48
	db $44
	db $A3
	db $40
	db $A2
	db $3A
	db $36
	db $A5
	db $4E
	db $A8
	db $4E
	db $A3
	db $48
	db $A5
	db $4E
	db $01
	db $A8
	db $52
	db $A3
	db $58
	db $A4
	db $5C
	db $58
	db $A8
	db $52
	db $A3
	db $4E
	db $A4
	db $48
	db $A3
	db $44
	db $40
	db $A8
	db $44
	db $A3
	db $48
	db $A4
	db $4E
	db $52
	db $A5
	db $58
	db $01
	db $00

Segment_768E::
	db $A3
	db $1E
	db $A2
	db $36
	db $2C
	db $A3
	db $1E
	db $36
	db $A3
	db $1E
	db $A2
	db $36
	db $2C
	db $A3
	db $1E
	db $36
	db $A3
	db $1A
	db $A2
	db $32
	db $28
	db $A3
	db $1A
	db $32
	db $A3
	db $1A
	db $A2
	db $32
	db $28
	db $A3
	db $1A
	db $32
	db $A3
	db $30
	db $A2
	db $48
	db $26
	db $A3
	db $30
	db $48
	db $A3
	db $30
	db $A2
	db $48
	db $26
	db $A3
	db $30
	db $48
	db $A3
	db $1E
	db $A2
	db $36
	db $2C
	db $A3
	db $1E
	db $36
	db $A3
	db $1E
	db $A2
	db $36
	db $2C
	db $A3
	db $1E
	db $36
	db $A5
	db $22
	db $22
	db $1A
	db $1A
	db $1E
	db $1E
	db $22
	db $22
	db $00

Segment_76D8::
	db $A3
	db $06
	db $A2
	db $06
	db $06
	db $A3
	db $0B
	db $A2
	db $06
	db $06
	db $A3
	db $06
	db $A2
	db $06
	db $06
	db $A3
	db $0B
	db $A2
	db $06
	db $06
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
	db $52
	db $01
	db $50
	db $01
	db $4E
	db $4A
	db $01
	db $01
	db $01
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
	db $70
	db $01
	db $6E
	db $01
	db $6C
	db $6A
	db $01
	db $01
	db $A4
	db $01
	db $40
	db $00

Segment_7746::
	db $A6
	db $06
	db $A1
	db $06
	db $A3
	db $0B
	db $A6
	db $06
	db $A1
	db $06
	db $A3
	db $0B
	db $A2
	db $01
	db $06
	db $01
	db $01
	db $A6
	db $0B
	db $A1
	db $06
	db $A3
	db $06
	db $00

Segment_775E::
	db $A3
	db $01
	db $3A
	db $01
	db $3A
	db $01
	db $3A
	db $01
	db $3A
	db $01
	db $3A
	db $01
	db $3A
	db $01
	db $3A
	db $01
	db $3A
	db $01
	db $4A
	db $01
	db $4A
	db $01
	db $4A
	db $01
	db $4A
	db $A5
	db $01
	db $A3
	db $01
	db $6E
	db $A4
	db $6E
	db $A3
	db $01
	db $3A
	db $01
	db $3A
	db $01
	db $3A
	db $01
	db $3A
	db $01
	db $3A
	db $01
	db $3A
	db $01
	db $3A
	db $01
	db $3A
	db $01
	db $4A
	db $01
	db $4A
	db $01
	db $4A
	db $01
	db $4A
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
	db $52
	db $01
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
	db $52
	db $01
	db $52
	db $01
	db $A3
	db $4E
	db $4A
	db $52
	db $54
	db $58
	db $5C
	db $01
	db $4A
	db $4A
	db $44
	db $40
	db $A6
	db $01
	db $A1
	db $4A
	db $A4
	db $01
	db $A3
	db $3C
	db $40
	db $44
	db $48
	db $A3
	db $01
	db $70
	db $A4
	db $70
	db $A3
	db $52
	db $01
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
	db $52
	db $01
	db $52
	db $01
	db $A3
	db $4E
	db $4A
	db $5C
	db $58
	db $62
	db $A6
	db $52
	db $A1
	db $4E
	db $A3
	db $01
	db $4A
	db $4A
	db $4E
	db $52
	db $A6
	db $01
	db $A1
	db $4A
	db $A4
	db $01
	db $A3
	db $54
	db $52
	db $4A
	db $4E
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
	db $32
	db $58
	db $32
	db $5A
	db $32
	db $5A
	db $32
	db $5C
	db $32
	db $5C
	db $32
	db $5E
	db $44
	db $5E
	db $3C
	db $5C
	db $3C
	db $5C
	db $3A
	db $58
	db $3A
	db $58
	db $4E
	db $52
	db $54
	db $56
	db $A5
	db $01
	db $00

Segment_7832::
	db $A3
	db $01
	db $5C
	db $60
	db $62
	db $A3
	db $60
	db $A6
	db $01
	db $A1
	db $58
	db $A4
	db $01
	db $A3
	db $54
	db $01
	db $A6
	db $58
	db $A1
	db $54
	db $A3
	db $01
	db $A2
	db $52
	db $01
	db $54
	db $01
	db $56
	db $01
	db $58
	db $01
	db $A3
	db $01
	db $5C
	db $60
	db $62
	db $A3
	db $60
	db $A6
	db $01
	db $A1
	db $58
	db $A4
	db $01
	db $A3
	db $68
	db $66
	db $01
	db $62
	db $A5
	db $01
	db $00

Segment_7866::
	db $A3
	db $01
	db $4A
	db $4E
	db $44
	db $4E
	db $A6
	db $40
	db $A1
	db $48
	db $A3
	db $01
	db $40
	db $44
	db $3C
	db $A6
	db $48
	db $A1
	db $44
	db $A3
	db $36
	db $A5
	db $01
	db $A3
	db $01
	db $4A
	db $4E
	db $44
	db $4E
	db $A6
	db $40
	db $A1
	db $48
	db $A3
	db $01
	db $40
	db $32
	db $32
	db $01
	db $32
	db $01
	db $01
	db $01
	db $01
	db $00

Segment_7893::
	db $A3
	db $3C
	db $4A
	db $3C
	db $4A
	db $3A
	db $4A
	db $3A
	db $4A
	db $36
	db $5C
	db $36
	db $5C
	db $A2
	db $4A
	db $01
	db $4E
	db $01
	db $50
	db $01
	db $52
	db $01
	db $A3
	db $3C
	db $4A
	db $3C
	db $4A
	db $3A
	db $4A
	db $3A
	db $4A
	db $42
	db $50
	db $42
	db $50
	db $A1
	db $58
	db $01
	db $58
	db $01
	db $A2
	db $54
	db $01
	db $52
	db $01
	db $4E
	db $01
	db $00

Segment_78C3::
	db $A3
	db $06
	db $A6
	db $06
	db $A1
	db $06
	db $A3
	db $0B
	db $A6
	db $06
	db $A1
	db $06
	db $A3
	db $06
	db $A6
	db $06
	db $A1
	db $06
	db $A3
	db $0B
	db $A6
	db $06
	db $A1
	db $06
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
	db $01
	db $1E
	db $20
	db $A4
	db $22
	db $24
	db $A3
	db $26
	db $28
	db $2A
	db $2C
	db $00

Segment_7979::
	db $9D, $A0, $00, $00
	db $A5
	db $01
	db $10
	db $12
	db $A4
	db $14
	db $16
	db $A3
	db $18
	db $1A
	db $1C
	db $1E
	db $00

Segment_798A::
	db $9D, $3B, $6F, $20
	db $A5
	db $01
	db $28
	db $2A
	db $A4
	db $2C
	db $2E
	db $A3
	db $30
	db $32
	db $34
	db $36
	db $00

Segment_799B::
	db $A1
	db $06
	db $06
	db $06
	db $06
	db $0B
	db $06
	db $06
	db $06
	db $06
	db $06
	db $06
	db $06
	db $0B
	db $06
	db $06
	db $06
	db $00

Segment_79AD::
	db $9D, $60, $00, $C1
	db $A4
	db $1E
	db $2A
	db $28
	db $34
	db $A5
	db $32
	db $01
	db $A4
	db $1E
	db $2A
	db $28
	db $34
	db $A5
	db $36
	db $01
	db $00

Segment_79C2::
	db $9D, $83, $00, $00
	db $A2
	db $10
	db $0E
	db $0C
	db $0A
	db $08
	db $06
	db $04
	db $02
	db $00

Segment_79D0::
	db $A1
	db $28
	db $40
	db $26
	db $3E
	db $24
	db $3C
	db $22
	db $3A
	db $20
	db $38
	db $1E
	db $36
	db $1C
	db $34
	db $1A
	db $32
	db $00

Channel1_79E2::
	dw Segment_79EE, $FFFF, $79E2

Channel2_79E8::
	dw Segment_7A04, $FFFF, $79E8

Segment_79EE::
	db $9D, $84, $00, $80
	db $A2
	db $40
	db $42
	db $40
	db $42
	db $40
	db $42
	db $40
	db $42
	db $40
	db $46
	db $4C
	db $52
	db $58
	db $52
	db $4C
	db $46
	db $00

Segment_7A04::
	db $9D, $74, $00, $80
	db $A2
	db $10
	db $12
	db $10
	db $12
	db $10
	db $12
	db $10
	db $12
	db $22
	db $28
	db $2E
	db $34
	db $3A
	db $34
	db $2E
	db $28
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
	db $3C
	db $4A
	db $54
	db $4A
	db $40
	db $4A
	db $3C
	db $3A
	db $2A
	db $9D, $30, $00, $81
	db $A1
	db $3A
	db $3C
	db $3A
	db $36
	db $A4
	db $3A
	db $00

Segment_7A3C::
	db $9D, $80, $00, $81
	db $A3
	db $44
	db $4A
	db $5C
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
	db $54
	db $52
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
	db $58
	db $60
	db $66
	db $60
	db $56
	db $60
	db $66
	db $60
	db $54
	db $60
	db $66
	db $60
	db $52
	db $58
	db $62
	db $58
	db $50
	db $58
	db $62
	db $58
	db $4E
	db $58
	db $60
	db $58
	db $00

Segment_7A8C::
	db $4C
	db $52
	db $58
	db $5C
	db $58
	db $4A
	db $56
	db $4E
	db $00

Segment_7A95::
	db $52
	db $58
	db $5C
	db $56
	db $A4
	db $60
	db $40
	db $00

Segment_7A9D::
	db $9D, $66, $00, $81
	db $A4
	db $78
	db $A3
	db $74
	db $70
	db $A8
	db $78
	db $A2
	db $70
	db $74
	db $A3
	db $78
	db $78
	db $74
	db $70
	db $78
	db $7A
	db $7E
	db $82
	db $01
	db $70
	db $70
	db $68
	db $A4
	db $66
	db $78
	db $00

Segment_7ABC::
	db $A3
	db $6A
	db $70
	db $74
	db $78
	db $A4
	db $74
	db $66
	db $00

Segment_7AC5::
	db $A3
	db $7A
	db $6A
	db $6E
	db $66
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
	db $40
	db $01
	db $40
	db $01
	db $40
	db $01
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
	db $78
	db $78
	db $78
	db $A3
	db $7A
	db $A2
	db $7E
	db $A1
	db $82
	db $70
	db $82
	db $70
	db $82
	db $70
	db $82
	db $70
	db $82
	db $70
	db $82
	db $70
	db $82
	db $70
	db $82
	db $70
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
	db $01
	db $4A
	db $01
	db $4A
	db $01
	db $4A
	db $01
	db $4A
	db $01
	db $4A
	db $01
	db $4A
	db $01
	db $4A
	db $01
	db $4A
	db $01
	db $40
	db $01
	db $40
	db $01
	db $40
	db $01
	db $40
	db $00

Segment_7B87::
	db $A5
	db $01
	db $00

Segment_7B8A::
	db $01
	db $4A
	db $01
	db $4A
	db $4A
	db $01
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
	db $46
	db $4C
	db $4A
	db $46
	db $A3
	db $50
	db $50
	db $A2
	db $50
	db $54
	db $4A
	db $4C
	db $A3
	db $46
	db $46
	db $A2
	db $46
	db $4C
	db $4A
	db $46
	db $00

Segment_7BB0::
	db $42
	db $5A
	db $58
	db $54
	db $50
	db $4C
	db $4A
	db $46
	db $00

Segment_7BB9::
	db $42
	db $50
	db $46
	db $4A
	db $42
	db $01
	db $00

Segment_7BC0::
	db $9D, $1B, $6F, $20
	db $A3
	db $01
	db $A2
	db $42
	db $50
	db $38
	db $50
	db $42
	db $50
	db $38
	db $50
	db $42
	db $50
	db $38
	db $50
	db $42
	db $50
	db $38
	db $50
	db $38
	db $5E
	db $46
	db $5E
	db $38
	db $5E
	db $46
	db $5E
	db $42
	db $5A
	db $58
	db $54
	db $50
	db $4C
	db $4A
	db $46
	db $42
	db $50
	db $38
	db $50
	db $42
	db $50
	db $38
	db $50
	db $42
	db $50
	db $38
	db $50
	db $42
	db $50
	db $38
	db $50
	db $38
	db $5E
	db $46
	db $5E
	db $38
	db $5E
	db $46
	db $5E
	db $42
	db $50
	db $38
	db $50
	db $42
	db $01
	db $00

Segment_7C06::
	db $A3
	db $01
	db $A2
	db $06
	db $0B
	db $06
	db $0B
	db $06
	db $0B
	db $0B
	db $0B
	db $06
	db $0B
	db $06
	db $0B
	db $06
	db $A1
	db $0B
	db $0B
	db $A2
	db $06
	db $0B
	db $06
	db $0B
	db $06
	db $0B
	db $06
	db $0B
	db $0B
	db $0B
	db $0B
	db $06
	db $0B
	db $06
	db $0B
	db $01
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
	db $50
	db $4E
	db $4C
	db $4A
	db $48
	db $46
	db $00

Segment_7C4F::
	db $9D, $34, $00, $80
	db $A2
	db $3A
	db $38
	db $36
	db $34
	db $32
	db $30
	db $00

Segment_7C5B::
	db $9D, $1B, $6F, $20
	db $A8
	db $44
	db $A7
	db $44
	db $4A
	db $A8
	db $50
	db $50
	db $A8
	db $44
	db $A7
	db $44
	db $4A
	db $A8
	db $50
	db $50
	db $00

Segment_7C70::
	db $A2
	db $06
	db $06
	db $06
	db $A7
	db $0B
	db $A2
	db $06
	db $06
	db $06
	db $A7
	db $0B
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
	db $32
	db $36
	db $3A
	db $3C
	db $40
	db $44
	db $48
	db $4A
	db $4E
	db $52
	db $54
	db $58
	db $5C
	db $00

Segment_7C98::
	db $9D, $41, $00, $80
	db $AA
	db $01
	db $A7
	db $32
	db $36
	db $3A
	db $3C
	db $40
	db $44
	db $48
	db $4A
	db $4E
	db $52
	db $54
	db $58
	db $5C
	db $00

Segment_7CAD::
	db $9D, $3B, $6F, $20
	db $A2
	db $4A
	db $01
	db $52
	db $4E
	db $01
	db $54
	db $52
	db $01
	db $58
	db $54
	db $01
	db $5C
	db $58
	db $01
	db $60
	db $5C
	db $01
	db $62
	db $60
	db $01
	db $66
	db $62
	db $01
	db $6A
	db $66
	db $01
	db $6C
	db $6A
	db $01
	db $70
	db $6C
	db $01
	db $74
	db $70
	db $01
	db $78
	db $74
	db $01
	db $7A
	db $78
	db $01
	db $7E

Channel1_7CDC::
	dw Segment_7CEE, $FFFF, $7CDC

Channel2_7CE2::
	dw Segment_7D14, $FFFF, $7CE2

Channel4_7CE8::
	dw Segment_7D5A, $FFFF, $7CE8

Segment_7CEE::
	db $9D, $91, $00, $80
	db $A2
	db $40
	db $4E
	db $40
	db $4E
	db $40
	db $4E
	db $40
	db $4E
	db $44
	db $52
	db $44
	db $4E
	db $44
	db $52
	db $44
	db $4E
	db $4A
	db $58
	db $4A
	db $58
	db $4A
	db $58
	db $4A
	db $58
	db $4E
	db $4E
	db $4A
	db $4A
	db $48
	db $48
	db $44
	db $44
	db $00

Segment_7D14::
	db $9D, $91, $00, $80
	db $A1
	db $60
	db $66
	db $70
	db $60
	db $66
	db $70
	db $60
	db $66
	db $70
	db $60
	db $66
	db $70
	db $60
	db $66
	db $70
	db $01
	db $5C
	db $64
	db $70
	db $5C
	db $64
	db $70
	db $5C
	db $64
	db $70
	db $5C
	db $64
	db $70
	db $5C
	db $64
	db $70
	db $01
	db $62
	db $6A
	db $70
	db $62
	db $6A
	db $70
	db $62
	db $6A
	db $70
	db $62
	db $6A
	db $70
	db $62
	db $6A
	db $70
	db $01
	db $6E
	db $5C
	db $6E
	db $5C
	db $6A
	db $70
	db $6A
	db $58
	db $66
	db $56
	db $66
	db $56
	db $62
	db $6A
	db $62
	db $52
	db $00

Segment_7D5A::
	db $A2
	db $06
	db $A1
	db $06
	db $06
	db $A2
	db $06
	db $A1
	db $06
	db $06
	db $A2
	db $06
	db $A1
	db $06
	db $06
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
	db $4C
	db $3A
	db $44
	db $4C
	db $50
	db $3E
	db $48
	db $50
	db $52
	db $40
	db $4A
	db $52
	db $56
	db $44
	db $4E
	db $56
	db $5A
	db $48
	db $52
	db $5A
	db $5C
	db $4A
	db $52
	db $5C
	db $5A
	db $48
	db $52
	db $5A
	db $5C
	db $4A
	db $52
	db $5C
	db $00

Segment_7DE7::
	db $A2
	db $5A
	db $01
	db $01
	db $52
	db $01
	db $01
	db $48
	db $01
	db $01
	db $56
	db $01
	db $5C
	db $01
	db $5A
	db $56
	db $A5
	db $52
	db $01
	db $A2
	db $01
	db $A2
	db $5A
	db $01
	db $01
	db $52
	db $01
	db $01
	db $48
	db $01
	db $A4
	db $52
	db $A2
	db $01
	db $50
	db $52
	db $A4
	db $56
	db $A2
	db $01
	db $A4
	db $4C
	db $50
	db $01
	db $00

Segment_7E14::
	db $A8
	db $52
	db $A2
	db $50
	db $52
	db $A4
	db $56
	db $48
	db $A8
	db $5A
	db $A2
	db $56
	db $5A
	db $A3
	db $5C
	db $4C
	db $52
	db $50
	db $A8
	db $52
	db $A2
	db $50
	db $52
	db $A4
	db $56
	db $48
	db $A8
	db $5A
	db $A2
	db $56
	db $5A
	db $A3
	db $60
	db $4A
	db $52
	db $58
	db $A4
	db $5C
	db $62
	db $A5
	db $5A
	db $56
	db $00

Segment_7E3F::
	db $9D, $3B, $6F, $A0
	db $00

Segment_7E44::
	db $A2
	db $44
	db $44
	db $5C
	db $5C
	db $44
	db $44
	db $5C
	db $5C
	db $44
	db $44
	db $5C
	db $5C
	db $44
	db $44
	db $5C
	db $5C
	db $00

Segment_7E56::
	db $3A
	db $3A
	db $52
	db $52
	db $3A
	db $3A
	db $52
	db $52
	db $3A
	db $3A
	db $52
	db $52
	db $3A
	db $3A
	db $52
	db $52
	db $00

Segment_7E67::
	db $A3
	db $52
	db $52
	db $52
	db $52
	db $50
	db $50
	db $50
	db $50
	db $4E
	db $4E
	db $4E
	db $4E
	db $4C
	db $4C
	db $4C
	db $4C
	db $44
	db $44
	db $44
	db $44
	db $42
	db $42
	db $42
	db $42
	db $3E
	db $3E
	db $3E
	db $3E
	db $48
	db $48
	db $48
	db $48
	db $00

Segment_7E89::
	db $A2
	db $2C
	db $2C
	db $44
	db $44
	db $2C
	db $2C
	db $44
	db $44
	db $2C
	db $2C
	db $44
	db $44
	db $2C
	db $2C
	db $44
	db $44
	db $2A
	db $2A
	db $42
	db $42
	db $2A
	db $2A
	db $42
	db $42
	db $00

Segment_7EA3::
	db $26
	db $26
	db $3E
	db $3E
	db $30
	db $30
	db $48
	db $48
	db $00

Segment_7EAC::
	db $28
	db $28
	db $40
	db $40
	db $28
	db $28
	db $40
	db $40
	db $28
	db $28
	db $40
	db $40
	db $28
	db $28
	db $40
	db $40
	db $30
	db $30
	db $3A
	db $42
	db $30
	db $30
	db $3A
	db $42
	db $30
	db $30
	db $38
	db $3E
	db $30
	db $30
	db $38
	db $3E
	db $00

Segment_7ECD::
	db $A1
	db $06
	db $06
	db $A2
	db $0B
	db $A1
	db $06
	db $06
	db $A2
	db $0B
	db $A1
	db $06
	db $06
	db $A2
	db $0B
	db $A1
	db $06
	db $06
	db $A2
	db $0B
	db $A1
	db $06
	db $06
	db $A2
	db $0B
	db $A1
	db $06
	db $06
	db $A2
	db $0B
	db $A1
	db $06
	db $06
	db $A2
	db $0B
	db $A1
	db $06
	db $06
	db $A2
	db $0B
	db $00

Segment_7EF6::
	db $A2
	db $06
	db $06
	db $10
	db $06
	db $06
	db $06
	db $10
	db $06
	db $06
	db $06
	db $10
	db $06
	db $06
	db $06
	db $10
	db $06
	db $00

