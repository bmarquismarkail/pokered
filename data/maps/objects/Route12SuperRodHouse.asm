	object_const_def
	const_export ROUTE12SUPERRODHOUSE_FISHING_GURU

Route12SuperRodHouse_Object:
	.DB $a ; border block

	.DB 2
	warp_event  2,  7, LAST_MAP, 4
	warp_event  3,  7, LAST_MAP, 4

	.DB 0
	.DB 1
	object_event  2,  4, SPRITE_FISHING_GURU, STAY, RIGHT, TEXT_ROUTE12SUPERRODHOUSE_FISHING_GURU

	event_displacement ROUTE_12_SUPER_ROD_HOUSE_WIDTH, 2, 7

	event_displacement ROUTE_12_SUPER_ROD_HOUSE_WIDTH, 3, 7