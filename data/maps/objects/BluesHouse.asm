	object_const_def
	const_export BLUESHOUSE_DAISY1
	const_export BLUESHOUSE_DAISY2
	const_export BLUESHOUSE_TOWN_MAP

BluesHouse_Object:
	.DB $a ; border block

	.DB 2
	warp_event  2,  7, LAST_MAP, 2
	warp_event  3,  7, LAST_MAP, 2

	.DB 0
	.DB 3
	object_event  2,  3, SPRITE_DAISY, STAY, RIGHT, TEXT_BLUESHOUSE_DAISY_SITTING
	object_event  6,  4, SPRITE_DAISY, WALK, UP_DOWN, TEXT_BLUESHOUSE_DAISY_WALKING, 0
	object_event  3,  3, SPRITE_POKEDEX, STAY, NONE, TEXT_BLUESHOUSE_TOWN_MAP, 0

	event_displacement BLUES_HOUSE_WIDTH, 2, 7

	event_displacement BLUES_HOUSE_WIDTH, 3, 7