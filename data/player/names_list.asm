; see constants/player_constants.asm

DefaultNamesPlayerList:
		.STRINGMAP pokemon, "NEW NAME@"
DefaultNamesPlayerList._list_start_u3:
	list_start PLAYER_NAME_LENGTH - 1
.REPEAT NUM_PLAYER_NAMES START 1 INDEX n
	li PLAYERNAME{n}
.ENDR
	assert_list_length NUM_PLAYER_NAMES

DefaultNamesRivalList:
		.STRINGMAP pokemon, "NEW NAME@"
DefaultNamesRivalList._list_start_u4:
	list_start PLAYER_NAME_LENGTH - 1
.REPEAT NUM_PLAYER_NAMES START 1 INDEX n
	li RIVALNAME{n}
.ENDR
	assert_list_length NUM_PLAYER_NAMES
