	object_const_def
	const_export POKEMONMANSION1F_SCIENTIST
	const_export POKEMONMANSION1F_ESCAPE_ROPE
	const_export POKEMONMANSION1F_CARBOS

PokemonMansion1F_Object:
	.DB $2e ; border block

	.DB 8
	warp_event  4, 27, LAST_MAP, 1
	warp_event  5, 27, LAST_MAP, 1
	warp_event  6, 27, LAST_MAP, 1
	warp_event  7, 27, LAST_MAP, 1
	warp_event  5, 10, POKEMON_MANSION_2F, 1
	warp_event 21, 23, POKEMON_MANSION_B1F, 1
	warp_event 26, 27, LAST_MAP, 1
	warp_event 27, 27, LAST_MAP, 1

	.DB 0
	.DB 3
	object_event 17, 17, SPRITE_SCIENTIST, STAY, LEFT, TEXT_POKEMONMANSION1F_SCIENTIST, OPP_SCIENTIST, 4
	object_event 14,  3, SPRITE_POKE_BALL, STAY, NONE, TEXT_POKEMONMANSION1F_ESCAPE_ROPE, ESCAPE_ROPE
	object_event 18, 21, SPRITE_POKE_BALL, STAY, NONE, TEXT_POKEMONMANSION1F_CARBOS, CARBOS

	event_displacement POKEMON_MANSION_1F_WIDTH, 4, 27

	event_displacement POKEMON_MANSION_1F_WIDTH, 5, 27

	event_displacement POKEMON_MANSION_1F_WIDTH, 6, 27

	event_displacement POKEMON_MANSION_1F_WIDTH, 7, 27

	event_displacement POKEMON_MANSION_1F_WIDTH, 5, 10

	event_displacement POKEMON_MANSION_1F_WIDTH, 21, 23

	event_displacement POKEMON_MANSION_1F_WIDTH, 26, 27

	event_displacement POKEMON_MANSION_1F_WIDTH, 27, 27