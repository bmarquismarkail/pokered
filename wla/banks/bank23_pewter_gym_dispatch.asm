; Native WLA-DX form of the Pewter Gym map-script dispatcher and reset routine.
.STRINGMAPTABLE pokemon "wla/pokemon.tbl"

PewterGym_Script:
	LD HL, $D126 ; wCurrentMapScriptFlags
	BIT 6, (HL)  ; BIT_CUR_MAP_LOADED_2
	RES 6, (HL)
	CALL NZ, PewterGym_Script.LoadNames
	CALL $3C3C ; EnableAutoTextBoxDrawing
	LD HL, $4441 ; PewterGymTrainerHeaders
	LD DE, $43CA ; PewterGym_ScriptPointers
	LD A, ($D5FC) ; wPewterGymCurScript
	CALL $3160 ; ExecuteCurMapScriptInTable
	LD ($D5FC), A
	RET

PewterGym_Script.LoadNames:
	LD HL, PewterGym_Script.CityName
	LD DE, PewterGym_Script.LeaderName
	JP $317F ; LoadGymLeaderAndCityName

PewterGym_Script.CityName:
	.STRINGMAP pokemon, "PEWTER CITY@"
PewterGym_Script.LeaderName:
	.STRINGMAP pokemon, "BROCK@"

PewterGymResetScripts:
	XOR A
	LD ($CD6B), A ; wJoyIgnore
	LD ($D5FC), A ; wPewterGymCurScript
	LD ($DA39), A ; wCurMapScript
	RET
PewterGymDispatchEnd:
.ASSERT PewterGymDispatchEnd - PewterGym_Script == 67
