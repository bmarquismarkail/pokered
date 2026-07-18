.STRINGMAPTABLE pokemon "wla/pokemon.tbl"

FuchsiaGym_Script:
	CALL FuchsiaGym_Script.LoadNames
	CALL $3C3C ; EnableAutoTextBoxDrawing
	LD HL, FuchsiaGymTrainerHeaders
	LD DE, FuchsiaGym_ScriptPointers
	LD A, ($D65B) ; wFuchsiaGymCurScript
	CALL $3160 ; ExecuteCurMapScriptInTable
	LD ($D65B), A
	RET
FuchsiaGym_Script.LoadNames:
	LD HL, $D126 ; wCurrentMapScriptFlags
	BIT 6, (HL) ; BIT_CUR_MAP_LOADED_2
	RES 6, (HL)
	RET Z
	LD HL, FuchsiaGym_Script.CityName
	LD DE, FuchsiaGym_Script.LeaderName
	CALL $317F ; LoadGymLeaderAndCityName
	RET
FuchsiaGym_Script.CityName:
	.STRINGMAP pokemon, "FUCHSIA CITY@"
FuchsiaGym_Script.LeaderName:
	.STRINGMAP pokemon, "KOGA@"
FuchsiaGymEntryEnd:
.ASSERT FuchsiaGymEntryEnd - FuchsiaGym_Script == 58
