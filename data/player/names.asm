; see constants/player_constants.asm

DefaultNamesPlayer:
		.STRINGMAP pokemon, "NEW NAME"
.REPEAT NUM_PLAYER_NAMES START 1 INDEX n
	next PLAYERNAME{n}
.ENDR
		.STRINGMAP pokemon, "@"

DefaultNamesRival:
		.STRINGMAP pokemon, "NEW NAME"
.REPEAT NUM_PLAYER_NAMES START 1 INDEX n
	next RIVALNAME{n}
.ENDR
		.STRINGMAP pokemon, "@"
