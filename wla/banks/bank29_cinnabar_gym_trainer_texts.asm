CinnabarGymTrainerTexts:
CinnabarGymSuperNerd1:
	.DB $08
	CALL CinnabarGymSetTrainerHeader
	LD A, ($D79A)
	BIT 2, A ; EVENT_BEAT_CINNABAR_GYM_TRAINER_0
	JR NZ, CinnabarGymSuperNerd1.defeated
	LD HL, CinnabarGymSuperNerd1.BattleText
	CALL $3C49
	LD HL, CinnabarGymSuperNerd1.EndBattleText
	LD DE, CinnabarGymSuperNerd1.EndBattleText
	CALL $3354
	JP CinnabarGymStartBattleScript
CinnabarGymSuperNerd1.defeated:
	LD HL, CinnabarGymSuperNerd1.AfterBattleText
	CALL $3C49
	JP $24D7
CinnabarGymSuperNerd1.BattleText:
	.DB $17
	.DW $4A36
	.DB $28,$50
CinnabarGymSuperNerd1.EndBattleText:
	.DB $17
	.DW $4A65
	.DB $28,$50
CinnabarGymSuperNerd1.AfterBattleText:
	.DB $17
	.DW $4A7A
	.DB $28,$50

CinnabarGymSuperNerd2:
	.DB $08
	CALL CinnabarGymSetTrainerHeader
	LD A, ($D79A)
	BIT 3, A
	JR NZ, CinnabarGymSuperNerd2.defeated
	LD HL, CinnabarGymSuperNerd2.BattleText
	CALL $3C49
	LD HL, CinnabarGymSuperNerd2.EndBattleText
	LD DE, CinnabarGymSuperNerd2.EndBattleText
	CALL $3354
	JP CinnabarGymStartBattleScript
CinnabarGymSuperNerd2.defeated:
	LD HL, CinnabarGymSuperNerd2.AfterBattleText
	CALL $3C49
	JP $24D7
CinnabarGymSuperNerd2.BattleText:
	.DB $17
	.DW $4AC0
	.DB $28,$50
CinnabarGymSuperNerd2.EndBattleText:
	.DB $17
	.DW $4AF4
	.DB $28,$50
CinnabarGymSuperNerd2.AfterBattleText:
	.DB $17
	.DW $4B02
	.DB $28,$50

CinnabarGymSuperNerd3:
	.DB $08
	CALL CinnabarGymSetTrainerHeader
	LD A, ($D79A)
	BIT 4, A
	JR NZ, CinnabarGymSuperNerd3.defeated
	LD HL, CinnabarGymSuperNerd3.BattleText
	CALL $3C49
	LD HL, CinnabarGymSuperNerd3.EndBattleText
	LD DE, CinnabarGymSuperNerd3.EndBattleText
	CALL $3354
	JP CinnabarGymStartBattleScript
CinnabarGymSuperNerd3.defeated:
	LD HL, CinnabarGymSuperNerd3.AfterBattleText
	CALL $3C49
	JP $24D7
CinnabarGymSuperNerd3.BattleText:
	.DB $17
	.DW $4B2C
	.DB $28,$50
CinnabarGymSuperNerd3.EndBattleText:
	.DB $17
	.DW $4B58
	.DB $28,$50
CinnabarGymSuperNerd3.AfterBattleText:
	.DB $17
	.DW $4B6B
	.DB $28,$50

CinnabarGymSuperNerd4:
	.DB $08
	CALL CinnabarGymSetTrainerHeader
	LD A, ($D79A)
	BIT 5, A
	JR NZ, CinnabarGymSuperNerd4.defeated
	LD HL, CinnabarGymSuperNerd4.BattleText
	CALL $3C49
	LD HL, CinnabarGymSuperNerd4.EndBattleText
	LD DE, CinnabarGymSuperNerd4.EndBattleText
	CALL $3354
	JP CinnabarGymStartBattleScript
CinnabarGymSuperNerd4.defeated:
	LD HL, CinnabarGymSuperNerd4.AfterBattleText
	CALL $3C49
	JP $24D7
CinnabarGymSuperNerd4.BattleText:
	.DB $17
	.DW $4B95
	.DB $28,$50
CinnabarGymSuperNerd4.EndBattleText:
	.DB $17
	.DW $4BB3
	.DB $28,$50
CinnabarGymSuperNerd4.AfterBattleText:
	.DB $17
	.DW $4BC7
	.DB $28,$50

CinnabarGymSuperNerd5:
	.DB $08
	CALL CinnabarGymSetTrainerHeader
	LD A, ($D79A)
	BIT 6, A
	JR NZ, CinnabarGymSuperNerd5.defeated
	LD HL, CinnabarGymSuperNerd5.BattleText
	CALL $3C49
	LD HL, CinnabarGymSuperNerd5.EndBattleText
	LD DE, CinnabarGymSuperNerd5.EndBattleText
	CALL $3354
	JP CinnabarGymStartBattleScript
CinnabarGymSuperNerd5.defeated:
	LD HL, CinnabarGymSuperNerd5.AfterBattleText
	CALL $3C49
	JP $24D7
CinnabarGymSuperNerd5.BattleText:
	.DB $17
	.DW $4BF4
	.DB $28,$50
CinnabarGymSuperNerd5.EndBattleText:
	.DB $17
	.DW $4C19
	.DB $28,$50
CinnabarGymSuperNerd5.AfterBattleText:
	.DB $17
	.DW $4C1E
	.DB $28,$50

CinnabarGymSuperNerd6:
	.DB $08
	CALL CinnabarGymSetTrainerHeader
	LD A, ($D79A)
	BIT 7, A
	JR NZ, CinnabarGymSuperNerd6.defeated
	LD HL, CinnabarGymSuperNerd6.BattleText
	CALL $3C49
	LD HL, CinnabarGymSuperNerd6.EndBattleText
	LD DE, CinnabarGymSuperNerd6.EndBattleText
	CALL $3354
	JP CinnabarGymStartBattleScript
CinnabarGymSuperNerd6.defeated:
	LD HL, CinnabarGymSuperNerd6.AfterBattleText
	CALL $3C49
	JP $24D7
CinnabarGymSuperNerd6.BattleText:
	.DB $17
	.DW $4C90
	.DB $28,$50
CinnabarGymSuperNerd6.EndBattleText:
	.DB $17
	.DW $4CC1
	.DB $28,$50
CinnabarGymSuperNerd6.AfterBattleText:
	.DB $17
	.DW $4CD2
	.DB $28,$50

CinnabarGymSuperNerd7:
	.DB $08
	CALL CinnabarGymSetTrainerHeader
	LD A, ($D79B)
	BIT 0, A
	JR NZ, CinnabarGymSuperNerd7.defeated
	LD HL, CinnabarGymSuperNerd7.BattleText
	CALL $3C49
	LD HL, CinnabarGymSuperNerd7.EndBattleText
	LD DE, CinnabarGymSuperNerd7.EndBattleText
	CALL $3354
	JP CinnabarGymStartBattleScript
CinnabarGymSuperNerd7.defeated:
	LD HL, CinnabarGymSuperNerd7.AfterBattleText
	CALL $3C49
	JP $24D7
CinnabarGymSuperNerd7.BattleText:
	.DB $17
	.DW $4D00
	.DB $28,$50
CinnabarGymSuperNerd7.EndBattleText:
	.DB $17
	.DW $4D1B
	.DB $28,$50
CinnabarGymSuperNerd7.AfterBattleText:
	.DB $17
	.DW $4D2D
	.DB $28,$50
CinnabarGymTrainerTextsEnd:
.ASSERT CinnabarGymTrainerTextsEnd - CinnabarGymTrainerTexts == 371
