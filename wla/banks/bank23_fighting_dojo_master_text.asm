FightingDojoKarateMasterText:
	.DB $08
	LD A, ($D7B1)
	BIT 0, A
	JP NZ, FightingDojoKarateMasterText.defeated_dojo
	BIT 1, A
	JP NZ, FightingDojoKarateMasterText.defeated_master
	LD HL, FightingDojoKarateMasterText.Text
	CALL PrintText
	LD HL, $D72D
	SET 6, (HL)
	SET 7, (HL)
	LD HL, FightingDojoKarateMasterText.DefeatedText
	LD DE, FightingDojoKarateMasterText.DefeatedText
	CALL $3354
	LDH A, ($8C)
	LD ($CF13), A
	CALL $336A
	CALL $32D7
	LD A, 3
	LD ($D642), A
	LD ($DA39), A
	JR FightingDojoKarateMasterText.end
FightingDojoKarateMasterText.defeated_dojo:
	LD HL, FightingDojoKarateMasterText.StayAndTrainWithUsText
	CALL PrintText
	JR FightingDojoKarateMasterText.end
FightingDojoKarateMasterText.defeated_master:
	LD HL, FightingDojoKarateMasterText.IWillGiveYouAPokemonText
	CALL PrintText
FightingDojoKarateMasterText.end:
	JP $24D7
FightingDojoKarateMasterText.Text:
	.DB $17
	.DW $5852
	.DB $28, $50
FightingDojoKarateMasterText.DefeatedText:
	.DB $17
	.DW $58BA
	.DB $28, $50
FightingDojoKarateMasterText.IWillGiveYouAPokemonText:
	.DB $17
	.DW $58CF
	.DB $28, $50
FightingDojoKarateMasterText.StayAndTrainWithUsText:
	.DB $17
	.DW $5972
	.DB $28, $50
FightingDojoMasterTextEnd:
.ASSERT FightingDojoMasterTextEnd - FightingDojoKarateMasterText == 94
