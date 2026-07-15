.STRINGMAPTABLE pokemon "wla/pokemon.tbl"

SaffronGym_h:
.DB $16, $09, $0A
.DW $53A3
.DW $50AB
.DW $500D
.DB $00
.DW $5259
SaffronGymHeaderEnd:
.ASSERT SaffronGymHeaderEnd - SaffronGym_h == 12

SaffronGym_Script:
	LD HL, $D126
	BIT 6, (HL)
	RES 6, (HL)
	CALL NZ, SaffronGym_Script.LoadNames
	CALL $3C3C
	LD HL, $50C3
	LD DE, $5053
	LD A, ($D65C)
	CALL $3160
	LD ($D65C), A
	RET
SaffronGym_Script.LoadNames:
	LD HL, SaffronGym_Script.CityName
	LD DE, SaffronGym_Script.LeaderName
	JP $317F
SaffronGym_Script.CityName:
	.STRINGMAP pokemon, "SAFFRON CITY@"
SaffronGym_Script.LeaderName:
	.STRINGMAP pokemon, "SABRINA@"
SaffronGymResetScripts:
	XOR A
	LD ($CD6B), A
	LD ($D65C), A
	LD ($DA39), A
	RET
SaffronGymEntryEnd:
.ASSERT SaffronGymEntryEnd - SaffronGym_Script == 70

SaffronGym_ScriptPointers:
.DW $3219, $324C, $3275, $505B
SaffronGymScriptPointersEnd:
.ASSERT SaffronGymScriptPointersEnd - SaffronGym_ScriptPointers == 8
