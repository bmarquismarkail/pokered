SaffronGymSabrinaText:
	.DB $08
	LD A, ($D7B3)
	BIT 1, A
	JR Z, SaffronGymSabrinaText.beforeBeat
	BIT 0, A
	JR NZ, SaffronGymSabrinaText.afterBeat
	CALL Z, SaffronGymSabrinaReceiveTM46Script
	CALL $30B6
	JR SaffronGymSabrinaText.done
SaffronGymSabrinaText.afterBeat:
	LD HL, SaffronGymSabrinaText.PostBattleAdviceText
	CALL PrintText
	JR SaffronGymSabrinaText.done
SaffronGymSabrinaText.beforeBeat:
	LD HL, SaffronGymSabrinaText.Text
	CALL PrintText
	LD HL, $D72D
	SET 6, (HL)
	SET 7, (HL)
	LD HL, SaffronGymSabrinaText.ReceivedMarshBadgeText
	LD DE, SaffronGymSabrinaText.ReceivedMarshBadgeText
	CALL $3354
	LDH A, ($8C)
	LD ($CF13), A
	CALL $336A
	CALL $32D7
	LD A, 6
	LD ($D05C), A
	LD A, 3
	LD ($D65C), A
SaffronGymSabrinaText.done:
	JP $24D7
SaffronGymSabrinaText.Text:
	.DB $17
	.DW $5BB4
	.DB $28, $50
SaffronGymSabrinaText.ReceivedMarshBadgeText:
	.DB $17
	.DW $5C73
	.DB $28, $11, $06, $50
SaffronGymSabrinaText.PostBattleAdviceText:
	.DB $17
	.DW $5CDC
	.DB $28, $50
SaffronGymSabrinaTextEnd:
.ASSERT SaffronGymSabrinaTextEnd - SaffronGymSabrinaText == 91
