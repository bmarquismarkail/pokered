	object_const_def
	const_export VERMILIONOLDRODHOUSE_FISHING_GURU

VermilionOldRodHouse_Object:
	.DB $a ; border block

	.DB 2
	warp_event  2,  7, LAST_MAP, 9
	warp_event  3,  7, LAST_MAP, 9

	.DB 0
	.DB 1
	object_event  2,  4, SPRITE_FISHING_GURU, STAY, RIGHT, TEXT_VERMILIONOLDRODHOUSE_FISHING_GURU

	event_displacement VERMILION_OLD_ROD_HOUSE_WIDTH, 2, 7

	event_displacement VERMILION_OLD_ROD_HOUSE_WIDTH, 3, 7