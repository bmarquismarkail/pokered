	object_const_def
	const_export POKEMONTOWER2F_RIVAL
	const_export POKEMONTOWER2F_CHANNELER

PokemonTower2F_Object:
	.DB $1 ; border block

	.DB 2
	warp_event  3,  9, POKEMON_TOWER_3F, 1
	warp_event 18,  9, POKEMON_TOWER_1F, 3

	.DB 0
	.DB 2
	object_event 14,  5, SPRITE_BLUE, STAY, NONE, TEXT_POKEMONTOWER2F_RIVAL
	object_event  3,  7, SPRITE_CHANNELER, STAY, RIGHT, TEXT_POKEMONTOWER2F_CHANNELER

	event_displacement POKEMON_TOWER_2F_WIDTH, 3, 9

	event_displacement POKEMON_TOWER_2F_WIDTH, 18, 9