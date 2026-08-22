	object_const_def
	const_export ROUTE16FLYHOUSE_BRUNETTE_GIRL
	const_export ROUTE16FLYHOUSE_FEAROW

Route16FlyHouse_Object:
	.DB $a ; border block

	.DB 2
	warp_event  2,  7, LAST_MAP, 9
	warp_event  3,  7, LAST_MAP, 9

	.DB 0
	.DB 2
	object_event  2,  3, SPRITE_BRUNETTE_GIRL, STAY, RIGHT, TEXT_ROUTE16FLYHOUSE_BRUNETTE_GIRL
	object_event  6,  4, SPRITE_BIRD, WALK, ANY_DIR, TEXT_ROUTE16FLYHOUSE_FEAROW

	event_displacement ROUTE_16_FLY_HOUSE_WIDTH, 2, 7

	event_displacement ROUTE_16_FLY_HOUSE_WIDTH, 3, 7