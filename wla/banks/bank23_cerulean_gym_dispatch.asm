.STRINGMAPTABLE pokemon "wla/pokemon.tbl"

CeruleanGym_Script:
	LD HL, $D126
	BIT 6, (HL)
	RES 6, (HL)
	CALL NZ, CeruleanGym_Script.LoadNames
	CALL $3C3C ; EnableAutoTextBoxDrawing
	LD HL, $4758 ; CeruleanGymTrainerHeaders
	LD DE, $46F8 ; CeruleanGym_ScriptPointers
	LD A, ($D5FD) ; wCeruleanGymCurScript
	CALL $3160 ; ExecuteCurMapScriptInTable
	LD ($D5FD), A
	RET
CeruleanGym_Script.LoadNames:
	LD HL, CeruleanGym_Script.CityName
	LD DE, CeruleanGym_Script.LeaderName
	JP $317F ; LoadGymLeaderAndCityName
CeruleanGym_Script.CityName:
	.STRINGMAP pokemon, "CERULEAN CITY@"
CeruleanGym_Script.LeaderName:
	.STRINGMAP pokemon, "MISTY@"
CeruleanGymResetScripts:
	XOR A
	LD ($CD6B), A
	LD ($D5FD), A
	LD ($DA39), A
	RET
CeruleanGymDispatchEnd:
.ASSERT CeruleanGymDispatchEnd - CeruleanGym_Script == 69
