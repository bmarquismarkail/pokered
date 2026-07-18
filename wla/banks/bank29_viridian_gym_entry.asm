.STRINGMAPTABLE pokemon "wla/pokemon.tbl"

ViridianGym_h:
	.DB $07,$09,$0A
	.DW $4C47 ; ViridianGym_Blocks
	.DW ViridianGym_TextPointers
	.DW ViridianGym_Script
	.DB $00
	.DW $4BDE ; ViridianGym_Object
ViridianGymHeaderEnd:
.ASSERT ViridianGymHeaderEnd - ViridianGym_h == 12
ViridianGym_Script:
	LD HL, ViridianGym_Script.CityName
	LD DE, ViridianGym_Script.LeaderName
	CALL $317F ; LoadGymLeaderAndCityName
	CALL $3C3C ; EnableAutoTextBoxDrawing
	LD HL, ViridianGymTrainerHeaders
	LD DE, ViridianGym_ScriptPointers
	LD A, ($D5FB) ; wViridianGymCurScript
	CALL $3160
	LD ($D5FB), A
	RET
ViridianGym_Script.CityName:
	.STRINGMAP pokemon, "VIRIDIAN CITY@"
ViridianGym_Script.LeaderName:
	.STRINGMAP pokemon, "GIOVANNI@"
ViridianGymResetScripts:
	XOR A
	LD ($CD6B), A ; wJoyIgnore
	LD ($D5FB), A
	LD ($DA39), A ; wCurMapScript
	RET
ViridianGymEntryEnd:
.ASSERT ViridianGymEntryEnd - ViridianGym_Script == 62
