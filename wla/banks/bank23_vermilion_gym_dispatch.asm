.STRINGMAPTABLE pokemon "wla/pokemon.tbl"

VermilionGym_Script:
	LD HL, $D126
	BIT 5, (HL)
	RES 5, (HL)
	PUSH HL
	CALL NZ, VermilionGym_Script.LoadNames
	POP HL
	BIT 6, (HL)
	RES 6, (HL)
	CALL NZ, VermilionGymSetDoorTile
	CALL $3C3C
	LD HL, $4AF8
	LD DE, $4A95
	LD A, ($D5FE)
	CALL $3160
	LD ($D5FE), A
	RET
VermilionGym_Script.LoadNames:
	LD HL, VermilionGym_Script.CityName
	LD DE, VermilionGym_Script.LeaderName
	JP $317F
VermilionGym_Script.CityName:
	.STRINGMAP pokemon, "VERMILION CITY@"
VermilionGym_Script.LeaderName:
	.STRINGMAP pokemon, "LT.SURGE@"

VermilionGymSetDoorTile:
	LD A, ($D773)
	BIT 0, A ; EVENT_2ND_LOCK_OPENED
	JR NZ, VermilionGymSetDoorTile.doorsOpen
	LD A, $24
	JR VermilionGymSetDoorTile.replaceTile
VermilionGymSetDoorTile.doorsOpen:
	LD A, $AD ; SFX_GO_INSIDE
	CALL $23B1
	LD A, $05
VermilionGymSetDoorTile.replaceTile:
	LD ($D09F), A
	LD BC, $0202
	LD A, $17 ; ReplaceTileBlock predef
	JP $3E6D

VermilionGymResetScripts:
	XOR A
	LD ($CD6B), A
	LD ($D5FE), A
	LD ($DA39), A
	RET
VermilionGymDispatchEnd:
.ASSERT VermilionGymDispatchEnd - VermilionGym_Script == 111
