VermilionGymLTSurgeText:
	.DB $08
	LD A, ($D773)
	BIT 7, A
	JR Z, VermilionGymLTSurgeText.before_beat
	BIT 6, A
	JR NZ, VermilionGymLTSurgeText.got_tm24_already
	CALL Z, VermilionGymLTSurgeReceiveTM24Script
	CALL $30B6
	JR VermilionGymLTSurgeText.text_script_end
VermilionGymLTSurgeText.got_tm24_already:
	LD HL, VermilionGymLTSurgeText.PostBattleAdviceText
	CALL PrintText
	JR VermilionGymLTSurgeText.text_script_end
VermilionGymLTSurgeText.before_beat:
	LD HL, VermilionGymLTSurgeText.PreBattleText
	CALL PrintText
	LD HL, $D72D
	SET 6, (HL)
	SET 7, (HL)
	LD HL, $4B8B
	LD DE, $4B8B
	CALL $3354
	LDH A, ($8C)
	LD ($CF13), A
	CALL $336A
	CALL $32D7
	LD A, $03
	LD ($D05C), A
	XOR A
	LDH ($B4), A
	LD A, $03
	LD ($D5FE), A
	LD ($DA39), A
VermilionGymLTSurgeText.text_script_end:
	JP $24D7
VermilionGymLTSurgeText.PreBattleText:
	.DB $17
	.DW $6AA5
	.DB $26, $50
VermilionGymLTSurgeText.PostBattleAdviceText:
	.DB $17
	.DW $4000
	.DB $27, $50
VermilionGymLTSurgeTextEnd:
.ASSERT VermilionGymLTSurgeTextEnd - VermilionGymLTSurgeText == 90
