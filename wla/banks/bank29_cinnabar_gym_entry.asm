.STRINGMAPTABLE pokemon "wla/pokemon.tbl"

CinnabarGym_Script:
	CALL CinnabarGymSetMapAndTiles
	CALL $3C3C ; EnableAutoTextBoxDrawing
	LD HL, CinnabarGym_ScriptPointers
	LD A, ($D65E) ; wCinnabarGymCurScript
	JP $3D97 ; CallFunctionInTable
CinnabarGymScriptEnd:
.ASSERT CinnabarGymScriptEnd - CinnabarGym_Script == 15

CinnabarGymSetMapAndTiles:
	LD HL, $D126 ; wCurrentMapScriptFlags
	BIT 6, (HL) ; BIT_CUR_MAP_LOADED_2
	RES 6, (HL)
	PUSH HL
	CALL NZ, CinnabarGymSetMapAndTiles.LoadNames
	POP HL
	BIT 5, (HL) ; BIT_CUR_MAP_LOADED_1
	RES 5, (HL)
	CALL NZ, $3EAD ; UpdateCinnabarGymGateTileBlocks
	LD HL, $D79B
	RES 7, (HL) ; EVENT_2A7
	RET
CinnabarGymSetMapAndTilesEnd:
.ASSERT CinnabarGymSetMapAndTilesEnd - CinnabarGymSetMapAndTiles == 25

CinnabarGymSetMapAndTiles.LoadNames:
	LD HL, CinnabarGymSetMapAndTiles.CityName
	LD DE, CinnabarGymSetMapAndTiles.LeaderName
	JP $317F ; LoadGymLeaderAndCityName
CinnabarGymSetMapAndTiles.CityName:
	.STRINGMAP pokemon, "CINNABAR ISLAND@"
CinnabarGymSetMapAndTiles.LeaderName:
	.STRINGMAP pokemon, "BLAINE@"
CinnabarGymNamesEnd:
.ASSERT CinnabarGymNamesEnd - CinnabarGymSetMapAndTiles.LoadNames == 32
