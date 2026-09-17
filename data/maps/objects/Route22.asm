	object_const_def
	const_export ROUTE22_RIVAL1
	const_export ROUTE22_RIVAL2

Route22_Object:
	.DB $2c ; border block

	.DB 1
	warp_event  8,  5, ROUTE_22_GATE, 1

	.DB 1
	bg_event  7, 11, TEXT_ROUTE22_POKEMON_LEAGUE_SIGN

	.DB 2
	object_event 25,  5, SPRITE_BLUE, STAY, NONE, TEXT_ROUTE22_RIVAL1
	object_event 25,  5, SPRITE_BLUE, STAY, NONE, TEXT_ROUTE22_RIVAL2

	event_displacement ROUTE_22_WIDTH, 8, 5